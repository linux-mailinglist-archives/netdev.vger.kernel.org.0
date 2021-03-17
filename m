Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83EFE33E2E6
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 01:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhCQAga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhCQAfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 20:35:54 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A175AC06175F;
        Tue, 16 Mar 2021 17:35:54 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id b23so9979462pfo.8;
        Tue, 16 Mar 2021 17:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DLT04vw8Z8RPIa9CQTYkcbioQCssb11p/TMPiakSxqI=;
        b=YdqPFijLIz8gdToBjIETgCVMFDHr1OZLsCf0/whQ/qjbcGMtBASAabKkY6/HdiXVN6
         R/PEV8KDNyY5YJeK23WzlY+O03BBEUBfO+lfU9/2nHK2yyys5kuQDDGGbMubul46o1Wf
         CjAz6zTsZQK7WivGMVTui35yEvdI96/ArMMV6QlUFEFQIySNip2hUKdLcyzqp1b/DzUi
         lL99oCSDXFal6L4LEBfAXHh70eVuKD4VQHjTXK/z7KC+6eHSk1MpxyfCCmR0BJ3PpVWe
         e586HO28CKSJxcnksxbBz3ixaLkfRF+bjBvn6tzz3DQYn76w27A7f6FkWpWU1KgNAHrT
         wafA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DLT04vw8Z8RPIa9CQTYkcbioQCssb11p/TMPiakSxqI=;
        b=SBxrRjX/Q/miypy6Kh1rZqwojA8+u6fRWGRyiol5dz2J33+I74t92LJhttbfdWgxN0
         mWAY91UAMTGX52+2eK1YLFSJy69FLHigYh3JTUUkSpxDX9V70qXFpT8o9WM2hKukK/zo
         B1cqoTYY/ta1Cet0R9fUH2xKN0HnyjzrQ2/3ks8xbPkaO+ZhF/5Jc6QglPuEsyRLaT78
         BzWX57DW6JWI7+3FqAZi7lNchT+XPZcWZgHQF/h+LYWJZXZ9Cuwk33FUEl1fyjxEp8/o
         OWTqvAniErVdZKdTXH1bJmHKpt6usqKHMY+TIM1FvOFOGy20ytQXsMjUv8ilGq+5H/yV
         Nsgg==
X-Gm-Message-State: AOAM531pJGTOpU7Ic+SZJfxwOE44DF/HLmNic8Vvsmdx+fkuHZ9rWghG
        o3mpLEK5khhBXpt2L9M530uU4/MPDyk=
X-Google-Smtp-Source: ABdhPJyQOtvt/voNPviKgzQxa+PtcYw/+tmvzoU0fc7Kvc5qVNk3ZnRKiANXljd9VsW997sIDF6QgA==
X-Received: by 2002:a63:140b:: with SMTP id u11mr334413pgl.436.1615941353784;
        Tue, 16 Mar 2021 17:35:53 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k63sm18796512pfd.48.2021.03.16.17.35.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 17:35:53 -0700 (PDT)
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
Subject: [PATCH stable 4.9] net: dsa: b53: Correct learning for standalone ports
Date:   Tue, 16 Mar 2021 17:35:44 -0700
Message-Id: <20210317003549.3964522-2-f.fainelli@gmail.com>
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

