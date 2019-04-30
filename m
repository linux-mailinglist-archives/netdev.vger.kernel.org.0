Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51F83FB26
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 16:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbfD3ONn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 10:13:43 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:61438 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbfD3ONm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 10:13:42 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 9D0FE6633;
        Tue, 30 Apr 2019 16:13:36 +0200 (CEST)
Received: from localhost (meh.true.cz [local])
        by meh.true.cz (OpenSMTPD) with ESMTPA id 3c5c6e60;
        Tue, 30 Apr 2019 16:13:35 +0200 (CEST)
Date:   Tue, 30 Apr 2019 16:13:35 +0200
From:   Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Alban Bedel <albeu@free.fr>
Subject: Handling of EPROBE_DEFER in of_get_mac_address [Was: Re: [PATCH v2
 3/4] net: macb: Drop nvmem_get_mac_address usage]
Message-ID: <20190430141335.GC346@meh.true.cz>
Reply-To: Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
References: <1556456002-13430-1-git-send-email-ynezz@true.cz>
 <1556456002-13430-4-git-send-email-ynezz@true.cz>
 <20190428165637.GJ23059@lunn.ch>
 <20190428210814.GA346@meh.true.cz>
 <20190428213640.GB10772@lunn.ch>
 <20190429075514.GB346@meh.true.cz>
 <20190429130248.GC10772@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190429130248.GC10772@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew Lunn <andrew@lunn.ch> [2019-04-29 15:02:48]:

Hi Andrew,

> > My understanding of -PROBE_DEFER is, that it needs to be propagated back from
> > the driver's probe callback/hook to the upper device/driver subsystem in order
> > to be moved to the list of pending drivers and considered for probe later
> > again. This is not going to happen in any of the current drivers, thus it will
> > probably still always result in random MAC address in case of -EPROBE_DEFER
> > error from the nvmem subsystem.
> 
> All current drivers which don't look in NVMEM don't expect
> EPROBE_DEFER. 

once there's NVMEM wired in of_get_mac_address, one can simply use it, nothing
is going to stop the potential user of doing so and if EPROBE_DEFER isn't
propagated from the driver back to the upper device driver subsytem, it's
probably going to end with random MAC address in some (very rare?) cases.

So if we don't want to properly convert all current of_get_mac_address users,
and just selectively upgrade drivers which could support NVMEM (and it makes
sense for those drivers) with proper EPROBE_DEFER handling, we should probably
just extend of_get_mac_address and convert those drivers to NVMEM one by one,
as needed:

 enum of_mac_addr {
	OF_MAC_ADDR_DT = 0,
	OF_MAC_ADDR_DT_NVMEM
 };

 const void *of_get_mac_address(struct device_node *np, enum of_mac_addr type);

  (just my first rough idea, feel free to suggest something more acceptable)

> The one driver which does expect EPROBE_DEFER already has the code to
> handle it.

I've read the code in that macb driver several times and I don't see any code
which is specificaly handling the EPROBE_DEFER, so I'm probably blind or I miss
something fundamental ;-) This driver is simply forwarding that EPROBE_DEFER
error to the upper layer, nothing specific. The other one, davinci_emac simply
doesn't care about the possible EPROBE_DEFER and uses random MAC address in
case of any NVMEM error.

> What you have to be careful of, is the return value from your new code
> looking in NVMEM. It should only return EPROBE_DEFER, or another error
> if there really is expected to be a value in NVMEM, or getting it from
> NVMEM resulted in an error.

Thanks for the hint, I've created of_has_nvmem_mac_addr helper for that and it
works fine.

> I've not looked at the details of nvmem_get_mac_address(), but it
> should be a two stage process. The first is to look in device tree to
> find the properties. Device tree is always accessible. So performing a
> lookup will never return EPROBE_DEFER. If there are no properties, it
> probably return -ENODEV. You need to consider that as not being a real
> error, since these are optional properties. of_get_mac_address() needs
> to try the next source of the MAC address. The second stage is to look
> into the NVMEM. That could return -EPROBE_DEFER and you should return
> that error, or any other error at this stage. The MAC address should
> exist in NVMEM so we want to know about the error.

While looking at all current of_get_mac_address users, I've simply found out,
that it would look inconsistent and confusing to propagate back EPROBE_DEFER
just in some places, so I've bitten the bullet and converted all current
of_get_mac_address users to return EPROBE_DEFER properly (where applicable),
see bellow.

It has resulted in a bunch of commits, and as I'm not sure how it's going to be
received and to avoid sending more nonsense to a lot of lists and people, I've
made it available in my GitHub repository (just tell me that it's OK and I'll
send it as v3):

 The following changes since commit 37624b58542fb9f2d9a70e6ea006ef8a5f66c30b:

   Linux 5.1-rc7 (2019-04-28 17:04:13 -0700)

 are available in the git repository at:

   https://github.com/ynezz/linux.git upstream/nvmem-mac-address

 for you to fetch changes up to 5eb1e8131d3f97a488b74563dd8fefa068218e05:

   powerpc: tsi108: adjust for of_get_mac_address ERR_PTR encoded error value (2019-04-30 13:02:22 +0200)

 ----------------------------------------------------------------
 Petr Štetiar (20):
       of_net: add NVMEM support to of_get_mac_address
       dt-bindings: doc: reflect new NVMEM of_get_mac_address behaviour
       net: macb: drop nvmem_get_mac_address usage
       net: davinci_emac: drop nvmem_get_mac_address usage
       net: ethernet: make eth_platform_get_mac_address probe defer aware
       net: ethernet: make of_get_mac_address probe defer aware
       net: usb: make eth_platform_get_mac_address probe defer aware
       net: usb: make of_get_mac_address probe defer aware
       net: sh_eth: make of_get_mac_address probe defer aware
       net: fec: make of_get_mac_address probe defer aware
       net: fec_mpc52xx: make of_get_mac_address probe defer aware
       net: hisi_femac: make of_get_mac_address probe defer aware
       net: sky2: make of_get_mac_address probe defer aware
       net: ks8851: make of_get_mac_address probe defer aware
       wireless: ath9k: make of_get_mac_address probe defer aware
       wireless: mt76: make of_get_mac_address probe defer aware
       wireless: ralink: make of_get_mac_address probe defer aware
       staging: octeon-ethernet: make of_get_mac_address probe defer aware
       ARM: Kirkwood: adjust for of_get_mac_address ERR_PTR encoded error value
       powerpc: tsi108: adjust for of_get_mac_address ERR_PTR encoded error value

  .../devicetree/bindings/net/altera_tse.txt         |  5 +-
  Documentation/devicetree/bindings/net/amd-xgbe.txt |  5 +-
  .../devicetree/bindings/net/brcm,amac.txt          |  4 +-
  Documentation/devicetree/bindings/net/cpsw.txt     |  4 +-
  .../devicetree/bindings/net/davinci_emac.txt       |  5 +-
  Documentation/devicetree/bindings/net/dsa/dsa.txt  |  5 +-
  Documentation/devicetree/bindings/net/ethernet.txt |  6 +-
  .../devicetree/bindings/net/hisilicon-femac.txt    |  4 +-
  .../bindings/net/hisilicon-hix5hd2-gmac.txt        |  4 +-
  .../devicetree/bindings/net/keystone-netcp.txt     | 10 ++--
  Documentation/devicetree/bindings/net/macb.txt     |  5 +-
  .../devicetree/bindings/net/marvell-pxa168.txt     |  4 +-
  .../devicetree/bindings/net/microchip,enc28j60.txt |  3 +-
  .../devicetree/bindings/net/microchip,lan78xx.txt  |  5 +-
  .../devicetree/bindings/net/qca,qca7000.txt        |  4 +-
  .../devicetree/bindings/net/samsung-sxgbe.txt      |  4 +-
  .../bindings/net/snps,dwc-qos-ethernet.txt         |  5 +-
  .../bindings/net/socionext,uniphier-ave4.txt       |  4 +-
  .../devicetree/bindings/net/socionext-netsec.txt   |  5 +-
  .../bindings/net/wireless/mediatek,mt76.txt        |  5 +-
  .../devicetree/bindings/net/wireless/qca,ath9k.txt |  4 +-
  arch/arm/mach-mvebu/kirkwood.c                     |  3 +-
  arch/powerpc/sysdev/tsi108_dev.c                   |  2 +-
  drivers/net/ethernet/aeroflex/greth.c              |  5 +-
  drivers/net/ethernet/allwinner/sun4i-emac.c        |  9 +--
  drivers/net/ethernet/altera/altera_tse_main.c      |  8 ++-
  drivers/net/ethernet/arc/emac_main.c               |  9 ++-
  drivers/net/ethernet/aurora/nb8800.c               |  9 ++-
  drivers/net/ethernet/broadcom/bcmsysport.c         |  5 +-
  drivers/net/ethernet/broadcom/bgmac-bcma.c         |  9 ++-
  drivers/net/ethernet/broadcom/bgmac-platform.c     |  4 +-
  drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  7 ++-
  drivers/net/ethernet/broadcom/tg3.c                | 10 +++-
  drivers/net/ethernet/cadence/macb_main.c           | 12 ++--
  drivers/net/ethernet/cavium/octeon/octeon_mgmt.c   |  9 ++-
  drivers/net/ethernet/cavium/thunder/thunder_bgx.c  |  4 +-
  drivers/net/ethernet/davicom/dm9000.c              |  4 +-
  drivers/net/ethernet/ethoc.c                       |  6 +-
  drivers/net/ethernet/ezchip/nps_enet.c             |  8 ++-
  drivers/net/ethernet/freescale/fec_main.c          | 17 ++++--
  drivers/net/ethernet/freescale/fec_mpc52xx.c       | 25 +++++----
  drivers/net/ethernet/freescale/fman/mac.c          |  5 +-
  .../net/ethernet/freescale/fs_enet/fs_enet-main.c  |  6 +-
  drivers/net/ethernet/freescale/gianfar.c           |  7 ++-
  drivers/net/ethernet/freescale/ucc_geth.c          |  6 +-
  drivers/net/ethernet/hisilicon/hisi_femac.c        | 21 ++++---
  drivers/net/ethernet/hisilicon/hix5hd2_gmac.c      |  7 ++-
  drivers/net/ethernet/intel/i40e/i40e_main.c        | 15 ++++-
  drivers/net/ethernet/intel/igb/igb_main.c          |  5 +-
  drivers/net/ethernet/intel/igc/igc_main.c          |  5 +-
  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  6 +-
  drivers/net/ethernet/lantiq_xrx200.c               |  4 +-
  drivers/net/ethernet/marvell/mv643xx_eth.c         |  4 +-
  drivers/net/ethernet/marvell/mvneta.c              |  5 +-
  drivers/net/ethernet/marvell/pxa168_eth.c          |  9 ++-
  drivers/net/ethernet/marvell/sky2.c                | 14 +++--
  drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  8 +--
  drivers/net/ethernet/micrel/ks8851.c               | 15 +++--
  drivers/net/ethernet/micrel/ks8851_mll.c           |  6 +-
  drivers/net/ethernet/microchip/enc28j60.c          |  8 ++-
  drivers/net/ethernet/nxp/lpc_eth.c                 | 10 +++-
  drivers/net/ethernet/qualcomm/qca_spi.c            |  9 +--
  drivers/net/ethernet/qualcomm/qca_uart.c           |  9 +--
  drivers/net/ethernet/realtek/r8169.c               |  4 +-
  drivers/net/ethernet/renesas/ravb_main.c           | 11 +++-
  drivers/net/ethernet/renesas/sh_eth.c              | 15 ++---
  .../net/ethernet/samsung/sxgbe/sxgbe_platform.c    |  7 ++-
  drivers/net/ethernet/socionext/sni_ave.c           |  9 +--
  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  2 +-
  .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |  3 +
  drivers/net/ethernet/ti/cpsw.c                     |  4 +-
  drivers/net/ethernet/ti/davinci_emac.c             | 25 ++++-----
  drivers/net/ethernet/ti/netcp_core.c               |  8 ++-
  drivers/net/ethernet/wiznet/w5100-spi.c            |  6 +-
  drivers/net/ethernet/wiznet/w5100.c                |  2 +-
  drivers/net/ethernet/xilinx/ll_temac_main.c        |  5 +-
  drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  4 +-
  drivers/net/ethernet/xilinx/xilinx_emaclite.c      |  7 ++-
  drivers/net/usb/asix_devices.c                     |  7 ++-
  drivers/net/usb/lan78xx.c                          | 13 ++++-
  drivers/net/usb/smsc75xx.c                         | 16 ++++--
  drivers/net/usb/smsc95xx.c                         | 16 ++++--
  drivers/net/wireless/ath/ath9k/init.c              |  4 +-
  drivers/net/wireless/mediatek/mt76/eeprom.c        | 10 +++-
  drivers/net/wireless/mediatek/mt76/mt76.h          |  2 +-
  drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c |  4 +-
  drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c |  6 +-
  drivers/net/wireless/ralink/rt2x00/rt2400pci.c     |  5 +-
  drivers/net/wireless/ralink/rt2x00/rt2500pci.c     |  5 +-
  drivers/net/wireless/ralink/rt2x00/rt2500usb.c     |  5 +-
  drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |  4 +-
  drivers/net/wireless/ralink/rt2x00/rt2x00.h        |  3 +-
  drivers/net/wireless/ralink/rt2x00/rt2x00dev.c     | 16 ++++--
  drivers/net/wireless/ralink/rt2x00/rt61pci.c       |  5 +-
  drivers/net/wireless/ralink/rt2x00/rt73usb.c       |  5 +-
  drivers/of/of_net.c                                | 64 +++++++++++++++++++++-
  drivers/staging/octeon/ethernet.c                  |  7 ++-
  net/ethernet/eth.c                                 |  8 ++-
  98 files changed, 527 insertions(+), 239 deletions(-)

So I'm wondering, is this (probably) proper handling of EPROBE_DEFER overkill?

Or should I really just convert all current consumers of of_get_mac_address to
IS_ERR_OR_NULL() macro check (as you've suggested) and call it a day? 

Or should I simply change of_get_mac_address so it would allow for progressive
conversion of drivers using of_get_mac_address to NVMEM?

Thanks!

-- ynezz
