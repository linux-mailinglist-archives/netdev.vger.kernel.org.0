Return-Path: <netdev+bounces-2550-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E197C7027C1
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:00:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 22ED128118F
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 09:00:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C40AA92D;
	Mon, 15 May 2023 09:00:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4EA8F42
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 09:00:24 +0000 (UTC)
X-Greylist: delayed 498 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 15 May 2023 02:00:21 PDT
Received: from mail.avm.de (mail.avm.de [IPv6:2001:bf0:244:244::94])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26ED10EA
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 02:00:20 -0700 (PDT)
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Mon, 15 May 2023 10:52:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1684140720; bh=oxYIMnYO7Ypmm/lpcPpl2z/P+Ln/Eg7ecWQ7USx+hCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qp0VSVgKIkpoy++GZFJ60Tq/PVL3lK0mLQuKAQHXaee2y8hQUDSGbuY/P+UuaZqz8
	 dCt2ZN4zmdofK/Ky6OIl+vjskDuiP/XCRKBpwa+8eMJFxiituZSgLqhPC83vwVsCD9
	 nBt2u/3TolebtTkhABCo+/eWmrSSuOBTorR3G59o=
Received: from u-jnixdorf.avm.de (unknown [172.17.88.63])
	by mail-auth.avm.de (Postfix) with ESMTPA id C14A380C0E;
	Mon, 15 May 2023 10:52:00 +0200 (CEST)
From: Johannes Nixdorf <jnixdorf-oss@avm.de>
To: netdev@vger.kernel.org
Cc: bridge@lists.linux-foundation.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Johannes Nixdorf <jnixdorf-oss@avm.de>
Subject: [PATCH net-next 2/2] bridge: Add a sysctl to limit new brides FDB entries
Date: Mon, 15 May 2023 10:50:46 +0200
Message-Id: <20230515085046.4457-2-jnixdorf-oss@avm.de>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515085046.4457-1-jnixdorf-oss@avm.de>
References: <20230515085046.4457-1-jnixdorf-oss@avm.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-purgate-ID: 149429::1684140720-E443384B-B2D92B77/0/0
X-purgate-type: clean
X-purgate-size: 4794
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate: clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This is a convenience setting, which allows the administrator to limit
the default limit of FDB entries for all created bridges, instead of
having to set it for each created bridge using the netlink property.

The setting is network namespace local, and defaults to 0, which means
unlimited, for backwards compatibility reasons.

Signed-off-by: Johannes Nixdorf <jnixdorf-oss@avm.de>
---
 net/bridge/br.c         | 83 +++++++++++++++++++++++++++++++++++++++++
 net/bridge/br_device.c  |  4 +-
 net/bridge/br_private.h |  9 +++++
 3 files changed, 95 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br.c b/net/bridge/br.c
index 4f5098d33a46..e32bb956111c 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/llc.h>
 #include <net/llc.h>
+#include <net/netns/generic.h>
 #include <net/stp.h>
 #include <net/switchdev.h>
 
@@ -348,6 +349,82 @@ void br_opt_toggle(struct net_bridge *br, enum net_bridge_opts opt, bool on)
 		clear_bit(opt, &br->options);
 }
 
+#ifdef CONFIG_SYSCTL
+static unsigned int br_net_id __read_mostly;
+
+struct br_net {
+	struct ctl_table_header *ctl_hdr;
+
+	unsigned int fdb_max_entries_default;
+};
+
+static int br_proc_rtnl_uintvec(struct ctl_table *table, int write,
+				void *buffer, size_t *lenp, loff_t *ppos)
+{
+	int ret;
+
+	rtnl_lock();
+	ret = proc_douintvec(table, write, buffer, lenp, ppos);
+	rtnl_unlock();
+
+	return ret;
+}
+
+static struct ctl_table br_sysctl_table[] = {
+	{
+		.procname     = "bridge-fdb-max-entries-default",
+		.maxlen	      = sizeof(unsigned int),
+		.mode	      = 0644,
+		.proc_handler = br_proc_rtnl_uintvec,
+	},
+	{ }
+};
+
+static int __net_init br_net_init(struct net *net)
+{
+	struct ctl_table *table = br_sysctl_table;
+	struct br_net *brnet;
+
+	if (!net_eq(net, &init_net)) {
+		table = kmemdup(table, sizeof(br_sysctl_table), GFP_KERNEL);
+		if (!table)
+			return -ENOMEM;
+	}
+
+	brnet = net_generic(net, br_net_id);
+
+	brnet->fdb_max_entries_default = 0;
+
+	table[0].data = &brnet->fdb_max_entries_default;
+	brnet->ctl_hdr = register_net_sysctl(net, "net/bridge", table);
+	if (!brnet->ctl_hdr) {
+		if (!net_eq(net, &init_net))
+			kfree(table);
+
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void __net_exit br_net_exit(struct net *net)
+{
+	struct br_net *brnet = net_generic(net, br_net_id);
+	struct ctl_table *table = brnet->ctl_hdr->ctl_table_arg;
+
+	unregister_net_sysctl_table(brnet->ctl_hdr);
+	if (!net_eq(net, &init_net))
+		kfree(table);
+}
+
+unsigned int br_fdb_max_entries_default(struct net *net)
+{
+	struct br_net *brnet = net_generic(net, br_net_id);
+
+	return brnet->fdb_max_entries_default;
+}
+#endif
+
 static void __net_exit br_net_exit_batch(struct list_head *net_list)
 {
 	struct net_device *dev;
@@ -367,6 +444,12 @@ static void __net_exit br_net_exit_batch(struct list_head *net_list)
 }
 
 static struct pernet_operations br_net_ops = {
+#ifdef CONFIG_SYSCTL
+	.init		= br_net_init,
+	.exit		= br_net_exit,
+	.id		= &br_net_id,
+	.size		= sizeof(struct br_net),
+#endif
 	.exit_batch	= br_net_exit_batch,
 };
 
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index d455a28df7c9..26023f2732e8 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -117,8 +117,11 @@ static void br_set_lockdep_class(struct net_device *dev)
 static int br_dev_init(struct net_device *dev)
 {
 	struct net_bridge *br = netdev_priv(dev);
+	struct net *net = dev_net(dev);
 	int err;
 
+	br->fdb_max_entries = br_fdb_max_entries_default(net);
+
 	dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
 	if (!dev->tstats)
 		return -ENOMEM;
@@ -529,7 +532,6 @@ void br_dev_setup(struct net_device *dev)
 	br->bridge_forward_delay = br->forward_delay = 15 * HZ;
 	br->bridge_ageing_time = br->ageing_time = BR_DEFAULT_AGEING_TIME;
 	br->fdb_n_entries = 0;
-	br->fdb_max_entries = 0;
 	dev->max_mtu = ETH_MAX_MTU;
 
 	br_netfilter_rtable_init(br);
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 64fb359c6e3e..d4b0f85cc278 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -2223,4 +2223,13 @@ void br_do_suppress_nd(struct sk_buff *skb, struct net_bridge *br,
 		       u16 vid, struct net_bridge_port *p, struct nd_msg *msg);
 struct nd_msg *br_is_nd_neigh_msg(struct sk_buff *skb, struct nd_msg *m);
 bool br_is_neigh_suppress_enabled(const struct net_bridge_port *p, u16 vid);
+
+#ifdef CONFIG_SYSFS
+unsigned int br_fdb_max_entries_default(struct net *net);
+#else
+static inline unsigned int br_fdb_max_entries_default(struct net *net)
+{
+	return 0;
+}
+#endif
 #endif
-- 
2.40.1


