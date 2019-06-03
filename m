Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F33833A64
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 23:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfFCV5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 17:57:35 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:12614 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbfFCV5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 17:57:33 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x53LvWE6000264
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 3 Jun 2019 15:57:32 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x53LvTMM008601
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 3 Jun 2019 15:57:32 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     anirudh@xilinx.com, John.Linn@xilinx.com,
        Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next 05/18] net: axienet: Allow explicitly setting MDIO clock divisor
Date:   Mon,  3 Jun 2019 15:57:04 -0600
Message-Id: <1559599037-8514-6-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1559599037-8514-1-git-send-email-hancock@sedsystems.ca>
References: <1559599037-8514-1-git-send-email-hancock@sedsystems.ca>
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver was previously always calculating the MDIO clock divisor
(from AXI bus clock to MDIO bus clock) based on the CPU clock frequency,
but that simplistic method only works on the MicroBlaze platform. This
really has to be a platform configuration setting as there is no way the
kernel can know the clock speed of the AXI bus in the general case.

Add an optional xlnx,mdio-clock-divisor device tree property that can be
used to explicitly set the MDIO bus divisor. This must be set based on the
AXI bus clock rate being used in the FPGA logic so that the resulting
MDIO clock rate is no greater than 2.5 MHz.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---
 .../devicetree/bindings/net/xilinx_axienet.txt     |   4 +
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |   5 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  10 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c  | 123 +++++++++++----------
 4 files changed, 79 insertions(+), 63 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
index 38f9ec0..708722e 100644
--- a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
+++ b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
@@ -31,6 +31,10 @@ Optional properties:
 		  1 to enable partial TX checksum offload,
 		  2 to enable full TX checksum offload
 - xlnx,rxcsum	: Same values as xlnx,txcsum but for RX checksum offload
+- xlnx,mdio-clock-divisor: Explicitly set clock divisor from AXI bus clock
+                           to MDIO bus. If not specified, it is auto-detected
+                           from the CPU clock (but only on platforms where this
+                           is possible).
 
 Example:
 	axi_ethernet_eth: ethernet@40c00000 {
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index f9078bd..1b3d8a4 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -418,6 +418,9 @@ struct axienet_local {
 	/* Connection to PHY device */
 	struct device_node *phy_node;
 
+	/* MDIO clock divisor (0=detected from CPU clock) */
+	u32 mdio_clock_divisor;
+
 	/* MDIO bus data */
 	struct mii_bus *mii_bus;	/* MII bus reference */
 
@@ -502,7 +505,7 @@ static inline void axienet_iow(struct axienet_local *lp, off_t offset,
 }
 
 /* Function prototypes visible in xilinx_axienet_mdio.c for other files */
-int axienet_mdio_setup(struct axienet_local *lp, struct device_node *np);
+int axienet_mdio_setup(struct axienet_local *lp);
 int axienet_mdio_wait_until_ready(struct axienet_local *lp);
 void axienet_mdio_teardown(struct axienet_local *lp);
 
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index ffbd4d7..09a489d 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1611,9 +1611,15 @@ static int axienet_probe(struct platform_device *pdev)
 
 	lp->phy_node = of_parse_phandle(pdev->dev.of_node, "phy-handle", 0);
 	if (lp->phy_node) {
-		ret = axienet_mdio_setup(lp, pdev->dev.of_node);
+		/* Defaults to 0 if not present */
+		of_property_read_u32(pdev->dev.of_node,
+				     "xlnx,mdio-clock-divisor",
+				     &lp->mdio_clock_divisor);
+
+		ret = axienet_mdio_setup(lp);
 		if (ret)
-			dev_warn(&pdev->dev, "error registering MDIO bus\n");
+			dev_warn(&pdev->dev,
+				 "error registering MDIO bus: %d\n", ret);
 	}
 
 	ret = register_netdev(lp->ndev);
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
index 665ae1d..0bba9bb 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
@@ -114,7 +114,6 @@ static int axienet_mdio_write(struct mii_bus *bus, int phy_id, int reg,
 /**
  * axienet_mdio_setup - MDIO setup function
  * @lp:		Pointer to axienet local data structure.
- * @np:		Pointer to device node
  *
  * Return:	0 on success, -ETIMEDOUT on a timeout, -ENOMEM when
  *		mdiobus_alloc (to allocate memory for mii bus structure) fails.
@@ -122,71 +121,75 @@ static int axienet_mdio_write(struct mii_bus *bus, int phy_id, int reg,
  * Sets up the MDIO interface by initializing the MDIO clock and enabling the
  * MDIO interface in hardware. Register the MDIO interface.
  **/
-int axienet_mdio_setup(struct axienet_local *lp, struct device_node *np)
+int axienet_mdio_setup(struct axienet_local *lp)
 {
+	u32 clk_div = lp->mdio_clock_divisor;
 	int ret;
-	u32 clk_div, host_clock;
 	struct mii_bus *bus;
 	struct device_node *mdio_node;
-	struct device_node *np1;
-
-	/* clk_div can be calculated by deriving it from the equation:
-	 * fMDIO = fHOST / ((1 + clk_div) * 2)
-	 *
-	 * Where fMDIO <= 2500000, so we get:
-	 * fHOST / ((1 + clk_div) * 2) <= 2500000
-	 *
-	 * Then we get:
-	 * 1 / ((1 + clk_div) * 2) <= (2500000 / fHOST)
-	 *
-	 * Then we get:
-	 * 1 / (1 + clk_div) <= ((2500000 * 2) / fHOST)
-	 *
-	 * Then we get:
-	 * 1 / (1 + clk_div) <= (5000000 / fHOST)
-	 *
-	 * So:
-	 * (1 + clk_div) >= (fHOST / 5000000)
-	 *
-	 * And finally:
-	 * clk_div >= (fHOST / 5000000) - 1
-	 *
-	 * fHOST can be read from the flattened device tree as property
-	 * "clock-frequency" from the CPU
-	 */
-
-	np1 = of_find_node_by_name(NULL, "cpu");
-	if (!np1) {
-		netdev_warn(lp->ndev, "Could not find CPU device node.\n");
-		netdev_warn(lp->ndev,
-			    "Setting MDIO clock divisor to default %d\n",
-			    DEFAULT_CLOCK_DIVISOR);
-		clk_div = DEFAULT_CLOCK_DIVISOR;
-		goto issue;
-	}
-	if (of_property_read_u32(np1, "clock-frequency", &host_clock)) {
-		netdev_warn(lp->ndev, "clock-frequency property not found.\n");
-		netdev_warn(lp->ndev,
-			    "Setting MDIO clock divisor to default %d\n",
-			    DEFAULT_CLOCK_DIVISOR);
-		clk_div = DEFAULT_CLOCK_DIVISOR;
-		of_node_put(np1);
-		goto issue;
-	}
 
-	clk_div = (host_clock / (MAX_MDIO_FREQ * 2)) - 1;
-	/* If there is any remainder from the division of
-	 * fHOST / (MAX_MDIO_FREQ * 2), then we need to add
-	 * 1 to the clock divisor or we will surely be above 2.5 MHz
-	 */
-	if (host_clock % (MAX_MDIO_FREQ * 2))
-		clk_div++;
+	if (!clk_div) {
+		u32 clk_div, host_clock;
+		struct device_node *np1;
+
+		/* clk_div can be calculated by deriving it from the equation:
+		 * fMDIO = fHOST / ((1 + clk_div) * 2)
+		 *
+		 * Where fMDIO <= 2500000, so we get:
+		 * fHOST / ((1 + clk_div) * 2) <= 2500000
+		 *
+		 * Then we get:
+		 * 1 / ((1 + clk_div) * 2) <= (2500000 / fHOST)
+		 *
+		 * Then we get:
+		 * 1 / (1 + clk_div) <= ((2500000 * 2) / fHOST)
+		 *
+		 * Then we get:
+		 * 1 / (1 + clk_div) <= (5000000 / fHOST)
+		 *
+		 * So:
+		 * (1 + clk_div) >= (fHOST / 5000000)
+		 *
+		 * And finally:
+		 * clk_div >= (fHOST / 5000000) - 1
+		 *
+		 * fHOST can be read from the flattened device tree as property
+		 * "clock-frequency" from the CPU
+		 */
+
+		np1 = of_find_node_by_name(NULL, "cpu");
+		if (!np1) {
+			netdev_warn(lp->ndev, "Could not find CPU device node.\n");
+			netdev_warn(lp->ndev,
+				    "Setting MDIO clock divisor to default %d\n",
+				    DEFAULT_CLOCK_DIVISOR);
+			clk_div = DEFAULT_CLOCK_DIVISOR;
+			goto issue;
+		}
+		if (of_property_read_u32(np1, "clock-frequency", &host_clock)) {
+			netdev_warn(lp->ndev, "clock-frequency property not found.\n");
+			netdev_warn(lp->ndev,
+				    "Setting MDIO clock divisor to default %d\n",
+				    DEFAULT_CLOCK_DIVISOR);
+			clk_div = DEFAULT_CLOCK_DIVISOR;
+			of_node_put(np1);
+			goto issue;
+		}
+
+		clk_div = (host_clock / (MAX_MDIO_FREQ * 2)) - 1;
+		/* If there is any remainder from the division of
+		 * fHOST / (MAX_MDIO_FREQ * 2), then we need to add
+		 * 1 to the clock divisor or we will surely be above 2.5 MHz
+		 */
+		if (host_clock % (MAX_MDIO_FREQ * 2))
+			clk_div++;
+
+		netdev_dbg(lp->ndev,
+			   "Setting MDIO clock divisor to %u/%u Hz host clock.\n",
+			   clk_div, host_clock);
 
-	netdev_dbg(lp->ndev,
-		   "Setting MDIO clock divisor to %u/%u Hz host clock.\n",
-		   clk_div, host_clock);
-
-	of_node_put(np1);
+		of_node_put(np1);
+	}
 issue:
 	axienet_iow(lp, XAE_MDIO_MC_OFFSET,
 		    (((u32) clk_div) | XAE_MDIO_MC_MDIOEN_MASK));
-- 
1.8.3.1

