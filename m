Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47FF82B904
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 18:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfE0QWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 12:22:41 -0400
Received: from vps.xff.cz ([195.181.215.36]:52476 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbfE0QWl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 12:22:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1558974159; bh=FM58/rXvCC2ZgZffUU7onMDJbM92qEgy2B6jGSR8HVY=;
        h=From:To:Cc:Subject:Date:From;
        b=Xdft0VjQJLDFdsHDfR8tZLN6fxztVyrUorgQGnz3MKfpMxAEbiEzmPZgVEavKPxfj
         CMbljdxjMqhndLSL/H4aZMamrHaHyRRUf9+d8qcffGKIJe/Af4lMYNU1EO6mfKFBRH
         XIlzLrw85EWcuan0YuVNJG5zxBh99HsmuDq6iB/Y=
From:   megous@megous.com
To:     linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>
Cc:     Ondrej Jirman <megous@megous.com>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Mark Rutland <mark.rutland@arm.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH v6 0/6] Add support for Orange Pi 3
Date:   Mon, 27 May 2019 18:22:31 +0200
Message-Id: <20190527162237.18495-1-megous@megous.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

This series implements support for Xunlong Orange Pi 3 board.

Unfortunately, this board needs some small driver patches, so I have
split the boards DT patch into chunks that require patches for drivers
in various subsystems.

Suggested merging plan/dependencies:

- stmmac patches are needed for ethernet support (patches 1-3)
  - these should be ready now
- HDMI support (patches 4-6)
  - should be ready

Changes in v2:
- added dt-bindings documentation for the board's compatible string
  (suggested by Clement)
- addressed checkpatch warnings and code formatting issues (on Maxime's
  suggestions)
- stmmac: dropped useless parenthesis, reworded description of the patch
  (suggested by Sergei)
- drop useles dev_info() about the selected io bias voltage
- docummented io voltage bias selection variant macros
- wifi: marked WiFi DTS patch and realted mmc1_pins as "DO NOT MERGE",
  because wifi depends on H6 RTC support that's not merged yet (suggested
  by Clement)
- added missing signed-of-bys
- changed &usb2otg dr_mode to otg, and added a note about VBUS
- improved wording of HDMI driver's DDC power supply patch

Changes in v3:
- dropped already applied patches
- changed pinctrl I/O bias selection constants to enum and renamed
- added /omit-if-no-ref/ to mmc1_pins
- made mmc1_pins default pinconf for mmc1 in H6 dtsi
- move ddc-supply to HDMI connector node, updated patch descriptions,
  changed dt-bindings docs

Changes in v4:
- fix checkpatch warnings/style issues
- use enum in struct sunxi_desc_function for io_bias_cfg_variant
- collected acked-by's
- fix compile error in drivers/pinctrl/sunxi/pinctrl-sun9i-a80-r.c:156
  caused by missing conversion from has_io_bias_cfg struct member
  (I've kept the acked-by, because it's a trivial change, but feel free
  to object.) (reported by Martin A. on github)
  I did not have A80 pinctrl enabled for some reason, so I did not catch
  this sooner.
- dropped brcm firmware patch (was already applied)
- dropped the wifi dts patch (will re-send after H6 RTC gets merged,
  along with bluetooth support, in a separate series)

Changes in v5:
- dropped already applied patches (pinctrl patches, mmc1 pinconf patch)
- rename GMAC-3V3 -> GMAC-3V to match the schematic (Jagan)
- changed hdmi-connector's ddc-supply property to ddc-en-gpios
  (Rob Herring)

Changes in v6:
- added dt-bindings reviewed-by tag
- fix wording in stmmac commit (as suggested by Sergei)

Please take a look.

thank you and regards,
  Ondrej Jirman

Icenowy Zheng (2):
  net: stmmac: sun8i: add support for Allwinner H6 EMAC
  net: stmmac: sun8i: force select external PHY when no internal one

Ondrej Jirman (4):
  arm64: dts: allwinner: orange-pi-3: Enable ethernet
  dt-bindings: display: hdmi-connector: Support DDC bus enable
  drm: sun4i: Add support for enabling DDC I2C bus to sun8i_dw_hdmi glue
  arm64: dts: allwinner: orange-pi-3: Enable HDMI output

 .../display/connector/hdmi-connector.txt      |  1 +
 .../dts/allwinner/sun50i-h6-orangepi-3.dts    | 70 +++++++++++++++++++
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c         | 55 ++++++++++++++-
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h         |  3 +
 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 21 ++++++
 5 files changed, 147 insertions(+), 3 deletions(-)

-- 
2.21.0

