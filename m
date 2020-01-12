Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A50713878F
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 18:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733174AbgALRfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 12:35:43 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40281 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732957AbgALRfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jan 2020 12:35:42 -0500
Received: by mail-pg1-f196.google.com with SMTP id k25so3554833pgt.7;
        Sun, 12 Jan 2020 09:35:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HV69n1sqlwCoeE6RtvaA5t9cef2ER7wcuo/YS6s88Ew=;
        b=q8ozB9BB5rSWksjJ6EcOWBHRubJTBy23cuWDS+nVzuRJ5tdkSw3HT+74UmTZvuT8ut
         wgSJHsk5HtyP6dloHeNLYdtAAb0VEfCkoa76yTUq4BAU+FrXLOvYCxHUFFasJ+wlp8pm
         C74VScwW/Drio/Ds8V1Gnys/8o4WyFw7W2izVUcqk62FLFyq/wfAHNHpGt52BeZ0cYIY
         x9rZNibB5oUo7fC/iVwR6j8KmQacW9+0mw+vAGHEWay47UK6Yh7nXhHnjTtljViXf3EJ
         1j88IaPWuYNqhXv8DPcWAc9GTs1pTzwKSB4QkqhItIBM1N5Brk1GmhWf8MCxSgPwZAXo
         Itpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HV69n1sqlwCoeE6RtvaA5t9cef2ER7wcuo/YS6s88Ew=;
        b=lAn8qfUihzJUdPkd8/eNK/4VJVHSaS1H1n2AZhvBK2JJ/8E0HH+vu37PxERxx0R73B
         fzpkJHS5ZDBTBKMkHgUQAmxjHer0zyh9bCiwQkSIYUu0IAuH2uuJd1vZ8v3uO/8TUj7s
         XXO1hjEudhhVxJbjLc8Wfmc9g9rzb+FCSLI5o6IKKjpvpC7EtfnK02fLYTRntU36FyCu
         agqU2ir6Nk6yn/OsQ/hqR0VbY+1DD6rvLN3ce5tSQpPmGZ+zoun7myrDDFE0g9yYz8hX
         UfMWdkT9nOA2HH5Cn5i9MOrwzBLYTG8vsN244jFoDGYF5yOEBKpMYuZnkgjrgsoGJDMu
         zCmg==
X-Gm-Message-State: APjAAAXjvY4fey+x8Z9e+f/l1S1gt0tHvP8B6U8rQ8ZiVNRcOsyhaamn
        JuiAKYONbYFd6Emuk/VFkw8Q9Sw6
X-Google-Smtp-Source: APXvYqyeEgRfOUKPiKviv2UctIzA+tz4njA/s6AWf7JhcjcGfgNP3FA3N8bjZcmz1+17J3ulmDGWvQ==
X-Received: by 2002:a63:6704:: with SMTP id b4mr17345507pgc.424.1578850541828;
        Sun, 12 Jan 2020 09:35:41 -0800 (PST)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id g21sm11098526pfo.126.2020.01.12.09.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jan 2020 09:35:41 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: phy: Added IRQ print to phylink_bringup_phy()
Date:   Sun, 12 Jan 2020 09:35:38 -0800
Message-Id: <20200112173539.18503-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The information about the PHY attached to the PHYLINK instance is useful
but is missing the IRQ prints that phy_attached_info() adds.
phy_attached_info() is a bit long and it would not be possible to use
phylink_info() anyway.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/phy_device.c | 12 ++++++++++--
 drivers/net/phy/phylink.c    |  7 +++++--
 include/linux/phy.h          |  2 ++
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index e5dc9f87f495..6a5056e0ae77 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1107,9 +1107,8 @@ void phy_attached_info(struct phy_device *phydev)
 EXPORT_SYMBOL(phy_attached_info);
 
 #define ATTACHED_FMT "attached PHY driver [%s] (mii_bus:phy_addr=%s, irq=%s)"
-void phy_attached_print(struct phy_device *phydev, const char *fmt, ...)
+char *phy_attached_info_irq(struct phy_device *phydev)
 {
-	const char *drv_name = phydev->drv ? phydev->drv->name : "unbound";
 	char *irq_str;
 	char irq_num[8];
 
@@ -1126,6 +1125,14 @@ void phy_attached_print(struct phy_device *phydev, const char *fmt, ...)
 		break;
 	}
 
+	return kasprintf(GFP_KERNEL, "%s", irq_str);
+}
+EXPORT_SYMBOL(phy_attached_info_irq);
+
+void phy_attached_print(struct phy_device *phydev, const char *fmt, ...)
+{
+	const char *drv_name = phydev->drv ? phydev->drv->name : "unbound";
+	char *irq_str = phy_attached_info_irq(phydev);
 
 	if (!fmt) {
 		phydev_info(phydev, ATTACHED_FMT "\n",
@@ -1142,6 +1149,7 @@ void phy_attached_print(struct phy_device *phydev, const char *fmt, ...)
 		vprintk(fmt, ap);
 		va_end(ap);
 	}
+	kfree(irq_str);
 }
 EXPORT_SYMBOL(phy_attached_print);
 
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 8d786c99f97a..efabbfa4a6d3 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -726,6 +726,7 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 {
 	struct phylink_link_state config;
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported);
+	char *irq_str;
 	int ret;
 
 	/*
@@ -761,9 +762,11 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 	phy->phylink = pl;
 	phy->phy_link_change = phylink_phy_change;
 
+	irq_str = phy_attached_info_irq(phy);
 	phylink_info(pl,
-		     "PHY [%s] driver [%s]\n", dev_name(&phy->mdio.dev),
-		     phy->drv->name);
+		     "PHY [%s] driver [%s] (irq=%s)\n",
+		     dev_name(&phy->mdio.dev), phy->drv->name, irq_str);
+	kfree(irq_str);
 
 	mutex_lock(&phy->lock);
 	mutex_lock(&pl->state_mutex);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 5932bb8e9c35..3a70b756ac1a 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1131,6 +1131,8 @@ static inline void phy_unlock_mdio_bus(struct phy_device *phydev)
 
 void phy_attached_print(struct phy_device *phydev, const char *fmt, ...)
 	__printf(2, 3);
+char *phy_attached_info_irq(struct phy_device *phydev)
+	__malloc;
 void phy_attached_info(struct phy_device *phydev);
 
 /* Clause 22 PHY */
-- 
2.19.1

