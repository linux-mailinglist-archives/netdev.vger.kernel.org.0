Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75BF6190176
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 23:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgCWW7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 18:59:36 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39575 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbgCWW7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 18:59:35 -0400
Received: by mail-wr1-f67.google.com with SMTP id p10so6835008wrt.6
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 15:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=etrMG9r3uPgO6iqWN9h+HJHmsxYLzY4l5a6/Z3F9CC0=;
        b=H7QP4imUjPMSNZlM/tda4espX0S0S37M6K+tA3WMq95dgpE99kCt5fP3zb3Jgu7h2e
         Wujv4leJ3tw/n0RhTtE+Vjp7XGd3BUsMySM29p3ivdTSoCe602jQKMdKTL2wMbmGkPw7
         TaZJOnDzbRx/xAorG4egdu2Lvw3BpLyQaFYvzWTlczqrR+mXKcCPwe1vQLLb9D1OuEPF
         mc31bcdGB0z8HJziLy632mygUbrc3c9oiSOAkANNS7P7FRlyMlAS6hqy4j5aBgxdZlCe
         nZ2cPZdwfae4Z5jKMzXWbGMnVgkWOo0QzSFDp8UckSWEHY5WHxo1ZYQpggSVIkP8ny6q
         ZC0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=etrMG9r3uPgO6iqWN9h+HJHmsxYLzY4l5a6/Z3F9CC0=;
        b=kySAfC5c2bNdceqdr3f3IZy6kjtXcEk8Snc2rIOJU/yvDLO1Vu4fc5SZgK19nOCWqf
         nnnLGhmJw+okYjPIK/6X5Hl2nN9oJp0caqrssoFlvJq5S8YIX4Fyi/o2NLzc8hTy8pWK
         dC00SgarpkVHkz0NRSJ7Zs8Mz6C19bcwX+McabjS4pwxRNzKkwclfSU3/Tc5fnvZ+TOD
         ZnS/Nu1PLOYDSKIgFYI648KH/mlC72FYsKB4QgWmUG/SUprGYiOwEDx6QPdQpgtR1c0g
         g2lUsfvOaxmBjVB4S9++F3tAO1w/IBZZ4Mf6BjxPNQEelLC+Q+XvNKK1kPhyvoyThH+I
         idvQ==
X-Gm-Message-State: ANhLgQ3SbPNDHd9mcEaN0r7IrIwHGUSwvkLxaB4tcyaXPwpkOhcGK1Es
        CMSL3roDEABxHEqAh/dQr/o=
X-Google-Smtp-Source: ADFU+vsW7/nw2qnRYlNmpfgxXH2UP8PpK+v0BDfNBiEwKKULmhYUx1rblC/y1KEMhFP69wYj/GDEEQ==
X-Received: by 2002:a5d:4284:: with SMTP id k4mr6891690wrq.310.1585004372387;
        Mon, 23 Mar 2020 15:59:32 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id r3sm26332912wrm.35.2020.03.23.15.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 15:59:31 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, richardcochran@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        christian.herber@nxp.com, yangbo.lu@nxp.com, netdev@vger.kernel.org
Subject: [PATCH net-next 1/4] net: dsa: sja1105: unconditionally set DESTMETA and SRCMETA in AVB table
Date:   Tue, 24 Mar 2020 00:59:21 +0200
Message-Id: <20200323225924.14347-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200323225924.14347-1-olteanv@gmail.com>
References: <20200323225924.14347-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

These fields configure the destination and source MAC address that the
switch will put in the Ethernet frames sent towards the CPU port that
contain RX timestamps for PTP.

These fields do not enable the feature itself, that is configured via
SEND_META0 and SEND_META1 in the General Params table.

The implication of this patch is that the AVB Params table will always
be present in the static config. Which doesn't really hurt.

This is needed because in a future patch, we will add another field from
this table, CAS_MASTER, for configuring the PTP_CLK pin function. That
can be configured irrespective of whether RX timestamping is enabled or
not, so always having this table present is going to simplify things a
bit.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 32 ++++++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_ptp.c  | 38 --------------------------
 2 files changed, 32 insertions(+), 38 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index afafe2ecf248..4d182293ca1f 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -479,6 +479,35 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 	return 0;
 }
 
+static int sja1105_init_avb_params(struct sja1105_private *priv)
+{
+	struct sja1105_avb_params_entry *avb;
+	struct sja1105_table *table;
+
+	table = &priv->static_config.tables[BLK_IDX_AVB_PARAMS];
+
+	/* Discard previous AVB Parameters Table */
+	if (table->entry_count) {
+		kfree(table->entries);
+		table->entry_count = 0;
+	}
+
+	table->entries = kcalloc(SJA1105_MAX_AVB_PARAMS_COUNT,
+				 table->ops->unpacked_entry_size, GFP_KERNEL);
+	if (!table->entries)
+		return -ENOMEM;
+
+	table->entry_count = SJA1105_MAX_AVB_PARAMS_COUNT;
+
+	avb = table->entries;
+
+	/* Configure the MAC addresses for meta frames */
+	avb->destmeta = SJA1105_META_DMAC;
+	avb->srcmeta  = SJA1105_META_SMAC;
+
+	return 0;
+}
+
 #define SJA1105_RATE_MBPS(speed) (((speed) * 64000) / 1000)
 
 static void sja1105_setup_policer(struct sja1105_l2_policing_entry *policing,
@@ -567,6 +596,9 @@ static int sja1105_static_config_load(struct sja1105_private *priv,
 	if (rc < 0)
 		return rc;
 	rc = sja1105_init_general_params(priv);
+	if (rc < 0)
+		return rc;
+	rc = sja1105_init_avb_params(priv);
 	if (rc < 0)
 		return rc;
 
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index a836fc38c4a4..a07aaf55068f 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -44,39 +44,6 @@ enum sja1105_ptp_clk_mode {
 #define ptp_data_to_sja1105(d) \
 		container_of((d), struct sja1105_private, ptp_data)
 
-static int sja1105_init_avb_params(struct sja1105_private *priv,
-				   bool on)
-{
-	struct sja1105_avb_params_entry *avb;
-	struct sja1105_table *table;
-
-	table = &priv->static_config.tables[BLK_IDX_AVB_PARAMS];
-
-	/* Discard previous AVB Parameters Table */
-	if (table->entry_count) {
-		kfree(table->entries);
-		table->entry_count = 0;
-	}
-
-	/* Configure the reception of meta frames only if requested */
-	if (!on)
-		return 0;
-
-	table->entries = kcalloc(SJA1105_MAX_AVB_PARAMS_COUNT,
-				 table->ops->unpacked_entry_size, GFP_KERNEL);
-	if (!table->entries)
-		return -ENOMEM;
-
-	table->entry_count = SJA1105_MAX_AVB_PARAMS_COUNT;
-
-	avb = table->entries;
-
-	avb->destmeta = SJA1105_META_DMAC;
-	avb->srcmeta  = SJA1105_META_SMAC;
-
-	return 0;
-}
-
 /* Must be called only with priv->tagger_data.state bit
  * SJA1105_HWTS_RX_EN cleared
  */
@@ -86,17 +53,12 @@ static int sja1105_change_rxtstamping(struct sja1105_private *priv,
 	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
 	struct sja1105_general_params_entry *general_params;
 	struct sja1105_table *table;
-	int rc;
 
 	table = &priv->static_config.tables[BLK_IDX_GENERAL_PARAMS];
 	general_params = table->entries;
 	general_params->send_meta1 = on;
 	general_params->send_meta0 = on;
 
-	rc = sja1105_init_avb_params(priv, on);
-	if (rc < 0)
-		return rc;
-
 	/* Initialize the meta state machine to a known state */
 	if (priv->tagger_data.stampable_skb) {
 		kfree_skb(priv->tagger_data.stampable_skb);
-- 
2.17.1

