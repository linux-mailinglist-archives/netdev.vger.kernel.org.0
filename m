Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDDC12B2EFF
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 18:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgKNReg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 12:34:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbgKNRef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 12:34:35 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30839C0617A6
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 09:34:35 -0800 (PST)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kdzRZ-0000mY-9l; Sat, 14 Nov 2020 18:34:33 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Alejandro Concepcion Rodriguez <alejandro@acoro.eu>,
        Loris Fauster <loris.fauster@ttcontrol.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 03/15] can: dev: can_restart(): post buffer from the right context
Date:   Sat, 14 Nov 2020 18:33:47 +0100
Message-Id: <20201114173358.2058600-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201114173358.2058600-1-mkl@pengutronix.de>
References: <20201114173358.2058600-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alejandro Concepcion Rodriguez <alejandro@acoro.eu>

netif_rx() is meant to be called from interrupt contexts. can_restart() may be
called by can_restart_work(), which is called from a worqueue, so it may run in
process context. Use netif_rx_ni() instead.

Fixes: 39549eef3587 ("can: CAN Network device driver and Netlink interface")
Co-developed-by: Loris Fauster <loris.fauster@ttcontrol.com>
Signed-off-by: Loris Fauster <loris.fauster@ttcontrol.com>
Signed-off-by: Alejandro Concepcion Rodriguez <alejandro@acoro.eu>
Link: https://lore.kernel.org/r/4e84162b-fb31-3a73-fa9a-9438b4bd5234@acoro.eu
[mkl: use netif_rx_ni() instead of netif_rx_any_context()]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index 6dee4f8f2024..81e39d7507d8 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -592,7 +592,7 @@ static void can_restart(struct net_device *dev)
 
 	cf->can_id |= CAN_ERR_RESTARTED;
 
-	netif_rx(skb);
+	netif_rx_ni(skb);
 
 	stats->rx_packets++;
 	stats->rx_bytes += cf->can_dlc;
-- 
2.29.2

