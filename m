Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C6228BE62
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 18:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403911AbgJLQqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 12:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390630AbgJLQqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 12:46:43 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8B6C0613D0
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 09:46:42 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 65534)
        id 801E7588C5A7E; Mon, 12 Oct 2020 18:46:40 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on a3.inai.de
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.2
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id 3B941588C5A7B;
        Mon, 12 Oct 2020 18:46:39 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     stephen@networkplumber.org
Cc:     jengelh@inai.de, netdev@vger.kernel.org
Subject: [iproute PATCH v2] lib/color: introduce freely configurable color strings
Date:   Mon, 12 Oct 2020 18:46:39 +0200
Message-Id: <20201012164639.20976-1-jengelh@inai.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement fine-grained control over color codes for iproute, very
similar to the GCC_COLORS environment variable.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 lib/color.c   | 125 +++++++++++++++++++++++++-------------------------
 man/man8/ip.8 |  25 ++++++++--
 2 files changed, 83 insertions(+), 67 deletions(-)

diff --git a/lib/color.c b/lib/color.c
index 59976847..2c1707f2 100644
--- a/lib/color.c
+++ b/lib/color.c
@@ -1,4 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+#include <stdbool.h>
 #include <stdio.h>
 #include <stdarg.h>
 #include <stdlib.h>
@@ -13,71 +14,38 @@
 
 static void set_color_palette(void);
 
-enum color {
-	C_RED,
-	C_GREEN,
-	C_YELLOW,
-	C_BLUE,
-	C_MAGENTA,
-	C_CYAN,
-	C_WHITE,
-	C_BOLD_RED,
-	C_BOLD_GREEN,
-	C_BOLD_YELLOW,
-	C_BOLD_BLUE,
-	C_BOLD_MAGENTA,
-	C_BOLD_CYAN,
-	C_BOLD_WHITE,
-	C_CLEAR
-};
-
-static const char * const color_codes[] = {
-	"\e[31m",
-	"\e[32m",
-	"\e[33m",
-	"\e[34m",
-	"\e[35m",
-	"\e[36m",
-	"\e[37m",
-	"\e[1;31m",
-	"\e[1;32m",
-	"\e[1;33m",
-	"\e[1;34m",
-	"\e[1;35m",
-	"\e[1;36m",
-	"\e[1;37m",
-	"\e[0m",
-	NULL,
-};
-
-/* light background */
-static enum color attr_colors_light[] = {
-	C_CYAN,
-	C_YELLOW,
-	C_MAGENTA,
-	C_BLUE,
-	C_GREEN,
-	C_RED,
+enum {
+	C_IFACE,
+	C_LLADDR,
+	C_V4ADDR,
+	C_V6ADDR,
+	C_OPERUP,
+	C_OPERDN,
 	C_CLEAR,
+	C_MAX,
 };
 
-/* dark background */
-static enum color attr_colors_dark[] = {
-	C_BOLD_CYAN,
-	C_BOLD_YELLOW,
-	C_BOLD_MAGENTA,
-	C_BOLD_BLUE,
-	C_BOLD_GREEN,
-	C_BOLD_RED,
-	C_CLEAR
+static const char default_colors[] =
+	"iface=36:lladdr=33:v4addr=35:v6addr=34:operup=32:operdn=31:clear=0";
+static const char default_colors_for_dark[] =
+	"iface=1;36:lladdr=1;33:v4addr=1;35:v6addr=1;34:operup=1;32:operdn=1;31:clear=0";
+static struct color_code {
+	const char match[8], *code;
+	int len;
+} color_codes[C_MAX] = {
+	{"iface="}, {"lladdr="}, {"v4addr="}, {"v6addr="}, {"operup="},
+	{"operdn="}, {"clear=", "0", 1},
 };
 
-static int is_dark_bg;
 static int color_is_enabled;
 
 static void enable_color(void)
 {
-	color_is_enabled = 1;
+	/* Without terminfo, the next best option is an env var heuristic */
+	const char *s = getenv("COLORTERM");
+
+	color_is_enabled = (s != NULL && strtoul(s, NULL, 0) != 0) ||
+			   getenv("COLORFGBG") != NULL;
 	set_color_palette();
 }
 
@@ -121,7 +89,8 @@ bool matches_color(const char *arg, int *val)
 
 static void set_color_palette(void)
 {
-	char *p = getenv("COLORFGBG");
+	const char *initstr = default_colors;
+	const char *p = getenv("COLORFGBG");
 
 	/*
 	 * COLORFGBG environment variable usually contains either two or three
@@ -131,7 +100,36 @@ static void set_color_palette(void)
 	if (p && (p = strrchr(p, ';')) != NULL
 		&& ((p[1] >= '0' && p[1] <= '6') || p[1] == '8')
 		&& p[2] == '\0')
-		is_dark_bg = 1;
+		initstr = default_colors_for_dark;
+	p = getenv("IPROUTE_COLORS");
+	if (p != NULL)
+		initstr = p;
+
+	for (p = initstr; *p != '\0'; ) {
+		unsigned int key = C_MAX;
+		const char *code = NULL, *next;
+		size_t j;
+
+		for (j = 0; j < ARRAY_SIZE(color_codes); ++j) {
+			if (strncmp(p, color_codes[j].match,
+			    strlen(color_codes[j].match)) != 0)
+				continue;
+			key = j;
+			code = p + strlen(color_codes[j].match);
+			break;
+		}
+
+		next = strchr(p, ':');
+		if (next == NULL)
+			next = p + strlen(p);
+		if (key != C_MAX) {
+			color_codes[key].code = code;
+			color_codes[key].len  = next - code;
+		}
+		p = next;
+		if (*next != '\0')
+			++p;
+	}
 }
 
 __attribute__((format(printf, 3, 4)))
@@ -139,6 +137,7 @@ int color_fprintf(FILE *fp, enum color_attr attr, const char *fmt, ...)
 {
 	int ret = 0;
 	va_list args;
+	const struct color_code *k;
 
 	va_start(args, fmt);
 
@@ -147,11 +146,13 @@ int color_fprintf(FILE *fp, enum color_attr attr, const char *fmt, ...)
 		goto end;
 	}
 
-	ret += fprintf(fp, "%s", color_codes[is_dark_bg ?
-		attr_colors_dark[attr] : attr_colors_light[attr]]);
-
+	k = &color_codes[attr];
+	if (k->code != NULL && *k->code != '\0')
+		ret += fprintf(fp, "\e[%.*sm", k->len, k->code);
 	ret += vfprintf(fp, fmt, args);
-	ret += fprintf(fp, "%s", color_codes[C_CLEAR]);
+	k = &color_codes[C_CLEAR];
+	if (k->code != NULL && *k->code != '\0')
+		ret += fprintf(fp, "\e[%.*sm", k->len, k->code);
 
 end:
 	va_end(args);
diff --git a/man/man8/ip.8 b/man/man8/ip.8
index c9f7671e..bfbdf9f8 100644
--- a/man/man8/ip.8
+++ b/man/man8/ip.8
@@ -199,8 +199,7 @@ precedence. This flag is ignored if
 .B \-json
 is also given.
 
-Used color palette can be influenced by
-.BR COLORFGBG
+The used color palette can be influenced by the \fBIPROUTE_COLORS\fP
 environment variable
 (see
 .BR ENVIRONMENT ).
@@ -359,15 +358,31 @@ or, if the objects of this class cannot be listed,
 .SH ENVIRONMENT
 .TP
 .B COLORFGBG
-If set, it's value is used for detection whether background is dark or
-light and use contrast colors for it.
+If set, its value is used to detect whether the background is dark or
+light and to select a different default palette.
 
-COLORFGBG environment variable usually contains either two or three
+The COLORFGBG environment variable usually contains either two or three
 values separated by semicolons; we want the last value in either case.
 If this value is 0-6 or 8, chose colors suitable for dark background:
 
 COLORFGBG=";0" ip -c a
+.TP
+\fBCOLORTERM\fP
+If set, its value is used to determine whether to enable color when
+--color=auto is in effect. iproute does not otherwise make use of terminfo and
+as such does not evaluate the TERM environment variable.
+.TP
+\fBIPROUTE_COLORS\fP
+Its value is a colon-separated list of capabilities and Select Graphic
+Rendition (SGR) substrings. SGR commands are interpreted by the terminal or
+terminal emulator. (See the section in the documentation of your text terminal
+for permitted values and their meanings as character attributes. The
+console_codes(4) manpage gives an overview of typical VT codes.) These
+substring values are integers in decimal representation and can be concatenated
+with semicolons.
 
+Default:
+\fIiface=36:lladdr=33:v4addr=35:v6addr=34:operup=32:operdn=31:clear=0\fP
 .SH EXIT STATUS
 Exit status is 0 if command was successful, and 1 if there is a syntax error.
 If an error was reported by the kernel exit status is 2.
-- 
2.28.0

