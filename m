Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D23552D558
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 15:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239191AbiESN5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 09:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237072AbiESN5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 09:57:08 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B0838AB;
        Thu, 19 May 2022 06:56:58 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 63F63240014;
        Thu, 19 May 2022 13:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652968613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=UIKY8sH1X5ECVbyISXl1wSkKulCZceNUKGMFNeLBB58=;
        b=dH4zG/rLfn5lYbDoNTUtI2jjvNpKLyNMlTWaHhX8zJXuzpS057KPCaTrElRlKJqiztw1SL
        6cDNU52AmZBbS64wCDX99mR2mee3NMLZsxFm0pTSyhrUPDM1zR69Cx4gbDX6UFV4ANUdht
        bLkjlOEuRSSXheDO5Nie6fMJwdzagP4oDIAj0ccaT9vmSCsyT425Nk87Yjgob5MxAhEHK7
        459gkEsdaifm2rqribGwOUl+WFphaRd87RhixGgEnBxFGQ6mkjcYxJ9t0vyL3XOT3sPy62
        lcNEGBRZL5Acis5qxAzkxQdIPyHvI0nmQZDQHfc0QuQ9LsrcP5b2vTONY2ISZQ==
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
Subject: [PATCH net-next 0/6] net: Introduce Ethernet Inband Extensions
Date:   Thu, 19 May 2022 15:56:41 +0200
Message-Id: <20220519135647.465653-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello everyone,

This series introduces support for Ethernet in-band extensions, a
mechanism proposed by Cisco as part of the USXGMII spec.

The idea is to leverage the 7 bytes preamble to convey meaningful data,
in what's called an "extension".

This series adds the QUSGMII mode, which is a quad variant of the
USXGMII standard, and adds its support in the lan966x driver. In
QUSGMII, extensions can be used.

The only extension support thus far is the PCH mode, a way to convey
part of a timestamp into the ethernet preamble. That's a pretty
straightfoward extension, documented in the Cisco spec. Other extensions
can exist, each being identified by a 2 bits code in the preamble,
parsed by the hardware.

We therefore need an API to synchronise which mode is supported by a
given PHY, then a way to enable it in the PHY, from the MAC's control.

This is done through a new phy_driver callback, .inband_ext_config(),
that the MAC driver will call to ask a PHY driver to enable a given
extension.

The PCH mode that is added in this series is used to offload a bit
the MDIO bus when doing PHY-side timestamping, by conveying the nanoseconds
part of the timestamp into the preamble. The MAC driver then extracts
the timestamp (using lan966x's IFH mechanism), puts the nanosecond part
in the SKB. The RX deferred timestamping then asks the PHY for the rest
of the timestamp.

Other modes exists, such as Microchip's MCH mode, but this series only
include PCH since it's simple enough and keeps the code reviewable.

Thanks,

Maxime

Maxime Chevallier (6):
  net: phy: Introduce QUSGMII PHY mode
  dt-bindings: net: ethernet-controller: add QUSGMII mode
  net: lan966x: Add QUSGMII support for lan966x
  net: phy: Add support for inband extensions
  net: lan966x: Allow using PCH extension for PTP
  net: phy: micrel: Add QUSGMII support and PCH extension

 .../bindings/net/ethernet-controller.yaml     |   1 +
 Documentation/networking/phy.rst              |   9 ++
 .../ethernet/microchip/lan966x/lan966x_main.c |  14 +--
 .../ethernet/microchip/lan966x/lan966x_main.h |   6 ++
 .../microchip/lan966x/lan966x_phylink.c       |   9 +-
 .../ethernet/microchip/lan966x/lan966x_port.c |  33 ++++--
 .../ethernet/microchip/lan966x/lan966x_ptp.c  |  93 +++++++++++++++-
 .../ethernet/microchip/lan966x/lan966x_regs.h |  72 +++++++++++++
 drivers/net/phy/micrel.c                      | 102 ++++++++++++++++--
 drivers/net/phy/phy.c                         |  68 ++++++++++++
 drivers/net/phy/phylink.c                     |   3 +
 include/linux/phy.h                           |  28 ++++-
 12 files changed, 413 insertions(+), 25 deletions(-)

-- 
2.36.1

