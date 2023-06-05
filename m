Return-Path: <netdev+bounces-7832-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20D0C721C4E
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 04:56:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 81C9C1C209BA
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 02:56:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 386DB37A;
	Mon,  5 Jun 2023 02:56:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A6C198
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 02:56:26 +0000 (UTC)
Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B19C7
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 19:56:16 -0700 (PDT)
X-QQ-mid: bizesmtp91t1685933683tcnl4z67
Received: from wxdbg.localdomain.com ( [60.177.99.31])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 05 Jun 2023 10:54:42 +0800 (CST)
X-QQ-SSF: 01400000000000J0Z000000A0000000
X-QQ-FEAT: k0mQ4ihyJQMcSrBPTG27vuejhTyaN/PCs65lq6HJvXp2u8fJkWnyQruiW8Gyo
	OJ5To82hUEpLlq8pJOFy7UpFcRkHtcdMnDTT6umU7asc0KY0/NN4iNXse6AmkBT4+oTOyoH
	EuJ9Hq0joYmxFpGx5hrzHeVHDl+mXdsUIJoz4yX4CasPEzmi4pWdUHsa2d7Jeb6dbTdYWpd
	QWw8G92i7VNICJXIm6hj+eq9RKfWc0XK3YFRQhsPn6zb9/PRiyz0CGbBIgRlTWIHkTNE4RW
	hyzUoTobNYYzsYXq7QfYZLS0AmP27EDHMIg0jzQSUoDPr6pxaD3xbBqlm3cLupEOgvd313b
	+fvoYQo+yL80iXyKseDcBHbDKOgeCKD1IJ4vzQuuK4UbmV5YZ7J4wXqo2DqUW8J2asrbnJf
	hZB1KCp8g00=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 13436933723295877036
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
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Piotr Raczynski <piotr.raczynski@intel.com>
Subject: [PATCH net-next v11 2/9] i2c: designware: Add driver support for Wangxun 10Gb NIC
Date: Mon,  5 Jun 2023 10:52:04 +0800
Message-Id: <20230605025211.743823-3-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230605025211.743823-1-jiawenwu@trustnetic.com>
References: <20230605025211.743823-1-jiawenwu@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Wangxun 10Gb ethernet chip is connected to Designware I2C, to communicate
with SFP.

Introduce the property "wx,i2c-snps-model" to match device data for Wangxun
in software node case. Since IO resource was mapped on the ethernet driver,
add a model quirk to get regmap from parent device.

The exists IP limitations are dealt as workarounds:
- IP does not support interrupt mode, it works on polling mode.
- Additionally set FIFO depth address the chip issue.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/i2c/busses/i2c-designware-common.c  |  8 ++
 drivers/i2c/busses/i2c-designware-core.h    |  4 +
 drivers/i2c/busses/i2c-designware-master.c  | 89 +++++++++++++++++++--
 drivers/i2c/busses/i2c-designware-platdrv.c | 15 ++++
 4 files changed, 111 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-common.c b/drivers/i2c/busses/i2c-designware-common.c
index 0dc6b1ce663f..cdd8c67d9129 100644
--- a/drivers/i2c/busses/i2c-designware-common.c
+++ b/drivers/i2c/busses/i2c-designware-common.c
@@ -575,6 +575,14 @@ int i2c_dw_set_fifo_size(struct dw_i2c_dev *dev)
 	unsigned int param;
 	int ret;
 
+	/* DW_IC_COMP_PARAM_1 not implement for IP issue */
+	if ((dev->flags & MODEL_MASK) == MODEL_WANGXUN_SP) {
+		dev->tx_fifo_depth = TXGBE_TX_FIFO_DEPTH;
+		dev->rx_fifo_depth = TXGBE_RX_FIFO_DEPTH;
+
+		return 0;
+	}
+
 	/*
 	 * Try to detect the FIFO depth if not set by interface driver,
 	 * the depth could be from 2 to 256 from HW spec.
diff --git a/drivers/i2c/busses/i2c-designware-core.h b/drivers/i2c/busses/i2c-designware-core.h
index c5d87aae39c6..782532c20bd1 100644
--- a/drivers/i2c/busses/i2c-designware-core.h
+++ b/drivers/i2c/busses/i2c-designware-core.h
@@ -303,6 +303,7 @@ struct dw_i2c_dev {
 #define MODEL_MSCC_OCELOT			BIT(8)
 #define MODEL_BAIKAL_BT1			BIT(9)
 #define MODEL_AMD_NAVI_GPU			BIT(10)
+#define MODEL_WANGXUN_SP			BIT(11)
 #define MODEL_MASK				GENMASK(11, 8)
 
 /*
@@ -312,6 +313,9 @@ struct dw_i2c_dev {
 #define AMD_UCSI_INTR_REG			0x474
 #define AMD_UCSI_INTR_EN			0xd
 
+#define TXGBE_TX_FIFO_DEPTH			4
+#define TXGBE_RX_FIFO_DEPTH			0
+
 struct i2c_dw_semaphore_callbacks {
 	int	(*probe)(struct dw_i2c_dev *dev);
 	void	(*remove)(struct dw_i2c_dev *dev);
diff --git a/drivers/i2c/busses/i2c-designware-master.c b/drivers/i2c/busses/i2c-designware-master.c
index 55ea91a63382..3bfd7a2232db 100644
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
@@ -559,13 +621,19 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 	pm_runtime_get_sync(dev->dev);
 
 	/*
-	 * Initiate I2C message transfer when AMD NAVI GPU card is enabled,
+	 * Initiate I2C message transfer when polling mode is enabled,
 	 * As it is polling based transfer mechanism, which does not support
 	 * interrupt based functionalities of existing DesignWare driver.
 	 */
-	if ((dev->flags & MODEL_MASK) == MODEL_AMD_NAVI_GPU) {
+	switch (dev->flags & MODEL_MASK) {
+	case MODEL_AMD_NAVI_GPU:
 		ret = amd_i2c_dw_xfer_quirk(adap, msgs, num);
 		goto done_nolock;
+	case MODEL_WANGXUN_SP:
+		ret = txgbe_i2c_dw_xfer_quirk(adap, msgs, num);
+		goto done_nolock;
+	default:
+		break;
 	}
 
 	reinit_completion(&dev->cmd_complete);
@@ -848,7 +916,7 @@ static int i2c_dw_init_recovery_info(struct dw_i2c_dev *dev)
 	return 0;
 }
 
-static int amd_i2c_adap_quirk(struct dw_i2c_dev *dev)
+static int i2c_dw_poll_adap_quirk(struct dw_i2c_dev *dev)
 {
 	struct i2c_adapter *adap = &dev->adapter;
 	int ret;
@@ -862,6 +930,17 @@ static int amd_i2c_adap_quirk(struct dw_i2c_dev *dev)
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
@@ -917,8 +996,8 @@ int i2c_dw_probe_master(struct dw_i2c_dev *dev)
 	adap->dev.parent = dev->dev;
 	i2c_set_adapdata(adap, dev);
 
-	if ((dev->flags & MODEL_MASK) == MODEL_AMD_NAVI_GPU)
-		return amd_i2c_adap_quirk(dev);
+	if (i2c_dw_is_model_poll(dev))
+		return i2c_dw_poll_adap_quirk(dev);
 
 	if (dev->flags & ACCESS_NO_IRQ_SUSPEND) {
 		irq_flags = IRQF_NO_SUSPEND;
diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 89ad88c54754..5a476a38b52f 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -168,6 +168,15 @@ static inline int dw_i2c_of_configure(struct platform_device *pdev)
 }
 #endif
 
+static int txgbe_i2c_request_regs(struct dw_i2c_dev *dev)
+{
+	dev->map = dev_get_regmap(dev->dev->parent, NULL);
+	if (!dev->map)
+		return -ENODEV;
+
+	return 0;
+}
+
 static void dw_i2c_plat_pm_cleanup(struct dw_i2c_dev *dev)
 {
 	pm_runtime_disable(dev->dev);
@@ -185,6 +194,9 @@ static int dw_i2c_plat_request_regs(struct dw_i2c_dev *dev)
 	case MODEL_BAIKAL_BT1:
 		ret = bt1_i2c_request_regs(dev);
 		break;
+	case MODEL_WANGXUN_SP:
+		ret = txgbe_i2c_request_regs(dev);
+		break;
 	default:
 		dev->base = devm_platform_ioremap_resource(pdev, 0);
 		ret = PTR_ERR_OR_ZERO(dev->base);
@@ -277,6 +289,9 @@ static int dw_i2c_plat_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	dev->flags = (uintptr_t)device_get_match_data(&pdev->dev);
+	if (device_property_present(&pdev->dev, "wx,i2c-snps-model"))
+		dev->flags = MODEL_WANGXUN_SP;
+
 	dev->dev = &pdev->dev;
 	dev->irq = irq;
 	platform_set_drvdata(pdev, dev);
-- 
2.27.0


