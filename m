Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEF2A527267
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 17:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbiENPHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 11:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiENPHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 11:07:05 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADD2BE23;
        Sat, 14 May 2022 08:07:03 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id CFE90C0006;
        Sat, 14 May 2022 15:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652540821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=QmF0ttkdEbbZTVa3vz08turW96svvMVbroFkxXDDwK4=;
        b=QfKEvRGqvZZOr3RWNave0cM7j3PDClxpummHGwj90TH0gDuTWygzEX1LDdSfhj7T2Xo/3E
        n1AgWVRnGdGADSklWGQGC/ODZNBqWplmRguprOw1TNekV6HgvHTFh+yOGzk7vGw3xP+XDR
        MTrvn3n5uV2DAaY3tkmb3MBzMHuGSqJ+Q9oaMlEleAVJE5AleoErIcueRtTzYMOVZA2OOh
        oGjpnL68Z8J1fWnFS7kZyTcx6D4xhtEBl/O8GhGv/fvwQJbTT5GcdP3r3o6hGScjHdRlfK
        kqDOs7xz/ZJr600EEIhxBkcn1S78CFfeMt6D/jmCyXnGVpacRwu5Laf+7t3bHw==
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
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH net-next v2 0/5] net: ipqess: introduce Qualcomm IPQESS driver
Date:   Sat, 14 May 2022 17:06:51 +0200
Message-Id: <20220514150656.122108-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
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

Hello everyone,

This is the 2nd iteration of a series that introduces a new driver, for
the Qualcomm IPQESS Ethernet Controller, found on the IPQ4019.

Notables changes on V2 :
 - Put the DSA tag in the skb itself instead of using skb->shinfo
 - Fixed the initialisation sequence based on Andrew's comments
 - Reworked the error paths in the init sequence
 - Add support for the clock and reset lines on that controller
 - Fixed and updated the binding

The driver itself is pretty straightforward, but has lived out-of-tree
for a while. I've done my best to clean-up some outdated API calls, but
some might remain.

This controller is somewhat special, since it's part of the IPQ4019 SoC
which also includes an QCA8K switch, and uses the IPQESS controller for
the CPU port. The switch is so tightly intergrated with the MAC that it
is connected to the MAC using an internal link (hence the fact that we
only support PHY_INTERFACE_MODE_INTERNAL), and this has some
consequences on the DSA side.

The tagging for the switch isn't done inband as most switch do, but
out-of-band, the DSA tag being included in the DMA descriptor.

This series includes a new out-of-band tagger that uses the skb headroom
to convey the tag between the tagger and the MAC driver.

Thanks to the Sartura folks who worked on a base version of this driver,
and provided test hardware.

Best regards,

Maxime Chevallier

Maxime Chevallier (5):
  net: ipqess: introduce the Qualcomm IPQESS driver
  net: dsa: add out-of-band tagging protocol
  net: ipqess: Add out-of-band DSA tagging support
  net: dt-bindings: Introduce the Qualcomm IPQESS Ethernet controller
  ARM: dts: qcom: ipq4019: Add description for the IPQESS Ethernet
    controller

 .../devicetree/bindings/net/qcom,ipqess.yaml  |  104 ++
 MAINTAINERS                                   |    6 +
 arch/arm/boot/dts/qcom-ipq4019.dtsi           |   46 +
 drivers/net/ethernet/qualcomm/Kconfig         |   12 +
 drivers/net/ethernet/qualcomm/Makefile        |    2 +
 drivers/net/ethernet/qualcomm/ipqess/Makefile |    8 +
 drivers/net/ethernet/qualcomm/ipqess/ipqess.c | 1296 +++++++++++++++++
 drivers/net/ethernet/qualcomm/ipqess/ipqess.h |  518 +++++++
 .../ethernet/qualcomm/ipqess/ipqess_ethtool.c |  168 +++
 include/linux/dsa/oob.h                       |   17 +
 include/net/dsa.h                             |    2 +
 net/dsa/Kconfig                               |    7 +
 net/dsa/Makefile                              |    1 +
 net/dsa/tag_oob.c                             |   84 ++
 14 files changed, 2271 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/qcom,ipqess.yaml
 create mode 100644 drivers/net/ethernet/qualcomm/ipqess/Makefile
 create mode 100644 drivers/net/ethernet/qualcomm/ipqess/ipqess.c
 create mode 100644 drivers/net/ethernet/qualcomm/ipqess/ipqess.h
 create mode 100644 drivers/net/ethernet/qualcomm/ipqess/ipqess_ethtool.c
 create mode 100644 include/linux/dsa/oob.h
 create mode 100644 net/dsa/tag_oob.c

-- 
2.36.1

