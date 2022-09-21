Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB8075BFE43
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 14:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbiIUMsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 08:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiIUMsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 08:48:14 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E7593235
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 05:48:13 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oaz8r-0001uO-Bg; Wed, 21 Sep 2022 14:47:53 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oaz8p-0023oB-Qi; Wed, 21 Sep 2022 14:47:50 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oaz8m-000J8P-SA; Wed, 21 Sep 2022 14:47:48 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH net-next v6 0/7] add generic PSE support 
Date:   Wed, 21 Sep 2022 14:47:40 +0200
Message-Id: <20220921124748.73495-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add generic support for the Ethernet Power Sourcing Equipment.

changes are listed within patches.

Oleksij Rempel (7):
  dt-bindings: net: phy: add PoDL PSE property
  net: add framework to support Ethernet PSE and PDs devices
  net: mdiobus: fwnode_mdiobus_register_phy() rework error handling
  net: mdiobus: search for PSE nodes by parsing PHY nodes.
  ethtool: add interface to interact with Ethernet Power Equipment
  dt-bindings: net: pse-dt: add bindings for regulator based PoDL PSE
    controller
  net: pse-pd: add regulator based PSE driver

 .../devicetree/bindings/net/ethernet-phy.yaml |   6 +
 .../net/pse-pd/podl-pse-regulator.yaml        |  40 ++
 .../bindings/net/pse-pd/pse-controller.yaml   |  33 ++
 Documentation/networking/ethtool-netlink.rst  |  59 +++
 drivers/net/Kconfig                           |   2 +
 drivers/net/Makefile                          |   1 +
 drivers/net/mdio/fwnode_mdio.c                |  55 ++-
 drivers/net/phy/phy_device.c                  |   2 +
 drivers/net/pse-pd/Kconfig                    |  22 ++
 drivers/net/pse-pd/Makefile                   |   6 +
 drivers/net/pse-pd/pse_core.c                 | 351 ++++++++++++++++++
 drivers/net/pse-pd/pse_regulator.c            | 147 ++++++++
 include/linux/phy.h                           |   2 +
 include/linux/pse-pd/pse.h                    | 156 ++++++++
 include/uapi/linux/ethtool.h                  |  45 +++
 include/uapi/linux/ethtool_netlink.h          |  16 +
 net/ethtool/Makefile                          |   3 +-
 net/ethtool/common.h                          |   1 +
 net/ethtool/netlink.c                         |  17 +
 net/ethtool/netlink.h                         |   4 +
 net/ethtool/pse-pd.c                          | 185 +++++++++
 21 files changed, 1141 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/pse-pd/podl-pse-regulator.yaml
 create mode 100644 Documentation/devicetree/bindings/net/pse-pd/pse-controller.yaml
 create mode 100644 drivers/net/pse-pd/Kconfig
 create mode 100644 drivers/net/pse-pd/Makefile
 create mode 100644 drivers/net/pse-pd/pse_core.c
 create mode 100644 drivers/net/pse-pd/pse_regulator.c
 create mode 100644 include/linux/pse-pd/pse.h
 create mode 100644 net/ethtool/pse-pd.c

-- 
2.30.2

