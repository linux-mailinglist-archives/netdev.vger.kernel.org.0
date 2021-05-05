Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 009CA374128
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234957AbhEEQgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:36:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234617AbhEEQeN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:34:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AABD6142D;
        Wed,  5 May 2021 16:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232358;
        bh=X3FQxJdww4G9BL4nHozkNPwQLtFFvOmKCWJyeQ5Rj5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KvP3uw7w5w46hxi6MnpsHt8JV9u/L68r5zCn6kOKpaD+oGiRsweST4fecV0G+LB7g
         1fizDza7H40EHqqqMDmvVeLqDql4n6fYAG+V5eZWPkA9FPT+Pjd6fah2Co9fT6SFwN
         kK9STm0HhXIjYJnGUyKCZhozPeNpMLie/4A2HrQeIYadX/0rzhZUwjaRBPZ/OftoJx
         ajr3m0AcA1/y11UMbSJTTB2Z5yhsiWdtCGUdLhWWTUdLJPn1Z4w+xcT1e54WCCZMNh
         Kg3I5DWrOu1RjS1yh+xwuWVD4/ICJuDfjxvtNCdQEOGWnsVcx4WD67+DeGOdhFWtsi
         ymEWDSkLq2zmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 053/116] net: fec: use mac-managed PHY PM
Date:   Wed,  5 May 2021 12:30:21 -0400
Message-Id: <20210505163125.3460440-53-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 557d5dc83f6831b4e54d141e9b121850406f9a60 ]

Use the new mac_managed_pm flag to work around an issue with KSZ8081 PHY
that becomes unstable when a soft reset is triggered during aneg.

Reported-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Tested-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 3db882322b2b..70aea9c274fe 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2048,6 +2048,8 @@ static int fec_enet_mii_probe(struct net_device *ndev)
 	fep->link = 0;
 	fep->full_duplex = 0;
 
+	phy_dev->mac_managed_pm = 1;
+
 	phy_attached_info(phy_dev);
 
 	return 0;
@@ -3864,6 +3866,7 @@ static int __maybe_unused fec_resume(struct device *dev)
 		netif_device_attach(ndev);
 		netif_tx_unlock_bh(ndev);
 		napi_enable(&fep->napi);
+		phy_init_hw(ndev->phydev);
 		phy_start(ndev->phydev);
 	}
 	rtnl_unlock();
-- 
2.30.2

