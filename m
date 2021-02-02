Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA46530C3D4
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 16:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235324AbhBBPah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 10:30:37 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:34864 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235592AbhBBP2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 10:28:48 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 112FOkVS003759;
        Tue, 2 Feb 2021 07:27:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=qZcydLCdqfhoqliWZKqqImE6OGiDWigqsO8cyZUAFp0=;
 b=MmZgxP75xtUGES8dWZSselliRLq9z9/clbd21UhSGDE/+iuID3HcXhf1Jau6ounPMRgZ
 IZKmdNJcGdtsv8O579ycqJCQRkdOCh8wuwj8Id6R/IlqzzvLk6zJjg8GhAZ4vZGRAGY6
 zhYPYJmy4JtQaHeVXZIsqqBJA1fr+NpXxgnYJrXpTRVU8GXNyD257EeNHjUEH0fN3t/+
 4n7lxQQ6m5kcOqpHZVXU7V3oM/N70tJ9ETw4ru7jyeuIVRwCdSMpQ8uo8rWVERIiH+0F
 d87c82a8PvgppZUOm7lFkuU4DtTFE8bvkPd2PTd5C/uopqzcIaaHJedTLzak9jvUZpUl oQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 36d5psyt6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 02 Feb 2021 07:27:59 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 2 Feb
 2021 07:27:58 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 2 Feb 2021 07:27:57 -0800
Received: from hyd1schalla-dt.caveonetworks.com.com (unknown [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id 8A8D63F703F;
        Tue,  2 Feb 2021 07:27:54 -0800 (PST)
From:   Srujana Challa <schalla@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>, <jerinj@marvell.com>,
        Srujana Challa <schalla@marvell.com>,
        Mahipal Challa <mchalla@marvell.com>
Subject: [PATCH v2,net-next,1/3] octeontx2-af: Mailbox changes for 98xx CPT block
Date:   Tue, 2 Feb 2021 20:57:07 +0530
Message-ID: <20210202152709.20450-2-schalla@marvell.com>
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

This patch changes CPT mailbox message format to
support new block CPT1 in 98xx silicon.

cpt_rd_wr_reg ->
    Modify cpt_rd_wr_reg mailbox and its handler to
    accommodate new block CPT1.
cpt_lf_alloc ->
    Modify cpt_lf_alloc mailbox and its handler to
    configure LFs from a block address out of multiple
    blocks of same type. If a PF/VF needs to configure
    LFs from both the blocks then this mbox should be
    called twice.

Signed-off-by: Mahipal Challa <mchalla@marvell.com>
Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  2 +
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 41 +++++++++++--------
 2 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 89e93eb46ab7..a0fa44941204 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -1073,6 +1073,7 @@ struct cpt_rd_wr_reg_msg {
 	u64 *ret_val;
 	u64 val;
 	u8 is_write;
+	int blkaddr;
 };
 
 struct cpt_lf_alloc_req_msg {
@@ -1080,6 +1081,7 @@ struct cpt_lf_alloc_req_msg {
 	u16 nix_pf_func;
 	u16 sso_pf_func;
 	u16 eng_grpmsk;
+	int blkaddr;
 };
 
 #endif /* MBOX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index 35261d52c997..b6de4b95a72a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -65,13 +65,13 @@ int rvu_mbox_handler_cpt_lf_alloc(struct rvu *rvu,
 	int num_lfs, slot;
 	u64 val;
 
+	blkaddr = req->blkaddr ? req->blkaddr : BLKADDR_CPT0;
+	if (blkaddr != BLKADDR_CPT0 && blkaddr != BLKADDR_CPT1)
+		return -ENODEV;
+
 	if (req->eng_grpmsk == 0x0)
 		return CPT_AF_ERR_GRP_INVALID;
 
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
-	if (blkaddr < 0)
-		return blkaddr;
-
 	block = &rvu->hw->block[blkaddr];
 	num_lfs = rvu_get_rsrc_mapcount(rvu_get_pfvf(rvu, pcifunc),
 					block->addr);
@@ -114,23 +114,17 @@ int rvu_mbox_handler_cpt_lf_alloc(struct rvu *rvu,
 	return 0;
 }
 
-int rvu_mbox_handler_cpt_lf_free(struct rvu *rvu, struct msg_req *req,
-				 struct msg_rsp *rsp)
+static int cpt_lf_free(struct rvu *rvu, struct msg_req *req, int blkaddr)
 {
 	u16 pcifunc = req->hdr.pcifunc;
+	int num_lfs, cptlf, slot;
 	struct rvu_block *block;
-	int cptlf, blkaddr;
-	int num_lfs, slot;
-
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
-	if (blkaddr < 0)
-		return blkaddr;
 
 	block = &rvu->hw->block[blkaddr];
 	num_lfs = rvu_get_rsrc_mapcount(rvu_get_pfvf(rvu, pcifunc),
 					block->addr);
 	if (!num_lfs)
-		return CPT_AF_ERR_LF_INVALID;
+		return 0;
 
 	for (slot = 0; slot < num_lfs; slot++) {
 		cptlf = rvu_get_lf(rvu, block, pcifunc, slot);
@@ -146,6 +140,21 @@ int rvu_mbox_handler_cpt_lf_free(struct rvu *rvu, struct msg_req *req,
 	return 0;
 }
 
+int rvu_mbox_handler_cpt_lf_free(struct rvu *rvu, struct msg_req *req,
+				 struct msg_rsp *rsp)
+{
+	int ret;
+
+	ret = cpt_lf_free(rvu, req, BLKADDR_CPT0);
+	if (ret)
+		return ret;
+
+	if (is_block_implemented(rvu->hw, BLKADDR_CPT1))
+		ret = cpt_lf_free(rvu, req, BLKADDR_CPT1);
+
+	return ret;
+}
+
 static bool is_valid_offset(struct rvu *rvu, struct cpt_rd_wr_reg_msg *req)
 {
 	u64 offset = req->reg_offset;
@@ -208,9 +217,9 @@ int rvu_mbox_handler_cpt_rd_wr_register(struct rvu *rvu,
 {
 	int blkaddr;
 
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
-	if (blkaddr < 0)
-		return blkaddr;
+	blkaddr = req->blkaddr ? req->blkaddr : BLKADDR_CPT0;
+	if (blkaddr != BLKADDR_CPT0 && blkaddr != BLKADDR_CPT1)
+		return -ENODEV;
 
 	/* This message is accepted only if sent from CPT PF/VF */
 	if (!is_cpt_pf(rvu, req->hdr.pcifunc) &&
-- 
2.29.0

