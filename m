Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00A5A600DC
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 08:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbfGEGLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 02:11:50 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:45124 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725827AbfGEGLu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 02:11:50 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 1D78CA60EB7F3C994434;
        Fri,  5 Jul 2019 14:11:48 +0800 (CST)
Received: from huawei.com (10.67.189.167) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Fri, 5 Jul 2019
 14:11:40 +0800
From:   Jiangfeng Xiao <xiaojiangfeng@huawei.com>
To:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <dingtianhong@huawei.com>, <xiaojiangfeng@huawei.com>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <leeyou.li@huawei.com>, <xiekunxun@huawei.com>,
        <jianping.liu@huawei.com>, <nixiaoming@huawei.com>
Subject: [PATCH 05/10] net: hisilicon: HI13X1_GMAX need dreq reset at first
Date:   Fri, 5 Jul 2019 14:11:34 +0800
Message-ID: <1562307094-103720-1-git-send-email-xiaojiangfeng@huawei.com>
X-Mailer: git-send-email 1.8.5.6
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.189.167]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HI13X1_GMAC delete request for soft reset at first,
otherwise, the subsequent initialization will not
take effect.

Signed-off-by: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
---
 drivers/net/ethernet/hisilicon/hip04_eth.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index fe61b01..19d8cfd 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -16,6 +16,8 @@
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
 
+#define SC_PPE_RESET_DREQ		0x026C
+
 #define PPE_CFG_RX_ADDR			0x100
 #define PPE_CFG_POOL_GRP		0x300
 #define PPE_CFG_RX_BUF_SIZE		0x400
@@ -61,6 +63,8 @@
 
 #define PPE_HIS_RX_PKT_CNT		0x804
 
+#define RESET_DREQ_ALL			0xffffffff
+
 /* REG_INTERRUPT */
 #define RCV_INT				BIT(10)
 #define RCV_NOBUF			BIT(8)
@@ -168,6 +172,9 @@ struct rx_desc {
 
 struct hip04_priv {
 	void __iomem *base;
+#if defined(CONFIG_HI13X1_GMAC)
+	void __iomem *sysctrl_base;
+#endif
 	int phy_mode;
 	int chan;
 	unsigned int port;
@@ -244,6 +251,13 @@ static void hip04_config_port(struct net_device *ndev, u32 speed, u32 duplex)
 	writel_relaxed(val, priv->base + GE_MODE_CHANGE_REG);
 }
 
+static void hip04_reset_dreq(struct hip04_priv *priv)
+{
+#if defined(CONFIG_HI13X1_GMAC)
+	writel_relaxed(RESET_DREQ_ALL, priv->sysctrl_base + SC_PPE_RESET_DREQ);
+#endif
+}
+
 static void hip04_reset_ppe(struct hip04_priv *priv)
 {
 	u32 val, tmp, timeout = 0;
@@ -853,6 +867,15 @@ static int hip04_mac_probe(struct platform_device *pdev)
 		goto init_fail;
 	}
 
+#if defined(CONFIG_HI13X1_GMAC)
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	priv->sysctrl_base = devm_ioremap_resource(d, res);
+	if (IS_ERR(priv->sysctrl_base)) {
+		ret = PTR_ERR(priv->sysctrl_base);
+		goto init_fail;
+	}
+#endif
+
 	ret = of_parse_phandle_with_fixed_args(node, "port-handle", 2, 0, &arg);
 	if (ret < 0) {
 		dev_warn(d, "no port-handle\n");
@@ -921,6 +944,7 @@ static int hip04_mac_probe(struct platform_device *pdev)
 	ndev->irq = irq;
 	netif_napi_add(ndev, &priv->napi, hip04_rx_poll, NAPI_POLL_WEIGHT);
 
+	hip04_reset_dreq(priv);
 	hip04_reset_ppe(priv);
 	if (priv->phy_mode == PHY_INTERFACE_MODE_MII)
 		hip04_config_port(ndev, SPEED_100, DUPLEX_FULL);
-- 
1.8.5.6

