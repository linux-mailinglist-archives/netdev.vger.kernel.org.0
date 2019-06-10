Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD343B154
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 10:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388703AbfFJIzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 04:55:37 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:56855 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387946AbfFJIzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 04:55:36 -0400
X-Originating-IP: 90.88.159.246
Received: from mc-bl-xps13.lan (aaubervilliers-681-1-40-246.w90-88.abo.wanadoo.fr [90.88.159.246])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id C3ADCFF80C;
        Mon, 10 Jun 2019 08:55:33 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, stefanc@marvell.com,
        ymarkman@marvell.com, mw@semihalf.com
Subject: [PATCH net-next 1/3] net: mvpp2: Only clear the stat counters at port init
Date:   Mon, 10 Jun 2019 10:55:27 +0200
Message-Id: <20190610085529.16803-2-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190610085529.16803-1-maxime.chevallier@bootlin.com>
References: <20190610085529.16803-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When first configuring a port on PPv2, we want to clear the internal
counters so that we don't get values from previous boot stages.

However, we can't really clear these counters when resetting the MAC,
since there are valid reasons to do so while the port is being used,
such as when reconfiguring the interface mode with the PHY.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 4b4d79611339..ee653125194e 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1359,13 +1359,8 @@ static int mvpp2_ethtool_get_sset_count(struct net_device *dev, int sset)
 
 static void mvpp2_mac_reset_assert(struct mvpp2_port *port)
 {
-	unsigned int i;
 	u32 val;
 
-	/* Read the GOP statistics to reset the hardware counters */
-	for (i = 0; i < ARRAY_SIZE(mvpp2_ethtool_regs); i++)
-		mvpp2_read_count(port, &mvpp2_ethtool_regs[i]);
-
 	val = readl(port->base + MVPP2_GMAC_CTRL_2_REG) |
 	      MVPP2_GMAC_PORT_RESET_MASK;
 	writel(val, port->base + MVPP2_GMAC_CTRL_2_REG);
@@ -4265,7 +4260,7 @@ static int mvpp2_port_init(struct mvpp2_port *port)
 	struct mvpp2 *priv = port->priv;
 	struct mvpp2_txq_pcpu *txq_pcpu;
 	unsigned int thread;
-	int queue, err;
+	int queue, err, i;
 
 	/* Checks for hardware constraints */
 	if (port->first_rxq + port->nrxqs >
@@ -4372,6 +4367,10 @@ static int mvpp2_port_init(struct mvpp2_port *port)
 	if (err)
 		goto err_free_percpu;
 
+	/* Read the GOP statistics to reset the hardware counters */
+	for (i = 0; i < ARRAY_SIZE(mvpp2_ethtool_regs); i++)
+		mvpp2_read_count(port, &mvpp2_ethtool_regs[i]);
+
 	return 0;
 
 err_free_percpu:
-- 
2.20.1

