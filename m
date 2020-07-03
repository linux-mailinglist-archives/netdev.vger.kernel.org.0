Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E9F2135F1
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 10:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgGCIMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 04:12:23 -0400
Received: from mx60.baidu.com ([61.135.168.60]:22206 "EHLO
        tc-sys-mailedm05.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725891AbgGCIMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 04:12:22 -0400
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm05.tc.baidu.com (Postfix) with ESMTP id 6C9431EBA001
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 16:12:06 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org
Subject: [PATCH][RFC] i40e: not flip rx buffer for copy mode xdp
Date:   Fri,  3 Jul 2020 16:12:06 +0800
Message-Id: <1593763926-24292-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

i40e_rx_buffer_flip in copy mode xdp can lead to data corruption,
like the following flow:

   1. first skb is not for xsk, and forwarded to another device
      or socket queue
   2. seconds skb is for xsk, copy data to xsk memory, and page
      of skb->data is released
   3. rx_buff is reusable since only first skb is in it, but
      i40e_rx_buffer_flip will make that page_offset is set to
      first skb data
   4. then reuse rx buffer, first skb which still is living
      will be corrupted.

so add flags in xdp struct, to report xdp's data status

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 5 ++++-
 include/net/xdp.h                           | 3 +++
 net/xdp/xsk.c                               | 4 +++-
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index b3836092c327..51fa6f86f917 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2376,6 +2376,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 
 		/* retrieve a buffer from the ring */
 		if (!skb) {
+			xdp.flags = 0;
 			xdp.data = page_address(rx_buffer->page) +
 				   rx_buffer->page_offset;
 			xdp.data_meta = xdp.data;
@@ -2394,7 +2395,9 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 
 			if (xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR)) {
 				xdp_xmit |= xdp_res;
-				i40e_rx_buffer_flip(rx_ring, rx_buffer, size);
+
+				if (!(xdp.flags & XDP_DATA_RELEASED))
+					i40e_rx_buffer_flip(rx_ring, rx_buffer, size);
 			} else {
 				rx_buffer->pagecnt_bias++;
 			}
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 609f819ed08b..6241e1efbcc7 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -47,6 +47,8 @@ enum xdp_mem_type {
 #define XDP_XMIT_FLUSH		(1U << 0)	/* doorbell signal consumer */
 #define XDP_XMIT_FLAGS_MASK	XDP_XMIT_FLUSH
 
+#define XDP_DATA_RELEASED (1U << 1)
+
 struct xdp_mem_info {
 	u32 type; /* enum xdp_mem_type, but known size type */
 	u32 id;
@@ -73,6 +75,7 @@ struct xdp_buff {
 	struct xdp_rxq_info *rxq;
 	struct xdp_txq_info *txq;
 	u32 frame_sz; /* frame size to deduce data_hard_end/reserved tailroom*/
+	u32 flags;
 };
 
 /* Reserve memory area at end-of data area.
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index b6c0f08bd80d..2c4c5c16660b 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -172,8 +172,10 @@ static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len,
 		xsk_buff_free(xsk_xdp);
 		return err;
 	}
-	if (explicit_free)
+	if (explicit_free) {
 		xdp_return_buff(xdp);
+		xdp->flags |= XDP_DATA_RELEASED;
+	}
 	return 0;
 }
 
-- 
2.16.2

