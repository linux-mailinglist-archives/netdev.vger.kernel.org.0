Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9E63134CD
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbhBHOQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:16:45 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:57452 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232380AbhBHOIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 09:08:06 -0500
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
Subject: [PATCH 16/20] net: stmmac: Discard conditional service task execution
Date:   Mon, 8 Feb 2021 17:03:37 +0300
Message-ID: <20210208140341.9271-17-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208140341.9271-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208140341.9271-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Indeed CMWQ guaranties that each particular work item is non-reenatrant,
while using the atomic bitmask operation statement may cause a requested
event being missed if for instance some event happens while the service
task is being executed (see the STMMAC_SERVICE_SCHED flag semantic).
Similarly the service task can be requested for being executed while the
STMMAC core is in the down state. (Though for now there is no such
sub-task defined in the driver).

So to speak just drop the conditional service task execution and queue the
corresponding work anytime it's requested, while the service sub-tasks
shall determine whether they really need to be performed in particular
situations.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h      | 1 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 5 +----
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 3e2bf7e2dafb..d88bc8af8eaa 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -248,7 +248,6 @@ struct stmmac_priv {
 enum stmmac_state {
 	STMMAC_DOWN,
 	STMMAC_RESET_REQUESTED,
-	STMMAC_SERVICE_SCHED,
 };
 
 int stmmac_mdio_unregister(struct net_device *ndev);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 16e08cfaadf0..08112b6e7afd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -176,9 +176,7 @@ static void stmmac_enable_all_queues(struct stmmac_priv *priv)
 
 static void stmmac_service_event_schedule(struct stmmac_priv *priv)
 {
-	if (!test_bit(STMMAC_DOWN, &priv->state) &&
-	    !test_and_set_bit(STMMAC_SERVICE_SCHED, &priv->state))
-		queue_work(priv->wq, &priv->service_task);
+	queue_work(priv->wq, &priv->service_task);
 }
 
 static void stmmac_global_err(struct stmmac_priv *priv)
@@ -4683,7 +4681,6 @@ static void stmmac_service_task(struct work_struct *work)
 			service_task);
 
 	stmmac_reset_subtask(priv);
-	clear_bit(STMMAC_SERVICE_SCHED, &priv->state);
 }
 
 /**
-- 
2.29.2

