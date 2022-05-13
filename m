Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2D31525FC1
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 12:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379360AbiEMKWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 06:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344326AbiEMKWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 06:22:38 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469E13BA76;
        Fri, 13 May 2022 03:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1652437357; x=1683973357;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1Jzj+aQ33go3hSLqDabpCzxtCzXLj+yMhrRH8wus34o=;
  b=CxiD39g7Xu64BxUQmriuw6+99GqGuk/fc5cvV2LsiZPmIpmw0rGuKUls
   s9LTphQzD7WdXUO0Z0YOucD6zbjR2LomPRX5w2fQ1Fk2hp4MNLYIgYr/w
   NctVVY/mNqOCVJOoU0Br1Q4NEH3Ogv6zCR6Jh/ElTK0saoLyVEOtPuFVO
   h8JsVXRF8Z9itFJR/LgN+V12dx6StzW/aLN4bXGLXln3E7qlPpBewDibY
   PtRzIZUAgBC9SIMB9Z6u4LtKuxsiL8lyRS6teuhy3obUCohlXGTDP312d
   8VZs7//wFpW27S6WbTXoEkKoAtDYKIuFvCdYHAp7ys20Errn5C6bkyokC
   g==;
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="163926052"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 May 2022 03:22:36 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 13 May 2022 03:22:36 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 13 May 2022 03:22:31 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Russell King <linux@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Marek Vasut <marex@denx.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>
Subject: [RFC Patch net-next v2 0/9] net: dsa: microchip: refactor the ksz switch init function
Date:   Fri, 13 May 2022 15:52:10 +0530
Message-ID: <20220513102219.30399-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
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

During the ksz_switch_register function, it calls the individual switches init
functions (ksz8795.c and ksz9477.c). Both these functions have few things in
common like, copying the chip specific data to struct ksz_dev, allocating
ksz_port memory and mib_names memory & cnt. And to add the new LAN937x series
switch, these allocations has to be replicated.
Based on the review feedback of LAN937x part support patch, refactored the
switch init function to move allocations to switch register.

Link:https://patchwork.kernel.org/project/netdevbpf/patch/20220504151755.11737-8-arun.ramadoss@microchip.com/

Changes in RFC v2
- Fixed the compilation issue

Arun Ramadoss (8):
  net: dsa: microchip: ksz8795: update the port_cnt value in
    ksz_chip_data
  net: dsa: microchip: move ksz_chip_data to ksz_common
  net: dsa: microchip: perform the compatibility check for dev probed
  net: dsa: microchip: move port memory allocation to ksz_common
  net: dsa: microchip: move struct mib_names to ksz_chip_data
  net: dsa: microchip: move get_strings to ksz_common
  net: dsa: microchip: add the phylink get_caps
  net: dsa: microchip: remove unused members in ksz_device

Prasanna Vengateshan (1):
  net: dsa: move mib->cnt_ptr reset code to ksz_common.c

 drivers/net/dsa/microchip/ksz8795.c     | 252 +-----------
 drivers/net/dsa/microchip/ksz8795_spi.c |  37 +-
 drivers/net/dsa/microchip/ksz9477.c     | 200 ++--------
 drivers/net/dsa/microchip/ksz9477_i2c.c |  30 +-
 drivers/net/dsa/microchip/ksz9477_spi.c |  30 +-
 drivers/net/dsa/microchip/ksz_common.c  | 485 +++++++++++++++++++++++-
 drivers/net/dsa/microchip/ksz_common.h  |  63 ++-
 7 files changed, 642 insertions(+), 455 deletions(-)

-- 
2.33.0

