Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B62AE5FAFB9
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 11:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiJKJyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 05:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiJKJyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 05:54:49 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6F5CE12;
        Tue, 11 Oct 2022 02:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1665482087; x=1697018087;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=dJ4Wy6/TZUF4md84ZV3E4CX78cKGFAXzNz4PfLmRgxU=;
  b=K4wRIq1RFVKvEZRbXPMS0fjfjS80rZT5hfQsAH1vH5HcmUHmlfxHOJlW
   5Uk61KPTxVst2SKYN8turPXtGCB3yf6FFqi7gBM54ZID/9obXRJeRzlZh
   8LzAtafERpv0TWL2lswy44Hjatu2YbHXs9CGcvivSxolVmkgTLH+iK3MC
   CyTkquWCWggOa0k7sM/S4MZCrMRrrNZX17+rk0ekg7a7LpqbnICQ05hMd
   q0DTlj2b8grMl1W4uMMfaK+6N427w/jbbC52uzG2+eQfqvGaU3L995ePK
   iNY7gEHx/AbphOurLqVuo7epvVttUM4Ap9ESXRMgCuzxdYQ+GUqKdXc0V
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,176,1661842800"; 
   d="scan'208";a="194823537"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Oct 2022 02:54:45 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 11 Oct 2022 02:54:44 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 11 Oct 2022 02:54:40 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>
Subject: [RESEND PATCH net] net: phy: micrel: Fixes FIELD_GET assertion
Date:   Tue, 11 Oct 2022 15:24:37 +0530
Message-ID: <20221011095437.12580-1-Divya.Koppera@microchip.com>
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

