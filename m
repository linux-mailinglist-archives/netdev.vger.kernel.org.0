Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB633250A
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 23:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbfFBVk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 17:40:29 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50410 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbfFBVk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 17:40:27 -0400
Received: by mail-wm1-f65.google.com with SMTP id f204so5228380wme.0;
        Sun, 02 Jun 2019 14:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=b/L012jALOwBrTcoSxMErbhZIw2hpGvLu3wWgRywTB0=;
        b=DIpxOjXUyrLAszbiCXGWMd+f41HQXywVEdenEIT26jckilmFT4fU8+M4rY+OdtSTxy
         hF4LGQS6vgoBl4KVST24maPst+tL9cvnNAZ3sWc5DM1CnQ1bps8flBULnXcjZD2dYtEf
         VCVbHHgK2qtmLdp2G2bkvSBaVQjXlfuvjgS3Arf1SgsaJsfEwKe1Mj2/xwMGW0jHj3qN
         Ps3HbwahOJERWVeFl1iXjMFV7+k5NK+1eYRe8lycNGioyANxiGoewSP516XthVAJpdzz
         SMJU8zcvkGrNllxF6I9JeQPA9Admx563BCv9qxJSagw+yZHiPGw22G1QWnnXUF6wCfE5
         8iEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=b/L012jALOwBrTcoSxMErbhZIw2hpGvLu3wWgRywTB0=;
        b=Da8aheltCj1uav8x3/sC9A5PwJM7BVlUTnC2nQq+5FyOTfpLpS8QrXcasUHyljrOSE
         244Pf27vnY7AjtMNFPB0JGu3J61SEUudHJ98xP3rg8goPANOhEhA2K1dWWtDFxgKaf9z
         WcJLEhkJZpHCHbV0JftM7Jtyeh7XvIELwV84HxYlE5L81tW4+XBUA6/7c8clH/UQdzwX
         L3cQA6VcQR2FzzHePOfM2rQ+grPmfNg3k+zDR31mryk60mfYidocX1ayjA125osV3LvB
         bifl7F2TNJX/d8e8uSRQgXwXVTJZBH4fgRhQgsyd/4w8lC+Sw364y/x8kY6QOwDvff6m
         JUOg==
X-Gm-Message-State: APjAAAVcCHwBXmnFeIMfO28ZUepgCiiX3XQ3en9zakZun6TevVFXkUBg
        kvFrPC0Y3q3SvNJVLTTqCts=
X-Google-Smtp-Source: APXvYqz4AN/NYOAKtVEeykepjcgoUBkIo9itiQh6LJu+4thVnwxhOtU5pYnpmgvWftoH0RoURleduQ==
X-Received: by 2002:a1c:ef05:: with SMTP id n5mr170491wmh.149.1559511625781;
        Sun, 02 Jun 2019 14:40:25 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id 65sm26486793wro.85.2019.06.02.14.40.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 14:40:25 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 04/10] net: dsa: sja1105: Move sja1105_change_tpid into sja1105_vlan_filtering
Date:   Mon,  3 Jun 2019 00:39:20 +0300
Message-Id: <20190602213926.2290-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190602213926.2290-1-olteanv@gmail.com>
References: <20190602213926.2290-1-olteanv@gmail.com>
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

