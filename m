Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72097671C54
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 13:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbjARMlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 07:41:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbjARMkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 07:40:14 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175236CCF4
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 04:04:19 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30I9uxts029997;
        Wed, 18 Jan 2023 04:04:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=7pcQ+aC1w2bUvYXU6/9R8I4UCvxqktKBaEL46xZ8OqM=;
 b=imS7/UPe6vGY7xxBI3lZqDWQ8hNjDnD+Bynltx8ISBl95758bPUjLMqpt1CVZn2laZbY
 TE8i6RATFhSMHfeekHNL6iE65A1SmVe9bccBLhdIsykXB/y4FoldVLCLDjP/yDip4fZj
 20LtXLMY+ugQn/lfj45osQiFtTK85JSN5gFc+X0azj1KRrktYf7GoDkHkbXrb21Ylz82
 5pKUWL0CA/DW6Mtpc+7+zUWAtQvEci/k2RPtqefXZofqCm7522CjxI2doACl1ISVbwzq
 UoynZgs0SZak/GvgOIq7RkY8gfE+EDzW9HlK95MSTsh/4qixh/iS8czT1dtO1k35ClxG yQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3n3vstgubr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 04:04:12 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 18 Jan
 2023 04:04:10 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Wed, 18 Jan 2023 04:04:10 -0800
Received: from localhost.localdomain (unknown [10.28.36.175])
        by maili.marvell.com (Postfix) with ESMTP id E8E405B6934;
        Wed, 18 Jan 2023 04:04:06 -0800 (PST)
From:   Srujana Challa <schalla@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jerinj@marvell.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <schalla@marvell.com>
Subject: [PATCH net-next v3 3/7] octeontx2-af: modify FLR sequence for CPT
Date:   Wed, 18 Jan 2023 17:33:50 +0530
Message-ID: <20230118120354.1017961-4-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230118120354.1017961-1-schalla@marvell.com>
References: <20230118120354.1017961-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: BLh9kejTB1HFEYIDLQF1UlnSN_iRCvQC
X-Proofpoint-GUID: BLh9kejTB1HFEYIDLQF1UlnSN_iRCvQC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_05,2023-01-18_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On OcteonTX2 platform CPT instruction enqueue is only
possible via LMTST operations.
The existing FLR sequence mentioned in HRM requires
a dummy LMTST to CPT but LMTST can't be submitted from
AF driver. So, HW team provided a new sequence to avoid
dummy LMTST. This patch adds code for the same.

Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/rvu.h   | 12 +++
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 86 +++++++++----------
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |  2 +
 3 files changed, 53 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 7f0a64731c67..20c75d7c962e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -459,6 +459,7 @@ struct rvu {
 	struct rvu_pfvf		*pf;
 	struct rvu_pfvf		*hwvf;
 	struct mutex		rsrc_lock; /* Serialize resource alloc/free */
+	struct mutex		alias_lock; /* Serialize bar2 alias access */
 	int			vfs; /* Number of VFs attached to RVU */
 	int			nix_blkaddr[MAX_NIX_BLKS];
 
@@ -546,6 +547,17 @@ static inline u64 rvupf_read64(struct rvu *rvu, u64 offset)
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
2.25.1

