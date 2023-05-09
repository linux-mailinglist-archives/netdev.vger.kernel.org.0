Return-Path: <netdev+bounces-1014-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE8746FBD43
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 04:31:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 22944281103
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 02:31:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81FEC17F8;
	Tue,  9 May 2023 02:31:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F655185E
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 02:31:07 +0000 (UTC)
Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3DBDAD17
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 19:31:02 -0700 (PDT)
X-QQ-mid: bizesmtp78t1683599359t1xk1z2k
Received: from wxdbg.localdomain.com ( [125.119.253.217])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 09 May 2023 10:29:18 +0800 (CST)
X-QQ-SSF: 01400000000000I0Z000000A0000000
X-QQ-FEAT: FVl8EHhfVR5OkKGr1ozwWME6ePFFBk31ZoMmbarqX0NwQTrkA/pG07rNi8Tq+
	tFzuTjEBJp5qR8NGoAAJGUDxJP9wvU78TfjaxPr4HUOAv99iGT+V3iSDfO6PiHvWWFWhm+k
	/igkMWhuTyw3jn3XANqdF+F4JD94O1by5+ELS96T7N8UhBlk1Ck009GtKZkPrJa5UMunCvr
	BHiYkRIQ3GKeYifDBBsngqTmW59xvqr0Mltq7Ni2stTAtKKQKvgn4jeQpjpNdFyV7QKrDNl
	cPwmHWc6iepiaCsLV8xVPmtK9tQVTHunpu1f+LyeMB+LZ53IxAYcQDRXzijVDQzyqtsY499
	L4umJQ5/sVzLtNYYgYOAqcwUuqR1rf4TRXO5MSIQSMB+p4qC+uk2lhpIvg6uUzCsUSq7BKJ
	qkm8JZiH7ml+SdbSs6FLUg==
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 14086836103078290225
From: Jiawen Wu <jiawenwu@trustnetic.com>
To: netdev@vger.kernel.org,
	jarkko.nikula@linux.intel.com,
	andriy.shevchenko@linux.intel.com,
	mika.westerberg@linux.intel.com,
	jsd@semihalf.com,
	Jose.Abreu@synopsys.com,
	andrew@lunn.ch,
	hkallweit1@gmail.com,
	linux@armlinux.org.uk
Cc: linux-i2c@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	mengyuanlou@net-swift.com,
	Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v7 6/9] net: txgbe: Support GPIO to SFP socket
Date: Tue,  9 May 2023 10:27:31 +0800
Message-Id: <20230509022734.148970-7-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230509022734.148970-1-jiawenwu@trustnetic.com>
References: <20230509022734.148970-1-jiawenwu@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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
index 90812d76181d..73f4492928c0 100644
--- a/drivers/net/ethernet/wangxun/Kconfig
+++ b/drivers/net/ethernet/wangxun/Kconfig
@@ -41,6 +41,8 @@ config TXGBE
 	tristate "Wangxun(R) 10GbE PCI Express adapters support"
 	depends on PCI
 	select I2C_DESIGNWARE_PLATFORM
+	select GPIOLIB_IRQCHIP
+	select GPIOLIB
 	select REGMAP
 	select COMMON_CLK
 	select LIBWX
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index 1e8d8b7b0c62..590215303d45 100644
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
index e10296abf5b4..ded04e9e136f 100644
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
index 23fa7311db45..8085616a9146 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
@@ -2,6 +2,9 @@
 /* Copyright (c) 2015 - 2023 Beijing WangXun Technology Co., Ltd. */
 
 #include <linux/platform_device.h>
+#include <linux/gpio/consumer.h>
+#include <linux/gpio/machine.h>
+#include <linux/gpio/driver.h>
 #include <linux/gpio/property.h>
 #include <linux/regmap.h>
 #include <linux/clkdev.h>
@@ -10,6 +13,7 @@
 #include <linux/pci.h>
 
 #include "../libwx/wx_type.h"
+#include "../libwx/wx_hw.h"
 #include "txgbe_type.h"
 #include "txgbe_phy.h"
 
@@ -74,6 +78,224 @@ static int txgbe_swnodes_register(struct txgbe *txgbe)
 	return software_node_register_node_group(nodes->group);
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
 static int txgbe_clock_register(struct txgbe *txgbe)
 {
 	struct pci_dev *pdev = txgbe->wx->pdev;
@@ -188,6 +410,12 @@ int txgbe_init_phy(struct txgbe *txgbe)
 		return ret;
 	}
 
+	ret = txgbe_gpio_init(txgbe);
+	if (ret) {
+		wx_err(txgbe->wx, "failed to init gpio\n");
+		goto err_unregister_swnode;
+	}
+
 	ret = txgbe_clock_register(txgbe);
 	if (ret) {
 		wx_err(txgbe->wx, "failed to register clock: %d\n", ret);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index fc91e0fc37a6..796f33fe3016 100644
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
 
@@ -153,6 +178,8 @@ struct txgbe {
 	struct platform_device *i2c_dev;
 	struct clk_lookup *clock;
 	struct clk *clk;
+	struct gpio_chip *gpio;
+	u32 gpio_orig;
 };
 
 #endif /* _TXGBE_TYPE_H_ */
-- 
2.27.0


