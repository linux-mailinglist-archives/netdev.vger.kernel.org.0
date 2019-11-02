Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B983ED0B6
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 23:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbfKBWAi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 2 Nov 2019 18:00:38 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61388 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727172AbfKBWAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Nov 2019 18:00:38 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA2LwQ34020869
        for <netdev@vger.kernel.org>; Sat, 2 Nov 2019 15:00:37 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w16wk24s6-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 02 Nov 2019 15:00:37 -0700
Received: from 2401:db00:12:909f:face:0:3:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 2 Nov 2019 15:00:35 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 056C0760F5C; Sat,  2 Nov 2019 15:00:34 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <peterz@infradead.org>,
        <rostedt@goodmis.org>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 4/7] libbpf: Add support to attach to fentry/fexit tracing progs
Date:   Sat, 2 Nov 2019 15:00:22 -0700
Message-ID: <20191102220025.2475981-5-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191102220025.2475981-1-ast@kernel.org>
References: <20191102220025.2475981-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-02_13:2019-11-01,2019-11-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 mlxscore=0
 bulkscore=0 clxscore=1034 malwarescore=0 mlxlogscore=912
 priorityscore=1501 impostorscore=0 phishscore=0 suspectscore=3
 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1911020218
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Teach libbpf to recognize tracing programs types and attach them to
fentry/fexit.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/include/uapi/linux/bpf.h |  2 ++
 tools/lib/bpf/libbpf.c         | 55 +++++++++++++++++++++++++++++-----
 tools/lib/bpf/libbpf.h         |  2 ++
 tools/lib/bpf/libbpf.map       |  1 +
 4 files changed, 53 insertions(+), 7 deletions(-)

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
index 7aa2a2a22cef..03e784f36dd9 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3744,7 +3744,7 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
 	return 0;
 }
 
-static int libbpf_attach_btf_id_by_name(const char *name, __u32 *btf_id);
+static int libbpf_attach_btf_id_by_name(const char *name, __u32 *btf_id, bool raw_tp);
 
 static struct bpf_object *
 __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
@@ -3811,7 +3811,9 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 		bpf_program__set_type(prog, prog_type);
 		bpf_program__set_expected_attach_type(prog, attach_type);
 		if (prog_type == BPF_PROG_TYPE_TRACING) {
-			err = libbpf_attach_btf_id_by_name(prog->section_name, &btf_id);
+			err = libbpf_attach_btf_id_by_name(prog->section_name,
+							   &btf_id,
+							   attach_type == BPF_TRACE_RAW_TP);
 			if (err)
 				goto out;
 			prog->attach_btf_id = btf_id;
@@ -4813,6 +4815,10 @@ static const struct {
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
@@ -4930,7 +4936,7 @@ int libbpf_prog_type_by_name(const char *name, enum bpf_prog_type *prog_type,
 }
 
 #define BTF_PREFIX "btf_trace_"
-static int libbpf_attach_btf_id_by_name(const char *name, __u32 *btf_id)
+static int libbpf_attach_btf_id_by_name(const char *name, __u32 *btf_id, bool raw_tp)
 {
 	struct btf *btf = bpf_core_find_kernel_btf();
 	char raw_tp_btf_name[128] = BTF_PREFIX;
@@ -4950,10 +4956,14 @@ static int libbpf_attach_btf_id_by_name(const char *name, __u32 *btf_id)
 			continue;
 		if (strncmp(name, section_names[i].sec, section_names[i].len))
 			continue;
-		/* prepend "btf_trace_" prefix per kernel convention */
-		strncat(dst, name + section_names[i].len,
-			sizeof(raw_tp_btf_name) - sizeof(BTF_PREFIX));
-		ret = btf__find_by_name(btf, raw_tp_btf_name);
+		if (!raw_tp) {
+			ret = btf__find_by_name(btf, name + section_names[i].len);
+		} else {
+			/* prepend "btf_trace_" prefix per kernel convention */
+			strncat(dst, name + section_names[i].len,
+				sizeof(raw_tp_btf_name) - sizeof(BTF_PREFIX));
+			ret = btf__find_by_name(btf, raw_tp_btf_name);
+		}
 		if (ret <= 0) {
 			pr_warn("%s is not found in vmlinux BTF\n", dst);
 			goto out;
@@ -5594,6 +5604,37 @@ struct bpf_link *bpf_program__attach_raw_tracepoint(struct bpf_program *prog,
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
index 6ddc0419337b..0f53b0e0e135 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -248,6 +248,8 @@ LIBBPF_API struct bpf_link *
 bpf_program__attach_raw_tracepoint(struct bpf_program *prog,
 				   const char *tp_name);
 
+LIBBPF_API struct bpf_link *
+bpf_program__attach_trace(struct bpf_program *prog);
 struct bpf_insn;
 
 /*
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 86173cbb159d..f7b4e062d704 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -198,6 +198,7 @@ LIBBPF_0.0.6 {
 		bpf_map__set_pin_path;
 		bpf_object__open_file;
 		bpf_object__open_mem;
+		bpf_program__attach_trace;
 		bpf_program__get_expected_attach_type;
 		bpf_program__get_type;
 		bpf_program__is_tracing;
-- 
2.23.0

