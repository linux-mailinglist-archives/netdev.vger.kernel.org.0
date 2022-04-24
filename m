Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64A0550CFBD
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 07:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238246AbiDXFNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 01:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238228AbiDXFNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 01:13:43 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56877B1E;
        Sat, 23 Apr 2022 22:10:42 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 2B207C021; Sun, 24 Apr 2022 07:10:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1650777041; bh=wnaQmB/OwGIOtKdRHm+IOTugJI2pRqMAdNdx5pQ7kzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jAl2c+qYxGYnCs4n+hsrIsmM4PADw8in+63+nixCeLXfZ/CHQf+7F8G1Qjrc7Kjzg
         uf6RguKXAbLvg+ERK2xXSDfTiUVHHSOVr3YCibtAxhDJP1K5B8mqxLbVXRQMxQQuNP
         NIei81d9tLesyB78eXE0dQZIuJVmRLdUSsES0GRz9RkYXGkb4EDoUvnt0P6caPSROR
         nSEuWaShiePbMDtd4xKukqw+rLCtsyW9BAQbRK60Y/sVigrAc3FfrLOigqKc6ic9Fl
         aPWW79yA4csxrXqoG0wbxdecGGLJkivbVPbzSttZZ1kIjWjQudn1q2Kz1sLQuFpq83
         MZh7aOeCkOTgA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id E99E0C01D;
        Sun, 24 Apr 2022 07:10:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1650777040; bh=wnaQmB/OwGIOtKdRHm+IOTugJI2pRqMAdNdx5pQ7kzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hpLemM1y73xMSYxt5t47CmkkobilnVQay0gmcSQ4V3i8qXFNoszr3CK/plzm8D5Xm
         ACGOB5pvo5TAibicjEp2jHbM0RvLk+vsCxMyYJMBkRUjwtqp87Gu1eaV+4rAzAtZig
         IB97yh9r7TXV2fKLLkGpaAXGGGXy39xrnwLECQFVl08cGJSDNPZUvqRZaWpEypnVvB
         C8vbr3/qDNgQR1j6yfrVRCf95UdgUM64aSDuDZ5HS/gCiRF/TpCXvl0AoK8GNAtj0i
         4CPv397WQ/kSYZQpEs4uRKCDqFvQd8kQ91aKa02ttP1sqLczUUJW9ZOwpkESQ/kzbI
         vIbt+3RQdiArQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 8d80284b;
        Sun, 24 Apr 2022 05:10:26 +0000 (UTC)
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 1/4] tools/bpf/runqslower: musl compat: explicitly link with libargp if found
Date:   Sun, 24 Apr 2022 14:10:19 +0900
Message-Id: <20220424051022.2619648-2-asmadeus@codewreck.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220424051022.2619648-1-asmadeus@codewreck.org>
References: <20220424051022.2619648-1-asmadeus@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

musl doesn't implement argp.h and requires an explicit lib for it, so
we must test for -largp presence and use it if appropriate

Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---

After having done this work I noticed runqslower is not actually
installed, so ideally instead of all of this it'd make more sense to
just not build it: would it make sense to take it out of the defaults
build targets?
I could just directly build the appropriate targets from tools/bpf
directory with 'make bpftool bpf_dbg bpf_asm bpf_jit_disasm', but
ideally I'd like to keep alpine's build script way of calling make from
the tools parent directory, and 'make bpf' there is all or nothing.


OTOH, we might as well keep this to allow people on alpine/void linux to
build runqslower if they want to. I didn't add libargp to default features
check so it shouldn't change much except for runqslower itself.
As an example it might be better to keep it independant from kbuild but
it already wasn't so I don't see much harm here.

 tools/bpf/runqslower/Makefile      | 30 +++++++++++++++++++++++++++++-
 tools/build/feature/Makefile       |  4 ++++
 tools/build/feature/test-all.c     |  4 ++++
 tools/build/feature/test-libargp.c | 14 ++++++++++++++
 4 files changed, 51 insertions(+), 1 deletion(-)
 create mode 100644 tools/build/feature/test-libargp.c

diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefile
index da6de16a3dfb..20a1d9a2a908 100644
--- a/tools/bpf/runqslower/Makefile
+++ b/tools/bpf/runqslower/Makefile
@@ -23,6 +23,34 @@ VMLINUX_BTF_PATHS := $(if $(O),$(O)/vmlinux)		\
 VMLINUX_BTF_PATH := $(or $(VMLINUX_BTF),$(firstword			       \
 					  $(wildcard $(VMLINUX_BTF_PATHS))))
 
+# musl requires linking with an external libargp
+FEATURE_USER = .runqslower
+FEATURE_TEST = libargp
+FEATURE_DISPLAY =
+
+check_feat := 1
+NON_CHECK_FEAT_TARGETS := clean
+ifdef MAKECMDGOALS
+ifeq ($(filter-out $(NON_CHECK_FEAT_TARGETS),$(MAKECMDGOALS)),)
+  check_feat := 0
+endif
+endif
+
+ifeq ($(check_feat),1)
+ifeq ($(FEATURES_DUMP),)
+srctree := $(abspath ../../..)
+include $(srctree)/tools/build/Makefile.feature
+else
+include $(FEATURES_DUMP)
+endif
+endif
+
+LIBS = -lelf -lz
+$(call feature_check,libargp)
+ifeq ($(feature-libargp), 1)
+LIBS += -largp
+endif
+
 ifeq ($(V),1)
 Q =
 else
@@ -49,7 +77,7 @@ clean:
 libbpf_hdrs: $(BPFOBJ)
 
 $(OUTPUT)/runqslower: $(OUTPUT)/runqslower.o $(BPFOBJ)
-	$(QUIET_LINK)$(CC) $(CFLAGS) $^ -lelf -lz -o $@
+	$(QUIET_LINK)$(CC) $(CFLAGS) $^ $(LIBS) -o $@
 
 $(OUTPUT)/runqslower.o: runqslower.h $(OUTPUT)/runqslower.skel.h	      \
 			$(OUTPUT)/runqslower.bpf.o | libbpf_hdrs
diff --git a/tools/build/feature/Makefile b/tools/build/feature/Makefile
index de66e1cc0734..ceb4224a0ede 100644
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -37,6 +37,7 @@ FILES=                                          \
          test-libtraceevent.bin                 \
          test-libtracefs.bin                    \
          test-libcrypto.bin                     \
+         test-libargp.bin                       \
          test-libunwind.bin                     \
          test-libunwind-debug-frame.bin         \
          test-libunwind-x86.bin                 \
@@ -205,6 +206,9 @@ $(OUTPUT)test-libtracefs.bin:
 $(OUTPUT)test-libcrypto.bin:
 	$(BUILD) -lcrypto
 
+$(OUTPUT)test-libargp.bin:
+	$(BUILD) -largp
+
 $(OUTPUT)test-gtk2.bin:
 	$(BUILD) $(shell $(PKG_CONFIG) --libs --cflags gtk+-2.0 2>/dev/null) -Wno-deprecated-declarations
 
diff --git a/tools/build/feature/test-all.c b/tools/build/feature/test-all.c
index 5ffafb967b6e..149d3ef4a439 100644
--- a/tools/build/feature/test-all.c
+++ b/tools/build/feature/test-all.c
@@ -146,6 +146,10 @@
 # include "test-libcrypto.c"
 #undef main
 
+#define main main_test_libargp
+# include "test-libargp.c"
+#undef main
+
 #define main main_test_sdt
 # include "test-sdt.c"
 #undef main
diff --git a/tools/build/feature/test-libargp.c b/tools/build/feature/test-libargp.c
new file mode 100644
index 000000000000..63b65d1f11fe
--- /dev/null
+++ b/tools/build/feature/test-libargp.c
@@ -0,0 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <argp.h>
+
+const char *argp_program_version = "test-libargp";
+static const struct argp_option opts[] = { {} };
+
+int main(int argc, char **argv)
+{
+	static const struct argp argp = {
+		.options = opts,
+	};
+	argp_parse(&argp, argc, argv, 0, NULL, NULL);
+	return 0;
+}
-- 
2.35.1

