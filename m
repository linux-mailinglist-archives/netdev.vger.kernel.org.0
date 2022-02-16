Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C94B4B8742
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 13:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232891AbiBPMA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 07:00:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbiBPMA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 07:00:26 -0500
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B122679C7;
        Wed, 16 Feb 2022 04:00:12 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V4dB.Pk_1645012809;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V4dB.Pk_1645012809)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 16 Feb 2022 20:00:10 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net-next v2] net/smc: Add autocork support
Date:   Wed, 16 Feb 2022 20:00:09 +0800
Message-Id: <20220216120009.63747-1-dust.li@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds autocork support for SMC which could improve
throughput for small message by x2 ~ x4.

The main idea is borrowed from TCP autocork with some RDMA
specific modification:
1. The first message should never cork to make sure we won't
   bring extra latency
2. If we have posted any Tx WRs to the NIC that have not
   completed, cork the new messages until:
   a) Receive CQE for the last Tx WR
   b) We have corked enough message on the connection
3. Try to push the corked data out when we receive CQE of
   the last Tx WR to prevent the corked messages hang in
   the send queue.

Both SMC autocork and TCP autocork check the TX completion
to decide whether we should cork or not. The difference is
when we got a SMC Tx WR completion, the data have been confirmed
by the RNIC while TCP TX completion just tells us the data
have been sent out by the local NIC.

Add an atomic variable tx_pushing in smc_connection to make
sure only one can send to let it cork more and save CDC slot.

SMC autocork should not bring extra latency since the first
message will always been sent out immediately.

The qperf tcp_bw test shows more than x4 increase under small
message size with Mellanox connectX4-Lx, same result with other
throughput benchmarks like sockperf/netperf.
The qperf tcp_lat test shows SMC autocork has not increase any
ping-pong latency.

BW test:
 client: smc_run taskset -c 1 qperf smc-server -oo msg_size:1:64K:*2 \
			-t 30 -vu tcp_bw
 server: smc_run taskset -c 1 qperf

MsgSize(Bytes)        TCP         SMC-NoCork           SMC-AutoCork
      1         2.57 MB/s     698 KB/s(-73.5%)     2.98 MB/s(16.0% )
      2          5.1 MB/s    1.41 MB/s(-72.4%)     5.82 MB/s(14.1% )
      4         10.2 MB/s    2.83 MB/s(-72.3%)     11.7 MB/s(14.7% )
      8         20.8 MB/s    5.62 MB/s(-73.0%)     22.9 MB/s(10.1% )
     16         42.5 MB/s    11.5 MB/s(-72.9%)     45.5 MB/s(7.1%  )
     32         80.7 MB/s    22.3 MB/s(-72.4%)     86.7 MB/s(7.4%  )
     64          155 MB/s    45.6 MB/s(-70.6%)      160 MB/s(3.2%  )
    128          295 MB/s    90.1 MB/s(-69.5%)      273 MB/s(-7.5% )
    256          539 MB/s     179 MB/s(-66.8%)      610 MB/s(13.2% )
    512          943 MB/s     360 MB/s(-61.8%)     1.02 GB/s(10.8% )
   1024         1.58 GB/s     710 MB/s(-56.1%)     1.91 GB/s(20.9% )
   2048         2.47 GB/s    1.34 GB/s(-45.7%)     2.92 GB/s(18.2% )
   4096         2.86 GB/s     2.5 GB/s(-12.6%)      2.4 GB/s(-16.1%)
   8192         3.89 GB/s    3.14 GB/s(-19.3%)     4.05 GB/s(4.1%  )
  16384         3.29 GB/s    4.67 GB/s(41.9% )     5.09 GB/s(54.7% )
  32768         2.73 GB/s    5.48 GB/s(100.7%)     5.49 GB/s(101.1%)
  65536            3 GB/s    4.85 GB/s(61.7% )     5.24 GB/s(74.7% )

Latency test:
 client: smc_run taskset -c 1 qperf smc-server -oo msg_size:1:64K:*2 \
			-t 30 -vu tcp_lat
 server: smc_run taskset -c 1 qperf

 MsgSize              SMC-NoCork           SMC-AutoCork
       1               9.7 us               9.6 us( -1.03%)
       2              9.43 us              9.39 us( -0.42%)
       4               9.6 us              9.35 us( -2.60%)
       8              9.42 us               9.2 us( -2.34%)
      16              9.13 us              9.43 us(  3.29%)
      32              9.19 us               9.5 us(  3.37%)
      64              9.38 us               9.5 us(  1.28%)
     128               9.9 us              9.29 us( -6.16%)
     256              9.42 us              9.26 us( -1.70%)
     512                10 us              9.45 us( -5.50%)
    1024              10.4 us               9.6 us( -7.69%)
    2048              10.4 us              10.2 us( -1.92%)
    4096                11 us              10.5 us( -4.55%)
    8192              11.7 us              11.8 us(  0.85%)
   16384              14.5 us              14.2 us( -2.07%)
   32768              19.4 us              19.3 us( -0.52%)
   65536              28.1 us              28.8 us(  2.49%)

With SMC autocork support, we can archive better throughput than
TCP in most message sizes without any latency tradeoff.

Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
---
v2: 1. Remove empty line in smc_connection
    2. use Reverse Christmas tree style for local variable.
    3. remove redundant container_of
---
 net/smc/smc.h     |   1 +
 net/smc/smc_cdc.c |  11 +++--
 net/smc/smc_tx.c  | 120 +++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 113 insertions(+), 19 deletions(-)

diff --git a/net/smc/smc.h b/net/smc/smc.h
index a096d8af21a0..c979965fcb53 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -192,6 +192,7 @@ struct smc_connection {
 						 * - dec on polled tx cqe
 						 */
 	wait_queue_head_t	cdc_pend_tx_wq; /* wakeup on no cdc_pend_tx_wr*/
+	atomic_t		tx_pushing;     /* nr_threads trying tx push */
 	struct delayed_work	tx_work;	/* retry of smc_cdc_msg_send */
 	u32			tx_off;		/* base offset in peer rmb */
 
diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index 9d5a97168969..2b37bec90824 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -48,9 +48,14 @@ static void smc_cdc_tx_handler(struct smc_wr_tx_pend_priv *pnd_snd,
 		conn->tx_cdc_seq_fin = cdcpend->ctrl_seq;
 	}
 
-	if (atomic_dec_and_test(&conn->cdc_pend_tx_wr) &&
-	    unlikely(wq_has_sleeper(&conn->cdc_pend_tx_wq)))
-		wake_up(&conn->cdc_pend_tx_wq);
+	if (atomic_dec_and_test(&conn->cdc_pend_tx_wr)) {
+		/* If this is the last pending WR complete, we must push to
+		 * prevent hang when autocork enabled.
+		 */
+		smc_tx_sndbuf_nonempty(conn);
+		if (unlikely(wq_has_sleeper(&conn->cdc_pend_tx_wq)))
+			wake_up(&conn->cdc_pend_tx_wq);
+	}
 	WARN_ON(atomic_read(&conn->cdc_pend_tx_wr) < 0);
 
 	smc_tx_sndbuf_nonfull(smc);
diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 5df3940d4543..f23f28c51913 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -31,6 +31,7 @@
 #include "smc_tracepoint.h"
 
 #define SMC_TX_WORK_DELAY	0
+#define SMC_DEFAULT_AUTOCORK_SIZE	(64 * 1024)
 
 /***************************** sndbuf producer *******************************/
 
@@ -127,10 +128,52 @@ static int smc_tx_wait(struct smc_sock *smc, int flags)
 static bool smc_tx_is_corked(struct smc_sock *smc)
 {
 	struct tcp_sock *tp = tcp_sk(smc->clcsock->sk);
-
 	return (tp->nonagle & TCP_NAGLE_CORK) ? true : false;
 }
 
+/* If we have pending CDC messages, do not send:
+ * Because CQE of this CDC message will happen shortly, it gives
+ * a chance to coalesce future sendmsg() payload in to one RDMA Write,
+ * without need for a timer, and with no latency trade off.
+ * Algorithm here:
+ *  1. First message should never cork
+ *  2. If we have pending CDC messages, wait for the first
+ *     message's completion
+ *  3. Don't cork to much data in a single RDMA Write to prevent burst,
+ *     total corked message should not exceed min(64k, sendbuf/2)
+ */
+static bool smc_should_autocork(struct smc_sock *smc, struct msghdr *msg,
+				int size_goal)
+{
+	struct smc_connection *conn = &smc->conn;
+
+	if (atomic_read(&conn->cdc_pend_tx_wr) == 0 ||
+	    smc_tx_prepared_sends(conn) > min(size_goal,
+					      conn->sndbuf_desc->len >> 1))
+		return false;
+	return true;
+}
+
+static bool smc_tx_should_cork(struct smc_sock *smc, struct msghdr *msg)
+{
+	struct smc_connection *conn = &smc->conn;
+
+	if (smc_should_autocork(smc, msg, SMC_DEFAULT_AUTOCORK_SIZE))
+		return true;
+
+	if ((msg->msg_flags & MSG_MORE ||
+	     smc_tx_is_corked(smc) ||
+	     msg->msg_flags & MSG_SENDPAGE_NOTLAST) &&
+	    (atomic_read(&conn->sndbuf_space)))
+		/* for a corked socket defer the RDMA writes if
+		 * sndbuf_space is still available. The applications
+		 * should known how/when to uncork it.
+		 */
+		return true;
+
+	return false;
+}
+
 /* sndbuf producer: main API called by socket layer.
  * called under sock lock.
  */
@@ -177,6 +220,13 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
 		if (msg->msg_flags & MSG_OOB)
 			conn->local_tx_ctrl.prod_flags.urg_data_pending = 1;
 
+		/* If our send queue is full but peer have RMBE space,
+		 * we should send them out before wait
+		 */
+		if (!atomic_read(&conn->sndbuf_space) &&
+		    atomic_read(&conn->peer_rmbe_space) > 0)
+			smc_tx_sndbuf_nonempty(conn);
+
 		if (!atomic_read(&conn->sndbuf_space) || conn->urg_tx_pend) {
 			if (send_done)
 				return send_done;
@@ -235,15 +285,12 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
 		 */
 		if ((msg->msg_flags & MSG_OOB) && !send_remaining)
 			conn->urg_tx_pend = true;
-		if ((msg->msg_flags & MSG_MORE || smc_tx_is_corked(smc) ||
-		     msg->msg_flags & MSG_SENDPAGE_NOTLAST) &&
-		    (atomic_read(&conn->sndbuf_space)))
-			/* for a corked socket defer the RDMA writes if
-			 * sndbuf_space is still available. The applications
-			 * should known how/when to uncork it.
-			 */
-			continue;
-		smc_tx_sndbuf_nonempty(conn);
+
+		/* If we need to cork, do nothing and wait for the next
+		 * sendmsg() call or push on tx completion
+		 */
+		if (!smc_tx_should_cork(smc, msg))
+			smc_tx_sndbuf_nonempty(conn);
 
 		trace_smc_tx_sendmsg(smc, copylen);
 	} /* while (msg_data_left(msg)) */
@@ -590,13 +637,26 @@ static int smcd_tx_sndbuf_nonempty(struct smc_connection *conn)
 	return rc;
 }
 
-int smc_tx_sndbuf_nonempty(struct smc_connection *conn)
+static int __smc_tx_sndbuf_nonempty(struct smc_connection *conn)
 {
-	int rc;
+	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
+	int rc = 0;
+
+	/* No data in the send queue */
+	if (unlikely(smc_tx_prepared_sends(conn) <= 0))
+		goto out;
+
+	/* Peer don't have RMBE space */
+	if (unlikely(atomic_read(&conn->peer_rmbe_space) <= 0)) {
+		SMC_STAT_RMB_TX_PEER_FULL(smc, !conn->lnk);
+		goto out;
+	}
 
 	if (conn->killed ||
-	    conn->local_rx_ctrl.conn_state_flags.peer_conn_abort)
-		return -EPIPE;	/* connection being aborted */
+	    conn->local_rx_ctrl.conn_state_flags.peer_conn_abort) {
+		rc = -EPIPE;    /* connection being aborted */
+		goto out;
+	}
 	if (conn->lgr->is_smcd)
 		rc = smcd_tx_sndbuf_nonempty(conn);
 	else
@@ -604,10 +664,38 @@ int smc_tx_sndbuf_nonempty(struct smc_connection *conn)
 
 	if (!rc) {
 		/* trigger socket release if connection is closing */
-		struct smc_sock *smc = container_of(conn, struct smc_sock,
-						    conn);
 		smc_close_wake_tx_prepared(smc);
 	}
+
+out:
+	return rc;
+}
+
+int smc_tx_sndbuf_nonempty(struct smc_connection *conn)
+{
+	int rc;
+
+	/* This make sure only one can send simultaneously to prevent wasting
+	 * of CPU and CDC slot.
+	 * Record whether someone has tried to push while we are pushing.
+	 */
+	if (atomic_inc_return(&conn->tx_pushing) > 1)
+		return 0;
+
+again:
+	atomic_set(&conn->tx_pushing, 1);
+	smp_wmb(); /* Make sure tx_pushing is 1 before real send */
+	rc = __smc_tx_sndbuf_nonempty(conn);
+
+	/* We need to check whether someone else have added some data into
+	 * the send queue and tried to push but failed after the atomic_set()
+	 * when we are pushing.
+	 * If so, we need to push again to prevent those data hang in the send
+	 * queue.
+	 */
+	if (unlikely(!atomic_dec_and_test(&conn->tx_pushing)))
+		goto again;
+
 	return rc;
 }
 
-- 
2.19.1.3.ge56e4f7

