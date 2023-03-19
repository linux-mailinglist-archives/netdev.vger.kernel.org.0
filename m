Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB636C01C7
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 13:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbjCSM6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 08:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjCSM6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 08:58:04 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9600D193D2;
        Sun, 19 Mar 2023 05:58:01 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pdsbe-0001Fp-21;
        Sun, 19 Mar 2023 13:57:50 +0100
Date:   Sun, 19 Mar 2023 12:56:07 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: [PATCH net-next v14 0/9] net: ethernet: mtk_eth_soc: various
 enhancements
Message-ID: <cover.1679230025.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series brings a variety of fixes and enhancements for mtk_eth_soc,
adds support for the MT7981 SoC and facilitates sharing the SGMII PCS
code between mtk_eth_soc and mt7530.

The whole series has been tested on MT7622+MT7531 (BPi-R64),
MT7623+MT7530 (BPi-R2), MT7981+GPY211 (GL.iNet GL-MT3000) and
MT7986+MT7531 (BPi-R3). On the BananaPi R3 a variete of SFP modules
have been tested, all of them (some SGMII with PHY, others 2500Base-X
or 1000Base-X without PHY) are working well now, however, some of them
need manually disabling of autonegotiation for the link to come up.

Changes since v13:
 * no longer pile Lorenzo's patches on top, they will be submitted
   separately
 * patches fixing existing code have been submitted already via 'net'
   tree, so they are no longer included in this series.

Changes since v12:
 * remove patches "fixing" ????Base-X modes. Turns out the cause are
   buggy SFP modules for which we will need to introduce quirks rather
   than trying to address this in the Ethernet driver.

Changes since v11:
 * remove patch "net: ethernet: mtk_eth_soc: fix RX data corruption issue"
   as it has already been merged via net tree
 * add commits fixing 1000Base-X and 2500Base-X modes after phylink_pcs
   conversion
 * completely remove mtk_sgmii.c as only about 20 lines were left in that
   file
 * Add commits from Lorenzo for MT7988 as requested by him

Changes since v10:
 * improve mediatek,mt7981-eth dt-bindings
 * use regmap_set_bits instead of regmap_update_bits where possible
 * completely remove mtk_sgmii.c
 * no need to keep struct mtk_sgmii either as it had only a single
   element

Changes since v9:
 * fix path in mediatek,sgmiisys dt-binding

Changes since v8:
 * move mediatek,sgmiisys dt-bindings to correct net/pcs folder
 * rebase on top of net-next/main so series applies cleanly again

Changes since v7:
 * move mediatek,sgmiisys.yaml to more appropriate folder
 * don't include <linux/phylink.h> twice in PCS driver, sort includes

Changes since v6:
 * label MAC MCR bit 12 in 08/12, MediaTek replied explaining its function

Changes since v5:
 * drop dev pointer also from struct mtk_sgmii, pass it as function
   parameter instead
 * address comments left for dt-bindings
 * minor improvements to commit messages

Changes since v4:
 * remove unused dev pointer in struct pcs_mtk_lynxi
 * squash link timer check into correct follow-up patch

Changes since v3:
 * remove unused #define's
 * use BMCR_* instead of #define'ing our own constants
 * return before changing registers in case of invalid link timer

Changes since v2:
 * improve dt-bindings, convert sgmisys bindings to dt-schema yaml
 * fix typo

Changes since v1:
 * apply reverse xmas tree everywhere
 * improve commit descriptions
 * add dt binding documentation
 * various small changes addressing all comments received for v1


Daniel Golle (9):
  net: ethernet: mtk_eth_soc: add support for MT7981 SoC
  dt-bindings: net: mediatek,net: add mt7981-eth binding
  dt-bindings: arm: mediatek: sgmiisys: Convert to DT schema
  dt-bindings: net: pcs: mediatek,sgmiisys: add MT7981 SoC
  net: ethernet: mtk_eth_soc: set MDIO bus clock frequency
  net: ethernet: mtk_eth_soc: ppe: add support for flow accounting
  net: pcs: add driver for MediaTek SGMII PCS
  net: ethernet: mtk_eth_soc: switch to external PCS driver
  net: dsa: mt7530: use external PCS driver

 .../arm/mediatek/mediatek,sgmiisys.txt        |  27 --
 .../devicetree/bindings/net/mediatek,net.yaml |  53 ++-
 .../bindings/net/pcs/mediatek,sgmiisys.yaml   |  55 ++++
 MAINTAINERS                                   |   8 +
 drivers/net/dsa/Kconfig                       |   1 +
 drivers/net/dsa/mt7530.c                      | 277 ++++------------
 drivers/net/dsa/mt7530.h                      |  47 +--
 drivers/net/ethernet/mediatek/Kconfig         |   2 +
 drivers/net/ethernet/mediatek/Makefile        |   2 +-
 drivers/net/ethernet/mediatek/mtk_eth_path.c  |  14 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   | 111 ++++++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h   | 118 +++----
 drivers/net/ethernet/mediatek/mtk_ppe.c       | 114 ++++++-
 drivers/net/ethernet/mediatek/mtk_ppe.h       |  25 +-
 .../net/ethernet/mediatek/mtk_ppe_debugfs.c   |   9 +-
 .../net/ethernet/mediatek/mtk_ppe_offload.c   |   8 +
 drivers/net/ethernet/mediatek/mtk_ppe_regs.h  |  14 +
 drivers/net/ethernet/mediatek/mtk_sgmii.c     | 207 ------------
 drivers/net/pcs/Kconfig                       |   7 +
 drivers/net/pcs/Makefile                      |   1 +
 drivers/net/pcs/pcs-mtk-lynxi.c               | 305 ++++++++++++++++++
 include/linux/pcs/pcs-mtk-lynxi.h             |  13 +
 22 files changed, 819 insertions(+), 599 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt
 create mode 100644 Documentation/devicetree/bindings/net/pcs/mediatek,sgmiisys.yaml
 delete mode 100644 drivers/net/ethernet/mediatek/mtk_sgmii.c
 create mode 100644 drivers/net/pcs/pcs-mtk-lynxi.c
 create mode 100644 include/linux/pcs/pcs-mtk-lynxi.h


base-commit: 105a201ebf3312990b96c4fbaade22e31402f8cc
-- 
2.39.2

