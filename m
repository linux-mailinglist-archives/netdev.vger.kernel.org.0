Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6133929CB3A
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 22:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373933AbgJ0VZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 17:25:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S374001AbgJ0VZM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 17:25:12 -0400
Received: from localhost.localdomain (unknown [192.30.34.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75D62207E8;
        Tue, 27 Oct 2020 21:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603833909;
        bh=b5OJshUb17aEJqwFYDInQ6m6BL8T6NdaxOAecGwqYoY=;
        h=From:To:Cc:Subject:Date:From;
        b=NYExpd4qj+lzyyRmhjQb7vqJI5yp3xN6LZuy6dcxlNhY7Uj7kj+xVy19Zc9FiCJVY
         SWIY8gFZnquXZhYLbQR0ID7ON77Em9NfwjvdZIDHLGFivN5CTGVyWUrhM6a/VcL9ps
         ilgARd/8WxD8Gt20vgH3HBsO32EujKh15oQoidLg=
From:   Arnd Bergmann <arnd@kernel.org>
To:     Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [RFC] wimax: move out to staging
Date:   Tue, 27 Oct 2020 22:20:13 +0100
Message-Id: <20201027212448.454129-1-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

There are no known users of this driver as of October 2020, and it will
be removed unless someone turns out to still need it in future releases.

According to https://en.wikipedia.org/wiki/List_of_WiMAX_networks, there
have been many public wimax networks, but it appears that these entries
are all stale, after everyone has migrated to LTE or discontinued their
service altogether.

NetworkManager appears to have dropped userspace support in 2015
https://bugzilla.gnome.org/show_bug.cgi?id=747846, the
www.linuxwimax.org
site had already shut down earlier.

WiMax is apparently still being deployed on airport campus networks
("AeroMACS"), but in a frequency band that was not supported by the old
Intel 2400m (used in Sandy Bridge laptops and earlier), which is the
only driver using the kernel's wimax stack.

Move all files into drivers/staging/wimax, including the uapi header
files and documentation, to make it easier to remove it when it gets
to that. Only minimal changes are made to the source files, in order
to make it possible to port patches across the move.

Also remove the MAINTAINERS entry that refers to a broken mailing
list and website.

Suggested-by: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 Documentation/admin-guide/index.rst           |  1 -
 Documentation/networking/kapi.rst             | 21 ------------------
 .../translations/zh_CN/admin-guide/index.rst  |  1 -
 MAINTAINERS                                   | 22 -------------------
 drivers/net/Kconfig                           |  2 --
 drivers/net/wimax/Kconfig                     | 18 ---------------
 drivers/net/wimax/Makefile                    |  2 --
 drivers/staging/Kconfig                       |  2 ++
 drivers/staging/Makefile                      |  1 +
 .../staging/wimax/Documentation}/i2400m.rst   |  0
 .../staging/wimax/Documentation}/index.rst    |  0
 .../staging/wimax/Documentation}/wimax.rst    |  0
 {net => drivers/staging}/wimax/Kconfig        |  6 +++++
 {net => drivers/staging}/wimax/Makefile       |  2 ++
 drivers/staging/wimax/TODO                    | 16 ++++++++++++++
 {net => drivers/staging}/wimax/debug-levels.h |  2 +-
 {net => drivers/staging}/wimax/debugfs.c      |  2 +-
 drivers/{net => staging}/wimax/i2400m/Kconfig |  0
 .../{net => staging}/wimax/i2400m/Makefile    |  0
 .../{net => staging}/wimax/i2400m/control.c   |  2 +-
 .../wimax/i2400m/debug-levels.h               |  2 +-
 .../{net => staging}/wimax/i2400m/debugfs.c   |  0
 .../{net => staging}/wimax/i2400m/driver.c    |  2 +-
 drivers/{net => staging}/wimax/i2400m/fw.c    |  0
 .../wimax/i2400m/i2400m-usb.h                 |  0
 .../{net => staging}/wimax/i2400m/i2400m.h    |  4 ++--
 .../staging/wimax/i2400m/linux-wimax-i2400m.h |  0
 .../{net => staging}/wimax/i2400m/netdev.c    |  0
 .../{net => staging}/wimax/i2400m/op-rfkill.c |  2 +-
 drivers/{net => staging}/wimax/i2400m/rx.c    |  0
 drivers/{net => staging}/wimax/i2400m/sysfs.c |  0
 drivers/{net => staging}/wimax/i2400m/tx.c    |  0
 .../wimax/i2400m/usb-debug-levels.h           |  2 +-
 .../{net => staging}/wimax/i2400m/usb-fw.c    |  0
 .../{net => staging}/wimax/i2400m/usb-notif.c |  0
 .../{net => staging}/wimax/i2400m/usb-rx.c    |  0
 .../{net => staging}/wimax/i2400m/usb-tx.c    |  0
 drivers/{net => staging}/wimax/i2400m/usb.c   |  2 +-
 {net => drivers/staging}/wimax/id-table.c     |  2 +-
 .../staging/wimax/linux-wimax-debug.h         |  2 +-
 .../staging/wimax/linux-wimax.h               |  0
 .../staging/wimax/net-wimax.h                 |  2 +-
 {net => drivers/staging}/wimax/op-msg.c       |  2 +-
 {net => drivers/staging}/wimax/op-reset.c     |  4 ++--
 {net => drivers/staging}/wimax/op-rfkill.c    |  4 ++--
 {net => drivers/staging}/wimax/op-state-get.c |  4 ++--
 {net => drivers/staging}/wimax/stack.c        |  2 +-
 .../staging}/wimax/wimax-internal.h           |  2 +-
 net/Kconfig                                   |  2 --
 net/Makefile                                  |  1 -
 50 files changed, 49 insertions(+), 92 deletions(-)
 delete mode 100644 drivers/net/wimax/Kconfig
 delete mode 100644 drivers/net/wimax/Makefile
 rename {Documentation/admin-guide/wimax => drivers/staging/wimax/Documentation}/i2400m.rst (100%)
 rename {Documentation/admin-guide/wimax => drivers/staging/wimax/Documentation}/index.rst (100%)
 rename {Documentation/admin-guide/wimax => drivers/staging/wimax/Documentation}/wimax.rst (100%)
 rename {net => drivers/staging}/wimax/Kconfig (94%)
 rename {net => drivers/staging}/wimax/Makefile (83%)
 create mode 100644 drivers/staging/wimax/TODO
 rename {net => drivers/staging}/wimax/debug-levels.h (96%)
 rename {net => drivers/staging}/wimax/debugfs.c (97%)
 rename drivers/{net => staging}/wimax/i2400m/Kconfig (100%)
 rename drivers/{net => staging}/wimax/i2400m/Makefile (100%)
 rename drivers/{net => staging}/wimax/i2400m/control.c (99%)
 rename drivers/{net => staging}/wimax/i2400m/debug-levels.h (96%)
 rename drivers/{net => staging}/wimax/i2400m/debugfs.c (100%)
 rename drivers/{net => staging}/wimax/i2400m/driver.c (99%)
 rename drivers/{net => staging}/wimax/i2400m/fw.c (100%)
 rename drivers/{net => staging}/wimax/i2400m/i2400m-usb.h (100%)
 rename drivers/{net => staging}/wimax/i2400m/i2400m.h (99%)
 rename include/uapi/linux/wimax/i2400m.h => drivers/staging/wimax/i2400m/linux-wimax-i2400m.h (100%)
 rename drivers/{net => staging}/wimax/i2400m/netdev.c (100%)
 rename drivers/{net => staging}/wimax/i2400m/op-rfkill.c (99%)
 rename drivers/{net => staging}/wimax/i2400m/rx.c (100%)
 rename drivers/{net => staging}/wimax/i2400m/sysfs.c (100%)
 rename drivers/{net => staging}/wimax/i2400m/tx.c (100%)
 rename drivers/{net => staging}/wimax/i2400m/usb-debug-levels.h (95%)
 rename drivers/{net => staging}/wimax/i2400m/usb-fw.c (100%)
 rename drivers/{net => staging}/wimax/i2400m/usb-notif.c (100%)
 rename drivers/{net => staging}/wimax/i2400m/usb-rx.c (100%)
 rename drivers/{net => staging}/wimax/i2400m/usb-tx.c (100%)
 rename drivers/{net => staging}/wimax/i2400m/usb.c (99%)
 rename {net => drivers/staging}/wimax/id-table.c (99%)
 rename include/linux/wimax/debug.h => drivers/staging/wimax/linux-wimax-debug.h (99%)
 rename include/uapi/linux/wimax.h => drivers/staging/wimax/linux-wimax.h (100%)
 rename include/net/wimax.h => drivers/staging/wimax/net-wimax.h (99%)
 rename {net => drivers/staging}/wimax/op-msg.c (99%)
 rename {net => drivers/staging}/wimax/op-reset.c (98%)
 rename {net => drivers/staging}/wimax/op-rfkill.c (99%)
 rename {net => drivers/staging}/wimax/op-state-get.c (96%)
 rename {net => drivers/staging}/wimax/stack.c (99%)
 rename {net => drivers/staging}/wimax/wimax-internal.h (99%)

diff --git a/Documentation/admin-guide/index.rst b/Documentation/admin-guide/index.rst
index ed1cf94ea50c..d53986a424c4 100644
--- a/Documentation/admin-guide/index.rst
+++ b/Documentation/admin-guide/index.rst
@@ -115,7 +115,6 @@ configure specific aspects of kernel behavior to your liking.
    unicode
    vga-softcursor
    video-output
-   wimax/index
    xfs
 
 .. only::  subproject and html
diff --git a/Documentation/networking/kapi.rst b/Documentation/networking/kapi.rst
index d198fa5eaacd..ea55f462cefa 100644
--- a/Documentation/networking/kapi.rst
+++ b/Documentation/networking/kapi.rst
@@ -83,27 +83,6 @@ SUN RPC subsystem
 .. kernel-doc:: net/sunrpc/clnt.c
    :export:
 
-WiMAX
------
-
-.. kernel-doc:: net/wimax/op-msg.c
-   :export:
-
-.. kernel-doc:: net/wimax/op-reset.c
-   :export:
-
-.. kernel-doc:: net/wimax/op-rfkill.c
-   :export:
-
-.. kernel-doc:: net/wimax/stack.c
-   :export:
-
-.. kernel-doc:: include/net/wimax.h
-   :internal:
-
-.. kernel-doc:: include/uapi/linux/wimax.h
-   :internal:
-
 Network device support
 ======================
 
diff --git a/Documentation/translations/zh_CN/admin-guide/index.rst b/Documentation/translations/zh_CN/admin-guide/index.rst
index ed5ab7e37f38..48bbd3ebad48 100644
--- a/Documentation/translations/zh_CN/admin-guide/index.rst
+++ b/Documentation/translations/zh_CN/admin-guide/index.rst
@@ -114,7 +114,6 @@ Todolist:
    unicode
    vga-softcursor
    video-output
-   wimax/index
    xfs
 
 .. only::  subproject and html
diff --git a/MAINTAINERS b/MAINTAINERS
index 49d31fc6763b..da59512616c7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9114,16 +9114,6 @@ W:	https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git
 F:	drivers/net/wireless/intel/iwlwifi/
 
-INTEL WIRELESS WIMAX CONNECTION 2400
-M:	Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
-M:	linux-wimax@intel.com
-L:	wimax@linuxwimax.org (subscribers-only)
-S:	Supported
-W:	http://linuxwimax.org
-F:	Documentation/admin-guide/wimax/i2400m.rst
-F:	drivers/net/wimax/i2400m/
-F:	include/uapi/linux/wimax/i2400m.h
-
 INTEL WMI SLIM BOOTLOADER (SBL) FIRMWARE UPDATE DRIVER
 M:	Jithu Joseph <jithu.joseph@intel.com>
 R:	Maurice Ma <maurice.ma@intel.com>
@@ -18941,18 +18931,6 @@ S:	Supported
 W:	https://wireless.wiki.kernel.org/en/users/Drivers/wil6210
 F:	drivers/net/wireless/ath/wil6210/
 
-WIMAX STACK
-M:	Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
-M:	linux-wimax@intel.com
-L:	wimax@linuxwimax.org (subscribers-only)
-S:	Supported
-W:	http://linuxwimax.org
-F:	Documentation/admin-guide/wimax/wimax.rst
-F:	include/linux/wimax/debug.h
-F:	include/net/wimax.h
-F:	include/uapi/linux/wimax.h
-F:	net/wimax/
-
 WINBOND CIR DRIVER
 M:	David Härdeman <david@hardeman.nu>
 S:	Maintained
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index c3dbe64e628e..c0af2dc8b938 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -489,8 +489,6 @@ source "drivers/net/usb/Kconfig"
 
 source "drivers/net/wireless/Kconfig"
 
-source "drivers/net/wimax/Kconfig"
-
 source "drivers/net/wan/Kconfig"
 
 source "drivers/net/ieee802154/Kconfig"
diff --git a/drivers/net/wimax/Kconfig b/drivers/net/wimax/Kconfig
deleted file mode 100644
index 2249e3d77a76..000000000000
--- a/drivers/net/wimax/Kconfig
+++ /dev/null
@@ -1,18 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-#
-# WiMAX LAN device drivers configuration
-#
-
-
-comment "Enable WiMAX (Networking options) to see the WiMAX drivers"
-	depends on WIMAX = n
-
-if WIMAX
-
-menu "WiMAX Wireless Broadband devices"
-
-source "drivers/net/wimax/i2400m/Kconfig"
-
-endmenu
-
-endif
diff --git a/drivers/net/wimax/Makefile b/drivers/net/wimax/Makefile
deleted file mode 100644
index b4575bacf994..000000000000
--- a/drivers/net/wimax/Makefile
+++ /dev/null
@@ -1,2 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_WIMAX_I2400M)	+= i2400m/
diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 2d0310448eba..443ca3f3cdf0 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -114,6 +114,8 @@ source "drivers/staging/kpc2000/Kconfig"
 
 source "drivers/staging/qlge/Kconfig"
 
+source "drivers/staging/wimax/Kconfig"
+
 source "drivers/staging/wfx/Kconfig"
 
 source "drivers/staging/hikey9xx/Kconfig"
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 757a892ab5b9..dc45128ef525 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -47,5 +47,6 @@ obj-$(CONFIG_XIL_AXIS_FIFO)	+= axis-fifo/
 obj-$(CONFIG_FIELDBUS_DEV)     += fieldbus/
 obj-$(CONFIG_KPC2000)		+= kpc2000/
 obj-$(CONFIG_QLGE)		+= qlge/
+obj-$(CONFIG_WIMAX)		+= wimax/
 obj-$(CONFIG_WFX)		+= wfx/
 obj-y				+= hikey9xx/
diff --git a/Documentation/admin-guide/wimax/i2400m.rst b/drivers/staging/wimax/Documentation/i2400m.rst
similarity index 100%
rename from Documentation/admin-guide/wimax/i2400m.rst
rename to drivers/staging/wimax/Documentation/i2400m.rst
diff --git a/Documentation/admin-guide/wimax/index.rst b/drivers/staging/wimax/Documentation/index.rst
similarity index 100%
rename from Documentation/admin-guide/wimax/index.rst
rename to drivers/staging/wimax/Documentation/index.rst
diff --git a/Documentation/admin-guide/wimax/wimax.rst b/drivers/staging/wimax/Documentation/wimax.rst
similarity index 100%
rename from Documentation/admin-guide/wimax/wimax.rst
rename to drivers/staging/wimax/Documentation/wimax.rst
diff --git a/net/wimax/Kconfig b/drivers/staging/wimax/Kconfig
similarity index 94%
rename from net/wimax/Kconfig
rename to drivers/staging/wimax/Kconfig
index d13762bc4abc..ded8b70b25ee 100644
--- a/net/wimax/Kconfig
+++ b/drivers/staging/wimax/Kconfig
@@ -22,6 +22,8 @@ menuconfig WIMAX
 
 	  If unsure, it is safe to select M (module).
 
+if WIMAX
+
 config WIMAX_DEBUG_LEVEL
 	int "WiMAX debug level"
 	depends on WIMAX
@@ -38,3 +40,7 @@ config WIMAX_DEBUG_LEVEL
 	  If set at zero, this will compile out all the debug code.
 
 	  It is recommended that it is left at 8.
+
+source "drivers/staging/wimax/i2400m/Kconfig"
+
+endif
diff --git a/net/wimax/Makefile b/drivers/staging/wimax/Makefile
similarity index 83%
rename from net/wimax/Makefile
rename to drivers/staging/wimax/Makefile
index c2a71ae487ac..0e3f988656aa 100644
--- a/net/wimax/Makefile
+++ b/drivers/staging/wimax/Makefile
@@ -11,3 +11,5 @@ wimax-y :=		\
 	stack.o
 
 wimax-$(CONFIG_DEBUG_FS) += debugfs.o
+
+obj-$(CONFIG_WIMAX_I2400M)	+= i2400m/
diff --git a/drivers/staging/wimax/TODO b/drivers/staging/wimax/TODO
new file mode 100644
index 000000000000..704186c6a5db
--- /dev/null
+++ b/drivers/staging/wimax/TODO
@@ -0,0 +1,16 @@
+There are no known users of this driver as of October 2020, and it will
+be removed unless someone turns out to still need it in future releases.
+
+According to https://en.wikipedia.org/wiki/List_of_WiMAX_networks, there
+have been many public wimax networks, but it appears that these entries
+are all stale, after everyone has migrated to LTE or discontinued their
+service altogether.
+
+NetworkManager appears to have dropped userspace support in 2015
+https://bugzilla.gnome.org/show_bug.cgi?id=747846, the www.linuxwimax.org
+site had already shut down earlier.
+
+WiMax is apparently still being deployed on airport campus networks
+("AeroMACS"), but in a frequency band that was not supported by the old
+Intel 2400m (used in Sandy Bridge laptops and earlier), which is the
+only driver using the kernel's wimax stack.
diff --git a/net/wimax/debug-levels.h b/drivers/staging/wimax/debug-levels.h
similarity index 96%
rename from net/wimax/debug-levels.h
rename to drivers/staging/wimax/debug-levels.h
index ebc287cde336..b854802d1d00 100644
--- a/net/wimax/debug-levels.h
+++ b/drivers/staging/wimax/debug-levels.h
@@ -13,7 +13,7 @@
 #define D_MODULENAME wimax
 #define D_MASTER CONFIG_WIMAX_DEBUG_LEVEL
 
-#include <linux/wimax/debug.h>
+#include "linux-wimax-debug.h"
 
 /* List of all the enabled modules */
 enum d_module {
diff --git a/net/wimax/debugfs.c b/drivers/staging/wimax/debugfs.c
similarity index 97%
rename from net/wimax/debugfs.c
rename to drivers/staging/wimax/debugfs.c
index 3c54bb6b925a..e11bff61ffcf 100644
--- a/net/wimax/debugfs.c
+++ b/drivers/staging/wimax/debugfs.c
@@ -7,7 +7,7 @@
  * Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
  */
 #include <linux/debugfs.h>
-#include <linux/wimax.h>
+#include "linux-wimax.h"
 #include "wimax-internal.h"
 
 #define D_SUBMODULE debugfs
diff --git a/drivers/net/wimax/i2400m/Kconfig b/drivers/staging/wimax/i2400m/Kconfig
similarity index 100%
rename from drivers/net/wimax/i2400m/Kconfig
rename to drivers/staging/wimax/i2400m/Kconfig
diff --git a/drivers/net/wimax/i2400m/Makefile b/drivers/staging/wimax/i2400m/Makefile
similarity index 100%
rename from drivers/net/wimax/i2400m/Makefile
rename to drivers/staging/wimax/i2400m/Makefile
diff --git a/drivers/net/wimax/i2400m/control.c b/drivers/staging/wimax/i2400m/control.c
similarity index 99%
rename from drivers/net/wimax/i2400m/control.c
rename to drivers/staging/wimax/i2400m/control.c
index 180d5f417bdc..8b533b1a3da4 100644
--- a/drivers/net/wimax/i2400m/control.c
+++ b/drivers/staging/wimax/i2400m/control.c
@@ -77,7 +77,7 @@
 #include "i2400m.h"
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <linux/wimax/i2400m.h>
+#include "linux-wimax-i2400m.h"
 #include <linux/export.h>
 #include <linux/moduleparam.h>
 
diff --git a/drivers/net/wimax/i2400m/debug-levels.h b/drivers/staging/wimax/i2400m/debug-levels.h
similarity index 96%
rename from drivers/net/wimax/i2400m/debug-levels.h
rename to drivers/staging/wimax/i2400m/debug-levels.h
index 00942bb1489b..a317e9fbb734 100644
--- a/drivers/net/wimax/i2400m/debug-levels.h
+++ b/drivers/staging/wimax/i2400m/debug-levels.h
@@ -13,7 +13,7 @@
 #define D_MODULENAME i2400m
 #define D_MASTER CONFIG_WIMAX_I2400M_DEBUG_LEVEL
 
-#include <linux/wimax/debug.h>
+#include "../linux-wimax-debug.h"
 
 /* List of all the enabled modules */
 enum d_module {
diff --git a/drivers/net/wimax/i2400m/debugfs.c b/drivers/staging/wimax/i2400m/debugfs.c
similarity index 100%
rename from drivers/net/wimax/i2400m/debugfs.c
rename to drivers/staging/wimax/i2400m/debugfs.c
diff --git a/drivers/net/wimax/i2400m/driver.c b/drivers/staging/wimax/i2400m/driver.c
similarity index 99%
rename from drivers/net/wimax/i2400m/driver.c
rename to drivers/staging/wimax/i2400m/driver.c
index ecb3fccca603..dc8939ff78c0 100644
--- a/drivers/net/wimax/i2400m/driver.c
+++ b/drivers/staging/wimax/i2400m/driver.c
@@ -50,7 +50,7 @@
  */
 #include "i2400m.h"
 #include <linux/etherdevice.h>
-#include <linux/wimax/i2400m.h>
+#include "linux-wimax-i2400m.h"
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/suspend.h>
diff --git a/drivers/net/wimax/i2400m/fw.c b/drivers/staging/wimax/i2400m/fw.c
similarity index 100%
rename from drivers/net/wimax/i2400m/fw.c
rename to drivers/staging/wimax/i2400m/fw.c
diff --git a/drivers/net/wimax/i2400m/i2400m-usb.h b/drivers/staging/wimax/i2400m/i2400m-usb.h
similarity index 100%
rename from drivers/net/wimax/i2400m/i2400m-usb.h
rename to drivers/staging/wimax/i2400m/i2400m-usb.h
diff --git a/drivers/net/wimax/i2400m/i2400m.h b/drivers/staging/wimax/i2400m/i2400m.h
similarity index 99%
rename from drivers/net/wimax/i2400m/i2400m.h
rename to drivers/staging/wimax/i2400m/i2400m.h
index a3733a6d14f5..de22cc6f2c5c 100644
--- a/drivers/net/wimax/i2400m/i2400m.h
+++ b/drivers/staging/wimax/i2400m/i2400m.h
@@ -156,8 +156,8 @@
 #include <linux/completion.h>
 #include <linux/rwsem.h>
 #include <linux/atomic.h>
-#include <net/wimax.h>
-#include <linux/wimax/i2400m.h>
+#include "../net-wimax.h"
+#include "linux-wimax-i2400m.h"
 #include <asm/byteorder.h>
 
 enum {
diff --git a/include/uapi/linux/wimax/i2400m.h b/drivers/staging/wimax/i2400m/linux-wimax-i2400m.h
similarity index 100%
rename from include/uapi/linux/wimax/i2400m.h
rename to drivers/staging/wimax/i2400m/linux-wimax-i2400m.h
diff --git a/drivers/net/wimax/i2400m/netdev.c b/drivers/staging/wimax/i2400m/netdev.c
similarity index 100%
rename from drivers/net/wimax/i2400m/netdev.c
rename to drivers/staging/wimax/i2400m/netdev.c
diff --git a/drivers/net/wimax/i2400m/op-rfkill.c b/drivers/staging/wimax/i2400m/op-rfkill.c
similarity index 99%
rename from drivers/net/wimax/i2400m/op-rfkill.c
rename to drivers/staging/wimax/i2400m/op-rfkill.c
index 5c79f052cad2..fbddf2e18c14 100644
--- a/drivers/net/wimax/i2400m/op-rfkill.c
+++ b/drivers/staging/wimax/i2400m/op-rfkill.c
@@ -18,7 +18,7 @@
  *   switch (coming from sysfs, the wimax stack or user space).
  */
 #include "i2400m.h"
-#include <linux/wimax/i2400m.h>
+#include "linux-wimax-i2400m.h"
 #include <linux/slab.h>
 
 
diff --git a/drivers/net/wimax/i2400m/rx.c b/drivers/staging/wimax/i2400m/rx.c
similarity index 100%
rename from drivers/net/wimax/i2400m/rx.c
rename to drivers/staging/wimax/i2400m/rx.c
diff --git a/drivers/net/wimax/i2400m/sysfs.c b/drivers/staging/wimax/i2400m/sysfs.c
similarity index 100%
rename from drivers/net/wimax/i2400m/sysfs.c
rename to drivers/staging/wimax/i2400m/sysfs.c
diff --git a/drivers/net/wimax/i2400m/tx.c b/drivers/staging/wimax/i2400m/tx.c
similarity index 100%
rename from drivers/net/wimax/i2400m/tx.c
rename to drivers/staging/wimax/i2400m/tx.c
diff --git a/drivers/net/wimax/i2400m/usb-debug-levels.h b/drivers/staging/wimax/i2400m/usb-debug-levels.h
similarity index 95%
rename from drivers/net/wimax/i2400m/usb-debug-levels.h
rename to drivers/staging/wimax/i2400m/usb-debug-levels.h
index b6f7335de765..8fd0111560f6 100644
--- a/drivers/net/wimax/i2400m/usb-debug-levels.h
+++ b/drivers/staging/wimax/i2400m/usb-debug-levels.h
@@ -13,7 +13,7 @@
 #define D_MODULENAME i2400m_usb
 #define D_MASTER CONFIG_WIMAX_I2400M_DEBUG_LEVEL
 
-#include <linux/wimax/debug.h>
+#include "../linux-wimax-debug.h"
 
 /* List of all the enabled modules */
 enum d_module {
diff --git a/drivers/net/wimax/i2400m/usb-fw.c b/drivers/staging/wimax/i2400m/usb-fw.c
similarity index 100%
rename from drivers/net/wimax/i2400m/usb-fw.c
rename to drivers/staging/wimax/i2400m/usb-fw.c
diff --git a/drivers/net/wimax/i2400m/usb-notif.c b/drivers/staging/wimax/i2400m/usb-notif.c
similarity index 100%
rename from drivers/net/wimax/i2400m/usb-notif.c
rename to drivers/staging/wimax/i2400m/usb-notif.c
diff --git a/drivers/net/wimax/i2400m/usb-rx.c b/drivers/staging/wimax/i2400m/usb-rx.c
similarity index 100%
rename from drivers/net/wimax/i2400m/usb-rx.c
rename to drivers/staging/wimax/i2400m/usb-rx.c
diff --git a/drivers/net/wimax/i2400m/usb-tx.c b/drivers/staging/wimax/i2400m/usb-tx.c
similarity index 100%
rename from drivers/net/wimax/i2400m/usb-tx.c
rename to drivers/staging/wimax/i2400m/usb-tx.c
diff --git a/drivers/net/wimax/i2400m/usb.c b/drivers/staging/wimax/i2400m/usb.c
similarity index 99%
rename from drivers/net/wimax/i2400m/usb.c
rename to drivers/staging/wimax/i2400m/usb.c
index b684e97ac976..3b84dd7b5567 100644
--- a/drivers/net/wimax/i2400m/usb.c
+++ b/drivers/staging/wimax/i2400m/usb.c
@@ -49,7 +49,7 @@
  *   usb_reset_device()
  */
 #include "i2400m-usb.h"
-#include <linux/wimax/i2400m.h>
+#include "linux-wimax-i2400m.h"
 #include <linux/debugfs.h>
 #include <linux/slab.h>
 #include <linux/module.h>
diff --git a/net/wimax/id-table.c b/drivers/staging/wimax/id-table.c
similarity index 99%
rename from net/wimax/id-table.c
rename to drivers/staging/wimax/id-table.c
index 02eee37b7e31..0e6f4aa87bc9 100644
--- a/net/wimax/id-table.c
+++ b/drivers/staging/wimax/id-table.c
@@ -28,7 +28,7 @@
 #include <net/genetlink.h>
 #include <linux/netdevice.h>
 #include <linux/list.h>
-#include <linux/wimax.h>
+#include "linux-wimax.h"
 #include "wimax-internal.h"
 
 
diff --git a/include/linux/wimax/debug.h b/drivers/staging/wimax/linux-wimax-debug.h
similarity index 99%
rename from include/linux/wimax/debug.h
rename to drivers/staging/wimax/linux-wimax-debug.h
index cdae052bcdcd..5b5ec405143b 100644
--- a/include/linux/wimax/debug.h
+++ b/drivers/staging/wimax/linux-wimax-debug.h
@@ -60,7 +60,7 @@
  *     #define D_MODULENAME modulename
  *     #define D_MASTER 10
  *
- *     #include <linux/wimax/debug.h>
+ *     #include "linux-wimax-debug.h"
  *
  *     enum d_module {
  *             D_SUBMODULE_DECLARE(submodule_1),
diff --git a/include/uapi/linux/wimax.h b/drivers/staging/wimax/linux-wimax.h
similarity index 100%
rename from include/uapi/linux/wimax.h
rename to drivers/staging/wimax/linux-wimax.h
diff --git a/include/net/wimax.h b/drivers/staging/wimax/net-wimax.h
similarity index 99%
rename from include/net/wimax.h
rename to drivers/staging/wimax/net-wimax.h
index f6e31d2f47aa..f578e345e2bd 100644
--- a/include/net/wimax.h
+++ b/drivers/staging/wimax/net-wimax.h
@@ -236,7 +236,7 @@
 #ifndef __NET__WIMAX_H__
 #define __NET__WIMAX_H__
 
-#include <linux/wimax.h>
+#include "linux-wimax.h"
 #include <net/genetlink.h>
 #include <linux/netdevice.h>
 
diff --git a/net/wimax/op-msg.c b/drivers/staging/wimax/op-msg.c
similarity index 99%
rename from net/wimax/op-msg.c
rename to drivers/staging/wimax/op-msg.c
index 6460b5785758..e20ac7d84e82 100644
--- a/net/wimax/op-msg.c
+++ b/drivers/staging/wimax/op-msg.c
@@ -60,7 +60,7 @@
 #include <linux/slab.h>
 #include <net/genetlink.h>
 #include <linux/netdevice.h>
-#include <linux/wimax.h>
+#include "linux-wimax.h"
 #include <linux/security.h>
 #include <linux/export.h>
 #include "wimax-internal.h"
diff --git a/net/wimax/op-reset.c b/drivers/staging/wimax/op-reset.c
similarity index 98%
rename from net/wimax/op-reset.c
rename to drivers/staging/wimax/op-reset.c
index 9899b2e56721..b3f000cbe112 100644
--- a/net/wimax/op-reset.c
+++ b/drivers/staging/wimax/op-reset.c
@@ -13,9 +13,9 @@
  * disconnect and reconnect the device).
  */
 
-#include <net/wimax.h>
+#include "net-wimax.h"
 #include <net/genetlink.h>
-#include <linux/wimax.h>
+#include "linux-wimax.h"
 #include <linux/security.h>
 #include <linux/export.h>
 #include "wimax-internal.h"
diff --git a/net/wimax/op-rfkill.c b/drivers/staging/wimax/op-rfkill.c
similarity index 99%
rename from net/wimax/op-rfkill.c
rename to drivers/staging/wimax/op-rfkill.c
index 248d10b60b05..78b294481a59 100644
--- a/net/wimax/op-rfkill.c
+++ b/drivers/staging/wimax/op-rfkill.c
@@ -45,9 +45,9 @@
  * wimax_rfkill_rm()            [called by wimax_dev_add/rm()]
  */
 
-#include <net/wimax.h>
+#include "net-wimax.h"
 #include <net/genetlink.h>
-#include <linux/wimax.h>
+#include "linux-wimax.h"
 #include <linux/security.h>
 #include <linux/rfkill.h>
 #include <linux/export.h>
diff --git a/net/wimax/op-state-get.c b/drivers/staging/wimax/op-state-get.c
similarity index 96%
rename from net/wimax/op-state-get.c
rename to drivers/staging/wimax/op-state-get.c
index 5bc712de1563..c5bfbed505f5 100644
--- a/net/wimax/op-state-get.c
+++ b/drivers/staging/wimax/op-state-get.c
@@ -10,9 +10,9 @@
  *  Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
  */
 
-#include <net/wimax.h>
+#include "net-wimax.h"
 #include <net/genetlink.h>
-#include <linux/wimax.h>
+#include "linux-wimax.h"
 #include <linux/security.h>
 #include "wimax-internal.h"
 
diff --git a/net/wimax/stack.c b/drivers/staging/wimax/stack.c
similarity index 99%
rename from net/wimax/stack.c
rename to drivers/staging/wimax/stack.c
index 3a62af3f80bf..ace24a6dfd2d 100644
--- a/net/wimax/stack.c
+++ b/drivers/staging/wimax/stack.c
@@ -39,7 +39,7 @@
 #include <linux/gfp.h>
 #include <net/genetlink.h>
 #include <linux/netdevice.h>
-#include <linux/wimax.h>
+#include "linux-wimax.h"
 #include <linux/module.h>
 #include "wimax-internal.h"
 
diff --git a/net/wimax/wimax-internal.h b/drivers/staging/wimax/wimax-internal.h
similarity index 99%
rename from net/wimax/wimax-internal.h
rename to drivers/staging/wimax/wimax-internal.h
index 40751207296c..a6b6990642a1 100644
--- a/net/wimax/wimax-internal.h
+++ b/drivers/staging/wimax/wimax-internal.h
@@ -22,7 +22,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/device.h>
-#include <net/wimax.h>
+#include "net-wimax.h"
 
 
 /*
diff --git a/net/Kconfig b/net/Kconfig
index d6567162c1cf..f4c32d982af6 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -386,8 +386,6 @@ source "net/mac80211/Kconfig"
 
 endif # WIRELESS
 
-source "net/wimax/Kconfig"
-
 source "net/rfkill/Kconfig"
 source "net/9p/Kconfig"
 source "net/caif/Kconfig"
diff --git a/net/Makefile b/net/Makefile
index 5744bf1997fd..d96b0aa8f39f 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -66,7 +66,6 @@ obj-$(CONFIG_MAC802154)		+= mac802154/
 ifeq ($(CONFIG_NET),y)
 obj-$(CONFIG_SYSCTL)		+= sysctl_net.o
 endif
-obj-$(CONFIG_WIMAX)		+= wimax/
 obj-$(CONFIG_DNS_RESOLVER)	+= dns_resolver/
 obj-$(CONFIG_CEPH_LIB)		+= ceph/
 obj-$(CONFIG_BATMAN_ADV)	+= batman-adv/
-- 
2.27.0

