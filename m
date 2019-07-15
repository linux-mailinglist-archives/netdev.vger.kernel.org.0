Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52FE6695D8
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 17:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389021AbfGOOOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:14:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388726AbfGOOOn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:14:43 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B26120651;
        Mon, 15 Jul 2019 14:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200082;
        bh=V2UUxD93vQBdwjlOYFv6XQAhIKfavGXHNogK1GjQ8bs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FSJD58qH3Sw5yxbGu3SV4cVE62kHyS50Wzqib6M0KKe1txSicHlMtUJ0kG58qLXde
         9ii4qAFaWTUo3+TisXKAyz/gy1Pg0EaDnNnrBLfOjQOmA8sdBK/rNVd95Dp+EkObrS
         xhA3RECcUf4rcZcRcqL9Y2xLZevriNWQ3IevSAfs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yonglong Liu <liuyonglong@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 179/219] net: hns3: add Asym Pause support to fix autoneg problem
Date:   Mon, 15 Jul 2019 10:03:00 -0400
Message-Id: <20190715140341.6443-179-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

[ Upstream commit bc3781edcea017aa1a29abd953b776cdba298ce2 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 1 +
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 563eefa20003..14d37c26196b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -889,6 +889,7 @@ static void hclge_parse_copper_link_mode(struct hclge_dev *hdev,
 	linkmode_set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, supported);
 	linkmode_set_bit(ETHTOOL_LINK_MODE_TP_BIT, supported);
 	linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT, supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, supported);
 }
 
 static void hclge_parse_link_mode(struct hclge_dev *hdev, u8 speed_ability)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
index 48eda2c6fdae..71a6f7c734b6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
@@ -215,6 +215,13 @@ int hclge_mac_connect_phy(struct hnae3_handle *handle)
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
2.20.1

