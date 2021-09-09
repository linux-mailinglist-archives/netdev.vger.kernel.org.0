Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415DE40474A
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 10:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbhIIIvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 04:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbhIIIvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 04:51:05 -0400
Received: from albert.telenet-ops.be (albert.telenet-ops.be [IPv6:2a02:1800:110:4::f00:1a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55490C061757
        for <netdev@vger.kernel.org>; Thu,  9 Sep 2021 01:49:56 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:7d44:646d:3ffb:9bbf])
        by albert.telenet-ops.be with bizsmtp
        id rkpq2501H3eH4vN06kpqre; Thu, 09 Sep 2021 10:49:54 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mOFkk-003Cqm-9d; Thu, 09 Sep 2021 10:49:50 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mOFkj-00Aj4l-2S; Thu, 09 Sep 2021 10:49:49 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Magnus Damm <magnus.damm@gmail.com>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Adam Ford <aford173@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 0/9] renesas: Add compatible properties to Ethernet PHY nodes
Date:   Thu,  9 Sep 2021 10:49:36 +0200
Message-Id: <cover.1631174218.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	Hi all,

If an Ethernet PHY reset is asserted when the Ethernet driver is
initialized, the PHY cannot be probed:

    mdio_bus ee700000.ethernet-ffffffff: MDIO device at address 1 is missing

This happens because the Linux PHY subsystem tries to read the PHY
Identifier registers before handling PHY reset.  Hence if the PHY reset
was asserted before, identification fails.

An easy way to reproduce this issue is by using kexec to launch a new
kernel (the PHY reset will be asserted before starting the new kernel),
or by unbinding and rebinding the Ethernet driver (the PHY reset will be
asserted during unbind), e.g. on koelsch:

    echo ee700000.ethernet > /sys/bus/platform/drivers/sh-eth/unbind
    $ echo ee700000.ethernet > /sys/bus/platform/drivers/sh-eth/bind

The recommended approach[1][2] seems to be working around this issue by
adding compatible values to all ethernet-phy nodes, so Linux can
identify the PHY at any time, without reading the PHY ID from the
device, and regardless of the state of the PHY reset line.

Hence this patch series adds such compatible values to all Ethernet PHY
subnodes representing PHYs on all boards with Renesas ARM and ARM64
SoCs.  For easier review, I have split the series in one patch per PHY
model.

On most boards, I could verify the actual PHY ID at runtime[3], on other
boards I had to resort to schematics.

Kexec and Ethernet driver rebind have been tested on Koelsch and
Salvator-XS.

I plan to queue these in renesas-devel for v5.16.

Thanks for your comments!

[1] "Re: [PATCH] RFC: net: phy: of phys probe/reset issue"
    https://lore.kernel.org/r/ade12434-adf2-6ea7-24ce-ce45ad2e1b5e@gmail.com/
[2] "PHY reset may still be asserted during MDIO probe"
    https://lore.kernel.org/r/CAMuHMdXno2OUHqsAfO0z43JmGkFehD+FJ2dEjEsr_P53oAAPxA@mail.gmail.com
[3] The easiest way to obtain the PHY ID is by adding a debug print to
    drivers/net/phy/phy_device.c:get_phy_c22_id(), _before_ applying
    this patch.

Geert Uytterhoeven (9):
  ARM: dts: renesas: Add compatible properties to KSZ8041 Ethernet PHYs
  ARM: dts: renesas: Add compatible properties to KSZ8081 Ethernet PHYs
  ARM: dts: renesas: Add compatible properties to KSZ9031 Ethernet PHYs
  iARM: dts: renesas: Add compatible properties to LAN8710A Ethernet
    PHYs
  ARM: dts: renesas: Add compatible properties to RTL8201FL Ethernet
    PHYs
  ARM: dts: renesas: Add compatible properties to uPD6061x Ethernet PHYs
  arm64: dts: renesas: Add compatible properties to AR8031 Ethernet PHYs
  arm64: dts: renesas: Add compatible properties to KSZ9031 Ethernet
    PHYs
  arm64: dts: renesas: Add compatible properties to RTL8211E Ethernet
    PHYs

 arch/arm/boot/dts/iwg20d-q7-common.dtsi             | 2 ++
 arch/arm/boot/dts/r7s72100-genmai.dts               | 2 ++
 arch/arm/boot/dts/r7s72100-gr-peach.dts             | 2 ++
 arch/arm/boot/dts/r7s72100-rskrza1.dts              | 2 ++
 arch/arm/boot/dts/r7s9210-rza2mevb.dts              | 2 ++
 arch/arm/boot/dts/r8a7740-armadillo800eva.dts       | 2 ++
 arch/arm/boot/dts/r8a7742-iwg21d-q7-dbcm-ca.dts     | 2 ++
 arch/arm/boot/dts/r8a7742-iwg21d-q7.dts             | 2 ++
 arch/arm/boot/dts/r8a7743-sk-rzg1m.dts              | 2 ++
 arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts         | 2 ++
 arch/arm/boot/dts/r8a7745-sk-rzg1e.dts              | 2 ++
 arch/arm/boot/dts/r8a77470-iwg23s-sbc.dts           | 2 ++
 arch/arm/boot/dts/r8a7790-lager.dts                 | 2 ++
 arch/arm/boot/dts/r8a7790-stout.dts                 | 2 ++
 arch/arm/boot/dts/r8a7791-koelsch.dts               | 2 ++
 arch/arm/boot/dts/r8a7791-porter.dts                | 2 ++
 arch/arm/boot/dts/r8a7793-gose.dts                  | 2 ++
 arch/arm/boot/dts/r8a7794-alt.dts                   | 2 ++
 arch/arm/boot/dts/r8a7794-silk.dts                  | 2 ++
 arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi | 2 ++
 arch/arm64/boot/dts/renesas/cat875.dtsi             | 2 ++
 arch/arm64/boot/dts/renesas/draak.dtsi              | 2 ++
 arch/arm64/boot/dts/renesas/ebisu.dtsi              | 2 ++
 arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi     | 2 ++
 arch/arm64/boot/dts/renesas/r8a77970-eagle.dts      | 2 ++
 arch/arm64/boot/dts/renesas/r8a77970-v3msk.dts      | 2 ++
 arch/arm64/boot/dts/renesas/r8a77980-condor.dts     | 2 ++
 arch/arm64/boot/dts/renesas/r8a77980-v3hsk.dts      | 2 ++
 arch/arm64/boot/dts/renesas/r8a779a0-falcon.dts     | 2 ++
 arch/arm64/boot/dts/renesas/salvator-common.dtsi    | 2 ++
 arch/arm64/boot/dts/renesas/ulcb.dtsi               | 2 ++
 31 files changed, 62 insertions(+)

-- 
2.25.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
