Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 285404CD188
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 10:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239298AbiCDJpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 04:45:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239288AbiCDJpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 04:45:15 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1BD1986C7;
        Fri,  4 Mar 2022 01:44:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646387068; x=1677923068;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=E3rqwY/99wnq4HgwXc6HJ5NbOlQpp4iqKb8/360vcls=;
  b=fWc5PYsmwGp05DKxGplrvgkGtzOFG1tqAhxbjV8zJRN8EgBOwm0CZE9f
   9m4sv2EF9qv6RxHRMQo54EXhoft+3qp4XWtb2NDUDVLRw7WDtep6Q14e2
   FCu1/uqXXyHUc9r25Y7X4RKYhSm7JdVyPzgqnyI0j6KlKqlkw23DLnH8q
   nVtkFIAC/457UsfBviO66U/9/H5ViF3xVQ838+RtgjxzfXpjHUF1GslrB
   cIa8efgjK+o5CSiqdfp1g4ptQ15CZ1ZruTP/oGDKY6QUXt4hlMKQhtnS0
   yAK+FaI7grjrjr4qP5A0TcCbIAHwFsNzS5us6kaMiLI7+lxqEOBuK6vwa
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,154,1643698800"; 
   d="scan'208";a="148081517"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Mar 2022 02:44:27 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 4 Mar 2022 02:44:26 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 4 Mar 2022 02:44:22 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next 1/6] net: phy: used genphy_soft_reset for phy reset in LAN87xx
Date:   Fri, 4 Mar 2022 15:13:56 +0530
Message-ID: <20220304094401.31375-2-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220304094401.31375-1-arun.ramadoss@microchip.com>
References: <20220304094401.31375-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replaced the current code of resetting of LAN87xx phy to
genphy_soft_reset library function.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/phy/microchip_t1.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index bc50224d43dd..c6a8c22efcce 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -197,20 +197,10 @@ static int lan87xx_phy_init(struct phy_device *phydev)
 	if (rc < 0)
 		return rc;
 
-	/* Soft Reset the SMI block */
-	rc = access_ereg_modify_changed(phydev, PHYACC_ATTR_BANK_SMI,
-					0x00, 0x8000, 0x8000);
-	if (rc < 0)
-		return rc;
-
-	/* Check to see if the self-clearing bit is cleared */
-	usleep_range(1000, 2000);
-	rc = access_ereg(phydev, PHYACC_ATTR_MODE_READ,
-			 PHYACC_ATTR_BANK_SMI, 0x00, 0);
+	/* phy Soft reset */
+	rc = genphy_soft_reset(phydev);
 	if (rc < 0)
 		return rc;
-	if ((rc & 0x8000) != 0)
-		return -ETIMEDOUT;
 
 	/* PHY Initialization */
 	for (i = 0; i < ARRAY_SIZE(init); i++) {
-- 
2.33.0

