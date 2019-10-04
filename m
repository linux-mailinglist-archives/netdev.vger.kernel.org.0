Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B33ECC600
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 00:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730770AbfJDWlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 18:41:12 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37210 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728767AbfJDWlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 18:41:12 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x94Mej9c028654
        for <netdev@vger.kernel.org>; Fri, 4 Oct 2019 15:41:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=6fu2NMQRFDvUUl/CUqhJrQTXyyrAVa46WH+4J/nqJy0=;
 b=Gw/AdKFqyXs/wrUesJwvGG2p6Qq6494O6ioadt3WZ99ixin6eHp7LGFPyNJK+5q+aBAz
 MgDc/Ffy8YuJSHRTi4GqhbiZFW00mLAk9JRoD30VTF3eBy9arKnz9+OP4OBrHPA66+vt
 kyYNSHoiyqetiwEsy5nkyq6Z0ceHYlEcJkU= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vdmh9ewn6-20
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 15:41:10 -0700
Received: from 2401:db00:12:909f:face:0:3:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 4 Oct 2019 15:40:50 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 876758617D0; Fri,  4 Oct 2019 15:40:47 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v3 bpf-next 4/4] selftests/bpf: switch tests to new bpf_object__open_{file,mem}() APIs
Date:   Fri, 4 Oct 2019 15:40:37 -0700
Message-ID: <20191004224037.1625049-5-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191004224037.1625049-1-andriin@fb.com>
References: <20191004224037.1625049-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-04_13:2019-10-03,2019-10-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 adultscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 bulkscore=0 phishscore=0 mlxscore=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910040191
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Verify new bpf_object__open_mem() and bpf_object__open_file() APIs work
as expected by switching test_attach_probe test to use embedded BPF
object and bpf_object__open_mem() and test_reference_tracking to
bpf_object__open_file().

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile          |  2 +-
 .../selftests/bpf/prog_tests/attach_probe.c   | 49 +++++++++++++++++--
 .../bpf/prog_tests/reference_tracking.c       | 16 +++++-
 3 files changed, 59 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 6889c19a628c..294d7472dad7 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -160,7 +160,7 @@ $(OUTPUT)/test_queue_map.o: test_queue_stack_map.h
 $(OUTPUT)/test_stack_map.o: test_queue_stack_map.h
 
 $(OUTPUT)/flow_dissector_load.o: flow_dissector_load.h
-$(OUTPUT)/test_progs.o: flow_dissector_load.h
+$(OUTPUT)/test_progs.o: flow_dissector_load.h $(OUTPUT)/test_attach_probe.o
 
 BTF_LLC_PROBE := $(shell $(LLC) -march=bpf -mattr=help 2>&1 | grep dwarfris)
 BTF_PAHOLE_PROBE := $(shell $(BTF_PAHOLE) --help 2>&1 | grep BTF)
diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
index 5ecc267d98b0..4f50d32c4abb 100644
--- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
+++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
@@ -1,6 +1,24 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <test_progs.h>
 
+#define EMBED_FILE(NAME, PATH)						    \
+asm (									    \
+"      .pushsection \".rodata\", \"a\", @progbits              \n"	    \
+"      .global "#NAME"_data                                    \n"	    \
+#NAME"_data:                                                   \n"	    \
+"      .incbin \"" PATH "\"                                    \n"	    \
+#NAME"_data_end:                                               \n"	    \
+"      .global "#NAME"_size                                    \n"	    \
+"      .type "#NAME"_size, @object                             \n"	    \
+"      .size "#NAME"_size, 4                                   \n"	    \
+"      .align 4,                                               \n"	    \
+#NAME"_size:                                                   \n"	    \
+"      .int "#NAME"_data_end - "#NAME"_data                    \n"	    \
+"      .popsection                                             \n"	    \
+);									    \
+extern char NAME##_data[];						    \
+extern int NAME##_size;
+
 ssize_t get_base_addr() {
 	size_t start;
 	char buf[256];
@@ -21,6 +39,8 @@ ssize_t get_base_addr() {
 	return -EINVAL;
 }
 
+EMBED_FILE(probe, "test_attach_probe.o");
+
 void test_attach_probe(void)
 {
 	const char *kprobe_name = "kprobe/sys_nanosleep";
@@ -29,11 +49,15 @@ void test_attach_probe(void)
 	const char *uretprobe_name = "uretprobe/trigger_func";
 	const int kprobe_idx = 0, kretprobe_idx = 1;
 	const int uprobe_idx = 2, uretprobe_idx = 3;
-	const char *file = "./test_attach_probe.o";
+	const char *obj_name = "attach_probe";
+	LIBBPF_OPTS(bpf_object_open_opts, open_opts,
+		.object_name = obj_name,
+		.relaxed_maps = true,
+	);
 	struct bpf_program *kprobe_prog, *kretprobe_prog;
 	struct bpf_program *uprobe_prog, *uretprobe_prog;
 	struct bpf_object *obj;
-	int err, prog_fd, duration = 0, res;
+	int err, duration = 0, res;
 	struct bpf_link *kprobe_link = NULL;
 	struct bpf_link *kretprobe_link = NULL;
 	struct bpf_link *uprobe_link = NULL;
@@ -48,11 +72,16 @@ void test_attach_probe(void)
 		return;
 	uprobe_offset = (size_t)&get_base_addr - base_addr;
 
-	/* load programs */
-	err = bpf_prog_load(file, BPF_PROG_TYPE_KPROBE, &obj, &prog_fd);
-	if (CHECK(err, "obj_load", "err %d errno %d\n", err, errno))
+	/* open object */
+	obj = bpf_object__open_mem(probe_data, probe_size, &open_opts);
+	if (CHECK(IS_ERR(obj), "obj_open_mem", "err %ld\n", PTR_ERR(obj)))
 		return;
 
+	if (CHECK(strcmp(bpf_object__name(obj), obj_name), "obj_name",
+		  "wrong obj name '%s', expected '%s'\n",
+		  bpf_object__name(obj), obj_name))
+		goto cleanup;
+
 	kprobe_prog = bpf_object__find_program_by_title(obj, kprobe_name);
 	if (CHECK(!kprobe_prog, "find_probe",
 		  "prog '%s' not found\n", kprobe_name))
@@ -70,6 +99,16 @@ void test_attach_probe(void)
 		  "prog '%s' not found\n", uretprobe_name))
 		goto cleanup;
 
+	bpf_program__set_kprobe(kprobe_prog);
+	bpf_program__set_kprobe(kretprobe_prog);
+	bpf_program__set_kprobe(uprobe_prog);
+	bpf_program__set_kprobe(uretprobe_prog);
+
+	/* create maps && load programs */
+	err = bpf_object__load(obj);
+	if (CHECK(err, "obj_load", "err %d\n", err))
+		goto cleanup;
+
 	/* load maps */
 	results_map_fd = bpf_find_map(__func__, obj, "results_map");
 	if (CHECK(results_map_fd < 0, "find_results_map",
diff --git a/tools/testing/selftests/bpf/prog_tests/reference_tracking.c b/tools/testing/selftests/bpf/prog_tests/reference_tracking.c
index 5c78e2b5a917..86cee820d4d3 100644
--- a/tools/testing/selftests/bpf/prog_tests/reference_tracking.c
+++ b/tools/testing/selftests/bpf/prog_tests/reference_tracking.c
@@ -3,16 +3,26 @@
 
 void test_reference_tracking(void)
 {
-	const char *file = "./test_sk_lookup_kern.o";
+	const char *file = "test_sk_lookup_kern.o";
+	const char *obj_name = "ref_track";
+	LIBBPF_OPTS(bpf_object_open_opts, open_opts,
+		.object_name = obj_name,
+		.relaxed_maps = true,
+	);
 	struct bpf_object *obj;
 	struct bpf_program *prog;
 	__u32 duration = 0;
 	int err = 0;
 
-	obj = bpf_object__open(file);
+	obj = bpf_object__open_file(file, &open_opts);
 	if (CHECK_FAIL(IS_ERR(obj)))
 		return;
 
+	if (CHECK(strcmp(bpf_object__name(obj), obj_name), "obj_name",
+		  "wrong obj name '%s', expected '%s'\n",
+		  bpf_object__name(obj), obj_name))
+		goto cleanup;
+
 	bpf_object__for_each_program(prog, obj) {
 		const char *title;
 
@@ -35,5 +45,7 @@ void test_reference_tracking(void)
 		}
 		CHECK(err, title, "\n");
 	}
+
+cleanup:
 	bpf_object__close(obj);
 }
-- 
2.17.1

