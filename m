Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCD32C8473
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 13:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbgK3Myf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 07:54:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbgK3Mye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 07:54:34 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3858C061A47
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 04:53:16 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kjig7-00042y-Gy
        for netdev@vger.kernel.org; Mon, 30 Nov 2020 13:53:15 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 102C259F90D
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 12:53:12 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id A9DA559F8EB;
        Mon, 30 Nov 2020 12:53:09 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id d614e40c;
        Mon, 30 Nov 2020 12:53:08 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Jeroen Hofstee <jhofstee@victronenergy.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 3/5] can: sun4i_can: sun4i_can_err(): don't count arbitration lose as an error
Date:   Mon, 30 Nov 2020 13:53:05 +0100
Message-Id: <20201130125307.218258-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201130125307.218258-1-mkl@pengutronix.de>
References: <20201130125307.218258-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeroen Hofstee <jhofstee@victronenergy.com>

Losing arbitration is normal in a CAN-bus network, it means that a higher
priority frame is being send and the pending message will be retried later.
Hence most driver only increment arbitration_lost, but the sun4i driver also
incremeants tx_error, causing errors to be reported on a normal functioning
CAN-bus. So stop counting them as errors.

Fixes: 0738eff14d81 ("can: Allwinner A10/A20 CAN Controller support - Kernel module")
Signed-off-by: Jeroen Hofstee <jhofstee@victronenergy.com>
Link: https://lore.kernel.org/r/20201127095941.21609-1-jhofstee@victronenergy.com
[mkl: split into two seperate patches]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/sun4i_can.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/can/sun4i_can.c b/drivers/net/can/sun4i_can.c
index e2c6cf4b2228..b3f2f4fe5ee0 100644
--- a/drivers/net/can/sun4i_can.c
+++ b/drivers/net/can/sun4i_can.c
@@ -604,7 +604,6 @@ static int sun4i_can_err(struct net_device *dev, u8 isrc, u8 status)
 		netdev_dbg(dev, "arbitration lost interrupt\n");
 		alc = readl(priv->base + SUN4I_REG_STA_ADDR);
 		priv->can.can_stats.arbitration_lost++;
-		stats->tx_errors++;
 		if (likely(skb)) {
 			cf->can_id |= CAN_ERR_LOSTARB;
 			cf->data[0] = (alc >> 8) & 0x1f;
-- 
2.29.2


