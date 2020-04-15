Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6431AB1A5
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 21:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411872AbgDOT2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 15:28:47 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53208 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2411868AbgDOT2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 15:28:33 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03FJSMjl024691
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 12:28:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=AL0NkZx+vrkOqW7HZHQTqiLzJW8FZ7I3xYBQLJiHFHs=;
 b=R9Uj/3qyqdn730e40FNpNu4BosWIFi6ej74+EKco/LPQDj68A0SSORZpzxK0UJ2He33X
 DN6LCUWPmz3ZgzshVMGzIg3J5xtCQufFJOYPdzUjB8VjR0drqVd8slnrX0lQpOCLByvz
 e43My9Tj6pswKK2LIAEFl6UlLTDzDXYsbms= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30dn7gqkqw-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 12:28:30 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 15 Apr 2020 12:28:00 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id E0FEF3700AF5; Wed, 15 Apr 2020 12:27:51 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next v2 10/17] bpf: add bpf_seq_printf and bpf_seq_write helpers
Date:   Wed, 15 Apr 2020 12:27:51 -0700
Message-ID: <20200415192751.4083563-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200415192740.4082659-1-yhs@fb.com>
References: <20200415192740.4082659-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-15_07:2020-04-14,2020-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 bulkscore=0 phishscore=0 adultscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004150144
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

For bpf_seq_printf, return value 1 specifically indicates
a write failure due to overflow in order to differentiate
the failure from format strings.

For seq_file show, since the same object may be called
twice, some bpf_prog might be sensitive to this. With return
value indicating overflow happens the bpf program can
react differently.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/uapi/linux/bpf.h       |  18 +++-
 kernel/trace/bpf_trace.c       | 172 +++++++++++++++++++++++++++++++++
 scripts/bpf_helpers_doc.py     |   2 +
 tools/include/uapi/linux/bpf.h |  18 +++-
 4 files changed, 208 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index f92b919c723e..75f3657d526c 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3029,6 +3029,20 @@ union bpf_attr {
  *		* **-EOPNOTSUPP**	Unsupported operation, for example a
  *					call from outside of TC ingress.
  *		* **-ESOCKTNOSUPPORT**	Socket type not supported (reuseport).
+ *
+ * int bpf_seq_printf(struct seq_file *m, const char *fmt, u32 fmt_size,=
 ...)
+ * 	Description
+ * 		seq_printf
+ * 	Return
+ * 		0 if successful, or
+ * 		1 if failure due to buffer overflow, or
+ * 		a negative value for format string related failures.
+ *
+ * int bpf_seq_write(struct seq_file *m, const void *data, u32 len)
+ * 	Description
+ * 		seq_write
+ * 	Return
+ * 		0 if successful, non-zero otherwise.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3155,7 +3169,9 @@ union bpf_attr {
 	FN(xdp_output),			\
 	FN(get_netns_cookie),		\
 	FN(get_current_ancestor_cgroup_id),	\
-	FN(sk_assign),
+	FN(sk_assign),			\
+	FN(seq_printf),			\
+	FN(seq_write),
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
  * function eBPF program intends to call
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index ca1796747a77..e7d6ba7c9c51 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -457,6 +457,174 @@ const struct bpf_func_proto *bpf_get_trace_printk_p=
roto(void)
 	return &bpf_trace_printk_proto;
 }
=20
+BPF_CALL_5(bpf_seq_printf, struct seq_file *, m, char *, fmt, u32, fmt_s=
ize, u64, arg1,
+	   u64, arg2)
+{
+	bool buf_used =3D false;
+	int i, copy_size;
+	int mod[2] =3D {};
+	int fmt_cnt =3D 0;
+	u64 unsafe_addr;
+	char buf[64];
+
+	/*
+	 * bpf_check()->check_func_arg()->check_stack_boundary()
+	 * guarantees that fmt points to bpf program stack,
+	 * fmt_size bytes of it were initialized and fmt_size > 0
+	 */
+	if (fmt[--fmt_size] !=3D 0)
+		return -EINVAL;
+
+	/* check format string for allowed specifiers */
+	for (i =3D 0; i < fmt_size; i++) {
+		if ((!isprint(fmt[i]) && !isspace(fmt[i])) || !isascii(fmt[i]))
+			return -EINVAL;
+
+		if (fmt[i] !=3D '%')
+			continue;
+
+		if (fmt_cnt >=3D 2)
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
+		if (fmt[i] =3D=3D 'l') {
+			mod[fmt_cnt]++;
+			i++;
+		} else if (fmt[i] =3D=3D 's') {
+			mod[fmt_cnt]++;
+			fmt_cnt++;
+			/* disallow any further format extensions */
+			if (fmt[i + 1] !=3D 0 &&
+			    !isspace(fmt[i + 1]) &&
+			    !ispunct(fmt[i + 1]))
+				return -EINVAL;
+
+			if (buf_used)
+				/* allow only one '%s'/'%p' per fmt string */
+				return -EINVAL;
+			buf_used =3D true;
+
+			if (fmt_cnt =3D=3D 1) {
+				unsafe_addr =3D arg1;
+				arg1 =3D (long) buf;
+			} else {
+				unsafe_addr =3D arg2;
+				arg2 =3D (long) buf;
+			}
+			buf[0] =3D 0;
+			strncpy_from_unsafe(buf,
+					    (void *) (long) unsafe_addr,
+					    sizeof(buf));
+			continue;
+		} else if (fmt[i] =3D=3D 'p') {
+			mod[fmt_cnt]++;
+			fmt_cnt++;
+			if (fmt[i + 1] =3D=3D 0 ||
+			    fmt[i + 1] =3D=3D 'K' ||
+			    fmt[i + 1] =3D=3D 'x') {
+				/* just kernel pointers */
+				continue;
+			}
+
+			if (buf_used)
+				return -EINVAL;
+			buf_used =3D true;
+
+			/* only support "%pI4", "%pi4", "%pI6" and "pi6". */
+			if (fmt[i + 1] !=3D 'i' && fmt[i + 1] !=3D 'I')
+				return -EINVAL;
+			if (fmt[i + 2] !=3D '4' && fmt[i + 2] !=3D '6')
+				return -EINVAL;
+
+			copy_size =3D (fmt[i + 2] =3D=3D '4') ? 4 : 16;
+
+			if (fmt_cnt =3D=3D 1) {
+				unsafe_addr =3D arg1;
+				arg1 =3D (long) buf;
+			} else {
+				unsafe_addr =3D arg2;
+				arg2 =3D (long) buf;
+			}
+			probe_kernel_read(buf, (void *) (long) unsafe_addr, copy_size);
+
+			i +=3D 2;
+			continue;
+		}
+
+		if (fmt[i] =3D=3D 'l') {
+			mod[fmt_cnt]++;
+			i++;
+		}
+
+		if (fmt[i] !=3D 'i' && fmt[i] !=3D 'd' &&
+		    fmt[i] !=3D 'u' && fmt[i] !=3D 'x')
+			return -EINVAL;
+		fmt_cnt++;
+	}
+
+/* Horrid workaround for getting va_list handling working with different
+ * argument type combinations generically for 32 and 64 bit archs.
+ */
+#define __BPF_SP_EMIT()	__BPF_ARG2_SP()
+#define __BPF_SP(...)							\
+	seq_printf(m, fmt, ##__VA_ARGS__)
+
+#define __BPF_ARG1_SP(...)						\
+	((mod[0] =3D=3D 2 || (mod[0] =3D=3D 1 && __BITS_PER_LONG =3D=3D 64))	\
+	  ? __BPF_SP(arg1, ##__VA_ARGS__)				\
+	  : ((mod[0] =3D=3D 1 || (mod[0] =3D=3D 0 && __BITS_PER_LONG =3D=3D 32)=
)	\
+	      ? __BPF_SP((long)arg1, ##__VA_ARGS__)			\
+	      : __BPF_SP((u32)arg1, ##__VA_ARGS__)))
+
+#define __BPF_ARG2_SP(...)						\
+	((mod[1] =3D=3D 2 || (mod[1] =3D=3D 1 && __BITS_PER_LONG =3D=3D 64))	\
+	  ? __BPF_ARG1_SP(arg2, ##__VA_ARGS__)				\
+	  : ((mod[1] =3D=3D 1 || (mod[1] =3D=3D 0 && __BITS_PER_LONG =3D=3D 32)=
)	\
+	      ? __BPF_ARG1_SP((long)arg2, ##__VA_ARGS__)		\
+	      : __BPF_ARG1_SP((u32)arg2, ##__VA_ARGS__)))
+
+	__BPF_SP_EMIT();
+	return seq_has_overflowed(m);
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
+	.btf_id		=3D bpf_seq_printf_btf_ids,
+};
+
+BPF_CALL_3(bpf_seq_write, struct seq_file *, m, const char *, data, u32,=
 len)
+{
+	return seq_write(m, data, len);
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
@@ -1224,6 +1392,10 @@ tracing_prog_func_proto(enum bpf_func_id func_id, =
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
index f92b919c723e..75f3657d526c 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3029,6 +3029,20 @@ union bpf_attr {
  *		* **-EOPNOTSUPP**	Unsupported operation, for example a
  *					call from outside of TC ingress.
  *		* **-ESOCKTNOSUPPORT**	Socket type not supported (reuseport).
+ *
+ * int bpf_seq_printf(struct seq_file *m, const char *fmt, u32 fmt_size,=
 ...)
+ * 	Description
+ * 		seq_printf
+ * 	Return
+ * 		0 if successful, or
+ * 		1 if failure due to buffer overflow, or
+ * 		a negative value for format string related failures.
+ *
+ * int bpf_seq_write(struct seq_file *m, const void *data, u32 len)
+ * 	Description
+ * 		seq_write
+ * 	Return
+ * 		0 if successful, non-zero otherwise.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3155,7 +3169,9 @@ union bpf_attr {
 	FN(xdp_output),			\
 	FN(get_netns_cookie),		\
 	FN(get_current_ancestor_cgroup_id),	\
-	FN(sk_assign),
+	FN(sk_assign),			\
+	FN(seq_printf),			\
+	FN(seq_write),
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
  * function eBPF program intends to call
--=20
2.24.1

