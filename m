Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 403054551E8
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 02:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242074AbhKRBDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 20:03:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:59858 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242082AbhKRBDO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 20:03:14 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10171"; a="221302866"
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="221302866"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 17:00:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="646235530"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 17 Nov 2021 17:00:10 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Radoslaw Tyl <radoslawx.tyl@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tony.brelinski@intel.com>
Subject: [PATCH net-next 2/5] ixgbevf: Improve error handling in mailbox
Date:   Wed, 17 Nov 2021 16:58:29 -0800
Message-Id: <20211118005832.245978-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118005832.245978-1-anthony.l.nguyen@intel.com>
References: <20211118005832.245978-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Radoslaw Tyl <radoslawx.tyl@intel.com>

Add new handling for error codes:
 IXGBE_ERR_CONFIG - ixgbe_mbx_operations is not correctly set
 IXGBE_ERR_TIMEOUT - mailbox operation, e.g. poll for message, timeout

Signed-off-by: Radoslaw Tyl <radoslawx.tyl@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbevf/defines.h |  3 +++
 drivers/net/ethernet/intel/ixgbevf/mbx.c     | 14 ++++++++++----
 drivers/net/ethernet/intel/ixgbevf/mbx.h     |  1 -
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/defines.h b/drivers/net/ethernet/intel/ixgbevf/defines.h
index 6bace746eaac..46fb1f9eab7f 100644
--- a/drivers/net/ethernet/intel/ixgbevf/defines.h
+++ b/drivers/net/ethernet/intel/ixgbevf/defines.h
@@ -281,6 +281,9 @@ struct ixgbe_adv_tx_context_desc {
 #define IXGBE_ERR_INVALID_MAC_ADDR	-1
 #define IXGBE_ERR_RESET_FAILED		-2
 #define IXGBE_ERR_INVALID_ARGUMENT	-3
+#define IXGBE_ERR_CONFIG		-4
+#define IXGBE_ERR_MBX			-5
+#define IXGBE_ERR_TIMEOUT		-6
 
 /* Transmit Config masks */
 #define IXGBE_TXDCTL_ENABLE		0x02000000 /* Ena specific Tx Queue */
diff --git a/drivers/net/ethernet/intel/ixgbevf/mbx.c b/drivers/net/ethernet/intel/ixgbevf/mbx.c
index 6bc1953263b9..2c3762cb467d 100644
--- a/drivers/net/ethernet/intel/ixgbevf/mbx.c
+++ b/drivers/net/ethernet/intel/ixgbevf/mbx.c
@@ -15,6 +15,9 @@ static s32 ixgbevf_poll_for_msg(struct ixgbe_hw *hw)
 	struct ixgbe_mbx_info *mbx = &hw->mbx;
 	int countdown = mbx->timeout;
 
+	if (!countdown || !mbx->ops.check_for_msg)
+		return IXGBE_ERR_CONFIG;
+
 	while (countdown && mbx->ops.check_for_msg(hw)) {
 		countdown--;
 		udelay(mbx->udelay);
@@ -24,7 +27,7 @@ static s32 ixgbevf_poll_for_msg(struct ixgbe_hw *hw)
 	if (!countdown)
 		mbx->timeout = 0;
 
-	return countdown ? 0 : IXGBE_ERR_MBX;
+	return countdown ? 0 : IXGBE_ERR_TIMEOUT;
 }
 
 /**
@@ -38,6 +41,9 @@ static s32 ixgbevf_poll_for_ack(struct ixgbe_hw *hw)
 	struct ixgbe_mbx_info *mbx = &hw->mbx;
 	int countdown = mbx->timeout;
 
+	if (!countdown || !mbx->ops.check_for_ack)
+		return IXGBE_ERR_CONFIG;
+
 	while (countdown && mbx->ops.check_for_ack(hw)) {
 		countdown--;
 		udelay(mbx->udelay);
@@ -47,7 +53,7 @@ static s32 ixgbevf_poll_for_ack(struct ixgbe_hw *hw)
 	if (!countdown)
 		mbx->timeout = 0;
 
-	return countdown ? 0 : IXGBE_ERR_MBX;
+	return countdown ? 0 : IXGBE_ERR_TIMEOUT;
 }
 
 /**
@@ -62,7 +68,7 @@ static s32 ixgbevf_poll_for_ack(struct ixgbe_hw *hw)
 static s32 ixgbevf_read_posted_mbx(struct ixgbe_hw *hw, u32 *msg, u16 size)
 {
 	struct ixgbe_mbx_info *mbx = &hw->mbx;
-	s32 ret_val = IXGBE_ERR_MBX;
+	s32 ret_val = IXGBE_ERR_CONFIG;
 
 	if (!mbx->ops.read)
 		goto out;
@@ -88,7 +94,7 @@ static s32 ixgbevf_read_posted_mbx(struct ixgbe_hw *hw, u32 *msg, u16 size)
 static s32 ixgbevf_write_posted_mbx(struct ixgbe_hw *hw, u32 *msg, u16 size)
 {
 	struct ixgbe_mbx_info *mbx = &hw->mbx;
-	s32 ret_val = IXGBE_ERR_MBX;
+	s32 ret_val = IXGBE_ERR_CONFIG;
 
 	/* exit if either we can't write or there isn't a defined timeout */
 	if (!mbx->ops.write || !mbx->timeout)
diff --git a/drivers/net/ethernet/intel/ixgbevf/mbx.h b/drivers/net/ethernet/intel/ixgbevf/mbx.h
index a461b7d16206..b3b83c95babf 100644
--- a/drivers/net/ethernet/intel/ixgbevf/mbx.h
+++ b/drivers/net/ethernet/intel/ixgbevf/mbx.h
@@ -7,7 +7,6 @@
 #include "vf.h"
 
 #define IXGBE_VFMAILBOX_SIZE	16 /* 16 32 bit words - 64 bytes */
-#define IXGBE_ERR_MBX		-100
 
 #define IXGBE_VFMAILBOX		0x002FC
 #define IXGBE_VFMBMEM		0x00200
-- 
2.31.1

