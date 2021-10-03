Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78BC42039E
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 21:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbhJCTYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 15:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbhJCTYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Oct 2021 15:24:10 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F1FC0613EC
        for <netdev@vger.kernel.org>; Sun,  3 Oct 2021 12:22:22 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id r10so9859425wra.12
        for <netdev@vger.kernel.org>; Sun, 03 Oct 2021 12:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F+eDIzEajIHNPrpBckDVUcZ6GfeTxtcft4jDlPKe6jw=;
        b=E0Iwd6T6L4LdUmdVFF9sCqNj9E45EUHHvXmULJyEW9pXEeslIi5ZqhHrHn0uAzaeUG
         fqszde80curm5O02ePqubTy9re719YzwcGij1/C3HFCtLZfKYAlHLVpSSelhaKt2KLmN
         76vp0vLJ+LvMS1VBDJ8aoXn5f7q/6FJTdO4HfbBssMFv/OOEe1tXHR2NR/BuFZeX/cq9
         JWWMQmkC8RbMUSv1nwURPZKeH3y8JrYdNTWRyOYn8xuo0PIEZ7QdO73LPHmX/c3wt4LZ
         yO9tzVd+uLJY/PynNjojW5Phuun44g/KmZzLK7HaofpSEfqlIpiPROukeufzr3zMuM8F
         pUPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F+eDIzEajIHNPrpBckDVUcZ6GfeTxtcft4jDlPKe6jw=;
        b=O0+57ktNrFs/TToInG8854K45KEfqMDSR835HIZ8BHUSpsDhVNCQwj5+w6g15tTf2q
         S/YFOE47yV5AKLywZ9eYjgp1ifHYDGNLdSLnb+anLqZQ/KXJ/9k9AFyIMCFgFupl+QVW
         epsk/T/e5a5uZAHo21bWKk90EtOtqzrUAjuqyBXkKDmw273lde3oJj9EP8hp1ARhkJJJ
         YTRG/pTyEG+fyuCbamlzHoqYE5IOWYot1mZUym7b+PVtf6+Uv3+PUaAYbAZeBubgTpSi
         J0YHdziT3fZhWccuHAVYPGt/wqAs/kv7PxHofPS1Kuwg097aE8VCwkmwLi79+U0jLETB
         GwUw==
X-Gm-Message-State: AOAM531UaXVlVhkramMiURDpL89NkHj3k9aUM4mjC37d5z6IT3llL40a
        McQLwsruWj3Uynvpn2x5D12R0A==
X-Google-Smtp-Source: ABdhPJzedE5stWqeSXaLh38lK73QksnPp8gbXU6Axw8FoeshUoB2hXXqAKkKuE0yiAlxXAop+s+UMQ==
X-Received: by 2002:adf:a4ca:: with SMTP id h10mr10085549wrb.28.1633288940729;
        Sun, 03 Oct 2021 12:22:20 -0700 (PDT)
Received: from localhost.localdomain ([149.86.88.77])
        by smtp.gmail.com with ESMTPSA id d3sm14124642wrb.36.2021.10.03.12.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 12:22:20 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v3 02/10] tools: bpftool: install libbpf headers instead of including the dir
Date:   Sun,  3 Oct 2021 20:22:00 +0100
Message-Id: <20211003192208.6297-3-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211003192208.6297-1-quentin@isovalent.com>
References: <20211003192208.6297-1-quentin@isovalent.com>
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
 tools/bpf/bpftool/Makefile           | 26 +++++++++++++++-----------
 tools/testing/selftests/bpf/Makefile |  2 ++
 2 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 1fcf5b01a193..ef5219e0e233 100644
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
 
@@ -37,8 +37,13 @@ endif
 $(LIBBPF_OUTPUT) $(BOOTSTRAP_OUTPUT) $(LIBBPF_BOOTSTRAP_OUTPUT):
 	$(QUIET_MKDIR)mkdir -p $@
 
+# We need to copy nlattr.h which is not otherwise exported by libbpf, but still
+# required by bpftool.
 $(LIBBPF): FORCE | $(LIBBPF_OUTPUT)
-	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_OUTPUT) $(LIBBPF_OUTPUT)libbpf.a
+	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_OUTPUT) \
+		DESTDIR=$(LIBBPF_DESTDIR) prefix= $(LIBBPF) install_headers
+	$(call QUIET_INSTALL, bpf/nlattr.h)
+	$(Q)install -m 644 -t $(LIBBPF_INCLUDE)/bpf/ $(BPF_DIR)nlattr.h
 
 $(LIBBPF_BOOTSTRAP): FORCE | $(LIBBPF_BOOTSTRAP_OUTPUT)
 	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_BOOTSTRAP_OUTPUT) \
@@ -60,10 +65,10 @@ CFLAGS += -W -Wall -Wextra -Wno-unused-parameter -Wno-missing-field-initializers
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
@@ -167,8 +172,7 @@ $(OUTPUT)%.bpf.o: skeleton/%.bpf.c $(OUTPUT)vmlinux.h $(LIBBPF)
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

