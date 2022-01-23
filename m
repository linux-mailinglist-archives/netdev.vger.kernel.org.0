Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE08A496EEE
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 01:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235959AbiAWAPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 19:15:23 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:46678 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235554AbiAWAOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 19:14:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6D7F3CE0ACE;
        Sun, 23 Jan 2022 00:14:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DEA8C004E1;
        Sun, 23 Jan 2022 00:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642896854;
        bh=jMezY4ErgndL5lwhGLediPZvGIjT3uL9MZNRLqXdn0A=;
        h=From:To:Cc:Subject:Date:From;
        b=TWG4vP24Ti9kTz0cEyQAXu+gxxWOCncA9+fbhJPNidEYcBMu3aG9eSoBmUtRY2dCa
         JlK1Yk4W7k3cnoH5ByvzHD95eZQWIMCQ9Bx7KozQ+ndXtDp5hxw9MeZ3imbyDZJdAa
         qDSAUi5gyi88sAvBtWqserM4IhFkA2RbO2iRlQwO2AVxBRR7hkH4D/97Hxljv+all7
         kHyRNHBCoN6jegnEvnGqNnx7IagtlXfO7kQmCh+9UAbQGWbN2qz7FiarTSsIBYMQz8
         gGTf+/u5ZcuZVmL01yiBNwmuS+ErfnrE37dYMA7qaJF/zSAsE6YtdbI0N+dIrZSjY9
         eI3dq4Spy4CLQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, tanghui20@huawei.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 1/4] net: apple: mace: Fix build since dev_addr constification
Date:   Sat, 22 Jan 2022 19:14:07 -0500
Message-Id: <20220123001412.2460945-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
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
index e58b157b7d7c4..5f1a8673aa605 100644
--- a/drivers/net/ethernet/apple/mace.c
+++ b/drivers/net/ethernet/apple/mace.c
@@ -89,7 +89,7 @@ static void mace_set_timeout(struct net_device *dev);
 static void mace_tx_timeout(unsigned long data);
 static inline void dbdma_reset(volatile struct dbdma_regs __iomem *dma);
 static inline void mace_clean_rings(struct mace_data *mp);
-static void __mace_set_address(struct net_device *dev, void *addr);
+static void __mace_set_address(struct net_device *dev, const void *addr);
 
 /*
  * If we can't get a skbuff when we need it, we use this area for DMA.
@@ -111,6 +111,7 @@ static int mace_probe(struct macio_dev *mdev, const struct of_device_id *match)
 	struct net_device *dev;
 	struct mace_data *mp;
 	const unsigned char *addr;
+	u8 macaddr[ETH_ALEN];
 	int j, rev, rc = -EBUSY;
 
 	if (macio_resource_count(mdev) != 3 || macio_irq_count(mdev) != 3) {
@@ -166,8 +167,9 @@ static int mace_probe(struct macio_dev *mdev, const struct of_device_id *match)
 
 	rev = addr[0] == 0 && addr[1] == 0xA0;
 	for (j = 0; j < 6; ++j) {
-		dev->dev_addr[j] = rev ? bitrev8(addr[j]): addr[j];
+		macaddr[j] = rev ? bitrev8(addr[j]): addr[j];
 	}
+	eth_hw_addr_set(dev, macaddr);
 	mp->chipid = (in_8(&mp->mace->chipid_hi) << 8) |
 			in_8(&mp->mace->chipid_lo);
 
@@ -368,11 +370,12 @@ static void mace_reset(struct net_device *dev)
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
@@ -384,7 +387,10 @@ static void __mace_set_address(struct net_device *dev, void *addr)
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

