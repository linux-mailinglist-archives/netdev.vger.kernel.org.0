Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 140BC4E2CEF
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 16:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348690AbiCUPzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 11:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348660AbiCUPzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 11:55:37 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE00565435;
        Mon, 21 Mar 2022 08:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647878051; x=1679414051;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qYChFPbDAfyBQGSHc8vlsYhPBC61xJmrzqLud48m8FQ=;
  b=MAN3gXI/5WHsRPi35ZTlgfjzosPoBIsFc5h41Nj9d1PIB16ltvQBQmU6
   NZCWDSlYscBG9CAIeGDiM4x6Ko3uJfWQL3NnNGdwxLMG8oHbdUPFHDQPZ
   6EjtrIpsyNoKmkRxmgbMYMMaIKr7g/jxJAbrIcsiUD+Cm+EJUwZEwsuk5
   si/VNu0o3MzIJqUV1Fyu0UExPooaKTJJ4r7v+LvrsK/J1nUc6x7JvuTTn
   bIOgwNKoAD26DzzR/LHAQhFJRcfPwT2phwr8ZznfjRp8smPpxRsvlbKJy
   7ZSV9p8v3Kzw7u9Ib2oA51GyfqxF/L9l2cuglAbFmaCmjhWPBb2zsPDBb
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,199,1643698800"; 
   d="scan'208";a="89617544"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Mar 2022 08:54:10 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 21 Mar 2022 08:54:10 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 21 Mar 2022 08:54:04 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>
Subject: [RFC Patch net-next 1/3] net: phy: lan87xx: added lan87xx_update_link routine
Date:   Mon, 21 Mar 2022 21:23:35 +0530
Message-ID: <20220321155337.16260-2-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220321155337.16260-1-arun.ramadoss@microchip.com>
References: <20220321155337.16260-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The LAN87xx phydev->link has been updated via lan87xx_read_status
routine. To get only the recent phydev->link status instead of various
other status, refactored the code to have separate lan87xx_update_link
routine.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/phy/microchip_t1.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index 389df3f4293c..bb4514254adc 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -674,7 +674,7 @@ static int lan87xx_cable_test_get_status(struct phy_device *phydev,
 	return 0;
 }
 
-static int lan87xx_read_status(struct phy_device *phydev)
+static int lan87xx_update_link(struct phy_device *phydev)
 {
 	int rc = 0;
 
@@ -687,6 +687,17 @@ static int lan87xx_read_status(struct phy_device *phydev)
 	else
 		phydev->link = 0;
 
+	return rc;
+}
+
+static int lan87xx_read_status(struct phy_device *phydev)
+{
+	int rc = 0;
+
+	rc = lan87xx_update_link(phydev);
+	if (rc < 0)
+		return rc;
+
 	phydev->speed = SPEED_UNKNOWN;
 	phydev->duplex = DUPLEX_UNKNOWN;
 	phydev->pause = 0;
-- 
2.33.0

