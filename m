Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3000B29F7DF
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 23:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725950AbgJ2WZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 18:25:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:43750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbgJ2WZQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 18:25:16 -0400
Received: from dellmb.labs.office.nic.cz (nat-1.nic.cz [217.31.205.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 064FB21531;
        Thu, 29 Oct 2020 22:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604010316;
        bh=3XTwgAa3BoI6bQchtn2eT/wund/GYOdEgOyRS1m8FS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gwqyGXHO7k49mia3fIGGKAJiEuPZn3LW7EL3/dsWYCXu7IExT1whLvt3HroVVa4lt
         IhZcB8t1wV5IGvELmC43iY+gXs2Qp8yaNAU/byBJPzL0ruBzfidd8rHWi07NQHt33o
         fCTp2l8yP9aqkI0VH8Nb6NBSPSrQiAkoT0g9SRUs=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net-next v2 2/5] net: phylink: allow attaching phy for SFP modules on 802.3z mode
Date:   Thu, 29 Oct 2020 23:25:06 +0100
Message-Id: <20201029222509.27201-3-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201029222509.27201-1-kabel@kernel.org>
References: <20201029222509.27201-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some SFPs may contain an internal PHY which may in some cases want to
connect with the host interface in 1000base-x/2500base-x mode.
Do not fail if such PHY is being attached in one of these PHY interface
modes.

Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 5d8c015bc9f2..705c49c37348 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1018,7 +1018,7 @@ static int phylink_attach_phy(struct phylink *pl, struct phy_device *phy,
 {
 	if (WARN_ON(pl->cfg_link_an_mode == MLO_AN_FIXED ||
 		    (pl->cfg_link_an_mode == MLO_AN_INBAND &&
-		     phy_interface_mode_is_8023z(interface))))
+		     phy_interface_mode_is_8023z(interface) && !pl->sfp_bus)))
 		return -EINVAL;
 
 	if (pl->phydev)
@@ -2069,9 +2069,6 @@ static int phylink_sfp_config(struct phylink *pl, u8 mode,
 		    phylink_an_mode_str(mode), phy_modes(config.interface),
 		    __ETHTOOL_LINK_MODE_MASK_NBITS, support);
 
-	if (phy_interface_mode_is_8023z(iface) && pl->phydev)
-		return -EINVAL;
-
 	changed = !linkmode_equal(pl->supported, support);
 	if (changed) {
 		linkmode_copy(pl->supported, support);
-- 
2.26.2

