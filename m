Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37C11317448
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 00:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233633AbhBJXYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 18:24:20 -0500
Received: from mga01.intel.com ([192.55.52.88]:20916 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233231AbhBJXYP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 18:24:15 -0500
IronPort-SDR: GkD3zKVWjGCGCTtqqTkq+VoHrCYzs/8/IOnr9xUABybDO4gPK0VkmW3KmmlhaaIF5cNsGpt/Zi
 njgWLoTONUWQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9891"; a="201287982"
X-IronPort-AV: E=Sophos;i="5.81,169,1610438400"; 
   d="scan'208";a="201287982"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2021 15:23:43 -0800
IronPort-SDR: 98BI70oi7VyeQHdH2Ukv1PPApoW4Gys9S2qvsj6tY+KT2bAnz479XxoPkoIaGGBuZKradSJrc0
 OV7KKfjk35gg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,169,1610438400"; 
   d="scan'208";a="361512339"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 10 Feb 2021 15:23:42 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 1/7] i40e: Add hardware configuration for software based DCB
Date:   Wed, 10 Feb 2021 15:24:30 -0800
Message-Id: <20210210232436.4084373-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210210232436.4084373-1-anthony.l.nguyen@intel.com>
References: <20210210232436.4084373-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

Add registers and definitions required for applying
DCB related hardware configuration.

Add functions responsible for calculating and setting proper
hardware configuration values for software based DCB functionality.

Add function responsible for invoking Admin Queue command, which
results in applying new DCB configuration to the hardware.

Update copyright dates as appropriate.

Software based DCB is a brand-new feature in i40e driver.
Before, DCB was implemented by Firmware LLDP agent only. The agent was
responsible for handling incoming DCB-related LLDP frames and
applying received DCB configuration to hardware.

New communication channel between software and hardware is required
for software driver. It must be able to calculate and configure all
the registers related for DCB feature.

Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/i40e/i40e_adminq_cmd.h |  11 +-
 drivers/net/ethernet/intel/i40e/i40e_common.c |  65 +-
 drivers/net/ethernet/intel/i40e/i40e_dcb.c    | 949 +++++++++++++++++-
 drivers/net/ethernet/intel/i40e/i40e_dcb.h    | 169 +++-
 .../net/ethernet/intel/i40e/i40e_prototype.h  |   9 +-
 .../net/ethernet/intel/i40e/i40e_register.h   | 172 +++-
 drivers/net/ethernet/intel/i40e/i40e_type.h   |   3 +-
 7 files changed, 1365 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
index 1e960c3c7ef0..ce626eace692 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright(c) 2013 - 2018 Intel Corporation. */
+/* Copyright(c) 2013 - 2021 Intel Corporation. */
 
 #ifndef _I40E_ADMINQ_CMD_H_
 #define _I40E_ADMINQ_CMD_H_
@@ -1080,6 +1080,7 @@ struct i40e_aqc_add_remove_control_packet_filter {
 #define I40E_AQC_ADD_CONTROL_PACKET_FLAGS_IGNORE_MAC	0x0001
 #define I40E_AQC_ADD_CONTROL_PACKET_FLAGS_DROP		0x0002
 #define I40E_AQC_ADD_CONTROL_PACKET_FLAGS_TX		0x0008
+#define I40E_AQC_ADD_CONTROL_PACKET_FLAGS_RX		0x0000
 	__le16	seid;
 	__le16	queue;
 	u8	reserved[2];
@@ -2184,6 +2185,14 @@ I40E_CHECK_STRUCT_LEN(0x20, i40e_aqc_get_cee_dcb_cfg_resp);
  *	Used to replace the local MIB of a given LLDP agent. e.g. DCBx
  */
 struct i40e_aqc_lldp_set_local_mib {
+#define SET_LOCAL_MIB_AC_TYPE_DCBX_SHIFT	0
+#define SET_LOCAL_MIB_AC_TYPE_DCBX_MASK	(1 << \
+					SET_LOCAL_MIB_AC_TYPE_DCBX_SHIFT)
+#define SET_LOCAL_MIB_AC_TYPE_LOCAL_MIB	0x0
+#define SET_LOCAL_MIB_AC_TYPE_NON_WILLING_APPS_SHIFT	(1)
+#define SET_LOCAL_MIB_AC_TYPE_NON_WILLING_APPS_MASK	(1 << \
+				SET_LOCAL_MIB_AC_TYPE_NON_WILLING_APPS_SHIFT)
+#define SET_LOCAL_MIB_AC_TYPE_NON_WILLING_APPS		0x1
 	u8	type;
 	u8	reserved0;
 	__le16	length;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index adc9e4fa4789..ec19e18305ec 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright(c) 2013 - 2018 Intel Corporation. */
+/* Copyright(c) 2013 - 2021 Intel Corporation. */
 
 #include "i40e.h"
 #include "i40e_type.h"
@@ -3661,6 +3661,46 @@ i40e_status i40e_aq_get_lldp_mib(struct i40e_hw *hw, u8 bridge_type,
 	return status;
 }
 
+/**
+ * i40e_aq_set_lldp_mib - Set the LLDP MIB
+ * @hw: pointer to the hw struct
+ * @mib_type: Local, Remote or both Local and Remote MIBs
+ * @buff: pointer to a user supplied buffer to store the MIB block
+ * @buff_size: size of the buffer (in bytes)
+ * @cmd_details: pointer to command details structure or NULL
+ *
+ * Set the LLDP MIB.
+ **/
+enum i40e_status_code
+i40e_aq_set_lldp_mib(struct i40e_hw *hw,
+		     u8 mib_type, void *buff, u16 buff_size,
+		     struct i40e_asq_cmd_details *cmd_details)
+{
+	struct i40e_aqc_lldp_set_local_mib *cmd;
+	enum i40e_status_code status;
+	struct i40e_aq_desc desc;
+
+	cmd = (struct i40e_aqc_lldp_set_local_mib *)&desc.params.raw;
+	if (buff_size == 0 || !buff)
+		return I40E_ERR_PARAM;
+
+	i40e_fill_default_direct_cmd_desc(&desc,
+					  i40e_aqc_opc_lldp_set_local_mib);
+	/* Indirect Command */
+	desc.flags |= cpu_to_le16((u16)(I40E_AQ_FLAG_BUF | I40E_AQ_FLAG_RD));
+	if (buff_size > I40E_AQ_LARGE_BUF)
+		desc.flags |= cpu_to_le16((u16)I40E_AQ_FLAG_LB);
+	desc.datalen = cpu_to_le16(buff_size);
+
+	cmd->type = mib_type;
+	cmd->length = cpu_to_le16(buff_size);
+	cmd->address_high = cpu_to_le32(upper_32_bits((uintptr_t)buff));
+	cmd->address_low = cpu_to_le32(lower_32_bits((uintptr_t)buff));
+
+	status = i40e_asq_send_command(hw, &desc, buff, buff_size, cmd_details);
+	return status;
+}
+
 /**
  * i40e_aq_cfg_lldp_mib_change_event
  * @hw: pointer to the hw struct
@@ -4479,6 +4519,29 @@ static i40e_status i40e_aq_alternate_read(struct i40e_hw *hw,
 	return status;
 }
 
+/**
+ * i40e_aq_suspend_port_tx
+ * @hw: pointer to the hardware structure
+ * @seid: port seid
+ * @cmd_details: pointer to command details structure or NULL
+ *
+ * Suspend port's Tx traffic
+ **/
+i40e_status i40e_aq_suspend_port_tx(struct i40e_hw *hw, u16 seid,
+				    struct i40e_asq_cmd_details *cmd_details)
+{
+	struct i40e_aqc_tx_sched_ind *cmd;
+	struct i40e_aq_desc desc;
+	i40e_status status;
+
+	cmd = (struct i40e_aqc_tx_sched_ind *)&desc.params.raw;
+	i40e_fill_default_direct_cmd_desc(&desc, i40e_aqc_opc_suspend_port_tx);
+	cmd->vsi_seid = cpu_to_le16(seid);
+	status = i40e_asq_send_command(hw, &desc, NULL, 0, cmd_details);
+
+	return status;
+}
+
 /**
  * i40e_aq_resume_port_tx
  * @hw: pointer to the hardware structure
diff --git a/drivers/net/ethernet/intel/i40e/i40e_dcb.c b/drivers/net/ethernet/intel/i40e/i40e_dcb.c
index 9de503c5f99b..7b73a279d46e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_dcb.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_dcb.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright(c) 2013 - 2018 Intel Corporation. */
+/* Copyright(c) 2013 - 2021 Intel Corporation. */
 
 #include "i40e_adminq.h"
 #include "i40e_prototype.h"
@@ -932,6 +932,953 @@ i40e_status i40e_init_dcb(struct i40e_hw *hw, bool enable_mib_change)
 	return ret;
 }
 
+/**
+ * i40e_get_fw_lldp_status
+ * @hw: pointer to the hw struct
+ * @lldp_status: pointer to the status enum
+ *
+ * Get status of FW Link Layer Discovery Protocol (LLDP) Agent.
+ * Status of agent is reported via @lldp_status parameter.
+ **/
+enum i40e_status_code
+i40e_get_fw_lldp_status(struct i40e_hw *hw,
+			enum i40e_get_fw_lldp_status_resp *lldp_status)
+{
+	struct i40e_virt_mem mem;
+	i40e_status ret;
+	u8 *lldpmib;
+
+	if (!lldp_status)
+		return I40E_ERR_PARAM;
+
+	/* Allocate buffer for the LLDPDU */
+	ret = i40e_allocate_virt_mem(hw, &mem, I40E_LLDPDU_SIZE);
+	if (ret)
+		return ret;
+
+	lldpmib = (u8 *)mem.va;
+	ret = i40e_aq_get_lldp_mib(hw, 0, 0, (void *)lldpmib,
+				   I40E_LLDPDU_SIZE, NULL, NULL, NULL);
+
+	if (!ret) {
+		*lldp_status = I40E_GET_FW_LLDP_STATUS_ENABLED;
+	} else if (hw->aq.asq_last_status == I40E_AQ_RC_ENOENT) {
+		/* MIB is not available yet but the agent is running */
+		*lldp_status = I40E_GET_FW_LLDP_STATUS_ENABLED;
+		ret = 0;
+	} else if (hw->aq.asq_last_status == I40E_AQ_RC_EPERM) {
+		*lldp_status = I40E_GET_FW_LLDP_STATUS_DISABLED;
+		ret = 0;
+	}
+
+	i40e_free_virt_mem(hw, &mem);
+	return ret;
+}
+
+/**
+ * i40e_add_ieee_ets_tlv - Prepare ETS TLV in IEEE format
+ * @tlv: Fill the ETS config data in IEEE format
+ * @dcbcfg: Local store which holds the DCB Config
+ *
+ * Prepare IEEE 802.1Qaz ETS CFG TLV
+ **/
+static void i40e_add_ieee_ets_tlv(struct i40e_lldp_org_tlv *tlv,
+				  struct i40e_dcbx_config *dcbcfg)
+{
+	u8 priority0, priority1, maxtcwilling = 0;
+	struct i40e_dcb_ets_config *etscfg;
+	u16 offset = 0, typelength, i;
+	u8 *buf = tlv->tlvinfo;
+	u32 ouisubtype;
+
+	typelength = (u16)((I40E_TLV_TYPE_ORG << I40E_LLDP_TLV_TYPE_SHIFT) |
+			I40E_IEEE_ETS_TLV_LENGTH);
+	tlv->typelength = htons(typelength);
+
+	ouisubtype = (u32)((I40E_IEEE_8021QAZ_OUI << I40E_LLDP_TLV_OUI_SHIFT) |
+			I40E_IEEE_SUBTYPE_ETS_CFG);
+	tlv->ouisubtype = htonl(ouisubtype);
+
+	/* First Octet post subtype
+	 * --------------------------
+	 * |will-|CBS  | Re-  | Max |
+	 * |ing  |     |served| TCs |
+	 * --------------------------
+	 * |1bit | 1bit|3 bits|3bits|
+	 */
+	etscfg = &dcbcfg->etscfg;
+	if (etscfg->willing)
+		maxtcwilling = BIT(I40E_IEEE_ETS_WILLING_SHIFT);
+	maxtcwilling |= etscfg->maxtcs & I40E_IEEE_ETS_MAXTC_MASK;
+	buf[offset] = maxtcwilling;
+
+	/* Move offset to Priority Assignment Table */
+	offset++;
+
+	/* Priority Assignment Table (4 octets)
+	 * Octets:|    1    |    2    |    3    |    4    |
+	 *        -----------------------------------------
+	 *        |pri0|pri1|pri2|pri3|pri4|pri5|pri6|pri7|
+	 *        -----------------------------------------
+	 *   Bits:|7  4|3  0|7  4|3  0|7  4|3  0|7  4|3  0|
+	 *        -----------------------------------------
+	 */
+	for (i = 0; i < 4; i++) {
+		priority0 = etscfg->prioritytable[i * 2] & 0xF;
+		priority1 = etscfg->prioritytable[i * 2 + 1] & 0xF;
+		buf[offset] = (priority0 << I40E_IEEE_ETS_PRIO_1_SHIFT) |
+				priority1;
+		offset++;
+	}
+
+	/* TC Bandwidth Table (8 octets)
+	 * Octets:| 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
+	 *        ---------------------------------
+	 *        |tc0|tc1|tc2|tc3|tc4|tc5|tc6|tc7|
+	 *        ---------------------------------
+	 */
+	for (i = 0; i < I40E_MAX_TRAFFIC_CLASS; i++)
+		buf[offset++] = etscfg->tcbwtable[i];
+
+	/* TSA Assignment Table (8 octets)
+	 * Octets:| 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
+	 *        ---------------------------------
+	 *        |tc0|tc1|tc2|tc3|tc4|tc5|tc6|tc7|
+	 *        ---------------------------------
+	 */
+	for (i = 0; i < I40E_MAX_TRAFFIC_CLASS; i++)
+		buf[offset++] = etscfg->tsatable[i];
+}
+
+/**
+ * i40e_add_ieee_etsrec_tlv - Prepare ETS Recommended TLV in IEEE format
+ * @tlv: Fill ETS Recommended TLV in IEEE format
+ * @dcbcfg: Local store which holds the DCB Config
+ *
+ * Prepare IEEE 802.1Qaz ETS REC TLV
+ **/
+static void i40e_add_ieee_etsrec_tlv(struct i40e_lldp_org_tlv *tlv,
+				     struct i40e_dcbx_config *dcbcfg)
+{
+	struct i40e_dcb_ets_config *etsrec;
+	u16 offset = 0, typelength, i;
+	u8 priority0, priority1;
+	u8 *buf = tlv->tlvinfo;
+	u32 ouisubtype;
+
+	typelength = (u16)((I40E_TLV_TYPE_ORG << I40E_LLDP_TLV_TYPE_SHIFT) |
+			I40E_IEEE_ETS_TLV_LENGTH);
+	tlv->typelength = htons(typelength);
+
+	ouisubtype = (u32)((I40E_IEEE_8021QAZ_OUI << I40E_LLDP_TLV_OUI_SHIFT) |
+			I40E_IEEE_SUBTYPE_ETS_REC);
+	tlv->ouisubtype = htonl(ouisubtype);
+
+	etsrec = &dcbcfg->etsrec;
+	/* First Octet is reserved */
+	/* Move offset to Priority Assignment Table */
+	offset++;
+
+	/* Priority Assignment Table (4 octets)
+	 * Octets:|    1    |    2    |    3    |    4    |
+	 *        -----------------------------------------
+	 *        |pri0|pri1|pri2|pri3|pri4|pri5|pri6|pri7|
+	 *        -----------------------------------------
+	 *   Bits:|7  4|3  0|7  4|3  0|7  4|3  0|7  4|3  0|
+	 *        -----------------------------------------
+	 */
+	for (i = 0; i < 4; i++) {
+		priority0 = etsrec->prioritytable[i * 2] & 0xF;
+		priority1 = etsrec->prioritytable[i * 2 + 1] & 0xF;
+		buf[offset] = (priority0 << I40E_IEEE_ETS_PRIO_1_SHIFT) |
+				priority1;
+		offset++;
+	}
+
+	/* TC Bandwidth Table (8 octets)
+	 * Octets:| 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
+	 *        ---------------------------------
+	 *        |tc0|tc1|tc2|tc3|tc4|tc5|tc6|tc7|
+	 *        ---------------------------------
+	 */
+	for (i = 0; i < I40E_MAX_TRAFFIC_CLASS; i++)
+		buf[offset++] = etsrec->tcbwtable[i];
+
+	/* TSA Assignment Table (8 octets)
+	 * Octets:| 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
+	 *        ---------------------------------
+	 *        |tc0|tc1|tc2|tc3|tc4|tc5|tc6|tc7|
+	 *        ---------------------------------
+	 */
+	for (i = 0; i < I40E_MAX_TRAFFIC_CLASS; i++)
+		buf[offset++] = etsrec->tsatable[i];
+}
+
+/**
+ * i40e_add_ieee_pfc_tlv - Prepare PFC TLV in IEEE format
+ * @tlv: Fill PFC TLV in IEEE format
+ * @dcbcfg: Local store to get PFC CFG data
+ *
+ * Prepare IEEE 802.1Qaz PFC CFG TLV
+ **/
+static void i40e_add_ieee_pfc_tlv(struct i40e_lldp_org_tlv *tlv,
+				  struct i40e_dcbx_config *dcbcfg)
+{
+	u8 *buf = tlv->tlvinfo;
+	u32 ouisubtype;
+	u16 typelength;
+
+	typelength = (u16)((I40E_TLV_TYPE_ORG << I40E_LLDP_TLV_TYPE_SHIFT) |
+			I40E_IEEE_PFC_TLV_LENGTH);
+	tlv->typelength = htons(typelength);
+
+	ouisubtype = (u32)((I40E_IEEE_8021QAZ_OUI << I40E_LLDP_TLV_OUI_SHIFT) |
+			I40E_IEEE_SUBTYPE_PFC_CFG);
+	tlv->ouisubtype = htonl(ouisubtype);
+
+	/* ----------------------------------------
+	 * |will-|MBC  | Re-  | PFC |  PFC Enable  |
+	 * |ing  |     |served| cap |              |
+	 * -----------------------------------------
+	 * |1bit | 1bit|2 bits|4bits| 1 octet      |
+	 */
+	if (dcbcfg->pfc.willing)
+		buf[0] = BIT(I40E_IEEE_PFC_WILLING_SHIFT);
+
+	if (dcbcfg->pfc.mbc)
+		buf[0] |= BIT(I40E_IEEE_PFC_MBC_SHIFT);
+
+	buf[0] |= dcbcfg->pfc.pfccap & 0xF;
+	buf[1] = dcbcfg->pfc.pfcenable;
+}
+
+/**
+ * i40e_add_ieee_app_pri_tlv -  Prepare APP TLV in IEEE format
+ * @tlv: Fill APP TLV in IEEE format
+ * @dcbcfg: Local store to get APP CFG data
+ *
+ * Prepare IEEE 802.1Qaz APP CFG TLV
+ **/
+static void i40e_add_ieee_app_pri_tlv(struct i40e_lldp_org_tlv *tlv,
+				      struct i40e_dcbx_config *dcbcfg)
+{
+	u16 typelength, length, offset = 0;
+	u8 priority, selector, i = 0;
+	u8 *buf = tlv->tlvinfo;
+	u32 ouisubtype;
+
+	/* No APP TLVs then just return */
+	if (dcbcfg->numapps == 0)
+		return;
+	ouisubtype = (u32)((I40E_IEEE_8021QAZ_OUI << I40E_LLDP_TLV_OUI_SHIFT) |
+			I40E_IEEE_SUBTYPE_APP_PRI);
+	tlv->ouisubtype = htonl(ouisubtype);
+
+	/* Move offset to App Priority Table */
+	offset++;
+	/* Application Priority Table (3 octets)
+	 * Octets:|         1          |    2    |    3    |
+	 *        -----------------------------------------
+	 *        |Priority|Rsrvd| Sel |    Protocol ID    |
+	 *        -----------------------------------------
+	 *   Bits:|23    21|20 19|18 16|15                0|
+	 *        -----------------------------------------
+	 */
+	while (i < dcbcfg->numapps) {
+		priority = dcbcfg->app[i].priority & 0x7;
+		selector = dcbcfg->app[i].selector & 0x7;
+		buf[offset] = (priority << I40E_IEEE_APP_PRIO_SHIFT) | selector;
+		buf[offset + 1] = (dcbcfg->app[i].protocolid >> 0x8) & 0xFF;
+		buf[offset + 2] =  dcbcfg->app[i].protocolid & 0xFF;
+		/* Move to next app */
+		offset += 3;
+		i++;
+		if (i >= I40E_DCBX_MAX_APPS)
+			break;
+	}
+	/* length includes size of ouisubtype + 1 reserved + 3*numapps */
+	length = sizeof(tlv->ouisubtype) + 1 + (i * 3);
+	typelength = (u16)((I40E_TLV_TYPE_ORG << I40E_LLDP_TLV_TYPE_SHIFT) |
+		(length & 0x1FF));
+	tlv->typelength = htons(typelength);
+}
+
+/**
+ * i40e_add_dcb_tlv - Add all IEEE TLVs
+ * @tlv: pointer to org tlv
+ * @dcbcfg: pointer to modified dcbx config structure *
+ * @tlvid: tlv id to be added
+ * add tlv information
+ **/
+static void i40e_add_dcb_tlv(struct i40e_lldp_org_tlv *tlv,
+			     struct i40e_dcbx_config *dcbcfg,
+			     u16 tlvid)
+{
+	switch (tlvid) {
+	case I40E_IEEE_TLV_ID_ETS_CFG:
+		i40e_add_ieee_ets_tlv(tlv, dcbcfg);
+		break;
+	case I40E_IEEE_TLV_ID_ETS_REC:
+		i40e_add_ieee_etsrec_tlv(tlv, dcbcfg);
+		break;
+	case I40E_IEEE_TLV_ID_PFC_CFG:
+		i40e_add_ieee_pfc_tlv(tlv, dcbcfg);
+		break;
+	case I40E_IEEE_TLV_ID_APP_PRI:
+		i40e_add_ieee_app_pri_tlv(tlv, dcbcfg);
+		break;
+	default:
+		break;
+	}
+}
+
+/**
+ * i40e_set_dcb_config - Set the local LLDP MIB to FW
+ * @hw: pointer to the hw struct
+ *
+ * Set DCB configuration to the Firmware
+ **/
+i40e_status i40e_set_dcb_config(struct i40e_hw *hw)
+{
+	struct i40e_dcbx_config *dcbcfg;
+	struct i40e_virt_mem mem;
+	u8 mib_type, *lldpmib;
+	i40e_status ret;
+	u16 miblen;
+
+	/* update the hw local config */
+	dcbcfg = &hw->local_dcbx_config;
+	/* Allocate the LLDPDU */
+	ret = i40e_allocate_virt_mem(hw, &mem, I40E_LLDPDU_SIZE);
+	if (ret)
+		return ret;
+
+	mib_type = SET_LOCAL_MIB_AC_TYPE_LOCAL_MIB;
+	if (dcbcfg->app_mode == I40E_DCBX_APPS_NON_WILLING) {
+		mib_type |= SET_LOCAL_MIB_AC_TYPE_NON_WILLING_APPS <<
+			    SET_LOCAL_MIB_AC_TYPE_NON_WILLING_APPS_SHIFT;
+	}
+	lldpmib = (u8 *)mem.va;
+	i40e_dcb_config_to_lldp(lldpmib, &miblen, dcbcfg);
+	ret = i40e_aq_set_lldp_mib(hw, mib_type, (void *)lldpmib, miblen, NULL);
+
+	i40e_free_virt_mem(hw, &mem);
+	return ret;
+}
+
+/**
+ * i40e_dcb_config_to_lldp - Convert Dcbconfig to MIB format
+ * @lldpmib: pointer to mib to be output
+ * @miblen: pointer to u16 for length of lldpmib
+ * @dcbcfg: store for LLDPDU data
+ *
+ * send DCB configuration to FW
+ **/
+i40e_status i40e_dcb_config_to_lldp(u8 *lldpmib, u16 *miblen,
+				    struct i40e_dcbx_config *dcbcfg)
+{
+	u16 length, offset = 0, tlvid, typelength;
+	struct i40e_lldp_org_tlv *tlv;
+
+	tlv = (struct i40e_lldp_org_tlv *)lldpmib;
+	tlvid = I40E_TLV_ID_START;
+	do {
+		i40e_add_dcb_tlv(tlv, dcbcfg, tlvid++);
+		typelength = ntohs(tlv->typelength);
+		length = (u16)((typelength & I40E_LLDP_TLV_LEN_MASK) >>
+				I40E_LLDP_TLV_LEN_SHIFT);
+		if (length)
+			offset += length + I40E_IEEE_TLV_HEADER_LENGTH;
+		/* END TLV or beyond LLDPDU size */
+		if (tlvid >= I40E_TLV_ID_END_OF_LLDPPDU ||
+		    offset >= I40E_LLDPDU_SIZE)
+			break;
+		/* Move to next TLV */
+		if (length)
+			tlv = (struct i40e_lldp_org_tlv *)((char *)tlv +
+			      sizeof(tlv->typelength) + length);
+	} while (tlvid < I40E_TLV_ID_END_OF_LLDPPDU);
+	*miblen = offset;
+	return I40E_SUCCESS;
+}
+
+/**
+ * i40e_dcb_hw_rx_fifo_config
+ * @hw: pointer to the hw struct
+ * @ets_mode: Strict Priority or Round Robin mode
+ * @non_ets_mode: Strict Priority or Round Robin
+ * @max_exponent: Exponent to calculate max refill credits
+ * @lltc_map: Low latency TC bitmap
+ *
+ * Configure HW Rx FIFO as part of DCB configuration.
+ **/
+void i40e_dcb_hw_rx_fifo_config(struct i40e_hw *hw,
+				enum i40e_dcb_arbiter_mode ets_mode,
+				enum i40e_dcb_arbiter_mode non_ets_mode,
+				u32 max_exponent,
+				u8 lltc_map)
+{
+	u32 reg = rd32(hw, I40E_PRTDCB_RETSC);
+
+	reg &= ~I40E_PRTDCB_RETSC_ETS_MODE_MASK;
+	reg |= ((u32)ets_mode << I40E_PRTDCB_RETSC_ETS_MODE_SHIFT) &
+		I40E_PRTDCB_RETSC_ETS_MODE_MASK;
+
+	reg &= ~I40E_PRTDCB_RETSC_NON_ETS_MODE_MASK;
+	reg |= ((u32)non_ets_mode << I40E_PRTDCB_RETSC_NON_ETS_MODE_SHIFT) &
+		I40E_PRTDCB_RETSC_NON_ETS_MODE_MASK;
+
+	reg &= ~I40E_PRTDCB_RETSC_ETS_MAX_EXP_MASK;
+	reg |= (max_exponent << I40E_PRTDCB_RETSC_ETS_MAX_EXP_SHIFT) &
+		I40E_PRTDCB_RETSC_ETS_MAX_EXP_MASK;
+
+	reg &= ~I40E_PRTDCB_RETSC_LLTC_MASK;
+	reg |= (lltc_map << I40E_PRTDCB_RETSC_LLTC_SHIFT) &
+		I40E_PRTDCB_RETSC_LLTC_MASK;
+	wr32(hw, I40E_PRTDCB_RETSC, reg);
+}
+
+/**
+ * i40e_dcb_hw_rx_cmd_monitor_config
+ * @hw: pointer to the hw struct
+ * @num_tc: Total number of traffic class
+ * @num_ports: Total number of ports on device
+ *
+ * Configure HW Rx command monitor as part of DCB configuration.
+ **/
+void i40e_dcb_hw_rx_cmd_monitor_config(struct i40e_hw *hw,
+				       u8 num_tc, u8 num_ports)
+{
+	u32 threshold;
+	u32 fifo_size;
+	u32 reg;
+
+	/* Set the threshold and fifo_size based on number of ports */
+	switch (num_ports) {
+	case 1:
+		threshold = I40E_DCB_1_PORT_THRESHOLD;
+		fifo_size = I40E_DCB_1_PORT_FIFO_SIZE;
+		break;
+	case 2:
+		if (num_tc > 4) {
+			threshold = I40E_DCB_2_PORT_THRESHOLD_HIGH_NUM_TC;
+			fifo_size = I40E_DCB_2_PORT_FIFO_SIZE_HIGH_NUM_TC;
+		} else {
+			threshold = I40E_DCB_2_PORT_THRESHOLD_LOW_NUM_TC;
+			fifo_size = I40E_DCB_2_PORT_FIFO_SIZE_LOW_NUM_TC;
+		}
+		break;
+	case 4:
+		if (num_tc > 4) {
+			threshold = I40E_DCB_4_PORT_THRESHOLD_HIGH_NUM_TC;
+			fifo_size = I40E_DCB_4_PORT_FIFO_SIZE_HIGH_NUM_TC;
+		} else {
+			threshold = I40E_DCB_4_PORT_THRESHOLD_LOW_NUM_TC;
+			fifo_size = I40E_DCB_4_PORT_FIFO_SIZE_LOW_NUM_TC;
+		}
+		break;
+	default:
+		i40e_debug(hw, I40E_DEBUG_DCB, "Invalid num_ports %u.\n",
+			   (u32)num_ports);
+		return;
+	}
+
+	/* The hardware manual describes setting up of I40E_PRT_SWR_PM_THR
+	 * based on the number of ports and traffic classes for a given port as
+	 * part of DCB configuration.
+	 */
+	reg = rd32(hw, I40E_PRT_SWR_PM_THR);
+	reg &= ~I40E_PRT_SWR_PM_THR_THRESHOLD_MASK;
+	reg |= (threshold << I40E_PRT_SWR_PM_THR_THRESHOLD_SHIFT) &
+		I40E_PRT_SWR_PM_THR_THRESHOLD_MASK;
+	wr32(hw, I40E_PRT_SWR_PM_THR, reg);
+
+	reg = rd32(hw, I40E_PRTDCB_RPPMC);
+	reg &= ~I40E_PRTDCB_RPPMC_RX_FIFO_SIZE_MASK;
+	reg |= (fifo_size << I40E_PRTDCB_RPPMC_RX_FIFO_SIZE_SHIFT) &
+		I40E_PRTDCB_RPPMC_RX_FIFO_SIZE_MASK;
+	wr32(hw, I40E_PRTDCB_RPPMC, reg);
+}
+
+/**
+ * i40e_dcb_hw_pfc_config
+ * @hw: pointer to the hw struct
+ * @pfc_en: Bitmap of PFC enabled priorities
+ * @prio_tc: priority to tc assignment indexed by priority
+ *
+ * Configure HW Priority Flow Controller as part of DCB configuration.
+ **/
+void i40e_dcb_hw_pfc_config(struct i40e_hw *hw,
+			    u8 pfc_en, u8 *prio_tc)
+{
+	u16 refresh_time = (u16)I40E_DEFAULT_PAUSE_TIME / 2;
+	u32 link_speed = hw->phy.link_info.link_speed;
+	u8 first_pfc_prio = 0;
+	u8 num_pfc_tc = 0;
+	u8 tc2pfc = 0;
+	u32 reg;
+	u8 i;
+
+	/* Get Number of PFC TCs and TC2PFC map */
+	for (i = 0; i < I40E_MAX_USER_PRIORITY; i++) {
+		if (pfc_en & BIT(i)) {
+			if (!first_pfc_prio)
+				first_pfc_prio = i;
+			/* Set bit for the PFC TC */
+			tc2pfc |= BIT(prio_tc[i]);
+			num_pfc_tc++;
+		}
+	}
+
+	switch (link_speed) {
+	case I40E_LINK_SPEED_10GB:
+		reg = rd32(hw, I40E_PRTDCB_MFLCN);
+		reg |= BIT(I40E_PRTDCB_MFLCN_DPF_SHIFT) &
+			I40E_PRTDCB_MFLCN_DPF_MASK;
+		reg &= ~I40E_PRTDCB_MFLCN_RFCE_MASK;
+		reg &= ~I40E_PRTDCB_MFLCN_RPFCE_MASK;
+		if (pfc_en) {
+			reg |= BIT(I40E_PRTDCB_MFLCN_RPFCM_SHIFT) &
+				I40E_PRTDCB_MFLCN_RPFCM_MASK;
+			reg |= ((u32)pfc_en << I40E_PRTDCB_MFLCN_RPFCE_SHIFT) &
+				I40E_PRTDCB_MFLCN_RPFCE_MASK;
+		}
+		wr32(hw, I40E_PRTDCB_MFLCN, reg);
+
+		reg = rd32(hw, I40E_PRTDCB_FCCFG);
+		reg &= ~I40E_PRTDCB_FCCFG_TFCE_MASK;
+		if (pfc_en)
+			reg |= (I40E_DCB_PFC_ENABLED <<
+				I40E_PRTDCB_FCCFG_TFCE_SHIFT) &
+				I40E_PRTDCB_FCCFG_TFCE_MASK;
+		wr32(hw, I40E_PRTDCB_FCCFG, reg);
+
+		/* FCTTV and FCRTV to be set by default */
+		break;
+	case I40E_LINK_SPEED_40GB:
+		reg = rd32(hw, I40E_PRTMAC_HSEC_CTL_RX_ENABLE_GPP);
+		reg &= ~I40E_PRTMAC_HSEC_CTL_RX_ENABLE_GPP_MASK;
+		wr32(hw, I40E_PRTMAC_HSEC_CTL_RX_ENABLE_GPP, reg);
+
+		reg = rd32(hw, I40E_PRTMAC_HSEC_CTL_RX_ENABLE_PPP);
+		reg &= ~I40E_PRTMAC_HSEC_CTL_RX_ENABLE_GPP_MASK;
+		reg |= BIT(I40E_PRTMAC_HSEC_CTL_RX_ENABLE_PPP_SHIFT) &
+			I40E_PRTMAC_HSEC_CTL_RX_ENABLE_PPP_MASK;
+		wr32(hw, I40E_PRTMAC_HSEC_CTL_RX_ENABLE_PPP, reg);
+
+		reg = rd32(hw, I40E_PRTMAC_HSEC_CTL_RX_PAUSE_ENABLE);
+		reg &= ~I40E_PRTMAC_HSEC_CTL_RX_PAUSE_ENABLE_MASK;
+		reg |= ((u32)pfc_en <<
+			   I40E_PRTMAC_HSEC_CTL_RX_PAUSE_ENABLE_SHIFT) &
+			I40E_PRTMAC_HSEC_CTL_RX_PAUSE_ENABLE_MASK;
+		wr32(hw, I40E_PRTMAC_HSEC_CTL_RX_PAUSE_ENABLE, reg);
+
+		reg = rd32(hw, I40E_PRTMAC_HSEC_CTL_TX_PAUSE_ENABLE);
+		reg &= ~I40E_PRTMAC_HSEC_CTL_TX_PAUSE_ENABLE_MASK;
+		reg |= ((u32)pfc_en <<
+			   I40E_PRTMAC_HSEC_CTL_TX_PAUSE_ENABLE_SHIFT) &
+			I40E_PRTMAC_HSEC_CTL_TX_PAUSE_ENABLE_MASK;
+		wr32(hw, I40E_PRTMAC_HSEC_CTL_TX_PAUSE_ENABLE, reg);
+
+		for (i = 0; i < I40E_PRTMAC_HSEC_CTL_TX_PAUSE_REFRESH_TIMER_MAX_INDEX; i++) {
+			reg = rd32(hw, I40E_PRTMAC_HSEC_CTL_TX_PAUSE_REFRESH_TIMER(i));
+			reg &= ~I40E_PRTMAC_HSEC_CTL_TX_PAUSE_REFRESH_TIMER_MASK;
+			if (pfc_en) {
+				reg |= ((u32)refresh_time <<
+					I40E_PRTMAC_HSEC_CTL_TX_PAUSE_REFRESH_TIMER_SHIFT) &
+					I40E_PRTMAC_HSEC_CTL_TX_PAUSE_REFRESH_TIMER_MASK;
+			}
+			wr32(hw, I40E_PRTMAC_HSEC_CTL_TX_PAUSE_REFRESH_TIMER(i), reg);
+		}
+		/* PRTMAC_HSEC_CTL_TX_PAUSE_QUANTA default value is 0xFFFF
+		 * for all user priorities
+		 */
+		break;
+	}
+
+	reg = rd32(hw, I40E_PRTDCB_TC2PFC);
+	reg &= ~I40E_PRTDCB_TC2PFC_TC2PFC_MASK;
+	reg |= ((u32)tc2pfc << I40E_PRTDCB_TC2PFC_TC2PFC_SHIFT) &
+		I40E_PRTDCB_TC2PFC_TC2PFC_MASK;
+	wr32(hw, I40E_PRTDCB_TC2PFC, reg);
+
+	reg = rd32(hw, I40E_PRTDCB_RUP);
+	reg &= ~I40E_PRTDCB_RUP_NOVLANUP_MASK;
+	reg |= ((u32)first_pfc_prio << I40E_PRTDCB_RUP_NOVLANUP_SHIFT) &
+		 I40E_PRTDCB_RUP_NOVLANUP_MASK;
+	wr32(hw, I40E_PRTDCB_RUP, reg);
+
+	reg = rd32(hw, I40E_PRTDCB_TDPMC);
+	reg &= ~I40E_PRTDCB_TDPMC_TCPM_MODE_MASK;
+	if (num_pfc_tc > I40E_DCB_PFC_FORCED_NUM_TC) {
+		reg |= BIT(I40E_PRTDCB_TDPMC_TCPM_MODE_SHIFT) &
+			I40E_PRTDCB_TDPMC_TCPM_MODE_MASK;
+	}
+	wr32(hw, I40E_PRTDCB_TDPMC, reg);
+
+	reg = rd32(hw, I40E_PRTDCB_TCPMC);
+	reg &= ~I40E_PRTDCB_TCPMC_TCPM_MODE_MASK;
+	if (num_pfc_tc > I40E_DCB_PFC_FORCED_NUM_TC) {
+		reg |= BIT(I40E_PRTDCB_TCPMC_TCPM_MODE_SHIFT) &
+			I40E_PRTDCB_TCPMC_TCPM_MODE_MASK;
+	}
+	wr32(hw, I40E_PRTDCB_TCPMC, reg);
+}
+
+/**
+ * i40e_dcb_hw_set_num_tc
+ * @hw: pointer to the hw struct
+ * @num_tc: number of traffic classes
+ *
+ * Configure number of traffic classes in HW
+ **/
+void i40e_dcb_hw_set_num_tc(struct i40e_hw *hw, u8 num_tc)
+{
+	u32 reg = rd32(hw, I40E_PRTDCB_GENC);
+
+	reg &= ~I40E_PRTDCB_GENC_NUMTC_MASK;
+	reg |= ((u32)num_tc << I40E_PRTDCB_GENC_NUMTC_SHIFT) &
+		I40E_PRTDCB_GENC_NUMTC_MASK;
+	wr32(hw, I40E_PRTDCB_GENC, reg);
+}
+
+/**
+ * i40e_dcb_hw_get_num_tc
+ * @hw: pointer to the hw struct
+ *
+ * Returns number of traffic classes configured in HW
+ **/
+u8 i40e_dcb_hw_get_num_tc(struct i40e_hw *hw)
+{
+	u32 reg = rd32(hw, I40E_PRTDCB_GENC);
+
+	return (u8)((reg & I40E_PRTDCB_GENC_NUMTC_MASK) >>
+		I40E_PRTDCB_GENC_NUMTC_SHIFT);
+}
+
+/**
+ * i40e_dcb_hw_rx_ets_bw_config
+ * @hw: pointer to the hw struct
+ * @bw_share: Bandwidth share indexed per traffic class
+ * @mode: Strict Priority or Round Robin mode between UP sharing same
+ * traffic class
+ * @prio_type: TC is ETS enabled or strict priority
+ *
+ * Configure HW Rx ETS bandwidth as part of DCB configuration.
+ **/
+void i40e_dcb_hw_rx_ets_bw_config(struct i40e_hw *hw, u8 *bw_share,
+				  u8 *mode, u8 *prio_type)
+{
+	u32 reg;
+	u8 i;
+
+	for (i = 0; i <= I40E_PRTDCB_RETSTCC_MAX_INDEX; i++) {
+		reg = rd32(hw, I40E_PRTDCB_RETSTCC(i));
+		reg &= ~(I40E_PRTDCB_RETSTCC_BWSHARE_MASK     |
+			 I40E_PRTDCB_RETSTCC_UPINTC_MODE_MASK |
+			 I40E_PRTDCB_RETSTCC_ETSTC_SHIFT);
+		reg |= ((u32)bw_share[i] << I40E_PRTDCB_RETSTCC_BWSHARE_SHIFT) &
+			 I40E_PRTDCB_RETSTCC_BWSHARE_MASK;
+		reg |= ((u32)mode[i] << I40E_PRTDCB_RETSTCC_UPINTC_MODE_SHIFT) &
+			 I40E_PRTDCB_RETSTCC_UPINTC_MODE_MASK;
+		reg |= ((u32)prio_type[i] << I40E_PRTDCB_RETSTCC_ETSTC_SHIFT) &
+			 I40E_PRTDCB_RETSTCC_ETSTC_MASK;
+		wr32(hw, I40E_PRTDCB_RETSTCC(i), reg);
+	}
+}
+
+/**
+ * i40e_dcb_hw_rx_ets_bw_config
+ * @hw: pointer to the hw struct
+ * @prio_tc: priority to tc assignment indexed by priority
+ *
+ * Configure HW Rx UP2TC map as part of DCB configuration.
+ **/
+void i40e_dcb_hw_rx_up2tc_config(struct i40e_hw *hw, u8 *prio_tc)
+{
+	u32 reg = rd32(hw, I40E_PRTDCB_RUP2TC);
+#define I40E_UP2TC_REG(val, i) \
+		(((val) << I40E_PRTDCB_RUP2TC_UP##i##TC_SHIFT) & \
+		  I40E_PRTDCB_RUP2TC_UP##i##TC_MASK)
+
+	reg |= I40E_UP2TC_REG(prio_tc[0], 0);
+	reg |= I40E_UP2TC_REG(prio_tc[1], 1);
+	reg |= I40E_UP2TC_REG(prio_tc[2], 2);
+	reg |= I40E_UP2TC_REG(prio_tc[3], 3);
+	reg |= I40E_UP2TC_REG(prio_tc[4], 4);
+	reg |= I40E_UP2TC_REG(prio_tc[5], 5);
+	reg |= I40E_UP2TC_REG(prio_tc[6], 6);
+	reg |= I40E_UP2TC_REG(prio_tc[7], 7);
+
+	wr32(hw, I40E_PRTDCB_RUP2TC, reg);
+}
+
+/**
+ * i40e_dcb_hw_calculate_pool_sizes - configure dcb pool sizes
+ * @hw: pointer to the hw struct
+ * @num_ports: Number of available ports on the device
+ * @eee_enabled: EEE enabled for the given port
+ * @pfc_en: Bit map of PFC enabled traffic classes
+ * @mfs_tc: Array of max frame size for each traffic class
+ * @pb_cfg: pointer to packet buffer configuration
+ *
+ * Calculate the shared and dedicated per TC pool sizes,
+ * watermarks and threshold values.
+ **/
+void i40e_dcb_hw_calculate_pool_sizes(struct i40e_hw *hw,
+				      u8 num_ports, bool eee_enabled,
+				      u8 pfc_en, u32 *mfs_tc,
+				      struct i40e_rx_pb_config *pb_cfg)
+{
+	u32 pool_size[I40E_MAX_TRAFFIC_CLASS];
+	u32 high_wm[I40E_MAX_TRAFFIC_CLASS];
+	u32 low_wm[I40E_MAX_TRAFFIC_CLASS];
+	u32 total_pool_size = 0;
+	int shared_pool_size; /* Need signed variable */
+	u32 port_pb_size;
+	u32 mfs_max;
+	u32 pcirtt;
+	u8 i;
+
+	/* Get the MFS(max) for the port */
+	for (i = 0; i < I40E_MAX_TRAFFIC_CLASS; i++) {
+		if (mfs_tc[i] > mfs_max)
+			mfs_max = mfs_tc[i];
+	}
+
+	pcirtt = I40E_BT2B(I40E_PCIRTT_LINK_SPEED_10G);
+
+	/* Calculate effective Rx PB size per port */
+	port_pb_size = I40E_DEVICE_RPB_SIZE / num_ports;
+	if (eee_enabled)
+		port_pb_size -= I40E_BT2B(I40E_EEE_TX_LPI_EXIT_TIME);
+	port_pb_size -= mfs_max;
+
+	/* Step 1 Calculating tc pool/shared pool sizes and watermarks */
+	for (i = 0; i < I40E_MAX_TRAFFIC_CLASS; i++) {
+		if (pfc_en & BIT(i)) {
+			low_wm[i] = (I40E_DCB_WATERMARK_START_FACTOR *
+				     mfs_tc[i]) + pcirtt;
+			high_wm[i] = low_wm[i];
+			high_wm[i] += ((mfs_max > I40E_MAX_FRAME_SIZE)
+					? mfs_max : I40E_MAX_FRAME_SIZE);
+			pool_size[i] = high_wm[i];
+			pool_size[i] += I40E_BT2B(I40E_STD_DV_TC(mfs_max,
+								mfs_tc[i]));
+		} else {
+			low_wm[i] = 0;
+			pool_size[i] = (I40E_DCB_WATERMARK_START_FACTOR *
+					mfs_tc[i]) + pcirtt;
+			high_wm[i] = pool_size[i];
+		}
+		total_pool_size += pool_size[i];
+	}
+
+	shared_pool_size = port_pb_size - total_pool_size;
+	if (shared_pool_size > 0) {
+		pb_cfg->shared_pool_size = shared_pool_size;
+		pb_cfg->shared_pool_high_wm = shared_pool_size;
+		pb_cfg->shared_pool_low_wm = 0;
+		for (i = 0; i < I40E_MAX_TRAFFIC_CLASS; i++) {
+			pb_cfg->shared_pool_low_thresh[i] = 0;
+			pb_cfg->shared_pool_high_thresh[i] = shared_pool_size;
+			pb_cfg->tc_pool_size[i] = pool_size[i];
+			pb_cfg->tc_pool_high_wm[i] = high_wm[i];
+			pb_cfg->tc_pool_low_wm[i] = low_wm[i];
+		}
+
+	} else {
+		i40e_debug(hw, I40E_DEBUG_DCB,
+			   "The shared pool size for the port is negative %d.\n",
+			   shared_pool_size);
+	}
+}
+
+/**
+ * i40e_dcb_hw_rx_pb_config
+ * @hw: pointer to the hw struct
+ * @old_pb_cfg: Existing Rx Packet buffer configuration
+ * @new_pb_cfg: New Rx Packet buffer configuration
+ *
+ * Program the Rx Packet Buffer registers.
+ **/
+void i40e_dcb_hw_rx_pb_config(struct i40e_hw *hw,
+			      struct i40e_rx_pb_config *old_pb_cfg,
+			      struct i40e_rx_pb_config *new_pb_cfg)
+{
+	u32 old_val;
+	u32 new_val;
+	u32 reg;
+	u8 i;
+
+	/* The Rx Packet buffer register programming needs to be done in a
+	 * certain order and the following code is based on that
+	 * requirement.
+	 */
+
+	/* Program the shared pool low water mark per port if decreasing */
+	old_val = old_pb_cfg->shared_pool_low_wm;
+	new_val = new_pb_cfg->shared_pool_low_wm;
+	if (new_val < old_val) {
+		reg = rd32(hw, I40E_PRTRPB_SLW);
+		reg &= ~I40E_PRTRPB_SLW_SLW_MASK;
+		reg |= (new_val << I40E_PRTRPB_SLW_SLW_SHIFT) &
+			I40E_PRTRPB_SLW_SLW_MASK;
+		wr32(hw, I40E_PRTRPB_SLW, reg);
+	}
+
+	/* Program the shared pool low threshold and tc pool
+	 * low water mark per TC that are decreasing.
+	 */
+	for (i = 0; i < I40E_MAX_TRAFFIC_CLASS; i++) {
+		old_val = old_pb_cfg->shared_pool_low_thresh[i];
+		new_val = new_pb_cfg->shared_pool_low_thresh[i];
+		if (new_val < old_val) {
+			reg = rd32(hw, I40E_PRTRPB_SLT(i));
+			reg &= ~I40E_PRTRPB_SLT_SLT_TCN_MASK;
+			reg |= (new_val << I40E_PRTRPB_SLT_SLT_TCN_SHIFT) &
+				I40E_PRTRPB_SLT_SLT_TCN_MASK;
+			wr32(hw, I40E_PRTRPB_SLT(i), reg);
+		}
+
+		old_val = old_pb_cfg->tc_pool_low_wm[i];
+		new_val = new_pb_cfg->tc_pool_low_wm[i];
+		if (new_val < old_val) {
+			reg = rd32(hw, I40E_PRTRPB_DLW(i));
+			reg &= ~I40E_PRTRPB_DLW_DLW_TCN_MASK;
+			reg |= (new_val << I40E_PRTRPB_DLW_DLW_TCN_SHIFT) &
+				I40E_PRTRPB_DLW_DLW_TCN_MASK;
+			wr32(hw, I40E_PRTRPB_DLW(i), reg);
+		}
+	}
+
+	/* Program the shared pool high water mark per port if decreasing */
+	old_val = old_pb_cfg->shared_pool_high_wm;
+	new_val = new_pb_cfg->shared_pool_high_wm;
+	if (new_val < old_val) {
+		reg = rd32(hw, I40E_PRTRPB_SHW);
+		reg &= ~I40E_PRTRPB_SHW_SHW_MASK;
+		reg |= (new_val << I40E_PRTRPB_SHW_SHW_SHIFT) &
+			I40E_PRTRPB_SHW_SHW_MASK;
+		wr32(hw, I40E_PRTRPB_SHW, reg);
+	}
+
+	/* Program the shared pool high threshold and tc pool
+	 * high water mark per TC that are decreasing.
+	 */
+	for (i = 0; i < I40E_MAX_TRAFFIC_CLASS; i++) {
+		old_val = old_pb_cfg->shared_pool_high_thresh[i];
+		new_val = new_pb_cfg->shared_pool_high_thresh[i];
+		if (new_val < old_val) {
+			reg = rd32(hw, I40E_PRTRPB_SHT(i));
+			reg &= ~I40E_PRTRPB_SHT_SHT_TCN_MASK;
+			reg |= (new_val << I40E_PRTRPB_SHT_SHT_TCN_SHIFT) &
+				I40E_PRTRPB_SHT_SHT_TCN_MASK;
+			wr32(hw, I40E_PRTRPB_SHT(i), reg);
+		}
+
+		old_val = old_pb_cfg->tc_pool_high_wm[i];
+		new_val = new_pb_cfg->tc_pool_high_wm[i];
+		if (new_val < old_val) {
+			reg = rd32(hw, I40E_PRTRPB_DHW(i));
+			reg &= ~I40E_PRTRPB_DHW_DHW_TCN_MASK;
+			reg |= (new_val << I40E_PRTRPB_DHW_DHW_TCN_SHIFT) &
+				I40E_PRTRPB_DHW_DHW_TCN_MASK;
+			wr32(hw, I40E_PRTRPB_DHW(i), reg);
+		}
+	}
+
+	/* Write Dedicated Pool Sizes per TC */
+	for (i = 0; i < I40E_MAX_TRAFFIC_CLASS; i++) {
+		new_val = new_pb_cfg->tc_pool_size[i];
+		reg = rd32(hw, I40E_PRTRPB_DPS(i));
+		reg &= ~I40E_PRTRPB_DPS_DPS_TCN_MASK;
+		reg |= (new_val << I40E_PRTRPB_DPS_DPS_TCN_SHIFT) &
+			I40E_PRTRPB_DPS_DPS_TCN_MASK;
+		wr32(hw, I40E_PRTRPB_DPS(i), reg);
+	}
+
+	/* Write Shared Pool Size per port */
+	new_val = new_pb_cfg->shared_pool_size;
+	reg = rd32(hw, I40E_PRTRPB_SPS);
+	reg &= ~I40E_PRTRPB_SPS_SPS_MASK;
+	reg |= (new_val << I40E_PRTRPB_SPS_SPS_SHIFT) &
+		I40E_PRTRPB_SPS_SPS_MASK;
+	wr32(hw, I40E_PRTRPB_SPS, reg);
+
+	/* Program the shared pool low water mark per port if increasing */
+	old_val = old_pb_cfg->shared_pool_low_wm;
+	new_val = new_pb_cfg->shared_pool_low_wm;
+	if (new_val > old_val) {
+		reg = rd32(hw, I40E_PRTRPB_SLW);
+		reg &= ~I40E_PRTRPB_SLW_SLW_MASK;
+		reg |= (new_val << I40E_PRTRPB_SLW_SLW_SHIFT) &
+			I40E_PRTRPB_SLW_SLW_MASK;
+		wr32(hw, I40E_PRTRPB_SLW, reg);
+	}
+
+	/* Program the shared pool low threshold and tc pool
+	 * low water mark per TC that are increasing.
+	 */
+	for (i = 0; i < I40E_MAX_TRAFFIC_CLASS; i++) {
+		old_val = old_pb_cfg->shared_pool_low_thresh[i];
+		new_val = new_pb_cfg->shared_pool_low_thresh[i];
+		if (new_val > old_val) {
+			reg = rd32(hw, I40E_PRTRPB_SLT(i));
+			reg &= ~I40E_PRTRPB_SLT_SLT_TCN_MASK;
+			reg |= (new_val << I40E_PRTRPB_SLT_SLT_TCN_SHIFT) &
+				I40E_PRTRPB_SLT_SLT_TCN_MASK;
+			wr32(hw, I40E_PRTRPB_SLT(i), reg);
+		}
+
+		old_val = old_pb_cfg->tc_pool_low_wm[i];
+		new_val = new_pb_cfg->tc_pool_low_wm[i];
+		if (new_val > old_val) {
+			reg = rd32(hw, I40E_PRTRPB_DLW(i));
+			reg &= ~I40E_PRTRPB_DLW_DLW_TCN_MASK;
+			reg |= (new_val << I40E_PRTRPB_DLW_DLW_TCN_SHIFT) &
+				I40E_PRTRPB_DLW_DLW_TCN_MASK;
+			wr32(hw, I40E_PRTRPB_DLW(i), reg);
+		}
+	}
+
+	/* Program the shared pool high water mark per port if increasing */
+	old_val = old_pb_cfg->shared_pool_high_wm;
+	new_val = new_pb_cfg->shared_pool_high_wm;
+	if (new_val > old_val) {
+		reg = rd32(hw, I40E_PRTRPB_SHW);
+		reg &= ~I40E_PRTRPB_SHW_SHW_MASK;
+		reg |= (new_val << I40E_PRTRPB_SHW_SHW_SHIFT) &
+			I40E_PRTRPB_SHW_SHW_MASK;
+		wr32(hw, I40E_PRTRPB_SHW, reg);
+	}
+
+	/* Program the shared pool high threshold and tc pool
+	 * high water mark per TC that are increasing.
+	 */
+	for (i = 0; i < I40E_MAX_TRAFFIC_CLASS; i++) {
+		old_val = old_pb_cfg->shared_pool_high_thresh[i];
+		new_val = new_pb_cfg->shared_pool_high_thresh[i];
+		if (new_val > old_val) {
+			reg = rd32(hw, I40E_PRTRPB_SHT(i));
+			reg &= ~I40E_PRTRPB_SHT_SHT_TCN_MASK;
+			reg |= (new_val << I40E_PRTRPB_SHT_SHT_TCN_SHIFT) &
+				I40E_PRTRPB_SHT_SHT_TCN_MASK;
+			wr32(hw, I40E_PRTRPB_SHT(i), reg);
+		}
+
+		old_val = old_pb_cfg->tc_pool_high_wm[i];
+		new_val = new_pb_cfg->tc_pool_high_wm[i];
+		if (new_val > old_val) {
+			reg = rd32(hw, I40E_PRTRPB_DHW(i));
+			reg &= ~I40E_PRTRPB_DHW_DHW_TCN_MASK;
+			reg |= (new_val << I40E_PRTRPB_DHW_DHW_TCN_SHIFT) &
+				I40E_PRTRPB_DHW_DHW_TCN_MASK;
+			wr32(hw, I40E_PRTRPB_DHW(i), reg);
+		}
+	}
+}
+
 /**
  * _i40e_read_lldp_cfg - generic read of LLDP Configuration data from NVM
  * @hw: pointer to the HW structure
diff --git a/drivers/net/ethernet/intel/i40e/i40e_dcb.h b/drivers/net/ethernet/intel/i40e/i40e_dcb.h
index 2b1a2e81ac73..2370ceecb061 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_dcb.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_dcb.h
@@ -1,13 +1,15 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright(c) 2013 - 2018 Intel Corporation. */
+/* Copyright(c) 2013 - 2021 Intel Corporation. */
 
 #ifndef _I40E_DCB_H_
 #define _I40E_DCB_H_
 
 #include "i40e_type.h"
 
+#define I40E_DCBX_STATUS_NOT_STARTED	0
 #define I40E_DCBX_STATUS_IN_PROGRESS	1
 #define I40E_DCBX_STATUS_DONE		2
+#define I40E_DCBX_STATUS_MULTIPLE_PEERS	3
 #define I40E_DCBX_STATUS_DISABLED	7
 
 #define I40E_TLV_TYPE_END		0
@@ -22,6 +24,7 @@
 #define I40E_CEE_DCBX_OUI		0x001b21
 #define I40E_CEE_DCBX_TYPE		2
 
+#define I40E_CEE_SUBTYPE_CTRL		1
 #define I40E_CEE_SUBTYPE_PG_CFG		2
 #define I40E_CEE_SUBTYPE_PFC_CFG	3
 #define I40E_CEE_SUBTYPE_APP_PRI	4
@@ -64,6 +67,8 @@
 #define I40E_IEEE_TSA_ETS		2
 
 /* Defines for IEEE PFC TLV */
+#define I40E_DCB_PFC_ENABLED		2
+#define I40E_DCB_PFC_FORCED_NUM_TC	2
 #define I40E_IEEE_PFC_CAP_SHIFT		0
 #define I40E_IEEE_PFC_CAP_MASK		(0xF << I40E_IEEE_PFC_CAP_SHIFT)
 #define I40E_IEEE_PFC_MBC_SHIFT		6
@@ -77,9 +82,30 @@
 #define I40E_IEEE_APP_PRIO_SHIFT	5
 #define I40E_IEEE_APP_PRIO_MASK		(0x7 << I40E_IEEE_APP_PRIO_SHIFT)
 
+/* TLV definitions for preparing MIB */
+#define I40E_TLV_ID_CHASSIS_ID		0
+#define I40E_TLV_ID_PORT_ID		1
+#define I40E_TLV_ID_TIME_TO_LIVE	2
+#define I40E_IEEE_TLV_ID_ETS_CFG	3
+#define I40E_IEEE_TLV_ID_ETS_REC	4
+#define I40E_IEEE_TLV_ID_PFC_CFG	5
+#define I40E_IEEE_TLV_ID_APP_PRI	6
+#define I40E_TLV_ID_END_OF_LLDPPDU	7
+#define I40E_TLV_ID_START		I40E_IEEE_TLV_ID_ETS_CFG
 
-#pragma pack(1)
+#define I40E_IEEE_TLV_HEADER_LENGTH	2
+#define I40E_IEEE_ETS_TLV_LENGTH	25
+#define I40E_IEEE_PFC_TLV_LENGTH	6
+#define I40E_IEEE_APP_TLV_LENGTH	11
+
+/* Defines for default SW DCB config */
+#define I40E_IEEE_DEFAULT_ETS_TCBW	100
+#define I40E_IEEE_DEFAULT_ETS_WILLING	1
+#define I40E_IEEE_DEFAULT_PFC_WILLING	1
+#define I40E_IEEE_DEFAULT_NUM_APPS	1
+#define I40E_IEEE_DEFAULT_APP_PRIO	3
 
+#pragma pack(1)
 /* IEEE 802.1AB LLDP Organization specific TLV */
 struct i40e_lldp_org_tlv {
 	__be16 typelength;
@@ -102,7 +128,9 @@ struct i40e_cee_ctrl_tlv {
 struct i40e_cee_feat_tlv {
 	struct i40e_cee_tlv_hdr hdr;
 	u8 en_will_err; /* Bits: |En|Will|Err|Reserved(5)| */
+#define I40E_CEE_FEAT_TLV_ENABLE_MASK	0x80
 #define I40E_CEE_FEAT_TLV_WILLING_MASK	0x40
+#define I40E_CEE_FEAT_TLV_ERR_MASK	0x20
 	u8 subtype;
 	u8 tlvinfo[1];
 };
@@ -116,13 +144,140 @@ struct i40e_cee_app_prio {
 };
 #pragma pack()
 
+enum i40e_get_fw_lldp_status_resp {
+	I40E_GET_FW_LLDP_STATUS_DISABLED = 0,
+	I40E_GET_FW_LLDP_STATUS_ENABLED = 1
+};
+
+/* Data structures to pass for SW DCBX */
+struct i40e_rx_pb_config {
+	u32	shared_pool_size;
+	u32	shared_pool_high_wm;
+	u32	shared_pool_low_wm;
+	u32	shared_pool_high_thresh[I40E_MAX_TRAFFIC_CLASS];
+	u32	shared_pool_low_thresh[I40E_MAX_TRAFFIC_CLASS];
+	u32	tc_pool_size[I40E_MAX_TRAFFIC_CLASS];
+	u32	tc_pool_high_wm[I40E_MAX_TRAFFIC_CLASS];
+	u32	tc_pool_low_wm[I40E_MAX_TRAFFIC_CLASS];
+};
+
+enum i40e_dcb_arbiter_mode {
+	I40E_DCB_ARB_MODE_STRICT_PRIORITY = 0,
+	I40E_DCB_ARB_MODE_ROUND_ROBIN = 1
+};
+
+#define I40E_DCB_DEFAULT_MAX_EXPONENT		0xB
+#define I40E_DEFAULT_PAUSE_TIME			0xffff
+#define I40E_MAX_FRAME_SIZE			4608 /* 4.5 KB */
+
+#define I40E_DEVICE_RPB_SIZE			968000 /* 968 KB */
+
+/* BitTimes (BT) conversion */
+#define I40E_BT2KB(BT) (((BT) + (8 * 1024 - 1)) / (8 * 1024))
+#define I40E_B2BT(BT) ((BT) * 8)
+#define I40E_BT2B(BT) (((BT) + (8 - 1)) / 8)
+
+/* Max Frame(TC) = MFS(max) + MFS(TC) */
+#define I40E_MAX_FRAME_TC(mfs_max, mfs_tc)	I40E_B2BT((mfs_max) + (mfs_tc))
+
+/* EEE Tx LPI Exit time in Bit Times */
+#define I40E_EEE_TX_LPI_EXIT_TIME		142500
+
+/* PCI Round Trip Time in Bit Times */
+#define I40E_PCIRTT_LINK_SPEED_10G		20000
+#define I40E_PCIRTT_BYTE_LINK_SPEED_20G		40000
+#define I40E_PCIRTT_BYTE_LINK_SPEED_40G		80000
+
+/* PFC Frame Delay Bit Times */
+#define I40E_PFC_FRAME_DELAY			672
+
+/* Worst case Cable (10GBase-T) Delay Bit Times */
+#define I40E_CABLE_DELAY			5556
+
+/* Higher Layer Delay @10G Bit Times */
+#define I40E_HIGHER_LAYER_DELAY_10G		6144
+
+/* Interface Delays in Bit Times */
+/* TODO: Add for other link speeds 20G/40G/etc. */
+#define I40E_INTERFACE_DELAY_10G_MAC_CONTROL	8192
+#define I40E_INTERFACE_DELAY_10G_MAC		8192
+#define I40E_INTERFACE_DELAY_10G_RS		8192
+
+#define I40E_INTERFACE_DELAY_XGXS		2048
+#define I40E_INTERFACE_DELAY_XAUI		2048
+
+#define I40E_INTERFACE_DELAY_10G_BASEX_PCS	2048
+#define I40E_INTERFACE_DELAY_10G_BASER_PCS	3584
+#define I40E_INTERFACE_DELAY_LX4_PMD		512
+#define I40E_INTERFACE_DELAY_CX4_PMD		512
+#define I40E_INTERFACE_DELAY_SERIAL_PMA		512
+#define I40E_INTERFACE_DELAY_PMD		512
+
+#define I40E_INTERFACE_DELAY_10G_BASET		25600
+
+/* Hardware RX DCB config related defines */
+#define I40E_DCB_1_PORT_THRESHOLD		0xF
+#define I40E_DCB_1_PORT_FIFO_SIZE		0x10
+#define I40E_DCB_2_PORT_THRESHOLD_LOW_NUM_TC	0xF
+#define I40E_DCB_2_PORT_FIFO_SIZE_LOW_NUM_TC	0x10
+#define I40E_DCB_2_PORT_THRESHOLD_HIGH_NUM_TC	0xC
+#define I40E_DCB_2_PORT_FIFO_SIZE_HIGH_NUM_TC	0x8
+#define I40E_DCB_4_PORT_THRESHOLD_LOW_NUM_TC	0x9
+#define I40E_DCB_4_PORT_FIFO_SIZE_LOW_NUM_TC	0x8
+#define I40E_DCB_4_PORT_THRESHOLD_HIGH_NUM_TC	0x6
+#define I40E_DCB_4_PORT_FIFO_SIZE_HIGH_NUM_TC	0x4
+#define I40E_DCB_WATERMARK_START_FACTOR		0x2
+
+/* delay values for with 10G BaseT in Bit Times */
+#define I40E_INTERFACE_DELAY_10G_COPPER	\
+	(I40E_INTERFACE_DELAY_10G_MAC + (2 * I40E_INTERFACE_DELAY_XAUI) \
+	 + I40E_INTERFACE_DELAY_10G_BASET)
+#define I40E_DV_TC(mfs_max, mfs_tc) \
+		((2 * I40E_MAX_FRAME_TC(mfs_max, mfs_tc)) \
+		 + I40E_PFC_FRAME_DELAY \
+		 + (2 * I40E_CABLE_DELAY) \
+		 + (2 * I40E_INTERFACE_DELAY_10G_COPPER) \
+		 + I40E_HIGHER_LAYER_DELAY_10G)
+static inline u32 I40E_STD_DV_TC(u32 mfs_max, u32 mfs_tc)
+{
+	return I40E_DV_TC(mfs_max, mfs_tc) + I40E_B2BT(mfs_max);
+}
+
+/* APIs for SW DCBX */
+void i40e_dcb_hw_rx_fifo_config(struct i40e_hw *hw,
+				enum i40e_dcb_arbiter_mode ets_mode,
+				enum i40e_dcb_arbiter_mode non_ets_mode,
+				u32 max_exponent, u8 lltc_map);
+void i40e_dcb_hw_rx_cmd_monitor_config(struct i40e_hw *hw,
+				       u8 num_tc, u8 num_ports);
+void i40e_dcb_hw_pfc_config(struct i40e_hw *hw,
+			    u8 pfc_en, u8 *prio_tc);
+void i40e_dcb_hw_set_num_tc(struct i40e_hw *hw, u8 num_tc);
+u8 i40e_dcb_hw_get_num_tc(struct i40e_hw *hw);
+void i40e_dcb_hw_rx_ets_bw_config(struct i40e_hw *hw, u8 *bw_share,
+				  u8 *mode, u8 *prio_type);
+void i40e_dcb_hw_rx_up2tc_config(struct i40e_hw *hw, u8 *prio_tc);
+void i40e_dcb_hw_calculate_pool_sizes(struct i40e_hw *hw,
+				      u8 num_ports, bool eee_enabled,
+				      u8 pfc_en, u32 *mfs_tc,
+				      struct i40e_rx_pb_config *pb_cfg);
+void i40e_dcb_hw_rx_pb_config(struct i40e_hw *hw,
+			      struct i40e_rx_pb_config *old_pb_cfg,
+			      struct i40e_rx_pb_config *new_pb_cfg);
 i40e_status i40e_get_dcbx_status(struct i40e_hw *hw,
-					   u16 *status);
+				 u16 *status);
 i40e_status i40e_lldp_to_dcb_config(u8 *lldpmib,
-					      struct i40e_dcbx_config *dcbcfg);
+				    struct i40e_dcbx_config *dcbcfg);
 i40e_status i40e_aq_get_dcb_config(struct i40e_hw *hw, u8 mib_type,
-					     u8 bridgetype,
-					     struct i40e_dcbx_config *dcbcfg);
+				   u8 bridgetype,
+				   struct i40e_dcbx_config *dcbcfg);
 i40e_status i40e_get_dcb_config(struct i40e_hw *hw);
-i40e_status i40e_init_dcb(struct i40e_hw *hw, bool enable_mib_change);
+i40e_status i40e_init_dcb(struct i40e_hw *hw,
+			  bool enable_mib_change);
+enum i40e_status_code
+i40e_get_fw_lldp_status(struct i40e_hw *hw,
+			enum i40e_get_fw_lldp_status_resp *lldp_status);
+i40e_status i40e_set_dcb_config(struct i40e_hw *hw);
+i40e_status i40e_dcb_config_to_lldp(u8 *lldpmib, u16 *miblen,
+				    struct i40e_dcbx_config *dcbcfg);
 #endif /* _I40E_DCB_H_ */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_prototype.h b/drivers/net/ethernet/intel/i40e/i40e_prototype.h
index 5c1378641b3b..aaea297640e0 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_prototype.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_prototype.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright(c) 2013 - 2018 Intel Corporation. */
+/* Copyright(c) 2013 - 2021 Intel Corporation. */
 
 #ifndef _I40E_PROTOTYPE_H_
 #define _I40E_PROTOTYPE_H_
@@ -200,6 +200,10 @@ i40e_status i40e_aq_get_lldp_mib(struct i40e_hw *hw, u8 bridge_type,
 				u8 mib_type, void *buff, u16 buff_size,
 				u16 *local_len, u16 *remote_len,
 				struct i40e_asq_cmd_details *cmd_details);
+enum i40e_status_code
+i40e_aq_set_lldp_mib(struct i40e_hw *hw,
+		     u8 mib_type, void *buff, u16 buff_size,
+		     struct i40e_asq_cmd_details *cmd_details);
 i40e_status i40e_aq_cfg_lldp_mib_change_event(struct i40e_hw *hw,
 				bool enable_update,
 				struct i40e_asq_cmd_details *cmd_details);
@@ -289,6 +293,9 @@ i40e_aq_rem_cloud_filters_bb(struct i40e_hw *hw, u16 seid,
 			     u8 filter_count);
 i40e_status i40e_read_lldp_cfg(struct i40e_hw *hw,
 			       struct i40e_lldp_variables *lldp_cfg);
+enum i40e_status_code
+i40e_aq_suspend_port_tx(struct i40e_hw *hw, u16 seid,
+			struct i40e_asq_cmd_details *cmd_details);
 /* i40e_common */
 i40e_status i40e_init_shared_code(struct i40e_hw *hw);
 i40e_status i40e_pf_reset(struct i40e_hw *hw);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_register.h b/drivers/net/ethernet/intel/i40e/i40e_register.h
index 564df22f3f46..f79355b1dde6 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_register.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_register.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright(c) 2013 - 2018 Intel Corporation. */
+/* Copyright(c) 2013 - 2021 Intel Corporation. */
 
 #ifndef _I40E_REGISTER_H_
 #define _I40E_REGISTER_H_
@@ -34,12 +34,137 @@
 #define I40E_PF_ATQLEN_ATQENABLE_SHIFT 31
 #define I40E_PF_ATQLEN_ATQENABLE_MASK I40E_MASK(0x1u, I40E_PF_ATQLEN_ATQENABLE_SHIFT)
 #define I40E_PF_ATQT 0x00080400 /* Reset: EMPR */
+#define I40E_PRT_SWR_PM_THR 0x0026CD00 /* Reset: CORER */
+#define I40E_PRT_SWR_PM_THR_THRESHOLD_SHIFT 0
+#define I40E_PRT_SWR_PM_THR_THRESHOLD_MASK I40E_MASK(0xFF, I40E_PRT_SWR_PM_THR_THRESHOLD_SHIFT)
+#define I40E_PRTDCB_FCCFG 0x001E4640 /* Reset: GLOBR */
+#define I40E_PRTDCB_FCCFG_TFCE_SHIFT 3
+#define I40E_PRTDCB_FCCFG_TFCE_MASK I40E_MASK(0x3, I40E_PRTDCB_FCCFG_TFCE_SHIFT)
 #define I40E_PRTDCB_GENC 0x00083000 /* Reset: CORER */
+#define I40E_PRTDCB_GENC_NUMTC_SHIFT 2
+#define I40E_PRTDCB_GENC_NUMTC_MASK I40E_MASK(0xF, I40E_PRTDCB_GENC_NUMTC_SHIFT)
 #define I40E_PRTDCB_GENC_PFCLDA_SHIFT 16
 #define I40E_PRTDCB_GENC_PFCLDA_MASK I40E_MASK(0xFFFF, I40E_PRTDCB_GENC_PFCLDA_SHIFT)
 #define I40E_PRTDCB_GENS 0x00083020 /* Reset: CORER */
 #define I40E_PRTDCB_GENS_DCBX_STATUS_SHIFT 0
 #define I40E_PRTDCB_GENS_DCBX_STATUS_MASK I40E_MASK(0x7, I40E_PRTDCB_GENS_DCBX_STATUS_SHIFT)
+#define I40E_PRTDCB_MFLCN 0x001E2400 /* Reset: GLOBR */
+#define I40E_PRTDCB_MFLCN_PMCF_SHIFT 0
+#define I40E_PRTDCB_MFLCN_PMCF_MASK I40E_MASK(0x1, I40E_PRTDCB_MFLCN_PMCF_SHIFT)
+#define I40E_PRTDCB_MFLCN_DPF_SHIFT 1
+#define I40E_PRTDCB_MFLCN_DPF_MASK I40E_MASK(0x1, I40E_PRTDCB_MFLCN_DPF_SHIFT)
+#define I40E_PRTDCB_MFLCN_RPFCM_SHIFT 2
+#define I40E_PRTDCB_MFLCN_RPFCM_MASK I40E_MASK(0x1, I40E_PRTDCB_MFLCN_RPFCM_SHIFT)
+#define I40E_PRTDCB_MFLCN_RFCE_SHIFT 3
+#define I40E_PRTDCB_MFLCN_RFCE_MASK I40E_MASK(0x1, I40E_PRTDCB_MFLCN_RFCE_SHIFT)
+#define I40E_PRTDCB_MFLCN_RPFCE_SHIFT 4
+#define I40E_PRTDCB_MFLCN_RPFCE_MASK I40E_MASK(0xFF, I40E_PRTDCB_MFLCN_RPFCE_SHIFT)
+#define I40E_PRTDCB_RETSC 0x001223E0 /* Reset: CORER */
+#define I40E_PRTDCB_RETSC_ETS_MODE_SHIFT 0
+#define I40E_PRTDCB_RETSC_ETS_MODE_MASK I40E_MASK(0x1, I40E_PRTDCB_RETSC_ETS_MODE_SHIFT)
+#define I40E_PRTDCB_RETSC_NON_ETS_MODE_SHIFT 1
+#define I40E_PRTDCB_RETSC_NON_ETS_MODE_MASK I40E_MASK(0x1, I40E_PRTDCB_RETSC_NON_ETS_MODE_SHIFT)
+#define I40E_PRTDCB_RETSC_ETS_MAX_EXP_SHIFT 2
+#define I40E_PRTDCB_RETSC_ETS_MAX_EXP_MASK I40E_MASK(0xF, I40E_PRTDCB_RETSC_ETS_MAX_EXP_SHIFT)
+#define I40E_PRTDCB_RETSC_LLTC_SHIFT 8
+#define I40E_PRTDCB_RETSC_LLTC_MASK I40E_MASK(0xFF, I40E_PRTDCB_RETSC_LLTC_SHIFT)
+#define I40E_PRTDCB_RETSTCC(_i) (0x00122180 + ((_i) * 32)) /* _i=0...7 */ /* Reset: CORER */
+#define I40E_PRTDCB_RETSTCC_MAX_INDEX 7
+#define I40E_PRTDCB_RETSTCC_BWSHARE_SHIFT 0
+#define I40E_PRTDCB_RETSTCC_BWSHARE_MASK I40E_MASK(0x7F, I40E_PRTDCB_RETSTCC_BWSHARE_SHIFT)
+#define I40E_PRTDCB_RETSTCC_UPINTC_MODE_SHIFT 30
+#define I40E_PRTDCB_RETSTCC_UPINTC_MODE_MASK I40E_MASK(0x1, I40E_PRTDCB_RETSTCC_UPINTC_MODE_SHIFT)
+#define I40E_PRTDCB_RETSTCC_ETSTC_SHIFT 31
+#define I40E_PRTDCB_RETSTCC_ETSTC_MASK I40E_MASK(0x1u, I40E_PRTDCB_RETSTCC_ETSTC_SHIFT)
+#define I40E_PRTDCB_RPPMC 0x001223A0 /* Reset: CORER */
+#define I40E_PRTDCB_RPPMC_LANRPPM_SHIFT 0
+#define I40E_PRTDCB_RPPMC_LANRPPM_MASK I40E_MASK(0xFF, I40E_PRTDCB_RPPMC_LANRPPM_SHIFT)
+#define I40E_PRTDCB_RPPMC_RDMARPPM_SHIFT 8
+#define I40E_PRTDCB_RPPMC_RDMARPPM_MASK I40E_MASK(0xFF, I40E_PRTDCB_RPPMC_RDMARPPM_SHIFT)
+#define I40E_PRTDCB_RPPMC_RX_FIFO_SIZE_SHIFT 16
+#define I40E_PRTDCB_RPPMC_RX_FIFO_SIZE_MASK I40E_MASK(0xFF, I40E_PRTDCB_RPPMC_RX_FIFO_SIZE_SHIFT)
+#define I40E_PRTDCB_RUP 0x001C0B00 /* Reset: CORER */
+#define I40E_PRTDCB_RUP_NOVLANUP_SHIFT 0
+#define I40E_PRTDCB_RUP_NOVLANUP_MASK I40E_MASK(0x7, I40E_PRTDCB_RUP_NOVLANUP_SHIFT)
+#define I40E_PRTDCB_RUP2TC 0x001C09A0 /* Reset: CORER */
+#define I40E_PRTDCB_RUP2TC_UP0TC_SHIFT 0
+#define I40E_PRTDCB_RUP2TC_UP0TC_MASK I40E_MASK(0x7, I40E_PRTDCB_RUP2TC_UP0TC_SHIFT)
+#define I40E_PRTDCB_RUP2TC_UP1TC_SHIFT 3
+#define I40E_PRTDCB_RUP2TC_UP1TC_MASK I40E_MASK(0x7, I40E_PRTDCB_RUP2TC_UP1TC_SHIFT)
+#define I40E_PRTDCB_RUP2TC_UP2TC_SHIFT 6
+#define I40E_PRTDCB_RUP2TC_UP2TC_MASK I40E_MASK(0x7, I40E_PRTDCB_RUP2TC_UP2TC_SHIFT)
+#define I40E_PRTDCB_RUP2TC_UP3TC_SHIFT 9
+#define I40E_PRTDCB_RUP2TC_UP3TC_MASK I40E_MASK(0x7, I40E_PRTDCB_RUP2TC_UP3TC_SHIFT)
+#define I40E_PRTDCB_RUP2TC_UP4TC_SHIFT 12
+#define I40E_PRTDCB_RUP2TC_UP4TC_MASK I40E_MASK(0x7, I40E_PRTDCB_RUP2TC_UP4TC_SHIFT)
+#define I40E_PRTDCB_RUP2TC_UP5TC_SHIFT 15
+#define I40E_PRTDCB_RUP2TC_UP5TC_MASK I40E_MASK(0x7, I40E_PRTDCB_RUP2TC_UP5TC_SHIFT)
+#define I40E_PRTDCB_RUP2TC_UP6TC_SHIFT 18
+#define I40E_PRTDCB_RUP2TC_UP6TC_MASK I40E_MASK(0x7, I40E_PRTDCB_RUP2TC_UP6TC_SHIFT)
+#define I40E_PRTDCB_RUP2TC_UP7TC_SHIFT 21
+#define I40E_PRTDCB_RUP2TC_UP7TC_MASK I40E_MASK(0x7, I40E_PRTDCB_RUP2TC_UP7TC_SHIFT)
+#define I40E_PRTDCB_RUPTQ(_i) (0x00122400 + ((_i) * 32)) /* _i=0...7 */ /* Reset: CORER */
+#define I40E_PRTDCB_RUPTQ_MAX_INDEX 7
+#define I40E_PRTDCB_RUPTQ_RXQNUM_SHIFT 0
+#define I40E_PRTDCB_RUPTQ_RXQNUM_MASK I40E_MASK(0x3FFF, I40E_PRTDCB_RUPTQ_RXQNUM_SHIFT)
+#define I40E_PRTDCB_TC2PFC 0x001C0980 /* Reset: CORER */
+#define I40E_PRTDCB_TC2PFC_TC2PFC_SHIFT 0
+#define I40E_PRTDCB_TC2PFC_TC2PFC_MASK I40E_MASK(0xFF, I40E_PRTDCB_TC2PFC_TC2PFC_SHIFT)
+#define I40E_PRTDCB_TCMSTC(_i) (0x000A0040 + ((_i) * 32)) /* _i=0...7 */ /* Reset: CORER */
+#define I40E_PRTDCB_TCMSTC_MAX_INDEX 7
+#define I40E_PRTDCB_TCMSTC_MSTC_SHIFT 0
+#define I40E_PRTDCB_TCMSTC_MSTC_MASK I40E_MASK(0xFFFFF, I40E_PRTDCB_TCMSTC_MSTC_SHIFT)
+#define I40E_PRTDCB_TCPMC 0x000A21A0 /* Reset: CORER */
+#define I40E_PRTDCB_TCPMC_CPM_SHIFT 0
+#define I40E_PRTDCB_TCPMC_CPM_MASK I40E_MASK(0x1FFF, I40E_PRTDCB_TCPMC_CPM_SHIFT)
+#define I40E_PRTDCB_TCPMC_LLTC_SHIFT 13
+#define I40E_PRTDCB_TCPMC_LLTC_MASK I40E_MASK(0xFF, I40E_PRTDCB_TCPMC_LLTC_SHIFT)
+#define I40E_PRTDCB_TCPMC_TCPM_MODE_SHIFT 30
+#define I40E_PRTDCB_TCPMC_TCPM_MODE_MASK I40E_MASK(0x1, I40E_PRTDCB_TCPMC_TCPM_MODE_SHIFT)
+#define I40E_PRTDCB_TCWSTC(_i) (0x000A2040 + ((_i) * 32)) /* _i=0...7 */ /* Reset: CORER */
+#define I40E_PRTDCB_TCWSTC_MAX_INDEX 7
+#define I40E_PRTDCB_TCWSTC_MSTC_SHIFT 0
+#define I40E_PRTDCB_TCWSTC_MSTC_MASK I40E_MASK(0xFFFFF, I40E_PRTDCB_TCWSTC_MSTC_SHIFT)
+#define I40E_PRTDCB_TDPMC 0x000A0180 /* Reset: CORER */
+#define I40E_PRTDCB_TDPMC_DPM_SHIFT 0
+#define I40E_PRTDCB_TDPMC_DPM_MASK I40E_MASK(0xFF, I40E_PRTDCB_TDPMC_DPM_SHIFT)
+#define I40E_PRTDCB_TDPMC_TCPM_MODE_SHIFT 30
+#define I40E_PRTDCB_TDPMC_TCPM_MODE_MASK I40E_MASK(0x1, I40E_PRTDCB_TDPMC_TCPM_MODE_SHIFT)
+#define I40E_PRTDCB_TETSC_TCB 0x000AE060 /* Reset: CORER */
+#define I40E_PRTDCB_TETSC_TCB_EN_LL_STRICT_PRIORITY_SHIFT 0
+#define I40E_PRTDCB_TETSC_TCB_EN_LL_STRICT_PRIORITY_MASK I40E_MASK(0x1, \
+	I40E_PRTDCB_TETSC_TCB_EN_LL_STRICT_PRIORITY_SHIFT)
+#define I40E_PRTDCB_TETSC_TCB_LLTC_SHIFT 8
+#define I40E_PRTDCB_TETSC_TCB_LLTC_MASK I40E_MASK(0xFF, I40E_PRTDCB_TETSC_TCB_LLTC_SHIFT)
+#define I40E_PRTDCB_TETSC_TPB 0x00098060 /* Reset: CORER */
+#define I40E_PRTDCB_TETSC_TPB_EN_LL_STRICT_PRIORITY_SHIFT 0
+#define I40E_PRTDCB_TETSC_TPB_EN_LL_STRICT_PRIORITY_MASK I40E_MASK(0x1, \
+	I40E_PRTDCB_TETSC_TPB_EN_LL_STRICT_PRIORITY_SHIFT)
+#define I40E_PRTDCB_TETSC_TPB_LLTC_SHIFT 8
+#define I40E_PRTDCB_TETSC_TPB_LLTC_MASK I40E_MASK(0xFF, I40E_PRTDCB_TETSC_TPB_LLTC_SHIFT)
+#define I40E_PRTDCB_TFCS 0x001E4560 /* Reset: GLOBR */
+#define I40E_PRTDCB_TFCS_TXOFF_SHIFT 0
+#define I40E_PRTDCB_TFCS_TXOFF_MASK I40E_MASK(0x1, I40E_PRTDCB_TFCS_TXOFF_SHIFT)
+#define I40E_PRTDCB_TFCS_TXOFF0_SHIFT 8
+#define I40E_PRTDCB_TFCS_TXOFF0_MASK I40E_MASK(0x1, I40E_PRTDCB_TFCS_TXOFF0_SHIFT)
+#define I40E_PRTDCB_TFCS_TXOFF1_SHIFT 9
+#define I40E_PRTDCB_TFCS_TXOFF1_MASK I40E_MASK(0x1, I40E_PRTDCB_TFCS_TXOFF1_SHIFT)
+#define I40E_PRTDCB_TFCS_TXOFF2_SHIFT 10
+#define I40E_PRTDCB_TFCS_TXOFF2_MASK I40E_MASK(0x1, I40E_PRTDCB_TFCS_TXOFF2_SHIFT)
+#define I40E_PRTDCB_TFCS_TXOFF3_SHIFT 11
+#define I40E_PRTDCB_TFCS_TXOFF3_MASK I40E_MASK(0x1, I40E_PRTDCB_TFCS_TXOFF3_SHIFT)
+#define I40E_PRTDCB_TFCS_TXOFF4_SHIFT 12
+#define I40E_PRTDCB_TFCS_TXOFF4_MASK I40E_MASK(0x1, I40E_PRTDCB_TFCS_TXOFF4_SHIFT)
+#define I40E_PRTDCB_TFCS_TXOFF5_SHIFT 13
+#define I40E_PRTDCB_TFCS_TXOFF5_MASK I40E_MASK(0x1, I40E_PRTDCB_TFCS_TXOFF5_SHIFT)
+#define I40E_PRTDCB_TFCS_TXOFF6_SHIFT 14
+#define I40E_PRTDCB_TFCS_TXOFF6_MASK I40E_MASK(0x1, I40E_PRTDCB_TFCS_TXOFF6_SHIFT)
+#define I40E_PRTDCB_TFCS_TXOFF7_SHIFT 15
+#define I40E_PRTDCB_TFCS_TXOFF7_MASK I40E_MASK(0x1, I40E_PRTDCB_TFCS_TXOFF7_SHIFT)
+#define I40E_PRTDCB_TPFCTS(_i) (0x001E4660 + ((_i) * 32)) /* _i=0...7 */ /* Reset: GLOBR */
+#define I40E_PRTDCB_TPFCTS_MAX_INDEX 7
+#define I40E_PRTDCB_TPFCTS_PFCTIMER_SHIFT 0
+#define I40E_PRTDCB_TPFCTS_PFCTIMER_MASK I40E_MASK(0x3FFF, I40E_PRTDCB_TPFCTS_PFCTIMER_SHIFT)
 #define I40E_GL_FWSTS 0x00083048 /* Reset: POR */
 #define I40E_GL_FWSTS_FWS1B_SHIFT 16
 #define I40E_GL_FWSTS_FWS1B_MASK I40E_MASK(0xFF, I40E_GL_FWSTS_FWS1B_SHIFT)
@@ -359,6 +484,27 @@
 #define I40E_PRTGL_SAL 0x001E2120 /* Reset: GLOBR */
 #define I40E_PRTGL_SAL_FC_SAL_SHIFT 0
 #define I40E_PRTGL_SAL_FC_SAL_MASK I40E_MASK(0xFFFFFFFF, I40E_PRTGL_SAL_FC_SAL_SHIFT)
+#define I40E_PRTMAC_HSEC_CTL_RX_ENABLE_GPP 0x001E3260 /* Reset: GLOBR */
+#define I40E_PRTMAC_HSEC_CTL_RX_ENABLE_GPP_SHIFT 0
+#define I40E_PRTMAC_HSEC_CTL_RX_ENABLE_GPP_MASK I40E_MASK(0x1, \
+	I40E_PRTMAC_HSEC_CTL_RX_ENABLE_GPP_SHIFT)
+#define I40E_PRTMAC_HSEC_CTL_RX_ENABLE_PPP 0x001E32E0 /* Reset: GLOBR */
+#define I40E_PRTMAC_HSEC_CTL_RX_ENABLE_PPP_SHIFT 0
+#define I40E_PRTMAC_HSEC_CTL_RX_ENABLE_PPP_MASK I40E_MASK(0x1, \
+	I40E_PRTMAC_HSEC_CTL_RX_ENABLE_PPP_SHIFT)
+#define I40E_PRTMAC_HSEC_CTL_RX_PAUSE_ENABLE 0x001E30C0 /* Reset: GLOBR */
+#define I40E_PRTMAC_HSEC_CTL_RX_PAUSE_ENABLE_SHIFT 0
+#define I40E_PRTMAC_HSEC_CTL_RX_PAUSE_ENABLE_MASK I40E_MASK(0x1FF, \
+	I40E_PRTMAC_HSEC_CTL_RX_PAUSE_ENABLE_SHIFT)
+#define I40E_PRTMAC_HSEC_CTL_TX_PAUSE_ENABLE 0x001E30D0 /* Reset: GLOBR */
+#define I40E_PRTMAC_HSEC_CTL_TX_PAUSE_ENABLE_SHIFT 0
+#define I40E_PRTMAC_HSEC_CTL_TX_PAUSE_ENABLE_MASK I40E_MASK(0x1FF, \
+	I40E_PRTMAC_HSEC_CTL_TX_PAUSE_ENABLE_SHIFT)
+#define I40E_PRTMAC_HSEC_CTL_TX_PAUSE_REFRESH_TIMER(_i) (0x001E3400 + ((_i) * 16)) /* _i=0...8 */
+#define I40E_PRTMAC_HSEC_CTL_TX_PAUSE_REFRESH_TIMER_MAX_INDEX 8
+#define I40E_PRTMAC_HSEC_CTL_TX_PAUSE_REFRESH_TIMER_SHIFT 0
+#define I40E_PRTMAC_HSEC_CTL_TX_PAUSE_REFRESH_TIMER_MASK I40E_MASK(0xFFFF, \
+	I40E_PRTMAC_HSEC_CTL_TX_PAUSE_REFRESH_TIMER_SHIFT)
 #define I40E_GLNVM_FLA 0x000B6108 /* Reset: POR */
 #define I40E_GLNVM_FLA_LOCKED_SHIFT 6
 #define I40E_GLNVM_FLA_LOCKED_MASK I40E_MASK(0x1, I40E_GLNVM_FLA_LOCKED_SHIFT)
@@ -400,6 +546,30 @@
 #define I40E_PRTPM_EEE_STAT_TX_LPI_STATUS_MASK I40E_MASK(0x1, I40E_PRTPM_EEE_STAT_TX_LPI_STATUS_SHIFT)
 #define I40E_PRTPM_RLPIC 0x001E43A0 /* Reset: GLOBR */
 #define I40E_PRTPM_TLPIC 0x001E43C0 /* Reset: GLOBR */
+#define I40E_PRTRPB_DHW(_i) (0x000AC100 + ((_i) * 32)) /* _i=0...7 */ /* Reset: CORER */
+#define I40E_PRTRPB_DHW_DHW_TCN_SHIFT 0
+#define I40E_PRTRPB_DHW_DHW_TCN_MASK I40E_MASK(0xFFFFF, I40E_PRTRPB_DHW_DHW_TCN_SHIFT)
+#define I40E_PRTRPB_DLW(_i) (0x000AC220 + ((_i) * 32)) /* _i=0...7 */ /* Reset: CORER */
+#define I40E_PRTRPB_DLW_DLW_TCN_SHIFT 0
+#define I40E_PRTRPB_DLW_DLW_TCN_MASK I40E_MASK(0xFFFFF, I40E_PRTRPB_DLW_DLW_TCN_SHIFT)
+#define I40E_PRTRPB_DPS(_i) (0x000AC320 + ((_i) * 32)) /* _i=0...7 */ /* Reset: CORER */
+#define I40E_PRTRPB_DPS_DPS_TCN_SHIFT 0
+#define I40E_PRTRPB_DPS_DPS_TCN_MASK I40E_MASK(0xFFFFF, I40E_PRTRPB_DPS_DPS_TCN_SHIFT)
+#define I40E_PRTRPB_SHT(_i) (0x000AC480 + ((_i) * 32)) /* _i=0...7 */ /* Reset: CORER */
+#define I40E_PRTRPB_SHT_SHT_TCN_SHIFT 0
+#define I40E_PRTRPB_SHT_SHT_TCN_MASK I40E_MASK(0xFFFFF, I40E_PRTRPB_SHT_SHT_TCN_SHIFT)
+#define I40E_PRTRPB_SHW 0x000AC580 /* Reset: CORER */
+#define I40E_PRTRPB_SHW_SHW_SHIFT 0
+#define I40E_PRTRPB_SHW_SHW_MASK I40E_MASK(0xFFFFF, I40E_PRTRPB_SHW_SHW_SHIFT)
+#define I40E_PRTRPB_SLT(_i) (0x000AC5A0 + ((_i) * 32)) /* _i=0...7 */ /* Reset: CORER */
+#define I40E_PRTRPB_SLT_SLT_TCN_SHIFT 0
+#define I40E_PRTRPB_SLT_SLT_TCN_MASK I40E_MASK(0xFFFFF, I40E_PRTRPB_SLT_SLT_TCN_SHIFT)
+#define I40E_PRTRPB_SLW 0x000AC6A0 /* Reset: CORER */
+#define I40E_PRTRPB_SLW_SLW_SHIFT 0
+#define I40E_PRTRPB_SLW_SLW_MASK I40E_MASK(0xFFFFF, I40E_PRTRPB_SLW_SLW_SHIFT)
+#define I40E_PRTRPB_SPS 0x000AC7C0 /* Reset: CORER */
+#define I40E_PRTRPB_SPS_SPS_SHIFT 0
+#define I40E_PRTRPB_SPS_SPS_MASK I40E_MASK(0xFFFFF, I40E_PRTRPB_SPS_SPS_SHIFT)
 #define I40E_GLQF_FDCNT_0 0x00269BAC /* Reset: CORER */
 #define I40E_GLQF_FDCNT_0_GUARANT_CNT_SHIFT 0
 #define I40E_GLQF_FDCNT_0_GUARANT_CNT_MASK I40E_MASK(0x1FFF, I40E_GLQF_FDCNT_0_GUARANT_CNT_SHIFT)
diff --git a/drivers/net/ethernet/intel/i40e/i40e_type.h b/drivers/net/ethernet/intel/i40e/i40e_type.h
index c0bdc666f557..cea7fde2fa03 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_type.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_type.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright(c) 2013 - 2018 Intel Corporation. */
+/* Copyright(c) 2013 - 2021 Intel Corporation. */
 
 #ifndef _I40E_TYPE_H_
 #define _I40E_TYPE_H_
@@ -517,6 +517,7 @@ struct i40e_dcbx_config {
 #define I40E_DCBX_MODE_CEE	0x1
 #define I40E_DCBX_MODE_IEEE	0x2
 	u8  app_mode;
+#define I40E_DCBX_APPS_NON_WILLING 0x1
 	u32 numapps;
 	u32 tlv_status; /* CEE mode TLV status */
 	struct i40e_dcb_ets_config etscfg;
-- 
2.26.2

