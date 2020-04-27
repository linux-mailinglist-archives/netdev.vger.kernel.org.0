Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD70A1BAF05
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 22:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgD0UNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 16:13:05 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44458 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726691AbgD0UM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 16:12:56 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03RK1sOs011056
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:12:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Z5WzyvU6Bl8evAcaKXqHCQvCbQ9llNqfDDDZxr8FaQY=;
 b=i3tp1E4IRNYbXRLHTRVbl6tgqsB1tnDU8SXfNovpSTDgCG4WGP2c+8d75ASr9W65g8Is
 MSer/uSCw9FpZuxWLgAhASINUoVFayqUI2GAM7s4p4HObBKW5trtnlpZLPBu0HQL7nIB
 J86O2qKCTdshotSUI5nKNjvH9ZQs+jfvLgY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30mk1gdyeq-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:12:54 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 27 Apr 2020 13:12:53 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 0D89E3700871; Mon, 27 Apr 2020 13:12:49 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v1 12/19] bpf: add bpf_seq_printf and bpf_seq_write helpers
Date:   Mon, 27 Apr 2020 13:12:49 -0700
Message-ID: <20200427201249.2995688-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200427201235.2994549-1-yhs@fb.com>
References: <20200427201235.2994549-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_15:2020-04-27,2020-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270161
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two helpers bpf_seq_printf and bpf_seq_write, are added for
writing data to the seq_file buffer.

bpf_seq_printf supports common format string flag/width/type
fields so at least I can get identical results for
netlink and ipv6_route targets.

For bpf_seq_printf and bpf_seq_write, return value -EOVERFLOW
specifically indicates a write failure due to overflow, which
means the object will be repeated in the next bpf invocation
if object collection stays the same. Note that if the object
collection is changed, depending how collection traversal is
done, even if the object still in the collection, it may not
be visited.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/uapi/linux/bpf.h       |  31 ++++++-
 kernel/trace/bpf_trace.c       | 159 +++++++++++++++++++++++++++++++++
 scripts/bpf_helpers_doc.py     |   2 +
 tools/include/uapi/linux/bpf.h |  31 ++++++-
 4 files changed, 221 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 576651110d16..f0ab17d8fb73 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3042,6 +3042,33 @@ union bpf_attr {
  * 		See: clock_gettime(CLOCK_BOOTTIME)
  * 	Return
  * 		Current *ktime*.
+ *
+ * int bpf_seq_printf(struct seq_file *m, const char *fmt, u32 fmt_size,=
 const void *data, u32 data_len)
+ * 	Description
+ * 		seq_printf uses seq_file seq_printf() to print out the format strin=
g.
+ * 		The *m* represents the seq_file. The *fmt* and *fmt_size* are for
+ * 		the format string itself. The *data* and *data_len* are format stri=
ng
+ * 		arguments. The *data* are a u64 array and corresponding format stri=
ng
+ * 		values are stored in the array. For strings and pointers where poin=
tees
+ * 		are accessed, only the pointer values are stored in the *data* arra=
y.
+ * 		The *data_len* is the *data* size in term of bytes.
+ * 	Return
+ * 		0 on success, or a negative errno in case of failure.
+ *
+ *		* **-EINVAL**		Invalid arguments, or invalid/unsupported formats.
+ *		* **-E2BIG**		Too many format specifiers.
+ *		* **-ENOMEM**		No enough memory to copy pointees or strings.
+ *		* **-EOVERFLOW**	Overflow happens, the same object will be tried aga=
in.
+ *
+ * int bpf_seq_write(struct seq_file *m, const void *data, u32 len)
+ * 	Description
+ * 		seq_write uses seq_file seq_write() to write the data.
+ * 		The *m* represents the seq_file. The *data* and *len* represent the
+ *		data to write in bytes.
+ * 	Return
+ * 		0 on success, or a negative errno in case of failure.
+ *
+ *		* **-EOVERFLOW**	Overflow happens, the same object will be tried aga=
in.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3169,7 +3196,9 @@ union bpf_attr {
 	FN(get_netns_cookie),		\
 	FN(get_current_ancestor_cgroup_id),	\
 	FN(sk_assign),			\
-	FN(ktime_get_boot_ns),
+	FN(ktime_get_boot_ns),		\
+	FN(seq_printf),			\
+	FN(seq_write),
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
  * function eBPF program intends to call
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index e875c95d3ced..f7c5587b5d2e 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -457,6 +457,161 @@ const struct bpf_func_proto *bpf_get_trace_printk_p=
roto(void)
 	return &bpf_trace_printk_proto;
 }
=20
+#define MAX_SEQ_PRINTF_VARARGS	12
+#define MAX_SEQ_PRINTF_STR_LEN	128
+
+BPF_CALL_5(bpf_seq_printf, struct seq_file *, m, char *, fmt, u32, fmt_s=
ize,
+	   const void *, data, u32, data_len)
+{
+	char bufs[MAX_SEQ_PRINTF_VARARGS][MAX_SEQ_PRINTF_STR_LEN];
+	u64 params[MAX_SEQ_PRINTF_VARARGS];
+	int i, copy_size, num_args;
+	const u64 *args =3D data;
+	int fmt_cnt =3D 0;
+
+	/*
+	 * bpf_check()->check_func_arg()->check_stack_boundary()
+	 * guarantees that fmt points to bpf program stack,
+	 * fmt_size bytes of it were initialized and fmt_size > 0
+	 */
+	if (fmt[--fmt_size] !=3D 0)
+		return -EINVAL;
+
+	if (data_len & 7)
+		return -EINVAL;
+
+	for (i =3D 0; i < fmt_size; i++) {
+		if (fmt[i] =3D=3D '%' && (!data || !data_len))
+			return -EINVAL;
+	}
+
+	num_args =3D data_len / 8;
+
+	/* check format string for allowed specifiers */
+	for (i =3D 0; i < fmt_size; i++) {
+		if ((!isprint(fmt[i]) && !isspace(fmt[i])) || !isascii(fmt[i]))
+			return -EINVAL;
+
+		if (fmt[i] !=3D '%')
+			continue;
+
+		if (fmt_cnt >=3D MAX_SEQ_PRINTF_VARARGS)
+			return -E2BIG;
+
+		if (fmt_cnt >=3D num_args)
+			return -EINVAL;
+
+		/* fmt[i] !=3D 0 && fmt[last] =3D=3D 0, so we can access fmt[i + 1] */
+		i++;
+
+		/* skip optional "[0+-][num]" width formating field */
+		while (fmt[i] =3D=3D '0' || fmt[i] =3D=3D '+'  || fmt[i] =3D=3D '-')
+			i++;
+		if (fmt[i] >=3D '1' && fmt[i] <=3D '9') {
+			i++;
+			while (fmt[i] >=3D '0' && fmt[i] <=3D '9')
+				i++;
+		}
+
+		if (fmt[i] =3D=3D 's') {
+			/* disallow any further format extensions */
+			if (fmt[i + 1] !=3D 0 &&
+			    !isspace(fmt[i + 1]) &&
+			    !ispunct(fmt[i + 1]))
+				return -EINVAL;
+
+			/* try our best to copy */
+			bufs[fmt_cnt][0] =3D 0;
+			strncpy_from_unsafe(bufs[fmt_cnt],
+					    (void *) (long) args[fmt_cnt],
+					    MAX_SEQ_PRINTF_STR_LEN);
+			params[fmt_cnt] =3D (u64)(long)bufs[fmt_cnt];
+
+			fmt_cnt++;
+			continue;
+		}
+
+		if (fmt[i] =3D=3D 'p') {
+			if (fmt[i + 1] =3D=3D 0 ||
+			    fmt[i + 1] =3D=3D 'K' ||
+			    fmt[i + 1] =3D=3D 'x') {
+				/* just kernel pointers */
+				params[fmt_cnt] =3D args[fmt_cnt];
+				fmt_cnt++;
+				continue;
+			}
+
+			/* only support "%pI4", "%pi4", "%pI6" and "pi6". */
+			if (fmt[i + 1] !=3D 'i' && fmt[i + 1] !=3D 'I')
+				return -EINVAL;
+			if (fmt[i + 2] !=3D '4' && fmt[i + 2] !=3D '6')
+				return -EINVAL;
+
+			copy_size =3D (fmt[i + 2] =3D=3D '4') ? 4 : 16;
+
+			/* try our best to copy */
+			probe_kernel_read(bufs[fmt_cnt],
+					  (void *) (long) args[fmt_cnt], copy_size);
+			params[fmt_cnt] =3D (u64)(long)bufs[fmt_cnt];
+
+			i +=3D 2;
+			fmt_cnt++;
+			continue;
+		}
+
+		if (fmt[i] =3D=3D 'l') {
+			i++;
+			if (fmt[i] =3D=3D 'l')
+				i++;
+		}
+
+		if (fmt[i] !=3D 'i' && fmt[i] !=3D 'd' &&
+		    fmt[i] !=3D 'u' && fmt[i] !=3D 'x')
+			return -EINVAL;
+
+		params[fmt_cnt] =3D args[fmt_cnt];
+		fmt_cnt++;
+	}
+
+	/* Maximumly we can have MAX_SEQ_PRINTF_VARARGS parameter, just give
+	 * all of them to seq_printf().
+	 */
+	seq_printf(m, fmt, params[0], params[1], params[2], params[3],
+		   params[4], params[5], params[6], params[7], params[8],
+		   params[9], params[10], params[11]);
+
+	return seq_has_overflowed(m) ? -EOVERFLOW : 0;
+}
+
+static int bpf_seq_printf_btf_ids[5];
+static const struct bpf_func_proto bpf_seq_printf_proto =3D {
+	.func		=3D bpf_seq_printf,
+	.gpl_only	=3D true,
+	.ret_type	=3D RET_INTEGER,
+	.arg1_type	=3D ARG_PTR_TO_BTF_ID,
+	.arg2_type	=3D ARG_PTR_TO_MEM,
+	.arg3_type	=3D ARG_CONST_SIZE,
+	.arg4_type      =3D ARG_PTR_TO_MEM_OR_NULL,
+	.arg5_type      =3D ARG_CONST_SIZE_OR_ZERO,
+	.btf_id		=3D bpf_seq_printf_btf_ids,
+};
+
+BPF_CALL_3(bpf_seq_write, struct seq_file *, m, const void *, data, u32,=
 len)
+{
+	return seq_write(m, data, len) ? -EOVERFLOW : 0;
+}
+
+static int bpf_seq_write_btf_ids[5];
+static const struct bpf_func_proto bpf_seq_write_proto =3D {
+	.func		=3D bpf_seq_write,
+	.gpl_only	=3D true,
+	.ret_type	=3D RET_INTEGER,
+	.arg1_type	=3D ARG_PTR_TO_BTF_ID,
+	.arg2_type	=3D ARG_PTR_TO_MEM,
+	.arg3_type	=3D ARG_CONST_SIZE,
+	.btf_id		=3D bpf_seq_write_btf_ids,
+};
+
 static __always_inline int
 get_map_perf_counter(struct bpf_map *map, u64 flags,
 		     u64 *value, u64 *enabled, u64 *running)
@@ -1226,6 +1381,10 @@ tracing_prog_func_proto(enum bpf_func_id func_id, =
const struct bpf_prog *prog)
 	case BPF_FUNC_xdp_output:
 		return &bpf_xdp_output_proto;
 #endif
+	case BPF_FUNC_seq_printf:
+		return &bpf_seq_printf_proto;
+	case BPF_FUNC_seq_write:
+		return &bpf_seq_write_proto;
 	default:
 		return raw_tp_prog_func_proto(func_id, prog);
 	}
diff --git a/scripts/bpf_helpers_doc.py b/scripts/bpf_helpers_doc.py
index f43d193aff3a..ded304c96a05 100755
--- a/scripts/bpf_helpers_doc.py
+++ b/scripts/bpf_helpers_doc.py
@@ -414,6 +414,7 @@ class PrinterHelpers(Printer):
             'struct sk_reuseport_md',
             'struct sockaddr',
             'struct tcphdr',
+            'struct seq_file',
=20
             'struct __sk_buff',
             'struct sk_msg_md',
@@ -450,6 +451,7 @@ class PrinterHelpers(Printer):
             'struct sk_reuseport_md',
             'struct sockaddr',
             'struct tcphdr',
+            'struct seq_file',
     }
     mapped_types =3D {
             'u8': '__u8',
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 576651110d16..f0ab17d8fb73 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3042,6 +3042,33 @@ union bpf_attr {
  * 		See: clock_gettime(CLOCK_BOOTTIME)
  * 	Return
  * 		Current *ktime*.
+ *
+ * int bpf_seq_printf(struct seq_file *m, const char *fmt, u32 fmt_size,=
 const void *data, u32 data_len)
+ * 	Description
+ * 		seq_printf uses seq_file seq_printf() to print out the format strin=
g.
+ * 		The *m* represents the seq_file. The *fmt* and *fmt_size* are for
+ * 		the format string itself. The *data* and *data_len* are format stri=
ng
+ * 		arguments. The *data* are a u64 array and corresponding format stri=
ng
+ * 		values are stored in the array. For strings and pointers where poin=
tees
+ * 		are accessed, only the pointer values are stored in the *data* arra=
y.
+ * 		The *data_len* is the *data* size in term of bytes.
+ * 	Return
+ * 		0 on success, or a negative errno in case of failure.
+ *
+ *		* **-EINVAL**		Invalid arguments, or invalid/unsupported formats.
+ *		* **-E2BIG**		Too many format specifiers.
+ *		* **-ENOMEM**		No enough memory to copy pointees or strings.
+ *		* **-EOVERFLOW**	Overflow happens, the same object will be tried aga=
in.
+ *
+ * int bpf_seq_write(struct seq_file *m, const void *data, u32 len)
+ * 	Description
+ * 		seq_write uses seq_file seq_write() to write the data.
+ * 		The *m* represents the seq_file. The *data* and *len* represent the
+ *		data to write in bytes.
+ * 	Return
+ * 		0 on success, or a negative errno in case of failure.
+ *
+ *		* **-EOVERFLOW**	Overflow happens, the same object will be tried aga=
in.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3169,7 +3196,9 @@ union bpf_attr {
 	FN(get_netns_cookie),		\
 	FN(get_current_ancestor_cgroup_id),	\
 	FN(sk_assign),			\
-	FN(ktime_get_boot_ns),
+	FN(ktime_get_boot_ns),		\
+	FN(seq_printf),			\
+	FN(seq_write),
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
  * function eBPF program intends to call
--=20
2.24.1

