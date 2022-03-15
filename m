Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C014D9214
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 02:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344130AbiCOBNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 21:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344099AbiCOBMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 21:12:50 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCAA046B08
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 18:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647306699; x=1678842699;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V6tDgjE8doArrt/odgf3dhPksjGEQP1NLw5wdFTFrH8=;
  b=HWp7sgh3TwqjLzCkCFIS/m081PWqIGAp4crBvZoOyl3dd4qq0UzvPPjl
   TsNoPWRZdTr8pG7DT4VSA0DacN7Z+zAGZfcqt2IQG4eD+Q0b/FRsOWSiy
   rJqc0PqVIgKJvEfDOuom4W9DjZ8NC5vesX8kstIzEWFUWETCXLot3Hzdd
   dDHpatlowVIqscRbNAcHsdYsddtpG1GCy+UTTFCpwimykBT9l3yOWxQ5C
   2bUeoV1SSwJb4cysUHW59jrMY0dWuaHLXuBYEFYiZqXF1floEwkTrLgWx
   rQt/m0oLHJgAVcNOlOeRHT/9iynVbUPjxdPYoHfgu3v9QZjNKpruVXMl8
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="236790467"
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="236790467"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 18:11:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="540222899"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 14 Mar 2022 18:11:33 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next v2 08/11] ice: move ice_set_vf_port_vlan near other .ndo ops
Date:   Mon, 14 Mar 2022 18:11:52 -0700
Message-Id: <20220315011155.2166817-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220315011155.2166817-1-anthony.l.nguyen@intel.com>
References: <20220315011155.2166817-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The ice_set_vf_port_vlan function is located in ice_sriov.c very far
away from the other .ndo operations that it is similar to. Move this so
that its located near the other .ndo operation definitions.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c | 192 ++++++++++-----------
 1 file changed, 96 insertions(+), 96 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 8d22b5d94706..eebff1824be2 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -4249,102 +4249,6 @@ static int ice_vc_request_qs_msg(struct ice_vf *vf, u8 *msg)
 				     v_ret, (u8 *)vfres, sizeof(*vfres));
 }
 
-/**
- * ice_is_supported_port_vlan_proto - make sure the vlan_proto is supported
- * @hw: hardware structure used to check the VLAN mode
- * @vlan_proto: VLAN TPID being checked
- *
- * If the device is configured in Double VLAN Mode (DVM), then both ETH_P_8021Q
- * and ETH_P_8021AD are supported. If the device is configured in Single VLAN
- * Mode (SVM), then only ETH_P_8021Q is supported.
- */
-static bool
-ice_is_supported_port_vlan_proto(struct ice_hw *hw, u16 vlan_proto)
-{
-	bool is_supported = false;
-
-	switch (vlan_proto) {
-	case ETH_P_8021Q:
-		is_supported = true;
-		break;
-	case ETH_P_8021AD:
-		if (ice_is_dvm_ena(hw))
-			is_supported = true;
-		break;
-	}
-
-	return is_supported;
-}
-
-/**
- * ice_set_vf_port_vlan
- * @netdev: network interface device structure
- * @vf_id: VF identifier
- * @vlan_id: VLAN ID being set
- * @qos: priority setting
- * @vlan_proto: VLAN protocol
- *
- * program VF Port VLAN ID and/or QoS
- */
-int
-ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
-		     __be16 vlan_proto)
-{
-	struct ice_pf *pf = ice_netdev_to_pf(netdev);
-	u16 local_vlan_proto = ntohs(vlan_proto);
-	struct device *dev;
-	struct ice_vf *vf;
-	int ret;
-
-	dev = ice_pf_to_dev(pf);
-
-	if (vlan_id >= VLAN_N_VID || qos > 7) {
-		dev_err(dev, "Invalid Port VLAN parameters for VF %d, ID %d, QoS %d\n",
-			vf_id, vlan_id, qos);
-		return -EINVAL;
-	}
-
-	if (!ice_is_supported_port_vlan_proto(&pf->hw, local_vlan_proto)) {
-		dev_err(dev, "VF VLAN protocol 0x%04x is not supported\n",
-			local_vlan_proto);
-		return -EPROTONOSUPPORT;
-	}
-
-	vf = ice_get_vf_by_id(pf, vf_id);
-	if (!vf)
-		return -EINVAL;
-
-	ret = ice_check_vf_ready_for_cfg(vf);
-	if (ret)
-		goto out_put_vf;
-
-	if (ice_vf_get_port_vlan_prio(vf) == qos &&
-	    ice_vf_get_port_vlan_tpid(vf) == local_vlan_proto &&
-	    ice_vf_get_port_vlan_id(vf) == vlan_id) {
-		/* duplicate request, so just return success */
-		dev_dbg(dev, "Duplicate port VLAN %u, QoS %u, TPID 0x%04x request\n",
-			vlan_id, qos, local_vlan_proto);
-		ret = 0;
-		goto out_put_vf;
-	}
-
-	mutex_lock(&vf->cfg_lock);
-
-	vf->port_vlan_info = ICE_VLAN(local_vlan_proto, vlan_id, qos);
-	if (ice_vf_is_port_vlan_ena(vf))
-		dev_info(dev, "Setting VLAN %u, QoS %u, TPID 0x%04x on VF %d\n",
-			 vlan_id, qos, local_vlan_proto, vf_id);
-	else
-		dev_info(dev, "Clearing port VLAN on VF %d\n", vf_id);
-
-	ice_vc_reset_vf(vf);
-	mutex_unlock(&vf->cfg_lock);
-
-out_put_vf:
-	ice_put_vf(vf);
-	return ret;
-}
-
 /**
  * ice_vf_vlan_offload_ena - determine if capabilities support VLAN offloads
  * @caps: VF driver negotiated capabilities
@@ -6483,6 +6387,102 @@ int ice_get_vf_stats(struct net_device *netdev, int vf_id,
 	return ret;
 }
 
+/**
+ * ice_is_supported_port_vlan_proto - make sure the vlan_proto is supported
+ * @hw: hardware structure used to check the VLAN mode
+ * @vlan_proto: VLAN TPID being checked
+ *
+ * If the device is configured in Double VLAN Mode (DVM), then both ETH_P_8021Q
+ * and ETH_P_8021AD are supported. If the device is configured in Single VLAN
+ * Mode (SVM), then only ETH_P_8021Q is supported.
+ */
+static bool
+ice_is_supported_port_vlan_proto(struct ice_hw *hw, u16 vlan_proto)
+{
+	bool is_supported = false;
+
+	switch (vlan_proto) {
+	case ETH_P_8021Q:
+		is_supported = true;
+		break;
+	case ETH_P_8021AD:
+		if (ice_is_dvm_ena(hw))
+			is_supported = true;
+		break;
+	}
+
+	return is_supported;
+}
+
+/**
+ * ice_set_vf_port_vlan
+ * @netdev: network interface device structure
+ * @vf_id: VF identifier
+ * @vlan_id: VLAN ID being set
+ * @qos: priority setting
+ * @vlan_proto: VLAN protocol
+ *
+ * program VF Port VLAN ID and/or QoS
+ */
+int
+ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
+		     __be16 vlan_proto)
+{
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
+	u16 local_vlan_proto = ntohs(vlan_proto);
+	struct device *dev;
+	struct ice_vf *vf;
+	int ret;
+
+	dev = ice_pf_to_dev(pf);
+
+	if (vlan_id >= VLAN_N_VID || qos > 7) {
+		dev_err(dev, "Invalid Port VLAN parameters for VF %d, ID %d, QoS %d\n",
+			vf_id, vlan_id, qos);
+		return -EINVAL;
+	}
+
+	if (!ice_is_supported_port_vlan_proto(&pf->hw, local_vlan_proto)) {
+		dev_err(dev, "VF VLAN protocol 0x%04x is not supported\n",
+			local_vlan_proto);
+		return -EPROTONOSUPPORT;
+	}
+
+	vf = ice_get_vf_by_id(pf, vf_id);
+	if (!vf)
+		return -EINVAL;
+
+	ret = ice_check_vf_ready_for_cfg(vf);
+	if (ret)
+		goto out_put_vf;
+
+	if (ice_vf_get_port_vlan_prio(vf) == qos &&
+	    ice_vf_get_port_vlan_tpid(vf) == local_vlan_proto &&
+	    ice_vf_get_port_vlan_id(vf) == vlan_id) {
+		/* duplicate request, so just return success */
+		dev_dbg(dev, "Duplicate port VLAN %u, QoS %u, TPID 0x%04x request\n",
+			vlan_id, qos, local_vlan_proto);
+		ret = 0;
+		goto out_put_vf;
+	}
+
+	mutex_lock(&vf->cfg_lock);
+
+	vf->port_vlan_info = ICE_VLAN(local_vlan_proto, vlan_id, qos);
+	if (ice_vf_is_port_vlan_ena(vf))
+		dev_info(dev, "Setting VLAN %u, QoS %u, TPID 0x%04x on VF %d\n",
+			 vlan_id, qos, local_vlan_proto, vf_id);
+	else
+		dev_info(dev, "Clearing port VLAN on VF %d\n", vf_id);
+
+	ice_vc_reset_vf(vf);
+	mutex_unlock(&vf->cfg_lock);
+
+out_put_vf:
+	ice_put_vf(vf);
+	return ret;
+}
+
 /**
  * ice_print_vf_rx_mdd_event - print VF Rx malicious driver detect event
  * @vf: pointer to the VF structure
-- 
2.31.1

