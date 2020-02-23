Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9486E1697E3
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 14:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgBWNiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 08:38:54 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:41544 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgBWNix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 08:38:53 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48QR9h6hKwz1qr4x;
        Sun, 23 Feb 2020 14:38:45 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48QR9d6J5Rz1r0cN;
        Sun, 23 Feb 2020 14:38:45 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id ebCWh7-Rq8qo; Sun, 23 Feb 2020 14:38:44 +0100 (CET)
X-Auth-Info: /jqsAtzJ2fVC8MNoLiaDRBNeyneHjPfDMUL6E1+yjqc=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sun, 23 Feb 2020 14:38:44 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] net: ks8851-ml: Fix IRQ handling and locking
Date:   Sun, 23 Feb 2020 14:38:40 +0100
Message-Id: <20200223133840.318025-1-marex@denx.de>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The KS8851 requires that packet RX and TX are mutually exclusive.
Currently, the driver hopes to achieve this by disabling interrupt
from the card by writing the card registers and by disabling the
interrupt on the interrupt controller. This however is racy on SMP.

Replace this approach by expanding the spinlock used around the
ks_start_xmit() TX path to ks_irq() RX path to assure true mutual
exclusion and remove the interrupt enabling/disabling, which is
now not needed anymore. Furthermore, disable interrupts also in
ks_net_stop(), which was missing before.

Note that a massive improvement here would be to re-use the KS8851
driver approach, which is to move the TX path into a worker thread,
interrupt handling to threaded interrupt, and synchronize everything
with mutexes, but that would be a much bigger rework, for a separate
patch.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/micrel/ks8851_mll.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851_mll.c b/drivers/net/ethernet/micrel/ks8851_mll.c
index 1c9e70c8cc30..58579baf3f7a 100644
--- a/drivers/net/ethernet/micrel/ks8851_mll.c
+++ b/drivers/net/ethernet/micrel/ks8851_mll.c
@@ -513,14 +513,17 @@ static irqreturn_t ks_irq(int irq, void *pw)
 {
 	struct net_device *netdev = pw;
 	struct ks_net *ks = netdev_priv(netdev);
+	unsigned long flags;
 	u16 status;
 
+	spin_lock_irqsave(&ks->statelock, flags);
 	/*this should be the first in IRQ handler */
 	ks_save_cmd_reg(ks);
 
 	status = ks_rdreg16(ks, KS_ISR);
 	if (unlikely(!status)) {
 		ks_restore_cmd_reg(ks);
+		spin_unlock_irqrestore(&ks->statelock, flags);
 		return IRQ_NONE;
 	}
 
@@ -546,6 +549,7 @@ static irqreturn_t ks_irq(int irq, void *pw)
 		ks->netdev->stats.rx_over_errors++;
 	/* this should be the last in IRQ handler*/
 	ks_restore_cmd_reg(ks);
+	spin_unlock_irqrestore(&ks->statelock, flags);
 	return IRQ_HANDLED;
 }
 
@@ -615,6 +619,7 @@ static int ks_net_stop(struct net_device *netdev)
 
 	/* shutdown RX/TX QMU */
 	ks_disable_qmu(ks);
+	ks_disable_int(ks);
 
 	/* set powermode to soft power down to save power */
 	ks_set_powermode(ks, PMECR_PM_SOFTDOWN);
@@ -671,10 +676,9 @@ static netdev_tx_t ks_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
 	netdev_tx_t retv = NETDEV_TX_OK;
 	struct ks_net *ks = netdev_priv(netdev);
+	unsigned long flags;
 
-	disable_irq(netdev->irq);
-	ks_disable_int(ks);
-	spin_lock(&ks->statelock);
+	spin_lock_irqsave(&ks->statelock, flags);
 
 	/* Extra space are required:
 	*  4 byte for alignment, 4 for status/length, 4 for CRC
@@ -688,9 +692,7 @@ static netdev_tx_t ks_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 		dev_kfree_skb(skb);
 	} else
 		retv = NETDEV_TX_BUSY;
-	spin_unlock(&ks->statelock);
-	ks_enable_int(ks);
-	enable_irq(netdev->irq);
+	spin_unlock_irqrestore(&ks->statelock, flags);
 	return retv;
 }
 
-- 
2.25.0

