Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF0C23E64B
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 05:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgHGDbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 23:31:09 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47370 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726038AbgHGDbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 23:31:09 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0773S6O0008601
        for <netdev@vger.kernel.org>; Thu, 6 Aug 2020 20:31:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=3jZJMPewx0JxZNRtokBU5E795eEura2mx2OWg38mnYg=;
 b=lQJf0bd5aiOEeBDY67kxzpDkbgjUKvt53CIz1NrX9CFEGEu1L9YBkhH6XyDh3+MaMC6z
 sj/He723jZZmppknvKxHFl8wOy4kE21TVgrS7MMGqtBu3nirUabvhiPD8d04FDPrKlqI
 qGvJHzGQ2rd84oogQe3hdxoOlwLxR8uAsM8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32qy47gkew-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 06 Aug 2020 20:31:08 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 6 Aug 2020 20:31:07 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id C603B2EC53DE; Thu,  6 Aug 2020 20:31:02 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] selftests/bpf: fix silent Makefile output
Date:   Thu, 6 Aug 2020 20:30:57 -0700
Message-ID: <20200807033058.848677-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-07_01:2020-08-06,2020-08-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 bulkscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0 spamscore=0
 suspectscore=9 mlxlogscore=999 malwarescore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008070025
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

99aacebecb75 ("selftests: do not use .ONESHELL") removed .ONESHELL, which
changes how Makefile "silences" multi-command target recipes. selftests/b=
pf's
Makefile relied (a somewhat unknowingly) on .ONESHELL behavior of silenci=
ng
all commands within the recipe if the first command contains @ symbol.
Removing .ONESHELL exposed this hack.

This patch fixes the issue by explicitly silencing each command with $(Q)=
.

Also explicitly define fallback rule for building *.o from *.c, instead o=
f
relying on non-silent inherited rule. This was causing a non-silent outpu=
t for
bench.o object file.

Fixes: 92f7440ecc93 ("selftests/bpf: More succinct Makefile output")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile | 48 +++++++++++++++-------------
 1 file changed, 26 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftes=
ts/bpf/Makefile
index 48425f9251b5..a83b5827532f 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -102,7 +102,7 @@ endif
 OVERRIDE_TARGETS :=3D 1
 override define CLEAN
 	$(call msg,CLEAN)
-	$(RM) -r $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES)=
 $(EXTRA_CLEAN)
+	$(Q)$(RM) -r $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FI=
LES) $(EXTRA_CLEAN)
 endef
=20
 include ../lib.mk
@@ -123,17 +123,21 @@ $(notdir $(TEST_GEN_PROGS)						\
 	 $(TEST_GEN_PROGS_EXTENDED)					\
 	 $(TEST_CUSTOM_PROGS)): %: $(OUTPUT)/% ;
=20
+$(OUTPUT)/%.o: %.c
+	$(call msg,CC,,$@)
+	$(Q)$(CC) $(CFLAGS) -c $(filter %.c,$^) $(LDLIBS) -o $@
+
 $(OUTPUT)/%:%.c
 	$(call msg,BINARY,,$@)
-	$(LINK.c) $^ $(LDLIBS) -o $@
+	$(Q)$(LINK.c) $^ $(LDLIBS) -o $@
=20
 $(OUTPUT)/urandom_read: urandom_read.c
 	$(call msg,BINARY,,$@)
-	$(CC) $(LDFLAGS) -o $@ $< $(LDLIBS) -Wl,--build-id
+	$(Q)$(CC) $(LDFLAGS) -o $@ $< $(LDLIBS) -Wl,--build-id
=20
 $(OUTPUT)/test_stub.o: test_stub.c $(BPFOBJ)
 	$(call msg,CC,,$@)
-	$(CC) -c $(CFLAGS) -o $@ $<
+	$(Q)$(CC) -c $(CFLAGS) -o $@ $<
=20
 VMLINUX_BTF_PATHS ?=3D $(if $(O),$(O)/vmlinux)				\
 		     $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)	\
@@ -181,15 +185,15 @@ $(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Ma=
kefile)		       \
=20
 $(BUILD_DIR)/libbpf $(BUILD_DIR)/bpftool $(BUILD_DIR)/resolve_btfids $(I=
NCLUDE_DIR):
 	$(call msg,MKDIR,,$@)
-	mkdir -p $@
+	$(Q)mkdir -p $@
=20
 $(INCLUDE_DIR)/vmlinux.h: $(VMLINUX_BTF) | $(BPFTOOL) $(INCLUDE_DIR)
 ifeq ($(VMLINUX_H),)
 	$(call msg,GEN,,$@)
-	$(BPFTOOL) btf dump file $(VMLINUX_BTF) format c > $@
+	$(Q)$(BPFTOOL) btf dump file $(VMLINUX_BTF) format c > $@
 else
 	$(call msg,CP,,$@)
-	cp "$(VMLINUX_H)" $@
+	$(Q)cp "$(VMLINUX_H)" $@
 endif
=20
 $(RESOLVE_BTFIDS): $(BPFOBJ) | $(BUILD_DIR)/resolve_btfids	\
@@ -238,28 +242,28 @@ $(OUTPUT)/flow_dissector_load.o: flow_dissector_loa=
d.h
 # $4 - LDFLAGS
 define CLANG_BPF_BUILD_RULE
 	$(call msg,CLNG-LLC,$(TRUNNER_BINARY),$2)
-	($(CLANG) $3 -O2 -target bpf -emit-llvm				\
+	$(Q)($(CLANG) $3 -O2 -target bpf -emit-llvm			\
 		-c $1 -o - || echo "BPF obj compilation failed") | 	\
 	$(LLC) -mattr=3Ddwarfris -march=3Dbpf -mcpu=3Dv3 $4 -filetype=3Dobj -o =
$2
 endef
 # Similar to CLANG_BPF_BUILD_RULE, but with disabled alu32
 define CLANG_NOALU32_BPF_BUILD_RULE
 	$(call msg,CLNG-LLC,$(TRUNNER_BINARY),$2)
-	($(CLANG) $3 -O2 -target bpf -emit-llvm				\
+	$(Q)($(CLANG) $3 -O2 -target bpf -emit-llvm			\
 		-c $1 -o - || echo "BPF obj compilation failed") | 	\
 	$(LLC) -march=3Dbpf -mcpu=3Dv2 $4 -filetype=3Dobj -o $2
 endef
 # Similar to CLANG_BPF_BUILD_RULE, but using native Clang and bpf LLC
 define CLANG_NATIVE_BPF_BUILD_RULE
 	$(call msg,CLNG-BPF,$(TRUNNER_BINARY),$2)
-	($(CLANG) $3 -O2 -emit-llvm					\
+	$(Q)($(CLANG) $3 -O2 -emit-llvm					\
 		-c $1 -o - || echo "BPF obj compilation failed") | 	\
 	$(LLC) -march=3Dbpf -mcpu=3Dv3 $4 -filetype=3Dobj -o $2
 endef
 # Build BPF object using GCC
 define GCC_BPF_BUILD_RULE
 	$(call msg,GCC-BPF,$(TRUNNER_BINARY),$2)
-	$(BPF_GCC) $3 $4 -O2 -c $1 -o $2
+	$(Q)$(BPF_GCC) $3 $4 -O2 -c $1 -o $2
 endef
=20
 SKEL_BLACKLIST :=3D btf__% test_pinning_invalid.c test_sk_assign.c
@@ -301,7 +305,7 @@ ifeq ($($(TRUNNER_OUTPUT)-dir),)
 $(TRUNNER_OUTPUT)-dir :=3D y
 $(TRUNNER_OUTPUT):
 	$$(call msg,MKDIR,,$$@)
-	mkdir -p $$@
+	$(Q)mkdir -p $$@
 endif
=20
 # ensure we set up BPF objects generation rule just once for a given
@@ -321,7 +325,7 @@ $(TRUNNER_BPF_SKELS): $(TRUNNER_OUTPUT)/%.skel.h:			\
 		      $(TRUNNER_OUTPUT)/%.o				\
 		      | $(BPFTOOL) $(TRUNNER_OUTPUT)
 	$$(call msg,GEN-SKEL,$(TRUNNER_BINARY),$$@)
-	$$(BPFTOOL) gen skeleton $$< > $$@
+	$(Q)$$(BPFTOOL) gen skeleton $$< > $$@
 endif
=20
 # ensure we set up tests.h header generation rule just once
@@ -345,7 +349,7 @@ $(TRUNNER_TEST_OBJS): $(TRUNNER_OUTPUT)/%.test.o:			\
 		      $(TRUNNER_BPF_SKELS)				\
 		      $$(BPFOBJ) | $(TRUNNER_OUTPUT)
 	$$(call msg,TEST-OBJ,$(TRUNNER_BINARY),$$@)
-	cd $$(@D) && $$(CC) -I. $$(CFLAGS) -c $(CURDIR)/$$< $$(LDLIBS) -o $$(@F=
)
+	$(Q)cd $$(@D) && $$(CC) -I. $$(CFLAGS) -c $(CURDIR)/$$< $$(LDLIBS) -o $=
$(@F)
=20
 $(TRUNNER_EXTRA_OBJS): $(TRUNNER_OUTPUT)/%.o:				\
 		       %.c						\
@@ -353,13 +357,13 @@ $(TRUNNER_EXTRA_OBJS): $(TRUNNER_OUTPUT)/%.o:				\
 		       $(TRUNNER_TESTS_HDR)				\
 		       $$(BPFOBJ) | $(TRUNNER_OUTPUT)
 	$$(call msg,EXT-OBJ,$(TRUNNER_BINARY),$$@)
-	$$(CC) $$(CFLAGS) -c $$< $$(LDLIBS) -o $$@
+	$(Q)$$(CC) $$(CFLAGS) -c $$< $$(LDLIBS) -o $$@
=20
 # only copy extra resources if in flavored build
 $(TRUNNER_BINARY)-extras: $(TRUNNER_EXTRA_FILES) | $(TRUNNER_OUTPUT)
 ifneq ($2,)
 	$$(call msg,EXT-COPY,$(TRUNNER_BINARY),$(TRUNNER_EXTRA_FILES))
-	cp -a $$^ $(TRUNNER_OUTPUT)/
+	$(Q)cp -a $$^ $(TRUNNER_OUTPUT)/
 endif
=20
 $(OUTPUT)/$(TRUNNER_BINARY): $(TRUNNER_TEST_OBJS)			\
@@ -367,8 +371,8 @@ $(OUTPUT)/$(TRUNNER_BINARY): $(TRUNNER_TEST_OBJS)			\
 			     $(RESOLVE_BTFIDS)				\
 			     | $(TRUNNER_BINARY)-extras
 	$$(call msg,BINARY,,$$@)
-	$$(CC) $$(CFLAGS) $$(filter %.a %.o,$$^) $$(LDLIBS) -o $$@
-	$(RESOLVE_BTFIDS) --no-fail --btf btf_data.o $$@
+	$(Q)$$(CC) $$(CFLAGS) $$(filter %.a %.o,$$^) $$(LDLIBS) -o $$@
+	$(Q)$(RESOLVE_BTFIDS) --no-fail --btf btf_data.o $$@
=20
 endef
=20
@@ -421,17 +425,17 @@ verifier/tests.h: verifier/*.c
 		) > verifier/tests.h)
 $(OUTPUT)/test_verifier: test_verifier.c verifier/tests.h $(BPFOBJ) | $(=
OUTPUT)
 	$(call msg,BINARY,,$@)
-	$(CC) $(CFLAGS) $(filter %.a %.o %.c,$^) $(LDLIBS) -o $@
+	$(Q)$(CC) $(CFLAGS) $(filter %.a %.o %.c,$^) $(LDLIBS) -o $@
=20
 # Make sure we are able to include and link libbpf against c++.
 $(OUTPUT)/test_cpp: test_cpp.cpp $(OUTPUT)/test_core_extern.skel.h $(BPF=
OBJ)
 	$(call msg,CXX,,$@)
-	$(CXX) $(CFLAGS) $^ $(LDLIBS) -o $@
+	$(Q)$(CXX) $(CFLAGS) $^ $(LDLIBS) -o $@
=20
 # Benchmark runner
 $(OUTPUT)/bench_%.o: benchs/bench_%.c bench.h
 	$(call msg,CC,,$@)
-	$(CC) $(CFLAGS) -c $(filter %.c,$^) $(LDLIBS) -o $@
+	$(Q)$(CC) $(CFLAGS) -c $(filter %.c,$^) $(LDLIBS) -o $@
 $(OUTPUT)/bench_rename.o: $(OUTPUT)/test_overhead.skel.h
 $(OUTPUT)/bench_trigger.o: $(OUTPUT)/trigger_bench.skel.h
 $(OUTPUT)/bench_ringbufs.o: $(OUTPUT)/ringbuf_bench.skel.h \
@@ -444,7 +448,7 @@ $(OUTPUT)/bench: $(OUTPUT)/bench.o $(OUTPUT)/testing_=
helpers.o \
 		 $(OUTPUT)/bench_trigger.o \
 		 $(OUTPUT)/bench_ringbufs.o
 	$(call msg,BINARY,,$@)
-	$(CC) $(LDFLAGS) -o $@ $(filter %.a %.o,$^) $(LDLIBS)
+	$(Q)$(CC) $(LDFLAGS) -o $@ $(filter %.a %.o,$^) $(LDLIBS)
=20
 EXTRA_CLEAN :=3D $(TEST_CUSTOM_PROGS) $(SCRATCH_DIR)			\
 	prog_tests/tests.h map_tests/tests.h verifier/tests.h		\
--=20
2.24.1

