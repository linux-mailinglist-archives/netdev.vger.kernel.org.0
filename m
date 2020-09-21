Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80BCC272647
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbgIUNrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727441AbgIUNqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 09:46:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49710C0613E3
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 06:46:12 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kKM8v-0003ED-Vb; Mon, 21 Sep 2020 15:46:10 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 20/38] can: pch_can: use generic power management
Date:   Mon, 21 Sep 2020 15:45:39 +0200
Message-Id: <20200921134557.2251383-21-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921134557.2251383-1-mkl@pengutronix.de>
References: <20200921134557.2251383-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vaibhav Gupta <vaibhavgupta40@gmail.com>

Drivers using legacy power management .suspen()/.resume() callbacks have to
manage PCI states and device's PM states themselves. They also need to take
care of standard configuration registers.

Switch to generic power management framework using a single "struct dev_pm_ops"
variable to take the unnecessary load from the driver. This also avoids the
need for the driver to directly call most of the PCI helper functions and
device power state control functions, as through the generic framework PCI Core
takes care of the necessary operations, and drivers are required to do only
device-specific jobs.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
Link: https://lore.kernel.org/r/20200728085757.888620-1-vaibhavgupta40@gmail.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/pch_can.c | 63 +++++++++++++--------------------------
 1 file changed, 21 insertions(+), 42 deletions(-)

diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index af4fbd8f9077..5c180d2f3c3c 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -957,8 +957,7 @@ static void pch_can_remove(struct pci_dev *pdev)
 	free_candev(priv->ndev);
 }
 
-#ifdef CONFIG_PM
-static void pch_can_set_int_custom(struct pch_can_priv *priv)
+static void __maybe_unused pch_can_set_int_custom(struct pch_can_priv *priv)
 {
 	/* Clearing the IE, SIE and EIE bits of Can control register. */
 	pch_can_bit_clear(&priv->regs->cont, PCH_CTRL_IE_SIE_EIE);
@@ -969,14 +968,14 @@ static void pch_can_set_int_custom(struct pch_can_priv *priv)
 }
 
 /* This function retrieves interrupt enabled for the CAN device. */
-static u32 pch_can_get_int_enables(struct pch_can_priv *priv)
+static u32 __maybe_unused pch_can_get_int_enables(struct pch_can_priv *priv)
 {
 	/* Obtaining the status of IE, SIE and EIE interrupt bits. */
 	return (ioread32(&priv->regs->cont) & PCH_CTRL_IE_SIE_EIE) >> 1;
 }
 
-static u32 pch_can_get_rxtx_ir(struct pch_can_priv *priv, u32 buff_num,
-			       enum pch_ifreg dir)
+static u32 __maybe_unused pch_can_get_rxtx_ir(struct pch_can_priv *priv,
+					      u32 buff_num, enum pch_ifreg dir)
 {
 	u32 ie, enable;
 
@@ -997,8 +996,8 @@ static u32 pch_can_get_rxtx_ir(struct pch_can_priv *priv, u32 buff_num,
 	return enable;
 }
 
-static void pch_can_set_rx_buffer_link(struct pch_can_priv *priv,
-				       u32 buffer_num, int set)
+static void __maybe_unused pch_can_set_rx_buffer_link(struct pch_can_priv *priv,
+						      u32 buffer_num, int set)
 {
 	iowrite32(PCH_CMASK_RX_TX_GET, &priv->regs->ifregs[0].cmask);
 	pch_can_rw_msg_obj(&priv->regs->ifregs[0].creq, buffer_num);
@@ -1013,7 +1012,8 @@ static void pch_can_set_rx_buffer_link(struct pch_can_priv *priv,
 	pch_can_rw_msg_obj(&priv->regs->ifregs[0].creq, buffer_num);
 }
 
-static u32 pch_can_get_rx_buffer_link(struct pch_can_priv *priv, u32 buffer_num)
+static u32 __maybe_unused pch_can_get_rx_buffer_link(struct pch_can_priv *priv,
+						     u32 buffer_num)
 {
 	u32 link;
 
@@ -1027,20 +1027,19 @@ static u32 pch_can_get_rx_buffer_link(struct pch_can_priv *priv, u32 buffer_num)
 	return link;
 }
 
-static int pch_can_get_buffer_status(struct pch_can_priv *priv)
+static int __maybe_unused pch_can_get_buffer_status(struct pch_can_priv *priv)
 {
 	return (ioread32(&priv->regs->treq1) & 0xffff) |
 	       (ioread32(&priv->regs->treq2) << 16);
 }
 
-static int pch_can_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused pch_can_suspend(struct device *dev_d)
 {
 	int i;
-	int retval;
 	u32 buf_stat;	/* Variable for reading the transmit buffer status. */
 	int counter = PCH_COUNTER_LIMIT;
 
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 	struct pch_can_priv *priv = netdev_priv(dev);
 
 	/* Stop the CAN controller */
@@ -1058,7 +1057,7 @@ static int pch_can_suspend(struct pci_dev *pdev, pm_message_t state)
 		udelay(1);
 	}
 	if (!counter)
-		dev_err(&pdev->dev, "%s -> Transmission time out.\n", __func__);
+		dev_err(dev_d, "%s -> Transmission time out.\n", __func__);
 
 	/* Save interrupt configuration and then disable them */
 	priv->int_enables = pch_can_get_int_enables(priv);
@@ -1081,35 +1080,16 @@ static int pch_can_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	/* Disable all Receive buffers */
 	pch_can_set_rx_all(priv, 0);
-	retval = pci_save_state(pdev);
-	if (retval) {
-		dev_err(&pdev->dev, "pci_save_state failed.\n");
-	} else {
-		pci_enable_wake(pdev, PCI_D3hot, 0);
-		pci_disable_device(pdev);
-		pci_set_power_state(pdev, pci_choose_state(pdev, state));
-	}
 
-	return retval;
+	return 0;
 }
 
-static int pch_can_resume(struct pci_dev *pdev)
+static int __maybe_unused pch_can_resume(struct device *dev_d)
 {
 	int i;
-	int retval;
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 	struct pch_can_priv *priv = netdev_priv(dev);
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-	retval = pci_enable_device(pdev);
-	if (retval) {
-		dev_err(&pdev->dev, "pci_enable_device failed.\n");
-		return retval;
-	}
-
-	pci_enable_wake(pdev, PCI_D3hot, 0);
-
 	priv->can.state = CAN_STATE_ERROR_ACTIVE;
 
 	/* Disabling all interrupts. */
@@ -1146,12 +1126,8 @@ static int pch_can_resume(struct pci_dev *pdev)
 	/* Restore Run Mode */
 	pch_can_set_run_mode(priv, PCH_CAN_RUN);
 
-	return retval;
+	return 0;
 }
-#else
-#define pch_can_suspend NULL
-#define pch_can_resume NULL
-#endif
 
 static int pch_can_get_berr_counter(const struct net_device *dev,
 				    struct can_berr_counter *bec)
@@ -1252,13 +1228,16 @@ static int pch_can_probe(struct pci_dev *pdev,
 	return rc;
 }
 
+static SIMPLE_DEV_PM_OPS(pch_can_pm_ops,
+			 pch_can_suspend,
+			 pch_can_resume);
+
 static struct pci_driver pch_can_pci_driver = {
 	.name = "pch_can",
 	.id_table = pch_pci_tbl,
 	.probe = pch_can_probe,
 	.remove = pch_can_remove,
-	.suspend = pch_can_suspend,
-	.resume = pch_can_resume,
+	.driver.pm = &pch_can_pm_ops,
 };
 
 module_pci_driver(pch_can_pci_driver);
-- 
2.28.0

