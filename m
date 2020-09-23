Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23201275F29
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 19:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgIWRuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 13:50:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57756 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbgIWRuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 13:50:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NHdJ2T078113;
        Wed, 23 Sep 2020 17:49:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=W65ZGoHediW1tGKJ28cfVTH/mnDXnEiOgdsTF56G2So=;
 b=FEaIJX0tanQZizkq46C9qey7G0Lh+B364o8nIr4gmjvMMZ0C/7I54aDZd0x0K5nKR4Zu
 2tzMmpU5CFNS1SeqN4lv4g6D+dk+n+mBk3QrQmW5dyt9xd3Zq4kyg0FK5cMHMoagYAGX
 YIuhqKIliI43orXhGBiwJ2fGbZUAOrX8iki4x2hegTV4snVl/bHe2ah0W09Z0ClqkVpv
 ViXkeNbc3NWaiiAD+A6GtrNLXrG5VNoltBvNVPqksFQ61Y1f2w8V4b6R3HkhLeNLb3tg
 PAeaWYu2HowiAPrB7LeNlxCNRHdyGUvsiyaJmf3rKdPCpXgJ2aaSV4LSVAXnOfgjak5c tQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33q5rgja2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Sep 2020 17:49:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NHfQfL039965;
        Wed, 23 Sep 2020 17:47:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 33nux1gepb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 17:47:17 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08NHlF2x001008;
        Wed, 23 Sep 2020 17:47:15 GMT
Received: from localhost.uk.oracle.com (/10.175.195.80)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Sep 2020 10:47:15 -0700
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
Subject: [PATCH v6 bpf-next 5/6] bpf: add bpf_seq_printf_btf helper
Date:   Wed, 23 Sep 2020 18:46:27 +0100
Message-Id: <1600883188-4831-6-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600883188-4831-1-git-send-email-alan.maguire@oracle.com>
References: <1600883188-4831-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009230135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 clxscore=1015 suspectscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230135
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A helper is added to allow seq file writing of kernel data
structures using vmlinux BTF.  Its signature is

long bpf_seq_printf_btf(struct seq_file *m, struct btf_ptr *ptr,
			u32 btf_ptr_size, u64 flags);

Flags and struct btf_ptr definitions/use are identical to the
bpf_snprintf_btf helper, and the helper returns 0 on success
or a negative error value.

Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 include/linux/btf.h            |  2 ++
 include/uapi/linux/bpf.h       | 10 ++++++++++
 kernel/bpf/btf.c               |  4 ++--
 kernel/bpf/core.c              |  1 +
 kernel/trace/bpf_trace.c       | 33 +++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h | 10 ++++++++++
 6 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 3e5cdc2..024e16f 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -68,6 +68,8 @@ const struct btf_type *btf_type_id_size(const struct btf *btf,
 
 void btf_type_seq_show(const struct btf *btf, u32 type_id, void *obj,
 		       struct seq_file *m);
+int btf_type_seq_show_flags(const struct btf *btf, u32 type_id, void *obj,
+			    struct seq_file *m, u64 flags);
 
 /*
  * Copy len bytes of string representation of obj of BTF type_id into buf.
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index c1675ad..c3231a8 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3621,6 +3621,15 @@ struct bpf_stack_build_id {
  *		The number of bytes that were written (or would have been
  *		written if output had to be truncated due to string size),
  *		or a negative error in cases of failure.
+ *
+ * long bpf_seq_printf_btf(struct seq_file *m, struct btf_ptr *ptr, u32 ptr_size, u64 flags)
+ *	Description
+ *		Use BTF to write to seq_write a string representation of
+ *		*ptr*->ptr, using *ptr*->type name or *ptr*->type_id as per
+ *		bpf_snprintf_btf() above.  *flags* are identical to those
+ *		used for bpf_snprintf_btf.
+ *	Return
+ *		0 on success or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3773,6 +3782,7 @@ struct bpf_stack_build_id {
 	FN(d_path),			\
 	FN(copy_from_user),		\
 	FN(snprintf_btf),		\
+	FN(seq_printf_btf),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 94190ec..dfc8654 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5316,8 +5316,8 @@ static __printf(2, 3) void btf_seq_show(struct btf_show *show, const char *fmt,
 	va_end(args);
 }
 
-static int btf_type_seq_show_flags(const struct btf *btf, u32 type_id,
-				   void *obj, struct seq_file *m, u64 flags)
+int btf_type_seq_show_flags(const struct btf *btf, u32 type_id,
+			    void *obj, struct seq_file *m, u64 flags)
 {
 	struct btf_show sseq;
 
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 403fb23..c4ba45f 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2217,6 +2217,7 @@ void bpf_user_rnd_init_once(void)
 const struct bpf_func_proto bpf_get_local_storage_proto __weak;
 const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto __weak;
 const struct bpf_func_proto bpf_snprintf_btf_proto __weak;
+const struct bpf_func_proto bpf_seq_printf_btf_proto __weak;
 
 const struct bpf_func_proto * __weak bpf_get_trace_printk_proto(void)
 {
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 61c274f8..e8fa1c0 100644
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
@@ -776,6 +780,31 @@ struct bpf_seq_printf_buf {
 	.arg3_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
+BPF_CALL_4(bpf_seq_printf_btf, struct seq_file *, m, struct btf_ptr *, ptr,
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
+static const struct bpf_func_proto bpf_seq_printf_btf_proto = {
+	.func		= bpf_seq_printf_btf,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_BTF_ID,
+	.arg1_btf_id	= &btf_seq_file_ids[0],
+	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg3_type	= ARG_CONST_SIZE_OR_ZERO,
+	.arg4_type	= ARG_ANYTHING,
+};
+
 static __always_inline int
 get_map_perf_counter(struct bpf_map *map, u64 flags,
 		     u64 *value, u64 *enabled, u64 *running)
@@ -1731,6 +1760,10 @@ static void put_bpf_raw_tp_regs(void)
 		return prog->expected_attach_type == BPF_TRACE_ITER ?
 		       &bpf_seq_write_proto :
 		       NULL;
+	case BPF_FUNC_seq_printf_btf:
+		return prog->expected_attach_type == BPF_TRACE_ITER ?
+		       &bpf_seq_printf_btf_proto :
+		       NULL;
 	case BPF_FUNC_d_path:
 		return &bpf_d_path_proto;
 	default:
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index c1675ad..c3231a8 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3621,6 +3621,15 @@ struct bpf_stack_build_id {
  *		The number of bytes that were written (or would have been
  *		written if output had to be truncated due to string size),
  *		or a negative error in cases of failure.
+ *
+ * long bpf_seq_printf_btf(struct seq_file *m, struct btf_ptr *ptr, u32 ptr_size, u64 flags)
+ *	Description
+ *		Use BTF to write to seq_write a string representation of
+ *		*ptr*->ptr, using *ptr*->type name or *ptr*->type_id as per
+ *		bpf_snprintf_btf() above.  *flags* are identical to those
+ *		used for bpf_snprintf_btf.
+ *	Return
+ *		0 on success or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3773,6 +3782,7 @@ struct bpf_stack_build_id {
 	FN(d_path),			\
 	FN(copy_from_user),		\
 	FN(snprintf_btf),		\
+	FN(seq_printf_btf),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
1.8.3.1

