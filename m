Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5662530C3D9
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 16:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235586AbhBBPa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 10:30:57 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52939 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235325AbhBBP2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 10:28:49 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 112FPtY4001023;
        Tue, 2 Feb 2021 07:28:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=B21l1B4y0vIMCV0/DHevsU3CQs/AgX0wKYiZ/Y21VQ4=;
 b=hnaKBV6l2QdJR3KdmtOu2h9Q4+bzyr/z6fZbdhhXepOXmmsej+ukR4yah9FjVaYLFDLf
 EZhHbF8XEA4T6heBPq51viwNswYTSiJEVkvDLpsZiUG+SH05zXqFOGPPDF5pCQuUD8Ha
 uMhrm/wYNFcZmAFoo3hyrWgAiLyKmOvW9LbQQVmMp2N/FV/V/wPt+/wyCwmhTCGDh6Zs
 PslXeFaSHG2ACHJFkA5nsBDSm2FNsppLFSx/9oBGP1gzEbh9Uj8mys6R0oJ1vieOdqRE
 ICWmn6PtdNiHdupTj0+r6xHu6T43t6BVscjyik5fFa/ZwIt/9GT9omvlHSnNhzP9hmdS DQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36d7uq7hpx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 02 Feb 2021 07:28:05 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 2 Feb
 2021 07:28:03 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 2 Feb 2021 07:28:03 -0800
Received: from hyd1schalla-dt.caveonetworks.com.com (unknown [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id AA1563F703F;
        Tue,  2 Feb 2021 07:27:59 -0800 (PST)
From:   Srujana Challa <schalla@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>, <jerinj@marvell.com>,
        Srujana Challa <schalla@marvell.com>,
        Mahipal Challa <mchalla@marvell.com>
Subject: [PATCH v2,net-next,2/3] octeontx2-af: Add support for CPT1 in debugfs
Date:   Tue, 2 Feb 2021 20:57:08 +0530
Message-ID: <20210202152709.20450-3-schalla@marvell.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210202152709.20450-1-schalla@marvell.com>
References: <20210202152709.20450-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-02_07:2021-02-02,2021-02-02 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds support to display block CPT1 stats at
"/sys/kernel/debug/octeontx2/cpt1".

Signed-off-by: Mahipal Challa <mchalla@marvell.com>
Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  7 ++
 .../marvell/octeontx2/af/rvu_debugfs.c        | 86 +++++++++----------
 2 files changed, 49 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index b1a6ecfd563e..aabf6d5ee020 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -33,6 +33,7 @@
 
 #define NAME_SIZE				32
 #define MAX_NIX_BLKS				2
+#define MAX_CPT_BLKS				2
 
 /* PF_FUNC */
 #define RVU_PFVF_PF_SHIFT	10
@@ -47,6 +48,11 @@ struct dump_ctx {
 	bool	all;
 };
 
+struct cpt_ctx {
+	int blkaddr;
+	struct rvu *rvu;
+};
+
 struct rvu_debugfs {
 	struct dentry *root;
 	struct dentry *cgx_root;
@@ -61,6 +67,7 @@ struct rvu_debugfs {
 	struct dump_ctx nix_cq_ctx;
 	struct dump_ctx nix_rq_ctx;
 	struct dump_ctx nix_sq_ctx;
+	struct cpt_ctx cpt_ctx[MAX_CPT_BLKS];
 	int npa_qsize_id;
 	int nix_qsize_id;
 };
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index f60499562d2e..80e964330de3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -1904,20 +1904,16 @@ static void rvu_dbg_npc_init(struct rvu *rvu)
 			    &rvu_dbg_npc_rx_miss_act_fops);
 }
 
-/* CPT debugfs APIs */
 static int cpt_eng_sts_display(struct seq_file *filp, u8 eng_type)
 {
-	struct rvu *rvu = filp->private;
+	struct cpt_ctx *ctx = filp->private;
 	u64 busy_sts = 0, free_sts = 0;
 	u32 e_min = 0, e_max = 0, e, i;
 	u16 max_ses, max_ies, max_aes;
-	int blkaddr;
+	struct rvu *rvu = ctx->rvu;
+	int blkaddr = ctx->blkaddr;
 	u64 reg;
 
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
-	if (blkaddr < 0)
-		return -ENODEV;
-
 	reg = rvu_read64(rvu, blkaddr, CPT_AF_CONSTANTS1);
 	max_ses = reg & 0xffff;
 	max_ies = (reg >> 16) & 0xffff;
@@ -1977,16 +1973,13 @@ RVU_DEBUG_SEQ_FOPS(cpt_ie_sts, cpt_ie_sts_display, NULL);
 
 static int rvu_dbg_cpt_engines_info_display(struct seq_file *filp, void *unused)
 {
-	struct rvu *rvu = filp->private;
+	struct cpt_ctx *ctx = filp->private;
 	u16 max_ses, max_ies, max_aes;
+	struct rvu *rvu = ctx->rvu;
+	int blkaddr = ctx->blkaddr;
 	u32 e_max, e;
-	int blkaddr;
 	u64 reg;
 
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
-	if (blkaddr < 0)
-		return -ENODEV;
-
 	reg = rvu_read64(rvu, blkaddr, CPT_AF_CONSTANTS1);
 	max_ses = reg & 0xffff;
 	max_ies = (reg >> 16) & 0xffff;
@@ -2014,17 +2007,15 @@ RVU_DEBUG_SEQ_FOPS(cpt_engines_info, cpt_engines_info_display, NULL);
 
 static int rvu_dbg_cpt_lfs_info_display(struct seq_file *filp, void *unused)
 {
-	struct rvu *rvu = filp->private;
-	struct rvu_hwinfo *hw = rvu->hw;
+	struct cpt_ctx *ctx = filp->private;
+	int blkaddr = ctx->blkaddr;
+	struct rvu *rvu = ctx->rvu;
 	struct rvu_block *block;
-	int blkaddr;
+	struct rvu_hwinfo *hw;
 	u64 reg;
 	u32 lf;
 
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
-	if (blkaddr < 0)
-		return -ENODEV;
-
+	hw = rvu->hw;
 	block = &hw->block[blkaddr];
 	if (!block->lf.bmap)
 		return -ENODEV;
@@ -2049,13 +2040,10 @@ RVU_DEBUG_SEQ_FOPS(cpt_lfs_info, cpt_lfs_info_display, NULL);
 
 static int rvu_dbg_cpt_err_info_display(struct seq_file *filp, void *unused)
 {
-	struct rvu *rvu = filp->private;
+	struct cpt_ctx *ctx = filp->private;
+	struct rvu *rvu = ctx->rvu;
+	int blkaddr = ctx->blkaddr;
 	u64 reg0, reg1;
-	int blkaddr;
-
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
-	if (blkaddr < 0)
-		return -ENODEV;
 
 	reg0 = rvu_read64(rvu, blkaddr, CPT_AF_FLTX_INT(0));
 	reg1 = rvu_read64(rvu, blkaddr, CPT_AF_FLTX_INT(1));
@@ -2079,15 +2067,11 @@ RVU_DEBUG_SEQ_FOPS(cpt_err_info, cpt_err_info_display, NULL);
 
 static int rvu_dbg_cpt_pc_display(struct seq_file *filp, void *unused)
 {
-	struct rvu *rvu;
-	int blkaddr;
+	struct cpt_ctx *ctx = filp->private;
+	struct rvu *rvu = ctx->rvu;
+	int blkaddr = ctx->blkaddr;
 	u64 reg;
 
-	rvu = filp->private;
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
-	if (blkaddr < 0)
-		return -ENODEV;
-
 	reg = rvu_read64(rvu, blkaddr, CPT_AF_INST_REQ_PC);
 	seq_printf(filp, "CPT instruction requests   %llu\n", reg);
 	reg = rvu_read64(rvu, blkaddr, CPT_AF_INST_LATENCY_PC);
@@ -2108,26 +2092,39 @@ static int rvu_dbg_cpt_pc_display(struct seq_file *filp, void *unused)
 
 RVU_DEBUG_SEQ_FOPS(cpt_pc, cpt_pc_display, NULL);
 
-static void rvu_dbg_cpt_init(struct rvu *rvu)
+static void rvu_dbg_cpt_init(struct rvu *rvu, int blkaddr)
 {
-	if (!is_block_implemented(rvu->hw, BLKADDR_CPT0))
+	struct cpt_ctx *ctx;
+
+	if (!is_block_implemented(rvu->hw, blkaddr))
 		return;
 
-	rvu->rvu_dbg.cpt = debugfs_create_dir("cpt", rvu->rvu_dbg.root);
+	if (blkaddr == BLKADDR_CPT0) {
+		rvu->rvu_dbg.cpt = debugfs_create_dir("cpt", rvu->rvu_dbg.root);
+		ctx = &rvu->rvu_dbg.cpt_ctx[0];
+		ctx->blkaddr = BLKADDR_CPT0;
+		ctx->rvu = rvu;
+	} else {
+		rvu->rvu_dbg.cpt = debugfs_create_dir("cpt1",
+						      rvu->rvu_dbg.root);
+		ctx = &rvu->rvu_dbg.cpt_ctx[1];
+		ctx->blkaddr = BLKADDR_CPT1;
+		ctx->rvu = rvu;
+	}
 
-	debugfs_create_file("cpt_pc", 0600, rvu->rvu_dbg.cpt, rvu,
+	debugfs_create_file("cpt_pc", 0600, rvu->rvu_dbg.cpt, ctx,
 			    &rvu_dbg_cpt_pc_fops);
-	debugfs_create_file("cpt_ae_sts", 0600, rvu->rvu_dbg.cpt, rvu,
+	debugfs_create_file("cpt_ae_sts", 0600, rvu->rvu_dbg.cpt, ctx,
 			    &rvu_dbg_cpt_ae_sts_fops);
-	debugfs_create_file("cpt_se_sts", 0600, rvu->rvu_dbg.cpt, rvu,
+	debugfs_create_file("cpt_se_sts", 0600, rvu->rvu_dbg.cpt, ctx,
 			    &rvu_dbg_cpt_se_sts_fops);
-	debugfs_create_file("cpt_ie_sts", 0600, rvu->rvu_dbg.cpt, rvu,
+	debugfs_create_file("cpt_ie_sts", 0600, rvu->rvu_dbg.cpt, ctx,
 			    &rvu_dbg_cpt_ie_sts_fops);
-	debugfs_create_file("cpt_engines_info", 0600, rvu->rvu_dbg.cpt, rvu,
+	debugfs_create_file("cpt_engines_info", 0600, rvu->rvu_dbg.cpt, ctx,
 			    &rvu_dbg_cpt_engines_info_fops);
-	debugfs_create_file("cpt_lfs_info", 0600, rvu->rvu_dbg.cpt, rvu,
+	debugfs_create_file("cpt_lfs_info", 0600, rvu->rvu_dbg.cpt, ctx,
 			    &rvu_dbg_cpt_lfs_info_fops);
-	debugfs_create_file("cpt_err_info", 0600, rvu->rvu_dbg.cpt, rvu,
+	debugfs_create_file("cpt_err_info", 0600, rvu->rvu_dbg.cpt, ctx,
 			    &rvu_dbg_cpt_err_info_fops);
 }
 
@@ -2146,7 +2143,8 @@ void rvu_dbg_init(struct rvu *rvu)
 	rvu_dbg_nix_init(rvu, BLKADDR_NIX1);
 	rvu_dbg_cgx_init(rvu);
 	rvu_dbg_npc_init(rvu);
-	rvu_dbg_cpt_init(rvu);
+	rvu_dbg_cpt_init(rvu, BLKADDR_CPT0);
+	rvu_dbg_cpt_init(rvu, BLKADDR_CPT1);
 }
 
 void rvu_dbg_exit(struct rvu *rvu)
-- 
2.29.0

