Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B407D1240F8
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 09:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbfLRICx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 03:02:53 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:42187 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726633AbfLRIC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 03:02:28 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ihUHj-0004ei-JI; Wed, 18 Dec 2019 09:02:19 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ihUHg-0000Ze-C8; Wed, 18 Dec 2019 09:02:16 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>, Chris Snook <chris.snook@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        James Hogan <jhogan@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: [PATCH v7 0/4] add dsa switch support for ar9331
Date:   Wed, 18 Dec 2019 09:02:11 +0100
Message-Id: <20191218080215.2151-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.24.0
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

changes v6:
- remove ag71xx changes from this patch set. It needs more work.
- ar9331: fix register definition and add ASCII art switch documentation.

changes v6:
- rebase against net-next

changes v5:
- remote support for port5. The effort of using this port is
  questionable. Currently, it is better to not use it at all, then
  adding buggy support.
- remove port enable call back. There is nothing what we actually need
  to enable.
- rebase it against v5.5-rc1 

changes v4:
- ag71xx: ag71xx_mac_validate fix always false comparison (&& -> ||)
- tag_ar9331: use skb_pull_rcsum() instead of skb_pull().
- tag_ar9331: drop skb_set_mac_header()

changes v3:
- ag71xx: ag71xx_mac_config: ignore MLO_AN_INBAND mode. It is not
  supported by HW and SW.
- ag71xx: ag71xx_mac_validate: return all supported bits on
  PHY_INTERFACE_MODE_NA

changes v2:
- move Atheros AR9331 TAG format to separate patch
- use netdev_warn_once in the tag driver to reduce potential message spam
- typo fixes
- reorder tag driver alphabetically 
- configure switch to maximal frame size
- use mdiobus_read/write
- fail if mdio sub node is not found
- add comment for post reset state
- remove deprecated comment about device id
- remove phy-handle option for node with fixed-link
- ag71xx: set 1G support only for GMII mode

This patch series provides dsa switch support for Atheros ar9331 WiSoC.
As side effect ag71xx needed to be ported to phylink to make the switch
driver (as well phylink based) work properly.

Oleksij Rempel (4):
  dt-bindings: net: dsa: qca,ar9331 switch documentation
  MIPS: ath79: ar9331: add ar9331-switch node
  net: dsa: add support for Atheros AR9331 TAG format
  net: dsa: add support for Atheros AR9331 built-in switch

 .../devicetree/bindings/net/dsa/ar9331.txt    | 148 +++
 arch/mips/boot/dts/qca/ar9331.dtsi            | 119 ++-
 arch/mips/boot/dts/qca/ar9331_dpt_module.dts  |  13 +
 drivers/net/dsa/Kconfig                       |   2 +
 drivers/net/dsa/Makefile                      |   1 +
 drivers/net/dsa/qca/Kconfig                   |  11 +
 drivers/net/dsa/qca/Makefile                  |   2 +
 drivers/net/dsa/qca/ar9331.c                  | 855 ++++++++++++++++++
 include/net/dsa.h                             |   2 +
 net/dsa/Kconfig                               |   6 +
 net/dsa/Makefile                              |   1 +
 net/dsa/tag_ar9331.c                          |  96 ++
 12 files changed, 1255 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/ar9331.txt
 create mode 100644 drivers/net/dsa/qca/Kconfig
 create mode 100644 drivers/net/dsa/qca/Makefile
 create mode 100644 drivers/net/dsa/qca/ar9331.c
 create mode 100644 net/dsa/tag_ar9331.c

-- 
2.24.0

