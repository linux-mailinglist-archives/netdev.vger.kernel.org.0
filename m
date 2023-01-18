Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 210EF671524
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 08:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjARHia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 02:38:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbjARHiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 02:38:04 -0500
Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF47E193DE
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 22:58:40 -0800 (PST)
X-QQ-mid: bizesmtp80t1674025115t8vbaaf9
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 18 Jan 2023 14:58:34 +0800 (CST)
X-QQ-SSF: 01400000002000H0X000B00A0000000
X-QQ-FEAT: bhet8yMU7vkWPzPxbB/SQQ4P9Ln19wF2vqBTYPQn167R5gIFR71VAX1G3dlyj
        Ku3czAfwD6frxYJu/e7W4wEi8cd5JqKX8r5z05dK0tTG33f+3YKuWoXfNUaWokCDvj5Ljrj
        pTGm9I64gciva6/ZQD3T2nxulXeZKwvbH8g5fD2tuy7I9vskS8m40TCxgQ2UrSnUXhucbID
        Dj0pnOKN+apkQ2ok85HE9uAuLcjNsYzNDcg3WlFGoe93H4d9GiCDkCQj31/+/meLdrw7dDS
        PBmkKXkd3Q2eU41yf/QgicvB6rrLCGmIlwoy6ML5HUrOG/O9c7PimtAD/pi6+bUeZxUuE+1
        HWoOnf3GMcNqlQ7js8chV8fsmGGm/WJZ5TRsCDaJMtojLf4StZ/NTI8xfB58ucKi/jzMihd
        OnY10ytPy11qKw4WljUGdA==
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Subject: [PATCH net-next 02/10] net: ngbe: Add irqs request flow
Date:   Wed, 18 Jan 2023 14:54:56 +0800
Message-Id: <20230118065504.3075474-3-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230118065504.3075474-1-jiawenwu@trustnetic.com>
References: <20230118065504.3075474-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mengyuan Lou <mengyuanlou@net-swift.com>

Add request_irq for tx/rx rings and misc other events.
If the application is successful, config vertors for interrupts.
Enable some base interrupts mask in ngbe_irq_enable.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c | 189 +++++++++++++++++-
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |  14 ++
 2 files changed, 202 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index ed52f80b5475..a9772f929274 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -13,6 +13,7 @@
 
 #include "../libwx/wx_type.h"
 #include "../libwx/wx_hw.h"
+#include "../libwx/wx_lib.h"
 #include "ngbe_type.h"
 #include "ngbe_mdio.h"
 #include "ngbe_hw.h"
@@ -148,6 +149,161 @@ static int ngbe_sw_init(struct wx *wx)
 	return 0;
 }
 
+/**
+ * ngbe_irq_enable - Enable default interrupt generation settings
+ * @wx: board private structure
+ * @queues: enable all queues interrupts
+ **/
+static void ngbe_irq_enable(struct wx *wx, bool queues)
+{
+	u32 mask;
+
+	/* enable misc interrupt */
+	mask = NGBE_PX_MISC_IEN_MASK;
+
+	wr32(wx, WX_GPIO_DDR, WX_GPIO_DDR_0);
+	wr32(wx, WX_GPIO_INTEN, WX_GPIO_INTEN_0 | WX_GPIO_INTEN_1);
+	wr32(wx, WX_GPIO_INTTYPE_LEVEL, 0x0);
+	wr32(wx, WX_GPIO_POLARITY, wx->gpio_ctrl ? 0 : 0x3);
+
+	wr32(wx, WX_PX_MISC_IEN, mask);
+
+	/* mask interrupt */
+	if (queues)
+		wx_intr_enable(wx, NGBE_INTR_ALL);
+	else
+		wx_intr_enable(wx, NGBE_INTR_MISC(wx));
+}
+
+/**
+ * ngbe_intr - msi/legacy mode Interrupt Handler
+ * @irq: interrupt number
+ * @data: pointer to a network interface device structure
+ **/
+static irqreturn_t ngbe_intr(int __always_unused irq, void *data)
+{
+	struct wx_q_vector *q_vector;
+	struct wx *wx  = data;
+	struct pci_dev *pdev;
+	u32 eicr;
+
+	q_vector = wx->q_vector[0];
+	pdev = wx->pdev;
+
+	eicr = wx_misc_isb(wx, WX_ISB_VEC0);
+	if (!eicr) {
+		/* shared interrupt alert!
+		 * the interrupt that we masked before the EICR read.
+		 */
+		if (netif_running(wx->netdev))
+			ngbe_irq_enable(wx, true);
+		return IRQ_NONE;        /* Not our interrupt */
+	}
+	wx->isb_mem[WX_ISB_VEC0] = 0;
+	if (!(pdev->msi_enabled))
+		wr32(wx, WX_PX_INTA, 1);
+
+	wx->isb_mem[WX_ISB_MISC] = 0;
+	/* would disable interrupts here but it is auto disabled */
+	napi_schedule_irqoff(&q_vector->napi);
+
+	if (netif_running(wx->netdev))
+		ngbe_irq_enable(wx, false);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t ngbe_msix_other(int __always_unused irq, void *data)
+{
+	struct wx *wx = data;
+
+	/* re-enable the original interrupt state, no lsc, no queues */
+	if (netif_running(wx->netdev))
+		ngbe_irq_enable(wx, false);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * ngbe_request_msix_irqs - Initialize MSI-X interrupts
+ * @wx: board private structure
+ *
+ * ngbe_request_msix_irqs allocates MSI-X vectors and requests
+ * interrupts from the kernel.
+ **/
+static int ngbe_request_msix_irqs(struct wx *wx)
+{
+	struct net_device *netdev = wx->netdev;
+	int vector, err;
+
+	for (vector = 0; vector < wx->num_q_vectors; vector++) {
+		struct wx_q_vector *q_vector = wx->q_vector[vector];
+		struct msix_entry *entry = &wx->msix_entries[vector];
+
+		if (q_vector->tx.ring && q_vector->rx.ring)
+			snprintf(q_vector->name, sizeof(q_vector->name) - 1,
+				 "%s-TxRx-%d", netdev->name, entry->entry);
+		else
+			/* skip this unused q_vector */
+			continue;
+
+		err = request_irq(entry->vector, wx_msix_clean_rings, 0,
+				  q_vector->name, q_vector);
+		if (err) {
+			wx_err(wx, "request_irq failed for MSIX interrupt %s Error: %d\n",
+			       q_vector->name, err);
+			goto free_queue_irqs;
+		}
+	}
+
+	err = request_irq(wx->msix_entries[vector].vector,
+			  ngbe_msix_other, 0, netdev->name, wx);
+
+	if (err) {
+		wx_err(wx, "request_irq for msix_other failed: %d\n", err);
+		goto free_queue_irqs;
+	}
+
+	return 0;
+
+free_queue_irqs:
+	while (vector) {
+		vector--;
+		free_irq(wx->msix_entries[vector].vector,
+			 wx->q_vector[vector]);
+	}
+	wx_reset_interrupt_capability(wx);
+	return err;
+}
+
+/**
+ * ngbe_request_irq - initialize interrupts
+ * @wx: board private structure
+ *
+ * Attempts to configure interrupts using the best available
+ * capabilities of the hardware and kernel.
+ **/
+static int ngbe_request_irq(struct wx *wx)
+{
+	struct net_device *netdev = wx->netdev;
+	struct pci_dev *pdev = wx->pdev;
+	int err;
+
+	if (pdev->msix_enabled)
+		err = ngbe_request_msix_irqs(wx);
+	else if (pdev->msi_enabled)
+		err = request_irq(pdev->irq, ngbe_intr, 0,
+				  netdev->name, wx);
+	else
+		err = request_irq(pdev->irq, ngbe_intr, IRQF_SHARED,
+				  netdev->name, wx);
+
+	if (err)
+		wx_err(wx, "request_irq failed, Error %d\n", err);
+
+	return err;
+}
+
 static void ngbe_disable_device(struct wx *wx)
 {
 	struct net_device *netdev = wx->netdev;
@@ -157,6 +313,7 @@ static void ngbe_disable_device(struct wx *wx)
 	netif_tx_disable(netdev);
 	if (wx->gpio_ctrl)
 		ngbe_sfp_modules_txrx_powerctl(wx, false);
+	wx_irq_disable(wx);
 }
 
 static void ngbe_down(struct wx *wx)
@@ -167,8 +324,15 @@ static void ngbe_down(struct wx *wx)
 
 static void ngbe_up(struct wx *wx)
 {
+	wx_configure_vectors(wx);
+
+	/* clear any pending interrupts, may auto mask */
+	rd32(wx, WX_PX_IC);
+	rd32(wx, WX_PX_MISC_IC);
+	ngbe_irq_enable(wx, true);
 	if (wx->gpio_ctrl)
 		ngbe_sfp_modules_txrx_powerctl(wx, true);
+
 	phy_start(wx->phydev);
 }
 
@@ -187,12 +351,26 @@ static int ngbe_open(struct net_device *netdev)
 	int err;
 
 	wx_control_hw(wx, true);
+
+	err = wx_setup_isb_resources(wx);
+	if (err)
+		return err;
+
+	wx_configure(wx);
+
+	err = ngbe_request_irq(wx);
+	if (err)
+		goto err_req_irq;
+
 	err = ngbe_phy_connect(wx);
 	if (err)
 		return err;
 	ngbe_up(wx);
 
 	return 0;
+err_req_irq:
+	wx_free_isb_resources(wx);
+	return err;
 }
 
 /**
@@ -211,6 +389,8 @@ static int ngbe_close(struct net_device *netdev)
 	struct wx *wx = netdev_priv(netdev);
 
 	ngbe_down(wx);
+	wx_free_irq(wx);
+	wx_free_isb_resources(wx);
 	phy_disconnect(wx->phydev);
 	wx_control_hw(wx, false);
 
@@ -411,10 +591,14 @@ static int ngbe_probe(struct pci_dev *pdev,
 	eth_hw_addr_set(netdev, wx->mac.perm_addr);
 	wx_mac_set_default_filter(wx, wx->mac.perm_addr);
 
+	err = wx_init_interrupt_scheme(wx);
+	if (err)
+		goto err_free_mac_table;
+
 	/* phy Interface Configuration */
 	err = ngbe_mdio_init(wx);
 	if (err)
-		goto err_free_mac_table;
+		goto err_clear_interrupt_scheme;
 
 	err = register_netdev(netdev);
 	if (err)
@@ -431,6 +615,8 @@ static int ngbe_probe(struct pci_dev *pdev,
 
 err_register:
 	wx_control_hw(wx, false);
+err_clear_interrupt_scheme:
+	wx_clear_interrupt_scheme(wx);
 err_free_mac_table:
 	kfree(wx->mac_table);
 err_pci_release_regions:
@@ -462,6 +648,7 @@ static void ngbe_remove(struct pci_dev *pdev)
 				     pci_select_bars(pdev, IORESOURCE_MEM));
 
 	kfree(wx->mac_table);
+	wx_clear_interrupt_scheme(wx);
 	pci_disable_pcie_error_reporting(pdev);
 
 	pci_disable_device(pdev);
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
index fd71260f73de..b60f5f0f64fa 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
@@ -90,6 +90,20 @@ enum NGBE_MSCA_CMD_value {
 #define NGBE_GPIO_DDR_0				BIT(0) /* SDP0 IO direction */
 #define NGBE_GPIO_DDR_1				BIT(1) /* SDP1 IO direction */
 
+/* Extended Interrupt Enable Set */
+#define NGBE_PX_MISC_IEN_DEV_RST		BIT(10)
+#define NGBE_PX_MISC_IEN_ETH_LK			BIT(18)
+#define NGBE_PX_MISC_IEN_INT_ERR		BIT(20)
+#define NGBE_PX_MISC_IEN_GPIO			BIT(26)
+#define NGBE_PX_MISC_IEN_MASK ( \
+				NGBE_PX_MISC_IEN_DEV_RST | \
+				NGBE_PX_MISC_IEN_ETH_LK | \
+				NGBE_PX_MISC_IEN_INT_ERR | \
+				NGBE_PX_MISC_IEN_GPIO)
+
+#define NGBE_INTR_ALL				0x1FF
+#define NGBE_INTR_MISC(A)			BIT((A)->num_q_vectors)
+
 #define NGBE_PHY_CONFIG(reg_offset)		(0x14000 + ((reg_offset) * 4))
 #define NGBE_CFG_LAN_SPEED			0x14440
 #define NGBE_CFG_PORT_ST			0x14404
-- 
2.27.0

