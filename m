Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA28310B3D
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 13:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbhBEMn4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 5 Feb 2021 07:43:56 -0500
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:24097 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232220AbhBEMle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 07:41:34 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-H-yKuGuPNNqYTr-ayKu7HQ-1; Fri, 05 Feb 2021 07:40:29 -0500
X-MC-Unique: H-yKuGuPNNqYTr-ayKu7HQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7545E107ACC7;
        Fri,  5 Feb 2021 12:40:27 +0000 (UTC)
Received: from krava.cust.in.nbox.cz (unknown [10.40.195.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A5C360936;
        Fri,  5 Feb 2021 12:40:24 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild@vger.kernel.org
Subject: [PATCH bpf-next 1/4] tools/resolve_btfids: Build libbpf and libsubcmd in separate directories
Date:   Fri,  5 Feb 2021 13:40:17 +0100
Message-Id: <20210205124020.683286-2-jolsa@kernel.org>
In-Reply-To: <20210205124020.683286-1-jolsa@kernel.org>
References: <20210205124020.683286-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Setting up separate build directories for libbpf and libpsubcmd,
so it's separated from other objects and we don't get them mixed
in the future.

It also simplifies cleaning, which is now simple rm -rf.

Also there's no need for FEATURE-DUMP.libbpf and bpf_helper_defs.h
files in .gitignore anymore.

Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/bpf/resolve_btfids/.gitignore |  2 --
 tools/bpf/resolve_btfids/Makefile   | 26 +++++++++++---------------
 2 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/tools/bpf/resolve_btfids/.gitignore b/tools/bpf/resolve_btfids/.gitignore
index a026df7dc280..25f308c933cc 100644
--- a/tools/bpf/resolve_btfids/.gitignore
+++ b/tools/bpf/resolve_btfids/.gitignore
@@ -1,4 +1,2 @@
-/FEATURE-DUMP.libbpf
-/bpf_helper_defs.h
 /fixdep
 /resolve_btfids
diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
index bf656432ad73..1d46a247ec95 100644
--- a/tools/bpf/resolve_btfids/Makefile
+++ b/tools/bpf/resolve_btfids/Makefile
@@ -28,22 +28,22 @@ OUTPUT ?= $(srctree)/tools/bpf/resolve_btfids/
 LIBBPF_SRC := $(srctree)/tools/lib/bpf/
 SUBCMD_SRC := $(srctree)/tools/lib/subcmd/
 
-BPFOBJ     := $(OUTPUT)/libbpf.a
-SUBCMDOBJ  := $(OUTPUT)/libsubcmd.a
+BPFOBJ     := $(OUTPUT)/libbpf/libbpf.a
+SUBCMDOBJ  := $(OUTPUT)/libsubcmd/libsubcmd.a
 
 BINARY     := $(OUTPUT)/resolve_btfids
 BINARY_IN  := $(BINARY)-in.o
 
 all: $(BINARY)
 
-$(OUTPUT):
+$(OUTPUT) $(OUTPUT)/libbpf $(OUTPUT)/libsubcmd:
 	$(call msg,MKDIR,,$@)
-	$(Q)mkdir -p $(OUTPUT)
+	$(Q)mkdir -p $(@)
 
-$(SUBCMDOBJ): fixdep FORCE
-	$(Q)$(MAKE) -C $(SUBCMD_SRC) OUTPUT=$(OUTPUT)
+$(SUBCMDOBJ): fixdep FORCE | $(OUTPUT)/libsubcmd
+	$(Q)$(MAKE) -C $(SUBCMD_SRC) OUTPUT=$(abspath $(dir $@))/ $(abspath $@)
 
-$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(OUTPUT)
+$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(OUTPUT)/libbpf
 	$(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC)  OUTPUT=$(abspath $(dir $@))/ $(abspath $@)
 
 CFLAGS := -g \
@@ -57,23 +57,19 @@ LIBS = -lelf -lz
 export srctree OUTPUT CFLAGS Q
 include $(srctree)/tools/build/Makefile.include
 
-$(BINARY_IN): fixdep FORCE
+$(BINARY_IN): fixdep FORCE | $(OUTPUT)
 	$(Q)$(MAKE) $(build)=resolve_btfids
 
 $(BINARY): $(BPFOBJ) $(SUBCMDOBJ) $(BINARY_IN)
 	$(call msg,LINK,$@)
 	$(Q)$(CC) $(BINARY_IN) $(LDFLAGS) -o $@ $(BPFOBJ) $(SUBCMDOBJ) $(LIBS)
 
-libsubcmd-clean:
-	$(Q)$(MAKE) -C $(SUBCMD_SRC) OUTPUT=$(OUTPUT) clean
-
-libbpf-clean:
-	$(Q)$(MAKE) -C $(LIBBPF_SRC) OUTPUT=$(OUTPUT) clean
-
-clean: libsubcmd-clean libbpf-clean fixdep-clean
+clean: fixdep-clean
 	$(call msg,CLEAN,$(BINARY))
 	$(Q)$(RM) -f $(BINARY); \
 	$(RM) -rf $(if $(OUTPUT),$(OUTPUT),.)/feature; \
+	$(RM) -rf $(OUTPUT)/libbpf; \
+	$(RM) -rf $(OUTPUT)/libsubcmd; \
 	find $(if $(OUTPUT),$(OUTPUT),.) -name \*.o -or -name \*.o.cmd -or -name \*.o.d | xargs $(RM)
 
 tags:
-- 
2.26.2

