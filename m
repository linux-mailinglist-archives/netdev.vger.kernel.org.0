Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD9127C11C
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 11:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbgI2J2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 05:28:47 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:3908 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727886AbgI2J2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 05:28:46 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08T9OYBi010724;
        Tue, 29 Sep 2020 02:28:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=dILEsdut/lgEbznOPu7kH9mLLC8AtHFemVXV+2inDGQ=;
 b=LnRTIMwGVpHDjL9FGfZsISFbzliLj3DozYKc+dophBwSQpNhZ5R66c617350KEQw2ylO
 BdIiwcgdkixRlqn3z0cv0hXZ+rUHI2XGNbAANzl2ZCizsIY6KBQNymqz6A+al0tTyI5/
 2ZhD4WB3xvQorZ5oOQhYxcL7nbEVg3vACuaqs+Xqhv9rl2k53bK+c6mBg2+fZFF3Ug9V
 DNNrL/HZ4dqO5lNTBxfNvCa/KnSRRO9FDrkTsZJQn96iGzq8e6qVDXQuzxWGfJT/0XCM
 2XKN4PtVDJ2uFvE32QOcyt1l9OFzj5Yy7PxQR5sFr962VHxagHHNr07NkZFbMSi6kdET Cw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 33teemb7xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 02:28:42 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 29 Sep
 2020 02:28:41 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 29 Sep 2020 02:28:41 -0700
Received: from yoga.marvell.com (unknown [10.95.131.226])
        by maili.marvell.com (Postfix) with ESMTP id 68DAF3F703F;
        Tue, 29 Sep 2020 02:28:39 -0700 (PDT)
From:   Stanislaw Kardach <skardach@marvell.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <netdev@vger.kernel.org>
CC:     <kda@semihalf.com>, Stanislaw Kardach <skardach@marvell.com>
Subject: [PATCH net-next 2/7] octeontx2-af: cleanup KPU config data
Date:   Tue, 29 Sep 2020 11:28:15 +0200
Message-ID: <20200929092820.22487-3-skardach@marvell.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200929092820.22487-1-skardach@marvell.com>
References: <20200929092820.22487-1-skardach@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_01:2020-09-29,2020-09-29 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor KPU related NPC code gathering all configuration data in a
structured format and putting it in one place (npc_profile.h).
This increases readability and makes it easier to extend the profile
configuration (as opposed to jumping between multiple header and source
files).

To do this:
* Gather all KPU profile related data into a single adapter struct.
* Convert the built-in MKEX definition to a structured one to streamline
  the MKEX loading.
* Convert LT default register configuration into a structure, keeping
  default protocol settings in same file where identifiers for those
  protocols are defined.
* Add a single point for KPU profile loading, so that its source may
  change in the future once proper interfaces for loading such config
  are in place.

Signed-off-by: Stanislaw Kardach <skardach@marvell.com>
Acked-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/npc.h   |  36 ++++
 .../marvell/octeontx2/af/npc_profile.h        | 154 +++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  17 ++
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  36 ++--
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   | 202 ++++++------------
 5 files changed, 301 insertions(+), 144 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index 4f36e5cd8ced..3b069f378b2a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -296,6 +296,9 @@ struct nix_rx_action {
 #endif
 };
 
+/* NPC_AF_INTFX_KEX_CFG field masks */
+#define NPC_PARSE_NIBBLE		GENMASK_ULL(30, 0)
+
 /* NIX Receive Vtag Action Structure */
 #define VTAG0_VALID_BIT		BIT_ULL(15)
 #define VTAG0_TYPE_MASK		GENMASK_ULL(14, 12)
@@ -320,4 +323,37 @@ struct npc_mcam_kex {
 	u64 intf_ld_flags[NPC_MAX_INTF][NPC_MAX_LD][NPC_MAX_LFL];
 } __packed;
 
+struct npc_lt_def {
+	u8	ltype_mask;
+	u8	ltype_match;
+	u8	lid;
+};
+
+struct npc_lt_def_ipsec {
+	u8	ltype_mask;
+	u8	ltype_match;
+	u8	lid;
+	u8	spi_offset;
+	u8	spi_nz;
+};
+
+struct npc_lt_def_cfg {
+	struct npc_lt_def	rx_ol2;
+	struct npc_lt_def	rx_oip4;
+	struct npc_lt_def	rx_iip4;
+	struct npc_lt_def	rx_oip6;
+	struct npc_lt_def	rx_iip6;
+	struct npc_lt_def	rx_otcp;
+	struct npc_lt_def	rx_itcp;
+	struct npc_lt_def	rx_oudp;
+	struct npc_lt_def	rx_iudp;
+	struct npc_lt_def	rx_osctp;
+	struct npc_lt_def	rx_isctp;
+	struct npc_lt_def_ipsec	rx_ipsec[2];
+	struct npc_lt_def	pck_ol2;
+	struct npc_lt_def	pck_oip4;
+	struct npc_lt_def	pck_oip6;
+	struct npc_lt_def	pck_iip4;
+};
+
 #endif /* NPC_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
index b29c6689ace2..a67e9ed718e7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
@@ -140,6 +140,12 @@
 #define NPC_DSA_EXTEND		0x1000
 #define NPC_DSA_EDSA		0x8000
 
+#define NPC_KEXOF_DMAC	8
+#define MKEX_SIGN	0x19bbfdbd15f /* strtoull of "mkexprof" with base:36 */
+#define KEX_LD_CFG(bytesm1, hdr_ofs, ena, flags_ena, key_ofs)		\
+			(((bytesm1) << 16) | ((hdr_ofs) << 8) | ((ena) << 7) | \
+			 ((flags_ena) << 6) | ((key_ofs) & 0x3F))
+
 enum npc_kpu_parser_state {
 	NPC_S_NA = 0,
 	NPC_S_KPU1_ETHER,
@@ -13114,4 +13120,152 @@ static const struct npc_kpu_profile npc_kpu_profiles[] = {
 	},
 };
 
+static const struct npc_lt_def_cfg npc_lt_defaults = {
+	.rx_ol2 = {
+		.lid = NPC_LID_LA,
+		.ltype_match = NPC_LT_LA_ETHER,
+		.ltype_mask = 0x0F,
+	},
+	.rx_oip4 = {
+		.lid = NPC_LID_LC,
+		.ltype_match = NPC_LT_LC_IP,
+		.ltype_mask = 0x0E,
+	},
+	.rx_iip4 = {
+		.lid = NPC_LID_LG,
+		.ltype_match = NPC_LT_LG_TU_IP,
+		.ltype_mask = 0x0F,
+	},
+	.rx_oip6 = {
+		.lid = NPC_LID_LC,
+		.ltype_match = NPC_LT_LC_IP6,
+		.ltype_mask = 0x0E,
+	},
+	.rx_iip6 = {
+		.lid = NPC_LID_LG,
+		.ltype_match = NPC_LT_LG_TU_IP6,
+		.ltype_mask = 0x0F,
+	},
+	.rx_otcp = {
+		.lid = NPC_LID_LD,
+		.ltype_match = NPC_LT_LD_TCP,
+		.ltype_mask = 0x0F,
+	},
+	.rx_itcp = {
+		.lid = NPC_LID_LH,
+		.ltype_match = NPC_LT_LH_TU_TCP,
+		.ltype_mask = 0x0F,
+	},
+	.rx_oudp = {
+		.lid = NPC_LID_LD,
+		.ltype_match = NPC_LT_LD_UDP,
+		.ltype_mask = 0x0F,
+	},
+	.rx_iudp = {
+		.lid = NPC_LID_LH,
+		.ltype_match = NPC_LT_LH_TU_UDP,
+		.ltype_mask = 0x0F,
+	},
+	.rx_osctp = {
+		.lid = NPC_LID_LD,
+		.ltype_match = NPC_LT_LD_SCTP,
+		.ltype_mask = 0x0F,
+	},
+	.rx_isctp = {
+		.lid = NPC_LID_LH,
+		.ltype_match = NPC_LT_LH_TU_SCTP,
+		.ltype_mask = 0x0F,
+	},
+	.rx_ipsec = {
+		{
+			.lid = NPC_LID_LD,
+			.ltype_match = NPC_LT_LD_ESP,
+			.ltype_mask = 0x0F,
+		},
+		{
+			.spi_offset = 8,
+			.lid = NPC_LID_LH,
+			.ltype_match = NPC_LT_LH_TU_ESP,
+			.ltype_mask = 0x0F,
+		},
+	},
+	.pck_ol2 = {
+			.lid = NPC_LID_LA,
+			.ltype_match = NPC_LT_LA_ETHER,
+			.ltype_mask = 0x0F,
+	},
+	.pck_oip4 = {
+			.lid = NPC_LID_LC,
+			.ltype_match = NPC_LT_LC_IP,
+			.ltype_mask = 0x0E,
+	},
+	.pck_iip4 = {
+			.lid = NPC_LID_LG,
+			.ltype_match = NPC_LT_LG_TU_IP,
+			.ltype_mask = 0x0F,
+	},
+};
+
+static const struct npc_mcam_kex npc_mkex_default = {
+	.mkex_sign = MKEX_SIGN,
+	.name = "default",
+	.kpu_version = NPC_KPU_PROFILE_VER,
+	.keyx_cfg = {
+		/* nibble: LA..LE (ltype only) + Channel */
+		[NIX_INTF_RX] = ((u64)NPC_MCAM_KEY_X2 << 32) | 0x49247,
+		[NIX_INTF_TX] = ((u64)NPC_MCAM_KEY_X2 << 32) | ((1ULL << 19) - 1),
+	},
+	.intf_lid_lt_ld = {
+	/* Default RX MCAM KEX profile */
+	[NIX_INTF_RX] = {
+		[NPC_LID_LA] = {
+			/* Layer A: Ethernet: */
+			[NPC_LT_LA_ETHER] = {
+				/* DMAC: 6 bytes, KW1[47:0] */
+				KEX_LD_CFG(0x05, 0x0, 0x1, 0x0, NPC_KEXOF_DMAC),
+				/* Ethertype: 2 bytes, KW0[47:32] */
+				KEX_LD_CFG(0x01, 0xc, 0x1, 0x0, 0x4),
+			},
+		},
+		[NPC_LID_LB] = {
+			/* Layer B: Single VLAN (CTAG) */
+			/* CTAG VLAN[2..3] + Ethertype, 4 bytes, KW0[63:32] */
+			[NPC_LT_LB_CTAG] = {
+				KEX_LD_CFG(0x03, 0x0, 0x1, 0x0, 0x4),
+			},
+			/* Layer B: Stacked VLAN (STAG|QinQ) */
+			[NPC_LT_LB_STAG_QINQ] = {
+				/* CTAG VLAN[2..3] + Ethertype, 4 bytes, KW0[63:32] */
+				KEX_LD_CFG(0x03, 0x4, 0x1, 0x0, 0x4),
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
+		},
+		[NPC_LID_LD] = {
+			/* Layer D:UDP */
+			[NPC_LT_LD_UDP] = {
+				/* SPORT: 2 bytes, KW3[15:0] */
+				KEX_LD_CFG(0x1, 0x0, 0x1, 0x0, 0x18),
+				/* DPORT: 2 bytes, KW3[31:16] */
+				KEX_LD_CFG(0x1, 0x2, 0x1, 0x0, 0x1a),
+			},
+			/* Layer D:TCP */
+			[NPC_LT_LD_TCP] = {
+				/* SPORT: 2 bytes, KW3[15:0] */
+				KEX_LD_CFG(0x1, 0x0, 0x1, 0x0, 0x18),
+				/* DPORT: 2 bytes, KW3[31:16] */
+				KEX_LD_CFG(0x1, 0x2, 0x1, 0x0, 0x1a),
+			},
+		},
+	},
+	},
+};
+
 #endif /* NPC_PROFILE_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 05da7a91944a..f1b03f8ab0ee 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -291,6 +291,20 @@ struct rvu_fwdata {
 
 struct ptp;
 
+/* KPU profile adapter structure gathering all KPU configuration data and abstracting out the
+ * source where it came from.
+ */
+struct npc_kpu_profile_adapter {
+	const char			*name;
+	u64				version;
+	const struct npc_lt_def_cfg	*lt_def;
+	const struct npc_kpu_profile_action	*ikpu; /* array[pkinds] */
+	const struct npc_kpu_profile	*kpu; /* array[kpus] */
+	const struct npc_mcam_kex	*mkex;
+	size_t				pkinds;
+	size_t				kpus;
+};
+
 struct rvu {
 	void __iomem		*afreg_base;
 	void __iomem		*pfreg_base;
@@ -339,6 +353,9 @@ struct rvu {
 	/* Firmware data */
 	struct rvu_fwdata	*fwdata;
 
+	/* NPC KPU data */
+	struct npc_kpu_profile_adapter kpu;
+
 	struct ptp		*ptp;
 
 #ifdef CONFIG_DEBUG_FS
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 4bdc4baa3c59..b403c16caa2f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -3112,6 +3112,7 @@ static int nix_aq_init(struct rvu *rvu, struct rvu_block *block)
 
 int rvu_nix_init(struct rvu *rvu)
 {
+	const struct npc_lt_def_cfg *ltdefs;
 	struct rvu_hwinfo *hw = rvu->hw;
 	struct rvu_block *block;
 	int blkaddr, err;
@@ -3142,6 +3143,7 @@ int rvu_nix_init(struct rvu *rvu)
 		rvu_write64(rvu, blkaddr, NIX_AF_SQM_DBG_CTL_STATUS, cfg);
 	}
 
+	ltdefs = rvu->kpu.lt_def;
 	/* Calibrate X2P bus to check if CGX/LBK links are fine */
 	err = nix_calibrate_x2p(rvu, blkaddr);
 	if (err)
@@ -3189,28 +3191,38 @@ int rvu_nix_init(struct rvu *rvu)
 		 * and validate length and checksums.
 		 */
 		rvu_write64(rvu, blkaddr, NIX_AF_RX_DEF_OL2,
-			    (NPC_LID_LA << 8) | (NPC_LT_LA_ETHER << 4) | 0x0F);
+			    (ltdefs->rx_ol2.lid << 8) | (ltdefs->rx_ol2.ltype_match << 4) |
+			    ltdefs->rx_ol2.ltype_mask);
 		rvu_write64(rvu, blkaddr, NIX_AF_RX_DEF_OIP4,
-			    (NPC_LID_LC << 8) | (NPC_LT_LC_IP << 4) | 0x0F);
+			    (ltdefs->rx_oip4.lid << 8) | (ltdefs->rx_oip4.ltype_match << 4) |
+			    ltdefs->rx_oip4.ltype_mask);
 		rvu_write64(rvu, blkaddr, NIX_AF_RX_DEF_IIP4,
-			    (NPC_LID_LG << 8) | (NPC_LT_LG_TU_IP << 4) | 0x0F);
+			    (ltdefs->rx_iip4.lid << 8) | (ltdefs->rx_iip4.ltype_match << 4) |
+			    ltdefs->rx_iip4.ltype_mask);
 		rvu_write64(rvu, blkaddr, NIX_AF_RX_DEF_OIP6,
-			    (NPC_LID_LC << 8) | (NPC_LT_LC_IP6 << 4) | 0x0F);
+			    (ltdefs->rx_oip6.lid << 8) | (ltdefs->rx_oip6.ltype_match << 4) |
+			    ltdefs->rx_oip6.ltype_mask);
 		rvu_write64(rvu, blkaddr, NIX_AF_RX_DEF_IIP6,
-			    (NPC_LID_LG << 8) | (NPC_LT_LG_TU_IP6 << 4) | 0x0F);
+			    (ltdefs->rx_iip6.lid << 8) | (ltdefs->rx_iip6.ltype_match << 4) |
+			    ltdefs->rx_iip6.ltype_mask);
 		rvu_write64(rvu, blkaddr, NIX_AF_RX_DEF_OTCP,
-			    (NPC_LID_LD << 8) | (NPC_LT_LD_TCP << 4) | 0x0F);
+			    (ltdefs->rx_otcp.lid << 8) | (ltdefs->rx_otcp.ltype_match << 4) |
+			    ltdefs->rx_otcp.ltype_mask);
 		rvu_write64(rvu, blkaddr, NIX_AF_RX_DEF_ITCP,
-			    (NPC_LID_LH << 8) | (NPC_LT_LH_TU_TCP << 4) | 0x0F);
+			    (ltdefs->rx_itcp.lid << 8) | (ltdefs->rx_itcp.ltype_match << 4) |
+			    ltdefs->rx_itcp.ltype_mask);
 		rvu_write64(rvu, blkaddr, NIX_AF_RX_DEF_OUDP,
-			    (NPC_LID_LD << 8) | (NPC_LT_LD_UDP << 4) | 0x0F);
+			    (ltdefs->rx_oudp.lid << 8) | (ltdefs->rx_oudp.ltype_match << 4) |
+			    ltdefs->rx_oudp.ltype_mask);
 		rvu_write64(rvu, blkaddr, NIX_AF_RX_DEF_IUDP,
-			    (NPC_LID_LH << 8) | (NPC_LT_LH_TU_UDP << 4) | 0x0F);
+			    (ltdefs->rx_iudp.lid << 8) | (ltdefs->rx_iudp.ltype_match << 4) |
+			    ltdefs->rx_iudp.ltype_mask);
 		rvu_write64(rvu, blkaddr, NIX_AF_RX_DEF_OSCTP,
-			    (NPC_LID_LD << 8) | (NPC_LT_LD_SCTP << 4) | 0x0F);
+			    (ltdefs->rx_osctp.lid << 8) | (ltdefs->rx_osctp.ltype_match << 4) |
+			    ltdefs->rx_osctp.ltype_mask);
 		rvu_write64(rvu, blkaddr, NIX_AF_RX_DEF_ISCTP,
-			    (NPC_LID_LH << 8) | (NPC_LT_LH_TU_SCTP << 4) |
-			    0x0F);
+			    (ltdefs->rx_isctp.lid << 8) | (ltdefs->rx_isctp.ltype_match << 4) |
+			    ltdefs->rx_isctp.ltype_mask);
 
 		err = nix_rx_flowkey_alg_cfg(rvu, blkaddr);
 		if (err)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 6a1ddb2da1a5..0abe5fd12131 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -29,6 +29,8 @@
 #define NPC_PARSE_RESULT_DMAC_OFFSET	8
 #define NPC_HW_TSTAMP_OFFSET		8
 
+static const char def_pfl_name[] = "default";
+
 static void npc_mcam_free_all_entries(struct rvu *rvu, struct npc_mcam *mcam,
 				      int blkaddr, u16 pcifunc);
 static void npc_mcam_free_all_counters(struct rvu *rvu, struct npc_mcam *mcam,
@@ -448,7 +450,7 @@ void rvu_npc_install_promisc_entry(struct rvu *rvu, u16 pcifunc,
 	entry.kw_mask[0] = 0xFFFULL;
 
 	if (allmulti) {
-		kwi = NPC_PARSE_RESULT_DMAC_OFFSET / sizeof(u64);
+		kwi = NPC_KEXOF_DMAC / sizeof(u64);
 		entry.kw[kwi] = BIT_ULL(40); /* LSB bit of 1st byte in DMAC */
 		entry.kw_mask[kwi] = BIT_ULL(40);
 	}
@@ -718,88 +720,8 @@ void rvu_npc_disable_mcam_entries(struct rvu *rvu, u16 pcifunc, int nixlf)
 	rvu_write64(rvu, blkaddr,			\
 		NPC_AF_INTFX_LDATAX_FLAGSX_CFG(intf, ld, flags), cfg)
 
-#define KEX_LD_CFG(bytesm1, hdr_ofs, ena, flags_ena, key_ofs)		\
-			(((bytesm1) << 16) | ((hdr_ofs) << 8) | ((ena) << 7) | \
-			 ((flags_ena) << 6) | ((key_ofs) & 0x3F))
-
-static void npc_config_ldata_extract(struct rvu *rvu, int blkaddr)
-{
-	struct npc_mcam *mcam = &rvu->hw->mcam;
-	int lid, ltype;
-	int lid_count;
-	u64 cfg;
-
-	cfg = rvu_read64(rvu, blkaddr, NPC_AF_CONST);
-	lid_count = (cfg >> 4) & 0xF;
-
-	/* First clear any existing config i.e
-	 * disable LDATA and FLAGS extraction.
-	 */
-	for (lid = 0; lid < lid_count; lid++) {
-		for (ltype = 0; ltype < 16; ltype++) {
-			SET_KEX_LD(NIX_INTF_RX, lid, ltype, 0, 0ULL);
-			SET_KEX_LD(NIX_INTF_RX, lid, ltype, 1, 0ULL);
-			SET_KEX_LD(NIX_INTF_TX, lid, ltype, 0, 0ULL);
-			SET_KEX_LD(NIX_INTF_TX, lid, ltype, 1, 0ULL);
-
-			SET_KEX_LDFLAGS(NIX_INTF_RX, 0, ltype, 0ULL);
-			SET_KEX_LDFLAGS(NIX_INTF_RX, 1, ltype, 0ULL);
-			SET_KEX_LDFLAGS(NIX_INTF_TX, 0, ltype, 0ULL);
-			SET_KEX_LDFLAGS(NIX_INTF_TX, 1, ltype, 0ULL);
-		}
-	}
-
-	if (mcam->keysize != NPC_MCAM_KEY_X2)
-		return;
-
-	/* Default MCAM KEX profile */
-	/* Layer A: Ethernet: */
-
-	/* DMAC: 6 bytes, KW1[47:0] */
-	cfg = KEX_LD_CFG(0x05, 0x0, 0x1, 0x0, NPC_PARSE_RESULT_DMAC_OFFSET);
-	SET_KEX_LD(NIX_INTF_RX, NPC_LID_LA, NPC_LT_LA_ETHER, 0, cfg);
-
-	/* Ethertype: 2 bytes, KW0[47:32] */
-	cfg = KEX_LD_CFG(0x01, 0xc, 0x1, 0x0, 0x4);
-	SET_KEX_LD(NIX_INTF_RX, NPC_LID_LA, NPC_LT_LA_ETHER, 1, cfg);
-
-	/* Layer B: Single VLAN (CTAG) */
-	/* CTAG VLAN[2..3] + Ethertype, 4 bytes, KW0[63:32] */
-	cfg = KEX_LD_CFG(0x03, 0x0, 0x1, 0x0, 0x4);
-	SET_KEX_LD(NIX_INTF_RX, NPC_LID_LB, NPC_LT_LB_CTAG, 0, cfg);
-
-	/* Layer B: Stacked VLAN (STAG|QinQ) */
-	/* CTAG VLAN[2..3] + Ethertype, 4 bytes, KW0[63:32] */
-	cfg = KEX_LD_CFG(0x03, 0x4, 0x1, 0x0, 0x4);
-	SET_KEX_LD(NIX_INTF_RX, NPC_LID_LB, NPC_LT_LB_STAG_QINQ, 0, cfg);
-
-	/* Layer C: IPv4 */
-	/* SIP+DIP: 8 bytes, KW2[63:0] */
-	cfg = KEX_LD_CFG(0x07, 0xc, 0x1, 0x0, 0x10);
-	SET_KEX_LD(NIX_INTF_RX, NPC_LID_LC, NPC_LT_LC_IP, 0, cfg);
-	/* TOS: 1 byte, KW1[63:56] */
-	cfg = KEX_LD_CFG(0x0, 0x1, 0x1, 0x0, 0xf);
-	SET_KEX_LD(NIX_INTF_RX, NPC_LID_LC, NPC_LT_LC_IP, 1, cfg);
-
-	/* Layer D:UDP */
-	/* SPORT: 2 bytes, KW3[15:0] */
-	cfg = KEX_LD_CFG(0x1, 0x0, 0x1, 0x0, 0x18);
-	SET_KEX_LD(NIX_INTF_RX, NPC_LID_LD, NPC_LT_LD_UDP, 0, cfg);
-	/* DPORT: 2 bytes, KW3[31:16] */
-	cfg = KEX_LD_CFG(0x1, 0x2, 0x1, 0x0, 0x1a);
-	SET_KEX_LD(NIX_INTF_RX, NPC_LID_LD, NPC_LT_LD_UDP, 1, cfg);
-
-	/* Layer D:TCP */
-	/* SPORT: 2 bytes, KW3[15:0] */
-	cfg = KEX_LD_CFG(0x1, 0x0, 0x1, 0x0, 0x18);
-	SET_KEX_LD(NIX_INTF_RX, NPC_LID_LD, NPC_LT_LD_TCP, 0, cfg);
-	/* DPORT: 2 bytes, KW3[31:16] */
-	cfg = KEX_LD_CFG(0x1, 0x2, 0x1, 0x0, 0x1a);
-	SET_KEX_LD(NIX_INTF_RX, NPC_LID_LD, NPC_LT_LD_TCP, 1, cfg);
-}
-
 static void npc_program_mkex_profile(struct rvu *rvu, int blkaddr,
-				     struct npc_mcam_kex *mkex)
+				     const struct npc_mcam_kex *mkex)
 {
 	int lid, lt, ld, fl;
 
@@ -839,34 +761,31 @@ static void npc_program_mkex_profile(struct rvu *rvu, int blkaddr,
 	}
 }
 
-/* strtoull of "mkexprof" with base:36 */
-#define MKEX_SIGN      0x19bbfdbd15f
 #define MKEX_END_SIGN  0xdeadbeef
 
-static void npc_load_mkex_profile(struct rvu *rvu, int blkaddr)
+static void npc_load_mkex_profile(struct rvu *rvu, int blkaddr,
+				  const char *mkex_profile)
 {
-	const char *mkex_profile = rvu->mkex_pfl_name;
 	struct device *dev = &rvu->pdev->dev;
-	void __iomem *mkex_prfl_addr = NULL;
 	struct npc_mcam_kex *mcam_kex;
-	u64 prfl_addr;
-	u64 prfl_sz;
+	void *mkex_prfl_addr = NULL;
+	u64 prfl_addr, prfl_sz;
 
 	/* If user not selected mkex profile */
-	if (!strncmp(mkex_profile, "default", MKEX_NAME_LEN))
-		goto load_default;
+	if (!strncmp(mkex_profile, def_pfl_name, MKEX_NAME_LEN))
+		goto program_mkex;
 
 	if (!rvu->fwdata)
-		goto load_default;
+		goto program_mkex;
 	prfl_addr = rvu->fwdata->mcam_addr;
 	prfl_sz = rvu->fwdata->mcam_sz;
 
 	if (!prfl_addr || !prfl_sz)
-		goto load_default;
+		goto program_mkex;
 
-	mkex_prfl_addr = ioremap_wc(prfl_addr, prfl_sz);
+	mkex_prfl_addr = memremap(prfl_addr, prfl_sz, MEMREMAP_WC);
 	if (!mkex_prfl_addr)
-		goto load_default;
+		goto program_mkex;
 
 	mcam_kex = (struct npc_mcam_kex *)mkex_prfl_addr;
 
@@ -878,31 +797,23 @@ static void npc_load_mkex_profile(struct rvu *rvu, int blkaddr)
 			 * parse nibble enable configuration has to be
 			 * identical for both Rx and Tx interfaces.
 			 */
-			if (is_rvu_96xx_B0(rvu) &&
-			    mcam_kex->keyx_cfg[NIX_INTF_RX] !=
-			    mcam_kex->keyx_cfg[NIX_INTF_TX])
-				goto load_default;
-
-			/* Program selected mkex profile */
-			npc_program_mkex_profile(rvu, blkaddr, mcam_kex);
-
-			goto unmap;
+			if (!is_rvu_96xx_B0(rvu) ||
+			    mcam_kex->keyx_cfg[NIX_INTF_RX] == mcam_kex->keyx_cfg[NIX_INTF_TX])
+				rvu->kpu.mkex = mcam_kex;
+			goto program_mkex;
 		}
 
 		mcam_kex++;
 		prfl_sz -= sizeof(struct npc_mcam_kex);
 	}
-	dev_warn(dev, "Failed to load requested profile: %s\n",
-		 rvu->mkex_pfl_name);
+	dev_warn(dev, "Failed to load requested profile: %s\n", mkex_profile);
 
-load_default:
-	dev_info(rvu->dev, "Using default mkex profile\n");
-	/* Config packet data and flags extraction into PARSE result */
-	npc_config_ldata_extract(rvu, blkaddr);
-
-unmap:
+program_mkex:
+	dev_info(rvu->dev, "Using %s mkex profile\n", rvu->kpu.mkex->name);
+	/* Program selected mkex profile */
+	npc_program_mkex_profile(rvu, blkaddr, rvu->kpu.mkex);
 	if (mkex_prfl_addr)
-		iounmap(mkex_prfl_addr);
+		memunmap(mkex_prfl_addr);
 }
 
 static void npc_config_kpuaction(struct rvu *rvu, int blkaddr,
@@ -1014,6 +925,27 @@ static void npc_program_kpu_profile(struct rvu *rvu, int blkaddr, int kpu,
 	rvu_write64(rvu, blkaddr, NPC_AF_KPUX_CFG(kpu), 0x01);
 }
 
+static int npc_prepare_default_kpu(struct npc_kpu_profile_adapter *profile)
+{
+	profile->name = def_pfl_name;
+	profile->version = NPC_KPU_PROFILE_VER;
+	profile->ikpu = ikpu_action_entries;
+	profile->pkinds = ARRAY_SIZE(ikpu_action_entries);
+	profile->kpu = npc_kpu_profiles;
+	profile->kpus = ARRAY_SIZE(npc_kpu_profiles);
+	profile->lt_def = &npc_lt_defaults;
+	profile->mkex = &npc_mkex_default;
+
+	return 0;
+}
+
+static void npc_load_kpu_profile(struct rvu *rvu)
+{
+	struct npc_kpu_profile_adapter *profile = &rvu->kpu;
+
+	npc_prepare_default_kpu(profile);
+}
+
 static void npc_parser_profile_init(struct rvu *rvu, int blkaddr)
 {
 	struct rvu_hwinfo *hw = rvu->hw;
@@ -1032,25 +964,26 @@ static void npc_parser_profile_init(struct rvu *rvu, int blkaddr)
 		rvu_write64(rvu, blkaddr, NPC_AF_KPUX_CFG(idx), 0x00);
 	}
 
+	/* Load and customize KPU profile. */
+	npc_load_kpu_profile(rvu);
+
 	/* First program IKPU profile i.e PKIND configs.
 	 * Check HW max count to avoid configuring junk or
 	 * writing to unsupported CSR addresses.
 	 */
 	pkind = &hw->pkind;
-	num_pkinds = ARRAY_SIZE(ikpu_action_entries);
+	num_pkinds = rvu->kpu.pkinds;
 	num_pkinds = min_t(int, pkind->rsrc.max, num_pkinds);
 
 	for (idx = 0; idx < num_pkinds; idx++)
-		npc_config_kpuaction(rvu, blkaddr,
-				     &ikpu_action_entries[idx], 0, idx, true);
+		npc_config_kpuaction(rvu, blkaddr, &rvu->kpu.ikpu[idx], 0, idx, true);
 
 	/* Program KPU CAM and Action profiles */
-	num_kpus = ARRAY_SIZE(npc_kpu_profiles);
+	num_kpus = rvu->kpu.kpus;
 	num_kpus = min_t(int, hw->npc_kpus, num_kpus);
 
 	for (idx = 0; idx < num_kpus; idx++)
-		npc_program_kpu_profile(rvu, blkaddr,
-					idx, &npc_kpu_profiles[idx]);
+		npc_program_kpu_profile(rvu, blkaddr, idx, &rvu->kpu.kpu[idx]);
 }
 
 static int npc_mcam_rsrcs_init(struct rvu *rvu, int blkaddr)
@@ -1175,11 +1108,11 @@ static int npc_mcam_rsrcs_init(struct rvu *rvu, int blkaddr)
 
 int rvu_npc_init(struct rvu *rvu)
 {
+	struct npc_kpu_profile_adapter *kpu = &rvu->kpu;
 	struct npc_pkind *pkind = &rvu->hw->pkind;
 	struct npc_mcam *mcam = &rvu->hw->mcam;
-	u64 keyz = NPC_MCAM_KEY_X2;
+	u64 cfg, nibble_ena, rx_kex, tx_kex;
 	int blkaddr, entry, bank, err;
-	u64 cfg, nibble_ena;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
 	if (blkaddr < 0) {
@@ -1213,13 +1146,16 @@ int rvu_npc_init(struct rvu *rvu)
 
 	/* Config Outer L2, IPv4's NPC layer info */
 	rvu_write64(rvu, blkaddr, NPC_AF_PCK_DEF_OL2,
-		    (NPC_LID_LA << 8) | (NPC_LT_LA_ETHER << 4) | 0x0F);
+		    (kpu->lt_def->pck_ol2.lid << 8) | (kpu->lt_def->pck_ol2.ltype_match << 4) |
+		    kpu->lt_def->pck_ol2.ltype_mask);
 	rvu_write64(rvu, blkaddr, NPC_AF_PCK_DEF_OIP4,
-		    (NPC_LID_LC << 8) | (NPC_LT_LC_IP << 4) | 0x0F);
+		    (kpu->lt_def->pck_oip4.lid << 8) | (kpu->lt_def->pck_oip4.ltype_match << 4) |
+		    kpu->lt_def->pck_oip4.ltype_mask);
 
 	/* Config Inner IPV4 NPC layer info */
 	rvu_write64(rvu, blkaddr, NPC_AF_PCK_DEF_IIP4,
-		    (NPC_LID_LG << 8) | (NPC_LT_LG_TU_IP << 4) | 0x0F);
+		    (kpu->lt_def->pck_iip4.lid << 8) | (kpu->lt_def->pck_iip4.ltype_match << 4) |
+		    kpu->lt_def->pck_iip4.ltype_mask);
 
 	/* Enable below for Rx pkts.
 	 * - Outer IPv4 header checksum validation.
@@ -1235,23 +1171,25 @@ int rvu_npc_init(struct rvu *rvu)
 	/* Set RX and TX side MCAM search key size.
 	 * LA..LD (ltype only) + Channel
 	 */
-	nibble_ena = 0x49247;
-	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(NIX_INTF_RX),
-			((keyz & 0x3) << 32) | nibble_ena);
+	rx_kex = npc_mkex_default.keyx_cfg[NIX_INTF_RX];
+	tx_kex = npc_mkex_default.keyx_cfg[NIX_INTF_TX];
+	nibble_ena = FIELD_GET(NPC_PARSE_NIBBLE, rx_kex);
+	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(NIX_INTF_RX), rx_kex);
 	/* Due to an errata (35786) in A0 pass silicon, parse nibble enable
 	 * configuration has to be identical for both Rx and Tx interfaces.
 	 */
-	if (!is_rvu_96xx_B0(rvu))
-		nibble_ena = (1ULL << 19) - 1;
-	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(NIX_INTF_TX),
-			((keyz & 0x3) << 32) | nibble_ena);
+	if (is_rvu_96xx_B0(rvu)) {
+		tx_kex &= ~NPC_PARSE_NIBBLE;
+		tx_kex |= FIELD_PREP(NPC_PARSE_NIBBLE, nibble_ena);
+	}
+	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(NIX_INTF_TX), tx_kex);
 
 	err = npc_mcam_rsrcs_init(rvu, blkaddr);
 	if (err)
 		return err;
 
 	/* Configure MKEX profile */
-	npc_load_mkex_profile(rvu, blkaddr);
+	npc_load_mkex_profile(rvu, blkaddr, rvu->mkex_pfl_name);
 
 	/* Set TX miss action to UCAST_DEFAULT i.e
 	 * transmit the packet on NIX LF SQ's default channel.
-- 
2.20.1

