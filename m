Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907143F7CED
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 21:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242511AbhHYT7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 15:59:31 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7886 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235554AbhHYT73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 15:59:29 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17PJpONp008913
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 12:58:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=84wBGCdA2aV9AzKBAJAgqkcZ74jy399t7G1gKlE8m0o=;
 b=Doxo8ny5zOiFkLACAIoQvuVUtWRkR5fy6B8I11lxLXZLWv5FLn21TIPQSXE/kpIY9qfi
 wssYRWwj7bySJkZE9jNsHALeqSFT9nTfL4PPW0TL7soPj2igCo5K/lvoFgRhxtCf8VHP
 VM+sCC3wV5Z9rIWxYG4CwhuOLk2ynfvU4V0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3an5sm894f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 12:58:43 -0700
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 25 Aug 2021 12:58:42 -0700
Received: by devbig030.frc3.facebook.com (Postfix, from userid 158236)
        id 8FCDD5A34E6F; Wed, 25 Aug 2021 12:58:34 -0700 (PDT)
From:   Dave Marchevsky <davemarchevsky@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, <netdev@vger.kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: [PATCH v2 bpf-next 2/6] bpf: add bpf_trace_vprintk helper
Date:   Wed, 25 Aug 2021 12:58:19 -0700
Message-ID: <20210825195823.381016-3-davemarchevsky@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210825195823.381016-1-davemarchevsky@fb.com>
References: <20210825195823.381016-1-davemarchevsky@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: xDkjWQ03NrtNr3O00rTtzi0KPwOXtMw4
X-Proofpoint-ORIG-GUID: xDkjWQ03NrtNr3O00rTtzi0KPwOXtMw4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-25_07:2021-08-25,2021-08-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 clxscore=1015 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108250117
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This helper is meant to be "bpf_trace_printk, but with proper vararg
support". Follow bpf_snprintf's example and take a u64 pseudo-vararg
array. Write to /sys/kernel/debug/tracing/trace_pipe using the same
mechanism as bpf_trace_printk.

Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
---
 include/linux/bpf.h            |  1 +
 include/uapi/linux/bpf.h       |  9 ++++++
 kernel/bpf/core.c              |  5 ++++
 kernel/bpf/helpers.c           |  2 ++
 kernel/trace/bpf_trace.c       | 52 +++++++++++++++++++++++++++++++++-
 tools/include/uapi/linux/bpf.h |  9 ++++++
 6 files changed, 77 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index be8d57e6e78a..b6c45a6cbbba 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1088,6 +1088,7 @@ bool bpf_prog_array_compatible(struct bpf_array *ar=
ray, const struct bpf_prog *f
 int bpf_prog_calc_tag(struct bpf_prog *fp);
=20
 const struct bpf_func_proto *bpf_get_trace_printk_proto(void);
+const struct bpf_func_proto *bpf_get_trace_vprintk_proto(void);
=20
 typedef unsigned long (*bpf_ctx_copy_t)(void *dst, const void *src,
 					unsigned long off, unsigned long len);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index c4f7892edb2b..33414cbeda53 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4871,6 +4871,14 @@ union bpf_attr {
  * 	Return
  *		Value specified by user at BPF link creation/attachment time
  *		or 0, if it was not specified.
+ *
+ * u64 bpf_trace_vprintk(const char *fmt, u32 fmt_size, const void *data=
, u32 data_len)
+ *	Description
+ *		Behaves like **bpf_trace_printk**\ () helper, but takes an array of =
u64
+ *		to format. Arguments are to be used as in **bpf_seq_printf**\ () hel=
per.
+ *	Return
+ *		The number of bytes written to the buffer, or a negative error
+ *		in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5048,6 +5056,7 @@ union bpf_attr {
 	FN(timer_cancel),		\
 	FN(get_func_ip),		\
 	FN(get_attach_cookie),		\
+	FN(trace_vprintk),		\
 	/* */
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 91f24c7b38a1..a137c550046c 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2357,6 +2357,11 @@ const struct bpf_func_proto * __weak bpf_get_trace=
_printk_proto(void)
 	return NULL;
 }
=20
+const struct bpf_func_proto * __weak bpf_get_trace_vprintk_proto(void)
+{
+	return NULL;
+}
+
 u64 __weak
 bpf_event_output(struct bpf_map *map, u64 flags, void *meta, u64 meta_si=
ze,
 		 void *ctx, u64 ctx_size, bpf_ctx_copy_t ctx_copy)
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 5ce19b376ef7..863e5ee68558 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1419,6 +1419,8 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return &bpf_snprintf_btf_proto;
 	case BPF_FUNC_snprintf:
 		return &bpf_snprintf_proto;
+	case BPF_FUNC_trace_vprintk:
+		return bpf_get_trace_vprintk_proto();
 	default:
 		return NULL;
 	}
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 2cf4bfa1ab7b..83df67f739d6 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -398,7 +398,7 @@ static const struct bpf_func_proto bpf_trace_printk_p=
roto =3D {
 	.arg2_type	=3D ARG_CONST_SIZE,
 };
=20
-const struct bpf_func_proto *bpf_get_trace_printk_proto(void)
+static void __set_printk_clr_event(void)
 {
 	/*
 	 * This program might be calling bpf_trace_printk,
@@ -410,10 +410,58 @@ const struct bpf_func_proto *bpf_get_trace_printk_p=
roto(void)
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
+BPF_CALL_4(bpf_trace_vprintk, char *, fmt, u32, fmt_size, const void *, =
data,
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
 BPF_CALL_5(bpf_seq_printf, struct seq_file *, m, char *, fmt, u32, fmt_s=
ize,
 	   const void *, data, u32, data_len)
 {
@@ -1113,6 +1161,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, co=
nst struct bpf_prog *prog)
 		return &bpf_snprintf_proto;
 	case BPF_FUNC_get_func_ip:
 		return &bpf_get_func_ip_proto_tracing;
+	case BPF_FUNC_trace_vprintk:
+		return bpf_get_trace_vprintk_proto();
 	default:
 		return bpf_base_func_proto(func_id);
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index c4f7892edb2b..33414cbeda53 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4871,6 +4871,14 @@ union bpf_attr {
  * 	Return
  *		Value specified by user at BPF link creation/attachment time
  *		or 0, if it was not specified.
+ *
+ * u64 bpf_trace_vprintk(const char *fmt, u32 fmt_size, const void *data=
, u32 data_len)
+ *	Description
+ *		Behaves like **bpf_trace_printk**\ () helper, but takes an array of =
u64
+ *		to format. Arguments are to be used as in **bpf_seq_printf**\ () hel=
per.
+ *	Return
+ *		The number of bytes written to the buffer, or a negative error
+ *		in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5048,6 +5056,7 @@ union bpf_attr {
 	FN(timer_cancel),		\
 	FN(get_func_ip),		\
 	FN(get_attach_cookie),		\
+	FN(trace_vprintk),		\
 	/* */
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
--=20
2.30.2

