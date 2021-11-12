Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B891D44E976
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 16:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235208AbhKLPGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 10:06:03 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22242 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235122AbhKLPGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 10:06:02 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ACExTt0017959
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 07:03:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=NeAU6EyWHfbhgGgMfVbUYBxrdvPZ2YFJ7Y2iQDJaEg8=;
 b=F2HlsRZlnDA+uoOSAEzXL6pG2MXSSahAlYQmXXm/n5poYpeUqYtZDOWaawqu0Jm+uMPQ
 jf2ZWnqMCZPbh2UNMuMaCE5jv8IqzSYayET7IhPtCviug1VAn8yIKxtNt2WcM6R7Mr5e
 GP6XMqjPXFvZ6aQAJnU7onGQMTAf0guGN0M= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3c9t4b06v6-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 07:03:11 -0800
Received: from intmgw002.25.frc3.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 12 Nov 2021 07:02:53 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id ADB3F1FA8FBF7; Fri, 12 Nov 2021 07:02:52 -0800 (PST)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, Song Liu <songliubraving@fb.com>
Subject: [PATCH v3 bpf-next 2/2] bpf: introduce btf_tracing_ids
Date:   Fri, 12 Nov 2021 07:02:43 -0800
Message-ID: <20211112150243.1270987-3-songliubraving@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211112150243.1270987-1-songliubraving@fb.com>
References: <20211112150243.1270987-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: hDYhj8D_CDaO3km2dXATmHM_xd5dUOjQ
X-Proofpoint-ORIG-GUID: hDYhj8D_CDaO3km2dXATmHM_xd5dUOjQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-12_05,2021-11-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 clxscore=1015 bulkscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=922
 priorityscore=1501 adultscore=0 impostorscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111120086
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to btf_sock_ids, btf_tracing_ids provides btf ID for task_struct,
file, and vm_area_struct via easy to understand format like
btf_tracing_ids[BTF_TRACING_TYPE_[TASK|file|VMA]].

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 include/linux/btf_ids.h       | 14 +++++++++++++-
 kernel/bpf/bpf_task_storage.c |  4 ++--
 kernel/bpf/btf.c              |  8 ++++----
 kernel/bpf/stackmap.c         |  2 +-
 kernel/bpf/task_iter.c        | 12 ++++++------
 kernel/bpf/verifier.c         |  2 +-
 kernel/trace/bpf_trace.c      |  4 ++--
 7 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
index 6bb42b785293a..919c0fde1c515 100644
--- a/include/linux/btf_ids.h
+++ b/include/linux/btf_ids.h
@@ -189,6 +189,18 @@ MAX_BTF_SOCK_TYPE,
 extern u32 btf_sock_ids[];
 #endif
=20
-extern u32 btf_task_struct_ids[];
+#define BTF_TRACING_TYPE_xxx	\
+	BTF_TRACING_TYPE(BTF_TRACING_TYPE_TASK, task_struct)	\
+	BTF_TRACING_TYPE(BTF_TRACING_TYPE_FILE, file)		\
+	BTF_TRACING_TYPE(BTF_TRACING_TYPE_VMA, vm_area_struct)
+
+enum {
+#define BTF_TRACING_TYPE(name, type) name,
+BTF_TRACING_TYPE_xxx
+#undef BTF_TRACING_TYPE
+MAX_BTF_TRACING_TYPE,
+};
+
+extern u32 btf_tracing_ids[];
=20
 #endif
diff --git a/kernel/bpf/bpf_task_storage.c b/kernel/bpf/bpf_task_storage.=
c
index ebfa8bc908923..bb69aea1a7776 100644
--- a/kernel/bpf/bpf_task_storage.c
+++ b/kernel/bpf/bpf_task_storage.c
@@ -323,7 +323,7 @@ const struct bpf_func_proto bpf_task_storage_get_prot=
o =3D {
 	.ret_type =3D RET_PTR_TO_MAP_VALUE_OR_NULL,
 	.arg1_type =3D ARG_CONST_MAP_PTR,
 	.arg2_type =3D ARG_PTR_TO_BTF_ID,
-	.arg2_btf_id =3D &btf_task_struct_ids[0],
+	.arg2_btf_id =3D &btf_tracing_ids[BTF_TRACING_TYPE_TASK],
 	.arg3_type =3D ARG_PTR_TO_MAP_VALUE_OR_NULL,
 	.arg4_type =3D ARG_ANYTHING,
 };
@@ -334,5 +334,5 @@ const struct bpf_func_proto bpf_task_storage_delete_p=
roto =3D {
 	.ret_type =3D RET_INTEGER,
 	.arg1_type =3D ARG_CONST_MAP_PTR,
 	.arg2_type =3D ARG_PTR_TO_BTF_ID,
-	.arg2_btf_id =3D &btf_task_struct_ids[0],
+	.arg2_btf_id =3D &btf_tracing_ids[BTF_TRACING_TYPE_TASK],
 };
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 2a9d8a1fee1de..6b9d23be1e992 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6354,10 +6354,10 @@ const struct bpf_func_proto bpf_btf_find_by_name_=
kind_proto =3D {
 	.arg4_type	=3D ARG_ANYTHING,
 };
=20
-BTF_ID_LIST_GLOBAL(btf_task_struct_ids, 3)
-BTF_ID(struct, task_struct)
-BTF_ID(struct, file)
-BTF_ID(struct, vm_area_struct)
+BTF_ID_LIST_GLOBAL(btf_tracing_ids, MAX_BTF_TRACING_TYPE)
+#define BTF_TRACING_TYPE(name, type) BTF_ID(struct, type)
+BTF_TRACING_TYPE_xxx
+#undef BTF_TRACING_TYPE
=20
 /* BTF ID set registration API for modules */
=20
diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 1de0a1b03636e..49e567209c6b6 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -489,7 +489,7 @@ const struct bpf_func_proto bpf_get_task_stack_proto =
=3D {
 	.gpl_only	=3D false,
 	.ret_type	=3D RET_INTEGER,
 	.arg1_type	=3D ARG_PTR_TO_BTF_ID,
-	.arg1_btf_id	=3D &btf_task_struct_ids[0],
+	.arg1_btf_id	=3D &btf_tracing_ids[BTF_TRACING_TYPE_TASK],
 	.arg2_type	=3D ARG_PTR_TO_UNINIT_MEM,
 	.arg3_type	=3D ARG_CONST_SIZE_OR_ZERO,
 	.arg4_type	=3D ARG_ANYTHING,
diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index f171479f7dd6b..d94696198ef89 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -622,7 +622,7 @@ const struct bpf_func_proto bpf_find_vma_proto =3D {
 	.func		=3D bpf_find_vma,
 	.ret_type	=3D RET_INTEGER,
 	.arg1_type	=3D ARG_PTR_TO_BTF_ID,
-	.arg1_btf_id	=3D &btf_task_struct_ids[0],
+	.arg1_btf_id	=3D &btf_tracing_ids[BTF_TRACING_TYPE_TASK],
 	.arg2_type	=3D ARG_ANYTHING,
 	.arg3_type	=3D ARG_PTR_TO_FUNC,
 	.arg4_type	=3D ARG_PTR_TO_STACK_OR_NULL,
@@ -652,19 +652,19 @@ static int __init task_iter_init(void)
 		init_irq_work(&work->irq_work, do_mmap_read_unlock);
 	}
=20
-	task_reg_info.ctx_arg_info[0].btf_id =3D btf_task_struct_ids[0];
+	task_reg_info.ctx_arg_info[0].btf_id =3D btf_tracing_ids[BTF_TRACING_TY=
PE_TASK];
 	ret =3D bpf_iter_reg_target(&task_reg_info);
 	if (ret)
 		return ret;
=20
-	task_file_reg_info.ctx_arg_info[0].btf_id =3D btf_task_struct_ids[0];
-	task_file_reg_info.ctx_arg_info[1].btf_id =3D btf_task_struct_ids[1];
+	task_file_reg_info.ctx_arg_info[0].btf_id =3D btf_tracing_ids[BTF_TRACI=
NG_TYPE_TASK];
+	task_file_reg_info.ctx_arg_info[1].btf_id =3D btf_tracing_ids[BTF_TRACI=
NG_TYPE_FILE];
 	ret =3D  bpf_iter_reg_target(&task_file_reg_info);
 	if (ret)
 		return ret;
=20
-	task_vma_reg_info.ctx_arg_info[0].btf_id =3D btf_task_struct_ids[0];
-	task_vma_reg_info.ctx_arg_info[1].btf_id =3D btf_task_struct_ids[2];
+	task_vma_reg_info.ctx_arg_info[0].btf_id =3D btf_tracing_ids[BTF_TRACIN=
G_TYPE_TASK];
+	task_vma_reg_info.ctx_arg_info[1].btf_id =3D btf_tracing_ids[BTF_TRACIN=
G_TYPE_VMA];
 	return bpf_iter_reg_target(&task_vma_reg_info);
 }
 late_initcall(task_iter_init);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1aafb43f61d1c..d31a031ab3775 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6147,7 +6147,7 @@ static int set_find_vma_callback_state(struct bpf_v=
erifier_env *env,
 	callee->regs[BPF_REG_2].type =3D PTR_TO_BTF_ID;
 	__mark_reg_known_zero(&callee->regs[BPF_REG_2]);
 	callee->regs[BPF_REG_2].btf =3D  btf_vmlinux;
-	callee->regs[BPF_REG_2].btf_id =3D btf_task_struct_ids[2];
+	callee->regs[BPF_REG_2].btf_id =3D btf_tracing_ids[BTF_TRACING_TYPE_VMA=
],
=20
 	/* pointer to stack or null */
 	callee->regs[BPF_REG_3] =3D caller->regs[BPF_REG_4];
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 390176a3031ab..25ea521fb8f14 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -764,7 +764,7 @@ const struct bpf_func_proto bpf_get_current_task_btf_=
proto =3D {
 	.func		=3D bpf_get_current_task_btf,
 	.gpl_only	=3D true,
 	.ret_type	=3D RET_PTR_TO_BTF_ID,
-	.ret_btf_id	=3D &btf_task_struct_ids[0],
+	.ret_btf_id	=3D &btf_tracing_ids[BTF_TRACING_TYPE_TASK],
 };
=20
 BPF_CALL_1(bpf_task_pt_regs, struct task_struct *, task)
@@ -779,7 +779,7 @@ const struct bpf_func_proto bpf_task_pt_regs_proto =3D=
 {
 	.func		=3D bpf_task_pt_regs,
 	.gpl_only	=3D true,
 	.arg1_type	=3D ARG_PTR_TO_BTF_ID,
-	.arg1_btf_id	=3D &btf_task_struct_ids[0],
+	.arg1_btf_id	=3D &btf_tracing_ids[BTF_TRACING_TYPE_TASK],
 	.ret_type	=3D RET_PTR_TO_BTF_ID,
 	.ret_btf_id	=3D &bpf_task_pt_regs_ids[0],
 };
--=20
2.30.2

