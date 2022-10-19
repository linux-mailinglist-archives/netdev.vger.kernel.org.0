Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 163F96040E1
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 12:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbiJSK0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 06:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbiJSK0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 06:26:18 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62500F5CD1;
        Wed, 19 Oct 2022 03:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666173944; x=1697709944;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VqVlegNUVIV/JH7Zje+bGAcW407b6Vj+m+3Z8IAvusY=;
  b=L5ivXYJHs1Aw54tnKZi+H6R4SgPtULGvuI4zqBVge4fYXnHDZMldPWPv
   2BgG5uc+sMbxztN8wsFiE61HvrG5ZVvcw+/oMM+WCwMSd3gU2mz/b2u8H
   J3Ioz3Xpm+Yk02Fbh7q2wDTGLUsp7ycpR8CpTUUtJI3NsaMYHzueR7LxN
   iF4kR6aEIPidLwmDLGqF0/6Tnkw4PH+PQVedu5HTggNFC5ZYnInmGRbno
   ksJj2TSU2bsqvduuYfTUBQ2YIotM8env4Yg4G+ZP8tCXquNlBfm33hRCa
   lj75q4aVDAZsVOckR3wJ9fvqbFNzR4Qk7/HEZBTWteXq7JBgF2r0Uveks
   g==;
X-IronPort-AV: E=Sophos;i="5.95,195,1661842800"; 
   d="scan'208";a="182912338"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Oct 2022 02:57:05 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 19 Oct 2022 02:57:02 -0700
Received: from ROB-ULT-M68701.mchp-main.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 19 Oct 2022 02:56:59 -0700
From:   Sergiu Moga <sergiu.moga@microchip.com>
To:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Sergiu Moga <sergiu.moga@microchip.com>
Subject: [PATCH] net: macb: Specify PHY PM management done by MAC
Date:   Wed, 19 Oct 2022 12:55:50 +0300
Message-ID: <20221019095548.57650-1-sergiu.moga@microchip.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The `macb_resume`/`macb_suspend` methods already call the
`phylink_start`/`phylink_stop` methods during their execution so
explicitly say that the PM of the PHY is done by MAC by using the
`mac_managed_pm` flag of the `struct phylink_config`.

This also fixes the warning message issued during resume:
WARNING: CPU: 0 PID: 237 at drivers/net/phy/phy_device.c:323 mdio_bus_phy_resume+0x144/0x148

Fixes: 744d23c71af3 ("net: phy: Warn about incorrect mdio_bus_phy_resume() state")
Signed-off-by: Sergiu Moga <sergiu.moga@microchip.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 51c9fd6f68a4..4f63f1ba3161 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -806,6 +806,7 @@ static int macb_mii_probe(struct net_device *dev)
 
 	bp->phylink_config.dev = &dev->dev;
 	bp->phylink_config.type = PHYLINK_NETDEV;
+	bp->phylink_config.mac_managed_pm = true;
 
 	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII) {
 		bp->phylink_config.poll_fixed_state = true;
-- 
2.34.1

