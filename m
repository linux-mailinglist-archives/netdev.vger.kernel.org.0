Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 484AE48D3B8
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 09:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233080AbiAMIg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 03:36:58 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:49193 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233055AbiAMIg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 03:36:56 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R551e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V1imC6N_1642063002;
Received: from e02h04404.eu6sqa(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V1imC6N_1642063002)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 13 Jan 2022 16:36:52 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v2 2/3] net/smc: Introduce a new conn->lgr validity check helper
Date:   Thu, 13 Jan 2022 16:36:41 +0800
Message-Id: <1642063002-45688-3-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1642063002-45688-1-git-send-email-guwen@linux.alibaba.com>
References: <1642063002-45688-1-git-send-email-guwen@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is no longer suitable to identify whether a smc connection
is registered in a link group through checking if conn->lgr
is NULL, because conn->lgr won't be reset even the connection
is unregistered from a link group.

So this patch introduces a new helper smc_conn_lgr_valid() and
replaces all the check of conn->lgr in original implementation
with the new helper to judge if conn->lgr is valid to use.

Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/af_smc.c   |  6 +++++-
 net/smc/smc_cdc.c  |  3 ++-
 net/smc/smc_clc.c  |  2 +-
 net/smc/smc_core.c | 14 ++++++++------
 net/smc/smc_core.h |  5 +++++
 net/smc/smc_diag.c |  6 +++---
 6 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 61bd002..eb724cb 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -634,9 +634,13 @@ static void smc_conn_abort(struct smc_sock *smc, int local_first)
 {
 	struct smc_connection *conn = &smc->conn;
 	struct smc_link_group *lgr = conn->lgr;
+	bool lgr_valid = false;
+
+	if (smc_conn_lgr_valid(conn))
+		lgr_valid = true;
 
 	smc_conn_free(conn);
-	if (local_first)
+	if (local_first && lgr_valid)
 		smc_lgr_cleanup_early(lgr);
 }
 
diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index 84c8a43..9d5a971 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -197,7 +197,8 @@ int smc_cdc_get_slot_and_msg_send(struct smc_connection *conn)
 {
 	int rc;
 
-	if (!conn->lgr || (conn->lgr->is_smcd && conn->lgr->peer_shutdown))
+	if (!smc_conn_lgr_valid(conn) ||
+	    (conn->lgr->is_smcd && conn->lgr->peer_shutdown))
 		return -EPIPE;
 
 	if (conn->lgr->is_smcd) {
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 8409ab7..5a21108 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -774,7 +774,7 @@ int smc_clc_send_decline(struct smc_sock *smc, u32 peer_diag_info, u8 version)
 	dclc.os_type = version == SMC_V1 ? 0 : SMC_CLC_OS_LINUX;
 	dclc.hdr.typev2 = (peer_diag_info == SMC_CLC_DECL_SYNCERR) ?
 						SMC_FIRST_CONTACT_MASK : 0;
-	if ((!smc->conn.lgr || !smc->conn.lgr->is_smcd) &&
+	if ((!smc_conn_lgr_valid(&smc->conn) || !smc->conn.lgr->is_smcd) &&
 	    smc_ib_is_valid_local_systemid())
 		memcpy(dclc.id_for_peer, local_systemid,
 		       sizeof(local_systemid));
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index d90e0af..bc4c615 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -211,7 +211,7 @@ static void smc_lgr_unregister_conn(struct smc_connection *conn)
 {
 	struct smc_link_group *lgr = conn->lgr;
 
-	if (!lgr)
+	if (!smc_conn_lgr_valid(conn))
 		return;
 	write_lock_bh(&lgr->conns_lock);
 	if (conn->alert_token_local) {
@@ -1129,7 +1129,7 @@ void smc_conn_free(struct smc_connection *conn)
 		return;
 
 	conn->freed = 1;
-	if (!conn->alert_token_local)
+	if (!smc_conn_lgr_valid(conn))
 		/* Connection has already unregistered from
 		 * link group.
 		 */
@@ -2263,14 +2263,16 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 
 void smc_sndbuf_sync_sg_for_cpu(struct smc_connection *conn)
 {
-	if (!conn->lgr || conn->lgr->is_smcd || !smc_link_active(conn->lnk))
+	if (!smc_conn_lgr_valid(conn) || conn->lgr->is_smcd ||
+	    !smc_link_active(conn->lnk))
 		return;
 	smc_ib_sync_sg_for_cpu(conn->lnk, conn->sndbuf_desc, DMA_TO_DEVICE);
 }
 
 void smc_sndbuf_sync_sg_for_device(struct smc_connection *conn)
 {
-	if (!conn->lgr || conn->lgr->is_smcd || !smc_link_active(conn->lnk))
+	if (!smc_conn_lgr_valid(conn) || conn->lgr->is_smcd ||
+	    !smc_link_active(conn->lnk))
 		return;
 	smc_ib_sync_sg_for_device(conn->lnk, conn->sndbuf_desc, DMA_TO_DEVICE);
 }
@@ -2279,7 +2281,7 @@ void smc_rmb_sync_sg_for_cpu(struct smc_connection *conn)
 {
 	int i;
 
-	if (!conn->lgr || conn->lgr->is_smcd)
+	if (!smc_conn_lgr_valid(conn) || conn->lgr->is_smcd)
 		return;
 	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
 		if (!smc_link_active(&conn->lgr->lnk[i]))
@@ -2293,7 +2295,7 @@ void smc_rmb_sync_sg_for_device(struct smc_connection *conn)
 {
 	int i;
 
-	if (!conn->lgr || conn->lgr->is_smcd)
+	if (!smc_conn_lgr_valid(conn) || conn->lgr->is_smcd)
 		return;
 	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
 		if (!smc_link_active(&conn->lgr->lnk[i]))
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index edbd401..630298b 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -408,6 +408,11 @@ static inline struct smc_connection *smc_lgr_find_conn(
 	return res;
 }
 
+static inline bool smc_conn_lgr_valid(struct smc_connection *conn)
+{
+	return conn->lgr && conn->alert_token_local;
+}
+
 /* returns true if the specified link is usable */
 static inline bool smc_link_usable(struct smc_link *lnk)
 {
diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
index c952986a..25ef26b 100644
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -89,7 +89,7 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
 	r->diag_state = sk->sk_state;
 	if (smc->use_fallback)
 		r->diag_mode = SMC_DIAG_MODE_FALLBACK_TCP;
-	else if (smc->conn.lgr && smc->conn.lgr->is_smcd)
+	else if (smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
 		r->diag_mode = SMC_DIAG_MODE_SMCD;
 	else
 		r->diag_mode = SMC_DIAG_MODE_SMCR;
@@ -142,7 +142,7 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
 			goto errout;
 	}
 
-	if (smc->conn.lgr && !smc->conn.lgr->is_smcd &&
+	if (smc_conn_lgr_valid(&smc->conn) && !smc->conn.lgr->is_smcd &&
 	    (req->diag_ext & (1 << (SMC_DIAG_LGRINFO - 1))) &&
 	    !list_empty(&smc->conn.lgr->list)) {
 		struct smc_diag_lgrinfo linfo = {
@@ -162,7 +162,7 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
 		if (nla_put(skb, SMC_DIAG_LGRINFO, sizeof(linfo), &linfo) < 0)
 			goto errout;
 	}
-	if (smc->conn.lgr && smc->conn.lgr->is_smcd &&
+	if (smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd &&
 	    (req->diag_ext & (1 << (SMC_DIAG_DMBINFO - 1))) &&
 	    !list_empty(&smc->conn.lgr->list)) {
 		struct smc_connection *conn = &smc->conn;
-- 
1.8.3.1

