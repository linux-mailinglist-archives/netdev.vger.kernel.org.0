Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEB211D292
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 17:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729997AbfLLQmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 11:42:16 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30894 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729899AbfLLQmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 11:42:14 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBCGXLu7006870
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 08:42:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=fFPuhT2cGv+f8l7JTgOsdl3qYT87TchSaw4fgLU/n84=;
 b=IlhdxtuxwZKizZyMyNUgH7000NeOJY38eISPC6LPDl4hLyj6cGDJSpfV2gWpBNvS0HsG
 oFDfJbyTrf6ImGsI32gpPki/bhFG2S0yJ80yTjaMW+WqwUjZrqn24j0EQ+3CESWM8MID
 sCZTpdzf0UdNjDuLsqmT0geU4ww74hblgHU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wu4ksd7mh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 08:42:12 -0800
Received: from intmgw001.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 12 Dec 2019 08:42:02 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id BC7D52EC1AD2; Thu, 12 Dec 2019 08:42:00 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 12/15] selftests/bpf: add BPF skeletons selftests and convert attach_probe.c
Date:   Thu, 12 Dec 2019 08:41:25 -0800
Message-ID: <20191212164129.494329-13-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191212164129.494329-1-andriin@fb.com>
References: <20191212164129.494329-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-12_04:2019-12-12,2019-12-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 suspectscore=9 adultscore=0 priorityscore=1501 spamscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912120129
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add BPF skeleton generation to selftest/bpf's Makefile. Convert attach_probe.c
to use skeleton.

Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/.gitignore        |   2 +
 tools/testing/selftests/bpf/Makefile          |  36 +++--
 .../selftests/bpf/prog_tests/attach_probe.c   | 135 +++++-------------
 .../selftests/bpf/progs/test_attach_probe.c   |  34 ++---
 4 files changed, 74 insertions(+), 133 deletions(-)

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 419652458da4..ce5af95ede42 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -38,5 +38,7 @@ test_hashmap
 test_btf_dump
 xdping
 test_cpp
+*.skel.h
 /no_alu32
 /bpf_gcc
+/tools
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index e0fe01d9ec33..01788c0d68dd 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -3,10 +3,12 @@ include ../../../../scripts/Kbuild.include
 include ../../../scripts/Makefile.arch
 
 CURDIR := $(abspath .)
-LIBDIR := $(abspath ../../../lib)
+TOOLSDIR := $(abspath ../../..)
+LIBDIR := $(TOOLSDIR)/lib
 BPFDIR := $(LIBDIR)/bpf
-TOOLSDIR := $(abspath ../../../include)
-APIDIR := $(TOOLSDIR)/uapi
+TOOLSINCDIR := $(TOOLSDIR)/include
+BPFTOOLDIR := $(TOOLSDIR)/bpf/bpftool
+APIDIR := $(TOOLSINCDIR)/uapi
 GENDIR := $(abspath ../../../../include/generated)
 GENHDR := $(GENDIR)/autoconf.h
 
@@ -19,7 +21,7 @@ LLC		?= llc
 LLVM_OBJCOPY	?= llvm-objcopy
 BPF_GCC		?= $(shell command -v bpf-gcc;)
 CFLAGS += -g -Wall -O2 $(GENFLAGS) -I$(APIDIR) -I$(LIBDIR) -I$(BPFDIR)	\
-	  -I$(GENDIR) -I$(TOOLSDIR) -I$(CURDIR)				\
+	  -I$(GENDIR) -I$(TOOLSINCDIR) -I$(CURDIR)			\
 	  -Dbpf_prog_load=bpf_prog_test_load				\
 	  -Dbpf_load_program=bpf_test_load_program
 LDLIBS += -lcap -lelf -lrt -lpthread
@@ -117,6 +119,12 @@ $(OUTPUT)/test_cgroup_attach: cgroup_helpers.c
 # force a rebuild of BPFOBJ when its dependencies are updated
 force:
 
+DEFAULT_BPFTOOL := $(OUTPUT)/tools/usr/local/sbin/bpftool
+BPFTOOL ?= $(DEFAULT_BPFTOOL)
+
+$(DEFAULT_BPFTOOL): force
+	$(MAKE) -C $(BPFTOOLDIR) DESTDIR=$(OUTPUT)/tools install
+
 $(BPFOBJ): force
 	$(MAKE) -C $(BPFDIR) OUTPUT=$(OUTPUT)/
 
@@ -180,6 +188,8 @@ define GCC_BPF_BUILD_RULE
 	$(BPF_GCC) $3 $4 -O2 -c $1 -o $2
 endef
 
+SKEL_BLACKLIST := btf__% test_pinning_invalid.c
+
 # Set up extra TRUNNER_XXX "temporary" variables in the environment (relies on
 # $eval()) and pass control to DEFINE_TEST_RUNNER_RULES.
 # Parameters:
@@ -195,8 +205,11 @@ TRUNNER_EXTRA_OBJS := $$(patsubst %.c,$$(TRUNNER_OUTPUT)/%.o,		\
 				 $$(filter %.c,$(TRUNNER_EXTRA_SOURCES)))
 TRUNNER_EXTRA_HDRS := $$(filter %.h,$(TRUNNER_EXTRA_SOURCES))
 TRUNNER_TESTS_HDR := $(TRUNNER_TESTS_DIR)/tests.h
-TRUNNER_BPF_OBJS := $$(patsubst %.c,$$(TRUNNER_OUTPUT)/%.o,		\
-				$$(notdir $$(wildcard $(TRUNNER_BPF_PROGS_DIR)/*.c)))
+TRUNNER_BPF_SRCS := $$(notdir $$(wildcard $(TRUNNER_BPF_PROGS_DIR)/*.c))
+TRUNNER_BPF_OBJS := $$(patsubst %.c,$$(TRUNNER_OUTPUT)/%.o, $$(TRUNNER_BPF_SRCS))
+TRUNNER_BPF_SKELS := $$(patsubst %.c,$$(TRUNNER_OUTPUT)/%.skel.h,	\
+				 $$(filter-out $(SKEL_BLACKLIST),	\
+					       $$(TRUNNER_BPF_SRCS)))
 
 # Evaluate rules now with extra TRUNNER_XXX variables above already defined
 $$(eval $$(call DEFINE_TEST_RUNNER_RULES,$1,$2))
@@ -226,6 +239,11 @@ $(TRUNNER_BPF_OBJS): $(TRUNNER_OUTPUT)/%.o:				\
 	$$(call $(TRUNNER_BPF_BUILD_RULE),$$<,$$@,			\
 					  $(TRUNNER_BPF_CFLAGS),	\
 					  $(TRUNNER_BPF_LDFLAGS))
+
+$(TRUNNER_BPF_SKELS): $(TRUNNER_OUTPUT)/%.skel.h:			\
+		      $(TRUNNER_OUTPUT)/%.o				\
+		      | $(BPFTOOL) $(TRUNNER_OUTPUT)
+	$$(BPFTOOL) gen skeleton $$< > $$@
 endif
 
 # ensure we set up tests.h header generation rule just once
@@ -245,6 +263,7 @@ $(TRUNNER_TEST_OBJS): $(TRUNNER_OUTPUT)/%.test.o:			\
 		      $(TRUNNER_TESTS_DIR)/%.c				\
 		      $(TRUNNER_EXTRA_HDRS)				\
 		      $(TRUNNER_BPF_OBJS)				\
+		      $(TRUNNER_BPF_SKELS)				\
 		      $$(BPFOBJ) | $(TRUNNER_OUTPUT)
 	cd $$(@D) && $$(CC) $$(CFLAGS) -c $(CURDIR)/$$< $$(LDLIBS) -o $$(@F)
 
@@ -255,9 +274,9 @@ $(TRUNNER_EXTRA_OBJS): $(TRUNNER_OUTPUT)/%.o:				\
 		       $$(BPFOBJ) | $(TRUNNER_OUTPUT)
 	$$(CC) $$(CFLAGS) -c $$< $$(LDLIBS) -o $$@
 
+# only copy extra resources if in flavored build
 $(TRUNNER_BINARY)-extras: $(TRUNNER_EXTRA_FILES) | $(TRUNNER_OUTPUT)
 ifneq ($2,)
-	# only copy extra resources if in flavored build
 	cp -a $$^ $(TRUNNER_OUTPUT)/
 endif
 
@@ -323,4 +342,5 @@ $(OUTPUT)/test_cpp: test_cpp.cpp $(BPFOBJ)
 
 EXTRA_CLEAN := $(TEST_CUSTOM_PROGS)					\
 	prog_tests/tests.h map_tests/tests.h verifier/tests.h		\
-	feature $(OUTPUT)/*.o $(OUTPUT)/no_alu32 $(OUTPUT)/bpf_gcc
+	feature $(OUTPUT)/*.o $(OUTPUT)/no_alu32 $(OUTPUT)/bpf_gcc	\
+	tools *.skel.h
diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
index b2e7c1424b07..60da1d08daa0 100644
--- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
+++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <test_progs.h>
+#include "test_attach_probe.skel.h"
 
 ssize_t get_base_addr() {
 	size_t start;
@@ -25,26 +26,10 @@ BPF_EMBED_OBJ(probe, "test_attach_probe.o");
 
 void test_attach_probe(void)
 {
-	const char *kprobe_name = "kprobe/sys_nanosleep";
-	const char *kretprobe_name = "kretprobe/sys_nanosleep";
-	const char *uprobe_name = "uprobe/trigger_func";
-	const char *uretprobe_name = "uretprobe/trigger_func";
-	const int kprobe_idx = 0, kretprobe_idx = 1;
-	const int uprobe_idx = 2, uretprobe_idx = 3;
-	const char *obj_name = "attach_probe";
-	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, open_opts,
-		.object_name = obj_name,
-		.relaxed_maps = true,
-	);
-	struct bpf_program *kprobe_prog, *kretprobe_prog;
-	struct bpf_program *uprobe_prog, *uretprobe_prog;
-	struct bpf_object *obj;
-	int err, duration = 0, res;
-	struct bpf_link *kprobe_link = NULL;
-	struct bpf_link *kretprobe_link = NULL;
-	struct bpf_link *uprobe_link = NULL;
-	struct bpf_link *uretprobe_link = NULL;
-	int results_map_fd;
+	int duration = 0;
+	struct bpf_link *kprobe_link, *kretprobe_link;
+	struct bpf_link *uprobe_link, *uretprobe_link;
+	struct test_attach_probe* skel;
 	size_t uprobe_offset;
 	ssize_t base_addr;
 
@@ -54,124 +39,68 @@ void test_attach_probe(void)
 		return;
 	uprobe_offset = (size_t)&get_base_addr - base_addr;
 
-	/* open object */
-	obj = bpf_object__open_mem(probe_embed.data, probe_embed.size,
-				   &open_opts);
-	if (CHECK(IS_ERR(obj), "obj_open_mem", "err %ld\n", PTR_ERR(obj)))
+	skel = test_attach_probe__open_and_load(&probe_embed);
+	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
 		return;
-
-	if (CHECK(strcmp(bpf_object__name(obj), obj_name), "obj_name",
-		  "wrong obj name '%s', expected '%s'\n",
-		  bpf_object__name(obj), obj_name))
-		goto cleanup;
-
-	kprobe_prog = bpf_object__find_program_by_title(obj, kprobe_name);
-	if (CHECK(!kprobe_prog, "find_probe",
-		  "prog '%s' not found\n", kprobe_name))
-		goto cleanup;
-	kretprobe_prog = bpf_object__find_program_by_title(obj, kretprobe_name);
-	if (CHECK(!kretprobe_prog, "find_probe",
-		  "prog '%s' not found\n", kretprobe_name))
-		goto cleanup;
-	uprobe_prog = bpf_object__find_program_by_title(obj, uprobe_name);
-	if (CHECK(!uprobe_prog, "find_probe",
-		  "prog '%s' not found\n", uprobe_name))
-		goto cleanup;
-	uretprobe_prog = bpf_object__find_program_by_title(obj, uretprobe_name);
-	if (CHECK(!uretprobe_prog, "find_probe",
-		  "prog '%s' not found\n", uretprobe_name))
+	if (CHECK(!skel->bss, "check_bss", ".bss wasn't mmap()-ed\n"))
 		goto cleanup;
 
-	/* create maps && load programs */
-	err = bpf_object__load(obj);
-	if (CHECK(err, "obj_load", "err %d\n", err))
-		goto cleanup;
-
-	/* load maps */
-	results_map_fd = bpf_find_map(__func__, obj, "results_map");
-	if (CHECK(results_map_fd < 0, "find_results_map",
-		  "err %d\n", results_map_fd))
-		goto cleanup;
-
-	kprobe_link = bpf_program__attach_kprobe(kprobe_prog,
+	kprobe_link = bpf_program__attach_kprobe(skel->progs.handle_kprobe,
 						 false /* retprobe */,
 						 SYS_NANOSLEEP_KPROBE_NAME);
 	if (CHECK(IS_ERR(kprobe_link), "attach_kprobe",
-		  "err %ld\n", PTR_ERR(kprobe_link))) {
-		kprobe_link = NULL;
+		  "err %ld\n", PTR_ERR(kprobe_link)))
 		goto cleanup;
-	}
-	kretprobe_link = bpf_program__attach_kprobe(kretprobe_prog,
+	skel->links.handle_kprobe = kprobe_link;
+
+	kretprobe_link = bpf_program__attach_kprobe(skel->progs.handle_kretprobe,
 						    true /* retprobe */,
 						    SYS_NANOSLEEP_KPROBE_NAME);
 	if (CHECK(IS_ERR(kretprobe_link), "attach_kretprobe",
-		  "err %ld\n", PTR_ERR(kretprobe_link))) {
-		kretprobe_link = NULL;
+		  "err %ld\n", PTR_ERR(kretprobe_link)))
 		goto cleanup;
-	}
-	uprobe_link = bpf_program__attach_uprobe(uprobe_prog,
+	skel->links.handle_kretprobe = kretprobe_link;
+
+	uprobe_link = bpf_program__attach_uprobe(skel->progs.handle_uprobe,
 						 false /* retprobe */,
 						 0 /* self pid */,
 						 "/proc/self/exe",
 						 uprobe_offset);
 	if (CHECK(IS_ERR(uprobe_link), "attach_uprobe",
-		  "err %ld\n", PTR_ERR(uprobe_link))) {
-		uprobe_link = NULL;
+		  "err %ld\n", PTR_ERR(uprobe_link)))
 		goto cleanup;
-	}
-	uretprobe_link = bpf_program__attach_uprobe(uretprobe_prog,
+	skel->links.handle_uprobe = uprobe_link;
+
+	uretprobe_link = bpf_program__attach_uprobe(skel->progs.handle_uretprobe,
 						    true /* retprobe */,
 						    -1 /* any pid */,
 						    "/proc/self/exe",
 						    uprobe_offset);
 	if (CHECK(IS_ERR(uretprobe_link), "attach_uretprobe",
-		  "err %ld\n", PTR_ERR(uretprobe_link))) {
-		uretprobe_link = NULL;
+		  "err %ld\n", PTR_ERR(uretprobe_link)))
 		goto cleanup;
-	}
+	skel->links.handle_uretprobe = uretprobe_link;
 
 	/* trigger & validate kprobe && kretprobe */
 	usleep(1);
 
-	err = bpf_map_lookup_elem(results_map_fd, &kprobe_idx, &res);
-	if (CHECK(err, "get_kprobe_res",
-		  "failed to get kprobe res: %d\n", err))
+	if (CHECK(skel->bss->kprobe_res != 1, "check_kprobe_res",
+		  "wrong kprobe res: %d\n", skel->bss->kprobe_res))
 		goto cleanup;
-	if (CHECK(res != kprobe_idx + 1, "check_kprobe_res",
-		  "wrong kprobe res: %d\n", res))
-		goto cleanup;
-
-	err = bpf_map_lookup_elem(results_map_fd, &kretprobe_idx, &res);
-	if (CHECK(err, "get_kretprobe_res",
-		  "failed to get kretprobe res: %d\n", err))
-		goto cleanup;
-	if (CHECK(res != kretprobe_idx + 1, "check_kretprobe_res",
-		  "wrong kretprobe res: %d\n", res))
+	if (CHECK(skel->bss->kretprobe_res != 2, "check_kretprobe_res",
+		  "wrong kretprobe res: %d\n", skel->bss->kretprobe_res))
 		goto cleanup;
 
 	/* trigger & validate uprobe & uretprobe */
 	get_base_addr();
 
-	err = bpf_map_lookup_elem(results_map_fd, &uprobe_idx, &res);
-	if (CHECK(err, "get_uprobe_res",
-		  "failed to get uprobe res: %d\n", err))
-		goto cleanup;
-	if (CHECK(res != uprobe_idx + 1, "check_uprobe_res",
-		  "wrong uprobe res: %d\n", res))
-		goto cleanup;
-
-	err = bpf_map_lookup_elem(results_map_fd, &uretprobe_idx, &res);
-	if (CHECK(err, "get_uretprobe_res",
-		  "failed to get uretprobe res: %d\n", err))
+	if (CHECK(skel->bss->uprobe_res != 3, "check_uprobe_res",
+		  "wrong uprobe res: %d\n", skel->bss->uprobe_res))
 		goto cleanup;
-	if (CHECK(res != uretprobe_idx + 1, "check_uretprobe_res",
-		  "wrong uretprobe res: %d\n", res))
+	if (CHECK(skel->bss->uretprobe_res != 4, "check_uretprobe_res",
+		  "wrong uretprobe res: %d\n", skel->bss->uretprobe_res))
 		goto cleanup;
 
 cleanup:
-	bpf_link__destroy(kprobe_link);
-	bpf_link__destroy(kretprobe_link);
-	bpf_link__destroy(uprobe_link);
-	bpf_link__destroy(uretprobe_link);
-	bpf_object__close(obj);
+	test_attach_probe__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_attach_probe.c b/tools/testing/selftests/bpf/progs/test_attach_probe.c
index 534621e38906..221b69700625 100644
--- a/tools/testing/selftests/bpf/progs/test_attach_probe.c
+++ b/tools/testing/selftests/bpf/progs/test_attach_probe.c
@@ -5,46 +5,36 @@
 #include <linux/bpf.h>
 #include "bpf_helpers.h"
 
-struct {
-	__uint(type, BPF_MAP_TYPE_ARRAY);
-	__uint(max_entries, 4);
-	__type(key, int);
-	__type(value, int);
-} results_map SEC(".maps");
+int kprobe_res = 0;
+int kretprobe_res = 0;
+int uprobe_res = 0;
+int uretprobe_res = 0;
 
 SEC("kprobe/sys_nanosleep")
-int handle_sys_nanosleep_entry(struct pt_regs *ctx)
+int handle_kprobe(struct pt_regs *ctx)
 {
-	const int key = 0, value = 1;
-
-	bpf_map_update_elem(&results_map, &key, &value, 0);
+	kprobe_res = 1;
 	return 0;
 }
 
 SEC("kretprobe/sys_nanosleep")
-int handle_sys_getpid_return(struct pt_regs *ctx)
+int handle_kretprobe(struct pt_regs *ctx)
 {
-	const int key = 1, value = 2;
-
-	bpf_map_update_elem(&results_map, &key, &value, 0);
+	kretprobe_res = 2;
 	return 0;
 }
 
 SEC("uprobe/trigger_func")
-int handle_uprobe_entry(struct pt_regs *ctx)
+int handle_uprobe(struct pt_regs *ctx)
 {
-	const int key = 2, value = 3;
-
-	bpf_map_update_elem(&results_map, &key, &value, 0);
+	uprobe_res = 3;
 	return 0;
 }
 
 SEC("uretprobe/trigger_func")
-int handle_uprobe_return(struct pt_regs *ctx)
+int handle_uretprobe(struct pt_regs *ctx)
 {
-	const int key = 3, value = 4;
-
-	bpf_map_update_elem(&results_map, &key, &value, 0);
+	uretprobe_res = 4;
 	return 0;
 }
 
-- 
2.17.1

