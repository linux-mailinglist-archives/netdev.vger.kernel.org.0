Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDCBC51F7F
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 02:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729355AbfFYAMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 20:12:50 -0400
Received: from mail.us.es ([193.147.175.20]:38006 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729281AbfFYAMt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 20:12:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C3975C04A7
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B310EDA70E
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:47 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A832BDA70B; Tue, 25 Jun 2019 02:12:47 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7250BDA705;
        Tue, 25 Jun 2019 02:12:45 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 25 Jun 2019 02:12:45 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 44BBA4265A2F;
        Tue, 25 Jun 2019 02:12:45 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 09/26] netfilter: nft_ct: add ct expectations support
Date:   Tue, 25 Jun 2019 02:12:16 +0200
Message-Id: <20190625001233.22057-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190625001233.22057-1-pablo@netfilter.org>
References: <20190625001233.22057-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stéphane Veyret <sveyret@gmail.com>

This patch allows to add, list and delete expectations via nft objref
infrastructure and assigning these expectations via nft rule.

This allows manual port triggering when no helper is defined to manage a
specific protocol. For example, if I have an online game which protocol
is based on initial connection to TCP port 9753 of the server, and where
the server opens a connection to port 9876, I can set rules as follow:

table ip filter {
    ct expectation mygame {
        protocol udp;
        dport 9876;
        timeout 2m;
        size 1;
    }

    chain input {
        type filter hook input priority 0; policy drop;
        tcp dport 9753 ct expectation set "mygame";
    }

    chain output {
        type filter hook output priority 0; policy drop;
        udp dport 9876 ct status expected accept;
    }
}

Signed-off-by: Stéphane Veyret <sveyret@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |  14 +++-
 net/netfilter/nft_ct.c                   | 138 ++++++++++++++++++++++++++++++-
 2 files changed, 149 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 505393c6e959..31a6b8f7ff73 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1445,6 +1445,17 @@ enum nft_ct_timeout_timeout_attributes {
 };
 #define NFTA_CT_TIMEOUT_MAX	(__NFTA_CT_TIMEOUT_MAX - 1)
 
+enum nft_ct_expectation_attributes {
+	NFTA_CT_EXPECT_UNSPEC,
+	NFTA_CT_EXPECT_L3PROTO,
+	NFTA_CT_EXPECT_L4PROTO,
+	NFTA_CT_EXPECT_DPORT,
+	NFTA_CT_EXPECT_TIMEOUT,
+	NFTA_CT_EXPECT_SIZE,
+	__NFTA_CT_EXPECT_MAX,
+};
+#define NFTA_CT_EXPECT_MAX	(__NFTA_CT_EXPECT_MAX - 1)
+
 #define NFT_OBJECT_UNSPEC	0
 #define NFT_OBJECT_COUNTER	1
 #define NFT_OBJECT_QUOTA	2
@@ -1454,7 +1465,8 @@ enum nft_ct_timeout_timeout_attributes {
 #define NFT_OBJECT_TUNNEL	6
 #define NFT_OBJECT_CT_TIMEOUT	7
 #define NFT_OBJECT_SECMARK	8
-#define __NFT_OBJECT_MAX	9
+#define NFT_OBJECT_CT_EXPECT	9
+#define __NFT_OBJECT_MAX	10
 #define NFT_OBJECT_MAX		(__NFT_OBJECT_MAX - 1)
 
 /**
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index f043936763f3..06b52c894573 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -24,6 +24,7 @@
 #include <net/netfilter/nf_conntrack_labels.h>
 #include <net/netfilter/nf_conntrack_timeout.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
+#include <net/netfilter/nf_conntrack_expect.h>
 
 struct nft_ct {
 	enum nft_ct_keys	key:8;
@@ -1156,6 +1157,131 @@ static struct nft_object_type nft_ct_helper_obj_type __read_mostly = {
 	.owner		= THIS_MODULE,
 };
 
+struct nft_ct_expect_obj {
+	u16		l3num;
+	__be16		dport;
+	u8		l4proto;
+	u8		size;
+	u32		timeout;
+};
+
+static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
+				  const struct nlattr * const tb[],
+				  struct nft_object *obj)
+{
+	struct nft_ct_expect_obj *priv = nft_obj_data(obj);
+
+	if (!tb[NFTA_CT_EXPECT_L4PROTO] ||
+	    !tb[NFTA_CT_EXPECT_DPORT] ||
+	    !tb[NFTA_CT_EXPECT_TIMEOUT] ||
+	    !tb[NFTA_CT_EXPECT_SIZE])
+		return -EINVAL;
+
+	priv->l3num = ctx->family;
+	if (tb[NFTA_CT_EXPECT_L3PROTO])
+		priv->l3num = ntohs(nla_get_be16(tb[NFTA_CT_EXPECT_L3PROTO]));
+
+	priv->l4proto = nla_get_u8(tb[NFTA_CT_EXPECT_L4PROTO]);
+	priv->dport = nla_get_be16(tb[NFTA_CT_EXPECT_DPORT]);
+	priv->timeout = nla_get_u32(tb[NFTA_CT_EXPECT_TIMEOUT]);
+	priv->size = nla_get_u8(tb[NFTA_CT_EXPECT_SIZE]);
+
+	return nf_ct_netns_get(ctx->net, ctx->family);
+}
+
+static void nft_ct_expect_obj_destroy(const struct nft_ctx *ctx,
+				       struct nft_object *obj)
+{
+	nf_ct_netns_put(ctx->net, ctx->family);
+}
+
+static int nft_ct_expect_obj_dump(struct sk_buff *skb,
+				  struct nft_object *obj, bool reset)
+{
+	const struct nft_ct_expect_obj *priv = nft_obj_data(obj);
+
+	if (nla_put_be16(skb, NFTA_CT_EXPECT_L3PROTO, htons(priv->l3num)) ||
+	    nla_put_u8(skb, NFTA_CT_EXPECT_L4PROTO, priv->l4proto) ||
+	    nla_put_be16(skb, NFTA_CT_EXPECT_DPORT, priv->dport) ||
+	    nla_put_u32(skb, NFTA_CT_EXPECT_TIMEOUT, priv->timeout) ||
+	    nla_put_u8(skb, NFTA_CT_EXPECT_SIZE, priv->size))
+		return -1;
+
+	return 0;
+}
+
+static void nft_ct_expect_obj_eval(struct nft_object *obj,
+				   struct nft_regs *regs,
+				   const struct nft_pktinfo *pkt)
+{
+	const struct nft_ct_expect_obj *priv = nft_obj_data(obj);
+	struct nf_conntrack_expect *exp;
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn_help *help;
+	enum ip_conntrack_dir dir;
+	u16 l3num = priv->l3num;
+	struct nf_conn *ct;
+
+	ct = nf_ct_get(pkt->skb, &ctinfo);
+	if (!ct || ctinfo == IP_CT_UNTRACKED) {
+		regs->verdict.code = NFT_BREAK;
+		return;
+	}
+	dir = CTINFO2DIR(ctinfo);
+
+	help = nfct_help(ct);
+	if (!help)
+		help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
+
+	if (help->expecting[NF_CT_EXPECT_CLASS_DEFAULT] >= priv->size) {
+		regs->verdict.code = NFT_BREAK;
+		return;
+	}
+	if (l3num == NFPROTO_INET)
+		l3num = nf_ct_l3num(ct);
+
+	exp = nf_ct_expect_alloc(ct);
+	if (exp == NULL) {
+		regs->verdict.code = NF_DROP;
+		return;
+	}
+	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, l3num,
+		          &ct->tuplehash[!dir].tuple.src.u3,
+		          &ct->tuplehash[!dir].tuple.dst.u3,
+		          priv->l4proto, NULL, &priv->dport);
+	exp->timeout.expires = jiffies + priv->timeout * HZ;
+
+	if (nf_ct_expect_related(exp) != 0)
+		regs->verdict.code = NF_DROP;
+}
+
+static const struct nla_policy nft_ct_expect_policy[NFTA_CT_EXPECT_MAX + 1] = {
+	[NFTA_CT_EXPECT_L3PROTO]	= { .type = NLA_U16 },
+	[NFTA_CT_EXPECT_L4PROTO]	= { .type = NLA_U8 },
+	[NFTA_CT_EXPECT_DPORT]		= { .type = NLA_U16 },
+	[NFTA_CT_EXPECT_TIMEOUT]	= { .type = NLA_U32 },
+	[NFTA_CT_EXPECT_SIZE]		= { .type = NLA_U8 },
+};
+
+static struct nft_object_type nft_ct_expect_obj_type;
+
+static const struct nft_object_ops nft_ct_expect_obj_ops = {
+	.type		= &nft_ct_expect_obj_type,
+	.size		= sizeof(struct nft_ct_expect_obj),
+	.eval		= nft_ct_expect_obj_eval,
+	.init		= nft_ct_expect_obj_init,
+	.destroy	= nft_ct_expect_obj_destroy,
+	.dump		= nft_ct_expect_obj_dump,
+};
+
+static struct nft_object_type nft_ct_expect_obj_type __read_mostly = {
+	.type		= NFT_OBJECT_CT_EXPECT,
+	.ops		= &nft_ct_expect_obj_ops,
+	.maxattr	= NFTA_CT_EXPECT_MAX,
+	.policy		= nft_ct_expect_policy,
+	.owner		= THIS_MODULE,
+};
+
 static int __init nft_ct_module_init(void)
 {
 	int err;
@@ -1173,17 +1299,23 @@ static int __init nft_ct_module_init(void)
 	err = nft_register_obj(&nft_ct_helper_obj_type);
 	if (err < 0)
 		goto err2;
+
+	err = nft_register_obj(&nft_ct_expect_obj_type);
+	if (err < 0)
+		goto err3;
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	err = nft_register_obj(&nft_ct_timeout_obj_type);
 	if (err < 0)
-		goto err3;
+		goto err4;
 #endif
 	return 0;
 
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
+err4:
+	nft_unregister_obj(&nft_ct_expect_obj_type);
+#endif
 err3:
 	nft_unregister_obj(&nft_ct_helper_obj_type);
-#endif
 err2:
 	nft_unregister_expr(&nft_notrack_type);
 err1:
@@ -1196,6 +1328,7 @@ static void __exit nft_ct_module_exit(void)
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	nft_unregister_obj(&nft_ct_timeout_obj_type);
 #endif
+	nft_unregister_obj(&nft_ct_expect_obj_type);
 	nft_unregister_obj(&nft_ct_helper_obj_type);
 	nft_unregister_expr(&nft_notrack_type);
 	nft_unregister_expr(&nft_ct_type);
@@ -1210,3 +1343,4 @@ MODULE_ALIAS_NFT_EXPR("ct");
 MODULE_ALIAS_NFT_EXPR("notrack");
 MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_CT_HELPER);
 MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_CT_TIMEOUT);
+MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_CT_EXPECT);
-- 
2.11.0

