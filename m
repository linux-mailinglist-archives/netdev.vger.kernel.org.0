Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9756E751A
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 10:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbjDSI3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 04:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbjDSI3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 04:29:20 -0400
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C823A24C;
        Wed, 19 Apr 2023 01:29:10 -0700 (PDT)
X-QQ-mid: bizesmtp68t1681892944tg1q93ud
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 19 Apr 2023 16:29:04 +0800 (CST)
X-QQ-SSF: 01400000000000I0Z000000A0000000
X-QQ-FEAT: +oIWmpEafD9LSLNN/kRmHY+UeeIsJHMpa+yBkuIXdeUK69D8leqBv24EfDBPk
        lSR/57bLHrQIMHxhBgTKpQIdWxiwTbWWBDHQR3EGbC8iCy1+I8vlvB6fqxZb0BSnnnrFP2j
        XQMtxXK5Av/fSU0S0pdM6xJoMaOzVn0I6h+/c6OCIHOeKMGRn6WjFmA3ZjWPhaQYF7ALkQ6
        1C76TDFvhbdKs637eeOOSVtQrpGzWhC78RvwpzPAWvSUy73lWDNKsz7Nail4t1d54zg71zU
        s9oc1do8/VudrXBjznZm4+/tIHajl5fYVKAQMzOKX3YvkIMElB8IcEsNMlUB6hx7JpoUMtc
        pYNsVPBVoZbg0cAhAJ0bAjr5l6nOP1Oj3tJRLLP3EYXeNrBvoo7/6Pgs6ZtqQrfoS7NOHJI
        q8wNDpmFhKM1eaJ02AUn4w==
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 6117726056375978320
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, linux@armlinux.org.uk
Cc:     linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        olteanv@gmail.com, mengyuanlou@net-swift.com,
        Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v3 5/8] net: txgbe: Support GPIO to SFP socket
Date:   Wed, 19 Apr 2023 16:27:36 +0800
Message-Id: <20230419082739.295180-6-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230419082739.295180-1-jiawenwu@trustnetic.com>
References: <20230419082739.295180-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  20 +-
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 228 ++++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  27 +++
 6 files changed, 263 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/Kconfig b/drivers/net/ethernet/wangxun/Kconfig
index d2dbaf19e53d..9b69c3d53d65 100644
--- a/drivers/net/ethernet/wangxun/Kconfig
+++ b/drivers/net/ethernet/wangxun/Kconfig
@@ -41,6 +41,8 @@ config TXGBE
 	tristate "Wangxun(R) 10GbE PCI Express adapters support"
 	depends on PCI
 	select I2C_DESIGNWARE_PLATFORM
+	select GPIOLIB_IRQCHIP
+	select GPIOLIB
 	select LIBWX
 	select SFP
 	help
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
index 97bce855bc60..d151d6f79022 100644
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
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index dbd4d409d93b..b1ede19f4ff8 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -82,6 +82,8 @@ static int txgbe_enumerate_functions(struct wx *wx)
  **/
 static void txgbe_irq_enable(struct wx *wx, bool queues)
 {
+	wr32(wx, WX_PX_MISC_IEN, TXGBE_PX_MISC_IEN_MASK);
+
 	/* unmask interrupt */
 	wx_intr_enable(wx, TXGBE_INTR_MISC(wx));
 	if (queues)
@@ -129,17 +131,6 @@ static irqreturn_t txgbe_intr(int __always_unused irq, void *data)
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
@@ -171,13 +162,6 @@ static int txgbe_request_msix_irqs(struct wx *wx)
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
index faa0479f1df3..d98d283dd0db 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
@@ -3,11 +3,15 @@
 
 #include <linux/platform_data/i2c-dw.h>
 #include <linux/platform_device.h>
+#include <linux/gpio/consumer.h>
+#include <linux/gpio/machine.h>
+#include <linux/gpio/driver.h>
 #include <linux/gpio/property.h>
 #include <linux/i2c.h>
 #include <linux/pci.h>
 
 #include "../libwx/wx_type.h"
+#include "../libwx/wx_hw.h"
 #include "txgbe_type.h"
 #include "txgbe_phy.h"
 
@@ -105,6 +109,224 @@ static int txgbe_i2c_register(struct txgbe *txgbe)
 	return 0;
 }
 
+static int txgbe_gpio_get(struct gpio_chip *chip, unsigned int offset)
+{
+	struct wx *wx = gpiochip_get_data(chip);
+	struct txgbe *txgbe = wx->priv;
+	int val;
+
+	val = rd32m(wx, WX_GPIO_EXT, BIT(offset));
+
+	txgbe->gpio_orig &= ~BIT(offset);
+	txgbe->gpio_orig |= val;
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
+	struct wx *wx = gpiochip_get_data(chip);
+
+	wr32m(wx, WX_GPIO_DDR, BIT(offset), 0);
+
+	return 0;
+}
+
+static int txgbe_gpio_direction_out(struct gpio_chip *chip, unsigned int offset,
+				    int val)
+{
+	struct wx *wx = gpiochip_get_data(chip);
+	u32 mask;
+
+	mask = BIT(offset) | BIT(offset - 1);
+	if (val)
+		wr32m(wx, WX_GPIO_DR, mask, mask);
+	else
+		wr32m(wx, WX_GPIO_DR, mask, 0);
+
+	wr32m(wx, WX_GPIO_DDR, BIT(offset), BIT(offset));
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
+	wr32m(wx, WX_GPIO_INTEN, BIT(hwirq), BIT(hwirq));
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
+	struct txgbe *txgbe = wx->priv;
+	irq_hw_number_t hwirq;
+	unsigned long gpioirq;
+	struct gpio_chip *gc;
+	u32 gpio;
+
+	chained_irq_enter(chip, desc);
+
+	gpioirq = rd32(wx, WX_GPIO_INTSTATUS);
+
+	/* workaround for hysteretic gpio interrupts */
+	gpio = rd32(wx, WX_GPIO_EXT);
+	if (!gpioirq)
+		gpioirq = txgbe->gpio_orig ^ gpio;
+
+	gc = txgbe->gpio;
+	for_each_set_bit(hwirq, &gpioirq, gc->ngpio)
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
+	txgbe->gpio_orig = 0;
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
@@ -140,6 +362,12 @@ int txgbe_init_phy(struct txgbe *txgbe)
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
index aa94c4fce311..334803e6a5de 100644
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
 #define TXGBE_I2C_BASE                          0x14900
 
@@ -151,6 +176,8 @@ struct txgbe {
 	struct txgbe_nodes nodes;
 	struct platform_device *sfp_dev;
 	struct platform_device *i2c_dev;
+	struct gpio_chip *gpio;
+	u32 gpio_orig;
 };
 
 #endif /* _TXGBE_TYPE_H_ */
-- 
2.27.0

