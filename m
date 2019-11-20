Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80765104279
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 18:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbfKTRta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 12:49:30 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42674 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727977AbfKTRta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 12:49:30 -0500
Received: by mail-pf1-f193.google.com with SMTP id s5so80993pfh.9
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 09:49:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cRmgU+++u40BvGBH7nqZsRULomtxWNwhALYJidqwG/8=;
        b=b70kx2spD1WUnte+alkM/mY38ZmBKNnNVGraWb1DyBj3WU9qvhOaXnTbaKjEqmJDiX
         sHbN4GHjZP2YN4UCueP6B1IDcVPQvgunXKRitKBGwGI6fONsrmtx1t9o5YB4RV+c0D90
         1mpfkZcXPFR4MOtJIuNFezXVQQRx22m4H0kRbAyP+azh1gfnmVjFhwi7MNNyrEsETjlp
         Jo1YRhnfiya/EYJBQIoPRxXEUnEdHSZlIt6LjHbSav+eXK4Jz5QqQxdgD0FiZnmel/5B
         E3iKT17dDhVa00laBRtNXQk2WrhKf3qnQzekeg30HENyvjv1TvtFyLpU0o917ytlN/TF
         XwBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cRmgU+++u40BvGBH7nqZsRULomtxWNwhALYJidqwG/8=;
        b=bVdwsDVIdcDZMrPVt60L2cjUKRKVxDUIPRZR0tNSdUFz6rboRX2exowouj1u/wK2sP
         ItcdBhtkqukf40p66Wl+qe5bnkuNGKtJn+9Nj7YBJAyZxkvYVKgBXp45JIZT2Cl5PYL5
         UnnxVgBLwK0L4hi0ugbNVMaAnc6us3ncFbV2PrZNjZMaXOqEt7dRny8HAr02/7OOllTq
         dDWTG35k192MDm+hI4c4U+Q9ihgdChyHYsJNVLaksMuOmXBVz5yaed8iSTnHSNUS+slj
         lva5g2H8pFehrL9uUGUoaNJbyp9fA2vafbcJ0ET3x39gROU8CjxMnBZ0VOjES16/n2o8
         tyrQ==
X-Gm-Message-State: APjAAAUqPHBherIEsa7ZfcOqQx25fm9fAKyEwGubPihzL7aCyrTyTiPa
        q5l13nayTLs3lGMXQcrEGaV5J2/s
X-Google-Smtp-Source: APXvYqx4eKZP2AarvW7GWDBZniC4Z6fSZXWXT97uUb4VoEUOrcuzoxuiQnYncaQHlZPfN/sVs/6WBg==
X-Received: by 2002:a63:4819:: with SMTP id v25mr4585237pga.165.1574272167695;
        Wed, 20 Nov 2019 09:49:27 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id y24sm32230522pfr.116.2019.11.20.09.49.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 20 Nov 2019 09:49:26 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        Radha Mohan Chintakuntla <radhac@marvell.com>,
        Pavan Nikhilesh <pbhagavatula@marvell.com>,
        Stanislaw Kardach <skardach@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v3 08/16] octeontx2-af: Add SSO unit support to the AF driver
Date:   Wed, 20 Nov 2019 23:17:58 +0530
Message-Id: <1574272086-21055-9-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574272086-21055-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1574272086-21055-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Radha Mohan Chintakuntla <radhac@marvell.com>

This patch adds the SSO (Schedule/Synchronize/Order) unit support to the
Adming Function (AF) driver including initial mailboxes, initialization
of SSO hardware groups and workslots and their teardown sequence.

Signed-off-by: Radha Mohan Chintakuntla <radhac@marvell.com>
Signed-off-by: Pavan Nikhilesh <pbhagavatula@marvell.com>
Signed-off-by: Stanislaw Kardach <skardach@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/Makefile |   2 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  90 +++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  28 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  24 +
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    | 180 ++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_sso.c    | 837 +++++++++++++++++++++
 6 files changed, 1157 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_sso.c

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/Makefile b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
index 1b25948..5988d58 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
@@ -8,4 +8,4 @@ obj-$(CONFIG_OCTEONTX2_AF) += octeontx2_af.o
 
 octeontx2_mbox-y := mbox.o
 octeontx2_af-y := cgx.o rvu.o rvu_cgx.o rvu_npa.o rvu_nix.o \
-		  rvu_reg.o rvu_npc.o rvu_debugfs.o
+		  rvu_reg.o rvu_npc.o rvu_debugfs.o rvu_sso.o
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 3dcfac5..ab03769 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -152,6 +152,21 @@ M(NPA_LF_FREE,		0x401, npa_lf_free, msg_req, msg_rsp)		\
 M(NPA_AQ_ENQ,		0x402, npa_aq_enq, npa_aq_enq_req, npa_aq_enq_rsp)   \
 M(NPA_HWCTX_DISABLE,	0x403, npa_hwctx_disable, hwctx_disable_req, msg_rsp)\
 /* SSO/SSOW mbox IDs (range 0x600 - 0x7FF) */				\
+M(SSO_LF_ALLOC,		0x600, sso_lf_alloc,				\
+				sso_lf_alloc_req, sso_lf_alloc_rsp)	\
+M(SSO_LF_FREE,		0x601, sso_lf_free,				\
+				sso_lf_free_req, msg_rsp)		\
+M(SSOW_LF_ALLOC,	0x602, ssow_lf_alloc,				\
+				ssow_lf_alloc_req, msg_rsp)		\
+M(SSOW_LF_FREE,		0x603, ssow_lf_free,				\
+				ssow_lf_free_req, msg_rsp)		\
+M(SSO_HW_SETCONFIG,	0x604, sso_hw_setconfig,			\
+				sso_hw_setconfig, msg_rsp)		\
+M(SSO_GRP_SET_PRIORITY,	0x605, sso_grp_set_priority,			\
+				sso_grp_priority, msg_rsp)		\
+M(SSO_GRP_GET_PRIORITY,	0x606, sso_grp_get_priority,			\
+				sso_info_req, sso_grp_priority)	\
+M(SSO_WS_CACHE_INV,	0x607, sso_ws_cache_inv, msg_req, msg_rsp)	\
 /* TIM mbox IDs (range 0x800 - 0x9FF) */				\
 /* CPT mbox IDs (range 0xA00 - 0xBFF) */				\
 /* NPC mbox IDs (range 0x6000 - 0x7FFF) */				\
@@ -710,6 +725,81 @@ struct nix_bp_cfg_rsp {
 	u8	chan_cnt; /* Number of channel for which bpids are assigned */
 };
 
+/* SSO mailbox error codes
+ * Range 501 - 600.
+ */
+enum sso_af_status {
+	SSO_AF_ERR_PARAM	= -501,
+	SSO_AF_ERR_LF_INVALID	= -502,
+	SSO_AF_ERR_AF_LF_ALLOC	= -503,
+	SSO_AF_ERR_GRP_EBUSY	= -504,
+	SSO_AF_INVAL_NPA_PF_FUNC = -505,
+};
+
+struct sso_lf_alloc_req {
+	struct mbox_msghdr hdr;
+	int node;
+	u16 hwgrps;
+};
+
+struct sso_lf_alloc_rsp {
+	struct mbox_msghdr hdr;
+	u32	xaq_buf_size;
+	u32	xaq_wq_entries;
+	u32	in_unit_entries;
+	u16	hwgrps;
+};
+
+struct sso_lf_free_req {
+	struct mbox_msghdr hdr;
+	int node;
+	u16 hwgrps;
+};
+
+struct sso_hw_setconfig {
+	struct mbox_msghdr hdr;
+	u32	npa_aura_id;
+	u16	npa_pf_func;
+	u16	hwgrps;
+};
+
+struct sso_info_req {
+	struct mbox_msghdr hdr;
+	union {
+		u16 grp;
+		u16 hws;
+	};
+};
+
+struct sso_grp_priority {
+	struct mbox_msghdr hdr;
+	u16 grp;
+	u8 priority;
+	u8 affinity;
+	u8 weight;
+};
+
+/* SSOW mailbox error codes
+ * Range 601 - 700.
+ */
+enum ssow_af_status {
+	SSOW_AF_ERR_PARAM	= -601,
+	SSOW_AF_ERR_LF_INVALID	= -602,
+	SSOW_AF_ERR_AF_LF_ALLOC	= -603,
+};
+
+struct ssow_lf_alloc_req {
+	struct mbox_msghdr hdr;
+	int node;
+	u16 hws;
+};
+
+struct ssow_lf_free_req {
+	struct mbox_msghdr hdr;
+	int node;
+	u16 hws;
+};
+
 /* NPC mbox message structs */
 
 #define NPC_MCAM_ENTRY_INVALID	0xFFFF
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index e39aa02..c1229e5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -653,6 +653,7 @@ static void rvu_free_hw_resources(struct rvu *rvu)
 	rvu_npa_freemem(rvu);
 	rvu_npc_freemem(rvu);
 	rvu_nix_freemem(rvu);
+	rvu_sso_freemem(rvu);
 
 	/* Free block LF bitmaps */
 	for (id = 0; id < BLK_COUNT; id++) {
@@ -954,6 +955,10 @@ static int rvu_setup_hw_resources(struct rvu *rvu)
 	if (err)
 		goto cgx_err;
 
+	err = rvu_sso_init(rvu);
+	if (err)
+		goto cgx_err;
+
 	return 0;
 
 cgx_err:
@@ -1018,7 +1023,7 @@ int rvu_mbox_handler_ready(struct rvu *rvu, struct msg_req *req,
 /* Get current count of a RVU block's LF/slots
  * provisioned to a given RVU func.
  */
-static u16 rvu_get_rsrc_mapcount(struct rvu_pfvf *pfvf, int blktype)
+u16 rvu_get_rsrc_mapcount(struct rvu_pfvf *pfvf, int blktype)
 {
 	switch (blktype) {
 	case BLKTYPE_NPA:
@@ -1047,7 +1052,7 @@ bool is_pffunc_map_valid(struct rvu *rvu, u16 pcifunc, int blktype)
 	pfvf = rvu_get_pfvf(rvu, pcifunc);
 
 	/* Check if this PFFUNC has a LF of type blktype attached */
-	if (!rvu_get_rsrc_mapcount(pfvf, blktype))
+	if (blktype != BLKTYPE_SSO && !rvu_get_rsrc_mapcount(pfvf, blktype))
 		return false;
 
 	return true;
@@ -1933,12 +1938,30 @@ static void rvu_blklf_teardown(struct rvu *rvu, u16 pcifunc, u8 blkaddr)
 			rvu_nix_lf_teardown(rvu, pcifunc, block->addr, lf);
 		else if (block->addr == BLKADDR_NPA)
 			rvu_npa_lf_teardown(rvu, pcifunc, lf);
+		else if (block->addr == BLKADDR_SSO)
+			rvu_sso_lf_teardown(rvu, pcifunc, lf, slot);
+		else if (block->addr == BLKADDR_SSOW)
+			rvu_ssow_lf_teardown(rvu, pcifunc, lf, slot);
 
 		err = rvu_lf_reset(rvu, block, lf);
 		if (err) {
 			dev_err(rvu->dev, "Failed to reset blkaddr %d LF%d\n",
 				block->addr, lf);
 		}
+
+		if (block->addr == BLKADDR_SSO)
+			rvu_sso_hwgrp_config_thresh(rvu, block->addr, lf);
+	}
+}
+
+static void rvu_sso_pfvf_rst(struct rvu *rvu, u16 pcifunc)
+{
+	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
+	struct rvu_hwinfo *hw = rvu->hw;
+
+	if (pfvf->sso_uniq_ident) {
+		rvu_free_rsrc(&hw->sso.pfvf_ident, pfvf->sso_uniq_ident);
+		pfvf->sso_uniq_ident = 0;
 	}
 }
 
@@ -1957,6 +1980,7 @@ static void __rvu_flr_handler(struct rvu *rvu, u16 pcifunc)
 	rvu_blklf_teardown(rvu, pcifunc, BLKADDR_SSO);
 	rvu_blklf_teardown(rvu, pcifunc, BLKADDR_NPA);
 	rvu_detach_rsrcs(rvu, NULL, pcifunc);
+	rvu_sso_pfvf_rst(rvu, pcifunc);
 	mutex_unlock(&rvu->flr_lock);
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 5936d8e..df3cd2b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -129,6 +129,19 @@ struct npc_mcam {
 	u16     rx_miss_act_cntr; /* Counter for RX MISS action */
 };
 
+struct sso_rsrc {
+	u8      sso_hws;
+	u16     sso_hwgrps;
+	u16     sso_xaq_num_works;
+	u16     sso_xaq_buf_size;
+	u16     sso_iue;
+	u64	iaq_rsvd;
+	u64	iaq_max;
+	u64	taq_rsvd;
+	u64	taq_max;
+	struct rsrc_bmap pfvf_ident;
+};
+
 /* Structure for per RVU func info ie PF/VF */
 struct rvu_pfvf {
 	bool		npalf; /* Only one NPALF per RVU_FUNC */
@@ -138,6 +151,7 @@ struct rvu_pfvf {
 	u16		cptlfs;
 	u16		timlfs;
 	u8		cgx_lmac;
+	u8		sso_uniq_ident;
 
 	/* Block LF's MSIX vector info */
 	struct rsrc_bmap msix;      /* Bitmap for MSIX vector alloc */
@@ -257,6 +271,7 @@ struct rvu_hwinfo {
 	struct nix_hw    *nix0;
 	struct npc_pkind pkind;
 	struct npc_mcam  mcam;
+	struct sso_rsrc  sso;
 };
 
 struct mbox_wq_info {
@@ -399,6 +414,7 @@ void rvu_free_rsrc(struct rsrc_bmap *rsrc, int id);
 int rvu_rsrc_free_count(struct rsrc_bmap *rsrc);
 int rvu_alloc_rsrc_contig(struct rsrc_bmap *rsrc, int nrsrc);
 bool rvu_rsrc_check_contig(struct rsrc_bmap *rsrc, int nrsrc);
+u16 rvu_get_rsrc_mapcount(struct rvu_pfvf *pfvf, int blktype);
 int rvu_get_pf(u16 pcifunc);
 struct rvu_pfvf *rvu_get_pfvf(struct rvu *rvu, int pcifunc);
 void rvu_get_pf_numvfs(struct rvu *rvu, int pf, int *numvfs, int *hwvf);
@@ -447,6 +463,14 @@ void rvu_cgx_enadis_rx_bp(struct rvu *rvu, int pf, bool enable);
 int rvu_cgx_start_stop_io(struct rvu *rvu, u16 pcifunc, bool start);
 int rvu_cgx_nix_cuml_stats(struct rvu *rvu, void *cgxd, int lmac_id, int index,
 			   int rxtxflag, u64 *stat);
+
+/* SSO APIs */
+int rvu_sso_init(struct rvu *rvu);
+void rvu_sso_freemem(struct rvu *rvu);
+int rvu_sso_lf_teardown(struct rvu *rvu, u16 pcifunc, int lf, int slot_id);
+int rvu_ssow_lf_teardown(struct rvu *rvu, u16 pcifunc, int lf, int slot_id);
+void rvu_sso_hwgrp_config_thresh(struct rvu *rvu, int blkaddr, int lf);
+
 /* NPA APIs */
 int rvu_npa_init(struct rvu *rvu);
 void rvu_npa_freemem(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index 7ca599b..8d319b6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -405,14 +405,167 @@
 #define NIX_PRIV_LFX_INT_CFG		(0x8000020)
 #define NIX_AF_RVU_LF_CFG_DEBUG		(0x8000030)
 
+#define NIX_AF_LF_CFG_SHIFT		17
+#define NIX_AF_LF_SSO_PF_FUNC_SHIFT	16
+
 /* SSO */
 #define SSO_AF_CONST			(0x1000)
 #define SSO_AF_CONST1			(0x1008)
-#define SSO_AF_BLK_RST			(0x10f8)
+#define SSO_AF_NOS_CNT			(0x1050)
+#define SSO_AF_AW_WE			(0x1080)
 #define SSO_AF_LF_HWGRP_RST		(0x10e0)
+#define SSO_AF_AW_CFG			(0x10f0)
+#define SSO_AF_BLK_RST			(0x10f8)
+#define SSO_AF_ACTIVE_CYCLES0		(0x1100)
+#define SSO_AF_ACTIVE_CYCLES1		(0x1108)
+#define SSO_AF_ACTIVE_CYCLES2		(0x1110)
+#define SSO_AF_ERR0			(0x1220)
+#define SSO_AF_ERR0_W1S			(0x1228)
+#define SSO_AF_ERR0_ENA_W1C		(0x1230)
+#define SSO_AF_ERR0_ENA_W1S		(0x1238)
+#define SSO_AF_ERR2			(0x1260)
+#define SSO_AF_ERR2_W1S			(0x1268)
+#define SSO_AF_ERR2_ENA_W1C		(0x1270)
+#define SSO_AF_ERR2_ENA_W1S		(0x1278)
+#define SSO_AF_UNMAP_INFO		(0x12f0)
+#define SSO_AF_UNMAP_INFO2		(0x1300)
+#define SSO_AF_UNMAP_INFO3		(0x1310)
+#define SSO_AF_RAS			(0x1420)
+#define SSO_AF_RAS_W1S			(0x1430)
+#define SSO_AF_RAS_ENA_W1C		(0x1460)
+#define SSO_AF_RAS_ENA_W1S		(0x1470)
+#define SSO_PRIV_AF_INT_CFG		(0x3000)
+#define SSO_AF_AW_ADD			(0x2080)
+#define SSO_AF_AW_READ_ARB		(0x2090)
+#define SSO_AF_XAQ_REQ_PC		(0x20B0)
+#define SSO_AF_XAQ_LATENCY_PC		(0x20B8)
+#define SSO_AF_TAQ_CNT			(0x20c0)
+#define SSO_AF_TAQ_ADD			(0x20e0)
+#define SSO_AF_POISONX(a)		(0x2100 | (a) << 3)
+#define SSO_AF_POISONX_W1S(a)		(0x2200 | (a) << 3)
 #define SSO_AF_RVU_LF_CFG_DEBUG		(0x3800)
 #define SSO_PRIV_LFX_HWGRP_CFG		(0x10000)
 #define SSO_PRIV_LFX_HWGRP_INT_CFG	(0x20000)
+#define SSO_AF_XAQX_GMCTL(a)		(0xe0000 | (a) << 3)
+#define SSO_AF_XAQX_HEAD_PTR(a)		(0x80000 | (a) << 3)
+#define SSO_AF_XAQX_TAIL_PTR(a)		(0x90000 | (a) << 3)
+#define SSO_AF_XAQX_HEAD_NEXT(a)	(0xa0000 | (a) << 3)
+#define SSO_AF_XAQX_TAIL_NEXT(a)	(0xb0000 | (a) << 3)
+#define SSO_AF_TOAQX_STATUS(a)		(0xd0000 | (a) << 3)
+#define SSO_AF_TIAQX_STATUS(a)		(0xc0000 | (a) << 3)
+#define SSO_AF_HWGRPX_IAQ_THR(a)	(0x200000 | (a) << 12)
+#define SSO_AF_HWGRPX_TAQ_THR(a)	(0x200010 | (a) << 12)
+#define SSO_AF_HWGRPX_PRI(a)		(0x200020 | (a) << 12)
+#define SSO_AF_HWGRPX_WS_PC(a)		(0x200050 | (a) << 12)
+#define SSO_AF_HWGRPX_EXT_PC(a)		(0x200060 | (a) << 12)
+#define SSO_AF_HWGRPX_WA_PC(a)		(0x200070 | (a) << 12)
+#define SSO_AF_HWGRPX_TS_PC(a)		(0x200080 | (a) << 12)
+#define SSO_AF_HWGRPX_DS_PC(a)		(0x200090 | (a) << 12)
+#define SSO_AF_HWGRPX_DQ_PC(a)		(0x2000A0 | (a) << 12)
+#define SSO_AF_HWGRPX_PAGE_CNT(a)	(0x200100 | (a) << 12)
+#define SSO_AF_IU_ACCNTX_CFG(a)		(0x50000 | (a) << 3)
+#define SSO_AF_IU_ACCNTX_RST(a)		(0x60000 | (a) << 3)
+#define SSO_AF_HWGRPX_AW_STATUS(a)	(0x200110 | (a) << 12)
+#define SSO_AF_HWGRPX_AW_CFG(a)		(0x200120 | (a) << 12)
+#define SSO_AF_HWGRPX_AW_TAGSPACE(a)	(0x200130 | (a) << 12)
+#define SSO_AF_HWGRPX_XAQ_AURA(a)	(0x200140 | (a) << 12)
+#define SSO_AF_HWGRPX_XAQ_LIMIT(a)	(0x200220 | (a) << 12)
+#define SSO_AF_HWGRPX_IU_ACCNT(a)	(0x200230 | (a) << 12)
+#define SSO_AF_HWSX_ARB(a)		(0x400100 | (a) << 12)
+#define SSO_AF_HWSX_INV(a)		(0x400180 | (a) << 12)
+#define SSO_AF_HWSX_GMCTL(a)		(0x400200 | (a) << 12)
+#define SSO_AF_HWSX_SX_GRPMSKX(a, b, c) \
+				(0x400400 | (a) << 12 | (b) << 5 | (c) << 3)
+#define SSO_AF_TAQX_LINK(a)		(0xc00000 | (a) << 3)
+#define SSO_AF_TAQX_WAEY_TAG(a, b)	(0xe00000 | (a) << 8 | (b) << 4)
+#define SSO_AF_TAQX_WAEY_WQP(a, b)	(0xe00008 | (a) << 8 | (b) << 4)
+#define SSO_AF_IPL_FREEX(a)		(0x800000 | (a) << 3)
+#define SSO_AF_IPL_IAQX(a)		(0x840000 | (a) << 3)
+#define SSO_AF_IPL_DESCHEDX(a)		(0x860000 | (a) << 3)
+#define SSO_AF_IPL_CONFX(a)		(0x880000 | (a) << 3)
+#define SSO_AF_IENTX_TAG(a)		(0Xa00000 | (a) << 3)
+#define SSO_AF_IENTX_GRP(a)		(0xa20000 | (a) << 3)
+#define SSO_AF_IENTX_PENDTAG(a)		(0xa40000 | (a) << 3)
+#define SSO_AF_IENTX_LINKS(a)		(0xa60000 | (a) << 3)
+#define SSO_AF_IENTX_QLINKS(a)		(0xa80000 | (a) << 3)
+#define SSO_AF_IENTX_WQP(a)		(0xaa0000 | (a) << 3)
+#define SSO_AF_XAQDIS_DIGESTX(a)	(0x901000 | (a) << 3)
+#define SSO_AF_FLR_AQ_DIGESTX(a)	(0x901200 | (a) << 3)
+#define SSO_AF_QCTLDIS_DIGESTX(a)	(0x900E00 | (a) << 3)
+#define SSO_AF_WQP0_DIGESTX(a)		(0x900A00 | (a) << 3)
+#define SSO_AF_NPA_DIGESTX(a)		(0x900000 | (a) << 3)
+#define SSO_AF_BFP_DIGESTX(a)		(0x900200 | (a) << 3)
+#define SSO_AF_BFPN_DIGESTX(a)		(0x900400 | (a) << 3)
+#define SSO_AF_GRPDIS_DIGESTX(a)	(0x900600 | (a) << 3)
+
+#define SSO_AF_IAQ_FREE_CNT_MASK	0x3FFFull
+#define SSO_AF_IAQ_RSVD_FREE_MASK	0x3FFFull
+#define SSO_AF_IAQ_RSVD_FREE_SHIFT	16
+#define SSO_AF_IAQ_FREE_CNT_MAX		SSO_AF_IAQ_FREE_CNT_MASK
+#define SSO_AF_AW_ADD_RSVD_FREE_MASK	0x3FFFull
+#define SSO_AF_AW_ADD_RSVD_FREE_SHIFT	16
+#define SSO_HWGRP_IAQ_MAX_THR_MASK	0x3FFFull
+#define SSO_HWGRP_IAQ_RSVD_THR_MASK	0x3FFFull
+#define SSO_HWGRP_IAQ_MAX_THR_SHIFT	32
+#define SSO_HWGRP_IAQ_RSVD_THR		0x2
+#define SSO_HWGRP_IAQ_GRP_CNT_SHIFT	48
+#define SSO_HWGRP_IAQ_GRP_CNT_MASK	0x3FFFull
+#define SSO_AF_HWGRPX_IUEX_NOSCHED(a, b)\
+		(((((b) >> 48) & 0x3FF) == (a)) && ((b) & BIT_ULL(60)))
+#define SSO_AF_HWGRP_PAGE_CNT_MASK	(BIT_ULL(32) - 1)
+#define SSO_AF_HWGRP_PAGE_CNT_MASK	(BIT_ULL(32) - 1)
+#define SSO_HWGRP_IAQ_MAX_THR_STRM_PERF	0xD0
+#define SSO_AF_HWGRP_IU_ACCNT_MAX_THR	0x7FFFull
+
+#define SSO_AF_TAQ_FREE_CNT_MASK	0x7FFull
+#define SSO_AF_TAQ_RSVD_FREE_MASK	0x7FFull
+#define SSO_AF_TAQ_RSVD_FREE_SHIFT	16
+#define SSO_AF_TAQ_FREE_CNT_MAX		SSO_AF_TAQ_FREE_CNT_MASK
+#define SSO_AF_TAQ_ADD_RSVD_FREE_MASK	0x1FFFull
+#define SSO_AF_TAQ_ADD_RSVD_FREE_SHIFT	16
+#define SSO_HWGRP_TAQ_MAX_THR_MASK	0x7FFull
+#define SSO_HWGRP_TAQ_RSVD_THR_MASK	0x7FFull
+#define SSO_HWGRP_TAQ_MAX_THR_SHIFT	32
+#define SSO_HWGRP_TAQ_RSVD_THR		0x3
+#define SSO_AF_ERR0_MASK		0xFFEull
+#define SSO_AF_ERR2_MASK		0xF001F000ull
+#define SSO_HWGRP_TAQ_MAX_THR_STRM_PERF	0x10
+
+#define SSO_HWGRP_PRI_MASK		0x7ull
+#define SSO_HWGRP_PRI_AFF_MASK		0xFull
+#define SSO_HWGRP_PRI_AFF_SHIFT		8
+#define SSO_HWGRP_PRI_WGT_MASK		0x3Full
+#define SSO_HWGRP_PRI_WGT_SHIFT		16
+#define SSO_HWGRP_PRI_WGT_LEFT_MASK	0x3Full
+#define SSO_HWGRP_PRI_WGT_LEFT_SHIFT	24
+
+#define SSO_HWGRP_AW_CFG_RWEN		BIT_ULL(0)
+#define SSO_HWGRP_AW_CFG_LDWB		BIT_ULL(1)
+#define SSO_HWGRP_AW_CFG_LDT		BIT_ULL(2)
+#define SSO_HWGRP_AW_CFG_STT		BIT_ULL(3)
+#define SSO_HWGRP_AW_CFG_XAQ_BYP_DIS	BIT_ULL(4)
+
+#define SSO_HWGRP_AW_STS_TPTR_VLD	BIT_ULL(8)
+#define SSO_HWGRP_AW_STS_NPA_FETCH	BIT_ULL(9)
+#define SSO_HWGRP_AW_STS_XAQ_BUFSC_MASK	0x7ull
+#define SSO_HWGRP_AW_STS_INIT_STS	0x18ull
+
+#define SSO_LF_GGRP_OP_ADD_WORK1	(0x8ull)
+#define SSO_LF_GGRP_QCTL		(0x20ull)
+#define SSO_LF_GGRP_INT			(0x100ull)
+#define SSO_LF_GGRP_INT_ENA_W1S		(0x110ull)
+#define SSO_LF_GGRP_INT_ENA_W1C		(0x118ull)
+#define SSO_LF_GGRP_INT_THR		(0x140ull)
+#define SSO_LF_GGRP_INT_CNT		(0x180ull)
+#define SSO_LF_GGRP_XAQ_CNT		(0x1b0ull)
+#define SSO_LF_GGRP_AQ_CNT		(0x1c0ull)
+#define SSO_LF_GGRP_AQ_THR		(0x1e0ull)
+#define SSO_LF_GGRP_MISC_CNT		(0x200ull)
+
+#define SSO_LF_GGRP_INT_MASK		(0X7)
+#define SSO_LF_GGRP_AQ_THR_MASK		(BIT_ULL(33) - 1)
+#define SSO_LF_GGRP_XAQ_CNT_MASK	(BIT_ULL(33) - 1)
+#define SSO_LF_GGRP_INT_CNT_MASK	(0x3FFF3FFF0000ull)
 
 /* SSOW */
 #define SSOW_AF_RVU_LF_HWS_CFG_DEBUG	(0x0010)
@@ -420,6 +573,22 @@
 #define SSOW_PRIV_LFX_HWS_CFG		(0x1000)
 #define SSOW_PRIV_LFX_HWS_INT_CFG	(0x2000)
 
+#define SSOW_LF_GWS_PENDSTATE		(0x50ull)
+#define SSOW_LF_GWS_NW_TIM		(0x70ull)
+#define SSOW_LF_GWS_INT			(0x100ull)
+#define SSOW_LF_GWS_INT_ENA_W1C		(0x118ull)
+#define SSOW_LF_GWS_TAG			(0x200ull)
+#define SSOW_LF_GWS_WQP			(0x210ull)
+#define SSOW_LF_GWS_OP_GET_WORK		(0x600ull)
+#define SSOW_LF_GWS_OP_SWTAG_FLUSH	(0x800ull)
+#define SSOW_LF_GWS_OP_DESCHED		(0x880ull)
+#define SSOW_LF_GWS_OP_CLR_NSCHED0	(0xA00ull)
+#define SSOW_LF_GWS_OP_GWC_INVAL	(0xe00ull)
+
+#define SSO_TT_EMPTY			(0x3)
+#define SSOW_LF_GWS_INT_MASK		(0x7FF)
+#define SSOW_LF_GWS_MAX_NW_TIM		(BIT_ULL(10) - 1)
+
 /* TIM */
 #define TIM_AF_CONST			(0x90)
 #define TIM_PRIV_LFX_CFG		(0x20000)
@@ -525,4 +694,13 @@
 		(0x00F00 | (a) << 5 | (b) << 4)
 #define NDC_AF_BANKX_HIT_PC(a)		(0x01000 | (a) << 3)
 #define NDC_AF_BANKX_MISS_PC(a)		(0x01100 | (a) << 3)
+
+#define AF_BAR2_ALIASX_SIZE		(0x100000ull)
+#define SSOW_AF_BAR2_SEL		(0x9000000ull)
+#define SSO_AF_BAR2_SEL			(0x9000000ull)
+
+#define AF_BAR2_ALIASX(a, b)		(0x9100000ull | (a) << 12 | (b))
+#define SSOW_AF_BAR2_ALIASX(a, b)	AF_BAR2_ALIASX(a, b)
+#define SSO_AF_BAR2_ALIASX(a, b)	AF_BAR2_ALIASX(a, b)
+
 #endif /* RVU_REG_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_sso.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_sso.c
new file mode 100644
index 0000000..cc80cc7
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_sso.c
@@ -0,0 +1,837 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell OcteonTx2 RVU Admin Function driver
+ *
+ * Copyright (C) 2019 Marvell International Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/types.h>
+
+#include "rvu_struct.h"
+
+#include "rvu_reg.h"
+#include "rvu.h"
+
+#if defined(CONFIG_ARM64)
+#define rvu_sso_store_pair(val0, val1, addr) ({				\
+	__asm__ volatile("stp %x[x0], %x[x1], [%x[p1]]"			\
+			 :						\
+			 :						\
+			 [x0]"r"(val0), [x1]"r"(val1), [p1]"r"(addr));	\
+	})
+#else
+#define rvu_sso_store_pair(val0, val1, addr)				\
+	do {								\
+		u64 *addr1 = (void *)addr;				\
+		*addr1 = val0;						\
+		*(u64 *)(((u8 *)addr1) + 8) = val1;			\
+	} while (0)
+#endif
+
+void rvu_sso_hwgrp_config_thresh(struct rvu *rvu, int blkaddr, int lf)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	u64 add, grp_thr, grp_rsvd;
+	u64 reg;
+
+	/* Configure IAQ Thresholds */
+	reg = rvu_read64(rvu, blkaddr, SSO_AF_HWGRPX_IAQ_THR(lf));
+	grp_rsvd = reg & SSO_HWGRP_IAQ_RSVD_THR_MASK;
+	add = hw->sso.iaq_rsvd - grp_rsvd;
+
+	grp_thr = hw->sso.iaq_rsvd & SSO_HWGRP_IAQ_RSVD_THR_MASK;
+	grp_thr |= ((hw->sso.iaq_max & SSO_HWGRP_IAQ_MAX_THR_MASK) <<
+		    SSO_HWGRP_IAQ_MAX_THR_SHIFT);
+
+	rvu_write64(rvu, blkaddr, SSO_AF_HWGRPX_IAQ_THR(lf), grp_thr);
+
+	if (add)
+		rvu_write64(rvu, blkaddr, SSO_AF_AW_ADD,
+			    (add & SSO_AF_AW_ADD_RSVD_FREE_MASK) <<
+			    SSO_AF_AW_ADD_RSVD_FREE_SHIFT);
+
+	/* Configure TAQ Thresholds */
+	reg = rvu_read64(rvu, blkaddr, SSO_AF_HWGRPX_TAQ_THR(lf));
+	grp_rsvd = reg & SSO_HWGRP_TAQ_RSVD_THR_MASK;
+	add = hw->sso.taq_rsvd - grp_rsvd;
+
+	grp_thr = hw->sso.taq_rsvd & SSO_HWGRP_TAQ_RSVD_THR_MASK;
+	grp_thr |= ((hw->sso.taq_max & SSO_HWGRP_TAQ_MAX_THR_MASK) <<
+		    SSO_HWGRP_TAQ_MAX_THR_SHIFT);
+
+	rvu_write64(rvu, blkaddr, SSO_AF_HWGRPX_TAQ_THR(lf), grp_thr);
+
+	if (add)
+		rvu_write64(rvu, blkaddr, SSO_AF_TAQ_ADD,
+			    (add & SSO_AF_TAQ_RSVD_FREE_MASK) <<
+			    SSO_AF_TAQ_ADD_RSVD_FREE_SHIFT);
+}
+
+int rvu_sso_lf_teardown(struct rvu *rvu, u16 pcifunc, int lf, int slot)
+{
+	int ssow_lf, iue, blkaddr, ssow_blkaddr, err;
+	struct sso_rsrc *sso = &rvu->hw->sso;
+	struct rvu_hwinfo *hw = rvu->hw;
+	u64 aq_cnt, ds_cnt, cq_ds_cnt;
+	u64 reg, add, wqp, val;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_SSO, 0);
+	if (blkaddr < 0)
+		return SSO_AF_ERR_LF_INVALID;
+
+	/* Enable BAR2 ALIAS for this pcifunc. */
+	reg = BIT_ULL(16) | pcifunc;
+	rvu_write64(rvu, blkaddr, SSO_AF_BAR2_SEL, reg);
+
+	rvu_write64(rvu, blkaddr,
+		    SSO_AF_BAR2_ALIASX(slot, SSO_LF_GGRP_INT_THR), 0x0);
+	rvu_write64(rvu, blkaddr,
+		    SSO_AF_BAR2_ALIASX(slot, SSO_LF_GGRP_AQ_THR),
+		    SSO_LF_GGRP_AQ_THR_MASK);
+
+	rvu_write64(rvu, blkaddr,
+		    SSO_AF_BAR2_ALIASX(slot, SSO_LF_GGRP_INT),
+		    SSO_LF_GGRP_INT_MASK);
+	rvu_write64(rvu, blkaddr,
+		    SSO_AF_BAR2_ALIASX(slot, SSO_LF_GGRP_INT_ENA_W1C),
+		    SSO_LF_GGRP_INT_MASK);
+
+	ssow_blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_SSOW, 0);
+	if (ssow_blkaddr < 0)
+		goto af_cleanup;
+	/* Check if LF is in slot 0, if not no HWS are attached. */
+	ssow_lf = rvu_get_lf(rvu, &hw->block[ssow_blkaddr], pcifunc, 0);
+	if (ssow_lf < 0)
+		goto af_cleanup;
+
+	rvu_write64(rvu, ssow_blkaddr, SSOW_AF_BAR2_SEL, reg);
+
+	/* Ignore all interrupts */
+	rvu_write64(rvu, ssow_blkaddr,
+		    SSOW_AF_BAR2_ALIASX(0, SSOW_LF_GWS_INT_ENA_W1C),
+		    SSOW_LF_GWS_INT_MASK);
+	rvu_write64(rvu, ssow_blkaddr,
+		    SSOW_AF_BAR2_ALIASX(0, SSOW_LF_GWS_INT),
+		    SSOW_LF_GWS_INT_MASK);
+
+	/* Prepare WS for GW operations. */
+	do {
+		reg = rvu_read64(rvu, ssow_blkaddr,
+				 SSOW_AF_BAR2_ALIASX(0, SSOW_LF_GWS_TAG));
+	} while (reg & BIT_ULL(63));
+
+	if (reg & BIT_ULL(62))
+		rvu_write64(rvu, ssow_blkaddr,
+			    SSOW_AF_BAR2_ALIASX(0, SSOW_LF_GWS_OP_DESCHED), 0);
+	else if (((reg >> 32) & SSO_TT_EMPTY) != SSO_TT_EMPTY)
+		rvu_write64(rvu, ssow_blkaddr,
+			    SSOW_AF_BAR2_ALIASX(0, SSOW_LF_GWS_OP_SWTAG_FLUSH),
+			    0);
+
+	rvu_write64(rvu, ssow_blkaddr,
+		    SSOW_AF_BAR2_ALIASX(0, SSOW_LF_GWS_OP_GWC_INVAL), 0);
+
+	/* Disable add work. */
+	rvu_write64(rvu, blkaddr, SSO_AF_BAR2_ALIASX(slot, SSO_LF_GGRP_QCTL),
+		    0x0);
+
+	/* HRM 14.13.4 (4) */
+	/* Clean up nscheduled IENT let the work flow. */
+	for (iue = 0; iue < sso->sso_iue; iue++) {
+		reg = rvu_read64(rvu, blkaddr, SSO_AF_IENTX_GRP(iue));
+		if (SSO_AF_HWGRPX_IUEX_NOSCHED(lf, reg)) {
+			wqp = rvu_read64(rvu, blkaddr, SSO_AF_IENTX_WQP(iue));
+			rvu_sso_store_pair(wqp, iue, rvu->afreg_base +
+					   ((ssow_blkaddr << 28) |
+					    SSOW_AF_BAR2_ALIASX(0,
+						  SSOW_LF_GWS_OP_CLR_NSCHED0)));
+		}
+	}
+
+	/* HRM 14.13.4 (6) */
+	/* Drain all the work using grouped gw. */
+	aq_cnt = rvu_read64(rvu, blkaddr,
+			    SSO_AF_BAR2_ALIASX(slot, SSO_LF_GGRP_AQ_CNT));
+	ds_cnt = rvu_read64(rvu, blkaddr,
+			    SSO_AF_BAR2_ALIASX(slot, SSO_LF_GGRP_MISC_CNT));
+	cq_ds_cnt = rvu_read64(rvu, blkaddr,
+			       SSO_AF_BAR2_ALIASX(slot, SSO_LF_GGRP_INT_CNT));
+	cq_ds_cnt &= SSO_LF_GGRP_INT_CNT_MASK;
+
+	val  = slot;		/* GGRP ID */
+	val |= BIT_ULL(18);	/* Grouped */
+	val |= BIT_ULL(16);	/* WAIT */
+
+	rvu_write64(rvu, ssow_blkaddr,
+		    SSOW_AF_BAR2_ALIASX(0, SSOW_LF_GWS_NW_TIM),
+		    SSOW_LF_GWS_MAX_NW_TIM);
+
+	while (aq_cnt || cq_ds_cnt || ds_cnt) {
+		rvu_write64(rvu, ssow_blkaddr,
+			    SSOW_AF_BAR2_ALIASX(0, SSOW_LF_GWS_OP_GET_WORK),
+			    val);
+		do {
+			reg = rvu_read64(rvu, ssow_blkaddr,
+					 SSOW_AF_BAR2_ALIASX(0,
+							     SSOW_LF_GWS_TAG));
+		} while (reg & BIT_ULL(63));
+		if (((reg >> 32) & SSO_TT_EMPTY) != SSO_TT_EMPTY)
+			rvu_write64(rvu, ssow_blkaddr,
+				    SSOW_AF_BAR2_ALIASX(0,
+						SSOW_LF_GWS_OP_SWTAG_FLUSH),
+				    0x0);
+		aq_cnt = rvu_read64(rvu, blkaddr,
+				    SSO_AF_BAR2_ALIASX(slot, SSO_LF_GGRP_AQ_CNT)
+				    );
+		ds_cnt = rvu_read64(rvu, blkaddr,
+				    SSO_AF_BAR2_ALIASX(slot,
+						       SSO_LF_GGRP_MISC_CNT));
+		cq_ds_cnt = rvu_read64(rvu, blkaddr,
+				       SSO_AF_BAR2_ALIASX(slot,
+							  SSO_LF_GGRP_INT_CNT));
+		/* Extract cq and ds count */
+		cq_ds_cnt &= SSO_LF_GGRP_INT_CNT_MASK;
+	}
+
+	rvu_write64(rvu, ssow_blkaddr,
+		    SSOW_AF_BAR2_ALIASX(0, SSOW_LF_GWS_NW_TIM), 0x0);
+
+	/* HRM 14.13.4 (7) */
+	reg = rvu_read64(rvu, blkaddr,
+			 SSO_AF_BAR2_ALIASX(slot, SSO_LF_GGRP_XAQ_CNT))
+		& SSO_LF_GGRP_XAQ_CNT_MASK;
+	if (reg != 0)
+		dev_warn(rvu->dev,
+			 "SSO_LF[%d]_GGRP_XAQ_CNT is %lld expected 0", lf, reg);
+
+	reg = rvu_read64(rvu, blkaddr, SSO_AF_HWGRPX_PAGE_CNT(lf))
+		& SSO_AF_HWGRP_PAGE_CNT_MASK;
+	if (reg != 0)
+		dev_warn(rvu->dev,
+			 "SSO_AF_HWGRP[%d]_PAGE_CNT is %lld expected 0", lf,
+			 reg);
+
+	reg = rvu_read64(rvu, blkaddr, SSO_AF_HWGRPX_IAQ_THR(lf))
+		>> SSO_HWGRP_IAQ_GRP_CNT_SHIFT;
+	reg &= SSO_HWGRP_IAQ_GRP_CNT_MASK;
+	if (reg != 0)
+		dev_warn(rvu->dev,
+			 "SSO_AF_HWGRP[%d]_IAQ_THR is %lld expected 0", lf,
+			 reg);
+	rvu_write64(rvu, ssow_blkaddr, SSOW_AF_BAR2_SEL, 0);
+	rvu_write64(rvu, blkaddr, SSO_AF_HWSX_INV(ssow_lf), 0x1);
+
+af_cleanup:
+	reg = rvu_read64(rvu, blkaddr, SSO_AF_UNMAP_INFO);
+	if ((reg & 0xFFF) == pcifunc)
+		rvu_write64(rvu, blkaddr, SSO_AF_ERR0, SSO_AF_ERR0_MASK);
+
+	reg = rvu_read64(rvu, blkaddr, SSO_AF_UNMAP_INFO2);
+	if ((reg & 0xFFF) == pcifunc)
+		rvu_write64(rvu, blkaddr, SSO_AF_ERR2, SSO_AF_ERR2_MASK);
+
+	rvu_write64(rvu, blkaddr, SSO_AF_POISONX(lf / 64), lf % 64);
+	rvu_write64(rvu, blkaddr, SSO_AF_IU_ACCNTX_RST(lf), 0x1);
+
+	err = rvu_poll_reg(rvu, blkaddr, SSO_AF_HWGRPX_AW_STATUS(lf),
+			   SSO_HWGRP_AW_STS_NPA_FETCH, true);
+	if (err)
+		dev_warn(rvu->dev,
+			 "SSO_HWGRP(%d)_AW_STATUS[NPA_FETCH] not cleared", lf);
+
+	/* Remove all pointers from XAQ, HRM 14.13.6 */
+	rvu_write64(rvu, blkaddr, SSO_AF_ERR0_ENA_W1C, ~0ULL);
+	reg = rvu_read64(rvu, blkaddr, SSO_AF_HWGRPX_AW_CFG(lf));
+	reg = (reg & ~SSO_HWGRP_AW_CFG_RWEN) | SSO_HWGRP_AW_CFG_XAQ_BYP_DIS;
+	rvu_write64(rvu, blkaddr, SSO_AF_HWGRPX_AW_CFG(lf), reg);
+
+	reg = rvu_read64(rvu, blkaddr, SSO_AF_HWGRPX_AW_STATUS(lf));
+	if (reg & SSO_HWGRP_AW_STS_TPTR_VLD) {
+		/* aura will be torn down, no need to free the pointer. */
+		rvu_write64(rvu, blkaddr, SSO_AF_HWGRPX_AW_STATUS(lf),
+			    SSO_HWGRP_AW_STS_TPTR_VLD);
+	}
+
+	err = rvu_poll_reg(rvu, blkaddr, SSO_AF_HWGRPX_AW_STATUS(lf),
+			   SSO_HWGRP_AW_STS_XAQ_BUFSC_MASK, true);
+	if (err) {
+		dev_warn(rvu->dev,
+			 "SSO_HWGRP(%d)_AW_STATUS[XAQ_BUF_CACHED] not cleared",
+			 lf);
+		return err;
+	}
+
+	rvu_write64(rvu, blkaddr, SSO_AF_ERR0, ~0ULL);
+	/* Re-enable error reporting once we're finished */
+	rvu_write64(rvu, blkaddr, SSO_AF_ERR0_ENA_W1S, ~0ULL);
+
+	/* HRM 14.13.4 (13) */
+	rvu_write64(rvu, blkaddr, SSO_AF_HWGRPX_AW_STATUS(lf), 0x0);
+	rvu_write64(rvu, blkaddr, SSO_AF_HWGRPX_AW_CFG(lf),
+		    SSO_HWGRP_AW_CFG_LDWB | SSO_HWGRP_AW_CFG_LDT |
+		    SSO_HWGRP_AW_CFG_STT);
+	rvu_write64(rvu, blkaddr, SSO_AF_HWGRPX_XAQ_AURA(lf), 0x0);
+	rvu_write64(rvu, blkaddr, SSO_AF_XAQX_GMCTL(lf), 0x0);
+	reg = (SSO_HWGRP_PRI_AFF_MASK << SSO_HWGRP_PRI_AFF_SHIFT) |
+	      (SSO_HWGRP_PRI_WGT_MASK << SSO_HWGRP_PRI_WGT_SHIFT) |
+	      (0x1 << SSO_HWGRP_PRI_WGT_SHIFT);
+	rvu_write64(rvu, blkaddr, SSO_AF_HWGRPX_PRI(lf), reg);
+	rvu_write64(rvu, blkaddr, SSO_AF_HWGRPX_WS_PC(lf), 0x0);
+	rvu_write64(rvu, blkaddr, SSO_AF_HWGRPX_EXT_PC(lf), 0x0);
+	rvu_write64(rvu, blkaddr, SSO_AF_HWGRPX_WA_PC(lf), 0x0);
+	rvu_write64(rvu, blkaddr, SSO_AF_HWGRPX_TS_PC(lf), 0x0);
+	rvu_write64(rvu, blkaddr, SSO_AF_HWGRPX_DS_PC(lf), 0x0);
+	rvu_write64(rvu, blkaddr, SSO_AF_HWGRPX_XAQ_LIMIT(lf), 0x0);
+	rvu_write64(rvu, blkaddr, SSO_AF_HWGRPX_IU_ACCNT(lf), 0x0);
+
+	/* The delta between the current and default thresholds
+	 * need to be returned to the SSO
+	 */
+	reg = rvu_read64(rvu, blkaddr, SSO_AF_HWGRPX_IAQ_THR(lf)) &
+		SSO_HWGRP_IAQ_RSVD_THR_MASK;
+	add = SSO_HWGRP_IAQ_RSVD_THR - reg;
+	reg = (SSO_HWGRP_IAQ_MAX_THR_MASK << SSO_HWGRP_IAQ_MAX_THR_SHIFT) |
+	      SSO_HWGRP_IAQ_RSVD_THR;
+	rvu_write64(rvu, blkaddr, SSO_AF_HWGRPX_IAQ_THR(lf), reg);
+
+	if (add)
+		rvu_write64(rvu, blkaddr, SSO_AF_AW_ADD,
+			    (add & SSO_AF_AW_ADD_RSVD_FREE_MASK) <<
+			    SSO_AF_AW_ADD_RSVD_FREE_SHIFT);
+
+	reg = rvu_read64(rvu, blkaddr, SSO_AF_HWGRPX_TAQ_THR(lf)) &
+		SSO_HWGRP_TAQ_RSVD_THR_MASK;
+	add = SSO_HWGRP_TAQ_RSVD_THR - reg;
+	reg = (SSO_HWGRP_TAQ_MAX_THR_MASK << SSO_HWGRP_TAQ_MAX_THR_SHIFT) |
+	      SSO_HWGRP_TAQ_RSVD_THR;
+	rvu_write64(rvu, blkaddr, SSO_AF_HWGRPX_TAQ_THR(lf), reg);
+	if (add)
+		rvu_write64(rvu, blkaddr, SSO_AF_TAQ_ADD,
+			    (add & SSO_AF_TAQ_RSVD_FREE_MASK) <<
+			    SSO_AF_TAQ_ADD_RSVD_FREE_SHIFT);
+
+	rvu_write64(rvu, blkaddr, SSO_AF_XAQX_HEAD_PTR(lf), 0x0);
+	rvu_write64(rvu, blkaddr, SSO_AF_XAQX_TAIL_PTR(lf), 0x0);
+	rvu_write64(rvu, blkaddr, SSO_AF_XAQX_HEAD_NEXT(lf), 0x0);
+	rvu_write64(rvu, blkaddr, SSO_AF_XAQX_TAIL_NEXT(lf), 0x0);
+
+	rvu_write64(rvu, blkaddr, SSO_AF_BAR2_SEL, 0);
+
+	return 0;
+}
+
+int rvu_ssow_lf_teardown(struct rvu *rvu, u16 pcifunc, int lf, int slot)
+{
+	int blkaddr, ssow_blkaddr;
+	u64 reg;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_SSO, 0);
+	if (blkaddr < 0)
+		return SSOW_AF_ERR_LF_INVALID;
+
+	ssow_blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_SSOW, 0);
+	if (ssow_blkaddr < 0)
+		return SSOW_AF_ERR_LF_INVALID;
+
+	/* Enable BAR2 alias access. */
+	reg = BIT_ULL(16) | pcifunc;
+	rvu_write64(rvu, ssow_blkaddr, SSOW_AF_BAR2_SEL, reg);
+
+	/* Ignore all interrupts */
+	rvu_write64(rvu, ssow_blkaddr,
+		    SSOW_AF_BAR2_ALIASX(0, SSOW_LF_GWS_INT_ENA_W1C),
+		    SSOW_LF_GWS_INT_MASK);
+	rvu_write64(rvu, ssow_blkaddr,
+		    SSOW_AF_BAR2_ALIASX(0, SSOW_LF_GWS_INT),
+		    SSOW_LF_GWS_INT_MASK);
+
+	/* HRM 14.13.4 (3) */
+	/* Wait till waitw/desched completes. */
+	do {
+		reg = rvu_read64(rvu, ssow_blkaddr,
+				 SSOW_AF_BAR2_ALIASX(slot,
+						     SSOW_LF_GWS_PENDSTATE));
+	} while (reg & (BIT_ULL(63) | BIT_ULL(58)));
+
+	reg = rvu_read64(rvu, ssow_blkaddr,
+			 SSOW_AF_BAR2_ALIASX(slot, SSOW_LF_GWS_TAG));
+	/* Switch Tag Pending */
+	if (reg & BIT_ULL(62))
+		rvu_write64(rvu, ssow_blkaddr,
+			    SSOW_AF_BAR2_ALIASX(slot, SSOW_LF_GWS_OP_DESCHED),
+			    0x0);
+	/* Tag Type != EMPTY use swtag_flush to release tag-chain. */
+	else if (((reg >> 32) & SSO_TT_EMPTY) != SSO_TT_EMPTY)
+		rvu_write64(rvu, ssow_blkaddr,
+			    SSOW_AF_BAR2_ALIASX(slot,
+						SSOW_LF_GWS_OP_SWTAG_FLUSH),
+			    0x0);
+
+	/* Wait for desched to complete. */
+	do {
+		reg = rvu_read64(rvu, ssow_blkaddr,
+				 SSOW_AF_BAR2_ALIASX(slot,
+						     SSOW_LF_GWS_PENDSTATE));
+	} while (reg & BIT_ULL(58));
+
+	rvu_write64(rvu, ssow_blkaddr,
+		    SSOW_AF_BAR2_ALIASX(0, SSOW_LF_GWS_NW_TIM), 0x0);
+	rvu_write64(rvu, ssow_blkaddr,
+		    SSOW_AF_BAR2_ALIASX(0, SSOW_LF_GWS_OP_GWC_INVAL), 0x0);
+
+	/* set SAI_INVAL bit */
+	rvu_write64(rvu, blkaddr, SSO_AF_HWSX_INV(lf), 0x1);
+	rvu_write64(rvu, blkaddr, SSO_AF_HWSX_ARB(lf), 0x0);
+	rvu_write64(rvu, blkaddr, SSO_AF_HWSX_GMCTL(lf), 0x0);
+
+	rvu_write64(rvu, ssow_blkaddr, SSOW_AF_BAR2_SEL, 0x0);
+
+	return 0;
+}
+
+int rvu_mbox_handler_sso_hw_setconfig(struct rvu *rvu,
+				      struct sso_hw_setconfig *req,
+				      struct msg_rsp *rsp)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	u16 pcifunc = req->hdr.pcifunc;
+	int hwgrp, lf, err, blkaddr;
+	u32 npa_aura_id;
+	u64 reg;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_SSO, pcifunc);
+	if (blkaddr < 0)
+		return SSO_AF_ERR_LF_INVALID;
+
+	npa_aura_id = req->npa_aura_id;
+
+	/* Check if requested 'SSOLF <=> NPALF' mapping is valid */
+	if (req->npa_pf_func) {
+		/* If default, use 'this' SSOLF's PFFUNC */
+		if (req->npa_pf_func == RVU_DEFAULT_PF_FUNC)
+			req->npa_pf_func = pcifunc;
+		if (!is_pffunc_map_valid(rvu, req->npa_pf_func, BLKTYPE_NPA))
+			return SSO_AF_INVAL_NPA_PF_FUNC;
+	}
+
+	/* Initialize XAQ ring */
+	for (hwgrp = 0; hwgrp < req->hwgrps; hwgrp++) {
+		lf = rvu_get_lf(rvu, &hw->block[blkaddr], pcifunc, hwgrp);
+		if (lf < 0)
+			return SSO_AF_ERR_LF_INVALID;
+
+		reg = rvu_read64(rvu, blkaddr, SSO_AF_HWGRPX_AW_STATUS(lf));
+		if (reg & SSO_HWGRP_AW_STS_XAQ_BUFSC_MASK || reg & BIT_ULL(3)) {
+			reg = rvu_read64(rvu, blkaddr,
+					 SSO_AF_HWGRPX_AW_CFG(lf));
+			reg = (reg & ~SSO_HWGRP_AW_CFG_RWEN) |
+			       SSO_HWGRP_AW_CFG_XAQ_BYP_DIS;
+			rvu_write64(rvu, blkaddr, SSO_AF_HWGRPX_AW_CFG(lf),
+				    reg);
+
+			reg = rvu_read64(rvu, blkaddr,
+					 SSO_AF_HWGRPX_AW_STATUS(lf));
+			if (reg & SSO_HWGRP_AW_STS_TPTR_VLD) {
+				rvu_poll_reg(rvu, blkaddr,
+					     SSO_AF_HWGRPX_AW_STATUS(lf),
+					     SSO_HWGRP_AW_STS_NPA_FETCH, true);
+
+				rvu_write64(rvu, blkaddr,
+					    SSO_AF_HWGRPX_AW_STATUS(lf),
+					    SSO_HWGRP_AW_STS_TPTR_VLD);
+			}
+
+			if (rvu_poll_reg(rvu, blkaddr,
+					 SSO_AF_HWGRPX_AW_STATUS(lf),
+					 SSO_HWGRP_AW_STS_XAQ_BUFSC_MASK, true))
+				dev_warn(rvu->dev,
+					 "SSO_HWGRP(%d)_AW_STATUS[XAQ_BUF_CACHED] not cleared",
+					 lf);
+		}
+
+		rvu_write64(rvu, blkaddr, SSO_AF_HWGRPX_XAQ_AURA(lf),
+			    npa_aura_id);
+		rvu_write64(rvu, blkaddr, SSO_AF_XAQX_GMCTL(lf),
+			    req->npa_pf_func);
+
+		/* enable XAQ */
+		rvu_write64(rvu, blkaddr, SSO_AF_HWGRPX_AW_CFG(lf), 0xF);
+
+		/* Wait for ggrp to ack. */
+		err = rvu_poll_reg(rvu, blkaddr,
+				   SSO_AF_HWGRPX_AW_STATUS(lf),
+				   SSO_HWGRP_AW_STS_INIT_STS, false);
+
+		reg = rvu_read64(rvu, blkaddr, SSO_AF_HWGRPX_AW_STATUS(lf));
+		if (err || (reg & BIT_ULL(4)) || !(reg & BIT_ULL(8))) {
+			dev_warn(rvu->dev, "SSO_HWGRP(%d) XAQ NPA pointer initialization failed",
+				 lf);
+			return -ENOMEM;
+		}
+	}
+
+	return 0;
+}
+
+int rvu_mbox_handler_sso_grp_set_priority(struct rvu *rvu,
+					  struct sso_grp_priority *req,
+					  struct msg_rsp *rsp)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	u16 pcifunc = req->hdr.pcifunc;
+	int lf, blkaddr;
+	u64 regval;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_SSO, pcifunc);
+	if (blkaddr < 0)
+		return SSO_AF_ERR_LF_INVALID;
+
+	regval = (((u64)(req->weight & SSO_HWGRP_PRI_WGT_MASK)
+		  << SSO_HWGRP_PRI_WGT_SHIFT) |
+		  ((u64)(req->affinity & SSO_HWGRP_PRI_AFF_MASK)
+		   << SSO_HWGRP_PRI_AFF_SHIFT) |
+		  (req->priority & SSO_HWGRP_PRI_MASK));
+
+	lf = rvu_get_lf(rvu, &hw->block[blkaddr], pcifunc, req->grp);
+	if (lf < 0)
+		return SSO_AF_ERR_LF_INVALID;
+
+	rvu_write64(rvu, blkaddr, SSO_AF_HWGRPX_PRI(lf), regval);
+
+	return 0;
+}
+
+int rvu_mbox_handler_sso_grp_get_priority(struct rvu *rvu,
+					  struct sso_info_req *req,
+					  struct sso_grp_priority *rsp)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	u16 pcifunc = req->hdr.pcifunc;
+	int lf, blkaddr;
+	u64 regval;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_SSO, pcifunc);
+	if (blkaddr < 0)
+		return SSO_AF_ERR_LF_INVALID;
+
+	lf = rvu_get_lf(rvu, &hw->block[blkaddr], pcifunc, req->grp);
+	if (lf < 0)
+		return SSO_AF_ERR_LF_INVALID;
+
+	regval = rvu_read64(rvu, blkaddr, SSO_AF_HWGRPX_PRI(lf));
+
+	rsp->weight = (regval >> SSO_HWGRP_PRI_WGT_SHIFT)
+			& SSO_HWGRP_PRI_WGT_MASK;
+	rsp->affinity = (regval >> SSO_HWGRP_PRI_AFF_SHIFT)
+			& SSO_HWGRP_PRI_AFF_MASK;
+	rsp->priority = regval & SSO_HWGRP_PRI_MASK;
+
+	return 0;
+}
+
+int rvu_mbox_handler_sso_lf_alloc(struct rvu *rvu, struct sso_lf_alloc_req *req,
+				  struct sso_lf_alloc_rsp *rsp)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	u16 pcifunc = req->hdr.pcifunc;
+	int ssolf, uniq_ident, rc = 0;
+	struct rvu_pfvf *pfvf;
+	int hwgrp, blkaddr;
+
+	pfvf = rvu_get_pfvf(rvu, pcifunc);
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_SSO, pcifunc);
+	if (pfvf->sso <= 0 || blkaddr < 0)
+		return SSO_AF_ERR_LF_INVALID;
+
+	if (!pfvf->sso_uniq_ident) {
+		uniq_ident = rvu_alloc_rsrc(&hw->sso.pfvf_ident);
+		if (uniq_ident < 0) {
+			rc = SSO_AF_ERR_AF_LF_ALLOC;
+			goto exit;
+		}
+		pfvf->sso_uniq_ident = uniq_ident;
+	} else {
+		uniq_ident = pfvf->sso_uniq_ident;
+	}
+
+	/* Set threshold for the In-Unit Accounting Index*/
+	rvu_write64(rvu, blkaddr, SSO_AF_IU_ACCNTX_CFG(uniq_ident),
+		    SSO_AF_HWGRP_IU_ACCNT_MAX_THR << 16);
+
+	for (hwgrp = 0; hwgrp < req->hwgrps; hwgrp++) {
+		ssolf = rvu_get_lf(rvu, &hw->block[blkaddr], pcifunc, hwgrp);
+		if (ssolf < 0)
+			return SSO_AF_ERR_LF_INVALID;
+
+		/* All groups assigned to single SR-IOV function must be
+		 * assigned same unique in-unit accounting index.
+		 */
+		rvu_write64(rvu, blkaddr, SSO_AF_HWGRPX_IU_ACCNT(ssolf),
+			    0x10000 | uniq_ident);
+
+		/* Assign unique tagspace */
+		rvu_write64(rvu, blkaddr, SSO_AF_HWGRPX_AW_TAGSPACE(ssolf),
+			    uniq_ident);
+	}
+
+exit:
+	rsp->xaq_buf_size = hw->sso.sso_xaq_buf_size;
+	rsp->xaq_wq_entries = hw->sso.sso_xaq_num_works;
+	rsp->in_unit_entries = hw->sso.sso_iue;
+	rsp->hwgrps = hw->sso.sso_hwgrps;
+	return rc;
+}
+
+int rvu_mbox_handler_sso_lf_free(struct rvu *rvu, struct sso_lf_free_req *req,
+				 struct msg_rsp *rsp)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	u16 pcifunc = req->hdr.pcifunc;
+	int hwgrp, lf, err, blkaddr;
+	struct rvu_pfvf *pfvf;
+
+	pfvf = rvu_get_pfvf(rvu, pcifunc);
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_SSO, pcifunc);
+	if (blkaddr < 0)
+		return SSO_AF_ERR_LF_INVALID;
+
+	/* Perform reset of SSO HW GRPs */
+	for (hwgrp = 0; hwgrp < req->hwgrps; hwgrp++) {
+		lf = rvu_get_lf(rvu, &hw->block[blkaddr], pcifunc, hwgrp);
+		if (lf < 0)
+			return SSO_AF_ERR_LF_INVALID;
+
+		err = rvu_sso_lf_teardown(rvu, pcifunc, lf, hwgrp);
+		if (err)
+			return err;
+
+		/* Reset this SSO LF */
+		err = rvu_lf_reset(rvu, &hw->block[blkaddr], lf);
+		if (err)
+			dev_err(rvu->dev, "SSO%d free: failed to reset\n", lf);
+		/* Reset the IAQ and TAQ thresholds */
+		rvu_sso_hwgrp_config_thresh(rvu, blkaddr, lf);
+	}
+
+	if (pfvf->sso_uniq_ident) {
+		rvu_free_rsrc(&hw->sso.pfvf_ident, pfvf->sso_uniq_ident);
+		pfvf->sso_uniq_ident = 0;
+	}
+
+	return 0;
+}
+
+int rvu_mbox_handler_sso_ws_cache_inv(struct rvu *rvu, struct msg_req *req,
+				      struct msg_rsp *rsp)
+{
+	int num_lfs, ssowlf, hws, blkaddr;
+	struct rvu_hwinfo *hw = rvu->hw;
+	u16 pcifunc = req->hdr.pcifunc;
+	struct rvu_block *block;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_SSOW, pcifunc);
+	if (blkaddr < 0)
+		return SSOW_AF_ERR_LF_INVALID;
+
+	block = &hw->block[blkaddr];
+
+	num_lfs = rvu_get_rsrc_mapcount(rvu_get_pfvf(rvu, pcifunc),
+					block->type);
+	if (!num_lfs)
+		return SSOW_AF_ERR_LF_INVALID;
+
+	/* SSO HWS invalidate registers are part of SSO AF */
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_SSO, pcifunc);
+	if (blkaddr < 0)
+		return SSO_AF_ERR_LF_INVALID;
+
+	for (hws = 0; hws < num_lfs; hws++) {
+		ssowlf = rvu_get_lf(rvu, block, pcifunc, hws);
+		if (ssowlf < 0)
+			return SSOW_AF_ERR_LF_INVALID;
+
+		/* Reset this SSO LF GWS cache */
+		rvu_write64(rvu, blkaddr, SSO_AF_HWSX_INV(ssowlf), 1);
+	}
+
+	return 0;
+}
+
+int rvu_mbox_handler_ssow_lf_alloc(struct rvu *rvu,
+				   struct ssow_lf_alloc_req *req,
+				   struct msg_rsp *rsp)
+{
+	u16 pcifunc = req->hdr.pcifunc;
+	struct rvu_pfvf *pfvf;
+
+	pfvf = rvu_get_pfvf(rvu, pcifunc);
+	if (pfvf->ssow <= 0)
+		return SSOW_AF_ERR_LF_INVALID;
+
+	return 0;
+}
+
+int rvu_mbox_handler_ssow_lf_free(struct rvu *rvu,
+				  struct ssow_lf_free_req *req,
+				  struct msg_rsp *rsp)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	u16 pcifunc = req->hdr.pcifunc;
+	int ssowlf, hws, err, blkaddr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_SSOW, pcifunc);
+	if (blkaddr < 0)
+		return SSOW_AF_ERR_LF_INVALID;
+
+	for (hws = 0; hws < req->hws; hws++) {
+		ssowlf = rvu_get_lf(rvu, &hw->block[blkaddr], pcifunc, hws);
+		if (ssowlf < 0)
+			return SSOW_AF_ERR_LF_INVALID;
+
+		err = rvu_ssow_lf_teardown(rvu, pcifunc, ssowlf, hws);
+		if (err)
+			return err;
+
+		/* Reset this SSO LF */
+		err = rvu_lf_reset(rvu, &hw->block[blkaddr], ssowlf);
+		if (err)
+			dev_err(rvu->dev, "SSOW%d free: failed to reset\n",
+				ssowlf);
+	}
+
+	return 0;
+}
+
+int rvu_sso_init(struct rvu *rvu)
+{
+	u64 iaq_free_cnt, iaq_rsvd, iaq_max, iaq_rsvd_cnt = 0;
+	u64 taq_free_cnt, taq_rsvd, taq_max, taq_rsvd_cnt = 0;
+	struct sso_rsrc *sso = &rvu->hw->sso;
+	int blkaddr, hwgrp, grpmsk, hws, err;
+	u64 reg;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_SSO, 0);
+	if (blkaddr < 0)
+		return 0;
+
+	reg = rvu_read64(rvu, blkaddr, SSO_AF_CONST);
+	/* number of SSO hardware work slots */
+	sso->sso_hws = (reg >> 56) & 0xFF;
+	/* number of SSO hardware groups */
+	sso->sso_hwgrps = (reg & 0xFFFF);
+	/* number of SSO In-Unit entries */
+	sso->sso_iue =  (reg >> 16) & 0xFFFF;
+
+	reg = rvu_read64(rvu, blkaddr, SSO_AF_CONST1);
+	/* number of work entries in external admission queue (XAQ) */
+	sso->sso_xaq_num_works = (reg >> 16) & 0xFFFF;
+	/* number of bytes in a XAQ buffer */
+	sso->sso_xaq_buf_size = (reg & 0xFFFF);
+
+	/* Configure IAQ entries */
+	reg = rvu_read64(rvu, blkaddr, SSO_AF_AW_WE);
+	iaq_free_cnt = reg & SSO_AF_IAQ_FREE_CNT_MASK;
+
+	/* Give out half of buffers fairly, rest left floating */
+	iaq_rsvd = iaq_free_cnt / sso->sso_hwgrps / 2;
+
+	/* Enforce minimum per hardware requirements */
+	if (iaq_rsvd < SSO_HWGRP_IAQ_RSVD_THR)
+		iaq_rsvd = SSO_HWGRP_IAQ_RSVD_THR;
+	/* To ensure full streaming performance should be at least 208. */
+	iaq_max = iaq_rsvd + SSO_HWGRP_IAQ_MAX_THR_STRM_PERF;
+
+	if (iaq_max >= (SSO_AF_IAQ_FREE_CNT_MAX + 1))
+		iaq_max = SSO_AF_IAQ_FREE_CNT_MAX;
+
+	/* Configure TAQ entries */
+	reg = rvu_read64(rvu, blkaddr, SSO_AF_TAQ_CNT);
+	taq_free_cnt = reg & SSO_AF_TAQ_FREE_CNT_MASK;
+
+	/* Give out half of buffers fairly, rest left floating */
+	taq_rsvd = taq_free_cnt / sso->sso_hwgrps / 2;
+
+	/* Enforce minimum per hardware requirements */
+	if (taq_rsvd < SSO_HWGRP_TAQ_RSVD_THR)
+		taq_rsvd = SSO_HWGRP_TAQ_RSVD_THR;
+	/* To ensure full streaming performance should be at least 16. */
+	taq_max = taq_rsvd + SSO_HWGRP_TAQ_MAX_THR_STRM_PERF;
+
+	if (taq_max >= (SSO_AF_TAQ_FREE_CNT_MAX + 1))
+		taq_max = SSO_AF_TAQ_FREE_CNT_MAX;
+
+	/* Save thresholds to reprogram HWGRPs on reset */
+	sso->iaq_rsvd = iaq_rsvd;
+	sso->iaq_max = iaq_max;
+	sso->taq_rsvd = taq_rsvd;
+	sso->taq_max = taq_max;
+
+	for (hwgrp = 0; hwgrp < sso->sso_hwgrps; hwgrp++) {
+		rvu_sso_hwgrp_config_thresh(rvu, blkaddr, hwgrp);
+		iaq_rsvd_cnt += iaq_rsvd;
+		taq_rsvd_cnt += taq_rsvd;
+	}
+
+	/* Verify SSO_AW_WE[RSVD_FREE], TAQ_CNT[RSVD_FREE] are greater than
+	 * or equal to sum of IAQ[RSVD_THR], TAQ[RSRVD_THR] fields.
+	 */
+	reg = rvu_read64(rvu, blkaddr, SSO_AF_AW_WE);
+	reg = (reg >> SSO_AF_IAQ_RSVD_FREE_SHIFT) & SSO_AF_IAQ_RSVD_FREE_MASK;
+	if (reg < iaq_rsvd_cnt) {
+		dev_warn(rvu->dev, "WARN: Wrong IAQ resource calculations %llx vs %llx\n",
+			 reg, iaq_rsvd_cnt);
+		rvu_write64(rvu, blkaddr, SSO_AF_AW_WE,
+			    (iaq_rsvd_cnt & SSO_AF_IAQ_RSVD_FREE_MASK) <<
+			    SSO_AF_IAQ_RSVD_FREE_SHIFT);
+	}
+
+	reg = rvu_read64(rvu, blkaddr, SSO_AF_TAQ_CNT);
+	reg = (reg >> SSO_AF_TAQ_RSVD_FREE_SHIFT) & SSO_AF_TAQ_RSVD_FREE_MASK;
+	if (reg < taq_rsvd_cnt) {
+		dev_warn(rvu->dev, "WARN: Wrong TAQ resource calculations %llx vs %llx\n",
+			 reg, taq_rsvd_cnt);
+		rvu_write64(rvu, blkaddr, SSO_AF_TAQ_CNT,
+			    (taq_rsvd_cnt & SSO_AF_TAQ_RSVD_FREE_MASK) <<
+			    SSO_AF_TAQ_RSVD_FREE_SHIFT);
+	}
+
+	/* Unset the HWS Hardware Group Mask.
+	 * The hardware group mask should be set by PF/VF
+	 * using SSOW_LF_GWS_GRPMSK_CHG based on the LF allocations.
+	 */
+	for (grpmsk = 0; grpmsk < (sso->sso_hwgrps / 64); grpmsk++) {
+		for (hws = 0; hws < sso->sso_hws; hws++) {
+			rvu_write64(rvu, blkaddr,
+				    SSO_AF_HWSX_SX_GRPMSKX(hws, 0, grpmsk),
+				    0x0);
+			rvu_write64(rvu, blkaddr,
+				    SSO_AF_HWSX_SX_GRPMSKX(hws, 1, grpmsk),
+				    0x0);
+		}
+	}
+
+	/* Allocate SSO_AF_CONST::HWS + 1. As the total number of pf/vf are
+	 * limited by the numeber of HWS available.
+	 */
+	sso->pfvf_ident.max = sso->sso_hws + 1;
+	err = rvu_alloc_bitmap(&sso->pfvf_ident);
+	if (err)
+		return err;
+
+	/* Reserve one bit so that identifier starts from 1 */
+	rvu_alloc_rsrc(&sso->pfvf_ident);
+
+	return 0;
+}
+
+void rvu_sso_freemem(struct rvu *rvu)
+{
+	struct sso_rsrc *sso = &rvu->hw->sso;
+
+	kfree(sso->pfvf_ident.bmap);
+}
-- 
2.7.4

