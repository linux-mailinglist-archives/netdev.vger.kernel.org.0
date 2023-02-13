Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 769B4695316
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 22:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbjBMVez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 16:34:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbjBMVev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 16:34:51 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570121E1DC;
        Mon, 13 Feb 2023 13:34:50 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pRgTC-0006e0-0X;
        Mon, 13 Feb 2023 22:34:42 +0100
Date:   Mon, 13 Feb 2023 21:33:02 +0000
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
        Andrew Lunn <andrew@lunn.ch>
Cc:     Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: [PATCH v6 00/12] net: ethernet: mtk_eth_soc: various enhancements
Message-ID: <cover.1676323692.git.daniel@makrotopia.org>
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

Note that this series depends on commit 697c3892d825
("regmap: apply reg_base and reg_downshift for single register ops") to
not break mt7530 pcs register access.

The whole series has been tested on MT7622+MT7531 (BPi-R64),
MT7623+MT7530 (BPi-R2) and MT7981+GPY211 (GL.iNet GL-MT3000).

Changes since v5:
 * drop dev pointer also from struct mtk_sgmii, pass it as function
   paramter instead
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


Daniel Golle (12):
  net: ethernet: mtk_eth_soc: add support for MT7981 SoC
  dt-bindings: net: mediatek,net: add mt7981-eth binding
  dt-bindings: arm: mediatek: sgmiisys: Convert to DT schema
  dt-bindings: arm: mediatek: sgmiisys: add MT7981 SoC
  net: ethernet: mtk_eth_soc: set MDIO bus clock frequency
  net: ethernet: mtk_eth_soc: reset PCS state
  net: ethernet: mtk_eth_soc: only write values if needed
  net: ethernet: mtk_eth_soc: fix RX data corruption issue
  net: ethernet: mtk_eth_soc: ppe: add support for flow accounting
  net: pcs: add driver for MediaTek SGMII PCS
  net: ethernet: mtk_eth_soc: switch to external PCS driver
  net: dsa: mt7530: use external PCS driver

 .../arm/mediatek/mediatek,sgmiisys.txt        |  27 --
 .../arm/mediatek/mediatek,sgmiisys.yaml       |  55 ++++
 .../devicetree/bindings/net/mediatek,net.yaml |  52 ++-
 MAINTAINERS                                   |   7 +
 drivers/net/dsa/Kconfig                       |   1 +
 drivers/net/dsa/mt7530.c                      | 277 ++++------------
 drivers/net/dsa/mt7530.h                      |  47 +--
 drivers/net/ethernet/mediatek/Kconfig         |   2 +
 drivers/net/ethernet/mediatek/mtk_eth_path.c  |  14 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  66 +++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h   | 105 +++---
 drivers/net/ethernet/mediatek/mtk_ppe.c       | 114 ++++++-
 drivers/net/ethernet/mediatek/mtk_ppe.h       |  25 +-
 .../net/ethernet/mediatek/mtk_ppe_debugfs.c   |   9 +-
 .../net/ethernet/mediatek/mtk_ppe_offload.c   |   8 +
 drivers/net/ethernet/mediatek/mtk_ppe_regs.h  |  14 +
 drivers/net/ethernet/mediatek/mtk_sgmii.c     | 192 ++---------
 drivers/net/pcs/Kconfig                       |   7 +
 drivers/net/pcs/Makefile                      |   1 +
 drivers/net/pcs/pcs-mtk-lynxi.c               | 303 ++++++++++++++++++
 include/linux/pcs/pcs-mtk-lynxi.h             |  13 +
 21 files changed, 801 insertions(+), 538 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.yaml
 create mode 100644 drivers/net/pcs/pcs-mtk-lynxi.c
 create mode 100644 include/linux/pcs/pcs-mtk-lynxi.h


base-commit: 09e41676e35ab06e4bce8870ea3bf1f191c3cb90
-- 
2.39.1

