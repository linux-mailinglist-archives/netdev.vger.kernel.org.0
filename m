Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D51DE486C
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 12:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409359AbfJYKRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 06:17:41 -0400
Received: from inva021.nxp.com ([92.121.34.21]:58568 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409056AbfJYKRi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 06:17:38 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 19584200475;
        Fri, 25 Oct 2019 12:17:36 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 0A98C200463;
        Fri, 25 Oct 2019 12:17:36 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id B03CB205DB;
        Fri, 25 Oct 2019 12:17:35 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     laurentiu.tudor@nxp.com, andrew@lunn.ch, f.fainelli@gmail.com,
        linux@armlinux.org.uk, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v3 3/5] dpaa2-eth: update the TX frame queues on DPNI_IRQ_EVENT_ENDPOINT_CHANGED
Date:   Fri, 25 Oct 2019 13:17:08 +0300
Message-Id: <1571998630-17108-4-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1571998630-17108-1-git-send-email-ioana.ciornei@nxp.com>
References: <1571998630-17108-1-git-send-email-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the function is called at every link up event, although the
FQID values will only change when the DPNI is disconnected from the
current object and reconnected to a different one.

The patch also avoids the forward declaration of update_tx_fqids.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none
Changes in v3:
 - none

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 90fc79b3fd0a..602d5118e928 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1255,8 +1255,6 @@ static void dpaa2_eth_set_rx_taildrop(struct dpaa2_eth_priv *priv, bool enable)
 	priv->rx_td_enabled = enable;
 }
 
-static void update_tx_fqids(struct dpaa2_eth_priv *priv);
-
 static int link_state_update(struct dpaa2_eth_priv *priv)
 {
 	struct dpni_link_state state = {0};
@@ -1283,7 +1281,6 @@ static int link_state_update(struct dpaa2_eth_priv *priv)
 		goto out;
 
 	if (state.up) {
-		update_tx_fqids(priv);
 		netif_carrier_on(priv->net_dev);
 		netif_tx_start_all_queues(priv->net_dev);
 	} else {
@@ -3363,8 +3360,10 @@ static irqreturn_t dpni_irq0_handler_thread(int irq_num, void *arg)
 	if (status & DPNI_IRQ_EVENT_LINK_CHANGED)
 		link_state_update(netdev_priv(net_dev));
 
-	if (status & DPNI_IRQ_EVENT_ENDPOINT_CHANGED)
+	if (status & DPNI_IRQ_EVENT_ENDPOINT_CHANGED) {
 		set_mac_addr(netdev_priv(net_dev));
+		update_tx_fqids(priv);
+	}
 
 	return IRQ_HANDLED;
 }
-- 
1.9.1

