Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2845340FF5F
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 20:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241162AbhIQSat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 14:30:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25622 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241447AbhIQSaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 14:30:46 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18HFeFAA001951
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 11:29:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=z+KeD8RJogKqQLaUcnoQ7zJuEW0ZQOClDFQXIXmzT7Q=;
 b=KOxNZfmzEZvcqt8/y6j3OARYeofNrWBK6EP8G9+BoTLX1LIr/d+iYLkhgR6LPG0yi/BP
 QfERiBE1LEZMccBc+QPP16fCDV9BjH8HUV0IoRVxmcem9fjscoN01oxLwcz/d0V8tBP8
 MljlKqtW+Y7wutZjj4DqMq5jDEmNTHNjwC0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3b4j7w5g90-18
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 11:29:23 -0700
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 17 Sep 2021 11:29:18 -0700
Received: by devbig030.frc3.facebook.com (Postfix, from userid 158236)
        id E609B6BF31C5; Fri, 17 Sep 2021 11:29:15 -0700 (PDT)
From:   Dave Marchevsky <davemarchevsky@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, <netdev@vger.kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: [PATCH v6 bpf-next 3/9] bpf: add bpf_trace_vprintk helper
Date:   Fri, 17 Sep 2021 11:29:05 -0700
Message-ID: <20210917182911.2426606-4-davemarchevsky@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210917182911.2426606-1-davemarchevsky@fb.com>
References: <20210917182911.2426606-1-davemarchevsky@fb.com>
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: ZxRIiZ37MH8egNL_kp5gp_hyxAJH1xQp
X-Proofpoint-GUID: ZxRIiZ37MH8egNL_kp5gp_hyxAJH1xQp
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-17_07,2021-09-17_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 impostorscore=0 malwarescore=0 clxscore=1015 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 adultscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109030001 definitions=main-2109170110
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This helper is meant to be "bpf_trace_printk, but with proper vararg
support". Follow bpf_snprintf's example and take a u64 pseudo-vararg
array. Write to /sys/kernel/debug/tracing/trace_pipe using the same
mechanism as bpf_trace_printk. The functionality of this helper was
requested in the libbpf issue tracker [0].

[0] Closes: https://github.com/libbpf/libbpf/issues/315

Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
---
 include/linux/bpf.h            |  1 +
 include/uapi/linux/bpf.h       | 11 +++++++
 kernel/bpf/core.c              |  5 ++++
 kernel/bpf/helpers.c           |  2 ++
 kernel/trace/bpf_trace.c       | 52 +++++++++++++++++++++++++++++++++-
 tools/include/uapi/linux/bpf.h | 11 +++++++
 6 files changed, 81 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index be8d57e6e78a..b6c45a6cbbba 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1088,6 +1088,7 @@ bool bpf_prog_array_compatible(struct bpf_array *arra=
y, const struct bpf_prog *f
 int bpf_prog_calc_tag(struct bpf_prog *fp);
=20
 const struct bpf_func_proto *bpf_get_trace_printk_proto(void);
+const struct bpf_func_proto *bpf_get_trace_vprintk_proto(void);
=20
 typedef unsigned long (*bpf_ctx_copy_t)(void *dst, const void *src,
 					unsigned long off, unsigned long len);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 3e9785f1064a..98ca79a67937 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4898,6 +4898,16 @@ union bpf_attr {
  *		**-EINVAL** if *flags* is not zero.
  *
  *		**-ENOENT** if architecture does not support branch records.
+ *
+ * long bpf_trace_vprintk(const char *fmt, u32 fmt_size, const void *data,=
 u32 data_len)
+ *	Description
+ *		Behaves like **bpf_trace_printk**\ () helper, but takes an array of u64
+ *		to format and can handle more format args as a result.
+ *
+ *		Arguments are to be used as in **bpf_seq_printf**\ () helper.
+ *	Return
+ *		The number of bytes written to the buffer, or a negative error
+ *		in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5077,6 +5087,7 @@ union bpf_attr {
 	FN(get_attach_cookie),		\
 	FN(task_pt_regs),		\
 	FN(get_branch_snapshot),	\
+	FN(trace_vprintk),		\
 	/* */
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which help=
er
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 9f4636d021b1..6fddc13fe67f 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2357,6 +2357,11 @@ const struct bpf_func_proto * __weak bpf_get_trace_p=
rintk_proto(void)
 	return NULL;
 }
=20
+const struct bpf_func_proto * __weak bpf_get_trace_vprintk_proto(void)
+{
+	return NULL;
+}
+
 u64 __weak
 bpf_event_output(struct bpf_map *map, u64 flags, void *meta, u64 meta_size,
 		 void *ctx, u64 ctx_size, bpf_ctx_copy_t ctx_copy)
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 8f9f392c1322..2c604ff8c7fb 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1435,6 +1435,8 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return &bpf_snprintf_proto;
 	case BPF_FUNC_task_pt_regs:
 		return &bpf_task_pt_regs_proto;
+	case BPF_FUNC_trace_vprintk:
+		return bpf_get_trace_vprintk_proto();
 	default:
 		return NULL;
 	}
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 4ec779fa0c1d..6b3153841a33 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -398,7 +398,7 @@ static const struct bpf_func_proto bpf_trace_printk_pro=
to =3D {
 	.arg2_type	=3D ARG_CONST_SIZE,
 };
=20
-const struct bpf_func_proto *bpf_get_trace_printk_proto(void)
+static void __set_printk_clr_event(void)
 {
 	/*
 	 * This program might be calling bpf_trace_printk,
@@ -410,10 +410,58 @@ const struct bpf_func_proto *bpf_get_trace_printk_pro=
to(void)
 	 */
 	if (trace_set_clr_event("bpf_trace", "bpf_trace_printk", 1))
 		pr_warn_ratelimited("could not enable bpf_trace_printk events");
+}
=20
+const struct bpf_func_proto *bpf_get_trace_printk_proto(void)
+{
+	__set_printk_clr_event();
 	return &bpf_trace_printk_proto;
 }
=20
+BPF_CALL_4(bpf_trace_vprintk, char *, fmt, u32, fmt_size, const void *, da=
ta,
+	   u32, data_len)
+{
+	static char buf[BPF_TRACE_PRINTK_SIZE];
+	unsigned long flags;
+	int ret, num_args;
+	u32 *bin_args;
+
+	if (data_len & 7 || data_len > MAX_BPRINTF_VARARGS * 8 ||
+	    (data_len && !data))
+		return -EINVAL;
+	num_args =3D data_len / 8;
+
+	ret =3D bpf_bprintf_prepare(fmt, fmt_size, data, &bin_args, num_args);
+	if (ret < 0)
+		return ret;
+
+	raw_spin_lock_irqsave(&trace_printk_lock, flags);
+	ret =3D bstr_printf(buf, sizeof(buf), fmt, bin_args);
+
+	trace_bpf_trace_printk(buf);
+	raw_spin_unlock_irqrestore(&trace_printk_lock, flags);
+
+	bpf_bprintf_cleanup();
+
+	return ret;
+}
+
+static const struct bpf_func_proto bpf_trace_vprintk_proto =3D {
+	.func		=3D bpf_trace_vprintk,
+	.gpl_only	=3D true,
+	.ret_type	=3D RET_INTEGER,
+	.arg1_type	=3D ARG_PTR_TO_MEM,
+	.arg2_type	=3D ARG_CONST_SIZE,
+	.arg3_type	=3D ARG_PTR_TO_MEM_OR_NULL,
+	.arg4_type	=3D ARG_CONST_SIZE_OR_ZERO,
+};
+
+const struct bpf_func_proto *bpf_get_trace_vprintk_proto(void)
+{
+	__set_printk_clr_event();
+	return &bpf_trace_vprintk_proto;
+}
+
 BPF_CALL_5(bpf_seq_printf, struct seq_file *, m, char *, fmt, u32, fmt_siz=
e,
 	   const void *, data, u32, data_len)
 {
@@ -1160,6 +1208,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, cons=
t struct bpf_prog *prog)
 		return &bpf_get_func_ip_proto_tracing;
 	case BPF_FUNC_get_branch_snapshot:
 		return &bpf_get_branch_snapshot_proto;
+	case BPF_FUNC_trace_vprintk:
+		return bpf_get_trace_vprintk_proto();
 	default:
 		return bpf_base_func_proto(func_id);
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 3e9785f1064a..98ca79a67937 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4898,6 +4898,16 @@ union bpf_attr {
  *		**-EINVAL** if *flags* is not zero.
  *
  *		**-ENOENT** if architecture does not support branch records.
+ *
+ * long bpf_trace_vprintk(const char *fmt, u32 fmt_size, const void *data,=
 u32 data_len)
+ *	Description
+ *		Behaves like **bpf_trace_printk**\ () helper, but takes an array of u64
+ *		to format and can handle more format args as a result.
+ *
+ *		Arguments are to be used as in **bpf_seq_printf**\ () helper.
+ *	Return
+ *		The number of bytes written to the buffer, or a negative error
+ *		in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5077,6 +5087,7 @@ union bpf_attr {
 	FN(get_attach_cookie),		\
 	FN(task_pt_regs),		\
 	FN(get_branch_snapshot),	\
+	FN(trace_vprintk),		\
 	/* */
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which help=
er
--=20
2.30.2

