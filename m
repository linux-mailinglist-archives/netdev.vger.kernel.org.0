Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23CA732485A
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 02:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236648AbhBYBL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 20:11:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235452AbhBYBLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 20:11:02 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7547FC061756;
        Wed, 24 Feb 2021 17:10:22 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id d11so2267609plo.8;
        Wed, 24 Feb 2021 17:10:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W5XSGEch+BExuGKBr4lniyKuRe4W+F14wv8bY0zf9vw=;
        b=vKpRaZuEP/PNVp0OUMi6mVKdEzK1wCVNmvEFph1cOXaw5uC+47EYQYhVDz31uJMtR8
         IQoG6rcPD1v3f0lb05ftEqWHUdvNCpXmPmO8ZSirm5wORPRzX9NQyj5HQsIy3qTj/i6o
         WnYiItTo7yNTZLYRorU/3e9BO3i/sWKGKxy5ygvld14WlzvfMgSz7Kb9ajyKs121HpZz
         un82LjbyVoWcPMIzwfJ7YtAJ54q63pIHXLc98eWhXPKZTT3PNbR35aGAlvEmG0eaRRhm
         aklcWpjlDdIhFF5noIEwSMA9IDFXezB/8TjaVTpq+OIsLqZcZORqKNohfFzmrChO9d/5
         IUyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W5XSGEch+BExuGKBr4lniyKuRe4W+F14wv8bY0zf9vw=;
        b=SBSuqoDk8Lv87MT+IwYWl+KNMzfmgrX4cZFfyJKYn9CxvUnfwHUVOoZ6Mrw0J/Cjhi
         GlsJqVTNZNeZ9I+804klqMUuhMA6GkJRRSTxFSxi/nN8zBF/a8ZeO5P1JKETxI/hlT4Z
         IxyrkpDQbDg36U90pCVRhz9NDlhoPpZm0IF9+hsQic421mfNfOprIR0znhhAZcBCIsYn
         CWxqf3psjMV19wn8dNJxXIzYThSS3XjsLXEP0scqj0ZrBjqLTvgeUJxx+D2YjRnRdPoq
         FfAGvPwH0XaPHuk958IV/5+Q+FPvRr38f5y/nzRksJxeF3wYMuAvSLwWhlLrygjQluMb
         BXMA==
X-Gm-Message-State: AOAM5336o/7s7Yv11yzSXZ6Dzr+49vio2cfBgbIM3WoY5hyLNQP2p6uv
        LYQie5eZ4XGlfNKFavuIyCBb2TWefzE=
X-Google-Smtp-Source: ABdhPJxoPDmeD5WvaAoxFPo3eA7QAsaaTmESGE2k3BEggDhnbBO5Oi4BsDWoOyISI5Z3yG9zN3g9xw==
X-Received: by 2002:a17:90a:4092:: with SMTP id l18mr639329pjg.1.1614215421567;
        Wed, 24 Feb 2021 17:10:21 -0800 (PST)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z11sm3503010pgk.65.2021.02.24.17.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 17:10:21 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list), stable@vger.kernel.org,
        gregkh@linuxfoundation.org, olteanv@gmail.com, sashal@kernel.org
Subject: [PATCH stable-4.19.y] net: dsa: b53: Correct learning for standalone ports
Date:   Wed, 24 Feb 2021 17:09:51 -0800
Message-Id: <20210225010956.946545-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210225010956.946545-1-f.fainelli@gmail.com>
References: <20210225010853.946338-1-f.fainelli@gmail.com>
 <20210225010956.946545-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Standalone ports should not have learning enabled since all the frames
are always copied to the CPU port. This is particularly important in
case an user-facing port intentionally spoofs the CPU port's MAC
address. With learning enabled we would end up with the switch having
incorrectly learned the address of the CPU port which typically results
in a complete break down of network connectivity until the address
learned ages out and gets re-learned, from the correct port this time.

There was no control of the BR_LEARNING flag until upstream commit
4098ced4680a485c5953f60ac63dff19f3fb3d42 ("Merge branch 'brport-flags'")
which is why we default to enabling learning when the ports gets added
as a bridge member.

Fixes: 967dd82ffc52 ("net: dsa: b53: Add support for Broadcom RoboSwitch")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 19 +++++++++++++++++++
 drivers/net/dsa/b53/b53_regs.h   |  1 +
 drivers/net/dsa/bcm_sf2.c        |  5 -----
 3 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 335ce1e84904..7eaeab65d39f 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -507,12 +507,27 @@ void b53_imp_vlan_setup(struct dsa_switch *ds, int cpu_port)
 }
 EXPORT_SYMBOL(b53_imp_vlan_setup);
 
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
 	unsigned int cpu_port = ds->ports[port].cpu_dp->index;
 	u16 pvlan;
 
+	b53_port_set_learning(dev, port, false);
+
 	/* Clear the Rx and Tx disable bits and set to no spanning tree */
 	b53_write8(dev, B53_CTRL_PAGE, B53_PORT_CTRL(port), 0);
 
@@ -620,6 +635,7 @@ static void b53_enable_cpu_port(struct b53_device *dev, int port)
 	b53_write8(dev, B53_CTRL_PAGE, B53_PORT_CTRL(port), port_ctrl);
 
 	b53_brcm_hdr_setup(dev->ds, port);
+	b53_port_set_learning(dev, port, false);
 }
 
 static void b53_enable_mib(struct b53_device *dev)
@@ -1517,6 +1533,8 @@ int b53_br_join(struct dsa_switch *ds, int port, struct net_device *br)
 	b53_write16(dev, B53_PVLAN_PAGE, B53_PVLAN_PORT_MASK(port), pvlan);
 	dev->ports[port].vlan_ctl_mask = pvlan;
 
+	b53_port_set_learning(dev, port, true);
+
 	return 0;
 }
 EXPORT_SYMBOL(b53_br_join);
@@ -1564,6 +1582,7 @@ void b53_br_leave(struct dsa_switch *ds, int port, struct net_device *br)
 		vl->untag |= BIT(port) | BIT(cpu_port);
 		b53_set_vlan_entry(dev, pvid, vl);
 	}
+	b53_port_set_learning(dev, port, false);
 }
 EXPORT_SYMBOL(b53_br_leave);
 
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
index 613f03f9d9ec..e9fe3897bd9c 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -173,11 +173,6 @@ static int bcm_sf2_port_setup(struct dsa_switch *ds, int port,
 	reg &= ~P_TXQ_PSM_VDD(port);
 	core_writel(priv, reg, CORE_MEM_PSM_VDD_CTRL);
 
-	/* Enable learning */
-	reg = core_readl(priv, CORE_DIS_LEARN);
-	reg &= ~BIT(port);
-	core_writel(priv, reg, CORE_DIS_LEARN);
-
 	/* Enable Broadcom tags for that port if requested */
 	if (priv->brcm_tag_mask & BIT(port))
 		b53_brcm_hdr_setup(ds, port);
-- 
2.25.1

