Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8157641EB70
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 13:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353749AbhJALLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 07:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353722AbhJALLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 07:11:09 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E96C06177B
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 04:09:24 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id k7so14757732wrd.13
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 04:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xF0wnid+jjLXYUJTQzy67G/Ce+wFFV52s66ZLdkw4oM=;
        b=q8KEVbmS6Mjqow8nfUNxws7dmWbHxPi6mZWPIuOkV9b7z4bidRlaNmBavBOf5yGoLF
         clvK8ssh6AEdKI2kuC/PuDAdneM/Ni1dzSzQfB/9rzluHXQ/OCyO11GJ886i9H8E1dzD
         za52HcXIqInKQMFMExMfB/iMgM3mym9omrQvUr3d8yrhcoK6qlviKcskeHOfXdbSWoh5
         mz+Uio+XjWxqpRDhTayD+caYE7qkvrnZWqQTEPqBXswKf1QhDYDjmtTaw8ViaQxSfNn/
         95s+RboC6nSaPKnbcsU1DK2hHEjPNILgZXzcQbltwBIc1yjO2xffsLeXugGuXfY2GbRY
         HPpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xF0wnid+jjLXYUJTQzy67G/Ce+wFFV52s66ZLdkw4oM=;
        b=Bmj90CqTsbKDwyOvhtqDV+Ki7+i5i25+G902l5gkO5e3DUjrgBcbO9tmcILktnnMaw
         FJOEfhffwjXsHUJxrSX2FO4rYMIcol1Lzr2WIiz8SRyO8pyvICx9iSOv1v7zu1xRl/wU
         DrEutO9BGLIWEHB2DW99PBevD8j2xePpcVlUz1eo6RcY1YedgOm7f+EgWteoM40HQxHG
         WCZILpugE2HjfuZBs5sxeQtyvZH7MP1szwWQXV6T8Nb+3v8FWpKL6EhB3NyEjN5Hdfnp
         90lngzs0cPYzZ9CgB8QQUtFEqCNAHDQUKM2k+CMYBAUQIMFn7pwVOKsDl49ItoZ0bYrX
         lphg==
X-Gm-Message-State: AOAM532iCzUbrQ2RlPh029ueFZhnvy1DWvmXhkwoLAQg0pY/Vk5oHpWF
        BZpohoL3voX/M+Fm5orz9qohKA==
X-Google-Smtp-Source: ABdhPJy6AFMC1fupIo2tO3H1v3wlb0D8SdCelwEFyRd5sUsOjTFm23LQEsj5H0mmJrlITtdRziOARg==
X-Received: by 2002:a05:6000:184c:: with SMTP id c12mr11906843wri.150.1633086563325;
        Fri, 01 Oct 2021 04:09:23 -0700 (PDT)
Received: from localhost.localdomain ([149.86.91.69])
        by smtp.gmail.com with ESMTPSA id v17sm5903271wro.34.2021.10.01.04.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 04:09:22 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 2/9] tools: bpftool: install libbpf headers instead of including the dir
Date:   Fri,  1 Oct 2021 12:08:49 +0100
Message-Id: <20211001110856.14730-3-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211001110856.14730-1-quentin@isovalent.com>
References: <20211001110856.14730-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bpftool relies on libbpf, therefore it relies on a number of headers
from the library and must be linked against the library. The Makefile
for bpftool exposes these objects by adding tools/lib as an include
directory ("-I$(srctree)/tools/lib"). This is a working solution, but
this is not the cleanest one. The risk is to involuntarily include
objects that are not intended to be exposed by the libbpf.

The headers needed to compile bpftool should in fact be "installed" from
libbpf, with its "install_headers" Makefile target. In addition, there
is one header which is internal to the library and not supposed to be
used by external applications, but that bpftool uses anyway.

Adjust the Makefile in order to install the header files properly before
compiling bpftool. Also copy the additional internal header file
(nlattr.h), but call it out explicitly. Build (and install headers) in a
subdirectory under bpftool/ instead of tools/lib/bpf/. When descending
from a parent Makefile, this is configurable by setting the OUTPUT,
LIBBPF_OUTPUT and LIBBPF_DESTDIR variables.

Also adjust the Makefile for BPF selftests, so as to reuse the (host)
libbpf compiled earlier and to avoid compiling a separate version of the
library just for bpftool.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/Makefile           | 27 ++++++++++++++++-----------
 tools/testing/selftests/bpf/Makefile |  2 ++
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 1fcf5b01a193..78e42963535a 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -17,16 +17,16 @@ endif
 BPF_DIR = $(srctree)/tools/lib/bpf/
 
 ifneq ($(OUTPUT),)
-  LIBBPF_OUTPUT = $(OUTPUT)/libbpf/
-  LIBBPF_PATH = $(LIBBPF_OUTPUT)
-  BOOTSTRAP_OUTPUT = $(OUTPUT)/bootstrap/
+  _OUTPUT := $(OUTPUT)
 else
-  LIBBPF_OUTPUT =
-  LIBBPF_PATH = $(BPF_DIR)
-  BOOTSTRAP_OUTPUT = $(CURDIR)/bootstrap/
+  _OUTPUT := $(CURDIR)
 endif
+BOOTSTRAP_OUTPUT := $(_OUTPUT)/bootstrap/
+LIBBPF_OUTPUT := $(_OUTPUT)/libbpf/
+LIBBPF_DESTDIR := $(LIBBPF_OUTPUT)
+LIBBPF_INCLUDE := $(LIBBPF_DESTDIR)/include
 
-LIBBPF = $(LIBBPF_PATH)libbpf.a
+LIBBPF = $(LIBBPF_OUTPUT)libbpf.a
 LIBBPF_BOOTSTRAP_OUTPUT = $(BOOTSTRAP_OUTPUT)libbpf/
 LIBBPF_BOOTSTRAP = $(LIBBPF_BOOTSTRAP_OUTPUT)libbpf.a
 
@@ -37,8 +37,14 @@ endif
 $(LIBBPF_OUTPUT) $(BOOTSTRAP_OUTPUT) $(LIBBPF_BOOTSTRAP_OUTPUT):
 	$(QUIET_MKDIR)mkdir -p $@
 
+# We need to copy nlattr.h which is not otherwise exported by libbpf, but still
+# required by bpftool.
 $(LIBBPF): FORCE | $(LIBBPF_OUTPUT)
-	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_OUTPUT) $(LIBBPF_OUTPUT)libbpf.a
+	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_OUTPUT) \
+		DESTDIR=$(LIBBPF_DESTDIR) prefix= \
+		$(LIBBPF_OUTPUT)libbpf.a install_headers
+	$(call QUIET_INSTALL, bpf/nlattr.h)
+	$(Q)install -m 644 -t $(LIBBPF_INCLUDE)/bpf/ $(BPF_DIR)nlattr.h
 
 $(LIBBPF_BOOTSTRAP): FORCE | $(LIBBPF_BOOTSTRAP_OUTPUT)
 	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_BOOTSTRAP_OUTPUT) \
@@ -60,10 +66,10 @@ CFLAGS += -W -Wall -Wextra -Wno-unused-parameter -Wno-missing-field-initializers
 CFLAGS += $(filter-out -Wswitch-enum -Wnested-externs,$(EXTRA_WARNINGS))
 CFLAGS += -DPACKAGE='"bpftool"' -D__EXPORTED_HEADERS__ \
 	-I$(if $(OUTPUT),$(OUTPUT),.) \
+	-I$(LIBBPF_INCLUDE) \
 	-I$(srctree)/kernel/bpf/ \
 	-I$(srctree)/tools/include \
 	-I$(srctree)/tools/include/uapi \
-	-I$(srctree)/tools/lib \
 	-I$(srctree)/tools/perf
 CFLAGS += -DBPFTOOL_VERSION='"$(BPFTOOL_VERSION)"'
 ifneq ($(EXTRA_CFLAGS),)
@@ -167,8 +173,7 @@ $(OUTPUT)%.bpf.o: skeleton/%.bpf.c $(OUTPUT)vmlinux.h $(LIBBPF)
 	$(QUIET_CLANG)$(CLANG) \
 		-I$(if $(OUTPUT),$(OUTPUT),.) \
 		-I$(srctree)/tools/include/uapi/ \
-		-I$(LIBBPF_PATH) \
-		-I$(srctree)/tools/lib \
+		-I$(LIBBPF_INCLUDE) \
 		-g -O2 -Wall -target bpf -c $< -o $@ && $(LLVM_STRIP) -g $@
 
 $(OUTPUT)%.skel.h: $(OUTPUT)%.bpf.o $(BPFTOOL_BOOTSTRAP)
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 326ea75ce99e..5432bfc99740 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -209,6 +209,8 @@ $(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)    \
 		    CC=$(HOSTCC) LD=$(HOSTLD)				       \
 		    EXTRA_CFLAGS='-g -O0'				       \
 		    OUTPUT=$(HOST_BUILD_DIR)/bpftool/			       \
+		    LIBBPF_OUTPUT=$(HOST_BUILD_DIR)/libbpf/		       \
+		    LIBBPF_DESTDIR=$(HOST_SCRATCH_DIR)/			       \
 		    prefix= DESTDIR=$(HOST_SCRATCH_DIR)/ install
 
 all: docs
-- 
2.30.2

