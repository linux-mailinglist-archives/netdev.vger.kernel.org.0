Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4180127ACE3
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 13:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgI1Lev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 07:34:51 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48614 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbgI1Lev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 07:34:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SBXSWL171212;
        Mon, 28 Sep 2020 11:33:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=ls5EWukwLTwEEeJB12YgOzvMVsP+dk+LjF2XTI0JFPw=;
 b=To9NJ1dSDnq9L+l5X5syK0JI9VcLP4BI48u9kn3fsZq1cfcesHaMSsg4Ljr/iM3Yut0o
 y08Op+sCSCXb7+6sHLwHwK9aQcB4X2MwdQqRktScs/QWixcf4/EYSnaI23n3MPljiQoT
 b7FXYXWdyhNArKddgyYPWSfnVG0YAxNrYH0B2UpLPDeivGtjU56H2B8nedYWQRpQ+zgc
 qopV2M/5TD7UzD535ZQTbkixLX2hqGDaqgx9tVSwNu6yV5nWv9m95zyL0VBkCyntS9Kp
 j6HGtpGsGzz5OfpCXMz6MYQ3RxxS/GqGlepc444QFlcFutaTuTjFtuq7ven0HVEtJCf5 gw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33swkkmetj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 11:33:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SBUffL136931;
        Mon, 28 Sep 2020 11:33:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33tfdpx811-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 11:33:23 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08SBXLWl009554;
        Mon, 28 Sep 2020 11:33:21 GMT
Received: from localhost.uk.oracle.com (/10.175.167.231)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Sep 2020 04:33:21 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com, yhs@fb.com
Cc:     linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com,
        pmladek@suse.com, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, shuah@kernel.org,
        rdna@fb.com, scott.branden@broadcom.com, quentin@isovalent.com,
        cneirabustos@gmail.com, jakub@cloudflare.com, mingo@redhat.com,
        rostedt@goodmis.org, acme@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v7 bpf-next 7/8] bpf: add bpf_seq_printf_btf helper
Date:   Mon, 28 Sep 2020 12:31:09 +0100
Message-Id: <1601292670-1616-8-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601292670-1616-1-git-send-email-alan.maguire@oracle.com>
References: <1601292670-1616-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009280093
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280094
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
 include/uapi/linux/bpf.h       |  9 +++++++++
 kernel/bpf/btf.c               |  4 ++--
 kernel/bpf/core.c              |  1 +
 kernel/trace/bpf_trace.c       | 33 +++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  9 +++++++++
 6 files changed, 56 insertions(+), 2 deletions(-)

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
index fcafe80..82817c4 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3623,6 +3623,14 @@ struct bpf_stack_build_id {
  *		The number of bytes that were written (or would have been
  *		written if output had to be truncated due to string size),
  *		or a negative error in cases of failure.
+ *
+ * long bpf_seq_printf_btf(struct seq_file *m, struct btf_ptr *ptr, u32 ptr_size, u64 flags)
+ *	Description
+ *		Use BTF to write to seq_write a string representation of
+ *		*ptr*->ptr, using *ptr*->type_id as per bpf_snprintf_btf().
+ *		*flags* are identical to those used for bpf_snprintf_btf.
+ *	Return
+ *		0 on success or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3775,6 +3783,7 @@ struct bpf_stack_build_id {
 	FN(d_path),			\
 	FN(copy_from_user),		\
 	FN(snprintf_btf),		\
+	FN(seq_printf_btf),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index be5acf6..99e307a 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5346,8 +5346,8 @@ static void btf_seq_show(struct btf_show *show, const char *fmt,
 	seq_vprintf((struct seq_file *)show->target, fmt, args);
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
index 983cbd3..6ac254e 100644
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
@@ -1695,6 +1724,10 @@ static void put_bpf_raw_tp_regs(void)
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
index fcafe80..82817c4 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3623,6 +3623,14 @@ struct bpf_stack_build_id {
  *		The number of bytes that were written (or would have been
  *		written if output had to be truncated due to string size),
  *		or a negative error in cases of failure.
+ *
+ * long bpf_seq_printf_btf(struct seq_file *m, struct btf_ptr *ptr, u32 ptr_size, u64 flags)
+ *	Description
+ *		Use BTF to write to seq_write a string representation of
+ *		*ptr*->ptr, using *ptr*->type_id as per bpf_snprintf_btf().
+ *		*flags* are identical to those used for bpf_snprintf_btf.
+ *	Return
+ *		0 on success or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3775,6 +3783,7 @@ struct bpf_stack_build_id {
 	FN(d_path),			\
 	FN(copy_from_user),		\
 	FN(snprintf_btf),		\
+	FN(seq_printf_btf),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
1.8.3.1

