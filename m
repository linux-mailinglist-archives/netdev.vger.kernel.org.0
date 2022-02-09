Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3C64AFFB3
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 23:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234625AbiBIV5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 16:57:55 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234626AbiBIV5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 16:57:39 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D588E00E598
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 13:57:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644443844; x=1675979844;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Xp5qQ6hLtW9um1yZ4Vzj7WPYwCyAqPTOcos4LQtxJn4=;
  b=l8yVpqZwp2VzMWJ5Sl+/QypWNjjDakzvZeiZ8Hl3iU2L8p8iYJHo0XO2
   3FNDH+2rbvXjLCXn/oZMsqgBLdUothK3zC920Gn/UMbjt4M5xgl4k/h1C
   tW8NXYeCToP0ySQrvvwOJIRneY3srCBajBbIlJ28Ubn0MDE6r1b2wvXQW
   k+S0+brxnrwL+eKbUj2k8lpxU0JGcxY5TjbU0iZOKdVPaJMb3Qc3odXdh
   +WKFLdve6GqfJmZCP2EXIuSRZHWPjEZZVUeeXIbpvFPcj09i+68O4vQTV
   HNMj7Ubw/y1Osg5FZFU4acCYNxMKISEJvWh1X4yoJiMaNqlf2NSEzeoxc
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="249104111"
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="249104111"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 13:57:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="601790521"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 09 Feb 2022 13:57:18 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 13/14] ice: Add support for 802.1ad port VLANs VF
Date:   Wed,  9 Feb 2022 13:57:05 -0800
Message-Id: <20220209215706.2468371-14-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220209215706.2468371-1-anthony.l.nguyen@intel.com>
References: <20220209215706.2468371-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently there is only support for 802.1Q port VLANs on SR-IOV VFs. Add
support to also allow 802.1ad port VLANs when double VLAN mode is
enabled.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 51 ++++++++++++++++---
 1 file changed, 44 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 68a515a87be7..9c43a7c8a45f 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -768,6 +768,11 @@ bool ice_vf_is_port_vlan_ena(struct ice_vf *vf)
 	return (ice_vf_get_port_vlan_id(vf) || ice_vf_get_port_vlan_prio(vf));
 }
 
+static u16 ice_vf_get_port_vlan_tpid(struct ice_vf *vf)
+{
+	return vf->port_vlan_info.tpid;
+}
+
 /**
  * ice_vf_rebuild_host_vlan_cfg - add VLAN 0 filter or rebuild the Port VLAN
  * @vf: VF to add MAC filters for
@@ -4130,6 +4135,33 @@ static int ice_vc_request_qs_msg(struct ice_vf *vf, u8 *msg)
 				     v_ret, (u8 *)vfres, sizeof(*vfres));
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
 /**
  * ice_set_vf_port_vlan
  * @netdev: network interface device structure
@@ -4145,6 +4177,7 @@ ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
 		     __be16 vlan_proto)
 {
 	struct ice_pf *pf = ice_netdev_to_pf(netdev);
+	u16 local_vlan_proto = ntohs(vlan_proto);
 	struct device *dev;
 	struct ice_vf *vf;
 	int ret;
@@ -4159,8 +4192,9 @@ ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
 		return -EINVAL;
 	}
 
-	if (vlan_proto != htons(ETH_P_8021Q)) {
-		dev_err(dev, "VF VLAN protocol is not supported\n");
+	if (!ice_is_supported_port_vlan_proto(&pf->hw, local_vlan_proto)) {
+		dev_err(dev, "VF VLAN protocol 0x%04x is not supported\n",
+			local_vlan_proto);
 		return -EPROTONOSUPPORT;
 	}
 
@@ -4170,19 +4204,20 @@ ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
 		return ret;
 
 	if (ice_vf_get_port_vlan_prio(vf) == qos &&
+	    ice_vf_get_port_vlan_tpid(vf) == local_vlan_proto &&
 	    ice_vf_get_port_vlan_id(vf) == vlan_id) {
 		/* duplicate request, so just return success */
-		dev_dbg(dev, "Duplicate port VLAN %u, QoS %u request\n",
-			vlan_id, qos);
+		dev_dbg(dev, "Duplicate port VLAN %u, QoS %u, TPID 0x%04x request\n",
+			vlan_id, qos, local_vlan_proto);
 		return 0;
 	}
 
 	mutex_lock(&vf->cfg_lock);
 
-	vf->port_vlan_info = ICE_VLAN(ETH_P_8021Q, vlan_id, qos);
+	vf->port_vlan_info = ICE_VLAN(local_vlan_proto, vlan_id, qos);
 	if (ice_vf_is_port_vlan_ena(vf))
-		dev_info(dev, "Setting VLAN %u, QoS %u on VF %d\n",
-			 vlan_id, qos, vf_id);
+		dev_info(dev, "Setting VLAN %u, QoS %u, TPID 0x%04x on VF %d\n",
+			 vlan_id, qos, local_vlan_proto, vf_id);
 	else
 		dev_info(dev, "Clearing port VLAN on VF %d\n", vf_id);
 
@@ -5905,6 +5940,8 @@ ice_get_vf_cfg(struct net_device *netdev, int vf_id, struct ifla_vf_info *ivi)
 	/* VF configuration for VLAN and applicable QoS */
 	ivi->vlan = ice_vf_get_port_vlan_id(vf);
 	ivi->qos = ice_vf_get_port_vlan_prio(vf);
+	if (ice_vf_is_port_vlan_ena(vf))
+		ivi->vlan_proto = cpu_to_be16(ice_vf_get_port_vlan_tpid(vf));
 
 	ivi->trusted = vf->trusted;
 	ivi->spoofchk = vf->spoofchk;
-- 
2.31.1

