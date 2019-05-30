Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C821B2FF78
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 17:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfE3Pc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 11:32:57 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:59986 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbfE3Pc5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 11:32:57 -0400
Received: from tarshish.tkos.co.il (unknown [10.0.8.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 4437744065D;
        Thu, 30 May 2019 18:32:54 +0300 (IDT)
From:   Baruch Siach <baruch@tkos.co.il>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
        Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH] devlink: fix libc and kernel headers collision
Date:   Thu, 30 May 2019 18:32:27 +0300
Message-Id: <602128d22db86bd67e11dec8fe40a73832c222c9.1559230347.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.20.1
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

Rely on the kernel header alone to avoid kernel and userspace headers
collision of definitions.

Cc: Aya Levin <ayal@mellanox.com>
Cc: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 devlink/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 436935f88bda..d7a6ce94f0e6 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -22,7 +22,7 @@
 #include <linux/devlink.h>
 #include <libmnl/libmnl.h>
 #include <netinet/ether.h>
-#include <sys/sysinfo.h>
+#include <linux/sysinfo.h>
 #include <sys/queue.h>
 
 #include "SNAPSHOT.h"
-- 
2.20.1

