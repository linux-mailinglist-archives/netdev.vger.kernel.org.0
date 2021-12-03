Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9EB146703D
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378260AbhLCCvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:51:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350593AbhLCCvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 21:51:18 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C55AC06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 18:47:55 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id u17so1099703plg.9
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 18:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TvekCyDlnpJy8Yfx/5JgJmFSWSd+IHup3z0pyOKys8k=;
        b=I6iTB6IMultl4X9ze4OnqJleR7TXwGY1ffxWkiGgryT4cSvV36j5MMYqg5gRAGqA1U
         cUeHLOnybnqcgzB8IgDd8QQB5fftKxbwK3traQh6+JoC0/CWCg9Flr9WeqniyhUbfCSg
         XAaztQgB/du3MJy9O/G1Kd5BjuzWloWNNnaM34re4FurK58S6vGuXY7kbduefbmfwJyg
         oi+XPfaiBA9rDmL+bVtE0+fPXAT38POB69SKad5lgq6NSxA3UAkO3Bxvb+afSILesYAG
         HGqzr67SN/NSS6gvhZessnK5o29AtTf4BMou0+jzqleARj3djFGx2s39T/4Fm1dLYEgV
         gZqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TvekCyDlnpJy8Yfx/5JgJmFSWSd+IHup3z0pyOKys8k=;
        b=wVSC/mdNwkpZ85IuRbp13lZUWQc2FDZDjrZc4HYAhUZu6VCNldKeaSlXVS8OQnpl8P
         0cGRVZZUQp/o3LP7cyoUbMOUFnP2SFhySqT+ugixUAjqU5/+lWQQpT30Qm2525u2m5ox
         w551SedJMWTvik2GBly4Cnw++vsWCCh+s08b6jhMWdzqX6fSGzsJlc8QYrgOs+n1GOhl
         9wdzPZFhzMOuB7ZZrsfuUAveLwPQpY/e0iCKMZFj57jX6WgX0og+24sMWg0Fr6DzoU9U
         UEtk/UEol1sZOceJ73PbVCQQJ6akMtis3ieAJfocZneNSbgnxqgzsGFf0bUIfjz0DigQ
         HBjA==
X-Gm-Message-State: AOAM533R522icjG2TTJEDMdr4aseo/IZ369yYJU+rhsU8gzSR6LLWQS0
        tRLCzysL3C8iJZN7wIK7gaw=
X-Google-Smtp-Source: ABdhPJzMC2TODWL84+Y9GGBVdvUY/3VcST3XbntE6rh/IaGoYTqtfbvZ4GEuEXJR+lUdgKwzkzKOyg==
X-Received: by 2002:a17:90b:1a87:: with SMTP id ng7mr10677856pjb.86.1638499674884;
        Thu, 02 Dec 2021 18:47:54 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6c4b:c5cb:ac63:1ebf])
        by smtp.gmail.com with ESMTPSA id k2sm1230260pfc.53.2021.12.02.18.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 18:47:54 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 12/23] ipv6: add net device refcount tracker to struct ip6_tnl
Date:   Thu,  2 Dec 2021 18:46:29 -0800
Message-Id: <20211203024640.1180745-13-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203024640.1180745-1-eric.dumazet@gmail.com>
References: <20211203024640.1180745-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/ip6_tunnel.h | 1 +
 net/ipv6/ip6_gre.c       | 8 ++++----
 net/ipv6/ip6_tunnel.c    | 4 ++--
 net/ipv6/ip6_vti.c       | 4 ++--
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/net/ip6_tunnel.h b/include/net/ip6_tunnel.h
index 028eaea1c854493fdab40f655216230e991e2fc5..a38c4f1e4e5c641dcede4d7fedfcdbfadbac430e 100644
--- a/include/net/ip6_tunnel.h
+++ b/include/net/ip6_tunnel.h
@@ -46,6 +46,7 @@ struct __ip6_tnl_parm {
 struct ip6_tnl {
 	struct ip6_tnl __rcu *next;	/* next tunnel in list */
 	struct net_device *dev;	/* virtual device associated with tunnel */
+	netdevice_tracker dev_tracker;
 	struct net *net;	/* netns for packet i/o */
 	struct __ip6_tnl_parm parms;	/* tunnel configuration parameters */
 	struct flowi fl;	/* flowi template for xmit */
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index d831d243969327b2cd4b539199e02a897a6c14f7..110839a88bc2ef098df38196f997335501305ad7 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -403,7 +403,7 @@ static void ip6erspan_tunnel_uninit(struct net_device *dev)
 	ip6erspan_tunnel_unlink_md(ign, t);
 	ip6gre_tunnel_unlink(ign, t);
 	dst_cache_reset(&t->dst_cache);
-	dev_put(dev);
+	dev_put_track(dev, &t->dev_tracker);
 }
 
 static void ip6gre_tunnel_uninit(struct net_device *dev)
@@ -416,7 +416,7 @@ static void ip6gre_tunnel_uninit(struct net_device *dev)
 	if (ign->fb_tunnel_dev == dev)
 		WRITE_ONCE(ign->fb_tunnel_dev, NULL);
 	dst_cache_reset(&t->dst_cache);
-	dev_put(dev);
+	dev_put_track(dev, &t->dev_tracker);
 }
 
 
@@ -1496,7 +1496,7 @@ static int ip6gre_tunnel_init_common(struct net_device *dev)
 	}
 	ip6gre_tnl_init_features(dev);
 
-	dev_hold(dev);
+	dev_hold_track(dev, &tunnel->dev_tracker, GFP_KERNEL);
 	return 0;
 
 cleanup_dst_cache_init:
@@ -1888,7 +1888,7 @@ static int ip6erspan_tap_init(struct net_device *dev)
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 	ip6erspan_tnl_link_config(tunnel, 1);
 
-	dev_hold(dev);
+	dev_hold_track(dev, &tunnel->dev_tracker, GFP_KERNEL);
 	return 0;
 
 cleanup_dst_cache_init:
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 484aca492cc06858319e87ba9c989de9f378e896..fe786df4f8493396b803002d25701affd59ee96c 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -383,7 +383,7 @@ ip6_tnl_dev_uninit(struct net_device *dev)
 	else
 		ip6_tnl_unlink(ip6n, t);
 	dst_cache_reset(&t->dst_cache);
-	dev_put(dev);
+	dev_put_track(dev, &t->dev_tracker);
 }
 
 /**
@@ -1883,7 +1883,7 @@ ip6_tnl_dev_init_gen(struct net_device *dev)
 	dev->min_mtu = ETH_MIN_MTU;
 	dev->max_mtu = IP6_MAX_MTU - dev->hard_header_len;
 
-	dev_hold(dev);
+	dev_hold_track(dev, &t->dev_tracker, GFP_KERNEL);
 	return 0;
 
 destroy_dst:
diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 527e9ead7449e5229db11b73622ff723847ffc96..ed9b6d6ca65e0173c9f03e580cca2747ad023a99 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -293,7 +293,7 @@ static void vti6_dev_uninit(struct net_device *dev)
 		RCU_INIT_POINTER(ip6n->tnls_wc[0], NULL);
 	else
 		vti6_tnl_unlink(ip6n, t);
-	dev_put(dev);
+	dev_put_track(dev, &t->dev_tracker);
 }
 
 static int vti6_input_proto(struct sk_buff *skb, int nexthdr, __be32 spi,
@@ -934,7 +934,7 @@ static inline int vti6_dev_init_gen(struct net_device *dev)
 	dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
 	if (!dev->tstats)
 		return -ENOMEM;
-	dev_hold(dev);
+	dev_hold_track(dev, &t->dev_tracker, GFP_KERNEL);
 	return 0;
 }
 
-- 
2.34.1.400.ga245620fadb-goog

