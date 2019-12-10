Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF1011980F
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730438AbfLJVgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:36:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:42136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729729AbfLJVf5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:35:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D4752465C;
        Tue, 10 Dec 2019 21:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013757;
        bh=xkT2GABLrjjiX2M9NN+i7kSUPGPmtf22rVA+Ee8NckY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pG7S/wQ8n25ejfuVGFkYUR94JhV1fr4UQJ7ZpAmf4bkwD15lHl178KHdYYkQFlZ4p
         MoWO7PPyX5TpNQXLJRYoqYLjf1919a6RsCKG/iQULZiwlZtgTzdA5mnygICnBY3HbP
         Tw66ZMBGn+WyzIcf+3zCJG5l+Kaq38p43txhAVL4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 177/177] net: phy: initialise phydev speed and duplex sanely
Date:   Tue, 10 Dec 2019 16:32:21 -0500
Message-Id: <20191210213221.11921-177-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit a5d66f810061e2dd70fb7a108dcd14e535bc639f ]

When a phydev is created, the speed and duplex are set to zero and
-1 respectively, rather than using the predefined SPEED_UNKNOWN and
DUPLEX_UNKNOWN constants.

There is a window at initialisation time where we may report link
down using the 0/-1 values.  Tidy this up and use the predefined
constants, so debug doesn't complain with:

"Unsupported (update phy-core.c)/Unsupported (update phy-core.c)"

when the speed and duplex settings are printed.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 6144146aec29d..43c4f358eeb8a 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -420,8 +420,8 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, int phy_id,
 	mdiodev->device_free = phy_mdio_device_free;
 	mdiodev->device_remove = phy_mdio_device_remove;
 
-	dev->speed = 0;
-	dev->duplex = -1;
+	dev->speed = SPEED_UNKNOWN;
+	dev->duplex = DUPLEX_UNKNOWN;
 	dev->pause = 0;
 	dev->asym_pause = 0;
 	dev->link = 0;
-- 
2.20.1

