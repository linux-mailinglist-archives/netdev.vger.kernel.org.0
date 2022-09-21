Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9A45BF9B6
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 10:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbiIUIsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 04:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231436AbiIUIsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 04:48:41 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7EC5B7FFA1;
        Wed, 21 Sep 2022 01:48:39 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.93,332,1654527600"; 
   d="scan'208";a="135683808"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 21 Sep 2022 17:48:38 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 5E0CB41D8A0E;
        Wed, 21 Sep 2022 17:48:38 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     kishon@ti.com, vkoul@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        richardcochran@gmail.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, geert+renesas@glider.be
Cc:     andrew@lunn.ch, linux-phy@lists.infradead.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH v2 0/8] treewide: Add R-Car S4-8 Ethernet Switch support
Date:   Wed, 21 Sep 2022 17:47:37 +0900
Message-Id: <20220921084745.3355107-1-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.5 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        KHOP_HELO_FCRDNS,SPF_HELO_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series is based on next-20220915.
Add minimal support for R-Car S4-8 Etherent Switch. This hardware
supports a lot of features. But, this driver only supports it as
act as an ethernet controller for now.

- patch [1/8] is for CCF.
- patch [2/8] and [3/8] are for Generic PHY.
- patch [4/8] through [6/8] are for Network Ethernet.
- patch [7/8] and [8/8] are for Renesas ARM64 SoC.

Changes from v1:
 https://lore.kernel.org/all/20220909132614.1967276-1-yoshihiro.shimoda.uh@renesas.com/
 - Separate Ethernet SERDES hardware block so that made a Generic PHY driver.
 - Separate PTP support into a patch as patch [6/8].
 - Fix dt-bindings of Ethernet Switch.
 - Remove module parameters from Ethernet Switch driver.
 - Wrote reverse christmas tree about local variables in all the code.
 - Improve error path handlings.
 - Add comment about the current hardware limitation.
 - Add comment about magic numbers about SERDES settings.

Yoshihiro Shimoda (8):
  clk: renesas: r8a779f0: Add Ethernet Switch clocks
  dt-bindings: phy: renesas: Document Renesas Ethernet SERDES
  phy: renesas: Add Renesas Ethernet SERDES driver for R-Car S4-8
  dt-bindings: net: renesas: Document Renesas Ethernet Switch
  net: ethernet: renesas: Add Ethernet Switch driver
  net: ethernet: renesas: rswitch: Add R-Car Gen4 gPTP support
  arm64: dts: renesas: r8a779f0: Add Ethernet Switch and SERDES nodes
  arm64: dts: renesas: r8a779f0: spider: Enable Ethernet Switch and
    SERDES

 .../bindings/net/renesas,etherswitch.yaml     |  286 +++
 .../bindings/phy/renesas,ether-serdes.yaml    |   54 +
 .../dts/renesas/r8a779f0-spider-ethernet.dtsi |   54 +
 arch/arm64/boot/dts/renesas/r8a779f0.dtsi     |  111 +
 drivers/clk/renesas/r8a779f0-cpg-mssr.c       |    2 +
 drivers/net/ethernet/renesas/Kconfig          |   11 +
 drivers/net/ethernet/renesas/Makefile         |    4 +
 drivers/net/ethernet/renesas/rcar_gen4_ptp.c  |  151 ++
 drivers/net/ethernet/renesas/rcar_gen4_ptp.h  |   71 +
 drivers/net/ethernet/renesas/rswitch.c        | 1779 +++++++++++++++++
 drivers/net/ethernet/renesas/rswitch.h        |  967 +++++++++
 drivers/phy/renesas/Kconfig                   |    7 +
 drivers/phy/renesas/Makefile                  |    2 +-
 drivers/phy/renesas/r8a779f0-ether-serdes.c   |  303 +++
 14 files changed, 3801 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/net/renesas,etherswitch.yaml
 create mode 100644 Documentation/devicetree/bindings/phy/renesas,ether-serdes.yaml
 create mode 100644 drivers/net/ethernet/renesas/rcar_gen4_ptp.c
 create mode 100644 drivers/net/ethernet/renesas/rcar_gen4_ptp.h
 create mode 100644 drivers/net/ethernet/renesas/rswitch.c
 create mode 100644 drivers/net/ethernet/renesas/rswitch.h
 create mode 100644 drivers/phy/renesas/r8a779f0-ether-serdes.c

-- 
2.25.1

