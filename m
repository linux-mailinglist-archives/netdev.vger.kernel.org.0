Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 834E1519BBB
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 11:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347329AbiEDJfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 05:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245754AbiEDJfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 05:35:06 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D3A20BF1;
        Wed,  4 May 2022 02:31:29 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 3790E40006;
        Wed,  4 May 2022 09:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1651656688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=YfS2uF+ICNTRe6Flzquf4GuU6MKFWg01yDIcRiXDy6Q=;
        b=ROk52wt1rQfp/9HtttBUNEzkHjGM0nEkyzLYwPCKWxLRv5voIEitSXl5lkr5JXoi9gE8hX
        p6uYYKlLZY37N2QHWvOw3tEbukqrNEJ2biOAbdJZrZJsLyaDBwNgdcFbqNk+wEAy86NuHC
        45H7mSjCM/asUzikyuZtM0Dw/DCQE33ffSLiVJvQXGYg4zYi4+9B8gzhBpLi6BSmqHfxyj
        jlGu70Sg8pejl1rV7ce2jRUHeKttL9MMGNIqw3z2FC440dEEF7UE916TOv1NymfowthCrq
        /M/2x3iUi5K04TyAHBXkJ+quOnXGpmleq6/m2EdlvjGoq9YQy4EJZ11f2BjD8A==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
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
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v3 00/12] add support for Renesas RZ/N1 ethernet subsystem devices
Date:   Wed,  4 May 2022 11:29:48 +0200
Message-Id: <20220504093000.132579-1-clement.leger@bootlin.com>
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

This series needs commits bcfb459b25b8 and 542d5835e4f6 which are on
the renesas-devel tree in order to enable generic power domain on
RZ/N1.

Link: [1] https://www.renesas.com/us/en/document/mah/rzn1d-group-rzn1s-group-rzn1l-group-users-manual-r-engine-and-ethernet-peripherals

-----
Changes in V3:
- PCS:
  - Fixed reverse christmas tree declaration
  - Remove spurious pr_err
  - Use pm_runtime functions
- Tag driver:
  - Remove packed attribute from the tag struct
  - Fix comment about packet size
- Switch:
  - Fix missing spin_unlock in fdb_dump in case of error
  - Add static qualifier to dsa_switch_ops
  - Add missing documentation for hclk and clk members of struct a5psw
  - Changed types of fdb_entry to u16 to discard GCC note on char
    packed bitfields and add reserved field
- Added Reviewed-by tag from Florian Fainelli

Changes in V2:
- PCS:
  - Fix Reverse Christmas tree declaration
  - Removed stray newline
  - Add PCS remove function and disable clocks in them
  - Fix miic_validate function to return correct values
  - Split PCS CONV_MODE definition
  - Reordered phylink_pcs_ops in definition order
  - Remove interface setting in miic_link_up
  - Remove useless checks for invalid interface/speed and error prints
  - Replace phylink_pcs_to_miic_port macro by a static function
  - Add comment in miic_probe about platform_set_drvdata
- Bindings:
 - Fix wrong path for mdio.yaml $ref
 - Fix yamllint errors
- Tag driver:
  - Squashed commit that added tag value with tag driver
  - Add BUILD_BUG_ON for tag size
  - Split control_data2 in 2 16bits values
- Switch:
  - Use .phylink_get_caps instead of .phylink_validate and fill
    supported_interface correctly
  - Use fixed size (ETH_GSTRING_LEN) string for stats and use memcpy
  - Remove stats access locking since RTNL lock is used in upper layers
  - Check for non C45 addresses in mdio_read/write and return
    -EOPNOTSUPP
  - Add get_eth_mac_stats, get_eth_mac_ctrl_stat, get_rmon_stats
  - Fix a few indentation problems
  - Remove reset callback from MDIO bus operation
  - Add phy/mac/rmon stats
- Add get_rmon_stat to dsa_ops

Clément Léger (12):
  net: dsa: add support for ethtool get_rmon_stats()
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

 .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  |  132 ++
 .../bindings/net/pcs/renesas,rzn1-miic.yaml   |  162 +++
 MAINTAINERS                                   |   11 +
 arch/arm/boot/dts/r9a06g032.dtsi              |   64 +
 drivers/net/dsa/Kconfig                       |    9 +
 drivers/net/dsa/Makefile                      |    1 +
 drivers/net/dsa/rzn1_a5psw.c                  | 1057 +++++++++++++++++
 drivers/net/dsa/rzn1_a5psw.h                  |  260 ++++
 drivers/net/pcs/Kconfig                       |    8 +
 drivers/net/pcs/Makefile                      |    1 +
 drivers/net/pcs/pcs-rzn1-miic.c               |  502 ++++++++
 include/dt-bindings/net/pcs-rzn1-miic.h       |   33 +
 include/linux/pcs-rzn1-miic.h                 |   18 +
 include/net/dsa.h                             |    5 +
 net/dsa/Kconfig                               |    7 +
 net/dsa/Makefile                              |    1 +
 net/dsa/slave.c                               |   13 +
 net/dsa/tag_rzn1_a5psw.c                      |  114 ++
 18 files changed, 2398 insertions(+)
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

