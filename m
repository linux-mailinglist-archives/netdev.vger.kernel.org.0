Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4577529E5A
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 11:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245237AbiEQJow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 05:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbiEQJoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 05:44:34 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C639F47AE2;
        Tue, 17 May 2022 02:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1652780639; x=1684316639;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yxwu1RG/SJB6geBmDmU/Fy5j+HhC1vUjbaAaw1C400I=;
  b=yfKOD+XgqXzY07xoIslZT86DJzzEg66I7RNtjsIERmE+3LooUneCGiGi
   3qcLNafq95sFc0+KhLtS1JshDpTO8Ku4bNVHu8UA+VAvfoqSRUf7GQGqH
   wS2OH/KHWHxcLwHwXwPlj5kQSZRl/ckvyZzU1zZ/c3vh18aE/Nl0nXXTQ
   aHgQvbLq8XeQSzrCBwEOw+A0WJWM9VxarJl01P7twCUJRIVzri9Y+M1l0
   lhUQlLBwCzXDiYXnjGCy+TJSLTAuJdiTd+xsyimGLzE/E3mD84WaRgTJ0
   ugSTAJpbvm4iBN02T4gPx8cyBV0XV89OTeS7+CTSpEi52H77p2Rll+aKD
   w==;
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="156360855"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 May 2022 02:43:57 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 17 May 2022 02:43:57 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 17 May 2022 02:43:51 -0700
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
Subject: [Patch net-next 0/9] net: dsa: microchip: refactor the ksz switch init function
Date:   Tue, 17 May 2022 15:13:24 +0530
Message-ID: <20220517094333.27225-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Changes in Patch v1
- Added the macros for the chip id
- Updated the ksz8863_smi of_device_id data
- Moved the patch 4 port allocation after the patch on mib_names to ksz_common

Changes in RFC v2
- Fixed the compilation issue

Arun Ramadoss (8):
  net: dsa: microchip: ksz8795: update the port_cnt value in
    ksz_chip_data
  net: dsa: microchip: move ksz_chip_data to ksz_common
  net: dsa: microchip: perform the compatibility check for dev probed
  net: dsa: microchip: move struct mib_names to ksz_chip_data
  net: dsa: microchip: move port memory allocation to ksz_common
  net: dsa: microchip: move get_strings to ksz_common
  net: dsa: microchip: add the phylink get_caps
  net: dsa: microchip: remove unused members in ksz_device

Prasanna Vengateshan (1):
  net: dsa: move mib->cnt_ptr reset code to ksz_common.c

 drivers/net/dsa/microchip/ksz8795.c     | 252 +-----------
 drivers/net/dsa/microchip/ksz8795_spi.c |  35 +-
 drivers/net/dsa/microchip/ksz8863_smi.c |  10 +-
 drivers/net/dsa/microchip/ksz9477.c     | 200 ++--------
 drivers/net/dsa/microchip/ksz9477_i2c.c |  30 +-
 drivers/net/dsa/microchip/ksz9477_spi.c |  30 +-
 drivers/net/dsa/microchip/ksz_common.c  | 485 +++++++++++++++++++++++-
 drivers/net/dsa/microchip/ksz_common.h  |  79 +++-
 8 files changed, 664 insertions(+), 457 deletions(-)


base-commit: 6251264fedde83ade6f0f1f7049037469dd4de0b
-- 
2.33.0

