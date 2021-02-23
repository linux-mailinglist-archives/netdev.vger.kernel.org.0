Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C04322394
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 02:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbhBWBWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 20:22:25 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27532 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230281AbhBWBV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 20:21:57 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11N18srt004844
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 17:21:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=tegtRoxZbQEANY3ry/okuMc7Ni5e8cpq7CiiZL1xIVg=;
 b=i9cJBi7IucdXvt5HTcvKpLG2KPWtG3juZ6GS5QMPzyXwwrBfCimOrt+TFUXL/j7xwO48
 7Rjk/aR4JQGx/U7Pmdtnx/GodO5KIlQqvV70vzmNF5JEf2L4nER5EFH83Xq1Ca2EDoq6
 TyHJzjOd14oMzPR4qLHyCekpRsjaYmFYJfc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 36uk0n0kxb-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 17:21:13 -0800
Received: from intmgw001.05.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 22 Feb 2021 17:21:12 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id DB7C862E0887; Mon, 22 Feb 2021 17:21:09 -0800 (PST)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <peterz@infradead.org>, Song Liu <songliubraving@fb.com>,
        KP Singh <kpsingh@kernel.org>
Subject: [PATCH v4 bpf-next 1/6] bpf: enable task local storage for tracing programs
Date:   Mon, 22 Feb 2021 17:20:09 -0800
Message-ID: <20210223012014.2087583-2-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210223012014.2087583-1-songliubraving@fb.com>
References: <20210223012014.2087583-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-22_08:2021-02-22,2021-02-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 malwarescore=0 bulkscore=0 phishscore=0
 adultscore=0 clxscore=1015 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230006
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To access per-task data, BPF programs usually creates a hash table with
pid as the key. This is not ideal because:
 1. The user need to estimate the proper size of the hash table, which ma=
y
    be inaccurate;
 2. Big hash tables are slow;
 3. To clean up the data properly during task terminations, the user need
    to write extra logic.

Task local storage overcomes these issues and offers a better option for
these per-task data. Task local storage is only available to BPF_LSM. Now
enable it for tracing programs.

Unlike LSM programs, tracing programs can be called in IRQ contexts.
Helpers that access task local storage are updated to use
raw_spin_lock_irqsave() instead of raw_spin_lock_bh().

Tracing programs can attach to functions on the task free path, e.g.
exit_creds(). To avoid allocating task local storage after
bpf_task_storage_free(). bpf_task_storage_get() is updated to not allocat=
e
new storage when the task is not refcounted (task->usage =3D=3D 0).

Acked-by: KP Singh <kpsingh@kernel.org>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 include/linux/bpf.h            |  7 +++++++
 include/linux/bpf_lsm.h        | 22 ----------------------
 include/linux/bpf_types.h      |  2 +-
 include/linux/sched.h          |  5 +++++
 kernel/bpf/Makefile            |  3 +--
 kernel/bpf/bpf_local_storage.c | 28 +++++++++++++++++-----------
 kernel/bpf/bpf_lsm.c           |  4 ----
 kernel/bpf/bpf_task_storage.c  | 34 +++++++++-------------------------
 kernel/fork.c                  |  5 +++++
 kernel/trace/bpf_trace.c       |  4 ++++
 10 files changed, 49 insertions(+), 65 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index cccaef1088eae..e2cfc4809219c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1499,6 +1499,7 @@ struct bpf_prog *bpf_prog_by_id(u32 id);
 struct bpf_link *bpf_link_by_id(u32 id);
=20
 const struct bpf_func_proto *bpf_base_func_proto(enum bpf_func_id func_i=
d);
+void bpf_task_storage_free(struct task_struct *task);
 #else /* !CONFIG_BPF_SYSCALL */
 static inline struct bpf_prog *bpf_prog_get(u32 ufd)
 {
@@ -1684,6 +1685,10 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 {
 	return NULL;
 }
+
+static inline void bpf_task_storage_free(struct task_struct *task)
+{
+}
 #endif /* CONFIG_BPF_SYSCALL */
=20
 void __bpf_free_used_btfs(struct bpf_prog_aux *aux,
@@ -1886,6 +1891,8 @@ extern const struct bpf_func_proto bpf_this_cpu_ptr=
_proto;
 extern const struct bpf_func_proto bpf_ktime_get_coarse_ns_proto;
 extern const struct bpf_func_proto bpf_sock_from_file_proto;
 extern const struct bpf_func_proto bpf_get_socket_ptr_cookie_proto;
+extern const struct bpf_func_proto bpf_task_storage_get_proto;
+extern const struct bpf_func_proto bpf_task_storage_delete_proto;
=20
 const struct bpf_func_proto *bpf_tracing_func_proto(
 	enum bpf_func_id func_id, const struct bpf_prog *prog);
diff --git a/include/linux/bpf_lsm.h b/include/linux/bpf_lsm.h
index 0d1c33ace3987..479c101546ad1 100644
--- a/include/linux/bpf_lsm.h
+++ b/include/linux/bpf_lsm.h
@@ -38,21 +38,9 @@ static inline struct bpf_storage_blob *bpf_inode(
 	return inode->i_security + bpf_lsm_blob_sizes.lbs_inode;
 }
=20
-static inline struct bpf_storage_blob *bpf_task(
-	const struct task_struct *task)
-{
-	if (unlikely(!task->security))
-		return NULL;
-
-	return task->security + bpf_lsm_blob_sizes.lbs_task;
-}
-
 extern const struct bpf_func_proto bpf_inode_storage_get_proto;
 extern const struct bpf_func_proto bpf_inode_storage_delete_proto;
-extern const struct bpf_func_proto bpf_task_storage_get_proto;
-extern const struct bpf_func_proto bpf_task_storage_delete_proto;
 void bpf_inode_storage_free(struct inode *inode);
-void bpf_task_storage_free(struct task_struct *task);
=20
 #else /* !CONFIG_BPF_LSM */
=20
@@ -73,20 +61,10 @@ static inline struct bpf_storage_blob *bpf_inode(
 	return NULL;
 }
=20
-static inline struct bpf_storage_blob *bpf_task(
-	const struct task_struct *task)
-{
-	return NULL;
-}
-
 static inline void bpf_inode_storage_free(struct inode *inode)
 {
 }
=20
-static inline void bpf_task_storage_free(struct task_struct *task)
-{
-}
-
 #endif /* CONFIG_BPF_LSM */
=20
 #endif /* _LINUX_BPF_LSM_H */
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 99f7fd657d87a..b9edee336d804 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -109,8 +109,8 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_SOCKHASH, sock_hash_ops)
 #endif
 #ifdef CONFIG_BPF_LSM
 BPF_MAP_TYPE(BPF_MAP_TYPE_INODE_STORAGE, inode_storage_map_ops)
-BPF_MAP_TYPE(BPF_MAP_TYPE_TASK_STORAGE, task_storage_map_ops)
 #endif
+BPF_MAP_TYPE(BPF_MAP_TYPE_TASK_STORAGE, task_storage_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_CPUMAP, cpu_map_ops)
 #if defined(CONFIG_XDP_SOCKETS)
 BPF_MAP_TYPE(BPF_MAP_TYPE_XSKMAP, xsk_map_ops)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4d568288abf9f..e5fbf8e6952ab 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -42,6 +42,7 @@ struct audit_context;
 struct backing_dev_info;
 struct bio_list;
 struct blk_plug;
+struct bpf_local_storage;
 struct capture_control;
 struct cfs_rq;
 struct fs_struct;
@@ -1348,6 +1349,10 @@ struct task_struct {
 	/* Used by LSM modules for access restriction: */
 	void				*security;
 #endif
+#ifdef CONFIG_BPF_SYSCALL
+	/* Used by BPF task local storage */
+	struct bpf_local_storage __rcu	*bpf_storage;
+#endif
=20
 #ifdef CONFIG_GCC_PLUGIN_STACKLEAK
 	unsigned long			lowest_stack;
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index d1249340fd6ba..ca995fdfa45e7 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -8,9 +8,8 @@ CFLAGS_core.o +=3D $(call cc-disable-warning, override-in=
it) $(cflags-nogcse-yy)
=20
 obj-$(CONFIG_BPF_SYSCALL) +=3D syscall.o verifier.o inode.o helpers.o tn=
um.o bpf_iter.o map_iter.o task_iter.o prog_iter.o
 obj-$(CONFIG_BPF_SYSCALL) +=3D hashtab.o arraymap.o percpu_freelist.o bp=
f_lru_list.o lpm_trie.o map_in_map.o
-obj-$(CONFIG_BPF_SYSCALL) +=3D local_storage.o queue_stack_maps.o ringbu=
f.o
+obj-$(CONFIG_BPF_SYSCALL) +=3D local_storage.o queue_stack_maps.o ringbu=
f.o bpf_task_storage.o
 obj-${CONFIG_BPF_LSM}	  +=3D bpf_inode_storage.o
-obj-${CONFIG_BPF_LSM}	  +=3D bpf_task_storage.o
 obj-$(CONFIG_BPF_SYSCALL) +=3D disasm.o
 obj-$(CONFIG_BPF_JIT) +=3D trampoline.o
 obj-$(CONFIG_BPF_SYSCALL) +=3D btf.o
diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storag=
e.c
index dd5aedee99e73..9bd47ad2b26f1 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -140,17 +140,18 @@ static void __bpf_selem_unlink_storage(struct bpf_l=
ocal_storage_elem *selem)
 {
 	struct bpf_local_storage *local_storage;
 	bool free_local_storage =3D false;
+	unsigned long flags;
=20
 	if (unlikely(!selem_linked_to_storage(selem)))
 		/* selem has already been unlinked from sk */
 		return;
=20
 	local_storage =3D rcu_dereference(selem->local_storage);
-	raw_spin_lock_bh(&local_storage->lock);
+	raw_spin_lock_irqsave(&local_storage->lock, flags);
 	if (likely(selem_linked_to_storage(selem)))
 		free_local_storage =3D bpf_selem_unlink_storage_nolock(
 			local_storage, selem, true);
-	raw_spin_unlock_bh(&local_storage->lock);
+	raw_spin_unlock_irqrestore(&local_storage->lock, flags);
=20
 	if (free_local_storage)
 		kfree_rcu(local_storage, rcu);
@@ -167,6 +168,7 @@ void bpf_selem_unlink_map(struct bpf_local_storage_el=
em *selem)
 {
 	struct bpf_local_storage_map *smap;
 	struct bpf_local_storage_map_bucket *b;
+	unsigned long flags;
=20
 	if (unlikely(!selem_linked_to_map(selem)))
 		/* selem has already be unlinked from smap */
@@ -174,21 +176,22 @@ void bpf_selem_unlink_map(struct bpf_local_storage_=
elem *selem)
=20
 	smap =3D rcu_dereference(SDATA(selem)->smap);
 	b =3D select_bucket(smap, selem);
-	raw_spin_lock_bh(&b->lock);
+	raw_spin_lock_irqsave(&b->lock, flags);
 	if (likely(selem_linked_to_map(selem)))
 		hlist_del_init_rcu(&selem->map_node);
-	raw_spin_unlock_bh(&b->lock);
+	raw_spin_unlock_irqrestore(&b->lock, flags);
 }
=20
 void bpf_selem_link_map(struct bpf_local_storage_map *smap,
 			struct bpf_local_storage_elem *selem)
 {
 	struct bpf_local_storage_map_bucket *b =3D select_bucket(smap, selem);
+	unsigned long flags;
=20
-	raw_spin_lock_bh(&b->lock);
+	raw_spin_lock_irqsave(&b->lock, flags);
 	RCU_INIT_POINTER(SDATA(selem)->smap, smap);
 	hlist_add_head_rcu(&selem->map_node, &b->list);
-	raw_spin_unlock_bh(&b->lock);
+	raw_spin_unlock_irqrestore(&b->lock, flags);
 }
=20
 void bpf_selem_unlink(struct bpf_local_storage_elem *selem)
@@ -224,16 +227,18 @@ bpf_local_storage_lookup(struct bpf_local_storage *=
local_storage,
=20
 	sdata =3D SDATA(selem);
 	if (cacheit_lockit) {
+		unsigned long flags;
+
 		/* spinlock is needed to avoid racing with the
 		 * parallel delete.  Otherwise, publishing an already
 		 * deleted sdata to the cache will become a use-after-free
 		 * problem in the next bpf_local_storage_lookup().
 		 */
-		raw_spin_lock_bh(&local_storage->lock);
+		raw_spin_lock_irqsave(&local_storage->lock, flags);
 		if (selem_linked_to_storage(selem))
 			rcu_assign_pointer(local_storage->cache[smap->cache_idx],
 					   sdata);
-		raw_spin_unlock_bh(&local_storage->lock);
+		raw_spin_unlock_irqrestore(&local_storage->lock, flags);
 	}
=20
 	return sdata;
@@ -327,6 +332,7 @@ bpf_local_storage_update(void *owner, struct bpf_loca=
l_storage_map *smap,
 	struct bpf_local_storage_data *old_sdata =3D NULL;
 	struct bpf_local_storage_elem *selem;
 	struct bpf_local_storage *local_storage;
+	unsigned long flags;
 	int err;
=20
 	/* BPF_EXIST and BPF_NOEXIST cannot be both set */
@@ -374,7 +380,7 @@ bpf_local_storage_update(void *owner, struct bpf_loca=
l_storage_map *smap,
 		}
 	}
=20
-	raw_spin_lock_bh(&local_storage->lock);
+	raw_spin_lock_irqsave(&local_storage->lock, flags);
=20
 	/* Recheck local_storage->list under local_storage->lock */
 	if (unlikely(hlist_empty(&local_storage->list))) {
@@ -428,11 +434,11 @@ bpf_local_storage_update(void *owner, struct bpf_lo=
cal_storage_map *smap,
 	}
=20
 unlock:
-	raw_spin_unlock_bh(&local_storage->lock);
+	raw_spin_unlock_irqrestore(&local_storage->lock, flags);
 	return SDATA(selem);
=20
 unlock_err:
-	raw_spin_unlock_bh(&local_storage->lock);
+	raw_spin_unlock_irqrestore(&local_storage->lock, flags);
 	return ERR_PTR(err);
 }
=20
diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 1622a44d1617e..9829f381b51c5 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -115,10 +115,6 @@ bpf_lsm_func_proto(enum bpf_func_id func_id, const s=
truct bpf_prog *prog)
 		return &bpf_spin_lock_proto;
 	case BPF_FUNC_spin_unlock:
 		return &bpf_spin_unlock_proto;
-	case BPF_FUNC_task_storage_get:
-		return &bpf_task_storage_get_proto;
-	case BPF_FUNC_task_storage_delete:
-		return &bpf_task_storage_delete_proto;
 	case BPF_FUNC_bprm_opts_set:
 		return &bpf_bprm_opts_set_proto;
 	case BPF_FUNC_ima_inode_hash:
diff --git a/kernel/bpf/bpf_task_storage.c b/kernel/bpf/bpf_task_storage.=
c
index e0da0258b732d..2034019966d44 100644
--- a/kernel/bpf/bpf_task_storage.c
+++ b/kernel/bpf/bpf_task_storage.c
@@ -15,7 +15,6 @@
 #include <linux/bpf_local_storage.h>
 #include <linux/filter.h>
 #include <uapi/linux/btf.h>
-#include <linux/bpf_lsm.h>
 #include <linux/btf_ids.h>
 #include <linux/fdtable.h>
=20
@@ -24,12 +23,8 @@ DEFINE_BPF_STORAGE_CACHE(task_cache);
 static struct bpf_local_storage __rcu **task_storage_ptr(void *owner)
 {
 	struct task_struct *task =3D owner;
-	struct bpf_storage_blob *bsb;
=20
-	bsb =3D bpf_task(task);
-	if (!bsb)
-		return NULL;
-	return &bsb->storage;
+	return &task->bpf_storage;
 }
=20
 static struct bpf_local_storage_data *
@@ -38,13 +33,8 @@ task_storage_lookup(struct task_struct *task, struct b=
pf_map *map,
 {
 	struct bpf_local_storage *task_storage;
 	struct bpf_local_storage_map *smap;
-	struct bpf_storage_blob *bsb;
-
-	bsb =3D bpf_task(task);
-	if (!bsb)
-		return NULL;
=20
-	task_storage =3D rcu_dereference(bsb->storage);
+	task_storage =3D rcu_dereference(task->bpf_storage);
 	if (!task_storage)
 		return NULL;
=20
@@ -57,16 +47,12 @@ void bpf_task_storage_free(struct task_struct *task)
 	struct bpf_local_storage_elem *selem;
 	struct bpf_local_storage *local_storage;
 	bool free_task_storage =3D false;
-	struct bpf_storage_blob *bsb;
 	struct hlist_node *n;
-
-	bsb =3D bpf_task(task);
-	if (!bsb)
-		return;
+	unsigned long flags;
=20
 	rcu_read_lock();
=20
-	local_storage =3D rcu_dereference(bsb->storage);
+	local_storage =3D rcu_dereference(task->bpf_storage);
 	if (!local_storage) {
 		rcu_read_unlock();
 		return;
@@ -81,7 +67,7 @@ void bpf_task_storage_free(struct task_struct *task)
 	 * when unlinking elem from the local_storage->list and
 	 * the map's bucket->list.
 	 */
-	raw_spin_lock_bh(&local_storage->lock);
+	raw_spin_lock_irqsave(&local_storage->lock, flags);
 	hlist_for_each_entry_safe(selem, n, &local_storage->list, snode) {
 		/* Always unlink from map before unlinking from
 		 * local_storage.
@@ -90,7 +76,7 @@ void bpf_task_storage_free(struct task_struct *task)
 		free_task_storage =3D bpf_selem_unlink_storage_nolock(
 			local_storage, selem, false);
 	}
-	raw_spin_unlock_bh(&local_storage->lock);
+	raw_spin_unlock_irqrestore(&local_storage->lock, flags);
 	rcu_read_unlock();
=20
 	/* free_task_storage should always be true as long as
@@ -225,11 +211,9 @@ BPF_CALL_4(bpf_task_storage_get, struct bpf_map *, m=
ap, struct task_struct *,
 	if (sdata)
 		return (unsigned long)sdata->data;
=20
-	/* This helper must only be called from places where the lifetime of th=
e task
-	 * is guaranteed. Either by being refcounted or by being protected
-	 * by an RCU read-side critical section.
-	 */
-	if (flags & BPF_LOCAL_STORAGE_GET_F_CREATE) {
+	/* only allocate new storage, when the task is refcounted */
+	if (refcount_read(&task->usage) &&
+	    (flags & BPF_LOCAL_STORAGE_GET_F_CREATE)) {
 		sdata =3D bpf_local_storage_update(
 			task, (struct bpf_local_storage_map *)map, value,
 			BPF_NOEXIST);
diff --git a/kernel/fork.c b/kernel/fork.c
index d66cd1014211b..181604db2d65e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -96,6 +96,7 @@
 #include <linux/kasan.h>
 #include <linux/scs.h>
 #include <linux/io_uring.h>
+#include <linux/bpf.h>
=20
 #include <asm/pgalloc.h>
 #include <linux/uaccess.h>
@@ -734,6 +735,7 @@ void __put_task_struct(struct task_struct *tsk)
 	cgroup_free(tsk);
 	task_numa_free(tsk, true);
 	security_task_free(tsk);
+	bpf_task_storage_free(tsk);
 	exit_creds(tsk);
 	delayacct_tsk_free(tsk);
 	put_signal_struct(tsk->signal);
@@ -2062,6 +2064,9 @@ static __latent_entropy struct task_struct *copy_pr=
ocess(
 	p->sequential_io	=3D 0;
 	p->sequential_io_avg	=3D 0;
 #endif
+#ifdef CONFIG_BPF_SYSCALL
+	RCU_INIT_POINTER(p->bpf_storage, NULL);
+#endif
=20
 	/* Perform scheduler related setup. Assign this task to a CPU. */
 	retval =3D sched_fork(clone_flags, p);
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index b0c45d923f0f9..e9701744d8e4c 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1367,6 +1367,10 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, c=
onst struct bpf_prog *prog)
 		return &bpf_per_cpu_ptr_proto;
 	case BPF_FUNC_this_cpu_ptr:
 		return &bpf_this_cpu_ptr_proto;
+	case BPF_FUNC_task_storage_get:
+		return &bpf_task_storage_get_proto;
+	case BPF_FUNC_task_storage_delete:
+		return &bpf_task_storage_delete_proto;
 	default:
 		return NULL;
 	}
--=20
2.24.1

