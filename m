Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF304284B3
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 03:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233608AbhJKBdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 21:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233498AbhJKBc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 21:32:57 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE44C061765;
        Sun, 10 Oct 2021 18:30:53 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id y12so48121456eda.4;
        Sun, 10 Oct 2021 18:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PVH/4dILS4HnQoOpObXNzmOj5DG6Y/PG1fkVCKAk9Tc=;
        b=WeFW+3q1T9GxIws3pYD6yviR5+8voIDddlSyZizEaBBgZoltMzwLGv9VkvXyJhyHi0
         QDht7YKGeHG/fjQe+9re3y+xrjmB6eXvvpavlU2cRtSiYUClmfHR3s4eOjLYchNc5Izd
         89FlSEisGOEfXPpvkVg+1EXPJC/2SMSyWqw/rwEn3iJIsgJ/OvLD9OyGmwov4LvBzli3
         FzQU73nlf4mE0TFW/clxy54eAA8n2PK7uBV+1dQfTnTRuaLSUkBjc+U4oZUHH/C7BlS8
         qUt2SKw2mR2ytI+peDVDbMk2nWzfEprE7Sh8mqCGtlIHXY0X+CmYVgDf4r7kEIdazofT
         Ey1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PVH/4dILS4HnQoOpObXNzmOj5DG6Y/PG1fkVCKAk9Tc=;
        b=ievL8q75DkaI0FwEm/KkdPq7fwxYFkGrKGt58xTu3Elfpvu8xTouHdyM5rmS3Cy18x
         B4AafDwRAezJCS4bS+uHKXH0Xlz4kMSYkxXp8O+5mOGXL3o/zdwVXYsHLepTxosTIIPH
         b1dwX73apwpFklAGLgQuHWw+h/SiVwm92qYf2V9zdEcEi1dTrIGGQpDgSnguEA7tU+TQ
         J5OAmGV2HNLIUk5J77/Yl3RyqzF6ZGEM6GEwkI0JdYIx46kgs/4gmrpEGT5KfbR7PhWL
         OlTs3YlFMBwHHMp50tQ41wO5qbGT0GMtk0+a/I2XuWkmd/fYtJNJXQOL1bs+Wrt2dae+
         2ufA==
X-Gm-Message-State: AOAM531s9l4I2FUlGSV1enfUAk/FuYA/NrVNhl5TZdpOEt//UlFNpw2m
        DzXGMxMIdVT7zw7YtoJcZNQ=
X-Google-Smtp-Source: ABdhPJzfFfiIcsHAwdJuPVBsfj5e+Y039yhkFsJOf2cdm1W8xtQ7+8lJyrqNlhZUoXRQE5/8H9Mp/w==
X-Received: by 2002:aa7:c948:: with SMTP id h8mr37677907edt.380.1633915851580;
        Sun, 10 Oct 2021 18:30:51 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id m15sm21314edd.5.2021.10.10.18.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 18:30:51 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v5 08/14] net: dsa: qca8k: add explicit SGMII PLL enable
Date:   Mon, 11 Oct 2021 03:30:18 +0200
Message-Id: <20211011013024.569-9-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211011013024.569-1-ansuelsmth@gmail.com>
References: <20211011013024.569-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support enabling PLL on the SGMII CPU port. Some device require this
special configuration or no traffic is transmitted and the switch
doesn't work at all. A dedicated binding is added to the CPU node
port to apply the correct reg on mac config.
Fail to correctly configure sgmii with qca8327 switch and warn if pll is
used on qca8337 with a revision greater than 1.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 19 +++++++++++++++++--
 drivers/net/dsa/qca8k.h |  1 +
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index b1ce625e9324..c5aee1aee550 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -996,6 +996,18 @@ qca8k_parse_port_config(struct qca8k_priv *priv)
 			if (of_property_read_bool(port_dn, "qca,sgmii-rxclk-falling-edge"))
 				priv->sgmii_rx_clk_falling_edge = true;
 
+			if (of_property_read_bool(port_dn, "qca,sgmii-enable-pll")) {
+				priv->sgmii_enable_pll = true;
+
+				if (priv->switch_id == QCA8K_ID_QCA8327) {
+					dev_err(priv->dev, "SGMII PLL should NOT be enabled for qca8327. Aborting enabling");
+					priv->sgmii_enable_pll = false;
+				}
+
+				if (priv->switch_revision < 2)
+					dev_warn(priv->dev, "SGMII PLL should NOT be enabled for qca8337 with revision 2 or more.");
+			}
+
 			break;
 		default:
 		}
@@ -1306,8 +1318,11 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		if (ret)
 			return;
 
-		val |= QCA8K_SGMII_EN_PLL | QCA8K_SGMII_EN_RX |
-			QCA8K_SGMII_EN_TX | QCA8K_SGMII_EN_SD;
+		val |= QCA8K_SGMII_EN_SD;
+
+		if (priv->sgmii_enable_pll)
+			val |= QCA8K_SGMII_EN_PLL | QCA8K_SGMII_EN_RX |
+			       QCA8K_SGMII_EN_TX;
 
 		if (dsa_is_cpu_port(ds, port)) {
 			/* CPU port, we're talking to the CPU MAC, be a PHY */
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 5eb0c890dfe4..77b1677edafa 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -266,6 +266,7 @@ struct qca8k_priv {
 	u8 switch_revision;
 	bool sgmii_rx_clk_falling_edge;
 	bool sgmii_tx_clk_falling_edge;
+	bool sgmii_enable_pll;
 	u8 rgmii_rx_delay[QCA8K_NUM_CPU_PORTS]; /* 0: CPU port0, 1: CPU port6 */
 	u8 rgmii_tx_delay[QCA8K_NUM_CPU_PORTS]; /* 0: CPU port0, 1: CPU port6 */
 	bool legacy_phy_port_mapping;
-- 
2.32.0

