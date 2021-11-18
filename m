Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4A745546F
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 06:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243179AbhKRFtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 00:49:53 -0500
Received: from mailgw.kylinos.cn ([123.150.8.42]:62355 "EHLO nksmu.kylinos.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243168AbhKRFtj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 00:49:39 -0500
X-UUID: c0750d918e584a1287ab6027b429c240-20211118
X-UUID: c0750d918e584a1287ab6027b429c240-20211118
X-User: zhangyue1@kylinos.cn
Received: from localhost.localdomain [(172.17.127.2)] by nksmu.kylinos.cn
        (envelope-from <zhangyue1@kylinos.cn>)
        (Generic MTA)
        with ESMTP id 1705651318; Thu, 18 Nov 2021 13:55:16 +0800
From:   zhangyue <zhangyue1@kylinos.cn>
To:     davem@davemloft.net, jesse.brandeburg@intel.com,
        gregkh@linuxfoundation.org, ecree@solarflare.com
Cc:     netdev@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: tulip: de4x5: fix the problem that the array 'lp->phy[8]' may be out of bound
Date:   Thu, 18 Nov 2021 13:46:32 +0800
Message-Id: <20211118054632.357006-1-zhangyue1@kylinos.cn>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In line 5001, if all id in the array 'lp->phy[8]' is not 0, when the
'for' end, the 'k' is 8.

At this time, the array 'lp->phy[8]' may be out of bound.

Signed-off-by: zhangyue <zhangyue1@kylinos.cn>
---
 drivers/net/ethernet/dec/tulip/de4x5.c | 30 +++++++++++++++-----------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/de4x5.c b/drivers/net/ethernet/dec/tulip/de4x5.c
index c813e6f2b371..a80252973171 100644
--- a/drivers/net/ethernet/dec/tulip/de4x5.c
+++ b/drivers/net/ethernet/dec/tulip/de4x5.c
@@ -4999,19 +4999,23 @@ mii_get_phy(struct net_device *dev)
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
2.30.0

