Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC971FAD68
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 12:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbgFPKFi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 16 Jun 2020 06:05:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46345 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726261AbgFPKFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 06:05:35 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-pjeXWtzxNaaRByx-W77-7A-1; Tue, 16 Jun 2020 06:05:32 -0400
X-MC-Unique: pjeXWtzxNaaRByx-W77-7A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3669193F587;
        Tue, 16 Jun 2020 10:05:29 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.195.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 42F3E5D9DD;
        Tue, 16 Jun 2020 10:05:23 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 02/11] bpf: Compile btfid tool at kernel compilation start
Date:   Tue, 16 Jun 2020 12:05:03 +0200
Message-Id: <20200616100512.2168860-3-jolsa@kernel.org>
In-Reply-To: <20200616100512.2168860-1-jolsa@kernel.org>
References: <20200616100512.2168860-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The btfid tool will be used during the vmlinux linking,
so it's necessary it's ready for it.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 Makefile           | 22 ++++++++++++++++++----
 tools/Makefile     |  3 +++
 tools/bpf/Makefile |  5 ++++-
 3 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index 839f9fee22cb..b190d502d7d7 100644
--- a/Makefile
+++ b/Makefile
@@ -1066,9 +1066,10 @@ export mod_sign_cmd
 
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
@@ -1077,6 +1078,14 @@ ifdef CONFIG_STACK_VALIDATION
   endif
 endif
 
+ifdef CONFIG_DEBUG_INFO_BTF
+  ifeq ($(has_libelf),1)
+    btfid_target := tools/bpf/btfid FORCE
+  else
+    ERROR_BTF_IDS_RESOLVE := 1
+  endif
+endif
+
 PHONY += prepare0
 
 export MODORDER := $(extmod-prefix)modules.order
@@ -1188,7 +1197,7 @@ prepare0: archprepare
 	$(Q)$(MAKE) $(build)=.
 
 # All the preparing..
-prepare: prepare0 prepare-objtool
+prepare: prepare0 prepare-objtool prepare-btfid
 
 # Support for using generic headers in asm-generic
 asm-generic := -f $(srctree)/scripts/Makefile.asm-generic obj
@@ -1201,7 +1210,7 @@ uapi-asm-generic:
 	$(Q)$(MAKE) $(asm-generic)=arch/$(SRCARCH)/include/generated/uapi/asm \
 	generic=include/uapi/asm-generic
 
-PHONY += prepare-objtool
+PHONY += prepare-objtool prepare-btfid
 prepare-objtool: $(objtool_target)
 ifeq ($(SKIP_STACK_VALIDATION),1)
 ifdef CONFIG_UNWINDER_ORC
@@ -1212,6 +1221,11 @@ else
 endif
 endif
 
+prepare-btfid: $(btfid_target)
+ifeq ($(ERROR_BTF_IDS_RESOLVE),1)
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
index 77472e28c8fd..d8bbe7ef264f 100644
--- a/tools/bpf/Makefile
+++ b/tools/bpf/Makefile
@@ -124,5 +124,8 @@ runqslower_install:
 runqslower_clean:
 	$(call descend,runqslower,clean)
 
+btfid:
+	$(call descend,btfid)
+
 .PHONY: all install clean bpftool bpftool_install bpftool_clean \
-	runqslower runqslower_install runqslower_clean
+	runqslower runqslower_install runqslower_clean btfid
-- 
2.25.4

