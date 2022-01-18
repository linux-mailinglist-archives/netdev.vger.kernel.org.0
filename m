Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81957491468
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239628AbiARCW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:22:29 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36246 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244949AbiARCWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:22:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EC04B8123A;
        Tue, 18 Jan 2022 02:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C1EC36AE3;
        Tue, 18 Jan 2022 02:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472528;
        bh=m1BlRPMjqADOPfF+pcH7G6HNhcalXPTaj0y9Fw/8EN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bVRCLX0ORtNED++wrP4aJ2VvpephpQmOPTvZQLhVvxi1JVVXdQ6OwZsDL1cGn6pPg
         U+QHoEOs73uXwAB2rwW8gTxvWjBuh37FeTlMkws3v2calH3dwO5yonHG6BfK8gEVZb
         40BTYIK4Fa4woYVfk2bcnmQf2k6PIY4fAtX75QuYhYTe+w27u9LzEjznPvMhRrrIu7
         Bij4qckBussQlHHK3Gk3rLJCL7s91YSBVWJoe+8hBsJ8Rh2GRoalapjBjsU84u8y0k
         ot3+vtFSxUTZ3ne5U/VbSExKaJuTfrGDvHJu1ju7hUNCnO4BAJXFD4BtStE3Dj5pVN
         pAyx+pdnmaQ3A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        u.kleine-koenig@pengutronix.de, fthain@linux-m68k.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 042/217] 8390: mac8390: use eth_hw_addr_set()
Date:   Mon, 17 Jan 2022 21:16:45 -0500
Message-Id: <20220118021940.1942199-42-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 973a34c087f43b61b26570110a284faf48d08d5d ]

Use temp to pass to the reading function, the function is generic
so can't fix there.

Fixes m68k build.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/8390/mac8390.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/8390/mac8390.c b/drivers/net/ethernet/8390/mac8390.c
index 91b04abfd6875..7fb819b9b89a5 100644
--- a/drivers/net/ethernet/8390/mac8390.c
+++ b/drivers/net/ethernet/8390/mac8390.c
@@ -292,6 +292,7 @@ static bool mac8390_rsrc_init(struct net_device *dev,
 	struct nubus_dirent ent;
 	int offset;
 	volatile unsigned short *i;
+	u8 addr[ETH_ALEN];
 
 	dev->irq = SLOT2IRQ(board->slot);
 	/* This is getting to be a habit */
@@ -314,7 +315,8 @@ static bool mac8390_rsrc_init(struct net_device *dev,
 		return false;
 	}
 
-	nubus_get_rsrc_mem(dev->dev_addr, &ent, 6);
+	nubus_get_rsrc_mem(addr, &ent, 6);
+	eth_hw_addr_set(dev, addr);
 
 	if (useresources[cardtype] == 1) {
 		nubus_rewinddir(&dir);
-- 
2.34.1

