Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F083E5BDA
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241623AbhHJNiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:38:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241584AbhHJNiG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 09:38:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B113360FDA;
        Tue, 10 Aug 2021 13:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628602664;
        bh=M7YYC86V3snE++Hi6R8B+ecf16khmRjxEgwHZa+z11c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k3kgXJCoVnKNB9I7tS2aPTM3rtoAWdciNOGImREzupykz2gaoIyIibSPySBOc4o58
         V+VHZbGINFzGVO2mpOkOq5X0WeTyOF1/rDIFVBEL50lmuaSiJBtWrKS1X99hA/Q4zY
         auXe7P0mt9RnNrhf1rnbvh8RqzdCKkeax4OGrvnpBZUqHYfjWedLgmtPf1rzyKxq/8
         PSMANImC+0lmao5bMa9XF1t7PSP06wfYn53xNRJ+kotlFb4CkA2339WvAAGi7WlVdU
         cqxgOuwXtAjAs3tSnYca3MV1WgK5xMdreEkxwtza8mO0vQ2lEERAcY7wqmLbJwXCPM
         DDGHA3NJxRP0A==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>
Subject: [PATCH net-next 1/5] net: hns3: remove always exist devlink pointer check
Date:   Tue, 10 Aug 2021 16:37:31 +0300
Message-Id: <2340cee7b177bf7c8825f61b9798034c77baec32.1628599239.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1628599239.git.leonro@nvidia.com>
References: <cover.1628599239.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The devlink pointer always exists after hclge_devlink_init() succeed.
Remove that check together with NULL setting after release and ensure
that devlink_register is last command prior to call to devlink_reload_enable().

Fixes: b741269b2759 ("net: hns3: add support for registering devlink for PF")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c    | 8 +-------
 .../net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c  | 8 +-------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
index 448f29aa4e6b..e4aad695abcc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
@@ -118,6 +118,7 @@ int hclge_devlink_init(struct hclge_dev *hdev)
 
 	priv = devlink_priv(devlink);
 	priv->hdev = hdev;
+	hdev->devlink = devlink;
 
 	ret = devlink_register(devlink);
 	if (ret) {
@@ -126,8 +127,6 @@ int hclge_devlink_init(struct hclge_dev *hdev)
 		goto out_reg_fail;
 	}
 
-	hdev->devlink = devlink;
-
 	devlink_reload_enable(devlink);
 
 	return 0;
@@ -141,14 +140,9 @@ void hclge_devlink_uninit(struct hclge_dev *hdev)
 {
 	struct devlink *devlink = hdev->devlink;
 
-	if (!devlink)
-		return;
-
 	devlink_reload_disable(devlink);
 
 	devlink_unregister(devlink);
 
 	devlink_free(devlink);
-
-	hdev->devlink = NULL;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
index 1e6061fb8ed4..f478770299c6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
@@ -120,6 +120,7 @@ int hclgevf_devlink_init(struct hclgevf_dev *hdev)
 
 	priv = devlink_priv(devlink);
 	priv->hdev = hdev;
+	hdev->devlink = devlink;
 
 	ret = devlink_register(devlink);
 	if (ret) {
@@ -128,8 +129,6 @@ int hclgevf_devlink_init(struct hclgevf_dev *hdev)
 		goto out_reg_fail;
 	}
 
-	hdev->devlink = devlink;
-
 	devlink_reload_enable(devlink);
 
 	return 0;
@@ -143,14 +142,9 @@ void hclgevf_devlink_uninit(struct hclgevf_dev *hdev)
 {
 	struct devlink *devlink = hdev->devlink;
 
-	if (!devlink)
-		return;
-
 	devlink_reload_disable(devlink);
 
 	devlink_unregister(devlink);
 
 	devlink_free(devlink);
-
-	hdev->devlink = NULL;
 }
-- 
2.31.1

