Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6CD049380C
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 11:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353541AbiASKQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 05:16:04 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:47562 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353474AbiASKP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 05:15:59 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: usama.anjum)
        with ESMTPSA id 4AD4A1F4442B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1642587356;
        bh=gjVHu+jWyShCzwYH7u0I9MtX/la4ZTeWCA5VgFyOCk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WmPQKScNKXIubsHhUPQ0UWTMbZea42T4UR9/BPGN2ahBB8XcJiVrhQIYF6BZ5hlX0
         q8gp7LUxCSQFElIffyo0lDWVGD/zC2KBugbqEh1TcLrlatMGeZfU8rimVe4dL/fbcX
         6s9z2ZfRvciZcnZtAIaztjLlNW7+HElw+ZF++XYNpZYCnprNkUvvOJXvFUMri1oVTL
         c60tiiXFIJwZbREPLPZA6Wqzrnm+ezgrofEvBRqJOEVHxoMBzoDDzHdIvnljxq7UW1
         YscwBUloUa1M8a5eTGAa8VhR0L/h5p9Vazp/3TXlZknKFvePVk6yZDZl7g0bc1CdND
         Xb+nwl8+gV8YA==
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
To:     Shuah Khan <shuah@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        chiminghao <chi.minghao@zte.com.cn>,
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK),
        linux-kernel@vger.kernel.org (open list),
        kvm@vger.kernel.org (open list:KERNEL VIRTUAL MACHINE (KVM)),
        linux-security-module@vger.kernel.org (open list:LANDLOCK SECURITY
        MODULE), netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        mptcp@lists.linux.dev (open list:NETWORKING [MPTCP]),
        linux-mm@kvack.org (open list:MEMORY MANAGEMENT)
Cc:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        kernel@collabora.com
Subject: [PATCH V2 01/10] selftests: set the BUILD variable to absolute path
Date:   Wed, 19 Jan 2022 15:15:22 +0500
Message-Id: <20220119101531.2850400-2-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220119101531.2850400-1-usama.anjum@collabora.com>
References: <20220119101531.2850400-1-usama.anjum@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The build of kselftests fails if relative path is specified through
KBUILD_OUTPUT or O=<path> method. BUILD variable is used to determine
the path of the output objects. When make is run from other directories
with relative paths, the exact path of the build objects is ambiguous
and build fails.

	make[1]: Entering directory '/home/usama/repos/kernel/linux_mainline2/tools/testing/selftests/alsa'
	gcc     mixer-test.c -L/usr/lib/x86_64-linux-gnu -lasound  -o build/kselftest/alsa/mixer-test
	/usr/bin/ld: cannot open output file build/kselftest/alsa/mixer-test

Set the BUILD variable to the absolute path of the output directory.
Make the logic readable and easy to follow. Use spaces instead of tabs
for indentation as if with tab indentation is considered recipe in make.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
 tools/testing/selftests/Makefile | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index d08fe4cfe811..a7b63860b7bc 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -114,19 +114,27 @@ ifdef building_out_of_srctree
 override LDFLAGS =
 endif
 
-ifneq ($(O),)
-	BUILD := $(O)/kselftest
+top_srcdir ?= ../../..
+
+ifeq ("$(origin O)", "command line")
+  KBUILD_OUTPUT := $(O)
+endif
+
+ifneq ($(KBUILD_OUTPUT),)
+  # Make's built-in functions such as $(abspath ...), $(realpath ...) cannot
+  # expand a shell special character '~'. We use a somewhat tedious way here.
+  abs_objtree := $(shell cd $(top_srcdir) && mkdir -p $(KBUILD_OUTPUT) && cd $(KBUILD_OUTPUT) && pwd)
+  $(if $(abs_objtree),, \
+    $(error failed to create output directory "$(KBUILD_OUTPUT)"))
+  # $(realpath ...) resolves symlinks
+  abs_objtree := $(realpath $(abs_objtree))
+  BUILD := $(abs_objtree)/kselftest
 else
-	ifneq ($(KBUILD_OUTPUT),)
-		BUILD := $(KBUILD_OUTPUT)/kselftest
-	else
-		BUILD := $(shell pwd)
-		DEFAULT_INSTALL_HDR_PATH := 1
-	endif
+  BUILD := $(CURDIR)
+  DEFAULT_INSTALL_HDR_PATH := 1
 endif
 
 # Prepare for headers install
-top_srcdir ?= ../../..
 include $(top_srcdir)/scripts/subarch.include
 ARCH           ?= $(SUBARCH)
 export KSFT_KHDR_INSTALL_DONE := 1
-- 
2.30.2

