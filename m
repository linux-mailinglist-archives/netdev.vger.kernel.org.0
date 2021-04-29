Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267AA36E95C
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 13:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240584AbhD2LJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 07:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233114AbhD2LJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 07:09:32 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED950C06138D
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 04:08:45 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lc4X6-00074s-Dv; Thu, 29 Apr 2021 13:08:36 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lc4X4-0000zG-MJ; Thu, 29 Apr 2021 13:08:34 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Colin Ian King <colin.king@canonical.com>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH net-next v1 2/3] net: dsa: ksz: ksz8795_spi_probe: fix possible NULL pointer dereference
Date:   Thu, 29 Apr 2021 13:08:32 +0200
Message-Id: <20210429110833.2181-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210429110833.2181-1-o.rempel@pengutronix.de>
References: <20210429110833.2181-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix possible NULL pointer dereference in case devm_kzalloc() failed to
allocate memory

Fixes: cc13e52c3a89 ("net: dsa: microchip: Add Microchip KSZ8863 SPI based driver support")
Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8795_spi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz8795_spi.c b/drivers/net/dsa/microchip/ksz8795_spi.c
index 85ba12aa82d8..ea7550d1b634 100644
--- a/drivers/net/dsa/microchip/ksz8795_spi.c
+++ b/drivers/net/dsa/microchip/ksz8795_spi.c
@@ -41,6 +41,9 @@ static int ksz8795_spi_probe(struct spi_device *spi)
 	int i, ret = 0;
 
 	ksz8 = devm_kzalloc(&spi->dev, sizeof(struct ksz8), GFP_KERNEL);
+	if (!ksz8)
+		return -ENOMEM;
+
 	ksz8->priv = spi;
 
 	dev = ksz_switch_alloc(&spi->dev, ksz8);
-- 
2.29.2

