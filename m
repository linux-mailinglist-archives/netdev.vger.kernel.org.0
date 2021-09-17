Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0DE40F8DF
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 15:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240673AbhIQNLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 09:11:54 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:48372 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240191AbhIQNLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 09:11:53 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18HCkjam018025;
        Fri, 17 Sep 2021 06:10:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=v70cNkPO1kw4kO7VHJjat5eVea6iUaJe4KB2otftuy8=;
 b=Cyi3pUcpIzmaBdA64Mr0lvS+D2HO9l6Gc7+VzMGPo24P4yBq1cSths1p4u1B+ymDg3a1
 BW9rZLN/ee2soVb9QvLVlTPEAtjvBT0qDUAxxDfp4kByL1jzuqtjYKPJoICcW7D2fuaE
 ioOA+LVIAxAWipuExWQiuJoK2yMPANr3/6cD1XudMf9iqMZJ++DJSOuoQkaECfkC6QX2
 Zyaz3bA6/cleM6g+1qLP+nlN5gqjgadMhcOme3ppeHYHztQf0c3l7wrH8BS/xqP2U9t6
 Zlu3e3j4cJI/BVcGgdGnuZjRYLNrJjNDMUymPWuPcl3yK6nd64p/BzQYpricX1lDM1bg sw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3b4uasg2av-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 06:10:30 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 17 Sep
 2021 06:10:28 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 17 Sep 2021 06:10:28 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id B7AFF3F707D;
        Fri, 17 Sep 2021 06:10:25 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net-next] octeontx2-af: verify CQ context updates
Date:   Fri, 17 Sep 2021 18:40:24 +0530
Message-ID: <20210917131024.19352-1-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: PGj0bQwJWraZn76PnPe3FNAL92Dh1Cot
X-Proofpoint-ORIG-GUID: PGj0bQwJWraZn76PnPe3FNAL92Dh1Cot
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-17_05,2021-09-17_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As per HW errata AQ modification to CQ could be discarded on heavy
traffic. This patch implements workaround for the same after each
CQ write by AQ check whether the requested fields (except those
which HW can update eg: avg_level) are properly updated or not.

If CQ context is not updated then perform AQ write again.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  2 +
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 78 ++++++++++++++++++-
 2 files changed, 79 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index f77f745be05b..250eefa5e853 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -704,6 +704,8 @@ enum nix_af_status {
 	NIX_AF_ERR_INVALID_BANDPROF = -426,
 	NIX_AF_ERR_IPOLICER_NOTSUPP = -427,
 	NIX_AF_ERR_BANDPROF_INVAL_REQ  = -428,
+	NIX_AF_ERR_CQ_CTX_WRITE_ERR  = -429,
+	NIX_AF_ERR_AQ_CTX_RETRY_WRITE  = -430,
 };
 
 /* For NIX RX vtag action  */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index ea3e03fa55d4..30b098cf4f7a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -28,6 +28,7 @@ static int nix_verify_bandprof(struct nix_cn10k_aq_enq_req *req,
 static int nix_free_all_bandprof(struct rvu *rvu, u16 pcifunc);
 static void nix_clear_ratelimit_aggr(struct rvu *rvu, struct nix_hw *nix_hw,
 				     u32 leaf_prof);
+static const char *nix_get_ctx_name(int ctype);
 
 enum mc_tbl_sz {
 	MC_TBL_SZ_256,
@@ -1061,10 +1062,68 @@ static int rvu_nix_blk_aq_enq_inst(struct rvu *rvu, struct nix_hw *nix_hw,
 	return 0;
 }
 
+static int rvu_nix_verify_aq_ctx(struct rvu *rvu, struct nix_hw *nix_hw,
+				 struct nix_aq_enq_req *req, u8 ctype)
+{
+	struct nix_cn10k_aq_enq_req aq_req;
+	struct nix_cn10k_aq_enq_rsp aq_rsp;
+	int rc, word;
+
+	if (req->ctype != NIX_AQ_CTYPE_CQ)
+		return 0;
+
+	rc = nix_aq_context_read(rvu, nix_hw, &aq_req, &aq_rsp,
+				 req->hdr.pcifunc, ctype, req->qidx);
+	if (rc) {
+		dev_err(rvu->dev,
+			"%s: Failed to fetch %s%d context of PFFUNC 0x%x\n",
+			__func__, nix_get_ctx_name(ctype), req->qidx,
+			req->hdr.pcifunc);
+		return rc;
+	}
+
+	/* Make copy of original context & mask which are required
+	 * for resubmission
+	 */
+	memcpy(&aq_req.cq_mask, &req->cq_mask, sizeof(struct nix_cq_ctx_s));
+	memcpy(&aq_req.cq, &req->cq, sizeof(struct nix_cq_ctx_s));
+
+	/* exclude fields which HW can update */
+	aq_req.cq_mask.cq_err       = 0;
+	aq_req.cq_mask.wrptr        = 0;
+	aq_req.cq_mask.tail         = 0;
+	aq_req.cq_mask.head	    = 0;
+	aq_req.cq_mask.avg_level    = 0;
+	aq_req.cq_mask.update_time  = 0;
+	aq_req.cq_mask.substream    = 0;
+
+	/* Context mask (cq_mask) holds mask value of fields which
+	 * are changed in AQ WRITE operation.
+	 * for example cq.drop = 0xa;
+	 *	       cq_mask.drop = 0xff;
+	 * Below logic performs '&' between cq and cq_mask so that non
+	 * updated fields are masked out for request and response
+	 * comparison
+	 */
+	for (word = 0; word < sizeof(struct nix_cq_ctx_s) / sizeof(u64);
+	     word++) {
+		*(u64 *)((u8 *)&aq_rsp.cq + word * 8) &=
+			(*(u64 *)((u8 *)&aq_req.cq_mask + word * 8));
+		*(u64 *)((u8 *)&aq_req.cq + word * 8) &=
+			(*(u64 *)((u8 *)&aq_req.cq_mask + word * 8));
+	}
+
+	if (memcmp(&aq_req.cq, &aq_rsp.cq, sizeof(struct nix_cq_ctx_s)))
+		return NIX_AF_ERR_AQ_CTX_RETRY_WRITE;
+
+	return 0;
+}
+
 static int rvu_nix_aq_enq_inst(struct rvu *rvu, struct nix_aq_enq_req *req,
 			       struct nix_aq_enq_rsp *rsp)
 {
 	struct nix_hw *nix_hw;
+	int err, retries = 5;
 	int blkaddr;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, req->hdr.pcifunc);
@@ -1075,7 +1134,24 @@ static int rvu_nix_aq_enq_inst(struct rvu *rvu, struct nix_aq_enq_req *req,
 	if (!nix_hw)
 		return NIX_AF_ERR_INVALID_NIXBLK;
 
-	return rvu_nix_blk_aq_enq_inst(rvu, nix_hw, req, rsp);
+retry:
+	err = rvu_nix_blk_aq_enq_inst(rvu, nix_hw, req, rsp);
+
+	/* HW errata 'AQ Modification to CQ could be discarded on heavy traffic'
+	 * As a work around perfrom CQ context read after each AQ write. If AQ
+	 * read shows AQ write is not updated perform AQ write again.
+	 */
+	if (!err && req->op == NIX_AQ_INSTOP_WRITE) {
+		err = rvu_nix_verify_aq_ctx(rvu, nix_hw, req, NIX_AQ_CTYPE_CQ);
+		if (err == NIX_AF_ERR_AQ_CTX_RETRY_WRITE) {
+			if (retries--)
+				goto retry;
+			else
+				return NIX_AF_ERR_CQ_CTX_WRITE_ERR;
+		}
+	}
+
+	return err;
 }
 
 static const char *nix_get_ctx_name(int ctype)
-- 
2.17.1

