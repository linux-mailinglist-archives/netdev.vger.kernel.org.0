Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1091D54DF2
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 13:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731916AbfFYLt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 07:49:28 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:34078 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726931AbfFYLt1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 07:49:27 -0400
Received: from tarshish.tkos.co.il (unknown [10.0.8.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id E09AE44059C;
        Tue, 25 Jun 2019 14:49:25 +0300 (IDT)
From:   Baruch Siach <baruch@tkos.co.il>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     netdev@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
        Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH iproute2 2/2] devlink: fix libc and kernel headers collision
Date:   Tue, 25 Jun 2019 14:49:05 +0300
Message-Id: <7f81026b803edcaeaca05994298118271a2f287d.1561463345.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <016aabe2639668b4710b73157ea39e8f97f7d726.1561463345.git.baruch@tkos.co.il>
References: <016aabe2639668b4710b73157ea39e8f97f7d726.1561463345.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 2f1242efe9d ("devlink: Add devlink health show command") we
use the sys/sysinfo.h header for the sysinfo(2) system call. But since
iproute2 carries a local version of the kernel struct sysinfo, this
causes a collision with libc that do not rely on kernel defined sysinfo
like musl libc:

In file included from devlink.c:25:0:
.../sysroot/usr/include/sys/sysinfo.h:10:8: error: redefinition of 'struct sysinfo'
 struct sysinfo {
        ^~~~~~~
In file included from ../include/uapi/linux/kernel.h:5:0,
                 from ../include/uapi/linux/netlink.h:5,
                 from ../include/uapi/linux/genetlink.h:6,
                 from devlink.c:21:
../include/uapi/linux/sysinfo.h:8:8: note: originally defined here
 struct sysinfo {
        ^~~~~~~

Move the sys/sysinfo.h userspace header before kernel headers, and
suppress the indirect include of linux/sysinfo.h.

Cc: Aya Levin <ayal@mellanox.com>
Cc: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 devlink/devlink.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index b400fab17578..2ea60d3556da 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -18,11 +18,16 @@
 #include <limits.h>
 #include <errno.h>
 #include <inttypes.h>
+#include <sys/sysinfo.h>
+/* Suppress linux/sysinfo.h to avoid
+ * collision of struct sysinfo definition
+ * with musl libc headers
+ */
+#define _LINUX_SYSINFO_H
 #include <linux/genetlink.h>
 #include <linux/devlink.h>
 #include <libmnl/libmnl.h>
 #include <netinet/ether.h>
-#include <sys/sysinfo.h>
 #include <sys/queue.h>
 
 #include "SNAPSHOT.h"
-- 
2.20.1

