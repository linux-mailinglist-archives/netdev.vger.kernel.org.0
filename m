Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68E7949179D
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343979AbiARCmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:42:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344754AbiARChW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:37:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9FEC0617AE;
        Mon, 17 Jan 2022 18:33:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A35DF611DC;
        Tue, 18 Jan 2022 02:33:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E06FC36AE3;
        Tue, 18 Jan 2022 02:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473229;
        bh=Y/Jg8zxEhlm7oR/BvTYZFwWEmKlAwuzQhC1L+ZRMTg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hUaU8gv8/47FKq6EQsevfGmgja8D9BfFjkYWMJlAv88/anUAHZplA+ntfG6FnD2U3
         Dr92sq5MLFumXfDNp0yO8Ed+Mi2HCj5IyVwG/QAyPrBvt+F/dgKgPAznBc919roqC6
         38/JX0K4PY4tdBlfjfOt1u8NB63QINZoohVSbKTozI5GOTquv2XK1MUD4iO31NYvWt
         ftyv+Ps9mlf97Ka/hjA2sEuJtC3xuuUvVq/zhBa1aK3j4LXYDxb85zez07iCgajz1T
         WwtMIuB55UHJDiZfYp5EZh1qTaJ/shl6i4JEOZG5ZpupmNAIRo1606KJhjmjrRH578
         jhHN53SbiiWqw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, geert@linux-m68k.org,
        arnd@arndb.de, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 033/188] amd: mvme147: use eth_hw_addr_set()
Date:   Mon, 17 Jan 2022 21:29:17 -0500
Message-Id: <20220118023152.1948105-33-sashal@kernel.org>
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

