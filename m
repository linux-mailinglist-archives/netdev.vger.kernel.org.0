Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9572AF2749
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 06:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbfKGFrG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 7 Nov 2019 00:47:06 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41854 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725875AbfKGFrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 00:47:06 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA75hTWb000579
        for <netdev@vger.kernel.org>; Wed, 6 Nov 2019 21:47:05 -0800
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41w6ug99-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 21:47:05 -0800
Received: from 2401:db00:2120:80e1:face:0:29:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 6 Nov 2019 21:46:53 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 6B809760BC0; Wed,  6 Nov 2019 21:46:52 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 04/17] libbpf: Add support to attach to fentry/fexit tracing progs
Date:   Wed, 6 Nov 2019 21:46:31 -0800
Message-ID: <20191107054644.1285697-5-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191107054644.1285697-1-ast@kernel.org>
References: <20191107054644.1285697-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-06_09:2019-11-06,2019-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1034
 phishscore=0 mlxscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 adultscore=0 priorityscore=1501 suspectscore=3 spamscore=0 mlxlogscore=828
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070059
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
 tools/lib/bpf/libbpf.c         | 61 +++++++++++++++++++++++++++++-----
 tools/lib/bpf/libbpf.h         |  5 +++
 tools/lib/bpf/libbpf.map       |  2 ++
 4 files changed, 61 insertions(+), 9 deletions(-)

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
index be4af95d5a2c..4baaa14b4ca0 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3859,8 +3859,6 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
 	return 0;
 }
 
-static int libbpf_attach_btf_id_by_name(const char *name, __u32 *btf_id);
-
 static struct bpf_object *
 __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 		   struct bpf_object_open_opts *opts)
@@ -3926,7 +3924,9 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 		bpf_program__set_type(prog, prog_type);
 		bpf_program__set_expected_attach_type(prog, attach_type);
 		if (prog_type == BPF_PROG_TYPE_TRACING) {
-			err = libbpf_attach_btf_id_by_name(prog->section_name, &btf_id);
+			err = libbpf_attach_btf_id_by_name(prog->section_name,
+							   attach_type,
+							   &btf_id);
 			if (err)
 				goto out;
 			prog->attach_btf_id = btf_id;
@@ -4928,6 +4928,10 @@ static const struct {
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
@@ -5045,12 +5049,15 @@ int libbpf_prog_type_by_name(const char *name, enum bpf_prog_type *prog_type,
 }
 
 #define BTF_PREFIX "btf_trace_"
-static int libbpf_attach_btf_id_by_name(const char *name, __u32 *btf_id)
+int libbpf_attach_btf_id_by_name(const char *name,
+				 enum bpf_attach_type attach_type,
+				 __u32 *btf_id)
 {
 	struct btf *btf = bpf_core_find_kernel_btf();
 	char raw_tp_btf_name[128] = BTF_PREFIX;
 	char *dst = raw_tp_btf_name + sizeof(BTF_PREFIX) - 1;
 	int ret, i, err = -EINVAL;
+	const char *btf_name;
 
 	if (IS_ERR(btf)) {
 		pr_warn("vmlinux BTF is not found\n");
@@ -5065,12 +5072,17 @@ static int libbpf_attach_btf_id_by_name(const char *name, __u32 *btf_id)
 			continue;
 		if (strncmp(name, section_names[i].sec, section_names[i].len))
 			continue;
-		/* prepend "btf_trace_" prefix per kernel convention */
-		strncat(dst, name + section_names[i].len,
-			sizeof(raw_tp_btf_name) - sizeof(BTF_PREFIX));
-		ret = btf__find_by_name(btf, raw_tp_btf_name);
+		if (attach_type == BPF_TRACE_RAW_TP) {
+			/* prepend "btf_trace_" prefix per kernel convention */
+			strncat(dst, name + section_names[i].len,
+				sizeof(raw_tp_btf_name) - sizeof(BTF_PREFIX));
+			btf_name = raw_tp_btf_name;
+		} else {
+			btf_name = name + section_names[i].len;
+		}
+		ret = btf__find_by_name(btf, btf_name);
 		if (ret <= 0) {
-			pr_warn("%s is not found in vmlinux BTF\n", dst);
+			pr_warn("%s is not found in vmlinux BTF\n", btf_name);
 			goto out;
 		}
 		*btf_id = ret;
@@ -5709,6 +5721,37 @@ struct bpf_link *bpf_program__attach_raw_tracepoint(struct bpf_program *prog,
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
index 6ddc0419337b..9576aeadc421 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -188,6 +188,9 @@ libbpf_prog_type_by_name(const char *name, enum bpf_prog_type *prog_type,
 			 enum bpf_attach_type *expected_attach_type);
 LIBBPF_API int libbpf_attach_type_by_name(const char *name,
 					  enum bpf_attach_type *attach_type);
+LIBBPF_API int libbpf_attach_btf_id_by_name(const char *name,
+					    enum bpf_attach_type attach_type,
+					    __u32 *btf_id);
 
 /* Accessors of bpf_program */
 struct bpf_program;
@@ -248,6 +251,8 @@ LIBBPF_API struct bpf_link *
 bpf_program__attach_raw_tracepoint(struct bpf_program *prog,
 				   const char *tp_name);
 
+LIBBPF_API struct bpf_link *
+bpf_program__attach_trace(struct bpf_program *prog);
 struct bpf_insn;
 
 /*
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 86173cbb159d..3a7ea739bb2a 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -198,8 +198,10 @@ LIBBPF_0.0.6 {
 		bpf_map__set_pin_path;
 		bpf_object__open_file;
 		bpf_object__open_mem;
+		bpf_program__attach_trace;
 		bpf_program__get_expected_attach_type;
 		bpf_program__get_type;
 		bpf_program__is_tracing;
 		bpf_program__set_tracing;
+		libbpf_attach_btf_id_by_name;
 } LIBBPF_0.0.5;
-- 
2.23.0

