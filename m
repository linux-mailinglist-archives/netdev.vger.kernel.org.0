Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2BC832222A
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 23:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbhBVWbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 17:31:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbhBVWa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 17:30:59 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A63C061786;
        Mon, 22 Feb 2021 14:30:18 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id l18so559797pji.3;
        Mon, 22 Feb 2021 14:30:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h/KntoK/CQtsozaIlBhJHdpvxiXz3xoyZJ1/l6lEJpc=;
        b=P9dXvFuKSXb0QOe1fjshkFxOVw3JgHb+TFzqE8bGOxYg01HzZxOdZfIv/8DMVRkWvo
         p9ouNfjehSo3IAGnmg4oluO/QtkPQWOAhu5XyLKiXrY5mJ63JyWVN51oBp+Qwj06IT7h
         Bzeuvgcb3E2Q2Fv63SJFb/6a+ygREiccuYSGIW+AkUk6dStuFm3V3FtYjsv7RWEneflS
         yYgGRsVpgvMc9DaL18WMANJjuxUNlWzc6+Wcpx1cz0sQFhVWPJJchA6PdjPjrgCDWqmE
         SUXJ3XOyMe7Cy6g7SOKegZvKsA4kgGzGmehHJGygvY48lRQ7GH4848ZTmFCKOrRU1L3s
         oy2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h/KntoK/CQtsozaIlBhJHdpvxiXz3xoyZJ1/l6lEJpc=;
        b=tY43Ih4Nlm3VhxIXBi5ZJlQUfX3oFWR8SNphVwSSNnN3RKImiXpRWVDRFKSQzH14GD
         oDcCJea9WLomeLeA/Xo9alyr3uRnWlxLAtOvxKuO+uqlZRYMoe0tUS2dxgLPN2wF5LM1
         GWsnXyvPn6NY+CUyGj7wD+T63xWpBW7qi+7+We/2tSg6CheSp06gQGauUKGLdJKKN1m8
         3Km5e/7X6dNWtgBQAagG8ahPKN5HpK6CUxsTsjCKG6K3/6DA+d4vH5PCk2a9B6cpsEad
         aCT8T8Lyje1/TsDExfYUlujBvUA+YbcptDu1OPtYpafoiWJQYPW4iBmL70cPt/PQTMAE
         Omwg==
X-Gm-Message-State: AOAM530SQ5xTqexhMLXoQdiodzO15SpsyBadQiqj/ms9ClXhTalFRUpX
        cV4a3beZ59pbnX5I8qZcPj3cQKHel7I=
X-Google-Smtp-Source: ABdhPJwSqg4rxDCmOP6GRBKICjBMsHEkzcwxqFLrm9h5VhfEFOdEhGRjKUJVWwD8a7di+HfHMKaRyA==
X-Received: by 2002:a17:90a:4146:: with SMTP id m6mr11289760pjg.118.1614033017181;
        Mon, 22 Feb 2021 14:30:17 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gg5sm495385pjb.3.2021.02.22.14.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 14:30:16 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net v2 2/2] net: dsa: b53: Support setting learning on port
Date:   Mon, 22 Feb 2021 14:30:10 -0800
Message-Id: <20210222223010.2907234-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210222223010.2907234-1-f.fainelli@gmail.com>
References: <20210222223010.2907234-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for being able to set the learning attribute on port, and
make sure that the standalone ports start up with learning disabled.

We can remove the code in bcm_sf2 that configured the ports learning
attribute because we want the standalone ports to have learning disabled
by default and port 7 cannot be bridged, so its learning attribute will
not change past its initial configuration.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 20 +++++++++++++++++++-
 drivers/net/dsa/b53/b53_regs.h   |  1 +
 drivers/net/dsa/bcm_sf2.c        | 15 +--------------
 3 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index fceca3f5b6a5..a162499bcafc 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -543,6 +543,19 @@ static void b53_port_set_mcast_flood(struct b53_device *dev, int port,
 	b53_write16(dev, B53_CTRL_PAGE, B53_IPMC_FLOOD_MASK, mc);
 }
 
+static void b53_port_set_learning(struct b53_device *dev, int port,
+				  bool learning)
+{
+	u16 reg;
+
+	b53_read16(dev, B53_CTRL_PAGE, B53_DIS_LEARNING, &reg);
+	if (learning)
+		reg &= ~BIT(port);
+	else
+		reg |= BIT(port);
+	b53_write16(dev, B53_CTRL_PAGE, B53_DIS_LEARNING, reg);
+}
+
 int b53_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy)
 {
 	struct b53_device *dev = ds->priv;
@@ -557,6 +570,7 @@ int b53_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy)
 
 	b53_port_set_ucast_flood(dev, port, true);
 	b53_port_set_mcast_flood(dev, port, true);
+	b53_port_set_learning(dev, port, false);
 
 	if (dev->ops->irq_enable)
 		ret = dev->ops->irq_enable(dev, port);
@@ -691,6 +705,7 @@ static void b53_enable_cpu_port(struct b53_device *dev, int port)
 
 	b53_port_set_ucast_flood(dev, port, true);
 	b53_port_set_mcast_flood(dev, port, true);
+	b53_port_set_learning(dev, port, false);
 }
 
 static void b53_enable_mib(struct b53_device *dev)
@@ -1957,7 +1972,7 @@ int b53_br_flags_pre(struct dsa_switch *ds, int port,
 		     struct switchdev_brport_flags flags,
 		     struct netlink_ext_ack *extack)
 {
-	if (flags.mask & ~(BR_FLOOD | BR_MCAST_FLOOD))
+	if (flags.mask & ~(BR_FLOOD | BR_MCAST_FLOOD | BR_LEARNING))
 		return -EINVAL;
 
 	return 0;
@@ -1974,6 +1989,9 @@ int b53_br_flags(struct dsa_switch *ds, int port,
 	if (flags.mask & BR_MCAST_FLOOD)
 		b53_port_set_mcast_flood(ds->priv, port,
 					 !!(flags.val & BR_MCAST_FLOOD));
+	if (flags.mask & BR_LEARNING)
+		b53_port_set_learning(ds->priv, port,
+				      !!(flags.val & BR_LEARNING));
 
 	return 0;
 }
diff --git a/drivers/net/dsa/b53/b53_regs.h b/drivers/net/dsa/b53/b53_regs.h
index c90985c294a2..b2c539a42154 100644
--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -115,6 +115,7 @@
 #define B53_UC_FLOOD_MASK		0x32
 #define B53_MC_FLOOD_MASK		0x34
 #define B53_IPMC_FLOOD_MASK		0x36
+#define B53_DIS_LEARNING		0x3c
 
 /*
  * Override Ports 0-7 State on devices with xMII interfaces (8 bit)
diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 3eaedbb12815..5ee8103b8e9c 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -223,23 +223,10 @@ static int bcm_sf2_port_setup(struct dsa_switch *ds, int port,
 	reg &= ~P_TXQ_PSM_VDD(port);
 	core_writel(priv, reg, CORE_MEM_PSM_VDD_CTRL);
 
-	/* Enable learning */
-	reg = core_readl(priv, CORE_DIS_LEARN);
-	reg &= ~BIT(port);
-	core_writel(priv, reg, CORE_DIS_LEARN);
-
 	/* Enable Broadcom tags for that port if requested */
-	if (priv->brcm_tag_mask & BIT(port)) {
+	if (priv->brcm_tag_mask & BIT(port))
 		b53_brcm_hdr_setup(ds, port);
 
-		/* Disable learning on ASP port */
-		if (port == 7) {
-			reg = core_readl(priv, CORE_DIS_LEARN);
-			reg |= BIT(port);
-			core_writel(priv, reg, CORE_DIS_LEARN);
-		}
-	}
-
 	/* Configure Traffic Class to QoS mapping, allow each priority to map
 	 * to a different queue number
 	 */
-- 
2.25.1

