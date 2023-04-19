Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF706E7523
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 10:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbjDSI3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 04:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232609AbjDSI3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 04:29:44 -0400
Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E22010271;
        Wed, 19 Apr 2023 01:29:25 -0700 (PDT)
X-QQ-mid: bizesmtp68t1681892934tjl1xu34
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 19 Apr 2023 16:28:53 +0800 (CST)
X-QQ-SSF: 01400000000000I0Z000000A0000000
X-QQ-FEAT: q+EIYT+FhZpXHgj6NbzKiCMQCAzm9mO5VjvMj1q7zXlrzNYqzope5NuxPpeEQ
        LDBBIiiXpvdlifceE3H14Ws5j16B3JCtKfSQ1pIVmDwhamOxv0e58pfA5GQCuISRdCQNPg6
        bH0POxdsfa5veHjy2/+Y/rDd1rCOneexbNjKKPrfIX2jLyk2qVBE+Xfu4Fh/ctttzy51ISw
        BZ5rihKNrrcAcpaVYgxlsKSPWRXeKWjMwLpWZmhZu+ftUXHZH21MYjt/uMNlwLIgS6xMsLB
        KNcE/bWyQZZlGwr01WvuYnF1APSpJKolJ8BbebV4zAGH8n5HWUUTfRf45edAXQ7VU1UindX
        1Msz0JqGg9oG5pTW4vRzPwQosfqQUfm9EnR+ukoNyLXVSDVGJv8T9tJxsCKkREGgOKf03ba
        To1je/KrAi8=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 15561080134594190925
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, linux@armlinux.org.uk
Cc:     linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        olteanv@gmail.com, mengyuanlou@net-swift.com,
        Jiawen Wu <jiawenwu@trustnetic.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>
Subject: [PATCH net-next v3 2/8] i2c: designware: Add driver support for Wangxun 10Gb NIC
Date:   Wed, 19 Apr 2023 16:27:33 +0800
Message-Id: <20230419082739.295180-3-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230419082739.295180-1-jiawenwu@trustnetic.com>
References: <20230419082739.295180-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wangxun 10Gb ethernet chip is connected to Designware I2C, to communicate
with SFP.

Add platform data to pass IOMEM base address, board flag and other
parameters, since resource address was mapped on ethernet driver.

The exists IP limitations are dealt as workarounds:
- IP does not support interrupt mode, it works on polling mode.
- I2C cannot read continuously, only one byte can at a time.
- Additionally set FIFO depth address the chip issue.

Cc: Jarkko Nikula <jarkko.nikula@linux.intel.com>

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/i2c/busses/i2c-designware-common.c  |  4 +
 drivers/i2c/busses/i2c-designware-core.h    |  1 +
 drivers/i2c/busses/i2c-designware-master.c  | 91 ++++++++++++++++++++-
 drivers/i2c/busses/i2c-designware-platdrv.c | 36 +++++++-
 include/linux/platform_data/i2c-dw.h        | 15 ++++
 5 files changed, 143 insertions(+), 4 deletions(-)
 create mode 100644 include/linux/platform_data/i2c-dw.h

diff --git a/drivers/i2c/busses/i2c-designware-common.c b/drivers/i2c/busses/i2c-designware-common.c
index 0dc6b1ce663f..e4faab4655cb 100644
--- a/drivers/i2c/busses/i2c-designware-common.c
+++ b/drivers/i2c/busses/i2c-designware-common.c
@@ -588,6 +588,10 @@ int i2c_dw_set_fifo_size(struct dw_i2c_dev *dev)
 	if (ret)
 		return ret;
 
+	/* workaround for IP hardware issue */
+	if ((dev->flags & MODEL_MASK) == MODEL_WANGXUN_SP)
+		param |= 0x80800;
+
 	tx_fifo_depth = ((param >> 16) & 0xff) + 1;
 	rx_fifo_depth = ((param >> 8)  & 0xff) + 1;
 	if (!dev->tx_fifo_depth) {
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
index 55ea91a63382..21e350203247 100644
--- a/drivers/i2c/busses/i2c-designware-master.c
+++ b/drivers/i2c/busses/i2c-designware-master.c
@@ -354,6 +354,75 @@ static int amd_i2c_dw_xfer_quirk(struct i2c_adapter *adap, struct i2c_msg *msgs,
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
+	unsigned int val;
+	u8 dev_addr;
+	u8 *buf;
+
+	dev->msgs = msgs;
+	dev->msgs_num = num_msgs;
+	i2c_dw_xfer_init(dev);
+	regmap_write(dev->map, DW_IC_INTR_MASK, 0);
+
+	dev_addr = msgs[0].buf[0];
+
+	for (msg_idx = 0; msg_idx < num_msgs; msg_idx++) {
+		buf = msgs[msg_idx].buf;
+		buf_len = msgs[msg_idx].len;
+
+		for (data_idx = 0; data_idx < buf_len; data_idx++) {
+			if (msgs[msg_idx].flags & I2C_M_RD) {
+				ret = i2c_dw_poll_tx_empty(dev);
+				if (ret)
+					return ret;
+
+				regmap_write(dev->map, DW_IC_DATA_CMD,
+					     (dev_addr + data_idx) | BIT(9));
+				regmap_write(dev->map, DW_IC_DATA_CMD, 0x100 | BIT(9));
+
+				ret = i2c_dw_poll_rx_full(dev);
+				if (ret)
+					return ret;
+
+				regmap_read(dev->map, DW_IC_DATA_CMD, &val);
+				buf[data_idx] = 0xFF & val;
+			} else {
+				ret = i2c_dw_poll_tx_empty(dev);
+				if (ret)
+					return ret;
+
+				regmap_write(dev->map, DW_IC_DATA_CMD, buf[data_idx]);
+				if (data_idx == (buf_len - 1))
+					regmap_write(dev->map, DW_IC_DATA_CMD, BIT(9));
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
@@ -568,6 +637,11 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
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
@@ -848,7 +922,7 @@ static int i2c_dw_init_recovery_info(struct dw_i2c_dev *dev)
 	return 0;
 }
 
-static int amd_i2c_adap_quirk(struct dw_i2c_dev *dev)
+static int poll_i2c_adap_quirk(struct dw_i2c_dev *dev)
 {
 	struct i2c_adapter *adap = &dev->adapter;
 	int ret;
@@ -862,6 +936,17 @@ static int amd_i2c_adap_quirk(struct dw_i2c_dev *dev)
 	return ret;
 }
 
+static bool i2c_is_model_poll(struct dw_i2c_dev *dev)
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
@@ -917,8 +1002,8 @@ int i2c_dw_probe_master(struct dw_i2c_dev *dev)
 	adap->dev.parent = dev->dev;
 	i2c_set_adapdata(adap, dev);
 
-	if ((dev->flags & MODEL_MASK) == MODEL_AMD_NAVI_GPU)
-		return amd_i2c_adap_quirk(dev);
+	if (i2c_is_model_poll(dev))
+		return poll_i2c_adap_quirk(dev);
 
 	if (dev->flags & ACCESS_NO_IRQ_SUSPEND) {
 		irq_flags = IRQF_NO_SUSPEND;
diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 74182db03a88..10b2c61b279f 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -23,6 +23,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/platform_data/i2c-dw.h>
 #include <linux/pm.h>
 #include <linux/pm_runtime.h>
 #include <linux/property.h>
@@ -179,12 +180,14 @@ static void dw_i2c_plat_pm_cleanup(struct dw_i2c_dev *dev)
 static int dw_i2c_plat_request_regs(struct dw_i2c_dev *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev->dev);
-	int ret;
+	int ret = 0;
 
 	switch (dev->flags & MODEL_MASK) {
 	case MODEL_BAIKAL_BT1:
 		ret = bt1_i2c_request_regs(dev);
 		break;
+	case MODEL_WANGXUN_SP:
+		break;
 	default:
 		dev->base = devm_platform_ioremap_resource(pdev, 0);
 		ret = PTR_ERR_OR_ZERO(dev->base);
@@ -194,6 +197,35 @@ static int dw_i2c_plat_request_regs(struct dw_i2c_dev *dev)
 	return ret;
 }
 
+static void dw_i2c_get_plat_data(struct dw_i2c_dev *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev->dev);
+	struct dw_i2c_platform_data *pdata;
+
+	pdata = dev_get_platdata(&pdev->dev);
+	if (!pdata)
+		return;
+
+	dev->flags |= pdata->flags;
+	dev->base = pdata->base;
+
+	if (pdata->ss_hcnt && pdata->ss_lcnt) {
+		dev->ss_hcnt = pdata->ss_hcnt;
+		dev->ss_lcnt = pdata->ss_lcnt;
+	} else {
+		dev->ss_hcnt = 6;
+		dev->ss_lcnt = 8;
+	}
+
+	if (pdata->fs_hcnt && pdata->fs_lcnt) {
+		dev->fs_hcnt = pdata->fs_hcnt;
+		dev->fs_lcnt = pdata->fs_lcnt;
+	} else {
+		dev->fs_hcnt = 6;
+		dev->fs_lcnt = 8;
+	}
+}
+
 static const struct dmi_system_id dw_i2c_hwmon_class_dmi[] = {
 	{
 		.ident = "Qtechnology QT5222",
@@ -282,6 +314,8 @@ static int dw_i2c_plat_probe(struct platform_device *pdev)
 	dev->irq = irq;
 	platform_set_drvdata(pdev, dev);
 
+	dw_i2c_get_plat_data(dev);
+
 	ret = dw_i2c_plat_request_regs(dev);
 	if (ret)
 		return ret;
diff --git a/include/linux/platform_data/i2c-dw.h b/include/linux/platform_data/i2c-dw.h
new file mode 100644
index 000000000000..f4552df08084
--- /dev/null
+++ b/include/linux/platform_data/i2c-dw.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _LINUX_I2C_DW_H
+#define _LINUX_I2C_DW_H
+
+struct dw_i2c_platform_data {
+	void __iomem *base;
+	unsigned int flags;
+	unsigned int ss_hcnt;
+	unsigned int ss_lcnt;
+	unsigned int fs_hcnt;
+	unsigned int fs_lcnt;
+};
+
+#endif /* _LINUX_I2C_DW_H */
-- 
2.27.0

