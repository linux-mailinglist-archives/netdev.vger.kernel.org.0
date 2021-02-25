Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBE5325A56
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 00:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232791AbhBYXov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 18:44:51 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:2924 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232077AbhBYXo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 18:44:26 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11PNhhOQ014138
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 15:43:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=E0ULp9pT+e++iTwzoI3j7hl8M6GoQAkpZEJr2rX/hkE=;
 b=Y5w8RnwLPX8ObStJkk9f9SHii+8RVMgFZ0O/xSG1CQm5Oc7SqXc8wJ3SBd+xyQ7GUumx
 db/9a/v78MBox9eY8OnAxsYT+A0Yk+dH0BL/X7OVZ/breThu2Vzj9LGVa2UCukFvObBP
 /Lmins/prxdIqGtIG6O+EqUy31JTT2/3PxY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 36x96bvgu1-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 15:43:45 -0800
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 25 Feb 2021 15:43:43 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 2AEB662E1BF5; Thu, 25 Feb 2021 15:43:39 -0800 (PST)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <peterz@infradead.org>, Song Liu <songliubraving@fb.com>
Subject: [PATCH v6 bpf-next 2/6] bpf: prevent deadlock from recursive bpf_task_storage_[get|delete]
Date:   Thu, 25 Feb 2021 15:43:15 -0800
Message-ID: <20210225234319.336131-3-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210225234319.336131-1-songliubraving@fb.com>
References: <20210225234319.336131-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-25_15:2021-02-24,2021-02-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 phishscore=0 mlxscore=0
 adultscore=0 malwarescore=0 impostorscore=0 priorityscore=1501
 mlxlogscore=743 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102250180
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF helpers bpf_task_storage_[get|delete] could hold two locks:
bpf_local_storage_map_bucket->lock and bpf_local_storage->lock. Calling
these helpers from fentry/fexit programs on functions in bpf_*_storage.c
may cause deadlock on either locks.

Prevent such deadlock with a per cpu counter, bpf_task_storage_busy. We
need this counter to be global, because the two locks here belong to two
different objects: bpf_local_storage_map and bpf_local_storage. If we
pick one of them as the owner of the counter, it is still possible to
trigger deadlock on the other lock. For example, if bpf_local_storage_map
owns the counters, it cannot prevent deadlock on bpf_local_storage->lock
when two maps are used.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 include/linux/bpf_local_storage.h |  3 +-
 kernel/bpf/bpf_inode_storage.c    |  2 +-
 kernel/bpf/bpf_local_storage.c    | 11 +++++-
 kernel/bpf/bpf_task_storage.c     | 59 ++++++++++++++++++++++++++-----
 net/core/bpf_sk_storage.c         |  2 +-
 5 files changed, 65 insertions(+), 12 deletions(-)

diff --git a/include/linux/bpf_local_storage.h b/include/linux/bpf_local_=
storage.h
index b2c9463f36a1b..b902c580c48d5 100644
--- a/include/linux/bpf_local_storage.h
+++ b/include/linux/bpf_local_storage.h
@@ -126,7 +126,8 @@ bpf_local_storage_lookup(struct bpf_local_storage *lo=
cal_storage,
 			 struct bpf_local_storage_map *smap,
 			 bool cacheit_lockit);
=20
-void bpf_local_storage_map_free(struct bpf_local_storage_map *smap);
+void bpf_local_storage_map_free(struct bpf_local_storage_map *smap,
+				int __percpu *busy_counter);
=20
 int bpf_local_storage_map_check_btf(const struct bpf_map *map,
 				    const struct btf *btf,
diff --git a/kernel/bpf/bpf_inode_storage.c b/kernel/bpf/bpf_inode_storag=
e.c
index 6639640523c0b..da753721457cb 100644
--- a/kernel/bpf/bpf_inode_storage.c
+++ b/kernel/bpf/bpf_inode_storage.c
@@ -237,7 +237,7 @@ static void inode_storage_map_free(struct bpf_map *ma=
p)
=20
 	smap =3D (struct bpf_local_storage_map *)map;
 	bpf_local_storage_cache_idx_free(&inode_cache, smap->cache_idx);
-	bpf_local_storage_map_free(smap);
+	bpf_local_storage_map_free(smap, NULL);
 }
=20
 static int inode_storage_map_btf_id;
diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storag=
e.c
index 9bd47ad2b26f1..b305270b7a4bd 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -474,7 +474,8 @@ void bpf_local_storage_cache_idx_free(struct bpf_loca=
l_storage_cache *cache,
 	spin_unlock(&cache->idx_lock);
 }
=20
-void bpf_local_storage_map_free(struct bpf_local_storage_map *smap)
+void bpf_local_storage_map_free(struct bpf_local_storage_map *smap,
+				int __percpu *busy_counter)
 {
 	struct bpf_local_storage_elem *selem;
 	struct bpf_local_storage_map_bucket *b;
@@ -503,7 +504,15 @@ void bpf_local_storage_map_free(struct bpf_local_sto=
rage_map *smap)
 		while ((selem =3D hlist_entry_safe(
 				rcu_dereference_raw(hlist_first_rcu(&b->list)),
 				struct bpf_local_storage_elem, map_node))) {
+			if (busy_counter) {
+				migrate_disable();
+				__this_cpu_inc(*busy_counter);
+			}
 			bpf_selem_unlink(selem);
+			if (busy_counter) {
+				__this_cpu_dec(*busy_counter);
+				migrate_enable();
+			}
 			cond_resched_rcu();
 		}
 		rcu_read_unlock();
diff --git a/kernel/bpf/bpf_task_storage.c b/kernel/bpf/bpf_task_storage.=
c
index baf3566e23233..fd3c74ef608ef 100644
--- a/kernel/bpf/bpf_task_storage.c
+++ b/kernel/bpf/bpf_task_storage.c
@@ -20,6 +20,31 @@
=20
 DEFINE_BPF_STORAGE_CACHE(task_cache);
=20
+DEFINE_PER_CPU(int, bpf_task_storage_busy);
+
+static void bpf_task_storage_lock(void)
+{
+	migrate_disable();
+	__this_cpu_inc(bpf_task_storage_busy);
+}
+
+static void bpf_task_storage_unlock(void)
+{
+	__this_cpu_dec(bpf_task_storage_busy);
+	migrate_enable();
+}
+
+static bool bpf_task_storage_trylock(void)
+{
+	migrate_disable();
+	if (unlikely(__this_cpu_inc_return(bpf_task_storage_busy) !=3D 1)) {
+		__this_cpu_dec(bpf_task_storage_busy);
+		migrate_enable();
+		return false;
+	}
+	return true;
+}
+
 static struct bpf_local_storage __rcu **task_storage_ptr(void *owner)
 {
 	struct task_struct *task =3D owner;
@@ -67,6 +92,7 @@ void bpf_task_storage_free(struct task_struct *task)
 	 * when unlinking elem from the local_storage->list and
 	 * the map's bucket->list.
 	 */
+	bpf_task_storage_lock();
 	raw_spin_lock_irqsave(&local_storage->lock, flags);
 	hlist_for_each_entry_safe(selem, n, &local_storage->list, snode) {
 		/* Always unlink from map before unlinking from
@@ -77,6 +103,7 @@ void bpf_task_storage_free(struct task_struct *task)
 			local_storage, selem, false);
 	}
 	raw_spin_unlock_irqrestore(&local_storage->lock, flags);
+	bpf_task_storage_unlock();
 	rcu_read_unlock();
=20
 	/* free_task_storage should always be true as long as
@@ -109,7 +136,9 @@ static void *bpf_pid_task_storage_lookup_elem(struct =
bpf_map *map, void *key)
 		goto out;
 	}
=20
+	bpf_task_storage_lock();
 	sdata =3D task_storage_lookup(task, map, true);
+	bpf_task_storage_unlock();
 	put_pid(pid);
 	return sdata ? sdata->data : NULL;
 out:
@@ -141,8 +170,10 @@ static int bpf_pid_task_storage_update_elem(struct b=
pf_map *map, void *key,
 		goto out;
 	}
=20
+	bpf_task_storage_lock();
 	sdata =3D bpf_local_storage_update(
 		task, (struct bpf_local_storage_map *)map, value, map_flags);
+	bpf_task_storage_unlock();
=20
 	err =3D PTR_ERR_OR_ZERO(sdata);
 out:
@@ -185,7 +216,9 @@ static int bpf_pid_task_storage_delete_elem(struct bp=
f_map *map, void *key)
 		goto out;
 	}
=20
+	bpf_task_storage_lock();
 	err =3D task_storage_delete(task, map);
+	bpf_task_storage_unlock();
 out:
 	put_pid(pid);
 	return err;
@@ -202,34 +235,44 @@ BPF_CALL_4(bpf_task_storage_get, struct bpf_map *, =
map, struct task_struct *,
 	if (!task)
 		return (unsigned long)NULL;
=20
+	if (!bpf_task_storage_trylock())
+		return (unsigned long)NULL;
+
 	sdata =3D task_storage_lookup(task, map, true);
 	if (sdata)
-		return (unsigned long)sdata->data;
+		goto unlock;
=20
 	/* only allocate new storage, when the task is refcounted */
 	if (refcount_read(&task->usage) &&
-	    (flags & BPF_LOCAL_STORAGE_GET_F_CREATE)) {
+	    (flags & BPF_LOCAL_STORAGE_GET_F_CREATE))
 		sdata =3D bpf_local_storage_update(
 			task, (struct bpf_local_storage_map *)map, value,
 			BPF_NOEXIST);
-		return IS_ERR(sdata) ? (unsigned long)NULL :
-					     (unsigned long)sdata->data;
-	}
=20
-	return (unsigned long)NULL;
+unlock:
+	bpf_task_storage_unlock();
+	return IS_ERR_OR_NULL(sdata) ? (unsigned long)NULL :
+		(unsigned long)sdata->data;
 }
=20
 BPF_CALL_2(bpf_task_storage_delete, struct bpf_map *, map, struct task_s=
truct *,
 	   task)
 {
+	int ret;
+
 	if (!task)
 		return -EINVAL;
=20
+	if (!bpf_task_storage_trylock())
+		return -EBUSY;
+
 	/* This helper must only be called from places where the lifetime of th=
e task
 	 * is guaranteed. Either by being refcounted or by being protected
 	 * by an RCU read-side critical section.
 	 */
-	return task_storage_delete(task, map);
+	ret =3D task_storage_delete(task, map);
+	bpf_task_storage_unlock();
+	return ret;
 }
=20
 static int notsupp_get_next_key(struct bpf_map *map, void *key, void *ne=
xt_key)
@@ -255,7 +298,7 @@ static void task_storage_map_free(struct bpf_map *map=
)
=20
 	smap =3D (struct bpf_local_storage_map *)map;
 	bpf_local_storage_cache_idx_free(&task_cache, smap->cache_idx);
-	bpf_local_storage_map_free(smap);
+	bpf_local_storage_map_free(smap, &bpf_task_storage_busy);
 }
=20
 static int task_storage_map_btf_id;
diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index 4edd033e899c0..cc3712ad8716f 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -89,7 +89,7 @@ static void bpf_sk_storage_map_free(struct bpf_map *map=
)
=20
 	smap =3D (struct bpf_local_storage_map *)map;
 	bpf_local_storage_cache_idx_free(&sk_cache, smap->cache_idx);
-	bpf_local_storage_map_free(smap);
+	bpf_local_storage_map_free(smap, NULL);
 }
=20
 static struct bpf_map *bpf_sk_storage_map_alloc(union bpf_attr *attr)
--=20
2.24.1

