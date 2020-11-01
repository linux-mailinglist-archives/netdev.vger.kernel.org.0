Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA9D2A1E24
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 13:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgKAMzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 07:55:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbgKAMwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 07:52:30 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCFDAC0617A6;
        Sun,  1 Nov 2020 04:52:29 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id p9so14839257eji.4;
        Sun, 01 Nov 2020 04:52:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B4hIcxvuIxpOSLl8jptUO1Tl9pOVe5RCkJtYqFudld8=;
        b=QcgoL+ulodGpLKZWdgJo+peUYJ6rSNKjO/Qr/I821sf4Xw913+YD58zEi+jdL0F6mV
         z91aVrHFy6xVLXgHm6wXFZXGHgs0hzIDhYpWbybu4sdOFpRiexzi7+MhWn89h+lbmoFX
         BSpW14v3DMZP88bNaf/+SS3WQFNhK0O1HBWdU9J5Yir60/arNvOrV9cgntjhqbjbixNN
         7Jlzt7Z/TUZWx0shJFlPkJj9RKvHM/L2A+/o8luDAj5SH72uQp1WvhkerzieDLY1e920
         XEQgBU/Vyhmix5SLbpqKxdxoH3+OyHn8kSDpsMtPF5B6thIIDYoi9ojr/CSAmJvtxfc1
         U2IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B4hIcxvuIxpOSLl8jptUO1Tl9pOVe5RCkJtYqFudld8=;
        b=R7WC4FQ3Slczh7FCEPoKBb9I3wQtRAfOSW3FtwPtR8ql3zqRCn+LGBiS52zd4i8vZn
         +1lqxx7hMsDthkVGJldigTLgDUUabBdrPhANH5nEHvFmkV9cmQ8vgIw3F+FM5CVjNPrg
         ll5+wYZ73/528zeDs21SW+r1FuFGStZAE7dBuOALNPHC7Ob5++v+N6vBLlxrR21xMaLg
         0v/3G7EacU49GQWk8khaqnkQ2qlOZQ3pjBxY9dp2U8HdSgiFt/cVwGuqbguuBIkrIBas
         oXlYYio9254JRXd2E4l2iH+ZEYv36YPgi6lkwOJYsO51FVfMFBiHutW2KcDG8PCXXabZ
         pinQ==
X-Gm-Message-State: AOAM533++nYPcHocScQ9B8HMLc6Iv8sZYB4CZ9QZc4hX6AMlzHs9waFx
        C9Kp9zkEVF9fshW8MngbUOC7dCY6BjwrrzIT
X-Google-Smtp-Source: ABdhPJwQtPi+5yw7YreBZuuieC4fenHh245iM5Sd1iAUjwD1KQgFjCeE+yJwlEz8a3AesFm0io/LWA==
X-Received: by 2002:a17:906:1183:: with SMTP id n3mr10794686eja.188.1604235148508;
        Sun, 01 Nov 2020 04:52:28 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c5sm8133603edx.58.2020.11.01.04.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 04:52:27 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 06/19] net: phy: mscc: use phy_trigger_machine() to notify link change
Date:   Sun,  1 Nov 2020 14:51:01 +0200
Message-Id: <20201101125114.1316879-7-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201101125114.1316879-1-ciorneiioana@gmail.com>
References: <20201101125114.1316879-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

According to the comment describing the phy_mac_interrupt() function, it
it intended to be used by MAC drivers which have noticed a link change
thus its use in the mscc PHY driver is improper and, most probably, was
added just because phy_trigger_machine() was not exported.
Now that we have acces to trigger the link state machine, use directly
the phy_trigger_machine() function to notify a link change detected by
the PHY driver.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none

 drivers/net/phy/mscc/mscc_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 6bc7406a1ce7..b705121c9d26 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -1498,7 +1498,7 @@ static irqreturn_t vsc8584_handle_interrupt(struct phy_device *phydev)
 		vsc8584_handle_macsec_interrupt(phydev);
 
 	if (irq_status & MII_VSC85XX_INT_MASK_LINK_CHG)
-		phy_mac_interrupt(phydev);
+		phy_trigger_machine(phydev);
 
 	return IRQ_HANDLED;
 }
-- 
2.28.0

