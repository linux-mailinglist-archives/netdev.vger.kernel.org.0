Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7FF7F4AC8
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391821AbfKHMKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 07:10:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:52630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387980AbfKHLjq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:39:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39D0E222C6;
        Fri,  8 Nov 2019 11:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213185;
        bh=2ohfrYlI9AQLpAqTbHVEr+dyZe0wqqGRf+hlTW7OljU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yhVQN5A2tAyJuE42z4NRHEcgUpy7akAdlktL9jRSjdWc15qqWVQMGoZ08FLv6zWzh
         4aW7XxUh/mOx9IVNHuBADJkkFuOdSAdkkHr7i2x49UbLMlMLQ2BAgwoQUi3Nu0zFIt
         dVAQxDqBS6xhizbJbgn66GwB5i2yxEGUPUZONsNg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quentin Schulz <quentin.schulz@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 076/205] net: phy: mscc: read 'vsc8531,vddmac' as an u32
Date:   Fri,  8 Nov 2019 06:35:43 -0500
Message-Id: <20191108113752.12502-76-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Quentin Schulz <quentin.schulz@bootlin.com>

[ Upstream commit a993e0f583c7925adaa7721226ccd7a41e7e63d1 ]

In the DT binding, it is specified nowhere that 'vsc8531,vddmac' is an
u16, even though it's read as an u16 in the driver.

Let's update the driver to take into consideration that the
'vsc8531,vddmac' property is of the default type u32.

Signed-off-by: Quentin Schulz <quentin.schulz@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mscc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/mscc.c b/drivers/net/phy/mscc.c
index 84ca9ff40ae0b..53d63a71a03e2 100644
--- a/drivers/net/phy/mscc.c
+++ b/drivers/net/phy/mscc.c
@@ -111,7 +111,7 @@ struct vsc8531_private {
 
 #ifdef CONFIG_OF_MDIO
 struct vsc8531_edge_rate_table {
-	u16 vddmac;
+	u32 vddmac;
 	u8 slowdown[8];
 };
 
@@ -376,7 +376,7 @@ out_unlock:
 static int vsc85xx_edge_rate_magic_get(struct phy_device *phydev)
 {
 	u8 sd;
-	u16 vdd;
+	u32 vdd;
 	int rc, i, j;
 	struct device *dev = &phydev->mdio.dev;
 	struct device_node *of_node = dev->of_node;
@@ -385,7 +385,7 @@ static int vsc85xx_edge_rate_magic_get(struct phy_device *phydev)
 	if (!of_node)
 		return -ENODEV;
 
-	rc = of_property_read_u16(of_node, "vsc8531,vddmac", &vdd);
+	rc = of_property_read_u32(of_node, "vsc8531,vddmac", &vdd);
 	if (rc != 0)
 		vdd = MSCC_VDDMAC_3300;
 
-- 
2.20.1

