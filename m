Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA116491CAD
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 04:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353517AbiARDR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 22:17:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351837AbiARDIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 22:08:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A0BC03327D;
        Mon, 17 Jan 2022 18:49:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85D336134B;
        Tue, 18 Jan 2022 02:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FBA9C36AE3;
        Tue, 18 Jan 2022 02:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474170;
        bh=aTAPP8MrV7hwrV/EMWjgogy86CTelnvvD67qI1DQVeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TwkHH9lwxKMEjygTpc5NXOIJ/5KsDddXlfFD7P8SpQjx9AT2+hFDGdBvvHXQFXWkI
         xd8+nNtZXZbVaqP1TanaKdyqB7ra0ChvBCwC6cPX9lnpdcHIdrGxahr1cr4PyuDmay
         wqKTrzmXe3jd0zLE5V9je+zIt5/jtN+hbRc9LL8d2QNdyGLMhz388vduum49UWb6do
         JnmJFB7mz2CaqaSouDE9ZKTTRZoj6ZOFKmkJfDAHwCG8qfuQ8ab46ajBdbNWlpAGP9
         r0xTfd2RJa+DFIP8V326Dpqj+TFyR0k3lcYHgkMWNfrrGCODEaYgnggXxtfb3p5s7w
         RCYp+QtRmK8hw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, liweihang@huawei.com,
        liuyixing1@huawei.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 07/56] amd: hplance: use eth_hw_addr_set()
Date:   Mon, 17 Jan 2022 21:48:19 -0500
Message-Id: <20220118024908.1953673-7-sashal@kernel.org>
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

[ Upstream commit 21942eef062781429b356974589d7965952940fb ]

Byte by byte assignments.

Fixes build on m68k.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/hplance.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/hplance.c b/drivers/net/ethernet/amd/hplance.c
index c3dbf1c8a2699..e0df98ff6847f 100644
--- a/drivers/net/ethernet/amd/hplance.c
+++ b/drivers/net/ethernet/amd/hplance.c
@@ -128,6 +128,7 @@ static void hplance_init(struct net_device *dev, struct dio_dev *d)
 {
 	unsigned long va = (d->resource.start + DIO_VIRADDRBASE);
 	struct hplance_private *lp;
+	u8 addr[ETH_ALEN];
 	int i;
 
 	/* reset the board */
@@ -143,9 +144,10 @@ static void hplance_init(struct net_device *dev, struct dio_dev *d)
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
2.34.1

