Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB85293282
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 02:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389713AbgJTA7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 20:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389678AbgJTA7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 20:59:03 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D670C0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 17:59:03 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4CFZyF4gQzzQkmG;
        Tue, 20 Oct 2020 02:59:01 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1603155539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gzMFZ+FNM7MuwnVbdkog27ewSAYn05vdEdmYZjvnLO4=;
        b=mFSg8kUxe95l9U7qfU6pQ3qPS8qkuCEashUpaHqkpKeOo5uD6lGG4yGbWJUK6YcZN+ARFn
        o9sxlXTnnFamgD+OMFHZZW4fq78Lrrie9yfcbM7gfvXAo/NgC583ek2SeAk/aFHOBRPWoa
        KKr6YG/KZk4CDXuJCtZX8DAmXSFowKSBrW6JQjqQ/fRI8ROjjAF/9pFzjbC49tR6HfzeN9
        uUqP8/ivDjy2Fe5hMW36+taPkxkLZviGdWuEkRdgKPnWSLdD/0nd1dB584LPC5fi5f57Zw
        7f6LdgOr0736WgBnQN1j1b1sQQkl9d5h0XUklx117lBq6CY89bWqrjjjN6kQvw==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id jjUUwgdijNo6; Tue, 20 Oct 2020 02:58:57 +0200 (CEST)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 14/15] Add skeleton of a new tool, dcb
Date:   Tue, 20 Oct 2020 02:58:22 +0200
Message-Id: <59a6e0bd537efbb8ecdfb623f074bb623a06237c.1603154867.git.me@pmachata.org>
In-Reply-To: <cover.1603154867.git.me@pmachata.org>
References: <cover.1603154867.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 0.08 / 15.00 / 15.00
X-Rspamd-Queue-Id: 69A2017DC
X-Rspamd-UID: 2d4de1
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
 Makefile       |   2 +-
 dcb/Makefile   |  24 ++++
 dcb/dcb.c      | 377 +++++++++++++++++++++++++++++++++++++++++++++++++
 dcb/dcb.h      |  32 +++++
 man/man8/dcb.8 | 103 ++++++++++++++
 5 files changed, 537 insertions(+), 1 deletion(-)
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
index 000000000000..c85008bbe1e9
--- /dev/null
+++ b/dcb/dcb.c
@@ -0,0 +1,377 @@
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
+	SPRINT_BUF(b1);
+	SPRINT_BUF(b2);
+	size_t i;
+
+	for (i = 0; i < size; i++) {
+		snprintf(b1, sizeof(b1), "%zd", i);
+		snprintf(b2, sizeof(b2), "%zd:%%d ", i);
+		print_uint(PRINT_ANY, b1, b2, array[i]);
+	}
+}
+
+void dcb_print_array_kw(FILE *fp, const __u8 *array, size_t array_size,
+			const char *const kw[], size_t kw_size)
+{
+	SPRINT_BUF(b1);
+	SPRINT_BUF(b2);
+	size_t i;
+
+	for (i = 0; i < array_size; i++) {
+		__u8 emt = array[i];
+
+		snprintf(b1, sizeof(b1), "%zd", i);
+		snprintf(b2, sizeof(b2), "%zd:%%s ", i);
+		if (emt < kw_size && kw[emt])
+			print_string(PRINT_ANY, b1, b2, kw[emt]);
+		else
+			print_string(PRINT_ANY, b1, b2, "???");
+	}
+}
+
+void dcb_print_named_array(FILE *fp, const char *name, const __u8 *array, size_t size,
+			   void (*print_array)(FILE *, const __u8 *, size_t))
+{
+	open_json_object(name);
+	print_string(PRINT_FP, NULL, "%s ", name);
+	print_array(fp, array, size);
+	close_json_object();
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
+		"       dcb [ -f[orce] ] -b[atch] filename -N[etns] netnsname\n"
+		"where  OBJECT :=\n"
+		"       OPTIONS := { -V[ersion] | -j[son] | -p[retty] | -v[erbose] }\n");
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
+	while ((opt = getopt_long(argc, argv, "Vfb:njpvsN:",
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
index 000000000000..7334ef7a94d8
--- /dev/null
+++ b/dcb/dcb.h
@@ -0,0 +1,32 @@
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
+void dcb_print_named_array(FILE *fp, const char *name, const __u8 *array, size_t size,
+			   void (*print_array)(FILE *, const __u8 *, size_t));
+void dcb_print_array_num(FILE *fp, const __u8 *array, size_t size);
+void dcb_print_array_kw(FILE *fp, const __u8 *array, size_t array_size,
+			const char *const kw[], size_t kw_size);
+
+#endif /* __DCB_H__ */
diff --git a/man/man8/dcb.8 b/man/man8/dcb.8
new file mode 100644
index 000000000000..25ddf204d60e
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
+.BR "\-b", " \-batch " <FILENAME>
+Read commands from provided file or standard input and invoke them. First
+failure will cause termination of dcb.
+
+.TP
+.B \-force
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
+following, the juju or all keys is set to \fBnone\fR, except 0 and 7, which have
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

