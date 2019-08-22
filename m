Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5E699011
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 11:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732334AbfHVJyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 05:54:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33762 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729797AbfHVJyq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 05:54:46 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0B27D308427C;
        Thu, 22 Aug 2019 09:54:46 +0000 (UTC)
Received: from wsfd-netdev76.ntdv.lab.eng.bos.redhat.com (wsfd-netdev76.ntdv.lab.eng.bos.redhat.com [10.19.188.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E1F6600CD;
        Thu, 22 Aug 2019 09:54:45 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andrii.nakryiko@gmail.com,
        magnus.karlsson@gmail.com
Subject: [PATCH bpf-next v5] libbpf: add xsk_ring_prod__nb_free() function
Date:   Thu, 22 Aug 2019 05:54:42 -0400
Message-Id: <86245c2d7b596f55d5ff1abeee3c3826b1b4370e.1566467579.git.echaudro@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Thu, 22 Aug 2019 09:54:46 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an AF_XDP application received X packets, it does not mean X
frames can be stuffed into the producer ring. To make it easier for
AF_XDP applications this API allows them to check how many frames can
be added into the ring.

The patch below looks like a name change only, but the xsk_prod__
prefix denotes that this API is exposed to be used by applications.

Besides, if you set the nb value to the size of the ring, you will
get the exact amount of slots available, at the cost of performance
(you touch shared state for sure). nb is there to limit the
touching of the shared state.

Also the example xdpsock application has been modified to use this
new API, so it's also able to process flows at a 1pps rate on veth
interfaces.

Signed-off-by: Eelco Chaudron <echaudro@redhat.com>

---
v4 -> v5
  - Rebase on latest bpf-next

v3 -> v4
  - Cleanedup commit message
  - Updated AF_XDP sample application to use this new API

v2 -> v3
  - Removed cache by pass option

v1 -> v2
  - Renamed xsk_ring_prod__free() to xsk_ring_prod__nb_free()
  - Add caching so it will only touch global state when needed

 samples/bpf/xdpsock_user.c | 119 ++++++++++++++++++++++++++++---------
 tools/lib/bpf/xsk.h        |   4 +-
 2 files changed, 93 insertions(+), 30 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index da84c760c094..bec0ee463184 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -470,9 +470,13 @@ static void kick_tx(struct xsk_socket_info *xsk)
 static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk,
 				     struct pollfd *fds)
 {
-	u32 idx_cq = 0, idx_fq = 0;
-	unsigned int rcvd;
+	static u64 free_frames[NUM_FRAMES];
+	static size_t nr_free_frames;
+
+	u32 idx_cq = 0, idx_fq = 0, free_slots;
+	unsigned int rcvd, i;
 	size_t ndescs;
+	int ret;
 
 	if (!xsk->outstanding_tx)
 		return;
@@ -485,29 +489,56 @@ static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk,
 
 	/* re-add completed Tx buffers */
 	rcvd = xsk_ring_cons__peek(&xsk->umem->cq, ndescs, &idx_cq);
-	if (rcvd > 0) {
-		unsigned int i;
-		int ret;
-
-		ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
-		while (ret != rcvd) {
-			if (ret < 0)
-				exit_with_error(-ret);
-			if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq))
-				ret = poll(fds, num_socks, opt_timeout);
-			ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd,
-						     &idx_fq);
-		}
-		for (i = 0; i < rcvd; i++)
+	if (!rcvd)
+		return;
+
+	/* When xsk_ring_cons__peek() for example returns that 5 packets
+	 * have been received, it does not automatically mean that
+	 * xsk_ring_prod__reserve() will have 5 slots available. You will
+	 * see this, for example, when using a veth interface due to the
+	 * RX_BATCH_SIZE used by the generic driver.
+	 *
+	 * In this example we store unused buffers and try to re-stock
+	 * them the next iteration.
+	 */
+
+	free_slots = xsk_prod__nb_free(&xsk->umem->fq, rcvd + nr_free_frames);
+	if (free_slots > rcvd + nr_free_frames)
+		free_slots = rcvd + nr_free_frames;
+
+	ret = xsk_ring_prod__reserve(&xsk->umem->fq, free_slots, &idx_fq);
+	while (ret != free_slots) {
+		if (ret < 0)
+			exit_with_error(-ret);
+
+		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq))
+			ret = poll(fds, num_socks, opt_timeout);
+
+		ret = xsk_ring_prod__reserve(&xsk->umem->fq, free_slots,
+					     &idx_fq);
+	}
+	for (i = 0; i < rcvd; i++) {
+		u64 addr = *xsk_ring_cons__comp_addr(&xsk->umem->cq, idx_cq++);
+
+		if (i < free_slots)
 			*xsk_ring_prod__fill_addr(&xsk->umem->fq, idx_fq++) =
-				*xsk_ring_cons__comp_addr(&xsk->umem->cq,
-							  idx_cq++);
+				addr;
+		else
+			free_frames[nr_free_frames++] = addr;
+	}
 
-		xsk_ring_prod__submit(&xsk->umem->fq, rcvd);
-		xsk_ring_cons__release(&xsk->umem->cq, rcvd);
-		xsk->outstanding_tx -= rcvd;
-		xsk->tx_npkts += rcvd;
+	if (free_slots > rcvd) {
+		for (i = 0; i < (free_slots - rcvd); i++) {
+			u64 addr = free_frames[--nr_free_frames];
+			*xsk_ring_prod__fill_addr(&xsk->umem->fq, idx_fq++) =
+				addr;
+		}
 	}
+
+	xsk_ring_prod__submit(&xsk->umem->fq, free_slots);
+	xsk_ring_cons__release(&xsk->umem->cq, rcvd);
+	xsk->outstanding_tx -= rcvd;
+	xsk->tx_npkts += rcvd;
 }
 
 static inline void complete_tx_only(struct xsk_socket_info *xsk)
@@ -531,8 +562,11 @@ static inline void complete_tx_only(struct xsk_socket_info *xsk)
 
 static void rx_drop(struct xsk_socket_info *xsk, struct pollfd *fds)
 {
+	static u64 free_frames[NUM_FRAMES];
+	static size_t nr_free_frames;
+
 	unsigned int rcvd, i;
-	u32 idx_rx = 0, idx_fq = 0;
+	u32 idx_rx = 0, idx_fq = 0, free_slots;
 	int ret;
 
 	rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
@@ -542,13 +576,30 @@ static void rx_drop(struct xsk_socket_info *xsk, struct pollfd *fds)
 		return;
 	}
 
-	ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
-	while (ret != rcvd) {
+	/* When xsk_ring_cons__peek() for example returns that 5 packets
+	 * have been received, it does not automatically mean that
+	 * xsk_ring_prod__reserve() will have 5 slots available. You will
+	 * see this, for example, when using a veth interface due to the
+	 * RX_BATCH_SIZE used by the generic driver.
+	 *
+	 * In this example we store unused buffers and try to re-stock
+	 * them the next iteration.
+	 */
+
+	free_slots = xsk_prod__nb_free(&xsk->umem->fq, rcvd + nr_free_frames);
+	if (free_slots > rcvd + nr_free_frames)
+		free_slots = rcvd + nr_free_frames;
+
+	ret = xsk_ring_prod__reserve(&xsk->umem->fq, free_slots, &idx_fq);
+	while (ret != free_slots) {
 		if (ret < 0)
 			exit_with_error(-ret);
+
 		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq))
 			ret = poll(fds, num_socks, opt_timeout);
-		ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
+
+		ret = xsk_ring_prod__reserve(&xsk->umem->fq, free_slots,
+					     &idx_fq);
 	}
 
 	for (i = 0; i < rcvd; i++) {
@@ -557,10 +608,22 @@ static void rx_drop(struct xsk_socket_info *xsk, struct pollfd *fds)
 		char *pkt = xsk_umem__get_data(xsk->umem->buffer, addr);
 
 		hex_dump(pkt, len, addr);
-		*xsk_ring_prod__fill_addr(&xsk->umem->fq, idx_fq++) = addr;
+		if (i < free_slots)
+			*xsk_ring_prod__fill_addr(&xsk->umem->fq, idx_fq++) =
+				addr;
+		else
+			free_frames[nr_free_frames++] = addr;
+	}
+
+	if (free_slots > rcvd) {
+		for (i = 0; i < (free_slots - rcvd); i++) {
+			u64 addr = free_frames[--nr_free_frames];
+			*xsk_ring_prod__fill_addr(&xsk->umem->fq, idx_fq++) =
+				addr;
+		}
 	}
 
-	xsk_ring_prod__submit(&xsk->umem->fq, rcvd);
+	xsk_ring_prod__submit(&xsk->umem->fq, free_slots);
 	xsk_ring_cons__release(&xsk->rx, rcvd);
 	xsk->rx_npkts += rcvd;
 }
diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
index aa1d6122b7db..520a772c882c 100644
--- a/tools/lib/bpf/xsk.h
+++ b/tools/lib/bpf/xsk.h
@@ -82,7 +82,7 @@ static inline int xsk_ring_prod__needs_wakeup(const struct xsk_ring_prod *r)
 	return *r->flags & XDP_RING_NEED_WAKEUP;
 }
 
-static inline __u32 xsk_prod_nb_free(struct xsk_ring_prod *r, __u32 nb)
+static inline __u32 xsk_prod__nb_free(struct xsk_ring_prod *r, __u32 nb)
 {
 	__u32 free_entries = r->cached_cons - r->cached_prod;
 
@@ -116,7 +116,7 @@ static inline __u32 xsk_cons_nb_avail(struct xsk_ring_cons *r, __u32 nb)
 static inline size_t xsk_ring_prod__reserve(struct xsk_ring_prod *prod,
 					    size_t nb, __u32 *idx)
 {
-	if (xsk_prod_nb_free(prod, nb) < nb)
+	if (xsk_prod__nb_free(prod, nb) < nb)
 		return 0;
 
 	*idx = prod->cached_prod;
-- 
2.18.1

