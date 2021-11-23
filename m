Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A00145A88D
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233389AbhKWQnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:43:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:47698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233113AbhKWQns (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 11:43:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC87860FE8;
        Tue, 23 Nov 2021 16:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637685640;
        bh=qjerIt6Uvl7jcepztOSIvq+5+1RCG0nkPZxqbSX3UGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JwPS5/d6lbogtOn6swqGp/P/4+bsjFAW690Gix5Ob/fhfYwJ5LRhuA4OzRpDKLHHR
         LT9YzJmNiijOo1+IJ12WaXrEJG8ohcoE4BKcaDRVuBNXYTd18fFBfP1VvaJmSudDn2
         1R4i1hkvagMDMIvBz4wUlzKt7PNcHo6ymjcPVmuPZo/AzWsvwv7cIlsqSoKz8mSwoo
         M1bEq6ja5uTyQU6kBUTQThdIgDDo2W0YNyOvahss+tEta/ryde/Wry8hfJ0jvbyoCO
         POIUNsCGLLSo+wRSwZDJTfzsuFIpzW6+cU8VLq/vbMUumEBLwSMHhsBeet3IsNo0A9
         UmdDbnuOnqgSA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>, davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v2 4/8] net: phylink: update supported_interfaces with modes from fwnode
Date:   Tue, 23 Nov 2021 17:40:23 +0100
Message-Id: <20211123164027.15618-5-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211123164027.15618-1-kabel@kernel.org>
References: <20211123164027.15618-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the 'phy-mode' property can be a string array containing more
PHY modes (all that are supported by the board), update the bitmap of
interfaces supported by the MAC with this property.

Normally this would be a simple intersection (of interfaces supported by
the current implementation of the driver and interfaces supported by the
board), but we need to keep being backwards compatible with older DTs,
which may only define one mode, since, as Russell King says,
  conventionally phy-mode has meant "this is the mode we want to operate
  the PHY interface in" which was fine when PHYs didn't change their
  mode depending on the media speed

An example is DT defining
  phy-mode = "sgmii";
but the board supporting also 1000base-x and 2500base-x.

Add the following logic to keep this backwards compatiblity:
- if more PHY modes are defined, do a simple intersection
- if one PHY mode is defined:
  - if it is sgmii, 1000base-x or 2500base-x, add all three and then do
    the intersection
  - if it is 10gbase-r or usxgmii, add both, and also 5gbase-r,
    2500base-x, 1000base-x and sgmii, and then do the intersection

This is simple enough and should work for all boards.

Nonetheless it is possible (although extremely unlikely, in my opinion)
that a board will be found that (for example) defines
  phy-mode = "sgmii";
and the MAC drivers supports sgmii, 1000base-x and 2500base-x, but the
board DOESN'T support 2500base-x, because of electrical reasons (since
the frequency is 2.5x of sgmii).
Our code will in this case incorrectly infer also support for
2500base-x. To avoid this, the board maintainer should either change DTS
to
  phy-mode = "sgmii", "1000base-x";
and update device tree on all boards, or, if that is impossible, add a
fix into the function we are introducing in this commit.

Another example would be a board with device-tree defining
  phy-mode = "10gbase-r";
We infer from this all other modes (sgmii, 1000base-x, 2500base-x,
5gbase-r, usxgmii), and these then get filtered by those supported by
the driver. But it is possible that a driver supports all of these
modes, and yet not all are supported because the board has an older
version of the TF-A firmware, which implements changing of PHY modes via
SMC calls. For this case, the board maintainer should either provide all
supported modes in the phy-mode property, or add a fix into this
function that somehow checks for this situation. But this is a really
unprobable scenario, in my opinion.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
Changes since v1:
- added 10gbase-r example scenario to commit message
- changed phylink_update_phy_modes() so that if supported_interfaces is
  empty (an unconverted driver that doesn't fill up this member), we
  leave it empty
- rewritten phylink_update_phy_modes() according to Sean Anderson's
  comment: use phy_interface_and/or() instead of several
  if (test_bit) set_bit
---
 drivers/net/phy/phylink.c | 70 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 3603c024109a..d2300a3a60ec 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -564,6 +564,74 @@ static int phylink_parse_fixedlink(struct phylink *pl,
 	return 0;
 }
 
+static void phylink_update_phy_modes(struct phylink *pl,
+				     struct fwnode_handle *fwnode)
+{
+	unsigned long *supported = pl->config->supported_interfaces;
+	DECLARE_PHY_INTERFACE_MASK(modes);
+
+	/* FIXME: If supported is empty, leave it as it is. This happens for
+	 * unconverted drivers that don't fill up supported_interfaces. Once all
+	 * such drivers are converted, we can drop this.
+	 */
+	if (phy_interface_empty(supported))
+		return;
+
+	if (fwnode_get_phy_modes(fwnode, modes) < 0)
+		return;
+
+	/* If no modes are defined in fwnode, interpret it as all modes
+	 * supported by the MAC are supported by the board.
+	 */
+	if (phy_interface_empty(modes))
+		return;
+
+	/* We want the intersection of given supported modes with those defined
+	 * in DT.
+	 *
+	 * Some older device-trees mention only one of `sgmii`, `1000base-x` or
+	 * `2500base-x`, while supporting all three. Other mention `10gbase-r`
+	 * or `usxgmii`, while supporting both, and also `sgmii`, `1000base-x`,
+	 * `2500base-x` and `5gbase-r`.
+	 * For backwards compatibility with these older DTs, make it so that if
+	 * one of these modes is mentioned in DT and MAC supports more of them,
+	 * keep all that are supported according to the logic above.
+	 *
+	 * Nonetheless it is possible that a device may support only one mode,
+	 * for example 1000base-x, due to strapping pins or some other reasons.
+	 * If a specific device supports only the mode mentioned in DT, the
+	 * exception should be made here with of_machine_is_compatible().
+	 */
+	if (bitmap_weight(modes, PHY_INTERFACE_MODE_MAX) == 1) {
+		DECLARE_PHY_INTERFACE_MASK(mask);
+		bool lower = false;
+
+		if (test_bit(PHY_INTERFACE_MODE_10GBASER, modes) ||
+		    test_bit(PHY_INTERFACE_MODE_USXGMII, modes)) {
+			phy_interface_zero(mask);
+			__set_bit(PHY_INTERFACE_MODE_5GBASER, mask);
+			__set_bit(PHY_INTERFACE_MODE_10GBASER, mask);
+			__set_bit(PHY_INTERFACE_MODE_USXGMII, mask);
+			phy_interface_and(mask, supported, mask);
+			phy_interface_or(modes, modes, mask);
+			lower = true;
+		}
+
+		if (lower || (test_bit(PHY_INTERFACE_MODE_SGMII, modes) ||
+			      test_bit(PHY_INTERFACE_MODE_1000BASEX, modes) ||
+			      test_bit(PHY_INTERFACE_MODE_2500BASEX, modes))) {
+			phy_interface_zero(mask);
+			__set_bit(PHY_INTERFACE_MODE_SGMII, mask);
+			__set_bit(PHY_INTERFACE_MODE_1000BASEX, mask);
+			__set_bit(PHY_INTERFACE_MODE_2500BASEX, mask);
+			phy_interface_and(mask, supported, mask);
+			phy_interface_or(modes, modes, mask);
+		}
+	}
+
+	phy_interface_and(supported, supported, modes);
+}
+
 static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 {
 	struct fwnode_handle *dn;
@@ -1157,6 +1225,8 @@ struct phylink *phylink_create(struct phylink_config *config,
 	__set_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state);
 	timer_setup(&pl->link_poll, phylink_fixed_poll, 0);
 
+	phylink_update_phy_modes(pl, fwnode);
+
 	bitmap_fill(pl->supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
 	linkmode_copy(pl->link_config.advertising, pl->supported);
 	phylink_validate(pl, pl->supported, &pl->link_config);
-- 
2.32.0

