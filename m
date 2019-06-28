Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3679559977
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 13:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbfF1Lwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 07:52:39 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56944 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726936AbfF1LwQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 07:52:16 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 1FE9EA34AF9716592401;
        Fri, 28 Jun 2019 19:52:11 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Fri, 28 Jun 2019 19:52:00 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Yonglong Liu <liuyonglong@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 06/12] net: hns3: add Asym Pause support to fix autoneg problem
Date:   Fri, 28 Jun 2019 19:50:12 +0800
Message-ID: <1561722618-12168-7-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561722618-12168-1-git-send-email-tanhuazhong@huawei.com>
References: <1561722618-12168-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

Local device and link partner config auto-negotiation on both,
local device config pause frame use as: rx on/tx off,
link partner config pause frame use as: rx off/tx on.

We except the result is:
Local device:
Autonegotiate:  on
RX:             on
TX:             off
RX negotiated:  on
TX negotiated:  off

Link partner:
Autonegotiate:  on
RX:             off
TX:             on
RX negotiated:  off
TX negotiated:  on

But actually, the result of Local device and link partner is both:
Autonegotiate:  on
RX:             off
TX:             off
RX negotiated:  off
TX negotiated:  off

The root cause is that the supported flag is has only Pause,
reference to the function genphy_config_advert():
static int genphy_config_advert(struct phy_device *phydev)
{
	...
	linkmode_and(phydev->advertising, phydev->advertising,
		     phydev->supported);
	...
}
The pause frame use of link partner is rx off/tx on, so its
advertising only set the bit Asym_Pause, and the supported is
only set the bit Pause, so the result of linkmode_and(), is
rx off/tx off.

This patch adds Asym_Pause to the supported flag to fix it.

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 1 +
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index b2faebd..896605f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1061,6 +1061,7 @@ static void hclge_parse_copper_link_mode(struct hclge_dev *hdev,
 	linkmode_set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, supported);
 	linkmode_set_bit(ETHTOOL_LINK_MODE_TP_BIT, supported);
 	linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT, supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, supported);
 }
 
 static void hclge_parse_link_mode(struct hclge_dev *hdev, u8 speed_ability)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
index d906d09..abb1b43 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
@@ -224,6 +224,13 @@ int hclge_mac_connect_phy(struct hnae3_handle *handle)
 	linkmode_and(phydev->supported, phydev->supported, mask);
 	linkmode_copy(phydev->advertising, phydev->supported);
 
+	/* supported flag is Pause and Asym Pause, but default advertising
+	 * should be rx on, tx on, so need clear Asym Pause in advertising
+	 * flag
+	 */
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+			   phydev->advertising);
+
 	return 0;
 }
 
-- 
2.7.4

