Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF8AA19AB9
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 11:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbfEJJgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 05:36:04 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:33296 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727298AbfEJJfz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 May 2019 05:35:55 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id D8024434D;
        Fri, 10 May 2019 11:35:50 +0200 (CEST)
Received: by meh.true.cz (OpenSMTPD) with ESMTP id 0141c5c7;
        Fri, 10 May 2019 11:35:49 +0200 (CEST)
From:   =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Li Yang <leoyang.li@nxp.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Michal Simek <michal.simek@xilinx.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh@kernel.org>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-renesas-soc@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH net 4/5] net: ethernet: fix similar warning reported by kbuild test robot
Date:   Fri, 10 May 2019 11:35:17 +0200
Message-Id: <1557480918-9627-5-git-send-email-ynezz@true.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1557480918-9627-1-git-send-email-ynezz@true.cz>
References: <1557480918-9627-1-git-send-email-ynezz@true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes following (similar) warning reported by kbuild test robot:

 In function ‘memcpy’,
  inlined from ‘smsc75xx_init_mac_address’ at drivers/net/usb/smsc75xx.c:778:3,
  inlined from ‘smsc75xx_bind’ at drivers/net/usb/smsc75xx.c:1501:2:
  ./include/linux/string.h:355:9: warning: argument 2 null where non-null expected [-Wnonnull]
  return __builtin_memcpy(p, q, size);
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
  drivers/net/usb/smsc75xx.c: In function ‘smsc75xx_bind’:
  ./include/linux/string.h:355:9: note: in a call to built-in function ‘__builtin_memcpy’

I've replaced the offending memcpy with ether_addr_copy, because I'm
100% sure, that of_get_mac_address can't return NULL as it returns valid
pointer or ERR_PTR encoded value, nothing else.

I'm hesitant to just change IS_ERR into IS_ERR_OR_NULL check, as this
would make the warning disappear also, but it would be confusing to
check for impossible return value just to make a compiler happy.

I'm now changing all occurencies of memcpy to ether_addr_copy after the
of_get_mac_address call, as it's very likely, that we're going to get
similar reports from kbuild test robot in the future.

Fixes: a51645f70f63 ("net: ethernet: support of_get_mac_address new ERR_PTR error")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Petr Štetiar <ynezz@true.cz>
---
 drivers/net/ethernet/allwinner/sun4i-emac.c           | 2 +-
 drivers/net/ethernet/arc/emac_main.c                  | 2 +-
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c      | 2 +-
 drivers/net/ethernet/davicom/dm9000.c                 | 2 +-
 drivers/net/ethernet/freescale/fec_mpc52xx.c          | 2 +-
 drivers/net/ethernet/freescale/fman/mac.c             | 2 +-
 drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c | 2 +-
 drivers/net/ethernet/freescale/gianfar.c              | 2 +-
 drivers/net/ethernet/freescale/ucc_geth.c             | 2 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c            | 2 +-
 drivers/net/ethernet/marvell/mvneta.c                 | 2 +-
 drivers/net/ethernet/marvell/sky2.c                   | 2 +-
 drivers/net/ethernet/micrel/ks8851.c                  | 2 +-
 drivers/net/ethernet/micrel/ks8851_mll.c              | 2 +-
 drivers/net/ethernet/nxp/lpc_eth.c                    | 2 +-
 drivers/net/ethernet/renesas/sh_eth.c                 | 2 +-
 drivers/net/ethernet/ti/cpsw.c                        | 2 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c           | 2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c         | 2 +-
 19 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index 37ebd890ef51..9e06dff619c3 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -871,7 +871,7 @@ static int emac_probe(struct platform_device *pdev)
 	/* Read MAC-address from DT */
 	mac_addr = of_get_mac_address(np);
 	if (!IS_ERR(mac_addr))
-		memcpy(ndev->dev_addr, mac_addr, ETH_ALEN);
+		ether_addr_copy(ndev->dev_addr, mac_addr);
 
 	/* Check if the MAC address is valid, if not get a random one */
 	if (!is_valid_ether_addr(ndev->dev_addr)) {
diff --git a/drivers/net/ethernet/arc/emac_main.c b/drivers/net/ethernet/arc/emac_main.c
index 7f89ad5c336d..13a1d99b29c6 100644
--- a/drivers/net/ethernet/arc/emac_main.c
+++ b/drivers/net/ethernet/arc/emac_main.c
@@ -961,7 +961,7 @@ int arc_emac_probe(struct net_device *ndev, int interface)
 	mac_addr = of_get_mac_address(dev->of_node);
 
 	if (!IS_ERR(mac_addr))
-		memcpy(ndev->dev_addr, mac_addr, ETH_ALEN);
+		ether_addr_copy(ndev->dev_addr, mac_addr);
 	else
 		eth_hw_addr_random(ndev);
 
diff --git a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
index 15b1130aa4ae..0e5de88fd6e8 100644
--- a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
@@ -1504,7 +1504,7 @@ static int octeon_mgmt_probe(struct platform_device *pdev)
 	mac = of_get_mac_address(pdev->dev.of_node);
 
 	if (!IS_ERR(mac))
-		memcpy(netdev->dev_addr, mac, ETH_ALEN);
+		ether_addr_copy(netdev->dev_addr, mac);
 	else
 		eth_hw_addr_random(netdev);
 
diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index 953ee5616801..5e1aff9a5fd6 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -1413,7 +1413,7 @@ static struct dm9000_plat_data *dm9000_parse_dt(struct device *dev)
 
 	mac_addr = of_get_mac_address(np);
 	if (!IS_ERR(mac_addr))
-		memcpy(pdata->dev_addr, mac_addr, sizeof(pdata->dev_addr));
+		ether_addr_copy(pdata->dev_addr, mac_addr);
 
 	return pdata;
 }
diff --git a/drivers/net/ethernet/freescale/fec_mpc52xx.c b/drivers/net/ethernet/freescale/fec_mpc52xx.c
index 7b7e526869a7..30cdb246d020 100644
--- a/drivers/net/ethernet/freescale/fec_mpc52xx.c
+++ b/drivers/net/ethernet/freescale/fec_mpc52xx.c
@@ -903,7 +903,7 @@ static int mpc52xx_fec_probe(struct platform_device *op)
 	 */
 	mac_addr = of_get_mac_address(np);
 	if (!IS_ERR(mac_addr)) {
-		memcpy(ndev->dev_addr, mac_addr, ETH_ALEN);
+		ether_addr_copy(ndev->dev_addr, mac_addr);
 	} else {
 		struct mpc52xx_fec __iomem *fec = priv->fec;
 
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 9cd2c28d17df..7ab8095db192 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -729,7 +729,7 @@ static int mac_probe(struct platform_device *_of_dev)
 		err = -EINVAL;
 		goto _return_of_get_parent;
 	}
-	memcpy(mac_dev->addr, mac_addr, sizeof(mac_dev->addr));
+	ether_addr_copy(mac_dev->addr, mac_addr);
 
 	/* Get the port handles */
 	nph = of_count_phandle_with_args(mac_node, "fsl,fman-ports", NULL);
diff --git a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
index 90ea7a115d0f..5fad73b2e123 100644
--- a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
+++ b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
@@ -1015,7 +1015,7 @@ static int fs_enet_probe(struct platform_device *ofdev)
 
 	mac_addr = of_get_mac_address(ofdev->dev.of_node);
 	if (!IS_ERR(mac_addr))
-		memcpy(ndev->dev_addr, mac_addr, ETH_ALEN);
+		ether_addr_copy(ndev->dev_addr, mac_addr);
 
 	ret = fep->ops->allocate_bd(ndev);
 	if (ret)
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index df13c693b038..e670cd293dba 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -873,7 +873,7 @@ static int gfar_of_init(struct platform_device *ofdev, struct net_device **pdev)
 	mac_addr = of_get_mac_address(np);
 
 	if (!IS_ERR(mac_addr))
-		memcpy(dev->dev_addr, mac_addr, ETH_ALEN);
+		ether_addr_copy(dev->dev_addr, mac_addr);
 
 	if (model && !strcasecmp(model, "TSEC"))
 		priv->device_flags |= FSL_GIANFAR_DEV_HAS_GIGABIT |
diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index 216e99af2b5a..4d6892d2f0a4 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -3911,7 +3911,7 @@ static int ucc_geth_probe(struct platform_device* ofdev)
 
 	mac_addr = of_get_mac_address(np);
 	if (!IS_ERR(mac_addr))
-		memcpy(dev->dev_addr, mac_addr, ETH_ALEN);
+		ether_addr_copy(dev->dev_addr, mac_addr);
 
 	ugeth->ug_info = ug_info;
 	ugeth->dev = device;
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 07e254fc96ef..409b69fd4374 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2750,7 +2750,7 @@ static int mv643xx_eth_shared_of_add_port(struct platform_device *pdev,
 
 	mac_addr = of_get_mac_address(pnp);
 	if (!IS_ERR(mac_addr))
-		memcpy(ppd.mac_addr, mac_addr, ETH_ALEN);
+		ether_addr_copy(ppd.mac_addr, mac_addr);
 
 	mv643xx_eth_property(pnp, "tx-queue-size", ppd.tx_queue_size);
 	mv643xx_eth_property(pnp, "tx-sram-addr", ppd.tx_sram_addr);
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 8186135883ed..e758650b2c26 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4565,7 +4565,7 @@ static int mvneta_probe(struct platform_device *pdev)
 	dt_mac_addr = of_get_mac_address(dn);
 	if (!IS_ERR(dt_mac_addr)) {
 		mac_from = "device tree";
-		memcpy(dev->dev_addr, dt_mac_addr, ETH_ALEN);
+		ether_addr_copy(dev->dev_addr, dt_mac_addr);
 	} else {
 		mvneta_get_mac_addr(pp, hw_mac_addr);
 		if (is_valid_ether_addr(hw_mac_addr)) {
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 9d070cca3e9e..5adf307fbbfd 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4805,7 +4805,7 @@ static struct net_device *sky2_init_netdev(struct sky2_hw *hw, unsigned port,
 	 */
 	iap = of_get_mac_address(hw->pdev->dev.of_node);
 	if (!IS_ERR(iap))
-		memcpy(dev->dev_addr, iap, ETH_ALEN);
+		ether_addr_copy(dev->dev_addr, iap);
 	else
 		memcpy_fromio(dev->dev_addr, hw->regs + B2_MAC_1 + port * 8,
 			      ETH_ALEN);
diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index b44172a901ed..ba4fdf1b0dea 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -426,7 +426,7 @@ static void ks8851_init_mac(struct ks8851_net *ks)
 
 	mac_addr = of_get_mac_address(ks->spidev->dev.of_node);
 	if (!IS_ERR(mac_addr)) {
-		memcpy(dev->dev_addr, mac_addr, ETH_ALEN);
+		ether_addr_copy(dev->dev_addr, mac_addr);
 		ks8851_write_mac_addr(dev);
 		return;
 	}
diff --git a/drivers/net/ethernet/micrel/ks8851_mll.c b/drivers/net/ethernet/micrel/ks8851_mll.c
index dc76b0d15234..e5c8412c08c1 100644
--- a/drivers/net/ethernet/micrel/ks8851_mll.c
+++ b/drivers/net/ethernet/micrel/ks8851_mll.c
@@ -1328,7 +1328,7 @@ static int ks8851_probe(struct platform_device *pdev)
 	if (pdev->dev.of_node) {
 		mac = of_get_mac_address(pdev->dev.of_node);
 		if (!IS_ERR(mac))
-			memcpy(ks->mac_addr, mac, ETH_ALEN);
+			ether_addr_copy(ks->mac_addr, mac);
 	} else {
 		struct ks8851_mll_platform_data *pdata;
 
diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index da138edddd32..fec604c4c0d3 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1369,7 +1369,7 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
 	if (!is_valid_ether_addr(ndev->dev_addr)) {
 		const char *macaddr = of_get_mac_address(np);
 		if (!IS_ERR(macaddr))
-			memcpy(ndev->dev_addr, macaddr, ETH_ALEN);
+			ether_addr_copy(ndev->dev_addr, macaddr);
 	}
 	if (!is_valid_ether_addr(ndev->dev_addr))
 		eth_hw_addr_random(ndev);
diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 7c4e282242d5..6354f19a31eb 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -3193,7 +3193,7 @@ static struct sh_eth_plat_data *sh_eth_parse_dt(struct device *dev)
 
 	mac_addr = of_get_mac_address(np);
 	if (!IS_ERR(mac_addr))
-		memcpy(pdata->mac_addr, mac_addr, ETH_ALEN);
+		ether_addr_copy(pdata->mac_addr, mac_addr);
 
 	pdata->no_ether_link =
 		of_property_read_bool(np, "renesas,no-ether-link");
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index b18eeb05b993..634fc484a0b3 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -2233,7 +2233,7 @@ static int cpsw_probe_dt(struct cpsw_platform_data *data,
 no_phy_slave:
 		mac_addr = of_get_mac_address(slave_node);
 		if (!IS_ERR(mac_addr)) {
-			memcpy(slave_data->mac_addr, mac_addr, ETH_ALEN);
+			ether_addr_copy(slave_data->mac_addr, mac_addr);
 		} else {
 			ret = ti_cm_get_macid(&pdev->dev, i,
 					      slave_data->mac_addr);
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 997475c209c0..47c45152132e 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -361,7 +361,7 @@ static void temac_do_set_mac_address(struct net_device *ndev)
 
 static int temac_init_mac_address(struct net_device *ndev, const void *address)
 {
-	memcpy(ndev->dev_addr, address, ETH_ALEN);
+	ether_addr_copy(ndev->dev_addr, address);
 	if (!is_valid_ether_addr(ndev->dev_addr))
 		eth_hw_addr_random(ndev);
 	temac_do_set_mac_address(ndev);
diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 691170753563..6886270da695 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -1167,7 +1167,7 @@ static int xemaclite_of_probe(struct platform_device *ofdev)
 
 	if (!IS_ERR(mac_address)) {
 		/* Set the MAC address. */
-		memcpy(ndev->dev_addr, mac_address, ETH_ALEN);
+		ether_addr_copy(ndev->dev_addr, mac_address);
 	} else {
 		dev_warn(dev, "No MAC address found, using random\n");
 		eth_hw_addr_random(ndev);
-- 
1.9.1

