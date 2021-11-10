Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A71944C886
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 20:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232621AbhKJTKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 14:10:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:33946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231968AbhKJTKI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 14:10:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAA6861027;
        Wed, 10 Nov 2021 19:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636571240;
        bh=xMx4vcg2t/Sj4yNqR+ICMx/LpoHCFrlG3jaM6qXSGRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oTa+0xFN9VzKMJtMHj6dx5i6cI2TwuM+i/8cSz0OIsPn2H5pBtRLgbk9RL0WrR5Su
         vi3FkKokx4iaAKym+VPxdr4hsW/G+5UFRjeJSurOe6dbWzzkRyBaZNb1ggKUibSMtl
         N3C6TIQReL0udJyPkiBnCpDYcZNDehqTJ41KOrFnvFolQ/zCltfgHhZdefr5ZTl9Vh
         gtoLLXWQvVPbJsrf5JO3PVyAyrUWMroLUXlXytMLmDuQjHUN8iZOJ1/VwKbVkjMPa+
         bju6F/eieVdJhQXOfb4sE+Hb6pBq0jDdPToRK9KbLHYeGVGE6QPHPAVNEhD3DjVkDy
         nbNiifjJClfjw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH RFC net-next 4/8] net: phylink: update supported_interfaces with modes from fwnode
Date:   Wed, 10 Nov 2021 20:07:05 +0100
Message-Id: <20211110190709.16505-5-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211110190709.16505-1-kabel@kernel.org>
References: <20211110190709.16505-1-kabel@kernel.org>
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

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/phylink.c | 63 +++++++++++++++++++++++++++++++++++++++
 include/linux/phy.h       |  6 ++++
 2 files changed, 69 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 3ad7397b8119..4a8a0adf8c6c 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -311,6 +311,67 @@ static int phylink_parse_fixedlink(struct phylink *pl,
 	return 0;
 }
 
+static void phylink_update_phy_modes(struct phylink *pl,
+				     struct fwnode_handle *fwnode)
+{
+	unsigned long *supported = pl->config->supported_interfaces;
+	DECLARE_PHY_INTERFACE_MASK(modes);
+
+	if (fwnode_get_phy_modes(fwnode, modes) < 0)
+		return;
+
+	if (phy_interface_empty(modes))
+		return;
+
+	/* If supported is empty, just copy modes defined in fwnode. */
+	if (phy_interface_empty(supported))
+		return phy_interface_copy(supported, modes);
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
+		bool lower = false;
+
+		if (test_bit(PHY_INTERFACE_MODE_10GBASER, modes) ||
+		    test_bit(PHY_INTERFACE_MODE_USXGMII, modes)) {
+			if (test_bit(PHY_INTERFACE_MODE_5GBASER, supported))
+				__set_bit(PHY_INTERFACE_MODE_5GBASER, modes);
+			if (test_bit(PHY_INTERFACE_MODE_10GBASER, supported))
+				__set_bit(PHY_INTERFACE_MODE_10GBASER, modes);
+			if (test_bit(PHY_INTERFACE_MODE_USXGMII, supported))
+				__set_bit(PHY_INTERFACE_MODE_USXGMII, modes);
+			lower = true;
+		}
+
+		if (lower || (test_bit(PHY_INTERFACE_MODE_SGMII, modes) ||
+			      test_bit(PHY_INTERFACE_MODE_1000BASEX, modes) ||
+			      test_bit(PHY_INTERFACE_MODE_2500BASEX, modes))) {
+			if (test_bit(PHY_INTERFACE_MODE_SGMII, supported))
+				__set_bit(PHY_INTERFACE_MODE_SGMII, modes);
+			if (test_bit(PHY_INTERFACE_MODE_1000BASEX, supported))
+				__set_bit(PHY_INTERFACE_MODE_1000BASEX, modes);
+			if (test_bit(PHY_INTERFACE_MODE_2500BASEX, supported))
+				__set_bit(PHY_INTERFACE_MODE_2500BASEX, modes);
+		}
+	}
+
+	phy_interface_and(supported, supported, modes);
+}
+
 static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 {
 	struct fwnode_handle *dn;
@@ -904,6 +965,8 @@ struct phylink *phylink_create(struct phylink_config *config,
 	__set_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state);
 	timer_setup(&pl->link_poll, phylink_fixed_poll, 0);
 
+	phylink_update_phy_modes(pl, fwnode);
+
 	bitmap_fill(pl->supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
 	linkmode_copy(pl->link_config.advertising, pl->supported);
 	phylink_validate(pl, pl->supported, &pl->link_config);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 96e43fbb2dd8..effa4137f173 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -169,6 +169,12 @@ static inline bool phy_interface_empty(const unsigned long *intf)
 	return bitmap_empty(intf, PHY_INTERFACE_MODE_MAX);
 }
 
+static inline void phy_interface_copy(unsigned long *dst,
+				      const unsigned long *src)
+{
+	bitmap_copy(dst, src, PHY_INTERFACE_MODE_MAX);
+}
+
 static inline void phy_interface_and(unsigned long *dst, const unsigned long *a,
 				     const unsigned long *b)
 {
-- 
2.32.0

