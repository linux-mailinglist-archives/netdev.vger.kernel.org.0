Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 704D3EA636
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 23:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfJ3WcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 18:32:20 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55826 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726377AbfJ3WcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 18:32:19 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9UMUl8O014557
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 15:32:18 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vxwn6x8u2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 15:32:18 -0700
Received: from 2401:db00:2050:5076:face:0:1f:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 30 Oct 2019 15:32:17 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 2ED72760903; Wed, 30 Oct 2019 15:32:17 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 2/2] libbpf: add support for prog_tracing
Date:   Wed, 30 Oct 2019 15:32:12 -0700
Message-ID: <20191030223212.953010-3-ast@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191030223212.953010-1-ast@kernel.org>
References: <20191030223212.953010-1-ast@kernel.org>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-30_09:2019-10-30,2019-10-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 mlxscore=0 spamscore=0 clxscore=1034 phishscore=0 impostorscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=3
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910300200
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cleanup libbpf from expected_attach_type == attach_btf_id hack
and introduce BPF_PROG_TYPE_TRACING.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/include/uapi/linux/bpf.h |  2 +
 tools/lib/bpf/bpf.c            |  8 ++--
 tools/lib/bpf/bpf.h            |  5 ++-
 tools/lib/bpf/libbpf.c         | 79 ++++++++++++++++++++++++----------
 tools/lib/bpf/libbpf.h         |  2 +
 tools/lib/bpf/libbpf.map       |  2 +
 tools/lib/bpf/libbpf_probes.c  |  1 +
 7 files changed, 71 insertions(+), 28 deletions(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4af8b0819a32..a6bf19dabaab 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -173,6 +173,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_CGROUP_SYSCTL,
 	BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
 	BPF_PROG_TYPE_CGROUP_SOCKOPT,
+	BPF_PROG_TYPE_TRACING,
 };
 
 enum bpf_attach_type {
@@ -199,6 +200,7 @@ enum bpf_attach_type {
 	BPF_CGROUP_UDP6_RECVMSG,
 	BPF_CGROUP_GETSOCKOPT,
 	BPF_CGROUP_SETSOCKOPT,
+	BPF_TRACE_RAW_TP,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 79046067720f..ca0d635b1d5e 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -228,9 +228,10 @@ int bpf_load_program_xattr(const struct bpf_load_program_attr *load_attr,
 	memset(&attr, 0, sizeof(attr));
 	attr.prog_type = load_attr->prog_type;
 	attr.expected_attach_type = load_attr->expected_attach_type;
-	if (attr.prog_type == BPF_PROG_TYPE_RAW_TRACEPOINT)
-		/* expected_attach_type is ignored for tracing progs */
-		attr.attach_btf_id = attr.expected_attach_type;
+	if (attr.prog_type == BPF_PROG_TYPE_TRACING)
+		attr.attach_btf_id = load_attr->attach_btf_id;
+	else
+		attr.prog_ifindex = load_attr->prog_ifindex;
 	attr.insn_cnt = (__u32)load_attr->insns_cnt;
 	attr.insns = ptr_to_u64(load_attr->insns);
 	attr.license = ptr_to_u64(load_attr->license);
@@ -245,7 +246,6 @@ int bpf_load_program_xattr(const struct bpf_load_program_attr *load_attr,
 	}
 
 	attr.kern_version = load_attr->kern_version;
-	attr.prog_ifindex = load_attr->prog_ifindex;
 	attr.prog_btf_fd = load_attr->prog_btf_fd;
 	attr.func_info_rec_size = load_attr->func_info_rec_size;
 	attr.func_info_cnt = load_attr->func_info_cnt;
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 0db01334740f..1c53bc5b4b3c 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -78,7 +78,10 @@ struct bpf_load_program_attr {
 	size_t insns_cnt;
 	const char *license;
 	__u32 kern_version;
-	__u32 prog_ifindex;
+	union {
+		__u32 prog_ifindex;
+		__u32 attach_btf_id;
+	};
 	__u32 prog_btf_fd;
 	__u32 func_info_rec_size;
 	const void *func_info;
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 5d15cc4dfcd6..c80f316f1320 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -188,6 +188,7 @@ struct bpf_program {
 	bpf_program_clear_priv_t clear_priv;
 
 	enum bpf_attach_type expected_attach_type;
+	__u32 attach_btf_id;
 	void *func_info;
 	__u32 func_info_rec_size;
 	__u32 func_info_cnt;
@@ -3446,6 +3447,7 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	load_attr.line_info_cnt = prog->line_info_cnt;
 	load_attr.log_level = prog->log_level;
 	load_attr.prog_flags = prog->prog_flags;
+	load_attr.attach_btf_id = prog->attach_btf_id;
 
 retry_load:
 	log_buf = malloc(log_buf_size);
@@ -3607,6 +3609,8 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
 	return 0;
 }
 
+static int libbpf_attach_btf_id_by_name(const char *name, __u32 *btf_id);
+
 static struct bpf_object *
 __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 		   struct bpf_object_open_opts *opts)
@@ -3656,6 +3660,7 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 	bpf_object__for_each_program(prog, obj) {
 		enum bpf_prog_type prog_type;
 		enum bpf_attach_type attach_type;
+		__u32 btf_id;
 
 		err = libbpf_prog_type_by_name(prog->section_name, &prog_type,
 					       &attach_type);
@@ -3667,6 +3672,12 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 
 		bpf_program__set_type(prog, prog_type);
 		bpf_program__set_expected_attach_type(prog, attach_type);
+		if (prog_type == BPF_PROG_TYPE_TRACING) {
+			err = libbpf_attach_btf_id_by_name(prog->section_name, &btf_id);
+			if (err)
+				goto out;
+			prog->attach_btf_id = btf_id;
+		}
 	}
 
 	return obj;
@@ -4518,6 +4529,7 @@ BPF_PROG_TYPE_FNS(tracepoint, BPF_PROG_TYPE_TRACEPOINT);
 BPF_PROG_TYPE_FNS(raw_tracepoint, BPF_PROG_TYPE_RAW_TRACEPOINT);
 BPF_PROG_TYPE_FNS(xdp, BPF_PROG_TYPE_XDP);
 BPF_PROG_TYPE_FNS(perf_event, BPF_PROG_TYPE_PERF_EVENT);
+BPF_PROG_TYPE_FNS(tracing, BPF_PROG_TYPE_TRACING);
 
 enum bpf_attach_type
 bpf_program__get_expected_attach_type(struct bpf_program *prog)
@@ -4546,7 +4558,8 @@ void bpf_program__set_expected_attach_type(struct bpf_program *prog,
 	BPF_PROG_SEC_IMPL(string, ptype, eatype, 1, 0, eatype)
 
 /* Programs that use BTF to identify attach point */
-#define BPF_PROG_BTF(string, ptype) BPF_PROG_SEC_IMPL(string, ptype, 0, 0, 1, 0)
+#define BPF_PROG_BTF(string, ptype, eatype) \
+	BPF_PROG_SEC_IMPL(string, ptype, eatype, 0, 1, 0)
 
 /* Programs that can be attached but attach type can't be identified by section
  * name. Kept for backward compatibility.
@@ -4573,7 +4586,8 @@ static const struct {
 	BPF_PROG_SEC("tp/",			BPF_PROG_TYPE_TRACEPOINT),
 	BPF_PROG_SEC("raw_tracepoint/",		BPF_PROG_TYPE_RAW_TRACEPOINT),
 	BPF_PROG_SEC("raw_tp/",			BPF_PROG_TYPE_RAW_TRACEPOINT),
-	BPF_PROG_BTF("tp_btf/",			BPF_PROG_TYPE_RAW_TRACEPOINT),
+	BPF_PROG_BTF("tp_btf/",			BPF_PROG_TYPE_TRACING,
+						BPF_TRACE_RAW_TP),
 	BPF_PROG_SEC("xdp",			BPF_PROG_TYPE_XDP),
 	BPF_PROG_SEC("perf_event",		BPF_PROG_TYPE_PERF_EVENT),
 	BPF_PROG_SEC("lwt_in",			BPF_PROG_TYPE_LWT_IN),
@@ -4678,27 +4692,6 @@ int libbpf_prog_type_by_name(const char *name, enum bpf_prog_type *prog_type,
 			continue;
 		*prog_type = section_names[i].prog_type;
 		*expected_attach_type = section_names[i].expected_attach_type;
-		if (section_names[i].is_attach_btf) {
-			struct btf *btf = bpf_core_find_kernel_btf();
-			char raw_tp_btf_name[128] = "btf_trace_";
-			char *dst = raw_tp_btf_name + sizeof("btf_trace_") - 1;
-			int ret;
-
-			if (IS_ERR(btf)) {
-				pr_warn("vmlinux BTF is not found\n");
-				return -EINVAL;
-			}
-			/* prepend "btf_trace_" prefix per kernel convention */
-			strncat(dst, name + section_names[i].len,
-				sizeof(raw_tp_btf_name) - sizeof("btf_trace_"));
-			ret = btf__find_by_name(btf, raw_tp_btf_name);
-			btf__free(btf);
-			if (ret <= 0) {
-				pr_warn("%s is not found in vmlinux BTF\n", dst);
-				return -EINVAL;
-			}
-			*expected_attach_type = ret;
-		}
 		return 0;
 	}
 	pr_warn("failed to guess program type based on ELF section name '%s'\n", name);
@@ -4711,6 +4704,46 @@ int libbpf_prog_type_by_name(const char *name, enum bpf_prog_type *prog_type,
 	return -ESRCH;
 }
 
+#define BTF_PREFIX "btf_trace_"
+static int libbpf_attach_btf_id_by_name(const char *name, __u32 *btf_id)
+{
+	struct btf *btf = bpf_core_find_kernel_btf();
+	char raw_tp_btf_name[128] = BTF_PREFIX;
+	char *dst = raw_tp_btf_name + sizeof(BTF_PREFIX) - 1;
+	int ret, i, err = -EINVAL;
+
+	if (IS_ERR(btf)) {
+		pr_warn("vmlinux BTF is not found\n");
+		return -EINVAL;
+	}
+
+	if (!name)
+		goto out;
+
+	for (i = 0; i < ARRAY_SIZE(section_names); i++) {
+		if (!section_names[i].is_attach_btf)
+			continue;
+		if (strncmp(name, section_names[i].sec, section_names[i].len))
+			continue;
+		/* prepend "btf_trace_" prefix per kernel convention */
+		strncat(dst, name + section_names[i].len,
+			sizeof(raw_tp_btf_name) - sizeof(BTF_PREFIX));
+		ret = btf__find_by_name(btf, raw_tp_btf_name);
+		if (ret <= 0) {
+			pr_warn("%s is not found in vmlinux BTF\n", dst);
+			goto out;
+		}
+		*btf_id = ret;
+		err = 0;
+		goto out;
+	}
+	pr_warn("failed to identify btf_id based on ELF section name '%s'\n", name);
+	err = -ESRCH;
+out:
+	btf__free(btf);
+	return err;
+}
+
 int libbpf_attach_type_by_name(const char *name,
 			       enum bpf_attach_type *attach_type)
 {
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index c63e2ff84abc..2b126ee5e173 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -307,6 +307,7 @@ LIBBPF_API int bpf_program__set_sched_cls(struct bpf_program *prog);
 LIBBPF_API int bpf_program__set_sched_act(struct bpf_program *prog);
 LIBBPF_API int bpf_program__set_xdp(struct bpf_program *prog);
 LIBBPF_API int bpf_program__set_perf_event(struct bpf_program *prog);
+LIBBPF_API int bpf_program__set_tracing(struct bpf_program *prog);
 
 LIBBPF_API enum bpf_prog_type bpf_program__get_type(struct bpf_program *prog);
 LIBBPF_API void bpf_program__set_type(struct bpf_program *prog,
@@ -326,6 +327,7 @@ LIBBPF_API bool bpf_program__is_sched_cls(const struct bpf_program *prog);
 LIBBPF_API bool bpf_program__is_sched_act(const struct bpf_program *prog);
 LIBBPF_API bool bpf_program__is_xdp(const struct bpf_program *prog);
 LIBBPF_API bool bpf_program__is_perf_event(const struct bpf_program *prog);
+LIBBPF_API bool bpf_program__is_tracing(const struct bpf_program *prog);
 
 /*
  * No need for __attribute__((packed)), all members of 'bpf_map_def'
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index d1473ea4d7a5..69dded5af00b 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -197,4 +197,6 @@ LIBBPF_0.0.6 {
 		bpf_object__open_mem;
 		bpf_program__get_expected_attach_type;
 		bpf_program__get_type;
+		bpf_program__is_tracing;
+		bpf_program__set_tracing;
 } LIBBPF_0.0.5;
diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
index 4b0b0364f5fc..a9eb8b322671 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -102,6 +102,7 @@ probe_load(enum bpf_prog_type prog_type, const struct bpf_insn *insns,
 	case BPF_PROG_TYPE_FLOW_DISSECTOR:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
 	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
+	case BPF_PROG_TYPE_TRACING:
 	default:
 		break;
 	}
-- 
2.17.1

