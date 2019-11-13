Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23DCDFA0EE
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 02:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728703AbfKMBxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 20:53:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:43914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728686AbfKMBxw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 20:53:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0F67222CD;
        Wed, 13 Nov 2019 01:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610030;
        bh=7kkQdKM17MDDKEtGn+Zxkx5RKER3gUy2kCYhpw782+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=azWy3I/gL/mms2CtiGKHtEGeZpddEd9BKaVm3rARQ1SwHULq+838OppUiFxoiFJ6n
         K7rWjSvB28sSHFBGK2lU9QJzqrOWlP2qfc9U6D3/cOkLpcOgiGdgcg+saEAg2dLeNi
         y2J8EkSbYwDUvLYwTPr0T0Q+cPYTyNy+FZWGduuc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Davide Caratti <dcaratti@redhat.com>,
        Lucas Bates <lucasb@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.19 124/209] tc-testing: fix build of eBPF programs
Date:   Tue, 12 Nov 2019 20:49:00 -0500
Message-Id: <20191113015025.9685-124-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit cf5eafbfa586d030f9321cee516b91d089e38280 ]

rely on uAPI headers in the current kernel tree, rather than requiring the
correct version installed on the test system. While at it, group all
sections in a single binary and test the 'section' parameter.

Reported-by: Lucas Bates <lucasb@mojatatu.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/tc-testing/bpf/Makefile | 29 +++++++++++++++++++
 .../testing/selftests/tc-testing/bpf/action.c | 23 +++++++++++++++
 .../tc-testing/tc-tests/actions/bpf.json      | 16 +++++-----
 .../selftests/tc-testing/tdc_config.py        |  4 ++-
 4 files changed, 63 insertions(+), 9 deletions(-)
 create mode 100644 tools/testing/selftests/tc-testing/bpf/Makefile
 create mode 100644 tools/testing/selftests/tc-testing/bpf/action.c

diff --git a/tools/testing/selftests/tc-testing/bpf/Makefile b/tools/testing/selftests/tc-testing/bpf/Makefile
new file mode 100644
index 0000000000000..dc92eb271d9a1
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/bpf/Makefile
@@ -0,0 +1,29 @@
+# SPDX-License-Identifier: GPL-2.0
+
+APIDIR := ../../../../include/uapi
+TEST_GEN_FILES = action.o
+
+top_srcdir = ../../../../..
+include ../../lib.mk
+
+CLANG ?= clang
+LLC   ?= llc
+PROBE := $(shell $(LLC) -march=bpf -mcpu=probe -filetype=null /dev/null 2>&1)
+
+ifeq ($(PROBE),)
+  CPU ?= probe
+else
+  CPU ?= generic
+endif
+
+CLANG_SYS_INCLUDES := $(shell $(CLANG) -v -E - </dev/null 2>&1 \
+	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }')
+
+CLANG_FLAGS = -I. -I$(APIDIR) \
+	      $(CLANG_SYS_INCLUDES) \
+	      -Wno-compare-distinct-pointer-types
+
+$(OUTPUT)/%.o: %.c
+	$(CLANG) $(CLANG_FLAGS) \
+		 -O2 -target bpf -emit-llvm -c $< -o - |      \
+	$(LLC) -march=bpf -mcpu=$(CPU) $(LLC_FLAGS) -filetype=obj -o $@
diff --git a/tools/testing/selftests/tc-testing/bpf/action.c b/tools/testing/selftests/tc-testing/bpf/action.c
new file mode 100644
index 0000000000000..c32b99b80e19e
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/bpf/action.c
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0
+ * Copyright (c) 2018 Davide Caratti, Red Hat inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ */
+
+#include <linux/bpf.h>
+#include <linux/pkt_cls.h>
+
+__attribute__((section("action-ok"),used)) int action_ok(struct __sk_buff *s)
+{
+	return TC_ACT_OK;
+}
+
+__attribute__((section("action-ko"),used)) int action_ko(struct __sk_buff *s)
+{
+	s->data = 0x0;
+	return TC_ACT_OK;
+}
+
+char _license[] __attribute__((section("license"),used)) = "GPL";
diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/bpf.json b/tools/testing/selftests/tc-testing/tc-tests/actions/bpf.json
index 6f289a49e5ecf..1a9b282dd0be2 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/bpf.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/bpf.json
@@ -55,7 +55,7 @@
             "bpf"
         ],
         "setup": [
-            "printf '#include <linux/bpf.h>\nchar l[] __attribute__((section(\"license\"),used))=\"GPL\"; __attribute__((section(\"action\"),used)) int m(struct __sk_buff *s) { return 2; }' | clang -O2 -x c -c - -target bpf -o _b.o",
+            "make -C bpf",
             [
                 "$TC action flush action bpf",
                 0,
@@ -63,14 +63,14 @@
                 255
             ]
         ],
-        "cmdUnderTest": "$TC action add action bpf object-file _b.o index 667",
+        "cmdUnderTest": "$TC action add action bpf object-file $EBPFDIR/action.o section action-ok index 667",
         "expExitCode": "0",
         "verifyCmd": "$TC action get action bpf index 667",
-        "matchPattern": "action order [0-9]*: bpf _b.o:\\[action\\] id [0-9]* tag 3b185187f1855c4c( jited)? default-action pipe.*index 667 ref",
+        "matchPattern": "action order [0-9]*: bpf action.o:\\[action-ok\\] id [0-9]* tag [0-9a-f]{16}( jited)? default-action pipe.*index 667 ref",
         "matchCount": "1",
         "teardown": [
             "$TC action flush action bpf",
-            "rm -f _b.o"
+            "make -C bpf clean"
         ]
     },
     {
@@ -81,7 +81,7 @@
             "bpf"
         ],
         "setup": [
-            "printf '#include <linux/bpf.h>\nchar l[] __attribute__((section(\"license\"),used))=\"GPL\"; __attribute__((section(\"action\"),used)) int m(struct __sk_buff *s) { s->data = 0x0; return 2; }' | clang -O2 -x c -c - -target bpf -o _c.o",
+            "make -C bpf",
             [
                 "$TC action flush action bpf",
                 0,
@@ -89,10 +89,10 @@
                 255
             ]
         ],
-        "cmdUnderTest": "$TC action add action bpf object-file _c.o index 667",
+        "cmdUnderTest": "$TC action add action bpf object-file $EBPFDIR/action.o section action-ko index 667",
         "expExitCode": "255",
         "verifyCmd": "$TC action get action bpf index 667",
-        "matchPattern": "action order [0-9]*: bpf _c.o:\\[action\\] id [0-9].*index 667 ref",
+        "matchPattern": "action order [0-9]*: bpf action.o:\\[action-ko\\] id [0-9].*index 667 ref",
         "matchCount": "0",
         "teardown": [
             [
@@ -101,7 +101,7 @@
                 1,
                 255
             ],
-            "rm -f _c.o"
+            "make -C bpf clean"
         ]
     },
     {
diff --git a/tools/testing/selftests/tc-testing/tdc_config.py b/tools/testing/selftests/tc-testing/tdc_config.py
index a023d0d62b25c..d651bc1501bdb 100644
--- a/tools/testing/selftests/tc-testing/tdc_config.py
+++ b/tools/testing/selftests/tc-testing/tdc_config.py
@@ -16,7 +16,9 @@ NAMES = {
           'DEV2': '',
           'BATCH_FILE': './batch.txt',
           # Name of the namespace to use
-          'NS': 'tcut'
+          'NS': 'tcut',
+          # Directory containing eBPF test programs
+          'EBPFDIR': './bpf'
         }
 
 
-- 
2.20.1

