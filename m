Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 188B95799CF
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 14:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238395AbiGSMG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 08:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238143AbiGSMF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 08:05:26 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10723459A2;
        Tue, 19 Jul 2022 05:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1658232060; x=1689768060;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=qdSDMszO7rtGPWMStk70YxXk8Tap3FTBbrpiSKKQbpI=;
  b=kjr9W2yBSdeHYntH53WVNCafTz2E0pdzVNaCRcCsjLsF7Kva+7s03VdL
   BZKlcglMNF+nqyLstoufIpuiYWhMi13fuDVmCRp+sf77UJWqLeEe/Nh1k
   8WmNrN9c/iLfixMLlIj6LRg6zAXngbbPgRizlIpp7fM7e+ij7l8uYiWaY
   wYX20RSYfihzWkfaiGNTu7+Guu1QQ2pCGFSHHhbpisVWD108rE1Lnlr69
   5sPxJsGZTOEM8hjKICSVr8970WtZYrsSqjS0JIqfH3GYkwTBYv75CDAxL
   cEnIS4dWtzI1txFBoiKf65kJA5EZUp+eJytgaYhJIwoQjnpnRDJyRMAQJ
   g==;
X-IronPort-AV: E=Sophos;i="5.92,284,1650956400"; 
   d="scan'208";a="172918483"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Jul 2022 05:00:59 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 19 Jul 2022 05:00:59 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 19 Jul 2022 05:00:55 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <richardcochran@gmail.com>
CC:     <UNGLinuxDriver@microchip.com>, <Madhuri.Sripada@microchip.com>
Subject: [PATCH v2 net] net: phy: micrel: Fix warn: passing zero to PTR_ERR
Date:   Tue, 19 Jul 2022 17:30:52 +0530
Message-ID: <20220719120052.26681-1-Divya.Koppera@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Handle the NULL pointer case

Fixes New smatch warnings:
drivers/net/phy/micrel.c:2613 lan8814_ptp_probe_once() warn: passing zero to 'PTR_ERR'

vim +/PTR_ERR +2613 drivers/net/phy/micrel.c

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: ece19502834d ("net: phy: micrel: 1588 support for LAN8814 phy")
Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
---
v1 -> v2:
- Handled NULL pointer case
- Changed subject line with net-next to net
---
 drivers/net/phy/micrel.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index e78d0bf69bc3..6be6ee156f40 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -2812,12 +2812,16 @@ static int lan8814_ptp_probe_once(struct phy_device *phydev)
 
 	shared->ptp_clock = ptp_clock_register(&shared->ptp_clock_info,
 					       &phydev->mdio.dev);
-	if (IS_ERR_OR_NULL(shared->ptp_clock)) {
+	if (IS_ERR(shared->ptp_clock)) {
 		phydev_err(phydev, "ptp_clock_register failed %lu\n",
 			   PTR_ERR(shared->ptp_clock));
 		return -EINVAL;
 	}
 
+	/* Check if PHC support is missing at the configuration level */
+	if (!shared->ptp_clock)
+		return 0;
+
 	phydev_dbg(phydev, "successfully registered ptp clock\n");
 
 	shared->phydev = phydev;
-- 
2.17.1

