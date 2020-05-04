Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270441C3934
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 14:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbgEDMTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 08:19:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3686 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728592AbgEDMTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 08:19:16 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 044CAQ9j065489;
        Mon, 4 May 2020 08:19:13 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30s2g1m30r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 May 2020 08:19:12 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 044C9pp3005720;
        Mon, 4 May 2020 12:19:11 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 30s0g5hwnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 May 2020 12:19:10 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 044CJ7nH64094458
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 May 2020 12:19:08 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D1884A4051;
        Mon,  4 May 2020 12:19:07 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8FE84A4040;
        Mon,  4 May 2020 12:19:07 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 May 2020 12:19:07 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 02/12] net/smc: switch connections to alternate link
Date:   Mon,  4 May 2020 14:18:38 +0200
Message-Id: <20200504121848.46585-3-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200504121848.46585-1-kgraul@linux.ibm.com>
References: <20200504121848.46585-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-04_06:2020-05-04,2020-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 suspectscore=4 bulkscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add smc_switch_conns() to switch all connections from a link that is
going down. Find an other link to switch the connections to, and
switch each connection to the new link. smc_switch_cursor() updates the
cursors of a connection to the state of the last successfully sent CDC
message. When there is no link to switch to, terminate the link group.
Call smc_switch_conns() when a link is going down.
And with the possibility that links of connections can switch adapt CDC
and TX functions to detect and handle link switches.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_cdc.c  |  18 ++++++-
 net/smc/smc_cdc.h  |   1 +
 net/smc/smc_core.c | 132 ++++++++++++++++++++++++++++++++++++++++++++-
 net/smc/smc_core.h |   2 +
 net/smc/smc_llc.c  |   6 +--
 net/smc/smc_tx.c   |  12 ++++-
 6 files changed, 162 insertions(+), 9 deletions(-)

diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index c5e33296e55c..3ca986066f32 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -56,11 +56,11 @@ static void smc_cdc_tx_handler(struct smc_wr_tx_pend_priv *pnd_snd,
 }
 
 int smc_cdc_get_free_slot(struct smc_connection *conn,
+			  struct smc_link *link,
 			  struct smc_wr_buf **wr_buf,
 			  struct smc_rdma_wr **wr_rdma_buf,
 			  struct smc_cdc_tx_pend **pend)
 {
-	struct smc_link *link = conn->lnk;
 	int rc;
 
 	rc = smc_wr_tx_get_free_slot(link, smc_cdc_tx_handler, wr_buf,
@@ -119,13 +119,27 @@ static int smcr_cdc_get_slot_and_msg_send(struct smc_connection *conn)
 {
 	struct smc_cdc_tx_pend *pend;
 	struct smc_wr_buf *wr_buf;
+	struct smc_link *link;
+	bool again = false;
 	int rc;
 
-	rc = smc_cdc_get_free_slot(conn, &wr_buf, NULL, &pend);
+again:
+	link = conn->lnk;
+	rc = smc_cdc_get_free_slot(conn, link, &wr_buf, NULL, &pend);
 	if (rc)
 		return rc;
 
 	spin_lock_bh(&conn->send_lock);
+	if (link != conn->lnk) {
+		/* link of connection changed, try again one time*/
+		spin_unlock_bh(&conn->send_lock);
+		smc_wr_tx_put_slot(link,
+				   (struct smc_wr_tx_pend_priv *)pend);
+		if (again)
+			return -ENOLINK;
+		again = true;
+		goto again;
+	}
 	rc = smc_cdc_msg_send(conn, wr_buf, pend);
 	spin_unlock_bh(&conn->send_lock);
 	return rc;
diff --git a/net/smc/smc_cdc.h b/net/smc/smc_cdc.h
index 861dc24c588c..42246b4bdcc9 100644
--- a/net/smc/smc_cdc.h
+++ b/net/smc/smc_cdc.h
@@ -304,6 +304,7 @@ struct smc_cdc_tx_pend {
 };
 
 int smc_cdc_get_free_slot(struct smc_connection *conn,
+			  struct smc_link *link,
 			  struct smc_wr_buf **wr_buf,
 			  struct smc_rdma_wr **wr_rdma_buf,
 			  struct smc_cdc_tx_pend **pend);
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 32a6cadc5c1f..21bc1ec07e99 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -432,6 +432,135 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 	return rc;
 }
 
+static int smc_write_space(struct smc_connection *conn)
+{
+	int buffer_len = conn->peer_rmbe_size;
+	union smc_host_cursor prod;
+	union smc_host_cursor cons;
+	int space;
+
+	smc_curs_copy(&prod, &conn->local_tx_ctrl.prod, conn);
+	smc_curs_copy(&cons, &conn->local_rx_ctrl.cons, conn);
+	/* determine rx_buf space */
+	space = buffer_len - smc_curs_diff(buffer_len, &cons, &prod);
+	return space;
+}
+
+static int smc_switch_cursor(struct smc_sock *smc)
+{
+	struct smc_connection *conn = &smc->conn;
+	union smc_host_cursor cons, fin;
+	int rc = 0;
+	int diff;
+
+	smc_curs_copy(&conn->tx_curs_sent, &conn->tx_curs_fin, conn);
+	smc_curs_copy(&fin, &conn->local_tx_ctrl_fin, conn);
+	/* set prod cursor to old state, enforce tx_rdma_writes() */
+	smc_curs_copy(&conn->local_tx_ctrl.prod, &fin, conn);
+	smc_curs_copy(&cons, &conn->local_rx_ctrl.cons, conn);
+
+	if (smc_curs_comp(conn->peer_rmbe_size, &cons, &fin) < 0) {
+		/* cons cursor advanced more than fin, and prod was set
+		 * fin above, so now prod is smaller than cons. Fix that.
+		 */
+		diff = smc_curs_diff(conn->peer_rmbe_size, &fin, &cons);
+		smc_curs_add(conn->sndbuf_desc->len,
+			     &conn->tx_curs_sent, diff);
+		smc_curs_add(conn->sndbuf_desc->len,
+			     &conn->tx_curs_fin, diff);
+
+		smp_mb__before_atomic();
+		atomic_add(diff, &conn->sndbuf_space);
+		smp_mb__after_atomic();
+
+		smc_curs_add(conn->peer_rmbe_size,
+			     &conn->local_tx_ctrl.prod, diff);
+		smc_curs_add(conn->peer_rmbe_size,
+			     &conn->local_tx_ctrl_fin, diff);
+	}
+	/* recalculate, value is used by tx_rdma_writes() */
+	atomic_set(&smc->conn.peer_rmbe_space, smc_write_space(conn));
+
+	if (smc->sk.sk_state != SMC_INIT &&
+	    smc->sk.sk_state != SMC_CLOSED) {
+		/* tbd: call rc = smc_cdc_get_slot_and_msg_send(conn); */
+		if (!rc) {
+			schedule_delayed_work(&conn->tx_work, 0);
+			smc->sk.sk_data_ready(&smc->sk);
+		}
+	}
+	return rc;
+}
+
+struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
+				  struct smc_link *from_lnk, bool is_dev_err)
+{
+	struct smc_link *to_lnk = NULL;
+	struct smc_connection *conn;
+	struct smc_sock *smc;
+	struct rb_node *node;
+	int i, rc = 0;
+
+	/* link is inactive, wake up tx waiters */
+	smc_wr_wakeup_tx_wait(from_lnk);
+
+	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
+		if (lgr->lnk[i].state != SMC_LNK_ACTIVE ||
+		    i == from_lnk->link_idx)
+			continue;
+		if (is_dev_err && from_lnk->smcibdev == lgr->lnk[i].smcibdev &&
+		    from_lnk->ibport == lgr->lnk[i].ibport) {
+			continue;
+		}
+		to_lnk = &lgr->lnk[i];
+		break;
+	}
+	if (!to_lnk) {
+		smc_lgr_terminate_sched(lgr);
+		return NULL;
+	}
+again:
+	read_lock_bh(&lgr->conns_lock);
+	for (node = rb_first(&lgr->conns_all); node; node = rb_next(node)) {
+		conn = rb_entry(node, struct smc_connection, alert_node);
+		if (conn->lnk != from_lnk)
+			continue;
+		smc = container_of(conn, struct smc_sock, conn);
+		/* conn->lnk not yet set in SMC_INIT state */
+		if (smc->sk.sk_state == SMC_INIT)
+			continue;
+		if (smc->sk.sk_state == SMC_CLOSED ||
+		    smc->sk.sk_state == SMC_PEERCLOSEWAIT1 ||
+		    smc->sk.sk_state == SMC_PEERCLOSEWAIT2 ||
+		    smc->sk.sk_state == SMC_APPFINCLOSEWAIT ||
+		    smc->sk.sk_state == SMC_APPCLOSEWAIT1 ||
+		    smc->sk.sk_state == SMC_APPCLOSEWAIT2 ||
+		    smc->sk.sk_state == SMC_PEERFINCLOSEWAIT ||
+		    smc->sk.sk_state == SMC_PEERABORTWAIT ||
+		    smc->sk.sk_state == SMC_PROCESSABORT) {
+			spin_lock_bh(&conn->send_lock);
+			conn->lnk = to_lnk;
+			spin_unlock_bh(&conn->send_lock);
+			continue;
+		}
+		sock_hold(&smc->sk);
+		read_unlock_bh(&lgr->conns_lock);
+		/* avoid race with smcr_tx_sndbuf_nonempty() */
+		spin_lock_bh(&conn->send_lock);
+		conn->lnk = to_lnk;
+		rc = smc_switch_cursor(smc);
+		spin_unlock_bh(&conn->send_lock);
+		sock_put(&smc->sk);
+		if (rc) {
+			smcr_link_down_cond_sched(to_lnk);
+			return NULL;
+		}
+		goto again;
+	}
+	read_unlock_bh(&lgr->conns_lock);
+	return to_lnk;
+}
+
 static void smcr_buf_unuse(struct smc_buf_desc *rmb_desc,
 			   struct smc_link_group *lgr)
 {
@@ -943,8 +1072,7 @@ static void smcr_link_down(struct smc_link *lnk)
 		return;
 
 	smc_ib_modify_qp_reset(lnk);
-	to_lnk = NULL;
-	/* tbd: call to_lnk = smc_switch_conns(lgr, lnk, true); */
+	to_lnk = smc_switch_conns(lgr, lnk, true);
 	if (!to_lnk) { /* no backup link available */
 		smcr_link_clear(lnk);
 		return;
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 7fe53feb9dc4..584f11230c4f 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -380,6 +380,8 @@ void smcr_link_clear(struct smc_link *lnk);
 int smcr_buf_map_lgr(struct smc_link *lnk);
 int smcr_buf_reg_lgr(struct smc_link *lnk);
 int smcr_link_reg_rmb(struct smc_link *link, struct smc_buf_desc *rmb_desc);
+struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
+				  struct smc_link *from_lnk, bool is_dev_err);
 void smcr_link_down_cond(struct smc_link *lnk);
 void smcr_link_down_cond_sched(struct smc_link *lnk);
 
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 7675ccd6f3c3..8d2368accbad 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -933,7 +933,7 @@ static void smc_llc_delete_asym_link(struct smc_link_group *lgr)
 		return; /* no asymmetric link */
 	if (!smc_link_downing(&lnk_asym->state))
 		return;
-	/* tbd: lnk_new = smc_switch_conns(lgr, lnk_asym, false); */
+	lnk_new = smc_switch_conns(lgr, lnk_asym, false);
 	smc_wr_tx_wait_no_pending_sends(lnk_asym);
 	if (!lnk_new)
 		goto out_free;
@@ -1195,7 +1195,7 @@ static void smc_llc_process_cli_delete_link(struct smc_link_group *lgr)
 	smc_llc_send_message(lnk, &qentry->msg); /* response */
 
 	if (smc_link_downing(&lnk_del->state)) {
-		/* tbd: call smc_switch_conns(lgr, lnk_del, false); */
+		smc_switch_conns(lgr, lnk_del, false);
 		smc_wr_tx_wait_no_pending_sends(lnk_del);
 	}
 	smcr_link_clear(lnk_del);
@@ -1245,7 +1245,7 @@ static void smc_llc_process_srv_delete_link(struct smc_link_group *lgr)
 		goto out; /* asymmetric link already deleted */
 
 	if (smc_link_downing(&lnk_del->state)) {
-		/* tbd: call smc_switch_conns(lgr, lnk_del, false); */
+		smc_switch_conns(lgr, lnk_del, false);
 		smc_wr_tx_wait_no_pending_sends(lnk_del);
 	}
 	if (!list_empty(&lgr->list)) {
diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 417204572a69..54ba0443847e 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -482,12 +482,13 @@ static int smc_tx_rdma_writes(struct smc_connection *conn,
 static int smcr_tx_sndbuf_nonempty(struct smc_connection *conn)
 {
 	struct smc_cdc_producer_flags *pflags = &conn->local_tx_ctrl.prod_flags;
+	struct smc_link *link = conn->lnk;
 	struct smc_rdma_wr *wr_rdma_buf;
 	struct smc_cdc_tx_pend *pend;
 	struct smc_wr_buf *wr_buf;
 	int rc;
 
-	rc = smc_cdc_get_free_slot(conn, &wr_buf, &wr_rdma_buf, &pend);
+	rc = smc_cdc_get_free_slot(conn, link, &wr_buf, &wr_rdma_buf, &pend);
 	if (rc < 0) {
 		if (rc == -EBUSY) {
 			struct smc_sock *smc =
@@ -505,10 +506,17 @@ static int smcr_tx_sndbuf_nonempty(struct smc_connection *conn)
 	}
 
 	spin_lock_bh(&conn->send_lock);
+	if (link != conn->lnk) {
+		/* link of connection changed, tx_work will restart */
+		smc_wr_tx_put_slot(link,
+				   (struct smc_wr_tx_pend_priv *)pend);
+		rc = -ENOLINK;
+		goto out_unlock;
+	}
 	if (!pflags->urg_data_present) {
 		rc = smc_tx_rdma_writes(conn, wr_rdma_buf);
 		if (rc) {
-			smc_wr_tx_put_slot(conn->lnk,
+			smc_wr_tx_put_slot(link,
 					   (struct smc_wr_tx_pend_priv *)pend);
 			goto out_unlock;
 		}
-- 
2.17.1

