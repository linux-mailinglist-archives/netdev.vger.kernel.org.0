Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A45958423F
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 16:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbiG1OxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 10:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbiG1OxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 10:53:04 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F956050B;
        Thu, 28 Jul 2022 07:53:02 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 94FB260009;
        Thu, 28 Jul 2022 14:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1659019978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=w9gjrFfJNDyi+UVEtu1C2UBFOyncoWXQkKZtz3CZtE8=;
        b=o3sxx7HQE6bPRAFefUy9+Yi6mBcI36Wp00NT/2+0A9NLCgpsN7gC899XWtjYi3SvDulVPY
        q9AsRK/lyCobDOktBquxGBLOs6MpT9VIgp1hQ2N/nWfBDtuKNzy2Wliv12CICDJ0qZFf74
        AijxQ54dJhWAAIjRBgpfYEy+sOaM9GzHno52Tew4dRPd3cziBCEGQdxtfB0JClCqI83Qxq
        jipUJPKweHtp7ZD2iLUmUrKHk+gs+R0/V80xSzkkaPBELItM8IJbAeK2oLJX+IhCYzCkZ1
        OhPIE+NNa+DSn1cPEDXhEUUxPmfS4H+Nmnw30jiN/CRSDUrB0r/WA9sAntg2Fw==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Horatiu.Vultur@microchip.com,
        Allan.Nielsen@microchip.com, UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 0/4] net: Introduce QUSGMII phy mode
Date:   Thu, 28 Jul 2022 16:52:48 +0200
Message-Id: <20220728145252.439201-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello everyone,

This is the V2 of a previous series [1] initially aimed at introducing
inband extensions, with modes like QUSGMII. This mode allows passing
info in the ethernet preamble between the MAC and the PHY, such s
timestamps.

This series has now become a preliminary series, that simply introduces
the new interface mode, without support for inband extensions, that will
come later.

The reasonning is that work will need to be done in the networking
subsystem, but also in the generic phy driver subsystem to allow serdes
configuration for qusgmii.

This series add the mode, the relevant binding changes, adds support for
it in the lan966x driver, and also introduces a small helper to get the
number of links a given phy mode can carry (think 1 for SGMII and 4 for
QSGMII). This allows for better readability and will prove useful
when (if) we support PSGMII (5 links on 1 interface) and OUSGMII (8
links on one interface).

Best regards,

Maxime

[1] : https://lore.kernel.org/netdev/20220519135647.465653-1-maxime.chevallier@bootlin.com/

Maxime Chevallier (4):
  net: phy: Introduce QUSGMII PHY mode
  dt-bindings: net: ethernet-controller: add QUSGMII mode
  net: phy: Add helper to derive the number of ports from a phy mode
  net: lan966x: Add QUSGMII support for lan966x

 .../bindings/net/ethernet-controller.yaml     |  1 +
 Documentation/networking/phy.rst              |  9 ++++
 .../ethernet/microchip/lan966x/lan966x_main.c |  2 +
 .../microchip/lan966x/lan966x_phylink.c       |  3 +-
 .../ethernet/microchip/lan966x/lan966x_port.c | 22 +++++---
 .../ethernet/microchip/lan966x/lan966x_regs.h |  6 +++
 drivers/net/phy/phy-core.c                    | 52 +++++++++++++++++++
 drivers/net/phy/phylink.c                     |  3 ++
 include/linux/phy.h                           |  5 ++
 9 files changed, 96 insertions(+), 7 deletions(-)

-- 
2.37.1

