Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6D4D50CBEE
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 17:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235582AbiDWPun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 11:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234162AbiDWPum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 11:50:42 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DCD1D3981;
        Sat, 23 Apr 2022 08:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1650728864; x=1682264864;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WUlcHf/t/2eZN/wNFhQO0XPNYnopzEAdT4u3MWAmykg=;
  b=JoUz3Gjw749ZAnD0F5JAUPoEt1TlM5Kx2PJuEMbeNyuAPyO7xDfeBJ1s
   umPk91jV16+NWc6rJkjE+tIdeCmLSFtRhEyVGfMPHFJizSBmuIpV1kvAe
   17lDki1uWoVVtIm82t6lY6fAzFphvcPfVq1UYQs9KcVxC2EYFH9Hz+Ax2
   SuZx0ruf624MUDu6BEQV17hnszKeNcxeCcEhXug7CYD/pJDgVu+w8h66N
   FtcEjKSe19ADL8k/QXIHm59olKBttQQpHU5Tj3o4f7ULll/BkBILlicIr
   jeTzruxSoL6McY8SulR1/TaxUnQGyKSVe7jeJkJQ6BfB8zBtsZ4C9taTL
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,284,1643698800"; 
   d="scan'208";a="161490770"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Apr 2022 08:47:44 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sat, 23 Apr 2022 08:47:43 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sat, 23 Apr 2022 08:47:35 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>
Subject: [Patch net-next] net: phy: LAN937x: add interrupt support for link detection
Date:   Sat, 23 Apr 2022 21:17:27 +0530
Message-ID: <20220423154727.29052-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added the config_intr and handle_interrupt for the LAN937x phy which is
same as the LAN87xx phy.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/phy/microchip_t1.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index 796fbcb7dafe..d4c93d59bc53 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -792,6 +792,8 @@ static struct phy_driver microchip_t1_phy_driver[] = {
 		.flags          = PHY_POLL_CABLE_TEST,
 		.features	= PHY_BASIC_T1_FEATURES,
 		.config_init	= lan87xx_config_init,
+		.config_intr    = lan87xx_phy_config_intr,
+		.handle_interrupt = lan87xx_handle_interrupt,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 		.config_aneg    = lan87xx_config_aneg,

base-commit: cfc1d91a7d78cf9de25b043d81efcc16966d55b3
-- 
2.33.0

