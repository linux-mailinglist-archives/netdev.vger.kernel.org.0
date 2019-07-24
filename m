Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4F872F66
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 15:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727287AbfGXND1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 09:03:27 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:44445 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbfGXND1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 09:03:27 -0400
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1hqGvV-0006gK-KX; Wed, 24 Jul 2019 15:03:25 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Willem de Bruijn <willemb@google.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 1/7] can: dev: call netif_carrier_off() in register_candev()
Date:   Wed, 24 Jul 2019 15:03:16 +0200
Message-Id: <20190724130322.31702-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190724130322.31702-1-mkl@pengutronix.de>
References: <20190724130322.31702-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

CONFIG_CAN_LEDS is deprecated. When trying to use the generic netdev
trigger as suggested, there's a small inconsistency with the link
property: The LED is on initially, stays on when the device is brought
up, and then turns off (as expected) when the device is brought down.

Make sure the LED always reflects the state of the CAN device.

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index b6b93a2d93a5..483d270664cc 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -1249,6 +1249,8 @@ int register_candev(struct net_device *dev)
 		return -EINVAL;
 
 	dev->rtnl_link_ops = &can_link_ops;
+	netif_carrier_off(dev);
+
 	return register_netdev(dev);
 }
 EXPORT_SYMBOL_GPL(register_candev);
-- 
2.20.1

