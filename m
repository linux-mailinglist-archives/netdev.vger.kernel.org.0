Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793C93A490E
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 21:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbhFKTEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 15:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbhFKTEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 15:04:04 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D40C0617AF
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 12:01:51 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id cb9so38307365edb.1
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 12:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b1KvMf8s5EhiJMj3yOgQkSXP/S6umLhie9PjvT6a+9U=;
        b=i6rhWaxPyYykQQDTPR6dDPncFe3BN/YzEGoV35spEaaSINY1vpcdGt6CKV276VjG/B
         03XOGYu7U6VDiAmdkZNCZ8VoP70DNVJon/HXAAxNbf76g0DeBi4TDvxdk5FQNiGNInqX
         pPPY6tqNqVdEWekJjynCnDIiG1KVSTLW8wonXQ1UKsefGH0c+EqLneRvyTFqGuakHAzD
         tSilHzMUQucvgn6aD18zxtR18msgvHGSat6F1Hc2P4WJRBUm29lw0c4L02tXI9R0oTSf
         3nKzcznXsRI5DJqWTrIB8h/sfTbA3GmcdZoCvI7F/4rPYIbwRUfsLSdlAyjmSRwMkbQl
         NvJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b1KvMf8s5EhiJMj3yOgQkSXP/S6umLhie9PjvT6a+9U=;
        b=kKCN9K8eazDuSVUQgqUmXo73d8xlQ+0p6RQWV7ERmmxQ8freoGhme9O7HzXnj7n4Pj
         /HP2rp4pNf20YRKGkTnKB57jqclgUYe4PBQvS01hWGdFueCSnKgOgd2dObYG7LNCrB8s
         JLk7OXodpu8yrOgieBn/WCp7nLkEXsBcr0+19TCrQyfZDwmCPLa0ZLkeOt9FJukZWbuZ
         iUPRzj1R49B3w8w39DAvMN9Mfg+v38/0bqCkcjUvvpNeMgCKEcmU+0ZeO8+gbpURHcI1
         QHnWlwYApTMLTi4VrBeZhI7tVyiIu9f8YQmdba5aseAAXjUVsn8vvQ55tZSltxbdF72o
         czuw==
X-Gm-Message-State: AOAM533uldCWHWVsRKbquk4eIMiA9nibS8YFPC3nladuRA4w7MR5xzf4
        VOwH8iJrO1EOidiceLO52xo=
X-Google-Smtp-Source: ABdhPJwqJVbC5F8ZfDYGkRrxEhl9igkXXNMrflzFvHb+PoTZBGetoIkQxJeQcBa5OYYxY7h+JGPJiA==
X-Received: by 2002:aa7:dc4c:: with SMTP id g12mr5348339edu.258.1623438109742;
        Fri, 11 Jun 2021 12:01:49 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id c19sm2922016edw.10.2021.06.11.12.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 12:01:49 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 06/10] net: dsa: tag_8021q: refactor RX VLAN parsing into a dedicated function
Date:   Fri, 11 Jun 2021 22:01:27 +0300
Message-Id: <20210611190131.2362911-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611190131.2362911-1-olteanv@gmail.com>
References: <20210611190131.2362911-1-olteanv@gmail.com>
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
v2->v3: none
v1->v2: export the dsa_8021q_rcv symbol to avoid build errors when
        building as module

 include/linux/dsa/8021q.h  |  3 +++
 net/dsa/tag_8021q.c        | 23 +++++++++++++++++++++++
 net/dsa/tag_ocelot_8021q.c | 18 ++----------------
 net/dsa/tag_sja1105.c      | 33 +++++++++++----------------------
 4 files changed, 39 insertions(+), 38 deletions(-)

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
index 122ad5833fb1..4aa29f90ecea 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -471,4 +471,27 @@ struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
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
+EXPORT_SYMBOL_GPL(dsa_8021q_rcv);
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

