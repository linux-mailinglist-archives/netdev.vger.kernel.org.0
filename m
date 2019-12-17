Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20511122DEE
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 15:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbfLQOEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 09:04:42 -0500
Received: from sitav-80046.hsr.ch ([152.96.80.46]:60864 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728546AbfLQOEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 09:04:39 -0500
Received: from obook.wlp.is (unknown [185.12.128.225])
        by mail.strongswan.org (Postfix) with ESMTPSA id C098A405F4;
        Tue, 17 Dec 2019 14:56:22 +0100 (CET)
From:   Martin Willi <martin@strongswan.org>
To:     netfilter-devel@vger.kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH iptables] extensions: Add new xt_slavedev input interface match extension
Date:   Tue, 17 Dec 2019 14:56:16 +0100
Message-Id: <20191217135616.25751-3-martin@strongswan.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191217135616.25751-1-martin@strongswan.org>
References: <20191217135616.25751-1-martin@strongswan.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When filtering in INPUT or FORWARD within a VRF domain, input interface
matching is done against the VRF device name instead of the real input
interface. This makes interface based filtering difficult if the interface
is associated to a VRF or some other layer 3 master device. While
PREROUTING can match against the real input interface, using it for
filtering is often inconvenient.

To allow filtering in INPUT/FORWARD against the real input interface,
add a match extension for this specific purpose. It is very similar
to the layer 2 slave device match implemented in xt_physdev to match
against bridge ports, but matches on layer 3 slave devices.

As an option, the user may specify a "strict" flag, limiting matches to
interfaces that strictly are layer 3 slave devices.

Signed-off-by: Martin Willi <martin@strongswan.org>
---
 extensions/libxt_slavedev.c           | 98 +++++++++++++++++++++++++++
 extensions/libxt_slavedev.man         | 19 ++++++
 extensions/libxt_slavedev.t           |  4 ++
 include/linux/netfilter/xt_slavedev.h | 18 +++++
 4 files changed, 139 insertions(+)
 create mode 100644 extensions/libxt_slavedev.c
 create mode 100644 extensions/libxt_slavedev.man
 create mode 100644 extensions/libxt_slavedev.t
 create mode 100644 include/linux/netfilter/xt_slavedev.h

diff --git a/extensions/libxt_slavedev.c b/extensions/libxt_slavedev.c
new file mode 100644
index 000000000000..d957c889e1a1
--- /dev/null
+++ b/extensions/libxt_slavedev.c
@@ -0,0 +1,98 @@
+#include <stdio.h>
+#include <string.h>
+#include <xtables.h>
+#include <linux/netfilter/xt_slavedev.h>
+
+enum {
+	O_SLAVEDEV_IN = 0,
+	O_SLAVEDEV_IN_STRICT,
+};
+
+static void slavedev_help(void)
+{
+	printf(
+"slavedev match options:\n"
+" [!] --slavedev-in inputname[+]	input device name ([+] for wildcard)\n"
+"     --slavedev-in-strict		input device must be layer 3 slave device\n");
+}
+
+static const struct xt_option_entry slavedev_opts[] = {
+	{.name = "slavedev-in", .id = O_SLAVEDEV_IN, .type = XTTYPE_STRING,
+	 .flags = XTOPT_INVERT | XTOPT_PUT,
+	 XTOPT_POINTER(struct xt_slavedev_info, iniface)},
+	{.name = "slavedev-in-strict", .id = O_SLAVEDEV_IN_STRICT,
+	 .type = XTTYPE_NONE},
+	XTOPT_TABLEEND,
+};
+
+static void slavedev_parse(struct xt_option_call *cb)
+{
+	struct xt_slavedev_info *info = cb->data;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_SLAVEDEV_IN:
+		xtables_parse_interface(cb->arg, info->iniface,
+					info->iniface_mask);
+		if (cb->invert)
+			info->flags |= XT_SLAVEDEV_IN_INV;
+		break;
+	case O_SLAVEDEV_IN_STRICT:
+		info->flags |= XT_SLAVEDEV_IN_STRICT;
+		break;
+	}
+}
+
+static bool slavedev_has_iniface(const struct xt_slavedev_info *info)
+{
+	int i;
+
+	for (i = 0; i < sizeof(info->iniface_mask); i++)
+		if (info->iniface_mask[i])
+			return true;
+	return false;
+}
+
+static void
+slavedev_print(const void *ip, const struct xt_entry_match *match, int numeric)
+{
+	const struct xt_slavedev_info *info = (const void *)match->data;
+
+	printf(" slavedev");
+	if (slavedev_has_iniface(info))
+		printf("%s in %s",
+		       (info->flags & XT_SLAVEDEV_IN_INV) ? " !" : "",
+		       info->iniface);
+	if (info->flags & XT_SLAVEDEV_IN_STRICT)
+		printf(" in-strict");
+}
+
+static void slavedev_save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_slavedev_info *info = (const void *)match->data;
+
+	if (slavedev_has_iniface(info))
+		printf("%s --slavedev-in %s",
+		       (info->flags & XT_SLAVEDEV_IN_INV) ? " !" : "",
+		       info->iniface);
+	if (info->flags & XT_SLAVEDEV_IN_STRICT)
+		printf(" --slavedev-in-strict");
+}
+
+static struct xtables_match slavedev_match = {
+	.family		= NFPROTO_UNSPEC,
+	.name		= "slavedev",
+	.version	= XTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_slavedev_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_slavedev_info)),
+	.help		= slavedev_help,
+	.print		= slavedev_print,
+	.save		= slavedev_save,
+	.x6_parse	= slavedev_parse,
+	.x6_options	= slavedev_opts,
+};
+
+void _init(void)
+{
+	xtables_register_match(&slavedev_match);
+}
diff --git a/extensions/libxt_slavedev.man b/extensions/libxt_slavedev.man
new file mode 100644
index 000000000000..127eab4872f4
--- /dev/null
+++ b/extensions/libxt_slavedev.man
@@ -0,0 +1,19 @@
+This module matches on the real input interface enslaved to layer 3 master
+devices. For devices associated to VRF interfaces, the standard matching in
+\fBINPUT\fP and \fBFORWARD\fP chains can match against the VRF interface
+name, only. The slavedev match can match against the real input interface
+instead.
+.PP
+The slavedef match is valid in the \fBINPUT\fP and \fBFORWARD\fP chains
+only, as \fBPREROUTING\fP always matches against the real input interface.
+.TP
+[\fB!\fP] \fB\-\-slavedev\-in\fP \fIname\fP
+Name of a slave device the packet has been received on. If the interface name
+ends in a "+", then any interface which begins with this name will match.
+Not specifying an input interface can be used to match any packet that
+was received over a layer 3 slave device if the strict flag below is given.
+.TP
+\fB\-\-slavedev\-in\-strict\fP
+Matches only if the input interface is actually a layer 3 slave device,
+i.e. is associated to a VRF domain. If this flag is omitted, it also
+matches input interfaces without a layer 3 master device.
diff --git a/extensions/libxt_slavedev.t b/extensions/libxt_slavedev.t
new file mode 100644
index 000000000000..80b0ff3b4264
--- /dev/null
+++ b/extensions/libxt_slavedev.t
@@ -0,0 +1,4 @@
+:INPUT,FORWARD
+-m slavedev --slavedev-in lo;=;OK
+-m slavedev --slavedev-in-strict;=;OK
+-m slavedev --slavedev-in eth+ --slavedev-in-strict;=;OK
diff --git a/include/linux/netfilter/xt_slavedev.h b/include/linux/netfilter/xt_slavedev.h
new file mode 100644
index 000000000000..d35785b04c4b
--- /dev/null
+++ b/include/linux/netfilter/xt_slavedev.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_XT_SLAVEDEV_H
+#define _UAPI_XT_SLAVEDEV_H
+
+#include <linux/types.h>
+#include <linux/if.h>
+
+#define XT_SLAVEDEV_IN_INV	0x01	/* invert interface match */
+#define XT_SLAVEDEV_IN_STRICT	0x02	/* require iif to be enslaved */
+#define XT_SLAVEDEV_MASK	(0x04 - 1)
+
+struct xt_slavedev_info {
+	char iniface[IFNAMSIZ];
+	unsigned char iniface_mask[IFNAMSIZ];
+	__u8 flags;
+};
+
+#endif /* _UAPI_XT_SLAVEDEV_H */
-- 
2.20.1

