Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8C5C65FCBA
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 09:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbjAFI3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 03:29:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232180AbjAFI3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 03:29:23 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596187A920;
        Fri,  6 Jan 2023 00:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1672993762; x=1704529762;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=OKsrMUds3JwbloBzsKaWTIBxPZJcQykKaE7DFA0jHmc=;
  b=U/xWVyOHxgN8UVNgCoxjkPp5/PDVkvNqKEUqvkOXELYdMdLnmprncL2z
   19xtwCs/rpAOXFp5Xhe/V6wLn3zq6bCkXtkmTy70WOyutJt29FEWWaFpf
   tfN9+Qsv3LXg4w+PexnnqtTw2PVG+hio7PbCBLNuxxMJkGzBSQ5Uf0h0P
   MnBsIyy/wfMdCcV8s4ynolUn90AMLdk2tkj64JQI+5XVj92X+6Q35RvQf
   Wsh9n5L5rzpYPADVzZDd7YuVCeu8I8APaJfb+b7GpyLbBRnnfAtvnmus9
   Ew8H/fl3EgyqD9PgiyXDTCg4Ukzf6IwFrmgazsFjLphiT3F83UnCRTkNB
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="195562570"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jan 2023 01:29:21 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 6 Jan 2023 01:29:21 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 6 Jan 2023 01:29:17 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <richardcochran@gmail.com>,
        <alexanderduyck@fb.com>
CC:     <UNGLinuxDriver@microchip.com>
Subject: [PATCH v6 net-next 2/2] net: phy: micrel: Fix warn: passing zero to PTR_ERR
Date:   Fri, 6 Jan 2023 13:59:05 +0530
Message-ID: <20230106082905.1159-3-Divya.Koppera@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230106082905.1159-1-Divya.Koppera@microchip.com>
References: <20230106082905.1159-1-Divya.Koppera@microchip.com>
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
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
---
v5 -> v6:
- Removed fixes tag as this is to fix static analysis issues and not
  real fix.

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

