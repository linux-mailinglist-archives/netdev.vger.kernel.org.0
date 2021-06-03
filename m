Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C36D939A8D0
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233806AbhFCRR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:17:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233654AbhFCRQF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:16:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40E28613F5;
        Thu,  3 Jun 2021 17:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740283;
        bh=O+Yu/TrYmYQMYndk7OBP5deROJlglwmdmEulGLzlJSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bRGJbgHWwqDDxaalFKcxRGKWpsDC2O78RDWvlMOidVrmBo4Y5QqFMbMU1uaTpsL+3
         Aw8FfUcUkcT7wT3JT4hpy5zc3ObhT2rDTOcjdj7mclAtFTYlOlLkwabKxqGo/i0NTg
         vjTyqQjv9b8gU30IwV5Z8uo5sclHkruLUtWKC56bQAmMkBmpEpqC1z2OCJikKY034l
         vNLMjCUgxzxuLBL0o7knGq9PE0869WFtB1ZRWgGxAkJVlJ2oASyq7Vm/DjjBN78nun
         RhBBgIWhbjUqoJ9hEp0FxP4xOmmNpidVVRdDkr0rGURhQHsfCMgZVIRTAWAoJ1kiC7
         W4+NW3doMrQuw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 06/15] net: mdiobus: get rid of a BUG_ON()
Date:   Thu,  3 Jun 2021 13:11:05 -0400
Message-Id: <20210603171114.3170086-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603171114.3170086-1-sashal@kernel.org>
References: <20210603171114.3170086-1-sashal@kernel.org>
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
index ccefba7af960..5ea86fd57ae6 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -308,7 +308,8 @@ void mdiobus_unregister(struct mii_bus *bus)
 {
 	int i;
 
-	BUG_ON(bus->state != MDIOBUS_REGISTERED);
+	if (WARN_ON_ONCE(bus->state != MDIOBUS_REGISTERED))
+		return;
 	bus->state = MDIOBUS_UNREGISTERED;
 
 	for (i = 0; i < PHY_MAX_ADDR; i++) {
-- 
2.30.2

