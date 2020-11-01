Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC402A1DED
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 13:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgKAMie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 07:38:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbgKAMi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 07:38:27 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6734EC0617A6
        for <netdev@vger.kernel.org>; Sun,  1 Nov 2020 04:38:27 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id n15so11436974wrq.2
        for <netdev@vger.kernel.org>; Sun, 01 Nov 2020 04:38:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WWh8Icx3a6xt4/VTrwlKOf5ZL4xCuid/F8XraeHweps=;
        b=GlntBfZz2PjVNoWNDUf/Al+pwMRcHdkuhRH+7G4hrA6wCd7JkYsOZZZ4wB6tM3M1Ju
         bAm54vb63uWDCqtcBUay37fmpQjHsCPO4REZXncyOJQg1nnUoll+3ysKuJ+RJuFrN9/6
         MBZ65PpJA44xWh1gbdPI9kUmTme3GuBi2+lxQindi+ty+DS4kunLvQJ9KXqv4Kdgua6Y
         eTX0Amjiu6PlZz8kubwp415rXaVEZR7d66FfrtFmnPAa4iWLe3llF19m1tNHjn0tVTGq
         m2HIS+ZAfBX2yUZHkUh+LGDuJoXKzHGma7N+QMyKJmeoggmlHC8DGLbizfTPboJPNs3l
         0Jgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WWh8Icx3a6xt4/VTrwlKOf5ZL4xCuid/F8XraeHweps=;
        b=l1UIC8HlXpld1cstO99HJtJjku3TDJ1Kd5Z8MDIXOsHGwKRzTiGegUc67fuYoN8ztM
         H0G7NYUpiXNBa19qYOXFObmXuqOiMGQ8QJagyeeRuFBXVnHCfMmNJg9XSkqJX5gt7Hvz
         FzOnDQyiNzAhsy+r5D8hMlhmlxnkBNcJOOPbUZWg8CneT8Bhxjvc09LW+sYyAWZjuTaC
         2t6ORcI+u9pYgUVMLAkupuUXGHjartMNkhDjT/vC3rlYIKVoWvqVjS0E6qJbmVrEN7RF
         L3u84qV7qJB0UpDOZBoAb1gYyrWvjxJWFZj5iO92geJnzQ7e/R9/ey6VNJJy8jThyPGD
         VKuA==
X-Gm-Message-State: AOAM533u6N7snNx17lArb1DJLyT9hPnrR+s0833oTH/wRIblqCkqqGgm
        k8DMGa7/6GSHm0zFz0LTbtT6AuZOo1g=
X-Google-Smtp-Source: ABdhPJzbOkK55W2iMZAouV24tnq2hYwyo7fbIx7vYjwogZKprjTSYn90DfqijnHy3j9GH0yZDHid6g==
X-Received: by 2002:adf:edcf:: with SMTP id v15mr13630083wro.291.1604234305916;
        Sun, 01 Nov 2020 04:38:25 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:dc4f:e3f6:2803:90d0? (p200300ea8f232800dc4fe3f6280390d0.dip0.t-ipconnect.de. [2003:ea:8f23:2800:dc4f:e3f6:2803:90d0])
        by smtp.googlemail.com with ESMTPSA id i2sm3358943wmc.28.2020.11.01.04.38.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Nov 2020 04:38:25 -0800 (PST)
Subject: [PATCH net-next 3/5] ip6_tunnel: use ip_tunnel_get_stats64 as
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
        Russell King <linux@armlinux.org.uk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <25c7e008-c3fb-9fcd-f518-5d36e181c0cb@gmail.com>
Message-ID: <ac477aa8-2596-e6f0-f320-408e3209a794@gmail.com>
Date:   Sun, 1 Nov 2020 13:36:00 +0100
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
index a0217e5bf..4ba18d9f9 100644
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
 
@@ -1835,7 +1805,7 @@ static const struct net_device_ops ip6_tnl_netdev_ops = {
 	.ndo_start_xmit = ip6_tnl_start_xmit,
 	.ndo_do_ioctl	= ip6_tnl_ioctl,
 	.ndo_change_mtu = ip6_tnl_change_mtu,
-	.ndo_get_stats	= ip6_get_stats,
+	.ndo_get_stats64 = ip_tunnel_get_stats64,
 	.ndo_get_iflink = ip6_tnl_get_iflink,
 };
 
-- 
2.29.2


