Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 649DF6D3B4F
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 03:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbjDCBQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 21:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjDCBQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 21:16:57 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE1C5BB2;
        Sun,  2 Apr 2023 18:16:56 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pj8oQ-0004f3-1u;
        Mon, 03 Apr 2023 03:16:46 +0200
Date:   Mon, 3 Apr 2023 02:16:40 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        =?utf-8?B?QXLEsW7DpyDDnG5hbA==?= <arinc.unal@arinc9.com>
Cc:     Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
Subject: [PATCH net-next v2 00/14] net: dsa: add support for MT7988
Message-ID: <cover.1680483895.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MediaTek MT7988 SoC comes with a built-in switch very similar to
previous MT7530 and MT7531. However, the switch address space is mapped
into the SoCs memory space rather than being connected via MDIO.
Using MMIO simplifies register access and also removes the need for a bus
lock, and for that reason also makes interrupt handling more light-weight.

Note that this is different from previous SoCs like MT7621 and MT7623N
which also came with an integrated MT7530-like switch which yet had to be
accessed via MDIO.

Split-off the part of the driver registering an MDIO driver, then add
another module acting as MMIO/platform driver.

The whole series has been tested on various MediaTek boards:
 * MT7623A + MT7530 (BPi-R2)
 * MT7986A + MT7531 (BPi-R3)
 * MT7988A reference board

Changes since v1:
 * use 'internal' PHY mode where appropriate
 * use regmap_update_bits in mt7530_rmw
 * improve dt-bindings

Changes since RFC v3:
 * WARN_ON_ONCE if register read fails
 * move probing of the reset GPIO and reset controller link out of
   common  probe function, as they are not actually common

Changes since RFC v2:
 * split into many small commits to ease review
 * introduce helper functions to reduce code duplication
 * use helpers for locking to make lock-skipping easier and less ugly
   to implement.
 * add dt-bindings for mediatek,mt7988-switch

Changes since initial RFC:
 * use regmap for register access and move register access to bus-
   specific driver
 * move initialization of MT7531 SGMII PCS to MDIO driver

Daniel Golle (14):
  net: dsa: mt7530: make some noise if register read fails
  net: dsa: mt7530: refactor SGMII PCS creation
  net: dsa: mt7530: use unlocked regmap accessors
  net: dsa: mt7530: use regmap to access switch register space
  net: dsa: mt7530: move SGMII PCS creation to mt7530_probe function
  net: dsa: mt7530: introduce mutex helpers
  net: dsa: mt7530: move p5_intf_modes() function to mt7530.c
  net: dsa: mt7530: introduce mt7530_probe_common helper function
  net: dsa: mt7530: introduce mt7530_remove_common helper function
  net: dsa: mt7530: split-off common parts from mt7531_setup
  net: dsa: mt7530: introduce separate MDIO driver
  net: dsa: mt7530: skip locking if MDIO bus isn't present
  net: dsa: mt7530: introduce driver for MT7988 built-in switch
  dt-bindings: net: dsa: mediatek,mt7530: add mediatek,mt7988-switch

 .../bindings/net/dsa/mediatek,mt7530.yaml     |  26 +-
 MAINTAINERS                                   |   3 +
 drivers/net/dsa/Kconfig                       |  27 +-
 drivers/net/dsa/Makefile                      |   2 +
 drivers/net/dsa/mt7530-mdio.c                 | 271 +++++++++
 drivers/net/dsa/mt7530-mmio.c                 | 101 ++++
 drivers/net/dsa/mt7530.c                      | 565 +++++++++---------
 drivers/net/dsa/mt7530.h                      |  38 +-
 8 files changed, 713 insertions(+), 320 deletions(-)
 create mode 100644 drivers/net/dsa/mt7530-mdio.c
 create mode 100644 drivers/net/dsa/mt7530-mmio.c


base-commit: 51aaa68222d6c34f0373cf95223ce2f230329e8f
-- 
2.40.0

