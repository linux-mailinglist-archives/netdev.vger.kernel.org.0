Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1CD324857
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 02:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235735AbhBYBLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 20:11:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234928AbhBYBK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 20:10:57 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E87C06174A;
        Wed, 24 Feb 2021 17:10:17 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id c19so2491129pjq.3;
        Wed, 24 Feb 2021 17:10:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iz4grmdAR+X/YxjZfLKabS1dAozwCKvvl9/He0wJGlw=;
        b=OJ+mKfdVkS/kzqj8vmWvwu86hA2wgdosh3xkvjR0B/GHFLfOsYn5PL9AWQWEkzGJmb
         o1/IfP1X/4XXP0z/cNW1Ko951Gv2pAhpmvY8CO7wyCBeAEM1OAZizrgXoI94NVI3IfTR
         j/+fPrPcKkRiM0DdvXs9Bq682N8ibR00QNdw8r28uL3n8AjUXFJRwMYo/pvFQZ7b9I9c
         6ZLTuSS9FZiWM0V7TF1ThZ2NHz/36Eu9Np7RJmnyYodlRTllNaWW351lkIw3CkMqHzAo
         HbqudRQVDf3mjn2/4YI1Ep0P98fIfXhEZPSfN/cDX/JPLoiixheIqSvPZvHyMGt3tOdh
         bMvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iz4grmdAR+X/YxjZfLKabS1dAozwCKvvl9/He0wJGlw=;
        b=LsCbdQob5weqHSgyV2ctN8AuMPWVA4PGRxFZgfnrNsIVVhoY+sPJ6vio76XuyB1F3a
         xGBYsjkP9QBBQmaVTBXUAw6aS/OhLk+IzS3onASYJvUBDfaGlzX4TMfS7N2DhLIpFMJT
         Cqu13ImnLnxWBid3bIqacNcMRkSFNWo4VUNyLcTGP2lsz4FaBnmjEfOc4LN2ORTo1Yly
         UwJ0Q2NVqz98UMBrqduO1hI/6ogoQ/n/rR2i/CJ1oRru8VGFUWxmK1w2DcFQe1rUyH2E
         ejvjWYocBCp3KL5K0lYPRwuFaMXqS6Tbi/ZKsdqeVBp/65GEBlxK8D1pmYuOZggUaO+k
         2gWg==
X-Gm-Message-State: AOAM533ZSIh93GEHoEGVv4dJbW7qnD2w6bWuYJf3L1lU6ZvCcRdGQZ5/
        TaWQEkHQphJxGuc6wK3j9lwrbVaUn94=
X-Google-Smtp-Source: ABdhPJxR0MZx8ASKY9jIP1eq/sfuY8hcjO7m7G1l/KdMv/WgbgGeNfjDP9wODmB6aY6tmOWnjd/QCw==
X-Received: by 2002:a17:902:ed82:b029:e2:d106:e76e with SMTP id e2-20020a170902ed82b02900e2d106e76emr775076plj.38.1614215416361;
        Wed, 24 Feb 2021 17:10:16 -0800 (PST)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z11sm3503010pgk.65.2021.02.24.17.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 17:10:15 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list), stable@vger.kernel.org,
        gregkh@linuxfoundation.org, olteanv@gmail.com, sashal@kernel.org
Subject: [PATCH stable-4.14.y] net: dsa: b53: Correct learning for standalone ports
Date:   Wed, 24 Feb 2021 17:09:50 -0800
Message-Id: <20210225010956.946545-2-f.fainelli@gmail.com>
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
 drivers/net/dsa/b53/b53_common.c | 20 ++++++++++++++++++++
 drivers/net/dsa/b53/b53_regs.h   |  1 +
 drivers/net/dsa/bcm_sf2.c        |  5 +++++
 drivers/net/dsa/bcm_sf2_regs.h   |  2 ++
 4 files changed, 28 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index c17cdbd0bb6a..820aed3e2352 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -501,6 +501,19 @@ static void b53_imp_vlan_setup(struct dsa_switch *ds, int cpu_port)
 	}
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
 static int b53_enable_port(struct dsa_switch *ds, int port,
 			   struct phy_device *phy)
 {
@@ -508,6 +521,8 @@ static int b53_enable_port(struct dsa_switch *ds, int port,
 	unsigned int cpu_port = dev->cpu_port;
 	u16 pvlan;
 
+	b53_port_set_learning(dev, port, false);
+
 	/* Clear the Rx and Tx disable bits and set to no spanning tree */
 	b53_write8(dev, B53_CTRL_PAGE, B53_PORT_CTRL(port), 0);
 
@@ -551,6 +566,8 @@ static void b53_enable_cpu_port(struct b53_device *dev)
 		    PORT_CTRL_RX_MCST_EN |
 		    PORT_CTRL_RX_UCST_EN;
 	b53_write8(dev, B53_CTRL_PAGE, B53_PORT_CTRL(cpu_port), port_ctrl);
+
+	b53_port_set_learning(dev, cpu_port, false);
 }
 
 static void b53_enable_mib(struct b53_device *dev)
@@ -1342,6 +1359,8 @@ int b53_br_join(struct dsa_switch *ds, int port, struct net_device *br)
 	b53_write16(dev, B53_PVLAN_PAGE, B53_PVLAN_PORT_MASK(port), pvlan);
 	dev->ports[port].vlan_ctl_mask = pvlan;
 
+	b53_port_set_learning(dev, port, true);
+
 	return 0;
 }
 EXPORT_SYMBOL(b53_br_join);
@@ -1392,6 +1411,7 @@ void b53_br_leave(struct dsa_switch *ds, int port, struct net_device *br)
 		vl->untag |= BIT(port) | BIT(dev->cpu_port);
 		b53_set_vlan_entry(dev, pvid, vl);
 	}
+	b53_port_set_learning(dev, port, false);
 }
 EXPORT_SYMBOL(b53_br_leave);
 
diff --git a/drivers/net/dsa/b53/b53_regs.h b/drivers/net/dsa/b53/b53_regs.h
index 247aef92b759..2b892b8d0374 100644
--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -112,6 +112,7 @@
 #define B53_UC_FLOOD_MASK		0x32
 #define B53_MC_FLOOD_MASK		0x34
 #define B53_IPMC_FLOOD_MASK		0x36
+#define B53_DIS_LEARNING		0x3c
 
 /*
  * Override Ports 0-7 State on devices with xMII interfaces (8 bit)
diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 91c8405e515f..7fc84ae562a2 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -252,6 +252,11 @@ static int bcm_sf2_port_setup(struct dsa_switch *ds, int port,
 	reg &= ~P_TXQ_PSM_VDD(port);
 	core_writel(priv, reg, CORE_MEM_PSM_VDD_CTRL);
 
+	/* Disable learning */
+	reg = core_readl(priv, CORE_DIS_LEARN);
+	reg |= BIT(port);
+	core_writel(priv, reg, CORE_DIS_LEARN);
+
 	/* Enable Broadcom tags for that port if requested */
 	if (priv->brcm_tag_mask & BIT(port))
 		bcm_sf2_brcm_hdr_setup(priv, port);
diff --git a/drivers/net/dsa/bcm_sf2_regs.h b/drivers/net/dsa/bcm_sf2_regs.h
index 49695fcc2ea8..da1336ddd52d 100644
--- a/drivers/net/dsa/bcm_sf2_regs.h
+++ b/drivers/net/dsa/bcm_sf2_regs.h
@@ -150,6 +150,8 @@ enum bcm_sf2_reg_offs {
 #define CORE_SWITCH_CTRL		0x00088
 #define  MII_DUMB_FWDG_EN		(1 << 6)
 
+#define CORE_DIS_LEARN			0x000f0
+
 #define CORE_SFT_LRN_CTRL		0x000f8
 #define  SW_LEARN_CNTL(x)		(1 << (x))
 
-- 
2.25.1

