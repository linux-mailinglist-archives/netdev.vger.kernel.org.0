Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 767DB39A897
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbhFCRQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:16:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231977AbhFCROS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:14:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 384FE61438;
        Thu,  3 Jun 2021 17:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740261;
        bh=v/zXBpze0qVz5SNggLiUZSwQ8Z80KlcQCzMin2Dijwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bHPT+el1E+UIhB52ljMykqY/Lr4yPYUd3q/7IOtCLjvZG6lcRW/SXrjTbCzQ64SHn
         tA3aDkZHj812fc5GDrgvYeZoV9q6miSNRXH7Oi3khl/tS6a829nyOBF4FrOZzpTeQy
         AXN3BA+w6eQnBZ7AZOgwJEIa1oUoGyW+63ImqjmwN+PVv4VTOu/artD8mpMuYUpT6Y
         dHdD73UYdgtkGI5poDS+7nJ4MfagC97BCXsFXqGijbDeOo70fP2Q+uV6Q3OX9fcf+l
         rGgKelqA9D3430GFhx/AM8jAxVww3nAHasaPhaDS/fa5MrUg76SOfLYyj8+spkXGKl
         i1XLnXDN8F1fA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 06/17] net: mdiobus: get rid of a BUG_ON()
Date:   Thu,  3 Jun 2021 13:10:41 -0400
Message-Id: <20210603171052.3169893-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603171052.3169893-1-sashal@kernel.org>
References: <20210603171052.3169893-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 1dde47a66d4fb181830d6fa000e5ea86907b639e ]

We spotted a bug recently during a review where a driver was
unregistering a bus that wasn't registered, which would trigger this
BUG_ON().  Let's handle that situation more gracefully, and just print
a warning and return.

Reported-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mdio_bus.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index a9bbdcec0bad..8cc7563ab103 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -362,7 +362,8 @@ void mdiobus_unregister(struct mii_bus *bus)
 	struct mdio_device *mdiodev;
 	int i;
 
-	BUG_ON(bus->state != MDIOBUS_REGISTERED);
+	if (WARN_ON_ONCE(bus->state != MDIOBUS_REGISTERED))
+		return;
 	bus->state = MDIOBUS_UNREGISTERED;
 
 	for (i = 0; i < PHY_MAX_ADDR; i++) {
-- 
2.30.2

