Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A90641AD019
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 21:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730848AbgDPTGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 15:06:12 -0400
Received: from mailoutvs60.siol.net ([185.57.226.251]:37007 "EHLO
        mail.siol.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730533AbgDPTGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 15:06:11 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.siol.net (Postfix) with ESMTP id EADF55246A1;
        Thu, 16 Apr 2020 20:58:07 +0200 (CEST)
X-Virus-Scanned: amavisd-new at psrvmta09.zcs-production.pri
Received: from mail.siol.net ([127.0.0.1])
        by localhost (psrvmta09.zcs-production.pri [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id ZxZKBzIH5Qt0; Thu, 16 Apr 2020 20:58:07 +0200 (CEST)
Received: from mail.siol.net (localhost [127.0.0.1])
        by mail.siol.net (Postfix) with ESMTPS id 750055246A0;
        Thu, 16 Apr 2020 20:58:07 +0200 (CEST)
Received: from localhost.localdomain (cpe-194-152-20-232.static.triera.net [194.152.20.232])
        (Authenticated sender: 031275009)
        by mail.siol.net (Postfix) with ESMTPSA id BBE2352465F;
        Thu, 16 Apr 2020 20:58:03 +0200 (CEST)
From:   Jernej Skrabec <jernej.skrabec@siol.net>
To:     robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     mripard@kernel.org, wens@csie.org, lee.jones@linaro.org,
        linux@armlinux.org.uk, davem@davemloft.net,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC PATCH 0/4] net: mfd: AC200 Ethernet PHY
Date:   Thu, 16 Apr 2020 20:57:54 +0200
Message-Id: <20200416185758.1388148-1-jernej.skrabec@siol.net>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is attempt to support Ethernet PHY on AC200 MFD chip. I'm sending
this as RFC because I stumbled on a problem how to properly describe it
in DT. Proper DT documentation will be added later, once DT issue is
solved.

Before Ethernet PHY can be actually used, few things must happen:
1. 24 MHz clock must be enabled and connected to input pin of this
   chip. In this case, PWM is set to generate 24 MHz signal with 50%
   duty cycle.
2. Chip must be put out of reset through I2C
3. Ethernet PHY must be enabled and configured through I2C

All above suggest that AC200 chip must be child node of I2C and Ethernet
PHY child node of AC200 node. This is done in patch 3.

However, mdio bus binding also requires that ethernet PHY is child node
of mdio bus node which can't be, because it's already child node of
AC200 MFD node.

Currently I'm using workaround to have another PHY defined in mdio bus
node as can be seen in patch 4. Then, with careful module loading order,
I make sure that ethernet controller driver is loaded last, after AC200
ethernet PHY driver is loaded. But that's fragile and not acceptable.

Suggestions how to solve that are highly appreciated.

One possible solution is that mdio bus node would contain phandle to
PHY node instead of having actual PHY child node.

Documentation of this chip can be found at
http://linux-sunxi.org/File:AC200_Datasheet_V1.1.pdf

Note that in this case, AC200 IC is copackaged with Allwinner H6 SoC and
all connections between them are internal. So, for example, PWM is the
only way to provide 24 MHz clock to this chip.

Best regards,
Jernej

Jernej Skrabec (4):
  mfd: Add support for AC200
  net: phy: Add support for AC200 EPHY
  arm64: dts: allwinner: h6: Add AC200 EPHY related nodes
  arm64: dts: allwinner: h6: tanix-tx6: Enable ethernet

 .../dts/allwinner/sun50i-h6-tanix-tx6.dts     |  32 +++
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi  |  63 ++++++
 drivers/mfd/Kconfig                           |   9 +
 drivers/mfd/Makefile                          |   1 +
 drivers/mfd/ac200.c                           | 188 ++++++++++++++++
 drivers/net/phy/Kconfig                       |   7 +
 drivers/net/phy/Makefile                      |   1 +
 drivers/net/phy/ac200.c                       | 206 +++++++++++++++++
 include/linux/mfd/ac200.h                     | 210 ++++++++++++++++++
 9 files changed, 717 insertions(+)
 create mode 100644 drivers/mfd/ac200.c
 create mode 100644 drivers/net/phy/ac200.c
 create mode 100644 include/linux/mfd/ac200.h

--=20
2.26.0

