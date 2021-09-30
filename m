Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A13D41D8DA
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 13:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350536AbhI3Lfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 07:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350508AbhI3Lfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 07:35:47 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97513C06176A
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:34:04 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id d6so9463177wrc.11
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZVRI1vsPtM4IE1gmBFSEqqg+MaNx9NW4FiCNSSzSPSc=;
        b=aJwwi3uvqzzLrCL4j7JafXjdO1sguBBVDhOHbm6VdmRRb0TRj/CGi31emCt44nCd8S
         jV3SiM6wbM38CJSwDUz3TYCvUGrT+6je56pCLejmyEbmqTdVlSFhq1iD/zZjOV/YND6Z
         mJsyKtSSoJjnZ6CZGwSwtffqhwMEKGe/enRzukrDmQRl1dCegk9VV26oX6PpeuN2rQnP
         FUD34wnr8apE1YoX6gUrwkiy8uLk9MYGozp4ZAHYqcz9sUP2dfyXuPLkmofIGmw+Mss4
         tWtsJvWb36EaARoii7B0E4jieb9KWIemS4xbCBTReYWwoZ8cu3fMMC6qteVjbCq7v6ki
         NMDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZVRI1vsPtM4IE1gmBFSEqqg+MaNx9NW4FiCNSSzSPSc=;
        b=4bF1dI2+JE9Dk4Ni5MOPKl6a4AtXnJZJCreQo8xHQhyauTqG5Y1KDIqG14eluD0UAV
         MOaDelH6VcElZvCtUJZccsqXUO+zHcwkteJwCkw6QFmgZouVYfRZfLtiewYUg0OV3G48
         t9somqL93i7+U3bz+2Arx1bmAglwpL+BrPzCMPdj2dBmiGyp6bqlRflTuA8x/hkDDq3p
         QKuKL0sHxzcAPj19xjuVPQf9DoN5mqxLGJmzP6HyXFsX69muKpkHMyF6RLTUpGUTr79W
         qQeDZ4gA/wYcOuO53wkv4xYfQ4+smTnEWJQbFnYQ4HxKgu2CnbDOEXAduvpr3sRw1jJ3
         BRNg==
X-Gm-Message-State: AOAM532Q0NjNJizS/nqHUiZYMnMc9yYdlYV6LGEZmvOBHEPMSi6s0HBF
        ZMCW/o185XsubAoWI9SfIEeoEg==
X-Google-Smtp-Source: ABdhPJxFslTAdxkH3ZFp0Gyn4Gn1atrAD+r3vTHGp1OI6ROrnFco+7HLkSd1n+7qfVCLp0JKrd0JSg==
X-Received: by 2002:a5d:5104:: with SMTP id s4mr5689517wrt.16.1633001643198;
        Thu, 30 Sep 2021 04:34:03 -0700 (PDT)
Received: from localhost.localdomain ([149.86.91.95])
        by smtp.gmail.com with ESMTPSA id v10sm2904660wrm.71.2021.09.30.04.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 04:34:02 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 3/9] tools: resolve_btfids: install libbpf headers when building
Date:   Thu, 30 Sep 2021 12:33:00 +0100
Message-Id: <20210930113306.14950-4-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210930113306.14950-1-quentin@isovalent.com>
References: <20210930113306.14950-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

API headers from libbpf should not be accessed directly from the
library's source directory. Instead, they should be exported with "make
install_headers". Let's make sure that resolve_btfids installs the
headers properly when building.

When descending from a parent Makefile, the specific output directories
for building the library and exporting the headers are configurable with
LIBBPF_OUT and LIBBPF_DESTDIR, respectively. This is in addition to
OUTPUT, on top of which those variables are constructed by default.

Also adjust the Makefile for the BPF selftests in order to point to the
(target) libbpf shared with other tools, instead of building a version
specific to resolve_btfids.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/resolve_btfids/Makefile    | 17 ++++++++++++-----
 tools/bpf/resolve_btfids/main.c      |  4 ++--
 tools/testing/selftests/bpf/Makefile |  7 +++++--
 3 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
index 08b75e314ae7..89a46d4d0768 100644
--- a/tools/bpf/resolve_btfids/Makefile
+++ b/tools/bpf/resolve_btfids/Makefile
@@ -29,25 +29,31 @@ BPFOBJ     := $(OUTPUT)/libbpf/libbpf.a
 LIBBPF_OUT := $(abspath $(dir $(BPFOBJ)))/
 SUBCMDOBJ  := $(OUTPUT)/libsubcmd/libsubcmd.a
 
+LIBBPF_DESTDIR := $(LIBBPF_OUT)
+LIBBPF_INCLUDE := $(LIBBPF_DESTDIR)include
+
 BINARY     := $(OUTPUT)/resolve_btfids
 BINARY_IN  := $(BINARY)-in.o
 
 all: $(BINARY)
 
-$(OUTPUT) $(OUTPUT)/libbpf $(OUTPUT)/libsubcmd:
+$(OUTPUT) $(OUTPUT)/libsubcmd $(LIBBPF_OUT) $(LIBBPF_INCLUDE):
 	$(call msg,MKDIR,,$@)
 	$(Q)mkdir -p $(@)
 
 $(SUBCMDOBJ): fixdep FORCE | $(OUTPUT)/libsubcmd
 	$(Q)$(MAKE) -C $(SUBCMD_SRC) OUTPUT=$(abspath $(dir $@))/ $(abspath $@)
 
-$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(OUTPUT)/libbpf
-	$(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC)  OUTPUT=$(LIBBPF_OUT) $(abspath $@)
+$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile)	       \
+	   | $(LIBBPF_OUT) $(LIBBPF_INCLUDE)
+	$(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC) OUTPUT=$(LIBBPF_OUT)    \
+		    DESTDIR=$(LIBBPF_DESTDIR) prefix=			       \
+		    $(abspath $@) install_headers
 
 CFLAGS := -g \
           -I$(srctree)/tools/include \
           -I$(srctree)/tools/include/uapi \
-          -I$(LIBBPF_SRC) \
+          -I$(LIBBPF_INCLUDE) \
           -I$(SUBCMD_SRC)
 
 LIBS = -lelf -lz
@@ -65,7 +71,8 @@ $(BINARY): $(BPFOBJ) $(SUBCMDOBJ) $(BINARY_IN)
 clean_objects := $(wildcard $(OUTPUT)/*.o                \
                             $(OUTPUT)/.*.o.cmd           \
                             $(OUTPUT)/.*.o.d             \
-                            $(OUTPUT)/libbpf             \
+                            $(LIBBPF_OUT)                \
+                            $(LIBBPF_DESTDIR)            \
                             $(OUTPUT)/libsubcmd          \
                             $(OUTPUT)/resolve_btfids)
 
diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
index de6365b53c9c..91af785e6de5 100644
--- a/tools/bpf/resolve_btfids/main.c
+++ b/tools/bpf/resolve_btfids/main.c
@@ -60,8 +60,8 @@
 #include <linux/rbtree.h>
 #include <linux/zalloc.h>
 #include <linux/err.h>
-#include <btf.h>
-#include <libbpf.h>
+#include <bpf/btf.h>
+#include <bpf/libbpf.h>
 #include <parse-options.h>
 
 #define BTF_IDS_SECTION	".BTF_ids"
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 5432bfc99740..0167514ccaa2 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -122,9 +122,11 @@ BPFOBJ := $(BUILD_DIR)/libbpf/libbpf.a
 ifneq ($(CROSS_COMPILE),)
 HOST_BUILD_DIR		:= $(BUILD_DIR)/host
 HOST_SCRATCH_DIR	:= $(OUTPUT)/host-tools
+HOST_INCLUDE_DIR	:= $(HOST_SCRATCH_DIR)/include
 else
 HOST_BUILD_DIR		:= $(BUILD_DIR)
 HOST_SCRATCH_DIR	:= $(SCRATCH_DIR)
+HOST_INCLUDE_DIR	:= $(INCLUDE_DIR)
 endif
 HOST_BPFOBJ := $(HOST_BUILD_DIR)/libbpf/libbpf.a
 RESOLVE_BTFIDS := $(HOST_BUILD_DIR)/resolve_btfids/resolve_btfids
@@ -152,7 +154,7 @@ $(notdir $(TEST_GEN_PROGS)						\
 # sort removes libbpf duplicates when not cross-building
 MAKE_DIRS := $(sort $(BUILD_DIR)/libbpf $(HOST_BUILD_DIR)/libbpf	       \
 	       $(HOST_BUILD_DIR)/bpftool $(HOST_BUILD_DIR)/resolve_btfids      \
-	       $(INCLUDE_DIR))
+	       $(INCLUDE_DIR) $(HOST_INCLUDE_DIR))
 $(MAKE_DIRS):
 	$(call msg,MKDIR,,$@)
 	$(Q)mkdir -p $@
@@ -235,7 +237,7 @@ $(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)		       \
 ifneq ($(BPFOBJ),$(HOST_BPFOBJ))
 $(HOST_BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)                \
 	   ../../../include/uapi/linux/bpf.h                                   \
-	   | $(INCLUDE_DIR) $(HOST_BUILD_DIR)/libbpf
+	   | $(HOST_INCLUDE_DIR) $(HOST_BUILD_DIR)/libbpf
 	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR)                             \
 		    EXTRA_CFLAGS='-g -O0'				       \
 		    OUTPUT=$(HOST_BUILD_DIR)/libbpf/ CC=$(HOSTCC) LD=$(HOSTLD) \
@@ -260,6 +262,7 @@ $(RESOLVE_BTFIDS): $(HOST_BPFOBJ) | $(HOST_BUILD_DIR)/resolve_btfids	\
 		       $(TOOLSDIR)/lib/str_error_r.c
 	$(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/resolve_btfids	\
 		CC=$(HOSTCC) LD=$(HOSTLD) AR=$(HOSTAR) \
+		LIBBPF_INCLUDE=$(HOST_INCLUDE_DIR) \
 		OUTPUT=$(HOST_BUILD_DIR)/resolve_btfids/ BPFOBJ=$(HOST_BPFOBJ)
 
 # Get Clang's default includes on this system, as opposed to those seen by
-- 
2.30.2

