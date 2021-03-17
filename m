Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC9833E2DD
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 01:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhCQAgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbhCQAgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 20:36:01 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3483DC061762;
        Tue, 16 Mar 2021 17:36:01 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id c17so6400046pfv.12;
        Tue, 16 Mar 2021 17:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+QAzmdz2J3myHOyB8tlALQV+gjhvFNmvosUKr/OQ9fw=;
        b=k0U8bNya3Q8ZPOCSg2peKRr4EHRWXOVdljUniyhMn8DwVQVP++a+9IPugiWqAC5Nrq
         GdFyHWuBKE/BLBLdh66LPdZwij3+T0WRTFPDxD5zKDaxxW1G58DyyxTJ1q9f7Wa//tD0
         H9f3qeBPMMw+E5vgyMr4yVAcBI1WokFNNOidD5fNQM1xhO54sGP/bC7pw6K2KnoP2b0c
         YB6G5W+LduvGd2OdRNEDwjJ5cF0chm6W+zugLmj0QsmWz9cbFlRb38G7KZt9tlILtilP
         0hXQdl0XtlIr4lratrQz2izJp0bQyWYMS4vmQebyymnUyjy1HXdHFB2dfHO8OZWFDcg2
         Yzbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+QAzmdz2J3myHOyB8tlALQV+gjhvFNmvosUKr/OQ9fw=;
        b=k6IeAjf643SE2BnMmmAKcYWqSs0dj3jEFGYk/CFb9bjL4ngouRnRoSNLNhPWKSWhb8
         WIEv7/SC7lsM2WBamtqYSikEdL8HeYFSBPBCLefQBUVqa88qYyIH8fm1NM5Z1ejI0PQg
         qGPhWkVUbWrulx+RHT04UyVx/GjsAAqrx6OWxbZHv/y53pa+HdFwuMF/5uyj2apU3A+D
         R1G7BjwlI/ElCfBDqZa/PM2fy38vis61yaU5fs90+kM8gUlGp2nwz4tM8zyR8Rhyto9C
         LbSa6X/Vgeiq32eczkcZVAZCfXtdb/t5Kccby9tpQK3/11l2gyt7o73SiNarJpqsgXhR
         yT3Q==
X-Gm-Message-State: AOAM5333wDfkpAJIZGlfdhWpxnbsI+PxK0Kns6/kYbB7NpqU4GufSiOR
        /V7/QZHC/8pa/jH6wREDCw6aU3/pB0o=
X-Google-Smtp-Source: ABdhPJz2aanHtNw0pamoXapFjVhVflcb7TbqRHDBJwvIJA6kh3t27UUMudkriyJ5bJMrbgcnfJRV0A==
X-Received: by 2002:a63:d17:: with SMTP id c23mr323358pgl.251.1615941360322;
        Tue, 16 Mar 2021 17:36:00 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k63sm18796512pfd.48.2021.03.16.17.35.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 17:35:59 -0700 (PDT)
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
Subject: [PATCH stable 5.11] net: dsa: b53: Correct learning for standalone ports
Date:   Tue, 16 Mar 2021 17:35:49 -0700
Message-Id: <20210317003549.3964522-7-f.fainelli@gmail.com>
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

