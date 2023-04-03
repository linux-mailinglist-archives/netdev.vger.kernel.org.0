Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 212766D3D8D
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 08:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbjDCGsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 02:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbjDCGsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 02:48:01 -0400
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C721FED
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 23:47:57 -0700 (PDT)
X-QQ-mid: bizesmtp63t1680504427te16rxw1
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 03 Apr 2023 14:47:06 +0800 (CST)
X-QQ-SSF: 01400000000000H0Z000B00A0000000
X-QQ-FEAT: KSpVqVeA+UWmIaeNZPWu+RaAv/tcGCS0S2CjmLQIjyPa4hfWjzrAVjsZNeyrd
        byfAIlmZek/agQFAYUwPMTWICAKFnPEO/oY0x6fvKaytdDNbe2QqX7AW514flLYE8Vn46Y4
        DBS/Om10g9E0H8F/apQ8N922V5M1wI8hqEZGJGIch6jVvGdowitrynQT9vFb6tW2Qk3UGV1
        HtOCl4IMzp5N7alc1XZ18zUPG8KihaHl/1oor/8am7kZsbfy+9fM6sLp8MEl7f15s0s9Lol
        Ov3CqroqTSgujl2/6l4Asj/wVfcrWrDT4fZjS5jChiiBbS5Q00rAO3cVYmeV9ypqSqz/f+l
        jmUmmSAxbGfDlvfYX0Rz3GpSf7ZwmxFd/YpL6g0d/UB6auSDcDRwUWlUBU/v1yCZvulVGfU
        gR2D0qSRpR4LclI/h+TVHQ==
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 858744205473956203
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, linux@armlinux.org.uk
Cc:     mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next 2/6] net: txgbe: Implement I2C bus master driver
Date:   Mon,  3 Apr 2023 14:45:24 +0800
Message-Id: <20230403064528.343866-3-jiawenwu@trustnetic.com>
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

I2C bus is integrated in Wangxun 10Gb ethernet chip. Implement I2C bus
driver to receive I2C messages.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/Kconfig          |   1 +
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 141 ++++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  26 ++++
 3 files changed, 168 insertions(+)

diff --git a/drivers/net/ethernet/wangxun/Kconfig b/drivers/net/ethernet/wangxun/Kconfig
index c9d88673d306..8cbf0dd48a2c 100644
--- a/drivers/net/ethernet/wangxun/Kconfig
+++ b/drivers/net/ethernet/wangxun/Kconfig
@@ -41,6 +41,7 @@ config TXGBE
 	tristate "Wangxun(R) 10GbE PCI Express adapters support"
 	depends on PCI
 	select LIBWX
+	select I2C
 	help
 	  This driver supports Wangxun(R) 10GbE PCI Express family of
 	  adapters.
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
index 163acb7e515e..f8a4b211f4e8 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
@@ -2,9 +2,12 @@
 /* Copyright (c) 2015 - 2023 Beijing WangXun Technology Co., Ltd. */
 
 #include <linux/gpio/property.h>
+#include <linux/iopoll.h>
+#include <linux/i2c.h>
 #include <linux/pci.h>
 
 #include "../libwx/wx_type.h"
+#include "../libwx/wx_hw.h"
 #include "txgbe_type.h"
 #include "txgbe_phy.h"
 
@@ -60,6 +63,130 @@ static int txgbe_swnodes_register(struct txgbe *txgbe)
 	return software_node_register_node_group(nodes->group);
 }
 
+static void txgbe_i2c_start(struct wx *wx, u16 dev_addr)
+{
+	wr32(wx, TXGBE_I2C_ENABLE, 0);
+
+	wr32(wx, TXGBE_I2C_CON,
+	     (TXGBE_I2C_CON_MASTER_MODE |
+	      TXGBE_I2C_CON_SPEED(1) |
+	      TXGBE_I2C_CON_RESTART_EN |
+	      TXGBE_I2C_CON_SLAVE_DISABLE));
+	/* Default addr is 0xA0 ,bit 0 is configure for read/write! */
+	wr32(wx, TXGBE_I2C_TAR, dev_addr);
+	wr32(wx, TXGBE_I2C_SS_SCL_HCNT, 600);
+	wr32(wx, TXGBE_I2C_SS_SCL_LCNT, 600);
+	wr32(wx, TXGBE_I2C_RX_TL, 0); /* 1byte for rx full signal */
+	wr32(wx, TXGBE_I2C_TX_TL, 4);
+	wr32(wx, TXGBE_I2C_SCL_STUCK_TIMEOUT, 0xFFFFFF);
+	wr32(wx, TXGBE_I2C_SDA_STUCK_TIMEOUT, 0xFFFFFF);
+
+	wr32(wx, TXGBE_I2C_INTR_MASK, 0);
+	wr32(wx, TXGBE_I2C_ENABLE, 1);
+}
+
+static int txgbe_read_i2c_bytes(struct wx *wx, u8 addr, u16 len, u8 *buf)
+{
+	int err, i;
+	u16 val;
+
+	for (i = 0; i < len; i++) {
+		/* wait tx empty */
+		err = read_poll_timeout(rd32, val,
+					(val & TXGBE_I2C_INTR_STAT_TEMP) ==
+					TXGBE_I2C_INTR_STAT_TEMP,
+					100, 1000, false, wx,
+					TXGBE_I2C_RAW_INTR_STAT);
+		if (err != 0)
+			return err;
+
+		/* read data */
+		wr32(wx, TXGBE_I2C_DATA_CMD, (addr + i) | TXGBE_I2C_DATA_CMD_STOP);
+		wr32(wx, TXGBE_I2C_DATA_CMD, TXGBE_I2C_DATA_CMD_READ);
+
+		/* wait for read complete */
+		err = read_poll_timeout(rd32, val,
+					(val & TXGBE_I2C_INTR_STAT_RFUL) ==
+					TXGBE_I2C_INTR_STAT_RFUL,
+					100, 1000, false, wx,
+					TXGBE_I2C_RAW_INTR_STAT);
+		if (err != 0)
+			return err;
+
+		buf[i] = 0xFF & rd32(wx, TXGBE_I2C_DATA_CMD);
+	}
+
+	return 0;
+}
+
+static int txgbe_i2c_xfer(struct i2c_adapter *i2c_adap,
+			  struct i2c_msg *msg, int num_msgs)
+{
+	struct wx *wx = i2c_get_adapdata(i2c_adap);
+	u8 *dev_addr = msg[0].buf;
+	bool read = false;
+	int i, ret;
+	u8 *buf;
+	u16 len;
+
+	txgbe_i2c_start(wx, msg[0].addr);
+
+	for (i = 0; i < num_msgs; i++) {
+		if (msg[i].flags & I2C_M_RD) {
+			read = true;
+			len = msg[i].len;
+			buf = msg[i].buf;
+		}
+	}
+
+	if (!read) {
+		wx_err(wx, "I2C write not supported\n");
+		return num_msgs;
+	}
+
+	ret = txgbe_read_i2c_bytes(wx, *dev_addr, len, buf);
+	if (!ret)
+		ret = num_msgs;
+
+	return ret;
+}
+
+static u32 txgbe_i2c_func(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_I2C;
+}
+
+static const struct i2c_algorithm txgbe_i2c_algo = {
+	.master_xfer = txgbe_i2c_xfer,
+	.functionality = txgbe_i2c_func,
+};
+
+static int txgbe_i2c_adapter_add(struct txgbe *txgbe)
+{
+	struct pci_dev *pdev = txgbe->wx->pdev;
+	struct i2c_adapter *i2c_adap;
+	int ret;
+
+	i2c_adap = devm_kzalloc(&pdev->dev, sizeof(*i2c_adap), GFP_KERNEL);
+	if (!i2c_adap)
+		return -ENOMEM;
+
+	i2c_adap->owner = THIS_MODULE;
+	i2c_adap->algo = &txgbe_i2c_algo;
+	i2c_adap->dev.parent = &pdev->dev;
+	i2c_adap->dev.fwnode = software_node_fwnode(txgbe->nodes.group[SWNODE_I2C]);
+	strscpy(i2c_adap->name, "txgbe_i2c", sizeof(i2c_adap->name));
+
+	i2c_set_adapdata(i2c_adap, txgbe->wx);
+	ret = i2c_add_adapter(i2c_adap);
+	if (ret)
+		return ret;
+
+	txgbe->i2c_adap = i2c_adap;
+
+	return 0;
+}
+
 int txgbe_init_phy(struct txgbe *txgbe)
 {
 	int ret;
@@ -70,10 +197,24 @@ int txgbe_init_phy(struct txgbe *txgbe)
 		return ret;
 	}
 
+	ret = txgbe_i2c_adapter_add(txgbe);
+	if (ret) {
+		wx_err(txgbe->wx, "failed to init i2c interface: %d\n", ret);
+		goto err;
+	}
+
 	return 0;
+
+err:
+	txgbe_remove_phy(txgbe);
+
+	return ret;
 }
 
 void txgbe_remove_phy(struct txgbe *txgbe)
 {
+	if (txgbe->i2c_adap)
+		i2c_del_adapter(txgbe->i2c_adap);
+
 	software_node_unregister_node_group(txgbe->nodes.group);
 }
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index d30684378f4e..de488609f713 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -55,6 +55,31 @@
 #define TXGBE_TS_CTL                            0x10300
 #define TXGBE_TS_CTL_EVAL_MD                    BIT(31)
 
+/* I2C registers */
+#define TXGBE_I2C_CON                           0x14900 /* I2C Control */
+#define TXGBE_I2C_CON_SLAVE_DISABLE             BIT(6)
+#define TXGBE_I2C_CON_RESTART_EN                BIT(5)
+#define TXGBE_I2C_CON_SPEED(_v)                 FIELD_PREP(GENMASK(2, 1), _v)
+#define TXGBE_I2C_CON_MASTER_MODE               BIT(0)
+#define TXGBE_I2C_TAR                           0x14904 /* I2C Target Address */
+#define TXGBE_I2C_DATA_CMD                      0x14910 /* I2C Rx/Tx Data Buf and Cmd */
+#define TXGBE_I2C_DATA_CMD_STOP                 BIT(9)
+#define TXGBE_I2C_DATA_CMD_READ                 (BIT(8) | TXGBE_I2C_DATA_CMD_STOP)
+#define TXGBE_I2C_SS_SCL_HCNT                   0x14914
+#define TXGBE_I2C_SS_SCL_LCNT                   0x14918
+#define TXGBE_I2C_INTR_MASK                     0x14930 /* I2C Interrupt Mask */
+#define TXGBE_I2C_RAW_INTR_STAT                 0x14934 /* I2C Raw Interrupt Status */
+#define TXGBE_I2C_INTR_STAT_RFUL                BIT(2)
+#define TXGBE_I2C_INTR_STAT_TEMP                BIT(4)
+#define TXGBE_I2C_RX_TL                         0x14938 /* I2C Receive FIFO Threshold */
+#define TXGBE_I2C_TX_TL                         0x1493C /* I2C TX FIFO Threshold */
+#define TXGBE_I2C_ENABLE                        0x1496C /* I2C Enable */
+#define TXGBE_I2C_SCL_STUCK_TIMEOUT             0x149AC
+#define TXGBE_I2C_SDA_STUCK_TIMEOUT             0x149B0
+
+#define TXGBE_I2C_SLAVE_ADDR                    (0xA0 >> 1)
+#define TXGBE_I2C_EEPROM_DEV_ADDR               0xA0
+
 /* Part Number String Length */
 #define TXGBE_PBANUM_LENGTH                     32
 
@@ -139,6 +164,7 @@ struct txgbe_nodes {
 struct txgbe {
 	struct wx *wx;
 	struct txgbe_nodes nodes;
+	struct i2c_adapter *i2c_adap;
 };
 
 #endif /* _TXGBE_TYPE_H_ */
-- 
2.27.0


