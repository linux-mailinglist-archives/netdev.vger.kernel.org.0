Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 779ED232292
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 18:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgG2QYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 12:24:16 -0400
Received: from mga03.intel.com ([134.134.136.65]:57481 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726581AbgG2QYO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 12:24:14 -0400
IronPort-SDR: oDjhR0KG9eqWnMiKShaPf4nVuUGMAh0TgwEvy7NPWMWpzj/8sqqwLKuN+/3qPvZX8SiSABC7mC
 YaHzPzCH2Nbw==
X-IronPort-AV: E=McAfee;i="6000,8403,9697"; a="151430820"
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="151430820"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2020 09:24:12 -0700
IronPort-SDR: TeamhZaIVfYXQJPL5sd0eVJ6tj11UySzFu3oEM/xa1Skwfd8Xuvz5BsVSC5P7PMRAxRzCqp4Rb
 vyFRVf3n6jXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="313087547"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 29 Jul 2020 09:24:11 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 01/15] ice: Implement LFC workaround
Date:   Wed, 29 Jul 2020 09:23:51 -0700
Message-Id: <20200729162405.1596435-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200729162405.1596435-1-anthony.l.nguyen@intel.com>
References: <20200729162405.1596435-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

There is a bug where the LFC settings are not being preserved
through a link event.  The registers in question are the ones
that are touched (and restored) when a set_local_mib AQ command
is performed.

On a link-up event, make sure that a set_local_mib is being
performed.

Move the function ice_aq_set_lldp_mib() from the DCB specific
ice_dcb.c to ice_common.c so that the driver always has access
to this AQ command.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c  |  33 ++++++
 drivers/net/ethernet/intel/ice/ice_common.h  |   3 +
 drivers/net/ethernet/intel/ice/ice_dcb.c     |  33 ------
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c |   4 -
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h |  11 ++
 drivers/net/ethernet/intel/ice/ice_main.c    | 102 ++++++++++++++++++-
 6 files changed, 148 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 50939ad0e760..fd9534568bf3 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -4357,3 +4357,36 @@ bool ice_is_phy_caps_an_enabled(struct ice_aqc_get_phy_caps_data *caps)
 
 	return false;
 }
+
+/**
+ * ice_aq_set_lldp_mib - Set the LLDP MIB
+ * @hw: pointer to the HW struct
+ * @mib_type: Local, Remote or both Local and Remote MIBs
+ * @buf: pointer to the caller-supplied buffer to store the MIB block
+ * @buf_size: size of the buffer (in bytes)
+ * @cd: pointer to command details structure or NULL
+ *
+ * Set the LLDP MIB. (0x0A08)
+ */
+enum ice_status
+ice_aq_set_lldp_mib(struct ice_hw *hw, u8 mib_type, void *buf, u16 buf_size,
+		    struct ice_sq_cd *cd)
+{
+	struct ice_aqc_lldp_set_local_mib *cmd;
+	struct ice_aq_desc desc;
+
+	cmd = &desc.params.lldp_set_mib;
+
+	if (buf_size == 0 || !buf)
+		return ICE_ERR_PARAM;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_lldp_set_local_mib);
+
+	desc.flags |= cpu_to_le16((u16)ICE_AQ_FLAG_RD);
+	desc.datalen = cpu_to_le16(buf_size);
+
+	cmd->type = mib_type;
+	cmd->length = cpu_to_le16(buf_size);
+
+	return ice_aq_send_cmd(hw, &desc, buf, buf_size, cd);
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 906113db6be6..3ebb973878c7 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -172,4 +172,7 @@ ice_stat_update32(struct ice_hw *hw, u32 reg, bool prev_stat_loaded,
 enum ice_status
 ice_sched_query_elem(struct ice_hw *hw, u32 node_teid,
 		     struct ice_aqc_txsched_elem_data *buf);
+enum ice_status
+ice_aq_set_lldp_mib(struct ice_hw *hw, u8 mib_type, void *buf, u16 buf_size,
+		    struct ice_sq_cd *cd);
 #endif /* _ICE_COMMON_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb.c b/drivers/net/ethernet/intel/ice/ice_dcb.c
index 2cecc9d08005..2a3147ee0bbb 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb.c
@@ -134,39 +134,6 @@ ice_aq_start_lldp(struct ice_hw *hw, bool persist, struct ice_sq_cd *cd)
 	return ice_aq_send_cmd(hw, &desc, NULL, 0, cd);
 }
 
-/**
- * ice_aq_set_lldp_mib - Set the LLDP MIB
- * @hw: pointer to the HW struct
- * @mib_type: Local, Remote or both Local and Remote MIBs
- * @buf: pointer to the caller-supplied buffer to store the MIB block
- * @buf_size: size of the buffer (in bytes)
- * @cd: pointer to command details structure or NULL
- *
- * Set the LLDP MIB. (0x0A08)
- */
-static enum ice_status
-ice_aq_set_lldp_mib(struct ice_hw *hw, u8 mib_type, void *buf, u16 buf_size,
-		    struct ice_sq_cd *cd)
-{
-	struct ice_aqc_lldp_set_local_mib *cmd;
-	struct ice_aq_desc desc;
-
-	cmd = &desc.params.lldp_set_mib;
-
-	if (buf_size == 0 || !buf)
-		return ICE_ERR_PARAM;
-
-	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_lldp_set_local_mib);
-
-	desc.flags |= cpu_to_le16((u16)ICE_AQ_FLAG_RD);
-	desc.datalen = cpu_to_le16(buf_size);
-
-	cmd->type = mib_type;
-	cmd->length = cpu_to_le16(buf_size);
-
-	return ice_aq_send_cmd(hw, &desc, buf, buf_size, cd);
-}
-
 /**
  * ice_get_dcbx_status
  * @hw: pointer to the HW struct
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 979af197f8a3..3b3a2789eb55 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -444,10 +444,6 @@ void ice_dcb_rebuild(struct ice_pf *pf)
 		goto dcb_error;
 	}
 
-	/* If DCB was not enabled previously, we are done */
-	if (!test_bit(ICE_FLAG_DCB_ENA, pf->flags))
-		return;
-
 	mutex_lock(&pf->tc_mutex);
 
 	if (!pf->hw.port_info->is_sw_lldp)
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
index 323238669572..35c21d9ae009 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
@@ -53,6 +53,12 @@ ice_set_cgd_num(struct ice_tlan_ctx *tlan_ctx, struct ice_ring *ring)
 {
 	tlan_ctx->cgd_num = ring->dcb_tc;
 }
+
+static inline bool ice_is_dcb_active(struct ice_pf *pf)
+{
+	return (test_bit(ICE_FLAG_FW_LLDP_AGENT, pf->flags) ||
+		test_bit(ICE_FLAG_DCB_ENA, pf->flags));
+}
 #else
 #define ice_dcb_rebuild(pf) do {} while (0)
 
@@ -95,6 +101,11 @@ ice_tx_prepare_vlan_flags_dcb(struct ice_ring __always_unused *tx_ring,
 	return 0;
 }
 
+static inline bool ice_is_dcb_active(struct ice_pf __always_unused *pf)
+{
+	return false;
+}
+
 static inline bool
 ice_is_pfc_causing_hung_q(struct ice_pf __always_unused *pf,
 			  unsigned int __always_unused txqueue)
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 646c2cbc6904..fe0982d0717d 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -766,6 +766,100 @@ static void ice_vsi_link_event(struct ice_vsi *vsi, bool link_up)
 	}
 }
 
+/**
+ * ice_set_dflt_mib - send a default config MIB to the FW
+ * @pf: private PF struct
+ *
+ * This function sends a default configuration MIB to the FW.
+ *
+ * If this function errors out at any point, the driver is still able to
+ * function.  The main impact is that LFC may not operate as expected.
+ * Therefore an error state in this function should be treated with a DBG
+ * message and continue on with driver rebuild/reenable.
+ */
+static void ice_set_dflt_mib(struct ice_pf *pf)
+{
+	struct device *dev = ice_pf_to_dev(pf);
+	u8 mib_type, *buf, *lldpmib = NULL;
+	u16 len, typelen, offset = 0;
+	struct ice_lldp_org_tlv *tlv;
+	struct ice_hw *hw;
+	u32 ouisubtype;
+
+	if (!pf) {
+		dev_dbg(dev, "%s NULL pf pointer\n", __func__);
+		return;
+	}
+
+	hw = &pf->hw;
+	mib_type = SET_LOCAL_MIB_TYPE_LOCAL_MIB;
+	lldpmib = kzalloc(ICE_LLDPDU_SIZE, GFP_KERNEL);
+	if (!lldpmib) {
+		dev_dbg(dev, "%s Failed to allocate MIB memory\n",
+			__func__);
+		return;
+	}
+
+	/* Add ETS CFG TLV */
+	tlv = (struct ice_lldp_org_tlv *)lldpmib;
+	typelen = ((ICE_TLV_TYPE_ORG << ICE_LLDP_TLV_TYPE_S) |
+		   ICE_IEEE_ETS_TLV_LEN);
+	tlv->typelen = htons(typelen);
+	ouisubtype = ((ICE_IEEE_8021QAZ_OUI << ICE_LLDP_TLV_OUI_S) |
+		      ICE_IEEE_SUBTYPE_ETS_CFG);
+	tlv->ouisubtype = htonl(ouisubtype);
+
+	buf = tlv->tlvinfo;
+	buf[0] = 0;
+
+	/* ETS CFG all UPs map to TC 0. Next 4 (1 - 4) Octets = 0.
+	 * Octets 5 - 12 are BW values, set octet 5 to 100% BW.
+	 * Octets 13 - 20 are TSA values - leave as zeros
+	 */
+	buf[5] = 0x64;
+	len = (typelen & ICE_LLDP_TLV_LEN_M) >> ICE_LLDP_TLV_LEN_S;
+	offset += len + 2;
+	tlv = (struct ice_lldp_org_tlv *)
+		((char *)tlv + sizeof(tlv->typelen) + len);
+
+	/* Add ETS REC TLV */
+	buf = tlv->tlvinfo;
+	tlv->typelen = htons(typelen);
+
+	ouisubtype = ((ICE_IEEE_8021QAZ_OUI << ICE_LLDP_TLV_OUI_S) |
+		      ICE_IEEE_SUBTYPE_ETS_REC);
+	tlv->ouisubtype = htonl(ouisubtype);
+
+	/* First octet of buf is reserved
+	 * Octets 1 - 4 map UP to TC - all UPs map to zero
+	 * Octets 5 - 12 are BW values - set TC 0 to 100%.
+	 * Octets 13 - 20 are TSA value - leave as zeros
+	 */
+	buf[5] = 0x64;
+	offset += len + 2;
+	tlv = (struct ice_lldp_org_tlv *)
+		((char *)tlv + sizeof(tlv->typelen) + len);
+
+	/* Add PFC CFG TLV */
+	typelen = ((ICE_TLV_TYPE_ORG << ICE_LLDP_TLV_TYPE_S) |
+		   ICE_IEEE_PFC_TLV_LEN);
+	tlv->typelen = htons(typelen);
+
+	ouisubtype = ((ICE_IEEE_8021QAZ_OUI << ICE_LLDP_TLV_OUI_S) |
+		      ICE_IEEE_SUBTYPE_PFC_CFG);
+	tlv->ouisubtype = htonl(ouisubtype);
+
+	/* Octet 1 left as all zeros - PFC disabled */
+	buf[0] = 0x08;
+	len = (typelen & ICE_LLDP_TLV_LEN_M) >> ICE_LLDP_TLV_LEN_S;
+	offset += len + 2;
+
+	if (ice_aq_set_lldp_mib(hw, mib_type, (void *)lldpmib, offset, NULL))
+		dev_dbg(dev, "%s Failed to set default LLDP MIB\n", __func__);
+
+	kfree(lldpmib);
+}
+
 /**
  * ice_link_event - process the link event
  * @pf: PF that the link event is associated with
@@ -821,7 +915,13 @@ ice_link_event(struct ice_pf *pf, struct ice_port_info *pi, bool link_up,
 	if (link_up == old_link && link_speed == old_link_speed)
 		return result;
 
-	ice_dcb_rebuild(pf);
+	if (ice_is_dcb_active(pf)) {
+		if (test_bit(ICE_FLAG_DCB_ENA, pf->flags))
+			ice_dcb_rebuild(pf);
+	} else {
+		if (link_up)
+			ice_set_dflt_mib(pf);
+	}
 	ice_vsi_link_event(vsi, link_up);
 	ice_print_link_msg(vsi, link_up);
 
-- 
2.26.2

