Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69A1A5F19EA
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 07:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiJAFAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 01:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiJAFAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 01:00:34 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE8665839
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 22:00:29 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2912qlxg009288;
        Fri, 30 Sep 2022 22:00:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=QVeT4Qk9othf9LUTwlraq04kgkDvzBx432qCt+24F5Q=;
 b=ZbbvP8PIpKDuG7psL7pgRcaMMw2jtzwRusjblA1eFBeZH5rr1ahJX1izynJ23/JrmkNO
 C1m6EdqGfFfUGLor59KVx+ieLv5sSeLGqWZeLUpFVjmzzi7d0fZ1Wgp4ZrBZRaUa0PeX
 /C1Dg2lmOZgrZcAIKdDmqcgiplQ5kykT17EUht5N7ioa4NXp3pDK6E4mtD27VeXpElKB
 kFPrRXpZJZPReu2q8bqwALpb5dUZTJLUnQAuSMTi9TTg0Vdb1zlmVCbvmoOc59bhKiWg
 jyTJzmkCezaZe4k1DIjJceTG88c3EZ14eMrKw6IBtVEYD3II0aaOg3LkqkPZAaiACdHA mA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3jx18bamb1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 30 Sep 2022 22:00:20 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 30 Sep
 2022 22:00:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 30 Sep 2022 22:00:19 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 386823F70A7;
        Fri, 30 Sep 2022 22:00:14 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <naveenm@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Vamsi Attunuru <vattunuru@marvell.com>,
        "Subbaraya Sundeep" <sbhatta@marvell.com>
Subject: [net-next PATCH v3 3/8] octeontx2-af: cn10k: mcs: Manage the MCS block hardware resources
Date:   Sat, 1 Oct 2022 10:29:44 +0530
Message-ID: <1664600389-5758-4-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1664600389-5758-1-git-send-email-sbhatta@marvell.com>
References: <1664600389-5758-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: YSIIRgumrGZwD6h_WnADejS11avXHS1l
X-Proofpoint-GUID: YSIIRgumrGZwD6h_WnADejS11avXHS1l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-01_03,2022-09-29_03,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

To establish a macsec connection association netdev driver
needs hardware resources like SecY, TCAM flows, SCs and SAs.
This patch manages allocating, freeing and configuring those
resources. AF consumers can request resources and configure them
via these mailbox messages. AF can allocate until it runs out of
hardware resources.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Vamsi Attunuru <vattunuru@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   | 211 ++++++++++
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c    | 447 +++++++++++++++++++++
 drivers/net/ethernet/marvell/octeontx2/af/mcs.h    |  59 ++-
 .../ethernet/marvell/octeontx2/af/mcs_cnf10kb.c    |  55 +++
 .../net/ethernet/marvell/octeontx2/af/mcs_reg.h    | 385 ++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c | 374 +++++++++++++++++
 6 files changed, 1530 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 207cd4f..3213b1512 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -295,10 +295,38 @@ M(NIX_BANDPROF_FREE,	0x801e, nix_bandprof_free, nix_bandprof_free_req,   \
 M(NIX_BANDPROF_GET_HWINFO, 0x801f, nix_bandprof_get_hwinfo, msg_req,		\
 				nix_bandprof_get_hwinfo_rsp)		    \
 /* MCS mbox IDs (range 0xA000 - 0xBFFF) */					\
+M(MCS_ALLOC_RESOURCES,	0xa000, mcs_alloc_resources, mcs_alloc_rsrc_req,	\
+				mcs_alloc_rsrc_rsp)				\
+M(MCS_FREE_RESOURCES,	0xa001, mcs_free_resources, mcs_free_rsrc_req, msg_rsp) \
+M(MCS_FLOWID_ENTRY_WRITE, 0xa002, mcs_flowid_entry_write, mcs_flowid_entry_write_req,	\
+				msg_rsp)					\
+M(MCS_SECY_PLCY_WRITE,	0xa003, mcs_secy_plcy_write, mcs_secy_plcy_write_req,	\
+				msg_rsp)					\
+M(MCS_RX_SC_CAM_WRITE,	0xa004, mcs_rx_sc_cam_write, mcs_rx_sc_cam_write_req,	\
+				msg_rsp)					\
+M(MCS_SA_PLCY_WRITE,	0xa005, mcs_sa_plcy_write, mcs_sa_plcy_write_req,	\
+				msg_rsp)					\
+M(MCS_TX_SC_SA_MAP_WRITE, 0xa006, mcs_tx_sc_sa_map_write, mcs_tx_sc_sa_map,	\
+				  msg_rsp)					\
+M(MCS_RX_SC_SA_MAP_WRITE, 0xa007, mcs_rx_sc_sa_map_write, mcs_rx_sc_sa_map,	\
+				  msg_rsp)					\
+M(MCS_FLOWID_ENA_ENTRY,	0xa008, mcs_flowid_ena_entry, mcs_flowid_ena_dis_entry,	\
+				msg_rsp)					\
+M(MCS_PN_TABLE_WRITE,	0xa009, mcs_pn_table_write, mcs_pn_table_write_req,	\
+				msg_rsp)					\
 M(MCS_SET_ACTIVE_LMAC,	0xa00a,	mcs_set_active_lmac, mcs_set_active_lmac,	\
 				msg_rsp)					\
 M(MCS_GET_HW_INFO,	0xa00b,	mcs_get_hw_info, msg_req, mcs_hw_info)		\
 M(MCS_SET_LMAC_MODE,	0xa013, mcs_set_lmac_mode, mcs_set_lmac_mode, msg_rsp)	\
+M(MCS_SET_PN_THRESHOLD, 0xa014, mcs_set_pn_threshold, mcs_set_pn_threshold,	\
+				msg_rsp)					\
+M(MCS_ALLOC_CTRL_PKT_RULE, 0xa015, mcs_alloc_ctrl_pkt_rule,			\
+				   mcs_alloc_ctrl_pkt_rule_req,			\
+				   mcs_alloc_ctrl_pkt_rule_rsp)			\
+M(MCS_FREE_CTRL_PKT_RULE, 0xa016, mcs_free_ctrl_pkt_rule,			\
+				  mcs_free_ctrl_pkt_rule_req, msg_rsp)		\
+M(MCS_CTRL_PKT_RULE_WRITE, 0xa017, mcs_ctrl_pkt_rule_write,			\
+				   mcs_ctrl_pkt_rule_write_req, msg_rsp)	\
 M(MCS_PORT_RESET,	0xa018, mcs_port_reset, mcs_port_reset_req, msg_rsp)	\
 M(MCS_PORT_CFG_SET,	0xa019, mcs_port_cfg_set, mcs_port_cfg_set_req, msg_rsp)\
 M(MCS_PORT_CFG_GET,	0xa020, mcs_port_cfg_get, mcs_port_cfg_get_req,		\
@@ -1674,6 +1702,133 @@ enum mcs_direction {
 	MCS_TX,
 };
 
+enum mcs_rsrc_type {
+	MCS_RSRC_TYPE_FLOWID,
+	MCS_RSRC_TYPE_SECY,
+	MCS_RSRC_TYPE_SC,
+	MCS_RSRC_TYPE_SA,
+};
+
+struct mcs_alloc_rsrc_req {
+	struct mbox_msghdr hdr;
+	u8 rsrc_type;
+	u8 rsrc_cnt;	/* Resources count */
+	u8 mcs_id;	/* MCS block ID	*/
+	u8 dir;		/* Macsec ingress or egress side */
+	u8 all;		/* Allocate all resource type one each */
+	u64 rsvd;
+};
+
+struct mcs_alloc_rsrc_rsp {
+	struct mbox_msghdr hdr;
+	u8 flow_ids[128];	/* Index of reserved entries */
+	u8 secy_ids[128];
+	u8 sc_ids[128];
+	u8 sa_ids[256];
+	u8 rsrc_type;
+	u8 rsrc_cnt;		/* No of entries reserved */
+	u8 mcs_id;
+	u8 dir;
+	u8 all;
+	u8 rsvd[256];		/* reserved fields for future expansion */
+};
+
+struct mcs_free_rsrc_req {
+	struct mbox_msghdr hdr;
+	u8 rsrc_id;		/* Index of the entry to be freed */
+	u8 rsrc_type;
+	u8 mcs_id;
+	u8 dir;
+	u8 all;			/* Free all the cam resources */
+	u64 rsvd;
+};
+
+struct mcs_flowid_entry_write_req {
+	struct mbox_msghdr hdr;
+	u64 data[4];
+	u64 mask[4];
+	u64 sci;	/* CNF10K-B for tx_secy_mem_map */
+	u8 flow_id;
+	u8 secy_id;	/* secyid for which flowid is mapped */
+	u8 sc_id;	/* Valid if dir = MCS_TX, SC_CAM id mapped to flowid */
+	u8 ena;		/* Enable tcam entry */
+	u8 ctrl_pkt;
+	u8 mcs_id;
+	u8 dir;
+	u64 rsvd;
+};
+
+struct mcs_secy_plcy_write_req {
+	struct mbox_msghdr hdr;
+	u64 plcy;
+	u8 secy_id;
+	u8 mcs_id;
+	u8 dir;
+	u64 rsvd;
+};
+
+/* RX SC_CAM mapping */
+struct mcs_rx_sc_cam_write_req {
+	struct mbox_msghdr hdr;
+	u64 sci;	/* SCI */
+	u64 secy_id;	/* secy index mapped to SC */
+	u8 sc_id;	/* SC CAM entry index */
+	u8 mcs_id;
+	u64 rsvd;
+};
+
+struct mcs_sa_plcy_write_req {
+	struct mbox_msghdr hdr;
+	u64 plcy[2][9];		/* Support 2 SA policy */
+	u8 sa_index[2];
+	u8 sa_cnt;
+	u8 mcs_id;
+	u8 dir;
+	u64 rsvd;
+};
+
+struct mcs_tx_sc_sa_map {
+	struct mbox_msghdr hdr;
+	u8 sa_index0;
+	u8 sa_index1;
+	u8 rekey_ena;
+	u8 sa_index0_vld;
+	u8 sa_index1_vld;
+	u8 tx_sa_active;
+	u64 sectag_sci;
+	u8 sc_id;	/* used as index for SA_MEM_MAP */
+	u8 mcs_id;
+	u64 rsvd;
+};
+
+struct mcs_rx_sc_sa_map {
+	struct mbox_msghdr hdr;
+	u8 sa_index;
+	u8 sa_in_use;
+	u8 sc_id;
+	u8 an;		/* value range 0-3, sc_id + an used as index SA_MEM_MAP */
+	u8 mcs_id;
+	u64 rsvd;
+};
+
+struct mcs_flowid_ena_dis_entry {
+	struct mbox_msghdr hdr;
+	u8 flow_id;
+	u8 ena;
+	u8 mcs_id;
+	u8 dir;
+	u64 rsvd;
+};
+
+struct mcs_pn_table_write_req {
+	struct mbox_msghdr hdr;
+	u64 next_pn;
+	u8 pn_id;
+	u8 mcs_id;
+	u8 dir;
+	u64 rsvd;
+};
+
 struct mcs_hw_info {
 	struct mbox_msghdr hdr;
 	u8 num_mcs_blks;	/* Number of MCS blocks */
@@ -1762,4 +1917,60 @@ enum mcs_af_status {
 	MCS_AF_ERR_NOT_MAPPED           = -1202,
 };
 
+struct mcs_set_pn_threshold {
+	struct mbox_msghdr hdr;
+	u64 threshold;
+	u8 xpn; /* '1' for setting xpn threshold */
+	u8 mcs_id;
+	u8 dir;
+	u64 rsvd;
+};
+
+enum mcs_ctrl_pkt_rulew_type {
+	MCS_CTRL_PKT_RULE_TYPE_ETH,
+	MCS_CTRL_PKT_RULE_TYPE_DA,
+	MCS_CTRL_PKT_RULE_TYPE_RANGE,
+	MCS_CTRL_PKT_RULE_TYPE_COMBO,
+	MCS_CTRL_PKT_RULE_TYPE_MAC,
+};
+
+struct mcs_alloc_ctrl_pkt_rule_req {
+	struct mbox_msghdr hdr;
+	u8 rule_type;
+	u8 mcs_id;	/* MCS block ID	*/
+	u8 dir;		/* Macsec ingress or egress side */
+	u64 rsvd;
+};
+
+struct mcs_alloc_ctrl_pkt_rule_rsp {
+	struct mbox_msghdr hdr;
+	u8 rule_idx;
+	u8 rule_type;
+	u8 mcs_id;
+	u8 dir;
+	u64 rsvd;
+};
+
+struct mcs_free_ctrl_pkt_rule_req {
+	struct mbox_msghdr hdr;
+	u8 rule_idx;
+	u8 rule_type;
+	u8 mcs_id;
+	u8 dir;
+	u8 all;
+	u64 rsvd;
+};
+
+struct mcs_ctrl_pkt_rule_write_req {
+	struct mbox_msghdr hdr;
+	u64 data0;
+	u64 data1;
+	u64 data2;
+	u8 rule_idx;
+	u8 rule_type;
+	u8 mcs_id;
+	u8 dir;
+	u64 rsvd;
+};
+
 #endif /* MBOX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
index 555f3b2..2f48fb9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
@@ -24,6 +24,429 @@ static const struct pci_device_id mcs_id_table[] = {
 
 static LIST_HEAD(mcs_list);
 
+void mcs_pn_table_write(struct mcs *mcs, u8 pn_id, u64 next_pn, u8 dir)
+{
+	u64 reg;
+
+	if (dir == MCS_RX)
+		reg = MCSX_CPM_RX_SLAVE_SA_PN_TABLE_MEMX(pn_id);
+	else
+		reg = MCSX_CPM_TX_SLAVE_SA_PN_TABLE_MEMX(pn_id);
+	mcs_reg_write(mcs, reg, next_pn);
+}
+
+void cn10kb_mcs_tx_sa_mem_map_write(struct mcs *mcs, struct mcs_tx_sc_sa_map *map)
+{
+	u64 reg, val;
+
+	val = (map->sa_index0 & 0xFF) |
+	      (map->sa_index1 & 0xFF) << 9 |
+	      (map->rekey_ena & 0x1) << 18 |
+	      (map->sa_index0_vld & 0x1) << 19 |
+	      (map->sa_index1_vld & 0x1) << 20 |
+	      (map->tx_sa_active & 0x1) << 21 |
+	      map->sectag_sci << 22;
+	reg = MCSX_CPM_TX_SLAVE_SA_MAP_MEM_0X(map->sc_id);
+	mcs_reg_write(mcs, reg, val);
+
+	val = map->sectag_sci >> 42;
+	reg = MCSX_CPM_TX_SLAVE_SA_MAP_MEM_1X(map->sc_id);
+	mcs_reg_write(mcs, reg, val);
+}
+
+void cn10kb_mcs_rx_sa_mem_map_write(struct mcs *mcs, struct mcs_rx_sc_sa_map *map)
+{
+	u64 val, reg;
+
+	val = (map->sa_index & 0xFF) | map->sa_in_use << 9;
+
+	reg = MCSX_CPM_RX_SLAVE_SA_MAP_MEMX((4 * map->sc_id) + map->an);
+	mcs_reg_write(mcs, reg, val);
+}
+
+void mcs_sa_plcy_write(struct mcs *mcs, u64 *plcy, int sa_id, int dir)
+{
+	int reg_id;
+	u64 reg;
+
+	if (dir == MCS_RX) {
+		for (reg_id = 0; reg_id < 8; reg_id++) {
+			reg =  MCSX_CPM_RX_SLAVE_SA_PLCY_MEMX(reg_id, sa_id);
+			mcs_reg_write(mcs, reg, plcy[reg_id]);
+		}
+	} else {
+		for (reg_id = 0; reg_id < 9; reg_id++) {
+			reg =  MCSX_CPM_TX_SLAVE_SA_PLCY_MEMX(reg_id, sa_id);
+			mcs_reg_write(mcs, reg, plcy[reg_id]);
+		}
+	}
+}
+
+void mcs_ena_dis_sc_cam_entry(struct mcs *mcs, int sc_id, int ena)
+{
+	u64 reg, val;
+
+	reg = MCSX_CPM_RX_SLAVE_SC_CAM_ENA(0);
+	if (sc_id > 63)
+		reg = MCSX_CPM_RX_SLAVE_SC_CAM_ENA(1);
+
+	if (ena)
+		val = mcs_reg_read(mcs, reg) | BIT_ULL(sc_id);
+	else
+		val = mcs_reg_read(mcs, reg) & ~BIT_ULL(sc_id);
+
+	mcs_reg_write(mcs, reg, val);
+}
+
+void mcs_rx_sc_cam_write(struct mcs *mcs, u64 sci, u64 secy, int sc_id)
+{
+	mcs_reg_write(mcs, MCSX_CPM_RX_SLAVE_SC_CAMX(0, sc_id), sci);
+	mcs_reg_write(mcs, MCSX_CPM_RX_SLAVE_SC_CAMX(1, sc_id), secy);
+	/* Enable SC CAM */
+	mcs_ena_dis_sc_cam_entry(mcs, sc_id, true);
+}
+
+void mcs_secy_plcy_write(struct mcs *mcs, u64 plcy, int secy_id, int dir)
+{
+	u64 reg;
+
+	if (dir == MCS_RX)
+		reg = MCSX_CPM_RX_SLAVE_SECY_PLCY_MEM_0X(secy_id);
+	else
+		reg = MCSX_CPM_TX_SLAVE_SECY_PLCY_MEMX(secy_id);
+
+	mcs_reg_write(mcs, reg, plcy);
+
+	if (mcs->hw->mcs_blks == 1 && dir == MCS_RX)
+		mcs_reg_write(mcs, MCSX_CPM_RX_SLAVE_SECY_PLCY_MEM_1X(secy_id), 0x0ull);
+}
+
+void cn10kb_mcs_flowid_secy_map(struct mcs *mcs, struct secy_mem_map *map, int dir)
+{
+	u64 reg, val;
+
+	val = (map->secy & 0x7F) | (map->ctrl_pkt & 0x1) << 8;
+	if (dir == MCS_RX) {
+		reg = MCSX_CPM_RX_SLAVE_SECY_MAP_MEMX(map->flow_id);
+	} else {
+		val |= (map->sc & 0x7F) << 9;
+		reg = MCSX_CPM_TX_SLAVE_SECY_MAP_MEM_0X(map->flow_id);
+	}
+
+	mcs_reg_write(mcs, reg, val);
+}
+
+void mcs_ena_dis_flowid_entry(struct mcs *mcs, int flow_id, int dir, int ena)
+{
+	u64 reg, val;
+
+	if (dir == MCS_RX) {
+		reg = MCSX_CPM_RX_SLAVE_FLOWID_TCAM_ENA_0;
+		if (flow_id > 63)
+			reg = MCSX_CPM_RX_SLAVE_FLOWID_TCAM_ENA_1;
+	} else {
+		reg = MCSX_CPM_TX_SLAVE_FLOWID_TCAM_ENA_0;
+		if (flow_id > 63)
+			reg = MCSX_CPM_TX_SLAVE_FLOWID_TCAM_ENA_1;
+	}
+
+	/* Enable/Disable the tcam entry */
+	if (ena)
+		val = mcs_reg_read(mcs, reg) | BIT_ULL(flow_id);
+	else
+		val = mcs_reg_read(mcs, reg) & ~BIT_ULL(flow_id);
+
+	mcs_reg_write(mcs, reg, val);
+}
+
+void mcs_flowid_entry_write(struct mcs *mcs, u64 *data, u64 *mask, int flow_id, int dir)
+{
+	int reg_id;
+	u64 reg;
+
+	if (dir == MCS_RX) {
+		for (reg_id = 0; reg_id < 4; reg_id++) {
+			reg = MCSX_CPM_RX_SLAVE_FLOWID_TCAM_DATAX(reg_id, flow_id);
+			mcs_reg_write(mcs, reg, data[reg_id]);
+			reg = MCSX_CPM_RX_SLAVE_FLOWID_TCAM_MASKX(reg_id, flow_id);
+			mcs_reg_write(mcs, reg, mask[reg_id]);
+		}
+	} else {
+		for (reg_id = 0; reg_id < 4; reg_id++) {
+			reg = MCSX_CPM_TX_SLAVE_FLOWID_TCAM_DATAX(reg_id, flow_id);
+			mcs_reg_write(mcs, reg, data[reg_id]);
+			reg = MCSX_CPM_TX_SLAVE_FLOWID_TCAM_MASKX(reg_id, flow_id);
+			mcs_reg_write(mcs, reg, mask[reg_id]);
+		}
+	}
+}
+
+void mcs_clear_secy_plcy(struct mcs *mcs, int secy_id, int dir)
+{
+	struct mcs_rsrc_map *map;
+	int flow_id;
+
+	if (dir == MCS_RX)
+		map = &mcs->rx;
+	else
+		map = &mcs->tx;
+
+	/* Clear secy memory to zero */
+	mcs_secy_plcy_write(mcs, 0, secy_id, dir);
+
+	/* Disable the tcam entry using this secy */
+	for (flow_id = 0; flow_id < map->flow_ids.max; flow_id++) {
+		if (map->flowid2secy_map[flow_id] != secy_id)
+			continue;
+		mcs_ena_dis_flowid_entry(mcs, flow_id, dir, false);
+	}
+}
+
+int mcs_alloc_ctrlpktrule(struct rsrc_bmap *rsrc, u16 *pf_map, u16 offset, u16 pcifunc)
+{
+	int rsrc_id;
+
+	if (!rsrc->bmap)
+		return -EINVAL;
+
+	rsrc_id = bitmap_find_next_zero_area(rsrc->bmap, rsrc->max, offset, 1, 0);
+	if (rsrc_id >= rsrc->max)
+		return -ENOSPC;
+
+	bitmap_set(rsrc->bmap, rsrc_id, 1);
+	pf_map[rsrc_id] = pcifunc;
+
+	return rsrc_id;
+}
+
+int mcs_free_ctrlpktrule(struct mcs *mcs, struct mcs_free_ctrl_pkt_rule_req *req)
+{
+	u16 pcifunc = req->hdr.pcifunc;
+	struct mcs_rsrc_map *map;
+	u64 dis, reg;
+	int id, rc;
+
+	reg = (req->dir == MCS_RX) ? MCSX_PEX_RX_SLAVE_RULE_ENABLE : MCSX_PEX_TX_SLAVE_RULE_ENABLE;
+	map = (req->dir == MCS_RX) ? &mcs->rx : &mcs->tx;
+
+	if (req->all) {
+		for (id = 0; id < map->ctrlpktrule.max; id++) {
+			if (map->ctrlpktrule2pf_map[id] != pcifunc)
+				continue;
+			mcs_free_rsrc(&map->ctrlpktrule, map->ctrlpktrule2pf_map, id, pcifunc);
+			dis = mcs_reg_read(mcs, reg);
+			dis &= ~BIT_ULL(id);
+			mcs_reg_write(mcs, reg, dis);
+		}
+		return 0;
+	}
+
+	rc = mcs_free_rsrc(&map->ctrlpktrule, map->ctrlpktrule2pf_map, req->rule_idx, pcifunc);
+	dis = mcs_reg_read(mcs, reg);
+	dis &= ~BIT_ULL(req->rule_idx);
+	mcs_reg_write(mcs, reg, dis);
+
+	return rc;
+}
+
+int mcs_ctrlpktrule_write(struct mcs *mcs, struct mcs_ctrl_pkt_rule_write_req *req)
+{
+	u64 reg, enb;
+	u64 idx;
+
+	switch (req->rule_type) {
+	case MCS_CTRL_PKT_RULE_TYPE_ETH:
+		req->data0 &= GENMASK(15, 0);
+		if (req->data0 != ETH_P_PAE)
+			return -EINVAL;
+
+		idx = req->rule_idx - MCS_CTRLPKT_ETYPE_RULE_OFFSET;
+		reg = (req->dir == MCS_RX) ? MCSX_PEX_RX_SLAVE_RULE_ETYPE_CFGX(idx) :
+		      MCSX_PEX_TX_SLAVE_RULE_ETYPE_CFGX(idx);
+
+		mcs_reg_write(mcs, reg, req->data0);
+		break;
+	case MCS_CTRL_PKT_RULE_TYPE_DA:
+		if (!(req->data0 & BIT_ULL(40)))
+			return -EINVAL;
+
+		idx = req->rule_idx - MCS_CTRLPKT_DA_RULE_OFFSET;
+		reg = (req->dir == MCS_RX) ? MCSX_PEX_RX_SLAVE_RULE_DAX(idx) :
+		      MCSX_PEX_TX_SLAVE_RULE_DAX(idx);
+
+		mcs_reg_write(mcs, reg, req->data0 & GENMASK_ULL(47, 0));
+		break;
+	case MCS_CTRL_PKT_RULE_TYPE_RANGE:
+		if (!(req->data0 & BIT_ULL(40)) || !(req->data1 & BIT_ULL(40)))
+			return -EINVAL;
+
+		idx = req->rule_idx - MCS_CTRLPKT_DA_RANGE_RULE_OFFSET;
+		if (req->dir == MCS_RX) {
+			reg = MCSX_PEX_RX_SLAVE_RULE_DA_RANGE_MINX(idx);
+			mcs_reg_write(mcs, reg, req->data0 & GENMASK_ULL(47, 0));
+			reg = MCSX_PEX_RX_SLAVE_RULE_DA_RANGE_MAXX(idx);
+			mcs_reg_write(mcs, reg, req->data1 & GENMASK_ULL(47, 0));
+		} else {
+			reg = MCSX_PEX_TX_SLAVE_RULE_DA_RANGE_MINX(idx);
+			mcs_reg_write(mcs, reg, req->data0 & GENMASK_ULL(47, 0));
+			reg = MCSX_PEX_TX_SLAVE_RULE_DA_RANGE_MAXX(idx);
+			mcs_reg_write(mcs, reg, req->data1 & GENMASK_ULL(47, 0));
+		}
+		break;
+	case MCS_CTRL_PKT_RULE_TYPE_COMBO:
+		req->data2 &= GENMASK(15, 0);
+		if (req->data2 != ETH_P_PAE || !(req->data0 & BIT_ULL(40)) ||
+		    !(req->data1 & BIT_ULL(40)))
+			return -EINVAL;
+
+		idx = req->rule_idx - MCS_CTRLPKT_COMBO_RULE_OFFSET;
+		if (req->dir == MCS_RX) {
+			reg = MCSX_PEX_RX_SLAVE_RULE_COMBO_MINX(idx);
+			mcs_reg_write(mcs, reg, req->data0 & GENMASK_ULL(47, 0));
+			reg = MCSX_PEX_RX_SLAVE_RULE_COMBO_MAXX(idx);
+			mcs_reg_write(mcs, reg, req->data1 & GENMASK_ULL(47, 0));
+			reg = MCSX_PEX_RX_SLAVE_RULE_COMBO_ETX(idx);
+			mcs_reg_write(mcs, reg, req->data2);
+		} else {
+			reg = MCSX_PEX_TX_SLAVE_RULE_COMBO_MINX(idx);
+			mcs_reg_write(mcs, reg, req->data0 & GENMASK_ULL(47, 0));
+			reg = MCSX_PEX_TX_SLAVE_RULE_COMBO_MAXX(idx);
+			mcs_reg_write(mcs, reg, req->data1 & GENMASK_ULL(47, 0));
+			reg = MCSX_PEX_TX_SLAVE_RULE_COMBO_ETX(idx);
+			mcs_reg_write(mcs, reg, req->data2);
+		}
+		break;
+	case MCS_CTRL_PKT_RULE_TYPE_MAC:
+		if (!(req->data0 & BIT_ULL(40)))
+			return -EINVAL;
+
+		idx = req->rule_idx - MCS_CTRLPKT_MAC_EN_RULE_OFFSET;
+		reg = (req->dir == MCS_RX) ? MCSX_PEX_RX_SLAVE_RULE_MAC :
+		      MCSX_PEX_TX_SLAVE_RULE_MAC;
+
+		mcs_reg_write(mcs, reg, req->data0 & GENMASK_ULL(47, 0));
+		break;
+	}
+
+	reg = (req->dir == MCS_RX) ? MCSX_PEX_RX_SLAVE_RULE_ENABLE : MCSX_PEX_TX_SLAVE_RULE_ENABLE;
+
+	enb = mcs_reg_read(mcs, reg);
+	enb |= BIT_ULL(req->rule_idx);
+	mcs_reg_write(mcs, reg, enb);
+
+	return 0;
+}
+
+int mcs_free_rsrc(struct rsrc_bmap *rsrc, u16 *pf_map, int rsrc_id, u16 pcifunc)
+{
+	/* Check if the rsrc_id is mapped to PF/VF */
+	if (pf_map[rsrc_id] != pcifunc)
+		return -EINVAL;
+
+	rvu_free_rsrc(rsrc, rsrc_id);
+	pf_map[rsrc_id] = 0;
+	return 0;
+}
+
+/* Free all the cam resources mapped to pf */
+int mcs_free_all_rsrc(struct mcs *mcs, int dir, u16 pcifunc)
+{
+	struct mcs_rsrc_map *map;
+	int id;
+
+	if (dir == MCS_RX)
+		map = &mcs->rx;
+	else
+		map = &mcs->tx;
+
+	/* free tcam entries */
+	for (id = 0; id < map->flow_ids.max; id++) {
+		if (map->flowid2pf_map[id] != pcifunc)
+			continue;
+		mcs_free_rsrc(&map->flow_ids, map->flowid2pf_map,
+			      id, pcifunc);
+		mcs_ena_dis_flowid_entry(mcs, id, dir, false);
+	}
+
+	/* free secy entries */
+	for (id = 0; id < map->secy.max; id++) {
+		if (map->secy2pf_map[id] != pcifunc)
+			continue;
+		mcs_free_rsrc(&map->secy, map->secy2pf_map,
+			      id, pcifunc);
+		mcs_clear_secy_plcy(mcs, id, dir);
+	}
+
+	/* free sc entries */
+	for (id = 0; id < map->secy.max; id++) {
+		if (map->sc2pf_map[id] != pcifunc)
+			continue;
+		mcs_free_rsrc(&map->sc, map->sc2pf_map, id, pcifunc);
+
+		/* Disable SC CAM only on RX side */
+		if (dir == MCS_RX)
+			mcs_ena_dis_sc_cam_entry(mcs, id, false);
+	}
+
+	/* free sa entries */
+	for (id = 0; id < map->sa.max; id++) {
+		if (map->sa2pf_map[id] != pcifunc)
+			continue;
+		mcs_free_rsrc(&map->sa, map->sa2pf_map, id, pcifunc);
+	}
+	return 0;
+}
+
+int mcs_alloc_rsrc(struct rsrc_bmap *rsrc, u16 *pf_map, u16 pcifunc)
+{
+	int rsrc_id;
+
+	rsrc_id = rvu_alloc_rsrc(rsrc);
+	if (rsrc_id < 0)
+		return -ENOMEM;
+	pf_map[rsrc_id] = pcifunc;
+	return rsrc_id;
+}
+
+int mcs_alloc_all_rsrc(struct mcs *mcs, u8 *flow_id, u8 *secy_id,
+		       u8 *sc_id, u8 *sa1_id, u8 *sa2_id, u16 pcifunc, int dir)
+{
+	struct mcs_rsrc_map *map;
+	int id;
+
+	if (dir == MCS_RX)
+		map = &mcs->rx;
+	else
+		map = &mcs->tx;
+
+	id = mcs_alloc_rsrc(&map->flow_ids, map->flowid2pf_map, pcifunc);
+	if (id < 0)
+		return -ENOMEM;
+	*flow_id = id;
+
+	id = mcs_alloc_rsrc(&map->secy, map->secy2pf_map, pcifunc);
+	if (id < 0)
+		return -ENOMEM;
+	*secy_id = id;
+
+	id = mcs_alloc_rsrc(&map->sc, map->sc2pf_map, pcifunc);
+	if (id < 0)
+		return -ENOMEM;
+	*sc_id = id;
+
+	id =  mcs_alloc_rsrc(&map->sa, map->sa2pf_map, pcifunc);
+	if (id < 0)
+		return -ENOMEM;
+	*sa1_id = id;
+
+	id =  mcs_alloc_rsrc(&map->sa, map->sa2pf_map, pcifunc);
+	if (id < 0)
+		return -ENOMEM;
+	*sa2_id = id;
+
+	return 0;
+}
+
 static void *alloc_mem(struct mcs *mcs, int n)
 {
 	return devm_kcalloc(mcs->dev, n, sizeof(u16), GFP_KERNEL);
@@ -54,6 +477,10 @@ static int mcs_alloc_struct_mem(struct mcs *mcs, struct mcs_rsrc_map *res)
 	if (!res->flowid2secy_map)
 		return -ENOMEM;
 
+	res->ctrlpktrule2pf_map = alloc_mem(mcs, MCS_MAX_CTRLPKT_RULES);
+	if (!res->ctrlpktrule2pf_map)
+		return -ENOMEM;
+
 	res->flow_ids.max = hw->tcam_entries - MCS_RSRC_RSVD_CNT;
 	err = rvu_alloc_bitmap(&res->flow_ids);
 	if (err)
@@ -74,6 +501,11 @@ static int mcs_alloc_struct_mem(struct mcs *mcs, struct mcs_rsrc_map *res)
 	if (err)
 		return err;
 
+	res->ctrlpktrule.max = MCS_MAX_CTRLPKT_RULES;
+	err = rvu_alloc_bitmap(&res->ctrlpktrule);
+	if (err)
+		return err;
+
 	return 0;
 }
 
@@ -210,6 +642,18 @@ void mcs_set_lmac_mode(struct mcs *mcs, int lmac_id, u8 mode)
 	mcs_reg_write(mcs, reg, (u64)mode);
 }
 
+void mcs_pn_threshold_set(struct mcs *mcs, struct mcs_set_pn_threshold *pn)
+{
+	u64 reg;
+
+	if (pn->dir == MCS_RX)
+		reg = pn->xpn ? MCSX_CPM_RX_SLAVE_XPN_THRESHOLD : MCSX_CPM_RX_SLAVE_PN_THRESHOLD;
+	else
+		reg = pn->xpn ? MCSX_CPM_TX_SLAVE_XPN_THRESHOLD : MCSX_CPM_TX_SLAVE_PN_THRESHOLD;
+
+	mcs_reg_write(mcs, reg, pn->threshold);
+}
+
 void cn10kb_mcs_parser_cfg(struct mcs *mcs)
 {
 	u64 reg, val;
@@ -353,6 +797,9 @@ void cn10kb_mcs_set_hw_capabilities(struct mcs *mcs)
 static struct mcs_ops cn10kb_mcs_ops = {
 	.mcs_set_hw_capabilities	= cn10kb_mcs_set_hw_capabilities,
 	.mcs_parser_cfg			= cn10kb_mcs_parser_cfg,
+	.mcs_tx_sa_mem_map_write	= cn10kb_mcs_tx_sa_mem_map_write,
+	.mcs_rx_sa_mem_map_write	= cn10kb_mcs_rx_sa_mem_map_write,
+	.mcs_flowid_secy_map		= cn10kb_mcs_flowid_secy_map,
 };
 
 static int mcs_probe(struct pci_dev *pdev, const struct pci_device_id *id)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs.h b/drivers/net/ethernet/marvell/octeontx2/af/mcs.h
index c11d507..615a3ad 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs.h
@@ -21,19 +21,47 @@
 #define MCS_PORT_FIFO_SKID_MASK		0x3F
 #define MCS_MAX_CUSTOM_TAGS		0x8
 
+#define MCS_CTRLPKT_ETYPE_RULE_MAX	8
+#define MCS_CTRLPKT_DA_RULE_MAX		8
+#define MCS_CTRLPKT_DA_RANGE_RULE_MAX	4
+#define MCS_CTRLPKT_COMBO_RULE_MAX	4
+#define MCS_CTRLPKT_MAC_RULE_MAX	1
+
+#define MCS_MAX_CTRLPKT_RULES	(MCS_CTRLPKT_ETYPE_RULE_MAX + \
+				MCS_CTRLPKT_DA_RULE_MAX + \
+				MCS_CTRLPKT_DA_RANGE_RULE_MAX + \
+				MCS_CTRLPKT_COMBO_RULE_MAX + \
+				MCS_CTRLPKT_MAC_RULE_MAX)
+
+#define MCS_CTRLPKT_ETYPE_RULE_OFFSET		0
+#define MCS_CTRLPKT_DA_RULE_OFFSET		8
+#define MCS_CTRLPKT_DA_RANGE_RULE_OFFSET	16
+#define MCS_CTRLPKT_COMBO_RULE_OFFSET		20
+#define MCS_CTRLPKT_MAC_EN_RULE_OFFSET		24
+
 /* Reserved resources for default bypass entry */
 #define MCS_RSRC_RSVD_CNT		1
 
+struct secy_mem_map {
+	u8 flow_id;
+	u8 secy;
+	u8 ctrl_pkt;
+	u8 sc;
+	u64 sci;
+};
+
 struct mcs_rsrc_map {
 	u16 *flowid2pf_map;
 	u16 *secy2pf_map;
 	u16 *sc2pf_map;
 	u16 *sa2pf_map;
 	u16 *flowid2secy_map;	/* bitmap flowid mapped to secy*/
+	u16 *ctrlpktrule2pf_map;
 	struct rsrc_bmap	flow_ids;
 	struct rsrc_bmap	secy;
 	struct rsrc_bmap	sc;
 	struct rsrc_bmap	sa;
+	struct rsrc_bmap	ctrlpktrule;
 };
 
 struct hwinfo {
@@ -62,6 +90,9 @@ struct mcs {
 struct mcs_ops {
 	void	(*mcs_set_hw_capabilities)(struct mcs *mcs);
 	void	(*mcs_parser_cfg)(struct mcs *mcs);
+	void	(*mcs_tx_sa_mem_map_write)(struct mcs *mcs, struct mcs_tx_sc_sa_map *map);
+	void	(*mcs_rx_sa_mem_map_write)(struct mcs *mcs, struct mcs_rx_sc_sa_map *map);
+	void	(*mcs_flowid_secy_map)(struct mcs *mcs, struct secy_mem_map *map, int dir);
 };
 
 extern struct pci_driver mcs_driver;
@@ -80,7 +111,24 @@ static inline u64 mcs_reg_read(struct mcs *mcs, u64 offset)
 struct mcs *mcs_get_pdata(int mcs_id);
 int mcs_get_blkcnt(void);
 int mcs_set_lmac_channels(int mcs_id, u16 base);
-
+int mcs_alloc_rsrc(struct rsrc_bmap *rsrc, u16 *pf_map, u16 pcifunc);
+int mcs_free_rsrc(struct rsrc_bmap *rsrc, u16 *pf_map, int rsrc_id, u16 pcifunc);
+int mcs_alloc_all_rsrc(struct mcs *mcs, u8 *flowid, u8 *secy_id,
+		       u8 *sc_id, u8 *sa1_id, u8 *sa2_id, u16 pcifunc, int dir);
+int mcs_free_all_rsrc(struct mcs *mcs, int dir, u16 pcifunc);
+void mcs_clear_secy_plcy(struct mcs *mcs, int secy_id, int dir);
+void mcs_ena_dis_flowid_entry(struct mcs *mcs, int id, int dir, int ena);
+void mcs_ena_dis_sc_cam_entry(struct mcs *mcs, int id, int ena);
+void mcs_flowid_entry_write(struct mcs *mcs, u64 *data, u64 *mask, int id, int dir);
+void mcs_secy_plcy_write(struct mcs *mcs, u64 plcy, int id, int dir);
+void mcs_rx_sc_cam_write(struct mcs *mcs, u64 sci, u64 secy, int sc_id);
+void mcs_sa_plcy_write(struct mcs *mcs, u64 *plcy, int sa, int dir);
+void mcs_map_sc_to_sa(struct mcs *mcs, u64 *sa_map, int sc, int dir);
+void mcs_pn_table_write(struct mcs *mcs, u8 pn_id, u64 next_pn, u8 dir);
+void mcs_tx_sa_mem_map_write(struct mcs *mcs, struct mcs_tx_sc_sa_map *map);
+void mcs_flowid_secy_map(struct mcs *mcs, struct secy_mem_map *map, int dir);
+void mcs_rx_sa_mem_map_write(struct mcs *mcs, struct mcs_rx_sc_sa_map *map);
+void mcs_pn_threshold_set(struct mcs *mcs, struct mcs_set_pn_threshold *pn);
 int mcs_install_flowid_bypass_entry(struct mcs *mcs);
 void mcs_set_lmac_mode(struct mcs *mcs, int lmac_id, u8 mode);
 void mcs_reset_port(struct mcs *mcs, u8 port_id, u8 reset);
@@ -89,14 +137,23 @@ void mcs_get_port_cfg(struct mcs *mcs, struct mcs_port_cfg_get_req *req,
 		      struct mcs_port_cfg_get_rsp *rsp);
 void mcs_get_custom_tag_cfg(struct mcs *mcs, struct mcs_custom_tag_cfg_get_req *req,
 			    struct mcs_custom_tag_cfg_get_rsp *rsp);
+int mcs_alloc_ctrlpktrule(struct rsrc_bmap *rsrc, u16 *pf_map, u16 offset, u16 pcifunc);
+int mcs_free_ctrlpktrule(struct mcs *mcs, struct mcs_free_ctrl_pkt_rule_req *req);
+int mcs_ctrlpktrule_write(struct mcs *mcs, struct mcs_ctrl_pkt_rule_write_req *req);
 
 /* CN10K-B APIs */
 void cn10kb_mcs_set_hw_capabilities(struct mcs *mcs);
+void cn10kb_mcs_tx_sa_mem_map_write(struct mcs *mcs, struct mcs_tx_sc_sa_map *map);
+void cn10kb_mcs_flowid_secy_map(struct mcs *mcs, struct secy_mem_map *map, int dir);
+void cn10kb_mcs_rx_sa_mem_map_write(struct mcs *mcs, struct mcs_rx_sc_sa_map *map);
 void cn10kb_mcs_parser_cfg(struct mcs *mcs);
 
 /* CNF10K-B APIs */
 struct mcs_ops *cnf10kb_get_mac_ops(void);
 void cnf10kb_mcs_set_hw_capabilities(struct mcs *mcs);
+void cnf10kb_mcs_tx_sa_mem_map_write(struct mcs *mcs, struct mcs_tx_sc_sa_map *map);
+void cnf10kb_mcs_flowid_secy_map(struct mcs *mcs, struct secy_mem_map *map, int dir);
+void cnf10kb_mcs_rx_sa_mem_map_write(struct mcs *mcs, struct mcs_rx_sc_sa_map *map);
 void cnf10kb_mcs_parser_cfg(struct mcs *mcs);
 
 #endif /* MCS_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs_cnf10kb.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs_cnf10kb.c
index 62c83a3e..f375402 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs_cnf10kb.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs_cnf10kb.c
@@ -10,6 +10,9 @@
 static struct mcs_ops cnf10kb_mcs_ops   = {
 	.mcs_set_hw_capabilities	= cnf10kb_mcs_set_hw_capabilities,
 	.mcs_parser_cfg			= cnf10kb_mcs_parser_cfg,
+	.mcs_tx_sa_mem_map_write	= cnf10kb_mcs_tx_sa_mem_map_write,
+	.mcs_rx_sa_mem_map_write	= cnf10kb_mcs_rx_sa_mem_map_write,
+	.mcs_flowid_secy_map		= cnf10kb_mcs_flowid_secy_map,
 };
 
 struct mcs_ops *cnf10kb_get_mac_ops(void)
@@ -63,3 +66,55 @@ void cnf10kb_mcs_parser_cfg(struct mcs *mcs)
 	reg = MCSX_PEX_TX_SLAVE_ETYPE_ENABLE;
 	mcs_reg_write(mcs, reg, val);
 }
+
+void cnf10kb_mcs_flowid_secy_map(struct mcs *mcs, struct secy_mem_map *map, int dir)
+{
+	u64 reg, val;
+
+	val = (map->secy & 0x3F) | (map->ctrl_pkt & 0x1) << 6;
+	if (dir == MCS_RX) {
+		reg = MCSX_CPM_RX_SLAVE_SECY_MAP_MEMX(map->flow_id);
+	} else {
+		reg = MCSX_CPM_TX_SLAVE_SECY_MAP_MEM_0X(map->flow_id);
+		mcs_reg_write(mcs, reg, map->sci);
+		val |= (map->sc & 0x3F) << 7;
+		reg = MCSX_CPM_TX_SLAVE_SECY_MAP_MEM_1X(map->flow_id);
+	}
+
+	mcs_reg_write(mcs, reg, val);
+}
+
+void cnf10kb_mcs_tx_sa_mem_map_write(struct mcs *mcs, struct mcs_tx_sc_sa_map *map)
+{
+	u64 reg, val;
+
+	val = (map->sa_index0 & 0x7F) | (map->sa_index1 & 0x7F) << 7;
+
+	reg = MCSX_CPM_TX_SLAVE_SA_MAP_MEM_0X(map->sc_id);
+	mcs_reg_write(mcs, reg, val);
+
+	if (map->rekey_ena) {
+		reg = MCSX_CPM_TX_SLAVE_AUTO_REKEY_ENABLE_0;
+		val = mcs_reg_read(mcs, reg);
+		val |= BIT_ULL(map->sc_id);
+		mcs_reg_write(mcs, reg, val);
+	}
+
+	if (map->sa_index0_vld)
+		mcs_reg_write(mcs, MCSX_CPM_TX_SLAVE_SA_INDEX0_VLDX(map->sc_id), BIT_ULL(0));
+
+	if (map->sa_index1_vld)
+		mcs_reg_write(mcs, MCSX_CPM_TX_SLAVE_SA_INDEX1_VLDX(map->sc_id), BIT_ULL(0));
+
+	mcs_reg_write(mcs, MCSX_CPM_TX_SLAVE_TX_SA_ACTIVEX(map->sc_id), map->tx_sa_active);
+}
+
+void cnf10kb_mcs_rx_sa_mem_map_write(struct mcs *mcs, struct mcs_rx_sc_sa_map *map)
+{
+	u64 val, reg;
+
+	val = (map->sa_index & 0x7F) | (map->sa_in_use << 7);
+
+	reg = MCSX_CPM_RX_SLAVE_SA_MAP_MEMX((4 * map->sc_id) + map->an);
+	mcs_reg_write(mcs, reg, val);
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h
index 1ce3442..e192a68 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h
@@ -89,6 +89,163 @@
 #define MCSX_PEX_TX_SLAVE_VLAN_CFGX(a)          (0x46f8ull + (a) * 0x8ull)
 #define MCSX_PEX_TX_SLAVE_CUSTOM_TAG_REL_MODE_SEL(a)	(0x788ull + (a) * 0x8ull)
 #define MCSX_PEX_TX_SLAVE_PORT_CONFIG(a)		(0x4738ull + (a) * 0x8ull)
+#define MCSX_PEX_RX_SLAVE_RULE_ETYPE_CFGX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x3fc0ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x558ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_PEX_RX_SLAVE_RULE_DAX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x4000ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x598ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_PEX_RX_SLAVE_RULE_DA_RANGE_MINX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x4040ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x5d8ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_PEX_RX_SLAVE_RULE_DA_RANGE_MAXX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x4048ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x5e0ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_PEX_RX_SLAVE_RULE_COMBO_MINX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x4080ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x648ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_PEX_RX_SLAVE_RULE_COMBO_MAXX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x4088ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x650ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_PEX_RX_SLAVE_RULE_COMBO_ETX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x4090ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x658ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_PEX_RX_SLAVE_RULE_MAC ({	\
+	u64 offset;					\
+							\
+	offset = 0x40e0ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x6d8ull;			\
+	offset; })
+
+#define MCSX_PEX_RX_SLAVE_RULE_ENABLE ({	\
+	u64 offset;					\
+							\
+	offset = 0x40e8ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x6e0ull;			\
+	offset; })
+
+#define MCSX_PEX_TX_SLAVE_RULE_ETYPE_CFGX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x4b60ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x7d8ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_PEX_TX_SLAVE_RULE_DAX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x4ba0ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x818ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_PEX_TX_SLAVE_RULE_DA_RANGE_MINX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x4be0ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x858ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_PEX_TX_SLAVE_RULE_DA_RANGE_MAXX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x4be8ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x860ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_PEX_TX_SLAVE_RULE_COMBO_MINX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x4c20ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x8c8ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_PEX_TX_SLAVE_RULE_COMBO_MAXX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x4c28ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x8d0ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_PEX_TX_SLAVE_RULE_COMBO_ETX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x4c30ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x8d8ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_PEX_TX_SLAVE_RULE_MAC ({	\
+	u64 offset;					\
+							\
+	offset = 0x4c80ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x958ull;			\
+	offset; })
+
+#define MCSX_PEX_TX_SLAVE_RULE_ENABLE ({	\
+	u64 offset;					\
+							\
+	offset = 0x4c88ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x960ull;			\
+	offset; })
 
 #define MCSX_PEX_RX_SLAVE_PEX_CONFIGURATION ({		\
 	u64 offset;					\
@@ -111,4 +268,232 @@
 #define MCSX_BBE_RX_SLAVE_CAL_LEN			0x188ull
 #define MCSX_PAB_RX_SLAVE_FIFO_SKID_CFGX(a)		(0x290ull + (a) * 0x40ull)
 
+/* CPM registers */
+#define MCSX_CPM_RX_SLAVE_FLOWID_TCAM_DATAX(a, b) ({	\
+	u64 offset;					\
+							\
+	offset = 0x30740ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x3bf8ull;			\
+	offset += (a) * 0x8ull + (b) * 0x20ull;		\
+	offset; })
+
+#define MCSX_CPM_RX_SLAVE_FLOWID_TCAM_MASKX(a, b) ({	\
+	u64 offset;					\
+							\
+	offset = 0x34740ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x43f8ull;			\
+	offset += (a) * 0x8ull + (b) * 0x20ull;		\
+	offset; })
+
+#define MCSX_CPM_RX_SLAVE_FLOWID_TCAM_ENA_0 ({		\
+	u64 offset;					\
+							\
+	offset = 0x30700ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x3bd8ull;			\
+	offset; })
+
+#define MCSX_CPM_RX_SLAVE_SC_CAMX(a, b)	({		\
+	u64 offset;					\
+							\
+	offset = 0x38780ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x4c08ull;			\
+	offset +=  (a) * 0x8ull + (b) * 0x10ull;	\
+	offset; })
+
+#define MCSX_CPM_RX_SLAVE_SC_CAM_ENA(a)	({		\
+	u64 offset;					\
+							\
+	offset = 0x38740ull + (a) * 0x8ull;		\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x4bf8ull;			\
+	offset; })
+
+#define MCSX_CPM_RX_SLAVE_SECY_MAP_MEMX(a) ({		\
+	u64 offset;					\
+							\
+	offset = 0x23ee0ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xbd0ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CPM_RX_SLAVE_SECY_PLCY_MEM_0X(a) ({	\
+	u64 offset;					\
+							\
+	offset = (0x246e0ull + (a) * 0x10ull);		\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = (0xdd0ull + (a) * 0x8ull);	\
+	offset; })
+
+#define MCSX_CPM_RX_SLAVE_SA_KEY_LOCKOUTX(a) ({		\
+	u64 offset;					\
+							\
+	offset = 0x23E90ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xbb0ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CPM_RX_SLAVE_SA_MAP_MEMX(a) ({		\
+	u64 offset;					\
+							\
+	offset = 0x256e0ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xfd0ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CPM_RX_SLAVE_SA_PLCY_MEMX(a, b) ({		\
+	u64 offset;					\
+							\
+	offset = 0x27700ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x17d8ull;			\
+	offset +=  (a) * 0x8ull + (b) * 0x40ull;	\
+	offset; })
+
+#define MCSX_CPM_RX_SLAVE_SA_PN_TABLE_MEMX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x2f700ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x37d8;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CPM_RX_SLAVE_XPN_THRESHOLD	({		\
+	u64 offset;					\
+							\
+	offset = 0x23e40ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xb90ull;			\
+	offset; })
+
+#define MCSX_CPM_RX_SLAVE_PN_THRESHOLD	({		\
+	u64 offset;					\
+							\
+	offset = 0x23e48ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xb98ull;			\
+	offset; })
+
+#define MCSX_CPM_RX_SLAVE_PN_THRESH_REACHEDX(a)	({	\
+	u64 offset;					\
+							\
+	offset = 0x23e50ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xba0ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CPM_RX_SLAVE_FLOWID_TCAM_ENA_1		0x30708ull
+#define MCSX_CPM_RX_SLAVE_SECY_PLCY_MEM_1X(a)		(0x246e8ull + (a) * 0x10ull)
+
+/* TX registers */
+#define MCSX_CPM_TX_SLAVE_FLOWID_TCAM_DATAX(a, b) ({	\
+	u64 offset;					\
+							\
+	offset = 0x51d50ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xa7c0ull;			\
+	offset += (a) * 0x8ull + (b) * 0x20ull;		\
+	offset; })
+
+#define MCSX_CPM_TX_SLAVE_FLOWID_TCAM_MASKX(a, b) ({	\
+	u64 offset;					\
+							\
+	offset = 0x55d50ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xafc0ull;			\
+	offset += (a) * 0x8ull + (b) * 0x20ull;		\
+	offset; })
+
+#define MCSX_CPM_TX_SLAVE_FLOWID_TCAM_ENA_0 ({		\
+	u64 offset;					\
+							\
+	offset = 0x51d10ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xa7a0ull;			\
+	offset; })
+
+#define MCSX_CPM_TX_SLAVE_SECY_MAP_MEM_0X(a) ({		\
+	u64 offset;					\
+							\
+	offset = 0x3e508ull + (a) * 0x8ull;		\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x5550ull + (a) * 0x10ull;	\
+	offset; })
+
+#define MCSX_CPM_TX_SLAVE_SECY_PLCY_MEMX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x3ed08ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x5950ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CPM_TX_SLAVE_SA_KEY_LOCKOUTX(a) ({		\
+	u64 offset;					\
+							\
+	offset = 0x3e4c0ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x5538ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CPM_TX_SLAVE_SA_MAP_MEM_0X(a) ({		\
+	u64 offset;					\
+							\
+	offset = 0x3fd10ull + (a) * 0x10ull;		\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x6150ull + (a) * 0x8ull;	\
+	offset; })
+
+#define MCSX_CPM_TX_SLAVE_SA_PLCY_MEMX(a, b) ({		\
+	u64 offset;					\
+							\
+	offset = 0x40d10ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x63a0ull;			\
+	offset += (a) * 0x8ull + (b) * 0x80ull;		\
+	offset; })
+
+#define MCSX_CPM_TX_SLAVE_SA_PN_TABLE_MEMX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x50d10ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xa3a0ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CPM_TX_SLAVE_XPN_THRESHOLD ({		\
+	u64 offset;					\
+							\
+	offset = 0x3e4b0ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x5528ull;			\
+	offset; })
+
+#define MCSX_CPM_TX_SLAVE_PN_THRESHOLD ({		\
+	u64 offset;					\
+							\
+	offset = 0x3e4b8ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x5530ull;			\
+	offset; })
+
+#define MCSX_CPM_TX_SLAVE_SA_MAP_MEM_1X(a)		(0x3fd18ull + (a) * 0x10ull)
+#define MCSX_CPM_TX_SLAVE_SECY_MAP_MEM_1X(a)		(0x5558ull + (a) * 0x10ull)
+#define MCSX_CPM_TX_SLAVE_FLOWID_TCAM_ENA_1		0x51d18ull
+#define MCSX_CPM_TX_SLAVE_TX_SA_ACTIVEX(a)		(0x5b50 + (a) * 0x8ull)
+#define MCSX_CPM_TX_SLAVE_SA_INDEX0_VLDX(a)		(0x5d50 + (a) * 0x8ull)
+#define MCSX_CPM_TX_SLAVE_SA_INDEX1_VLDX(a)		(0x5f50 + (a) * 0x8ull)
+#define MCSX_CPM_TX_SLAVE_AUTO_REKEY_ENABLE_0		0x5500ull
+
 #endif
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
index 9eaa8ee..3c307e7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
@@ -133,6 +133,380 @@ int rvu_mbox_handler_mcs_custom_tag_cfg_get(struct rvu *rvu, struct mcs_custom_t
 	return 0;
 }
 
+int rvu_mbox_handler_mcs_flowid_ena_entry(struct rvu *rvu,
+					  struct mcs_flowid_ena_dis_entry *req,
+					  struct msg_rsp *rsp)
+{
+	struct mcs *mcs;
+
+	if (req->mcs_id >= rvu->mcs_blk_cnt)
+		return MCS_AF_ERR_INVALID_MCSID;
+
+	mcs = mcs_get_pdata(req->mcs_id);
+	mcs_ena_dis_flowid_entry(mcs, req->flow_id, req->dir, req->ena);
+	return 0;
+}
+
+int rvu_mbox_handler_mcs_pn_table_write(struct rvu *rvu,
+					struct mcs_pn_table_write_req *req,
+					struct msg_rsp *rsp)
+{
+	struct mcs *mcs;
+
+	if (req->mcs_id >= rvu->mcs_blk_cnt)
+		return MCS_AF_ERR_INVALID_MCSID;
+
+	mcs = mcs_get_pdata(req->mcs_id);
+	mcs_pn_table_write(mcs, req->pn_id, req->next_pn, req->dir);
+	return 0;
+}
+
+int rvu_mbox_handler_mcs_set_pn_threshold(struct rvu *rvu,
+					  struct mcs_set_pn_threshold *req,
+					  struct msg_rsp *rsp)
+{
+	struct mcs *mcs;
+
+	if (req->mcs_id >= rvu->mcs_blk_cnt)
+		return MCS_AF_ERR_INVALID_MCSID;
+
+	mcs = mcs_get_pdata(req->mcs_id);
+
+	mcs_pn_threshold_set(mcs, req);
+
+	return 0;
+}
+
+int rvu_mbox_handler_mcs_rx_sc_sa_map_write(struct rvu *rvu,
+					    struct mcs_rx_sc_sa_map *req,
+					    struct msg_rsp *rsp)
+{
+	struct mcs *mcs;
+
+	if (req->mcs_id >= rvu->mcs_blk_cnt)
+		return MCS_AF_ERR_INVALID_MCSID;
+
+	mcs = mcs_get_pdata(req->mcs_id);
+	mcs->mcs_ops->mcs_rx_sa_mem_map_write(mcs, req);
+	return 0;
+}
+
+int rvu_mbox_handler_mcs_tx_sc_sa_map_write(struct rvu *rvu,
+					    struct mcs_tx_sc_sa_map *req,
+					    struct msg_rsp *rsp)
+{
+	struct mcs *mcs;
+
+	if (req->mcs_id >= rvu->mcs_blk_cnt)
+		return MCS_AF_ERR_INVALID_MCSID;
+
+	mcs = mcs_get_pdata(req->mcs_id);
+	mcs->mcs_ops->mcs_tx_sa_mem_map_write(mcs, req);
+
+	return 0;
+}
+
+int rvu_mbox_handler_mcs_sa_plcy_write(struct rvu *rvu,
+				       struct mcs_sa_plcy_write_req *req,
+				       struct msg_rsp *rsp)
+{
+	struct mcs *mcs;
+	int i;
+
+	if (req->mcs_id >= rvu->mcs_blk_cnt)
+		return MCS_AF_ERR_INVALID_MCSID;
+
+	mcs = mcs_get_pdata(req->mcs_id);
+
+	for (i = 0; i < req->sa_cnt; i++)
+		mcs_sa_plcy_write(mcs, &req->plcy[i][0],
+				  req->sa_index[i], req->dir);
+	return 0;
+}
+
+int rvu_mbox_handler_mcs_rx_sc_cam_write(struct rvu *rvu,
+					 struct mcs_rx_sc_cam_write_req *req,
+					 struct msg_rsp *rsp)
+{
+	struct mcs *mcs;
+
+	if (req->mcs_id >= rvu->mcs_blk_cnt)
+		return MCS_AF_ERR_INVALID_MCSID;
+
+	mcs = mcs_get_pdata(req->mcs_id);
+	mcs_rx_sc_cam_write(mcs, req->sci, req->secy_id, req->sc_id);
+	return 0;
+}
+
+int rvu_mbox_handler_mcs_secy_plcy_write(struct rvu *rvu,
+					 struct mcs_secy_plcy_write_req *req,
+					 struct msg_rsp *rsp)
+{	struct mcs *mcs;
+
+	if (req->mcs_id >= rvu->mcs_blk_cnt)
+		return MCS_AF_ERR_INVALID_MCSID;
+
+	mcs = mcs_get_pdata(req->mcs_id);
+
+	mcs_secy_plcy_write(mcs, req->plcy,
+			    req->secy_id, req->dir);
+	return 0;
+}
+
+int rvu_mbox_handler_mcs_flowid_entry_write(struct rvu *rvu,
+					    struct mcs_flowid_entry_write_req *req,
+					    struct msg_rsp *rsp)
+{
+	struct secy_mem_map map;
+	struct mcs *mcs;
+
+	if (req->mcs_id >= rvu->mcs_blk_cnt)
+		return MCS_AF_ERR_INVALID_MCSID;
+
+	mcs = mcs_get_pdata(req->mcs_id);
+
+	/* TODO validate the flowid */
+	mcs_flowid_entry_write(mcs, req->data, req->mask,
+			       req->flow_id, req->dir);
+	map.secy = req->secy_id;
+	map.sc = req->sc_id;
+	map.ctrl_pkt = req->ctrl_pkt;
+	map.flow_id = req->flow_id;
+	map.sci = req->sci;
+	mcs->mcs_ops->mcs_flowid_secy_map(mcs, &map, req->dir);
+	if (req->ena)
+		mcs_ena_dis_flowid_entry(mcs, req->flow_id,
+					 req->dir, true);
+	return 0;
+}
+
+int rvu_mbox_handler_mcs_free_resources(struct rvu *rvu,
+					struct mcs_free_rsrc_req *req,
+					struct msg_rsp *rsp)
+{
+	u16 pcifunc = req->hdr.pcifunc;
+	struct mcs_rsrc_map *map;
+	struct mcs *mcs;
+	int rc;
+
+	if (req->mcs_id >= rvu->mcs_blk_cnt)
+		return MCS_AF_ERR_INVALID_MCSID;
+
+	mcs = mcs_get_pdata(req->mcs_id);
+
+	if (req->dir == MCS_RX)
+		map = &mcs->rx;
+	else
+		map = &mcs->tx;
+
+	mutex_lock(&rvu->rsrc_lock);
+	/* Free all the cam resources mapped to PF/VF */
+	if (req->all) {
+		rc = mcs_free_all_rsrc(mcs, req->dir, pcifunc);
+		goto exit;
+	}
+
+	switch (req->rsrc_type) {
+	case MCS_RSRC_TYPE_FLOWID:
+		rc = mcs_free_rsrc(&map->flow_ids, map->flowid2pf_map, req->rsrc_id, pcifunc);
+		mcs_ena_dis_flowid_entry(mcs, req->rsrc_id, req->dir, false);
+		break;
+	case MCS_RSRC_TYPE_SECY:
+		rc =  mcs_free_rsrc(&map->secy, map->secy2pf_map, req->rsrc_id, pcifunc);
+		mcs_clear_secy_plcy(mcs, req->rsrc_id, req->dir);
+		break;
+	case MCS_RSRC_TYPE_SC:
+		rc = mcs_free_rsrc(&map->sc, map->sc2pf_map, req->rsrc_id, pcifunc);
+		/* Disable SC CAM only on RX side */
+		if (req->dir == MCS_RX)
+			mcs_ena_dis_sc_cam_entry(mcs, req->rsrc_id, false);
+		break;
+	case MCS_RSRC_TYPE_SA:
+		rc = mcs_free_rsrc(&map->sa, map->sa2pf_map, req->rsrc_id, pcifunc);
+		break;
+	}
+exit:
+	mutex_unlock(&rvu->rsrc_lock);
+	return rc;
+}
+
+int rvu_mbox_handler_mcs_alloc_resources(struct rvu *rvu,
+					 struct mcs_alloc_rsrc_req *req,
+					 struct mcs_alloc_rsrc_rsp *rsp)
+{
+	u16 pcifunc = req->hdr.pcifunc;
+	struct mcs_rsrc_map *map;
+	struct mcs *mcs;
+	int rsrc_id, i;
+
+	if (req->mcs_id >= rvu->mcs_blk_cnt)
+		return MCS_AF_ERR_INVALID_MCSID;
+
+	mcs = mcs_get_pdata(req->mcs_id);
+
+	if (req->dir == MCS_RX)
+		map = &mcs->rx;
+	else
+		map = &mcs->tx;
+
+	mutex_lock(&rvu->rsrc_lock);
+
+	if (req->all) {
+		rsrc_id = mcs_alloc_all_rsrc(mcs, &rsp->flow_ids[0],
+					     &rsp->secy_ids[0],
+					     &rsp->sc_ids[0],
+					     &rsp->sa_ids[0],
+					     &rsp->sa_ids[1],
+					     pcifunc, req->dir);
+		goto exit;
+	}
+
+	switch (req->rsrc_type) {
+	case MCS_RSRC_TYPE_FLOWID:
+		for (i = 0; i < req->rsrc_cnt; i++) {
+			rsrc_id = mcs_alloc_rsrc(&map->flow_ids, map->flowid2pf_map, pcifunc);
+			if (rsrc_id < 0)
+				goto exit;
+			rsp->flow_ids[i] = rsrc_id;
+			rsp->rsrc_cnt++;
+		}
+		break;
+	case MCS_RSRC_TYPE_SECY:
+		for (i = 0; i < req->rsrc_cnt; i++) {
+			rsrc_id = mcs_alloc_rsrc(&map->secy, map->secy2pf_map, pcifunc);
+			if (rsrc_id < 0)
+				goto exit;
+			rsp->secy_ids[i] = rsrc_id;
+			rsp->rsrc_cnt++;
+		}
+		break;
+	case MCS_RSRC_TYPE_SC:
+		for (i = 0; i < req->rsrc_cnt; i++) {
+			rsrc_id = mcs_alloc_rsrc(&map->sc, map->sc2pf_map, pcifunc);
+			if (rsrc_id < 0)
+				goto exit;
+			rsp->sc_ids[i] = rsrc_id;
+			rsp->rsrc_cnt++;
+		}
+		break;
+	case MCS_RSRC_TYPE_SA:
+		for (i = 0; i < req->rsrc_cnt; i++) {
+			rsrc_id = mcs_alloc_rsrc(&map->sa, map->sa2pf_map, pcifunc);
+			if (rsrc_id < 0)
+				goto exit;
+			rsp->sa_ids[i] = rsrc_id;
+			rsp->rsrc_cnt++;
+		}
+		break;
+	}
+
+	rsp->rsrc_type = req->rsrc_type;
+	rsp->dir = req->dir;
+	rsp->mcs_id = req->mcs_id;
+	rsp->all = req->all;
+
+exit:
+	if (rsrc_id < 0)
+		dev_err(rvu->dev, "Failed to allocate the mcs resources for PCIFUNC:%d\n", pcifunc);
+	mutex_unlock(&rvu->rsrc_lock);
+	return 0;
+}
+
+int rvu_mbox_handler_mcs_alloc_ctrl_pkt_rule(struct rvu *rvu,
+					     struct mcs_alloc_ctrl_pkt_rule_req *req,
+					     struct mcs_alloc_ctrl_pkt_rule_rsp *rsp)
+{
+	u16 pcifunc = req->hdr.pcifunc;
+	struct mcs_rsrc_map *map;
+	struct mcs *mcs;
+	int rsrc_id;
+	u16 offset;
+
+	if (req->mcs_id >= rvu->mcs_blk_cnt)
+		return MCS_AF_ERR_INVALID_MCSID;
+
+	mcs = mcs_get_pdata(req->mcs_id);
+
+	map = (req->dir == MCS_RX) ? &mcs->rx : &mcs->tx;
+
+	mutex_lock(&rvu->rsrc_lock);
+
+	switch (req->rule_type) {
+	case MCS_CTRL_PKT_RULE_TYPE_ETH:
+		offset = MCS_CTRLPKT_ETYPE_RULE_OFFSET;
+		break;
+	case MCS_CTRL_PKT_RULE_TYPE_DA:
+		offset = MCS_CTRLPKT_DA_RULE_OFFSET;
+		break;
+	case MCS_CTRL_PKT_RULE_TYPE_RANGE:
+		offset = MCS_CTRLPKT_DA_RANGE_RULE_OFFSET;
+		break;
+	case MCS_CTRL_PKT_RULE_TYPE_COMBO:
+		offset = MCS_CTRLPKT_COMBO_RULE_OFFSET;
+		break;
+	case MCS_CTRL_PKT_RULE_TYPE_MAC:
+		offset = MCS_CTRLPKT_MAC_EN_RULE_OFFSET;
+		break;
+	}
+
+	rsrc_id = mcs_alloc_ctrlpktrule(&map->ctrlpktrule, map->ctrlpktrule2pf_map, offset,
+					pcifunc);
+	if (rsrc_id < 0)
+		goto exit;
+
+	rsp->rule_idx = rsrc_id;
+	rsp->rule_type = req->rule_type;
+	rsp->dir = req->dir;
+	rsp->mcs_id = req->mcs_id;
+
+	mutex_unlock(&rvu->rsrc_lock);
+	return 0;
+exit:
+	if (rsrc_id < 0)
+		dev_err(rvu->dev, "Failed to allocate the mcs ctrl pkt rule for PCIFUNC:%d\n",
+			pcifunc);
+	mutex_unlock(&rvu->rsrc_lock);
+	return rsrc_id;
+}
+
+int rvu_mbox_handler_mcs_free_ctrl_pkt_rule(struct rvu *rvu,
+					    struct mcs_free_ctrl_pkt_rule_req *req,
+					    struct msg_rsp *rsp)
+{
+	struct mcs *mcs;
+	int rc;
+
+	if (req->mcs_id >= rvu->mcs_blk_cnt)
+		return MCS_AF_ERR_INVALID_MCSID;
+
+	mcs = mcs_get_pdata(req->mcs_id);
+
+	mutex_lock(&rvu->rsrc_lock);
+
+	rc = mcs_free_ctrlpktrule(mcs, req);
+
+	mutex_unlock(&rvu->rsrc_lock);
+
+	return rc;
+}
+
+int rvu_mbox_handler_mcs_ctrl_pkt_rule_write(struct rvu *rvu,
+					     struct mcs_ctrl_pkt_rule_write_req *req,
+					     struct msg_rsp *rsp)
+{
+	struct mcs *mcs;
+	int rc;
+
+	if (req->mcs_id >= rvu->mcs_blk_cnt)
+		return MCS_AF_ERR_INVALID_MCSID;
+
+	mcs = mcs_get_pdata(req->mcs_id);
+
+	rc = mcs_ctrlpktrule_write(mcs, req);
+
+	return rc;
+}
+
 static void rvu_mcs_set_lmac_bmap(struct rvu *rvu)
 {
 	struct mcs *mcs = mcs_get_pdata(0);
-- 
2.7.4

