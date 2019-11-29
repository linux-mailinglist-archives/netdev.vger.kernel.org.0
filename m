Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B49E10D13C
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 07:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfK2GDM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 29 Nov 2019 01:03:12 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:48099 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727047AbfK2GDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 01:03:11 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iaZMi-0008I2-HE; Fri, 29 Nov 2019 07:02:52 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 384291C2102;
        Fri, 29 Nov 2019 07:02:51 +0100 (CET)
Date:   Fri, 29 Nov 2019 06:02:51 -0000
From:   "tip-bot2 for Jiri Olsa" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] perf tools: Allow to link with libbpf dynamicaly
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        toke@redhat.com,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20191126121253.28253-1-jolsa@kernel.org>
References: <20191126121253.28253-1-jolsa@kernel.org>
MIME-Version: 1.0
Message-ID: <157500737114.21853.14426283162041132071.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     7b65e2034fde011d090d4ec472902b71129c6cbd
Gitweb:        https://git.kernel.org/tip/7b65e2034fde011d090d4ec472902b71129c6cbd
Author:        Jiri Olsa <jolsa@kernel.org>
AuthorDate:    Tue, 26 Nov 2019 13:12:53 +01:00
Committer:     Arnaldo Carvalho de Melo <acme@redhat.com>
CommitterDate: Tue, 26 Nov 2019 11:17:45 -03:00

perf tools: Allow to link with libbpf dynamicaly

Currently we support only static linking with kernel's libbpf
(tools/lib/bpf). This patch adds libbpf package detection and support to
link perf with it dynamically.

The libbpf package status is displayed with:

  $ make VF=1
  Auto-detecting system features:
  ...
  ...                        libbpf: [ on  ]

It's not checked by default, because it's quite new.  Once it's on most
distros we can switch it on.

For the same reason it's not added to the test-all check.

Perf does not need advanced version of libbpf, so we can check just for
the base bpf_object__open function.

Adding new compile variable to detect libbpf package and link bpf
dynamically:

  $ make LIBBPF_DYNAMIC=1
    ...
    LINK     perf
  $ ldd perf | grep bpf
    libbpf.so.0 => /lib64/libbpf.so.0 (0x00007f46818bc000)

If libbpf is not installed, build stops with:

  Makefile.config:486: *** Error: No libbpf devel library found,\
  please install libbpf-devel.  Stop.

Committer testing:

  $ make LIBBPF_DYNAMIC=1 -C tools/perf O=/tmp/build/perf
  make: Entering directory '/home/acme/git/perf/tools/perf'
    BUILD:   Doing 'make -j8' parallel build
  Makefile.config:493: *** Error: No libbpf devel library found, please install libbpf-devel.  Stop.
  make[1]: *** [Makefile.perf:225: sub-make] Error 2
  make: *** [Makefile:70: all] Error 2
  make: Leaving directory '/home/acme/git/perf/tools/perf'
  $

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Toke Høiland-Jørgensen <toke@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrii Nakryiko <andriin@fb.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: bpf@vger.kernel.org
Cc: netdev@vger.kernel.org
Link: http://lore.kernel.org/lkml/20191126121253.28253-1-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/build/Makefile.feature      |  3 ++-
 tools/build/feature/Makefile      |  4 ++++
 tools/build/feature/test-libbpf.c |  7 +++++++
 tools/perf/Makefile.config        | 10 ++++++++++
 tools/perf/Makefile.perf          |  6 +++++-
 5 files changed, 28 insertions(+), 2 deletions(-)
 create mode 100644 tools/build/feature/test-libbpf.c

diff --git a/tools/build/Makefile.feature b/tools/build/Makefile.feature
index 8a19753..574c2e0 100644
--- a/tools/build/Makefile.feature
+++ b/tools/build/Makefile.feature
@@ -96,7 +96,8 @@ FEATURE_TESTS_EXTRA :=                  \
          cxx                            \
          llvm                           \
          llvm-version                   \
-         clang
+         clang                          \
+         libbpf
 
 FEATURE_TESTS ?= $(FEATURE_TESTS_BASIC)
 
diff --git a/tools/build/feature/Makefile b/tools/build/feature/Makefile
index 8499385..f30a890 100644
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -53,6 +53,7 @@ FILES=                                          \
          test-zlib.bin                          \
          test-lzma.bin                          \
          test-bpf.bin                           \
+         test-libbpf.bin                        \
          test-get_cpuid.bin                     \
          test-sdt.bin                           \
          test-cxx.bin                           \
@@ -270,6 +271,9 @@ $(OUTPUT)test-get_cpuid.bin:
 $(OUTPUT)test-bpf.bin:
 	$(BUILD)
 
+$(OUTPUT)test-libbpf.bin:
+	$(BUILD) -lbpf
+
 $(OUTPUT)test-sdt.bin:
 	$(BUILD)
 
diff --git a/tools/build/feature/test-libbpf.c b/tools/build/feature/test-libbpf.c
new file mode 100644
index 0000000..a508756
--- /dev/null
+++ b/tools/build/feature/test-libbpf.c
@@ -0,0 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <bpf/libbpf.h>
+
+int main(void)
+{
+	return bpf_object__open("test") ? 0 : -1;
+}
diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index 1783427..c90f414 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -483,6 +483,16 @@ ifndef NO_LIBELF
     ifeq ($(feature-bpf), 1)
       CFLAGS += -DHAVE_LIBBPF_SUPPORT
       $(call detected,CONFIG_LIBBPF)
+
+      # detecting libbpf without LIBBPF_DYNAMIC, so make VF=1 shows libbpf detection status
+      $(call feature_check,libbpf)
+      ifdef LIBBPF_DYNAMIC
+        ifeq ($(feature-libbpf), 1)
+          EXTLIBS += -lbpf
+        else
+          dummy := $(error Error: No libbpf devel library found, please install libbpf-devel);
+        endif
+      endif
     endif
 
     ifndef NO_DWARF
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 1cd2944..eae5d5e 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -116,6 +116,8 @@ include ../scripts/utilities.mak
 #
 # Define TCMALLOC to enable tcmalloc heap profiling.
 #
+# Define LIBBPF_DYNAMIC to enable libbpf dynamic linking.
+#
 
 # As per kernel Makefile, avoid funny character set dependencies
 unexport LC_ALL
@@ -360,7 +362,9 @@ export PERL_PATH
 
 PERFLIBS = $(LIBAPI) $(LIBTRACEEVENT) $(LIBSUBCMD) $(LIBPERF)
 ifndef NO_LIBBPF
-  PERFLIBS += $(LIBBPF)
+  ifndef LIBBPF_DYNAMIC
+    PERFLIBS += $(LIBBPF)
+  endif
 endif
 
 # We choose to avoid "if .. else if .. else .. endif endif"
