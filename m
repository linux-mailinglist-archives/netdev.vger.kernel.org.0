Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 973CA665B4E
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 13:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236789AbjAKMYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 07:24:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233279AbjAKMYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 07:24:15 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928BDE0BC
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 04:24:14 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30B16r7N027948;
        Wed, 11 Jan 2023 04:24:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=sEqiRpmSJHk+r/mLJ0syfwGrgE/Xez82s9VTJeYLOGg=;
 b=BvgUERr5HN+agyyfZNv5lWZWq6a8oCohwlldFMLGvMeuyW4I5qOh7N9fPRdUUUbB4pWa
 mVW/CSPedGGV9EXwzju+ph6pAsfPKRORbeFLp6Qn5dy10jBF4WNOia9XQjzH8Y809PtX
 8ZS5c4+7QcEQSuinUvWYBxBCS1WsoujK8kXkjnPmTQEdS0KVgKo6D4Xyv8DKtR0aFUso
 WHS/msbpmW/IAFKPckAt+X+fp/5C5De29emStxa7acyEyOMIMpEtVmka96be1MVSbpB5
 mR1LX+zC2ULfkUyGTCnmbx/q/2BMwkHP9LFg0IA//qozw6QG1euc3AbUFIQf4cTGgW8r Lw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3n1k55hgus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 11 Jan 2023 04:24:09 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 11 Jan
 2023 04:24:07 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Wed, 11 Jan 2023 04:24:07 -0800
Received: from localhost.localdomain (unknown [10.28.36.175])
        by maili.marvell.com (Postfix) with ESMTP id D11D63F704A;
        Wed, 11 Jan 2023 04:24:03 -0800 (PST)
From:   Srujana Challa <schalla@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jerinj@marvell.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <schalla@marvell.com>,
        Nithin Dabilpuram <ndabilpuram@marvell.com>
Subject: [PATCH v2 net-next,5/8] octeontx2-af: restore rxc conf after teardown sequence
Date:   Wed, 11 Jan 2023 17:53:40 +0530
Message-ID: <20230111122343.928694-6-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230111122343.928694-1-schalla@marvell.com>
References: <20230111122343.928694-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: wAEGkO38zxi7XQ2agHMbFZpXSD26tcU6
X-Proofpoint-ORIG-GUID: wAEGkO38zxi7XQ2agHMbFZpXSD26tcU6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-11_05,2023-01-11_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nithin Dabilpuram <ndabilpuram@marvell.com>

Restore rxc timeout and threshold config after teardown
sequence is complete as it is global config and not
per CPT LF.

Signed-off-by: Nithin Dabilpuram <ndabilpuram@marvell.com>
---
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 22 +++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index f970cb9b0bff..302ff549284e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -812,10 +812,21 @@ int rvu_mbox_handler_cpt_sts(struct rvu *rvu, struct cpt_sts_req *req,
 #define RXC_ZOMBIE_COUNT  GENMASK_ULL(60, 48)
 
 static void cpt_rxc_time_cfg(struct rvu *rvu, struct cpt_rxc_time_cfg_req *req,
-			     int blkaddr)
+			     int blkaddr, struct cpt_rxc_time_cfg_req *save)
 {
 	u64 dfrg_reg;
 
+	if (save) {
+		/* Save older config */
+		dfrg_reg = rvu_read64(rvu, blkaddr, CPT_AF_RXC_DFRG);
+		save->zombie_thres = FIELD_GET(RXC_ZOMBIE_THRES, dfrg_reg);
+		save->zombie_limit = FIELD_GET(RXC_ZOMBIE_LIMIT, dfrg_reg);
+		save->active_thres = FIELD_GET(RXC_ACTIVE_THRES, dfrg_reg);
+		save->active_limit = FIELD_GET(RXC_ACTIVE_LIMIT, dfrg_reg);
+
+		save->step = rvu_read64(rvu, blkaddr, CPT_AF_RXC_TIME_CFG);
+	}
+
 	dfrg_reg = FIELD_PREP(RXC_ZOMBIE_THRES, req->zombie_thres);
 	dfrg_reg |= FIELD_PREP(RXC_ZOMBIE_LIMIT, req->zombie_limit);
 	dfrg_reg |= FIELD_PREP(RXC_ACTIVE_THRES, req->active_thres);
@@ -840,7 +851,7 @@ int rvu_mbox_handler_cpt_rxc_time_cfg(struct rvu *rvu,
 	    !is_cpt_vf(rvu, req->hdr.pcifunc))
 		return CPT_AF_ERR_ACCESS_DENIED;
 
-	cpt_rxc_time_cfg(rvu, req, blkaddr);
+	cpt_rxc_time_cfg(rvu, req, blkaddr, NULL);
 
 	return 0;
 }
@@ -886,7 +897,7 @@ int rvu_mbox_handler_cpt_lf_reset(struct rvu *rvu, struct cpt_lf_rst_req *req,
 
 static void cpt_rxc_teardown(struct rvu *rvu, int blkaddr)
 {
-	struct cpt_rxc_time_cfg_req req;
+	struct cpt_rxc_time_cfg_req req, prev;
 	int timeout = 2000;
 	u64 reg;
 
@@ -902,7 +913,7 @@ static void cpt_rxc_teardown(struct rvu *rvu, int blkaddr)
 	req.active_thres = 1;
 	req.active_limit = 1;
 
-	cpt_rxc_time_cfg(rvu, &req, blkaddr);
+	cpt_rxc_time_cfg(rvu, &req, blkaddr, &prev);
 
 	do {
 		reg = rvu_read64(rvu, blkaddr, CPT_AF_RXC_ACTIVE_STS);
@@ -928,6 +939,9 @@ static void cpt_rxc_teardown(struct rvu *rvu, int blkaddr)
 
 	if (timeout == 0)
 		dev_warn(rvu->dev, "Poll for RXC zombie count hits hard loop counter\n");
+
+	/* Restore config */
+	cpt_rxc_time_cfg(rvu, &prev, blkaddr, NULL);
 }
 
 #define INFLIGHT   GENMASK_ULL(8, 0)
-- 
2.25.1

