Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 747E62AA7FA
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 21:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728710AbgKGU4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 15:56:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgKGU4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 15:56:09 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFA7C0613CF
        for <netdev@vger.kernel.org>; Sat,  7 Nov 2020 12:56:08 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id r17so910775wrw.1
        for <netdev@vger.kernel.org>; Sat, 07 Nov 2020 12:56:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=5jZpp0lzBcPuUpKtQcBf1JMXZFjL3Ty+zKDFPNMgTUw=;
        b=kroF5lezm0PQ9NFHDrYhTVy4y/t28Wa3+jgF8sIfvIX3O/67CzK57FFakcN+ogCJop
         zCIcOMyZEN5HKmO0K4n7lkmQqwDWpUADwqlxtMBu389uPrO0AZOaYZ2hvb4+9RVScS2B
         ydbIf+85ijGu1vK1Wcw6TntzMeCvTD4mkLZ0e3eRgQPjyp4EC5GgNujB3wenXsa45co4
         S54CGf3klS7mJniXABgrktWO5Pzodi9emwRHqrpUXPG57eSrWoIaIPV3mBlaDATZkcHS
         DgDZIJQrqJ1Vp8wAZ7fk07AjK2adQzjuYjrt0i8fMITc6kXkJT2EPPR4VjLvEjKAifLB
         Mc3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=5jZpp0lzBcPuUpKtQcBf1JMXZFjL3Ty+zKDFPNMgTUw=;
        b=mc0jPvsDxlM9y+E66l5cvijbZMR4RU+YwoLCnxlJ0Ua0c4T69lAQN3LdA8Mki4FpTH
         mbzLX/jIAGxfEo5TBr1Yn7GkQktTedgeJXjXFGJ4Rr01fUHwDR+EVQMBYbwzWuVMW/Nw
         NbKT0qDWuv3wJhSXFx29VDtiDdKpDRMcagh6GGIjIJ1j2Z9bScPYdMhRdlrzGDeS+8Oa
         3rOWSn0aZhWD0E7AQIqPpLU6hKCC+CXDHVUwO+O7D944tVWQNQdLA+AC/pvgFg5/b0Rv
         rnHv8dGkq0KmFzk+N/uDJ4c78g8bA2fJN5pPbUdnlKhBoTXMsMEuGnpR62hnUMnxFHeK
         aMbg==
X-Gm-Message-State: AOAM5310qE701alTUGtZh6b01ge695fdZnH8e3ZRjFSVkE5BQzc9LhLE
        bmSbX844B30s9VsOVLG1Y+29RlYqWQ5dtA==
X-Google-Smtp-Source: ABdhPJy+9mIxPYkJxLChUXjCS3+Kuaxs1KdOAsxHWZJG5oswp6lAZMSLAaCslToAnIpT8cOb7NGG+g==
X-Received: by 2002:adf:9407:: with SMTP id 7mr10024569wrq.182.1604782567513;
        Sat, 07 Nov 2020 12:56:07 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:7051:31d:251f:edd6? (p200300ea8f2328007051031d251fedd6.dip0.t-ipconnect.de. [2003:ea:8f23:2800:7051:31d:251f:edd6])
        by smtp.googlemail.com with ESMTPSA id s188sm7563208wmf.45.2020.11.07.12.56.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Nov 2020 12:56:07 -0800 (PST)
Subject: [PATCH net-next v3 04/10] ip6_tunnel: use ip_tunnel_get_stats64 as
 ndo_get_stats64 callback
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
Message-ID: <70653bd6-41de-8a4f-61d6-41245257048f@gmail.com>
Date:   Sat, 7 Nov 2020 21:51:32 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <99273e2f-c218-cd19-916e-9161d8ad8c56@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch ip6_tunnel to the standard statistics pattern:
- use dev->stats for the less frequently accessed counters
- use dev->tstats for the frequently accessed counters

An additional benefit is that we now have 64bit statistics also on
32bit systems.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 net/ipv6/ip6_tunnel.c | 32 +-------------------------------
 1 file changed, 1 insertion(+), 31 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 74a6ea9f8..a7950baa0 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -94,36 +94,6 @@ static inline int ip6_tnl_mpls_supported(void)
 	return IS_ENABLED(CONFIG_MPLS);
 }
 
-static struct net_device_stats *ip6_get_stats(struct net_device *dev)
-{
-	struct pcpu_sw_netstats tmp, sum = { 0 };
-	int i;
-
-	for_each_possible_cpu(i) {
-		unsigned int start;
-		const struct pcpu_sw_netstats *tstats =
-						   per_cpu_ptr(dev->tstats, i);
-
-		do {
-			start = u64_stats_fetch_begin_irq(&tstats->syncp);
-			tmp.rx_packets = tstats->rx_packets;
-			tmp.rx_bytes = tstats->rx_bytes;
-			tmp.tx_packets = tstats->tx_packets;
-			tmp.tx_bytes =  tstats->tx_bytes;
-		} while (u64_stats_fetch_retry_irq(&tstats->syncp, start));
-
-		sum.rx_packets += tmp.rx_packets;
-		sum.rx_bytes   += tmp.rx_bytes;
-		sum.tx_packets += tmp.tx_packets;
-		sum.tx_bytes   += tmp.tx_bytes;
-	}
-	dev->stats.rx_packets = sum.rx_packets;
-	dev->stats.rx_bytes   = sum.rx_bytes;
-	dev->stats.tx_packets = sum.tx_packets;
-	dev->stats.tx_bytes   = sum.tx_bytes;
-	return &dev->stats;
-}
-
 #define for_each_ip6_tunnel_rcu(start) \
 	for (t = rcu_dereference(start); t; t = rcu_dereference(t->next))
 
@@ -1834,7 +1804,7 @@ static const struct net_device_ops ip6_tnl_netdev_ops = {
 	.ndo_start_xmit = ip6_tnl_start_xmit,
 	.ndo_do_ioctl	= ip6_tnl_ioctl,
 	.ndo_change_mtu = ip6_tnl_change_mtu,
-	.ndo_get_stats	= ip6_get_stats,
+	.ndo_get_stats64 = dev_get_tstats64,
 	.ndo_get_iflink = ip6_tnl_get_iflink,
 };
 
-- 
2.29.2


