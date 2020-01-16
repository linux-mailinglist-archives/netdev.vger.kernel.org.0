Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92F3413E3AB
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388160AbgAPRDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:03:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:57166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388586AbgAPRDL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:03:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98F5820730;
        Thu, 16 Jan 2020 17:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194190;
        bh=QdBoVwWQMq0aqvMeaztun3dghZY+IZ7Q6+kCOypgPlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qsapOdpE39YLN4TQg661R73BwU8mLL9zPZomadHbCuyHs0gLN1mBFcx/RDY3QC7s3
         7974fOAPHmnRhT7iNDDV4YdT7+vdl48ENgkOxXVqk2HJOGPgWD4zkUnyh3IPYpqMhu
         Fd+PJArmXgOIL8gYcrHeW42SppzchEB7GRdwSdug=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 262/671] net: dsa: Avoid null pointer when failing to connect to PHY
Date:   Thu, 16 Jan 2020 11:52:51 -0500
Message-Id: <20200116165940.10720-145-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>

[ Upstream commit 6146dd453e235c487d85ae4dc6cc08978a1c890f ]

When phylink_of_phy_connect fails, dsa_slave_phy_setup tries to save the
day by connecting to an alternative PHY, none other than a PHY on the
switch's internal MDIO bus, at an address equal to the port's index.

However this does not take into consideration the scenario when the
switch that failed to probe an external PHY does not have an internal
MDIO bus at all.

Fixes: aab9c4067d23 ("net: dsa: Plug in PHYLINK support")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/slave.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index b39720d0995d..8ee28b6016d8 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1219,9 +1219,9 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 		phy_flags = ds->ops->get_phy_flags(ds, dp->index);
 
 	ret = phylink_of_phy_connect(dp->pl, port_dn, phy_flags);
-	if (ret == -ENODEV) {
-		/* We could not connect to a designated PHY or SFP, so use the
-		 * switch internal MDIO bus instead
+	if (ret == -ENODEV && ds->slave_mii_bus) {
+		/* We could not connect to a designated PHY or SFP, so try to
+		 * use the switch internal MDIO bus instead
 		 */
 		ret = dsa_slave_phy_connect(slave_dev, dp->index);
 		if (ret) {
@@ -1233,7 +1233,7 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 		}
 	}
 
-	return 0;
+	return ret;
 }
 
 static struct lock_class_key dsa_slave_netdev_xmit_lock_key;
-- 
2.20.1

