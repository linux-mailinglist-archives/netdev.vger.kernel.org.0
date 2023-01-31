Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC186827B9
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 09:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjAaIzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 03:55:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232176AbjAaIyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 03:54:15 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECAB49437
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 00:49:48 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pMmHw-0003xI-6v; Tue, 31 Jan 2023 09:46:48 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pMmHw-001eMX-91; Tue, 31 Jan 2023 09:46:47 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pMmHq-002yYt-VV; Tue, 31 Jan 2023 09:46:42 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Abel Vesa <abelvesa@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v3 00/19] ARM: imx: make Ethernet refclock configurable
Date:   Tue, 31 Jan 2023 09:46:23 +0100
Message-Id: <20230131084642.709385-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

changes v3:
- add Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
- rebase on top of abelvesa/for-next

changes v2:
- remove "ARM: imx6q: use of_clk_get_by_name() instead of_clk_get() to
  get ptp clock" patch
- fix build warnings
- add "Acked-by: Lee Jones <lee@kernel.org>"
- reword some commits as suggested by Fabio

Most of i.MX SoC variants have configurable FEC/Ethernet reference
lock
used by RMII specification. This functionality is located in the
general purpose registers (GRPx) and till now was not implemented as
part of SoC clock tree.

With this patch set, we move forward and add this missing functionality
to some of i.MX clk drivers. So, we will be able to configure clock
opology
by using devicetree and be able to troubleshoot clock dependencies
by using clk_summary etc.

Currently implemented and tested i.MX6Q, i.MX6DL and i.MX6UL variants.


Oleksij Rempel (19):
  clk: imx: add clk-gpr-mux driver
  clk: imx6q: add ethernet refclock mux support
  ARM: imx6q: skip ethernet refclock reconfiguration if enet_clk_ref is
    present
  ARM: dts: imx6qdl: use enet_clk_ref instead of enet_out for the FEC
    node
  ARM: dts: imx6dl-lanmcu: configure ethernet reference clock parent
  ARM: dts: imx6dl-alti6p: configure ethernet reference clock parent
  ARM: dts: imx6dl-plybas: configure ethernet reference clock parent
  ARM: dts: imx6dl-plym2m: configure ethernet reference clock parent
  ARM: dts: imx6dl-prtmvt: configure ethernet reference clock parent
  ARM: dts: imx6dl-victgo: configure ethernet reference clock parent
  ARM: dts: imx6q-prtwd2: configure ethernet reference clock parent
  ARM: dts: imx6qdl-skov-cpu: configure ethernet reference clock parent
  ARM: dts: imx6dl-eckelmann-ci4x10: configure ethernet reference clock
    parent
  clk: imx: add imx_obtain_fixed_of_clock()
  clk: imx6ul: fix enet1 gate configuration
  clk: imx6ul: add ethernet refclock mux support
  ARM: dts: imx6ul: set enet_clk_ref to CLK_ENETx_REF_SEL
  ARM: mach-imx: imx6ul: remove not optional ethernet refclock overwrite
  ARM: dts: imx6ul-prti6g: configure ethernet reference clock parent

 arch/arm/boot/dts/imx6dl-alti6p.dts           |  12 +-
 arch/arm/boot/dts/imx6dl-eckelmann-ci4x10.dts |  13 +-
 arch/arm/boot/dts/imx6dl-lanmcu.dts           |  12 +-
 arch/arm/boot/dts/imx6dl-plybas.dts           |  12 +-
 arch/arm/boot/dts/imx6dl-plym2m.dts           |  12 +-
 arch/arm/boot/dts/imx6dl-prtmvt.dts           |  11 +-
 arch/arm/boot/dts/imx6dl-victgo.dts           |  12 +-
 arch/arm/boot/dts/imx6q-prtwd2.dts            |  17 ++-
 arch/arm/boot/dts/imx6qdl-skov-cpu.dtsi       |  12 +-
 arch/arm/boot/dts/imx6qdl.dtsi                |   4 +-
 arch/arm/boot/dts/imx6ul-prti6g.dts           |  14 ++-
 arch/arm/boot/dts/imx6ul.dtsi                 |  10 +-
 arch/arm/mach-imx/mach-imx6q.c                |  10 +-
 arch/arm/mach-imx/mach-imx6ul.c               |  20 ---
 drivers/clk/imx/Makefile                      |   1 +
 drivers/clk/imx/clk-gpr-mux.c                 | 119 ++++++++++++++++++
 drivers/clk/imx/clk-imx6q.c                   |  13 ++
 drivers/clk/imx/clk-imx6ul.c                  |  33 ++++-
 drivers/clk/imx/clk.c                         |  14 +++
 drivers/clk/imx/clk.h                         |   8 ++
 include/dt-bindings/clock/imx6qdl-clock.h     |   4 +-
 include/dt-bindings/clock/imx6ul-clock.h      |   7 +-
 include/linux/mfd/syscon/imx6q-iomuxc-gpr.h   |   6 +-
 23 files changed, 296 insertions(+), 80 deletions(-)
 create mode 100644 drivers/clk/imx/clk-gpr-mux.c

-- 
2.30.2

