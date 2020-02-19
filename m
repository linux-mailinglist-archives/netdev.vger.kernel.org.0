Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFED6164F6C
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 21:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbgBSUBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 15:01:02 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43289 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727400AbgBSUBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 15:01:00 -0500
Received: by mail-pg1-f194.google.com with SMTP id u12so621936pgb.10;
        Wed, 19 Feb 2020 12:00:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RiNEerjQz5Z1eXDKERAoR3iSV24FkTdaO7Og7MzVBAo=;
        b=vejW2eF9YVCfwvXLFdO7oBnXxTzCr3GGvUat95kJ4QLPc6T2nsgvMxA6mdQ8mtJ72s
         I4GmcNjEvXZHZEyPsBv8czWDyZYW7vzbpJOEZn3AIqCxRpKI/JTOSBrf9rPIq8Q8wYOn
         9zzum3CsP+iwJ3tYH7pKIAmMsbTYyQl01xbYppMYR8jzoUyMoq4pZY6vsApyqDss3jgJ
         3F8uzXMRHTfBmqvtbFPBtNmBXJw4eEbCU4swkPB1qBeyp+H8/EUYOMEvQlJCP9DnkWix
         fe8jOqmuYwJUGQ7uus7n9gq6W7flNuVWw6GcZUsm5aPr+VrEA4w2MAteuVJa24IAS5mS
         ZXyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RiNEerjQz5Z1eXDKERAoR3iSV24FkTdaO7Og7MzVBAo=;
        b=iCEF/qtdQUC487W9v8nMgtjcU0WUuBtbCVuUnxdTEzEdE3ExGDYUZ+Rwy4U6HTLvk7
         QCj+S0dsgGfqtClsa1muy2h5jLhnLDw1hqCjl27UAiDVrnE/aU8At3nOg4QrNLfta73Y
         K6VSosqVLC+GcoX03HLQ9m9F7nviv0DCaD9iEMLZb1xTLOz3EhWtgIRXDtzmnJ+irbL2
         0yBzXKADb7LS8tCjFdMw94dJzq5ZiXueN6mTvI2ZCRFdFxirxv0O1QXTZu+lBE3/0uaY
         Rf/bZiC9mEfl/MLlPM7sXs+RHB1ejxVclccqv6DAPoGsBloqcS/GwbeDQy4sxWQ93q0/
         7Q+g==
X-Gm-Message-State: APjAAAW+qxzHtTr+tDKJLeYJzPgPx+dHhsTUgkGZl/TklCc3qal5OTL6
        /YmeSxPR4f3wmd20Ps7c3WhjxYZN
X-Google-Smtp-Source: APXvYqxyT5OfEgISAVi3F6wxO1u24WUOdtGkq5Gk7BAa1bcVY+i9uDxrlZLzIrtOZre2vQCgIj/6lQ==
X-Received: by 2002:a63:ed49:: with SMTP id m9mr28928851pgk.304.1582142459267;
        Wed, 19 Feb 2020 12:00:59 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2sm625926pjv.18.2020.02.19.12.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 12:00:57 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v2 3/3] net: phy: broadcom: Wire suspend/resume for BCM54810
Date:   Wed, 19 Feb 2020 12:00:49 -0800
Message-Id: <20200219200049.12512-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200219200049.12512-1-f.fainelli@gmail.com>
References: <20200219200049.12512-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BCM54810 PHY can use the standard BMCR Power down suspend, but needs
a custom resume routine which first clear the Power down bit, and then
re-initializes the PHY. While in low-power mode, the PHY only accepts
writes to the BMCR register. The datasheet clearly says it:

Reads or writes to any MII register other than MII Control register
(address 00h) while the device is in the standby power-down mode may
cause unpredictable results.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/broadcom.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index b4eae84a9195..ab24692a92c6 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -313,6 +313,20 @@ static int bcm54xx_config_init(struct phy_device *phydev)
 	return 0;
 }
 
+static int bcm54xx_resume(struct phy_device *phydev)
+{
+	int ret;
+
+	/* Writes to register other than BMCR would be ignored
+	 * unless we clear the PDOWN bit first
+	 */
+	ret = genphy_resume(phydev);
+	if (ret < 0)
+		return ret;
+
+	return bcm54xx_config_init(phydev);
+}
+
 static int bcm5482_config_init(struct phy_device *phydev)
 {
 	int err, reg;
@@ -706,6 +720,8 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_aneg    = bcm5481_config_aneg,
 	.ack_interrupt  = bcm_phy_ack_intr,
 	.config_intr    = bcm_phy_config_intr,
+	.suspend	= genphy_suspend,
+	.resume		= bcm54xx_resume,
 }, {
 	.phy_id		= PHY_ID_BCM5482,
 	.phy_id_mask	= 0xfffffff0,
-- 
2.17.1

