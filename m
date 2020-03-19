Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B72AD18C227
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 22:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgCSVRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 17:17:11 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44616 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727217AbgCSVRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 17:17:09 -0400
Received: by mail-wr1-f65.google.com with SMTP id o12so4489615wrh.11
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 14:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Bl3f+J88shETG3TutG14cD21imHzBNbH/Zx/P5rSu6w=;
        b=C6tBPzW8PUpAVo3U4YRAAqbZEs80MtqN9oKTrf1Kz77kPUGsNBl9iTSM/BltDtBOGw
         4YiP7nogBYTwNnOcv278b4xSLAYgB7U1CFMnUIUAU1ipsEvAJvwFhnZUabs4iat9yGM7
         PWV0AQHBw1VGKP4pW+uDLOnk9UngBCD7HWNDIDT0al2RKqg5m7COo6Iv+lRisxaEfabZ
         abIyCpy2IVUGHBSzJfRPLuI/kH/Rg4kvjz7wFuVpCgAXJTBqibE7hSZxlQEz0g9W8S6P
         9iH3mXjOX0cSz4wpPm5jr3MYmWiVxp60oI41wERT8VhxTALpltjMnzGLMDS4o6gOzQgB
         GKMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Bl3f+J88shETG3TutG14cD21imHzBNbH/Zx/P5rSu6w=;
        b=gVSZA4MJjLWDECtVxu4/jIbUfs+Tm2GVMNB73ITW1zCWDtRvfae5h5GT0r/Qx84Rn3
         hj8FQr9NLesaxlN1V+dUCMEOAKckZDqRO43uk0MRvS3zkMmjas5mwde2CXIFGKOMgCAh
         EfcoTUpUTaItHIf1bc8Q0SwBARoldDutBEkTj2iAMwfR2xZ95jKhXrdJi56479Tv1z89
         cEZgcER0xSRyFGEapJ6qneDRktY1GCs7rmvIzMxxAzlrXp++ZpRwS3Fkp1RIpdIDEKSX
         kbG+e93Q4r3u7hoixtPKKMFgXCFPWH/aerRBefNhhmgaktVv2Y5qOeCSqwH3tvdqU3wQ
         kaRg==
X-Gm-Message-State: ANhLgQ1D3kvyZyo0vFv3NywJEE/uLT6sdcx5dUREhVrr7fnWmCjqTIYR
        D6InbuooJDaPObHYJ8btl3Q=
X-Google-Smtp-Source: ADFU+vsHXPcB6lMAMfOX6CI5HCTCc5cxbauwol0PyXFWgxBfcRe3UYbn/1y/TlVGn/PIFqVbiqQZTQ==
X-Received: by 2002:adf:82b0:: with SMTP id 45mr6559038wrc.120.1584652626235;
        Thu, 19 Mar 2020 14:17:06 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id l13sm5117655wrm.57.2020.03.19.14.17.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 14:17:05 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, antoine.tenart@bootlin.com
Subject: [PATCH net-next 4/4] net: phy: mscc: add support for VSC8502
Date:   Thu, 19 Mar 2020 23:16:49 +0200
Message-Id: <20200319211649.10136-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200319211649.10136-1-olteanv@gmail.com>
References: <20200319211649.10136-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This is a dual copper PHY with support for MII/GMII/RGMII on MAC side,
as well as a bunch of other features such as SyncE and Ring Resiliency.

I haven't tested interrupts and WoL, but I am confident that they work
since support is already present in the driver and the register map is
no different for this PHY.

PHY statistics work, PHY tunables appear to work, suspend/resume works.

Signed-off-by: Wes Li <wes.li@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/phy/mscc/mscc.h      |  1 +
 drivers/net/phy/mscc/mscc_main.c | 24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index d4349a327329..ba3c1e76eac8 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -261,6 +261,7 @@ enum rgmii_clock_delay {
 /* Microsemi PHY ID's
  *   Code assumes lowest nibble is 0
  */
+#define PHY_ID_VSC8502			  0x00070630
 #define PHY_ID_VSC8504			  0x000704c0
 #define PHY_ID_VSC8514			  0x00070670
 #define PHY_ID_VSC8530			  0x00070560
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index dd99e0cb9588..055df2744d7c 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -2050,6 +2050,30 @@ static int vsc85xx_probe(struct phy_device *phydev)
 
 /* Microsemi VSC85xx PHYs */
 static struct phy_driver vsc85xx_driver[] = {
+{
+	.phy_id		= PHY_ID_VSC8502,
+	.name		= "Microsemi GE VSC8502 SyncE",
+	.phy_id_mask	= 0xfffffff0,
+	/* PHY_BASIC_FEATURES */
+	.soft_reset	= &genphy_soft_reset,
+	.config_init	= &vsc85xx_config_init,
+	.config_aneg    = &vsc85xx_config_aneg,
+	.read_status	= &vsc85xx_read_status,
+	.ack_interrupt	= &vsc85xx_ack_interrupt,
+	.config_intr	= &vsc85xx_config_intr,
+	.suspend	= &genphy_suspend,
+	.resume		= &genphy_resume,
+	.probe		= &vsc85xx_probe,
+	.set_wol	= &vsc85xx_wol_set,
+	.get_wol	= &vsc85xx_wol_get,
+	.get_tunable	= &vsc85xx_get_tunable,
+	.set_tunable	= &vsc85xx_set_tunable,
+	.read_page	= &vsc85xx_phy_read_page,
+	.write_page	= &vsc85xx_phy_write_page,
+	.get_sset_count = &vsc85xx_get_sset_count,
+	.get_strings    = &vsc85xx_get_strings,
+	.get_stats      = &vsc85xx_get_stats,
+},
 {
 	.phy_id		= PHY_ID_VSC8504,
 	.name		= "Microsemi GE VSC8504 SyncE",
-- 
2.17.1

