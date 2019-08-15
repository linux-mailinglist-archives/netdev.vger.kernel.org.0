Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 348C78EE44
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 16:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732966AbfHOOcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 10:32:43 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37883 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732958AbfHOOck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 10:32:40 -0400
Received: by mail-wr1-f67.google.com with SMTP id z11so2416364wrt.4
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 07:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=klej20LM50rl+qegl25ThpIduG7ubdFrTIw/Elq2Oyk=;
        b=ZmpLee+MpsIvwrI81gSC97WwtSwmglFRgAnR53OEOPTIM7/tGVwNzCUqW0EpCz7zCl
         nSp7J9zX5N6QYUBVade+gQUtTr76yPVmJrkOP6fbrjC8jDz/wnckOKG7atAdCO2NhQZI
         F/wup5rR8QZZ8U32G6dILI4JyV5P1ATplET25i3PZMZhaw5wnKBhFRDvvAYF6PH7ETja
         1jUkLhXCs/iQRYqLmxUShrskQZU8h1N360msgzQt9DP9U/grRFS5MrMYVD4JXbT1DtmM
         IpemRMWBOi61793/oigcAAWQgHnZQy/lz3BSm0Fa6oHt0Jymj5qU61aLQ+wMtcPLz8oC
         jMDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=klej20LM50rl+qegl25ThpIduG7ubdFrTIw/Elq2Oyk=;
        b=iE6GvuYthLndJEf1MQR6lwhU5FvEX9WVT/CD6B7sN+pfhErecbaOA0w3g8pjb/4D1h
         dXPlHv2p/d/kN+M4eJ0/AdDrJg1Ed3AHg0IgDjeWaHsjSWwb1R1tx/Q5a1mX+Q7OSHdh
         4yp8O58vgIHy380xrKhCFCOHXbLWQK/RkA/OaWB2CmuGzZr8wEXONXUBHd3em2N5Ke0n
         QP6Cll/IrkVSnn95SQnrLOk/ahbHKm450lZe/QWOror+RCp9BLz6cFLYnfJSP7apImm9
         df57m+5fml2IWZ6BVaoyyYK+3XhWdaXX6sT9i/YPdjTkgpWbdf1OXxQitjFwRji2wQ3j
         l8/Q==
X-Gm-Message-State: APjAAAVWWphMi0M/J2aua6NnHTpulQQVqE11kwF4pCx0cugRkzS08iac
        tY4lplS2vxBLDM8och6V3X5iBw==
X-Google-Smtp-Source: APXvYqxIBOQL+nrXAbciTgQQN+SrA6sh71SeVePn3YZ9iwT/G69fL834Z5AjxMuTvBATZtBtSF+u0g==
X-Received: by 2002:adf:fdcc:: with SMTP id i12mr6065639wrs.88.1565879558327;
        Thu, 15 Aug 2019 07:32:38 -0700 (PDT)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id a19sm8857463wra.2.2019.08.15.07.32.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 07:32:35 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH bpf 6/6] tools: bpftool: move "__printf()" attributes to header file
Date:   Thu, 15 Aug 2019 15:32:20 +0100
Message-Id: <20190815143220.4199-7-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815143220.4199-1-quentin.monnet@netronome.com>
References: <20190815143220.4199-1-quentin.monnet@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some functions in bpftool have a "__printf()" format attributes to tell
the compiler they should expect printf()-like arguments. But because
these attributes are not used for the function prototypes in the header
files, the compiler does not run the checks everywhere the functions are
used, and some mistakes on format string and corresponding arguments
slipped in over time.

Let's move the __printf() attributes to the correct places.

Note: We add guards around the definition of GCC_VERSION in
tools/include/linux/compiler-gcc.h to prevent a conflict in jit_disasm.c
on GCC_VERSION from headers pulled via libbfd.

Fixes: c101189bc968 ("tools: bpftool: fix -Wmissing declaration warnings")
Reported-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 tools/bpf/bpftool/common.c         | 4 ++--
 tools/bpf/bpftool/json_writer.c    | 6 ++----
 tools/bpf/bpftool/json_writer.h    | 6 ++++--
 tools/bpf/bpftool/main.h           | 4 ++--
 tools/include/linux/compiler-gcc.h | 2 ++
 5 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index 6a71324be628..88264abaa738 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -29,7 +29,7 @@
 #define BPF_FS_MAGIC		0xcafe4a11
 #endif
 
-void __printf(1, 2) p_err(const char *fmt, ...)
+void p_err(const char *fmt, ...)
 {
 	va_list ap;
 
@@ -47,7 +47,7 @@ void __printf(1, 2) p_err(const char *fmt, ...)
 	va_end(ap);
 }
 
-void __printf(1, 2) p_info(const char *fmt, ...)
+void p_info(const char *fmt, ...)
 {
 	va_list ap;
 
diff --git a/tools/bpf/bpftool/json_writer.c b/tools/bpf/bpftool/json_writer.c
index 6046dcab51cc..86501cd3c763 100644
--- a/tools/bpf/bpftool/json_writer.c
+++ b/tools/bpf/bpftool/json_writer.c
@@ -15,7 +15,6 @@
 #include <malloc.h>
 #include <inttypes.h>
 #include <stdint.h>
-#include <linux/compiler.h>
 
 #include "json_writer.h"
 
@@ -153,8 +152,7 @@ void jsonw_name(json_writer_t *self, const char *name)
 		putc(' ', self->out);
 }
 
-void __printf(2, 0)
-jsonw_vprintf_enquote(json_writer_t *self, const char *fmt, va_list ap)
+void jsonw_vprintf_enquote(json_writer_t *self, const char *fmt, va_list ap)
 {
 	jsonw_eor(self);
 	putc('"', self->out);
@@ -162,7 +160,7 @@ jsonw_vprintf_enquote(json_writer_t *self, const char *fmt, va_list ap)
 	putc('"', self->out);
 }
 
-void __printf(2, 3) jsonw_printf(json_writer_t *self, const char *fmt, ...)
+void jsonw_printf(json_writer_t *self, const char *fmt, ...)
 {
 	va_list ap;
 
diff --git a/tools/bpf/bpftool/json_writer.h b/tools/bpf/bpftool/json_writer.h
index cb9a1993681c..35cf1f00f96c 100644
--- a/tools/bpf/bpftool/json_writer.h
+++ b/tools/bpf/bpftool/json_writer.h
@@ -14,6 +14,7 @@
 #include <stdbool.h>
 #include <stdint.h>
 #include <stdarg.h>
+#include <linux/compiler.h>
 
 /* Opaque class structure */
 typedef struct json_writer json_writer_t;
@@ -30,8 +31,9 @@ void jsonw_pretty(json_writer_t *self, bool on);
 void jsonw_name(json_writer_t *self, const char *name);
 
 /* Add value  */
-void jsonw_vprintf_enquote(json_writer_t *self, const char *fmt, va_list ap);
-void jsonw_printf(json_writer_t *self, const char *fmt, ...);
+void __printf(2, 0) jsonw_vprintf_enquote(json_writer_t *self, const char *fmt,
+					  va_list ap);
+void __printf(2, 3) jsonw_printf(json_writer_t *self, const char *fmt, ...);
 void jsonw_string(json_writer_t *self, const char *value);
 void jsonw_bool(json_writer_t *self, bool value);
 void jsonw_float(json_writer_t *self, double number);
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 7031a4bf87a0..af9ad56c303a 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -98,8 +98,8 @@ extern int bpf_flags;
 extern struct pinned_obj_table prog_table;
 extern struct pinned_obj_table map_table;
 
-void p_err(const char *fmt, ...);
-void p_info(const char *fmt, ...);
+void __printf(1, 2) p_err(const char *fmt, ...);
+void __printf(1, 2) p_info(const char *fmt, ...);
 
 bool is_prefix(const char *pfx, const char *str);
 int detect_common_prefix(const char *arg, ...);
diff --git a/tools/include/linux/compiler-gcc.h b/tools/include/linux/compiler-gcc.h
index 0d35f18006a1..95c072b70d0e 100644
--- a/tools/include/linux/compiler-gcc.h
+++ b/tools/include/linux/compiler-gcc.h
@@ -6,9 +6,11 @@
 /*
  * Common definitions for all gcc versions go here.
  */
+#ifndef GCC_VERSION
 #define GCC_VERSION (__GNUC__ * 10000		\
 		     + __GNUC_MINOR__ * 100	\
 		     + __GNUC_PATCHLEVEL__)
+#endif
 
 #if GCC_VERSION >= 70000 && !defined(__CHECKER__)
 # define __fallthrough __attribute__ ((fallthrough))
-- 
2.17.1

