Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C43E12C8472
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 13:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgK3Myf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 07:54:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgK3Mye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 07:54:34 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE65C0617A7
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 04:53:15 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kjig6-00041N-9F
        for netdev@vger.kernel.org; Mon, 30 Nov 2020 13:53:14 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id E338659F900
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 12:53:10 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 9208A59F8E9;
        Mon, 30 Nov 2020 12:53:09 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 37dadc1d;
        Mon, 30 Nov 2020 12:53:08 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Jeroen Hofstee <jhofstee@victronenergy.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 2/5] can: sja1000: sja1000_err(): don't count arbitration lose as an error
Date:   Mon, 30 Nov 2020 13:53:04 +0100
Message-Id: <20201130125307.218258-3-mkl@pengutronix.de>
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
Hence most driver only increment arbitration_lost, but the sja1000 driver also
incremeants tx_error, causing errors to be reported on a normal functioning
CAN-bus. So stop counting them as errors.

Fixes: 8935f57e68c4 ("can: sja1000: fix network statistics update")
Signed-off-by: Jeroen Hofstee <jhofstee@victronenergy.com>
Link: https://lore.kernel.org/r/20201127095941.21609-1-jhofstee@victronenergy.com
[mkl: split into two seperate patches]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/sja1000/sja1000.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
index 9f107798f904..25a4d7d0b349 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -474,7 +474,6 @@ static int sja1000_err(struct net_device *dev, uint8_t isrc, uint8_t status)
 		netdev_dbg(dev, "arbitration lost interrupt\n");
 		alc = priv->read_reg(priv, SJA1000_ALC);
 		priv->can.can_stats.arbitration_lost++;
-		stats->tx_errors++;
 		cf->can_id |= CAN_ERR_LOSTARB;
 		cf->data[0] = alc & 0x1f;
 	}
-- 
2.29.2


