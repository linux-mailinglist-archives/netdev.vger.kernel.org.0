Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5475B39A750
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbhFCRK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:10:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232062AbhFCRKi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:10:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EC6861402;
        Thu,  3 Jun 2021 17:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740133;
        bh=u5s1YdcZSBXUWXhImeKcnymWGOplfXCUMLiVvmJzk2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iq7wiiKpBn3jOQP+OULahPOpOD1Av8snpC+G+5bXacmAi1nJMN+ix5RYvxDb0amzP
         rdPJ/0phc+DZ/edxNu00xUCzV1ZFiAW65aZC9abZejvh4dEP5iGCYbqTbiQRRKuNFy
         rv9YZuq1uG44e72o/NIvJ6MoUhW3oycOxgoD1A0TZalTYWxaQCaPazYY0RoNXq3yju
         Bjv70W+7ZTg9b6860aGSUwDVJFL890mrXu1Quk+Jd3xzXo7Fifz25ZeOwAEa+xtR2c
         4DMvuHnu1qXJcMyi+o9SOvqEcgI6tvhxL5Id9rSpkIZKB1K4yDVO0loYPOSjDscfip
         jbZUzfFJuCBQw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 19/39] net: mdiobus: get rid of a BUG_ON()
Date:   Thu,  3 Jun 2021 13:08:09 -0400
Message-Id: <20210603170829.3168708-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170829.3168708-1-sashal@kernel.org>
References: <20210603170829.3168708-1-sashal@kernel.org>
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
index 757e950fb745..b848439fa837 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -608,7 +608,8 @@ void mdiobus_unregister(struct mii_bus *bus)
 	struct mdio_device *mdiodev;
 	int i;
 
-	BUG_ON(bus->state != MDIOBUS_REGISTERED);
+	if (WARN_ON_ONCE(bus->state != MDIOBUS_REGISTERED))
+		return;
 	bus->state = MDIOBUS_UNREGISTERED;
 
 	for (i = 0; i < PHY_MAX_ADDR; i++) {
-- 
2.30.2

