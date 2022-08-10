Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C52D58F1C8
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 19:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbiHJRrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 13:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbiHJRrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 13:47:48 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DD386C17;
        Wed, 10 Aug 2022 10:47:46 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VLvtrmG_1660153663;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VLvtrmG_1660153663)
          by smtp.aliyun-inc.com;
          Thu, 11 Aug 2022 01:47:44 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net-next 02/10] net/smc: fix SMC_CLC_DECL_ERR_REGRMB without smc_server_lgr_pending
Date:   Thu, 11 Aug 2022 01:47:33 +0800
Message-Id: <01105a98ac715b6df6d019c0b6a9916814fdcff4.1660152975.git.alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1660152975.git.alibuda@linux.alibaba.com>
References: <cover.1660152975.git.alibuda@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

As commit "net/smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB error cause
by server" mentioned, it works only when all connection creations are
completely protected by smc_server_lgr_pending lock, since we already
cancel the lock, we need to re-fix the issues.

Fixes: 4940a1fdf31c ("net/smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB error cause by server")

Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 net/smc/af_smc.c   |  2 ++
 net/smc/smc_core.c | 11 ++++++++---
 net/smc/smc_core.h | 21 +++++++++++++++++++++
 3 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index af4b0aa..c0842a9 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2413,6 +2413,7 @@ static void smc_listen_work(struct work_struct *work)
 		if (rc)
 			goto out_unlock;
 	}
+	smc_conn_leave_rtoken_pending(new_smc, ini);
 	smc_conn_save_peer_info(new_smc, cclc);
 	smc_listen_out_connected(new_smc);
 	SMC_STAT_SERV_SUCC_INC(sock_net(newclcsock->sk), ini);
@@ -2422,6 +2423,7 @@ static void smc_listen_work(struct work_struct *work)
 	if (ini->is_smcd)
 		mutex_unlock(&smc_server_lgr_pending);
 out_decl:
+	smc_conn_leave_rtoken_pending(new_smc, ini);
 	smc_listen_decline(new_smc, rc, ini ? ini->first_contact_local : 0,
 			   proposal_version);
 out_free:
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index a3338cc..61a3854 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -2190,14 +2190,19 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
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
index 199f533..acc2869 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -293,6 +293,9 @@ struct smc_link_group {
 	struct rb_root		conns_all;	/* connection tree */
 	rwlock_t		conns_lock;	/* protects conns_all */
 	unsigned int		conns_num;	/* current # of connections */
+	atomic_t		rtoken_pendings;/* number of connection that
+						 * lgr assigned but no rtoken got yet
+						 */
 	unsigned short		vlan_id;	/* vlan id of link group */
 
 	struct list_head	sndbufs[SMC_RMBE_SIZES];/* tx buffers */
@@ -603,6 +606,24 @@ struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
 int smcr_nl_get_link(struct sk_buff *skb, struct netlink_callback *cb);
 int smcd_nl_get_lgr(struct sk_buff *skb, struct netlink_callback *cb);
 
+static inline void smc_conn_enter_rtoken_pending(struct smc_sock *smc, struct smc_init_info *ini)
+{
+	struct smc_link_group *lgr;
+
+	lgr = smc->conn.lgr;
+	if (lgr && !ini->first_contact_local)
+		atomic_inc(&lgr->rtoken_pendings);
+}
+
+static inline void smc_conn_leave_rtoken_pending(struct smc_sock *smc, struct smc_init_info *ini)
+{
+	struct smc_link_group *lgr;
+
+	lgr = smc->conn.lgr;
+	if (lgr && !ini->first_contact_local)
+		atomic_dec(&lgr->rtoken_pendings);
+}
+
 void smcr_lnk_cluster_on_lnk_state(struct smc_link *lnk);
 
 static inline struct smc_link_group *smc_get_lgr(struct smc_link *link)
-- 
1.8.3.1

