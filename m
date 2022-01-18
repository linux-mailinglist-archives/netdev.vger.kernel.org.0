Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8874919F7
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350125AbiARC5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:57:34 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43366 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349406AbiARCth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:49:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5977D612D1;
        Tue, 18 Jan 2022 02:49:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC970C36AEB;
        Tue, 18 Jan 2022 02:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474176;
        bh=AOCmFw8/sQVTBVtdw/nlFII9xut6Rmigf5LeBgmj/tY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BM85y0Pb79EfMtnOONN3p156dv4SCuOHQr6IEb64hrxXmkV94Ok87Tugwsm1k7jyZ
         DS9CcBGoTHO9UhDL4siQg6PyBOO6168ykwB/a/h3c9isSqpFk9HEbwm5u4v9l+hU06
         4oqPcLqPXYfjCbAhGU3X8jvSAfX7whay7BCtKS4eQmKPLQSOOYE+d4fWDxXZ6AeodB
         dffIiY+8lYVtSye9So9A6zArLkuVjybWv24qEW8SoHz4mHIkQFkvFNCo6+73qSJbx2
         rRyMWI9SNsxgGyTOOvaQVZNi1jSfB6PQMIIWgKMx9qeDvwzrhrHK5CoV0ULumccT+A
         YFqLnqw3sK88w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, geert@linux-m68k.org,
        arnd@arndb.de, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 09/56] amd: mvme147: use eth_hw_addr_set()
Date:   Mon, 17 Jan 2022 21:48:21 -0500
Message-Id: <20220118024908.1953673-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024908.1953673-1-sashal@kernel.org>
References: <20220118024908.1953673-1-sashal@kernel.org>
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
index 0a920448522f3..095055258c9da 100644
--- a/drivers/net/ethernet/amd/mvme147.c
+++ b/drivers/net/ethernet/amd/mvme147.c
@@ -73,6 +73,7 @@ struct net_device * __init mvme147lance_probe(int unit)
 	static int called;
 	static const char name[] = "MVME147 LANCE";
 	struct m147lance_private *lp;
+	u8 macaddr[ETH_ALEN];
 	u_long *addr;
 	u_long address;
 	int err;
@@ -95,15 +96,16 @@ struct net_device * __init mvme147lance_probe(int unit)
 
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

