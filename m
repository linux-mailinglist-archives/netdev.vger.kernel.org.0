Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12F6A254519
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 14:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbgH0Miw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 08:38:52 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:56874 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728334AbgH0M1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 08:27:17 -0400
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTPS id 33B3E44706A;
        Thu, 27 Aug 2020 14:19:27 +0200 (CEST)
Received: from dichtel by bretzel.dev.6wind.com with local (Exim 4.92)
        (envelope-from <dichtel@bretzel.dev.6wind.com>)
        id 1kBGsJ-0001v9-4i; Thu, 27 Aug 2020 14:19:27 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     davem@davemloft.net, kuba@kernel.org, pablo@netfilter.org,
        laforge@gnumonks.org, osmocom-net-gprs@lists.osmocom.org
Cc:     netdev@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Gabriel Ganne <gabriel.ganne@6wind.com>
Subject: [PATCH net-next v3] gtp: add notification mechanism
Date:   Thu, 27 Aug 2020 14:19:23 +0200
Message-Id: <20200827121923.7302-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200827090026.GK130874@nataraja>
References: <20200827090026.GK130874@nataraja>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Like all other network functions, let's notify gtp context on creation and
deletion.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Tested-by: Gabriel Ganne <gabriel.ganne@6wind.com>
Acked-by: Harald Welte <laforge@gnumonks.org>
---

v2 -> v3:
 - add ack from Harald
 - rebase on HEAD of net-next

v1 -> v2:
 - fix typo in the commit title
 - fix indentation of GTP_GENL_MCGRP

 drivers/net/gtp.c        | 58 +++++++++++++++++++++++++++++++++-------
 include/uapi/linux/gtp.h |  2 ++
 2 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 21640a035d7d..c84a10569388 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -928,8 +928,8 @@ static void ipv4_pdp_fill(struct pdp_ctx *pctx, struct genl_info *info)
 	}
 }
 
-static int gtp_pdp_add(struct gtp_dev *gtp, struct sock *sk,
-		       struct genl_info *info)
+static struct pdp_ctx *gtp_pdp_add(struct gtp_dev *gtp, struct sock *sk,
+				   struct genl_info *info)
 {
 	struct pdp_ctx *pctx, *pctx_tid = NULL;
 	struct net_device *dev = gtp->dev;
@@ -956,12 +956,12 @@ static int gtp_pdp_add(struct gtp_dev *gtp, struct sock *sk,
 
 	if (found) {
 		if (info->nlhdr->nlmsg_flags & NLM_F_EXCL)
-			return -EEXIST;
+			return ERR_PTR(-EEXIST);
 		if (info->nlhdr->nlmsg_flags & NLM_F_REPLACE)
-			return -EOPNOTSUPP;
+			return ERR_PTR(-EOPNOTSUPP);
 
 		if (pctx && pctx_tid)
-			return -EEXIST;
+			return ERR_PTR(-EEXIST);
 		if (!pctx)
 			pctx = pctx_tid;
 
@@ -974,13 +974,13 @@ static int gtp_pdp_add(struct gtp_dev *gtp, struct sock *sk,
 			netdev_dbg(dev, "GTPv1-U: update tunnel id = %x/%x (pdp %p)\n",
 				   pctx->u.v1.i_tei, pctx->u.v1.o_tei, pctx);
 
-		return 0;
+		return pctx;
 
 	}
 
 	pctx = kmalloc(sizeof(*pctx), GFP_ATOMIC);
 	if (pctx == NULL)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	sock_hold(sk);
 	pctx->sk = sk;
@@ -1018,7 +1018,7 @@ static int gtp_pdp_add(struct gtp_dev *gtp, struct sock *sk,
 		break;
 	}
 
-	return 0;
+	return pctx;
 }
 
 static void pdp_context_free(struct rcu_head *head)
@@ -1036,9 +1036,12 @@ static void pdp_context_delete(struct pdp_ctx *pctx)
 	call_rcu(&pctx->rcu_head, pdp_context_free);
 }
 
+static int gtp_tunnel_notify(struct pdp_ctx *pctx, u8 cmd);
+
 static int gtp_genl_new_pdp(struct sk_buff *skb, struct genl_info *info)
 {
 	unsigned int version;
+	struct pdp_ctx *pctx;
 	struct gtp_dev *gtp;
 	struct sock *sk;
 	int err;
@@ -1088,7 +1091,13 @@ static int gtp_genl_new_pdp(struct sk_buff *skb, struct genl_info *info)
 		goto out_unlock;
 	}
 
-	err = gtp_pdp_add(gtp, sk, info);
+	pctx = gtp_pdp_add(gtp, sk, info);
+	if (IS_ERR(pctx)) {
+		err = PTR_ERR(pctx);
+	} else {
+		gtp_tunnel_notify(pctx, GTP_CMD_NEWPDP);
+		err = 0;
+	}
 
 out_unlock:
 	rcu_read_unlock();
@@ -1159,6 +1168,7 @@ static int gtp_genl_del_pdp(struct sk_buff *skb, struct genl_info *info)
 		netdev_dbg(pctx->dev, "GTPv1-U: deleting tunnel id = %x/%x (pdp %p)\n",
 			   pctx->u.v1.i_tei, pctx->u.v1.o_tei, pctx);
 
+	gtp_tunnel_notify(pctx, GTP_CMD_DELPDP);
 	pdp_context_delete(pctx);
 
 out_unlock:
@@ -1168,6 +1178,14 @@ static int gtp_genl_del_pdp(struct sk_buff *skb, struct genl_info *info)
 
 static struct genl_family gtp_genl_family;
 
+enum gtp_multicast_groups {
+	GTP_GENL_MCGRP,
+};
+
+static const struct genl_multicast_group gtp_genl_mcgrps[] = {
+	[GTP_GENL_MCGRP] = { .name = GTP_GENL_MCGRP_NAME },
+};
+
 static int gtp_genl_fill_info(struct sk_buff *skb, u32 snd_portid, u32 snd_seq,
 			      int flags, u32 type, struct pdp_ctx *pctx)
 {
@@ -1204,6 +1222,26 @@ static int gtp_genl_fill_info(struct sk_buff *skb, u32 snd_portid, u32 snd_seq,
 	return -EMSGSIZE;
 }
 
+static int gtp_tunnel_notify(struct pdp_ctx *pctx, u8 cmd)
+{
+	struct sk_buff *msg;
+	int ret;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	if (!msg)
+		return -ENOMEM;
+
+	ret = gtp_genl_fill_info(msg, 0, 0, 0, cmd, pctx);
+	if (ret < 0) {
+		nlmsg_free(msg);
+		return ret;
+	}
+
+	ret = genlmsg_multicast_netns(&gtp_genl_family, dev_net(pctx->dev), msg,
+				      0, GTP_GENL_MCGRP, GFP_ATOMIC);
+	return ret;
+}
+
 static int gtp_genl_get_pdp(struct sk_buff *skb, struct genl_info *info)
 {
 	struct pdp_ctx *pctx = NULL;
@@ -1334,6 +1372,8 @@ static struct genl_family gtp_genl_family __ro_after_init = {
 	.module		= THIS_MODULE,
 	.ops		= gtp_genl_ops,
 	.n_ops		= ARRAY_SIZE(gtp_genl_ops),
+	.mcgrps		= gtp_genl_mcgrps,
+	.n_mcgrps	= ARRAY_SIZE(gtp_genl_mcgrps),
 };
 
 static int __net_init gtp_net_init(struct net *net)
diff --git a/include/uapi/linux/gtp.h b/include/uapi/linux/gtp.h
index c7d66755d212..79f9191bbb24 100644
--- a/include/uapi/linux/gtp.h
+++ b/include/uapi/linux/gtp.h
@@ -2,6 +2,8 @@
 #ifndef _UAPI_LINUX_GTP_H_
 #define _UAPI_LINUX_GTP_H_
 
+#define GTP_GENL_MCGRP_NAME	"gtp"
+
 enum gtp_genl_cmds {
 	GTP_CMD_NEWPDP,
 	GTP_CMD_DELPDP,
-- 
2.26.2

