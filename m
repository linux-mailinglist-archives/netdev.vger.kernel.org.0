Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A89C4551EA
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 02:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242084AbhKRBDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 20:03:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:59862 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242083AbhKRBDO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 20:03:14 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10171"; a="221302867"
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="221302867"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 17:00:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="646235543"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 17 Nov 2021 17:00:11 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Radoslaw Tyl <radoslawx.tyl@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tony.brelinski@intel.com>
Subject: [PATCH net-next 3/5] ixgbevf: Add legacy suffix to old API mailbox functions
Date:   Wed, 17 Nov 2021 16:58:30 -0800
Message-Id: <20211118005832.245978-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118005832.245978-1-anthony.l.nguyen@intel.com>
References: <20211118005832.245978-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Radoslaw Tyl <radoslawx.tyl@intel.com>

Add legacy suffix to mailbox functions which should be backwards compatible
with older PF drivers. Communication during API negotiation always has to
be done using the earlier implementation.

Signed-off-by: Radoslaw Tyl <radoslawx.tyl@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf.h      |  2 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |  2 +-
 drivers/net/ethernet/intel/ixgbevf/mbx.c          | 14 +++++++-------
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf.h b/drivers/net/ethernet/intel/ixgbevf/ixgbevf.h
index a0e325774819..5d9284dd04dc 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf.h
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf.h
@@ -429,7 +429,7 @@ extern const struct ixgbevf_info ixgbevf_82599_vf_info;
 extern const struct ixgbevf_info ixgbevf_X540_vf_info;
 extern const struct ixgbevf_info ixgbevf_X550_vf_info;
 extern const struct ixgbevf_info ixgbevf_X550EM_x_vf_info;
-extern const struct ixgbe_mbx_operations ixgbevf_mbx_ops;
+extern const struct ixgbe_mbx_operations ixgbevf_mbx_ops_legacy;
 extern const struct ixgbevf_info ixgbevf_x550em_a_vf_info;
 
 extern const struct ixgbevf_info ixgbevf_82599_vf_hv_info;
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index d81811ab4ec4..cd93b47a61cd 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -4565,7 +4565,7 @@ static int ixgbevf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	memcpy(&hw->mac.ops, ii->mac_ops, sizeof(hw->mac.ops));
 	hw->mac.type  = ii->mac;
 
-	memcpy(&hw->mbx.ops, &ixgbevf_mbx_ops,
+	memcpy(&hw->mbx.ops, &ixgbevf_mbx_ops_legacy,
 	       sizeof(struct ixgbe_mbx_operations));
 
 	/* setup the private structure */
diff --git a/drivers/net/ethernet/intel/ixgbevf/mbx.c b/drivers/net/ethernet/intel/ixgbevf/mbx.c
index 2c3762cb467d..0edcfcbf5296 100644
--- a/drivers/net/ethernet/intel/ixgbevf/mbx.c
+++ b/drivers/net/ethernet/intel/ixgbevf/mbx.c
@@ -224,14 +224,14 @@ static s32 ixgbevf_obtain_mbx_lock_vf(struct ixgbe_hw *hw)
 }
 
 /**
- *  ixgbevf_write_mbx_vf - Write a message to the mailbox
+ *  ixgbevf_write_mbx_vf_legacy - Write a message to the mailbox
  *  @hw: pointer to the HW structure
  *  @msg: The message buffer
  *  @size: Length of buffer
  *
  *  returns 0 if it successfully copied message into the buffer
  **/
-static s32 ixgbevf_write_mbx_vf(struct ixgbe_hw *hw, u32 *msg, u16 size)
+static s32 ixgbevf_write_mbx_vf_legacy(struct ixgbe_hw *hw, u32 *msg, u16 size)
 {
 	s32 ret_val;
 	u16 i;
@@ -260,14 +260,14 @@ static s32 ixgbevf_write_mbx_vf(struct ixgbe_hw *hw, u32 *msg, u16 size)
 }
 
 /**
- *  ixgbevf_read_mbx_vf - Reads a message from the inbox intended for VF
+ *  ixgbevf_read_mbx_vf_legacy - Reads a message from the inbox intended for VF
  *  @hw: pointer to the HW structure
  *  @msg: The message buffer
  *  @size: Length of buffer
  *
  *  returns 0 if it successfully read message from buffer
  **/
-static s32 ixgbevf_read_mbx_vf(struct ixgbe_hw *hw, u32 *msg, u16 size)
+static s32 ixgbevf_read_mbx_vf_legacy(struct ixgbe_hw *hw, u32 *msg, u16 size)
 {
 	s32 ret_val = 0;
 	u16 i;
@@ -318,10 +318,10 @@ static s32 ixgbevf_init_mbx_params_vf(struct ixgbe_hw *hw)
 	return 0;
 }
 
-const struct ixgbe_mbx_operations ixgbevf_mbx_ops = {
+const struct ixgbe_mbx_operations ixgbevf_mbx_ops_legacy = {
 	.init_params	= ixgbevf_init_mbx_params_vf,
-	.read		= ixgbevf_read_mbx_vf,
-	.write		= ixgbevf_write_mbx_vf,
+	.read		= ixgbevf_read_mbx_vf_legacy,
+	.write		= ixgbevf_write_mbx_vf_legacy,
 	.read_posted	= ixgbevf_read_posted_mbx,
 	.write_posted	= ixgbevf_write_posted_mbx,
 	.check_for_msg	= ixgbevf_check_for_msg_vf,
-- 
2.31.1

