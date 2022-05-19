Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C236A52DFC2
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 00:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245355AbiESWC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 18:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235495AbiESWCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 18:02:18 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8733BF68BA;
        Thu, 19 May 2022 15:02:17 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: [PATCH net-next 06/11] netfilter: nf_flow_table: count and limit hw offloaded entries
Date:   Fri, 20 May 2022 00:02:01 +0200
Message-Id: <20220519220206.722153-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220519220206.722153-1-pablo@netfilter.org>
References: <20220519220206.722153-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

To improve hardware offload debuggability and scalability introduce
'nf_flowtable_count_hw' and 'nf_flowtable_max_hw' sysctl entries in new
dedicated 'net/netfilter/ft' namespace. Add new pernet struct nf_ft_net in
order to store the counter and sysctl header of new sysctl table.

Count the offloaded flows in workqueue add task handler. Verify that
offloaded flow total is lower than allowed maximum before calling the
driver callbacks. To prevent spamming the 'add' workqueue with tasks when
flows can't be offloaded anymore also check that count is below limit
before queuing offload work. This doesn't prevent all redundant workqueue
task since counter can be taken by concurrent work handler after the check
had been performed but before the offload job is executed but it still
greatly reduces such occurrences. Note that flows that were not offloaded
due to counter being larger than the cap can still be offloaded via refresh
function.

Ensure that flows are accounted correctly by verifying IPS_HW_OFFLOAD_BIT
value before counting them. This ensures that add/refresh code path
increments the counter exactly once per flow when setting the bit and
decrements it only for accounted flows when deleting the flow with the bit
set.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../networking/nf_conntrack-sysctl.rst        |  9 +++
 include/net/netfilter/nf_flow_table.h         | 36 ++++++++++
 net/netfilter/Makefile                        |  1 +
 net/netfilter/nf_flow_table_core.c            | 55 ++++++++++++++-
 net/netfilter/nf_flow_table_offload.c         | 38 ++++++++--
 net/netfilter/nf_flow_table_sysctl.c          | 69 +++++++++++++++++++
 6 files changed, 200 insertions(+), 8 deletions(-)
 create mode 100644 net/netfilter/nf_flow_table_sysctl.c

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index 834945ebc4cd..116c27f46c24 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -210,3 +210,12 @@ nf_flowtable_udp_timeout - INTEGER (seconds)
         Control offload timeout for udp connections.
         UDP connections may be offloaded from nf conntrack to nf flow table.
         Once aged, the connection is returned to nf conntrack with udp pickup timeout.
+
+nf_flowtable_count_hw - INTEGER (read-only)
+	Number of flowtable entries that are currently offloaded to hardware.
+
+nf_flowtable_max_hw - INTEGER
+	- 0 - disabled (default)
+	- not 0 - enabled
+
+	Cap on maximum total amount of flowtable entries offloaded to hardware.
diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 64daafd1fc41..9709f984fba2 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -335,4 +335,40 @@ static inline __be16 nf_flow_pppoe_proto(const struct sk_buff *skb)
 	return 0;
 }
 
+struct nf_ft_net {
+	atomic_t count_hw;
+#ifdef CONFIG_SYSCTL
+	struct ctl_table_header *sysctl_header;
+#endif
+};
+
+extern unsigned int nf_ft_hw_max;
+extern unsigned int nf_ft_net_id;
+
+#include <net/netns/generic.h>
+
+static inline struct nf_ft_net *nf_ft_pernet(const struct net *net)
+{
+	return net_generic(net, nf_ft_net_id);
+}
+
+static inline struct nf_ft_net *nf_ft_pernet_get(struct nf_flowtable *flow_table)
+{
+	return nf_ft_pernet(read_pnet(&flow_table->net));
+}
+
+#ifdef CONFIG_SYSCTL
+int nf_flow_table_init_sysctl(struct net *net);
+void nf_flow_table_fini_sysctl(struct net *net);
+#else
+static inline int nf_flow_table_init_sysctl(struct net *net)
+{
+	return 0;
+}
+
+static inline void nf_flow_table_fini_sysctl(struct net *net)
+{
+}
+#endif /* CONFIG_SYSCTL */
+
 #endif /* _NF_FLOW_TABLE_H */
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 238b6a620e88..9e3c1f9c6d07 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -128,6 +128,7 @@ obj-$(CONFIG_NFT_FWD_NETDEV)	+= nft_fwd_netdev.o
 obj-$(CONFIG_NF_FLOW_TABLE)	+= nf_flow_table.o
 nf_flow_table-objs		:= nf_flow_table_core.o nf_flow_table_ip.o \
 				   nf_flow_table_offload.o
+nf_flow_table-$(CONFIG_SYSCTL)	+= nf_flow_table_sysctl.o
 
 obj-$(CONFIG_NF_FLOW_TABLE_INET) += nf_flow_table_inet.o
 
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 3db256da919b..e2598f98017c 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -277,6 +277,13 @@ static const struct rhashtable_params nf_flow_offload_rhash_params = {
 	.automatic_shrinking	= true,
 };
 
+static bool flow_max_hw_entries(struct nf_flowtable *flow_table)
+{
+	struct nf_ft_net *fnet = nf_ft_pernet_get(flow_table);
+
+	return nf_ft_hw_max && atomic_read(&fnet->count_hw) >= nf_ft_hw_max;
+}
+
 unsigned long flow_offload_get_timeout(struct flow_offload *flow)
 {
 	unsigned long timeout = NF_FLOW_TIMEOUT;
@@ -320,7 +327,8 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 
 	nf_ct_offload_timeout(flow->ct);
 
-	if (nf_flowtable_hw_offload(flow_table)) {
+	if (nf_flowtable_hw_offload(flow_table) &&
+	    !flow_max_hw_entries(flow_table)) {
 		__set_bit(NF_FLOW_HW, &flow->flags);
 		nf_flow_offload_add(flow_table, flow);
 	}
@@ -338,9 +346,11 @@ void flow_offload_refresh(struct nf_flowtable *flow_table,
 	if (READ_ONCE(flow->timeout) != timeout)
 		WRITE_ONCE(flow->timeout, timeout);
 
-	if (likely(!nf_flowtable_hw_offload(flow_table)))
+	if (likely(!nf_flowtable_hw_offload(flow_table) ||
+		   flow_max_hw_entries(flow_table)))
 		return;
 
+	set_bit(NF_FLOW_HW, &flow->flags);
 	nf_flow_offload_add(flow_table, flow);
 }
 EXPORT_SYMBOL_GPL(flow_offload_refresh);
@@ -652,14 +662,53 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_free);
 
+static int nf_flow_table_pernet_init(struct net *net)
+{
+	return nf_flow_table_init_sysctl(net);
+}
+
+static void nf_flow_table_pernet_exit(struct list_head *net_exit_list)
+{
+	struct net *net;
+
+	list_for_each_entry(net, net_exit_list, exit_list)
+		nf_flow_table_fini_sysctl(net);
+}
+
+unsigned int nf_ft_net_id __read_mostly;
+
+static struct pernet_operations nf_flow_table_net_ops = {
+	.init = nf_flow_table_pernet_init,
+	.exit_batch = nf_flow_table_pernet_exit,
+	.id = &nf_ft_net_id,
+	.size = sizeof(struct nf_ft_net),
+};
+
 static int __init nf_flow_table_module_init(void)
 {
-	return nf_flow_table_offload_init();
+	int ret;
+
+	nf_ft_hw_max = 0;
+
+	ret = register_pernet_subsys(&nf_flow_table_net_ops);
+	if (ret < 0)
+		return ret;
+
+	ret = nf_flow_table_offload_init();
+	if (ret)
+		goto out_offload;
+
+	return 0;
+
+out_offload:
+	unregister_pernet_subsys(&nf_flow_table_net_ops);
+	return ret;
 }
 
 static void __exit nf_flow_table_module_exit(void)
 {
 	nf_flow_table_offload_exit();
+	unregister_pernet_subsys(&nf_flow_table_net_ops);
 }
 
 module_init(nf_flow_table_module_init);
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 11b6e1942092..5c7146eb646a 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -13,6 +13,8 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
 
+unsigned int nf_ft_hw_max __read_mostly;
+
 static struct workqueue_struct *nf_flow_offload_add_wq;
 static struct workqueue_struct *nf_flow_offload_del_wq;
 static struct workqueue_struct *nf_flow_offload_stats_wq;
@@ -903,30 +905,56 @@ static int flow_offload_rule_add(struct flow_offload_work *offload,
 	return 0;
 }
 
+static bool flow_get_max_hw_entries(struct nf_flowtable *flow_table)
+{
+	struct nf_ft_net *fnet = nf_ft_pernet_get(flow_table);
+	int count_hw = atomic_inc_return(&fnet->count_hw);
+
+	if (nf_ft_hw_max && count_hw > nf_ft_hw_max) {
+		atomic_dec(&fnet->count_hw);
+		return false;
+	}
+	return true;
+}
+
 static void flow_offload_work_add(struct flow_offload_work *offload)
 {
+	struct nf_ft_net *fnet = nf_ft_pernet_get(offload->flowtable);
 	struct nf_flow_rule *flow_rule[FLOW_OFFLOAD_DIR_MAX];
 	int err;
 
+	if (!flow_get_max_hw_entries(offload->flowtable))
+		return;
+
 	err = nf_flow_offload_alloc(offload, flow_rule);
 	if (err < 0)
-		return;
+		goto out_alloc;
 
 	err = flow_offload_rule_add(offload, flow_rule);
 	if (err < 0)
-		goto out;
+		goto out_add;
 
-	set_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
+	if (test_and_set_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status))
+		atomic_dec(&fnet->count_hw);
+	nf_flow_offload_destroy(flow_rule);
+	return;
 
-out:
+out_add:
 	nf_flow_offload_destroy(flow_rule);
+out_alloc:
+	atomic_dec(&fnet->count_hw);
 }
 
 static void flow_offload_work_del(struct flow_offload_work *offload)
 {
-	clear_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
+	bool offloaded = test_and_clear_bit(IPS_HW_OFFLOAD_BIT,
+					    &offload->flow->ct->status);
+	struct nf_ft_net *fnet = nf_ft_pernet_get(offload->flowtable);
+
 	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
 	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
+	if (offloaded)
+		atomic_dec(&fnet->count_hw);
 	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
 }
 
diff --git a/net/netfilter/nf_flow_table_sysctl.c b/net/netfilter/nf_flow_table_sysctl.c
new file mode 100644
index 000000000000..2e7539be8f88
--- /dev/null
+++ b/net/netfilter/nf_flow_table_sysctl.c
@@ -0,0 +1,69 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/kernel.h>
+#include <net/netfilter/nf_flow_table.h>
+
+enum nf_ct_sysctl_index {
+	NF_SYSCTL_FLOW_TABLE_MAX_HW,
+	NF_SYSCTL_FLOW_TABLE_COUNT_HW,
+
+	__NF_SYSCTL_FLOW_TABLE_LAST_SYSCTL,
+};
+
+#define NF_SYSCTL_FLOW_TABLE_LAST_SYSCTL                                       \
+	(__NF_SYSCTL_FLOW_TABLE_LAST_SYSCTL + 1)
+
+static struct ctl_table nf_flow_table_sysctl_table[] = {
+	[NF_SYSCTL_FLOW_TABLE_MAX_HW] = {
+		.procname	= "nf_flowtable_max_hw",
+		.data		= &nf_ft_hw_max,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	[NF_SYSCTL_FLOW_TABLE_COUNT_HW] = {
+		.procname	= "nf_flowtable_count_hw",
+		.maxlen		= sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= proc_dointvec,
+	},
+	{}
+};
+
+int nf_flow_table_init_sysctl(struct net *net)
+{
+	struct nf_ft_net *fnet = nf_ft_pernet(net);
+	struct ctl_table *table;
+
+	BUILD_BUG_ON(ARRAY_SIZE(nf_flow_table_sysctl_table) != NF_SYSCTL_FLOW_TABLE_LAST_SYSCTL);
+
+	table = kmemdup(nf_flow_table_sysctl_table, sizeof(nf_flow_table_sysctl_table),
+			GFP_KERNEL);
+	if (!table)
+		return -ENOMEM;
+
+	table[NF_SYSCTL_FLOW_TABLE_COUNT_HW].data = &fnet->count_hw;
+
+	/* Don't allow non-init_net ns to alter global sysctls */
+	if (!net_eq(&init_net, net))
+		table[NF_SYSCTL_FLOW_TABLE_MAX_HW].mode = 0444;
+
+	fnet->sysctl_header = register_net_sysctl(net, "net/netfilter/ft", table);
+	if (!fnet->sysctl_header)
+		goto out_unregister_netfilter;
+
+	return 0;
+
+out_unregister_netfilter:
+	kfree(table);
+	return -ENOMEM;
+}
+
+void nf_flow_table_fini_sysctl(struct net *net)
+{
+	struct nf_ft_net *fnet = nf_ft_pernet(net);
+	struct ctl_table *table;
+
+	table = fnet->sysctl_header->ctl_table_arg;
+	unregister_net_sysctl_table(fnet->sysctl_header);
+	kfree(table);
+}
-- 
2.30.2

