Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01BF7433980
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 17:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbhJSPCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 11:02:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:53216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233084AbhJSPCb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 11:02:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8E7F6137E;
        Tue, 19 Oct 2021 15:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634655619;
        bh=qJQmKjLpkCQkQpxDCEvoSnYi8BuwTNLgap+4JbNvHqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iwot5/pa9XWQ4Qi3eP4dzM3kBKZLVXg7KaoDRwPWx0/YGeYNW5ZkRe3GOifYotYXG
         W1zTfs8XT/Kx4rfEITg7a1sX0oFVcNua+RUW3kp7GFxuDtPXIFy6/6loFjtMxxQKLo
         CV1iBtOta5I2mWKyLxlKyv2+r16qWpeavdeqk6pBPvB3EdJVMbl321Ke0OzLrB5VZi
         LDRYj+E5Do4b49+6uSG61gPXTWj7biDNDK6GbECnf+Vjbg2LPPkYKykR04y2+IWvnn
         mu/j32S/4pk1t5Mc9FxiacUHZCjQ3n4dsxLFci9hzGBSCX070IhukSt+HE8vzMgZSC
         +mKccopx/2C0w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        chessman@tux.org
Subject: [PATCH net-next 4/6] ethernet: tlan: use eth_hw_addr_set()
Date:   Tue, 19 Oct 2021 08:00:09 -0700
Message-Id: <20211019150011.1355755-5-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211019150011.1355755-1-kuba@kernel.org>
References: <20211019150011.1355755-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Read the address into an array on the stack, do the swapping, then
call eth_hw_addr_set().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: chessman@tux.org
---
 drivers/net/ethernet/ti/tlan.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.c
index eab7d78d7c72..741c42c6a417 100644
--- a/drivers/net/ethernet/ti/tlan.c
+++ b/drivers/net/ethernet/ti/tlan.c
@@ -817,6 +817,7 @@ static int tlan_init(struct net_device *dev)
 	int		err;
 	int		i;
 	struct tlan_priv	*priv;
+	u8 addr[ETH_ALEN];
 
 	priv = netdev_priv(dev);
 
@@ -842,7 +843,7 @@ static int tlan_init(struct net_device *dev)
 	for (i = 0; i < ETH_ALEN; i++)
 		err |= tlan_ee_read_byte(dev,
 					 (u8) priv->adapter->addr_ofs + i,
-					 (u8 *) &dev->dev_addr[i]);
+					 addr + i);
 	if (err) {
 		pr_err("%s: Error reading MAC from eeprom: %d\n",
 		       dev->name, err);
@@ -850,11 +851,12 @@ static int tlan_init(struct net_device *dev)
 	/* Olicom OC-2325/OC-2326 have the address byte-swapped */
 	if (priv->adapter->addr_ofs == 0xf8) {
 		for (i = 0; i < ETH_ALEN; i += 2) {
-			char tmp = dev->dev_addr[i];
-			dev->dev_addr[i] = dev->dev_addr[i + 1];
-			dev->dev_addr[i + 1] = tmp;
+			char tmp = addr[i];
+			addr[i] = addr[i + 1];
+			addr[i + 1] = tmp;
 		}
 	}
+	eth_hw_addr_set(dev, addr);
 
 	netif_carrier_off(dev);
 
-- 
2.31.1

