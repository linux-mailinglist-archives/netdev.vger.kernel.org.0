Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5052C663938
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 07:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbjAJGU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 01:20:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbjAJGUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 01:20:55 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3ACF2AD9
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 22:20:53 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30A3wriX028425;
        Mon, 9 Jan 2023 22:20:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=KO+utiOO1L/jxEg3IbF7CuhnVtbahkFw27m+cHV8omE=;
 b=RPorCN85dfIFrDvcrge8TnqkZADT5yocXPChG1WLjWOeeKs32LWLYJ+E5wXwMEQ24lJ8
 GSJ0fZHWC7u1+GpxhAES6bsMLerJ0aZMRiBpT3+nxv/yUaazsIanoGzYfNffEB766Qrf
 sNFq7BpGSBugjRpNPJzJi4W4qvbbM+7DM1OHGyiNqOXAyWQMX5j+rFJOSmaav6UDvEWR
 x21oVPBpay6bDijspDOBOUtojB/rz3YhTvYBcTP2WbrLvhyEr5ax0ndEejCDWcnu5RYG
 iLrQEdf+5nRBNANIp1Xt5YSl0RmF/l0fyv7PQIUawufXi4E0rmvjU1ubYg9P8ekGFaMl UQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3my94tsn07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 22:20:45 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 9 Jan
 2023 22:20:43 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Mon, 9 Jan 2023 22:20:43 -0800
Received: from localhost.localdomain (unknown [10.28.36.175])
        by maili.marvell.com (Postfix) with ESMTP id E497E3F7081;
        Mon,  9 Jan 2023 22:20:39 -0800 (PST)
From:   Srujana Challa <schalla@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jerinj@marvell.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <schalla@marvell.com>,
        Nithin Dabilpuram <ndabilpuram@marvell.com>
Subject: [PATCH v1 net-next,5/8] octeontx2-af: restore rxc conf after teardown sequence
Date:   Tue, 10 Jan 2023 11:50:16 +0530
Message-ID: <20230110062019.892719-6-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230110062019.892719-1-schalla@marvell.com>
References: <20230110062019.892719-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: bhu0imOOBuhB1TS7TkllsvqlQcHgqUJg
X-Proofpoint-GUID: bhu0imOOBuhB1TS7TkllsvqlQcHgqUJg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-10_01,2023-01-09_02,2022-06-22_01
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

Change-Id: I6b7a7149d5f8ce9db44c1b339a655523cdf3cfd0
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

