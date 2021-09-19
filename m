Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA1B411739
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 16:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240681AbhITOhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 10:37:53 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:33213 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237264AbhITOhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 10:37:42 -0400
Received: from h7.dl5rb.org.uk (p5790756f.dip0.t-ipconnect.de [87.144.117.111])
        (Authenticated sender: ralf@linux-mips.org)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 8941B1BF214;
        Mon, 20 Sep 2021 14:36:14 +0000 (UTC)
Received: from h7.dl5rb.org.uk (localhost [127.0.0.1])
        by h7.dl5rb.org.uk (8.16.1/8.16.1) with ESMTPS id 18KEaDxf1202543
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 16:36:13 +0200
Received: (from ralf@localhost)
        by h7.dl5rb.org.uk (8.16.1/8.16.1/Submit) id 18KEaDRg1202542;
        Mon, 20 Sep 2021 16:36:13 +0200
Message-Id: <b913c3f92657e40ec762ae214deb0e4a5bdec6ca.1632059758.git.ralf@linux-mips.org>
In-Reply-To: <cover.1632059758.git.ralf@linux-mips.org>
References: <cover.1632059758.git.ralf@linux-mips.org>
From:   Ralf Baechle <ralf@linux-mips.org>
Date:   Sun, 19 Sep 2021 15:30:26 +0200
Subject: [PATCH v2 5/6] ROSE: Add rose_ntop implementation.
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, linux-hams@vger.kernel.org
Lines:  103
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ROSE addresses are ten digit numbers, basically like North American
telephone numbers.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
---
 Makefile        |  3 +++
 include/utils.h |  2 ++
 lib/rose_ntop.c | 56 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+)
 create mode 100644 lib/rose_ntop.c

diff --git a/Makefile b/Makefile
index df894d54..5eddd504 100644
--- a/Makefile
+++ b/Makefile
@@ -43,6 +43,9 @@ DEFINES+=-DCONFDIR=\"$(CONFDIR)\" \
 #options for AX.25
 ADDLIB+=ax25_ntop.o
 
+#options for AX.25
+ADDLIB+=rose_ntop.o
+
 #options for mpls
 ADDLIB+=mpls_ntop.o mpls_pton.o
 
diff --git a/include/utils.h b/include/utils.h
index 6ab2fa74..b6c468e9 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -200,6 +200,8 @@ int inet_addr_match_rta(const inet_prefix *m, const struct rtattr *rta);
 
 const char *ax25_ntop(int af, const void *addr, char *str, socklen_t len);
 
+const char *rose_ntop(int af, const void *addr, char *buf, socklen_t buflen);
+
 const char *mpls_ntop(int af, const void *addr, char *str, size_t len);
 int mpls_pton(int af, const char *src, void *addr, size_t alen);
 
diff --git a/lib/rose_ntop.c b/lib/rose_ntop.c
new file mode 100644
index 00000000..c9ba712c
--- /dev/null
+++ b/lib/rose_ntop.c
@@ -0,0 +1,56 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/ioctl.h>
+#include <sys/socket.h>
+#include <netinet/in.h>
+#include <arpa/inet.h>
+#include <string.h>
+#include <errno.h>
+
+#include <linux/netdevice.h>
+#include <linux/if_arp.h>
+#include <linux/sockios.h>
+#include <linux/rose.h>
+
+#include "rt_names.h"
+#include "utils.h"
+
+static const char *rose_ntop1(const rose_address *src, char *dst,
+			      socklen_t size)
+{
+	char *p = dst;
+	int i;
+
+	if (size < 10)
+		return NULL;
+
+	for (i = 0; i < 5; i++) {
+		*p++ = '0' + ((src->rose_addr[i] >> 4) & 0xf);
+		*p++ = '0' + ((src->rose_addr[i]     ) & 0xf);
+	}
+
+	if (size == 10)
+		return dst;
+
+	*p = '\0';
+
+	return dst;
+}
+
+const char *rose_ntop(int af, const void *addr, char *buf, socklen_t buflen)
+{
+	switch (af) {
+	case AF_ROSE:
+		errno = 0;
+		return rose_ntop1((rose_address *)addr, buf, buflen);
+
+	default:
+		errno = EAFNOSUPPORT;
+	}
+
+	return NULL;
+}
-- 
2.31.1


