Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEBB4FA404
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729798AbfKMB50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 20:57:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:50624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729782AbfKMB5Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 20:57:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 845B4222CF;
        Wed, 13 Nov 2019 01:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610245;
        bh=ZbNF/HOQmAyS7qUPtr8/B5e3AqtF1X/+pA8iO8KsUvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M6pdmhnoheEkdMLfBMWFWh3jDKr7wA1ZctEMvaQED0cwTZ95HXJd8a8AEVmN54u6z
         CaQHPkarmvDsoF8Ods18C/4Amo1VQnXJQEw+CMm5K78H0x1bEp+/l1TQ4Hm6BrO15j
         POWbWXONvYGbgs7zu4tYnK7W1FWP5LVUhG3OQ6d8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Radoslaw Tyl <radoslawx.tyl@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 044/115] ixgbe: Fix crash with VFs and flow director on interface flap
Date:   Tue, 12 Nov 2019 20:55:11 -0500
Message-Id: <20191113015622.11592-44-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
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
index d1472727ef882..4801d96c4fa91 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -5129,6 +5129,7 @@ static void ixgbe_fdir_filter_restore(struct ixgbe_adapter *adapter)
 	struct ixgbe_hw *hw = &adapter->hw;
 	struct hlist_node *node2;
 	struct ixgbe_fdir_filter *filter;
+	u64 action;
 
 	spin_lock(&adapter->fdir_perfect_lock);
 
@@ -5137,12 +5138,17 @@ static void ixgbe_fdir_filter_restore(struct ixgbe_adapter *adapter)
 
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

