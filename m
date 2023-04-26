Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51E866EEDA4
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 07:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239446AbjDZFss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 01:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239447AbjDZFsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 01:48:45 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A884D35AC;
        Tue, 25 Apr 2023 22:48:15 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33PIXEpr013403;
        Tue, 25 Apr 2023 22:48:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=CIRshexfxY8mAQpx489TAR0r4/CAm5zty6Q2NXesydo=;
 b=JAA6k8p6VnOXn217khfg2KIx3OVG9D7ds53sjjwLgB4NX7GiQs+xuWqkVfj67ug/qU+T
 8W+eNIPgAkJp1JomYoqw5qI775IhcAn2huy6LggU4zKM+z0mtmCI6sUd4Kwqt0XBzVnF
 218FWsYG1oOmgAG/iq0yOire+hilW8yTWaQZZip2XOWGq3mpeM/u6a/UWLzK8NuNk66F
 HQZtCjU4Bjylk2Yn27Ncg+yXdEge4AodRJt8FzK0Ixm2t7mjlFn3AF7X9d9wO+AnaV0E
 ALO1yTikR2LfZZnQ2fMMLNC0MpRWvC3gEJLEEqf3qQRpWfa5UCYzoo9OaKXOzj9kKh3b /w== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3q6c2fcw23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 22:48:04 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 25 Apr
 2023 22:48:02 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 25 Apr 2023 22:48:02 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id C3FC43F706D;
        Tue, 25 Apr 2023 22:47:56 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <naveenm@marvell.com>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <maxtram95@gmail.com>, <corbet@lwn.net>
Subject: [net-next Patch v10 4/8] octeontx2-pf: Refactor schedular queue alloc/free calls
Date:   Wed, 26 Apr 2023 11:17:27 +0530
Message-ID: <20230426054731.5720-5-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230426054731.5720-1-hkelam@marvell.com>
References: <20230426054731.5720-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: MOHofM2vErl-boL9R6ruzmSwUOpG8Bug
X-Proofpoint-ORIG-GUID: MOHofM2vErl-boL9R6ruzmSwUOpG8Bug
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-26_02,2023-04-25_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. Upon txschq free request, the transmit schedular config in hardware
is not getting reset. This patch adds necessary changes to do the same.

2. Current implementation calls txschq alloc during interface
initialization and in response handler updates the default txschq array.
This creates a problem for htb offload where txsch alloc will be called
for every tc class. This patch addresses the issue by reading txschq
response in mbox caller function instead in the response handler.

3. Current otx2_txschq_stop routine tries to free all txschq nodes
allocated to the interface. This creates a problem for htb offload.
This patch introduces the otx2_txschq_free_one to free txschq in a
given level.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 45 +++++++++++++
 .../marvell/octeontx2/nic/otx2_common.c       | 67 ++++++++++++-------
 .../marvell/octeontx2/nic/otx2_common.h       |  3 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  | 13 +---
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |  4 --
 5 files changed, 94 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 4ad707e758b9..79ed7af0b0a4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -1691,6 +1691,42 @@ handle_txschq_shaper_update(struct rvu *rvu, int blkaddr, int nixlf,
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
@@ -2039,6 +2075,7 @@ int rvu_mbox_handler_nix_txsch_alloc(struct rvu *rvu,
 				pfvf_map[schq] = TXSCH_MAP(pcifunc, 0);
 			nix_reset_tx_linkcfg(rvu, blkaddr, lvl, schq);
 			nix_reset_tx_shaping(rvu, blkaddr, nixlf, lvl, schq);
+			nix_reset_tx_schedule(rvu, blkaddr, lvl, schq);
 		}
 
 		for (idx = 0; idx < req->schq[lvl]; idx++) {
@@ -2048,6 +2085,7 @@ int rvu_mbox_handler_nix_txsch_alloc(struct rvu *rvu,
 				pfvf_map[schq] = TXSCH_MAP(pcifunc, 0);
 			nix_reset_tx_linkcfg(rvu, blkaddr, lvl, schq);
 			nix_reset_tx_shaping(rvu, blkaddr, nixlf, lvl, schq);
+			nix_reset_tx_schedule(rvu, blkaddr, lvl, schq);
 		}
 	}
 
@@ -2143,6 +2181,7 @@ static int nix_txschq_free(struct rvu *rvu, u16 pcifunc)
 				continue;
 			nix_reset_tx_linkcfg(rvu, blkaddr, lvl, schq);
 			nix_clear_tx_xoff(rvu, blkaddr, lvl, schq);
+			nix_reset_tx_shaping(rvu, blkaddr, nixlf, lvl, schq);
 		}
 	}
 	nix_clear_tx_xoff(rvu, blkaddr, NIX_TXSCH_LVL_TL1,
@@ -2181,6 +2220,7 @@ static int nix_txschq_free(struct rvu *rvu, u16 pcifunc)
 		for (schq = 0; schq < txsch->schq.max; schq++) {
 			if (TXSCH_MAP_FUNC(txsch->pfvf_map[schq]) != pcifunc)
 				continue;
+			nix_reset_tx_schedule(rvu, blkaddr, lvl, schq);
 			rvu_free_rsrc(&txsch->schq, schq);
 			txsch->pfvf_map[schq] = TXSCH_MAP(0, NIX_TXSCHQ_FREE);
 		}
@@ -2240,6 +2280,9 @@ static int nix_txschq_free_one(struct rvu *rvu,
 	 */
 	nix_clear_tx_xoff(rvu, blkaddr, lvl, schq);
 
+	nix_reset_tx_linkcfg(rvu, blkaddr, lvl, schq);
+	nix_reset_tx_shaping(rvu, blkaddr, nixlf, lvl, schq);
+
 	/* Flush if it is a SMQ. Onus of disabling
 	 * TL2/3 queue links before SMQ flush is on user
 	 */
@@ -2249,6 +2292,8 @@ static int nix_txschq_free_one(struct rvu *rvu,
 		goto err;
 	}
 
+	nix_reset_tx_schedule(rvu, blkaddr, lvl, schq);
+
 	/* Free the resource */
 	rvu_free_rsrc(&txsch->schq, schq);
 	txsch->pfvf_map[schq] = TXSCH_MAP(0, NIX_TXSCHQ_FREE);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index adbcc087d2a8..6df6f6380b55 100644
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
@@ -726,33 +727,68 @@ int otx2_txsch_alloc(struct otx2_nic *pfvf)
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
+	pfvf->hw.txschq_link_cfg_lvl = rsp->link_cfg_lvl;
+
+	return 0;
 }
 
-int otx2_txschq_stop(struct otx2_nic *pfvf)
+void otx2_txschq_free_one(struct otx2_nic *pfvf, u16 lvl, u16 schq)
 {
 	struct nix_txsch_free_req *free_req;
-	int lvl, schq, err;
+	int err;
 
 	mutex_lock(&pfvf->mbox.lock);
-	/* Free the transmit schedulers */
+
 	free_req = otx2_mbox_alloc_msg_nix_txsch_free(&pfvf->mbox);
 	if (!free_req) {
 		mutex_unlock(&pfvf->mbox.lock);
-		return -ENOMEM;
+		netdev_err(pfvf->netdev,
+			   "Failed alloc txschq free req\n");
+		return;
 	}
 
-	free_req->flags = TXSCHQ_FREE_ALL;
+	free_req->schq_lvl = lvl;
+	free_req->schq = schq;
+
 	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (err) {
+		netdev_err(pfvf->netdev,
+			   "Failed stop txschq %d at level %d\n", schq, lvl);
+	}
+
 	mutex_unlock(&pfvf->mbox.lock);
+}
+
+void otx2_txschq_stop(struct otx2_nic *pfvf)
+{
+	int lvl, schq;
+
+	/* free non QOS TLx nodes */
+	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++)
+		otx2_txschq_free_one(pfvf, lvl,
+				     pfvf->hw.txschq_list[lvl][0]);
 
 	/* Clear the txschq list */
 	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++) {
 		for (schq = 0; schq < MAX_TXSCHQ_PER_FUNC; schq++)
 			pfvf->hw.txschq_list[lvl][schq] = 0;
 	}
-	return err;
+
 }
 
 void otx2_sqb_flush(struct otx2_nic *pfvf)
@@ -1642,21 +1678,6 @@ void mbox_handler_cgx_fec_stats(struct otx2_nic *pfvf,
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
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 383a6716dbb9..cbe09a33ba01 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -934,7 +934,8 @@ int otx2_config_nix(struct otx2_nic *pfvf);
 int otx2_config_nix_queues(struct otx2_nic *pfvf);
 int otx2_txschq_config(struct otx2_nic *pfvf, int lvl, int prio, bool pfc_en);
 int otx2_txsch_alloc(struct otx2_nic *pfvf);
-int otx2_txschq_stop(struct otx2_nic *pfvf);
+void otx2_txschq_stop(struct otx2_nic *pfvf);
+void otx2_txschq_free_one(struct otx2_nic *pfvf, u16 lvl, u16 schq);
 void otx2_sqb_flush(struct otx2_nic *pfvf);
 int otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
 		    dma_addr_t *dma);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index c9141d608342..8706bc2bcf75 100644
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
@@ -1522,8 +1518,7 @@ static int otx2_init_hw_resources(struct otx2_nic *pf)
 	otx2_free_cq_res(pf);
 	otx2_ctx_disable(mbox, NIX_AQ_CTYPE_RQ, false);
 err_free_txsch:
-	if (otx2_txschq_stop(pf))
-		dev_err(pf->dev, "%s failed to stop TX schedulers\n", __func__);
+	otx2_txschq_stop(pf);
 err_free_sq_ptrs:
 	otx2_sq_free_sqbs(pf);
 err_free_rq_ptrs:
@@ -1558,15 +1553,13 @@ static void otx2_free_hw_resources(struct otx2_nic *pf)
 	struct mbox *mbox = &pf->mbox;
 	struct otx2_cq_queue *cq;
 	struct msg_req *req;
-	int qidx, err;
+	int qidx;
 
 	/* Ensure all SQE are processed */
 	otx2_sqb_flush(pf);
 
 	/* Stop transmission */
-	err = otx2_txschq_stop(pf);
-	if (err)
-		dev_err(pf->dev, "RVUPF: Failed to stop/free TX schedulers\n");
+	otx2_txschq_stop(pf);
 
 #ifdef CONFIG_DCB
 	if (pf->pfc_en)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 5dddf067a810..ce8ffb71ff38 100644
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

