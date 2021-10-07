Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0D9425C79
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 21:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241025AbhJGTqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 15:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237265AbhJGTqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 15:46:44 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4894CC061760
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 12:44:50 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id o20so22398952wro.3
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 12:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uh3z/u1dbz/GK73aZBtMswoc9OmOJld1oGoJJOO6d/0=;
        b=rckX9v+V+NzjXUjxz91cL6vYqQjdFJcQxstm/NRl6qMPvkptekgJ9fvFm+OBPwxJ4D
         wDqFYGV1M84T1EGzSowoA59oBEkft/1jztYSQ9QAcxg5fa9Mi+AQ+jy3QZ2Ihb+KQmvn
         5bNmJNs8yPipvajNLAOH3sR8icLJw71XAcEelKINMNPQy2N+peUvbx0RFvkgzlRcqZtw
         1glPfVFqgrRqk6D22fn7jlFpOHLmcYRnSq7mymZ0SN81Zz8plz2NzVZGyshZOXFinhBb
         dzPoKhcz+qF/GUte5Jz8UkmZ/U4TGkAhpPY3MfVpvoil2tFbDh+JAp+QN4jbVg2BxY5F
         5WzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uh3z/u1dbz/GK73aZBtMswoc9OmOJld1oGoJJOO6d/0=;
        b=fxB8KgidFL7l11MIv5YDUKJl/3w/GbNV5DZvvojTyH7F/dFEYV+74N2ZNhZ/RJaY9n
         I+r8+NTv1x9VyPc4BRtTDxmp/4c/dBcrMVvFKkLXIxsP+XJ8Zvx12iM40fI8fhyFIPIM
         ncR+oTlHHTRmgEvzJCTiOIPyLkOWZ91z89Yf4oKKIl8DBTggvE93a6jFvgpyVd21j9qj
         wOeqRExgZGYuPHt51DMlvQG0cVqV20nmmjkVuqVCC6/XYDcO/qlf6iz/DimholCSFI28
         Py/Th/wd1HCbz8L1zYurGV8ID1MidW19cDYk1oMVtOtsWvypg+vFAcsEZC8Tf0+QCIWp
         +TlQ==
X-Gm-Message-State: AOAM530ZPifMxTOmy2xB9aQ98rnf722qXNaz0Ays978UCZ44HB3jemMP
        ippJEEl5oDwIK11LfALzeE4flvO/BuezyQqraS4=
X-Google-Smtp-Source: ABdhPJzYjiO+9DNONXygkL/gbErrRfGYY0TFqZQ2otxg++asQfopRQ7rV/ecjm0zLJeySVizwrWa4w==
X-Received: by 2002:a7b:c04e:: with SMTP id u14mr18416402wmc.195.1633635888860;
        Thu, 07 Oct 2021 12:44:48 -0700 (PDT)
Received: from localhost.localdomain ([149.86.87.165])
        by smtp.gmail.com with ESMTPSA id u2sm259747wrr.35.2021.10.07.12.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 12:44:48 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v4 03/12] bpftool: install libbpf headers instead of including the dir
Date:   Thu,  7 Oct 2021 20:44:29 +0100
Message-Id: <20211007194438.34443-4-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211007194438.34443-1-quentin@isovalent.com>
References: <20211007194438.34443-1-quentin@isovalent.com>
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
Acked-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/bpf/bpftool/Makefile           | 33 ++++++++++++++++++----------
 tools/testing/selftests/bpf/Makefile |  2 ++
 2 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 1fcf5b01a193..ba02d71c39ef 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -17,19 +17,23 @@ endif
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
 
+# We need to copy nlattr.h which is not otherwise exported by libbpf, but still
+# required by bpftool.
+LIBBPF_INTERNAL_HDRS := nlattr.h
+
 ifeq ($(BPFTOOL_VERSION),)
 BPFTOOL_VERSION := $(shell make -rR --no-print-directory -sC ../../.. kernelversion)
 endif
@@ -38,7 +42,13 @@ $(LIBBPF_OUTPUT) $(BOOTSTRAP_OUTPUT) $(LIBBPF_BOOTSTRAP_OUTPUT):
 	$(QUIET_MKDIR)mkdir -p $@
 
 $(LIBBPF): FORCE | $(LIBBPF_OUTPUT)
-	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_OUTPUT) $(LIBBPF_OUTPUT)libbpf.a
+	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_OUTPUT) \
+		DESTDIR=$(LIBBPF_DESTDIR) prefix= $(LIBBPF) install_headers
+
+$(LIBBPF_INCLUDE)/bpf/$(LIBBPF_INTERNAL_HDRS): \
+		$(addprefix $(BPF_DIR),$(LIBBPF_INTERNAL_HDRS)) $(LIBBPF)
+	$(call QUIET_INSTALL, bpf/$(notdir $@))
+	$(Q)install -m 644 -t $(LIBBPF_INCLUDE)/bpf/ $(BPF_DIR)$(notdir $@)
 
 $(LIBBPF_BOOTSTRAP): FORCE | $(LIBBPF_BOOTSTRAP_OUTPUT)
 	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_BOOTSTRAP_OUTPUT) \
@@ -60,10 +70,10 @@ CFLAGS += -W -Wall -Wextra -Wno-unused-parameter -Wno-missing-field-initializers
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
@@ -140,7 +150,7 @@ BOOTSTRAP_OBJS = $(addprefix $(BOOTSTRAP_OUTPUT),main.o common.o json_writer.o g
 $(BOOTSTRAP_OBJS): $(LIBBPF_BOOTSTRAP)
 
 OBJS = $(patsubst %.c,$(OUTPUT)%.o,$(SRCS)) $(OUTPUT)disasm.o
-$(OBJS): $(LIBBPF)
+$(OBJS): $(LIBBPF) $(LIBBPF_INCLUDE)/bpf/$(LIBBPF_INTERNAL_HDRS)
 
 VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)				\
 		     $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)	\
@@ -167,8 +177,7 @@ $(OUTPUT)%.bpf.o: skeleton/%.bpf.c $(OUTPUT)vmlinux.h $(LIBBPF)
 	$(QUIET_CLANG)$(CLANG) \
 		-I$(if $(OUTPUT),$(OUTPUT),.) \
 		-I$(srctree)/tools/include/uapi/ \
-		-I$(LIBBPF_PATH) \
-		-I$(srctree)/tools/lib \
+		-I$(LIBBPF_INCLUDE) \
 		-g -O2 -Wall -target bpf -c $< -o $@ && $(LLVM_STRIP) -g $@
 
 $(OUTPUT)%.skel.h: $(OUTPUT)%.bpf.o $(BPFTOOL_BOOTSTRAP)
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index c5c9a9f50d8d..849a4637f59d 100644
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

