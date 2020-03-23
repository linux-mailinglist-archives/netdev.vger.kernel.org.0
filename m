Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA4D19020C
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 00:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbgCWXn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 19:43:28 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:46169 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbgCWXn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 19:43:28 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48mWCw2mn6z1rwZl;
        Tue, 24 Mar 2020 00:43:24 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48mWCw2ZVPz1qyDv;
        Tue, 24 Mar 2020 00:43:24 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id ek5nkX8h-XIz; Tue, 24 Mar 2020 00:43:23 +0100 (CET)
X-Auth-Info: btL2ENAz9r+cMTQ+lt0+ucrpLLYkUvwqbTns9QFzj4g=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue, 24 Mar 2020 00:43:23 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH 02/14] net: ks8851: Replace dev_err() with netdev_err() in IRQ handler
Date:   Tue, 24 Mar 2020 00:42:51 +0100
Message-Id: <20200323234303.526748-3-marex@denx.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200323234303.526748-1-marex@denx.de>
References: <20200323234303.526748-1-marex@denx.de>
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

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/micrel/ks8851.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index d1e0116c9728..8f4d7c0af723 100644
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

