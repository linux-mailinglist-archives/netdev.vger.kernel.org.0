Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48CB334E695
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 13:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbhC3LrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 07:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231945AbhC3Lq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 07:46:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9032C061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 04:46:26 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lRCpF-000610-DW
        for netdev@vger.kernel.org; Tue, 30 Mar 2021 13:46:25 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id A466A603E3F
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 11:46:13 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 279DF603DE0;
        Tue, 30 Mar 2021 11:46:03 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 73a5df45;
        Tue, 30 Mar 2021 11:46:00 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 10/39] can: bittiming: add CAN_KBPS, CAN_MBPS and CAN_MHZ macros
Date:   Tue, 30 Mar 2021 13:45:30 +0200
Message-Id: <20210330114559.1114855-11-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330114559.1114855-1-mkl@pengutronix.de>
References: <20210330114559.1114855-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Add three macro to simplify the readability of big bit timing numbers:
  - CAN_KBPS: kilobits per second (one thousand)
  - CAN_MBPS: megabits per second (one million)
  - CAN_MHZ: megahertz per second (one million)

Example:
	u32 bitrate_max = 8 * CAN_MBPS;
	struct can_clock clock = {.freq = 80 * CAN_MHZ};
instead of:
	u32 bitrate_max = 8000000;
	struct can_clock clock = {.freq = 80000000};

Apply the new macro to driver/net/can/dev/bittiming.c.

Link: https://lore.kernel.org/r/20210306054040.76483-1-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/bittiming.c | 4 ++--
 include/linux/can/bittiming.h   | 8 ++++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/dev/bittiming.c b/drivers/net/can/dev/bittiming.c
index 2907e60c9a57..f49170eadd54 100644
--- a/drivers/net/can/dev/bittiming.c
+++ b/drivers/net/can/dev/bittiming.c
@@ -81,9 +81,9 @@ int can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
 	if (bt->sample_point) {
 		sample_point_nominal = bt->sample_point;
 	} else {
-		if (bt->bitrate > 800000)
+		if (bt->bitrate > 800 * CAN_KBPS)
 			sample_point_nominal = 750;
-		else if (bt->bitrate > 500000)
+		else if (bt->bitrate > 500 * CAN_KBPS)
 			sample_point_nominal = 800;
 		else
 			sample_point_nominal = 875;
diff --git a/include/linux/can/bittiming.h b/include/linux/can/bittiming.h
index 3c4cad7b52c0..ae7a3411167c 100644
--- a/include/linux/can/bittiming.h
+++ b/include/linux/can/bittiming.h
@@ -11,6 +11,14 @@
 
 #define CAN_SYNC_SEG 1
 
+
+/* Kilobits and Megabits per second */
+#define CAN_KBPS 1000UL
+#define CAN_MBPS 1000000UL
+
+/* Megahertz */
+#define CAN_MHZ 1000000UL
+
 /*
  * struct can_tdc - CAN FD Transmission Delay Compensation parameters
  *
-- 
2.30.2


