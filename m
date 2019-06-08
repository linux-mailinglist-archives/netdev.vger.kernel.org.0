Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC6C439F8B
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 14:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbfFHMFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 08:05:43 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53470 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727360AbfFHMFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 08:05:40 -0400
Received: by mail-wm1-f68.google.com with SMTP id x15so4440788wmj.3;
        Sat, 08 Jun 2019 05:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rKmaUol3AJJCotkUF9lP9xkA27+huL//MWeYV5SAbW4=;
        b=IM3G9RQ3lUlExkH2lDxaxEY5t3WBx1SbXLepblj+ZTO0By5JguN1fyT/bZPOd9IKJi
         JysB0vY+GROdcv2auC6q0zmzcm016cTe9aPje5B+//kiGShu7QGrDW86WiNET61ESEEN
         YohqPcl8qx9keNoe4ihHGL/vVxYh0znfIS9VDlBOdt1dy71sF225GELjjklGTH771MmY
         ryfVJU/MEWeHj6kJ0LRK3fZGTZkFnNst3mGBZa7uIVLi8dxp8wCdYF1wxrCy9YNXrJQG
         fzvr1rTIv/xJhTSznk5R4Poxb/5ye2vFmdGhSPXqGkPYNzL41s/3BrUYBE9lEgaHlpMD
         h7Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rKmaUol3AJJCotkUF9lP9xkA27+huL//MWeYV5SAbW4=;
        b=S5CuyjW9s22iarWvVEZ/c5nmhlI0DHmFT+AingootfLNJfHS+pr7f+9tUqk04iP1ec
         k6qMFc2Tv9vM51ECm65SWAG6xvFxdnqr2uAzyr7qN8mJMy6OYpUoxtEOLQTZA+S19gTC
         BFCpBtHY5oH5eBvQIiSXWCDS7w2Xug897wQIrOCJubP5zPPwyieTCFgtDeXZMpqQbdDN
         SaMxt1atq8b5L3kCvyxQJa7GjOYmWzEUUf7cee+6oaVWwKwyU8aJYqtaUgb3g9wZfjHZ
         uti7OBtQaey2hN2GmasqcLkQI2hCCs0Ol411gD6CzMMFcbaovaTkIre00jd/IqwSC7cO
         avBw==
X-Gm-Message-State: APjAAAWf01zCH6tlzHTK8s4W6/S8E8JEMhb5dyIB4OH23ZSwL0pc1Pzt
        SmuLGxr99tdUE4TpkQkO5ME=
X-Google-Smtp-Source: APXvYqyDGd4lrCSbk7VshYpo05oAAJZwt/DJ7pZWFlzKLgYhw8ZyUm610nMEGM98bKg6vcgB4NvZKQ==
X-Received: by 2002:a1c:35c9:: with SMTP id c192mr7152807wma.147.1559995538689;
        Sat, 08 Jun 2019 05:05:38 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id j16sm5440030wre.94.2019.06.08.05.05.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 05:05:38 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v4 net-next 04/17] net: dsa: sja1105: Move sja1105_change_tpid into sja1105_vlan_filtering
Date:   Sat,  8 Jun 2019 15:04:30 +0300
Message-Id: <20190608120443.21889-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190608120443.21889-1-olteanv@gmail.com>
References: <20190608120443.21889-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a cosmetic patch, pre-cursor to making another change to the
General Parameters Table (incl_srcpt) which does not logically pertain
to the sja1105_change_tpid function name, but not putting it there would
otherwise create a need of resetting the switch twice.

So simply move the existing code into the .port_vlan_filtering callback,
where the incl_srcpt change will be added as well.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v4:

None.

Changes in v3:

None.

Changes in v2:

Patch is new.

 drivers/net/dsa/sja1105/sja1105_main.c | 42 +++++++++++++-------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 66e90bbe8bc9..8ee63f2e6529 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1289,23 +1289,6 @@ static int sja1105_static_config_reload(struct sja1105_private *priv)
 	return rc;
 }
 
-/* The TPID setting belongs to the General Parameters table,
- * which can only be partially reconfigured at runtime (and not the TPID).
- * So a switch reset is required.
- */
-static int sja1105_change_tpid(struct sja1105_private *priv,
-			       u16 tpid, u16 tpid2)
-{
-	struct sja1105_general_params_entry *general_params;
-	struct sja1105_table *table;
-
-	table = &priv->static_config.tables[BLK_IDX_GENERAL_PARAMS];
-	general_params = table->entries;
-	general_params->tpid = tpid;
-	general_params->tpid2 = tpid2;
-	return sja1105_static_config_reload(priv);
-}
-
 static int sja1105_pvid_apply(struct sja1105_private *priv, int port, u16 pvid)
 {
 	struct sja1105_mac_config_entry *mac;
@@ -1424,17 +1407,34 @@ static int sja1105_vlan_prepare(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+/* The TPID setting belongs to the General Parameters table,
+ * which can only be partially reconfigured at runtime (and not the TPID).
+ * So a switch reset is required.
+ */
 static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 {
+	struct sja1105_general_params_entry *general_params;
 	struct sja1105_private *priv = ds->priv;
+	struct sja1105_table *table;
+	u16 tpid, tpid2;
 	int rc;
 
-	if (enabled)
+	if (enabled) {
 		/* Enable VLAN filtering. */
-		rc = sja1105_change_tpid(priv, ETH_P_8021Q, ETH_P_8021AD);
-	else
+		tpid  = ETH_P_8021Q;
+		tpid2 = ETH_P_8021AD;
+	} else {
 		/* Disable VLAN filtering. */
-		rc = sja1105_change_tpid(priv, ETH_P_SJA1105, ETH_P_SJA1105);
+		tpid  = ETH_P_SJA1105;
+		tpid2 = ETH_P_SJA1105;
+	}
+
+	table = &priv->static_config.tables[BLK_IDX_GENERAL_PARAMS];
+	general_params = table->entries;
+	general_params->tpid = tpid;
+	general_params->tpid2 = tpid2;
+
+	rc = sja1105_static_config_reload(priv);
 	if (rc)
 		dev_err(ds->dev, "Failed to change VLAN Ethertype\n");
 
-- 
2.17.1

