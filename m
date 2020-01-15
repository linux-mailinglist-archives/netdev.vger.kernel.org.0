Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1FB13CC57
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 19:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729375AbgAOSng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 13:43:36 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:36726 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729287AbgAOSnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 13:43:35 -0500
Received: by mail-pl1-f201.google.com with SMTP id t3so7358817plz.3
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 10:43:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BUa2sGYQ5pE+WXHCee7JUKHRZrR8FCZKjHLXT2C4YTU=;
        b=gSilzt0Py5C7B8PeUlFXzIaWrEfWpYQRf7qJRuSoPmzaRdLtoefLCqKt4Bd8BqrOxb
         FR4EZ9Dfi0pAql/EDoC+U4z7Cpv32ErvwhPi3s6L92XAiOSWColy/iTzK2dMdglRJft0
         rl53cee7V16Sbth0ryq16nBR36tlQ55YpoHyiKuNGS+W0eN9d94ZWB4tvPfh/jo6JVpQ
         N40k0gTCWVUYQH4JalFly6SXbfJnbW0cSJ913MaU924kyhc+M0aTcgXTfUThoXwfuzCO
         eug3jEJP0/WGDuo+CCI+H/4Bgr2FJ76wMR3+Bpz69chgmlh1vQRLaygc9Lgz1O81TYUv
         6++Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BUa2sGYQ5pE+WXHCee7JUKHRZrR8FCZKjHLXT2C4YTU=;
        b=hmHZxN+VycgNKDOKlp1c6yM+mXMPMYiA1t/Go+EwTHVk2o9s30vLAxvcGmSwAYaJwk
         nDXmXiT1NpZXp5LdAifpvyBNRAirbqkgdo7D3HZPkIAb/qHmfW+ETI5IXIPICjOvtXc1
         pzXqi8vdxmmADwldkCOH8TWIvnDV4W9KJX+A/mHX4Jpeqmhi8KYPNcuTzLtTIUFwEofC
         mvty4cQOJSSyj4V2I6p4dF8LmydQpjuxNajCJgXKKRwBJUihs6UqhOCxsii/PSY8kkir
         UWIKw28ioTieHBu9Qv7R2KquQzhQSPrFNyslYVfKkoI/V6FCxvfBL7di7ld0D0M7rKiD
         V3bA==
X-Gm-Message-State: APjAAAVTBWyBXGHJYiVCgXHcrqJL0Ol5/ZTnQMtGbiP5vG9jPxUFLAs2
        zh8hrhm311XVJ0q5LUvWj1B5gFbHI/aP
X-Google-Smtp-Source: APXvYqzv5gI0ULsp/bBoCIzGtI5FXE2rHyEEXw9SBUXCCbdcMUiowT1j+VNUPjxnoYXdFnUN4vSJAglqtm4Y
X-Received: by 2002:a63:1322:: with SMTP id i34mr35499353pgl.163.1579113814157;
 Wed, 15 Jan 2020 10:43:34 -0800 (PST)
Date:   Wed, 15 Jan 2020 10:43:04 -0800
In-Reply-To: <20200115184308.162644-1-brianvv@google.com>
Message-Id: <20200115184308.162644-6-brianvv@google.com>
Mime-Version: 1.0
References: <20200115184308.162644-1-brianvv@google.com>
X-Mailer: git-send-email 2.25.0.rc1.283.g88dfdc4193-goog
Subject: [PATCH v5 bpf-next 5/9] bpf: add batch ops to all htab bpf map
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
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

This commits implements BPF_MAP_LOOKUP_BATCH and adds support for new
command BPF_MAP_LOOKUP_AND_DELETE_BATCH. Note that for update/delete
batch ops it is possible to use the generic implementations.

[1] https://lore.kernel.org/bpf/20190724165803.87470-1-brianvv@google.com/
[2] https://lore.kernel.org/bpf/20190906225434.3635421-1-yhs@fb.com/

Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Brian Vazquez <brianvv@google.com>
---
 include/linux/bpf.h      |   3 +
 include/uapi/linux/bpf.h |   1 +
 kernel/bpf/hashtab.c     | 264 +++++++++++++++++++++++++++++++++++++++
 kernel/bpf/syscall.c     |   9 +-
 4 files changed, 276 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 05466ad6cf1c5..3517e32149a4f 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -46,6 +46,9 @@ struct bpf_map_ops {
 	void *(*map_lookup_elem_sys_only)(struct bpf_map *map, void *key);
 	int (*map_lookup_batch)(struct bpf_map *map, const union bpf_attr *attr,
 				union bpf_attr __user *uattr);
+	int (*map_lookup_and_delete_batch)(struct bpf_map *map,
+					   const union bpf_attr *attr,
+					   union bpf_attr __user *uattr);
 	int (*map_update_batch)(struct bpf_map *map, const union bpf_attr *attr,
 				union bpf_attr __user *uattr);
 	int (*map_delete_batch)(struct bpf_map *map, const union bpf_attr *attr,
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index e8df9ca680e0c..9536729a03d57 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -108,6 +108,7 @@ enum bpf_cmd {
 	BPF_MAP_FREEZE,
 	BPF_BTF_GET_NEXT_ID,
 	BPF_MAP_LOOKUP_BATCH,
+	BPF_MAP_LOOKUP_AND_DELETE_BATCH,
 	BPF_MAP_UPDATE_BATCH,
 	BPF_MAP_DELETE_BATCH,
 };
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 22066a62c8c97..2d182c4ee9d99 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -17,6 +17,16 @@
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
 struct bucket {
 	struct hlist_nulls_head head;
 	raw_spinlock_t lock;
@@ -1232,6 +1242,256 @@ static void htab_map_seq_show_elem(struct bpf_map *map, void *key,
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
+	u32 batch, max_count, size, bucket_size;
+	u64 elem_map_flags, map_flags;
+	struct hlist_nulls_head *head;
+	struct hlist_nulls_node *n;
+	unsigned long flags;
+	struct htab_elem *l;
+	struct bucket *b;
+	int ret = 0;
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
+	max_count = attr->batch.count;
+	if (!max_count)
+		return 0;
+
+	if (put_user(0, &uattr->batch.count))
+		return -EFAULT;
+
+	batch = 0;
+	if (ubatch && copy_from_user(&batch, ubatch, sizeof(batch)))
+		return -EFAULT;
+
+	if (batch >= htab->n_buckets)
+		return -ENOENT;
+
+	key_size = htab->map.key_size;
+	roundup_key_size = round_up(htab->map.key_size, 8);
+	value_size = htab->map.value_size;
+	size = round_up(value_size, 8);
+	if (is_percpu)
+		value_size = size * num_possible_cpus();
+	total = 0;
+	/* while experimenting with hash tables with sizes ranging from 10 to
+	 * 1000, it was observed that a bucket can have upto 5 entries.
+	 */
+	bucket_size = 5;
+
+alloc:
+	/* We cannot do copy_from_user or copy_to_user inside
+	 * the rcu_read_lock. Allocate enough space here.
+	 */
+	keys = kvmalloc(key_size * bucket_size, GFP_USER | __GFP_NOWARN);
+	values = kvmalloc(value_size * bucket_size, GFP_USER | __GFP_NOWARN);
+	if (!keys || !values) {
+		ret = -ENOMEM;
+		goto after_loop;
+	}
+
+again:
+	preempt_disable();
+	this_cpu_inc(bpf_prog_active);
+	rcu_read_lock();
+again_nocopy:
+	dst_key = keys;
+	dst_val = values;
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
+		raw_spin_unlock_irqrestore(&b->lock, flags);
+		rcu_read_unlock();
+		this_cpu_dec(bpf_prog_active);
+		preempt_enable();
+		goto after_loop;
+	}
+
+	if (bucket_cnt > bucket_size) {
+		bucket_size = bucket_cnt;
+		raw_spin_unlock_irqrestore(&b->lock, flags);
+		rcu_read_unlock();
+		this_cpu_dec(bpf_prog_active);
+		preempt_enable();
+		kvfree(keys);
+		kvfree(values);
+		goto alloc;
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
+		dst_key += key_size;
+		dst_val += value_size;
+	}
+
+	raw_spin_unlock_irqrestore(&b->lock, flags);
+	/* If we are not copying data, we can go to next bucket and avoid
+	 * unlocking the rcu.
+	 */
+	if (!bucket_cnt && (batch + 1 < htab->n_buckets)) {
+		batch++;
+		goto again_nocopy;
+	}
+
+	rcu_read_unlock();
+	this_cpu_dec(bpf_prog_active);
+	preempt_enable();
+	if (bucket_cnt && (copy_to_user(ukeys + total * key_size, keys,
+	    key_size * bucket_cnt) ||
+	    copy_to_user(uvalues + total * value_size, values,
+	    value_size * bucket_cnt))) {
+		ret = -EFAULT;
+		goto after_loop;
+	}
+
+	total += bucket_cnt;
+	batch++;
+	if (batch >= htab->n_buckets) {
+		ret = -ENOENT;
+		goto after_loop;
+	}
+	goto again;
+
+after_loop:
+	if (ret == -EFAULT)
+		goto out;
+
+	/* copy # of entries and next batch */
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
@@ -1242,6 +1502,7 @@ const struct bpf_map_ops htab_map_ops = {
 	.map_delete_elem = htab_map_delete_elem,
 	.map_gen_lookup = htab_map_gen_lookup,
 	.map_seq_show_elem = htab_map_seq_show_elem,
+	BATCH_OPS(htab),
 };
 
 const struct bpf_map_ops htab_lru_map_ops = {
@@ -1255,6 +1516,7 @@ const struct bpf_map_ops htab_lru_map_ops = {
 	.map_delete_elem = htab_lru_map_delete_elem,
 	.map_gen_lookup = htab_lru_map_gen_lookup,
 	.map_seq_show_elem = htab_map_seq_show_elem,
+	BATCH_OPS(htab_lru),
 };
 
 /* Called from eBPF program */
@@ -1368,6 +1630,7 @@ const struct bpf_map_ops htab_percpu_map_ops = {
 	.map_update_elem = htab_percpu_map_update_elem,
 	.map_delete_elem = htab_map_delete_elem,
 	.map_seq_show_elem = htab_percpu_map_seq_show_elem,
+	BATCH_OPS(htab_percpu),
 };
 
 const struct bpf_map_ops htab_lru_percpu_map_ops = {
@@ -1379,6 +1642,7 @@ const struct bpf_map_ops htab_lru_percpu_map_ops = {
 	.map_update_elem = htab_lru_percpu_map_update_elem,
 	.map_delete_elem = htab_lru_map_delete_elem,
 	.map_seq_show_elem = htab_percpu_map_seq_show_elem,
+	BATCH_OPS(htab_lru_percpu),
 };
 
 static int fd_htab_map_alloc_check(union bpf_attr *attr)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index ce8244d1ba99c..0d94d361379c3 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3310,7 +3310,8 @@ static int bpf_map_do_batch(const union bpf_attr *attr,
 	if (IS_ERR(map))
 		return PTR_ERR(map);
 
-	if (cmd == BPF_MAP_LOOKUP_BATCH &&
+	if ((cmd == BPF_MAP_LOOKUP_BATCH ||
+	     cmd == BPF_MAP_LOOKUP_AND_DELETE_BATCH) &&
 	    !(map_get_sys_perms(map, f) & FMODE_CAN_READ)) {
 		err = -EPERM;
 		goto err_put;
@@ -3324,6 +3325,8 @@ static int bpf_map_do_batch(const union bpf_attr *attr,
 
 	if (cmd == BPF_MAP_LOOKUP_BATCH)
 		BPF_DO_BATCH(map->ops->map_lookup_batch);
+	else if (cmd == BPF_MAP_LOOKUP_AND_DELETE_BATCH)
+		BPF_DO_BATCH(map->ops->map_lookup_and_delete_batch);
 	else if (cmd == BPF_MAP_UPDATE_BATCH)
 		BPF_DO_BATCH(map->ops->map_update_batch);
 	else
@@ -3434,6 +3437,10 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 	case BPF_MAP_LOOKUP_BATCH:
 		err = bpf_map_do_batch(&attr, uattr, BPF_MAP_LOOKUP_BATCH);
 		break;
+	case BPF_MAP_LOOKUP_AND_DELETE_BATCH:
+		err = bpf_map_do_batch(&attr, uattr,
+				       BPF_MAP_LOOKUP_AND_DELETE_BATCH);
+		break;
 	case BPF_MAP_UPDATE_BATCH:
 		err = bpf_map_do_batch(&attr, uattr, BPF_MAP_UPDATE_BATCH);
 		break;
-- 
2.25.0.rc1.283.g88dfdc4193-goog

