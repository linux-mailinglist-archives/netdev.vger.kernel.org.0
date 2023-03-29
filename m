Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 213066CEE32
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 17:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbjC2P6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 11:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjC2P6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 11:58:36 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06CF5FDC;
        Wed, 29 Mar 2023 08:58:03 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1phYAh-0003Jq-1t;
        Wed, 29 Mar 2023 17:57:12 +0200
Date:   Wed, 29 Mar 2023 16:57:04 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
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
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
Subject: [RFC PATCH net-next v3 00/15] net: dsa: add support for MT7988
Message-ID: <cover.1680105013.git.daniel@makrotopia.org>
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

Changes since v2:
 * split into many small commits to ease review
 * introduce helper functions to reduce code duplication
 * use helpers for locking to make lock-skipping easier and less ugly
   to implement.
 * add dt-bindings for mediatek,mt7988-switch

Changes since initial RFC:
 * use regmap for register access and move register access to bus-
   specific driver
 * move initialization of MT7531 SGMII PCS to MDIO driver

Daniel Golle (15):
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
  net: dsa: mt7530: add support for single-chip reset line
  net: dsa: mt7530: add support for 10G link modes for CPU port
  net: dsa: mt7530: introduce driver for MT7988 built-in switch
  dt-bindings: net: dsa: mediatek,mt7530: add mediatek,mt7988-switch

 .../bindings/net/dsa/mediatek,mt7530.yaml     |  26 +-
 MAINTAINERS                                   |   3 +
 drivers/net/dsa/Kconfig                       |  28 +-
 drivers/net/dsa/Makefile                      |   4 +-
 drivers/net/dsa/mt7530-mdio.c                 | 242 ++++++++
 drivers/net/dsa/mt7530-mmio.c                 |  96 ++++
 drivers/net/dsa/mt7530.c                      | 519 +++++++++---------
 drivers/net/dsa/mt7530.h                      |  38 +-
 8 files changed, 653 insertions(+), 303 deletions(-)
 create mode 100644 drivers/net/dsa/mt7530-mdio.c
 create mode 100644 drivers/net/dsa/mt7530-mmio.c


base-commit: 86e2eca4ddedc07d639c44c990e1c220cac3741e
-- 
2.39.2

