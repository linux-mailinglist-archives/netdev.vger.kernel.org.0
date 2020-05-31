Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961DD1E9782
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 14:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728844AbgEaM1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 08:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgEaM1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 08:27:07 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F31C061A0E
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 05:27:06 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id o15so6535399ejm.12
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 05:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rhkYBLRZMJ0YDVGbfyVR1ak78MVN3O/AEg6DTWvtJsg=;
        b=DGzjq2HPNPH3r9lwQW5EaIAng/8C2aDkHLdmygpyL+YIkrUrTq1Tqsx55nK2e8sTqd
         wE6RUOOFSM0WJT2eJQv9x2VToSyy9ybzmmJu4cXuKb97SBBavhuKaq/0ZsP1OQ5Lj7ka
         M5dMJ1VkauRcAuB+q4i/mtXbmp0wwpnfYp8KlF+KnHD03xqxogzUM8ZZSfRHzgym08sD
         NcW8QDMZcB3gIqBpEAwwX50ZU/H8wuPksgDduoH5E8fiK1iD7ZTeUwDt97OjgC/LSnaH
         +zIGExyEoq1w4xpVij3lWBVeq3Rvu20WPP6aPz9ii3GYYBgnEQ6f7+hDm5zhNDFSLF3s
         Ky4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rhkYBLRZMJ0YDVGbfyVR1ak78MVN3O/AEg6DTWvtJsg=;
        b=eM6KOqyg2Lmc41Dqus8ABLRlA65vUi+mWrCxL5nBuxGK7XuZ+FtvWUyQ0EddyU0dcQ
         xvqYqB+SLh47LKmO1jUy35LobDhMykbYLXztumPZ42m7+4DHNPQz0t7OExuPHXlDMnO9
         VBGS7qZjdtESVgrIhNPWID7huiM5IUo+VIQrsuwdw25vcjL8r3AuLhDj7D8f/uJr0tYn
         y1nHF1NZLm4kIos+m3eU4K1FP62Plewb9fJkM5sJhSLZrm5BIHfvqtfZPus9XkrYf/2Q
         sPwxWHPw8tZjoMQSHJdqNB56tyv4S2vWE4hBbaPM3AXW0aGoVtBQaucirHctlICSpx0A
         QeWQ==
X-Gm-Message-State: AOAM5336qIntlqHhnOVBaXrLC/1/Pfsz7jIskNo8fRu/E5e3SEtjkqVV
        fS8bbBny/gpUrL3WXI6BKsg=
X-Google-Smtp-Source: ABdhPJxqj1aKe6Er9UUq1tsA8IgNsLBpRpAtKpvlBW84H2Y74JLn//cxKjfwJ4qkVEZ4X4v56jucDg==
X-Received: by 2002:a17:907:119a:: with SMTP id uz26mr4079099ejb.523.1590928025497;
        Sun, 31 May 2020 05:27:05 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id b16sm12870024edu.89.2020.05.31.05.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 05:27:05 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru, broonie@kernel.org
Subject: [PATCH v3 net-next 02/13] net: dsa: felix: set proper link speed in felix_phylink_mac_config
Date:   Sun, 31 May 2020 15:26:29 +0300
Message-Id: <20200531122640.1375715-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200531122640.1375715-1-olteanv@gmail.com>
References: <20200531122640.1375715-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

state->speed holds a value of 10, 100, 1000 or 2500, but
SYS_MAC_FC_CFG_FC_LINK_SPEE and DEV_CLOCK_CFG_LINK_SPEED expect a value
in the range 0, 1, 2 or 3.

Even truncated to 2 bits, we are still writing incorrect values to the
registers, but for some reason Felix still works.

On Seville (which we're introducing now), however, we need to set
correct values for the link speed into the MAC registers. Do that now.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v3:
None.

Changes in v2:
Patch is new.

 drivers/net/dsa/ocelot/felix.c | 40 +++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index a6e272d2110d..6ba0d2c3c2fa 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -208,18 +208,39 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 	struct ocelot *ocelot = ds->priv;
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	struct felix *felix = ocelot_to_felix(ocelot);
-	u32 mac_fc_cfg;
+	u32 clock_cfg, mac_fc_cfg;
+
+	switch (state->speed) {
+	case SPEED_10:
+		mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(3);
+		clock_cfg = DEV_CLOCK_CFG_LINK_SPEED(3);
+		break;
+	case SPEED_100:
+		mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(2);
+		clock_cfg = DEV_CLOCK_CFG_LINK_SPEED(2);
+		break;
+	case SPEED_1000:
+		mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(1);
+		clock_cfg = DEV_CLOCK_CFG_LINK_SPEED(1);
+		break;
+	case SPEED_2500:
+		mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(1);
+		clock_cfg = DEV_CLOCK_CFG_LINK_SPEED(0);
+		break;
+	case SPEED_UNKNOWN:
+		mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(0);
+		clock_cfg = DEV_CLOCK_CFG_LINK_SPEED(0);
+		break;
+	default:
+		dev_err(ocelot->dev, "Unsupported speed on port %d: %d\n",
+			port, state->speed);
+		return;
+	}
 
 	/* Take port out of reset by clearing the MAC_TX_RST, MAC_RX_RST and
 	 * PORT_RST bits in CLOCK_CFG
 	 */
-	ocelot_port_writel(ocelot_port, DEV_CLOCK_CFG_LINK_SPEED(state->speed),
-			   DEV_CLOCK_CFG);
-
-	/* Flow control. Link speed is only used here to evaluate the time
-	 * specification in incoming pause frames.
-	 */
-	mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(state->speed);
+	ocelot_port_writel(ocelot_port, clock_cfg, DEV_CLOCK_CFG);
 
 	/* handle Rx pause in all cases, with 2500base-X this is used for rate
 	 * adaptation.
@@ -231,6 +252,9 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 			      SYS_MAC_FC_CFG_PAUSE_VAL_CFG(0xffff) |
 			      SYS_MAC_FC_CFG_FC_LATENCY_CFG(0x7) |
 			      SYS_MAC_FC_CFG_ZERO_PAUSE_ENA;
+	/* Flow control. Link speed is only used here to evaluate the time
+	 * specification in incoming pause frames.
+	 */
 	ocelot_write_rix(ocelot, mac_fc_cfg, SYS_MAC_FC_CFG, port);
 
 	ocelot_write_rix(ocelot, 0, ANA_POL_FLOWC, port);
-- 
2.25.1

