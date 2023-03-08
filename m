Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 394746B0A4A
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 15:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbjCHOBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 09:01:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbjCHOBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 09:01:11 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDAEEFF0D;
        Wed,  8 Mar 2023 05:59:44 -0800 (PST)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 847C51C0003;
        Wed,  8 Mar 2023 13:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1678283983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FTBqfoX84Wuze6pyOMEwaXrXDsP6bvdwqai+tioaAFE=;
        b=Tyhi640kB8cduEHSCqX7++WDer6tvO6G7mt1SfulRraHIqpXXOLkyZeJKeDkSEcmwbMNxp
        YsrGves4sTnPiMqQb9WW69BU2vpCptruZRd6Zw6jpsj4NQmK/4q39XVWkj0pLkP27RG09q
        ZN+9Rr9duzqrnyvmsR0GMqQiAo5G3+Hh2yz9jyPFLT9U1BkiLvu5Rtpl3jTCxhM7ZFO54u
        YRoNHwyQZQ3rI/8bXKfb6S8AhM3Mw486n8uVGV9RDlSEVEE/n/lwKRCEuzPOvBq9nlLRma
        PhJLw9j2Sbkqsrr8FbySLnTzk+vG8fAJMJ2TYSNSZH4wxnIYSOok+bUPGActAQ==
From:   =?UTF-8?q?K=C3=B6ry=20Maincent?= <kory.maincent@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-omap@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Kory Maincent <kory.maincent@bootlin.com>,
        thomas.petazzoni@bootlin.com, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Jie Wang <wangjie125@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Sasha Levin <sashal@kernel.org>,
        Marco Bonelli <marco@mebeim.net>,
        Maxim Korotkov <korotkov.maxim.s@gmail.com>
Subject: [PATCH v3 0/5] net: Make MAC/PHY time stamping selectable
Date:   Wed,  8 Mar 2023 14:59:24 +0100
Message-Id: <20230308135936.761794-1-kory.maincent@bootlin.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kory Maincent <kory.maincent@bootlin.com>

Up until now, there was no way to let the user select the layer at
which time stamping occurs.  The stack assumed that PHY time stamping
is always preferred, but some MAC/PHY combinations were buggy.

This series aims to allow the user to select the desired layer
administratively.

- Patch 1 refactors get_ts_info copy/paste code.

- Patch 2 introduces sysfs files that reflect the current, static
  preference of PHY over MAC.

- Patch 3 makes the layer selectable at run time.

- Patch 4 fixes up MAC drivers that attempt to defer to the PHY layer.
  This patch is broken out for review, but it will eventually be
  squashed into Patch 3 after comments come in.

Changes in v2:
- Move selected_timestamping_layer variable of the concerned patch.
- Use sysfs_streq instead of strmcmp.
- Use the PHY timestamp only if available.

Changes in v3:
- Expose the PTP choice to ethtool instead of sysfs.
  You can test it with the ethtool source on branch feature_ptp of:
  https://github.com/kmaincent/ethtool
- Added a devicetree binding to select the preferred timestamp.

Kory Maincent (2):
  net: Expose available time stamping layers to user space.
  dt-bindings: net: phy: add timestamp preferred choice property

Richard Cochran (3):
  net: ethtool: Refactor identical get_ts_info implementations.
  net: Let the active time stamping layer be selectable.
  net: fix up drivers WRT phy time stamping

 .../devicetree/bindings/net/ethernet-phy.yaml |  7 ++
 Documentation/networking/ethtool-netlink.rst  |  3 +
 drivers/net/bonding/bond_main.c               | 14 +---
 drivers/net/ethernet/freescale/fec_main.c     | 23 +++---
 drivers/net/ethernet/mscc/ocelot_net.c        | 21 +++---
 drivers/net/ethernet/ti/cpsw_priv.c           | 12 ++--
 drivers/net/ethernet/ti/netcp_ethss.c         | 26 ++-----
 drivers/net/macvlan.c                         | 14 +---
 drivers/net/phy/phy_device.c                  | 34 +++++++++
 include/linux/ethtool.h                       |  8 +++
 include/linux/netdevice.h                     |  6 ++
 include/uapi/linux/ethtool.h                  |  3 +
 include/uapi/linux/net_tstamp.h               |  6 ++
 net/8021q/vlan_dev.c                          | 15 +---
 net/core/dev_ioctl.c                          | 43 ++++++++++-
 net/core/timestamping.c                       |  6 ++
 net/ethtool/common.c                          | 22 ++++--
 net/ethtool/ioctl.c                           | 71 +++++++++++++++++++
 18 files changed, 237 insertions(+), 97 deletions(-)

-- 
2.25.1

