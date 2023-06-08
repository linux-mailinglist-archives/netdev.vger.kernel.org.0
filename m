Return-Path: <netdev+bounces-9191-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 00337727D3D
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 12:52:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5AFEC2816FA
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 10:52:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84E1FC8FC;
	Thu,  8 Jun 2023 10:50:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F9811187
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 10:50:48 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4816E2D41;
	Thu,  8 Jun 2023 03:50:42 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35838QYa023519;
	Thu, 8 Jun 2023 03:50:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=4cyWdPq2awzrKVLCMzcQ/M2cjI+AAxSFQEvtCVM6Dcs=;
 b=hYc2uF4ZdZTgPl2LZb6QLgXuuBO4Av2jrUTN6WvX6LzYM5j2uEw7Mzql1iXSrECn70fD
 WquqpCSuOw/pkCYI1I/FsmRQ/7HnhK6AqS/Xk7j7ZHmWaK4ywlONSLXjkonmldk0mX36
 s6hCytiCbc0fdMOJkyvDdILkii1ZPjg/rr9a5CvAptI6yjBJkCTffhGrthLvJ6OYczEN
 K5lDhMcW50HUjVf7v/plk3Djour8YxvYy8oLBdK0uXh3OTphrEbImPFPw/ycLwY0nDQg
 F9eDqob/0CVSda4WCkEvO91v0zMVWlDvlxI0fAkjgVUSHTPgVn5MZI1fcYSnNRerb0by GA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3r30eu27dp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Thu, 08 Jun 2023 03:50:33 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 8 Jun
 2023 03:50:31 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 8 Jun 2023 03:50:31 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
	by maili.marvell.com (Postfix) with ESMTP id 01CD33F707C;
	Thu,  8 Jun 2023 03:50:28 -0700 (PDT)
From: Naveen Mamindlapalli <naveenm@marvell.com>
To: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>
CC: Naveen Mamindlapalli <naveenm@marvell.com>
Subject: [net-next PATCH 6/6] octeontx2-af: Set XOFF on other child transmit schedulers during SMQ flush
Date: Thu, 8 Jun 2023 16:20:07 +0530
Message-ID: <20230608105007.26924-7-naveenm@marvell.com>
X-Mailer: git-send-email 2.39.0.198.ga38d39a4c5
In-Reply-To: <20230608105007.26924-1-naveenm@marvell.com>
References: <20230608105007.26924-1-naveenm@marvell.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: FxoRhPXoPdjRf6ap7frjR4m4FBxdzeVJ
X-Proofpoint-GUID: FxoRhPXoPdjRf6ap7frjR4m4FBxdzeVJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-08_07,2023-06-08_01,2023-05-22_02
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
index 78c796fb2bb4..8a825b983320 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -283,6 +283,22 @@ struct nix_mark_format {
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
index 18a146e9c4ef..eb5c11d06d7f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -2062,9 +2062,121 @@ int rvu_mbox_handler_nix_txsch_alloc(struct rvu *rvu,
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
@@ -2077,6 +2189,14 @@ static int nix_smq_flush(struct rvu *rvu, int blkaddr,
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
@@ -2091,8 +2211,14 @@ static int nix_smq_flush(struct rvu *rvu, int blkaddr,
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


