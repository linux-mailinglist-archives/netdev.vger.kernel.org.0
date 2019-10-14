Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3680D6B22
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 23:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387581AbfJNVUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 17:20:24 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37165 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731044AbfJNVUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 17:20:24 -0400
Received: by mail-pg1-f195.google.com with SMTP id p1so10784235pgi.4;
        Mon, 14 Oct 2019 14:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6hnKN1qn6JLpTqGZTLDM/rpkhCTaFPjWHHLh+2/f/Ls=;
        b=MVcxx5lEPiPXy0DHx260IoTJwTaCJ6QPc7Arebc7m+Hk1VlzFGhyl01W/WYXQl0wmS
         dH65hOmAds130pc5TI7O/K/iuc4d6K7hVEJrlo0QleOR63G3X2mub+pRTcTcL1T0CAJ7
         W5xFbnQWJ6yTX8gNWThqzLQdN5JGZS3ZMthdqCEgeqBbnZnjiahYXfierXrhzPnmKh80
         SfV/1xOORL+YR6MPGbz4gL1sd+EWi8TJcAkyekyldLrtNZPNCdJU/+jEEBLEk/r7vqpW
         9aYt/kwrpy5CS01LQkY6zzS4rvBbOXuhC522FXfXkYT9iHDVmfHCScH+tEM8qeWWDjd3
         cKOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6hnKN1qn6JLpTqGZTLDM/rpkhCTaFPjWHHLh+2/f/Ls=;
        b=GC3zwxhvw10QI6/Q9+yEb19gQV5NGCFxnIPcLJ9zAS6QPX6yKhapxYigkJ4PMdjNKl
         X5o/aE0G66heODyYQijVez2gf6p9b1fYVTWR2FbBaq0Q5X5xdWAADboylFsTtaC+RT7E
         cnMZvoakquUfbJzwLY2aCaFYyD6WlIzB/A4KRomaY4HjV9ApcLJ9IgYRiZxe6Pmxt8hc
         6tlQpyJUrtk5Y8i7mydfieOGWkRMC3ToCnbXt+SucJ608W+xkp0dM8x/mcAKQLqeuTGo
         Bf0Q1od6LFVLjmT02zQYn6wqhAIw12dC4mcea2aXJxeRcBdE5CcTbgjJGnZpxGweUYxy
         F8hA==
X-Gm-Message-State: APjAAAWW16QpyQfbivsANO43QS1ljju02ConVthTp1j/KU8RnfCSZQaU
        OESZfjkwjOeE+a2E+bt8rwlxkmmu
X-Google-Smtp-Source: APXvYqzBR113HjB6MReVbbJeiZmCPs00mQalASCCL13ftvB8BJ/UzpoGqFzbr+p7eXz0cKDxydPlrA==
X-Received: by 2002:a17:90a:8592:: with SMTP id m18mr38885129pjn.118.1571088023647;
        Mon, 14 Oct 2019 14:20:23 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c69sm1286528pga.69.2019.10.14.14.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 14:20:21 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     phil@raspberrypi.org, jonathan@raspberrypi.org,
        matthias.bgg@kernel.org, linux-rpi-kernel@lists.infradead.org,
        wahrenst@gmx.net, nsaenzjulienne@suse.de,
        Florian Fainelli <f.fainelli@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM GENET
        ETHERNET DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v2] net: bcmgenet: Generate a random MAC if none is valid
Date:   Mon, 14 Oct 2019 14:20:00 -0700
Message-Id: <20191014212000.27712-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of having a hard failure and stopping the driver's probe
routine, generate a random Ethernet MAC address to keep going.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:

- provide a message that a random MAC is used, the same message that
  bcmsysport.c uses

 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 12cb77ef1081..dd4e4f1dd384 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3461,16 +3461,10 @@ static int bcmgenet_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	if (dn) {
+	if (dn)
 		macaddr = of_get_mac_address(dn);
-		if (IS_ERR(macaddr)) {
-			dev_err(&pdev->dev, "can't find MAC address\n");
-			err = -EINVAL;
-			goto err;
-		}
-	} else {
+	else
 		macaddr = pd->mac_address;
-	}
 
 	priv->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(priv->base)) {
@@ -3482,7 +3476,12 @@ static int bcmgenet_probe(struct platform_device *pdev)
 
 	SET_NETDEV_DEV(dev, &pdev->dev);
 	dev_set_drvdata(&pdev->dev, dev);
-	ether_addr_copy(dev->dev_addr, macaddr);
+	if (IS_ERR_OR_NULL(macaddr) || !is_valid_ether_addr(macaddr)) {
+		dev_warn(&pdev->dev, "using random Ethernet MAC\n");
+		eth_hw_addr_random(dev);
+	} else {
+		ether_addr_copy(dev->dev_addr, macaddr);
+	}
 	dev->watchdog_timeo = 2 * HZ;
 	dev->ethtool_ops = &bcmgenet_ethtool_ops;
 	dev->netdev_ops = &bcmgenet_netdev_ops;
-- 
2.17.1

