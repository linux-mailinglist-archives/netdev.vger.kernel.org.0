Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1C03D6742
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 21:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbhGZSYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 14:24:12 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:54125 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232474AbhGZSYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 14:24:06 -0400
Received: from h7.dl5rb.org.uk (p57907709.dip0.t-ipconnect.de [87.144.119.9])
        (Authenticated sender: ralf@linux-mips.org)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 287F7E0002;
        Mon, 26 Jul 2021 19:04:32 +0000 (UTC)
Received: from h7.dl5rb.org.uk (localhost [127.0.0.1])
        by h7.dl5rb.org.uk (8.16.1/8.16.1) with ESMTPS id 16QJ4W9q836347
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Mon, 26 Jul 2021 21:04:32 +0200
Received: (from ralf@localhost)
        by h7.dl5rb.org.uk (8.16.1/8.16.1/Submit) id 16QJ4WZa836346;
        Mon, 26 Jul 2021 21:04:32 +0200
Message-Id: <80f422e5bf353498221a2bb08a2d8a819f3e1543.1627295848.git.ralf@linux-mips.org>
In-Reply-To: <cover.1627295848.git.ralf@linux-mips.org>
References: <cover.1627295848.git.ralf@linux-mips.org>
From:   Ralf Baechle <ralf@linux-mips.org>
Date:   Wed, 18 Jan 2017 23:08:21 +0100
Subject: [PATCH 1/6] AX.25: Add ax25_ntop implementation.
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, linux-hams@vger.kernel.org
Lines:  138
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

AX.25 addresses are based on Amateur radio callsigns followed by an SSID
like XXXXXX-SS where the callsign is up to 6 characters which are either
letters or digits and the SSID is a decimal number in the range 0..15.
Amateur radio callsigns are assigned by a country's relevant authorities
and are 3..6 characters though a few countries have assigned callsigns
longer than that.  AX.25 is not able to handle such longer callsigns.

Being based on HDLC AX.25 encodes addresses by shifting them one bit left
thus zeroing bit 0, the HDLC extension bit for all but the last bit of
a packet's address field but for our purposes here we're not considering
the HDLC extension bit that is it will always be zero.

Linux' internal representation of AX.25 addresses in Linux is very similar
to this on the on-air or on-the-wire format.  The callsign is padded to
6 octets by adding spaces, followed by the SSID octet then all 7 octets
are left-shifted by one byte.

This for example turns "LINUX-1" where the callsign is LINUX and SSID is 1
into 98:92:9c:aa:b0:40:02.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
---
 Makefile        |  3 ++
 include/utils.h |  2 ++
 lib/ax25_ntop.c | 74 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 79 insertions(+)
 create mode 100644 lib/ax25_ntop.c

diff --git a/Makefile b/Makefile
index 5bc11477..551f528b 100644
--- a/Makefile
+++ b/Makefile
@@ -40,6 +40,9 @@ DEFINES+=-DCONFDIR=\"$(CONFDIR)\" \
          -DNETNS_RUN_DIR=\"$(NETNS_RUN_DIR)\" \
          -DNETNS_ETC_DIR=\"$(NETNS_ETC_DIR)\"
 
+#options for AX.25
+ADDLIB+=ax25_ntop.o
+
 #options for mpls
 ADDLIB+=mpls_ntop.o mpls_pton.o
 
diff --git a/include/utils.h b/include/utils.h
index 28eaad8e..31c1e442 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -209,6 +209,8 @@ bool matches(const char *prefix, const char *string);
 int inet_addr_match(const inet_prefix *a, const inet_prefix *b, int bits);
 int inet_addr_match_rta(const inet_prefix *m, const struct rtattr *rta);
 
+const char *ax25_ntop(int af, const void *addr, char *str, socklen_t len);
+
 const char *mpls_ntop(int af, const void *addr, char *str, size_t len);
 int mpls_pton(int af, const char *src, void *addr, size_t alen);
 
diff --git a/lib/ax25_ntop.c b/lib/ax25_ntop.c
new file mode 100644
index 00000000..48098581
--- /dev/null
+++ b/lib/ax25_ntop.c
@@ -0,0 +1,74 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+
+#include <errno.h>
+#include <sys/socket.h>
+#include <netax25/ax25.h>
+
+#include "utils.h"
+
+/*
+ * AX.25 addresses are based on Amateur radio callsigns followed by an SSID
+ * like XXXXXX-SS where the callsign is up to 6 characters which are either
+ * letters or digits and the SSID is a decimal number in the range 0..15.
+ * Amateur radio callsigns are assigned by a country's relevant authorities
+ * and are 3..6 characters though a few countries have assigned callsigns
+ * longer than that.  AX.25 is not able to handle such longer callsigns.
+ *
+ * Being based on HDLC AX.25 encodes addresses by shifting them one bit left
+ * thus zeroing bit 0, the HDLC extension bit for all but the last bit of
+ * a packet's address field but for our purposes here we're not considering
+ * the HDLC extension bit that is it will always be zero.
+ *
+ * Linux' internal representation of AX.25 addresses in Linux is very similar
+ * to this on the on-air or on-the-wire format.  The callsign is padded to
+ * 6 octets by adding spaces, followed by the SSID octet then all 7 octets
+ * are left-shifted by one byte.
+ *
+ * This for example turns "LINUX-1" where the callsign is LINUX and SSID is 1
+ * into 98:92:9c:aa:b0:40:02.
+ */
+
+static const char *ax25_ntop1(const ax25_address *src, char *dst,
+			      socklen_t size)
+{
+	char c, *s;
+	int n;
+
+	for (n = 0, s = dst; n < 6; n++) {
+		c = (src->ax25_call[n] >> 1) & 0x7f;
+		if (c != ' ')
+			*s++ = c;
+	}
+
+	*s++ = '-';
+
+	n = ((src->ax25_call[6] >> 1) & 0x0f);
+	if (n > 9) {
+		*s++ = '1';
+		n -= 10;
+	}
+
+	*s++ = n + '0';
+	*s++ = '\0';
+
+	if (*dst == '\0' || *dst == '-') {
+		dst[0] = '*';
+		dst[1] = '\0';
+	}
+
+	return dst;
+}
+
+const char *ax25_ntop(int af, const void *addr, char *buf, socklen_t buflen)
+{
+	switch (af) {
+	case AF_AX25:
+		errno = 0;
+		return ax25_ntop1((ax25_address *)addr, buf, buflen);
+
+	default:
+		errno = EAFNOSUPPORT;
+	}
+
+	return NULL;
+}
-- 
2.31.1


