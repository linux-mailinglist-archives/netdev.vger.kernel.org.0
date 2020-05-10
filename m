Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 554D11CCC4C
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 18:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbgEJQnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 12:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728360AbgEJQnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 12:43:40 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E0FC061A0C;
        Sun, 10 May 2020 09:43:40 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id h4so15412221wmb.4;
        Sun, 10 May 2020 09:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tjPoKBQLdBCmIv/BSjsK87xqPqvAOHh8klv/pK8e1nA=;
        b=un/h33bcQW0CA+P9TMKksDpA5sJguFfJ+QITRgP5pmZQnYoMKZtbuk0a1P7Dw9PavX
         XhdTuNFNLySQw9o9X+/a5aGw94D5dEcUvI0XLcnxwGkgGkgHDlHbOJzy9F6VefYyHmxt
         gWbEs/y97eqJi7aJA2n1ppIAOOYeIEvkOSp40vTcGPjoXVR4f9oJyxcRyVpAK17WpVhs
         XqdjIslnhGEurANXbUQdibWwKf4Ne3XyravWIF/nYNBpv27wpE26KEOYi/jHaH1WRCvK
         tJVR/R5Bw8gbEHRvStakhh8gW7k9e/iKAqkvHMBDM+5GStPEGbIyBOFyv2M/ql0TmPMP
         U6Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tjPoKBQLdBCmIv/BSjsK87xqPqvAOHh8klv/pK8e1nA=;
        b=dBKO1LOq/EnEGQBllquIMx2GBYyvKjjImFbUqPsByldNWdCUDYfJvxBLamAYYKZien
         6jbS/qbsHVgd6NVrDSkleBOfXsI2VugPApcnGDCI9HkKci1FAiIMB4iL1LUCpJV8Sr1C
         bRzNMvScj114rH2+ZZA3k+msIXfr8MDaW+K16n/G/1iP1XKksBbRLAmYpJjeAm4PApTL
         e+s/pqRH6HtOf74Dr5XozhEuf6S65KJ1mepq1QOvS5XwY4+ZSjJqehU5dkt7/KG3JeAZ
         2vDML7+FlNaCyzelipF7+qAZ/th40Xp2A6buElmMPpYTqHfo6FOMwrNVu8d1WHFt+Aej
         ZTFw==
X-Gm-Message-State: AGi0PuaUFtfuBcywkLEFlmuc0zr8x1Dd6U30hH4aKKjpiE4PVjE17gE6
        qNXqeZcp/iwJwKjVX40dPHQ=
X-Google-Smtp-Source: APiQypKctZhDDaokPrvj/CLeh1F0VT57/ZccBOyC+PN5589x+zoyvnvIMjqRF0eYr5+FRyaoXmqaYA==
X-Received: by 2002:a1c:750a:: with SMTP id o10mr26541341wmc.124.1589129019252;
        Sun, 10 May 2020 09:43:39 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id i1sm13390916wrx.22.2020.05.10.09.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2020 09:43:38 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 10/15] net: dsa: tag_sja1105: implement sub-VLAN decoding
Date:   Sun, 10 May 2020 19:42:50 +0300
Message-Id: <20200510164255.19322-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200510164255.19322-1-olteanv@gmail.com>
References: <20200510164255.19322-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a subvlan_map as part of each port's tagger private structure.
This keeps reverse mappings of bridge-to-dsa_8021q VLAN retagging rules.

Note that as of this patch, this piece of code is never engaged, due to
the fact that the driver hasn't installed any retagging rule, so we'll
always see packets with a subvlan code of 0 (untagged).

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c |  4 ++++
 include/linux/dsa/sja1105.h            |  1 +
 net/dsa/tag_sja1105.c                  | 19 +++++++++++++++++++
 3 files changed, 24 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 34006b2def32..d298098232cb 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2835,6 +2835,7 @@ static int sja1105_probe(struct spi_device *spi)
 		struct sja1105_port *sp = &priv->ports[port];
 		struct dsa_port *dp = dsa_to_port(ds, port);
 		struct net_device *slave;
+		int subvlan;
 
 		if (!dsa_is_user_port(ds, port))
 			continue;
@@ -2855,6 +2856,9 @@ static int sja1105_probe(struct spi_device *spi)
 		}
 		skb_queue_head_init(&sp->xmit_queue);
 		sp->xmit_tpid = ETH_P_SJA1105;
+
+		for (subvlan = 0; subvlan < DSA_8021Q_N_SUBVLAN; subvlan++)
+			sp->subvlan_map[subvlan] = VLAN_N_VID;
 	}
 
 	return 0;
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index e47acf0965c5..cac168852321 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -54,6 +54,7 @@ struct sja1105_skb_cb {
 	((struct sja1105_skb_cb *)DSA_SKB_CB_PRIV(skb))
 
 struct sja1105_port {
+	u16 subvlan_map[DSA_8021Q_N_SUBVLAN];
 	struct kthread_worker *xmit_worker;
 	struct kthread_work xmit_work;
 	struct sk_buff_head xmit_queue;
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 0a95fdd7bff8..f690511b6d31 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -241,6 +241,20 @@ static struct sk_buff
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
@@ -250,6 +264,7 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 	struct ethhdr *hdr;
 	u16 tpid, vid, tci;
 	bool is_link_local;
+	u16 subvlan = 0;
 	bool is_tagged;
 	bool is_meta;
 
@@ -273,6 +288,7 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 		source_port = dsa_8021q_rx_source_port(vid);
 		switch_id = dsa_8021q_rx_switch_id(vid);
 		skb->priority = (tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
+		subvlan = dsa_8021q_rx_subvlan(vid);
 	} else if (is_link_local) {
 		/* Management traffic path. Switch embeds the switch ID and
 		 * port ID into bytes of the destination MAC, courtesy of
@@ -297,6 +313,9 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
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

