Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3FA2A1DEC
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 13:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgKAMia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 07:38:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgKAMi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 07:38:29 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C59C061A04
        for <netdev@vger.kernel.org>; Sun,  1 Nov 2020 04:38:28 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id n18so11392979wrs.5
        for <netdev@vger.kernel.org>; Sun, 01 Nov 2020 04:38:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4Y0FVVw9FTTHNqxeo8AUqCL86XfRYk9cyqhsJGZGas4=;
        b=qTziHirIIwexlmqSBuv5dN/wYAoA828Y8v6HIaUKwSA4YNgM+op54En0NvAF8vKhUU
         4EV/ZbfxteUbCxqv1awa8RPdMW+M9Saxm2NEX7lkMh/0zjE0V8qyePlrSeIrgWgPd/FP
         CSomszvn9nH0gI8ibUVPj/9FwkhG6EL4hi7Vw65LLKh5XGhk6jJulRnaa0s+gesv93ov
         rCS5+K28Fx3DHx8t9lUouAIywYnV7mKYyKPTym2gHlDKTHkPu5stAweYWKmjx/uDgpsf
         8L8v55uL8xvRoXI6Pi8CVBGtHAhkwJ4sDvttr4vXRYkItm5GFEuAX0EPX5wERewmaUuQ
         HQhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4Y0FVVw9FTTHNqxeo8AUqCL86XfRYk9cyqhsJGZGas4=;
        b=ZFEpQpNv4LFBMP/WH/0ls/ZlZDAfmYNFv1NKCIJ3elK84ryKb5OqhgF95GcoK5Z8oU
         1VFfxX8W4hQlcsKblpY/cAlIII8bu59c7JdUvsEUAVHR7Fne3KKQZxvewfzj0NVe3OEK
         ap3Gg+FThXbLcmLTijmmyn0rXN1BGHczdMRu6nYHXXgWxQJS19qPvCGAjq1uvM0DpnNi
         qzXLhW1+VnmIABOLKseUKPTeTr5BPGh/6R7OtUP2gUiMGkb5kSHaGeM+oI+8NcdIgU9R
         oSI2Z9SBaRXgZQ51QkUmJSKo2DNwRWNyK68rqmgrclmeRDF1ukcdgtcPXVLu0QWyzugv
         Qb6Q==
X-Gm-Message-State: AOAM533GFrhu3Lx2GBmxXYQrN7IwqNzvCm8c5Ie+td/hi+cZNMs0/0FT
        82WqvWwi3gsQBJyRRaNTsTEpGUEHY5w=
X-Google-Smtp-Source: ABdhPJymIo/9gBPihISbSn+bazQe7uzEE0x68eQuaCf50/cSE3xUTVuZpBl41wMd+OjyWcZSCfnidQ==
X-Received: by 2002:a5d:498a:: with SMTP id r10mr14606356wrq.106.1604234307111;
        Sun, 01 Nov 2020 04:38:27 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:dc4f:e3f6:2803:90d0? (p200300ea8f232800dc4fe3f6280390d0.dip0.t-ipconnect.de. [2003:ea:8f23:2800:dc4f:e3f6:2803:90d0])
        by smtp.googlemail.com with ESMTPSA id k18sm18053873wrx.96.2020.11.01.04.38.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Nov 2020 04:38:26 -0800 (PST)
Subject: [PATCH net-next 4/5] net: dsa: use net core stats64 handling
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <25c7e008-c3fb-9fcd-f518-5d36e181c0cb@gmail.com>
Message-ID: <d5091440-3fe2-4d14-dfed-3d030bd09633@gmail.com>
Date:   Sun, 1 Nov 2020 13:37:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <25c7e008-c3fb-9fcd-f518-5d36e181c0cb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev->tstats instead of a member of dsa_slave_priv for storing
a pointer to the per-cpu counters. This allows us to use core
functionality for statistics handling.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 net/dsa/dsa.c      |  7 +------
 net/dsa/dsa_priv.h |  2 --
 net/dsa/slave.c    | 29 +++++++----------------------
 3 files changed, 8 insertions(+), 30 deletions(-)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 2131bf2b3..a1b1dc8a4 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -201,7 +201,6 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
 {
 	struct dsa_port *cpu_dp = dev->dsa_ptr;
 	struct sk_buff *nskb = NULL;
-	struct pcpu_sw_netstats *s;
 	struct dsa_slave_priv *p;
 
 	if (unlikely(!cpu_dp)) {
@@ -234,11 +233,7 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
 		skb = nskb;
 	}
 
-	s = this_cpu_ptr(p->stats64);
-	u64_stats_update_begin(&s->syncp);
-	s->rx_packets++;
-	s->rx_bytes += skb->len;
-	u64_stats_update_end(&s->syncp);
+	dev_sw_netstats_rx_add(skb->dev, skb->len);
 
 	if (dsa_skb_defer_rx_timestamp(p, skb))
 		return 0;
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 12998bf04..7c96aae90 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -78,8 +78,6 @@ struct dsa_slave_priv {
 	struct sk_buff *	(*xmit)(struct sk_buff *skb,
 					struct net_device *dev);
 
-	struct pcpu_sw_netstats	__percpu *stats64;
-
 	struct gro_cells	gcells;
 
 	/* DSA port data, such as switch, port index, etc. */
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 3bc5ca40c..c6a797d75 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -551,14 +551,9 @@ EXPORT_SYMBOL_GPL(dsa_enqueue_skb);
 static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct dsa_slave_priv *p = netdev_priv(dev);
-	struct pcpu_sw_netstats *s;
 	struct sk_buff *nskb;
 
-	s = this_cpu_ptr(p->stats64);
-	u64_stats_update_begin(&s->syncp);
-	s->tx_packets++;
-	s->tx_bytes += skb->len;
-	u64_stats_update_end(&s->syncp);
+	dev_sw_netstats_tx_add(dev, 1, skb->len);
 
 	DSA_SKB_CB(skb)->clone = NULL;
 
@@ -679,7 +674,6 @@ static void dsa_slave_get_ethtool_stats(struct net_device *dev,
 					uint64_t *data)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct dsa_slave_priv *p = netdev_priv(dev);
 	struct dsa_switch *ds = dp->ds;
 	struct pcpu_sw_netstats *s;
 	unsigned int start;
@@ -688,7 +682,7 @@ static void dsa_slave_get_ethtool_stats(struct net_device *dev,
 	for_each_possible_cpu(i) {
 		u64 tx_packets, tx_bytes, rx_packets, rx_bytes;
 
-		s = per_cpu_ptr(p->stats64, i);
+		s = per_cpu_ptr(dev->tstats, i);
 		do {
 			start = u64_stats_fetch_begin_irq(&s->syncp);
 			tx_packets = s->tx_packets;
@@ -1217,15 +1211,6 @@ static int dsa_slave_setup_tc(struct net_device *dev, enum tc_setup_type type,
 	return ds->ops->port_setup_tc(ds, dp->index, type, type_data);
 }
 
-static void dsa_slave_get_stats64(struct net_device *dev,
-				  struct rtnl_link_stats64 *stats)
-{
-	struct dsa_slave_priv *p = netdev_priv(dev);
-
-	netdev_stats_to_stats64(stats, &dev->stats);
-	dev_fetch_sw_netstats(stats, p->stats64);
-}
-
 static int dsa_slave_get_rxnfc(struct net_device *dev,
 			       struct ethtool_rxnfc *nfc, u32 *rule_locs)
 {
@@ -1601,7 +1586,7 @@ static const struct net_device_ops dsa_slave_netdev_ops = {
 #endif
 	.ndo_get_phys_port_name	= dsa_slave_get_phys_port_name,
 	.ndo_setup_tc		= dsa_slave_setup_tc,
-	.ndo_get_stats64	= dsa_slave_get_stats64,
+	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_get_port_parent_id	= dsa_slave_get_port_parent_id,
 	.ndo_vlan_rx_add_vid	= dsa_slave_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= dsa_slave_vlan_rx_kill_vid,
@@ -1801,8 +1786,8 @@ int dsa_slave_create(struct dsa_port *port)
 	slave_dev->vlan_features = master->vlan_features;
 
 	p = netdev_priv(slave_dev);
-	p->stats64 = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
-	if (!p->stats64) {
+	slave_dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
+	if (!slave_dev->tstats) {
 		free_netdev(slave_dev);
 		return -ENOMEM;
 	}
@@ -1864,7 +1849,7 @@ int dsa_slave_create(struct dsa_port *port)
 out_gcells:
 	gro_cells_destroy(&p->gcells);
 out_free:
-	free_percpu(p->stats64);
+	free_percpu(slave_dev->tstats);
 	free_netdev(slave_dev);
 	port->slave = NULL;
 	return ret;
@@ -1886,7 +1871,7 @@ void dsa_slave_destroy(struct net_device *slave_dev)
 	dsa_slave_notify(slave_dev, DSA_PORT_UNREGISTER);
 	phylink_destroy(dp->pl);
 	gro_cells_destroy(&p->gcells);
-	free_percpu(p->stats64);
+	free_percpu(slave_dev->tstats);
 	free_netdev(slave_dev);
 }
 
-- 
2.29.2


