Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426A43A3237
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 19:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbhFJRiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 13:38:09 -0400
Received: from mail-ej1-f41.google.com ([209.85.218.41]:39544 "EHLO
        mail-ej1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbhFJRiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 13:38:02 -0400
Received: by mail-ej1-f41.google.com with SMTP id l1so443645ejb.6
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 10:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1t3RaxyVyJVD7mirypPBdoS9B/N0JlFENjTUbHk6/1Q=;
        b=TT22kNvLDYwsZxVJPrDtcNGUPir0GQbTo6IKXmnHedFk4gfoSTUtTfz2igeZHSRhFh
         E9cNoI/qiD3JusTa639kFYf+WPsxLYmXtWZABW9KVqfWoiWAPJLnnMDy2lzh6raHFiz8
         PtxBPauOSA0wwGmE7ONIatURLn7kGEI5CPX1EsSTOd9G8ie49yVY7smkImJ8bdBs6qVf
         1yIPYE6s0Oxe/pdoXHRRNg+sQ2c1CwJvsqpuzO2Uk8Rm1/SX6xJtzMhmkwPXudPRWk6c
         wUaEQUuNOpd/bFUqDAqy7VoUHO7xnVQ3s2Y1atZ+2/lkCw6V39fgGoWswKMn0rbrKHMv
         aBeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1t3RaxyVyJVD7mirypPBdoS9B/N0JlFENjTUbHk6/1Q=;
        b=r2Hnw4runLH5zmhD39zI1xpW+TrbIXj30uY2TBpRlRRofblurNRtClXWpTgIr0jdjp
         OmybuONe/G3hNsZENDHqpzGQDyHXKxymAoWP8AnABOr7/DxaAtBD+GCtoZcpLSneWFDX
         oONM6hUP0D3VohyAVyJln4UE0eUh5f6bp8J4LAdMBzNK6E/ilPETUehD4shVZA7lAmeL
         bmLilKgy5KuGrhAjjGilBNKI/LYY/9MrTSDp1qi3bIUSCa+r7UMZAZSLq1bOi2/Zdb4C
         rVibxXoFrLPIZbSmEx4RQDdQuAnirvgF3Uo2ZXKPImgsAnxMbWqsILhYmC0e/OUSnhaV
         JbRQ==
X-Gm-Message-State: AOAM530WALUM1IkD8/+vg3iFCmWZhf2KZ2RaSV5obtDMV9fsMhL5VE6y
        aH9luF2BnKdIl92Mjyl38p0=
X-Google-Smtp-Source: ABdhPJxTIO5rNnyfixQhR/rG0BDGqSrev/161DNyEkyDEYbPuKQfY/eKlt842Y8i/CmLQCsKOBfLVw==
X-Received: by 2002:a17:906:af85:: with SMTP id mj5mr741163ejb.352.1623346504560;
        Thu, 10 Jun 2021 10:35:04 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g17sm1789595edp.14.2021.06.10.10.35.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 10:35:03 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 06/10] net: dsa: tag_8021q: refactor RX VLAN parsing into a dedicated function
Date:   Thu, 10 Jun 2021 20:34:21 +0300
Message-Id: <20210610173425.1791379-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210610173425.1791379-1-olteanv@gmail.com>
References: <20210610173425.1791379-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The added value of this function is that it can deal with both the case
where the VLAN header is in the skb head, as well as in the offload field.
This is something I was not able to do using other functions in the
network stack.

Since both ocelot-8021q and sja1105 need to do the same stuff, let's
make it a common service provided by tag_8021q.

This is done as refactoring for the new SJA1110 tagger, which partly
uses tag_8021q as well (just like SJA1105), and will be the third caller.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/dsa/8021q.h  |  3 +++
 net/dsa/tag_8021q.c        | 22 ++++++++++++++++++++++
 net/dsa/tag_ocelot_8021q.c | 18 ++----------------
 net/dsa/tag_sja1105.c      | 33 +++++++++++----------------------
 4 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index cbf2c9b1ee4f..1587961f1a7b 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -50,6 +50,9 @@ int dsa_8021q_crosschip_bridge_leave(struct dsa_8021q_context *ctx, int port,
 struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
 			       u16 tpid, u16 tci);
 
+void dsa_8021q_rcv(struct sk_buff *skb, int *source_port, int *switch_id,
+		   int *subvlan);
+
 u16 dsa_8021q_tx_vid(struct dsa_switch *ds, int port);
 
 u16 dsa_8021q_rx_vid(struct dsa_switch *ds, int port);
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 122ad5833fb1..74bcf48169be 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -471,4 +471,26 @@ struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_xmit);
 
+void dsa_8021q_rcv(struct sk_buff *skb, int *source_port, int *switch_id,
+		   int *subvlan)
+{
+	u16 vid, tci;
+
+	skb_push_rcsum(skb, ETH_HLEN);
+	if (skb_vlan_tag_present(skb)) {
+		tci = skb_vlan_tag_get(skb);
+		__vlan_hwaccel_clear_tag(skb);
+	} else {
+		__skb_vlan_pop(skb, &tci);
+	}
+	skb_pull_rcsum(skb, ETH_HLEN);
+
+	vid = tci & VLAN_VID_MASK;
+
+	*source_port = dsa_8021q_rx_source_port(vid);
+	*switch_id = dsa_8021q_rx_switch_id(vid);
+	*subvlan = dsa_8021q_rx_subvlan(vid);
+	skb->priority = (tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
+}
+
 MODULE_LICENSE("GPL v2");
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index 663b74793cfc..85ac85c3af8c 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -41,29 +41,15 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 				  struct net_device *netdev,
 				  struct packet_type *pt)
 {
-	int src_port, switch_id, qos_class;
-	u16 vid, tci;
+	int src_port, switch_id, subvlan;
 
-	skb_push_rcsum(skb, ETH_HLEN);
-	if (skb_vlan_tag_present(skb)) {
-		tci = skb_vlan_tag_get(skb);
-		__vlan_hwaccel_clear_tag(skb);
-	} else {
-		__skb_vlan_pop(skb, &tci);
-	}
-	skb_pull_rcsum(skb, ETH_HLEN);
-
-	vid = tci & VLAN_VID_MASK;
-	src_port = dsa_8021q_rx_source_port(vid);
-	switch_id = dsa_8021q_rx_switch_id(vid);
-	qos_class = (tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
+	dsa_8021q_rcv(skb, &src_port, &switch_id, &subvlan);
 
 	skb->dev = dsa_master_find_slave(netdev, switch_id, src_port);
 	if (!skb->dev)
 		return NULL;
 
 	skb->offload_fwd_mark = 1;
-	skb->priority = qos_class;
 
 	return skb;
 }
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 92e147293acf..a70625fe64f7 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -275,44 +275,33 @@ static void sja1105_decode_subvlan(struct sk_buff *skb, u16 subvlan)
 	__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vlan_tci);
 }
 
+static bool sja1105_skb_has_tag_8021q(const struct sk_buff *skb)
+{
+	u16 tpid = ntohs(eth_hdr(skb)->h_proto);
+
+	return tpid == ETH_P_SJA1105 || tpid == ETH_P_8021Q ||
+	       skb_vlan_tag_present(skb);
+}
+
 static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 				   struct net_device *netdev,
 				   struct packet_type *pt)
 {
+	int source_port, switch_id, subvlan = 0;
 	struct sja1105_meta meta = {0};
-	int source_port, switch_id;
 	struct ethhdr *hdr;
-	u16 tpid, vid, tci;
 	bool is_link_local;
-	u16 subvlan = 0;
-	bool is_tagged;
 	bool is_meta;
 
 	hdr = eth_hdr(skb);
-	tpid = ntohs(hdr->h_proto);
-	is_tagged = (tpid == ETH_P_SJA1105 || tpid == ETH_P_8021Q ||
-		     skb_vlan_tag_present(skb));
 	is_link_local = sja1105_is_link_local(skb);
 	is_meta = sja1105_is_meta_frame(skb);
 
 	skb->offload_fwd_mark = 1;
 
-	if (is_tagged) {
+	if (sja1105_skb_has_tag_8021q(skb)) {
 		/* Normal traffic path. */
-		skb_push_rcsum(skb, ETH_HLEN);
-		if (skb_vlan_tag_present(skb)) {
-			tci = skb_vlan_tag_get(skb);
-			__vlan_hwaccel_clear_tag(skb);
-		} else {
-			__skb_vlan_pop(skb, &tci);
-		}
-		skb_pull_rcsum(skb, ETH_HLEN);
-
-		vid = tci & VLAN_VID_MASK;
-		source_port = dsa_8021q_rx_source_port(vid);
-		switch_id = dsa_8021q_rx_switch_id(vid);
-		skb->priority = (tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
-		subvlan = dsa_8021q_rx_subvlan(vid);
+		dsa_8021q_rcv(skb, &source_port, &switch_id, &subvlan);
 	} else if (is_link_local) {
 		/* Management traffic path. Switch embeds the switch ID and
 		 * port ID into bytes of the destination MAC, courtesy of
-- 
2.25.1

