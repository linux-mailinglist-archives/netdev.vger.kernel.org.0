Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 345AD491771
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347586AbiARClg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:41:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344793AbiARCh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:37:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC9EC0612EE;
        Mon, 17 Jan 2022 18:33:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF758611A5;
        Tue, 18 Jan 2022 02:33:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E64C36AE3;
        Tue, 18 Jan 2022 02:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473238;
        bh=m1BlRPMjqADOPfF+pcH7G6HNhcalXPTaj0y9Fw/8EN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mLjlSzXSmw77kSCbvzTiCchmIg/LUeYBrrz+cu0t2vYPYaYTaEv+JLWcYbnlFZMii
         DT43SvzmltUZH9ZmEBsmvBrlbdmQu6fG551P8wpMpnfT88faGfvyq69bnaf2nwg4UP
         LQ81KZ4gHYz8mnWA2G2SEctsbmd1Ng1aX+MwWNERdDpNnA7MKUJTF1UPLdCn7C5mNy
         AMMtP5tUMEmaGUCvKesmr6fNvb1U4hKCrd8qqcOq/PVsCJsl+vgB8QThmTarz5pUwm
         pgb7bcfLDspr0Ygj80BdRZnHoaSbypPVD46sB/EtOPUpztAT/AJZNEQL/mVxQ9Fy4W
         FWHV5T/dBq6lg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        u.kleine-koenig@pengutronix.de, fthain@linux-m68k.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 036/188] 8390: mac8390: use eth_hw_addr_set()
Date:   Mon, 17 Jan 2022 21:29:20 -0500
Message-Id: <20220118023152.1948105-36-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
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

