Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC1F2412CF
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 00:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgHJWGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 18:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbgHJWGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 18:06:49 -0400
Received: from mail.nic.cz (lists.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73552C06174A
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 15:06:49 -0700 (PDT)
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 79A5C140A11;
        Tue, 11 Aug 2020 00:06:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1597097206; bh=tf2BkipgAegb0Bz0MTZMSQbkd/revEZbs1jACrnaBvs=;
        h=From:To:Date;
        b=VD8qj+OrhNFPJhRLVxkrxyBIM/WEHFhxVBo864tVy1ZNhzjsz10pTpXAMjBiKmMOh
         2mU9tTL4/sOu3tu5ZbCMHuZfNbSPoj8ROVQRrBUbRClOBZOanHeFkksdvC8sFY45Zk
         C0hCMyjH+llSlX6gyt3pdD6C/ABT3njjhGomZZvU=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH RFC russell-king 0/4] Support for RollBall 10G copper SFP modules
Date:   Tue, 11 Aug 2020 00:06:41 +0200
Message-Id: <20200810220645.19326-1-marek.behun@nic.cz>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Spam-Status: No, score=0.00
X-Spamd-Bar: /
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

this series should apply on linux-arm git repository, on branch
clearfog.

Some internet providers are already starting to offer 2.5G copper
connectivity to their users. On Turris Omnia the SFP port is capable
of 2.5G speed, so we tested some copper SFP modules.

This adds support to the SFP subsystem for 10G RollBall copper modules
which contain a Marvell 88X3310 PHY. By default these modules are
configured in 10GKR only mode on the host interface, and also contain
some bad information in EEPROM (the extended_cc byte).

The PHY in these modules is also accessed via a different I2C protocol
than the standard one.

Patch 1 adds support for this different I2C MDIO bus.
Patch 2 adds support for these modules into the SFP driver.
Patch 3 adds support for chaning MACTYPE in marvell10g PHY driver so
that the PHY will connect to the host interface on Turris Omnia even
though it only supports SGMII/1000base-x/2500base-x modes.
Patch 4 changes phylink code so that a PHY can be attached even though
802.3z mode is requested.

Marek

Marek Behún (4):
  net: phy: add I2C mdio bus for RollBall compatible SFPs
  net: phy: sfp: add support for multigig RollBall modules
  net: phy: marvell10g: change MACTYPE according to phydev->interface
  net: phylink: don't fail attaching phy on 1000base-x/2500base-x mode

 drivers/net/phy/Makefile            |   2 +-
 drivers/net/phy/marvell10g.c        |  32 +++-
 drivers/net/phy/mdio-i2c-rollball.c | 238 ++++++++++++++++++++++++++++
 drivers/net/phy/mdio-i2c.h          |   1 +
 drivers/net/phy/phylink.c           |   4 +-
 drivers/net/phy/sfp.c               |  62 ++++++--
 include/linux/sfp.h                 |   5 +
 7 files changed, 322 insertions(+), 22 deletions(-)
 create mode 100644 drivers/net/phy/mdio-i2c-rollball.c

-- 
2.26.2

