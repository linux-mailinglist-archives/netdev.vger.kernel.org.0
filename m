Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643841CFBFC
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 19:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730730AbgELRU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 13:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730687AbgELRU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 13:20:57 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D505C061A0C;
        Tue, 12 May 2020 10:20:57 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id e26so22759684wmk.5;
        Tue, 12 May 2020 10:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0NNXolhWfsz1MwXYqKD7ZCNPJaroZJ/oxX2vSOaaKzU=;
        b=pnWL8JbdZeURpFQGsNJI2Fbvmj6YXzLt8m+OAPlbZu6Lo89Gex0SmgV0+yzR1I29lR
         Op4A8ECHBPzCQBPjxd4xBXamHEX9/4yNLrNPAKsySt+PxA9nMiZCStNrAn3vpwNlkwhI
         s4ewYD8zpWyF/Bx653G1nFJ61xBliGfFei3jYPuqt49WGjujW+1WVdlH4Gr4Rz8qqAeJ
         StHdKWQwqII+Q4QA+LmlO5Gs/rwr1+7aPwzddkWMBDXKr+vSmmeZV+5TrvOmyz4bKuFo
         GZ9O4MPpNeqpg9sndPGGxBPKp7h/pzVbwV58EeJip0huktvxTyOUStiFBcQw8XRjZIPc
         0E2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0NNXolhWfsz1MwXYqKD7ZCNPJaroZJ/oxX2vSOaaKzU=;
        b=OeWFcyKSf30sdX4crfw6cOBac0ysqe24lAmHDmHCtlycFwUIdiC94C6S1/9fjCy4rh
         0IV/vDcWEsq+erZDF92jHMH7o2hiv0Ya04lDH6Wg6TLINEz37UN5kSjnILXWqEsvUW3P
         YOKX12gWA+xU5xWPB3FSnNsPQNQsSjsVkvGkfKRTqNV3eVGwiBMT/dNclNd5pwN81PDG
         EiYEadBhm7XLkh2ni6NmG7wytIC0nP+9+umZ1nUJYC1ZBuuynh7jPM4ZYcDUwHS0/lLw
         50aVoQbSrXnaScx3CN3dkzU+voyTR4GYBfCUPvVfhf0ilEGu5hKEG4KTBF8+Gs5thAzw
         3x/w==
X-Gm-Message-State: AGi0PubMdsbH9q1sKaWFXJvpIhCXkAJitVjvyPtOVQ4qdo+UfYB4ABwi
        hnvprahwzcRhNYVOmptQW9Al878X
X-Google-Smtp-Source: APiQypK2snIlL4lilAlMPacQejv276flrY5EXcSH4hC2UZHV3Htdv7hlA+YeUo3kvRBfG5YJkVCvjQ==
X-Received: by 2002:a05:600c:293:: with SMTP id 19mr18863634wmk.71.1589304055866;
        Tue, 12 May 2020 10:20:55 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id a15sm23999743wrw.56.2020.05.12.10.20.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 10:20:55 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 10/15] net: dsa: tag_sja1105: implement sub-VLAN decoding
Date:   Tue, 12 May 2020 20:20:34 +0300
Message-Id: <20200512172039.14136-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200512172039.14136-1-olteanv@gmail.com>
References: <20200512172039.14136-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Create a subvlan_map as part of each port's tagger private structure.
This keeps reverse mappings of bridge-to-dsa_8021q VLAN retagging rules.

Note that as of this patch, this piece of code is never engaged, due to
the fact that the driver hasn't installed any retagging rule, so we'll
always see packets with a subvlan code of 0 (untagged).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v3:
None.

Changes in v2:
None.

 drivers/net/dsa/sja1105/sja1105_main.c |  4 ++++
 include/linux/dsa/sja1105.h            |  2 ++
 net/dsa/tag_sja1105.c                  | 19 +++++++++++++++++++
 3 files changed, 25 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index b7e4a85caade..fd15a18596ea 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2856,6 +2856,7 @@ static int sja1105_probe(struct spi_device *spi)
 		struct sja1105_port *sp = &priv->ports[port];
 		struct dsa_port *dp = dsa_to_port(ds, port);
 		struct net_device *slave;
+		int subvlan;
 
 		if (!dsa_is_user_port(ds, port))
 			continue;
@@ -2876,6 +2877,9 @@ static int sja1105_probe(struct spi_device *spi)
 		}
 		skb_queue_head_init(&sp->xmit_queue);
 		sp->xmit_tpid = ETH_P_SJA1105;
+
+		for (subvlan = 0; subvlan < DSA_8021Q_N_SUBVLAN; subvlan++)
+			sp->subvlan_map[subvlan] = VLAN_N_VID;
 	}
 
 	return 0;
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index f821d08b1b5f..dd93735ae228 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -9,6 +9,7 @@
 
 #include <linux/skbuff.h>
 #include <linux/etherdevice.h>
+#include <linux/dsa/8021q.h>
 #include <net/dsa.h>
 
 #define ETH_P_SJA1105				ETH_P_DSA_8021Q
@@ -53,6 +54,7 @@ struct sja1105_skb_cb {
 	((struct sja1105_skb_cb *)DSA_SKB_CB_PRIV(skb))
 
 struct sja1105_port {
+	u16 subvlan_map[DSA_8021Q_N_SUBVLAN];
 	struct kthread_worker *xmit_worker;
 	struct kthread_work xmit_work;
 	struct sk_buff_head xmit_queue;
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index adeffd3b515a..0c3d0e38831e 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -254,6 +254,20 @@ static struct sk_buff
 	return skb;
 }
 
+static void sja1105_decode_subvlan(struct sk_buff *skb, u16 subvlan)
+{
+	struct dsa_port *dp = dsa_slave_to_port(skb->dev);
+	struct sja1105_port *sp = dp->priv;
+	u16 vid = sp->subvlan_map[subvlan];
+	u16 vlan_tci;
+
+	if (vid == VLAN_N_VID)
+		return;
+
+	vlan_tci = (skb->priority << VLAN_PRIO_SHIFT) | vid;
+	__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vlan_tci);
+}
+
 static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 				   struct net_device *netdev,
 				   struct packet_type *pt)
@@ -263,6 +277,7 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 	struct ethhdr *hdr;
 	u16 tpid, vid, tci;
 	bool is_link_local;
+	u16 subvlan = 0;
 	bool is_tagged;
 	bool is_meta;
 
@@ -286,6 +301,7 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 		source_port = dsa_8021q_rx_source_port(vid);
 		switch_id = dsa_8021q_rx_switch_id(vid);
 		skb->priority = (tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
+		subvlan = dsa_8021q_rx_subvlan(vid);
 	} else if (is_link_local) {
 		/* Management traffic path. Switch embeds the switch ID and
 		 * port ID into bytes of the destination MAC, courtesy of
@@ -310,6 +326,9 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 		return NULL;
 	}
 
+	if (subvlan)
+		sja1105_decode_subvlan(skb, subvlan);
+
 	return sja1105_rcv_meta_state_machine(skb, &meta, is_link_local,
 					      is_meta);
 }
-- 
2.17.1

