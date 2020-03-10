Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC67E1806E4
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 19:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbgCJSgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 14:36:35 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51476 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727020AbgCJSge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 14:36:34 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02AIWrET024706
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 11:36:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=dvvzqHIo0UsE30wHzutqkvcRqJq4ctQTBNl3MHmLbPo=;
 b=p4jdVv2bpP/nY7bd0vO2PoZffahMo2ENnSALEIDwpIS+A/Bw+zeGhZV4Lb+xgrUAZOEN
 MKY6lQO3Exei//nvu/8ah3Sgg1ZD+r0NOrxgFLD75/UQsKT8U47JnKWUMCfjsyOClOWr
 w/aNAMcXwJP/2uZ00R2mkew0iKeiZ7eIMoM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yp25fm4n0-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 11:36:33 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 10 Mar 2020 11:36:31 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id A7B6E62E28D2; Tue, 10 Mar 2020 11:36:27 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <quentin@isovalent.com>, <kernel-team@fb.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <arnaldo.melo@gmail.com>,
        <jolsa@kernel.org>, Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/2] bpftool: only build bpftool-prog-profile with clang >= v11
Date:   Tue, 10 Mar 2020 11:36:22 -0700
Message-ID: <20200310183624.441788-2-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200310183624.441788-1-songliubraving@fb.com>
References: <20200310183624.441788-1-songliubraving@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-10_12:2020-03-10,2020-03-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 phishscore=0 malwarescore=0 suspectscore=0 clxscore=1015 spamscore=0
 mlxscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003100110
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpftool-prog-profile requires clang of version 11.0.0 or newer. If
bpftool is built with older clang, show a hint of to the user.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 tools/bpf/bpftool/Makefile | 13 +++++++++++--
 tools/bpf/bpftool/prog.c   |  2 ++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 20a90d8450f8..05a37f0f76a9 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -60,6 +60,15 @@ LIBS = $(LIBBPF) -lelf -lz
 INSTALL ?= install
 RM ?= rm -f
 CLANG ?= clang
+CLANG_VERS = $(shell $(CLANG) --version | head -n 1 | awk '{print $$3}')
+CLANG_MAJ = $(shell echo $(CLANG_VERS) | cut -d '.' -f 1)
+WITHOUT_SKELETONS = -DBPFTOOL_WITHOUT_SKELETONS
+
+ifeq ($(shell test $(CLANG_MAJ) -ge 11; echo $$?),0)
+	PROG_FLAGS =
+else
+	PROG_FLAGS = $(WITHOUT_SKELETONS)
+endif
 
 FEATURE_USER = .bpftool
 FEATURE_TESTS = libbfd disassembler-four-args reallocarray zlib
@@ -114,7 +123,7 @@ OBJS = $(patsubst %.c,$(OUTPUT)%.o,$(SRCS)) $(OUTPUT)disasm.o
 _OBJS = $(filter-out $(OUTPUT)prog.o,$(OBJS)) $(OUTPUT)_prog.o
 
 $(OUTPUT)_prog.o: prog.c
-	$(QUIET_CC)$(COMPILE.c) -MMD -DBPFTOOL_WITHOUT_SKELETONS -o $@ $<
+	$(QUIET_CC)$(COMPILE.c) -MMD $(WITHOUT_SKELETONS) -o $@ $<
 
 $(OUTPUT)_bpftool: $(_OBJS) $(LIBBPF)
 	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(_OBJS) $(LIBS)
@@ -126,7 +135,7 @@ profiler.skel.h: $(OUTPUT)_bpftool skeleton/profiler.bpf.o
 	$(QUIET_GEN)$(OUTPUT)./_bpftool gen skeleton skeleton/profiler.bpf.o > $@
 
 $(OUTPUT)prog.o: prog.c profiler.skel.h
-	$(QUIET_CC)$(COMPILE.c) -MMD -o $@ $<
+	$(QUIET_CC)$(COMPILE.c) -MMD $(PROG_FLAGS) -o $@ $<
 
 $(OUTPUT)disasm.o: $(srctree)/kernel/bpf/disasm.c
 	$(QUIET_CC)$(COMPILE.c) -MMD -o $@ $<
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 576ddd82bc96..5db378d5d970 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1545,6 +1545,8 @@ static int do_loadall(int argc, char **argv)
 
 static int do_profile(int argc, char **argv)
 {
+	fprintf(stdout, "bpftool prog profile command is not supported.\n"
+		"Please recompile bpftool with clang >= 11.0.0\n");
 	return 0;
 }
 
-- 
2.17.1

