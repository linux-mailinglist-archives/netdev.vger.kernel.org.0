Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0A81180550
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 18:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbgCJRrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 13:47:31 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52553 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbgCJRrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 13:47:31 -0400
Received: by mail-wm1-f66.google.com with SMTP id 11so2079990wmo.2
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 10:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VOVxpIVTl1mbMOrH4rGvuKP/ssyXIX2mzp/+xoiFMfw=;
        b=v4O5uI+Zw8nHFm0oKKYzkXlBVbyCW4vvzZMubbOI5hrGUsXM+nWTpQ72uSE4DHuBfs
         PjWBPJCiEXST44w81hzSCb/sp9DR3DtUWCk5WjnDRjBiref2kWPDkyvbGjOe573KP7Dn
         f9hWNENyvHoWciaJJ0HFXkOiWkSWj7k5b90OE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VOVxpIVTl1mbMOrH4rGvuKP/ssyXIX2mzp/+xoiFMfw=;
        b=ejBWTpREscPolSJgex1LY7l7ABlfL8/a0raetm9St5W6WOscwSpBVaz0OluzvuOzgA
         sd8ta9oISUBXo5o6cQjrQu7n6YrLumuzan0TAXAq/x9lW/HDteLhV69cdhLDLnqYLVzD
         ux2A8egLK1VpJEISkHBn3rMR9zAJAy9bdL2J2vKArUon6qcgEv/9GFdLboifNJcmTPMT
         JoV3w9AsXJf57VeBz0l/7Z1PcKwgNwVRV0YMV6AdM61bFri9dCqyj6UtJt9ughmpXWni
         9oPfLZ7UhhZQIYRIP2/TKOsg5Umqd4m5MoEiRISGOJZcOTD9IvSHXaunGVFB/2coLPoJ
         AYMg==
X-Gm-Message-State: ANhLgQ3yR3ptddIKguwWck8XPXvOzUurIezSevUSOKQ3SKJb4aJq20fX
        0+1JEIdifq3atPJDL6VSGy/3+gDGWpE=
X-Google-Smtp-Source: ADFU+vuSj7BjZpChlQFTQVFKfYrsLOKUpJKHl7GK7T5wV+os0aT4UwkwkF0NTlFg1QRB0zdW7IW7BQ==
X-Received: by 2002:a1c:9c96:: with SMTP id f144mr3131417wme.98.1583862448310;
        Tue, 10 Mar 2020 10:47:28 -0700 (PDT)
Received: from localhost.localdomain ([2a06:98c0:1000:8250:9494:775c:e7b6:e690])
        by smtp.gmail.com with ESMTPSA id k4sm9118691wrx.27.2020.03.10.10.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 10:47:27 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] bpf: add map_copy_value hook
Date:   Tue, 10 Mar 2020 17:47:07 +0000
Message-Id: <20200310174711.7490-2-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200310174711.7490-1-lmb@cloudflare.com>
References: <20200310174711.7490-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_map_copy_value has a lot of special cases for different map types
that want more control than map_lookup_elem provides. On closer
inspection, almost all of them follow the pattern

    int func(struct bpf_map *, void *, void *)

Introduce a new member map_copy_value to struct bpf_map_ops, and
convert the current special cases to use it.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 include/linux/bpf-cgroup.h   |  5 -----
 include/linux/bpf.h          | 21 +--------------------
 include/linux/bpf_types.h    |  2 +-
 kernel/bpf/arraymap.c        | 13 ++++++++++---
 kernel/bpf/bpf_struct_ops.c  |  7 ++++---
 kernel/bpf/hashtab.c         | 10 +++++++---
 kernel/bpf/local_storage.c   | 14 +++++++++++++-
 kernel/bpf/reuseport_array.c |  5 +++--
 kernel/bpf/syscall.c         | 24 ++++--------------------
 9 files changed, 43 insertions(+), 58 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index a7cd5c7a2509..6741a6c460f6 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -162,7 +162,6 @@ void bpf_cgroup_storage_unlink(struct bpf_cgroup_storage *storage);
 int bpf_cgroup_storage_assign(struct bpf_prog_aux *aux, struct bpf_map *map);
 void bpf_cgroup_storage_release(struct bpf_prog_aux *aux, struct bpf_map *map);
 
-int bpf_percpu_cgroup_storage_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 				     void *value, u64 flags);
 
@@ -370,10 +369,6 @@ static inline struct bpf_cgroup_storage *bpf_cgroup_storage_alloc(
 	struct bpf_prog *prog, enum bpf_cgroup_storage_type stype) { return NULL; }
 static inline void bpf_cgroup_storage_free(
 	struct bpf_cgroup_storage *storage) {}
-static inline int bpf_percpu_cgroup_storage_copy(struct bpf_map *map, void *key,
-						 void *value) {
-	return 0;
-}
 static inline int bpf_percpu_cgroup_storage_update(struct bpf_map *map,
 					void *key, void *value, u64 flags) {
 	return 0;
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 94a329b9da81..ad9f3be830f0 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -44,6 +44,7 @@ struct bpf_map_ops {
 	int (*map_get_next_key)(struct bpf_map *map, void *key, void *next_key);
 	void (*map_release_uref)(struct bpf_map *map);
 	void *(*map_lookup_elem_sys_only)(struct bpf_map *map, void *key);
+	int (*map_copy_value)(struct bpf_map *map, void *key, void *value);
 	int (*map_lookup_batch)(struct bpf_map *map, const union bpf_attr *attr,
 				union bpf_attr __user *uattr);
 	int (*map_lookup_and_delete_batch)(struct bpf_map *map,
@@ -741,8 +742,6 @@ const struct bpf_struct_ops *bpf_struct_ops_find(u32 type_id);
 void bpf_struct_ops_init(struct btf *btf, struct bpf_verifier_log *log);
 bool bpf_struct_ops_get(const void *kdata);
 void bpf_struct_ops_put(const void *kdata);
-int bpf_struct_ops_map_sys_lookup_elem(struct bpf_map *map, void *key,
-				       void *value);
 static inline bool bpf_try_module_get(const void *data, struct module *owner)
 {
 	if (owner == BPF_MODULE_OWNER)
@@ -774,12 +773,6 @@ static inline void bpf_module_put(const void *data, struct module *owner)
 {
 	module_put(owner);
 }
-static inline int bpf_struct_ops_map_sys_lookup_elem(struct bpf_map *map,
-						     void *key,
-						     void *value)
-{
-	return -EINVAL;
-}
 #endif
 
 struct bpf_array {
@@ -1082,8 +1075,6 @@ struct bpf_link *bpf_link_get_from_fd(u32 ufd);
 int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
 int bpf_obj_get_user(const char __user *pathname, int flags);
 
-int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
-int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_hash_update(struct bpf_map *map, void *key, void *value,
 			   u64 flags);
 int bpf_percpu_array_update(struct bpf_map *map, void *key, void *value,
@@ -1093,10 +1084,8 @@ int bpf_stackmap_copy(struct bpf_map *map, void *key, void *value);
 
 int bpf_fd_array_map_update_elem(struct bpf_map *map, struct file *map_file,
 				 void *key, void *value, u64 map_flags);
-int bpf_fd_array_map_lookup_elem(struct bpf_map *map, void *key, u32 *value);
 int bpf_fd_htab_map_update_elem(struct bpf_map *map, struct file *map_file,
 				void *key, void *value, u64 map_flags);
-int bpf_fd_htab_map_lookup_elem(struct bpf_map *map, void *key, u32 *value);
 
 int bpf_get_file_flag(int flags);
 int bpf_check_uarg_tail_zero(void __user *uaddr, size_t expected_size,
@@ -1437,8 +1426,6 @@ static inline int sock_map_get_from_fd(const union bpf_attr *attr,
 
 #if defined(CONFIG_INET) && defined(CONFIG_BPF_SYSCALL)
 void bpf_sk_reuseport_detach(struct sock *sk);
-int bpf_fd_reuseport_array_lookup_elem(struct bpf_map *map, void *key,
-				       void *value);
 int bpf_fd_reuseport_array_update_elem(struct bpf_map *map, void *key,
 				       void *value, u64 map_flags);
 #else
@@ -1447,12 +1434,6 @@ static inline void bpf_sk_reuseport_detach(struct sock *sk)
 }
 
 #ifdef CONFIG_BPF_SYSCALL
-static inline int bpf_fd_reuseport_array_lookup_elem(struct bpf_map *map,
-						     void *key, void *value)
-{
-	return -EOPNOTSUPP;
-}
-
 static inline int bpf_fd_reuseport_array_update_elem(struct bpf_map *map,
 						     void *key, void *value,
 						     u64 map_flags)
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index c81d4ece79a4..4949638cd049 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -81,7 +81,7 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_CGROUP_ARRAY, cgroup_array_map_ops)
 #endif
 #ifdef CONFIG_CGROUP_BPF
 BPF_MAP_TYPE(BPF_MAP_TYPE_CGROUP_STORAGE, cgroup_storage_map_ops)
-BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE, cgroup_storage_map_ops)
+BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE, percpu_cgroup_storage_map_ops)
 #endif
 BPF_MAP_TYPE(BPF_MAP_TYPE_HASH, htab_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_HASH, htab_percpu_map_ops)
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 95d77770353c..58a0a8b3abe3 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -249,7 +249,8 @@ static void *percpu_array_map_lookup_elem(struct bpf_map *map, void *key)
 	return this_cpu_ptr(array->pptrs[index & array->index_mask]);
 }
 
-int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value)
+static int percpu_array_map_copy_value(struct bpf_map *map, void *key,
+				       void *value)
 {
 	struct bpf_array *array = container_of(map, struct bpf_array, map);
 	u32 index = *(u32 *)key;
@@ -513,6 +514,7 @@ const struct bpf_map_ops percpu_array_map_ops = {
 	.map_free = array_map_free,
 	.map_get_next_key = array_map_get_next_key,
 	.map_lookup_elem = percpu_array_map_lookup_elem,
+	.map_copy_value = percpu_array_map_copy_value,
 	.map_update_elem = array_map_update_elem,
 	.map_delete_elem = array_map_delete_elem,
 	.map_seq_show_elem = percpu_array_map_seq_show_elem,
@@ -550,7 +552,8 @@ static void *fd_array_map_lookup_elem(struct bpf_map *map, void *key)
 }
 
 /* only called from syscall */
-int bpf_fd_array_map_lookup_elem(struct bpf_map *map, void *key, u32 *value)
+static int fd_array_map_lookup_elem_sys_copy(struct bpf_map *map, void *key,
+					     void *value)
 {
 	void **elem, *ptr;
 	int ret =  0;
@@ -561,7 +564,7 @@ int bpf_fd_array_map_lookup_elem(struct bpf_map *map, void *key, u32 *value)
 	rcu_read_lock();
 	elem = array_map_lookup_elem(map, key);
 	if (elem && (ptr = READ_ONCE(*elem)))
-		*value = map->ops->map_fd_sys_lookup_elem(ptr);
+		*(u32 *)value = map->ops->map_fd_sys_lookup_elem(ptr);
 	else
 		ret = -ENOENT;
 	rcu_read_unlock();
@@ -872,6 +875,7 @@ const struct bpf_map_ops prog_array_map_ops = {
 	.map_poke_run = prog_array_map_poke_run,
 	.map_get_next_key = array_map_get_next_key,
 	.map_lookup_elem = fd_array_map_lookup_elem,
+	.map_copy_value = fd_array_map_lookup_elem_sys_copy,
 	.map_delete_elem = fd_array_map_delete_elem,
 	.map_fd_get_ptr = prog_fd_array_get_ptr,
 	.map_fd_put_ptr = prog_fd_array_put_ptr,
@@ -962,6 +966,7 @@ const struct bpf_map_ops perf_event_array_map_ops = {
 	.map_free = fd_array_map_free,
 	.map_get_next_key = array_map_get_next_key,
 	.map_lookup_elem = fd_array_map_lookup_elem,
+	.map_copy_value = fd_array_map_lookup_elem_sys_copy,
 	.map_delete_elem = fd_array_map_delete_elem,
 	.map_fd_get_ptr = perf_event_fd_array_get_ptr,
 	.map_fd_put_ptr = perf_event_fd_array_put_ptr,
@@ -995,6 +1000,7 @@ const struct bpf_map_ops cgroup_array_map_ops = {
 	.map_free = cgroup_fd_array_free,
 	.map_get_next_key = array_map_get_next_key,
 	.map_lookup_elem = fd_array_map_lookup_elem,
+	.map_copy_value = fd_array_map_lookup_elem_sys_copy,
 	.map_delete_elem = fd_array_map_delete_elem,
 	.map_fd_get_ptr = cgroup_fd_array_get_ptr,
 	.map_fd_put_ptr = cgroup_fd_array_put_ptr,
@@ -1078,6 +1084,7 @@ const struct bpf_map_ops array_of_maps_map_ops = {
 	.map_free = array_of_map_free,
 	.map_get_next_key = array_map_get_next_key,
 	.map_lookup_elem = array_of_map_lookup_elem,
+	.map_copy_value = fd_array_map_lookup_elem_sys_copy,
 	.map_delete_elem = fd_array_map_delete_elem,
 	.map_fd_get_ptr = bpf_map_fd_get_ptr,
 	.map_fd_put_ptr = bpf_map_fd_put_ptr,
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index ca5cc8cdb6eb..cc1d7d1077c1 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -238,8 +238,8 @@ static int bpf_struct_ops_map_get_next_key(struct bpf_map *map, void *key,
 	return 0;
 }
 
-int bpf_struct_ops_map_sys_lookup_elem(struct bpf_map *map, void *key,
-				       void *value)
+static int bpf_struct_ops_map_copy_value(struct bpf_map *map, void *key,
+					 void *value)
 {
 	struct bpf_struct_ops_map *st_map = (struct bpf_struct_ops_map *)map;
 	struct bpf_struct_ops_value *uvalue, *kvalue;
@@ -509,7 +509,7 @@ static void bpf_struct_ops_map_seq_show_elem(struct bpf_map *map, void *key,
 	if (!value)
 		return;
 
-	err = bpf_struct_ops_map_sys_lookup_elem(map, key, value);
+	err = bpf_struct_ops_map_copy_value(map, key, value);
 	if (!err) {
 		btf_type_seq_show(btf_vmlinux, map->btf_vmlinux_value_type_id,
 				  value, m);
@@ -609,6 +609,7 @@ const struct bpf_map_ops bpf_struct_ops_map_ops = {
 	.map_free = bpf_struct_ops_map_free,
 	.map_get_next_key = bpf_struct_ops_map_get_next_key,
 	.map_lookup_elem = bpf_struct_ops_map_lookup_elem,
+	.map_copy_value = bpf_struct_ops_map_copy_value,
 	.map_delete_elem = bpf_struct_ops_map_delete_elem,
 	.map_update_elem = bpf_struct_ops_map_update_elem,
 	.map_seq_show_elem = bpf_struct_ops_map_seq_show_elem,
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index d541c8486c95..f5452a8a5177 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -1664,7 +1664,8 @@ static void *htab_lru_percpu_map_lookup_elem(struct bpf_map *map, void *key)
 	return NULL;
 }
 
-int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value)
+static int htab_percpu_map_copy_value(struct bpf_map *map, void *key,
+				      void *value)
 {
 	struct htab_elem *l;
 	void __percpu *pptr;
@@ -1749,6 +1750,7 @@ const struct bpf_map_ops htab_percpu_map_ops = {
 	.map_free = htab_map_free,
 	.map_get_next_key = htab_map_get_next_key,
 	.map_lookup_elem = htab_percpu_map_lookup_elem,
+	.map_copy_value = htab_percpu_map_copy_value,
 	.map_update_elem = htab_percpu_map_update_elem,
 	.map_delete_elem = htab_map_delete_elem,
 	.map_seq_show_elem = htab_percpu_map_seq_show_elem,
@@ -1761,6 +1763,7 @@ const struct bpf_map_ops htab_lru_percpu_map_ops = {
 	.map_free = htab_map_free,
 	.map_get_next_key = htab_map_get_next_key,
 	.map_lookup_elem = htab_lru_percpu_map_lookup_elem,
+	.map_copy_value = htab_percpu_map_copy_value,
 	.map_update_elem = htab_lru_percpu_map_update_elem,
 	.map_delete_elem = htab_lru_map_delete_elem,
 	.map_seq_show_elem = htab_percpu_map_seq_show_elem,
@@ -1796,7 +1799,7 @@ static void fd_htab_map_free(struct bpf_map *map)
 }
 
 /* only called from syscall */
-int bpf_fd_htab_map_lookup_elem(struct bpf_map *map, void *key, u32 *value)
+static int fd_htab_map_copy_value(struct bpf_map *map, void *key, void *value)
 {
 	void **ptr;
 	int ret = 0;
@@ -1807,7 +1810,7 @@ int bpf_fd_htab_map_lookup_elem(struct bpf_map *map, void *key, u32 *value)
 	rcu_read_lock();
 	ptr = htab_map_lookup_elem(map, key);
 	if (ptr)
-		*value = map->ops->map_fd_sys_lookup_elem(READ_ONCE(*ptr));
+		*(u32 *)value = map->ops->map_fd_sys_lookup_elem(READ_ONCE(*ptr));
 	else
 		ret = -ENOENT;
 	rcu_read_unlock();
@@ -1893,6 +1896,7 @@ const struct bpf_map_ops htab_of_maps_map_ops = {
 	.map_free = htab_of_map_free,
 	.map_get_next_key = htab_map_get_next_key,
 	.map_lookup_elem = htab_of_map_lookup_elem,
+	.map_copy_value = fd_htab_map_copy_value,
 	.map_delete_elem = htab_map_delete_elem,
 	.map_fd_get_ptr = bpf_map_fd_get_ptr,
 	.map_fd_put_ptr = bpf_map_fd_put_ptr,
diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index 33d01866bcc2..fcc0b168dad2 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -167,7 +167,7 @@ static int cgroup_storage_update_elem(struct bpf_map *map, void *_key,
 	return 0;
 }
 
-int bpf_percpu_cgroup_storage_copy(struct bpf_map *_map, void *_key,
+static int percpu_cgroup_storage_copy(struct bpf_map *_map, void *_key,
 				   void *value)
 {
 	struct bpf_cgroup_storage_map *map = map_to_storage(_map);
@@ -420,6 +420,18 @@ const struct bpf_map_ops cgroup_storage_map_ops = {
 	.map_seq_show_elem = cgroup_storage_seq_show_elem,
 };
 
+const struct bpf_map_ops percpu_cgroup_storage_map_ops = {
+	.map_alloc = cgroup_storage_map_alloc,
+	.map_free = cgroup_storage_map_free,
+	.map_get_next_key = cgroup_storage_get_next_key,
+	.map_lookup_elem = cgroup_storage_lookup_elem,
+	.map_copy_value = percpu_cgroup_storage_copy,
+	.map_update_elem = cgroup_storage_update_elem,
+	.map_delete_elem = cgroup_storage_delete_elem,
+	.map_check_btf = cgroup_storage_check_btf,
+	.map_seq_show_elem = cgroup_storage_seq_show_elem,
+};
+
 int bpf_cgroup_storage_assign(struct bpf_prog_aux *aux, struct bpf_map *_map)
 {
 	enum bpf_cgroup_storage_type stype = cgroup_storage_type(_map);
diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
index 01badd3eda7a..f36ccbf2612e 100644
--- a/kernel/bpf/reuseport_array.c
+++ b/kernel/bpf/reuseport_array.c
@@ -178,8 +178,8 @@ static struct bpf_map *reuseport_array_alloc(union bpf_attr *attr)
 	return &array->map;
 }
 
-int bpf_fd_reuseport_array_lookup_elem(struct bpf_map *map, void *key,
-				       void *value)
+static int reuseport_array_copy_value(struct bpf_map *map, void *key,
+				      void *value)
 {
 	struct sock *sk;
 	int err;
@@ -350,6 +350,7 @@ const struct bpf_map_ops reuseport_array_ops = {
 	.map_alloc = reuseport_array_alloc,
 	.map_free = reuseport_array_free,
 	.map_lookup_elem = reuseport_array_lookup_elem,
+	.map_copy_value = reuseport_array_copy_value,
 	.map_get_next_key = reuseport_array_get_next_key,
 	.map_delete_elem = reuseport_array_delete_elem,
 };
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 7ce0815793dd..6503824e81e9 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -218,27 +218,11 @@ static int bpf_map_copy_value(struct bpf_map *map, void *key, void *value,
 		return bpf_map_offload_lookup_elem(map, key, value);
 
 	bpf_disable_instrumentation();
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
+	if (map->map_type == BPF_MAP_TYPE_QUEUE ||
+	    map->map_type == BPF_MAP_TYPE_STACK) {
 		err = map->ops->map_peek_elem(map, value);
-	} else if (map->map_type == BPF_MAP_TYPE_STRUCT_OPS) {
-		/* struct_ops map requires directly updating "value" */
-		err = bpf_struct_ops_map_sys_lookup_elem(map, key, value);
+	} else if (map->ops->map_copy_value) {
+		err = map->ops->map_copy_value(map, key, value);
 	} else {
 		rcu_read_lock();
 		if (map->ops->map_lookup_elem_sys_only)
-- 
2.20.1

