Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3F2C600E2
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 08:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbfGEGMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 02:12:18 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8708 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725827AbfGEGMS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 02:12:18 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 20313F38436F1FB3106C;
        Fri,  5 Jul 2019 14:12:16 +0800 (CST)
Received: from huawei.com (10.67.189.167) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Fri, 5 Jul 2019
 14:12:06 +0800
From:   Jiangfeng Xiao <xiaojiangfeng@huawei.com>
To:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <dingtianhong@huawei.com>, <xiaojiangfeng@huawei.com>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <leeyou.li@huawei.com>, <xiekunxun@huawei.com>,
        <jianping.liu@huawei.com>, <nixiaoming@huawei.com>
Subject: [PATCH 07/10] net: hisilicon: Add group field to adapt HI13X1_GMAC
Date:   Fri, 5 Jul 2019 14:12:00 +0800
Message-ID: <1562307120-103799-1-git-send-email-xiaojiangfeng@huawei.com>
X-Mailer: git-send-email 1.8.5.6
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.189.167]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In general, group is the same as the port, but some
boards specify a special group for better load
balancing of each processing unit.

Signed-off-by: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
---
 drivers/net/ethernet/hisilicon/hip04_eth.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index 19d8cfd..5328219 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -178,6 +178,7 @@ struct hip04_priv {
 	int phy_mode;
 	int chan;
 	unsigned int port;
+	unsigned int group;
 	unsigned int speed;
 	unsigned int duplex;
 	unsigned int reg_inten;
@@ -278,10 +279,10 @@ static void hip04_config_fifo(struct hip04_priv *priv)
 	val |= PPE_CFG_STS_RX_PKT_CNT_RC;
 	writel_relaxed(val, priv->base + PPE_CFG_STS_MODE);
 
-	val = BIT(priv->port);
+	val = BIT(priv->group);
 	regmap_write(priv->map, priv->port * 4 + PPE_CFG_POOL_GRP, val);
 
-	val = priv->port << PPE_CFG_QOS_VMID_GRP_SHIFT;
+	val = priv->group << PPE_CFG_QOS_VMID_GRP_SHIFT;
 	val |= PPE_CFG_QOS_VMID_MODE;
 	writel_relaxed(val, priv->base + PPE_CFG_QOS_VMID_GEN);
 
@@ -876,7 +877,7 @@ static int hip04_mac_probe(struct platform_device *pdev)
 	}
 #endif
 
-	ret = of_parse_phandle_with_fixed_args(node, "port-handle", 2, 0, &arg);
+	ret = of_parse_phandle_with_fixed_args(node, "port-handle", 3, 0, &arg);
 	if (ret < 0) {
 		dev_warn(d, "no port-handle\n");
 		goto init_fail;
@@ -884,6 +885,7 @@ static int hip04_mac_probe(struct platform_device *pdev)
 
 	priv->port = arg.args[0];
 	priv->chan = arg.args[1] * RX_DESC_NUM;
+	priv->group = arg.args[2];
 
 	hrtimer_init(&priv->tx_coalesce_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 
-- 
1.8.5.6

