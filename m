Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58BB7651987
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 04:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232858AbiLTDWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 22:22:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233118AbiLTDWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 22:22:08 -0500
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE4810FF4;
        Mon, 19 Dec 2022 19:22:06 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VXjWtup_1671506522;
Received: from localhost(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VXjWtup_1671506522)
          by smtp.aliyun-inc.com;
          Tue, 20 Dec 2022 11:22:04 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v2 5/5] net/smc: logic of cursors update in SMC-D loopback connections
Date:   Tue, 20 Dec 2022 11:21:45 +0800
Message-Id: <1671506505-104676-6-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1671506505-104676-1-git-send-email-guwen@linux.alibaba.com>
References: <1671506505-104676-1-git-send-email-guwen@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since local sndbuf of SMC-D loopback connection shares the same
physical memory region with peer RMB, the logic of cursors update
needs to be adapted.

The main difference from original implementation is need to ensure
that the data copied to local sndbuf won't overwrite the unconsumed
data of peer.

So, for SMC-D loopback connections:

1. TX
        a. don't update fin_curs when send out cdc msg.
        b. fin_curs and sndbuf_space update will be deferred until
           receiving peer cons_curs update.

2. RX
        a. same as before. peer sndbuf is as large as local rmb,
           which guarantees that prod_curs will behind prep_curs.

Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/smc_cdc.c      | 53 +++++++++++++++++++++++++++++++++++++++-----------
 net/smc/smc_loopback.c |  7 +++++++
 2 files changed, 49 insertions(+), 11 deletions(-)

diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index 61f5ff7..586472a 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -253,17 +253,26 @@ int smcd_cdc_msg_send(struct smc_connection *conn)
 		return rc;
 	smc_curs_copy(&conn->rx_curs_confirmed, &curs, conn);
 	conn->local_rx_ctrl.prod_flags.cons_curs_upd_req = 0;
-	/* Calculate transmitted data and increment free send buffer space */
-	diff = smc_curs_diff(conn->sndbuf_desc->len, &conn->tx_curs_fin,
-			     &conn->tx_curs_sent);
-	/* increased by confirmed number of bytes */
-	smp_mb__before_atomic();
-	atomic_add(diff, &conn->sndbuf_space);
-	/* guarantee 0 <= sndbuf_space <= sndbuf_desc->len */
-	smp_mb__after_atomic();
-	smc_curs_copy(&conn->tx_curs_fin, &conn->tx_curs_sent, conn);
+	if (!conn->lgr->smcd->is_loopback) {
+		/* Note:
+		 * For smcd loopback device:
+		 *
+		 * Don't update the fin_curs and sndbuf_space here.
+		 * Update fin_curs when peer consumes the data in RMB.
+		 */
 
-	smc_tx_sndbuf_nonfull(smc);
+		/* Calculate transmitted data and increment free send buffer space */
+		diff = smc_curs_diff(conn->sndbuf_desc->len, &conn->tx_curs_fin,
+				     &conn->tx_curs_sent);
+		/* increased by confirmed number of bytes */
+		smp_mb__before_atomic();
+		atomic_add(diff, &conn->sndbuf_space);
+		/* guarantee 0 <= sndbuf_space <= sndbuf_desc->len */
+		smp_mb__after_atomic();
+		smc_curs_copy(&conn->tx_curs_fin, &conn->tx_curs_sent, conn);
+
+		smc_tx_sndbuf_nonfull(smc);
+	}
 	return rc;
 }
 
@@ -321,7 +330,7 @@ static void smc_cdc_msg_recv_action(struct smc_sock *smc,
 {
 	union smc_host_cursor cons_old, prod_old;
 	struct smc_connection *conn = &smc->conn;
-	int diff_cons, diff_prod;
+	int diff_cons, diff_prod, diff_tx;
 
 	smc_curs_copy(&prod_old, &conn->local_rx_ctrl.prod, conn);
 	smc_curs_copy(&cons_old, &conn->local_rx_ctrl.cons, conn);
@@ -337,6 +346,28 @@ static void smc_cdc_msg_recv_action(struct smc_sock *smc,
 		atomic_add(diff_cons, &conn->peer_rmbe_space);
 		/* guarantee 0 <= peer_rmbe_space <= peer_rmbe_size */
 		smp_mb__after_atomic();
+
+		/* For smcd loopback device:
+		 * Update of peer cons_curs indicates that
+		 * 1. peer rmbe space increases.
+		 * 2. local sndbuf space increases.
+		 *
+		 * So local sndbuf fin_curs should be equal to peer RMB cons_curs.
+		 */
+		if (conn->lgr->is_smcd &&
+		    conn->lgr->smcd->is_loopback) {
+			/* calculate peer rmb consumed data */
+			diff_tx = smc_curs_diff(conn->sndbuf_desc->len, &conn->tx_curs_fin,
+						&conn->local_rx_ctrl.cons);
+			/* increase local sndbuf space and fin_curs */
+			smp_mb__before_atomic();
+			atomic_add(diff_tx, &conn->sndbuf_space);
+			/* guarantee 0 <= sndbuf_space <= sndbuf_desc->len */
+			smp_mb__after_atomic();
+			smc_curs_copy(&conn->tx_curs_fin, &conn->local_rx_ctrl.cons, conn);
+
+			smc_tx_sndbuf_nonfull(smc);
+		}
 	}
 
 	diff_prod = smc_curs_diff(conn->rmb_desc->len, &prod_old,
diff --git a/net/smc/smc_loopback.c b/net/smc/smc_loopback.c
index bc3ff82..43f0287 100644
--- a/net/smc/smc_loopback.c
+++ b/net/smc/smc_loopback.c
@@ -216,6 +216,13 @@ static int lo_move_data(struct smcd_dev *smcd, u64 dmb_tok, unsigned int idx,
 	struct lo_dmb_node *rmb_node = NULL, *tmp_node;
 	struct lo_dev *ldev = smcd->priv;
 
+	if (!sf) {
+		/* no need to move data.
+		 * sndbuf is equal to peer rmb.
+		 */
+		return 0;
+	}
+
 	read_lock(&ldev->dmb_ht_lock);
 	hash_for_each_possible(ldev->dmb_ht, tmp_node, list, dmb_tok) {
 		if (tmp_node->token == dmb_tok) {
-- 
1.8.3.1

