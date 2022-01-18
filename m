Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE621491CAF
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 04:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350753AbiARDRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 22:17:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346733AbiARDIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 22:08:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B18C06176E;
        Mon, 17 Jan 2022 18:49:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 203216134B;
        Tue, 18 Jan 2022 02:49:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50FACC36AE3;
        Tue, 18 Jan 2022 02:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474173;
        bh=TiuzeM5rv9ZpaORtZliSXdD4xxb5o66FSkoiOdED7o8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DoFhNZyu3CnHVLmmbOneJ21Vei2RBfRLRWGtjNjN0dLSBI5Xdl3plfuU6TgRx5i0f
         16w/hcEZoGzYMnsP6XxX70QgMVlA+t6clWDfv/7+ACgc0NNAjkMwFzrcbps9PYLkGT
         p8IymVmty/ulS1M6msrzgg5BNXUIFxLdZf693GvpEh2jLVotoEM3NgwlG7Ax/HQgbT
         BC0UjUn+c6pYP4ROftQNyZcZFBimQztuN/44Avz16LftKIu4JSDvQ0cmrJGrpkD+UI
         LbyzjeWWFvw05J1N3/xlZ4dBe5y6l6L5bZ1NvgRv3rS6KBXwXr3hHm6XTLnsdcwjwr
         iDBgXdXWFXrmg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, geert@linux-m68k.org,
        ojeda@kernel.org, akpm@linux-foundation.org, masahiroy@kernel.org,
        arnd@arndb.de, tanghui20@huawei.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 08/56] amd: atarilance: use eth_hw_addr_set()
Date:   Mon, 17 Jan 2022 21:48:20 -0500
Message-Id: <20220118024908.1953673-8-sashal@kernel.org>
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
index d3d44e07afbc0..4b8fe4b1d418d 100644
--- a/drivers/net/ethernet/amd/atarilance.c
+++ b/drivers/net/ethernet/amd/atarilance.c
@@ -475,6 +475,7 @@ static unsigned long __init lance_probe1( struct net_device *dev,
 	int 					i;
 	static int 				did_version;
 	unsigned short			save1, save2;
+	u8 addr[ETH_ALEN];
 
 	PROBE_PRINT(( "Probing for Lance card at mem %#lx io %#lx\n",
 				  (long)memaddr, (long)ioaddr ));
@@ -589,14 +590,16 @@ static unsigned long __init lance_probe1( struct net_device *dev,
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

