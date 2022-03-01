Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4490D4C8860
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 10:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233995AbiCAJpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 04:45:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233990AbiCAJpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 04:45:05 -0500
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24B047AC0;
        Tue,  1 Mar 2022 01:44:14 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R381e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V5wm1Le_1646127851;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V5wm1Le_1646127851)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 01 Mar 2022 17:44:12 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Guangguan Wang <guangguan.wang@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net-next 7/7] net/smc: don't send in the BH context if sock_owned_by_user
Date:   Tue,  1 Mar 2022 17:44:02 +0800
Message-Id: <20220301094402.14992-8-dust.li@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
In-Reply-To: <20220301094402.14992-1-dust.li@linux.alibaba.com>
References: <20220301094402.14992-1-dust.li@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Send data all the way down to the RDMA device is a time
consuming operation(get a new slot, maybe do RDMA Write
and send a CDC, etc). Moving those operations from BH
to user context is good for performance.

If the sock_lock is hold by user, we don't try to send
data out in the BH context, but just mark we should
send. Since the user will release the sock_lock soon, we
can do the sending there.

Add smc_release_cb() which will be called in release_sock()
and try send in the callback if needed.

This patch moves the sending part out from BH if sock lock
is hold by user. In my testing environment, this saves about
20% softirq in the qperf 4K tcp_bw test in the sender side
with no noticeable throughput drop.

Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
---
 net/smc/af_smc.c  | 16 ++++++++++++++++
 net/smc/smc.h     |  4 ++++
 net/smc/smc_cdc.c | 19 ++++++++++++++-----
 3 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index e661b3747945..6447607675fa 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -193,12 +193,27 @@ void smc_unhash_sk(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(smc_unhash_sk);
 
+/* This will be called before user really release sock_lock. So do the
+ * work which we didn't do because of user hold the sock_lock in the
+ * BH context
+ */
+static void smc_release_cb(struct sock *sk)
+{
+	struct smc_sock *smc = smc_sk(sk);
+
+	if (smc->conn.tx_in_release_sock) {
+		smc_tx_pending(&smc->conn);
+		smc->conn.tx_in_release_sock = false;
+	}
+}
+
 struct proto smc_proto = {
 	.name		= "SMC",
 	.owner		= THIS_MODULE,
 	.keepalive	= smc_set_keepalive,
 	.hash		= smc_hash_sk,
 	.unhash		= smc_unhash_sk,
+	.release_cb	= smc_release_cb,
 	.obj_size	= sizeof(struct smc_sock),
 	.h.smc_hash	= &smc_v4_hashinfo,
 	.slab_flags	= SLAB_TYPESAFE_BY_RCU,
@@ -211,6 +226,7 @@ struct proto smc_proto6 = {
 	.keepalive	= smc_set_keepalive,
 	.hash		= smc_hash_sk,
 	.unhash		= smc_unhash_sk,
+	.release_cb	= smc_release_cb,
 	.obj_size	= sizeof(struct smc_sock),
 	.h.smc_hash	= &smc_v6_hashinfo,
 	.slab_flags	= SLAB_TYPESAFE_BY_RCU,
diff --git a/net/smc/smc.h b/net/smc/smc.h
index e266b04b7585..ea0620529ebe 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -213,6 +213,10 @@ struct smc_connection {
 						 * data still pending
 						 */
 	char			urg_rx_byte;	/* urgent byte */
+	bool			tx_in_release_sock;
+						/* flush pending tx data in
+						 * sock release_cb()
+						 */
 	atomic_t		bytes_to_rcv;	/* arrived data,
 						 * not yet received
 						 */
diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index 2b37bec90824..5c731f27996e 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -49,10 +49,15 @@ static void smc_cdc_tx_handler(struct smc_wr_tx_pend_priv *pnd_snd,
 	}
 
 	if (atomic_dec_and_test(&conn->cdc_pend_tx_wr)) {
-		/* If this is the last pending WR complete, we must push to
-		 * prevent hang when autocork enabled.
+		/* If user owns the sock_lock, mark the connection need sending.
+		 * User context will later try to send when it release sock_lock
+		 * in smc_release_cb()
 		 */
-		smc_tx_sndbuf_nonempty(conn);
+		if (sock_owned_by_user(&smc->sk))
+			conn->tx_in_release_sock = true;
+		else
+			smc_tx_pending(conn);
+
 		if (unlikely(wq_has_sleeper(&conn->cdc_pend_tx_wq)))
 			wake_up(&conn->cdc_pend_tx_wq);
 	}
@@ -355,8 +360,12 @@ static void smc_cdc_msg_recv_action(struct smc_sock *smc,
 	/* trigger sndbuf consumer: RDMA write into peer RMBE and CDC */
 	if ((diff_cons && smc_tx_prepared_sends(conn)) ||
 	    conn->local_rx_ctrl.prod_flags.cons_curs_upd_req ||
-	    conn->local_rx_ctrl.prod_flags.urg_data_pending)
-		smc_tx_sndbuf_nonempty(conn);
+	    conn->local_rx_ctrl.prod_flags.urg_data_pending) {
+		if (!sock_owned_by_user(&smc->sk))
+			smc_tx_pending(conn);
+		else
+			conn->tx_in_release_sock = true;
+	}
 
 	if (diff_cons && conn->urg_tx_pend &&
 	    atomic_read(&conn->peer_rmbe_space) == conn->peer_rmbe_size) {
-- 
2.19.1.3.ge56e4f7

