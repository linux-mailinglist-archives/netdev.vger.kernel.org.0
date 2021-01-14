Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344B42F5A00
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 05:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbhANEof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 23:44:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:34860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726640AbhANEo1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 23:44:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F1FF2395B;
        Thu, 14 Jan 2021 04:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610599426;
        bh=JkPVPwYLS4y43fsbynG1MyOKpEOsyx6ePisAgjEQMhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uVRRk3t6dSdqg7qbuj44yE6CxbKrWEAEqcVbZTM8GIGs3F+5hbl7Z74Kch5QOM8LA
         iji7a52ESWX5b0WopDy9zbpIG9MxaHkOX+UTIexSz+9SxT10ctd2iGnQCVVzc5cu9k
         Oh9eI224R2R2TCU3kEGby9n9EN6HUfLFjIaVDhTuLPuJi6CeeSDbl3YekeDbdd/T1x
         cO4Lj90Y0vohBMdRGC1Hj86eReQyjbIbmEUUbax5AU1JRxQyo3kqPbrO0La1AeqWsK
         6zTthUG2Sa16m5zXniGOt1Q9pvfqJaNgAW/nD18QNw6r11Io7vkPfdrac6U+sel8MS
         Kshx4eh9RFqFQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        davem@davemloft.net, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v5 3/5] net: phylink: allow attaching phy for SFP modules on 802.3z mode
Date:   Thu, 14 Jan 2021 05:43:29 +0100
Message-Id: <20210114044331.5073-4-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210114044331.5073-1-kabel@kernel.org>
References: <20210114044331.5073-1-kabel@kernel.org>
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
Reviewed-by: Pali Rohár <pali@kernel.org>
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

