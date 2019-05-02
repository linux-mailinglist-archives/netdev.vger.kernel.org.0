Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0770012348
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 22:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfEBUYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 16:24:46 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39985 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbfEBUYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 16:24:43 -0400
Received: by mail-wr1-f65.google.com with SMTP id h4so5119352wre.7;
        Thu, 02 May 2019 13:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eNwEq5Or4bWTUzwzELHbHDLYFqTs+RWmHegQP5AuHJs=;
        b=gZEX2KMAz1ouktZbqMZSabpSdxuQ1f9Ak5DFy2bPJZHQtcPiAe+TopOEdF04ZSEzq6
         4q0c2omPbOrJ8416GG3hj8A8U+I31hfgN8IQdGiiDSX3MHqCAnH0NAMjYpMoRi+5lWo/
         y2HYmN8Z+A3b25w8b25xpd9ZXD9NUBGTH/xcHkTduFFdbPp9L95IydWJNBCS6oSWMzBZ
         m8cFYsI/Y3+KV5zLurdDZ+HJGTi5le3tbdj6F3poCTiS6IRtJrEOCTR/vQwEkj6wXnTf
         wo19DIOv7xZR6Dklp24bndiBEV5cDSurjiUmmJgvs0DSngYasq1HU//CoRFjtBOtyLmV
         cOxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eNwEq5Or4bWTUzwzELHbHDLYFqTs+RWmHegQP5AuHJs=;
        b=KX0WRWkQM9uPHNlYMt5HUGGzwcZI6F1q/0tCBdMs15ZyR3Gp7uy/XDfagvFKRzCMlb
         9WSIJ4qoIBaxmVXCarpGRxQEOcExhzCdk3Vs8/pZCp6wyLLz3Txh9FyttjcvAP71x5dh
         /gzNeN3EZe6s9tt3HQs7FHCw4tCaOrger7NfTzQNrspe69zGXa5ULt/NLMM6CjJBgeno
         EHieHBcWe1xZC6JbKcYndg1dvKsr81hYCNXea+NSNs/+AD2E1wCmqvbkItb/lIcARKDd
         UIpLIifp3/70VtrkmLnzETazAVZ2MUK3caKBheHOGNOE/djIim3k1t63T54sSJvnh/pe
         PsfQ==
X-Gm-Message-State: APjAAAVVYXbJQ/Zti6gcFkCStWLOIxJmHE1/1EmD9yZoUmDg34p2qb2y
        OoebNbHql53OOKo1BlDlltA=
X-Google-Smtp-Source: APXvYqxSpDaPmUx3zE2W3yEggWNO3mO/gSrgpE3HjxOmJFAvZfhamcJ0XHi7g24V5iNMzUWU1MJ3Lw==
X-Received: by 2002:adf:dccc:: with SMTP id x12mr4230273wrm.168.1556828682018;
        Thu, 02 May 2019 13:24:42 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id s124sm217655wmf.42.2019.05.02.13.24.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 13:24:41 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v5 net-next 04/12] net: dsa: sja1105: Error out if RGMII delays are requested in DT
Date:   Thu,  2 May 2019 23:23:32 +0300
Message-Id: <20190502202340.21054-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190502202340.21054-1-olteanv@gmail.com>
References: <20190502202340.21054-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Documentation/devicetree/bindings/net/ethernet.txt is confusing because
it says what the MAC should not do, but not what it *should* do:

  * "rgmii-rxid" (RGMII with internal RX delay provided by the PHY, the MAC
     should not add an RX delay in this case)

The gap in semantics is threefold:
1. Is it illegal for the MAC to apply the Rx internal delay by itself,
   and simplify the phy_mode (mask off "rgmii-rxid" into "rgmii") before
   passing it to of_phy_connect? The documentation would suggest yes.
1. For "rgmii-rxid", while the situation with the Rx clock skew is more
   or less clear (needs to be added by the PHY), what should the MAC
   driver do about the Tx delays? Is it an implicit wild card for the
   MAC to apply delays in the Tx direction if it can? What if those were
   already added as serpentine PCB traces, how could that be made more
   obvious through DT bindings so that the MAC doesn't attempt to add
   them twice and again potentially break the link?
3. If the interface is a fixed-link and therefore the PHY object is
   fixed (a purely software entity that obviously cannot add clock
   skew), what is the meaning of the above property?

So an interpretation of the RGMII bindings was chosen that hopefully
does not contradict their intention but also makes them more applied.
The SJA1105 driver understands to act upon "rgmii-*id" phy-mode bindings
if the port is in the PHY role (either explicitly, or if it is a
fixed-link). Otherwise it always passes the duty of setting up delays to
the PHY driver.

The error behavior that this patch adds is required on SJA1105E/T where
the MAC really cannot apply internal delays. If the other end of the
fixed-link cannot apply RGMII delays either (this would be specified
through its own DT bindings), then the situation requires PCB delays.

For SJA1105P/Q/R/S, this is however hardware supported and the error is
thus only temporary. I created a stub function pointer for configuring
delays per-port on RXC and TXC, and will implement it when I have access
to a board with this hardware setup.

Meanwhile do not allow the user to select an invalid configuration.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Changes in v5:
None.

Changes in v4:
Moved RGMII delay settings to an array in sja1105_private. The
sja1105_port structure will be used to share info with the tagger (in a
future patchset), and RGMII delays are not an example of that.
Not setting to NULL function pointers that don't need to.

Changes in v3:
None.

Changes in v2:
Patch is new.

 drivers/net/dsa/sja1105/sja1105.h          |  3 ++
 drivers/net/dsa/sja1105/sja1105_clocking.c |  5 +++-
 drivers/net/dsa/sja1105/sja1105_main.c     | 34 ++++++++++++++++++++++
 3 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 50ab9282c4f1..87dee6794d98 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -48,11 +48,14 @@ struct sja1105_info {
 	const struct sja1105_table_ops *static_ops;
 	const struct sja1105_regs *regs;
 	int (*reset_cmd)(const void *ctx, const void *data);
+	int (*setup_rgmii_delay)(const void *ctx, int port);
 	const char *name;
 };
 
 struct sja1105_private {
 	struct sja1105_static_config static_config;
+	bool rgmii_rx_delay[SJA1105_NUM_PORTS];
+	bool rgmii_tx_delay[SJA1105_NUM_PORTS];
 	const struct sja1105_info *info;
 	struct gpio_desc *reset_gpio;
 	struct spi_device *spidev;
diff --git a/drivers/net/dsa/sja1105/sja1105_clocking.c b/drivers/net/dsa/sja1105/sja1105_clocking.c
index 598544297931..94bfe0ee50a8 100644
--- a/drivers/net/dsa/sja1105/sja1105_clocking.c
+++ b/drivers/net/dsa/sja1105/sja1105_clocking.c
@@ -427,7 +427,10 @@ static int sja1105_rgmii_clocking_setup(struct sja1105_private *priv, int port)
 		dev_err(dev, "Failed to configure Tx pad registers\n");
 		return rc;
 	}
-	return 0;
+	if (!priv->info->setup_rgmii_delay)
+		return 0;
+
+	return priv->info->setup_rgmii_delay(priv, port);
 }
 
 static int sja1105_cgu_rmii_ref_clk_config(struct sja1105_private *priv,
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index ec8137eff223..d27b9c178cba 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -518,6 +518,30 @@ static int sja1105_static_config_load(struct sja1105_private *priv,
 	return sja1105_static_config_upload(priv);
 }
 
+static int sja1105_parse_rgmii_delays(struct sja1105_private *priv,
+				      const struct sja1105_dt_port *ports)
+{
+	int i;
+
+	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
+		if (ports->role == XMII_MAC)
+			continue;
+
+		if (ports->phy_mode == PHY_INTERFACE_MODE_RGMII_RXID ||
+		    ports->phy_mode == PHY_INTERFACE_MODE_RGMII_ID)
+			priv->rgmii_rx_delay[i] = true;
+
+		if (ports->phy_mode == PHY_INTERFACE_MODE_RGMII_TXID ||
+		    ports->phy_mode == PHY_INTERFACE_MODE_RGMII_ID)
+			priv->rgmii_tx_delay[i] = true;
+
+		if ((priv->rgmii_rx_delay[i] || priv->rgmii_tx_delay[i]) &&
+		     !priv->info->setup_rgmii_delay)
+			return -EINVAL;
+	}
+	return 0;
+}
+
 static int sja1105_parse_ports_node(struct sja1105_private *priv,
 				    struct sja1105_dt_port *ports,
 				    struct device_node *ports_node)
@@ -959,6 +983,16 @@ static int sja1105_setup(struct dsa_switch *ds)
 		dev_err(ds->dev, "Failed to parse DT: %d\n", rc);
 		return rc;
 	}
+
+	/* Error out early if internal delays are required through DT
+	 * and we can't apply them.
+	 */
+	rc = sja1105_parse_rgmii_delays(priv, ports);
+	if (rc < 0) {
+		dev_err(ds->dev, "RGMII delay not supported\n");
+		return rc;
+	}
+
 	/* Create and send configuration down to device */
 	rc = sja1105_static_config_load(priv, ports);
 	if (rc < 0) {
-- 
2.17.1

