Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B822433E2D8
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 01:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhCQAge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbhCQAf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 20:35:59 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8EA8C061762;
        Tue, 16 Mar 2021 17:35:59 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id c17so6400018pfv.12;
        Tue, 16 Mar 2021 17:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+QAzmdz2J3myHOyB8tlALQV+gjhvFNmvosUKr/OQ9fw=;
        b=gW2OGB6PbKlM7xt6W4OIp4mG6QIYwUlZLzQE1kraE6HVRP8/l1gK9OCL6GdJwu2jSI
         eT/h5kLd3Gs7AXl1fdRIa7RUWQ0v+6iV4rrtv9kt8kzYGtG5jBO6NMGuzj1MxaE1yFj+
         YD3Z2wAkgdRwYLLsBxVslFKenymCoAAiPEsAKkdPvfv58ahimnSfP5jAquvOohNHGVNQ
         3RY5yrU7dF4ZgYVJJpEL15svPenn0tpAXD1+N4VKF3BUg4uW1UAs0fY1pCNadAS2ZwoM
         fB2KpO7xT9smCyg62JVQibDFie8tD4ppq9SGjFBWhtggjY2FOyRyaazfuISNKJ3QsIwA
         ygaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+QAzmdz2J3myHOyB8tlALQV+gjhvFNmvosUKr/OQ9fw=;
        b=OzLK2mw6esGe4q7Hp2ansC9PC/QTZoQtFQQdgKeahayAlyGe1a8BhWF2m2eHVnAL8h
         LaavkWFFl0Wd143g1RMZjFAk5c85qLLoBA20VFF6rKWDa992ccGbGZzZWIn9ZqPCwH/u
         A0lVkS5VL3CTr5nbEOWP5RHYLynGhA++fYYzocJU5p0CKt69TtQadJKZMONXEiwPHOV7
         q/C1u+VxQ/MB75IqbjSM0wKjFluo2iQSiDJ3siOZRtLD7xpKIR8gLiC1TQoOQtxu8CEN
         vQcYjpwFZZ+T0TlFwmtNBkYu+WeqitJ1CSOBF6zx0ePLJb4ujp1fjp8M+D1vL27y6uxf
         PV1A==
X-Gm-Message-State: AOAM531iP/kPiGwKOgJEWx/r8+Jiz4Lb6G5uztpD2T9ldMWDeFopGhZt
        p7n5GnmsKeCrbXtT6ydXMrKYly/OlHE=
X-Google-Smtp-Source: ABdhPJzL6E3KKO10jvhVD05f8r6U6PdabinnP4QTKZDMjUUvlQXOfD5Sz2MjMkrq6K9JHsphRm5OFA==
X-Received: by 2002:a63:4709:: with SMTP id u9mr334008pga.250.1615941358997;
        Tue, 16 Mar 2021 17:35:58 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k63sm18796512pfd.48.2021.03.16.17.35.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 17:35:58 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list), stable@vger.kernel.org,
        gregkh@linuxfoundation.org, sashal@kernel.org
Subject: [PATCH stable 5.10] net: dsa: b53: Correct learning for standalone ports
Date:   Tue, 16 Mar 2021 17:35:48 -0700
Message-Id: <20210317003549.3964522-6-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210317003549.3964522-1-f.fainelli@gmail.com>
References: <20210317003549.3964522-1-f.fainelli@gmail.com>
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

