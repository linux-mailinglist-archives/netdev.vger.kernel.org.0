Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAEB29E3BC
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbgJ2HVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:21:06 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14652 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725950AbgJ2HUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:20:44 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 09T7KUHO005860
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 00:20:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=n5un1TOjg4zumUX3obhV3mFg6fx1cUEqKSrhMSWOkvw=;
 b=coavtNB0GZdyxy0lfv6ooKuQgoXuZJf6KSiJu2vBtOfPL2zre98KxR2fBmORP+BhaXCK
 4unFz5etCs5+L+IojbydtbbPHujJaB35duSKYOILlC1wmqteKHRkYrpegkn1k5BCGR9N
 aQhPbwKuuv/5nQoNobdAEmv1I5xjMleGKJI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 34ejk2c460-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 00:20:41 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 29 Oct 2020 00:20:40 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 8652E62E580C; Thu, 29 Oct 2020 00:20:33 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH bpf-next 2/2] bpf: Avoid hashtab deadlock with map_locked
Date:   Thu, 29 Oct 2020 00:19:25 -0700
Message-ID: <20201029071925.3103400-3-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201029071925.3103400-1-songliubraving@fb.com>
References: <20201029071925.3103400-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-29_03:2020-10-29,2020-10-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=884 clxscore=1015
 phishscore=0 suspectscore=2 adultscore=0 bulkscore=0 impostorscore=0
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290051
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a hashtab is accessed in both non-NMI and NMI context, the system may
deadlock on bucket->lock. Fix this issue with percpu counter map_locked.
map_locked rejects concurrent access to the same bucket from the same CPU=
.
To reduce memory overhead, map_locked is not added per bucket. Instead,
8 percpu counters are added to each hashtab. buckets are assigned to thes=
e
counters based on the lower bits of its hash.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 kernel/bpf/hashtab.c | 114 +++++++++++++++++++++++++++++++------------
 1 file changed, 82 insertions(+), 32 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 278da031c91ab..da59ba978d172 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -86,6 +86,9 @@ struct bucket {
 	};
 };
=20
+#define HASHTAB_MAP_LOCK_COUNT 8
+#define HASHTAB_MAP_LOCK_MASK (HASHTAB_MAP_LOCK_COUNT - 1)
+
 struct bpf_htab {
 	struct bpf_map map;
 	struct bucket *buckets;
@@ -100,6 +103,7 @@ struct bpf_htab {
 	u32 elem_size;	/* size of each element in bytes */
 	u32 hashrnd;
 	struct lock_class_key lockdep_key;
+	int __percpu *map_locked[HASHTAB_MAP_LOCK_COUNT];
 };
=20
 /* each htab element is struct htab_elem + key + value */
@@ -152,26 +156,41 @@ static void htab_init_buckets(struct bpf_htab *htab=
)
 	}
 }
=20
-static inline unsigned long htab_lock_bucket(const struct bpf_htab *htab=
,
-					     struct bucket *b)
+static inline int htab_lock_bucket(const struct bpf_htab *htab,
+				   struct bucket *b, u32 hash,
+				   unsigned long *pflags)
 {
 	unsigned long flags;
=20
+	hash =3D hash & HASHTAB_MAP_LOCK_MASK;
+
+	migrate_disable();
+	if (unlikely(__this_cpu_inc_return(*(htab->map_locked[hash])) !=3D 1)) =
{
+		__this_cpu_dec(*(htab->map_locked[hash]));
+		migrate_enable();
+		return -EBUSY;
+	}
+
 	if (htab_use_raw_lock(htab))
 		raw_spin_lock_irqsave(&b->raw_lock, flags);
 	else
 		spin_lock_irqsave(&b->lock, flags);
-	return flags;
+	*pflags =3D flags;
+
+	return 0;
 }
=20
 static inline void htab_unlock_bucket(const struct bpf_htab *htab,
-				      struct bucket *b,
+				      struct bucket *b, u32 hash,
 				      unsigned long flags)
 {
+	hash =3D hash & HASHTAB_MAP_LOCK_MASK;
 	if (htab_use_raw_lock(htab))
 		raw_spin_unlock_irqrestore(&b->raw_lock, flags);
 	else
 		spin_unlock_irqrestore(&b->lock, flags);
+	__this_cpu_dec(*(htab->map_locked[hash]));
+	migrate_enable();
 }
=20
 static bool htab_lru_map_delete_node(void *arg, struct bpf_lru_node *nod=
e);
@@ -429,8 +448,8 @@ static struct bpf_map *htab_map_alloc(union bpf_attr =
*attr)
 	bool percpu_lru =3D (attr->map_flags & BPF_F_NO_COMMON_LRU);
 	bool prealloc =3D !(attr->map_flags & BPF_F_NO_PREALLOC);
 	struct bpf_htab *htab;
+	int err, i;
 	u64 cost;
-	int err;
=20
 	htab =3D kzalloc(sizeof(*htab), GFP_USER);
 	if (!htab)
@@ -487,6 +506,13 @@ static struct bpf_map *htab_map_alloc(union bpf_attr=
 *attr)
 	if (!htab->buckets)
 		goto free_charge;
=20
+	for (i =3D 0; i < HASHTAB_MAP_LOCK_COUNT; i++) {
+		htab->map_locked[i] =3D __alloc_percpu_gfp(sizeof(int),
+							 sizeof(int), GFP_USER);
+		if (!htab->map_locked[i])
+			goto free_map_locked;
+	}
+
 	if (htab->map.map_flags & BPF_F_ZERO_SEED)
 		htab->hashrnd =3D 0;
 	else
@@ -497,7 +523,7 @@ static struct bpf_map *htab_map_alloc(union bpf_attr =
*attr)
 	if (prealloc) {
 		err =3D prealloc_init(htab);
 		if (err)
-			goto free_buckets;
+			goto free_map_locked;
=20
 		if (!percpu && !lru) {
 			/* lru itself can remove the least used element, so
@@ -513,7 +539,9 @@ static struct bpf_map *htab_map_alloc(union bpf_attr =
*attr)
=20
 free_prealloc:
 	prealloc_destroy(htab);
-free_buckets:
+free_map_locked:
+	for (i =3D 0; i < HASHTAB_MAP_LOCK_COUNT; i++)
+		free_percpu(htab->map_locked[i]);
 	bpf_map_area_free(htab->buckets);
 free_charge:
 	bpf_map_charge_finish(&htab->map.memory);
@@ -694,12 +722,15 @@ static bool htab_lru_map_delete_node(void *arg, str=
uct bpf_lru_node *node)
 	struct hlist_nulls_node *n;
 	unsigned long flags;
 	struct bucket *b;
+	int ret;
=20
 	tgt_l =3D container_of(node, struct htab_elem, lru_node);
 	b =3D __select_bucket(htab, tgt_l->hash);
 	head =3D &b->head;
=20
-	flags =3D htab_lock_bucket(htab, b);
+	ret =3D htab_lock_bucket(htab, b, tgt_l->hash, &flags);
+	if (ret)
+		return false;
=20
 	hlist_nulls_for_each_entry_rcu(l, n, head, hash_node)
 		if (l =3D=3D tgt_l) {
@@ -707,7 +738,7 @@ static bool htab_lru_map_delete_node(void *arg, struc=
t bpf_lru_node *node)
 			break;
 		}
=20
-	htab_unlock_bucket(htab, b, flags);
+	htab_unlock_bucket(htab, b, tgt_l->hash, flags);
=20
 	return l =3D=3D tgt_l;
 }
@@ -979,7 +1010,9 @@ static int htab_map_update_elem(struct bpf_map *map,=
 void *key, void *value,
 		 */
 	}
=20
-	flags =3D htab_lock_bucket(htab, b);
+	ret =3D htab_lock_bucket(htab, b, hash, &flags);
+	if (ret)
+		return ret;
=20
 	l_old =3D lookup_elem_raw(head, hash, key, key_size);
=20
@@ -1020,7 +1053,7 @@ static int htab_map_update_elem(struct bpf_map *map=
, void *key, void *value,
 	}
 	ret =3D 0;
 err:
-	htab_unlock_bucket(htab, b, flags);
+	htab_unlock_bucket(htab, b, hash, flags);
 	return ret;
 }
=20
@@ -1058,7 +1091,9 @@ static int htab_lru_map_update_elem(struct bpf_map =
*map, void *key, void *value,
 		return -ENOMEM;
 	memcpy(l_new->key + round_up(map->key_size, 8), value, map->value_size)=
;
=20
-	flags =3D htab_lock_bucket(htab, b);
+	ret =3D htab_lock_bucket(htab, b, hash, &flags);
+	if (ret)
+		return ret;
=20
 	l_old =3D lookup_elem_raw(head, hash, key, key_size);
=20
@@ -1077,7 +1112,7 @@ static int htab_lru_map_update_elem(struct bpf_map =
*map, void *key, void *value,
 	ret =3D 0;
=20
 err:
-	htab_unlock_bucket(htab, b, flags);
+	htab_unlock_bucket(htab, b, hash, flags);
=20
 	if (ret)
 		bpf_lru_push_free(&htab->lru, &l_new->lru_node);
@@ -1112,7 +1147,9 @@ static int __htab_percpu_map_update_elem(struct bpf=
_map *map, void *key,
 	b =3D __select_bucket(htab, hash);
 	head =3D &b->head;
=20
-	flags =3D htab_lock_bucket(htab, b);
+	ret =3D htab_lock_bucket(htab, b, hash, &flags);
+	if (ret)
+		return ret;
=20
 	l_old =3D lookup_elem_raw(head, hash, key, key_size);
=20
@@ -1135,7 +1172,7 @@ static int __htab_percpu_map_update_elem(struct bpf=
_map *map, void *key,
 	}
 	ret =3D 0;
 err:
-	htab_unlock_bucket(htab, b, flags);
+	htab_unlock_bucket(htab, b, hash, flags);
 	return ret;
 }
=20
@@ -1175,7 +1212,9 @@ static int __htab_lru_percpu_map_update_elem(struct=
 bpf_map *map, void *key,
 			return -ENOMEM;
 	}
=20
-	flags =3D htab_lock_bucket(htab, b);
+	ret =3D htab_lock_bucket(htab, b, hash, &flags);
+	if (ret)
+		return ret;
=20
 	l_old =3D lookup_elem_raw(head, hash, key, key_size);
=20
@@ -1197,7 +1236,7 @@ static int __htab_lru_percpu_map_update_elem(struct=
 bpf_map *map, void *key,
 	}
 	ret =3D 0;
 err:
-	htab_unlock_bucket(htab, b, flags);
+	htab_unlock_bucket(htab, b, hash, flags);
 	if (l_new)
 		bpf_lru_push_free(&htab->lru, &l_new->lru_node);
 	return ret;
@@ -1225,7 +1264,7 @@ static int htab_map_delete_elem(struct bpf_map *map=
, void *key)
 	struct htab_elem *l;
 	unsigned long flags;
 	u32 hash, key_size;
-	int ret =3D -ENOENT;
+	int ret;
=20
 	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held());
=20
@@ -1235,17 +1274,20 @@ static int htab_map_delete_elem(struct bpf_map *m=
ap, void *key)
 	b =3D __select_bucket(htab, hash);
 	head =3D &b->head;
=20
-	flags =3D htab_lock_bucket(htab, b);
+	ret =3D htab_lock_bucket(htab, b, hash, &flags);
+	if (ret)
+		return ret;
=20
 	l =3D lookup_elem_raw(head, hash, key, key_size);
=20
 	if (l) {
 		hlist_nulls_del_rcu(&l->hash_node);
 		free_htab_elem(htab, l);
-		ret =3D 0;
+	} else {
+		ret =3D -ENOENT;
 	}
=20
-	htab_unlock_bucket(htab, b, flags);
+	htab_unlock_bucket(htab, b, hash, flags);
 	return ret;
 }
=20
@@ -1257,7 +1299,7 @@ static int htab_lru_map_delete_elem(struct bpf_map =
*map, void *key)
 	struct htab_elem *l;
 	unsigned long flags;
 	u32 hash, key_size;
-	int ret =3D -ENOENT;
+	int ret;
=20
 	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held());
=20
@@ -1267,16 +1309,18 @@ static int htab_lru_map_delete_elem(struct bpf_ma=
p *map, void *key)
 	b =3D __select_bucket(htab, hash);
 	head =3D &b->head;
=20
-	flags =3D htab_lock_bucket(htab, b);
+	ret =3D htab_lock_bucket(htab, b, hash, &flags);
+	if (ret)
+		return ret;
=20
 	l =3D lookup_elem_raw(head, hash, key, key_size);
=20
-	if (l) {
+	if (l)
 		hlist_nulls_del_rcu(&l->hash_node);
-		ret =3D 0;
-	}
+	else
+		ret =3D -ENOENT;
=20
-	htab_unlock_bucket(htab, b, flags);
+	htab_unlock_bucket(htab, b, hash, flags);
 	if (l)
 		bpf_lru_push_free(&htab->lru, &l->lru_node);
 	return ret;
@@ -1302,6 +1346,7 @@ static void delete_all_elements(struct bpf_htab *ht=
ab)
 static void htab_map_free(struct bpf_map *map)
 {
 	struct bpf_htab *htab =3D container_of(map, struct bpf_htab, map);
+	int i;
=20
 	/* bpf_free_used_maps() or close(map_fd) will trigger this map_free cal=
lback.
 	 * bpf_free_used_maps() is called after bpf prog is no longer executing=
.
@@ -1320,6 +1365,8 @@ static void htab_map_free(struct bpf_map *map)
 	free_percpu(htab->extra_elems);
 	bpf_map_area_free(htab->buckets);
 	lockdep_unregister_key(&htab->lockdep_key);
+	for (i =3D 0; i < HASHTAB_MAP_LOCK_COUNT; i++)
+		free_percpu(htab->map_locked[i]);
 	kfree(htab);
 }
=20
@@ -1423,8 +1470,11 @@ __htab_map_lookup_and_delete_batch(struct bpf_map =
*map,
 	b =3D &htab->buckets[batch];
 	head =3D &b->head;
 	/* do not grab the lock unless need it (bucket_cnt > 0). */
-	if (locked)
-		flags =3D htab_lock_bucket(htab, b);
+	if (locked) {
+		ret =3D htab_lock_bucket(htab, b, batch, &flags);
+		if (ret)
+			goto next_batch;
+	}
=20
 	bucket_cnt =3D 0;
 	hlist_nulls_for_each_entry_rcu(l, n, head, hash_node)
@@ -1441,7 +1491,7 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *=
map,
 		/* Note that since bucket_cnt > 0 here, it is implicit
 		 * that the locked was grabbed, so release it.
 		 */
-		htab_unlock_bucket(htab, b, flags);
+		htab_unlock_bucket(htab, b, batch, flags);
 		rcu_read_unlock();
 		bpf_enable_instrumentation();
 		goto after_loop;
@@ -1452,7 +1502,7 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *=
map,
 		/* Note that since bucket_cnt > 0 here, it is implicit
 		 * that the locked was grabbed, so release it.
 		 */
-		htab_unlock_bucket(htab, b, flags);
+		htab_unlock_bucket(htab, b, batch, flags);
 		rcu_read_unlock();
 		bpf_enable_instrumentation();
 		kvfree(keys);
@@ -1505,7 +1555,7 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *=
map,
 		dst_val +=3D value_size;
 	}
=20
-	htab_unlock_bucket(htab, b, flags);
+	htab_unlock_bucket(htab, b, batch, flags);
 	locked =3D false;
=20
 	while (node_to_free) {
--=20
2.24.1

