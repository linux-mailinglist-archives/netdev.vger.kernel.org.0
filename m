Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDAE44B093A
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 10:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238291AbiBJJLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 04:11:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238283AbiBJJLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 04:11:46 -0500
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193061039;
        Thu, 10 Feb 2022 01:11:46 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V43kdh0_1644484302;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V43kdh0_1644484302)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 10 Feb 2022 17:11:43 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net-next v7 5/5] net/smc: Add global configure for handshake limitation by netlink
Date:   Thu, 10 Feb 2022 17:11:38 +0800
Message-Id: <d8bb3cbf1c532d5cf8048c67ccbf0b87664a00f4.1644481811.git.alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1644481811.git.alibuda@linux.alibaba.com>
References: <cover.1644481811.git.alibuda@linux.alibaba.com>
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

Although we can control SMC handshake limitation through socket options,
which means that applications who need it must modify their code. It's
quite troublesome for many existing applications. This patch modifies
the global default value of SMC handshake limitation through netlink,
providing a way to put constraint on handshake without modifies any code
for applications.

Suggested-by: Tony Lu <tonylu@linux.alibaba.com>
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 include/net/netns/smc.h  |  2 ++
 include/uapi/linux/smc.h | 11 +++++++++++
 net/smc/af_smc.c         | 42 ++++++++++++++++++++++++++++++++++++++++++
 net/smc/smc.h            |  6 ++++++
 net/smc/smc_netlink.c    | 15 +++++++++++++++
 net/smc/smc_pnet.c       |  3 +++
 6 files changed, 79 insertions(+)

diff --git a/include/net/netns/smc.h b/include/net/netns/smc.h
index ea8a9cf..47b1666 100644
--- a/include/net/netns/smc.h
+++ b/include/net/netns/smc.h
@@ -12,5 +12,7 @@ struct netns_smc {
 	/* protect fback_rsn */
 	struct mutex			mutex_fback_rsn;
 	struct smc_stats_rsn		*fback_rsn;
+
+	bool				limit_smc_hs;	/* constraint on handshake */
 };
 #endif
diff --git a/include/uapi/linux/smc.h b/include/uapi/linux/smc.h
index 343e745..693f549 100644
--- a/include/uapi/linux/smc.h
+++ b/include/uapi/linux/smc.h
@@ -59,6 +59,9 @@ enum {
 	SMC_NETLINK_DUMP_SEID,
 	SMC_NETLINK_ENABLE_SEID,
 	SMC_NETLINK_DISABLE_SEID,
+	SMC_NETLINK_DUMP_HS_LIMITATION,
+	SMC_NETLINK_ENABLE_HS_LIMITATION,
+	SMC_NETLINK_DISABLE_HS_LIMITATION,
 };
 
 /* SMC_GENL_FAMILY top level attributes */
@@ -285,6 +288,14 @@ enum {
 	SMC_NLA_SEID_TABLE_MAX = __SMC_NLA_SEID_TABLE_MAX - 1
 };
 
+/* SMC_NETLINK_HS_LIMITATION attributes */
+enum {
+	SMC_NLA_HS_LIMITATION_UNSPEC,
+	SMC_NLA_HS_LIMITATION_ENABLED,	/* u8 */
+	__SMC_NLA_HS_LIMITATION_MAX,
+	SMC_NLA_HS_LIMITATION_MAX = __SMC_NLA_HS_LIMITATION_MAX - 1
+};
+
 /* SMC socket options */
 #define SMC_LIMIT_HS 1	/* constraint on smc handshake */
 
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 97dcdc0..246c874 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -66,6 +66,45 @@
 static void smc_tcp_listen_work(struct work_struct *);
 static void smc_connect_work(struct work_struct *);
 
+int smc_nl_dump_hs_limitation(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct smc_nl_dmp_ctx *cb_ctx = smc_nl_dmp_ctx(cb);
+	void *hdr;
+
+	if (cb_ctx->pos[0])
+		goto out;
+
+	hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
+			  &smc_gen_nl_family, NLM_F_MULTI,
+			  SMC_NETLINK_DUMP_HS_LIMITATION);
+	if (!hdr)
+		return -ENOMEM;
+
+	if (nla_put_u8(skb, SMC_NLA_HS_LIMITATION_ENABLED,
+		       sock_net(skb->sk)->smc.limit_smc_hs))
+		goto err;
+
+	genlmsg_end(skb, hdr);
+	cb_ctx->pos[0] = 1;
+out:
+	return skb->len;
+err:
+	genlmsg_cancel(skb, hdr);
+	return -EMSGSIZE;
+}
+
+int smc_nl_enable_hs_limitation(struct sk_buff *skb, struct genl_info *info)
+{
+	sock_net(skb->sk)->smc.limit_smc_hs = true;
+	return 0;
+}
+
+int smc_nl_disable_hs_limitation(struct sk_buff *skb, struct genl_info *info)
+{
+	sock_net(skb->sk)->smc.limit_smc_hs = false;
+	return 0;
+}
+
 static void smc_set_keepalive(struct sock *sk, int val)
 {
 	struct smc_sock *smc = smc_sk(sk);
@@ -3007,6 +3046,9 @@ static int __smc_create(struct net *net, struct socket *sock, int protocol,
 	smc->use_fallback = false; /* assume rdma capability first */
 	smc->fallback_rsn = 0;
 
+	/* default behavior from limit_smc_hs in every net namespace */
+	smc->limit_smc_hs = net->smc.limit_smc_hs;
+
 	rc = 0;
 	if (!clcsock) {
 		rc = sock_create_kern(net, family, SOCK_STREAM, IPPROTO_TCP,
diff --git a/net/smc/smc.h b/net/smc/smc.h
index 7e26938..a096d8a 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -14,6 +14,7 @@
 #include <linux/socket.h>
 #include <linux/types.h>
 #include <linux/compiler.h> /* __aligned */
+#include <net/genetlink.h>
 #include <net/sock.h>
 
 #include "smc_ib.h"
@@ -336,4 +337,9 @@ void smc_fill_gid_list(struct smc_link_group *lgr,
 		       struct smc_gidlist *gidlist,
 		       struct smc_ib_device *known_dev, u8 *known_gid);
 
+/* smc handshake limitation interface for netlink  */
+int smc_nl_dump_hs_limitation(struct sk_buff *skb, struct netlink_callback *cb);
+int smc_nl_enable_hs_limitation(struct sk_buff *skb, struct genl_info *info);
+int smc_nl_disable_hs_limitation(struct sk_buff *skb, struct genl_info *info);
+
 #endif	/* __SMC_H */
diff --git a/net/smc/smc_netlink.c b/net/smc/smc_netlink.c
index f13ab06..c5a62f6 100644
--- a/net/smc/smc_netlink.c
+++ b/net/smc/smc_netlink.c
@@ -111,6 +111,21 @@
 		.flags = GENL_ADMIN_PERM,
 		.doit = smc_nl_disable_seid,
 	},
+	{
+		.cmd = SMC_NETLINK_DUMP_HS_LIMITATION,
+		/* can be retrieved by unprivileged users */
+		.dumpit = smc_nl_dump_hs_limitation,
+	},
+	{
+		.cmd = SMC_NETLINK_ENABLE_HS_LIMITATION,
+		.flags = GENL_ADMIN_PERM,
+		.doit = smc_nl_enable_hs_limitation,
+	},
+	{
+		.cmd = SMC_NETLINK_DISABLE_HS_LIMITATION,
+		.flags = GENL_ADMIN_PERM,
+		.doit = smc_nl_disable_hs_limitation,
+	},
 };
 
 static const struct nla_policy smc_gen_nl_policy[2] = {
diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 291f148..ed8951e 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -868,6 +868,9 @@ int smc_pnet_net_init(struct net *net)
 
 	smc_pnet_create_pnetids_list(net);
 
+	/* disable handshake limitation by default */
+	net->smc.limit_smc_hs = 0;
+
 	return 0;
 }
 
-- 
1.8.3.1

