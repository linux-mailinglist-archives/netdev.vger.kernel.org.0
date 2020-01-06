Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F025F131251
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 13:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgAFMy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 07:54:26 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:44220 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725787AbgAFMyZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 07:54:25 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E25709042C21FDDE4C37;
        Mon,  6 Jan 2020 20:54:22 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Mon, 6 Jan 2020
 20:54:16 +0800
From:   yu kuai <yukuai3@huawei.com>
To:     <klassert@kernel.org>, <davem@davemloft.net>,
        <hkallweit1@gmail.com>, <jakub.kicinski@netronome.com>,
        <hslester96@gmail.com>, <mst@redhat.com>, <yang.wei9@zte.com.cn>,
        <willy@infradead.org>, <netdev@vger.kernel.org>
CC:     <yukuai3@huawei.com>, <yi.zhang@huawei.com>,
        <zhengbin13@huawei.com>
Subject: [PATCH V2] net: 3com: 3c59x: remove set but not used variable 'mii_reg1'
Date:   Mon, 6 Jan 2020 20:53:37 +0800
Message-ID: <20200106125337.40297-1-yukuai3@huawei.com>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/ethernet/3com/3c59x.c: In function ‘vortex_up’:
drivers/net/ethernet/3com/3c59x.c:1551:9: warning: variable
‘mii_reg1’ set but not used [-Wunused-but-set-variable]

It is never used, and so can be removed.

Signed-off-by: yu kuai <yukuai3@huawei.com>
---
changes in V2
-The read might have side effects, don't remove it.

 drivers/net/ethernet/3com/3c59x.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
index fc046797c0ea..6e537e5dc208 100644
--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -1548,7 +1548,7 @@ vortex_up(struct net_device *dev)
 	struct vortex_private *vp = netdev_priv(dev);
 	void __iomem *ioaddr = vp->ioaddr;
 	unsigned int config;
-	int i, mii_reg1, mii_reg5, err = 0;
+	int i, mii_reg5, err = 0;
 
 	if (VORTEX_PCI(vp)) {
 		pci_set_power_state(VORTEX_PCI(vp), PCI_D0);	/* Go active */
@@ -1605,7 +1605,6 @@ vortex_up(struct net_device *dev)
 	window_write32(vp, config, 3, Wn3_Config);
 
 	if (dev->if_port == XCVR_MII || dev->if_port == XCVR_NWAY) {
-		mii_reg1 = mdio_read(dev, vp->phys[0], MII_BMSR);
 		mdio_read(dev, vp->phys[0], MII_LPA);
 		vp->partner_flow_ctrl = ((mii_reg5 & 0x0400) != 0);
 		vp->mii.full_duplex = vp->full_duplex;
-- 
2.17.2

