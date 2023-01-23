Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8283B678575
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 19:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbjAWS46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 13:56:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232411AbjAWS41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 13:56:27 -0500
Received: from michel.telenet-ops.be (michel.telenet-ops.be [IPv6:2a02:1800:110:4::f00:18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273DB32E58
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 10:56:23 -0800 (PST)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed50:6083:1fd7:ba05:ea8d])
        by michel.telenet-ops.be with bizsmtp
        id CJwJ2900B4604Ck06JwJ2l; Mon, 23 Jan 2023 19:56:21 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtp (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1pK1zG-0076K6-G3;
        Mon, 23 Jan 2023 19:56:18 +0100
Received: from geert by rox.of.borg with local (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1pK1zO-00Ekh0-C1;
        Mon, 23 Jan 2023 19:56:18 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Ulrich Hecht <uli+renesas@fpond.eu>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 00/12] can: rcar_canfd: Add support for R-Car V4H systems
Date:   Mon, 23 Jan 2023 19:56:02 +0100
Message-Id: <cover.1674499048.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	Hi all,

This patch series adds support for the CAN-FD interface on the Renesas
R-Car V4H (R8A779G0) SoC and support for CAN transceivers described as
PHYs to the R-Car CAN-FD driver.  It includes several fixes for issues
(some minor) detected while adding the support and during testing.
More details can be found in the individual patches.

Note that the last patch depends on "[PATCH 1/7] phy: Add
devm_of_phy_optional_get() helper"[1].

This has been tested on the Renesas White-Hawk development board using
cansend, candump, and canfdtest:
  - Channel 0 uses an NXP TJR1443AT CAN transceiver, and works fine,
  - Channels 1-7 use Microchip MCP2558FD-H/SN CAN transceivers (not
    mounted for channels 4-7), which do not need explicit description.
    While channel 1 works fine, channels 2-3 do not seem to work.

Hence despite the new fixes, the test results are similar to what Ulrich
Hecht reported for R-Car V3U on the Falcon development board before,
i.e. only channels 0 and 1 work (FTR, [2] does not help).
Whether this is a CAN-FD driver issue, a pin control issue, an IP core
issue, or an SoC integration issue is still to be seen...


Thanks for your comments!

[1] https://lore.kernel.org/all/f53a1bcca637ceeafb04ce3540a605532d3bc34a.1674036164.git.geert+renesas@glider.be
[2] commit e3e5bccc92446048 ("can: rcar_canfd:
    rcar_canfd_configure_afl_rules(): Fix Rx FIFO entry setting") in
    renesas-bsp/v5.10.147/rcar-5.2.0.rc3.

Geert Uytterhoeven (12):
  dt-bindings: can: renesas,rcar-canfd: R-Car V3U is R-Car Gen4
  dt-bindings: can: renesas,rcar-canfd: Document R-Car V4H support
  dt-bindings: can: renesas,rcar-canfd: Add transceiver support
  can: rcar_canfd: Fix R-Car V3U CAN mode selection
  can: rcar_canfd: Fix R-Car V3U GAFLCFG field accesses
  can: rcar_canfd: Abstract out DCFG address differences
  can: rcar_canfd: Add support for R-Car Gen4
  can: rcar_canfd: Fix R-Car Gen4 DCFG.DSJW field width
  can: rcar_canfd: Fix R-Car Gen4 CFCC.CFTML field width
  can: rcar_canfd: Sort included header files
  can: rcar_canfd: Add helper variable dev
  can: rcar_canfd: Add transceiver support

 .../bindings/net/can/renesas,rcar-canfd.yaml  |  16 +-
 drivers/net/can/rcar/rcar_canfd.c             | 255 ++++++++++--------
 2 files changed, 148 insertions(+), 123 deletions(-)

-- 
2.34.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
