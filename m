Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9DFB2B6BF4
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 18:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729786AbgKQRio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 12:38:44 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:37585 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbgKQRin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 12:38:43 -0500
Received: from orion.localdomain ([95.118.38.12]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MNtny-1kuYU13N4S-00OE50; Tue, 17 Nov 2020 18:38:29 +0100
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     alexander.shishkin@linux.intel.com, mcoquelin.stm32@gmail.com,
        alexandre.torgue@st.com, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andrii@kernel.org, john.fastabend@gmail.com,
        kpsingh@chromium.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH] lib: compile memcat_p only when needed
Date:   Tue, 17 Nov 2020 18:38:28 +0100
Message-Id: <20201117173828.27292-1-info@metux.net>
X-Mailer: git-send-email 2.11.0
X-Provags-ID: V03:K1:WLtI2dhe23NlCGvRD0bQU5TmYycnzy6Pd31ukZBnKNWCoAnPQ7O
 wObf9KlfjUMJ0j5ttfV0Q74UhV+inNsIH7TvyxkfNy2AIF0ZrdN1cYKC4YfchqlEZAdWjup
 SvAAIiGZOC79vLc/ecuz96pt1yxUR5+SgeKA5j4A2OWQMQh964LirWKxUy0zuM7ZuvQFdlq
 3QnhrViK1QozM6MA8as0g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Mg8iHrkpY3E=:i3JQ1DnnD2/k2sjtlbn7Fw
 wvqz2OILSVqTvWZS2Eo93Yti4ukgOmRCXtyyNWc34KOdzHLZU8nVMevyy7TYcIJGT2cPsFgbm
 MxVWzqd5TNKHTecNbDZ2qhC3H+DeheFHhNzpx7Nmj3TGwM4Cfse2T+piD3dkESbfHFMqkPAMn
 0UuAh0lXTiPx5p69puuU0PgD18Hd5zTZ2zadvUmILu4+rX5YVzShY8kuknQ98rGmKFzN6icsq
 S0BpuwPMFX9E/ah2pEoW4kT68bNbEKlIttyabbNwonekwBRXbckOpc9GEv17DTjLbXAmapxxI
 WCvk4A67e2tBev/NSgxM5OoDnLUvS5BvZqsX+Q3IdqLMu1PflPSX5eqTWQZeK9MKzZINgbCLP
 EwYf/wKk7T9TqigL26LNgQ1MRyTqtC2NbyuXI3vOPjdDeMKxye+cdZrtgeJdZ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The library function memcat_p() is currently used only once.
(drivers/hwtracing/stm). So, often completely unused.

Reducing the kernel size by about 4k by compiling it
conditionally, only when needed.

Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
---
 drivers/hwtracing/stm/Kconfig | 1 +
 lib/Kconfig                   | 3 +++
 lib/Kconfig.debug             | 1 +
 lib/Makefile                  | 4 +++-
 4 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/hwtracing/stm/Kconfig b/drivers/hwtracing/stm/Kconfig
index aad594fe79cc..8ce5cfd759d1 100644
--- a/drivers/hwtracing/stm/Kconfig
+++ b/drivers/hwtracing/stm/Kconfig
@@ -3,6 +3,7 @@ config STM
 	tristate "System Trace Module devices"
 	select CONFIGFS_FS
 	select SRCU
+	select GENERIC_LIB_MEMCAT_P
 	help
 	  A System Trace Module (STM) is a device exporting data in System
 	  Trace Protocol (STP) format as defined by MIPI STP standards.
diff --git a/lib/Kconfig b/lib/Kconfig
index b46a9fd122c8..b42ed8d68937 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -686,6 +686,9 @@ config GENERIC_LIB_CMPDI2
 config GENERIC_LIB_UCMPDI2
 	bool
 
+config GENERIC_LIB_MEMCAT_P
+	tristate
+
 config PLDMFW
 	bool
 	default n
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c789b39ed527..beb5adb2f0b7 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2334,6 +2334,7 @@ config TEST_DEBUG_VIRTUAL
 
 config TEST_MEMCAT_P
 	tristate "Test memcat_p() helper function"
+	select GENERIC_LIB_MEMCAT_P
 	help
 	  Test the memcat_p() helper for correctly merging two
 	  pointer arrays together.
diff --git a/lib/Makefile b/lib/Makefile
index ce45af50983a..18fd6630be0b 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -36,7 +36,9 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 flex_proportions.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
 	 earlycpio.o seq_buf.o siphash.o dec_and_lock.o \
-	 nmi_backtrace.o nodemask.o win_minmax.o memcat_p.o
+	 nmi_backtrace.o nodemask.o win_minmax.o
+
+obj-$(CONFIG_GENERIC_LIB_MEMCAT_P) += memcat_p.o
 
 lib-$(CONFIG_PRINTK) += dump_stack.o
 lib-$(CONFIG_SMP) += cpumask.o
-- 
2.11.0

