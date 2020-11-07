Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C5E2AA1A1
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 01:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbgKGADR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 6 Nov 2020 19:03:17 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8036 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728059AbgKGADH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 19:03:07 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A700qqY030020
        for <netdev@vger.kernel.org>; Fri, 6 Nov 2020 16:03:05 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34m5r5vp5h-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 06 Nov 2020 16:03:05 -0800
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 6 Nov 2020 16:03:03 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 3945C2EC8FB3; Fri,  6 Nov 2020 16:02:58 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Dmitrii Banshchikov <dbanschikov@fb.com>
Subject: [PATCH bpf] libbpf: don't attempt to load unused subprog as an entry-point BPF program
Date:   Fri, 6 Nov 2020 16:02:51 -0800
Message-ID: <20201107000251.256821-1-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-06_06:2020-11-05,2020-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=834 suspectscore=0 clxscore=1015
 spamscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011060162
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If BPF code contains unused BPF subprogram and there are no other subprogram
calls (which can realistically happen in real-world applications given
sufficiently smart Clang code optimizations), libbpf will erroneously assume
that subprograms are entry-point programs and will attempt to load them with
UNSPEC program type.

Fix by not relying on subcall instructions and rather detect it based on the
structure of BPF object's sections.

Reported-by: Dmitrii Banshchikov <dbanschikov@fb.com>
Fixes: 9a94f277c4fb ("tools: libbpf: restore the ability to load programs from .text section")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/libbpf.c                        | 23 +++++++++++--------
 .../selftests/bpf/prog_tests/subprogs.c       |  6 +++++
 .../bpf/progs/test_subprogs_unused.c          | 21 +++++++++++++++++
 3 files changed, 40 insertions(+), 10 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_subprogs_unused.c

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 313034117070..28baee7ba1ca 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -560,8 +560,6 @@ bpf_object__init_prog(struct bpf_object *obj, struct bpf_program *prog,
 		      const char *name, size_t sec_idx, const char *sec_name,
 		      size_t sec_off, void *insn_data, size_t insn_data_sz)
 {
-	int i;
-
 	if (insn_data_sz == 0 || insn_data_sz % BPF_INSN_SZ || sec_off % BPF_INSN_SZ) {
 		pr_warn("sec '%s': corrupted program '%s', offset %zu, size %zu\n",
 			sec_name, name, sec_off, insn_data_sz);
@@ -600,13 +598,6 @@ bpf_object__init_prog(struct bpf_object *obj, struct bpf_program *prog,
 		goto errout;
 	memcpy(prog->insns, insn_data, insn_data_sz);
 
-	for (i = 0; i < prog->insns_cnt; i++) {
-		if (insn_is_subprog_call(&prog->insns[i])) {
-			obj->has_subcalls = true;
-			break;
-		}
-	}
-
 	return 0;
 errout:
 	pr_warn("sec '%s': failed to allocate memory for prog '%s'\n", sec_name, name);
@@ -3280,7 +3271,19 @@ bpf_object__find_program_by_title(const struct bpf_object *obj,
 static bool prog_is_subprog(const struct bpf_object *obj,
 			    const struct bpf_program *prog)
 {
-	return prog->sec_idx == obj->efile.text_shndx && obj->has_subcalls;
+	/* For legacy reasons, libbpf supports an entry-point BPF programs
+	 * without SEC() attribute, i.e., those in the .text section. But if
+	 * there are 2 or more such programs in the .text section, they all
+	 * must be subprograms called from entry-point BPF programs in
+	 * designated SEC()'tions, otherwise there is no way to distinguish
+	 * which of those programs should be loaded vs which are a subprogram.
+	 * Similarly, if there is a function/program in .text and at least one
+	 * other BPF program with custom SEC() attribute, then we just assume
+	 * .text programs are subprograms (even if they are not called from
+	 * other programs), because libbpf never explicitly supported mixing
+	 * SEC()-designated BPF programs and .text entry-point BPF programs.
+	 */
+	return prog->sec_idx == obj->efile.text_shndx && obj->nr_programs > 1;
 }
 
 struct bpf_program *
diff --git a/tools/testing/selftests/bpf/prog_tests/subprogs.c b/tools/testing/selftests/bpf/prog_tests/subprogs.c
index a00abf58c037..3f3d2ac4dd57 100644
--- a/tools/testing/selftests/bpf/prog_tests/subprogs.c
+++ b/tools/testing/selftests/bpf/prog_tests/subprogs.c
@@ -3,12 +3,14 @@
 #include <test_progs.h>
 #include <time.h>
 #include "test_subprogs.skel.h"
+#include "test_subprogs_unused.skel.h"
 
 static int duration;
 
 void test_subprogs(void)
 {
 	struct test_subprogs *skel;
+	struct test_subprogs_unused *skel2;
 	int err;
 
 	skel = test_subprogs__open_and_load();
@@ -26,6 +28,10 @@ void test_subprogs(void)
 	CHECK(skel->bss->res3 != 19, "res3", "got %d, exp %d\n", skel->bss->res3, 19);
 	CHECK(skel->bss->res4 != 36, "res4", "got %d, exp %d\n", skel->bss->res4, 36);
 
+	skel2 = test_subprogs_unused__open_and_load();
+	ASSERT_OK_PTR(skel2, "unused_progs_skel");
+	test_subprogs_unused__destroy(skel2);
+
 cleanup:
 	test_subprogs__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_subprogs_unused.c b/tools/testing/selftests/bpf/progs/test_subprogs_unused.c
new file mode 100644
index 000000000000..75d975f8cf90
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_subprogs_unused.c
@@ -0,0 +1,21 @@
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_core_read.h>
+
+const char LICENSE[] SEC("license") = "GPL";
+
+__attribute__((maybe_unused)) __noinline int unused1(int x)
+{
+	return x + 1;
+}
+
+static __attribute__((maybe_unused)) __noinline int unused2(int x)
+{
+	return x + 2;
+}
+
+SEC("raw_tp/sys_enter")
+int main_prog(void *ctx)
+{
+	return 0;
+}
-- 
2.24.1

