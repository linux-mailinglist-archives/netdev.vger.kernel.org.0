Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4355974DD
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 19:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241183AbiHQRN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 13:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236463AbiHQRNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 13:13:43 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E6B19C2F1
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 10:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660756418; x=1692292418;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4IiPaMXhgmMkrRvJcN6gL9Vjhv7UVkQI1/vhjhryprU=;
  b=FBrzK08CSLPvBDgnqiDmq8Nnxzlnw7JDVLojYKWrihjZHETdN9NVOGDS
   WA0thrcmerLvsnEHJznL3LBp2XSAEg7Kqpik5VJ2ta95eekkpkMTJrTpX
   z7mWQOrkzJ3JLWK/xqlfgaMXizT120Xs2j/FeB21YAxPckX8eFKvHl2Fx
   TuZSMWtKfaMAGdtElKjkerWOXa9H1LTSGe0WhtL2FJbm3LJOjH8JEPGri
   K4OxSYHDuQKJdPLp7ZhbKuYRGDyb9LteS+rUfRyT4jvsCZJgC+U6WIMXM
   0Ip+nxs9hEt+0gndXquW/Ga38gGT3rOpFnJeHta+rPLfRMM3Bvf/3r8e1
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="291307374"
X-IronPort-AV: E=Sophos;i="5.93,243,1654585200"; 
   d="scan'208";a="291307374"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 10:13:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,243,1654585200"; 
   d="scan'208";a="558204991"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 17 Aug 2022 10:13:36 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 5/5] ice: Fix VF not able to send tagged traffic with no VLAN filters
Date:   Wed, 17 Aug 2022 10:13:29 -0700
Message-Id: <20220817171329.65285-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220817171329.65285-1-anthony.l.nguyen@intel.com>
References: <20220817171329.65285-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>

VF was not able to send tagged traffic when it didn't
have any VLAN interfaces and VLAN anti-spoofing was enabled.
Fix this by allowing VFs with no VLAN filters to send tagged
traffic. After VF adds a VLAN interface it will be able to
send tagged traffic matching VLAN filters only.

Testing hints:
1. Spawn VF
2. Send tagged packet from a VF
3. The packet should be sent out and not dropped
4. Add a VLAN interface on VF
5. Send tagged packet on that VLAN interface
6. Packet should be sent out and not dropped
7. Send tagged packet with id different than VLAN interface
8. Packet should be dropped

Fixes: daf4dd16438b ("ice: Refactor spoofcheck configuration functions")
Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_vf_lib.c   | 11 ++--
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 57 ++++++++++++++++---
 2 files changed, 57 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 76f70fe1d998..0abeed092de1 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -764,13 +764,16 @@ static int ice_cfg_mac_antispoof(struct ice_vsi *vsi, bool enable)
 static int ice_vsi_ena_spoofchk(struct ice_vsi *vsi)
 {
 	struct ice_vsi_vlan_ops *vlan_ops;
-	int err;
+	int err = 0;
 
 	vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
 
-	err = vlan_ops->ena_tx_filtering(vsi);
-	if (err)
-		return err;
+	/* Allow VF with VLAN 0 only to send all tagged traffic */
+	if (vsi->type != ICE_VSI_VF || ice_vsi_has_non_zero_vlans(vsi)) {
+		err = vlan_ops->ena_tx_filtering(vsi);
+		if (err)
+			return err;
+	}
 
 	return ice_cfg_mac_antispoof(vsi, true);
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index 094e3c97a1ea..2b4c791b6cba 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -2288,6 +2288,15 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 
 			/* Enable VLAN filtering on first non-zero VLAN */
 			if (!vlan_promisc && vid && !ice_is_dvm_ena(&pf->hw)) {
+				if (vf->spoofchk) {
+					status = vsi->inner_vlan_ops.ena_tx_filtering(vsi);
+					if (status) {
+						v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+						dev_err(dev, "Enable VLAN anti-spoofing on VLAN ID: %d failed error-%d\n",
+							vid, status);
+						goto error_param;
+					}
+				}
 				if (vsi->inner_vlan_ops.ena_rx_filtering(vsi)) {
 					v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 					dev_err(dev, "Enable VLAN pruning on VLAN ID: %d failed error-%d\n",
@@ -2333,8 +2342,10 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 			}
 
 			/* Disable VLAN filtering when only VLAN 0 is left */
-			if (!ice_vsi_has_non_zero_vlans(vsi))
+			if (!ice_vsi_has_non_zero_vlans(vsi)) {
+				vsi->inner_vlan_ops.dis_tx_filtering(vsi);
 				vsi->inner_vlan_ops.dis_rx_filtering(vsi);
+			}
 
 			if (vlan_promisc)
 				ice_vf_dis_vlan_promisc(vsi, &vlan);
@@ -2838,6 +2849,13 @@ ice_vc_del_vlans(struct ice_vf *vf, struct ice_vsi *vsi,
 
 			if (vlan_promisc)
 				ice_vf_dis_vlan_promisc(vsi, &vlan);
+
+			/* Disable VLAN filtering when only VLAN 0 is left */
+			if (!ice_vsi_has_non_zero_vlans(vsi) && ice_is_dvm_ena(&vsi->back->hw)) {
+				err = vsi->outer_vlan_ops.dis_tx_filtering(vsi);
+				if (err)
+					return err;
+			}
 		}
 
 		vc_vlan = &vlan_fltr->inner;
@@ -2853,8 +2871,17 @@ ice_vc_del_vlans(struct ice_vf *vf, struct ice_vsi *vsi,
 			/* no support for VLAN promiscuous on inner VLAN unless
 			 * we are in Single VLAN Mode (SVM)
 			 */
-			if (!ice_is_dvm_ena(&vsi->back->hw) && vlan_promisc)
-				ice_vf_dis_vlan_promisc(vsi, &vlan);
+			if (!ice_is_dvm_ena(&vsi->back->hw)) {
+				if (vlan_promisc)
+					ice_vf_dis_vlan_promisc(vsi, &vlan);
+
+				/* Disable VLAN filtering when only VLAN 0 is left */
+				if (!ice_vsi_has_non_zero_vlans(vsi)) {
+					err = vsi->inner_vlan_ops.dis_tx_filtering(vsi);
+					if (err)
+						return err;
+				}
+			}
 		}
 	}
 
@@ -2931,6 +2958,13 @@ ice_vc_add_vlans(struct ice_vf *vf, struct ice_vsi *vsi,
 				if (err)
 					return err;
 			}
+
+			/* Enable VLAN filtering on first non-zero VLAN */
+			if (vf->spoofchk && vlan.vid && ice_is_dvm_ena(&vsi->back->hw)) {
+				err = vsi->outer_vlan_ops.ena_tx_filtering(vsi);
+				if (err)
+					return err;
+			}
 		}
 
 		vc_vlan = &vlan_fltr->inner;
@@ -2946,10 +2980,19 @@ ice_vc_add_vlans(struct ice_vf *vf, struct ice_vsi *vsi,
 			/* no support for VLAN promiscuous on inner VLAN unless
 			 * we are in Single VLAN Mode (SVM)
 			 */
-			if (!ice_is_dvm_ena(&vsi->back->hw) && vlan_promisc) {
-				err = ice_vf_ena_vlan_promisc(vsi, &vlan);
-				if (err)
-					return err;
+			if (!ice_is_dvm_ena(&vsi->back->hw)) {
+				if (vlan_promisc) {
+					err = ice_vf_ena_vlan_promisc(vsi, &vlan);
+					if (err)
+						return err;
+				}
+
+				/* Enable VLAN filtering on first non-zero VLAN */
+				if (vf->spoofchk && vlan.vid) {
+					err = vsi->inner_vlan_ops.ena_tx_filtering(vsi);
+					if (err)
+						return err;
+				}
 			}
 		}
 	}
-- 
2.35.1

