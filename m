Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF33A13CC52
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 19:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729235AbgAOSnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 13:43:35 -0500
Received: from mail-pf1-f201.google.com ([209.85.210.201]:38374 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729214AbgAOSna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 13:43:30 -0500
Received: by mail-pf1-f201.google.com with SMTP id l17so11461501pff.5
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 10:43:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+HqP+4pv65tNa2gKmR3/Ufe3GB9e142iVvYjLgWUjzs=;
        b=akYxcL9+ITuQ5MSssRxGCnVoBxHKT823lD+O+bV4ruD6VuFQCLd8Mvz3zTqrZJLeuJ
         3ELpEryZsOSjEgYTK605geIdA62KHipRYON1jN/zkiqQZGBm0KxZhLk9L4ElMyasjQW0
         66VxWAy/NtKXw7mwYiStg3XZSezuaYKMZWPAt3cDbNAOu1Y98syq46Y4o/54ZcPBwe2V
         19Y/uOaEEbfzarONYn+1jRMFTdUFGGjMgZizQpk00bZahqrbEGSCDdrxYMZtNHjgNNPz
         cSz04MN5afU7riHlu1k19g5naPrPM591MhVPFhhtUNmBRppY/RsitCIfKZDWMWiUtpph
         dlzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+HqP+4pv65tNa2gKmR3/Ufe3GB9e142iVvYjLgWUjzs=;
        b=SBhzgBbsy5LAlq8iTGJ8aG/nMAqj8OE9Lsonn/D4uSHQRHrGHe8ENWh/li6SEd9LlP
         b1cV17C57sv3QNz1Ta/E08i4eyZYUh8LNSQpyEzg4q2QTQ9Br2YZpaXyqjnskTiJVjpv
         eCLGuIducX7NCyaOe752GdtfXXjjbsUhWEoAG1bvoKAxn3G+xr1EAuvTposo5J8I31G0
         ljbbF0GJh956+3sHtlOZY+znTXzqG1US1pWDk1YWcMFyhb4NPiL5qzwVk3ruRq6Ohp8U
         Y1H+ghQwGXtnMLnR7pkYBXcVzhlDlN3joRnE8AUXSGYirTLBnRFWevQmwyENlSCZfXmN
         JQLQ==
X-Gm-Message-State: APjAAAX3LTn0JxQWfug49sGOjPenYADEHcEPZWRb+MOCl4/CniHxyXWw
        HaUVu4kdePADr+/OieRQxLO7zmZxikx+
X-Google-Smtp-Source: APXvYqzKo2keGutY0WAmSicGGy79WlONhp388LEj+kDtrBSYPCwdd+l0xdDVmntBheaVzDOJEev9szmYkbp9
X-Received: by 2002:a63:a511:: with SMTP id n17mr33958608pgf.338.1579113809055;
 Wed, 15 Jan 2020 10:43:29 -0800 (PST)
Date:   Wed, 15 Jan 2020 10:43:02 -0800
In-Reply-To: <20200115184308.162644-1-brianvv@google.com>
Message-Id: <20200115184308.162644-4-brianvv@google.com>
Mime-Version: 1.0
References: <20200115184308.162644-1-brianvv@google.com>
X-Mailer: git-send-email 2.25.0.rc1.283.g88dfdc4193-goog
Subject: [PATCH v5 bpf-next 3/9] bpf: add generic support for update and
 delete batch ops
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

This commit adds generic support for update and delete batch ops that
can be used for almost all the bpf maps. These commands share the same
UAPI attr that lookup and lookup_and_delete batch ops use and the
syscall commands are:

  BPF_MAP_UPDATE_BATCH
  BPF_MAP_DELETE_BATCH

The main difference between update/delete and lookup batch ops is that
for update/delete keys/values must be specified for userspace and
because of that, neither in_batch nor out_batch are used.

Suggested-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Brian Vazquez <brianvv@google.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h      |  10 ++++
 include/uapi/linux/bpf.h |   2 +
 kernel/bpf/syscall.c     | 115 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 127 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 807744ecaa5a1..05466ad6cf1c5 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -46,6 +46,10 @@ struct bpf_map_ops {
 	void *(*map_lookup_elem_sys_only)(struct bpf_map *map, void *key);
 	int (*map_lookup_batch)(struct bpf_map *map, const union bpf_attr *attr,
 				union bpf_attr __user *uattr);
+	int (*map_update_batch)(struct bpf_map *map, const union bpf_attr *attr,
+				union bpf_attr __user *uattr);
+	int (*map_delete_batch)(struct bpf_map *map, const union bpf_attr *attr,
+				union bpf_attr __user *uattr);
 
 	/* funcs callable from userspace and from eBPF programs */
 	void *(*map_lookup_elem)(struct bpf_map *map, void *key);
@@ -987,6 +991,12 @@ void bpf_map_init_from_attr(struct bpf_map *map, union bpf_attr *attr);
 int  generic_map_lookup_batch(struct bpf_map *map,
 			      const union bpf_attr *attr,
 			      union bpf_attr __user *uattr);
+int  generic_map_update_batch(struct bpf_map *map,
+			      const union bpf_attr *attr,
+			      union bpf_attr __user *uattr);
+int  generic_map_delete_batch(struct bpf_map *map,
+			      const union bpf_attr *attr,
+			      union bpf_attr __user *uattr);
 
 extern int sysctl_unprivileged_bpf_disabled;
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 8185f1542daa1..e8df9ca680e0c 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -108,6 +108,8 @@ enum bpf_cmd {
 	BPF_MAP_FREEZE,
 	BPF_BTF_GET_NEXT_ID,
 	BPF_MAP_LOOKUP_BATCH,
+	BPF_MAP_UPDATE_BATCH,
+	BPF_MAP_DELETE_BATCH,
 };
 
 enum bpf_map_type {
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index d604ddbb1afbe..ce8244d1ba99c 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1218,6 +1218,111 @@ static int map_get_next_key(union bpf_attr *attr)
 	return err;
 }
 
+int generic_map_delete_batch(struct bpf_map *map,
+			     const union bpf_attr *attr,
+			     union bpf_attr __user *uattr)
+{
+	void __user *keys = u64_to_user_ptr(attr->batch.keys);
+	u32 cp, max_count;
+	int err = 0;
+	void *key;
+
+	if (attr->batch.elem_flags & ~BPF_F_LOCK)
+		return -EINVAL;
+
+	if ((attr->batch.elem_flags & BPF_F_LOCK) &&
+	    !map_value_has_spin_lock(map)) {
+		return -EINVAL;
+	}
+
+	max_count = attr->batch.count;
+	if (!max_count)
+		return 0;
+
+	for (cp = 0; cp < max_count; cp++) {
+		key = __bpf_copy_key(keys + cp * map->key_size, map->key_size);
+		if (IS_ERR(key)) {
+			err = PTR_ERR(key);
+			break;
+		}
+
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
+	return err;
+}
+
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
+	int err = 0;
+
+	f = fdget(ufd);
+	if (attr->batch.elem_flags & ~BPF_F_LOCK)
+		return -EINVAL;
+
+	if ((attr->batch.elem_flags & BPF_F_LOCK) &&
+	    !map_value_has_spin_lock(map)) {
+		return -EINVAL;
+	}
+
+	value_size = bpf_map_value_size(map);
+
+	max_count = attr->batch.count;
+	if (!max_count)
+		return 0;
+
+	value = kmalloc(value_size, GFP_USER | __GFP_NOWARN);
+	if (!value)
+		return -ENOMEM;
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
+	kfree(key);
+	return err;
+}
+
 #define MAP_LOOKUP_RETRIES 3
 
 int generic_map_lookup_batch(struct bpf_map *map,
@@ -3219,6 +3324,10 @@ static int bpf_map_do_batch(const union bpf_attr *attr,
 
 	if (cmd == BPF_MAP_LOOKUP_BATCH)
 		BPF_DO_BATCH(map->ops->map_lookup_batch);
+	else if (cmd == BPF_MAP_UPDATE_BATCH)
+		BPF_DO_BATCH(map->ops->map_update_batch);
+	else
+		BPF_DO_BATCH(map->ops->map_delete_batch);
 
 err_put:
 	fdput(f);
@@ -3325,6 +3434,12 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 	case BPF_MAP_LOOKUP_BATCH:
 		err = bpf_map_do_batch(&attr, uattr, BPF_MAP_LOOKUP_BATCH);
 		break;
+	case BPF_MAP_UPDATE_BATCH:
+		err = bpf_map_do_batch(&attr, uattr, BPF_MAP_UPDATE_BATCH);
+		break;
+	case BPF_MAP_DELETE_BATCH:
+		err = bpf_map_do_batch(&attr, uattr, BPF_MAP_DELETE_BATCH);
+		break;
 	default:
 		err = -EINVAL;
 		break;
-- 
2.25.0.rc1.283.g88dfdc4193-goog

