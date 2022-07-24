Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5461657F45E
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 11:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbiGXJ2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 05:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbiGXJ2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 05:28:48 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D9B14037;
        Sun, 24 Jul 2022 02:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1658654926; x=1690190926;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=t7ZE0FC8tCkKrFMZykyQb3aNE67a/iby4CnvmhR6I3Y=;
  b=nCReLHBKYLU8wsLNYRcPm8YgEmNkQQUXzRsd5D/Y12gRIgmK2ynOsPtn
   lO7+foKUo8DY2SrQVDFO8jVVjwUB/ugwqnUGpy9tDbhCmyMvYyJFrjkyo
   MgD65WHB7OqIsoGbGNmA+vzPVS8wXqL4L0RSwgb42Hn0FtbJvYer7ZaEz
   BIYXJoxo2UeSYiYZWWWt0RiGJOi6oGu4j99uuKwKDgSH0dyhoxe1JvXqL
   boDnoIuV3QFc8NsPa72hY9Mu7/oAacEvHKjKwS9TOAxt25gH2+LcuzEoB
   z8rq4M2FT09Dyun3oJxBeK/L1+EpgRVL0L4La1l637ufavQPCrrut6Sm8
   w==;
X-IronPort-AV: E=Sophos;i="5.93,190,1654585200"; 
   d="scan'208";a="173571567"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jul 2022 02:28:46 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sun, 24 Jul 2022 02:28:44 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.28 via Frontend Transport; Sun, 24 Jul 2022 02:28:31 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King" <linux@armlinux.org.uk>
Subject: [Patch net-next v2 0/9] net: dsa: microchip: add support for phylink mac config and link up
Date:   Sun, 24 Jul 2022 14:58:14 +0530
Message-ID: <20220724092823.24567-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series add support common phylink mac config and link up for the ksz
series switches. At present, ksz8795 and ksz9477 doesn't implement the phylink
mac config and link up. It configures the mac interface in the port setup hook.
ksz8830 series switch does not mac link configuration. For lan937x switches, in
the part support patch series has support only for MII and RMII configuration.
Some group of switches have some register address and bit fields common and
others are different. So, this patch aims to have common phylink implementation
which configures the register based on the chip id.

Changes in v2
- combined the modification of duplex, tx_pause and rx_pause into single
  function.

Changes in v1
- Squash the reading rgmii value from dt to patch which apply the rgmii value
- Created the new function ksz_port_set_xmii_speed
- Seperated the namespace values for xmii_ctrl_0 and xmii_ctrl_1 register
- Applied the rgmii delay value based on the rx/tx-internal-delay-ps

Arun Ramadoss (9):
  net: dsa: microchip: add common gigabit set and get function
  net: dsa: microchip: add common ksz port xmii speed selection function
  net: dsa: microchip: add common duplex and flow control function
  net: dsa: microchip: add support for common phylink mac link up
  net: dsa: microchip: lan937x: add support for configuing xMII register
  net: dsa: microchip: apply rgmii tx and rx delay in phylink mac config
  net: dsa: microchip: ksz9477: use common xmii function
  net: dsa: microchip: ksz8795: use common xmii function
  net: dsa: microchip: add support for phylink mac config

 drivers/net/dsa/microchip/ksz8795.c      |  40 ---
 drivers/net/dsa/microchip/ksz8795_reg.h  |   8 -
 drivers/net/dsa/microchip/ksz9477.c      | 183 +------------
 drivers/net/dsa/microchip/ksz9477_reg.h  |  24 --
 drivers/net/dsa/microchip/ksz_common.c   | 312 ++++++++++++++++++++++-
 drivers/net/dsa/microchip/ksz_common.h   |  54 ++++
 drivers/net/dsa/microchip/lan937x.h      |   8 +-
 drivers/net/dsa/microchip/lan937x_main.c | 125 +++------
 drivers/net/dsa/microchip/lan937x_reg.h  |  32 ++-
 9 files changed, 431 insertions(+), 355 deletions(-)


base-commit: 502c6f8cedcce7889ccdefeb88ce36b39acd522f
-- 
2.36.1

