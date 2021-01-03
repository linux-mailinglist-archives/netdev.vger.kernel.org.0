Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32282E89CC
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 02:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbhACB0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jan 2021 20:26:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbhACB0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jan 2021 20:26:43 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C5FC0613CF;
        Sat,  2 Jan 2021 17:26:02 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id 6so32206676ejz.5;
        Sat, 02 Jan 2021 17:26:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4u5lr4vS/zwS7CdImn9JUDlJYsBMsJtACqSfVPiryf4=;
        b=t5qQCW6RQIm7EoZOy4p4dtL7x4eSeX4Hr9m7ECEcwNyHuGXCEY4twhhx56mnsCJ0JL
         6WnsIQB+bmcCiWHbEhT6V+PfjAfW+C08tKFDZRCSTKPMIuXaLVkrJrPAIbjLKQ2BLTCu
         D6GwRg2i9BkSLdZ1DU0I0m/0nSoBmg03SNlcAst3KE4RZKdquwp9S7JnMa99ndxTrnEX
         YN1OAw8VsbVsNsB4/0F8qmfStGh1/Q2K39ar/hT4o00TElPP05Xms2m98NiEgyhFPM8E
         Twn2fZDe4V5E8PioZUB4gXNrudC+OT3frT3b6BBTIHKWvXVbFMJGlhWe0Egzx6Sc4+yf
         qjvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4u5lr4vS/zwS7CdImn9JUDlJYsBMsJtACqSfVPiryf4=;
        b=mNquTOYjoi4nA8shdJ0WqH76AvWg3h2Xp4ScjHEcmSiJgwogobYYg6VFQiNPVv+TNn
         djyKsaE+rRto6YUO2n9+kBAUHCqNbZju+4vG2+KB4+pfp+v0FMNGOruODmQwzI/iF5qA
         PXF+kczEUaUg6aPSkaG5c3qlHKlk+N68PsRCi/iz0eEsIUdk5jtCgMU1cfg06y7sW1z2
         NDNHc6LGauy74U4STVPOOzavhIT+EK9YzPgYxzeCTmOKpD32Qy7WftY+AYADd06KDFHY
         HXK+p1OzPsrw1DQQ+9B4TKqMiI1h8jnzSS5hbFwV/v6F+8/P7R6ykRcZ5OEmF8OO/9Wz
         msFw==
X-Gm-Message-State: AOAM531cFu8nWcW0E3zk3CZ0ShJcwWehrtBxrxcorhX75OJdEnbdgjLQ
        nBZBxBg9o5DBjAysAXgejm0=
X-Google-Smtp-Source: ABdhPJyU/2gBLOXYt+eFDT6eljqckfEe4KnMTelSHcwUtFIAW9LppVviEdleSjVof1gekovk/9M3xw==
X-Received: by 2002:a17:906:3d62:: with SMTP id r2mr63425558ejf.295.1609637160795;
        Sat, 02 Jan 2021 17:26:00 -0800 (PST)
Received: from localhost.localdomain (p200300f13724fd00428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:3724:fd00:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id op5sm22118006ejb.43.2021.01.02.17.25.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jan 2021 17:26:00 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     hauke@hauke-m.de, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] net: dsa: lantiq_gswip: Fix GSWIP_MII_CFG(p) register access
Date:   Sun,  3 Jan 2021 02:25:44 +0100
Message-Id: <20210103012544.3259029-3-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210103012544.3259029-1-martin.blumenstingl@googlemail.com>
References: <20210103012544.3259029-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is one GSWIP_MII_CFG register for each switch-port except the CPU
port. The register offset for the first port is 0x0, 0x02 for the
second, 0x04 for the third and so on.

Update the driver to not only restrict the GSWIP_MII_CFG registers to
ports 0, 1 and 5. Handle ports 0..5 instead but skip the CPU port. This
means we are not overwriting the configuration for the third port (port
two since we start counting from zero) with the settings for the sixth
port (with number five) anymore.

The GSWIP_MII_PCDU(p) registers are not updated because there's really
only three (one for each of the following ports: 0, 1, 5).

Fixes: 14fceff4771e51 ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
Cc: stable@vger.kernel.org
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/dsa/lantiq_gswip.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 5d378c8026f0..4b36d89bec06 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -92,9 +92,7 @@
 					 GSWIP_MDIO_PHY_FDUP_MASK)
 
 /* GSWIP MII Registers */
-#define GSWIP_MII_CFG0			0x00
-#define GSWIP_MII_CFG1			0x02
-#define GSWIP_MII_CFG5			0x04
+#define GSWIP_MII_CFGp(p)		(0x2 * (p))
 #define  GSWIP_MII_CFG_EN		BIT(14)
 #define  GSWIP_MII_CFG_LDCLKDIS		BIT(12)
 #define  GSWIP_MII_CFG_MODE_MIIP	0x0
@@ -392,17 +390,9 @@ static void gswip_mii_mask(struct gswip_priv *priv, u32 clear, u32 set,
 static void gswip_mii_mask_cfg(struct gswip_priv *priv, u32 clear, u32 set,
 			       int port)
 {
-	switch (port) {
-	case 0:
-		gswip_mii_mask(priv, clear, set, GSWIP_MII_CFG0);
-		break;
-	case 1:
-		gswip_mii_mask(priv, clear, set, GSWIP_MII_CFG1);
-		break;
-	case 5:
-		gswip_mii_mask(priv, clear, set, GSWIP_MII_CFG5);
-		break;
-	}
+	/* There's no MII_CFG register for the CPU port */
+	if (!dsa_is_cpu_port(priv->ds, port))
+		gswip_mii_mask(priv, clear, set, GSWIP_MII_CFGp(port));
 }
 
 static void gswip_mii_mask_pcdu(struct gswip_priv *priv, u32 clear, u32 set,
@@ -822,9 +812,8 @@ static int gswip_setup(struct dsa_switch *ds)
 	gswip_mdio_mask(priv, 0xff, 0x09, GSWIP_MDIO_MDC_CFG1);
 
 	/* Disable the xMII link */
-	gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_EN, 0, 0);
-	gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_EN, 0, 1);
-	gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_EN, 0, 5);
+	for (i = 0; i < priv->hw_info->max_ports; i++)
+		gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_EN, 0, i);
 
 	/* enable special tag insertion on cpu port */
 	gswip_switch_mask(priv, 0, GSWIP_FDMA_PCTRL_STEN,
-- 
2.30.0

