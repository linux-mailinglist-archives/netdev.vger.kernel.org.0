Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B76620A5BC
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 21:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406432AbgFYTZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 15:25:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60906 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404019AbgFYTZE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 15:25:04 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1joXUX-002FO5-4p; Thu, 25 Jun 2020 21:24:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH ethtool v3 3/6] json_writer/json_print: Import the iproute2 helper code for JSON output
Date:   Thu, 25 Jun 2020 21:24:43 +0200
Message-Id: <20200625192446.535754-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200625192446.535754-1-andrew@lunn.ch>
References: <20200625192446.535754-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In general, Linux network tools use JSON for machine readable output.
See for example -json for iproute2 and devlink. In order to support
JSON output from ethtool, import the iproute2 helper code.

Acked-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 Makefile.am   |   3 +-
 json_print.c  | 229 +++++++++++++++++++++++++++++
 json_print.h  |  67 +++++++++
 json_writer.c | 389 ++++++++++++++++++++++++++++++++++++++++++++++++++
 json_writer.h |  76 ++++++++++
 5 files changed, 763 insertions(+), 1 deletion(-)
 create mode 100644 json_print.c
 create mode 100644 json_print.h
 create mode 100644 json_writer.c
 create mode 100644 json_writer.h

diff --git a/Makefile.am b/Makefile.am
index a818cf8..a736237 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -7,7 +7,8 @@ EXTRA_DIST = LICENSE ethtool.8 ethtool.spec.in aclocal.m4 ChangeLog autogen.sh
 
 sbin_PROGRAMS = ethtool
 ethtool_SOURCES = ethtool.c uapi/linux/ethtool.h internal.h \
-		  uapi/linux/net_tstamp.h rxclass.c common.c common.h
+		  uapi/linux/net_tstamp.h rxclass.c common.c common.h \
+		  json_writer.c json_writer.h json_print.c json_print.h
 if ETHTOOL_ENABLE_PRETTY_DUMP
 ethtool_SOURCES += \
 		  amd8111e.c de2104x.c dsa.c e100.c e1000.c et131x.c igb.c	\
diff --git a/json_print.c b/json_print.c
new file mode 100644
index 0000000..1ce2e69
--- /dev/null
+++ b/json_print.c
@@ -0,0 +1,229 @@
+/*
+ * json_print.c		"print regular or json output, based on json_writer".
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
+#include <unistd.h>
+#include <stdlib.h>
+
+#include "json_print.h"
+
+#define SPRINT_BSIZE 64
+#define SPRINT_BUF(x)   char x[SPRINT_BSIZE]
+
+static json_writer_t *_jw;
+
+#define _IS_JSON_CONTEXT(type) ((type & PRINT_JSON || type & PRINT_ANY) && _jw)
+#define _IS_FP_CONTEXT(type) (!_jw && (type & PRINT_FP || type & PRINT_ANY))
+
+void new_json_obj(int json)
+{
+	if (json) {
+		_jw = jsonw_new(stdout);
+		if (!_jw) {
+			perror("json object");
+			exit(1);
+		}
+		jsonw_pretty(_jw, true);
+		jsonw_start_array(_jw);
+	}
+}
+
+void delete_json_obj(void)
+{
+	if (_jw) {
+		jsonw_end_array(_jw);
+		jsonw_destroy(&_jw);
+	}
+}
+
+bool is_json_context(void)
+{
+	return _jw != NULL;
+}
+
+json_writer_t *get_json_writer(void)
+{
+	return _jw;
+}
+
+void open_json_object(const char *str)
+{
+	if (_IS_JSON_CONTEXT(PRINT_JSON)) {
+		if (str)
+			jsonw_name(_jw, str);
+		jsonw_start_object(_jw);
+	}
+}
+
+void close_json_object(void)
+{
+	if (_IS_JSON_CONTEXT(PRINT_JSON))
+		jsonw_end_object(_jw);
+}
+
+/*
+ * Start json array or string array using
+ * the provided string as json key (if not null)
+ * or as array delimiter in non-json context.
+ */
+void open_json_array(enum output_type type, const char *str)
+{
+	if (_IS_JSON_CONTEXT(type)) {
+		if (str)
+			jsonw_name(_jw, str);
+		jsonw_start_array(_jw);
+	} else if (_IS_FP_CONTEXT(type)) {
+		printf("%s", str);
+	}
+}
+
+/*
+ * End json array or string array
+ */
+void close_json_array(enum output_type type, const char *str)
+{
+	if (_IS_JSON_CONTEXT(type)) {
+		jsonw_end_array(_jw);
+	} else if (_IS_FP_CONTEXT(type)) {
+		printf("%s", str);
+	}
+}
+
+/*
+ * pre-processor directive to generate similar
+ * functions handling different types
+ */
+#define _PRINT_FUNC(type_name, type)					\
+	__attribute__((format(printf, 3, 0)))				\
+	void print_##type_name(enum output_type t,			\
+			       const char *key,				\
+			       const char *fmt,				\
+			       type value)				\
+	{								\
+		if (_IS_JSON_CONTEXT(t)) {				\
+			if (!key)					\
+				jsonw_##type_name(_jw, value);		\
+			else						\
+				jsonw_##type_name##_field(_jw, key, value); \
+		} else if (_IS_FP_CONTEXT(t)) {				\
+			fprintf(stdout, fmt, value);			\
+		}							\
+	}
+_PRINT_FUNC(int, int);
+_PRINT_FUNC(s64, int64_t);
+_PRINT_FUNC(hhu, unsigned char);
+_PRINT_FUNC(hu, unsigned short);
+_PRINT_FUNC(uint, unsigned int);
+_PRINT_FUNC(u64, uint64_t);
+_PRINT_FUNC(luint, unsigned long);
+_PRINT_FUNC(lluint, unsigned long long);
+_PRINT_FUNC(float, double);
+#undef _PRINT_FUNC
+
+void print_string(enum output_type type,
+		  const char *key,
+		  const char *fmt,
+		  const char *value)
+{
+	if (_IS_JSON_CONTEXT(type)) {
+		if (key && !value)
+			jsonw_name(_jw, key);
+		else if (!key && value)
+			jsonw_string(_jw, value);
+		else
+			jsonw_string_field(_jw, key, value);
+	} else if (_IS_FP_CONTEXT(type)) {
+		fprintf(stdout, fmt, value);
+	}
+}
+
+/*
+ * value's type is bool. When using this function in FP context you can't pass
+ * a value to it, you will need to use "is_json_context()" to have different
+ * branch for json and regular output. grep -r "print_bool" for example
+ */
+void print_bool(enum output_type type,
+		const char *key,
+		const char *fmt,
+		bool value)
+{
+	if (_IS_JSON_CONTEXT(type)) {
+		if (key)
+			jsonw_bool_field(_jw, key, value);
+		else
+			jsonw_bool(_jw, value);
+	} else if (_IS_FP_CONTEXT(type)) {
+		fprintf(stdout, fmt, value ? "true" : "false");
+	}
+}
+
+/*
+ * In JSON context uses hardcode %#x format: 42 -> 0x2a
+ */
+void print_0xhex(enum output_type type,
+		 const char *key,
+		 const char *fmt,
+		 unsigned long long hex)
+{
+	if (_IS_JSON_CONTEXT(type)) {
+		SPRINT_BUF(b1);
+
+		snprintf(b1, sizeof(b1), "%#llx", hex);
+		print_string(PRINT_JSON, key, NULL, b1);
+	} else if (_IS_FP_CONTEXT(type)) {
+		fprintf(stdout, fmt, hex);
+	}
+}
+
+void print_hex(enum output_type type,
+	       const char *key,
+	       const char *fmt,
+	       unsigned int hex)
+{
+	if (_IS_JSON_CONTEXT(type)) {
+		SPRINT_BUF(b1);
+
+		snprintf(b1, sizeof(b1), "%x", hex);
+		if (key)
+			jsonw_string_field(_jw, key, b1);
+		else
+			jsonw_string(_jw, b1);
+	} else if (_IS_FP_CONTEXT(type)) {
+		fprintf(stdout, fmt, hex);
+	}
+}
+
+/*
+ * In JSON context we don't use the argument "value" we simply call jsonw_null
+ * whereas FP context can use "value" to output anything
+ */
+void print_null(enum output_type type,
+		const char *key,
+		const char *fmt,
+		const char *value)
+{
+	if (_IS_JSON_CONTEXT(type)) {
+		if (key)
+			jsonw_null_field(_jw, key);
+		else
+			jsonw_null(_jw);
+	} else if (_IS_FP_CONTEXT(type)) {
+		fprintf(stdout, fmt, value);
+	}
+}
+
+/* Print line seperator (if not in JSON mode) */
+void print_nl(void)
+{
+	if (!_jw)
+		printf("%s", "\n");
+}
diff --git a/json_print.h b/json_print.h
new file mode 100644
index 0000000..d035ba2
--- /dev/null
+++ b/json_print.h
@@ -0,0 +1,67 @@
+/*
+ * json_print.h		"print regular or json output, based on json_writer".
+ *
+ *             This program is free software; you can redistribute it and/or
+ *             modify it under the terms of the GNU General Public License
+ *             as published by the Free Software Foundation; either version
+ *             2 of the License, or (at your option) any later version.
+ *
+ * Authors:    Julien Fortin, <julien@cumulusnetworks.com>
+ */
+
+#ifndef _JSON_PRINT_H_
+#define _JSON_PRINT_H_
+
+#include "json_writer.h"
+
+json_writer_t *get_json_writer(void);
+
+/*
+ * use:
+ *      - PRINT_ANY for context based output
+ *      - PRINT_FP for non json specific output
+ *      - PRINT_JSON for json specific output
+ */
+enum output_type {
+	PRINT_FP = 1,
+	PRINT_JSON = 2,
+	PRINT_ANY = 4,
+};
+
+void new_json_obj(int json);
+void delete_json_obj(void);
+
+bool is_json_context(void);
+
+void fflush_fp(void);
+
+void open_json_object(const char *str);
+void close_json_object(void);
+void open_json_array(enum output_type type, const char *delim);
+void close_json_array(enum output_type type, const char *delim);
+
+void print_nl(void);
+
+#define _PRINT_FUNC(type_name, type)					\
+	void print_##type_name(enum output_type t,			\
+			       const char *key,				\
+			       const char *fmt,				\
+			       type value);				\
+
+_PRINT_FUNC(int, int);
+_PRINT_FUNC(s64, int64_t);
+_PRINT_FUNC(bool, bool);
+_PRINT_FUNC(null, const char*);
+_PRINT_FUNC(string, const char*);
+_PRINT_FUNC(uint, unsigned int);
+_PRINT_FUNC(u64, uint64_t);
+_PRINT_FUNC(hhu, unsigned char);
+_PRINT_FUNC(hu, unsigned short);
+_PRINT_FUNC(hex, unsigned int);
+_PRINT_FUNC(0xhex, unsigned long long);
+_PRINT_FUNC(luint, unsigned long);
+_PRINT_FUNC(lluint, unsigned long long);
+_PRINT_FUNC(float, double);
+#undef _PRINT_FUNC
+
+#endif /* _JSON_PRINT_H_ */
diff --git a/json_writer.c b/json_writer.c
new file mode 100644
index 0000000..88c5eb8
--- /dev/null
+++ b/json_writer.c
@@ -0,0 +1,389 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause) */
+/*
+ * Simple streaming JSON writer
+ *
+ * This takes care of the annoying bits of JSON syntax like the commas
+ * after elements
+ *
+ * Authors:	Stephen Hemminger <stephen@networkplumber.org>
+ */
+
+#include <stdio.h>
+#include <stdbool.h>
+#include <stdarg.h>
+#include <assert.h>
+#include <malloc.h>
+#include <inttypes.h>
+#include <stdint.h>
+
+#include "json_writer.h"
+
+struct json_writer {
+	FILE		*out;	/* output file */
+	unsigned	depth;  /* nesting */
+	bool		pretty; /* optional whitepace */
+	char		sep;	/* either nul or comma */
+};
+
+/* indentation for pretty print */
+static void jsonw_indent(json_writer_t *self)
+{
+	unsigned i;
+	for (i = 0; i < self->depth; ++i)
+		fputs("    ", self->out);
+}
+
+/* end current line and indent if pretty printing */
+static void jsonw_eol(json_writer_t *self)
+{
+	if (!self->pretty)
+		return;
+
+	putc('\n', self->out);
+	jsonw_indent(self);
+}
+
+/* If current object is not empty print a comma */
+static void jsonw_eor(json_writer_t *self)
+{
+	if (self->sep != '\0')
+		putc(self->sep, self->out);
+	self->sep = ',';
+}
+
+
+/* Output JSON encoded string */
+/* Handles C escapes, does not do Unicode */
+static void jsonw_puts(json_writer_t *self, const char *str)
+{
+	putc('"', self->out);
+	for (; *str; ++str)
+		switch (*str) {
+		case '\t':
+			fputs("\\t", self->out);
+			break;
+		case '\n':
+			fputs("\\n", self->out);
+			break;
+		case '\r':
+			fputs("\\r", self->out);
+			break;
+		case '\f':
+			fputs("\\f", self->out);
+			break;
+		case '\b':
+			fputs("\\b", self->out);
+			break;
+		case '\\':
+			fputs("\\\\", self->out);
+			break;
+		case '"':
+			fputs("\\\"", self->out);
+			break;
+		case '\'':
+			fputs("\\\'", self->out);
+			break;
+		default:
+			putc(*str, self->out);
+		}
+	putc('"', self->out);
+}
+
+/* Create a new JSON stream */
+json_writer_t *jsonw_new(FILE *f)
+{
+	json_writer_t *self = malloc(sizeof(*self));
+	if (self) {
+		self->out = f;
+		self->depth = 0;
+		self->pretty = false;
+		self->sep = '\0';
+	}
+	return self;
+}
+
+/* End output to JSON stream */
+void jsonw_destroy(json_writer_t **self_p)
+{
+	json_writer_t *self = *self_p;
+
+	assert(self->depth == 0);
+	fputs("\n", self->out);
+	fflush(self->out);
+	free(self);
+	*self_p = NULL;
+}
+
+void jsonw_pretty(json_writer_t *self, bool on)
+{
+	self->pretty = on;
+}
+
+/* Basic blocks */
+static void jsonw_begin(json_writer_t *self, int c)
+{
+	jsonw_eor(self);
+	putc(c, self->out);
+	++self->depth;
+	self->sep = '\0';
+}
+
+static void jsonw_end(json_writer_t *self, int c)
+{
+	assert(self->depth > 0);
+
+	--self->depth;
+	if (self->sep != '\0')
+		jsonw_eol(self);
+	putc(c, self->out);
+	self->sep = ',';
+}
+
+
+/* Add a JSON property name */
+void jsonw_name(json_writer_t *self, const char *name)
+{
+	jsonw_eor(self);
+	jsonw_eol(self);
+	self->sep = '\0';
+	jsonw_puts(self, name);
+	putc(':', self->out);
+	if (self->pretty)
+		putc(' ', self->out);
+}
+
+__attribute__((format(printf, 2, 3)))
+void jsonw_printf(json_writer_t *self, const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	jsonw_eor(self);
+	vfprintf(self->out, fmt, ap);
+	va_end(ap);
+}
+
+/* Collections */
+void jsonw_start_object(json_writer_t *self)
+{
+	jsonw_begin(self, '{');
+}
+
+void jsonw_end_object(json_writer_t *self)
+{
+	jsonw_end(self, '}');
+}
+
+void jsonw_start_array(json_writer_t *self)
+{
+	jsonw_begin(self, '[');
+	if (self->pretty)
+		putc(' ', self->out);
+}
+
+void jsonw_end_array(json_writer_t *self)
+{
+	if (self->pretty && self->sep)
+		putc(' ', self->out);
+	self->sep = '\0';
+	jsonw_end(self, ']');
+}
+
+/* JSON value types */
+void jsonw_string(json_writer_t *self, const char *value)
+{
+	jsonw_eor(self);
+	jsonw_puts(self, value);
+}
+
+void jsonw_bool(json_writer_t *self, bool val)
+{
+	jsonw_printf(self, "%s", val ? "true" : "false");
+}
+
+void jsonw_null(json_writer_t *self)
+{
+	jsonw_printf(self, "null");
+}
+
+void jsonw_float(json_writer_t *self, double num)
+{
+	jsonw_printf(self, "%g", num);
+}
+
+void jsonw_hhu(json_writer_t *self, unsigned char num)
+{
+	jsonw_printf(self, "%hhu", num);
+}
+
+void jsonw_hu(json_writer_t *self, unsigned short num)
+{
+	jsonw_printf(self, "%hu", num);
+}
+
+void jsonw_uint(json_writer_t *self, unsigned int num)
+{
+	jsonw_printf(self, "%u", num);
+}
+
+void jsonw_u64(json_writer_t *self, uint64_t num)
+{
+	jsonw_printf(self, "%"PRIu64, num);
+}
+
+void jsonw_xint(json_writer_t *self, uint64_t num)
+{
+	jsonw_printf(self, "%"PRIx64, num);
+}
+
+void jsonw_luint(json_writer_t *self, unsigned long num)
+{
+	jsonw_printf(self, "%lu", num);
+}
+
+void jsonw_lluint(json_writer_t *self, unsigned long long num)
+{
+	jsonw_printf(self, "%llu", num);
+}
+
+void jsonw_int(json_writer_t *self, int num)
+{
+	jsonw_printf(self, "%d", num);
+}
+
+void jsonw_s64(json_writer_t *self, int64_t num)
+{
+	jsonw_printf(self, "%"PRId64, num);
+}
+
+/* Basic name/value objects */
+void jsonw_string_field(json_writer_t *self, const char *prop, const char *val)
+{
+	jsonw_name(self, prop);
+	jsonw_string(self, val);
+}
+
+void jsonw_bool_field(json_writer_t *self, const char *prop, bool val)
+{
+	jsonw_name(self, prop);
+	jsonw_bool(self, val);
+}
+
+void jsonw_float_field(json_writer_t *self, const char *prop, double val)
+{
+	jsonw_name(self, prop);
+	jsonw_float(self, val);
+}
+
+void jsonw_uint_field(json_writer_t *self, const char *prop, unsigned int num)
+{
+	jsonw_name(self, prop);
+	jsonw_uint(self, num);
+}
+
+void jsonw_u64_field(json_writer_t *self, const char *prop, uint64_t num)
+{
+	jsonw_name(self, prop);
+	jsonw_u64(self, num);
+}
+
+void jsonw_xint_field(json_writer_t *self, const char *prop, uint64_t num)
+{
+	jsonw_name(self, prop);
+	jsonw_xint(self, num);
+}
+
+void jsonw_hhu_field(json_writer_t *self, const char *prop, unsigned char num)
+{
+	jsonw_name(self, prop);
+	jsonw_hhu(self, num);
+}
+
+void jsonw_hu_field(json_writer_t *self, const char *prop, unsigned short num)
+{
+	jsonw_name(self, prop);
+	jsonw_hu(self, num);
+}
+
+void jsonw_luint_field(json_writer_t *self,
+			const char *prop,
+			unsigned long num)
+{
+	jsonw_name(self, prop);
+	jsonw_luint(self, num);
+}
+
+void jsonw_lluint_field(json_writer_t *self,
+			const char *prop,
+			unsigned long long num)
+{
+	jsonw_name(self, prop);
+	jsonw_lluint(self, num);
+}
+
+void jsonw_int_field(json_writer_t *self, const char *prop, int num)
+{
+	jsonw_name(self, prop);
+	jsonw_int(self, num);
+}
+
+void jsonw_s64_field(json_writer_t *self, const char *prop, int64_t num)
+{
+	jsonw_name(self, prop);
+	jsonw_s64(self, num);
+}
+
+void jsonw_null_field(json_writer_t *self, const char *prop)
+{
+	jsonw_name(self, prop);
+	jsonw_null(self);
+}
+
+#ifdef TEST
+int main(int argc, char **argv)
+{
+	json_writer_t *wr = jsonw_new(stdout);
+
+	jsonw_start_object(wr);
+	jsonw_pretty(wr, true);
+	jsonw_name(wr, "Vyatta");
+	jsonw_start_object(wr);
+	jsonw_string_field(wr, "url", "http://vyatta.com");
+	jsonw_uint_field(wr, "downloads", 2000000ul);
+	jsonw_float_field(wr, "stock", 8.16);
+
+	jsonw_name(wr, "ARGV");
+	jsonw_start_array(wr);
+	while (--argc)
+		jsonw_string(wr, *++argv);
+	jsonw_end_array(wr);
+
+	jsonw_name(wr, "empty");
+	jsonw_start_array(wr);
+	jsonw_end_array(wr);
+
+	jsonw_name(wr, "NIL");
+	jsonw_start_object(wr);
+	jsonw_end_object(wr);
+
+	jsonw_null_field(wr, "my_null");
+
+	jsonw_name(wr, "special chars");
+	jsonw_start_array(wr);
+	jsonw_string_field(wr, "slash", "/");
+	jsonw_string_field(wr, "newline", "\n");
+	jsonw_string_field(wr, "tab", "\t");
+	jsonw_string_field(wr, "ff", "\f");
+	jsonw_string_field(wr, "quote", "\"");
+	jsonw_string_field(wr, "tick", "\'");
+	jsonw_string_field(wr, "backslash", "\\");
+	jsonw_end_array(wr);
+
+	jsonw_end_object(wr);
+
+	jsonw_end_object(wr);
+	jsonw_destroy(&wr);
+	return 0;
+}
+
+#endif
diff --git a/json_writer.h b/json_writer.h
new file mode 100644
index 0000000..b52dc2d
--- /dev/null
+++ b/json_writer.h
@@ -0,0 +1,76 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause) */
+/*
+ * Simple streaming JSON writer
+ *
+ * This takes care of the annoying bits of JSON syntax like the commas
+ * after elements
+ *
+ * Authors:	Stephen Hemminger <stephen@networkplumber.org>
+ */
+
+#ifndef _JSON_WRITER_H_
+#define _JSON_WRITER_H_
+
+#include <stdbool.h>
+#include <stdint.h>
+
+/* Opaque class structure */
+typedef struct json_writer json_writer_t;
+
+/* Create a new JSON stream */
+json_writer_t *jsonw_new(FILE *f);
+/* End output to JSON stream */
+void jsonw_destroy(json_writer_t **self_p);
+
+/* Cause output to have pretty whitespace */
+void jsonw_pretty(json_writer_t *self, bool on);
+
+/* Add property name */
+void jsonw_name(json_writer_t *self, const char *name);
+
+/* Add value  */
+__attribute__((format(printf, 2, 3)))
+void jsonw_printf(json_writer_t *self, const char *fmt, ...);
+void jsonw_string(json_writer_t *self, const char *value);
+void jsonw_bool(json_writer_t *self, bool value);
+void jsonw_float(json_writer_t *self, double number);
+void jsonw_float_fmt(json_writer_t *self, const char *fmt, double num);
+void jsonw_uint(json_writer_t *self, unsigned int number);
+void jsonw_u64(json_writer_t *self, uint64_t number);
+void jsonw_xint(json_writer_t *self, uint64_t number);
+void jsonw_hhu(json_writer_t *self, unsigned char num);
+void jsonw_hu(json_writer_t *self, unsigned short number);
+void jsonw_int(json_writer_t *self, int number);
+void jsonw_s64(json_writer_t *self, int64_t number);
+void jsonw_null(json_writer_t *self);
+void jsonw_luint(json_writer_t *self, unsigned long num);
+void jsonw_lluint(json_writer_t *self, unsigned long long num);
+
+/* Useful Combinations of name and value */
+void jsonw_string_field(json_writer_t *self, const char *prop, const char *val);
+void jsonw_bool_field(json_writer_t *self, const char *prop, bool value);
+void jsonw_float_field(json_writer_t *self, const char *prop, double num);
+void jsonw_uint_field(json_writer_t *self, const char *prop, unsigned int num);
+void jsonw_u64_field(json_writer_t *self, const char *prop, uint64_t num);
+void jsonw_xint_field(json_writer_t *self, const char *prop, uint64_t num);
+void jsonw_hhu_field(json_writer_t *self, const char *prop, unsigned char num);
+void jsonw_hu_field(json_writer_t *self, const char *prop, unsigned short num);
+void jsonw_int_field(json_writer_t *self, const char *prop, int num);
+void jsonw_s64_field(json_writer_t *self, const char *prop, int64_t num);
+void jsonw_null_field(json_writer_t *self, const char *prop);
+void jsonw_luint_field(json_writer_t *self, const char *prop,
+			unsigned long num);
+void jsonw_lluint_field(json_writer_t *self, const char *prop,
+			unsigned long long num);
+
+/* Collections */
+void jsonw_start_object(json_writer_t *self);
+void jsonw_end_object(json_writer_t *self);
+
+void jsonw_start_array(json_writer_t *self);
+void jsonw_end_array(json_writer_t *self);
+
+/* Override default exception handling */
+typedef void (jsonw_err_handler_fn)(const char *);
+
+#endif /* _JSON_WRITER_H_ */
-- 
2.27.0

