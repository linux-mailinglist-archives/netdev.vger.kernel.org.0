Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 295D04B17CE
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 22:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344784AbiBJVmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 16:42:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344766AbiBJVml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 16:42:41 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE818F
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 13:42:39 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id h14-20020a17090a130e00b001b88991a305so9944367pja.3
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 13:42:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d2wuMAg/F1HyRPouNFzbcdYBb0XWDDW51cEAcSB8C9I=;
        b=SGPDSa8FNYFgkB8NpK6+u11TDucHcg6hDods0FkoaWpFqet3KMJjwW3vltXoi3lSZt
         0DvhWF57z2DmetK//nwaTpeiMoXvRTlNFI22QvO32b/bOrNGLB0uVctLIs1kpkM1GC7b
         jkTlBUfFfXKunMP9jcPyGbeasXU90E14q+T0vvw/fPDxeYSKLn240mxVxo0nZvuDIE7i
         ftGfcNqCQpZIt73i8ZVJ3Aw3CUtvIMe6YQmMbVRgXWh68ucCgVYEHJ2UW/AIhNz5h2zV
         8cdAzv7/C0EvofSaN4f/O3n7kb7QOec7TEF70xkJOQHa6pMpIXj00opEgNtO0DExOIyZ
         0iEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d2wuMAg/F1HyRPouNFzbcdYBb0XWDDW51cEAcSB8C9I=;
        b=k1xUgN9pjlKsHxkAhN1BibE88BK+2kVak5jBIudBF4hekzwPVBGa1zTkjv8IX8Tsxz
         yjsHEJB41Snm+/5VXDT9Y6bA6yanpD5Ik8XiymOt/xhvtZCd3cKxgpcqE4VD8oR4LQo+
         ohHclxkR67q4GagJ5IAZkZ24SN0nq94LQkp8uVcdHe9ypgjZhJSiB59oFz10CVxj2gu+
         lnOGt7czzSdd/ghObkINvn7/gNvRYr8sTfBSxcwkhM5BiMce4ACSkkb9f5YYYnzRwqiB
         JmHfWbz+mxkpIY/V6CWOrJhIz6g56d3ID51DR+pN2SZTW+6fgUYxF/QvCWD4Z9lgKvCQ
         lX9g==
X-Gm-Message-State: AOAM530mP+/EHmcl9FbjLx29vJce90pa2euQg/9t9uq/yC8ogHocSois
        bY5zXBOeJbduo/YbaFgLGhk=
X-Google-Smtp-Source: ABdhPJzY4olX+egjpx/QQCyvGDNR6RuuB6HWc0MN8JkLo+k5DYrc2WN8gjOv3Xqf4OwvSN2rdyFb1g==
X-Received: by 2002:a17:902:ced1:: with SMTP id d17mr9402601plg.37.1644529358681;
        Thu, 10 Feb 2022 13:42:38 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:60c1:10c1:3f4f:199d])
        by smtp.gmail.com with ESMTPSA id s19sm23824098pfu.34.2022.02.10.13.42.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 13:42:38 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 1/4] ipv6: get rid of net->ipv6.rt6_stats->fib_rt_uncache
Date:   Thu, 10 Feb 2022 13:42:28 -0800
Message-Id: <20220210214231.2420942-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
In-Reply-To: <20220210214231.2420942-1-eric.dumazet@gmail.com>
References: <20220210214231.2420942-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This counter has never been visible, there is little point
trying to maintain it.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/ip6_fib.h   | 3 +--
 net/ipv6/route.c        | 4 ----
 net/ipv6/xfrm6_policy.c | 1 -
 3 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 40ae8f1b18e502cece9f11b3a60c9cc30c2e1a5e..32c83bb688798b5c12f8aeea1c66debe866689d8 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -367,9 +367,8 @@ struct rt6_statistics {
 	__u32		fib_rt_cache;		/* cached rt entries in exception table */
 	__u32		fib_discarded_routes;	/* total number of routes delete */
 
-	/* The following stats are not protected by any lock */
+	/* The following stat is not protected by any lock */
 	atomic_t	fib_rt_alloc;		/* total number of routes alloced */
-	atomic_t	fib_rt_uncache;		/* rt entries in uncached list */
 };
 
 #define RTN_TL_ROOT	0x0001
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index f4884cda13b92e72d041680cbabfee2e07ec0f10..53acd1568ebcceb1a1697579ed505cefc7a35a65 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -149,11 +149,9 @@ void rt6_uncached_list_del(struct rt6_info *rt)
 {
 	if (!list_empty(&rt->rt6i_uncached)) {
 		struct uncached_list *ul = rt->rt6i_uncached_list;
-		struct net *net = dev_net(rt->dst.dev);
 
 		spin_lock_bh(&ul->lock);
 		list_del(&rt->rt6i_uncached);
-		atomic_dec(&net->ipv6.rt6_stats->fib_rt_uncache);
 		spin_unlock_bh(&ul->lock);
 	}
 }
@@ -2244,7 +2242,6 @@ struct rt6_info *ip6_pol_route(struct net *net, struct fib6_table *table,
 			 * if caller sets RT6_LOOKUP_F_DST_NOREF flag.
 			 */
 			rt6_uncached_list_add(rt);
-			atomic_inc(&net->ipv6.rt6_stats->fib_rt_uncache);
 			rcu_read_unlock();
 
 			return rt;
@@ -3287,7 +3284,6 @@ struct dst_entry *icmp6_dst_alloc(struct net_device *dev,
 	 * do proper release of the net_device
 	 */
 	rt6_uncached_list_add(rt);
-	atomic_inc(&net->ipv6.rt6_stats->fib_rt_uncache);
 
 	dst = xfrm_lookup(net, &rt->dst, flowi6_to_flowi(fl6), NULL, 0);
 
diff --git a/net/ipv6/xfrm6_policy.c b/net/ipv6/xfrm6_policy.c
index fad687ee6dd81af9ee3591eb2333cfed8ceae8ce..55bb2cbae13ddc236e420fae37cd42bbad14d1b2 100644
--- a/net/ipv6/xfrm6_policy.c
+++ b/net/ipv6/xfrm6_policy.c
@@ -92,7 +92,6 @@ static int xfrm6_fill_dst(struct xfrm_dst *xdst, struct net_device *dev,
 	xdst->u.rt6.rt6i_src = rt->rt6i_src;
 	INIT_LIST_HEAD(&xdst->u.rt6.rt6i_uncached);
 	rt6_uncached_list_add(&xdst->u.rt6);
-	atomic_inc(&dev_net(dev)->ipv6.rt6_stats->fib_rt_uncache);
 
 	return 0;
 }
-- 
2.35.1.265.g69c8d7142f-goog

