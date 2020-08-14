Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43FB8244FCD
	for <lists+netdev@lfdr.de>; Sat, 15 Aug 2020 00:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgHNWSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 18:18:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:20045 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726637AbgHNWR7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Aug 2020 18:17:59 -0400
IronPort-SDR: TDHh9iSkBNMT40Mc14Y87X8F57R+Y88WTJ6Y+U7/BKrU1HT1tDMDS9LI0vYWg7ln4JWFaBevzc
 QWJrmUs2GHVw==
X-IronPort-AV: E=McAfee;i="6000,8403,9713"; a="172545042"
X-IronPort-AV: E=Sophos;i="5.76,313,1592895600"; 
   d="scan'208";a="172545042"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2020 15:17:58 -0700
IronPort-SDR: qhPpobabI0oHRwJ6VgzYEQDWeBAuuRa73OgkMLk8yVd9ewEbmFjlbyk4MOI1suUsAlBK7Wa9Rb
 cHP+ycIt1Ccw==
X-IronPort-AV: E=Sophos;i="5.76,313,1592895600"; 
   d="scan'208";a="291857043"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2020 15:17:58 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net v2 2/3] i40e: Set RX_ONLY mode for unicast promiscuous on VLAN
Date:   Fri, 14 Aug 2020 15:17:44 -0700
Message-Id: <20200814221745.666974-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200814221745.666974-1-anthony.l.nguyen@intel.com>
References: <20200814221745.666974-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>

Trusted VF with unicast promiscuous mode set, could listen to TX
traffic of other VFs.
Set unicast promiscuous mode to RX traffic, if VSI has port VLAN
configured. Rename misleading I40E_AQC_SET_VSI_PROMISC_TX bit to
I40E_AQC_SET_VSI_PROMISC_RX_ONLY. Aligned unicast promiscuous with
VLAN to the one without VLAN.

Fixes: 6c41a7606967 ("i40e: Add promiscuous on VLAN support")
Fixes: 3b1200891b7f ("i40e: When in promisc mode apply promisc mode to Tx Traffic as well")
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/i40e/i40e_adminq_cmd.h |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_common.c | 35 ++++++++++++++-----
 2 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
index a62ddd626929..c0c8efe42fce 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
@@ -981,7 +981,7 @@ struct i40e_aqc_set_vsi_promiscuous_modes {
 #define I40E_AQC_SET_VSI_PROMISC_BROADCAST	0x04
 #define I40E_AQC_SET_VSI_DEFAULT		0x08
 #define I40E_AQC_SET_VSI_PROMISC_VLAN		0x10
-#define I40E_AQC_SET_VSI_PROMISC_TX		0x8000
+#define I40E_AQC_SET_VSI_PROMISC_RX_ONLY	0x8000
 	__le16	seid;
 	__le16	vlan_tag;
 #define I40E_AQC_SET_VSI_VLAN_VALID		0x8000
diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index afad5e9f80e0..6ab52cbd697a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -1966,6 +1966,21 @@ i40e_status i40e_aq_set_phy_debug(struct i40e_hw *hw, u8 cmd_flags,
 	return status;
 }
 
+/**
+ * i40e_is_aq_api_ver_ge
+ * @aq: pointer to AdminQ info containing HW API version to compare
+ * @maj: API major value
+ * @min: API minor value
+ *
+ * Assert whether current HW API version is greater/equal than provided.
+ **/
+static bool i40e_is_aq_api_ver_ge(struct i40e_adminq_info *aq, u16 maj,
+				  u16 min)
+{
+	return (aq->api_maj_ver > maj ||
+		(aq->api_maj_ver == maj && aq->api_min_ver >= min));
+}
+
 /**
  * i40e_aq_add_vsi
  * @hw: pointer to the hw struct
@@ -2091,18 +2106,16 @@ i40e_status i40e_aq_set_vsi_unicast_promiscuous(struct i40e_hw *hw,
 
 	if (set) {
 		flags |= I40E_AQC_SET_VSI_PROMISC_UNICAST;
-		if (rx_only_promisc &&
-		    (((hw->aq.api_maj_ver == 1) && (hw->aq.api_min_ver >= 5)) ||
-		     (hw->aq.api_maj_ver > 1)))
-			flags |= I40E_AQC_SET_VSI_PROMISC_TX;
+		if (rx_only_promisc && i40e_is_aq_api_ver_ge(&hw->aq, 1, 5))
+			flags |= I40E_AQC_SET_VSI_PROMISC_RX_ONLY;
 	}
 
 	cmd->promiscuous_flags = cpu_to_le16(flags);
 
 	cmd->valid_flags = cpu_to_le16(I40E_AQC_SET_VSI_PROMISC_UNICAST);
-	if (((hw->aq.api_maj_ver >= 1) && (hw->aq.api_min_ver >= 5)) ||
-	    (hw->aq.api_maj_ver > 1))
-		cmd->valid_flags |= cpu_to_le16(I40E_AQC_SET_VSI_PROMISC_TX);
+	if (i40e_is_aq_api_ver_ge(&hw->aq, 1, 5))
+		cmd->valid_flags |=
+			cpu_to_le16(I40E_AQC_SET_VSI_PROMISC_RX_ONLY);
 
 	cmd->seid = cpu_to_le16(seid);
 	status = i40e_asq_send_command(hw, &desc, NULL, 0, cmd_details);
@@ -2199,11 +2212,17 @@ enum i40e_status_code i40e_aq_set_vsi_uc_promisc_on_vlan(struct i40e_hw *hw,
 	i40e_fill_default_direct_cmd_desc(&desc,
 					  i40e_aqc_opc_set_vsi_promiscuous_modes);
 
-	if (enable)
+	if (enable) {
 		flags |= I40E_AQC_SET_VSI_PROMISC_UNICAST;
+		if (i40e_is_aq_api_ver_ge(&hw->aq, 1, 5))
+			flags |= I40E_AQC_SET_VSI_PROMISC_RX_ONLY;
+	}
 
 	cmd->promiscuous_flags = cpu_to_le16(flags);
 	cmd->valid_flags = cpu_to_le16(I40E_AQC_SET_VSI_PROMISC_UNICAST);
+	if (i40e_is_aq_api_ver_ge(&hw->aq, 1, 5))
+		cmd->valid_flags |=
+			cpu_to_le16(I40E_AQC_SET_VSI_PROMISC_RX_ONLY);
 	cmd->seid = cpu_to_le16(seid);
 	cmd->vlan_tag = cpu_to_le16(vid | I40E_AQC_SET_VSI_VLAN_VALID);
 
-- 
2.26.2

