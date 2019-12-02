Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44F8110EAAD
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 14:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727551AbfLBNTK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 2 Dec 2019 08:19:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48667 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727527AbfLBNTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 08:19:09 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-jWYtbyG7PlG6nn6dqdpm2A-1; Mon, 02 Dec 2019 08:19:05 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F73110054E3;
        Mon,  2 Dec 2019 13:19:03 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DFFDF600C8;
        Mon,  2 Dec 2019 13:18:59 +0000 (UTC)
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
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH 2/6] bpftool: Allow to link libbpf dynamically
Date:   Mon,  2 Dec 2019 14:18:42 +0100
Message-Id: <20191202131847.30837-3-jolsa@kernel.org>
In-Reply-To: <20191202131847.30837-1-jolsa@kernel.org>
References: <20191202131847.30837-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: jWYtbyG7PlG6nn6dqdpm2A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
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

  Makefile:102: *** Error: No libbpf devel library found, please install libbpf-devel or libbpf-dev.

Adding LIBBPF_DIR compile variable to allow linking with
libbpf installed into specific directory:

  $ make -C tools/lib/bpf/ prefix=/tmp/libbpf/ install_lib install_headers
  $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=1 LIBBPF_DIR=/tmp/libbpf/

It might be needed to clean build tree first because features
framework does not detect the change properly:

  $ make -C tools/build/feature clean
  $ make -C tools/bpf/bpftool/ clean

Since bpftool uses bits of libbpf that are not exported as public API in
the .so version, we also pass in libbpf.a to the linker, which allows it to
pick up the private functions from the static library without having to
expose them as ABI.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/bpf/bpftool/Makefile | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 39bc6f0f4f0b..be6dea7eb9fd 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -1,6 +1,21 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+# To link dynamically with libbpf run:
+#   make LIBBPF_DYNAMIC=1
+# build will try to detect installed devel package of libbpf.
+#
+# For linking dynamically with libbpf installed at specific PATH run:
+#   make LIBBPF_DYNAMIC=1 LIBBPF_DIR=<PATH>
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
@@ -63,6 +78,17 @@ RM ?= rm -f
 FEATURE_USER = .bpftool
 FEATURE_TESTS = libbfd disassembler-four-args reallocarray zlib
 FEATURE_DISPLAY = libbfd disassembler-four-args zlib
+ifdef LIBBPF_DYNAMIC
+  FEATURE_TESTS   += libbpf
+  FEATURE_DISPLAY += libbpf
+
+  ifdef LIBBPF_DIR
+    LIBBPF_CFLAGS  := -I$(LIBBPF_DIR)/include
+    LIBBPF_LDFLAGS := -L$(LIBBPF_DIR)/$(libdir_relative)
+    FEATURE_CHECK_CFLAGS-libbpf  := $(LIBBPF_CFLAGS)
+    FEATURE_CHECK_LDFLAGS-libbpf := $(LIBBPF_LDFLAGS)
+  endif
+endif
 
 check_feat := 1
 NON_CHECK_FEAT_TARGETS := clean uninstall doc doc-clean doc-install doc-uninstall
@@ -88,6 +114,18 @@ ifeq ($(feature-reallocarray), 0)
 CFLAGS += -DCOMPAT_NEED_REALLOCARRAY
 endif
 
+ifdef LIBBPF_DYNAMIC
+  ifeq ($(feature-libbpf), 1)
+    # bpftool uses non-exported functions from libbpf, so just add the dynamic
+    # version of libbpf and let the linker figure it out
+    LIBS    := -lbpf $(LIBS)
+    CFLAGS  += $(LIBBPF_CFLAGS)
+    LDFLAGS += $(LIBBPF_LDFLAGS)
+  else
+    dummy := $(error Error: No libbpf devel library found, please install libbpf-devel or libbpf-dev.)
+  endif
+endif
+
 include $(wildcard $(OUTPUT)*.d)
 
 all: $(OUTPUT)bpftool
-- 
2.21.0

