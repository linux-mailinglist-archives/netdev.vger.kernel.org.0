Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 020538D564
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 15:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbfHNNv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 09:51:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46090 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726551AbfHNNv2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 09:51:28 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1DF2D306731B;
        Wed, 14 Aug 2019 13:51:27 +0000 (UTC)
Received: from wsfd-netdev76.ntdv.lab.eng.bos.redhat.com (wsfd-netdev76.ntdv.lab.eng.bos.redhat.com [10.19.188.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4377260BE1;
        Wed, 14 Aug 2019 13:51:26 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andrii.nakryiko@gmail.com,
        magnus.karlsson@gmail.com
Subject: [PATCH bpf-next v4] libbpf: add xsk_ring_prod__nb_free() function
Date:   Wed, 14 Aug 2019 09:51:23 -0400
Message-Id: <d1773613833e2824f95c3adbe46bff757280c16e.1565790591.git.echaudro@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Wed, 14 Aug 2019 13:51:27 +0000 (UTC)
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

v3 -> v4
  - Cleanedup commit message
  - Updated AF_XDP sample application to use this new API

v2 -> v3
  - Removed cache by pass option

v1 -> v2
  - Renamed xsk_ring_prod__free() to xsk_ring_prod__nb_free()
  - Add caching so it will only touch global state when needed

 samples/bpf/xdpsock_user.c | 109 ++++++++++++++++++++++++++++---------
 tools/lib/bpf/xsk.h        |   4 +-
 2 files changed, 86 insertions(+), 27 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 93eaaf7239b2..87115e233b54 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -461,9 +461,13 @@ static void kick_tx(struct xsk_socket_info *xsk)
 
 static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk)
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
@@ -474,27 +478,52 @@ static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk)
 
 	/* re-add completed Tx buffers */
 	rcvd = xsk_ring_cons__peek(&xsk->umem->cq, ndescs, &idx_cq);
-	if (rcvd > 0) {
-		unsigned int i;
-		int ret;
+	if (!rcvd)
+		return;
 
-		ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
-		while (ret != rcvd) {
-			if (ret < 0)
-				exit_with_error(-ret);
-			ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd,
-						     &idx_fq);
-		}
-		for (i = 0; i < rcvd; i++)
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
@@ -517,19 +546,37 @@ static inline void complete_tx_only(struct xsk_socket_info *xsk)
 
 static void rx_drop(struct xsk_socket_info *xsk)
 {
+	static u64 free_frames[NUM_FRAMES];
+	static size_t nr_free_frames;
+
 	unsigned int rcvd, i;
-	u32 idx_rx = 0, idx_fq = 0;
+	u32 idx_rx = 0, idx_fq = 0, free_slots;
 	int ret;
 
 	rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
 	if (!rcvd)
 		return;
 
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
-		ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
+		ret = xsk_ring_prod__reserve(&xsk->umem->fq, free_slots,
+					     &idx_fq);
 	}
 
 	for (i = 0; i < rcvd; i++) {
@@ -538,10 +585,22 @@ static void rx_drop(struct xsk_socket_info *xsk)
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
index 833a6e60d065..cae506ab3f3c 100644
--- a/tools/lib/bpf/xsk.h
+++ b/tools/lib/bpf/xsk.h
@@ -76,7 +76,7 @@ xsk_ring_cons__rx_desc(const struct xsk_ring_cons *rx, __u32 idx)
 	return &descs[idx & rx->mask];
 }
 
-static inline __u32 xsk_prod_nb_free(struct xsk_ring_prod *r, __u32 nb)
+static inline __u32 xsk_prod__nb_free(struct xsk_ring_prod *r, __u32 nb)
 {
 	__u32 free_entries = r->cached_cons - r->cached_prod;
 
@@ -110,7 +110,7 @@ static inline __u32 xsk_cons_nb_avail(struct xsk_ring_cons *r, __u32 nb)
 static inline size_t xsk_ring_prod__reserve(struct xsk_ring_prod *prod,
 					    size_t nb, __u32 *idx)
 {
-	if (xsk_prod_nb_free(prod, nb) < nb)
+	if (xsk_prod__nb_free(prod, nb) < nb)
 		return 0;
 
 	*idx = prod->cached_prod;
-- 
2.18.1

