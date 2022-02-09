Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 115994AF3BE
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 15:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234850AbiBIOLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 09:11:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234828AbiBIOLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 09:11:31 -0500
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C61C05CBA3;
        Wed,  9 Feb 2022 06:11:28 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V4.kjv9_1644415885;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V4.kjv9_1644415885)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Feb 2022 22:11:26 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        "D. Wythe" <alibuda@linux.alibaba.com>
Subject: [PATCH net-next v6 5/5] net/smc: Add global configure for auto fallback by netlink
Date:   Wed,  9 Feb 2022 22:11:15 +0800
Message-Id: <64348e3dcd0b74ed638e895fa217d03df9bec854.1644413637.git.alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1644413637.git.alibuda@linux.alibaba.com>
References: <cover.1644413637.git.alibuda@linux.alibaba.com>
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

Although we can control SMC auto fallback through socket options, which
means that applications who need it must modify their code. It's quite
troublesome for many existing applications. This patch modifies the
global default value of auto fallback through netlink, providing a way
to auto fallback without modifying any code for applications.

Suggested-by: Tony Lu <tonylu@linux.alibaba.com>
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 include/net/netns/smc.h  |  2 ++
 include/uapi/linux/smc.h | 11 +++++++++++
 net/smc/af_smc.c         | 41 +++++++++++++++++++++++++++++++++++++++++
 net/smc/smc.h            |  6 ++++++
 net/smc/smc_netlink.c    | 15 +++++++++++++++
 net/smc/smc_pnet.c       |  3 +++
 6 files changed, 78 insertions(+)

diff --git a/include/net/netns/smc.h b/include/net/netns/smc.h
index ea8a9cf..61646ff 100644
--- a/include/net/netns/smc.h
+++ b/include/net/netns/smc.h
@@ -12,5 +12,7 @@ struct netns_smc {
 	/* protect fback_rsn */
 	struct mutex			mutex_fback_rsn;
 	struct smc_stats_rsn		*fback_rsn;
+
+	bool				auto_fallback;	/* whether allow auto_fallback */
 };
 #endif
diff --git a/include/uapi/linux/smc.h b/include/uapi/linux/smc.h
index 9f2cbf8..28a590d 100644
--- a/include/uapi/linux/smc.h
+++ b/include/uapi/linux/smc.h
@@ -59,6 +59,9 @@ enum {
 	SMC_NETLINK_DUMP_SEID,
 	SMC_NETLINK_ENABLE_SEID,
 	SMC_NETLINK_DISABLE_SEID,
+	SMC_NETLINK_DUMP_AUTO_FALLBACK,
+	SMC_NETLINK_ENABLE_AUTO_FALLBACK,
+	SMC_NETLINK_DISABLE_AUTO_FALLBACK,
 };
 
 /* SMC_GENL_FAMILY top level attributes */
@@ -285,6 +288,14 @@ enum {
 	SMC_NLA_SEID_TABLE_MAX = __SMC_NLA_SEID_TABLE_MAX - 1
 };
 
+/* SMC_NETLINK_AUTO_FALLBACK attributes */
+enum {
+	SMC_NLA_AUTO_FALLBACK_UNSPEC,
+	SMC_NLA_AUTO_FALLBACK_ENABLED,	/* u8 */
+	__SMC_NLA_AUTO_FALLBACK_MAX,
+	SMC_NLA_AUTO_FALLBACK_MAX = __SMC_NLA_AUTO_FALLBACK_MAX - 1
+};
+
 /* SMC socket options */
 #define SMC_AUTO_FALLBACK 1	/* allow auto fallback to TCP */
 
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index c313561..5e56281 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -66,6 +66,44 @@
 static void smc_tcp_listen_work(struct work_struct *);
 static void smc_connect_work(struct work_struct *);
 
+int smc_nl_dump_auto_fallback(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct smc_nl_dmp_ctx *cb_ctx = smc_nl_dmp_ctx(cb);
+	void *hdr;
+
+	if (cb_ctx->pos[0])
+		goto out;
+
+	hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
+			  &smc_gen_nl_family, NLM_F_MULTI,
+			  SMC_NETLINK_DUMP_AUTO_FALLBACK);
+	if (!hdr)
+		return -ENOMEM;
+
+	if (nla_put_u8(skb, SMC_NLA_AUTO_FALLBACK_ENABLED, sock_net(skb->sk)->smc.auto_fallback))
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
+int smc_nl_enable_auto_fallback(struct sk_buff *skb, struct genl_info *info)
+{
+	sock_net(skb->sk)->smc.auto_fallback = true;
+	return 0;
+}
+
+int smc_nl_disable_auto_fallback(struct sk_buff *skb, struct genl_info *info)
+{
+	sock_net(skb->sk)->smc.auto_fallback = false;
+	return 0;
+}
+
 static void smc_set_keepalive(struct sock *sk, int val)
 {
 	struct smc_sock *smc = smc_sk(sk);
@@ -3006,6 +3044,9 @@ static int __smc_create(struct net *net, struct socket *sock, int protocol,
 	smc->use_fallback = false; /* assume rdma capability first */
 	smc->fallback_rsn = 0;
 
+	/* default behavior from auto_fallback */
+	smc->auto_fallback = net->smc.auto_fallback;
+
 	rc = 0;
 	if (!clcsock) {
 		rc = sock_create_kern(net, family, SOCK_STREAM, IPPROTO_TCP,
diff --git a/net/smc/smc.h b/net/smc/smc.h
index a0bdf75..4cfbd61 100644
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
 
+/* smc auto_fallback interface for netlink */
+int smc_nl_dump_auto_fallback(struct sk_buff *skb, struct netlink_callback *cb);
+int smc_nl_enable_auto_fallback(struct sk_buff *skb, struct genl_info *info);
+int smc_nl_disable_auto_fallback(struct sk_buff *skb, struct genl_info *info);
+
 #endif	/* __SMC_H */
diff --git a/net/smc/smc_netlink.c b/net/smc/smc_netlink.c
index f13ab06..9f3abf7 100644
--- a/net/smc/smc_netlink.c
+++ b/net/smc/smc_netlink.c
@@ -111,6 +111,21 @@
 		.flags = GENL_ADMIN_PERM,
 		.doit = smc_nl_disable_seid,
 	},
+	{
+		.cmd = SMC_NETLINK_DUMP_AUTO_FALLBACK,
+		/* can be retrieved by unprivileged users */
+		.dumpit = smc_nl_dump_auto_fallback,
+	},
+	{
+		.cmd = SMC_NETLINK_ENABLE_AUTO_FALLBACK,
+		.flags = GENL_ADMIN_PERM,
+		.doit = smc_nl_enable_auto_fallback,
+	},
+	{
+		.cmd = SMC_NETLINK_DISABLE_AUTO_FALLBACK,
+		.flags = GENL_ADMIN_PERM,
+		.doit = smc_nl_disable_auto_fallback,
+	},
 };
 
 static const struct nla_policy smc_gen_nl_policy[2] = {
diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 291f148..07d7ee8 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -868,6 +868,9 @@ int smc_pnet_net_init(struct net *net)
 
 	smc_pnet_create_pnetids_list(net);
 
+	/* disable auto fallback by default */
+	net->smc.auto_fallback = 0;
+
 	return 0;
 }
 
-- 
1.8.3.1

