Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A6D2AAFE6
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 04:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729271AbgKIDW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 22:22:26 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7613 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729178AbgKIDWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 22:22:25 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CTxBD0m5gzLvvK;
        Mon,  9 Nov 2020 11:22:12 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Mon, 9 Nov 2020 11:22:16 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 03/11] net: hns3: add support for 1us unit GL configuration
Date:   Mon, 9 Nov 2020 11:22:31 +0800
Message-ID: <1604892159-19990-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1604892159-19990-1-git-send-email-tanhuazhong@huawei.com>
References: <1604892159-19990-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For device whose version is above V3(include V3), the GL
configuration can set as 1us unit, so adds support for
configuring this field.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 26 ++++++++++++++++++----
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  3 +++
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  6 +++++
 3 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 6e08719..2813fe5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -224,17 +224,27 @@ void hns3_set_vector_coalesce_rl(struct hns3_enet_tqp_vector *tqp_vector,
 void hns3_set_vector_coalesce_rx_gl(struct hns3_enet_tqp_vector *tqp_vector,
 				    u32 gl_value)
 {
-	u32 rx_gl_reg = hns3_gl_usec_to_reg(gl_value);
+	u32 new_val;
 
-	writel(rx_gl_reg, tqp_vector->mask_addr + HNS3_VECTOR_GL0_OFFSET);
+	if (tqp_vector->rx_group.coal.unit_1us)
+		new_val = gl_value | HNS3_INT_GL_1US;
+	else
+		new_val = hns3_gl_usec_to_reg(gl_value);
+
+	writel(new_val, tqp_vector->mask_addr + HNS3_VECTOR_GL0_OFFSET);
 }
 
 void hns3_set_vector_coalesce_tx_gl(struct hns3_enet_tqp_vector *tqp_vector,
 				    u32 gl_value)
 {
-	u32 tx_gl_reg = hns3_gl_usec_to_reg(gl_value);
+	u32 new_val;
+
+	if (tqp_vector->tx_group.coal.unit_1us)
+		new_val = gl_value | HNS3_INT_GL_1US;
+	else
+		new_val = hns3_gl_usec_to_reg(gl_value);
 
-	writel(tx_gl_reg, tqp_vector->mask_addr + HNS3_VECTOR_GL1_OFFSET);
+	writel(new_val, tqp_vector->mask_addr + HNS3_VECTOR_GL1_OFFSET);
 }
 
 void hns3_set_vector_coalesce_tx_ql(struct hns3_enet_tqp_vector *tqp_vector,
@@ -272,6 +282,14 @@ static void hns3_vector_coalesce_init(struct hns3_enet_tqp_vector *tqp_vector,
 	rx_coal->flow_level = HNS3_FLOW_LOW;
 	tx_coal->flow_level = HNS3_FLOW_LOW;
 
+	/* device version above V3(include V3), GL can configure 1us
+	 * unit, so uses 1us unit.
+	 */
+	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V3) {
+		tx_coal->unit_1us = 1;
+		rx_coal->unit_1us = 1;
+	}
+
 	if (ae_dev->dev_specs.int_ql_max) {
 		tx_coal->ql_enable = 1;
 		rx_coal->ql_enable = 1;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index be099dd..4651ad1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -425,6 +425,8 @@ enum hns3_flow_level_range {
 #define HNS3_INT_GL_18K			0x0036
 #define HNS3_INT_GL_8K			0x007C
 
+#define HNS3_INT_GL_1US			BIT(31)
+
 #define HNS3_INT_RL_MAX			0x00EC
 #define HNS3_INT_RL_ENABLE_MASK		0x40
 
@@ -436,6 +438,7 @@ struct hns3_enet_coalesce {
 	u16 int_ql_max;
 	u8 gl_adapt_enable:1;
 	u8 ql_enable:1;
+	u8 unit_1us:1;
 	enum hns3_flow_level_range flow_level;
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 9e90d67..8d5c194 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1148,6 +1148,12 @@ static int hns3_check_gl_coalesce_para(struct net_device *netdev,
 		return -EINVAL;
 	}
 
+	/* device version above V3(include V3), GL uses 1us unit,
+	 * so the round down is not needed.
+	 */
+	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V3)
+		return 0;
+
 	rx_gl = hns3_gl_round_down(cmd->rx_coalesce_usecs);
 	if (rx_gl != cmd->rx_coalesce_usecs) {
 		netdev_info(netdev,
-- 
2.7.4

