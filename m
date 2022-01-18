Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE22491473
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244915AbiARCWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:22:40 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38646 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244898AbiARCV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:21:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A5D4612D0;
        Tue, 18 Jan 2022 02:21:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE17DC36AEF;
        Tue, 18 Jan 2022 02:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472518;
        bh=Y/Jg8zxEhlm7oR/BvTYZFwWEmKlAwuzQhC1L+ZRMTg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uQTz3VSlsEoxqJa3vbXmRpmwzPe66eLLU79x+ffQVIgvXq6L/0gjYXd2ffsT9RBVz
         m41Aabm5EYS8T05sjoyZJu0Zr35o9TDcMNFYVP3WXGyF7lGthAH4V0fuFFWOgVGxcv
         eZ8genwaG9lMcdskzR97byLzQJXMfYSlMP0PGwMwAOm/pKI6kFajqUjyIEIIqpXote
         k3OicLnhe+TVL//RTF69zeLrXZCB3wxjp29NIA9VpXQnLDLVaSGYj78TxKqDdEF+hV
         RxrGWKSmHTFSvwHf5aMoPYIQwKmos1czTB62TMINE9sIPCIgt8a9i8u1dcDDDWlWoJ
         DqG+Ddy0aSIbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, arnd@arndb.de,
        geert@linux-m68k.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 039/217] amd: mvme147: use eth_hw_addr_set()
Date:   Mon, 17 Jan 2022 21:16:42 -0500
Message-Id: <20220118021940.1942199-39-sashal@kernel.org>
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

[ Upstream commit cc71b8b9376ff5072d23b191654408c144dac6aa ]

Byte by byte assignments.

Fixes build on m68k.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/mvme147.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/amd/mvme147.c b/drivers/net/ethernet/amd/mvme147.c
index da97fccea9ea6..410c7b67eba4d 100644
--- a/drivers/net/ethernet/amd/mvme147.c
+++ b/drivers/net/ethernet/amd/mvme147.c
@@ -74,6 +74,7 @@ static struct net_device * __init mvme147lance_probe(void)
 	static int called;
 	static const char name[] = "MVME147 LANCE";
 	struct m147lance_private *lp;
+	u8 macaddr[ETH_ALEN];
 	u_long *addr;
 	u_long address;
 	int err;
@@ -93,15 +94,16 @@ static struct net_device * __init mvme147lance_probe(void)
 
 	addr = (u_long *)ETHERNET_ADDRESS;
 	address = *addr;
-	dev->dev_addr[0] = 0x08;
-	dev->dev_addr[1] = 0x00;
-	dev->dev_addr[2] = 0x3e;
+	macaddr[0] = 0x08;
+	macaddr[1] = 0x00;
+	macaddr[2] = 0x3e;
 	address = address >> 8;
-	dev->dev_addr[5] = address&0xff;
+	macaddr[5] = address&0xff;
 	address = address >> 8;
-	dev->dev_addr[4] = address&0xff;
+	macaddr[4] = address&0xff;
 	address = address >> 8;
-	dev->dev_addr[3] = address&0xff;
+	macaddr[3] = address&0xff;
+	eth_hw_addr_set(dev, macaddr);
 
 	printk("%s: MVME147 at 0x%08lx, irq %d, Hardware Address %pM\n",
 	       dev->name, dev->base_addr, MVME147_LANCE_IRQ,
-- 
2.34.1

