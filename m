Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC95EF62E6
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 03:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbfKJCqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 21:46:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:50410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729083AbfKJCqg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:46:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05C8221848;
        Sun, 10 Nov 2019 02:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353994;
        bh=Fqy9Df9VV1p/fXocuqWjl0pJ6+pzlHmrrdfJKPeH+lM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p/2+1k1iTG4blro8BST/+VdcawFJPr1maghzp+jd/aFq/dCB+stE+XuJ/qVpOCpZB
         CkuTQm0dcS67BGqtLPXV9KpUm3eo5aLtPp0dVQQNL34Pk7UZbIUvvWj1/PuqTuao68
         EC0m+0iUAHaxFRszqW8lJI7sEt6REaMZ2W96tetE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fuyun Liang <liangfuyun1@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 024/109] net: hns3: Fix for setting speed for phy failed problem
Date:   Sat,  9 Nov 2019 21:44:16 -0500
Message-Id: <20191110024541.31567-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
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
index 86523e8993cb9..3bb6181ff0548 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2179,7 +2179,7 @@ static int hclge_get_mac_phy_link(struct hclge_dev *hdev)
 	mac_state = hclge_get_mac_link_status(hdev);
 
 	if (hdev->hw.mac.phydev) {
-		if (!genphy_read_status(hdev->hw.mac.phydev))
+		if (hdev->hw.mac.phydev->state == PHY_RUNNING)
 			link_stat = mac_state &
 				hdev->hw.mac.phydev->link;
 		else
-- 
2.20.1

