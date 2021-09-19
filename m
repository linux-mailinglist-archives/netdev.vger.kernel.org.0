Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905C741173A
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 16:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240505AbhITOhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 10:37:54 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:58347 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233406AbhITOhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 10:37:42 -0400
Received: from h7.dl5rb.org.uk (p5790756f.dip0.t-ipconnect.de [87.144.117.111])
        (Authenticated sender: ralf@linux-mips.org)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 5F9141BF213;
        Mon, 20 Sep 2021 14:36:13 +0000 (UTC)
Received: from h7.dl5rb.org.uk (localhost [127.0.0.1])
        by h7.dl5rb.org.uk (8.16.1/8.16.1) with ESMTPS id 18KEaCcA1202535
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 16:36:12 +0200
Received: (from ralf@localhost)
        by h7.dl5rb.org.uk (8.16.1/8.16.1/Submit) id 18KEaCLY1202534;
        Mon, 20 Sep 2021 16:36:12 +0200
Message-Id: <1eb184007b7b07ad0d4c42cbd58be265eb3c67b7.1632059758.git.ralf@linux-mips.org>
In-Reply-To: <cover.1632059758.git.ralf@linux-mips.org>
References: <cover.1632059758.git.ralf@linux-mips.org>
From:   Ralf Baechle <ralf@linux-mips.org>
Date:   Sun, 19 Sep 2021 15:30:26 +0200
Subject: [PATCH v2 3/6] NETROM: Add netrom_ntop implementation.
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, linux-hams@vger.kernel.org
Lines:  118
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NETROM uses AX.25 addresses so this is a simple wrapper around ax25_ntop1.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
---
 Makefile          |  3 +++
 include/utils.h   |  2 ++
 lib/ax25_ntop.c   | 22 +++++++++++++++-------
 lib/netrom_ntop.c | 23 +++++++++++++++++++++++
 4 files changed, 43 insertions(+), 7 deletions(-)
 create mode 100644 lib/netrom_ntop.c

diff --git a/Makefile b/Makefile
index 551f528b..df894d54 100644
--- a/Makefile
+++ b/Makefile
@@ -46,6 +46,9 @@ ADDLIB+=ax25_ntop.o
 #options for mpls
 ADDLIB+=mpls_ntop.o mpls_pton.o
 
+#options for NETROM
+ADDLIB+=netrom_ntop.o
+
 CC := gcc
 HOSTCC ?= $(CC)
 DEFINES += -D_GNU_SOURCE
diff --git a/include/utils.h b/include/utils.h
index 947ab5c3..6ab2fa74 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -203,6 +203,8 @@ const char *ax25_ntop(int af, const void *addr, char *str, socklen_t len);
 const char *mpls_ntop(int af, const void *addr, char *str, size_t len);
 int mpls_pton(int af, const char *src, void *addr, size_t alen);
 
+const char *netrom_ntop(int af, const void *addr, char *str, socklen_t len);
+
 extern int __iproute2_hz_internal;
 int __get_hz(void);
 
diff --git a/lib/ax25_ntop.c b/lib/ax25_ntop.c
index 48098581..cfd0e04b 100644
--- a/lib/ax25_ntop.c
+++ b/lib/ax25_ntop.c
@@ -6,13 +6,22 @@
 
 #include "utils.h"
 
+const char *ax25_ntop1(const ax25_address *src, char *dst, socklen_t size);
+
 /*
  * AX.25 addresses are based on Amateur radio callsigns followed by an SSID
- * like XXXXXX-SS where the callsign is up to 6 characters which are either
- * letters or digits and the SSID is a decimal number in the range 0..15.
+ * like XXXXXX-SS where the callsign consists of up to 6 ASCII characters
+ * which are either letters or digits and the SSID is a decimal number in the
+ * range 0..15.
  * Amateur radio callsigns are assigned by a country's relevant authorities
  * and are 3..6 characters though a few countries have assigned callsigns
  * longer than that.  AX.25 is not able to handle such longer callsigns.
+ * There are further restrictions on the format of valid callsigns by
+ * applicable national and international law.  Linux doesn't need to care and
+ * will happily accept anything that consists of 6 ASCII characters in the
+ * range of A-Z and 0-9 for a callsign such as the default AX.25 MAC address
+ * LINUX-1 and the default broadcast address QST-0.
+ * The SSID is just a number and not encoded in ASCII digits.
  *
  * Being based on HDLC AX.25 encodes addresses by shifting them one bit left
  * thus zeroing bit 0, the HDLC extension bit for all but the last bit of
@@ -22,14 +31,13 @@
  * Linux' internal representation of AX.25 addresses in Linux is very similar
  * to this on the on-air or on-the-wire format.  The callsign is padded to
  * 6 octets by adding spaces, followed by the SSID octet then all 7 octets
- * are left-shifted by one byte.
+ * are left-shifted by one bit.
  *
- * This for example turns "LINUX-1" where the callsign is LINUX and SSID is 1
- * into 98:92:9c:aa:b0:40:02.
+ * For example, for the address "LINUX-1" the callsign is LINUX and SSID is 1
+ * the internal format is 98:92:9c:aa:b0:40:02.
  */
 
-static const char *ax25_ntop1(const ax25_address *src, char *dst,
-			      socklen_t size)
+const char *ax25_ntop1(const ax25_address *src, char *dst, socklen_t size)
 {
 	char c, *s;
 	int n;
diff --git a/lib/netrom_ntop.c b/lib/netrom_ntop.c
new file mode 100644
index 00000000..3dd6cb0b
--- /dev/null
+++ b/lib/netrom_ntop.c
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <sys/socket.h>
+#include <errno.h>
+#include <linux/ax25.h>
+
+#include "utils.h"
+
+const char *ax25_ntop1(const ax25_address *src, char *dst, socklen_t size);
+
+const char *netrom_ntop(int af, const void *addr, char *buf, socklen_t buflen)
+{
+	switch (af) {
+	case AF_NETROM:
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


