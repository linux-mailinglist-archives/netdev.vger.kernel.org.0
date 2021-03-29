Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C922934CD48
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 11:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbhC2JqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 05:46:12 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:37891 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbhC2Jpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 05:45:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1617011150; x=1648547150;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7mQ2O8uMGGM8M7A4/bHP3Kwzqmc4SB5p43XoI6YVrdg=;
  b=grrIwnqsjHUAwWfWsD5DriZ8U4e19tCM0XPT7wBTGUDmQCloLnkogdQJ
   gLEbban7KxegHZVRqESiHEbvFkqIdaD3exMXMW9JmRHfhNt94RNvaTLhf
   8tv8v6+suqRDgTupZsoAK3rLaB1YNJjNc5mpbHbY6qMAkNZuetpGaxwE0
   TjLyCshNdbXwpoh10UZN9OYakZM4iRgqgiq+2rxC6lf70jONhq8n/MBPx
   K3aBBhRjl6yKbVOFLbf40TFXjggz32ZWgF0cjRFoIvGjY2zZLD1UzgA/u
   TcUPNGZBTjznyy8UAy73KWsP7pw71Km6oOe/doTIO1ouGEl7XyufQM9ZW
   A==;
IronPort-SDR: 3H9Qy591LYNLaroSO/YDaECvEsI/wnEnD5F9Y2UOGKX/0EdxxIZ9zkcho85F7Ggb1IqzgRvURv
 FN8k86k+rUTU7bSuxuz1T3XXwU0xrun3BZ6dQ3IGbQVYM2Mno32o6GSSAb0y5mbHgCPNaPy6PL
 P0Bvok7ouNSVvZWr45dvky8wEFkCpfS2gIldrL4hqbPL3YAszVchP4X7v8+Mw/t6S9YnQ3Y5VP
 fFbGK4e/o+MXvcZV1VXh9108LmXRXJnBJuW3CrQJ3uIqi+2mui+HnZGdGu79Ac9sksvRLMTJAd
 kx4=
X-IronPort-AV: E=Sophos;i="5.81,287,1610434800"; 
   d="scan'208";a="111694250"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Mar 2021 02:45:48 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 29 Mar 2021 02:45:47 -0700
Received: from xasv.mchp-main.com (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Mon, 29 Mar 2021 02:45:46 -0700
From:   Andre Edich <andre.edich@microchip.com>
To:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>
CC:     <Parthiban.Veerasooran@microchip.com>,
        Andre Edich <andre.edich@microchip.com>,
        =?UTF-8?q?M=C3=A5ns=20Rullg=C3=A5rd?= <mans@mansr.com>
Subject: [PATCH net-next] net: phy: lan87xx: fix access to wrong register of LAN87xx
Date:   Mon, 29 Mar 2021 11:45:36 +0200
Message-ID: <20210329094536.3118619-1-andre.edich@microchip.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function lan87xx_config_aneg_ext was introduced to configure
LAN95xxA but as well writes to undocumented register of LAN87xx.
This fix prevents that access.

The function lan87xx_config_aneg_ext gets more suitable for the new
behavior name.

Reported-by: Måns Rullgård <mans@mansr.com>
Fixes: 05b35e7eb9a1 ("smsc95xx: add phylib support")
Signed-off-by: Andre Edich <andre.edich@microchip.com>
---
 drivers/net/phy/smsc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index ddb78fb4d6dc..d8cac02a79b9 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -185,10 +185,13 @@ static int lan87xx_config_aneg(struct phy_device *phydev)
 	return genphy_config_aneg(phydev);
 }
 
-static int lan87xx_config_aneg_ext(struct phy_device *phydev)
+static int lan95xx_config_aneg_ext(struct phy_device *phydev)
 {
 	int rc;
 
+	if (phydev->phy_id != 0x0007c0f0) /* not (LAN9500A or LAN9505A) */
+		return lan87xx_config_aneg(phydev);
+
 	/* Extend Manual AutoMDIX timer */
 	rc = phy_read(phydev, PHY_EDPD_CONFIG);
 	if (rc < 0)
@@ -441,7 +444,7 @@ static struct phy_driver smsc_phy_driver[] = {
 	.read_status	= lan87xx_read_status,
 	.config_init	= smsc_phy_config_init,
 	.soft_reset	= smsc_phy_reset,
-	.config_aneg	= lan87xx_config_aneg_ext,
+	.config_aneg	= lan95xx_config_aneg_ext,
 
 	/* IRQ related */
 	.config_intr	= smsc_phy_config_intr,
-- 
2.28.0

