Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 559EC204A82
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 09:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731206AbgFWHI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 03:08:27 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48974 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730781AbgFWHIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 03:08:25 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 05N72GGl021664
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 00:08:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=h9hzQRSnnqUfYEsZJwB4iiRNF8tazAWqAlkR8NtDjRg=;
 b=VYFigv+8yxk+VJcSOHQisEJZB9g4+UIDm6bbKIDVJ2cU8pGemj0ik3O5mzhouFQZW8j0
 jr6/XWB4nsa6esofL2lPu2x4bO+m6A6TZu59qXTpFDoyHbf0WMSj/v/hlwYQIRcmM7gz
 XZ6IwS1rBnbTZn/mgcvYbIPvuubi42H/0aQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 31se4nmn0p-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 00:08:24 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 00:08:23 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id AEC5B62E50B5; Tue, 23 Jun 2020 00:08:16 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/3] bpf: introduce helper bpf_get_task_stack_trace()
Date:   Tue, 23 Jun 2020 00:08:00 -0700
Message-ID: <20200623070802.2310018-2-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200623070802.2310018-1-songliubraving@fb.com>
References: <20200623070802.2310018-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_04:2020-06-22,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 impostorscore=0 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0
 clxscore=1015 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 cotscore=-2147483648 adultscore=0 suspectscore=9 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006230055
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This helper can be used with bpf_iter__task to dump all /proc/*/stack to
a seq_file.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 include/uapi/linux/bpf.h       | 10 +++++++++-
 kernel/trace/bpf_trace.c       | 21 +++++++++++++++++++++
 scripts/bpf_helpers_doc.py     |  2 ++
 tools/include/uapi/linux/bpf.h | 10 +++++++++-
 4 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 19684813faaed..a30416b822fe3 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3252,6 +3252,13 @@ union bpf_attr {
  * 		case of **BPF_CSUM_LEVEL_QUERY**, the current skb->csum_level
  * 		is returned or the error code -EACCES in case the skb is not
  * 		subject to CHECKSUM_UNNECESSARY.
+ *
+ * int bpf_get_task_stack_trace(struct task_struct *task, void *entries,=
 u32 size)
+ *	Description
+ *		Save a task stack trace into array *entries*. This is a wrapper
+ *		over stack_trace_save_tsk().
+ *	Return
+ *		Number of trace entries stored.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3389,7 +3396,8 @@ union bpf_attr {
 	FN(ringbuf_submit),		\
 	FN(ringbuf_discard),		\
 	FN(ringbuf_query),		\
-	FN(csum_level),
+	FN(csum_level),			\
+	FN(get_task_stack_trace),

 /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
  * function eBPF program intends to call
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index e729c9e587a07..2c13bcb5c2bce 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1488,6 +1488,23 @@ static const struct bpf_func_proto bpf_get_stack_p=
roto_raw_tp =3D {
 	.arg4_type	=3D ARG_ANYTHING,
 };

+BPF_CALL_3(bpf_get_task_stack_trace, struct task_struct *, task,
+	   void *, entries, u32, size)
+{
+	return stack_trace_save_tsk(task, (unsigned long *)entries, size, 0);
+}
+
+static int bpf_get_task_stack_trace_btf_ids[5];
+static const struct bpf_func_proto bpf_get_task_stack_trace_proto =3D {
+	.func		=3D bpf_get_task_stack_trace,
+	.gpl_only	=3D true,
+	.ret_type	=3D RET_INTEGER,
+	.arg1_type	=3D ARG_PTR_TO_BTF_ID,
+	.arg2_type	=3D ARG_PTR_TO_MEM,
+	.arg3_type	=3D ARG_CONST_SIZE_OR_ZERO,
+	.btf_id		=3D bpf_get_task_stack_trace_btf_ids,
+};
+
 static const struct bpf_func_proto *
 raw_tp_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *=
prog)
 {
@@ -1521,6 +1538,10 @@ tracing_prog_func_proto(enum bpf_func_id func_id, =
const struct bpf_prog *prog)
 		return prog->expected_attach_type =3D=3D BPF_TRACE_ITER ?
 		       &bpf_seq_write_proto :
 		       NULL;
+	case BPF_FUNC_get_task_stack_trace:
+		return prog->expected_attach_type =3D=3D BPF_TRACE_ITER ?
+			&bpf_get_task_stack_trace_proto :
+			NULL;
 	default:
 		return raw_tp_prog_func_proto(func_id, prog);
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
index 19684813faaed..a30416b822fe3 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3252,6 +3252,13 @@ union bpf_attr {
  * 		case of **BPF_CSUM_LEVEL_QUERY**, the current skb->csum_level
  * 		is returned or the error code -EACCES in case the skb is not
  * 		subject to CHECKSUM_UNNECESSARY.
+ *
+ * int bpf_get_task_stack_trace(struct task_struct *task, void *entries,=
 u32 size)
+ *	Description
+ *		Save a task stack trace into array *entries*. This is a wrapper
+ *		over stack_trace_save_tsk().
+ *	Return
+ *		Number of trace entries stored.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3389,7 +3396,8 @@ union bpf_attr {
 	FN(ringbuf_submit),		\
 	FN(ringbuf_discard),		\
 	FN(ringbuf_query),		\
-	FN(csum_level),
+	FN(csum_level),			\
+	FN(get_task_stack_trace),

 /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
  * function eBPF program intends to call
--
2.24.1
