Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C39CC11BFF4
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 23:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbfLKWeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 17:34:24 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:34983 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726824AbfLKWeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 17:34:23 -0500
Received: by mail-pf1-f202.google.com with SMTP id r2so46640pfl.2
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 14:34:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rC4tOR/kyk4ZUKAZPKvyfm3r2gY5Mo2Zi+lINXPmnEk=;
        b=QH6Y79uzDJFjMEBU4pIPFpxWInfJ6MmN1WVAWvmffKlNMbRS+eOKJaxlgG+iG2kwYj
         7FsOE7nMHjnA2gbsIcPvnc39QlufrmU4X0jyLD+zCmruy/ItG0BuDLLet28j+K0pgIOn
         BtR0u+KHflzio54Kp//TN6EasCNzzX8SNpEJeJ8YVMC/irF4zY5TapiahabeCXsYyaOh
         SvdCvuPkhkLsb3rXlImJz/tDXUXuRR33EzdD81Vhv8XvPWKy3ShxseVxnrFDdFcqwgfJ
         YadJjFJurnsYcwgwct+9fxtPvnTcfx9m3vNvAZe3gtgoz4JtT1+WRdi9jtEwp0saDjeU
         64kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rC4tOR/kyk4ZUKAZPKvyfm3r2gY5Mo2Zi+lINXPmnEk=;
        b=Q8tHCY8s3JWqZY8C9Fvfx3OMgEyv+j1LeUNyaUewCV/CkUK2cElr55PU61WToP4L8E
         rDUvU8EJeXOrshuR9JwfqxawFaINCc9NwgX8wGS5A6cFSq0QXyBuHoNL8/rgVsPjRKLA
         jOwb8lP6sLrwTph+wvz62cketSnsHqIY6IsxbgqNETgLnl4GmLn98P5CAf0ZEsNnW+m2
         3T6vviUn5NXxE08HDWYL6kI6geEMTTFFcL/rc/SQXRiJ0xCOtdbZCdu+U44n8C4+lSyk
         2P5NqJRAPROkqR91z8sMQJqs09MvLCoXHFb7bI60KL1OQ0JeJ2abBQMRH+kpeg8fmBlO
         0PBQ==
X-Gm-Message-State: APjAAAXTVIMGNKUz1TVZIcnhPCSXEFH9dSQEMIKk6J8xoNvcliZ9ow8I
        jASANw7xjuDL2zejREnXKCKPCreMcDvv
X-Google-Smtp-Source: APXvYqyhTi5l47eqFaFESWam56zAf22qT8vlJBx2CG2GmUyBNo1O5XvbDh2mPa3WijP8neWyEC3F6DqQTtiJ
X-Received: by 2002:a63:5b0e:: with SMTP id p14mr7046671pgb.315.1576103662226;
 Wed, 11 Dec 2019 14:34:22 -0800 (PST)
Date:   Wed, 11 Dec 2019 14:33:35 -0800
In-Reply-To: <20191211223344.165549-1-brianvv@google.com>
Message-Id: <20191211223344.165549-3-brianvv@google.com>
Mime-Version: 1.0
References: <20191211223344.165549-1-brianvv@google.com>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH v3 bpf-next 02/11] bpf: add generic support for lookup and
 lookup_and_delete batch ops
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

This commit introduces generic support for the bpf_map_lookup_batch and
bpf_map_lookup_and_delete_batch ops. This implementation can be used by
almost all the bpf maps since its core implementation is relying on the
existing map_get_next_key, map_lookup_elem and map_delete_elem
functions. The bpf syscall subcommands introduced are:

  BPF_MAP_LOOKUP_BATCH
  BPF_MAP_LOOKUP_AND_DELETE_BATCH

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
 include/linux/bpf.h      |  11 +++
 include/uapi/linux/bpf.h |  19 +++++
 kernel/bpf/syscall.c     | 172 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 202 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 35903f148be59..a16f209255a59 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -43,6 +43,11 @@ struct bpf_map_ops {
 	int (*map_get_next_key)(struct bpf_map *map, void *key, void *next_key);
 	void (*map_release_uref)(struct bpf_map *map);
 	void *(*map_lookup_elem_sys_only)(struct bpf_map *map, void *key);
+	int (*map_lookup_batch)(struct bpf_map *map, const union bpf_attr *attr,
+				union bpf_attr __user *uattr);
+	int (*map_lookup_and_delete_batch)(struct bpf_map *map,
+					   const union bpf_attr *attr,
+					   union bpf_attr __user *uattr);
 
 	/* funcs callable from userspace and from eBPF programs */
 	void *(*map_lookup_elem)(struct bpf_map *map, void *key);
@@ -838,6 +843,12 @@ void *bpf_map_area_alloc(u64 size, int numa_node);
 void *bpf_map_area_mmapable_alloc(u64 size, int numa_node);
 void bpf_map_area_free(void *base);
 void bpf_map_init_from_attr(struct bpf_map *map, union bpf_attr *attr);
+int  generic_map_lookup_batch(struct bpf_map *map,
+			      const union bpf_attr *attr,
+			      union bpf_attr __user *uattr);
+int  generic_map_lookup_and_delete_batch(struct bpf_map *map,
+					 const union bpf_attr *attr,
+					 union bpf_attr __user *uattr);
 
 extern int sysctl_unprivileged_bpf_disabled;
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index dbbcf0b02970b..36d3b885ddedd 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -107,6 +107,8 @@ enum bpf_cmd {
 	BPF_MAP_LOOKUP_AND_DELETE_ELEM,
 	BPF_MAP_FREEZE,
 	BPF_BTF_GET_NEXT_ID,
+	BPF_MAP_LOOKUP_BATCH,
+	BPF_MAP_LOOKUP_AND_DELETE_BATCH,
 };
 
 enum bpf_map_type {
@@ -403,6 +405,23 @@ union bpf_attr {
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
index 2530266fa6477..708aa89fe2308 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1206,6 +1206,120 @@ static int map_get_next_key(union bpf_attr *attr)
 	return err;
 }
 
+#define MAP_LOOKUP_RETRIES 3
+
+static int __generic_map_lookup_batch(struct bpf_map *map,
+				      const union bpf_attr *attr,
+				      union bpf_attr __user *uattr,
+				      bool do_delete)
+{
+	void __user *ubatch = u64_to_user_ptr(attr->batch.in_batch);
+	void __user *uobatch = u64_to_user_ptr(attr->batch.out_batch);
+	void __user *values = u64_to_user_ptr(attr->batch.values);
+	void __user *keys = u64_to_user_ptr(attr->batch.keys);
+	void *buf, *prev_key, *key, *value;
+	u32 value_size, cp, max_count;
+	bool first_key = false;
+	int err, retry = MAP_LOOKUP_RETRIES;
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
+	buf = kmalloc(map->key_size + value_size, GFP_USER | __GFP_NOWARN);
+	if (!buf)
+		return -ENOMEM;
+
+	err = -EFAULT;
+	first_key = false;
+	if (ubatch && copy_from_user(buf, ubatch, map->key_size))
+		goto free_buf;
+	key = buf;
+	value = key + map->key_size;
+	if (!ubatch) {
+		prev_key = NULL;
+		first_key = true;
+	}
+
+	for (cp = 0; cp < max_count;) {
+		if (cp || first_key) {
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
+		retry = MAP_LOOKUP_RETRIES;
+		cp++;
+	}
+
+	if (!err) {
+		rcu_read_lock();
+		err = map->ops->map_get_next_key(map, prev_key, key);
+		rcu_read_unlock();
+	}
+
+	if (err)
+		memset(key, 0, map->key_size);
+
+	if ((copy_to_user(&uattr->batch.count, &cp, sizeof(cp)) ||
+		    (copy_to_user(uobatch, key, map->key_size))))
+		err = -EFAULT;
+
+free_buf:
+	kfree(buf);
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
@@ -3046,6 +3160,57 @@ static int bpf_task_fd_query(const union bpf_attr *attr,
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
+	if ((cmd == BPF_MAP_LOOKUP_BATCH ||
+	     cmd == BPF_MAP_LOOKUP_AND_DELETE_BATCH) &&
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
+	else
+		BPF_DO_BATCH(map->ops->map_lookup_and_delete_batch);
+
+err_put:
+	fdput(f);
+	return err;
+}
+
 SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, size)
 {
 	union bpf_attr attr = {};
@@ -3143,6 +3308,13 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 	case BPF_MAP_LOOKUP_AND_DELETE_ELEM:
 		err = map_lookup_and_delete_elem(&attr);
 		break;
+	case BPF_MAP_LOOKUP_BATCH:
+		err = bpf_map_do_batch(&attr, uattr, BPF_MAP_LOOKUP_BATCH);
+		break;
+	case BPF_MAP_LOOKUP_AND_DELETE_BATCH:
+		err = bpf_map_do_batch(&attr, uattr,
+				       BPF_MAP_LOOKUP_AND_DELETE_BATCH);
+		break;
 	default:
 		err = -EINVAL;
 		break;
-- 
2.24.1.735.g03f4e72817-goog

