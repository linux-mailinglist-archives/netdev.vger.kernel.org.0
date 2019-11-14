Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F16ECFCE4D
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfKNS5u convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 14 Nov 2019 13:57:50 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8698 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726786AbfKNS5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:57:36 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xAEIgs8a031753
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:57:35 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2w8jxpqkm4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:57:35 -0800
Received: from 2401:db00:2120:80d4:face:0:39:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 14 Nov 2019 10:57:34 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 35B7E76071B; Thu, 14 Nov 2019 10:57:33 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 06/20] libbpf: Add support to attach to fentry/fexit tracing progs
Date:   Thu, 14 Nov 2019 10:57:06 -0800
Message-ID: <20191114185720.1641606-7-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191114185720.1641606-1-ast@kernel.org>
References: <20191114185720.1641606-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-14_05:2019-11-14,2019-11-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 suspectscore=3 impostorscore=0 adultscore=0 mlxlogscore=897 phishscore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911140157
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Teach libbpf to recognize tracing programs types and attach them to
fentry/fexit.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Song Liu <songliubraving@fb.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/include/uapi/linux/bpf.h |  2 +
 tools/lib/bpf/libbpf.c         | 99 +++++++++++++++++++++++++---------
 tools/lib/bpf/libbpf.h         |  4 ++
 tools/lib/bpf/libbpf.map       |  2 +
 4 files changed, 82 insertions(+), 25 deletions(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index df6809a76404..69c200e6e696 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -201,6 +201,8 @@ enum bpf_attach_type {
 	BPF_CGROUP_GETSOCKOPT,
 	BPF_CGROUP_SETSOCKOPT,
 	BPF_TRACE_RAW_TP,
+	BPF_TRACE_FENTRY,
+	BPF_TRACE_FEXIT,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 96ef18cfeffb..98ee033e021f 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3856,7 +3856,8 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
 	return 0;
 }
 
-static int libbpf_attach_btf_id_by_name(const char *name, __u32 *btf_id);
+static int libbpf_attach_btf_id_by_name(const char *name,
+					enum bpf_attach_type attach_type);
 
 static struct bpf_object *
 __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
@@ -3910,7 +3911,6 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 	bpf_object__for_each_program(prog, obj) {
 		enum bpf_prog_type prog_type;
 		enum bpf_attach_type attach_type;
-		__u32 btf_id;
 
 		err = libbpf_prog_type_by_name(prog->section_name, &prog_type,
 					       &attach_type);
@@ -3923,10 +3923,11 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 		bpf_program__set_type(prog, prog_type);
 		bpf_program__set_expected_attach_type(prog, attach_type);
 		if (prog_type == BPF_PROG_TYPE_TRACING) {
-			err = libbpf_attach_btf_id_by_name(prog->section_name, &btf_id);
-			if (err)
+			err = libbpf_attach_btf_id_by_name(prog->section_name,
+							   attach_type);
+			if (err <= 0)
 				goto out;
-			prog->attach_btf_id = btf_id;
+			prog->attach_btf_id = err;
 		}
 	}
 
@@ -4935,6 +4936,10 @@ static const struct {
 	BPF_PROG_SEC("raw_tp/",			BPF_PROG_TYPE_RAW_TRACEPOINT),
 	BPF_PROG_BTF("tp_btf/",			BPF_PROG_TYPE_TRACING,
 						BPF_TRACE_RAW_TP),
+	BPF_PROG_BTF("fentry/",			BPF_PROG_TYPE_TRACING,
+						BPF_TRACE_FENTRY),
+	BPF_PROG_BTF("fexit/",			BPF_PROG_TYPE_TRACING,
+						BPF_TRACE_FEXIT),
 	BPF_PROG_SEC("xdp",			BPF_PROG_TYPE_XDP),
 	BPF_PROG_SEC("perf_event",		BPF_PROG_TYPE_PERF_EVENT),
 	BPF_PROG_SEC("lwt_in",			BPF_PROG_TYPE_LWT_IN),
@@ -5052,43 +5057,56 @@ int libbpf_prog_type_by_name(const char *name, enum bpf_prog_type *prog_type,
 }
 
 #define BTF_PREFIX "btf_trace_"
-static int libbpf_attach_btf_id_by_name(const char *name, __u32 *btf_id)
+int libbpf_find_vmlinux_btf_id(const char *name,
+			       enum bpf_attach_type attach_type)
 {
 	struct btf *btf = bpf_core_find_kernel_btf();
-	char raw_tp_btf_name[128] = BTF_PREFIX;
-	char *dst = raw_tp_btf_name + sizeof(BTF_PREFIX) - 1;
-	int ret, i, err = -EINVAL;
+	char raw_tp_btf[128] = BTF_PREFIX;
+	char *dst = raw_tp_btf + sizeof(BTF_PREFIX) - 1;
+	const char *btf_name;
+	int err = -EINVAL;
+	u32 kind;
 
 	if (IS_ERR(btf)) {
 		pr_warn("vmlinux BTF is not found\n");
 		return -EINVAL;
 	}
 
+	if (attach_type == BPF_TRACE_RAW_TP) {
+		/* prepend "btf_trace_" prefix per kernel convention */
+		strncat(dst, name, sizeof(raw_tp_btf) - sizeof(BTF_PREFIX));
+		btf_name = raw_tp_btf;
+		kind = BTF_KIND_TYPEDEF;
+	} else {
+		btf_name = name;
+		kind = BTF_KIND_FUNC;
+	}
+	err = btf__find_by_name_kind(btf, btf_name, kind);
+	btf__free(btf);
+	return err;
+}
+
+static int libbpf_attach_btf_id_by_name(const char *name,
+					enum bpf_attach_type attach_type)
+{
+	int i, err;
+
 	if (!name)
-		goto out;
+		return -EINVAL;
 
 	for (i = 0; i < ARRAY_SIZE(section_names); i++) {
 		if (!section_names[i].is_attach_btf)
 			continue;
 		if (strncmp(name, section_names[i].sec, section_names[i].len))
 			continue;
-		/* prepend "btf_trace_" prefix per kernel convention */
-		strncat(dst, name + section_names[i].len,
-			sizeof(raw_tp_btf_name) - sizeof(BTF_PREFIX));
-		ret = btf__find_by_name(btf, raw_tp_btf_name);
-		if (ret <= 0) {
-			pr_warn("%s is not found in vmlinux BTF\n", dst);
-			goto out;
-		}
-		*btf_id = ret;
-		err = 0;
-		goto out;
+		err = libbpf_find_vmlinux_btf_id(name + section_names[i].len,
+						 attach_type);
+		if (err <= 0)
+			pr_warn("%s is not found in vmlinux BTF\n", name);
+		return err;
 	}
 	pr_warn("failed to identify btf_id based on ELF section name '%s'\n", name);
-	err = -ESRCH;
-out:
-	btf__free(btf);
-	return err;
+	return -ESRCH;
 }
 
 int libbpf_attach_type_by_name(const char *name,
@@ -5716,6 +5734,37 @@ struct bpf_link *bpf_program__attach_raw_tracepoint(struct bpf_program *prog,
 	return (struct bpf_link *)link;
 }
 
+struct bpf_link *bpf_program__attach_trace(struct bpf_program *prog)
+{
+	char errmsg[STRERR_BUFSIZE];
+	struct bpf_link_fd *link;
+	int prog_fd, pfd;
+
+	prog_fd = bpf_program__fd(prog);
+	if (prog_fd < 0) {
+		pr_warn("program '%s': can't attach before loaded\n",
+			bpf_program__title(prog, false));
+		return ERR_PTR(-EINVAL);
+	}
+
+	link = malloc(sizeof(*link));
+	if (!link)
+		return ERR_PTR(-ENOMEM);
+	link->link.destroy = &bpf_link__destroy_fd;
+
+	pfd = bpf_raw_tracepoint_open(NULL, prog_fd);
+	if (pfd < 0) {
+		pfd = -errno;
+		free(link);
+		pr_warn("program '%s': failed to attach to trace: %s\n",
+			bpf_program__title(prog, false),
+			libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
+		return ERR_PTR(pfd);
+	}
+	link->fd = pfd;
+	return (struct bpf_link *)link;
+}
+
 enum bpf_perf_event_ret
 bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
 			   void **copy_mem, size_t *copy_size,
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 5aa27caad6c2..fbff419f6daf 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -188,6 +188,8 @@ libbpf_prog_type_by_name(const char *name, enum bpf_prog_type *prog_type,
 			 enum bpf_attach_type *expected_attach_type);
 LIBBPF_API int libbpf_attach_type_by_name(const char *name,
 					  enum bpf_attach_type *attach_type);
+LIBBPF_API int libbpf_find_vmlinux_btf_id(const char *name,
+					  enum bpf_attach_type attach_type);
 
 /* Accessors of bpf_program */
 struct bpf_program;
@@ -251,6 +253,8 @@ LIBBPF_API struct bpf_link *
 bpf_program__attach_raw_tracepoint(struct bpf_program *prog,
 				   const char *tp_name);
 
+LIBBPF_API struct bpf_link *
+bpf_program__attach_trace(struct bpf_program *prog);
 struct bpf_insn;
 
 /*
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 420e69bfe699..8ddc2c40e482 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -199,10 +199,12 @@ LIBBPF_0.0.6 {
 		bpf_map__set_pin_path;
 		bpf_object__open_file;
 		bpf_object__open_mem;
+		bpf_program__attach_trace;
 		bpf_program__get_expected_attach_type;
 		bpf_program__get_type;
 		bpf_program__is_tracing;
 		bpf_program__set_tracing;
 		bpf_program__size;
 		btf__find_by_name_kind;
+		libbpf_find_vmlinux_btf_id;
 } LIBBPF_0.0.5;
-- 
2.23.0

