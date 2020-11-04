Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219772A6664
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729591AbgKDObh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:31:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbgKDObg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 09:31:36 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33146C0613D3
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 06:31:36 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id k18so2504331wmj.5
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 06:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6SiUt2m0lyov7szAdtT9DtunKlYj5/LtzG9e5wM0UUk=;
        b=HXJtzNm3maEgUV7AjpCtg/3m9wFUBj/qdeBM1FhksyqUBXXAFaYv/dHA6ZtiYyVuLw
         NN4nM1HGCjjju3OnsHLxBjsQB7jcmzGQSgwSTGk3wjbDcRa/jNouyERNfW2dEhUmkOmA
         YA54Il53zb7yDYUUQgZKyt+3tJZZvU8h0E3NwQwtPt8GIkQf1weEf7oG/dS3xiyTa6jN
         dJQ+jL/zYD/YLjxquoQZRbkBjdEVA3f11ePY8LqsSPaNFCIjoU0jGiIjKKhZ0qz4qCEk
         KfwLTUQ6yIQzGrXCrD3fx7UTgUFwSpt64XeOSE3aLHIpkMzvM+CFKUSO59kW+HcT5F0b
         n4zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6SiUt2m0lyov7szAdtT9DtunKlYj5/LtzG9e5wM0UUk=;
        b=XpuVDF6VV+Zg422fX+890R65rTuuTxTpBievSLtFINiYr0LbrIf24oeHWP0hRohKyU
         UiaSdm98cYeOoJ+UHgh7+ItN9FTNTQK2/VMURuKW7t9wpHtYAZK3cshIiu+a51tjwPrR
         Kg1R54OfrEGJwnivTYUBk5nwtsCj0HHFglNcHvRcOSMHXennnO6J6KvVf/4SPm4UOeKv
         spsb6ak+EPbbgAP6C7UpMHGQx9a6UoyDTWStKgjGuAv8fzP3iOTrkNBjQI9PI4orklb6
         cMJ3msd4gmYY+lNdtPpM45MFuXtF7bRJB/2Pv5WwIkGeUM3L/TOiMpHKQIqzGDNADfFp
         QRKA==
X-Gm-Message-State: AOAM532UTKwaE+ri9fpwgFzoTki+Csup9J54K7ay7ICzCoBlMcWbKj3u
        GpamoCtlH2kvkUxxolJzXa0kL63qqyPQhw==
X-Google-Smtp-Source: ABdhPJzsIQUXJ7REVV6XSlEVzNeDfhOLFDiPRW/zne857Ilzz1neAPJ3PVdT8KcbvYdiu/7wz8usYA==
X-Received: by 2002:a1c:4b0c:: with SMTP id y12mr5212893wma.91.1604500294880;
        Wed, 04 Nov 2020 06:31:34 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:d177:63da:d01d:cf70? (p200300ea8f232800d17763dad01dcf70.dip0.t-ipconnect.de. [2003:ea:8f23:2800:d177:63da:d01d:cf70])
        by smtp.googlemail.com with ESMTPSA id 130sm2695433wmd.18.2020.11.04.06.31.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 06:31:34 -0800 (PST)
Subject: [PATCH net-next v2 02/10] net: dsa: use net core stats64 handling
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
References: <059fcb95-fba8-673e-0cd6-fb26e8ed4861@gmail.com>
Message-ID: <9c091e28-8585-c082-9587-d73ac5e4680d@gmail.com>
Date:   Wed, 4 Nov 2020 15:24:46 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <059fcb95-fba8-673e-0cd6-fb26e8ed4861@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
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


