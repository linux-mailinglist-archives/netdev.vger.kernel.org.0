Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 937F8468AA5
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 12:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233387AbhLELzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 06:55:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49354 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233115AbhLELzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 06:55:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89609B80E16;
        Sun,  5 Dec 2021 11:51:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421C0C341C1;
        Sun,  5 Dec 2021 11:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638705104;
        bh=ie+oT2aZFuAcAfutGFNsfXVLPx78WoYGUZ15+v+3MZA=;
        h=From:To:Cc:Subject:Date:From;
        b=ZFPcjNRY+4hxTXvvsjkSZKiXqIxXrToaWpFUpbNPbVpGQ9hgrXEndJi8f1wpX1ur4
         waufIeWZqPrY8pt/8Y/W4HANRroqYKI3bsK+TaBypNbknDYiwtjKleEnKTSt+G/p5T
         BnCkNecuL3Qv2TLFT9oOjCX57dxuUEFoHnbTxPg4lWCKEVs21910RCASPs6KYShHML
         87RkZE+AdLFOU7jEza+UTrrv5I6T44yqv0Gi+J0Fyxieq43ZCnB+cDBckiD31OGMcj
         PyjRuBUTKDcTWoVGCBHoOK+hxJGd7cn+uYkPWQ+s5URrKrSizzphXCBLsQsOYBqVPQ
         95E3hgGY3E6XA==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Salil Mehta <salil.mehta@huawei.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: [PATCH net-next] Revert "net: hns3: add void before function which don't receive ret"
Date:   Sun,  5 Dec 2021 13:51:37 +0200
Message-Id: <ec8b4004475049060d03fd71b916cbf32858559d.1638705082.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

There are two issues with this patch:
1. devlink_register() doesn't return any value. It is already void.
2. It is not kernel coding at all to cast return type to void.

This reverts commit 5ac4f180bd07116c1e57858bc3f6741adbca3eb6.

Link: https://lore.kernel.org/all/Yan8VDXC0BtBRVGz@unreal
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c   | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
index 9c3199d3c8ee..4c441e6a5082 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
@@ -120,7 +120,7 @@ int hclge_devlink_init(struct hclge_dev *hdev)
 	hdev->devlink = devlink;
 
 	devlink_set_features(devlink, DEVLINK_F_RELOAD);
-	(void)devlink_register(devlink);
+	devlink_register(devlink);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
index 75d2926729d3..fdc19868b818 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
@@ -122,7 +122,7 @@ int hclgevf_devlink_init(struct hclgevf_dev *hdev)
 	hdev->devlink = devlink;
 
 	devlink_set_features(devlink, DEVLINK_F_RELOAD);
-	(void)devlink_register(devlink);
+	devlink_register(devlink);
 	return 0;
 }
 
-- 
2.33.1

