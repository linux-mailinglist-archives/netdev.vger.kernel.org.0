Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7201E4AD890
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 14:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbiBHNPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 08:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359762AbiBHMx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 07:53:27 -0500
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F3BC03FECA;
        Tue,  8 Feb 2022 04:53:26 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V3wCD9C_1644324803;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V3wCD9C_1644324803)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 08 Feb 2022 20:53:23 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        "D. Wythe" <alibuda@linux.alibaba.com>
Subject: [PATCH net-next v5 5/5] net/smc: Add global configure for auto fallback by netlink
Date:   Tue,  8 Feb 2022 20:53:13 +0800
Message-Id: <f54ee9f30898b998edf8f07dabccc84efaa2ab8b.1644323503.git.alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1644323503.git.alibuda@linux.alibaba.com>
References: <cover.1644323503.git.alibuda@linux.alibaba.com>
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
 include/uapi/linux/smc.h |  3 +++
 net/smc/af_smc.c         | 17 +++++++++++++++++
 net/smc/smc.h            |  7 +++++++
 net/smc/smc_core.c       |  2 ++
 net/smc/smc_netlink.c    | 10 ++++++++++
 5 files changed, 39 insertions(+)

diff --git a/include/uapi/linux/smc.h b/include/uapi/linux/smc.h
index 9f2cbf8..33f7fb8 100644
--- a/include/uapi/linux/smc.h
+++ b/include/uapi/linux/smc.h
@@ -59,6 +59,8 @@ enum {
 	SMC_NETLINK_DUMP_SEID,
 	SMC_NETLINK_ENABLE_SEID,
 	SMC_NETLINK_DISABLE_SEID,
+	SMC_NETLINK_ENABLE_AUTO_FALLBACK,
+	SMC_NETLINK_DISABLE_AUTO_FALLBACK,
 };
 
 /* SMC_GENL_FAMILY top level attributes */
@@ -85,6 +87,7 @@ enum {
 	SMC_NLA_SYS_LOCAL_HOST,		/* string */
 	SMC_NLA_SYS_SEID,		/* string */
 	SMC_NLA_SYS_IS_SMCR_V2,		/* u8 */
+	SMC_NLA_SYS_AUTO_FALLBACK,	/* u8 */
 	__SMC_NLA_SYS_MAX,
 	SMC_NLA_SYS_MAX = __SMC_NLA_SYS_MAX - 1
 };
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index c313561..4a25ce7 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -59,6 +59,8 @@
 						 * creation on client
 						 */
 
+bool smc_auto_fallback;	/* default behavior for auto fallback, disable by default */
+
 static struct workqueue_struct	*smc_tcp_ls_wq;	/* wq for tcp listen work */
 struct workqueue_struct	*smc_hs_wq;	/* wq for handshake work */
 struct workqueue_struct	*smc_close_wq;	/* wq for close work */
@@ -66,6 +68,18 @@
 static void smc_tcp_listen_work(struct work_struct *);
 static void smc_connect_work(struct work_struct *);
 
+int smc_enable_auto_fallback(struct sk_buff *skb, struct genl_info *info)
+{
+	WRITE_ONCE(smc_auto_fallback, true);
+	return 0;
+}
+
+int smc_disable_auto_fallback(struct sk_buff *skb, struct genl_info *info)
+{
+	WRITE_ONCE(smc_auto_fallback, false);
+	return 0;
+}
+
 static void smc_set_keepalive(struct sock *sk, int val)
 {
 	struct smc_sock *smc = smc_sk(sk);
@@ -3006,6 +3020,9 @@ static int __smc_create(struct net *net, struct socket *sock, int protocol,
 	smc->use_fallback = false; /* assume rdma capability first */
 	smc->fallback_rsn = 0;
 
+	/* default behavior from smc_auto_fallback */
+	smc->auto_fallback = READ_ONCE(smc_auto_fallback);
+
 	rc = 0;
 	if (!clcsock) {
 		rc = sock_create_kern(net, family, SOCK_STREAM, IPPROTO_TCP,
diff --git a/net/smc/smc.h b/net/smc/smc.h
index a0bdf75..ac75fe8 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -14,6 +14,7 @@
 #include <linux/socket.h>
 #include <linux/types.h>
 #include <linux/compiler.h> /* __aligned */
+#include <net/genetlink.h>
 #include <net/sock.h>
 
 #include "smc_ib.h"
@@ -336,4 +337,10 @@ void smc_fill_gid_list(struct smc_link_group *lgr,
 		       struct smc_gidlist *gidlist,
 		       struct smc_ib_device *known_dev, u8 *known_gid);
 
+extern bool smc_auto_fallback; /* default behavior for auto fallback */
+
+/* smc_auto_fallback setter for netlink */
+int smc_enable_auto_fallback(struct sk_buff *skb, struct genl_info *info);
+int smc_disable_auto_fallback(struct sk_buff *skb, struct genl_info *info);
+
 #endif	/* __SMC_H */
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 29525d0..cc9a398 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -248,6 +248,8 @@ int smc_nl_get_sys_info(struct sk_buff *skb, struct netlink_callback *cb)
 		goto errattr;
 	if (nla_put_u8(skb, SMC_NLA_SYS_IS_SMCR_V2, true))
 		goto errattr;
+	if (nla_put_u8(skb, SMC_NLA_SYS_AUTO_FALLBACK, smc_auto_fallback))
+		goto errattr;
 	smc_clc_get_hostname(&host);
 	if (host) {
 		memcpy(hostname, host, SMC_MAX_HOSTNAME_LEN);
diff --git a/net/smc/smc_netlink.c b/net/smc/smc_netlink.c
index f13ab06..a7de517 100644
--- a/net/smc/smc_netlink.c
+++ b/net/smc/smc_netlink.c
@@ -111,6 +111,16 @@
 		.flags = GENL_ADMIN_PERM,
 		.doit = smc_nl_disable_seid,
 	},
+	{
+		.cmd = SMC_NETLINK_ENABLE_AUTO_FALLBACK,
+		.flags = GENL_ADMIN_PERM,
+		.doit = smc_enable_auto_fallback,
+	},
+	{
+		.cmd = SMC_NETLINK_DISABLE_AUTO_FALLBACK,
+		.flags = GENL_ADMIN_PERM,
+		.doit = smc_disable_auto_fallback,
+	},
 };
 
 static const struct nla_policy smc_gen_nl_policy[2] = {
-- 
1.8.3.1

