Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2C63233BB
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 23:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbhBWWbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 17:31:03 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56612 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232297AbhBWW3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 17:29:46 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11NMRhu3021762
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 14:29:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=0saTt9K644f/9qL+P+3OCeD9fUjY5PxHUzgH5CApGF4=;
 b=NiVRWEhJqZeFBrpX7eBvs68qGaEyQaLs+Dffypj39so05o83aBpHjwdaqP9B6FEdgUMK
 azZLPWAE0xMo1WtnUVp4Z4MBUMOvn5q1bMlhXv+kxcn4YQKgwrWOI0rX97Aw2KSVQckP
 LkJhsbQs3jS86XgRbwZxwhTiQFqJsa8Rdq4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 36vx7am3xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 14:29:02 -0800
Received: from intmgw001.38.frc1.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Feb 2021 14:29:01 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 6791262E093E; Tue, 23 Feb 2021 14:28:58 -0800 (PST)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <peterz@infradead.org>, Song Liu <songliubraving@fb.com>
Subject: [PATCH v5 bpf-next 2/6] bpf: prevent deadlock from recursive bpf_task_storage_[get|delete]
Date:   Tue, 23 Feb 2021 14:28:41 -0800
Message-ID: <20210223222845.2866124-3-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210223222845.2866124-1-songliubraving@fb.com>
References: <20210223222845.2866124-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-23_11:2021-02-23,2021-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 bulkscore=0 mlxlogscore=695 phishscore=0 impostorscore=0
 clxscore=1015 mlxscore=0 suspectscore=0 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230189
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
 kernel/bpf/bpf_task_storage.c | 57 ++++++++++++++++++++++++++++++-----
 1 file changed, 50 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/bpf_task_storage.c b/kernel/bpf/bpf_task_storage.=
c
index baf3566e23233..d37650a1966f4 100644
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
--=20
2.24.1

