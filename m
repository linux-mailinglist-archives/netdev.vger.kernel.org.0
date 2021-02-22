Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275E93221BD
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 22:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhBVVsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 16:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbhBVVsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 16:48:17 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E03AC06174A;
        Mon, 22 Feb 2021 13:47:37 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id b15so480018pjb.0;
        Mon, 22 Feb 2021 13:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yUOECDbspUPB7vYqE7OAhqNYTlK/dZC/wuY7Okr7q74=;
        b=lPuAGNYCfU6ycpsOEQxNhUk+IFECTwWNSe+gYigLGt4NsMk+knHGI72M3vuf3taREn
         Q4zaixwwd8Qf2Xc4WHzNDu4D+Bkg99/qpKPOtqcGd0dZ32S5APclqxnNT1zDFV3y+15W
         b8zOTZKv3hOeXbLNwAj0I71DFfAaBw77Cj0YCVmiz+9ltR4N2TV3novh8KGic2T89vQs
         aELEE7dw7lsMQ4KPTCzNrog/4zMpoO4ZvOgR0zONMtgYehDakihEZl/5flGHznD8l4bd
         YV7FfT0Fn49oW/rQ9AruL6rLmdqTvDcUCvRoTLE6lm1ntvW8JrqKHMNu0Bmjdkfp0v81
         t1TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yUOECDbspUPB7vYqE7OAhqNYTlK/dZC/wuY7Okr7q74=;
        b=RPzk/NNAzs6SQ5YyFnJobQHPqs0X2uASzG0mFOXZhZrkMzEmsQXA1SgetUM81wfp2A
         BNK1SwknhmeN2eiGKBuy492A8Pq3UNW6weOjse/ahOQ17Q5ZUkdBm2VvnG1cyQbK13Ox
         4kIQq7POnH+XaKhTWNijLATIay5mDwuMwKINBRIUUQxVCpMfgy003ncoI70eaiq4LCmY
         ICytsZVekUNegmOtMMQR2TsJ7uDpqvEbc7WY6cOLTnBgpAMqId5Zdo8lnONAGZL177bP
         5F2s1gFcCKgDcGtQkptE5ah/I2qjUF0RZu5b4Z15tQccClUDnUXq04WAQvLepDHVbvI2
         ZHnA==
X-Gm-Message-State: AOAM532iPj7DtSaUaJvF6EsOgsCqz+rqOW91qXWnghPdvDHSjA8GIHyn
        lAyMVoQjKwVBDwa/RJkEXyQDWtVj8iw=
X-Google-Smtp-Source: ABdhPJw/5pkHY75CzRt791ZqaQhoYcAkGlvgMr5oxz/oCbaSgHacytQMtT+saIMDOdHwmMp/Mr8DEQ==
X-Received: by 2002:a17:90a:a117:: with SMTP id s23mr14027096pjp.208.1614030456614;
        Mon, 22 Feb 2021 13:47:36 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x9sm433339pjp.3.2021.02.22.13.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 13:47:35 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: dsa: b53: Support setting learning on port
Date:   Mon, 22 Feb 2021 13:46:41 -0800
Message-Id: <20210222214641.2865493-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
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
David, Jakub,

This is submitted against "net" because this is technically a bug fix
since ports should not have had learning enabled by default but given
this is dependent upon Vladimir's recent br_flags series, there is no
Fixes tag provided.

I will be providing targeted stable backports that look a bit
difference.

Thanks!

 drivers/net/dsa/b53/b53_common.c | 18 ++++++++++++++++++
 drivers/net/dsa/b53/b53_regs.h   |  1 +
 drivers/net/dsa/bcm_sf2.c        | 15 +--------------
 3 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index ae86ded1e2a1..261f6902abc3 100644
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
@@ -1973,6 +1988,9 @@ static int b53_br_flags(struct dsa_switch *ds, int port,
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
index 1857aa9aa84a..726edfe230df 100644
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

