Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367072ECAD6
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 08:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbhAGHO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 02:14:29 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:37183 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725974AbhAGHO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 02:14:29 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from roid@nvidia.com)
        with SMTP; 7 Jan 2021 09:13:38 +0200
Received: from dev-r-vrt-138.mtr.labs.mlnx (dev-r-vrt-138.mtr.labs.mlnx [10.212.138.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 1077DcMl024482;
        Thu, 7 Jan 2021 09:13:38 +0200
From:   Roi Dayan <roid@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     Roi Dayan <roid@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 v2 1/1] build: Fix link errors on some systems
Date:   Thu,  7 Jan 2021 09:13:34 +0200
Message-Id: <20210107071334.473916-1-roid@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since moving get_rate() and get_size() from tc to lib, on some
systems we fail to link because of missing math lib.
Move the functions that require math lib to their own c file
and add -lm to dcb that now use those functions.

../lib/libutil.a(utils.o): In function `get_rate':
utils.c:(.text+0x10dc): undefined reference to `floor'
../lib/libutil.a(utils.o): In function `get_size':
utils.c:(.text+0x1394): undefined reference to `floor'
../lib/libutil.a(json_print.o): In function `sprint_size':
json_print.c:(.text+0x14c0): undefined reference to `rint'
json_print.c:(.text+0x14f4): undefined reference to `rint'
json_print.c:(.text+0x157c): undefined reference to `rint'

Fixes: f3be0e6366ac ("lib: Move get_rate(), get_rate64() from tc here")
Fixes: 44396bdfcc0a ("lib: Move get_size() from tc here")
Fixes: adbe5de96662 ("lib: Move sprint_size() from tc here, add print_size()")

Signed-off-by: Roi Dayan <roid@nvidia.com>
---

Notes:
    v2
    - As suggested by Petr.
      Instead of adding -lm to all utils move the functions that
      require math lib to seperate c files and add -lm to dcb that
      use those functions.

 dcb/Makefile          |   1 +
 include/json_print.h  |   3 +
 lib/Makefile          |   4 +-
 lib/json_print.c      |  33 -----------
 lib/json_print_math.c |  46 +++++++++++++++
 lib/utils.c           | 114 ------------------------------------
 lib/utils_math.c      | 133 ++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 185 insertions(+), 149 deletions(-)
 create mode 100644 lib/json_print_math.c
 create mode 100644 lib/utils_math.c

diff --git a/dcb/Makefile b/dcb/Makefile
index 4add954b4bba..7c09bb4f2e00 100644
--- a/dcb/Makefile
+++ b/dcb/Makefile
@@ -7,6 +7,7 @@ ifeq ($(HAVE_MNL),y)
 
 DCBOBJ = dcb.o dcb_buffer.o dcb_ets.o dcb_maxrate.o dcb_pfc.o
 TARGETS += dcb
+LDLIBS += -lm
 
 endif
 
diff --git a/include/json_print.h b/include/json_print.h
index 1a1ad5ffa552..9ec8626c4d85 100644
--- a/include/json_print.h
+++ b/include/json_print.h
@@ -15,6 +15,9 @@
 #include "json_writer.h"
 #include "color.h"
 
+#define _IS_JSON_CONTEXT(type) ((type & PRINT_JSON || type & PRINT_ANY) && is_json_context())
+#define _IS_FP_CONTEXT(type) (!is_json_context() && (type & PRINT_FP || type & PRINT_ANY))
+
 json_writer_t *get_json_writer(void);
 
 /*
diff --git a/lib/Makefile b/lib/Makefile
index 764c9137d0ec..6c98f9a61fdb 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -3,8 +3,8 @@ include ../config.mk
 
 CFLAGS += -fPIC
 
-UTILOBJ = utils.o rt_names.o ll_map.o ll_types.o ll_proto.o ll_addr.o \
-	inet_proto.o namespace.o json_writer.o json_print.o \
+UTILOBJ = utils.o utils_math.o rt_names.o ll_map.o ll_types.o ll_proto.o ll_addr.o \
+	inet_proto.o namespace.o json_writer.o json_print.o json_print_math.o \
 	names.o color.o bpf_legacy.o bpf_glue.o exec.o fs.o cg_map.o
 
 ifeq ($(HAVE_ELF),y)
diff --git a/lib/json_print.c b/lib/json_print.c
index b086123ad1f4..994a2f8d6ae0 100644
--- a/lib/json_print.c
+++ b/lib/json_print.c
@@ -11,16 +11,12 @@
 
 #include <stdarg.h>
 #include <stdio.h>
-#include <math.h>
 
 #include "utils.h"
 #include "json_print.h"
 
 static json_writer_t *_jw;
 
-#define _IS_JSON_CONTEXT(type) ((type & PRINT_JSON || type & PRINT_ANY) && _jw)
-#define _IS_FP_CONTEXT(type) (!_jw && (type & PRINT_FP || type & PRINT_ANY))
-
 static void __new_json_obj(int json, bool have_array)
 {
 	if (json) {
@@ -342,32 +338,3 @@ int print_color_rate(bool use_iec, enum output_type type, enum color_attr color,
 	free(buf);
 	return rc;
 }
-
-char *sprint_size(__u32 sz, char *buf)
-{
-	long kilo = 1024;
-	long mega = kilo * kilo;
-	size_t len = SPRINT_BSIZE - 1;
-	double tmp = sz;
-
-	if (sz >= mega && fabs(mega * rint(tmp / mega) - sz) < 1024)
-		snprintf(buf, len, "%gMb", rint(tmp / mega));
-	else if (sz >= kilo && fabs(kilo * rint(tmp / kilo) - sz) < 16)
-		snprintf(buf, len, "%gKb", rint(tmp / kilo));
-	else
-		snprintf(buf, len, "%ub", sz);
-
-	return buf;
-}
-
-int print_color_size(enum output_type type, enum color_attr color,
-		     const char *key, const char *fmt, __u32 sz)
-{
-	SPRINT_BUF(buf);
-
-	if (_IS_JSON_CONTEXT(type))
-		return print_color_uint(type, color, key, "%u", sz);
-
-	sprint_size(sz, buf);
-	return print_color_string(type, color, key, fmt, buf);
-}
diff --git a/lib/json_print_math.c b/lib/json_print_math.c
new file mode 100644
index 000000000000..3d560defcd3e
--- /dev/null
+++ b/lib/json_print_math.c
@@ -0,0 +1,46 @@
+/*
+ * json_print_math.c		"print regular or json output, based on json_writer".
+ *
+ *             This program is free software; you can redistribute it and/or
+ *             modify it under the terms of the GNU General Public License
+ *             as published by the Free Software Foundation; either version
+ *             2 of the License, or (at your option) any later version.
+ *
+ * Authors:    Julien Fortin, <julien@cumulusnetworks.com>
+ */
+
+#include <stdarg.h>
+#include <stdio.h>
+#include <math.h>
+
+#include "utils.h"
+#include "json_print.h"
+
+char *sprint_size(__u32 sz, char *buf)
+{
+	long kilo = 1024;
+	long mega = kilo * kilo;
+	size_t len = SPRINT_BSIZE - 1;
+	double tmp = sz;
+
+	if (sz >= mega && fabs(mega * rint(tmp / mega) - sz) < 1024)
+		snprintf(buf, len, "%gMb", rint(tmp / mega));
+	else if (sz >= kilo && fabs(kilo * rint(tmp / kilo) - sz) < 16)
+		snprintf(buf, len, "%gKb", rint(tmp / kilo));
+	else
+		snprintf(buf, len, "%ub", sz);
+
+	return buf;
+}
+
+int print_color_size(enum output_type type, enum color_attr color,
+		     const char *key, const char *fmt, __u32 sz)
+{
+	SPRINT_BUF(buf);
+
+	if (_IS_JSON_CONTEXT(type))
+		return print_color_uint(type, color, key, "%u", sz);
+
+	sprint_size(sz, buf);
+	return print_color_string(type, color, key, fmt, buf);
+}
diff --git a/lib/utils.c b/lib/utils.c
index de875639c608..a0ba5181160e 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -513,120 +513,6 @@ int get_addr64(__u64 *ap, const char *cp)
 	return 1;
 }
 
-/* See http://physics.nist.gov/cuu/Units/binary.html */
-static const struct rate_suffix {
-	const char *name;
-	double scale;
-} suffixes[] = {
-	{ "bit",	1. },
-	{ "Kibit",	1024. },
-	{ "kbit",	1000. },
-	{ "mibit",	1024.*1024. },
-	{ "mbit",	1000000. },
-	{ "gibit",	1024.*1024.*1024. },
-	{ "gbit",	1000000000. },
-	{ "tibit",	1024.*1024.*1024.*1024. },
-	{ "tbit",	1000000000000. },
-	{ "Bps",	8. },
-	{ "KiBps",	8.*1024. },
-	{ "KBps",	8000. },
-	{ "MiBps",	8.*1024*1024. },
-	{ "MBps",	8000000. },
-	{ "GiBps",	8.*1024.*1024.*1024. },
-	{ "GBps",	8000000000. },
-	{ "TiBps",	8.*1024.*1024.*1024.*1024. },
-	{ "TBps",	8000000000000. },
-	{ NULL }
-};
-
-int get_rate(unsigned int *rate, const char *str)
-{
-	char *p;
-	double bps = strtod(str, &p);
-	const struct rate_suffix *s;
-
-	if (p == str)
-		return -1;
-
-	for (s = suffixes; s->name; ++s) {
-		if (strcasecmp(s->name, p) == 0) {
-			bps *= s->scale;
-			p += strlen(p);
-			break;
-		}
-	}
-
-	if (*p)
-		return -1; /* unknown suffix */
-
-	bps /= 8; /* -> bytes per second */
-	*rate = bps;
-	/* detect if an overflow happened */
-	if (*rate != floor(bps))
-		return -1;
-	return 0;
-}
-
-int get_rate64(__u64 *rate, const char *str)
-{
-	char *p;
-	double bps = strtod(str, &p);
-	const struct rate_suffix *s;
-
-	if (p == str)
-		return -1;
-
-	for (s = suffixes; s->name; ++s) {
-		if (strcasecmp(s->name, p) == 0) {
-			bps *= s->scale;
-			p += strlen(p);
-			break;
-		}
-	}
-
-	if (*p)
-		return -1; /* unknown suffix */
-
-	bps /= 8; /* -> bytes per second */
-	*rate = bps;
-	return 0;
-}
-
-int get_size(unsigned int *size, const char *str)
-{
-	double sz;
-	char *p;
-
-	sz = strtod(str, &p);
-	if (p == str)
-		return -1;
-
-	if (*p) {
-		if (strcasecmp(p, "kb") == 0 || strcasecmp(p, "k") == 0)
-			sz *= 1024;
-		else if (strcasecmp(p, "gb") == 0 || strcasecmp(p, "g") == 0)
-			sz *= 1024*1024*1024;
-		else if (strcasecmp(p, "gbit") == 0)
-			sz *= 1024*1024*1024/8;
-		else if (strcasecmp(p, "mb") == 0 || strcasecmp(p, "m") == 0)
-			sz *= 1024*1024;
-		else if (strcasecmp(p, "mbit") == 0)
-			sz *= 1024*1024/8;
-		else if (strcasecmp(p, "kbit") == 0)
-			sz *= 1024/8;
-		else if (strcasecmp(p, "b") != 0)
-			return -1;
-	}
-
-	*size = sz;
-
-	/* detect if an overflow happened */
-	if (*size != floor(sz))
-		return -1;
-
-	return 0;
-}
-
 static void set_address_type(inet_prefix *addr)
 {
 	switch (addr->family) {
diff --git a/lib/utils_math.c b/lib/utils_math.c
new file mode 100644
index 000000000000..d67affeb16c2
--- /dev/null
+++ b/lib/utils_math.c
@@ -0,0 +1,133 @@
+/*
+ * utils.c
+ *
+ *		This program is free software; you can redistribute it and/or
+ *		modify it under the terms of the GNU General Public License
+ *		as published by the Free Software Foundation; either version
+ *		2 of the License, or (at your option) any later version.
+ *
+ * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
+ *
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <math.h>
+#include <asm/types.h>
+
+#include "utils.h"
+
+/* See http://physics.nist.gov/cuu/Units/binary.html */
+static const struct rate_suffix {
+	const char *name;
+	double scale;
+} suffixes[] = {
+	{ "bit",	1. },
+	{ "Kibit",	1024. },
+	{ "kbit",	1000. },
+	{ "mibit",	1024.*1024. },
+	{ "mbit",	1000000. },
+	{ "gibit",	1024.*1024.*1024. },
+	{ "gbit",	1000000000. },
+	{ "tibit",	1024.*1024.*1024.*1024. },
+	{ "tbit",	1000000000000. },
+	{ "Bps",	8. },
+	{ "KiBps",	8.*1024. },
+	{ "KBps",	8000. },
+	{ "MiBps",	8.*1024*1024. },
+	{ "MBps",	8000000. },
+	{ "GiBps",	8.*1024.*1024.*1024. },
+	{ "GBps",	8000000000. },
+	{ "TiBps",	8.*1024.*1024.*1024.*1024. },
+	{ "TBps",	8000000000000. },
+	{ NULL }
+};
+
+int get_rate(unsigned int *rate, const char *str)
+{
+	char *p;
+	double bps = strtod(str, &p);
+	const struct rate_suffix *s;
+
+	if (p == str)
+		return -1;
+
+	for (s = suffixes; s->name; ++s) {
+		if (strcasecmp(s->name, p) == 0) {
+			bps *= s->scale;
+			p += strlen(p);
+			break;
+		}
+	}
+
+	if (*p)
+		return -1; /* unknown suffix */
+
+	bps /= 8; /* -> bytes per second */
+	*rate = bps;
+	/* detect if an overflow happened */
+	if (*rate != floor(bps))
+		return -1;
+	return 0;
+}
+
+int get_rate64(__u64 *rate, const char *str)
+{
+	char *p;
+	double bps = strtod(str, &p);
+	const struct rate_suffix *s;
+
+	if (p == str)
+		return -1;
+
+	for (s = suffixes; s->name; ++s) {
+		if (strcasecmp(s->name, p) == 0) {
+			bps *= s->scale;
+			p += strlen(p);
+			break;
+		}
+	}
+
+	if (*p)
+		return -1; /* unknown suffix */
+
+	bps /= 8; /* -> bytes per second */
+	*rate = bps;
+	return 0;
+}
+
+int get_size(unsigned int *size, const char *str)
+{
+	double sz;
+	char *p;
+
+	sz = strtod(str, &p);
+	if (p == str)
+		return -1;
+
+	if (*p) {
+		if (strcasecmp(p, "kb") == 0 || strcasecmp(p, "k") == 0)
+			sz *= 1024;
+		else if (strcasecmp(p, "gb") == 0 || strcasecmp(p, "g") == 0)
+			sz *= 1024*1024*1024;
+		else if (strcasecmp(p, "gbit") == 0)
+			sz *= 1024*1024*1024/8;
+		else if (strcasecmp(p, "mb") == 0 || strcasecmp(p, "m") == 0)
+			sz *= 1024*1024;
+		else if (strcasecmp(p, "mbit") == 0)
+			sz *= 1024*1024/8;
+		else if (strcasecmp(p, "kbit") == 0)
+			sz *= 1024/8;
+		else if (strcasecmp(p, "b") != 0)
+			return -1;
+	}
+
+	*size = sz;
+
+	/* detect if an overflow happened */
+	if (*size != floor(sz))
+		return -1;
+
+	return 0;
+}
-- 
2.26.2

