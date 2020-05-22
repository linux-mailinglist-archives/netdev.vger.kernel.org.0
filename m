Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 709101DE03A
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 08:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbgEVG4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 02:56:13 -0400
Received: from mga14.intel.com ([192.55.52.115]:18659 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728192AbgEVG4L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 02:56:11 -0400
IronPort-SDR: Z4OmkL/rMs2ZsXuCJql0QRUb8vTRI/Mm6abOpfAMIyC3zpgjsW8fQOC38BBKqTHsxMG56JM3te
 680W6K+a6WAQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 23:56:09 -0700
IronPort-SDR: BSgOQjkZRImw1T8A00t2RoDb5iKWJWRM2hLeFTverfbHW5qW0cQab41+PACdVp+GDQ5abYma4J
 xUtwzUavdCbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,420,1583222400"; 
   d="scan'208";a="290017742"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 21 May 2020 23:56:09 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 03/17] ice: Add VF promiscuous support
Date:   Thu, 21 May 2020 23:55:53 -0700
Message-Id: <20200522065607.1680050-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522065607.1680050-1-jeffrey.t.kirsher@intel.com>
References: <20200522065607.1680050-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Implement promiscuous support for VF VSIs. Behaviour of promiscuous support
is based on VF trust as well as the, introduced, vf-true-promisc flag.

A trusted VF with vf-true-promisc disabled will be the default VSI, which
means that all traffic without a matching destination MAC address in the
device's internal switch will be forwarded to this VF VSI.

A trusted VF with vf-true-promisc enabled will go into "true promiscuous
mode". This amounts to the VF receiving all ingress and egress traffic
that hits the device's internal switch.

An untrusted VF will only receive traffic destined for that VF.

The vf-true-promisc-support flag cannot be toggled while any VF is in
promiscuous mode. This flag should be set prior to loading the iavf driver
or spawning VF(s).

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |   1 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  12 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 206 +++++++++++++++++-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |   6 +
 4 files changed, 223 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 43349eaa02b2..ce7172901428 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -345,6 +345,7 @@ enum ice_pf_flags {
 	ICE_FLAG_FW_LLDP_AGENT,
 	ICE_FLAG_ETHTOOL_CTXT,		/* set when ethtool holds RTNL lock */
 	ICE_FLAG_LEGACY_RX,
+	ICE_FLAG_VF_TRUE_PROMISC_ENA,
 	ICE_FLAG_MDD_AUTO_RESET_VF,
 	ICE_PF_FLAGS_NBITS		/* must be last */
 };
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 593fb37bd59e..66d0bcc51ad9 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -157,6 +157,8 @@ struct ice_priv_flag {
 static const struct ice_priv_flag ice_gstrings_priv_flags[] = {
 	ICE_PRIV_FLAG("link-down-on-close", ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA),
 	ICE_PRIV_FLAG("fw-lldp-agent", ICE_FLAG_FW_LLDP_AGENT),
+	ICE_PRIV_FLAG("vf-true-promisc-support",
+		      ICE_FLAG_VF_TRUE_PROMISC_ENA),
 	ICE_PRIV_FLAG("mdd-auto-reset-vf", ICE_FLAG_MDD_AUTO_RESET_VF),
 	ICE_PRIV_FLAG("legacy-rx", ICE_FLAG_LEGACY_RX),
 };
@@ -1308,6 +1310,16 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 		ice_down(vsi);
 		ice_up(vsi);
 	}
+	/* don't allow modification of this flag when a single VF is in
+	 * promiscuous mode because it's not supported
+	 */
+	if (test_bit(ICE_FLAG_VF_TRUE_PROMISC_ENA, change_flags) &&
+	    ice_is_any_vf_in_promisc(pf)) {
+		dev_err(dev, "Changing vf-true-promisc-support flag while VF(s) are in promiscuous mode not supported\n");
+		/* toggle bit back to previous state */
+		change_bit(ICE_FLAG_VF_TRUE_PROMISC_ENA, pf->flags);
+		ret = -EAGAIN;
+	}
 	clear_bit(ICE_FLAG_ETHTOOL_CTXT, pf->flags);
 	return ret;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 15191a325918..1389d0d6d3d2 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -34,6 +34,37 @@ static int ice_check_vf_init(struct ice_pf *pf, struct ice_vf *vf)
 	return 0;
 }
 
+/**
+ * ice_err_to_virt_err - translate errors for VF return code
+ * @ice_err: error return code
+ */
+static enum virtchnl_status_code ice_err_to_virt_err(enum ice_status ice_err)
+{
+	switch (ice_err) {
+	case ICE_SUCCESS:
+		return VIRTCHNL_STATUS_SUCCESS;
+	case ICE_ERR_BAD_PTR:
+	case ICE_ERR_INVAL_SIZE:
+	case ICE_ERR_DEVICE_NOT_SUPPORTED:
+	case ICE_ERR_PARAM:
+	case ICE_ERR_CFG:
+		return VIRTCHNL_STATUS_ERR_PARAM;
+	case ICE_ERR_NO_MEMORY:
+		return VIRTCHNL_STATUS_ERR_NO_MEMORY;
+	case ICE_ERR_NOT_READY:
+	case ICE_ERR_RESET_FAILED:
+	case ICE_ERR_FW_API_VER:
+	case ICE_ERR_AQ_ERROR:
+	case ICE_ERR_AQ_TIMEOUT:
+	case ICE_ERR_AQ_FULL:
+	case ICE_ERR_AQ_NO_WORK:
+	case ICE_ERR_AQ_EMPTY:
+		return VIRTCHNL_STATUS_ERR_ADMIN_QUEUE_ERROR;
+	default:
+		return VIRTCHNL_STATUS_ERR_NOT_SUPPORTED;
+	}
+}
+
 /**
  * ice_vc_vf_broadcast - Broadcast a message to all VFs on PF
  * @pf: pointer to the PF structure
@@ -2059,6 +2090,173 @@ int ice_set_vf_spoofchk(struct net_device *netdev, int vf_id, bool ena)
 	return ret;
 }
 
+/**
+ * ice_is_any_vf_in_promisc - check if any VF(s) are in promiscuous mode
+ * @pf: PF structure for accessing VF(s)
+ *
+ * Return false if no VF(s) are in unicast and/or multicast promiscuous mode,
+ * else return true
+ */
+bool ice_is_any_vf_in_promisc(struct ice_pf *pf)
+{
+	int vf_idx;
+
+	ice_for_each_vf(pf, vf_idx) {
+		struct ice_vf *vf = &pf->vf[vf_idx];
+
+		/* found a VF that has promiscuous mode configured */
+		if (test_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states) ||
+		    test_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states))
+			return true;
+	}
+
+	return false;
+}
+
+/**
+ * ice_vc_cfg_promiscuous_mode_msg
+ * @vf: pointer to the VF info
+ * @msg: pointer to the msg buffer
+ *
+ * called from the VF to configure VF VSIs promiscuous mode
+ */
+static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
+{
+	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
+	struct virtchnl_promisc_info *info =
+	    (struct virtchnl_promisc_info *)msg;
+	struct ice_pf *pf = vf->pf;
+	struct ice_vsi *vsi;
+	struct device *dev;
+	bool rm_promisc;
+	int ret = 0;
+
+	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
+	}
+
+	if (!ice_vc_isvalid_vsi_id(vf, info->vsi_id)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
+	}
+
+	vsi = pf->vsi[vf->lan_vsi_idx];
+	if (!vsi) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
+	}
+
+	dev = ice_pf_to_dev(pf);
+	if (!test_bit(ICE_VIRTCHNL_VF_CAP_PRIVILEGE, &vf->vf_caps)) {
+		dev_err(dev, "Unprivileged VF %d is attempting to configure promiscuous mode\n",
+			vf->vf_id);
+		/* Leave v_ret alone, lie to the VF on purpose. */
+		goto error_param;
+	}
+
+	rm_promisc = !(info->flags & FLAG_VF_UNICAST_PROMISC) &&
+		!(info->flags & FLAG_VF_MULTICAST_PROMISC);
+
+	if (vsi->num_vlan || vf->port_vlan_info) {
+		struct ice_vsi *pf_vsi = ice_get_main_vsi(pf);
+		struct net_device *pf_netdev;
+
+		if (!pf_vsi) {
+			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+			goto error_param;
+		}
+
+		pf_netdev = pf_vsi->netdev;
+
+		ret = ice_set_vf_spoofchk(pf_netdev, vf->vf_id, rm_promisc);
+		if (ret) {
+			dev_err(dev, "Failed to update spoofchk to %s for VF %d VSI %d when setting promiscuous mode\n",
+				rm_promisc ? "ON" : "OFF", vf->vf_id,
+				vsi->vsi_num);
+			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		}
+
+		ret = ice_cfg_vlan_pruning(vsi, true, !rm_promisc);
+		if (ret) {
+			dev_err(dev, "Failed to configure VLAN pruning in promiscuous mode\n");
+			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+			goto error_param;
+		}
+	}
+
+	if (!test_bit(ICE_FLAG_VF_TRUE_PROMISC_ENA, pf->flags)) {
+		bool set_dflt_vsi = !!(info->flags & FLAG_VF_UNICAST_PROMISC);
+
+		if (set_dflt_vsi && !ice_is_dflt_vsi_in_use(pf->first_sw))
+			/* only attempt to set the default forwarding VSI if
+			 * it's not currently set
+			 */
+			ret = ice_set_dflt_vsi(pf->first_sw, vsi);
+		else if (!set_dflt_vsi &&
+			 ice_is_vsi_dflt_vsi(pf->first_sw, vsi))
+			/* only attempt to free the default forwarding VSI if we
+			 * are the owner
+			 */
+			ret = ice_clear_dflt_vsi(pf->first_sw);
+
+		if (ret) {
+			dev_err(dev, "%sable VF %d as the default VSI failed, error %d\n",
+				set_dflt_vsi ? "en" : "dis", vf->vf_id, ret);
+			v_ret = VIRTCHNL_STATUS_ERR_ADMIN_QUEUE_ERROR;
+			goto error_param;
+		}
+	} else {
+		enum ice_status status;
+		u8 promisc_m;
+
+		if (info->flags & FLAG_VF_UNICAST_PROMISC) {
+			if (vf->port_vlan_info || vsi->num_vlan)
+				promisc_m = ICE_UCAST_VLAN_PROMISC_BITS;
+			else
+				promisc_m = ICE_UCAST_PROMISC_BITS;
+		} else if (info->flags & FLAG_VF_MULTICAST_PROMISC) {
+			if (vf->port_vlan_info || vsi->num_vlan)
+				promisc_m = ICE_MCAST_VLAN_PROMISC_BITS;
+			else
+				promisc_m = ICE_MCAST_PROMISC_BITS;
+		} else {
+			if (vf->port_vlan_info || vsi->num_vlan)
+				promisc_m = ICE_UCAST_VLAN_PROMISC_BITS;
+			else
+				promisc_m = ICE_UCAST_PROMISC_BITS;
+		}
+
+		/* Configure multicast/unicast with or without VLAN promiscuous
+		 * mode
+		 */
+		status = ice_vf_set_vsi_promisc(vf, vsi, promisc_m, rm_promisc);
+		if (status) {
+			dev_err(dev, "%sable Tx/Rx filter promiscuous mode on VF-%d failed, error: %d\n",
+				rm_promisc ? "dis" : "en", vf->vf_id, status);
+			v_ret = ice_err_to_virt_err(status);
+			goto error_param;
+		} else {
+			dev_dbg(dev, "%sable Tx/Rx filter promiscuous mode on VF-%d succeeded\n",
+				rm_promisc ? "dis" : "en", vf->vf_id);
+		}
+	}
+
+	if (info->flags & FLAG_VF_MULTICAST_PROMISC)
+		set_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states);
+	else
+		clear_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states);
+
+	if (info->flags & FLAG_VF_UNICAST_PROMISC)
+		set_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states);
+	else
+		clear_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states);
+
+error_param:
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE,
+				     v_ret, NULL, 0);
+}
+
 /**
  * ice_vc_get_stats_msg
  * @vf: pointer to the VF info
@@ -2992,8 +3190,9 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 		goto error_param;
 	}
 
-	if (test_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states) ||
-	    test_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states))
+	if ((test_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states) ||
+	     test_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states)) &&
+	    test_bit(ICE_FLAG_VF_TRUE_PROMISC_ENA, pf->flags))
 		vlan_promisc = true;
 
 	if (add_v) {
@@ -3317,6 +3516,9 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 	case VIRTCHNL_OP_GET_STATS:
 		err = ice_vc_get_stats_msg(vf, msg);
 		break;
+	case VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE:
+		err = ice_vc_cfg_promiscuous_mode_msg(vf, msg);
+		break;
 	case VIRTCHNL_OP_ADD_VLAN:
 		err = ice_vc_add_vlan_msg(vf, msg);
 		break;
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 3f9464269bd2..f7fd1188efa4 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -128,6 +128,7 @@ void ice_set_vf_state_qs_dis(struct ice_vf *vf);
 int
 ice_get_vf_stats(struct net_device *netdev, int vf_id,
 		 struct ifla_vf_stats *vf_stats);
+bool ice_is_any_vf_in_promisc(struct ice_pf *pf);
 void
 ice_vf_lan_overflow_event(struct ice_pf *pf, struct ice_rq_event_info *event);
 void ice_print_vfs_mdd_events(struct ice_pf *pf);
@@ -219,5 +220,10 @@ ice_get_vf_stats(struct net_device __always_unused *netdev,
 {
 	return -EOPNOTSUPP;
 }
+
+static inline bool ice_is_any_vf_in_promisc(struct ice_pf __always_unused *pf)
+{
+	return false;
+}
 #endif /* CONFIG_PCI_IOV */
 #endif /* _ICE_VIRTCHNL_PF_H_ */
-- 
2.26.2

