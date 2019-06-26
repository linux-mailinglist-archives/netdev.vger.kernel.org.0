Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C827E566CF
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 12:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbfFZKcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 06:32:39 -0400
Received: from m97179.mail.qiye.163.com ([220.181.97.179]:53388 "EHLO
        m97179.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbfFZKch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 06:32:37 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m97179.mail.qiye.163.com (Hmail) with ESMTPA id 2370CE01B02;
        Wed, 26 Jun 2019 18:32:30 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 3/3 nf-next] netfilter: Flow table support for the bridge family
Date:   Wed, 26 Jun 2019 18:32:28 +0800
Message-Id: <1561545148-11978-3-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1561545148-11978-1-git-send-email-wenxu@ucloud.cn>
References: <1561545148-11978-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSUlDQkJCQkxJSE9IT09ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NzI6Lxw5Tzg1OhQNQwk3MCkY
        PCsKCktVSlVKTk1KTk9OSk5LSkJDVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhDQ0g3Bg++
X-HM-Tid: 0a6b93580ed320bdkuqy2370ce01b02
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch adds the bridge flow table type, that implements the datapath
flow table to forward IPv4 traffic through bridge.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/bridge/netfilter/Kconfig                |  8 +++++
 net/bridge/netfilter/Makefile               |  1 +
 net/bridge/netfilter/nf_flow_table_bridge.c | 46 +++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+)
 create mode 100644 net/bridge/netfilter/nf_flow_table_bridge.c

diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index f4fb0b9..cba5f71 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -33,6 +33,14 @@ config NF_CONNTRACK_BRIDGE
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NF_FLOW_TABLE_BRIDGE
+	tristate "Netfilter flow table bridge module"
+	depends on NF_FLOW_TABLE && NF_CONNTRACK_BRIDGE
+	help
+          This option adds the flow table bridge support.
+
+	  To compile it as a module, choose M here.
+
 endif # NF_TABLES_BRIDGE
 
 menuconfig BRIDGE_NF_EBTABLES
diff --git a/net/bridge/netfilter/Makefile b/net/bridge/netfilter/Makefile
index 9d77673..deb81e6 100644
--- a/net/bridge/netfilter/Makefile
+++ b/net/bridge/netfilter/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_NFT_BRIDGE_REJECT)  += nft_reject_bridge.o
 
 # connection tracking
 obj-$(CONFIG_NF_CONNTRACK_BRIDGE) += nf_conntrack_bridge.o
+obj-$(CONFIG_NF_FLOW_TABLE_BRIDGE) += nf_flow_table_bridge.o
 
 # packet logging
 obj-$(CONFIG_NF_LOG_BRIDGE) += nf_log_bridge.o
diff --git a/net/bridge/netfilter/nf_flow_table_bridge.c b/net/bridge/netfilter/nf_flow_table_bridge.c
new file mode 100644
index 0000000..ad3220c
--- /dev/null
+++ b/net/bridge/netfilter/nf_flow_table_bridge.c
@@ -0,0 +1,46 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netfilter.h>
+#include <net/netfilter/nf_flow_table.h>
+#include <net/netfilter/nf_tables.h>
+
+static unsigned int
+nf_flow_offload_bridge_hook(void *priv, struct sk_buff *skb,
+			    const struct nf_hook_state *state)
+{
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		return nf_flow_offload_ip_hook(priv, skb, state);
+	}
+
+	return NF_ACCEPT;
+}
+
+static struct nf_flowtable_type flowtable_bridge = {
+	.family		= NFPROTO_BRIDGE,
+	.init		= nf_flow_table_init,
+	.free		= nf_flow_table_free,
+	.hook		= nf_flow_offload_bridge_hook,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nf_flow_bridge_module_init(void)
+{
+	nft_register_flowtable_type(&flowtable_bridge);
+
+	return 0;
+}
+
+static void __exit nf_flow_bridge_module_exit(void)
+{
+	nft_unregister_flowtable_type(&flowtable_bridge);
+}
+
+module_init(nf_flow_bridge_module_init);
+module_exit(nf_flow_bridge_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("wenxu <wenxu@ucloud.cn>");
+MODULE_ALIAS_NF_FLOWTABLE(AF_BRIDGE);
-- 
1.8.3.1

