Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A860117AB37
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 18:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgCERJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 12:09:06 -0500
Received: from inva021.nxp.com ([92.121.34.21]:34230 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbgCERJF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 12:09:05 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id B82B22007B0;
        Thu,  5 Mar 2020 18:09:02 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id AB62B2007A1;
        Thu,  5 Mar 2020 18:09:02 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 76A542059D;
        Thu,  5 Mar 2020 18:09:02 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, s.hauer@pengutronix.de,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Subject: [PATCH net-next v3 2/3] fsl/fman: tolerate missing MAC address in device tree
Date:   Thu,  5 Mar 2020 19:08:57 +0200
Message-Id: <1583428138-12733-3-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1583428138-12733-1-git-send-email-madalin.bucur@oss.nxp.com>
References: <1583428138-12733-1-git-send-email-madalin.bucur@oss.nxp.com>
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@oss.nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow the initialization of the MAC to be performed even if the
device tree does not provide a valid MAC address. Later a random
MAC address should be assigned by the Ethernet driver.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
---
 drivers/net/ethernet/freescale/fman/fman_dtsec.c | 10 ++++------
 drivers/net/ethernet/freescale/fman/fman_memac.c | 10 ++++------
 drivers/net/ethernet/freescale/fman/fman_tgec.c  | 10 ++++------
 drivers/net/ethernet/freescale/fman/mac.c        | 13 ++++++-------
 4 files changed, 18 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index f7aec507787f..004c266802a8 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -514,8 +514,10 @@ static int init(struct dtsec_regs __iomem *regs, struct dtsec_cfg *cfg,
 
 	iowrite32be(0xffffffff, &regs->ievent);
 
-	MAKE_ENET_ADDR_FROM_UINT64(addr, eth_addr);
-	set_mac_address(regs, (u8 *)eth_addr);
+	if (addr) {
+		MAKE_ENET_ADDR_FROM_UINT64(addr, eth_addr);
+		set_mac_address(regs, (u8 *)eth_addr);
+	}
 
 	/* HASH */
 	for (i = 0; i < NUM_OF_HASH_REGS; i++) {
@@ -553,10 +555,6 @@ static int check_init_parameters(struct fman_mac *dtsec)
 		pr_err("1G MAC driver supports 1G or lower speeds\n");
 		return -EINVAL;
 	}
-	if (dtsec->addr == 0) {
-		pr_err("Ethernet MAC Must have a valid MAC Address\n");
-		return -EINVAL;
-	}
 	if ((dtsec->dtsec_drv_param)->rx_prepend >
 	    MAX_PACKET_ALIGNMENT) {
 		pr_err("packetAlignmentPadding can't be > than %d\n",
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index e1901874c19f..f2b2bfcbb529 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -596,10 +596,6 @@ static void setup_sgmii_internal_phy_base_x(struct fman_mac *memac)
 
 static int check_init_parameters(struct fman_mac *memac)
 {
-	if (memac->addr == 0) {
-		pr_err("Ethernet MAC must have a valid MAC address\n");
-		return -EINVAL;
-	}
 	if (!memac->exception_cb) {
 		pr_err("Uninitialized exception handler\n");
 		return -EINVAL;
@@ -1057,8 +1053,10 @@ int memac_init(struct fman_mac *memac)
 	}
 
 	/* MAC Address */
-	MAKE_ENET_ADDR_FROM_UINT64(memac->addr, eth_addr);
-	add_addr_in_paddr(memac->regs, (u8 *)eth_addr, 0);
+	if (memac->addr != 0) {
+		MAKE_ENET_ADDR_FROM_UINT64(memac->addr, eth_addr);
+		add_addr_in_paddr(memac->regs, (u8 *)eth_addr, 0);
+	}
 
 	fixed_link = memac_drv_param->fixed_link;
 
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
index f75b9c11b2d2..8c7eb878d5b4 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
@@ -273,10 +273,6 @@ static int check_init_parameters(struct fman_mac *tgec)
 		pr_err("10G MAC driver only support 10G speed\n");
 		return -EINVAL;
 	}
-	if (tgec->addr == 0) {
-		pr_err("Ethernet 10G MAC Must have valid MAC Address\n");
-		return -EINVAL;
-	}
 	if (!tgec->exception_cb) {
 		pr_err("uninitialized exception_cb\n");
 		return -EINVAL;
@@ -706,8 +702,10 @@ int tgec_init(struct fman_mac *tgec)
 
 	cfg = tgec->cfg;
 
-	MAKE_ENET_ADDR_FROM_UINT64(tgec->addr, eth_addr);
-	set_mac_address(tgec->regs, (u8 *)eth_addr);
+	if (tgec->addr) {
+		MAKE_ENET_ADDR_FROM_UINT64(tgec->addr, eth_addr);
+		set_mac_address(tgec->regs, (u8 *)eth_addr);
+	}
 
 	/* interrupts */
 	/* FM_10G_REM_N_LCL_FLT_EX_10GMAC_ERRATA_SW005 Errata workaround */
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 55f2122c3217..43427c5b9396 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -724,12 +724,10 @@ static int mac_probe(struct platform_device *_of_dev)
 
 	/* Get the MAC address */
 	mac_addr = of_get_mac_address(mac_node);
-	if (IS_ERR(mac_addr)) {
-		dev_err(dev, "of_get_mac_address(%pOF) failed\n", mac_node);
-		err = -EINVAL;
-		goto _return_of_get_parent;
-	}
-	ether_addr_copy(mac_dev->addr, mac_addr);
+	if (IS_ERR(mac_addr))
+		dev_warn(dev, "of_get_mac_address(%pOF) failed\n", mac_node);
+	else
+		ether_addr_copy(mac_dev->addr, mac_addr);
 
 	/* Get the port handles */
 	nph = of_count_phandle_with_args(mac_node, "fsl,fman-ports", NULL);
@@ -855,7 +853,8 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (err < 0)
 		dev_err(dev, "fman_set_mac_active_pause() = %d\n", err);
 
-	dev_info(dev, "FMan MAC address: %pM\n", mac_dev->addr);
+	if (!IS_ERR(mac_addr))
+		dev_info(dev, "FMan MAC address: %pM\n", mac_dev->addr);
 
 	priv->eth_dev = dpaa_eth_add_device(fman_id, mac_dev);
 	if (IS_ERR(priv->eth_dev)) {
-- 
2.1.0

