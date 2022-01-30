Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0CA4A35D1
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 11:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240477AbiA3KzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 05:55:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239076AbiA3KzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 05:55:21 -0500
X-Greylist: delayed 1780 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 30 Jan 2022 02:55:21 PST
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EAD9C061714;
        Sun, 30 Jan 2022 02:55:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
        s=the; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:Sender:
        Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date
        :Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:
        References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:
        List-Owner:List-Archive; bh=zynwQsXAChbzANQqprwMGE7qGv9t50Oo07QICLYU9a0=; b=Z
        K8tRPtlmUhokQQlgSXpHDLec4xjYjkTQl6oFZ1GPCWgQy2YyrGnhNmtUr8GG4q3NR0jhiKh9A2y61
        pfq1eOPalgLqQ47fxD6JmCK8r/Sb6cXRKYN3OZ8NiEC9yhT8uxEqYe1tTUJL6RVfepb6+yFT5sp2Y
        Osx4iy/QAibB+/8I6lhU5Tb35eztlYgE+/Mky3gIAhyM5kvHjcj4/S6i6Sw2UW27P3tuvH0JetOT6
        OFx58fSC5azHX6pNGqx+Na+tHVtfBMkIiOpdumXyswfZDNqGvg6eXTMPsSZUJ269N1dkqPLBB7Mwz
        jtBcyMpAaEbN7MJWuh2h0DMYmTymlFFrg==;
Received: from noodles by the.earth.li with local (Exim 4.94.2)
        (envelope-from <noodles@earth.li>)
        id 1nE7Oi-00A0XI-KA; Sun, 30 Jan 2022 10:25:28 +0000
Date:   Sun, 30 Jan 2022 10:25:28 +0000
From:   Jonathan McDowell <noodles@earth.li>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Luo Jie <luoj@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Marko <robimarko@gmail.com>
Subject: [PATCH net] net: phy: Fix qca8081 with speeds lower than 2.5Gb/s
Message-ID: <YfZnmMteVry/A1XR@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A typo in qca808x_read_status means we try to set SMII mode on the port
rather than SGMII when the link speed is not 2.5Gb/s. This results in no
traffic due to the mismatch in configuration between the phy and the
mac.

Fixes: 79c7bc0521545 ("net: phy: add qca8081 read_status")
Signed-off-by: Jonathan McDowell <noodles@earth.li>
---
 drivers/net/phy/at803x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 5b6c0d120e09..7077e3a92d31 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -1691,7 +1691,7 @@ static int qca808x_read_status(struct phy_device *phydev)
 	if (phydev->link && phydev->speed == SPEED_2500)
 		phydev->interface = PHY_INTERFACE_MODE_2500BASEX;
 	else
-		phydev->interface = PHY_INTERFACE_MODE_SMII;
+		phydev->interface = PHY_INTERFACE_MODE_SGMII;
 
 	/* generate seed as a lower random value to make PHY linked as SLAVE easily,
 	 * except for master/slave configuration fault detected.
-- 
2.30.2

