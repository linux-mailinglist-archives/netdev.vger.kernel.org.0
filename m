Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03344FD387
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 05:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfKOECz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 23:02:55 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62828 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726985AbfKOECz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 23:02:55 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAF40PLM017281
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 20:02:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=6JYPgaFvdk+R7kqtQpJ9jn4QTVcGqSzvWKnnRIHzbNs=;
 b=WifVg4m9AcsNkaFIfv2JHfQf2eqDaHHFL68lYjBH5JAiQZjzQvpolwlq3ikmkuTxFDQW
 6NG1pfXOWja8ttcXz/39Q5enWcNK5FYNfZzmvKFSiQD6AaLjeadSjzxS7ooFHyRcvOm9
 8S+yZjwTegpqPGl7Myx/1skawuXHKp79Q8E= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w8u0tk7gd-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 20:02:53 -0800
Received: from 2401:db00:2050:5076:face:0:9:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 14 Nov 2019 20:02:52 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 6AEC62EC1AEC; Thu, 14 Nov 2019 20:02:51 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 1/4] bpf: switch bpf_map ref counter to 64bit so bpf_map_inc never fails
Date:   Thu, 14 Nov 2019 20:02:22 -0800
Message-ID: <20191115040225.2147245-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191115040225.2147245-1-andriin@fb.com>
References: <20191115040225.2147245-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-14_07:2019-11-14,2019-11-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=25 malwarescore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 bulkscore=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 clxscore=1015 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1911150034
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

92117d8443bc ("bpf: fix refcnt overflow") turned refcounting of bpf_map into
potentially failing operation, when refcount reaches BPF_MAX_REFCNT limit
(32k). Due to using 32-bit counter, it's possible in practice to overflow
refcounter and make it wrap around to 0, causing erroneous map free, while
there are still references to it, causing use-after-free problems.

But having a failing refcounting operations are problematic in some cases. One
example is mmap() interface. After establishing initial memory-mapping, user
is allowed to arbitrarily map/remap/unmap parts of mapped memory, arbitrarily
splitting it into multiple non-contiguous regions. All this happening without
any control from the users of mmap subsystem. Rather mmap subsystem sends
notifications to original creator of memory mapping through open/close
callbacks, which are optionally specified during initial memory mapping
creation. These callbacks are used to maintain accurate refcount for bpf_map
(see next patch in this series). The problem is that open() callback is not
supposed to fail, because memory-mapped resource is set up and properly
referenced. This is posing a problem for using memory-mapping with BPF maps.

One solution to this is to maintain separate refcount for just memory-mappings
and do single bpf_map_inc/bpf_map_put when it goes from/to zero, respectively.
There are similar use cases in current work on tcp-bpf, necessitating extra
counter as well. This seems like a rather unfortunate and ugly solution that
doesn't scale well to various new use cases.

Another approach to solve this is to use non-failing refcount_t type, which
uses 32-bit counter internally, but, once reaching overflow state at UINT_MAX,
stays there. This utlimately causes memory leak, but prevents use after free.

But given refcounting is not the most performance-critical operation with BPF
maps (it's not used from running BPF program code), we can also just switch to
64-bit counter that can't overflow in practice, potentially disadvantaging
32-bit platforms a tiny bit. This simplifies semantics and allows above
described scenarios to not worry about failing refcount increment operation.

In terms of struct bpf_map size, we are still good and use the same amount of
space:

BEFORE (3 cache lines, 8 bytes of padding at the end):
struct bpf_map {
	const struct bpf_map_ops  * ops __attribute__((__aligned__(64))); /*     0     8 */
	struct bpf_map *           inner_map_meta;       /*     8     8 */
	void *                     security;             /*    16     8 */
	enum bpf_map_type  map_type;                     /*    24     4 */
	u32                        key_size;             /*    28     4 */
	u32                        value_size;           /*    32     4 */
	u32                        max_entries;          /*    36     4 */
	u32                        map_flags;            /*    40     4 */
	int                        spin_lock_off;        /*    44     4 */
	u32                        id;                   /*    48     4 */
	int                        numa_node;            /*    52     4 */
	u32                        btf_key_type_id;      /*    56     4 */
	u32                        btf_value_type_id;    /*    60     4 */
	/* --- cacheline 1 boundary (64 bytes) --- */
	struct btf *               btf;                  /*    64     8 */
	struct bpf_map_memory memory;                    /*    72    16 */
	bool                       unpriv_array;         /*    88     1 */
	bool                       frozen;               /*    89     1 */

	/* XXX 38 bytes hole, try to pack */

	/* --- cacheline 2 boundary (128 bytes) --- */
	atomic_t                   refcnt __attribute__((__aligned__(64))); /*   128     4 */
	atomic_t                   usercnt;              /*   132     4 */
	struct work_struct work;                         /*   136    32 */
	char                       name[16];             /*   168    16 */

	/* size: 192, cachelines: 3, members: 21 */
	/* sum members: 146, holes: 1, sum holes: 38 */
	/* padding: 8 */
	/* forced alignments: 2, forced holes: 1, sum forced holes: 38 */
} __attribute__((__aligned__(64)));

AFTER (same 3 cache lines, no extra padding now):
struct bpf_map {
	const struct bpf_map_ops  * ops __attribute__((__aligned__(64))); /*     0     8 */
	struct bpf_map *           inner_map_meta;       /*     8     8 */
	void *                     security;             /*    16     8 */
	enum bpf_map_type  map_type;                     /*    24     4 */
	u32                        key_size;             /*    28     4 */
	u32                        value_size;           /*    32     4 */
	u32                        max_entries;          /*    36     4 */
	u32                        map_flags;            /*    40     4 */
	int                        spin_lock_off;        /*    44     4 */
	u32                        id;                   /*    48     4 */
	int                        numa_node;            /*    52     4 */
	u32                        btf_key_type_id;      /*    56     4 */
	u32                        btf_value_type_id;    /*    60     4 */
	/* --- cacheline 1 boundary (64 bytes) --- */
	struct btf *               btf;                  /*    64     8 */
	struct bpf_map_memory memory;                    /*    72    16 */
	bool                       unpriv_array;         /*    88     1 */
	bool                       frozen;               /*    89     1 */

	/* XXX 38 bytes hole, try to pack */

	/* --- cacheline 2 boundary (128 bytes) --- */
	atomic64_t                 refcnt __attribute__((__aligned__(64))); /*   128     8 */
	atomic64_t                 usercnt;              /*   136     8 */
	struct work_struct work;                         /*   144    32 */
	char                       name[16];             /*   176    16 */

	/* size: 192, cachelines: 3, members: 21 */
	/* sum members: 154, holes: 1, sum holes: 38 */
	/* forced alignments: 2, forced holes: 1, sum forced holes: 38 */
} __attribute__((__aligned__(64)));

This patch, while modifying all users of bpf_map_inc, also cleans up its
interface to match bpf_map_put with separate operations for bpf_map_inc and
bpf_map_inc_with_uref (to match bpf_map_put and bpf_map_put_with_uref,
respectively). Also, given there are no users of bpf_map_inc_not_zero
specifying uref=true, remove uref flag and default to uref=false internally.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../net/ethernet/netronome/nfp/bpf/offload.c  |  4 +-
 include/linux/bpf.h                           | 10 ++--
 kernel/bpf/inode.c                            |  2 +-
 kernel/bpf/map_in_map.c                       |  2 +-
 kernel/bpf/syscall.c                          | 51 ++++++++-----------
 kernel/bpf/verifier.c                         |  6 +--
 kernel/bpf/xskmap.c                           |  6 +--
 net/core/bpf_sk_storage.c                     |  2 +-
 8 files changed, 34 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/bpf/offload.c b/drivers/net/ethernet/netronome/nfp/bpf/offload.c
index 88fab6a82acf..06927ba5a3ae 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/offload.c
@@ -46,9 +46,7 @@ nfp_map_ptr_record(struct nfp_app_bpf *bpf, struct nfp_prog *nfp_prog,
 	/* Grab a single ref to the map for our record.  The prog destroy ndo
 	 * happens after free_used_maps().
 	 */
-	map = bpf_map_inc(map, false);
-	if (IS_ERR(map))
-		return PTR_ERR(map);
+	bpf_map_inc(map);
 
 	record = kmalloc(sizeof(*record), GFP_KERNEL);
 	if (!record) {
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 7c7f518811a6..6fbe599fb977 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -101,8 +101,8 @@ struct bpf_map {
 	/* The 3rd and 4th cacheline with misc members to avoid false sharing
 	 * particularly with refcounting.
 	 */
-	atomic_t refcnt ____cacheline_aligned;
-	atomic_t usercnt;
+	atomic64_t refcnt ____cacheline_aligned;
+	atomic64_t usercnt;
 	struct work_struct work;
 	char name[BPF_OBJ_NAME_LEN];
 };
@@ -677,9 +677,9 @@ void bpf_map_free_id(struct bpf_map *map, bool do_idr_lock);
 
 struct bpf_map *bpf_map_get_with_uref(u32 ufd);
 struct bpf_map *__bpf_map_get(struct fd f);
-struct bpf_map * __must_check bpf_map_inc(struct bpf_map *map, bool uref);
-struct bpf_map * __must_check bpf_map_inc_not_zero(struct bpf_map *map,
-						   bool uref);
+void bpf_map_inc(struct bpf_map *map);
+void bpf_map_inc_with_uref(struct bpf_map *map);
+struct bpf_map * __must_check bpf_map_inc_not_zero(struct bpf_map *map);
 void bpf_map_put_with_uref(struct bpf_map *map);
 void bpf_map_put(struct bpf_map *map);
 int bpf_map_charge_memlock(struct bpf_map *map, u32 pages);
diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index a70f7209cda3..2f17f24258dc 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -34,7 +34,7 @@ static void *bpf_any_get(void *raw, enum bpf_type type)
 		raw = bpf_prog_inc(raw);
 		break;
 	case BPF_TYPE_MAP:
-		raw = bpf_map_inc(raw, true);
+		bpf_map_inc_with_uref(raw);
 		break;
 	default:
 		WARN_ON_ONCE(1);
diff --git a/kernel/bpf/map_in_map.c b/kernel/bpf/map_in_map.c
index fab4fb134547..4cbe987be35b 100644
--- a/kernel/bpf/map_in_map.c
+++ b/kernel/bpf/map_in_map.c
@@ -98,7 +98,7 @@ void *bpf_map_fd_get_ptr(struct bpf_map *map,
 		return inner_map;
 
 	if (bpf_map_meta_equal(map->inner_map_meta, inner_map))
-		inner_map = bpf_map_inc(inner_map, false);
+		bpf_map_inc(inner_map);
 	else
 		inner_map = ERR_PTR(-EINVAL);
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 6d9ce95e5a8d..9d8b56d660d7 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -311,7 +311,7 @@ static void bpf_map_free_deferred(struct work_struct *work)
 
 static void bpf_map_put_uref(struct bpf_map *map)
 {
-	if (atomic_dec_and_test(&map->usercnt)) {
+	if (atomic64_dec_and_test(&map->usercnt)) {
 		if (map->ops->map_release_uref)
 			map->ops->map_release_uref(map);
 	}
@@ -322,7 +322,7 @@ static void bpf_map_put_uref(struct bpf_map *map)
  */
 static void __bpf_map_put(struct bpf_map *map, bool do_idr_lock)
 {
-	if (atomic_dec_and_test(&map->refcnt)) {
+	if (atomic64_dec_and_test(&map->refcnt)) {
 		/* bpf_map_free_id() must be called first */
 		bpf_map_free_id(map, do_idr_lock);
 		btf_put(map->btf);
@@ -575,8 +575,8 @@ static int map_create(union bpf_attr *attr)
 	if (err)
 		goto free_map;
 
-	atomic_set(&map->refcnt, 1);
-	atomic_set(&map->usercnt, 1);
+	atomic64_set(&map->refcnt, 1);
+	atomic64_set(&map->usercnt, 1);
 
 	if (attr->btf_key_type_id || attr->btf_value_type_id) {
 		struct btf *btf;
@@ -653,21 +653,19 @@ struct bpf_map *__bpf_map_get(struct fd f)
 	return f.file->private_data;
 }
 
-/* prog's and map's refcnt limit */
-#define BPF_MAX_REFCNT 32768
-
-struct bpf_map *bpf_map_inc(struct bpf_map *map, bool uref)
+void bpf_map_inc(struct bpf_map *map)
 {
-	if (atomic_inc_return(&map->refcnt) > BPF_MAX_REFCNT) {
-		atomic_dec(&map->refcnt);
-		return ERR_PTR(-EBUSY);
-	}
-	if (uref)
-		atomic_inc(&map->usercnt);
-	return map;
+	atomic64_inc(&map->refcnt);
 }
 EXPORT_SYMBOL_GPL(bpf_map_inc);
 
+void bpf_map_inc_with_uref(struct bpf_map *map)
+{
+	atomic64_inc(&map->refcnt);
+	atomic64_inc(&map->usercnt);
+}
+EXPORT_SYMBOL_GPL(bpf_map_inc_with_uref);
+
 struct bpf_map *bpf_map_get_with_uref(u32 ufd)
 {
 	struct fd f = fdget(ufd);
@@ -677,38 +675,30 @@ struct bpf_map *bpf_map_get_with_uref(u32 ufd)
 	if (IS_ERR(map))
 		return map;
 
-	map = bpf_map_inc(map, true);
+	bpf_map_inc_with_uref(map);
 	fdput(f);
 
 	return map;
 }
 
 /* map_idr_lock should have been held */
-static struct bpf_map *__bpf_map_inc_not_zero(struct bpf_map *map,
-					      bool uref)
+static struct bpf_map *__bpf_map_inc_not_zero(struct bpf_map *map, bool uref)
 {
 	int refold;
 
-	refold = atomic_fetch_add_unless(&map->refcnt, 1, 0);
-
-	if (refold >= BPF_MAX_REFCNT) {
-		__bpf_map_put(map, false);
-		return ERR_PTR(-EBUSY);
-	}
-
+	refold = atomic64_fetch_add_unless(&map->refcnt, 1, 0);
 	if (!refold)
 		return ERR_PTR(-ENOENT);
-
 	if (uref)
-		atomic_inc(&map->usercnt);
+		atomic64_inc(&map->usercnt);
 
 	return map;
 }
 
-struct bpf_map *bpf_map_inc_not_zero(struct bpf_map *map, bool uref)
+struct bpf_map *bpf_map_inc_not_zero(struct bpf_map *map)
 {
 	spin_lock_bh(&map_idr_lock);
-	map = __bpf_map_inc_not_zero(map, uref);
+	map = __bpf_map_inc_not_zero(map, false);
 	spin_unlock_bh(&map_idr_lock);
 
 	return map;
@@ -1454,6 +1444,9 @@ static struct bpf_prog *____bpf_prog_get(struct fd f)
 	return f.file->private_data;
 }
 
+/* prog's refcnt limit */
+#define BPF_MAX_REFCNT 32768
+
 struct bpf_prog *bpf_prog_add(struct bpf_prog *prog, int i)
 {
 	if (atomic_add_return(i, &prog->aux->refcnt) > BPF_MAX_REFCNT) {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2f2374967b36..38d34afe979c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8169,11 +8169,7 @@ static int replace_map_fd_with_map_ptr(struct bpf_verifier_env *env)
 			 * will be used by the valid program until it's unloaded
 			 * and all maps are released in free_used_maps()
 			 */
-			map = bpf_map_inc(map, false);
-			if (IS_ERR(map)) {
-				fdput(f);
-				return PTR_ERR(map);
-			}
+			bpf_map_inc(map);
 
 			aux->map_index = env->used_map_cnt;
 			env->used_maps[env->used_map_cnt++] = map;
diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
index da16c30868f3..90c4fce1c981 100644
--- a/kernel/bpf/xskmap.c
+++ b/kernel/bpf/xskmap.c
@@ -11,10 +11,8 @@
 
 int xsk_map_inc(struct xsk_map *map)
 {
-	struct bpf_map *m = &map->map;
-
-	m = bpf_map_inc(m, false);
-	return PTR_ERR_OR_ZERO(m);
+	bpf_map_inc(&map->map);
+	return 0;
 }
 
 void xsk_map_put(struct xsk_map *map)
diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index da5639a5bd3b..458be6b3eda9 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -798,7 +798,7 @@ int bpf_sk_storage_clone(const struct sock *sk, struct sock *newsk)
 		 * Try to grab map refcnt to make sure that it's still
 		 * alive and prevent concurrent removal.
 		 */
-		map = bpf_map_inc_not_zero(&smap->map, false);
+		map = bpf_map_inc_not_zero(&smap->map);
 		if (IS_ERR(map))
 			continue;
 
-- 
2.17.1

