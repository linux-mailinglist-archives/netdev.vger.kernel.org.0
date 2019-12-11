Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC17311BFD7
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 23:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfLKWe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 17:34:28 -0500
Received: from mail-yb1-f202.google.com ([209.85.219.202]:35904 "EHLO
        mail-yb1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbfLKWe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 17:34:27 -0500
Received: by mail-yb1-f202.google.com with SMTP id 132so255651ybd.3
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 14:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZD1OM8PwYuxCvRtnkK5reLXP+XBkL7o2/oXUFKCCwtM=;
        b=rF4pZ8JhbNxXPvh3c5QWREgSO25foZMcyh9eAgJXHr1nEM+H7MyKf88S1vclj953OP
         3HO+jnP5arAXT2srzJnfyciJ4SJrmzCJRGn95JL+TykBNCL2VWOxp45zOsTZN8JeEkKf
         M9NYBlbcz+PXEtC8GKEC3eFELK6DrISScn+zfv5D0oacqKxM7UpV73ga+6Q3VXmnoEo4
         k8s7v5x2z8r8pxxSbfy3mZ/124dcVgG/RvoE/lzWiFgC0mu77eqhoWAfTWyVyTfhFySo
         KjUQdKpjfpGj/qNnJI4Ja1DK//TjipFy2YpNKw7kyVS+iv6kwUyhY5nbaIuQo1ghKC12
         FxIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZD1OM8PwYuxCvRtnkK5reLXP+XBkL7o2/oXUFKCCwtM=;
        b=NIRFQ9uHSAn5WDDB+idSSmRrtVUml8DgGmL8zlyDY5I6Xy6u+fi1fmszhSmK2nfbZ+
         SUvJK6P29EJ766TZx7Wr7up4gyMqbjZyDR6iuQc6yo0AiBtMq7o2KjsDmk+0asK5egWl
         wF9F/s46qmaoMCaH0++bWmuMzM6TRNhuTZ4X0bF2os7aLRPGZQLs8Zcl6xCNo2Y88Z6l
         bBj/qx0EM6NoyrfSRSjPU/s1j9FaiBukJVHl/ZjD3hh6xU7JvW5LVlRMzl5XgTgo8v18
         nVTWjJ+zWDYp8doijiw5XZu+zEKnYuklzXJIlx7shB8EZCwgE1KZIO2mI3/K4bSdsxLY
         HaXA==
X-Gm-Message-State: APjAAAWsYVT1Va4oUXSgEwoOevLzE/7Lv2g5P1he6juBdYHj+lGiFVcg
        384jabp/c8/lXnDdbAwgv7cerBOEvyYL
X-Google-Smtp-Source: APXvYqzYGWbHouH3DlBkE5VQgFjLUgXyujsw2IiKv/M9K2wAcv0H53Odx0b7CWRsKRNzCUvPTKV12D+pdPge
X-Received: by 2002:a81:6b88:: with SMTP id g130mr1788465ywc.404.1576103665894;
 Wed, 11 Dec 2019 14:34:25 -0800 (PST)
Date:   Wed, 11 Dec 2019 14:33:36 -0800
In-Reply-To: <20191211223344.165549-1-brianvv@google.com>
Message-Id: <20191211223344.165549-4-brianvv@google.com>
Mime-Version: 1.0
References: <20191211223344.165549-1-brianvv@google.com>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH v3 bpf-next 03/11] bpf: add generic support for update and
 delete batch ops
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

This commit adds generic support for update and delete batch ops that
can be used for almost all the bpf maps. These commands share the same
UAPI attr that lookup and lookup_and_delete batch ops use and the
syscall commands are:

  BPF_MAP_UPDATE_BATCH
  BPF_MAP_DELETE_BATCH

The main difference between update/delete and lookup/lookup_and_delete
batch ops is that for update/delete keys/values must be specified for
userspace and because of that, neither in_batch nor out_batch are used.

Suggested-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Brian Vazquez <brianvv@google.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h      |  10 ++++
 include/uapi/linux/bpf.h |   2 +
 kernel/bpf/syscall.c     | 117 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 128 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index a16f209255a59..851fb3ff084b0 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -48,6 +48,10 @@ struct bpf_map_ops {
 	int (*map_lookup_and_delete_batch)(struct bpf_map *map,
 					   const union bpf_attr *attr,
 					   union bpf_attr __user *uattr);
+	int (*map_update_batch)(struct bpf_map *map, const union bpf_attr *attr,
+				union bpf_attr __user *uattr);
+	int (*map_delete_batch)(struct bpf_map *map, const union bpf_attr *attr,
+				union bpf_attr __user *uattr);
 
 	/* funcs callable from userspace and from eBPF programs */
 	void *(*map_lookup_elem)(struct bpf_map *map, void *key);
@@ -849,6 +853,12 @@ int  generic_map_lookup_batch(struct bpf_map *map,
 int  generic_map_lookup_and_delete_batch(struct bpf_map *map,
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
index 36d3b885ddedd..dab24a763e4bb 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -109,6 +109,8 @@ enum bpf_cmd {
 	BPF_BTF_GET_NEXT_ID,
 	BPF_MAP_LOOKUP_BATCH,
 	BPF_MAP_LOOKUP_AND_DELETE_BATCH,
+	BPF_MAP_UPDATE_BATCH,
+	BPF_MAP_DELETE_BATCH,
 };
 
 enum bpf_map_type {
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 708aa89fe2308..8272e76183068 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1206,6 +1206,111 @@ static int map_get_next_key(union bpf_attr *attr)
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
+		return -EINVAL;
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
 
 static int __generic_map_lookup_batch(struct bpf_map *map,
@@ -3203,8 +3308,12 @@ static int bpf_map_do_batch(const union bpf_attr *attr,
 
 	if (cmd == BPF_MAP_LOOKUP_BATCH)
 		BPF_DO_BATCH(map->ops->map_lookup_batch);
-	else
+	else if (cmd == BPF_MAP_LOOKUP_AND_DELETE_BATCH)
 		BPF_DO_BATCH(map->ops->map_lookup_and_delete_batch);
+	else if (cmd == BPF_MAP_UPDATE_BATCH)
+		BPF_DO_BATCH(map->ops->map_update_batch);
+	else
+		BPF_DO_BATCH(map->ops->map_delete_batch);
 
 err_put:
 	fdput(f);
@@ -3315,6 +3424,12 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 		err = bpf_map_do_batch(&attr, uattr,
 				       BPF_MAP_LOOKUP_AND_DELETE_BATCH);
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
2.24.1.735.g03f4e72817-goog

