Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3632D4D6F
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 23:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388475AbgLIWTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 17:19:08 -0500
Received: from correo.us.es ([193.147.175.20]:32968 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388400AbgLIWTG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 17:19:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 78771D2DA0C
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 23:18:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 675A5DA8FA
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 23:18:09 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5C1CEDA8F6; Wed,  9 Dec 2020 23:18:09 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 99828DA722;
        Wed,  9 Dec 2020 23:18:06 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 09 Dec 2020 23:18:06 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 6393E4265A5A;
        Wed,  9 Dec 2020 23:18:06 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 1/4] netfilter: x_tables: Switch synchronization to RCU
Date:   Wed,  9 Dec 2020 23:18:07 +0100
Message-Id: <20201209221810.32504-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201209221810.32504-1-pablo@netfilter.org>
References: <20201209221810.32504-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>

When running concurrent iptables rules replacement with data, the per CPU
sequence count is checked after the assignment of the new information.
The sequence count is used to synchronize with the packet path without the
use of any explicit locking. If there are any packets in the packet path using
the table information, the sequence count is incremented to an odd value and
is incremented to an even after the packet process completion.

The new table value assignment is followed by a write memory barrier so every
CPU should see the latest value. If the packet path has started with the old
table information, the sequence counter will be odd and the iptables
replacement will wait till the sequence count is even prior to freeing the
old table info.

However, this assumes that the new table information assignment and the memory
barrier is actually executed prior to the counter check in the replacement
thread. If CPU decides to execute the assignment later as there is no user of
the table information prior to the sequence check, the packet path in another
CPU may use the old table information. The replacement thread would then free
the table information under it leading to a use after free in the packet
processing context-

Unable to handle kernel NULL pointer dereference at virtual
address 000000000000008e
pc : ip6t_do_table+0x5d0/0x89c
lr : ip6t_do_table+0x5b8/0x89c
ip6t_do_table+0x5d0/0x89c
ip6table_filter_hook+0x24/0x30
nf_hook_slow+0x84/0x120
ip6_input+0x74/0xe0
ip6_rcv_finish+0x7c/0x128
ipv6_rcv+0xac/0xe4
__netif_receive_skb+0x84/0x17c
process_backlog+0x15c/0x1b8
napi_poll+0x88/0x284
net_rx_action+0xbc/0x23c
__do_softirq+0x20c/0x48c

This could be fixed by forcing instruction order after the new table
information assignment or by switching to RCU for the synchronization.

Fixes: 80055dab5de0 ("netfilter: x_tables: make xt_replace_table wait until old rules are not used anymore")
Reported-by: Sean Tranchetti <stranche@codeaurora.org>
Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/x_tables.h |  5 ++-
 net/ipv4/netfilter/arp_tables.c    | 14 ++++-----
 net/ipv4/netfilter/ip_tables.c     | 14 ++++-----
 net/ipv6/netfilter/ip6_tables.c    | 14 ++++-----
 net/netfilter/x_tables.c           | 49 +++++++++---------------------
 5 files changed, 40 insertions(+), 56 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 5deb099d156d..8ebb64193757 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -227,7 +227,7 @@ struct xt_table {
 	unsigned int valid_hooks;
 
 	/* Man behind the curtain... */
-	struct xt_table_info *private;
+	struct xt_table_info __rcu *private;
 
 	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
 	struct module *me;
@@ -448,6 +448,9 @@ xt_get_per_cpu_counter(struct xt_counters *cnt, unsigned int cpu)
 
 struct nf_hook_ops *xt_hook_ops_alloc(const struct xt_table *, nf_hookfn *);
 
+struct xt_table_info
+*xt_table_get_private_protected(const struct xt_table *table);
+
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
 
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index d1e04d2b5170..563b62b76a5f 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -203,7 +203,7 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 
 	local_bh_disable();
 	addend = xt_write_recseq_begin();
-	private = READ_ONCE(table->private); /* Address dependency. */
+	private = rcu_access_pointer(table->private);
 	cpu     = smp_processor_id();
 	table_base = private->entries;
 	jumpstack  = (struct arpt_entry **)private->jumpstack[cpu];
@@ -649,7 +649,7 @@ static struct xt_counters *alloc_counters(const struct xt_table *table)
 {
 	unsigned int countersize;
 	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = xt_table_get_private_protected(table);
 
 	/* We need atomic snapshot of counters: rest doesn't change
 	 * (other than comefrom, which userspace doesn't care
@@ -673,7 +673,7 @@ static int copy_entries_to_user(unsigned int total_size,
 	unsigned int off, num;
 	const struct arpt_entry *e;
 	struct xt_counters *counters;
-	struct xt_table_info *private = table->private;
+	struct xt_table_info *private = xt_table_get_private_protected(table);
 	int ret = 0;
 	void *loc_cpu_entry;
 
@@ -807,7 +807,7 @@ static int get_info(struct net *net, void __user *user, const int *len)
 	t = xt_request_find_table_lock(net, NFPROTO_ARP, name);
 	if (!IS_ERR(t)) {
 		struct arpt_getinfo info;
-		const struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = xt_table_get_private_protected(t);
 #ifdef CONFIG_COMPAT
 		struct xt_table_info tmp;
 
@@ -860,7 +860,7 @@ static int get_entries(struct net *net, struct arpt_get_entries __user *uptr,
 
 	t = xt_find_table_lock(net, NFPROTO_ARP, get.name);
 	if (!IS_ERR(t)) {
-		const struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = xt_table_get_private_protected(t);
 
 		if (get.size == private->size)
 			ret = copy_entries_to_user(private->size,
@@ -1017,7 +1017,7 @@ static int do_add_counters(struct net *net, sockptr_t arg, unsigned int len)
 	}
 
 	local_bh_disable();
-	private = t->private;
+	private = xt_table_get_private_protected(t);
 	if (private->number != tmp.num_counters) {
 		ret = -EINVAL;
 		goto unlock_up_free;
@@ -1330,7 +1330,7 @@ static int compat_copy_entries_to_user(unsigned int total_size,
 				       void __user *userptr)
 {
 	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = xt_table_get_private_protected(table);
 	void __user *pos;
 	unsigned int size;
 	int ret = 0;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index f15bc21d7301..6e2851f8d3a3 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -258,7 +258,7 @@ ipt_do_table(struct sk_buff *skb,
 	WARN_ON(!(table->valid_hooks & (1 << hook)));
 	local_bh_disable();
 	addend = xt_write_recseq_begin();
-	private = READ_ONCE(table->private); /* Address dependency. */
+	private = rcu_access_pointer(table->private);
 	cpu        = smp_processor_id();
 	table_base = private->entries;
 	jumpstack  = (struct ipt_entry **)private->jumpstack[cpu];
@@ -791,7 +791,7 @@ static struct xt_counters *alloc_counters(const struct xt_table *table)
 {
 	unsigned int countersize;
 	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = xt_table_get_private_protected(table);
 
 	/* We need atomic snapshot of counters: rest doesn't change
 	   (other than comefrom, which userspace doesn't care
@@ -815,7 +815,7 @@ copy_entries_to_user(unsigned int total_size,
 	unsigned int off, num;
 	const struct ipt_entry *e;
 	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = xt_table_get_private_protected(table);
 	int ret = 0;
 	const void *loc_cpu_entry;
 
@@ -964,7 +964,7 @@ static int get_info(struct net *net, void __user *user, const int *len)
 	t = xt_request_find_table_lock(net, AF_INET, name);
 	if (!IS_ERR(t)) {
 		struct ipt_getinfo info;
-		const struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = xt_table_get_private_protected(t);
 #ifdef CONFIG_COMPAT
 		struct xt_table_info tmp;
 
@@ -1018,7 +1018,7 @@ get_entries(struct net *net, struct ipt_get_entries __user *uptr,
 
 	t = xt_find_table_lock(net, AF_INET, get.name);
 	if (!IS_ERR(t)) {
-		const struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = xt_table_get_private_protected(t);
 		if (get.size == private->size)
 			ret = copy_entries_to_user(private->size,
 						   t, uptr->entrytable);
@@ -1173,7 +1173,7 @@ do_add_counters(struct net *net, sockptr_t arg, unsigned int len)
 	}
 
 	local_bh_disable();
-	private = t->private;
+	private = xt_table_get_private_protected(t);
 	if (private->number != tmp.num_counters) {
 		ret = -EINVAL;
 		goto unlock_up_free;
@@ -1543,7 +1543,7 @@ compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
 			    void __user *userptr)
 {
 	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = xt_table_get_private_protected(table);
 	void __user *pos;
 	unsigned int size;
 	int ret = 0;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 2e2119bfcf13..c4f532f4d311 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -280,7 +280,7 @@ ip6t_do_table(struct sk_buff *skb,
 
 	local_bh_disable();
 	addend = xt_write_recseq_begin();
-	private = READ_ONCE(table->private); /* Address dependency. */
+	private = rcu_access_pointer(table->private);
 	cpu        = smp_processor_id();
 	table_base = private->entries;
 	jumpstack  = (struct ip6t_entry **)private->jumpstack[cpu];
@@ -807,7 +807,7 @@ static struct xt_counters *alloc_counters(const struct xt_table *table)
 {
 	unsigned int countersize;
 	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = xt_table_get_private_protected(table);
 
 	/* We need atomic snapshot of counters: rest doesn't change
 	   (other than comefrom, which userspace doesn't care
@@ -831,7 +831,7 @@ copy_entries_to_user(unsigned int total_size,
 	unsigned int off, num;
 	const struct ip6t_entry *e;
 	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = xt_table_get_private_protected(table);
 	int ret = 0;
 	const void *loc_cpu_entry;
 
@@ -980,7 +980,7 @@ static int get_info(struct net *net, void __user *user, const int *len)
 	t = xt_request_find_table_lock(net, AF_INET6, name);
 	if (!IS_ERR(t)) {
 		struct ip6t_getinfo info;
-		const struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = xt_table_get_private_protected(t);
 #ifdef CONFIG_COMPAT
 		struct xt_table_info tmp;
 
@@ -1035,7 +1035,7 @@ get_entries(struct net *net, struct ip6t_get_entries __user *uptr,
 
 	t = xt_find_table_lock(net, AF_INET6, get.name);
 	if (!IS_ERR(t)) {
-		struct xt_table_info *private = t->private;
+		struct xt_table_info *private = xt_table_get_private_protected(t);
 		if (get.size == private->size)
 			ret = copy_entries_to_user(private->size,
 						   t, uptr->entrytable);
@@ -1189,7 +1189,7 @@ do_add_counters(struct net *net, sockptr_t arg, unsigned int len)
 	}
 
 	local_bh_disable();
-	private = t->private;
+	private = xt_table_get_private_protected(t);
 	if (private->number != tmp.num_counters) {
 		ret = -EINVAL;
 		goto unlock_up_free;
@@ -1552,7 +1552,7 @@ compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
 			    void __user *userptr)
 {
 	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = xt_table_get_private_protected(table);
 	void __user *pos;
 	unsigned int size;
 	int ret = 0;
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index af22dbe85e2c..acce622582e3 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1349,6 +1349,14 @@ struct xt_counters *xt_counters_alloc(unsigned int counters)
 }
 EXPORT_SYMBOL(xt_counters_alloc);
 
+struct xt_table_info
+*xt_table_get_private_protected(const struct xt_table *table)
+{
+	return rcu_dereference_protected(table->private,
+					 mutex_is_locked(&xt[table->af].mutex));
+}
+EXPORT_SYMBOL(xt_table_get_private_protected);
+
 struct xt_table_info *
 xt_replace_table(struct xt_table *table,
 	      unsigned int num_counters,
@@ -1356,7 +1364,6 @@ xt_replace_table(struct xt_table *table,
 	      int *error)
 {
 	struct xt_table_info *private;
-	unsigned int cpu;
 	int ret;
 
 	ret = xt_jumpstack_alloc(newinfo);
@@ -1366,47 +1373,20 @@ xt_replace_table(struct xt_table *table,
 	}
 
 	/* Do the substitution. */
-	local_bh_disable();
-	private = table->private;
+	private = xt_table_get_private_protected(table);
 
 	/* Check inside lock: is the old number correct? */
 	if (num_counters != private->number) {
 		pr_debug("num_counters != table->private->number (%u/%u)\n",
 			 num_counters, private->number);
-		local_bh_enable();
 		*error = -EAGAIN;
 		return NULL;
 	}
 
 	newinfo->initial_entries = private->initial_entries;
-	/*
-	 * Ensure contents of newinfo are visible before assigning to
-	 * private.
-	 */
-	smp_wmb();
-	table->private = newinfo;
-
-	/* make sure all cpus see new ->private value */
-	smp_wmb();
 
-	/*
-	 * Even though table entries have now been swapped, other CPU's
-	 * may still be using the old entries...
-	 */
-	local_bh_enable();
-
-	/* ... so wait for even xt_recseq on all cpus */
-	for_each_possible_cpu(cpu) {
-		seqcount_t *s = &per_cpu(xt_recseq, cpu);
-		u32 seq = raw_read_seqcount(s);
-
-		if (seq & 1) {
-			do {
-				cond_resched();
-				cpu_relax();
-			} while (seq == raw_read_seqcount(s));
-		}
-	}
+	rcu_assign_pointer(table->private, newinfo);
+	synchronize_rcu();
 
 	audit_log_nfcfg(table->name, table->af, private->number,
 			!private->number ? AUDIT_XT_OP_REGISTER :
@@ -1442,12 +1422,12 @@ struct xt_table *xt_register_table(struct net *net,
 	}
 
 	/* Simplifies replace_table code. */
-	table->private = bootstrap;
+	rcu_assign_pointer(table->private, bootstrap);
 
 	if (!xt_replace_table(table, 0, newinfo, &ret))
 		goto unlock;
 
-	private = table->private;
+	private = xt_table_get_private_protected(table);
 	pr_debug("table->private->number = %u\n", private->number);
 
 	/* save number of initial entries */
@@ -1470,7 +1450,8 @@ void *xt_unregister_table(struct xt_table *table)
 	struct xt_table_info *private;
 
 	mutex_lock(&xt[table->af].mutex);
-	private = table->private;
+	private = xt_table_get_private_protected(table);
+	RCU_INIT_POINTER(table->private, NULL);
 	list_del(&table->list);
 	mutex_unlock(&xt[table->af].mutex);
 	audit_log_nfcfg(table->name, table->af, private->number,
-- 
2.20.1

