Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF831413316
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 14:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbhIUMD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 08:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232089AbhIUMDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 08:03:55 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD82C061574;
        Tue, 21 Sep 2021 05:02:27 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id b20so21749033lfv.3;
        Tue, 21 Sep 2021 05:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ctNr/D5rTY85/Mtfv0uTalwkEbhm7HjmfEXl7IY2HrM=;
        b=TSKZComt+DeQOLeUtlJWlCjouxYRzIIQU8ReSt08SsYHYx0NwKs1kQeOmN74RLYJ0Q
         4PQrYsc57Ewxsz0Bg7CJ1WSharjgh5s7eEOGgshGpqk31QsBZzjRH8GSVax5hNyfyOjM
         sSeW8XAUTZ7j40MqB/Osqr13Fb2GSztDV4ned9fraBSlvYwbR+dc+lp3foINE4Fb8rZT
         h8K+sBCz2ASVr3cU5uSlw2gjsRiPNK5ZNIfam67NakbS0R4M3M2dqZperaf0Btm5kjmc
         5jBqdW93Hk3UAeUs85Rk9+X+jypOqfHOQpwKN60NcSXqjprF5VqvKHhwgo7SFC3xHpgR
         a+Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ctNr/D5rTY85/Mtfv0uTalwkEbhm7HjmfEXl7IY2HrM=;
        b=PHu9uAT4bn1QQkLH2VCTPn2aK/3wj5vF66d7gLj7pdaRXTSt7ziI6EOQrcc0voAw1a
         lr4u++6YIgiZyn1SSY6s/jm9D4P00YNf54/OVLqUQxpVyvmse8T1UCC76CU5+joBDbXc
         BGKKEZ96VozD+pElXkO0Xmytn9XaiCorAbkGM1hySIAutftG1mnbwfefCxnoQ7GRmZ5E
         8qa8k950pepGRTNoyE7kjoz618xRzgB7YwVJy3hki9Tixrx5HTx03m15cervAouDjHV6
         92H0tX70LPHiTVhVy0eODa8kOxzni8wKKP/xlwgqo3MvcYLKcHwdw4v1REpXK5b+qzaT
         8lyg==
X-Gm-Message-State: AOAM532Ikatsd/R02w+yGUnUs6c7EAFoBw0sewDFDpeIL/Bjsm9LGitl
        nk553ZzY3dprXmi9WMBslgw06YuaR30=
X-Google-Smtp-Source: ABdhPJwLu5o5L5YFnpYsCVVdTnPQpjucX7Hlz0Qygf5v5YvnmTmfWTkVTMkP8eeB0+iXxC8Wby/1fw==
X-Received: by 2002:a05:651c:4d0:: with SMTP id e16mr28940871lji.498.1632225745426;
        Tue, 21 Sep 2021 05:02:25 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id m17sm2097160ljp.80.2021.09.21.05.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 05:02:24 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Saravana Kannan <saravanak@google.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH RFC] net: bgmac: improve handling PHY
Date:   Tue, 21 Sep 2021 14:02:15 +0200
Message-Id: <20210921120215.27924-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

1. Use info from DT if available

It allows describing for example a fixed link. It's more accurate than
just guessing there may be one (depending on a chipset).

2. Verify PHY ID before trying to connect PHY

PHY addr 0x1e (30) is special in Broadcom routers and means a switch
connected as MDIO devices instead of a real PHY. Don't try connecting to
it.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/ethernet/broadcom/bgmac-bcma.c | 33 ++++++++++++++--------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bgmac-bcma.c b/drivers/net/ethernet/broadcom/bgmac-bcma.c
index 85fa0ab7201c..e39361042aa1 100644
--- a/drivers/net/ethernet/broadcom/bgmac-bcma.c
+++ b/drivers/net/ethernet/broadcom/bgmac-bcma.c
@@ -11,6 +11,7 @@
 #include <linux/bcma/bcma.h>
 #include <linux/brcmphy.h>
 #include <linux/etherdevice.h>
+#include <linux/of_mdio.h>
 #include <linux/of_net.h>
 #include "bgmac.h"
 
@@ -86,17 +87,28 @@ static int bcma_phy_connect(struct bgmac *bgmac)
 	struct phy_device *phy_dev;
 	char bus_id[MII_BUS_ID_SIZE + 3];
 
+	/* DT info should be the most accurate */
+	phy_dev = of_phy_get_and_connect(bgmac->net_dev, bgmac->dev->of_node,
+					 bgmac_adjust_link);
+	if (phy_dev)
+		return 0;
+
 	/* Connect to the PHY */
-	snprintf(bus_id, sizeof(bus_id), PHY_ID_FMT, bgmac->mii_bus->id,
-		 bgmac->phyaddr);
-	phy_dev = phy_connect(bgmac->net_dev, bus_id, bgmac_adjust_link,
-			      PHY_INTERFACE_MODE_MII);
-	if (IS_ERR(phy_dev)) {
-		dev_err(bgmac->dev, "PHY connection failed\n");
-		return PTR_ERR(phy_dev);
+	if (bgmac->mii_bus && bgmac->phyaddr != BGMAC_PHY_NOREGS) {
+		snprintf(bus_id, sizeof(bus_id), PHY_ID_FMT, bgmac->mii_bus->id,
+			 bgmac->phyaddr);
+		phy_dev = phy_connect(bgmac->net_dev, bus_id, bgmac_adjust_link,
+				      PHY_INTERFACE_MODE_MII);
+		if (IS_ERR(phy_dev)) {
+			dev_err(bgmac->dev, "PHY connection failed\n");
+			return PTR_ERR(phy_dev);
+		}
+
+		return 0;
 	}
 
-	return 0;
+	/* Assume a fixed link to the switch port */
+	return bgmac_phy_connect_direct(bgmac);
 }
 
 static const struct bcma_device_id bgmac_bcma_tbl[] = {
@@ -295,10 +307,7 @@ static int bgmac_probe(struct bcma_device *core)
 	bgmac->cco_ctl_maskset = bcma_bgmac_cco_ctl_maskset;
 	bgmac->get_bus_clock = bcma_bgmac_get_bus_clock;
 	bgmac->cmn_maskset32 = bcma_bgmac_cmn_maskset32;
-	if (bgmac->mii_bus)
-		bgmac->phy_connect = bcma_phy_connect;
-	else
-		bgmac->phy_connect = bgmac_phy_connect_direct;
+	bgmac->phy_connect = bcma_phy_connect;
 
 	err = bgmac_enet_probe(bgmac);
 	if (err)
-- 
2.26.2

