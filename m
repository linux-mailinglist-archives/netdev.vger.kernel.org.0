Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50C2B4AFFA7
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 22:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234643AbiBIV5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 16:57:44 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234575AbiBIV5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 16:57:20 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F676E010DBF
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 13:57:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644443839; x=1675979839;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tuWMR+rT/qfqa/qi3OmEN/gqd0sDsUZTM5dV8+Ai7bE=;
  b=O+t9TJpKiVMKmR53M+4c9m9NyIQvZXgjh5f02/G57k0vend7pN0vOfym
   dbfNFXI38mH4ZPAANmBxvY5zYjDy4nuzFIO4PW5ieW2lqtlk3dMUQljCL
   /wPLgebGHsbHrWDpEJaRSyOPWj51TqUXlBV8Vs1TGCCQW13V5iRoaoqD2
   4e3C7/evrZ0KcvOc9ielhdAp4xItEnaL6G/6Ajm6sq5ju5lcWpOyyYXxP
   Y2Qa64f6yYwRrkaGD+TxtkdrrvxqUHCftQT4mcZuaXZ8VF8/ujmuThd7U
   /sRbsnzmn4j0eh8Ew5N0DxALGj2UmsZkmqOMbrqPrIyIhEGvFLnVMTjUx
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="249104100"
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="249104100"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 13:57:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="601790501"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 09 Feb 2022 13:57:16 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 08/14] ice: Add outer_vlan_ops and VSI specific VLAN ops implementations
Date:   Wed,  9 Feb 2022 13:57:00 -0800
Message-Id: <20220209215706.2468371-9-anthony.l.nguyen@intel.com>
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

Add a new outer_vlan_ops member to the ice_vsi structure as outer VLAN
ops are only available when the device is in Double VLAN Mode (DVM).
Depending on the VSI type, the requirements for what operations to
use/allow differ.

By default all VSI's have unsupported inner and outer VSI VLAN ops. This
implementation was chosen to prevent unexpected crashes due to null
pointer dereferences. Instead, if a VSI calls an unsupported op, it will
just return -EOPNOTSUPP.

Add implementations to support modifying outer VLAN fields for VSI
context. This includes the ability to modify VLAN stripping, insertion,
and the port VLAN based on the outer VLAN handling fields of the VSI
context.

These functions should only ever be used if DVM is enabled because that
means the firmware supports the outer VLAN fields in the VSI context. If
the device is in DVM, then always use the outer_vlan_ops, else use the
vlan_ops since the device is in Single VLAN Mode (SVM).

Also, move adding the untagged VLAN 0 filter from ice_vsi_setup() to
ice_vsi_vlan_setup() as the latter function is specific to the PF and
all other VSI types that need an untagged VLAN 0 filter already do this
in their specific flows. Without this change, Flow Director is failing
to initialize because it does not implement any VSI VLAN ops.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/Makefile       |   9 +-
 drivers/net/ethernet/intel/ice/ice.h          |   3 +-
 drivers/net/ethernet/intel/ice/ice_eswitch.c  |   5 +-
 drivers/net/ethernet/intel/ice/ice_lib.c      | 111 +++++-
 drivers/net/ethernet/intel/ice/ice_lib.h      |   3 +
 drivers/net/ethernet/intel/ice/ice_main.c     |  60 +--
 .../ethernet/intel/ice/ice_pf_vsi_vlan_ops.c  |  37 ++
 .../ethernet/intel/ice/ice_pf_vsi_vlan_ops.h  |  13 +
 .../ethernet/intel/ice/ice_vf_vsi_vlan_ops.c  |  72 ++++
 .../ethernet/intel/ice/ice_vf_vsi_vlan_ops.h  |  16 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 101 +++--
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |   6 +
 .../net/ethernet/intel/ice/ice_vsi_vlan_lib.c | 344 +++++++++++++++++-
 .../net/ethernet/intel/ice/ice_vsi_vlan_lib.h |   6 +
 .../net/ethernet/intel/ice/ice_vsi_vlan_ops.c | 107 +++++-
 .../net/ethernet/intel/ice/ice_vsi_vlan_ops.h |   6 +
 16 files changed, 813 insertions(+), 86 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_pf_vsi_vlan_ops.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_pf_vsi_vlan_ops.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.h

diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index 935e1786ae0b..d0c4db00590c 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -18,6 +18,7 @@ ice-y := ice_main.o	\
 	 ice_txrx_lib.o	\
 	 ice_txrx.o	\
 	 ice_fltr.o	\
+	 ice_pf_vsi_vlan_ops.o \
 	 ice_vsi_vlan_ops.o \
 	 ice_vsi_vlan_lib.o \
 	 ice_fdir.o	\
@@ -31,8 +32,12 @@ ice-y := ice_main.o	\
 	 ice_ethtool.o  \
 	 ice_repr.o	\
 	 ice_tc_lib.o
-ice-$(CONFIG_PCI_IOV) += ice_virtchnl_allowlist.o
-ice-$(CONFIG_PCI_IOV) += ice_virtchnl_pf.o ice_sriov.o ice_virtchnl_fdir.o
+ice-$(CONFIG_PCI_IOV) +=	\
+	ice_virtchnl_allowlist.o \
+	ice_virtchnl_fdir.o	\
+	ice_sriov.o		\
+	ice_vf_vsi_vlan_ops.o	\
+	ice_virtchnl_pf.o
 ice-$(CONFIG_PTP_1588_CLOCK) += ice_ptp.o ice_ptp_hw.o
 ice-$(CONFIG_DCB) += ice_dcb.o ice_dcb_nl.o ice_dcb_lib.o
 ice-$(CONFIG_RFS_ACCEL) += ice_arfs.o
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index c5e8e38eedee..55f32fca619b 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -369,7 +369,8 @@ struct ice_vsi {
 	u8 irqs_ready:1;
 	u8 current_isup:1;		 /* Sync 'link up' logging */
 	u8 stat_offsets_loaded:1;
-	struct ice_vsi_vlan_ops vlan_ops;
+	struct ice_vsi_vlan_ops inner_vlan_ops;
+	struct ice_vsi_vlan_ops outer_vlan_ops;
 	u16 num_vlan;
 
 	/* queue information */
diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
index eeac993668ae..e1cb6682eee2 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -115,9 +115,12 @@ static int ice_eswitch_setup_env(struct ice_pf *pf)
 	struct ice_vsi *uplink_vsi = pf->switchdev.uplink_vsi;
 	struct net_device *uplink_netdev = uplink_vsi->netdev;
 	struct ice_vsi *ctrl_vsi = pf->switchdev.control_vsi;
+	struct ice_vsi_vlan_ops *vlan_ops;
 	bool rule_added = false;
 
-	ctrl_vsi->vlan_ops.dis_stripping(ctrl_vsi);
+	vlan_ops = ice_get_compat_vsi_vlan_ops(ctrl_vsi);
+	if (vlan_ops->dis_stripping(ctrl_vsi))
+		return -ENODEV;
 
 	ice_remove_vsi_fltr(&pf->hw, uplink_vsi->idx);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index d6a1c10fa2b6..27a673b016f0 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -8,6 +8,7 @@
 #include "ice_fltr.h"
 #include "ice_dcb_lib.h"
 #include "ice_devlink.h"
+#include "ice_vsi_vlan_ops.h"
 
 /**
  * ice_vsi_type_str - maps VSI type enum to string equivalents
@@ -2458,17 +2459,6 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 		if (ret)
 			goto unroll_vector_base;
 
-		/* Always add VLAN ID 0 switch rule by default. This is needed
-		 * in order to allow all untagged and 0 tagged priority traffic
-		 * if Rx VLAN pruning is enabled. Also there are cases where we
-		 * don't get the call to add VLAN 0 via ice_vlan_rx_add_vid()
-		 * so this handles those cases (i.e. adding the PF to a bridge
-		 * without the 8021q module loaded).
-		 */
-		ret = ice_vsi_add_vlan_zero(vsi);
-		if (ret)
-			goto unroll_clear_rings;
-
 		ice_vsi_map_rings_to_vectors(vsi);
 
 		/* ICE_VSI_CTRL does not need RSS so skip RSS processing */
@@ -3918,13 +3908,110 @@ int ice_set_link(struct ice_vsi *vsi, bool ena)
 /**
  * ice_vsi_add_vlan_zero - add VLAN 0 filter(s) for this VSI
  * @vsi: VSI used to add VLAN filters
+ *
+ * In Single VLAN Mode (SVM), single VLAN filters via ICE_SW_LKUP_VLAN are based
+ * on the inner VLAN ID, so the VLAN TPID (i.e. 0x8100 or 0x888a8) doesn't
+ * matter. In Double VLAN Mode (DVM), outer/single VLAN filters via
+ * ICE_SW_LKUP_VLAN are based on the outer/single VLAN ID + VLAN TPID.
+ *
+ * For both modes add a VLAN 0 + no VLAN TPID filter to handle untagged traffic
+ * when VLAN pruning is enabled. Also, this handles VLAN 0 priority tagged
+ * traffic in SVM, since the VLAN TPID isn't part of filtering.
+ *
+ * If DVM is enabled then an explicit VLAN 0 + VLAN TPID filter needs to be
+ * added to allow VLAN 0 priority tagged traffic in DVM, since the VLAN TPID is
+ * part of filtering.
  */
 int ice_vsi_add_vlan_zero(struct ice_vsi *vsi)
 {
+	struct ice_vsi_vlan_ops *vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
+	struct ice_vlan vlan;
+	int err;
+
+	vlan = ICE_VLAN(0, 0, 0);
+	err = vlan_ops->add_vlan(vsi, &vlan);
+	if (err && err != -EEXIST)
+		return err;
+
+	/* in SVM both VLAN 0 filters are identical */
+	if (!ice_is_dvm_ena(&vsi->back->hw))
+		return 0;
+
+	vlan = ICE_VLAN(ETH_P_8021Q, 0, 0);
+	err = vlan_ops->add_vlan(vsi, &vlan);
+	if (err && err != -EEXIST)
+		return err;
+
+	return 0;
+}
+
+/**
+ * ice_vsi_del_vlan_zero - delete VLAN 0 filter(s) for this VSI
+ * @vsi: VSI used to add VLAN filters
+ *
+ * Delete the VLAN 0 filters in the same manner that they were added in
+ * ice_vsi_add_vlan_zero.
+ */
+int ice_vsi_del_vlan_zero(struct ice_vsi *vsi)
+{
+	struct ice_vsi_vlan_ops *vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
 	struct ice_vlan vlan;
+	int err;
 
 	vlan = ICE_VLAN(0, 0, 0);
-	return vsi->vlan_ops.add_vlan(vsi, &vlan);
+	err = vlan_ops->del_vlan(vsi, &vlan);
+	if (err && err != -EEXIST)
+		return err;
+
+	/* in SVM both VLAN 0 filters are identical */
+	if (!ice_is_dvm_ena(&vsi->back->hw))
+		return 0;
+
+	vlan = ICE_VLAN(ETH_P_8021Q, 0, 0);
+	err = vlan_ops->del_vlan(vsi, &vlan);
+	if (err && err != -EEXIST)
+		return err;
+
+	return 0;
+}
+
+/**
+ * ice_vsi_num_zero_vlans - get number of VLAN 0 filters based on VLAN mode
+ * @vsi: VSI used to get the VLAN mode
+ *
+ * If DVM is enabled then 2 VLAN 0 filters are added, else if SVM is enabled
+ * then 1 VLAN 0 filter is added. See ice_vsi_add_vlan_zero for more details.
+ */
+static u16 ice_vsi_num_zero_vlans(struct ice_vsi *vsi)
+{
+#define ICE_DVM_NUM_ZERO_VLAN_FLTRS	2
+#define ICE_SVM_NUM_ZERO_VLAN_FLTRS	1
+	/* no VLAN 0 filter is created when a port VLAN is active */
+	if (vsi->type == ICE_VSI_VF &&
+	    ice_vf_is_port_vlan_ena(&vsi->back->vf[vsi->vf_id]))
+		return 0;
+	if (ice_is_dvm_ena(&vsi->back->hw))
+		return ICE_DVM_NUM_ZERO_VLAN_FLTRS;
+	else
+		return ICE_SVM_NUM_ZERO_VLAN_FLTRS;
+}
+
+/**
+ * ice_vsi_has_non_zero_vlans - check if VSI has any non-zero VLANs
+ * @vsi: VSI used to determine if any non-zero VLANs have been added
+ */
+bool ice_vsi_has_non_zero_vlans(struct ice_vsi *vsi)
+{
+	return (vsi->num_vlan > ice_vsi_num_zero_vlans(vsi));
+}
+
+/**
+ * ice_vsi_num_non_zero_vlans - get the number of non-zero VLANs for this VSI
+ * @vsi: VSI used to get the number of non-zero VLANs added
+ */
+u16 ice_vsi_num_non_zero_vlans(struct ice_vsi *vsi)
+{
+	return (vsi->num_vlan - ice_vsi_num_zero_vlans(vsi));
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index e3dabc9ec64e..133fc235141a 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -123,6 +123,9 @@ void ice_vsi_ctx_set_allow_override(struct ice_vsi_ctx *ctx);
 
 void ice_vsi_ctx_clear_allow_override(struct ice_vsi_ctx *ctx);
 int ice_vsi_add_vlan_zero(struct ice_vsi *vsi);
+int ice_vsi_del_vlan_zero(struct ice_vsi *vsi);
+bool ice_vsi_has_non_zero_vlans(struct ice_vsi *vsi);
+u16 ice_vsi_num_non_zero_vlans(struct ice_vsi *vsi);
 bool ice_is_feature_supported(struct ice_pf *pf, enum ice_feature f);
 void ice_clear_feature_support(struct ice_pf *pf, enum ice_feature f);
 void ice_init_feature_support(struct ice_pf *pf);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 9b85498067b9..a1497c809cf3 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -21,6 +21,7 @@
 #include "ice_trace.h"
 #include "ice_eswitch.h"
 #include "ice_tc_lib.h"
+#include "ice_vsi_vlan_ops.h"
 
 #define DRV_SUMMARY	"Intel(R) Ethernet Connection E800 Series Linux Driver"
 static const char ice_driver_string[] = DRV_SUMMARY;
@@ -244,7 +245,7 @@ static int ice_set_promisc(struct ice_vsi *vsi, u8 promisc_m)
 	if (vsi->type != ICE_VSI_PF)
 		return 0;
 
-	if (vsi->num_vlan > 1)
+	if (ice_vsi_has_non_zero_vlans(vsi))
 		status = ice_fltr_set_vlan_vsi_promisc(&vsi->back->hw, vsi, promisc_m);
 	else
 		status = ice_fltr_set_vsi_promisc(&vsi->back->hw, vsi->idx, promisc_m, 0);
@@ -264,7 +265,7 @@ static int ice_clear_promisc(struct ice_vsi *vsi, u8 promisc_m)
 	if (vsi->type != ICE_VSI_PF)
 		return 0;
 
-	if (vsi->num_vlan > 1)
+	if (ice_vsi_has_non_zero_vlans(vsi))
 		status = ice_fltr_clear_vlan_vsi_promisc(&vsi->back->hw, vsi, promisc_m);
 	else
 		status = ice_fltr_clear_vsi_promisc(&vsi->back->hw, vsi->idx, promisc_m, 0);
@@ -279,6 +280,7 @@ static int ice_clear_promisc(struct ice_vsi *vsi, u8 promisc_m)
  */
 static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 {
+	struct ice_vsi_vlan_ops *vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
 	struct device *dev = ice_pf_to_dev(vsi->back);
 	struct net_device *netdev = vsi->netdev;
 	bool promisc_forced_on = false;
@@ -352,7 +354,7 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 	/* check for changes in promiscuous modes */
 	if (changed_flags & IFF_ALLMULTI) {
 		if (vsi->current_netdev_flags & IFF_ALLMULTI) {
-			if (vsi->num_vlan > 1)
+			if (ice_vsi_has_non_zero_vlans(vsi))
 				promisc_m = ICE_MCAST_VLAN_PROMISC_BITS;
 			else
 				promisc_m = ICE_MCAST_PROMISC_BITS;
@@ -366,7 +368,7 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 			}
 		} else {
 			/* !(vsi->current_netdev_flags & IFF_ALLMULTI) */
-			if (vsi->num_vlan > 1)
+			if (ice_vsi_has_non_zero_vlans(vsi))
 				promisc_m = ICE_MCAST_VLAN_PROMISC_BITS;
 			else
 				promisc_m = ICE_MCAST_PROMISC_BITS;
@@ -396,7 +398,7 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 					goto out_promisc;
 				}
 				err = 0;
-				vsi->vlan_ops.dis_rx_filtering(vsi);
+				vlan_ops->dis_rx_filtering(vsi);
 			}
 		} else {
 			/* Clear Rx filter to remove traffic from wire */
@@ -410,7 +412,7 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 					goto out_promisc;
 				}
 				if (vsi->num_vlan > 1)
-					vsi->vlan_ops.ena_rx_filtering(vsi);
+					vlan_ops->ena_rx_filtering(vsi);
 			}
 		}
 	}
@@ -3411,6 +3413,7 @@ static int
 ice_vlan_rx_add_vid(struct net_device *netdev, __be16 proto, u16 vid)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_vsi_vlan_ops *vlan_ops;
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_vlan vlan;
 	int ret;
@@ -3419,9 +3422,11 @@ ice_vlan_rx_add_vid(struct net_device *netdev, __be16 proto, u16 vid)
 	if (!vid)
 		return 0;
 
+	vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
+
 	/* Enable VLAN pruning when a VLAN other than 0 is added */
 	if (!ice_vsi_is_vlan_pruning_ena(vsi)) {
-		ret = vsi->vlan_ops.ena_rx_filtering(vsi);
+		ret = vlan_ops->ena_rx_filtering(vsi);
 		if (ret)
 			return ret;
 	}
@@ -3430,7 +3435,7 @@ ice_vlan_rx_add_vid(struct net_device *netdev, __be16 proto, u16 vid)
 	 * packets aren't pruned by the device's internal switch on Rx
 	 */
 	vlan = ICE_VLAN(be16_to_cpu(proto), vid, 0);
-	ret = vsi->vlan_ops.add_vlan(vsi, &vlan);
+	ret = vlan_ops->add_vlan(vsi, &vlan);
 	if (!ret)
 		set_bit(ICE_VSI_VLAN_FLTR_CHANGED, vsi->state);
 
@@ -3449,6 +3454,7 @@ static int
 ice_vlan_rx_kill_vid(struct net_device *netdev, __be16 proto, u16 vid)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_vsi_vlan_ops *vlan_ops;
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_vlan vlan;
 	int ret;
@@ -3457,17 +3463,19 @@ ice_vlan_rx_kill_vid(struct net_device *netdev, __be16 proto, u16 vid)
 	if (!vid)
 		return 0;
 
+	vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
+
 	/* Make sure VLAN delete is successful before updating VLAN
 	 * information
 	 */
 	vlan = ICE_VLAN(be16_to_cpu(proto), vid, 0);
-	ret = vsi->vlan_ops.del_vlan(vsi, &vlan);
+	ret = vlan_ops->del_vlan(vsi, &vlan);
 	if (ret)
 		return ret;
 
 	/* Disable pruning when VLAN 0 is the only VLAN rule */
 	if (vsi->num_vlan == 1 && ice_vsi_is_vlan_pruning_ena(vsi))
-		vsi->vlan_ops.dis_rx_filtering(vsi);
+		vlan_ops->dis_rx_filtering(vsi);
 
 	set_bit(ICE_VSI_VLAN_FLTR_CHANGED, vsi->state);
 	return ret;
@@ -5579,6 +5587,7 @@ static int
 ice_set_features(struct net_device *netdev, netdev_features_t features)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_vsi_vlan_ops *vlan_ops;
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
 	int ret = 0;
@@ -5595,6 +5604,8 @@ ice_set_features(struct net_device *netdev, netdev_features_t features)
 		return -EBUSY;
 	}
 
+	vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
+
 	/* Multiple features can be changed in one call so keep features in
 	 * separate if/else statements to guarantee each feature is checked
 	 */
@@ -5606,24 +5617,24 @@ ice_set_features(struct net_device *netdev, netdev_features_t features)
 
 	if ((features & NETIF_F_HW_VLAN_CTAG_RX) &&
 	    !(netdev->features & NETIF_F_HW_VLAN_CTAG_RX))
-		ret = vsi->vlan_ops.ena_stripping(vsi, ETH_P_8021Q);
+		ret = vlan_ops->ena_stripping(vsi, ETH_P_8021Q);
 	else if (!(features & NETIF_F_HW_VLAN_CTAG_RX) &&
 		 (netdev->features & NETIF_F_HW_VLAN_CTAG_RX))
-		ret = vsi->vlan_ops.dis_stripping(vsi);
+		ret = vlan_ops->dis_stripping(vsi);
 
 	if ((features & NETIF_F_HW_VLAN_CTAG_TX) &&
 	    !(netdev->features & NETIF_F_HW_VLAN_CTAG_TX))
-		ret = vsi->vlan_ops.ena_insertion(vsi, ETH_P_8021Q);
+		ret = vlan_ops->ena_insertion(vsi, ETH_P_8021Q);
 	else if (!(features & NETIF_F_HW_VLAN_CTAG_TX) &&
 		 (netdev->features & NETIF_F_HW_VLAN_CTAG_TX))
-		ret = vsi->vlan_ops.dis_insertion(vsi);
+		ret = vlan_ops->dis_insertion(vsi);
 
 	if ((features & NETIF_F_HW_VLAN_CTAG_FILTER) &&
 	    !(netdev->features & NETIF_F_HW_VLAN_CTAG_FILTER))
-		ret = vsi->vlan_ops.ena_rx_filtering(vsi);
+		ret = vlan_ops->ena_rx_filtering(vsi);
 	else if (!(features & NETIF_F_HW_VLAN_CTAG_FILTER) &&
 		 (netdev->features & NETIF_F_HW_VLAN_CTAG_FILTER))
-		ret = vsi->vlan_ops.dis_rx_filtering(vsi);
+		ret = vlan_ops->dis_rx_filtering(vsi);
 
 	if ((features & NETIF_F_NTUPLE) &&
 	    !(netdev->features & NETIF_F_NTUPLE)) {
@@ -5651,19 +5662,21 @@ ice_set_features(struct net_device *netdev, netdev_features_t features)
 }
 
 /**
- * ice_vsi_vlan_setup - Setup VLAN offload properties on a VSI
+ * ice_vsi_vlan_setup - Setup VLAN offload properties on a PF VSI
  * @vsi: VSI to setup VLAN properties for
  */
 static int ice_vsi_vlan_setup(struct ice_vsi *vsi)
 {
-	int ret = 0;
+	struct ice_vsi_vlan_ops *vlan_ops;
+
+	vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
 
 	if (vsi->netdev->features & NETIF_F_HW_VLAN_CTAG_RX)
-		ret = vsi->vlan_ops.ena_stripping(vsi, ETH_P_8021Q);
+		vlan_ops->ena_stripping(vsi, ETH_P_8021Q);
 	if (vsi->netdev->features & NETIF_F_HW_VLAN_CTAG_TX)
-		ret = vsi->vlan_ops.ena_insertion(vsi, ETH_P_8021Q);
+		vlan_ops->ena_insertion(vsi, ETH_P_8021Q);
 
-	return ret;
+	return ice_vsi_add_vlan_zero(vsi);
 }
 
 /**
@@ -6264,11 +6277,12 @@ static void ice_napi_disable_all(struct ice_vsi *vsi)
  */
 int ice_down(struct ice_vsi *vsi)
 {
-	int i, tx_err, rx_err, link_err = 0;
+	int i, tx_err, rx_err, link_err = 0, vlan_err = 0;
 
 	WARN_ON(!test_bit(ICE_VSI_DOWN, vsi->state));
 
 	if (vsi->netdev && vsi->type == ICE_VSI_PF) {
+		vlan_err = ice_vsi_del_vlan_zero(vsi);
 		if (!ice_is_e810(&vsi->back->hw))
 			ice_ptp_link_change(vsi->back, vsi->back->hw.pf_id, false);
 		netif_carrier_off(vsi->netdev);
@@ -6310,7 +6324,7 @@ int ice_down(struct ice_vsi *vsi)
 	ice_for_each_rxq(vsi, i)
 		ice_clean_rx_ring(vsi->rx_rings[i]);
 
-	if (tx_err || rx_err || link_err) {
+	if (tx_err || rx_err || link_err || vlan_err) {
 		netdev_err(vsi->netdev, "Failed to close VSI 0x%04X on switch 0x%04X\n",
 			   vsi->vsi_num, vsi->vsw->sw_id);
 		return -EIO;
diff --git a/drivers/net/ethernet/intel/ice/ice_pf_vsi_vlan_ops.c b/drivers/net/ethernet/intel/ice/ice_pf_vsi_vlan_ops.c
new file mode 100644
index 000000000000..b00360ca6e92
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_pf_vsi_vlan_ops.c
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2019-2021, Intel Corporation. */
+
+#include "ice_vsi_vlan_ops.h"
+#include "ice_vsi_vlan_lib.h"
+#include "ice.h"
+#include "ice_pf_vsi_vlan_ops.h"
+
+void ice_pf_vsi_init_vlan_ops(struct ice_vsi *vsi)
+{
+	struct ice_vsi_vlan_ops *vlan_ops;
+
+	if (ice_is_dvm_ena(&vsi->back->hw)) {
+		vlan_ops = &vsi->outer_vlan_ops;
+
+		vlan_ops->add_vlan = ice_vsi_add_vlan;
+		vlan_ops->del_vlan = ice_vsi_del_vlan;
+		vlan_ops->ena_stripping = ice_vsi_ena_outer_stripping;
+		vlan_ops->dis_stripping = ice_vsi_dis_outer_stripping;
+		vlan_ops->ena_insertion = ice_vsi_ena_outer_insertion;
+		vlan_ops->dis_insertion = ice_vsi_dis_outer_insertion;
+		vlan_ops->ena_rx_filtering = ice_vsi_ena_rx_vlan_filtering;
+		vlan_ops->dis_rx_filtering = ice_vsi_dis_rx_vlan_filtering;
+	} else {
+		vlan_ops = &vsi->inner_vlan_ops;
+
+		vlan_ops->add_vlan = ice_vsi_add_vlan;
+		vlan_ops->del_vlan = ice_vsi_del_vlan;
+		vlan_ops->ena_stripping = ice_vsi_ena_inner_stripping;
+		vlan_ops->dis_stripping = ice_vsi_dis_inner_stripping;
+		vlan_ops->ena_insertion = ice_vsi_ena_inner_insertion;
+		vlan_ops->dis_insertion = ice_vsi_dis_inner_insertion;
+		vlan_ops->ena_rx_filtering = ice_vsi_ena_rx_vlan_filtering;
+		vlan_ops->dis_rx_filtering = ice_vsi_dis_rx_vlan_filtering;
+	}
+}
+
diff --git a/drivers/net/ethernet/intel/ice/ice_pf_vsi_vlan_ops.h b/drivers/net/ethernet/intel/ice/ice_pf_vsi_vlan_ops.h
new file mode 100644
index 000000000000..6741ec8c5f6b
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_pf_vsi_vlan_ops.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2019-2021, Intel Corporation. */
+
+#ifndef _ICE_PF_VSI_VLAN_OPS_H_
+#define _ICE_PF_VSI_VLAN_OPS_H_
+
+#include "ice_vsi_vlan_ops.h"
+
+struct ice_vsi;
+
+void ice_pf_vsi_init_vlan_ops(struct ice_vsi *vsi);
+
+#endif /* _ICE_PF_VSI_VLAN_OPS_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c b/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c
new file mode 100644
index 000000000000..741b041606a2
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c
@@ -0,0 +1,72 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2019-2021, Intel Corporation. */
+
+#include "ice_vsi_vlan_ops.h"
+#include "ice_vsi_vlan_lib.h"
+#include "ice.h"
+#include "ice_vf_vsi_vlan_ops.h"
+#include "ice_virtchnl_pf.h"
+
+static int
+noop_vlan_arg(struct ice_vsi __always_unused *vsi,
+	      struct ice_vlan __always_unused *vlan)
+{
+	return 0;
+}
+
+/**
+ * ice_vf_vsi_init_vlan_ops - Initialize default VSI VLAN ops for VF VSI
+ * @vsi: VF's VSI being configured
+ */
+void ice_vf_vsi_init_vlan_ops(struct ice_vsi *vsi)
+{
+	struct ice_vsi_vlan_ops *vlan_ops;
+	struct ice_pf *pf = vsi->back;
+	struct ice_vf *vf;
+
+	vf = &pf->vf[vsi->vf_id];
+
+	if (ice_is_dvm_ena(&pf->hw)) {
+		vlan_ops = &vsi->outer_vlan_ops;
+
+		/* outer VLAN ops regardless of port VLAN config */
+		vlan_ops->add_vlan = ice_vsi_add_vlan;
+		vlan_ops->ena_rx_filtering = ice_vsi_ena_rx_vlan_filtering;
+		vlan_ops->dis_rx_filtering = ice_vsi_dis_rx_vlan_filtering;
+		vlan_ops->ena_tx_filtering = ice_vsi_ena_tx_vlan_filtering;
+		vlan_ops->dis_tx_filtering = ice_vsi_dis_tx_vlan_filtering;
+
+		if (ice_vf_is_port_vlan_ena(vf)) {
+			/* setup outer VLAN ops */
+			vlan_ops->set_port_vlan = ice_vsi_set_outer_port_vlan;
+
+			/* setup inner VLAN ops */
+			vlan_ops = &vsi->inner_vlan_ops;
+			vlan_ops->add_vlan = noop_vlan_arg;
+			vlan_ops->del_vlan = noop_vlan_arg;
+			vlan_ops->ena_stripping = ice_vsi_ena_inner_stripping;
+			vlan_ops->dis_stripping = ice_vsi_dis_inner_stripping;
+			vlan_ops->ena_insertion = ice_vsi_ena_inner_insertion;
+			vlan_ops->dis_insertion = ice_vsi_dis_inner_insertion;
+		}
+	} else {
+		vlan_ops = &vsi->inner_vlan_ops;
+
+		/* inner VLAN ops regardless of port VLAN config */
+		vlan_ops->add_vlan = ice_vsi_add_vlan;
+		vlan_ops->ena_rx_filtering = ice_vsi_ena_rx_vlan_filtering;
+		vlan_ops->dis_rx_filtering = ice_vsi_dis_rx_vlan_filtering;
+		vlan_ops->ena_tx_filtering = ice_vsi_ena_tx_vlan_filtering;
+		vlan_ops->dis_tx_filtering = ice_vsi_dis_tx_vlan_filtering;
+
+		if (ice_vf_is_port_vlan_ena(vf)) {
+			vlan_ops->set_port_vlan = ice_vsi_set_inner_port_vlan;
+		} else {
+			vlan_ops->del_vlan = ice_vsi_del_vlan;
+			vlan_ops->ena_stripping = ice_vsi_ena_inner_stripping;
+			vlan_ops->dis_stripping = ice_vsi_dis_inner_stripping;
+			vlan_ops->ena_insertion = ice_vsi_ena_inner_insertion;
+			vlan_ops->dis_insertion = ice_vsi_dis_inner_insertion;
+		}
+	}
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.h b/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.h
new file mode 100644
index 000000000000..8ea13628a5e1
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2019-2021, Intel Corporation. */
+
+#ifndef _ICE_VF_VSI_VLAN_OPS_H_
+#define _ICE_VF_VSI_VLAN_OPS_H_
+
+#include "ice_vsi_vlan_ops.h"
+
+struct ice_vsi;
+
+#ifdef CONFIG_PCI_IOV
+void ice_vf_vsi_init_vlan_ops(struct ice_vsi *vsi);
+#else
+static inline void ice_vf_vsi_init_vlan_ops(struct ice_vsi *vsi) { }
+#endif /* CONFIG_PCI_IOV */
+#endif /* _ICE_PF_VSI_VLAN_OPS_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index ce168307f005..e63e0664e44b 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -10,6 +10,7 @@
 #include "ice_eswitch.h"
 #include "ice_virtchnl_allowlist.h"
 #include "ice_flex_pipe.h"
+#include "ice_vf_vsi_vlan_ops.h"
 
 #define FIELD_SELECTOR(proto_hdr_field) \
 		BIT((proto_hdr_field) & PROTO_HDR_FIELD_MASK)
@@ -761,7 +762,7 @@ static u8 ice_vf_get_port_vlan_prio(struct ice_vf *vf)
 	return vf->port_vlan_info.prio;
 }
 
-static bool ice_vf_is_port_vlan_ena(struct ice_vf *vf)
+bool ice_vf_is_port_vlan_ena(struct ice_vf *vf)
 {
 	return (ice_vf_get_port_vlan_id(vf) || ice_vf_get_port_vlan_prio(vf));
 }
@@ -769,26 +770,30 @@ static bool ice_vf_is_port_vlan_ena(struct ice_vf *vf)
 /**
  * ice_vf_rebuild_host_vlan_cfg - add VLAN 0 filter or rebuild the Port VLAN
  * @vf: VF to add MAC filters for
+ * @vsi: Pointer to VSI
  *
  * Called after a VF VSI has been re-added/rebuilt during reset. The PF driver
  * always re-adds either a VLAN 0 or port VLAN based filter after reset.
  */
-static int ice_vf_rebuild_host_vlan_cfg(struct ice_vf *vf)
+static int ice_vf_rebuild_host_vlan_cfg(struct ice_vf *vf, struct ice_vsi *vsi)
 {
+	struct ice_vsi_vlan_ops *vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
 	struct device *dev = ice_pf_to_dev(vf->pf);
-	struct ice_vsi *vsi = ice_get_vf_vsi(vf);
 	int err;
 
 	if (ice_vf_is_port_vlan_ena(vf)) {
-		err = vsi->vlan_ops.set_port_vlan(vsi, &vf->port_vlan_info);
+		err = vlan_ops->set_port_vlan(vsi, &vf->port_vlan_info);
 		if (err) {
 			dev_err(dev, "failed to configure port VLAN via VSI parameters for VF %u, error %d\n",
 				vf->vf_id, err);
 			return err;
 		}
+
+		err = vlan_ops->add_vlan(vsi, &vf->port_vlan_info);
+	} else {
+		err = ice_vsi_add_vlan_zero(vsi);
 	}
 
-	err = vsi->vlan_ops.add_vlan(vsi, &vf->port_vlan_info);
 	if (err) {
 		dev_err(dev, "failed to add VLAN %u filter for VF %u during VF rebuild, error %d\n",
 			ice_vf_is_port_vlan_ena(vf) ?
@@ -834,9 +839,12 @@ static int ice_cfg_mac_antispoof(struct ice_vsi *vsi, bool enable)
  */
 static int ice_vsi_ena_spoofchk(struct ice_vsi *vsi)
 {
+	struct ice_vsi_vlan_ops *vlan_ops;
 	int err;
 
-	err = vsi->vlan_ops.ena_tx_filtering(vsi);
+	vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
+
+	err = vlan_ops->ena_tx_filtering(vsi);
 	if (err)
 		return err;
 
@@ -849,9 +857,12 @@ static int ice_vsi_ena_spoofchk(struct ice_vsi *vsi)
  */
 static int ice_vsi_dis_spoofchk(struct ice_vsi *vsi)
 {
+	struct ice_vsi_vlan_ops *vlan_ops;
 	int err;
 
-	err = vsi->vlan_ops.dis_tx_filtering(vsi);
+	vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
+
+	err = vlan_ops->dis_tx_filtering(vsi);
 	if (err)
 		return err;
 
@@ -1269,7 +1280,7 @@ ice_vf_set_vsi_promisc(struct ice_vf *vf, struct ice_vsi *vsi, u8 promisc_m)
 	if (ice_vf_is_port_vlan_ena(vf))
 		status = ice_fltr_set_vsi_promisc(hw, vsi->idx, promisc_m,
 						  ice_vf_get_port_vlan_id(vf));
-	else if (vsi->num_vlan > 1)
+	else if (ice_vsi_has_non_zero_vlans(vsi))
 		status = ice_fltr_set_vlan_vsi_promisc(hw, vsi, promisc_m);
 	else
 		status = ice_fltr_set_vsi_promisc(hw, vsi->idx, promisc_m, 0);
@@ -1292,7 +1303,7 @@ ice_vf_clear_vsi_promisc(struct ice_vf *vf, struct ice_vsi *vsi, u8 promisc_m)
 	if (ice_vf_is_port_vlan_ena(vf))
 		status = ice_fltr_clear_vsi_promisc(hw, vsi->idx, promisc_m,
 						    ice_vf_get_port_vlan_id(vf));
-	else if (vsi->num_vlan > 1)
+	else if (ice_vsi_has_non_zero_vlans(vsi))
 		status = ice_fltr_clear_vlan_vsi_promisc(hw, vsi, promisc_m);
 	else
 		status = ice_fltr_clear_vsi_promisc(hw, vsi->idx, promisc_m, 0);
@@ -1377,7 +1388,7 @@ static void ice_vf_rebuild_host_cfg(struct ice_vf *vf)
 		dev_err(dev, "failed to rebuild default MAC configuration for VF %d\n",
 			vf->vf_id);
 
-	if (ice_vf_rebuild_host_vlan_cfg(vf))
+	if (ice_vf_rebuild_host_vlan_cfg(vf, vsi))
 		dev_err(dev, "failed to rebuild VLAN configuration for VF %u\n",
 			vf->vf_id);
 
@@ -3023,6 +3034,7 @@ static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
 	bool rm_promisc, alluni = false, allmulti = false;
 	struct virtchnl_promisc_info *info =
 	    (struct virtchnl_promisc_info *)msg;
+	struct ice_vsi_vlan_ops *vlan_ops;
 	int mcast_err = 0, ucast_err = 0;
 	struct ice_pf *pf = vf->pf;
 	struct ice_vsi *vsi;
@@ -3061,16 +3073,15 @@ static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
 
 	rm_promisc = !allmulti && !alluni;
 
-	if (vsi->num_vlan || ice_vf_is_port_vlan_ena(vf)) {
-		if (rm_promisc)
-			ret = vsi->vlan_ops.ena_rx_filtering(vsi);
-		else
-			ret = vsi->vlan_ops.dis_rx_filtering(vsi);
-		if (ret) {
-			dev_err(dev, "Failed to configure VLAN pruning in promiscuous mode\n");
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-			goto error_param;
-		}
+	vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
+	if (rm_promisc)
+		ret = vlan_ops->ena_rx_filtering(vsi);
+	else
+		ret = vlan_ops->dis_rx_filtering(vsi);
+	if (ret) {
+		dev_err(dev, "Failed to configure VLAN pruning in promiscuous mode\n");
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
 	}
 
 	if (!test_bit(ICE_FLAG_VF_TRUE_PROMISC_ENA, pf->flags)) {
@@ -3097,7 +3108,8 @@ static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
 	} else {
 		u8 mcast_m, ucast_m;
 
-		if (ice_vf_is_port_vlan_ena(vf) || vsi->num_vlan > 1) {
+		if (ice_vf_is_port_vlan_ena(vf) ||
+		    ice_vsi_has_non_zero_vlans(vsi)) {
 			mcast_m = ICE_MCAST_VLAN_PROMISC_BITS;
 			ucast_m = ICE_UCAST_VLAN_PROMISC_BITS;
 		} else {
@@ -4164,6 +4176,27 @@ static bool ice_vf_vlan_offload_ena(u32 caps)
 	return !!(caps & VIRTCHNL_VF_OFFLOAD_VLAN);
 }
 
+/**
+ * ice_vf_has_max_vlans - check if VF already has the max allowed VLAN filters
+ * @vf: VF to check against
+ * @vsi: VF's VSI
+ *
+ * If the VF is trusted then the VF is allowed to add as many VLANs as it
+ * wants to, so return false.
+ *
+ * When the VF is untrusted compare the number of non-zero VLANs + 1 to the max
+ * allowed VLANs for an untrusted VF. Return the result of this comparison.
+ */
+static bool ice_vf_has_max_vlans(struct ice_vf *vf, struct ice_vsi *vsi)
+{
+	if (ice_is_vf_trusted(vf))
+		return false;
+
+#define ICE_VF_ADDED_VLAN_ZERO_FLTRS	1
+	return ((ice_vsi_num_non_zero_vlans(vsi) +
+		ICE_VF_ADDED_VLAN_ZERO_FLTRS) >= ICE_MAX_VLAN_PER_VF);
+}
+
 /**
  * ice_vc_process_vlan_msg
  * @vf: pointer to the VF info
@@ -4177,6 +4210,7 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
 	struct virtchnl_vlan_filter_list *vfl =
 	    (struct virtchnl_vlan_filter_list *)msg;
+	struct ice_vsi_vlan_ops *vlan_ops;
 	struct ice_pf *pf = vf->pf;
 	bool vlan_promisc = false;
 	struct ice_vsi *vsi;
@@ -4218,8 +4252,7 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 		goto error_param;
 	}
 
-	if (add_v && !ice_is_vf_trusted(vf) &&
-	    vsi->num_vlan >= ICE_MAX_VLAN_PER_VF) {
+	if (add_v && ice_vf_has_max_vlans(vf, vsi)) {
 		dev_info(dev, "VF-%d is not trusted, switch the VF to trusted mode, in order to add more VLAN addresses\n",
 			 vf->vf_id);
 		/* There is no need to let VF know about being not trusted,
@@ -4238,13 +4271,13 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 	    test_bit(ICE_FLAG_VF_TRUE_PROMISC_ENA, pf->flags))
 		vlan_promisc = true;
 
+	vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
 	if (add_v) {
 		for (i = 0; i < vfl->num_elements; i++) {
 			u16 vid = vfl->vlan_id[i];
 			struct ice_vlan vlan;
 
-			if (!ice_is_vf_trusted(vf) &&
-			    vsi->num_vlan >= ICE_MAX_VLAN_PER_VF) {
+			if (ice_vf_has_max_vlans(vf, vsi)) {
 				dev_info(dev, "VF-%d is not trusted, switch the VF to trusted mode, in order to add more VLAN addresses\n",
 					 vf->vf_id);
 				/* There is no need to let VF know about being
@@ -4262,7 +4295,7 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 				continue;
 
 			vlan = ICE_VLAN(ETH_P_8021Q, vid, 0);
-			status = vsi->vlan_ops.add_vlan(vsi, &vlan);
+			status = vsi->inner_vlan_ops.add_vlan(vsi, &vlan);
 			if (status) {
 				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 				goto error_param;
@@ -4271,7 +4304,7 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 			/* Enable VLAN pruning when non-zero VLAN is added */
 			if (!vlan_promisc && vid &&
 			    !ice_vsi_is_vlan_pruning_ena(vsi)) {
-				status = vsi->vlan_ops.ena_rx_filtering(vsi);
+				status = vlan_ops->ena_rx_filtering(vsi);
 				if (status) {
 					v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 					dev_err(dev, "Enable VLAN pruning on VLAN ID: %d failed error-%d\n",
@@ -4315,16 +4348,16 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 				continue;
 
 			vlan = ICE_VLAN(ETH_P_8021Q, vid, 0);
-			status = vsi->vlan_ops.del_vlan(vsi, &vlan);
+			status = vsi->inner_vlan_ops.del_vlan(vsi, &vlan);
 			if (status) {
 				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 				goto error_param;
 			}
 
 			/* Disable VLAN pruning when only VLAN 0 is left */
-			if (vsi->num_vlan == 1 &&
+			if (!ice_vsi_has_non_zero_vlans(vsi) &&
 			    ice_vsi_is_vlan_pruning_ena(vsi))
-				status = vsi->vlan_ops.dis_rx_filtering(vsi);
+				status = vlan_ops->dis_rx_filtering(vsi);
 
 			/* Disable Unicast/Multicast VLAN promiscuous mode */
 			if (vlan_promisc) {
@@ -4393,7 +4426,7 @@ static int ice_vc_ena_vlan_stripping(struct ice_vf *vf)
 	}
 
 	vsi = ice_get_vf_vsi(vf);
-	if (vsi->vlan_ops.ena_stripping(vsi, ETH_P_8021Q))
+	if (vsi->inner_vlan_ops.ena_stripping(vsi, ETH_P_8021Q))
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 
 error_param:
@@ -4428,7 +4461,7 @@ static int ice_vc_dis_vlan_stripping(struct ice_vf *vf)
 		goto error_param;
 	}
 
-	if (vsi->vlan_ops.dis_stripping(vsi))
+	if (vsi->inner_vlan_ops.dis_stripping(vsi))
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 
 error_param:
@@ -4458,9 +4491,9 @@ static int ice_vf_init_vlan_stripping(struct ice_vf *vf)
 		return 0;
 
 	if (ice_vf_vlan_offload_ena(vf->driver_caps))
-		return vsi->vlan_ops.ena_stripping(vsi, ETH_P_8021Q);
+		return vsi->inner_vlan_ops.ena_stripping(vsi, ETH_P_8021Q);
 	else
-		return vsi->vlan_ops.dis_stripping(vsi);
+		return vsi->inner_vlan_ops.dis_stripping(vsi);
 }
 
 static struct ice_vc_vf_ops ice_vc_vf_dflt_ops = {
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index b06ca1f97833..4110847e0699 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -211,6 +211,7 @@ int
 ice_vc_send_msg_to_vf(struct ice_vf *vf, u32 v_opcode,
 		      enum virtchnl_status_code v_retval, u8 *msg, u16 msglen);
 bool ice_vc_isvalid_vsi_id(struct ice_vf *vf, u16 vsi_id);
+bool ice_vf_is_port_vlan_ena(struct ice_vf *vf);
 #else /* CONFIG_PCI_IOV */
 static inline void ice_process_vflr_event(struct ice_pf *pf) { }
 static inline void ice_free_vfs(struct ice_pf *pf) { }
@@ -343,5 +344,10 @@ static inline bool ice_is_any_vf_in_promisc(struct ice_pf __always_unused *pf)
 {
 	return false;
 }
+
+static inline bool ice_vf_is_port_vlan_ena(struct ice_vf __always_unused *vf)
+{
+	return false;
+}
 #endif /* CONFIG_PCI_IOV */
 #endif /* _ICE_VIRTCHNL_PF_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c
index 0b130505b68a..62a2630d6fab 100644
--- a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c
@@ -23,7 +23,8 @@ static void print_invalid_tpid(struct ice_vsi *vsi, u16 tpid)
  */
 static bool validate_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan)
 {
-	if (vlan->tpid != ETH_P_8021Q && (vlan->tpid || vlan->vid)) {
+	if (vlan->tpid != ETH_P_8021Q && vlan->tpid != ETH_P_8021AD &&
+	    vlan->tpid != ETH_P_QINQ1 && (vlan->tpid || vlan->vid)) {
 		print_invalid_tpid(vsi, vlan->tpid);
 		return false;
 	}
@@ -366,3 +367,344 @@ int ice_vsi_dis_tx_vlan_filtering(struct ice_vsi *vsi)
 {
 	return ice_cfg_vlan_antispoof(vsi, false);
 }
+
+/**
+ * tpid_to_vsi_outer_vlan_type - convert from TPID to VSI context based tag_type
+ * @tpid: tpid used to translate into VSI context based tag_type
+ * @tag_type: output variable to hold the VSI context based tag type
+ */
+static int tpid_to_vsi_outer_vlan_type(u16 tpid, u8 *tag_type)
+{
+	switch (tpid) {
+	case ETH_P_8021Q:
+		*tag_type = ICE_AQ_VSI_OUTER_TAG_VLAN_8100;
+		break;
+	case ETH_P_8021AD:
+		*tag_type = ICE_AQ_VSI_OUTER_TAG_STAG;
+		break;
+	case ETH_P_QINQ1:
+		*tag_type = ICE_AQ_VSI_OUTER_TAG_VLAN_9100;
+		break;
+	default:
+		*tag_type = 0;
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_vsi_ena_outer_stripping - enable outer VLAN stripping
+ * @vsi: VSI to configure
+ * @tpid: TPID to enable outer VLAN stripping for
+ *
+ * Enable outer VLAN stripping via VSI context. This function should only be
+ * used if DVM is supported. Also, this function should never be called directly
+ * as it should be part of ice_vsi_vlan_ops if it's needed.
+ *
+ * Since the VSI context only supports a single TPID for insertion and
+ * stripping, setting the TPID for stripping will affect the TPID for insertion.
+ * Callers need to be aware of this limitation.
+ *
+ * Only modify outer VLAN stripping settings and the VLAN TPID. Outer VLAN
+ * insertion settings are unmodified.
+ *
+ * This enables hardware to strip a VLAN tag with the specified TPID to be
+ * stripped from the packet and placed in the receive descriptor.
+ */
+int ice_vsi_ena_outer_stripping(struct ice_vsi *vsi, u16 tpid)
+{
+	struct ice_hw *hw = &vsi->back->hw;
+	struct ice_vsi_ctx *ctxt;
+	u8 tag_type;
+	int err;
+
+	/* do not allow modifying VLAN stripping when a port VLAN is configured
+	 * on this VSI
+	 */
+	if (vsi->info.port_based_outer_vlan)
+		return 0;
+
+	if (tpid_to_vsi_outer_vlan_type(tpid, &tag_type))
+		return -EINVAL;
+
+	ctxt = kzalloc(sizeof(*ctxt), GFP_KERNEL);
+	if (!ctxt)
+		return -ENOMEM;
+
+	ctxt->info.valid_sections =
+		cpu_to_le16(ICE_AQ_VSI_PROP_OUTER_TAG_VALID);
+	/* clear current outer VLAN strip settings */
+	ctxt->info.outer_vlan_flags = vsi->info.outer_vlan_flags &
+		~(ICE_AQ_VSI_OUTER_VLAN_EMODE_M | ICE_AQ_VSI_OUTER_TAG_TYPE_M);
+	ctxt->info.outer_vlan_flags |=
+		((ICE_AQ_VSI_OUTER_VLAN_EMODE_SHOW_BOTH <<
+		  ICE_AQ_VSI_OUTER_VLAN_EMODE_S) |
+		 ((tag_type << ICE_AQ_VSI_OUTER_TAG_TYPE_S) &
+		  ICE_AQ_VSI_OUTER_TAG_TYPE_M));
+
+	err = ice_update_vsi(hw, vsi->idx, ctxt, NULL);
+	if (err)
+		dev_err(ice_pf_to_dev(vsi->back), "update VSI for enabling outer VLAN stripping failed, err %d aq_err %s\n",
+			err, ice_aq_str(hw->adminq.sq_last_status));
+	else
+		vsi->info.outer_vlan_flags = ctxt->info.outer_vlan_flags;
+
+	kfree(ctxt);
+	return err;
+}
+
+/**
+ * ice_vsi_dis_outer_stripping - disable outer VLAN stripping
+ * @vsi: VSI to configure
+ *
+ * Disable outer VLAN stripping via VSI context. This function should only be
+ * used if DVM is supported. Also, this function should never be called directly
+ * as it should be part of ice_vsi_vlan_ops if it's needed.
+ *
+ * Only modify the outer VLAN stripping settings. The VLAN TPID and outer VLAN
+ * insertion settings are unmodified.
+ *
+ * This tells the hardware to not strip any VLAN tagged packets, thus leaving
+ * them in the packet. This enables software offloaded VLAN stripping and
+ * disables hardware offloaded VLAN stripping.
+ */
+int ice_vsi_dis_outer_stripping(struct ice_vsi *vsi)
+{
+	struct ice_hw *hw = &vsi->back->hw;
+	struct ice_vsi_ctx *ctxt;
+	int err;
+
+	if (vsi->info.port_based_outer_vlan)
+		return 0;
+
+	ctxt = kzalloc(sizeof(*ctxt), GFP_KERNEL);
+	if (!ctxt)
+		return -ENOMEM;
+
+	ctxt->info.valid_sections =
+		cpu_to_le16(ICE_AQ_VSI_PROP_OUTER_TAG_VALID);
+	/* clear current outer VLAN strip settings */
+	ctxt->info.outer_vlan_flags = vsi->info.outer_vlan_flags &
+		~ICE_AQ_VSI_OUTER_VLAN_EMODE_M;
+	ctxt->info.outer_vlan_flags |= ICE_AQ_VSI_OUTER_VLAN_EMODE_NOTHING <<
+		ICE_AQ_VSI_OUTER_VLAN_EMODE_S;
+
+	err = ice_update_vsi(hw, vsi->idx, ctxt, NULL);
+	if (err)
+		dev_err(ice_pf_to_dev(vsi->back), "update VSI for disabling outer VLAN stripping failed, err %d aq_err %s\n",
+			err, ice_aq_str(hw->adminq.sq_last_status));
+	else
+		vsi->info.outer_vlan_flags = ctxt->info.outer_vlan_flags;
+
+	kfree(ctxt);
+	return err;
+}
+
+/**
+ * ice_vsi_ena_outer_insertion - enable outer VLAN insertion
+ * @vsi: VSI to configure
+ * @tpid: TPID to enable outer VLAN insertion for
+ *
+ * Enable outer VLAN insertion via VSI context. This function should only be
+ * used if DVM is supported. Also, this function should never be called directly
+ * as it should be part of ice_vsi_vlan_ops if it's needed.
+ *
+ * Since the VSI context only supports a single TPID for insertion and
+ * stripping, setting the TPID for insertion will affect the TPID for stripping.
+ * Callers need to be aware of this limitation.
+ *
+ * Only modify outer VLAN insertion settings and the VLAN TPID. Outer VLAN
+ * stripping settings are unmodified.
+ *
+ * This allows a VLAN tag with the specified TPID to be inserted in the transmit
+ * descriptor.
+ */
+int ice_vsi_ena_outer_insertion(struct ice_vsi *vsi, u16 tpid)
+{
+	struct ice_hw *hw = &vsi->back->hw;
+	struct ice_vsi_ctx *ctxt;
+	u8 tag_type;
+	int err;
+
+	if (vsi->info.port_based_outer_vlan)
+		return 0;
+
+	if (tpid_to_vsi_outer_vlan_type(tpid, &tag_type))
+		return -EINVAL;
+
+	ctxt = kzalloc(sizeof(*ctxt), GFP_KERNEL);
+	if (!ctxt)
+		return -ENOMEM;
+
+	ctxt->info.valid_sections =
+		cpu_to_le16(ICE_AQ_VSI_PROP_OUTER_TAG_VALID);
+	/* clear current outer VLAN insertion settings */
+	ctxt->info.outer_vlan_flags = vsi->info.outer_vlan_flags &
+		~(ICE_AQ_VSI_OUTER_VLAN_PORT_BASED_INSERT |
+		  ICE_AQ_VSI_OUTER_VLAN_BLOCK_TX_DESC |
+		  ICE_AQ_VSI_OUTER_VLAN_TX_MODE_M |
+		  ICE_AQ_VSI_OUTER_TAG_TYPE_M);
+	ctxt->info.outer_vlan_flags |=
+		((ICE_AQ_VSI_OUTER_VLAN_TX_MODE_ALL <<
+		  ICE_AQ_VSI_OUTER_VLAN_TX_MODE_S) &
+		 ICE_AQ_VSI_OUTER_VLAN_TX_MODE_M) |
+		((tag_type << ICE_AQ_VSI_OUTER_TAG_TYPE_S) &
+		 ICE_AQ_VSI_OUTER_TAG_TYPE_M);
+
+	err = ice_update_vsi(hw, vsi->idx, ctxt, NULL);
+	if (err)
+		dev_err(ice_pf_to_dev(vsi->back), "update VSI for enabling outer VLAN insertion failed, err %d aq_err %s\n",
+			err, ice_aq_str(hw->adminq.sq_last_status));
+	else
+		vsi->info.outer_vlan_flags = ctxt->info.outer_vlan_flags;
+
+	kfree(ctxt);
+	return err;
+}
+
+/**
+ * ice_vsi_dis_outer_insertion - disable outer VLAN insertion
+ * @vsi: VSI to configure
+ *
+ * Disable outer VLAN insertion via VSI context. This function should only be
+ * used if DVM is supported. Also, this function should never be called directly
+ * as it should be part of ice_vsi_vlan_ops if it's needed.
+ *
+ * Only modify the outer VLAN insertion settings. The VLAN TPID and outer VLAN
+ * settings are unmodified.
+ *
+ * This tells the hardware to not allow any VLAN tagged packets in the transmit
+ * descriptor. This enables software offloaded VLAN insertion and disables
+ * hardware offloaded VLAN insertion.
+ */
+int ice_vsi_dis_outer_insertion(struct ice_vsi *vsi)
+{
+	struct ice_hw *hw = &vsi->back->hw;
+	struct ice_vsi_ctx *ctxt;
+	int err;
+
+	if (vsi->info.port_based_outer_vlan)
+		return 0;
+
+	ctxt = kzalloc(sizeof(*ctxt), GFP_KERNEL);
+	if (!ctxt)
+		return -ENOMEM;
+
+	ctxt->info.valid_sections =
+		cpu_to_le16(ICE_AQ_VSI_PROP_OUTER_TAG_VALID);
+	/* clear current outer VLAN insertion settings */
+	ctxt->info.outer_vlan_flags = vsi->info.outer_vlan_flags &
+		~(ICE_AQ_VSI_OUTER_VLAN_PORT_BASED_INSERT |
+		  ICE_AQ_VSI_OUTER_VLAN_TX_MODE_M);
+	ctxt->info.outer_vlan_flags |=
+		ICE_AQ_VSI_OUTER_VLAN_BLOCK_TX_DESC |
+		((ICE_AQ_VSI_OUTER_VLAN_TX_MODE_ALL <<
+		  ICE_AQ_VSI_OUTER_VLAN_TX_MODE_S) &
+		 ICE_AQ_VSI_OUTER_VLAN_TX_MODE_M);
+
+	err = ice_update_vsi(hw, vsi->idx, ctxt, NULL);
+	if (err)
+		dev_err(ice_pf_to_dev(vsi->back), "update VSI for disabling outer VLAN insertion failed, err %d aq_err %s\n",
+			err, ice_aq_str(hw->adminq.sq_last_status));
+	else
+		vsi->info.outer_vlan_flags = ctxt->info.outer_vlan_flags;
+
+	kfree(ctxt);
+	return err;
+}
+
+/**
+ * __ice_vsi_set_outer_port_vlan - set the outer port VLAN and related settings
+ * @vsi: VSI to configure
+ * @vlan_info: packed u16 that contains the VLAN prio and ID
+ * @tpid: TPID of the port VLAN
+ *
+ * Set the port VLAN prio, ID, and TPID.
+ *
+ * Enable VLAN pruning so the VSI doesn't receive any traffic that doesn't match
+ * a VLAN prune rule. The caller should take care to add a VLAN prune rule that
+ * matches the port VLAN ID and TPID.
+ *
+ * Tell hardware to strip outer VLAN tagged packets on receive and don't put
+ * them in the receive descriptor. VSI(s) in port VLANs should not be aware of
+ * the port VLAN ID or TPID they are assigned to.
+ *
+ * Tell hardware to prevent outer VLAN tag insertion on transmit and only allow
+ * untagged outer packets from the transmit descriptor.
+ *
+ * Also, tell the hardware to insert the port VLAN on transmit.
+ */
+static int
+__ice_vsi_set_outer_port_vlan(struct ice_vsi *vsi, u16 vlan_info, u16 tpid)
+{
+	struct ice_hw *hw = &vsi->back->hw;
+	struct ice_vsi_ctx *ctxt;
+	u8 tag_type;
+	int err;
+
+	if (tpid_to_vsi_outer_vlan_type(tpid, &tag_type))
+		return -EINVAL;
+
+	ctxt = kzalloc(sizeof(*ctxt), GFP_KERNEL);
+	if (!ctxt)
+		return -ENOMEM;
+
+	ctxt->info = vsi->info;
+
+	ctxt->info.sw_flags2 |= ICE_AQ_VSI_SW_FLAG_RX_VLAN_PRUNE_ENA;
+
+	ctxt->info.port_based_outer_vlan = cpu_to_le16(vlan_info);
+	ctxt->info.outer_vlan_flags =
+		(ICE_AQ_VSI_OUTER_VLAN_EMODE_SHOW <<
+		 ICE_AQ_VSI_OUTER_VLAN_EMODE_S) |
+		((tag_type << ICE_AQ_VSI_OUTER_TAG_TYPE_S) &
+		 ICE_AQ_VSI_OUTER_TAG_TYPE_M) |
+		ICE_AQ_VSI_OUTER_VLAN_BLOCK_TX_DESC |
+		(ICE_AQ_VSI_OUTER_VLAN_TX_MODE_ACCEPTUNTAGGED <<
+		 ICE_AQ_VSI_OUTER_VLAN_TX_MODE_S) |
+		ICE_AQ_VSI_OUTER_VLAN_PORT_BASED_INSERT;
+
+	ctxt->info.valid_sections =
+		cpu_to_le16(ICE_AQ_VSI_PROP_OUTER_TAG_VALID |
+			    ICE_AQ_VSI_PROP_SW_VALID);
+
+	err = ice_update_vsi(hw, vsi->idx, ctxt, NULL);
+	if (err) {
+		dev_err(ice_pf_to_dev(vsi->back), "update VSI for setting outer port based VLAN failed, err %d aq_err %s\n",
+			err, ice_aq_str(hw->adminq.sq_last_status));
+	} else {
+		vsi->info.port_based_outer_vlan = ctxt->info.port_based_outer_vlan;
+		vsi->info.outer_vlan_flags = ctxt->info.outer_vlan_flags;
+		vsi->info.sw_flags2 = ctxt->info.sw_flags2;
+	}
+
+	kfree(ctxt);
+	return err;
+}
+
+/**
+ * ice_vsi_set_outer_port_vlan - public version of __ice_vsi_set_outer_port_vlan
+ * @vsi: VSI to configure
+ * @vlan: ice_vlan structure used to set the port VLAN
+ *
+ * Set the outer port VLAN via VSI context. This function should only be
+ * used if DVM is supported. Also, this function should never be called directly
+ * as it should be part of ice_vsi_vlan_ops if it's needed.
+ *
+ * This function does not support clearing the port VLAN as there is currently
+ * no use case for this.
+ *
+ * Use the ice_vlan structure passed in to set this VSI in a port VLAN.
+ */
+int ice_vsi_set_outer_port_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan)
+{
+	u16 port_vlan_info;
+
+	if (vlan->prio > (VLAN_PRIO_MASK >> VLAN_PRIO_SHIFT))
+		return -EINVAL;
+
+	port_vlan_info = vlan->vid | (vlan->prio << VLAN_PRIO_SHIFT);
+
+	return __ice_vsi_set_outer_port_vlan(vsi, port_vlan_info, vlan->tpid);
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.h b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.h
index a10671133e36..f459909490ec 100644
--- a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.h
@@ -23,4 +23,10 @@ int ice_vsi_dis_rx_vlan_filtering(struct ice_vsi *vsi);
 int ice_vsi_ena_tx_vlan_filtering(struct ice_vsi *vsi);
 int ice_vsi_dis_tx_vlan_filtering(struct ice_vsi *vsi);
 
+int ice_vsi_ena_outer_stripping(struct ice_vsi *vsi, u16 tpid);
+int ice_vsi_dis_outer_stripping(struct ice_vsi *vsi);
+int ice_vsi_ena_outer_insertion(struct ice_vsi *vsi, u16 tpid);
+int ice_vsi_dis_outer_insertion(struct ice_vsi *vsi);
+int ice_vsi_set_outer_port_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan);
+
 #endif /* _ICE_VSI_VLAN_LIB_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_ops.c b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_ops.c
index 6a6b49581c70..4a6c850d83ac 100644
--- a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_ops.c
+++ b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_ops.c
@@ -1,20 +1,103 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (C) 2019-2021, Intel Corporation. */
 
-#include "ice_vsi_vlan_ops.h"
+#include "ice_pf_vsi_vlan_ops.h"
+#include "ice_vf_vsi_vlan_ops.h"
+#include "ice_lib.h"
 #include "ice.h"
 
+static int
+op_unsupported_vlan_arg(struct ice_vsi * __always_unused vsi,
+			struct ice_vlan * __always_unused vlan)
+{
+	return -EOPNOTSUPP;
+}
+
+static int
+op_unsupported_tpid_arg(struct ice_vsi *__always_unused vsi,
+			u16 __always_unused tpid)
+{
+	return -EOPNOTSUPP;
+}
+
+static int op_unsupported(struct ice_vsi *__always_unused vsi)
+{
+	return -EOPNOTSUPP;
+}
+
+/* If any new ops are added to the VSI VLAN ops interface then an unsupported
+ * implementation should be set here.
+ */
+static struct ice_vsi_vlan_ops ops_unsupported = {
+	.add_vlan = op_unsupported_vlan_arg,
+	.del_vlan = op_unsupported_vlan_arg,
+	.ena_stripping = op_unsupported_tpid_arg,
+	.dis_stripping = op_unsupported,
+	.ena_insertion = op_unsupported_tpid_arg,
+	.dis_insertion = op_unsupported,
+	.ena_rx_filtering = op_unsupported,
+	.dis_rx_filtering = op_unsupported,
+	.ena_tx_filtering = op_unsupported,
+	.dis_tx_filtering = op_unsupported,
+	.set_port_vlan = op_unsupported_vlan_arg,
+};
+
+/**
+ * ice_vsi_init_unsupported_vlan_ops - init all VSI VLAN ops to unsupported
+ * @vsi: VSI to initialize VSI VLAN ops to unsupported for
+ *
+ * By default all inner and outer VSI VLAN ops return -EOPNOTSUPP. This was done
+ * as oppsed to leaving the ops null to prevent unexpected crashes. Instead if
+ * an unsupported VSI VLAN op is called it will just return -EOPNOTSUPP.
+ *
+ */
+static void ice_vsi_init_unsupported_vlan_ops(struct ice_vsi *vsi)
+{
+	vsi->outer_vlan_ops = ops_unsupported;
+	vsi->inner_vlan_ops = ops_unsupported;
+}
+
+/**
+ * ice_vsi_init_vlan_ops - initialize type specific VSI VLAN ops
+ * @vsi: VSI to initialize ops for
+ *
+ * If any VSI types are added and/or require different ops than the PF or VF VSI
+ * then they will have to add a case here to handle that. Also, VSI type
+ * specific files should be added in the same manner that was done for PF VSI.
+ */
 void ice_vsi_init_vlan_ops(struct ice_vsi *vsi)
 {
-	vsi->vlan_ops.add_vlan = ice_vsi_add_vlan;
-	vsi->vlan_ops.del_vlan = ice_vsi_del_vlan;
-	vsi->vlan_ops.ena_stripping = ice_vsi_ena_inner_stripping;
-	vsi->vlan_ops.dis_stripping = ice_vsi_dis_inner_stripping;
-	vsi->vlan_ops.ena_insertion = ice_vsi_ena_inner_insertion;
-	vsi->vlan_ops.dis_insertion = ice_vsi_dis_inner_insertion;
-	vsi->vlan_ops.ena_rx_filtering = ice_vsi_ena_rx_vlan_filtering;
-	vsi->vlan_ops.dis_rx_filtering = ice_vsi_dis_rx_vlan_filtering;
-	vsi->vlan_ops.ena_tx_filtering = ice_vsi_ena_tx_vlan_filtering;
-	vsi->vlan_ops.dis_tx_filtering = ice_vsi_dis_tx_vlan_filtering;
-	vsi->vlan_ops.set_port_vlan = ice_vsi_set_inner_port_vlan;
+	/* Initialize all VSI types to have unsupported VSI VLAN ops */
+	ice_vsi_init_unsupported_vlan_ops(vsi);
+
+	switch (vsi->type) {
+	case ICE_VSI_PF:
+	case ICE_VSI_SWITCHDEV_CTRL:
+		ice_pf_vsi_init_vlan_ops(vsi);
+		break;
+	case ICE_VSI_VF:
+		ice_vf_vsi_init_vlan_ops(vsi);
+		break;
+	default:
+		dev_dbg(ice_pf_to_dev(vsi->back), "%s does not support VLAN operations\n",
+			ice_vsi_type_str(vsi->type));
+		break;
+	}
+}
+
+/**
+ * ice_get_compat_vsi_vlan_ops - Get VSI VLAN ops based on VLAN mode
+ * @vsi: VSI used to get the VSI VLAN ops
+ *
+ * This function is meant to be used when the caller doesn't know which VLAN ops
+ * to use (i.e. inner or outer). This allows backward compatibility for VLANs
+ * since most of the Outer VSI VLAN functins are not supported when
+ * the device is configured in Single VLAN Mode (SVM).
+ */
+struct ice_vsi_vlan_ops *ice_get_compat_vsi_vlan_ops(struct ice_vsi *vsi)
+{
+	if (ice_is_dvm_ena(&vsi->back->hw))
+		return &vsi->outer_vlan_ops;
+	else
+		return &vsi->inner_vlan_ops;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_ops.h b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_ops.h
index 76e55b259bc8..30d02d2b8e5f 100644
--- a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_ops.h
+++ b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_ops.h
@@ -23,6 +23,12 @@ struct ice_vsi_vlan_ops {
 	int (*set_port_vlan)(struct ice_vsi *vsi, struct ice_vlan *vlan);
 };
 
+static inline bool ice_is_dvm_ena(struct ice_hw __always_unused *hw)
+{
+	return false;
+}
+
 void ice_vsi_init_vlan_ops(struct ice_vsi *vsi);
+struct ice_vsi_vlan_ops *ice_get_compat_vsi_vlan_ops(struct ice_vsi *vsi);
 
 #endif /* _ICE_VSI_VLAN_OPS_H_ */
-- 
2.31.1

