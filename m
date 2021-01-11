Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0D92F0C09
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 06:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbhAKFBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 00:01:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:52214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbhAKFBg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 00:01:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCA17229C6;
        Mon, 11 Jan 2021 05:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610341256;
        bh=KAV6E0b8RE1R5gEHSAletR4hXCAACeYOTCsrvDmu7Ww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Anbkfzh7+/r9XFNDUG1nn5g/RvR6UkSFHXoh0hzcKdmG3Kkmt0SgUMOlJQTT4ynFl
         EIx8GdHf/YZp6+HG5pw6th6CXzcoWFBAHX5y3D5b7I5HA+hO2P3khhsaTOX7gfwz1/
         5LOVzKyZ00UTSRm8voHB3y19J8E9njyYu4j/Vh+uXbHFHTkkhNUlglGUE4raCYUFsl
         qi/I1do5E+A2uPGFLXgRAGEfxzEr34xrkqRE5Ies/iigKC5JgCGja8Kz3Ub94yHC2M
         k5zU8UXzKrJDNWut8Uehoe6YWg6XVWA11KexxSuIwIuQ7p7cLAxUZvVXCzia3OpTez
         vAID2GvpDeRmQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        davem@davemloft.net, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v4 2/4] net: phylink: allow attaching phy for SFP modules on 802.3z mode
Date:   Mon, 11 Jan 2021 06:00:42 +0100
Message-Id: <20210111050044.22002-3-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210111050044.22002-1-kabel@kernel.org>
References: <20210111050044.22002-1-kabel@kernel.org>
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
Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phylink.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 84f6e197f965..f97d041f82f4 100644
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

