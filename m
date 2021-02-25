Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E0C324855
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 02:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235215AbhBYBLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 20:11:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234811AbhBYBKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 20:10:52 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E3FC061574;
        Wed, 24 Feb 2021 17:10:11 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id j24so2515326pfi.2;
        Wed, 24 Feb 2021 17:10:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DLT04vw8Z8RPIa9CQTYkcbioQCssb11p/TMPiakSxqI=;
        b=H3T5tzcgA0dbeTVMOLnx+dAW15oK2hJ7qDdpXc23jy0D+KJMr7cV1X2otHdLVjwQXy
         KlTY3l7ZGEeO2Qe4bMPwTaOpBWwEdEFeZoi8urnnR+mix7ghEBl+4u34C/fp4O/URnvl
         ppzxuEay5/sHp43iGN57NHT7potZdTysUBZFgHbtB21/Fg/85FONnaVlREeZNZ3hHkgR
         0EcFpD+Aga8o23ghWeAmKVC7J+YvIAOOTUxK3zfKobXcvaPdvnxknpmNlkOEyUW/2PuO
         GJCu9LPDSMKDAso0olY2dMq6Iws6KoAz2kxs/lwkBpuUe7Gtpue4bZ5de5+SK5omAp6M
         KUcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DLT04vw8Z8RPIa9CQTYkcbioQCssb11p/TMPiakSxqI=;
        b=sNDCkH83+xESNVnJYbKfp6RiaadjDTY/q02Dixi1PPqFou6xF+54e9+JiK6WZKKAom
         LQj8wlaaJiABnzDbCpZn/IzwqvYOF8MA90jk3vOSrGcz2XKPzZbK/effpwmcPT+LIaLy
         1rn8ys2TQPKOnLdHyNe9gu/QJkHY2ZZGaWclroT7mXZvCdhjqqxROzCOrL+XGGNE5qAh
         JcFE0Vu8HigRt2gYWUgetXxAqpLtG9XbNZUeqBLDu3QGU2sMki+fGBnzB4OaMHJkcit5
         p510dcprmI3ibXldvYqd79mZM7UVgqdbh9NYtguJ2tUd+IQurZk8z8Q/WNCurPJhXu5b
         kF+w==
X-Gm-Message-State: AOAM531rFkk1dzpl3BJg/0DJhB1W8PbhYJsyEHqLW+dDq2ZRfQwt9MIj
        6+mb6+RAfoOfQFydeTna2gd8zqLAe/0=
X-Google-Smtp-Source: ABdhPJwUWUOhGhS1SkFqYfP9dq1gGqLLNxfcgHSM2M/Nwk8J5dLimpCkNjElUNbYg4m/+BgdOSoXjg==
X-Received: by 2002:a05:6a00:1392:b029:1ed:fbd0:c700 with SMTP id t18-20020a056a001392b02901edfbd0c700mr752742pfg.4.1614215410827;
        Wed, 24 Feb 2021 17:10:10 -0800 (PST)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z11sm3503010pgk.65.2021.02.24.17.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 17:10:10 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list), stable@vger.kernel.org,
        gregkh@linuxfoundation.org, olteanv@gmail.com, sashal@kernel.org
Subject: [PATCH stable-4.9.y] net: dsa: b53: Correct learning for standalone ports
Date:   Wed, 24 Feb 2021 17:09:49 -0800
Message-Id: <20210225010956.946545-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210225010853.946338-1-f.fainelli@gmail.com>
References: <20210225010853.946338-1-f.fainelli@gmail.com>
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
index 5ec0042bc384..b6867a8915da 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -502,6 +502,19 @@ static void b53_imp_vlan_setup(struct dsa_switch *ds, int cpu_port)
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
@@ -509,6 +522,8 @@ static int b53_enable_port(struct dsa_switch *ds, int port,
 	unsigned int cpu_port = dev->cpu_port;
 	u16 pvlan;
 
+	b53_port_set_learning(dev, port, false);
+
 	/* Clear the Rx and Tx disable bits and set to no spanning tree */
 	b53_write8(dev, B53_CTRL_PAGE, B53_PORT_CTRL(port), 0);
 
@@ -552,6 +567,8 @@ static void b53_enable_cpu_port(struct b53_device *dev)
 		    PORT_CTRL_RX_MCST_EN |
 		    PORT_CTRL_RX_UCST_EN;
 	b53_write8(dev, B53_CTRL_PAGE, B53_PORT_CTRL(cpu_port), port_ctrl);
+
+	b53_port_set_learning(dev, cpu_port, false);
 }
 
 static void b53_enable_mib(struct b53_device *dev)
@@ -1375,6 +1392,8 @@ static int b53_br_join(struct dsa_switch *ds, int port,
 	b53_write16(dev, B53_PVLAN_PAGE, B53_PVLAN_PORT_MASK(port), pvlan);
 	dev->ports[port].vlan_ctl_mask = pvlan;
 
+	b53_port_set_learning(dev, port, true);
+
 	return 0;
 }
 
@@ -1426,6 +1445,7 @@ static void b53_br_leave(struct dsa_switch *ds, int port)
 		vl->untag |= BIT(port) | BIT(dev->cpu_port);
 		b53_set_vlan_entry(dev, pvid, vl);
 	}
+	b53_port_set_learning(dev, port, false);
 }
 
 static void b53_br_set_stp_state(struct dsa_switch *ds, int port, u8 state)
diff --git a/drivers/net/dsa/b53/b53_regs.h b/drivers/net/dsa/b53/b53_regs.h
index 3cf246c6bdcc..aed70e76006d 100644
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
index a3742a3b413c..0c69d5858558 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -224,6 +224,11 @@ static int bcm_sf2_port_setup(struct dsa_switch *ds, int port,
 	reg &= ~P_TXQ_PSM_VDD(port);
 	core_writel(priv, reg, CORE_MEM_PSM_VDD_CTRL);
 
+	/* Disable learning */
+	reg = core_readl(priv, CORE_DIS_LEARN);
+	reg |= BIT(port);
+	core_writel(priv, reg, CORE_DIS_LEARN);
+
 	/* Clear the Rx and Tx disable bits and set to no spanning tree */
 	core_writel(priv, 0, CORE_G_PCTL_PORT(port));
 
diff --git a/drivers/net/dsa/bcm_sf2_regs.h b/drivers/net/dsa/bcm_sf2_regs.h
index 838fe373cd6f..ca1d1f2e1161 100644
--- a/drivers/net/dsa/bcm_sf2_regs.h
+++ b/drivers/net/dsa/bcm_sf2_regs.h
@@ -138,6 +138,8 @@
 #define CORE_SWITCH_CTRL		0x00088
 #define  MII_DUMB_FWDG_EN		(1 << 6)
 
+#define CORE_DIS_LEARN			0x000f0
+
 #define CORE_SFT_LRN_CTRL		0x000f8
 #define  SW_LEARN_CNTL(x)		(1 << (x))
 
-- 
2.25.1

