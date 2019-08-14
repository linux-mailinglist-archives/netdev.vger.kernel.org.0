Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDE578C889
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbfHNCQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:16:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728096AbfHNCQP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:16:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 708472085A;
        Wed, 14 Aug 2019 02:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748974;
        bh=iMt6Qn1efyK3QfEFLC8bvF9ax3KIPLQSkSGy+fdIcK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A8TF35UCV+tMt+eaRto3zDOl//y/nMBRXf046ymziFcQW1T2PlQy2y/tVuvjAwIb9
         4pelmqTN3LkGyqNeperqVcJ2+QxI8e7VHPG0pYp8YHSm3CYN1HWEpmCv/4iLMvewBC
         qVtPOhyIBTBVWPiRwAM0U8sLjoHfgPWfSTSr+5to=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Weitao Hou <houweitaoo@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Sean Nyekjaer <sean@geanix.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 14/68] can: mcp251x: add error check when wq alloc failed
Date:   Tue, 13 Aug 2019 22:14:52 -0400
Message-Id: <20190814021548.16001-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021548.16001-1-sashal@kernel.org>
References: <20190814021548.16001-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Weitao Hou <houweitaoo@gmail.com>

[ Upstream commit 375f755899b8fc21196197e02aab26257df26e85 ]

add error check when workqueue alloc failed, and remove redundant code
to make it clear.

Fixes: e0000163e30e ("can: Driver for the Microchip MCP251x SPI CAN controllers")
Signed-off-by: Weitao Hou <houweitaoo@gmail.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Tested-by: Sean Nyekjaer <sean@geanix.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/spi/mcp251x.c | 49 ++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 27 deletions(-)

diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index da64e71a62ee2..fccb6bf21fada 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -678,17 +678,6 @@ static int mcp251x_power_enable(struct regulator *reg, int enable)
 		return regulator_disable(reg);
 }
 
-static void mcp251x_open_clean(struct net_device *net)
-{
-	struct mcp251x_priv *priv = netdev_priv(net);
-	struct spi_device *spi = priv->spi;
-
-	free_irq(spi->irq, priv);
-	mcp251x_hw_sleep(spi);
-	mcp251x_power_enable(priv->transceiver, 0);
-	close_candev(net);
-}
-
 static int mcp251x_stop(struct net_device *net)
 {
 	struct mcp251x_priv *priv = netdev_priv(net);
@@ -954,37 +943,43 @@ static int mcp251x_open(struct net_device *net)
 				   flags | IRQF_ONESHOT, DEVICE_NAME, priv);
 	if (ret) {
 		dev_err(&spi->dev, "failed to acquire irq %d\n", spi->irq);
-		mcp251x_power_enable(priv->transceiver, 0);
-		close_candev(net);
-		goto open_unlock;
+		goto out_close;
 	}
 
 	priv->wq = alloc_workqueue("mcp251x_wq", WQ_FREEZABLE | WQ_MEM_RECLAIM,
 				   0);
+	if (!priv->wq) {
+		ret = -ENOMEM;
+		goto out_clean;
+	}
 	INIT_WORK(&priv->tx_work, mcp251x_tx_work_handler);
 	INIT_WORK(&priv->restart_work, mcp251x_restart_work_handler);
 
 	ret = mcp251x_hw_reset(spi);
-	if (ret) {
-		mcp251x_open_clean(net);
-		goto open_unlock;
-	}
+	if (ret)
+		goto out_free_wq;
 	ret = mcp251x_setup(net, spi);
-	if (ret) {
-		mcp251x_open_clean(net);
-		goto open_unlock;
-	}
+	if (ret)
+		goto out_free_wq;
 	ret = mcp251x_set_normal_mode(spi);
-	if (ret) {
-		mcp251x_open_clean(net);
-		goto open_unlock;
-	}
+	if (ret)
+		goto out_free_wq;
 
 	can_led_event(net, CAN_LED_EVENT_OPEN);
 
 	netif_wake_queue(net);
+	mutex_unlock(&priv->mcp_lock);
 
-open_unlock:
+	return 0;
+
+out_free_wq:
+	destroy_workqueue(priv->wq);
+out_clean:
+	free_irq(spi->irq, priv);
+	mcp251x_hw_sleep(spi);
+out_close:
+	mcp251x_power_enable(priv->transceiver, 0);
+	close_candev(net);
 	mutex_unlock(&priv->mcp_lock);
 	return ret;
 }
-- 
2.20.1

