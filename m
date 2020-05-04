Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A261C32CB
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 08:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727971AbgEDG0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 02:26:14 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44240 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727903AbgEDG0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 02:26:11 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04469xLH008282
        for <netdev@vger.kernel.org>; Sun, 3 May 2020 23:26:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=9zx7N12kgTHaTJLL75ll3b4VKwPbk6Mc1DA2sZTH7bM=;
 b=RZ+X3xYfdTJRWxVRzv/2m+nSUdvxNwKp9wk4Qw9HTHwxrZXLo3XzNxUvwWCOrzqK6Tsy
 Xt8wDWe94jw0JdWpW+ydLd6lMwTS9Jn/8QAXHvB9D9WiYleQbVjls0ehSEmbYc3n+imm
 FbfbQGLczpBGPiN7Kaypqt0t0cK+8V8gKc8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30s6kpen0b-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 03 May 2020 23:26:10 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sun, 3 May 2020 23:26:08 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id DE8A43702037; Sun,  3 May 2020 23:26:05 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v2 16/20] tools/libbpf: add bpf_iter support
Date:   Sun, 3 May 2020 23:26:05 -0700
Message-ID: <20200504062605.2048882-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200504062547.2047304-1-yhs@fb.com>
References: <20200504062547.2047304-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-04_02:2020-05-01,2020-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 suspectscore=2 adultscore=0 malwarescore=0 impostorscore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040054
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

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/lib/bpf/bpf.c         | 11 +++++++++
 tools/lib/bpf/bpf.h         |  2 ++
 tools/lib/bpf/bpf_tracing.h | 16 +++++++++++++
 tools/lib/bpf/libbpf.c      | 45 +++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h      |  9 ++++++++
 tools/lib/bpf/libbpf.map    |  2 ++
 6 files changed, 85 insertions(+)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 43322f0d6c7f..1756ae47ddf2 100644
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
index 1901b2777854..d2748b9da86f 100644
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
index 977add1b73e2..93355a257405 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6629,6 +6629,9 @@ static const struct bpf_sec_def section_defs[] =3D =
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
@@ -6891,6 +6894,7 @@ static int bpf_object__collect_st_ops_relos(struct =
bpf_object *obj,
=20
 #define BTF_TRACE_PREFIX "btf_trace_"
 #define BTF_LSM_PREFIX "bpf_lsm_"
+#define BTF_ITER_PREFIX "__bpf_iter__"
 #define BTF_MAX_NAME_SIZE 128
=20
 static int find_btf_by_prefix_kind(const struct btf *btf, const char *pr=
efix,
@@ -6921,6 +6925,9 @@ static inline int __find_vmlinux_btf_id(struct btf =
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
@@ -7882,6 +7889,44 @@ bpf_program__attach_cgroup(struct bpf_program *pro=
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
+	attach_type =3D BPF_TRACE_ITER;
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

