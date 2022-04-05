Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A64F4F24BA
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 09:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbiDEHci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 03:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiDEHcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 03:32:36 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3577B2E6AE;
        Tue,  5 Apr 2022 00:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649143839; x=1680679839;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WpqyCkN8z6dTmB2Z+i50lANb6XH8SIiEf6GfW2z8T0U=;
  b=zKmEug4g8hC/Vse8xP8Mj7oWEQ8hjX8eg2Zi0uU/Xo469rV2xkW7st4Z
   mLi1VyWUYYEUmHOQmUvlF0qYqvPPFF0U01aPj8fErz5GR34F/YO2Le46+
   5GWCMwgnIIMV3ExQIMxEpZMqNxeHsEU6KqXCrmvB8VM1R5dOiRQULINpi
   9pLvSXFPYNnc9CHpt2tbQ9rIxd7c+H3gj0R1FOPrMvv6w0rpnhbljX4qC
   XuCWiJFgbcZ9New0OoP0HKN+wIVjZm+d8gHS14ih25JkprphlGcS9B5sO
   GuTa8q5f+EF9JwLzambpyCezmyVMdVSF5L1mqbcPOGubeWZhYLWyaWtkg
   w==;
X-IronPort-AV: E=Sophos;i="5.90,236,1643698800"; 
   d="scan'208";a="158891598"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Apr 2022 00:30:38 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 5 Apr 2022 00:30:37 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 5 Apr 2022 00:30:33 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>
Subject: [Patch net] net: phy: LAN87xx: remove genphy_softreset in config_aneg
Date:   Tue, 5 Apr 2022 13:00:23 +0530
Message-ID: <20220405073023.7393-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the T1 phy master/slave state is changed, at the end of config_aneg
function genphy_softreset is called. After the reset all the registers
configured during the config_init are restored to default value.
To avoid this, removed the genphy_softreset call.

Fixes: 8a1b415d70b7 ("net: phy: added ethtool master-slave configuration support")
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/phy/microchip_t1.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index 389df3f4293c..3f79bbbe62d3 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -706,7 +706,6 @@ static int lan87xx_read_status(struct phy_device *phydev)
 static int lan87xx_config_aneg(struct phy_device *phydev)
 {
 	u16 ctl = 0;
-	int rc;
 
 	switch (phydev->master_slave_set) {
 	case MASTER_SLAVE_CFG_MASTER_FORCE:
@@ -722,11 +721,7 @@ static int lan87xx_config_aneg(struct phy_device *phydev)
 		return -EOPNOTSUPP;
 	}
 
-	rc = phy_modify_changed(phydev, MII_CTRL1000, CTL1000_AS_MASTER, ctl);
-	if (rc == 1)
-		rc = genphy_soft_reset(phydev);
-
-	return rc;
+	return phy_modify_changed(phydev, MII_CTRL1000, CTL1000_AS_MASTER, ctl);
 }
 
 static struct phy_driver microchip_t1_phy_driver[] = {

base-commit: 2975dbdc3989cd66a4cb5a7c5510de2de8ee4d14
-- 
2.33.0

