Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC0211824A2
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 23:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730198AbgCKWTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 18:19:17 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21198 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729848AbgCKWTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 18:19:17 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 02BMJF14005943
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 15:19:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=M2mWtnSJp1cw377nA2VrqYddzPNOE4+7dBPhMZv7wAk=;
 b=X60vT7NzH7JLZWb8zeJar5HRTAViwkKXGJZdTW6/whqZujU7JiSTnn2soW/2GbAVq8Nz
 PT9HJbTfoa0JRbpUKoCjvxJU9+p9kLwM1Xe3AlzX3iBxumaNuWNGBVeltPcXocgA4Y8D
 awfpAK4mufPpkRVmjYh3J0c0xuT2ETQtm3s= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2ypkv9dhum-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 15:19:15 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 11 Mar 2020 15:18:49 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id A9D6D62E2936; Wed, 11 Mar 2020 15:18:48 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <john.fastabend@gmail.com>, <quentin@isovalent.com>,
        <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <arnaldo.melo@gmail.com>, <jolsa@kernel.org>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 1/3] bpftool: only build bpftool-prog-profile if supported by clang
Date:   Wed, 11 Mar 2020 15:18:42 -0700
Message-ID: <20200311221844.3089820-2-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200311221844.3089820-1-songliubraving@fb.com>
References: <20200311221844.3089820-1-songliubraving@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-11_11:2020-03-11,2020-03-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 adultscore=0 clxscore=1015 phishscore=0 spamscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003110125
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpftoo-prog-profile requires clang to generate BTF for global variables.
When compared with older clang, skip this command. This is achieved by
adding a new feature, clang-bpf-global-var, to tools/build/feature.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 tools/bpf/bpftool/Makefile                      | 15 +++++++++++----
 tools/bpf/bpftool/prog.c                        |  2 ++
 tools/build/feature/Makefile                    |  9 ++++++++-
 tools/build/feature/test-clang-bpf-global-var.c |  4 ++++
 4 files changed, 25 insertions(+), 5 deletions(-)
 create mode 100644 tools/build/feature/test-clang-bpf-global-var.c

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 20a90d8450f8..0d9ede8e7340 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -62,8 +62,9 @@ RM ?= rm -f
 CLANG ?= clang
 
 FEATURE_USER = .bpftool
-FEATURE_TESTS = libbfd disassembler-four-args reallocarray zlib
-FEATURE_DISPLAY = libbfd disassembler-four-args zlib
+FEATURE_TESTS = libbfd disassembler-four-args reallocarray zlib \
+	clang-bpf-global-var
+FEATURE_DISPLAY = libbfd disassembler-four-args zlib clang-bpf-global-var
 
 check_feat := 1
 NON_CHECK_FEAT_TARGETS := clean uninstall doc doc-clean doc-install doc-uninstall
@@ -113,6 +114,12 @@ endif
 OBJS = $(patsubst %.c,$(OUTPUT)%.o,$(SRCS)) $(OUTPUT)disasm.o
 _OBJS = $(filter-out $(OUTPUT)prog.o,$(OBJS)) $(OUTPUT)_prog.o
 
+ifeq ($(feature-clang-bpf-global-var),1)
+	__OBJS = $(OBJS)
+else
+	__OBJS = $(_OBJS)
+endif
+
 $(OUTPUT)_prog.o: prog.c
 	$(QUIET_CC)$(COMPILE.c) -MMD -DBPFTOOL_WITHOUT_SKELETONS -o $@ $<
 
@@ -133,8 +140,8 @@ $(OUTPUT)disasm.o: $(srctree)/kernel/bpf/disasm.c
 
 $(OUTPUT)feature.o: | zdep
 
-$(OUTPUT)bpftool: $(OBJS) $(LIBBPF)
-	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)
+$(OUTPUT)bpftool: $(__OBJS) $(LIBBPF)
+	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(__OBJS) $(LIBS)
 
 $(OUTPUT)%.o: %.c
 	$(QUIET_CC)$(COMPILE.c) -MMD -o $@ $<
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 576ddd82bc96..03b1979dfad8 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1545,6 +1545,8 @@ static int do_loadall(int argc, char **argv)
 
 static int do_profile(int argc, char **argv)
 {
+	fprintf(stdout, "bpftool prog profile command is not supported.\n"
+		"Please build bpftool with clang >= 10.0.0\n");
 	return 0;
 }
 
diff --git a/tools/build/feature/Makefile b/tools/build/feature/Makefile
index 7ac0d8088565..ab8e89a7009c 100644
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -67,7 +67,8 @@ FILES=                                          \
          test-llvm.bin				\
          test-llvm-version.bin			\
          test-libaio.bin			\
-         test-libzstd.bin
+         test-libzstd.bin			\
+         test-clang-bpf-global-var.bin
 
 FILES := $(addprefix $(OUTPUT),$(FILES))
 
@@ -75,6 +76,7 @@ CC ?= $(CROSS_COMPILE)gcc
 CXX ?= $(CROSS_COMPILE)g++
 PKG_CONFIG ?= $(CROSS_COMPILE)pkg-config
 LLVM_CONFIG ?= llvm-config
+CLANG ?= clang
 
 all: $(FILES)
 
@@ -321,6 +323,11 @@ $(OUTPUT)test-libaio.bin:
 $(OUTPUT)test-libzstd.bin:
 	$(BUILD) -lzstd
 
+$(OUTPUT)test-clang-bpf-global-var.bin:
+	$(CLANG) -S -g -target bpf -o - $(patsubst %.bin,%.c,$(@F)) |	\
+		grep BTF_KIND_VAR
+
+
 ###############################
 
 clean:
diff --git a/tools/build/feature/test-clang-bpf-global-var.c b/tools/build/feature/test-clang-bpf-global-var.c
new file mode 100644
index 000000000000..221f1481d52e
--- /dev/null
+++ b/tools/build/feature/test-clang-bpf-global-var.c
@@ -0,0 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2020 Facebook
+
+volatile int global_value_for_test = 1;
-- 
2.17.1

