Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF8A4860B0
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 07:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234210AbiAFGoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 01:44:25 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:42239 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229956AbiAFGoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 01:44:25 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V15.ucH_1641451455;
Received: from e02h04404.eu6sqa(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V15.ucH_1641451455)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 06 Jan 2022 14:44:22 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v4] net/smc: Reset conn->lgr when link group registration fails
Date:   Thu,  6 Jan 2022 14:44:15 +0800
Message-Id: <1641451455-41647-1-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SMC connections might fail to be registered in a link group due to
unable to find a link to assign to during its creation. As a result,
connection creation will return a failure and most resources related
to the connection won't be applied or initialized, such as
conn->abort_work or conn->lnk.

If smc_conn_free() is invoked later, it will try to access the
resources related to the connection, which wasn't initialized, thus
causing a warning or crash.

This patch tries to fix this by resetting conn->lgr to NULL if an
abnormal exit occurs in smc_lgr_register_conn(), thus avoiding the
access to uninitialized resources in smc_conn_free().

Meanwhile, the new created link group should be terminated if smc
connections can't be registered in it. So smc_lgr_cleanup_early() is
modified to take care of link group only and invoked to terminate
unusable link group by smc_conn_create(). The call to smc_conn_free()
is moved out from smc_lgr_cleanup_early() to smc_conn_abort().

Fixes: 56bc3b2094b4 ("net/smc: assign link to a new connection")
Suggested-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
v1->v2:
- Reset conn->lgr to NULL in smc_lgr_register_conn().
- Only free new created link group.
v2->v3:
- Using __smc_lgr_terminate() instead of smc_lgr_schedule_free_work()
  for an immediate free.
v3->v4:
- Modify smc_lgr_cleanup_early() and invoke it from smc_conn_create().
---
 net/smc/af_smc.c   |  7 ++++---
 net/smc/smc_core.c | 12 +++++++-----
 net/smc/smc_core.h |  2 +-
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 230072f..f22f3ca 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -630,10 +630,11 @@ static int smc_connect_decline_fallback(struct smc_sock *smc, int reason_code,
 
 static void smc_conn_abort(struct smc_sock *smc, int local_first)
 {
+	struct smc_connection *conn = &smc->conn;
+
+	smc_conn_free(conn);
 	if (local_first)
-		smc_lgr_cleanup_early(&smc->conn);
-	else
-		smc_conn_free(&smc->conn);
+		smc_lgr_cleanup_early(conn->lgr);
 }
 
 /* check if there is a rdma device available for this connection. */
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 412bc85..cd3c3b8 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -171,8 +171,10 @@ static int smc_lgr_register_conn(struct smc_connection *conn, bool first)
 
 	if (!conn->lgr->is_smcd) {
 		rc = smcr_lgr_conn_assign_link(conn, first);
-		if (rc)
+		if (rc) {
+			conn->lgr = NULL;
 			return rc;
+		}
 	}
 	/* find a new alert_token_local value not yet used by some connection
 	 * in this link group
@@ -622,15 +624,13 @@ int smcd_nl_get_lgr(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
-void smc_lgr_cleanup_early(struct smc_connection *conn)
+void smc_lgr_cleanup_early(struct smc_link_group *lgr)
 {
-	struct smc_link_group *lgr = conn->lgr;
 	spinlock_t *lgr_lock;
 
 	if (!lgr)
 		return;
 
-	smc_conn_free(conn);
 	smc_lgr_list_head(lgr, &lgr_lock);
 	spin_lock_bh(lgr_lock);
 	/* do not use this link group for new connections */
@@ -1835,8 +1835,10 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 		write_lock_bh(&lgr->conns_lock);
 		rc = smc_lgr_register_conn(conn, true);
 		write_unlock_bh(&lgr->conns_lock);
-		if (rc)
+		if (rc) {
+			smc_lgr_cleanup_early(lgr);
 			goto out;
+		}
 	}
 	conn->local_tx_ctrl.common.type = SMC_CDC_MSG_TYPE;
 	conn->local_tx_ctrl.len = SMC_WR_TX_SIZE;
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index d63b082..73d0c35 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -468,7 +468,7 @@ static inline void smc_set_pci_values(struct pci_dev *pci_dev,
 struct smc_sock;
 struct smc_clc_msg_accept_confirm;
 
-void smc_lgr_cleanup_early(struct smc_connection *conn);
+void smc_lgr_cleanup_early(struct smc_link_group *lgr);
 void smc_lgr_terminate_sched(struct smc_link_group *lgr);
 void smcr_port_add(struct smc_ib_device *smcibdev, u8 ibport);
 void smcr_port_err(struct smc_ib_device *smcibdev, u8 ibport);
-- 
1.8.3.1

