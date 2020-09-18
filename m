Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C9A26FEB6
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 15:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgIRNg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 09:36:58 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43724 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgIRNg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 09:36:58 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08IDZ06d150461;
        Fri, 18 Sep 2020 13:36:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=szkY3iGmeag5lu7sNlObRYjPNSfXniNi6vqm1qzKLB0=;
 b=HG6r9j6cPgEP12t1GlmsuLgvSQsxenwDxyJVjMbZpk/JIgIfRO3vb+WXJCUQXaKPumXm
 0ihjNojeZehdo8iU2Lsp6daVwpdcwIo+nsLgQ5LTTOCuMZ14hRyOAjsIjkoJpCVRVIpA
 3WKdT6XZup4tSVtgm9ZjS/JFyGkOXTatfbFCfugIGviWW/qpO9h/fyUbldVgVJXgRQ1Z
 dbsqIvlTVkLeI9t5Kjo39UoWSV4FjlIRQ4pUQF64hDN92if7wjVNzmr0j/XJpP+wN64o
 CvbTaaZD/VvsYjiGNDdYW0IvF1LwsFfe2xlzuqpHWfEaefqrsFvN2inQjXuZhL+5zNGS fA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33gp9mq5un-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Sep 2020 13:36:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08IDa2F5063855;
        Fri, 18 Sep 2020 13:36:07 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33hm36v2y9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Sep 2020 13:36:06 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08IDa41A018592;
        Fri, 18 Sep 2020 13:36:04 GMT
Received: from localhost.uk.oracle.com (/10.175.217.104)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Sep 2020 13:35:55 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com, yhs@fb.com
Cc:     linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com,
        pmladek@suse.com, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, shuah@kernel.org,
        rdna@fb.com, scott.branden@broadcom.com, quentin@isovalent.com,
        cneirabustos@gmail.com, jakub@cloudflare.com, mingo@redhat.com,
        rostedt@goodmis.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        acme@kernel.org, Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v5 bpf-next 5/6] bpf: add bpf_seq_btf_write helper
Date:   Fri, 18 Sep 2020 14:34:34 +0100
Message-Id: <1600436075-2961-6-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600436075-2961-1-git-send-email-alan.maguire@oracle.com>
References: <1600436075-2961-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009180111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009180110
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A helper is added to allow seq file writing of kernel data
structures using vmlinux BTF.  Its signature is

long bpf_seq_btf_write(struct seq_file *m, struct btf_ptr *ptr,
		       u32 btf_ptr_size, u64 flags);

Flags and struct btf_ptr definitions/use are identical to the
bpf_btf_snprintf helper, and the helper returns 0 on success
or a negative error value.

Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 include/linux/btf.h            |  3 ++
 include/uapi/linux/bpf.h       | 10 ++++++
 kernel/bpf/btf.c               | 17 +++++++---
 kernel/trace/bpf_trace.c       | 75 +++++++++++++++++++++++++++++++++---------
 tools/include/uapi/linux/bpf.h | 10 ++++++
 5 files changed, 96 insertions(+), 19 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 3e5cdc2..eed23a4 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -69,6 +69,9 @@ const struct btf_type *btf_type_id_size(const struct btf *btf,
 void btf_type_seq_show(const struct btf *btf, u32 type_id, void *obj,
 		       struct seq_file *m);
 
+int btf_type_seq_show_flags(const struct btf *btf, u32 type_id, void *obj,
+			    struct seq_file *m, u64 flags);
+
 /*
  * Copy len bytes of string representation of obj of BTF type_id into buf.
  *
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 9b89b67..c0815f1 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3614,6 +3614,15 @@ struct bpf_stack_build_id {
  *		The number of bytes that were written (or would have been
  *		written if output had to be truncated due to string size),
  *		or a negative error in cases of failure.
+ *
+ * long bpf_seq_btf_write(struct seq_file *m, struct btf_ptr *ptr, u32 ptr_size, u64 flags)
+ *	Description
+ *		Use BTF to write to seq_write a string representation of
+ *		*ptr*->ptr, using *ptr*->type name or *ptr*->type_id as per
+ *		bpf_btf_snprintf() above.  *flags* are identical to those
+ *		used for bpf_btf_snprintf.
+ *	Return
+ *		0 on success or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3766,6 +3775,7 @@ struct bpf_stack_build_id {
 	FN(d_path),			\
 	FN(copy_from_user),		\
 	FN(btf_snprintf),		\
+	FN(seq_btf_write),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 70f5b88..0902464 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5328,17 +5328,26 @@ static void btf_seq_show(struct btf_show *show, const char *fmt, ...)
 	va_end(args);
 }
 
-void btf_type_seq_show(const struct btf *btf, u32 type_id, void *obj,
-			struct seq_file *m)
+int btf_type_seq_show_flags(const struct btf *btf, u32 type_id, void *obj,
+			struct seq_file *m, u64 flags)
 {
 	struct btf_show sseq;
 
 	sseq.target = m;
 	sseq.showfn = btf_seq_show;
-	sseq.flags = BTF_SHOW_NONAME | BTF_SHOW_COMPACT | BTF_SHOW_ZERO |
-		     BTF_SHOW_UNSAFE;
+	sseq.flags = flags;
 
 	btf_type_show(btf, type_id, obj, &sseq);
+
+	return sseq.state.status;
+}
+
+void btf_type_seq_show(const struct btf *btf, u32 type_id, void *obj,
+		       struct seq_file *m)
+{
+	(void) btf_type_seq_show_flags(btf, type_id, obj, m,
+				       BTF_SHOW_NONAME | BTF_SHOW_COMPACT |
+				       BTF_SHOW_ZERO | BTF_SHOW_UNSAFE);
 }
 
 struct btf_show_snprintf {
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index f171e03..eee36a8 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -71,6 +71,10 @@ static struct bpf_raw_event_map *bpf_get_raw_tracepoint_module(const char *name)
 u64 bpf_get_stackid(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
 u64 bpf_get_stack(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
 
+static int bpf_btf_printf_prepare(struct btf_ptr *ptr, u32 btf_ptr_size,
+				  u64 flags, const struct btf **btf,
+				  s32 *btf_id);
+
 /**
  * trace_call_bpf - invoke BPF program
  * @call: tracepoint event
@@ -780,6 +784,30 @@ struct bpf_seq_printf_buf {
 	.btf_id		= bpf_seq_write_btf_ids,
 };
 
+BPF_CALL_4(bpf_seq_btf_write, struct seq_file *, m, struct btf_ptr *, ptr,
+	   u32, btf_ptr_size, u64, flags)
+{
+	const struct btf *btf;
+	s32 btf_id;
+	int ret;
+
+	ret = bpf_btf_printf_prepare(ptr, btf_ptr_size, flags, &btf, &btf_id);
+	if (ret)
+		return ret;
+
+	return btf_type_seq_show_flags(btf, btf_id, ptr->ptr, m, flags);
+}
+
+static const struct bpf_func_proto bpf_seq_btf_write_proto = {
+	.func		= bpf_seq_btf_write,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type      = ARG_PTR_TO_BTF_ID,
+	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg3_type	= ARG_CONST_SIZE_OR_ZERO,
+	.btf_id		= bpf_seq_write_btf_ids,
+};
+
 static __always_inline int
 get_map_perf_counter(struct bpf_map *map, u64 flags,
 		     u64 *value, u64 *enabled, u64 *running)
@@ -1151,15 +1179,14 @@ static bool bpf_d_path_allowed(const struct bpf_prog *prog)
 #define BTF_F_ALL	(BTF_F_COMPACT  | BTF_F_NONAME | \
 			 BTF_F_PTR_RAW | BTF_F_ZERO)
 
-BPF_CALL_5(bpf_btf_snprintf, char *, str, u32, str_size, struct btf_ptr *, ptr,
-	   u32, btf_ptr_size, u64, flags)
+static int bpf_btf_printf_prepare(struct btf_ptr *ptr, u32 btf_ptr_size,
+				  u64 flags, const struct btf **btf,
+				  s32 *btf_id)
 {
 	u8 btf_kind = BTF_KIND_TYPEDEF;
 	char type_name[KSYM_NAME_LEN];
 	const struct btf_type *t;
-	const struct btf *btf;
 	const char *btf_type;
-	s32 btf_id;
 	int ret;
 
 	if (unlikely(flags & ~(BTF_F_ALL)))
@@ -1168,10 +1195,10 @@ static bool bpf_d_path_allowed(const struct bpf_prog *prog)
 	if (btf_ptr_size != sizeof(struct btf_ptr))
 		return -EINVAL;
 
-	btf = bpf_get_btf_vmlinux();
+	*btf = bpf_get_btf_vmlinux();
 
-	if (IS_ERR_OR_NULL(btf))
-		return PTR_ERR(btf);
+	if (IS_ERR_OR_NULL(*btf))
+		return PTR_ERR(*btf);
 
 	if (ptr->type != NULL) {
 		ret = copy_from_kernel_nofault(type_name, ptr->type,
@@ -1201,20 +1228,34 @@ static bool bpf_d_path_allowed(const struct bpf_prog *prog)
 		 *
 		 * Fall back to BTF_KIND_INT if this fails.
 		 */
-		btf_id = btf_find_by_name_kind(btf, btf_type, btf_kind);
-		if (btf_id < 0)
-			btf_id = btf_find_by_name_kind(btf, btf_type,
-						       BTF_KIND_INT);
+		*btf_id = btf_find_by_name_kind(*btf, btf_type, btf_kind);
+		if (*btf_id < 0)
+			*btf_id = btf_find_by_name_kind(*btf, btf_type,
+							BTF_KIND_INT);
 	} else if (ptr->type_id > 0)
-		btf_id = ptr->type_id;
+		*btf_id = ptr->type_id;
 	else
 		return -EINVAL;
 
-	if (btf_id > 0)
-		t = btf_type_by_id(btf, btf_id);
-	if (btf_id <= 0 || !t)
+	if (*btf_id > 0)
+		t = btf_type_by_id(*btf, *btf_id);
+	if (*btf_id <= 0 || !t)
 		return -ENOENT;
 
+	return 0;
+}
+
+BPF_CALL_5(bpf_btf_snprintf, char *, str, u32, str_size, struct btf_ptr *, ptr,
+	   u32, btf_ptr_size, u64, flags)
+{
+	const struct btf *btf;
+	s32 btf_id;
+	int ret;
+
+	ret = bpf_btf_printf_prepare(ptr, btf_ptr_size, flags, &btf, &btf_id);
+	if (ret)
+		return ret;
+
 	return btf_type_snprintf_show(btf, btf_id, ptr->ptr, str, str_size,
 				      flags);
 }
@@ -1715,6 +1756,10 @@ static void put_bpf_raw_tp_regs(void)
 		return prog->expected_attach_type == BPF_TRACE_ITER ?
 		       &bpf_seq_write_proto :
 		       NULL;
+	case BPF_FUNC_seq_btf_write:
+		return prog->expected_attach_type == BPF_TRACE_ITER ?
+		       &bpf_seq_btf_write_proto :
+		       NULL;
 	case BPF_FUNC_d_path:
 		return &bpf_d_path_proto;
 	default:
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 9b89b67..c0815f1 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3614,6 +3614,15 @@ struct bpf_stack_build_id {
  *		The number of bytes that were written (or would have been
  *		written if output had to be truncated due to string size),
  *		or a negative error in cases of failure.
+ *
+ * long bpf_seq_btf_write(struct seq_file *m, struct btf_ptr *ptr, u32 ptr_size, u64 flags)
+ *	Description
+ *		Use BTF to write to seq_write a string representation of
+ *		*ptr*->ptr, using *ptr*->type name or *ptr*->type_id as per
+ *		bpf_btf_snprintf() above.  *flags* are identical to those
+ *		used for bpf_btf_snprintf.
+ *	Return
+ *		0 on success or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3766,6 +3775,7 @@ struct bpf_stack_build_id {
 	FN(d_path),			\
 	FN(copy_from_user),		\
 	FN(btf_snprintf),		\
+	FN(seq_btf_write),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
1.8.3.1

