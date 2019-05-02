Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFBE61234C
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 22:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfEBUZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 16:25:44 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43707 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726503AbfEBUYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 16:24:48 -0400
Received: by mail-wr1-f68.google.com with SMTP id a12so5107955wrq.10;
        Thu, 02 May 2019 13:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jf2kOfcFwhC5hgcJnB1jFK3+poVVivYESV876e0dzPE=;
        b=rLfb6q5g77wj4QG0H3930+TFWsAUVpDuHMU/c9KR5VeJwju+lCZ7ase5Wd2i6RC3d4
         /5I9UNYbZX7kkAhqztyA02dIhMzM83b5AaSbFSf4yi5RyPxsNuocOzl214jxF4YPdWC7
         4OQxwnUIGWrQmqxwiAHYrMH09dxj0rrjZOzfNHFHzEQSiwqmjZJVeEHL5jJo7dEm8wip
         93fAiwkxM5a8BCv3IXqJ9Tx+tZTnZ6oDjsVt6vGI/XRaEGcosFoVxl5/gcFCjwIjpKBV
         kXXTeHojtzYEweduVHW3GNq7x/kj+IQERqJzNvyhwuAVGgzTfEWEL0so9gtyz4nLmC8h
         qKmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jf2kOfcFwhC5hgcJnB1jFK3+poVVivYESV876e0dzPE=;
        b=LGJrls7SpfXzw7rxrS2QbH+q/ulPF0YPrRN0JYYplycldUEiDOR0UeDsoJLPl89ODJ
         QZBWSN6lKO5BPJkqYVBYyl1vfQyy7CWANtE6bKHINHm+upEDMBvma+Ctb0agFyi7AQ7W
         V5DOFHqnCqHY7jJn6hOq8zqvu852bdQ83TxF4ddPWXpMJG1ciu3H1ntFYdMdukFCk1jA
         dgve2Zot5Hl0k5s6KJKVlSrmHK4O5sdl/R0yaXlBRWLOql3iMHEmQuEVMZ9zzDkxl4+x
         +9VFZJL995bwVW6Qes134BXUMqdCYTATJ6OizQdszLSTb9gVyPlZdO++l5vjzE3SEt26
         XX8A==
X-Gm-Message-State: APjAAAXtXv+2PdM/aP/L8EO0zV6EC4CrZvFH2H80DslFRl9pnW4yOTyZ
        sef31VpXTeWtyzj2HItNToY=
X-Google-Smtp-Source: APXvYqw71dp4zvw6zuHvWPjydqgPrUmpMneG/Tqnumx/fkgbGL9WfcgP7IOSMMMj1n5bgx9kbq5mRA==
X-Received: by 2002:adf:dd8e:: with SMTP id x14mr3959974wrl.252.1556828686060;
        Thu, 02 May 2019 13:24:46 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id s124sm217655wmf.42.2019.05.02.13.24.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 13:24:45 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v5 net-next 08/12] net: dsa: sja1105: Add support for configuring address ageing time
Date:   Thu,  2 May 2019 23:23:36 +0300
Message-Id: <20190502202340.21054-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190502202340.21054-1-olteanv@gmail.com>
References: <20190502202340.21054-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If STP is active, this setting is applied on bridged ports each time an
Ethernet link is established (topology changes).

Since the setting is global to the switch and a reset is required to
change it, resets are prevented if the new callback does not change the
value that the hardware already is programmed for.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Changes in v5:
Changed "aging" to "ageing" in commit message to be consistent with the
code.

Changes in v4:
Patch is new.

 drivers/net/dsa/sja1105/sja1105.h      |  4 ++++
 drivers/net/dsa/sja1105/sja1105_main.c | 29 ++++++++++++++++++++++++--
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 38506bde83c6..0489d9adf957 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -12,6 +12,10 @@
 #define SJA1105_NUM_PORTS		5
 #define SJA1105_NUM_TC			8
 #define SJA1105ET_FDB_BIN_SIZE		4
+/* The hardware value is in multiples of 10 ms.
+ * The passed parameter is in multiples of 1 ms.
+ */
+#define SJA1105_AGEING_TIME_MS(ms)	((ms) / 10)
 
 /* Keeps the different addresses between E/T and P/Q/R/S */
 struct sja1105_regs {
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 28b11c7a81e7..f5205ce85dbe 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -193,8 +193,8 @@ static int sja1105_init_l2_lookup_params(struct sja1105_private *priv)
 {
 	struct sja1105_table *table;
 	struct sja1105_l2_lookup_params_entry default_l2_lookup_params = {
-		/* TODO Learned FDB entries are never forgotten */
-		.maxage = 0,
+		/* Learned FDB entries are forgotten after 300 seconds */
+		.maxage = SJA1105_AGEING_TIME_MS(300000),
 		/* All entries within a FDB bin are available for learning */
 		.dyn_tbsz = SJA1105ET_FDB_BIN_SIZE,
 		/* 2^8 + 2^5 + 2^3 + 2^2 + 2^1 + 1 in Koopman notation */
@@ -1249,10 +1249,35 @@ static int sja1105_setup(struct dsa_switch *ds)
 	return 0;
 }
 
+/* The MAXAGE setting belongs to the L2 Forwarding Parameters table,
+ * which cannot be reconfigured at runtime. So a switch reset is required.
+ */
+static int sja1105_set_ageing_time(struct dsa_switch *ds,
+				   unsigned int ageing_time)
+{
+	struct sja1105_l2_lookup_params_entry *l2_lookup_params;
+	struct sja1105_private *priv = ds->priv;
+	struct sja1105_table *table;
+	unsigned int maxage;
+
+	table = &priv->static_config.tables[BLK_IDX_L2_LOOKUP_PARAMS];
+	l2_lookup_params = table->entries;
+
+	maxage = SJA1105_AGEING_TIME_MS(ageing_time);
+
+	if (l2_lookup_params->maxage == maxage)
+		return 0;
+
+	l2_lookup_params->maxage = maxage;
+
+	return sja1105_static_config_reload(priv);
+}
+
 static const struct dsa_switch_ops sja1105_switch_ops = {
 	.get_tag_protocol	= sja1105_get_tag_protocol,
 	.setup			= sja1105_setup,
 	.adjust_link		= sja1105_adjust_link,
+	.set_ageing_time	= sja1105_set_ageing_time,
 	.get_strings		= sja1105_get_strings,
 	.get_ethtool_stats	= sja1105_get_ethtool_stats,
 	.get_sset_count		= sja1105_get_sset_count,
-- 
2.17.1

