Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5B51799AF
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 21:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbgCDUYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 15:24:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:33110 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728482AbgCDUYn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 15:24:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5586AAF01;
        Wed,  4 Mar 2020 20:24:41 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 02E90E037F; Wed,  4 Mar 2020 21:24:40 +0100 (CET)
Message-Id: <23ae41de7dd8663380d522e0fa2a75bf6b8724af.1583347351.git.mkubecek@suse.cz>
In-Reply-To: <cover.1583347351.git.mkubecek@suse.cz>
References: <cover.1583347351.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool v2 01/25] move UAPI header copies to a separate
 directory
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Wed,  4 Mar 2020 21:24:40 +0100 (CET)
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

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Makefile.am                                  | 10 +++++-----
 internal.h                                   |  4 ++--
 ethtool-copy.h => uapi/linux/ethtool.h       |  0
 net_tstamp-copy.h => uapi/linux/net_tstamp.h |  0
 4 files changed, 7 insertions(+), 7 deletions(-)
 rename ethtool-copy.h => uapi/linux/ethtool.h (100%)
 rename net_tstamp-copy.h => uapi/linux/net_tstamp.h (100%)

diff --git a/Makefile.am b/Makefile.am
index 3af4d4c2b5da..05beb22be669 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,12 +1,12 @@
-AM_CFLAGS = -Wall
+AM_CFLAGS = -I./uapi -Wall
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
@@ -25,9 +25,9 @@ endif
 TESTS = test-cmdline test-features
 check_PROGRAMS = test-cmdline test-features
 test_cmdline_SOURCES = test-cmdline.c test-common.c $(ethtool_SOURCES) 
-test_cmdline_CFLAGS = -DTEST_ETHTOOL
+test_cmdline_CFLAGS = $(AM_FLAGS) -DTEST_ETHTOOL
 test_features_SOURCES = test-features.c test-common.c $(ethtool_SOURCES) 
-test_features_CFLAGS = -DTEST_ETHTOOL
+test_features_CFLAGS = $(AM_FLAGS) -DTEST_ETHTOOL
 
 dist-hook:
 	cp $(top_srcdir)/ethtool.spec $(distdir)
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

