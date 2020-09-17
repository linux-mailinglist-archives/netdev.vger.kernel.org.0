Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A965D26D1DD
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 05:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgIQDnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 23:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgIQDnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 23:43:20 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58103C061756
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 20:43:19 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id o16so539336pjr.2
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 20:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mSoNbvOVf3RC8KTFvaLWCOIEZgc75lAFVk73Kx6X7z4=;
        b=osPiRtU0mUSKfA1yITqpA9R5aseIayhlvzpXzPjqSABLpq7rIas6VFT88uf971ONOz
         nZqFdFVdBtpch5J9vHTsdw9+YjCsxtjCgTrASQownVxGGr9MatcsUGm8YUxnh5UKNy4x
         sL6aiOIxfsHNTLAps92OkjbIQoaBnT4uybJ51Z4x8yfpQiBKOOxcV3aQZFVI34eL0+yv
         RYT11Od5yDwgLypzrPzuaCD1MWiLUuDkBJX9T3PMC4LyVfXcoYSyW2TX+dOn2gzUuHqV
         SdET4/zgvaq0q2k1DfXcVCZ59EJjxkhQigvLEeUAQcwcDeSqe2mGx2Q6fDKkJ00LXhTd
         VLNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mSoNbvOVf3RC8KTFvaLWCOIEZgc75lAFVk73Kx6X7z4=;
        b=bpg+uVuSGWQyOAeRqq16tVn37hWm8xRbMUKjVh/yz4lx4xVBoE9WBYSXJZRCXXhoqq
         ZcWgkm1l27XsUTHBxg1f2ptKCWWp87wJ31nom8Tg1fX4BlVX+1LjFM7KLT/wlKny0yLe
         tVLBdUII3auwt4UFjEj5tcmoMG9jJbgPqtXtLiGceFFtXXS4b+W+v4vyWN/FrYN5fIDK
         rDXHbV7I0CIVEYgK8seah3Cpq9DmmksdUhPQwYlyS7xLmxlI29ivTrQuQUDgN+OzEeJU
         Qrv5SfhCtN0g954DiXVjulN8kv4lDzZCIiDyqWcITm1Ytfpe2jA+aY2yGxg3GpA7JaQQ
         NuNg==
X-Gm-Message-State: AOAM5324rKOYZfqUSneKCD6EoGAZJp2Tj9CMCs6pA4zPiTIVaLZGDP2p
        wLlmb4TZNTaO7ZS9J/jRd0Yf57jH3NXyOA==
X-Google-Smtp-Source: ABdhPJwPk31XU9nzw/TuhSCFpjMTrczHnpM7xxuQF9XqTUYVSdoGW7Gb0d7+6j9yfbFxera4p6lBOg==
X-Received: by 2002:a17:902:5992:b029:d1:e5e7:be7b with SMTP id p18-20020a1709025992b02900d1e5e7be7bmr8675746pli.85.1600314198541;
        Wed, 16 Sep 2020 20:43:18 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i187sm15810116pgd.82.2020.09.16.20.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 20:43:17 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, kuba@kernel.org, davem@davemloft.net
Subject: [PATCH net 1/2] net: phy: Avoid NPD upon phy_detach() when driver is unbound
Date:   Wed, 16 Sep 2020 20:43:09 -0700
Message-Id: <20200917034310.2360488-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200917034310.2360488-1-f.fainelli@gmail.com>
References: <20200917034310.2360488-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we have unbound the PHY driver prior to calling phy_detach() (often
via phy_disconnect()) then we can cause a NULL pointer de-reference
accessing the driver owner member. The steps to reproduce are:

echo unimac-mdio-0:01 > /sys/class/net/eth0/phydev/driver/unbind
ip link set eth0 down

Fixes: cafe8df8b9bc ("net: phy: Fix lack of reference count on PHY driver")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/phy_device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 8adfbad0a1e8..81eb76a8295b 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1682,7 +1682,8 @@ void phy_detach(struct phy_device *phydev)
 
 	phy_led_triggers_unregister(phydev);
 
-	module_put(phydev->mdio.dev.driver->owner);
+	if (phydev->mdio.dev.driver)
+		module_put(phydev->mdio.dev.driver->owner);
 
 	/* If the device had no specific driver before (i.e. - it
 	 * was using the generic driver), we unbind the device
-- 
2.25.1

