Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7474327FCEE
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 12:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732026AbgJAKKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 06:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731967AbgJAKK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 06:10:28 -0400
Received: from albert.telenet-ops.be (albert.telenet-ops.be [IPv6:2a02:1800:110:4::f00:1a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1D9C0613E5
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 03:10:28 -0700 (PDT)
Received: from ramsan ([84.195.186.194])
        by albert.telenet-ops.be with bizsmtp
        id aaAA230044C55Sk06aAABk; Thu, 01 Oct 2020 12:10:19 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1kNvXN-0001MU-UI; Thu, 01 Oct 2020 12:10:09 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1kNvXN-0003kW-Sq; Thu, 01 Oct 2020 12:10:09 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Dan Murphy <dmurphy@ti.com>,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Magnus Damm <magnus.damm@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH net-next v4 resend 0/5] net/ravb: Add support for explicit internal clock delay configuration
Date:   Thu,  1 Oct 2020 12:10:03 +0200
Message-Id: <20201001101008.14365-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	Hi David, Jakub,

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

This series consists of 3 parts:
  1. DT binding updates documenting the new properties, for both the
     generic ethernet-controller and the EtherAVB-specific bindings,
  2. Conversion to json-schema of the Renesas EtherAVB DT bindings.
     Technically, the conversion is independent of all of the above.
     I included it in this series, as it shows how all sanity checks on
     "[rt]x-internal-delay-ps" values are implemented as DT binding
     checks,
  3. EtherAVB driver update implementing support for the new properties.

Given Rob has provided his acks for the DT binding updates, all of this
can be merged through net-next.

Changes compared to v3[4]:
  - Add Reviewed-by,
  - Drop the DT updates, as they will be merged through renesas-devel and
    arm-soc, and have a hard dependency on this series.

Changes compared to v2[5]:
  - Update recently added board DTS files,
  - Add Reviewed-by.

Changes compared to v1[6]:
  - Added "[PATCH 1/7] dt-bindings: net: ethernet-controller: Add
    internal delay properties",
  - Replace "renesas,[rt]xc-delay-ps" by "[rt]x-internal-delay-ps",
  - Incorporated EtherAVB DT binding conversion to json-schema,
  - Add Reviewed-by.

Impacted, tested:
  - Salvator-X(S) with R-Car H3 ES1.0 and ES2.0, M3-W, and M3-N.

Not impacted, tested:
  - Ebisu with R-Car E3.

Impacted, not tested:
  - Salvator-X(S) with other SoC variants,
  - ULCB with R-Car H3/M3-W/M3-N variants,
  - V3MSK and Eagle with R-Car V3M,
  - Draak with R-Car V3H,
  - HiHope RZ/G2[MN] with RZ/G2M or RZ/G2N,
  - Beacon EmbeddedWorks RZ/G2M Development Kit.

To ease testing, I have pushed this series and the DT updates to the
topic/ravb-internal-clock-delays-v4 branch of my renesas-drivers
repository at
git://git.kernel.org/pub/scm/linux/kernel/git/geert/renesas-drivers.git.

Thanks for applying!

References:
  [1] Commit bcf3440c6dd78bfe ("net: phy: micrel: add phy-mode support
      for the KSZ9031 PHY")
  [2] Commit 9b23203c32ee02cd ("ravb: Mask PHY mode to avoid inserting
      delays twice").
      https://lore.kernel.org/r/20200529122540.31368-1-geert+renesas@glider.be/
  [3] https://lore.kernel.org/r/CAMuHMdU+MR-2tr3-pH55G0GqPG9HwH3XUd=8HZxprFDMGQeWUw@mail.gmail.com/
  [4] https://lore.kernel.org/linux-devicetree/20200819134344.27813-1-geert+renesas@glider.be/
  [5] https://lore.kernel.org/linux-devicetree/20200706143529.18306-1-geert+renesas@glider.be/
  [6] https://lore.kernel.org/linux-devicetree/20200619191554.24942-1-geert+renesas@glider.be/

Geert Uytterhoeven (5):
  dt-bindings: net: ethernet-controller: Add internal delay properties
  dt-bindings: net: renesas,ravb: Document internal clock delay
    properties
  dt-bindings: net: renesas,etheravb: Convert to json-schema
  ravb: Split delay handling in parsing and applying
  ravb: Add support for explicit internal clock delay configuration

 .../bindings/net/ethernet-controller.yaml     |  14 +
 .../bindings/net/renesas,etheravb.yaml        | 261 ++++++++++++++++++
 .../devicetree/bindings/net/renesas,ravb.txt  | 134 ---------
 drivers/net/ethernet/renesas/ravb.h           |   5 +-
 drivers/net/ethernet/renesas/ravb_main.c      |  53 +++-
 5 files changed, 320 insertions(+), 147 deletions(-)
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
