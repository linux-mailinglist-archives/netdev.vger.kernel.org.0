Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8567D8662
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 05:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390958AbfJPDZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 23:25:26 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:12022 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390917AbfJPDZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 23:25:25 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9G3NwTi029560
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 20:25:24 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vna13vrxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 20:25:23 -0700
Received: from 2401:db00:2050:5102:face:0:3b:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 15 Oct 2019 20:25:17 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id E2E1B760F32; Tue, 15 Oct 2019 20:25:15 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 05/11] libbpf: auto-detect btf_id of BTF-based raw_tracepoints
Date:   Tue, 15 Oct 2019 20:24:59 -0700
Message-ID: <20191016032505.2089704-6-ast@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191016032505.2089704-1-ast@kernel.org>
References: <20191016032505.2089704-1-ast@kernel.org>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_01:2019-10-15,2019-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 malwarescore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0 bulkscore=0
 phishscore=0 suspectscore=3 clxscore=1015 impostorscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910160029
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's a responsiblity of bpf program author to annotate the program
with SEC("tp_btf/name") where "name" is a valid raw tracepoint.
The libbpf will try to find "name" in vmlinux BTF and error out
in case vmlinux BTF is not available or "name" is not found.
If "name" is indeed a valid raw tracepoint then in-kernel BTF
will have "btf_trace_##name" typedef that points to function
prototype of that raw tracepoint. BTF description captures
exact argument the kernel C code is passing into raw tracepoint.
The kernel verifier will check the types while loading bpf program.

libbpf keeps BTF type id in expected_attach_type, but since
kernel ignores this attribute for tracing programs copy it
into attach_btf_id attribute before loading.

Later the kernel will use prog->attach_btf_id to select raw tracepoint
during bpf_raw_tracepoint_open syscall command.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/lib/bpf/bpf.c    |  3 +++
 tools/lib/bpf/libbpf.c | 38 ++++++++++++++++++++++++++++++++------
 2 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index cbb933532981..79046067720f 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -228,6 +228,9 @@ int bpf_load_program_xattr(const struct bpf_load_program_attr *load_attr,
 	memset(&attr, 0, sizeof(attr));
 	attr.prog_type = load_attr->prog_type;
 	attr.expected_attach_type = load_attr->expected_attach_type;
+	if (attr.prog_type == BPF_PROG_TYPE_RAW_TRACEPOINT)
+		/* expected_attach_type is ignored for tracing progs */
+		attr.attach_btf_id = attr.expected_attach_type;
 	attr.insn_cnt = (__u32)load_attr->insns_cnt;
 	attr.insns = ptr_to_u64(load_attr->insns);
 	attr.license = ptr_to_u64(load_attr->license);
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 8d565590ce05..22bf3b189947 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4489,19 +4489,22 @@ void bpf_program__set_expected_attach_type(struct bpf_program *prog,
 	prog->expected_attach_type = type;
 }
 
-#define BPF_PROG_SEC_IMPL(string, ptype, eatype, is_attachable, atype) \
-	{ string, sizeof(string) - 1, ptype, eatype, is_attachable, atype }
+#define BPF_PROG_SEC_IMPL(string, ptype, eatype, is_attachable, btf, atype) \
+	{ string, sizeof(string) - 1, ptype, eatype, is_attachable, btf, atype }
 
 /* Programs that can NOT be attached. */
-#define BPF_PROG_SEC(string, ptype) BPF_PROG_SEC_IMPL(string, ptype, 0, 0, 0)
+#define BPF_PROG_SEC(string, ptype) BPF_PROG_SEC_IMPL(string, ptype, 0, 0, 0, 0)
 
 /* Programs that can be attached. */
 #define BPF_APROG_SEC(string, ptype, atype) \
-	BPF_PROG_SEC_IMPL(string, ptype, 0, 1, atype)
+	BPF_PROG_SEC_IMPL(string, ptype, 0, 1, 0, atype)
 
 /* Programs that must specify expected attach type at load time. */
 #define BPF_EAPROG_SEC(string, ptype, eatype) \
-	BPF_PROG_SEC_IMPL(string, ptype, eatype, 1, eatype)
+	BPF_PROG_SEC_IMPL(string, ptype, eatype, 1, 0, eatype)
+
+/* Programs that use BTF to identify attach point */
+#define BPF_PROG_BTF(string, ptype) BPF_PROG_SEC_IMPL(string, ptype, 0, 0, 1, 0)
 
 /* Programs that can be attached but attach type can't be identified by section
  * name. Kept for backward compatibility.
@@ -4513,7 +4516,8 @@ static const struct {
 	size_t len;
 	enum bpf_prog_type prog_type;
 	enum bpf_attach_type expected_attach_type;
-	int is_attachable;
+	bool is_attachable;
+	bool is_attach_btf;
 	enum bpf_attach_type attach_type;
 } section_names[] = {
 	BPF_PROG_SEC("socket",			BPF_PROG_TYPE_SOCKET_FILTER),
@@ -4523,6 +4527,7 @@ static const struct {
 	BPF_PROG_SEC("action",			BPF_PROG_TYPE_SCHED_ACT),
 	BPF_PROG_SEC("tracepoint/",		BPF_PROG_TYPE_TRACEPOINT),
 	BPF_PROG_SEC("raw_tracepoint/",		BPF_PROG_TYPE_RAW_TRACEPOINT),
+	BPF_PROG_BTF("tp_btf/",			BPF_PROG_TYPE_RAW_TRACEPOINT),
 	BPF_PROG_SEC("xdp",			BPF_PROG_TYPE_XDP),
 	BPF_PROG_SEC("perf_event",		BPF_PROG_TYPE_PERF_EVENT),
 	BPF_PROG_SEC("lwt_in",			BPF_PROG_TYPE_LWT_IN),
@@ -4627,6 +4632,27 @@ int libbpf_prog_type_by_name(const char *name, enum bpf_prog_type *prog_type,
 			continue;
 		*prog_type = section_names[i].prog_type;
 		*expected_attach_type = section_names[i].expected_attach_type;
+		if (section_names[i].is_attach_btf) {
+			struct btf *btf = bpf_core_find_kernel_btf();
+			char raw_tp_btf_name[128] = "btf_trace_";
+			char *dst = raw_tp_btf_name + sizeof("btf_trace_") - 1;
+			int ret;
+
+			if (IS_ERR(btf)) {
+				pr_warning("vmlinux BTF is not found\n");
+				return -EINVAL;
+			}
+			/* prepend "btf_trace_" prefix per kernel convention */
+			strncat(dst, name + section_names[i].len,
+				sizeof(raw_tp_btf_name) - (dst - raw_tp_btf_name));
+			ret = btf__find_by_name(btf, raw_tp_btf_name);
+			btf__free(btf);
+			if (ret <= 0) {
+				pr_warning("%s is not found in vmlinux BTF\n", dst);
+				return -EINVAL;
+			}
+			*expected_attach_type = ret;
+		}
 		return 0;
 	}
 	pr_warning("failed to guess program type based on ELF section name '%s'\n", name);
-- 
2.17.1

