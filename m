Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4857635D3FA
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 01:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238067AbhDLXaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 19:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237776AbhDLXaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 19:30:55 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A81C061574;
        Mon, 12 Apr 2021 16:30:35 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id l76so10585478pga.6;
        Mon, 12 Apr 2021 16:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kkc/3Sbn1YiBpMuXTEWW3YCGWqSYNXGhcKujPJsQLIs=;
        b=jDc1QFZATIsSh7cz4z8tp4dbUiNhI7qnrzVEiG/ZujpK9EFZ9jxvjqYTa6x2y5ip1M
         CrNm2Q8YHUjzzjJpDkgOVCDKFPrwHGGPIq3r3QeRSfYo2SKy5LaXE7n7XApZ7KcmY4Ga
         /Qgvh1PdKrsmmT0HyXAOoLXFwE7pM+ptP47YHBzBSU4Edh1JajiFLoR2q1JTE2a4uvPg
         tmKqnhVTLMYSuuKKx8tbvi6OZPDWiLbMkIXXLVC2QhHobWSWQBxPouhmFYcI1G4YLA1a
         W1TMSsb7OjDQ7dlZ1RcpGN/cqf0jTZRmQbQ6erPV6WIx1wG0f/F/B+DfBr+bdS5g6V0m
         PFog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kkc/3Sbn1YiBpMuXTEWW3YCGWqSYNXGhcKujPJsQLIs=;
        b=IQ02sym/3/MU2BbLTLP9gRlOa9bwP/ExmwfaGvc8ThZx4NCAdMiUxzmSAt0Pjhkoob
         hOqabRL1mNqB3CbdzwCXcsdhxjbUXO3gEuBSoIiZoY+KgVgFnoAwUsRGNt92ptv4lDl5
         dIvynS439U8lAwtlmCVArrCouiue5UwFDd30Doj+4sxCXguyWHmTwoAkrM+Fhq0mELJO
         wGCKE9NjcuErkAE5Wk/XYlJiSPvnKWwSJ6ejTXEB3SxRZBaGWDnQFceRu8vWQ752DTqn
         yb3cvQe2xm1A3I6h6YdDfZk+HSOXlvWE4GvhpOgLOJ+fnBuJo+pGcRkaE5f3gb1IGjXw
         zWwA==
X-Gm-Message-State: AOAM531W6X4kaDs1PGT0p9USCPJ3FFOaR6UNv/PrpeeMllGxWLvqzIft
        BmCnI/uwHUAhI8gA6/2gxLWkmNpkvT4=
X-Google-Smtp-Source: ABdhPJxdmWrx3gp6HH7wXXNPUlCnkz4D4SSgnCXZ2Y6XlFwI7EnRoZqQ+VAD27Gg8GMpiy6x9gSnAw==
X-Received: by 2002:a63:1646:: with SMTP id 6mr30201946pgw.321.1618270234125;
        Mon, 12 Apr 2021 16:30:34 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y2sm12257314pgp.2.2021.04.12.16.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 16:30:33 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM ETHERNET PHY
        DRIVERS),
        netdev@vger.kernel.org (open list:BROADCOM ETHERNET PHY DRIVERS)
Subject: [PATCh stable 4.19] net: phy: broadcom: Only advertise EEE for supported modes
Date:   Mon, 12 Apr 2021 16:30:14 -0700
Message-Id: <20210412233014.3301686-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210412022312.283964-1-sashal@kernel.org>
References: <20210412022312.283964-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit c056d480b40a68f2520ccc156c7fae672d69d57d upstream

We should not be advertising EEE for modes that we do not support,
correct that oversight by looking at the PHY device supported linkmodes.

Fixes: 99cec8a4dda2 ("net: phy: broadcom: Allow enabling or disabling of EEE")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/bcm-phy-lib.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/bcm-phy-lib.c b/drivers/net/phy/bcm-phy-lib.c
index e10e7b54ec4b..7e5892597533 100644
--- a/drivers/net/phy/bcm-phy-lib.c
+++ b/drivers/net/phy/bcm-phy-lib.c
@@ -198,7 +198,7 @@ EXPORT_SYMBOL_GPL(bcm_phy_enable_apd);
 
 int bcm_phy_set_eee(struct phy_device *phydev, bool enable)
 {
-	int val;
+	int val, mask = 0;
 
 	/* Enable EEE at PHY level */
 	val = phy_read_mmd(phydev, MDIO_MMD_AN, BRCM_CL45VEN_EEE_CONTROL);
@@ -217,10 +217,15 @@ int bcm_phy_set_eee(struct phy_device *phydev, bool enable)
 	if (val < 0)
 		return val;
 
+	if (phydev->supported & SUPPORTED_1000baseT_Full)
+		mask |= MDIO_EEE_1000T;
+	if (phydev->supported & SUPPORTED_100baseT_Full)
+		mask |= MDIO_EEE_100TX;
+
 	if (enable)
-		val |= (MDIO_EEE_100TX | MDIO_EEE_1000T);
+		val |= mask;
 	else
-		val &= ~(MDIO_EEE_100TX | MDIO_EEE_1000T);
+		val &= ~mask;
 
 	phy_write_mmd(phydev, MDIO_MMD_AN, BCM_CL45VEN_EEE_ADV, (u32)val);
 
-- 
2.25.1

