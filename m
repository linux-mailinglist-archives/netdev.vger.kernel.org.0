Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDB82D6B84
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 00:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389286AbgLJXEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 18:04:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388892AbgLJXEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 18:04:07 -0500
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6BBEC0611D0
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 15:03:26 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4CsTwM55MnzQlJF;
        Fri, 11 Dec 2020 00:02:59 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1607641377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0Srx/VUSameVuk/fCFFayGJTkiH3wo26j9OeHYbJZAI=;
        b=OgRm5nJ/zAwO4/p7Q9hDQisO7svvxuyHNRu59O5O6213NpNf7TjxPw5rS4g3+JdWVA6VNB
        O4ygTPQqoHqTz3+pKPrOVHcKzc0qpGpE8yoZ/VETgDc9clr6tsknkgGMuJnWEjknPsUNEE
        y3l6by9En2b0tbuEv7Ul1U7l6BFGk3O+EU43p77GSQcxIi1gVDGsOfVjxas1qEDZ12vMmK
        +u9IAjVA/n/b16Bk9DejmoDiDd2220QAPku74zYMZBg0FwD3kdG79Uc1EXDYVG6Iupvbq9
        Cg+Uua/YiT9pI6ntDKnI7uq7xQb0j3+TdCEu4UeASDPBqY89j171F2AisEov6g==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter05.heinlein-hosting.de (spamfilter05.heinlein-hosting.de [80.241.56.123]) (amavisd-new, port 10030)
        with ESMTP id RgsFMBm4Lyrv; Fri, 11 Dec 2020 00:02:56 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 09/10] dcb: Add a subtool for the DCB buffer object
Date:   Fri, 11 Dec 2020 00:02:23 +0100
Message-Id: <dc48908daa28ccf13c7e4281650f94f4fcaf987e.1607640819.git.me@pmachata.org>
In-Reply-To: <cover.1607640819.git.me@pmachata.org>
References: <cover.1607640819.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -1.33 / 15.00 / 15.00
X-Rspamd-Queue-Id: AC4B3171A
X-Rspamd-UID: bc8cad
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DCBNL buffer interfaces are an extension to the 802.1q DCB interfaces and
allow configuration of port headroom buffers.

Add a dcb subtool to allow showing and tweaking of buffer priority mapping
and buffer sizes. For example:

    # dcb buf show dev eni1np1
    prio-buffer 0:0 1:0 2:0 3:3 4:0 5:0 6:6 7:0
    buffer-size 0:10000 1:0 2:0 3:70000 4:0 5:0 6:10000 7:0
    total-size 221072

Signed-off-by: Petr Machata <me@pmachata.org>
---
 dcb/Makefile          |   2 +-
 dcb/dcb.c             |   4 +-
 dcb/dcb.h             |   4 +
 dcb/dcb_buffer.c      | 235 ++++++++++++++++++++++++++++++++++++++++++
 man/man8/dcb-buffer.8 | 126 ++++++++++++++++++++++
 man/man8/dcb.8        |   7 +-
 6 files changed, 375 insertions(+), 3 deletions(-)
 create mode 100644 dcb/dcb_buffer.c
 create mode 100644 man/man8/dcb-buffer.8

diff --git a/dcb/Makefile b/dcb/Makefile
index ea557a309e81..dc84422f6096 100644
--- a/dcb/Makefile
+++ b/dcb/Makefile
@@ -5,7 +5,7 @@ TARGETS :=
 
 ifeq ($(HAVE_MNL),y)
 
-DCBOBJ = dcb.o dcb_ets.o dcb_pfc.o
+DCBOBJ = dcb.o dcb_buffer.o dcb_ets.o dcb_pfc.o
 TARGETS += dcb
 
 endif
diff --git a/dcb/dcb.c b/dcb/dcb.c
index cc07d3ddcee0..570405a7e628 100644
--- a/dcb/dcb.c
+++ b/dcb/dcb.c
@@ -332,7 +332,7 @@ static void dcb_help(void)
 	fprintf(stderr,
 		"Usage: dcb [ OPTIONS ] OBJECT { COMMAND | help }\n"
 		"       dcb [ -f | --force ] { -b | --batch } filename [ -N | --Netns ] netnsname\n"
-		"where  OBJECT := { ets | pfc }\n"
+		"where  OBJECT := { buffer | ets | pfc }\n"
 		"       OPTIONS := [ -V | --Version | -i | --iec | -j | --json\n"
 		"                  | -p | --pretty | -s | --statistics | -v | --verbose]\n");
 }
@@ -342,6 +342,8 @@ static int dcb_cmd(struct dcb *dcb, int argc, char **argv)
 	if (!argc || matches(*argv, "help") == 0) {
 		dcb_help();
 		return 0;
+	} else if (matches(*argv, "buffer") == 0) {
+		return dcb_cmd_buffer(dcb, argc - 1, argv + 1);
 	} else if (matches(*argv, "ets") == 0) {
 		return dcb_cmd_ets(dcb, argc - 1, argv + 1);
 	} else if (matches(*argv, "pfc") == 0) {
diff --git a/dcb/dcb.h b/dcb/dcb.h
index 4ecc6afd59a9..0638d63938fc 100644
--- a/dcb/dcb.h
+++ b/dcb/dcb.h
@@ -42,6 +42,10 @@ void dcb_print_array_on_off(const __u8 *array, size_t size);
 void dcb_print_array_kw(const __u8 *array, size_t array_size,
 			const char *const kw[], size_t kw_size);
 
+/* dcb_buffer.c */
+
+int dcb_cmd_buffer(struct dcb *dcb, int argc, char **argv);
+
 /* dcb_ets.c */
 
 int dcb_cmd_ets(struct dcb *dcb, int argc, char **argv);
diff --git a/dcb/dcb_buffer.c b/dcb/dcb_buffer.c
new file mode 100644
index 000000000000..e6a88a00f4a6
--- /dev/null
+++ b/dcb/dcb_buffer.c
@@ -0,0 +1,235 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include <errno.h>
+#include <inttypes.h>
+#include <stdio.h>
+#include <linux/dcbnl.h>
+
+#include "dcb.h"
+#include "utils.h"
+
+static void dcb_buffer_help_set(void)
+{
+	fprintf(stderr,
+		"Usage: dcb buffer set dev STRING\n"
+		"           [ prio-buffer PRIO-MAP ]\n"
+		"           [ buffer-size SIZE-MAP ]\n"
+		"\n"
+		" where PRIO-MAP := [ PRIO-MAP ] PRIO-MAPPING\n"
+		"       PRIO-MAPPING := { all | PRIO }:BUFFER\n"
+		"       SIZE-MAP := [ SIZE-MAP ] SIZE-MAPPING\n"
+		"       SIZE-MAPPING := { all | BUFFER }:INTEGER\n"
+		"       PRIO := { 0 .. 7 }\n"
+		"       BUFFER := { 0 .. 7 }\n"
+		"\n"
+	);
+}
+
+static void dcb_buffer_help_show(void)
+{
+	fprintf(stderr,
+		"Usage: dcb buffer show dev STRING\n"
+		"           [ prio-buffer ] [ buffer-size ] [ total-size ]\n"
+		"\n"
+	);
+}
+
+static void dcb_buffer_help(void)
+{
+	fprintf(stderr,
+		"Usage: dcb buffer help\n"
+		"\n"
+	);
+	dcb_buffer_help_show();
+	dcb_buffer_help_set();
+}
+
+static int dcb_buffer_parse_mapping_prio_buffer(__u32 key, char *value, void *data)
+{
+	struct dcbnl_buffer *buffer = data;
+	__u8 buf;
+
+	if (get_u8(&buf, value, 0))
+		return -EINVAL;
+
+	return dcb_parse_mapping("PRIO", key, IEEE_8021Q_MAX_PRIORITIES - 1,
+				 "BUFFER", buf, DCBX_MAX_BUFFERS - 1,
+				 dcb_set_u8, buffer->prio2buffer);
+}
+
+static int dcb_buffer_parse_mapping_buffer_size(__u32 key, char *value, void *data)
+{
+	struct dcbnl_buffer *buffer = data;
+	unsigned int size;
+
+	if (get_size(&size, value)) {
+		fprintf(stderr, "%d:%s: Illegal value for buffer size\n", key, value);
+		return -EINVAL;
+	}
+
+	return dcb_parse_mapping("BUFFER", key, DCBX_MAX_BUFFERS - 1,
+				 "INTEGER", size, -1,
+				 dcb_set_u32, buffer->buffer_size);
+}
+
+static void dcb_buffer_print_total_size(const struct dcbnl_buffer *buffer)
+{
+	print_size(PRINT_ANY, "total_size", "total-size %s ", buffer->total_size);
+}
+
+static void dcb_buffer_print_prio_buffer(const struct dcbnl_buffer *buffer)
+{
+	dcb_print_named_array("prio_buffer", "prio-buffer",
+			      buffer->prio2buffer, ARRAY_SIZE(buffer->prio2buffer),
+			      dcb_print_array_u8);
+}
+
+static void dcb_buffer_print_buffer_size(const struct dcbnl_buffer *buffer)
+{
+	size_t size = ARRAY_SIZE(buffer->buffer_size);
+	SPRINT_BUF(b);
+	size_t i;
+
+	open_json_array(PRINT_JSON, "buffer_size");
+	print_string(PRINT_FP, NULL, "buffer-size ", NULL);
+
+	for (i = 0; i < size; i++) {
+		snprintf(b, sizeof(b), "%zd:%%s ", i);
+		print_size(PRINT_ANY, NULL, b, buffer->buffer_size[i]);
+	}
+
+	close_json_array(PRINT_JSON, "buffer_size");
+}
+
+static void dcb_buffer_print(const struct dcbnl_buffer *buffer)
+{
+	dcb_buffer_print_prio_buffer(buffer);
+	print_nl();
+
+	dcb_buffer_print_buffer_size(buffer);
+	print_nl();
+
+	dcb_buffer_print_total_size(buffer);
+	print_nl();
+}
+
+static int dcb_buffer_get(struct dcb *dcb, const char *dev, struct dcbnl_buffer *buffer)
+{
+	return dcb_get_attribute(dcb, dev, DCB_ATTR_DCB_BUFFER, buffer, sizeof(*buffer));
+}
+
+static int dcb_buffer_set(struct dcb *dcb, const char *dev, const struct dcbnl_buffer *buffer)
+{
+	return dcb_set_attribute(dcb, dev, DCB_ATTR_DCB_BUFFER, buffer, sizeof(*buffer));
+}
+
+static int dcb_cmd_buffer_set(struct dcb *dcb, const char *dev, int argc, char **argv)
+{
+	struct dcbnl_buffer buffer;
+	int ret;
+
+	if (!argc) {
+		dcb_buffer_help_set();
+		return 0;
+	}
+
+	ret = dcb_buffer_get(dcb, dev, &buffer);
+	if (ret)
+		return ret;
+
+	do {
+		if (matches(*argv, "help") == 0) {
+			dcb_buffer_help_set();
+			return 0;
+		} else if (matches(*argv, "prio-buffer") == 0) {
+			NEXT_ARG();
+			ret = parse_mapping(&argc, &argv, true,
+					    &dcb_buffer_parse_mapping_prio_buffer, &buffer);
+			if (ret) {
+				fprintf(stderr, "Invalid priority mapping %s\n", *argv);
+				return ret;
+			}
+			continue;
+		} else if (matches(*argv, "buffer-size") == 0) {
+			NEXT_ARG();
+			ret = parse_mapping(&argc, &argv, true,
+					    &dcb_buffer_parse_mapping_buffer_size, &buffer);
+			if (ret) {
+				fprintf(stderr, "Invalid buffer size mapping %s\n", *argv);
+				return ret;
+			}
+			continue;
+		} else {
+			fprintf(stderr, "What is \"%s\"?\n", *argv);
+			dcb_buffer_help_set();
+			return -EINVAL;
+		}
+
+		NEXT_ARG_FWD();
+	} while (argc > 0);
+
+	return dcb_buffer_set(dcb, dev, &buffer);
+}
+
+static int dcb_cmd_buffer_show(struct dcb *dcb, const char *dev, int argc, char **argv)
+{
+	struct dcbnl_buffer buffer;
+	int ret;
+
+	ret = dcb_buffer_get(dcb, dev, &buffer);
+	if (ret)
+		return ret;
+
+	open_json_object(NULL);
+
+	if (!argc) {
+		dcb_buffer_print(&buffer);
+		goto out;
+	}
+
+	do {
+		if (matches(*argv, "help") == 0) {
+			dcb_buffer_help_show();
+			return 0;
+		} else if (matches(*argv, "prio-buffer") == 0) {
+			dcb_buffer_print_prio_buffer(&buffer);
+			print_nl();
+		} else if (matches(*argv, "buffer-size") == 0) {
+			dcb_buffer_print_buffer_size(&buffer);
+			print_nl();
+		} else if (matches(*argv, "total-size") == 0) {
+			dcb_buffer_print_total_size(&buffer);
+			print_nl();
+		} else {
+			fprintf(stderr, "What is \"%s\"?\n", *argv);
+			dcb_buffer_help_show();
+			return -EINVAL;
+		}
+
+		NEXT_ARG_FWD();
+	} while (argc > 0);
+
+out:
+	close_json_object();
+	return 0;
+}
+
+int dcb_cmd_buffer(struct dcb *dcb, int argc, char **argv)
+{
+	if (!argc || matches(*argv, "help") == 0) {
+		dcb_buffer_help();
+		return 0;
+	} else if (matches(*argv, "show") == 0) {
+		NEXT_ARG_FWD();
+		return dcb_cmd_parse_dev(dcb, argc, argv,
+					 dcb_cmd_buffer_show, dcb_buffer_help_show);
+	} else if (matches(*argv, "set") == 0) {
+		NEXT_ARG_FWD();
+		return dcb_cmd_parse_dev(dcb, argc, argv,
+					 dcb_cmd_buffer_set, dcb_buffer_help_set);
+	} else {
+		fprintf(stderr, "What is \"%s\"?\n", *argv);
+		dcb_buffer_help();
+		return -EINVAL;
+	}
+}
diff --git a/man/man8/dcb-buffer.8 b/man/man8/dcb-buffer.8
new file mode 100644
index 000000000000..c7ba6a993ee6
--- /dev/null
+++ b/man/man8/dcb-buffer.8
@@ -0,0 +1,126 @@
+.TH DCB-BUFFER 8 "12 November 2020" "iproute2" "Linux"
+.SH NAME
+dcb-buffer \- show / manipulate port buffer settings of
+the DCB (Data Center Bridging) subsystem
+.SH SYNOPSIS
+.sp
+.ad l
+.in +8
+
+.ti -8
+.B dcb
+.RI "[ " OPTIONS " ] "
+.B buffer
+.RI "{ " COMMAND " | " help " }"
+.sp
+
+.ti -8
+.B dcb buffer show dev
+.RI DEV
+.RB "[ " prio-buffer " ]"
+.RB "[ " buffer-size " ]"
+.RB "[ " total-size " ]"
+
+.ti -8
+.B dcb buffer set dev
+.RI DEV
+.RB "[ " prio-buffer " " \fIPRIO-MAP " ]"
+.RB "[ " buffer-size " " \fISIZE-MAP " ]"
+
+.ti -8
+.IR PRIO-MAP " := [ " PRIO-MAP " ] " PRIO-MAPPING
+
+.ti -8
+.IR PRIO-MAPPING " := { " PRIO " | " \fBall " }" \fB:\fIBUFFER\fR
+
+.ti -8
+.IR SIZE-MAP " := [ " SIZE-MAP " ] " SIZE-MAPPING
+
+.ti -8
+.IR SIZE-MAPPING " := { " BUFFER " | " \fBall " }" \fB:\fISIZE\fR
+
+.ti -8
+.IR PRIO " := { " \fB0\fR " .. " \fB7\fR " }"
+
+.ti -8
+.IR BUFFER " := { " \fB0\fR " .. " \fB7\fR " }"
+
+.ti -8
+.IR SIZE " := { " INTEGER " | " INTEGER\fBK\fR " | " INTEGER\fBM\fR " | " ... " }"
+
+.SH DESCRIPTION
+
+.B dcb buffer
+is used to configure assignment of traffic to port buffers based on traffic
+priority, and sizes of those buffers. It can be also used to inspect the current
+configuration, as well as total device memory that the port buffers take.
+
+.SH PARAMETERS
+
+For read-write parameters, the following describes only the write direction,
+i.e. as used with the \fBset\fR command. For the \fBshow\fR command, the
+parameter name is to be used as a simple keyword without further arguments. This
+instructs the tool to show the value of a given parameter. When no parameters
+are given, the tool shows the complete buffer configuration.
+
+.TP
+.B total-size
+A read-only property that shows the total device memory taken up by port
+buffers. This might be more than a simple sum of individual buffer sizes if
+there are any hidden or internal buffers.
+
+.TP
+.B prio-buffer \fIPRIO-MAP
+\fIPRIO-MAP\fR uses the array parameter syntax, see
+.BR dcb (8)
+for details. Keys are priorities, values are buffer indices. For each priority
+sets a buffer where traffic with that priority is directed to.
+
+.TP
+.B buffer-size \fISIZE-MAP
+\fISIZE-MAP\fR uses the array parameter syntax, see
+.BR dcb (8)
+for details. Keys are buffer indices, values are sizes of that buffer in bytes.
+The sizes can use the notation documented in section PARAMETERS at
+.BR tc (8).
+Note that the size requested by the tool can be rounded or capped by the driver
+to satisfy the requirements of the device.
+
+.SH EXAMPLE & USAGE
+
+Configure the priomap in a one-to-one fashion:
+
+.P
+# dcb buffer set dev eth0 prio-buffer 0:0 1:1 2:2 3:3 4:4 5:5 6:6 7:7
+
+Set sizes of all buffers to 10KB, except for buffer 6, which will have the size
+1MB:
+
+.P
+# dcb buffer set dev eth0 buffer-size all:10K 6:1M
+
+Show what was set:
+
+.P
+# dcb buffer show dev eth0
+.br
+prio-buffer 0:0 1:1 2:2 3:3 4:4 5:5 6:6 7:7
+.br
+buffer-size 0:10Kb 1:10Kb 2:10Kb 3:10Kb 4:10Kb 5:10Kb 6:1Mb 7:10Kb
+.br
+total-size 1222Kb
+
+.SH EXIT STATUS
+Exit status is 0 if command was successful or a positive integer upon failure.
+
+.SH SEE ALSO
+.BR dcb (8)
+
+.SH REPORTING BUGS
+Report any bugs to the Network Developers mailing list
+.B <netdev@vger.kernel.org>
+where the development and maintenance is primarily done.
+You do not have to be subscribed to the list to send a message there.
+
+.SH AUTHOR
+Petr Machata <me@pmachata.org>
diff --git a/man/man8/dcb.8 b/man/man8/dcb.8
index 01febe166bdf..e14762365cef 100644
--- a/man/man8/dcb.8
+++ b/man/man8/dcb.8
@@ -9,7 +9,7 @@ dcb \- show / manipulate DCB (Data Center Bridging) settings
 .ti -8
 .B dcb
 .RI "[ " OPTIONS " ] "
-.RB "{ " ets " | " pfc " }"
+.RB "{ " buffer " | " ets " | " pfc " }"
 .RI "{ " COMMAND " | " help " }"
 .sp
 
@@ -63,6 +63,10 @@ part of the "show" output.
 
 .SH OBJECTS
 
+.TP
+.B buffer
+- Configuration of port buffers
+
 .TP
 .B ets
 - Configuration of ETS (Enhanced Transmission Selection)
@@ -115,6 +119,7 @@ other values:
 Exit status is 0 if command was successful or a positive integer upon failure.
 
 .SH SEE ALSO
+.BR dcb-buffer (8),
 .BR dcb-ets (8),
 .BR dcb-pfc (8)
 .br
-- 
2.25.1

