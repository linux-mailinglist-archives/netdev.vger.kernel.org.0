Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19239273840
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 03:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbgIVB7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 21:59:32 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14204 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728501AbgIVB7c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 21:59:32 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 6B0108B4805C26644EC1;
        Tue, 22 Sep 2020 09:59:30 +0800 (CST)
Received: from SWX921481.china.huawei.com (10.126.201.120) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Tue, 22 Sep 2020 09:59:19 +0800
From:   Barry Song <song.bao.hua@hisilicon.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Barry Song <song.bao.hua@hisilicon.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>
Subject: [PATCH] net: allwinner: remove redundant irqsave and irqrestore in hardIRQ
Date:   Tue, 22 Sep 2020 13:56:15 +1200
Message-ID: <20200922015615.19212-1-song.bao.hua@hisilicon.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.126.201.120]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The comment "holders of db->lock must always block IRQs" and related
code to do irqsave and irqrestore don't make sense since we are in a
IRQ-disabled hardIRQ context.

Cc: Maxime Ripard <mripard@kernel.org>
Cc: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
---
 drivers/net/ethernet/allwinner/sun4i-emac.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index b3b8a8010142..862ea44beea7 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -640,13 +640,11 @@ static irqreturn_t emac_interrupt(int irq, void *dev_id)
 	struct net_device *dev = dev_id;
 	struct emac_board_info *db = netdev_priv(dev);
 	int int_status;
-	unsigned long flags;
 	unsigned int reg_val;
 
 	/* A real interrupt coming */
 
-	/* holders of db->lock must always block IRQs */
-	spin_lock_irqsave(&db->lock, flags);
+	spin_lock(&db->lock);
 
 	/* Disable all interrupts */
 	writel(0, db->membase + EMAC_INT_CTL_REG);
@@ -680,7 +678,7 @@ static irqreturn_t emac_interrupt(int irq, void *dev_id)
 		reg_val |= (0xf << 0) | (0x01 << 8);
 		writel(reg_val, db->membase + EMAC_INT_CTL_REG);
 	}
-	spin_unlock_irqrestore(&db->lock, flags);
+	spin_unlock(&db->lock);
 
 	return IRQ_HANDLED;
 }
-- 
2.25.1

