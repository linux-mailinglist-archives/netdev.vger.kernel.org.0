Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 002D64AFFB0
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 23:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234832AbiBIV6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 16:58:10 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234530AbiBIV5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 16:57:20 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768B8E00FEC3
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 13:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644443838; x=1675979838;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mS2nQF53WsAzheWf/DdEFjFftgXgro/LjLvjllDwxJk=;
  b=CFloiO3VYjxHKBLZIR/LgIqC5+owz1n5o5TpQuylFHgex1sz+ksTAv5k
   2lFB/kKTVsk8HgGPUdjlwQLhUdkenQvUydo983e8DpgW2HguyiQ2KV7FL
   QTuwZTWk0foOVw0mxXE0g2SIdTKz+8hfPst3IE1PaIDdduTpdCOjCBTf9
   xjhv6cTmc+ntiZh1NSSikKNyl1/I0xX/eunHY/6fh7B01Tk4qirK122zp
   W/i872PUfm/Q3EBbJ94a+5Q9fiE4l3/XQkUanwbGjhSPMBoSxFdr8eWd7
   GGuFbAEOlxLRwNNnOzm3eeEpzvOmya+QNZSLmwDxmYDG5/FhDWk5eW4do
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="249104096"
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="249104096"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 13:57:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="601790492"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 09 Feb 2022 13:57:15 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 06/14] ice: Use the proto argument for VLAN ops
Date:   Wed,  9 Feb 2022 13:56:58 -0800
Message-Id: <20220209215706.2468371-7-anthony.l.nguyen@intel.com>
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

Currently the proto argument is unused. This is because the driver only
supports 802.1Q VLAN filtering. This policy is enforced via netdev
features that the driver sets up when configuring the netdev, so the
proto argument won't ever be anything other than 802.1Q. However, this
will allow for future iterations of the driver to seemlessly support
802.1ad filtering. Begin using the proto argument and extend the related
structures to support its use.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_fltr.c     |  2 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |  2 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 22 ++++-----
 drivers/net/ethernet/intel/ice/ice_switch.c   |  5 ++
 drivers/net/ethernet/intel/ice/ice_switch.h   |  2 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 10 ++--
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  2 +-
 drivers/net/ethernet/intel/ice/ice_vlan.h     |  3 +-
 .../net/ethernet/intel/ice/ice_vsi_vlan_lib.c | 48 ++++++++++++++++++-
 .../net/ethernet/intel/ice/ice_vsi_vlan_lib.h |  4 +-
 .../net/ethernet/intel/ice/ice_vsi_vlan_ops.h |  4 +-
 11 files changed, 78 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_fltr.c b/drivers/net/ethernet/intel/ice/ice_fltr.c
index 0e6c4f052686..af57eb114966 100644
--- a/drivers/net/ethernet/intel/ice/ice_fltr.c
+++ b/drivers/net/ethernet/intel/ice/ice_fltr.c
@@ -217,6 +217,8 @@ ice_fltr_add_vlan_to_list(struct ice_vsi *vsi, struct list_head *list,
 	info.fltr_act = ICE_FWD_TO_VSI;
 	info.vsi_handle = vsi->idx;
 	info.l_data.vlan.vlan_id = vlan->vid;
+	info.l_data.vlan.tpid = vlan->tpid;
+	info.l_data.vlan.tpid_valid = true;
 
 	return ice_fltr_add_entry_to_list(ice_pf_to_dev(vsi->back), &info,
 					  list);
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 58e796191a0f..08539c966b18 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3923,7 +3923,7 @@ int ice_vsi_add_vlan_zero(struct ice_vsi *vsi)
 {
 	struct ice_vlan vlan;
 
-	vlan = ICE_VLAN(0, 0);
+	vlan = ICE_VLAN(0, 0, 0);
 	return vsi->vlan_ops.add_vlan(vsi, &vlan);
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index cc13943a1d88..8ec36bd87a48 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3402,14 +3402,13 @@ ice_lb_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi)
 /**
  * ice_vlan_rx_add_vid - Add a VLAN ID filter to HW offload
  * @netdev: network interface to be adjusted
- * @proto: unused protocol
+ * @proto: VLAN TPID
  * @vid: VLAN ID to be added
  *
  * net_device_ops implementation for adding VLAN IDs
  */
 static int
-ice_vlan_rx_add_vid(struct net_device *netdev, __always_unused __be16 proto,
-		    u16 vid)
+ice_vlan_rx_add_vid(struct net_device *netdev, __be16 proto, u16 vid)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
@@ -3430,7 +3429,7 @@ ice_vlan_rx_add_vid(struct net_device *netdev, __always_unused __be16 proto,
 	/* Add a switch rule for this VLAN ID so its corresponding VLAN tagged
 	 * packets aren't pruned by the device's internal switch on Rx
 	 */
-	vlan = ICE_VLAN(vid, 0);
+	vlan = ICE_VLAN(be16_to_cpu(proto), vid, 0);
 	ret = vsi->vlan_ops.add_vlan(vsi, &vlan);
 	if (!ret)
 		set_bit(ICE_VSI_VLAN_FLTR_CHANGED, vsi->state);
@@ -3441,14 +3440,13 @@ ice_vlan_rx_add_vid(struct net_device *netdev, __always_unused __be16 proto,
 /**
  * ice_vlan_rx_kill_vid - Remove a VLAN ID filter from HW offload
  * @netdev: network interface to be adjusted
- * @proto: unused protocol
+ * @proto: VLAN TPID
  * @vid: VLAN ID to be removed
  *
  * net_device_ops implementation for removing VLAN IDs
  */
 static int
-ice_vlan_rx_kill_vid(struct net_device *netdev, __always_unused __be16 proto,
-		     u16 vid)
+ice_vlan_rx_kill_vid(struct net_device *netdev, __be16 proto, u16 vid)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
@@ -3462,7 +3460,7 @@ ice_vlan_rx_kill_vid(struct net_device *netdev, __always_unused __be16 proto,
 	/* Make sure VLAN delete is successful before updating VLAN
 	 * information
 	 */
-	vlan = ICE_VLAN(vid, 0);
+	vlan = ICE_VLAN(be16_to_cpu(proto), vid, 0);
 	ret = vsi->vlan_ops.del_vlan(vsi, &vlan);
 	if (ret)
 		return ret;
@@ -5608,14 +5606,14 @@ ice_set_features(struct net_device *netdev, netdev_features_t features)
 
 	if ((features & NETIF_F_HW_VLAN_CTAG_RX) &&
 	    !(netdev->features & NETIF_F_HW_VLAN_CTAG_RX))
-		ret = vsi->vlan_ops.ena_stripping(vsi);
+		ret = vsi->vlan_ops.ena_stripping(vsi, ETH_P_8021Q);
 	else if (!(features & NETIF_F_HW_VLAN_CTAG_RX) &&
 		 (netdev->features & NETIF_F_HW_VLAN_CTAG_RX))
 		ret = vsi->vlan_ops.dis_stripping(vsi);
 
 	if ((features & NETIF_F_HW_VLAN_CTAG_TX) &&
 	    !(netdev->features & NETIF_F_HW_VLAN_CTAG_TX))
-		ret = vsi->vlan_ops.ena_insertion(vsi);
+		ret = vsi->vlan_ops.ena_insertion(vsi, ETH_P_8021Q);
 	else if (!(features & NETIF_F_HW_VLAN_CTAG_TX) &&
 		 (netdev->features & NETIF_F_HW_VLAN_CTAG_TX))
 		ret = vsi->vlan_ops.dis_insertion(vsi);
@@ -5661,9 +5659,9 @@ static int ice_vsi_vlan_setup(struct ice_vsi *vsi)
 	int ret = 0;
 
 	if (vsi->netdev->features & NETIF_F_HW_VLAN_CTAG_RX)
-		ret = vsi->vlan_ops.ena_stripping(vsi);
+		ret = vsi->vlan_ops.ena_stripping(vsi, ETH_P_8021Q);
 	if (vsi->netdev->features & NETIF_F_HW_VLAN_CTAG_TX)
-		ret = vsi->vlan_ops.ena_insertion(vsi);
+		ret = vsi->vlan_ops.ena_insertion(vsi, ETH_P_8021Q);
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 11ae0bee3590..4213855f7961 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -1539,6 +1539,7 @@ ice_fill_sw_rule(struct ice_hw *hw, struct ice_fltr_info *f_info,
 		 struct ice_aqc_sw_rules_elem *s_rule, enum ice_adminq_opc opc)
 {
 	u16 vlan_id = ICE_MAX_VLAN_ID + 1;
+	u16 vlan_tpid = ETH_P_8021Q;
 	void *daddr = NULL;
 	u16 eth_hdr_sz;
 	u8 *eth_hdr;
@@ -1611,6 +1612,8 @@ ice_fill_sw_rule(struct ice_hw *hw, struct ice_fltr_info *f_info,
 		break;
 	case ICE_SW_LKUP_VLAN:
 		vlan_id = f_info->l_data.vlan.vlan_id;
+		if (f_info->l_data.vlan.tpid_valid)
+			vlan_tpid = f_info->l_data.vlan.tpid;
 		if (f_info->fltr_act == ICE_FWD_TO_VSI ||
 		    f_info->fltr_act == ICE_FWD_TO_VSI_LIST) {
 			act |= ICE_SINGLE_ACT_PRUNE;
@@ -1653,6 +1656,8 @@ ice_fill_sw_rule(struct ice_hw *hw, struct ice_fltr_info *f_info,
 	if (!(vlan_id > ICE_MAX_VLAN_ID)) {
 		off = (__force __be16 *)(eth_hdr + ICE_ETH_VLAN_TCI_OFFSET);
 		*off = cpu_to_be16(vlan_id);
+		off = (__force __be16 *)(eth_hdr + ICE_ETH_ETHTYPE_OFFSET);
+		*off = cpu_to_be16(vlan_tpid);
 	}
 
 	/* Create the switch rule with the final dummy Ethernet header */
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.h b/drivers/net/ethernet/intel/ice/ice_switch.h
index 4fb1a7ae5dbb..5000cc8276cd 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.h
+++ b/drivers/net/ethernet/intel/ice/ice_switch.h
@@ -77,6 +77,8 @@ struct ice_fltr_info {
 		} mac_vlan;
 		struct {
 			u16 vlan_id;
+			u16 tpid;
+			u8 tpid_valid;
 		} vlan;
 		/* Set lkup_type as ICE_SW_LKUP_ETHERTYPE
 		 * if just using ethertype as filter. Set lkup_type as
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index a36a80b64455..ce168307f005 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -4140,7 +4140,7 @@ ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
 
 	mutex_lock(&vf->cfg_lock);
 
-	vf->port_vlan_info = ICE_VLAN(vlan_id, qos);
+	vf->port_vlan_info = ICE_VLAN(ETH_P_8021Q, vlan_id, qos);
 	if (ice_vf_is_port_vlan_ena(vf))
 		dev_info(dev, "Setting VLAN %u, QoS %u on VF %d\n",
 			 vlan_id, qos, vf_id);
@@ -4261,7 +4261,7 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 			if (!vid)
 				continue;
 
-			vlan = ICE_VLAN(vid, 0);
+			vlan = ICE_VLAN(ETH_P_8021Q, vid, 0);
 			status = vsi->vlan_ops.add_vlan(vsi, &vlan);
 			if (status) {
 				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
@@ -4314,7 +4314,7 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 			if (!vid)
 				continue;
 
-			vlan = ICE_VLAN(vid, 0);
+			vlan = ICE_VLAN(ETH_P_8021Q, vid, 0);
 			status = vsi->vlan_ops.del_vlan(vsi, &vlan);
 			if (status) {
 				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
@@ -4393,7 +4393,7 @@ static int ice_vc_ena_vlan_stripping(struct ice_vf *vf)
 	}
 
 	vsi = ice_get_vf_vsi(vf);
-	if (vsi->vlan_ops.ena_stripping(vsi))
+	if (vsi->vlan_ops.ena_stripping(vsi, ETH_P_8021Q))
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 
 error_param:
@@ -4458,7 +4458,7 @@ static int ice_vf_init_vlan_stripping(struct ice_vf *vf)
 		return 0;
 
 	if (ice_vf_vlan_offload_ena(vf->driver_caps))
-		return vsi->vlan_ops.ena_stripping(vsi);
+		return vsi->vlan_ops.ena_stripping(vsi, ETH_P_8021Q);
 	else
 		return vsi->vlan_ops.dis_stripping(vsi);
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 5079a3b72698..b06ca1f97833 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -120,7 +120,7 @@ struct ice_vf {
 	struct ice_time_mac legacy_last_added_umac;
 	DECLARE_BITMAP(txq_ena, ICE_MAX_RSS_QS_PER_VF);
 	DECLARE_BITMAP(rxq_ena, ICE_MAX_RSS_QS_PER_VF);
-	struct ice_vlan port_vlan_info;	/* Port VLAN ID and QoS */
+	struct ice_vlan port_vlan_info;	/* Port VLAN ID, QoS, and TPID */
 	u8 pf_set_mac:1;		/* VF MAC address set by VMM admin */
 	u8 trusted:1;
 	u8 spoofchk:1;
diff --git a/drivers/net/ethernet/intel/ice/ice_vlan.h b/drivers/net/ethernet/intel/ice/ice_vlan.h
index 3fad0cba2da6..bc4550a03173 100644
--- a/drivers/net/ethernet/intel/ice/ice_vlan.h
+++ b/drivers/net/ethernet/intel/ice/ice_vlan.h
@@ -8,10 +8,11 @@
 #include "ice_type.h"
 
 struct ice_vlan {
+	u16 tpid;
 	u16 vid;
 	u8 prio;
 };
 
-#define ICE_VLAN(vid, prio) ((struct ice_vlan){ vid, prio })
+#define ICE_VLAN(tpid, vid, prio) ((struct ice_vlan){ tpid, vid, prio })
 
 #endif /* _ICE_VLAN_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c
index 74b6dec0744b..6b7feab0b2a1 100644
--- a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c
@@ -6,6 +6,31 @@
 #include "ice_fltr.h"
 #include "ice.h"
 
+static void print_invalid_tpid(struct ice_vsi *vsi, u16 tpid)
+{
+	dev_err(ice_pf_to_dev(vsi->back), "%s %d specified invalid VLAN tpid 0x%04x\n",
+		ice_vsi_type_str(vsi->type), vsi->idx, tpid);
+}
+
+/**
+ * validate_vlan - check if the ice_vlan passed in is valid
+ * @vsi: VSI used for printing error message
+ * @vlan: ice_vlan structure to validate
+ *
+ * Return true if the VLAN TPID is valid or if the VLAN TPID is 0 and the VLAN
+ * VID is 0, which allows for non-zero VLAN filters with the specified VLAN TPID
+ * and untagged VLAN 0 filters to be added to the prune list respectively.
+ */
+static bool validate_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan)
+{
+	if (vlan->tpid != ETH_P_8021Q && (vlan->tpid || vlan->vid)) {
+		print_invalid_tpid(vsi, vlan->tpid);
+		return false;
+	}
+
+	return true;
+}
+
 /**
  * ice_vsi_add_vlan - default add VLAN implementation for all VSI types
  * @vsi: VSI being configured
@@ -15,6 +40,9 @@ int ice_vsi_add_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan)
 {
 	int err = 0;
 
+	if (!validate_vlan(vsi, vlan))
+		return -EINVAL;
+
 	if (!ice_fltr_add_vlan(vsi, vlan)) {
 		vsi->num_vlan++;
 	} else {
@@ -37,6 +65,9 @@ int ice_vsi_del_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan)
 	struct device *dev;
 	int err;
 
+	if (!validate_vlan(vsi, vlan))
+		return -EINVAL;
+
 	dev = ice_pf_to_dev(pf);
 
 	err = ice_fltr_remove_vlan(vsi, vlan);
@@ -143,8 +174,13 @@ static int ice_vsi_manage_vlan_stripping(struct ice_vsi *vsi, bool ena)
 	return err;
 }
 
-int ice_vsi_ena_stripping(struct ice_vsi *vsi)
+int ice_vsi_ena_stripping(struct ice_vsi *vsi, const u16 tpid)
 {
+	if (tpid != ETH_P_8021Q) {
+		print_invalid_tpid(vsi, tpid);
+		return -EINVAL;
+	}
+
 	return ice_vsi_manage_vlan_stripping(vsi, true);
 }
 
@@ -153,8 +189,13 @@ int ice_vsi_dis_stripping(struct ice_vsi *vsi)
 	return ice_vsi_manage_vlan_stripping(vsi, false);
 }
 
-int ice_vsi_ena_insertion(struct ice_vsi *vsi)
+int ice_vsi_ena_insertion(struct ice_vsi *vsi, const u16 tpid)
 {
+	if (tpid != ETH_P_8021Q) {
+		print_invalid_tpid(vsi, tpid);
+		return -EINVAL;
+	}
+
 	return ice_vsi_manage_vlan_insertion(vsi);
 }
 
@@ -216,6 +257,9 @@ int ice_vsi_set_port_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan)
 {
 	u16 port_vlan_info;
 
+	if (vlan->tpid != ETH_P_8021Q)
+		return -EINVAL;
+
 	if (vlan->prio > 7)
 		return -EINVAL;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.h b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.h
index a0305007896c..1bdbf585db7d 100644
--- a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.h
@@ -12,9 +12,9 @@ struct ice_vsi;
 int ice_vsi_add_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan);
 int ice_vsi_del_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan);
 
-int ice_vsi_ena_stripping(struct ice_vsi *vsi);
+int ice_vsi_ena_stripping(struct ice_vsi *vsi, u16 tpid);
 int ice_vsi_dis_stripping(struct ice_vsi *vsi);
-int ice_vsi_ena_insertion(struct ice_vsi *vsi);
+int ice_vsi_ena_insertion(struct ice_vsi *vsi, u16 tpid);
 int ice_vsi_dis_insertion(struct ice_vsi *vsi);
 int ice_vsi_set_port_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_ops.h b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_ops.h
index c944f04acd3c..76e55b259bc8 100644
--- a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_ops.h
+++ b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_ops.h
@@ -12,9 +12,9 @@ struct ice_vsi;
 struct ice_vsi_vlan_ops {
 	int (*add_vlan)(struct ice_vsi *vsi, struct ice_vlan *vlan);
 	int (*del_vlan)(struct ice_vsi *vsi, struct ice_vlan *vlan);
-	int (*ena_stripping)(struct ice_vsi *vsi);
+	int (*ena_stripping)(struct ice_vsi *vsi, const u16 tpid);
 	int (*dis_stripping)(struct ice_vsi *vsi);
-	int (*ena_insertion)(struct ice_vsi *vsi);
+	int (*ena_insertion)(struct ice_vsi *vsi, const u16 tpid);
 	int (*dis_insertion)(struct ice_vsi *vsi);
 	int (*ena_rx_filtering)(struct ice_vsi *vsi);
 	int (*dis_rx_filtering)(struct ice_vsi *vsi);
-- 
2.31.1

