Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0029634E51
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbfFDRIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:08:10 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46913 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727757AbfFDRIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:08:09 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so11386654wrw.13;
        Tue, 04 Jun 2019 10:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qi1xjQ0wj659GRdPVek4osDhFXISQR+un5DeLKDWEKU=;
        b=soqM+Wa/tg6xgJa9pIvAsQflKlUInVWLnd8eM3TBRbiC3pZZOsP5nZ8vU9mznFcTzk
         Kwul67o/0FgQSnEopzvYa6GZYdgTAT3pWcNZCzgrN0tYF/nd8TJsI7W6z6/27rdiEL9j
         Gp0pzno/qhiWhKU5gDCoeH8BDzgvmdsyfbD8Z4yqCwy1jGmRimgfTYuVZIR5wgvOk9U3
         Ec+yVWZJvHJwJw4yLHhX36h6ZYWnkLtpeZes4VxL74v0VJHng91Pxwbg5cGQM36HoL4g
         ZGfJNnY2gkq/cHXyzjEMu8PRbKqq3UXWp4up0R7pqdZ6S3qKTjT3Yxd+zuIokOMnswv7
         X1jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qi1xjQ0wj659GRdPVek4osDhFXISQR+un5DeLKDWEKU=;
        b=GvI1Rsh+xO6YOtto7/A8lMhL0uYjYh2dXeG0FetOUs+hVQZ3BiOdyYA427egpoBFaj
         mz2dPweX1fKoZNP4jCTK58K31m17MsFMIvQgC/gyMZb7FB3OSy/w9EsEJwxZb776E2is
         ILE5ddmZuPodKjhMryFFru3RWZnRAOC96dBjal8QrG+/L8JGoDuSmI5S+7CK+dl7V9Vm
         +9qQgOXiTUAU3qPbdZ8X2WeAZPAQJtTiJr66WtcICv2wk9Yg7ZZobGDvUj9rWh/42Ldo
         AV0/03LvGyBtkSJENFkPOunE/f5j0n2WRNjQrFOleAKfMi9T4yGo/xptQSse8D357jDS
         oJIg==
X-Gm-Message-State: APjAAAVjYF6CX1KMAL6V7OQw8+sH44Xia1IV++Hnr6e2Ns3fCtNBIKLe
        d8NroXbglQeekmvXN61AieQ=
X-Google-Smtp-Source: APXvYqzkZVAjPQFk3omj3JwtdDGKeVeYe+WGyeceJTNkhfSacNgSUkd7ceYOlMOEX+xRrecPWFbSug==
X-Received: by 2002:adf:e309:: with SMTP id b9mr21333415wrj.135.1559668087698;
        Tue, 04 Jun 2019 10:08:07 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id f2sm19692218wme.12.2019.06.04.10.08.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 10:08:07 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 04/17] net: dsa: sja1105: Move sja1105_change_tpid into sja1105_vlan_filtering
Date:   Tue,  4 Jun 2019 20:07:43 +0300
Message-Id: <20190604170756.14338-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190604170756.14338-1-olteanv@gmail.com>
References: <20190604170756.14338-1-olteanv@gmail.com>
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
---
Changes in v3:

None.

Changes in v2:

Patch is new.

 drivers/net/dsa/sja1105/sja1105_main.c | 42 +++++++++++++-------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index b151a8fafb9e..909497aa4b6f 100644
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

