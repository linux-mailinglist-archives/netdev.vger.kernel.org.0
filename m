Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A072E6EEF19
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 09:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239995AbjDZHSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 03:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239807AbjDZHSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 03:18:20 -0400
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5B640FF;
        Wed, 26 Apr 2023 00:17:38 -0700 (PDT)
X-QQ-mid: bizesmtp63t1682493367tpn2rkyx
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 26 Apr 2023 15:16:05 +0800 (CST)
X-QQ-SSF: 01400000000000I0Z000000A0000000
X-QQ-FEAT: 0vfWcIgh24z5EFGbD5Mgh0YxBqKzPiIUT71CmvHxv1egX9TaXMJeFjCTNEc6w
        EFJZ9EU73zJzTprAYZwfDWy6QDb0hHJM57R18edVA1mHuv7h9wvUOsreFtwyVRNCeE0z2oN
        9SCu5vQ8bHL+eSVdAk8kFzaES5VHk3h2WlqT+H6AtVnu9TrQUZ0e07uE7DIo7026bZE8eV6
        kQJPDmzvb/sRFdtufJcaMzT8Q777Nza5u+XY2rUR3idzASzB+T77D0psJ8i9nQ4IMK+mTky
        rf54+F5bO5OHYD7Y01uJ/TWIZJYntbps5VFXiauImwoB6KRE1eyUJCYV1LT4d3D9CQEbYu0
        iuydHRfy4buwOiQz8V7pOdNpf66nj8hE84jwTF57loiQfQnQhPKZD7PyVEYU206EWOmOlT6
        AuI72uX1MLQ=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 9258252668174130001
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, jarkko.nikula@linux.intel.com,
        andriy.shevchenko@linux.intel.com, mika.westerberg@linux.intel.com,
        jsd@semihalf.com, ose.Abreu@synopsys.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [RFC PATCH net-next v5 2/9] i2c: designware: Add driver support for Wangxun 10Gb NIC
Date:   Wed, 26 Apr 2023 15:14:27 +0800
Message-Id: <20230426071434.452717-3-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230426071434.452717-1-jiawenwu@trustnetic.com>
References: <20230426071434.452717-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wangxun 10Gb ethernet chip is connected to Designware I2C, to communicate
with SFP.

Introduce the property "i2c-dw-flags" to match device data for software
node case. Since IO resource was mapped on the ethernet driver, add a model
quirk to get resource from platform info.

The exists IP limitations are dealt as workarounds:
- IP does not support interrupt mode, it works on polling mode.
- Additionally set FIFO depth address the chip issue.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/i2c/busses/i2c-designware-common.c  |  8 ++
 drivers/i2c/busses/i2c-designware-core.h    |  1 +
 drivers/i2c/busses/i2c-designware-master.c  | 84 ++++++++++++++++++++-
 drivers/i2c/busses/i2c-designware-platdrv.c | 20 +++++
 4 files changed, 110 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-common.c b/drivers/i2c/busses/i2c-designware-common.c
index 0dc6b1ce663f..a7c2e67ccbf6 100644
--- a/drivers/i2c/busses/i2c-designware-common.c
+++ b/drivers/i2c/busses/i2c-designware-common.c
@@ -575,6 +575,14 @@ int i2c_dw_set_fifo_size(struct dw_i2c_dev *dev)
 	unsigned int param;
 	int ret;
 
+	/* DW_IC_COMP_PARAM_1 not implement for IP issue */
+	if ((dev->flags & MODEL_MASK) == MODEL_WANGXUN_SP) {
+		dev->tx_fifo_depth = 4;
+		dev->rx_fifo_depth = 0;
+
+		return 0;
+	}
+
 	/*
 	 * Try to detect the FIFO depth if not set by interface driver,
 	 * the depth could be from 2 to 256 from HW spec.
diff --git a/drivers/i2c/busses/i2c-designware-core.h b/drivers/i2c/busses/i2c-designware-core.h
index 050d8c63ad3c..c686198e12d2 100644
--- a/drivers/i2c/busses/i2c-designware-core.h
+++ b/drivers/i2c/busses/i2c-designware-core.h
@@ -303,6 +303,7 @@ struct dw_i2c_dev {
 #define MODEL_MSCC_OCELOT			BIT(8)
 #define MODEL_BAIKAL_BT1			BIT(9)
 #define MODEL_AMD_NAVI_GPU			BIT(10)
+#define MODEL_WANGXUN_SP			BIT(11)
 #define MODEL_MASK				GENMASK(11, 8)
 
 /*
diff --git a/drivers/i2c/busses/i2c-designware-master.c b/drivers/i2c/busses/i2c-designware-master.c
index 55ea91a63382..fe85c2ac79d7 100644
--- a/drivers/i2c/busses/i2c-designware-master.c
+++ b/drivers/i2c/busses/i2c-designware-master.c
@@ -354,6 +354,68 @@ static int amd_i2c_dw_xfer_quirk(struct i2c_adapter *adap, struct i2c_msg *msgs,
 	return 0;
 }
 
+static int i2c_dw_poll_tx_empty(struct dw_i2c_dev *dev)
+{
+	u32 val;
+
+	return regmap_read_poll_timeout(dev->map, DW_IC_RAW_INTR_STAT, val,
+					val & DW_IC_INTR_TX_EMPTY,
+					100, 1000);
+}
+
+static int i2c_dw_poll_rx_full(struct dw_i2c_dev *dev)
+{
+	u32 val;
+
+	return regmap_read_poll_timeout(dev->map, DW_IC_RAW_INTR_STAT, val,
+					val & DW_IC_INTR_RX_FULL,
+					100, 1000);
+}
+
+static int txgbe_i2c_dw_xfer_quirk(struct i2c_adapter *adap, struct i2c_msg *msgs,
+				   int num_msgs)
+{
+	struct dw_i2c_dev *dev = i2c_get_adapdata(adap);
+	int msg_idx, buf_len, data_idx, ret;
+	unsigned int val, stop = 0;
+	u8 *buf;
+
+	dev->msgs = msgs;
+	dev->msgs_num = num_msgs;
+	i2c_dw_xfer_init(dev);
+	regmap_write(dev->map, DW_IC_INTR_MASK, 0);
+
+	for (msg_idx = 0; msg_idx < num_msgs; msg_idx++) {
+		buf = msgs[msg_idx].buf;
+		buf_len = msgs[msg_idx].len;
+
+		for (data_idx = 0; data_idx < buf_len; data_idx++) {
+			if (msg_idx == num_msgs - 1 && data_idx == buf_len - 1)
+				stop |= BIT(9);
+
+			if (msgs[msg_idx].flags & I2C_M_RD) {
+				regmap_write(dev->map, DW_IC_DATA_CMD, 0x100 | stop);
+
+				ret = i2c_dw_poll_rx_full(dev);
+				if (ret)
+					return ret;
+
+				regmap_read(dev->map, DW_IC_DATA_CMD, &val);
+				buf[data_idx] = val;
+			} else {
+				ret = i2c_dw_poll_tx_empty(dev);
+				if (ret)
+					return ret;
+
+				regmap_write(dev->map, DW_IC_DATA_CMD,
+					     buf[data_idx] | stop);
+			}
+		}
+	}
+
+	return num_msgs;
+}
+
 /*
  * Initiate (and continue) low level master read/write transaction.
  * This function is only called from i2c_dw_isr, and pumping i2c_msg
@@ -568,6 +630,11 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 		goto done_nolock;
 	}
 
+	if ((dev->flags & MODEL_MASK) == MODEL_WANGXUN_SP) {
+		ret = txgbe_i2c_dw_xfer_quirk(adap, msgs, num);
+		goto done_nolock;
+	}
+
 	reinit_completion(&dev->cmd_complete);
 	dev->msgs = msgs;
 	dev->msgs_num = num;
@@ -848,7 +915,7 @@ static int i2c_dw_init_recovery_info(struct dw_i2c_dev *dev)
 	return 0;
 }
 
-static int amd_i2c_adap_quirk(struct dw_i2c_dev *dev)
+static int i2c_dw_poll_adap_quirk(struct dw_i2c_dev *dev)
 {
 	struct i2c_adapter *adap = &dev->adapter;
 	int ret;
@@ -862,6 +929,17 @@ static int amd_i2c_adap_quirk(struct dw_i2c_dev *dev)
 	return ret;
 }
 
+static bool i2c_dw_is_model_poll(struct dw_i2c_dev *dev)
+{
+	switch (dev->flags & MODEL_MASK) {
+	case MODEL_AMD_NAVI_GPU:
+	case MODEL_WANGXUN_SP:
+		return true;
+	default:
+		return false;
+	}
+}
+
 int i2c_dw_probe_master(struct dw_i2c_dev *dev)
 {
 	struct i2c_adapter *adap = &dev->adapter;
@@ -917,8 +995,8 @@ int i2c_dw_probe_master(struct dw_i2c_dev *dev)
 	adap->dev.parent = dev->dev;
 	i2c_set_adapdata(adap, dev);
 
-	if ((dev->flags & MODEL_MASK) == MODEL_AMD_NAVI_GPU)
-		return amd_i2c_adap_quirk(dev);
+	if (i2c_dw_is_model_poll(dev))
+		return i2c_dw_poll_adap_quirk(dev);
 
 	if (dev->flags & ACCESS_NO_IRQ_SUSPEND) {
 		irq_flags = IRQF_NO_SUSPEND;
diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 74182db03a88..5504579cd622 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -168,6 +168,20 @@ static inline int dw_i2c_of_configure(struct platform_device *pdev)
 }
 #endif
 
+static int txgbe_i2c_request_regs(struct dw_i2c_dev *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev->dev);
+	struct resource *r;
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!r)
+		return -ENODEV;
+
+	dev->base = devm_ioremap(&pdev->dev, r->start, resource_size(r));
+
+	return PTR_ERR_OR_ZERO(dev->base);
+}
+
 static void dw_i2c_plat_pm_cleanup(struct dw_i2c_dev *dev)
 {
 	pm_runtime_disable(dev->dev);
@@ -185,6 +199,9 @@ static int dw_i2c_plat_request_regs(struct dw_i2c_dev *dev)
 	case MODEL_BAIKAL_BT1:
 		ret = bt1_i2c_request_regs(dev);
 		break;
+	case MODEL_WANGXUN_SP:
+		ret = txgbe_i2c_request_regs(dev);
+		break;
 	default:
 		dev->base = devm_platform_ioremap_resource(pdev, 0);
 		ret = PTR_ERR_OR_ZERO(dev->base);
@@ -278,6 +295,9 @@ static int dw_i2c_plat_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	dev->flags = (uintptr_t)device_get_match_data(&pdev->dev);
+	if (!dev->flags)
+		device_property_read_u32(&pdev->dev, "i2c-dw-flags", &dev->flags);
+
 	dev->dev = &pdev->dev;
 	dev->irq = irq;
 	platform_set_drvdata(pdev, dev);
-- 
2.27.0

