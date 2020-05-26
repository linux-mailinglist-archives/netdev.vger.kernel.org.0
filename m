Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E571BE23F
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 17:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgD2PL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 11:11:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21076 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727077AbgD2PLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 11:11:42 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03TF1Hnc142915;
        Wed, 29 Apr 2020 11:11:37 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30q80ps2t5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 11:11:36 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03TFBE6u004957;
        Wed, 29 Apr 2020 15:11:35 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 30mcu8dwjn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 15:11:34 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03TFBVlG1311160
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Apr 2020 15:11:31 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF8EAAE045;
        Wed, 29 Apr 2020 15:11:30 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91ACBAE05A;
        Wed, 29 Apr 2020 15:11:30 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Apr 2020 15:11:30 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 05/13] net/smc: convert static link ID instances to support multiple links
Date:   Wed, 29 Apr 2020 17:10:41 +0200
Message-Id: <20200429151049.49979-6-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200429151049.49979-1-kgraul@linux.ibm.com>
References: <20200429151049.49979-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_07:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 impostorscore=0 phishscore=0
 bulkscore=0 spamscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=999
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
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
 net/smc/af_smc.c   |  54 +++++---
 net/smc/smc_clc.h  |   1 +
 net/smc/smc_core.c | 332 +++++++++++++++++++++++++++++++--------------
 net/smc/smc_core.h |  37 +++--
 net/smc/smc_llc.c  |   2 +
 5 files changed, 291 insertions(+), 135 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 6e4bad8c64a8..890dc6422f8c 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -338,28 +338,48 @@ static void smc_copy_sock_settings_to_smc(struct smc_sock *smc)
 }
 
 /* register a new rmb, send confirm_rkey msg to register with peer */
-static int smc_reg_rmb(struct smc_link *link, struct smc_buf_desc *rmb_desc,
-		       bool conf_rkey)
+static int smcr_link_reg_rmb(struct smc_link *link,
+			     struct smc_buf_desc *rmb_desc, bool conf_rkey)
 {
-	if (!rmb_desc->wr_reg) {
+	if (!rmb_desc->is_reg_mr[link->link_idx]) {
 		/* register memory region for new rmb */
 		if (smc_wr_reg_send(link, rmb_desc->mr_rx[link->link_idx])) {
-			rmb_desc->regerr = 1;
+			rmb_desc->is_reg_err = true;
 			return -EFAULT;
 		}
-		rmb_desc->wr_reg = 1;
+		rmb_desc->is_reg_mr[link->link_idx] = true;
 	}
 	if (!conf_rkey)
 		return 0;
+
 	/* exchange confirm_rkey msg with peer */
-	if (smc_llc_do_confirm_rkey(link, rmb_desc)) {
-		rmb_desc->regerr = 1;
-		return -EFAULT;
+	if (!rmb_desc->is_conf_rkey) {
+		if (smc_llc_do_confirm_rkey(link, rmb_desc)) {
+			rmb_desc->is_reg_err = true;
+			return -EFAULT;
+		}
+		rmb_desc->is_conf_rkey = true;
+	}
+	return 0;
+}
+
+/* register the new rmb on all links */
+static int smcr_lgr_reg_rmbs(struct smc_link_group *lgr,
+			     struct smc_buf_desc *rmb_desc)
+{
+	int i, rc;
+
+	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
+		if (lgr->lnk[i].state != SMC_LNK_ACTIVE)
+			continue;
+		rc = smcr_link_reg_rmb(&lgr->lnk[i], rmb_desc, true);
+		if (rc)
+			return rc;
 	}
 	return 0;
 }
 
-static int smc_clnt_conf_first_link(struct smc_sock *smc)
+static int smcr_clnt_conf_first_link(struct smc_sock *smc)
 {
 	struct net *net = sock_net(smc->clcsock->sk);
 	struct smc_link *link = smc->conn.lnk;
@@ -387,7 +407,7 @@ static int smc_clnt_conf_first_link(struct smc_sock *smc)
 
 	smc_wr_remember_qp_attr(link);
 
-	if (smc_reg_rmb(link, smc->conn.rmb_desc, false))
+	if (smcr_link_reg_rmb(link, smc->conn.rmb_desc, false))
 		return SMC_CLC_DECL_ERR_REGRMB;
 
 	/* send CONFIRM LINK response over RoCE fabric */
@@ -632,7 +652,7 @@ static int smc_connect_rdma(struct smc_sock *smc,
 			return smc_connect_abort(smc, SMC_CLC_DECL_ERR_RDYLNK,
 						 ini->cln_first_contact);
 	} else {
-		if (smc_reg_rmb(link, smc->conn.rmb_desc, true))
+		if (smcr_lgr_reg_rmbs(smc->conn.lgr, smc->conn.rmb_desc))
 			return smc_connect_abort(smc, SMC_CLC_DECL_ERR_REGRMB,
 						 ini->cln_first_contact);
 	}
@@ -647,7 +667,7 @@ static int smc_connect_rdma(struct smc_sock *smc,
 
 	if (ini->cln_first_contact == SMC_FIRST_CONTACT) {
 		/* QP confirmation over RoCE fabric */
-		reason_code = smc_clnt_conf_first_link(smc);
+		reason_code = smcr_clnt_conf_first_link(smc);
 		if (reason_code)
 			return smc_connect_abort(smc, reason_code,
 						 ini->cln_first_contact);
@@ -997,14 +1017,14 @@ void smc_close_non_accepted(struct sock *sk)
 	sock_put(sk); /* final sock_put */
 }
 
-static int smc_serv_conf_first_link(struct smc_sock *smc)
+static int smcr_serv_conf_first_link(struct smc_sock *smc)
 {
 	struct net *net = sock_net(smc->clcsock->sk);
 	struct smc_link *link = smc->conn.lnk;
 	int rest;
 	int rc;
 
-	if (smc_reg_rmb(link, smc->conn.rmb_desc, false))
+	if (smcr_link_reg_rmb(link, smc->conn.rmb_desc, false))
 		return SMC_CLC_DECL_ERR_REGRMB;
 
 	/* send CONFIRM LINK request to client over the RoCE fabric */
@@ -1189,10 +1209,10 @@ static int smc_listen_ism_init(struct smc_sock *new_smc,
 /* listen worker: register buffers */
 static int smc_listen_rdma_reg(struct smc_sock *new_smc, int local_contact)
 {
-	struct smc_link *link = new_smc->conn.lnk;
+	struct smc_connection *conn = &new_smc->conn;
 
 	if (local_contact != SMC_FIRST_CONTACT) {
-		if (smc_reg_rmb(link, new_smc->conn.rmb_desc, true))
+		if (smcr_lgr_reg_rmbs(conn->lgr, conn->rmb_desc))
 			return SMC_CLC_DECL_ERR_REGRMB;
 	}
 	smc_rmb_sync_sg_for_device(&new_smc->conn);
@@ -1222,7 +1242,7 @@ static int smc_listen_rdma_finish(struct smc_sock *new_smc,
 			goto decline;
 		}
 		/* QP confirmation over RoCE fabric */
-		reason_code = smc_serv_conf_first_link(new_smc);
+		reason_code = smcr_serv_conf_first_link(new_smc);
 		if (reason_code)
 			goto decline;
 	}
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index ca209272e5fa..4f2e150a2be1 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -44,6 +44,7 @@
 #define SMC_CLC_DECL_DIFFPREFIX	0x03070000  /* IP prefix / subnet mismatch    */
 #define SMC_CLC_DECL_GETVLANERR	0x03080000  /* err to get vlan id of ip device*/
 #define SMC_CLC_DECL_ISMVLANERR	0x03090000  /* err to reg vlan id on ism dev  */
+#define SMC_CLC_DECL_NOACTLINK	0x030a0000  /* no active smc-r link in lgr    */
 #define SMC_CLC_DECL_SYNCERR	0x04000000  /* synchronization error          */
 #define SMC_CLC_DECL_PEERDECL	0x05000000  /* peer declined during handshake */
 #define SMC_CLC_DECL_INTERR	0x09990000  /* internal error		      */
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 1d695093f205..5df3f8f41d19 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -116,7 +116,7 @@ static void smc_lgr_add_alert_token(struct smc_connection *conn)
  * Requires @conns_lock
  * Note that '0' is a reserved value and not assigned.
  */
-static void smc_lgr_register_conn(struct smc_connection *conn)
+static int smc_lgr_register_conn(struct smc_connection *conn)
 {
 	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
 	static atomic_t nexttoken = ATOMIC_INIT(0);
@@ -133,10 +133,22 @@ static void smc_lgr_register_conn(struct smc_connection *conn)
 	smc_lgr_add_alert_token(conn);
 
 	/* assign the new connection to a link */
-	if (!conn->lgr->is_smcd)
-		conn->lnk = &conn->lgr->lnk[SMC_SINGLE_LINK];
+	if (!conn->lgr->is_smcd) {
+		struct smc_link *lnk;
+		int i;
 
+		/* tbd - link balancing */
+		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
+			lnk = &conn->lgr->lnk[i];
+			if (lnk->state == SMC_LNK_ACTIVATING ||
+			    lnk->state == SMC_LNK_ACTIVE)
+				conn->lnk = lnk;
+		}
+		if (!conn->lnk)
+			return SMC_CLC_DECL_NOACTLINK;
+	}
 	conn->lgr->conns_num++;
+	return 0;
 }
 
 /* Unregister connection and reset the alert token of the given connection<
@@ -202,8 +214,8 @@ static void smc_lgr_free_work(struct work_struct *work)
 						  struct smc_link_group,
 						  free_work);
 	spinlock_t *lgr_lock;
-	struct smc_link *lnk;
 	bool conns;
+	int i;
 
 	smc_lgr_list_head(lgr, &lgr_lock);
 	spin_lock_bh(lgr_lock);
@@ -220,25 +232,38 @@ static void smc_lgr_free_work(struct work_struct *work)
 	}
 	list_del_init(&lgr->list); /* remove from smc_lgr_list */
 
-	lnk = &lgr->lnk[SMC_SINGLE_LINK];
 	if (!lgr->is_smcd && !lgr->terminating)	{
-		/* try to send del link msg, on error free lgr immediately */
-		if (lnk->state == SMC_LNK_ACTIVE &&
-		    !smcr_link_send_delete(lnk, true)) {
-			/* reschedule in case we never receive a response */
-			smc_lgr_schedule_free_work(lgr);
+		bool do_wait = false;
+
+		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
+			struct smc_link *lnk = &lgr->lnk[i];
+			/* try to send del link msg, on err free immediately */
+			if (lnk->state == SMC_LNK_ACTIVE &&
+			    !smcr_link_send_delete(lnk, true)) {
+				/* reschedule in case we never receive a resp */
+				smc_lgr_schedule_free_work(lgr);
+				do_wait = true;
+			}
+		}
+		if (do_wait) {
 			spin_unlock_bh(lgr_lock);
-			return;
+			return; /* wait for resp, see smc_llc_rx_delete_link */
 		}
 	}
 	lgr->freeing = 1; /* this instance does the freeing, no new schedule */
 	spin_unlock_bh(lgr_lock);
 	cancel_delayed_work(&lgr->free_work);
 
-	if (!lgr->is_smcd && lnk->state != SMC_LNK_INACTIVE)
-		smc_llc_link_inactive(lnk);
 	if (lgr->is_smcd && !lgr->terminating)
 		smc_ism_signal_shutdown(lgr);
+	if (!lgr->is_smcd) {
+		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
+			struct smc_link *lnk = &lgr->lnk[i];
+
+			if (lnk->state != SMC_LNK_INACTIVE)
+				smc_llc_link_inactive(lnk);
+		}
+	}
 	smc_lgr_free(lgr);
 }
 
@@ -417,29 +442,37 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 	return rc;
 }
 
+static void smcr_buf_unuse(struct smc_buf_desc *rmb_desc,
+			   struct smc_link *lnk)
+{
+	struct smc_link_group *lgr = lnk->lgr;
+
+	if (rmb_desc->is_conf_rkey && !list_empty(&lgr->list)) {
+		/* unregister rmb with peer */
+		smc_llc_do_delete_rkey(lnk, rmb_desc);
+		rmb_desc->is_conf_rkey = false;
+	}
+	if (rmb_desc->is_reg_err) {
+		/* buf registration failed, reuse not possible */
+		write_lock_bh(&lgr->rmbs_lock);
+		list_del(&rmb_desc->list);
+		write_unlock_bh(&lgr->rmbs_lock);
+
+		smc_buf_free(lgr, true, rmb_desc);
+	} else {
+		rmb_desc->used = 0;
+	}
+}
+
 static void smc_buf_unuse(struct smc_connection *conn,
 			  struct smc_link_group *lgr)
 {
 	if (conn->sndbuf_desc)
 		conn->sndbuf_desc->used = 0;
-	if (conn->rmb_desc) {
-		if (!conn->rmb_desc->regerr) {
-			if (!lgr->is_smcd && !list_empty(&lgr->list)) {
-				/* unregister rmb with peer */
-				smc_llc_do_delete_rkey(
-						conn->lnk,
-						conn->rmb_desc);
-			}
-			conn->rmb_desc->used = 0;
-		} else {
-			/* buf registration failed, reuse not possible */
-			write_lock_bh(&lgr->rmbs_lock);
-			list_del(&conn->rmb_desc->list);
-			write_unlock_bh(&lgr->rmbs_lock);
-
-			smc_buf_free(lgr, true, conn->rmb_desc);
-		}
-	}
+	if (conn->rmb_desc && lgr->is_smcd)
+		conn->rmb_desc->used = 0;
+	else if (conn->rmb_desc)
+		smcr_buf_unuse(conn->rmb_desc, conn->lnk);
 }
 
 /* remove a finished connection from its link group */
@@ -467,6 +500,8 @@ void smc_conn_free(struct smc_connection *conn)
 
 static void smcr_link_clear(struct smc_link *lnk)
 {
+	if (lnk->peer_qpn == 0)
+		return;
 	lnk->peer_qpn = 0;
 	smc_llc_link_clear(lnk);
 	smc_ib_modify_qp_reset(lnk);
@@ -482,17 +517,23 @@ static void smcr_link_clear(struct smc_link *lnk)
 static void smcr_buf_free(struct smc_link_group *lgr, bool is_rmb,
 			  struct smc_buf_desc *buf_desc)
 {
-	struct smc_link *lnk = &lgr->lnk[SMC_SINGLE_LINK];
+	struct smc_link *lnk;
+	int i;
 
-	if (is_rmb) {
-		if (buf_desc->mr_rx[lnk->link_idx])
-			smc_ib_put_memory_region(
-					buf_desc->mr_rx[lnk->link_idx]);
-		smc_ib_buf_unmap_sg(lnk, buf_desc, DMA_FROM_DEVICE);
-	} else {
-		smc_ib_buf_unmap_sg(lnk, buf_desc, DMA_TO_DEVICE);
+	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
+		lnk = &lgr->lnk[i];
+		if (!buf_desc->is_map_ib[lnk->link_idx])
+			continue;
+		if (is_rmb) {
+			if (buf_desc->mr_rx[lnk->link_idx])
+				smc_ib_put_memory_region(
+						buf_desc->mr_rx[lnk->link_idx]);
+			smc_ib_buf_unmap_sg(lnk, buf_desc, DMA_FROM_DEVICE);
+		} else {
+			smc_ib_buf_unmap_sg(lnk, buf_desc, DMA_TO_DEVICE);
+		}
+		sg_free_table(&buf_desc->sgt[lnk->link_idx]);
 	}
-	sg_free_table(&buf_desc->sgt[lnk->link_idx]);
 
 	if (buf_desc->pages)
 		__free_pages(buf_desc->pages, buf_desc->order);
@@ -551,6 +592,8 @@ static void smc_lgr_free_bufs(struct smc_link_group *lgr)
 /* remove a link group */
 static void smc_lgr_free(struct smc_link_group *lgr)
 {
+	int i;
+
 	smc_lgr_free_bufs(lgr);
 	if (lgr->is_smcd) {
 		if (!lgr->terminating) {
@@ -560,7 +603,11 @@ static void smc_lgr_free(struct smc_link_group *lgr)
 		if (!atomic_dec_return(&lgr->smcd->lgr_cnt))
 			wake_up(&lgr->smcd->lgrs_deleted);
 	} else {
-		smcr_link_clear(&lgr->lnk[SMC_SINGLE_LINK]);
+		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
+			if (lgr->lnk[i].state == SMC_LNK_INACTIVE)
+				continue;
+			smcr_link_clear(&lgr->lnk[i]);
+		}
 		if (!atomic_dec_return(&lgr_cnt))
 			wake_up(&lgrs_deleted);
 	}
@@ -628,16 +675,20 @@ static void smc_conn_kill(struct smc_connection *conn, bool soft)
 
 static void smc_lgr_cleanup(struct smc_link_group *lgr)
 {
+	int i;
+
 	if (lgr->is_smcd) {
 		smc_ism_signal_shutdown(lgr);
 		smcd_unregister_all_dmbs(lgr);
 		smc_ism_put_vlan(lgr->smcd, lgr->vlan_id);
 		put_device(&lgr->smcd->dev);
 	} else {
-		struct smc_link *lnk = &lgr->lnk[SMC_SINGLE_LINK];
+		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
+			struct smc_link *lnk = &lgr->lnk[i];
 
-		if (lnk->state != SMC_LNK_INACTIVE)
-			smc_llc_link_inactive(lnk);
+			if (lnk->state != SMC_LNK_INACTIVE)
+				smc_llc_link_inactive(lnk);
+		}
 	}
 }
 
@@ -650,6 +701,7 @@ static void __smc_lgr_terminate(struct smc_link_group *lgr, bool soft)
 	struct smc_connection *conn;
 	struct smc_sock *smc;
 	struct rb_node *node;
+	int i;
 
 	if (lgr->terminating)
 		return;	/* lgr already terminating */
@@ -657,7 +709,8 @@ static void __smc_lgr_terminate(struct smc_link_group *lgr, bool soft)
 		cancel_delayed_work_sync(&lgr->free_work);
 	lgr->terminating = 1;
 	if (!lgr->is_smcd)
-		smc_llc_link_inactive(&lgr->lnk[SMC_SINGLE_LINK]);
+		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++)
+			smc_llc_link_inactive(&lgr->lnk[i]);
 
 	/* kill remaining link group connections */
 	read_lock_bh(&lgr->conns_lock);
@@ -703,14 +756,22 @@ void smc_port_terminate(struct smc_ib_device *smcibdev, u8 ibport)
 {
 	struct smc_link_group *lgr, *l;
 	LIST_HEAD(lgr_free_list);
+	int i;
 
 	spin_lock_bh(&smc_lgr_list.lock);
 	list_for_each_entry_safe(lgr, l, &smc_lgr_list.list, list) {
-		if (!lgr->is_smcd &&
-		    lgr->lnk[SMC_SINGLE_LINK].smcibdev == smcibdev &&
-		    lgr->lnk[SMC_SINGLE_LINK].ibport == ibport) {
-			list_move(&lgr->list, &lgr_free_list);
-			lgr->freeing = 1;
+		if (lgr->is_smcd)
+			continue;
+		/* tbd - terminate only when no more links are active */
+		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
+			if (lgr->lnk[i].state == SMC_LNK_INACTIVE ||
+			    lgr->lnk[i].state == SMC_LNK_DELETING)
+				continue;
+			if (lgr->lnk[i].smcibdev == smcibdev &&
+			    lgr->lnk[i].ibport == ibport) {
+				list_move(&lgr->list, &lgr_free_list);
+				lgr->freeing = 1;
+			}
 		}
 	}
 	spin_unlock_bh(&smc_lgr_list.lock);
@@ -775,6 +836,7 @@ void smc_smcr_terminate_all(struct smc_ib_device *smcibdev)
 {
 	struct smc_link_group *lgr, *lg;
 	LIST_HEAD(lgr_free_list);
+	int i;
 
 	spin_lock_bh(&smc_lgr_list.lock);
 	if (!smcibdev) {
@@ -783,9 +845,12 @@ void smc_smcr_terminate_all(struct smc_ib_device *smcibdev)
 			lgr->freeing = 1;
 	} else {
 		list_for_each_entry_safe(lgr, lg, &smc_lgr_list.list, list) {
-			if (lgr->lnk[SMC_SINGLE_LINK].smcibdev == smcibdev) {
-				list_move(&lgr->list, &lgr_free_list);
-				lgr->freeing = 1;
+			for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
+				if (lgr->lnk[i].smcibdev == smcibdev) {
+					list_move(&lgr->list, &lgr_free_list);
+					lgr->freeing = 1;
+					break;
+				}
 			}
 		}
 	}
@@ -857,15 +922,21 @@ static bool smcr_lgr_match(struct smc_link_group *lgr,
 			   struct smc_clc_msg_local *lcl,
 			   enum smc_lgr_role role, u32 clcqpn)
 {
-	return !memcmp(lgr->peer_systemid, lcl->id_for_peer,
-		       SMC_SYSTEMID_LEN) &&
-		!memcmp(lgr->lnk[SMC_SINGLE_LINK].peer_gid, &lcl->gid,
-			SMC_GID_SIZE) &&
-		!memcmp(lgr->lnk[SMC_SINGLE_LINK].peer_mac, lcl->mac,
-			sizeof(lcl->mac)) &&
-		lgr->role == role &&
-		(lgr->role == SMC_SERV ||
-		 lgr->lnk[SMC_SINGLE_LINK].peer_qpn == clcqpn);
+	int i;
+
+	if (memcmp(lgr->peer_systemid, lcl->id_for_peer, SMC_SYSTEMID_LEN) ||
+	    lgr->role != role)
+		return false;
+
+	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
+		if (lgr->lnk[i].state != SMC_LNK_ACTIVE)
+			continue;
+		if ((lgr->role == SMC_SERV || lgr->lnk[i].peer_qpn == clcqpn) &&
+		    !memcmp(lgr->lnk[i].peer_gid, &lcl->gid, SMC_GID_SIZE) &&
+		    !memcmp(lgr->lnk[i].peer_mac, lcl->mac, sizeof(lcl->mac)))
+			return true;
+	}
+	return false;
 }
 
 static bool smcd_lgr_match(struct smc_link_group *lgr,
@@ -906,15 +977,17 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 			/* link group found */
 			ini->cln_first_contact = SMC_REUSE_CONTACT;
 			conn->lgr = lgr;
-			smc_lgr_register_conn(conn); /* add smc conn to lgr */
-			if (delayed_work_pending(&lgr->free_work))
-				cancel_delayed_work(&lgr->free_work);
+			rc = smc_lgr_register_conn(conn); /* add conn to lgr */
 			write_unlock_bh(&lgr->conns_lock);
+			if (!rc && delayed_work_pending(&lgr->free_work))
+				cancel_delayed_work(&lgr->free_work);
 			break;
 		}
 		write_unlock_bh(&lgr->conns_lock);
 	}
 	spin_unlock_bh(lgr_lock);
+	if (rc)
+		return rc;
 
 	if (role == SMC_CLNT && !ini->srv_first_contact &&
 	    ini->cln_first_contact == SMC_FIRST_CONTACT) {
@@ -932,8 +1005,10 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 			goto out;
 		lgr = conn->lgr;
 		write_lock_bh(&lgr->conns_lock);
-		smc_lgr_register_conn(conn); /* add smc conn to lgr */
+		rc = smc_lgr_register_conn(conn); /* add smc conn to lgr */
 		write_unlock_bh(&lgr->conns_lock);
+		if (rc)
+			goto out;
 	}
 	conn->local_tx_ctrl.common.type = SMC_CDC_MSG_TYPE;
 	conn->local_tx_ctrl.len = SMC_WR_TX_SIZE;
@@ -1006,12 +1081,55 @@ static inline int smc_rmb_wnd_update_limit(int rmbe_size)
 	return min_t(int, rmbe_size / 10, SOCK_MIN_SNDBUF / 2);
 }
 
+/* map an rmb buf to a link */
+static int smcr_buf_map_link(struct smc_buf_desc *buf_desc, bool is_rmb,
+			     struct smc_link *lnk)
+{
+	int rc;
+
+	if (buf_desc->is_map_ib[lnk->link_idx])
+		return 0;
+
+	rc = sg_alloc_table(&buf_desc->sgt[lnk->link_idx], 1, GFP_KERNEL);
+	if (rc)
+		return rc;
+	sg_set_buf(buf_desc->sgt[lnk->link_idx].sgl,
+		   buf_desc->cpu_addr, buf_desc->len);
+
+	/* map sg table to DMA address */
+	rc = smc_ib_buf_map_sg(lnk, buf_desc,
+			       is_rmb ? DMA_FROM_DEVICE : DMA_TO_DEVICE);
+	/* SMC protocol depends on mapping to one DMA address only */
+	if (rc != 1) {
+		rc = -EAGAIN;
+		goto free_table;
+	}
+
+	/* create a new memory region for the RMB */
+	if (is_rmb) {
+		rc = smc_ib_get_memory_region(lnk->roce_pd,
+					      IB_ACCESS_REMOTE_WRITE |
+					      IB_ACCESS_LOCAL_WRITE,
+					      buf_desc, lnk->link_idx);
+		if (rc)
+			goto buf_unmap;
+		smc_ib_sync_sg_for_device(lnk, buf_desc, DMA_FROM_DEVICE);
+	}
+	buf_desc->is_map_ib[lnk->link_idx] = true;
+	return 0;
+
+buf_unmap:
+	smc_ib_buf_unmap_sg(lnk, buf_desc,
+			    is_rmb ? DMA_FROM_DEVICE : DMA_TO_DEVICE);
+free_table:
+	sg_free_table(&buf_desc->sgt[lnk->link_idx]);
+	return rc;
+}
+
 static struct smc_buf_desc *smcr_new_buf_create(struct smc_link_group *lgr,
 						bool is_rmb, int bufsize)
 {
 	struct smc_buf_desc *buf_desc;
-	struct smc_link *lnk;
-	int rc;
 
 	/* try to alloc a new buffer */
 	buf_desc = kzalloc(sizeof(*buf_desc), GFP_KERNEL);
@@ -1028,40 +1146,32 @@ static struct smc_buf_desc *smcr_new_buf_create(struct smc_link_group *lgr,
 		return ERR_PTR(-EAGAIN);
 	}
 	buf_desc->cpu_addr = (void *)page_address(buf_desc->pages);
+	buf_desc->len = bufsize;
+	return buf_desc;
+}
 
-	/* build the sg table from the pages */
-	lnk = &lgr->lnk[SMC_SINGLE_LINK];
-	rc = sg_alloc_table(&buf_desc->sgt[lnk->link_idx], 1, GFP_KERNEL);
-	if (rc) {
-		smc_buf_free(lgr, is_rmb, buf_desc);
-		return ERR_PTR(rc);
-	}
-	sg_set_buf(buf_desc->sgt[lnk->link_idx].sgl,
-		   buf_desc->cpu_addr, bufsize);
+/* map buf_desc on all usable links,
+ * unused buffers stay mapped as long as the link is up
+ */
+static int smcr_buf_map_usable_links(struct smc_link_group *lgr,
+				     struct smc_buf_desc *buf_desc, bool is_rmb)
+{
+	int i, rc = 0;
 
-	/* map sg table to DMA address */
-	rc = smc_ib_buf_map_sg(lnk, buf_desc,
-			       is_rmb ? DMA_FROM_DEVICE : DMA_TO_DEVICE);
-	/* SMC protocol depends on mapping to one DMA address only */
-	if (rc != 1)  {
-		smc_buf_free(lgr, is_rmb, buf_desc);
-		return ERR_PTR(-EAGAIN);
-	}
+	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
+		struct smc_link *lnk = &lgr->lnk[i];
 
-	/* create a new memory region for the RMB */
-	if (is_rmb) {
-		rc = smc_ib_get_memory_region(lnk->roce_pd,
-					      IB_ACCESS_REMOTE_WRITE |
-					      IB_ACCESS_LOCAL_WRITE,
-					      buf_desc, lnk->link_idx);
-		if (rc) {
-			smc_buf_free(lgr, is_rmb, buf_desc);
-			return ERR_PTR(rc);
+		if (lnk->state != SMC_LNK_ACTIVE &&
+		    lnk->state != SMC_LNK_ACTIVATING)
+			continue;
+		if (smcr_buf_map_link(buf_desc, is_rmb, lnk)) {
+			smcr_buf_unuse(buf_desc, lnk);
+			rc = -ENOMEM;
+			goto out;
 		}
 	}
-
-	buf_desc->len = bufsize;
-	return buf_desc;
+out:
+	return rc;
 }
 
 #define SMCD_DMBE_SIZES		7 /* 0 -> 16KB, 1 -> 32KB, .. 6 -> 1MB */
@@ -1159,6 +1269,12 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 	if (IS_ERR(buf_desc))
 		return -ENOMEM;
 
+	if (!is_smcd) {
+		if (smcr_buf_map_usable_links(lgr, buf_desc, is_rmb)) {
+			return -ENOMEM;
+		}
+	}
+
 	if (is_rmb) {
 		conn->rmb_desc = buf_desc;
 		conn->rmbe_size_short = bufsize_short;
@@ -1192,22 +1308,32 @@ void smc_sndbuf_sync_sg_for_device(struct smc_connection *conn)
 
 void smc_rmb_sync_sg_for_cpu(struct smc_connection *conn)
 {
-	struct smc_link_group *lgr = conn->lgr;
+	int i;
 
 	if (!conn->lgr || conn->lgr->is_smcd)
 		return;
-	smc_ib_sync_sg_for_cpu(&lgr->lnk[SMC_SINGLE_LINK],
-			       conn->rmb_desc, DMA_FROM_DEVICE);
+	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
+		if (conn->lgr->lnk[i].state != SMC_LNK_ACTIVE &&
+		    conn->lgr->lnk[i].state != SMC_LNK_ACTIVATING)
+			continue;
+		smc_ib_sync_sg_for_cpu(&conn->lgr->lnk[i], conn->rmb_desc,
+				       DMA_FROM_DEVICE);
+	}
 }
 
 void smc_rmb_sync_sg_for_device(struct smc_connection *conn)
 {
-	struct smc_link_group *lgr = conn->lgr;
+	int i;
 
 	if (!conn->lgr || conn->lgr->is_smcd)
 		return;
-	smc_ib_sync_sg_for_device(&lgr->lnk[SMC_SINGLE_LINK],
-				  conn->rmb_desc, DMA_FROM_DEVICE);
+	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
+		if (conn->lgr->lnk[i].state != SMC_LNK_ACTIVE &&
+		    conn->lgr->lnk[i].state != SMC_LNK_ACTIVATING)
+			continue;
+		smc_ib_sync_sg_for_device(&conn->lgr->lnk[i], conn->rmb_desc,
+					  DMA_FROM_DEVICE);
+	}
 }
 
 /* create the send and receive buffer for an SMC socket;
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index c71c35a3596c..66753ba23bc6 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -152,25 +152,32 @@ struct smc_buf_desc {
 	struct page		*pages;
 	int			len;		/* length of buffer */
 	u32			used;		/* currently used / unused */
-	u8			wr_reg	: 1;	/* mem region registered */
-	u8			regerr	: 1;	/* err during registration */
 	union {
 		struct { /* SMC-R */
-			struct sg_table		sgt[SMC_LINKS_PER_LGR_MAX];
-						/* virtual buffer */
-			struct ib_mr		*mr_rx[SMC_LINKS_PER_LGR_MAX];
-						/* for rmb only: memory region
-						 * incl. rkey provided to peer
-						 */
-			u32			order;	/* allocation order */
+			struct sg_table	sgt[SMC_LINKS_PER_LGR_MAX];
+					/* virtual buffer */
+			struct ib_mr	*mr_rx[SMC_LINKS_PER_LGR_MAX];
+					/* for rmb only: memory region
+					 * incl. rkey provided to peer
+					 */
+			u32		order;	/* allocation order */
+
+			u8		is_conf_rkey;
+					/* confirm_rkey done */
+			u8		is_reg_mr[SMC_LINKS_PER_LGR_MAX];
+					/* mem region registered */
+			u8		is_map_ib[SMC_LINKS_PER_LGR_MAX];
+					/* mem region mapped to lnk */
+			u8		is_reg_err;
+					/* buffer registration err */
 		};
 		struct { /* SMC-D */
-			unsigned short		sba_idx;
-						/* SBA index number */
-			u64			token;
-						/* DMB token number */
-			dma_addr_t		dma_addr;
-						/* DMA address */
+			unsigned short	sba_idx;
+					/* SBA index number */
+			u64		token;
+					/* DMB token number */
+			dma_addr_t	dma_addr;
+					/* DMA address */
 		};
 	};
 };
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 34d0752ba6af..903ae068da3a 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -662,6 +662,8 @@ void smc_llc_link_deleting(struct smc_link *link)
 /* called in tasklet context */
 void smc_llc_link_inactive(struct smc_link *link)
 {
+	if (link->state == SMC_LNK_INACTIVE)
+		return;
 	link->state = SMC_LNK_INACTIVE;
 	cancel_delayed_work(&link->llc_testlink_wrk);
 	smc_wr_wakeup_reg_wait(link);
-- 
2.17.1

