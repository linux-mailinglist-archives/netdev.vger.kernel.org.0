Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD7764C5D6
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 10:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237907AbiLNJ0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 04:26:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237180AbiLNJZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 04:25:51 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808271D648;
        Wed, 14 Dec 2022 01:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1671009951; x=1702545951;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=xyc4x/K6bFavC9UZAWslWQocjusdPMbCBREoUlViGU0=;
  b=TultIts98M9DVLhkshwK7NriAEp7Y/9yC00DAshP77xsSTzkIWDxgv4i
   RxVWmt80TKv5fao+C350TC8OR4YWwheLBOEUN/4uMU4v3SOadWtCMQEql
   uccaN3nCVixIviUaOw5qSH13GwEc27ypb30H2xEhQPHYvSsufnM2ihdy5
   dOFmHulIkFL5l6Jk6teW/Df8pL8V/biQlw70tRcictnwDyM3MiyminwU2
   TTYAKZSruraG89jrKQ7oa+qQ9b39+A3LzS+ITTKCLXu7UFRKlFA9zNkVH
   pg5MLWB54iipNyACFKg3JtRGV/puONVOROh+o9a9SSdWXeFNAQVBMVdkJ
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,244,1665471600"; 
   d="scan'208";a="188100271"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Dec 2022 02:25:50 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 14 Dec 2022 02:25:47 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Wed, 14 Dec 2022 02:25:43 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <richardcochran@gmail.com>
CC:     <UNGLinuxDriver@microchip.com>
Subject: [RESEND PATCH v5 net-next 2/2] net: phy: micrel: Fix warn: passing zero to PTR_ERR
Date:   Wed, 14 Dec 2022 14:55:24 +0530
Message-ID: <20221214092524.21399-3-Divya.Koppera@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221214092524.21399-1-Divya.Koppera@microchip.com>
References: <20221214092524.21399-1-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
v4 -> v5:
- Removed run time check and added compile time check for PHC

v3 -> v4:
- Split the patch for different warnings
- Renamed variable from shared_priv to shared.

v2 -> v3:
- Changed subject line from net to net-next
- Removed config check for ptp and clock configuration
  instead added null check for ptp_clock
- Fixed one more warning related to initialisaton.

v1 -> v2:
- Handled NULL pointer case
- Changed subject line with net-next to net
---
 drivers/net/phy/micrel.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 1bcdb828db56..650ef53fcf20 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -3017,10 +3017,6 @@ static int lan8814_ptp_probe_once(struct phy_device *phydev)
 {
 	struct lan8814_shared_priv *shared = phydev->shared->priv;

-	if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) ||
-	    !IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING))
-		return 0;
-
 	/* Initialise shared lock for clock*/
 	mutex_init(&shared->shared_lock);

@@ -3040,12 +3036,16 @@ static int lan8814_ptp_probe_once(struct phy_device *phydev)

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

