Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 738B9A1202
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 08:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbfH2GpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 02:45:17 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:2906 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727400AbfH2GpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 02:45:14 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7T6cKQv025157
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 23:45:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=wa4XPtxGVIBQXk7QNKNEdDoZCqTh5EoO2jCKZ7oXdoQ=;
 b=oUIpTTpE0gNHlplvkwovQZy5/R2HF85SIcUpNGWBQuQH/3laLN//HXApibeqT4i4vZfN
 xi5O5/zXqhRfyYbcuoy4xLzIgTI/N41pewUfKbaktlrPvF353ZcbfRnRmNqz30fs/BqS
 eaVDI1aR6H2XdklzQGCz+QfyjfqovTRiRlA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2untb0m1a6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 23:45:11 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 28 Aug 2019 23:45:10 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id D33B33702BA3; Wed, 28 Aug 2019 23:45:07 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Brian Vazquez <brianvv@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Yonghong Song <yhs@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 05/13] bpf: adding map batch processing support
Date:   Wed, 28 Aug 2019 23:45:07 -0700
Message-ID: <20190829064507.2750795-1-yhs@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190829064502.2750303-1-yhs@fb.com>
References: <20190829064502.2750303-1-yhs@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-29_04:2019-08-28,2019-08-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 phishscore=0 bulkscore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1906280000 definitions=main-1908290072
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Brian Vazquez has proposed BPF_MAP_DUMP command to look up more than one
map entries per syscall.
  https://lore.kernel.org/bpf/CABCgpaU3xxX6CMMxD+1knApivtc2jLBHysDXw-0E9bQEL0qC3A@mail.gmail.com/T/#t

During discussion, we found more use cases can be supported in a similar
map operation batching framework. For example, batched map lookup and delete,
which can be really helpful for bcc.
  https://github.com/iovisor/bcc/blob/master/tools/tcptop.py#L233-L243
  https://github.com/iovisor/bcc/blob/master/tools/slabratetop.py#L129-L138

Also, in bcc, we have API to delete all entries in a map.
  https://github.com/iovisor/bcc/blob/master/src/cc/api/BPFTable.h#L257-L264

For map update, batched operations also useful as sometimes applications need
to populate initial maps with more than one entry. For example, the below
example is from kernel/samples/bpf/xdp_redirect_cpu_user.c:
  https://github.com/torvalds/linux/blob/master/samples/bpf/xdp_redirect_cpu_user.c#L543-L550

This patch addresses all the above use cases. To make uapi stable, it also
covers other potential use cases. Four bpf syscall subcommands are introduced:
	BPF_MAP_LOOKUP_BATCH
	BPF_MAP_LOOKUP_AND_DELETE_BATCH
	BPF_MAP_UPDATE_BATCH
	BPF_MAP_DELETE_BATCH

The UAPI attribute structure looks like:
	struct { /* struct used by BPF_MAP_*_BATCH commands */
		__aligned_u64   start_key;      /* input: storing start key,
						 * if NULL, starting from the beginning.
						 */
		__aligned_u64   next_start_key; /* output: storing next batch start_key,
						 * if NULL, no next key.
						 */
		__aligned_u64	keys;		/* input/output: key buffer */
		__aligned_u64	values;		/* input/output: value buffer */
		__u32		count;		/* input: # of keys/values in
						 *   or fits in keys[]/values[].
						 * output: how many successful
						 *   lookup/lookup_and_delete
						 *   /delete/update operations.
						 */
		__u32		map_fd;
		__u64		elem_flags;	/* BPF_MAP_{UPDATE,LOOKUP}_ELEM flags */
		__u64		flags;		/* flags for batch operation */
	} batch;

The 'start_key' and 'next_start_key' are used to BPF_MAP_LOOKUP_BATCH,
BPF_MAP_LOOKUP_AND_DELETE_BATCH and BPF_MAP_DELETE_BATCH
to start the operation on 'start_key' and also set the
next batch start key in 'next_start_key'.

If 'count' is greater than 0 and the return code is 0,
  . the 'count' may be updated to be smaller if there is less
    elements than 'count' for the operation. In such cases,
    'next_start_key' will be set to NULL.
  . the 'count' remains the same. 'next_start_key' could be NULL
    or could point to next start_key for batch processing.

If 'count' is greater than 0 and the return code is an error
other than -EFAULT, the kernel will try to overwrite 'count'
to contain the number of successful element-level (lookup,
lookup_and_delete, update and delete) operations. The following
attributes can be checked:
  . if 'count' value is modified, the new value will be
    the number of successful element-level operations.
  . if 'count' value is modified, the keys[]/values[] will
    contain correct results for new 'count' number of
    operations for lookup[_and_delete] and update.

The implementation in this patch mimics what user space
did, e.g., for lookup_and_delete,
    while(bpf_get_next_key(map, keyp, next_keyp) == 0) {
       bpf_map_delete_elem(map, keyp);
       bpf_map_lookup_elem(map, next_keyp, &value, flags);
       keyp, next_keyp = next_keyp, keyp;
    }
The similar loop is implemented in the kernel, and
each operation, bpf_get_next_key(), bpf_map_delete_elem()
and bpf_map_lookup_elem(), uses existing kernel functions
each of which has its own rcu_read_lock region, bpf_prog_active
protection, etc.
Therefore, it is totally possible that after bpf_get_next_key(),
the bpf_map_delete_elem() or bpf_map_lookup_elem() may fail
as the key may be deleted concurrently by kernel or
other user space processes/threads.
By default, the current implementation permits the loop
to continue, just like typical user space handling. But
a flag, BPF_F_ENFORCE_ENOENT, can be specified, so kernel
will return an error if bpf_map_delete_elem() or
bpf_map_lookup_elem() failed.

The high-level algorithm for BPF_MAP_LOOKUP_BATCH and
BPF_MAP_LOOKUP_AND_DELETE_BATCH:
	if (start_key == NULL and next_start_key == NULL) {
		lookup up to 'count' keys in keys[] and fill
		corresponding values[], and delete those
		keys if BPF_MAP_LOOKUP_AND_DELETE_BATCH.
	} else if (start_key == NULL && next_start_key != NULL) {
		lookup up to 'count' keys from the beginning
		of the map and fill keys[]/values[], delete
		those keys if BPF_MAP_LOOKUP_AND_DELETE_BATCH.
		Set 'next_start_key' for next batch operation.
	} else if (start_key != NULL && next_start_key != NULL) {
		lookup to 'count' keys from 'start_key', inclusive,
		and fill keys[]/values[], delete those keys if
		BPF_MAP_LOOKUP_AND_DELETE_BATCH.
		Set 'next_start_key' for next batch operation.
	}

The high-level algorithm for BPF_MAP_UPDATE_BATCH:
	if (count != 0) {
		do 'count' number of updates on keys[]/values[].
	}

The high-level algorithm for BPF_MAP_DELETE_BATCH:
	if (count == 0) {
		if (start_key == NULL) {
			delete all elements from map.
		} else {
			delete all elements from start_key to the end of map.
		}
	} else {
		if (start_key == NULL and next_start_key == NULL) {
			delete 'count' number of keys in keys[].
		} else if (start_key == NULL and next_start_key != NULL) {
			delete 'count' number of keys from the
			beginning of the map and set 'next_start_key'
			properly.
		} else if (start_key != NULL and next_start_keeey != NULL) {
			delete 'count' number of keys from 'start_key',
			and set 'next_start_key' properly.
		}
	}

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/uapi/linux/bpf.h |  27 +++
 kernel/bpf/syscall.c     | 448 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 475 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 5d2fb183ee2d..576688f13e8c 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -107,6 +107,10 @@ enum bpf_cmd {
 	BPF_MAP_LOOKUP_AND_DELETE_ELEM,
 	BPF_MAP_FREEZE,
 	BPF_BTF_GET_NEXT_ID,
+	BPF_MAP_LOOKUP_BATCH,
+	BPF_MAP_LOOKUP_AND_DELETE_BATCH,
+	BPF_MAP_UPDATE_BATCH,
+	BPF_MAP_DELETE_BATCH,
 };
 
 enum bpf_map_type {
@@ -347,6 +351,9 @@ enum bpf_attach_type {
 /* flags for BPF_PROG_QUERY */
 #define BPF_F_QUERY_EFFECTIVE	(1U << 0)
 
+/* flags for BPF_MAP_*_BATCH */
+#define BPF_F_ENFORCE_ENOENT	(1U << 0)
+
 enum bpf_stack_build_id_status {
 	/* user space need an empty entry to identify end of a trace */
 	BPF_STACK_BUILD_ID_EMPTY = 0,
@@ -396,6 +403,26 @@ union bpf_attr {
 		__u64		flags;
 	};
 
+	struct { /* struct used by BPF_MAP_*_BATCH commands */
+		__aligned_u64	start_key;	/* input: storing start key,
+						 * if NULL, starting from the beginning.
+						 */
+		__aligned_u64	next_start_key;	/* output: storing next batch start_key,
+						 * if NULL, no next key.
+						 */
+		__aligned_u64	keys;		/* input/output: key buffer */
+		__aligned_u64	values;		/* input/output: value buffer */
+		__u32		count;		/* input: # of keys/values in
+						 *   or fits in keys[]/values[].
+						 * output: how many successful
+						 *   lookup/lookup_and_delete
+						 *   update/delete operations.
+						 */
+		__u32		map_fd;
+		__u64		elem_flags;	/* BPF_MAP_*_ELEM flags */
+		__u64		flags;		/* flags for batch operation */
+	} batch;
+
 	struct { /* anonymous struct used by BPF_PROG_LOAD command */
 		__u32		prog_type;	/* one of enum bpf_prog_type */
 		__u32		insn_cnt;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 06308f0206e5..8746b55405f9 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -33,6 +33,17 @@
 
 #define BPF_OBJ_FLAG_MASK   (BPF_F_RDONLY | BPF_F_WRONLY)
 
+#define BPF_MAP_BATCH_SWAP_KEYS(key1, key2, buf1, buf2)	\
+	do {						\
+		if (key1 == (buf1)) {			\
+			key1 = buf2;			\
+			key2 = buf1;			\
+		} else {				\
+			key1 = buf1;			\
+			key2 = buf2;			\
+		}					\
+	} while (0)					\
+
 DEFINE_PER_CPU(int, bpf_prog_active);
 static DEFINE_IDR(prog_idr);
 static DEFINE_SPINLOCK(prog_idr_lock);
@@ -1183,6 +1194,431 @@ static int map_lookup_and_delete_elem(union bpf_attr *attr)
 	return err;
 }
 
+static void __map_batch_get_attrs(const union bpf_attr *attr,
+				  void __user **skey, void __user **nskey,
+				  void __user **keys, void __user **values,
+				  u32 *max_count, u64 *elem_flags, u64 *flags)
+{
+	*skey = u64_to_user_ptr(attr->batch.start_key);
+	*nskey = u64_to_user_ptr(attr->batch.next_start_key);
+	*keys = u64_to_user_ptr(attr->batch.keys);
+	*values = u64_to_user_ptr(attr->batch.values);
+	*max_count = attr->batch.count;
+	*elem_flags = attr->batch.elem_flags;
+	*flags = attr->batch.flags;
+}
+
+static int
+__map_lookup_delete_batch_key_in_keys(struct bpf_map *map, void *key, void *value,
+				      u32 max_count, u32 key_size, u32 value_size,
+				      u64 elem_flags, void __user *keys,
+				      void __user *values,
+				      union bpf_attr __user *uattr,
+				      bool ignore_enoent)
+{
+	u32 count, missed = 0;
+	int ret = 0, err;
+
+	for (count = 0; count < max_count; count++) {
+		if (copy_from_user(key, keys + count * key_size, key_size)) {
+			ret = -EFAULT;
+			break;
+		}
+
+		ret = bpf_map_copy_value(map, key, value, elem_flags);
+		if (ret) {
+			if (ret != -ENOENT || !ignore_enoent)
+				break;
+
+			missed++;
+			continue;
+		}
+
+
+		if (copy_to_user(values + count * value_size, value, value_size)) {
+			ret = -EFAULT;
+			break;
+		}
+
+		ret = bpf_map_delete_elem(map, key);
+		if (ret) {
+			if (ret != -ENOENT || !ignore_enoent)
+				break;
+
+			missed++;
+		}
+	}
+
+	count -= missed;
+	if ((!ret && missed) || (ret && ret != -EFAULT)) {
+		err = put_user(count, &uattr->batch.count);
+		ret = err ? : ret;
+	}
+
+	return ret;
+}
+
+static int map_lookup_and_delete_batch(struct bpf_map *map,
+				       const union bpf_attr *attr,
+				       union bpf_attr __user *uattr,
+				       bool do_delete)
+{
+	u32 max_count, count = 0, key_size, roundup_key_size, value_size;
+	bool ignore_enoent, nextkey_is_null, copied;
+	void *buf = NULL, *key, *value, *next_key;
+	void __user *skey, *nskey, *keys, *values;
+	u64 elem_flags, flags, zero = 0;
+	int err, ret = 0;
+
+	if (map->map_type == BPF_MAP_TYPE_QUEUE ||
+	    map->map_type == BPF_MAP_TYPE_STACK)
+		return -ENOTSUPP;
+
+	__map_batch_get_attrs(attr, &skey, &nskey, &keys, &values, &max_count,
+			      &elem_flags, &flags);
+
+	if (elem_flags & ~BPF_F_LOCK || flags & ~BPF_F_ENFORCE_ENOENT)
+		return -EINVAL;
+
+	if (!max_count)
+		return 0;
+
+	/* The following max_count/skey/nskey combinations are supported:
+	 * max_count != 0 && !skey && !nskey: loop/delete max_count elements in keys[]/values[].
+	 * max_count != 0 && !skey && nskey: loop/delete max_count elements starting from map start.
+	 * max_count != 0 && skey && nskey: loop/delete max_count elements starting from skey.
+	 */
+	if (skey && !nskey)
+		return -EINVAL;
+
+	/* allocate space for two keys and one value. */
+	key_size = map->key_size;
+	roundup_key_size = round_up(map->key_size, 8);
+	value_size = bpf_map_value_size(map);
+	buf = kmalloc(roundup_key_size * 2 + value_size, GFP_USER | __GFP_NOWARN);
+	if (!buf)
+		return -ENOMEM;
+
+	key = buf;
+	next_key = buf + roundup_key_size;
+	value = buf + roundup_key_size * 2;
+	ignore_enoent = !(flags & BPF_F_ENFORCE_ENOENT);
+
+	if (!skey && !nskey) {
+		/* handle cases where keys in keys[] */
+		ret = __map_lookup_delete_batch_key_in_keys(map, key, value, max_count,
+							    key_size, value_size,
+							    elem_flags, keys, values,
+							    uattr, ignore_enoent);
+		goto out;
+	}
+
+	/* Get the first key. */
+	if (!skey) {
+		ret = bpf_map_get_next_key(map, NULL, key);
+		if (ret) {
+			nextkey_is_null = true;
+			goto after_loop;
+		}
+	} else if (copy_from_user(key, skey, key_size)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	/* Copy the first key/value pair */
+	ret = bpf_map_copy_value(map, key, value, elem_flags);
+	if (ret) {
+		if (skey)
+			goto out;
+
+		nextkey_is_null = true;
+		goto after_loop;
+	}
+
+	if (copy_to_user(keys, key, key_size) ||
+	    copy_to_user(values, value, value_size)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	/* We will always try to get next_key first
+	 * and then delete the current key.
+	 */
+	ret = bpf_map_get_next_key(map, key, next_key);
+	count = 0;
+	nextkey_is_null = false;
+	copied = true;
+
+again:
+	/* delete key */
+	if (do_delete) {
+		err = bpf_map_delete_elem(map, key);
+		if (err && (err != -ENOENT || !ignore_enoent)) {
+			/* failed to delete "key".
+			 * lookup_delete will considered failed.
+			 */
+			ret = err;
+			goto after_loop;
+		}
+	}
+
+	/* deletion in lookup_and_delete is successful. */
+	/* check bpf_map_get_next_key() result. */
+	count += !!copied;
+	nextkey_is_null = ret && ret == -ENOENT;
+	if (ret || count >= max_count)
+		goto after_loop;
+
+	/* copy value corresponding to next_key */
+	ret = bpf_map_copy_value(map, next_key, value, elem_flags);
+	copied = true;
+	if (ret) {
+		copied = false;
+		if (ret != -ENOENT || !ignore_enoent)
+			goto after_loop;
+	} else {
+		if (copy_to_user(keys + count * key_size, next_key, key_size) ||
+		    copy_to_user(values + count * value_size, value, value_size)) {
+			ret = -EFAULT;
+			goto after_loop;
+		}
+	}
+
+	BPF_MAP_BATCH_SWAP_KEYS(key, next_key, buf, buf + roundup_key_size);
+	ret = bpf_map_get_next_key(map, key, next_key);
+	goto again;
+
+after_loop:
+	if (!ret) {
+		if (put_user(count, &uattr->batch.count) ||
+		    copy_to_user(nskey, next_key, key_size))
+			ret = -EFAULT;
+	} else if (nextkey_is_null) {
+		ret = 0;
+		if (put_user(count, &uattr->batch.count) ||
+                    copy_to_user(&uattr->batch.next_start_key, &zero, sizeof(u64)))
+			ret = -EFAULT;
+	} else if (ret != -EFAULT) {
+		if (put_user(count, &uattr->batch.count))
+			ret = -EFAULT;
+	}
+
+out:
+	kfree(buf);
+	return ret;
+}
+
+static int map_update_batch(struct bpf_map *map,
+			    const union bpf_attr *attr,
+			    union bpf_attr __user *uattr,
+			    struct fd *f)
+{
+	u32 max_count, count, missed, key_size, roundup_key_size, value_size;
+	void __user *skey, *nskey, *keys, *values;
+	void *buf = NULL, *key, *value;
+	u64 elem_flags, flags;
+	bool ignore_enoent;
+	int ret, err;
+
+	__map_batch_get_attrs(attr, &skey, &nskey, &keys, &values, &max_count,
+			      &elem_flags, &flags);
+
+	if (flags & ~BPF_F_ENFORCE_ENOENT)
+		return -EINVAL;
+
+	if (!max_count)
+		return 0;
+
+	/* The following max_count/skey/nskey combinations are supported:
+	 * max_count != 0 && !skey && !nskey: update max_count elements in keys[]/values[].
+	 */
+	if (nskey || skey)
+		return -EINVAL;
+
+	if ((elem_flags & BPF_F_LOCK) && !map_value_has_spin_lock(map))
+		return -EINVAL;
+
+	key_size = map->key_size;
+	roundup_key_size = round_up(key_size, 8);
+	value_size = bpf_map_value_size(map);
+	buf = kmalloc(roundup_key_size + value_size, GFP_USER | __GFP_NOWARN);
+	if (!buf)
+		return -ENOMEM;
+
+	key = buf;
+	value = buf + roundup_key_size;
+	ignore_enoent = !(flags & BPF_F_ENFORCE_ENOENT);
+
+	missed = 0;
+	for (count = 0; count < max_count; count++) {
+		if (copy_from_user(key, keys + count * key_size, key_size) ||
+		    copy_from_user(value, values + count * value_size, value_size)) {
+			ret = -EFAULT;
+			break;
+		}
+
+		ret = bpf_map_update_elem(map, key, value, f, elem_flags);
+		if (ret && (ret != -ENOENT || !ignore_enoent))
+			break;
+
+		missed += !!ret;
+		ret = 0;
+	}
+	count -= missed;
+	if ((!ret && missed) || (ret && ret != -EFAULT)) {
+		err = put_user(count, &uattr->batch.count);
+		// Reset the error code if the above put_user failed.
+		ret = err ? : ret;
+	}
+
+	kfree(buf);
+	return ret;
+}
+
+static int map_delete_batch(struct bpf_map *map,
+			    const union bpf_attr *attr,
+			    union bpf_attr __user *uattr)
+{
+	u32 max_count, count, key_size, roundup_key_size;
+	void __user *skey, *nskey, *keys, *values;
+	bool ignore_enoent, nextkey_is_null;
+	void *buf = NULL, *key, *next_key;
+	u64 elem_flags, flags, zero = 0;
+	int ret, err;
+
+	__map_batch_get_attrs(attr, &skey, &nskey, &keys, &values, &max_count,
+			      &elem_flags, &flags);
+
+	if (elem_flags || flags & ~BPF_F_ENFORCE_ENOENT)
+		return -EINVAL;
+
+	/* The following max_count/skey/nskey combinations are supported:
+	 * max_count == 0 && !skey && !nskey: delete all elements in the map
+	 * max_count == 0 && skey && !nskey: delete all elements starting from skey.
+	 * max_count != 0 && !skey && nskey: delete max_count elements starting from map start.
+	 * max_count != 0 && skey && nskey: delete max_count elements starting from skey.
+	 * max_count != 0 && !skey && !nskey: delete max_count elements in keys[].
+	 */
+	if ((max_count == 0 && nskey) || (max_count != 0 && skey && !nskey))
+		return -EINVAL;
+
+	ignore_enoent = !(flags & BPF_F_ENFORCE_ENOENT);
+	key_size = map->key_size;
+	roundup_key_size = round_up(map->key_size, 8);
+	buf = kmalloc(roundup_key_size * 2, GFP_USER | __GFP_NOWARN);
+	if (!buf)
+		return -ENOMEM;
+
+	key = buf;
+	next_key = buf + roundup_key_size;
+
+	nextkey_is_null = false;
+
+	if (max_count == 0 || nskey) {
+		count = 0;
+		if (skey) {
+			if (copy_from_user(key, skey, key_size)) {
+				ret = -EFAULT;
+				goto out;
+			}
+		} else {
+			ret = bpf_map_get_next_key(map, NULL, key);
+			if (ret) {
+				nextkey_is_null = true;
+				goto after_loop;
+			}
+		}
+
+		while (max_count == 0 || count < max_count) {
+			ret = bpf_map_get_next_key(map, key, next_key);
+
+			err = bpf_map_delete_elem(map, key);
+			if (err && (err != -ENOENT || !ignore_enoent)) {
+				ret = err;
+				break;
+			}
+
+			count += !err;
+
+			/* check bpf_map_get_next_key() result */
+			if (ret) {
+				nextkey_is_null = ret == -ENOENT;
+				break;
+			}
+
+			BPF_MAP_BATCH_SWAP_KEYS(key, next_key, buf, buf + roundup_key_size);
+		}
+
+after_loop:
+		if (!ret) {
+			if (copy_to_user(nskey, key, key_size))
+				ret = -EFAULT;
+		} else if (nextkey_is_null) {
+			ret = 0;
+			if (copy_to_user(&uattr->batch.next_start_key, &zero, sizeof(u64)))
+				ret = -EFAULT;
+		}
+	} else {
+		for (count = 0; count < max_count;) {
+			if (copy_from_user(key, keys + count * key_size, key_size)) {
+				ret = -EFAULT;
+				break;
+			}
+
+			ret = bpf_map_delete_elem(map, key);
+			if (ret && (ret != -ENOENT || !ignore_enoent))
+				break;
+
+			count += !ret;
+		}
+	}
+
+	if (ret != -EFAULT && put_user(count, &uattr->batch.count))
+		ret = -EFAULT;
+
+out:
+	kfree(buf);
+	return ret;
+}
+
+#define BPF_MAP_BATCH_LAST_FIELD batch.flags
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
+	if (!(map_get_sys_perms(map, f) & FMODE_CAN_WRITE)) {
+		err = -EPERM;
+		goto err_put;
+	}
+
+	if (cmd == BPF_MAP_LOOKUP_BATCH)
+		err = map_lookup_and_delete_batch(map, attr, uattr, false);
+	else if (cmd == BPF_MAP_LOOKUP_AND_DELETE_BATCH)
+		err = map_lookup_and_delete_batch(map, attr, uattr, true);
+	else if (cmd == BPF_MAP_UPDATE_BATCH)
+		err = map_update_batch(map, attr, uattr, &f);
+	else /* BPF_MAP_DELETE_BATCH */
+		err = map_delete_batch(map, attr, uattr);
+
+err_put:
+	fdput(f);
+	return err;
+
+}
+
 #define BPF_MAP_FREEZE_LAST_FIELD map_fd
 
 static int map_freeze(const union bpf_attr *attr)
@@ -2939,6 +3375,18 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 	case BPF_MAP_LOOKUP_AND_DELETE_ELEM:
 		err = map_lookup_and_delete_elem(&attr);
 		break;
+	case BPF_MAP_LOOKUP_BATCH:
+		err = bpf_map_do_batch(&attr, uattr, BPF_MAP_LOOKUP_BATCH);
+		break;
+	case BPF_MAP_LOOKUP_AND_DELETE_BATCH:
+		err = bpf_map_do_batch(&attr, uattr, BPF_MAP_LOOKUP_AND_DELETE_BATCH);
+		break;
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
2.17.1

