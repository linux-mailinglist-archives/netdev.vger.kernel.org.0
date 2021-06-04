Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A22E539BA77
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 16:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbhFDOEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 10:04:46 -0400
Received: from mail-ej1-f49.google.com ([209.85.218.49]:44682 "EHLO
        mail-ej1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbhFDOEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 10:04:45 -0400
Received: by mail-ej1-f49.google.com with SMTP id c10so14624614eja.11;
        Fri, 04 Jun 2021 07:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CpJVgHTUceoxbDq/gcjcqqzG+LswC1KLVcY/Z+QzfbA=;
        b=EIJQ5L1juufTyusD9ZShvfZVWS/DJ5UPx2xVbo/hPzH6U+SD5bw91W2huYxg4LJDWz
         DozEUjChSVJS6PH9uPc5PDffeoOLAgdD+aupJSeWx2xzN2H2SIP4bXGGG3weCcNWaeCq
         15pnNrk1FaTcbcu6mAAbS+u0vGwDAPtcAqKaAEOvX/eTRXT8wbRgxjZ4QYcWmeR6rfdC
         TtOyNNU8K1cnNlgRuoeuGPEmh0UbIsO+O/Ft5QWmXhC3ORWrzlJ9ReYfN2FA0enmV6P6
         gP8yXQpKUJFIJMNEmlKgryISJSk+1EDDQB35wG4/GOwkpD9i2jiAiwk0G7yyeO+JgUg/
         z9Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CpJVgHTUceoxbDq/gcjcqqzG+LswC1KLVcY/Z+QzfbA=;
        b=NBheQPUwZRmZGqvpsoCDTKfiBpY5vOJKeZV3m1E4O8DqC4b2iovJB4/Fioh8OX9Gy+
         N3AxccWUts3DEyZlAUOEl5F4mhGxnmiK9oMpTUpcT4HvwDui95dcIIVkKzlduVa5MSn8
         9+VY39fxLdmnmM+dEtR6nh9XgLRD47KalAbnbI/woW3pn6Pl335z4M3wCens7LuIUYLg
         zswEOTtc4uHwR6CT/mYjVkkNR6V2286qXjWxsgPac9mTTNcxAdhpz7dV6J207pCyvKDe
         5JK0AHem50TImQVRHwDp+5/ZyWvwNpvTA+BN8DvVA2xoWsDmKINjLDxdB1cwdfTGWuyr
         TtBA==
X-Gm-Message-State: AOAM531R2QM7IfNNug+fIqpqSoZ42ViaarDExcmMENPKlbK7slaxnn6c
        4g1VJGaDN9Jqfh8Lw8G2EAo=
X-Google-Smtp-Source: ABdhPJwnKPp64wqzN9JyYi/cNn0wMJaU45+lwRos9BS3F+eSDXIUvIu8twTMtdZr9FHBWFrnQT4yUg==
X-Received: by 2002:a17:906:f285:: with SMTP id gu5mr4386548ejb.226.1622815318091;
        Fri, 04 Jun 2021 07:01:58 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id a22sm2804513ejv.67.2021.06.04.07.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 07:01:57 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 2/4] net: dsa: sja1105: apply RGMII delays based on the fixed-link property
Date:   Fri,  4 Jun 2021 17:01:49 +0300
Message-Id: <20210604140151.2885611-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210604140151.2885611-1-olteanv@gmail.com>
References: <20210604140151.2885611-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The sja1105 driver has an intermediate way of determining whether the
RGMII delays should be applied by the PHY or by itself: by looking at
the port role (PHY or MAC). The port can be put in the PHY role either
explicitly (sja1105,role-phy) or implicitly (fixed-link).

We want to deprecate the sja1105,role-phy property, so all that remains
is the fixed-link property. Introduce a "fixed_link" array of booleans
in the driver, and use that to determine whether RGMII delays must be
applied or not.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h      |  1 +
 drivers/net/dsa/sja1105/sja1105_main.c | 28 +++++++++++++-------------
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 867cda832e77..3c66e5945cca 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -226,6 +226,7 @@ struct sja1105_private {
 	bool rgmii_rx_delay[SJA1105_MAX_NUM_PORTS];
 	bool rgmii_tx_delay[SJA1105_MAX_NUM_PORTS];
 	phy_interface_t phy_mode[SJA1105_MAX_NUM_PORTS];
+	bool fixed_link[SJA1105_MAX_NUM_PORTS];
 	bool best_effort_vlan_filtering;
 	unsigned long learn_ena;
 	unsigned long ucast_egress_floods;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 84edd054781b..5839c1e0475a 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -799,26 +799,25 @@ static int sja1105_static_config_load(struct sja1105_private *priv,
 	return sja1105_static_config_upload(priv);
 }
 
-static int sja1105_parse_rgmii_delays(struct sja1105_private *priv,
-				      const struct sja1105_dt_port *ports)
+static int sja1105_parse_rgmii_delays(struct sja1105_private *priv)
 {
 	struct dsa_switch *ds = priv->ds;
-	int i;
+	int port;
 
-	for (i = 0; i < ds->num_ports; i++) {
-		if (ports[i].role == XMII_MAC)
+	for (port = 0; port < ds->num_ports; port++) {
+		if (!priv->fixed_link[port])
 			continue;
 
-		if (ports[i].phy_mode == PHY_INTERFACE_MODE_RGMII_RXID ||
-		    ports[i].phy_mode == PHY_INTERFACE_MODE_RGMII_ID)
-			priv->rgmii_rx_delay[i] = true;
+		if (priv->phy_mode[port] == PHY_INTERFACE_MODE_RGMII_RXID ||
+		    priv->phy_mode[port] == PHY_INTERFACE_MODE_RGMII_ID)
+			priv->rgmii_rx_delay[port] = true;
 
-		if (ports[i].phy_mode == PHY_INTERFACE_MODE_RGMII_TXID ||
-		    ports[i].phy_mode == PHY_INTERFACE_MODE_RGMII_ID)
-			priv->rgmii_tx_delay[i] = true;
+		if (priv->phy_mode[port] == PHY_INTERFACE_MODE_RGMII_TXID ||
+		    priv->phy_mode[port] == PHY_INTERFACE_MODE_RGMII_ID)
+			priv->rgmii_tx_delay[port] = true;
 
-		if ((priv->rgmii_rx_delay[i] || priv->rgmii_tx_delay[i]) &&
-		     !priv->info->setup_rgmii_delay)
+		if ((priv->rgmii_rx_delay[port] || priv->rgmii_tx_delay[port]) &&
+		    !priv->info->setup_rgmii_delay)
 			return -EINVAL;
 	}
 	return 0;
@@ -867,6 +866,7 @@ static int sja1105_parse_ports_node(struct sja1105_private *priv,
 			/* phy-handle is missing, but fixed-link isn't.
 			 * So it's a fixed link. Default to PHY role.
 			 */
+			priv->fixed_link[index] = true;
 			ports[index].role = XMII_PHY;
 		} else {
 			/* phy-handle present => put port in MAC role */
@@ -3021,7 +3021,7 @@ static int sja1105_setup(struct dsa_switch *ds)
 	/* Error out early if internal delays are required through DT
 	 * and we can't apply them.
 	 */
-	rc = sja1105_parse_rgmii_delays(priv, ports);
+	rc = sja1105_parse_rgmii_delays(priv);
 	if (rc < 0) {
 		dev_err(ds->dev, "RGMII delay not supported\n");
 		return rc;
-- 
2.25.1

