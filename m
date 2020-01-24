Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE301488B5
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731598AbgAXOUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:20:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:41832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404930AbgAXOUi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 09:20:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A745E2077C;
        Fri, 24 Jan 2020 14:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875637;
        bh=MepvgZWRn42fd+rCUdxQRVnBHHPf5FpQs2mJ+e+l62A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wofoee+FH81s8xjxaE9KgSRKG8ep0b16UTmjKwbNliRJVDVIvqzFXX0ZIBQeoOovT
         XT2cDkUL7hXne15kQuafaDraCKSvkqxRgMqXQP+JdM4TjGre3ZQwHUHiO/twais3iy
         xI1CqNBArwfcYN4Ovvmz3a04WxEMG5kp5IuMdDVc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cambda Zhu <cambda@linux.alibaba.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 21/56] ixgbe: Fix calculation of queue with VFs and flow director on interface flap
Date:   Fri, 24 Jan 2020 09:19:37 -0500
Message-Id: <20200124142012.29752-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124142012.29752-1-sashal@kernel.org>
References: <20200124142012.29752-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cambda Zhu <cambda@linux.alibaba.com>

[ Upstream commit 4fad78ad6422d9bca62135bbed8b6abc4cbb85b8 ]

This patch fixes the calculation of queue when we restore flow director
filters after resetting adapter. In ixgbe_fdir_filter_restore(), filter's
vf may be zero which makes the queue outside of the rx_ring array.

The calculation is changed to the same as ixgbe_add_ethtool_fdir_entry().

Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 37 ++++++++++++++-----
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index de65ca1e65580..7db8a05de861a 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -5187,7 +5187,7 @@ static void ixgbe_fdir_filter_restore(struct ixgbe_adapter *adapter)
 	struct ixgbe_hw *hw = &adapter->hw;
 	struct hlist_node *node2;
 	struct ixgbe_fdir_filter *filter;
-	u64 action;
+	u8 queue;
 
 	spin_lock(&adapter->fdir_perfect_lock);
 
@@ -5196,17 +5196,34 @@ static void ixgbe_fdir_filter_restore(struct ixgbe_adapter *adapter)
 
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
+				e_err(drv, "FDIR restore failed without VF, ring: %u\n",
+				      ring);
+				continue;
+			} else if (vf &&
+				   ((vf > adapter->num_vfs) ||
+				     ring >= adapter->num_rx_queues_per_pool)) {
+				e_err(drv, "FDIR restore failed with VF, vf: %hhu, ring: %u\n",
+				      vf, ring);
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
2.20.1

