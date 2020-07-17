Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5682233E3
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 08:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgGQGZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 02:25:30 -0400
Received: from mx59.baidu.com ([61.135.168.59]:33155 "EHLO
        tc-sys-mailedm01.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727867AbgGQGYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 02:24:36 -0400
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm01.tc.baidu.com (Postfix) with ESMTP id 3F0572040057;
        Fri, 17 Jul 2020 14:24:22 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        magnus.karlsson@intel.com, bjorn.topel@intel.com
Subject: [PATCH 2/2] ice/xdp: not adjust rx buffer for copy mode xdp
Date:   Fri, 17 Jul 2020 14:24:22 +0800
Message-Id: <1594967062-20674-3-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1594967062-20674-1-git-send-email-lirongqing@baidu.com>
References: <1594967062-20674-1-git-send-email-lirongqing@baidu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ice_rx_buf_adjust_pg_offset in copy mode xdp can lead to data
corruption, like the following flow:

   1. first skb is not for xsk, and forwarded to another device
      or socket queue
   2. seconds skb is for xsk, copy data to xsk memory, and page
      of skb->data is released
   3. rx_buff is reusable since only first skb is in it, but
      ice_rx_buf_adjust_pg_offset will make that page_offset
      is set to first skb data
   4. then reuse rx buffer, first skb which still is living
      will be corrupted.

so adjust rx buffer page offset only when xdp data is not released

Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index abdb137c8bb7..2c58daf4d0d1 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1147,6 +1147,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 			goto construct_skb;
 		}
 
+		xdp.flags = 0;
 		xdp.data = page_address(rx_buf->page) + rx_buf->page_offset;
 		xdp.data_hard_start = xdp.data - ice_rx_offset(rx_ring);
 		xdp.data_meta = xdp.data;
@@ -1169,7 +1170,9 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 			goto construct_skb;
 		if (xdp_res & (ICE_XDP_TX | ICE_XDP_REDIR)) {
 			xdp_xmit |= xdp_res;
-			ice_rx_buf_adjust_pg_offset(rx_buf, xdp.frame_sz);
+
+			if (!(xdp.flags & XDP_DATA_RELEASED))
+				ice_rx_buf_adjust_pg_offset(rx_buf, xdp.frame_sz);
 		} else {
 			rx_buf->pagecnt_bias++;
 		}
-- 
2.16.2

