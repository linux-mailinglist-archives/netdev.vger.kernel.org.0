Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB5556143D
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 10:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbiF3IHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 04:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbiF3IH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 04:07:29 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A483D41335;
        Thu, 30 Jun 2022 01:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656576447; x=1688112447;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xg8LrUK4CK/f+slaxiW8w/2cvQ2plwdDazQvdSmW29g=;
  b=Fk1YPlw/KnT0KFHj7kUotH+Qh1EHPZxHAuN7EVZzYJoYueFZc2VaJubp
   U8xyH2PcFRQ4GWX5UhTYwtOtXaPq4r9CphS97+xukNyL+OcEWV7kGT+Df
   fmon09Vf9gpFKgXIlvSOm0rjIaH0IzDUp1Wj2XUDp3zDCmwLxeFWhk7VO
   DtlTZEMOhk0Qa8eiD1N7aQermixF9RcpbvcXjR8bgMfur08e5GiAlBKH/
   /wlc4mmkSOXL87r79nPSfn0DH4uy49SMvhmPRyZlD0RloNJFdNYsMCN4m
   IMAM6fPJvH/Ncqn6MQP+oIZ7mOqVBVltEPZKxxIGQkWwDStwhqET8UKsv
   A==;
X-IronPort-AV: E=Sophos;i="5.92,233,1650956400"; 
   d="scan'208";a="102426504"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Jun 2022 01:07:25 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 30 Jun 2022 01:07:25 -0700
Received: from wendy.microchip.com (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 30 Jun 2022 01:07:21 -0700
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        "Nicolas Ferre" <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Daire McNamara" <daire.mcnamara@microchip.com>
CC:     Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, <linux-clk@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-riscv@lists.infradead.org>
Subject: [PATCH v1 00/14] PolarFire SoC reset controller & clock cleanups
Date:   Thu, 30 Jun 2022 09:05:19 +0100
Message-ID: <20220630080532.323731-1-conor.dooley@microchip.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey all,
I know I have not sat on the RFC I sent about the aux. bus parts
for too long, but figured I'd just send the whole thing anyway to all
lists etc.

Kinda two things happening in this series, but I sent it together to
ensure the second part would apply correctly.

The first is the reset controller that I promised after discovering the
issue triggered by CONFIG_PM & the phy not coming up correctly. I have
now removed all the messing with resets from clock enable/disable
functions & now use the aux bus to set up a reset controller driver.
Since I needed something to test it, I hooked up the reset for the
Cadence MACB on PolarFire SoC.

The second part adds rate control for the MSS PLL clock, followed by
some simplifications to the driver & conversions of some custom structs
to the corresponding structs in the framework.

Thanks,
Conor.

FYI, there'll be maintainers conflicts with an obvious resolution in
-next, but I cannot rebase on then b/c unrelated changes have broken
boot there at the moment.

Conor Dooley (14):
  dt-bindings: clk: microchip: mpfs: add reset controller support
  dt-bindings: net: cdns,macb: document polarfire soc's macb
  clk: microchip: mpfs: add reset controller
  reset: add polarfire soc reset support
  MAINTAINERS: add polarfire soc reset controller
  net: macb: add polarfire soc reset support
  riscv: dts: microchip: add mpfs specific macb reset support
  clk: microchip: mpfs: add module_authors entries
  clk: microchip: mpfs: add MSS pll's set & round rate
  clk: microchip: mpfs: move id & offset out of clock structs
  clk: microchip: mpfs: simplify control reg access
  clk: microchip: mpfs: delete 2 line mpfs_clk_register_foo()
  clk: microchip: mpfs: convert cfg_clk to clk_divider
  clk: microchip: mpfs: convert periph_clk to clk_gate

 .../bindings/clock/microchip,mpfs.yaml        |  17 +-
 .../devicetree/bindings/net/cdns,macb.yaml    |   1 +
 MAINTAINERS                                   |   1 +
 arch/riscv/boot/dts/microchip/mpfs.dtsi       |   7 +-
 drivers/clk/microchip/Kconfig                 |   1 +
 drivers/clk/microchip/clk-mpfs.c              | 377 +++++++++---------
 drivers/net/ethernet/cadence/macb_main.c      |  25 +-
 drivers/reset/Kconfig                         |   9 +
 drivers/reset/Makefile                        |   2 +-
 drivers/reset/reset-mpfs.c                    | 145 +++++++
 include/soc/microchip/mpfs.h                  |   8 +
 11 files changed, 393 insertions(+), 200 deletions(-)
 create mode 100644 drivers/reset/reset-mpfs.c


base-commit: b13baccc3850ca8b8cccbf8ed9912dbaa0fdf7f3
-- 
2.36.1

