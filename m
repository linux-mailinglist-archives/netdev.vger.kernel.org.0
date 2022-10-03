Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBB35F2894
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 08:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiJCGbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 02:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiJCGbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 02:31:47 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3863AE71;
        Sun,  2 Oct 2022 23:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1664778706; x=1696314706;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=dJ4Wy6/TZUF4md84ZV3E4CX78cKGFAXzNz4PfLmRgxU=;
  b=BSq9q//sSvNaRFjPVOnpXWya4TTwcaH1cfVl3NlVh7nAmEnZMuBZ+THb
   G2C06lW4i0xfuW+RIGr1Qfg3lzwuWeK4N3XwUOMREghZdZqFTkWZuw4zL
   7FUNTYUPk4FOgenSWoyOcK8QDerRJGebb5UKcRfBu4c1MpxDD9VGuS9SV
   3QTjHd5WJx77ZWDFuGysZGGj/DG4v/nT1Kwdw9xGF4My+t2+FeUDAP5vx
   cq0az7J6bWDi5w1kz2sacjOjEH4xh18lN0+65enLI1HstxcVmpVf5qYOb
   +CzmPYrvg5EutRd5x59oQUCDYSAp0YLwQQQlez+M57A6pmKrpvYfVHPoj
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,364,1654585200"; 
   d="scan'208";a="182935779"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Oct 2022 23:31:45 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 2 Oct 2022 23:31:44 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sun, 2 Oct 2022 23:31:41 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>
Subject: [PATCH net] net: phy: micrel: Fixes FIELD_GET assertion
Date:   Mon, 3 Oct 2022 12:01:30 +0530
Message-ID: <20221003063130.17782-1-Divya.Koppera@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FIELD_GET() must only be used with a mask that is a compile-time
constant. Mark the functions as __always_inline to avoid the problem.

Fixes: 21b688dabecb6a ("net: phy: micrel: Cable Diag feature for lan8814 phy")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
---
 drivers/net/phy/micrel.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 3757e069c486..54a17b576eac 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1838,7 +1838,7 @@ static int ksz886x_cable_test_start(struct phy_device *phydev)
 	return phy_clear_bits(phydev, MII_BMCR, BMCR_ANENABLE | BMCR_SPEED100);
 }
 
-static int ksz886x_cable_test_result_trans(u16 status, u16 mask)
+static __always_inline int ksz886x_cable_test_result_trans(u16 status, u16 mask)
 {
 	switch (FIELD_GET(mask, status)) {
 	case KSZ8081_LMD_STAT_NORMAL:
@@ -1854,13 +1854,13 @@ static int ksz886x_cable_test_result_trans(u16 status, u16 mask)
 	}
 }
 
-static bool ksz886x_cable_test_failed(u16 status, u16 mask)
+static __always_inline bool ksz886x_cable_test_failed(u16 status, u16 mask)
 {
 	return FIELD_GET(mask, status) ==
 		KSZ8081_LMD_STAT_FAIL;
 }
 
-static bool ksz886x_cable_test_fault_length_valid(u16 status, u16 mask)
+static __always_inline bool ksz886x_cable_test_fault_length_valid(u16 status, u16 mask)
 {
 	switch (FIELD_GET(mask, status)) {
 	case KSZ8081_LMD_STAT_OPEN:
@@ -1871,7 +1871,8 @@ static bool ksz886x_cable_test_fault_length_valid(u16 status, u16 mask)
 	return false;
 }
 
-static int ksz886x_cable_test_fault_length(struct phy_device *phydev, u16 status, u16 data_mask)
+static __always_inline int ksz886x_cable_test_fault_length(struct phy_device *phydev,
+							   u16 status, u16 data_mask)
 {
 	int dt;
 
-- 
2.17.1

