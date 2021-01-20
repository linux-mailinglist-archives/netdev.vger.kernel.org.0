Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5271E2FD241
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 15:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389338AbhATOCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 09:02:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732730AbhATMwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 07:52:49 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35199C0613D6
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 04:52:09 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1l2Cxz-000554-NU
        for netdev@vger.kernel.org; Wed, 20 Jan 2021 13:52:07 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id A774A5C8B12
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 12:52:05 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 0D0445C8AFD;
        Wed, 20 Jan 2021 12:52:04 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 2415bd1e;
        Wed, 20 Jan 2021 12:52:03 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 1/3] can: dev: can_restart: fix use after free bug
Date:   Wed, 20 Jan 2021 13:52:00 +0100
Message-Id: <20210120125202.2187358-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210120125202.2187358-1-mkl@pengutronix.de>
References: <20210120125202.2187358-1-mkl@pengutronix.de>
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

After calling netif_rx_ni(skb), dereferencing skb is unsafe.
Especially, the can_frame cf which aliases skb memory is accessed
after the netif_rx_ni() in:
      stats->rx_bytes += cf->len;

Reordering the lines solves the issue.

Fixes: 39549eef3587 ("can: CAN Network device driver and Netlink interface")
Link: https://lore.kernel.org/r/20210120114137.200019-2-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index 3486704c8a95..8b1ae023cb21 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -592,11 +592,11 @@ static void can_restart(struct net_device *dev)
 
 	cf->can_id |= CAN_ERR_RESTARTED;
 
-	netif_rx_ni(skb);
-
 	stats->rx_packets++;
 	stats->rx_bytes += cf->len;
 
+	netif_rx_ni(skb);
+
 restart:
 	netdev_dbg(dev, "restarted\n");
 	priv->can_stats.restarts++;

base-commit: 9c30ae8398b0813e237bde387d67a7f74ab2db2d
-- 
2.29.2


