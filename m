Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0D1A13F6BD
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729991AbgAPTGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:06:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:52588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387495AbgAPRB2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:01:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0319821582;
        Thu, 16 Jan 2020 17:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194087;
        bh=tvYjhdGG/mNMo4H1UoE0B3fWCG3cdfeEEw8tNd+7JHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M2bStPI7KLfUHBotrPbSt+6gfLdLZljOYdwOy+lbVntTI6gXum4Z11EuVkJGxbUBQ
         Rtjyy4YZCJdvhOV33aKW65Jqe4tq3a+87/QF6KEOXejP2bCg7pBp0DzUTKP1UZPCGU
         pvzU8guJIbnnG8Q/Ihn7FX5YIG19aXC4Rxnkf2Y0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 191/671] mdio_bus: Fix PTR_ERR() usage after initialization to constant
Date:   Thu, 16 Jan 2020 11:51:40 -0500
Message-Id: <20200116165940.10720-74-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 780feae7eb69388c8d8b661cda6706b0dc0f642b ]

Fix coccinelle warning:

./drivers/net/phy/mdio_bus.c:51:5-12: ERROR: PTR_ERR applied after initialization to constant on line 44
./drivers/net/phy/mdio_bus.c:52:5-12: ERROR: PTR_ERR applied after initialization to constant on line 44

fix this by using IS_ERR before PTR_ERR

Fixes: bafbdd527d56 ("phylib: Add device reset GPIO support")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mdio_bus.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index c5588d4508f9..5c89a310359d 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -56,11 +56,12 @@ static int mdiobus_register_gpiod(struct mdio_device *mdiodev)
 		gpiod = fwnode_get_named_gpiod(&mdiodev->dev.of_node->fwnode,
 					       "reset-gpios", 0, GPIOD_OUT_LOW,
 					       "PHY reset");
-	if (PTR_ERR(gpiod) == -ENOENT ||
-	    PTR_ERR(gpiod) == -ENOSYS)
-		gpiod = NULL;
-	else if (IS_ERR(gpiod))
-		return PTR_ERR(gpiod);
+	if (IS_ERR(gpiod)) {
+		if (PTR_ERR(gpiod) == -ENOENT || PTR_ERR(gpiod) == -ENOSYS)
+			gpiod = NULL;
+		else
+			return PTR_ERR(gpiod);
+	}
 
 	mdiodev->reset = gpiod;
 
-- 
2.20.1

