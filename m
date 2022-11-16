Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7772E62C5B0
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 18:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234240AbiKPRAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 12:00:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234338AbiKPRAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 12:00:25 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 249AF2F677
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 09:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668618012; x=1700154012;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=HUgEMlU6yNuQmgDFwrXwjchEJj+a9g564qvmdiMgtfY=;
  b=fsj0mA+YQRpoeKdSqxAnFVc81RJvKnOhvn8WSq3+82XHtbwYI1itqbv5
   tHkWIlN995Lujz8WKbDIAWHrv78nwALJyyuCC91oeEC3hLwr9N4+ODVrn
   hO9ToYBvW8c3j2PeLaoJNWed9Hlwd5xhYnCdYvyFAHebZ/9+yWCkkav8w
   CnpVVySMi4/KkrCeDg8mGH9gPQu0aNlsElXifBlKdpKve5+bUtxssy3q/
   cHvhnTnxG+aVln/oYl/IqIu25O56n7eyFTwcayH1KkOrGAKTLZpknjGqf
   ojAWjoYIeV0WamQ3GNCnxi69Ug1EwzajwlQ0swowdqqCO+1PiLH5pvFVi
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="398886074"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="398886074"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 09:00:10 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="708237606"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="708237606"
Received: from unknown (HELO paamrpdk12-S2600BPB.aw.intel.com) ([10.228.151.145])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 09:00:09 -0800
From:   Tirthendu Sarkar <tirthendu.sarkar@intel.com>
To:     tirtha@gmail.com, magnus.karlsson@intel.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        maciej.fijalkowski@intel.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH intel-next v3] i40e: allow toggling loopback mode via ndo_set_features callback
Date:   Wed, 16 Nov 2022 22:17:09 +0530
Message-Id: <20221116164709.9201-1-tirthendu.sarkar@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for NETIF_F_LOOPBACK. This feature can be set via:
$ ethtool -K eth0 loopback <on|off>

This sets the MAC Tx->Rx loopback.

This feature is used for the xsk selftests, and might have other uses
too.

Changelog:
    v2 -> v3:
     - Fixed loopback macros as per NVM version 6.01+.
     - Renamed existing macros as *_LEGACY
     - Based on NVM verison appropriate macro is used for MAC loopback.

    v1 -> v2:
     - Moved loopback to netdev's hardware features as suggested by
       Alexandr Lobakin.

Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
---
 .../net/ethernet/intel/i40e/i40e_adminq_cmd.h | 10 +++++--
 drivers/net/ethernet/intel/i40e/i40e_common.c | 26 +++++++++++++++++
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 28 ++++++++++++++++++-
 .../net/ethernet/intel/i40e/i40e_prototype.h  |  3 ++
 4 files changed, 63 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
index 60f9e0a6aaca..7532553a6982 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
@@ -1795,9 +1795,13 @@ I40E_CHECK_CMD_LENGTH(i40e_aqc_an_advt_reg);
 /* Set Loopback mode (0x0618) */
 struct i40e_aqc_set_lb_mode {
 	__le16	lb_mode;
-#define I40E_AQ_LB_PHY_LOCAL	0x01
-#define I40E_AQ_LB_PHY_REMOTE	0x02
-#define I40E_AQ_LB_MAC_LOCAL	0x04
+#define I40E_LEGACY_LOOPBACK_NVM_VER	0x6000
+#define I40E_AQ_LB_MAC_LOCAL		0x01
+#define I40E_AQ_LB_PHY_LOCAL		0x05
+#define I40E_AQ_LB_PHY_REMOTE		0x06
+#define I40E_AQ_LB_PHY_LOCAL_LEGACY   	0x01
+#define I40E_AQ_LB_PHY_REMOTE_LEGACY  	0x02
+#define I40E_AQ_LB_MAC_LOCAL_LEGACY   	0x04
 	u8	reserved[14];
 };
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index 4f01e2a6b6bb..8f764ff5c990 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -1830,6 +1830,32 @@ i40e_status i40e_aq_set_phy_int_mask(struct i40e_hw *hw,
 	return status;
 }
 
+/**
+ * i40e_aq_set_mac_loopback
+ * @hw: pointer to the HW struct
+ * @ena_lpbk: Enable or Disable loopback
+ * @cmd_details: pointer to command details structure or NULL
+ *
+ * Enable/disable loopback on a given port
+ */
+i40e_status i40e_aq_set_mac_loopback(struct i40e_hw *hw, bool ena_lpbk,
+				     struct i40e_asq_cmd_details *cmd_details)
+{
+	struct i40e_aq_desc desc;
+	struct i40e_aqc_set_lb_mode *cmd =
+		(struct i40e_aqc_set_lb_mode *)&desc.params.raw;
+
+	i40e_fill_default_direct_cmd_desc(&desc, i40e_aqc_opc_set_lb_modes);
+	if (ena_lpbk) {
+		if (hw->nvm.version <= I40E_LEGACY_LOOPBACK_NVM_VER)
+			cmd->lb_mode = cpu_to_le16(I40E_AQ_LB_MAC_LOCAL_LEGACY);
+		else
+			cmd->lb_mode = cpu_to_le16(I40E_AQ_LB_MAC_LOCAL);
+	}
+
+	return i40e_asq_send_command(hw, &desc, NULL, 0, cmd_details);
+}
+
 /**
  * i40e_aq_set_phy_debug
  * @hw: pointer to the hw struct
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 4880b740fa6e..1941715b6223 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -12920,6 +12920,28 @@ static void i40e_clear_rss_lut(struct i40e_vsi *vsi)
 	}
 }
 
+/**
+ * i40e_set_loopback - turn on/off loopback mode on underlying PF
+ * @vsi: ptr to VSI
+ * @ena: flag to indicate the on/off setting
+ */
+static int i40e_set_loopback(struct i40e_vsi *vsi, bool ena)
+{
+	bool if_running = netif_running(vsi->netdev);
+	int ret;
+
+	if (if_running && !test_and_set_bit(__I40E_VSI_DOWN, vsi->state))
+		i40e_down(vsi);
+
+	ret = i40e_aq_set_mac_loopback(&vsi->back->hw, ena, NULL);
+	if (ret)
+		netdev_err(vsi->netdev, "Failed to toggle loopback state\n");
+	if (if_running)
+		i40e_up(vsi);
+
+	return ret;
+}
+
 /**
  * i40e_set_features - set the netdev feature flags
  * @netdev: ptr to the netdev being adjusted
@@ -12960,6 +12982,10 @@ static int i40e_set_features(struct net_device *netdev,
 	if (need_reset)
 		i40e_do_reset(pf, I40E_PF_RESET_FLAG, true);
 
+	if (netdev->hw_features & NETIF_F_LOOPBACK)
+		if (i40e_set_loopback(vsi, !!(features & NETIF_F_LOOPBACK)))
+			return -EINVAL;
+
 	return 0;
 }
 
@@ -13722,7 +13748,7 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 	if (!(pf->flags & I40E_FLAG_MFP_ENABLED))
 		hw_features |= NETIF_F_NTUPLE | NETIF_F_HW_TC;
 
-	netdev->hw_features |= hw_features;
+	netdev->hw_features |= hw_features | NETIF_F_LOOPBACK;
 
 	netdev->features |= hw_features | NETIF_F_HW_VLAN_CTAG_FILTER;
 	netdev->hw_enc_features |= NETIF_F_TSO_MANGLEID;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_prototype.h b/drivers/net/ethernet/intel/i40e/i40e_prototype.h
index ebdcde6f1aeb..9a71121420c3 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_prototype.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_prototype.h
@@ -105,6 +105,9 @@ enum i40e_status_code i40e_aq_set_phy_config(struct i40e_hw *hw,
 				struct i40e_asq_cmd_details *cmd_details);
 enum i40e_status_code i40e_set_fc(struct i40e_hw *hw, u8 *aq_failures,
 				  bool atomic_reset);
+i40e_status i40e_aq_set_mac_loopback(struct i40e_hw *hw,
+				     bool ena_lpbk,
+				     struct i40e_asq_cmd_details *cmd_details);
 i40e_status i40e_aq_set_phy_int_mask(struct i40e_hw *hw, u16 mask,
 				     struct i40e_asq_cmd_details *cmd_details);
 i40e_status i40e_aq_clear_pxe_mode(struct i40e_hw *hw,
-- 
2.34.1

