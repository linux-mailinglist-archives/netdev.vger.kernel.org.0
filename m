Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7A510ACDF
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 10:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbfK0JtF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 27 Nov 2019 04:49:05 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52881 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727031AbfK0JtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 04:49:04 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-N8QNudZsNuOKTM7DqNQzcw-1; Wed, 27 Nov 2019 04:49:00 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB3FB107ACE3;
        Wed, 27 Nov 2019 09:48:57 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A52305D6C8;
        Wed, 27 Nov 2019 09:48:54 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH 3/3] bpftool: Allow to link libbpf dynamically
Date:   Wed, 27 Nov 2019 10:48:37 +0100
Message-Id: <20191127094837.4045-4-jolsa@kernel.org>
In-Reply-To: <20191127094837.4045-1-jolsa@kernel.org>
References: <20191127094837.4045-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: N8QNudZsNuOKTM7DqNQzcw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we support only static linking with kernel's libbpf
(tools/lib/bpf). This patch adds LIBBPF_DYNAMIC compile variable
that triggers libbpf detection and bpf dynamic linking:

  $ make -C tools/bpf/bpftool make LIBBPF_DYNAMIC=1

If libbpf is not installed, build (with LIBBPF_DYNAMIC=1) stops with:

  $ make -C tools/bpf/bpftool LIBBPF_DYNAMIC=1
    Auto-detecting system features:
    ...                        libbfd: [ on  ]
    ...        disassembler-four-args: [ on  ]
    ...                          zlib: [ on  ]
    ...                        libbpf: [ OFF ]

  Makefile:102: *** Error: libbpf-devel is missing, please install it.  Stop.

Adding specific bpftool's libbpf check for libbpf_netlink_open (LIBBPF_0.0.6)
which is the latest we need for bpftool at the moment.

Adding LIBBPF_DIR compile variable to allow linking with
libbpf installed into specific directory:

  $ make -C tools/lib/bpf/ prefix=/tmp/libbpf/ install_lib install_headers
  $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=1 LIBBPF_DIR=/tmp/libbpf/

It might be needed to clean build tree first because features
framework does not detect the change properly:

  $ make -C tools/build/feature clean
  $ make -C tools/bpf/bpftool/ clean

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/bpf/bpftool/Makefile        | 40 ++++++++++++++++++++++++++++++-
 tools/build/feature/test-libbpf.c |  9 +++++++
 2 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 39bc6f0f4f0b..2b6ed08cb31e 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -1,6 +1,15 @@
 # SPDX-License-Identifier: GPL-2.0-only
+# LIBBPF_DYNAMIC to enable libbpf dynamic linking.
+
 include ../../scripts/Makefile.include
 include ../../scripts/utilities.mak
+include ../../scripts/Makefile.arch
+
+ifeq ($(LP64), 1)
+  libdir_relative = lib64
+else
+  libdir_relative = lib
+endif
 
 ifeq ($(srctree),)
 srctree := $(patsubst %/,%,$(dir $(CURDIR)))
@@ -55,7 +64,7 @@ ifneq ($(EXTRA_LDFLAGS),)
 LDFLAGS += $(EXTRA_LDFLAGS)
 endif
 
-LIBS = $(LIBBPF) -lelf -lz
+LIBS = -lelf -lz
 
 INSTALL ?= install
 RM ?= rm -f
@@ -64,6 +73,23 @@ FEATURE_USER = .bpftool
 FEATURE_TESTS = libbfd disassembler-four-args reallocarray zlib
 FEATURE_DISPLAY = libbfd disassembler-four-args zlib
 
+ifdef LIBBPF_DYNAMIC
+  # Add libbpf check with the flags to ensure bpftool
+  # specific version is detected.
+  FEATURE_CHECK_CFLAGS-libbpf := -DBPFTOOL
+  FEATURE_TESTS   += libbpf
+  FEATURE_DISPLAY += libbpf
+
+  # for linking with debug library run:
+  # make LIBBPF_DYNAMIC=1 LIBBPF_DIR=/opt/libbpf
+  ifdef LIBBPF_DIR
+    LIBBPF_CFLAGS  := -I$(LIBBPF_DIR)/include
+    LIBBPF_LDFLAGS := -L$(LIBBPF_DIR)/$(libdir_relative)
+    FEATURE_CHECK_CFLAGS-libbpf  := $(LIBBPF_CFLAGS)
+    FEATURE_CHECK_LDFLAGS-libbpf := $(LIBBPF_LDFLAGS)
+  endif
+endif
+
 check_feat := 1
 NON_CHECK_FEAT_TARGETS := clean uninstall doc doc-clean doc-install doc-uninstall
 ifdef MAKECMDGOALS
@@ -88,6 +114,18 @@ ifeq ($(feature-reallocarray), 0)
 CFLAGS += -DCOMPAT_NEED_REALLOCARRAY
 endif
 
+ifdef LIBBPF_DYNAMIC
+  ifeq ($(feature-libbpf), 1)
+    LIBS    += -lbpf
+    CFLAGS  += $(LIBBPF_CFLAGS)
+    LDFLAGS += $(LIBBPF_LDFLAGS)
+  else
+    dummy := $(error Error: No libbpf devel library found, please install libbpf-devel)
+  endif
+else
+  LIBS += $(LIBBPF)
+endif
+
 include $(wildcard $(OUTPUT)*.d)
 
 all: $(OUTPUT)bpftool
diff --git a/tools/build/feature/test-libbpf.c b/tools/build/feature/test-libbpf.c
index a508756cf4cc..93566d105a64 100644
--- a/tools/build/feature/test-libbpf.c
+++ b/tools/build/feature/test-libbpf.c
@@ -3,5 +3,14 @@
 
 int main(void)
 {
+#ifdef BPFTOOL
+	/*
+	 * libbpf_netlink_open (LIBBPF_0.0.6) is the latest
+	 * we need for bpftool at the moment
+	 */
+	libbpf_netlink_open(NULL);
+	return 0;
+#else
 	return bpf_object__open("test") ? 0 : -1;
+#endif
 }
-- 
2.21.0

