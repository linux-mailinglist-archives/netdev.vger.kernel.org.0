Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65B9217ACC9
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 18:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbgCERW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 12:22:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:39736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727461AbgCERN4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 12:13:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B2B220848;
        Thu,  5 Mar 2020 17:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428435;
        bh=fIW9RpwBzvjkRLCfM9sJ2cMeptlTr1Gs34EZQL58bpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vJLSMpucl/Fb9BswW/dAdM+zY8wwwpQnQQ0Qnw6m3LwW4tdp3p1LsxEP/8mYSIqX/
         PnuOYq7JrYq+Mo3smJGDYQB9t5J4E69lRHojf3wgnWbVT1Bo/kTUCCqWn+PyEJMcTj
         WBoCRSmlOKbE9YNt2sDGCKDahO1+WpUnIKo2rCtI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 33/67] net: ks8851-ml: Fix IRQ handling and locking
Date:   Thu,  5 Mar 2020 12:12:34 -0500
Message-Id: <20200305171309.29118-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305171309.29118-1-sashal@kernel.org>
References: <20200305171309.29118-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 44343418d0f2f623cb9da6f5000df793131cbe3b ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/micrel/ks8851_mll.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851_mll.c b/drivers/net/ethernet/micrel/ks8851_mll.c
index a41a90c589db2..20cb5b500661a 100644
--- a/drivers/net/ethernet/micrel/ks8851_mll.c
+++ b/drivers/net/ethernet/micrel/ks8851_mll.c
@@ -548,14 +548,17 @@ static irqreturn_t ks_irq(int irq, void *pw)
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
 
@@ -581,6 +584,7 @@ static irqreturn_t ks_irq(int irq, void *pw)
 		ks->netdev->stats.rx_over_errors++;
 	/* this should be the last in IRQ handler*/
 	ks_restore_cmd_reg(ks);
+	spin_unlock_irqrestore(&ks->statelock, flags);
 	return IRQ_HANDLED;
 }
 
@@ -650,6 +654,7 @@ static int ks_net_stop(struct net_device *netdev)
 
 	/* shutdown RX/TX QMU */
 	ks_disable_qmu(ks);
+	ks_disable_int(ks);
 
 	/* set powermode to soft power down to save power */
 	ks_set_powermode(ks, PMECR_PM_SOFTDOWN);
@@ -706,10 +711,9 @@ static netdev_tx_t ks_start_xmit(struct sk_buff *skb, struct net_device *netdev)
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
@@ -723,9 +727,7 @@ static netdev_tx_t ks_start_xmit(struct sk_buff *skb, struct net_device *netdev)
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
2.20.1

