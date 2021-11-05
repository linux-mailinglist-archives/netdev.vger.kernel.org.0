Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15DD445DBF
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 03:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbhKECF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 22:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbhKECF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 22:05:29 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466E4C061714
        for <netdev@vger.kernel.org>; Thu,  4 Nov 2021 19:02:50 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id t30so11386922wra.10
        for <netdev@vger.kernel.org>; Thu, 04 Nov 2021 19:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g/KwcGZJ2ywlDI+GoDm/yLhvbB9i4E8UzpdWkn5/09g=;
        b=koUs0Dv9hoJYn22M4mp6QYRlvnl+sg+Ewxmw/b2AU6eDWveCnlK24mI041ZftDlU9Q
         STQIpo/im7vwfJjBiwO3RW2b58TBsw5XikQP3wZGAyjlJdeaTgmAnrnlXu5bUy7EeVEl
         LK6jSkE2I1tbzy8NO3iMW3jfWZqseW/wE63MPnIY8iX+3umCU5jD5Vc50Dr65erXrsx5
         ExPBfmGHc7/a90YrB22rq/AAlcQAoRoNQAXYgebK+SRiLvmvoRTGUFyExG4Y9kPNb1/x
         LA6wO4sVHj899uFJjAucqy41xjvDvo2uFdwnyFrZQEkqeNoyr1WLofUpN/3W0aPKiAnH
         Mp+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g/KwcGZJ2ywlDI+GoDm/yLhvbB9i4E8UzpdWkn5/09g=;
        b=nV9uwelrzaL5UmGiiNfgirmJ0leKc8GTjBQ3kftQ9EZdWbA3iGKwtvVz5KKtukiGoy
         p1ZLHigoXqb39i8DI/gaZeKFn1kLYm5pTyMHCPgbv63THoSYcMj+i7cHiXL4eaNoR4E+
         2j1Wf3mTVX75xyUjtql8mgcxCd+2H0Ga3l/Kk69q+m2MdjRyMujH7tfEPlCtrxjE2HSi
         mFK/dANlAFUgIW0BSr/9h/fUiGhsZ5h8LUoMb/4IfvvqgcvwQvmrdOWDasWaQCFkvlf7
         4GTcFaAodnNEf+YKUUe7FLNBLnRriuEK1euNS02XfA90aBRBUYIRJLzatKSkDlIK4qZv
         AlaA==
X-Gm-Message-State: AOAM530iG+ZJ1u3xBbvkknZVmf6InGTa1sDJonEFEmgdJhcLhHESgt+X
        DuWo158xN1qYryak9JtXYWogrw==
X-Google-Smtp-Source: ABdhPJw2eYBYU5ZduG5er5venKP9bKIbi8LA0CIVYCWbVjCU4Jv2ipObag8iHzsN4LkC17S3XLYm6Q==
X-Received: by 2002:adf:e54a:: with SMTP id z10mr59092064wrm.328.1636077768859;
        Thu, 04 Nov 2021 19:02:48 -0700 (PDT)
Received: from localhost.localdomain ([149.86.70.55])
        by smtp.gmail.com with ESMTPSA id u19sm6781708wmm.5.2021.11.04.19.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 19:02:48 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Song Liu <songliubraving@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next] perf build: Install libbpf headers locally when building
Date:   Fri,  5 Nov 2021 02:02:44 +0000
Message-Id: <20211105020244.6869-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

API headers from libbpf should not be accessed directly from the
library's source directory. Instead, they should be exported with "make
install_headers". Let's adjust perf's Makefile to install those headers
locally when building libbpf.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
Note: Sending to bpf-next because it's directly related to libbpf, and
to similar patches merged through bpf-next, but maybe Arnaldo prefers to
take it?
---
 tools/perf/Makefile.perf | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index b856afa6eb52..3a81b6c712a9 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -241,7 +241,7 @@ else # force_fixdep
 
 LIB_DIR         = $(srctree)/tools/lib/api/
 TRACE_EVENT_DIR = $(srctree)/tools/lib/traceevent/
-BPF_DIR         = $(srctree)/tools/lib/bpf/
+LIBBPF_DIR      = $(srctree)/tools/lib/bpf/
 SUBCMD_DIR      = $(srctree)/tools/lib/subcmd/
 LIBPERF_DIR     = $(srctree)/tools/lib/perf/
 DOC_DIR         = $(srctree)/tools/perf/Documentation/
@@ -293,7 +293,6 @@ strip-libs = $(filter-out -l%,$(1))
 ifneq ($(OUTPUT),)
   TE_PATH=$(OUTPUT)
   PLUGINS_PATH=$(OUTPUT)
-  BPF_PATH=$(OUTPUT)
   SUBCMD_PATH=$(OUTPUT)
   LIBPERF_PATH=$(OUTPUT)
 ifneq ($(subdir),)
@@ -305,7 +304,6 @@ else
   TE_PATH=$(TRACE_EVENT_DIR)
   PLUGINS_PATH=$(TRACE_EVENT_DIR)plugins/
   API_PATH=$(LIB_DIR)
-  BPF_PATH=$(BPF_DIR)
   SUBCMD_PATH=$(SUBCMD_DIR)
   LIBPERF_PATH=$(LIBPERF_DIR)
 endif
@@ -324,7 +322,10 @@ LIBTRACEEVENT_DYNAMIC_LIST_LDFLAGS = $(if $(findstring -static,$(LDFLAGS)),,$(DY
 LIBAPI = $(API_PATH)libapi.a
 export LIBAPI
 
-LIBBPF = $(BPF_PATH)libbpf.a
+LIBBPF_OUTPUT = $(OUTPUT)libbpf
+LIBBPF_DESTDIR = $(LIBBPF_OUTPUT)
+LIBBPF_INCLUDE = $(LIBBPF_DESTDIR)/include
+LIBBPF = $(LIBBPF_OUTPUT)/libbpf.a
 
 LIBSUBCMD = $(SUBCMD_PATH)libsubcmd.a
 
@@ -829,12 +830,14 @@ $(LIBAPI)-clean:
 	$(call QUIET_CLEAN, libapi)
 	$(Q)$(MAKE) -C $(LIB_DIR) O=$(OUTPUT) clean >/dev/null
 
-$(LIBBPF): FORCE
-	$(Q)$(MAKE) -C $(BPF_DIR) O=$(OUTPUT) $(OUTPUT)libbpf.a FEATURES_DUMP=$(FEATURE_DUMP_EXPORT)
+$(LIBBPF): FORCE | $(LIBBPF_OUTPUT)
+	$(Q)$(MAKE) -C $(LIBBPF_DIR) FEATURES_DUMP=$(FEATURE_DUMP_EXPORT) \
+		O= OUTPUT=$(LIBBPF_OUTPUT)/ DESTDIR=$(LIBBPF_DESTDIR) prefix= \
+		$@ install_headers
 
 $(LIBBPF)-clean:
 	$(call QUIET_CLEAN, libbpf)
-	$(Q)$(MAKE) -C $(BPF_DIR) O=$(OUTPUT) clean >/dev/null
+	$(Q)$(RM) -r -- $(LIBBPF_OUTPUT)
 
 $(LIBPERF): FORCE
 	$(Q)$(MAKE) -C $(LIBPERF_DIR) EXTRA_CFLAGS="$(LIBPERF_CFLAGS)" O=$(OUTPUT) $(OUTPUT)libperf.a
@@ -1036,14 +1039,13 @@ SKELETONS += $(SKEL_OUT)/bperf_cgroup.skel.h
 
 ifdef BUILD_BPF_SKEL
 BPFTOOL := $(SKEL_TMP_OUT)/bootstrap/bpftool
-LIBBPF_SRC := $(abspath ../lib/bpf)
-BPF_INCLUDE := -I$(SKEL_TMP_OUT)/.. -I$(BPF_PATH) -I$(LIBBPF_SRC)/..
+BPF_INCLUDE := -I$(SKEL_TMP_OUT)/.. -I$(LIBBPF_INCLUDE)
 
-$(SKEL_TMP_OUT):
+$(SKEL_TMP_OUT) $(LIBBPF_OUTPUT):
 	$(Q)$(MKDIR) -p $@
 
 $(BPFTOOL): | $(SKEL_TMP_OUT)
-	CFLAGS= $(MAKE) -C ../bpf/bpftool \
+	$(Q)CFLAGS= $(MAKE) -C ../bpf/bpftool \
 		OUTPUT=$(SKEL_TMP_OUT)/ bootstrap
 
 VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)				\
-- 
2.32.0

