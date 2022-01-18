Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58437491460
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244871AbiARCWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:22:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36074 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244888AbiARCV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:21:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79B17B81233;
        Tue, 18 Jan 2022 02:21:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA8CC36AE3;
        Tue, 18 Jan 2022 02:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472515;
        bh=UpsprJJW4lY/e6ZoX9JBjVJaE+uumK8qxGzR9yydx6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tIvtQtLbDvENQMOS4zEgDXr9cMB+3eHOp+J9IG22PNqMAx39wzo1MkoEocEjRTQY5
         LOSkgIbzioJyE9ftwE7LzEPlf+Y/Pj3sgBSMWB3jg8YECARfDBPbwlyK/wRJEBYh1s
         4ndmmxeo8tzV59Q/BR/t5ScyzFaSJmOYMGe5gjQ3kJYlRefkDIqewbU0edKRxjJQqo
         d4CqOOONqQTZWVf/kcAhJc6stcpzvuguM121kAYPeLXts3szWyGtmU4YUMGiWq3dY3
         ECx0eO98ns2Btsazf/b966KBlccF0y3uvBDn2htVnOgoEZEYz8hiwB1i24E9KLlN4A
         4n12m6wmrF6dg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, geert@linux-m68k.org,
        ojeda@kernel.org, tanghui20@huawei.com, arnd@arndb.de,
        masahiroy@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 038/217] amd: atarilance: use eth_hw_addr_set()
Date:   Mon, 17 Jan 2022 21:16:41 -0500
Message-Id: <20220118021940.1942199-38-sashal@kernel.org>
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
index 9c7d9690d00c4..27869164c6e62 100644
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
 		eth_hw_addr_set(dev, OldRieblDefHwaddr);
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

