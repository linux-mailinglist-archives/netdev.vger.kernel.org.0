Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13334500D44
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 14:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243205AbiDNM1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 08:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243183AbiDNM1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 08:27:08 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F413A2B253;
        Thu, 14 Apr 2022 05:24:41 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 633314000B;
        Thu, 14 Apr 2022 12:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1649939080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=7k9dMmdJiLhZNju+anqVUQR32MWAhgfsVNste3l027c=;
        b=BjqvxE/y28Wr6BqT9pd92vY991wLbZtgrA7PATKWjhEJoUg0JwxbZW/sQtwU8dkadR4iD9
        WDyOrLBHrcONjIsn+Pijy9yct4PCsCQpUeCXDBF6kHkyRk6qAP23Z4r6RnYfp2u8utmHZJ
        hEYxPVgqJ0PFsZgavX0388irzhUdLtzP3b2qLbAi1rVgPuBmttr6e0DHcfk+ZVOj/RLnmO
        LgnVO7qhT9KN3guLXrfDBHXJaFwPxI7K92BVMdt6Pj3QR0q2LGnrbP4VAKQF2YJEzewR6u
        cgsjEE4Ogq/6J6GtnE1ZuqhbEqZy/cl//xxCE2ofgJJWsU3axQ4fSDgDew2Z1g==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 00/12] add support for Renesas RZ/N1 ethernet subsystem devices
Date:   Thu, 14 Apr 2022 14:22:38 +0200
Message-Id: <20220414122250.158113-1-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Renesas RZ/N1 SoCs features an ethernet subsystem which contains
(most notably) a switch, two GMACs, and a MII converter [1]. This
series adds support for the switch and the MII converter.

The MII converter present on this SoC has been represented as a PCS
which sit between the MACs and the PHY. This PCS driver is probed from
the device-tree since it requires to be configured. Indeed the MII
converter also contains the registers that are handling the muxing of
ports (Switch, MAC, HSR, RTOS, etc) internally to the SoC.

The switch driver is based on DSA and exposes 4 ports + 1 CPU
management port. It include basic bridging support as well as FDB and
statistics support.

Link: [1] https://www.renesas.com/us/en/document/mah/rzn1d-group-rzn1s-group-rzn1l-group-users-manual-r-engine-and-ethernet-peripherals

Clément Léger (12):
  net: dsa: add support for Renesas RZ/N1 A5PSW switch tag code
  net: dsa: add Renesas RZ/N1 switch tag driver
  dt-bindings: net: pcs: add bindings for Renesas RZ/N1 MII converter
  net: pcs: add Renesas MII converter driver
  dt-bindings: net: dsa: add bindings for Renesas RZ/N1 Advanced 5 port
    switch
  net: dsa: rzn1-a5psw: add Renesas RZ/N1 advanced 5 port switch driver
  net: dsa: rzn1-a5psw: add statistics support
  net: dsa: rzn1-a5psw: add FDB support
  ARM: dts: r9a06g032: describe MII converter
  ARM: dts: r9a06g032: describe GMAC2
  ARM: dts: r9a06g032: describe switch
  MAINTAINERS: add Renesas RZ/N1 switch related driver entry

 .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  | 128 +++
 .../bindings/net/pcs/renesas,rzn1-miic.yaml   |  95 ++
 MAINTAINERS                                   |  11 +
 arch/arm/boot/dts/r9a06g032.dtsi              |  61 ++
 drivers/net/dsa/Kconfig                       |   9 +
 drivers/net/dsa/Makefile                      |   2 +
 drivers/net/dsa/rzn1_a5psw.c                  | 940 ++++++++++++++++++
 drivers/net/dsa/rzn1_a5psw.h                  | 214 ++++
 drivers/net/pcs/Kconfig                       |   7 +
 drivers/net/pcs/Makefile                      |   1 +
 drivers/net/pcs/pcs-rzn1-miic.c               | 350 +++++++
 include/dt-bindings/net/pcs-rzn1-miic.h       |  19 +
 include/linux/pcs-rzn1-miic.h                 |  18 +
 include/net/dsa.h                             |   2 +
 net/dsa/Kconfig                               |   8 +
 net/dsa/Makefile                              |   1 +
 net/dsa/tag_rzn1_a5psw.c                      | 112 +++
 17 files changed, 1978 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
 create mode 100644 Documentation/devicetree/bindings/net/pcs/renesas,rzn1-miic.yaml
 create mode 100644 drivers/net/dsa/rzn1_a5psw.c
 create mode 100644 drivers/net/dsa/rzn1_a5psw.h
 create mode 100644 drivers/net/pcs/pcs-rzn1-miic.c
 create mode 100644 include/dt-bindings/net/pcs-rzn1-miic.h
 create mode 100644 include/linux/pcs-rzn1-miic.h
 create mode 100644 net/dsa/tag_rzn1_a5psw.c

-- 
2.34.1

