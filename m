Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9BF2B3054
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 20:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgKNTxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 14:53:32 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:20250 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726156AbgKNTxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 14:53:31 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AEJousE029426;
        Sat, 14 Nov 2020 11:53:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=ticCaHSSihrJ8suXDmY1l8cLPoRhqsWs+uF1hqBIenE=;
 b=M+gccCnakrCgYrWDkAe1BqPUwHU8p50CjA4Mm8zIonZHkHQR7DhXPIT1HTQ5Xr7SDvvg
 VgUeuyy9kbUyJB2gjfE+FHMa4M7F2BkxYPGf9TUjWV4Atjw0pwgEQQbcXNmjVOu1+KQm
 bi+xrpJhHRAp552hy9SV9nInzGyiTYW+FuAp4+NZezhFU/33+GD9e/fOn50dljWAZXP6
 J9kBOCJjIYUJy8Pgzkj/ETe2ydflztxfXTRApTac1bpVw4C+h0LgJJ8TIZZZ4PmpGfmC
 OWxxmMQmHsTOu3IImcWS6rjrAohRT2YGEL4DhQRriI2vrEkQu+PrAJoIN2W1DSBDSrNA mA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 34tdfts04t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 14 Nov 2020 11:53:26 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 14 Nov
 2020 11:53:25 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 14 Nov 2020 11:53:25 -0800
Received: from hyd1583.caveonetworks.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 5A8013F7040;
        Sat, 14 Nov 2020 11:53:21 -0800 (PST)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <saeed@kernel.org>,
        <alexander.duyck@gmail.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [PATCH v4 net-next 04/13] octeontx2-af: Add mbox messages to install and delete MCAM rules
Date:   Sun, 15 Nov 2020 01:22:54 +0530
Message-ID: <20201114195303.25967-5-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20201114195303.25967-1-naveenm@marvell.com>
References: <20201114195303.25967-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-14_07:2020-11-13,2020-11-14 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

Added new mailbox messages to install and delete MCAM rules.
These mailbox messages will be used for adding/deleting ethtool
n-tuple filters by NIX PF. The installed MCAM rules are stored
in a list that will be traversed later to delete the MCAM entries
when the interface is brought down or when PCIe FLR is received.
The delete mailbox supports deleting a single MCAM entry or range
of entries or all the MCAM entries owned by the pcifunc. Each MCAM
entry can be associated with a HW match stat entry if the mailbox
requester wants to check the hit count for debugging.

Modified adding default unicast DMAC match rule using install
flow API. The default unicast DMAC match entry installed by
Administrative Function is saved and can be changed later by the
mailbox user to fit additional fields, or the default MCAM entry
rule action can be used for other flow rules installed later.

Modified rvu_mbox_handler_nix_lf_free mailbox to add a flag to
disable or delete the MCAM entries. The MCAM entries are disabled
when the interface is brought down and deleted in FLR handler.
The disabled MCAM entries will be re-enabled when the interface
is brought up again.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/common.h |   2 +
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  76 ++-
 drivers/net/ethernet/marvell/octeontx2/af/npc.h    |  57 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  13 +
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  19 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 216 +++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 721 +++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  12 +-
 8 files changed, 1064 insertions(+), 52 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/common.h b/drivers/net/ethernet/marvell/octeontx2/af/common.h
index 8f68e7a8b882..17f6f42f4453 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/common.h
@@ -162,6 +162,8 @@ enum nix_scheduler {
 #define NIX_RX_ACTIONOP_UCAST_IPSEC	(0x2ull)
 #define NIX_RX_ACTIONOP_MCAST		(0x3ull)
 #define NIX_RX_ACTIONOP_RSS		(0x4ull)
+/* Use the RX action set in the default unicast entry */
+#define NIX_RX_ACTION_DEFAULT		(0xfull)
 
 /* NIX TX action operation*/
 #define NIX_TX_ACTIONOP_DROP		(0x0ull)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index f46de8419b77..ac3118d2d126 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -188,10 +188,14 @@ M(NPC_MCAM_ALLOC_AND_WRITE_ENTRY, 0x600b, npc_mcam_alloc_and_write_entry,      \
 					  npc_mcam_alloc_and_write_entry_rsp)  \
 M(NPC_GET_KEX_CFG,	  0x600c, npc_get_kex_cfg,			\
 				   msg_req, npc_get_kex_cfg_rsp)	\
+M(NPC_INSTALL_FLOW,	  0x600d, npc_install_flow,			       \
+				  npc_install_flow_req, npc_install_flow_rsp)  \
+M(NPC_DELETE_FLOW,	  0x600e, npc_delete_flow,			\
+				  npc_delete_flow_req, msg_rsp)		\
 /* NIX mbox IDs (range 0x8000 - 0xFFFF) */				\
 M(NIX_LF_ALLOC,		0x8000, nix_lf_alloc,				\
 				 nix_lf_alloc_req, nix_lf_alloc_rsp)	\
-M(NIX_LF_FREE,		0x8001, nix_lf_free, msg_req, msg_rsp)		\
+M(NIX_LF_FREE,		0x8001, nix_lf_free, nix_lf_free_req, msg_rsp)	\
 M(NIX_AQ_ENQ,		0x8002, nix_aq_enq, nix_aq_enq_req, nix_aq_enq_rsp)  \
 M(NIX_HWCTX_DISABLE,	0x8003, nix_hwctx_disable,			\
 				 hwctx_disable_req, msg_rsp)		\
@@ -510,6 +514,12 @@ struct nix_lf_alloc_rsp {
 	u8	sdp_links;  /* No. of SDP links present in HW */
 };
 
+struct nix_lf_free_req {
+	struct mbox_msghdr hdr;
+#define NIX_LF_DISABLE_FLOWS           BIT_ULL(0)
+	u64 flags;
+};
+
 /* NIX AQ enqueue msg */
 struct nix_aq_enq_req {
 	struct mbox_msghdr hdr;
@@ -882,6 +892,70 @@ struct npc_get_kex_cfg_rsp {
 	u8 mkex_pfl_name[MKEX_NAME_LEN];
 };
 
+struct flow_msg {
+	unsigned char dmac[6];
+	unsigned char smac[6];
+	__be16 etype;
+	__be16 vlan_etype;
+	__be16 vlan_tci;
+	union {
+		__be32 ip4src;
+		__be32 ip6src[4];
+	};
+	union {
+		__be32 ip4dst;
+		__be32 ip6dst[4];
+	};
+	u8 tos;
+	u8 ip_ver;
+	u8 ip_proto;
+	u8 tc;
+	__be16 sport;
+	__be16 dport;
+};
+
+struct npc_install_flow_req {
+	struct mbox_msghdr hdr;
+	struct flow_msg packet;
+	struct flow_msg mask;
+	u64 features;
+	u16 entry;
+	u16 channel;
+	u8 intf;
+	u8 set_cntr; /* If counter is available set counter for this entry ? */
+	u8 default_rule;
+	u8 append; /* overwrite(0) or append(1) flow to default rule? */
+	u16 vf;
+	/* action */
+	u32 index;
+	u16 match_id;
+	u8 flow_key_alg;
+	u8 op;
+	/* vtag rx action */
+	u8 vtag0_type;
+	u8 vtag0_valid;
+	u8 vtag1_type;
+	u8 vtag1_valid;
+	/* vtag tx action */
+	u16 vtag0_def;
+	u8  vtag0_op;
+	u16 vtag1_def;
+	u8  vtag1_op;
+};
+
+struct npc_install_flow_rsp {
+	struct mbox_msghdr hdr;
+	int counter; /* negative if no counter else counter number */
+};
+
+struct npc_delete_flow_req {
+	struct mbox_msghdr hdr;
+	u16 entry;
+	u16 start;/*Disable range of entries */
+	u16 end;
+	u8 all; /* PF + VFs */
+};
+
 enum ptp_op {
 	PTP_OP_ADJFINE = 0,
 	PTP_OP_GET_CLOCK = 1,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index d9b8edfc129e..551cc7ce7ffa 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -379,11 +379,41 @@ struct nix_rx_action {
 #define NPC_PARSE_NIBBLE_LH_FLAGS	GENMASK_ULL(29, 28)
 #define NPC_PARSE_NIBBLE_LH_LTYPE	BIT_ULL(30)
 
+struct nix_tx_action {
+#if defined(__BIG_ENDIAN_BITFIELD)
+	u64	rsvd_63_48	:16;
+	u64	match_id	:16;
+	u64	index		:20;
+	u64	rsvd_11_8	:8;
+	u64	op		:4;
+#else
+	u64	op		:4;
+	u64	rsvd_11_8	:8;
+	u64	index		:20;
+	u64	match_id	:16;
+	u64	rsvd_63_48	:16;
+#endif
+};
+
 /* NIX Receive Vtag Action Structure */
-#define VTAG0_VALID_BIT		BIT_ULL(15)
-#define VTAG0_TYPE_MASK		GENMASK_ULL(14, 12)
-#define VTAG0_LID_MASK		GENMASK_ULL(10, 8)
-#define VTAG0_RELPTR_MASK	GENMASK_ULL(7, 0)
+#define RX_VTAG0_VALID_BIT		BIT_ULL(15)
+#define RX_VTAG0_TYPE_MASK		GENMASK_ULL(14, 12)
+#define RX_VTAG0_LID_MASK		GENMASK_ULL(10, 8)
+#define RX_VTAG0_RELPTR_MASK		GENMASK_ULL(7, 0)
+#define RX_VTAG1_VALID_BIT		BIT_ULL(47)
+#define RX_VTAG1_TYPE_MASK		GENMASK_ULL(46, 44)
+#define RX_VTAG1_LID_MASK		GENMASK_ULL(42, 40)
+#define RX_VTAG1_RELPTR_MASK		GENMASK_ULL(39, 32)
+
+/* NIX Transmit Vtag Action Structure */
+#define TX_VTAG0_DEF_MASK		GENMASK_ULL(25, 16)
+#define TX_VTAG0_OP_MASK		GENMASK_ULL(13, 12)
+#define TX_VTAG0_LID_MASK		GENMASK_ULL(10, 8)
+#define TX_VTAG0_RELPTR_MASK		GENMASK_ULL(7, 0)
+#define TX_VTAG1_DEF_MASK		GENMASK_ULL(57, 48)
+#define TX_VTAG1_OP_MASK		GENMASK_ULL(45, 44)
+#define TX_VTAG1_LID_MASK		GENMASK_ULL(42, 40)
+#define TX_VTAG1_RELPTR_MASK		GENMASK_ULL(39, 32)
 
 struct npc_mcam_kex {
 	/* MKEX Profle Header */
@@ -436,4 +466,23 @@ struct npc_lt_def_cfg {
 	struct npc_lt_def	pck_iip4;
 };
 
+struct rvu_npc_mcam_rule {
+	struct flow_msg packet;
+	struct flow_msg mask;
+	u8 intf;
+	union {
+		struct nix_tx_action tx_action;
+		struct nix_rx_action rx_action;
+	};
+	u64 vtag_action;
+	struct list_head list;
+	u64 features;
+	u16 owner;
+	u16 entry;
+	u16 cntr;
+	bool has_cntr;
+	u8 default_rule;
+	bool enable;
+};
+
 #endif /* NPC_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 0289a1deb444..4c99bed369ae 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -147,6 +147,7 @@ struct npc_mcam {
 	u16	*entry2cntr_map;
 	u16	*cntr2pfvf_map;
 	u16	*cntr_refcnt;
+	u16	*entry2target_pffunc;
 	u8	keysize;	/* MCAM keysize 112/224/448 bits */
 	u8	banks;		/* Number of MCAM banks */
 	u8	banks_per_entry;/* Number of keywords in key */
@@ -164,6 +165,7 @@ struct npc_mcam {
 	struct npc_key_field	rx_key_fields[NPC_KEY_FIELDS_MAX];
 	u64	tx_features;
 	u64	rx_features;
+	struct list_head mcam_rules;
 };
 
 /* Structure for per RVU func info ie PF/VF */
@@ -218,6 +220,8 @@ struct rvu_pfvf {
 	int rxvlan_index;
 	bool rxvlan;
 
+	struct rvu_npc_mcam_rule *def_ucast_rule;
+
 	bool	cgx_in_use; /* this PF/VF using CGX? */
 	int	cgx_users;  /* number of cgx users - used only by PFs */
 
@@ -558,6 +562,7 @@ void rvu_npc_install_bcast_match_entry(struct rvu *rvu, u16 pcifunc,
 void rvu_npc_enable_bcast_entry(struct rvu *rvu, u16 pcifunc, bool enable);
 int rvu_npc_update_rxvlan(struct rvu *rvu, u16 pcifunc, int nixlf);
 void rvu_npc_disable_mcam_entries(struct rvu *rvu, u16 pcifunc, int nixlf);
+void rvu_npc_free_mcam_entries(struct rvu *rvu, u16 pcifunc, int nixlf);
 void rvu_npc_disable_default_entries(struct rvu *rvu, u16 pcifunc, int nixlf);
 void rvu_npc_enable_default_entries(struct rvu *rvu, u16 pcifunc, int nixlf);
 void rvu_npc_update_flowkey_alg_idx(struct rvu *rvu, u16 pcifunc, int nixlf,
@@ -575,6 +580,14 @@ int rvu_npc_get_tx_nibble_cfg(struct rvu *rvu, u64 nibble_ena);
 int npc_mcam_verify_channel(struct rvu *rvu, u16 pcifunc, u8 intf, u16 channel);
 int npc_flow_steering_init(struct rvu *rvu, int blkaddr);
 const char *npc_get_field_name(u8 hdr);
+bool rvu_npc_write_default_rule(struct rvu *rvu, int blkaddr, int nixlf,
+				u16 pcifunc, u8 intf, struct mcam_entry *entry,
+				int *entry_index);
+int npc_get_bank(struct npc_mcam *mcam, int index);
+void npc_mcam_enable_flows(struct rvu *rvu, u16 target);
+void npc_mcam_disable_flows(struct rvu *rvu, u16 target);
+void npc_enable_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
+			   int blkaddr, int index, bool enable);
 
 #ifdef CONFIG_DEBUG_FS
 void rvu_dbg_init(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 18738fb9fcd3..9f60f4370d49 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -302,7 +302,6 @@ static void nix_interface_deinit(struct rvu *rvu, u16 pcifunc, u8 nixlf)
 
 	pfvf->maxlen = 0;
 	pfvf->minlen = 0;
-	pfvf->rxvlan = false;
 
 	/* Remove this PF_FUNC from bcast pkt replication list */
 	err = nix_update_bcast_mce_list(rvu, pcifunc, false);
@@ -1228,7 +1227,7 @@ int rvu_mbox_handler_nix_lf_alloc(struct rvu *rvu,
 	return rc;
 }
 
-int rvu_mbox_handler_nix_lf_free(struct rvu *rvu, struct msg_req *req,
+int rvu_mbox_handler_nix_lf_free(struct rvu *rvu, struct nix_lf_free_req *req,
 				 struct msg_rsp *rsp)
 {
 	struct rvu_hwinfo *hw = rvu->hw;
@@ -1247,6 +1246,11 @@ int rvu_mbox_handler_nix_lf_free(struct rvu *rvu, struct msg_req *req,
 	if (nixlf < 0)
 		return NIX_AF_ERR_AF_LF_INVALID;
 
+	if (req->flags & NIX_LF_DISABLE_FLOWS)
+		rvu_npc_disable_mcam_entries(rvu, pcifunc, nixlf);
+	else
+		rvu_npc_free_mcam_entries(rvu, pcifunc, nixlf);
+
 	nix_interface_deinit(rvu, pcifunc, nixlf);
 
 	/* Reset this NIX LF */
@@ -2762,8 +2766,6 @@ int rvu_mbox_handler_nix_set_mac_addr(struct rvu *rvu,
 	rvu_npc_install_ucast_entry(rvu, pcifunc, nixlf,
 				    pfvf->rx_chan_base, req->mac_addr);
 
-	rvu_npc_update_rxvlan(rvu, pcifunc, nixlf);
-
 	return 0;
 }
 
@@ -2810,9 +2812,6 @@ int rvu_mbox_handler_nix_set_rx_mode(struct rvu *rvu, struct nix_rx_mode *req,
 	else
 		rvu_npc_install_promisc_entry(rvu, pcifunc, nixlf,
 					      pfvf->rx_chan_base, allmulti);
-
-	rvu_npc_update_rxvlan(rvu, pcifunc, nixlf);
-
 	return 0;
 }
 
@@ -3376,6 +3375,8 @@ int rvu_mbox_handler_nix_lf_start_rx(struct rvu *rvu, struct msg_req *req,
 
 	rvu_npc_enable_default_entries(rvu, pcifunc, nixlf);
 
+	npc_mcam_enable_flows(rvu, pcifunc);
+
 	return rvu_cgx_start_stop_io(rvu, pcifunc, true);
 }
 
@@ -3391,6 +3392,8 @@ int rvu_mbox_handler_nix_lf_stop_rx(struct rvu *rvu, struct msg_req *req,
 
 	rvu_npc_disable_default_entries(rvu, pcifunc, nixlf);
 
+	npc_mcam_disable_flows(rvu, pcifunc);
+
 	return rvu_cgx_start_stop_io(rvu, pcifunc, false);
 }
 
@@ -3403,6 +3406,8 @@ void rvu_nix_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int nixlf)
 	ctx_req.hdr.pcifunc = pcifunc;
 
 	/* Cleanup NPC MCAM entries, free Tx scheduler queues being used */
+	rvu_npc_disable_mcam_entries(rvu, pcifunc, nixlf);
+	rvu_npc_free_mcam_entries(rvu, pcifunc, nixlf);
 	nix_interface_deinit(rvu, pcifunc, nixlf);
 	nix_rx_sync(rvu, blkaddr);
 	nix_txschq_free(rvu, pcifunc);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index eb4eaa7ece3a..c3ea59909a77 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -219,7 +219,7 @@ static int npc_get_nixlf_mcam_index(struct npc_mcam *mcam,
 	return npc_get_ucast_mcam_index(mcam, pcifunc, nixlf);
 }
 
-static int npc_get_bank(struct npc_mcam *mcam, int index)
+int npc_get_bank(struct npc_mcam *mcam, int index)
 {
 	int bank = index / mcam->banksize;
 
@@ -241,8 +241,8 @@ static bool is_mcam_entry_enabled(struct rvu *rvu, struct npc_mcam *mcam,
 	return (cfg & 1);
 }
 
-static void npc_enable_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
-				  int blkaddr, int index, bool enable)
+void npc_enable_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
+			   int blkaddr, int index, bool enable)
 {
 	int bank = npc_get_bank(mcam, index);
 	int actbank = bank;
@@ -359,6 +359,41 @@ static void npc_get_keyword(struct mcam_entry *entry, int idx,
 	*cam0 = ~*cam1 & kw_mask;
 }
 
+static void npc_get_default_entry_action(struct rvu *rvu, struct npc_mcam *mcam,
+					 int blkaddr, int index,
+					 struct mcam_entry *entry)
+{
+	u16 owner, target_func;
+	struct rvu_pfvf *pfvf;
+	int bank, nixlf;
+	u64 rx_action;
+
+	owner = mcam->entry2pfvf_map[index];
+	target_func = (entry->action >> 4) & 0xffff;
+	/* return incase target is PF or LBK or rule owner is not PF */
+	if (is_afvf(target_func) || (owner & RVU_PFVF_FUNC_MASK) ||
+	    !(target_func & RVU_PFVF_FUNC_MASK))
+		return;
+
+	pfvf = rvu_get_pfvf(rvu, target_func);
+	mcam->entry2target_pffunc[index] = target_func;
+	/* return if nixlf is not attached or initialized */
+	if (!is_nixlf_attached(rvu, target_func) || !pfvf->def_ucast_rule)
+		return;
+
+	/* get VF ucast entry rule */
+	nix_get_nixlf(rvu, target_func, &nixlf, NULL);
+	index = npc_get_nixlf_mcam_index(mcam, target_func,
+					 nixlf, NIXLF_UCAST_ENTRY);
+	bank = npc_get_bank(mcam, index);
+	index &= (mcam->banksize - 1);
+
+	rx_action = rvu_read64(rvu, blkaddr,
+			       NPC_AF_MCAMEX_BANKX_ACTION(index, bank));
+	if (rx_action)
+		entry->action = rx_action;
+}
+
 static void npc_config_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
 				  int blkaddr, int index, u8 intf,
 				  struct mcam_entry *entry, bool enable)
@@ -406,6 +441,11 @@ static void npc_config_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
 			    NPC_AF_MCAMEX_BANKX_CAMX_W1(index, bank, 0), cam0);
 	}
 
+	/* copy VF default entry action to the VF mcam entry */
+	if (intf == NIX_INTF_RX && actindex < mcam->bmap_entries)
+		npc_get_default_entry_action(rvu, mcam, blkaddr, actindex,
+					     entry);
+
 	/* Set 'action' */
 	rvu_write64(rvu, blkaddr,
 		    NPC_AF_MCAMEX_BANKX_ACTION(index, actbank), entry->action);
@@ -473,11 +513,11 @@ void rvu_npc_install_ucast_entry(struct rvu *rvu, u16 pcifunc,
 				 int nixlf, u64 chan, u8 *mac_addr)
 {
 	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
+	struct npc_install_flow_req req = { 0 };
+	struct npc_install_flow_rsp rsp = { 0 };
 	struct npc_mcam *mcam = &rvu->hw->mcam;
-	struct mcam_entry entry = { {0} };
 	struct nix_rx_action action;
-	int blkaddr, index, kwi;
-	u64 mac = 0;
+	int blkaddr, index;
 
 	/* AF's VFs work in promiscuous mode */
 	if (is_afvf(pcifunc))
@@ -487,20 +527,9 @@ void rvu_npc_install_ucast_entry(struct rvu *rvu, u16 pcifunc,
 	if (blkaddr < 0)
 		return;
 
-	for (index = ETH_ALEN - 1; index >= 0; index--)
-		mac |= ((u64)*mac_addr++) << (8 * index);
-
 	index = npc_get_nixlf_mcam_index(mcam, pcifunc,
 					 nixlf, NIXLF_UCAST_ENTRY);
 
-	/* Match ingress channel and DMAC */
-	entry.kw[0] = chan;
-	entry.kw_mask[0] = 0xFFFULL;
-
-	kwi = NPC_PARSE_RESULT_DMAC_OFFSET / sizeof(u64);
-	entry.kw[kwi] = mac;
-	entry.kw_mask[kwi] = BIT_ULL(48) - 1;
-
 	/* Don't change the action if entry is already enabled
 	 * Otherwise RSS action may get overwritten.
 	 */
@@ -513,20 +542,20 @@ void rvu_npc_install_ucast_entry(struct rvu *rvu, u16 pcifunc,
 		action.pf_func = pcifunc;
 	}
 
-	entry.action = *(u64 *)&action;
-	npc_config_mcam_entry(rvu, mcam, blkaddr, index,
-			      pfvf->nix_rx_intf, &entry, true);
-
-	/* add VLAN matching, setup action and save entry back for later */
-	entry.kw[0] |= (NPC_LT_LB_STAG_QINQ | NPC_LT_LB_CTAG) << 20;
-	entry.kw_mask[0] |= (NPC_LT_LB_STAG_QINQ & NPC_LT_LB_CTAG) << 20;
+	req.default_rule = 1;
+	ether_addr_copy(req.packet.dmac, mac_addr);
+	eth_broadcast_addr((u8 *)&req.mask.dmac);
+	req.features = BIT_ULL(NPC_DMAC);
+	req.channel = chan;
+	req.intf = pfvf->nix_rx_intf;
+	req.op = action.op;
+	req.hdr.pcifunc = 0; /* AF is requester */
+	req.vf = action.pf_func;
+	req.index = action.index;
+	req.match_id = action.match_id;
+	req.flow_key_alg = action.flow_key_alg;
 
-	entry.vtag_action = VTAG0_VALID_BIT |
-			    FIELD_PREP(VTAG0_TYPE_MASK, 0) |
-			    FIELD_PREP(VTAG0_LID_MASK, NPC_LID_LA) |
-			    FIELD_PREP(VTAG0_RELPTR_MASK, 12);
-
-	memcpy(&pfvf->entry, &entry, sizeof(entry));
+	rvu_mbox_handler_npc_install_flow(rvu, &req, &rsp);
 }
 
 void rvu_npc_install_promisc_entry(struct rvu *rvu, u16 pcifunc,
@@ -682,12 +711,47 @@ void rvu_npc_enable_bcast_entry(struct rvu *rvu, u16 pcifunc, bool enable)
 	npc_enable_mcam_entry(rvu, mcam, blkaddr, index, enable);
 }
 
+static void npc_update_vf_flow_entry(struct rvu *rvu, struct npc_mcam *mcam,
+				     int blkaddr, u16 pcifunc, u64 rx_action)
+{
+	int actindex, index, bank;
+	bool enable;
+
+	if (!(pcifunc & RVU_PFVF_FUNC_MASK))
+		return;
+
+	mutex_lock(&mcam->lock);
+	for (index = 0; index < mcam->bmap_entries; index++) {
+		if (mcam->entry2target_pffunc[index] == pcifunc) {
+			bank = npc_get_bank(mcam, index);
+			actindex = index;
+			index &= (mcam->banksize - 1);
+
+			/* read vf flow entry enable status */
+			enable = is_mcam_entry_enabled(rvu, mcam, blkaddr,
+						       actindex);
+			/* disable before mcam entry update */
+			npc_enable_mcam_entry(rvu, mcam, blkaddr, actindex,
+					      false);
+			/* update 'action' */
+			rvu_write64(rvu, blkaddr,
+				    NPC_AF_MCAMEX_BANKX_ACTION(index, bank),
+				    rx_action);
+			if (enable)
+				npc_enable_mcam_entry(rvu, mcam, blkaddr,
+						      actindex, true);
+		}
+	}
+	mutex_unlock(&mcam->lock);
+}
+
 void rvu_npc_update_flowkey_alg_idx(struct rvu *rvu, u16 pcifunc, int nixlf,
 				    int group, int alg_idx, int mcam_index)
 {
 	struct npc_mcam *mcam = &rvu->hw->mcam;
 	struct nix_rx_action action;
 	int blkaddr, index, bank;
+	struct rvu_pfvf *pfvf;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
 	if (blkaddr < 0)
@@ -724,6 +788,16 @@ void rvu_npc_update_flowkey_alg_idx(struct rvu *rvu, u16 pcifunc, int nixlf,
 	rvu_write64(rvu, blkaddr,
 		    NPC_AF_MCAMEX_BANKX_ACTION(index, bank), *(u64 *)&action);
 
+	/* update the VF flow rule action with the VF default entry action */
+	if (mcam_index < 0)
+		npc_update_vf_flow_entry(rvu, mcam, blkaddr, pcifunc,
+					 *(u64 *)&action);
+
+	/* update the action change in default rule */
+	pfvf = rvu_get_pfvf(rvu, pcifunc);
+	if (pfvf->def_ucast_rule)
+		pfvf->def_ucast_rule->rx_action = action;
+
 	index = npc_get_nixlf_mcam_index(mcam, pcifunc,
 					 nixlf, NIXLF_PROMISC_ENTRY);
 
@@ -738,8 +812,6 @@ void rvu_npc_update_flowkey_alg_idx(struct rvu *rvu, u16 pcifunc, int nixlf,
 			    NPC_AF_MCAMEX_BANKX_ACTION(index, bank),
 			    *(u64 *)&action);
 	}
-
-	rvu_npc_update_rxvlan(rvu, pcifunc, nixlf);
 }
 
 static void npc_enadis_default_entries(struct rvu *rvu, u16 pcifunc,
@@ -791,8 +863,6 @@ static void npc_enadis_default_entries(struct rvu *rvu, u16 pcifunc,
 		rvu_npc_enable_promisc_entry(rvu, pcifunc, nixlf);
 	else
 		rvu_npc_disable_promisc_entry(rvu, pcifunc, nixlf);
-
-	rvu_npc_update_rxvlan(rvu, pcifunc, nixlf);
 }
 
 void rvu_npc_disable_default_entries(struct rvu *rvu, u16 pcifunc, int nixlf)
@@ -807,7 +877,9 @@ void rvu_npc_enable_default_entries(struct rvu *rvu, u16 pcifunc, int nixlf)
 
 void rvu_npc_disable_mcam_entries(struct rvu *rvu, u16 pcifunc, int nixlf)
 {
+	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
 	struct npc_mcam *mcam = &rvu->hw->mcam;
+	struct rvu_npc_mcam_rule *rule;
 	int blkaddr;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
@@ -816,12 +888,52 @@ void rvu_npc_disable_mcam_entries(struct rvu *rvu, u16 pcifunc, int nixlf)
 
 	mutex_lock(&mcam->lock);
 
-	/* Disable and free all MCAM entries mapped to this 'pcifunc' */
+	/* Disable MCAM entries directing traffic to this 'pcifunc' */
+	list_for_each_entry(rule, &mcam->mcam_rules, list) {
+		if (is_npc_intf_rx(rule->intf) &&
+		    rule->rx_action.pf_func == pcifunc) {
+			npc_enable_mcam_entry(rvu, mcam, blkaddr,
+					      rule->entry, false);
+			rule->enable = false;
+			/* Indicate that default rule is disabled */
+			if (rule->default_rule)
+				pfvf->def_ucast_rule = NULL;
+		}
+	}
+
+	mutex_unlock(&mcam->lock);
+
+	npc_mcam_disable_flows(rvu, pcifunc);
+
+	rvu_npc_disable_default_entries(rvu, pcifunc, nixlf);
+}
+
+void rvu_npc_free_mcam_entries(struct rvu *rvu, u16 pcifunc, int nixlf)
+{
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+	struct rvu_npc_mcam_rule *rule, *tmp;
+	int blkaddr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
+	if (blkaddr < 0)
+		return;
+
+	mutex_lock(&mcam->lock);
+
+	/* Free all MCAM entries owned by this 'pcifunc' */
 	npc_mcam_free_all_entries(rvu, mcam, blkaddr, pcifunc);
 
-	/* Free all MCAM counters mapped to this 'pcifunc' */
+	/* Free all MCAM counters owned by this 'pcifunc' */
 	npc_mcam_free_all_counters(rvu, mcam, pcifunc);
 
+	/* Delete MCAM entries owned by this 'pcifunc' */
+	list_for_each_entry_safe(rule, tmp, &mcam->mcam_rules, list) {
+		if (rule->owner == pcifunc && !rule->default_rule) {
+			list_del(&rule->list);
+			kfree(rule);
+		}
+	}
+
 	mutex_unlock(&mcam->lock);
 
 	rvu_npc_disable_default_entries(rvu, pcifunc, nixlf);
@@ -1231,6 +1343,12 @@ static int npc_mcam_rsrcs_init(struct rvu *rvu, int blkaddr)
 	if (!mcam->cntr_refcnt)
 		goto free_mem;
 
+	/* Alloc memory for saving target device of mcam rule */
+	mcam->entry2target_pffunc = devm_kcalloc(rvu->dev, mcam->total_entries,
+						 sizeof(u16), GFP_KERNEL);
+	if (!mcam->entry2target_pffunc)
+		goto free_mem;
+
 	mutex_init(&mcam->lock);
 
 	return 0;
@@ -1580,6 +1698,7 @@ static void npc_mcam_free_all_entries(struct rvu *rvu, struct npc_mcam *mcam,
 				npc_unmap_mcam_entry_and_cntr(rvu, mcam,
 							      blkaddr, index,
 							      cntr);
+			mcam->entry2target_pffunc[index] = 0x0;
 		}
 	}
 }
@@ -1966,6 +2085,7 @@ int rvu_mbox_handler_npc_mcam_free_entry(struct rvu *rvu,
 		goto exit;
 
 	mcam->entry2pfvf_map[req->entry] = 0;
+	mcam->entry2target_pffunc[req->entry] = 0x0;
 	npc_mcam_clear_bit(mcam, req->entry);
 	npc_enable_mcam_entry(rvu, mcam, blkaddr, req->entry, false);
 
@@ -2521,3 +2641,27 @@ int rvu_npc_update_rxvlan(struct rvu *rvu, u16 pcifunc, int nixlf)
 
 	return 0;
 }
+
+bool rvu_npc_write_default_rule(struct rvu *rvu, int blkaddr, int nixlf,
+				u16 pcifunc, u8 intf, struct mcam_entry *entry,
+				int *index)
+{
+	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+	bool enable;
+	u8 nix_intf;
+
+	if (is_npc_intf_tx(intf))
+		nix_intf = pfvf->nix_tx_intf;
+	else
+		nix_intf = pfvf->nix_rx_intf;
+
+	*index = npc_get_nixlf_mcam_index(mcam, pcifunc,
+					  nixlf, NIXLF_UCAST_ENTRY);
+	/* dont force enable unicast entry  */
+	enable = is_mcam_entry_enabled(rvu, mcam, blkaddr, *index);
+	npc_config_mcam_entry(rvu, mcam, blkaddr, *index, nix_intf,
+			      entry, enable);
+
+	return enable;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index c618854f0830..8dadb399197b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -558,5 +558,726 @@ static int npc_scan_verify_kex(struct rvu *rvu, int blkaddr)
 
 int npc_flow_steering_init(struct rvu *rvu, int blkaddr)
 {
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+
+	INIT_LIST_HEAD(&mcam->mcam_rules);
+
 	return npc_scan_verify_kex(rvu, blkaddr);
 }
+
+static int npc_check_unsupported_flows(struct rvu *rvu, u64 features, u8 intf)
+{
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+	u64 *mcam_features = &mcam->rx_features;
+	u64 unsupported;
+	u8 bit;
+
+	if (is_npc_intf_tx(intf))
+		mcam_features = &mcam->tx_features;
+
+	unsupported = (*mcam_features ^ features) & ~(*mcam_features);
+	if (unsupported) {
+		dev_info(rvu->dev, "Unsupported flow(s):\n");
+		for_each_set_bit(bit, (unsigned long *)&unsupported, 64)
+			dev_info(rvu->dev, "%s ", npc_get_field_name(bit));
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+/* npc_update_entry - Based on the masks generated during
+ * the key scanning, updates the given entry with value and
+ * masks for the field of interest. Maximum 16 bytes of a packet
+ * header can be extracted by HW hence lo and hi are sufficient.
+ * When field bytes are less than or equal to 8 then hi should be
+ * 0 for value and mask.
+ *
+ * If exact match of value is required then mask should be all 1's.
+ * If any bits in mask are 0 then corresponding bits in value are
+ * dont care.
+ */
+static void npc_update_entry(struct rvu *rvu, enum key_fields type,
+			     struct mcam_entry *entry, u64 val_lo,
+			     u64 val_hi, u64 mask_lo, u64 mask_hi, u8 intf)
+{
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+	struct mcam_entry dummy = { {0} };
+	struct npc_key_field *field;
+	u64 kw1, kw2, kw3;
+	u8 shift;
+	int i;
+
+	field = &mcam->rx_key_fields[type];
+	if (is_npc_intf_tx(intf))
+		field = &mcam->tx_key_fields[type];
+
+	if (!field->nr_kws)
+		return;
+
+	for (i = 0; i < NPC_MAX_KWS_IN_KEY; i++) {
+		if (!field->kw_mask[i])
+			continue;
+		/* place key value in kw[x] */
+		shift = __ffs64(field->kw_mask[i]);
+		/* update entry value */
+		kw1 = (val_lo << shift) & field->kw_mask[i];
+		dummy.kw[i] = kw1;
+		/* update entry mask */
+		kw1 = (mask_lo << shift) & field->kw_mask[i];
+		dummy.kw_mask[i] = kw1;
+
+		if (field->nr_kws == 1)
+			break;
+		/* place remaining bits of key value in kw[x + 1] */
+		if (field->nr_kws == 2) {
+			/* update entry value */
+			kw2 = shift ? val_lo >> (64 - shift) : 0;
+			kw2 |= (val_hi << shift);
+			kw2 &= field->kw_mask[i + 1];
+			dummy.kw[i + 1] = kw2;
+			/* update entry mask */
+			kw2 = shift ? mask_lo >> (64 - shift) : 0;
+			kw2 |= (mask_hi << shift);
+			kw2 &= field->kw_mask[i + 1];
+			dummy.kw_mask[i + 1] = kw2;
+			break;
+		}
+		/* place remaining bits of key value in kw[x + 1], kw[x + 2] */
+		if (field->nr_kws == 3) {
+			/* update entry value */
+			kw2 = shift ? val_lo >> (64 - shift) : 0;
+			kw2 |= (val_hi << shift);
+			kw2 &= field->kw_mask[i + 1];
+			kw3 = shift ? val_hi >> (64 - shift) : 0;
+			kw3 &= field->kw_mask[i + 2];
+			dummy.kw[i + 1] = kw2;
+			dummy.kw[i + 2] = kw3;
+			/* update entry mask */
+			kw2 = shift ? mask_lo >> (64 - shift) : 0;
+			kw2 |= (mask_hi << shift);
+			kw2 &= field->kw_mask[i + 1];
+			kw3 = shift ? mask_hi >> (64 - shift) : 0;
+			kw3 &= field->kw_mask[i + 2];
+			dummy.kw_mask[i + 1] = kw2;
+			dummy.kw_mask[i + 2] = kw3;
+			break;
+		}
+	}
+	/* dummy is ready with values and masks for given key
+	 * field now clear and update input entry with those
+	 */
+	for (i = 0; i < NPC_MAX_KWS_IN_KEY; i++) {
+		if (!field->kw_mask[i])
+			continue;
+		entry->kw[i] &= ~field->kw_mask[i];
+		entry->kw_mask[i] &= ~field->kw_mask[i];
+
+		entry->kw[i] |= dummy.kw[i];
+		entry->kw_mask[i] |= dummy.kw_mask[i];
+	}
+}
+
+#define IPV6_WORDS     4
+
+static void npc_update_ipv6_flow(struct rvu *rvu, struct mcam_entry *entry,
+				 u64 features, struct flow_msg *pkt,
+				 struct flow_msg *mask,
+				 struct rvu_npc_mcam_rule *output, u8 intf)
+{
+	u32 src_ip[IPV6_WORDS], src_ip_mask[IPV6_WORDS];
+	u32 dst_ip[IPV6_WORDS], dst_ip_mask[IPV6_WORDS];
+	struct flow_msg *opkt = &output->packet;
+	struct flow_msg *omask = &output->mask;
+	u64 mask_lo, mask_hi;
+	u64 val_lo, val_hi;
+
+	/* For an ipv6 address fe80::2c68:63ff:fe5e:2d0a the packet
+	 * values to be programmed in MCAM should as below:
+	 * val_high: 0xfe80000000000000
+	 * val_low: 0x2c6863fffe5e2d0a
+	 */
+	if (features & BIT_ULL(NPC_SIP_IPV6)) {
+		be32_to_cpu_array(src_ip_mask, mask->ip6src, IPV6_WORDS);
+		be32_to_cpu_array(src_ip, pkt->ip6src, IPV6_WORDS);
+
+		mask_hi = (u64)src_ip_mask[0] << 32 | src_ip_mask[1];
+		mask_lo = (u64)src_ip_mask[2] << 32 | src_ip_mask[3];
+		val_hi = (u64)src_ip[0] << 32 | src_ip[1];
+		val_lo = (u64)src_ip[2] << 32 | src_ip[3];
+
+		npc_update_entry(rvu, NPC_SIP_IPV6, entry, val_lo, val_hi,
+				 mask_lo, mask_hi, intf);
+		memcpy(opkt->ip6src, pkt->ip6src, sizeof(opkt->ip6src));
+		memcpy(omask->ip6src, mask->ip6src, sizeof(omask->ip6src));
+	}
+	if (features & BIT_ULL(NPC_DIP_IPV6)) {
+		be32_to_cpu_array(dst_ip_mask, mask->ip6dst, IPV6_WORDS);
+		be32_to_cpu_array(dst_ip, pkt->ip6dst, IPV6_WORDS);
+
+		mask_hi = (u64)dst_ip_mask[0] << 32 | dst_ip_mask[1];
+		mask_lo = (u64)dst_ip_mask[2] << 32 | dst_ip_mask[3];
+		val_hi = (u64)dst_ip[0] << 32 | dst_ip[1];
+		val_lo = (u64)dst_ip[2] << 32 | dst_ip[3];
+
+		npc_update_entry(rvu, NPC_DIP_IPV6, entry, val_lo, val_hi,
+				 mask_lo, mask_hi, intf);
+		memcpy(opkt->ip6dst, pkt->ip6dst, sizeof(opkt->ip6dst));
+		memcpy(omask->ip6dst, mask->ip6dst, sizeof(omask->ip6dst));
+	}
+}
+
+static void npc_update_flow(struct rvu *rvu, struct mcam_entry *entry,
+			    u64 features, struct flow_msg *pkt,
+			    struct flow_msg *mask,
+			    struct rvu_npc_mcam_rule *output, u8 intf)
+{
+	u64 dmac_mask = ether_addr_to_u64(mask->dmac);
+	u64 smac_mask = ether_addr_to_u64(mask->smac);
+	u64 dmac_val = ether_addr_to_u64(pkt->dmac);
+	u64 smac_val = ether_addr_to_u64(pkt->smac);
+	struct flow_msg *opkt = &output->packet;
+	struct flow_msg *omask = &output->mask;
+
+	if (!features)
+		return;
+
+	/* For tcp/udp/sctp LTYPE should be present in entry */
+	if (features & (BIT_ULL(NPC_SPORT_TCP) | BIT_ULL(NPC_DPORT_TCP)))
+		npc_update_entry(rvu, NPC_LD, entry, NPC_LT_LD_TCP,
+				 0, ~0ULL, 0, intf);
+	if (features & (BIT_ULL(NPC_SPORT_UDP) | BIT_ULL(NPC_DPORT_UDP)))
+		npc_update_entry(rvu, NPC_LD, entry, NPC_LT_LD_UDP,
+				 0, ~0ULL, 0, intf);
+	if (features & (BIT_ULL(NPC_SPORT_SCTP) | BIT_ULL(NPC_DPORT_SCTP)))
+		npc_update_entry(rvu, NPC_LD, entry, NPC_LT_LD_SCTP,
+				 0, ~0ULL, 0, intf);
+
+	if (features & BIT_ULL(NPC_OUTER_VID))
+		npc_update_entry(rvu, NPC_LB, entry,
+				 NPC_LT_LB_STAG_QINQ | NPC_LT_LB_CTAG, 0,
+				 NPC_LT_LB_STAG_QINQ & NPC_LT_LB_CTAG, 0, intf);
+
+#define NPC_WRITE_FLOW(field, member, val_lo, val_hi, mask_lo, mask_hi)	      \
+do {									      \
+	if (features & BIT_ULL((field))) {				      \
+		npc_update_entry(rvu, (field), entry, (val_lo), (val_hi),     \
+				 (mask_lo), (mask_hi), intf);		      \
+		memcpy(&opkt->member, &pkt->member, sizeof(pkt->member));     \
+		memcpy(&omask->member, &mask->member, sizeof(mask->member));  \
+	}								      \
+} while (0)
+
+	NPC_WRITE_FLOW(NPC_DMAC, dmac, dmac_val, 0, dmac_mask, 0);
+	NPC_WRITE_FLOW(NPC_SMAC, smac, smac_val, 0, smac_mask, 0);
+	NPC_WRITE_FLOW(NPC_ETYPE, etype, ntohs(pkt->etype), 0,
+		       ntohs(mask->etype), 0);
+	NPC_WRITE_FLOW(NPC_SIP_IPV4, ip4src, ntohl(pkt->ip4src), 0,
+		       ntohl(mask->ip4src), 0);
+	NPC_WRITE_FLOW(NPC_DIP_IPV4, ip4dst, ntohl(pkt->ip4dst), 0,
+		       ntohl(mask->ip4dst), 0);
+	NPC_WRITE_FLOW(NPC_SPORT_TCP, sport, ntohs(pkt->sport), 0,
+		       ntohs(mask->sport), 0);
+	NPC_WRITE_FLOW(NPC_SPORT_UDP, sport, ntohs(pkt->sport), 0,
+		       ntohs(mask->sport), 0);
+	NPC_WRITE_FLOW(NPC_DPORT_TCP, dport, ntohs(pkt->dport), 0,
+		       ntohs(mask->dport), 0);
+	NPC_WRITE_FLOW(NPC_DPORT_UDP, dport, ntohs(pkt->dport), 0,
+		       ntohs(mask->dport), 0);
+	NPC_WRITE_FLOW(NPC_SPORT_SCTP, sport, ntohs(pkt->sport), 0,
+		       ntohs(mask->sport), 0);
+	NPC_WRITE_FLOW(NPC_DPORT_SCTP, dport, ntohs(pkt->dport), 0,
+		       ntohs(mask->dport), 0);
+
+	NPC_WRITE_FLOW(NPC_OUTER_VID, vlan_tci, ntohs(pkt->vlan_tci), 0,
+		       ntohs(mask->vlan_tci), 0);
+
+	npc_update_ipv6_flow(rvu, entry, features, pkt, mask, output, intf);
+}
+
+static struct rvu_npc_mcam_rule *rvu_mcam_find_rule(struct npc_mcam *mcam,
+						    u16 entry)
+{
+	struct rvu_npc_mcam_rule *iter;
+
+	mutex_lock(&mcam->lock);
+	list_for_each_entry(iter, &mcam->mcam_rules, list) {
+		if (iter->entry == entry) {
+			mutex_unlock(&mcam->lock);
+			return iter;
+		}
+	}
+	mutex_unlock(&mcam->lock);
+
+	return NULL;
+}
+
+static void rvu_mcam_add_rule(struct npc_mcam *mcam,
+			      struct rvu_npc_mcam_rule *rule)
+{
+	struct list_head *head = &mcam->mcam_rules;
+	struct rvu_npc_mcam_rule *iter;
+
+	mutex_lock(&mcam->lock);
+	list_for_each_entry(iter, &mcam->mcam_rules, list) {
+		if (iter->entry > rule->entry)
+			break;
+		head = &iter->list;
+	}
+
+	list_add(&rule->list, head);
+	mutex_unlock(&mcam->lock);
+}
+
+static void rvu_mcam_remove_counter_from_rule(struct rvu *rvu, u16 pcifunc,
+					      struct rvu_npc_mcam_rule *rule)
+{
+	struct npc_mcam_oper_counter_req free_req = { 0 };
+	struct msg_rsp free_rsp;
+
+	if (!rule->has_cntr)
+		return;
+
+	free_req.hdr.pcifunc = pcifunc;
+	free_req.cntr = rule->cntr;
+
+	rvu_mbox_handler_npc_mcam_free_counter(rvu, &free_req, &free_rsp);
+	rule->has_cntr = false;
+}
+
+static void rvu_mcam_add_counter_to_rule(struct rvu *rvu, u16 pcifunc,
+					 struct rvu_npc_mcam_rule *rule,
+					 struct npc_install_flow_rsp *rsp)
+{
+	struct npc_mcam_alloc_counter_req cntr_req = { 0 };
+	struct npc_mcam_alloc_counter_rsp cntr_rsp = { 0 };
+	int err;
+
+	cntr_req.hdr.pcifunc = pcifunc;
+	cntr_req.contig = true;
+	cntr_req.count = 1;
+
+	/* we try to allocate a counter to track the stats of this
+	 * rule. If counter could not be allocated then proceed
+	 * without counter because counters are limited than entries.
+	 */
+	err = rvu_mbox_handler_npc_mcam_alloc_counter(rvu, &cntr_req,
+						      &cntr_rsp);
+	if (!err && cntr_rsp.count) {
+		rule->cntr = cntr_rsp.cntr;
+		rule->has_cntr = true;
+		rsp->counter = rule->cntr;
+	} else {
+		rsp->counter = err;
+	}
+}
+
+static void npc_update_rx_entry(struct rvu *rvu, struct rvu_pfvf *pfvf,
+				struct mcam_entry *entry,
+				struct npc_install_flow_req *req, u16 target)
+{
+	struct nix_rx_action action;
+
+	npc_update_entry(rvu, NPC_CHAN, entry, req->channel, 0,
+			 ~0ULL, 0, NIX_INTF_RX);
+
+	*(u64 *)&action = 0x00;
+	action.pf_func = target;
+	action.op = req->op;
+	action.index = req->index;
+	action.match_id = req->match_id;
+	action.flow_key_alg = req->flow_key_alg;
+
+	if (req->op == NIX_RX_ACTION_DEFAULT && pfvf->def_ucast_rule)
+		action = pfvf->def_ucast_rule->rx_action;
+
+	entry->action = *(u64 *)&action;
+
+	/* VTAG0 starts at 0th byte of LID_B.
+	 * VTAG1 starts at 4th byte of LID_B.
+	 */
+	entry->vtag_action = FIELD_PREP(RX_VTAG0_VALID_BIT, req->vtag0_valid) |
+			     FIELD_PREP(RX_VTAG0_TYPE_MASK, req->vtag0_type) |
+			     FIELD_PREP(RX_VTAG0_LID_MASK, NPC_LID_LB) |
+			     FIELD_PREP(RX_VTAG0_RELPTR_MASK, 0) |
+			     FIELD_PREP(RX_VTAG1_VALID_BIT, req->vtag1_valid) |
+			     FIELD_PREP(RX_VTAG1_TYPE_MASK, req->vtag1_type) |
+			     FIELD_PREP(RX_VTAG1_LID_MASK, NPC_LID_LB) |
+			     FIELD_PREP(RX_VTAG1_RELPTR_MASK, 4);
+}
+
+static void npc_update_tx_entry(struct rvu *rvu, struct rvu_pfvf *pfvf,
+				struct mcam_entry *entry,
+				struct npc_install_flow_req *req, u16 target)
+{
+	struct nix_tx_action action;
+
+	npc_update_entry(rvu, NPC_PF_FUNC, entry, (__force u16)htons(target),
+			 0, ~0ULL, 0, NIX_INTF_TX);
+
+	*(u64 *)&action = 0x00;
+	action.op = req->op;
+	action.index = req->index;
+	action.match_id = req->match_id;
+
+	entry->action = *(u64 *)&action;
+
+	/* VTAG0 starts at 0th byte of LID_B.
+	 * VTAG1 starts at 4th byte of LID_B.
+	 */
+	entry->vtag_action = FIELD_PREP(TX_VTAG0_DEF_MASK, req->vtag0_def) |
+			     FIELD_PREP(TX_VTAG0_OP_MASK, req->vtag0_op) |
+			     FIELD_PREP(TX_VTAG0_LID_MASK, NPC_LID_LA) |
+			     FIELD_PREP(TX_VTAG0_RELPTR_MASK, 20) |
+			     FIELD_PREP(TX_VTAG1_DEF_MASK, req->vtag1_def) |
+			     FIELD_PREP(TX_VTAG1_OP_MASK, req->vtag1_op) |
+			     FIELD_PREP(TX_VTAG1_LID_MASK, NPC_LID_LA) |
+			     FIELD_PREP(TX_VTAG1_RELPTR_MASK, 24);
+}
+
+static int npc_install_flow(struct rvu *rvu, int blkaddr, u16 target,
+			    int nixlf, struct rvu_pfvf *pfvf,
+			    struct npc_install_flow_req *req,
+			    struct npc_install_flow_rsp *rsp, bool enable)
+{
+	struct rvu_npc_mcam_rule *def_ucast_rule = pfvf->def_ucast_rule;
+	u64 features, installed_features, missing_features = 0;
+	struct npc_mcam_write_entry_req write_req = { 0 };
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+	struct rvu_npc_mcam_rule dummy = { 0 };
+	struct rvu_npc_mcam_rule *rule;
+	bool new = false, msg_from_vf;
+	u16 owner = req->hdr.pcifunc;
+	struct msg_rsp write_rsp;
+	struct mcam_entry *entry;
+	int entry_index, err;
+
+	msg_from_vf = !!(owner & RVU_PFVF_FUNC_MASK);
+
+	installed_features = req->features;
+	features = req->features;
+	entry = &write_req.entry_data;
+	entry_index = req->entry;
+
+	npc_update_flow(rvu, entry, features, &req->packet, &req->mask, &dummy,
+			req->intf);
+
+	if (is_npc_intf_rx(req->intf))
+		npc_update_rx_entry(rvu, pfvf, entry, req, target);
+	else
+		npc_update_tx_entry(rvu, pfvf, entry, req, target);
+
+	/* Default unicast rules do not exist for TX */
+	if (is_npc_intf_tx(req->intf))
+		goto find_rule;
+
+	if (def_ucast_rule)
+		missing_features = (def_ucast_rule->features ^ features) &
+					def_ucast_rule->features;
+
+	if (req->default_rule && req->append) {
+		/* add to default rule */
+		if (missing_features)
+			npc_update_flow(rvu, entry, missing_features,
+					&def_ucast_rule->packet,
+					&def_ucast_rule->mask,
+					&dummy, req->intf);
+		enable = rvu_npc_write_default_rule(rvu, blkaddr,
+						    nixlf, target,
+						    pfvf->nix_rx_intf, entry,
+						    &entry_index);
+		installed_features = req->features | missing_features;
+	} else if (req->default_rule && !req->append) {
+		/* overwrite default rule */
+		enable = rvu_npc_write_default_rule(rvu, blkaddr,
+						    nixlf, target,
+						    pfvf->nix_rx_intf, entry,
+						    &entry_index);
+	} else if (msg_from_vf) {
+		/* normal rule - include default rule also to it for VF */
+		npc_update_flow(rvu, entry, missing_features,
+				&def_ucast_rule->packet, &def_ucast_rule->mask,
+				&dummy, req->intf);
+		installed_features = req->features | missing_features;
+	}
+
+find_rule:
+	rule = rvu_mcam_find_rule(mcam, entry_index);
+	if (!rule) {
+		rule = kzalloc(sizeof(*rule), GFP_KERNEL);
+		if (!rule)
+			return -ENOMEM;
+		new = true;
+	}
+	/* no counter for default rule */
+	if (req->default_rule)
+		goto update_rule;
+
+	/* allocate new counter if rule has no counter */
+	if (req->set_cntr && !rule->has_cntr)
+		rvu_mcam_add_counter_to_rule(rvu, owner, rule, rsp);
+
+	/* if user wants to delete an existing counter for a rule then
+	 * free the counter
+	 */
+	if (!req->set_cntr && rule->has_cntr)
+		rvu_mcam_remove_counter_from_rule(rvu, owner, rule);
+
+	write_req.hdr.pcifunc = owner;
+	write_req.entry = req->entry;
+	write_req.intf = req->intf;
+	write_req.enable_entry = (u8)enable;
+	/* if counter is available then clear and use it */
+	if (req->set_cntr && rule->has_cntr) {
+		rvu_write64(rvu, blkaddr, NPC_AF_MATCH_STATX(rule->cntr), 0x00);
+		write_req.set_cntr = 1;
+		write_req.cntr = rule->cntr;
+	}
+
+	err = rvu_mbox_handler_npc_mcam_write_entry(rvu, &write_req,
+						    &write_rsp);
+	if (err) {
+		rvu_mcam_remove_counter_from_rule(rvu, owner, rule);
+		if (new)
+			kfree(rule);
+		return err;
+	}
+update_rule:
+	memcpy(&rule->packet, &dummy.packet, sizeof(rule->packet));
+	memcpy(&rule->mask, &dummy.mask, sizeof(rule->mask));
+	rule->entry = entry_index;
+	memcpy(&rule->rx_action, &entry->action, sizeof(struct nix_rx_action));
+	if (is_npc_intf_tx(req->intf))
+		memcpy(&rule->tx_action, &entry->action,
+		       sizeof(struct nix_tx_action));
+	rule->vtag_action = entry->vtag_action;
+	rule->features = installed_features;
+	rule->default_rule = req->default_rule;
+	rule->owner = owner;
+	rule->enable = enable;
+	if (is_npc_intf_tx(req->intf))
+		rule->intf = pfvf->nix_tx_intf;
+	else
+		rule->intf = pfvf->nix_rx_intf;
+
+	if (new)
+		rvu_mcam_add_rule(mcam, rule);
+	if (req->default_rule)
+		pfvf->def_ucast_rule = rule;
+
+	return 0;
+}
+
+int rvu_mbox_handler_npc_install_flow(struct rvu *rvu,
+				      struct npc_install_flow_req *req,
+				      struct npc_install_flow_rsp *rsp)
+{
+	bool from_vf = !!(req->hdr.pcifunc & RVU_PFVF_FUNC_MASK);
+	int blkaddr, nixlf, err;
+	struct rvu_pfvf *pfvf;
+	bool enable = true;
+	u16 target;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
+	if (blkaddr < 0) {
+		dev_err(rvu->dev, "%s: NPC block not implemented\n", __func__);
+		return -ENODEV;
+	}
+
+	if (!is_npc_interface_valid(rvu, req->intf))
+		return -EINVAL;
+
+	if (from_vf && req->default_rule)
+		return NPC_MCAM_PERM_DENIED;
+
+	/* Each PF/VF info is maintained in struct rvu_pfvf.
+	 * rvu_pfvf for the target PF/VF needs to be retrieved
+	 * hence modify pcifunc accordingly.
+	 */
+
+	/* AF installing for a PF/VF */
+	if (!req->hdr.pcifunc)
+		target = req->vf;
+	/* PF installing for its VF */
+	else if (!from_vf && req->vf)
+		target = (req->hdr.pcifunc & ~RVU_PFVF_FUNC_MASK) | req->vf;
+	/* msg received from PF/VF */
+	else
+		target = req->hdr.pcifunc;
+
+	if (npc_check_unsupported_flows(rvu, req->features, req->intf))
+		return -EOPNOTSUPP;
+
+	if (npc_mcam_verify_channel(rvu, target, req->intf, req->channel))
+		return -EINVAL;
+
+	pfvf = rvu_get_pfvf(rvu, target);
+
+	/* update req destination mac addr */
+	if ((req->features & BIT_ULL(NPC_DMAC)) && is_npc_intf_rx(req->intf) &&
+	    is_zero_ether_addr(req->packet.dmac)) {
+		ether_addr_copy(req->packet.dmac, pfvf->mac_addr);
+		eth_broadcast_addr((u8 *)&req->mask.dmac);
+	}
+
+	err = nix_get_nixlf(rvu, target, &nixlf, NULL);
+
+	/* If interface is uninitialized then do not enable entry */
+	if (err || (!req->default_rule && !pfvf->def_ucast_rule))
+		enable = false;
+
+	/* Packets reaching NPC in Tx path implies that a
+	 * NIXLF is properly setup and transmitting.
+	 * Hence rules can be enabled for Tx.
+	 */
+	if (is_npc_intf_tx(req->intf))
+		enable = true;
+
+	/* Do not allow requests from uninitialized VFs */
+	if (from_vf && !enable)
+		return -EINVAL;
+
+	/* If message is from VF then its flow should not overlap with
+	 * reserved unicast flow.
+	 */
+	if (from_vf && pfvf->def_ucast_rule && is_npc_intf_rx(req->intf) &&
+	    pfvf->def_ucast_rule->features & req->features)
+		return -EINVAL;
+
+	return npc_install_flow(rvu, blkaddr, target, nixlf, pfvf, req, rsp,
+				enable);
+}
+
+static int npc_delete_flow(struct rvu *rvu, struct rvu_npc_mcam_rule *rule,
+			   u16 pcifunc)
+{
+	struct npc_mcam_ena_dis_entry_req dis_req = { 0 };
+	struct msg_rsp dis_rsp;
+
+	if (rule->default_rule)
+		return 0;
+
+	if (rule->has_cntr)
+		rvu_mcam_remove_counter_from_rule(rvu, pcifunc, rule);
+
+	dis_req.hdr.pcifunc = pcifunc;
+	dis_req.entry = rule->entry;
+
+	list_del(&rule->list);
+	kfree(rule);
+
+	return rvu_mbox_handler_npc_mcam_dis_entry(rvu, &dis_req, &dis_rsp);
+}
+
+int rvu_mbox_handler_npc_delete_flow(struct rvu *rvu,
+				     struct npc_delete_flow_req *req,
+				     struct msg_rsp *rsp)
+{
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+	struct rvu_npc_mcam_rule *iter, *tmp;
+	u16 pcifunc = req->hdr.pcifunc;
+	struct list_head del_list;
+
+	INIT_LIST_HEAD(&del_list);
+
+	mutex_lock(&mcam->lock);
+	list_for_each_entry_safe(iter, tmp, &mcam->mcam_rules, list) {
+		if (iter->owner == pcifunc) {
+			/* All rules */
+			if (req->all) {
+				list_move_tail(&iter->list, &del_list);
+			/* Range of rules */
+			} else if (req->end && iter->entry >= req->start &&
+				   iter->entry <= req->end) {
+				list_move_tail(&iter->list, &del_list);
+			/* single rule */
+			} else if (req->entry == iter->entry) {
+				list_move_tail(&iter->list, &del_list);
+				break;
+			}
+		}
+	}
+	mutex_unlock(&mcam->lock);
+
+	list_for_each_entry_safe(iter, tmp, &del_list, list) {
+		/* clear the mcam entry target pcifunc */
+		mcam->entry2target_pffunc[iter->entry] = 0x0;
+		if (npc_delete_flow(rvu, iter, pcifunc))
+			dev_err(rvu->dev, "rule deletion failed for entry:%d",
+				iter->entry);
+	}
+
+	return 0;
+}
+
+void npc_mcam_enable_flows(struct rvu *rvu, u16 target)
+{
+	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, target);
+	struct rvu_npc_mcam_rule *def_ucast_rule;
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+	struct rvu_npc_mcam_rule *rule;
+	int blkaddr, bank, index;
+	u64 def_action;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
+	if (blkaddr < 0)
+		return;
+
+	def_ucast_rule = pfvf->def_ucast_rule;
+
+	mutex_lock(&mcam->lock);
+	list_for_each_entry(rule, &mcam->mcam_rules, list) {
+		if (is_npc_intf_rx(rule->intf) &&
+		    rule->rx_action.pf_func == target && !rule->enable) {
+			if (rule->default_rule) {
+				npc_enable_mcam_entry(rvu, mcam, blkaddr,
+						      rule->entry, true);
+				rule->enable = true;
+				continue;
+			}
+
+			if (rule->rx_action.op == NIX_RX_ACTION_DEFAULT) {
+				if (!def_ucast_rule)
+					continue;
+				/* Use default unicast entry action */
+				rule->rx_action = def_ucast_rule->rx_action;
+				def_action = *(u64 *)&def_ucast_rule->rx_action;
+				bank = npc_get_bank(mcam, rule->entry);
+				rvu_write64(rvu, blkaddr,
+					    NPC_AF_MCAMEX_BANKX_ACTION
+					    (rule->entry, bank), def_action);
+			}
+
+			npc_enable_mcam_entry(rvu, mcam, blkaddr,
+					      rule->entry, true);
+			rule->enable = true;
+		}
+	}
+
+	/* Enable MCAM entries installed by PF with target as VF pcifunc */
+	for (index = 0; index < mcam->bmap_entries; index++) {
+		if (mcam->entry2target_pffunc[index] == target)
+			npc_enable_mcam_entry(rvu, mcam, blkaddr,
+					      index, true);
+	}
+	mutex_unlock(&mcam->lock);
+}
+
+void npc_mcam_disable_flows(struct rvu *rvu, u16 target)
+{
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+	int blkaddr, index;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
+	if (blkaddr < 0)
+		return;
+
+	mutex_lock(&mcam->lock);
+	/* Disable MCAM entries installed by PF with target as VF pcifunc */
+	for (index = 0; index < mcam->bmap_entries; index++) {
+		if (mcam->entry2target_pffunc[index] == target)
+			npc_enable_mcam_entry(rvu, mcam, blkaddr,
+					      index, false);
+	}
+	mutex_unlock(&mcam->lock);
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 66f1a212f1f4..672768630557 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1278,6 +1278,7 @@ static void otx2_free_sq_res(struct otx2_nic *pf)
 
 static int otx2_init_hw_resources(struct otx2_nic *pf)
 {
+	struct nix_lf_free_req *free_req;
 	struct mbox *mbox = &pf->mbox;
 	struct otx2_hw *hw = &pf->hw;
 	struct msg_req *req;
@@ -1359,8 +1360,9 @@ static int otx2_init_hw_resources(struct otx2_nic *pf)
 	otx2_aura_pool_free(pf);
 err_free_nix_lf:
 	mutex_lock(&mbox->lock);
-	req = otx2_mbox_alloc_msg_nix_lf_free(mbox);
-	if (req) {
+	free_req = otx2_mbox_alloc_msg_nix_lf_free(mbox);
+	if (free_req) {
+		free_req->flags = NIX_LF_DISABLE_FLOWS;
 		if (otx2_sync_mbox_msg(mbox))
 			dev_err(pf->dev, "%s failed to free nixlf\n", __func__);
 	}
@@ -1379,6 +1381,7 @@ static int otx2_init_hw_resources(struct otx2_nic *pf)
 static void otx2_free_hw_resources(struct otx2_nic *pf)
 {
 	struct otx2_qset *qset = &pf->qset;
+	struct nix_lf_free_req *free_req;
 	struct mbox *mbox = &pf->mbox;
 	struct otx2_cq_queue *cq;
 	struct msg_req *req;
@@ -1419,8 +1422,9 @@ static void otx2_free_hw_resources(struct otx2_nic *pf)
 
 	mutex_lock(&mbox->lock);
 	/* Reset NIX LF */
-	req = otx2_mbox_alloc_msg_nix_lf_free(mbox);
-	if (req) {
+	free_req = otx2_mbox_alloc_msg_nix_lf_free(mbox);
+	if (free_req) {
+		free_req->flags = NIX_LF_DISABLE_FLOWS;
 		if (otx2_sync_mbox_msg(mbox))
 			dev_err(pf->dev, "%s failed to free nixlf\n", __func__);
 	}
-- 
2.16.5

