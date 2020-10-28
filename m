Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A6929D689
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731240AbgJ1WOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:14:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:58040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730220AbgJ1WOd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:14:33 -0400
Received: from dellmb.labs.office.nic.cz (nat-1.nic.cz [217.31.205.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A39F24171;
        Wed, 28 Oct 2020 22:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603923272;
        bh=2rzczwEnY3kmFD4UuO1ztrExR1WAw3kW3Eaz0UACh8g=;
        h=From:To:Cc:Subject:Date:From;
        b=W/iGmlHLxGnEF4ZFzxmc4VFzGA+bxjw3ATGG6gpzm3+KBU1ZxOE8zKZtzrKCX/NAs
         RGkba9W5fPD7hShRdtLRfQApoW1Y9cnmJNE/x7pI6HvoIvwFYgCQzvizZyX7Wz+5Qg
         Qe0KNUm1eFIj0BUVICB47JAWtRODHe8JFdsuLSqI=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net-next 0/5] Support for RollBall 10G copper SFP modules
Date:   Wed, 28 Oct 2020 23:14:22 +0100
Message-Id: <20201028221427.22968-1-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

this series adds support for RollBall/Hilink SFP modules.
These are copper modules capable of up to 10G via copper.
They contain a Marvell 88X3310 PHY.

These modules by default configure the internal PHY into XFI with Rate
Matching mode on the MAC side. To support devices which have MAC capable
of only lower than 10G SerDeses, the fourth patch sets the PHYs MACTYPE
in this case (in the marvell10g driver). Russell King has patches in his
tree that solve similar thing, but they depend on more complicated and
experimental patches. So in the meantime I think this patch can be
accepted (since it should not break anything that already works).

The protocol via which communication with the PHY can be done
is different than the standard one. This series therefore adds
support for this protocol into the mdio-i2c driver:
  - Russell first suggested that the protocol should be selected
    by PHY address: currently all SFP modules use PHY address 22 (0x16)
    because the PHY is accessible via I2C on address 0x56 (=0x40 + 0x16).
  - but Andrew thinks that this could cause problems in the future,
    and that instead the protocol should be selected not via PHY address,
    but on instatination of the mdiobus. This series uses this approach.

Marek

Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <rmk+kernel@armlinux.org.uk>

Marek Behún (5):
  net: phy: mdio-i2c: support I2C MDIO protocol for RollBall SFP modules
  net: phylink: allow attaching phy for SFP modules on 802.3z mode
  net: sfp: configure/destroy I2C mdiobus on transceiver plug/unplug
  net: phy: marvell10g: change MACTYPE if underlying MAC does not
    support it
  net: sfp: add support for multigig RollBall transceivers

 drivers/net/mdio/mdio-i2c.c   | 180 +++++++++++++++++++++++++++++++++-
 drivers/net/phy/marvell10g.c  |  31 ++++++
 drivers/net/phy/phylink.c     |   2 +-
 drivers/net/phy/sfp.c         |  96 ++++++++++++++++--
 include/linux/mdio/mdio-i2c.h |   8 +-
 5 files changed, 300 insertions(+), 17 deletions(-)


base-commit: cd29296fdfca919590e4004a7e4905544f4c4a32
-- 
2.26.2

