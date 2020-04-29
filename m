Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBAE31BE235
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 17:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbgD2PLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 11:11:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28576 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727057AbgD2PLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 11:11:40 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03TFA04m018712;
        Wed, 29 Apr 2020 11:11:36 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30pjy7n17e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 11:11:35 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03TFB4Ra001536;
        Wed, 29 Apr 2020 15:11:33 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 30mcu59wgs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 15:11:33 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03TFBU6B65863700
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Apr 2020 15:11:30 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A4AEAE055;
        Wed, 29 Apr 2020 15:11:30 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 368D6AE057;
        Wed, 29 Apr 2020 15:11:30 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Apr 2020 15:11:30 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 04/13] net/smc: convert static link ID to dynamic references
Date:   Wed, 29 Apr 2020 17:10:40 +0200
Message-Id: <20200429151049.49979-5-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200429151049.49979-1-kgraul@linux.ibm.com>
References: <20200429151049.49979-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_07:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501 spamscore=0
 malwarescore=0 impostorscore=0 suspectscore=3 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290122
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As a preparation for the support of multiple links remove the usage of
a static link id (SMC_SINGLE_LINK) and allow dynamic link ids.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/af_smc.c   | 17 +++++-------
 net/smc/smc.h      |  1 +
 net/smc/smc_cdc.c  |  8 +++---
 net/smc/smc_clc.c  | 12 ++++-----
 net/smc/smc_core.c | 66 +++++++++++++++++++++++-----------------------
 net/smc/smc_core.h |  7 ++---
 net/smc/smc_ib.c   | 58 ++++++++++++++++++++--------------------
 net/smc/smc_ib.h   | 10 +++----
 net/smc/smc_llc.c  | 10 +++----
 net/smc/smc_tx.c   | 13 ++++-----
 10 files changed, 99 insertions(+), 103 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 6fd44bdb0fc3..6e4bad8c64a8 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -343,7 +343,7 @@ static int smc_reg_rmb(struct smc_link *link, struct smc_buf_desc *rmb_desc,
 {
 	if (!rmb_desc->wr_reg) {
 		/* register memory region for new rmb */
-		if (smc_wr_reg_send(link, rmb_desc->mr_rx[SMC_SINGLE_LINK])) {
+		if (smc_wr_reg_send(link, rmb_desc->mr_rx[link->link_idx])) {
 			rmb_desc->regerr = 1;
 			return -EFAULT;
 		}
@@ -362,12 +362,10 @@ static int smc_reg_rmb(struct smc_link *link, struct smc_buf_desc *rmb_desc,
 static int smc_clnt_conf_first_link(struct smc_sock *smc)
 {
 	struct net *net = sock_net(smc->clcsock->sk);
-	struct smc_link_group *lgr = smc->conn.lgr;
-	struct smc_link *link;
+	struct smc_link *link = smc->conn.lnk;
 	int rest;
 	int rc;
 
-	link = &lgr->lnk[SMC_SINGLE_LINK];
 	/* receive CONFIRM LINK request from server over RoCE fabric */
 	rest = wait_for_completion_interruptible_timeout(
 		&link->llc_confirm,
@@ -610,7 +608,7 @@ static int smc_connect_rdma(struct smc_sock *smc,
 		mutex_unlock(&smc_client_lgr_pending);
 		return reason_code;
 	}
-	link = &smc->conn.lgr->lnk[SMC_SINGLE_LINK];
+	link = smc->conn.lnk;
 
 	smc_conn_save_peer_info(smc, aclc);
 
@@ -1002,13 +1000,10 @@ void smc_close_non_accepted(struct sock *sk)
 static int smc_serv_conf_first_link(struct smc_sock *smc)
 {
 	struct net *net = sock_net(smc->clcsock->sk);
-	struct smc_link_group *lgr = smc->conn.lgr;
-	struct smc_link *link;
+	struct smc_link *link = smc->conn.lnk;
 	int rest;
 	int rc;
 
-	link = &lgr->lnk[SMC_SINGLE_LINK];
-
 	if (smc_reg_rmb(link, smc->conn.rmb_desc, false))
 		return SMC_CLC_DECL_ERR_REGRMB;
 
@@ -1194,7 +1189,7 @@ static int smc_listen_ism_init(struct smc_sock *new_smc,
 /* listen worker: register buffers */
 static int smc_listen_rdma_reg(struct smc_sock *new_smc, int local_contact)
 {
-	struct smc_link *link = &new_smc->conn.lgr->lnk[SMC_SINGLE_LINK];
+	struct smc_link *link = new_smc->conn.lnk;
 
 	if (local_contact != SMC_FIRST_CONTACT) {
 		if (smc_reg_rmb(link, new_smc->conn.rmb_desc, true))
@@ -1210,7 +1205,7 @@ static int smc_listen_rdma_finish(struct smc_sock *new_smc,
 				  struct smc_clc_msg_accept_confirm *cclc,
 				  int local_contact)
 {
-	struct smc_link *link = &new_smc->conn.lgr->lnk[SMC_SINGLE_LINK];
+	struct smc_link *link = new_smc->conn.lnk;
 	int reason_code = 0;
 
 	if (local_contact == SMC_FIRST_CONTACT)
diff --git a/net/smc/smc.h b/net/smc/smc.h
index be11ba41190f..1a084afa7372 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -121,6 +121,7 @@ enum smc_urg_state {
 struct smc_connection {
 	struct rb_node		alert_node;
 	struct smc_link_group	*lgr;		/* link group of connection */
+	struct smc_link		*lnk;		/* assigned SMC-R link */
 	u32			alert_token_local; /* unique conn. id */
 	u8			peer_rmbe_idx;	/* from tcp handshake */
 	int			peer_rmbe_size;	/* size of peer rx buffer */
diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index 164f1584861b..f64589d823aa 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -57,7 +57,7 @@ int smc_cdc_get_free_slot(struct smc_connection *conn,
 			  struct smc_rdma_wr **wr_rdma_buf,
 			  struct smc_cdc_tx_pend **pend)
 {
-	struct smc_link *link = &conn->lgr->lnk[SMC_SINGLE_LINK];
+	struct smc_link *link = conn->lnk;
 	int rc;
 
 	rc = smc_wr_tx_get_free_slot(link, smc_cdc_tx_handler, wr_buf,
@@ -91,12 +91,10 @@ int smc_cdc_msg_send(struct smc_connection *conn,
 		     struct smc_wr_buf *wr_buf,
 		     struct smc_cdc_tx_pend *pend)
 {
+	struct smc_link *link = conn->lnk;
 	union smc_host_cursor cfed;
-	struct smc_link *link;
 	int rc;
 
-	link = &conn->lgr->lnk[SMC_SINGLE_LINK];
-
 	smc_cdc_add_pending_send(conn, pend);
 
 	conn->tx_cdc_seq++;
@@ -165,7 +163,7 @@ static void smc_cdc_tx_dismisser(struct smc_wr_tx_pend_priv *tx_pend)
 
 void smc_cdc_tx_dismiss_slots(struct smc_connection *conn)
 {
-	struct smc_link *link = &conn->lgr->lnk[SMC_SINGLE_LINK];
+	struct smc_link *link = conn->lnk;
 
 	smc_wr_tx_dismiss_slots(link, SMC_CDC_MSG_TYPE,
 				smc_cdc_tx_filter, smc_cdc_tx_dismisser,
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index ea0068f0173c..d5627df24215 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -496,7 +496,7 @@ int smc_clc_send_confirm(struct smc_sock *smc)
 		       sizeof(SMCD_EYECATCHER));
 	} else {
 		/* SMC-R specific settings */
-		link = &conn->lgr->lnk[SMC_SINGLE_LINK];
+		link = conn->lnk;
 		memcpy(cclc.hdr.eyecatcher, SMC_EYECATCHER,
 		       sizeof(SMC_EYECATCHER));
 		cclc.hdr.path = SMC_TYPE_R;
@@ -508,13 +508,13 @@ int smc_clc_send_confirm(struct smc_sock *smc)
 		       ETH_ALEN);
 		hton24(cclc.qpn, link->roce_qp->qp_num);
 		cclc.rmb_rkey =
-			htonl(conn->rmb_desc->mr_rx[SMC_SINGLE_LINK]->rkey);
+			htonl(conn->rmb_desc->mr_rx[link->link_idx]->rkey);
 		cclc.rmbe_idx = 1; /* for now: 1 RMB = 1 RMBE */
 		cclc.rmbe_alert_token = htonl(conn->alert_token_local);
 		cclc.qp_mtu = min(link->path_mtu, link->peer_mtu);
 		cclc.rmbe_size = conn->rmbe_size_short;
 		cclc.rmb_dma_addr = cpu_to_be64((u64)sg_dma_address
-				(conn->rmb_desc->sgt[SMC_SINGLE_LINK].sgl));
+				(conn->rmb_desc->sgt[link->link_idx].sgl));
 		hton24(cclc.psn, link->psn_initial);
 		memcpy(cclc.smcr_trl.eyecatcher, SMC_EYECATCHER,
 		       sizeof(SMC_EYECATCHER));
@@ -572,7 +572,7 @@ int smc_clc_send_accept(struct smc_sock *new_smc, int srv_first_contact)
 		memcpy(aclc.hdr.eyecatcher, SMC_EYECATCHER,
 		       sizeof(SMC_EYECATCHER));
 		aclc.hdr.path = SMC_TYPE_R;
-		link = &conn->lgr->lnk[SMC_SINGLE_LINK];
+		link = conn->lnk;
 		memcpy(aclc.lcl.id_for_peer, local_systemid,
 		       sizeof(local_systemid));
 		memcpy(&aclc.lcl.gid, link->gid, SMC_GID_SIZE);
@@ -580,13 +580,13 @@ int smc_clc_send_accept(struct smc_sock *new_smc, int srv_first_contact)
 		       ETH_ALEN);
 		hton24(aclc.qpn, link->roce_qp->qp_num);
 		aclc.rmb_rkey =
-			htonl(conn->rmb_desc->mr_rx[SMC_SINGLE_LINK]->rkey);
+			htonl(conn->rmb_desc->mr_rx[link->link_idx]->rkey);
 		aclc.rmbe_idx = 1;		/* as long as 1 RMB = 1 RMBE */
 		aclc.rmbe_alert_token = htonl(conn->alert_token_local);
 		aclc.qp_mtu = link->path_mtu;
 		aclc.rmbe_size = conn->rmbe_size_short,
 		aclc.rmb_dma_addr = cpu_to_be64((u64)sg_dma_address
-				(conn->rmb_desc->sgt[SMC_SINGLE_LINK].sgl));
+				(conn->rmb_desc->sgt[link->link_idx].sgl));
 		hton24(aclc.psn, link->psn_initial);
 		memcpy(aclc.smcr_trl.eyecatcher, SMC_EYECATCHER,
 		       sizeof(SMC_EYECATCHER));
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index d233112ced2a..1d695093f205 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -131,6 +131,11 @@ static void smc_lgr_register_conn(struct smc_connection *conn)
 			conn->alert_token_local = 0;
 	}
 	smc_lgr_add_alert_token(conn);
+
+	/* assign the new connection to a link */
+	if (!conn->lgr->is_smcd)
+		conn->lnk = &conn->lgr->lnk[SMC_SINGLE_LINK];
+
 	conn->lgr->conns_num++;
 }
 
@@ -275,6 +280,7 @@ static int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 	atomic_inc(&ini->ib_dev->lnk_cnt);
 	lnk->state = SMC_LNK_ACTIVATING;
 	lnk->link_id = smcr_next_link_id(lgr);
+	lnk->lgr = lgr;
 	lnk->link_idx = link_idx;
 	lnk->smcibdev = ini->ib_dev;
 	lnk->ibport = ini->ib_port;
@@ -421,7 +427,7 @@ static void smc_buf_unuse(struct smc_connection *conn,
 			if (!lgr->is_smcd && !list_empty(&lgr->list)) {
 				/* unregister rmb with peer */
 				smc_llc_do_delete_rkey(
-						&lgr->lnk[SMC_SINGLE_LINK],
+						conn->lnk,
 						conn->rmb_desc);
 			}
 			conn->rmb_desc->used = 0;
@@ -479,16 +485,15 @@ static void smcr_buf_free(struct smc_link_group *lgr, bool is_rmb,
 	struct smc_link *lnk = &lgr->lnk[SMC_SINGLE_LINK];
 
 	if (is_rmb) {
-		if (buf_desc->mr_rx[SMC_SINGLE_LINK])
+		if (buf_desc->mr_rx[lnk->link_idx])
 			smc_ib_put_memory_region(
-					buf_desc->mr_rx[SMC_SINGLE_LINK]);
-		smc_ib_buf_unmap_sg(lnk->smcibdev, buf_desc,
-				    DMA_FROM_DEVICE);
+					buf_desc->mr_rx[lnk->link_idx]);
+		smc_ib_buf_unmap_sg(lnk, buf_desc, DMA_FROM_DEVICE);
 	} else {
-		smc_ib_buf_unmap_sg(lnk->smcibdev, buf_desc,
-				    DMA_TO_DEVICE);
+		smc_ib_buf_unmap_sg(lnk, buf_desc, DMA_TO_DEVICE);
 	}
-	sg_free_table(&buf_desc->sgt[SMC_SINGLE_LINK]);
+	sg_free_table(&buf_desc->sgt[lnk->link_idx]);
+
 	if (buf_desc->pages)
 		__free_pages(buf_desc->pages, buf_desc->order);
 	kfree(buf_desc);
@@ -1026,17 +1031,16 @@ static struct smc_buf_desc *smcr_new_buf_create(struct smc_link_group *lgr,
 
 	/* build the sg table from the pages */
 	lnk = &lgr->lnk[SMC_SINGLE_LINK];
-	rc = sg_alloc_table(&buf_desc->sgt[SMC_SINGLE_LINK], 1,
-			    GFP_KERNEL);
+	rc = sg_alloc_table(&buf_desc->sgt[lnk->link_idx], 1, GFP_KERNEL);
 	if (rc) {
 		smc_buf_free(lgr, is_rmb, buf_desc);
 		return ERR_PTR(rc);
 	}
-	sg_set_buf(buf_desc->sgt[SMC_SINGLE_LINK].sgl,
+	sg_set_buf(buf_desc->sgt[lnk->link_idx].sgl,
 		   buf_desc->cpu_addr, bufsize);
 
 	/* map sg table to DMA address */
-	rc = smc_ib_buf_map_sg(lnk->smcibdev, buf_desc,
+	rc = smc_ib_buf_map_sg(lnk, buf_desc,
 			       is_rmb ? DMA_FROM_DEVICE : DMA_TO_DEVICE);
 	/* SMC protocol depends on mapping to one DMA address only */
 	if (rc != 1)  {
@@ -1049,7 +1053,7 @@ static struct smc_buf_desc *smcr_new_buf_create(struct smc_link_group *lgr,
 		rc = smc_ib_get_memory_region(lnk->roce_pd,
 					      IB_ACCESS_REMOTE_WRITE |
 					      IB_ACCESS_LOCAL_WRITE,
-					      buf_desc);
+					      buf_desc, lnk->link_idx);
 		if (rc) {
 			smc_buf_free(lgr, is_rmb, buf_desc);
 			return ERR_PTR(rc);
@@ -1174,22 +1178,16 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 
 void smc_sndbuf_sync_sg_for_cpu(struct smc_connection *conn)
 {
-	struct smc_link_group *lgr = conn->lgr;
-
 	if (!conn->lgr || conn->lgr->is_smcd)
 		return;
-	smc_ib_sync_sg_for_cpu(lgr->lnk[SMC_SINGLE_LINK].smcibdev,
-			       conn->sndbuf_desc, DMA_TO_DEVICE);
+	smc_ib_sync_sg_for_cpu(conn->lnk, conn->sndbuf_desc, DMA_TO_DEVICE);
 }
 
 void smc_sndbuf_sync_sg_for_device(struct smc_connection *conn)
 {
-	struct smc_link_group *lgr = conn->lgr;
-
 	if (!conn->lgr || conn->lgr->is_smcd)
 		return;
-	smc_ib_sync_sg_for_device(lgr->lnk[SMC_SINGLE_LINK].smcibdev,
-				  conn->sndbuf_desc, DMA_TO_DEVICE);
+	smc_ib_sync_sg_for_device(conn->lnk, conn->sndbuf_desc, DMA_TO_DEVICE);
 }
 
 void smc_rmb_sync_sg_for_cpu(struct smc_connection *conn)
@@ -1198,7 +1196,7 @@ void smc_rmb_sync_sg_for_cpu(struct smc_connection *conn)
 
 	if (!conn->lgr || conn->lgr->is_smcd)
 		return;
-	smc_ib_sync_sg_for_cpu(lgr->lnk[SMC_SINGLE_LINK].smcibdev,
+	smc_ib_sync_sg_for_cpu(&lgr->lnk[SMC_SINGLE_LINK],
 			       conn->rmb_desc, DMA_FROM_DEVICE);
 }
 
@@ -1208,7 +1206,7 @@ void smc_rmb_sync_sg_for_device(struct smc_connection *conn)
 
 	if (!conn->lgr || conn->lgr->is_smcd)
 		return;
-	smc_ib_sync_sg_for_device(lgr->lnk[SMC_SINGLE_LINK].smcibdev,
+	smc_ib_sync_sg_for_device(&lgr->lnk[SMC_SINGLE_LINK],
 				  conn->rmb_desc, DMA_FROM_DEVICE);
 }
 
@@ -1245,15 +1243,16 @@ static inline int smc_rmb_reserve_rtoken_idx(struct smc_link_group *lgr)
 }
 
 /* add a new rtoken from peer */
-int smc_rtoken_add(struct smc_link_group *lgr, __be64 nw_vaddr, __be32 nw_rkey)
+int smc_rtoken_add(struct smc_link *lnk, __be64 nw_vaddr, __be32 nw_rkey)
 {
+	struct smc_link_group *lgr = smc_get_lgr(lnk);
 	u64 dma_addr = be64_to_cpu(nw_vaddr);
 	u32 rkey = ntohl(nw_rkey);
 	int i;
 
 	for (i = 0; i < SMC_RMBS_PER_LGR_MAX; i++) {
-		if ((lgr->rtokens[i][SMC_SINGLE_LINK].rkey == rkey) &&
-		    (lgr->rtokens[i][SMC_SINGLE_LINK].dma_addr == dma_addr) &&
+		if (lgr->rtokens[i][lnk->link_idx].rkey == rkey &&
+		    lgr->rtokens[i][lnk->link_idx].dma_addr == dma_addr &&
 		    test_bit(i, lgr->rtokens_used_mask)) {
 			/* already in list */
 			return i;
@@ -1262,22 +1261,23 @@ int smc_rtoken_add(struct smc_link_group *lgr, __be64 nw_vaddr, __be32 nw_rkey)
 	i = smc_rmb_reserve_rtoken_idx(lgr);
 	if (i < 0)
 		return i;
-	lgr->rtokens[i][SMC_SINGLE_LINK].rkey = rkey;
-	lgr->rtokens[i][SMC_SINGLE_LINK].dma_addr = dma_addr;
+	lgr->rtokens[i][lnk->link_idx].rkey = rkey;
+	lgr->rtokens[i][lnk->link_idx].dma_addr = dma_addr;
 	return i;
 }
 
 /* delete an rtoken */
-int smc_rtoken_delete(struct smc_link_group *lgr, __be32 nw_rkey)
+int smc_rtoken_delete(struct smc_link *lnk, __be32 nw_rkey)
 {
+	struct smc_link_group *lgr = smc_get_lgr(lnk);
 	u32 rkey = ntohl(nw_rkey);
 	int i;
 
 	for (i = 0; i < SMC_RMBS_PER_LGR_MAX; i++) {
-		if (lgr->rtokens[i][SMC_SINGLE_LINK].rkey == rkey &&
+		if (lgr->rtokens[i][lnk->link_idx].rkey == rkey &&
 		    test_bit(i, lgr->rtokens_used_mask)) {
-			lgr->rtokens[i][SMC_SINGLE_LINK].rkey = 0;
-			lgr->rtokens[i][SMC_SINGLE_LINK].dma_addr = 0;
+			lgr->rtokens[i][lnk->link_idx].rkey = 0;
+			lgr->rtokens[i][lnk->link_idx].dma_addr = 0;
 
 			clear_bit(i, lgr->rtokens_used_mask);
 			return 0;
@@ -1290,7 +1290,7 @@ int smc_rtoken_delete(struct smc_link_group *lgr, __be32 nw_rkey)
 int smc_rmb_rtoken_handling(struct smc_connection *conn,
 			    struct smc_clc_msg_accept_confirm *clc)
 {
-	conn->rtoken_idx = smc_rtoken_add(conn->lgr, clc->rmb_dma_addr,
+	conn->rtoken_idx = smc_rtoken_add(conn->lnk, clc->rmb_dma_addr,
 					  clc->rmb_rkey);
 	if (conn->rtoken_idx < 0)
 		return conn->rtoken_idx;
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index c459b0639bf3..c71c35a3596c 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -116,6 +116,7 @@ struct smc_link {
 	u8			peer_gid[SMC_GID_SIZE];	/* gid of peer*/
 	u8			link_id;	/* unique # within link group */
 	u8			link_idx;	/* index in lgr link array */
+	struct smc_link_group	*lgr;		/* parent link group */
 
 	enum smc_link_state	state;		/* state of link */
 	struct workqueue_struct *llc_wq;	/* single thread work queue */
@@ -303,8 +304,8 @@ int smc_buf_create(struct smc_sock *smc, bool is_smcd);
 int smc_uncompress_bufsize(u8 compressed);
 int smc_rmb_rtoken_handling(struct smc_connection *conn,
 			    struct smc_clc_msg_accept_confirm *clc);
-int smc_rtoken_add(struct smc_link_group *lgr, __be64 nw_vaddr, __be32 nw_rkey);
-int smc_rtoken_delete(struct smc_link_group *lgr, __be32 nw_rkey);
+int smc_rtoken_add(struct smc_link *lnk, __be64 nw_vaddr, __be32 nw_rkey);
+int smc_rtoken_delete(struct smc_link *lnk, __be32 nw_rkey);
 void smc_sndbuf_sync_sg_for_cpu(struct smc_connection *conn);
 void smc_sndbuf_sync_sg_for_device(struct smc_connection *conn);
 void smc_rmb_sync_sg_for_cpu(struct smc_connection *conn);
@@ -319,6 +320,6 @@ void smc_core_exit(void);
 
 static inline struct smc_link_group *smc_get_lgr(struct smc_link *link)
 {
-	return container_of(link, struct smc_link_group, lnk[SMC_SINGLE_LINK]);
+	return link->lgr;
 }
 #endif
diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 440f9e319a38..c090678a3e5a 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -389,15 +389,15 @@ void smc_ib_put_memory_region(struct ib_mr *mr)
 	ib_dereg_mr(mr);
 }
 
-static int smc_ib_map_mr_sg(struct smc_buf_desc *buf_slot)
+static int smc_ib_map_mr_sg(struct smc_buf_desc *buf_slot, u8 link_idx)
 {
 	unsigned int offset = 0;
 	int sg_num;
 
 	/* map the largest prefix of a dma mapped SG list */
-	sg_num = ib_map_mr_sg(buf_slot->mr_rx[SMC_SINGLE_LINK],
-			      buf_slot->sgt[SMC_SINGLE_LINK].sgl,
-			      buf_slot->sgt[SMC_SINGLE_LINK].orig_nents,
+	sg_num = ib_map_mr_sg(buf_slot->mr_rx[link_idx],
+			      buf_slot->sgt[link_idx].sgl,
+			      buf_slot->sgt[link_idx].orig_nents,
 			      &offset, PAGE_SIZE);
 
 	return sg_num;
@@ -405,29 +405,29 @@ static int smc_ib_map_mr_sg(struct smc_buf_desc *buf_slot)
 
 /* Allocate a memory region and map the dma mapped SG list of buf_slot */
 int smc_ib_get_memory_region(struct ib_pd *pd, int access_flags,
-			     struct smc_buf_desc *buf_slot)
+			     struct smc_buf_desc *buf_slot, u8 link_idx)
 {
-	if (buf_slot->mr_rx[SMC_SINGLE_LINK])
+	if (buf_slot->mr_rx[link_idx])
 		return 0; /* already done */
 
-	buf_slot->mr_rx[SMC_SINGLE_LINK] =
+	buf_slot->mr_rx[link_idx] =
 		ib_alloc_mr(pd, IB_MR_TYPE_MEM_REG, 1 << buf_slot->order);
-	if (IS_ERR(buf_slot->mr_rx[SMC_SINGLE_LINK])) {
+	if (IS_ERR(buf_slot->mr_rx[link_idx])) {
 		int rc;
 
-		rc = PTR_ERR(buf_slot->mr_rx[SMC_SINGLE_LINK]);
-		buf_slot->mr_rx[SMC_SINGLE_LINK] = NULL;
+		rc = PTR_ERR(buf_slot->mr_rx[link_idx]);
+		buf_slot->mr_rx[link_idx] = NULL;
 		return rc;
 	}
 
-	if (smc_ib_map_mr_sg(buf_slot) != 1)
+	if (smc_ib_map_mr_sg(buf_slot, link_idx) != 1)
 		return -EINVAL;
 
 	return 0;
 }
 
 /* synchronize buffer usage for cpu access */
-void smc_ib_sync_sg_for_cpu(struct smc_ib_device *smcibdev,
+void smc_ib_sync_sg_for_cpu(struct smc_link *lnk,
 			    struct smc_buf_desc *buf_slot,
 			    enum dma_data_direction data_direction)
 {
@@ -435,11 +435,11 @@ void smc_ib_sync_sg_for_cpu(struct smc_ib_device *smcibdev,
 	unsigned int i;
 
 	/* for now there is just one DMA address */
-	for_each_sg(buf_slot->sgt[SMC_SINGLE_LINK].sgl, sg,
-		    buf_slot->sgt[SMC_SINGLE_LINK].nents, i) {
+	for_each_sg(buf_slot->sgt[lnk->link_idx].sgl, sg,
+		    buf_slot->sgt[lnk->link_idx].nents, i) {
 		if (!sg_dma_len(sg))
 			break;
-		ib_dma_sync_single_for_cpu(smcibdev->ibdev,
+		ib_dma_sync_single_for_cpu(lnk->smcibdev->ibdev,
 					   sg_dma_address(sg),
 					   sg_dma_len(sg),
 					   data_direction);
@@ -447,7 +447,7 @@ void smc_ib_sync_sg_for_cpu(struct smc_ib_device *smcibdev,
 }
 
 /* synchronize buffer usage for device access */
-void smc_ib_sync_sg_for_device(struct smc_ib_device *smcibdev,
+void smc_ib_sync_sg_for_device(struct smc_link *lnk,
 			       struct smc_buf_desc *buf_slot,
 			       enum dma_data_direction data_direction)
 {
@@ -455,11 +455,11 @@ void smc_ib_sync_sg_for_device(struct smc_ib_device *smcibdev,
 	unsigned int i;
 
 	/* for now there is just one DMA address */
-	for_each_sg(buf_slot->sgt[SMC_SINGLE_LINK].sgl, sg,
-		    buf_slot->sgt[SMC_SINGLE_LINK].nents, i) {
+	for_each_sg(buf_slot->sgt[lnk->link_idx].sgl, sg,
+		    buf_slot->sgt[lnk->link_idx].nents, i) {
 		if (!sg_dma_len(sg))
 			break;
-		ib_dma_sync_single_for_device(smcibdev->ibdev,
+		ib_dma_sync_single_for_device(lnk->smcibdev->ibdev,
 					      sg_dma_address(sg),
 					      sg_dma_len(sg),
 					      data_direction);
@@ -467,15 +467,15 @@ void smc_ib_sync_sg_for_device(struct smc_ib_device *smcibdev,
 }
 
 /* Map a new TX or RX buffer SG-table to DMA */
-int smc_ib_buf_map_sg(struct smc_ib_device *smcibdev,
+int smc_ib_buf_map_sg(struct smc_link *lnk,
 		      struct smc_buf_desc *buf_slot,
 		      enum dma_data_direction data_direction)
 {
 	int mapped_nents;
 
-	mapped_nents = ib_dma_map_sg(smcibdev->ibdev,
-				     buf_slot->sgt[SMC_SINGLE_LINK].sgl,
-				     buf_slot->sgt[SMC_SINGLE_LINK].orig_nents,
+	mapped_nents = ib_dma_map_sg(lnk->smcibdev->ibdev,
+				     buf_slot->sgt[lnk->link_idx].sgl,
+				     buf_slot->sgt[lnk->link_idx].orig_nents,
 				     data_direction);
 	if (!mapped_nents)
 		return -ENOMEM;
@@ -483,18 +483,18 @@ int smc_ib_buf_map_sg(struct smc_ib_device *smcibdev,
 	return mapped_nents;
 }
 
-void smc_ib_buf_unmap_sg(struct smc_ib_device *smcibdev,
+void smc_ib_buf_unmap_sg(struct smc_link *lnk,
 			 struct smc_buf_desc *buf_slot,
 			 enum dma_data_direction data_direction)
 {
-	if (!buf_slot->sgt[SMC_SINGLE_LINK].sgl->dma_address)
+	if (!buf_slot->sgt[lnk->link_idx].sgl->dma_address)
 		return; /* already unmapped */
 
-	ib_dma_unmap_sg(smcibdev->ibdev,
-			buf_slot->sgt[SMC_SINGLE_LINK].sgl,
-			buf_slot->sgt[SMC_SINGLE_LINK].orig_nents,
+	ib_dma_unmap_sg(lnk->smcibdev->ibdev,
+			buf_slot->sgt[lnk->link_idx].sgl,
+			buf_slot->sgt[lnk->link_idx].orig_nents,
 			data_direction);
-	buf_slot->sgt[SMC_SINGLE_LINK].sgl->dma_address = 0;
+	buf_slot->sgt[lnk->link_idx].sgl->dma_address = 0;
 }
 
 long smc_ib_setup_per_ibdev(struct smc_ib_device *smcibdev)
diff --git a/net/smc/smc_ib.h b/net/smc/smc_ib.h
index 5c2b115d36da..e6a696ae15f3 100644
--- a/net/smc/smc_ib.h
+++ b/net/smc/smc_ib.h
@@ -59,10 +59,10 @@ struct smc_link;
 int smc_ib_register_client(void) __init;
 void smc_ib_unregister_client(void);
 bool smc_ib_port_active(struct smc_ib_device *smcibdev, u8 ibport);
-int smc_ib_buf_map_sg(struct smc_ib_device *smcibdev,
+int smc_ib_buf_map_sg(struct smc_link *lnk,
 		      struct smc_buf_desc *buf_slot,
 		      enum dma_data_direction data_direction);
-void smc_ib_buf_unmap_sg(struct smc_ib_device *smcibdev,
+void smc_ib_buf_unmap_sg(struct smc_link *lnk,
 			 struct smc_buf_desc *buf_slot,
 			 enum dma_data_direction data_direction);
 void smc_ib_dealloc_protection_domain(struct smc_link *lnk);
@@ -74,12 +74,12 @@ int smc_ib_modify_qp_rts(struct smc_link *lnk);
 int smc_ib_modify_qp_reset(struct smc_link *lnk);
 long smc_ib_setup_per_ibdev(struct smc_ib_device *smcibdev);
 int smc_ib_get_memory_region(struct ib_pd *pd, int access_flags,
-			     struct smc_buf_desc *buf_slot);
+			     struct smc_buf_desc *buf_slot, u8 link_idx);
 void smc_ib_put_memory_region(struct ib_mr *mr);
-void smc_ib_sync_sg_for_cpu(struct smc_ib_device *smcibdev,
+void smc_ib_sync_sg_for_cpu(struct smc_link *lnk,
 			    struct smc_buf_desc *buf_slot,
 			    enum dma_data_direction data_direction);
-void smc_ib_sync_sg_for_device(struct smc_ib_device *smcibdev,
+void smc_ib_sync_sg_for_device(struct smc_link *lnk,
 			       struct smc_buf_desc *buf_slot,
 			       enum dma_data_direction data_direction);
 int smc_ib_determine_gid(struct smc_ib_device *smcibdev, u8 ibport,
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 0e52aab53d97..34d0752ba6af 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -231,9 +231,9 @@ static int smc_llc_send_confirm_rkey(struct smc_link *link,
 	rkeyllc->hd.common.type = SMC_LLC_CONFIRM_RKEY;
 	rkeyllc->hd.length = sizeof(struct smc_llc_msg_confirm_rkey);
 	rkeyllc->rtoken[0].rmb_key =
-		htonl(rmb_desc->mr_rx[SMC_SINGLE_LINK]->rkey);
+		htonl(rmb_desc->mr_rx[link->link_idx]->rkey);
 	rkeyllc->rtoken[0].rmb_vaddr = cpu_to_be64(
-		(u64)sg_dma_address(rmb_desc->sgt[SMC_SINGLE_LINK].sgl));
+		(u64)sg_dma_address(rmb_desc->sgt[link->link_idx].sgl));
 	/* send llc message */
 	rc = smc_wr_tx_send(link, pend);
 	return rc;
@@ -256,7 +256,7 @@ static int smc_llc_send_delete_rkey(struct smc_link *link,
 	rkeyllc->hd.common.type = SMC_LLC_DELETE_RKEY;
 	rkeyllc->hd.length = sizeof(struct smc_llc_msg_delete_rkey);
 	rkeyllc->num_rkeys = 1;
-	rkeyllc->rkey[0] = htonl(rmb_desc->mr_rx[SMC_SINGLE_LINK]->rkey);
+	rkeyllc->rkey[0] = htonl(rmb_desc->mr_rx[link->link_idx]->rkey);
 	/* send llc message */
 	rc = smc_wr_tx_send(link, pend);
 	return rc;
@@ -501,7 +501,7 @@ static void smc_llc_rx_confirm_rkey(struct smc_link *link,
 					    SMC_LLC_FLAG_RKEY_NEG;
 		complete(&link->llc_confirm_rkey);
 	} else {
-		rc = smc_rtoken_add(smc_get_lgr(link),
+		rc = smc_rtoken_add(link,
 				    llc->rtoken[0].rmb_vaddr,
 				    llc->rtoken[0].rmb_key);
 
@@ -539,7 +539,7 @@ static void smc_llc_rx_delete_rkey(struct smc_link *link,
 	} else {
 		max = min_t(u8, llc->num_rkeys, SMC_LLC_DEL_RKEY_MAX);
 		for (i = 0; i < max; i++) {
-			if (smc_rtoken_delete(smc_get_lgr(link), llc->rkey[i]))
+			if (smc_rtoken_delete(link, llc->rkey[i]))
 				err_mask |= 1 << (SMC_LLC_DEL_RKEY_MAX - 1 - i);
 		}
 
diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 9f1ade86d70e..d74bfe6a90f1 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -269,19 +269,18 @@ static int smc_tx_rdma_write(struct smc_connection *conn, int peer_rmbe_offset,
 			     int num_sges, struct ib_rdma_wr *rdma_wr)
 {
 	struct smc_link_group *lgr = conn->lgr;
-	struct smc_link *link;
+	struct smc_link *link = conn->lnk;
 	int rc;
 
-	link = &lgr->lnk[SMC_SINGLE_LINK];
 	rdma_wr->wr.wr_id = smc_wr_tx_get_next_wr_id(link);
 	rdma_wr->wr.num_sge = num_sges;
 	rdma_wr->remote_addr =
-		lgr->rtokens[conn->rtoken_idx][SMC_SINGLE_LINK].dma_addr +
+		lgr->rtokens[conn->rtoken_idx][link->link_idx].dma_addr +
 		/* RMBE within RMB */
 		conn->tx_off +
 		/* offset within RMBE */
 		peer_rmbe_offset;
-	rdma_wr->rkey = lgr->rtokens[conn->rtoken_idx][SMC_SINGLE_LINK].rkey;
+	rdma_wr->rkey = lgr->rtokens[conn->rtoken_idx][link->link_idx].rkey;
 	rc = ib_post_send(link->roce_qp, &rdma_wr->wr, NULL);
 	if (rc)
 		smc_lgr_terminate_sched(lgr);
@@ -310,8 +309,10 @@ static int smcr_tx_rdma_writes(struct smc_connection *conn, size_t len,
 			       size_t dst_off, size_t dst_len,
 			       struct smc_rdma_wr *wr_rdma_buf)
 {
+	struct smc_link *link = conn->lnk;
+
 	dma_addr_t dma_addr =
-		sg_dma_address(conn->sndbuf_desc->sgt[SMC_SINGLE_LINK].sgl);
+		sg_dma_address(conn->sndbuf_desc->sgt[link->link_idx].sgl);
 	int src_len_sum = src_len, dst_len_sum = dst_len;
 	int sent_count = src_off;
 	int srcchunk, dstchunk;
@@ -507,7 +508,7 @@ static int smcr_tx_sndbuf_nonempty(struct smc_connection *conn)
 	if (!pflags->urg_data_present) {
 		rc = smc_tx_rdma_writes(conn, wr_rdma_buf);
 		if (rc) {
-			smc_wr_tx_put_slot(&conn->lgr->lnk[SMC_SINGLE_LINK],
+			smc_wr_tx_put_slot(conn->lnk,
 					   (struct smc_wr_tx_pend_priv *)pend);
 			goto out_unlock;
 		}
-- 
2.17.1

