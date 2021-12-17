Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D6D4796D8
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 23:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbhLQWHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 17:07:45 -0500
Received: from mga03.intel.com ([134.134.136.65]:43081 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229587AbhLQWHn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 17:07:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639778863; x=1671314863;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Xc5c/9JyROoYd/tuolNgGimTu8v2BlasYb44jevv3Yg=;
  b=kleburtFMbqa98rySoBdxglI0SL+lBv3Jn5rSq9pmKeZ9AaH9RYblQQf
   mg2vjnPsF6+fJvMfxRoaw8tmMHbLfeazBpkN6vlsezNaIxLX2Mzp7yKme
   QvOUYLI2+P28sX7rsST8D3DcJHcvOTN5rll4cR8u53S8iS6QtXtQtNstO
   Zl5PK+5pjOEEniU1ADxmxyC5/FNBUU2kBtmTbkyv/uj9+M4TvTOCk3gPL
   fYL1vqNI4czyvgJ7IfR/c9TbBUWQjLP8nh3PAzvY4qSDMXkrHxbkMuNfw
   fhxRjRgRYb1IxgRhBNfKGWh1P3KWOVZnVDwN/TqWae036Bt0QX7hoT5P6
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10201"; a="239794453"
X-IronPort-AV: E=Sophos;i="5.88,214,1635231600"; 
   d="scan'208";a="239794453"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 14:07:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,214,1635231600"; 
   d="scan'208";a="519922254"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 17 Dec 2021 14:07:42 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 3/6] iavf: Add support VIRTCHNL_VF_OFFLOAD_VLAN_V2 during netdev config
Date:   Fri, 17 Dec 2021 14:06:44 -0800
Message-Id: <20211217220647.875246-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211217220647.875246-1-anthony.l.nguyen@intel.com>
References: <20211217220647.875246-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Based on VIRTCHNL_VF_OFFLOAD_VLAN_V2, the VF can now support more VLAN
capabilities (i.e. 802.1AD offloads and filtering). In order to
communicate these capabilities to the netdev layer, the VF needs to
parse its VLAN capabilities based on whether it was able to negotiation
VIRTCHNL_VF_OFFLOAD_VLAN or VIRTCHNL_VF_OFFLOAD_VLAN_V2 or neither of
these.

In order to support this, add the following functionality:

iavf_get_netdev_vlan_hw_features() - This is used to determine the VLAN
features that the underlying hardware supports and that can be toggled
off/on based on the negotiated capabiltiies. For example, if
VIRTCHNL_VF_OFFLOAD_VLAN_V2 was negotiated, then any capability marked
with VIRTCHNL_VLAN_TOGGLE can be toggled on/off by the VF. If
VIRTCHNL_VF_OFFLOAD_VLAN was negotiated, then only VLAN insertion and/or
stripping can be toggled on/off.

iavf_get_netdev_vlan_features() - This is used to determine the VLAN
features that the underlying hardware supports and that should be
enabled by default. For example, if VIRTHCNL_VF_OFFLOAD_VLAN_V2 was
negotiated, then any supported capability that has its ethertype_init
filed set should be enabled by default. If VIRTCHNL_VF_OFFLOAD_VLAN was
negotiated, then filtering, stripping, and insertion should be enabled
by default.

Also, refactor iavf_fix_features() to take into account the new
capabilities. To do this, query all the supported features (enabled by
default and toggleable) and make sure the requested change is supported.
If VIRTCHNL_VF_OFFLOAD_VLAN_V2 is successfully negotiated, there is no
need to check VIRTCHNL_VLAN_TOGGLE here because the driver already told
the netdev layer which features can be toggled via netdev->hw_features
during iavf_process_config(), so only those features will be requested
to change.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf.h        |  17 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 279 ++++++++++++++++--
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   | 251 +++++++++++-----
 3 files changed, 453 insertions(+), 94 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index edb139834437..5fb6ebf9a760 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -55,7 +55,8 @@ enum iavf_vsi_state_t {
 struct iavf_vsi {
 	struct iavf_adapter *back;
 	struct net_device *netdev;
-	unsigned long active_vlans[BITS_TO_LONGS(VLAN_N_VID)];
+	unsigned long active_cvlans[BITS_TO_LONGS(VLAN_N_VID)];
+	unsigned long active_svlans[BITS_TO_LONGS(VLAN_N_VID)];
 	u16 seid;
 	u16 id;
 	DECLARE_BITMAP(state, __IAVF_VSI_STATE_SIZE__);
@@ -146,9 +147,15 @@ struct iavf_mac_filter {
 	};
 };
 
+#define IAVF_VLAN(vid, tpid) ((struct iavf_vlan){ vid, tpid })
+struct iavf_vlan {
+	u16 vid;
+	u16 tpid;
+};
+
 struct iavf_vlan_filter {
 	struct list_head list;
-	u16 vlan;
+	struct iavf_vlan vlan;
 	bool remove;		/* filter needs to be removed */
 	bool add;		/* filter needs to be added */
 };
@@ -354,6 +361,12 @@ struct iavf_adapter {
 			  VIRTCHNL_VF_OFFLOAD_VLAN)
 #define VLAN_V2_ALLOWED(_a) ((_a)->vf_res->vf_cap_flags & \
 			     VIRTCHNL_VF_OFFLOAD_VLAN_V2)
+#define VLAN_V2_FILTERING_ALLOWED(_a) \
+	(VLAN_V2_ALLOWED((_a)) && \
+	 ((_a)->vlan_v2_caps.filtering.filtering_support.outer || \
+	  (_a)->vlan_v2_caps.filtering.filtering_support.inner))
+#define VLAN_FILTERING_ALLOWED(_a) \
+	(VLAN_ALLOWED((_a)) || VLAN_V2_FILTERING_ALLOWED((_a)))
 #define ADV_LINK_SUPPORT(_a) ((_a)->vf_res->vf_cap_flags & \
 			      VIRTCHNL_VF_CAP_ADV_LINK_SPEED)
 #define FDIR_FLTR_SUPPORT(_a) ((_a)->vf_res->vf_cap_flags & \
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index b301da6c0a96..6b7f59718097 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -646,14 +646,17 @@ static void iavf_configure_rx(struct iavf_adapter *adapter)
  * mac_vlan_list_lock.
  **/
 static struct
-iavf_vlan_filter *iavf_find_vlan(struct iavf_adapter *adapter, u16 vlan)
+iavf_vlan_filter *iavf_find_vlan(struct iavf_adapter *adapter,
+				 struct iavf_vlan vlan)
 {
 	struct iavf_vlan_filter *f;
 
 	list_for_each_entry(f, &adapter->vlan_filter_list, list) {
-		if (vlan == f->vlan)
+		if (f->vlan.vid == vlan.vid &&
+		    f->vlan.tpid == vlan.tpid)
 			return f;
 	}
+
 	return NULL;
 }
 
@@ -665,7 +668,8 @@ iavf_vlan_filter *iavf_find_vlan(struct iavf_adapter *adapter, u16 vlan)
  * Returns ptr to the filter object or NULL when no memory available.
  **/
 static struct
-iavf_vlan_filter *iavf_add_vlan(struct iavf_adapter *adapter, u16 vlan)
+iavf_vlan_filter *iavf_add_vlan(struct iavf_adapter *adapter,
+				struct iavf_vlan vlan)
 {
 	struct iavf_vlan_filter *f = NULL;
 
@@ -694,7 +698,7 @@ iavf_vlan_filter *iavf_add_vlan(struct iavf_adapter *adapter, u16 vlan)
  * @adapter: board private structure
  * @vlan: VLAN tag
  **/
-static void iavf_del_vlan(struct iavf_adapter *adapter, u16 vlan)
+static void iavf_del_vlan(struct iavf_adapter *adapter, struct iavf_vlan vlan)
 {
 	struct iavf_vlan_filter *f;
 
@@ -720,8 +724,11 @@ static void iavf_restore_filters(struct iavf_adapter *adapter)
 	u16 vid;
 
 	/* re-add all VLAN filters */
-	for_each_set_bit(vid, adapter->vsi.active_vlans, VLAN_N_VID)
-		iavf_add_vlan(adapter, vid);
+	for_each_set_bit(vid, adapter->vsi.active_cvlans, VLAN_N_VID)
+		iavf_add_vlan(adapter, IAVF_VLAN(vid, ETH_P_8021Q));
+
+	for_each_set_bit(vid, adapter->vsi.active_svlans, VLAN_N_VID)
+		iavf_add_vlan(adapter, IAVF_VLAN(vid, ETH_P_8021AD));
 }
 
 /**
@@ -735,13 +742,17 @@ static int iavf_vlan_rx_add_vid(struct net_device *netdev,
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 
-	if (!VLAN_ALLOWED(adapter))
+	if (!VLAN_FILTERING_ALLOWED(adapter))
 		return -EIO;
 
-	if (iavf_add_vlan(adapter, vid) == NULL)
+	if (!iavf_add_vlan(adapter, IAVF_VLAN(vid, be16_to_cpu(proto))))
 		return -ENOMEM;
 
-	set_bit(vid, adapter->vsi.active_vlans);
+	if (proto == cpu_to_be16(ETH_P_8021Q))
+		set_bit(vid, adapter->vsi.active_cvlans);
+	else
+		set_bit(vid, adapter->vsi.active_svlans);
+
 	return 0;
 }
 
@@ -756,8 +767,11 @@ static int iavf_vlan_rx_kill_vid(struct net_device *netdev,
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 
-	iavf_del_vlan(adapter, vid);
-	clear_bit(vid, adapter->vsi.active_vlans);
+	iavf_del_vlan(adapter, IAVF_VLAN(vid, be16_to_cpu(proto)));
+	if (proto == cpu_to_be16(ETH_P_8021Q))
+		clear_bit(vid, adapter->vsi.active_cvlans);
+	else
+		clear_bit(vid, adapter->vsi.active_svlans);
 
 	return 0;
 }
@@ -3680,6 +3694,228 @@ static netdev_features_t iavf_features_check(struct sk_buff *skb,
 	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 }
 
+/**
+ * iavf_get_netdev_vlan_hw_features - get NETDEV VLAN features that can toggle on/off
+ * @adapter: board private structure
+ *
+ * Depending on whether VIRTHCNL_VF_OFFLOAD_VLAN or VIRTCHNL_VF_OFFLOAD_VLAN_V2
+ * were negotiated determine the VLAN features that can be toggled on and off.
+ **/
+static netdev_features_t
+iavf_get_netdev_vlan_hw_features(struct iavf_adapter *adapter)
+{
+	netdev_features_t hw_features = 0;
+
+	if (!adapter->vf_res || !adapter->vf_res->vf_cap_flags)
+		return hw_features;
+
+	/* Enable VLAN features if supported */
+	if (VLAN_ALLOWED(adapter)) {
+		hw_features |= (NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_CTAG_RX);
+	} else if (VLAN_V2_ALLOWED(adapter)) {
+		struct virtchnl_vlan_caps *vlan_v2_caps =
+			&adapter->vlan_v2_caps;
+		struct virtchnl_vlan_supported_caps *stripping_support =
+			&vlan_v2_caps->offloads.stripping_support;
+		struct virtchnl_vlan_supported_caps *insertion_support =
+			&vlan_v2_caps->offloads.insertion_support;
+
+		if (stripping_support->outer != VIRTCHNL_VLAN_UNSUPPORTED &&
+		    stripping_support->outer & VIRTCHNL_VLAN_TOGGLE) {
+			if (stripping_support->outer &
+			    VIRTCHNL_VLAN_ETHERTYPE_8100)
+				hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
+			if (stripping_support->outer &
+			    VIRTCHNL_VLAN_ETHERTYPE_88A8)
+				hw_features |= NETIF_F_HW_VLAN_STAG_RX;
+		} else if (stripping_support->inner !=
+			   VIRTCHNL_VLAN_UNSUPPORTED &&
+			   stripping_support->inner & VIRTCHNL_VLAN_TOGGLE) {
+			if (stripping_support->inner &
+			    VIRTCHNL_VLAN_ETHERTYPE_8100)
+				hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
+		}
+
+		if (insertion_support->outer != VIRTCHNL_VLAN_UNSUPPORTED &&
+		    insertion_support->outer & VIRTCHNL_VLAN_TOGGLE) {
+			if (insertion_support->outer &
+			    VIRTCHNL_VLAN_ETHERTYPE_8100)
+				hw_features |= NETIF_F_HW_VLAN_CTAG_TX;
+			if (insertion_support->outer &
+			    VIRTCHNL_VLAN_ETHERTYPE_88A8)
+				hw_features |= NETIF_F_HW_VLAN_STAG_TX;
+		} else if (insertion_support->inner &&
+			   insertion_support->inner & VIRTCHNL_VLAN_TOGGLE) {
+			if (insertion_support->inner &
+			    VIRTCHNL_VLAN_ETHERTYPE_8100)
+				hw_features |= NETIF_F_HW_VLAN_CTAG_TX;
+		}
+	}
+
+	return hw_features;
+}
+
+/**
+ * iavf_get_netdev_vlan_features - get the enabled NETDEV VLAN fetures
+ * @adapter: board private structure
+ *
+ * Depending on whether VIRTHCNL_VF_OFFLOAD_VLAN or VIRTCHNL_VF_OFFLOAD_VLAN_V2
+ * were negotiated determine the VLAN features that are enabled by default.
+ **/
+static netdev_features_t
+iavf_get_netdev_vlan_features(struct iavf_adapter *adapter)
+{
+	netdev_features_t features = 0;
+
+	if (!adapter->vf_res || !adapter->vf_res->vf_cap_flags)
+		return features;
+
+	if (VLAN_ALLOWED(adapter)) {
+		features |= NETIF_F_HW_VLAN_CTAG_FILTER |
+			NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_CTAG_TX;
+	} else if (VLAN_V2_ALLOWED(adapter)) {
+		struct virtchnl_vlan_caps *vlan_v2_caps =
+			&adapter->vlan_v2_caps;
+		struct virtchnl_vlan_supported_caps *filtering_support =
+			&vlan_v2_caps->filtering.filtering_support;
+		struct virtchnl_vlan_supported_caps *stripping_support =
+			&vlan_v2_caps->offloads.stripping_support;
+		struct virtchnl_vlan_supported_caps *insertion_support =
+			&vlan_v2_caps->offloads.insertion_support;
+		u32 ethertype_init;
+
+		/* give priority to outer stripping and don't support both outer
+		 * and inner stripping
+		 */
+		ethertype_init = vlan_v2_caps->offloads.ethertype_init;
+		if (stripping_support->outer != VIRTCHNL_VLAN_UNSUPPORTED) {
+			if (stripping_support->outer &
+			    VIRTCHNL_VLAN_ETHERTYPE_8100 &&
+			    ethertype_init & VIRTCHNL_VLAN_ETHERTYPE_8100)
+				features |= NETIF_F_HW_VLAN_CTAG_RX;
+			else if (stripping_support->outer &
+				 VIRTCHNL_VLAN_ETHERTYPE_88A8 &&
+				 ethertype_init & VIRTCHNL_VLAN_ETHERTYPE_88A8)
+				features |= NETIF_F_HW_VLAN_STAG_RX;
+		} else if (stripping_support->inner !=
+			   VIRTCHNL_VLAN_UNSUPPORTED) {
+			if (stripping_support->inner &
+			    VIRTCHNL_VLAN_ETHERTYPE_8100 &&
+			    ethertype_init & VIRTCHNL_VLAN_ETHERTYPE_8100)
+				features |= NETIF_F_HW_VLAN_CTAG_RX;
+		}
+
+		/* give priority to outer insertion and don't support both outer
+		 * and inner insertion
+		 */
+		if (insertion_support->outer != VIRTCHNL_VLAN_UNSUPPORTED) {
+			if (insertion_support->outer &
+			    VIRTCHNL_VLAN_ETHERTYPE_8100 &&
+			    ethertype_init & VIRTCHNL_VLAN_ETHERTYPE_8100)
+				features |= NETIF_F_HW_VLAN_CTAG_TX;
+			else if (insertion_support->outer &
+				 VIRTCHNL_VLAN_ETHERTYPE_88A8 &&
+				 ethertype_init & VIRTCHNL_VLAN_ETHERTYPE_88A8)
+				features |= NETIF_F_HW_VLAN_STAG_TX;
+		} else if (insertion_support->inner !=
+			   VIRTCHNL_VLAN_UNSUPPORTED) {
+			if (insertion_support->inner &
+			    VIRTCHNL_VLAN_ETHERTYPE_8100 &&
+			    ethertype_init & VIRTCHNL_VLAN_ETHERTYPE_8100)
+				features |= NETIF_F_HW_VLAN_CTAG_TX;
+		}
+
+		/* give priority to outer filtering and don't bother if both
+		 * outer and inner filtering are enabled
+		 */
+		ethertype_init = vlan_v2_caps->filtering.ethertype_init;
+		if (filtering_support->outer != VIRTCHNL_VLAN_UNSUPPORTED) {
+			if (filtering_support->outer &
+			    VIRTCHNL_VLAN_ETHERTYPE_8100 &&
+			    ethertype_init & VIRTCHNL_VLAN_ETHERTYPE_8100)
+				features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+			if (filtering_support->outer &
+			    VIRTCHNL_VLAN_ETHERTYPE_88A8 &&
+			    ethertype_init & VIRTCHNL_VLAN_ETHERTYPE_88A8)
+				features |= NETIF_F_HW_VLAN_STAG_FILTER;
+		} else if (filtering_support->inner !=
+			   VIRTCHNL_VLAN_UNSUPPORTED) {
+			if (filtering_support->inner &
+			    VIRTCHNL_VLAN_ETHERTYPE_8100 &&
+			    ethertype_init & VIRTCHNL_VLAN_ETHERTYPE_8100)
+				features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+			if (filtering_support->inner &
+			    VIRTCHNL_VLAN_ETHERTYPE_88A8 &&
+			    ethertype_init & VIRTCHNL_VLAN_ETHERTYPE_88A8)
+				features |= NETIF_F_HW_VLAN_STAG_FILTER;
+		}
+	}
+
+	return features;
+}
+
+#define IAVF_NETDEV_VLAN_FEATURE_ALLOWED(requested, allowed, feature_bit) \
+	(!(((requested) & (feature_bit)) && \
+	   !((allowed) & (feature_bit))))
+
+/**
+ * iavf_fix_netdev_vlan_features - fix NETDEV VLAN features based on support
+ * @adapter: board private structure
+ * @requested_features: stack requested NETDEV features
+ **/
+static netdev_features_t
+iavf_fix_netdev_vlan_features(struct iavf_adapter *adapter,
+			      netdev_features_t requested_features)
+{
+	netdev_features_t allowed_features;
+
+	allowed_features = iavf_get_netdev_vlan_hw_features(adapter) |
+		iavf_get_netdev_vlan_features(adapter);
+
+	if (!IAVF_NETDEV_VLAN_FEATURE_ALLOWED(requested_features,
+					      allowed_features,
+					      NETIF_F_HW_VLAN_CTAG_TX))
+		requested_features &= ~NETIF_F_HW_VLAN_CTAG_TX;
+
+	if (!IAVF_NETDEV_VLAN_FEATURE_ALLOWED(requested_features,
+					      allowed_features,
+					      NETIF_F_HW_VLAN_CTAG_RX))
+		requested_features &= ~NETIF_F_HW_VLAN_CTAG_RX;
+
+	if (!IAVF_NETDEV_VLAN_FEATURE_ALLOWED(requested_features,
+					      allowed_features,
+					      NETIF_F_HW_VLAN_STAG_TX))
+		requested_features &= ~NETIF_F_HW_VLAN_STAG_TX;
+	if (!IAVF_NETDEV_VLAN_FEATURE_ALLOWED(requested_features,
+					      allowed_features,
+					      NETIF_F_HW_VLAN_STAG_RX))
+		requested_features &= ~NETIF_F_HW_VLAN_STAG_RX;
+
+	if (!IAVF_NETDEV_VLAN_FEATURE_ALLOWED(requested_features,
+					      allowed_features,
+					      NETIF_F_HW_VLAN_CTAG_FILTER))
+		requested_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+
+	if (!IAVF_NETDEV_VLAN_FEATURE_ALLOWED(requested_features,
+					      allowed_features,
+					      NETIF_F_HW_VLAN_STAG_FILTER))
+		requested_features &= ~NETIF_F_HW_VLAN_STAG_FILTER;
+
+	if ((requested_features &
+	     (NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_CTAG_TX)) &&
+	    (requested_features &
+	     (NETIF_F_HW_VLAN_STAG_RX | NETIF_F_HW_VLAN_STAG_TX)) &&
+	    adapter->vlan_v2_caps.offloads.ethertype_match ==
+	    VIRTCHNL_ETHERTYPE_STRIPPING_MATCHES_INSERTION) {
+		netdev_warn(adapter->netdev, "cannot support CTAG and STAG VLAN stripping and/or insertion simultaneously since CTAG and STAG offloads are mutually exclusive, clearing STAG offload settings\n");
+		requested_features &= ~(NETIF_F_HW_VLAN_STAG_RX |
+					NETIF_F_HW_VLAN_STAG_TX);
+	}
+
+	return requested_features;
+}
+
 /**
  * iavf_fix_features - fix up the netdev feature bits
  * @netdev: our net device
@@ -3692,13 +3928,7 @@ static netdev_features_t iavf_fix_features(struct net_device *netdev,
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 
-	if (adapter->vf_res &&
-	    !(adapter->vf_res->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_VLAN))
-		features &= ~(NETIF_F_HW_VLAN_CTAG_TX |
-			      NETIF_F_HW_VLAN_CTAG_RX |
-			      NETIF_F_HW_VLAN_CTAG_FILTER);
-
-	return features;
+	return iavf_fix_netdev_vlan_features(adapter, features);
 }
 
 static const struct net_device_ops iavf_netdev_ops = {
@@ -3750,6 +3980,7 @@ static int iavf_check_reset_complete(struct iavf_hw *hw)
 int iavf_process_config(struct iavf_adapter *adapter)
 {
 	struct virtchnl_vf_resource *vfres = adapter->vf_res;
+	netdev_features_t hw_vlan_features, vlan_features;
 	struct net_device *netdev = adapter->netdev;
 	netdev_features_t hw_enc_features;
 	netdev_features_t hw_features;
@@ -3797,19 +4028,19 @@ int iavf_process_config(struct iavf_adapter *adapter)
 	 */
 	hw_features = hw_enc_features;
 
-	/* Enable VLAN features if supported */
-	if (vfres->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_VLAN)
-		hw_features |= (NETIF_F_HW_VLAN_CTAG_TX |
-				NETIF_F_HW_VLAN_CTAG_RX);
+	/* get HW VLAN features that can be toggled */
+	hw_vlan_features = iavf_get_netdev_vlan_hw_features(adapter);
+
 	/* Enable cloud filter if ADQ is supported */
 	if (vfres->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_ADQ)
 		hw_features |= NETIF_F_HW_TC;
 	if (vfres->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_USO)
 		hw_features |= NETIF_F_GSO_UDP_L4;
 
-	netdev->hw_features |= hw_features;
+	netdev->hw_features |= hw_features | hw_vlan_features;
+	vlan_features = iavf_get_netdev_vlan_features(adapter);
 
-	netdev->features |= hw_features;
+	netdev->features |= hw_features | vlan_features;
 
 	if (vfres->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_VLAN)
 		netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 1ebff8dc38ba..783d829874bc 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -642,7 +642,6 @@ static void iavf_mac_add_reject(struct iavf_adapter *adapter)
  **/
 void iavf_add_vlans(struct iavf_adapter *adapter)
 {
-	struct virtchnl_vlan_filter_list *vvfl;
 	int len, i = 0, count = 0;
 	struct iavf_vlan_filter *f;
 	bool more = false;
@@ -660,48 +659,105 @@ void iavf_add_vlans(struct iavf_adapter *adapter)
 		if (f->add)
 			count++;
 	}
-	if (!count || !VLAN_ALLOWED(adapter)) {
+	if (!count || !VLAN_FILTERING_ALLOWED(adapter)) {
 		adapter->aq_required &= ~IAVF_FLAG_AQ_ADD_VLAN_FILTER;
 		spin_unlock_bh(&adapter->mac_vlan_list_lock);
 		return;
 	}
-	adapter->current_op = VIRTCHNL_OP_ADD_VLAN;
 
-	len = sizeof(struct virtchnl_vlan_filter_list) +
-	      (count * sizeof(u16));
-	if (len > IAVF_MAX_AQ_BUF_SIZE) {
-		dev_warn(&adapter->pdev->dev, "Too many add VLAN changes in one request\n");
-		count = (IAVF_MAX_AQ_BUF_SIZE -
-			 sizeof(struct virtchnl_vlan_filter_list)) /
-			sizeof(u16);
-		len = sizeof(struct virtchnl_vlan_filter_list) +
-		      (count * sizeof(u16));
-		more = true;
-	}
-	vvfl = kzalloc(len, GFP_ATOMIC);
-	if (!vvfl) {
+	if (VLAN_ALLOWED(adapter)) {
+		struct virtchnl_vlan_filter_list *vvfl;
+
+		adapter->current_op = VIRTCHNL_OP_ADD_VLAN;
+
+		len = sizeof(*vvfl) + (count * sizeof(u16));
+		if (len > IAVF_MAX_AQ_BUF_SIZE) {
+			dev_warn(&adapter->pdev->dev, "Too many add VLAN changes in one request\n");
+			count = (IAVF_MAX_AQ_BUF_SIZE - sizeof(*vvfl)) /
+				sizeof(u16);
+			len = sizeof(*vvfl) + (count * sizeof(u16));
+			more = true;
+		}
+		vvfl = kzalloc(len, GFP_ATOMIC);
+		if (!vvfl) {
+			spin_unlock_bh(&adapter->mac_vlan_list_lock);
+			return;
+		}
+
+		vvfl->vsi_id = adapter->vsi_res->vsi_id;
+		vvfl->num_elements = count;
+		list_for_each_entry(f, &adapter->vlan_filter_list, list) {
+			if (f->add) {
+				vvfl->vlan_id[i] = f->vlan.vid;
+				i++;
+				f->add = false;
+				if (i == count)
+					break;
+			}
+		}
+		if (!more)
+			adapter->aq_required &= ~IAVF_FLAG_AQ_ADD_VLAN_FILTER;
+
 		spin_unlock_bh(&adapter->mac_vlan_list_lock);
-		return;
-	}
 
-	vvfl->vsi_id = adapter->vsi_res->vsi_id;
-	vvfl->num_elements = count;
-	list_for_each_entry(f, &adapter->vlan_filter_list, list) {
-		if (f->add) {
-			vvfl->vlan_id[i] = f->vlan;
-			i++;
-			f->add = false;
-			if (i == count)
-				break;
+		iavf_send_pf_msg(adapter, VIRTCHNL_OP_ADD_VLAN, (u8 *)vvfl, len);
+		kfree(vvfl);
+	} else {
+		struct virtchnl_vlan_filter_list_v2 *vvfl_v2;
+
+		adapter->current_op = VIRTCHNL_OP_ADD_VLAN_V2;
+
+		len = sizeof(*vvfl_v2) + ((count - 1) *
+					  sizeof(struct virtchnl_vlan_filter));
+		if (len > IAVF_MAX_AQ_BUF_SIZE) {
+			dev_warn(&adapter->pdev->dev, "Too many add VLAN changes in one request\n");
+			count = (IAVF_MAX_AQ_BUF_SIZE - sizeof(*vvfl_v2)) /
+				sizeof(struct virtchnl_vlan_filter);
+			len = sizeof(*vvfl_v2) +
+				((count - 1) *
+				 sizeof(struct virtchnl_vlan_filter));
+			more = true;
 		}
-	}
-	if (!more)
-		adapter->aq_required &= ~IAVF_FLAG_AQ_ADD_VLAN_FILTER;
 
-	spin_unlock_bh(&adapter->mac_vlan_list_lock);
+		vvfl_v2 = kzalloc(len, GFP_ATOMIC);
+		if (!vvfl_v2) {
+			spin_unlock_bh(&adapter->mac_vlan_list_lock);
+			return;
+		}
 
-	iavf_send_pf_msg(adapter, VIRTCHNL_OP_ADD_VLAN, (u8 *)vvfl, len);
-	kfree(vvfl);
+		vvfl_v2->vport_id = adapter->vsi_res->vsi_id;
+		vvfl_v2->num_elements = count;
+		list_for_each_entry(f, &adapter->vlan_filter_list, list) {
+			if (f->add) {
+				struct virtchnl_vlan_supported_caps *filtering_support =
+					&adapter->vlan_v2_caps.filtering.filtering_support;
+				struct virtchnl_vlan *vlan;
+
+				/* give priority over outer if it's enabled */
+				if (filtering_support->outer)
+					vlan = &vvfl_v2->filters[i].outer;
+				else
+					vlan = &vvfl_v2->filters[i].inner;
+
+				vlan->tci = f->vlan.vid;
+				vlan->tpid = f->vlan.tpid;
+
+				i++;
+				f->add = false;
+				if (i == count)
+					break;
+			}
+		}
+
+		if (!more)
+			adapter->aq_required &= ~IAVF_FLAG_AQ_ADD_VLAN_FILTER;
+
+		spin_unlock_bh(&adapter->mac_vlan_list_lock);
+
+		iavf_send_pf_msg(adapter, VIRTCHNL_OP_ADD_VLAN_V2,
+				 (u8 *)vvfl_v2, len);
+		kfree(vvfl_v2);
+	}
 }
 
 /**
@@ -712,7 +768,6 @@ void iavf_add_vlans(struct iavf_adapter *adapter)
  **/
 void iavf_del_vlans(struct iavf_adapter *adapter)
 {
-	struct virtchnl_vlan_filter_list *vvfl;
 	struct iavf_vlan_filter *f, *ftmp;
 	int len, i = 0, count = 0;
 	bool more = false;
@@ -733,56 +788,116 @@ void iavf_del_vlans(struct iavf_adapter *adapter)
 		 * filters marked for removal to enable bailing out before
 		 * sending a virtchnl message
 		 */
-		if (f->remove && !VLAN_ALLOWED(adapter)) {
+		if (f->remove && !VLAN_FILTERING_ALLOWED(adapter)) {
 			list_del(&f->list);
 			kfree(f);
 		} else if (f->remove) {
 			count++;
 		}
 	}
-	if (!count) {
+	if (!count || !VLAN_FILTERING_ALLOWED(adapter)) {
 		adapter->aq_required &= ~IAVF_FLAG_AQ_DEL_VLAN_FILTER;
 		spin_unlock_bh(&adapter->mac_vlan_list_lock);
 		return;
 	}
-	adapter->current_op = VIRTCHNL_OP_DEL_VLAN;
 
-	len = sizeof(struct virtchnl_vlan_filter_list) +
-	      (count * sizeof(u16));
-	if (len > IAVF_MAX_AQ_BUF_SIZE) {
-		dev_warn(&adapter->pdev->dev, "Too many delete VLAN changes in one request\n");
-		count = (IAVF_MAX_AQ_BUF_SIZE -
-			 sizeof(struct virtchnl_vlan_filter_list)) /
-			sizeof(u16);
-		len = sizeof(struct virtchnl_vlan_filter_list) +
-		      (count * sizeof(u16));
-		more = true;
-	}
-	vvfl = kzalloc(len, GFP_ATOMIC);
-	if (!vvfl) {
+	if (VLAN_ALLOWED(adapter)) {
+		struct virtchnl_vlan_filter_list *vvfl;
+
+		adapter->current_op = VIRTCHNL_OP_DEL_VLAN;
+
+		len = sizeof(*vvfl) + (count * sizeof(u16));
+		if (len > IAVF_MAX_AQ_BUF_SIZE) {
+			dev_warn(&adapter->pdev->dev, "Too many delete VLAN changes in one request\n");
+			count = (IAVF_MAX_AQ_BUF_SIZE - sizeof(*vvfl)) /
+				sizeof(u16);
+			len = sizeof(*vvfl) + (count * sizeof(u16));
+			more = true;
+		}
+		vvfl = kzalloc(len, GFP_ATOMIC);
+		if (!vvfl) {
+			spin_unlock_bh(&adapter->mac_vlan_list_lock);
+			return;
+		}
+
+		vvfl->vsi_id = adapter->vsi_res->vsi_id;
+		vvfl->num_elements = count;
+		list_for_each_entry_safe(f, ftmp, &adapter->vlan_filter_list, list) {
+			if (f->remove) {
+				vvfl->vlan_id[i] = f->vlan.vid;
+				i++;
+				list_del(&f->list);
+				kfree(f);
+				if (i == count)
+					break;
+			}
+		}
+
+		if (!more)
+			adapter->aq_required &= ~IAVF_FLAG_AQ_DEL_VLAN_FILTER;
+
 		spin_unlock_bh(&adapter->mac_vlan_list_lock);
-		return;
-	}
 
-	vvfl->vsi_id = adapter->vsi_res->vsi_id;
-	vvfl->num_elements = count;
-	list_for_each_entry_safe(f, ftmp, &adapter->vlan_filter_list, list) {
-		if (f->remove) {
-			vvfl->vlan_id[i] = f->vlan;
-			i++;
-			list_del(&f->list);
-			kfree(f);
-			if (i == count)
-				break;
+		iavf_send_pf_msg(adapter, VIRTCHNL_OP_DEL_VLAN, (u8 *)vvfl, len);
+		kfree(vvfl);
+	} else {
+		struct virtchnl_vlan_filter_list_v2 *vvfl_v2;
+
+		adapter->current_op = VIRTCHNL_OP_DEL_VLAN_V2;
+
+		len = sizeof(*vvfl_v2) +
+			((count - 1) * sizeof(struct virtchnl_vlan_filter));
+		if (len > IAVF_MAX_AQ_BUF_SIZE) {
+			dev_warn(&adapter->pdev->dev, "Too many add VLAN changes in one request\n");
+			count = (IAVF_MAX_AQ_BUF_SIZE -
+				 sizeof(*vvfl_v2)) /
+				sizeof(struct virtchnl_vlan_filter);
+			len = sizeof(*vvfl_v2) +
+				((count - 1) *
+				 sizeof(struct virtchnl_vlan_filter));
+			more = true;
 		}
-	}
-	if (!more)
-		adapter->aq_required &= ~IAVF_FLAG_AQ_DEL_VLAN_FILTER;
 
-	spin_unlock_bh(&adapter->mac_vlan_list_lock);
+		vvfl_v2 = kzalloc(len, GFP_ATOMIC);
+		if (!vvfl_v2) {
+			spin_unlock_bh(&adapter->mac_vlan_list_lock);
+			return;
+		}
+
+		vvfl_v2->vport_id = adapter->vsi_res->vsi_id;
+		vvfl_v2->num_elements = count;
+		list_for_each_entry_safe(f, ftmp, &adapter->vlan_filter_list, list) {
+			if (f->remove) {
+				struct virtchnl_vlan_supported_caps *filtering_support =
+					&adapter->vlan_v2_caps.filtering.filtering_support;
+				struct virtchnl_vlan *vlan;
+
+				/* give priority over outer if it's enabled */
+				if (filtering_support->outer)
+					vlan = &vvfl_v2->filters[i].outer;
+				else
+					vlan = &vvfl_v2->filters[i].inner;
+
+				vlan->tci = f->vlan.vid;
+				vlan->tpid = f->vlan.tpid;
+
+				list_del(&f->list);
+				kfree(f);
+				i++;
+				if (i == count)
+					break;
+			}
+		}
 
-	iavf_send_pf_msg(adapter, VIRTCHNL_OP_DEL_VLAN, (u8 *)vvfl, len);
-	kfree(vvfl);
+		if (!more)
+			adapter->aq_required &= ~IAVF_FLAG_AQ_DEL_VLAN_FILTER;
+
+		spin_unlock_bh(&adapter->mac_vlan_list_lock);
+
+		iavf_send_pf_msg(adapter, VIRTCHNL_OP_DEL_VLAN_V2,
+				 (u8 *)vvfl_v2, len);
+		kfree(vvfl_v2);
+	}
 }
 
 /**
-- 
2.31.1

