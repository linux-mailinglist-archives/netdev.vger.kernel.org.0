Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07EB2F4E6A
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 16:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbhAMPVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 10:21:33 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:15530 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725949AbhAMPVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 10:21:32 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10DF4svp012864;
        Wed, 13 Jan 2021 07:20:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=mvWmtkWg7z7I9kZ+u7URtaVNTZ8bu+W78qp/ihHwIvI=;
 b=HyOAOYTHDivMIeAYDBgQ0oiz1OHZluAOr+d+knVYsFdkf3vK8UJISvIUzyZwd+zXwH2x
 yrX9iOUhTClDuSRyVeHFkmzyCToETzH84gsrbKyjh4yAyDB5c7DiRSiitqvPDqLxcBW8
 /SVZ9OeZfsTMZaqVHusvTRzSbggBXxLmY9fyzRYs4ZCzX7GLZIZ/63qzLGSsTSuyj9hc
 lbsWzq0FRTtdL8stNAzwc1RqmRIAQEtE7TL9Ki6dcsxwODkIJROFIqAiPPP2VCTJHF9b
 hqkEzeE17X2Q46RfDXfd7CilStvdJqKmSTEEn2sC0pdBf3mLNFT/IbAvRGCcfpvux/1V 1Q== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 35ycvpuu02-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 07:20:47 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 13 Jan
 2021 07:20:43 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 13 Jan 2021 07:20:43 -0800
Received: from hyd1schalla-dt.caveonetworks.com.com (unknown [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id 2BE403F7044;
        Wed, 13 Jan 2021 07:20:39 -0800 (PST)
From:   Srujana Challa <schalla@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>, <jerinj@marvell.com>,
        Srujana Challa <schalla@marvell.com>,
        Mahipal Challa <mchalla@marvell.com>
Subject: [PATCH net-next,2/3] octeontx2-af: Add support for CPT1 in debugfs
Date:   Wed, 13 Jan 2021 20:50:06 +0530
Message-ID: <20210113152007.30293-3-schalla@marvell.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210113152007.30293-1-schalla@marvell.com>
References: <20210113152007.30293-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_07:2021-01-13,2021-01-13 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds support to display block CPT1 stats at
"/sys/kernel/debug/octeontx2/cpt1".

Signed-off-by: Mahipal Challa <mchalla@marvell.com>
Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 .../marvell/octeontx2/af/rvu_debugfs.c        | 45 +++++++++++--------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index d27543c1a166..158876366dd3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -1904,6 +1904,18 @@ static void rvu_dbg_npc_init(struct rvu *rvu)
 }
 
 /* CPT debugfs APIs */
+static int cpt_get_blkaddr(struct seq_file *filp)
+{
+	struct dentry *current_dir;
+	int blkaddr;
+
+	current_dir = filp->file->f_path.dentry->d_parent;
+	blkaddr = (!strcmp(current_dir->d_name.name, "cpt1") ?
+			   BLKADDR_CPT1 : BLKADDR_CPT0);
+
+	return blkaddr;
+}
+
 static int cpt_eng_sts_display(struct seq_file *filp, u8 eng_type)
 {
 	struct rvu *rvu = filp->private;
@@ -1913,9 +1925,7 @@ static int cpt_eng_sts_display(struct seq_file *filp, u8 eng_type)
 	int blkaddr;
 	u64 reg;
 
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
-	if (blkaddr < 0)
-		return -ENODEV;
+	blkaddr = cpt_get_blkaddr(filp);
 
 	reg = rvu_read64(rvu, blkaddr, CPT_AF_CONSTANTS1);
 	max_ses = reg & 0xffff;
@@ -1982,9 +1992,7 @@ static int rvu_dbg_cpt_engines_info_display(struct seq_file *filp, void *unused)
 	int blkaddr;
 	u64 reg;
 
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
-	if (blkaddr < 0)
-		return -ENODEV;
+	blkaddr = cpt_get_blkaddr(filp);
 
 	reg = rvu_read64(rvu, blkaddr, CPT_AF_CONSTANTS1);
 	max_ses = reg & 0xffff;
@@ -2020,9 +2028,7 @@ static int rvu_dbg_cpt_lfs_info_display(struct seq_file *filp, void *unused)
 	u64 reg;
 	u32 lf;
 
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
-	if (blkaddr < 0)
-		return -ENODEV;
+	blkaddr = cpt_get_blkaddr(filp);
 
 	block = &hw->block[blkaddr];
 	if (!block->lf.bmap)
@@ -2052,9 +2058,7 @@ static int rvu_dbg_cpt_err_info_display(struct seq_file *filp, void *unused)
 	u64 reg0, reg1;
 	int blkaddr;
 
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
-	if (blkaddr < 0)
-		return -ENODEV;
+	blkaddr = cpt_get_blkaddr(filp);
 
 	reg0 = rvu_read64(rvu, blkaddr, CPT_AF_FLTX_INT(0));
 	reg1 = rvu_read64(rvu, blkaddr, CPT_AF_FLTX_INT(1));
@@ -2083,9 +2087,7 @@ static int rvu_dbg_cpt_pc_display(struct seq_file *filp, void *unused)
 	u64 reg;
 
 	rvu = filp->private;
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
-	if (blkaddr < 0)
-		return -ENODEV;
+	blkaddr = cpt_get_blkaddr(filp);
 
 	reg = rvu_read64(rvu, blkaddr, CPT_AF_INST_REQ_PC);
 	seq_printf(filp, "CPT instruction requests   %llu\n", reg);
@@ -2107,12 +2109,16 @@ static int rvu_dbg_cpt_pc_display(struct seq_file *filp, void *unused)
 
 RVU_DEBUG_SEQ_FOPS(cpt_pc, cpt_pc_display, NULL);
 
-static void rvu_dbg_cpt_init(struct rvu *rvu)
+static void rvu_dbg_cpt_init(struct rvu *rvu, int blkaddr)
 {
-	if (!is_block_implemented(rvu->hw, BLKADDR_CPT0))
+	if (!is_block_implemented(rvu->hw, blkaddr))
 		return;
 
-	rvu->rvu_dbg.cpt = debugfs_create_dir("cpt", rvu->rvu_dbg.root);
+	if (blkaddr == BLKADDR_NIX0)
+		rvu->rvu_dbg.cpt = debugfs_create_dir("cpt", rvu->rvu_dbg.root);
+	else
+		rvu->rvu_dbg.cpt = debugfs_create_dir("cpt1",
+						      rvu->rvu_dbg.root);
 
 	debugfs_create_file("cpt_pc", 0600, rvu->rvu_dbg.cpt, rvu,
 			    &rvu_dbg_cpt_pc_fops);
@@ -2145,7 +2151,8 @@ void rvu_dbg_init(struct rvu *rvu)
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

