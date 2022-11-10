Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE58F623CF4
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 08:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbiKJHxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 02:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232858AbiKJHxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 02:53:38 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5693FD0D
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 23:53:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668066817; x=1699602817;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fYkttwNKwU/bCgG8EmqEBArJJBs2YCKQhQd9sHquWPk=;
  b=MLsayCgwooELHsnDvaN9VrgGDaC4cZDcn9BA72mjIzikY78L9eXb53wr
   orEke93UoxvqDbbz58mCKBHVifnjlgwCv/GJ1jIXQ2G6tRFMSqbcCKiPh
   3W2p+F19/S8RG0Snyird32+eC6GT6oh6y9jR/GJw0umMDIRQ+tV/aip+i
   fylbUJAAuazoxAd6iI10ixKBZmz58L/j3S/HY3RnKpuDgw+gp79dGovjz
   jecAXnhBN9x190hKM+g+8tWq/NvezPVoGF1opPBoOZp2oWhUyD3COCrZb
   GN5v07PrUe+rC2L3a6jw4DDJpu0a7rDwUU8KeB9v/+wvo+nS6AY47l531
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="309959497"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="309959497"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 23:53:37 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="588080557"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="588080557"
Received: from unknown (HELO paamrpdk12-S2600BPB.aw.intel.com) ([10.228.151.145])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 23:53:36 -0800
From:   Tirthendu Sarkar <tirthendu.sarkar@intel.com>
To:     tirtha@gmail.com, magnus.karlsson@intel.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        maciej.fijalkowski@intel.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH intel-next v2] i40e: allow toggling loopback mode via ndo_set_features callback
Date:   Thu, 10 Nov 2022 13:10:38 +0530
Message-Id: <20221110074038.94804-1-tirthendu.sarkar@intel.com>
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

Feature can be useful for local data path tests.

Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_common.c | 22 +++++++++++++++
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 28 ++++++++++++++++++-
 .../net/ethernet/intel/i40e/i40e_prototype.h  |  3 ++
 3 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index 4f01e2a6b6bb..73d2c700dc35 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -1830,6 +1830,28 @@ i40e_status i40e_aq_set_phy_int_mask(struct i40e_hw *hw,
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
+	if (ena_lpbk)
+		cmd->lb_mode = cpu_to_le16(I40E_AQ_LB_MAC_LOCAL);
+
+	return i40e_asq_send_command(hw, &desc, NULL, 0, cmd_details);
+}
+
 /**
  * i40e_aq_set_phy_debug
  * @hw: pointer to the hw struct
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 1a1fab94205d..f134ae9169d7 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -12919,6 +12919,28 @@ static void i40e_clear_rss_lut(struct i40e_vsi *vsi)
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
@@ -12959,6 +12981,10 @@ static int i40e_set_features(struct net_device *netdev,
 	if (need_reset)
 		i40e_do_reset(pf, I40E_PF_RESET_FLAG, true);
 
+	if (features & NETIF_F_LOOPBACK)
+		if (i40e_set_loopback(vsi, !!(features & NETIF_F_LOOPBACK)))
+			return -EINVAL;
+
 	return 0;
 }
 
@@ -13721,7 +13747,7 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
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

