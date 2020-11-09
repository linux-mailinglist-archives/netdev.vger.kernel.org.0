Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92BB62AAFEB
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 04:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729378AbgKIDWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 22:22:34 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:7433 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729329AbgKIDWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 22:22:32 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CTxBN4lrzz74nH;
        Mon,  9 Nov 2020 11:22:20 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Mon, 9 Nov 2020 11:22:16 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 04/11] net: hns3: rename gl_adapt_enable in struct hns3_enet_coalesce
Date:   Mon, 9 Nov 2020 11:22:32 +0800
Message-ID: <1604892159-19990-5-git-send-email-tanhuazhong@huawei.com>
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

Besides GL(Gap Limiting), QL(Quantity Limiting) can be modified
dynamically when DIM is supported. So rename gl_adapt_enable as
adapt_enable in struct hns3_enet_coalesce.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 12 ++++++------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  8 ++++----
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 2813fe5..999a2aa 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -211,8 +211,8 @@ void hns3_set_vector_coalesce_rl(struct hns3_enet_tqp_vector *tqp_vector,
 	 * GL and RL(Rate Limiter) are 2 ways to acheive interrupt coalescing
 	 */
 
-	if (rl_reg > 0 && !tqp_vector->tx_group.coal.gl_adapt_enable &&
-	    !tqp_vector->rx_group.coal.gl_adapt_enable)
+	if (rl_reg > 0 && !tqp_vector->tx_group.coal.adapt_enable &&
+	    !tqp_vector->rx_group.coal.adapt_enable)
 		/* According to the hardware, the range of rl_reg is
 		 * 0-59 and the unit is 4.
 		 */
@@ -273,8 +273,8 @@ static void hns3_vector_coalesce_init(struct hns3_enet_tqp_vector *tqp_vector,
 	 *
 	 * Default: enable interrupt coalescing self-adaptive and GL
 	 */
-	tx_coal->gl_adapt_enable = 1;
-	rx_coal->gl_adapt_enable = 1;
+	tx_coal->adapt_enable = 1;
+	rx_coal->adapt_enable = 1;
 
 	tx_coal->int_gl = HNS3_INT_GL_50K;
 	rx_coal->int_gl = HNS3_INT_GL_50K;
@@ -3384,14 +3384,14 @@ static void hns3_update_new_int_gl(struct hns3_enet_tqp_vector *tqp_vector)
 			tqp_vector->last_jiffies + msecs_to_jiffies(1000)))
 		return;
 
-	if (rx_group->coal.gl_adapt_enable) {
+	if (rx_group->coal.adapt_enable) {
 		rx_update = hns3_get_new_int_gl(rx_group);
 		if (rx_update)
 			hns3_set_vector_coalesce_rx_gl(tqp_vector,
 						       rx_group->coal.int_gl);
 	}
 
-	if (tx_group->coal.gl_adapt_enable) {
+	if (tx_group->coal.adapt_enable) {
 		tx_update = hns3_get_new_int_gl(tx_group);
 		if (tx_update)
 			hns3_set_vector_coalesce_tx_gl(tqp_vector,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 4651ad1..8d33652 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -436,7 +436,7 @@ struct hns3_enet_coalesce {
 	u16 int_gl;
 	u16 int_ql;
 	u16 int_ql_max;
-	u8 gl_adapt_enable:1;
+	u8 adapt_enable:1;
 	u8 ql_enable:1;
 	u8 unit_1us:1;
 	enum hns3_flow_level_range flow_level;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 8d5c194..30ffaaf 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1105,9 +1105,9 @@ static int hns3_get_coalesce_per_queue(struct net_device *netdev, u32 queue,
 	rx_vector = priv->ring[queue_num + queue].tqp_vector;
 
 	cmd->use_adaptive_tx_coalesce =
-			tx_vector->tx_group.coal.gl_adapt_enable;
+			tx_vector->tx_group.coal.adapt_enable;
 	cmd->use_adaptive_rx_coalesce =
-			rx_vector->rx_group.coal.gl_adapt_enable;
+			rx_vector->rx_group.coal.adapt_enable;
 
 	cmd->tx_coalesce_usecs = tx_vector->tx_group.coal.int_gl;
 	cmd->rx_coalesce_usecs = rx_vector->rx_group.coal.int_gl;
@@ -1268,9 +1268,9 @@ static void hns3_set_coalesce_per_queue(struct net_device *netdev,
 	tx_vector = priv->ring[queue].tqp_vector;
 	rx_vector = priv->ring[queue_num + queue].tqp_vector;
 
-	tx_vector->tx_group.coal.gl_adapt_enable =
+	tx_vector->tx_group.coal.adapt_enable =
 				cmd->use_adaptive_tx_coalesce;
-	rx_vector->rx_group.coal.gl_adapt_enable =
+	rx_vector->rx_group.coal.adapt_enable =
 				cmd->use_adaptive_rx_coalesce;
 
 	tx_vector->tx_group.coal.int_gl = cmd->tx_coalesce_usecs;
-- 
2.7.4

