Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B63184C884E
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 10:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233968AbiCAJow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 04:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiCAJou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 04:44:50 -0500
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F2E3B3C5;
        Tue,  1 Mar 2022 01:44:08 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R821e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V5wm1Jv_1646127845;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V5wm1Jv_1646127845)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 01 Mar 2022 17:44:06 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Guangguan Wang <guangguan.wang@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net-next 2/7] net/smc: add autocorking support
Date:   Tue,  1 Mar 2022 17:43:57 +0800
Message-Id: <20220301094402.14992-3-dust.li@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
In-Reply-To: <20220301094402.14992-1-dust.li@linux.alibaba.com>
References: <20220301094402.14992-1-dust.li@linux.alibaba.com>
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

This patch adds autocorking support for SMC which could improve
throughput for small message by x3+.

The main idea is borrowed from TCP autocorking with some RDMA
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

Both SMC autocorking and TCP autocorking check the TX completion
to decide whether we should cork or not. The difference is
when we got a SMC Tx WR completion, the data have been confirmed
by the RNIC while TCP TX completion just tells us the data
have been sent out by the local NIC.

Add an atomic variable tx_pushing in smc_connection to make
sure only one can send to let it cork more and save CDC slot.

SMC autocorking should not bring extra latency since the first
message will always been sent out immediately.

The qperf tcp_bw test shows more than x4 increase under small
message size with Mellanox connectX4-Lx, same result with other
throughput benchmarks like sockperf/netperf.
The qperf tcp_lat test shows SMC autocorking has not increase any
ping-pong latency.

Test command:
 client: smc_run taskset -c 1 qperf smc-server -oo msg_size:1:64K:*2 \
			-t 30 -vu tcp_{bw|lat}
 server: smc_run taskset -c 1 qperf

=== Bandwidth ====
MsgSize(Bytes)  SMC-NoCork           TCP                      SMC-AutoCorking
      1         0.578 MB/s       2.392 MB/s(313.57%)        2.647 MB/s(357.72%)
      2         1.159 MB/s       4.780 MB/s(312.53%)        5.153 MB/s(344.71%)
      4         2.283 MB/s      10.266 MB/s(349.77%)       10.363 MB/s(354.02%)
      8         4.668 MB/s      19.040 MB/s(307.86%)       21.215 MB/s(354.45%)
     16         9.147 MB/s      38.904 MB/s(325.31%)       41.740 MB/s(356.32%)
     32        18.369 MB/s      79.587 MB/s(333.25%)       82.392 MB/s(348.52%)
     64        36.562 MB/s     148.668 MB/s(306.61%)      161.564 MB/s(341.89%)
    128        72.961 MB/s     274.913 MB/s(276.80%)      325.363 MB/s(345.94%)
    256       144.705 MB/s     512.059 MB/s(253.86%)      633.743 MB/s(337.96%)
    512       288.873 MB/s     884.977 MB/s(206.35%)     1250.681 MB/s(332.95%)
   1024       574.180 MB/s    1337.736 MB/s(132.98%)     2246.121 MB/s(291.19%)
   2048      1095.192 MB/s    1865.952 MB/s( 70.38%)     2057.767 MB/s( 87.89%)
   4096      2066.157 MB/s    2380.337 MB/s( 15.21%)     2173.983 MB/s(  5.22%)
   8192      3717.198 MB/s    2733.073 MB/s(-26.47%)     3491.223 MB/s( -6.08%)
  16384      4742.221 MB/s    2958.693 MB/s(-37.61%)     4637.692 MB/s( -2.20%)
  32768      5349.550 MB/s    3061.285 MB/s(-42.77%)     5385.796 MB/s(  0.68%)
  65536      5162.919 MB/s    3731.408 MB/s(-27.73%)     5223.890 MB/s(  1.18%)
==== Latency ====
MsgSize(Bytes)   SMC-NoCork         TCP                    SMC-AutoCorking
      1          10.540 us      11.938 us( 13.26%)       10.573 us(  0.31%)
      2          10.996 us      11.992 us(  9.06%)       10.269 us( -6.61%)
      4          10.229 us      11.687 us( 14.25%)       10.240 us(  0.11%)
      8          10.203 us      11.653 us( 14.21%)       10.402 us(  1.95%)
     16          10.530 us      11.313 us(  7.44%)       10.599 us(  0.66%)
     32          10.241 us      11.586 us( 13.13%)       10.223 us( -0.18%)
     64          10.693 us      11.652 us(  8.97%)       10.251 us( -4.13%)
    128          10.597 us      11.579 us(  9.27%)       10.494 us( -0.97%)
    256          10.409 us      11.957 us( 14.87%)       10.710 us(  2.89%)
    512          11.088 us      12.505 us( 12.78%)       10.547 us( -4.88%)
   1024          11.240 us      12.255 us(  9.03%)       10.787 us( -4.03%)
   2048          11.485 us      16.970 us( 47.76%)       11.256 us( -1.99%)
   4096          12.077 us      13.948 us( 15.49%)       12.230 us(  1.27%)
   8192          13.683 us      16.693 us( 22.00%)       13.786 us(  0.75%)
  16384          16.470 us      23.615 us( 43.38%)       16.459 us( -0.07%)
  32768          22.540 us      40.966 us( 81.75%)       23.284 us(  3.30%)
  65536          34.192 us      73.003 us(113.51%)       34.233 us(  0.12%)

With SMC autocorking support, we can archive better throughput
than TCP in most message sizes without any latency trade-off.

Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
---
v2: 1. Remove empty line in smc_connection
    2. use Reverse Christmas tree style for local variable.
    3. remove redundant container_of
v3: 1. use hex instead of decimal
    2. Remove unintented removal of new line
    3. Rename autocork to autocorking to be compliant with TCP
    4. re-test the data, use SMC NoCork as baseline
---
 net/smc/smc.h     |   2 +
 net/smc/smc_cdc.c |  11 +++--
 net/smc/smc_tx.c  | 107 ++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 105 insertions(+), 15 deletions(-)

diff --git a/net/smc/smc.h b/net/smc/smc.h
index a096d8af21a0..e266b04b7585 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -29,6 +29,7 @@
 #define SMC_MAX_ISM_DEVS	8	/* max # of proposed non-native ISM
 					 * devices
 					 */
+#define SMC_AUTOCORKING_DEFAULT_SIZE	0x10000	/* 64K by default */
 
 extern struct proto smc_proto;
 extern struct proto smc_proto6;
@@ -192,6 +193,7 @@ struct smc_connection {
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
index 436ac836f363..062c6b1535e3 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -131,6 +131,51 @@ static bool smc_tx_is_corked(struct smc_sock *smc)
 	return (tp->nonagle & TCP_NAGLE_CORK) ? true : false;
 }
 
+/* If we have pending CDC messages, do not send:
+ * Because CQE of this CDC message will happen shortly, it gives
+ * a chance to coalesce future sendmsg() payload in to one RDMA Write,
+ * without need for a timer, and with no latency trade off.
+ * Algorithm here:
+ *  1. First message should never cork
+ *  2. If we have pending Tx CDC messages, wait for the first CDC
+ *     message's completion
+ *  3. Don't cork to much data in a single RDMA Write to prevent burst
+ *     traffic, total corked message should not exceed sendbuf/2
+ */
+static bool smc_should_autocork(struct smc_sock *smc)
+{
+	struct smc_connection *conn = &smc->conn;
+	int corking_size;
+
+	corking_size = min(SMC_AUTOCORKING_DEFAULT_SIZE,
+			   conn->sndbuf_desc->len >> 1);
+
+	if (atomic_read(&conn->cdc_pend_tx_wr) == 0 ||
+	    smc_tx_prepared_sends(conn) > corking_size)
+		return false;
+	return true;
+}
+
+static bool smc_tx_should_cork(struct smc_sock *smc, struct msghdr *msg)
+{
+	struct smc_connection *conn = &smc->conn;
+
+	if (smc_should_autocork(smc))
+		return true;
+
+	/* for a corked socket defer the RDMA writes if
+	 * sndbuf_space is still available. The applications
+	 * should known how/when to uncork it.
+	 */
+	if ((msg->msg_flags & MSG_MORE ||
+	     smc_tx_is_corked(smc) ||
+	     msg->msg_flags & MSG_SENDPAGE_NOTLAST) &&
+	    atomic_read(&conn->sndbuf_space))
+		return true;
+
+	return false;
+}
+
 /* sndbuf producer: main API called by socket layer.
  * called under sock lock.
  */
@@ -235,13 +280,10 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
 		 */
 		if ((msg->msg_flags & MSG_OOB) && !send_remaining)
 			conn->urg_tx_pend = true;
-		/* for a corked socket defer the RDMA writes if
-		 * sndbuf_space is still available. The applications
-		 * should known how/when to uncork it.
+		/* If we need to cork, do nothing and wait for the next
+		 * sendmsg() call or push on tx completion
 		 */
-		if (!((msg->msg_flags & MSG_MORE || smc_tx_is_corked(smc) ||
-		       msg->msg_flags & MSG_SENDPAGE_NOTLAST) &&
-		      atomic_read(&conn->sndbuf_space)))
+		if (!smc_tx_should_cork(smc, msg))
 			smc_tx_sndbuf_nonempty(conn);
 
 		trace_smc_tx_sendmsg(smc, copylen);
@@ -589,13 +631,26 @@ static int smcd_tx_sndbuf_nonempty(struct smc_connection *conn)
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
@@ -603,10 +658,38 @@ int smc_tx_sndbuf_nonempty(struct smc_connection *conn)
 
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

