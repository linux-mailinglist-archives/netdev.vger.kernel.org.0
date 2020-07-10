Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3F921BDC2
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 21:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgGJTiL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 10 Jul 2020 15:38:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36395 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728362AbgGJTiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 15:38:08 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-4KfsuBDeNsKkbLjQJ_BUbQ-1; Fri, 10 Jul 2020 15:38:02 -0400
X-MC-Unique: 4KfsuBDeNsKkbLjQJ_BUbQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D608100CCC5;
        Fri, 10 Jul 2020 19:38:01 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D56110016E8;
        Fri, 10 Jul 2020 19:37:59 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v6 bpf-next 2/9] bpf: Compile resolve_btfids tool at kernel compilation start
Date:   Fri, 10 Jul 2020 21:37:47 +0200
Message-Id: <20200710193754.3821104-3-jolsa@kernel.org>
In-Reply-To: <20200710193754.3821104-1-jolsa@kernel.org>
References: <20200710193754.3821104-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The resolve_btfids tool will be used during the vmlinux linking,
so it's necessary it's ready for it.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 Makefile           | 22 ++++++++++++++++++----
 tools/Makefile     |  3 +++
 tools/bpf/Makefile |  9 ++++++++-
 3 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index ac2c61c37a73..017e775b3288 100644
--- a/Makefile
+++ b/Makefile
@@ -1053,9 +1053,10 @@ export mod_sign_cmd
 
 HOST_LIBELF_LIBS = $(shell pkg-config libelf --libs 2>/dev/null || echo -lelf)
 
+has_libelf = $(call try-run,\
+               echo "int main() {}" | $(HOSTCC) -xc -o /dev/null $(HOST_LIBELF_LIBS) -,1,0)
+
 ifdef CONFIG_STACK_VALIDATION
-  has_libelf := $(call try-run,\
-		echo "int main() {}" | $(HOSTCC) -xc -o /dev/null $(HOST_LIBELF_LIBS) -,1,0)
   ifeq ($(has_libelf),1)
     objtool_target := tools/objtool FORCE
   else
@@ -1064,6 +1065,14 @@ ifdef CONFIG_STACK_VALIDATION
   endif
 endif
 
+ifdef CONFIG_DEBUG_INFO_BTF
+  ifeq ($(has_libelf),1)
+    resolve_btfids_target := tools/bpf/resolve_btfids FORCE
+  else
+    ERROR_RESOLVE_BTFIDS := 1
+  endif
+endif
+
 PHONY += prepare0
 
 export MODORDER := $(extmod-prefix)modules.order
@@ -1175,7 +1184,7 @@ prepare0: archprepare
 	$(Q)$(MAKE) $(build)=.
 
 # All the preparing..
-prepare: prepare0 prepare-objtool
+prepare: prepare0 prepare-objtool prepare-resolve_btfids
 
 # Support for using generic headers in asm-generic
 asm-generic := -f $(srctree)/scripts/Makefile.asm-generic obj
@@ -1188,7 +1197,7 @@ uapi-asm-generic:
 	$(Q)$(MAKE) $(asm-generic)=arch/$(SRCARCH)/include/generated/uapi/asm \
 	generic=include/uapi/asm-generic
 
-PHONY += prepare-objtool
+PHONY += prepare-objtool prepare-resolve_btfids
 prepare-objtool: $(objtool_target)
 ifeq ($(SKIP_STACK_VALIDATION),1)
 ifdef CONFIG_UNWINDER_ORC
@@ -1199,6 +1208,11 @@ else
 endif
 endif
 
+prepare-resolve_btfids: $(resolve_btfids_target)
+ifeq ($(ERROR_RESOLVE_BTFIDS),1)
+	@echo "error: Cannot resolve BTF IDs for CONFIG_DEBUG_INFO_BTF, please install libelf-dev, libelf-devel or elfutils-libelf-devel" >&2
+	@false
+endif
 # Generate some files
 # ---------------------------------------------------------------------------
 
diff --git a/tools/Makefile b/tools/Makefile
index bd778812e915..85af6ebbce91 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -67,6 +67,9 @@ cpupower: FORCE
 cgroup firewire hv guest bootconfig spi usb virtio vm bpf iio gpio objtool leds wmi pci firmware debugging: FORCE
 	$(call descend,$@)
 
+bpf/%: FORCE
+	$(call descend,$@)
+
 liblockdep: FORCE
 	$(call descend,lib/lockdep)
 
diff --git a/tools/bpf/Makefile b/tools/bpf/Makefile
index 6df1850f8353..74bc9a105225 100644
--- a/tools/bpf/Makefile
+++ b/tools/bpf/Makefile
@@ -123,5 +123,12 @@ runqslower_install:
 runqslower_clean:
 	$(call descend,runqslower,clean)
 
+resolve_btfids:
+	$(call descend,resolve_btfids)
+
+resolve_btfids_clean:
+	$(call descend,resolve_btfids,clean)
+
 .PHONY: all install clean bpftool bpftool_install bpftool_clean \
-	runqslower runqslower_install runqslower_clean
+	runqslower runqslower_install runqslower_clean \
+	resolve_btfids resolve_btfids_clean
-- 
2.25.4

