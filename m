Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E82D661F4E
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 08:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236476AbjAIHgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 02:36:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236306AbjAIHgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 02:36:33 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8FD12AC4
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 23:36:32 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 308Jp9vY008708;
        Sun, 8 Jan 2023 23:36:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=8cazZwH9Kvf5whLyyU7u9nMqVXJ/n7UwztgCWNBTuLc=;
 b=FsMW7XcW7xTL/+xmK6FB6Ugq8dx4o4K75TV3ndAc/24jH6LZmLwMDhLHb7qNrXXVjO6T
 zXV1ZZzZOnwL16eX9+fbBB4mzNP276XEdSwsS3koxxF/T9ajb4wJqZQpHl0Il3csX2gw
 rDVHojQrvZlw7iVYlhulf0V8vKZXFs3rUyzVJYjT68NWgGc1bMXzmnT6ySON+oIEYD/9
 krhOTGJ17nC8tR4NQshG5Fmc3rZjVobpYT5Eh+CJEs8vqZMez2fgnAi78LLQmpiU+132
 TXFqCgSJIPD6qe38IrriyCQ74/d2ECnKc5EshagmPIB9G2XcyWZClCoCM/vbaG4v9ym8 uA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3my94tmmmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 08 Jan 2023 23:36:26 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Sun, 8 Jan
 2023 23:36:24 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Sun, 8 Jan 2023 23:36:24 -0800
Received: from localhost.localdomain (unknown [10.28.36.175])
        by maili.marvell.com (Postfix) with ESMTP id E4D873F7057;
        Sun,  8 Jan 2023 23:36:21 -0800 (PST)
From:   Srujana Challa <schalla@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <jerinj@marvell.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [PATCH net-next,5/9] octeontx2-af: optimize cpt pf identification
Date:   Mon, 9 Jan 2023 13:05:59 +0530
Message-ID: <20230109073603.861043-6-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230109073603.861043-1-schalla@marvell.com>
References: <20230109073603.861043-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 1C-yRCfAg7EIT-ZMgWHAxTGfDRus9Axd
X-Proofpoint-GUID: 1C-yRCfAg7EIT-ZMgWHAxTGfDRus9Axd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_02,2023-01-06_01,2022-06-22_01
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

