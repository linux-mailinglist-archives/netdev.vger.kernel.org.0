Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5132025F09F
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 23:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgIFVYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 17:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726154AbgIFVY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Sep 2020 17:24:29 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98031C061573
        for <netdev@vger.kernel.org>; Sun,  6 Sep 2020 14:24:28 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id a15so13872691ljk.2
        for <netdev@vger.kernel.org>; Sun, 06 Sep 2020 14:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TeL7Sn0wISyA/6rSw+Hft+Lnn/YVl9Ra+xPig7T0bfs=;
        b=Qhd8lT08TiAxip70LQex3VWm9OP78VLieG3ENYkBcy0xO0txedyeIJVm13fuNSxq4d
         JHVSj/d5JBje+HflBcGGYRbHDWSYOWrRxJNbX9tXDhYHpMghGcxhFjNyjaAQtOxz8RYW
         gU/UVSCI+OAp5Dv3495hzRuA/dl3G/o5iP3ndgS98uA4VgfvxO3Zo6DyALv3LrXaYkoX
         GVaBx4+P2NLybJz71cFeSXTD72F+45HOG6b/JvjvuT4tg6Vf/5VSEq7TJTaoQ03cCyw5
         AHwt8R4XO7poIO4dBaD1rxisykHHMvfG+bqI3j0pyu1QDrCpyoJYUKkQf4qsXizzFWKP
         nHEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TeL7Sn0wISyA/6rSw+Hft+Lnn/YVl9Ra+xPig7T0bfs=;
        b=IMwvOqSQFxHvfYiIIdL+9npjwNqJsy1r97CAURyXKc8AuCHMvowSAmipN2J9fEDNRM
         u+rIDy7JViJRn9fhpWUE5Sl0Mmhpr8RmUwnIrICR/Erj81Gr3Qx12VBJ9E3woHMRkTxk
         zcf2xc02mmHX6iQ2UW4yhhgLdCYYYp1YRw+GqNTvIincudVZFQzP0HDoCLslPBmk01zn
         CefRgPKsN3qMooj+SVT0DmMbVQg1lZLWNEWLiFWIgW/YWiym3/XjO1X8TDNhVpEwQHCX
         u0RXEinLZuGEOgSra/jZOv5jafnj6umm9v/+9hEbl+Id3XiMphmHMEtRidJxzJFjaYen
         3U8g==
X-Gm-Message-State: AOAM531VJLULHw/vWBRhEeQ9LO65AcWtItXNX0aY0bXTG9lK1cJFp4BS
        WneKWDOeldUJAv3DpXoecsmkdw==
X-Google-Smtp-Source: ABdhPJy/+ErhnNda81bRYCsjHCIGE8B6BUsKoWjJ51S25h2/oMv9CCd0A4t4dNUJEg0y7IaqgHBEtQ==
X-Received: by 2002:a2e:b0fc:: with SMTP id h28mr9242314ljl.114.1599427459065;
        Sun, 06 Sep 2020 14:24:19 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id m15sm5151188ljh.62.2020.09.06.14.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2020 14:24:18 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v2] net: dsa: rtl8366rb: Switch to phylink
Date:   Sun,  6 Sep 2020 23:24:15 +0200
Message-Id: <20200906212415.99415-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This switches the RTL8366RB over to using phylink callbacks
instead of .adjust_link(). This is a pretty template
switchover. All we adjust is the CPU port so that is why
the code only inspects this port.

We enhance by adding proper error messages, also disabling
the CPU port on the way down and moving dev_info() to
dev_dbg().

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Fix the function declarations to be static.
---
 drivers/net/dsa/rtl8366rb.c | 44 +++++++++++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index f763f93f600f..ddc24f5e4123 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -969,8 +969,10 @@ static enum dsa_tag_protocol rtl8366_get_tag_protocol(struct dsa_switch *ds,
 	return DSA_TAG_PROTO_RTL4_A;
 }
 
-static void rtl8366rb_adjust_link(struct dsa_switch *ds, int port,
-				  struct phy_device *phydev)
+static void
+rtl8366rb_mac_link_up(struct dsa_switch *ds, int port, unsigned int mode,
+		      phy_interface_t interface, struct phy_device *phydev,
+		      int speed, int duplex, bool tx_pause, bool rx_pause)
 {
 	struct realtek_smi *smi = ds->priv;
 	int ret;
@@ -978,25 +980,52 @@ static void rtl8366rb_adjust_link(struct dsa_switch *ds, int port,
 	if (port != smi->cpu_port)
 		return;
 
-	dev_info(smi->dev, "adjust link on CPU port (%d)\n", port);
+	dev_dbg(smi->dev, "MAC link up on CPU port (%d)\n", port);
 
 	/* Force the fixed CPU port into 1Gbit mode, no autonegotiation */
 	ret = regmap_update_bits(smi->map, RTL8366RB_MAC_FORCE_CTRL_REG,
 				 BIT(port), BIT(port));
-	if (ret)
+	if (ret) {
+		dev_err(smi->dev, "failed to force 1Gbit on CPU port\n");
 		return;
+	}
 
 	ret = regmap_update_bits(smi->map, RTL8366RB_PAACR2,
 				 0xFF00U,
 				 RTL8366RB_PAACR_CPU_PORT << 8);
-	if (ret)
+	if (ret) {
+		dev_err(smi->dev, "failed to set PAACR on CPU port\n");
 		return;
+	}
 
 	/* Enable the CPU port */
 	ret = regmap_update_bits(smi->map, RTL8366RB_PECR, BIT(port),
 				 0);
-	if (ret)
+	if (ret) {
+		dev_err(smi->dev, "failed to enable the CPU port\n");
+		return;
+	}
+}
+
+static void
+rtl8366rb_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
+			phy_interface_t interface)
+{
+	struct realtek_smi *smi = ds->priv;
+	int ret;
+
+	if (port != smi->cpu_port)
 		return;
+
+	dev_dbg(smi->dev, "MAC link down on CPU port (%d)\n", port);
+
+	/* Disable the CPU port */
+	ret = regmap_update_bits(smi->map, RTL8366RB_PECR, BIT(port),
+				 BIT(port));
+	if (ret) {
+		dev_err(smi->dev, "failed to disable the CPU port\n");
+		return;
+	}
 }
 
 static void rb8366rb_set_port_led(struct realtek_smi *smi,
@@ -1439,7 +1468,8 @@ static int rtl8366rb_detect(struct realtek_smi *smi)
 static const struct dsa_switch_ops rtl8366rb_switch_ops = {
 	.get_tag_protocol = rtl8366_get_tag_protocol,
 	.setup = rtl8366rb_setup,
-	.adjust_link = rtl8366rb_adjust_link,
+	.phylink_mac_link_up = rtl8366rb_mac_link_up,
+	.phylink_mac_link_down = rtl8366rb_mac_link_down,
 	.get_strings = rtl8366_get_strings,
 	.get_ethtool_stats = rtl8366_get_ethtool_stats,
 	.get_sset_count = rtl8366_get_sset_count,
-- 
2.26.2

