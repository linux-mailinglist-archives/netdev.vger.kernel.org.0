Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAFA23DC00
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 18:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729064AbgHFQmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 12:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729001AbgHFQkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 12:40:42 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AAB8C0086BC;
        Thu,  6 Aug 2020 08:39:20 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id v4so42602271ljd.0;
        Thu, 06 Aug 2020 08:39:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q5PIhTZ1k5FdG3NQbW/iiFuxA5Ifg1yNdI35SxS/Xwk=;
        b=qQGNBo6Ekik496p3/E13FqX0TMGK+7zedJcS9ukf6cmLtwnbAEhkXjXAbK7OHp5zjo
         /XPHpmUDEPKy8Iw38Q08tzeWDCaC/9ImokMgBOM+HRYwWv7ZdCjDiz8LibmRTeqN4BGD
         JYVlGgw/o3m3yuE14VtimRONafHPNADq7EkerpnxevEdfxQeHc2PP7JjDLlCHQ13vrnZ
         KIHN9/EjGf8fGNMsFBINqWmX6eJQUzr/h6XUcXnp9MgkyRAVehdfwdEajwjRkwwmiXeN
         uIiLMRZHyORk0e/nZ3sGaGObKos2UnoDouX31w8j6vQu2L+u3UpoBNuTxfY3hRic4Ny0
         xb0A==
X-Gm-Message-State: AOAM532XMv2iAljFtCbUMxAO+hbXbHoRKx+D9JZ/GYsb22XvWAsyqRd6
        N6YkizC2wXu/GqsLTevUGxQ=
X-Google-Smtp-Source: ABdhPJxkmm9iVoirzrxeN4OhGBs4mKGRNymtq+vksvikDKFhl16Z12DTSOySIPWDzecAwwEXojdHKg==
X-Received: by 2002:a2e:9196:: with SMTP id f22mr4160854ljg.435.1596728358635;
        Thu, 06 Aug 2020 08:39:18 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id v26sm2554919lji.65.2020.08.06.08.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 08:39:17 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@xi.terra>)
        id 1k3hzE-0003Cf-Up; Thu, 06 Aug 2020 17:39:21 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH net] net: phy: fix memory leak in device-create error path
Date:   Thu,  6 Aug 2020 17:37:53 +0200
Message-Id: <20200806153753.12247-1-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A recent commit introduced a late error path in phy_device_create()
which fails to release the device name allocated by dev_set_name().

Fixes: 13d0ab6750b2 ("net: phy: check return code when requesting PHY driver module")
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/phy/phy_device.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 1b9523595839..57d44648c8dd 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -615,7 +615,9 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 	if (c45_ids)
 		dev->c45_ids = *c45_ids;
 	dev->irq = bus->irq[addr];
+
 	dev_set_name(&mdiodev->dev, PHY_ID_FMT, bus->id, addr);
+	device_initialize(&mdiodev->dev);
 
 	dev->state = PHY_DOWN;
 
@@ -649,10 +651,8 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 		ret = phy_request_driver_module(dev, phy_id);
 	}
 
-	if (!ret) {
-		device_initialize(&mdiodev->dev);
-	} else {
-		kfree(dev);
+	if (ret) {
+		put_device(&mdiodev->dev);
 		dev = ERR_PTR(ret);
 	}
 
-- 
2.26.2

