Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7942F615B4F
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 05:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiKBEOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 00:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiKBEOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 00:14:21 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B309E2316F;
        Tue,  1 Nov 2022 21:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667362460; x=1698898460;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=08W5rKKIlMXbts2FT16e7Bj9/VESAyQ7decV9eV/k4A=;
  b=NGdzOck6yCcD/I1pnC4CkAF2uumlx8j9jkMfS09/rlvK2sxCaNel3bYe
   l9otSYq1rrTgE62ADAZyiZHohcqkcyEHX8cOJzKmngiwI1+m4roUEsYkD
   qoYEF5LYUZhyQOPD0PC/CHoliFsNo9zIE/moritUtJv7fZjIp/hOUBk5P
   2V1XNFPX1A4cfQqbL0eSXLoZtcrLnYwjCLAXEnQTijngXFFp/dRV2wmE/
   ormcyuaDz4VaYupUHDvdi8luBnP+RQ9OyiUFj9OGZU35zfJMUH0D4Dkfc
   tzq1Vgn+Q0n8t+3kk8qfnR+l3dp3Z/IaSxp5EhTfJqOMn85UIaCE35GIS
   A==;
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="184948846"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Nov 2022 21:14:17 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 1 Nov 2022 21:14:17 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 1 Nov 2022 21:14:13 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
Subject: [PATCH net-next 0/6] net: dsa: microchip: regmap range validation and ksz_pwrite status check for lan937x and irq and error checking updates for ksz series
Date:   Wed, 2 Nov 2022 09:40:52 +0530
Message-ID: <20221102041058.128779-1-rakesh.sankaranarayanan@microchip.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series include following changes, 
- add regmap range validation support for lan937x series switches, 
which will help to avoid access to unused register addresses.
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

Rakesh Sankaranarayanan (6):
  net: dsa: microchip: lan937x: add regmap range validation
  net: dsa: microchip: add ksz9563 in ksz_switch_ops and select based on
    compatible string
  net: dsa: microchip: add irq in i2c probe
  net: dsa: microchip: add error checking for ksz_pwrite
  net: dsa: microchip: ksz8563: Add number of port irq
  net: dsa: microchip: add dev_err_probe in probe functions

 drivers/net/dsa/microchip/ksz8863_smi.c  |    9 +-
 drivers/net/dsa/microchip/ksz9477.c      |    3 +-
 drivers/net/dsa/microchip/ksz9477_i2c.c  |   12 +-
 drivers/net/dsa/microchip/ksz_common.c   | 1794 +++++++++++++++++++++-
 drivers/net/dsa/microchip/ksz_common.h   |    3 +
 drivers/net/dsa/microchip/ksz_spi.c      |   10 +-
 drivers/net/dsa/microchip/lan937x_main.c |    6 +-
 7 files changed, 1816 insertions(+), 21 deletions(-)

-- 
2.34.1

