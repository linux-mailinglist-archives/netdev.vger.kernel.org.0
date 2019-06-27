Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8D158D53
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 23:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfF0VrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 17:47:07 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35793 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbfF0VrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 17:47:06 -0400
Received: by mail-wr1-f65.google.com with SMTP id f15so4150098wrp.2
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 14:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RBoaagMyoT3Y82kWpCOMYVv+Htpw0F63H6flwEeSbgU=;
        b=DCv98DI3bY7Exv1mLRhrwgr/oJObG+PphSKNJCf7cMs/TqCD4Xlrh4G9zWi6PzbWi5
         qLVSrh5nIDjDnmfJDare7FoiTcPs7INTb4LuUTipNm+5s3PQIw7QCex0Zby9Ght/d4KJ
         4AtE3xRYAAKGOUHg2eqKnprQTTAKiaEfi+nfH9t5BzlPLRYjr6wVoe8nanh+ks7OMF5i
         neNeWW5TanImwJN+8dbdvV8pGfzIU5XuOdC5dqqbzbslaBCFG8E9PJyleOSPoooGW0ns
         JU1LJh72rQoRABluIIqGITM8Op6Oik7qwCjWygS75gfve3JaXp2HGBmlcSZ5DmGsllCB
         GtKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RBoaagMyoT3Y82kWpCOMYVv+Htpw0F63H6flwEeSbgU=;
        b=Mk1iRzon8TtGYsvUcch5RpS1Qmg3VokJT9Tgjn4qhDU1/XNvYV8VkzuzKQAmvpDPaa
         +tUbV2ifWcM+p3VIbwMY2lB+xHP/HIdM8wJgt4g7Vys1ZavFZL5qjaHiPYNVZbAVKQLB
         ONICCaFQ7Tk0hno2+A32ZKppv0Rc27ne1scfYDKdhCvlCDgpU1FFDs5K5w05adVGbHM1
         rGaIXi09HleDLQJl369aLwTioQBA9WVfsaW1zVEaYapk/e7mS/I+512vkFlwJRurr4uF
         jwgO57KoUWzCNVr9uirHq4JuDSPLqwVirH8CxJfEYzzWdRIxvhy7Z47noAGIfFLF3+70
         YMUg==
X-Gm-Message-State: APjAAAUAsuU/BvVy9EJ0+F6ewuY07rUfumdquHWjDkuyEMhW7SxAq4lm
        OKb8HfbP8kyKZh3M820NPoJKXd8L
X-Google-Smtp-Source: APXvYqxs+n96FzEhH+1NrFE7wzO8uSLytviFnl/oPKZB5ro4STD5bvz1Qkf/iTdc+viV/jEviMAEPQ==
X-Received: by 2002:a5d:4810:: with SMTP id l16mr4519567wrq.48.1561672024026;
        Thu, 27 Jun 2019 14:47:04 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id v18sm286923wrs.80.2019.06.27.14.47.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 14:47:03 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     linux@armlinux.org.uk, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH v2 net-next 2/3] net: dsa: sja1105: Check for PHY mode mismatches with what PHYLINK reports
Date:   Fri, 28 Jun 2019 00:46:36 +0300
Message-Id: <20190627214637.22366-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190627214637.22366-1-olteanv@gmail.com>
References: <20190627214637.22366-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PHYLINK being designed with PHYs in mind that can change MII protocol,
for correct operation it is necessary to ensure that the PHY interface
mode stays the same (otherwise clear the supported bit mask, as
required).

Because this is just a hypothetical situation for now, we don't bother
to check whether we could actually support the new PHY interface mode.
Actually we could modify the xMII table, reset the switch and send an
updated static configuration, but adding that would just be dead code.

Cc: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 44 ++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index da1736093b06..b366b8e100f8 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -766,12 +766,46 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 	return sja1105_clocking_setup_port(priv, port);
 }
 
+/* The SJA1105 MAC programming model is through the static config (the xMII
+ * Mode table cannot be dynamically reconfigured), and we have to program
+ * that early (earlier than PHYLINK calls us, anyway).
+ * So just error out in case the connected PHY attempts to change the initial
+ * system interface MII protocol from what is defined in the DT, at least for
+ * now.
+ */
+static bool sja1105_phy_mode_mismatch(struct sja1105_private *priv, int port,
+				      phy_interface_t interface)
+{
+	struct sja1105_xmii_params_entry *mii;
+	sja1105_phy_interface_t phy_mode;
+
+	mii = priv->static_config.tables[BLK_IDX_XMII_PARAMS].entries;
+	phy_mode = mii->xmii_mode[port];
+
+	switch (interface) {
+	case PHY_INTERFACE_MODE_MII:
+		return (phy_mode != XMII_MODE_MII);
+	case PHY_INTERFACE_MODE_RMII:
+		return (phy_mode != XMII_MODE_RMII);
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		return (phy_mode != XMII_MODE_RGMII);
+	default:
+		return true;
+	}
+}
+
 static void sja1105_mac_config(struct dsa_switch *ds, int port,
 			       unsigned int link_an_mode,
 			       const struct phylink_link_state *state)
 {
 	struct sja1105_private *priv = ds->priv;
 
+	if (sja1105_phy_mode_mismatch(priv, port, state->interface))
+		return;
+
 	sja1105_adjust_port_config(priv, port, state->speed);
 }
 
@@ -804,6 +838,16 @@ static void sja1105_phylink_validate(struct dsa_switch *ds, int port,
 
 	mii = priv->static_config.tables[BLK_IDX_XMII_PARAMS].entries;
 
+	/* include/linux/phylink.h says:
+	 *     When @state->interface is %PHY_INTERFACE_MODE_NA, phylink
+	 *     expects the MAC driver to return all supported link modes.
+	 */
+	if (state->interface != PHY_INTERFACE_MODE_NA &&
+	    sja1105_phy_mode_mismatch(priv, port, state->interface)) {
+		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		return;
+	}
+
 	/* The MAC does not support pause frames, and also doesn't
 	 * support half-duplex traffic modes.
 	 */
-- 
2.17.1

