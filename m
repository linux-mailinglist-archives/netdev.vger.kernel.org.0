Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E263134CC
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbhBHOQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:16:21 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:57456 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232377AbhBHOIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 09:08:04 -0500
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 17/20] net: stmmac: Add 'cause' arg to the service task executioner
Date:   Mon, 8 Feb 2021 17:03:38 +0300
Message-ID: <20210208140341.9271-18-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208140341.9271-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208140341.9271-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to have a more descriptive and coherent service task interface
let's add the cause argument to the stmmac_service_event_schedule()
method. It will be used to test-and-set the corresponding flag in the
private device state variable, and execute the service handler if the flag
hasn't been set. By doing so we'll be able to activate the service
sub-task just by calling the stmmac_service_event_schedule() method.

Note currently there is only a single user of the service tasks interface.
It's used to handle a case of the critical device errors to cause the
interface reset. The changes provided here will also prevent the global
error handler from being called twice if the service task has already
being executed while reset sub-task still isn't started.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 08112b6e7afd..f3ced94b3f4e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -174,16 +174,18 @@ static void stmmac_enable_all_queues(struct stmmac_priv *priv)
 	}
 }
 
-static void stmmac_service_event_schedule(struct stmmac_priv *priv)
+static void stmmac_service_event_schedule(struct stmmac_priv *priv,
+					  unsigned long cause)
 {
-	queue_work(priv->wq, &priv->service_task);
+	if (!test_and_set_bit(cause, &priv->state))
+		queue_work(priv->wq, &priv->service_task);
 }
 
 static void stmmac_global_err(struct stmmac_priv *priv)
 {
 	netif_carrier_off(priv->dev);
-	set_bit(STMMAC_RESET_REQUESTED, &priv->state);
-	stmmac_service_event_schedule(priv);
+
+	stmmac_service_event_schedule(priv, STMMAC_RESET_REQUESTED);
 }
 
 /**
@@ -4658,8 +4660,6 @@ static const struct net_device_ops stmmac_netdev_ops = {
 
 static void stmmac_reset_subtask(struct stmmac_priv *priv)
 {
-	if (!test_and_clear_bit(STMMAC_RESET_REQUESTED, &priv->state))
-		return;
 	if (test_bit(STMMAC_DOWN, &priv->state))
 		return;
 
@@ -4680,7 +4680,8 @@ static void stmmac_service_task(struct work_struct *work)
 	struct stmmac_priv *priv = container_of(work, struct stmmac_priv,
 			service_task);
 
-	stmmac_reset_subtask(priv);
+	if (test_and_clear_bit(STMMAC_RESET_REQUESTED, &priv->state))
+		stmmac_reset_subtask(priv);
 }
 
 /**
-- 
2.29.2

