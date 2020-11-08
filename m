Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD9F2AABC0
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 16:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgKHPIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 10:08:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728631AbgKHPIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 10:08:40 -0500
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050::465:103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B59C0613D3
        for <netdev@vger.kernel.org>; Sun,  8 Nov 2020 07:08:40 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4CTcvp0tFszQlB3;
        Sun,  8 Nov 2020 16:08:38 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1604848116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y6oSCaqzN1RPuFNpyhQ90aQmzkuY9zrzrKoMdyJkg3o=;
        b=GMmZ32ZdLh8y7Y/0CN+CnKPzdnHMu/Zx7cDq2QCxO+DY5J8AvXa5MNiRkSGSZoc3cCza73
        xLUxe3tPqrGJlgm0nFRA0DeUXrsr7iNVmEnuNJ2MQdmfmZl1X2jfxG0EFjhmEmo+pPct8X
        ngZ9mSCP5YO3j22vGbuA6Qa/BWlmtev3K5H+pjPN+WjGf1LB1lF687Kw966wHrYuIlBbo5
        dAK701QBbmS7RXG55G4/vnaYqSa9Lhq++3835hibgi46o/yfpKZsmT49dVjB5Aw70Ctq8M
        C2HbDw0uijSxaZddceHsYUulDqqgeVHI+wgbKEmzdEGcDDhvfV0tUoT+H75lZg==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter06.heinlein-hosting.de (spamfilter06.heinlein-hosting.de [80.241.56.125]) (amavisd-new, port 10030)
        with ESMTP id 2EMPoZM6hI3t; Sun,  8 Nov 2020 16:08:34 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>,
        Leon Romanovsky <leon@kernel.org>,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next v3 10/11] Add skeleton of a new tool, dcb
Date:   Sun,  8 Nov 2020 16:07:31 +0100
Message-Id: <9f46aa75764256d0701df1006f05c4614bba22b9.1604847919.git.me@pmachata.org>
In-Reply-To: <cover.1604847919.git.me@pmachata.org>
References: <cover.1604847919.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 0.10 / 15.00 / 15.00
X-Rspamd-Queue-Id: 07C93171A
X-Rspamd-UID: 10a4fc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Linux DCB interface allows configuration of a broad range of
hardware-specific attributes, such as TC scheduling, flow control, per-port
buffer configuration, TC rate, etc. Add a new tool to show that
configuration and tweak it.

DCB allows configuration of several objects, and possibly could expand to
pre-standard CEE interfaces. Therefore the tool itself is a lean shell that
dispatches to subtools each dedicated to one of the objects.

Signed-off-by: Petr Machata <me@pmachata.org>
---

Notes:
    v3:
    - Fix help output and man page to show the arguments as they are, so
      -p and --pretty, not -[p]retty, which is inaccurate.

 Makefile       |   2 +-
 dcb/Makefile   |  24 +++
 dcb/dcb.c      | 405 +++++++++++++++++++++++++++++++++++++++++++++++++
 dcb/dcb.h      |  35 +++++
 man/man8/dcb.8 | 103 +++++++++++++
 5 files changed, 568 insertions(+), 1 deletion(-)
 create mode 100644 dcb/Makefile
 create mode 100644 dcb/dcb.c
 create mode 100644 dcb/dcb.h
 create mode 100644 man/man8/dcb.8

diff --git a/Makefile b/Makefile
index 5b040415a12b..e64c65992585 100644
--- a/Makefile
+++ b/Makefile
@@ -55,7 +55,7 @@ WFLAGS += -Wmissing-declarations -Wold-style-definition -Wformat=2
 CFLAGS := $(WFLAGS) $(CCOPTS) -I../include -I../include/uapi $(DEFINES) $(CFLAGS)
 YACCFLAGS = -d -t -v
 
-SUBDIRS=lib ip tc bridge misc netem genl tipc devlink rdma man
+SUBDIRS=lib ip tc bridge misc netem genl tipc devlink rdma dcb man
 
 LIBNETLINK=../lib/libutil.a ../lib/libnetlink.a
 LDLIBS += $(LIBNETLINK)
diff --git a/dcb/Makefile b/dcb/Makefile
new file mode 100644
index 000000000000..9966c8f0bfa4
--- /dev/null
+++ b/dcb/Makefile
@@ -0,0 +1,24 @@
+# SPDX-License-Identifier: GPL-2.0
+include ../config.mk
+
+TARGETS :=
+
+ifeq ($(HAVE_MNL),y)
+
+DCBOBJ = dcb.o
+TARGETS += dcb
+
+endif
+
+all: $(TARGETS) $(LIBS)
+
+dcb: $(DCBOBJ) $(LIBNETLINK)
+	$(QUIET_LINK)$(CC) $^ $(LDFLAGS) $(LDLIBS) -o $@
+
+install: all
+	for i in $(TARGETS); \
+	do install -m 0755 $$i $(DESTDIR)$(SBINDIR); \
+	done
+
+clean:
+	rm -f $(DCBOBJ) $(TARGETS)
diff --git a/dcb/dcb.c b/dcb/dcb.c
new file mode 100644
index 000000000000..5c4969e4f651
--- /dev/null
+++ b/dcb/dcb.c
@@ -0,0 +1,405 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include <stdio.h>
+#include <linux/dcbnl.h>
+#include <libmnl/libmnl.h>
+#include <getopt.h>
+
+#include "dcb.h"
+#include "mnl_utils.h"
+#include "namespace.h"
+#include "utils.h"
+#include "version.h"
+
+static int dcb_init(struct dcb *dcb)
+{
+	dcb->buf = malloc(MNL_SOCKET_BUFFER_SIZE);
+	if (dcb->buf == NULL) {
+		perror("Netlink buffer allocation");
+		return -1;
+	}
+
+	dcb->nl = mnlu_socket_open(NETLINK_ROUTE);
+	if (dcb->nl == NULL) {
+		perror("Open netlink socket");
+		goto err_socket_open;
+	}
+
+	new_json_obj_plain(dcb->json_output);
+	return 0;
+
+err_socket_open:
+	free(dcb->buf);
+	return -1;
+}
+
+static void dcb_fini(struct dcb *dcb)
+{
+	delete_json_obj_plain();
+	mnl_socket_close(dcb->nl);
+}
+
+static struct dcb *dcb_alloc(void)
+{
+	struct dcb *dcb;
+
+	dcb = calloc(1, sizeof(*dcb));
+	if (!dcb)
+		return NULL;
+	return dcb;
+}
+
+static void dcb_free(struct dcb *dcb)
+{
+	free(dcb);
+}
+
+struct dcb_get_attribute {
+	struct dcb *dcb;
+	int attr;
+	void *data;
+	size_t data_len;
+};
+
+static int dcb_get_attribute_attr_ieee_cb(const struct nlattr *attr, void *data)
+{
+	struct dcb_get_attribute *ga = data;
+	uint16_t len;
+
+	if (mnl_attr_get_type(attr) != ga->attr)
+		return MNL_CB_OK;
+
+	len = mnl_attr_get_payload_len(attr);
+	if (len != ga->data_len) {
+		fprintf(stderr, "Wrong len %d, expected %zd\n", len, ga->data_len);
+		return MNL_CB_ERROR;
+	}
+
+	memcpy(ga->data, mnl_attr_get_payload(attr), ga->data_len);
+	return MNL_CB_STOP;
+}
+
+static int dcb_get_attribute_attr_cb(const struct nlattr *attr, void *data)
+{
+	if (mnl_attr_get_type(attr) != DCB_ATTR_IEEE)
+		return MNL_CB_OK;
+
+	return mnl_attr_parse_nested(attr, dcb_get_attribute_attr_ieee_cb, data);
+}
+
+static int dcb_get_attribute_cb(const struct nlmsghdr *nlh, void *data)
+{
+	return mnl_attr_parse(nlh, sizeof(struct dcbmsg), dcb_get_attribute_attr_cb, data);
+}
+
+static int dcb_set_attribute_attr_cb(const struct nlattr *attr, void *data)
+{
+	uint16_t len;
+	uint8_t err;
+
+	if (mnl_attr_get_type(attr) != DCB_ATTR_IEEE)
+		return MNL_CB_OK;
+
+	len = mnl_attr_get_payload_len(attr);
+	if (len != 1) {
+		fprintf(stderr, "Response attribute expected to have size 1, not %d\n", len);
+		return MNL_CB_ERROR;
+	}
+
+	err = mnl_attr_get_u8(attr);
+	if (err) {
+		fprintf(stderr, "Error when attempting to set attribute: %s\n",
+			strerror(err));
+		return MNL_CB_ERROR;
+	}
+
+	return MNL_CB_STOP;
+}
+
+static int dcb_set_attribute_cb(const struct nlmsghdr *nlh, void *data)
+{
+	return mnl_attr_parse(nlh, sizeof(struct dcbmsg), dcb_set_attribute_attr_cb, data);
+}
+
+static int dcb_talk(struct dcb *dcb, struct nlmsghdr *nlh, mnl_cb_t cb, void *data)
+{
+	int ret;
+
+	ret = mnl_socket_sendto(dcb->nl, nlh, nlh->nlmsg_len);
+	if (ret < 0) {
+		perror("mnl_socket_sendto");
+		return -1;
+	}
+
+	return mnlu_socket_recv_run(dcb->nl, nlh->nlmsg_seq, dcb->buf, MNL_SOCKET_BUFFER_SIZE,
+				    cb, data);
+}
+
+static struct nlmsghdr *dcb_prepare(struct dcb *dcb, const char *dev,
+				    uint32_t nlmsg_type, uint8_t dcb_cmd)
+{
+	struct dcbmsg dcbm = {
+		.cmd = dcb_cmd,
+	};
+	struct nlmsghdr *nlh;
+
+	nlh = mnlu_msg_prepare(dcb->buf, nlmsg_type, NLM_F_REQUEST, &dcbm, sizeof(dcbm));
+	mnl_attr_put_strz(nlh, DCB_ATTR_IFNAME, dev);
+	return nlh;
+}
+
+int dcb_get_attribute(struct dcb *dcb, const char *dev, int attr, void *data, size_t data_len)
+{
+	struct dcb_get_attribute ga;
+	struct nlmsghdr *nlh;
+	int ret;
+
+	nlh = dcb_prepare(dcb, dev, RTM_GETDCB, DCB_CMD_IEEE_GET);
+
+	ga = (struct dcb_get_attribute) {
+		.dcb = dcb,
+		.attr = attr,
+		.data = data,
+		.data_len = data_len,
+	};
+	ret = dcb_talk(dcb, nlh, dcb_get_attribute_cb, &ga);
+	if (ret) {
+		perror("Attribute read");
+		return ret;
+	}
+	return 0;
+}
+
+int dcb_set_attribute(struct dcb *dcb, const char *dev, int attr, const void *data, size_t data_len)
+{
+	struct nlmsghdr *nlh;
+	struct nlattr *nest;
+	int ret;
+
+	nlh = dcb_prepare(dcb, dev, RTM_GETDCB, DCB_CMD_IEEE_SET);
+
+	nest = mnl_attr_nest_start(nlh, DCB_ATTR_IEEE);
+	mnl_attr_put(nlh, attr, data_len, data);
+	mnl_attr_nest_end(nlh, nest);
+
+	ret = dcb_talk(dcb, nlh, dcb_set_attribute_cb, NULL);
+	if (ret) {
+		perror("Attribute write");
+		return ret;
+	}
+	return 0;
+}
+
+void dcb_print_array_num(FILE *fp, const __u8 *array, size_t size)
+{
+	SPRINT_BUF(b);
+	size_t i;
+
+	for (i = 0; i < size; i++) {
+		snprintf(b, sizeof(b), "%zd:%%d ", i);
+		print_uint(PRINT_ANY, NULL, b, array[i]);
+	}
+}
+
+void dcb_print_array_kw(FILE *fp, const __u8 *array, size_t array_size,
+			const char *const kw[], size_t kw_size)
+{
+	SPRINT_BUF(b);
+	size_t i;
+
+	for (i = 0; i < array_size; i++) {
+		__u8 emt = array[i];
+
+		snprintf(b, sizeof(b), "%zd:%%s ", i);
+		if (emt < kw_size && kw[emt])
+			print_string(PRINT_ANY, NULL, b, kw[emt]);
+		else
+			print_string(PRINT_ANY, NULL, b, "???");
+	}
+}
+
+void dcb_print_named_array(FILE *fp, const char *fp_name, const char *json_name,
+			   const __u8 *array, size_t size,
+			   void (*print_array)(FILE *, const __u8 *, size_t))
+{
+	open_json_array(PRINT_JSON, json_name);
+	print_string(PRINT_FP, NULL, "%s ", fp_name);
+	print_array(fp, array, size);
+	close_json_array(PRINT_JSON, json_name);
+}
+
+int dcb_parse_mapping(__u32 key, __u8 value, __u8 max_value, __u8 *array,
+		      const char *what_key, const char *what_value)
+{
+	bool is_all = key == (__u32) -1;
+
+	if (!is_all && key >= IEEE_8021QAZ_MAX_TCS) {
+		fprintf(stderr, "In %s:%s mapping, %s is expected to be 0..%d\n",
+			what_key, what_value, what_key, IEEE_8021QAZ_MAX_TCS - 1);
+		return -EINVAL;
+	}
+
+	if (value > max_value) {
+		fprintf(stderr, "In %s:%s mapping, %s is expected to be 0..%d\n",
+			what_key, what_value, what_value, max_value);
+		return -EINVAL;
+	}
+
+	if (is_all) {
+		for (key = 0; key < IEEE_8021QAZ_MAX_TCS; key++)
+			array[key] = value;
+	} else {
+		array[key] = value;
+	}
+
+	return 0;
+}
+
+int dcb_cmd_parse_dev(struct dcb *dcb, int argc, char **argv,
+		      int (*and_then)(struct dcb *dcb, const char *dev,
+				      int argc, char **argv),
+		      void (*help)(void))
+{
+	const char *dev;
+
+	if (!argc || matches(*argv, "help") == 0) {
+		help();
+		return 0;
+	} else if (matches(*argv, "dev") == 0) {
+		NEXT_ARG();
+		dev = *argv;
+		if (check_ifname(dev)) {
+			invarg("not a valid ifname", *argv);
+			return -EINVAL;
+		}
+		NEXT_ARG_FWD();
+		return and_then(dcb, dev, argc, argv);
+	} else {
+		fprintf(stderr, "Expected `dev DEV', not `%s'", *argv);
+		help();
+		return -EINVAL;
+	}
+}
+
+static void dcb_help(void)
+{
+	fprintf(stderr,
+		"Usage: dcb [ OPTIONS ] OBJECT { COMMAND | help }\n"
+		"       dcb [ -f | --force ] { -b | --batch } filename [ -N | --Netns ] netnsname\n"
+		"where  OBJECT :=\n"
+		"       OPTIONS := [ -V | --Version | -j | --json | -p | --pretty | -v | --verbose ]\n");
+}
+
+static int dcb_cmd(struct dcb *dcb, int argc, char **argv)
+{
+	if (!argc || matches(*argv, "help") == 0) {
+		dcb_help();
+		return 0;
+	}
+
+	fprintf(stderr, "Object \"%s\" is unknown\n", *argv);
+	return -ENOENT;
+}
+
+static int dcb_batch_cmd(int argc, char *argv[], void *data)
+{
+	struct dcb *dcb = data;
+
+	return dcb_cmd(dcb, argc, argv);
+}
+
+static int dcb_batch(struct dcb *dcb, const char *name, bool force)
+{
+	return do_batch(name, force, dcb_batch_cmd, dcb);
+}
+
+int main(int argc, char **argv)
+{
+	static const struct option long_options[] = {
+		{ "Version",		no_argument,		NULL, 'V' },
+		{ "force",		no_argument,		NULL, 'f' },
+		{ "batch",		required_argument,	NULL, 'b' },
+		{ "json",		no_argument,		NULL, 'j' },
+		{ "pretty",		no_argument,		NULL, 'p' },
+		{ "Netns",		required_argument,	NULL, 'N' },
+		{ "help",		no_argument,		NULL, 'h' },
+		{ NULL, 0, NULL, 0 }
+	};
+	const char *batch_file = NULL;
+	bool force = false;
+	struct dcb *dcb;
+	int opt;
+	int err;
+	int ret;
+
+	dcb = dcb_alloc();
+	if (!dcb) {
+		fprintf(stderr, "Failed to allocate memory for dcb\n");
+		return EXIT_FAILURE;
+	}
+
+	while ((opt = getopt_long(argc, argv, "b:c::fhjnpvN:V",
+				  long_options, NULL)) >= 0) {
+
+		switch (opt) {
+		case 'V':
+			printf("dcb utility, iproute2-%s\n", version);
+			ret = EXIT_SUCCESS;
+			goto dcb_free;
+		case 'f':
+			force = true;
+			break;
+		case 'b':
+			batch_file = optarg;
+			break;
+		case 'j':
+			dcb->json_output = true;
+			break;
+		case 'p':
+			pretty = true;
+			break;
+		case 'N':
+			if (netns_switch(optarg)) {
+				ret = EXIT_FAILURE;
+				goto dcb_free;
+			}
+			break;
+		case 'h':
+			dcb_help();
+			return 0;
+		default:
+			fprintf(stderr, "Unknown option.\n");
+			dcb_help();
+			ret = EXIT_FAILURE;
+			goto dcb_free;
+		}
+	}
+
+	argc -= optind;
+	argv += optind;
+
+	err = dcb_init(dcb);
+	if (err) {
+		ret = EXIT_FAILURE;
+		goto dcb_free;
+	}
+
+	if (batch_file)
+		err = dcb_batch(dcb, batch_file, force);
+	else
+		err = dcb_cmd(dcb, argc, argv);
+
+	if (err) {
+		ret = EXIT_FAILURE;
+		goto dcb_fini;
+	}
+
+	ret = EXIT_SUCCESS;
+
+dcb_fini:
+	dcb_fini(dcb);
+dcb_free:
+	dcb_free(dcb);
+
+	return ret;
+}
diff --git a/dcb/dcb.h b/dcb/dcb.h
new file mode 100644
index 000000000000..1d31a0f94652
--- /dev/null
+++ b/dcb/dcb.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __DCB_H__
+#define __DCB_H__ 1
+
+#include <stdbool.h>
+#include <stddef.h>
+
+/* dcb.c */
+
+struct dcb {
+	char *buf;
+	struct mnl_socket *nl;
+	bool json_output;
+};
+
+int dcb_parse_mapping(__u32 key, __u8 value, __u8 max_value, __u8 *array,
+		      const char *what_key, const char *what_value);
+int dcb_cmd_parse_dev(struct dcb *dcb, int argc, char **argv,
+		      int (*and_then)(struct dcb *dcb, const char *dev,
+				      int argc, char **argv),
+		      void (*help)(void));
+
+int dcb_get_attribute(struct dcb *dcb, const char *dev, int attr,
+		      void *data, size_t data_len);
+int dcb_set_attribute(struct dcb *dcb, const char *dev, int attr,
+		      const void *data, size_t data_len);
+
+void dcb_print_named_array(FILE *fp, const char *fp_name, const char *json_name,
+			   const __u8 *array, size_t size,
+			   void (*print_array)(FILE *, const __u8 *, size_t));
+void dcb_print_array_num(FILE *fp, const __u8 *array, size_t size);
+void dcb_print_array_kw(FILE *fp, const __u8 *array, size_t array_size,
+			const char *const kw[], size_t kw_size);
+
+#endif /* __DCB_H__ */
diff --git a/man/man8/dcb.8 b/man/man8/dcb.8
new file mode 100644
index 000000000000..19433bfb906d
--- /dev/null
+++ b/man/man8/dcb.8
@@ -0,0 +1,103 @@
+.TH DCB 8 "19 October 2020" "iproute2" "Linux"
+.SH NAME
+dcb \- show / manipulate DCB (Data Center Bridging) settings
+.SH SYNOPSIS
+.sp
+.ad l
+.in +8
+
+.ti -8
+.B dcb
+.RB "[ " -force " ] "
+.BI "-batch " filename
+.sp
+
+.ti -8
+.B dcb
+.RI "[ " OPTIONS " ] "
+.B help
+.sp
+
+.SH OPTIONS
+
+.TP
+.BR "\-V" , " --Version"
+Print the version of the
+.B dcb
+utility and exit.
+
+.TP
+.BR "\-b", " --batch " <FILENAME>
+Read commands from provided file or standard input and invoke them. First
+failure will cause termination of dcb.
+
+.TP
+.BR "\-f", " --force"
+Don't terminate dcb on errors in batch mode. If there were any errors during
+execution of the commands, the application return code will be non zero.
+
+.TP
+.BR "\-j" , " --json"
+Generate JSON output.
+
+.TP
+.BR "\-p" , " --pretty"
+When combined with -j generate a pretty JSON output.
+
+.SH OBJECTS
+
+.SH COMMANDS
+
+A \fICOMMAND\fR specifies the action to perform on the object. The set of
+possible actions depends on the object type. As a rule, it is possible to
+.B show
+objects and to invoke topical
+.B help,
+which prints a list of available commands and argument syntax conventions.
+
+.SH ARRAY PARAMETERS
+
+Like commands, specification of parameters is in the domain of individual
+objects (and their commands) as well. However, much of the DCB interface
+revolves around arrays of fixed size that specify one value per some key, such
+as per traffic class or per priority. There is therefore a single syntax for
+adjusting elements of these arrays. It consists of a series of
+\fIKEY\fB:\fIVALUE\fR pairs, where the meaning of the individual keys and values
+depends on the parameter.
+
+The elements are evaluated in order from left to right, and the latter ones
+override the earlier ones. The elements that are not specified on the command
+line are queried from the kernel and their current value is retained.
+
+As an example, take a made-up parameter tc-juju, which can be set to charm
+traffic in a given TC with either good luck or bad luck. \fIKEY\fR can therefore
+be 0..7 (as is usual for TC numbers in DCB), and \fIVALUE\fR either of
+\fBnone\fR, \fBgood\fR, and \fBbad\fR. An example of changing a juju value of
+TCs 0 and 7, while leaving all other intact, would then be:
+
+.P
+# dcb foo set dev eth0 tc-juju 0:good 7:bad
+
+A special key, \fBall\fR, is recognized which sets the same value to all array
+elements. This can be combined with the usual single-element syntax. E.g. in the
+following, the juju of all keys is set to \fBnone\fR, except 0 and 7, which have
+other values:
+
+.P
+# dcb foo set dev eth0 tc-juju all:none 0:good 7:bad
+
+.SH EXIT STATUS
+Exit status is 0 if command was successful or a positive integer upon failure.
+
+.SH SEE ALSO
+.BR dcb-ets (8)
+.br
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
2.25.1

