Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04E671C71BC
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 15:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbgEFNa0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 6 May 2020 09:30:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49830 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728667AbgEFNaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 09:30:24 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-kR9gOgttP-K3_9o0J4CVfg-1; Wed, 06 May 2020 09:30:19 -0400
X-MC-Unique: kR9gOgttP-K3_9o0J4CVfg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D139046B;
        Wed,  6 May 2020 13:30:17 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8CC58605F7;
        Wed,  6 May 2020 13:30:14 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>, bgregg@netflix.com,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 6/9] bpf: Compile bpfwl tool at kernel compilation start
Date:   Wed,  6 May 2020 15:29:43 +0200
Message-Id: <20200506132946.2164578-7-jolsa@kernel.org>
In-Reply-To: <20200506132946.2164578-1-jolsa@kernel.org>
References: <20200506132946.2164578-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpfwl tool will be used during the vmlinux linking,
so it's necessary it's ready.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 Makefile           | 21 +++++++++++++++++----
 tools/Makefile     |  3 +++
 tools/bpf/Makefile |  5 ++++-
 3 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index 49b2709ff44e..b0537af523dc 100644
--- a/Makefile
+++ b/Makefile
@@ -1017,9 +1017,10 @@ export mod_sign_cmd
 
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
@@ -1028,6 +1029,14 @@ ifdef CONFIG_STACK_VALIDATION
   endif
 endif
 
+ifdef CONFIG_DEBUG_INFO_BTF
+  ifeq ($(has_libelf),1)
+    bpfwl_target := tools/bpf/bpfwl FORCE
+  else
+    SKIP_BTF_WHITELIST_GENERATION := 1
+  endif
+endif
+
 PHONY += prepare0
 
 export MODORDER := $(extmod-prefix)modules.order
@@ -1141,7 +1150,7 @@ prepare0: archprepare
 	$(Q)$(MAKE) $(build)=.
 
 # All the preparing..
-prepare: prepare0 prepare-objtool
+prepare: prepare0 prepare-objtool prepare-bpfwl
 
 # Support for using generic headers in asm-generic
 asm-generic := -f $(srctree)/scripts/Makefile.asm-generic obj
@@ -1154,7 +1163,7 @@ uapi-asm-generic:
 	$(Q)$(MAKE) $(asm-generic)=arch/$(SRCARCH)/include/generated/uapi/asm \
 	generic=include/uapi/asm-generic
 
-PHONY += prepare-objtool
+PHONY += prepare-objtool prepare-bpfwl
 prepare-objtool: $(objtool_target)
 ifeq ($(SKIP_STACK_VALIDATION),1)
 ifdef CONFIG_UNWINDER_ORC
@@ -1165,6 +1174,10 @@ else
 endif
 endif
 
+prepare-bpfwl: $(bpfwl_target)
+ifeq ($(SKIP_BTF_WHITELIST_GENERATION),1)
+	@echo "warning: Cannot use BTF whitelist checks, please install libelf-dev, libelf-devel or elfutils-libelf-devel" >&2
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
index f897eeeb0b4f..d4ea2b5a2e58 100644
--- a/tools/bpf/Makefile
+++ b/tools/bpf/Makefile
@@ -124,5 +124,8 @@ runqslower_install:
 runqslower_clean:
 	$(call descend,runqslower,clean)
 
+bpfwl:
+	$(call descend,bpfwl)
+
 .PHONY: all install clean bpftool bpftool_install bpftool_clean \
-	runqslower runqslower_install runqslower_clean
+	runqslower runqslower_install runqslower_clean bpfwl
-- 
2.25.4

