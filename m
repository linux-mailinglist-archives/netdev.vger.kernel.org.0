Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4770330FEDC
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 21:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhBDUvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 15:51:00 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6398 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229996AbhBDUuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 15:50:54 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 114KiJR5018846
        for <netdev@vger.kernel.org>; Thu, 4 Feb 2021 12:50:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=9R67QdYN1HVGnSV+7kMgPEc/7rOUIP+521VSKYzNydo=;
 b=M7oeTzTpgqNXeIb5E4VSJhGw6e4AmnMolt0Sm5cRj7v67SeGr8uWCB9IfgV4imRF2uhh
 i2MHizfX7O6bKC+82AMPzYnyGTy4KIU7fOVOehKj7Rc/PyZqvtoQNnwJAsxkB/rKo6xQ
 CSRGJP8LFmfN9/PTx5s5zQcHEwh1Y6bwf6w= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 36fvyd0tkt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 12:50:11 -0800
Received: from intmgw002.06.ash9.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 4 Feb 2021 12:50:09 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 9A83562E1750; Thu,  4 Feb 2021 12:50:08 -0800 (PST)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <akpm@linux-foundation.org>, Song Liu <songliubraving@fb.com>
Subject: [PATCH v4 bpf-next 1/4] bpf: introduce task_vma bpf_iter
Date:   Thu, 4 Feb 2021 12:49:58 -0800
Message-ID: <20210204205002.4075937-2-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210204205002.4075937-1-songliubraving@fb.com>
References: <20210204205002.4075937-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-04_10:2021-02-04,2021-02-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 mlxscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102040128
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce task_vma bpf_iter to print memory information of a process. It
can be used to print customized information similar to /proc/<pid>/maps.

Current /proc/<pid>/maps and /proc/<pid>/smaps provide information of
vma's of a process. However, these information are not flexible enough to
cover all use cases. For example, if a vma cover mixed 2MB pages and 4kB
pages (x86_64), there is no easy way to tell which address ranges are
backed by 2MB pages. task_vma solves the problem by enabling the user to
generate customize information based on the vma (and vma->vm_mm,
vma->vm_file, etc.).

To access the vma safely in the BPF program, task_vma iterator holds
target mmap_lock while calling the BPF program. If the mmap_lock is
contended, task_vma unlocks mmap_lock between iterations to unblock the
writer(s). This lock contention avoidance mechanism is similar to the one
used in show_smaps_rollup().

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 kernel/bpf/task_iter.c | 215 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 214 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index 175b7b42bfc46..31e63b6c3d718 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -286,9 +286,196 @@ static const struct seq_operations task_file_seq_op=
s =3D {
 	.show	=3D task_file_seq_show,
 };
=20
+struct bpf_iter_seq_task_vma_info {
+	/* The first field must be struct bpf_iter_seq_task_common.
+	 * this is assumed by {init, fini}_seq_pidns() callback functions.
+	 */
+	struct bpf_iter_seq_task_common common;
+	struct task_struct *task;
+	struct vm_area_struct *vma;
+	u32 tid;
+	unsigned long prev_vm_start;
+	unsigned long prev_vm_end;
+};
+
+enum bpf_task_vma_iter_find_op {
+	task_vma_iter_first_vma,   /* use mm->mmap */
+	task_vma_iter_next_vma,    /* use curr_vma->vm_next */
+	task_vma_iter_find_vma,    /* use find_vma() to find next vma */
+};
+
+static struct vm_area_struct *
+task_vma_seq_get_next(struct bpf_iter_seq_task_vma_info *info)
+{
+	struct pid_namespace *ns =3D info->common.ns;
+	enum bpf_task_vma_iter_find_op op;
+	struct vm_area_struct *curr_vma;
+	struct task_struct *curr_task;
+	u32 curr_tid =3D info->tid;
+
+	/* If this function returns a non-NULL vma, it holds a reference to
+	 * the task_struct, and holds read lock on vma->mm->mmap_lock.
+	 * If this function returns NULL, it does not hold any reference or
+	 * lock.
+	 */
+	if (info->task) {
+		curr_task =3D info->task;
+		curr_vma =3D info->vma;
+		/* In case of lock contention, drop mmap_lock to unblock
+		 * the writer.
+		 */
+		if (mmap_lock_is_contended(curr_task->mm)) {
+			info->prev_vm_start =3D curr_vma->vm_start;
+			info->prev_vm_end =3D curr_vma->vm_end;
+			op =3D task_vma_iter_find_vma;
+			mmap_read_unlock(curr_task->mm);
+			if (mmap_read_lock_killable(curr_task->mm))
+				goto finish;
+		} else {
+			op =3D task_vma_iter_next_vma;
+		}
+	} else {
+again:
+		curr_task =3D task_seq_get_next(ns, &curr_tid, true);
+		if (!curr_task) {
+			info->tid =3D curr_tid + 1;
+			goto finish;
+		}
+
+		if (curr_tid !=3D info->tid) {
+			info->tid =3D curr_tid;
+			op =3D task_vma_iter_first_vma;
+		} else {
+			op =3D task_vma_iter_find_vma;
+		}
+
+		if (!curr_task->mm)
+			goto next_task;
+
+		if (mmap_read_lock_killable(curr_task->mm))
+			goto finish;
+	}
+
+	switch (op) {
+	case task_vma_iter_first_vma:
+		curr_vma =3D curr_task->mm->mmap;
+		break;
+	case task_vma_iter_next_vma:
+		curr_vma =3D curr_vma->vm_next;
+		break;
+	case task_vma_iter_find_vma:
+		/* We dropped mmap_lock so it is necessary to use find_vma
+		 * to find the next vma. This is similar to the  mechanism
+		 * in show_smaps_rollup().
+		 */
+		curr_vma =3D find_vma(curr_task->mm, info->prev_vm_end - 1);
+
+		if (curr_vma && (curr_vma->vm_start =3D=3D info->prev_vm_start))
+			curr_vma =3D curr_vma->vm_next;
+		break;
+	}
+	if (!curr_vma) {
+		mmap_read_unlock(curr_task->mm);
+		goto next_task;
+	}
+	info->task =3D curr_task;
+	info->vma =3D curr_vma;
+	return curr_vma;
+
+next_task:
+	put_task_struct(curr_task);
+	info->task =3D NULL;
+	curr_tid++;
+	goto again;
+
+finish:
+	info->task =3D NULL;
+	info->vma =3D NULL;
+	return NULL;
+}
+
+static void *task_vma_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct bpf_iter_seq_task_vma_info *info =3D seq->private;
+	struct vm_area_struct *vma;
+
+	vma =3D task_vma_seq_get_next(info);
+	if (vma && *pos =3D=3D 0)
+		++*pos;
+
+	return vma;
+}
+
+static void *task_vma_seq_next(struct seq_file *seq, void *v, loff_t *po=
s)
+{
+	struct bpf_iter_seq_task_vma_info *info =3D seq->private;
+
+	++*pos;
+	return task_vma_seq_get_next(info);
+}
+
+struct bpf_iter__task_vma {
+	__bpf_md_ptr(struct bpf_iter_meta *, meta);
+	__bpf_md_ptr(struct task_struct *, task);
+	__bpf_md_ptr(struct vm_area_struct *, vma);
+};
+
+DEFINE_BPF_ITER_FUNC(task_vma, struct bpf_iter_meta *meta,
+		     struct task_struct *task, struct vm_area_struct *vma)
+
+static int __task_vma_seq_show(struct seq_file *seq, bool in_stop)
+{
+	struct bpf_iter_seq_task_vma_info *info =3D seq->private;
+	struct bpf_iter__task_vma ctx;
+	struct bpf_iter_meta meta;
+	struct bpf_prog *prog;
+
+	meta.seq =3D seq;
+	prog =3D bpf_iter_get_info(&meta, in_stop);
+	if (!prog)
+		return 0;
+
+	ctx.meta =3D &meta;
+	ctx.task =3D info->task;
+	ctx.vma =3D info->vma;
+	return bpf_iter_run_prog(prog, &ctx);
+}
+
+static int task_vma_seq_show(struct seq_file *seq, void *v)
+{
+	return __task_vma_seq_show(seq, false);
+}
+
+static void task_vma_seq_stop(struct seq_file *seq, void *v)
+{
+	struct bpf_iter_seq_task_vma_info *info =3D seq->private;
+
+	if (!v) {
+		(void)__task_vma_seq_show(seq, true);
+	} else {
+		/* Set prev_vm_start to ~0UL, so that we don't skip the
+		 * vma returned by the next find_vma(). Please refer to
+		 * case task_vma_iter_find_vma in task_vma_seq_get_next().
+		 */
+		info->prev_vm_start =3D ~0UL;
+		info->prev_vm_end =3D info->vma->vm_end;
+		mmap_read_unlock(info->task->mm);
+		put_task_struct(info->task);
+		info->task =3D NULL;
+	}
+}
+
+static const struct seq_operations task_vma_seq_ops =3D {
+	.start	=3D task_vma_seq_start,
+	.next	=3D task_vma_seq_next,
+	.stop	=3D task_vma_seq_stop,
+	.show	=3D task_vma_seq_show,
+};
+
 BTF_ID_LIST(btf_task_file_ids)
 BTF_ID(struct, task_struct)
 BTF_ID(struct, file)
+BTF_ID(struct, vm_area_struct)
=20
 static const struct bpf_iter_seq_info task_seq_info =3D {
 	.seq_ops		=3D &task_seq_ops,
@@ -328,6 +515,26 @@ static struct bpf_iter_reg task_file_reg_info =3D {
 	.seq_info		=3D &task_file_seq_info,
 };
=20
+static const struct bpf_iter_seq_info task_vma_seq_info =3D {
+	.seq_ops		=3D &task_vma_seq_ops,
+	.init_seq_private	=3D init_seq_pidns,
+	.fini_seq_private	=3D fini_seq_pidns,
+	.seq_priv_size		=3D sizeof(struct bpf_iter_seq_task_vma_info),
+};
+
+static struct bpf_iter_reg task_vma_reg_info =3D {
+	.target			=3D "task_vma",
+	.feature		=3D BPF_ITER_RESCHED,
+	.ctx_arg_info_size	=3D 2,
+	.ctx_arg_info		=3D {
+		{ offsetof(struct bpf_iter__task_vma, task),
+		  PTR_TO_BTF_ID_OR_NULL },
+		{ offsetof(struct bpf_iter__task_vma, vma),
+		  PTR_TO_BTF_ID_OR_NULL },
+	},
+	.seq_info		=3D &task_vma_seq_info,
+};
+
 static int __init task_iter_init(void)
 {
 	int ret;
@@ -339,6 +546,12 @@ static int __init task_iter_init(void)
=20
 	task_file_reg_info.ctx_arg_info[0].btf_id =3D btf_task_file_ids[0];
 	task_file_reg_info.ctx_arg_info[1].btf_id =3D btf_task_file_ids[1];
-	return bpf_iter_reg_target(&task_file_reg_info);
+	ret =3D  bpf_iter_reg_target(&task_file_reg_info);
+	if (ret)
+		return ret;
+
+	task_vma_reg_info.ctx_arg_info[0].btf_id =3D btf_task_file_ids[0];
+	task_vma_reg_info.ctx_arg_info[1].btf_id =3D btf_task_file_ids[2];
+	return bpf_iter_reg_target(&task_vma_reg_info);
 }
 late_initcall(task_iter_init);
--=20
2.24.1

