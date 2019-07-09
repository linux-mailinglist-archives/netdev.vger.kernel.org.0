Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B246462EDB
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 05:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbfGIDbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 23:31:32 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:51552 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726046AbfGIDbb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 23:31:31 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 812921B7C99B1553E632;
        Tue,  9 Jul 2019 11:31:29 +0800 (CST)
Received: from huawei.com (10.67.189.167) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Tue, 9 Jul 2019
 11:31:20 +0800
From:   Jiangfeng Xiao <xiaojiangfeng@huawei.com>
To:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <mark.rutland@arm.com>, <dingtianhong@huawei.com>,
        <xiaojiangfeng@huawei.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <leeyou.li@huawei.com>,
        <nixiaoming@huawei.com>, <jianping.liu@huawei.com>,
        <xiekunxun@huawei.com>
Subject: [PATCH v2 01/10] net: hisilicon: Add support for HI13X1 to hip04_eth
Date:   Tue, 9 Jul 2019 11:31:02 +0800
Message-ID: <1562643071-46811-2-git-send-email-xiaojiangfeng@huawei.com>
X-Mailer: git-send-email 1.8.5.6
In-Reply-To: <1562643071-46811-1-git-send-email-xiaojiangfeng@huawei.com>
References: <1562643071-46811-1-git-send-email-xiaojiangfeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.189.167]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the hip04_eth driver to support HI13X1_GMAC.
Enable it with CONFIG_HI13X1_GMAC option.

Signed-off-by: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
---
 drivers/net/ethernet/hisilicon/Kconfig     | 10 ++++++++
 drivers/net/ethernet/hisilicon/hip04_eth.c | 37 ++++++++++++++++++++++++------
 2 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/Kconfig b/drivers/net/ethernet/hisilicon/Kconfig
index a0d780c..3892a20 100644
--- a/drivers/net/ethernet/hisilicon/Kconfig
+++ b/drivers/net/ethernet/hisilicon/Kconfig
@@ -46,6 +46,16 @@ config HIP04_ETH
 	  If you wish to compile a kernel for a hardware with hisilicon p04 SoC and
 	  want to use the internal ethernet then you should answer Y to this.
 
+config HI13X1_GMAC
+	bool "Hisilicon HI13X1 Network Device Support"
+	depends on HIP04_ETH
+	help
+	  If you wish to compile a kernel for a hardware with hisilicon hi13x1_gamc
+	  then you should answer Y to this. This makes this driver suitable for use
+	  on certain boards such as the HI13X1.
+
+	  If you are unsure, say N.
+
 config HNS_MDIO
 	tristate
 	select PHYLIB
diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index e1f2978..2b5112b 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -33,10 +33,23 @@
 #define GE_MODE_CHANGE_REG		0x1b4
 #define GE_RECV_CONTROL_REG		0x1e0
 #define GE_STATION_MAC_ADDRESS		0x210
-#define PPE_CFG_CPU_ADD_ADDR		0x580
-#define PPE_CFG_MAX_FRAME_LEN_REG	0x408
+
 #define PPE_CFG_BUS_CTRL_REG		0x424
 #define PPE_CFG_RX_CTRL_REG		0x428
+
+#if defined(CONFIG_HI13X1_GMAC)
+#define PPE_CFG_CPU_ADD_ADDR		0x6D0
+#define PPE_CFG_MAX_FRAME_LEN_REG	0x500
+#define PPE_CFG_RX_PKT_MODE_REG		0x504
+#define PPE_CFG_QOS_VMID_GEN		0x520
+#define PPE_CFG_RX_PKT_INT		0x740
+#define PPE_INTEN			0x700
+#define PPE_INTSTS			0x708
+#define PPE_RINT			0x704
+#define PPE_CFG_STS_MODE		0x880
+#else
+#define PPE_CFG_CPU_ADD_ADDR		0x580
+#define PPE_CFG_MAX_FRAME_LEN_REG	0x408
 #define PPE_CFG_RX_PKT_MODE_REG		0x438
 #define PPE_CFG_QOS_VMID_GEN		0x500
 #define PPE_CFG_RX_PKT_INT		0x538
@@ -44,6 +57,8 @@
 #define PPE_INTSTS			0x608
 #define PPE_RINT			0x604
 #define PPE_CFG_STS_MODE		0x700
+#endif /* CONFIG_HI13X1_GMAC */
+
 #define PPE_HIS_RX_PKT_CNT		0x804
 
 /* REG_INTERRUPT */
@@ -93,18 +108,26 @@
 #define GE_RX_PORT_EN			BIT(1)
 #define GE_TX_PORT_EN			BIT(2)
 
-#define PPE_CFG_STS_RX_PKT_CNT_RC	BIT(12)
-
 #define PPE_CFG_RX_PKT_ALIGN		BIT(18)
-#define PPE_CFG_QOS_VMID_MODE		BIT(14)
+
+#if defined(CONFIG_HI13X1_GMAC)
+#define PPE_CFG_QOS_VMID_GRP_SHIFT	4
+#define PPE_CFG_RX_CTRL_ALIGN_SHIFT	7
+#define PPE_CFG_STS_RX_PKT_CNT_RC	BIT(0)
+#define PPE_CFG_QOS_VMID_MODE		BIT(15)
+#define PPE_CFG_BUS_LOCAL_REL		(BIT(9) | BIT(15) | BIT(19) | BIT(23))
+#else
 #define PPE_CFG_QOS_VMID_GRP_SHIFT	8
+#define PPE_CFG_RX_CTRL_ALIGN_SHIFT	11
+#define PPE_CFG_STS_RX_PKT_CNT_RC	BIT(12)
+#define PPE_CFG_QOS_VMID_MODE		BIT(14)
+#define PPE_CFG_BUS_LOCAL_REL		BIT(14)
+#endif /* CONFIG_HI13X1_GMAC */
 
 #define PPE_CFG_RX_FIFO_FSFU		BIT(11)
 #define PPE_CFG_RX_DEPTH_SHIFT		16
 #define PPE_CFG_RX_START_SHIFT		0
-#define PPE_CFG_RX_CTRL_ALIGN_SHIFT	11
 
-#define PPE_CFG_BUS_LOCAL_REL		BIT(14)
 #define PPE_CFG_BUS_BIG_ENDIEN		BIT(0)
 
 #define RX_DESC_NUM			128
-- 
1.8.5.6

