Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563A3491CB3
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 04:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349598AbiARDRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 22:17:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352145AbiARDIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 22:08:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07EABC061771;
        Mon, 17 Jan 2022 18:49:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F247612E8;
        Tue, 18 Jan 2022 02:49:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B725C36AE3;
        Tue, 18 Jan 2022 02:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474182;
        bh=wc7KSmdjpJ3GW/QmBMVKoAq3LtguGJ74FVAo69SnYBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T/6FfxLylRlEhYaGKlWb6GcCBlskKpLvr1bw8lsHPBF9T0jWYy4gBTMba3lEKFRCA
         zHsUP4582CuJ/yIqn+jJh1r0VmezFPU99yq0INZMLjWOfWcw63bu1zMMZkBJDMDJAY
         Yj0w7xJaVrB51EM5W6A0gRnezGIZ/1rnT0h/PhPwK8wyiRHmwjQzXt8DiGGYaEhj4p
         7qURFI74pTyEy9HAFinK716VE20928tM2tLJ3Hn6lbGFT+44JeafEyuIsO4H92vMxg
         fRpEaOhIuCrpHM9HDoftZBQsMtijiCrTs5XbFF/vOMsfFikLhPs5HiLuTJH8nxGn3Y
         WquhMu3/ZFk5w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, fthain@linux-m68k.org,
        u.kleine-koenig@pengutronix.de, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 11/56] 8390: mac8390: use eth_hw_addr_set()
Date:   Mon, 17 Jan 2022 21:48:23 -0500
Message-Id: <20220118024908.1953673-11-sashal@kernel.org>
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
index e95a7567bb234..4e2301798be7a 100644
--- a/drivers/net/ethernet/8390/mac8390.c
+++ b/drivers/net/ethernet/8390/mac8390.c
@@ -301,6 +301,7 @@ static bool __init mac8390_init(struct net_device *dev, struct nubus_dev *ndev,
 	struct nubus_dirent ent;
 	int offset;
 	volatile unsigned short *i;
+	u8 addr[ETH_ALEN];
 
 	printk_once(KERN_INFO pr_fmt("%s"), version);
 
@@ -326,7 +327,8 @@ static bool __init mac8390_init(struct net_device *dev, struct nubus_dev *ndev,
 		return false;
 	}
 
-	nubus_get_rsrc_mem(dev->dev_addr, &ent, 6);
+	nubus_get_rsrc_mem(addr, &ent, 6);
+	eth_hw_addr_set(dev, addr);
 
 	if (useresources[cardtype] == 1) {
 		nubus_rewinddir(&dir);
-- 
2.34.1

