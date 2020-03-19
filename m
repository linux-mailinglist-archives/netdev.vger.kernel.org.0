Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0465F18BCCC
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 17:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728492AbgCSQkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 12:40:12 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37898 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728432AbgCSQkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 12:40:10 -0400
Received: by mail-pl1-f195.google.com with SMTP id w3so1289959plz.5;
        Thu, 19 Mar 2020 09:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rloxk6KMCAo15cdBgyeSFkOgJtDa0iK4er6MLSygxnM=;
        b=HFkF8QSGupPui+FkbaKz9W7f7mPU/zJLozyW3bNBk8FTMC4pRZvP5VyAqeksWESTdp
         SFL/LtRXqN/FKJSowXPkGAajU4V7S7ZieNw13lifOvJO49gXACyuINGass2Gnb4JTpAe
         I2EkleacykKij6EyP0Evy738HjmjHqvg6DSvlZ1bMKdQxJZiiOM9JkwkXjrKCgfZRwVn
         bzL06dV8cD2YHy96hxHAZg65Vjap62fYo1TOt1RBkLYEDsk9i3CXb1RDoynA6AGgKH/8
         tetEXeq1PKs1t9KX1dsFAerrrRIlo2UGiXnDlcPQaP+86YyXbaSOT8G37H0p6PVY9+Mo
         a1MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rloxk6KMCAo15cdBgyeSFkOgJtDa0iK4er6MLSygxnM=;
        b=Z72/oIwvNtC8QaEnwasuZU6StloeDDT5vFP5ZowIsFnGpWXL3FUo1gHdFMFa62itf9
         L61VRGe0rrNDstZFdX2juxXpM6XyQkKIIAiojuf9pzA8O/zIy0qBLWckL8NboJmck4wY
         xgWKmLHiGXnO5EHbC9pv6VMxzSjJihYQRCQC2C1KTyjhkM+gdwuVlAHHHfqZftG8bh4r
         AlktCmyb8DGUtHPaHg5D9DWBERkAa+V2Qt60VSJ9m0+hu30ahEuOVKAHSZwSv8d5vOqM
         7z03mCRrqtTxopzvmNRXxoYQzAq7msk83VWVWmfqcnLZyOA+YTKpqMDjR33fOiExUDwz
         B+8Q==
X-Gm-Message-State: ANhLgQ0obqFhZ1fe+di2vWE4vk6PE5zwAzMjJYPRma1EJf540qW9Q/1v
        8+OS0sZOL9yYM8XkcBvbn1Y=
X-Google-Smtp-Source: ADFU+vvGLY5Jg2hx8JZtyRJCy4FXsgiEnPyudeI1CAF6O3Qdb2dCh2tbOMnwypcBZvv8T+z9R4NMaA==
X-Received: by 2002:a17:90b:355:: with SMTP id fh21mr4610476pjb.147.1584636010133;
        Thu, 19 Mar 2020 09:40:10 -0700 (PDT)
Received: from localhost ([216.24.188.11])
        by smtp.gmail.com with ESMTPSA id u12sm2922357pfm.165.2020.03.19.09.40.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 19 Mar 2020 09:40:09 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, tglx@linutronix.de,
        broonie@kernel.org, corbet@lwn.net, mchehab+samsung@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next 6/7] net: phy: introduce phy_read_poll_timeout macro
Date:   Fri, 20 Mar 2020 00:39:09 +0800
Message-Id: <20200319163910.14733-7-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200319163910.14733-1-zhengdejin5@gmail.com>
References: <20200319163910.14733-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

it is sometimes necessary to poll a phy register by phy_read()
function until its value satisfies some condition. introduce
phy_read_poll_timeout() macros that do this.

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
 include/linux/phy.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index a30e9008647f..a28cc16fdaac 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -714,6 +714,9 @@ static inline int phy_read(struct phy_device *phydev, u32 regnum)
 	return mdiobus_read(phydev->mdio.bus, phydev->mdio.addr, regnum);
 }
 
+#define phy_read_poll_timeout(val, cond, sleep_us, timeout_us, args...) \
+	read_poll_timeout(phy_read, val, cond, sleep_us, timeout_us, args)
+
 /**
  * __phy_read - convenience function for reading a given PHY register
  * @phydev: the phy_device struct
-- 
2.25.0

