Return-Path: <netdev+bounces-9969-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8249372B7EA
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:06:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAC831C209B4
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 06:06:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB241881E;
	Mon, 12 Jun 2023 06:04:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01902567
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 06:04:58 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4F7E7D;
	Sun, 11 Jun 2023 23:04:57 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35BMrBPi028647;
	Sun, 11 Jun 2023 23:04:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=/XRTdAMx/z82fDMsnrRsvRLSwBhN53Ecvtz0zJ9xQBo=;
 b=TAVX5jAwELaouiJurjMzJMSbj+hEg19mLKJLgByOSsIAX2lhBXn22UfqiinI4KFqalQF
 k2e9e3fX1dLSsYXdmyXuulm68whkYb0CpGx/qqN4FPUOi51R13fy22sugE7oszsH0RbM
 CRCkUHn1u0XeUf/i6vfcbQBvo6qG7jBB0pk2uobAih7HfaUKeCAeZBCBJxAt9So+nced
 GY8qkPLMFO3ldURUEo7lUu0+BqfBVkmyU5PgVmjNuHp9asIpX6zr99uCOxDwJV5vwFP8
 TRVIxhzkt7nJ/PWyisY/7MXbBSaz2er3rcTvceIizFZW2MafFGiwrg1EdToKN9kC4Vt+ IQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3r4phnc9ub-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Sun, 11 Jun 2023 23:04:49 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sun, 11 Jun
 2023 23:04:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Sun, 11 Jun 2023 23:04:48 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
	by maili.marvell.com (Postfix) with ESMTP id C1AFC5B6943;
	Sun, 11 Jun 2023 23:04:45 -0700 (PDT)
From: Naveen Mamindlapalli <naveenm@marvell.com>
To: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>
CC: Naveen Mamindlapalli <naveenm@marvell.com>
Subject: [net-next PATCH v2 6/6] octeontx2-af: Set XOFF on other child transmit schedulers during SMQ flush
Date: Mon, 12 Jun 2023 11:34:24 +0530
Message-ID: <20230612060424.1427-7-naveenm@marvell.com>
X-Mailer: git-send-email 2.39.0.198.ga38d39a4c5
In-Reply-To: <20230612060424.1427-1-naveenm@marvell.com>
References: <20230612060424.1427-1-naveenm@marvell.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 9zogxPCCTiNkFWoiDpWsFL8gnIz_peuU
X-Proofpoint-ORIG-GUID: 9zogxPCCTiNkFWoiDpWsFL8gnIz_peuU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-12_03,2023-06-09_01,2023-05-22_02
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When multiple transmit scheduler queues feed a TL1 transmit link, the
SMQ flush initiated on a low priority queue might get stuck when a high
priority queue fully subscribes the transmit link. This inturn effects
interface teardown. To avoid this, temporarily XOFF all TL1's other
immediate child transmit scheduler queues and also clear any rate limit
configuration on all the scheduler queues in SMQ(flush) hierarchy.

Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  16 +++
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 130 +++++++++++++++++-
 2 files changed, 144 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index c07d826e36d1..b5a7ee63508c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -285,6 +285,22 @@ struct nix_mark_format {
 	u32 *cfg;
 };
 
+/* smq(flush) to tl1 cir/pir info */
+struct nix_smq_tree_ctx {
+	u64 cir_off;
+	u64 cir_val;
+	u64 pir_off;
+	u64 pir_val;
+};
+
+/* smq flush context */
+struct nix_smq_flush_ctx {
+	int smq;
+	u16 tl1_schq;
+	u16 tl2_schq;
+	struct nix_smq_tree_ctx smq_tree_ctx[NIX_TXSCH_LVL_CNT];
+};
+
 struct npc_pkind {
 	struct rsrc_bmap rsrc;
 	u32	*pfchan_map;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 23149036be77..601ef269aa29 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -2114,9 +2114,121 @@ int rvu_mbox_handler_nix_txsch_alloc(struct rvu *rvu,
 	return rc;
 }
 
+static void nix_smq_flush_fill_ctx(struct rvu *rvu, int blkaddr, int smq,
+				   struct nix_smq_flush_ctx *smq_flush_ctx)
+{
+	struct nix_smq_tree_ctx *smq_tree_ctx;
+	u64 parent_off, regval;
+	u16 schq;
+	int lvl;
+
+	smq_flush_ctx->smq = smq;
+
+	schq = smq;
+	for (lvl = NIX_TXSCH_LVL_SMQ; lvl <= NIX_TXSCH_LVL_TL1; lvl++) {
+		smq_tree_ctx = &smq_flush_ctx->smq_tree_ctx[lvl];
+		if (lvl == NIX_TXSCH_LVL_TL1) {
+			smq_flush_ctx->tl1_schq = schq;
+			smq_tree_ctx->cir_off = NIX_AF_TL1X_CIR(schq);
+			smq_tree_ctx->pir_off = 0;
+			smq_tree_ctx->pir_val = 0;
+			parent_off = 0;
+		} else if (lvl == NIX_TXSCH_LVL_TL2) {
+			smq_flush_ctx->tl2_schq = schq;
+			smq_tree_ctx->cir_off = NIX_AF_TL2X_CIR(schq);
+			smq_tree_ctx->pir_off = NIX_AF_TL2X_PIR(schq);
+			parent_off = NIX_AF_TL2X_PARENT(schq);
+		} else if (lvl == NIX_TXSCH_LVL_TL3) {
+			smq_tree_ctx->cir_off = NIX_AF_TL3X_CIR(schq);
+			smq_tree_ctx->pir_off = NIX_AF_TL3X_PIR(schq);
+			parent_off = NIX_AF_TL3X_PARENT(schq);
+		} else if (lvl == NIX_TXSCH_LVL_TL4) {
+			smq_tree_ctx->cir_off = NIX_AF_TL4X_CIR(schq);
+			smq_tree_ctx->pir_off = NIX_AF_TL4X_PIR(schq);
+			parent_off = NIX_AF_TL4X_PARENT(schq);
+		} else if (lvl == NIX_TXSCH_LVL_MDQ) {
+			smq_tree_ctx->cir_off = NIX_AF_MDQX_CIR(schq);
+			smq_tree_ctx->pir_off = NIX_AF_MDQX_PIR(schq);
+			parent_off = NIX_AF_MDQX_PARENT(schq);
+		}
+		/* save cir/pir register values */
+		smq_tree_ctx->cir_val = rvu_read64(rvu, blkaddr, smq_tree_ctx->cir_off);
+		if (smq_tree_ctx->pir_off)
+			smq_tree_ctx->pir_val = rvu_read64(rvu, blkaddr, smq_tree_ctx->pir_off);
+
+		/* get parent txsch node */
+		if (parent_off) {
+			regval = rvu_read64(rvu, blkaddr, parent_off);
+			schq = (regval >> 16) & 0x1FF;
+		}
+	}
+}
+
+static void nix_smq_flush_enadis_xoff(struct rvu *rvu, int blkaddr,
+				      struct nix_smq_flush_ctx *smq_flush_ctx, bool enable)
+{
+	struct nix_txsch *txsch;
+	struct nix_hw *nix_hw;
+	u64 regoff;
+	int tl2;
+
+	nix_hw = get_nix_hw(rvu->hw, blkaddr);
+	if (!nix_hw)
+		return;
+
+	/* loop through all TL2s with matching PF_FUNC */
+	txsch = &nix_hw->txsch[NIX_TXSCH_LVL_TL2];
+	for (tl2 = 0; tl2 < txsch->schq.max; tl2++) {
+		/* skip the smq(flush) TL2 */
+		if (tl2 == smq_flush_ctx->tl2_schq)
+			continue;
+		/* skip unused TL2s */
+		if (TXSCH_MAP_FLAGS(txsch->pfvf_map[tl2]) & NIX_TXSCHQ_FREE)
+			continue;
+		/* skip if PF_FUNC doesn't match */
+		if ((TXSCH_MAP_FUNC(txsch->pfvf_map[tl2]) & ~RVU_PFVF_FUNC_MASK) !=
+		    (TXSCH_MAP_FUNC(txsch->pfvf_map[smq_flush_ctx->tl2_schq] &
+				    ~RVU_PFVF_FUNC_MASK)))
+			continue;
+		/* enable/disable XOFF */
+		regoff = NIX_AF_TL2X_SW_XOFF(tl2);
+		if (enable)
+			rvu_write64(rvu, blkaddr, regoff, 0x1);
+		else
+			rvu_write64(rvu, blkaddr, regoff, 0x0);
+	}
+}
+
+static void nix_smq_flush_enadis_rate(struct rvu *rvu, int blkaddr,
+				      struct nix_smq_flush_ctx *smq_flush_ctx, bool enable)
+{
+	u64 cir_off, pir_off, cir_val, pir_val;
+	struct nix_smq_tree_ctx *smq_tree_ctx;
+	int lvl;
+
+	for (lvl = NIX_TXSCH_LVL_SMQ; lvl <= NIX_TXSCH_LVL_TL1; lvl++) {
+		smq_tree_ctx = &smq_flush_ctx->smq_tree_ctx[lvl];
+		cir_off = smq_tree_ctx->cir_off;
+		cir_val = smq_tree_ctx->cir_val;
+		pir_off = smq_tree_ctx->pir_off;
+		pir_val = smq_tree_ctx->pir_val;
+
+		if (enable) {
+			rvu_write64(rvu, blkaddr, cir_off, cir_val);
+			if (lvl != NIX_TXSCH_LVL_TL1)
+				rvu_write64(rvu, blkaddr, pir_off, pir_val);
+		} else {
+			rvu_write64(rvu, blkaddr, cir_off, 0x0);
+			if (lvl != NIX_TXSCH_LVL_TL1)
+				rvu_write64(rvu, blkaddr, pir_off, 0x0);
+		}
+	}
+}
+
 static int nix_smq_flush(struct rvu *rvu, int blkaddr,
 			 int smq, u16 pcifunc, int nixlf)
 {
+	struct nix_smq_flush_ctx *smq_flush_ctx;
 	int pf = rvu_get_pf(pcifunc);
 	u8 cgx_id = 0, lmac_id = 0;
 	int err, restore_tx_en = 0;
@@ -2136,6 +2248,14 @@ static int nix_smq_flush(struct rvu *rvu, int blkaddr,
 						   lmac_id, true);
 	}
 
+	/* XOFF all TL2s whose parent TL1 matches SMQ tree TL1 */
+	smq_flush_ctx = kzalloc(sizeof(*smq_flush_ctx), GFP_KERNEL);
+	if (!smq_flush_ctx)
+		return -ENOMEM;
+	nix_smq_flush_fill_ctx(rvu, blkaddr, smq, smq_flush_ctx);
+	nix_smq_flush_enadis_xoff(rvu, blkaddr, smq_flush_ctx, true);
+	nix_smq_flush_enadis_rate(rvu, blkaddr, smq_flush_ctx, false);
+
 	cfg = rvu_read64(rvu, blkaddr, NIX_AF_SMQX_CFG(smq));
 	/* Do SMQ flush and set enqueue xoff */
 	cfg |= BIT_ULL(50) | BIT_ULL(49);
@@ -2150,8 +2270,14 @@ static int nix_smq_flush(struct rvu *rvu, int blkaddr,
 	err = rvu_poll_reg(rvu, blkaddr,
 			   NIX_AF_SMQX_CFG(smq), BIT_ULL(49), true);
 	if (err)
-		dev_err(rvu->dev,
-			"NIXLF%d: SMQ%d flush failed\n", nixlf, smq);
+		dev_info(rvu->dev,
+			 "NIXLF%d: SMQ%d flush failed, txlink might be busy\n",
+			 nixlf, smq);
+
+	/* clear XOFF on TL2s */
+	nix_smq_flush_enadis_rate(rvu, blkaddr, smq_flush_ctx, true);
+	nix_smq_flush_enadis_xoff(rvu, blkaddr, smq_flush_ctx, false);
+	kfree(smq_flush_ctx);
 
 	rvu_cgx_enadis_rx_bp(rvu, pf, true);
 	/* restore cgx tx state */
-- 
2.39.0.198.ga38d39a4c5


