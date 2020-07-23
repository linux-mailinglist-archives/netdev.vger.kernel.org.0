Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B6222B5E5
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 20:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbgGWSl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 14:41:29 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38634 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726500AbgGWSlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 14:41:25 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06NIZXHH009825
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 11:41:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=tgIy8zksWHk2zSIZyWd0+1ajtCgWt/KSiJnfftHbu4I=;
 b=pXZAdLQYmVx5XXUSI+5OsrAm5t7F+EzBZ9Sc8bNk7bh5bSPGdNC+GQ6bGCNZVtCK53H6
 XQGNqMPARbPar1oISBC8Qb4N2M2g9jqU7vFRNVi1e0BTbtvR51+vUs3iq91GVHst5I+D
 xKS74C7IPrHkXkXavxDs0a5nOJdr0AgWc5M= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32esyuwu9x-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 11:41:22 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 23 Jul 2020 11:41:20 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 1E0573702DDA; Thu, 23 Jul 2020 11:41:14 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v4 05/13] bpf: implement bpf iterator for hash maps
Date:   Thu, 23 Jul 2020 11:41:14 -0700
Message-ID: <20200723184114.590470-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200723184108.589857-1-yhs@fb.com>
References: <20200723184108.589857-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-23_09:2020-07-23,2020-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 suspectscore=8 impostorscore=0 mlxlogscore=888 phishscore=0 spamscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007230134
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf iterators for hash, percpu hash, lru hash
and lru percpu hash are implemented. During link time,
bpf_iter_reg->check_target() will check map type
and ensure the program access key/value region is
within the map defined key/value size limit.

For percpu hash and lru hash maps, the bpf program
will receive values for all cpus. The map element
bpf iterator infrastructure will prepare value
properly before passing the value pointer to the
bpf program.

This patch set supports readonly map keys and
read/write map values. It does not support deleting
map elements, e.g., from hash tables. If there is
a user case for this, the following mechanism can
be used to support map deletion for hashtab, etc.
  - permit a new bpf program return value, e.g., 2,
    to let bpf iterator know the map element should
    be removed.
  - since bucket lock is taken, the map element will be
    queued.
  - once bucket lock is released after all elements under
    this bucket are traversed, all to-be-deleted map
    elements can be deleted.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/hashtab.c  | 194 ++++++++++++++++++++++++++++++++++++++++++
 kernel/bpf/map_iter.c |  24 +++++-
 2 files changed, 217 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index d4378d7d442b..024276787055 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -1612,6 +1612,196 @@ htab_lru_map_lookup_and_delete_batch(struct bpf_m=
ap *map,
 						  true, false);
 }
=20
+struct bpf_iter_seq_hash_map_info {
+	struct bpf_map *map;
+	struct bpf_htab *htab;
+	void *percpu_value_buf; // non-zero means percpu hash
+	unsigned long flags;
+	u32 bucket_id;
+	u32 skip_elems;
+};
+
+static struct htab_elem *
+bpf_hash_map_seq_find_next(struct bpf_iter_seq_hash_map_info *info,
+			   struct htab_elem *prev_elem)
+{
+	const struct bpf_htab *htab =3D info->htab;
+	unsigned long flags =3D info->flags;
+	u32 skip_elems =3D info->skip_elems;
+	u32 bucket_id =3D info->bucket_id;
+	struct hlist_nulls_head *head;
+	struct hlist_nulls_node *n;
+	struct htab_elem *elem;
+	struct bucket *b;
+	u32 i, count;
+
+	if (bucket_id >=3D htab->n_buckets)
+		return NULL;
+
+	/* try to find next elem in the same bucket */
+	if (prev_elem) {
+		/* no update/deletion on this bucket, prev_elem should be still valid
+		 * and we won't skip elements.
+		 */
+		n =3D rcu_dereference_raw(hlist_nulls_next_rcu(&prev_elem->hash_node))=
;
+		elem =3D hlist_nulls_entry_safe(n, struct htab_elem, hash_node);
+		if (elem)
+			return elem;
+
+		/* not found, unlock and go to the next bucket */
+		b =3D &htab->buckets[bucket_id++];
+		htab_unlock_bucket(htab, b, flags);
+		skip_elems =3D 0;
+	}
+
+	for (i =3D bucket_id; i < htab->n_buckets; i++) {
+		b =3D &htab->buckets[i];
+		flags =3D htab_lock_bucket(htab, b);
+
+		count =3D 0;
+		head =3D &b->head;
+		hlist_nulls_for_each_entry_rcu(elem, n, head, hash_node) {
+			if (count >=3D skip_elems) {
+				info->flags =3D flags;
+				info->bucket_id =3D i;
+				info->skip_elems =3D count;
+				return elem;
+			}
+			count++;
+		}
+
+		htab_unlock_bucket(htab, b, flags);
+		skip_elems =3D 0;
+	}
+
+	info->bucket_id =3D i;
+	info->skip_elems =3D 0;
+	return NULL;
+}
+
+static void *bpf_hash_map_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct bpf_iter_seq_hash_map_info *info =3D seq->private;
+	struct htab_elem *elem;
+
+	elem =3D bpf_hash_map_seq_find_next(info, NULL);
+	if (!elem)
+		return NULL;
+
+	if (*pos =3D=3D 0)
+		++*pos;
+	return elem;
+}
+
+static void *bpf_hash_map_seq_next(struct seq_file *seq, void *v, loff_t=
 *pos)
+{
+	struct bpf_iter_seq_hash_map_info *info =3D seq->private;
+
+	++*pos;
+	++info->skip_elems;
+	return bpf_hash_map_seq_find_next(info, v);
+}
+
+static int __bpf_hash_map_seq_show(struct seq_file *seq, struct htab_ele=
m *elem)
+{
+	struct bpf_iter_seq_hash_map_info *info =3D seq->private;
+	u32 roundup_key_size, roundup_value_size;
+	struct bpf_iter__bpf_map_elem ctx =3D {};
+	struct bpf_map *map =3D info->map;
+	struct bpf_iter_meta meta;
+	int ret =3D 0, off =3D 0, cpu;
+	struct bpf_prog *prog;
+	void __percpu *pptr;
+
+	meta.seq =3D seq;
+	prog =3D bpf_iter_get_info(&meta, elem =3D=3D NULL);
+	if (prog) {
+		ctx.meta =3D &meta;
+		ctx.map =3D info->map;
+		if (elem) {
+			roundup_key_size =3D round_up(map->key_size, 8);
+			ctx.key =3D elem->key;
+			if (!info->percpu_value_buf) {
+				ctx.value =3D elem->key + roundup_key_size;
+			} else {
+				roundup_value_size =3D round_up(map->value_size, 8);
+				pptr =3D htab_elem_get_ptr(elem, map->key_size);
+				for_each_possible_cpu(cpu) {
+					bpf_long_memcpy(info->percpu_value_buf + off,
+							per_cpu_ptr(pptr, cpu),
+							roundup_value_size);
+					off +=3D roundup_value_size;
+				}
+				ctx.value =3D info->percpu_value_buf;
+			}
+		}
+		ret =3D bpf_iter_run_prog(prog, &ctx);
+	}
+
+	return ret;
+}
+
+static int bpf_hash_map_seq_show(struct seq_file *seq, void *v)
+{
+	return __bpf_hash_map_seq_show(seq, v);
+}
+
+static void bpf_hash_map_seq_stop(struct seq_file *seq, void *v)
+{
+	struct bpf_iter_seq_hash_map_info *info =3D seq->private;
+
+	if (!v)
+		(void)__bpf_hash_map_seq_show(seq, NULL);
+	else
+		htab_unlock_bucket(info->htab,
+				   &info->htab->buckets[info->bucket_id],
+				   info->flags);
+}
+
+static int bpf_iter_init_hash_map(void *priv_data,
+				  struct bpf_iter_aux_info *aux)
+{
+	struct bpf_iter_seq_hash_map_info *seq_info =3D priv_data;
+	struct bpf_map *map =3D aux->map;
+	void *value_buf;
+	u32 buf_size;
+
+	if (map->map_type =3D=3D BPF_MAP_TYPE_PERCPU_HASH ||
+	    map->map_type =3D=3D BPF_MAP_TYPE_LRU_PERCPU_HASH) {
+		buf_size =3D round_up(map->value_size, 8) * num_possible_cpus();
+		value_buf =3D kmalloc(buf_size, GFP_USER | __GFP_NOWARN);
+		if (!value_buf)
+			return -ENOMEM;
+
+		seq_info->percpu_value_buf =3D value_buf;
+	}
+
+	seq_info->map =3D map;
+	seq_info->htab =3D container_of(map, struct bpf_htab, map);
+	return 0;
+}
+
+static void bpf_iter_fini_hash_map(void *priv_data)
+{
+	struct bpf_iter_seq_hash_map_info *seq_info =3D priv_data;
+
+	kfree(seq_info->percpu_value_buf);
+}
+
+static const struct seq_operations bpf_hash_map_seq_ops =3D {
+	.start	=3D bpf_hash_map_seq_start,
+	.next	=3D bpf_hash_map_seq_next,
+	.stop	=3D bpf_hash_map_seq_stop,
+	.show	=3D bpf_hash_map_seq_show,
+};
+
+static const struct bpf_iter_seq_info iter_seq_info =3D {
+	.seq_ops		=3D &bpf_hash_map_seq_ops,
+	.init_seq_private	=3D bpf_iter_init_hash_map,
+	.fini_seq_private	=3D bpf_iter_fini_hash_map,
+	.seq_priv_size		=3D sizeof(struct bpf_iter_seq_hash_map_info),
+};
+
 static int htab_map_btf_id;
 const struct bpf_map_ops htab_map_ops =3D {
 	.map_alloc_check =3D htab_map_alloc_check,
@@ -1626,6 +1816,7 @@ const struct bpf_map_ops htab_map_ops =3D {
 	BATCH_OPS(htab),
 	.map_btf_name =3D "bpf_htab",
 	.map_btf_id =3D &htab_map_btf_id,
+	.iter_seq_info =3D &iter_seq_info,
 };
=20
 static int htab_lru_map_btf_id;
@@ -1643,6 +1834,7 @@ const struct bpf_map_ops htab_lru_map_ops =3D {
 	BATCH_OPS(htab_lru),
 	.map_btf_name =3D "bpf_htab",
 	.map_btf_id =3D &htab_lru_map_btf_id,
+	.iter_seq_info =3D &iter_seq_info,
 };
=20
 /* Called from eBPF program */
@@ -1760,6 +1952,7 @@ const struct bpf_map_ops htab_percpu_map_ops =3D {
 	BATCH_OPS(htab_percpu),
 	.map_btf_name =3D "bpf_htab",
 	.map_btf_id =3D &htab_percpu_map_btf_id,
+	.iter_seq_info =3D &iter_seq_info,
 };
=20
 static int htab_lru_percpu_map_btf_id;
@@ -1775,6 +1968,7 @@ const struct bpf_map_ops htab_lru_percpu_map_ops =3D=
 {
 	BATCH_OPS(htab_lru_percpu),
 	.map_btf_name =3D "bpf_htab",
 	.map_btf_id =3D &htab_lru_percpu_map_btf_id,
+	.iter_seq_info =3D &iter_seq_info,
 };
=20
 static int fd_htab_map_alloc_check(union bpf_attr *attr)
diff --git a/kernel/bpf/map_iter.c b/kernel/bpf/map_iter.c
index 8a1f9b3355d0..bcb68b55bf65 100644
--- a/kernel/bpf/map_iter.c
+++ b/kernel/bpf/map_iter.c
@@ -101,7 +101,29 @@ static struct bpf_iter_reg bpf_map_reg_info =3D {
 static int bpf_iter_check_map(struct bpf_prog *prog,
 			      struct bpf_iter_aux_info *aux)
 {
-	return -EINVAL;
+	u32 key_acc_size, value_acc_size, key_size, value_size;
+	struct bpf_map *map =3D aux->map;
+	bool is_percpu =3D false;
+
+	if (map->map_type =3D=3D BPF_MAP_TYPE_PERCPU_HASH ||
+	    map->map_type =3D=3D BPF_MAP_TYPE_LRU_PERCPU_HASH)
+		is_percpu =3D true;
+	else if (map->map_type !=3D BPF_MAP_TYPE_HASH &&
+		 map->map_type !=3D BPF_MAP_TYPE_LRU_HASH)
+		return -EINVAL;
+
+	key_acc_size =3D prog->aux->max_rdonly_access;
+	value_acc_size =3D prog->aux->max_rdwr_access;
+	key_size =3D map->key_size;
+	if (!is_percpu)
+		value_size =3D map->value_size;
+	else
+		value_size =3D round_up(map->value_size, 8) * num_possible_cpus();
+
+	if (key_acc_size > key_size || value_acc_size > value_size)
+		return -EACCES;
+
+	return 0;
 }
=20
 DEFINE_BPF_ITER_FUNC(bpf_map_elem, struct bpf_iter_meta *meta,
--=20
2.24.1

