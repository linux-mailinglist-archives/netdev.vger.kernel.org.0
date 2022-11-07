Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150DC61E9ED
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 04:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbiKGD5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 22:57:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbiKGD5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 22:57:17 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07058F035;
        Sun,  6 Nov 2022 19:57:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667793435; x=1699329435;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/VdPwOPXFuQLF7y8PxmNOq84WJKyxPdMjH21bqYW7DE=;
  b=PTMeFX4qhYLFDrcclIHFOOS5zT7r4+WCkw5HLuOGcyjSNhsfdQxzqY+v
   MXDXXJlZRo8t1fyrb7ba97gRgYkndsNVgaAB/PMF6wWMi9VDT3PlWwHao
   TbsBFS0RKRtKnDXPGuD8440mKlmnAibsNu60YI5ctG1ESfoSl40o5xiO7
   +RLNyGaKnQm2w4AEs5iiquR6i2qelF1Rthhwt9YnxkKgOZjQhja7LZ1GC
   A5WOW8g0yTHmuwD1TIU8TBDFZESfcCRb5YScVUVXJxCQ6tVzSYBgmkaEk
   Vii0eVCrnpZEjBZkPbxDt000AURukU0IvWbjjmrHKJ6FRkDUa8cKqZjGH
   A==;
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="187856335"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Nov 2022 20:57:15 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 6 Nov 2022 20:57:13 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sun, 6 Nov 2022 20:57:10 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
Subject: [PATCH net-next v2 0/5] net: dsa: microchip: ksz_pwrite status check for lan937x and irq and error checking updates for ksz series
Date:   Mon, 7 Nov 2022 14:59:17 +0530
Message-ID: <20221107092922.5926-1-rakesh.sankaranarayanan@microchip.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series include following changes, 
- Add KSZ9563 inside ksz_switch_chips. As per current structure,
KSZ9893 is reused inside ksz_switch_chips structure, but since
there is a mismatch in number of irq's, new member added for KSZ9563
and sku detected based on Global Chip ID 4 Register. Compatible
string from device tree mapped to KSZ9563 for spi and i2c mode
probes.
- Assign device interrupt during i2c probe operation.
- Add error checking for ksz_pwrite inside lan937x_change_mtu. After v6.0,
ksz_pwrite updated to have return type int instead of void, and
lan937x_change_mtu still uses ksz_pwrite without status verification.
- Add port_nirq as 3 for KSZ8563 switch family.
- Use dev_err_probe() instead of dev_err() to have more standardized error
formatting and logging.

v1 -> v2:
- Removed regmap validation patch from the series, planning to take
  up in future after checking for any better approach and studying
  the actual need for this change.
- Resolved error reported in ksz8863_smi.c file.

Rakesh Sankaranarayanan (5):
  net: dsa: microchip: add ksz9563 in ksz_switch_ops and select based on
    compatible string
  net: dsa: microchip: add irq in i2c probe
  net: dsa: microchip: add error checking for ksz_pwrite
  net: dsa: microchip: ksz8563: Add number of port irq
  net: dsa: microchip: add dev_err_probe in probe functions

 drivers/net/dsa/microchip/ksz8863_smi.c  |  9 +++----
 drivers/net/dsa/microchip/ksz9477.c      |  3 ++-
 drivers/net/dsa/microchip/ksz9477_i2c.c  | 12 ++++-----
 drivers/net/dsa/microchip/ksz_common.c   | 34 ++++++++++++++++++++++--
 drivers/net/dsa/microchip/ksz_common.h   |  3 +++
 drivers/net/dsa/microchip/ksz_spi.c      | 10 +++----
 drivers/net/dsa/microchip/lan937x_main.c |  6 ++++-
 7 files changed, 56 insertions(+), 21 deletions(-)

-- 
2.34.1

