Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B216741FD89
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 19:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233744AbhJBSAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 14:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232043AbhJBSAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 14:00:07 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F55C0613EC;
        Sat,  2 Oct 2021 10:58:21 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id y23so12994454lfb.0;
        Sat, 02 Oct 2021 10:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JkjhFap2SaKbCVGK3B2tWxosThf62VIvzJlE9sE85OE=;
        b=oAVdA7Dmue10p33t50tGLK7NmxX7LZX/SLJlP2VjHiADCEAPRP1lUNWcgM+ZyeT2II
         UmY80EkAMBC0KGIt7OygVtjGOqcUYNM8riQeNjD7d5Q1Vte1iXH+u5kJDVMDVW7dt7Qb
         doINhDYzoHR/5HlRZdA8R3vL9aGQ3H4NloJqWgW2mFtA//F811UWGfloJ7ZEXks+DTQI
         5m4Lt370Uqnbip+8+2PN7ZiVktJWGA8mxDL5SfUWMfFTUg83y9GNQAuzfCWvgS2vDUil
         sOFaYvy2NqpTgp7XhuorabRdExsXAXkNPGNNLG6mUaaX+8ytTfYc1CcJYgE7bmxe5WHN
         DGaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JkjhFap2SaKbCVGK3B2tWxosThf62VIvzJlE9sE85OE=;
        b=rFCbVvh9O/1EKgspTVvMpGQgkv7ka15yHT3PLgzN9Gywa8e7KlPOhQf5fAbnBuMqyV
         sxlulXkZCiXfe21c7z84xfgm579I1SA7FI7W6wAtGWTRgNO77mzaJLPxYqJ4Kp9SntLT
         HDDNgf9XX0A79iQFpmtkijfYIpkxKzaS5BWC7O/gusvJ3jAqXqrniKylsDNVHz5+IMG6
         wVHW7AKoiTsBYJaLmlsh3XxjmhBLDEc1N/PhhH+0O9Tf0m4IikASgMFcwLQwr7izuR6/
         kLP6kBnFAF/9sMZvybHCln0KyKICzVTYXVZ6t2Gnx8aE2MeedrnG6jDGhrDCYmZGuEYG
         2RNw==
X-Gm-Message-State: AOAM533oAWdj1X81SqMejzYWRdtqCL0HzrYuwP3b1U1vrfNdm9DfYzSb
        CFLnv4cL10G/fqH5Vpg51RA=
X-Google-Smtp-Source: ABdhPJx7j+bqqISG+zpYLqXO7exxTaMKYbSOJYhakMULTdwY1OZKxxSInen9GngredVEd7cyHpcIPA==
X-Received: by 2002:a2e:d19:: with SMTP id 25mr4825511ljn.167.1633197499509;
        Sat, 02 Oct 2021 10:58:19 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id t26sm1100043lfl.141.2021.10.02.10.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 10:58:18 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V2 net-next 1/2] net: bgmac: improve handling PHY
Date:   Sat,  2 Oct 2021 19:58:11 +0200
Message-Id: <20211002175812.14384-1-zajec5@gmail.com>
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
V2: Promote it out of RFC and send together with MDIO patch per
    Florian's request.
---
 drivers/net/ethernet/broadcom/bgmac-bcma.c | 33 ++++++++++++++--------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bgmac-bcma.c b/drivers/net/ethernet/broadcom/bgmac-bcma.c
index 28759062d68d..7190e3f0da91 100644
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
@@ -297,10 +309,7 @@ static int bgmac_probe(struct bcma_device *core)
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

