Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEDB468918
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 05:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbhLEE05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 23:26:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbhLEE0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 23:26:55 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8ACC061751
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 20:23:29 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id k6-20020a17090a7f0600b001ad9d73b20bso3381993pjl.3
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 20:23:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TvekCyDlnpJy8Yfx/5JgJmFSWSd+IHup3z0pyOKys8k=;
        b=lcKGzyTk63fxn9KAjWmgYHOj6bLXUIiJtZwc9ccEn+m/XNCqxtDf/cbqb8IiefGyox
         VRfYDRN5/28sYslgpT++ifrhFm6xfRWWwGFzhgybAUc6y2g9Ef+uqVBDcybW+i2O+fIT
         hJoJhJvG14ZXuB47Hcv8XcUD7EhAGwCNC8RkSDbqnEs/kbIT2ULusIGwK97wFhAo91bw
         6d4/YSDZq2uG0q5J0fZtIsw+Yf65yCUnt8NuwPcse9AJgKXd1YGqw3PWYbrEQ+s5HhmK
         BHqalvvlqhbHB59eDJkhk7xED8cAMKNIbdThshZRMUsiYGoOczOqcyBf86QhhmL9fqrb
         rYSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TvekCyDlnpJy8Yfx/5JgJmFSWSd+IHup3z0pyOKys8k=;
        b=g8Cb3l8hmFyOo8NyxUN65M7S8BPCr0LbjiPDs2i2AHDFAFVRue4kWP0TUHoTvsamFE
         CVUfGGUpk9STfVOCHHW18EP+ig6zW5QganoEBVj7u2+sLMfLRkGouXyj5HNnZPMq2Fn5
         6lZvNrx7ni7jL/5V5yu3No/oY834GP054Z2RC6AURoCprL1LqRNfzXCpTQsS8SETtt6b
         8X+6ICDAo9+jsDrTSqSPoLzwzplmmDphKjrsKDofr0GS/wUPnT9M7al8ZKPADnK9xBsG
         T0Okhz20xUDhfhncfVOgBy+42luqPKAE9ZRzdb1EC6xs8T8HpWclLIV1defFnEo+m13w
         efvA==
X-Gm-Message-State: AOAM530jVpYNtSKQAu75UwPgciaPUXbMxdonU8oFIKZ0R/Pctc8IlSrj
        IDCeEn8uv5W6f1G+rSEBT64=
X-Google-Smtp-Source: ABdhPJwV9j0OX6Z2Ub5u4qkZx2Jbe5otfKw3dKrAc3XnWOl0uwK6LTOyvKXieRaiSlLlKMJcCgqmCQ==
X-Received: by 2002:a17:903:31d1:b0:141:f14b:6ebd with SMTP id v17-20020a17090331d100b00141f14b6ebdmr34231279ple.75.1638678209038;
        Sat, 04 Dec 2021 20:23:29 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ffa7:1c62:2d55:eac2])
        by smtp.gmail.com with ESMTPSA id 17sm6027095pgw.1.2021.12.04.20.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 20:23:28 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH v3 net-next 12/23] ipv6: add net device refcount tracker to struct ip6_tnl
Date:   Sat,  4 Dec 2021 20:22:06 -0800
Message-Id: <20211205042217.982127-13-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211205042217.982127-1-eric.dumazet@gmail.com>
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
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

