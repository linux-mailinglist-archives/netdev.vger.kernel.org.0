Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39A1E5230CE
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 12:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235205AbiEKKj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 06:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239173AbiEKKiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 06:38:50 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83A398594;
        Wed, 11 May 2022 03:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1652265501; x=1683801501;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=eJcORp5K8rg50jt7c2WyWJJ6ztxAxXlwjFtxo7BVTco=;
  b=CuUY3NFXAPEKuKDxUZs4DB93HtYc32Sabv5CJFIP1RKxzbV8eul5iKRe
   rQ7JtxWyOjf1hfwaYByIESYWvbVv8Hks2gueDrPzjim5r2+ShMNsIFmMv
   9f3XSxVjqjAkSA+TTTk9QJsKNVXCIZ3buq/gWJoP3bPrv9aZdt379q4ed
   niXAW/ZfGWW9U8Aj2zTwg5zVbssX3UvoqwktaeTpLTJYJkTWWhOEt7N7O
   I9RLPcn3SEeSrbl36q+BlJwf0xsRzQIixP91Dd8ge2iApCxzgCr73hHii
   DyKhzYmW7KbWMeZZec4JDtXrOcQ8rynoBAIw+BIkR2rBUbHsqv7D6Wb3+
   g==;
X-IronPort-AV: E=Sophos;i="5.91,216,1647327600"; 
   d="scan'208";a="155586461"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 May 2022 03:38:19 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 11 May 2022 03:38:19 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 11 May 2022 03:38:13 -0700
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
        Eric Dumazet <edumazet@google.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Marek Vasut <marex@denx.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [RFC Patch net-next 0/9] net: dsa: microchip: refactor the ksz switch init function
Date:   Wed, 11 May 2022 16:07:46 +0530
Message-ID: <20220511103755.12553-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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

Arun Ramadoss (8):
  net: dsa: microchip: ksz8795: update the port_cnt value in
    ksz_chip_data
  net: dsa: microchip: move ksz_chip_data to ksz_common
  net: dsa: microchip: perform the compatibility check for dev probed
  net: dsa: microchip: move port memory allocation to ksz_common
  net: dsa: microchip: move struct mib_names to ksz_chip_data
  net: dsa: microchip: move get_strings to ksz_common
  net: dsa: microchip: remove unused members in ksz_device
  net: dsa: microchip: add the phylink get_caps

Prasanna Vengateshan (1):
  net: dsa: move mib->cnt_ptr reset code to ksz_common.c

 drivers/net/dsa/microchip/ksz8795.c     | 251 +-----------
 drivers/net/dsa/microchip/ksz8795_spi.c |  37 +-
 drivers/net/dsa/microchip/ksz9477.c     | 200 ++--------
 drivers/net/dsa/microchip/ksz9477_i2c.c |  30 +-
 drivers/net/dsa/microchip/ksz9477_spi.c |  30 +-
 drivers/net/dsa/microchip/ksz_common.c  | 484 +++++++++++++++++++++++-
 drivers/net/dsa/microchip/ksz_common.h  |  62 ++-
 7 files changed, 641 insertions(+), 453 deletions(-)


base-commit: c908565eecf2d310edddaecea6166015abe9df08
-- 
2.33.0

