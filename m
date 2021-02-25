Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20AD6324866
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 02:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236730AbhBYBMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 20:12:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236705AbhBYBLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 20:11:38 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21726C061793;
        Wed, 24 Feb 2021 17:10:43 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id c19so2491696pjq.3;
        Wed, 24 Feb 2021 17:10:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+QAzmdz2J3myHOyB8tlALQV+gjhvFNmvosUKr/OQ9fw=;
        b=D99MJWF/QSM5mUouLSuN6lJWzDuVLhO06GVyHPklWXa0ouKV5SXSjxeX4QO7V/w8pr
         SYeBkLV54G8tHlnLePsqeNs8ZngcV+Lwdky2QyXyCr+LU2sgBT642v7LGgLcU/cf+f0b
         F7xWVtP5N5v1FE4hbFGAby8nDwbDsG4wdWEH3+NFEmnXRNVa3ndHk/3n3MZoRV2IxZDx
         blb3K89v6hM7LLBwJ8k9VC+5VUAGHeHQeczcJiYEF4dIEqYt5if3d/+YIjbZoobtst+O
         PGi7EIYDbYJIp9PTFSW8KNtTvNnLvfbavtMV6cvnK2Qz6QTWUdKoyVqNK0ce8ceWsKv4
         9Oog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+QAzmdz2J3myHOyB8tlALQV+gjhvFNmvosUKr/OQ9fw=;
        b=tf5yEruSe827IMDRcBoQoZo30tIdEoPplz5g567ImyD+KYFBNxGRiTQEJsuHOajphu
         FXgqU3dg8Dfc7IXvUcHj087Q4NvQIwVSDlMLwe57+TgkUFouW2cga8n7IONhzjBQqZb1
         ZEDgzCVFh4Hyumv7pXMvpUSX/SaEw5fe/d++qLKT2+BDWx14yms43s5UjObvVbjCoJb9
         2ZlZB2AhhlLUF7rKj8CxDAvpb09KpAV7O2r6dtnPUc328UYLbGeY2s3sAJFxBr4NA9G1
         4NL7VMrOgfG/Oif8izCpcmotbVebu6QHYrveAEaVmmL6lGLOMGgthYil7Bd8OI7Xgvnh
         ElRg==
X-Gm-Message-State: AOAM530On8xWXvgaDN7Leia0Ib77UeofAjQGSv67e9M/GPTXuTgWsou3
        xT0oUd7dOOQhQ1y/5tJWHUCkEr6eG3k=
X-Google-Smtp-Source: ABdhPJzYEzcQZU3Aw1kWPwY6+tvSiNMyHMX6KtCtYjJQUVYiiGaZrT+zxJQyUZL9utVB1QUNTGE/Sw==
X-Received: by 2002:a17:90b:806:: with SMTP id bk6mr672592pjb.16.1614215442244;
        Wed, 24 Feb 2021 17:10:42 -0800 (PST)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z11sm3503010pgk.65.2021.02.24.17.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 17:10:41 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list), stable@vger.kernel.org,
        gregkh@linuxfoundation.org, olteanv@gmail.com, sashal@kernel.org
Subject: [PATCH stable-5.10.y] net: dsa: b53: Correct learning for standalone ports
Date:   Wed, 24 Feb 2021 17:09:55 -0800
Message-Id: <20210225010956.946545-7-f.fainelli@gmail.com>
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
 drivers/net/dsa/b53/b53_common.c | 18 ++++++++++++++++++
 drivers/net/dsa/b53/b53_regs.h   |  1 +
 drivers/net/dsa/bcm_sf2.c        | 15 +--------------
 3 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 95c7fa171e35..f504b6858ed2 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -510,6 +510,19 @@ void b53_imp_vlan_setup(struct dsa_switch *ds, int cpu_port)
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
@@ -523,6 +536,7 @@ int b53_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy)
 	cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
 
 	b53_br_egress_floods(ds, port, true, true);
+	b53_port_set_learning(dev, port, false);
 
 	if (dev->ops->irq_enable)
 		ret = dev->ops->irq_enable(dev, port);
@@ -656,6 +670,7 @@ static void b53_enable_cpu_port(struct b53_device *dev, int port)
 	b53_brcm_hdr_setup(dev->ds, port);
 
 	b53_br_egress_floods(dev->ds, port, true, true);
+	b53_port_set_learning(dev, port, false);
 }
 
 static void b53_enable_mib(struct b53_device *dev)
@@ -1839,6 +1854,8 @@ int b53_br_join(struct dsa_switch *ds, int port, struct net_device *br)
 	b53_write16(dev, B53_PVLAN_PAGE, B53_PVLAN_PORT_MASK(port), pvlan);
 	dev->ports[port].vlan_ctl_mask = pvlan;
 
+	b53_port_set_learning(dev, port, true);
+
 	return 0;
 }
 EXPORT_SYMBOL(b53_br_join);
@@ -1886,6 +1903,7 @@ void b53_br_leave(struct dsa_switch *ds, int port, struct net_device *br)
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
index 445226720ff2..edb0a1027b38 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -222,23 +222,10 @@ static int bcm_sf2_port_setup(struct dsa_switch *ds, int port,
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

