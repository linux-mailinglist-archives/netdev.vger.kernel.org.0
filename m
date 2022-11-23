Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1D566364F0
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238983AbiKWPzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:55:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238181AbiKWPzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:55:22 -0500
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BACD297AA7;
        Wed, 23 Nov 2022 07:55:01 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VVXZuJe_1669218898;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VVXZuJe_1669218898)
          by smtp.aliyun-inc.com;
          Wed, 23 Nov 2022 23:54:59 +0800
From:   "D.Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net-next v5 03/10] net/smc: fix SMC_CLC_DECL_ERR_REGRMB without smc_server_lgr_pending
Date:   Wed, 23 Nov 2022 23:54:43 +0800
Message-Id: <1669218890-115854-4-git-send-email-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1669218890-115854-1-git-send-email-alibuda@linux.alibaba.com>
References: <1669218890-115854-1-git-send-email-alibuda@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

As commit 4940a1fdf31c ("net/smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB
error cause by server") mentioned, it works only when all connection
creations are completely protected by smc_server_lgr_pending, since we
already remove this lock, we need to re-fix the issues.

Fixes: 4940a1fdf31c ("net/smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB error cause by server")
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 net/smc/af_smc.c   |  2 ++
 net/smc/smc_core.c | 11 ++++++++---
 net/smc/smc_core.h | 19 +++++++++++++++++++
 3 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 8594927..7911caf 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2420,6 +2420,7 @@ static void smc_listen_work(struct work_struct *work)
 			goto out_unlock;
 		mutex_unlock(&smc_server_lgr_pending);
 	}
+	smc_conn_leave_rtoken_pending(new_smc, ini);
 	smc_conn_save_peer_info(new_smc, cclc);
 	smc_listen_out_connected(new_smc);
 	SMC_STAT_SERV_SUCC_INC(sock_net(newclcsock->sk), ini);
@@ -2428,6 +2429,7 @@ static void smc_listen_work(struct work_struct *work)
 out_unlock:
 	mutex_unlock(&smc_server_lgr_pending);
 out_decl:
+	smc_conn_leave_rtoken_pending(new_smc, ini);
 	smc_listen_decline(new_smc, rc, ini ? ini->first_contact_local : 0,
 			   proposal_version);
 out_free:
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 5982a00..8394086 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1882,14 +1882,19 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 		     lgr->vlan_id == ini->vlan_id) &&
 		    (role == SMC_CLNT || ini->is_smcd ||
 		    (lgr->conns_num < SMC_RMBS_PER_LGR_MAX &&
-		      !bitmap_full(lgr->rtokens_used_mask, SMC_RMBS_PER_LGR_MAX)))) {
+		    (SMC_RMBS_PER_LGR_MAX -
+			bitmap_weight(lgr->rtokens_used_mask, SMC_RMBS_PER_LGR_MAX)
+				> atomic_read(&lgr->rtoken_pendings))))) {
 			/* link group found */
 			ini->first_contact_local = 0;
 			conn->lgr = lgr;
 			rc = smc_lgr_register_conn(conn, false);
 			write_unlock_bh(&lgr->conns_lock);
-			if (!rc && delayed_work_pending(&lgr->free_work))
-				cancel_delayed_work(&lgr->free_work);
+			if (!rc) {
+				smc_conn_enter_rtoken_pending(smc, ini);
+				if (delayed_work_pending(&lgr->free_work))
+					cancel_delayed_work(&lgr->free_work);
+			}
 			break;
 		}
 		write_unlock_bh(&lgr->conns_lock);
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 285f9bd..678b2f3 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -249,6 +249,9 @@ struct smc_link_group {
 	struct rb_root		conns_all;	/* connection tree */
 	rwlock_t		conns_lock;	/* protects conns_all */
 	unsigned int		conns_num;	/* current # of connections */
+	atomic_t		rtoken_pendings;/* number of connection that
+						 * lgr assigned but no rtoken got yet
+						 */
 	unsigned short		vlan_id;	/* vlan id of link group */
 
 	struct list_head	sndbufs[SMC_RMBE_SIZES];/* tx buffers */
@@ -559,6 +562,22 @@ struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
 int smcr_nl_get_link(struct sk_buff *skb, struct netlink_callback *cb);
 int smcd_nl_get_lgr(struct sk_buff *skb, struct netlink_callback *cb);
 
+static inline void smc_conn_enter_rtoken_pending(struct smc_sock *smc, struct smc_init_info *ini)
+{
+	struct smc_link_group *lgr = smc->conn.lgr;
+
+	if (lgr && !ini->first_contact_local)
+		atomic_inc(&lgr->rtoken_pendings);
+}
+
+static inline void smc_conn_leave_rtoken_pending(struct smc_sock *smc, struct smc_init_info *ini)
+{
+	struct smc_link_group *lgr = smc->conn.lgr;
+
+	if (lgr && !ini->first_contact_local)
+		atomic_dec(&lgr->rtoken_pendings);
+}
+
 static inline struct smc_link_group *smc_get_lgr(struct smc_link *link)
 {
 	return link->lgr;
-- 
1.8.3.1

