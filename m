Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBE0C46FE0
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 14:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfFOMO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 08:14:29 -0400
Received: from m97179.mail.qiye.163.com ([220.181.97.179]:42625 "EHLO
        m97179.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbfFOMO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 08:14:28 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m97179.mail.qiye.163.com (Hmail) with ESMTPA id D34E2E00D7F;
        Sat, 15 Jun 2019 20:14:22 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next] netfilter: bridge: add nft_bridge_pvid to tag the default pvid for non-tagged packet
Date:   Sat, 15 Jun 2019 20:14:21 +0800
Message-Id: <1560600861-8848-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVJQ0hCQkJCSkJDQkpITVlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mk06Hjo4Czg*MhI3SzoMOAJD
        DwoKCy1VSlVKTk1LTUtLQ01JQk1LVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU9NTk83Bg++
X-HM-Tid: 0a6b5b0f60a320bdkuqyd34e2e00d7f
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

bridge vlan add dev veth1 vid 200 pvid untagged
bridge vlan add dev veth2 vid 200 pvid untagged

nft add table bridge firewall
nft add chain bridge firewall zones { type filter hook prerouting priority - 300 \; }
nft add rule bridge firewall zones counter ct zone set vlan id map { 100 : 1, 200 : 2 }

As above set the bridge port with pvid, the received packet don't contain
the vlan tag which means the packet should belong to vlan 200 through pvid.
With this pacth user can set the pvid in the prerouting hook before set zone id and
conntrack. So the conntrack can only base on vlan id and map the vlan id to zone id
in the prerouting hook.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/bridge/netfilter/Kconfig           |  6 ++++
 net/bridge/netfilter/Makefile          |  1 +
 net/bridge/netfilter/nft_bridge_pvid.c | 63 ++++++++++++++++++++++++++++++++++
 3 files changed, 70 insertions(+)
 create mode 100644 net/bridge/netfilter/nft_bridge_pvid.c

diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index f4fb0b9..61f2a31 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -33,6 +33,12 @@ config NF_CONNTRACK_BRIDGE
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NFT_BRIDGE_PVID
+	tristate "Netfilter nf_tables bridge pvid support"
+	depends on BRIDGE_VLAN_FILTERING
+	help
+	  Add support to add vlan-pvid tag for non-tagged packets.
+
 endif # NF_TABLES_BRIDGE
 
 menuconfig BRIDGE_NF_EBTABLES
diff --git a/net/bridge/netfilter/Makefile b/net/bridge/netfilter/Makefile
index 9d77673..e0d6c59 100644
--- a/net/bridge/netfilter/Makefile
+++ b/net/bridge/netfilter/Makefile
@@ -4,6 +4,7 @@
 #
 
 obj-$(CONFIG_NFT_BRIDGE_REJECT)  += nft_reject_bridge.o
+obj-$(CONFIG_NFT_BRIDGE_PVID)  += nft_bridge_pvid.o
 
 # connection tracking
 obj-$(CONFIG_NF_CONNTRACK_BRIDGE) += nf_conntrack_bridge.o
diff --git a/net/bridge/netfilter/nft_bridge_pvid.c b/net/bridge/netfilter/nft_bridge_pvid.c
new file mode 100644
index 0000000..93a4d38
--- /dev/null
+++ b/net/bridge/netfilter/nft_bridge_pvid.c
@@ -0,0 +1,63 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netfilter_bridge.h>
+#include <net/netfilter/nf_tables.h>
+#include "../br_private.h"
+
+static void nft_bridge_pvid_eval(const struct nft_expr *expr,
+				 struct nft_regs *regs,
+				 const struct nft_pktinfo *pkt)
+{
+	struct sk_buff *skb = pkt->skb;
+	struct net_bridge_port *p;
+
+	p = br_port_get_rtnl_rcu(skb->dev);
+
+	if (p && br_opt_get(p->br, BROPT_VLAN_ENABLED) &&
+	    !skb_vlan_tag_present(skb)) {
+		u16 pvid = br_get_pvid(nbp_vlan_group_rcu(p));
+
+		if (pvid)
+			__vlan_hwaccel_put_tag(skb, p->br->vlan_proto, pvid);
+	}
+}
+
+static int nft_bridge_pvid_validate(const struct nft_ctx *ctx,
+				    const struct nft_expr *expr,
+				    const struct nft_data **data)
+{
+	return nft_chain_validate_hooks(ctx->chain, 1 << NF_BR_PRE_ROUTING);
+}
+
+static struct nft_expr_type nft_bridge_pvid_type;
+static const struct nft_expr_ops nft_bridge_pvid_ops = {
+	.type		= &nft_bridge_pvid_type,
+	.size		= NFT_EXPR_SIZE(0),
+	.eval		= nft_bridge_pvid_eval,
+	.validate	= nft_bridge_pvid_validate,
+};
+
+static struct nft_expr_type nft_bridge_pvid_type __read_mostly = {
+	.family		= NFPROTO_BRIDGE,
+	.name		= "pvid",
+	.ops		= &nft_bridge_pvid_ops,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nft_bridge_pvid_module_init(void)
+{
+	return nft_register_expr(&nft_bridge_pvid_type);
+}
+
+static void __exit nft_bridge_pvid_module_exit(void)
+{
+	nft_unregister_expr(&nft_bridge_pvid_type);
+}
+
+module_init(nft_bridge_pvid_module_init);
+module_exit(nft_bridge_pvid_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_NFT_AF_EXPR(AF_BRIDGE, "pvid");
-- 
1.8.3.1

