Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC3441562F
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 05:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239105AbhIWDkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 23:40:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239111AbhIWDj5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 23:39:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C18B66124C;
        Thu, 23 Sep 2021 03:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368306;
        bh=Rv8CJQga4Yv8ECnEEldtb1CzDuxQ88OavcGdUOUP940=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HqWacRtLw+HaqQ0jxDbZHaF+u3NGd//F88DiTg5o19MYGVqzIAp3hukyuVIycBvAb
         OmuXY4oGArZCMF5PZwz3gfB/7qneqKELeurT+KPwh9N4FPw22tXkpuyvgPRhkKoYH3
         OiW/nDxQD9u4A5Nw+706fSBoBtg5q6WYMDVqLAhHuK5OpVsDHF4lUR6vxRdxLZIyUW
         TGeUDGKK2wKqC8Zx/mALSdF1MQXvtuuCa8uA6kmPRKNA4yTfISeZ2GQlLSswwyqjSl
         dcb9pCx+CY1mMNpUG4T4ecUhGwHj7/c77wNg+3nbCfundW7IbVXHnMBgvac7gN1eCK
         goQj5WnIAuKdQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Rossi <nathan.rossi@digi.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        andrew@lunn.ch, hkallweit1@gmail.com, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 02/34] net: phylink: Update SFP selected interface on advertising changes
Date:   Wed, 22 Sep 2021 23:37:50 -0400
Message-Id: <20210923033823.1420814-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210923033823.1420814-1-sashal@kernel.org>
References: <20210923033823.1420814-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Rossi <nathan.rossi@digi.com>

[ Upstream commit ea269a6f720782ed94171fb962b14ce07c372138 ]

Currently changes to the advertising state via ethtool do not cause any
reselection of the configured interface mode after the SFP is already
inserted and initially configured.

While it is not typical to change the advertised link modes for an
interface using an SFP in certain use cases it is desirable. In the case
of a SFP port that is capable of handling both SFP and SFP+ modules it
will automatically select between 1G and 10G modes depending on the
supported mode of the SFP. However if the SFP module is capable of
working in multiple modes (e.g. a SFP+ DAC that can operate at 1G or
10G), one end of the cable may be attached to a SFP 1000base-x port thus
the SFP+ end must be manually configured to the 1000base-x mode in order
for the link to be established.

This change causes the ethtool setting of advertised mode changes to
reselect the interface mode so that the link can be established.
Additionally when a module is inserted the advertising mode is reset to
match the supported modes of the module.

Signed-off-by: Nathan Rossi <nathan.rossi@digi.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phylink.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index eb29ef53d971..91c600c4c04a 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1522,6 +1522,32 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 	if (config.an_enabled && phylink_is_empty_linkmode(config.advertising))
 		return -EINVAL;
 
+	/* If this link is with an SFP, ensure that changes to advertised modes
+	 * also cause the associated interface to be selected such that the
+	 * link can be configured correctly.
+	 */
+	if (pl->sfp_port && pl->sfp_bus) {
+		config.interface = sfp_select_interface(pl->sfp_bus,
+							config.advertising);
+		if (config.interface == PHY_INTERFACE_MODE_NA) {
+			phylink_err(pl,
+				    "selection of interface failed, advertisement %*pb\n",
+				    __ETHTOOL_LINK_MODE_MASK_NBITS,
+				    config.advertising);
+			return -EINVAL;
+		}
+
+		/* Revalidate with the selected interface */
+		linkmode_copy(support, pl->supported);
+		if (phylink_validate(pl, support, &config)) {
+			phylink_err(pl, "validation of %s/%s with support %*pb failed\n",
+				    phylink_an_mode_str(pl->cur_link_an_mode),
+				    phy_modes(config.interface),
+				    __ETHTOOL_LINK_MODE_MASK_NBITS, support);
+			return -EINVAL;
+		}
+	}
+
 	mutex_lock(&pl->state_mutex);
 	pl->link_config.speed = config.speed;
 	pl->link_config.duplex = config.duplex;
@@ -2101,7 +2127,9 @@ static int phylink_sfp_config(struct phylink *pl, u8 mode,
 	if (phy_interface_mode_is_8023z(iface) && pl->phydev)
 		return -EINVAL;
 
-	changed = !linkmode_equal(pl->supported, support);
+	changed = !linkmode_equal(pl->supported, support) ||
+		  !linkmode_equal(pl->link_config.advertising,
+				  config.advertising);
 	if (changed) {
 		linkmode_copy(pl->supported, support);
 		linkmode_copy(pl->link_config.advertising, config.advertising);
-- 
2.30.2

