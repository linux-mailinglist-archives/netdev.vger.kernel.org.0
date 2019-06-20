Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E355A4D3D7
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 18:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbfFTQej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 12:34:39 -0400
Received: from vps.xff.cz ([195.181.215.36]:38884 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbfFTQej (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 12:34:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1561048476; bh=o/Mcg/crtvpWxn1wzurghlzWgNJsvC2nPLJ6FrUQ/ak=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OOoXpp5AeLGNexNn7LTMlvWNXYoDw13vRczTqVmlZrlW5UUgGhVmdiiIW/gGRUUNV
         aKjs8K0+yW7kBoCdZND1UogtHtgLvmCd+QQ4WN7NRpABKhWBBepxKGW9A8hISzRoBh
         V5ZscyNMoQZc4A5tonmTLLytGu/CoBsMNjJHEPaw=
Date:   Thu, 20 Jun 2019 18:34:36 +0200
From:   =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>
To:     Jernej =?utf-8?Q?=C5=A0krabec?= <jernej.skrabec@gmail.com>
Cc:     linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        David Airlie <airlied@linux.ie>,
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
Subject: Re: [linux-sunxi] [PATCH v7 0/6] Add support for Orange Pi 3
Message-ID: <20190620163436.upg5pkpspyz64brh@core.my.home>
Mail-Followup-To: Jernej =?utf-8?Q?=C5=A0krabec?= <jernej.skrabec@gmail.com>,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        Mark Rutland <mark.rutland@arm.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com
References: <20190620134748.17866-1-megous@megous.com>
 <2263144.KN5DhQ2VKD@jernej-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2263144.KN5DhQ2VKD@jernej-laptop>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jernej,

On Thu, Jun 20, 2019 at 05:53:58PM +0200, Jernej Škrabec wrote:
> Hi!
> 
> Dne četrtek, 20. junij 2019 ob 15:47:42 CEST je megous via linux-sunxi 
> napisal(a):
> > From: Ondrej Jirman <megous@megous.com>
> > 
> > This series implements support for Xunlong Orange Pi 3 board.
> > 
> > - ethernet support (patches 1-3)
> 
> Correct me if I'm wrong, but patches 1-2 aren't strictly necessary for 
> OrangePi 3, right? H6 DTSI already has emac node with dual compatible (H6 and 
> A64) and since OrangePi 3 uses gigabit ethernet, quirk introduced by patches 
> 1-2 are not needed.

I've checked with u-boot and md.l 0x03000030 (syscon_field) and the actual
default value there on cold boot is 0x58000, just like on H3.

H3_EPHY_SELECT is BIT(15)

That means that those patches (1 and 2) are both doing the same thing, basicaly.
H3_EPHY_SELECT bit needs to be cleared, and it is cleared either explicitly, or
via default_syscon_value = 0x50000. It's also cleared incidentally by using
emac_variant_a64, because it has default_syscon_value set to 0.

Meaning of those remaining set bits on H6[1] are the same as on H3. Bit 16 is
SHUTDOWN (on 1) and bit 18 is CLK_SEL. At least SHUTDOWN bit should be kept
high, as it keeps the EPHY shut down. Normally that would be ensured by the
code, but only if soc_has_internal_phy is true, which it is not for
emac_variant_a64.

Thus the patch adds the emac_variant_h6 with a different default_syscon_value
from A64.

Dose the SHUTDOWN bit matter on H6? I don't know. I'm just trying to keep the
default values of these bits unchanged. Maybe it would be nicer to have
default_syscon_value be 0x58000 on H6, to avoid the boot warning.

dwmac-sun8i 5020000.ethernet: Current syscon value is not the default 58000 (expect 50000)

The same warning is there with A64 compatible (with "expect 0").

[1] See page 238 in H6 manual.

regards,
	o.

> However, it is nice to have this 100 Mbit fix, because most STB DTS will need 
> it.
> 
> Best regards,
> Jernej
> 
> > - HDMI support (patches 4-6)
> > 
> > For some people, ethernet doesn't work after reboot (but works on cold
> > boot), when the stmmac driver is built into the kernel. It works when
> > the driver is built as a module. It's either some timing issue, or power
> > supply issue or a combination of both. Module build induces a power
> > cycling of the phy.
> > 
> > I encourage people with this issue, to build the driver into the kernel,
> > and try to alter the reset timings for the phy in DTS or
> > startup-delay-us and report the findings.
> > 
> > 
> > Please take a look.
> > 
> > thank you and regards,
> >   Ondrej Jirman
> > 
> > 
> > Changes in v7:
> > - dropped stored reference to connector_pdev as suggested by Jernej
> > - added forgotten dt-bindings reviewed-by tag
> > 
> > Changes in v6:
> > - added dt-bindings reviewed-by tag
> > - fix wording in stmmac commit (as suggested by Sergei)
> > 
> > Changes in v5:
> > - dropped already applied patches (pinctrl patches, mmc1 pinconf patch)
> > - rename GMAC-3V3 -> GMAC-3V to match the schematic (Jagan)
> > - changed hdmi-connector's ddc-supply property to ddc-en-gpios
> >   (Rob Herring)
> > 
> > Changes in v4:
> > - fix checkpatch warnings/style issues
> > - use enum in struct sunxi_desc_function for io_bias_cfg_variant
> > - collected acked-by's
> > - fix compile error in drivers/pinctrl/sunxi/pinctrl-sun9i-a80-r.c:156
> >   caused by missing conversion from has_io_bias_cfg struct member
> >   (I've kept the acked-by, because it's a trivial change, but feel free
> >   to object.) (reported by Martin A. on github)
> >   I did not have A80 pinctrl enabled for some reason, so I did not catch
> >   this sooner.
> > - dropped brcm firmware patch (was already applied)
> > - dropped the wifi dts patch (will re-send after H6 RTC gets merged,
> >   along with bluetooth support, in a separate series)
> > 
> > Changes in v3:
> > - dropped already applied patches
> > - changed pinctrl I/O bias selection constants to enum and renamed
> > - added /omit-if-no-ref/ to mmc1_pins
> > - made mmc1_pins default pinconf for mmc1 in H6 dtsi
> > - move ddc-supply to HDMI connector node, updated patch descriptions,
> >   changed dt-bindings docs
> > 
> > Changes in v2:
> > - added dt-bindings documentation for the board's compatible string
> >   (suggested by Clement)
> > - addressed checkpatch warnings and code formatting issues (on Maxime's
> >   suggestions)
> > - stmmac: dropped useless parenthesis, reworded description of the patch
> >   (suggested by Sergei)
> > - drop useles dev_info() about the selected io bias voltage
> > - docummented io voltage bias selection variant macros
> > - wifi: marked WiFi DTS patch and realted mmc1_pins as "DO NOT MERGE",
> >   because wifi depends on H6 RTC support that's not merged yet (suggested
> >   by Clement)
> > - added missing signed-of-bys
> > - changed &usb2otg dr_mode to otg, and added a note about VBUS
> > - improved wording of HDMI driver's DDC power supply patch
> > 
> > Icenowy Zheng (2):
> >   net: stmmac: sun8i: add support for Allwinner H6 EMAC
> >   net: stmmac: sun8i: force select external PHY when no internal one
> > 
> > Ondrej Jirman (4):
> >   arm64: dts: allwinner: orange-pi-3: Enable ethernet
> >   dt-bindings: display: hdmi-connector: Support DDC bus enable
> >   drm: sun4i: Add support for enabling DDC I2C bus to sun8i_dw_hdmi glue
> >   arm64: dts: allwinner: orange-pi-3: Enable HDMI output
> > 
> >  .../display/connector/hdmi-connector.txt      |  1 +
> >  .../dts/allwinner/sun50i-h6-orangepi-3.dts    | 70 +++++++++++++++++++
> >  drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c         | 54 ++++++++++++--
> >  drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h         |  2 +
> >  .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 21 ++++++
> >  5 files changed, 144 insertions(+), 4 deletions(-)
> 
> 
> 
> 
