Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35BFD671C55
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 13:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjARMlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 07:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbjARMkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 07:40:15 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FB66D37B
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 04:04:21 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30I8rtiw009083;
        Wed, 18 Jan 2023 04:04:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=8cazZwH9Kvf5whLyyU7u9nMqVXJ/n7UwztgCWNBTuLc=;
 b=LNaSdh/257/gMRXFEF2N1p0S0RaLWGmHRcbUMaz0uegpA3DWKRR/bDkQq9XbLlJ7pn/t
 78D7vqXJq7PeWyDcKeiPqFvup8cYuNwYyCgmgaRPBoaOeGMu86emt2vNaNU3QzO/unCm
 RUJgqTjWWMn2vNieQhWZvmHp+deWpLBuerPYLDjNlfxDhdo7I8MmJX6lW3x9yCQSMBVh
 jT0oOuIBVexCx9YpLSr6mKVFmDRD7MOy6b/6aUMx6W/Gah14LTT8P+7ffXuY24dTFrFJ
 M6ojEjm6Xp37uYFq867A3reaJ7GtbL5+uPxE/LafDqNdlBixkgPecZVPy0RnIL2j3DT2 TQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3n3vstgubu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 04:04:16 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 18 Jan
 2023 04:04:14 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Wed, 18 Jan 2023 04:04:14 -0800
Received: from localhost.localdomain (unknown [10.28.36.175])
        by maili.marvell.com (Postfix) with ESMTP id BB2903F704E;
        Wed, 18 Jan 2023 04:04:10 -0800 (PST)
From:   Srujana Challa <schalla@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jerinj@marvell.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <schalla@marvell.com>
Subject: [PATCH net-next v3 4/7] octeontx2-af: optimize cpt pf identification
Date:   Wed, 18 Jan 2023 17:33:51 +0530
Message-ID: <20230118120354.1017961-5-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230118120354.1017961-1-schalla@marvell.com>
References: <20230118120354.1017961-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: xjlTkdchvDqnkdYrT6au9VA7S3451IPl
X-Proofpoint-GUID: xjlTkdchvDqnkdYrT6au9VA7S3451IPl
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

