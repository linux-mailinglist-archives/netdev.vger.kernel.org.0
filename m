Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D294A1171D7
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 17:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfLIQdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 11:33:36 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:50831 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbfLIQdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 11:33:04 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ieLy2-0001up-Q1; Mon, 09 Dec 2019 17:33:02 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Sean Nyekjaer <sean@geanix.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        linux-stable <stable@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 06/13] can: flexcan: fix possible deadlock and out-of-order reception after wakeup
Date:   Mon,  9 Dec 2019 17:32:49 +0100
Message-Id: <20191209163256.12000-7-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191209163256.12000-1-mkl@pengutronix.de>
References: <20191209163256.12000-1-mkl@pengutronix.de>
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

From: Sean Nyekjaer <sean@geanix.com>

When suspending, and there is still CAN traffic on the interfaces the
flexcan immediately wakes the platform again. As it should :-). But it
throws this error msg:

[ 3169.378661] PM: noirq suspend of devices failed

On the way down to suspend the interface that throws the error message
calls flexcan_suspend() but fails to call flexcan_noirq_suspend(). That
means flexcan_enter_stop_mode() is called, but on the way out of suspend
the driver only calls flexcan_resume() and skips flexcan_noirq_resume(),
thus it doesn't call flexcan_exit_stop_mode(). This leaves the flexcan
in stop mode, and with the current driver it can't recover from this
even with a soft reboot, it requires a hard reboot.

This patch fixes the deadlock when using self wakeup, by calling
flexcan_exit_stop_mode() from flexcan_resume() instead of
flexcan_noirq_resume().

This also fixes another issue: CAN frames are received out-of-order in
first IRQ handler run after wakeup.

The problem is that the wakeup latency from frame reception to the IRQ
handler (where the CAN frames are sorted by timestamp) is much bigger
than the time stamp counter wrap around time. This means it's
impossible to sort the CAN frames by timestamp.

The reason is that the controller exits stop mode during noirq resume,
which means it receives frames immediately, but interrupt handling is
still not possible.

So exit stop mode during resume stage instead of noirq resume fixes this
issue.

Fixes: de3578c198c6 ("can: flexcan: add self wakeup support")
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Tested-by: Sean Nyekjaer <sean@geanix.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Cc: linux-stable <stable@vger.kernel.org> # >= v5.0
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/flexcan.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index a929cdda9ab2..b6f675a5e2d9 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1722,6 +1722,9 @@ static int __maybe_unused flexcan_resume(struct device *device)
 		netif_start_queue(dev);
 		if (device_may_wakeup(device)) {
 			disable_irq_wake(dev->irq);
+			err = flexcan_exit_stop_mode(priv);
+			if (err)
+				return err;
 		} else {
 			err = pm_runtime_force_resume(device);
 			if (err)
@@ -1767,14 +1770,9 @@ static int __maybe_unused flexcan_noirq_resume(struct device *device)
 {
 	struct net_device *dev = dev_get_drvdata(device);
 	struct flexcan_priv *priv = netdev_priv(dev);
-	int err;
 
-	if (netif_running(dev) && device_may_wakeup(device)) {
+	if (netif_running(dev) && device_may_wakeup(device))
 		flexcan_enable_wakeup_irq(priv, false);
-		err = flexcan_exit_stop_mode(priv);
-		if (err)
-			return err;
-	}
 
 	return 0;
 }
-- 
2.24.0

