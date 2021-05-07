Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9743737699F
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 19:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhEGRsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 13:48:46 -0400
Received: from mail.netfilter.org ([217.70.188.207]:49090 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbhEGRsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 13:48:45 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id AE0E76414C;
        Fri,  7 May 2021 19:46:58 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 1/8] netfilter: xt_SECMARK: add new revision to fix structure layout
Date:   Fri,  7 May 2021 19:47:32 +0200
Message-Id: <20210507174739.1850-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210507174739.1850-1-pablo@netfilter.org>
References: <20210507174739.1850-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This extension breaks when trying to delete rules, add a new revision to
fix this.

Fixes: 5e6874cdb8de ("[SECMARK]: Add xtables SECMARK target")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/xt_SECMARK.h |  6 ++
 net/netfilter/xt_SECMARK.c                | 88 ++++++++++++++++++-----
 2 files changed, 75 insertions(+), 19 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_SECMARK.h b/include/uapi/linux/netfilter/xt_SECMARK.h
index 1f2a708413f5..beb2cadba8a9 100644
--- a/include/uapi/linux/netfilter/xt_SECMARK.h
+++ b/include/uapi/linux/netfilter/xt_SECMARK.h
@@ -20,4 +20,10 @@ struct xt_secmark_target_info {
 	char secctx[SECMARK_SECCTX_MAX];
 };
 
+struct xt_secmark_target_info_v1 {
+	__u8 mode;
+	char secctx[SECMARK_SECCTX_MAX];
+	__u32 secid;
+};
+
 #endif /*_XT_SECMARK_H_target */
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 75625d13e976..498a0bf6f044 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -24,10 +24,9 @@ MODULE_ALIAS("ip6t_SECMARK");
 static u8 mode;
 
 static unsigned int
-secmark_tg(struct sk_buff *skb, const struct xt_action_param *par)
+secmark_tg(struct sk_buff *skb, const struct xt_secmark_target_info_v1 *info)
 {
 	u32 secmark = 0;
-	const struct xt_secmark_target_info *info = par->targinfo;
 
 	switch (mode) {
 	case SECMARK_MODE_SEL:
@@ -41,7 +40,7 @@ secmark_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	return XT_CONTINUE;
 }
 
-static int checkentry_lsm(struct xt_secmark_target_info *info)
+static int checkentry_lsm(struct xt_secmark_target_info_v1 *info)
 {
 	int err;
 
@@ -73,15 +72,15 @@ static int checkentry_lsm(struct xt_secmark_target_info *info)
 	return 0;
 }
 
-static int secmark_tg_check(const struct xt_tgchk_param *par)
+static int
+secmark_tg_check(const char *table, struct xt_secmark_target_info_v1 *info)
 {
-	struct xt_secmark_target_info *info = par->targinfo;
 	int err;
 
-	if (strcmp(par->table, "mangle") != 0 &&
-	    strcmp(par->table, "security") != 0) {
+	if (strcmp(table, "mangle") != 0 &&
+	    strcmp(table, "security") != 0) {
 		pr_info_ratelimited("only valid in \'mangle\' or \'security\' table, not \'%s\'\n",
-				    par->table);
+				    table);
 		return -EINVAL;
 	}
 
@@ -116,25 +115,76 @@ static void secmark_tg_destroy(const struct xt_tgdtor_param *par)
 	}
 }
 
-static struct xt_target secmark_tg_reg __read_mostly = {
-	.name       = "SECMARK",
-	.revision   = 0,
-	.family     = NFPROTO_UNSPEC,
-	.checkentry = secmark_tg_check,
-	.destroy    = secmark_tg_destroy,
-	.target     = secmark_tg,
-	.targetsize = sizeof(struct xt_secmark_target_info),
-	.me         = THIS_MODULE,
+static int secmark_tg_check_v0(const struct xt_tgchk_param *par)
+{
+	struct xt_secmark_target_info *info = par->targinfo;
+	struct xt_secmark_target_info_v1 newinfo = {
+		.mode	= info->mode,
+	};
+	int ret;
+
+	memcpy(newinfo.secctx, info->secctx, SECMARK_SECCTX_MAX);
+
+	ret = secmark_tg_check(par->table, &newinfo);
+	info->secid = newinfo.secid;
+
+	return ret;
+}
+
+static unsigned int
+secmark_tg_v0(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct xt_secmark_target_info *info = par->targinfo;
+	struct xt_secmark_target_info_v1 newinfo = {
+		.secid	= info->secid,
+	};
+
+	return secmark_tg(skb, &newinfo);
+}
+
+static int secmark_tg_check_v1(const struct xt_tgchk_param *par)
+{
+	return secmark_tg_check(par->table, par->targinfo);
+}
+
+static unsigned int
+secmark_tg_v1(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	return secmark_tg(skb, par->targinfo);
+}
+
+static struct xt_target secmark_tg_reg[] __read_mostly = {
+	{
+		.name		= "SECMARK",
+		.revision	= 0,
+		.family		= NFPROTO_UNSPEC,
+		.checkentry	= secmark_tg_check_v0,
+		.destroy	= secmark_tg_destroy,
+		.target		= secmark_tg_v0,
+		.targetsize	= sizeof(struct xt_secmark_target_info),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "SECMARK",
+		.revision	= 1,
+		.family		= NFPROTO_UNSPEC,
+		.checkentry	= secmark_tg_check_v1,
+		.destroy	= secmark_tg_destroy,
+		.target		= secmark_tg_v1,
+		.targetsize	= sizeof(struct xt_secmark_target_info_v1),
+		.usersize	= offsetof(struct xt_secmark_target_info_v1, secid),
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init secmark_tg_init(void)
 {
-	return xt_register_target(&secmark_tg_reg);
+	return xt_register_targets(secmark_tg_reg, ARRAY_SIZE(secmark_tg_reg));
 }
 
 static void __exit secmark_tg_exit(void)
 {
-	xt_unregister_target(&secmark_tg_reg);
+	xt_unregister_targets(secmark_tg_reg, ARRAY_SIZE(secmark_tg_reg));
 }
 
 module_init(secmark_tg_init);
-- 
2.30.2

