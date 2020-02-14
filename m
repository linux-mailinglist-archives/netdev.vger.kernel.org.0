Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7F5015E60B
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 17:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394038AbgBNQpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:45:22 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55561 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392980AbgBNQVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 11:21:33 -0500
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j2diK-0003Oh-Gr; Fri, 14 Feb 2020 17:21:12 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 085E5103067;
        Fri, 14 Feb 2020 17:21:07 +0100 (CET)
Message-Id: <20200214161504.541509611@linutronix.de>
User-Agent: quilt/0.65
Date:   Fri, 14 Feb 2020 14:39:33 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [RFC patch 16/19] bpf: Factor out hashtab bucket lock operations
References: <20200214133917.304937432@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As a preparation for making the BPF locking RT friendly, factor out the
hash bucket lock operations into inline functions. This allows to do the
necessary RT modification in one place instead of sprinkling it all over
the place. No functional change.

The now unused htab argument of the lock/unlock functions will be used in
the next step which adds PREEMPT_RT support.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/bpf/hashtab.c |   69 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 46 insertions(+), 23 deletions(-)

--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -87,6 +87,32 @@ struct htab_elem {
 	char key[0] __aligned(8);
 };
 
+static void htab_init_buckets(struct bpf_htab *htab)
+{
+	unsigned i;
+
+	for (i = 0; i < htab->n_buckets; i++) {
+		INIT_HLIST_NULLS_HEAD(&htab->buckets[i].head, i);
+		raw_spin_lock_init(&htab->buckets[i].lock);
+	}
+}
+
+static inline unsigned long htab_lock_bucket(const struct bpf_htab *htab,
+					     struct bucket *b)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&b->lock, flags);
+	return flags;
+}
+
+static inline void htab_unlock_bucket(const struct bpf_htab *htab,
+				      struct bucket *b,
+				      unsigned long flags)
+{
+	raw_spin_unlock_irqrestore(&b->lock, flags);
+}
+
 static bool htab_lru_map_delete_node(void *arg, struct bpf_lru_node *node);
 
 static bool htab_is_lru(const struct bpf_htab *htab)
@@ -336,8 +362,8 @@ static struct bpf_map *htab_map_alloc(un
 	bool percpu_lru = (attr->map_flags & BPF_F_NO_COMMON_LRU);
 	bool prealloc = !(attr->map_flags & BPF_F_NO_PREALLOC);
 	struct bpf_htab *htab;
-	int err, i;
 	u64 cost;
+	int err;
 
 	htab = kzalloc(sizeof(*htab), GFP_USER);
 	if (!htab)
@@ -399,10 +425,7 @@ static struct bpf_map *htab_map_alloc(un
 	else
 		htab->hashrnd = get_random_int();
 
-	for (i = 0; i < htab->n_buckets; i++) {
-		INIT_HLIST_NULLS_HEAD(&htab->buckets[i].head, i);
-		raw_spin_lock_init(&htab->buckets[i].lock);
-	}
+	htab_init_buckets(htab);
 
 	if (prealloc) {
 		err = prealloc_init(htab);
@@ -610,7 +633,7 @@ static bool htab_lru_map_delete_node(voi
 	b = __select_bucket(htab, tgt_l->hash);
 	head = &b->head;
 
-	raw_spin_lock_irqsave(&b->lock, flags);
+	flags = htab_lock_bucket(htab, b);
 
 	hlist_nulls_for_each_entry_rcu(l, n, head, hash_node)
 		if (l == tgt_l) {
@@ -618,7 +641,7 @@ static bool htab_lru_map_delete_node(voi
 			break;
 		}
 
-	raw_spin_unlock_irqrestore(&b->lock, flags);
+	htab_unlock_bucket(htab, b, flags);
 
 	return l == tgt_l;
 }
@@ -892,7 +915,7 @@ static int htab_map_update_elem(struct b
 		 */
 	}
 
-	raw_spin_lock_irqsave(&b->lock, flags);
+	flags = htab_lock_bucket(htab, b);
 
 	l_old = lookup_elem_raw(head, hash, key, key_size);
 
@@ -933,7 +956,7 @@ static int htab_map_update_elem(struct b
 	}
 	ret = 0;
 err:
-	raw_spin_unlock_irqrestore(&b->lock, flags);
+	htab_unlock_bucket(htab, b, flags);
 	return ret;
 }
 
@@ -971,7 +994,7 @@ static int htab_lru_map_update_elem(stru
 		return -ENOMEM;
 	memcpy(l_new->key + round_up(map->key_size, 8), value, map->value_size);
 
-	raw_spin_lock_irqsave(&b->lock, flags);
+	flags = htab_lock_bucket(htab, b);
 
 	l_old = lookup_elem_raw(head, hash, key, key_size);
 
@@ -990,7 +1013,7 @@ static int htab_lru_map_update_elem(stru
 	ret = 0;
 
 err:
-	raw_spin_unlock_irqrestore(&b->lock, flags);
+	htab_unlock_bucket(htab, b, flags);
 
 	if (ret)
 		bpf_lru_push_free(&htab->lru, &l_new->lru_node);
@@ -1025,7 +1048,7 @@ static int __htab_percpu_map_update_elem
 	b = __select_bucket(htab, hash);
 	head = &b->head;
 
-	raw_spin_lock_irqsave(&b->lock, flags);
+	flags = htab_lock_bucket(htab, b);
 
 	l_old = lookup_elem_raw(head, hash, key, key_size);
 
@@ -1048,7 +1071,7 @@ static int __htab_percpu_map_update_elem
 	}
 	ret = 0;
 err:
-	raw_spin_unlock_irqrestore(&b->lock, flags);
+	htab_unlock_bucket(htab, b, flags);
 	return ret;
 }
 
@@ -1088,7 +1111,7 @@ static int __htab_lru_percpu_map_update_
 			return -ENOMEM;
 	}
 
-	raw_spin_lock_irqsave(&b->lock, flags);
+	flags = htab_lock_bucket(htab, b);
 
 	l_old = lookup_elem_raw(head, hash, key, key_size);
 
@@ -1110,7 +1133,7 @@ static int __htab_lru_percpu_map_update_
 	}
 	ret = 0;
 err:
-	raw_spin_unlock_irqrestore(&b->lock, flags);
+	htab_unlock_bucket(htab, b, flags);
 	if (l_new)
 		bpf_lru_push_free(&htab->lru, &l_new->lru_node);
 	return ret;
@@ -1148,7 +1171,7 @@ static int htab_map_delete_elem(struct b
 	b = __select_bucket(htab, hash);
 	head = &b->head;
 
-	raw_spin_lock_irqsave(&b->lock, flags);
+	flags = htab_lock_bucket(htab, b);
 
 	l = lookup_elem_raw(head, hash, key, key_size);
 
@@ -1158,7 +1181,7 @@ static int htab_map_delete_elem(struct b
 		ret = 0;
 	}
 
-	raw_spin_unlock_irqrestore(&b->lock, flags);
+	htab_unlock_bucket(htab, b, flags);
 	return ret;
 }
 
@@ -1180,7 +1203,7 @@ static int htab_lru_map_delete_elem(stru
 	b = __select_bucket(htab, hash);
 	head = &b->head;
 
-	raw_spin_lock_irqsave(&b->lock, flags);
+	flags = htab_lock_bucket(htab, b);
 
 	l = lookup_elem_raw(head, hash, key, key_size);
 
@@ -1189,7 +1212,7 @@ static int htab_lru_map_delete_elem(stru
 		ret = 0;
 	}
 
-	raw_spin_unlock_irqrestore(&b->lock, flags);
+	htab_unlock_bucket(htab, b, flags);
 	if (l)
 		bpf_lru_push_free(&htab->lru, &l->lru_node);
 	return ret;
@@ -1335,7 +1358,7 @@ static int
 	dst_val = values;
 	b = &htab->buckets[batch];
 	head = &b->head;
-	raw_spin_lock_irqsave(&b->lock, flags);
+	flags = htab_lock_bucket(htab, b);
 
 	bucket_cnt = 0;
 	hlist_nulls_for_each_entry_rcu(l, n, head, hash_node)
@@ -1344,7 +1367,7 @@ static int
 	if (bucket_cnt > (max_count - total)) {
 		if (total == 0)
 			ret = -ENOSPC;
-		raw_spin_unlock_irqrestore(&b->lock, flags);
+		htab_unlock_bucket(htab, b, flags);
 		rcu_read_unlock();
 		this_cpu_dec(bpf_prog_active);
 		migrate_enable();
@@ -1353,7 +1376,7 @@ static int
 
 	if (bucket_cnt > bucket_size) {
 		bucket_size = bucket_cnt;
-		raw_spin_unlock_irqrestore(&b->lock, flags);
+		htab_unlock_bucket(htab, b, flags);
 		rcu_read_unlock();
 		this_cpu_dec(bpf_prog_active);
 		migrate_enable();
@@ -1395,7 +1418,7 @@ static int
 		dst_val += value_size;
 	}
 
-	raw_spin_unlock_irqrestore(&b->lock, flags);
+	htab_unlock_bucket(htab, b, flags);
 	/* If we are not copying data, we can go to next bucket and avoid
 	 * unlocking the rcu.
 	 */

