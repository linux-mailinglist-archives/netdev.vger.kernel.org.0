Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D06412E2D
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 07:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbhIUF0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 01:26:52 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:12316 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229471AbhIUF0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 01:26:52 -0400
X-IronPort-AV: E=Sophos;i="5.85,310,1624287600"; 
   d="scan'208";a="94654052"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 21 Sep 2021 14:25:23 +0900
Received: from localhost.localdomain (unknown [10.166.14.185])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 3129541C799A;
        Tue, 21 Sep 2021 14:25:23 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     wg@grandegger.com, mkl@pengutronix.de
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Ayumi Nakamichi <ayumi.nakamichi.kf@renesas.com>
Subject: [PATCH] can: rcar_can: Fix suspend/resume
Date:   Tue, 21 Sep 2021 14:19:59 +0900
Message-Id: <20210921051959.50309-1-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the driver was not opened, rcar_can_suspend() should not call
clk_disable() because the clock was not enabled.

Fixes: fd1159318e55 ("can: add Renesas R-Car CAN driver")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Ayumi Nakamichi <ayumi.nakamichi.kf@renesas.com>
---
 drivers/net/can/rcar/rcar_can.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_can.c b/drivers/net/can/rcar/rcar_can.c
index 00e4533c8bdd..6b4eefb03044 100644
--- a/drivers/net/can/rcar/rcar_can.c
+++ b/drivers/net/can/rcar/rcar_can.c
@@ -846,10 +846,12 @@ static int __maybe_unused rcar_can_suspend(struct device *dev)
 	struct rcar_can_priv *priv = netdev_priv(ndev);
 	u16 ctlr;
 
-	if (netif_running(ndev)) {
-		netif_stop_queue(ndev);
-		netif_device_detach(ndev);
-	}
+	if (!netif_running(ndev))
+		return 0;
+
+	netif_stop_queue(ndev);
+	netif_device_detach(ndev);
+
 	ctlr = readw(&priv->regs->ctlr);
 	ctlr |= RCAR_CAN_CTLR_CANM_HALT;
 	writew(ctlr, &priv->regs->ctlr);
@@ -858,6 +860,7 @@ static int __maybe_unused rcar_can_suspend(struct device *dev)
 	priv->can.state = CAN_STATE_SLEEPING;
 
 	clk_disable(priv->clk);
+
 	return 0;
 }
 
@@ -868,6 +871,9 @@ static int __maybe_unused rcar_can_resume(struct device *dev)
 	u16 ctlr;
 	int err;
 
+	if (!netif_running(ndev))
+		return 0;
+
 	err = clk_enable(priv->clk);
 	if (err) {
 		netdev_err(ndev, "clk_enable() failed, error %d\n", err);
@@ -881,10 +887,9 @@ static int __maybe_unused rcar_can_resume(struct device *dev)
 	writew(ctlr, &priv->regs->ctlr);
 	priv->can.state = CAN_STATE_ERROR_ACTIVE;
 
-	if (netif_running(ndev)) {
-		netif_device_attach(ndev);
-		netif_start_queue(ndev);
-	}
+	netif_device_attach(ndev);
+	netif_start_queue(ndev);
+
 	return 0;
 }
 
-- 
2.25.1

