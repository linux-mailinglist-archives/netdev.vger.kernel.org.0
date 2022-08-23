Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F035E59D312
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 10:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240998AbiHWIDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 04:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241566AbiHWIC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 04:02:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11A2659C7
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 01:02:57 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oQOrt-0002vf-Oc; Tue, 23 Aug 2022 10:02:38 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oQOrr-001Sv1-5S; Tue, 23 Aug 2022 10:02:35 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oQOrp-00ALXd-07; Tue, 23 Aug 2022 10:02:33 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v3 00/17] net: dsa: microchip: add error handling and register access validation
Date:   Tue, 23 Aug 2022 10:02:14 +0200
Message-Id: <20220823080231.2466017-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

changes v3:
- fix build error in the middle of the patch stack.

changes v2:
- add regmap_ranges for KSZ9477
- drop output clock devicetree in driver validation patches. DTs need
  some more refactoring and can be done in a separate patch set.
- remove some unused variables.

This patch series adds error handling for the PHY read/write path and optional
register access validation.
After adding regmap_ranges for KSZ8563 some bugs was detected, so
critical bug fixes are sorted before ragmap_range patch.

Potentially this bug fixes can be ported to stable kernels, but need to be
reworked.

Oleksij Rempel (17):
  net: dsa: microchip: add separate struct ksz_chip_data for KSZ8563
    chip
  net: dsa: microchip: do per-port Gbit detection instead of per-chip
  net: dsa: microchip: don't announce extended register support on non
    Gbit chips
  net: dsa: microchip: allow to pass return values for PHY read/write
    accesses
  net: dsa: microchip: forward error value on all ksz_pread/ksz_pwrite
    functions
  net: dsa: microchip: ksz9477: add error handling to ksz9477_r/w_phy
  net: dsa: microchip: ksz8795: add error handling to ksz8_r/w_phy
  net: dsa: microchip: KSZ9893: do not write to not supported Output
    Clock Control Register
  net: dsa: microchip: add support for regmap_access_tables
  net: dsa: microchip: add regmap_range for KSZ8563 chip
  net: dsa: microchip: ksz9477: remove MII_CTRL1000 check from
    ksz9477_w_phy()
  net: dsa: microchip: add regmap_range for KSZ9477 chip
  net: dsa: microchip: ksz9477: use internal_phy instead of phy_port_cnt
  net: dsa: microchip: remove unused port phy variable
  net: dsa: microchip: ksz9477: remove unused "on" variable
  net: dsa: microchip: remove unused sgmii variable
  net: dsa: microchip: remove IS_9893 flag

 drivers/net/dsa/microchip/ksz8.h         |   4 +-
 drivers/net/dsa/microchip/ksz8795.c      | 111 ++++--
 drivers/net/dsa/microchip/ksz9477.c      |  86 ++---
 drivers/net/dsa/microchip/ksz9477.h      |   4 +-
 drivers/net/dsa/microchip/ksz_common.c   | 450 ++++++++++++++++++++++-
 drivers/net/dsa/microchip/ksz_common.h   |  90 +++--
 drivers/net/dsa/microchip/ksz_spi.c      |   5 +-
 drivers/net/dsa/microchip/lan937x.h      |   4 +-
 drivers/net/dsa/microchip/lan937x_main.c |   8 +-
 9 files changed, 646 insertions(+), 116 deletions(-)

-- 
2.30.2

