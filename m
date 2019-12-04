Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE6F112330
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 08:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbfLDHAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 02:00:55 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16084 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727318AbfLDHAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 02:00:53 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB470btJ026930
        for <netdev@vger.kernel.org>; Tue, 3 Dec 2019 23:00:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=KfFoRceG2BJLTNhA/Fd/ZRnTqeVDU39zHlUMfIj837s=;
 b=PxPV8jCbxLEXkthhcFY3hQQR8W6bYdrzSqpc5VJhlFcTKTBDABPDetiR4t5pYRnj/OnK
 8gn0s5WYXUMH+vR8s/4ZVf8T1eQtsiw4Wg5wMa9/xjQ4vPM2rAvL0P+hMKXDR8tIP72T
 F+ng0e0vVGkGtfvTiweTvstAaipGBeRsExE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wnsxpm7kh-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 23:00:52 -0800
Received: from 2401:db00:30:6012:face:0:17:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 3 Dec 2019 23:00:48 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 213092EC1853; Tue,  3 Dec 2019 23:00:47 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 13/16] selftests/bpf: add BPF skeletons selftests and convert attach_probe.c
Date:   Tue, 3 Dec 2019 23:00:12 -0800
Message-ID: <20191204070015.3523523-14-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191204070015.3523523-1-andriin@fb.com>
References: <20191204070015.3523523-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-04_01:2019-12-04,2019-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=2 impostorscore=0 bulkscore=0 phishscore=0 suspectscore=9
 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912040051
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add BPF skeleton generation to selftest/bpf's Makefile. Convert attach_probe.c
to use skeleton.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/.gitignore        |   2 +
 tools/testing/selftests/bpf/Makefile          |  36 +++--
 .../selftests/bpf/prog_tests/attach_probe.c   | 135 +++++-------------
 .../selftests/bpf/progs/test_attach_probe.c   |  34 ++---
 4 files changed, 74 insertions(+), 133 deletions(-)

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 4865116b96c7..649b2e585580 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -37,5 +37,7 @@ libbpf.so.*
 test_hashmap
 test_btf_dump
 xdping
+*.skel.h
 /no_alu32
 /bpf_gcc
+/tools
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 085678d88ef8..eeb312735e35 100644
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
 
@@ -319,4 +338,5 @@ $(OUTPUT)/test_verifier: test_verifier.c verifier/tests.h $(BPFOBJ) | $(OUTPUT)
 
 EXTRA_CLEAN := $(TEST_CUSTOM_PROGS)					\
 	prog_tests/tests.h map_tests/tests.h verifier/tests.h		\
-	feature $(OUTPUT)/*.o $(OUTPUT)/no_alu32 $(OUTPUT)/bpf_gcc
+	feature $(OUTPUT)/*.o $(OUTPUT)/no_alu32 $(OUTPUT)/bpf_gcc	\
+	tools
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

