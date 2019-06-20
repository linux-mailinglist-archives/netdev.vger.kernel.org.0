Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D150D4CF79
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 15:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732149AbfFTNsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 09:48:20 -0400
Received: from vps.xff.cz ([195.181.215.36]:36072 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726562AbfFTNry (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 09:47:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1561038471; bh=EtxBSRR4SpnZbnkKuYOnn0iuta6FqDZ+zK2kZr5kejg=;
        h=From:To:Cc:Subject:Date:From;
        b=ckh/EsuH/Dff/Yy+mbHihrInZ6GTZhgcUd7uRM8A84U3v10l+iavQuIZJl3zN8vet
         Ky8x1QlNp3WkmgTTztO+7jm0lD1+d6ArTPoZzjauaYCjEyl/RIW4NKLRTP9CuDcAio
         0YzHHuLwcPEcz2q2h2/j4xOEAZmQq3jnHefTrzBc=
From:   megous@megous.com
To:     linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?Jernej=20=C5=A0krabec?= <jernej.skrabec@gmail.com>
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
Subject: [PATCH v7 0/6] Add support for Orange Pi 3
Date:   Thu, 20 Jun 2019 15:47:42 +0200
Message-Id: <20190620134748.17866-1-megous@megous.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

This series implements support for Xunlong Orange Pi 3 board.

- ethernet support (patches 1-3)
- HDMI support (patches 4-6)

For some people, ethernet doesn't work after reboot (but works on cold
boot), when the stmmac driver is built into the kernel. It works when
the driver is built as a module. It's either some timing issue, or power
supply issue or a combination of both. Module build induces a power
cycling of the phy.

I encourage people with this issue, to build the driver into the kernel,
and try to alter the reset timings for the phy in DTS or
startup-delay-us and report the findings.


Please take a look.

thank you and regards,
  Ondrej Jirman


Changes in v7:
- dropped stored reference to connector_pdev as suggested by Jernej
- added forgotten dt-bindings reviewed-by tag

Changes in v6:
- added dt-bindings reviewed-by tag
- fix wording in stmmac commit (as suggested by Sergei)

Changes in v5:
- dropped already applied patches (pinctrl patches, mmc1 pinconf patch)
- rename GMAC-3V3 -> GMAC-3V to match the schematic (Jagan)
- changed hdmi-connector's ddc-supply property to ddc-en-gpios
  (Rob Herring)

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

Changes in v3:
- dropped already applied patches
- changed pinctrl I/O bias selection constants to enum and renamed
- added /omit-if-no-ref/ to mmc1_pins
- made mmc1_pins default pinconf for mmc1 in H6 dtsi
- move ddc-supply to HDMI connector node, updated patch descriptions,
  changed dt-bindings docs

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
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c         | 54 ++++++++++++--
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h         |  2 +
 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 21 ++++++
 5 files changed, 144 insertions(+), 4 deletions(-)

-- 
2.22.0

