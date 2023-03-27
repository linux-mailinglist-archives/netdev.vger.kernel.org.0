Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7634E6C9A33
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 05:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbjC0D3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 23:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232019AbjC0D3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 23:29:04 -0400
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72FC655A4;
        Sun, 26 Mar 2023 20:28:40 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R261e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0Vef4Ary_1679887715;
Received: from localhost(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0Vef4Ary_1679887715)
          by smtp.aliyun-inc.com;
          Mon, 27 Mar 2023 11:28:37 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        wintera@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v4 8/9] net/smc: Modify cursor update logic when using mappable DMB
Date:   Mon, 27 Mar 2023 11:28:18 +0800
Message-Id: <1679887699-54797-9-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1679887699-54797-1-git-send-email-guwen@linux.alibaba.com>
References: <1679887699-54797-1-git-send-email-guwen@linux.alibaba.com>
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since local sndbuf shares the same physical memory region with peer
RMB when using mappable DMBs, the cursor update logic needs to be
adapted.

The main concern is to ensure that the data written by local to this
memory region won't overwrite the data that has not been consumed by
the peer.

So in this scene, the fin_curs and sndbuf_space that were originally
updated when sending out CDC message are not updated until the cons_curs
update from the peer is received.

Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/smc_cdc.c | 50 +++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 39 insertions(+), 11 deletions(-)

diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index 2f79bac..915b8e7 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -18,6 +18,7 @@
 #include "smc_tx.h"
 #include "smc_rx.h"
 #include "smc_close.h"
+#include "smc_ism.h"
 
 /********************************** send *************************************/
 
@@ -256,17 +257,24 @@ int smcd_cdc_msg_send(struct smc_connection *conn)
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
+	if (!smc_ism_dmb_mappable(conn->lgr->smcd)) {
+		/* If local sndbuf has been mapped to peer RMB, then
+		 * don't update the tx_curs_fin and sndbuf_space until
+		 * peer has consumed the data in RMB.
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
 
@@ -324,7 +332,7 @@ static void smc_cdc_msg_recv_action(struct smc_sock *smc,
 {
 	union smc_host_cursor cons_old, prod_old;
 	struct smc_connection *conn = &smc->conn;
-	int diff_cons, diff_prod;
+	int diff_cons, diff_prod, diff_tx;
 
 	smc_curs_copy(&prod_old, &conn->local_rx_ctrl.prod, conn);
 	smc_curs_copy(&cons_old, &conn->local_rx_ctrl.cons, conn);
@@ -340,6 +348,26 @@ static void smc_cdc_msg_recv_action(struct smc_sock *smc,
 		atomic_add(diff_cons, &conn->peer_rmbe_space);
 		/* guarantee 0 <= peer_rmbe_space <= peer_rmbe_size */
 		smp_mb__after_atomic();
+
+		if (conn->lgr->is_smcd &&
+		    smc_ism_dmb_mappable(conn->lgr->smcd)) {
+			/* If local sndbuf has been mapped to peer RMB, then
+			 * update tx_curs_fin and sndbuf_space when peer has
+			 * consumed the data in it's RMB.
+			 */
+
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
-- 
1.8.3.1

