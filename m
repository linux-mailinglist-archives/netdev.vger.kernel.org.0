Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 663A418931E
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 01:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbgCRAlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 20:41:11 -0400
Received: from correo.us.es ([193.147.175.20]:45596 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727266AbgCRAkR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 20:40:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A9BBE27F8AF
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 960E3DA39F
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:45 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8B95ADA3AB; Wed, 18 Mar 2020 01:39:45 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 03921DA38D;
        Wed, 18 Mar 2020 01:39:43 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 18 Mar 2020 01:39:43 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D1E9F426CCB9;
        Wed, 18 Mar 2020 01:39:42 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 08/29] netfilter: Replace zero-length array with flexible-array member
Date:   Wed, 18 Mar 2020 01:39:35 +0100
Message-Id: <20200318003956.73573-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200318003956.73573-1-pablo@netfilter.org>
References: <20200318003956.73573-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

Lastly, fix checkpatch.pl warning
WARNING: __aligned(size) is preferred over __attribute__((aligned(size)))
in net/bridge/netfilter/ebtables.c

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/ipset/ip_set.h          | 2 +-
 include/linux/netfilter/x_tables.h              | 8 ++++----
 include/linux/netfilter_arp/arp_tables.h        | 2 +-
 include/linux/netfilter_bridge/ebtables.h       | 2 +-
 include/linux/netfilter_ipv4/ip_tables.h        | 2 +-
 include/linux/netfilter_ipv6/ip6_tables.h       | 2 +-
 include/net/netfilter/nf_conntrack_extend.h     | 2 +-
 include/net/netfilter/nf_conntrack_timeout.h    | 2 +-
 include/net/netfilter/nf_tables.h               | 6 +++---
 include/uapi/linux/netfilter_bridge/ebt_among.h | 2 +-
 net/bridge/netfilter/ebtables.c                 | 2 +-
 net/ipv4/netfilter/arp_tables.c                 | 4 ++--
 net/ipv4/netfilter/ip_tables.c                  | 4 ++--
 net/ipv6/netfilter/ip6_tables.c                 | 4 ++--
 net/netfilter/ipset/ip_set_bitmap_ip.c          | 2 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c       | 2 +-
 net/netfilter/ipset/ip_set_bitmap_port.c        | 2 +-
 net/netfilter/ipset/ip_set_hash_gen.h           | 4 ++--
 net/netfilter/nfnetlink_acct.c                  | 2 +-
 net/netfilter/nft_set_pipapo.c                  | 2 +-
 net/netfilter/xt_hashlimit.c                    | 2 +-
 net/netfilter/xt_recent.c                       | 4 ++--
 22 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 5448c8b443db..ab192720e2d6 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -98,7 +98,7 @@ struct ip_set_counter {
 
 struct ip_set_comment_rcu {
 	struct rcu_head rcu;
-	char str[0];
+	char str[];
 };
 
 struct ip_set_comment {
diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 1b261c51b3a3..5da88451853b 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -264,7 +264,7 @@ struct xt_table_info {
 	unsigned int stacksize;
 	void ***jumpstack;
 
-	unsigned char entries[0] __aligned(8);
+	unsigned char entries[] __aligned(8);
 };
 
 int xt_register_target(struct xt_target *target);
@@ -464,7 +464,7 @@ struct compat_xt_entry_match {
 		} kernel;
 		u_int16_t match_size;
 	} u;
-	unsigned char data[0];
+	unsigned char data[];
 };
 
 struct compat_xt_entry_target {
@@ -480,7 +480,7 @@ struct compat_xt_entry_target {
 		} kernel;
 		u_int16_t target_size;
 	} u;
-	unsigned char data[0];
+	unsigned char data[];
 };
 
 /* FIXME: this works only on 32 bit tasks
@@ -494,7 +494,7 @@ struct compat_xt_counters {
 struct compat_xt_counters_info {
 	char name[XT_TABLE_MAXNAMELEN];
 	compat_uint_t num_counters;
-	struct compat_xt_counters counters[0];
+	struct compat_xt_counters counters[];
 };
 
 struct _compat_xt_align {
diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index e98028f00e47..7d3537c40ec9 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -67,7 +67,7 @@ struct compat_arpt_entry {
 	__u16 next_offset;
 	compat_uint_t comefrom;
 	struct compat_xt_counters counters;
-	unsigned char elems[0];
+	unsigned char elems[];
 };
 
 static inline struct xt_entry_target *
diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index 162f59d0d17a..2f5c4e6ecd8a 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -85,7 +85,7 @@ struct ebt_table_info {
 	/* room to maintain the stack used for jumping from and into udc */
 	struct ebt_chainstack **chainstack;
 	char *entries;
-	struct ebt_counter counters[0] ____cacheline_aligned;
+	struct ebt_counter counters[] ____cacheline_aligned;
 };
 
 struct ebt_table {
diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index e9e1ed74cdf1..b394bd4f68a3 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -76,7 +76,7 @@ struct compat_ipt_entry {
 	__u16 next_offset;
 	compat_uint_t comefrom;
 	struct compat_xt_counters counters;
-	unsigned char elems[0];
+	unsigned char elems[];
 };
 
 /* Helper functions */
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 78ab959c4575..8225f7821a29 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -43,7 +43,7 @@ struct compat_ip6t_entry {
 	__u16 next_offset;
 	compat_uint_t comefrom;
 	struct compat_xt_counters counters;
-	unsigned char elems[0];
+	unsigned char elems[];
 };
 
 static inline struct xt_entry_target *
diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index 5ae5295aa46d..e1e588387103 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -45,7 +45,7 @@ enum nf_ct_ext_id {
 struct nf_ct_ext {
 	u8 offset[NF_CT_EXT_NUM];
 	u8 len;
-	char data[0];
+	char data[];
 };
 
 static inline bool __nf_ct_ext_exist(const struct nf_ct_ext *ext, u8 id)
diff --git a/include/net/netfilter/nf_conntrack_timeout.h b/include/net/netfilter/nf_conntrack_timeout.h
index 6dd72396f534..659b0ea25b4d 100644
--- a/include/net/netfilter/nf_conntrack_timeout.h
+++ b/include/net/netfilter/nf_conntrack_timeout.h
@@ -14,7 +14,7 @@
 struct nf_ct_timeout {
 	__u16			l3num;
 	const struct nf_conntrack_l4proto *l4proto;
-	char			data[0];
+	char			data[];
 };
 
 struct ctnl_timeout {
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index d913cdb6a27b..01f48b5e6bf2 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -224,7 +224,7 @@ int nft_validate_register_store(const struct nft_ctx *ctx,
  */
 struct nft_userdata {
 	u8			len;
-	unsigned char		data[0];
+	unsigned char		data[];
 };
 
 /**
@@ -565,7 +565,7 @@ struct nft_set_ext_tmpl {
 struct nft_set_ext {
 	u8	genmask;
 	u8	offset[NFT_SET_EXT_NUM];
-	char	data[0];
+	char	data[];
 };
 
 static inline void nft_set_ext_prepare(struct nft_set_ext_tmpl *tmpl)
@@ -1375,7 +1375,7 @@ struct nft_trans {
 	int				msg_type;
 	bool				put_net;
 	struct nft_ctx			ctx;
-	char				data[0];
+	char				data[];
 };
 
 struct nft_trans_rule {
diff --git a/include/uapi/linux/netfilter_bridge/ebt_among.h b/include/uapi/linux/netfilter_bridge/ebt_among.h
index 9acf757bc1f7..73b26a280c4f 100644
--- a/include/uapi/linux/netfilter_bridge/ebt_among.h
+++ b/include/uapi/linux/netfilter_bridge/ebt_among.h
@@ -40,7 +40,7 @@ struct ebt_mac_wormhash_tuple {
 struct ebt_mac_wormhash {
 	int table[257];
 	int poolsize;
-	struct ebt_mac_wormhash_tuple pool[0];
+	struct ebt_mac_wormhash_tuple pool[];
 };
 
 #define ebt_mac_wormhash_size(x) ((x) ? sizeof(struct ebt_mac_wormhash) \
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index e1256e03a9a8..78db58c7aec2 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1561,7 +1561,7 @@ struct compat_ebt_entry_mwt {
 		compat_uptr_t ptr;
 	} u;
 	compat_uint_t match_size;
-	compat_uint_t data[0] __attribute__ ((aligned (__alignof__(struct compat_ebt_replace))));
+	compat_uint_t data[] __aligned(__alignof__(struct compat_ebt_replace));
 };
 
 /* account for possible padding between match_size and ->data */
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index f1f78a742b36..b167f4a5b684 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1057,7 +1057,7 @@ struct compat_arpt_replace {
 	u32				underflow[NF_ARP_NUMHOOKS];
 	u32				num_counters;
 	compat_uptr_t			counters;
-	struct compat_arpt_entry	entries[0];
+	struct compat_arpt_entry	entries[];
 };
 
 static inline void compat_release_entry(struct compat_arpt_entry *e)
@@ -1383,7 +1383,7 @@ static int compat_copy_entries_to_user(unsigned int total_size,
 struct compat_arpt_get_entries {
 	char name[XT_TABLE_MAXNAMELEN];
 	compat_uint_t size;
-	struct compat_arpt_entry entrytable[0];
+	struct compat_arpt_entry entrytable[];
 };
 
 static int compat_get_entries(struct net *net,
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 10b91ebdf213..c2670eaa74e6 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1211,7 +1211,7 @@ struct compat_ipt_replace {
 	u32			underflow[NF_INET_NUMHOOKS];
 	u32			num_counters;
 	compat_uptr_t		counters;	/* struct xt_counters * */
-	struct compat_ipt_entry	entries[0];
+	struct compat_ipt_entry	entries[];
 };
 
 static int
@@ -1562,7 +1562,7 @@ compat_do_ipt_set_ctl(struct sock *sk,	int cmd, void __user *user,
 struct compat_ipt_get_entries {
 	char name[XT_TABLE_MAXNAMELEN];
 	compat_uint_t size;
-	struct compat_ipt_entry entrytable[0];
+	struct compat_ipt_entry entrytable[];
 };
 
 static int
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index c973ace208c5..e27393498ecb 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1227,7 +1227,7 @@ struct compat_ip6t_replace {
 	u32			underflow[NF_INET_NUMHOOKS];
 	u32			num_counters;
 	compat_uptr_t		counters;	/* struct xt_counters * */
-	struct compat_ip6t_entry entries[0];
+	struct compat_ip6t_entry entries[];
 };
 
 static int
@@ -1571,7 +1571,7 @@ compat_do_ip6t_set_ctl(struct sock *sk, int cmd, void __user *user,
 struct compat_ip6t_get_entries {
 	char name[XT_TABLE_MAXNAMELEN];
 	compat_uint_t size;
-	struct compat_ip6t_entry entrytable[0];
+	struct compat_ip6t_entry entrytable[];
 };
 
 static int
diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
index 0a2196f59106..486959f70cf3 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -46,7 +46,7 @@ struct bitmap_ip {
 	u8 netmask;		/* subnet netmask */
 	struct timer_list gc;	/* garbage collection */
 	struct ip_set *set;	/* attached to this ip_set */
-	unsigned char extensions[0]	/* data extensions */
+	unsigned char extensions[]	/* data extensions */
 		__aligned(__alignof__(u64));
 };
 
diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index 739e343efaf6..2310a316e0af 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -49,7 +49,7 @@ struct bitmap_ipmac {
 	size_t memsize;		/* members size */
 	struct timer_list gc;	/* garbage collector */
 	struct ip_set *set;	/* attached to this ip_set */
-	unsigned char extensions[0]	/* MAC + data extensions */
+	unsigned char extensions[]	/* MAC + data extensions */
 		__aligned(__alignof__(u64));
 };
 
diff --git a/net/netfilter/ipset/ip_set_bitmap_port.c b/net/netfilter/ipset/ip_set_bitmap_port.c
index b49978dd810d..e56ced66f202 100644
--- a/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -37,7 +37,7 @@ struct bitmap_port {
 	size_t memsize;		/* members size */
 	struct timer_list gc;	/* garbage collection */
 	struct ip_set *set;	/* attached to this ip_set */
-	unsigned char extensions[0]	/* data extensions */
+	unsigned char extensions[]	/* data extensions */
 		__aligned(__alignof__(u64));
 };
 
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index e52d7b7597a0..1ee43752d6d3 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -76,7 +76,7 @@ struct hbucket {
 	DECLARE_BITMAP(used, AHASH_MAX_TUNED);
 	u8 size;		/* size of the array */
 	u8 pos;			/* position of the first free entry */
-	unsigned char value[0]	/* the array of the values */
+	unsigned char value[]	/* the array of the values */
 		__aligned(__alignof__(u64));
 };
 
@@ -109,7 +109,7 @@ struct htable {
 	u8 htable_bits;		/* size of hash table == 2^htable_bits */
 	u32 maxelem;		/* Maxelem per region */
 	struct ip_set_region *hregion;	/* Region locks and ext sizes */
-	struct hbucket __rcu *bucket[0]; /* hashtable buckets */
+	struct hbucket __rcu *bucket[]; /* hashtable buckets */
 };
 
 #define hbucket(h, i)		((h)->bucket[i])
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 2481470dec36..5827117f2635 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -33,7 +33,7 @@ struct nf_acct {
 	refcount_t		refcnt;
 	char			name[NFACCT_NAME_MAX];
 	struct rcu_head		rcu_head;
-	char			data[0];
+	char			data[];
 };
 
 struct nfacct_filter {
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index d752a39b97d6..26395c8188b1 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -433,7 +433,7 @@ struct nft_pipapo_match {
 	unsigned long * __percpu *scratch;
 	size_t bsize_max;
 	struct rcu_head rcu;
-	struct nft_pipapo_field f[0];
+	struct nft_pipapo_field f[];
 };
 
 /* Current working bitmap index, toggled between field matches */
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 8c835ad63729..9c5cfd74a0ee 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -132,7 +132,7 @@ struct xt_hashlimit_htable {
 	const char *name;
 	struct net *net;
 
-	struct hlist_head hash[0];	/* hashtable itself */
+	struct hlist_head hash[];	/* hashtable itself */
 };
 
 static int
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 225a7ab6d79a..19bef176145e 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -71,7 +71,7 @@ struct recent_entry {
 	u_int8_t		ttl;
 	u_int8_t		index;
 	u_int16_t		nstamps;
-	unsigned long		stamps[0];
+	unsigned long		stamps[];
 };
 
 struct recent_table {
@@ -82,7 +82,7 @@ struct recent_table {
 	unsigned int		entries;
 	u8			nstamps_max_mask;
 	struct list_head	lru_list;
-	struct list_head	iphash[0];
+	struct list_head	iphash[];
 };
 
 struct recent_net {
-- 
2.11.0

