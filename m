Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5D301CC371
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 19:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728756AbgEIR7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 13:59:24 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31426 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728692AbgEIR7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 13:59:21 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 049HsgNv032361
        for <netdev@vger.kernel.org>; Sat, 9 May 2020 10:59:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=g3yVwnpdBkdi06Ujfbn6TFjA41ICMylF5j/zru4soTA=;
 b=OroGDhZfduH4zTGE6oQuggvilFtf8s/AUTziLJCmCY/HEFExTY9xy2xr79ZuADbP1ySw
 x04PMQAeyHht0TIhrsLPWJ4Dv0qch7waAP/V9XmpNIcvL0dsNY1HZYeH1YzcIH5YDUPQ
 RQSZsDY3XozJrhoVhSLqaIqWIOvroGpR9Ss= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30wt1ksdsv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 09 May 2020 10:59:19 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sat, 9 May 2020 10:59:19 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id CC96037008E2; Sat,  9 May 2020 10:59:17 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v4 16/21] tools/libbpf: add bpf_iter support
Date:   Sat, 9 May 2020 10:59:17 -0700
Message-ID: <20200509175917.2476936-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200509175859.2474608-1-yhs@fb.com>
References: <20200509175859.2474608-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-09_06:2020-05-08,2020-05-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 suspectscore=2 phishscore=0 impostorscore=0 adultscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005090155
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two new libbpf APIs are added to support bpf_iter:
  - bpf_program__attach_iter
    Given a bpf program and additional parameters, which is
    none now, returns a bpf_link.
  - bpf_iter_create
    syscall level API to create a bpf iterator.

The macro BPF_SEQ_PRINTF are also introduced. The format
looks like:
  BPF_SEQ_PRINTF(seq, "task id %d\n", pid);

This macro can help bpf program writers with
nicer bpf_seq_printf syntax similar to the kernel one.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/lib/bpf/bpf.c         | 10 +++++++
 tools/lib/bpf/bpf.h         |  2 ++
 tools/lib/bpf/bpf_tracing.h | 16 ++++++++++++
 tools/lib/bpf/libbpf.c      | 52 +++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h      |  9 +++++++
 tools/lib/bpf/libbpf.map    |  2 ++
 6 files changed, 91 insertions(+)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 43322f0d6c7f..a7329b671c41 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -619,6 +619,16 @@ int bpf_link_update(int link_fd, int new_prog_fd,
 	return sys_bpf(BPF_LINK_UPDATE, &attr, sizeof(attr));
 }
=20
+int bpf_iter_create(int link_fd)
+{
+	union bpf_attr attr;
+
+	memset(&attr, 0, sizeof(attr));
+	attr.iter_create.link_fd =3D link_fd;
+
+	return sys_bpf(BPF_ITER_CREATE, &attr, sizeof(attr));
+}
+
 int bpf_prog_query(int target_fd, enum bpf_attach_type type, __u32 query=
_flags,
 		   __u32 *attach_flags, __u32 *prog_ids, __u32 *prog_cnt)
 {
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 1901b2777854..1b6015b21ba8 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -187,6 +187,8 @@ struct bpf_link_update_opts {
 LIBBPF_API int bpf_link_update(int link_fd, int new_prog_fd,
 			       const struct bpf_link_update_opts *opts);
=20
+LIBBPF_API int bpf_iter_create(int link_fd);
+
 struct bpf_prog_test_run_attr {
 	int prog_fd;
 	int repeat;
diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
index f3f3c3fb98cb..cf97d07692b4 100644
--- a/tools/lib/bpf/bpf_tracing.h
+++ b/tools/lib/bpf/bpf_tracing.h
@@ -413,4 +413,20 @@ typeof(name(0)) name(struct pt_regs *ctx)				    \
 }									    \
 static __always_inline typeof(name(0)) ____##name(struct pt_regs *ctx, #=
#args)
=20
+/*
+ * BPF_SEQ_PRINTF to wrap bpf_seq_printf to-be-printed values
+ * in a structure.
+ */
+#define BPF_SEQ_PRINTF(seq, fmt, args...)				    \
+	({								    \
+		_Pragma("GCC diagnostic push")				    \
+		_Pragma("GCC diagnostic ignored \"-Wint-conversion\"")	    \
+		static const char ___fmt[] =3D fmt;			    \
+		unsigned long long ___param[] =3D { args };		    \
+		_Pragma("GCC diagnostic pop")				    \
+		int ___ret =3D bpf_seq_printf(seq, ___fmt, sizeof(___fmt),    \
+					    ___param, sizeof(___param));    \
+		___ret;							    \
+	})
+
 #endif
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 977add1b73e2..6c2f46908f4d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6586,6 +6586,8 @@ static struct bpf_link *attach_trace(const struct b=
pf_sec_def *sec,
 				     struct bpf_program *prog);
 static struct bpf_link *attach_lsm(const struct bpf_sec_def *sec,
 				   struct bpf_program *prog);
+static struct bpf_link *attach_iter(const struct bpf_sec_def *sec,
+				    struct bpf_program *prog);
=20
 static const struct bpf_sec_def section_defs[] =3D {
 	BPF_PROG_SEC("socket",			BPF_PROG_TYPE_SOCKET_FILTER),
@@ -6629,6 +6631,10 @@ static const struct bpf_sec_def section_defs[] =3D=
 {
 		.is_attach_btf =3D true,
 		.expected_attach_type =3D BPF_LSM_MAC,
 		.attach_fn =3D attach_lsm),
+	SEC_DEF("iter/", TRACING,
+		.expected_attach_type =3D BPF_TRACE_ITER,
+		.is_attach_btf =3D true,
+		.attach_fn =3D attach_iter),
 	BPF_PROG_SEC("xdp",			BPF_PROG_TYPE_XDP),
 	BPF_PROG_SEC("perf_event",		BPF_PROG_TYPE_PERF_EVENT),
 	BPF_PROG_SEC("lwt_in",			BPF_PROG_TYPE_LWT_IN),
@@ -6891,6 +6897,7 @@ static int bpf_object__collect_st_ops_relos(struct =
bpf_object *obj,
=20
 #define BTF_TRACE_PREFIX "btf_trace_"
 #define BTF_LSM_PREFIX "bpf_lsm_"
+#define BTF_ITER_PREFIX "__bpf_iter__"
 #define BTF_MAX_NAME_SIZE 128
=20
 static int find_btf_by_prefix_kind(const struct btf *btf, const char *pr=
efix,
@@ -6921,6 +6928,9 @@ static inline int __find_vmlinux_btf_id(struct btf =
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
@@ -7848,6 +7858,12 @@ static struct bpf_link *attach_lsm(const struct bp=
f_sec_def *sec,
 	return bpf_program__attach_lsm(prog);
 }
=20
+static struct bpf_link *attach_iter(const struct bpf_sec_def *sec,
+				    struct bpf_program *prog)
+{
+	return bpf_program__attach_iter(prog, NULL);
+}
+
 struct bpf_link *
 bpf_program__attach_cgroup(struct bpf_program *prog, int cgroup_fd)
 {
@@ -7882,6 +7898,42 @@ bpf_program__attach_cgroup(struct bpf_program *pro=
g, int cgroup_fd)
 	return link;
 }
=20
+struct bpf_link *
+bpf_program__attach_iter(struct bpf_program *prog,
+			 const struct bpf_iter_attach_opts *opts)
+{
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
+	link_fd =3D bpf_link_create(prog_fd, 0, BPF_TRACE_ITER, NULL);
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
 struct bpf_link *bpf_program__attach(struct bpf_program *prog)
 {
 	const struct bpf_sec_def *sec_def;
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index f1dacecb1619..8ea69558f0a8 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -258,6 +258,15 @@ struct bpf_map;
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
+
 struct bpf_insn;
=20
 /*
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index e03bd4db827e..0133d469d30b 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -258,6 +258,8 @@ LIBBPF_0.0.8 {
 LIBBPF_0.0.9 {
 	global:
 		bpf_enable_stats;
+		bpf_iter_create;
 		bpf_link_get_fd_by_id;
 		bpf_link_get_next_id;
+		bpf_program__attach_iter;
 } LIBBPF_0.0.8;
--=20
2.24.1

