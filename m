Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 630F152DFCA
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 00:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242204AbiESWCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 18:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237131AbiESWCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 18:02:20 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3952EC8BFA;
        Thu, 19 May 2022 15:02:18 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: [PATCH net-next 07/11] netfilter: nf_flow_table: count pending offload workqueue tasks
Date:   Fri, 20 May 2022 00:02:02 +0200
Message-Id: <20220519220206.722153-8-pablo@netfilter.org>
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

To improve hardware offload debuggability count pending 'add', 'del' and
'stats' flow_table offload workqueue tasks. Counters are incremented before
scheduling new task and decremented when workqueue handler finishes
executing. These counters allow user to diagnose congestion on hardware
offload workqueues that can happen when either CPU is starved and workqueue
jobs are executed at lower rate than new ones are added or when
hardware/driver can't keep up with the rate.

Implement the described counters as percpu counters inside new struct
netns_ft which is stored inside struct net. Expose them via new procfs file
'/proc/net/stats/nf_flowtable' that is similar to existing 'nf_conntrack'
file.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/net_namespace.h           |  6 ++
 include/net/netfilter/nf_flow_table.h | 21 +++++++
 include/net/netns/flow_table.h        | 14 +++++
 net/netfilter/Kconfig                 |  9 +++
 net/netfilter/nf_flow_table_core.c    | 38 ++++++++++++-
 net/netfilter/nf_flow_table_offload.c | 17 +++++-
 net/netfilter/nf_flow_table_sysctl.c  | 79 +++++++++++++++++++++++++++
 7 files changed, 179 insertions(+), 5 deletions(-)
 create mode 100644 include/net/netns/flow_table.h

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index c4f5601f6e32..bf770c13e19b 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -26,6 +26,9 @@
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 #include <net/netns/conntrack.h>
 #endif
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
+#include <net/netns/flow_table.h>
+#endif
 #include <net/netns/nftables.h>
 #include <net/netns/xfrm.h>
 #include <net/netns/mpls.h>
@@ -140,6 +143,9 @@ struct net {
 #if defined(CONFIG_NF_TABLES) || defined(CONFIG_NF_TABLES_MODULE)
 	struct netns_nftables	nft;
 #endif
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
+	struct netns_ft ft;
+#endif
 #endif
 #ifdef CONFIG_WEXT_CORE
 	struct sk_buff_head	wext_nlevents;
diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 9709f984fba2..e6d63228efd4 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -371,4 +371,25 @@ static inline void nf_flow_table_fini_sysctl(struct net *net)
 }
 #endif /* CONFIG_SYSCTL */
 
+#define NF_FLOW_TABLE_STAT_INC(net, count) __this_cpu_inc((net)->ft.stat->count)
+#define NF_FLOW_TABLE_STAT_DEC(net, count) __this_cpu_dec((net)->ft.stat->count)
+#define NF_FLOW_TABLE_STAT_INC_ATOMIC(net, count)	\
+	this_cpu_inc((net)->ft.stat->count)
+#define NF_FLOW_TABLE_STAT_DEC_ATOMIC(net, count)	\
+	this_cpu_dec((net)->ft.stat->count)
+
+#ifdef CONFIG_NF_FLOW_TABLE_PROCFS
+int nf_flow_table_init_proc(struct net *net);
+void nf_flow_table_fini_proc(struct net *net);
+#else
+static inline int nf_flow_table_init_proc(struct net *net)
+{
+	return 0;
+}
+
+static inline void nf_flow_table_fini_proc(struct net *net)
+{
+}
+#endif /* CONFIG_NF_FLOW_TABLE_PROCFS */
+
 #endif /* _NF_FLOW_TABLE_H */
diff --git a/include/net/netns/flow_table.h b/include/net/netns/flow_table.h
new file mode 100644
index 000000000000..1c5fc657e267
--- /dev/null
+++ b/include/net/netns/flow_table.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __NETNS_FLOW_TABLE_H
+#define __NETNS_FLOW_TABLE_H
+
+struct nf_flow_table_stat {
+	unsigned int count_wq_add;
+	unsigned int count_wq_del;
+	unsigned int count_wq_stats;
+};
+
+struct netns_ft {
+	struct nf_flow_table_stat __percpu *stat;
+};
+#endif
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index ddc54b6d18ee..df6abbfe0079 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -734,6 +734,15 @@ config NF_FLOW_TABLE
 
 	  To compile it as a module, choose M here.
 
+config NF_FLOW_TABLE_PROCFS
+	bool "Supply flow table statistics in procfs"
+	default y
+	depends on PROC_FS
+	depends on SYSCTL
+	help
+	  This option enables for the flow table offload statistics
+	  to be shown in procfs under net/netfilter/nf_flowtable.
+
 config NETFILTER_XTABLES
 	tristate "Netfilter Xtables support (required for ip_tables)"
 	default m if NETFILTER_ADVANCED=n
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index e2598f98017c..c86dd627ef42 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -662,17 +662,51 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_free);
 
+static int nf_flow_table_init_net(struct net *net)
+{
+	net->ft.stat = alloc_percpu(struct nf_flow_table_stat);
+	return net->ft.stat ? 0 : -ENOMEM;
+}
+
+static void nf_flow_table_fini_net(struct net *net)
+{
+	free_percpu(net->ft.stat);
+}
+
 static int nf_flow_table_pernet_init(struct net *net)
 {
-	return nf_flow_table_init_sysctl(net);
+	int ret;
+
+	ret = nf_flow_table_init_net(net);
+	if (ret < 0)
+		return ret;
+
+	ret = nf_flow_table_init_sysctl(net);
+	if (ret < 0)
+		goto out_sysctl;
+
+	ret = nf_flow_table_init_proc(net);
+	if (ret < 0)
+		goto out_proc;
+
+	return 0;
+
+out_proc:
+	nf_flow_table_fini_sysctl(net);
+out_sysctl:
+	nf_flow_table_fini_net(net);
+	return ret;
 }
 
 static void nf_flow_table_pernet_exit(struct list_head *net_exit_list)
 {
 	struct net *net;
 
-	list_for_each_entry(net, net_exit_list, exit_list)
+	list_for_each_entry(net, net_exit_list, exit_list) {
+		nf_flow_table_fini_proc(net);
 		nf_flow_table_fini_sysctl(net);
+		nf_flow_table_fini_net(net);
+	}
 }
 
 unsigned int nf_ft_net_id __read_mostly;
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 5c7146eb646a..074322c1176f 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -995,17 +995,22 @@ static void flow_offload_work_stats(struct flow_offload_work *offload)
 static void flow_offload_work_handler(struct work_struct *work)
 {
 	struct flow_offload_work *offload;
+	struct net *net;
 
 	offload = container_of(work, struct flow_offload_work, work);
+	net = read_pnet(&offload->flowtable->net);
 	switch (offload->cmd) {
 		case FLOW_CLS_REPLACE:
 			flow_offload_work_add(offload);
+			NF_FLOW_TABLE_STAT_DEC_ATOMIC(net, count_wq_add);
 			break;
 		case FLOW_CLS_DESTROY:
 			flow_offload_work_del(offload);
+			NF_FLOW_TABLE_STAT_DEC_ATOMIC(net, count_wq_del);
 			break;
 		case FLOW_CLS_STATS:
 			flow_offload_work_stats(offload);
+			NF_FLOW_TABLE_STAT_DEC_ATOMIC(net, count_wq_stats);
 			break;
 		default:
 			WARN_ON_ONCE(1);
@@ -1017,12 +1022,18 @@ static void flow_offload_work_handler(struct work_struct *work)
 
 static void flow_offload_queue_work(struct flow_offload_work *offload)
 {
-	if (offload->cmd == FLOW_CLS_REPLACE)
+	struct net *net = read_pnet(&offload->flowtable->net);
+
+	if (offload->cmd == FLOW_CLS_REPLACE) {
+		NF_FLOW_TABLE_STAT_INC(net, count_wq_add);
 		queue_work(nf_flow_offload_add_wq, &offload->work);
-	else if (offload->cmd == FLOW_CLS_DESTROY)
+	} else if (offload->cmd == FLOW_CLS_DESTROY) {
+		NF_FLOW_TABLE_STAT_INC(net, count_wq_del);
 		queue_work(nf_flow_offload_del_wq, &offload->work);
-	else
+	} else {
+		NF_FLOW_TABLE_STAT_INC(net, count_wq_stats);
 		queue_work(nf_flow_offload_stats_wq, &offload->work);
+	}
 }
 
 static struct flow_offload_work *
diff --git a/net/netfilter/nf_flow_table_sysctl.c b/net/netfilter/nf_flow_table_sysctl.c
index 2e7539be8f88..edbdcc8731d9 100644
--- a/net/netfilter/nf_flow_table_sysctl.c
+++ b/net/netfilter/nf_flow_table_sysctl.c
@@ -1,7 +1,86 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <linux/kernel.h>
+#include <linux/proc_fs.h>
 #include <net/netfilter/nf_flow_table.h>
 
+#ifdef CONFIG_NF_FLOW_TABLE_PROCFS
+static void *nf_flow_table_cpu_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct net *net = seq_file_net(seq);
+	int cpu;
+
+	if (*pos == 0)
+		return SEQ_START_TOKEN;
+
+	for (cpu = *pos - 1; cpu < nr_cpu_ids; ++cpu) {
+		if (!cpu_possible(cpu))
+			continue;
+		*pos = cpu + 1;
+		return per_cpu_ptr(net->ft.stat, cpu);
+	}
+
+	return NULL;
+}
+
+static void *nf_flow_table_cpu_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct net *net = seq_file_net(seq);
+	int cpu;
+
+	for (cpu = *pos; cpu < nr_cpu_ids; ++cpu) {
+		if (!cpu_possible(cpu))
+			continue;
+		*pos = cpu + 1;
+		return per_cpu_ptr(net->ft.stat, cpu);
+	}
+	(*pos)++;
+	return NULL;
+}
+
+static void nf_flow_table_cpu_seq_stop(struct seq_file *seq, void *v)
+{
+}
+
+static int nf_flow_table_cpu_seq_show(struct seq_file *seq, void *v)
+{
+	const struct nf_flow_table_stat *st = v;
+
+	if (v == SEQ_START_TOKEN) {
+		seq_puts(seq, "wq_add   wq_del   wq_stats\n");
+		return 0;
+	}
+
+	seq_printf(seq, "%8d %8d %8d\n",
+		   st->count_wq_add,
+		   st->count_wq_del,
+		   st->count_wq_stats
+		);
+	return 0;
+}
+
+static const struct seq_operations nf_flow_table_cpu_seq_ops = {
+	.start	= nf_flow_table_cpu_seq_start,
+	.next	= nf_flow_table_cpu_seq_next,
+	.stop	= nf_flow_table_cpu_seq_stop,
+	.show	= nf_flow_table_cpu_seq_show,
+};
+
+int nf_flow_table_init_proc(struct net *net)
+{
+	struct proc_dir_entry *pde;
+
+	pde = proc_create_net("nf_flowtable", 0444, net->proc_net_stat,
+			      &nf_flow_table_cpu_seq_ops,
+			      sizeof(struct seq_net_private));
+	return pde ? 0 : -ENOMEM;
+}
+
+void nf_flow_table_fini_proc(struct net *net)
+{
+	remove_proc_entry("nf_flowtable", net->proc_net_stat);
+}
+#endif /* CONFIG_NF_FLOW_TABLE_PROCFS */
+
 enum nf_ct_sysctl_index {
 	NF_SYSCTL_FLOW_TABLE_MAX_HW,
 	NF_SYSCTL_FLOW_TABLE_COUNT_HW,
-- 
2.30.2

