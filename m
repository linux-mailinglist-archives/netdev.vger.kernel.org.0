Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D881E85C0
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 19:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbgE2Ru4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 13:50:56 -0400
Received: from correo.us.es ([193.147.175.20]:58866 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727922AbgE2Rui (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 13:50:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 006128140A
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 19:50:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E854CDA714
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 19:50:36 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DDC0ADA705; Fri, 29 May 2020 19:50:36 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9DA74DA716;
        Fri, 29 May 2020 19:50:34 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 29 May 2020 19:50:34 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 722C342EE38E;
        Fri, 29 May 2020 19:50:34 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 9/9] netfilter: nf_tables: skip flowtable hooknum and priority on device updates
Date:   Fri, 29 May 2020 19:50:26 +0200
Message-Id: <20200529175026.30541-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200529175026.30541-1-pablo@netfilter.org>
References: <20200529175026.30541-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On device updates, the hooknum and priority attributes are not required.
This patch makes optional these two netlink attributes.

Moreover, bail out with EOPNOTSUPP if userspace tries to update the
hooknum and priority for existing flowtables.

While at this, turn EINVAL into EOPNOTSUPP in case the hooknum is not
ingress. EINVAL is reserved for missing netlink attribute / malformed
netlink messages.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 53 +++++++++++++++++++++++------------
 1 file changed, 35 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 897ac5fbe079..073aa1051d43 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6195,7 +6195,7 @@ static const struct nla_policy nft_flowtable_hook_policy[NFTA_FLOWTABLE_HOOK_MAX
 static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
 				    const struct nlattr *attr,
 				    struct nft_flowtable_hook *flowtable_hook,
-				    struct nf_flowtable *ft)
+				    struct nft_flowtable *flowtable, bool add)
 {
 	struct nlattr *tb[NFTA_FLOWTABLE_HOOK_MAX + 1];
 	struct nft_hook *hook;
@@ -6209,15 +6209,35 @@ static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
-	if (!tb[NFTA_FLOWTABLE_HOOK_NUM] ||
-	    !tb[NFTA_FLOWTABLE_HOOK_PRIORITY])
-		return -EINVAL;
+	if (add) {
+		if (!tb[NFTA_FLOWTABLE_HOOK_NUM] ||
+		    !tb[NFTA_FLOWTABLE_HOOK_PRIORITY])
+			return -EINVAL;
 
-	hooknum = ntohl(nla_get_be32(tb[NFTA_FLOWTABLE_HOOK_NUM]));
-	if (hooknum != NF_NETDEV_INGRESS)
-		return -EINVAL;
+		hooknum = ntohl(nla_get_be32(tb[NFTA_FLOWTABLE_HOOK_NUM]));
+		if (hooknum != NF_NETDEV_INGRESS)
+			return -EOPNOTSUPP;
+
+		priority = ntohl(nla_get_be32(tb[NFTA_FLOWTABLE_HOOK_PRIORITY]));
+
+		flowtable_hook->priority	= priority;
+		flowtable_hook->num		= hooknum;
+	} else {
+		if (tb[NFTA_FLOWTABLE_HOOK_NUM]) {
+			hooknum = ntohl(nla_get_be32(tb[NFTA_FLOWTABLE_HOOK_NUM]));
+			if (hooknum != flowtable->hooknum)
+				return -EOPNOTSUPP;
+		}
+
+		if (tb[NFTA_FLOWTABLE_HOOK_PRIORITY]) {
+			priority = ntohl(nla_get_be32(tb[NFTA_FLOWTABLE_HOOK_PRIORITY]));
+			if (priority != flowtable->data.priority)
+				return -EOPNOTSUPP;
+		}
 
-	priority = ntohl(nla_get_be32(tb[NFTA_FLOWTABLE_HOOK_PRIORITY]));
+		flowtable_hook->priority	= flowtable->data.priority;
+		flowtable_hook->num		= flowtable->hooknum;
+	}
 
 	if (tb[NFTA_FLOWTABLE_HOOK_DEVS]) {
 		err = nf_tables_parse_netdev_hooks(ctx->net,
@@ -6227,15 +6247,12 @@ static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
 			return err;
 	}
 
-	flowtable_hook->priority	= priority;
-	flowtable_hook->num		= hooknum;
-
 	list_for_each_entry(hook, &flowtable_hook->list, list) {
 		hook->ops.pf		= NFPROTO_NETDEV;
-		hook->ops.hooknum	= hooknum;
-		hook->ops.priority	= priority;
-		hook->ops.priv		= ft;
-		hook->ops.hook		= ft->type->hook;
+		hook->ops.hooknum	= flowtable_hook->num;
+		hook->ops.priority	= flowtable_hook->priority;
+		hook->ops.priv		= &flowtable->data;
+		hook->ops.hook		= flowtable->data.type->hook;
 	}
 
 	return err;
@@ -6363,7 +6380,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 	int err;
 
 	err = nft_flowtable_parse_hook(ctx, nla[NFTA_FLOWTABLE_HOOK],
-				       &flowtable_hook, &flowtable->data);
+				       &flowtable_hook, flowtable, false);
 	if (err < 0)
 		return err;
 
@@ -6492,7 +6509,7 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 		goto err3;
 
 	err = nft_flowtable_parse_hook(&ctx, nla[NFTA_FLOWTABLE_HOOK],
-				       &flowtable_hook, &flowtable->data);
+				       &flowtable_hook, flowtable, true);
 	if (err < 0)
 		goto err4;
 
@@ -6543,7 +6560,7 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 	int err;
 
 	err = nft_flowtable_parse_hook(ctx, nla[NFTA_FLOWTABLE_HOOK],
-				       &flowtable_hook, &flowtable->data);
+				       &flowtable_hook, flowtable, false);
 	if (err < 0)
 		return err;
 
-- 
2.20.1

