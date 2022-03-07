Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C832E4D03C9
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 17:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244044AbiCGQQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 11:16:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbiCGQQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 11:16:21 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E66C4199C;
        Mon,  7 Mar 2022 08:15:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646669726; x=1678205726;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1tgZ7PNrCUFybKd/JLjq33KO6voyiECva9usYrk8k+g=;
  b=QSKcwE0aJyUjvrX+Vj6/bHTxMka3rOqUsMXZrVBVBqo9sr0lgIFvli0d
   dcLX89udbqu/VPyyo5qTbEhGD8bjrRzD6C85nBZfPbJPo5DS4DIRsCI7j
   bDynEB1jP54eT1k/hS4Esn19z92x2jZcgMZDKzwuc4Hzn6vWcpCACWSnn
   /H4Yq4+k8R67VoKZrELo5projiKjyJA15wMsIc09Va2hu29pNldGZe18T
   Qo1Tn2asfniSDjnAaNc1N65+z+uTNsOoUPnQgXnTyI+ZuF4vKdzYaOdGx
   q5JIKYiHsRY2+Ed31wcyalglYYiNFoHEy0/OHuQVprRSoWArWACKPOhuO
   g==;
X-IronPort-AV: E=Sophos;i="5.90,162,1643698800"; 
   d="scan'208";a="164796989"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Mar 2022 09:15:26 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 7 Mar 2022 09:15:26 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 7 Mar 2022 09:15:22 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next 0/2] net: phy: lan87xx: use genphy_read_master_slave function
Date:   Mon, 7 Mar 2022 21:45:13 +0530
Message-ID: <20220307161515.14970-1-arun.ramadoss@microchip.com>
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
 drivers/net/phy/phy_device.c   | 19 +++++++++----------
 include/linux/phy.h            |  1 +
 3 files changed, 11 insertions(+), 39 deletions(-)


base-commit: 57d29a2935c9aab0aaef6264bf6a58aad3859e7c
-- 
2.33.0

