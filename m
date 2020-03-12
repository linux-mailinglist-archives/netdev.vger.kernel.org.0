Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8FD183885
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 19:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgCLSYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 14:24:02 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48738 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726328AbgCLSYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 14:24:02 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02CIGYeD020495
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 11:24:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=/tBS5KiO8m1SQYSknSY7CYG5S+7N9Ztm7wo3NK861uw=;
 b=qwZ4QNeS+nVqe2YjY5LAFDTHZobLOWCoNCdGpONHpvb7ntu+vaMh98vS4vAjtV5EtPY7
 9aOdzwppSgpTbFyEFJWJICLfe/5BpUBkdGm1njz1BxWtTBT5Bpxwv+TrbZjhEje8Baxu
 HjZVS2M9rByrDrTqi6YnV1jYtXaV+k2efgc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yqt7fg190-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 11:24:00 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 12 Mar 2020 11:23:44 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 51EA662E0874; Thu, 12 Mar 2020 11:23:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <john.fastabend@gmail.com>, <quentin@isovalent.com>,
        <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <arnaldo.melo@gmail.com>, <jolsa@kernel.org>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 1/3] bpftool: only build bpftool-prog-profile if supported by clang
Date:   Thu, 12 Mar 2020 11:23:30 -0700
Message-ID: <20200312182332.3953408-2-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200312182332.3953408-1-songliubraving@fb.com>
References: <20200312182332.3953408-1-songliubraving@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-12_12:2020-03-11,2020-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 adultscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 impostorscore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003120093
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpftool-prog-profile requires clang to generate BTF for global variables.
When compared with older clang, skip this command. This is achieved by
adding a new feature, clang-bpf-global-var, to tools/build/feature.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 tools/bpf/bpftool/Makefile                      | 15 +++++++++++----
 tools/bpf/bpftool/prog.c                        |  1 +
 tools/build/feature/Makefile                    |  9 ++++++++-
 tools/build/feature/test-clang-bpf-global-var.c |  4 ++++
 4 files changed, 24 insertions(+), 5 deletions(-)
 create mode 100644 tools/build/feature/test-clang-bpf-global-var.c

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index f294f6c1e795..b0574751f231 100644
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
 
@@ -136,8 +143,8 @@ $(OUTPUT)disasm.o: $(srctree)/kernel/bpf/disasm.c
 
 $(OUTPUT)feature.o: | zdep
 
-$(OUTPUT)bpftool: $(OBJS) $(LIBBPF)
-	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)
+$(OUTPUT)bpftool: $(__OBJS) $(LIBBPF)
+	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(__OBJS) $(LIBS)
 
 $(OUTPUT)%.o: %.c
 	$(QUIET_CC)$(COMPILE.c) -MMD -o $@ $<
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 576ddd82bc96..925c6c66aad7 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1545,6 +1545,7 @@ static int do_loadall(int argc, char **argv)
 
 static int do_profile(int argc, char **argv)
 {
+	p_err("bpftool prog profile command is not supported. Please build bpftool with clang >= 10.0.0");
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

