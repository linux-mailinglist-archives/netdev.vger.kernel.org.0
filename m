Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73DF531980D
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 02:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbhBLBn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 20:43:29 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48140 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229653AbhBLBn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 20:43:27 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11C1eL0W012461
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 17:42:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=wMrsqJYwN420bFfUvGfPI7mw+h4y4B8OX7GZP160nik=;
 b=IVGaMs7IJ2hCaXFJPu6/Hr/aQTYEMh2XGon9aZtsujuRR3wg8H4pgY0RbvJpoiv8tFb6
 BlxY/30DYrtTo0FxeNi8lzggrNgOZoWH2MwCPcrvzTHHqR/4E1UuHTdgaPMhsDcmrfQA
 p14aqBgOAFXpolW9MXE+M4SaFuwoDjT72Z8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 36mh2u2hsc-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 17:42:46 -0800
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 11 Feb 2021 17:42:45 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 12C0162E0B5D; Thu, 11 Feb 2021 17:42:44 -0800 (PST)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <akpm@linux-foundation.org>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH v6 bpf-next 1/4] bpf: introduce task_vma bpf_iter
Date:   Thu, 11 Feb 2021 17:42:29 -0800
Message-ID: <20210212014232.414643-2-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210212014232.414643-1-songliubraving@fb.com>
References: <20210212014232.414643-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_07:2021-02-11,2021-02-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 bulkscore=0
 phishscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120009
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

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 kernel/bpf/task_iter.c | 267 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 266 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index 175b7b42bfc46..b68cb5d6d6ebc 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -286,9 +286,248 @@ static const struct seq_operations task_file_seq_op=
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
+		 *
+		 * After relock, call find(mm, prev_vm_end - 1) to find
+		 * new vma to process.
+		 *
+		 *   +------+------+-----------+
+		 *   | VMA1 | VMA2 | VMA3      |
+		 *   +------+------+-----------+
+		 *   |      |      |           |
+		 *  4k     8k     16k         400k
+		 *
+		 * For example, curr_vma =3D=3D VMA2. Before unlock, we set
+		 *
+		 *    prev_vm_start =3D 8k
+		 *    prev_vm_end   =3D 16k
+		 *
+		 * There are a few cases:
+		 *
+		 * 1) VMA2 is freed, but VMA3 exists.
+		 *
+		 *    find_vma() will return VMA3, just process VMA3.
+		 *
+		 * 2) VMA2 still exists.
+		 *
+		 *    find_vma() will return VMA2, process VMA2->next.
+		 *
+		 * 3) no more vma in this mm.
+		 *
+		 *    Process the next task.
+		 *
+		 * 4) find_vma() returns a different vma, VMA2'.
+		 *
+		 *    4.1) If VMA2 covers same range as VMA2', skip VMA2',
+		 *         because we already covered the range;
+		 *    4.2) VMA2 and VMA2' covers different ranges, process
+		 *         VMA2'.
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
+			/* new task, process the first vma */
+			op =3D task_vma_iter_first_vma;
+		} else {
+			/* Found the same tid, which means the user space
+			 * finished data in previous buffer and read more.
+			 * We dropped mmap_lock before returning to user
+			 * space, so it is necessary to use find_vma() to
+			 * find the next vma to process.
+			 */
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
+		/* case 1) and 4.2) above just use curr_vma */
+
+		/* check for case 2) or case 4.1) above */
+		if (curr_vma &&
+		    curr_vma->vm_start =3D=3D info->prev_vm_start &&
+		    curr_vma->vm_end =3D=3D info->prev_vm_end)
+			curr_vma =3D curr_vma->vm_next;
+		break;
+	}
+	if (!curr_vma) {
+		/* case 3) above, or case 2) 4.1) with vma->next =3D=3D NULL */
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
+	if (curr_task)
+		put_task_struct(curr_task);
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
+		/* info->vma has not been seen by the BPF program. If the
+		 * user space reads more, task_vma_seq_get_next should
+		 * return this vma again. Set prev_vm_start to ~0UL,
+		 * so that we don't skip the vma returned by the next
+		 * find_vma() (case task_vma_iter_find_vma in
+		 * task_vma_seq_get_next()).
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
@@ -328,6 +567,26 @@ static struct bpf_iter_reg task_file_reg_info =3D {
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
@@ -339,6 +598,12 @@ static int __init task_iter_init(void)
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

