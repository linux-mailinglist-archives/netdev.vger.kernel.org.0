Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20FC542603A
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 01:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241302AbhJGXKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 19:10:41 -0400
Received: from mga03.intel.com ([134.134.136.65]:15520 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234163AbhJGXKY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 19:10:24 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10130"; a="226340365"
X-IronPort-AV: E=Sophos;i="5.85,355,1624345200"; 
   d="scan'208";a="226340365"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 16:08:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,355,1624345200"; 
   d="scan'208";a="590344364"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 07 Oct 2021 16:08:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Grzegorz Nitka <grzegorz.nitka@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, jiri@resnulli.us, ivecera@redhat.com,
        michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 11/12] ice: switchdev slow path
Date:   Thu,  7 Oct 2021 16:06:19 -0700
Message-Id: <20211007230620.3413290-12-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007230620.3413290-1-anthony.l.nguyen@intel.com>
References: <20211007230620.3413290-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grzegorz Nitka <grzegorz.nitka@intel.com>

Slow path means allowing packet to go from uplink to representor
and from representor to correct VF on Rx site and from VF to
representor and to uplink on Tx site.

To accomplish this driver, has to set correct Tx descriptor. When
packet is sent from representor to VF, destination should be
set to VF VSI. When packet is sent from uplink port destination
should be uplink to bypass switch infrastructure and send packet
outside.

On Rx site driver should check source VSI field from Rx descriptor
and based on that forward packed to correct netdev. To allow
this there is a target netdevs table in control plane VSI
struct.

Co-developed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Grzegorz Nitka <grzegorz.nitka@intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_eswitch.c  | 80 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_eswitch.h  | 26 ++++++
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    | 43 ++++++++++
 drivers/net/ethernet/intel/ice/ice_repr.c     |  1 +
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  3 +
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  4 +-
 6 files changed, 156 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
index 0acbe29fa091..477e3f2d616d 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -258,6 +258,58 @@ void ice_eswitch_update_repr(struct ice_vsi *vsi)
 	}
 }
 
+/**
+ * ice_eswitch_port_start_xmit - callback for packets transmit
+ * @skb: send buffer
+ * @netdev: network interface device structure
+ *
+ * Returns NETDEV_TX_OK if sent, else an error code
+ */
+netdev_tx_t
+ice_eswitch_port_start_xmit(struct sk_buff *skb, struct net_device *netdev)
+{
+	struct ice_netdev_priv *np;
+	struct ice_repr *repr;
+	struct ice_vsi *vsi;
+
+	np = netdev_priv(netdev);
+	vsi = np->vsi;
+
+	if (ice_is_reset_in_progress(vsi->back->state))
+		return NETDEV_TX_BUSY;
+
+	repr = ice_netdev_to_repr(netdev);
+	skb_dst_drop(skb);
+	dst_hold((struct dst_entry *)repr->dst);
+	skb_dst_set(skb, (struct dst_entry *)repr->dst);
+	skb->queue_mapping = repr->vf->vf_id;
+
+	return ice_start_xmit(skb, netdev);
+}
+
+/**
+ * ice_eswitch_set_target_vsi - set switchdev context in Tx context descriptor
+ * @skb: pointer to send buffer
+ * @off: pointer to offload struct
+ */
+void
+ice_eswitch_set_target_vsi(struct sk_buff *skb,
+			   struct ice_tx_offload_params *off)
+{
+	struct metadata_dst *dst = skb_metadata_dst(skb);
+	u64 cd_cmd, dst_vsi;
+
+	if (!dst) {
+		cd_cmd = ICE_TX_CTX_DESC_SWTCH_UPLINK << ICE_TXD_CTX_QW1_CMD_S;
+		off->cd_qw1 |= (cd_cmd | ICE_TX_DESC_DTYPE_CTX);
+	} else {
+		cd_cmd = ICE_TX_CTX_DESC_SWTCH_VSI << ICE_TXD_CTX_QW1_CMD_S;
+		dst_vsi = ((u64)dst->u.port_info.port_id <<
+			   ICE_TXD_CTX_QW1_VSI_S) & ICE_TXD_CTX_QW1_VSI_M;
+		off->cd_qw1 = cd_cmd | dst_vsi | ICE_TX_DESC_DTYPE_CTX;
+	}
+}
+
 /**
  * ice_eswitch_release_env - clear switchdev HW filters
  * @pf: pointer to PF struct
@@ -448,6 +500,34 @@ ice_eswitch_mode_set(struct devlink *devlink, u16 mode,
 	return 0;
 }
 
+/**
+ * ice_eswitch_get_target_netdev - return port representor netdev
+ * @rx_ring: pointer to Rx ring
+ * @rx_desc: pointer to Rx descriptor
+ *
+ * When working in switchdev mode context (when control VSI is used), this
+ * function returns netdev of appropriate port representor. For non-switchdev
+ * context, regular netdev associated with Rx ring is returned.
+ */
+struct net_device *
+ice_eswitch_get_target_netdev(struct ice_ring *rx_ring,
+			      union ice_32b_rx_flex_desc *rx_desc)
+{
+	struct ice_32b_rx_flex_desc_nic_2 *desc;
+	struct ice_vsi *vsi = rx_ring->vsi;
+	struct ice_vsi *control_vsi;
+	u16 target_vsi_id;
+
+	control_vsi = vsi->back->switchdev.control_vsi;
+	if (vsi != control_vsi)
+		return rx_ring->netdev;
+
+	desc = (struct ice_32b_rx_flex_desc_nic_2 *)rx_desc;
+	target_vsi_id = le16_to_cpu(desc->src_vsi);
+
+	return vsi->target_netdevs[target_vsi_id];
+}
+
 /**
  * ice_eswitch_mode_get - get current eswitch mode
  * @devlink: pointer to devlink structure
diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.h b/drivers/net/ethernet/intel/ice/ice_eswitch.h
index 609774bf1c3e..23df0d400847 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.h
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.h
@@ -20,11 +20,24 @@ bool ice_is_eswitch_mode_switchdev(struct ice_pf *pf);
 void ice_eswitch_update_repr(struct ice_vsi *vsi);
 
 void ice_eswitch_stop_all_tx_queues(struct ice_pf *pf);
+
+struct net_device *
+ice_eswitch_get_target_netdev(struct ice_ring *rx_ring,
+			      union ice_32b_rx_flex_desc *rx_desc);
+
+void ice_eswitch_set_target_vsi(struct sk_buff *skb,
+				struct ice_tx_offload_params *off);
+netdev_tx_t
+ice_eswitch_port_start_xmit(struct sk_buff *skb, struct net_device *netdev);
 #else /* CONFIG_ICE_SWITCHDEV */
 static inline void ice_eswitch_release(struct ice_pf *pf) { }
 
 static inline void ice_eswitch_stop_all_tx_queues(struct ice_pf *pf) { }
 
+static inline void
+ice_eswitch_set_target_vsi(struct sk_buff *skb,
+			   struct ice_tx_offload_params *off) { }
+
 static inline void ice_eswitch_update_repr(struct ice_vsi *vsi) { }
 
 static inline int ice_eswitch_configure(struct ice_pf *pf)
@@ -53,5 +66,18 @@ static inline bool ice_is_eswitch_mode_switchdev(struct ice_pf *pf)
 {
 	return false;
 }
+
+static inline struct net_device *
+ice_eswitch_get_target_netdev(struct ice_ring *rx_ring,
+			      union ice_32b_rx_flex_desc *rx_desc)
+{
+	return rx_ring->netdev;
+}
+
+static inline netdev_tx_t
+ice_eswitch_port_start_xmit(struct sk_buff *skb, struct net_device *netdev)
+{
+	return NETDEV_TX_BUSY;
+}
 #endif /* CONFIG_ICE_SWITCHDEV */
 #endif /* _ICE_ESWITCH_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
index 80736e0ec0dc..d981dc6f2323 100644
--- a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
+++ b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
@@ -301,6 +301,46 @@ struct ice_32b_rx_flex_desc_nic {
 	} flex_ts;
 };
 
+/* Rx Flex Descriptor NIC Profile
+ * RxDID Profile ID 6
+ * Flex-field 0: RSS hash lower 16-bits
+ * Flex-field 1: RSS hash upper 16-bits
+ * Flex-field 2: Flow ID lower 16-bits
+ * Flex-field 3: Source VSI
+ * Flex-field 4: reserved, VLAN ID taken from L2Tag
+ */
+struct ice_32b_rx_flex_desc_nic_2 {
+	/* Qword 0 */
+	u8 rxdid;
+	u8 mir_id_umb_cast;
+	__le16 ptype_flexi_flags0;
+	__le16 pkt_len;
+	__le16 hdr_len_sph_flex_flags1;
+
+	/* Qword 1 */
+	__le16 status_error0;
+	__le16 l2tag1;
+	__le32 rss_hash;
+
+	/* Qword 2 */
+	__le16 status_error1;
+	u8 flexi_flags2;
+	u8 ts_low;
+	__le16 l2tag2_1st;
+	__le16 l2tag2_2nd;
+
+	/* Qword 3 */
+	__le16 flow_id;
+	__le16 src_vsi;
+	union {
+		struct {
+			__le16 rsvd;
+			__le16 flow_id_ipv6;
+		} flex;
+		__le32 ts_high;
+	} flex_ts;
+};
+
 /* Receive Flex Descriptor profile IDs: There are a total
  * of 64 profiles where profile IDs 0/1 are for legacy; and
  * profiles 2-63 are flex profiles that can be programmed
@@ -529,6 +569,9 @@ struct ice_tx_ctx_desc {
 
 #define ICE_TXD_CTX_QW1_MSS_S	50
 
+#define ICE_TXD_CTX_QW1_VSI_S	50
+#define ICE_TXD_CTX_QW1_VSI_M	(0x3FFULL << ICE_TXD_CTX_QW1_VSI_S)
+
 enum ice_tx_ctx_desc_cmd_bits {
 	ICE_TX_CTX_DESC_TSO		= 0x01,
 	ICE_TX_CTX_DESC_TSYN		= 0x02,
diff --git a/drivers/net/ethernet/intel/ice/ice_repr.c b/drivers/net/ethernet/intel/ice/ice_repr.c
index c558fb583e97..ee11bfc7bee1 100644
--- a/drivers/net/ethernet/intel/ice/ice_repr.c
+++ b/drivers/net/ethernet/intel/ice/ice_repr.c
@@ -114,6 +114,7 @@ static const struct net_device_ops ice_repr_netdev_ops = {
 	.ndo_get_phys_port_name = ice_repr_get_phys_port_name,
 	.ndo_open = ice_repr_open,
 	.ndo_stop = ice_repr_stop,
+	.ndo_start_xmit = ice_eswitch_port_start_xmit,
 	.ndo_get_devlink_port = ice_repr_get_devlink_port,
 };
 
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 13b2bdc25b0d..4da9420df1b0 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -14,6 +14,7 @@
 #include "ice_trace.h"
 #include "ice_dcb_lib.h"
 #include "ice_xsk.h"
+#include "ice_eswitch.h"
 
 #define ICE_RX_HDR_SIZE		256
 
@@ -2246,6 +2247,8 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_ring *tx_ring)
 					ICE_TXD_CTX_QW1_CMD_S);
 
 	ice_tstamp(tx_ring, skb, first, &offload);
+	if (ice_is_switchdev_running(vsi->back))
+		ice_eswitch_set_target_vsi(skb, &offload);
 
 	if (offload.cd_qw1 & ICE_TX_DESC_DTYPE_CTX) {
 		struct ice_tx_ctx_desc *cdesc;
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 171397dcf00a..e314a1aee0ff 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2019, Intel Corporation. */
 
 #include "ice_txrx_lib.h"
+#include "ice_eswitch.h"
 
 /**
  * ice_release_rx_desc - Store the new tail and head values
@@ -185,7 +186,8 @@ ice_process_skb_fields(struct ice_ring *rx_ring,
 	ice_rx_hash(rx_ring, rx_desc, skb, ptype);
 
 	/* modifies the skb - consumes the enet header */
-	skb->protocol = eth_type_trans(skb, rx_ring->netdev);
+	skb->protocol = eth_type_trans(skb, ice_eswitch_get_target_netdev
+				       (rx_ring, rx_desc));
 
 	ice_rx_csum(rx_ring, skb, rx_desc, ptype);
 
-- 
2.31.1

