Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0705A2502
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 11:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239753AbiHZJwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 05:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344066AbiHZJwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 05:52:04 -0400
Received: from out199-9.us.a.mail.aliyun.com (out199-9.us.a.mail.aliyun.com [47.90.199.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60DF4D83D4;
        Fri, 26 Aug 2022 02:51:57 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VNIa0Hk_1661507512;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VNIa0Hk_1661507512)
          by smtp.aliyun-inc.com;
          Fri, 26 Aug 2022 17:51:53 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        "D. Wythe" <alibuda@linux.alibaba.com>
Subject: [PATCH net-next v2 02/10] net/smc: fix SMC_CLC_DECL_ERR_REGRMB without smc_server_lgr_pending
Date:   Fri, 26 Aug 2022 17:51:29 +0800
Message-Id: <f9d1129066bd2ed0c01fb01f3d4697ee99659667.1661407821.git.alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1661407821.git.alibuda@linux.alibaba.com>
References: <cover.1661407821.git.alibuda@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
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
 net/smc/smc_core.h | 18 ++++++++++++++++++
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index d0e6bec..ddca170 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2411,6 +2411,7 @@ static void smc_listen_work(struct work_struct *work)
 		if (rc)
 			goto out_unlock;
 	}
+	smc_conn_leave_rtoken_pending(new_smc, ini);
 	smc_conn_save_peer_info(new_smc, cclc);
 	smc_listen_out_connected(new_smc);
 	SMC_STAT_SERV_SUCC_INC(sock_net(newclcsock->sk), ini);
@@ -2420,6 +2421,7 @@ static void smc_listen_work(struct work_struct *work)
 	if (ini->is_smcd)
 		mutex_unlock(&smc_server_lgr_pending);
 out_decl:
+	smc_conn_leave_rtoken_pending(new_smc, ini);
 	smc_listen_decline(new_smc, rc, ini ? ini->first_contact_local : 0,
 			   proposal_version);
 out_free:
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index cfaddf2..f93c69f 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -2167,14 +2167,19 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
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
index 3c3bc11..a304ef3 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -298,6 +298,9 @@ struct smc_link_group {
 	struct rb_root		conns_all;	/* connection tree */
 	rwlock_t		conns_lock;	/* protects conns_all */
 	unsigned int		conns_num;	/* current # of connections */
+	atomic_t		rtoken_pendings;/* number of connection that
+						 * lgr assigned but no rtoken got yet
+						 */
 	unsigned short		vlan_id;	/* vlan id of link group */
 
 	struct list_head	sndbufs[SMC_RMBE_SIZES];/* tx buffers */
@@ -609,6 +612,21 @@ struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
 int smcd_nl_get_lgr(struct sk_buff *skb, struct netlink_callback *cb);
 
 void smcr_link_cluster_on_link_state(struct smc_link *lnk);
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
 
 static inline struct smc_link_group *smc_get_lgr(struct smc_link *link)
 {
-- 
1.8.3.1

