Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C69456D3D8C
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 08:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbjDCGsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 02:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbjDCGsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 02:48:00 -0400
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860241BC5
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 23:47:57 -0700 (PDT)
X-QQ-mid: bizesmtp63t1680504433tae6ynrg
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 03 Apr 2023 14:47:12 +0800 (CST)
X-QQ-SSF: 01400000000000H0Z000B00A0000000
X-QQ-FEAT: KSpVqVeA+UU2ASOLpqU+n9wCyX8aQcgKbzAIzB5CjsTOjLmXuIduLTk0b9DZN
        m5Z2h+B5/Be65/0ESkVA0UeLZn9H6BTxajaLPS7CQ2G4+QD9YfFdAZQH1H7tiDAsyLDbQuQ
        VgryAjhAzgmEd06e5LNTcWDFhEhIqHvqVflFb/4tGiU6owQ7V540rr/zIAvik15LPOZimOO
        18kwwYefzMx4RehArWkLNu07oODedV+MrF/eeFYlp1kPZph4/MbLYShBd8qQNWFX1nt/uAT
        Z2u0+dIblS5NE4oLqKXqEWFXK/7OXHd9+p1Sq1pY2Gce6cXVeQ3nr5PWoToax8LA9y7egB7
        0CzD/d2E3Qs1bRDSz85d3KAnIgsRG+zUStDoeRWC3T+Tc7BAWjsbp8yJoFcFhG69NkFk2ct
        RYR4M1yiqlQfrhQPZNlvQA==
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 1725779558253379975
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, linux@armlinux.org.uk
Cc:     mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next 4/6] net: txgbe: Support GPIO to SFP socket
Date:   Mon,  3 Apr 2023 14:45:26 +0800
Message-Id: <20230403064528.343866-5-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230403064528.343866-1-jiawenwu@trustnetic.com>
References: <20230403064528.343866-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-0.0 required=5.0 tests=RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Register GPIO chip and handle GPIO IRQ for SFP socket.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/Kconfig          |   2 +
 drivers/net/ethernet/wangxun/libwx/wx_lib.c   |   3 +-
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |   2 +
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c |   1 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  22 +-
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 216 ++++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  26 +++
 7 files changed, 253 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/Kconfig b/drivers/net/ethernet/wangxun/Kconfig
index c5b62918db78..d9cccdad8a53 100644
--- a/drivers/net/ethernet/wangxun/Kconfig
+++ b/drivers/net/ethernet/wangxun/Kconfig
@@ -40,6 +40,8 @@ config NGBE
 config TXGBE
 	tristate "Wangxun(R) 10GbE PCI Express adapters support"
 	depends on PCI
+	select GPIOLIB_IRQCHIP
+	select GPIOLIB
 	select LIBWX
 	select I2C
 	select SFP
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index eb89a274083e..dff0d573ee33 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -1348,7 +1348,8 @@ void wx_free_irq(struct wx *wx)
 		free_irq(entry->vector, q_vector);
 	}
 
-	free_irq(wx->msix_entries[vector].vector, wx);
+	if (wx->mac.type == wx_mac_em)
+		free_irq(wx->msix_entries[vector].vector, wx);
 }
 EXPORT_SYMBOL(wx_free_irq);
 
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index 072aa2bd3fdc..89bba827edf2 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -79,7 +79,9 @@
 #define WX_GPIO_INTMASK              0x14834
 #define WX_GPIO_INTTYPE_LEVEL        0x14838
 #define WX_GPIO_POLARITY             0x1483C
+#define WX_GPIO_INTSTATUS            0x14844
 #define WX_GPIO_EOI                  0x1484C
+#define WX_GPIO_EXT                  0x14850
 
 /*********************** Transmit DMA registers **************************/
 /* transmit global control */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
index ebc46f3be056..b87034e57140 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -256,6 +256,7 @@ int txgbe_validate_eeprom_checksum(struct wx *wx, u16 *checksum_val)
 static void txgbe_reset_misc(struct wx *wx)
 {
 	wx_reset_misc(wx);
+	wr32(wx, WX_GPIO_DDR, 0x32);
 	txgbe_init_thermal_sensor_thresh(wx);
 }
 
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 319d56720c06..caaefc20afb9 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -82,6 +82,10 @@ static int txgbe_enumerate_functions(struct wx *wx)
  **/
 static void txgbe_irq_enable(struct wx *wx, bool queues)
 {
+	wr32(wx, WX_GPIO_INTEN, TXGBE_GPIOBIT_0 | TXGBE_GPIOBIT_2 | TXGBE_GPIOBIT_3);
+	wr32(wx, WX_GPIO_INTTYPE_LEVEL, TXGBE_GPIOBIT_0 | TXGBE_GPIOBIT_2 | TXGBE_GPIOBIT_3);
+	wr32(wx, WX_PX_MISC_IEN, TXGBE_PX_MISC_IEN_MASK);
+
 	/* unmask interrupt */
 	wx_intr_enable(wx, TXGBE_INTR_MISC(wx));
 	if (queues)
@@ -129,17 +133,6 @@ static irqreturn_t txgbe_intr(int __always_unused irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t txgbe_msix_other(int __always_unused irq, void *data)
-{
-	struct wx *wx = data;
-
-	/* re-enable the original interrupt state */
-	if (netif_running(wx->netdev))
-		txgbe_irq_enable(wx, false);
-
-	return IRQ_HANDLED;
-}
-
 /**
  * txgbe_request_msix_irqs - Initialize MSI-X interrupts
  * @wx: board private structure
@@ -171,13 +164,6 @@ static int txgbe_request_msix_irqs(struct wx *wx)
 		}
 	}
 
-	err = request_irq(wx->msix_entries[vector].vector,
-			  txgbe_msix_other, 0, netdev->name, wx);
-	if (err) {
-		wx_err(wx, "request_irq for msix_other failed: %d\n", err);
-		goto free_queue_irqs;
-	}
-
 	return 0;
 
 free_queue_irqs:
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
index dac9dfd001f0..fe51485a9b68 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
@@ -2,6 +2,9 @@
 /* Copyright (c) 2015 - 2023 Beijing WangXun Technology Co., Ltd. */
 
 #include <linux/platform_device.h>
+#include <linux/gpio/consumer.h>
+#include <linux/gpio/machine.h>
+#include <linux/gpio/driver.h>
 #include <linux/gpio/property.h>
 #include <linux/iopoll.h>
 #include <linux/i2c.h>
@@ -188,6 +191,213 @@ static int txgbe_i2c_adapter_add(struct txgbe *txgbe)
 	return 0;
 }
 
+static int txgbe_gpio_get(struct gpio_chip *chip, unsigned int offset)
+{
+	struct wx *wx = gpiochip_get_data(chip);
+	int val, dir;
+
+	dir = chip->get_direction(chip, offset);
+	if (dir == GPIO_LINE_DIRECTION_IN)
+		val = rd32m(wx, WX_GPIO_EXT, BIT(offset));
+	else
+		val = rd32m(wx, WX_GPIO_DR, BIT(offset));
+
+	return !!(val & BIT(offset));
+}
+
+static int txgbe_gpio_get_direction(struct gpio_chip *chip, unsigned int offset)
+{
+	struct wx *wx = gpiochip_get_data(chip);
+	u32 val;
+
+	val = rd32(wx, WX_GPIO_DDR);
+	if (BIT(offset) & val)
+		return GPIO_LINE_DIRECTION_OUT;
+
+	return GPIO_LINE_DIRECTION_IN;
+}
+
+static int txgbe_gpio_direction_in(struct gpio_chip *chip, unsigned int offset)
+{
+	return 0;
+}
+
+static int txgbe_gpio_direction_out(struct gpio_chip *chip, unsigned int offset,
+				    int val)
+{
+	struct wx *wx = gpiochip_get_data(chip);
+	u32 mask;
+	int dir;
+
+	dir = chip->get_direction(chip, offset);
+	if (dir == GPIO_LINE_DIRECTION_IN)
+		return 0;
+
+	mask = BIT(offset) | BIT(offset - 1);
+	if (val)
+		wr32m(wx, WX_GPIO_DR, mask, mask);
+	else
+		wr32m(wx, WX_GPIO_DR, mask, 0);
+
+	return 0;
+}
+
+static void txgbe_gpio_irq_ack(struct irq_data *d)
+{
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	irq_hw_number_t hwirq = irqd_to_hwirq(d);
+	struct wx *wx = gpiochip_get_data(gc);
+
+	wr32(wx, WX_GPIO_EOI, BIT(hwirq));
+}
+
+static void txgbe_gpio_irq_mask(struct irq_data *d)
+{
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	irq_hw_number_t hwirq = irqd_to_hwirq(d);
+	struct wx *wx = gpiochip_get_data(gc);
+
+	gpiochip_disable_irq(gc, hwirq);
+
+	wr32m(wx, WX_GPIO_INTMASK, BIT(hwirq), BIT(hwirq));
+}
+
+static void txgbe_gpio_irq_unmask(struct irq_data *d)
+{
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	irq_hw_number_t hwirq = irqd_to_hwirq(d);
+	struct wx *wx = gpiochip_get_data(gc);
+
+	gpiochip_enable_irq(gc, hwirq);
+
+	wr32m(wx, WX_GPIO_INTMASK, BIT(hwirq), 0);
+}
+
+static int txgbe_gpio_set_type(struct irq_data *d, unsigned int type)
+{
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	irq_hw_number_t hwirq = irqd_to_hwirq(d);
+	struct wx *wx = gpiochip_get_data(gc);
+	u32 level, polarity;
+
+	level = rd32(wx, WX_GPIO_INTTYPE_LEVEL);
+	polarity = rd32(wx, WX_GPIO_POLARITY);
+
+	switch (type) {
+	case IRQ_TYPE_EDGE_BOTH:
+		level |= BIT(hwirq);
+		break;
+	case IRQ_TYPE_EDGE_RISING:
+		level |= BIT(hwirq);
+		polarity |= BIT(hwirq);
+		break;
+	case IRQ_TYPE_EDGE_FALLING:
+		level |= BIT(hwirq);
+		polarity &= ~BIT(hwirq);
+		break;
+	case IRQ_TYPE_LEVEL_HIGH:
+		level &= ~BIT(hwirq);
+		polarity |= BIT(hwirq);
+		break;
+	case IRQ_TYPE_LEVEL_LOW:
+		level &= ~BIT(hwirq);
+		polarity &= ~BIT(hwirq);
+		break;
+	}
+
+	if (type & IRQ_TYPE_LEVEL_MASK)
+		irq_set_handler_locked(d, handle_level_irq);
+	else if (type & IRQ_TYPE_EDGE_BOTH)
+		irq_set_handler_locked(d, handle_edge_irq);
+
+	wr32(wx, WX_GPIO_INTTYPE_LEVEL, level);
+	if (type != IRQ_TYPE_EDGE_BOTH)
+		wr32(wx, WX_GPIO_POLARITY, polarity);
+
+	return 0;
+}
+
+static const struct irq_chip txgbe_gpio_irq_chip = {
+	.name = "txgbe_gpio_irq",
+	.irq_ack = txgbe_gpio_irq_ack,
+	.irq_mask = txgbe_gpio_irq_mask,
+	.irq_unmask = txgbe_gpio_irq_unmask,
+	.irq_set_type = txgbe_gpio_set_type,
+	.flags = IRQCHIP_IMMUTABLE,
+	GPIOCHIP_IRQ_RESOURCE_HELPERS,
+};
+
+static void txgbe_irq_handler(struct irq_desc *desc)
+{
+	struct irq_chip *chip = irq_desc_get_chip(desc);
+	struct wx *wx = irq_desc_get_handler_data(desc);
+	struct txgbe *txgbe = (struct txgbe *)wx->priv;
+	struct gpio_chip *gc = txgbe->gpio;
+	irq_hw_number_t hwirq;
+	unsigned long val;
+
+	chained_irq_enter(chip, desc);
+
+	val = rd32(wx, WX_GPIO_INTSTATUS);
+	for_each_set_bit(hwirq, &val, gc->ngpio)
+		generic_handle_domain_irq(gc->irq.domain, hwirq);
+
+	chained_irq_exit(chip, desc);
+
+	/* unmask interrupt */
+	if (netif_running(wx->netdev))
+		wx_intr_enable(wx, TXGBE_INTR_MISC(wx));
+}
+
+static int txgbe_gpio_init(struct txgbe *txgbe)
+{
+	struct gpio_irq_chip *girq;
+	struct wx *wx = txgbe->wx;
+	struct pci_dev *pdev;
+	struct gpio_chip *gc;
+	int ret;
+
+	pdev = wx->pdev;
+
+	gc = devm_kzalloc(&pdev->dev, sizeof(*gc), GFP_KERNEL);
+	if (!gc)
+		return -ENOMEM;
+
+	gc->label = devm_kasprintf(&pdev->dev, GFP_KERNEL, "txgbe_gpio-%x",
+				   (pdev->bus->number << 8) | pdev->devfn);
+	gc->base = -1;
+	gc->ngpio = 6;
+	gc->owner = THIS_MODULE;
+	gc->parent = &pdev->dev;
+	gc->fwnode = software_node_fwnode(txgbe->nodes.group[SWNODE_GPIO]);
+	gc->get = txgbe_gpio_get;
+	gc->get_direction = txgbe_gpio_get_direction;
+	gc->direction_input = txgbe_gpio_direction_in;
+	gc->direction_output = txgbe_gpio_direction_out;
+	gc->can_sleep = false;
+
+	girq = &gc->irq;
+	gpio_irq_chip_set_chip(girq, &txgbe_gpio_irq_chip);
+	girq->parent_handler = txgbe_irq_handler;
+	girq->parent_handler_data = wx;
+	girq->num_parents = 1;
+	girq->parents = devm_kcalloc(&pdev->dev, 1, sizeof(*girq->parents),
+				     GFP_KERNEL);
+	if (!girq->parents)
+		return -ENOMEM;
+	girq->parents[0] = wx->msix_entries[wx->num_q_vectors].vector;
+	girq->default_type = IRQ_TYPE_NONE;
+	girq->handler = handle_bad_irq;
+
+	ret = devm_gpiochip_add_data(&pdev->dev, gc, wx);
+	if (ret)
+		return ret;
+
+	txgbe->gpio = gc;
+
+	return 0;
+}
+
 static int txgbe_sfp_register(struct txgbe *txgbe)
 {
 	struct pci_dev *pdev = txgbe->wx->pdev;
@@ -224,6 +434,12 @@ int txgbe_init_phy(struct txgbe *txgbe)
 		goto err;
 	}
 
+	ret = txgbe_gpio_init(txgbe);
+	if (ret) {
+		wx_err(txgbe->wx, "failed to init gpio\n");
+		goto err;
+	}
+
 	ret = txgbe_sfp_register(txgbe);
 	if (ret) {
 		wx_err(txgbe->wx, "failed to register sfp\n");
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 75a4e7b8cc51..ea2b39252edf 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -55,6 +55,31 @@
 #define TXGBE_TS_CTL                            0x10300
 #define TXGBE_TS_CTL_EVAL_MD                    BIT(31)
 
+/* GPIO register bit */
+#define TXGBE_GPIOBIT_0                         BIT(0) /* I:tx fault */
+#define TXGBE_GPIOBIT_1                         BIT(1) /* O:tx disabled */
+#define TXGBE_GPIOBIT_2                         BIT(2) /* I:sfp module absent */
+#define TXGBE_GPIOBIT_3                         BIT(3) /* I:rx signal lost */
+#define TXGBE_GPIOBIT_4                         BIT(4) /* O:rate select, 1G(0) 10G(1) */
+#define TXGBE_GPIOBIT_5                         BIT(5) /* O:rate select, 1G(0) 10G(1) */
+
+/* Extended Interrupt Enable Set */
+#define TXGBE_PX_MISC_ETH_LKDN                  BIT(8)
+#define TXGBE_PX_MISC_DEV_RST                   BIT(10)
+#define TXGBE_PX_MISC_ETH_EVENT                 BIT(17)
+#define TXGBE_PX_MISC_ETH_LK                    BIT(18)
+#define TXGBE_PX_MISC_ETH_AN                    BIT(19)
+#define TXGBE_PX_MISC_INT_ERR                   BIT(20)
+#define TXGBE_PX_MISC_GPIO                      BIT(26)
+#define TXGBE_PX_MISC_IEN_MASK ( \
+				TXGBE_PX_MISC_ETH_LKDN | \
+				TXGBE_PX_MISC_DEV_RST | \
+				TXGBE_PX_MISC_ETH_EVENT | \
+				TXGBE_PX_MISC_ETH_LK | \
+				TXGBE_PX_MISC_ETH_AN | \
+				TXGBE_PX_MISC_INT_ERR | \
+				TXGBE_PX_MISC_GPIO)
+
 /* I2C registers */
 #define TXGBE_I2C_CON                           0x14900 /* I2C Control */
 #define TXGBE_I2C_CON_SLAVE_DISABLE             BIT(6)
@@ -165,6 +190,7 @@ struct txgbe {
 	struct wx *wx;
 	struct txgbe_nodes nodes;
 	struct i2c_adapter *i2c_adap;
+	struct gpio_chip *gpio;
 	struct platform_device *sfp_dev;
 };
 
-- 
2.27.0

