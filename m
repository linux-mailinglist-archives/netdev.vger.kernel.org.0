Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8430243E800
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 20:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbhJ1SLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 14:11:14 -0400
Received: from mga03.intel.com ([134.134.136.65]:46223 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230520AbhJ1SLK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 14:11:10 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10151"; a="230427776"
X-IronPort-AV: E=Sophos;i="5.87,190,1631602800"; 
   d="scan'208";a="230427776"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2021 11:08:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,190,1631602800"; 
   d="scan'208";a="725849078"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 28 Oct 2021 11:08:42 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 5/9] ice: send correct vc status in switchdev
Date:   Thu, 28 Oct 2021 11:06:55 -0700
Message-Id: <20211028180659.218912-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211028180659.218912-1-anthony.l.nguyen@intel.com>
References: <20211028180659.218912-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

Part of virtchannel messages are treated in different way in switchdev
mode to block configuring VFs from iavf driver side. This blocking was
done by doing nothing and returning success, event without sending
response.

Not sending response for opcodes that aren't supported in switchdev mode
leads to block iavf driver message handling. This happens for example
when vlan is configured at VF config time (VLAN module is already
loaded).

To get rid of it ice driver should answer for each VF message. In
switchdev mode:
- for adding/deleting VLAN driver should answer success without doing
  anything to allow creating vlan device on VFs
- for enabling/disabling VLAN stripping  and promiscuous mode driver
  should answer not supported, this feature in switchdev can be only
  set from host side

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 63 ++++++++++++++-----
 1 file changed, 49 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index a42eaf6f942e..6a74344a3c21 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -4499,13 +4499,6 @@ void ice_vc_set_dflt_vf_ops(struct ice_vc_vf_ops *ops)
 	*ops = ice_vc_vf_dflt_ops;
 }
 
-static int
-ice_vc_repr_no_action_msg(struct ice_vf __always_unused *vf,
-			  u8 __always_unused *msg)
-{
-	return 0;
-}
-
 /**
  * ice_vc_repr_add_mac
  * @vf: pointer to VF
@@ -4581,20 +4574,62 @@ ice_vc_repr_del_mac(struct ice_vf __always_unused *vf, u8 __always_unused *msg)
 				     VIRTCHNL_STATUS_SUCCESS, NULL, 0);
 }
 
-static int ice_vc_repr_no_action(struct ice_vf __always_unused *vf)
+static int ice_vc_repr_add_vlan(struct ice_vf *vf, u8 __always_unused *msg)
 {
-	return 0;
+	dev_dbg(ice_pf_to_dev(vf->pf),
+		"Can't add VLAN in switchdev mode for VF %d\n", vf->vf_id);
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ADD_VLAN,
+				     VIRTCHNL_STATUS_SUCCESS, NULL, 0);
+}
+
+static int ice_vc_repr_del_vlan(struct ice_vf *vf, u8 __always_unused *msg)
+{
+	dev_dbg(ice_pf_to_dev(vf->pf),
+		"Can't delete VLAN in switchdev mode for VF %d\n", vf->vf_id);
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DEL_VLAN,
+				     VIRTCHNL_STATUS_SUCCESS, NULL, 0);
+}
+
+static int ice_vc_repr_ena_vlan_stripping(struct ice_vf *vf)
+{
+	dev_dbg(ice_pf_to_dev(vf->pf),
+		"Can't enable VLAN stripping in switchdev mode for VF %d\n",
+		vf->vf_id);
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_STRIPPING,
+				     VIRTCHNL_STATUS_ERR_NOT_SUPPORTED,
+				     NULL, 0);
+}
+
+static int ice_vc_repr_dis_vlan_stripping(struct ice_vf *vf)
+{
+	dev_dbg(ice_pf_to_dev(vf->pf),
+		"Can't disable VLAN stripping in switchdev mode for VF %d\n",
+		vf->vf_id);
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_STRIPPING,
+				     VIRTCHNL_STATUS_ERR_NOT_SUPPORTED,
+				     NULL, 0);
+}
+
+static int
+ice_vc_repr_cfg_promiscuous_mode(struct ice_vf *vf, u8 __always_unused *msg)
+{
+	dev_dbg(ice_pf_to_dev(vf->pf),
+		"Can't config promiscuous mode in switchdev mode for VF %d\n",
+		vf->vf_id);
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE,
+				     VIRTCHNL_STATUS_ERR_NOT_SUPPORTED,
+				     NULL, 0);
 }
 
 void ice_vc_change_ops_to_repr(struct ice_vc_vf_ops *ops)
 {
 	ops->add_mac_addr_msg = ice_vc_repr_add_mac;
 	ops->del_mac_addr_msg = ice_vc_repr_del_mac;
-	ops->add_vlan_msg = ice_vc_repr_no_action_msg;
-	ops->remove_vlan_msg = ice_vc_repr_no_action_msg;
-	ops->ena_vlan_stripping = ice_vc_repr_no_action;
-	ops->dis_vlan_stripping = ice_vc_repr_no_action;
-	ops->cfg_promiscuous_mode_msg = ice_vc_repr_no_action_msg;
+	ops->add_vlan_msg = ice_vc_repr_add_vlan;
+	ops->remove_vlan_msg = ice_vc_repr_del_vlan;
+	ops->ena_vlan_stripping = ice_vc_repr_ena_vlan_stripping;
+	ops->dis_vlan_stripping = ice_vc_repr_dis_vlan_stripping;
+	ops->cfg_promiscuous_mode_msg = ice_vc_repr_cfg_promiscuous_mode;
 }
 
 /**
-- 
2.31.1

