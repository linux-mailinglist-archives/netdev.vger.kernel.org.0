Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED5FD883B
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 07:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387801AbfJPFuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 01:50:13 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53734 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387605AbfJPFuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 01:50:08 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9G5o4aa016633
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 22:50:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=a07wVOiGf7dMy99G+J8erT67VO//Yuiya3E4T/eROO0=;
 b=JjklSRb/KHeQUBIz/Ci4FMSYwgUwryk4q6I3iD019z+KA8o9/U5OgHCzn4svLsfyASz+
 tofrZbbwRTNT22BAMJltG3zEbW+wmuSYPTodbRyeiIjOTtatgOgNGinPG4Dfo6Vt9vSo
 FahmlTgYLAXDsn/ON2Adrnn9yHxjgW15+5w= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vnf1wm21a-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 22:50:07 -0700
Received: from 2401:db00:12:9028:face:0:29:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 15 Oct 2019 22:50:00 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id CB11786193C; Tue, 15 Oct 2019 22:49:58 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v3 bpf-next 5/7] selftests/bpf: replace test_progs and test_maps w/ general rule
Date:   Tue, 15 Oct 2019 22:49:43 -0700
Message-ID: <20191016054945.1988387-6-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191016054945.1988387-1-andriin@fb.com>
References: <20191016054945.1988387-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_02:2019-10-15,2019-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 spamscore=0 clxscore=1015 malwarescore=0
 mlxlogscore=999 priorityscore=1501 suspectscore=9 phishscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910160054
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define test runner generation meta-rule that codifies dependencies
between test runner, its tests, and its dependent BPF programs. Use that
for defining test_progs and test_maps test-runners. Also additionally define
2 flavors of test_progs:
- alu32, which builds BPF programs with 32-bit registers codegen;
- bpf_gcc, which build BPF programs using GCC, if it supports BPF target.

Overall, this is accomplished through $(eval)'ing a set of generic
rules, which defines Makefile targets dynamically at runtime. See
comments explaining the need for 2 $(evals), though.

For each test runner we have (test_maps and test_progs, currently), and,
optionally, their flavors, the logic of build process is modeled as
follows (using test_progs as an example):
- all BPF objects are in progs/:
  - BPF object's .o file is built into output directory from
    corresponding progs/.c file;
  - all BPF objects in progs/*.c depend on all progs/*.h headers;
  - all BPF objects depend on bpf_*.h helpers from libbpf (but not
    libbpf archive). There is an extra rule to trigger bpf_helper_defs.h
    (re-)build, if it's not present/outdated);
  - build recipe for BPF object can be re-defined per test runner/flavor;
- test files are built from prog_tests/*.c:
  - all such test file objects are built on individual file basis;
  - currently, every single test file depends on all BPF object files;
    this might be improved in follow up patches to do 1-to-1 dependency,
    but allowing to customize this per each individual test;
  - each test runner definition can specify a list of extra .c and .h
    files to be built along test files and test runner binary; all such
    headers are becoming automatic dependency of each test .c file;
  - due to test files sometimes embedding (using .incbin assembly
    directive) contents of some BPF objects at compilation time, which are
    expected to be in CWD of compiler, compilation for test file object does
    cd into test runner's output directory; to support this mode all the
    include paths are turned into absolute paths using $(abspath) make
    function;
- prog_tests/test.h is automatically (re-)generated with an entry for
  each .c file in prog_tests/;
- final test runner binary is linked together from test object files and
  extra object files, linking together libbpf's archive as well;
- it's possible to specify extra "resource" files/targets, which will be
  copied into test runner output directory, if it differes from
  Makefile-wide $(OUTPUT). This is used to ensure btf_dump test cases and
  urandom_read binary is put into a test runner's CWD for tests to find
  them in runtime.

For flavored test runners, their output directory is a subdirectory of
common Makefile-wide $(OUTPUT) directory with flavor name used as
subdirectory name.

BPF objects targets might be reused between different test runners, so
extra checks are employed to not double-define them. Similarly, we have
redefinition guards for output directories and test headers.

test_verifier follows slightly different patterns and is simple enough
to not justify generalizing TEST_RUNNER_DEFINE/TEST_RUNNER_DEFINE_RULES
further to accomodate these differences. Instead, rules for
test_verifier are minimized and simplified, while preserving correctness
of dependencies.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/.gitignore |   5 +-
 tools/testing/selftests/bpf/Makefile   | 316 ++++++++++++++-----------
 2 files changed, 182 insertions(+), 139 deletions(-)

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 7470327edcfe..c51f356f84b5 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -7,7 +7,7 @@ FEATURE-DUMP.libbpf
 fixdep
 test_align
 test_dev_cgroup
-test_progs
+/test_progs*
 test_tcpbpf_user
 test_verifier_log
 feature
@@ -33,9 +33,10 @@ test_tcpnotify_user
 test_libbpf
 test_tcp_check_syncookie_user
 test_sysctl
-alu32
 libbpf.pc
 libbpf.so.*
 test_hashmap
 test_btf_dump
 xdping
+/alu32
+/bpf_gcc
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index fbced23935cc..54dff225b588 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -2,10 +2,12 @@
 include ../../../../scripts/Kbuild.include
 include ../../../scripts/Makefile.arch
 
-LIBDIR := ../../../lib
+CURDIR := $(abspath .)
+LIBDIR := $(abspath ../../../lib)
 BPFDIR := $(LIBDIR)/bpf
-APIDIR := ../../../include/uapi
-GENDIR := ../../../../include/generated
+TOOLSDIR := $(abspath ../../../include)
+APIDIR := $(TOOLSDIR)/uapi
+GENDIR := $(abspath ../../../../include/generated)
 GENHDR := $(GENDIR)/autoconf.h
 
 ifneq ($(wildcard $(GENHDR)),)
@@ -16,8 +18,9 @@ CLANG		?= clang
 LLC		?= llc
 LLVM_OBJCOPY	?= llvm-objcopy
 BPF_GCC		?= $(shell command -v bpf-gcc;)
-CFLAGS += -g -Wall -O2 -I$(APIDIR) -I$(LIBDIR) -I$(BPFDIR) -I$(GENDIR) $(GENFLAGS) -I../../../include \
-	  -Dbpf_prog_load=bpf_prog_test_load \
+CFLAGS += -g -Wall -O2 $(GENFLAGS) -I$(APIDIR) -I$(LIBDIR) -I$(BPFDIR)	\
+	  -I$(GENDIR) -I$(TOOLSDIR) -I$(CURDIR)				\
+	  -Dbpf_prog_load=bpf_prog_test_load				\
 	  -Dbpf_load_program=bpf_test_load_program
 LDLIBS += -lcap -lelf -lrt -lpthread
 
@@ -29,12 +32,6 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
 	test_cgroup_attach xdping
 
-BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
-TEST_GEN_FILES = $(BPF_OBJ_FILES)
-
-BTF_C_FILES = $(wildcard progs/btf_dump_test_case_*.c)
-TEST_FILES = $(BTF_C_FILES)
-
 # Also test sub-register code-gen if LLVM has eBPF v3 processor support which
 # contains both ALU32 and JMP32 instructions.
 SUBREG_CODEGEN := $(shell echo "int cal(int a) { return a > 0; }" | \
@@ -42,13 +39,17 @@ SUBREG_CODEGEN := $(shell echo "int cal(int a) { return a > 0; }" | \
 			$(LLC) -mattr=+alu32 -mcpu=v3 2>&1 | \
 			grep 'if w')
 ifneq ($(SUBREG_CODEGEN),)
-TEST_GEN_FILES += $(patsubst %.o,alu32/%.o, $(BPF_OBJ_FILES))
+TEST_GEN_PROGS += test_progs-alu32
 endif
 
+# Also test bpf-gcc, if present
 ifneq ($(BPF_GCC),)
-TEST_GEN_FILES += $(patsubst %.o,bpf_gcc/%.o, $(BPF_OBJ_FILES))
+TEST_GEN_PROGS += test_progs-bpf_gcc
 endif
 
+TEST_GEN_FILES =
+TEST_FILES =
+
 # Order correspond to 'make run_tests' order
 TEST_PROGS := test_kmod.sh \
 	test_libbpf.sh \
@@ -82,6 +83,8 @@ TEST_GEN_PROGS_EXTENDED = test_libbpf_open test_sock_addr test_skb_cgroup_id_use
 	flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
 	test_lirc_mode2_user
 
+TEST_CUSTOM_PROGS = urandom_read
+
 include ../lib.mk
 
 # Define simple and short `make test_progs`, `make test_sysctl`, etc targets
@@ -94,21 +97,12 @@ $(notdir $(TEST_GEN_PROGS)						\
 	 $(TEST_GEN_PROGS_EXTENDED)					\
 	 $(TEST_CUSTOM_PROGS)): %: $(OUTPUT)/% ;
 
-# NOTE: $(OUTPUT) won't get default value if used before lib.mk
-TEST_CUSTOM_PROGS = $(OUTPUT)/urandom_read
-all: $(TEST_CUSTOM_PROGS)
-
-$(OUTPUT)/urandom_read: $(OUTPUT)/%: %.c
+$(OUTPUT)/urandom_read: urandom_read.c
 	$(CC) -o $@ $< -Wl,--build-id
 
-$(OUTPUT)/test_stub.o: test_stub.c
-	$(CC) $(TEST_PROGS_CFLAGS) $(CFLAGS) -c -o $@ $<
-
 BPFOBJ := $(OUTPUT)/libbpf.a
 
-$(TEST_GEN_PROGS): $(OUTPUT)/test_stub.o $(BPFOBJ)
-
-$(TEST_GEN_PROGS_EXTENDED): $(OUTPUT)/test_stub.o $(OUTPUT)/libbpf.a
+$(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED): $(OUTPUT)/test_stub.o $(BPFOBJ)
 
 $(OUTPUT)/test_dev_cgroup: cgroup_helpers.c
 $(OUTPUT)/test_skb_cgroup_id_user: cgroup_helpers.c
@@ -118,7 +112,6 @@ $(OUTPUT)/test_socket_cookie: cgroup_helpers.c
 $(OUTPUT)/test_sockmap: cgroup_helpers.c
 $(OUTPUT)/test_tcpbpf_user: cgroup_helpers.c
 $(OUTPUT)/test_tcpnotify_user: cgroup_helpers.c trace_helpers.c
-$(OUTPUT)/test_progs: cgroup_helpers.c trace_helpers.c
 $(OUTPUT)/get_cgroup_id_user: cgroup_helpers.c
 $(OUTPUT)/test_cgroup_storage: cgroup_helpers.c
 $(OUTPUT)/test_netcnt: cgroup_helpers.c
@@ -134,6 +127,10 @@ force:
 $(BPFOBJ): force
 	$(MAKE) -C $(BPFDIR) OUTPUT=$(OUTPUT)/
 
+BPF_HELPERS := $(BPFDIR)/bpf_helper_defs.h $(wildcard $(BPFDIR)/bpf_*.h)
+$(BPFDIR)/bpf_helper_defs.h:
+	$(MAKE) -C $(BPFDIR) OUTPUT=$(OUTPUT)/ bpf_helper_defs.h
+
 # Get Clang's default includes on this system, as opposed to those seen by
 # '-target bpf'. This fixes "missing" files on some architectures/distros,
 # such as asm/byteorder.h, asm/socket.h, asm/sockios.h, sys/cdefs.h etc.
@@ -144,10 +141,11 @@ define get_sys_includes
 $(shell $(1) -v -E - </dev/null 2>&1 \
 	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }')
 endef
+
 CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
 BPF_CFLAGS = -g -D__TARGET_ARCH_$(SRCARCH) 				\
-	     -I. -I./include/uapi -I../../../include/uapi 		\
-	     -I$(BPFDIR) -I$(OUTPUT)/../usr/include
+	     -I. -I./include/uapi -I$(APIDIR)				\
+	     -I$(BPFDIR) -I$(abspath $(OUTPUT)/../usr/include)
 
 CLANG_CFLAGS = $(CLANG_SYS_INCLUDES) \
 	       -Wno-compare-distinct-pointer-types
@@ -159,127 +157,171 @@ $(OUTPUT)/test_queue_map.o: test_queue_stack_map.h
 $(OUTPUT)/test_stack_map.o: test_queue_stack_map.h
 
 $(OUTPUT)/flow_dissector_load.o: flow_dissector_load.h
-$(OUTPUT)/test_progs.o: flow_dissector_load.h
 
-TEST_PROGS_CFLAGS := -I. -I$(OUTPUT)
-TEST_MAPS_CFLAGS := -I. -I$(OUTPUT)
-TEST_VERIFIER_CFLAGS := -I. -I$(OUTPUT) -Iverifier
+# Build BPF object using Clang
+# $1 - input .c file
+# $2 - output .o file
+# $3 - CFLAGS
+# $4 - LDFLAGS
+define CLANG_BPF_BUILD_RULE
+	($(CLANG) $3 -O2 -target bpf -emit-llvm				\
+		-c $1 -o - || echo "BPF obj compilation failed") | 	\
+	$(LLC) -march=bpf -mcpu=probe $4 -filetype=obj -o $2
+endef
+# Similar to CLANG_BPF_BUILD_RULE, but using native Clang and bpf LLC
+define CLANG_NATIVE_BPF_BUILD_RULE
+	($(CLANG) $3 -O2 -emit-llvm					\
+		-c $1 -o - || echo "BPF obj compilation failed") | 	\
+	$(LLC) -march=bpf -mcpu=probe $4 -filetype=obj -o $2
+endef
+# Build BPF object using GCC
+define GCC_BPF_BUILD_RULE
+	$(BPF_GCC) $3 $4 -O2 -c $1 -o $2
+endef
+
+# Set up extra TRUNNER_XXX "temporary" variables in the environment (relies on
+# $eval()) and pass control to DEFINE_TEST_RUNNER_RULES.
+# Parameters:
+# $1 - test runner base binary name (e.g., test_progs)
+# $2 - test runner extra "flavor" (e.g., alu32, gcc-bpf, etc)
+define DEFINE_TEST_RUNNER
+
+TRUNNER_OUTPUT := $(OUTPUT)$(if $2,/)$2
+TRUNNER_BINARY := $1$(if $2,-)$2
+TRUNNER_TEST_OBJS := $$(patsubst %.c,$$(TRUNNER_OUTPUT)/%.test.o,	\
+				 $$(notdir $$(wildcard $(TRUNNER_TESTS_DIR)/*.c)))
+TRUNNER_EXTRA_OBJS := $$(patsubst %.c,$$(TRUNNER_OUTPUT)/%.o,		\
+				 $$(filter %.c,$(TRUNNER_EXTRA_SOURCES)))
+TRUNNER_EXTRA_HDRS := $$(filter %.h,$(TRUNNER_EXTRA_SOURCES))
+TRUNNER_TESTS_HDR := $(TRUNNER_TESTS_DIR)/tests.h
+TRUNNER_BPF_OBJS := $$(patsubst %.c,$$(TRUNNER_OUTPUT)/%.o,		\
+				$$(notdir $$(wildcard $(TRUNNER_BPF_PROGS_DIR)/*.c)))
+
+# Evaluate rules now with extra TRUNNER_XXX variables above already defined
+$$(eval $$(call DEFINE_TEST_RUNNER_RULES,$1,$2))
+
+endef
+
+# Using TRUNNER_XXX variables, provided by callers of DEFINE_TEST_RUNNER and
+# set up by DEFINE_TEST_RUNNER itself, create test runner build rules with:
+# $1 - test runner base binary name (e.g., test_progs)
+# $2 - test runner extra "flavor" (e.g., alu32, gcc-bpf, etc)
+define DEFINE_TEST_RUNNER_RULES
 
+ifeq ($($(TRUNNER_OUTPUT)-dir),)
+$(TRUNNER_OUTPUT)-dir := y
+$(TRUNNER_OUTPUT):
+	mkdir -p $$@
+endif
+
+# ensure we set up BPF objects generation rule just once for a given
+# input/output directory combination
+ifeq ($($(TRUNNER_BPF_PROGS_DIR)$(if $2,-)$2-bpfobjs),)
+$(TRUNNER_BPF_PROGS_DIR)$(if $2,-)$2-bpfobjs := y
+$(TRUNNER_BPF_OBJS): $(TRUNNER_OUTPUT)/%.o:				\
+		     $(TRUNNER_BPF_PROGS_DIR)/%.c			\
+		     $(TRUNNER_BPF_PROGS_DIR)/*.h			\
+		     $$(BPF_HELPERS) | $(TRUNNER_OUTPUT)
+	$$(call $(TRUNNER_BPF_BUILD_RULE),$$<,$$@,			\
+					  $(TRUNNER_BPF_CFLAGS),	\
+					  $(TRUNNER_BPF_LDFLAGS))
+endif
+
+# ensure we set up tests.h header generation rule just once
+ifeq ($($(TRUNNER_TESTS_DIR)-tests-hdr),)
+$(TRUNNER_TESTS_DIR)-tests-hdr := y
+$(TRUNNER_TESTS_HDR): $(TRUNNER_TESTS_DIR)/*.c
+	$$(shell ( cd $(TRUNNER_TESTS_DIR);				\
+		  echo '/* Generated header, do not edit */';		\
+		  ls *.c 2> /dev/null |					\
+			sed -e 's@\([^\.]*\)\.c@DEFINE_TEST(\1)@';	\
+		 ) > $$@)
+endif
+
+# compile individual test files
+# Note: we cd into output directory to ensure embedded BPF object is found
+$(TRUNNER_TEST_OBJS): $(TRUNNER_OUTPUT)/%.test.o:			\
+		      $(TRUNNER_TESTS_DIR)/%.c				\
+		      $(TRUNNER_EXTRA_HDRS)				\
+		      $(TRUNNER_BPF_OBJS)				\
+		      $$(BPFOBJ) | $(TRUNNER_OUTPUT)
+	cd $$(@D) && $$(CC) $$(CFLAGS) $$(LDLIBS) -c $(CURDIR)/$$< -o $$(@F)
+
+$(TRUNNER_EXTRA_OBJS): $(TRUNNER_OUTPUT)/%.o:				\
+		       %.c						\
+		       $(TRUNNER_EXTRA_HDRS)				\
+		       $(TRUNNER_TESTS_HDR)				\
+		       $$(BPFOBJ) | $(TRUNNER_OUTPUT)
+	$$(CC) $$(CFLAGS) $$(LDLIBS) -c $$< -o $$@
+
+$(TRUNNER_BINARY)-extras: $(TRUNNER_EXTRA_FILES) | $(TRUNNER_OUTPUT)
+ifneq ($2,)
+	# only copy extra resources if in flavored build
+	cp -a $$^ $(TRUNNER_OUTPUT)/
+endif
+
+$(OUTPUT)/$(TRUNNER_BINARY): $(TRUNNER_TEST_OBJS)			\
+			     $(TRUNNER_EXTRA_OBJS) $$(BPFOBJ)		\
+			     | $(TRUNNER_BINARY)-extras
+	$$(CC) $$(CFLAGS) $$(LDLIBS) $$(filter %.a %.o,$$^) -o $$@
+
+endef
+
+# Define test_progs test runner.
+TRUNNER_TESTS_DIR := prog_tests
+TRUNNER_BPF_PROGS_DIR := progs
+TRUNNER_EXTRA_SOURCES := test_progs.c cgroup_helpers.c trace_helpers.c	\
+			 flow_dissector_load.h
+TRUNNER_EXTRA_FILES := $(OUTPUT)/urandom_read				\
+		       $(wildcard progs/btf_dump_test_case_*.c)
+TRUNNER_BPF_BUILD_RULE := CLANG_BPF_BUILD_RULE
+TRUNNER_BPF_CFLAGS := -I. -I$(OUTPUT) $(BPF_CFLAGS) $(CLANG_CFLAGS)
+TRUNNER_BPF_LDFLAGS :=
+$(eval $(call DEFINE_TEST_RUNNER,test_progs))
+
+# Define test_progs-alu32 test runner.
 ifneq ($(SUBREG_CODEGEN),)
-ALU32_BUILD_DIR = $(OUTPUT)/alu32
-TEST_CUSTOM_PROGS += $(ALU32_BUILD_DIR)/test_progs_32
-$(ALU32_BUILD_DIR):
-	mkdir -p $@
-
-$(ALU32_BUILD_DIR)/urandom_read: $(OUTPUT)/urandom_read | $(ALU32_BUILD_DIR)
-	cp $< $@
-
-$(ALU32_BUILD_DIR)/test_progs_32: test_progs.c $(OUTPUT)/libbpf.a\
-						$(ALU32_BUILD_DIR)/urandom_read \
-						| $(ALU32_BUILD_DIR)
-	$(CC) $(TEST_PROGS_CFLAGS) $(CFLAGS) \
-		-o $(ALU32_BUILD_DIR)/test_progs_32 \
-		test_progs.c test_stub.c cgroup_helpers.c trace_helpers.c prog_tests/*.c \
-		$(OUTPUT)/libbpf.a $(LDLIBS)
-
-$(ALU32_BUILD_DIR)/test_progs_32: $(PROG_TESTS_H)
-$(ALU32_BUILD_DIR)/test_progs_32: prog_tests/*.c
-
-$(ALU32_BUILD_DIR)/%.o: progs/%.c $(ALU32_BUILD_DIR)/test_progs_32 \
-					| $(ALU32_BUILD_DIR)
-	($(CLANG) $(BPF_CFLAGS) $(CLANG_CFLAGS) -O2 -target bpf -emit-llvm \
-		-c $< -o - || echo "clang failed") | \
-	$(LLC) -march=bpf -mcpu=probe -mattr=+alu32 $(LLC_FLAGS) \
-		-filetype=obj -o $@
+TRUNNER_BPF_LDFLAGS += -mattr=+alu32
+$(eval $(call DEFINE_TEST_RUNNER,test_progs,alu32))
 endif
 
+# Define test_progs BPF-GCC-flavored test runner.
 ifneq ($(BPF_GCC),)
-GCC_SYS_INCLUDES = $(call get_sys_includes,gcc)
 IS_LITTLE_ENDIAN = $(shell $(CC) -dM -E - </dev/null | \
 			grep 'define __BYTE_ORDER__ __ORDER_LITTLE_ENDIAN__')
-ifeq ($(IS_LITTLE_ENDIAN),)
-MENDIAN=-mbig-endian
-else
-MENDIAN=-mlittle-endian
-endif
-BPF_GCC_CFLAGS = $(GCC_SYS_INCLUDES) $(MENDIAN)
-BPF_GCC_BUILD_DIR = $(OUTPUT)/bpf_gcc
-TEST_CUSTOM_PROGS += $(BPF_GCC_BUILD_DIR)/test_progs_bpf_gcc
-$(BPF_GCC_BUILD_DIR):
-	mkdir -p $@
-
-$(BPF_GCC_BUILD_DIR)/urandom_read: $(OUTPUT)/urandom_read | $(BPF_GCC_BUILD_DIR)
-	cp $< $@
-
-$(BPF_GCC_BUILD_DIR)/test_progs_bpf_gcc: $(OUTPUT)/test_progs \
-					 | $(BPF_GCC_BUILD_DIR)
-	cp $< $@
-
-$(BPF_GCC_BUILD_DIR)/%.o: progs/%.c $(BPF_GCC_BUILD_DIR)/test_progs_bpf_gcc \
-			  | $(BPF_GCC_BUILD_DIR)
-	$(BPF_GCC) $(BPF_CFLAGS) $(BPF_GCC_CFLAGS) -O2 -c $< -o $@
+MENDIAN=$(if $(IS_LITTLE_ENDIAN),-mlittle-endian,-mbig-endian)
+
+TRUNNER_BPF_BUILD_RULE := GCC_BPF_BUILD_RULE
+TRUNNER_BPF_CFLAGS := $(BPF_CFLAGS) $(call get_sys_includes,gcc) $(MENDIAN)
+TRUNNER_BPF_LDFLAGS :=
+$(eval $(call DEFINE_TEST_RUNNER,test_progs,bpf_gcc))
 endif
 
-# Have one program compiled without "-target bpf" to test whether libbpf loads
-# it successfully
-$(OUTPUT)/test_xdp.o: progs/test_xdp.c
-	($(CLANG) $(BPF_CFLAGS) $(CLANG_CFLAGS) -O2 -emit-llvm -c $< -o - || \
-		echo "clang failed") | \
-	$(LLC) -march=bpf -mcpu=probe $(LLC_FLAGS) -filetype=obj -o $@
-
-# libbpf has to be built before BPF programs due to bpf_helper_defs.h
-$(OUTPUT)/%.o: progs/%.c | $(BPFOBJ)
-	($(CLANG) $(BPF_CFLAGS) $(CLANG_CFLAGS) -O2 -target bpf -emit-llvm \
-		-c $< -o - || echo "clang failed") | \
-	$(LLC) -march=bpf -mcpu=probe $(LLC_FLAGS) -filetype=obj -o $@
-
-PROG_TESTS_DIR = $(OUTPUT)/prog_tests
-$(PROG_TESTS_DIR):
-	mkdir -p $@
-PROG_TESTS_H := $(PROG_TESTS_DIR)/tests.h
-PROG_TESTS_FILES := $(wildcard prog_tests/*.c)
-test_progs.c: $(PROG_TESTS_H)
-$(OUTPUT)/test_progs: CFLAGS += $(TEST_PROGS_CFLAGS)
-$(OUTPUT)/test_progs: test_progs.c $(PROG_TESTS_FILES) | $(OUTPUT)/test_attach_probe.o $(PROG_TESTS_H)
-$(PROG_TESTS_H): $(PROG_TESTS_FILES) | $(PROG_TESTS_DIR)
-	$(shell ( cd prog_tests/; \
-		  echo '/* Generated header, do not edit */'; \
-		  ls *.c 2> /dev/null | \
-			sed -e 's@\([^\.]*\)\.c@DEFINE_TEST(\1)@'; \
-		 ) > $(PROG_TESTS_H))
-
-MAP_TESTS_DIR = $(OUTPUT)/map_tests
-$(MAP_TESTS_DIR):
-	mkdir -p $@
-MAP_TESTS_H := $(MAP_TESTS_DIR)/tests.h
-MAP_TESTS_FILES := $(wildcard map_tests/*.c)
-test_maps.c: $(MAP_TESTS_H)
-$(OUTPUT)/test_maps: CFLAGS += $(TEST_MAPS_CFLAGS)
-$(OUTPUT)/test_maps: test_maps.c $(MAP_TESTS_FILES) | $(MAP_TESTS_H)
-$(MAP_TESTS_H): $(MAP_TESTS_FILES) | $(MAP_TESTS_DIR)
-	$(shell ( cd map_tests/; \
-		  echo '/* Generated header, do not edit */'; \
-		  ls *.c 2> /dev/null | \
-			sed -e 's@\([^\.]*\)\.c@DEFINE_TEST(\1)@'; \
-		 ) > $(MAP_TESTS_H))
-
-VERIFIER_TESTS_DIR = $(OUTPUT)/verifier
-$(VERIFIER_TESTS_DIR):
-	mkdir -p $@
-VERIFIER_TESTS_H := $(VERIFIER_TESTS_DIR)/tests.h
-VERIFIER_TEST_FILES := $(wildcard verifier/*.c)
-test_verifier.c: $(VERIFIER_TESTS_H)
-$(OUTPUT)/test_verifier: CFLAGS += $(TEST_VERIFIER_CFLAGS)
-$(OUTPUT)/test_verifier: test_verifier.c | $(VERIFIER_TEST_FILES) $(VERIFIER_TESTS_H)
-$(VERIFIER_TESTS_H): $(VERIFIER_TEST_FILES) | $(VERIFIER_TESTS_DIR)
+# Define test_maps test runner.
+TRUNNER_TESTS_DIR := map_tests
+TRUNNER_BPF_PROGS_DIR := progs
+TRUNNER_EXTRA_SOURCES := test_maps.c
+TRUNNER_EXTRA_FILES :=
+TRUNNER_BPF_BUILD_RULE := $$(error no BPF objects should be built)
+TRUNNER_BPF_CFLAGS :=
+TRUNNER_BPF_LDFLAGS :=
+$(eval $(call DEFINE_TEST_RUNNER,test_maps))
+
+# Define test_verifier test runner.
+# It is much simpler than test_maps/test_progs and sufficiently different from
+# them (e.g., test.h is using completely pattern), that it's worth just
+# explicitly defining all the rules explicitly.
+verifier/tests.h: verifier/*.c
 	$(shell ( cd verifier/; \
 		  echo '/* Generated header, do not edit */'; \
 		  echo '#ifdef FILL_ARRAY'; \
-		  ls *.c 2> /dev/null | \
-			sed -e 's@\(.*\)@#include \"\1\"@'; \
+		  ls *.c 2> /dev/null | sed -e 's@\(.*\)@#include \"\1\"@'; \
 		  echo '#endif' \
-		 ) > $(VERIFIER_TESTS_H))
-
-EXTRA_CLEAN := $(TEST_CUSTOM_PROGS) $(ALU32_BUILD_DIR) $(BPF_GCC_BUILD_DIR) \
-	$(VERIFIER_TESTS_H) $(PROG_TESTS_H) $(MAP_TESTS_H) \
-	feature
+		) > verifier/tests.h)
+$(OUTPUT)/test_verifier: test_verifier.c verifier/tests.h $(BPFOBJ) | $(OUTPUT)
+	$(CC) $(CFLAGS) $(LDLIBS) $(filter %.a %.o %.c,$^) -o $@
+
+EXTRA_CLEAN := $(TEST_CUSTOM_PROGS)					\
+	prog_tests/tests.h map_tests/tests.h verifier/tests.h		\
+	feature $(OUTPUT)/*.o $(OUTPUT)/alu32 $(OUTPUT)/bpf_gcc		\
+	$(OUTPUT)/native
-- 
2.17.1

