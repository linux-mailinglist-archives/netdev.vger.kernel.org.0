Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE23281499
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 16:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388019AbgJBOCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 10:02:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:44231 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388004AbgJBOCL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 10:02:11 -0400
IronPort-SDR: AzUJji7MV9bmLl+DhfnJWeqFJbqhiFXgYsvqvji2ifw16JgEr+1gsVHoermfUjRzNDyWP4sBlj
 Vxg/6YllGtKA==
X-IronPort-AV: E=McAfee;i="6000,8403,9761"; a="181119389"
X-IronPort-AV: E=Sophos;i="5.77,327,1596524400"; 
   d="scan'208";a="181119389"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2020 07:01:57 -0700
IronPort-SDR: OTuIomqKahVpiDoZaSe4NkrZndgyYAl865ruUDe1hq79n+zsHlJEuzMHD7KUN7Zf8lAVW2yhLn
 byFy2D88ax/g==
X-IronPort-AV: E=Sophos;i="5.77,327,1596524400"; 
   d="scan'208";a="508762506"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2020 07:01:56 -0700
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf-next 1/3] samples: bpf: split xdpsock stats into new struct
Date:   Fri,  2 Oct 2020 13:36:10 +0000
Message-Id: <20201002133612.31536-1-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

New statistics will be added in future commits. In preparation for this,
let's split out the existing statistics into their own struct.

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 samples/bpf/xdpsock_user.c | 123 +++++++++++++++++++++----------------
 1 file changed, 69 insertions(+), 54 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index b220173dbe1e..4c5022e6479e 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -91,18 +91,7 @@ static bool opt_need_wakeup = true;
 static u32 opt_num_xsks = 1;
 static u32 prog_id;
 
-struct xsk_umem_info {
-	struct xsk_ring_prod fq;
-	struct xsk_ring_cons cq;
-	struct xsk_umem *umem;
-	void *buffer;
-};
-
-struct xsk_socket_info {
-	struct xsk_ring_cons rx;
-	struct xsk_ring_prod tx;
-	struct xsk_umem_info *umem;
-	struct xsk_socket *xsk;
+struct xsk_ring_stats {
 	unsigned long rx_npkts;
 	unsigned long tx_npkts;
 	unsigned long rx_dropped_npkts;
@@ -119,6 +108,21 @@ struct xsk_socket_info {
 	unsigned long prev_rx_full_npkts;
 	unsigned long prev_rx_fill_empty_npkts;
 	unsigned long prev_tx_empty_npkts;
+};
+
+struct xsk_umem_info {
+	struct xsk_ring_prod fq;
+	struct xsk_ring_cons cq;
+	struct xsk_umem *umem;
+	void *buffer;
+};
+
+struct xsk_socket_info {
+	struct xsk_ring_cons rx;
+	struct xsk_ring_prod tx;
+	struct xsk_umem_info *umem;
+	struct xsk_socket *xsk;
+	struct xsk_ring_stats ring_stats;
 	u32 outstanding_tx;
 };
 
@@ -173,12 +177,12 @@ static int xsk_get_xdp_stats(int fd, struct xsk_socket_info *xsk)
 		return err;
 
 	if (optlen == sizeof(struct xdp_statistics)) {
-		xsk->rx_dropped_npkts = stats.rx_dropped;
-		xsk->rx_invalid_npkts = stats.rx_invalid_descs;
-		xsk->tx_invalid_npkts = stats.tx_invalid_descs;
-		xsk->rx_full_npkts = stats.rx_ring_full;
-		xsk->rx_fill_empty_npkts = stats.rx_fill_ring_empty_descs;
-		xsk->tx_empty_npkts = stats.tx_ring_empty_descs;
+		xsk->ring_stats.rx_dropped_npkts = stats.rx_dropped;
+		xsk->ring_stats.rx_invalid_npkts = stats.rx_invalid_descs;
+		xsk->ring_stats.tx_invalid_npkts = stats.tx_invalid_descs;
+		xsk->ring_stats.rx_full_npkts = stats.rx_ring_full;
+		xsk->ring_stats.rx_fill_empty_npkts = stats.rx_fill_ring_empty_descs;
+		xsk->ring_stats.tx_empty_npkts = stats.tx_ring_empty_descs;
 		return 0;
 	}
 
@@ -198,9 +202,9 @@ static void dump_stats(void)
 		double rx_pps, tx_pps, dropped_pps, rx_invalid_pps, full_pps, fill_empty_pps,
 			tx_invalid_pps, tx_empty_pps;
 
-		rx_pps = (xsks[i]->rx_npkts - xsks[i]->prev_rx_npkts) *
+		rx_pps = (xsks[i]->ring_stats.rx_npkts - xsks[i]->ring_stats.prev_rx_npkts) *
 			 1000000000. / dt;
-		tx_pps = (xsks[i]->tx_npkts - xsks[i]->prev_tx_npkts) *
+		tx_pps = (xsks[i]->ring_stats.tx_npkts - xsks[i]->ring_stats.prev_tx_npkts) *
 			 1000000000. / dt;
 
 		printf("\n sock%d@", i);
@@ -209,47 +213,58 @@ static void dump_stats(void)
 
 		printf("%-15s %-11s %-11s %-11.2f\n", "", "pps", "pkts",
 		       dt / 1000000000.);
-		printf(fmt, "rx", rx_pps, xsks[i]->rx_npkts);
-		printf(fmt, "tx", tx_pps, xsks[i]->tx_npkts);
+		printf(fmt, "rx", rx_pps, xsks[i]->ring_stats.rx_npkts);
+		printf(fmt, "tx", tx_pps, xsks[i]->ring_stats.tx_npkts);
 
-		xsks[i]->prev_rx_npkts = xsks[i]->rx_npkts;
-		xsks[i]->prev_tx_npkts = xsks[i]->tx_npkts;
+		xsks[i]->ring_stats.prev_rx_npkts = xsks[i]->ring_stats.rx_npkts;
+		xsks[i]->ring_stats.prev_tx_npkts = xsks[i]->ring_stats.tx_npkts;
 
 		if (opt_extra_stats) {
 			if (!xsk_get_xdp_stats(xsk_socket__fd(xsks[i]->xsk), xsks[i])) {
-				dropped_pps = (xsks[i]->rx_dropped_npkts -
-						xsks[i]->prev_rx_dropped_npkts) * 1000000000. / dt;
-				rx_invalid_pps = (xsks[i]->rx_invalid_npkts -
-						xsks[i]->prev_rx_invalid_npkts) * 1000000000. / dt;
-				tx_invalid_pps = (xsks[i]->tx_invalid_npkts -
-						xsks[i]->prev_tx_invalid_npkts) * 1000000000. / dt;
-				full_pps = (xsks[i]->rx_full_npkts -
-						xsks[i]->prev_rx_full_npkts) * 1000000000. / dt;
-				fill_empty_pps = (xsks[i]->rx_fill_empty_npkts -
-						xsks[i]->prev_rx_fill_empty_npkts)
-						* 1000000000. / dt;
-				tx_empty_pps = (xsks[i]->tx_empty_npkts -
-						xsks[i]->prev_tx_empty_npkts) * 1000000000. / dt;
+				dropped_pps = (xsks[i]->ring_stats.rx_dropped_npkts -
+						xsks[i]->ring_stats.prev_rx_dropped_npkts) *
+							1000000000. / dt;
+				rx_invalid_pps = (xsks[i]->ring_stats.rx_invalid_npkts -
+						xsks[i]->ring_stats.prev_rx_invalid_npkts) *
+							1000000000. / dt;
+				tx_invalid_pps = (xsks[i]->ring_stats.tx_invalid_npkts -
+						xsks[i]->ring_stats.prev_tx_invalid_npkts) *
+							1000000000. / dt;
+				full_pps = (xsks[i]->ring_stats.rx_full_npkts -
+						xsks[i]->ring_stats.prev_rx_full_npkts) *
+							1000000000. / dt;
+				fill_empty_pps = (xsks[i]->ring_stats.rx_fill_empty_npkts -
+						xsks[i]->ring_stats.prev_rx_fill_empty_npkts) *
+							1000000000. / dt;
+				tx_empty_pps = (xsks[i]->ring_stats.tx_empty_npkts -
+						xsks[i]->ring_stats.prev_tx_empty_npkts) *
+							1000000000. / dt;
 
 				printf(fmt, "rx dropped", dropped_pps,
-				       xsks[i]->rx_dropped_npkts);
+				       xsks[i]->ring_stats.rx_dropped_npkts);
 				printf(fmt, "rx invalid", rx_invalid_pps,
-				       xsks[i]->rx_invalid_npkts);
+				       xsks[i]->ring_stats.rx_invalid_npkts);
 				printf(fmt, "tx invalid", tx_invalid_pps,
-				       xsks[i]->tx_invalid_npkts);
+				       xsks[i]->ring_stats.tx_invalid_npkts);
 				printf(fmt, "rx queue full", full_pps,
-				       xsks[i]->rx_full_npkts);
+				       xsks[i]->ring_stats.rx_full_npkts);
 				printf(fmt, "fill ring empty", fill_empty_pps,
-				       xsks[i]->rx_fill_empty_npkts);
+				       xsks[i]->ring_stats.rx_fill_empty_npkts);
 				printf(fmt, "tx ring empty", tx_empty_pps,
-				       xsks[i]->tx_empty_npkts);
-
-				xsks[i]->prev_rx_dropped_npkts = xsks[i]->rx_dropped_npkts;
-				xsks[i]->prev_rx_invalid_npkts = xsks[i]->rx_invalid_npkts;
-				xsks[i]->prev_tx_invalid_npkts = xsks[i]->tx_invalid_npkts;
-				xsks[i]->prev_rx_full_npkts = xsks[i]->rx_full_npkts;
-				xsks[i]->prev_rx_fill_empty_npkts = xsks[i]->rx_fill_empty_npkts;
-				xsks[i]->prev_tx_empty_npkts = xsks[i]->tx_empty_npkts;
+				       xsks[i]->ring_stats.tx_empty_npkts);
+
+				xsks[i]->ring_stats.prev_rx_dropped_npkts =
+					xsks[i]->ring_stats.rx_dropped_npkts;
+				xsks[i]->ring_stats.prev_rx_invalid_npkts =
+					xsks[i]->ring_stats.rx_invalid_npkts;
+				xsks[i]->ring_stats.prev_tx_invalid_npkts =
+					xsks[i]->ring_stats.tx_invalid_npkts;
+				xsks[i]->ring_stats.prev_rx_full_npkts =
+					xsks[i]->ring_stats.rx_full_npkts;
+				xsks[i]->ring_stats.prev_rx_fill_empty_npkts =
+					xsks[i]->ring_stats.rx_fill_empty_npkts;
+				xsks[i]->ring_stats.prev_tx_empty_npkts =
+					xsks[i]->ring_stats.tx_empty_npkts;
 			} else {
 				printf("%-15s\n", "Error retrieving extra stats");
 			}
@@ -936,7 +951,7 @@ static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk,
 		xsk_ring_prod__submit(&xsk->umem->fq, rcvd);
 		xsk_ring_cons__release(&xsk->umem->cq, rcvd);
 		xsk->outstanding_tx -= rcvd;
-		xsk->tx_npkts += rcvd;
+		xsk->ring_stats.tx_npkts += rcvd;
 	}
 }
 
@@ -956,7 +971,7 @@ static inline void complete_tx_only(struct xsk_socket_info *xsk,
 	if (rcvd > 0) {
 		xsk_ring_cons__release(&xsk->umem->cq, rcvd);
 		xsk->outstanding_tx -= rcvd;
-		xsk->tx_npkts += rcvd;
+		xsk->ring_stats.tx_npkts += rcvd;
 	}
 }
 
@@ -996,7 +1011,7 @@ static void rx_drop(struct xsk_socket_info *xsk, struct pollfd *fds)
 
 	xsk_ring_prod__submit(&xsk->umem->fq, rcvd);
 	xsk_ring_cons__release(&xsk->rx, rcvd);
-	xsk->rx_npkts += rcvd;
+	xsk->ring_stats.rx_npkts += rcvd;
 }
 
 static void rx_drop_all(void)
@@ -1155,7 +1170,7 @@ static void l2fwd(struct xsk_socket_info *xsk, struct pollfd *fds)
 	xsk_ring_prod__submit(&xsk->tx, rcvd);
 	xsk_ring_cons__release(&xsk->rx, rcvd);
 
-	xsk->rx_npkts += rcvd;
+	xsk->ring_stats.rx_npkts += rcvd;
 	xsk->outstanding_tx += rcvd;
 }
 
-- 
2.17.1

