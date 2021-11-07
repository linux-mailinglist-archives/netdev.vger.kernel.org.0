Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64534447117
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 01:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233533AbhKGA2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 20:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231869AbhKGA2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 20:28:13 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE78C061570
        for <netdev@vger.kernel.org>; Sat,  6 Nov 2021 17:25:31 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id r9-20020a7bc089000000b00332f4abf43fso8652374wmh.0
        for <netdev@vger.kernel.org>; Sat, 06 Nov 2021 17:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y1HVp9FmknLhxKbjSBkY/pQ0aUWzycOIYNg60LBlRKM=;
        b=PAbMbOaQQ02yfasQOcEshLjXpHu7XBvVm7m+hl+4bBemu4SE021mzHq5KFv41qSW56
         /liAwYw0evxi/w0LKmIZ1ZaJ4wDdVMDGkqY9kK1J1r0U6MtPm1jLleE2vbB277D1NASH
         1y7GijXY1TxH3j9plJTuUgmaBob2o2FpwMzkmj6qtyGf36Fi8o1dmZztJYmy6GEzWwN2
         fZRUd9fJuWUeOPlk4r+A45D7PeOAgu5rmPplOW0M6JNYZJ/NTstax5ljxvq8gDP7Nniz
         6BrM/u9DN7OQyDJJ971LADJ6LC+ehcf7dWG8acutBtrZwRHPx3G1JsLA6zwzDzWskr6+
         +prg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y1HVp9FmknLhxKbjSBkY/pQ0aUWzycOIYNg60LBlRKM=;
        b=OUP24SO4+EItvB5YF6Aw6pkJJ3AJ+K/GRiq5hGnvuxIBnJo3J2lrqTZC+7p4qcIXAl
         rAElNwgeST3rgSyODwk1uwZMRySkgKjPGekFtnyxncOIMMtC0/oQMKI6AHENsw1jQnYM
         2TUytWrp6mp10rkHND4dsbCzGk5PQCxpJbGvEWIisXCdY4Q+JPH6MMbRG452ivHEKFBR
         2GOKa2MajAk6ubpTpmj8saZGZ6NabhNxvQOrq76c35EDGKoXhBTuS96j/N9zbfX/i4lV
         AgY6cVrIDTeVtLDvdJ2SYTo/yXW8X2lFLs37hjzsm0k1bvK5kx5o6Xz/xW+aNU7Bh+0k
         Ah8Q==
X-Gm-Message-State: AOAM531uWaw98HL9NzdxG5MLVT0w9JC62UK7f0ulP8z4dkhUIAbdoIXg
        QuJKlXgKpSpuib5ude4sCy/fHgTVZi6T3A==
X-Google-Smtp-Source: ABdhPJwjQg4523Hu5mJSwF08gsTlYIStemQsKCmYcOBSNVcPiZT5Yov83jxn3fksBDfgDikt1iukcA==
X-Received: by 2002:a05:600c:b41:: with SMTP id k1mr43615221wmr.4.1636244729930;
        Sat, 06 Nov 2021 17:25:29 -0700 (PDT)
Received: from localhost.localdomain ([149.86.67.25])
        by smtp.gmail.com with ESMTPSA id h1sm11698919wmb.7.2021.11.06.17.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Nov 2021 17:25:29 -0700 (PDT)
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
Subject: [PATCH v2] perf build: Install libbpf headers locally when building
Date:   Sun,  7 Nov 2021 00:24:45 +0000
Message-Id: <20211107002445.4790-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <813cc0db-51d0-65b3-70f4-f1a823b0d029@isovalent.com>
References: <813cc0db-51d0-65b3-70f4-f1a823b0d029@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

API headers from libbpf should not be accessed directly from the
library's source directory. Instead, they should be exported with "make
install_headers". Let's adjust perf's Makefile to install those headers
locally when building libbpf.

v2:
- Fix $(LIBBPF_OUTPUT) when $(OUTPUT) is null.
- Make sure the recipe for $(LIBBPF_OUTPUT) is not under a "ifdef".

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/perf/Makefile.perf | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index b856afa6eb52..e01ada5c9876 100644
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
@@ -324,7 +322,14 @@ LIBTRACEEVENT_DYNAMIC_LIST_LDFLAGS = $(if $(findstring -static,$(LDFLAGS)),,$(DY
 LIBAPI = $(API_PATH)libapi.a
 export LIBAPI
 
-LIBBPF = $(BPF_PATH)libbpf.a
+ifneq ($(OUTPUT),)
+  LIBBPF_OUTPUT = $(abspath $(OUTPUT))/libbpf
+else
+  LIBBPF_OUTPUT = $(CURDIR)/libbpf
+endif
+LIBBPF_DESTDIR = $(LIBBPF_OUTPUT)
+LIBBPF_INCLUDE = $(LIBBPF_DESTDIR)/include
+LIBBPF = $(LIBBPF_OUTPUT)/libbpf.a
 
 LIBSUBCMD = $(SUBCMD_PATH)libsubcmd.a
 
@@ -829,12 +834,14 @@ $(LIBAPI)-clean:
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
@@ -1034,16 +1041,15 @@ SKELETONS := $(SKEL_OUT)/bpf_prog_profiler.skel.h
 SKELETONS += $(SKEL_OUT)/bperf_leader.skel.h $(SKEL_OUT)/bperf_follower.skel.h
 SKELETONS += $(SKEL_OUT)/bperf_cgroup.skel.h
 
+$(SKEL_TMP_OUT) $(LIBBPF_OUTPUT):
+	$(Q)$(MKDIR) -p $@
+
 ifdef BUILD_BPF_SKEL
 BPFTOOL := $(SKEL_TMP_OUT)/bootstrap/bpftool
-LIBBPF_SRC := $(abspath ../lib/bpf)
-BPF_INCLUDE := -I$(SKEL_TMP_OUT)/.. -I$(BPF_PATH) -I$(LIBBPF_SRC)/..
-
-$(SKEL_TMP_OUT):
-	$(Q)$(MKDIR) -p $@
+BPF_INCLUDE := -I$(SKEL_TMP_OUT)/.. -I$(LIBBPF_INCLUDE)
 
 $(BPFTOOL): | $(SKEL_TMP_OUT)
-	CFLAGS= $(MAKE) -C ../bpf/bpftool \
+	$(Q)CFLAGS= $(MAKE) -C ../bpf/bpftool \
 		OUTPUT=$(SKEL_TMP_OUT)/ bootstrap
 
 VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)				\
-- 
2.32.0

