Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04D291302F
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 16:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbfECO2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 10:28:52 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:59218 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbfECO1a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 10:27:30 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 9A93A4AC5;
        Fri,  3 May 2019 16:27:24 +0200 (CEST)
Received: by meh.true.cz (OpenSMTPD) with ESMTP id eb006926;
        Fri, 3 May 2019 16:27:23 +0200 (CEST)
From:   =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v4 00/10] of_net: Add NVMEM support to of_get_mac_address
Date:   Fri,  3 May 2019 16:27:05 +0200
Message-Id: <1556893635-18549-1-git-send-email-ynezz@true.cz>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this patch series is a continuation of my previous attempt[1], where I've
tried to wire MTD layer into of_get_mac_address, so it would be possible to
load MAC addresses from various NVMEMs as EEPROMs etc.

Predecessor of this patch which used directly MTD layer has originated in
OpenWrt some time ago and supports already about 497 use cases in 357
device tree files.

During the review process of my 1st attempt I was told, that I shouldn't be
using MTD directly, but that I should rather use new NVMEM subsystem and
during the review process of v2 I was told, that I should handle
EPROBE_DEFFER error as well, during the review process of v3 I was told,
that returning pointer/NULL/ERR_PTR is considered as wrong API design, so
this v4 patch series tries to accommodate all this previous remarks.

First patch is wiring NVMEM support directly into of_get_mac_address as
it's obvious, that adding support for NVMEM into every other driver would
mean adding a lot of repetitive code. This patch allows us to configure MAC
addresses in various devices like ethernet and wireless adapters directly
from of_get_mac_address, which is used by quite a lot of drivers in the
tree already.

Second patch is simply updating documentation with NVMEM bits, and cleaning
up all current binding documentation referencing any of the MAC address
related properties.

Third and fourth patches are simply removing duplicate NVMEM code which is
no longer needed as the first patch has wired NVMEM support directly into
of_get_mac_address.

Patches 5-10 are converting all current users of of_get_mac_address to the
new ERR_PTR encoded error value, as of_get_mac_address could now return
valid pointer, NULL and ERR_PTR.

Just for a better picture, this patch series and one simple patch[2] on top
of it, allows me to configure 8Devices Carambola2 board's MAC addresses
with following DTS (simplified):

 &spi {
 	flash@0 {
 		partitions {
			art: partition@ff0000 {
				label = "art";
				reg = <0xff0000 0x010000>;
				read-only;

				nvmem-cells {
					compatible = "nvmem-cells";
					#address-cells = <1>;
					#size-cells = <1>;

					eth0_addr: eth-mac-addr@0 {
						reg = <0x0 0x6>;
					};

					eth1_addr: eth-mac-addr@6 {
						reg = <0x6 0x6>;
					};

					wmac_addr: wifi-mac-addr@1002 {
						reg = <0x1002 0x6>;
					};
				};
			};
		};
	};
 };

 &eth0 {
	nvmem-cells = <&eth0_addr>;
	nvmem-cell-names = "mac-address";
 };

 &eth1 {
	nvmem-cells = <&eth1_addr>;
	nvmem-cell-names = "mac-address";
 };

 &wmac {
	nvmem-cells = <&wmac_addr>;
	nvmem-cell-names = "mac-address";
 };


1. https://patchwork.ozlabs.org/patch/1086628/
2. https://patchwork.ozlabs.org/patch/890738/

-- ynezz

Petr Štetiar (10):
  of_net: add NVMEM support to of_get_mac_address
  dt-bindings: doc: reflect new NVMEM of_get_mac_address behaviour
  net: macb: support of_get_mac_address new ERR_PTR error
  net: davinci: support of_get_mac_address new ERR_PTR error
  net: ethernet: support of_get_mac_address new ERR_PTR error
  net: usb: support of_get_mac_address new ERR_PTR error
  net: wireless: support of_get_mac_address new ERR_PTR error
  staging: octeon-ethernet: support of_get_mac_address new ERR_PTR error
  ARM: Kirkwood: support of_get_mac_address new ERR_PTR error
  powerpc: tsi108: support of_get_mac_address new ERR_PTR error

 .../devicetree/bindings/net/altera_tse.txt         |  5 +-
 Documentation/devicetree/bindings/net/amd-xgbe.txt |  5 +-
 .../devicetree/bindings/net/brcm,amac.txt          |  4 +-
 Documentation/devicetree/bindings/net/cpsw.txt     |  4 +-
 .../devicetree/bindings/net/davinci_emac.txt       |  5 +-
 Documentation/devicetree/bindings/net/dsa/dsa.txt  |  5 +-
 Documentation/devicetree/bindings/net/ethernet.txt |  6 ++-
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
 drivers/net/ethernet/aeroflex/greth.c              |  2 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c        |  2 +-
 drivers/net/ethernet/altera/altera_tse_main.c      |  2 +-
 drivers/net/ethernet/arc/emac_main.c               |  2 +-
 drivers/net/ethernet/aurora/nb8800.c               |  2 +-
 drivers/net/ethernet/broadcom/bcmsysport.c         |  2 +-
 drivers/net/ethernet/broadcom/bgmac-bcma.c         |  2 +-
 drivers/net/ethernet/broadcom/bgmac-platform.c     |  2 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  2 +-
 drivers/net/ethernet/cadence/macb_main.c           | 12 ++---
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c   |  2 +-
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c  |  2 +-
 drivers/net/ethernet/davicom/dm9000.c              |  2 +-
 drivers/net/ethernet/ethoc.c                       |  2 +-
 drivers/net/ethernet/ezchip/nps_enet.c             |  2 +-
 drivers/net/ethernet/freescale/fec_main.c          |  2 +-
 drivers/net/ethernet/freescale/fec_mpc52xx.c       |  2 +-
 drivers/net/ethernet/freescale/fman/mac.c          |  2 +-
 .../net/ethernet/freescale/fs_enet/fs_enet-main.c  |  2 +-
 drivers/net/ethernet/freescale/gianfar.c           |  2 +-
 drivers/net/ethernet/freescale/ucc_geth.c          |  2 +-
 drivers/net/ethernet/hisilicon/hisi_femac.c        |  2 +-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c      |  2 +-
 drivers/net/ethernet/lantiq_xrx200.c               |  2 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c         |  2 +-
 drivers/net/ethernet/marvell/mvneta.c              |  2 +-
 drivers/net/ethernet/marvell/pxa168_eth.c          |  2 +-
 drivers/net/ethernet/marvell/sky2.c                |  2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  2 +-
 drivers/net/ethernet/micrel/ks8851.c               |  2 +-
 drivers/net/ethernet/micrel/ks8851_mll.c           |  2 +-
 drivers/net/ethernet/microchip/enc28j60.c          |  2 +-
 drivers/net/ethernet/nxp/lpc_eth.c                 |  2 +-
 drivers/net/ethernet/qualcomm/qca_spi.c            |  2 +-
 drivers/net/ethernet/qualcomm/qca_uart.c           |  2 +-
 drivers/net/ethernet/renesas/ravb_main.c           |  2 +-
 drivers/net/ethernet/renesas/sh_eth.c              |  2 +-
 .../net/ethernet/samsung/sxgbe/sxgbe_platform.c    |  2 +-
 drivers/net/ethernet/socionext/sni_ave.c           |  2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  2 +-
 drivers/net/ethernet/ti/cpsw.c                     |  2 +-
 drivers/net/ethernet/ti/davinci_emac.c             | 16 +++----
 drivers/net/ethernet/ti/netcp_core.c               |  2 +-
 drivers/net/ethernet/wiznet/w5100.c                |  2 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c        |  2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |  2 +-
 drivers/net/usb/smsc75xx.c                         |  2 +-
 drivers/net/usb/smsc95xx.c                         |  2 +-
 drivers/net/wireless/ath/ath9k/init.c              |  2 +-
 drivers/net/wireless/mediatek/mt76/eeprom.c        |  2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c     |  2 +-
 drivers/of/of_net.c                                | 54 ++++++++++++++++++++--
 drivers/staging/octeon/ethernet.c                  |  2 +-
 net/ethernet/eth.c                                 |  2 +-
 78 files changed, 175 insertions(+), 116 deletions(-)

-- 
1.9.1

