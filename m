Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9879125527B
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 03:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726854AbgH1BSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 21:18:12 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18900 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728048AbgH1BSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 21:18:12 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07S1BV9I007923
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 18:18:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=p0hD89TQ8QHpFLSYVYiClgA+Tg7sw4wtAHDDawzS8d0=;
 b=pM/9OpbD+w7J3YjFQK9Q+EMnG1iK4a7f3zjrcTFB/xJvt8NKRL1iuaJid35WBQMZPscu
 iiVqVKbBglK+wr9mGIFdxmPbSaoVsPphghMZNzK7cbpwMRQliC5KFudpD4DgxwFoTpkp
 UtSfeJygX+nR9uInXueqM1xP2uPS8dthHyI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 335up8rmcc-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 18:18:10 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 27 Aug 2020 18:18:08 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id DDB342946559; Thu, 27 Aug 2020 18:18:06 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 1/3] bpf: Add map_meta_equal map ops
Date:   Thu, 27 Aug 2020 18:18:06 -0700
Message-ID: <20200828011806.1970400-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200828011800.1970018-1-kafai@fb.com>
References: <20200828011800.1970018-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-27_14:2020-08-27,2020-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008280009
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some properties of the inner map is used in the verification time.
When an inner map is inserted to an outer map at runtime,
bpf_map_meta_equal() is currently used to ensure those properties
of the inserting inner map stays the same as the verification
time.

In particular, the current bpf_map_meta_equal() checks max_entries which
turns out to be too restrictive for most of the maps which do not use
max_entries during the verification time.  It limits the use case that
wants to replace a smaller inner map with a larger inner map.  There are
some maps do use max_entries during verification though.  For example,
the map_gen_lookup in array_map_ops uses the max_entries to generate
the inline lookup code.

To accommodate differences between maps, the map_meta_equal is added
to bpf_map_ops.  Each map-type can decide what to check when its
map is used as an inner map during runtime.

Also, some map types cannot be used as an inner map and they are
currently black listed in bpf_map_meta_alloc() in map_in_map.c.
It is not unusual that the new map types may not aware that such
blacklist exists.  This patch enforces an explicit opt-in
and only allows a map to be used as an inner map if it has
implemented the map_meta_equal ops.  It is based on the
discussion in [1].

All maps that support inner map has its map_meta_equal points
to bpf_map_meta_equal in this patch.  A later patch will
relax the max_entries check for most maps.  bpf_types.h
counts 28 map types.  This patch adds 23 ".map_meta_equal"
by using coccinelle.  -5 for
	BPF_MAP_TYPE_PROG_ARRAY
	BPF_MAP_TYPE_(PERCPU)_CGROUP_STORAGE
	BPF_MAP_TYPE_STRUCT_OPS
	BPF_MAP_TYPE_ARRAY_OF_MAPS
	BPF_MAP_TYPE_HASH_OF_MAPS

The "if (inner_map->inner_map_meta)" check in bpf_map_meta_alloc()
is moved such that the same error is returned.

[1]: https://lore.kernel.org/bpf/20200522022342.899756-1-kafai@fb.com/

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/bpf.h            | 16 ++++++++++++++++
 kernel/bpf/arraymap.c          |  9 +++++++++
 kernel/bpf/bpf_inode_storage.c |  1 +
 kernel/bpf/cpumap.c            |  1 +
 kernel/bpf/devmap.c            |  2 ++
 kernel/bpf/hashtab.c           |  4 ++++
 kernel/bpf/lpm_trie.c          |  1 +
 kernel/bpf/map_in_map.c        | 21 ++++++++-------------
 kernel/bpf/map_in_map.h        |  2 --
 kernel/bpf/queue_stack_maps.c  |  2 ++
 kernel/bpf/reuseport_array.c   |  1 +
 kernel/bpf/ringbuf.c           |  1 +
 kernel/bpf/stackmap.c          |  1 +
 kernel/bpf/syscall.c           |  1 +
 net/core/bpf_sk_storage.c      |  1 +
 net/core/sock_map.c            |  2 ++
 net/xdp/xskmap.c               |  1 +
 17 files changed, 52 insertions(+), 15 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index a6131d95e31e..dbba82a80087 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -112,6 +112,19 @@ struct bpf_map_ops {
 	void (*map_local_storage_uncharge)(struct bpf_local_storage_map *smap,
 					   void *owner, u32 size);
 	struct bpf_local_storage __rcu ** (*map_owner_storage_ptr)(void *owner)=
;
+
+	/* map_meta_equal must be implemented for maps that can be
+	 * used as an inner map.  It is a runtime check to ensure
+	 * an inner map can be inserted to an outer map.
+	 *
+	 * Some properties of the inner map has been used during the
+	 * verification time.  When inserting an inner map at the runtime,
+	 * map_meta_equal has to ensure the inserting map has the same
+	 * properties that the verifier has used earlier.
+	 */
+	bool (*map_meta_equal)(const struct bpf_map *meta0,
+			       const struct bpf_map *meta1);
+
 	/* BTF name and id of struct allocated by map_alloc */
 	const char * const map_btf_name;
 	int *map_btf_id;
@@ -235,6 +248,9 @@ int map_check_no_btf(const struct bpf_map *map,
 		     const struct btf_type *key_type,
 		     const struct btf_type *value_type);
=20
+bool bpf_map_meta_equal(const struct bpf_map *meta0,
+			const struct bpf_map *meta1);
+
 extern const struct bpf_map_ops bpf_map_offload_ops;
=20
 /* function argument constraints */
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 8ff419b632a6..40d1f7f94307 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -625,6 +625,7 @@ static const struct bpf_iter_seq_info iter_seq_info =3D=
 {
=20
 static int array_map_btf_id;
 const struct bpf_map_ops array_map_ops =3D {
+	.map_meta_equal =3D bpf_map_meta_equal,
 	.map_alloc_check =3D array_map_alloc_check,
 	.map_alloc =3D array_map_alloc,
 	.map_free =3D array_map_free,
@@ -647,6 +648,7 @@ const struct bpf_map_ops array_map_ops =3D {
=20
 static int percpu_array_map_btf_id;
 const struct bpf_map_ops percpu_array_map_ops =3D {
+	.map_meta_equal =3D bpf_map_meta_equal,
 	.map_alloc_check =3D array_map_alloc_check,
 	.map_alloc =3D array_map_alloc,
 	.map_free =3D array_map_free,
@@ -1003,6 +1005,11 @@ static void prog_array_map_free(struct bpf_map *ma=
p)
 	fd_array_map_free(map);
 }
=20
+/* prog_array->aux->{type,jited} is a runtime binding.
+ * Doing static check alone in the verifier is not enough.
+ * Thus, prog_array_map cannot be used as an inner_map
+ * and map_meta_equal is not implemented.
+ */
 static int prog_array_map_btf_id;
 const struct bpf_map_ops prog_array_map_ops =3D {
 	.map_alloc_check =3D fd_array_map_alloc_check,
@@ -1101,6 +1108,7 @@ static void perf_event_fd_array_release(struct bpf_=
map *map,
=20
 static int perf_event_array_map_btf_id;
 const struct bpf_map_ops perf_event_array_map_ops =3D {
+	.map_meta_equal =3D bpf_map_meta_equal,
 	.map_alloc_check =3D fd_array_map_alloc_check,
 	.map_alloc =3D array_map_alloc,
 	.map_free =3D fd_array_map_free,
@@ -1137,6 +1145,7 @@ static void cgroup_fd_array_free(struct bpf_map *ma=
p)
=20
 static int cgroup_array_map_btf_id;
 const struct bpf_map_ops cgroup_array_map_ops =3D {
+	.map_meta_equal =3D bpf_map_meta_equal,
 	.map_alloc_check =3D fd_array_map_alloc_check,
 	.map_alloc =3D array_map_alloc,
 	.map_free =3D cgroup_fd_array_free,
diff --git a/kernel/bpf/bpf_inode_storage.c b/kernel/bpf/bpf_inode_storag=
e.c
index f3a44e929447..75be02799c0f 100644
--- a/kernel/bpf/bpf_inode_storage.c
+++ b/kernel/bpf/bpf_inode_storage.c
@@ -235,6 +235,7 @@ static void inode_storage_map_free(struct bpf_map *ma=
p)
=20
 static int inode_storage_map_btf_id;
 const struct bpf_map_ops inode_storage_map_ops =3D {
+	.map_meta_equal =3D bpf_map_meta_equal,
 	.map_alloc_check =3D bpf_local_storage_map_alloc_check,
 	.map_alloc =3D inode_storage_map_alloc,
 	.map_free =3D inode_storage_map_free,
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index f1c46529929b..8d2a8623d2a7 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -658,6 +658,7 @@ static int cpu_map_get_next_key(struct bpf_map *map, =
void *key, void *next_key)
=20
 static int cpu_map_btf_id;
 const struct bpf_map_ops cpu_map_ops =3D {
+	.map_meta_equal		=3D bpf_map_meta_equal,
 	.map_alloc		=3D cpu_map_alloc,
 	.map_free		=3D cpu_map_free,
 	.map_delete_elem	=3D cpu_map_delete_elem,
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 10abb06065bb..a42052b85c35 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -751,6 +751,7 @@ static int dev_map_hash_update_elem(struct bpf_map *m=
ap, void *key, void *value,
=20
 static int dev_map_btf_id;
 const struct bpf_map_ops dev_map_ops =3D {
+	.map_meta_equal =3D bpf_map_meta_equal,
 	.map_alloc =3D dev_map_alloc,
 	.map_free =3D dev_map_free,
 	.map_get_next_key =3D dev_map_get_next_key,
@@ -764,6 +765,7 @@ const struct bpf_map_ops dev_map_ops =3D {
=20
 static int dev_map_hash_map_btf_id;
 const struct bpf_map_ops dev_map_hash_ops =3D {
+	.map_meta_equal =3D bpf_map_meta_equal,
 	.map_alloc =3D dev_map_alloc,
 	.map_free =3D dev_map_free,
 	.map_get_next_key =3D dev_map_hash_get_next_key,
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 78dfff6a501b..ad80f45774e7 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -1810,6 +1810,7 @@ static const struct bpf_iter_seq_info iter_seq_info=
 =3D {
=20
 static int htab_map_btf_id;
 const struct bpf_map_ops htab_map_ops =3D {
+	.map_meta_equal =3D bpf_map_meta_equal,
 	.map_alloc_check =3D htab_map_alloc_check,
 	.map_alloc =3D htab_map_alloc,
 	.map_free =3D htab_map_free,
@@ -1827,6 +1828,7 @@ const struct bpf_map_ops htab_map_ops =3D {
=20
 static int htab_lru_map_btf_id;
 const struct bpf_map_ops htab_lru_map_ops =3D {
+	.map_meta_equal =3D bpf_map_meta_equal,
 	.map_alloc_check =3D htab_map_alloc_check,
 	.map_alloc =3D htab_map_alloc,
 	.map_free =3D htab_map_free,
@@ -1947,6 +1949,7 @@ static void htab_percpu_map_seq_show_elem(struct bp=
f_map *map, void *key,
=20
 static int htab_percpu_map_btf_id;
 const struct bpf_map_ops htab_percpu_map_ops =3D {
+	.map_meta_equal =3D bpf_map_meta_equal,
 	.map_alloc_check =3D htab_map_alloc_check,
 	.map_alloc =3D htab_map_alloc,
 	.map_free =3D htab_map_free,
@@ -1963,6 +1966,7 @@ const struct bpf_map_ops htab_percpu_map_ops =3D {
=20
 static int htab_lru_percpu_map_btf_id;
 const struct bpf_map_ops htab_lru_percpu_map_ops =3D {
+	.map_meta_equal =3D bpf_map_meta_equal,
 	.map_alloc_check =3D htab_map_alloc_check,
 	.map_alloc =3D htab_map_alloc,
 	.map_free =3D htab_map_free,
diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index 44474bf3ab7a..00e32f2ec3e6 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -732,6 +732,7 @@ static int trie_check_btf(const struct bpf_map *map,
=20
 static int trie_map_btf_id;
 const struct bpf_map_ops trie_map_ops =3D {
+	.map_meta_equal =3D bpf_map_meta_equal,
 	.map_alloc =3D trie_alloc,
 	.map_free =3D trie_free,
 	.map_get_next_key =3D trie_get_next_key,
diff --git a/kernel/bpf/map_in_map.c b/kernel/bpf/map_in_map.c
index 17738c93bec8..e97a22dd3232 100644
--- a/kernel/bpf/map_in_map.c
+++ b/kernel/bpf/map_in_map.c
@@ -17,23 +17,17 @@ struct bpf_map *bpf_map_meta_alloc(int inner_map_ufd)
 	if (IS_ERR(inner_map))
 		return inner_map;
=20
-	/* prog_array->aux->{type,jited} is a runtime binding.
-	 * Doing static check alone in the verifier is not enough.
-	 */
-	if (inner_map->map_type =3D=3D BPF_MAP_TYPE_PROG_ARRAY ||
-	    inner_map->map_type =3D=3D BPF_MAP_TYPE_CGROUP_STORAGE ||
-	    inner_map->map_type =3D=3D BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE ||
-	    inner_map->map_type =3D=3D BPF_MAP_TYPE_STRUCT_OPS) {
-		fdput(f);
-		return ERR_PTR(-ENOTSUPP);
-	}
-
 	/* Does not support >1 level map-in-map */
 	if (inner_map->inner_map_meta) {
 		fdput(f);
 		return ERR_PTR(-EINVAL);
 	}
=20
+	if (!inner_map->ops->map_meta_equal) {
+		fdput(f);
+		return ERR_PTR(-ENOTSUPP);
+	}
+
 	if (map_value_has_spin_lock(inner_map)) {
 		fdput(f);
 		return ERR_PTR(-ENOTSUPP);
@@ -89,7 +83,7 @@ void *bpf_map_fd_get_ptr(struct bpf_map *map,
 			 struct file *map_file /* not used */,
 			 int ufd)
 {
-	struct bpf_map *inner_map;
+	struct bpf_map *inner_map, *inner_map_meta;
 	struct fd f;
=20
 	f =3D fdget(ufd);
@@ -97,7 +91,8 @@ void *bpf_map_fd_get_ptr(struct bpf_map *map,
 	if (IS_ERR(inner_map))
 		return inner_map;
=20
-	if (bpf_map_meta_equal(map->inner_map_meta, inner_map))
+	inner_map_meta =3D map->inner_map_meta;
+	if (inner_map_meta->ops->map_meta_equal(inner_map_meta, inner_map))
 		bpf_map_inc(inner_map);
 	else
 		inner_map =3D ERR_PTR(-EINVAL);
diff --git a/kernel/bpf/map_in_map.h b/kernel/bpf/map_in_map.h
index a507bf6ef8b9..bcb7534afb3c 100644
--- a/kernel/bpf/map_in_map.h
+++ b/kernel/bpf/map_in_map.h
@@ -11,8 +11,6 @@ struct bpf_map;
=20
 struct bpf_map *bpf_map_meta_alloc(int inner_map_ufd);
 void bpf_map_meta_free(struct bpf_map *map_meta);
-bool bpf_map_meta_equal(const struct bpf_map *meta0,
-			const struct bpf_map *meta1);
 void *bpf_map_fd_get_ptr(struct bpf_map *map, struct file *map_file,
 			 int ufd);
 void bpf_map_fd_put_ptr(void *ptr);
diff --git a/kernel/bpf/queue_stack_maps.c b/kernel/bpf/queue_stack_maps.=
c
index 44184f82916a..0ee2347ba510 100644
--- a/kernel/bpf/queue_stack_maps.c
+++ b/kernel/bpf/queue_stack_maps.c
@@ -257,6 +257,7 @@ static int queue_stack_map_get_next_key(struct bpf_ma=
p *map, void *key,
=20
 static int queue_map_btf_id;
 const struct bpf_map_ops queue_map_ops =3D {
+	.map_meta_equal =3D bpf_map_meta_equal,
 	.map_alloc_check =3D queue_stack_map_alloc_check,
 	.map_alloc =3D queue_stack_map_alloc,
 	.map_free =3D queue_stack_map_free,
@@ -273,6 +274,7 @@ const struct bpf_map_ops queue_map_ops =3D {
=20
 static int stack_map_btf_id;
 const struct bpf_map_ops stack_map_ops =3D {
+	.map_meta_equal =3D bpf_map_meta_equal,
 	.map_alloc_check =3D queue_stack_map_alloc_check,
 	.map_alloc =3D queue_stack_map_alloc,
 	.map_free =3D queue_stack_map_free,
diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
index 90b29c5b1da7..5a2ba1182493 100644
--- a/kernel/bpf/reuseport_array.c
+++ b/kernel/bpf/reuseport_array.c
@@ -351,6 +351,7 @@ static int reuseport_array_get_next_key(struct bpf_ma=
p *map, void *key,
=20
 static int reuseport_array_map_btf_id;
 const struct bpf_map_ops reuseport_array_ops =3D {
+	.map_meta_equal =3D bpf_map_meta_equal,
 	.map_alloc_check =3D reuseport_array_alloc_check,
 	.map_alloc =3D reuseport_array_alloc,
 	.map_free =3D reuseport_array_free,
diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index 002f8a5c9e51..31cb04a4dd2d 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -287,6 +287,7 @@ static __poll_t ringbuf_map_poll(struct bpf_map *map,=
 struct file *filp,
=20
 static int ringbuf_map_btf_id;
 const struct bpf_map_ops ringbuf_map_ops =3D {
+	.map_meta_equal =3D bpf_map_meta_equal,
 	.map_alloc =3D ringbuf_map_alloc,
 	.map_free =3D ringbuf_map_free,
 	.map_mmap =3D ringbuf_map_mmap,
diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index cfed0ac44d38..a2fa006f430e 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -839,6 +839,7 @@ static void stack_map_free(struct bpf_map *map)
=20
 static int stack_trace_map_btf_id;
 const struct bpf_map_ops stack_trace_map_ops =3D {
+	.map_meta_equal =3D bpf_map_meta_equal,
 	.map_alloc =3D stack_map_alloc,
 	.map_free =3D stack_map_free,
 	.map_get_next_key =3D stack_map_get_next_key,
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 5443cea86cef..b86b1155b748 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -90,6 +90,7 @@ int bpf_check_uarg_tail_zero(void __user *uaddr,
 }
=20
 const struct bpf_map_ops bpf_map_offload_ops =3D {
+	.map_meta_equal =3D bpf_map_meta_equal,
 	.map_alloc =3D bpf_map_offload_map_alloc,
 	.map_free =3D bpf_map_offload_map_free,
 	.map_check_btf =3D map_check_no_btf,
diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index 55fae03b4cc3..a0d1a3265b71 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -335,6 +335,7 @@ sk_storage_ptr(void *owner)
=20
 static int sk_storage_map_btf_id;
 const struct bpf_map_ops sk_storage_map_ops =3D {
+	.map_meta_equal =3D bpf_map_meta_equal,
 	.map_alloc_check =3D bpf_local_storage_map_alloc_check,
 	.map_alloc =3D sk_storage_map_alloc,
 	.map_free =3D sk_storage_map_free,
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index d6c6e1e312fc..078386d7d9a2 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -705,6 +705,7 @@ const struct bpf_func_proto bpf_msg_redirect_map_prot=
o =3D {
=20
 static int sock_map_btf_id;
 const struct bpf_map_ops sock_map_ops =3D {
+	.map_meta_equal		=3D bpf_map_meta_equal,
 	.map_alloc		=3D sock_map_alloc,
 	.map_free		=3D sock_map_free,
 	.map_get_next_key	=3D sock_map_get_next_key,
@@ -1200,6 +1201,7 @@ const struct bpf_func_proto bpf_msg_redirect_hash_p=
roto =3D {
=20
 static int sock_hash_map_btf_id;
 const struct bpf_map_ops sock_hash_ops =3D {
+	.map_meta_equal		=3D bpf_map_meta_equal,
 	.map_alloc		=3D sock_hash_alloc,
 	.map_free		=3D sock_hash_free,
 	.map_get_next_key	=3D sock_hash_get_next_key,
diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
index 8367adbbe9df..f45f29f04151 100644
--- a/net/xdp/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -256,6 +256,7 @@ void xsk_map_try_sock_delete(struct xsk_map *map, str=
uct xdp_sock *xs,
=20
 static int xsk_map_btf_id;
 const struct bpf_map_ops xsk_map_ops =3D {
+	.map_meta_equal =3D bpf_map_meta_equal,
 	.map_alloc =3D xsk_map_alloc,
 	.map_free =3D xsk_map_free,
 	.map_get_next_key =3D xsk_map_get_next_key,
--=20
2.24.1

