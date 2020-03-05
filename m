Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F06DE17ACD5
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 18:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbgCERNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 12:13:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:39498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727359AbgCERNu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 12:13:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1429F20848;
        Thu,  5 Mar 2020 17:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428428;
        bh=9BomOEDdG4KGQeMyPpQVy/7nCcOS//vi9vhan5UNMiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jOS8+Rlbp5J30vlzNhbe7uAbHg2P4WqhqgTxsRkZ9Nam/I2uq+sluXcE7pabqv/+r
         UvtoSWTeg6/Dew9lABlI9Y+MxwHSWrcCOR1XjsCybTCJLL9AtTQMAuSJ/6uPzHJeKD
         vz+jAhVcFbcsJGp3iMY3k5HebcXk3VoZ6ekVChXA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        syzbot+4b0e9d4ff3cf117837e5@syzkaller.appspotmail.com,
        syzbot+c27b8d5010f45c666ed1@syzkaller.appspotmail.com,
        syzbot+68a806795ac89df3aa1c@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 28/67] netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" reports
Date:   Thu,  5 Mar 2020 12:12:29 -0500
Message-Id: <20200305171309.29118-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305171309.29118-1-sashal@kernel.org>
References: <20200305171309.29118-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jozsef Kadlecsik <kadlec@netfilter.org>

[ Upstream commit f66ee0410b1c3481ee75e5db9b34547b4d582465 ]

In the case of huge hash:* types of sets, due to the single spinlock of
a set the processing of the whole set under spinlock protection could take
too long.

There were four places where the whole hash table of the set was processed
from bucket to bucket under holding the spinlock:

- During resizing a set, the original set was locked to exclude kernel side
  add/del element operations (userspace add/del is excluded by the
  nfnetlink mutex). The original set is actually just read during the
  resize, so the spinlocking is replaced with rcu locking of regions.
  However, thus there can be parallel kernel side add/del of entries.
  In order not to loose those operations a backlog is added and replayed
  after the successful resize.
- Garbage collection of timed out entries was also protected by the spinlock.
  In order not to lock too long, region locking is introduced and a single
  region is processed in one gc go. Also, the simple timer based gc running
  is replaced with a workqueue based solution. The internal book-keeping
  (number of elements, size of extensions) is moved to region level due to
  the region locking.
- Adding elements: when the max number of the elements is reached, the gc
  was called to evict the timed out entries. The new approach is that the gc
  is called just for the matching region, assuming that if the region
  (proportionally) seems to be full, then the whole set does. We could scan
  the other regions to check every entry under rcu locking, but for huge
  sets it'd mean a slowdown at adding elements.
- Listing the set header data: when the set was defined with timeout
  support, the garbage collector was called to clean up timed out entries
  to get the correct element numbers and set size values. Now the set is
  scanned to check non-timed out entries, without actually calling the gc
  for the whole set.

Thanks to Florian Westphal for helping me to solve the SOFTIRQ-safe ->
SOFTIRQ-unsafe lock order issues during working on the patch.

Reported-by: syzbot+4b0e9d4ff3cf117837e5@syzkaller.appspotmail.com
Reported-by: syzbot+c27b8d5010f45c666ed1@syzkaller.appspotmail.com
Reported-by: syzbot+68a806795ac89df3aa1c@syzkaller.appspotmail.com
Fixes: 23c42a403a9c ("netfilter: ipset: Introduction of new commands and protocol version 7")
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netfilter/ipset/ip_set.h |  11 +-
 net/netfilter/ipset/ip_set_core.c      |  34 +-
 net/netfilter/ipset/ip_set_hash_gen.h  | 633 +++++++++++++++++--------
 3 files changed, 472 insertions(+), 206 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 908d38dbcb91f..5448c8b443dbf 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -121,6 +121,7 @@ struct ip_set_ext {
 	u32 timeout;
 	u8 packets_op;
 	u8 bytes_op;
+	bool target;
 };
 
 struct ip_set;
@@ -187,6 +188,14 @@ struct ip_set_type_variant {
 	/* Return true if "b" set is the same as "a"
 	 * according to the create set parameters */
 	bool (*same_set)(const struct ip_set *a, const struct ip_set *b);
+	/* Region-locking is used */
+	bool region_lock;
+};
+
+struct ip_set_region {
+	spinlock_t lock;	/* Region lock */
+	size_t ext_size;	/* Size of the dynamic extensions */
+	u32 elements;		/* Number of elements vs timeout */
 };
 
 /* The core set type structure */
@@ -501,7 +510,7 @@ ip_set_init_skbinfo(struct ip_set_skbinfo *skbinfo,
 }
 
 #define IP_SET_INIT_KEXT(skb, opt, set)			\
-	{ .bytes = (skb)->len, .packets = 1,		\
+	{ .bytes = (skb)->len, .packets = 1, .target = true,\
 	  .timeout = ip_set_adt_opt_timeout(opt, set) }
 
 #define IP_SET_INIT_UEXT(set)				\
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 69c107f9ba8db..8dd17589217d7 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -723,6 +723,20 @@ ip_set_rcu_get(struct net *net, ip_set_id_t index)
 	return set;
 }
 
+static inline void
+ip_set_lock(struct ip_set *set)
+{
+	if (!set->variant->region_lock)
+		spin_lock_bh(&set->lock);
+}
+
+static inline void
+ip_set_unlock(struct ip_set *set)
+{
+	if (!set->variant->region_lock)
+		spin_unlock_bh(&set->lock);
+}
+
 int
 ip_set_test(ip_set_id_t index, const struct sk_buff *skb,
 	    const struct xt_action_param *par, struct ip_set_adt_opt *opt)
@@ -744,9 +758,9 @@ ip_set_test(ip_set_id_t index, const struct sk_buff *skb,
 	if (ret == -EAGAIN) {
 		/* Type requests element to be completed */
 		pr_debug("element must be completed, ADD is triggered\n");
-		spin_lock_bh(&set->lock);
+		ip_set_lock(set);
 		set->variant->kadt(set, skb, par, IPSET_ADD, opt);
-		spin_unlock_bh(&set->lock);
+		ip_set_unlock(set);
 		ret = 1;
 	} else {
 		/* --return-nomatch: invert matched element */
@@ -775,9 +789,9 @@ ip_set_add(ip_set_id_t index, const struct sk_buff *skb,
 	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
 		return -IPSET_ERR_TYPE_MISMATCH;
 
-	spin_lock_bh(&set->lock);
+	ip_set_lock(set);
 	ret = set->variant->kadt(set, skb, par, IPSET_ADD, opt);
-	spin_unlock_bh(&set->lock);
+	ip_set_unlock(set);
 
 	return ret;
 }
@@ -797,9 +811,9 @@ ip_set_del(ip_set_id_t index, const struct sk_buff *skb,
 	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
 		return -IPSET_ERR_TYPE_MISMATCH;
 
-	spin_lock_bh(&set->lock);
+	ip_set_lock(set);
 	ret = set->variant->kadt(set, skb, par, IPSET_DEL, opt);
-	spin_unlock_bh(&set->lock);
+	ip_set_unlock(set);
 
 	return ret;
 }
@@ -1264,9 +1278,9 @@ ip_set_flush_set(struct ip_set *set)
 {
 	pr_debug("set: %s\n",  set->name);
 
-	spin_lock_bh(&set->lock);
+	ip_set_lock(set);
 	set->variant->flush(set);
-	spin_unlock_bh(&set->lock);
+	ip_set_unlock(set);
 }
 
 static int ip_set_flush(struct net *net, struct sock *ctnl, struct sk_buff *skb,
@@ -1713,9 +1727,9 @@ call_ad(struct sock *ctnl, struct sk_buff *skb, struct ip_set *set,
 	bool eexist = flags & IPSET_FLAG_EXIST, retried = false;
 
 	do {
-		spin_lock_bh(&set->lock);
+		ip_set_lock(set);
 		ret = set->variant->uadt(set, tb, adt, &lineno, flags, retried);
-		spin_unlock_bh(&set->lock);
+		ip_set_unlock(set);
 		retried = true;
 	} while (ret == -EAGAIN &&
 		 set->variant->resize &&
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 7480ce55b5c85..71e93eac08319 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -7,13 +7,21 @@
 #include <linux/rcupdate.h>
 #include <linux/jhash.h>
 #include <linux/types.h>
+#include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/ipset/ip_set.h>
 
-#define __ipset_dereference_protected(p, c)	rcu_dereference_protected(p, c)
-#define ipset_dereference_protected(p, set) \
-	__ipset_dereference_protected(p, lockdep_is_held(&(set)->lock))
-
-#define rcu_dereference_bh_nfnl(p)	rcu_dereference_bh_check(p, 1)
+#define __ipset_dereference(p)		\
+	rcu_dereference_protected(p, 1)
+#define ipset_dereference_nfnl(p)	\
+	rcu_dereference_protected(p,	\
+		lockdep_nfnl_is_held(NFNL_SUBSYS_IPSET))
+#define ipset_dereference_set(p, set) 	\
+	rcu_dereference_protected(p,	\
+		lockdep_nfnl_is_held(NFNL_SUBSYS_IPSET) || \
+		lockdep_is_held(&(set)->lock))
+#define ipset_dereference_bh_nfnl(p)	\
+	rcu_dereference_bh_check(p, 	\
+		lockdep_nfnl_is_held(NFNL_SUBSYS_IPSET))
 
 /* Hashing which uses arrays to resolve clashing. The hash table is resized
  * (doubled) when searching becomes too long.
@@ -72,11 +80,35 @@ struct hbucket {
 		__aligned(__alignof__(u64));
 };
 
+/* Region size for locking == 2^HTABLE_REGION_BITS */
+#define HTABLE_REGION_BITS	10
+#define ahash_numof_locks(htable_bits)		\
+	((htable_bits) < HTABLE_REGION_BITS ? 1	\
+		: jhash_size((htable_bits) - HTABLE_REGION_BITS))
+#define ahash_sizeof_regions(htable_bits)		\
+	(ahash_numof_locks(htable_bits) * sizeof(struct ip_set_region))
+#define ahash_region(n, htable_bits)		\
+	((n) % ahash_numof_locks(htable_bits))
+#define ahash_bucket_start(h,  htable_bits)	\
+	((htable_bits) < HTABLE_REGION_BITS ? 0	\
+		: (h) * jhash_size(HTABLE_REGION_BITS))
+#define ahash_bucket_end(h,  htable_bits)	\
+	((htable_bits) < HTABLE_REGION_BITS ? jhash_size(htable_bits)	\
+		: ((h) + 1) * jhash_size(HTABLE_REGION_BITS))
+
+struct htable_gc {
+	struct delayed_work dwork;
+	struct ip_set *set;	/* Set the gc belongs to */
+	u32 region;		/* Last gc run position */
+};
+
 /* The hash table: the table size stored here in order to make resizing easy */
 struct htable {
 	atomic_t ref;		/* References for resizing */
-	atomic_t uref;		/* References for dumping */
+	atomic_t uref;		/* References for dumping and gc */
 	u8 htable_bits;		/* size of hash table == 2^htable_bits */
+	u32 maxelem;		/* Maxelem per region */
+	struct ip_set_region *hregion;	/* Region locks and ext sizes */
 	struct hbucket __rcu *bucket[0]; /* hashtable buckets */
 };
 
@@ -162,6 +194,10 @@ htable_bits(u32 hashsize)
 #define NLEN			0
 #endif /* IP_SET_HASH_WITH_NETS */
 
+#define SET_ELEM_EXPIRED(set, d)	\
+	(SET_WITH_TIMEOUT(set) &&	\
+	 ip_set_timeout_expired(ext_timeout(d, set)))
+
 #endif /* _IP_SET_HASH_GEN_H */
 
 #ifndef MTYPE
@@ -205,10 +241,12 @@ htable_bits(u32 hashsize)
 #undef mtype_test_cidrs
 #undef mtype_test
 #undef mtype_uref
-#undef mtype_expire
 #undef mtype_resize
+#undef mtype_ext_size
+#undef mtype_resize_ad
 #undef mtype_head
 #undef mtype_list
+#undef mtype_gc_do
 #undef mtype_gc
 #undef mtype_gc_init
 #undef mtype_variant
@@ -247,10 +285,12 @@ htable_bits(u32 hashsize)
 #define mtype_test_cidrs	IPSET_TOKEN(MTYPE, _test_cidrs)
 #define mtype_test		IPSET_TOKEN(MTYPE, _test)
 #define mtype_uref		IPSET_TOKEN(MTYPE, _uref)
-#define mtype_expire		IPSET_TOKEN(MTYPE, _expire)
 #define mtype_resize		IPSET_TOKEN(MTYPE, _resize)
+#define mtype_ext_size		IPSET_TOKEN(MTYPE, _ext_size)
+#define mtype_resize_ad		IPSET_TOKEN(MTYPE, _resize_ad)
 #define mtype_head		IPSET_TOKEN(MTYPE, _head)
 #define mtype_list		IPSET_TOKEN(MTYPE, _list)
+#define mtype_gc_do		IPSET_TOKEN(MTYPE, _gc_do)
 #define mtype_gc		IPSET_TOKEN(MTYPE, _gc)
 #define mtype_gc_init		IPSET_TOKEN(MTYPE, _gc_init)
 #define mtype_variant		IPSET_TOKEN(MTYPE, _variant)
@@ -275,8 +315,7 @@ htable_bits(u32 hashsize)
 /* The generic hash structure */
 struct htype {
 	struct htable __rcu *table; /* the hash table */
-	struct timer_list gc;	/* garbage collection when timeout enabled */
-	struct ip_set *set;	/* attached to this ip_set */
+	struct htable_gc gc;	/* gc workqueue */
 	u32 maxelem;		/* max elements in the hash */
 	u32 initval;		/* random jhash init value */
 #ifdef IP_SET_HASH_WITH_MARKMASK
@@ -288,21 +327,33 @@ struct htype {
 #ifdef IP_SET_HASH_WITH_NETMASK
 	u8 netmask;		/* netmask value for subnets to store */
 #endif
+	struct list_head ad;	/* Resize add|del backlist */
 	struct mtype_elem next; /* temporary storage for uadd */
 #ifdef IP_SET_HASH_WITH_NETS
 	struct net_prefixes nets[NLEN]; /* book-keeping of prefixes */
 #endif
 };
 
+/* ADD|DEL entries saved during resize */
+struct mtype_resize_ad {
+	struct list_head list;
+	enum ipset_adt ad;	/* ADD|DEL element */
+	struct mtype_elem d;	/* Element value */
+	struct ip_set_ext ext;	/* Extensions for ADD */
+	struct ip_set_ext mext;	/* Target extensions for ADD */
+	u32 flags;		/* Flags for ADD */
+};
+
 #ifdef IP_SET_HASH_WITH_NETS
 /* Network cidr size book keeping when the hash stores different
  * sized networks. cidr == real cidr + 1 to support /0.
  */
 static void
-mtype_add_cidr(struct htype *h, u8 cidr, u8 n)
+mtype_add_cidr(struct ip_set *set, struct htype *h, u8 cidr, u8 n)
 {
 	int i, j;
 
+	spin_lock_bh(&set->lock);
 	/* Add in increasing prefix order, so larger cidr first */
 	for (i = 0, j = -1; i < NLEN && h->nets[i].cidr[n]; i++) {
 		if (j != -1) {
@@ -311,7 +362,7 @@ mtype_add_cidr(struct htype *h, u8 cidr, u8 n)
 			j = i;
 		} else if (h->nets[i].cidr[n] == cidr) {
 			h->nets[CIDR_POS(cidr)].nets[n]++;
-			return;
+			goto unlock;
 		}
 	}
 	if (j != -1) {
@@ -320,24 +371,29 @@ mtype_add_cidr(struct htype *h, u8 cidr, u8 n)
 	}
 	h->nets[i].cidr[n] = cidr;
 	h->nets[CIDR_POS(cidr)].nets[n] = 1;
+unlock:
+	spin_unlock_bh(&set->lock);
 }
 
 static void
-mtype_del_cidr(struct htype *h, u8 cidr, u8 n)
+mtype_del_cidr(struct ip_set *set, struct htype *h, u8 cidr, u8 n)
 {
 	u8 i, j, net_end = NLEN - 1;
 
+	spin_lock_bh(&set->lock);
 	for (i = 0; i < NLEN; i++) {
 		if (h->nets[i].cidr[n] != cidr)
 			continue;
 		h->nets[CIDR_POS(cidr)].nets[n]--;
 		if (h->nets[CIDR_POS(cidr)].nets[n] > 0)
-			return;
+			goto unlock;
 		for (j = i; j < net_end && h->nets[j].cidr[n]; j++)
 			h->nets[j].cidr[n] = h->nets[j + 1].cidr[n];
 		h->nets[j].cidr[n] = 0;
-		return;
+		goto unlock;
 	}
+unlock:
+	spin_unlock_bh(&set->lock);
 }
 #endif
 
@@ -345,7 +401,7 @@ mtype_del_cidr(struct htype *h, u8 cidr, u8 n)
 static size_t
 mtype_ahash_memsize(const struct htype *h, const struct htable *t)
 {
-	return sizeof(*h) + sizeof(*t);
+	return sizeof(*h) + sizeof(*t) + ahash_sizeof_regions(t->htable_bits);
 }
 
 /* Get the ith element from the array block n */
@@ -369,24 +425,29 @@ mtype_flush(struct ip_set *set)
 	struct htype *h = set->data;
 	struct htable *t;
 	struct hbucket *n;
-	u32 i;
-
-	t = ipset_dereference_protected(h->table, set);
-	for (i = 0; i < jhash_size(t->htable_bits); i++) {
-		n = __ipset_dereference_protected(hbucket(t, i), 1);
-		if (!n)
-			continue;
-		if (set->extensions & IPSET_EXT_DESTROY)
-			mtype_ext_cleanup(set, n);
-		/* FIXME: use slab cache */
-		rcu_assign_pointer(hbucket(t, i), NULL);
-		kfree_rcu(n, rcu);
+	u32 r, i;
+
+	t = ipset_dereference_nfnl(h->table);
+	for (r = 0; r < ahash_numof_locks(t->htable_bits); r++) {
+		spin_lock_bh(&t->hregion[r].lock);
+		for (i = ahash_bucket_start(r, t->htable_bits);
+		     i < ahash_bucket_end(r, t->htable_bits); i++) {
+			n = __ipset_dereference(hbucket(t, i));
+			if (!n)
+				continue;
+			if (set->extensions & IPSET_EXT_DESTROY)
+				mtype_ext_cleanup(set, n);
+			/* FIXME: use slab cache */
+			rcu_assign_pointer(hbucket(t, i), NULL);
+			kfree_rcu(n, rcu);
+		}
+		t->hregion[r].ext_size = 0;
+		t->hregion[r].elements = 0;
+		spin_unlock_bh(&t->hregion[r].lock);
 	}
 #ifdef IP_SET_HASH_WITH_NETS
 	memset(h->nets, 0, sizeof(h->nets));
 #endif
-	set->elements = 0;
-	set->ext_size = 0;
 }
 
 /* Destroy the hashtable part of the set */
@@ -397,7 +458,7 @@ mtype_ahash_destroy(struct ip_set *set, struct htable *t, bool ext_destroy)
 	u32 i;
 
 	for (i = 0; i < jhash_size(t->htable_bits); i++) {
-		n = __ipset_dereference_protected(hbucket(t, i), 1);
+		n = __ipset_dereference(hbucket(t, i));
 		if (!n)
 			continue;
 		if (set->extensions & IPSET_EXT_DESTROY && ext_destroy)
@@ -406,6 +467,7 @@ mtype_ahash_destroy(struct ip_set *set, struct htable *t, bool ext_destroy)
 		kfree(n);
 	}
 
+	ip_set_free(t->hregion);
 	ip_set_free(t);
 }
 
@@ -414,28 +476,21 @@ static void
 mtype_destroy(struct ip_set *set)
 {
 	struct htype *h = set->data;
+	struct list_head *l, *lt;
 
 	if (SET_WITH_TIMEOUT(set))
-		del_timer_sync(&h->gc);
+		cancel_delayed_work_sync(&h->gc.dwork);
 
-	mtype_ahash_destroy(set,
-			    __ipset_dereference_protected(h->table, 1), true);
+	mtype_ahash_destroy(set, ipset_dereference_nfnl(h->table), true);
+	list_for_each_safe(l, lt, &h->ad) {
+		list_del(l);
+		kfree(l);
+	}
 	kfree(h);
 
 	set->data = NULL;
 }
 
-static void
-mtype_gc_init(struct ip_set *set, void (*gc)(struct timer_list *t))
-{
-	struct htype *h = set->data;
-
-	timer_setup(&h->gc, gc, 0);
-	mod_timer(&h->gc, jiffies + IPSET_GC_PERIOD(set->timeout) * HZ);
-	pr_debug("gc initialized, run in every %u\n",
-		 IPSET_GC_PERIOD(set->timeout));
-}
-
 static bool
 mtype_same_set(const struct ip_set *a, const struct ip_set *b)
 {
@@ -454,11 +509,9 @@ mtype_same_set(const struct ip_set *a, const struct ip_set *b)
 	       a->extensions == b->extensions;
 }
 
-/* Delete expired elements from the hashtable */
 static void
-mtype_expire(struct ip_set *set, struct htype *h)
+mtype_gc_do(struct ip_set *set, struct htype *h, struct htable *t, u32 r)
 {
-	struct htable *t;
 	struct hbucket *n, *tmp;
 	struct mtype_elem *data;
 	u32 i, j, d;
@@ -466,10 +519,12 @@ mtype_expire(struct ip_set *set, struct htype *h)
 #ifdef IP_SET_HASH_WITH_NETS
 	u8 k;
 #endif
+	u8 htable_bits = t->htable_bits;
 
-	t = ipset_dereference_protected(h->table, set);
-	for (i = 0; i < jhash_size(t->htable_bits); i++) {
-		n = __ipset_dereference_protected(hbucket(t, i), 1);
+	spin_lock_bh(&t->hregion[r].lock);
+	for (i = ahash_bucket_start(r, htable_bits);
+	     i < ahash_bucket_end(r, htable_bits); i++) {
+		n = __ipset_dereference(hbucket(t, i));
 		if (!n)
 			continue;
 		for (j = 0, d = 0; j < n->pos; j++) {
@@ -485,58 +540,100 @@ mtype_expire(struct ip_set *set, struct htype *h)
 			smp_mb__after_atomic();
 #ifdef IP_SET_HASH_WITH_NETS
 			for (k = 0; k < IPSET_NET_COUNT; k++)
-				mtype_del_cidr(h,
+				mtype_del_cidr(set, h,
 					NCIDR_PUT(DCIDR_GET(data->cidr, k)),
 					k);
 #endif
+			t->hregion[r].elements--;
 			ip_set_ext_destroy(set, data);
-			set->elements--;
 			d++;
 		}
 		if (d >= AHASH_INIT_SIZE) {
 			if (d >= n->size) {
+				t->hregion[r].ext_size -=
+					ext_size(n->size, dsize);
 				rcu_assign_pointer(hbucket(t, i), NULL);
 				kfree_rcu(n, rcu);
 				continue;
 			}
 			tmp = kzalloc(sizeof(*tmp) +
-				      (n->size - AHASH_INIT_SIZE) * dsize,
-				      GFP_ATOMIC);
+				(n->size - AHASH_INIT_SIZE) * dsize,
+				GFP_ATOMIC);
 			if (!tmp)
-				/* Still try to delete expired elements */
+				/* Still try to delete expired elements. */
 				continue;
 			tmp->size = n->size - AHASH_INIT_SIZE;
 			for (j = 0, d = 0; j < n->pos; j++) {
 				if (!test_bit(j, n->used))
 					continue;
 				data = ahash_data(n, j, dsize);
-				memcpy(tmp->value + d * dsize, data, dsize);
+				memcpy(tmp->value + d * dsize,
+				       data, dsize);
 				set_bit(d, tmp->used);
 				d++;
 			}
 			tmp->pos = d;
-			set->ext_size -= ext_size(AHASH_INIT_SIZE, dsize);
+			t->hregion[r].ext_size -=
+				ext_size(AHASH_INIT_SIZE, dsize);
 			rcu_assign_pointer(hbucket(t, i), tmp);
 			kfree_rcu(n, rcu);
 		}
 	}
+	spin_unlock_bh(&t->hregion[r].lock);
 }
 
 static void
-mtype_gc(struct timer_list *t)
+mtype_gc(struct work_struct *work)
 {
-	struct htype *h = from_timer(h, t, gc);
-	struct ip_set *set = h->set;
+	struct htable_gc *gc;
+	struct ip_set *set;
+	struct htype *h;
+	struct htable *t;
+	u32 r, numof_locks;
+	unsigned int next_run;
+
+	gc = container_of(work, struct htable_gc, dwork.work);
+	set = gc->set;
+	h = set->data;
 
-	pr_debug("called\n");
 	spin_lock_bh(&set->lock);
-	mtype_expire(set, h);
+	t = ipset_dereference_set(h->table, set);
+	atomic_inc(&t->uref);
+	numof_locks = ahash_numof_locks(t->htable_bits);
+	r = gc->region++;
+	if (r >= numof_locks) {
+		r = gc->region = 0;
+	}
+	next_run = (IPSET_GC_PERIOD(set->timeout) * HZ) / numof_locks;
+	if (next_run < HZ/10)
+		next_run = HZ/10;
 	spin_unlock_bh(&set->lock);
 
-	h->gc.expires = jiffies + IPSET_GC_PERIOD(set->timeout) * HZ;
-	add_timer(&h->gc);
+	mtype_gc_do(set, h, t, r);
+
+	if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
+		pr_debug("Table destroy after resize by expire: %p\n", t);
+		mtype_ahash_destroy(set, t, false);
+	}
+
+	queue_delayed_work(system_power_efficient_wq, &gc->dwork, next_run);
+
+}
+
+static void
+mtype_gc_init(struct htable_gc *gc)
+{
+	INIT_DEFERRABLE_WORK(&gc->dwork, mtype_gc);
+	queue_delayed_work(system_power_efficient_wq, &gc->dwork, HZ);
 }
 
+static int
+mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
+	  struct ip_set_ext *mext, u32 flags);
+static int
+mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
+	  struct ip_set_ext *mext, u32 flags);
+
 /* Resize a hash: create a new hash table with doubling the hashsize
  * and inserting the elements to it. Repeat until we succeed or
  * fail due to memory pressures.
@@ -547,7 +644,7 @@ mtype_resize(struct ip_set *set, bool retried)
 	struct htype *h = set->data;
 	struct htable *t, *orig;
 	u8 htable_bits;
-	size_t extsize, dsize = set->dsize;
+	size_t dsize = set->dsize;
 #ifdef IP_SET_HASH_WITH_NETS
 	u8 flags;
 	struct mtype_elem *tmp;
@@ -555,7 +652,9 @@ mtype_resize(struct ip_set *set, bool retried)
 	struct mtype_elem *data;
 	struct mtype_elem *d;
 	struct hbucket *n, *m;
-	u32 i, j, key;
+	struct list_head *l, *lt;
+	struct mtype_resize_ad *x;
+	u32 i, j, r, nr, key;
 	int ret;
 
 #ifdef IP_SET_HASH_WITH_NETS
@@ -563,10 +662,8 @@ mtype_resize(struct ip_set *set, bool retried)
 	if (!tmp)
 		return -ENOMEM;
 #endif
-	rcu_read_lock_bh();
-	orig = rcu_dereference_bh_nfnl(h->table);
+	orig = ipset_dereference_bh_nfnl(h->table);
 	htable_bits = orig->htable_bits;
-	rcu_read_unlock_bh();
 
 retry:
 	ret = 0;
@@ -583,88 +680,124 @@ mtype_resize(struct ip_set *set, bool retried)
 		ret = -ENOMEM;
 		goto out;
 	}
+	t->hregion = ip_set_alloc(ahash_sizeof_regions(htable_bits));
+	if (!t->hregion) {
+		kfree(t);
+		ret = -ENOMEM;
+		goto out;
+	}
 	t->htable_bits = htable_bits;
+	t->maxelem = h->maxelem / ahash_numof_locks(htable_bits);
+	for (i = 0; i < ahash_numof_locks(htable_bits); i++)
+		spin_lock_init(&t->hregion[i].lock);
 
-	spin_lock_bh(&set->lock);
-	orig = __ipset_dereference_protected(h->table, 1);
-	/* There can't be another parallel resizing, but dumping is possible */
+	/* There can't be another parallel resizing,
+	 * but dumping, gc, kernel side add/del are possible
+	 */
+	orig = ipset_dereference_bh_nfnl(h->table);
 	atomic_set(&orig->ref, 1);
 	atomic_inc(&orig->uref);
-	extsize = 0;
 	pr_debug("attempt to resize set %s from %u to %u, t %p\n",
 		 set->name, orig->htable_bits, htable_bits, orig);
-	for (i = 0; i < jhash_size(orig->htable_bits); i++) {
-		n = __ipset_dereference_protected(hbucket(orig, i), 1);
-		if (!n)
-			continue;
-		for (j = 0; j < n->pos; j++) {
-			if (!test_bit(j, n->used))
+	for (r = 0; r < ahash_numof_locks(orig->htable_bits); r++) {
+		/* Expire may replace a hbucket with another one */
+		rcu_read_lock_bh();
+		for (i = ahash_bucket_start(r, orig->htable_bits);
+		     i < ahash_bucket_end(r, orig->htable_bits); i++) {
+			n = __ipset_dereference(hbucket(orig, i));
+			if (!n)
 				continue;
-			data = ahash_data(n, j, dsize);
+			for (j = 0; j < n->pos; j++) {
+				if (!test_bit(j, n->used))
+					continue;
+				data = ahash_data(n, j, dsize);
+				if (SET_ELEM_EXPIRED(set, data))
+					continue;
 #ifdef IP_SET_HASH_WITH_NETS
-			/* We have readers running parallel with us,
-			 * so the live data cannot be modified.
-			 */
-			flags = 0;
-			memcpy(tmp, data, dsize);
-			data = tmp;
-			mtype_data_reset_flags(data, &flags);
+				/* We have readers running parallel with us,
+				 * so the live data cannot be modified.
+				 */
+				flags = 0;
+				memcpy(tmp, data, dsize);
+				data = tmp;
+				mtype_data_reset_flags(data, &flags);
 #endif
-			key = HKEY(data, h->initval, htable_bits);
-			m = __ipset_dereference_protected(hbucket(t, key), 1);
-			if (!m) {
-				m = kzalloc(sizeof(*m) +
+				key = HKEY(data, h->initval, htable_bits);
+				m = __ipset_dereference(hbucket(t, key));
+				nr = ahash_region(key, htable_bits);
+				if (!m) {
+					m = kzalloc(sizeof(*m) +
 					    AHASH_INIT_SIZE * dsize,
 					    GFP_ATOMIC);
-				if (!m) {
-					ret = -ENOMEM;
-					goto cleanup;
-				}
-				m->size = AHASH_INIT_SIZE;
-				extsize += ext_size(AHASH_INIT_SIZE, dsize);
-				RCU_INIT_POINTER(hbucket(t, key), m);
-			} else if (m->pos >= m->size) {
-				struct hbucket *ht;
-
-				if (m->size >= AHASH_MAX(h)) {
-					ret = -EAGAIN;
-				} else {
-					ht = kzalloc(sizeof(*ht) +
+					if (!m) {
+						ret = -ENOMEM;
+						goto cleanup;
+					}
+					m->size = AHASH_INIT_SIZE;
+					t->hregion[nr].ext_size +=
+						ext_size(AHASH_INIT_SIZE,
+							 dsize);
+					RCU_INIT_POINTER(hbucket(t, key), m);
+				} else if (m->pos >= m->size) {
+					struct hbucket *ht;
+
+					if (m->size >= AHASH_MAX(h)) {
+						ret = -EAGAIN;
+					} else {
+						ht = kzalloc(sizeof(*ht) +
 						(m->size + AHASH_INIT_SIZE)
 						* dsize,
 						GFP_ATOMIC);
-					if (!ht)
-						ret = -ENOMEM;
+						if (!ht)
+							ret = -ENOMEM;
+					}
+					if (ret < 0)
+						goto cleanup;
+					memcpy(ht, m, sizeof(struct hbucket) +
+					       m->size * dsize);
+					ht->size = m->size + AHASH_INIT_SIZE;
+					t->hregion[nr].ext_size +=
+						ext_size(AHASH_INIT_SIZE,
+							 dsize);
+					kfree(m);
+					m = ht;
+					RCU_INIT_POINTER(hbucket(t, key), ht);
 				}
-				if (ret < 0)
-					goto cleanup;
-				memcpy(ht, m, sizeof(struct hbucket) +
-					      m->size * dsize);
-				ht->size = m->size + AHASH_INIT_SIZE;
-				extsize += ext_size(AHASH_INIT_SIZE, dsize);
-				kfree(m);
-				m = ht;
-				RCU_INIT_POINTER(hbucket(t, key), ht);
-			}
-			d = ahash_data(m, m->pos, dsize);
-			memcpy(d, data, dsize);
-			set_bit(m->pos++, m->used);
+				d = ahash_data(m, m->pos, dsize);
+				memcpy(d, data, dsize);
+				set_bit(m->pos++, m->used);
+				t->hregion[nr].elements++;
 #ifdef IP_SET_HASH_WITH_NETS
-			mtype_data_reset_flags(d, &flags);
+				mtype_data_reset_flags(d, &flags);
 #endif
+			}
 		}
+		rcu_read_unlock_bh();
 	}
-	rcu_assign_pointer(h->table, t);
-	set->ext_size = extsize;
 
-	spin_unlock_bh(&set->lock);
+	/* There can't be any other writer. */
+	rcu_assign_pointer(h->table, t);
 
 	/* Give time to other readers of the set */
 	synchronize_rcu();
 
 	pr_debug("set %s resized from %u (%p) to %u (%p)\n", set->name,
 		 orig->htable_bits, orig, t->htable_bits, t);
-	/* If there's nobody else dumping the table, destroy it */
+	/* Add/delete elements processed by the SET target during resize.
+	 * Kernel-side add cannot trigger a resize and userspace actions
+	 * are serialized by the mutex.
+	 */
+	list_for_each_safe(l, lt, &h->ad) {
+		x = list_entry(l, struct mtype_resize_ad, list);
+		if (x->ad == IPSET_ADD) {
+			mtype_add(set, &x->d, &x->ext, &x->mext, x->flags);
+		} else {
+			mtype_del(set, &x->d, NULL, NULL, 0);
+		}
+		list_del(l);
+		kfree(l);
+	}
+	/* If there's nobody else using the table, destroy it */
 	if (atomic_dec_and_test(&orig->uref)) {
 		pr_debug("Table destroy by resize %p\n", orig);
 		mtype_ahash_destroy(set, orig, false);
@@ -677,15 +810,44 @@ mtype_resize(struct ip_set *set, bool retried)
 	return ret;
 
 cleanup:
+	rcu_read_unlock_bh();
 	atomic_set(&orig->ref, 0);
 	atomic_dec(&orig->uref);
-	spin_unlock_bh(&set->lock);
 	mtype_ahash_destroy(set, t, false);
 	if (ret == -EAGAIN)
 		goto retry;
 	goto out;
 }
 
+/* Get the current number of elements and ext_size in the set  */
+static void
+mtype_ext_size(struct ip_set *set, u32 *elements, size_t *ext_size)
+{
+	struct htype *h = set->data;
+	const struct htable *t;
+	u32 i, j, r;
+	struct hbucket *n;
+	struct mtype_elem *data;
+
+	t = rcu_dereference_bh(h->table);
+	for (r = 0; r < ahash_numof_locks(t->htable_bits); r++) {
+		for (i = ahash_bucket_start(r, t->htable_bits);
+		     i < ahash_bucket_end(r, t->htable_bits); i++) {
+			n = rcu_dereference_bh(hbucket(t, i));
+			if (!n)
+				continue;
+			for (j = 0; j < n->pos; j++) {
+				if (!test_bit(j, n->used))
+					continue;
+				data = ahash_data(n, j, set->dsize);
+				if (!SET_ELEM_EXPIRED(set, data))
+					(*elements)++;
+			}
+		}
+		*ext_size += t->hregion[r].ext_size;
+	}
+}
+
 /* Add an element to a hash and update the internal counters when succeeded,
  * otherwise report the proper error code.
  */
@@ -698,32 +860,49 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	const struct mtype_elem *d = value;
 	struct mtype_elem *data;
 	struct hbucket *n, *old = ERR_PTR(-ENOENT);
-	int i, j = -1;
+	int i, j = -1, ret;
 	bool flag_exist = flags & IPSET_FLAG_EXIST;
 	bool deleted = false, forceadd = false, reuse = false;
-	u32 key, multi = 0;
+	u32 r, key, multi = 0, elements, maxelem;
 
-	if (set->elements >= h->maxelem) {
-		if (SET_WITH_TIMEOUT(set))
-			/* FIXME: when set is full, we slow down here */
-			mtype_expire(set, h);
-		if (set->elements >= h->maxelem && SET_WITH_FORCEADD(set))
+	rcu_read_lock_bh();
+	t = rcu_dereference_bh(h->table);
+	key = HKEY(value, h->initval, t->htable_bits);
+	r = ahash_region(key, t->htable_bits);
+	atomic_inc(&t->uref);
+	elements = t->hregion[r].elements;
+	maxelem = t->maxelem;
+	if (elements >= maxelem) {
+		u32 e;
+		if (SET_WITH_TIMEOUT(set)) {
+			rcu_read_unlock_bh();
+			mtype_gc_do(set, h, t, r);
+			rcu_read_lock_bh();
+		}
+		maxelem = h->maxelem;
+		elements = 0;
+		for (e = 0; e < ahash_numof_locks(t->htable_bits); e++)
+			elements += t->hregion[e].elements;
+		if (elements >= maxelem && SET_WITH_FORCEADD(set))
 			forceadd = true;
 	}
+	rcu_read_unlock_bh();
 
-	t = ipset_dereference_protected(h->table, set);
-	key = HKEY(value, h->initval, t->htable_bits);
-	n = __ipset_dereference_protected(hbucket(t, key), 1);
+	spin_lock_bh(&t->hregion[r].lock);
+	n = rcu_dereference_bh(hbucket(t, key));
 	if (!n) {
-		if (forceadd || set->elements >= h->maxelem)
+		if (forceadd || elements >= maxelem)
 			goto set_full;
 		old = NULL;
 		n = kzalloc(sizeof(*n) + AHASH_INIT_SIZE * set->dsize,
 			    GFP_ATOMIC);
-		if (!n)
-			return -ENOMEM;
+		if (!n) {
+			ret = -ENOMEM;
+			goto unlock;
+		}
 		n->size = AHASH_INIT_SIZE;
-		set->ext_size += ext_size(AHASH_INIT_SIZE, set->dsize);
+		t->hregion[r].ext_size +=
+			ext_size(AHASH_INIT_SIZE, set->dsize);
 		goto copy_elem;
 	}
 	for (i = 0; i < n->pos; i++) {
@@ -737,19 +916,16 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		}
 		data = ahash_data(n, i, set->dsize);
 		if (mtype_data_equal(data, d, &multi)) {
-			if (flag_exist ||
-			    (SET_WITH_TIMEOUT(set) &&
-			     ip_set_timeout_expired(ext_timeout(data, set)))) {
+			if (flag_exist || SET_ELEM_EXPIRED(set, data)) {
 				/* Just the extensions could be overwritten */
 				j = i;
 				goto overwrite_extensions;
 			}
-			return -IPSET_ERR_EXIST;
+			ret = -IPSET_ERR_EXIST;
+			goto unlock;
 		}
 		/* Reuse first timed out entry */
-		if (SET_WITH_TIMEOUT(set) &&
-		    ip_set_timeout_expired(ext_timeout(data, set)) &&
-		    j == -1) {
+		if (SET_ELEM_EXPIRED(set, data) && j == -1) {
 			j = i;
 			reuse = true;
 		}
@@ -759,16 +935,16 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		if (!deleted) {
 #ifdef IP_SET_HASH_WITH_NETS
 			for (i = 0; i < IPSET_NET_COUNT; i++)
-				mtype_del_cidr(h,
+				mtype_del_cidr(set, h,
 					NCIDR_PUT(DCIDR_GET(data->cidr, i)),
 					i);
 #endif
 			ip_set_ext_destroy(set, data);
-			set->elements--;
+			t->hregion[r].elements--;
 		}
 		goto copy_data;
 	}
-	if (set->elements >= h->maxelem)
+	if (elements >= maxelem)
 		goto set_full;
 	/* Create a new slot */
 	if (n->pos >= n->size) {
@@ -776,28 +952,32 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		if (n->size >= AHASH_MAX(h)) {
 			/* Trigger rehashing */
 			mtype_data_next(&h->next, d);
-			return -EAGAIN;
+			ret = -EAGAIN;
+			goto resize;
 		}
 		old = n;
 		n = kzalloc(sizeof(*n) +
 			    (old->size + AHASH_INIT_SIZE) * set->dsize,
 			    GFP_ATOMIC);
-		if (!n)
-			return -ENOMEM;
+		if (!n) {
+			ret = -ENOMEM;
+			goto unlock;
+		}
 		memcpy(n, old, sizeof(struct hbucket) +
 		       old->size * set->dsize);
 		n->size = old->size + AHASH_INIT_SIZE;
-		set->ext_size += ext_size(AHASH_INIT_SIZE, set->dsize);
+		t->hregion[r].ext_size +=
+			ext_size(AHASH_INIT_SIZE, set->dsize);
 	}
 
 copy_elem:
 	j = n->pos++;
 	data = ahash_data(n, j, set->dsize);
 copy_data:
-	set->elements++;
+	t->hregion[r].elements++;
 #ifdef IP_SET_HASH_WITH_NETS
 	for (i = 0; i < IPSET_NET_COUNT; i++)
-		mtype_add_cidr(h, NCIDR_PUT(DCIDR_GET(d->cidr, i)), i);
+		mtype_add_cidr(set, h, NCIDR_PUT(DCIDR_GET(d->cidr, i)), i);
 #endif
 	memcpy(data, d, sizeof(struct mtype_elem));
 overwrite_extensions:
@@ -820,13 +1000,41 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		if (old)
 			kfree_rcu(old, rcu);
 	}
+	ret = 0;
+resize:
+	spin_unlock_bh(&t->hregion[r].lock);
+	if (atomic_read(&t->ref) && ext->target) {
+		/* Resize is in process and kernel side add, save values */
+		struct mtype_resize_ad *x;
+
+		x = kzalloc(sizeof(struct mtype_resize_ad), GFP_ATOMIC);
+		if (!x)
+			/* Don't bother */
+			goto out;
+		x->ad = IPSET_ADD;
+		memcpy(&x->d, value, sizeof(struct mtype_elem));
+		memcpy(&x->ext, ext, sizeof(struct ip_set_ext));
+		memcpy(&x->mext, mext, sizeof(struct ip_set_ext));
+		x->flags = flags;
+		spin_lock_bh(&set->lock);
+		list_add_tail(&x->list, &h->ad);
+		spin_unlock_bh(&set->lock);
+	}
+	goto out;
 
-	return 0;
 set_full:
 	if (net_ratelimit())
 		pr_warn("Set %s is full, maxelem %u reached\n",
-			set->name, h->maxelem);
-	return -IPSET_ERR_HASH_FULL;
+			set->name, maxelem);
+	ret = -IPSET_ERR_HASH_FULL;
+unlock:
+	spin_unlock_bh(&t->hregion[r].lock);
+out:
+	if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
+		pr_debug("Table destroy after resize by add: %p\n", t);
+		mtype_ahash_destroy(set, t, false);
+	}
+	return ret;
 }
 
 /* Delete an element from the hash and free up space if possible.
@@ -840,13 +1048,23 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	const struct mtype_elem *d = value;
 	struct mtype_elem *data;
 	struct hbucket *n;
-	int i, j, k, ret = -IPSET_ERR_EXIST;
+	struct mtype_resize_ad *x = NULL;
+	int i, j, k, r, ret = -IPSET_ERR_EXIST;
 	u32 key, multi = 0;
 	size_t dsize = set->dsize;
 
-	t = ipset_dereference_protected(h->table, set);
+	/* Userspace add and resize is excluded by the mutex.
+	 * Kernespace add does not trigger resize.
+	 */
+	rcu_read_lock_bh();
+	t = rcu_dereference_bh(h->table);
 	key = HKEY(value, h->initval, t->htable_bits);
-	n = __ipset_dereference_protected(hbucket(t, key), 1);
+	r = ahash_region(key, t->htable_bits);
+	atomic_inc(&t->uref);
+	rcu_read_unlock_bh();
+
+	spin_lock_bh(&t->hregion[r].lock);
+	n = rcu_dereference_bh(hbucket(t, key));
 	if (!n)
 		goto out;
 	for (i = 0, k = 0; i < n->pos; i++) {
@@ -857,8 +1075,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		data = ahash_data(n, i, dsize);
 		if (!mtype_data_equal(data, d, &multi))
 			continue;
-		if (SET_WITH_TIMEOUT(set) &&
-		    ip_set_timeout_expired(ext_timeout(data, set)))
+		if (SET_ELEM_EXPIRED(set, data))
 			goto out;
 
 		ret = 0;
@@ -866,20 +1083,33 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		smp_mb__after_atomic();
 		if (i + 1 == n->pos)
 			n->pos--;
-		set->elements--;
+		t->hregion[r].elements--;
 #ifdef IP_SET_HASH_WITH_NETS
 		for (j = 0; j < IPSET_NET_COUNT; j++)
-			mtype_del_cidr(h, NCIDR_PUT(DCIDR_GET(d->cidr, j)),
-				       j);
+			mtype_del_cidr(set, h,
+				       NCIDR_PUT(DCIDR_GET(d->cidr, j)), j);
 #endif
 		ip_set_ext_destroy(set, data);
 
+		if (atomic_read(&t->ref) && ext->target) {
+			/* Resize is in process and kernel side del,
+			 * save values
+			 */
+			x = kzalloc(sizeof(struct mtype_resize_ad),
+				    GFP_ATOMIC);
+			if (x) {
+				x->ad = IPSET_DEL;
+				memcpy(&x->d, value,
+				       sizeof(struct mtype_elem));
+				x->flags = flags;
+			}
+		}
 		for (; i < n->pos; i++) {
 			if (!test_bit(i, n->used))
 				k++;
 		}
 		if (n->pos == 0 && k == 0) {
-			set->ext_size -= ext_size(n->size, dsize);
+			t->hregion[r].ext_size -= ext_size(n->size, dsize);
 			rcu_assign_pointer(hbucket(t, key), NULL);
 			kfree_rcu(n, rcu);
 		} else if (k >= AHASH_INIT_SIZE) {
@@ -898,7 +1128,8 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 				k++;
 			}
 			tmp->pos = k;
-			set->ext_size -= ext_size(AHASH_INIT_SIZE, dsize);
+			t->hregion[r].ext_size -=
+				ext_size(AHASH_INIT_SIZE, dsize);
 			rcu_assign_pointer(hbucket(t, key), tmp);
 			kfree_rcu(n, rcu);
 		}
@@ -906,6 +1137,16 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	}
 
 out:
+	spin_unlock_bh(&t->hregion[r].lock);
+	if (x) {
+		spin_lock_bh(&set->lock);
+		list_add(&x->list, &h->ad);
+		spin_unlock_bh(&set->lock);
+	}
+	if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
+		pr_debug("Table destroy after resize by del: %p\n", t);
+		mtype_ahash_destroy(set, t, false);
+	}
 	return ret;
 }
 
@@ -991,6 +1232,7 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	int i, ret = 0;
 	u32 key, multi = 0;
 
+	rcu_read_lock_bh();
 	t = rcu_dereference_bh(h->table);
 #ifdef IP_SET_HASH_WITH_NETS
 	/* If we test an IP address and not a network address,
@@ -1022,6 +1264,7 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 			goto out;
 	}
 out:
+	rcu_read_unlock_bh();
 	return ret;
 }
 
@@ -1033,23 +1276,14 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 	const struct htable *t;
 	struct nlattr *nested;
 	size_t memsize;
+	u32 elements = 0;
+	size_t ext_size = 0;
 	u8 htable_bits;
 
-	/* If any members have expired, set->elements will be wrong
-	 * mytype_expire function will update it with the right count.
-	 * we do not hold set->lock here, so grab it first.
-	 * set->elements can still be incorrect in the case of a huge set,
-	 * because elements might time out during the listing.
-	 */
-	if (SET_WITH_TIMEOUT(set)) {
-		spin_lock_bh(&set->lock);
-		mtype_expire(set, h);
-		spin_unlock_bh(&set->lock);
-	}
-
 	rcu_read_lock_bh();
-	t = rcu_dereference_bh_nfnl(h->table);
-	memsize = mtype_ahash_memsize(h, t) + set->ext_size;
+	t = rcu_dereference_bh(h->table);
+	mtype_ext_size(set, &elements, &ext_size);
+	memsize = mtype_ahash_memsize(h, t) + ext_size + set->ext_size;
 	htable_bits = t->htable_bits;
 	rcu_read_unlock_bh();
 
@@ -1071,7 +1305,7 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 #endif
 	if (nla_put_net32(skb, IPSET_ATTR_REFERENCES, htonl(set->ref)) ||
 	    nla_put_net32(skb, IPSET_ATTR_MEMSIZE, htonl(memsize)) ||
-	    nla_put_net32(skb, IPSET_ATTR_ELEMENTS, htonl(set->elements)))
+	    nla_put_net32(skb, IPSET_ATTR_ELEMENTS, htonl(elements)))
 		goto nla_put_failure;
 	if (unlikely(ip_set_put_flags(skb, set)))
 		goto nla_put_failure;
@@ -1091,15 +1325,15 @@ mtype_uref(struct ip_set *set, struct netlink_callback *cb, bool start)
 
 	if (start) {
 		rcu_read_lock_bh();
-		t = rcu_dereference_bh_nfnl(h->table);
+		t = ipset_dereference_bh_nfnl(h->table);
 		atomic_inc(&t->uref);
 		cb->args[IPSET_CB_PRIVATE] = (unsigned long)t;
 		rcu_read_unlock_bh();
 	} else if (cb->args[IPSET_CB_PRIVATE]) {
 		t = (struct htable *)cb->args[IPSET_CB_PRIVATE];
 		if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
-			/* Resizing didn't destroy the hash table */
-			pr_debug("Table destroy by dump: %p\n", t);
+			pr_debug("Table destroy after resize "
+				 " by dump: %p\n", t);
 			mtype_ahash_destroy(set, t, false);
 		}
 		cb->args[IPSET_CB_PRIVATE] = 0;
@@ -1141,8 +1375,7 @@ mtype_list(const struct ip_set *set,
 			if (!test_bit(i, n->used))
 				continue;
 			e = ahash_data(n, i, set->dsize);
-			if (SET_WITH_TIMEOUT(set) &&
-			    ip_set_timeout_expired(ext_timeout(e, set)))
+			if (SET_ELEM_EXPIRED(set, e))
 				continue;
 			pr_debug("list hash %lu hbucket %p i %u, data %p\n",
 				 cb->args[IPSET_CB_ARG0], n, i, e);
@@ -1208,6 +1441,7 @@ static const struct ip_set_type_variant mtype_variant = {
 	.uref	= mtype_uref,
 	.resize	= mtype_resize,
 	.same_set = mtype_same_set,
+	.region_lock = true,
 };
 
 #ifdef IP_SET_EMIT_CREATE
@@ -1226,6 +1460,7 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 	size_t hsize;
 	struct htype *h;
 	struct htable *t;
+	u32 i;
 
 	pr_debug("Create set %s with family %s\n",
 		 set->name, set->family == NFPROTO_IPV4 ? "inet" : "inet6");
@@ -1294,6 +1529,15 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 		kfree(h);
 		return -ENOMEM;
 	}
+	t->hregion = ip_set_alloc(ahash_sizeof_regions(hbits));
+	if (!t->hregion) {
+		kfree(t);
+		kfree(h);
+		return -ENOMEM;
+	}
+	h->gc.set = set;
+	for (i = 0; i < ahash_numof_locks(hbits); i++)
+		spin_lock_init(&t->hregion[i].lock);
 	h->maxelem = maxelem;
 #ifdef IP_SET_HASH_WITH_NETMASK
 	h->netmask = netmask;
@@ -1304,9 +1548,10 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 	get_random_bytes(&h->initval, sizeof(h->initval));
 
 	t->htable_bits = hbits;
+	t->maxelem = h->maxelem / ahash_numof_locks(hbits);
 	RCU_INIT_POINTER(h->table, t);
 
-	h->set = set;
+	INIT_LIST_HEAD(&h->ad);
 	set->data = h;
 #ifndef IP_SET_PROTO_UNDEF
 	if (set->family == NFPROTO_IPV4) {
@@ -1329,12 +1574,10 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 #ifndef IP_SET_PROTO_UNDEF
 		if (set->family == NFPROTO_IPV4)
 #endif
-			IPSET_TOKEN(HTYPE, 4_gc_init)(set,
-				IPSET_TOKEN(HTYPE, 4_gc));
+			IPSET_TOKEN(HTYPE, 4_gc_init)(&h->gc);
 #ifndef IP_SET_PROTO_UNDEF
 		else
-			IPSET_TOKEN(HTYPE, 6_gc_init)(set,
-				IPSET_TOKEN(HTYPE, 6_gc));
+			IPSET_TOKEN(HTYPE, 6_gc_init)(&h->gc);
 #endif
 	}
 	pr_debug("create %s hashsize %u (%u) maxelem %u: %p(%p)\n",
-- 
2.20.1

