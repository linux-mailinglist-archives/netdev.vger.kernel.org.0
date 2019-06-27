Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A879758A18
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 20:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbfF0Sh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 14:37:58 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:34159 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbfF0Sh4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 14:37:56 -0400
Received: from tarshish.tkos.co.il (unknown [10.0.8.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 5C35B44039B;
        Thu, 27 Jun 2019 21:37:37 +0300 (IDT)
From:   Baruch Siach <baruch@tkos.co.il>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     netdev@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
        Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH iproute2 v2 2/2] devlink: fix libc and kernel headers collision
Date:   Thu, 27 Jun 2019 21:37:19 +0300
Message-Id: <d3509129f913b5b109359658b98aad9cdc035797.1561660639.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <7a72ae0f9519e6a445d9712399d989fed648e6eb.1561660639.git.baruch@tkos.co.il>
References: <7a72ae0f9519e6a445d9712399d989fed648e6eb.1561660639.git.baruch@tkos.co.il>
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
v2: Shorten comment
---
 devlink/devlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index b6e68f9a4d65..039225df7cbf 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -18,11 +18,12 @@
 #include <limits.h>
 #include <errno.h>
 #include <inttypes.h>
+#include <sys/sysinfo.h>
+#define _LINUX_SYSINFO_H /* avoid collision with musl header */
 #include <linux/genetlink.h>
 #include <linux/devlink.h>
 #include <libmnl/libmnl.h>
 #include <netinet/ether.h>
-#include <sys/sysinfo.h>
 #include <sys/queue.h>
 
 #include "SNAPSHOT.h"
-- 
2.20.1

