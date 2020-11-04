Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFF92A661A
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730349AbgKDOM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:12:29 -0500
Received: from correo.us.es ([193.147.175.20]:35758 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726874AbgKDOMD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 09:12:03 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CC395B60E3
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 15:12:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AE559DA73F
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 15:12:00 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A3C9CDA730; Wed,  4 Nov 2020 15:12:00 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 421A0DA801;
        Wed,  4 Nov 2020 15:11:58 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 04 Nov 2020 15:11:58 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 0580742EF9E2;
        Wed,  4 Nov 2020 15:11:57 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 3/8] netfilter: nft_reject: add reject verdict support for netdev
Date:   Wed,  4 Nov 2020 15:11:44 +0100
Message-Id: <20201104141149.30082-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201104141149.30082-1-pablo@netfilter.org>
References: <20201104141149.30082-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jose M. Guisado Gomez" <guigom@riseup.net>

Adds support for reject from ingress hook in netdev family.
Both stacks ipv4 and ipv6.  With reject packets supporting ICMP
and TCP RST.

This ability is required in devices that need to REJECT legitimate
clients which traffic is forwarded from the ingress hook.

Joint work with Laura Garcia.

Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/Kconfig             |  10 ++
 net/netfilter/Makefile            |   1 +
 net/netfilter/nft_reject_netdev.c | 189 ++++++++++++++++++++++++++++++
 3 files changed, 200 insertions(+)
 create mode 100644 net/netfilter/nft_reject_netdev.c

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 52370211e46b..49fbef0d99be 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -682,6 +682,16 @@ config NFT_FIB_NETDEV
 	  The lookup will be delegated to the IPv4 or IPv6 FIB depending
 	  on the protocol of the packet.
 
+config NFT_REJECT_NETDEV
+	depends on NFT_REJECT_IPV4
+	depends on NFT_REJECT_IPV6
+	tristate "Netfilter nf_tables netdev REJECT support"
+	help
+	  This option enables the REJECT support from the netdev table.
+	  The return packet generation will be delegated to the IPv4
+	  or IPv6 ICMP or TCP RST implementation depending on the
+	  protocol of the packet.
+
 endif # NF_TABLES_NETDEV
 
 endif # NF_TABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 0e0ded87e27b..33da7bf1b68e 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -101,6 +101,7 @@ obj-$(CONFIG_NFT_QUEUE)		+= nft_queue.o
 obj-$(CONFIG_NFT_QUOTA)		+= nft_quota.o
 obj-$(CONFIG_NFT_REJECT) 	+= nft_reject.o
 obj-$(CONFIG_NFT_REJECT_INET)	+= nft_reject_inet.o
+obj-$(CONFIG_NFT_REJECT_NETDEV)	+= nft_reject_netdev.o
 obj-$(CONFIG_NFT_TUNNEL)	+= nft_tunnel.o
 obj-$(CONFIG_NFT_COUNTER)	+= nft_counter.o
 obj-$(CONFIG_NFT_LOG)		+= nft_log.o
diff --git a/net/netfilter/nft_reject_netdev.c b/net/netfilter/nft_reject_netdev.c
new file mode 100644
index 000000000000..d89f68754f42
--- /dev/null
+++ b/net/netfilter/nft_reject_netdev.c
@@ -0,0 +1,189 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2020 Laura Garcia Liebana <nevola@gmail.com>
+ * Copyright (c) 2020 Jose M. Guisado <guigom@riseup.net>
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netlink.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nft_reject.h>
+#include <net/netfilter/ipv4/nf_reject.h>
+#include <net/netfilter/ipv6/nf_reject.h>
+
+static void nft_reject_queue_xmit(struct sk_buff *nskb, struct sk_buff *oldskb)
+{
+	dev_hard_header(nskb, nskb->dev, ntohs(oldskb->protocol),
+			eth_hdr(oldskb)->h_source, eth_hdr(oldskb)->h_dest,
+			nskb->len);
+	dev_queue_xmit(nskb);
+}
+
+static void nft_reject_netdev_send_v4_tcp_reset(struct net *net,
+						struct sk_buff *oldskb,
+						const struct net_device *dev,
+						int hook)
+{
+	struct sk_buff *nskb;
+
+	nskb = nf_reject_skb_v4_tcp_reset(net, oldskb, dev, hook);
+	if (!nskb)
+		return;
+
+	nft_reject_queue_xmit(nskb, oldskb);
+}
+
+static void nft_reject_netdev_send_v4_unreach(struct net *net,
+					      struct sk_buff *oldskb,
+					      const struct net_device *dev,
+					      int hook, u8 code)
+{
+	struct sk_buff *nskb;
+
+	nskb = nf_reject_skb_v4_unreach(net, oldskb, dev, hook, code);
+	if (!nskb)
+		return;
+
+	nft_reject_queue_xmit(nskb, oldskb);
+}
+
+static void nft_reject_netdev_send_v6_tcp_reset(struct net *net,
+						struct sk_buff *oldskb,
+						const struct net_device *dev,
+						int hook)
+{
+	struct sk_buff *nskb;
+
+	nskb = nf_reject_skb_v6_tcp_reset(net, oldskb, dev, hook);
+	if (!nskb)
+		return;
+
+	nft_reject_queue_xmit(nskb, oldskb);
+}
+
+
+static void nft_reject_netdev_send_v6_unreach(struct net *net,
+					      struct sk_buff *oldskb,
+					      const struct net_device *dev,
+					      int hook, u8 code)
+{
+	struct sk_buff *nskb;
+
+	nskb = nf_reject_skb_v6_unreach(net, oldskb, dev, hook, code);
+	if (!nskb)
+		return;
+
+	nft_reject_queue_xmit(nskb, oldskb);
+}
+
+static void nft_reject_netdev_eval(const struct nft_expr *expr,
+				   struct nft_regs *regs,
+				   const struct nft_pktinfo *pkt)
+{
+	struct ethhdr *eth = eth_hdr(pkt->skb);
+	struct nft_reject *priv = nft_expr_priv(expr);
+	const unsigned char *dest = eth->h_dest;
+
+	if (is_broadcast_ether_addr(dest) ||
+	    is_multicast_ether_addr(dest))
+		goto out;
+
+	switch (eth->h_proto) {
+	case htons(ETH_P_IP):
+		switch (priv->type) {
+		case NFT_REJECT_ICMP_UNREACH:
+			nft_reject_netdev_send_v4_unreach(nft_net(pkt), pkt->skb,
+							  nft_in(pkt),
+							  nft_hook(pkt),
+							  priv->icmp_code);
+			break;
+		case NFT_REJECT_TCP_RST:
+			nft_reject_netdev_send_v4_tcp_reset(nft_net(pkt), pkt->skb,
+							    nft_in(pkt),
+							    nft_hook(pkt));
+			break;
+		case NFT_REJECT_ICMPX_UNREACH:
+			nft_reject_netdev_send_v4_unreach(nft_net(pkt), pkt->skb,
+							  nft_in(pkt),
+							  nft_hook(pkt),
+							  nft_reject_icmp_code(priv->icmp_code));
+			break;
+		}
+		break;
+	case htons(ETH_P_IPV6):
+		switch (priv->type) {
+		case NFT_REJECT_ICMP_UNREACH:
+			nft_reject_netdev_send_v6_unreach(nft_net(pkt), pkt->skb,
+							  nft_in(pkt),
+							  nft_hook(pkt),
+							  priv->icmp_code);
+			break;
+		case NFT_REJECT_TCP_RST:
+			nft_reject_netdev_send_v6_tcp_reset(nft_net(pkt), pkt->skb,
+							    nft_in(pkt),
+							    nft_hook(pkt));
+			break;
+		case NFT_REJECT_ICMPX_UNREACH:
+			nft_reject_netdev_send_v6_unreach(nft_net(pkt), pkt->skb,
+							  nft_in(pkt),
+							  nft_hook(pkt),
+							  nft_reject_icmpv6_code(priv->icmp_code));
+			break;
+		}
+		break;
+	default:
+		/* No explicit way to reject this protocol, drop it. */
+		break;
+	}
+out:
+	regs->verdict.code = NF_DROP;
+}
+
+static int nft_reject_netdev_validate(const struct nft_ctx *ctx,
+				      const struct nft_expr *expr,
+				      const struct nft_data **data)
+{
+	return nft_chain_validate_hooks(ctx->chain, (1 << NF_NETDEV_INGRESS));
+}
+
+static struct nft_expr_type nft_reject_netdev_type;
+static const struct nft_expr_ops nft_reject_netdev_ops = {
+	.type		= &nft_reject_netdev_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_reject)),
+	.eval		= nft_reject_netdev_eval,
+	.init		= nft_reject_init,
+	.dump		= nft_reject_dump,
+	.validate	= nft_reject_netdev_validate,
+};
+
+static struct nft_expr_type nft_reject_netdev_type __read_mostly = {
+	.family		= NFPROTO_NETDEV,
+	.name		= "reject",
+	.ops		= &nft_reject_netdev_ops,
+	.policy		= nft_reject_policy,
+	.maxattr	= NFTA_REJECT_MAX,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nft_reject_netdev_module_init(void)
+{
+	return nft_register_expr(&nft_reject_netdev_type);
+}
+
+static void __exit nft_reject_netdev_module_exit(void)
+{
+	nft_unregister_expr(&nft_reject_netdev_type);
+}
+
+module_init(nft_reject_netdev_module_init);
+module_exit(nft_reject_netdev_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Laura Garcia Liebana <nevola@gmail.com>");
+MODULE_AUTHOR("Jose M. Guisado <guigom@riseup.net>");
+MODULE_DESCRIPTION("Reject packets from netdev via nftables");
+MODULE_ALIAS_NFT_AF_EXPR(5, "reject");
-- 
2.20.1

