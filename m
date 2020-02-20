Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAF6166927
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 21:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729270AbgBTU4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 15:56:43 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:44165 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729087AbgBTU4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 15:56:42 -0500
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j4sri-0007cl-MX; Thu, 20 Feb 2020 21:56:10 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id E86B4104096;
        Thu, 20 Feb 2020 21:56:05 +0100 (CET)
Message-Id: <20200220204619.020532816@linutronix.de>
User-Agent: quilt/0.65
Date:   Thu, 20 Feb 2020 21:45:34 +0100
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
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [patch V2 17/20] bpf: Factor out hashtab bucket lock operations
References: <20200220204517.863202864@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
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
@@ -884,7 +907,7 @@ static int htab_map_update_elem(struct b
 		 */
 	}
 
-	raw_spin_lock_irqsave(&b->lock, flags);
+	flags = htab_lock_bucket(htab, b);
 
 	l_old = lookup_elem_raw(head, hash, key, key_size);
 
@@ -925,7 +948,7 @@ static int htab_map_update_elem(struct b
 	}
 	ret = 0;
 err:
-	raw_spin_unlock_irqrestore(&b->lock, flags);
+	htab_unlock_bucket(htab, b, flags);
 	return ret;
 }
 
@@ -963,7 +986,7 @@ static int htab_lru_map_update_elem(stru
 		return -ENOMEM;
 	memcpy(l_new->key + round_up(map->key_size, 8), value, map->value_size);
 
-	raw_spin_lock_irqsave(&b->lock, flags);
+	flags = htab_lock_bucket(htab, b);
 
 	l_old = lookup_elem_raw(head, hash, key, key_size);
 
@@ -982,7 +1005,7 @@ static int htab_lru_map_update_elem(stru
 	ret = 0;
 
 err:
-	raw_spin_unlock_irqrestore(&b->lock, flags);
+	htab_unlock_bucket(htab, b, flags);
 
 	if (ret)
 		bpf_lru_push_free(&htab->lru, &l_new->lru_node);
@@ -1017,7 +1040,7 @@ static int __htab_percpu_map_update_elem
 	b = __select_bucket(htab, hash);
 	head = &b->head;
 
-	raw_spin_lock_irqsave(&b->lock, flags);
+	flags = htab_lock_bucket(htab, b);
 
 	l_old = lookup_elem_raw(head, hash, key, key_size);
 
@@ -1040,7 +1063,7 @@ static int __htab_percpu_map_update_elem
 	}
 	ret = 0;
 err:
-	raw_spin_unlock_irqrestore(&b->lock, flags);
+	htab_unlock_bucket(htab, b, flags);
 	return ret;
 }
 
@@ -1080,7 +1103,7 @@ static int __htab_lru_percpu_map_update_
 			return -ENOMEM;
 	}
 
-	raw_spin_lock_irqsave(&b->lock, flags);
+	flags = htab_lock_bucket(htab, b);
 
 	l_old = lookup_elem_raw(head, hash, key, key_size);
 
@@ -1102,7 +1125,7 @@ static int __htab_lru_percpu_map_update_
 	}
 	ret = 0;
 err:
-	raw_spin_unlock_irqrestore(&b->lock, flags);
+	htab_unlock_bucket(htab, b, flags);
 	if (l_new)
 		bpf_lru_push_free(&htab->lru, &l_new->lru_node);
 	return ret;
@@ -1140,7 +1163,7 @@ static int htab_map_delete_elem(struct b
 	b = __select_bucket(htab, hash);
 	head = &b->head;
 
-	raw_spin_lock_irqsave(&b->lock, flags);
+	flags = htab_lock_bucket(htab, b);
 
 	l = lookup_elem_raw(head, hash, key, key_size);
 
@@ -1150,7 +1173,7 @@ static int htab_map_delete_elem(struct b
 		ret = 0;
 	}
 
-	raw_spin_unlock_irqrestore(&b->lock, flags);
+	htab_unlock_bucket(htab, b, flags);
 	return ret;
 }
 
@@ -1172,7 +1195,7 @@ static int htab_lru_map_delete_elem(stru
 	b = __select_bucket(htab, hash);
 	head = &b->head;
 
-	raw_spin_lock_irqsave(&b->lock, flags);
+	flags = htab_lock_bucket(htab, b);
 
 	l = lookup_elem_raw(head, hash, key, key_size);
 
@@ -1181,7 +1204,7 @@ static int htab_lru_map_delete_elem(stru
 		ret = 0;
 	}
 
-	raw_spin_unlock_irqrestore(&b->lock, flags);
+	htab_unlock_bucket(htab, b, flags);
 	if (l)
 		bpf_lru_push_free(&htab->lru, &l->lru_node);
 	return ret;
@@ -1326,7 +1349,7 @@ static int
 	dst_val = values;
 	b = &htab->buckets[batch];
 	head = &b->head;
-	raw_spin_lock_irqsave(&b->lock, flags);
+	flags = htab_lock_bucket(htab, b);
 
 	bucket_cnt = 0;
 	hlist_nulls_for_each_entry_rcu(l, n, head, hash_node)
@@ -1335,7 +1358,7 @@ static int
 	if (bucket_cnt > (max_count - total)) {
 		if (total == 0)
 			ret = -ENOSPC;
-		raw_spin_unlock_irqrestore(&b->lock, flags);
+		htab_unlock_bucket(htab, b, flags);
 		rcu_read_unlock();
 		bpf_enable_instrumentation();
 		goto after_loop;
@@ -1343,7 +1366,7 @@ static int
 
 	if (bucket_cnt > bucket_size) {
 		bucket_size = bucket_cnt;
-		raw_spin_unlock_irqrestore(&b->lock, flags);
+		htab_unlock_bucket(htab, b, flags);
 		rcu_read_unlock();
 		bpf_enable_instrumentation();
 		kvfree(keys);
@@ -1384,7 +1407,7 @@ static int
 		dst_val += value_size;
 	}
 
-	raw_spin_unlock_irqrestore(&b->lock, flags);
+	htab_unlock_bucket(htab, b, flags);
 	/* If we are not copying data, we can go to next bucket and avoid
 	 * unlocking the rcu.
 	 */

