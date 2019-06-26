Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29D6E5677B
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 13:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbfFZLVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 07:21:16 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46482 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbfFZLVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 07:21:14 -0400
Received: by mail-wr1-f66.google.com with SMTP id n4so2240693wrw.13
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 04:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+tplfgKyukxLNF7ayWw2aUDxGP6sAVd9YOzb54Ag8Vg=;
        b=Rybc+lIn3kb/YgJfhhmX57/T30oGnrSGlYgn3LiBiRiRl5NTbx9gSAt9zf7cnfKuHw
         wdWp3y3Fpo9wz3NObB/kqV7MkQkj/07E3t5UQH8wBn0dh6bC6Ye8P+sF97tFkVnL5zHe
         J8oYmpXE0FCIBY1Dmlxiqa09VKw57h0r2KXQsEelTrX9R0h9KtF7vExkV7Us7AA2M4O8
         gdd7CKugN7ixbceTTbSNZUGKj7OIdg04E6jbkFNz+tljpz0q5ud7OnS5dIJKvR9Rlo6D
         DTaw8X//cqJ+XT999w3/+wqdKyFY04ATbCs57lS7DSczXM2FX38Zo7sZKAw/WxynJEbN
         IuqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+tplfgKyukxLNF7ayWw2aUDxGP6sAVd9YOzb54Ag8Vg=;
        b=Nf/kK/kNa6HRSfRzXIJ8kBYAV1vkdnjrJsIDgFADd1/cHNaZnYQT53JZmQS02yvj7e
         Hm4+gPYEl/6AzSBVFuafPbdAaQtSz7ZlmzxXUNOqRslRJnZBe1fFGTxLl1BKGH1bLocE
         bX9LjJI7HLzdHX6qWxmLUQUhpm6g47h3W/gfe5qJjkyKm1Lsouj9JFM1YZBuEnLn88mc
         AODPNs+vRFp3oPu7POK79SYBfamYlA5vbc4txu8SSSE3Ud8dCMzsnM0ArK3jQzxzCOa2
         Unv2MEXyDK7RLUdFnrxHKSUmJUjfYuYunCs3fuLF3ERirACUu9H59lolTisrkcbRXdrE
         nEfw==
X-Gm-Message-State: APjAAAWsCjb16E0U+fS/5KgIUXQHkvrceQ/RHMNTDhc+Qe1inSH1dJ6Q
        KKJzkQgWkldR8jZdXlyI0fw=
X-Google-Smtp-Source: APXvYqyops9SNNqS70655O67XR4dc8aWupXCDGyUM9Egz8xfNY3LPLmCG/N4Apt4WO80SIRM7D0OzQ==
X-Received: by 2002:adf:f812:: with SMTP id s18mr3553190wrp.32.1561548072760;
        Wed, 26 Jun 2019 04:21:12 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id h14sm6233701wro.30.2019.06.26.04.21.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 04:21:12 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     rmk+kernel@armlinux.org.uk, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 2/3] net: dsa: sja1105: Check for PHY mode mismatches with what PHYLINK reports
Date:   Wed, 26 Jun 2019 14:20:13 +0300
Message-Id: <20190626112014.7625-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190626112014.7625-1-olteanv@gmail.com>
References: <20190626112014.7625-1-olteanv@gmail.com>
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
 drivers/net/dsa/sja1105/sja1105_main.c | 47 ++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index da1736093b06..ad4f604590c0 100644
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
 
@@ -804,6 +838,19 @@ static void sja1105_phylink_validate(struct dsa_switch *ds, int port,
 
 	mii = priv->static_config.tables[BLK_IDX_XMII_PARAMS].entries;
 
+	/* include/linux/phylink.h says:
+	 *     When @state->interface is %PHY_INTERFACE_MODE_NA, phylink
+	 *     expects the MAC driver to return all supported link modes.
+	 */
+	if (state->interface != PHY_INTERFACE_MODE_NA &&
+	    sja1105_phy_mode_mismatch(priv, port, state->interface)) {
+		dev_warn(ds->dev, "PHY mode mismatch on port %d: "
+			 "PHYLINK tried to change to %s\n",
+			 port, phy_modes(state->interface));
+		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		return;
+	}
+
 	/* The MAC does not support pause frames, and also doesn't
 	 * support half-duplex traffic modes.
 	 */
-- 
2.17.1

