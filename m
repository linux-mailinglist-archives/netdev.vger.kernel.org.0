Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B22D361D0E
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 12:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730165AbfGHKdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 06:33:12 -0400
Received: from mail.us.es ([193.147.175.20]:34318 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729419AbfGHKcx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 06:32:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 077EEBAE8E
        for <netdev@vger.kernel.org>; Mon,  8 Jul 2019 12:32:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E686E114D70
        for <netdev@vger.kernel.org>; Mon,  8 Jul 2019 12:32:48 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DBC48A0AC7; Mon,  8 Jul 2019 12:32:48 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DC5C110219C;
        Mon,  8 Jul 2019 12:32:45 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 08 Jul 2019 12:32:45 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id AFEE84265A2F;
        Mon,  8 Jul 2019 12:32:45 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 05/15] netfilter: nf_tables: Add synproxy support
Date:   Mon,  8 Jul 2019 12:32:27 +0200
Message-Id: <20190708103237.28061-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190708103237.28061-1-pablo@netfilter.org>
References: <20190708103237.28061-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

Add synproxy support for nf_tables. This behaves like the iptables
synproxy target but it is structured in a way that allows us to propose
improvements in the future.

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_synproxy.h |   1 +
 include/net/netfilter/nf_synproxy.h           |   5 +
 include/uapi/linux/netfilter/nf_synproxy.h    |   4 +
 include/uapi/linux/netfilter/nf_tables.h      |  16 ++
 net/netfilter/Kconfig                         |  11 +
 net/netfilter/Makefile                        |   1 +
 net/netfilter/nft_synproxy.c                  | 287 ++++++++++++++++++++++++++
 7 files changed, 325 insertions(+)
 create mode 100644 net/netfilter/nft_synproxy.c

diff --git a/include/net/netfilter/nf_conntrack_synproxy.h b/include/net/netfilter/nf_conntrack_synproxy.h
index c5659dcf5b1a..8f00125b06f4 100644
--- a/include/net/netfilter/nf_conntrack_synproxy.h
+++ b/include/net/netfilter/nf_conntrack_synproxy.h
@@ -2,6 +2,7 @@
 #ifndef _NF_CONNTRACK_SYNPROXY_H
 #define _NF_CONNTRACK_SYNPROXY_H
 
+#include <net/netfilter/nf_conntrack_seqadj.h>
 #include <net/netns/generic.h>
 
 struct nf_conn_synproxy {
diff --git a/include/net/netfilter/nf_synproxy.h b/include/net/netfilter/nf_synproxy.h
index 3e8b3f03b687..87d73fb5279d 100644
--- a/include/net/netfilter/nf_synproxy.h
+++ b/include/net/netfilter/nf_synproxy.h
@@ -39,6 +39,11 @@ unsigned int ipv6_synproxy_hook(void *priv, struct sk_buff *skb,
 				const struct nf_hook_state *nhs);
 int nf_synproxy_ipv6_init(struct synproxy_net *snet, struct net *net);
 void nf_synproxy_ipv6_fini(struct synproxy_net *snet, struct net *net);
+#else
+static inline int
+nf_synproxy_ipv6_init(struct synproxy_net *snet, struct net *net) { return 0; }
+static inline void
+nf_synproxy_ipv6_fini(struct synproxy_net *snet, struct net *net) {};
 #endif /* CONFIG_IPV6 */
 
 #endif /* _NF_SYNPROXY_SHARED_H */
diff --git a/include/uapi/linux/netfilter/nf_synproxy.h b/include/uapi/linux/netfilter/nf_synproxy.h
index 068d1b3a6f06..6f3791c8946f 100644
--- a/include/uapi/linux/netfilter/nf_synproxy.h
+++ b/include/uapi/linux/netfilter/nf_synproxy.h
@@ -9,6 +9,10 @@
 #define NF_SYNPROXY_OPT_SACK_PERM	0x04
 #define NF_SYNPROXY_OPT_TIMESTAMP	0x08
 #define NF_SYNPROXY_OPT_ECN		0x10
+#define NF_SYNPROXY_OPT_MASK		(NF_SYNPROXY_OPT_MSS | \
+					 NF_SYNPROXY_OPT_WSCALE | \
+					 NF_SYNPROXY_OPT_SACK_PERM | \
+					 NF_SYNPROXY_OPT_TIMESTAMP)
 
 struct nf_synproxy_info {
 	__u8	options;
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index c6c8ec5c7c00..c53d581643fe 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1552,6 +1552,22 @@ enum nft_osf_flags {
 };
 
 /**
+ * enum nft_synproxy_attributes - nf_tables synproxy expression netlink attributes
+ *
+ * @NFTA_SYNPROXY_MSS: mss value sent to the backend (NLA_U16)
+ * @NFTA_SYNPROXY_WSCALE: wscale value sent to the backend (NLA_U8)
+ * @NFTA_SYNPROXY_FLAGS: flags (NLA_U32)
+ */
+enum nft_synproxy_attributes {
+	NFTA_SYNPROXY_UNSPEC,
+	NFTA_SYNPROXY_MSS,
+	NFTA_SYNPROXY_WSCALE,
+	NFTA_SYNPROXY_FLAGS,
+	__NFTA_SYNPROXY_MAX,
+};
+#define NFTA_SYNPROXY_MAX (__NFTA_SYNPROXY_MAX - 1)
+
+/**
  * enum nft_device_attributes - nf_tables device netlink attributes
  *
  * @NFTA_DEVICE_NAME: name of this device (NLA_STRING)
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 21025c2c605b..d59742408d9b 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -651,6 +651,17 @@ config NFT_TPROXY
 	help
 	  This makes transparent proxy support available in nftables.
 
+config NFT_SYNPROXY
+	tristate "Netfilter nf_tables SYNPROXY expression support"
+	depends on NF_CONNTRACK && NETFILTER_ADVANCED
+	select NETFILTER_SYNPROXY
+	select SYN_COOKIES
+	help
+	  The SYNPROXY expression allows you to intercept TCP connections and
+	  establish them using syncookies before they are passed on to the
+	  server. This allows to avoid conntrack and server resource usage
+	  during SYN-flood attacks.
+
 if NF_TABLES_NETDEV
 
 config NF_DUP_NETDEV
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 72cca6b48960..deada20975ff 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -110,6 +110,7 @@ obj-$(CONFIG_NFT_SOCKET)	+= nft_socket.o
 obj-$(CONFIG_NFT_OSF)		+= nft_osf.o
 obj-$(CONFIG_NFT_TPROXY)	+= nft_tproxy.o
 obj-$(CONFIG_NFT_XFRM)		+= nft_xfrm.o
+obj-$(CONFIG_NFT_SYNPROXY)	+= nft_synproxy.o
 
 obj-$(CONFIG_NFT_NAT)		+= nft_chain_nat.o
 
diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
new file mode 100644
index 000000000000..80060ade8a5b
--- /dev/null
+++ b/net/netfilter/nft_synproxy.c
@@ -0,0 +1,287 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/types.h>
+#include <net/ip.h>
+#include <net/tcp.h>
+#include <net/netlink.h>
+#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_synproxy.h>
+#include <net/netfilter/nf_synproxy.h>
+#include <linux/netfilter/nf_tables.h>
+#include <linux/netfilter/nf_synproxy.h>
+
+struct nft_synproxy {
+	struct nf_synproxy_info	info;
+};
+
+static const struct nla_policy nft_synproxy_policy[NFTA_SYNPROXY_MAX + 1] = {
+	[NFTA_SYNPROXY_MSS]		= { .type = NLA_U16 },
+	[NFTA_SYNPROXY_WSCALE]		= { .type = NLA_U8 },
+	[NFTA_SYNPROXY_FLAGS]		= { .type = NLA_U32 },
+};
+
+static void nft_synproxy_tcp_options(struct synproxy_options *opts,
+				     const struct tcphdr *tcp,
+				     struct synproxy_net *snet,
+				     struct nf_synproxy_info *info,
+				     struct nft_synproxy *priv)
+{
+	this_cpu_inc(snet->stats->syn_received);
+	if (tcp->ece && tcp->cwr)
+		opts->options |= NF_SYNPROXY_OPT_ECN;
+
+	opts->options &= priv->info.options;
+	if (opts->options & NF_SYNPROXY_OPT_TIMESTAMP)
+		synproxy_init_timestamp_cookie(info, opts);
+	else
+		opts->options &= ~(NF_SYNPROXY_OPT_WSCALE |
+				   NF_SYNPROXY_OPT_SACK_PERM |
+				   NF_SYNPROXY_OPT_ECN);
+}
+
+static void nft_synproxy_eval_v4(const struct nft_expr *expr,
+				 struct nft_regs *regs,
+				 const struct nft_pktinfo *pkt,
+				 const struct tcphdr *tcp,
+				 struct tcphdr *_tcph,
+				 struct synproxy_options *opts)
+{
+	struct nft_synproxy *priv = nft_expr_priv(expr);
+	struct nf_synproxy_info info = priv->info;
+	struct net *net = nft_net(pkt);
+	struct synproxy_net *snet = synproxy_pernet(net);
+	struct sk_buff *skb = pkt->skb;
+
+	if (tcp->syn) {
+		/* Initial SYN from client */
+		nft_synproxy_tcp_options(opts, tcp, snet, &info, priv);
+		synproxy_send_client_synack(net, skb, tcp, opts);
+		consume_skb(skb);
+		regs->verdict.code = NF_STOLEN;
+	} else if (tcp->ack) {
+		/* ACK from client */
+		if (synproxy_recv_client_ack(net, skb, tcp, opts,
+					     ntohl(tcp->seq))) {
+			consume_skb(skb);
+			regs->verdict.code = NF_STOLEN;
+		} else {
+			regs->verdict.code = NF_DROP;
+		}
+	}
+}
+
+#if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
+static void nft_synproxy_eval_v6(const struct nft_expr *expr,
+				 struct nft_regs *regs,
+				 const struct nft_pktinfo *pkt,
+				 const struct tcphdr *tcp,
+				 struct tcphdr *_tcph,
+				 struct synproxy_options *opts)
+{
+	struct nft_synproxy *priv = nft_expr_priv(expr);
+	struct nf_synproxy_info info = priv->info;
+	struct net *net = nft_net(pkt);
+	struct synproxy_net *snet = synproxy_pernet(net);
+	struct sk_buff *skb = pkt->skb;
+
+	if (tcp->syn) {
+		/* Initial SYN from client */
+		nft_synproxy_tcp_options(opts, tcp, snet, &info, priv);
+		synproxy_send_client_synack_ipv6(net, skb, tcp, opts);
+		consume_skb(skb);
+		regs->verdict.code = NF_STOLEN;
+	} else if (tcp->ack) {
+		/* ACK from client */
+		if (synproxy_recv_client_ack_ipv6(net, skb, tcp, opts,
+						  ntohl(tcp->seq))) {
+			consume_skb(skb);
+			regs->verdict.code = NF_STOLEN;
+		} else {
+			regs->verdict.code = NF_DROP;
+		}
+	}
+}
+#endif /* CONFIG_NF_TABLES_IPV6*/
+
+static void nft_synproxy_eval(const struct nft_expr *expr,
+			      struct nft_regs *regs,
+			      const struct nft_pktinfo *pkt)
+{
+	struct synproxy_options opts = {};
+	struct sk_buff *skb = pkt->skb;
+	int thoff = pkt->xt.thoff;
+	const struct tcphdr *tcp;
+	struct tcphdr _tcph;
+
+	if (pkt->tprot != IPPROTO_TCP) {
+		regs->verdict.code = NFT_BREAK;
+		return;
+	}
+
+	if (nf_ip_checksum(skb, nft_hook(pkt), thoff, IPPROTO_TCP)) {
+		regs->verdict.code = NF_DROP;
+		return;
+	}
+
+	tcp = skb_header_pointer(skb, pkt->xt.thoff,
+				 sizeof(struct tcphdr),
+				 &_tcph);
+	if (!tcp) {
+		regs->verdict.code = NF_DROP;
+		return;
+	}
+
+	if (!synproxy_parse_options(skb, thoff, tcp, &opts)) {
+		regs->verdict.code = NF_DROP;
+		return;
+	}
+
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		nft_synproxy_eval_v4(expr, regs, pkt, tcp, &_tcph, &opts);
+		return;
+#if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
+	case htons(ETH_P_IPV6):
+		nft_synproxy_eval_v6(expr, regs, pkt, tcp, &_tcph, &opts);
+		return;
+#endif
+	}
+	regs->verdict.code = NFT_BREAK;
+}
+
+static int nft_synproxy_init(const struct nft_ctx *ctx,
+			     const struct nft_expr *expr,
+			     const struct nlattr * const tb[])
+{
+	struct synproxy_net *snet = synproxy_pernet(ctx->net);
+	struct nft_synproxy *priv = nft_expr_priv(expr);
+	u32 flags;
+	int err;
+
+	if (tb[NFTA_SYNPROXY_MSS])
+		priv->info.mss = ntohs(nla_get_be16(tb[NFTA_SYNPROXY_MSS]));
+	if (tb[NFTA_SYNPROXY_WSCALE])
+		priv->info.wscale = nla_get_u8(tb[NFTA_SYNPROXY_WSCALE]);
+	if (tb[NFTA_SYNPROXY_FLAGS]) {
+		flags = ntohl(nla_get_be32(tb[NFTA_SYNPROXY_FLAGS]));
+		if (flags & ~NF_SYNPROXY_OPT_MASK)
+			return -EOPNOTSUPP;
+		priv->info.options = flags;
+	}
+
+	err = nf_ct_netns_get(ctx->net, ctx->family);
+	if (err)
+		return err;
+
+	switch (ctx->family) {
+	case NFPROTO_IPV4:
+		err = nf_synproxy_ipv4_init(snet, ctx->net);
+		if (err)
+			goto nf_ct_failure;
+		break;
+#if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
+	case NFPROTO_IPV6:
+		err = nf_synproxy_ipv6_init(snet, ctx->net);
+		if (err)
+			goto nf_ct_failure;
+		break;
+#endif
+	case NFPROTO_INET:
+	case NFPROTO_BRIDGE:
+		err = nf_synproxy_ipv4_init(snet, ctx->net);
+		if (err)
+			goto nf_ct_failure;
+		err = nf_synproxy_ipv6_init(snet, ctx->net);
+		if (err)
+			goto nf_ct_failure;
+		break;
+	}
+
+	return 0;
+
+nf_ct_failure:
+	nf_ct_netns_put(ctx->net, ctx->family);
+	return err;
+}
+
+static void nft_synproxy_destroy(const struct nft_ctx *ctx,
+				 const struct nft_expr *expr)
+{
+	struct synproxy_net *snet = synproxy_pernet(ctx->net);
+
+	switch (ctx->family) {
+	case NFPROTO_IPV4:
+		nf_synproxy_ipv4_fini(snet, ctx->net);
+		break;
+#if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
+	case NFPROTO_IPV6:
+		nf_synproxy_ipv6_fini(snet, ctx->net);
+		break;
+#endif
+	case NFPROTO_INET:
+	case NFPROTO_BRIDGE:
+		nf_synproxy_ipv4_fini(snet, ctx->net);
+		nf_synproxy_ipv6_fini(snet, ctx->net);
+		break;
+	}
+	nf_ct_netns_put(ctx->net, ctx->family);
+}
+
+static int nft_synproxy_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	const struct nft_synproxy *priv = nft_expr_priv(expr);
+
+	if (nla_put_be16(skb, NFTA_SYNPROXY_MSS, htons(priv->info.mss)) ||
+	    nla_put_u8(skb, NFTA_SYNPROXY_WSCALE, priv->info.wscale) ||
+	    nla_put_be32(skb, NFTA_SYNPROXY_FLAGS, htonl(priv->info.options)))
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static int nft_synproxy_validate(const struct nft_ctx *ctx,
+				 const struct nft_expr *expr,
+				 const struct nft_data **data)
+{
+	return nft_chain_validate_hooks(ctx->chain, (1 << NF_INET_LOCAL_IN) |
+						    (1 << NF_INET_FORWARD));
+}
+
+static struct nft_expr_type nft_synproxy_type;
+static const struct nft_expr_ops nft_synproxy_ops = {
+	.eval		= nft_synproxy_eval,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_synproxy)),
+	.init		= nft_synproxy_init,
+	.destroy	= nft_synproxy_destroy,
+	.dump		= nft_synproxy_dump,
+	.type		= &nft_synproxy_type,
+	.validate	= nft_synproxy_validate,
+};
+
+static struct nft_expr_type nft_synproxy_type __read_mostly = {
+	.ops		= &nft_synproxy_ops,
+	.name		= "synproxy",
+	.owner		= THIS_MODULE,
+	.policy		= nft_synproxy_policy,
+	.maxattr	= NFTA_SYNPROXY_MAX,
+};
+
+static int __init nft_synproxy_module_init(void)
+{
+	return nft_register_expr(&nft_synproxy_type);
+}
+
+static void __exit nft_synproxy_module_exit(void)
+{
+	return nft_unregister_expr(&nft_synproxy_type);
+}
+
+module_init(nft_synproxy_module_init);
+module_exit(nft_synproxy_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Fernando Fernandez <ffmancera@riseup.net>");
+MODULE_ALIAS_NFT_EXPR("synproxy");
-- 
2.11.0

