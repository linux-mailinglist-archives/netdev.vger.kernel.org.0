Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30479CF6F4
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 12:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730408AbfJHKXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 06:23:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:22769 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730051AbfJHKXf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 06:23:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 03:23:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,270,1566889200"; 
   d="scan'208";a="345001950"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO VM.isw.intel.com) ([10.103.211.41])
  by orsmga004.jf.intel.com with ESMTP; 08 Oct 2019 03:23:31 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf] libbpf: fix compatibility for kernels without need_wakeup
Date:   Tue,  8 Oct 2019 12:23:28 +0200
Message-Id: <1570530208-17720-1-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the need_wakeup flag was added to AF_XDP, the format of the
XDP_MMAP_OFFSETS getsockopt was extended. Code was added to the kernel
to take care of compatibility issues arrising from running
applications using any of the two formats. However, libbpf was not
extended to take care of the case when the application/libbpf uses the
new format but the kernel only supports the old format. This patch
adds support in libbpf for parsing the old format, before the
need_wakeup flag was added, and emulating a set of static need_wakeup
flags that will always work for the application.

Fixes: a4500432c2587cb2a ("libbpf: add support for need_wakeup flag in AF_XDP part")
Reported-by: Eloy Degen <degeneloy@gmail.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/lib/bpf/xsk.c | 109 +++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 78 insertions(+), 31 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index a902838..46f9687 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -44,6 +44,25 @@
  #define PF_XDP AF_XDP
 #endif
 
+#define is_mmap_offsets_v1(optlen) \
+	((optlen) == sizeof(struct xdp_mmap_offsets_v1))
+
+#define get_prod_off(ring) \
+	(is_mmap_offsets_v1(optlen) ? \
+	 ((struct xdp_mmap_offsets_v1 *)&off)->ring.producer : \
+	 off.ring.producer)
+#define get_cons_off(ring) \
+	(is_mmap_offsets_v1(optlen) ? \
+	 ((struct xdp_mmap_offsets_v1 *)&off)->ring.consumer : \
+	 off.ring.consumer)
+#define get_desc_off(ring) \
+	(is_mmap_offsets_v1(optlen) ? \
+	 ((struct xdp_mmap_offsets_v1 *)&off)->ring.desc : off.ring.desc)
+#define get_flags_off(ring) \
+	(is_mmap_offsets_v1(optlen) ? \
+	 ((struct xdp_mmap_offsets_v1 *)&off)->ring.consumer + sizeof(u32) : \
+	 off.ring.flags)
+
 struct xsk_umem {
 	struct xsk_ring_prod *fill;
 	struct xsk_ring_cons *comp;
@@ -73,6 +92,20 @@ struct xsk_nl_info {
 	int fd;
 };
 
+struct xdp_ring_offset_v1 {
+	__u64 producer;
+	__u64 consumer;
+	__u64 desc;
+};
+
+/* Up until and including Linux 5.3 */
+struct xdp_mmap_offsets_v1 {
+	struct xdp_ring_offset_v1 rx;
+	struct xdp_ring_offset_v1 tx;
+	struct xdp_ring_offset_v1 fr;
+	struct xdp_ring_offset_v1 cr;
+};
+
 int xsk_umem__fd(const struct xsk_umem *umem)
 {
 	return umem ? umem->fd : -EINVAL;
@@ -196,7 +229,8 @@ int xsk_umem__create_v0_0_4(struct xsk_umem **umem_ptr, void *umem_area,
 		goto out_socket;
 	}
 
-	map = mmap(NULL, off.fr.desc + umem->config.fill_size * sizeof(__u64),
+	map = mmap(NULL, get_desc_off(fr) +
+		   umem->config.fill_size * sizeof(__u64),
 		   PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, umem->fd,
 		   XDP_UMEM_PGOFF_FILL_RING);
 	if (map == MAP_FAILED) {
@@ -207,13 +241,18 @@ int xsk_umem__create_v0_0_4(struct xsk_umem **umem_ptr, void *umem_area,
 	umem->fill = fill;
 	fill->mask = umem->config.fill_size - 1;
 	fill->size = umem->config.fill_size;
-	fill->producer = map + off.fr.producer;
-	fill->consumer = map + off.fr.consumer;
-	fill->flags = map + off.fr.flags;
-	fill->ring = map + off.fr.desc;
+	fill->producer = map + get_prod_off(fr);
+	fill->consumer = map + get_cons_off(fr);
+	fill->flags = map + get_flags_off(fr);
+	fill->ring = map + get_desc_off(fr);
 	fill->cached_cons = umem->config.fill_size;
 
-	map = mmap(NULL, off.cr.desc + umem->config.comp_size * sizeof(__u64),
+	if (is_mmap_offsets_v1(optlen))
+		/* Initialized the flag to never signal wakeup */
+		*fill->flags = 0;
+
+	map = mmap(NULL, get_desc_off(cr) +
+		   umem->config.comp_size * sizeof(__u64),
 		   PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, umem->fd,
 		   XDP_UMEM_PGOFF_COMPLETION_RING);
 	if (map == MAP_FAILED) {
@@ -224,16 +263,16 @@ int xsk_umem__create_v0_0_4(struct xsk_umem **umem_ptr, void *umem_area,
 	umem->comp = comp;
 	comp->mask = umem->config.comp_size - 1;
 	comp->size = umem->config.comp_size;
-	comp->producer = map + off.cr.producer;
-	comp->consumer = map + off.cr.consumer;
-	comp->flags = map + off.cr.flags;
-	comp->ring = map + off.cr.desc;
+	comp->producer = map + get_prod_off(cr);
+	comp->consumer = map + get_cons_off(cr);
+	comp->flags = map + get_flags_off(cr);
+	comp->ring = map + get_desc_off(cr);
 
 	*umem_ptr = umem;
 	return 0;
 
 out_mmap:
-	munmap(map, off.fr.desc + umem->config.fill_size * sizeof(__u64));
+	munmap(map, get_desc_off(fr) + umem->config.fill_size * sizeof(__u64));
 out_socket:
 	close(umem->fd);
 out_umem_alloc:
@@ -558,7 +597,7 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 	}
 
 	if (rx) {
-		rx_map = mmap(NULL, off.rx.desc +
+		rx_map = mmap(NULL, get_desc_off(rx) +
 			      xsk->config.rx_size * sizeof(struct xdp_desc),
 			      PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE,
 			      xsk->fd, XDP_PGOFF_RX_RING);
@@ -569,15 +608,15 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 
 		rx->mask = xsk->config.rx_size - 1;
 		rx->size = xsk->config.rx_size;
-		rx->producer = rx_map + off.rx.producer;
-		rx->consumer = rx_map + off.rx.consumer;
-		rx->flags = rx_map + off.rx.flags;
-		rx->ring = rx_map + off.rx.desc;
+		rx->producer = rx_map + get_prod_off(rx);
+		rx->consumer = rx_map + get_cons_off(rx);
+		rx->flags = rx_map + get_flags_off(rx);
+		rx->ring = rx_map + get_desc_off(rx);
 	}
 	xsk->rx = rx;
 
 	if (tx) {
-		tx_map = mmap(NULL, off.tx.desc +
+		tx_map = mmap(NULL, get_desc_off(tx) +
 			      xsk->config.tx_size * sizeof(struct xdp_desc),
 			      PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE,
 			      xsk->fd, XDP_PGOFF_TX_RING);
@@ -588,11 +627,15 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 
 		tx->mask = xsk->config.tx_size - 1;
 		tx->size = xsk->config.tx_size;
-		tx->producer = tx_map + off.tx.producer;
-		tx->consumer = tx_map + off.tx.consumer;
-		tx->flags = tx_map + off.tx.flags;
-		tx->ring = tx_map + off.tx.desc;
+		tx->producer = tx_map + get_prod_off(tx);
+		tx->consumer = tx_map + get_cons_off(tx);
+		tx->flags = tx_map + get_flags_off(tx);
+		tx->ring = tx_map + get_desc_off(tx);
 		tx->cached_cons = xsk->config.tx_size;
+
+		if (is_mmap_offsets_v1(optlen))
+			/* Initialized the flag to always signal wakeup */
+			*tx->flags = XDP_RING_NEED_WAKEUP;
 	}
 	xsk->tx = tx;
 
@@ -620,11 +663,11 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 
 out_mmap_tx:
 	if (tx)
-		munmap(tx_map, off.tx.desc +
+		munmap(tx_map, get_desc_off(tx) +
 		       xsk->config.tx_size * sizeof(struct xdp_desc));
 out_mmap_rx:
 	if (rx)
-		munmap(rx_map, off.rx.desc +
+		munmap(rx_map, get_desc_off(rx) +
 		       xsk->config.rx_size * sizeof(struct xdp_desc));
 out_socket:
 	if (--umem->refcount)
@@ -649,10 +692,12 @@ int xsk_umem__delete(struct xsk_umem *umem)
 	optlen = sizeof(off);
 	err = getsockopt(umem->fd, SOL_XDP, XDP_MMAP_OFFSETS, &off, &optlen);
 	if (!err) {
-		munmap(umem->fill->ring - off.fr.desc,
-		       off.fr.desc + umem->config.fill_size * sizeof(__u64));
-		munmap(umem->comp->ring - off.cr.desc,
-		       off.cr.desc + umem->config.comp_size * sizeof(__u64));
+		munmap(umem->fill->ring - get_desc_off(fr),
+		       get_desc_off(fr) +
+		       umem->config.fill_size * sizeof(__u64));
+		munmap(umem->comp->ring - get_desc_off(cr),
+		       get_desc_off(cr) +
+		       umem->config.comp_size * sizeof(__u64));
 	}
 
 	close(umem->fd);
@@ -680,12 +725,14 @@ void xsk_socket__delete(struct xsk_socket *xsk)
 	err = getsockopt(xsk->fd, SOL_XDP, XDP_MMAP_OFFSETS, &off, &optlen);
 	if (!err) {
 		if (xsk->rx) {
-			munmap(xsk->rx->ring - off.rx.desc,
-			       off.rx.desc + xsk->config.rx_size * desc_sz);
+			munmap(xsk->rx->ring - get_desc_off(rx),
+			       get_desc_off(rx) +
+			       xsk->config.rx_size * desc_sz);
 		}
 		if (xsk->tx) {
-			munmap(xsk->tx->ring - off.tx.desc,
-			       off.tx.desc + xsk->config.tx_size * desc_sz);
+			munmap(xsk->tx->ring - get_desc_off(tx),
+			       get_desc_off(tx) +
+			       xsk->config.tx_size * desc_sz);
 		}
 
 	}
-- 
2.7.4

