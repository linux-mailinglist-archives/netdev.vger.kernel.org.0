Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4E7310AC62
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 10:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbfK0JE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 04:04:59 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:52248 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726112AbfK0JE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 04:04:58 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R731e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=cambda@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0TjDNUDL_1574845494;
Received: from localhost(mailfrom:cambda@linux.alibaba.com fp:SMTPD_---0TjDNUDL_1574845494)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 27 Nov 2019 17:04:55 +0800
From:   Cambda Zhu <cambda@linux.alibaba.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Radoslaw Tyl <radoslawx.tyl@intel.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Cambda Zhu <cambda@linux.alibaba.com>
Subject: [PATCH] ixgbe: Fix calculation of queue with VFs and flow director on interface flap
Date:   Wed, 27 Nov 2019 17:03:55 +0800
Message-Id: <20191127090355.27708-1-cambda@linux.alibaba.com>
X-Mailer: git-send-email 2.16.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the calculation of queue when we restore flow director
filters after resetting adapter. In ixgbe_fdir_filter_restore(), filter's
vf may be zero which makes the queue outside of the rx_ring array.

The calculation is changed to the same as ixgbe_add_ethtool_fdir_entry().

Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 37 +++++++++++++++++++--------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 25c097cd8100..6d5be31cc9cb 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -5239,7 +5239,7 @@ static void ixgbe_fdir_filter_restore(struct ixgbe_adapter *adapter)
 	struct ixgbe_hw *hw = &adapter->hw;
 	struct hlist_node *node2;
 	struct ixgbe_fdir_filter *filter;
-	u64 action;
+	u8 queue;
 
 	spin_lock(&adapter->fdir_perfect_lock);
 
@@ -5248,17 +5248,34 @@ static void ixgbe_fdir_filter_restore(struct ixgbe_adapter *adapter)
 
 	hlist_for_each_entry_safe(filter, node2,
 				  &adapter->fdir_filter_list, fdir_node) {
-		action = filter->action;
-		if (action != IXGBE_FDIR_DROP_QUEUE && action != 0)
-			action =
-			(action >> ETHTOOL_RX_FLOW_SPEC_RING_VF_OFF) - 1;
+		if (filter->action == IXGBE_FDIR_DROP_QUEUE) {
+			queue = IXGBE_FDIR_DROP_QUEUE;
+		} else {
+			u32 ring = ethtool_get_flow_spec_ring(filter->action);
+			u8 vf = ethtool_get_flow_spec_ring_vf(filter->action);
+
+			if (!vf && (ring >= adapter->num_rx_queues)) {
+				e_err(drv, "FDIR restore failed without VF, "
+				      "ring: %u\n", ring);
+				continue;
+			} else if (vf &&
+				   ((vf > adapter->num_vfs) ||
+				     ring >= adapter->num_rx_queues_per_pool)) {
+				e_err(drv, "FDIR restore failed with VF, "
+				      "vf: %hhu, ring: %u\n", vf, ring);
+				continue;
+			}
+
+			/* Map the ring onto the absolute queue index */
+			if (!vf)
+				queue = adapter->rx_ring[ring]->reg_idx;
+			else
+				queue = ((vf - 1) *
+					adapter->num_rx_queues_per_pool) + ring;
+		}
 
 		ixgbe_fdir_write_perfect_filter_82599(hw,
-				&filter->filter,
-				filter->sw_idx,
-				(action == IXGBE_FDIR_DROP_QUEUE) ?
-				IXGBE_FDIR_DROP_QUEUE :
-				adapter->rx_ring[action]->reg_idx);
+				&filter->filter, filter->sw_idx, queue);
 	}
 
 	spin_unlock(&adapter->fdir_perfect_lock);
-- 
2.16.5

