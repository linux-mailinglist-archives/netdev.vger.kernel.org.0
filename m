Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A15649BB43
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 19:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbiAYS1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 13:27:32 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:57564 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231658AbiAYS12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 13:27:28 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20PAXH6J025305;
        Tue, 25 Jan 2022 10:27:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=R4xsLDo0IDM+WN++RajqbMQ729YCfaTeKhxL7/Be6Q8=;
 b=Tf9wW0A+ISrG2HBP7iFCfrRcBAit7sO1Kw9QjK/OHRFXHG8KcvMe4fZsPbzH6NWis30v
 xouTHc2cFFDJ/qwe2K6nS+NhNk5UCUnO4TNPX0wumpucfDoONjO/mk51Qwsa/3B6KgeK
 tKQNPAGoxtaC7d0xtEuwxZ/qdH2CblZOs75DcOngi9VGoIOTvMiWYkAiLaKQfbD/Ko/J
 NDbFhxbdVl1SLLXi+8S0i7w7icmZILLt5Hu12rD0l7Yej2e5AHHTMhsGgI0vncUxJBVh
 z4o5g/BZTy4GPNr6i/EDmYfIbzb0exUCum71NkCPcWEtHryUKRuDkm52yswEi2wwmKL8 Gg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3dt8muk0ge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 10:27:12 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 25 Jan
 2022 10:27:10 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 25 Jan 2022 10:27:09 -0800
Received: from localhost.localdomain (unknown [10.28.34.29])
        by maili.marvell.com (Postfix) with ESMTP id A97345E6868;
        Tue, 25 Jan 2022 10:27:04 -0800 (PST)
From:   Shijith Thotton <sthotton@marvell.com>
To:     Arnaud Ebalard <arno@natisbad.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Boris Brezillon <bbrezillon@kernel.org>
CC:     Srujana Challa <schalla@marvell.com>,
        <linux-crypto@vger.kernel.org>, <jerinj@marvell.com>,
        <sgoutham@marvell.com>, Shijith Thotton <sthotton@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:MARVELL OCTEONTX2 RVU ADMIN FUNCTION DRIVER" 
        <netdev@vger.kernel.org>
Subject: [PATCH] crypto: octeontx2: disable DMA black hole on an DMA fault
Date:   Tue, 25 Jan 2022 23:56:23 +0530
Message-ID: <2ece169a85504c8a185070055db2f6f8ea3c7d11.1643134449.git.sthotton@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <ab2269cb3ef3049ed0ab73f28be29f6669a06e36.1643134480.git.sthotton@marvell.com>
References: <ab2269cb3ef3049ed0ab73f28be29f6669a06e36.1643134480.git.sthotton@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: IzxQUWPTrdDlWI6sUKAOlwFzFEeTCAdW
X-Proofpoint-GUID: IzxQUWPTrdDlWI6sUKAOlwFzFEeTCAdW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_03,2022-01-25_02,2021-12-02_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Srujana Challa <schalla@marvell.com>

When CPT_AF_DIAG[FLT_DIS] = 0 and a CPT engine access to
LLC/DRAM encounters a fault/poison, a rare case may result
in unpredictable data being delivered to a CPT engine.
So, this patch adds code to set FLT_DIS as a workaround.

Signed-off-by: Srujana Challa <schalla@marvell.com>
Signed-off-by: Shijith Thotton <sthotton@marvell.com>
---
 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c | 13 +++++++++++++
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c |  1 +
 2 files changed, 14 insertions(+)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index 4c8ebdf671ca..e0b29cf504b9 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -1111,6 +1111,7 @@ int otx2_cpt_create_eng_grps(struct otx2_cptpf_dev *cptpf,
 	struct otx2_cpt_engines engs[OTX2_CPT_MAX_ETYPES_PER_GRP] = { {0} };
 	struct pci_dev *pdev = cptpf->pdev;
 	struct fw_info_t fw_info;
+	u64 reg_val;
 	int ret = 0;
 
 	mutex_lock(&eng_grps->lock);
@@ -1203,6 +1204,18 @@ int otx2_cpt_create_eng_grps(struct otx2_cptpf_dev *cptpf,
 	 */
 	otx2_cpt_write_af_reg(&cptpf->afpf_mbox, pdev, CPT_AF_CTX_FLUSH_TIMER,
 			      CTX_FLUSH_TIMER_CNT, BLKADDR_CPT0);
+
+	/*
+	 * Set CPT_AF_DIAG[FLT_DIS], as a workaround for HW errata, when
+	 * CPT_AF_DIAG[FLT_DIS] = 0 and a CPT engine access to LLC/DRAM
+	 * encounters a fault/poison, a rare case may result in
+	 * unpredictable data being delivered to a CPT engine.
+	 */
+	otx2_cpt_read_af_reg(&cptpf->afpf_mbox, pdev, CPT_AF_DIAG, &reg_val,
+			     BLKADDR_CPT0);
+	otx2_cpt_write_af_reg(&cptpf->afpf_mbox, pdev, CPT_AF_DIAG,
+			      reg_val | BIT_ULL(24), BLKADDR_CPT0);
+
 	mutex_unlock(&eng_grps->lock);
 	return 0;
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index 45357deecabb..1f7c971e6757 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -606,6 +606,7 @@ static bool is_valid_offset(struct rvu *rvu, struct cpt_rd_wr_reg_msg *req)
 	} else if (!(req->hdr.pcifunc & RVU_PFVF_FUNC_MASK)) {
 		/* Registers that can be accessed from PF */
 		switch (offset) {
+		case CPT_AF_DIAG:
 		case CPT_AF_CTL:
 		case CPT_AF_PF_FUNC:
 		case CPT_AF_BLK_RST:
-- 
2.25.1

