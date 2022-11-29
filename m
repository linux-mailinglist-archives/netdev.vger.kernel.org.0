Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90A7F63BDC5
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 11:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbiK2KRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 05:17:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232487AbiK2KRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 05:17:08 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E957A2E7;
        Tue, 29 Nov 2022 02:17:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669717026; x=1701253026;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=ntIufUXdHMrv3LebSNeNQZucKKAEML05blpxTFqTPd0=;
  b=acBmnh2y+WExKsEGvFwPF7TNR0Smli4D5HsF6+3zasti0xdDltoC84iB
   dPD/nL1I3YzwAizb5Wiv2KQHT/NXlgtjL5Aeqq1ndgZSfEpDZPunaJx2h
   jBbJzK7VMH+mDzNd8xf+iVozBZKKabP2mx1BKiCZaBG8dt+usaYHpYQ9V
   DO3NYrTm/2GYRxgo0B2SYZw3vnl7sMTJQkEkEcLin9YmSFGPqgfMi9DSv
   vMMpPvqUalAePkmbuaGsa9gTE4gtQ9DqZFaQapOXEoZSsd5UTU3/duIDh
   QoOU1IZtrLPISo8uzWelVMIGsxyCALjH/ll9oSANfMSBpeeznlO8Vzp2t
   g==;
X-IronPort-AV: E=Sophos;i="5.96,202,1665471600"; 
   d="scan'208";a="185652937"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Nov 2022 03:17:05 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 29 Nov 2022 03:17:02 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 29 Nov 2022 03:16:59 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <richardcochran@gmail.com>
CC:     <UNGLinuxDriver@microchip.com>, <Madhuri.Sripada@microchip.com>
Subject: [PATCH v3 net-next] net: phy: micrel: Fix warn: passing zero to PTR_ERR
Date:   Tue, 29 Nov 2022 15:46:53 +0530
Message-ID: <20221129101653.6921-1-Divya.Koppera@microchip.com>
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

Handle the NULL pointer case

Fixes New smatch warnings:
drivers/net/phy/micrel.c:2613 lan8814_ptp_probe_once() warn: passing zero to 'PTR_ERR'

Fixes Old smatch warnings:
drivers/net/phy/micrel.c:1750 ksz886x_cable_test_get_status() error:
uninitialized symbol 'ret'.

vim +/PTR_ERR +2613 drivers/net/phy/micrel.c
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: ece19502834d ("net: phy: micrel: 1588 support for LAN8814 phy")
Fixes: 21b688dabecb ("net: phy: micrel: Cable Diag feature for lan8814 phy")
Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
---
v2 -> v3:
- Changed subject line from net to net-next
- Removed config check for ptp and clock configuration
  instead added null check for ptp_clock
- Fixed one more warning related to initialisaton.

v1 -> v2:
- Handled NULL pointer case
- Changed subject line with net-next to net
---
 drivers/net/phy/micrel.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 26ce0c5defcd..3703e2fafbd4 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -2088,7 +2088,8 @@ static int ksz886x_cable_test_get_status(struct phy_device *phydev,
 	const struct kszphy_type *type = phydev->drv->driver_data;
 	unsigned long pair_mask = type->pair_mask;
 	int retries = 20;
-	int pair, ret;
+	int ret = 0;
+	int pair;
 
 	*finished = false;
 
@@ -2970,12 +2971,13 @@ static int lan8814_config_intr(struct phy_device *phydev)
 
 static void lan8814_ptp_init(struct phy_device *phydev)
 {
+	struct lan8814_shared_priv *shared_priv = phydev->shared->priv;
 	struct kszphy_priv *priv = phydev->priv;
 	struct kszphy_ptp_priv *ptp_priv = &priv->ptp_priv;
 	u32 temp;
 
-	if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) ||
-	    !IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING))
+	/* Check if PHC support is missing at the configuration level */
+	if (!shared_priv->ptp_clock)
 		return;
 
 	lanphy_write_page_reg(phydev, 5, TSU_HARD_RESET, TSU_HARD_RESET_);
@@ -3016,10 +3018,6 @@ static int lan8814_ptp_probe_once(struct phy_device *phydev)
 {
 	struct lan8814_shared_priv *shared = phydev->shared->priv;
 
-	if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) ||
-	    !IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING))
-		return 0;
-
 	/* Initialise shared lock for clock*/
 	mutex_init(&shared->shared_lock);
 
@@ -3039,12 +3037,16 @@ static int lan8814_ptp_probe_once(struct phy_device *phydev)
 
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

