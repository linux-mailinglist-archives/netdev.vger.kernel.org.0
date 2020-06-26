Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9579920A9B8
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 02:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725821AbgFZANt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 20:13:49 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26732 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725767AbgFZANs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 20:13:48 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05Q08uSZ004688
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 17:13:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=VWzNHf6XVkbJgDoQwFO1zN25OrigVegRG7jjJkjw7WY=;
 b=GwJHCy1idM6FNS2vpBfwGyXdh5n3l2vrraYHvtD0ie4gIv//AjmTCcUhU90Q3A86aj62
 N62nIA7mz14G0x5YkdK1quD2XSSYaEiLsoVl2sZaEysJeUBDUThI1532x0DD5/V0FBuk
 miVK0hmrVK1Tiiqc5jslOlnbIP+1jQ+USgE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31ux0m2vnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 17:13:47 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 25 Jun 2020 17:13:46 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 54F3662E4FA9; Thu, 25 Jun 2020 17:13:45 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <peterz@infradead.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>, Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 2/4] bpf: introduce helper bpf_get_task_stak()
Date:   Thu, 25 Jun 2020 17:13:30 -0700
Message-ID: <20200626001332.1554603-3-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200626001332.1554603-1-songliubraving@fb.com>
References: <20200626001332.1554603-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-25_19:2020-06-25,2020-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=9 mlxlogscore=999
 clxscore=1015 priorityscore=1501 mlxscore=0 cotscore=-2147483648
 malwarescore=0 spamscore=0 impostorscore=0 phishscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250142
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce helper bpf_get_task_stack(), which dumps stack trace of given
task. This is different to bpf_get_stack(), which gets stack track of
current task. One potential use case of bpf_get_task_stack() is to call
it from bpf_iter__task and dump all /proc/<pid>/stack to a seq_file.

bpf_get_task_stack() uses stack_trace_save_tsk() instead of
get_perf_callchain() for kernel stack. The benefit of this choice is that
stack_trace_save_tsk() doesn't require changes in arch/. The downside of
using stack_trace_save_tsk() is that stack_trace_save_tsk() dumps the
stack trace to unsigned long array. For 32-bit systems, we need to
translate it to u64 array.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 include/linux/bpf.h            |  1 +
 include/uapi/linux/bpf.h       | 35 ++++++++++++++-
 kernel/bpf/stackmap.c          | 79 ++++++++++++++++++++++++++++++++--
 kernel/trace/bpf_trace.c       |  2 +
 scripts/bpf_helpers_doc.py     |  2 +
 tools/include/uapi/linux/bpf.h | 35 ++++++++++++++-
 6 files changed, 149 insertions(+), 5 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 07052d44bca1c..cee31ee56367b 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1607,6 +1607,7 @@ extern const struct bpf_func_proto bpf_get_current_=
uid_gid_proto;
 extern const struct bpf_func_proto bpf_get_current_comm_proto;
 extern const struct bpf_func_proto bpf_get_stackid_proto;
 extern const struct bpf_func_proto bpf_get_stack_proto;
+extern const struct bpf_func_proto bpf_get_task_stack_proto;
 extern const struct bpf_func_proto bpf_sock_map_update_proto;
 extern const struct bpf_func_proto bpf_sock_hash_update_proto;
 extern const struct bpf_func_proto bpf_get_current_cgroup_id_proto;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 19684813faaed..7638412987354 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3252,6 +3252,38 @@ union bpf_attr {
  * 		case of **BPF_CSUM_LEVEL_QUERY**, the current skb->csum_level
  * 		is returned or the error code -EACCES in case the skb is not
  * 		subject to CHECKSUM_UNNECESSARY.
+ *
+ * int bpf_get_task_stack(struct task_struct *task, void *buf, u32 size,=
 u64 flags)
+ *	Description
+ *		Return a user or a kernel stack in bpf program provided buffer.
+ *		To achieve this, the helper needs *task*, which is a valid
+ *		pointer to struct task_struct. To store the stacktrace, the
+ *		bpf program provides *buf* with	a nonnegative *size*.
+ *
+ *		The last argument, *flags*, holds the number of stack frames to
+ *		skip (from 0 to 255), masked with
+ *		**BPF_F_SKIP_FIELD_MASK**. The next bits can be used to set
+ *		the following flags:
+ *
+ *		**BPF_F_USER_STACK**
+ *			Collect a user space stack instead of a kernel stack.
+ *		**BPF_F_USER_BUILD_ID**
+ *			Collect buildid+offset instead of ips for user stack,
+ *			only valid if **BPF_F_USER_STACK** is also specified.
+ *
+ *		**bpf_get_task_stack**\ () can collect up to
+ *		**PERF_MAX_STACK_DEPTH** both kernel and user frames, subject
+ *		to sufficient large buffer size. Note that
+ *		this limit can be controlled with the **sysctl** program, and
+ *		that it should be manually increased in order to profile long
+ *		user stacks (such as stacks for Java programs). To do so, use:
+ *
+ *		::
+ *
+ *			# sysctl kernel.perf_event_max_stack=3D<new value>
+ *	Return
+ *		A non-negative value equal to or less than *size* on success,
+ *		or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3389,7 +3421,8 @@ union bpf_attr {
 	FN(ringbuf_submit),		\
 	FN(ringbuf_discard),		\
 	FN(ringbuf_query),		\
-	FN(csum_level),
+	FN(csum_level),			\
+	FN(get_task_stack),
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
  * function eBPF program intends to call
diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 599488f25e404..64b7843057a23 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -348,6 +348,44 @@ static void stack_map_get_build_id_offset(struct bpf=
_stack_build_id *id_offs,
 	}
 }
=20
+static struct perf_callchain_entry *
+get_callchain_entry_for_task(struct task_struct *task, u32 init_nr)
+{
+	struct perf_callchain_entry *entry;
+	int rctx;
+
+	entry =3D get_callchain_entry(&rctx);
+
+	if (rctx =3D=3D -1)
+		return NULL;
+
+	if (!entry)
+		goto exit_put;
+
+	entry->nr =3D init_nr +
+		stack_trace_save_tsk(task, (unsigned long *)(entry->ip + init_nr),
+				     sysctl_perf_event_max_stack - init_nr, 0);
+
+	/* stack_trace_save_tsk() works on unsigned long array, while
+	 * perf_callchain_entry uses u64 array. For 32-bit systems, it is
+	 * necessary to fix this mismatch.
+	 */
+	if (__BITS_PER_LONG !=3D 64) {
+		unsigned long *from =3D (unsigned long *) entry->ip;
+		u64 *to =3D entry->ip;
+		int i;
+
+		/* copy data from the end to avoid using extra buffer */
+		for (i =3D entry->nr - 1; i >=3D (int)init_nr; i--)
+			to[i] =3D (u64)(from[i]);
+	}
+
+exit_put:
+	put_callchain_entry(rctx);
+
+	return entry;
+}
+
 BPF_CALL_3(bpf_get_stackid, struct pt_regs *, regs, struct bpf_map *, ma=
p,
 	   u64, flags)
 {
@@ -448,8 +486,8 @@ const struct bpf_func_proto bpf_get_stackid_proto =3D=
 {
 	.arg3_type	=3D ARG_ANYTHING,
 };
=20
-BPF_CALL_4(bpf_get_stack, struct pt_regs *, regs, void *, buf, u32, size=
,
-	   u64, flags)
+static int __bpf_get_stack(struct pt_regs *regs, struct task_struct *tas=
k,
+			   void *buf, u32 size, u64 flags)
 {
 	u32 init_nr, trace_nr, copy_len, elem_size, num_elem;
 	bool user_build_id =3D flags & BPF_F_USER_BUILD_ID;
@@ -471,13 +509,22 @@ BPF_CALL_4(bpf_get_stack, struct pt_regs *, regs, v=
oid *, buf, u32, size,
 	if (unlikely(size % elem_size))
 		goto clear;
=20
+	/* cannot get valid user stack for task without user_mode regs */
+	if (task && user && !user_mode(regs))
+		goto err_fault;
+
 	num_elem =3D size / elem_size;
 	if (sysctl_perf_event_max_stack < num_elem)
 		init_nr =3D 0;
 	else
 		init_nr =3D sysctl_perf_event_max_stack - num_elem;
+
+	if (kernel && task)
+		trace =3D get_callchain_entry_for_task(task, init_nr);
+	else
 		trace =3D get_perf_callchain(regs, init_nr, kernel, user,
-				   sysctl_perf_event_max_stack, false, false);
+					   sysctl_perf_event_max_stack,
+					   false, false);
 	if (unlikely(!trace))
 		goto err_fault;
=20
@@ -505,6 +552,12 @@ BPF_CALL_4(bpf_get_stack, struct pt_regs *, regs, vo=
id *, buf, u32, size,
 	return err;
 }
=20
+BPF_CALL_4(bpf_get_stack, struct pt_regs *, regs, void *, buf, u32, size=
,
+	   u64, flags)
+{
+	return __bpf_get_stack(regs, NULL, buf, size, flags);
+}
+
 const struct bpf_func_proto bpf_get_stack_proto =3D {
 	.func		=3D bpf_get_stack,
 	.gpl_only	=3D true,
@@ -515,6 +568,26 @@ const struct bpf_func_proto bpf_get_stack_proto =3D =
{
 	.arg4_type	=3D ARG_ANYTHING,
 };
=20
+BPF_CALL_4(bpf_get_task_stack, struct task_struct *, task, void *, buf,
+	   u32, size, u64, flags)
+{
+	struct pt_regs *regs =3D task_pt_regs(task);
+
+	return __bpf_get_stack(regs, task, buf, size, flags);
+}
+
+static int bpf_get_task_stack_btf_ids[5];
+const struct bpf_func_proto bpf_get_task_stack_proto =3D {
+	.func		=3D bpf_get_task_stack,
+	.gpl_only	=3D false,
+	.ret_type	=3D RET_INTEGER,
+	.arg1_type	=3D ARG_PTR_TO_BTF_ID,
+	.arg2_type	=3D ARG_PTR_TO_UNINIT_MEM,
+	.arg3_type	=3D ARG_CONST_SIZE_OR_ZERO,
+	.arg4_type	=3D ARG_ANYTHING,
+	.btf_id		=3D bpf_get_task_stack_btf_ids,
+};
+
 /* Called from eBPF program */
 static void *stack_map_lookup_elem(struct bpf_map *map, void *key)
 {
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index e729c9e587a07..65fa62723e2f8 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1134,6 +1134,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, co=
nst struct bpf_prog *prog)
 		return &bpf_ringbuf_discard_proto;
 	case BPF_FUNC_ringbuf_query:
 		return &bpf_ringbuf_query_proto;
+	case BPF_FUNC_get_task_stack:
+		return &bpf_get_task_stack_proto;
 	default:
 		return NULL;
 	}
diff --git a/scripts/bpf_helpers_doc.py b/scripts/bpf_helpers_doc.py
index 91fa668fa8602..a8783d668c5b7 100755
--- a/scripts/bpf_helpers_doc.py
+++ b/scripts/bpf_helpers_doc.py
@@ -421,6 +421,7 @@ class PrinterHelpers(Printer):
             'struct sockaddr',
             'struct tcphdr',
             'struct seq_file',
+            'struct task_struct',
=20
             'struct __sk_buff',
             'struct sk_msg_md',
@@ -458,6 +459,7 @@ class PrinterHelpers(Printer):
             'struct sockaddr',
             'struct tcphdr',
             'struct seq_file',
+            'struct task_struct',
     }
     mapped_types =3D {
             'u8': '__u8',
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 19684813faaed..7638412987354 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3252,6 +3252,38 @@ union bpf_attr {
  * 		case of **BPF_CSUM_LEVEL_QUERY**, the current skb->csum_level
  * 		is returned or the error code -EACCES in case the skb is not
  * 		subject to CHECKSUM_UNNECESSARY.
+ *
+ * int bpf_get_task_stack(struct task_struct *task, void *buf, u32 size,=
 u64 flags)
+ *	Description
+ *		Return a user or a kernel stack in bpf program provided buffer.
+ *		To achieve this, the helper needs *task*, which is a valid
+ *		pointer to struct task_struct. To store the stacktrace, the
+ *		bpf program provides *buf* with	a nonnegative *size*.
+ *
+ *		The last argument, *flags*, holds the number of stack frames to
+ *		skip (from 0 to 255), masked with
+ *		**BPF_F_SKIP_FIELD_MASK**. The next bits can be used to set
+ *		the following flags:
+ *
+ *		**BPF_F_USER_STACK**
+ *			Collect a user space stack instead of a kernel stack.
+ *		**BPF_F_USER_BUILD_ID**
+ *			Collect buildid+offset instead of ips for user stack,
+ *			only valid if **BPF_F_USER_STACK** is also specified.
+ *
+ *		**bpf_get_task_stack**\ () can collect up to
+ *		**PERF_MAX_STACK_DEPTH** both kernel and user frames, subject
+ *		to sufficient large buffer size. Note that
+ *		this limit can be controlled with the **sysctl** program, and
+ *		that it should be manually increased in order to profile long
+ *		user stacks (such as stacks for Java programs). To do so, use:
+ *
+ *		::
+ *
+ *			# sysctl kernel.perf_event_max_stack=3D<new value>
+ *	Return
+ *		A non-negative value equal to or less than *size* on success,
+ *		or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3389,7 +3421,8 @@ union bpf_attr {
 	FN(ringbuf_submit),		\
 	FN(ringbuf_discard),		\
 	FN(ringbuf_query),		\
-	FN(csum_level),
+	FN(csum_level),			\
+	FN(get_task_stack),
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
  * function eBPF program intends to call
--=20
2.24.1

