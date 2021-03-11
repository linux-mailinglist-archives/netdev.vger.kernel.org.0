Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37B9C336B42
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 05:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhCKExt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 23:53:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbhCKExs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 23:53:48 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64756C061574;
        Wed, 10 Mar 2021 20:53:48 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id t18so2849414pjs.3;
        Wed, 10 Mar 2021 20:53:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G/ZyAlrdSh96R2OBAg45j1/mBvyZvy2vStgPDbFN5p4=;
        b=WqiklgzivzpudRP+SwG7E8o+XdV/4uoKhYDxwsjgC3r8b3rcEQGiKy6AJdCW5rNcZp
         Acvdr7+l/OfuBW3yCiVvGFL5KvsBWun2OuYsIDtONqxOV25PEpgMIP+fwkzIA7fL5b8n
         XCWhGCb4PNPHLIa3i/VpMVoII1jv5y/+uPcfyPkmguZr2NMOAYBmFpv5EENKUcP6+s8d
         JuLsqHuJw+2CT5e5RwpmUtkNCH3Fi904CyDjf8NgeHkDOblwWPi3l+vBjx3sUTwPXnge
         GC8shKA4G9W5lfA8JXj5Y982lkexoWvMEcJevHu/SQekdsi5p8/6Xkq+9Fe7vWl6Kk81
         uOjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G/ZyAlrdSh96R2OBAg45j1/mBvyZvy2vStgPDbFN5p4=;
        b=SOi/4ydGEFz80MiJA1EFyPnvbaX0jIQi35uQTZ8000X5wy2EU2CtRQ13gzq1+N9bta
         ivWQbGg07fTmk5P0FbuWJA8nipQ2dVF4/8nVvoPvFPongZ6+pJl/U/WRlld2n+lKW6mw
         7F5a4asC/gL7s9GXrVsizagoCDY05FJvczWX0WPCemWLW1S3M1AittCb/mq4IIodJH/e
         xiV2/HNmU7Gmp6LiuuZYut10tjXYja7gkid61tW/FWVC2ooYoREPqvqcMWhL0R87I5Xz
         fbp3d1wJ6xSj1Qvi48gauPKyUK4l3v0cbGi7u6IgjTdkJGatgvfyALnKkEVLUFeApyhh
         o8lA==
X-Gm-Message-State: AOAM530449yCtdHvo2RmqdH9itYgh4NGjuzbKI+1feE919xSePcqGusS
        oe1sX5dzdrnSIrbrjcUT1++bl3jqNMA=
X-Google-Smtp-Source: ABdhPJxK6RnO0t6cZRRDNm3qM/giX93t36xte/dGSz2AapcDKKpswbOec6AvcmGSLVqBIQsjpAPuUg==
X-Received: by 2002:a17:90a:5d09:: with SMTP id s9mr6871777pji.172.1615438427336;
        Wed, 10 Mar 2021 20:53:47 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s4sm887710pji.2.2021.03.10.20.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 20:53:46 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM ETHERNET PHY
        DRIVERS), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net v2] net: phy: broadcom: Add power down exit reset state delay
Date:   Wed, 10 Mar 2021 20:53:42 -0800
Message-Id: <20210311045343.3259383-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Per the datasheet, when we clear the power down bit, the PHY remains in
an internal reset state for 40us and then resume normal operation.
Account for that delay to avoid any issues in the future if
genphy_resume() changes.

Fixes: fe26821fa614 ("net: phy: broadcom: Wire suspend/resume for BCM54810")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:

- make it build by using flseep()

 drivers/net/phy/broadcom.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index fa0be591ae79..ad51f1889435 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -399,6 +399,11 @@ static int bcm54xx_resume(struct phy_device *phydev)
 	if (ret < 0)
 		return ret;
 
+	/* Upon exiting power down, the PHY remains in an internal reset state
+	 * for 40us
+	 */
+	fsleep(40);
+
 	return bcm54xx_config_init(phydev);
 }
 
-- 
2.25.1

