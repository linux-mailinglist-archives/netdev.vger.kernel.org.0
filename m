Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0AC94572B5
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 17:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbhKSQWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 11:22:16 -0500
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:64604 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236446AbhKSQWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 11:22:05 -0500
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by smtp.orange.fr with ESMTPA
        id o6bEmqPplIEdlo6bJm8F5b; Fri, 19 Nov 2021 17:18:59 +0100
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Fri, 19 Nov 2021 17:18:59 +0100
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Jimmy Assarsson <extja@kvaser.com>
Subject: [PATCH] can: bittiming: replace CAN units with the SI metric
Date:   Sat, 20 Nov 2021 01:18:50 +0900
Message-Id: <20211119161850.202094-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In [1], we introduced a set of units in linux/can/bittiming.h. Since
then, generic SI prefix were added to linux/units.h in [2]. Those new
prefix can perfectly replace the CAN specific units.

This patch replaces all occurrences of the CAN units with their
corresponding prefix according to below table.

 CAN units	SI metric prefix
 -------------------------------
 CAN_KBPS	KILO
 CAN_MBPS	MEGA
 CAM_MHZ	MEGA

The macro declarations are then removed from linux/can/bittiming.h

[1] commit 1d7750760b70 ("can: bittiming: add CAN_KBPS, CAN_MBPS and
CAN_MHZ macros")

[2] commit 26471d4a6cf8 ("units: Add SI metric prefix definitions")

Suggested-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/dev/bittiming.c           | 5 +++--
 drivers/net/can/usb/etas_es58x/es581_4.c  | 5 +++--
 drivers/net/can/usb/etas_es58x/es58x_fd.c | 5 +++--
 include/linux/can/bittiming.h             | 7 -------
 4 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/net/can/dev/bittiming.c b/drivers/net/can/dev/bittiming.c
index 0509625c3082..a5c9f973802a 100644
--- a/drivers/net/can/dev/bittiming.c
+++ b/drivers/net/can/dev/bittiming.c
@@ -4,6 +4,7 @@
  * Copyright (C) 2008-2009 Wolfgang Grandegger <wg@grandegger.com>
  */
 
+#include <linux/units.h>
 #include <linux/can/dev.h>
 
 #ifdef CONFIG_CAN_CALC_BITTIMING
@@ -81,9 +82,9 @@ int can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
 	if (bt->sample_point) {
 		sample_point_nominal = bt->sample_point;
 	} else {
-		if (bt->bitrate > 800 * CAN_KBPS)
+		if (bt->bitrate > 800 * KILO)
 			sample_point_nominal = 750;
-		else if (bt->bitrate > 500 * CAN_KBPS)
+		else if (bt->bitrate > 500 * KILO)
 			sample_point_nominal = 800;
 		else
 			sample_point_nominal = 875;
diff --git a/drivers/net/can/usb/etas_es58x/es581_4.c b/drivers/net/can/usb/etas_es58x/es581_4.c
index 14e360c9f2c9..ed340141c712 100644
--- a/drivers/net/can/usb/etas_es58x/es581_4.c
+++ b/drivers/net/can/usb/etas_es58x/es581_4.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/units.h>
 #include <asm/unaligned.h>
 
 #include "es58x_core.h"
@@ -469,8 +470,8 @@ const struct es58x_parameters es581_4_param = {
 	.bittiming_const = &es581_4_bittiming_const,
 	.data_bittiming_const = NULL,
 	.tdc_const = NULL,
-	.bitrate_max = 1 * CAN_MBPS,
-	.clock = {.freq = 50 * CAN_MHZ},
+	.bitrate_max = 1 * MEGA,
+	.clock = {.freq = 50 * MEGA},
 	.ctrlmode_supported = CAN_CTRLMODE_CC_LEN8_DLC,
 	.tx_start_of_frame = 0xAFAF,
 	.rx_start_of_frame = 0xFAFA,
diff --git a/drivers/net/can/usb/etas_es58x/es58x_fd.c b/drivers/net/can/usb/etas_es58x/es58x_fd.c
index 4f0cae29f4d8..aec299bed6dc 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_fd.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_fd.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/units.h>
 #include <asm/unaligned.h>
 
 #include "es58x_core.h"
@@ -522,8 +523,8 @@ const struct es58x_parameters es58x_fd_param = {
 	 * Mbps work in an optimal environment but are not recommended
 	 * for production environment.
 	 */
-	.bitrate_max = 8 * CAN_MBPS,
-	.clock = {.freq = 80 * CAN_MHZ},
+	.bitrate_max = 8 * MEGA,
+	.clock = {.freq = 80 * MEGA},
 	.ctrlmode_supported = CAN_CTRLMODE_LOOPBACK | CAN_CTRLMODE_LISTENONLY |
 	    CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_FD | CAN_CTRLMODE_FD_NON_ISO |
 	    CAN_CTRLMODE_CC_LEN8_DLC | CAN_CTRLMODE_TDC_AUTO,
diff --git a/include/linux/can/bittiming.h b/include/linux/can/bittiming.h
index 20b50baf3a02..a81652d1c6f3 100644
--- a/include/linux/can/bittiming.h
+++ b/include/linux/can/bittiming.h
@@ -12,13 +12,6 @@
 #define CAN_SYNC_SEG 1
 
 
-/* Kilobits and Megabits per second */
-#define CAN_KBPS 1000UL
-#define CAN_MBPS 1000000UL
-
-/* Megahertz */
-#define CAN_MHZ 1000000UL
-
 #define CAN_CTRLMODE_TDC_MASK					\
 	(CAN_CTRLMODE_TDC_AUTO | CAN_CTRLMODE_TDC_MANUAL)
 
-- 
2.32.0

