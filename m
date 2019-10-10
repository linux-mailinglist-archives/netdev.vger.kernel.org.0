Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF75FD292F
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 14:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387621AbfJJMSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 08:18:13 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:45203 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387586AbfJJMSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 08:18:12 -0400
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iIXOU-0006Lw-EL; Thu, 10 Oct 2019 14:18:10 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org, linux-can <linux-can@vger.kernel.org>
Cc:     davem@davemloft.net, kernel@pengutronix.de,
        jhofstee@victronenergy.com,
        =?UTF-8?q?Martin=20Hundeb=C3=B8ll?= <martin@geanix.com>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 22/29] can: ti_hecc: keep MIM and MD set
Date:   Thu, 10 Oct 2019 14:17:43 +0200
Message-Id: <20191010121750.27237-23-mkl@pengutronix.de>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010121750.27237-1-mkl@pengutronix.de>
References: <20191010121750.27237-1-mkl@pengutronix.de>
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

From: Jeroen Hofstee <jhofstee@victronenergy.com>

The HECC_CANMIM is set in the xmit path and cleared in the interrupt.
Since this is done with a read, modify, write action the register might
end up with some more MIM enabled then intended, since it is not
protected. That doesn't matter at all, since the tx interrupt disables
the mailbox with HECC_CANME (while holding a spinlock). So lets just
always keep MIM set.

While at it, since the mailbox direction never changes, don't set it
every time a message is send, ti_hecc_reset() already sets them to tx.

Signed-off-by: Jeroen Hofstee <jhofstee@victronenergy.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/ti_hecc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index eb8151154083..d6a84f8ff863 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -382,6 +382,9 @@ static void ti_hecc_start(struct net_device *ndev)
 		hecc_set_bit(priv, HECC_CANMIM, mbx_mask);
 	}
 
+	/* Enable tx interrupts */
+	hecc_set_bit(priv, HECC_CANMIM, BIT(HECC_MAX_TX_MBOX) - 1);
+
 	/* Prevent message over-write & Enable interrupts */
 	hecc_write(priv, HECC_CANOPC, HECC_SET_REG);
 	if (priv->use_hecc1int) {
@@ -511,8 +514,6 @@ static netdev_tx_t ti_hecc_xmit(struct sk_buff *skb, struct net_device *ndev)
 	hecc_set_bit(priv, HECC_CANME, mbx_mask);
 	spin_unlock_irqrestore(&priv->mbx_lock, flags);
 
-	hecc_clear_bit(priv, HECC_CANMD, mbx_mask);
-	hecc_set_bit(priv, HECC_CANMIM, mbx_mask);
 	hecc_write(priv, HECC_CANTRS, mbx_mask);
 
 	return NETDEV_TX_OK;
@@ -676,7 +677,6 @@ static irqreturn_t ti_hecc_interrupt(int irq, void *dev_id)
 			mbx_mask = BIT(mbxno);
 			if (!(mbx_mask & hecc_read(priv, HECC_CANTA)))
 				break;
-			hecc_clear_bit(priv, HECC_CANMIM, mbx_mask);
 			hecc_write(priv, HECC_CANTA, mbx_mask);
 			spin_lock_irqsave(&priv->mbx_lock, flags);
 			hecc_clear_bit(priv, HECC_CANME, mbx_mask);
-- 
2.23.0

