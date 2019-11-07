Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 640D1F3A63
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 22:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbfKGVVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 16:21:38 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:52305 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727034AbfKGVVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 16:21:37 -0500
Received: by mail-pg1-f202.google.com with SMTP id 32so617809pgy.19
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 13:21:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fdC5nnRhM3+R1951ZXj0wJaYA0pZsj9u2hiQZ7hN5RE=;
        b=IF76rirWXUMHfjgnygZ6zO6z4AcBozuCOLnkMtxsRsJb+4cb9ntqNm57rwQFmNRz3z
         jdHXFZK2PL3hSI8/nzrGyB9zOnfDpVWVdcCFnbDpSQiRVTZ+9xt5OshHYxxAb2NWSH5c
         FU9UQcNsW28K2F0WKLASsx9NKMr8sfa0yWMczneqbaHSvjR4DVddW/8wk4r0AupjPPqo
         ZBTMUz4zShcn+gkCR9pD+KZBjxyeQoWUULfpYT0WfFo2dULUcn4ZiEhli+CF7q+Yg83z
         pYcKG7r1YxNAuzB8G9oaaLExQw2jMEZcaLnPVrRbG1+kKGaF8s/SdWqF6dX0lGxRlDhy
         NjfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fdC5nnRhM3+R1951ZXj0wJaYA0pZsj9u2hiQZ7hN5RE=;
        b=YxOYZe2vL9WeO9VR/e7hjrCJtSiiReXcyOLqzbgBZ9nUGD68v1qmfGYvTT/wx7+D50
         QwJiCM6XjA1zyFAcYGv2vh79q3fMsUEwGSa20trMiKT8eUbq+0aVp6651nYPJ27ZG9Nh
         gIEignkeVcB61/gNL92DLbZN+JY25h3Upt8Mz36dJKTzRcL3RwZ4t7lMMtdOhc+z5UBB
         GmZuBpkRKI/r1poSMoaub1hVCCbsT2fHAJn6vADJWcAhgVohTYEc/lpwQmx8rBufSDNY
         LLC5htB1mlp6YIRFK6AflB3b0fOUX/xQAAg+3kfcxA6M678TDUmyQQgLdq1MXk/V5B2f
         jq1w==
X-Gm-Message-State: APjAAAXaqsoX8eP+g3FVn3B5lpHZg3nwvrleKC+JRY1y4rhhbvBR4Qg0
        JSP06emZQQ9C3wWTuNy7oD5JipwYtlqm
X-Google-Smtp-Source: APXvYqwm+LZreo4y6e8IURo3ybFy6XqJ3PUv0RnC3Bj+dg4ngGe7fzZ1QMfaUOGsbvnumlw0YE6XV1Z7hitS
X-Received: by 2002:a63:d70e:: with SMTP id d14mr7205196pgg.10.1573161695731;
 Thu, 07 Nov 2019 13:21:35 -0800 (PST)
Date:   Thu,  7 Nov 2019 13:20:23 -0800
In-Reply-To: <20191107212023.171208-1-brianvv@google.com>
Message-Id: <20191107212023.171208-4-brianvv@google.com>
Mime-Version: 1.0
References: <20191107212023.171208-1-brianvv@google.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [RFC bpf-next 3/3] bpf: add generic batch support
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Stanislav Fomichev <sdf@google.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Brian Vazquez <brianvv@google.com>, Yonghong Song <yhs@fb.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commits add generic batch support, this coulde b used by data
structures that don't have specific constrains or inconsistencies like
hashmap. This implementation also allow us to incremenmtally add the
support for the remaining data structures keeping less lines of code.

This commit also tests the generic batch operations with pcpu hashmaps
and arrays. Note that pcpu hashmaps support was only added in this
commit for demonstration purposes and the specific implementation should
be used instead.

Cc: Yonghong Song <yhs@fb.com>
Cc: Stanislav Fomichev <sdf@google.com>
Cc: Petar Penkov <ppenkov@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: Brian Vazquez <brianvv@google.com>
---
 include/linux/bpf.h                           |  12 +
 kernel/bpf/arraymap.c                         |   4 +
 kernel/bpf/hashtab.c                          |   4 +
 kernel/bpf/syscall.c                          | 506 +++++++++++++-----
 .../map_tests/map_lookup_and_delete_batch.c   | 132 ++++-
 .../map_lookup_and_delete_batch_array.c       | 118 ++++
 6 files changed, 635 insertions(+), 141 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch_array.c

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 66df540ee2473..211f5d04748cc 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -700,6 +700,18 @@ void bpf_map_charge_move(struct bpf_map_memory *dst,
 void *bpf_map_area_alloc(size_t size, int numa_node);
 void bpf_map_area_free(void *base);
 void bpf_map_init_from_attr(struct bpf_map *map, union bpf_attr *attr);
+int  generic_map_lookup_batch(struct bpf_map *map,
+			      const union bpf_attr *attr,
+			      union bpf_attr __user *uattr);
+int  generic_map_lookup_and_delete_batch(struct bpf_map *map,
+					 const union bpf_attr *attr,
+					 union bpf_attr __user *uattr);
+int  generic_map_update_batch(struct bpf_map *map,
+			      const union bpf_attr *attr,
+			      union bpf_attr __user *uattr);
+int  generic_map_delete_batch(struct bpf_map *map,
+			      const union bpf_attr *attr,
+			      union bpf_attr __user *uattr);
 
 extern int sysctl_unprivileged_bpf_disabled;
 
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 1c65ce0098a95..5afab2c36a3ba 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -457,6 +457,10 @@ const struct bpf_map_ops array_map_ops = {
 	.map_direct_value_meta = array_map_direct_value_meta,
 	.map_seq_show_elem = array_map_seq_show_elem,
 	.map_check_btf = array_map_check_btf,
+	.map_lookup_batch = generic_map_lookup_batch,
+	.map_lookup_and_delete_batch = generic_map_lookup_and_delete_batch,
+	.map_update_batch = generic_map_update_batch,
+	.map_delete_batch = generic_map_lookup_batch,
 };
 
 const struct bpf_map_ops percpu_array_map_ops = {
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 10977cb321862..d68374b1cd83e 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -1695,6 +1695,10 @@ const struct bpf_map_ops htab_percpu_map_ops = {
 	.map_update_elem = htab_percpu_map_update_elem,
 	.map_delete_elem = htab_map_delete_elem,
 	.map_seq_show_elem = htab_percpu_map_seq_show_elem,
+	.map_lookup_batch = generic_map_lookup_batch,
+	.map_lookup_and_delete_batch = generic_map_lookup_and_delete_batch,
+	.map_update_batch = generic_map_update_batch,
+	.map_delete_batch = generic_map_lookup_batch,
 };
 
 const struct bpf_map_ops htab_lru_percpu_map_ops = {
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index c9e5f928d85b0..1a42ccab32113 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -127,6 +127,153 @@ static struct bpf_map *find_and_alloc_map(union bpf_attr *attr)
 	return map;
 }
 
+static u32 bpf_map_value_size(struct bpf_map *map)
+{
+	if (map->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
+	    map->map_type == BPF_MAP_TYPE_LRU_PERCPU_HASH ||
+	    map->map_type == BPF_MAP_TYPE_PERCPU_ARRAY ||
+	    map->map_type == BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE)
+		return round_up(map->value_size, 8) * num_possible_cpus();
+	else if (IS_FD_MAP(map))
+		return sizeof(u32);
+	else
+		return  map->value_size;
+}
+
+static void maybe_wait_bpf_programs(struct bpf_map *map)
+{
+	/* Wait for any running BPF programs to complete so that
+	 * userspace, when we return to it, knows that all programs
+	 * that could be running use the new map value.
+	 */
+	if (map->map_type == BPF_MAP_TYPE_HASH_OF_MAPS ||
+	    map->map_type == BPF_MAP_TYPE_ARRAY_OF_MAPS)
+		synchronize_rcu();
+}
+
+static int bpf_map_update_value(struct bpf_map *map, struct fd f, void *key,
+				void *value, __u64 flags)
+{
+	int err;
+	/* Need to create a kthread, thus must support schedule */
+	if (bpf_map_is_dev_bound(map)) {
+		return bpf_map_offload_update_elem(map, key, value, flags);
+	} else if (map->map_type == BPF_MAP_TYPE_CPUMAP ||
+		   map->map_type == BPF_MAP_TYPE_SOCKHASH ||
+		   map->map_type == BPF_MAP_TYPE_SOCKMAP) {
+		return map->ops->map_update_elem(map, key, value, flags);
+	}
+
+	/* must increment bpf_prog_active to avoid kprobe+bpf triggering from
+	 * inside bpf map update or delete otherwise deadlocks are possible
+	 */
+	preempt_disable();
+	__this_cpu_inc(bpf_prog_active);
+	if (map->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
+	    map->map_type == BPF_MAP_TYPE_LRU_PERCPU_HASH) {
+		err = bpf_percpu_hash_update(map, key, value, flags);
+	} else if (map->map_type == BPF_MAP_TYPE_PERCPU_ARRAY) {
+		err = bpf_percpu_array_update(map, key, value, flags);
+	} else if (map->map_type == BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE) {
+		err = bpf_percpu_cgroup_storage_update(map, key, value,
+						       flags);
+	} else if (IS_FD_ARRAY(map)) {
+		rcu_read_lock();
+		err = bpf_fd_array_map_update_elem(map, f.file, key, value,
+						   flags);
+		rcu_read_unlock();
+	} else if (map->map_type == BPF_MAP_TYPE_HASH_OF_MAPS) {
+		rcu_read_lock();
+		err = bpf_fd_htab_map_update_elem(map, f.file, key, value,
+						  flags);
+		rcu_read_unlock();
+	} else if (map->map_type == BPF_MAP_TYPE_REUSEPORT_SOCKARRAY) {
+		/* rcu_read_lock() is not needed */
+		err = bpf_fd_reuseport_array_update_elem(map, key, value,
+							 flags);
+	} else if (map->map_type == BPF_MAP_TYPE_QUEUE ||
+		   map->map_type == BPF_MAP_TYPE_STACK) {
+		err = map->ops->map_push_elem(map, value, flags);
+	} else {
+		rcu_read_lock();
+		err = map->ops->map_update_elem(map, key, value, flags);
+		rcu_read_unlock();
+	}
+	__this_cpu_dec(bpf_prog_active);
+	preempt_enable();
+	maybe_wait_bpf_programs(map);
+
+	return err;
+}
+
+static int bpf_map_copy_value(struct bpf_map *map, void *key, void *value,
+			      __u64 flags, bool do_delete)
+{
+	void *ptr;
+	int err;
+
+
+	if (bpf_map_is_dev_bound(map)) {
+		err =  bpf_map_offload_lookup_elem(map, key, value);
+
+		if (!err && do_delete)
+			err = bpf_map_offload_delete_elem(map, key);
+
+		return err;
+	}
+
+	preempt_disable();
+	this_cpu_inc(bpf_prog_active);
+	if (map->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
+	    map->map_type == BPF_MAP_TYPE_LRU_PERCPU_HASH) {
+		err = bpf_percpu_hash_copy(map, key, value);
+	} else if (map->map_type == BPF_MAP_TYPE_PERCPU_ARRAY) {
+		err = bpf_percpu_array_copy(map, key, value);
+	} else if (map->map_type == BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE) {
+		err = bpf_percpu_cgroup_storage_copy(map, key, value);
+	} else if (map->map_type == BPF_MAP_TYPE_STACK_TRACE) {
+		err = bpf_stackmap_copy(map, key, value);
+	} else if (IS_FD_ARRAY(map)) {
+		err = bpf_fd_array_map_lookup_elem(map, key, value);
+	} else if (IS_FD_HASH(map)) {
+		err = bpf_fd_htab_map_lookup_elem(map, key, value);
+	} else if (map->map_type == BPF_MAP_TYPE_REUSEPORT_SOCKARRAY) {
+		err = bpf_fd_reuseport_array_lookup_elem(map, key, value);
+	} else if (map->map_type == BPF_MAP_TYPE_QUEUE ||
+		   map->map_type == BPF_MAP_TYPE_STACK) {
+		err = map->ops->map_peek_elem(map, value);
+	} else {
+		rcu_read_lock();
+		if (map->ops->map_lookup_elem_sys_only)
+			ptr = map->ops->map_lookup_elem_sys_only(map, key);
+		else
+			ptr = map->ops->map_lookup_elem(map, key);
+		if (IS_ERR(ptr)) {
+			err = PTR_ERR(ptr);
+		} else if (!ptr) {
+			err = -ENOENT;
+		} else {
+			err = 0;
+			if (flags & BPF_F_LOCK)
+				/* lock 'ptr' and copy everything but lock */
+				copy_map_value_locked(map, value, ptr, true);
+			else
+				copy_map_value(map, value, ptr);
+			/* mask lock, since value wasn't zero inited */
+			check_and_init_map_lock(map, value);
+		}
+		rcu_read_unlock();
+	}
+	if (do_delete)
+		err = err ? err : map->ops->map_delete_elem(map, key);
+
+	this_cpu_dec(bpf_prog_active);
+	preempt_enable();
+	maybe_wait_bpf_programs(map);
+
+	return err;
+}
+
 void *bpf_map_area_alloc(size_t size, int numa_node)
 {
 	/* We really just want to fail instead of triggering OOM killer
@@ -740,7 +887,7 @@ static int map_lookup_elem(union bpf_attr *attr)
 	void __user *uvalue = u64_to_user_ptr(attr->value);
 	int ufd = attr->map_fd;
 	struct bpf_map *map;
-	void *key, *value, *ptr;
+	void *key, *value;
 	u32 value_size;
 	struct fd f;
 	int err;
@@ -772,72 +919,14 @@ static int map_lookup_elem(union bpf_attr *attr)
 		goto err_put;
 	}
 
-	if (map->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
-	    map->map_type == BPF_MAP_TYPE_LRU_PERCPU_HASH ||
-	    map->map_type == BPF_MAP_TYPE_PERCPU_ARRAY ||
-	    map->map_type == BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE)
-		value_size = round_up(map->value_size, 8) * num_possible_cpus();
-	else if (IS_FD_MAP(map))
-		value_size = sizeof(u32);
-	else
-		value_size = map->value_size;
+	value_size = bpf_map_value_size(map);
 
 	err = -ENOMEM;
 	value = kmalloc(value_size, GFP_USER | __GFP_NOWARN);
 	if (!value)
 		goto free_key;
 
-	if (bpf_map_is_dev_bound(map)) {
-		err = bpf_map_offload_lookup_elem(map, key, value);
-		goto done;
-	}
-
-	preempt_disable();
-	this_cpu_inc(bpf_prog_active);
-	if (map->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
-	    map->map_type == BPF_MAP_TYPE_LRU_PERCPU_HASH) {
-		err = bpf_percpu_hash_copy(map, key, value);
-	} else if (map->map_type == BPF_MAP_TYPE_PERCPU_ARRAY) {
-		err = bpf_percpu_array_copy(map, key, value);
-	} else if (map->map_type == BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE) {
-		err = bpf_percpu_cgroup_storage_copy(map, key, value);
-	} else if (map->map_type == BPF_MAP_TYPE_STACK_TRACE) {
-		err = bpf_stackmap_copy(map, key, value);
-	} else if (IS_FD_ARRAY(map)) {
-		err = bpf_fd_array_map_lookup_elem(map, key, value);
-	} else if (IS_FD_HASH(map)) {
-		err = bpf_fd_htab_map_lookup_elem(map, key, value);
-	} else if (map->map_type == BPF_MAP_TYPE_REUSEPORT_SOCKARRAY) {
-		err = bpf_fd_reuseport_array_lookup_elem(map, key, value);
-	} else if (map->map_type == BPF_MAP_TYPE_QUEUE ||
-		   map->map_type == BPF_MAP_TYPE_STACK) {
-		err = map->ops->map_peek_elem(map, value);
-	} else {
-		rcu_read_lock();
-		if (map->ops->map_lookup_elem_sys_only)
-			ptr = map->ops->map_lookup_elem_sys_only(map, key);
-		else
-			ptr = map->ops->map_lookup_elem(map, key);
-		if (IS_ERR(ptr)) {
-			err = PTR_ERR(ptr);
-		} else if (!ptr) {
-			err = -ENOENT;
-		} else {
-			err = 0;
-			if (attr->flags & BPF_F_LOCK)
-				/* lock 'ptr' and copy everything but lock */
-				copy_map_value_locked(map, value, ptr, true);
-			else
-				copy_map_value(map, value, ptr);
-			/* mask lock, since value wasn't zero inited */
-			check_and_init_map_lock(map, value);
-		}
-		rcu_read_unlock();
-	}
-	this_cpu_dec(bpf_prog_active);
-	preempt_enable();
-
-done:
+	err = bpf_map_copy_value(map, key, value, attr->flags, false);
 	if (err)
 		goto free_value;
 
@@ -856,16 +945,6 @@ static int map_lookup_elem(union bpf_attr *attr)
 	return err;
 }
 
-static void maybe_wait_bpf_programs(struct bpf_map *map)
-{
-	/* Wait for any running BPF programs to complete so that
-	 * userspace, when we return to it, knows that all programs
-	 * that could be running use the new map value.
-	 */
-	if (map->map_type == BPF_MAP_TYPE_HASH_OF_MAPS ||
-	    map->map_type == BPF_MAP_TYPE_ARRAY_OF_MAPS)
-		synchronize_rcu();
-}
 
 #define BPF_MAP_UPDATE_ELEM_LAST_FIELD flags
 
@@ -921,56 +1000,8 @@ static int map_update_elem(union bpf_attr *attr)
 	if (copy_from_user(value, uvalue, value_size) != 0)
 		goto free_value;
 
-	/* Need to create a kthread, thus must support schedule */
-	if (bpf_map_is_dev_bound(map)) {
-		err = bpf_map_offload_update_elem(map, key, value, attr->flags);
-		goto out;
-	} else if (map->map_type == BPF_MAP_TYPE_CPUMAP ||
-		   map->map_type == BPF_MAP_TYPE_SOCKHASH ||
-		   map->map_type == BPF_MAP_TYPE_SOCKMAP) {
-		err = map->ops->map_update_elem(map, key, value, attr->flags);
-		goto out;
-	}
+	err = bpf_map_update_value(map, f, key, value, attr->flags);
 
-	/* must increment bpf_prog_active to avoid kprobe+bpf triggering from
-	 * inside bpf map update or delete otherwise deadlocks are possible
-	 */
-	preempt_disable();
-	__this_cpu_inc(bpf_prog_active);
-	if (map->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
-	    map->map_type == BPF_MAP_TYPE_LRU_PERCPU_HASH) {
-		err = bpf_percpu_hash_update(map, key, value, attr->flags);
-	} else if (map->map_type == BPF_MAP_TYPE_PERCPU_ARRAY) {
-		err = bpf_percpu_array_update(map, key, value, attr->flags);
-	} else if (map->map_type == BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE) {
-		err = bpf_percpu_cgroup_storage_update(map, key, value,
-						       attr->flags);
-	} else if (IS_FD_ARRAY(map)) {
-		rcu_read_lock();
-		err = bpf_fd_array_map_update_elem(map, f.file, key, value,
-						   attr->flags);
-		rcu_read_unlock();
-	} else if (map->map_type == BPF_MAP_TYPE_HASH_OF_MAPS) {
-		rcu_read_lock();
-		err = bpf_fd_htab_map_update_elem(map, f.file, key, value,
-						  attr->flags);
-		rcu_read_unlock();
-	} else if (map->map_type == BPF_MAP_TYPE_REUSEPORT_SOCKARRAY) {
-		/* rcu_read_lock() is not needed */
-		err = bpf_fd_reuseport_array_update_elem(map, key, value,
-							 attr->flags);
-	} else if (map->map_type == BPF_MAP_TYPE_QUEUE ||
-		   map->map_type == BPF_MAP_TYPE_STACK) {
-		err = map->ops->map_push_elem(map, value, attr->flags);
-	} else {
-		rcu_read_lock();
-		err = map->ops->map_update_elem(map, key, value, attr->flags);
-		rcu_read_unlock();
-	}
-	__this_cpu_dec(bpf_prog_active);
-	preempt_enable();
-	maybe_wait_bpf_programs(map);
-out:
 free_value:
 	kfree(value);
 free_key:
@@ -1096,6 +1127,241 @@ static int map_get_next_key(union bpf_attr *attr)
 	return err;
 }
 
+int generic_map_delete_batch(struct bpf_map *map,
+			     const union bpf_attr *attr,
+			     union bpf_attr __user *uattr)
+{
+	void __user *keys = u64_to_user_ptr(attr->batch.keys);
+	int ufd = attr->map_fd;
+	u32 cp, max_count;
+	struct fd f;
+	void *key;
+	int err;
+
+	f = fdget(ufd);
+	if (attr->batch.elem_flags & ~BPF_F_LOCK)
+		return -EINVAL;
+
+	if ((attr->batch.elem_flags & BPF_F_LOCK) &&
+	    !map_value_has_spin_lock(map)) {
+		err = -EINVAL;
+		goto err_put;
+	}
+
+	max_count = attr->batch.count;
+	if (!max_count)
+		return 0;
+
+	err = -ENOMEM;
+	for (cp = 0; cp < max_count; cp++) {
+		key = __bpf_copy_key(keys + cp * map->key_size, map->key_size);
+		if (IS_ERR(key)) {
+			err = PTR_ERR(key);
+			break;
+		}
+
+		if (err)
+			break;
+		if (bpf_map_is_dev_bound(map)) {
+			err = bpf_map_offload_delete_elem(map, key);
+			break;
+		}
+
+		preempt_disable();
+		__this_cpu_inc(bpf_prog_active);
+		rcu_read_lock();
+		err = map->ops->map_delete_elem(map, key);
+		rcu_read_unlock();
+		__this_cpu_dec(bpf_prog_active);
+		preempt_enable();
+		maybe_wait_bpf_programs(map);
+		if (err)
+			break;
+	}
+	if (copy_to_user(&uattr->batch.count, &cp, sizeof(cp)))
+		err = -EFAULT;
+err_put:
+	return err;
+}
+int generic_map_update_batch(struct bpf_map *map,
+			     const union bpf_attr *attr,
+			     union bpf_attr __user *uattr)
+{
+	void __user *values = u64_to_user_ptr(attr->batch.values);
+	void __user *keys = u64_to_user_ptr(attr->batch.keys);
+	u32 value_size, cp, max_count;
+	int ufd = attr->map_fd;
+	void *key, *value;
+	struct fd f;
+	int err;
+
+	f = fdget(ufd);
+	if (attr->batch.elem_flags & ~BPF_F_LOCK)
+		return -EINVAL;
+
+	if ((attr->batch.elem_flags & BPF_F_LOCK) &&
+	    !map_value_has_spin_lock(map)) {
+		err = -EINVAL;
+		goto err_put;
+	}
+
+	value_size = bpf_map_value_size(map);
+
+	max_count = attr->batch.count;
+	if (!max_count)
+		return 0;
+
+	err = -ENOMEM;
+	value = kmalloc(value_size, GFP_USER | __GFP_NOWARN);
+	if (!value)
+		goto err_put;
+
+	for (cp = 0; cp < max_count; cp++) {
+		key = __bpf_copy_key(keys + cp * map->key_size, map->key_size);
+		if (IS_ERR(key)) {
+			err = PTR_ERR(key);
+			break;
+		}
+		err = -EFAULT;
+		if (copy_from_user(value, values + cp * value_size, value_size))
+			break;
+
+		err = bpf_map_update_value(map, f, key, value,
+					   attr->batch.elem_flags);
+
+		if (err)
+			break;
+	}
+
+	if (copy_to_user(&uattr->batch.count, &cp, sizeof(cp)))
+		err = -EFAULT;
+
+	kfree(value);
+err_put:
+	return err;
+}
+
+static int __generic_map_lookup_batch(struct bpf_map *map,
+				      const union bpf_attr *attr,
+				      union bpf_attr __user *uattr,
+				      bool do_delete)
+{
+	void __user *values = u64_to_user_ptr(attr->batch.values);
+	void __user *keys = u64_to_user_ptr(attr->batch.keys);
+	void *buf, *prev_key, *key, *value;
+	u32 value_size, cp, max_count;
+	bool first_key = false;
+	u64 batch;
+	int err, retry = 3;
+
+	if (attr->batch.elem_flags & ~BPF_F_LOCK)
+		return -EINVAL;
+
+	if ((attr->batch.elem_flags & BPF_F_LOCK) &&
+	    !map_value_has_spin_lock(map)) {
+		err = -EINVAL;
+		goto err_put;
+	}
+
+	if (map->map_type == BPF_MAP_TYPE_QUEUE ||
+	    map->map_type == BPF_MAP_TYPE_STACK) {
+		err = -ENOTSUPP;
+		goto err_put;
+	}
+
+	value_size = bpf_map_value_size(map);
+
+	max_count = attr->batch.count;
+	if (!max_count)
+		return 0;
+
+	batch = attr->batch.batch;
+
+	err = -ENOMEM;
+	buf = kmalloc(map->key_size + value_size, GFP_USER | __GFP_NOWARN);
+	if (!buf)
+		goto err_put;
+
+	key = buf;
+	value = key + map->key_size;
+	if (batch) {
+		memcpy(key, &batch, map->key_size);
+	} else {
+		prev_key = NULL;
+		first_key = true;
+	}
+
+
+	for (cp = 0; cp < max_count; cp++) {
+		if (cp || !batch) {
+			rcu_read_lock();
+			err = map->ops->map_get_next_key(map, prev_key, key);
+			rcu_read_unlock();
+			if (err)
+				break;
+		}
+		err = bpf_map_copy_value(map, key, value,
+					 attr->batch.elem_flags, do_delete);
+
+		if (err == -ENOENT) {
+			if (retry) {
+				retry--;
+				continue;
+			}
+			err = -EINTR;
+			break;
+		}
+
+		if (err)
+			goto free_buf;
+
+		if (copy_to_user(keys + cp * map->key_size, key,
+				 map->key_size)) {
+			err = -EFAULT;
+			goto free_buf;
+		}
+		if (copy_to_user(values + cp * value_size, value, value_size)) {
+			err = -EFAULT;
+			goto free_buf;
+		}
+
+		prev_key = key;
+		retry = 3;
+	}
+	if (!err) {
+		rcu_read_lock();
+		err = map->ops->map_get_next_key(map, prev_key, key);
+		rcu_read_unlock();
+	}
+
+	if (err == -ENOENT && (cp || do_delete)) {
+		err = 0;
+		memset(key, 0, map->key_size);
+	}
+	if (!err && (copy_to_user(&uattr->batch.count, &cp, sizeof(cp)) ||
+		    (copy_to_user(&uattr->batch.batch, key, map->key_size))))
+		err = -EFAULT;
+
+free_buf:
+	kfree(buf);
+err_put:
+	return err;
+}
+
+int generic_map_lookup_batch(struct bpf_map *map,
+			     const union bpf_attr *attr,
+			     union bpf_attr __user *uattr)
+{
+	return __generic_map_lookup_batch(map, attr, uattr, false);
+}
+
+int generic_map_lookup_and_delete_batch(struct bpf_map *map,
+					const union bpf_attr *attr,
+					union bpf_attr __user *uattr)
+{
+	return __generic_map_lookup_batch(map, attr, uattr, true);
+}
+
 #define BPF_MAP_LOOKUP_AND_DELETE_ELEM_LAST_FIELD value
 
 static int map_lookup_and_delete_elem(union bpf_attr *attr)
diff --git a/tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch.c b/tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch.c
index dd906b1de5950..60fe30793fa22 100644
--- a/tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch.c
+++ b/tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch.c
@@ -7,16 +7,26 @@
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
 
+#include <bpf_util.h>
 #include <test_maps.h>
 
 static void map_batch_update(int map_fd, __u32 max_entries, int *keys,
-			     int *values)
+			     void *values, bool is_pcpu)
 {
-	int i, err;
+	typedef BPF_DECLARE_PERCPU(int, value);
+	int i, j, err;
+	value *v;
+
+	if(is_pcpu)
+		v = (value *)values;
 
 	for (i = 0; i < max_entries; i++) {
 		keys[i] = i + 1;
-		values[i] = i + 2;
+		if (is_pcpu)
+			for (j = 0; j < bpf_num_possible_cpus(); j++)
+				bpf_percpu(v[i], j) = i + 2 + j;
+		else
+			((int *)values)[i] = i + 2;
 	}
 
 	err = bpf_map_update_batch(map_fd, keys, values, &max_entries, 0, 0);
@@ -24,15 +34,32 @@ static void map_batch_update(int map_fd, __u32 max_entries, int *keys,
 }
 
 static void map_batch_verify(int *visited, __u32 max_entries,
-			     int *keys, int *values)
+			     int *keys, void *values, bool is_pcpu)
 {
-	int i;
+	typedef BPF_DECLARE_PERCPU(int, value);
+	value *v;
+	int i, j;
+
+	if(is_pcpu)
+		v = (value *)values;
 
 	memset(visited, 0, max_entries * sizeof(*visited));
 	for (i = 0; i < max_entries; i++) {
-		CHECK(keys[i] + 1 != values[i], "key/value checking",
-		      "error: i %d key %d value %d\n", i, keys[i], values[i]);
+
+		if (is_pcpu) {
+			for (j = 0; j < bpf_num_possible_cpus(); j++) {
+				CHECK(keys[i] + 1 + j != bpf_percpu(v[i], j),
+				      "key/value checking",
+				      "error: i %d j %d key %d value %d\n",
+				      i, j, keys[i], bpf_percpu(v[i],  j));
+			}
+		} else {
+			CHECK(keys[i] + 1 != ((int *)values)[i], "key/value checking",
+			      "error: i %d key %d value %d\n", i, keys[i], ((int *)values)[i]);
+		}
+
 		visited[i] = 1;
+
 	}
 	for (i = 0; i < max_entries; i++) {
 		CHECK(visited[i] != 1, "visited checking",
@@ -40,18 +67,21 @@ static void map_batch_verify(int *visited, __u32 max_entries,
 	}
 }
 
-void test_map_lookup_and_delete_batch(void)
-{
+void __test_map_lookup_and_delete_batch(bool is_pcpu){
+	int map_type = is_pcpu ? BPF_MAP_TYPE_PERCPU_HASH : BPF_MAP_TYPE_HASH;
 	struct bpf_create_map_attr xattr = {
 		.name = "hash_map",
-		.map_type = BPF_MAP_TYPE_HASH,
+		.map_type = map_type,
 		.key_size = sizeof(int),
 		.value_size = sizeof(int),
 	};
-	int map_fd, *keys, *values, *visited, key;
+	typedef BPF_DECLARE_PERCPU(int, value);
+	int map_fd, *keys, *visited, key;
+	void *values;
 	__u32 count, total, total_success;
 	const __u32 max_entries = 10;
-	int err, i, step;
+	int err, i, step, value_size;
+	value pcpu_values [10];
 	bool nospace_err;
 	__u64 batch = 0;
 
@@ -60,8 +90,12 @@ void test_map_lookup_and_delete_batch(void)
 	CHECK(map_fd == -1,
 	      "bpf_create_map_xattr()", "error:%s\n", strerror(errno));
 
-	keys = malloc(max_entries * sizeof(int));
-	values = malloc(max_entries * sizeof(int));
+	value_size = is_pcpu ? sizeof(value) : sizeof(int);
+	keys = malloc(max_entries * sizeof(int)); 
+	if (is_pcpu)
+		values = pcpu_values;
+	else
+		values = malloc(max_entries * sizeof(int));
 	visited = malloc(max_entries * sizeof(int));
 	CHECK(!keys || !values || !visited, "malloc()", "error:%s\n", strerror(errno));
 
@@ -73,7 +107,7 @@ void test_map_lookup_and_delete_batch(void)
 	CHECK(batch || count, "empty map", "batch = %lld, count = %u\n", batch, count);
 
 	/* populate elements to the map */
-	map_batch_update(map_fd, max_entries, keys, values);
+	map_batch_update(map_fd, max_entries, keys, values, is_pcpu);
 
 	/* test 2: lookup/delete with count = 0, success */
 	batch = 0;
@@ -84,7 +118,7 @@ void test_map_lookup_and_delete_batch(void)
 
 	/* test 3: lookup/delete with count = max_entries, success */
 	memset(keys, 0, max_entries * sizeof(*keys));
-	memset(values, 0, max_entries * sizeof(*values));
+	memset(values, 0, max_entries * value_size);
 	count = max_entries;
 	batch = 0;
 	err = bpf_map_lookup_and_delete_batch(map_fd, &batch, keys,
@@ -93,7 +127,7 @@ void test_map_lookup_and_delete_batch(void)
 	CHECK(count != max_entries || batch != 0, "count = max_entries",
 	      "count = %u, max_entries = %u, batch = %lld\n",
 	      count, max_entries, batch);
-	map_batch_verify(visited, max_entries, keys, values);
+	map_batch_verify(visited, max_entries, keys, values, is_pcpu);
 
 	/* bpf_map_get_next_key() should return -ENOENT for an empty map. */
 	err = bpf_map_get_next_key(map_fd, NULL, &key);
@@ -102,9 +136,48 @@ void test_map_lookup_and_delete_batch(void)
 	/* test 4: lookup/delete in a loop with various steps. */
 	total_success = 0;
 	for (step = 1; step < max_entries; step++) {
-		map_batch_update(map_fd, max_entries, keys, values);
+		map_batch_update(map_fd, max_entries, keys, values, is_pcpu);
+		memset(keys, 0, max_entries * sizeof(*keys));
+		memset(values, 0, max_entries * value_size);
+		batch = 0;
+		total = 0;
+		i = 0;
+		/* iteratively lookup/delete elements with 'step' elements each */
+		count = step;
+		nospace_err = false;
+		while (true) {
+			err = bpf_map_lookup_batch(map_fd, &batch,
+						   keys + total,
+						   values + total * value_size,
+						   &count, 0, 0);
+			/* It is possible that we are failing due to buffer size
+			 * not big enough. In such cases, let us just exit and
+			 * go with large steps. Not that a buffer size with
+			 * max_entries should always work.
+			 */
+			if (err && errno == ENOSPC) {
+				nospace_err = true;
+				break;
+			}
+
+			CHECK(err, "lookup with steps", "error: %s\n",
+			      strerror(errno));
+
+			total += count;
+			if (err || batch == 0)
+				break;
+
+			i++;
+		}
+		if (nospace_err == true)
+			continue;
+
+		CHECK(total != max_entries, "lookup with steps",
+		      "total = %u, max_entries = %u\n", total, max_entries);
+		map_batch_verify(visited, max_entries, keys, values, is_pcpu);
+
 		memset(keys, 0, max_entries * sizeof(*keys));
-		memset(values, 0, max_entries * sizeof(*values));
+		memset(values, 0, max_entries * value_size);
 		batch = 0;
 		total = 0;
 		i = 0;
@@ -114,7 +187,7 @@ void test_map_lookup_and_delete_batch(void)
 		while (true) {
 			err = bpf_map_lookup_and_delete_batch(map_fd, &batch,
 							      keys + total,
-							      values + total,
+							      values + total * value_size,
 							      &count, 0, 0);
 			/* It is possible that we are failing due to buffer size
 			 * not big enough. In such cases, let us just exit and
@@ -142,7 +215,7 @@ void test_map_lookup_and_delete_batch(void)
 		CHECK(total != max_entries, "lookup/delete with steps",
 		      "total = %u, max_entries = %u\n", total, max_entries);
 
-		map_batch_verify(visited, max_entries, keys, values);
+		map_batch_verify(visited, max_entries, keys, values, is_pcpu);
 		err = bpf_map_get_next_key(map_fd, NULL, &key);
 		CHECK(!err, "bpf_map_get_next_key()", "error: %s\n", strerror(errno));
 
@@ -150,6 +223,23 @@ void test_map_lookup_and_delete_batch(void)
 	}
 
 	CHECK(total_success == 0, "check total_success", "unexpected failure\n");
+}
+
+void test_hmap_lookup_and_delete_batch(void)
+{
+	__test_map_lookup_and_delete_batch(false);
+	printf("%s:PASS\n", __func__);
+}
 
+void test_pcpu_hmap_lookup_and_delete_batch(void)
+{
+	__test_map_lookup_and_delete_batch(true);
 	printf("%s:PASS\n", __func__);
 }
+
+void test_map_lookup_and_delete_batch(void)
+{
+	test_hmap_lookup_and_delete_batch();
+	test_pcpu_hmap_lookup_and_delete_batch();
+}
+
diff --git a/tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch_array.c b/tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch_array.c
new file mode 100644
index 0000000000000..e4ea6e45f038c
--- /dev/null
+++ b/tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch_array.c
@@ -0,0 +1,118 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <stdio.h>
+#include <errno.h>
+#include <string.h>
+
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#include <test_maps.h>
+
+static void map_batch_update(int map_fd, __u32 max_entries, int *keys,
+			     int *values)
+{
+	int i, err;
+
+	for (i = 0; i < max_entries; i++) {
+		keys[i] = i;
+		values[i] = i + 1;
+	}
+
+	err = bpf_map_update_batch(map_fd, keys, values, &max_entries, 0, 0);
+	CHECK(err, "bpf_map_update_batch()", "error:%s\n", strerror(errno));
+}
+
+static void map_batch_verify(int *visited, __u32 max_entries,
+			     int *keys, int *values)
+{
+	int i;
+
+	memset(visited, 0, max_entries * sizeof(*visited));
+	for (i = 0; i < max_entries; i++) {
+		CHECK(keys[i] + 1 != values[i], "key/value checking",
+		      "error: i %d key %d value %d\n", i, keys[i], values[i]);
+		visited[i] = 1;
+	}
+	for (i = 0; i < max_entries; i++) {
+		CHECK(visited[i] != 1, "visited checking",
+		      "error: keys array at index %d missing\n", i);
+	}
+}
+
+void test_map_lookup_and_delete_batch_array(void)
+{
+	struct bpf_create_map_attr xattr = {
+		.name = "hash_map",
+		.map_type = BPF_MAP_TYPE_ARRAY,
+		.key_size = sizeof(int),
+		.value_size = sizeof(int),
+	};
+	int map_fd, *keys, *values, *visited;
+	__u32 count, total, total_success;
+	const __u32 max_entries = 10;
+	int err, i, step;
+	bool nospace_err;
+	__u64 batch = 0;
+
+	xattr.max_entries = max_entries;
+	map_fd = bpf_create_map_xattr(&xattr);
+	CHECK(map_fd == -1,
+	      "bpf_create_map_xattr()", "error:%s\n", strerror(errno));
+
+	keys = malloc(max_entries * sizeof(int));
+	values = malloc(max_entries * sizeof(int));
+	visited = malloc(max_entries * sizeof(int));
+	CHECK(!keys || !values || !visited, "malloc()", "error:%s\n",
+	      strerror(errno));
+
+	/* populate elements to the map */
+	map_batch_update(map_fd, max_entries, keys, values);
+
+	/* test 1: lookup in a loop with various steps. */
+	total_success = 0;
+	for (step = 1; step < max_entries; step++) {
+		map_batch_update(map_fd, max_entries, keys, values);
+		memset(keys, 0, max_entries * sizeof(*keys));
+		memset(values, 0, max_entries * sizeof(*values));
+		batch = 0;
+		total = 0;
+		i = 0;
+		/* iteratively lookup/delete elements with 'step'
+		 * elements each.
+		 */
+		count = step;
+		nospace_err = false;
+		while (true) {
+			err = bpf_map_lookup_batch(map_fd, &batch,
+						   keys + total,
+						   values + total,
+						   &count, 0, 0);
+
+			CHECK(err, "lookup with steps", "error: %s\n",
+			      strerror(errno));
+
+			total += count;
+
+			if (err || batch == 0)
+				break;
+
+			i++;
+		}
+
+		if (nospace_err == true)
+			continue;
+
+		CHECK(total != max_entries, "lookup with steps",
+		      "total = %u, max_entries = %u\n", total, max_entries);
+
+		map_batch_verify(visited, max_entries, keys, values);
+
+		total_success++;
+	}
+
+	CHECK(total_success == 0, "check total_success",
+	      "unexpected failure\n");
+
+	printf("%s:PASS\n", __func__);
+}
-- 
2.24.0.432.g9d3f5f5b63-goog

