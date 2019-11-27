Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA63410B72B
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 21:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfK0UG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 15:06:57 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42398 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726729AbfK0UG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 15:06:56 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xARJhJoD025100
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 12:06:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=2zo+L2lkRdURqBGaburOWmMv8Yl9GNGw8GrgXgVhgbo=;
 b=BUsWjfE1tieFTj+hPkMHckCKqWvNfGA+oterzjGxqS50jVnFS3vi0TtfU9Qz5kg8zOW6
 hBryZyDK48zK9ysuMy3G3JcQCD61NWrHNLwiRoPfMZ5gLOb9yAEEBjARPoDHd+8Pl0IE
 nFVJ64WD37OqqGUgZY3UldlkLfGRAcRctv0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2whcy6pgx2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 12:06:55 -0800
Received: from 2401:db00:2050:5102:face:0:3b:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 27 Nov 2019 12:06:53 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id A2E5E2EC1D62; Wed, 27 Nov 2019 12:06:52 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <yhs@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf] libbpf: fix global variable relocation
Date:   Wed, 27 Nov 2019 12:06:50 -0800
Message-ID: <20191127200651.1381348-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-27_04:2019-11-27,2019-11-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 clxscore=1015
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911270161
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similarly to a0d7da26ce86 ("libbpf: Fix call relocation offset calculation
bug"), relocations against global variables need to take into account
referenced symbol's st_value, which holds offset into a corresponding data
section (and, subsequently, offset into internal backing map). For static
variables this offset is always zero and data offset is completely described
by respective instruction's imm field.

Convert a bunch of selftests to global variables. Previously they were relying
on `static volatile` trick to ensure Clang doesn't inline static variables,
which with global variables is not necessary anymore.

Fixes: 393cdfbee809 ("libbpf: Support initialized global variables")
Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c                        | 43 ++++++++-----------
 .../testing/selftests/bpf/progs/fentry_test.c | 12 +++---
 .../selftests/bpf/progs/fexit_bpf2bpf.c       |  6 +--
 .../testing/selftests/bpf/progs/fexit_test.c  | 12 +++---
 tools/testing/selftests/bpf/progs/test_mmap.c |  4 +-
 5 files changed, 36 insertions(+), 41 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index b20f82e58989..bae692831e14 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -171,10 +171,8 @@ struct bpf_program {
 			RELO_DATA,
 		} type;
 		int insn_idx;
-		union {
-			int map_idx;
-			int text_off;
-		};
+		int map_idx;
+		int sym_off;
 	} *reloc_desc;
 	int nr_reloc;
 	int log_level;
@@ -1824,7 +1822,7 @@ static int bpf_program__record_reloc(struct bpf_program *prog,
 		}
 		reloc_desc->type = RELO_CALL;
 		reloc_desc->insn_idx = insn_idx;
-		reloc_desc->text_off = sym->st_value / 8;
+		reloc_desc->sym_off = sym->st_value;
 		obj->has_pseudo_calls = true;
 		return 0;
 	}
@@ -1868,6 +1866,7 @@ static int bpf_program__record_reloc(struct bpf_program *prog,
 		reloc_desc->type = RELO_LD64;
 		reloc_desc->insn_idx = insn_idx;
 		reloc_desc->map_idx = map_idx;
+		reloc_desc->sym_off = 0; /* sym->st_value determines map_idx */
 		return 0;
 	}
 
@@ -1899,6 +1898,7 @@ static int bpf_program__record_reloc(struct bpf_program *prog,
 	reloc_desc->type = RELO_DATA;
 	reloc_desc->insn_idx = insn_idx;
 	reloc_desc->map_idx = map_idx;
+	reloc_desc->sym_off = sym->st_value;
 	return 0;
 }
 
@@ -3563,8 +3563,8 @@ bpf_program__reloc_text(struct bpf_program *prog, struct bpf_object *obj,
 		return -LIBBPF_ERRNO__RELOC;
 
 	if (prog->idx == obj->efile.text_shndx) {
-		pr_warn("relo in .text insn %d into off %d\n",
-			relo->insn_idx, relo->text_off);
+		pr_warn("relo in .text insn %d into off %d (insn #%d)\n",
+			relo->insn_idx, relo->sym_off, relo->sym_off / 8);
 		return -LIBBPF_ERRNO__RELOC;
 	}
 
@@ -3599,7 +3599,7 @@ bpf_program__reloc_text(struct bpf_program *prog, struct bpf_object *obj,
 			 prog->section_name);
 	}
 	insn = &prog->insns[relo->insn_idx];
-	insn->imm += relo->text_off + prog->main_prog_cnt - relo->insn_idx;
+	insn->imm += relo->sym_off / 8 + prog->main_prog_cnt - relo->insn_idx;
 	return 0;
 }
 
@@ -3622,31 +3622,26 @@ bpf_program__relocate(struct bpf_program *prog, struct bpf_object *obj)
 		return 0;
 
 	for (i = 0; i < prog->nr_reloc; i++) {
-		if (prog->reloc_desc[i].type == RELO_LD64 ||
-		    prog->reloc_desc[i].type == RELO_DATA) {
-			bool relo_data = prog->reloc_desc[i].type == RELO_DATA;
-			struct bpf_insn *insns = prog->insns;
-			int insn_idx, map_idx;
+		struct reloc_desc *relo = &prog->reloc_desc[i];
 
-			insn_idx = prog->reloc_desc[i].insn_idx;
-			map_idx = prog->reloc_desc[i].map_idx;
+		if (relo->type == RELO_LD64 || relo->type == RELO_DATA) {
+			struct bpf_insn *insn = &prog->insns[relo->insn_idx];
 
-			if (insn_idx + 1 >= (int)prog->insns_cnt) {
+			if (relo->insn_idx + 1 >= (int)prog->insns_cnt) {
 				pr_warn("relocation out of range: '%s'\n",
 					prog->section_name);
 				return -LIBBPF_ERRNO__RELOC;
 			}
 
-			if (!relo_data) {
-				insns[insn_idx].src_reg = BPF_PSEUDO_MAP_FD;
+			if (relo->type != RELO_DATA) {
+				insn[0].src_reg = BPF_PSEUDO_MAP_FD;
 			} else {
-				insns[insn_idx].src_reg = BPF_PSEUDO_MAP_VALUE;
-				insns[insn_idx + 1].imm = insns[insn_idx].imm;
+				insn[0].src_reg = BPF_PSEUDO_MAP_VALUE;
+				insn[1].imm = insn[0].imm + relo->sym_off;
 			}
-			insns[insn_idx].imm = obj->maps[map_idx].fd;
-		} else if (prog->reloc_desc[i].type == RELO_CALL) {
-			err = bpf_program__reloc_text(prog, obj,
-						      &prog->reloc_desc[i]);
+			insn[0].imm = obj->maps[relo->map_idx].fd;
+		} else if (relo->type == RELO_CALL) {
+			err = bpf_program__reloc_text(prog, obj, relo);
 			if (err)
 				return err;
 		}
diff --git a/tools/testing/selftests/bpf/progs/fentry_test.c b/tools/testing/selftests/bpf/progs/fentry_test.c
index d2af9f039df5..615f7c6bca77 100644
--- a/tools/testing/selftests/bpf/progs/fentry_test.c
+++ b/tools/testing/selftests/bpf/progs/fentry_test.c
@@ -6,28 +6,28 @@
 
 char _license[] SEC("license") = "GPL";
 
-static volatile __u64 test1_result;
+__u64 test1_result = 0;
 BPF_TRACE_1("fentry/bpf_fentry_test1", test1, int, a)
 {
 	test1_result = a == 1;
 	return 0;
 }
 
-static volatile __u64 test2_result;
+__u64 test2_result = 0;
 BPF_TRACE_2("fentry/bpf_fentry_test2", test2, int, a, __u64, b)
 {
 	test2_result = a == 2 && b == 3;
 	return 0;
 }
 
-static volatile __u64 test3_result;
+__u64 test3_result = 0;
 BPF_TRACE_3("fentry/bpf_fentry_test3", test3, char, a, int, b, __u64, c)
 {
 	test3_result = a == 4 && b == 5 && c == 6;
 	return 0;
 }
 
-static volatile __u64 test4_result;
+__u64 test4_result = 0;
 BPF_TRACE_4("fentry/bpf_fentry_test4", test4,
 	    void *, a, char, b, int, c, __u64, d)
 {
@@ -35,7 +35,7 @@ BPF_TRACE_4("fentry/bpf_fentry_test4", test4,
 	return 0;
 }
 
-static volatile __u64 test5_result;
+__u64 test5_result = 0;
 BPF_TRACE_5("fentry/bpf_fentry_test5", test5,
 	    __u64, a, void *, b, short, c, int, d, __u64, e)
 {
@@ -44,7 +44,7 @@ BPF_TRACE_5("fentry/bpf_fentry_test5", test5,
 	return 0;
 }
 
-static volatile __u64 test6_result;
+__u64 test6_result = 0;
 BPF_TRACE_6("fentry/bpf_fentry_test6", test6,
 	    __u64, a, void *, b, short, c, int, d, void *, e, __u64, f)
 {
diff --git a/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c b/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c
index 525d47d7b589..2d211ee98a1c 100644
--- a/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c
@@ -8,7 +8,7 @@ struct sk_buff {
 	unsigned int len;
 };
 
-static volatile __u64 test_result;
+__u64 test_result = 0;
 BPF_TRACE_2("fexit/test_pkt_access", test_main,
 	    struct sk_buff *, skb, int, ret)
 {
@@ -23,7 +23,7 @@ BPF_TRACE_2("fexit/test_pkt_access", test_main,
 	return 0;
 }
 
-static volatile __u64 test_result_subprog1;
+__u64 test_result_subprog1 = 0;
 BPF_TRACE_2("fexit/test_pkt_access_subprog1", test_subprog1,
 	    struct sk_buff *, skb, int, ret)
 {
@@ -56,7 +56,7 @@ struct args_subprog2 {
 	__u64 args[5];
 	__u64 ret;
 };
-static volatile __u64 test_result_subprog2;
+__u64 test_result_subprog2 = 0;
 SEC("fexit/test_pkt_access_subprog2")
 int test_subprog2(struct args_subprog2 *ctx)
 {
diff --git a/tools/testing/selftests/bpf/progs/fexit_test.c b/tools/testing/selftests/bpf/progs/fexit_test.c
index 2487e98edb34..86db0d60fb6e 100644
--- a/tools/testing/selftests/bpf/progs/fexit_test.c
+++ b/tools/testing/selftests/bpf/progs/fexit_test.c
@@ -6,28 +6,28 @@
 
 char _license[] SEC("license") = "GPL";
 
-static volatile __u64 test1_result;
+__u64 test1_result = 0;
 BPF_TRACE_2("fexit/bpf_fentry_test1", test1, int, a, int, ret)
 {
 	test1_result = a == 1 && ret == 2;
 	return 0;
 }
 
-static volatile __u64 test2_result;
+__u64 test2_result = 0;
 BPF_TRACE_3("fexit/bpf_fentry_test2", test2, int, a, __u64, b, int, ret)
 {
 	test2_result = a == 2 && b == 3 && ret == 5;
 	return 0;
 }
 
-static volatile __u64 test3_result;
+__u64 test3_result = 0;
 BPF_TRACE_4("fexit/bpf_fentry_test3", test3, char, a, int, b, __u64, c, int, ret)
 {
 	test3_result = a == 4 && b == 5 && c == 6 && ret == 15;
 	return 0;
 }
 
-static volatile __u64 test4_result;
+__u64 test4_result = 0;
 BPF_TRACE_5("fexit/bpf_fentry_test4", test4,
 	    void *, a, char, b, int, c, __u64, d, int, ret)
 {
@@ -37,7 +37,7 @@ BPF_TRACE_5("fexit/bpf_fentry_test4", test4,
 	return 0;
 }
 
-static volatile __u64 test5_result;
+__u64 test5_result = 0;
 BPF_TRACE_6("fexit/bpf_fentry_test5", test5,
 	    __u64, a, void *, b, short, c, int, d, __u64, e, int, ret)
 {
@@ -46,7 +46,7 @@ BPF_TRACE_6("fexit/bpf_fentry_test5", test5,
 	return 0;
 }
 
-static volatile __u64 test6_result;
+__u64 test6_result = 0;
 BPF_TRACE_7("fexit/bpf_fentry_test6", test6,
 	    __u64, a, void *, b, short, c, int, d, void *, e, __u64, f,
 	    int, ret)
diff --git a/tools/testing/selftests/bpf/progs/test_mmap.c b/tools/testing/selftests/bpf/progs/test_mmap.c
index 0d2ec9fbcf61..e808791b7047 100644
--- a/tools/testing/selftests/bpf/progs/test_mmap.c
+++ b/tools/testing/selftests/bpf/progs/test_mmap.c
@@ -15,8 +15,8 @@ struct {
 	__type(value, __u64);
 } data_map SEC(".maps");
 
-static volatile __u64 in_val;
-static volatile __u64 out_val;
+__u64 in_val = 0;
+__u64 out_val = 0;
 
 SEC("raw_tracepoint/sys_enter")
 int test_mmap(void *ctx)
-- 
2.17.1

