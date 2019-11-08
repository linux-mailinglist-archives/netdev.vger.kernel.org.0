Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 076B6F48EF
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 12:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390646AbfKHLoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 06:44:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:58722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387894AbfKHLoC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:44:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 811702245A;
        Fri,  8 Nov 2019 11:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213441;
        bh=vBOqu7GzsbHaGf7lKcTUOnA8+j2QHZ/DVsBHpJURgDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QZKF5jHYfPpCtBOUDE/0MkPYOTU3XdNXIDzy2Llro5VUgBkKVSuMZnQ450sx8id/H
         +Pzrvp+iWj2WhTeVNjSGUzHxXeE5p7omx2nbLCfM1CXy4j5/Si5woK+YS0C0M4GvJj
         uh0S3yw+WNLkOpI4Mea6RZTtpwsrIveR2qMRaF10=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quentin Schulz <quentin.schulz@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 035/103] net: phy: mscc: read 'vsc8531,vddmac' as an u32
Date:   Fri,  8 Nov 2019 06:42:00 -0500
Message-Id: <20191108114310.14363-35-sashal@kernel.org>
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
index 650c2667d523d..88bcdbcb432cc 100644
--- a/drivers/net/phy/mscc.c
+++ b/drivers/net/phy/mscc.c
@@ -111,7 +111,7 @@ struct vsc8531_private {
 
 #ifdef CONFIG_OF_MDIO
 struct vsc8531_edge_rate_table {
-	u16 vddmac;
+	u32 vddmac;
 	u8 slowdown[8];
 };
 
@@ -376,7 +376,7 @@ static void vsc85xx_wol_get(struct phy_device *phydev,
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

