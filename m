Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D04C22C2AD
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 11:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgGXJ6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 05:58:14 -0400
Received: from mx56.baidu.com ([61.135.168.56]:52016 "EHLO
        tc-sys-mailedm02.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726114AbgGXJ6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 05:58:14 -0400
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm02.tc.baidu.com (Postfix) with ESMTP id A624F11C0059;
        Fri, 24 Jul 2020 17:57:59 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        magnus.karlsson@intel.com
Subject: [PATCH 1/2] xdp/i40e/ixgbe: not flip rx buffer for copy mode xdp
Date:   Fri, 24 Jul 2020 17:57:58 +0800
Message-Id: <1595584679-30652-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

i40e/ixgbe_rx_buffer_flip in copy mode xdp can lead to data
corruption, like the following flow:

   1. first skb is not for xsk, and forwarded to another device
      or socket queue
   2. seconds skb is for xsk, copy data to xsk memory, and page
      of skb->data is released
   3. rx_buff is reusable since only first skb is in it, but
      *_rx_buffer_flip will make that page_offset is set to
      first skb data
   4. then reuse rx buffer, first skb which still is living
      will be corrupted.

so not flip rx buffer for copy mode xdp

Fixes: c497176cb2e4 ("xsk: add Rx receive functions and poll support")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Dongsheng Rong <rongdongsheng@baidu.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  5 ++++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  5 ++++-
 include/linux/filter.h                        | 11 +++++++++++
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index b3836092c327..a8cea62fdbf5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2394,7 +2394,10 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 
 			if (xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR)) {
 				xdp_xmit |= xdp_res;
-				i40e_rx_buffer_flip(rx_ring, rx_buffer, size);
+
+				if (xdp.rxq->mem.type == MEM_TYPE_XSK_BUFF_POOL ||
+				    xdp_get_map_type_no_direct() != BPF_MAP_TYPE_XSKMAP)
+					i40e_rx_buffer_flip(rx_ring, rx_buffer, size);
 			} else {
 				rx_buffer->pagecnt_bias++;
 			}
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index a8bf941c5c29..e5607ad7ac4f 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -2351,7 +2351,10 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 
 			if (xdp_res & (IXGBE_XDP_TX | IXGBE_XDP_REDIR)) {
 				xdp_xmit |= xdp_res;
-				ixgbe_rx_buffer_flip(rx_ring, rx_buffer, size);
+
+				if (xdp.rxq->mem.type == MEM_TYPE_XSK_BUFF_POOL ||
+				    xdp_get_map_type_no_direct() != BPF_MAP_TYPE_XSKMAP)
+					ixgbe_rx_buffer_flip(rx_ring, rx_buffer, size);
 			} else {
 				rx_buffer->pagecnt_bias++;
 			}
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 259377723603..3b3103814693 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -919,6 +919,17 @@ static inline void xdp_clear_return_frame_no_direct(void)
 	ri->kern_flags &= ~BPF_RI_F_RF_NO_DIRECT;
 }
 
+static inline enum bpf_map_type xdp_get_map_type_no_direct(void)
+{
+	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+	struct bpf_map *map = READ_ONCE(ri->map);
+
+	if (map)
+		return map->map_type;
+	else
+		return BPF_MAP_TYPE_UNSPEC;
+}
+
 static inline int xdp_ok_fwd_dev(const struct net_device *fwd,
 				 unsigned int pktlen)
 {
-- 
2.16.2

