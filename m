Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C97C8164F6A
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 21:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbgBSUA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 15:00:59 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44714 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbgBSUA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 15:00:58 -0500
Received: by mail-pf1-f194.google.com with SMTP id y5so588837pfb.11;
        Wed, 19 Feb 2020 12:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KVW7aJ+ZMAxJTXWp12kuW+W7LTI/JHCf7SczU6ZKwhI=;
        b=ps5iQHRj1l1mbA2m6Cti8w57gnrdSgWMt3pzwwli2eKZwBF6l+YyZ92CmxOIaYB3gx
         ScSdJMY/JnWyPkJlgtx+YVE1dGCz8CckNotx4UMEvEAqnCH2+nB6+V+z4wgdD8V45Lx4
         Z8CWaycEs5aWxs6gB06Zr2hiMv+bjrPtUZaryY7220RZiPy4YjCbRj0QaETc1Uld6C7O
         IvCrByv/9GkgwjNY36HBgBqteAn0kDHx9PoTPVYB3JQdXlCYkUEyJ+V824GTJJIVGEBt
         mEOMjMM+QFGWHH1tbG2aJYS95agEt+irbqY/21zH+0EFY7Oe6FZZhyOdchWhHPjK7rFh
         7k0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KVW7aJ+ZMAxJTXWp12kuW+W7LTI/JHCf7SczU6ZKwhI=;
        b=tZIP5fFH7SnTyFH2KqV80p3gTV5NbAIyc+YIHpnlluUEdni0U1ENhGMKrjhG+QF9Sq
         JqbmmmfTYPhuV6nqe+7W1afGmsnWUOYzk7+jiq65pOjHvWXi7IYPIHI1EzEJUX2YUlqZ
         2ujuaT59ZfmfOApawaWfRckE9im4n0ta1fYicni7ZpXNBQcGCTZWzejvTZ8OitC+R8OA
         6FA1VR1swyCLkHrV0OEH0QzoiF7dsO6ap9yMUkiW6FAdVg9T6ZRI3MTlPduyv0R2ag3Z
         4R3k2RUJtlZ9eYmMuGOcA9cdS18ox2i0EGZSBR44BTytcXBquC1fxtsJBzMqwwzFN2QG
         YL6g==
X-Gm-Message-State: APjAAAUfZYuTL+OJOnxV+CKBaKOM2NMOOtMlA7tQ2foY4ZpGBrK8LeHh
        ZL2y7miUekgRUSN75h3pXyLyJpXY
X-Google-Smtp-Source: APXvYqynuiAzerwpAEkXu4MiileARDWrc2ulqnV1g1e8unXuR1rU8yfxbr5HG1yOZVKAMgWURs01yw==
X-Received: by 2002:a63:561c:: with SMTP id k28mr3128521pgb.392.1582142456675;
        Wed, 19 Feb 2020 12:00:56 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2sm625926pjv.18.2020.02.19.12.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 12:00:55 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v2 2/3] net: phy: broadcom: Have bcm54xx_adjust_rxrefclk() check for flags
Date:   Wed, 19 Feb 2020 12:00:48 -0800
Message-Id: <20200219200049.12512-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200219200049.12512-1-f.fainelli@gmail.com>
References: <20200219200049.12512-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bcm54xx_adjust_rxrefclk() already checks for PHY_BRCM_AUTO_PWRDWN_ENABLE
and PHY_BRCM_DIS_TXCRXC_NOENRGY in order to set the appropriate bit. The
situation is a bit more complicated with the flag
PHY_BRCM_RX_REFCLK_UNUSED but essentially amounts to the same situation.

The default setting for the 125MHz clock is to be on for all PHYs and
we still treat BCM50610 and BCM50610M specifically with the polarity of
the bit reversed.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/broadcom.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 4ad2128cc454..b4eae84a9195 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -273,10 +273,7 @@ static int bcm54xx_config_init(struct phy_device *phydev)
 	    (phydev->dev_flags & PHY_BRCM_CLEAR_RGMII_MODE))
 		bcm_phy_write_shadow(phydev, BCM54XX_SHD_RGMII_MODE, 0);
 
-	if ((phydev->dev_flags & PHY_BRCM_RX_REFCLK_UNUSED) ||
-	    (phydev->dev_flags & PHY_BRCM_DIS_TXCRXC_NOENRGY) ||
-	    (phydev->dev_flags & PHY_BRCM_AUTO_PWRDWN_ENABLE))
-		bcm54xx_adjust_rxrefclk(phydev);
+	bcm54xx_adjust_rxrefclk(phydev);
 
 	if (BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54210E) {
 		err = bcm54210e_config_init(phydev);
-- 
2.17.1

