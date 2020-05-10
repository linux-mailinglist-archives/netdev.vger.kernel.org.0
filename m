Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0CA1CCC54
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 18:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729143AbgEJQng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 12:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729124AbgEJQnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 12:43:33 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E643FC061A0C;
        Sun, 10 May 2020 09:43:32 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id g12so16295799wmh.3;
        Sun, 10 May 2020 09:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=S/ucj9FqaJZxqwK6ttNEH98kMzRsUXKRYHBKd01NMJ0=;
        b=qmuC8DrOSHDAALVQnKjGk39SZNRqnza6L0ea8eY8dl/g/XT06McJ2wGJxUkW2lvqRv
         zX7YdpS6aDg3Mx4FpRdvaSiYiYKY5SJ8r0lLHbqS2ZMNsER398QdyaxiY0qKrlegxCUm
         vqsVnYvgJGuxf0nlQVdA/IFGytgT+0hJ516TpfI7LZPhDfRa/qqf3tr2f3qhDqDQufSy
         ZvXUsajVF4xvji3QONCWgfyKwUkvrLR8tzUWpzGK7joCXp963sXPrceBe9BjFuTHbqYE
         C/Ip1tSsWdRJSYIx99XdA1dUXajyWwVo2jyYouwj8WmQVenSzjNnz3wawhGtxhsDIUIP
         Vl9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=S/ucj9FqaJZxqwK6ttNEH98kMzRsUXKRYHBKd01NMJ0=;
        b=H7MwZ5hFj4L8Fec34zNNiuyoFL3v9r0sCnT1ejUeiU3a3V9NvF2MVLzoKiGDJYYj21
         ln+CW4oCyWOosfgjIyFv4t6cy/eK6Eaao01y8Yfjdjcpc25w4ODb772pKqBjiF4FHPSG
         Ca+l8zb+507+3OxTL1gaLTaFV5pMXFFVU45KYt1M4ZQVAUcu6GycoJKnDhsqycVKiY71
         Eiw5fzTMui0T0aG2HuV5BQ5FWK3dSFwlamFUbGNv6/kuscezyLZwqKoOg68eoch8XkDw
         W547MJqBtVnPQ/zn5Qn/btVAJTSmrEKkG3eXu3gX3SCjgXwdbRJ3COgkvg1CEhKQ6jUl
         GMjw==
X-Gm-Message-State: AGi0PuY7jSbzYOIs6bcviJuzAbAkpv0c6xPviSYM16pow1xSL/UB3yU1
        //vPnHqdi2gML9EXJlg6FZQ=
X-Google-Smtp-Source: APiQypLPuwUkRPgewra1ItZFSUUfJFbg+CHbvtR1qKra1pq50WTsDjHWt58lOp7rO4KbpLqZO8mSfw==
X-Received: by 2002:a1c:7e4e:: with SMTP id z75mr22092030wmc.41.1589129011681;
        Sun, 10 May 2020 09:43:31 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id i1sm13390916wrx.22.2020.05.10.09.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2020 09:43:31 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 03/15] net: dsa: sja1105: keep the VLAN awareness state in a driver variable
Date:   Sun, 10 May 2020 19:42:43 +0300
Message-Id: <20200510164255.19322-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200510164255.19322-1-olteanv@gmail.com>
References: <20200510164255.19322-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Soon we'll add a third operating mode to the driver. Introduce a
vlan_state to make things more easy to manage, and use it where
applicable.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h      |  6 ++++++
 drivers/net/dsa/sja1105/sja1105_main.c | 16 ++++++++++++++++
 include/linux/dsa/sja1105.h            |  2 ++
 net/dsa/tag_sja1105.c                  |  2 +-
 4 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index a64ace07b89f..5b2b275d01a7 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -178,6 +178,11 @@ struct sja1105_flow_block {
 	int num_virtual_links;
 };
 
+enum sja1105_vlan_state {
+	SJA1105_VLAN_UNAWARE,
+	SJA1105_VLAN_FILTERING_FULL,
+};
+
 struct sja1105_private {
 	struct sja1105_static_config static_config;
 	bool rgmii_rx_delay[SJA1105_NUM_PORTS];
@@ -193,6 +198,7 @@ struct sja1105_private {
 	 * the switch doesn't confuse them with one another.
 	 */
 	struct mutex mgmt_lock;
+	enum sja1105_vlan_state vlan_state;
 	struct sja1105_tagger_data tagger_data;
 	struct sja1105_ptp_data ptp_data;
 	struct sja1105_tas_data tas_data;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index d5de9305df25..7dee9b282a1b 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1917,6 +1917,7 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 	struct sja1105_l2_lookup_params_entry *l2_lookup_params;
 	struct sja1105_general_params_entry *general_params;
 	struct sja1105_private *priv = ds->priv;
+	enum sja1105_vlan_state state;
 	struct sja1105_table *table;
 	struct sja1105_rule *rule;
 	u16 tpid, tpid2;
@@ -1940,6 +1941,13 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 		tpid2 = ETH_P_SJA1105;
 	}
 
+	if (!enabled)
+		state = SJA1105_VLAN_UNAWARE;
+	else
+		state = SJA1105_VLAN_FILTERING_FULL;
+
+	priv->vlan_state = state;
+
 	table = &priv->static_config.tables[BLK_IDX_GENERAL_PARAMS];
 	general_params = table->entries;
 	/* EtherType used to identify inner tagged (C-tag) VLAN traffic */
@@ -1985,6 +1993,14 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 	return sja1105_setup_8021q_tagging(ds, !enabled);
 }
 
+bool sja1105_can_use_vlan_as_tags(struct dsa_switch *ds)
+{
+	struct sja1105_private *priv = ds->priv;
+
+	return priv->vlan_state != SJA1105_VLAN_FILTERING_FULL;
+}
+EXPORT_SYMBOL_GPL(sja1105_can_use_vlan_as_tags);
+
 static void sja1105_vlan_add(struct dsa_switch *ds, int port,
 			     const struct switchdev_obj_port_vlan *vlan)
 {
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index fa5735c353cd..136481ce3c6f 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -61,4 +61,6 @@ struct sja1105_port {
 	bool hwts_tx_en;
 };
 
+bool sja1105_can_use_vlan_as_tags(struct dsa_switch *ds);
+
 #endif /* _NET_DSA_SJA1105_H */
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index d553bf36bd41..5368cd34bcf4 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -74,7 +74,7 @@ static inline bool sja1105_is_meta_frame(const struct sk_buff *skb)
  */
 static bool sja1105_filter(const struct sk_buff *skb, struct net_device *dev)
 {
-	if (!dsa_port_is_vlan_filtering(dev->dsa_ptr))
+	if (sja1105_can_use_vlan_as_tags(dev->dsa_ptr->ds))
 		return true;
 	if (sja1105_is_link_local(skb))
 		return true;
-- 
2.17.1

