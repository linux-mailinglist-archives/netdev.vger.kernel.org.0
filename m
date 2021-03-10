Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B2C33490A
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 21:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbhCJUlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 15:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbhCJUle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 15:41:34 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6A8C061574
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 12:41:34 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id p21so12180431pgl.12
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 12:41:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ij8Hc6almb7rYgIAUR8gU2x64ABzwdSHskk6pI5i4u4=;
        b=W97tR+C64ciKlRcjzq0+vvPSz5CzR6YgvYr72bWqekGj3JKak4Qr2y0veWoc6rwal1
         lZqPUpT9hfeKwV7dVujPw85frGnDd+EVWhkkjnwX6a663cOGayyLkUOHifN7zJWeSWAY
         xZg/2hnblVjUPsB1su3DRp8mD5i7evp+kBQ9IxAuGHQnK4GMFptiytlJbZ7KeEWNPbXM
         QDY3Nt09IpJK5Qd9DAxpvctSnyydY78GO7oqbTKhw7N3D0UA96B00kFZV9/hLnywXQhL
         ed3+4vsjMoC7g9ABE9y0vOSC/iXraZ2+7veGCR2abVp3/HjTV9en46B3K08w/Az+0lTC
         c4bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ij8Hc6almb7rYgIAUR8gU2x64ABzwdSHskk6pI5i4u4=;
        b=QzMUf8WzJrYcWATA9IMmnJRqDpc+dEPXI0E6kxlqc75kgQXOQBSahKB1ClMO1K/PpO
         0l86U2JEvqOABwFjPG8hFh27YCrRicWMA77MJ/mfe6JQZu6S2C/ViA0O+9Z6h06waqBl
         bqdmDl9Eo7wBeD7z1HfGpYaTUuK8MQ5MGZd9qDDcGxWoHBocaSGMZSp/19/xxUupuQeF
         D+yzGeL+NZDTxlvsSlU6waML2q/NZbvw+YXo5LfjO0tdeh7KE4z1HQF+y87PxUu97vCz
         a9HUsjNTruE5k0/9i0ZDfgSSsyBtw1gcFD8MrfNDAopaZVdPWGis1/XDUO+93Haxsmc4
         Uwgg==
X-Gm-Message-State: AOAM530av5ICS/gO3IOTsKkunPSbEql3w/Nzwdr5bmOxHliVaI3hzcqS
        dKvrDzuCCRgTZeON0w5oHyovqSJIl6c=
X-Google-Smtp-Source: ABdhPJy7D5FACyQB8QpqNh96vrh12oxoTmxUi+9SawcGKN1hlaWiroI+jGjiaA7L10McZlahPtE8Eg==
X-Received: by 2002:a63:4956:: with SMTP id y22mr4367845pgk.309.1615408893645;
        Wed, 10 Mar 2021 12:41:33 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 1sm370213pfh.90.2021.03.10.12.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 12:41:33 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, kuba@kernel.org, davem@davemloft.net
Subject: [PATCH net 2/3] net: phy: broadcom: Only set BMCR.PDOWN to suspend
Date:   Wed, 10 Mar 2021 12:41:05 -0800
Message-Id: <20210310204106.2767772-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210310204106.2767772-1-f.fainelli@gmail.com>
References: <20210310204106.2767772-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

B50212E PHYs have been observed to get into an incorrect state with the
visible effect of having both activity and link LEDs flashing
alternatively instead of being turned off as intended when
genphy_suspend() was issued. The BCM54810 is a similar design and
equally suffers from that issue.

The datasheet is not particularly clear whether a read/modify/write
sequence is acceptable and only indicates that BMCR.PDOWN=1 should be
utilized to enter the power down mode. When this was done the PHYs were
always measured to have power levels that match the expectations and
LEDs powered off.

Fixes: fe26821fa614 ("net: phy: broadcom: Wire suspend/resume for BCM54810")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/broadcom.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index b8eb736fb456..b33ffd44f799 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -388,6 +388,21 @@ static int bcm54xx_config_init(struct phy_device *phydev)
 	return 0;
 }
 
+static int bcm54xx_suspend(struct phy_device *phydev)
+{
+	/* We cannot perform a read/modify/write like what genphy_suspend()
+	 * does because depending on the time we can observe the PHY having
+	 * both of its LEDs flashing indicating that it is in an incorrect
+	 * state and not powered down as expected.
+	 *
+	 * There is not a clear indication in the datasheet whether a
+	 * read/modify/write would be acceptable, but a blind write to the
+	 * register has been proven to be functional unlike the
+	 * Read/Modify/Write.
+	 */
+	return phy_write(phydev, MII_BMCR, BMCR_PDOWN);
+}
+
 static int bcm54xx_resume(struct phy_device *phydev)
 {
 	int ret;
@@ -778,7 +793,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_aneg    = bcm5481_config_aneg,
 	.config_intr    = bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
-	.suspend	= genphy_suspend,
+	.suspend	= bcm54xx_suspend,
 	.resume		= bcm54xx_resume,
 }, {
 	.phy_id         = PHY_ID_BCM54811,
-- 
2.25.1

