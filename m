Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C1A53A360
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 13:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352240AbiFALBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 07:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352239AbiFALA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 07:00:59 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA9B87A3D;
        Wed,  1 Jun 2022 04:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654081255; x=1685617255;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uvZYnWXEBdVsWK8hcE8N3xslkBAQQvJxIizBzObTpZg=;
  b=OkYJ69LO+KIR/CepI1WKMqAVLKxlcgQTxh3TpfDuUym6dWrlAg/ufIVA
   YXuBVbPNp3A6nXo8tfLpH8LvDPh30/UIbs8r/yF06pN7xbsl00IisxQdl
   vGgHOGYz+ZFrHteOtsYnE9UwQrdCUTS48cKQ1Bn25EwfsS5SyYbq1cU7G
   2jeGkFTpewiAGxYefE/ZO2Gcp8i3dovuPH7LeLFK3scfYoDwTVnfINp52
   TrVrJ0MR1NPC0PilBOjkQM1GyBlloa132BYahMhzfzJCexLdnsU4gpyry
   52ELn3GD17FVl1ZriZkAyPvdY9HSIcHkk7e+t4Oo1JgV+dk5D8GhWrLlm
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10364"; a="300901336"
X-IronPort-AV: E=Sophos;i="5.91,268,1647327600"; 
   d="scan'208";a="300901336"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 04:00:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,268,1647327600"; 
   d="scan'208";a="552255407"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga006.jf.intel.com with ESMTP; 01 Jun 2022 04:00:50 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 251B0nFb000755;
        Wed, 1 Jun 2022 12:00:49 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Wojciech Drewek <wojciech.drewek@intel.com>,
        Marcin Szycik <marcin.szycik@linux.intel.com>,
        Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@intel.com>,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] ice: fix access-beyond-end in the switch code
Date:   Wed,  1 Jun 2022 12:59:24 +0200
Message-Id: <20220601105924.2841410-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Global `-Warray-bounds` enablement revealed some problems, one of
which is the way we define and use AQC rules messages.
In fact, they have a shared header, followed by the actual message,
which can be of one of several different formats. So it is
straightforward enough to define that header as a separate struct
and then embed it into message structures as needed, but currently
all the formats reside in one union coupled with the header. Then,
the code allocates only the memory needed for a particular message
format, leaving the union potentially incomplete.
There are no actual reads or writes beyond the end of an allocated
chunk, but at the same time, the whole implementation is fragile and
backed by an equilibrium rather than strong type and memory checks.

Define the structures the other way around: one for the common
header and the rest for the actual formats with the header embedded.
There are no places where several union members would be used at the
same time anyway. This allows to use proper struct_size() and let
the compiler know what is going to be done.
Finally, unsilence `-Warray-bounds` back for ice_switch.c.

Other little things worth mentioning:
* &ice_sw_rule_vsi_list_query is not used anywhere, remove it. It's
  weird anyway to talk to hardware with purely kernel types
  (bitmaps);
* expand the ICE_SW_RULE_*_SIZE() macros to pass a structure
  variable name to struct_size() to let it do strict typechecking;
* rename ice_sw_rule_lkup_rx_tx::hdr to ::hdr_data to keep ::hdr
  for the header structure to have the same name for it constistenly
  everywhere;
* drop the duplicate of %ICE_SW_RULE_RX_TX_NO_HDR_SIZE residing in
  ice_switch.h.

Fixes: 9daf8208dd4d ("ice: Add support for switch filter programming")
Fixes: 66486d8943ba ("ice: replace single-element array used for C struct hack")
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Marcin Szycik <marcin.szycik@linux.intel.com>
---
To Tony: I'd like this to hit RC1 or RC2, so would it be okay to pass
through -net directly? Or via some quick pull request would work too
I guess :)
---
 drivers/net/ethernet/intel/ice/Makefile       |   5 -
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  58 +++---
 drivers/net/ethernet/intel/ice/ice_switch.c   | 188 +++++++++---------
 drivers/net/ethernet/intel/ice/ice_switch.h   |   3 -
 4 files changed, 115 insertions(+), 139 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index 46f439641441..9183d480b70b 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -47,8 +47,3 @@ ice-$(CONFIG_DCB) += ice_dcb.o ice_dcb_nl.o ice_dcb_lib.o
 ice-$(CONFIG_RFS_ACCEL) += ice_arfs.o
 ice-$(CONFIG_XDP_SOCKETS) += ice_xsk.o
 ice-$(CONFIG_ICE_SWITCHDEV) += ice_eswitch.o
-
-# FIXME: temporarily silence -Warray-bounds on non W=1+ builds
-ifndef KBUILD_EXTRA_WARN
-CFLAGS_ice_switch.o += -Wno-array-bounds
-endif
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index b25e27c4d887..05cb9dd7035a 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -601,12 +601,30 @@ struct ice_aqc_sw_rules {
 	__le32 addr_low;
 };
 
+/* Add switch rule response:
+ * Content of return buffer is same as the input buffer. The status field and
+ * LUT index are updated as part of the response
+ */
+struct ice_aqc_sw_rules_elem_hdr {
+	__le16 type; /* Switch rule type, one of T_... */
+#define ICE_AQC_SW_RULES_T_LKUP_RX		0x0
+#define ICE_AQC_SW_RULES_T_LKUP_TX		0x1
+#define ICE_AQC_SW_RULES_T_LG_ACT		0x2
+#define ICE_AQC_SW_RULES_T_VSI_LIST_SET		0x3
+#define ICE_AQC_SW_RULES_T_VSI_LIST_CLEAR	0x4
+#define ICE_AQC_SW_RULES_T_PRUNE_LIST_SET	0x5
+#define ICE_AQC_SW_RULES_T_PRUNE_LIST_CLEAR	0x6
+	__le16 status;
+} __packed __aligned(sizeof(__le16));
+
 /* Add/Update/Get/Remove lookup Rx/Tx command/response entry
  * This structures describes the lookup rules and associated actions. "index"
  * is returned as part of a response to a successful Add command, and can be
  * used to identify the rule for Update/Get/Remove commands.
  */
 struct ice_sw_rule_lkup_rx_tx {
+	struct ice_aqc_sw_rules_elem_hdr hdr;
+
 	__le16 recipe_id;
 #define ICE_SW_RECIPE_LOGICAL_PORT_FWD		10
 	/* Source port for LOOKUP_RX and source VSI in case of LOOKUP_TX */
@@ -683,14 +701,16 @@ struct ice_sw_rule_lkup_rx_tx {
 	 * lookup-type
 	 */
 	__le16 hdr_len;
-	u8 hdr[];
-};
+	u8 hdr_data[];
+} __packed __aligned(sizeof(__le16));
 
 /* Add/Update/Remove large action command/response entry
  * "index" is returned as part of a response to a successful Add command, and
  * can be used to identify the action for Update/Get/Remove commands.
  */
 struct ice_sw_rule_lg_act {
+	struct ice_aqc_sw_rules_elem_hdr hdr;
+
 	__le16 index; /* Index in large action table */
 	__le16 size;
 	/* Max number of large actions */
@@ -744,45 +764,19 @@ struct ice_sw_rule_lg_act {
 #define ICE_LG_ACT_STAT_COUNT_S		3
 #define ICE_LG_ACT_STAT_COUNT_M		(0x7F << ICE_LG_ACT_STAT_COUNT_S)
 	__le32 act[]; /* array of size for actions */
-};
+} __packed __aligned(sizeof(__le16));
 
 /* Add/Update/Remove VSI list command/response entry
  * "index" is returned as part of a response to a successful Add command, and
  * can be used to identify the VSI list for Update/Get/Remove commands.
  */
 struct ice_sw_rule_vsi_list {
+	struct ice_aqc_sw_rules_elem_hdr hdr;
+
 	__le16 index; /* Index of VSI/Prune list */
 	__le16 number_vsi;
 	__le16 vsi[]; /* Array of number_vsi VSI numbers */
-};
-
-/* Query VSI list command/response entry */
-struct ice_sw_rule_vsi_list_query {
-	__le16 index;
-	DECLARE_BITMAP(vsi_list, ICE_MAX_VSI);
-} __packed;
-
-/* Add switch rule response:
- * Content of return buffer is same as the input buffer. The status field and
- * LUT index are updated as part of the response
- */
-struct ice_aqc_sw_rules_elem {
-	__le16 type; /* Switch rule type, one of T_... */
-#define ICE_AQC_SW_RULES_T_LKUP_RX		0x0
-#define ICE_AQC_SW_RULES_T_LKUP_TX		0x1
-#define ICE_AQC_SW_RULES_T_LG_ACT		0x2
-#define ICE_AQC_SW_RULES_T_VSI_LIST_SET		0x3
-#define ICE_AQC_SW_RULES_T_VSI_LIST_CLEAR	0x4
-#define ICE_AQC_SW_RULES_T_PRUNE_LIST_SET	0x5
-#define ICE_AQC_SW_RULES_T_PRUNE_LIST_CLEAR	0x6
-	__le16 status;
-	union {
-		struct ice_sw_rule_lkup_rx_tx lkup_tx_rx;
-		struct ice_sw_rule_lg_act lg_act;
-		struct ice_sw_rule_vsi_list vsi_list;
-		struct ice_sw_rule_vsi_list_query vsi_list_query;
-	} __packed pdata;
-};
+} __packed __aligned(sizeof(__le16));
 
 /* Query PFC Mode (direct 0x0302)
  * Set PFC Mode (direct 0x0303)
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 9f0a4dfb4818..8d8f3eec79ee 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -1282,18 +1282,13 @@ static const struct ice_dummy_pkt_profile ice_dummy_pkt_profiles[] = {
 	ICE_PKT_PROFILE(tcp, 0),
 };
 
-#define ICE_SW_RULE_RX_TX_ETH_HDR_SIZE \
-	(offsetof(struct ice_aqc_sw_rules_elem, pdata.lkup_tx_rx.hdr) + \
-	 (DUMMY_ETH_HDR_LEN * \
-	  sizeof(((struct ice_sw_rule_lkup_rx_tx *)0)->hdr[0])))
-#define ICE_SW_RULE_RX_TX_NO_HDR_SIZE \
-	(offsetof(struct ice_aqc_sw_rules_elem, pdata.lkup_tx_rx.hdr))
-#define ICE_SW_RULE_LG_ACT_SIZE(n) \
-	(offsetof(struct ice_aqc_sw_rules_elem, pdata.lg_act.act) + \
-	 ((n) * sizeof(((struct ice_sw_rule_lg_act *)0)->act[0])))
-#define ICE_SW_RULE_VSI_LIST_SIZE(n) \
-	(offsetof(struct ice_aqc_sw_rules_elem, pdata.vsi_list.vsi) + \
-	 ((n) * sizeof(((struct ice_sw_rule_vsi_list *)0)->vsi[0])))
+#define ICE_SW_RULE_RX_TX_HDR_SIZE(s, l)	struct_size((s), hdr_data, (l))
+#define ICE_SW_RULE_RX_TX_ETH_HDR_SIZE(s)	\
+	ICE_SW_RULE_RX_TX_HDR_SIZE((s), DUMMY_ETH_HDR_LEN)
+#define ICE_SW_RULE_RX_TX_NO_HDR_SIZE(s)	\
+	ICE_SW_RULE_RX_TX_HDR_SIZE((s), 0)
+#define ICE_SW_RULE_LG_ACT_SIZE(s, n)		struct_size((s), act, (n))
+#define ICE_SW_RULE_VSI_LIST_SIZE(s, n)		struct_size((s), vsi, (n))
 
 /* this is a recipe to profile association bitmap */
 static DECLARE_BITMAP(recipe_to_profile[ICE_MAX_NUM_RECIPES],
@@ -2376,7 +2371,8 @@ static void ice_fill_sw_info(struct ice_hw *hw, struct ice_fltr_info *fi)
  */
 static void
 ice_fill_sw_rule(struct ice_hw *hw, struct ice_fltr_info *f_info,
-		 struct ice_aqc_sw_rules_elem *s_rule, enum ice_adminq_opc opc)
+		 struct ice_sw_rule_lkup_rx_tx *s_rule,
+		 enum ice_adminq_opc opc)
 {
 	u16 vlan_id = ICE_MAX_VLAN_ID + 1;
 	u16 vlan_tpid = ETH_P_8021Q;
@@ -2388,15 +2384,14 @@ ice_fill_sw_rule(struct ice_hw *hw, struct ice_fltr_info *f_info,
 	u8 q_rgn;
 
 	if (opc == ice_aqc_opc_remove_sw_rules) {
-		s_rule->pdata.lkup_tx_rx.act = 0;
-		s_rule->pdata.lkup_tx_rx.index =
-			cpu_to_le16(f_info->fltr_rule_id);
-		s_rule->pdata.lkup_tx_rx.hdr_len = 0;
+		s_rule->act = 0;
+		s_rule->index = cpu_to_le16(f_info->fltr_rule_id);
+		s_rule->hdr_len = 0;
 		return;
 	}
 
 	eth_hdr_sz = sizeof(dummy_eth_header);
-	eth_hdr = s_rule->pdata.lkup_tx_rx.hdr;
+	eth_hdr = s_rule->hdr_data;
 
 	/* initialize the ether header with a dummy header */
 	memcpy(eth_hdr, dummy_eth_header, eth_hdr_sz);
@@ -2481,14 +2476,14 @@ ice_fill_sw_rule(struct ice_hw *hw, struct ice_fltr_info *f_info,
 		break;
 	}
 
-	s_rule->type = (f_info->flag & ICE_FLTR_RX) ?
+	s_rule->hdr.type = (f_info->flag & ICE_FLTR_RX) ?
 		cpu_to_le16(ICE_AQC_SW_RULES_T_LKUP_RX) :
 		cpu_to_le16(ICE_AQC_SW_RULES_T_LKUP_TX);
 
 	/* Recipe set depending on lookup type */
-	s_rule->pdata.lkup_tx_rx.recipe_id = cpu_to_le16(f_info->lkup_type);
-	s_rule->pdata.lkup_tx_rx.src = cpu_to_le16(f_info->src);
-	s_rule->pdata.lkup_tx_rx.act = cpu_to_le32(act);
+	s_rule->recipe_id = cpu_to_le16(f_info->lkup_type);
+	s_rule->src = cpu_to_le16(f_info->src);
+	s_rule->act = cpu_to_le32(act);
 
 	if (daddr)
 		ether_addr_copy(eth_hdr + ICE_ETH_DA_OFFSET, daddr);
@@ -2502,7 +2497,7 @@ ice_fill_sw_rule(struct ice_hw *hw, struct ice_fltr_info *f_info,
 
 	/* Create the switch rule with the final dummy Ethernet header */
 	if (opc != ice_aqc_opc_update_sw_rules)
-		s_rule->pdata.lkup_tx_rx.hdr_len = cpu_to_le16(eth_hdr_sz);
+		s_rule->hdr_len = cpu_to_le16(eth_hdr_sz);
 }
 
 /**
@@ -2519,7 +2514,8 @@ static int
 ice_add_marker_act(struct ice_hw *hw, struct ice_fltr_mgmt_list_entry *m_ent,
 		   u16 sw_marker, u16 l_id)
 {
-	struct ice_aqc_sw_rules_elem *lg_act, *rx_tx;
+	struct ice_sw_rule_lkup_rx_tx *rx_tx;
+	struct ice_sw_rule_lg_act *lg_act;
 	/* For software marker we need 3 large actions
 	 * 1. FWD action: FWD TO VSI or VSI LIST
 	 * 2. GENERIC VALUE action to hold the profile ID
@@ -2540,18 +2536,18 @@ ice_add_marker_act(struct ice_hw *hw, struct ice_fltr_mgmt_list_entry *m_ent,
 	 *    1. Large Action
 	 *    2. Look up Tx Rx
 	 */
-	lg_act_size = (u16)ICE_SW_RULE_LG_ACT_SIZE(num_lg_acts);
-	rules_size = lg_act_size + ICE_SW_RULE_RX_TX_ETH_HDR_SIZE;
+	lg_act_size = (u16)ICE_SW_RULE_LG_ACT_SIZE(lg_act, num_lg_acts);
+	rules_size = lg_act_size + ICE_SW_RULE_RX_TX_ETH_HDR_SIZE(rx_tx);
 	lg_act = devm_kzalloc(ice_hw_to_dev(hw), rules_size, GFP_KERNEL);
 	if (!lg_act)
 		return -ENOMEM;
 
-	rx_tx = (struct ice_aqc_sw_rules_elem *)((u8 *)lg_act + lg_act_size);
+	rx_tx = (typeof(rx_tx))((u8 *)lg_act + lg_act_size);
 
 	/* Fill in the first switch rule i.e. large action */
-	lg_act->type = cpu_to_le16(ICE_AQC_SW_RULES_T_LG_ACT);
-	lg_act->pdata.lg_act.index = cpu_to_le16(l_id);
-	lg_act->pdata.lg_act.size = cpu_to_le16(num_lg_acts);
+	lg_act->hdr.type = cpu_to_le16(ICE_AQC_SW_RULES_T_LG_ACT);
+	lg_act->index = cpu_to_le16(l_id);
+	lg_act->size = cpu_to_le16(num_lg_acts);
 
 	/* First action VSI forwarding or VSI list forwarding depending on how
 	 * many VSIs
@@ -2563,13 +2559,13 @@ ice_add_marker_act(struct ice_hw *hw, struct ice_fltr_mgmt_list_entry *m_ent,
 	act |= (id << ICE_LG_ACT_VSI_LIST_ID_S) & ICE_LG_ACT_VSI_LIST_ID_M;
 	if (m_ent->vsi_count > 1)
 		act |= ICE_LG_ACT_VSI_LIST;
-	lg_act->pdata.lg_act.act[0] = cpu_to_le32(act);
+	lg_act->act[0] = cpu_to_le32(act);
 
 	/* Second action descriptor type */
 	act = ICE_LG_ACT_GENERIC;
 
 	act |= (1 << ICE_LG_ACT_GENERIC_VALUE_S) & ICE_LG_ACT_GENERIC_VALUE_M;
-	lg_act->pdata.lg_act.act[1] = cpu_to_le32(act);
+	lg_act->act[1] = cpu_to_le32(act);
 
 	act = (ICE_LG_ACT_GENERIC_OFF_RX_DESC_PROF_IDX <<
 	       ICE_LG_ACT_GENERIC_OFFSET_S) & ICE_LG_ACT_GENERIC_OFFSET_M;
@@ -2579,24 +2575,22 @@ ice_add_marker_act(struct ice_hw *hw, struct ice_fltr_mgmt_list_entry *m_ent,
 	act |= (sw_marker << ICE_LG_ACT_GENERIC_VALUE_S) &
 		ICE_LG_ACT_GENERIC_VALUE_M;
 
-	lg_act->pdata.lg_act.act[2] = cpu_to_le32(act);
+	lg_act->act[2] = cpu_to_le32(act);
 
 	/* call the fill switch rule to fill the lookup Tx Rx structure */
 	ice_fill_sw_rule(hw, &m_ent->fltr_info, rx_tx,
 			 ice_aqc_opc_update_sw_rules);
 
 	/* Update the action to point to the large action ID */
-	rx_tx->pdata.lkup_tx_rx.act =
-		cpu_to_le32(ICE_SINGLE_ACT_PTR |
-			    ((l_id << ICE_SINGLE_ACT_PTR_VAL_S) &
-			     ICE_SINGLE_ACT_PTR_VAL_M));
+	rx_tx->act = cpu_to_le32(ICE_SINGLE_ACT_PTR |
+				 ((l_id << ICE_SINGLE_ACT_PTR_VAL_S) &
+				  ICE_SINGLE_ACT_PTR_VAL_M));
 
 	/* Use the filter rule ID of the previously created rule with single
 	 * act. Once the update happens, hardware will treat this as large
 	 * action
 	 */
-	rx_tx->pdata.lkup_tx_rx.index =
-		cpu_to_le16(m_ent->fltr_info.fltr_rule_id);
+	rx_tx->index = cpu_to_le16(m_ent->fltr_info.fltr_rule_id);
 
 	status = ice_aq_sw_rules(hw, lg_act, rules_size, 2,
 				 ice_aqc_opc_update_sw_rules, NULL);
@@ -2658,7 +2652,7 @@ ice_update_vsi_list_rule(struct ice_hw *hw, u16 *vsi_handle_arr, u16 num_vsi,
 			 u16 vsi_list_id, bool remove, enum ice_adminq_opc opc,
 			 enum ice_sw_lkup_type lkup_type)
 {
-	struct ice_aqc_sw_rules_elem *s_rule;
+	struct ice_sw_rule_vsi_list *s_rule;
 	u16 s_rule_size;
 	u16 rule_type;
 	int status;
@@ -2681,7 +2675,7 @@ ice_update_vsi_list_rule(struct ice_hw *hw, u16 *vsi_handle_arr, u16 num_vsi,
 	else
 		return -EINVAL;
 
-	s_rule_size = (u16)ICE_SW_RULE_VSI_LIST_SIZE(num_vsi);
+	s_rule_size = (u16)ICE_SW_RULE_VSI_LIST_SIZE(s_rule, num_vsi);
 	s_rule = devm_kzalloc(ice_hw_to_dev(hw), s_rule_size, GFP_KERNEL);
 	if (!s_rule)
 		return -ENOMEM;
@@ -2691,13 +2685,13 @@ ice_update_vsi_list_rule(struct ice_hw *hw, u16 *vsi_handle_arr, u16 num_vsi,
 			goto exit;
 		}
 		/* AQ call requires hw_vsi_id(s) */
-		s_rule->pdata.vsi_list.vsi[i] =
+		s_rule->vsi[i] =
 			cpu_to_le16(ice_get_hw_vsi_num(hw, vsi_handle_arr[i]));
 	}
 
-	s_rule->type = cpu_to_le16(rule_type);
-	s_rule->pdata.vsi_list.number_vsi = cpu_to_le16(num_vsi);
-	s_rule->pdata.vsi_list.index = cpu_to_le16(vsi_list_id);
+	s_rule->hdr.type = cpu_to_le16(rule_type);
+	s_rule->number_vsi = cpu_to_le16(num_vsi);
+	s_rule->index = cpu_to_le16(vsi_list_id);
 
 	status = ice_aq_sw_rules(hw, s_rule, s_rule_size, 1, opc, NULL);
 
@@ -2745,13 +2739,14 @@ ice_create_pkt_fwd_rule(struct ice_hw *hw,
 			struct ice_fltr_list_entry *f_entry)
 {
 	struct ice_fltr_mgmt_list_entry *fm_entry;
-	struct ice_aqc_sw_rules_elem *s_rule;
+	struct ice_sw_rule_lkup_rx_tx *s_rule;
 	enum ice_sw_lkup_type l_type;
 	struct ice_sw_recipe *recp;
 	int status;
 
 	s_rule = devm_kzalloc(ice_hw_to_dev(hw),
-			      ICE_SW_RULE_RX_TX_ETH_HDR_SIZE, GFP_KERNEL);
+			      ICE_SW_RULE_RX_TX_ETH_HDR_SIZE(s_rule),
+			      GFP_KERNEL);
 	if (!s_rule)
 		return -ENOMEM;
 	fm_entry = devm_kzalloc(ice_hw_to_dev(hw), sizeof(*fm_entry),
@@ -2772,17 +2767,16 @@ ice_create_pkt_fwd_rule(struct ice_hw *hw,
 	ice_fill_sw_rule(hw, &fm_entry->fltr_info, s_rule,
 			 ice_aqc_opc_add_sw_rules);
 
-	status = ice_aq_sw_rules(hw, s_rule, ICE_SW_RULE_RX_TX_ETH_HDR_SIZE, 1,
+	status = ice_aq_sw_rules(hw, s_rule,
+				 ICE_SW_RULE_RX_TX_ETH_HDR_SIZE(s_rule), 1,
 				 ice_aqc_opc_add_sw_rules, NULL);
 	if (status) {
 		devm_kfree(ice_hw_to_dev(hw), fm_entry);
 		goto ice_create_pkt_fwd_rule_exit;
 	}
 
-	f_entry->fltr_info.fltr_rule_id =
-		le16_to_cpu(s_rule->pdata.lkup_tx_rx.index);
-	fm_entry->fltr_info.fltr_rule_id =
-		le16_to_cpu(s_rule->pdata.lkup_tx_rx.index);
+	f_entry->fltr_info.fltr_rule_id = le16_to_cpu(s_rule->index);
+	fm_entry->fltr_info.fltr_rule_id = le16_to_cpu(s_rule->index);
 
 	/* The book keeping entries will get removed when base driver
 	 * calls remove filter AQ command
@@ -2807,20 +2801,22 @@ ice_create_pkt_fwd_rule(struct ice_hw *hw,
 static int
 ice_update_pkt_fwd_rule(struct ice_hw *hw, struct ice_fltr_info *f_info)
 {
-	struct ice_aqc_sw_rules_elem *s_rule;
+	struct ice_sw_rule_lkup_rx_tx *s_rule;
 	int status;
 
 	s_rule = devm_kzalloc(ice_hw_to_dev(hw),
-			      ICE_SW_RULE_RX_TX_ETH_HDR_SIZE, GFP_KERNEL);
+			      ICE_SW_RULE_RX_TX_ETH_HDR_SIZE(s_rule),
+			      GFP_KERNEL);
 	if (!s_rule)
 		return -ENOMEM;
 
 	ice_fill_sw_rule(hw, f_info, s_rule, ice_aqc_opc_update_sw_rules);
 
-	s_rule->pdata.lkup_tx_rx.index = cpu_to_le16(f_info->fltr_rule_id);
+	s_rule->index = cpu_to_le16(f_info->fltr_rule_id);
 
 	/* Update switch rule with new rule set to forward VSI list */
-	status = ice_aq_sw_rules(hw, s_rule, ICE_SW_RULE_RX_TX_ETH_HDR_SIZE, 1,
+	status = ice_aq_sw_rules(hw, s_rule,
+				 ICE_SW_RULE_RX_TX_ETH_HDR_SIZE(s_rule), 1,
 				 ice_aqc_opc_update_sw_rules, NULL);
 
 	devm_kfree(ice_hw_to_dev(hw), s_rule);
@@ -3104,17 +3100,17 @@ static int
 ice_remove_vsi_list_rule(struct ice_hw *hw, u16 vsi_list_id,
 			 enum ice_sw_lkup_type lkup_type)
 {
-	struct ice_aqc_sw_rules_elem *s_rule;
+	struct ice_sw_rule_vsi_list *s_rule;
 	u16 s_rule_size;
 	int status;
 
-	s_rule_size = (u16)ICE_SW_RULE_VSI_LIST_SIZE(0);
+	s_rule_size = (u16)ICE_SW_RULE_VSI_LIST_SIZE(s_rule, 0);
 	s_rule = devm_kzalloc(ice_hw_to_dev(hw), s_rule_size, GFP_KERNEL);
 	if (!s_rule)
 		return -ENOMEM;
 
-	s_rule->type = cpu_to_le16(ICE_AQC_SW_RULES_T_VSI_LIST_CLEAR);
-	s_rule->pdata.vsi_list.index = cpu_to_le16(vsi_list_id);
+	s_rule->hdr.type = cpu_to_le16(ICE_AQC_SW_RULES_T_VSI_LIST_CLEAR);
+	s_rule->index = cpu_to_le16(vsi_list_id);
 
 	/* Free the vsi_list resource that we allocated. It is assumed that the
 	 * list is empty at this point.
@@ -3274,10 +3270,10 @@ ice_remove_rule_internal(struct ice_hw *hw, u8 recp_id,
 
 	if (remove_rule) {
 		/* Remove the lookup rule */
-		struct ice_aqc_sw_rules_elem *s_rule;
+		struct ice_sw_rule_lkup_rx_tx *s_rule;
 
 		s_rule = devm_kzalloc(ice_hw_to_dev(hw),
-				      ICE_SW_RULE_RX_TX_NO_HDR_SIZE,
+				      ICE_SW_RULE_RX_TX_NO_HDR_SIZE(s_rule),
 				      GFP_KERNEL);
 		if (!s_rule) {
 			status = -ENOMEM;
@@ -3288,8 +3284,8 @@ ice_remove_rule_internal(struct ice_hw *hw, u8 recp_id,
 				 ice_aqc_opc_remove_sw_rules);
 
 		status = ice_aq_sw_rules(hw, s_rule,
-					 ICE_SW_RULE_RX_TX_NO_HDR_SIZE, 1,
-					 ice_aqc_opc_remove_sw_rules, NULL);
+					 ICE_SW_RULE_RX_TX_NO_HDR_SIZE(s_rule),
+					 1, ice_aqc_opc_remove_sw_rules, NULL);
 
 		/* Remove a book keeping from the list */
 		devm_kfree(ice_hw_to_dev(hw), s_rule);
@@ -3437,7 +3433,7 @@ bool ice_vlan_fltr_exist(struct ice_hw *hw, u16 vlan_id, u16 vsi_handle)
  */
 int ice_add_mac(struct ice_hw *hw, struct list_head *m_list)
 {
-	struct ice_aqc_sw_rules_elem *s_rule, *r_iter;
+	struct ice_sw_rule_lkup_rx_tx *s_rule, *r_iter;
 	struct ice_fltr_list_entry *m_list_itr;
 	struct list_head *rule_head;
 	u16 total_elem_left, s_rule_size;
@@ -3501,7 +3497,7 @@ int ice_add_mac(struct ice_hw *hw, struct list_head *m_list)
 	rule_head = &sw->recp_list[ICE_SW_LKUP_MAC].filt_rules;
 
 	/* Allocate switch rule buffer for the bulk update for unicast */
-	s_rule_size = ICE_SW_RULE_RX_TX_ETH_HDR_SIZE;
+	s_rule_size = ICE_SW_RULE_RX_TX_ETH_HDR_SIZE(s_rule);
 	s_rule = devm_kcalloc(ice_hw_to_dev(hw), num_unicast, s_rule_size,
 			      GFP_KERNEL);
 	if (!s_rule) {
@@ -3517,8 +3513,7 @@ int ice_add_mac(struct ice_hw *hw, struct list_head *m_list)
 		if (is_unicast_ether_addr(mac_addr)) {
 			ice_fill_sw_rule(hw, &m_list_itr->fltr_info, r_iter,
 					 ice_aqc_opc_add_sw_rules);
-			r_iter = (struct ice_aqc_sw_rules_elem *)
-				((u8 *)r_iter + s_rule_size);
+			r_iter = (typeof(s_rule))((u8 *)r_iter + s_rule_size);
 		}
 	}
 
@@ -3527,7 +3522,7 @@ int ice_add_mac(struct ice_hw *hw, struct list_head *m_list)
 	/* Call AQ switch rule in AQ_MAX chunk */
 	for (total_elem_left = num_unicast; total_elem_left > 0;
 	     total_elem_left -= elem_sent) {
-		struct ice_aqc_sw_rules_elem *entry = r_iter;
+		struct ice_sw_rule_lkup_rx_tx *entry = r_iter;
 
 		elem_sent = min_t(u8, total_elem_left,
 				  (ICE_AQ_MAX_BUF_LEN / s_rule_size));
@@ -3536,7 +3531,7 @@ int ice_add_mac(struct ice_hw *hw, struct list_head *m_list)
 					 NULL);
 		if (status)
 			goto ice_add_mac_exit;
-		r_iter = (struct ice_aqc_sw_rules_elem *)
+		r_iter = (typeof(s_rule))
 			((u8 *)r_iter + (elem_sent * s_rule_size));
 	}
 
@@ -3548,8 +3543,7 @@ int ice_add_mac(struct ice_hw *hw, struct list_head *m_list)
 		struct ice_fltr_mgmt_list_entry *fm_entry;
 
 		if (is_unicast_ether_addr(mac_addr)) {
-			f_info->fltr_rule_id =
-				le16_to_cpu(r_iter->pdata.lkup_tx_rx.index);
+			f_info->fltr_rule_id = le16_to_cpu(r_iter->index);
 			f_info->fltr_act = ICE_FWD_TO_VSI;
 			/* Create an entry to track this MAC address */
 			fm_entry = devm_kzalloc(ice_hw_to_dev(hw),
@@ -3565,8 +3559,7 @@ int ice_add_mac(struct ice_hw *hw, struct list_head *m_list)
 			 */
 
 			list_add(&fm_entry->list_entry, rule_head);
-			r_iter = (struct ice_aqc_sw_rules_elem *)
-				((u8 *)r_iter + s_rule_size);
+			r_iter = (typeof(s_rule))((u8 *)r_iter + s_rule_size);
 		}
 	}
 
@@ -3865,7 +3858,7 @@ ice_rem_adv_rule_info(struct ice_hw *hw, struct list_head *rule_head)
  */
 int ice_cfg_dflt_vsi(struct ice_hw *hw, u16 vsi_handle, bool set, u8 direction)
 {
-	struct ice_aqc_sw_rules_elem *s_rule;
+	struct ice_sw_rule_lkup_rx_tx *s_rule;
 	struct ice_fltr_info f_info;
 	enum ice_adminq_opc opcode;
 	u16 s_rule_size;
@@ -3876,8 +3869,8 @@ int ice_cfg_dflt_vsi(struct ice_hw *hw, u16 vsi_handle, bool set, u8 direction)
 		return -EINVAL;
 	hw_vsi_id = ice_get_hw_vsi_num(hw, vsi_handle);
 
-	s_rule_size = set ? ICE_SW_RULE_RX_TX_ETH_HDR_SIZE :
-		ICE_SW_RULE_RX_TX_NO_HDR_SIZE;
+	s_rule_size = set ? ICE_SW_RULE_RX_TX_ETH_HDR_SIZE(s_rule) :
+			    ICE_SW_RULE_RX_TX_NO_HDR_SIZE(s_rule);
 
 	s_rule = devm_kzalloc(ice_hw_to_dev(hw), s_rule_size, GFP_KERNEL);
 	if (!s_rule)
@@ -3915,7 +3908,7 @@ int ice_cfg_dflt_vsi(struct ice_hw *hw, u16 vsi_handle, bool set, u8 direction)
 	if (status || !(f_info.flag & ICE_FLTR_TX_RX))
 		goto out;
 	if (set) {
-		u16 index = le16_to_cpu(s_rule->pdata.lkup_tx_rx.index);
+		u16 index = le16_to_cpu(s_rule->index);
 
 		if (f_info.flag & ICE_FLTR_TX) {
 			hw->port_info->dflt_tx_vsi_num = hw_vsi_id;
@@ -5641,7 +5634,7 @@ ice_find_dummy_packet(struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
  */
 static int
 ice_fill_adv_dummy_packet(struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
-			  struct ice_aqc_sw_rules_elem *s_rule,
+			  struct ice_sw_rule_lkup_rx_tx *s_rule,
 			  const struct ice_dummy_pkt_profile *profile)
 {
 	u8 *pkt;
@@ -5650,7 +5643,7 @@ ice_fill_adv_dummy_packet(struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
 	/* Start with a packet with a pre-defined/dummy content. Then, fill
 	 * in the header values to be looked up or matched.
 	 */
-	pkt = s_rule->pdata.lkup_tx_rx.hdr;
+	pkt = s_rule->hdr_data;
 
 	memcpy(pkt, profile->pkt, profile->pkt_len);
 
@@ -5740,7 +5733,7 @@ ice_fill_adv_dummy_packet(struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
 		}
 	}
 
-	s_rule->pdata.lkup_tx_rx.hdr_len = cpu_to_le16(profile->pkt_len);
+	s_rule->hdr_len = cpu_to_le16(profile->pkt_len);
 
 	return 0;
 }
@@ -5963,7 +5956,7 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 		 struct ice_rule_query_data *added_entry)
 {
 	struct ice_adv_fltr_mgmt_list_entry *m_entry, *adv_fltr = NULL;
-	struct ice_aqc_sw_rules_elem *s_rule = NULL;
+	struct ice_sw_rule_lkup_rx_tx *s_rule = NULL;
 	const struct ice_dummy_pkt_profile *profile;
 	u16 rid = 0, i, rule_buf_sz, vsi_handle;
 	struct list_head *rule_head;
@@ -6040,7 +6033,7 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 		}
 		return status;
 	}
-	rule_buf_sz = ICE_SW_RULE_RX_TX_NO_HDR_SIZE + profile->pkt_len;
+	rule_buf_sz = ICE_SW_RULE_RX_TX_HDR_SIZE(s_rule, profile->pkt_len);
 	s_rule = kzalloc(rule_buf_sz, GFP_KERNEL);
 	if (!s_rule)
 		return -ENOMEM;
@@ -6089,16 +6082,15 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 	 * by caller)
 	 */
 	if (rinfo->rx) {
-		s_rule->type = cpu_to_le16(ICE_AQC_SW_RULES_T_LKUP_RX);
-		s_rule->pdata.lkup_tx_rx.src =
-			cpu_to_le16(hw->port_info->lport);
+		s_rule->hdr.type = cpu_to_le16(ICE_AQC_SW_RULES_T_LKUP_RX);
+		s_rule->src = cpu_to_le16(hw->port_info->lport);
 	} else {
-		s_rule->type = cpu_to_le16(ICE_AQC_SW_RULES_T_LKUP_TX);
-		s_rule->pdata.lkup_tx_rx.src = cpu_to_le16(rinfo->sw_act.src);
+		s_rule->hdr.type = cpu_to_le16(ICE_AQC_SW_RULES_T_LKUP_TX);
+		s_rule->src = cpu_to_le16(rinfo->sw_act.src);
 	}
 
-	s_rule->pdata.lkup_tx_rx.recipe_id = cpu_to_le16(rid);
-	s_rule->pdata.lkup_tx_rx.act = cpu_to_le32(act);
+	s_rule->recipe_id = cpu_to_le16(rid);
+	s_rule->act = cpu_to_le32(act);
 
 	status = ice_fill_adv_dummy_packet(lkups, lkups_cnt, s_rule, profile);
 	if (status)
@@ -6107,7 +6099,7 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 	if (rinfo->tun_type != ICE_NON_TUN &&
 	    rinfo->tun_type != ICE_SW_TUN_AND_NON_TUN) {
 		status = ice_fill_adv_packet_tun(hw, rinfo->tun_type,
-						 s_rule->pdata.lkup_tx_rx.hdr,
+						 s_rule->hdr_data,
 						 profile->offsets);
 		if (status)
 			goto err_ice_add_adv_rule;
@@ -6135,8 +6127,7 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 
 	adv_fltr->lkups_cnt = lkups_cnt;
 	adv_fltr->rule_info = *rinfo;
-	adv_fltr->rule_info.fltr_rule_id =
-		le16_to_cpu(s_rule->pdata.lkup_tx_rx.index);
+	adv_fltr->rule_info.fltr_rule_id = le16_to_cpu(s_rule->index);
 	sw = hw->switch_info;
 	sw->recp_list[rid].adv_rule = true;
 	rule_head = &sw->recp_list[rid].filt_rules;
@@ -6384,17 +6375,16 @@ ice_rem_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 	}
 	mutex_unlock(rule_lock);
 	if (remove_rule) {
-		struct ice_aqc_sw_rules_elem *s_rule;
+		struct ice_sw_rule_lkup_rx_tx *s_rule;
 		u16 rule_buf_sz;
 
-		rule_buf_sz = ICE_SW_RULE_RX_TX_NO_HDR_SIZE;
+		rule_buf_sz = ICE_SW_RULE_RX_TX_NO_HDR_SIZE(s_rule);
 		s_rule = kzalloc(rule_buf_sz, GFP_KERNEL);
 		if (!s_rule)
 			return -ENOMEM;
-		s_rule->pdata.lkup_tx_rx.act = 0;
-		s_rule->pdata.lkup_tx_rx.index =
-			cpu_to_le16(list_elem->rule_info.fltr_rule_id);
-		s_rule->pdata.lkup_tx_rx.hdr_len = 0;
+		s_rule->act = 0;
+		s_rule->index = cpu_to_le16(list_elem->rule_info.fltr_rule_id);
+		s_rule->hdr_len = 0;
 		status = ice_aq_sw_rules(hw, (struct ice_aqc_sw_rules *)s_rule,
 					 rule_buf_sz, 1,
 					 ice_aqc_opc_remove_sw_rules, NULL);
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.h b/drivers/net/ethernet/intel/ice/ice_switch.h
index ecac75e71395..eb641e5512d2 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.h
+++ b/drivers/net/ethernet/intel/ice/ice_switch.h
@@ -23,9 +23,6 @@
 #define ICE_PROFID_IPV6_GTPU_TEID			46
 #define ICE_PROFID_IPV6_GTPU_IPV6_TCP_INNER		70
 
-#define ICE_SW_RULE_RX_TX_NO_HDR_SIZE \
-	(offsetof(struct ice_aqc_sw_rules_elem, pdata.lkup_tx_rx.hdr))
-
 /* VSI context structure for add/get/update/free operations */
 struct ice_vsi_ctx {
 	u16 vsi_num;
-- 
2.36.1

