Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFB16DEF07
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 16:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729170AbfJUONh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 10:13:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24682 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729112AbfJUONh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 10:13:37 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9LEDVVV029715
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 10:13:36 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vsdcvtmsx-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 10:13:36 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Mon, 21 Oct 2019 15:13:25 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 21 Oct 2019 15:13:22 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9LEDLEB42598816
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Oct 2019 14:13:21 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B9104C06E;
        Mon, 21 Oct 2019 14:13:20 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 168E44C050;
        Mon, 21 Oct 2019 14:13:20 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Oct 2019 14:13:20 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 1/8] net/smc: cancel send and receive for terminated socket
Date:   Mon, 21 Oct 2019 16:13:08 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191021141315.58969-1-kgraul@linux.ibm.com>
References: <20191021141315.58969-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19102114-0008-0000-0000-00000324F3FA
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102114-0009-0000-0000-00004A441C31
Message-Id: <20191021141315.58969-2-kgraul@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-21_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910210135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

The resources for a terminated socket are being cleaned up.
This patch makes sure
* no more data is received for an actively terminated socket
* no more data is sent for an actively or passively terminated socket

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc.h       |  1 +
 net/smc/smc_cdc.c   |  4 ++--
 net/smc/smc_close.c |  7 +++++--
 net/smc/smc_core.c  |  1 +
 net/smc/smc_rx.c    | 10 ++++++++--
 net/smc/smc_tx.c    | 26 +++++++++++++++-----------
 6 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/net/smc/smc.h b/net/smc/smc.h
index 878313f8d6c1..be11ba41190f 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -188,6 +188,7 @@ struct smc_connection {
 						 * 0 for SMC-R, 32 for SMC-D
 						 */
 	u64			peer_token;	/* SMC-D token of peer */
+	u8			killed : 1;	/* abnormal termination */
 };
 
 struct smc_sock {				/* smc sock container */
diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index d0b0f4c865b4..7dc07ec2379b 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -63,7 +63,7 @@ int smc_cdc_get_free_slot(struct smc_connection *conn,
 	rc = smc_wr_tx_get_free_slot(link, smc_cdc_tx_handler, wr_buf,
 				     wr_rdma_buf,
 				     (struct smc_wr_tx_pend_priv **)pend);
-	if (!conn->alert_token_local)
+	if (conn->killed)
 		/* abnormal termination */
 		rc = -EPIPE;
 	return rc;
@@ -328,7 +328,7 @@ static void smcd_cdc_rx_tsklet(unsigned long data)
 	struct smcd_cdc_msg cdc;
 	struct smc_sock *smc;
 
-	if (!conn)
+	if (!conn || conn->killed)
 		return;
 
 	data_cdc = (struct smcd_cdc_msg *)conn->rmb_desc->cpu_addr;
diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index 1a858e59fc31..1d706c581592 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -66,7 +66,8 @@ static void smc_close_stream_wait(struct smc_sock *smc, long timeout)
 		rc = sk_wait_event(sk, &timeout,
 				   !smc_tx_prepared_sends(&smc->conn) ||
 				   sk->sk_err == ECONNABORTED ||
-				   sk->sk_err == ECONNRESET,
+				   sk->sk_err == ECONNRESET ||
+				   smc->conn.killed,
 				   &wait);
 		if (rc)
 			break;
@@ -95,6 +96,8 @@ static int smc_close_final(struct smc_connection *conn)
 		conn->local_tx_ctrl.conn_state_flags.peer_conn_abort = 1;
 	else
 		conn->local_tx_ctrl.conn_state_flags.peer_conn_closed = 1;
+	if (conn->killed)
+		return -EPIPE;
 
 	return smc_cdc_get_slot_and_msg_send(conn);
 }
@@ -326,7 +329,7 @@ static void smc_close_passive_work(struct work_struct *work)
 	lock_sock(sk);
 	old_state = sk->sk_state;
 
-	if (!conn->alert_token_local) {
+	if (conn->killed) {
 		/* abnormal termination */
 		smc_close_active_abort(smc);
 		goto wakeup;
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index de9bf035f545..4ee0e33b8c5a 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -500,6 +500,7 @@ static void __smc_lgr_terminate(struct smc_link_group *lgr)
 		conn = rb_entry(node, struct smc_connection, alert_node);
 		smc = container_of(conn, struct smc_sock, conn);
 		sock_hold(&smc->sk); /* sock_put in close work */
+		conn->killed = 1;
 		conn->local_tx_ctrl.conn_state_flags.peer_conn_abort = 1;
 		__smc_lgr_unregister_conn(conn);
 		conn->lgr = NULL;
diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
index 97e8369002d7..39d7b34d06d2 100644
--- a/net/smc/smc_rx.c
+++ b/net/smc/smc_rx.c
@@ -201,6 +201,8 @@ int smc_rx_wait(struct smc_sock *smc, long *timeo,
 {
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	struct smc_connection *conn = &smc->conn;
+	struct smc_cdc_conn_state_flags *cflags =
+					&conn->local_tx_ctrl.conn_state_flags;
 	struct sock *sk = &smc->sk;
 	int rc;
 
@@ -210,7 +212,9 @@ int smc_rx_wait(struct smc_sock *smc, long *timeo,
 	add_wait_queue(sk_sleep(sk), &wait);
 	rc = sk_wait_event(sk, timeo,
 			   sk->sk_err ||
+			   cflags->peer_conn_abort ||
 			   sk->sk_shutdown & RCV_SHUTDOWN ||
+			   conn->killed ||
 			   fcrit(conn),
 			   &wait);
 	remove_wait_queue(sk_sleep(sk), &wait);
@@ -314,11 +318,13 @@ int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg,
 		if (read_done >= target || (pipe && read_done))
 			break;
 
+		if (conn->killed)
+			break;
+
 		if (smc_rx_recvmsg_data_available(smc))
 			goto copy;
 
-		if (sk->sk_shutdown & RCV_SHUTDOWN ||
-		    conn->local_tx_ctrl.conn_state_flags.peer_conn_abort) {
+		if (sk->sk_shutdown & RCV_SHUTDOWN) {
 			/* smc_cdc_msg_recv_action() could have run after
 			 * above smc_rx_recvmsg_data_available()
 			 */
diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 6c8f09c1ce51..824f096ee7de 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -86,6 +86,7 @@ static int smc_tx_wait(struct smc_sock *smc, int flags)
 		sk_set_bit(SOCKWQ_ASYNC_NOSPACE, sk);
 		if (sk->sk_err ||
 		    (sk->sk_shutdown & SEND_SHUTDOWN) ||
+		    conn->killed ||
 		    conn->local_tx_ctrl.conn_state_flags.peer_done_writing) {
 			rc = -EPIPE;
 			break;
@@ -155,7 +156,7 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
 			return -ENOTCONN;
 		if (smc->sk.sk_shutdown & SEND_SHUTDOWN ||
 		    (smc->sk.sk_err == ECONNABORTED) ||
-		    conn->local_tx_ctrl.conn_state_flags.peer_conn_abort)
+		    conn->killed)
 			return -EPIPE;
 		if (smc_cdc_rxed_any_close(conn))
 			return send_done ?: -ECONNRESET;
@@ -282,10 +283,8 @@ static int smc_tx_rdma_write(struct smc_connection *conn, int peer_rmbe_offset,
 		peer_rmbe_offset;
 	rdma_wr->rkey = lgr->rtokens[conn->rtoken_idx][SMC_SINGLE_LINK].rkey;
 	rc = ib_post_send(link->roce_qp, &rdma_wr->wr, NULL);
-	if (rc) {
-		conn->local_tx_ctrl.conn_state_flags.peer_conn_abort = 1;
+	if (rc)
 		smc_lgr_terminate(lgr);
-	}
 	return rc;
 }
 
@@ -495,10 +494,11 @@ static int smcr_tx_sndbuf_nonempty(struct smc_connection *conn)
 
 			if (smc->sk.sk_err == ECONNABORTED)
 				return sock_error(&smc->sk);
+			if (conn->killed)
+				return -EPIPE;
 			rc = 0;
-			if (conn->alert_token_local) /* connection healthy */
-				mod_delayed_work(system_wq, &conn->tx_work,
-						 SMC_TX_WORK_DELAY);
+			mod_delayed_work(system_wq, &conn->tx_work,
+					 SMC_TX_WORK_DELAY);
 		}
 		return rc;
 	}
@@ -547,6 +547,9 @@ int smc_tx_sndbuf_nonempty(struct smc_connection *conn)
 {
 	int rc;
 
+	if (conn->killed ||
+	    conn->local_rx_ctrl.conn_state_flags.peer_conn_abort)
+		return -EPIPE;	/* connection being aborted */
 	if (conn->lgr->is_smcd)
 		rc = smcd_tx_sndbuf_nonempty(conn);
 	else
@@ -573,9 +576,7 @@ void smc_tx_work(struct work_struct *work)
 	int rc;
 
 	lock_sock(&smc->sk);
-	if (smc->sk.sk_err ||
-	    !conn->alert_token_local ||
-	    conn->local_rx_ctrl.conn_state_flags.peer_conn_abort)
+	if (smc->sk.sk_err)
 		goto out;
 
 	rc = smc_tx_sndbuf_nonempty(conn);
@@ -608,8 +609,11 @@ void smc_tx_consumer_update(struct smc_connection *conn, bool force)
 	    ((to_confirm > conn->rmbe_update_limit) &&
 	     ((sender_free <= (conn->rmb_desc->len / 2)) ||
 	      conn->local_rx_ctrl.prod_flags.write_blocked))) {
+		if (conn->killed ||
+		    conn->local_rx_ctrl.conn_state_flags.peer_conn_abort)
+			return;
 		if ((smc_cdc_get_slot_and_msg_send(conn) < 0) &&
-		    conn->alert_token_local) { /* connection healthy */
+		    !conn->killed) {
 			schedule_delayed_work(&conn->tx_work,
 					      SMC_TX_WORK_DELAY);
 			return;
-- 
2.17.1

