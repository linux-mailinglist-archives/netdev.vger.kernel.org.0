Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C42E6FF238
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731579AbfKPQRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:17:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:53230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729461AbfKPPqo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:46:44 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FC932089D;
        Sat, 16 Nov 2019 15:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919203;
        bh=9uyfzauE58ZzV9qho2Uq/YQRYCXqOI53XmSwiLS9fDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sYkZsYT1FG72hrdW9PICtjdz27y0ivASTwI5YdACbG7yH4erdo4pMWz9yujNO3LYO
         cX6lx9lUSVCbgcpcbPAwYYRASLd6fCRhVEehJsR22PKsAKxFbHQ8YdfaQ4mqYA+6i2
         5XWNiaNPs5WtK5VKki4WVt1kVZgwlao07YsbaITA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 206/237] net: dsa: bcm_sf2: Turn on PHY to allow successful registration
Date:   Sat, 16 Nov 2019 10:40:41 -0500
Message-Id: <20191116154113.7417-206-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit c04a17d2a9ccf1eaba1c5a56f83e997540a70556 ]

We are binding to the PHY using the SF2 slave MDIO bus that we create,
binding involves reading the PHY's MII_PHYSID1/2 which won't be possible
if the PHY is turned off. Temporarily turn it on/off for the bus probing
to succeeed. This fixes unbind/bind problems where the port connecting
to that PHY would be in error since it could not connect to it.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/bcm_sf2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index ca3655d28e00f..17cec68e56b4f 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -1099,12 +1099,16 @@ static int bcm_sf2_sw_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	bcm_sf2_gphy_enable_set(priv->dev->ds, true);
+
 	ret = bcm_sf2_mdio_register(ds);
 	if (ret) {
 		pr_err("failed to register MDIO bus\n");
 		return ret;
 	}
 
+	bcm_sf2_gphy_enable_set(priv->dev->ds, false);
+
 	ret = bcm_sf2_cfp_rst(priv);
 	if (ret) {
 		pr_err("failed to reset CFP\n");
-- 
2.20.1

