Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0C43F74F8
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 14:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240935AbhHYMUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 08:20:05 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:62376 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240864AbhHYMTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 08:19:50 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17P6euWi015422;
        Wed, 25 Aug 2021 05:18:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=6a5aG4Ngwt1IXuDFNG/90MzD4kUtSb/HWt8XrxZenbA=;
 b=Xh39xs2pVFpZhixyzzgoAt7JS1kjCO9LcRBThekrVp+9AJd4/2/YoKzRGu3HI51juNdU
 SxZaFp/7ep7Mg/fJWLAXucFzo6BFKXtfjfWLCrwKIwQ7fUGiSAvmh0NyDslU3nmU3D0D
 zmmGeRzg5hJspw4rjxEon8KE9W3RoiaObrq5tC681REIZObuM7SgIqvvyBPZeHn5WtwZ
 Am88P91HLReanW8LdiI7dmHGD6wTlH2X2aziUm5GsDmxM9IZCGiMQ2MM9tUQjX0P2ULU
 nmr0mHhKGghvBpwzRLr8VcBYpWRRCWWevNKXfUYlk9lpQAymwdF0X3XLbpyMR1gb+Dwd Dg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3angt017nh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 25 Aug 2021 05:18:57 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 25 Aug
 2021 05:18:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 25 Aug 2021 05:18:56 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id 585403F7067;
        Wed, 25 Aug 2021 05:18:54 -0700 (PDT)
From:   Sunil Goutham <sgoutham@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Jerin Jacob <jerinj@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [net-next PATCH 2/9] octeontx2-af: Allow to configure flow tag LSB byte as RSS adder
Date:   Wed, 25 Aug 2021 17:48:39 +0530
Message-ID: <1629893926-18398-3-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629893926-18398-1-git-send-email-sgoutham@marvell.com>
References: <1629893926-18398-1-git-send-email-sgoutham@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: fj2CTRubIVzD2zS9ftq9h86RxoIIuzqu
X-Proofpoint-GUID: fj2CTRubIVzD2zS9ftq9h86RxoIIuzqu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-25_05,2021-08-25_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jerin Jacob <jerinj@marvell.com>

Before C0 HW revision, The RSS adder was computed based the
following static formula.

rss_adder<7:0> = flow_tag<7:0> ^ flow_tag<15:8> ^
flow_tag<23:16> ^ flow_tag<31:24>

The above scheme has the following drawbacks:
1) It is not in line with other standard NIC behavior.
2) There can be an SW use case where SW can compute the hash
upfront using Toeplitz function and predict the queue selection
to optimize some packet lookup function. The nonstandard
way of doing XOR makes the consumer to not predict the queue selection.

C0 HW revision onwards, The HW can configure the
rss_adder<7:0> as flow_tag<7:0> to align with standard NICs.

This patch adds an option to select legacy RSS adder mode
vs standard NIC behavior by setting NIX_LF_RSS_TAG_LSB_AS_ADDER flag.

Since this bit field is used as reserved in old HW revisions,
No need to have an additional HW version check.

Signed-off-by: Jerin Jacob <jerinj@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h    |  2 ++
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 17 +++++++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 5ffb6b6..8ee9504 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -704,6 +704,8 @@ struct nix_lf_alloc_req {
 	u16 sso_func;
 	u64 rx_cfg;   /* See NIX_AF_LF(0..127)_RX_CFG */
 	u64 way_mask;
+#define NIX_LF_RSS_TAG_LSB_AS_ADDER BIT_ULL(0)
+	u64 flags;
 };
 
 struct nix_lf_alloc_rsp {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 54d2dfa..a07d99a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -671,9 +671,10 @@ static void nix_ctx_free(struct rvu *rvu, struct rvu_pfvf *pfvf)
 static int nixlf_rss_ctx_init(struct rvu *rvu, int blkaddr,
 			      struct rvu_pfvf *pfvf, int nixlf,
 			      int rss_sz, int rss_grps, int hwctx_size,
-			      u64 way_mask)
+			      u64 way_mask, bool tag_lsb_as_adder)
 {
 	int err, grp, num_indices;
+	u64 val;
 
 	/* RSS is not requested for this NIXLF */
 	if (!rss_sz)
@@ -689,10 +690,13 @@ static int nixlf_rss_ctx_init(struct rvu *rvu, int blkaddr,
 		    (u64)pfvf->rss_ctx->iova);
 
 	/* Config full RSS table size, enable RSS and caching */
-	rvu_write64(rvu, blkaddr, NIX_AF_LFX_RSS_CFG(nixlf),
-		    BIT_ULL(36) | BIT_ULL(4) |
-		    ilog2(num_indices / MAX_RSS_INDIR_TBL_SIZE) |
-		    way_mask << 20);
+	val = BIT_ULL(36) | BIT_ULL(4) | way_mask << 20 |
+			ilog2(num_indices / MAX_RSS_INDIR_TBL_SIZE);
+
+	if (tag_lsb_as_adder)
+		val |= BIT_ULL(5);
+
+	rvu_write64(rvu, blkaddr, NIX_AF_LFX_RSS_CFG(nixlf), val);
 	/* Config RSS group offset and sizes */
 	for (grp = 0; grp < rss_grps; grp++)
 		rvu_write64(rvu, blkaddr, NIX_AF_LFX_RSS_GRPX(nixlf, grp),
@@ -1241,7 +1245,8 @@ int rvu_mbox_handler_nix_lf_alloc(struct rvu *rvu,
 	/* Initialize receive side scaling (RSS) */
 	hwctx_size = 1UL << ((ctx_cfg >> 12) & 0xF);
 	err = nixlf_rss_ctx_init(rvu, blkaddr, pfvf, nixlf, req->rss_sz,
-				 req->rss_grps, hwctx_size, req->way_mask);
+				 req->rss_grps, hwctx_size, req->way_mask,
+				 !!(req->flags & NIX_LF_RSS_TAG_LSB_AS_ADDER));
 	if (err)
 		goto free_mem;
 
-- 
2.7.4

