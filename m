Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3713E350FA3
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 08:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233470AbhDAG5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 02:57:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233376AbhDAG51 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 02:57:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63D9361057;
        Thu,  1 Apr 2021 06:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617260247;
        bh=qqgym3ZImLzrZ/bfAC2kk5LAa27jppiee5uZ74LdJAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fjodSnuamgAja9u/n212mR6hYLFz2ZP74lU4/Fqme4uJKpq/+TyE97k7BXc17hCJY
         vXUYpoXtdGrlecbiyZd9MrOFyMWzAzu+GTCBoB2b6XpooA5HDNmAHf4MSQkuVX5+DK
         wg8PQs0nhe6YfZyWTS5kayaBQJuzzkJZuwjYtKCydmUOjzrqWHxNoyYqOJJehelbqL
         WHkULfyJiGQ804+Y/tiRcIHn8pDhjALU3J8f2RFeRBV2wHT/rclWKw4v/gbPoTUezB
         ZNnrDMUhTZfahH/+Td+Ngh/d1eN3jqECoSyImWcOnajIJBK2MDLTAwkXlKRQzYZ74e
         EKlswLbV6UpKA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Michael Chan <michael.chan@broadcom.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        netdev@vger.kernel.org, Selvin Xavier <selvin.xavier@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Subject: [PATCH rdma-next v2 3/5] RDMA/bnxt_re: Get rid of custom module reference counting
Date:   Thu,  1 Apr 2021 09:57:13 +0300
Message-Id: <20210401065715.565226-4-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210401065715.565226-1-leon@kernel.org>
References: <20210401065715.565226-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Instead of manually messing with parent driver module reference
counting rely on export symbol mechanism to ensure that proper
probe/remove chain is performed.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/bnxt_re/main.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 140c54ee5916..8bfbf0231a9e 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -601,13 +601,6 @@ static struct bnxt_re_dev *bnxt_re_from_netdev(struct net_device *netdev)
 	return container_of(ibdev, struct bnxt_re_dev, ibdev);
 }
 
-static void bnxt_re_dev_unprobe(struct net_device *netdev,
-				struct bnxt_en_dev *en_dev)
-{
-	dev_put(netdev);
-	module_put(en_dev->pdev->driver->driver.owner);
-}
-
 static struct bnxt_en_dev *bnxt_re_dev_probe(struct net_device *netdev)
 {
 	struct bnxt_en_dev *en_dev;
@@ -628,10 +621,6 @@ static struct bnxt_en_dev *bnxt_re_dev_probe(struct net_device *netdev)
 		return ERR_PTR(-ENODEV);
 	}
 
-	/* Bump net device reference count */
-	if (!try_module_get(pdev->driver->driver.owner))
-		return ERR_PTR(-ENODEV);
-
 	dev_hold(netdev);
 
 	return en_dev;
@@ -1558,13 +1547,12 @@ static int bnxt_re_dev_init(struct bnxt_re_dev *rdev, u8 wqe_mode)
 
 static void bnxt_re_dev_unreg(struct bnxt_re_dev *rdev)
 {
-	struct bnxt_en_dev *en_dev = rdev->en_dev;
 	struct net_device *netdev = rdev->netdev;
 
 	bnxt_re_dev_remove(rdev);
 
 	if (netdev)
-		bnxt_re_dev_unprobe(netdev, en_dev);
+		dev_put(netdev);
 }
 
 static int bnxt_re_dev_reg(struct bnxt_re_dev **rdev, struct net_device *netdev)
@@ -1586,7 +1574,7 @@ static int bnxt_re_dev_reg(struct bnxt_re_dev **rdev, struct net_device *netdev)
 	*rdev = bnxt_re_dev_add(netdev, en_dev);
 	if (!*rdev) {
 		rc = -ENOMEM;
-		bnxt_re_dev_unprobe(netdev, en_dev);
+		dev_put(netdev);
 		goto exit;
 	}
 exit:
-- 
2.30.2

