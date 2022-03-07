Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB37C4CFC1A
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 11:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237199AbiCGK7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 05:59:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241614AbiCGK5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 05:57:41 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54FCB1884;
        Mon,  7 Mar 2022 02:18:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646648290; x=1678184290;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/x9Os74ZVsNOOG2tcGaGL4zfGaT3I0GD1gck2+BW7HA=;
  b=NRt6i/6UBGMz/TfyB+WqJB6koQ/olf1FT7TYNCAWDVRPBFsuMdU8iDK4
   yJJhQEVGakkgtoEwetCa79wu5XEdMQhC3r3UoaR7CIpSThUl9MPGEwbKv
   W4rQFTuYLDJD5hKVNrJVs7RJU/cP20oV5PIqXJNHaHTP2epfxnOyHmfPM
   pOVn0herg6KRI0j55X9lAt0VUOTQp3OlPWKl33WNLYI9vJYfd5fFVJvas
   vf3QWVE14lzAmTBNcHsyV8Tjum22ouK0nBXOQu6/ZwkuX1OBxxiU6f8Yu
   IRuTfOVptpEgE7lxNvRpHRHG0+S0RzInV07xif2y4K7SqG/cJkQ/l3VP8
   A==;
X-IronPort-AV: E=Sophos;i="5.90,161,1643698800"; 
   d="scan'208";a="164755252"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Mar 2022 03:18:10 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 7 Mar 2022 03:18:10 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 7 Mar 2022 03:18:04 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        <UNGLinuxDriver@microchip.com>
Subject: [RFC PATCH net-next 0/2] net: phy: lan87xx: use genphy_read_master_slave function
Date:   Mon, 7 Mar 2022 15:47:41 +0530
Message-ID: <20220307101743.8567-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LAN87xx T1 Phy has the same register field as gigabit phy for reading the
master slave configuration. But the genphy_read_master_slave function has a
check of gigabit phy. So refactored the function in such a way, moved the speed
check to the genphy_read_status function. Analyzed the nxp-tja11xx function for
refactoring, but the register for configuring master/slave is nxp specific
which is not extended phy register.
And analyzed the reusing genphy_setup_master_slave, but for LAN87xx
MASTER_ENABLE is always 1 and Preferred state is always 0. So, I didn't try to
change it.

Arun Ramadoss (2):
  net: phy: exported the genphy_read_master_slave function
  net: phy: lan87xx: use genphy_read_master_slave in read_status

 drivers/net/phy/microchip_t1.c | 30 +-----------------------------
 drivers/net/phy/phy_device.c   | 20 ++++++++++----------
 include/linux/phy.h            |  1 +
 3 files changed, 12 insertions(+), 39 deletions(-)


base-commit: 669b258a793db9f1c3bff29ce2bbd61b810503ad
-- 
2.33.0

