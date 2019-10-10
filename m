Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B02A1D1F66
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 06:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732735AbfJJEPX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 10 Oct 2019 00:15:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64102 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728771AbfJJEPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 00:15:17 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9A4E5FF024766
        for <netdev@vger.kernel.org>; Wed, 9 Oct 2019 21:15:16 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vhm0ua7qs-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 21:15:16 -0700
Received: from 2401:db00:2050:5102:face:0:3b:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 9 Oct 2019 21:15:14 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 675CF760CEE; Wed,  9 Oct 2019 21:15:13 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 05/12] libbpf: auto-detect btf_id of raw_tracepoint
Date:   Wed, 9 Oct 2019 21:14:56 -0700
Message-ID: <20191010041503.2526303-6-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010041503.2526303-1-ast@kernel.org>
References: <20191010041503.2526303-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-10_02:2019-10-08,2019-10-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 clxscore=1015 bulkscore=0 impostorscore=0 mlxscore=0
 suspectscore=3 mlxlogscore=999 lowpriorityscore=0 adultscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910100037
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For raw tracepoint program types libbpf will try to find
btf_id of raw tracepoint in vmlinux's BTF.
It's a responsiblity of bpf program author to annotate the program
with SEC("raw_tracepoint/name") where "name" is a valid raw tracepoint.
If "name" is indeed a valid raw tracepoint then in-kernel BTF
will have "btf_trace_##name" typedef that points to function
prototype of that raw tracepoint. BTF description captures
exact argument the kernel C code is passing into raw tracepoint.
The kernel verifier will check the types while loading bpf program.

libbpf keeps BTF type id in expected_attach_type, but since
kernel ignores this attribute for tracing programs copy it
into attach_btf_id attribute before loading.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/lib/bpf/bpf.c    |  3 +++
 tools/lib/bpf/libbpf.c | 17 +++++++++++++++++
 2 files changed, 20 insertions(+)

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
index a02cdedc4e3f..8bf30a67428c 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4586,6 +4586,23 @@ int libbpf_prog_type_by_name(const char *name, enum bpf_prog_type *prog_type,
 			continue;
 		*prog_type = section_names[i].prog_type;
 		*expected_attach_type = section_names[i].expected_attach_type;
+		if (*prog_type == BPF_PROG_TYPE_RAW_TRACEPOINT) {
+			struct btf *btf = bpf_core_find_kernel_btf();
+			char raw_tp_btf_name[128] = "btf_trace_";
+			char *dst = raw_tp_btf_name + sizeof("btf_trace_") - 1;
+			int ret;
+
+			if (IS_ERR(btf))
+				/* lack of kernel BTF is not a failure */
+				return 0;
+			/* prepend "btf_trace_" prefix per kernel convention */
+			strncat(dst, name + section_names[i].len,
+				sizeof(raw_tp_btf_name) - (dst - raw_tp_btf_name));
+			ret = btf__find_by_name(btf, raw_tp_btf_name);
+			if (ret > 0)
+				*expected_attach_type = ret;
+			btf__free(btf);
+		}
 		return 0;
 	}
 	pr_warning("failed to guess program type based on ELF section name '%s'\n", name);
-- 
2.23.0

