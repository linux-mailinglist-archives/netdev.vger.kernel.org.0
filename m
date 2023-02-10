Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF5C5691DC2
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 12:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbjBJLLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 06:11:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbjBJLLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 06:11:32 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2901470CE6;
        Fri, 10 Feb 2023 03:11:31 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AB22Xf025691;
        Fri, 10 Feb 2023 03:11:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=GRGFK9GLfs5dF7tqaDgMvBY0sj8AhevJVwlN7IJ9AZo=;
 b=JyFpZK0CCSrdoM4bI6HM6c9e5/bKxtETMlInEBq2bAkSKGbs5KYpolNcsyiSFailZenb
 rR1k9NQ0apda1B8dK0W4vcFf5JN8QPMuFVUItrJ2uyUC4B6OHwZthcrB5QDPeS+AJISy
 ymXYDr0IiEMIsXXoPbu700H7NiSVyN07kXXBTinbTKdCdYFAyN+6sz70SmOmJbyc2moy
 0+K1vyapomF0xrYUvvkiz+YD08FoY7jgXM6u62sl9ghOCaN80vG+Ktc2kmgeFTQERusE
 PlH3xCtsx25UbOOhHJNTaTegPXQc27INnpP7WtlVPCxEiFP+/N1rFUfsSpOObhfZWyOk Hg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3nnf7wgqm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 10 Feb 2023 03:11:21 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 10 Feb
 2023 03:11:19 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Fri, 10 Feb 2023 03:11:19 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id D68D95B6939;
        Fri, 10 Feb 2023 03:11:12 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <saeedm@nvidia.com>, <richardcochran@gmail.com>,
        <tariqt@nvidia.com>, <linux-rdma@vger.kernel.org>,
        <maxtram95@gmail.com>, <naveenm@marvell.com>,
        <bpf@vger.kernel.org>, <hariprasad.netdev@gmail.com>
Subject: [net-next Patch V4 3/4] octeontx2-pf: Refactor schedular queue alloc/free calls
Date:   Fri, 10 Feb 2023 16:40:50 +0530
Message-ID: <20230210111051.13654-4-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230210111051.13654-1-hkelam@marvell.com>
References: <20230210111051.13654-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: DJp9yypE7OCAtkKIJ7b37qHq3Pn1MG1u
X-Proofpoint-GUID: DJp9yypE7OCAtkKIJ7b37qHq3Pn1MG1u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_06,2023-02-09_03,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Multiple transmit scheduler queues can be configured at different
levels to support traffic shaping and scheduling. But on txschq free
requests, the transmit schedular config in hardware is not getting
reset. This patch adds support to reset the stale config.

The txschq alloc response handler updates the default txschq
array which is used to configure the transmit packet path from
SMQ to TL2 levels. However, for new features such as QoS offload
that requires it's own txschq queues, this handler is still
invoked and results in undefined behavior. The code now handles
txschq response in the mbox caller function.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 45 +++++++++++++++++++
 .../marvell/octeontx2/nic/otx2_common.c       | 36 ++++++++-------
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  4 --
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |  4 --
 4 files changed, 64 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 89e94569e74c..c11859999074 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -1677,6 +1677,42 @@ handle_txschq_shaper_update(struct rvu *rvu, int blkaddr, int nixlf,
 	return true;
 }
 
+static void nix_reset_tx_schedule(struct rvu *rvu, int blkaddr,
+				  int lvl, int schq)
+{
+	u64 tlx_parent = 0, tlx_schedule = 0;
+
+	switch (lvl) {
+	case NIX_TXSCH_LVL_TL2:
+		tlx_parent   = NIX_AF_TL2X_PARENT(schq);
+		tlx_schedule = NIX_AF_TL2X_SCHEDULE(schq);
+		break;
+	case NIX_TXSCH_LVL_TL3:
+		tlx_parent   = NIX_AF_TL3X_PARENT(schq);
+		tlx_schedule = NIX_AF_TL3X_SCHEDULE(schq);
+		break;
+	case NIX_TXSCH_LVL_TL4:
+		tlx_parent   = NIX_AF_TL4X_PARENT(schq);
+		tlx_schedule = NIX_AF_TL4X_SCHEDULE(schq);
+		break;
+	case NIX_TXSCH_LVL_MDQ:
+		/* no need to reset SMQ_CFG as HW clears this CSR
+		 * on SMQ flush
+		 */
+		tlx_parent   = NIX_AF_MDQX_PARENT(schq);
+		tlx_schedule = NIX_AF_MDQX_SCHEDULE(schq);
+		break;
+	default:
+		return;
+	}
+
+	if (tlx_parent)
+		rvu_write64(rvu, blkaddr, tlx_parent, 0x0);
+
+	if (tlx_schedule)
+		rvu_write64(rvu, blkaddr, tlx_schedule, 0x0);
+}
+
 /* Disable shaping of pkts by a scheduler queue
  * at a given scheduler level.
  */
@@ -2025,6 +2061,7 @@ int rvu_mbox_handler_nix_txsch_alloc(struct rvu *rvu,
 				pfvf_map[schq] = TXSCH_MAP(pcifunc, 0);
 			nix_reset_tx_linkcfg(rvu, blkaddr, lvl, schq);
 			nix_reset_tx_shaping(rvu, blkaddr, nixlf, lvl, schq);
+			nix_reset_tx_schedule(rvu, blkaddr, lvl, schq);
 		}
 
 		for (idx = 0; idx < req->schq[lvl]; idx++) {
@@ -2034,6 +2071,7 @@ int rvu_mbox_handler_nix_txsch_alloc(struct rvu *rvu,
 				pfvf_map[schq] = TXSCH_MAP(pcifunc, 0);
 			nix_reset_tx_linkcfg(rvu, blkaddr, lvl, schq);
 			nix_reset_tx_shaping(rvu, blkaddr, nixlf, lvl, schq);
+			nix_reset_tx_schedule(rvu, blkaddr, lvl, schq);
 		}
 	}
 
@@ -2122,6 +2160,7 @@ static int nix_txschq_free(struct rvu *rvu, u16 pcifunc)
 				continue;
 			nix_reset_tx_linkcfg(rvu, blkaddr, lvl, schq);
 			nix_clear_tx_xoff(rvu, blkaddr, lvl, schq);
+			nix_reset_tx_shaping(rvu, blkaddr, nixlf, lvl, schq);
 		}
 	}
 	nix_clear_tx_xoff(rvu, blkaddr, NIX_TXSCH_LVL_TL1,
@@ -2160,6 +2199,7 @@ static int nix_txschq_free(struct rvu *rvu, u16 pcifunc)
 		for (schq = 0; schq < txsch->schq.max; schq++) {
 			if (TXSCH_MAP_FUNC(txsch->pfvf_map[schq]) != pcifunc)
 				continue;
+			nix_reset_tx_schedule(rvu, blkaddr, lvl, schq);
 			rvu_free_rsrc(&txsch->schq, schq);
 			txsch->pfvf_map[schq] = TXSCH_MAP(0, NIX_TXSCHQ_FREE);
 		}
@@ -2219,6 +2259,9 @@ static int nix_txschq_free_one(struct rvu *rvu,
 	 */
 	nix_clear_tx_xoff(rvu, blkaddr, lvl, schq);
 
+	nix_reset_tx_linkcfg(rvu, blkaddr, lvl, schq);
+	nix_reset_tx_shaping(rvu, blkaddr, nixlf, lvl, schq);
+
 	/* Flush if it is a SMQ. Onus of disabling
 	 * TL2/3 queue links before SMQ flush is on user
 	 */
@@ -2228,6 +2271,8 @@ static int nix_txschq_free_one(struct rvu *rvu,
 		goto err;
 	}
 
+	nix_reset_tx_schedule(rvu, blkaddr, lvl, schq);
+
 	/* Free the resource */
 	rvu_free_rsrc(&txsch->schq, schq);
 	txsch->pfvf_map[schq] = TXSCH_MAP(0, NIX_TXSCHQ_FREE);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 73c8d36b6e12..4cb3fab8baae 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -716,7 +716,8 @@ EXPORT_SYMBOL(otx2_smq_flush);
 int otx2_txsch_alloc(struct otx2_nic *pfvf)
 {
 	struct nix_txsch_alloc_req *req;
-	int lvl;
+	struct nix_txsch_alloc_rsp *rsp;
+	int lvl, schq, rc;
 
 	/* Get memory to put this msg */
 	req = otx2_mbox_alloc_msg_nix_txsch_alloc(&pfvf->mbox);
@@ -726,8 +727,24 @@ int otx2_txsch_alloc(struct otx2_nic *pfvf)
 	/* Request one schq per level */
 	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++)
 		req->schq[lvl] = 1;
+	rc = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (rc)
+		return rc;
 
-	return otx2_sync_mbox_msg(&pfvf->mbox);
+	rsp = (struct nix_txsch_alloc_rsp *)
+	      otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
+	if (IS_ERR(rsp))
+		return PTR_ERR(rsp);
+
+	/* Setup transmit scheduler list */
+	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++)
+		for (schq = 0; schq < rsp->schq[lvl]; schq++)
+			pfvf->hw.txschq_list[lvl][schq] =
+				rsp->schq_list[lvl][schq];
+
+	pfvf->hw.txschq_link_cfg_lvl     = rsp->link_cfg_lvl;
+
+	return 0;
 }
 
 int otx2_txschq_stop(struct otx2_nic *pfvf)
@@ -1641,21 +1658,6 @@ void mbox_handler_cgx_fec_stats(struct otx2_nic *pfvf,
 	pfvf->hw.cgx_fec_uncorr_blks += rsp->fec_uncorr_blks;
 }
 
-void mbox_handler_nix_txsch_alloc(struct otx2_nic *pf,
-				  struct nix_txsch_alloc_rsp *rsp)
-{
-	int lvl, schq;
-
-	/* Setup transmit scheduler list */
-	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++)
-		for (schq = 0; schq < rsp->schq[lvl]; schq++)
-			pf->hw.txschq_list[lvl][schq] =
-				rsp->schq_list[lvl][schq];
-
-	pf->hw.txschq_link_cfg_lvl = rsp->link_cfg_lvl;
-}
-EXPORT_SYMBOL(mbox_handler_nix_txsch_alloc);
-
 void mbox_handler_npa_lf_alloc(struct otx2_nic *pfvf,
 			       struct npa_lf_alloc_rsp *rsp)
 {
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 3f88975e13c1..9ed24bff6b2a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -792,10 +792,6 @@ static void otx2_process_pfaf_mbox_msg(struct otx2_nic *pf,
 	case MBOX_MSG_NIX_LF_ALLOC:
 		mbox_handler_nix_lf_alloc(pf, (struct nix_lf_alloc_rsp *)msg);
 		break;
-	case MBOX_MSG_NIX_TXSCH_ALLOC:
-		mbox_handler_nix_txsch_alloc(pf,
-					     (struct nix_txsch_alloc_rsp *)msg);
-		break;
 	case MBOX_MSG_NIX_BP_ENABLE:
 		mbox_handler_nix_bp_enable(pf, (struct nix_bp_cfg_rsp *)msg);
 		break;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index c84804d16b8a..b7af02b12e05 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -70,10 +70,6 @@ static void otx2vf_process_vfaf_mbox_msg(struct otx2_nic *vf,
 	case MBOX_MSG_NIX_LF_ALLOC:
 		mbox_handler_nix_lf_alloc(vf, (struct nix_lf_alloc_rsp *)msg);
 		break;
-	case MBOX_MSG_NIX_TXSCH_ALLOC:
-		mbox_handler_nix_txsch_alloc(vf,
-					     (struct nix_txsch_alloc_rsp *)msg);
-		break;
 	case MBOX_MSG_NIX_BP_ENABLE:
 		mbox_handler_nix_bp_enable(vf, (struct nix_bp_cfg_rsp *)msg);
 		break;
-- 
2.17.1

