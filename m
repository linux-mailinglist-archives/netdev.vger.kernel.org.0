Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9F2665B4C
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 13:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbjAKMYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 07:24:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232942AbjAKMYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 07:24:11 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257956376
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 04:24:11 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30B9Zi4D016451;
        Wed, 11 Jan 2023 04:24:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=8cazZwH9Kvf5whLyyU7u9nMqVXJ/n7UwztgCWNBTuLc=;
 b=X/KL04gpBYEEVBOHzQ0INlJoBTyRjzVZwpWCLRR5FRAo4G4FXaYlP4iHdPUC/MTibIot
 GxOk2QeS/rBxNkO4IsLSg3xihf+i8S0ZoRTP5EMgkTHEpNIM3ljqY25XhyDtmtGT8F2t
 Ppo+Uis0QIV4fHWa+VPVw7xgGAHNbMtud+ItZkBGpVmEyw4Rdifo920tAWQkst0HVM56
 dd86p22bG8Ja2Q07dDXePIa6B50HAR+8mF8txYId89tE8oZb4VXWHBb23Rklwh/N9SE8
 ddkX6qPE86TDL4GeZXoFgpUzwz/Wkja5gfE443AnreP9RrY/Bz4F7Idrc54Y6PzSzNzB Wg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3n1k56t553-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 11 Jan 2023 04:24:05 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 11 Jan
 2023 04:24:03 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Wed, 11 Jan 2023 04:24:03 -0800
Received: from localhost.localdomain (unknown [10.28.36.175])
        by maili.marvell.com (Postfix) with ESMTP id 0444F3F7040;
        Wed, 11 Jan 2023 04:23:59 -0800 (PST)
From:   Srujana Challa <schalla@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jerinj@marvell.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <schalla@marvell.com>
Subject: [PATCH v2 net-next,4/8] octeontx2-af: optimize cpt pf identification
Date:   Wed, 11 Jan 2023 17:53:39 +0530
Message-ID: <20230111122343.928694-5-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230111122343.928694-1-schalla@marvell.com>
References: <20230111122343.928694-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Yey2nt-mBzAj8fmUw0EjaW5Rva90jOiG
X-Proofpoint-GUID: Yey2nt-mBzAj8fmUw0EjaW5Rva90jOiG
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

Optimize CPT PF identification in mbox handling for faster
mbox response by doing it at AF driver probe instead of
every mbox message.

Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c     |  8 ++++++++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h     |  2 ++
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c | 13 ++++++++++---
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 3f5e09b77d4b..8683ce57ed3f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -1164,8 +1164,16 @@ static int rvu_setup_hw_resources(struct rvu *rvu)
 		goto nix_err;
 	}
 
+	err = rvu_cpt_init(rvu);
+	if (err) {
+		dev_err(rvu->dev, "%s: Failed to initialize cpt\n", __func__);
+		goto mcs_err;
+	}
+
 	return 0;
 
+mcs_err:
+	rvu_mcs_exit(rvu);
 nix_err:
 	rvu_nix_freemem(rvu);
 npa_err:
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 20c75d7c962e..2f480c73ef55 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -511,6 +511,7 @@ struct rvu {
 	struct ptp		*ptp;
 
 	int			mcs_blk_cnt;
+	int			cpt_pf_num;
 
 #ifdef CONFIG_DEBUG_FS
 	struct rvu_debugfs	rvu_dbg;
@@ -877,6 +878,7 @@ void rvu_cpt_unregister_interrupts(struct rvu *rvu);
 int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int lf,
 			int slot);
 int rvu_cpt_ctx_flush(struct rvu *rvu, u16 pcifunc);
+int rvu_cpt_init(struct rvu *rvu);
 
 /* CN10K RVU */
 int rvu_set_channels_base(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index e8973294c4f8..f970cb9b0bff 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -340,7 +340,7 @@ static int get_cpt_pf_num(struct rvu *rvu)
 
 static bool is_cpt_pf(struct rvu *rvu, u16 pcifunc)
 {
-	int cpt_pf_num = get_cpt_pf_num(rvu);
+	int cpt_pf_num = rvu->cpt_pf_num;
 
 	if (rvu_get_pf(pcifunc) != cpt_pf_num)
 		return false;
@@ -352,7 +352,7 @@ static bool is_cpt_pf(struct rvu *rvu, u16 pcifunc)
 
 static bool is_cpt_vf(struct rvu *rvu, u16 pcifunc)
 {
-	int cpt_pf_num = get_cpt_pf_num(rvu);
+	int cpt_pf_num = rvu->cpt_pf_num;
 
 	if (rvu_get_pf(pcifunc) != cpt_pf_num)
 		return false;
@@ -1015,7 +1015,7 @@ int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int lf, int s
 static int cpt_inline_inb_lf_cmd_send(struct rvu *rvu, int blkaddr,
 				      int nix_blkaddr)
 {
-	int cpt_pf_num = get_cpt_pf_num(rvu);
+	int cpt_pf_num = rvu->cpt_pf_num;
 	struct cpt_inst_lmtst_req *req;
 	dma_addr_t res_daddr;
 	int timeout = 3000;
@@ -1159,3 +1159,10 @@ int rvu_cpt_ctx_flush(struct rvu *rvu, u16 pcifunc)
 
 	return 0;
 }
+
+int rvu_cpt_init(struct rvu *rvu)
+{
+	/* Retrieve CPT PF number */
+	rvu->cpt_pf_num = get_cpt_pf_num(rvu);
+	return 0;
+}
-- 
2.25.1

