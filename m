Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29335679A00
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 14:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234421AbjAXNnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 08:43:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234330AbjAXNnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 08:43:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002D3A5DC;
        Tue, 24 Jan 2023 05:42:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87081611E6;
        Tue, 24 Jan 2023 13:42:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75798C4339E;
        Tue, 24 Jan 2023 13:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567764;
        bh=KkluuNP23Y3g1OrC46yFW4Q5w72RBwGZbAsIMzbUBmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r7rtzQtGkK7fiVlziak5eW/06jTTIBZyewRcnpDbAwcFfy8vSGlw+iSiwEAKXOfe5
         GRNrN9T0UJnARuKegaAticsVBOgZ1e0qUfUR1v+RgoA9SIzs+Y+sdtDoxPxKlRVZcx
         d02OHD8r1L1vTm2rXZaSK28+F0f55/54cXKxKGk32qRqEL/v6owNUtFDafHm/eC+dI
         YSlL6rQUVXuNQ9vNjWIhD2nT4tACp6/c7O9j2IuMxEYF7/Ayw72GdL9ALHJoiMvcRo
         USK1xU4NTUPMXhTP3sT3HctCOIHvieWCTXUIWAO3cs+E6ITFISYaNI/6BrLUX+1b43
         2zOK2dnLvfFSQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srujana Challa <schalla@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        hkelam@marvell.com, sbhatta@marvell.com, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 29/35] octeontx2-af: modify FLR sequence for CPT
Date:   Tue, 24 Jan 2023 08:41:25 -0500
Message-Id: <20230124134131.637036-29-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124134131.637036-1-sashal@kernel.org>
References: <20230124134131.637036-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Srujana Challa <schalla@marvell.com>

[ Upstream commit 1286c50ae9e0f5025b165c8f2321b3ce3b558002 ]

On OcteonTX2 platform CPT instruction enqueue is only
possible via LMTST operations.
The existing FLR sequence mentioned in HRM requires
a dummy LMTST to CPT but LMTST can't be submitted from
AF driver. So, HW team provided a new sequence to avoid
dummy LMTST. This patch adds code for the same.

Signed-off-by: Srujana Challa <schalla@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/af/rvu.h   | 12 +++
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 86 +++++++++----------
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |  2 +
 3 files changed, 53 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 76474385a602..a981463939ac 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -453,6 +453,7 @@ struct rvu {
 	struct rvu_pfvf		*pf;
 	struct rvu_pfvf		*hwvf;
 	struct mutex		rsrc_lock; /* Serialize resource alloc/free */
+	struct mutex		alias_lock; /* Serialize bar2 alias access */
 	int			vfs; /* Number of VFs attached to RVU */
 	int			nix_blkaddr[MAX_NIX_BLKS];
 
@@ -540,6 +541,17 @@ static inline u64 rvupf_read64(struct rvu *rvu, u64 offset)
 	return readq(rvu->pfreg_base + offset);
 }
 
+static inline void rvu_bar2_sel_write64(struct rvu *rvu, u64 block, u64 offset, u64 val)
+{
+	/* HW requires read back of RVU_AF_BAR2_SEL register to make sure completion of
+	 * write operation.
+	 */
+	rvu_write64(rvu, block, offset, val);
+	rvu_read64(rvu, block, offset);
+	/* Barrier to ensure read completes before accessing LF registers */
+	mb();
+}
+
 /* Silicon revisions */
 static inline bool is_rvu_pre_96xx_C0(struct rvu *rvu)
 {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index 1cd34914cb86..e8973294c4f8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -930,68 +930,63 @@ static void cpt_rxc_teardown(struct rvu *rvu, int blkaddr)
 		dev_warn(rvu->dev, "Poll for RXC zombie count hits hard loop counter\n");
 }
 
-#define INPROG_INFLIGHT(reg)    ((reg) & 0x1FF)
-#define INPROG_GRB_PARTIAL(reg) ((reg) & BIT_ULL(31))
-#define INPROG_GRB(reg)         (((reg) >> 32) & 0xFF)
-#define INPROG_GWB(reg)         (((reg) >> 40) & 0xFF)
+#define INFLIGHT   GENMASK_ULL(8, 0)
+#define GRB_CNT    GENMASK_ULL(39, 32)
+#define GWB_CNT    GENMASK_ULL(47, 40)
+#define XQ_XOR     GENMASK_ULL(63, 63)
+#define DQPTR      GENMASK_ULL(19, 0)
+#define NQPTR      GENMASK_ULL(51, 32)
 
 static void cpt_lf_disable_iqueue(struct rvu *rvu, int blkaddr, int slot)
 {
-	int i = 0, hard_lp_ctr = 100000;
-	u64 inprog, grp_ptr;
-	u16 nq_ptr, dq_ptr;
+	int timeout = 1000000;
+	u64 inprog, inst_ptr;
+	u64 qsize, pending;
+	int i = 0;
 
 	/* Disable instructions enqueuing */
 	rvu_write64(rvu, blkaddr, CPT_AF_BAR2_ALIASX(slot, CPT_LF_CTL), 0x0);
 
-	/* Disable executions in the LF's queue */
 	inprog = rvu_read64(rvu, blkaddr,
 			    CPT_AF_BAR2_ALIASX(slot, CPT_LF_INPROG));
-	inprog &= ~BIT_ULL(16);
+	inprog |= BIT_ULL(16);
 	rvu_write64(rvu, blkaddr,
 		    CPT_AF_BAR2_ALIASX(slot, CPT_LF_INPROG), inprog);
 
-	/* Wait for CPT queue to become execution-quiescent */
+	qsize = rvu_read64(rvu, blkaddr,
+			   CPT_AF_BAR2_ALIASX(slot, CPT_LF_Q_SIZE)) & 0x7FFF;
 	do {
-		inprog = rvu_read64(rvu, blkaddr,
-				    CPT_AF_BAR2_ALIASX(slot, CPT_LF_INPROG));
-		if (INPROG_GRB_PARTIAL(inprog)) {
-			i = 0;
-			hard_lp_ctr--;
-		} else {
-			i++;
-		}
-
-		grp_ptr = rvu_read64(rvu, blkaddr,
-				     CPT_AF_BAR2_ALIASX(slot,
-							CPT_LF_Q_GRP_PTR));
-		nq_ptr = (grp_ptr >> 32) & 0x7FFF;
-		dq_ptr = grp_ptr & 0x7FFF;
-
-	} while (hard_lp_ctr && (i < 10) && (nq_ptr != dq_ptr));
+		inst_ptr = rvu_read64(rvu, blkaddr,
+				      CPT_AF_BAR2_ALIASX(slot, CPT_LF_Q_INST_PTR));
+		pending = (FIELD_GET(XQ_XOR, inst_ptr) * qsize * 40) +
+			  FIELD_GET(NQPTR, inst_ptr) -
+			  FIELD_GET(DQPTR, inst_ptr);
+		udelay(1);
+		timeout--;
+	} while ((pending != 0) && (timeout != 0));
 
-	if (hard_lp_ctr == 0)
-		dev_warn(rvu->dev, "CPT FLR hits hard loop counter\n");
+	if (timeout == 0)
+		dev_warn(rvu->dev, "TIMEOUT: CPT poll on pending instructions\n");
 
-	i = 0;
-	hard_lp_ctr = 100000;
+	timeout = 1000000;
+	/* Wait for CPT queue to become execution-quiescent */
 	do {
 		inprog = rvu_read64(rvu, blkaddr,
 				    CPT_AF_BAR2_ALIASX(slot, CPT_LF_INPROG));
 
-		if ((INPROG_INFLIGHT(inprog) == 0) &&
-		    (INPROG_GWB(inprog) < 40) &&
-		    ((INPROG_GRB(inprog) == 0) ||
-		     (INPROG_GRB((inprog)) == 40))) {
+		if ((FIELD_GET(INFLIGHT, inprog) == 0) &&
+		    (FIELD_GET(GRB_CNT, inprog) == 0)) {
 			i++;
 		} else {
 			i = 0;
-			hard_lp_ctr--;
+			timeout--;
 		}
-	} while (hard_lp_ctr && (i < 10));
+	} while ((timeout != 0) && (i < 10));
 
-	if (hard_lp_ctr == 0)
-		dev_warn(rvu->dev, "CPT FLR hits hard loop counter\n");
+	if (timeout == 0)
+		dev_warn(rvu->dev, "TIMEOUT: CPT poll on inflight count\n");
+	/* Wait for 2 us to flush all queue writes to memory */
+	udelay(2);
 }
 
 int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int lf, int slot)
@@ -1001,18 +996,15 @@ int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int lf, int s
 	if (is_cpt_pf(rvu, pcifunc) || is_cpt_vf(rvu, pcifunc))
 		cpt_rxc_teardown(rvu, blkaddr);
 
+	mutex_lock(&rvu->alias_lock);
 	/* Enable BAR2 ALIAS for this pcifunc. */
 	reg = BIT_ULL(16) | pcifunc;
-	rvu_write64(rvu, blkaddr, CPT_AF_BAR2_SEL, reg);
+	rvu_bar2_sel_write64(rvu, blkaddr, CPT_AF_BAR2_SEL, reg);
 
 	cpt_lf_disable_iqueue(rvu, blkaddr, slot);
 
-	/* Set group drop to help clear out hardware */
-	reg = rvu_read64(rvu, blkaddr, CPT_AF_BAR2_ALIASX(slot, CPT_LF_INPROG));
-	reg |= BIT_ULL(17);
-	rvu_write64(rvu, blkaddr, CPT_AF_BAR2_ALIASX(slot, CPT_LF_INPROG), reg);
-
-	rvu_write64(rvu, blkaddr, CPT_AF_BAR2_SEL, 0);
+	rvu_bar2_sel_write64(rvu, blkaddr, CPT_AF_BAR2_SEL, 0);
+	mutex_unlock(&rvu->alias_lock);
 
 	return 0;
 }
@@ -1147,7 +1139,7 @@ int rvu_cpt_ctx_flush(struct rvu *rvu, u16 pcifunc)
 
 	/* Enable BAR2 ALIAS for this pcifunc. */
 	reg = BIT_ULL(16) | pcifunc;
-	rvu_write64(rvu, blkaddr, CPT_AF_BAR2_SEL, reg);
+	rvu_bar2_sel_write64(rvu, blkaddr, CPT_AF_BAR2_SEL, reg);
 
 	for (i = 0; i < max_ctx_entries; i++) {
 		cam_data = rvu_read64(rvu, blkaddr, CPT_AF_CTX_CAM_DATA(i));
@@ -1160,7 +1152,7 @@ int rvu_cpt_ctx_flush(struct rvu *rvu, u16 pcifunc)
 				    reg);
 		}
 	}
-	rvu_write64(rvu, blkaddr, CPT_AF_BAR2_SEL, 0);
+	rvu_bar2_sel_write64(rvu, blkaddr, CPT_AF_BAR2_SEL, 0);
 
 unlock:
 	mutex_unlock(&rvu->rsrc_lock);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index 0e0d536645ac..5437bd20c719 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -545,6 +545,8 @@
 
 #define CPT_LF_CTL                      0x10
 #define CPT_LF_INPROG                   0x40
+#define CPT_LF_Q_SIZE                   0x100
+#define CPT_LF_Q_INST_PTR               0x110
 #define CPT_LF_Q_GRP_PTR                0x120
 #define CPT_LF_CTX_FLUSH                0x510
 
-- 
2.39.0

