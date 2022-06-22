Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5597155489D
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357092AbiFVJGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 05:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356423AbiFVJGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 05:06:17 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636C2275D2;
        Wed, 22 Jun 2022 02:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655888769; x=1687424769;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cl43ewztgiqfA8qjSqqVU9/tRzcxq1NocInwS9WEa9M=;
  b=TBAf5Dw2Vla9XCCQZ2Y71NZxzrrX5rtnotF1AUk2f/0Iu0zy0YIvMRFy
   V259Dx43I+KWtfLq51Vp5TenPi9ZlUkxSV2jqLLlAvZ6CigR2UtZ8hP/C
   DFkeWF86LbI/KJpywAOuHvDjuv2qxNkTtZIOZfiJmxS21IcWRpFoPMeay
   SkhEAuLiIEe2JTHuFMpWz0YaAFXphxz/MYxCPDyQ8NSdX7XOHgLoNBVHw
   ssob1IkPFAhjeuwF6vTOutS0BdvW041Dfab+DpA1js94vZqYwQ4rnJNbu
   pbBE093XuUE9RpWpslIrRFLS6loiyleQX8+NflzbDxyuEYnUuKiBH7Vom
   w==;
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="179016996"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jun 2022 02:06:08 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 22 Jun 2022 02:06:08 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 22 Jun 2022 02:06:03 -0700
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
Subject: [Patch net-next 00/13] net: dsa: microchip: common spi probe for the ksz series switches - part 2
Date:   Wed, 22 Jun 2022 14:34:12 +0530
Message-ID: <20220622090425.17709-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series aims to refactor the ksz_switch_register routine to have the
common flow for the ksz series switch. And this is the follow up patch series.

First, it tries moves the common implementation in the setup from individual
files to ksz_setup. Then implements the common dsa_switch_ops structure instead
of independent registration. And then moves the ksz_dev_ops to ksz_common.c,
it allows the dynamic detection of which ksz_dev_ops to be used based on
the switch detection function.

Finally, the patch updates the ksz_spi probe function to be same for all the
ksz_switches.

Arun Ramadoss (13):
  net: dsa: microchip: rename shutdown to reset in ksz_dev_ops
  net: dsa: microchip: add config_cpu_port to struct ksz_dev_ops
  net: dsa: microchip: add the enable_stp_addr pointer in ksz_dev_ops
  net: dsa: microchip: move setup function to ksz_common
  net: dsa: microchip: move broadcast rate limit to ksz_setup
  net: dsa: microchip: move multicast enable to ksz_setup
  net: dsa: microchip: move start of switch to ksz_setup
  net: dsa: microchip: common dsa_switch_ops for ksz switches
  net: dsa: microchip: ksz9477: separate phylink mode from switch
    register
  net: dsa: microchip: common menuconfig for ksz series switch
  net: dsa: microchip: move ksz_dev_ops to ksz_common.c
  net: dsa: microchip: remove the ksz8/ksz9477_switch_register
  net: dsa: microchip: common ksz_spi_probe for ksz switches

 drivers/net/dsa/microchip/Kconfig             |  42 +--
 drivers/net/dsa/microchip/Makefile            |  10 +-
 drivers/net/dsa/microchip/ksz8.h              |  48 +++
 drivers/net/dsa/microchip/ksz8795.c           | 195 +++--------
 drivers/net/dsa/microchip/ksz8795_reg.h       |  12 -
 drivers/net/dsa/microchip/ksz8863_smi.c       |   2 +-
 drivers/net/dsa/microchip/ksz9477.c           | 244 +++++--------
 drivers/net/dsa/microchip/ksz9477.h           |  60 ++++
 drivers/net/dsa/microchip/ksz9477_i2c.c       |   6 +-
 drivers/net/dsa/microchip/ksz9477_reg.h       |  12 -
 drivers/net/dsa/microchip/ksz9477_spi.c       | 150 --------
 drivers/net/dsa/microchip/ksz_common.c        | 326 +++++++++++++-----
 drivers/net/dsa/microchip/ksz_common.h        |  82 ++---
 .../microchip/{ksz8795_spi.c => ksz_spi.c}    |  89 +++--
 14 files changed, 598 insertions(+), 680 deletions(-)
 create mode 100644 drivers/net/dsa/microchip/ksz9477.h
 delete mode 100644 drivers/net/dsa/microchip/ksz9477_spi.c
 rename drivers/net/dsa/microchip/{ksz8795_spi.c => ksz_spi.c} (60%)


base-commit: 8720bd951b8e8515ffd995c7631790fdabaa9265
-- 
2.36.1

