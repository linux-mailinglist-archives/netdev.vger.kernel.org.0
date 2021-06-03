Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82F739A849
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232954AbhFCROb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:14:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:42436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232779AbhFCRNF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:13:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30DF861432;
        Thu,  3 Jun 2021 17:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740239;
        bh=OduFFxGahl0LqRAzegpmCRYK1Csic7OHYh/+II9U6o4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WEcwm2GB0hjoixbRADzwqmjBJh9cBOf5EDQRqKwbPT4PW5LY+YrM8fzBMvUDZZ12o
         oGq98o4w0xiN5s1ia09lvc6Jtg92xbPXH+HJIC1VAc9MZJDHA7gkn8ggrlm+9cXUEN
         VLeXzTDz5ZTYyZcY6N+pibWA7jXbgijZVn3vcYuMMPljpe0c65Jvx9SysJkpIxVhkV
         6+0Xm6dJtEK2GaJIeG0QdwJE7DwVm26Jo382FcO6+OPbJLQZclv+DL0HBrCBcMoUqe
         SPUGev3lM2PLPGFjQbF1dQa6ScRfobtl2cNUt/+U/ZqXa45MeKozhJ7gYk3i1YV5DG
         Z2Vb+CDajHNFA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 07/18] net: mdiobus: get rid of a BUG_ON()
Date:   Thu,  3 Jun 2021 13:10:18 -0400
Message-Id: <20210603171029.3169669-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603171029.3169669-1-sashal@kernel.org>
References: <20210603171029.3169669-1-sashal@kernel.org>
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
index c545fb1f82bd..5fc7b6c1a442 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -412,7 +412,8 @@ void mdiobus_unregister(struct mii_bus *bus)
 	struct mdio_device *mdiodev;
 	int i;
 
-	BUG_ON(bus->state != MDIOBUS_REGISTERED);
+	if (WARN_ON_ONCE(bus->state != MDIOBUS_REGISTERED))
+		return;
 	bus->state = MDIOBUS_UNREGISTERED;
 
 	for (i = 0; i < PHY_MAX_ADDR; i++) {
-- 
2.30.2

