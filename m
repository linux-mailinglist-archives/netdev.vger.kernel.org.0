Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBC23C2C4D
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 03:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhGJBOI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 9 Jul 2021 21:14:08 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7874 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229506AbhGJBOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 21:14:08 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16A1AL7e021197
        for <netdev@vger.kernel.org>; Fri, 9 Jul 2021 18:11:23 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 39pt84jchx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 09 Jul 2021 18:11:23 -0700
Received: from intmgw001.05.ash7.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 9 Jul 2021 18:11:22 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 94D2E3D40D49; Fri,  9 Jul 2021 18:11:20 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <linux-kernel@vger.kernel.org>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf-next] bpf: add ambient BPF runtime context stored in current
Date:   Fri, 9 Jul 2021 18:11:17 -0700
Message-ID: <20210710011117.1235487-1-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Zzv5Jow-3jlwMhXxSz5U-vWfg3UQ9YGu
X-Proofpoint-GUID: Zzv5Jow-3jlwMhXxSz5U-vWfg3UQ9YGu
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-09_18:2021-07-09,2021-07-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1034
 mlxlogscore=999 suspectscore=0 priorityscore=1501 phishscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 impostorscore=0 adultscore=0 lowpriorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107100005
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

b910eaaaa4b8 ("bpf: Fix NULL pointer dereference in bpf_get_local_storage()
helper") fixed the problem with cgroup-local storage use in BPF by
pre-allocating per-CPU array of 8 cgroup storage pointers to accommodate
possible BPF program preemptions and nested executions.

While this seems to work good in practice, it introduces new and unnecessary
failure mode in which not all BPF programs might be executed if we fail to
find an unused slot for cgroup storage, however unlikely it is. It might also
not be so unlikely when/if we allow sleepable cgroup BPF programs in the
future.

Further, the way that cgroup storage is implemented as ambiently-available
property during entire BPF program execution is a convenient way to pass extra
information to BPF program and helpers without requiring user code to pass
around extra arguments explicitly. So it would be good to have a generic
solution that can allow implementing this without arbitrary restrictions.
Ideally, such solution would work for both preemptable and sleepable BPF
programs in exactly the same way.

This patch introduces such solution, bpf_run_ctx. It adds one pointer field
(bpf_ctx) to task_struct. This field is maintained by BPF_PROG_RUN family of
macros in such a way that it always stays valid throughout BPF program
execution. BPF program preemption is handled by remembering previous
current->bpf_ctx value locally while executing nested BPF program and
restoring old value after nested BPF program finishes. This is handled by two
helper functions, bpf_set_run_ctx() and bpf_reset_run_ctx(), which are
supposed to be used before and after BPF program runs, respectively.

Restoring old value of the pointer handles preemption, while bpf_run_ctx
pointer being a property of current task_struct naturally solves this problem
for sleepable BPF programs by "following" BPF program execution as it is
scheduled in and out of CPU. It would even allow CPU migration of BPF
programs, even though it's not currently allowed by BPF infra.

This patch cleans up cgroup local storage handling as a first application. The
design itself is generic, though, with bpf_run_ctx being an empty struct that
is supposed to be embedded into a specific struct for a given BPF program type
(bpf_cg_run_ctx in this case). Follow up patches are planned that will expand
this mechanism for other uses within tracing BPF programs.

To verify that this change doesn't revert the fix to the original cgroup
storage issue, I ran the same repro as in the original report ([0]) and didn't
get any problems. Replacing bpf_reset_run_ctx(old_run_ctx) with
bpf_reset_run_ctx(NULL) triggers the issue pretty quickly (so repro does work).

  [0] https://lore.kernel.org/bpf/YEEvBUiJl2pJkxTd@krava/

Cc: Yonghong Song <yhs@fb.com>
Fixes: b910eaaaa4b8 ("bpf: Fix NULL pointer dereference in bpf_get_local_storage() helper")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 include/linux/bpf-cgroup.h | 54 --------------------------------------
 include/linux/bpf.h        | 54 ++++++++++++++++++++++++--------------
 include/linux/sched.h      |  3 +++
 kernel/bpf/helpers.c       | 16 ++++-------
 kernel/bpf/local_storage.c |  3 ---
 kernel/fork.c              |  1 +
 net/bpf/test_run.c         | 23 ++++++++--------
 7 files changed, 54 insertions(+), 100 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 8b77d08d4b47..a74cd1c3bd87 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -27,19 +27,6 @@ struct task_struct;
 extern struct static_key_false cgroup_bpf_enabled_key[MAX_BPF_ATTACH_TYPE];
 #define cgroup_bpf_enabled(type) static_branch_unlikely(&cgroup_bpf_enabled_key[type])
 
-#define BPF_CGROUP_STORAGE_NEST_MAX	8
-
-struct bpf_cgroup_storage_info {
-	struct task_struct *task;
-	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE];
-};
-
-/* For each cpu, permit maximum BPF_CGROUP_STORAGE_NEST_MAX number of tasks
- * to use bpf cgroup storage simultaneously.
- */
-DECLARE_PER_CPU(struct bpf_cgroup_storage_info,
-		bpf_cgroup_storage_info[BPF_CGROUP_STORAGE_NEST_MAX]);
-
 #define for_each_cgroup_storage_type(stype) \
 	for (stype = 0; stype < MAX_BPF_CGROUP_STORAGE_TYPE; stype++)
 
@@ -172,44 +159,6 @@ static inline enum bpf_cgroup_storage_type cgroup_storage_type(
 	return BPF_CGROUP_STORAGE_SHARED;
 }
 
-static inline int bpf_cgroup_storage_set(struct bpf_cgroup_storage
-					 *storage[MAX_BPF_CGROUP_STORAGE_TYPE])
-{
-	enum bpf_cgroup_storage_type stype;
-	int i, err = 0;
-
-	preempt_disable();
-	for (i = 0; i < BPF_CGROUP_STORAGE_NEST_MAX; i++) {
-		if (unlikely(this_cpu_read(bpf_cgroup_storage_info[i].task) != NULL))
-			continue;
-
-		this_cpu_write(bpf_cgroup_storage_info[i].task, current);
-		for_each_cgroup_storage_type(stype)
-			this_cpu_write(bpf_cgroup_storage_info[i].storage[stype],
-				       storage[stype]);
-		goto out;
-	}
-	err = -EBUSY;
-	WARN_ON_ONCE(1);
-
-out:
-	preempt_enable();
-	return err;
-}
-
-static inline void bpf_cgroup_storage_unset(void)
-{
-	int i;
-
-	for (i = 0; i < BPF_CGROUP_STORAGE_NEST_MAX; i++) {
-		if (unlikely(this_cpu_read(bpf_cgroup_storage_info[i].task) != current))
-			continue;
-
-		this_cpu_write(bpf_cgroup_storage_info[i].task, NULL);
-		return;
-	}
-}
-
 struct bpf_cgroup_storage *
 cgroup_storage_lookup(struct bpf_cgroup_storage_map *map,
 		      void *key, bool locked);
@@ -487,9 +436,6 @@ static inline int cgroup_bpf_prog_query(const union bpf_attr *attr,
 	return -EINVAL;
 }
 
-static inline int bpf_cgroup_storage_set(
-	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE]) { return 0; }
-static inline void bpf_cgroup_storage_unset(void) {}
 static inline int bpf_cgroup_storage_assign(struct bpf_prog_aux *aux,
 					    struct bpf_map *map) { return 0; }
 static inline struct bpf_cgroup_storage *bpf_cgroup_storage_alloc(
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 4afbff308ca3..8d72fdfba7bc 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1111,38 +1111,54 @@ int bpf_prog_array_copy(struct bpf_prog_array *old_array,
 			struct bpf_prog *include_prog,
 			struct bpf_prog_array **new_array);
 
+struct bpf_run_ctx {};
+
+static inline struct bpf_run_ctx *bpf_set_run_ctx(struct bpf_run_ctx *new_ctx)
+{
+	struct bpf_run_ctx *old_ctx;
+
+	old_ctx = current->bpf_ctx;
+	current->bpf_ctx = new_ctx;
+	return old_ctx;
+}
+
+static inline void bpf_reset_run_ctx(struct bpf_run_ctx *old_ctx)
+{
+	current->bpf_ctx = old_ctx;
+}
+
+struct bpf_cg_run_ctx {
+	struct bpf_run_ctx run_ctx;
+	struct bpf_prog_array_item *prog_item;
+};
+
 /* BPF program asks to bypass CAP_NET_BIND_SERVICE in bind. */
 #define BPF_RET_BIND_NO_CAP_NET_BIND_SERVICE			(1 << 0)
 /* BPF program asks to set CN on the packet. */
 #define BPF_RET_SET_CN						(1 << 0)
 
-/* For BPF_PROG_RUN_ARRAY_FLAGS and __BPF_PROG_RUN_ARRAY,
- * if bpf_cgroup_storage_set() failed, the rest of programs
- * will not execute. This should be a really rare scenario
- * as it requires BPF_CGROUP_STORAGE_NEST_MAX number of
- * preemptions all between bpf_cgroup_storage_set() and
- * bpf_cgroup_storage_unset() on the same cpu.
- */
 #define BPF_PROG_RUN_ARRAY_FLAGS(array, ctx, func, ret_flags)		\
 	({								\
 		struct bpf_prog_array_item *_item;			\
 		struct bpf_prog *_prog;					\
 		struct bpf_prog_array *_array;				\
+		struct bpf_run_ctx *old_run_ctx;			\
+		struct bpf_cg_run_ctx run_ctx;				\
 		u32 _ret = 1;						\
 		u32 func_ret;						\
 		migrate_disable();					\
 		rcu_read_lock();					\
 		_array = rcu_dereference(array);			\
 		_item = &_array->items[0];				\
+		old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);	\
 		while ((_prog = READ_ONCE(_item->prog))) {		\
-			if (unlikely(bpf_cgroup_storage_set(_item->cgroup_storage)))	\
-				break;					\
+			run_ctx.prog_item = _item;			\
 			func_ret = func(_prog, ctx);			\
 			_ret &= (func_ret & 1);				\
-			*(ret_flags) |= (func_ret >> 1);			\
-			bpf_cgroup_storage_unset();			\
+			*(ret_flags) |= (func_ret >> 1);		\
 			_item++;					\
 		}							\
+		bpf_reset_run_ctx(old_run_ctx);				\
 		rcu_read_unlock();					\
 		migrate_enable();					\
 		_ret;							\
@@ -1153,6 +1169,8 @@ int bpf_prog_array_copy(struct bpf_prog_array *old_array,
 		struct bpf_prog_array_item *_item;	\
 		struct bpf_prog *_prog;			\
 		struct bpf_prog_array *_array;		\
+		struct bpf_run_ctx *old_run_ctx;	\
+		struct bpf_cg_run_ctx run_ctx;		\
 		u32 _ret = 1;				\
 		migrate_disable();			\
 		rcu_read_lock();			\
@@ -1160,17 +1178,13 @@ int bpf_prog_array_copy(struct bpf_prog_array *old_array,
 		if (unlikely(check_non_null && !_array))\
 			goto _out;			\
 		_item = &_array->items[0];		\
-		while ((_prog = READ_ONCE(_item->prog))) {		\
-			if (!set_cg_storage) {			\
-				_ret &= func(_prog, ctx);	\
-			} else {				\
-				if (unlikely(bpf_cgroup_storage_set(_item->cgroup_storage)))	\
-					break;			\
-				_ret &= func(_prog, ctx);	\
-				bpf_cgroup_storage_unset();	\
-			}				\
+		old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);\
+		while ((_prog = READ_ONCE(_item->prog))) {	\
+			run_ctx.prog_item = _item;	\
+			_ret &= func(_prog, ctx);	\
 			_item++;			\
 		}					\
+		bpf_reset_run_ctx(old_run_ctx);		\
 _out:							\
 		rcu_read_unlock();			\
 		migrate_enable();			\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index ec8d07d88641..c64119aa2e60 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -42,6 +42,7 @@ struct backing_dev_info;
 struct bio_list;
 struct blk_plug;
 struct bpf_local_storage;
+struct bpf_run_ctx;
 struct capture_control;
 struct cfs_rq;
 struct fs_struct;
@@ -1379,6 +1380,8 @@ struct task_struct {
 #ifdef CONFIG_BPF_SYSCALL
 	/* Used by BPF task local storage */
 	struct bpf_local_storage __rcu	*bpf_storage;
+	/* Used for BPF run context */
+	struct bpf_run_ctx		*bpf_ctx;
 #endif
 
 #ifdef CONFIG_GCC_PLUGIN_STACKLEAK
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 62cf00383910..3d05674f4f85 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -383,8 +383,6 @@ const struct bpf_func_proto bpf_get_current_ancestor_cgroup_id_proto = {
 };
 
 #ifdef CONFIG_CGROUP_BPF
-DECLARE_PER_CPU(struct bpf_cgroup_storage_info,
-		bpf_cgroup_storage_info[BPF_CGROUP_STORAGE_NEST_MAX]);
 
 BPF_CALL_2(bpf_get_local_storage, struct bpf_map *, map, u64, flags)
 {
@@ -393,17 +391,13 @@ BPF_CALL_2(bpf_get_local_storage, struct bpf_map *, map, u64, flags)
 	 * verifier checks that its value is correct.
 	 */
 	enum bpf_cgroup_storage_type stype = cgroup_storage_type(map);
-	struct bpf_cgroup_storage *storage = NULL;
+	struct bpf_cgroup_storage *storage;
+	struct bpf_cg_run_ctx *ctx;
 	void *ptr;
-	int i;
 
-	for (i = 0; i < BPF_CGROUP_STORAGE_NEST_MAX; i++) {
-		if (unlikely(this_cpu_read(bpf_cgroup_storage_info[i].task) != current))
-			continue;
-
-		storage = this_cpu_read(bpf_cgroup_storage_info[i].storage[stype]);
-		break;
-	}
+	/* get current cgroup storage from BPF run context */
+	ctx = container_of(current->bpf_ctx, struct bpf_cg_run_ctx, run_ctx);
+	storage = ctx->prog_item->cgroup_storage[stype];
 
 	if (stype == BPF_CGROUP_STORAGE_SHARED)
 		ptr = &READ_ONCE(storage->buf)->data[0];
diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index bd11db9774c3..1ef12f320a9b 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -11,9 +11,6 @@
 
 #ifdef CONFIG_CGROUP_BPF
 
-DEFINE_PER_CPU(struct bpf_cgroup_storage_info,
-	       bpf_cgroup_storage_info[BPF_CGROUP_STORAGE_NEST_MAX]);
-
 #include "../cgroup/cgroup-internal.h"
 
 #define LOCAL_STORAGE_CREATE_FLAG_MASK					\
diff --git a/kernel/fork.c b/kernel/fork.c
index bc94b2cc5995..e8b41e212110 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2083,6 +2083,7 @@ static __latent_entropy struct task_struct *copy_process(
 #endif
 #ifdef CONFIG_BPF_SYSCALL
 	RCU_INIT_POINTER(p->bpf_storage, NULL);
+	p->bpf_ctx = NULL;
 #endif
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index cda8375bbbaf..8d46e2962786 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -88,17 +88,19 @@ static bool bpf_test_timer_continue(struct bpf_test_timer *t, u32 repeat, int *e
 static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
 			u32 *retval, u32 *time, bool xdp)
 {
-	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = { NULL };
+	struct bpf_prog_array_item item = {.prog = prog};
+	struct bpf_run_ctx *old_ctx;
+	struct bpf_cg_run_ctx run_ctx;
 	struct bpf_test_timer t = { NO_MIGRATE };
 	enum bpf_cgroup_storage_type stype;
 	int ret;
 
 	for_each_cgroup_storage_type(stype) {
-		storage[stype] = bpf_cgroup_storage_alloc(prog, stype);
-		if (IS_ERR(storage[stype])) {
-			storage[stype] = NULL;
+		item.cgroup_storage[stype] = bpf_cgroup_storage_alloc(prog, stype);
+		if (IS_ERR(item.cgroup_storage[stype])) {
+			item.cgroup_storage[stype] = NULL;
 			for_each_cgroup_storage_type(stype)
-				bpf_cgroup_storage_free(storage[stype]);
+				bpf_cgroup_storage_free(item.cgroup_storage[stype]);
 			return -ENOMEM;
 		}
 	}
@@ -107,22 +109,19 @@ static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
 		repeat = 1;
 
 	bpf_test_timer_enter(&t);
+	old_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
 	do {
-		ret = bpf_cgroup_storage_set(storage);
-		if (ret)
-			break;
-
+		run_ctx.prog_item = &item;
 		if (xdp)
 			*retval = bpf_prog_run_xdp(prog, ctx);
 		else
 			*retval = BPF_PROG_RUN(prog, ctx);
-
-		bpf_cgroup_storage_unset();
 	} while (bpf_test_timer_continue(&t, repeat, &ret, time));
+	bpf_reset_run_ctx(old_ctx);
 	bpf_test_timer_leave(&t);
 
 	for_each_cgroup_storage_type(stype)
-		bpf_cgroup_storage_free(storage[stype]);
+		bpf_cgroup_storage_free(item.cgroup_storage[stype]);
 
 	return ret;
 }
-- 
2.30.2

