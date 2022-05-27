Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9DF5359C3
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 09:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344806AbiE0HFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 03:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239584AbiE0HFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 03:05:32 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA18E2777;
        Fri, 27 May 2022 00:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1653635127; x=1685171127;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UvMpghii5UOJUtFGUhwLAlb6IkBq4PX0+OgGfu4XxpE=;
  b=toz3dqgcLFZSnpVBxS5sP6OvqL9PLo8zatbbyhpZHqNxVKAcTEwA/t9s
   KJMuf+nx8EKwJVvvMhgyQDGnhU0Ea6LnonFqM7UHLb5JGKmmz8ZsXwssR
   Kbke8G5VeVK7kW9MiOOgT+ajtq2cTcBkHb3KJZOGvxCneQqBXdC/OIash
   MpXrUBmZC3upCrMH0S3rCu9t7vGBxreQ8JOl5pDVQOG8w3aMUJrJaA2ZO
   qSMHI+wfdMWlRyiM647PDVwvBDPIl8uUJUNhqO5Ri3nGzxxJKIcyLq3r9
   7Mr09IGsLr4PApedBuK0PHzPdpegRudrlUz7ttvsrlPQf5jIo829Jao5N
   g==;
X-IronPort-AV: E=Sophos;i="5.91,254,1647327600"; 
   d="scan'208";a="165953276"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 May 2022 00:05:25 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 27 May 2022 00:05:25 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 27 May 2022 00:05:20 -0700
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
Subject: [RFC Patch net-next 00/17] net: dsa: microchip: common spi probe for the ksz series switches
Date:   Fri, 27 May 2022 12:33:41 +0530
Message-ID: <20220527070358.25490-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series aims to refactor the ksz_switch_register routine to have the
common flow for the ksz series switch. At present ksz8795.c & ksz9477.c have
its own dsa_switch_ops and switch detect functionality.
In ksz_switch_register, ksz_dev_ops is assigned based on the function parameter
passed by the individual ksz8/ksz9477 switch register function. And then switch
detect is performed based on the ksz_dev_ops.detect hook.  This patch modifies
the ksz_switch_register such a way that switch detect is performed first, based
on the chip ksz_dev_ops is assigned to ksz_device structure. It ensures the
common flow for the existing as well as LAN937x switches.
It also replaces the individual dsa_switch_ops structure to common
dsa_switch_ops in the ksz_common.  Based on the ksz_dev_ops hook pointer,
particular functionality for the switches may or may not executed.
Finally replaces the two spi probes such as ksz8795_spi.c and ksz9477_spi.c to
common ksz_spi.c. These switches have different regmap config and it is
differentited using the platform data.

Arun Ramadoss (17):
  net: dsa: microchip: ksz9477: cleanup the ksz9477_switch_detect
  net: dsa: microchip: move switch chip_id detection to ksz_common
  net: dsa: microchip: move tag_protocol to ksz_common
  net: dsa: microchip: ksz9477: use ksz_read_phy16 & ksz_write_phy16
  net: dsa: microchip: move vlan functionality to ksz_common
  net: dsa: microchip: move the port mirror to ksz_common
  net: dsa: microchip: get P_STP_CTRL in ksz_port_stp_state by
    ksz_dev_ops
  net: dsa: microchip: update the ksz_phylink_get_caps
  net: dsa: microchip: update the ksz_port_mdb_add/del
  net: dsa: microchip: update fdb add/del/dump in ksz_common
  net: dsa: microchip: move the setup, get_phy_flags & mtu to ksz_common
  net: dsa: microchip: common dsa_switch_ops for ksz switches
  net: dsa: microchip: ksz9477: separate phylink mode from switch
    register
  net: dsa: microchip: move ksz_dev_ops to ksz_common.c
  net: dsa: microchip: remove the ksz8/ksz9477_switch_register
  net: dsa: microchip: common menuconfig for ksz series switch
  net: dsa: microchip: common ksz_spi_probe for ksz switches

 drivers/net/dsa/microchip/Kconfig             |  42 +-
 drivers/net/dsa/microchip/Makefile            |  10 +-
 drivers/net/dsa/microchip/ksz8.h              |  46 ++
 drivers/net/dsa/microchip/ksz8795.c           | 309 +++++------
 drivers/net/dsa/microchip/ksz8795_reg.h       |  13 -
 drivers/net/dsa/microchip/ksz8863_smi.c       |   2 +-
 drivers/net/dsa/microchip/ksz9477.c           | 225 ++------
 drivers/net/dsa/microchip/ksz9477.h           |  58 ++
 drivers/net/dsa/microchip/ksz9477_i2c.c       |   2 +-
 drivers/net/dsa/microchip/ksz9477_reg.h       |   1 -
 drivers/net/dsa/microchip/ksz9477_spi.c       | 150 -----
 drivers/net/dsa/microchip/ksz_common.c        | 521 +++++++++++++-----
 drivers/net/dsa/microchip/ksz_common.h        |  91 +--
 .../microchip/{ksz8795_spi.c => ksz_spi.c}    |  85 ++-
 14 files changed, 821 insertions(+), 734 deletions(-)
 create mode 100644 drivers/net/dsa/microchip/ksz9477.h
 delete mode 100644 drivers/net/dsa/microchip/ksz9477_spi.c
 rename drivers/net/dsa/microchip/{ksz8795_spi.c => ksz_spi.c} (61%)


base-commit: 7e062cda7d90543ac8c7700fc7c5527d0c0f22ad
-- 
2.36.1

