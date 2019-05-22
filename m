Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E74926FD6
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 22:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730859AbfEVTXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:23:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729898AbfEVTXV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:23:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3500020879;
        Wed, 22 May 2019 19:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553000;
        bh=ohwL04BOh4ZgawOxZX/3E1Brr5PMk/Jb/8Hs5x/j9lQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1of2dmi5lXNNjQ+1lGnt38HrbzVV6yYwYDaoxQ64foH+zX08t9+JHw0okQ25HeSCC
         BNpcxWdjW4BXrVbQDRa5eQ7Hd1WdJB8TGL4t4JP1XdXSeB/14p6B2mrLolqE1eMD9j
         sO01YMcaOqAcUGyohIvrv5404smCoG6bK/HwrAoU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huazhong Tan <tanhuazhong@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 069/375] net: hns3: fix pause configure fail problem
Date:   Wed, 22 May 2019 15:16:09 -0400
Message-Id: <20190522192115.22666-69-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192115.22666-1-sashal@kernel.org>
References: <20190522192115.22666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>

[ Upstream commit fba2efdae8b4f998f66a2ff4c9f0575e1c4bbc40 ]

When configure pause, current implementation returns directly
after setup PFC without setup BP, which is not sufficient.

So this patch fixes it, only return while setting PFC failed.

Fixes: 44e59e375bf7 ("net: hns3: do not return GE PFC setting err when initializing")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index aafc69f4bfdd6..a7bbb6d3091a6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -1331,8 +1331,11 @@ int hclge_pause_setup_hw(struct hclge_dev *hdev, bool init)
 	ret = hclge_pfc_setup_hw(hdev);
 	if (init && ret == -EOPNOTSUPP)
 		dev_warn(&hdev->pdev->dev, "GE MAC does not support pfc\n");
-	else
+	else if (ret) {
+		dev_err(&hdev->pdev->dev, "config pfc failed! ret = %d\n",
+			ret);
 		return ret;
+	}
 
 	return hclge_tm_bp_setup(hdev);
 }
-- 
2.20.1

