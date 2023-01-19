Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC3F674518
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 22:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbjASVmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 16:42:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbjASVjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 16:39:36 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B63C94CB9
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 13:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674163685; x=1705699685;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9mXmRVUlEsINCj/fG9YFAJ6CYe5wD+yst6c6HZfRNBA=;
  b=MbFlsTOmnQwuRnXQWkLocbY8fI8z4NEyUqv7uosYl5ZGJZw9AkhaJKdG
   3OZimDST1/NtoitEih1V8bzpqi/LVmJRTt8gNMa1knlPCvfkcroqGhkK7
   5yt5h7HP/vyjlpCwMjeHTNBzkaOptz2VDJjJuNaUiMpA+KIFly5qqJwhs
   YVnJXebX+458AZCXUxF6QSb66I6MhcPocsKw0FSViEFY2hv6ajBDPt4P2
   x2rOVQFWmnsjSiFA2JdSF+zZ+gTp82Q9KSKJnzJfTnwryOuuTf0ABQWHm
   Cr01x+n4qtXl6pfoVXpM04VwPolbH7o17FTg4JbE7A2SMQpHv79Usl4b4
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="323120594"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="323120594"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 13:27:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="692589868"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="692589868"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga001.jf.intel.com with ESMTP; 19 Jan 2023 13:27:26 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tsotne Chakhvadze <tsotne.chakhvadze@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        lukasz.plachno@intel.com, Karen Sornek <karen.sornek@intel.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>,
        Arpana Arland <arpanax.arland@intel.com>
Subject: [PATCH net-next 01/15] ice: Add 'Execute Pending LLDP MIB' Admin Queue command
Date:   Thu, 19 Jan 2023 13:27:28 -0800
Message-Id: <20230119212742.2106833-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230119212742.2106833-1-anthony.l.nguyen@intel.com>
References: <20230119212742.2106833-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tsotne Chakhvadze <tsotne.chakhvadze@intel.com>

In DCB Willing Mode (FW managed LLDP), when the link partner changes
configuration which requires fewer TCs, the TCs that are no longer
needed are suspended by EMP FW, removed, and never resumed. This occurs
before a MIB change event is indicated to SW. The permanent suspension and
removal of these TC nodes in the scheduler prevents RDMA from being able
to destroy QPs associated with this TC, requiring a CORE reset to recover.

A new DCBX configuration change flow is defined to allow SW driver and
other SW components (RDMA) to properly adjust to the configuration
changes before they are taking effect in HW. This flow includes a
two-way handshake between EMP FW<->LAN SW<->RDMA SW.

List of changes:
- Add 'Execute Pending LLDP MIB' AQC.
- Add 'Pending Event Enable' bit.
- Add additional logic to ignore Pending Event Enable' request
  while 'LLDP MIB Chnage' event is disabled.
- Add 'Execute Pending LLDP MIB' AQC sending function to FW,
  which is needed to take place MIB Event change.

Signed-off-by: Tsotne Chakhvadze <tsotne.chakhvadze@intel.com>
Co-developed-by: Karen Sornek <karen.sornek@intel.com>
Signed-off-by: Karen Sornek <karen.sornek@intel.com>
Co-developed-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Co-developed-by: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
Signed-off-by: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
Tested-by: Arpana Arland <arpanax.arland@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h    | 18 ++++++++++++++++--
 drivers/net/ethernet/intel/ice/ice_common.c    | 13 +++++++++++++
 drivers/net/ethernet/intel/ice/ice_common.h    |  1 +
 drivers/net/ethernet/intel/ice/ice_dcb.c       |  3 +++
 4 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 958c1e435232..838d9b274d68 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1659,14 +1659,24 @@ struct ice_aqc_lldp_get_mib {
 #define ICE_AQ_LLDP_TX_ACTIVE			0
 #define ICE_AQ_LLDP_TX_SUSPENDED		1
 #define ICE_AQ_LLDP_TX_FLUSHED			3
+/* DCBX mode */
+#define ICE_AQ_LLDP_DCBX_M			GENMASK(7, 6)
+#define ICE_AQ_LLDP_DCBX_NA			0
+#define ICE_AQ_LLDP_DCBX_CEE			1
+#define ICE_AQ_LLDP_DCBX_IEEE			2
+
+	u8 state;
+#define ICE_AQ_LLDP_MIB_CHANGE_STATE_M		BIT(0)
+#define ICE_AQ_LLDP_MIB_CHANGE_EXECUTED		0
+#define ICE_AQ_LLDP_MIB_CHANGE_PENDING		1
+
 /* The following bytes are reserved for the Get LLDP MIB command (0x0A00)
  * and in the LLDP MIB Change Event (0x0A01). They are valid for the
  * Get LLDP MIB (0x0A00) response only.
  */
-	u8 reserved1;
 	__le16 local_len;
 	__le16 remote_len;
-	u8 reserved2[2];
+	u8 reserved[2];
 	__le32 addr_high;
 	__le32 addr_low;
 };
@@ -1677,6 +1687,9 @@ struct ice_aqc_lldp_set_mib_change {
 	u8 command;
 #define ICE_AQ_LLDP_MIB_UPDATE_ENABLE		0x0
 #define ICE_AQ_LLDP_MIB_UPDATE_DIS		0x1
+#define ICE_AQ_LLDP_MIB_PENDING_M		BIT(1)
+#define ICE_AQ_LLDP_MIB_PENDING_DISABLE		0
+#define ICE_AQ_LLDP_MIB_PENDING_ENABLE		1
 	u8 reserved[15];
 };
 
@@ -2329,6 +2342,7 @@ enum ice_adminq_opc {
 	ice_aqc_opc_lldp_set_local_mib			= 0x0A08,
 	ice_aqc_opc_lldp_stop_start_specific_agent	= 0x0A09,
 	ice_aqc_opc_lldp_filter_ctrl			= 0x0A0A,
+	ice_aqc_opc_lldp_execute_pending_mib		= 0x0A0B,
 
 	/* RSS commands */
 	ice_aqc_opc_set_rss_key				= 0x0B02,
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index d02b55b6aa9c..f5842ff42bc7 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -5503,6 +5503,19 @@ ice_lldp_fltr_add_remove(struct ice_hw *hw, u16 vsi_num, bool add)
 	return ice_aq_send_cmd(hw, &desc, NULL, 0, NULL);
 }
 
+/**
+ * ice_lldp_execute_pending_mib - execute LLDP pending MIB request
+ * @hw: pointer to HW struct
+ */
+int ice_lldp_execute_pending_mib(struct ice_hw *hw)
+{
+	struct ice_aq_desc desc;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_lldp_execute_pending_mib);
+
+	return ice_aq_send_cmd(hw, &desc, NULL, 0, NULL);
+}
+
 /**
  * ice_fw_supports_report_dflt_cfg
  * @hw: pointer to the hardware structure
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 4c6a0b5c9304..22839c4f7247 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -221,6 +221,7 @@ ice_aq_set_lldp_mib(struct ice_hw *hw, u8 mib_type, void *buf, u16 buf_size,
 bool ice_fw_supports_lldp_fltr_ctrl(struct ice_hw *hw);
 int
 ice_lldp_fltr_add_remove(struct ice_hw *hw, u16 vsi_num, bool add);
+int ice_lldp_execute_pending_mib(struct ice_hw *hw);
 int
 ice_aq_read_i2c(struct ice_hw *hw, struct ice_aqc_link_topo_addr topo_addr,
 		u16 bus_addr, __le16 addr, u8 params, u8 *data,
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb.c b/drivers/net/ethernet/intel/ice/ice_dcb.c
index 6be02f9b0b8c..22a94e05233a 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb.c
@@ -73,6 +73,9 @@ ice_aq_cfg_lldp_mib_change(struct ice_hw *hw, bool ena_update,
 
 	if (!ena_update)
 		cmd->command |= ICE_AQ_LLDP_MIB_UPDATE_DIS;
+	else
+		cmd->command |= FIELD_PREP(ICE_AQ_LLDP_MIB_PENDING_M,
+					   ICE_AQ_LLDP_MIB_PENDING_ENABLE);
 
 	return ice_aq_send_cmd(hw, &desc, NULL, 0, cd);
 }
-- 
2.38.1

