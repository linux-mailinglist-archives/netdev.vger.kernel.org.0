Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECED39A7A6
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232509AbhFCRMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:12:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232290AbhFCRLV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:11:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1ECF3613F6;
        Thu,  3 Jun 2021 17:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740175;
        bh=Gui2hudISqEfdhqO0LlkhxgmBIPBJErNssutgA9Cb14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a6A1WAS3zdIuhEYxkI96CiSyWtbEIGYhWFV0v3ARTRLBL9YQ6Y2/A9dvVVpIY3Ky9
         7i8T0YL2L1BVVF2zin7kGZIn8yGGX2r8gpfxtWdRy9KP1BscPIlUIJ84kidqYzo8MZ
         bV1DmjU5lS4RdsLmoWgDDtzoCjnWgzr20agbYgNmQztgWvOku7q7WricrI8WRvspqD
         +06xsJNDjX5f7PxH4DRD9X4C+ZQm5HTv7NhFnzsZMZUQLR1o1loDfKyfM6f4gFyX/K
         0tLjvx4XWsXhzQ+EM3WWwziW177r8uxp4X+x6Ns3MQ0CP3EBggAsMb9GXd6RPjdpdM
         gHqpNNszk9Zpw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 13/31] net: mdiobus: get rid of a BUG_ON()
Date:   Thu,  3 Jun 2021 13:09:01 -0400
Message-Id: <20210603170919.3169112-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170919.3169112-1-sashal@kernel.org>
References: <20210603170919.3169112-1-sashal@kernel.org>
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
index 229e480179ff..5bf06eac04ba 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -453,7 +453,8 @@ void mdiobus_unregister(struct mii_bus *bus)
 	struct mdio_device *mdiodev;
 	int i;
 
-	BUG_ON(bus->state != MDIOBUS_REGISTERED);
+	if (WARN_ON_ONCE(bus->state != MDIOBUS_REGISTERED))
+		return;
 	bus->state = MDIOBUS_UNREGISTERED;
 
 	for (i = 0; i < PHY_MAX_ADDR; i++) {
-- 
2.30.2

