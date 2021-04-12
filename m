Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1178535D3FE
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 01:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238967AbhDLXbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 19:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237776AbhDLXbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 19:31:24 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0CBC061574;
        Mon, 12 Apr 2021 16:31:06 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id q10so10589098pgj.2;
        Mon, 12 Apr 2021 16:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PjahROLYxLkItibP1nYgnQjPDeCkVdG73GnROFyRGUk=;
        b=s7OduWsmdbp2FyJ4edYCmtWnalTE+jxvlt6T9SjXRPYsS2kFD054/DbD6LXuzaRPqW
         QV3pGl/e1mAidP0/tgTFvLPqNA1vYaX5v/UmuqrJR1xuxYcpTccauPQYD4Nqd58fwW6y
         y5Dn2X10DUDTGS6Gt5K98HJAs9I7QjrqEcP7qxYomI5oNzRj0LQLJSjLdsv3DeX0TqqJ
         hM7PfdJmMUGjJFCK6UBelIVzcdMlgDqdP52TsbQi9qEgm1/AkTHL1g6nYk018Tm/LzN1
         MIcbBZtyZ4jCx5ETOgRE5MBaRFdJQ1HepfEeUsJwAfyo9ZfA87WErT/7icY/tM+KQ7th
         LWtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PjahROLYxLkItibP1nYgnQjPDeCkVdG73GnROFyRGUk=;
        b=Dqfu1LpWKiqCy/VmErr/wt9GzyIGP6LCeFxVpcGJJNDclUJ0vstrE/Gh4vJqKOMm0m
         NCvxCYrv9VRRQGUjrdPKrXewMcQ8EdUSdNyMuzVb0p2kHslgeurnMbvDH/y4AOJr1hDy
         eC72n7jFpCRf4Zv1ijk6iRFAE3FWS+ehczETJgpymJnGlJdXwvE9njzjdad17qJdHgA4
         rJBFVQg+aSOznk2LNxWJU2V6jI6htTgzDBui5JRneKh5KI3UWo1+10kfU+9bRjHMyyfc
         j57YmcDTNVHA9B5k0YQ/OCA9xd1uWFykf2Cak1FvtQm6Q0SaqDw9uRO3xUiLIaQvjbLU
         B8Bw==
X-Gm-Message-State: AOAM532UnmEyXb5qtCZQAOfa1QhpEXyt1TLBFD58bCAWlHvMM15cZICH
        NU4exgxhRWAW4yZvo170mDPLdJC6XNo=
X-Google-Smtp-Source: ABdhPJwchi6NWQ+08k961jXdwiV/+MN49hmE4H353w40YX5Iug7pw7Y4N0cFbQYnxkdQby4OernHgA==
X-Received: by 2002:a65:5203:: with SMTP id o3mr13233800pgp.305.1618270265281;
        Mon, 12 Apr 2021 16:31:05 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l10sm10619682pfc.125.2021.04.12.16.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 16:31:04 -0700 (PDT)
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
Subject: [PATCH stable 4.14] net: phy: broadcom: Only advertise EEE for supported modes
Date:   Mon, 12 Apr 2021 16:31:01 -0700
Message-Id: <20210412233102.3301765-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210412022325.284395-1-sashal@kernel.org>
References: <20210412022325.284395-1-sashal@kernel.org>
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
index d5e0833d69b9..66e4ef8ed345 100644
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

