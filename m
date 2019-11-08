Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 952FDF48F9
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391027AbfKHMAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 07:00:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:58760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732452AbfKHLoC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:44:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8456E21D6C;
        Fri,  8 Nov 2019 11:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213442;
        bh=nj4xV/O2BgT3Vx28Imsn78CJnab4xK7OtS0HVjm4e2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0RyiqaApw7Xxde+RdcHerqKmoTa+s4iKGzzclYl8zUj2PW/N0gKMEvVbcBSfPNvcs
         vW54vm4ZNBAojm0knu225uKVenHFUkVKwVGPf5oYWY+CDTRNYzF1xG9KlLHiiB5iOp
         pE+uTIsVf1y4cK0eFy9FM72ckLSLvS8XNix3zuMU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quentin Schulz <quentin.schulz@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 036/103] net: phy: mscc: read 'vsc8531, edge-slowdown' as an u32
Date:   Fri,  8 Nov 2019 06:42:01 -0500
Message-Id: <20191108114310.14363-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114310.14363-1-sashal@kernel.org>
References: <20191108114310.14363-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Quentin Schulz <quentin.schulz@bootlin.com>

[ Upstream commit 36c53cf0f46526b898390659b125155939f67892 ]

In the DT binding, it is specified nowhere that 'vsc8531,edge-slowdown'
is an u8, even though it's read as an u8 in the driver.

Let's update the driver to take into consideration that the
'vsc8531,edge-slowdown' property is of the default type u32.

Signed-off-by: Quentin Schulz <quentin.schulz@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mscc.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/mscc.c b/drivers/net/phy/mscc.c
index 88bcdbcb432cc..fe81741ab66a3 100644
--- a/drivers/net/phy/mscc.c
+++ b/drivers/net/phy/mscc.c
@@ -112,7 +112,7 @@ struct vsc8531_private {
 #ifdef CONFIG_OF_MDIO
 struct vsc8531_edge_rate_table {
 	u32 vddmac;
-	u8 slowdown[8];
+	u32 slowdown[8];
 };
 
 static const struct vsc8531_edge_rate_table edge_table[] = {
@@ -375,8 +375,7 @@ static void vsc85xx_wol_get(struct phy_device *phydev,
 #ifdef CONFIG_OF_MDIO
 static int vsc85xx_edge_rate_magic_get(struct phy_device *phydev)
 {
-	u8 sd;
-	u32 vdd;
+	u32 vdd, sd;
 	int rc, i, j;
 	struct device *dev = &phydev->mdio.dev;
 	struct device_node *of_node = dev->of_node;
@@ -389,7 +388,7 @@ static int vsc85xx_edge_rate_magic_get(struct phy_device *phydev)
 	if (rc != 0)
 		vdd = MSCC_VDDMAC_3300;
 
-	rc = of_property_read_u8(of_node, "vsc8531,edge-slowdown", &sd);
+	rc = of_property_read_u32(of_node, "vsc8531,edge-slowdown", &sd);
 	if (rc != 0)
 		sd = 0;
 
-- 
2.20.1

