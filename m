Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F249E314578
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 02:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbhBIBRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 20:17:05 -0500
Received: from mga07.intel.com ([134.134.136.100]:36361 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229669AbhBIBRB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 20:17:01 -0500
IronPort-SDR: XvnBMU29Nz+HWAL9s7SXtJ9TaTi0KHl7k8d6Sn6ysQ77M0JKOFUBA6Fk7ztZZF90N7i1GOP0h9
 B6FXirYEV2Jw==
X-IronPort-AV: E=McAfee;i="6000,8403,9889"; a="245879729"
X-IronPort-AV: E=Sophos;i="5.81,163,1610438400"; 
   d="scan'208";a="245879729"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 17:15:46 -0800
IronPort-SDR: aeOTBiv4069C1a4GSy36M8POufw5Zohrc/k9PW/elKKPfitMtOu8BE42VsfiM+2XeaJdpj20tM
 bDXt67TOE+kw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,163,1610438400"; 
   d="scan'208";a="487669587"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 08 Feb 2021 17:15:46 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 01/12] ice: log message when trusted VF goes in/out of promisc mode
Date:   Mon,  8 Feb 2021 17:16:25 -0800
Message-Id: <20210209011636.1989093-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210209011636.1989093-1-anthony.l.nguyen@intel.com>
References: <20210209011636.1989093-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently there is no message printed on the host when a VF goes in and
out of promiscuous mode. This is causing confusion because this is the
expected behavior based on i40e. Fix this.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 32 +++++++++++--------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index ec7f6c64132e..d0c3a5342aa9 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -2312,12 +2312,12 @@ bool ice_is_any_vf_in_promisc(struct ice_pf *pf)
 static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
 {
 	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
+	bool rm_promisc, alluni = false, allmulti = false;
 	struct virtchnl_promisc_info *info =
 	    (struct virtchnl_promisc_info *)msg;
 	struct ice_pf *pf = vf->pf;
 	struct ice_vsi *vsi;
 	struct device *dev;
-	bool rm_promisc;
 	int ret = 0;
 
 	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
@@ -2344,8 +2344,13 @@ static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
 		goto error_param;
 	}
 
-	rm_promisc = !(info->flags & FLAG_VF_UNICAST_PROMISC) &&
-		!(info->flags & FLAG_VF_MULTICAST_PROMISC);
+	if (info->flags & FLAG_VF_UNICAST_PROMISC)
+		alluni = true;
+
+	if (info->flags & FLAG_VF_MULTICAST_PROMISC)
+		allmulti = true;
+
+	rm_promisc = !allmulti && !alluni;
 
 	if (vsi->num_vlan || vf->port_vlan_info) {
 		struct ice_vsi *pf_vsi = ice_get_main_vsi(pf);
@@ -2399,12 +2404,12 @@ static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
 		enum ice_status status;
 		u8 promisc_m;
 
-		if (info->flags & FLAG_VF_UNICAST_PROMISC) {
+		if (alluni) {
 			if (vf->port_vlan_info || vsi->num_vlan)
 				promisc_m = ICE_UCAST_VLAN_PROMISC_BITS;
 			else
 				promisc_m = ICE_UCAST_PROMISC_BITS;
-		} else if (info->flags & FLAG_VF_MULTICAST_PROMISC) {
+		} else if (allmulti) {
 			if (vf->port_vlan_info || vsi->num_vlan)
 				promisc_m = ICE_MCAST_VLAN_PROMISC_BITS;
 			else
@@ -2432,15 +2437,16 @@ static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
 		}
 	}
 
-	if (info->flags & FLAG_VF_MULTICAST_PROMISC)
-		set_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states);
-	else
-		clear_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states);
+	if (allmulti &&
+	    !test_and_set_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states))
+		dev_info(dev, "VF %u successfully set multicast promiscuous mode\n", vf->vf_id);
+	else if (!allmulti && test_and_clear_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states))
+		dev_info(dev, "VF %u successfully unset multicast promiscuous mode\n", vf->vf_id);
 
-	if (info->flags & FLAG_VF_UNICAST_PROMISC)
-		set_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states);
-	else
-		clear_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states);
+	if (alluni && !test_and_set_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states))
+		dev_info(dev, "VF %u successfully set unicast promiscuous mode\n", vf->vf_id);
+	else if (!alluni && test_and_clear_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states))
+		dev_info(dev, "VF %u successfully unset unicast promiscuous mode\n", vf->vf_id);
 
 error_param:
 	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE,
-- 
2.26.2

