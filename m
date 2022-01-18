Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1AE491703
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346347AbiARChe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:37:34 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48594 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245752AbiARCdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:33:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 863D960C74;
        Tue, 18 Jan 2022 02:33:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8859C36AEB;
        Tue, 18 Jan 2022 02:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473225;
        bh=FbDyOkb3R6R5jpdWBi1jFIf9Ev+1MgP8MJOwPf6wJfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rgVMdmdsuNmnIXfwFELWN4M5QOufk5StjLwRdKdcdXiXbJm7mDfyZyEVJ2T9Ox3D+
         1OTV0JK8eI75baescK9oRlYvWdn/95Imx0cuw9+w4GYg5pgfA+4NIpWwwbFVjtHQKX
         gJAT6SGw2VSgTvpsy7K6AMARjS7zWGrw34nu57nDjx/Ekdx2LatAnSz3C56JLRr6jZ
         VYUW1yJVt1VfrXC4eDQ0cFiHgWpZGBKhpdPCO7rQEtef/lVd+lP0YIQTOzv9wkbvhC
         7gRq9ehWw9+/SrEkMkWGibnV5UWxOvqfpx7hyXu3rzbvOk+gDIvgAkPONUb1OW4Eus
         UnYIeGwlEynUQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, geert@linux-m68k.org,
        tanghui20@huawei.com, akpm@linux-foundation.org,
        masahiroy@kernel.org, arnd@arndb.de, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 032/188] amd: atarilance: use eth_hw_addr_set()
Date:   Mon, 17 Jan 2022 21:29:16 -0500
Message-Id: <20220118023152.1948105-32-sashal@kernel.org>
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

[ Upstream commit c3dc2f7196ca0f59d9baeb5d3b927e703944dc6c ]

Byte by byte assignments.

Fixes build on m68k.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/atarilance.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/atarilance.c b/drivers/net/ethernet/amd/atarilance.c
index 9d2f49fd945ed..f57c82f8ae647 100644
--- a/drivers/net/ethernet/amd/atarilance.c
+++ b/drivers/net/ethernet/amd/atarilance.c
@@ -471,6 +471,7 @@ static unsigned long __init lance_probe1( struct net_device *dev,
 	int 					i;
 	static int 				did_version;
 	unsigned short			save1, save2;
+	u8 addr[ETH_ALEN];
 
 	PROBE_PRINT(( "Probing for Lance card at mem %#lx io %#lx\n",
 				  (long)memaddr, (long)ioaddr ));
@@ -585,14 +586,16 @@ static unsigned long __init lance_probe1( struct net_device *dev,
 		memcpy(dev->dev_addr, OldRieblDefHwaddr, ETH_ALEN);
 		break;
 	  case NEW_RIEBL:
-		lp->memcpy_f(dev->dev_addr, RIEBL_HWADDR_ADDR, ETH_ALEN);
+		lp->memcpy_f(addr, RIEBL_HWADDR_ADDR, ETH_ALEN);
+		eth_hw_addr_set(dev, addr);
 		break;
 	  case PAM_CARD:
 		i = IO->eeprom;
 		for( i = 0; i < 6; ++i )
-			dev->dev_addr[i] =
+			addr[i] =
 				((((unsigned short *)MEM)[i*2] & 0x0f) << 4) |
 				((((unsigned short *)MEM)[i*2+1] & 0x0f));
+		eth_hw_addr_set(dev, addr);
 		i = IO->mem;
 		break;
 	}
-- 
2.34.1

