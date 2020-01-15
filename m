Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF22013CC50
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 19:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbgAOSnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 13:43:31 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:39099 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729163AbgAOSn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 13:43:27 -0500
Received: by mail-pf1-f202.google.com with SMTP id i196so11455858pfe.6
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 10:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tz5xgOut9x3UI8UwL3xgmMSxaEDJNtFpPyGv6YNxIbw=;
        b=kmyws+otBIE9Ecpup9S5LsbuxRSQr1xp6+I1JzBwg+ja7qTXasp43mzqMiDWgRz3+x
         I+0uIQ6D9L6D2L1vwKKkQOmtWAsQCs2hblHhXCDcPZ7D4supA/jOE/s74vFuhLt5RU5S
         Q0yJ36NRWumr2ZdIKb/pKgQZJ+FltOatZ+CjvZSW/KUxS6V5deD0VwwXADueJXT6s7bo
         eiCyu+ygq0VnlNL/f8LJ9KY9bg42GlCN9ZqUFlExp0QkZO7MQbBu5G2w7M8OaOPqpv58
         8Th1juLdZIPYEe6vIMroHh930VRav6nW7texgAeLu3pzOrzUsTV1Zf818DyY/KFhrTfn
         6DQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tz5xgOut9x3UI8UwL3xgmMSxaEDJNtFpPyGv6YNxIbw=;
        b=oAkZNUMklKl77MWBHtiIayAvVfMBIat7ruf8OjUSo+GRlNk3Nls0fXMEqLyV0WdPER
         RiHSi1jhym6/EwxFVEqJmr6Urd8YSUVRPYtwvGRefBl6/hYJTo9URSfuhgPQXZ7iT4Id
         XTWx1zJOslBboKHIzIwm8pj+7i3igOCS0+WRFUxnDMRy06NNCYLX/tiskmNI3WeQ0bXa
         tB0wBV/I8QFDxtoog7jP0FnAZh+gLqXODgHBZWQ0psF92b5tRdSUjRg/H40GsKbBvk8i
         Sp1MBq7bfzeFeN2TWzIwaUJvjNNmTUm78Qq3UnRgbeXYYO7QD27cegZvxF1n3K+2MjGK
         BOmA==
X-Gm-Message-State: APjAAAVpx5cOKZw7iks9I4T9AO+jw2/s1xBrbLozv486/3Bzfmlwapg7
        LghMjxESTZFCXYm8ZukAJ3OIse/tNxUa
X-Google-Smtp-Source: APXvYqxDDvVwRB34BB0+uLfkMzU6LBD3k4eXsiaEETIErWB8rUFiaIvQT/cUEKHnWq3Eg0rFghVlvCk090Ii
X-Received: by 2002:a65:68d4:: with SMTP id k20mr35174972pgt.142.1579113806532;
 Wed, 15 Jan 2020 10:43:26 -0800 (PST)
Date:   Wed, 15 Jan 2020 10:43:01 -0800
In-Reply-To: <20200115184308.162644-1-brianvv@google.com>
Message-Id: <20200115184308.162644-3-brianvv@google.com>
Mime-Version: 1.0
References: <20200115184308.162644-1-brianvv@google.com>
X-Mailer: git-send-email 2.25.0.rc1.283.g88dfdc4193-goog
Subject: [PATCH v5 bpf-next 2/9] bpf: add generic support for lookup batch op
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

This commit introduces generic support for the bpf_map_lookup_batch.
This implementation can be used by almost all the bpf maps since its core
implementation is relying on the existing map_get_next_key and
map_lookup_elem. The bpf syscall subcommand introduced is:

  BPF_MAP_LOOKUP_BATCH

The UAPI attribute is:

  struct { /* struct used by BPF_MAP_*_BATCH commands */
         __aligned_u64   in_batch;       /* start batch,
                                          * NULL to start from beginning
                                          */
         __aligned_u64   out_batch;      /* output: next start batch */
         __aligned_u64   keys;
         __aligned_u64   values;
         __u32           count;          /* input/output:
                                          * input: # of key/value
                                          * elements
                                          * output: # of filled elements
                                          */
         __u32           map_fd;
         __u64           elem_flags;
         __u64           flags;
  } batch;

in_batch/out_batch are opaque values use to communicate between
user/kernel space, in_batch/out_batch must be of key_size length.

To start iterating from the beginning in_batch must be null,
count is the # of key/value elements to retrieve. Note that the 'keys'
buffer must be a buffer of key_size * count size and the 'values' buffer
must be value_size * count, where value_size must be aligned to 8 bytes
by userspace if it's dealing with percpu maps. 'count' will contain the
number of keys/values successfully retrieved. Note that 'count' is an
input/output variable and it can contain a lower value after a call.

If there's no more entries to retrieve, ENOENT will be returned. If error
is ENOENT, count might be > 0 in case it copied some values but there were
no more entries to retrieve.

Note that if the return code is an error and not -EFAULT,
count indicates the number of elements successfully processed.

Suggested-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Brian Vazquez <brianvv@google.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h      |   5 ++
 include/uapi/linux/bpf.h |  18 +++++
 kernel/bpf/syscall.c     | 160 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 179 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index aed2bc39d72b6..807744ecaa5a1 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -44,6 +44,8 @@ struct bpf_map_ops {
 	int (*map_get_next_key)(struct bpf_map *map, void *key, void *next_key);
 	void (*map_release_uref)(struct bpf_map *map);
 	void *(*map_lookup_elem_sys_only)(struct bpf_map *map, void *key);
+	int (*map_lookup_batch)(struct bpf_map *map, const union bpf_attr *attr,
+				union bpf_attr __user *uattr);
 
 	/* funcs callable from userspace and from eBPF programs */
 	void *(*map_lookup_elem)(struct bpf_map *map, void *key);
@@ -982,6 +984,9 @@ void *bpf_map_area_alloc(u64 size, int numa_node);
 void *bpf_map_area_mmapable_alloc(u64 size, int numa_node);
 void bpf_map_area_free(void *base);
 void bpf_map_init_from_attr(struct bpf_map *map, union bpf_attr *attr);
+int  generic_map_lookup_batch(struct bpf_map *map,
+			      const union bpf_attr *attr,
+			      union bpf_attr __user *uattr);
 
 extern int sysctl_unprivileged_bpf_disabled;
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 52966e758fe59..8185f1542daa1 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -107,6 +107,7 @@ enum bpf_cmd {
 	BPF_MAP_LOOKUP_AND_DELETE_ELEM,
 	BPF_MAP_FREEZE,
 	BPF_BTF_GET_NEXT_ID,
+	BPF_MAP_LOOKUP_BATCH,
 };
 
 enum bpf_map_type {
@@ -420,6 +421,23 @@ union bpf_attr {
 		__u64		flags;
 	};
 
+	struct { /* struct used by BPF_MAP_*_BATCH commands */
+		__aligned_u64	in_batch;	/* start batch,
+						 * NULL to start from beginning
+						 */
+		__aligned_u64	out_batch;	/* output: next start batch */
+		__aligned_u64	keys;
+		__aligned_u64	values;
+		__u32		count;		/* input/output:
+						 * input: # of key/value
+						 * elements
+						 * output: # of filled elements
+						 */
+		__u32		map_fd;
+		__u64		elem_flags;
+		__u64		flags;
+	} batch;
+
 	struct { /* anonymous struct used by BPF_PROG_LOAD command */
 		__u32		prog_type;	/* one of enum bpf_prog_type */
 		__u32		insn_cnt;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 08b0b6e40454b..d604ddbb1afbe 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -219,10 +219,8 @@ static int bpf_map_copy_value(struct bpf_map *map, void *key, void *value,
 	void *ptr;
 	int err;
 
-	if (bpf_map_is_dev_bound(map)) {
-		err =  bpf_map_offload_lookup_elem(map, key, value);
-		return err;
-	}
+	if (bpf_map_is_dev_bound(map))
+		return bpf_map_offload_lookup_elem(map, key, value);
 
 	preempt_disable();
 	this_cpu_inc(bpf_prog_active);
@@ -1220,6 +1218,109 @@ static int map_get_next_key(union bpf_attr *attr)
 	return err;
 }
 
+#define MAP_LOOKUP_RETRIES 3
+
+int generic_map_lookup_batch(struct bpf_map *map,
+				    const union bpf_attr *attr,
+				    union bpf_attr __user *uattr)
+{
+	void __user *uobatch = u64_to_user_ptr(attr->batch.out_batch);
+	void __user *ubatch = u64_to_user_ptr(attr->batch.in_batch);
+	void __user *values = u64_to_user_ptr(attr->batch.values);
+	void __user *keys = u64_to_user_ptr(attr->batch.keys);
+	void *buf, *buf_prevkey, *prev_key, *key, *value;
+	int err, retry = MAP_LOOKUP_RETRIES;
+	u32 value_size, cp, max_count;
+	bool first_key = false;
+
+	if (attr->batch.elem_flags & ~BPF_F_LOCK)
+		return -EINVAL;
+
+	if ((attr->batch.elem_flags & BPF_F_LOCK) &&
+	    !map_value_has_spin_lock(map))
+		return -EINVAL;
+
+	value_size = bpf_map_value_size(map);
+
+	max_count = attr->batch.count;
+	if (!max_count)
+		return 0;
+
+	if (put_user(0, &uattr->batch.count))
+		return -EFAULT;
+
+	buf_prevkey = kmalloc(map->key_size, GFP_USER | __GFP_NOWARN);
+	if (!buf_prevkey)
+		return -ENOMEM;
+
+	buf = kmalloc(map->key_size + value_size, GFP_USER | __GFP_NOWARN);
+	if (!buf) {
+		kvfree(buf_prevkey);
+		return -ENOMEM;
+	}
+
+	err = -EFAULT;
+	first_key = false;
+	prev_key = NULL;
+	if (ubatch && copy_from_user(buf_prevkey, ubatch, map->key_size))
+		goto free_buf;
+	key = buf;
+	value = key + map->key_size;
+	if (ubatch)
+		prev_key = buf_prevkey;
+
+	for (cp = 0; cp < max_count;) {
+		rcu_read_lock();
+		err = map->ops->map_get_next_key(map, prev_key, key);
+		rcu_read_unlock();
+		if (err)
+			break;
+		err = bpf_map_copy_value(map, key, value,
+					 attr->batch.elem_flags);
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
+		if (!prev_key)
+			prev_key = buf_prevkey;
+
+		swap(prev_key, key);
+		retry = MAP_LOOKUP_RETRIES;
+		cp++;
+	}
+
+	if (err == -EFAULT)
+		goto free_buf;
+
+	if ((copy_to_user(&uattr->batch.count, &cp, sizeof(cp)) ||
+		    (cp && copy_to_user(uobatch, prev_key, map->key_size))))
+		err = -EFAULT;
+
+free_buf:
+	kfree(buf_prevkey);
+	kfree(buf);
+	return err;
+}
+
 #define BPF_MAP_LOOKUP_AND_DELETE_ELEM_LAST_FIELD value
 
 static int map_lookup_and_delete_elem(union bpf_attr *attr)
@@ -3076,6 +3177,54 @@ static int bpf_task_fd_query(const union bpf_attr *attr,
 	return err;
 }
 
+#define BPF_MAP_BATCH_LAST_FIELD batch.flags
+
+#define BPF_DO_BATCH(fn)			\
+	do {					\
+		if (!fn) {			\
+			err = -ENOTSUPP;	\
+			goto err_put;		\
+		}				\
+		err = fn(map, attr, uattr);	\
+	} while (0)
+
+static int bpf_map_do_batch(const union bpf_attr *attr,
+			    union bpf_attr __user *uattr,
+			    int cmd)
+{
+	struct bpf_map *map;
+	int err, ufd;
+	struct fd f;
+
+	if (CHECK_ATTR(BPF_MAP_BATCH))
+		return -EINVAL;
+
+	ufd = attr->batch.map_fd;
+	f = fdget(ufd);
+	map = __bpf_map_get(f);
+	if (IS_ERR(map))
+		return PTR_ERR(map);
+
+	if (cmd == BPF_MAP_LOOKUP_BATCH &&
+	    !(map_get_sys_perms(map, f) & FMODE_CAN_READ)) {
+		err = -EPERM;
+		goto err_put;
+	}
+
+	if (cmd != BPF_MAP_LOOKUP_BATCH &&
+	    !(map_get_sys_perms(map, f) & FMODE_CAN_WRITE)) {
+		err = -EPERM;
+		goto err_put;
+	}
+
+	if (cmd == BPF_MAP_LOOKUP_BATCH)
+		BPF_DO_BATCH(map->ops->map_lookup_batch);
+
+err_put:
+	fdput(f);
+	return err;
+}
+
 SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, size)
 {
 	union bpf_attr attr = {};
@@ -3173,6 +3322,9 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 	case BPF_MAP_LOOKUP_AND_DELETE_ELEM:
 		err = map_lookup_and_delete_elem(&attr);
 		break;
+	case BPF_MAP_LOOKUP_BATCH:
+		err = bpf_map_do_batch(&attr, uattr, BPF_MAP_LOOKUP_BATCH);
+		break;
 	default:
 		err = -EINVAL;
 		break;
-- 
2.25.0.rc1.283.g88dfdc4193-goog

