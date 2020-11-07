Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0652AA7F8
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 21:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbgKGU4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 15:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgKGU4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 15:56:06 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC56EC0613CF
        for <netdev@vger.kernel.org>; Sat,  7 Nov 2020 12:56:05 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id p22so4654140wmg.3
        for <netdev@vger.kernel.org>; Sat, 07 Nov 2020 12:56:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=whZpVChbC/Oh3fGf+zAOWeG71Nt5Rog/T1hyV+pag+s=;
        b=HuMmBGOZjUkGiKhtWqwnFVrZogGWKOpl2hx4HGzximEH87j5Cy/XzDpjZy8D7CMGZ9
         DS3v3xjv37n8RnEG1ns3FlJy+YI1S4xn6o0AY66D6JpL6jilQIHe7y+/KK78jS3yWEC0
         exQ4hd2kp3aVPER+QmgccFdFX6na+5LCyg5sddW347hVlopRa08jzeitSVh5OZAKj/np
         W9Ye5AcPA2O5sET5dU2wIbtCD+VWSW8MH7jNJYjbJKKbTaBCkpX/QmhC0bmewk5m+Fxf
         /OU55EYcv+hOBvT9gPKGOYcxDrZa2Um85Oy3puao1Fdm0Ngd/ySwOoYbvE2K65qW00om
         vMDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=whZpVChbC/Oh3fGf+zAOWeG71Nt5Rog/T1hyV+pag+s=;
        b=ROseFHmvQ9fOZsm27iBUCJaoA84DNi/jCgZ/OciK9FAKtNUqzcSesJyE7ozVIX97p2
         1Wu1MjoOw53G3H2uqdj/52r38sZzi/LTb61hMYvBm24Mi3Y6dTBqgzfFAEvkgkcjk6QZ
         I567g/zJG0Fp+qLeFND/jCgV7fo/9H/6I43UoYfy0N5wika8KYgwQrwgTUIySe+KHr9b
         e3khUfZksf/pfSLMO7Vnsv45om1RWVKm9j5h9/32JQm5Xi1XPGfdh6m0zTOvoqMiVTUd
         7kfl6VRmLTC7+YOkeRF9a2I+kuSvIx7DbYQjB/xo0kmtq1uUjMtfJLtQUdJOIEvilQLJ
         MXAA==
X-Gm-Message-State: AOAM533FmB7Qj+dJvXj1KUDQqaFb2P48EHMJdG/++uB08H/IZgL09O4n
        G8qQ8wdSNM2XrpMyOyWho3reyCWlfwk8fQ==
X-Google-Smtp-Source: ABdhPJxnEfRez/hEbRVq9jtSSBegtRME/vDRC1PdL/NV7oUwXPZ4chY5azs5X3HhST6WqbuflfsJ9w==
X-Received: by 2002:a7b:ce8a:: with SMTP id q10mr6343037wmj.101.1604782564583;
        Sat, 07 Nov 2020 12:56:04 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:7051:31d:251f:edd6? (p200300ea8f2328007051031d251fedd6.dip0.t-ipconnect.de. [2003:ea:8f23:2800:7051:31d:251f:edd6])
        by smtp.googlemail.com with ESMTPSA id 90sm7604936wrl.30.2020.11.07.12.56.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Nov 2020 12:56:04 -0800 (PST)
Subject: [PATCH net-next v3 02/10] net: dsa: use net core stats64 handling
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Harald Welte <laforge@gnumonks.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        osmocom-net-gprs@lists.osmocom.org, wireguard@lists.zx2c4.com,
        Steffen Klassert <steffen.klassert@secunet.com>
References: <99273e2f-c218-cd19-916e-9161d8ad8c56@gmail.com>
Message-ID: <74c82e15-c44e-8368-6d60-4f61f6aba92f@gmail.com>
Date:   Sat, 7 Nov 2020 21:49:46 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <99273e2f-c218-cd19-916e-9161d8ad8c56@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev->tstats instead of a member of dsa_slave_priv for storing
a pointer to the per-cpu counters. This allows us to use core
functionality for statistics handling.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Vladimir Oltean <olteanv@gmail.com>
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
index 59c80052e..ff2266d2b 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -575,14 +575,9 @@ static int dsa_realloc_skb(struct sk_buff *skb, struct net_device *dev)
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
 
@@ -714,7 +709,6 @@ static void dsa_slave_get_ethtool_stats(struct net_device *dev,
 					uint64_t *data)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct dsa_slave_priv *p = netdev_priv(dev);
 	struct dsa_switch *ds = dp->ds;
 	struct pcpu_sw_netstats *s;
 	unsigned int start;
@@ -723,7 +717,7 @@ static void dsa_slave_get_ethtool_stats(struct net_device *dev,
 	for_each_possible_cpu(i) {
 		u64 tx_packets, tx_bytes, rx_packets, rx_bytes;
 
-		s = per_cpu_ptr(p->stats64, i);
+		s = per_cpu_ptr(dev->tstats, i);
 		do {
 			start = u64_stats_fetch_begin_irq(&s->syncp);
 			tx_packets = s->tx_packets;
@@ -1252,15 +1246,6 @@ static int dsa_slave_setup_tc(struct net_device *dev, enum tc_setup_type type,
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
@@ -1636,7 +1621,7 @@ static const struct net_device_ops dsa_slave_netdev_ops = {
 #endif
 	.ndo_get_phys_port_name	= dsa_slave_get_phys_port_name,
 	.ndo_setup_tc		= dsa_slave_setup_tc,
-	.ndo_get_stats64	= dsa_slave_get_stats64,
+	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_get_port_parent_id	= dsa_slave_get_port_parent_id,
 	.ndo_vlan_rx_add_vid	= dsa_slave_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= dsa_slave_vlan_rx_kill_vid,
@@ -1846,8 +1831,8 @@ int dsa_slave_create(struct dsa_port *port)
 	slave_dev->vlan_features = master->vlan_features;
 
 	p = netdev_priv(slave_dev);
-	p->stats64 = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
-	if (!p->stats64) {
+	slave_dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
+	if (!slave_dev->tstats) {
 		free_netdev(slave_dev);
 		return -ENOMEM;
 	}
@@ -1909,7 +1894,7 @@ int dsa_slave_create(struct dsa_port *port)
 out_gcells:
 	gro_cells_destroy(&p->gcells);
 out_free:
-	free_percpu(p->stats64);
+	free_percpu(slave_dev->tstats);
 	free_netdev(slave_dev);
 	port->slave = NULL;
 	return ret;
@@ -1931,7 +1916,7 @@ void dsa_slave_destroy(struct net_device *slave_dev)
 	dsa_slave_notify(slave_dev, DSA_PORT_UNREGISTER);
 	phylink_destroy(dp->pl);
 	gro_cells_destroy(&p->gcells);
-	free_percpu(p->stats64);
+	free_percpu(slave_dev->tstats);
 	free_netdev(slave_dev);
 }
 
-- 
2.29.2


