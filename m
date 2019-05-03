Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33C201294C
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 09:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbfECH4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 03:56:40 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:44348 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727166AbfECH4j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 03:56:39 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id EB492357C;
        Fri,  3 May 2019 09:56:36 +0200 (CEST)
Received: by meh.true.cz (OpenSMTPD) with ESMTP id bfb4ad22;
        Fri, 3 May 2019 09:56:35 +0200 (CEST)
From:   =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 03/10] net: macb: support of_get_mac_address new ERR_PTR error
Date:   Fri,  3 May 2019 09:56:00 +0200
Message-Id: <1556870168-26864-4-git-send-email-ynezz@true.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1556870168-26864-1-git-send-email-ynezz@true.cz>
References: <1556870168-26864-1-git-send-email-ynezz@true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There was NVMEM support added directly to of_get_mac_address, and it
uses nvmem_get_mac_address under the hood, so we can remove it. As
of_get_mac_address can now return NULL and ERR_PTR encoded error values,
adjust to that as well.

Signed-off-by: Petr Štetiar <ynezz@true.cz>
---

 Changes since v2:

 * ERR_PTR and EPROBE_DEFER handling

 drivers/net/ethernet/cadence/macb_main.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 3da2795..964911a 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4172,15 +4172,13 @@ static int macb_probe(struct platform_device *pdev)
 		bp->rx_intr_mask |= MACB_BIT(RXUBR);
 
 	mac = of_get_mac_address(np);
-	if (mac) {
+	if (PTR_ERR(mac) == -EPROBE_DEFER) {
+		err = -EPROBE_DEFER;
+		goto err_out_free_netdev;
+	} else if (!IS_ERR_OR_NULL(mac)) {
 		ether_addr_copy(bp->dev->dev_addr, mac);
 	} else {
-		err = nvmem_get_mac_address(&pdev->dev, bp->dev->dev_addr);
-		if (err) {
-			if (err == -EPROBE_DEFER)
-				goto err_out_free_netdev;
-			macb_get_hwaddr(bp);
-		}
+		macb_get_hwaddr(bp);
 	}
 
 	err = of_get_phy_mode(np);
-- 
1.9.1

