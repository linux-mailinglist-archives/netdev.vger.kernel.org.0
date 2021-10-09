Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C739427D7E
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 23:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhJIVFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 17:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbhJIVFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 17:05:50 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9411C061764
        for <netdev@vger.kernel.org>; Sat,  9 Oct 2021 14:03:52 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id r18so41392439wrg.6
        for <netdev@vger.kernel.org>; Sat, 09 Oct 2021 14:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vxhL1cLX+WJUmiozIOS0qjqujZU09pMwQ+UT7XVfvGQ=;
        b=MouNxQEfindL7mty3cVeBaUdO2AJ6dMnjo7zKqt5iWpoRiHACjYdIcjSeO99POLtco
         k7j2GIfwQX+Bsr9I7nEmrPVFFSQcsBQrfz/8jhZ6VzJTn5npFqSwWhWcRw75hGu3NGD3
         EM2siFNuduR7MOyo/UTm39CSSRKoeiM9BR1slj+4N+A5GRqcJIxrxuScemiHOjk2wS9b
         KU2d21rCCvfIF/SyewHaKsrnSa8wtMrf9QlDiSjQkzpZE8CX9mGnNT7dvi5dDM5Wez82
         fjmITVsQx/I+Pi+jBCKw2gvJUQw08oJJUBlLEBgQBNp5w/rPLi5ciUe3lrasGhxUhu4z
         Vvkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vxhL1cLX+WJUmiozIOS0qjqujZU09pMwQ+UT7XVfvGQ=;
        b=GS4qdF5vvY7mu5hef2vcRsspbippIAHqPE4G2vHYKDh7C27mOanPgpMvEvYMzoGt2k
         WFNjlbENIkNkVBAtvOsL6TLXGuZ9fpUk90f0D7M9Bnvxi7+NVWw4IDLgEakfVUdbdLlp
         oxGxMPJU3YH0eKxskrrjlEYsFSI37NX33DpZzWkzoo4jx7gbakQnwvquVRJFdmDSapBR
         k8SDPSTQCX+zm0nGemQnwrDeEjkNdT76pSIXWa07tHQpJcCHiWO8gwhD+sOc1kySmUpi
         Lfm/Fg7rh1oh4rqE93jXqypcXpI8Bha//UEmJVjPgJEIyAKDxR9aqPbGXKfCjbc/5Xxt
         iamw==
X-Gm-Message-State: AOAM530H/eqC91iQ/vdt4/3bOGDDxHW9NBGdUg1sPv4JccDSYyDwyebZ
        BsXaoP+FlEPXiC71SyElp8DX9A==
X-Google-Smtp-Source: ABdhPJy+16M6bYoUpeKjkYq1a2kb32QKXs7FbbMGTfP9dvD9JA8t2jvRPs6tPW+1dLJujsEXQBlHXQ==
X-Received: by 2002:a05:600c:214:: with SMTP id 20mr11762643wmi.190.1633813431377;
        Sat, 09 Oct 2021 14:03:51 -0700 (PDT)
Received: from localhost.localdomain ([149.86.83.130])
        by smtp.gmail.com with ESMTPSA id k128sm3102516wme.41.2021.10.09.14.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 14:03:51 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 1/3] bpftool: fix install for libbpf's internal header(s)
Date:   Sat,  9 Oct 2021 22:03:39 +0100
Message-Id: <20211009210341.6291-2-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211009210341.6291-1-quentin@isovalent.com>
References: <20211009210341.6291-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We recently updated bpftool's Makefile to make it install the headers
from libbpf, instead of pulling them directly from libbpf's directory.
There is also an additional header, internal to libbpf, that needs be
installed. The way that bpftool's Makefile installs that particular
header is currently correct, but would break if we were to modify
$(LIBBPF_INTERNAL_HDRS) to make it point to more than one header.

Use a static pattern rule instead, so that the Makefile can withstand
the addition of other headers to install.

The objective is simply to make the Makefile more robust. It should
_not_ be read as an invitation to import more internal headers from
libbpf into bpftool.

Fixes: f012ade10b34 ("bpftool: Install libbpf headers instead of including the dir")
Reported-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/Makefile | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 9c2d13c513f0..2c510293f32b 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -14,7 +14,7 @@ else
   Q = @
 endif
 
-BPF_DIR = $(srctree)/tools/lib/bpf/
+BPF_DIR = $(srctree)/tools/lib/bpf
 
 ifneq ($(OUTPUT),)
   _OUTPUT := $(OUTPUT)
@@ -25,6 +25,7 @@ BOOTSTRAP_OUTPUT := $(_OUTPUT)/bootstrap/
 LIBBPF_OUTPUT := $(_OUTPUT)/libbpf/
 LIBBPF_DESTDIR := $(LIBBPF_OUTPUT)
 LIBBPF_INCLUDE := $(LIBBPF_DESTDIR)/include
+LIBBPF_HDRS_DIR := $(LIBBPF_INCLUDE)/bpf
 
 LIBBPF = $(LIBBPF_OUTPUT)libbpf.a
 LIBBPF_BOOTSTRAP_OUTPUT = $(BOOTSTRAP_OUTPUT)libbpf/
@@ -32,7 +33,8 @@ LIBBPF_BOOTSTRAP = $(LIBBPF_BOOTSTRAP_OUTPUT)libbpf.a
 
 # We need to copy nlattr.h which is not otherwise exported by libbpf, but still
 # required by bpftool.
-LIBBPF_INTERNAL_HDRS := nlattr.h
+_LIBBPF_INTERNAL_HDRS := nlattr.h
+LIBBPF_INTERNAL_HDRS := $(addprefix $(LIBBPF_HDRS_DIR)/,$(_LIBBPF_INTERNAL_HDRS))
 
 ifeq ($(BPFTOOL_VERSION),)
 BPFTOOL_VERSION := $(shell make -rR --no-print-directory -sC ../../.. kernelversion)
@@ -45,10 +47,9 @@ $(LIBBPF): FORCE | $(LIBBPF_OUTPUT)
 	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_OUTPUT) \
 		DESTDIR=$(LIBBPF_DESTDIR) prefix= $(LIBBPF) install_headers
 
-$(LIBBPF_INCLUDE)/bpf/$(LIBBPF_INTERNAL_HDRS): \
-		$(addprefix $(BPF_DIR),$(LIBBPF_INTERNAL_HDRS)) $(LIBBPF)
-	$(call QUIET_INSTALL, bpf/$(notdir $@))
-	$(Q)install -m 644 -t $(LIBBPF_INCLUDE)/bpf/ $(BPF_DIR)$(notdir $@)
+$(LIBBPF_INTERNAL_HDRS): $(LIBBPF_HDRS_DIR)/%.h: $(BPF_DIR)/%.h $(LIBBPF)
+	$(call QUIET_INSTALL, $@)
+	$(Q)install -m 644 -t $(LIBBPF_HDRS_DIR) $<
 
 $(LIBBPF_BOOTSTRAP): FORCE | $(LIBBPF_BOOTSTRAP_OUTPUT)
 	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_BOOTSTRAP_OUTPUT) \
@@ -150,7 +151,7 @@ BOOTSTRAP_OBJS = $(addprefix $(BOOTSTRAP_OUTPUT),main.o common.o json_writer.o g
 $(BOOTSTRAP_OBJS): $(LIBBPF_BOOTSTRAP)
 
 OBJS = $(patsubst %.c,$(OUTPUT)%.o,$(SRCS)) $(OUTPUT)disasm.o
-$(OBJS): $(LIBBPF) $(LIBBPF_INCLUDE)/bpf/$(LIBBPF_INTERNAL_HDRS)
+$(OBJS): $(LIBBPF) $(LIBBPF_INTERNAL_HDRS)
 
 VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)				\
 		     $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)	\
-- 
2.30.2

