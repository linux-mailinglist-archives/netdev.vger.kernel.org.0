Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEE51D67D6
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 13:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbgEQLxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 07:53:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727833AbgEQLxq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 May 2020 07:53:46 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0285206F4;
        Sun, 17 May 2020 11:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589716426;
        bh=9FsYMlSfeCJWncuLjQ3mbr2AKny28mgZM1pKTVtJH+0=;
        h=From:To:Cc:Subject:Date:From;
        b=izz1rlgYRMsOwX7HHtLlNSTYQSiEacpAbkDdtQ+n3Txs1WrGDi3zTxZ+okrdd11gx
         2ujG2OmdbW7DsF4j2bkS9rJAPjoFT3KMO+ph16PAOhfvvCe+130aSrLbiM8dEL+wNi
         VvJR4Myn2x60RiTnQy3xct56HhjH+qyhMUk2JA90=
From:   Leon Romanovsky <leon@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, netdev@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net] net: phy: propagate an error back to the callers of phy_sfp_probe
Date:   Sun, 17 May 2020 14:53:40 +0300
Message-Id: <20200517115340.78554-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

The compilation warning below reveals that the errors returned from
the sfp_bus_add_upstream() call are not propagated to the callers.
Fix it by returning "ret".

14:37:51 drivers/net/phy/phy_device.c: In function 'phy_sfp_probe':
14:37:51 drivers/net/phy/phy_device.c:1236:6: warning: variable 'ret'
   set but not used [-Wunused-but-set-variable]
14:37:51  1236 |  int ret;
14:37:51       |      ^~~

Fixes: 298e54fa810e ("net: phy: add core phylib sfp support")
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/phy/phy_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index ac2784192472..697c74deb222 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1233,7 +1233,7 @@ int phy_sfp_probe(struct phy_device *phydev,
 		  const struct sfp_upstream_ops *ops)
 {
 	struct sfp_bus *bus;
-	int ret;
+	int ret = 0;

 	if (phydev->mdio.dev.fwnode) {
 		bus = sfp_bus_find_fwnode(phydev->mdio.dev.fwnode);
@@ -1245,7 +1245,7 @@ int phy_sfp_probe(struct phy_device *phydev,
 		ret = sfp_bus_add_upstream(bus, phydev, ops);
 		sfp_bus_put(bus);
 	}
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(phy_sfp_probe);

--
2.26.2

