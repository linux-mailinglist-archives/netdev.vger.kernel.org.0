Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E840E2159AE
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 16:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729434AbgGFOfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 10:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729401AbgGFOfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 10:35:43 -0400
Received: from baptiste.telenet-ops.be (baptiste.telenet-ops.be [IPv6:2a02:1800:120:4::f00:13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C11CC08C5F6
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 07:35:42 -0700 (PDT)
Received: from ramsan ([IPv6:2a02:1810:ac12:ed20:e012:1552:6e81:c371])
        by baptiste.telenet-ops.be with bizsmtp
        id zqbX2200L0tDR5Q01qbXHT; Mon, 06 Jul 2020 16:35:41 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1jsSDT-0004kK-9w; Mon, 06 Jul 2020 16:35:31 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1jsSDT-0004mB-6R; Mon, 06 Jul 2020 16:35:31 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Dan Murphy <dmurphy@ti.com>,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Magnus Damm <magnus.damm@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v2 0/7] ravb: Add support for explicit internal clock delay configuration
Date:   Mon,  6 Jul 2020 16:35:22 +0200
Message-Id: <20200706143529.18306-1-geert+renesas@glider.be>
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

This patch series implements the next step of the plan outlined in [3],
and adds proper support for explicit configuration of the MAC internal
clock delays using new "[rt]x-internal-delay-ps" properties.  If none of
these properties is present, the driver falls back to the old handling.

This can be considered the MAC counterpart of commit 9150069bf5fc0e86
("dt-bindings: net: Add tx and rx internal delays"), which applies to
the PHY.  Note that unlike commit 92252eec913b2dd5 ("net: phy: Add a
helper to return the index for of the internal delay"), no helpers are
provided to parse the DT properties, as so far there is a single user
only, which supports only zero or a single fixed value.  Of course such
helpers can be added later, when the need arises, or when deemed useful
otherwise.

This series consists of 4 parts:
  1. DT binding updates documenting the new properties, for both the
     generic ethernet-controller and the EtherAVB-specific bindings.
     => intended to be merged through net-next.
  2. EtherAVB driver update implementing support for the new properties.
     => intended to be merged through net-next.
  3. DT updates, one for R-Car Gen3 and RZ/G2 SoC families each.
     => intended to be merged through renesas-devel and arm-soc, but
	only _after_ 2. has hit upstream.
  4. Conversion to json-schema of the Renesas EtherAVB DT bindings.
     Technically, the conversion is independent of all of the above.
     I included it in this series, as it shows how all sanity checks on
     "[rt]x-internal-delay-ps" values are implemented as DT binding
     checks.
     => intended to be merged through net-next, or devicetree (ignoring
        any conflict due to 1.).

Changes compared to v1[4] (more detail in the individual patch
descriptions):
  - Added "[PATCH 1/7] dt-bindings: net: ethernet-controller: Add
    internal delay properties",
  - Replace "renesas,[rt]xc-delay-ps" by "[rt]x-internal-delay-ps",
  - Incorporated EtherAVB DT binding conversion to json-schema.
  - Add Reviewed-by,

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

To ease testing, I have pushed this series to the
topic/ravb-internal-clock-delays-v2 branch of my renesas-drivers
repository at
git://git.kernel.org/pub/scm/linux/kernel/git/geert/renesas-drivers.git.

Thanks for your comments!

References:
  [1] Commit bcf3440c6dd78bfe ("net: phy: micrel: add phy-mode support
      for the KSZ9031 PHY")
  [2] Commit 9b23203c32ee02cd ("ravb: Mask PHY mode to avoid inserting
      delays twice").
      https://lore.kernel.org/r/20200529122540.31368-1-geert+renesas@glider.be/
  [3] https://lore.kernel.org/r/CAMuHMdU+MR-2tr3-pH55G0GqPG9HwH3XUd=8HZxprFDMGQeWUw@mail.gmail.com/
  [4] https://lore.kernel.org/linux-devicetree/20200619191554.24942-1-geert+renesas@glider.be/

Geert Uytterhoeven (7):
  dt-bindings: net: ethernet-controller: Add internal delay properties
  dt-bindings: net: renesas,ravb: Document internal clock delay
    properties
  ravb: Split delay handling in parsing and applying
  ravb: Add support for explicit internal clock delay configuration
  arm64: dts: renesas: rcar-gen3: Convert EtherAVB to explicit delay
    handling
  arm64: dts: renesas: rzg2: Convert EtherAVB to explicit delay handling
  dt-bindings: net: renesas,etheravb: Convert to json-schema

 .../bindings/net/ethernet-controller.yaml     |  14 +
 .../bindings/net/renesas,etheravb.yaml        | 261 ++++++++++++++++++
 .../devicetree/bindings/net/renesas,ravb.txt  | 134 ---------
 .../boot/dts/renesas/hihope-rzg2-ex.dtsi      |   2 +-
 arch/arm64/boot/dts/renesas/r8a774a1.dtsi     |   2 +
 arch/arm64/boot/dts/renesas/r8a774b1.dtsi     |   2 +
 arch/arm64/boot/dts/renesas/r8a774c0.dtsi     |   1 +
 arch/arm64/boot/dts/renesas/r8a77951.dtsi     |   2 +
 arch/arm64/boot/dts/renesas/r8a77960.dtsi     |   2 +
 arch/arm64/boot/dts/renesas/r8a77961.dtsi     |   2 +
 arch/arm64/boot/dts/renesas/r8a77965.dtsi     |   2 +
 .../arm64/boot/dts/renesas/r8a77970-eagle.dts |   3 +-
 .../arm64/boot/dts/renesas/r8a77970-v3msk.dts |   3 +-
 arch/arm64/boot/dts/renesas/r8a77970.dtsi     |   2 +
 arch/arm64/boot/dts/renesas/r8a77980.dtsi     |   2 +
 arch/arm64/boot/dts/renesas/r8a77990.dtsi     |   1 +
 arch/arm64/boot/dts/renesas/r8a77995.dtsi     |   1 +
 .../boot/dts/renesas/salvator-common.dtsi     |   2 +-
 arch/arm64/boot/dts/renesas/ulcb.dtsi         |   2 +-
 drivers/net/ethernet/renesas/ravb.h           |   5 +-
 drivers/net/ethernet/renesas/ravb_main.c      |  53 +++-
 21 files changed, 346 insertions(+), 152 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/renesas,etheravb.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/renesas,ravb.txt

-- 
2.17.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
