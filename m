Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E09F31BAF01
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 22:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgD0UNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 16:13:00 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51394 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726881AbgD0UM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 16:12:57 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03RK1sOw011056
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:12:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=e6sUKVJE4TRn+OgxVb/za2wlkWSbdOe4ULxFFsDU+0w=;
 b=MjI8PPEaCRGxJHuZp4PRnmiLpKg588K0StKgpbcXUq4lsb8xdRy2Ioj1h+hnrnxG02nj
 NfbZsTAH5kCMeGewF5NjLtLCsy88rAeRvZQuto9QG3dwKfiSu1Sg4ps9LvOzAH64CRzC
 zSHwFMSz9yx26Lrr9TjsvjrbIoXQVP+1sY4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30mk1gdyeq-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:12:55 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 27 Apr 2020 13:12:53 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id B8AC73700871; Mon, 27 Apr 2020 13:12:52 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v1 15/19] tools/libbpf: add bpf_iter support
Date:   Mon, 27 Apr 2020 13:12:52 -0700
Message-ID: <20200427201252.2996037-1-yhs@fb.com>
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
 suspectscore=2 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270161
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Three new libbpf APIs are added to support bpf_iter:
  - bpf_program__attach_iter
    Given a bpf program and additional parameters, which is
    none now, returns a bpf_link.
  - bpf_link__create_iter
    Given a bpf_link, create a bpf_iter and return a fd
    so user can then do read() to get seq_file output data.
  - bpf_iter_create
    syscall level API to create a bpf iterator.

Two macros, BPF_SEQ_PRINTF0 and BPF_SEQ_PRINTF, are also introduced.
These two macros can help bpf program writers with
nicer bpf_seq_printf syntax similar to the kernel one.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/lib/bpf/bpf.c         | 11 +++++++
 tools/lib/bpf/bpf.h         |  2 ++
 tools/lib/bpf/bpf_tracing.h | 23 ++++++++++++++
 tools/lib/bpf/libbpf.c      | 60 +++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h      | 11 +++++++
 tools/lib/bpf/libbpf.map    |  7 +++++
 6 files changed, 114 insertions(+)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 5cc1b0785d18..7ffd6c0ad95f 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -619,6 +619,17 @@ int bpf_link_update(int link_fd, int new_prog_fd,
 	return sys_bpf(BPF_LINK_UPDATE, &attr, sizeof(attr));
 }
=20
+int bpf_iter_create(int link_fd, unsigned int flags)
+{
+	union bpf_attr attr;
+
+	memset(&attr, 0, sizeof(attr));
+	attr.iter_create.link_fd =3D link_fd;
+	attr.iter_create.flags =3D flags;
+
+	return sys_bpf(BPF_ITER_CREATE, &attr, sizeof(attr));
+}
+
 int bpf_prog_query(int target_fd, enum bpf_attach_type type, __u32 query=
_flags,
 		   __u32 *attach_flags, __u32 *prog_ids, __u32 *prog_cnt)
 {
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 46d47afdd887..db9df303090e 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -187,6 +187,8 @@ struct bpf_link_update_opts {
 LIBBPF_API int bpf_link_update(int link_fd, int new_prog_fd,
 			       const struct bpf_link_update_opts *opts);
=20
+LIBBPF_API int bpf_iter_create(int link_fd, unsigned int flags);
+
 struct bpf_prog_test_run_attr {
 	int prog_fd;
 	int repeat;
diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
index f3f3c3fb98cb..4a6dffaa7e57 100644
--- a/tools/lib/bpf/bpf_tracing.h
+++ b/tools/lib/bpf/bpf_tracing.h
@@ -413,4 +413,27 @@ typeof(name(0)) name(struct pt_regs *ctx)				    \
 }									    \
 static __always_inline typeof(name(0)) ____##name(struct pt_regs *ctx, #=
#args)
=20
+/*
+ * BPF_SEQ_PRINTF to wrap bpf_seq_printf to-be-printed values
+ * in a structure. BPF_SEQ_PRINTF0 is a simple wrapper for
+ * bpf_seq_printf().
+ */
+#define BPF_SEQ_PRINTF0(seq, fmt)					\
+	({								\
+		int ret =3D bpf_seq_printf(seq, fmt, sizeof(fmt),		\
+					 (void *)0, 0);			\
+		ret;							\
+	})
+
+#define BPF_SEQ_PRINTF(seq, fmt, args...)				\
+	({								\
+		_Pragma("GCC diagnostic push")				\
+		_Pragma("GCC diagnostic ignored \"-Wint-conversion\"")	\
+		__u64 param[___bpf_narg(args)] =3D { args };		\
+		_Pragma("GCC diagnostic pop")				\
+		int ret =3D bpf_seq_printf(seq, fmt, sizeof(fmt),		\
+					 param, sizeof(param));		\
+		ret;							\
+	})
+
 #endif
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 8e1dc6980fac..ffdc4d8e0cc0 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6366,6 +6366,9 @@ static const struct bpf_sec_def section_defs[] =3D =
{
 		.is_attach_btf =3D true,
 		.expected_attach_type =3D BPF_LSM_MAC,
 		.attach_fn =3D attach_lsm),
+	SEC_DEF("iter/", TRACING,
+		.expected_attach_type =3D BPF_TRACE_ITER,
+		.is_attach_btf =3D true),
 	BPF_PROG_SEC("xdp",			BPF_PROG_TYPE_XDP),
 	BPF_PROG_SEC("perf_event",		BPF_PROG_TYPE_PERF_EVENT),
 	BPF_PROG_SEC("lwt_in",			BPF_PROG_TYPE_LWT_IN),
@@ -6629,6 +6632,7 @@ static int bpf_object__collect_struct_ops_map_reloc=
(struct bpf_object *obj,
=20
 #define BTF_TRACE_PREFIX "btf_trace_"
 #define BTF_LSM_PREFIX "bpf_lsm_"
+#define BTF_ITER_PREFIX "__bpf_iter__"
 #define BTF_MAX_NAME_SIZE 128
=20
 static int find_btf_by_prefix_kind(const struct btf *btf, const char *pr=
efix,
@@ -6659,6 +6663,9 @@ static inline int __find_vmlinux_btf_id(struct btf =
*btf, const char *name,
 	else if (attach_type =3D=3D BPF_LSM_MAC)
 		err =3D find_btf_by_prefix_kind(btf, BTF_LSM_PREFIX, name,
 					      BTF_KIND_FUNC);
+	else if (attach_type =3D=3D BPF_TRACE_ITER)
+		err =3D find_btf_by_prefix_kind(btf, BTF_ITER_PREFIX, name,
+					      BTF_KIND_FUNC);
 	else
 		err =3D btf__find_by_name_kind(btf, name, BTF_KIND_FUNC);
=20
@@ -7617,6 +7624,59 @@ bpf_program__attach_cgroup(struct bpf_program *pro=
g, int cgroup_fd)
 	return link;
 }
=20
+struct bpf_link *
+bpf_program__attach_iter(struct bpf_program *prog,
+			 const struct bpf_iter_attach_opts *opts)
+{
+	enum bpf_attach_type attach_type;
+	char errmsg[STRERR_BUFSIZE];
+	struct bpf_link *link;
+	int prog_fd, link_fd;
+
+	if (!OPTS_VALID(opts, bpf_iter_attach_opts))
+		return ERR_PTR(-EINVAL);
+
+	prog_fd =3D bpf_program__fd(prog);
+	if (prog_fd < 0) {
+		pr_warn("program '%s': can't attach before loaded\n",
+			bpf_program__title(prog, false));
+		return ERR_PTR(-EINVAL);
+	}
+
+	link =3D calloc(1, sizeof(*link));
+	if (!link)
+		return ERR_PTR(-ENOMEM);
+	link->detach =3D &bpf_link__detach_fd;
+
+	attach_type =3D bpf_program__get_expected_attach_type(prog);
+	link_fd =3D bpf_link_create(prog_fd, 0, attach_type, NULL);
+	if (link_fd < 0) {
+		link_fd =3D -errno;
+		free(link);
+		pr_warn("program '%s': failed to attach to iterator: %s\n",
+			bpf_program__title(prog, false),
+			libbpf_strerror_r(link_fd, errmsg, sizeof(errmsg)));
+		return ERR_PTR(link_fd);
+	}
+	link->fd =3D link_fd;
+	return link;
+}
+
+int bpf_link__create_iter(struct bpf_link *link, unsigned int flags)
+{
+	char errmsg[STRERR_BUFSIZE];
+	int iter_fd;
+
+	iter_fd =3D bpf_iter_create(bpf_link__fd(link), flags);
+	if (iter_fd < 0) {
+		iter_fd =3D -errno;
+		pr_warn("failed to create an iterator: %s\n",
+			libbpf_strerror_r(iter_fd, errmsg, sizeof(errmsg)));
+	}
+
+	return iter_fd;
+}
+
 struct bpf_link *bpf_program__attach(struct bpf_program *prog)
 {
 	const struct bpf_sec_def *sec_def;
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index f1dacecb1619..abe5786fcab3 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -258,6 +258,17 @@ struct bpf_map;
=20
 LIBBPF_API struct bpf_link *bpf_map__attach_struct_ops(struct bpf_map *m=
ap);
=20
+struct bpf_iter_attach_opts {
+	size_t sz; /* size of this struct for forward/backward compatibility */
+};
+#define bpf_iter_attach_opts__last_field sz
+
+LIBBPF_API struct bpf_link *
+bpf_program__attach_iter(struct bpf_program *prog,
+			 const struct bpf_iter_attach_opts *opts);
+LIBBPF_API int
+bpf_link__create_iter(struct bpf_link *link, unsigned int flags);
+
 struct bpf_insn;
=20
 /*
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index bb8831605b25..1cea36f9f2e2 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -254,3 +254,10 @@ LIBBPF_0.0.8 {
 		bpf_program__set_lsm;
 		bpf_set_link_xdp_fd_opts;
 } LIBBPF_0.0.7;
+
+LIBBPF_0.0.9 {
+	global:
+		bpf_link__create_iter;
+		bpf_program__attach_iter;
+		bpf_iter_create;
+} LIBBPF_0.0.8;
--=20
2.24.1

