Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0795345E625
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 04:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359627AbhKZCtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 21:49:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:50770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357796AbhKZCqM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 21:46:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FC476136F;
        Fri, 26 Nov 2021 02:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894216;
        bh=FrYRzC9RMzsN9T8M4PFLTdVZC58KrKh8sovKEllXWac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S6GWaA256qwxoNNJDln0My5YBAK7XCQ0a8FqclFnr6DXoXr1gaz1SGALxKCLBSl4y
         7RMOhcX0Ah1kVFBxWmhoeI2de1nWEYSlNbPUqejpWRFani+qs9+HJyqrjn4Dkr1kPO
         0hdDS13/IRy51ezChAbHRcmT43DNuPnJHkmMIAYEBcRzV+3JBMwZ5F9LUOVCpMp1oG
         R/m+206gQciYcrGQYbl0hJ+GRQBLMnIgVDUKGewlGpfUiA0vtWDTK9vvkutFK6zRf3
         SpPGdT56/UEcYC+gjbz4vhCr4809mTkskGEeN/OfEQyflWRLlhvBdO0GJA1pd4+7jk
         9qF/GmVIGOp9Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhangyue <zhangyue1@kylinos.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        arnd@arndb.de, tanghui20@huawei.com, starmiku1207184332@gmail.com,
        netdev@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 7/8] net: tulip: de4x5: fix the problem that the array 'lp->phy[8]' may be out of bound
Date:   Thu, 25 Nov 2021 21:36:39 -0500
Message-Id: <20211126023640.443271-7-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023640.443271-1-sashal@kernel.org>
References: <20211126023640.443271-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zhangyue <zhangyue1@kylinos.cn>

[ Upstream commit 61217be886b5f7402843677e4be7e7e83de9cb41 ]

In line 5001, if all id in the array 'lp->phy[8]' is not 0, when the
'for' end, the 'k' is 8.

At this time, the array 'lp->phy[8]' may be out of bound.

Signed-off-by: zhangyue <zhangyue1@kylinos.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/dec/tulip/de4x5.c | 30 +++++++++++++++-----------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/de4x5.c b/drivers/net/ethernet/dec/tulip/de4x5.c
index 005c79b5b3f01..b39e8315e4e27 100644
--- a/drivers/net/ethernet/dec/tulip/de4x5.c
+++ b/drivers/net/ethernet/dec/tulip/de4x5.c
@@ -4995,19 +4995,23 @@ mii_get_phy(struct net_device *dev)
 	}
 	if ((j == limit) && (i < DE4X5_MAX_MII)) {
 	    for (k=0; k < DE4X5_MAX_PHY && lp->phy[k].id; k++);
-	    lp->phy[k].addr = i;
-	    lp->phy[k].id = id;
-	    lp->phy[k].spd.reg = GENERIC_REG;      /* ANLPA register         */
-	    lp->phy[k].spd.mask = GENERIC_MASK;    /* 100Mb/s technologies   */
-	    lp->phy[k].spd.value = GENERIC_VALUE;  /* TX & T4, H/F Duplex    */
-	    lp->mii_cnt++;
-	    lp->active++;
-	    printk("%s: Using generic MII device control. If the board doesn't operate,\nplease mail the following dump to the author:\n", dev->name);
-	    j = de4x5_debug;
-	    de4x5_debug |= DEBUG_MII;
-	    de4x5_dbg_mii(dev, k);
-	    de4x5_debug = j;
-	    printk("\n");
+	    if (k < DE4X5_MAX_PHY) {
+		lp->phy[k].addr = i;
+		lp->phy[k].id = id;
+		lp->phy[k].spd.reg = GENERIC_REG;      /* ANLPA register         */
+		lp->phy[k].spd.mask = GENERIC_MASK;    /* 100Mb/s technologies   */
+		lp->phy[k].spd.value = GENERIC_VALUE;  /* TX & T4, H/F Duplex    */
+		lp->mii_cnt++;
+		lp->active++;
+		printk("%s: Using generic MII device control. If the board doesn't operate,\nplease mail the following dump to the author:\n", dev->name);
+		j = de4x5_debug;
+		de4x5_debug |= DEBUG_MII;
+		de4x5_dbg_mii(dev, k);
+		de4x5_debug = j;
+		printk("\n");
+	    } else {
+		goto purgatory;
+	    }
 	}
     }
   purgatory:
-- 
2.33.0

