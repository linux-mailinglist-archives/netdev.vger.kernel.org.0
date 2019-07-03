Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D21C5E9F9
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 19:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbfGCRCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 13:02:09 -0400
Received: from mail-ua1-f74.google.com ([209.85.222.74]:52221 "EHLO
        mail-ua1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727240AbfGCRCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 13:02:05 -0400
Received: by mail-ua1-f74.google.com with SMTP id d5so162127uaj.18
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 10:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=a4B2pi3afPrfivcwvxY/0YFG7emhlAa6z/TIz7oLh4I=;
        b=bukW9FgrgpnaTfg+obcuWRTUvcBzM1ggSi0JTvkY2Ae5L6Evnn1MydKeWAdJr4jHpD
         K155rMxmXXFSDoq4Gb6xRF5gobEtv7Uo8uSmSZ14Anr3zhMh2ChciBLGQZGq6OekZKEe
         jRP1pbytIydxHfngZ0esiuBzO2S38JHCupNdqAzG3a1512b2/+dX0x06ht1OuIhnMZwO
         /9nO/fzdGARi9rMTIVYLWPZIdBTRyaktPnhp99sgEoQSR4Wu8SAzlVe31dFU/gEiQPhV
         7AEr53drxmxgT0iNyHiR5JGfHl5U/KRFgOeuXxobQH3RkOQwsTNpuYtWiXrOvJcJ3v6L
         qx+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=a4B2pi3afPrfivcwvxY/0YFG7emhlAa6z/TIz7oLh4I=;
        b=eNVATReNy4cUsOHp0IWmWpM/5rTJ9i8UvIPJKouKPMUHfj5+P6QwuS9aNZEDbno/T3
         yjqEXcXzBwV1o1x11EyiU3G+I6zpw++mcDPTVIs8uzba9P+Py4gXVvFg+91KClPYXULQ
         hnedAEXX7aHpSLozlehU+kfFFgy4QP1QilOAYB7VMxNO1LXCKhYDYUi1LTsudyAzMtbF
         E74NTKUiNqMsCelij/GYBaKxU54rQT1KdkvCy6mixinpw7UYV71uymk/GjSTOOjlTVBI
         nH5noDwoXcQ7L/YqINSz46KebcveYNkgmshIl2xjNB8ZENz1mUD8swvJ/qv1k9q69QEL
         JhGQ==
X-Gm-Message-State: APjAAAV0XA95Kd5WZFTwKitzSUeJweSkOEE/H+Y6mSt9vLBv0Kq629BN
        MnTJykzDHIbWzxIWY1kYgb4dH+BQHSTU
X-Google-Smtp-Source: APXvYqyRDVT/laYhNDbWB8Xb2kPsFbhawuoJWiOJduoc/afILyBFyisVqWPFHogEuIHJSxmJgFzVmkvnEmqF
X-Received: by 2002:a1f:a887:: with SMTP id r129mr11227778vke.75.1562173324191;
 Wed, 03 Jul 2019 10:02:04 -0700 (PDT)
Date:   Wed,  3 Jul 2019 10:01:13 -0700
In-Reply-To: <20190703170118.196552-1-brianvv@google.com>
Message-Id: <20190703170118.196552-2-brianvv@google.com>
Mime-Version: 1.0
References: <20190703170118.196552-1-brianvv@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next RFC v3 1/6] bpf: add bpf_map_value_size and
 bp_map_copy_value helper functions
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Brian Vazquez <brianvv@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move reusable code from map_lookup_elem to helper functions to avoid code
duplication in kernel/bpf/syscall.c

Suggested-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Brian Vazquez <brianvv@google.com>
---
 kernel/bpf/syscall.c | 134 +++++++++++++++++++++++--------------------
 1 file changed, 73 insertions(+), 61 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index b0f545e07425..d200d2837ade 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -126,6 +126,76 @@ static struct bpf_map *find_and_alloc_map(union bpf_attr *attr)
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
+static int bpf_map_copy_value(struct bpf_map *map, void *key, void *value,
+			      __u64 flags)
+{
+	void *ptr;
+	int err;
+
+	if (bpf_map_is_dev_bound(map))
+		return  bpf_map_offload_lookup_elem(map, key, value);
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
+	this_cpu_dec(bpf_prog_active);
+	preempt_enable();
+
+	return err;
+}
+
 void *bpf_map_area_alloc(size_t size, int numa_node)
 {
 	/* We really just want to fail instead of triggering OOM killer
@@ -729,7 +799,7 @@ static int map_lookup_elem(union bpf_attr *attr)
 	void __user *uvalue = u64_to_user_ptr(attr->value);
 	int ufd = attr->map_fd;
 	struct bpf_map *map;
-	void *key, *value, *ptr;
+	void *key, *value;
 	u32 value_size;
 	struct fd f;
 	int err;
@@ -761,72 +831,14 @@ static int map_lookup_elem(union bpf_attr *attr)
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
+	err = bpf_map_copy_value(map, key, value, attr->flags);
 	if (err)
 		goto free_value;
 
-- 
2.22.0.410.gd8fdbe21b5-goog

