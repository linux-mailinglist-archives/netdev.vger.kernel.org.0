Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092A71D2362
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 02:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732884AbgENAIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 20:08:09 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:39633 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732871AbgENAII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 20:08:08 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 49MsLv0L4wz1qs3X;
        Thu, 14 May 2020 02:08:07 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 49MsLv03nvz1shf6;
        Thu, 14 May 2020 02:08:07 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id xqK_-SaRpSNU; Thu, 14 May 2020 02:08:05 +0200 (CEST)
X-Auth-Info: 21pPsPo6yAe+NISyElRZNwE1W6zOplvuYjThvxpp4v8=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu, 14 May 2020 02:08:05 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH V5 03/19] net: ks8851: Replace dev_err() with netdev_err() in IRQ handler
Date:   Thu, 14 May 2020 02:07:31 +0200
Message-Id: <20200514000747.159320-4-marex@denx.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200514000747.159320-1-marex@denx.de>
References: <20200514000747.159320-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev_err() instead of dev_err() to avoid accessing the spidev->dev
in the interrupt handler. This is the only place which uses the spidev
in this function, so replace it with netdev_err() to get rid of it. This
is done in preparation for unifying the KS8851 SPI and parallel drivers.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
---
V2: Add RB from Andrew
V3: No change
V4: No change
V5: No change
---
 drivers/net/ethernet/micrel/ks8851.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index 2b85072993c5..0088df970ad6 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -631,7 +631,7 @@ static irqreturn_t ks8851_irq(int irq, void *_ks)
 		handled |= IRQ_RXI;
 
 	if (status & IRQ_SPIBEI) {
-		dev_err(&ks->spidev->dev, "%s: spi bus error\n", __func__);
+		netdev_err(ks->netdev, "%s: spi bus error\n", __func__);
 		handled |= IRQ_SPIBEI;
 	}
 
-- 
2.25.1

