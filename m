Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE44C38E72F
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 15:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbhEXNQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 09:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbhEXNQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 09:16:14 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70892C06138A
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 06:14:45 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id c20so41799451ejm.3
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 06:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aMeRrQRmroe6ObDStzwM5JRa1zE8nTTeB2bGk0hllpU=;
        b=aHiwgK9zbLiVhBxuUerK1UkUK2EstRMN0cPpEMWEH2pUvpBuzqSKb/8HY/e81C1Bkg
         bUw9jAgXoTDdEXq2quL122xrryRioVSxZCfuuojyclnQ9P13eXkZpHTSwRdmJDGU7uS/
         Tzd9FEaiP++vVj1hveCH35XZnI07ldHnZuAXRHFy5CXcf9bFJy3qy5Df/HeNuHIeUgvr
         QRZlv2mLI0jPMWJWFzem4GenfznqJKot+eHA0CV9rhbFrcJveh/zbtrSRjNkgVudHWM4
         AgUdhuqcI7T0mux+ZBBQWDQzNw08iYkUK7pigFIgKxa0la+I50rG1aOY1NykRyQlzr4Z
         YyLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aMeRrQRmroe6ObDStzwM5JRa1zE8nTTeB2bGk0hllpU=;
        b=nc+OTPMcBH76zfd0Rt0+lSWHIKvyds4noAWB9mxtxq/57ibI9CeUG6Iw1hl+nby3Rx
         L79qY4fIuQtDSKxaiQmqXSti0U7vfYc15Uus0JN6HDmJy+KgKiWzv34ZN4rkYLawWYV5
         xjwqeANpSw0k2zVwLdATSifrmOkYpg+woYpq7CCNY1MkZAEUaPRzfQvEIQv0byCuMabT
         ewglzIqxEmO4SmujG/gfYp1mTLZJ/snRc+4buxRFQnl8/DpwXyPjoLzQRYS0HQIuEaNH
         UrAkP4oHe9nOR7OsgJTcaYHGkjCw/PZ6m6gpB4d528xD9lbYwOGqOU5swyMf5a5BFGv0
         lD1g==
X-Gm-Message-State: AOAM530/IrY3OhoJOwHLgcLIih4O621cJuXUCMONDaT6iZ3wjl/mQ6Nc
        btqurtzcQf9HsfIkGm+W1Yc=
X-Google-Smtp-Source: ABdhPJwX/Mr4tiezmixbNd9TJLA6oJbeQ9piPUt3l4yisEMno5Rl7UqlqmTxohAysrypDx/fuMCPwQ==
X-Received: by 2002:a17:906:8586:: with SMTP id v6mr22989814ejx.304.1621862084064;
        Mon, 24 May 2021 06:14:44 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g13sm8009139ejz.24.2021.05.24.06.14.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 06:14:43 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 2/9] net: dsa: sja1105: avoid some work for unused ports
Date:   Mon, 24 May 2021 16:14:14 +0300
Message-Id: <20210524131421.1030789-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524131421.1030789-1-olteanv@gmail.com>
References: <20210524131421.1030789-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Do not put unused ports in the forwarding domain, and do not allocate
FDB entries for dynamic address learning for them.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 27 +++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 0e4e27b444fa..32bdbdb7cba2 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -298,14 +298,22 @@ static int sja1105_init_l2_lookup_params(struct sja1105_private *priv)
 		.drpnolearn = true,
 	};
 	struct dsa_switch *ds = priv->ds;
+	int port, num_used_ports = 0;
 	struct sja1105_table *table;
 	u64 max_fdb_entries;
-	int port;
-
-	max_fdb_entries = SJA1105_MAX_L2_LOOKUP_COUNT / ds->num_ports;
 
 	for (port = 0; port < ds->num_ports; port++)
+		if (!dsa_is_unused_port(ds, port))
+			num_used_ports++;
+
+	max_fdb_entries = SJA1105_MAX_L2_LOOKUP_COUNT / num_used_ports;
+
+	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_is_unused_port(ds, port))
+			continue;
+
 		default_l2_lookup_params.maxaddrp[port] = max_fdb_entries;
+	}
 
 	table = &priv->static_config.tables[BLK_IDX_L2_LOOKUP_PARAMS];
 
@@ -419,6 +427,9 @@ static int sja1105_init_l2_forwarding(struct sja1105_private *priv)
 	for (i = 0; i < ds->num_ports; i++) {
 		unsigned int upstream = dsa_upstream_port(priv->ds, i);
 
+		if (dsa_is_unused_port(ds, i))
+			continue;
+
 		for (j = 0; j < SJA1105_NUM_TC; j++)
 			l2fwd[i].vlan_pmap[j] = j;
 
@@ -440,12 +451,18 @@ static int sja1105_init_l2_forwarding(struct sja1105_private *priv)
 		l2fwd[upstream].bc_domain |= BIT(i);
 		l2fwd[upstream].fl_domain |= BIT(i);
 	}
+
 	/* Next 8 entries define VLAN PCP mapping from ingress to egress.
 	 * Create a one-to-one mapping.
 	 */
-	for (i = 0; i < SJA1105_NUM_TC; i++)
-		for (j = 0; j < ds->num_ports; j++)
+	for (i = 0; i < SJA1105_NUM_TC; i++) {
+		for (j = 0; j < ds->num_ports; j++) {
+			if (dsa_is_unused_port(ds, j))
+				continue;
+
 			l2fwd[ds->num_ports + i].vlan_pmap[j] = i;
+		}
+	}
 
 	return 0;
 }
-- 
2.25.1

