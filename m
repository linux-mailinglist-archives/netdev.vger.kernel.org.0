Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3B7A8B94
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733055AbfIDQDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 12:03:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:40148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387697AbfIDQDb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 12:03:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4B6A20820;
        Wed,  4 Sep 2019 16:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567613010;
        bh=yx3NuZ2IIf9E6pMH2Ag2YDTHyO0z815AA/8i5DWjOXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RDHlubuiuVIPJvdtlJCq/nrSJFd3KyALruqE8VkefMZcfq425byXhhFeuONWhki7P
         Cso84jZTuv5cVBQwoTZzNf3oaw46DXGKmnAEiCISoq/u+vSwLuRkgXCXnxAqO5e8F6
         7UVcnNdI4yPikwJeG4tlDCi2Ntlag0Uch6fCMmqQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chen-Yu Tsai <wens@csie.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 18/20] net: stmmac: dwmac-rk: Don't fail if phy regulator is absent
Date:   Wed,  4 Sep 2019 12:03:01 -0400
Message-Id: <20190904160303.5062-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904160303.5062-1-sashal@kernel.org>
References: <20190904160303.5062-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit 3b25528e1e355c803e73aa326ce657b5606cda73 ]

The devicetree binding lists the phy phy as optional. As such, the
driver should not bail out if it can't find a regulator. Instead it
should just skip the remaining regulator related code and continue
on normally.

Skip the remainder of phy_power_on() if a regulator supply isn't
available. This also gets rid of the bogus return code.

Fixes: 2e12f536635f ("net: stmmac: dwmac-rk: Use standard devicetree property for phy regulator")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
index 398b08e07149b..68a58333bd740 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -429,10 +429,8 @@ static int phy_power_on(struct rk_priv_data *bsp_priv, bool enable)
 	int ret;
 	struct device *dev = &bsp_priv->pdev->dev;
 
-	if (!ldo) {
-		dev_err(dev, "no regulator found\n");
-		return -1;
-	}
+	if (!ldo)
+		return 0;
 
 	if (enable) {
 		ret = regulator_enable(ldo);
-- 
2.20.1

