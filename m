Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A354496E77
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 01:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235313AbiAWAMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 19:12:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40802 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235174AbiAWAMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 19:12:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 028ECB80924;
        Sun, 23 Jan 2022 00:11:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22BEC36AE3;
        Sun, 23 Jan 2022 00:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642896716;
        bh=wlev53RohC18v85rZCDSZmJYzwQ/o/N7TSr+PrRz6fc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ueXyD1SGJpr9jie7JSyEJL3s07xtqFkJoxNcMdwvtHM80qAWQMECM6tOu6oOZQasR
         XvbBaq89AE3ywYLNBiWX1DHBlPgYyLnTqD7UNFDF5zVXbJYPuCpFGjyWrOKsr+hx8j
         6uWJL5EaqCuegE8LhWCYAWKjGRmEE4Rgy271BeaTfcIl0YZo8GNbRshwbDQ/tMuoAJ
         3Kbm4VxohI7MiVihxp0Afx0zneyKrO1kmcXIFdkDqF1y3WWKQprKMLWc2gGlzq6iRU
         VsYKmQodAO/5/MuX14av5aN2Pu8HR2SFlGTNyQCJj6dWYCmx8MvlVErDo8dOUmMOE3
         s1Lk4NRmldTFA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, tanghui20@huawei.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 11/19] net: apple: mace: Fix build since dev_addr constification
Date:   Sat, 22 Jan 2022 19:11:04 -0500
Message-Id: <20220123001113.2460140-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220123001113.2460140-1-sashal@kernel.org>
References: <20220123001113.2460140-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 6c8dc12cd925e5fa8c152633338b2b35c4c89258 ]

Since commit adeef3e32146 ("net: constify netdev->dev_addr") the mace
driver no longer builds with various errors (pmac32_defconfig):

  linux/drivers/net/ethernet/apple/mace.c: In function ‘mace_probe’:
  linux/drivers/net/ethernet/apple/mace.c:170:20: error: assignment of read-only location ‘*(dev->dev_addr + (sizetype)j)’
    170 |   dev->dev_addr[j] = rev ? bitrev8(addr[j]): addr[j];
        |                    ^
  linux/drivers/net/ethernet/apple/mace.c: In function ‘mace_reset’:
  linux/drivers/net/ethernet/apple/mace.c:349:32: warning: passing argument 2 of ‘__mace_set_address’ discards ‘const’ qualifier from pointer target type
    349 |     __mace_set_address(dev, dev->dev_addr);
        |                             ~~~^~~~~~~~~~
  linux/drivers/net/ethernet/apple/mace.c:93:62: note: expected ‘void *’ but argument is of type ‘const unsigned char *’
     93 | static void __mace_set_address(struct net_device *dev, void *addr);
        |                                                        ~~~~~~^~~~
  linux/drivers/net/ethernet/apple/mace.c: In function ‘__mace_set_address’:
  linux/drivers/net/ethernet/apple/mace.c:388:36: error: assignment of read-only location ‘*(dev->dev_addr + (sizetype)i)’
    388 |  out_8(&mb->padr, dev->dev_addr[i] = p[i]);
        |                                    ^

Fix it by making the modifications to a local macaddr variable and then
passing that to eth_hw_addr_set(), as well as adding some missing const
qualifiers.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/apple/mace.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/apple/mace.c b/drivers/net/ethernet/apple/mace.c
index 4b80e3a52a199..6f8c91eb1263d 100644
--- a/drivers/net/ethernet/apple/mace.c
+++ b/drivers/net/ethernet/apple/mace.c
@@ -90,7 +90,7 @@ static void mace_set_timeout(struct net_device *dev);
 static void mace_tx_timeout(struct timer_list *t);
 static inline void dbdma_reset(volatile struct dbdma_regs __iomem *dma);
 static inline void mace_clean_rings(struct mace_data *mp);
-static void __mace_set_address(struct net_device *dev, void *addr);
+static void __mace_set_address(struct net_device *dev, const void *addr);
 
 /*
  * If we can't get a skbuff when we need it, we use this area for DMA.
@@ -112,6 +112,7 @@ static int mace_probe(struct macio_dev *mdev, const struct of_device_id *match)
 	struct net_device *dev;
 	struct mace_data *mp;
 	const unsigned char *addr;
+	u8 macaddr[ETH_ALEN];
 	int j, rev, rc = -EBUSY;
 
 	if (macio_resource_count(mdev) != 3 || macio_irq_count(mdev) != 3) {
@@ -167,8 +168,9 @@ static int mace_probe(struct macio_dev *mdev, const struct of_device_id *match)
 
 	rev = addr[0] == 0 && addr[1] == 0xA0;
 	for (j = 0; j < 6; ++j) {
-		dev->dev_addr[j] = rev ? bitrev8(addr[j]): addr[j];
+		macaddr[j] = rev ? bitrev8(addr[j]): addr[j];
 	}
+	eth_hw_addr_set(dev, macaddr);
 	mp->chipid = (in_8(&mp->mace->chipid_hi) << 8) |
 			in_8(&mp->mace->chipid_lo);
 
@@ -369,11 +371,12 @@ static void mace_reset(struct net_device *dev)
 	out_8(&mb->plscc, PORTSEL_GPSI + ENPLSIO);
 }
 
-static void __mace_set_address(struct net_device *dev, void *addr)
+static void __mace_set_address(struct net_device *dev, const void *addr)
 {
     struct mace_data *mp = netdev_priv(dev);
     volatile struct mace __iomem *mb = mp->mace;
-    unsigned char *p = addr;
+    const unsigned char *p = addr;
+    u8 macaddr[ETH_ALEN];
     int i;
 
     /* load up the hardware address */
@@ -385,7 +388,10 @@ static void __mace_set_address(struct net_device *dev, void *addr)
 	    ;
     }
     for (i = 0; i < 6; ++i)
-	out_8(&mb->padr, dev->dev_addr[i] = p[i]);
+        out_8(&mb->padr, macaddr[i] = p[i]);
+
+    eth_hw_addr_set(dev, macaddr);
+
     if (mp->chipid != BROKEN_ADDRCHG_REV)
         out_8(&mb->iac, 0);
 }
-- 
2.34.1

