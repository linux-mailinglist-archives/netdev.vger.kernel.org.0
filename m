Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B094161D67
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 23:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgBQWhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 17:37:08 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:40287 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgBQWhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 17:37:08 -0500
Received: by mail-qk1-f193.google.com with SMTP id b7so17733929qkl.7
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 14:37:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KS784o0IGEKIhOJxpUkOgdBWIc7LSVlI20Bg3J4dxho=;
        b=PsCgB0zMjpe/AlZ5Bn9DY3QWQ0qMVBoi26bzZIM3DpfQ3KplmapGNzHXi5YNWfGz+N
         8EAdKlO+3HS735qzcljZPLE/T6/RffUUnjjpazMkb5IcSE+VLWkGrDGu0EzMH/0iYw3J
         Z5xa5BBKxCN4aahGn6+GegCg6L5+kbru+BcbZVxHUVhTerQWJ9Hr8sA1Iq5ZGQgku/0L
         u1YbPJzkCi0PWzValdwC9UJM2xOQ6O9oladVPYnBrzjWvW7Rq+Qy1rfAdCox9TvijVCT
         YVqhiF05yYCcxyZLWD11/eOpGhjntTwowWTeyeaDZgAjC8qZyf40AvWJA2d9q0GJOgRh
         4YiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KS784o0IGEKIhOJxpUkOgdBWIc7LSVlI20Bg3J4dxho=;
        b=LomY5Xdv6c3zQsLusRR3F7df0sGj8aHMW8SEaDi6s8234akvjJ7FJDRr2VERv9jcbg
         9urH7EZTU8wskrAO9pSHz9vFiJT+TeL/MmzcHIMrAi9/o/xMKYOg4fdgXHAAGx5OP0E0
         DlIDQ4BoZ///K5usVNWHCOW7dH9jskvcPwSwP78+yHLc9Z9vVgJMXEx7nhpmet9AM7Bj
         uuvi4khg0gE3ZVK0sdvyw8FDN/PxaUZzIjTJg806vhRDzltlpOLR0zs6RBSu61ZI0uLa
         G/c2lIE6aauq7iK9+JloXjBj9PogdvAJ1+BLh0XeFvFyXmSp0K8d4v3rAFMX+YFZYodI
         j/9A==
X-Gm-Message-State: APjAAAXePL2FY23cBFK3pmdIsHSaG2h/CsrWLQ0QIK7IDksSRdbgTW1O
        /NKFOCCGI2kZ2AYuD28g93E=
X-Google-Smtp-Source: APXvYqz7/X8sw9xGPA+Pn8L+rNjc0uW9bMy0SCPSC/sSNyeSXHQSIrAHvFxBpRbWGtHfFnJOeLMdtA==
X-Received: by 2002:ae9:ed12:: with SMTP id c18mr16102919qkg.418.1581979027528;
        Mon, 17 Feb 2020 14:37:07 -0800 (PST)
Received: from fabio-Latitude-E5450.nxp.com ([2804:14c:482:5bb::1])
        by smtp.gmail.com with ESMTPSA id h6sm915557qtr.33.2020.02.17.14.37.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 14:37:06 -0800 (PST)
From:   Fabio Estevam <festevam@gmail.com>
To:     davem@davemloft.net
Cc:     fugang.duan@nxp.com, netdev@vger.kernel.org, andrew@lunn.ch,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH net-next] net: fec: Use a proper ID allocation scheme
Date:   Mon, 17 Feb 2020 19:36:51 -0300
Message-Id: <20200217223651.22688-1-festevam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently when performing an unbind/bind operation network is no
longer functional:

# echo 2188000.ethernet > /sys/bus/platform/drivers/fec/unbind
# echo 2188000.ethernet > /sys/bus/platform/drivers/fec/bind
[   10.756519] pps pps0: new PPS source ptp0
[   10.792626] libphy: fec_enet_mii_bus: probed
[   10.799330] fec 2188000.ethernet eth0: registered PHC device 1
# udhcpc -i eth0
udhcpc: started, v1.31.1
[   14.985211] fec 2188000.ethernet eth0: no PHY, assuming direct connection to switch
[   14.993140] libphy: PHY fixed-0:00 not found
[   14.997643] fec 2188000.ethernet eth0: could not attach to PHY
ifconfig: SIOCSIFFLAGS: No such device

The reason for the failure is that fec_drv_remove() does not
decrement the dev_id variable.

Instead of using such poor mechanism for counting the network interfaces
IDs, use a proper allocation scheme, such as IDR.

This fixes the network behavior after unbind/bind.

Tested on a imx6qp-sabresd board.

Suggested-by: David Miller <davem@davemloft.net>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
Hi,

There was a prior attempt to fix this problem:
https://www.spinics.net/lists/netdev/msg616487.html

, but it was rejected and David suggested the usage of IDR.

 drivers/net/ethernet/freescale/fec.h      |  1 +
 drivers/net/ethernet/freescale/fec_main.c | 15 +++++++++------
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index f79e57f735b3..0d718545b9a2 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -528,6 +528,7 @@ struct fec_enet_private {
 	struct	platform_device *pdev;
 
 	int	dev_id;
+	struct  idr idr;
 
 	/* Phylib and MDIO interface */
 	struct	mii_bus *mii_bus;
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 4432a59904c7..77b63ecf96b4 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -62,6 +62,7 @@
 #include <linux/if_vlan.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/prefetch.h>
+#include <linux/idr.h>
 #include <soc/imx/cpuidle.h>
 
 #include <asm/cacheflush.h>
@@ -1949,7 +1950,6 @@ static int fec_enet_mii_probe(struct net_device *ndev)
 	char mdio_bus_id[MII_BUS_ID_SIZE];
 	char phy_name[MII_BUS_ID_SIZE + 3];
 	int phy_id;
-	int dev_id = fep->dev_id;
 
 	if (fep->phy_node) {
 		phy_dev = of_phy_connect(ndev, fep->phy_node,
@@ -1964,8 +1964,6 @@ static int fec_enet_mii_probe(struct net_device *ndev)
 		for (phy_id = 0; (phy_id < PHY_MAX_ADDR); phy_id++) {
 			if (!mdiobus_is_registered_device(fep->mii_bus, phy_id))
 				continue;
-			if (dev_id--)
-				continue;
 			strlcpy(mdio_bus_id, fep->mii_bus->id, MII_BUS_ID_SIZE);
 			break;
 		}
@@ -3406,7 +3404,6 @@ fec_probe(struct platform_device *pdev)
 	struct net_device *ndev;
 	int i, irq, ret = 0;
 	const struct of_device_id *of_id;
-	static int dev_id;
 	struct device_node *np = pdev->dev.of_node, *phy_node;
 	int num_tx_qs;
 	int num_rx_qs;
@@ -3451,7 +3448,13 @@ fec_probe(struct platform_device *pdev)
 	}
 
 	fep->pdev = pdev;
-	fep->dev_id = dev_id++;
+	idr_init(&fep->idr);
+
+	ret = idr_alloc_cyclic(&fep->idr, fep, 0, INT_MAX, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+
+	fep->dev_id = ret;
 
 	platform_set_drvdata(pdev, ndev);
 
@@ -3632,7 +3635,6 @@ fec_probe(struct platform_device *pdev)
 		of_phy_deregister_fixed_link(np);
 	of_node_put(phy_node);
 failed_phy:
-	dev_id--;
 failed_ioremap:
 	free_netdev(ndev);
 
@@ -3661,6 +3663,7 @@ fec_drv_remove(struct platform_device *pdev)
 	if (of_phy_is_fixed_link(np))
 		of_phy_deregister_fixed_link(np);
 	of_node_put(fep->phy_node);
+	idr_destroy(&fep->idr);
 	free_netdev(ndev);
 
 	clk_disable_unprepare(fep->clk_ahb);
-- 
2.17.1

