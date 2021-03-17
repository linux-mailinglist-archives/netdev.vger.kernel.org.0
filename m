Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96B633E2DE
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 01:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbhCQAgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbhCQAgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 20:36:07 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115FBC06175F;
        Tue, 16 Mar 2021 17:35:56 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id c17so6399918pfv.12;
        Tue, 16 Mar 2021 17:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iz4grmdAR+X/YxjZfLKabS1dAozwCKvvl9/He0wJGlw=;
        b=ci7ktRqxU9oyqvOHVWkTFdbKl1mkguynfMx/+6Rpkf5CcDvQmcnxZcBDWgyw+ULynr
         cmA+PzRUoZy/2MJuulaRO6y13qUDNfytbi/ngJanaT3LGxWMwdTm5mNq8SbwbXuwKoOT
         28CzJOu3cl9lSVJeUDsGFe1igycPTh+je0jdlCYl1tjEFEWBhH2r5UHh8Yk3/Uk4BcCW
         4aEZer6GBgHGGPoOm6e2SLtAjdRPY+qR7TqhDxXQPG5B9hxnebsTfE5M48EUWucjd7JT
         qk2lNaM0W6FjQf1eSKgW/rAyzJr9RkI1INgvwXPHpV9FJBbPnT7IM7sTwBInbeZlobS6
         enoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iz4grmdAR+X/YxjZfLKabS1dAozwCKvvl9/He0wJGlw=;
        b=NJ/0vHELnvsqcS8bqAoEHxHFza4zTlyHQuxWNyuhF2KgGGaIXJO72iZ4M63T1mon0q
         K8lhlGzqQa6++DX+V6yy3++M7SfYtnhBOR9GQ0m+/wkr1yD3MQ8gaGKhRJIODhB1YkBz
         gbWio2O7uUs2YLqlDd5yE8Q9sGAuTIpWvZtVaQQz/hyfK2BW5E/9lsuUkIVWbrC6cHKK
         4MPGLdZB/YA+IMp1mEstdCtDlofCCB/vxPwhL2a1yLKvygMSiwD2BGXbvuKfcRDRlIqA
         V4j15+LqAyuUPgpx3DJ4q8JzEHrANdoOncNN/QV+vqnR5idC+b49vYgHNCNrYVgqpajr
         4Dbg==
X-Gm-Message-State: AOAM532NrM7T+dK65r4oh6qHGoVdTiDI3duU88XKuOFkn+RluRv0Fp/Z
        l/i3Aa6TNEjZPrjVHNzflXMaLedHAHA=
X-Google-Smtp-Source: ABdhPJy8uctQl6g7Tc2dszC7EpwdwpssuJQ/05q+WlsygaqhgEettLQ7Lr+PtQbgn31b4C1+Bx+kBA==
X-Received: by 2002:a63:6d81:: with SMTP id i123mr326196pgc.278.1615941355113;
        Tue, 16 Mar 2021 17:35:55 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k63sm18796512pfd.48.2021.03.16.17.35.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 17:35:54 -0700 (PDT)
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
Subject: [PATCH stable 4.14] net: dsa: b53: Correct learning for standalone ports
Date:   Tue, 16 Mar 2021 17:35:45 -0700
Message-Id: <20210317003549.3964522-3-f.fainelli@gmail.com>
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

