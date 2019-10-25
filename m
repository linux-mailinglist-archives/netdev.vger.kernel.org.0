Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 414CEE5549
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 22:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728639AbfJYUms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 16:42:48 -0400
Received: from mga14.intel.com ([192.55.52.115]:63953 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728591AbfJYUmq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 16:42:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Oct 2019 13:42:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,229,1569308400"; 
   d="scan'208";a="202713962"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 25 Oct 2019 13:42:44 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Piotr Azarewicz <piotr.azarewicz@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 3/9] i40e: Extract detection of HW flags into a function
Date:   Fri, 25 Oct 2019 13:42:36 -0700
Message-Id: <20191025204242.10535-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191025204242.10535-1-jeffrey.t.kirsher@intel.com>
References: <20191025204242.10535-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Piotr Azarewicz <piotr.azarewicz@intel.com>

Move code detecting HW flags based on device type and FW API version
into a single function.

Signed-off-by: Piotr Azarewicz <piotr.azarewicz@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_adminq.c | 71 +++++++++++++++----
 drivers/net/ethernet/intel/i40e/i40e_common.c |  4 --
 2 files changed, 58 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq.c b/drivers/net/ethernet/intel/i40e/i40e_adminq.c
index 72c04881d290..9f0a4e92a231 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq.c
@@ -507,6 +507,59 @@ static i40e_status i40e_shutdown_arq(struct i40e_hw *hw)
 	return ret_code;
 }
 
+/**
+ *  i40e_set_hw_flags - set HW flags
+ *  @hw: pointer to the hardware structure
+ **/
+static void i40e_set_hw_flags(struct i40e_hw *hw)
+{
+	struct i40e_adminq_info *aq = &hw->aq;
+
+	hw->flags = 0;
+
+	switch (hw->mac.type) {
+	case I40E_MAC_XL710:
+		if (aq->api_maj_ver > 1 ||
+		    (aq->api_maj_ver == 1 &&
+		     aq->api_min_ver >= I40E_MINOR_VER_GET_LINK_INFO_XL710)) {
+			hw->flags |= I40E_HW_FLAG_AQ_PHY_ACCESS_CAPABLE;
+			hw->flags |= I40E_HW_FLAG_FW_LLDP_STOPPABLE;
+			/* The ability to RX (not drop) 802.1ad frames */
+			hw->flags |= I40E_HW_FLAG_802_1AD_CAPABLE;
+		}
+		break;
+	case I40E_MAC_X722:
+		hw->flags |= I40E_HW_FLAG_AQ_SRCTL_ACCESS_ENABLE |
+			     I40E_HW_FLAG_NVM_READ_REQUIRES_LOCK;
+
+		if (aq->api_maj_ver > 1 ||
+		    (aq->api_maj_ver == 1 &&
+		     aq->api_min_ver >= I40E_MINOR_VER_FW_LLDP_STOPPABLE_X722))
+			hw->flags |= I40E_HW_FLAG_FW_LLDP_STOPPABLE;
+		/* fall through */
+	default:
+		break;
+	}
+
+	/* Newer versions of firmware require lock when reading the NVM */
+	if (aq->api_maj_ver > 1 ||
+	    (aq->api_maj_ver == 1 &&
+	     aq->api_min_ver >= 5))
+		hw->flags |= I40E_HW_FLAG_NVM_READ_REQUIRES_LOCK;
+
+	if (aq->api_maj_ver > 1 ||
+	    (aq->api_maj_ver == 1 &&
+	     aq->api_min_ver >= 8)) {
+		hw->flags |= I40E_HW_FLAG_FW_LLDP_PERSISTENT;
+		hw->flags |= I40E_HW_FLAG_DROP_MODE;
+	}
+
+	if (aq->api_maj_ver > 1 ||
+	    (aq->api_maj_ver == 1 &&
+	     aq->api_min_ver >= 9))
+		hw->flags |= I40E_HW_FLAG_AQ_PHY_ACCESS_EXTENDED;
+}
+
 /**
  *  i40e_init_adminq - main initialization routine for Admin Queue
  *  @hw: pointer to the hardware structure
@@ -571,6 +624,11 @@ i40e_status i40e_init_adminq(struct i40e_hw *hw)
 	if (ret_code != I40E_SUCCESS)
 		goto init_adminq_free_arq;
 
+	/* Some features were introduced in different FW API version
+	 * for different MAC type.
+	 */
+	i40e_set_hw_flags(hw);
+
 	/* get the NVM version info */
 	i40e_read_nvm_word(hw, I40E_SR_NVM_DEV_STARTER_VERSION,
 			   &hw->nvm.version);
@@ -596,25 +654,12 @@ i40e_status i40e_init_adminq(struct i40e_hw *hw)
 		hw->flags |= I40E_HW_FLAG_FW_LLDP_STOPPABLE;
 	}
 
-	/* Newer versions of firmware require lock when reading the NVM */
-	if (hw->aq.api_maj_ver > 1 ||
-	    (hw->aq.api_maj_ver == 1 &&
-	     hw->aq.api_min_ver >= 5))
-		hw->flags |= I40E_HW_FLAG_NVM_READ_REQUIRES_LOCK;
-
 	/* The ability to RX (not drop) 802.1ad frames was added in API 1.7 */
 	if (hw->aq.api_maj_ver > 1 ||
 	    (hw->aq.api_maj_ver == 1 &&
 	     hw->aq.api_min_ver >= 7))
 		hw->flags |= I40E_HW_FLAG_802_1AD_CAPABLE;
 
-	if (hw->aq.api_maj_ver > 1 ||
-	    (hw->aq.api_maj_ver == 1 &&
-	     hw->aq.api_min_ver >= 8)) {
-		hw->flags |= I40E_HW_FLAG_FW_LLDP_PERSISTENT;
-		hw->flags |= I40E_HW_FLAG_DROP_MODE;
-	}
-
 	if (hw->aq.api_maj_ver > I40E_FW_API_VERSION_MAJOR) {
 		ret_code = I40E_ERR_FIRMWARE_API_VERSION;
 		goto init_adminq_free_arq;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index f1d67267c983..fe553bb23d7a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -933,10 +933,6 @@ i40e_status i40e_init_shared_code(struct i40e_hw *hw)
 	else
 		hw->pf_id = (u8)(func_rid & 0x7);
 
-	if (hw->mac.type == I40E_MAC_X722)
-		hw->flags |= I40E_HW_FLAG_AQ_SRCTL_ACCESS_ENABLE |
-			     I40E_HW_FLAG_NVM_READ_REQUIRES_LOCK;
-
 	status = i40e_init_nvm(hw);
 	return status;
 }
-- 
2.21.0

