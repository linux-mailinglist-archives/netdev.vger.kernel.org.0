Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20C11300693
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 16:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729037AbhAVPFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 10:05:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728984AbhAVPEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 10:04:22 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37CB0C061794
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 07:03:40 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1l2xyM-0002T8-5z
        for netdev@vger.kernel.org; Fri, 22 Jan 2021 16:03:38 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 14FC05CAA40
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 15:03:37 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 81DEF5CAA39;
        Fri, 22 Jan 2021 15:03:36 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id ede34be9;
        Fri, 22 Jan 2021 15:03:36 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH] net: dp83tc811: fix link detection and possbile IRQ storm
Date:   Fri, 22 Jan 2021 16:03:34 +0100
Message-Id: <20210122150334.2378703-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In our setup the dp83tc811 is configure to master mode. When there is no slave
connected the dp83tc811 triggers an interrupt is triggerd, several bits in the
status registers are set, and te INT_N pin goes low. One of interrupt bits is
the NO_FRAME interrupt.

Reading the status register acknowledges the interrupt, but as there is still
no slave connected, the NO_FRAME interrupt stays set and the INT_N pin low. For
level triggered IRQs this results in an interrupt storm, as long as the slave
is not connected. For edge triggered interupts the link change event, when the
slave comes online, is lost.

To fix this problem the NO_FRAME interrupt is not enabled. At least in our
testcase with edge triggered interrupts link change events are now properly
detected.

Cc: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/phy/dp83tc811.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/phy/dp83tc811.c b/drivers/net/phy/dp83tc811.c
index b8d802cbf615..2801492bfaad 100644
--- a/drivers/net/phy/dp83tc811.c
+++ b/drivers/net/phy/dp83tc811.c
@@ -222,7 +222,6 @@ static int dp83811_config_intr(struct phy_device *phydev)
 			return err;
 
 		misr_status = (DP83811_LPS_INT_EN |
-			       DP83811_NO_FRAME_INT_EN |
 			       DP83811_POR_DONE_INT_EN);
 
 		err = phy_write(phydev, MII_DP83811_INT_STAT3, misr_status);
-- 
2.29.2


