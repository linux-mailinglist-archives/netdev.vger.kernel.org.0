Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC0EE10ACD9
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 10:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbfK0Js6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 27 Nov 2019 04:48:58 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24050 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726133AbfK0Js5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 04:48:57 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-DSEZju5GNVqQ6TsiR2Jrkg-1; Wed, 27 Nov 2019 04:48:52 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B238780183C;
        Wed, 27 Nov 2019 09:48:50 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E2215D6C8;
        Wed, 27 Nov 2019 09:48:47 +0000 (UTC)
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
Subject: [PATCH 1/3] perf tools: Allow to specify libbpf install directory
Date:   Wed, 27 Nov 2019 10:48:35 +0100
Message-Id: <20191127094837.4045-2-jolsa@kernel.org>
In-Reply-To: <20191127094837.4045-1-jolsa@kernel.org>
References: <20191127094837.4045-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: DSEZju5GNVqQ6TsiR2Jrkg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding LIBBPF_DIR compile variable to allow linking with
libbpf installed into specific directory:

  $ make -C tools/lib/bpf/ prefix=/tmp/libbpf/ install_lib install_headers
  $ make -C tools/perf/ LIBBPF_DYNAMIC=1 LIBBPF_DIR=/tmp/libbpf/

It might be needed to clean build tree first because features
framework does not detect the change properly:

  $ make -C tools/build/feature clean
  $ make -C tools/perf/ clean

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/Makefile.config | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index c90f4146e5a2..eb9d9b70b7d3 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -22,6 +22,14 @@ include $(srctree)/tools/scripts/Makefile.arch
 
 $(call detected_var,SRCARCH)
 
+ifndef lib
+  ifeq ($(SRCARCH)$(IS_64_BIT), x861)
+    lib = lib64
+  else
+    lib = lib
+  endif
+endif # lib
+
 NO_PERF_REGS := 1
 NO_SYSCALL_TABLE := 1
 
@@ -484,11 +492,22 @@ ifndef NO_LIBELF
       CFLAGS += -DHAVE_LIBBPF_SUPPORT
       $(call detected,CONFIG_LIBBPF)
 
+      # for linking with debug library run:
+      # make DEBUG=1 LIBBPF_DIR=/opt/libbpf
+      ifdef LIBBPF_DIR
+        LIBBPF_CFLAGS  := -I$(LIBBPF_DIR)/include
+        LIBBPF_LDFLAGS := -L$(LIBBPF_DIR)/$(lib)
+        FEATURE_CHECK_CFLAGS-libbpf  := $(LIBBPF_CFLAGS)
+        FEATURE_CHECK_LDFLAGS-libbpf := $(LIBBPF_LDFLAGS)
+      endif
+
       # detecting libbpf without LIBBPF_DYNAMIC, so make VF=1 shows libbpf detection status
       $(call feature_check,libbpf)
       ifdef LIBBPF_DYNAMIC
         ifeq ($(feature-libbpf), 1)
           EXTLIBS += -lbpf
+          CFLAGS  += $(LIBBPF_CFLAGS)
+          LDFLAGS += $(LIBBPF_LDFLAGS)
         else
           dummy := $(error Error: No libbpf devel library found, please install libbpf-devel);
         endif
@@ -1037,13 +1056,6 @@ else
 sysconfdir = $(prefix)/etc
 ETC_PERFCONFIG = etc/perfconfig
 endif
-ifndef lib
-ifeq ($(SRCARCH)$(IS_64_BIT), x861)
-lib = lib64
-else
-lib = lib
-endif
-endif # lib
 libdir = $(prefix)/$(lib)
 
 # Shell quote (do not use $(call) to accommodate ancient setups);
@@ -1108,6 +1120,7 @@ ifeq ($(VF),1)
   $(call print_var,LIBUNWIND_DIR)
   $(call print_var,LIBDW_DIR)
   $(call print_var,JDIR)
+  $(call print_var,LIBBPF_DIR)
 
   ifeq ($(dwarf-post-unwind),1)
     $(call feature_print_text,"DWARF post unwind library", $(dwarf-post-unwind-text))
-- 
2.21.0

