Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5148830FF30
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 22:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbhBDVTd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 4 Feb 2021 16:19:33 -0500
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:43691 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229534AbhBDVTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 16:19:31 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-C8ToOAWhNu-dZ2YDN91Qsw-1; Thu, 04 Feb 2021 16:18:34 -0500
X-MC-Unique: C8ToOAWhNu-dZ2YDN91Qsw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 663664236C;
        Thu,  4 Feb 2021 21:18:32 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A29185B695;
        Thu,  4 Feb 2021 21:18:29 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild@vger.kernel.org
Subject: [PATCH bpf-next 1/4] tools/resolve_btfids: Build libbpf and libsubcmd in separate directories
Date:   Thu,  4 Feb 2021 22:18:22 +0100
Message-Id: <20210204211825.588160-2-jolsa@kernel.org>
In-Reply-To: <20210204211825.588160-1-jolsa@kernel.org>
References: <20210129134855.195810-1-jolsa@redhat.com>
 <20210204211825.588160-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
index bf656432ad73..b780b3a9fb07 100644
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
+	$(RM) -rf $(OUTPUT)libbpf; \
+	$(RM) -rf $(OUTPUT)libsubcmd; \
 	find $(if $(OUTPUT),$(OUTPUT),.) -name \*.o -or -name \*.o.cmd -or -name \*.o.d | xargs $(RM)
 
 tags:
-- 
2.26.2

