Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B62C13AFE8
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 17:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728924AbgANQqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 11:46:39 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:45844 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728912AbgANQqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 11:46:38 -0500
Received: by mail-pl1-f202.google.com with SMTP id k9so5384403pll.12
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 08:46:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Jc5+7d7NtiEYIwbVpgtYmSFqbGpKI69cS8An9zRo6DQ=;
        b=RD+O07e8AvfO9vxlexBheHJWnYQeRdWn1MYOgbysmc347uLeJufnqIGOBAzcI7jr6l
         N5RMZnBvwpiVkwCIn3L2j8ALC3sIAZZFcxJ0B8cbGYPdaBJx/B8wAowcGbvb/v/tXNJF
         7oprjCc/b4kS60EUehwbCLX67OvjllQfmwU83q55rZkOgu1tnhWKJrsy/K2XkiwTLL6J
         LsSnlx2dk6uU5X+3roL1UGf5t089iFPH5zjC9s9hDlPFanoBMJAr+8E5irV+uPb0o4BG
         cEGrNateiE4nHFS/eM23xH70cVmedwrgS3FkuFPQwWjPum6ttFaZ6dWzE7f8LRWp9qMG
         wQqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Jc5+7d7NtiEYIwbVpgtYmSFqbGpKI69cS8An9zRo6DQ=;
        b=i0jmqYWW66e0T3va+RDTlpdeP7ZJ2kbeS+II/C7wjkDQQf1T4fhcDvGvRNWZnqBS+Q
         l+n9t/5/UbKCzBLAiSsGoFq8+2fhoUqNZCpXgpub+XmAs4sRrhiKqbmM78hXBD0BEZer
         XwnaqtkSHDqhmj8qJgOjUbEZ7MvHDpUKW282naJMf5sNB1u/rA9izXbdIKF/3NNRiPHJ
         uRDDE2DJVgw+6HpfJSuGMCmRTdvLc3NQSnPLPnsuRyAJzG2sQp68Erq/BBkxTn37uFOS
         ftAmM+ndqHUp+JsnP8awtUPWCI3u5m/AtLSIlGLyIFCUq0EnU2s8E8R6Q/gf6sBr1HbD
         0VNw==
X-Gm-Message-State: APjAAAV4eOMzQQruRPyEm1bPCJShqQ53vUO6UlC7y5gl4dlj2bcNrZzK
        +Xew1taLD1fjFDt7oxB/9RchQGkEljiV
X-Google-Smtp-Source: APXvYqzCK/+QxDG9ZFuDR26tMZLXh46byU3EXvYd1q83XUiWtbwRFsNncXq4PHpIUj3OXnaXGqtX/9JFcg5p
X-Received: by 2002:a63:6787:: with SMTP id b129mr27904289pgc.103.1579020396975;
 Tue, 14 Jan 2020 08:46:36 -0800 (PST)
Date:   Tue, 14 Jan 2020 08:46:05 -0800
In-Reply-To: <20200114164614.47029-1-brianvv@google.com>
Message-Id: <20200114164614.47029-2-brianvv@google.com>
Mime-Version: 1.0
References: <20200114164614.47029-1-brianvv@google.com>
X-Mailer: git-send-email 2.25.0.rc1.283.g88dfdc4193-goog
Subject: [PATCH v4 bpf-next 1/9] bpf: add bpf_map_{value_size,update_value,map_copy_value}
 functions
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
        bpf@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit moves reusable code from map_lookup_elem and map_update_elem
to avoid code duplication in kernel/bpf/syscall.c.

Signed-off-by: Brian Vazquez <brianvv@google.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/syscall.c | 280 +++++++++++++++++++++++--------------------
 1 file changed, 152 insertions(+), 128 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index f9db72a96ec04..08b0b6e40454b 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -129,6 +129,154 @@ static struct bpf_map *find_and_alloc_map(union bpf_attr *attr)
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
+
+	/* Need to create a kthread, thus must support schedule */
+	if (bpf_map_is_dev_bound(map)) {
+		return bpf_map_offload_update_elem(map, key, value, flags);
+	} else if (map->map_type == BPF_MAP_TYPE_CPUMAP ||
+		   map->map_type == BPF_MAP_TYPE_SOCKHASH ||
+		   map->map_type == BPF_MAP_TYPE_SOCKMAP ||
+		   map->map_type == BPF_MAP_TYPE_STRUCT_OPS) {
+		return map->ops->map_update_elem(map, key, value, flags);
+	} else if (IS_FD_PROG_ARRAY(map)) {
+		return bpf_fd_array_map_update_elem(map, f.file, key, value,
+						    flags);
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
+			      __u64 flags)
+{
+	void *ptr;
+	int err;
+
+	if (bpf_map_is_dev_bound(map)) {
+		err =  bpf_map_offload_lookup_elem(map, key, value);
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
+	} else if (IS_FD_ARRAY(map) || IS_FD_PROG_ARRAY(map)) {
+		err = bpf_fd_array_map_lookup_elem(map, key, value);
+	} else if (IS_FD_HASH(map)) {
+		err = bpf_fd_htab_map_lookup_elem(map, key, value);
+	} else if (map->map_type == BPF_MAP_TYPE_REUSEPORT_SOCKARRAY) {
+		err = bpf_fd_reuseport_array_lookup_elem(map, key, value);
+	} else if (map->map_type == BPF_MAP_TYPE_QUEUE ||
+		   map->map_type == BPF_MAP_TYPE_STACK) {
+		err = map->ops->map_peek_elem(map, value);
+	} else if (map->map_type == BPF_MAP_TYPE_STRUCT_OPS) {
+		/* struct_ops map requires directly updating "value" */
+		err = bpf_struct_ops_map_sys_lookup_elem(map, key, value);
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
+
+	this_cpu_dec(bpf_prog_active);
+	preempt_enable();
+	maybe_wait_bpf_programs(map);
+
+	return err;
+}
+
 static void *__bpf_map_area_alloc(u64 size, int numa_node, bool mmapable)
 {
 	/* We really just want to fail instead of triggering OOM killer
@@ -827,7 +975,7 @@ static int map_lookup_elem(union bpf_attr *attr)
 	void __user *uvalue = u64_to_user_ptr(attr->value);
 	int ufd = attr->map_fd;
 	struct bpf_map *map;
-	void *key, *value, *ptr;
+	void *key, *value;
 	u32 value_size;
 	struct fd f;
 	int err;
@@ -859,75 +1007,14 @@ static int map_lookup_elem(union bpf_attr *attr)
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
-	} else if (IS_FD_ARRAY(map) || IS_FD_PROG_ARRAY(map)) {
-		err = bpf_fd_array_map_lookup_elem(map, key, value);
-	} else if (IS_FD_HASH(map)) {
-		err = bpf_fd_htab_map_lookup_elem(map, key, value);
-	} else if (map->map_type == BPF_MAP_TYPE_REUSEPORT_SOCKARRAY) {
-		err = bpf_fd_reuseport_array_lookup_elem(map, key, value);
-	} else if (map->map_type == BPF_MAP_TYPE_QUEUE ||
-		   map->map_type == BPF_MAP_TYPE_STACK) {
-		err = map->ops->map_peek_elem(map, value);
-	} else if (map->map_type == BPF_MAP_TYPE_STRUCT_OPS) {
-		/* struct_ops map requires directly updating "value" */
-		err = bpf_struct_ops_map_sys_lookup_elem(map, key, value);
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
+	err = bpf_map_copy_value(map, key, value, attr->flags);
 	if (err)
 		goto free_value;
 
@@ -946,16 +1033,6 @@ static int map_lookup_elem(union bpf_attr *attr)
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
 
@@ -1011,61 +1088,8 @@ static int map_update_elem(union bpf_attr *attr)
 	if (copy_from_user(value, uvalue, value_size) != 0)
 		goto free_value;
 
-	/* Need to create a kthread, thus must support schedule */
-	if (bpf_map_is_dev_bound(map)) {
-		err = bpf_map_offload_update_elem(map, key, value, attr->flags);
-		goto out;
-	} else if (map->map_type == BPF_MAP_TYPE_CPUMAP ||
-		   map->map_type == BPF_MAP_TYPE_SOCKHASH ||
-		   map->map_type == BPF_MAP_TYPE_SOCKMAP ||
-		   map->map_type == BPF_MAP_TYPE_STRUCT_OPS) {
-		err = map->ops->map_update_elem(map, key, value, attr->flags);
-		goto out;
-	} else if (IS_FD_PROG_ARRAY(map)) {
-		err = bpf_fd_array_map_update_elem(map, f.file, key, value,
-						   attr->flags);
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
-- 
2.25.0.rc1.283.g88dfdc4193-goog

