Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1A461306F
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 16:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbfECOfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 10:35:18 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:17091 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728018AbfECOfR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 10:35:17 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 8BAAE4ACD;
        Fri,  3 May 2019 16:27:33 +0200 (CEST)
Received: by meh.true.cz (OpenSMTPD) with ESMTP id fc19d9f1;
        Fri, 3 May 2019 16:27:32 +0200 (CEST)
From:   =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 04/10] net: davinci: support of_get_mac_address new ERR_PTR error
Date:   Fri,  3 May 2019 16:27:09 +0200
Message-Id: <1556893635-18549-5-git-send-email-ynezz@true.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1556893635-18549-1-git-send-email-ynezz@true.cz>
References: <1556893635-18549-1-git-send-email-ynezz@true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There was NVMEM support added directly to of_get_mac_address, and it uses
nvmem_get_mac_address under the hood, so we can remove it. As
of_get_mac_address can now return ERR_PTR encoded error values, adjust to
that as well.

Signed-off-by: Petr Štetiar <ynezz@true.cz>
---

 Changes since v2:

  * ERR_PTR handling

 Changes since v3:

  * IS_ERR_OR_NULL -> IS_ERR

 drivers/net/ethernet/ti/davinci_emac.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index 57450b1..c117a8f 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -1714,7 +1714,7 @@ static struct net_device_stats *emac_dev_getnetstats(struct net_device *ndev)
 
 	if (!is_valid_ether_addr(pdata->mac_addr)) {
 		mac_addr = of_get_mac_address(np);
-		if (mac_addr)
+		if (!IS_ERR(mac_addr))
 			ether_addr_copy(pdata->mac_addr, mac_addr);
 	}
 
@@ -1912,15 +1912,11 @@ static int davinci_emac_probe(struct platform_device *pdev)
 		ether_addr_copy(ndev->dev_addr, priv->mac_addr);
 
 	if (!is_valid_ether_addr(priv->mac_addr)) {
-		/* Try nvmem if MAC wasn't passed over pdata or DT. */
-		rc = nvmem_get_mac_address(&pdev->dev, priv->mac_addr);
-		if (rc) {
-			/* Use random MAC if still none obtained. */
-			eth_hw_addr_random(ndev);
-			memcpy(priv->mac_addr, ndev->dev_addr, ndev->addr_len);
-			dev_warn(&pdev->dev, "using random MAC addr: %pM\n",
-				 priv->mac_addr);
-		}
+		/* Use random MAC if still none obtained. */
+		eth_hw_addr_random(ndev);
+		memcpy(priv->mac_addr, ndev->dev_addr, ndev->addr_len);
+		dev_warn(&pdev->dev, "using random MAC addr: %pM\n",
+			 priv->mac_addr);
 	}
 
 	ndev->netdev_ops = &emac_netdev_ops;
-- 
1.9.1

