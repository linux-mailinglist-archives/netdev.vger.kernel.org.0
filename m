Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B9D201B0B
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 21:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733203AbgFSTQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 15:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733165AbgFSTQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 15:16:09 -0400
Received: from xavier.telenet-ops.be (xavier.telenet-ops.be [IPv6:2a02:1800:120:4::f00:14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00AE3C0617B9
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 12:16:06 -0700 (PDT)
Received: from ramsan ([IPv6:2a02:1810:ac12:ed20:e0be:48f2:cba4:1407])
        by xavier.telenet-ops.be with bizsmtp
        id t7Fx220034UASYb017FxCJ; Fri, 19 Jun 2020 21:16:05 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1jmMUX-0002JR-28; Fri, 19 Jun 2020 21:15:57 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1jmMUX-0006V6-0C; Fri, 19 Jun 2020 21:15:57 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH/RFC 0/5] ravb: Add support for explicit internal clock delay configuration
Date:   Fri, 19 Jun 2020 21:15:49 +0200
Message-Id: <20200619191554.24942-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	Hi all,

Some Renesas EtherAVB variants support internal clock delay
configuration, which can add larger delays than the delays that are
typically supported by the PHY (using an "rgmii-*id" PHY mode, and/or
"[rt]xc-skew-ps" properties).

Historically, the EtherAVB driver configured these delays based on the
"rgmii-*id" PHY mode.  This caused issues with PHY drivers that
implement PHY internal delays properly[1].  Hence a backwards-compatible
workaround was added by masking the PHY mode[2].

This RFC patch series implements the next step of the plan outlined in
[3], and adds proper support for explicit configuration of the MAC
internal clock delays using new "renesas,[rt]xc-delay-ps" properties.
If none of these properties is present, the driver falls back to the old
handling.

The series consists of 4 parts:
  1. DT binding update documenting the new properties,
  2. A preparatory improvement,
  3. Driver update implementing support for the new properties,
  4. DT updates, one for R-Car Gen3 and RZ/G2 SoC families each.

Note that patches 4 and 5 depend on patch 3, and must not be applied
before that dependency has hit upstream.

Impacted, tested:
  - Salvator-X(S) with R-Car H3 ES1.0 and ES2.0, M3-W, and M3-N.

Not impacted, tested:
  - Ebisu with R-Car E3.

Impacted, not tested:
  - Salvator-X(S) with other SoC variants,
  - ULCB with R-Car H3/M3-W/M3-N variants,
  - V3MSK and Eagle with R-Car V3M,
  - Draak with R-Car V3H,
  - HiHope RZ/G2[MN] with RZ/G2M or RZ/G2N.

Thanks for your comments!

References:
  [1] Commit bcf3440c6dd78bfe ("net: phy: micrel: add phy-mode support
      for the KSZ9031 PHY")
  [2] Commit 9b23203c32ee02cd ("ravb: Mask PHY mode to avoid inserting
      delays twice").
      https://lore.kernel.org/r/20200529122540.31368-1-geert+renesas@glider.be/
  [3] https://lore.kernel.org/r/CAMuHMdU+MR-2tr3-pH55G0GqPG9HwH3XUd=8HZxprFDMGQeWUw@mail.gmail.com/

Geert Uytterhoeven (5):
  dt-bindings: net: renesas,ravb: Document internal clock delay
    properties
  ravb: Split delay handling in parsing and applying
  ravb: Add support for explicit internal clock delay configuration
  arm64: dts: renesas: rcar-gen3: Convert EtherAVB to explicit delay
    handling
  arm64: dts: renesas: rzg2: Convert EtherAVB to explicit delay handling

 .../devicetree/bindings/net/renesas,ravb.txt  | 29 ++++++-----
 .../boot/dts/renesas/hihope-rzg2-ex.dtsi      |  2 +-
 arch/arm64/boot/dts/renesas/r8a774a1.dtsi     |  2 +
 arch/arm64/boot/dts/renesas/r8a774b1.dtsi     |  2 +
 arch/arm64/boot/dts/renesas/r8a774c0.dtsi     |  1 +
 arch/arm64/boot/dts/renesas/r8a77951.dtsi     |  2 +
 arch/arm64/boot/dts/renesas/r8a77960.dtsi     |  2 +
 arch/arm64/boot/dts/renesas/r8a77961.dtsi     |  2 +
 arch/arm64/boot/dts/renesas/r8a77965.dtsi     |  2 +
 .../arm64/boot/dts/renesas/r8a77970-eagle.dts |  3 +-
 .../arm64/boot/dts/renesas/r8a77970-v3msk.dts |  3 +-
 arch/arm64/boot/dts/renesas/r8a77970.dtsi     |  2 +
 arch/arm64/boot/dts/renesas/r8a77980.dtsi     |  2 +
 arch/arm64/boot/dts/renesas/r8a77990.dtsi     |  1 +
 arch/arm64/boot/dts/renesas/r8a77995.dtsi     |  1 +
 .../boot/dts/renesas/salvator-common.dtsi     |  2 +-
 arch/arm64/boot/dts/renesas/ulcb.dtsi         |  2 +-
 drivers/net/ethernet/renesas/ravb.h           |  5 +-
 drivers/net/ethernet/renesas/ravb_main.c      | 52 ++++++++++++++-----
 19 files changed, 86 insertions(+), 31 deletions(-)

-- 
2.17.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
