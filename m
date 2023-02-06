Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEE168CAD6
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 00:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjBFX5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 18:57:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjBFX5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 18:57:03 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B5920687
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 15:57:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675727822; x=1707263822;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jmtR2xKdXvHbJFezOgE2lIc7SxoZRN0DkxjctqJzWyQ=;
  b=fbeqju9lkiNdeo1JSYrj4HdZWqWMMkocdd5+B9VFsv2blLCtsop0kv+p
   m8bYo0hgBmUVhuD6UJfpQt5XaI5OqlrzKCvBLSvrAJlD417NXQEzuLCf3
   MnJVlsDeaFRjGNUTX3XqJ2sfok4wd+yqM8yocFilOsVJmYw8SN0CUA3Td
   V7iHyd7IsP0YXjfN/3vokwxGonpx0yt5FIjJVr8iC/Id+9hYLlyRhwO9V
   Nmc/a0hDE8eUWkopJiWmRsWKBln+imGDKWb7zUz8OtwjtnGWVoAsoDowV
   K6DRzrM557/Ormv92VmmbwAH27P3Pfce0FmEO2pDuNFgCDghIXdZMt+/k
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="327034348"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="327034348"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 15:57:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="616606965"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="616606965"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga003.jf.intel.com with ESMTP; 06 Feb 2023 15:57:00 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Sebastian Czapla <sebastianx.czapla@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net-next 1/6] i40e: Add flag for disabling VF source pruning
Date:   Mon,  6 Feb 2023 15:56:30 -0800
Message-Id: <20230206235635.662263-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230206235635.662263-1-anthony.l.nguyen@intel.com>
References: <20230206235635.662263-1-anthony.l.nguyen@intel.com>
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

From: Sebastian Czapla <sebastianx.czapla@intel.com>

Allow user to change source pruning for VF VSIs. This allows VFs to
receive packets with MAC_SRC and MAC_DST equal to VFs mac.

Added priv flag vf-source-pruning to allow user to change
source pruning setting. Reset all VSIs to commit the setting.
If vf-source-pruning is off and VF is trusted on with spoofchk off
then disable source pruning on specific VF takes effect.

Without this patch it is not possible to change source pruning
setting on VF VSIs.

Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Signed-off-by: Sebastian Czapla <sebastianx.czapla@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h        |  2 +
 .../net/ethernet/intel/i40e/i40e_ethtool.c    | 13 +++-
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 70 ++++++++++++++-----
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 66 ++++++++++++++++-
 .../ethernet/intel/i40e/i40e_virtchnl_pf.h    |  2 +
 5 files changed, 134 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 38c341b9f368..f1b42095e2dc 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -604,6 +604,7 @@ struct i40e_pf {
  *   in abilities field of i40e_aq_set_phy_config structure
  */
 #define I40E_FLAG_TOTAL_PORT_SHUTDOWN_ENABLED	BIT(27)
+#define I40E_FLAG_VF_SOURCE_PRUNING		BIT(31)
 
 	struct i40e_client_instance *cinst;
 	bool stat_offsets_loaded;
@@ -1288,6 +1289,7 @@ void i40e_ptp_stop(struct i40e_pf *pf);
 int i40e_ptp_alloc_pins(struct i40e_pf *pf);
 int i40e_update_adq_vsi_queues(struct i40e_vsi *vsi, int vsi_offset);
 int i40e_is_vsi_uplink_mode_veb(struct i40e_vsi *vsi);
+i40e_status i40e_configure_source_pruning(struct i40e_vsi *vsi, bool enable);
 i40e_status i40e_get_partition_bw_setting(struct i40e_pf *pf);
 i40e_status i40e_set_partition_bw_setting(struct i40e_pf *pf);
 i40e_status i40e_commit_partition_bw_setting(struct i40e_pf *pf);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 887a735fe2a7..781824e2c011 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -457,6 +457,7 @@ static const struct i40e_priv_flags i40e_gstrings_priv_flags[] = {
 	I40E_PRIV_FLAG("base-r-fec", I40E_FLAG_BASE_R_FEC, 0),
 	I40E_PRIV_FLAG("vf-vlan-pruning",
 		       I40E_FLAG_VF_VLAN_PRUNING, 0),
+	I40E_PRIV_FLAG("vf-source-pruning", I40E_FLAG_VF_SOURCE_PRUNING, 0),
 };
 
 #define I40E_PRIV_FLAGS_STR_LEN ARRAY_SIZE(i40e_gstrings_priv_flags)
@@ -5294,7 +5295,8 @@ static int i40e_set_priv_flags(struct net_device *dev, u32 flags)
 	if (changed_flags & I40E_FLAG_DISABLE_FW_LLDP)
 		reset_needed = I40E_PF_RESET_AND_REBUILD_FLAG;
 	if (changed_flags & (I40E_FLAG_VEB_STATS_ENABLED |
-	    I40E_FLAG_LEGACY_RX | I40E_FLAG_SOURCE_PRUNING_DISABLED))
+	    I40E_FLAG_LEGACY_RX | I40E_FLAG_SOURCE_PRUNING_DISABLED |
+	    I40E_FLAG_VF_SOURCE_PRUNING))
 		reset_needed = BIT(__I40E_PF_RESET_REQUESTED);
 
 	/* Before we finalize any flag changes, we need to perform some
@@ -5446,6 +5448,15 @@ static int i40e_set_priv_flags(struct net_device *dev, u32 flags)
 		}
 	}
 
+	if (changed_flags & I40E_FLAG_VF_SOURCE_PRUNING) {
+		if (orig_flags & I40E_FLAG_VF_SOURCE_PRUNING)
+			dev_info(&pf->pdev->dev,
+				 "VF source pruning disabled. To take effect please make sure to disable spoof checking and enable trust on selected VF's\n");
+		else
+			dev_info(&pf->pdev->dev,
+				 "VF source pruning enabled on all VF's\n");
+	}
+
 	/* Now that we've checked to ensure that the new flags are valid, load
 	 * them into place. Since we only modify flags either (a) during
 	 * initialization or (b) while holding the RTNL lock, we don't need
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 43693f902c27..284e44ff8d16 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -12874,6 +12874,9 @@ static int i40e_sw_init(struct i40e_pf *pf)
 		dev_info(&pf->pdev->dev,
 			 "total-port-shutdown was enabled, link-down-on-close is forced on\n");
 	}
+	/* VSIs by default have source pruning enabled */
+	pf->flags |= I40E_FLAG_VF_SOURCE_PRUNING;
+
 	mutex_init(&pf->switch_mutex);
 
 sw_init_done:
@@ -13906,6 +13909,54 @@ int i40e_is_vsi_uplink_mode_veb(struct i40e_vsi *vsi)
 	return 0;
 }
 
+/**
+ * i40e_configure_source_pruning
+ * @vsi: VSI to disable source pruning on
+ * @enable: enable or disable pruning
+ *
+ * Enable/disable vsi source pruning based on enable flag
+ **/
+i40e_status i40e_configure_source_pruning(struct i40e_vsi *vsi, bool enable)
+{
+	struct i40e_pf *pf = vsi->back;
+	struct i40e_hw *hw = &pf->hw;
+	struct i40e_vsi_context ctxt;
+	i40e_status ret;
+
+	memset(&ctxt, 0, sizeof(ctxt));
+
+	ctxt.seid = vsi->seid;
+	ctxt.pf_num = hw->pf_id;
+	if (vsi->type == I40E_VSI_SRIOV)
+		ctxt.vf_num = vsi->vf_id + hw->func_caps.vf_base_id;
+	ret = i40e_aq_get_vsi_params(hw, &ctxt, NULL);
+	if (ret) {
+		dev_info(&pf->pdev->dev,
+			 "couldn't get vsi config, err %s\n",
+			 i40e_stat_str(hw, ret));
+		return ret;
+	}
+
+	if (vsi->type == I40E_VSI_MAIN)
+		ctxt.flags = I40E_AQ_VSI_TYPE_PF;
+	else if (vsi->type == I40E_VSI_SRIOV)
+		ctxt.flags = I40E_AQ_VSI_TYPE_VF;
+
+	ctxt.info.valid_sections = cpu_to_le16(I40E_AQ_VSI_PROP_SWITCH_VALID);
+	if (enable)
+		ctxt.info.switch_id &=
+			~cpu_to_le16(I40E_AQ_VSI_SW_ID_FLAG_LOCAL_LB);
+	else
+		ctxt.info.switch_id |=
+			cpu_to_le16(I40E_AQ_VSI_SW_ID_FLAG_LOCAL_LB);
+	ret = i40e_aq_update_vsi_params(&pf->hw, &ctxt, NULL);
+	if (ret)
+		dev_err(&pf->pdev->dev,
+			"Update VSI failed, err %s\n",
+			i40e_stat_str(&pf->hw, ret));
+	return ret;
+}
+
 /**
  * i40e_add_vsi - Add a VSI to the switch
  * @vsi: the VSI being configured
@@ -13960,24 +14011,9 @@ static int i40e_add_vsi(struct i40e_vsi *vsi)
 		 * the VSI to disable source pruning.
 		 */
 		if (pf->flags & I40E_FLAG_SOURCE_PRUNING_DISABLED) {
-			memset(&ctxt, 0, sizeof(ctxt));
-			ctxt.seid = pf->main_vsi_seid;
-			ctxt.pf_num = pf->hw.pf_id;
-			ctxt.vf_num = 0;
-			ctxt.info.valid_sections |=
-				     cpu_to_le16(I40E_AQ_VSI_PROP_SWITCH_VALID);
-			ctxt.info.switch_id =
-				   cpu_to_le16(I40E_AQ_VSI_SW_ID_FLAG_LOCAL_LB);
-			ret = i40e_aq_update_vsi_params(hw, &ctxt, NULL);
-			if (ret) {
-				dev_info(&pf->pdev->dev,
-					 "update vsi failed, err %s aq_err %s\n",
-					 i40e_stat_str(&pf->hw, ret),
-					 i40e_aq_str(&pf->hw,
-						     pf->hw.aq.asq_last_status));
-				ret = -ENOENT;
+			ret = i40e_configure_source_pruning(vsi, false);
+			if (ret)
 				goto err;
-			}
 		}
 
 		/* MFP mode setup queue map and update VSI */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 8fa0f0c12fde..c2141f0c9adb 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -591,6 +591,61 @@ i40e_config_rdma_qvlist(struct i40e_vf *vf,
 	return ret;
 }
 
+/**
+ * i40e_set_source_pruning
+ * @vf: pointer to the VF info
+ *
+ * This function set appropriate source pruning flag for vf.
+ * To disable source pruning on selected VFs the PF should set
+ * private flag 'vf-source-pruning' off, and VF should be set
+ * 'trusted' on and 'spoofchk' off.
+ * Otherwise, source pruning should still be enabled on VF.
+ **/
+static int i40e_set_source_pruning(struct i40e_vf *vf)
+{
+	struct i40e_pf *pf = vf->pf;
+	struct i40e_vsi *vsi;
+	bool pf_sp;
+
+	vsi = pf->vsi[vf->lan_vsi_idx];
+	pf_sp = !!(pf->flags & I40E_FLAG_VF_SOURCE_PRUNING);
+
+	if (pf_sp) {
+		if (!vf->source_pruning) {
+			vf->source_pruning = true;
+			dev_info(&pf->pdev->dev,
+				 "Source pruning enabled on VF %d\n",
+				 vf->vf_id);
+		}
+		return 0;
+	}
+
+	if (!vf->source_pruning && (!vf->trusted || vf->spoofchk)) {
+		if (vf->spoofchk &&
+		    test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+			/* enable source pruning beyond vf reset */
+			if (i40e_configure_source_pruning(vsi, true))
+				return -EIO;
+		}
+		vf->source_pruning = true;
+		dev_info(&pf->pdev->dev,
+			 "Source pruning enabled on VF %d\n", vf->vf_id);
+	} else if ((vf->source_pruning && vf->trusted &&
+		   !vf->spoofchk) || !vf->source_pruning) {
+		if (i40e_configure_source_pruning(vsi, false))
+			return -EIO;
+
+		if (vf->source_pruning) {
+			vf->source_pruning = false;
+			dev_info(&pf->pdev->dev,
+				 "Source pruning disabled on VF %d\n",
+				 vf->vf_id);
+		}
+	}
+
+	return 0;
+}
+
 /**
  * i40e_config_vsi_tx_queue
  * @vf: pointer to the VF info
@@ -848,6 +903,9 @@ static int i40e_alloc_vsi_res(struct i40e_vf *vf, u8 idx)
 				vf->vf_id, ret);
 	}
 
+	if (!idx)
+		ret = i40e_set_source_pruning(vf);
+
 error_alloc_vsi_res:
 	return ret;
 }
@@ -1830,6 +1888,8 @@ int i40e_alloc_vfs(struct i40e_pf *pf, u16 num_alloc_vfs)
 
 		set_bit(I40E_VF_STATE_PRE_ENABLE, &vfs[i].vf_states);
 
+		/* assign source pruning default value */
+		vfs[i].source_pruning = true;
 	}
 	pf->num_alloc_vfs = num_alloc_vfs;
 
@@ -4718,7 +4778,6 @@ int i40e_ndo_set_vf_spoofchk(struct net_device *netdev, int vf_id, bool enable)
 	if (enable == vf->spoofchk)
 		goto out;
 
-	vf->spoofchk = enable;
 	memset(&ctxt, 0, sizeof(ctxt));
 	ctxt.seid = pf->vsi[vf->lan_vsi_idx]->seid;
 	ctxt.pf_num = pf->hw.pf_id;
@@ -4731,7 +4790,12 @@ int i40e_ndo_set_vf_spoofchk(struct net_device *netdev, int vf_id, bool enable)
 		dev_err(&pf->pdev->dev, "Error %d updating VSI parameters\n",
 			ret);
 		ret = -EIO;
+		goto out;
 	}
+	vf->spoofchk = enable;
+
+	ret = i40e_set_source_pruning(vf);
+
 out:
 	clear_bit(__I40E_VIRTCHNL_OP_PENDING, pf->state);
 	return ret;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
index 895b8feb2567..755f29cb0131 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
@@ -80,6 +80,8 @@ struct i40e_vf {
 	u16 port_vlan_id;
 	bool pf_set_mac;	/* The VMM admin set the VF MAC address */
 	bool trusted;
+	bool source_pruning;
+
 
 	/* VSI indices - actual VSI pointers are maintained in the PF structure
 	 * When assigned, these will be non-zero, because VSI 0 is always
-- 
2.38.1

