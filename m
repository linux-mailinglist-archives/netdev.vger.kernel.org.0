Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFF55F668E
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 04:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfKJClp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 21:41:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:36460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727557AbfKJClo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:41:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6414215EA;
        Sun, 10 Nov 2019 02:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353703;
        bh=ojGzov/r6HgGqt/xSkwiBfoEhkdH/13yhhdnWmF9/OE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H1tpS4AyyYWc1zzBe4l5ffu9u5mpcyDijnPfODzdBdxy1MMJNVnB3Ip3OIFD/GqkV
         0SS/6rW4WYP9KRW5L1WdMEXHCzEFuzbj+GNKVYsEWpI+lN39Q/MhapKV5NSyjYnXFJ
         X9n7Y0mmQmBoe/O3ND4C0nh4k1NXkjrscTSts0Zo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fuyun Liang <liangfuyun1@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 046/191] net: hns3: Fix for setting speed for phy failed problem
Date:   Sat,  9 Nov 2019 21:37:48 -0500
Message-Id: <20191110024013.29782-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fuyun Liang <liangfuyun1@huawei.com>

[ Upstream commit fd8133148eb6a733f9cfdaecd4d99f378e21d582 ]

The function of genphy_read_status is that reading phy information
from HW and using these information to update SW variable. If user
is using ethtool to setting the speed of phy and service task is calling
by hclge_get_mac_phy_link, the result of speed setting is uncertain.
Because ethtool cmd will modified phydev and hclge_get_mac_phy_link also
will modified phydev.

Because phy state machine will update phy link periodically, we can
just use phydev->link to check the link status. This patch removes
function call of genphy_read_status. To ensure accuracy, this patch
adds a phy state check. If phy state is not PHY_RUNNING, we consider
link is down. Because in some scenarios, phydev->link may be link up,
but phy state is not PHY_RUNNING. This is just an intermediate state.
In fact, the link is not ready yet.

Fixes: 46a3df9f9718 ("net: hns3: Add HNS3 Acceleration Engine & Compatibility Layer Support")
Signed-off-by: Fuyun Liang <liangfuyun1@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 89ca69fa2b97b..6907280d316fb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2367,7 +2367,7 @@ static int hclge_get_mac_phy_link(struct hclge_dev *hdev)
 	mac_state = hclge_get_mac_link_status(hdev);
 
 	if (hdev->hw.mac.phydev) {
-		if (!genphy_read_status(hdev->hw.mac.phydev))
+		if (hdev->hw.mac.phydev->state == PHY_RUNNING)
 			link_stat = mac_state &
 				hdev->hw.mac.phydev->link;
 		else
-- 
2.20.1

