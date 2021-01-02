Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCFF2E85F6
	for <lists+netdev@lfdr.de>; Sat,  2 Jan 2021 01:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbhABAFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jan 2021 19:05:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727216AbhABAE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jan 2021 19:04:58 -0500
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7651EC0613CF
        for <netdev@vger.kernel.org>; Fri,  1 Jan 2021 16:04:16 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4D72Dv337NzQlRT;
        Sat,  2 Jan 2021 01:04:15 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1609545853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nU8hcxXJKPswDfU9YD1zOkojOisNQjbuTQCu67WZlFY=;
        b=xo8c9pDKQ5w5w09WF26WU07jKUPnKhzu66e9lBu20OR9FwjoJRqasv++mS8OVQW7GbwDii
        GPFjhaLsgGqewIXM1mp0MFsEFuBQeF5+II/SNT5ttpI4/eKFnfSErQDacZHWHfUIlZ0oKS
        GZGxnlDE3k4bd3O6jOztbzGdLo/aSZYk84XFzKrXQCiOPWxxUCa4Q7mazhnaPacsfoCaQX
        34yLTrNXBC4QX+jHg4PHNvdtw4dGCIrdYTMVVL3ctGDef4MDXRKA3v+38fE1hfhAUnFkt9
        uZqRvL31doeCLNvul3TKUhMjKnvZva+mY/nzYJDpLnrjb+R/1nIoe1uLrarfkw==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id fyy2HLB3P2pz; Sat,  2 Jan 2021 01:04:12 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next v2 7/7] dcb: Add a subtool for the DCBX object
Date:   Sat,  2 Jan 2021 01:03:41 +0100
Message-Id: <3dc4091311a7d44247779d1fc0130bf05adbdc9d.1609544200.git.me@pmachata.org>
In-Reply-To: <cover.1609544200.git.me@pmachata.org>
References: <cover.1609544200.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -1.09 / 15.00 / 15.00
X-Rspamd-Queue-Id: 606011718
X-Rspamd-UID: f65114
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Linux DCBX object is a 1-byte bitfield of flags that configure whether
the DCBX protocol is implemented in the device or in the host, and which
version of the protocol should be used. Add a tool to access the per-port
Linux DCBX object.

For example:

	# dcb dcbx set dev eni1np1 host ieee
	# dcb dcbx show dev eni1np1
	host ieee

Signed-off-by: Petr Machata <me@pmachata.org>
---
 dcb/Makefile        |   1 +
 dcb/dcb.c           |   4 +-
 dcb/dcb.h           |   4 +
 dcb/dcb_dcbx.c      | 192 ++++++++++++++++++++++++++++++++++++++++++++
 man/man8/dcb-dcbx.8 | 108 +++++++++++++++++++++++++
 5 files changed, 308 insertions(+), 1 deletion(-)
 create mode 100644 dcb/dcb_dcbx.c
 create mode 100644 man/man8/dcb-dcbx.8

diff --git a/dcb/Makefile b/dcb/Makefile
index 13d45f2b96b1..02d5d044cf09 100644
--- a/dcb/Makefile
+++ b/dcb/Makefile
@@ -8,6 +8,7 @@ ifeq ($(HAVE_MNL),y)
 DCBOBJ = dcb.o \
          dcb_app.o \
          dcb_buffer.o \
+         dcb_dcbx.o \
          dcb_ets.o \
          dcb_maxrate.o \
          dcb_pfc.o
diff --git a/dcb/dcb.c b/dcb/dcb.c
index 644059c44ee7..64a9ef02d256 100644
--- a/dcb/dcb.c
+++ b/dcb/dcb.c
@@ -465,7 +465,7 @@ static void dcb_help(void)
 	fprintf(stderr,
 		"Usage: dcb [ OPTIONS ] OBJECT { COMMAND | help }\n"
 		"       dcb [ -f | --force ] { -b | --batch } filename [ -n | --netns ] netnsname\n"
-		"where  OBJECT := { app | buffer | ets | maxrate | pfc }\n"
+		"where  OBJECT := { app | buffer | dcbx | ets | maxrate | pfc }\n"
 		"       OPTIONS := [ -V | --Version | -i | --iec | -j | --json\n"
 		"                  | -N | --Numeric | -p | --pretty\n"
 		"                  | -s | --statistics | -v | --verbose]\n");
@@ -480,6 +480,8 @@ static int dcb_cmd(struct dcb *dcb, int argc, char **argv)
 		return dcb_cmd_app(dcb, argc - 1, argv + 1);
 	} else if (matches(*argv, "buffer") == 0) {
 		return dcb_cmd_buffer(dcb, argc - 1, argv + 1);
+	} else if (matches(*argv, "dcbx") == 0) {
+		return dcb_cmd_dcbx(dcb, argc - 1, argv + 1);
 	} else if (matches(*argv, "ets") == 0) {
 		return dcb_cmd_ets(dcb, argc - 1, argv + 1);
 	} else if (matches(*argv, "maxrate") == 0) {
diff --git a/dcb/dcb.h b/dcb/dcb.h
index 92eada169cd0..244c3d3c30e3 100644
--- a/dcb/dcb.h
+++ b/dcb/dcb.h
@@ -62,6 +62,10 @@ int dcb_cmd_app(struct dcb *dcb, int argc, char **argv);
 
 int dcb_cmd_buffer(struct dcb *dcb, int argc, char **argv);
 
+/* dcb_dcbx.c */
+
+int dcb_cmd_dcbx(struct dcb *dcb, int argc, char **argv);
+
 /* dcb_ets.c */
 
 int dcb_cmd_ets(struct dcb *dcb, int argc, char **argv);
diff --git a/dcb/dcb_dcbx.c b/dcb/dcb_dcbx.c
new file mode 100644
index 000000000000..244b671b893b
--- /dev/null
+++ b/dcb/dcb_dcbx.c
@@ -0,0 +1,192 @@
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
+static void dcb_dcbx_help_set(void)
+{
+	fprintf(stderr,
+		"Usage: dcb dcbx set dev STRING\n"
+		"           [ host | lld-managed ]\n"
+		"           [ cee | ieee ] [ static ]\n"
+		"\n"
+	);
+}
+
+static void dcb_dcbx_help_show(void)
+{
+	fprintf(stderr,
+		"Usage: dcb dcbx show dev STRING\n"
+		"\n"
+	);
+}
+
+static void dcb_dcbx_help(void)
+{
+	fprintf(stderr,
+		"Usage: dcb dcbx help\n"
+		"\n"
+	);
+	dcb_dcbx_help_show();
+	dcb_dcbx_help_set();
+}
+
+struct dcb_dcbx_flag {
+	__u8 value;
+	const char *key_fp;
+	const char *key_json;
+};
+
+static struct dcb_dcbx_flag dcb_dcbx_flags[] = {
+	{DCB_CAP_DCBX_HOST, "host"},
+	{DCB_CAP_DCBX_LLD_MANAGED, "lld-managed", "lld_managed"},
+	{DCB_CAP_DCBX_VER_CEE, "cee"},
+	{DCB_CAP_DCBX_VER_IEEE, "ieee"},
+	{DCB_CAP_DCBX_STATIC, "static"},
+};
+
+static void dcb_dcbx_print(__u8 dcbx)
+{
+	int bit;
+	int i;
+
+	while ((bit = ffs(dcbx))) {
+		bool found = false;
+
+		bit--;
+		for (i = 0; i < ARRAY_SIZE(dcb_dcbx_flags); i++) {
+			struct dcb_dcbx_flag *flag = &dcb_dcbx_flags[i];
+
+			if (flag->value == 1 << bit) {
+				print_bool(PRINT_JSON, flag->key_json ?: flag->key_fp,
+					   NULL, true);
+				print_string(PRINT_FP, NULL, "%s ", flag->key_fp);
+				found = true;
+				break;
+			}
+		}
+
+		if (!found)
+			fprintf(stderr, "Unknown DCBX bit %#x.\n", 1 << bit);
+
+		dcbx &= ~(1 << bit);
+	}
+
+	print_nl();
+}
+
+static int dcb_dcbx_get(struct dcb *dcb, const char *dev, __u8 *dcbx)
+{
+	__u16 payload_len;
+	void *payload;
+	int err;
+
+	err = dcb_get_attribute_bare(dcb, DCB_CMD_IEEE_GET, dev, DCB_ATTR_DCBX,
+				     &payload, &payload_len);
+	if (err != 0)
+		return err;
+
+	if (payload_len != 1) {
+		fprintf(stderr, "DCB_ATTR_DCBX payload has size %d, expected 1.\n",
+			payload_len);
+		return -EINVAL;
+	}
+	*dcbx = *(__u8 *) payload;
+	return 0;
+}
+
+static int dcb_dcbx_set(struct dcb *dcb, const char *dev, __u8 dcbx)
+{
+	return dcb_set_attribute_bare(dcb, DCB_CMD_SDCBX, dev, DCB_ATTR_DCBX,
+				      &dcbx, 1, DCB_ATTR_DCBX);
+}
+
+static int dcb_cmd_dcbx_set(struct dcb *dcb, const char *dev, int argc, char **argv)
+{
+	__u8 dcbx = 0;
+	__u8 i;
+
+	if (!argc) {
+		dcb_dcbx_help_set();
+		return 0;
+	}
+
+	do {
+		if (matches(*argv, "help") == 0) {
+			dcb_dcbx_help_set();
+			return 0;
+		}
+
+		for (i = 0; i < ARRAY_SIZE(dcb_dcbx_flags); i++) {
+			struct dcb_dcbx_flag *flag = &dcb_dcbx_flags[i];
+
+			if (matches(*argv, flag->key_fp) == 0) {
+				dcbx |= flag->value;
+				NEXT_ARG_FWD();
+				goto next;
+			}
+		}
+
+		fprintf(stderr, "What is \"%s\"?\n", *argv);
+		dcb_dcbx_help_set();
+		return -EINVAL;
+
+next:
+		;
+	} while (argc > 0);
+
+	return dcb_dcbx_set(dcb, dev, dcbx);
+}
+
+static int dcb_cmd_dcbx_show(struct dcb *dcb, const char *dev, int argc, char **argv)
+{
+	__u8 dcbx;
+	int ret;
+
+	ret = dcb_dcbx_get(dcb, dev, &dcbx);
+	if (ret != 0)
+		return ret;
+
+	while (argc > 0) {
+		if (matches(*argv, "help") == 0) {
+			dcb_dcbx_help_show();
+			return 0;
+		} else {
+			fprintf(stderr, "What is \"%s\"?\n", *argv);
+			dcb_dcbx_help_show();
+			return -EINVAL;
+		}
+
+		NEXT_ARG_FWD();
+	}
+
+	open_json_object(NULL);
+	dcb_dcbx_print(dcbx);
+	close_json_object();
+	return 0;
+}
+
+int dcb_cmd_dcbx(struct dcb *dcb, int argc, char **argv)
+{
+	if (!argc || matches(*argv, "help") == 0) {
+		dcb_dcbx_help();
+		return 0;
+	} else if (matches(*argv, "show") == 0) {
+		NEXT_ARG_FWD();
+		return dcb_cmd_parse_dev(dcb, argc, argv,
+					 dcb_cmd_dcbx_show, dcb_dcbx_help_show);
+	} else if (matches(*argv, "set") == 0) {
+		NEXT_ARG_FWD();
+		return dcb_cmd_parse_dev(dcb, argc, argv,
+					 dcb_cmd_dcbx_set, dcb_dcbx_help_set);
+	} else {
+		fprintf(stderr, "What is \"%s\"?\n", *argv);
+		dcb_dcbx_help();
+		return -EINVAL;
+	}
+}
diff --git a/man/man8/dcb-dcbx.8 b/man/man8/dcb-dcbx.8
new file mode 100644
index 000000000000..52133e348a70
--- /dev/null
+++ b/man/man8/dcb-dcbx.8
@@ -0,0 +1,108 @@
+.TH DCB-DCBX 8 "13 December 2020" "iproute2" "Linux"
+.SH NAME
+dcb-dcbx \- show / manipulate port DCBX (Data Center Bridging eXchange)
+.SH SYNOPSIS
+.sp
+.ad l
+.in +8
+
+.ti -8
+.B dcb
+.RI "[ " OPTIONS " ] "
+.B dcbx
+.RI "{ " COMMAND " | " help " }"
+.sp
+
+.ti -8
+.B dcb dcbx show dev
+.RI DEV
+
+.ti -8
+.B dcb dcbx set dev
+.RI DEV
+.RB "[ " host " ]"
+.RB "[ " lld-managed " ]"
+.RB "[ " cee " ]"
+.RB "[ " ieee " ]"
+.RB "[ " static " ]"
+
+.SH DESCRIPTION
+
+Data Center Bridging eXchange (DCBX) is a protocol used by DCB devices to
+exchange configuration information with directly connected peers. The Linux DCBX
+object is a 1-byte bitfield of flags that configure whether DCBX is implemented
+in the device or in the host, and which version of the protocol should be used.
+.B dcb dcbx
+is used to access the per-port Linux DCBX object.
+
+There are two principal modes of operation: in
+.B host
+mode, DCBX protocol is implemented by the host LLDP agent, and the DCB
+interfaces are used to propagate the negotiate parameters to capable devices. In
+.B lld-managed
+mode, the configuration is handled by the device, and DCB interfaces are used
+for inspection of negotiated parameters, and can also be used to set initial
+parameters.
+
+.SH PARAMETERS
+
+When used with
+.B dcb dcbx set,
+the following keywords enable the corresponding configuration. The keywords that
+are not mentioned on the command line are considered disabled. When used with
+.B show,
+each enabled feature is shown by its corresponding keyword.
+
+.TP
+.B host
+.TQ
+.B lld-managed
+The device is in the host mode of operation and, respectively, the lld-managed
+mode of operation, as described above. In principle these two keywords are
+mutually exclusive, but
+.B dcb dcbx
+allows setting both and lets the driver handle it as appropriate.
+
+.TP
+.B cee
+.TQ
+.B ieee
+The device supports CEE (Converged Enhanced Ethernet) and, respecively, IEEE
+version of the DCB specification. Typically only one of these will be set, but
+.B dcb dcbx
+does not mandate this.
+
+.TP
+.B static
+indicates the engine supports static configuration. No actual negotiation is
+performed, negotiated parameters are always the initial configuration.
+
+.SH EXAMPLE & USAGE
+
+Put the DCB engine into the "host" mode of operation, and use IEEE-standardized
+DCB interfaces:
+
+.P
+# dcb dcbx set dev eth0 host ieee
+
+Show what was set:
+
+.P
+# dcb dcbx show dev eth0
+.br
+host ieee
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
-- 
2.26.2

