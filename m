Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F71456AAD
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 08:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233439AbhKSHNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 02:13:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:59742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233335AbhKSHNn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 02:13:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3AC061B4C;
        Fri, 19 Nov 2021 07:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637305841;
        bh=e/SmWskEoqnL3J/C3r3RCd+LNGbDirsBqcrWyM2QFlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mNwwEQ864NswoplgoM744d+DLoHNMMNId9xVr/4ZSHgzSIFTKgMHfxiDIFLJFv/v3
         LYB5P3CguaakfaaD9+mgrU2EwSJSJ2IQp6pqZfxMEVQdjAuuQbHmScj24f+MDFwehT
         x2POGCLQL3J8Tsu6HNQOySkJnLwh6sn5r6hv7ffzm9VV6n/a9BkWhqzwsm1AG+aUDe
         mbvIRgmQjjCQi/HO80alQGPCLe5Al/uu8334jxzOzIXtxGauCEe1wTb5B7KJcFPD9m
         S7faMeK4aCJLUnvssZ3BbJZ9brDh81uaI2GdGGekowIJxvxYiPbJ8eg3QSBojm4sz3
         w13+7dwkElBMw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 04/15] amd: hplance: use eth_hw_addr_set()
Date:   Thu, 18 Nov 2021 23:10:22 -0800
Message-Id: <20211119071033.3756560-5-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211119071033.3756560-1-kuba@kernel.org>
References: <20211119071033.3756560-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Byte by byte assignments.

Fixes build on m68k.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/amd/hplance.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/hplance.c b/drivers/net/ethernet/amd/hplance.c
index 6784f8748638..055fda11c572 100644
--- a/drivers/net/ethernet/amd/hplance.c
+++ b/drivers/net/ethernet/amd/hplance.c
@@ -129,6 +129,7 @@ static void hplance_init(struct net_device *dev, struct dio_dev *d)
 {
 	unsigned long va = (d->resource.start + DIO_VIRADDRBASE);
 	struct hplance_private *lp;
+	u8 addr[ETH_ALEN];
 	int i;
 
 	/* reset the board */
@@ -144,9 +145,10 @@ static void hplance_init(struct net_device *dev, struct dio_dev *d)
 		/* The NVRAM holds our ethernet address, one nibble per byte,
 		 * at bytes NVRAMOFF+1,3,5,7,9...
 		 */
-		dev->dev_addr[i] = ((in_8(va + HPLANCE_NVRAMOFF + i*4 + 1) & 0xF) << 4)
+		addr[i] = ((in_8(va + HPLANCE_NVRAMOFF + i*4 + 1) & 0xF) << 4)
 			| (in_8(va + HPLANCE_NVRAMOFF + i*4 + 3) & 0xF);
 	}
+	eth_hw_addr_set(dev, addr);
 
 	lp = netdev_priv(dev);
 	lp->lance.name = d->name;
-- 
2.31.1

