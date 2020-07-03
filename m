Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5719E21380F
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 11:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbgGCJvf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 3 Jul 2020 05:51:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29349 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726112AbgGCJvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 05:51:33 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-Xe6m8ymjOhqryvC5s0Bu2A-1; Fri, 03 Jul 2020 05:51:28 -0400
X-MC-Unique: Xe6m8ymjOhqryvC5s0Bu2A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1AF68015F5;
        Fri,  3 Jul 2020 09:51:25 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.194.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B5B17AC6C;
        Fri,  3 Jul 2020 09:51:21 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v5 bpf-next 2/9] bpf: Compile resolve_btfids tool at kernel compilation start
Date:   Fri,  3 Jul 2020 11:51:04 +0200
Message-Id: <20200703095111.3268961-3-jolsa@kernel.org>
In-Reply-To: <20200703095111.3268961-1-jolsa@kernel.org>
References: <20200703095111.3268961-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
index ae5d8220f431..8db4fd8097e0 100644
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

