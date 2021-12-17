Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C167A4796D6
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 23:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbhLQWHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 17:07:43 -0500
Received: from mga03.intel.com ([134.134.136.65]:43080 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229451AbhLQWHn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 17:07:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639778862; x=1671314862;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KSZQZM83rQPYVEkKFlYxp6CgaqAnmOBGoBvkdzd92AE=;
  b=KUPLSl83mGasVroeCebLFzk05750LHh/QxnUVGZU9nBQSxj5z2px1eJQ
   JFiUwZlQa1DwyvScm2ev2BIIRp5R91QeNcuUvZjYw4BD+VvshLv2Sp7jy
   wZVrSgLE2HP/92RqBqpENif7sJhtf5vTiQtVM3sY5NemQT8+zabtluKh0
   xcfF0TKZ4nBt40l0Tc3VlVkC0r5MmO1Mb+Iz08iM1dqPkYaghg98zIapp
   3KzDuw7Q7Jp5z20bKGq1JkAXviWDCky+4jr459bZQGaGcYVK8ExIvO0vm
   hRhmjHs0mjB96vjZKxcgCfRQ9gHt433OWSEV78bAQwVirEDIZ6TdzlX1k
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10201"; a="239794449"
X-IronPort-AV: E=Sophos;i="5.88,214,1635231600"; 
   d="scan'208";a="239794449"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 14:07:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,214,1635231600"; 
   d="scan'208";a="519922247"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 17 Dec 2021 14:07:42 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 1/6] virtchnl: Add support for new VLAN capabilities
Date:   Fri, 17 Dec 2021 14:06:42 -0800
Message-Id: <20211217220647.875246-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211217220647.875246-1-anthony.l.nguyen@intel.com>
References: <20211217220647.875246-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently VIRTCHNL only allows for VLAN filtering and offloads to happen
on a single 802.1Q VLAN. Add support to filter and offload on inner,
outer, and/or inner + outer VLANs.

This is done by introducing the new capability
VIRTCHNL_VF_OFFLOAD_VLAN_V2. The flow to negotiate this new capability
is shown below.

1. VF - sets the VIRTCHNL_VF_OFFLOAD_VLAN_V2 bit in the
   virtchnl_vf_resource.vf_caps_flags during the
   VIRTCHNL_OP_GET_VF_RESOURCES request message. The VF should also set
   the VIRTCHNL_VF_OFFLOAD_VLAN bit in case the PF driver doesn't support
   the new capability.

2. PF - sets the VLAN capability bit it supports in the
   VIRTCHNL_OP_GET_VF_RESOURCES response message. This will either be
   VIRTCHNL_VF_OFFLOAD_VLAN_V2, VIRTCHNL_VF_OFFLOAD_VLAN, or none.

3. VF - If the VIRTCHNL_VF_OFFLOAD_VLAN_V2 capability was ACK'd by the
   PF, then the VF needs to request the VLAN capabilities of the
   PF/Device by issuing a VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS request.
   If the VIRTCHNL_VF_OFFLOAD_VLAN capability was ACK'd then the VF
   knows only single 802.1Q VLAN filtering/offloads are supported. If no
   VLAN capability is ACK'd then the PF/Device doesn't support hardware
   VLAN filtering/offloads for this VF.

4. PF - Populates the virtchnl_vlan_caps structure based on what it
   allows/supports for that VF and sends that response via
   VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS.

After VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS is successfully negotiated
the VF driver needs to interpret the capabilities supported by the
underlying PF/Device. The VF will be allowed to filter/offload the
inner 802.1Q, outer (various ethertype), inner 802.1Q + outer
(various ethertypes), or none based on which fields are set.

The VF will also need to interpret where the VLAN tag should be inserted
and/or stripped based on the negotiated capabilities.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 include/linux/avf/virtchnl.h | 377 +++++++++++++++++++++++++++++++++++
 1 file changed, 377 insertions(+)

diff --git a/include/linux/avf/virtchnl.h b/include/linux/avf/virtchnl.h
index b30a1bc74fc7..2ce27e8e4f19 100644
--- a/include/linux/avf/virtchnl.h
+++ b/include/linux/avf/virtchnl.h
@@ -141,6 +141,13 @@ enum virtchnl_ops {
 	VIRTCHNL_OP_DEL_RSS_CFG = 46,
 	VIRTCHNL_OP_ADD_FDIR_FILTER = 47,
 	VIRTCHNL_OP_DEL_FDIR_FILTER = 48,
+	VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS = 51,
+	VIRTCHNL_OP_ADD_VLAN_V2 = 52,
+	VIRTCHNL_OP_DEL_VLAN_V2 = 53,
+	VIRTCHNL_OP_ENABLE_VLAN_STRIPPING_V2 = 54,
+	VIRTCHNL_OP_DISABLE_VLAN_STRIPPING_V2 = 55,
+	VIRTCHNL_OP_ENABLE_VLAN_INSERTION_V2 = 56,
+	VIRTCHNL_OP_DISABLE_VLAN_INSERTION_V2 = 57,
 	VIRTCHNL_OP_MAX,
 };
 
@@ -246,6 +253,7 @@ VIRTCHNL_CHECK_STRUCT_LEN(16, virtchnl_vsi_resource);
 #define VIRTCHNL_VF_OFFLOAD_REQ_QUEUES		BIT(6)
 /* used to negotiate communicating link speeds in Mbps */
 #define VIRTCHNL_VF_CAP_ADV_LINK_SPEED		BIT(7)
+#define VIRTCHNL_VF_OFFLOAD_VLAN_V2		BIT(15)
 #define VIRTCHNL_VF_OFFLOAD_VLAN		BIT(16)
 #define VIRTCHNL_VF_OFFLOAD_RX_POLLING		BIT(17)
 #define VIRTCHNL_VF_OFFLOAD_RSS_PCTYPE_V2	BIT(18)
@@ -475,6 +483,351 @@ struct virtchnl_vlan_filter_list {
 
 VIRTCHNL_CHECK_STRUCT_LEN(6, virtchnl_vlan_filter_list);
 
+/* This enum is used for all of the VIRTCHNL_VF_OFFLOAD_VLAN_V2_CAPS related
+ * structures and opcodes.
+ *
+ * VIRTCHNL_VLAN_UNSUPPORTED - This field is not supported and if a VF driver
+ * populates it the PF should return VIRTCHNL_STATUS_ERR_NOT_SUPPORTED.
+ *
+ * VIRTCHNL_VLAN_ETHERTYPE_8100 - This field supports 0x8100 ethertype.
+ * VIRTCHNL_VLAN_ETHERTYPE_88A8 - This field supports 0x88A8 ethertype.
+ * VIRTCHNL_VLAN_ETHERTYPE_9100 - This field supports 0x9100 ethertype.
+ *
+ * VIRTCHNL_VLAN_ETHERTYPE_AND - Used when multiple ethertypes can be supported
+ * by the PF concurrently. For example, if the PF can support
+ * VIRTCHNL_VLAN_ETHERTYPE_8100 AND VIRTCHNL_VLAN_ETHERTYPE_88A8 filters it
+ * would OR the following bits:
+ *
+ *	VIRTHCNL_VLAN_ETHERTYPE_8100 |
+ *	VIRTCHNL_VLAN_ETHERTYPE_88A8 |
+ *	VIRTCHNL_VLAN_ETHERTYPE_AND;
+ *
+ * The VF would interpret this as VLAN filtering can be supported on both 0x8100
+ * and 0x88A8 VLAN ethertypes.
+ *
+ * VIRTCHNL_ETHERTYPE_XOR - Used when only a single ethertype can be supported
+ * by the PF concurrently. For example if the PF can support
+ * VIRTCHNL_VLAN_ETHERTYPE_8100 XOR VIRTCHNL_VLAN_ETHERTYPE_88A8 stripping
+ * offload it would OR the following bits:
+ *
+ *	VIRTCHNL_VLAN_ETHERTYPE_8100 |
+ *	VIRTCHNL_VLAN_ETHERTYPE_88A8 |
+ *	VIRTCHNL_VLAN_ETHERTYPE_XOR;
+ *
+ * The VF would interpret this as VLAN stripping can be supported on either
+ * 0x8100 or 0x88a8 VLAN ethertypes. So when requesting VLAN stripping via
+ * VIRTCHNL_OP_ENABLE_VLAN_STRIPPING_V2 the specified ethertype will override
+ * the previously set value.
+ *
+ * VIRTCHNL_VLAN_TAG_LOCATION_L2TAG1 - Used to tell the VF to insert and/or
+ * strip the VLAN tag using the L2TAG1 field of the Tx/Rx descriptors.
+ *
+ * VIRTCHNL_VLAN_TAG_LOCATION_L2TAG2 - Used to tell the VF to insert hardware
+ * offloaded VLAN tags using the L2TAG2 field of the Tx descriptor.
+ *
+ * VIRTCHNL_VLAN_TAG_LOCATION_L2TAG2 - Used to tell the VF to strip hardware
+ * offloaded VLAN tags using the L2TAG2_2 field of the Rx descriptor.
+ *
+ * VIRTCHNL_VLAN_PRIO - This field supports VLAN priority bits. This is used for
+ * VLAN filtering if the underlying PF supports it.
+ *
+ * VIRTCHNL_VLAN_TOGGLE_ALLOWED - This field is used to say whether a
+ * certain VLAN capability can be toggled. For example if the underlying PF/CP
+ * allows the VF to toggle VLAN filtering, stripping, and/or insertion it should
+ * set this bit along with the supported ethertypes.
+ */
+enum virtchnl_vlan_support {
+	VIRTCHNL_VLAN_UNSUPPORTED =		0,
+	VIRTCHNL_VLAN_ETHERTYPE_8100 =		BIT(0),
+	VIRTCHNL_VLAN_ETHERTYPE_88A8 =		BIT(1),
+	VIRTCHNL_VLAN_ETHERTYPE_9100 =		BIT(2),
+	VIRTCHNL_VLAN_TAG_LOCATION_L2TAG1 =	BIT(8),
+	VIRTCHNL_VLAN_TAG_LOCATION_L2TAG2 =	BIT(9),
+	VIRTCHNL_VLAN_TAG_LOCATION_L2TAG2_2 =	BIT(10),
+	VIRTCHNL_VLAN_PRIO =			BIT(24),
+	VIRTCHNL_VLAN_FILTER_MASK =		BIT(28),
+	VIRTCHNL_VLAN_ETHERTYPE_AND =		BIT(29),
+	VIRTCHNL_VLAN_ETHERTYPE_XOR =		BIT(30),
+	VIRTCHNL_VLAN_TOGGLE =			BIT(31),
+};
+
+/* This structure is used as part of the VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS
+ * for filtering, insertion, and stripping capabilities.
+ *
+ * If only outer capabilities are supported (for filtering, insertion, and/or
+ * stripping) then this refers to the outer most or single VLAN from the VF's
+ * perspective.
+ *
+ * If only inner capabilities are supported (for filtering, insertion, and/or
+ * stripping) then this refers to the outer most or single VLAN from the VF's
+ * perspective. Functionally this is the same as if only outer capabilities are
+ * supported. The VF driver is just forced to use the inner fields when
+ * adding/deleting filters and enabling/disabling offloads (if supported).
+ *
+ * If both outer and inner capabilities are supported (for filtering, insertion,
+ * and/or stripping) then outer refers to the outer most or single VLAN and
+ * inner refers to the second VLAN, if it exists, in the packet.
+ *
+ * There is no support for tunneled VLAN offloads, so outer or inner are never
+ * referring to a tunneled packet from the VF's perspective.
+ */
+struct virtchnl_vlan_supported_caps {
+	u32 outer;
+	u32 inner;
+};
+
+/* The PF populates these fields based on the supported VLAN filtering. If a
+ * field is VIRTCHNL_VLAN_UNSUPPORTED then it's not supported and the PF will
+ * reject any VIRTCHNL_OP_ADD_VLAN_V2 or VIRTCHNL_OP_DEL_VLAN_V2 messages using
+ * the unsupported fields.
+ *
+ * Also, a VF is only allowed to toggle its VLAN filtering setting if the
+ * VIRTCHNL_VLAN_TOGGLE bit is set.
+ *
+ * The ethertype(s) specified in the ethertype_init field are the ethertypes
+ * enabled for VLAN filtering. VLAN filtering in this case refers to the outer
+ * most VLAN from the VF's perspective. If both inner and outer filtering are
+ * allowed then ethertype_init only refers to the outer most VLAN as only
+ * VLAN ethertype supported for inner VLAN filtering is
+ * VIRTCHNL_VLAN_ETHERTYPE_8100. By default, inner VLAN filtering is disabled
+ * when both inner and outer filtering are allowed.
+ *
+ * The max_filters field tells the VF how many VLAN filters it's allowed to have
+ * at any one time. If it exceeds this amount and tries to add another filter,
+ * then the request will be rejected by the PF. To prevent failures, the VF
+ * should keep track of how many VLAN filters it has added and not attempt to
+ * add more than max_filters.
+ */
+struct virtchnl_vlan_filtering_caps {
+	struct virtchnl_vlan_supported_caps filtering_support;
+	u32 ethertype_init;
+	u16 max_filters;
+	u8 pad[2];
+};
+
+VIRTCHNL_CHECK_STRUCT_LEN(16, virtchnl_vlan_filtering_caps);
+
+/* This enum is used for the virtchnl_vlan_offload_caps structure to specify
+ * if the PF supports a different ethertype for stripping and insertion.
+ *
+ * VIRTCHNL_ETHERTYPE_STRIPPING_MATCHES_INSERTION - The ethertype(s) specified
+ * for stripping affect the ethertype(s) specified for insertion and visa versa
+ * as well. If the VF tries to configure VLAN stripping via
+ * VIRTCHNL_OP_ENABLE_VLAN_STRIPPING_V2 with VIRTCHNL_VLAN_ETHERTYPE_8100 then
+ * that will be the ethertype for both stripping and insertion.
+ *
+ * VIRTCHNL_ETHERTYPE_MATCH_NOT_REQUIRED - The ethertype(s) specified for
+ * stripping do not affect the ethertype(s) specified for insertion and visa
+ * versa.
+ */
+enum virtchnl_vlan_ethertype_match {
+	VIRTCHNL_ETHERTYPE_STRIPPING_MATCHES_INSERTION = 0,
+	VIRTCHNL_ETHERTYPE_MATCH_NOT_REQUIRED = 1,
+};
+
+/* The PF populates these fields based on the supported VLAN offloads. If a
+ * field is VIRTCHNL_VLAN_UNSUPPORTED then it's not supported and the PF will
+ * reject any VIRTCHNL_OP_ENABLE_VLAN_STRIPPING_V2 or
+ * VIRTCHNL_OP_DISABLE_VLAN_STRIPPING_V2 messages using the unsupported fields.
+ *
+ * Also, a VF is only allowed to toggle its VLAN offload setting if the
+ * VIRTCHNL_VLAN_TOGGLE_ALLOWED bit is set.
+ *
+ * The VF driver needs to be aware of how the tags are stripped by hardware and
+ * inserted by the VF driver based on the level of offload support. The PF will
+ * populate these fields based on where the VLAN tags are expected to be
+ * offloaded via the VIRTHCNL_VLAN_TAG_LOCATION_* bits. The VF will need to
+ * interpret these fields. See the definition of the
+ * VIRTCHNL_VLAN_TAG_LOCATION_* bits above the virtchnl_vlan_support
+ * enumeration.
+ */
+struct virtchnl_vlan_offload_caps {
+	struct virtchnl_vlan_supported_caps stripping_support;
+	struct virtchnl_vlan_supported_caps insertion_support;
+	u32 ethertype_init;
+	u8 ethertype_match;
+	u8 pad[3];
+};
+
+VIRTCHNL_CHECK_STRUCT_LEN(24, virtchnl_vlan_offload_caps);
+
+/* VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS
+ * VF sends this message to determine its VLAN capabilities.
+ *
+ * PF will mark which capabilities it supports based on hardware support and
+ * current configuration. For example, if a port VLAN is configured the PF will
+ * not allow outer VLAN filtering, stripping, or insertion to be configured so
+ * it will block these features from the VF.
+ *
+ * The VF will need to cross reference its capabilities with the PFs
+ * capabilities in the response message from the PF to determine the VLAN
+ * support.
+ */
+struct virtchnl_vlan_caps {
+	struct virtchnl_vlan_filtering_caps filtering;
+	struct virtchnl_vlan_offload_caps offloads;
+};
+
+VIRTCHNL_CHECK_STRUCT_LEN(40, virtchnl_vlan_caps);
+
+struct virtchnl_vlan {
+	u16 tci;	/* tci[15:13] = PCP and tci[11:0] = VID */
+	u16 tci_mask;	/* only valid if VIRTCHNL_VLAN_FILTER_MASK set in
+			 * filtering caps
+			 */
+	u16 tpid;	/* 0x8100, 0x88a8, etc. and only type(s) set in
+			 * filtering caps. Note that tpid here does not refer to
+			 * VIRTCHNL_VLAN_ETHERTYPE_*, but it refers to the
+			 * actual 2-byte VLAN TPID
+			 */
+	u8 pad[2];
+};
+
+VIRTCHNL_CHECK_STRUCT_LEN(8, virtchnl_vlan);
+
+struct virtchnl_vlan_filter {
+	struct virtchnl_vlan inner;
+	struct virtchnl_vlan outer;
+	u8 pad[16];
+};
+
+VIRTCHNL_CHECK_STRUCT_LEN(32, virtchnl_vlan_filter);
+
+/* VIRTCHNL_OP_ADD_VLAN_V2
+ * VIRTCHNL_OP_DEL_VLAN_V2
+ *
+ * VF sends these messages to add/del one or more VLAN tag filters for Rx
+ * traffic.
+ *
+ * The PF attempts to add the filters and returns status.
+ *
+ * The VF should only ever attempt to add/del virtchnl_vlan_filter(s) using the
+ * supported fields negotiated via VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS.
+ */
+struct virtchnl_vlan_filter_list_v2 {
+	u16 vport_id;
+	u16 num_elements;
+	u8 pad[4];
+	struct virtchnl_vlan_filter filters[1];
+};
+
+VIRTCHNL_CHECK_STRUCT_LEN(40, virtchnl_vlan_filter_list_v2);
+
+/* VIRTCHNL_OP_ENABLE_VLAN_STRIPPING_V2
+ * VIRTCHNL_OP_DISABLE_VLAN_STRIPPING_V2
+ * VIRTCHNL_OP_ENABLE_VLAN_INSERTION_V2
+ * VIRTCHNL_OP_DISABLE_VLAN_INSERTION_V2
+ *
+ * VF sends this message to enable or disable VLAN stripping or insertion. It
+ * also needs to specify an ethertype. The VF knows which VLAN ethertypes are
+ * allowed and whether or not it's allowed to enable/disable the specific
+ * offload via the VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS message. The VF needs to
+ * parse the virtchnl_vlan_caps.offloads fields to determine which offload
+ * messages are allowed.
+ *
+ * For example, if the PF populates the virtchnl_vlan_caps.offloads in the
+ * following manner the VF will be allowed to enable and/or disable 0x8100 inner
+ * VLAN insertion and/or stripping via the opcodes listed above. Inner in this
+ * case means the outer most or single VLAN from the VF's perspective. This is
+ * because no outer offloads are supported. See the comments above the
+ * virtchnl_vlan_supported_caps structure for more details.
+ *
+ * virtchnl_vlan_caps.offloads.stripping_support.inner =
+ *			VIRTCHNL_VLAN_TOGGLE |
+ *			VIRTCHNL_VLAN_ETHERTYPE_8100;
+ *
+ * virtchnl_vlan_caps.offloads.insertion_support.inner =
+ *			VIRTCHNL_VLAN_TOGGLE |
+ *			VIRTCHNL_VLAN_ETHERTYPE_8100;
+ *
+ * In order to enable inner (again note that in this case inner is the outer
+ * most or single VLAN from the VF's perspective) VLAN stripping for 0x8100
+ * VLANs, the VF would populate the virtchnl_vlan_setting structure in the
+ * following manner and send the VIRTCHNL_OP_ENABLE_VLAN_STRIPPING_V2 message.
+ *
+ * virtchnl_vlan_setting.inner_ethertype_setting =
+ *			VIRTCHNL_VLAN_ETHERTYPE_8100;
+ *
+ * virtchnl_vlan_setting.vport_id = vport_id or vsi_id assigned to the VF on
+ * initialization.
+ *
+ * The reason that VLAN TPID(s) are not being used for the
+ * outer_ethertype_setting and inner_ethertype_setting fields is because it's
+ * possible a device could support VLAN insertion and/or stripping offload on
+ * multiple ethertypes concurrently, so this method allows a VF to request
+ * multiple ethertypes in one message using the virtchnl_vlan_support
+ * enumeration.
+ *
+ * For example, if the PF populates the virtchnl_vlan_caps.offloads in the
+ * following manner the VF will be allowed to enable 0x8100 and 0x88a8 outer
+ * VLAN insertion and stripping simultaneously. The
+ * virtchnl_vlan_caps.offloads.ethertype_match field will also have to be
+ * populated based on what the PF can support.
+ *
+ * virtchnl_vlan_caps.offloads.stripping_support.outer =
+ *			VIRTCHNL_VLAN_TOGGLE |
+ *			VIRTCHNL_VLAN_ETHERTYPE_8100 |
+ *			VIRTCHNL_VLAN_ETHERTYPE_88A8 |
+ *			VIRTCHNL_VLAN_ETHERTYPE_AND;
+ *
+ * virtchnl_vlan_caps.offloads.insertion_support.outer =
+ *			VIRTCHNL_VLAN_TOGGLE |
+ *			VIRTCHNL_VLAN_ETHERTYPE_8100 |
+ *			VIRTCHNL_VLAN_ETHERTYPE_88A8 |
+ *			VIRTCHNL_VLAN_ETHERTYPE_AND;
+ *
+ * In order to enable outer VLAN stripping for 0x8100 and 0x88a8 VLANs, the VF
+ * would populate the virthcnl_vlan_offload_structure in the following manner
+ * and send the VIRTCHNL_OP_ENABLE_VLAN_STRIPPING_V2 message.
+ *
+ * virtchnl_vlan_setting.outer_ethertype_setting =
+ *			VIRTHCNL_VLAN_ETHERTYPE_8100 |
+ *			VIRTHCNL_VLAN_ETHERTYPE_88A8;
+ *
+ * virtchnl_vlan_setting.vport_id = vport_id or vsi_id assigned to the VF on
+ * initialization.
+ *
+ * There is also the case where a PF and the underlying hardware can support
+ * VLAN offloads on multiple ethertypes, but not concurrently. For example, if
+ * the PF populates the virtchnl_vlan_caps.offloads in the following manner the
+ * VF will be allowed to enable and/or disable 0x8100 XOR 0x88a8 outer VLAN
+ * offloads. The ethertypes must match for stripping and insertion.
+ *
+ * virtchnl_vlan_caps.offloads.stripping_support.outer =
+ *			VIRTCHNL_VLAN_TOGGLE |
+ *			VIRTCHNL_VLAN_ETHERTYPE_8100 |
+ *			VIRTCHNL_VLAN_ETHERTYPE_88A8 |
+ *			VIRTCHNL_VLAN_ETHERTYPE_XOR;
+ *
+ * virtchnl_vlan_caps.offloads.insertion_support.outer =
+ *			VIRTCHNL_VLAN_TOGGLE |
+ *			VIRTCHNL_VLAN_ETHERTYPE_8100 |
+ *			VIRTCHNL_VLAN_ETHERTYPE_88A8 |
+ *			VIRTCHNL_VLAN_ETHERTYPE_XOR;
+ *
+ * virtchnl_vlan_caps.offloads.ethertype_match =
+ *			VIRTCHNL_ETHERTYPE_STRIPPING_MATCHES_INSERTION;
+ *
+ * In order to enable outer VLAN stripping for 0x88a8 VLANs, the VF would
+ * populate the virtchnl_vlan_setting structure in the following manner and send
+ * the VIRTCHNL_OP_ENABLE_VLAN_STRIPPING_V2. Also, this will change the
+ * ethertype for VLAN insertion if it's enabled. So, for completeness, a
+ * VIRTCHNL_OP_ENABLE_VLAN_INSERTION_V2 with the same ethertype should be sent.
+ *
+ * virtchnl_vlan_setting.outer_ethertype_setting = VIRTHCNL_VLAN_ETHERTYPE_88A8;
+ *
+ * virtchnl_vlan_setting.vport_id = vport_id or vsi_id assigned to the VF on
+ * initialization.
+ */
+struct virtchnl_vlan_setting {
+	u32 outer_ethertype_setting;
+	u32 inner_ethertype_setting;
+	u16 vport_id;
+	u8 pad[6];
+};
+
+VIRTCHNL_CHECK_STRUCT_LEN(16, virtchnl_vlan_setting);
+
 /* VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE
  * VF sends VSI id and flags.
  * PF returns status code in retval.
@@ -1156,6 +1509,30 @@ virtchnl_vc_validate_vf_msg(struct virtchnl_version_info *ver, u32 v_opcode,
 	case VIRTCHNL_OP_DEL_FDIR_FILTER:
 		valid_len = sizeof(struct virtchnl_fdir_del);
 		break;
+	case VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS:
+		break;
+	case VIRTCHNL_OP_ADD_VLAN_V2:
+	case VIRTCHNL_OP_DEL_VLAN_V2:
+		valid_len = sizeof(struct virtchnl_vlan_filter_list_v2);
+		if (msglen >= valid_len) {
+			struct virtchnl_vlan_filter_list_v2 *vfl =
+			    (struct virtchnl_vlan_filter_list_v2 *)msg;
+
+			valid_len += (vfl->num_elements - 1) *
+				sizeof(struct virtchnl_vlan_filter);
+
+			if (vfl->num_elements == 0) {
+				err_msg_format = true;
+				break;
+			}
+		}
+		break;
+	case VIRTCHNL_OP_ENABLE_VLAN_STRIPPING_V2:
+	case VIRTCHNL_OP_DISABLE_VLAN_STRIPPING_V2:
+	case VIRTCHNL_OP_ENABLE_VLAN_INSERTION_V2:
+	case VIRTCHNL_OP_DISABLE_VLAN_INSERTION_V2:
+		valid_len = sizeof(struct virtchnl_vlan_setting);
+		break;
 	/* These are always errors coming from the VF. */
 	case VIRTCHNL_OP_EVENT:
 	case VIRTCHNL_OP_UNKNOWN:
-- 
2.31.1

