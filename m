Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9272143D62D
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 00:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhJ0WDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 18:03:21 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22100 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229924AbhJ0WDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 18:03:19 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19RLfR7b030659
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 15:00:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Yy2J+Zcj2ImgtONZexNgKM+B/e+q8Rvh9TB8LF9RrQg=;
 b=EY3s2WfsQVjaNvHmpSMhUTP55jJXaRADcPLlwFoXbhGH+vV/VQ/xRvY7suiKVDYxLpnr
 ANzAmwJ2JrLpcGBwnccNNepeYpY2Ozwt2EjCl/ObHoRETw05/Gse1HfN/cZw+uIIrTBx
 Q9WQLUV6YgcqoQcEkXGkVVq5UwGeWL4x83Q= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3by9w83ukb-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 15:00:53 -0700
Received: from intmgw002.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 27 Oct 2021 15:00:52 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 2E20C1B7DA3EA; Wed, 27 Oct 2021 15:00:48 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, <kpsingh@kernel.org>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH bpf-next 1/2] bpf: introduce helper bpf_find_vma
Date:   Wed, 27 Oct 2021 15:00:42 -0700
Message-ID: <20211027220043.1937648-2-songliubraving@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211027220043.1937648-1-songliubraving@fb.com>
References: <20211027220043.1937648-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: KoWnKbos9BZTigCHgFwBKDMZIufE7Ot7
X-Proofpoint-ORIG-GUID: KoWnKbos9BZTigCHgFwBKDMZIufE7Ot7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-27_06,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxscore=0 bulkscore=0
 suspectscore=0 priorityscore=1501 mlxlogscore=999 impostorscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110270121
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some profiler use cases, it is necessary to map an address to the
backing file, e.g., a shared library. bpf_find_vma helper provides a
flexible way to achieve this. bpf_find_vma maps an address of a task to
the vma (vm_area_struct) for this address, and feed the vma to an callbac=
k
BPF function. The callback function is necessary here, as we need to
ensure mmap_sem is unlocked.

It is necessary to lock mmap_sem for find_vma. To lock and unlock mmap_se=
m
safely when irqs are disable, we use the same mechanism as stackmap with
build_id. Specifically, when irqs are disabled, the unlocked is postponed
in an irq_work.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 include/linux/bpf.h            |   1 +
 include/uapi/linux/bpf.h       |  20 +++++++
 kernel/bpf/task_iter.c         | 102 ++++++++++++++++++++++++++++++++-
 kernel/bpf/verifier.c          |  36 ++++++++++++
 kernel/trace/bpf_trace.c       |   2 +
 tools/include/uapi/linux/bpf.h |  19 ++++++
 6 files changed, 179 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 31421c74ba081..65def8467b609 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2109,6 +2109,7 @@ extern const struct bpf_func_proto bpf_for_each_map=
_elem_proto;
 extern const struct bpf_func_proto bpf_btf_find_by_name_kind_proto;
 extern const struct bpf_func_proto bpf_sk_setsockopt_proto;
 extern const struct bpf_func_proto bpf_sk_getsockopt_proto;
+extern const struct bpf_func_proto bpf_find_vma_proto;
=20
 const struct bpf_func_proto *tracing_prog_func_proto(
   enum bpf_func_id func_id, const struct bpf_prog *prog);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index c108200378834..e1401ae4decc9 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4915,6 +4915,25 @@ union bpf_attr {
  *		Dynamically cast a *sk* pointer to a *unix_sock* pointer.
  *	Return
  *		*sk* if casting is valid, or **NULL** otherwise.
+ *
+ * long bpf_find_vma(struct task_struct *task, u64 addr, void *callback_=
fn, void *callback_ctx, u64 flags)
+ *	Description
+ *		Find vma of *task* that contains *addr*, call *callback_fn*
+ *		function with *task*, *vma*, and *callback_ctx*.
+ *		The *callback_fn* should be a static function and
+ *		the *callback_ctx* should be a pointer to the stack.
+ *		The *flags* is used to control certain aspects of the helper.
+ *		Currently, the *flags* must be 0.
+ *
+ *		The expected callback signature is
+ *
+ *		long (\*callback_fn)(struct task_struct \*task, struct vm_area_struc=
t \*vma, void \*ctx);
+ *
+ *	Return
+ *		0 on success.
+ *		**-ENOENT** if *task->mm* is NULL, or no vma contains *addr*.
+ *		**-EBUSY** if failed to try lock mmap_lock.
+ *		**-EINVAL** for invalid **flags**.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5096,6 +5115,7 @@ union bpf_attr {
 	FN(get_branch_snapshot),	\
 	FN(trace_vprintk),		\
 	FN(skc_to_unix_sock),		\
+	FN(find_vma),			\
 	/* */
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index b48750bfba5aa..ad30f2e885356 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -8,6 +8,7 @@
 #include <linux/fdtable.h>
 #include <linux/filter.h>
 #include <linux/btf_ids.h>
+#include <linux/irq_work.h>
=20
 struct bpf_iter_seq_task_common {
 	struct pid_namespace *ns;
@@ -21,6 +22,25 @@ struct bpf_iter_seq_task_info {
 	u32 tid;
 };
=20
+/* irq_work to run mmap_read_unlock() */
+struct task_iter_irq_work {
+	struct irq_work irq_work;
+	struct mm_struct *mm;
+};
+
+static DEFINE_PER_CPU(struct task_iter_irq_work, mmap_unlock_work);
+
+static void do_mmap_read_unlock(struct irq_work *entry)
+{
+	struct task_iter_irq_work *work;
+
+	if (WARN_ON_ONCE(IS_ENABLED(CONFIG_PREEMPT_RT)))
+		return;
+
+	work =3D container_of(entry, struct task_iter_irq_work, irq_work);
+	mmap_read_unlock_non_owner(work->mm);
+}
+
 static struct task_struct *task_seq_get_next(struct pid_namespace *ns,
 					     u32 *tid,
 					     bool skip_if_dup_files)
@@ -586,9 +606,89 @@ static struct bpf_iter_reg task_vma_reg_info =3D {
 	.seq_info		=3D &task_vma_seq_info,
 };
=20
+BPF_CALL_5(bpf_find_vma, struct task_struct *, task, u64, start,
+	   bpf_callback_t, callback_fn, void *, callback_ctx, u64, flags)
+{
+	struct task_iter_irq_work *work =3D NULL;
+	struct mm_struct *mm =3D task->mm;
+	struct vm_area_struct *vma;
+	bool irq_work_busy =3D false;
+	int ret =3D -ENOENT;
+
+	if (flags)
+		return -EINVAL;
+
+	if (!mm)
+		return -ENOENT;
+
+	/*
+	 * Similar to stackmap with build_id support, we cannot simply do
+	 * mmap_read_unlock when the irq is disabled. Instead, we need do
+	 * the unlock in the irq_work.
+	 */
+	if (irqs_disabled()) {
+		if (!IS_ENABLED(CONFIG_PREEMPT_RT)) {
+			work =3D this_cpu_ptr(&mmap_unlock_work);
+			if (irq_work_is_busy(&work->irq_work)) {
+				/* cannot queue more mmap_unlock, abort. */
+				irq_work_busy =3D true;
+			}
+		} else {
+			/*
+			 * PREEMPT_RT does not allow to trylock mmap sem in
+			 * interrupt disabled context, abort.
+			 */
+			irq_work_busy =3D true;
+		}
+	}
+
+	if (irq_work_busy || !mmap_read_trylock(mm))
+		return -EBUSY;
+
+	vma =3D find_vma(mm, start);
+
+	if (vma && vma->vm_start <=3D start && vma->vm_end > start) {
+		callback_fn((u64)(long)task, (u64)(long)vma,
+			    (u64)(long)callback_ctx, 0, 0);
+		ret =3D 0;
+	}
+	if (!work) {
+		mmap_read_unlock(current->mm);
+	} else {
+		work->mm =3D current->mm;
+
+		/* The lock will be released once we're out of interrupt
+		 * context. Tell lockdep that we've released it now so
+		 * it doesn't complain that we forgot to release it.
+		 */
+		rwsem_release(&current->mm->mmap_lock.dep_map, _RET_IP_);
+		irq_work_queue(&work->irq_work);
+	}
+	return ret;
+}
+
+BTF_ID_LIST_SINGLE(btf_find_vma_ids, struct, task_struct)
+
+const struct bpf_func_proto bpf_find_vma_proto =3D {
+	.func		=3D bpf_find_vma,
+	.ret_type	=3D RET_INTEGER,
+	.arg1_type	=3D ARG_PTR_TO_BTF_ID,
+	.arg1_btf_id	=3D &btf_find_vma_ids[0],
+	.arg2_type	=3D ARG_ANYTHING,
+	.arg3_type	=3D ARG_PTR_TO_FUNC,
+	.arg4_type	=3D ARG_PTR_TO_STACK_OR_NULL,
+	.arg5_type	=3D ARG_ANYTHING,
+};
+
 static int __init task_iter_init(void)
 {
-	int ret;
+	struct task_iter_irq_work *work;
+	int ret, cpu;
+
+	for_each_possible_cpu(cpu) {
+		work =3D per_cpu_ptr(&mmap_unlock_work, cpu);
+		init_irq_work(&work->irq_work, do_mmap_read_unlock);
+	}
=20
 	task_reg_info.ctx_arg_info[0].btf_id =3D btf_task_struct_ids[0];
 	ret =3D bpf_iter_reg_target(&task_reg_info);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c6616e3258038..393ab21529b08 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6119,6 +6119,35 @@ static int set_timer_callback_state(struct bpf_ver=
ifier_env *env,
 	return 0;
 }
=20
+BTF_ID_LIST_SINGLE(btf_set_find_vma_ids, struct, vm_area_struct)
+
+static int set_find_vma_callback_state(struct bpf_verifier_env *env,
+				       struct bpf_func_state *caller,
+				       struct bpf_func_state *callee,
+				       int insn_idx)
+{
+	/* bpf_find_vma(struct task_struct *task, u64 start,
+	 *               void *callback_fn, void *callback_ctx, u64 flags)
+	 * (callback_fn)(struct task_struct *task,
+	 *               struct vm_area_struct *vma, void *ctx);
+	 */
+	callee->regs[BPF_REG_1] =3D caller->regs[BPF_REG_1];
+
+	callee->regs[BPF_REG_2].type =3D PTR_TO_BTF_ID;
+	__mark_reg_known_zero(&callee->regs[BPF_REG_2]);
+	callee->regs[BPF_REG_2].btf =3D  btf_vmlinux;
+	callee->regs[BPF_REG_2].btf_id =3D btf_set_find_vma_ids[0];
+
+	/* pointer to stack or null */
+	callee->regs[BPF_REG_3] =3D caller->regs[BPF_REG_4];
+
+	/* unused */
+	__mark_reg_not_init(env, &callee->regs[BPF_REG_4]);
+	__mark_reg_not_init(env, &callee->regs[BPF_REG_5]);
+	callee->in_callback_fn =3D true;
+	return 0;
+}
+
 static int prepare_func_exit(struct bpf_verifier_env *env, int *insn_idx=
)
 {
 	struct bpf_verifier_state *state =3D env->cur_state;
@@ -6476,6 +6505,13 @@ static int check_helper_call(struct bpf_verifier_e=
nv *env, struct bpf_insn *insn
 			return -EINVAL;
 	}
=20
+	if (func_id =3D=3D BPF_FUNC_find_vma) {
+		err =3D __check_func_call(env, insn, insn_idx_p, meta.subprogno,
+					set_find_vma_callback_state);
+		if (err < 0)
+			return -EINVAL;
+	}
+
 	if (func_id =3D=3D BPF_FUNC_snprintf) {
 		err =3D check_bpf_snprintf_call(env, regs);
 		if (err < 0)
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index cbcd0d6fca7c7..c95397c55d0e8 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1208,6 +1208,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, co=
nst struct bpf_prog *prog)
 		return &bpf_get_func_ip_proto_tracing;
 	case BPF_FUNC_get_branch_snapshot:
 		return &bpf_get_branch_snapshot_proto;
+	case BPF_FUNC_find_vma:
+		return &bpf_find_vma_proto;
 	case BPF_FUNC_trace_vprintk:
 		return bpf_get_trace_vprintk_proto();
 	default:
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index c108200378834..056c00da1b5d6 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4915,6 +4915,24 @@ union bpf_attr {
  *		Dynamically cast a *sk* pointer to a *unix_sock* pointer.
  *	Return
  *		*sk* if casting is valid, or **NULL** otherwise.
+ * long bpf_find_vma(struct task_struct *task, u64 addr, void *callback_=
fn, void *callback_ctx, u64 flags)
+ *	Description
+ *		Find vma of *task* that contains *addr*, call *callback_fn*
+ *		function with *task*, *vma*, and *callback_ctx*.
+ *		The *callback_fn* should be a static function and
+ *		the *callback_ctx* should be a pointer to the stack.
+ *		The *flags* is used to control certain aspects of the helper.
+ *		Currently, the *flags* must be 0.
+ *
+ *		The expected callback signature is
+ *
+ *		long (\*callback_fn)(struct task_struct \*task, struct vm_area_struc=
t \*vma, void \*ctx);
+ *
+ *	Return
+ *		0 on success.
+ *		**-ENOENT** if *task->mm* is NULL, or no vma contains *addr*.
+ *		**-EBUSY** if failed to try lock mmap_lock.
+ *		**-EINVAL** for invalid **flags**.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5096,6 +5114,7 @@ union bpf_attr {
 	FN(get_branch_snapshot),	\
 	FN(trace_vprintk),		\
 	FN(skc_to_unix_sock),		\
+	FN(find_vma),			\
 	/* */
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
--=20
2.30.2

