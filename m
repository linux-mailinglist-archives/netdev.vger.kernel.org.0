Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573C649145C
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244856AbiARCWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:22:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244854AbiARCVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:21:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A522C061746;
        Mon, 17 Jan 2022 18:21:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B88FCB81233;
        Tue, 18 Jan 2022 02:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4872C36AE3;
        Tue, 18 Jan 2022 02:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472511;
        bh=wNtTxl+7OJwp4XfQcWDBPvTn86mQUGQpqISqFTZAWxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kuKdllV5iX89R6MT2H13cM2dDHY3/koKAGj0xAs0e/Sm86qbV7uT0wkYvcDmUuab/
         nvl9qgdh8CTI+3AMR+vE2Ok9HVaMMvsVbuRhZMK8i3Dm4VC1umPHmgWzD/Z7uNG0BW
         wAYOsG1QDVBUrnqGs+EL3IdjOlPMhJO7g4LQqdUIr+wIA/hkQqJvzYFq/K4pGzFurw
         IqPHdj8aSYX8vM9w6QgKTKAAno/du2iwJ6bZpeiSmKvRjYB+nmp+VdCKDXqIe5RrKp
         2s49461WOOhy1CE+54h0oOhAhhsseRzrxJyzDo5zNq1gCjybPxDvhNNuMgcd2WBv8O
         mgVuMWcmqg9Yw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, liweihang@huawei.com,
        liuyixing1@huawei.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 037/217] amd: hplance: use eth_hw_addr_set()
Date:   Mon, 17 Jan 2022 21:16:40 -0500
Message-Id: <20220118021940.1942199-37-sashal@kernel.org>
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
index 6784f8748638b..055fda11c5724 100644
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
2.34.1

