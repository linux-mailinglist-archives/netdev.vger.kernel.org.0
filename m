Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B73FD36B7BB
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235710AbhDZRMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:12:31 -0400
Received: from mail.netfilter.org ([217.70.188.207]:51544 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236066AbhDZRMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 13:12:00 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 058D364130;
        Mon, 26 Apr 2021 19:10:39 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 22/22] netfilter: allow to turn off xtables compat layer
Date:   Mon, 26 Apr 2021 19:10:56 +0200
Message-Id: <20210426171056.345271-23-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210426171056.345271-1-pablo@netfilter.org>
References: <20210426171056.345271-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The compat layer needs to parse untrusted input (the ruleset)
to translate it to a 64bit compatible format.

We had a number of bugs in this department in the past, so allow users
to turn this feature off.

Add CONFIG_NETFILTER_XTABLES_COMPAT kconfig knob and make it default to y
to keep existing behaviour.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/x_tables.h        | 12 ++++++------
 include/linux/netfilter_arp/arp_tables.h  |  2 +-
 include/linux/netfilter_ipv4/ip_tables.h  |  2 +-
 include/linux/netfilter_ipv6/ip6_tables.h |  2 +-
 net/bridge/netfilter/ebt_limit.c          |  4 ++--
 net/bridge/netfilter/ebt_mark.c           |  4 ++--
 net/bridge/netfilter/ebt_mark_m.c         |  4 ++--
 net/bridge/netfilter/ebtables.c           | 12 ++++++------
 net/ipv4/netfilter/arp_tables.c           | 16 ++++++++--------
 net/ipv4/netfilter/ip_tables.c            | 16 ++++++++--------
 net/ipv4/netfilter/ipt_CLUSTERIP.c        |  8 ++++----
 net/ipv6/netfilter/ip6_tables.c           | 16 ++++++++--------
 net/netfilter/Kconfig                     | 10 ++++++++++
 net/netfilter/x_tables.c                  | 16 ++++++++--------
 net/netfilter/xt_limit.c                  |  6 +++---
 15 files changed, 70 insertions(+), 60 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index a52cc22f806a..07c6ad8f2a02 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -158,7 +158,7 @@ struct xt_match {
 
 	/* Called when entry of this type deleted. */
 	void (*destroy)(const struct xt_mtdtor_param *);
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 	/* Called when userspace align differs from kernel space one */
 	void (*compat_from_user)(void *dst, const void *src);
 	int (*compat_to_user)(void __user *dst, const void *src);
@@ -169,7 +169,7 @@ struct xt_match {
 	const char *table;
 	unsigned int matchsize;
 	unsigned int usersize;
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 	unsigned int compatsize;
 #endif
 	unsigned int hooks;
@@ -199,7 +199,7 @@ struct xt_target {
 
 	/* Called when entry of this type deleted. */
 	void (*destroy)(const struct xt_tgdtor_param *);
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 	/* Called when userspace align differs from kernel space one */
 	void (*compat_from_user)(void *dst, const void *src);
 	int (*compat_to_user)(void __user *dst, const void *src);
@@ -210,7 +210,7 @@ struct xt_target {
 	const char *table;
 	unsigned int targetsize;
 	unsigned int usersize;
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 	unsigned int compatsize;
 #endif
 	unsigned int hooks;
@@ -452,7 +452,7 @@ xt_get_per_cpu_counter(struct xt_counters *cnt, unsigned int cpu)
 
 struct nf_hook_ops *xt_hook_ops_alloc(const struct xt_table *, nf_hookfn *);
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 #include <net/compat.h>
 
 struct compat_xt_entry_match {
@@ -533,5 +533,5 @@ int xt_compat_check_entry_offsets(const void *base, const char *elems,
 				  unsigned int target_offset,
 				  unsigned int next_offset);
 
-#endif /* CONFIG_COMPAT */
+#endif /* CONFIG_NETFILTER_XTABLES_COMPAT */
 #endif /* _X_TABLES_H */
diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index a0474b4e7782..2aab9612f6ab 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -59,7 +59,7 @@ extern unsigned int arpt_do_table(struct sk_buff *skb,
 				  const struct nf_hook_state *state,
 				  struct xt_table *table);
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 #include <net/compat.h>
 
 struct compat_arpt_entry {
diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index 0fdab3246ef5..8d09bfe850dc 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -67,7 +67,7 @@ extern unsigned int ipt_do_table(struct sk_buff *skb,
 				 const struct nf_hook_state *state,
 				 struct xt_table *table);
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 #include <net/compat.h>
 
 struct compat_ipt_entry {
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 11d0e725fe79..79e73fd7d965 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -33,7 +33,7 @@ extern unsigned int ip6t_do_table(struct sk_buff *skb,
 				  const struct nf_hook_state *state,
 				  struct xt_table *table);
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 #include <net/compat.h>
 
 struct compat_ip6t_entry {
diff --git a/net/bridge/netfilter/ebt_limit.c b/net/bridge/netfilter/ebt_limit.c
index fa199556e122..e16183bd1bb8 100644
--- a/net/bridge/netfilter/ebt_limit.c
+++ b/net/bridge/netfilter/ebt_limit.c
@@ -87,7 +87,7 @@ static int ebt_limit_mt_check(const struct xt_mtchk_param *par)
 }
 
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 /*
  * no conversion function needed --
  * only avg/burst have meaningful values in userspace.
@@ -107,7 +107,7 @@ static struct xt_match ebt_limit_mt_reg __read_mostly = {
 	.checkentry	= ebt_limit_mt_check,
 	.matchsize	= sizeof(struct ebt_limit_info),
 	.usersize	= offsetof(struct ebt_limit_info, prev),
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 	.compatsize	= sizeof(struct ebt_compat_limit_info),
 #endif
 	.me		= THIS_MODULE,
diff --git a/net/bridge/netfilter/ebt_mark.c b/net/bridge/netfilter/ebt_mark.c
index 21fd3d3d77f6..8cf653c72fd8 100644
--- a/net/bridge/netfilter/ebt_mark.c
+++ b/net/bridge/netfilter/ebt_mark.c
@@ -53,7 +53,7 @@ static int ebt_mark_tg_check(const struct xt_tgchk_param *par)
 		return -EINVAL;
 	return 0;
 }
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 struct compat_ebt_mark_t_info {
 	compat_ulong_t mark;
 	compat_uint_t target;
@@ -87,7 +87,7 @@ static struct xt_target ebt_mark_tg_reg __read_mostly = {
 	.target		= ebt_mark_tg,
 	.checkentry	= ebt_mark_tg_check,
 	.targetsize	= sizeof(struct ebt_mark_t_info),
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 	.compatsize	= sizeof(struct compat_ebt_mark_t_info),
 	.compat_from_user = mark_tg_compat_from_user,
 	.compat_to_user	= mark_tg_compat_to_user,
diff --git a/net/bridge/netfilter/ebt_mark_m.c b/net/bridge/netfilter/ebt_mark_m.c
index 81fb59dec499..5872e73c741e 100644
--- a/net/bridge/netfilter/ebt_mark_m.c
+++ b/net/bridge/netfilter/ebt_mark_m.c
@@ -37,7 +37,7 @@ static int ebt_mark_mt_check(const struct xt_mtchk_param *par)
 }
 
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 struct compat_ebt_mark_m_info {
 	compat_ulong_t mark, mask;
 	uint8_t invert, bitmask;
@@ -75,7 +75,7 @@ static struct xt_match ebt_mark_mt_reg __read_mostly = {
 	.match		= ebt_mark_mt,
 	.checkentry	= ebt_mark_mt_check,
 	.matchsize	= sizeof(struct ebt_mark_m_info),
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 	.compatsize	= sizeof(struct compat_ebt_mark_m_info),
 	.compat_from_user = mark_mt_compat_from_user,
 	.compat_to_user	= mark_mt_compat_to_user,
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index a04596bb2a6e..f022deb3721e 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -47,7 +47,7 @@ struct ebt_pernet {
 static unsigned int ebt_pernet_id __read_mostly;
 static DEFINE_MUTEX(ebt_mutex);
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 static void ebt_standard_compat_from_user(void *dst, const void *src)
 {
 	int v = *(compat_int_t *)src;
@@ -73,7 +73,7 @@ static struct xt_target ebt_standard_target = {
 	.revision   = 0,
 	.family     = NFPROTO_BRIDGE,
 	.targetsize = sizeof(int),
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 	.compatsize = sizeof(compat_int_t),
 	.compat_from_user = ebt_standard_compat_from_user,
 	.compat_to_user =  ebt_standard_compat_to_user,
@@ -1502,7 +1502,7 @@ static int copy_everything_to_user(struct ebt_table *t, void __user *user,
 	   ebt_entry_to_user, entries, tmp.entries);
 }
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 /* 32 bit-userspace compatibility definitions. */
 struct compat_ebt_replace {
 	char name[EBT_TABLE_MAXNAMELEN];
@@ -2367,7 +2367,7 @@ static int do_ebt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 	/* try real handler in case userland supplied needed padding */
 	if (in_compat_syscall() &&
 	    ((cmd != EBT_SO_GET_INFO && cmd != EBT_SO_GET_INIT_INFO) ||
@@ -2434,7 +2434,7 @@ static int do_ebt_set_ctl(struct sock *sk, int cmd, sockptr_t arg,
 
 	switch (cmd) {
 	case EBT_SO_SET_ENTRIES:
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 		if (in_compat_syscall())
 			ret = compat_do_replace(net, arg, len);
 		else
@@ -2442,7 +2442,7 @@ static int do_ebt_set_ctl(struct sock *sk, int cmd, sockptr_t arg,
 			ret = do_replace(net, arg, len);
 		break;
 	case EBT_SO_SET_COUNTERS:
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 		if (in_compat_syscall())
 			ret = compat_update_counters(net, arg, len);
 		else
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index b1bb6a7e2dd7..cf20316094d0 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -713,7 +713,7 @@ static int copy_entries_to_user(unsigned int total_size,
 	return ret;
 }
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 static void compat_standard_from_user(void *dst, const void *src)
 {
 	int v = *(compat_int_t *)src;
@@ -800,7 +800,7 @@ static int get_info(struct net *net, void __user *user, const int *len)
 		return -EFAULT;
 
 	name[XT_TABLE_MAXNAMELEN-1] = '\0';
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 	if (in_compat_syscall())
 		xt_compat_lock(NFPROTO_ARP);
 #endif
@@ -808,7 +808,7 @@ static int get_info(struct net *net, void __user *user, const int *len)
 	if (!IS_ERR(t)) {
 		struct arpt_getinfo info;
 		const struct xt_table_info *private = t->private;
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 		struct xt_table_info tmp;
 
 		if (in_compat_syscall()) {
@@ -835,7 +835,7 @@ static int get_info(struct net *net, void __user *user, const int *len)
 		module_put(t->me);
 	} else
 		ret = PTR_ERR(t);
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 	if (in_compat_syscall())
 		xt_compat_unlock(NFPROTO_ARP);
 #endif
@@ -1044,7 +1044,7 @@ static int do_add_counters(struct net *net, sockptr_t arg, unsigned int len)
 	return ret;
 }
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 struct compat_arpt_replace {
 	char				name[XT_TABLE_MAXNAMELEN];
 	u32				valid_hooks;
@@ -1412,7 +1412,7 @@ static int do_arpt_set_ctl(struct sock *sk, int cmd, sockptr_t arg,
 
 	switch (cmd) {
 	case ARPT_SO_SET_REPLACE:
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 		if (in_compat_syscall())
 			ret = compat_do_replace(sock_net(sk), arg, len);
 		else
@@ -1444,7 +1444,7 @@ static int do_arpt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len
 		break;
 
 	case ARPT_SO_GET_ENTRIES:
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 		if (in_compat_syscall())
 			ret = compat_get_entries(sock_net(sk), user, len);
 		else
@@ -1580,7 +1580,7 @@ static struct xt_target arpt_builtin_tg[] __read_mostly = {
 		.name             = XT_STANDARD_TARGET,
 		.targetsize       = sizeof(int),
 		.family           = NFPROTO_ARP,
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 		.compatsize       = sizeof(compat_int_t),
 		.compat_from_user = compat_standard_from_user,
 		.compat_to_user   = compat_standard_to_user,
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index d6caaed5dd45..13acb687c19a 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -868,7 +868,7 @@ copy_entries_to_user(unsigned int total_size,
 	return ret;
 }
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 static void compat_standard_from_user(void *dst, const void *src)
 {
 	int v = *(compat_int_t *)src;
@@ -957,7 +957,7 @@ static int get_info(struct net *net, void __user *user, const int *len)
 		return -EFAULT;
 
 	name[XT_TABLE_MAXNAMELEN-1] = '\0';
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 	if (in_compat_syscall())
 		xt_compat_lock(AF_INET);
 #endif
@@ -965,7 +965,7 @@ static int get_info(struct net *net, void __user *user, const int *len)
 	if (!IS_ERR(t)) {
 		struct ipt_getinfo info;
 		const struct xt_table_info *private = t->private;
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 		struct xt_table_info tmp;
 
 		if (in_compat_syscall()) {
@@ -993,7 +993,7 @@ static int get_info(struct net *net, void __user *user, const int *len)
 		module_put(t->me);
 	} else
 		ret = PTR_ERR(t);
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 	if (in_compat_syscall())
 		xt_compat_unlock(AF_INET);
 #endif
@@ -1199,7 +1199,7 @@ do_add_counters(struct net *net, sockptr_t arg, unsigned int len)
 	return ret;
 }
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 struct compat_ipt_replace {
 	char			name[XT_TABLE_MAXNAMELEN];
 	u32			valid_hooks;
@@ -1621,7 +1621,7 @@ do_ipt_set_ctl(struct sock *sk, int cmd, sockptr_t arg, unsigned int len)
 
 	switch (cmd) {
 	case IPT_SO_SET_REPLACE:
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 		if (in_compat_syscall())
 			ret = compat_do_replace(sock_net(sk), arg, len);
 		else
@@ -1654,7 +1654,7 @@ do_ipt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 		break;
 
 	case IPT_SO_GET_ENTRIES:
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 		if (in_compat_syscall())
 			ret = compat_get_entries(sock_net(sk), user, len);
 		else
@@ -1846,7 +1846,7 @@ static struct xt_target ipt_builtin_tg[] __read_mostly = {
 		.name             = XT_STANDARD_TARGET,
 		.targetsize       = sizeof(int),
 		.family           = NFPROTO_IPV4,
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 		.compatsize       = sizeof(compat_int_t),
 		.compat_from_user = compat_standard_from_user,
 		.compat_to_user   = compat_standard_to_user,
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index a8b980ad11d4..8f7ca67475b7 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -541,7 +541,7 @@ static void clusterip_tg_destroy(const struct xt_tgdtor_param *par)
 	nf_ct_netns_put(par->net, par->family);
 }
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 struct compat_ipt_clusterip_tgt_info
 {
 	u_int32_t	flags;
@@ -553,7 +553,7 @@ struct compat_ipt_clusterip_tgt_info
 	u_int32_t	hash_initval;
 	compat_uptr_t	config;
 };
-#endif /* CONFIG_COMPAT */
+#endif /* CONFIG_NETFILTER_XTABLES_COMPAT */
 
 static struct xt_target clusterip_tg_reg __read_mostly = {
 	.name		= "CLUSTERIP",
@@ -563,9 +563,9 @@ static struct xt_target clusterip_tg_reg __read_mostly = {
 	.destroy	= clusterip_tg_destroy,
 	.targetsize	= sizeof(struct ipt_clusterip_tgt_info),
 	.usersize	= offsetof(struct ipt_clusterip_tgt_info, config),
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 	.compatsize	= sizeof(struct compat_ipt_clusterip_tgt_info),
-#endif /* CONFIG_COMPAT */
+#endif /* CONFIG_NETFILTER_XTABLES_COMPAT */
 	.me		= THIS_MODULE
 };
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index e763716ffa25..e810a23baf99 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -884,7 +884,7 @@ copy_entries_to_user(unsigned int total_size,
 	return ret;
 }
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 static void compat_standard_from_user(void *dst, const void *src)
 {
 	int v = *(compat_int_t *)src;
@@ -973,7 +973,7 @@ static int get_info(struct net *net, void __user *user, const int *len)
 		return -EFAULT;
 
 	name[XT_TABLE_MAXNAMELEN-1] = '\0';
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 	if (in_compat_syscall())
 		xt_compat_lock(AF_INET6);
 #endif
@@ -981,7 +981,7 @@ static int get_info(struct net *net, void __user *user, const int *len)
 	if (!IS_ERR(t)) {
 		struct ip6t_getinfo info;
 		const struct xt_table_info *private = t->private;
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 		struct xt_table_info tmp;
 
 		if (in_compat_syscall()) {
@@ -1009,7 +1009,7 @@ static int get_info(struct net *net, void __user *user, const int *len)
 		module_put(t->me);
 	} else
 		ret = PTR_ERR(t);
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 	if (in_compat_syscall())
 		xt_compat_unlock(AF_INET6);
 #endif
@@ -1215,7 +1215,7 @@ do_add_counters(struct net *net, sockptr_t arg, unsigned int len)
 	return ret;
 }
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 struct compat_ip6t_replace {
 	char			name[XT_TABLE_MAXNAMELEN];
 	u32			valid_hooks;
@@ -1630,7 +1630,7 @@ do_ip6t_set_ctl(struct sock *sk, int cmd, sockptr_t arg, unsigned int len)
 
 	switch (cmd) {
 	case IP6T_SO_SET_REPLACE:
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 		if (in_compat_syscall())
 			ret = compat_do_replace(sock_net(sk), arg, len);
 		else
@@ -1663,7 +1663,7 @@ do_ip6t_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 		break;
 
 	case IP6T_SO_GET_ENTRIES:
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 		if (in_compat_syscall())
 			ret = compat_get_entries(sock_net(sk), user, len);
 		else
@@ -1853,7 +1853,7 @@ static struct xt_target ip6t_builtin_tg[] __read_mostly = {
 		.name             = XT_STANDARD_TARGET,
 		.targetsize       = sizeof(int),
 		.family           = NFPROTO_IPV6,
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 		.compatsize       = sizeof(compat_int_t),
 		.compat_from_user = compat_standard_from_user,
 		.compat_to_user   = compat_standard_to_user,
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index fcd8682704c4..56a2531a3402 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -728,6 +728,16 @@ config NETFILTER_XTABLES
 
 if NETFILTER_XTABLES
 
+config NETFILTER_XTABLES_COMPAT
+	bool "Netfilter Xtables 32bit support"
+	depends on COMPAT
+	default y
+	help
+	   This option provides a translation layer to run 32bit arp,ip(6),ebtables
+	   binaries on 64bit kernels.
+
+	   If unsure, say N.
+
 comment "Xtables combined modules"
 
 config NETFILTER_XT_MARK
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index ef37deff8405..84e58ee501a4 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -52,7 +52,7 @@ struct xt_af {
 	struct mutex mutex;
 	struct list_head match;
 	struct list_head target;
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 	struct mutex compat_mutex;
 	struct compat_delta *compat_tab;
 	unsigned int number; /* number of slots in compat_tab[] */
@@ -647,7 +647,7 @@ static bool error_tg_ok(unsigned int usersize, unsigned int kernsize,
 	return usersize == kernsize && strnlen(msg, msglen) < msglen;
 }
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 int xt_compat_add_offset(u_int8_t af, unsigned int offset, int delta)
 {
 	struct xt_af *xp = &xt[af];
@@ -850,7 +850,7 @@ int xt_compat_check_entry_offsets(const void *base, const char *elems,
 				    __alignof__(struct compat_xt_entry_match));
 }
 EXPORT_SYMBOL(xt_compat_check_entry_offsets);
-#endif /* CONFIG_COMPAT */
+#endif /* CONFIG_NETFILTER_XTABLES_COMPAT */
 
 /**
  * xt_check_entry_offsets - validate arp/ip/ip6t_entry
@@ -868,7 +868,7 @@ EXPORT_SYMBOL(xt_compat_check_entry_offsets);
  * match structures are aligned, and that the last structure ends where
  * the target structure begins.
  *
- * Also see xt_compat_check_entry_offsets for CONFIG_COMPAT version.
+ * Also see xt_compat_check_entry_offsets for CONFIG_NETFILTER_XTABLES_COMPAT version.
  *
  * The arp/ip/ip6t_entry structure @base must have passed following tests:
  * - it must point to a valid memory location
@@ -1059,7 +1059,7 @@ void *xt_copy_counters(sockptr_t arg, unsigned int len,
 	void *mem;
 	u64 size;
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 	if (in_compat_syscall()) {
 		/* structures only differ in size due to alignment */
 		struct compat_xt_counters_info compat_tmp;
@@ -1106,7 +1106,7 @@ void *xt_copy_counters(sockptr_t arg, unsigned int len,
 }
 EXPORT_SYMBOL_GPL(xt_copy_counters);
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 int xt_compat_target_offset(const struct xt_target *target)
 {
 	u_int16_t csize = target->compatsize ? : target->targetsize;
@@ -1293,7 +1293,7 @@ void xt_table_unlock(struct xt_table *table)
 }
 EXPORT_SYMBOL_GPL(xt_table_unlock);
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 void xt_compat_lock(u_int8_t af)
 {
 	mutex_lock(&xt[af].compat_mutex);
@@ -1931,7 +1931,7 @@ static int __init xt_init(void)
 
 	for (i = 0; i < NFPROTO_NUMPROTO; i++) {
 		mutex_init(&xt[i].mutex);
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 		mutex_init(&xt[i].compat_mutex);
 		xt[i].compat_tab = NULL;
 #endif
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index bd1dea9c7b88..24d4afb9988d 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -134,7 +134,7 @@ static void limit_mt_destroy(const struct xt_mtdtor_param *par)
 	kfree(info->master);
 }
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 struct compat_xt_rateinfo {
 	u_int32_t avg;
 	u_int32_t burst;
@@ -176,7 +176,7 @@ static int limit_mt_compat_to_user(void __user *dst, const void *src)
 	};
 	return copy_to_user(dst, &cm, sizeof(cm)) ? -EFAULT : 0;
 }
-#endif /* CONFIG_COMPAT */
+#endif /* CONFIG_NETFILTER_XTABLES_COMPAT */
 
 static struct xt_match limit_mt_reg __read_mostly = {
 	.name             = "limit",
@@ -186,7 +186,7 @@ static struct xt_match limit_mt_reg __read_mostly = {
 	.checkentry       = limit_mt_check,
 	.destroy          = limit_mt_destroy,
 	.matchsize        = sizeof(struct xt_rateinfo),
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 	.compatsize       = sizeof(struct compat_xt_rateinfo),
 	.compat_from_user = limit_mt_compat_from_user,
 	.compat_to_user   = limit_mt_compat_to_user,
-- 
2.30.2

