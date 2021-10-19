Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABF9433981
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 17:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbhJSPCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 11:02:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231758AbhJSPCe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 11:02:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20D4E613A1;
        Tue, 19 Oct 2021 15:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634655619;
        bh=0RMvC3DMOP4AlEq82bP1DugbJtK3ZjORqZK6r2XeHAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FYA4GRlS32ziBoTXu2NC6g/hpxRlZJgkM9LT6Dk12AJK3QUU9YsDGftHxRQXPMcK3
         SOBrJY4CdMZ1Ykvo2HKLs4IC6am4PkJmAOrCf6T00INbQ/sYW3d8gl7pUqmEXboH6J
         Yka5DFihh7RyKjRgrRFM8+FhXhk54B+8bRTKnOA+37GNOuxGwdhmzH2Bhky8w6DDJh
         HZAvX3HETK/ByxZI1e2xh5fHy0t3XJF/6qefdcgE2pBUUTr6MlojMzxFjehGF6pVhv
         FYYU2EWehCe5Kf3NKitQ2wDh+SE/+iEdaznzwum2gLnrgizzJa5WSFYillKAYJ2olz
         HRa5zkwh0+LRQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        kevinbrace@bracecomputerlab.com
Subject: [PATCH net-next 5/6] ethernet: via-rhine: use eth_hw_addr_set()
Date:   Tue, 19 Oct 2021 08:00:10 -0700
Message-Id: <20211019150011.1355755-6-kuba@kernel.org>
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

Read the address into an array on the stack, then call
eth_hw_addr_set().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: kevinbrace@bracecomputerlab.com
---
 drivers/net/ethernet/via/via-rhine.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index 3b73a9c55a5a..509c5e9b29df 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -899,6 +899,7 @@ static int rhine_init_one_common(struct device *hwdev, u32 quirks,
 	struct net_device *dev;
 	struct rhine_private *rp;
 	int i, rc, phy_id;
+	u8 addr[ETH_ALEN];
 	const char *name;
 
 	/* this should always be supported */
@@ -933,7 +934,8 @@ static int rhine_init_one_common(struct device *hwdev, u32 quirks,
 	rhine_hw_init(dev, pioaddr);
 
 	for (i = 0; i < 6; i++)
-		dev->dev_addr[i] = ioread8(ioaddr + StationAddr + i);
+		addr[i] = ioread8(ioaddr + StationAddr + i);
+	eth_hw_addr_set(dev, addr);
 
 	if (!is_valid_ether_addr(dev->dev_addr)) {
 		/* Report it and use a random ethernet address instead */
-- 
2.31.1

