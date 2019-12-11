Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D409E11BFDE
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 23:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbfLKWek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 17:34:40 -0500
Received: from mail-qk1-f202.google.com ([209.85.222.202]:46446 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727043AbfLKWej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 17:34:39 -0500
Received: by mail-qk1-f202.google.com with SMTP id u30so138112qke.13
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 14:34:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=P2kOV2MOEC7IyfI18P+9M8i9WTTLIF62qpmoxon3j7g=;
        b=Gf2PVR5HbajhdZOpp9oR0/yn/6sUcwlVQ8ElQ0vyPtsl4xej7L57ih2UfHCRJItK9I
         t8E/JYe7elTcDPrdZmVYNGctq84MjpKnzNeXX2qYEwHtgPjTkaH+q7aJ3OD8/lg2AxB6
         ZK4xwGt9QGt/L+nRdSsHDWyc5jZVZlyV4vNhFp7oVME4BtTXAewhTaVcOOMwwHw/q0V9
         on4evPOKMPnWcUU6f/KYQotp8urRseA2ZMfRmgcl9hWyk2+/aOTGEnJsddqu6Adjuhes
         xNOvB9frmBoNL8iMEvLBvz4mzWRV18Yb3MwOwy+eR620PuRici/RuYnf8hYeJf7RZO1+
         gVcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=P2kOV2MOEC7IyfI18P+9M8i9WTTLIF62qpmoxon3j7g=;
        b=qNMS0vsDfvYHQTW5HUzyTqpdQEZRVOe2OnjMN4MEPxWEVC1nePcjQGPneHHr2mouUs
         ++zrJV5ljsitK6qN8AhkKOxRpNO+yFoELXItziShQ0rYMk6JVHUy3oh9eLqAAMSM7BCw
         LdijaOG+W0BUVPGMaAjTHInJiXkdnlZdT9kxFre7ayRveL6PwjT/LvJBHedlrN76nPn0
         oHc33DFHxhQKuUrcVAgBlYFZAkHJark7dgb8yUE3ah9CpyBepHGWBbEkL0uduirp10ea
         OKkNFFsLLCp2eIaV2MgoqWlCAx/hMJX0wc6CRrqvGo3uSUe28QZkF4VMenh1J2ULKd/S
         epdw==
X-Gm-Message-State: APjAAAXwBQliJ8D0S3BNp7Vizrmq1p6vvR7bFef8oI0w35XnQBmMsegl
        qPebtVICR6I/+tgI035Mjbheo45GSU4H
X-Google-Smtp-Source: APXvYqySFP7ubIS00OK4nJdgWZ7dzPEn+xssIGcvvXeMAyGHhiWB3bLBaGjMT7zfZbyrXM981HrVhNjroGKp
X-Received: by 2002:ad4:514e:: with SMTP id g14mr5410614qvq.196.1576103676841;
 Wed, 11 Dec 2019 14:34:36 -0800 (PST)
Date:   Wed, 11 Dec 2019 14:33:39 -0800
In-Reply-To: <20191211223344.165549-1-brianvv@google.com>
Message-Id: <20191211223344.165549-7-brianvv@google.com>
Mime-Version: 1.0
References: <20191211223344.165549-1-brianvv@google.com>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH v3 bpf-next 06/11] bpf: add batch ops to all htab bpf map
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Yonghong Song <yhs@fb.com>, Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

htab can't use generic batch support due some problematic behaviours
inherent to the data structre, i.e. while iterating the bpf map  a
concurrent program might delete the next entry that batch was about to
use, in that case there's no easy solution to retrieve the next entry,
the issue has been discussed multiple times (see [1] and [2]).

The only way hmap can be traversed without the problem previously
exposed is by making sure that the map is traversing entire buckets.
This commit implements those strict requirements for hmap, the
implementation follows the same interaction that generic support with
some exceptions:

 - If keys/values buffer are not big enough to traverse a bucket,
   ENOSPC will be returned.
 - out_batch contains the value of the next bucket in the iteration, not
   the next key, but this is transparent for the user since the user
   should never use out_batch for other than bpf batch syscalls.

Note that only lookup and lookup_and_delete batch ops require the hmap
specific implementation, update/delete batch ops can be the generic
ones.

[1] https://lore.kernel.org/bpf/20190724165803.87470-1-brianvv@google.com/
[2] https://lore.kernel.org/bpf/20190906225434.3635421-1-yhs@fb.com/

Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Brian Vazquez <brianvv@google.com>
---
 kernel/bpf/hashtab.c | 242 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 242 insertions(+)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 22066a62c8c97..fac107bdaf9ec 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -17,6 +17,17 @@
 	(BPF_F_NO_PREALLOC | BPF_F_NO_COMMON_LRU | BPF_F_NUMA_NODE |	\
 	 BPF_F_ACCESS_MASK | BPF_F_ZERO_SEED)
 
+#define BATCH_OPS(_name)			\
+	.map_lookup_batch =			\
+	_name##_map_lookup_batch,		\
+	.map_lookup_and_delete_batch =		\
+	_name##_map_lookup_and_delete_batch,	\
+	.map_update_batch =			\
+	generic_map_update_batch,		\
+	.map_delete_batch =			\
+	generic_map_delete_batch
+
+
 struct bucket {
 	struct hlist_nulls_head head;
 	raw_spinlock_t lock;
@@ -1232,6 +1243,233 @@ static void htab_map_seq_show_elem(struct bpf_map *map, void *key,
 	rcu_read_unlock();
 }
 
+static int
+__htab_map_lookup_and_delete_batch(struct bpf_map *map,
+				   const union bpf_attr *attr,
+				   union bpf_attr __user *uattr,
+				   bool do_delete, bool is_lru_map,
+				   bool is_percpu)
+{
+	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
+	u32 bucket_cnt, total, key_size, value_size, roundup_key_size;
+	void *keys = NULL, *values = NULL, *value, *dst_key, *dst_val;
+	void __user *uvalues = u64_to_user_ptr(attr->batch.values);
+	void __user *ukeys = u64_to_user_ptr(attr->batch.keys);
+	void *ubatch = u64_to_user_ptr(attr->batch.in_batch);
+	u64 elem_map_flags, map_flags;
+	struct hlist_nulls_head *head;
+	u32 batch, max_count, size;
+	struct hlist_nulls_node *n;
+	unsigned long flags;
+	struct htab_elem *l;
+	struct bucket *b;
+	int ret = 0;
+
+	max_count = attr->batch.count;
+	if (!max_count)
+		return 0;
+
+	elem_map_flags = attr->batch.elem_flags;
+	if ((elem_map_flags & ~BPF_F_LOCK) ||
+	    ((elem_map_flags & BPF_F_LOCK) && !map_value_has_spin_lock(map)))
+		return -EINVAL;
+
+	map_flags = attr->batch.flags;
+	if (map_flags)
+		return -EINVAL;
+
+	batch = 0;
+	if (ubatch && copy_from_user(&batch, ubatch, sizeof(batch)))
+		return -EFAULT;
+
+	if (batch >= htab->n_buckets)
+		return -ENOENT;
+
+	/* We cannot do copy_from_user or copy_to_user inside
+	 * the rcu_read_lock. Allocate enough space here.
+	 */
+	key_size = htab->map.key_size;
+	roundup_key_size = round_up(htab->map.key_size, 8);
+	value_size = htab->map.value_size;
+	size = round_up(value_size, 8);
+	if (is_percpu)
+		value_size = size * num_possible_cpus();
+	keys = kvmalloc(key_size, GFP_USER | __GFP_NOWARN);
+	values = kvmalloc(value_size, GFP_USER | __GFP_NOWARN);
+	if (!keys || !values) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	dst_key = keys;
+	dst_val = values;
+	total = 0;
+
+	preempt_disable();
+	this_cpu_inc(bpf_prog_active);
+	rcu_read_lock();
+
+again:
+	b = &htab->buckets[batch];
+	head = &b->head;
+	raw_spin_lock_irqsave(&b->lock, flags);
+
+	bucket_cnt = 0;
+	hlist_nulls_for_each_entry_rcu(l, n, head, hash_node)
+		bucket_cnt++;
+
+	if (bucket_cnt > (max_count - total)) {
+		if (total == 0)
+			ret = -ENOSPC;
+		goto after_loop;
+	}
+
+	hlist_nulls_for_each_entry_safe(l, n, head, hash_node) {
+		memcpy(dst_key, l->key, key_size);
+
+		if (is_percpu) {
+			int off = 0, cpu;
+			void __percpu *pptr;
+
+			pptr = htab_elem_get_ptr(l, map->key_size);
+			for_each_possible_cpu(cpu) {
+				bpf_long_memcpy(dst_val + off,
+						per_cpu_ptr(pptr, cpu), size);
+				off += size;
+			}
+		} else {
+			value = l->key + roundup_key_size;
+			if (elem_map_flags & BPF_F_LOCK)
+				copy_map_value_locked(map, dst_val, value,
+						      true);
+			else
+				copy_map_value(map, dst_val, value);
+			check_and_init_map_lock(map, dst_val);
+		}
+		if (do_delete) {
+			hlist_nulls_del_rcu(&l->hash_node);
+			if (is_lru_map)
+				bpf_lru_push_free(&htab->lru, &l->lru_node);
+			else
+				free_htab_elem(htab, l);
+		}
+		if (copy_to_user(ukeys + total * key_size, keys, key_size) ||
+		   copy_to_user(uvalues + total * value_size, values,
+		   value_size)) {
+			ret = -EFAULT;
+			goto after_loop;
+		}
+		total++;
+	}
+
+	batch++;
+	if (batch >= htab->n_buckets) {
+		ret = -ENOENT;
+		goto after_loop;
+	}
+
+	raw_spin_unlock_irqrestore(&b->lock, flags);
+	goto again;
+
+after_loop:
+	raw_spin_unlock_irqrestore(&b->lock, flags);
+
+	rcu_read_unlock();
+	this_cpu_dec(bpf_prog_active);
+	preempt_enable();
+
+	if (ret && ret != -ENOENT)
+		goto out;
+
+	/* copy data back to user */
+	ubatch = u64_to_user_ptr(attr->batch.out_batch);
+	if (copy_to_user(ubatch, &batch, sizeof(batch)) ||
+	    put_user(total, &uattr->batch.count))
+		ret = -EFAULT;
+
+out:
+	kvfree(keys);
+	kvfree(values);
+	return ret;
+}
+
+static int
+htab_percpu_map_lookup_batch(struct bpf_map *map, const union bpf_attr *attr,
+			     union bpf_attr __user *uattr)
+{
+	return __htab_map_lookup_and_delete_batch(map, attr, uattr, false,
+						  false, true);
+}
+
+static int
+htab_percpu_map_lookup_and_delete_batch(struct bpf_map *map,
+					const union bpf_attr *attr,
+					union bpf_attr __user *uattr)
+{
+	return __htab_map_lookup_and_delete_batch(map, attr, uattr, true,
+						  false, true);
+}
+
+static int
+htab_map_lookup_batch(struct bpf_map *map, const union bpf_attr *attr,
+		      union bpf_attr __user *uattr)
+{
+	return __htab_map_lookup_and_delete_batch(map, attr, uattr, false,
+						  false, false);
+}
+
+static int
+htab_map_lookup_and_delete_batch(struct bpf_map *map,
+				 const union bpf_attr *attr,
+				 union bpf_attr __user *uattr)
+{
+	return __htab_map_lookup_and_delete_batch(map, attr, uattr, true,
+						  false, false);
+}
+
+static int
+htab_map_delete_batch(struct bpf_map *map,
+		      const union bpf_attr *attr,
+		      union bpf_attr __user *uattr)
+{
+	return generic_map_delete_batch(map, attr, uattr);
+}
+
+static int
+htab_lru_percpu_map_lookup_batch(struct bpf_map *map,
+				 const union bpf_attr *attr,
+				 union bpf_attr __user *uattr)
+{
+	return __htab_map_lookup_and_delete_batch(map, attr, uattr, false,
+						  true, true);
+}
+
+static int
+htab_lru_percpu_map_lookup_and_delete_batch(struct bpf_map *map,
+					    const union bpf_attr *attr,
+					    union bpf_attr __user *uattr)
+{
+	return __htab_map_lookup_and_delete_batch(map, attr, uattr, true,
+						  true, true);
+}
+
+static int
+htab_lru_map_lookup_batch(struct bpf_map *map, const union bpf_attr *attr,
+			  union bpf_attr __user *uattr)
+{
+	return __htab_map_lookup_and_delete_batch(map, attr, uattr, false,
+						  true, false);
+}
+
+static int
+htab_lru_map_lookup_and_delete_batch(struct bpf_map *map,
+				     const union bpf_attr *attr,
+				     union bpf_attr __user *uattr)
+{
+	return __htab_map_lookup_and_delete_batch(map, attr, uattr, true,
+						  true, false);
+}
+
 const struct bpf_map_ops htab_map_ops = {
 	.map_alloc_check = htab_map_alloc_check,
 	.map_alloc = htab_map_alloc,
@@ -1242,6 +1480,7 @@ const struct bpf_map_ops htab_map_ops = {
 	.map_delete_elem = htab_map_delete_elem,
 	.map_gen_lookup = htab_map_gen_lookup,
 	.map_seq_show_elem = htab_map_seq_show_elem,
+	BATCH_OPS(htab),
 };
 
 const struct bpf_map_ops htab_lru_map_ops = {
@@ -1255,6 +1494,7 @@ const struct bpf_map_ops htab_lru_map_ops = {
 	.map_delete_elem = htab_lru_map_delete_elem,
 	.map_gen_lookup = htab_lru_map_gen_lookup,
 	.map_seq_show_elem = htab_map_seq_show_elem,
+	BATCH_OPS(htab_lru),
 };
 
 /* Called from eBPF program */
@@ -1368,6 +1608,7 @@ const struct bpf_map_ops htab_percpu_map_ops = {
 	.map_update_elem = htab_percpu_map_update_elem,
 	.map_delete_elem = htab_map_delete_elem,
 	.map_seq_show_elem = htab_percpu_map_seq_show_elem,
+	BATCH_OPS(htab_percpu),
 };
 
 const struct bpf_map_ops htab_lru_percpu_map_ops = {
@@ -1379,6 +1620,7 @@ const struct bpf_map_ops htab_lru_percpu_map_ops = {
 	.map_update_elem = htab_lru_percpu_map_update_elem,
 	.map_delete_elem = htab_lru_map_delete_elem,
 	.map_seq_show_elem = htab_percpu_map_seq_show_elem,
+	BATCH_OPS(htab_lru_percpu),
 };
 
 static int fd_htab_map_alloc_check(union bpf_attr *attr)
-- 
2.24.1.735.g03f4e72817-goog

