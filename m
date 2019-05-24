Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED676296DC
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 13:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391085AbfEXLM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 07:12:59 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:38049 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391077AbfEXLMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 07:12:38 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1hU87g-0000GY-QJ; Fri, 24 May 2019 13:12:28 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1hU87e-0007Fj-4K; Fri, 24 May 2019 13:12:26 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Chuanhong Guo <gch981213@gmail.com>,
        info@freifunk-bad-gandersheim.net
Subject: [PATCH v6 0/3] MIPS: ath79: add ag71xx support
Date:   Fri, 24 May 2019 13:12:21 +0200
Message-Id: <20190524111224.24819-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019.05.24 v6:
- ag71xx: remove double union
- ag71xx: reverse Christmas tree for all functions
- ag71xx: add Reviewed-by: Andrew Lunn <andrew@lunn.ch>

2019.05.20 v5:
- ag71xx: remove MII_CMD_WRITE, the name is confusing. It is
  actually disables MII_CMD_READ.
- ag71xx: rework ag71xx_mdio_mii_read/write
- ag71xx: set proper mask for the addr in ag71xx_mdio_mii_read/write
- Kconfig: remove MDIO_BITBANG
- ag71xx: ./scripts/checkpatch.pl it.

2019.05.19 v4:
- DT: define eth and mdio clocks
- ag71xx: remove module parameters
- ag71xx: return proper error value on mdio_read/write
- ag71xx: use proper mdio clock registration
- ag71xx: add ag71xx_dma_wait_stop() for ag71xx_dma_reset()
- ag71xx: remove ag71xx_speed_str()
- ag71xx: use phydev->link/sped/duplex instead of ag-> variants
- ag71xx: use WARN() instead of BUG()
- ag71xx: drop big part of ag71xx_phy_link_adjust()
- ag71xx: drop most of ag71xx_do_ioctl()
- ag71xx: register eth clock
- ag71xx: remove AG71XX_ETH0_NO_MDIO quirk.

2019.04.22 v3:
- ag71xx: use phy_modes() instead of ag71xx_get_phy_if_mode_name()
- ag71xx: remove .ndo_poll_controller support
- ag71xx: unregister_netdev before disconnecting phy.

2019.04.18 v2:
- ag71xx: add list of openwrt authors
- ag71xx: remove redundant PHY_POLL assignment
- ag71xx: use phy_attached_info instead of netif_info
- ag71xx: remove redundant netif_carrier_off() on .stop.
- DT: use "ethernet" instead of "eth"

This patch series provide ethernet support for many Atheros/QCA
MIPS based SoCs.

I reworked ag71xx driver which was previously maintained within OpenWRT
repository. So far, following changes was made to make upstreaming
easier:
- everything what can be some how used in user space was removed. Most
  of it was debug functionality.
- most of deficetree bindings was removed. Not every thing made sense
  and most of it is SoC specific, so it is possible to detect it by
  compatible.
- mac and mdio parts are merged in to one driver. It makes easier to
  maintaine SoC specific quirks.

Oleksij Rempel (3):
  dt-bindings: net: add qca,ar71xx.txt documentation
  MIPS: ath79: ar9331: add Ethernet nodes
  net: ethernet: add ag71xx driver

 .../devicetree/bindings/net/qca,ar71xx.txt    |   45 +
 arch/mips/boot/dts/qca/ar9331.dtsi            |   26 +
 arch/mips/boot/dts/qca/ar9331_dpt_module.dts  |    8 +
 drivers/net/ethernet/atheros/Kconfig          |   10 +-
 drivers/net/ethernet/atheros/Makefile         |    1 +
 drivers/net/ethernet/atheros/ag71xx.c         | 1898 +++++++++++++++++
 6 files changed, 1987 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/net/qca,ar71xx.txt
 create mode 100644 drivers/net/ethernet/atheros/ag71xx.c

-- 
2.20.1

