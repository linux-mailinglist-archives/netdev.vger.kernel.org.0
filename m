Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D922D5F0D68
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbiI3OV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231950AbiI3OV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:21:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D5B1A3AC7
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 07:21:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 763A26233F
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 14:21:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66EBFC433D6;
        Fri, 30 Sep 2022 14:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664547674;
        bh=SuKTETuz8WXsX3BeLrSrrtAcbZYiXxxskWZ4YH1+5Is=;
        h=From:To:Cc:Subject:Date:From;
        b=IIvlB/RsjP1u8boqRcKo+WKhh7LpxsKwidpJafMR4BLFbwMA4in1cfNCGbRcsKJd4
         HikQpSO2dgEKODD+MVCLzoZwFnc9gUorsmaCsirgGkYNKnVTyapAkBrWpRouvKe34n
         P9GITcmNXfBgEYaarsrB02QLbcSCLKrJBkvf9KCgOMp+vZ/qFTi9h1SbV3CGg4vI1i
         qqXOAd4AOOYCldOyhOpES5SEJoUFr57U6OoMFiupU+BZ9H08elUQO3l9RzqzymBHcp
         crH3VMGuYGQ5J9mDR4o43RPF5PHM58UUkOOnLf6Ibcn8VHqAiBUweCkovsCVa7iOHu
         l06IKCXDV7caQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 00/12] RollBall / Hilink / Turris 10G copper SFP support
Date:   Fri, 30 Sep 2022 16:20:58 +0200
Message-Id: <20220930142110.15372-1-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I am resurrecting my attempt to add support for RollBall / Hilink /
Turris 10G copper SFPs modules.

The modules contain Marvell 88X3310 PHY, which can communicate with
the system via sgmii, 2500base-x, 5gbase-r, 10gbase-r or usxgmii mode.

Some of the patches I've taken from Russell King's net-queue [1]
(with some rebasing).

The important change from my previous attempts are:
- I am including the changes needed to phylink and marvell10g driver,
  so that the 88X3310 PHY is configured to use PHY modes supported by
  the host (the PHY defaults to use 10gbase-r only on host's side)
- I have changed the patch that informs phylib about the interfaces
  supported by the host (patch 5 of this series): it now fills in the
  phydev->host_interfaces member only when connecting a PHY that is
  inside a SFP module. This may change in the future.

Marek

[1] http://git.armlinux.org.uk/cgit/linux-arm.git/?h=net-queue

Marek Behún (7):
  net: phylink: pass supported host PHY interface modes to phylib for
    SFP's PHYs
  net: phy: marvell10g: Use tabs instead of spaces for indentation
  net: phylink: allow attaching phy for SFP modules on 802.3z mode
  net: sfp: Add and use macros for SFP quirks definitions
  net: sfp: create/destroy I2C mdiobus before PHY probe/after PHY
    release
  net: phy: mdio-i2c: support I2C MDIO protocol for RollBall SFP modules
  net: sfp: add support for multigig RollBall transceivers

Russell King (3):
  net: sfp: augment SFP parsing with phy_interface_t bitmap
  net: phylink: use phy_interface_t bitmaps for optical modules
  net: phy: marvell10g: select host interface configuration

Russell King (Oracle) (2):
  net: phylink: add ability to validate a set of interface modes
  net: phylink: rename phylink_sfp_config()

 drivers/net/mdio/mdio-i2c.c       | 310 +++++++++++++++++++++++++++++-
 drivers/net/phy/at803x.c          |   3 +-
 drivers/net/phy/marvell-88x2222.c |   3 +-
 drivers/net/phy/marvell.c         |   3 +-
 drivers/net/phy/marvell10g.c      | 133 ++++++++++++-
 drivers/net/phy/phylink.c         | 210 +++++++++++++++-----
 drivers/net/phy/sfp-bus.c         |  75 ++++++--
 drivers/net/phy/sfp.c             | 179 +++++++++++------
 drivers/net/phy/sfp.h             |   3 +-
 include/linux/mdio/mdio-i2c.h     |  10 +-
 include/linux/phy.h               |   4 +
 include/linux/sfp.h               |   5 +-
 12 files changed, 797 insertions(+), 141 deletions(-)

-- 
2.35.1

