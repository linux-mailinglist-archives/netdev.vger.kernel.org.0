Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C65A51D095
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 07:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389087AbiEFF0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 01:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389085AbiEFF0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 01:26:15 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4195E765;
        Thu,  5 May 2022 22:22:31 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VCQBjlI_1651814548;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VCQBjlI_1651814548)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 06 May 2022 13:22:29 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net-next] net/smc: Fix smc-r link reference count
Date:   Fri,  6 May 2022 13:22:28 +0800
Message-Id: <1651814548-83231-1-git-send-email-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

The following scenarios exist:

lnk->refcnt=1;
smcr_link_put(lnk);
lnk->refcnt=0;
				smcr_link_hold(lnk);
__smcr_link_clear(lnk);
				do_xxx(lnk);

This patch try using refcount_inc_not_zero() instead refcount_inc()
to prevent this race condition. Therefore, we need to always check its
return value, and respond with an error when it fails.

Fixes: 20c9398d3309 ("net/smc: Resolve the race between SMC-R link access and clear")
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 net/smc/af_smc.c   |  3 +--
 net/smc/smc_core.c | 27 +++++++++++++++++++++------
 net/smc/smc_core.h |  4 ++--
 3 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 30acc31..b449c08 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1129,11 +1129,10 @@ static int smc_connect_rdma(struct smc_sock *smc,
 				break;
 			}
 		}
-		if (!link) {
+		if (!link || !smc_switch_link_and_count(&smc->conn, link)) {
 			reason_code = SMC_CLC_DECL_NOSRVLINK;
 			goto connect_abort;
 		}
-		smc_switch_link_and_count(&smc->conn, link);
 	}
 
 	/* create send buffer and rmb */
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 29525d0..f2d08b0 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -996,7 +996,7 @@ static int smc_switch_cursor(struct smc_sock *smc, struct smc_cdc_tx_pend *pend,
 	return rc;
 }
 
-void smc_switch_link_and_count(struct smc_connection *conn,
+bool smc_switch_link_and_count(struct smc_connection *conn,
 			       struct smc_link *to_lnk)
 {
 	atomic_dec(&conn->lnk->conn_cnt);
@@ -1005,7 +1005,7 @@ void smc_switch_link_and_count(struct smc_connection *conn,
 	conn->lnk = to_lnk;
 	atomic_inc(&conn->lnk->conn_cnt);
 	/* link_put in smc_conn_free() */
-	smcr_link_hold(conn->lnk);
+	return smcr_link_hold(conn->lnk);
 }
 
 struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
@@ -1029,11 +1029,21 @@ struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
 		    from_lnk->ibport == lgr->lnk[i].ibport) {
 			continue;
 		}
+
+		/* Try to hold a reference here. Once succeed,
+		 * all subsequent hold in smc_switch_link_and_count()  will not fail.
+		 * We can simplify the subsequent processing logic.
+		 */
+		if (!smcr_link_hold(&lgr->lnk[i]))
+			continue;
+
 		to_lnk = &lgr->lnk[i];
 		break;
 	}
 	if (!to_lnk || !smc_wr_tx_link_hold(to_lnk)) {
 		smc_lgr_terminate_sched(lgr);
+		if (to_lnk)
+			smcr_link_put(to_lnk); /* smcr_link_hold() above */
 		return NULL;
 	}
 again:
@@ -1056,6 +1066,7 @@ struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
 		    smc->sk.sk_state == SMC_PEERABORTWAIT ||
 		    smc->sk.sk_state == SMC_PROCESSABORT) {
 			spin_lock_bh(&conn->send_lock);
+			/* smcr_link_hold() already, won't fail */
 			smc_switch_link_and_count(conn, to_lnk);
 			spin_unlock_bh(&conn->send_lock);
 			continue;
@@ -1068,6 +1079,7 @@ struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
 			goto err_out;
 		/* avoid race with smcr_tx_sndbuf_nonempty() */
 		spin_lock_bh(&conn->send_lock);
+		/* smcr_link_hold() already, won't fail */
 		smc_switch_link_and_count(conn, to_lnk);
 		rc = smc_switch_cursor(smc, pend, wr_buf);
 		spin_unlock_bh(&conn->send_lock);
@@ -1078,11 +1090,13 @@ struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
 	}
 	read_unlock_bh(&lgr->conns_lock);
 	smc_wr_tx_link_put(to_lnk);
+	smcr_link_put(to_lnk); /* smcr_link_hold() above */
 	return to_lnk;
 
 err_out:
 	smcr_link_down_cond_sched(to_lnk);
 	smc_wr_tx_link_put(to_lnk);
+	smcr_link_put(to_lnk); /* smcr_link_hold() above */
 	return NULL;
 }
 
@@ -1260,9 +1274,9 @@ void smcr_link_clear(struct smc_link *lnk, bool log)
 	smcr_link_put(lnk); /* theoretically last link_put */
 }
 
-void smcr_link_hold(struct smc_link *lnk)
+bool smcr_link_hold(struct smc_link *lnk)
 {
-	refcount_inc(&lnk->refcnt);
+	return refcount_inc_not_zero(&lnk->refcnt);
 }
 
 void smcr_link_put(struct smc_link *lnk)
@@ -1904,8 +1918,9 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 		}
 	}
 	smc_lgr_hold(conn->lgr); /* lgr_put in smc_conn_free() */
-	if (!conn->lgr->is_smcd)
-		smcr_link_hold(conn->lnk); /* link_put in smc_conn_free() */
+	if (!conn->lgr->is_smcd && !smcr_link_hold(conn->lnk))
+		return SMC_CLC_DECL_NOACTLINK;
+
 	conn->freed = 0;
 	conn->local_tx_ctrl.common.type = SMC_CDC_MSG_TYPE;
 	conn->local_tx_ctrl.len = SMC_WR_TX_SIZE;
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 4cb03e9..9e2f67d 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -528,9 +528,9 @@ void smc_rtoken_set2(struct smc_link_group *lgr, int rtok_idx, int link_id,
 int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 		   u8 link_idx, struct smc_init_info *ini);
 void smcr_link_clear(struct smc_link *lnk, bool log);
-void smcr_link_hold(struct smc_link *lnk);
+bool smcr_link_hold(struct smc_link *lnk);
 void smcr_link_put(struct smc_link *lnk);
-void smc_switch_link_and_count(struct smc_connection *conn,
+bool smc_switch_link_and_count(struct smc_connection *conn,
 			       struct smc_link *to_lnk);
 int smcr_buf_map_lgr(struct smc_link *lnk);
 int smcr_buf_reg_lgr(struct smc_link *lnk);
-- 
1.8.3.1

