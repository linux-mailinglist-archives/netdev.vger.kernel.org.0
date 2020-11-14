Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB5592B304E
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 20:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgKNTxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 14:53:17 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:3944 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726156AbgKNTxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 14:53:17 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AEJrE3Q001074;
        Sat, 14 Nov 2020 11:53:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=lWUFrIMBn3qF21OTKcS35lvh2diUpvLQocxTtqWQMgk=;
 b=XrFfd24xME+XV64wdV1vf6EbcSUoKLxdfSGtk9BdtvmZzrtxfBt07jt3iXvjHngU5bfn
 ulp/bu/qPxqV3KcTjyyn6Co0Tv5qkOZn7lpBp7+3sKna0Li7EqRLQHBb/tuM9AuhDVnh
 Y13YNZXkFZDeHH6YIeQoEoB+LCtKc7EUsHr+UJx7tbCageAw3vIqjXgxqrDdt4ML6bLu
 Q3UMusA2V9Y1gegSL7Wwj4tEhomyv7FpRSXel3dYEW7cXvokWG1/Q+RK+d6BShdj3xul
 /03aaKOoB3V2/tGRmi+KxedpXEce934Ago2sxzrusoERMh1/Cp5CKC3twNX9mYi/owOZ Rw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 34tdfts040-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 14 Nov 2020 11:53:14 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 14 Nov
 2020 11:53:13 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 14 Nov
 2020 11:53:12 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 14 Nov 2020 11:53:12 -0800
Received: from hyd1583.caveonetworks.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 01B363F7040;
        Sat, 14 Nov 2020 11:53:08 -0800 (PST)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <saeed@kernel.org>,
        <alexander.duyck@gmail.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [PATCH v4 net-next 01/13] octeontx2-af: Modify default KEX profile to extract TX packet fields
Date:   Sun, 15 Nov 2020 01:22:51 +0530
Message-ID: <20201114195303.25967-2-naveenm@marvell.com>
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

From: Stanislaw Kardach <skardach@marvell.com>

The current default Key Extraction(KEX) profile can only use RX
packet fields while generating the MCAM search key. The profile
can't be used for matching TX packet fields. This patch modifies
the default KEX profile to add support for extracting TX packet
fields into MCAM search key. Enabled Tx KPU packet parsing by
configuring TX PKIND in tx_parse_cfg.

Modified the KEX profile to extract 2 bytes of VLAN TCI from an
offset of 2 bytes from LB_PTR. The LB_PTR points to the byte offset
where the VLAN header starts. The NPC KPU parser profile has been
modified to point LB_PTR to the starting byte offset of VLAN header
which points to the tpid field.

Signed-off-by: Stanislaw Kardach <skardach@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/npc.h    | 31 +++++++
 .../ethernet/marvell/octeontx2/af/npc_profile.h    | 99 +++++++++++++++++++---
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  4 +
 3 files changed, 120 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index 91a9d00e4fb5..407b9477da24 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -140,6 +140,15 @@ enum npc_kpu_lh_ltype {
 	NPC_LT_LH_CUSTOM1 = 0xF,
 };
 
+/* NPC port kind defines how the incoming or outgoing packets
+ * are processed. NPC accepts packets from up to 64 pkinds.
+ * Software assigns pkind for each incoming port such as CGX
+ * Ethernet interfaces, LBK interfaces, etc.
+ */
+enum npc_pkind_type {
+	NPC_TX_DEF_PKIND = 63ULL,	/* NIX-TX PKIND */
+};
+
 struct npc_kpu_profile_cam {
 	u8 state;
 	u8 state_mask;
@@ -300,6 +309,28 @@ struct nix_rx_action {
 /* NPC_AF_INTFX_KEX_CFG field masks */
 #define NPC_PARSE_NIBBLE		GENMASK_ULL(30, 0)
 
+/* NPC_PARSE_KEX_S nibble definitions for each field */
+#define NPC_PARSE_NIBBLE_CHAN		GENMASK_ULL(2, 0)
+#define NPC_PARSE_NIBBLE_ERRLEV		BIT_ULL(3)
+#define NPC_PARSE_NIBBLE_ERRCODE	GENMASK_ULL(5, 4)
+#define NPC_PARSE_NIBBLE_L2L3_BCAST	BIT_ULL(6)
+#define NPC_PARSE_NIBBLE_LA_FLAGS	GENMASK_ULL(8, 7)
+#define NPC_PARSE_NIBBLE_LA_LTYPE	BIT_ULL(9)
+#define NPC_PARSE_NIBBLE_LB_FLAGS	GENMASK_ULL(11, 10)
+#define NPC_PARSE_NIBBLE_LB_LTYPE	BIT_ULL(12)
+#define NPC_PARSE_NIBBLE_LC_FLAGS	GENMASK_ULL(14, 13)
+#define NPC_PARSE_NIBBLE_LC_LTYPE	BIT_ULL(15)
+#define NPC_PARSE_NIBBLE_LD_FLAGS	GENMASK_ULL(17, 16)
+#define NPC_PARSE_NIBBLE_LD_LTYPE	BIT_ULL(18)
+#define NPC_PARSE_NIBBLE_LE_FLAGS	GENMASK_ULL(20, 19)
+#define NPC_PARSE_NIBBLE_LE_LTYPE	BIT_ULL(21)
+#define NPC_PARSE_NIBBLE_LF_FLAGS	GENMASK_ULL(23, 22)
+#define NPC_PARSE_NIBBLE_LF_LTYPE	BIT_ULL(24)
+#define NPC_PARSE_NIBBLE_LG_FLAGS	GENMASK_ULL(26, 25)
+#define NPC_PARSE_NIBBLE_LG_LTYPE	BIT_ULL(27)
+#define NPC_PARSE_NIBBLE_LH_FLAGS	GENMASK_ULL(29, 28)
+#define NPC_PARSE_NIBBLE_LH_LTYPE	BIT_ULL(30)
+
 /* NIX Receive Vtag Action Structure */
 #define VTAG0_VALID_BIT		BIT_ULL(15)
 #define VTAG0_TYPE_MASK		GENMASK_ULL(14, 12)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
index 199448610e3e..b192692b4fc4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
@@ -148,6 +148,20 @@
 			(((bytesm1) << 16) | ((hdr_ofs) << 8) | ((ena) << 7) | \
 			 ((flags_ena) << 6) | ((key_ofs) & 0x3F))
 
+/* Rx parse key extract nibble enable */
+#define NPC_PARSE_NIBBLE_INTF_RX	(NPC_PARSE_NIBBLE_CHAN | \
+					 NPC_PARSE_NIBBLE_LA_LTYPE | \
+					 NPC_PARSE_NIBBLE_LB_LTYPE | \
+					 NPC_PARSE_NIBBLE_LC_LTYPE | \
+					 NPC_PARSE_NIBBLE_LD_LTYPE | \
+					 NPC_PARSE_NIBBLE_LE_LTYPE)
+/* Tx parse key extract nibble enable */
+#define NPC_PARSE_NIBBLE_INTF_TX	(NPC_PARSE_NIBBLE_LA_LTYPE | \
+					 NPC_PARSE_NIBBLE_LB_LTYPE | \
+					 NPC_PARSE_NIBBLE_LC_LTYPE | \
+					 NPC_PARSE_NIBBLE_LD_LTYPE | \
+					 NPC_PARSE_NIBBLE_LE_LTYPE)
+
 enum npc_kpu_parser_state {
 	NPC_S_NA = 0,
 	NPC_S_KPU1_ETHER,
@@ -13385,9 +13399,10 @@ static struct npc_mcam_kex npc_mkex_default = {
 	.name = "default",
 	.kpu_version = NPC_KPU_PROFILE_VER,
 	.keyx_cfg = {
-		/* nibble: LA..LE (ltype only) + Channel */
-		[NIX_INTF_RX] = ((u64)NPC_MCAM_KEY_X2 << 32) | 0x49247,
-		[NIX_INTF_TX] = ((u64)NPC_MCAM_KEY_X2 << 32) | ((1ULL << 19) - 1),
+		/* nibble: LA..LE (ltype only) + channel */
+		[NIX_INTF_RX] = ((u64)NPC_MCAM_KEY_X2 << 32) | NPC_PARSE_NIBBLE_INTF_RX,
+		/* nibble: LA..LE (ltype only) */
+		[NIX_INTF_TX] = ((u64)NPC_MCAM_KEY_X2 << 32) | NPC_PARSE_NIBBLE_INTF_TX,
 	},
 	.intf_lid_lt_ld = {
 	/* Default RX MCAM KEX profile */
@@ -13405,12 +13420,14 @@ static struct npc_mcam_kex npc_mkex_default = {
 			/* Layer B: Single VLAN (CTAG) */
 			/* CTAG VLAN[2..3] + Ethertype, 4 bytes, KW0[63:32] */
 			[NPC_LT_LB_CTAG] = {
-				KEX_LD_CFG(0x03, 0x0, 0x1, 0x0, 0x4),
+				KEX_LD_CFG(0x03, 0x2, 0x1, 0x0, 0x4),
 			},
 			/* Layer B: Stacked VLAN (STAG|QinQ) */
 			[NPC_LT_LB_STAG_QINQ] = {
-				/* CTAG VLAN[2..3] + Ethertype, 4 bytes, KW0[63:32] */
-				KEX_LD_CFG(0x03, 0x4, 0x1, 0x0, 0x4),
+				/* Outer VLAN: 2 bytes, KW0[63:48] */
+				KEX_LD_CFG(0x01, 0x2, 0x1, 0x0, 0x6),
+				/* Ethertype: 2 bytes, KW0[47:32] */
+				KEX_LD_CFG(0x01, 0x8, 0x1, 0x0, 0x4),
 			},
 			[NPC_LT_LB_FDSA] = {
 				/* SWITCH PORT: 1 byte, KW0[63:48] */
@@ -13436,17 +13453,71 @@ static struct npc_mcam_kex npc_mkex_default = {
 		[NPC_LID_LD] = {
 			/* Layer D:UDP */
 			[NPC_LT_LD_UDP] = {
-				/* SPORT: 2 bytes, KW3[15:0] */
-				KEX_LD_CFG(0x1, 0x0, 0x1, 0x0, 0x18),
-				/* DPORT: 2 bytes, KW3[31:16] */
-				KEX_LD_CFG(0x1, 0x2, 0x1, 0x0, 0x1a),
+				/* SPORT+DPORT: 4 bytes, KW3[31:0] */
+				KEX_LD_CFG(0x3, 0x0, 0x1, 0x0, 0x18),
+			},
+			/* Layer D:TCP */
+			[NPC_LT_LD_TCP] = {
+				/* SPORT+DPORT: 4 bytes, KW3[31:0] */
+				KEX_LD_CFG(0x3, 0x0, 0x1, 0x0, 0x18),
+			},
+		},
+	},
+
+	/* Default TX MCAM KEX profile */
+	[NIX_INTF_TX] = {
+		[NPC_LID_LA] = {
+			/* Layer A: NIX_INST_HDR_S + Ethernet */
+			/* NIX appends 8 bytes of NIX_INST_HDR_S at the
+			 * start of each TX packet supplied to NPC.
+			 */
+			[NPC_LT_LA_IH_NIX_ETHER] = {
+				/* PF_FUNC: 2B , KW0 [47:32] */
+				KEX_LD_CFG(0x01, 0x0, 0x1, 0x0, 0x4),
+				/* DMAC: 6 bytes, KW1[63:16] */
+				KEX_LD_CFG(0x05, 0x8, 0x1, 0x0, 0xa),
+			},
+		},
+		[NPC_LID_LB] = {
+			/* Layer B: Single VLAN (CTAG) */
+			[NPC_LT_LB_CTAG] = {
+				/* CTAG VLAN[2..3] KW0[63:48] */
+				KEX_LD_CFG(0x01, 0x2, 0x1, 0x0, 0x6),
+				/* CTAG VLAN[2..3] KW1[15:0] */
+				KEX_LD_CFG(0x01, 0x4, 0x1, 0x0, 0x8),
+			},
+			/* Layer B: Stacked VLAN (STAG|QinQ) */
+			[NPC_LT_LB_STAG_QINQ] = {
+				/* Outer VLAN: 2 bytes, KW0[63:48] */
+				KEX_LD_CFG(0x01, 0x2, 0x1, 0x0, 0x6),
+				/* Outer VLAN: 2 Bytes, KW1[15:0] */
+				KEX_LD_CFG(0x01, 0x8, 0x1, 0x0, 0x8),
+			},
+		},
+		[NPC_LID_LC] = {
+			/* Layer C: IPv4 */
+			[NPC_LT_LC_IP] = {
+				/* SIP+DIP: 8 bytes, KW2[63:0] */
+				KEX_LD_CFG(0x07, 0xc, 0x1, 0x0, 0x10),
+				/* TOS: 1 byte, KW1[63:56] */
+				KEX_LD_CFG(0x0, 0x1, 0x1, 0x0, 0xf),
+			},
+			/* Layer C: IPv6 */
+			[NPC_LT_LC_IP6] = {
+				/* Everything up to SADDR: 8 bytes, KW2[63:0] */
+				KEX_LD_CFG(0x07, 0x0, 0x1, 0x0, 0x10),
+			},
+		},
+		[NPC_LID_LD] = {
+			/* Layer D:UDP */
+			[NPC_LT_LD_UDP] = {
+				/* SPORT+DPORT: 4 bytes, KW3[31:0] */
+				KEX_LD_CFG(0x3, 0x0, 0x1, 0x0, 0x18),
 			},
 			/* Layer D:TCP */
 			[NPC_LT_LD_TCP] = {
-				/* SPORT: 2 bytes, KW3[15:0] */
-				KEX_LD_CFG(0x1, 0x0, 0x1, 0x0, 0x18),
-				/* DPORT: 2 bytes, KW3[31:16] */
-				KEX_LD_CFG(0x1, 0x2, 0x1, 0x0, 0x1a),
+				/* SPORT+DPORT: 4 bytes, KW3[31:0] */
+				KEX_LD_CFG(0x3, 0x0, 0x1, 0x0, 0x18),
 			},
 		},
 	},
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 8bac1dd3a1c2..18738fb9fcd3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -1182,6 +1182,10 @@ int rvu_mbox_handler_nix_lf_alloc(struct rvu *rvu,
 	/* Config Rx pkt length, csum checks and apad  enable / disable */
 	rvu_write64(rvu, blkaddr, NIX_AF_LFX_RX_CFG(nixlf), req->rx_cfg);
 
+	/* Configure pkind for TX parse config */
+	cfg = NPC_TX_DEF_PKIND;
+	rvu_write64(rvu, blkaddr, NIX_AF_LFX_TX_PARSE_CFG(nixlf), cfg);
+
 	intf = is_afvf(pcifunc) ? NIX_INTF_TYPE_LBK : NIX_INTF_TYPE_CGX;
 	err = nix_interface_init(rvu, pcifunc, intf, nixlf);
 	if (err)
-- 
2.16.5

