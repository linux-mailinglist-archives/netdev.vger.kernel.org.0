Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90FE1FA0BB
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 02:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbfKMBwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 20:52:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:40422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728119AbfKMBwD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 20:52:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1460B20674;
        Wed, 13 Nov 2019 01:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609922;
        bh=l6pIeRuMJhfnBHzeFNNTbpdwiyNr5qVCW2IiF8wlkhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=riFSBAertdqd8ZRL1oQTyGJ+eRRy+QFZ1p3EKv7nubN4F4N217D8j4jmL8yVRS1LN
         gIlAsnj5AGcLp/TmLfJqAbORRZqsClCsY0Q4GHegFTuL2xmwpD8ulP4npuneCdWwd8
         LBBZ8fZChDR74DypEs9eZN1DTzc+d4hp794CR6cM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Radoslaw Tyl <radoslawx.tyl@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 070/209] ixgbe: Fix crash with VFs and flow director on interface flap
Date:   Tue, 12 Nov 2019 20:48:06 -0500
Message-Id: <20191113015025.9685-70-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Radoslaw Tyl <radoslawx.tyl@intel.com>

[ Upstream commit 5d826d209164b0752c883607be4cdbbcf7cab494 ]

This patch fix crash when we have restore flow director filters after reset
adapter. In ixgbe_fdir_filter_restore() filter->action is outside of the
rx_ring array, as it has a VF identifier in the upper 32 bits.

Signed-off-by: Radoslaw Tyl <radoslawx.tyl@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index f3e21de3b1f0b..b45a6e2ed8d15 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -5187,6 +5187,7 @@ static void ixgbe_fdir_filter_restore(struct ixgbe_adapter *adapter)
 	struct ixgbe_hw *hw = &adapter->hw;
 	struct hlist_node *node2;
 	struct ixgbe_fdir_filter *filter;
+	u64 action;
 
 	spin_lock(&adapter->fdir_perfect_lock);
 
@@ -5195,12 +5196,17 @@ static void ixgbe_fdir_filter_restore(struct ixgbe_adapter *adapter)
 
 	hlist_for_each_entry_safe(filter, node2,
 				  &adapter->fdir_filter_list, fdir_node) {
+		action = filter->action;
+		if (action != IXGBE_FDIR_DROP_QUEUE && action != 0)
+			action =
+			(action >> ETHTOOL_RX_FLOW_SPEC_RING_VF_OFF) - 1;
+
 		ixgbe_fdir_write_perfect_filter_82599(hw,
 				&filter->filter,
 				filter->sw_idx,
-				(filter->action == IXGBE_FDIR_DROP_QUEUE) ?
+				(action == IXGBE_FDIR_DROP_QUEUE) ?
 				IXGBE_FDIR_DROP_QUEUE :
-				adapter->rx_ring[filter->action]->reg_idx);
+				adapter->rx_ring[action]->reg_idx);
 	}
 
 	spin_unlock(&adapter->fdir_perfect_lock);
-- 
2.20.1

