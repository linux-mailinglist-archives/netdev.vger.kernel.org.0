Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A841432485D
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 02:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236677AbhBYBLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 20:11:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236502AbhBYBLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 20:11:07 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F899C061786;
        Wed, 24 Feb 2021 17:10:27 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id f8so2273523plg.5;
        Wed, 24 Feb 2021 17:10:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RPlS17Li+Ps4JCfS5GMNYek0uWlfFA+sAc6YzpJh9Cw=;
        b=dKxguE9YHb1mPQfmYbDzdUsYXDamhd4GGnrdEamTYZjDb1acm4/12rw+48ekOHDOvT
         XPogd36psy1zGWSftbliwcAV7O/88IRssXyIAkQXZRsZoADvFQjc/uLPqLw1DbbReJ8+
         1VcS9XsHTfQITrLThI3UUz6T7eBip+9elMp/DiqDEKrZmXgn39Ud6tFqLacg9/4zeqJ3
         v+gUlbObXJV1LSq4AhYoR2VZQc2cZ4DV2zaaxvxOlAMGZE0PNIxosRJg9UNbWmUdVzSR
         Nkd8bVdJAhqUI7W+vikPoXFqSPXtZ9qb53cJN/KaPOl9vjoND23j52wXCiT+GasQ/qjq
         mEtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RPlS17Li+Ps4JCfS5GMNYek0uWlfFA+sAc6YzpJh9Cw=;
        b=MzZIenNVwqgbCjHSmyHoKVrEOegyfzMM6jfaulDVOCwaTHeO/JZEpSF7Ya5f+nvrB3
         jjyXK3Pk7RK1EBVgWycQaDqPkdkk/GvZgUijmWZcCzHkLlLS93+VIaml6DlNsXzw0mtK
         15VOep2AKrZdL17EVERdz2UQqaEzXkNiItURusqIggJUW66ggKbnCDN55tMVVi5886Kz
         5LKG5+3ixoHxpZtupUeDDCmT/GEq6B84BPYclbFXefE43QLzoKi/X4cspzF+7Eqf5JcN
         BYzo2jvqLkfwMjDwZMhhcGKtRcIZ7HpsY98mrDauqwzj1ZptTl6j459ii4J7FyyC/Kdk
         IBFA==
X-Gm-Message-State: AOAM530voqj2iBoIndm8nKMOoTJ+qpAqLb/KcojJ29GzGaBB6LMaMFwF
        TlvBW7c1Ze5BZmao6B3w41VCI9Usfhc=
X-Google-Smtp-Source: ABdhPJwgOcAlpG7Pps4imdxe11Wj9ouzedmv5oDo6t2H3qrz8FP+bCF6SzgT21EG4fqZnQ351UjkFQ==
X-Received: by 2002:a17:902:8c97:b029:e2:8c58:153f with SMTP id t23-20020a1709028c97b02900e28c58153fmr735186plo.79.1614215426730;
        Wed, 24 Feb 2021 17:10:26 -0800 (PST)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z11sm3503010pgk.65.2021.02.24.17.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 17:10:26 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list), stable@vger.kernel.org,
        gregkh@linuxfoundation.org, olteanv@gmail.com, sashal@kernel.org
Subject: [PATCH stable-5.4.y] net: dsa: b53: Correct learning for standalone ports
Date:   Wed, 24 Feb 2021 17:09:52 -0800
Message-Id: <20210225010956.946545-4-f.fainelli@gmail.com>
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
 drivers/net/dsa/bcm_sf2.c        |  5 -----
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 0b1223f360d9..f35757b63ea7 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -514,6 +514,19 @@ void b53_imp_vlan_setup(struct dsa_switch *ds, int cpu_port)
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
@@ -527,6 +540,7 @@ int b53_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy)
 	cpu_port = ds->ports[port].cpu_dp->index;
 
 	b53_br_egress_floods(ds, port, true, true);
+	b53_port_set_learning(dev, port, false);
 
 	if (dev->ops->irq_enable)
 		ret = dev->ops->irq_enable(dev, port);
@@ -645,6 +659,7 @@ static void b53_enable_cpu_port(struct b53_device *dev, int port)
 	b53_brcm_hdr_setup(dev->ds, port);
 
 	b53_br_egress_floods(dev->ds, port, true, true);
+	b53_port_set_learning(dev, port, false);
 }
 
 static void b53_enable_mib(struct b53_device *dev)
@@ -1704,6 +1719,8 @@ int b53_br_join(struct dsa_switch *ds, int port, struct net_device *br)
 	b53_write16(dev, B53_PVLAN_PAGE, B53_PVLAN_PORT_MASK(port), pvlan);
 	dev->ports[port].vlan_ctl_mask = pvlan;
 
+	b53_port_set_learning(dev, port, true);
+
 	return 0;
 }
 EXPORT_SYMBOL(b53_br_join);
@@ -1751,6 +1768,7 @@ void b53_br_leave(struct dsa_switch *ds, int port, struct net_device *br)
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
index 6dd29bad1609..ca425c15953b 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -172,11 +172,6 @@ static int bcm_sf2_port_setup(struct dsa_switch *ds, int port,
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

