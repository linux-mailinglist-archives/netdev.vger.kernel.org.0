Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5AC717C377
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 18:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgCFREH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 12:04:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:42886 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbgCFREG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 12:04:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0DE19B0F2;
        Fri,  6 Mar 2020 17:04:05 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id B5A19E00E7; Fri,  6 Mar 2020 18:04:04 +0100 (CET)
Message-Id: <20527076df2743a1d640031b65cd2992222e383e.1583513281.git.mkubecek@suse.cz>
In-Reply-To: <cover.1583513281.git.mkubecek@suse.cz>
References: <cover.1583513281.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool v3 01/25] move UAPI header copies to a separate
 directory
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Fri,  6 Mar 2020 18:04:04 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The upcoming netlink series is going to add more local copies of kernel
UAPI header files and some of them are going to include others. Keeping
them in the main directory under modified name would require modifying
those includes as well which would be impractical.

Create a subdirectory uapi and move the UAPI headers there to allow
including them in the usual way.

v3:
  - use top_srcdir to fix build in a separate directory
  - Makefile.am: no need to touch test_*_CFLAGS

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Makefile.am                                  | 5 +++--
 internal.h                                   | 4 ++--
 ethtool-copy.h => uapi/linux/ethtool.h       | 0
 net_tstamp-copy.h => uapi/linux/net_tstamp.h | 0
 4 files changed, 5 insertions(+), 4 deletions(-)
 rename ethtool-copy.h => uapi/linux/ethtool.h (100%)
 rename net_tstamp-copy.h => uapi/linux/net_tstamp.h (100%)

diff --git a/Makefile.am b/Makefile.am
index 3af4d4c2b5da..e6d6e4ccda9e 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,12 +1,13 @@
 AM_CFLAGS = -Wall
+AM_CPPFLAGS = -I$(top_srcdir)/uapi
 LDADD = -lm
 
 man_MANS = ethtool.8
 EXTRA_DIST = LICENSE ethtool.8 ethtool.spec.in aclocal.m4 ChangeLog autogen.sh
 
 sbin_PROGRAMS = ethtool
-ethtool_SOURCES = ethtool.c ethtool-copy.h internal.h net_tstamp-copy.h \
-		  rxclass.c
+ethtool_SOURCES = ethtool.c uapi/linux/ethtool.h internal.h \
+		  uapi/linux/net_tstamp.h rxclass.c
 if ETHTOOL_ENABLE_PRETTY_DUMP
 ethtool_SOURCES += \
 		  amd8111e.c de2104x.c dsa.c e100.c e1000.c et131x.c igb.c	\
diff --git a/internal.h b/internal.h
index ff52c6e7660c..527245633338 100644
--- a/internal.h
+++ b/internal.h
@@ -44,8 +44,8 @@ typedef int32_t s32;
 #define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
 #endif
 
-#include "ethtool-copy.h"
-#include "net_tstamp-copy.h"
+#include <linux/ethtool.h>
+#include <linux/net_tstamp.h>
 
 #if __BYTE_ORDER == __BIG_ENDIAN
 static inline u16 cpu_to_be16(u16 value)
diff --git a/ethtool-copy.h b/uapi/linux/ethtool.h
similarity index 100%
rename from ethtool-copy.h
rename to uapi/linux/ethtool.h
diff --git a/net_tstamp-copy.h b/uapi/linux/net_tstamp.h
similarity index 100%
rename from net_tstamp-copy.h
rename to uapi/linux/net_tstamp.h
-- 
2.25.1

