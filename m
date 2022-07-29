Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8E415852B6
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 17:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237607AbiG2PeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 11:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232488AbiG2PeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 11:34:06 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [217.70.178.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B096FA0C;
        Fri, 29 Jul 2022 08:34:04 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id AF00A240003;
        Fri, 29 Jul 2022 15:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1659108843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=W8HzVP3f12jtZr7ZSlHrA7jmUrW5KGei/Y00G5BNdF8=;
        b=XJNp0Bp7SVJ5kKDdoYriSdiGFucOCO3WcPhxRjgoKwueodrAXjaQdmiYUIyrHWVTA2doRw
        SMxVb5m1+8euBAqcJZ2ixXoHSunv6cmESz0UdjsMDJ+vMDA8NgB9OmrYodmpEfDO0ZXfFX
        hh/xaSgKo+iJt9SCwtrO1rLQMZXrxo8k3iZZeXZQY13TSjfwb6bLsu8+dX136wtAs9flFB
        AkiL/ta7MtTj7uzHJ7kPCPU+hKHzq0ze0NEheEvhczkzafiHXc8hmFI15HSDq21wQ7FUAd
        PCw6hng81Ffl28F4VFaWLUtesFgkEYqyFqJOALZsJYj1sMT7WcEAQJL3Clrg9Q==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Richard Cochran <richardcochran@gmail.com>,
        Horatiu.Vultur@microchip.com, Allan.Nielsen@microchip.com,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next v3 0/4] net: Introduce QUSGMII phy mode
Date:   Fri, 29 Jul 2022 17:33:52 +0200
Message-Id: <20220729153356.581444-1-maxime.chevallier@bootlin.com>
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

This is the V3 of a previous series [1] initially aimed at introducing
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

V3 includes small fixups on the ports-per-interface assignment and some
missing documentation, thanks Andrew and Florian for the review !

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
 include/linux/phy.h                           |  6 +++
 9 files changed, 97 insertions(+), 7 deletions(-)

-- 
2.37.1

