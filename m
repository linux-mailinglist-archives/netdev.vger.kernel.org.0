Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591BC3411E7
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 02:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbhCSBGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 21:06:35 -0400
Received: from mail.netfilter.org ([217.70.188.207]:52588 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbhCSBGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 21:06:18 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id AF13562C13;
        Fri, 19 Mar 2021 02:06:13 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 2/9] Revert "netfilter: x_tables: Switch synchronization to RCU"
Date:   Fri, 19 Mar 2021 02:06:01 +0100
Message-Id: <20210319010608.9758-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210319010608.9758-1-pablo@netfilter.org>
References: <20210319010608.9758-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>

This reverts commit cc00bcaa589914096edef7fb87ca5cee4a166b5c.

This (and the preceding) patch basically re-implemented the RCU
mechanisms of patch 784544739a25. That patch was replaced because of the
performance problems that it created when replacing tables. Now, we have
the same issue: the call to synchronize_rcu() makes replacing tables
slower by as much as an order of magnitude.

Prior to using RCU a script calling "iptables" approx. 200 times was
taking 1.16s. With RCU this increased to 11.59s.

Revert these patches and fix the issue in a different way.

Signed-off-by: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/x_tables.h |  5 +--
 net/ipv4/netfilter/arp_tables.c    | 14 ++++-----
 net/ipv4/netfilter/ip_tables.c     | 14 ++++-----
 net/ipv6/netfilter/ip6_tables.c    | 14 ++++-----
 net/netfilter/x_tables.c           | 49 +++++++++++++++++++++---------
 5 files changed, 56 insertions(+), 40 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 8ebb64193757..5deb099d156d 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -227,7 +227,7 @@ struct xt_table {
 	unsigned int valid_hooks;
 
 	/* Man behind the curtain... */
-	struct xt_table_info __rcu *private;
+	struct xt_table_info *private;
 
 	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
 	struct module *me;
@@ -448,9 +448,6 @@ xt_get_per_cpu_counter(struct xt_counters *cnt, unsigned int cpu)
 
 struct nf_hook_ops *xt_hook_ops_alloc(const struct xt_table *, nf_hookfn *);
 
-struct xt_table_info
-*xt_table_get_private_protected(const struct xt_table *table);
-
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
 
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 563b62b76a5f..d1e04d2b5170 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -203,7 +203,7 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 
 	local_bh_disable();
 	addend = xt_write_recseq_begin();
-	private = rcu_access_pointer(table->private);
+	private = READ_ONCE(table->private); /* Address dependency. */
 	cpu     = smp_processor_id();
 	table_base = private->entries;
 	jumpstack  = (struct arpt_entry **)private->jumpstack[cpu];
@@ -649,7 +649,7 @@ static struct xt_counters *alloc_counters(const struct xt_table *table)
 {
 	unsigned int countersize;
 	struct xt_counters *counters;
-	const struct xt_table_info *private = xt_table_get_private_protected(table);
+	const struct xt_table_info *private = table->private;
 
 	/* We need atomic snapshot of counters: rest doesn't change
 	 * (other than comefrom, which userspace doesn't care
@@ -673,7 +673,7 @@ static int copy_entries_to_user(unsigned int total_size,
 	unsigned int off, num;
 	const struct arpt_entry *e;
 	struct xt_counters *counters;
-	struct xt_table_info *private = xt_table_get_private_protected(table);
+	struct xt_table_info *private = table->private;
 	int ret = 0;
 	void *loc_cpu_entry;
 
@@ -807,7 +807,7 @@ static int get_info(struct net *net, void __user *user, const int *len)
 	t = xt_request_find_table_lock(net, NFPROTO_ARP, name);
 	if (!IS_ERR(t)) {
 		struct arpt_getinfo info;
-		const struct xt_table_info *private = xt_table_get_private_protected(t);
+		const struct xt_table_info *private = t->private;
 #ifdef CONFIG_COMPAT
 		struct xt_table_info tmp;
 
@@ -860,7 +860,7 @@ static int get_entries(struct net *net, struct arpt_get_entries __user *uptr,
 
 	t = xt_find_table_lock(net, NFPROTO_ARP, get.name);
 	if (!IS_ERR(t)) {
-		const struct xt_table_info *private = xt_table_get_private_protected(t);
+		const struct xt_table_info *private = t->private;
 
 		if (get.size == private->size)
 			ret = copy_entries_to_user(private->size,
@@ -1017,7 +1017,7 @@ static int do_add_counters(struct net *net, sockptr_t arg, unsigned int len)
 	}
 
 	local_bh_disable();
-	private = xt_table_get_private_protected(t);
+	private = t->private;
 	if (private->number != tmp.num_counters) {
 		ret = -EINVAL;
 		goto unlock_up_free;
@@ -1330,7 +1330,7 @@ static int compat_copy_entries_to_user(unsigned int total_size,
 				       void __user *userptr)
 {
 	struct xt_counters *counters;
-	const struct xt_table_info *private = xt_table_get_private_protected(table);
+	const struct xt_table_info *private = table->private;
 	void __user *pos;
 	unsigned int size;
 	int ret = 0;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 6e2851f8d3a3..f15bc21d7301 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -258,7 +258,7 @@ ipt_do_table(struct sk_buff *skb,
 	WARN_ON(!(table->valid_hooks & (1 << hook)));
 	local_bh_disable();
 	addend = xt_write_recseq_begin();
-	private = rcu_access_pointer(table->private);
+	private = READ_ONCE(table->private); /* Address dependency. */
 	cpu        = smp_processor_id();
 	table_base = private->entries;
 	jumpstack  = (struct ipt_entry **)private->jumpstack[cpu];
@@ -791,7 +791,7 @@ static struct xt_counters *alloc_counters(const struct xt_table *table)
 {
 	unsigned int countersize;
 	struct xt_counters *counters;
-	const struct xt_table_info *private = xt_table_get_private_protected(table);
+	const struct xt_table_info *private = table->private;
 
 	/* We need atomic snapshot of counters: rest doesn't change
 	   (other than comefrom, which userspace doesn't care
@@ -815,7 +815,7 @@ copy_entries_to_user(unsigned int total_size,
 	unsigned int off, num;
 	const struct ipt_entry *e;
 	struct xt_counters *counters;
-	const struct xt_table_info *private = xt_table_get_private_protected(table);
+	const struct xt_table_info *private = table->private;
 	int ret = 0;
 	const void *loc_cpu_entry;
 
@@ -964,7 +964,7 @@ static int get_info(struct net *net, void __user *user, const int *len)
 	t = xt_request_find_table_lock(net, AF_INET, name);
 	if (!IS_ERR(t)) {
 		struct ipt_getinfo info;
-		const struct xt_table_info *private = xt_table_get_private_protected(t);
+		const struct xt_table_info *private = t->private;
 #ifdef CONFIG_COMPAT
 		struct xt_table_info tmp;
 
@@ -1018,7 +1018,7 @@ get_entries(struct net *net, struct ipt_get_entries __user *uptr,
 
 	t = xt_find_table_lock(net, AF_INET, get.name);
 	if (!IS_ERR(t)) {
-		const struct xt_table_info *private = xt_table_get_private_protected(t);
+		const struct xt_table_info *private = t->private;
 		if (get.size == private->size)
 			ret = copy_entries_to_user(private->size,
 						   t, uptr->entrytable);
@@ -1173,7 +1173,7 @@ do_add_counters(struct net *net, sockptr_t arg, unsigned int len)
 	}
 
 	local_bh_disable();
-	private = xt_table_get_private_protected(t);
+	private = t->private;
 	if (private->number != tmp.num_counters) {
 		ret = -EINVAL;
 		goto unlock_up_free;
@@ -1543,7 +1543,7 @@ compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
 			    void __user *userptr)
 {
 	struct xt_counters *counters;
-	const struct xt_table_info *private = xt_table_get_private_protected(table);
+	const struct xt_table_info *private = table->private;
 	void __user *pos;
 	unsigned int size;
 	int ret = 0;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index c4f532f4d311..2e2119bfcf13 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -280,7 +280,7 @@ ip6t_do_table(struct sk_buff *skb,
 
 	local_bh_disable();
 	addend = xt_write_recseq_begin();
-	private = rcu_access_pointer(table->private);
+	private = READ_ONCE(table->private); /* Address dependency. */
 	cpu        = smp_processor_id();
 	table_base = private->entries;
 	jumpstack  = (struct ip6t_entry **)private->jumpstack[cpu];
@@ -807,7 +807,7 @@ static struct xt_counters *alloc_counters(const struct xt_table *table)
 {
 	unsigned int countersize;
 	struct xt_counters *counters;
-	const struct xt_table_info *private = xt_table_get_private_protected(table);
+	const struct xt_table_info *private = table->private;
 
 	/* We need atomic snapshot of counters: rest doesn't change
 	   (other than comefrom, which userspace doesn't care
@@ -831,7 +831,7 @@ copy_entries_to_user(unsigned int total_size,
 	unsigned int off, num;
 	const struct ip6t_entry *e;
 	struct xt_counters *counters;
-	const struct xt_table_info *private = xt_table_get_private_protected(table);
+	const struct xt_table_info *private = table->private;
 	int ret = 0;
 	const void *loc_cpu_entry;
 
@@ -980,7 +980,7 @@ static int get_info(struct net *net, void __user *user, const int *len)
 	t = xt_request_find_table_lock(net, AF_INET6, name);
 	if (!IS_ERR(t)) {
 		struct ip6t_getinfo info;
-		const struct xt_table_info *private = xt_table_get_private_protected(t);
+		const struct xt_table_info *private = t->private;
 #ifdef CONFIG_COMPAT
 		struct xt_table_info tmp;
 
@@ -1035,7 +1035,7 @@ get_entries(struct net *net, struct ip6t_get_entries __user *uptr,
 
 	t = xt_find_table_lock(net, AF_INET6, get.name);
 	if (!IS_ERR(t)) {
-		struct xt_table_info *private = xt_table_get_private_protected(t);
+		struct xt_table_info *private = t->private;
 		if (get.size == private->size)
 			ret = copy_entries_to_user(private->size,
 						   t, uptr->entrytable);
@@ -1189,7 +1189,7 @@ do_add_counters(struct net *net, sockptr_t arg, unsigned int len)
 	}
 
 	local_bh_disable();
-	private = xt_table_get_private_protected(t);
+	private = t->private;
 	if (private->number != tmp.num_counters) {
 		ret = -EINVAL;
 		goto unlock_up_free;
@@ -1552,7 +1552,7 @@ compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
 			    void __user *userptr)
 {
 	struct xt_counters *counters;
-	const struct xt_table_info *private = xt_table_get_private_protected(table);
+	const struct xt_table_info *private = table->private;
 	void __user *pos;
 	unsigned int size;
 	int ret = 0;
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index bce6ca203d46..7df3aef39c5c 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1351,14 +1351,6 @@ struct xt_counters *xt_counters_alloc(unsigned int counters)
 }
 EXPORT_SYMBOL(xt_counters_alloc);
 
-struct xt_table_info
-*xt_table_get_private_protected(const struct xt_table *table)
-{
-	return rcu_dereference_protected(table->private,
-					 mutex_is_locked(&xt[table->af].mutex));
-}
-EXPORT_SYMBOL(xt_table_get_private_protected);
-
 struct xt_table_info *
 xt_replace_table(struct xt_table *table,
 	      unsigned int num_counters,
@@ -1366,6 +1358,7 @@ xt_replace_table(struct xt_table *table,
 	      int *error)
 {
 	struct xt_table_info *private;
+	unsigned int cpu;
 	int ret;
 
 	ret = xt_jumpstack_alloc(newinfo);
@@ -1375,20 +1368,47 @@ xt_replace_table(struct xt_table *table,
 	}
 
 	/* Do the substitution. */
-	private = xt_table_get_private_protected(table);
+	local_bh_disable();
+	private = table->private;
 
 	/* Check inside lock: is the old number correct? */
 	if (num_counters != private->number) {
 		pr_debug("num_counters != table->private->number (%u/%u)\n",
 			 num_counters, private->number);
+		local_bh_enable();
 		*error = -EAGAIN;
 		return NULL;
 	}
 
 	newinfo->initial_entries = private->initial_entries;
+	/*
+	 * Ensure contents of newinfo are visible before assigning to
+	 * private.
+	 */
+	smp_wmb();
+	table->private = newinfo;
+
+	/* make sure all cpus see new ->private value */
+	smp_wmb();
 
-	rcu_assign_pointer(table->private, newinfo);
-	synchronize_rcu();
+	/*
+	 * Even though table entries have now been swapped, other CPU's
+	 * may still be using the old entries...
+	 */
+	local_bh_enable();
+
+	/* ... so wait for even xt_recseq on all cpus */
+	for_each_possible_cpu(cpu) {
+		seqcount_t *s = &per_cpu(xt_recseq, cpu);
+		u32 seq = raw_read_seqcount(s);
+
+		if (seq & 1) {
+			do {
+				cond_resched();
+				cpu_relax();
+			} while (seq == raw_read_seqcount(s));
+		}
+	}
 
 	audit_log_nfcfg(table->name, table->af, private->number,
 			!private->number ? AUDIT_XT_OP_REGISTER :
@@ -1424,12 +1444,12 @@ struct xt_table *xt_register_table(struct net *net,
 	}
 
 	/* Simplifies replace_table code. */
-	rcu_assign_pointer(table->private, bootstrap);
+	table->private = bootstrap;
 
 	if (!xt_replace_table(table, 0, newinfo, &ret))
 		goto unlock;
 
-	private = xt_table_get_private_protected(table);
+	private = table->private;
 	pr_debug("table->private->number = %u\n", private->number);
 
 	/* save number of initial entries */
@@ -1452,8 +1472,7 @@ void *xt_unregister_table(struct xt_table *table)
 	struct xt_table_info *private;
 
 	mutex_lock(&xt[table->af].mutex);
-	private = xt_table_get_private_protected(table);
-	RCU_INIT_POINTER(table->private, NULL);
+	private = table->private;
 	list_del(&table->list);
 	mutex_unlock(&xt[table->af].mutex);
 	audit_log_nfcfg(table->name, table->af, private->number,
-- 
2.20.1

