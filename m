Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33FE0FF82D
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 08:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbfKQHIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 02:08:24 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1702 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726007AbfKQHIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 02:08:24 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xAH7511J018737
        for <netdev@vger.kernel.org>; Sat, 16 Nov 2019 23:08:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=okx+Nm2yu5+z+GTNMiiC1ZhDLm2V7WSUdLp1dzGTqL0=;
 b=PJpNkhMV2Tw5NwkkNNyBpF256RX0thGdrkdBv3JntQGaI9iRbYtwVU55fS80Qriyopjf
 eNz1HNc95Yjlvo6l2iG3xqANsqyOh/MmP8r8k/39tdLG86cDzs0sEB+LA6roYYN8J2RW
 Ig/jPmG5lohzV6TV25ghP6qRemxvykBQTHE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2wadg0u1vp-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 16 Nov 2019 23:08:22 -0800
Received: from 2401:db00:2120:81ca:face:0:31:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 16 Nov 2019 23:08:21 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 6E18C2EC19AE; Sat, 16 Nov 2019 23:08:20 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 4/6] libbpf: support initialized global variables
Date:   Sat, 16 Nov 2019 23:08:05 -0800
Message-ID: <20191117070807.251360-5-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191117070807.251360-1-andriin@fb.com>
References: <20191117070807.251360-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-17_01:2019-11-15,2019-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=8 malwarescore=0 impostorscore=0
 adultscore=0 priorityscore=1501 clxscore=1015 phishscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911170066
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initialized global variables are no different in ELF from static variables,
and don't require any extra support from libbpf. But they are matching
semantics of global data (backed by BPF maps) more closely, preventing
LLVM/Clang from aggressively inlining constant values and not requiring
volatile incantations to prevent those. This patch enables global variables.
It still disables uninitialized variables, which will be put into special COM
(common) ELF section, because BPF doesn't allow uninitialized data to be
accessed.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c                                   | 9 ++-------
 .../testing/selftests/bpf/progs/test_core_reloc_arrays.c | 4 ++--
 .../bpf/progs/test_core_reloc_bitfields_direct.c         | 4 ++--
 .../bpf/progs/test_core_reloc_bitfields_probed.c         | 4 ++--
 .../selftests/bpf/progs/test_core_reloc_existence.c      | 4 ++--
 .../selftests/bpf/progs/test_core_reloc_flavors.c        | 4 ++--
 tools/testing/selftests/bpf/progs/test_core_reloc_ints.c | 4 ++--
 .../testing/selftests/bpf/progs/test_core_reloc_kernel.c | 4 ++--
 tools/testing/selftests/bpf/progs/test_core_reloc_misc.c | 4 ++--
 tools/testing/selftests/bpf/progs/test_core_reloc_mods.c | 4 ++--
 .../selftests/bpf/progs/test_core_reloc_nesting.c        | 4 ++--
 .../selftests/bpf/progs/test_core_reloc_primitives.c     | 4 ++--
 .../selftests/bpf/progs/test_core_reloc_ptr_as_arr.c     | 4 ++--
 tools/testing/selftests/bpf/progs/test_core_reloc_size.c | 4 ++--
 14 files changed, 28 insertions(+), 33 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index f6232aeefb9e..639c2e17df0b 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1831,8 +1831,8 @@ static int bpf_program__record_reloc(struct bpf_program *prog,
 		return -LIBBPF_ERRNO__RELOC;
 	}
 	if (!shdr_idx || shdr_idx >= SHN_LORESERVE) {
-		pr_warn("relocation: not yet supported relo for non-static global \'%s\' variable in special section (0x%x) found in insns[%d].code 0x%x\n",
-			name, shdr_idx, insn_idx, insn->code);
+		pr_warn("invalid relo for \'%s\' in special section 0x%x; forgot to initialize global var?..\n",
+			name, shdr_idx);
 		return -LIBBPF_ERRNO__RELOC;
 	}
 
@@ -1872,11 +1872,6 @@ static int bpf_program__record_reloc(struct bpf_program *prog,
 		pr_warn("bad data relo against section %u\n", shdr_idx);
 		return -LIBBPF_ERRNO__RELOC;
 	}
-	if (GELF_ST_BIND(sym->st_info) == STB_GLOBAL) {
-		pr_warn("relocation: not yet supported relo for non-static global \'%s\' variable found in insns[%d].code 0x%x\n",
-			name, insn_idx, insn->code);
-		return -LIBBPF_ERRNO__RELOC;
-	}
 	if (!obj->caps.global_data) {
 		pr_warn("relocation: kernel does not support global \'%s\' variable access in insns[%d]\n",
 			name, insn_idx);
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c b/tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c
index 96b1f5f3b07a..89951b684282 100644
--- a/tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c
@@ -8,10 +8,10 @@
 
 char _license[] SEC("license") = "GPL";
 
-static volatile struct data {
+struct {
 	char in[256];
 	char out[256];
-} data;
+} data = {};
 
 struct core_reloc_arrays_output {
 	int a2;
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_bitfields_direct.c b/tools/testing/selftests/bpf/progs/test_core_reloc_bitfields_direct.c
index 738b34b72655..edc0f7c9e56d 100644
--- a/tools/testing/selftests/bpf/progs/test_core_reloc_bitfields_direct.c
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_bitfields_direct.c
@@ -8,10 +8,10 @@
 
 char _license[] SEC("license") = "GPL";
 
-static volatile struct data {
+struct {
 	char in[256];
 	char out[256];
-} data;
+} data = {};
 
 struct core_reloc_bitfields {
 	/* unsigned bitfields */
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_bitfields_probed.c b/tools/testing/selftests/bpf/progs/test_core_reloc_bitfields_probed.c
index e466e3ab7de4..6c20e433558b 100644
--- a/tools/testing/selftests/bpf/progs/test_core_reloc_bitfields_probed.c
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_bitfields_probed.c
@@ -8,10 +8,10 @@
 
 char _license[] SEC("license") = "GPL";
 
-static volatile struct data {
+struct {
 	char in[256];
 	char out[256];
-} data;
+} data = {};
 
 struct core_reloc_bitfields {
 	/* unsigned bitfields */
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_existence.c b/tools/testing/selftests/bpf/progs/test_core_reloc_existence.c
index c3cac95a19f1..1b7f0ae49cfb 100644
--- a/tools/testing/selftests/bpf/progs/test_core_reloc_existence.c
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_existence.c
@@ -8,10 +8,10 @@
 
 char _license[] SEC("license") = "GPL";
 
-static volatile struct data {
+struct {
 	char in[256];
 	char out[256];
-} data;
+} data = {};
 
 struct core_reloc_existence_output {
 	int a_exists;
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_flavors.c b/tools/testing/selftests/bpf/progs/test_core_reloc_flavors.c
index 71fd7cebc9d7..b5dbeef540fd 100644
--- a/tools/testing/selftests/bpf/progs/test_core_reloc_flavors.c
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_flavors.c
@@ -8,10 +8,10 @@
 
 char _license[] SEC("license") = "GPL";
 
-static volatile struct data {
+struct {
 	char in[256];
 	char out[256];
-} data;
+} data = {};
 
 struct core_reloc_flavors {
 	int a;
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_ints.c b/tools/testing/selftests/bpf/progs/test_core_reloc_ints.c
index ad5c3f59c9c6..c78ab6d28a14 100644
--- a/tools/testing/selftests/bpf/progs/test_core_reloc_ints.c
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_ints.c
@@ -8,10 +8,10 @@
 
 char _license[] SEC("license") = "GPL";
 
-static volatile struct data {
+struct {
 	char in[256];
 	char out[256];
-} data;
+} data = {};
 
 struct core_reloc_ints {
 	uint8_t		u8_field;
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c b/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
index a4b5e0562ed5..5d499ebdc4bd 100644
--- a/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
@@ -8,10 +8,10 @@
 
 char _license[] SEC("license") = "GPL";
 
-static volatile struct data {
+struct {
 	char in[256];
 	char out[256];
-} data;
+} data = {};
 
 struct core_reloc_kernel_output {
 	int valid[10];
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_misc.c b/tools/testing/selftests/bpf/progs/test_core_reloc_misc.c
index 1a36b0856653..292a5c4ee76a 100644
--- a/tools/testing/selftests/bpf/progs/test_core_reloc_misc.c
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_misc.c
@@ -8,10 +8,10 @@
 
 char _license[] SEC("license") = "GPL";
 
-static volatile struct data {
+struct {
 	char in[256];
 	char out[256];
-} data;
+} data = {};
 
 struct core_reloc_misc_output {
 	int a, b, c;
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_mods.c b/tools/testing/selftests/bpf/progs/test_core_reloc_mods.c
index 3199fafede2c..0b28bfacc8fd 100644
--- a/tools/testing/selftests/bpf/progs/test_core_reloc_mods.c
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_mods.c
@@ -8,10 +8,10 @@
 
 char _license[] SEC("license") = "GPL";
 
-static volatile struct data {
+struct {
 	char in[256];
 	char out[256];
-} data;
+} data = {};
 
 struct core_reloc_mods_output {
 	int a, b, c, d, e, f, g, h;
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_nesting.c b/tools/testing/selftests/bpf/progs/test_core_reloc_nesting.c
index 98238cb64fbd..39279bf0c9db 100644
--- a/tools/testing/selftests/bpf/progs/test_core_reloc_nesting.c
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_nesting.c
@@ -8,10 +8,10 @@
 
 char _license[] SEC("license") = "GPL";
 
-static volatile struct data {
+struct {
 	char in[256];
 	char out[256];
-} data;
+} data = {};
 
 struct core_reloc_nesting_substruct {
 	int a;
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_primitives.c b/tools/testing/selftests/bpf/progs/test_core_reloc_primitives.c
index 4f3ecb9127bb..ea57973cdd19 100644
--- a/tools/testing/selftests/bpf/progs/test_core_reloc_primitives.c
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_primitives.c
@@ -8,10 +8,10 @@
 
 char _license[] SEC("license") = "GPL";
 
-static volatile struct data {
+struct {
 	char in[256];
 	char out[256];
-} data;
+} data = {};
 
 enum core_reloc_primitives_enum {
 	A = 0,
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_ptr_as_arr.c b/tools/testing/selftests/bpf/progs/test_core_reloc_ptr_as_arr.c
index 27f602f00419..d1eb59d4ea64 100644
--- a/tools/testing/selftests/bpf/progs/test_core_reloc_ptr_as_arr.c
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_ptr_as_arr.c
@@ -8,10 +8,10 @@
 
 char _license[] SEC("license") = "GPL";
 
-static volatile struct data {
+struct {
 	char in[256];
 	char out[256];
-} data;
+} data = {};
 
 struct core_reloc_ptr_as_arr {
 	int a;
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_size.c b/tools/testing/selftests/bpf/progs/test_core_reloc_size.c
index 9a92998d9107..9e091124d3bd 100644
--- a/tools/testing/selftests/bpf/progs/test_core_reloc_size.c
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_size.c
@@ -8,10 +8,10 @@
 
 char _license[] SEC("license") = "GPL";
 
-static volatile struct data {
+struct {
 	char in[256];
 	char out[256];
-} data;
+} data = {};
 
 struct core_reloc_size_output {
 	int int_sz;
-- 
2.17.1

