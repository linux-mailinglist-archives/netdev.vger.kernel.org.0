Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F99311870
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhBFCiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:38:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbhBFCfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:35:20 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF34C061223
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 14:03:17 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id i8so14410410ejc.7
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 14:03:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MsV1sQIBZpuksx4sPdCdGrBtzsa4qZpu9FzXyF9RiLU=;
        b=bzktRBIakRgngCW4fmg1eSKERCtBOnq0/KK9ohDllwkjw5dY3PdVk4VNfAFUl2lcjl
         7v7aOBdqfJDoOdLFGiBVOLrG7q2iJLOsZvrXAkJsqWwjrPzNmE5DY1XVDDCARzzejLLj
         Pd0ivEnI/fnKIQlHw50yZ30CH+zaAwOPr4K6KLoz/16gF0KWsrue7Adp3LN5LMb76Za8
         8is7WZVQkgdsoVHXm0orTBK81lj11EShfPmBw76cGPgI0pgvGBdypcz9C7G+7i9g94uv
         yaoRc3ivD98atDP/DYUL5oJuZ0S/qJ7vJzEQS7zXJrzoQ4gAT6pUaKA1fr6eGBziszUc
         dIrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MsV1sQIBZpuksx4sPdCdGrBtzsa4qZpu9FzXyF9RiLU=;
        b=YcRX0MAgTClAfLUA+2ow7NSzPHlNxDVsHiAE7zMhhumb4vWtGMnzGj5AzuFnrL3v/v
         dTR/+5MI1WrBl0xls7olZkTf3PyVF8hH7WXa1t3Pi3FTJeev+/46xJswztzWa0VzESaj
         3TYZQ0bXgtW67huFbqmZjLxnDTbp1RNIm33Fs5wG7DA6AjAZC6MPPOK9hMpgTabjggQM
         yI5xN9a8/dNlBkdV+mmclJ1FIqCSj1TgkbTuJgBLv6hQSHfpkZC6dTAis9O2w40vFoQ6
         t7aIj9fydHCiiQwLuBMIa/ITtaBUgY2QqjEO253zae0GLGeRl/l+iV2MIV8u3P3hixDk
         /2tg==
X-Gm-Message-State: AOAM532cYJctR5xnkp8oIxZp80V8mcMXOaHVtl5UlPRtBlnre+xz85Do
        GlrQcqEey490U+qiGF3UZAsqsAmQbIA=
X-Google-Smtp-Source: ABdhPJykkP6n9YNLjQRzRxIS6rjykzpvoxQlOgR24NF06MjiFBMSeloYcO/qJ5y4nG+XVCPYmPV4gQ==
X-Received: by 2002:a17:906:84d7:: with SMTP id f23mr6268570ejy.87.1612562596584;
        Fri, 05 Feb 2021 14:03:16 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id t16sm4969909edi.60.2021.02.05.14.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 14:03:16 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH RESEND v3 net-next 05/12] net: mscc: ocelot: set up the bonding mask in a way that avoids a net_device
Date:   Sat,  6 Feb 2021 00:02:14 +0200
Message-Id: <20210205220221.255646-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210205220221.255646-1-olteanv@gmail.com>
References: <20210205220221.255646-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Since this code should be called from pure switchdev as well as from
DSA, we must find a way to determine the bonding mask not by looking
directly at the net_device lowers of the bonding interface, since those
could have different private structures.

We keep a pointer to the bonding upper interface, if present, in struct
ocelot_port. Then the bonding mask becomes the bitwise OR of all ports
that have the same bonding upper interface. This adds a duplication of
functionality with the current "lags" array, but the duplication will be
short-lived, since further patches will remove the latter completely.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
---
Changes in v3:
None.

Changes in v2:
Adapted to the merged version of the DSA API for LAG offload (i.e.
rejecting a bonding interface due to tx_type now done within the
.port_lag_join callback, caller is supposed to handle -EOPNOTSUPP).

 drivers/net/ethernet/mscc/ocelot.c | 29 ++++++++++++++++++++++-------
 include/soc/mscc/ocelot.h          |  2 ++
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index ef3f10f1e54f..127beedcccde 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -889,6 +889,24 @@ int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_get_ts_info);
 
+static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
+{
+	u32 mask = 0;
+	int port;
+
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+		if (!ocelot_port)
+			continue;
+
+		if (ocelot_port->bond == bond)
+			mask |= BIT(port);
+	}
+
+	return mask;
+}
+
 static u32 ocelot_get_dsa_8021q_cpu_mask(struct ocelot *ocelot)
 {
 	u32 mask = 0;
@@ -1319,20 +1337,15 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 			 struct net_device *bond,
 			 struct netdev_lag_upper_info *info)
 {
-	struct net_device *ndev;
 	u32 bond_mask = 0;
 	int lag, lp;
 
 	if (info->tx_type != NETDEV_LAG_TX_TYPE_HASH)
 		return -EOPNOTSUPP;
 
-	rcu_read_lock();
-	for_each_netdev_in_bond_rcu(bond, ndev) {
-		struct ocelot_port_private *priv = netdev_priv(ndev);
+	ocelot->ports[port]->bond = bond;
 
-		bond_mask |= BIT(priv->chip_port);
-	}
-	rcu_read_unlock();
+	bond_mask = ocelot_get_bond_mask(ocelot, bond);
 
 	lp = __ffs(bond_mask);
 
@@ -1366,6 +1379,8 @@ void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 	u32 port_cfg;
 	int i;
 
+	ocelot->ports[port]->bond = NULL;
+
 	/* Remove port from any lag */
 	for (i = 0; i < ocelot->num_phys_ports; i++)
 		ocelot->lags[i] &= ~BIT(port);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 6a61c499a30d..e36a1ed29c01 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -611,6 +611,8 @@ struct ocelot_port {
 
 	u8				*xmit_template;
 	bool				is_dsa_8021q_cpu;
+
+	struct net_device		*bond;
 };
 
 struct ocelot {
-- 
2.25.1

