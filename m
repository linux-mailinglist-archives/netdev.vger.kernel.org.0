Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACF755571C4
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 06:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbiFWElG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 00:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347424AbiFWEgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 00:36:01 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D254530F71
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:35:59 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-317b6ecba61so96385577b3.9
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=FqrzbrlJqIQQUjGW5dvrMp33HGa4GU4gREXFl8wp6ts=;
        b=M5KIBZ1LrL60PItHYIsOl6tYrJH8qP6gvKQYwXXYFksDjVL+5E+CspJGLU0my0BIQr
         sqxMSiJ8mbuL+K58wW+NNdYHjmW4bWDlwedfYXOarpTQUXZe1sWsalL342ZdSsT3Bn94
         GSRcEERyZmTN7gjk0xkBRbQ2eO938jGGmUyZ2LPuiGL5l+AF/J3XewplCCNQcuT5wuyW
         VKFXEtt7HQzuLsMFblSAlC3Og7MF20+S25VG21a70fHduIMyzsrw5rLEEEpupbW95Hm1
         3oxLC2164kwto/wGv6OqFlyBPwj/aIN63ihGZdZrV8k6OhKlMlFaGoqR0SV3dyG6Xc4G
         3Nug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FqrzbrlJqIQQUjGW5dvrMp33HGa4GU4gREXFl8wp6ts=;
        b=isQLTRbMT6DV3dcqb1Kwx/MQpQ4zSyyHk4AFPqkvHFJ5e8nkCFvONUP9q58s4hSLdZ
         IgV3q+m1d3lIyx9M0RRUXVHtILKLp5AzHoHgDDBV1ROiYI28sjAW/dqKb24RqO7tbUWE
         I3eMJEx98WGRytsb7y07BvqFqdcbZo9C+x/zB8o3SYZH5ZWf33NTejukG/ph4j90TJsD
         DG8+D4ebK7WgphLIRt/CvaNh/SeZIiUsX8xcZ83u/J/GnkI6dZD4dNyHBZFdIm5jTEbG
         50kvQOO8dYYWc/V9rPG1KLTuG+6F/UaSSUbsmI0ZrqrY7gfcizVp9BzDTMkXmid+izxf
         6dSQ==
X-Gm-Message-State: AJIora8L3P8zBHIu5WYv+nyynw5K+rxpE1Ps+M50WALcpaa4vUqzBsHy
        mMS1Va+q2474Zj3v5UbIYalrOdBtwvry0A==
X-Google-Smtp-Source: AGRyM1saYGInX1aGG7ipnueXSl08hv+Xyl68UNWxvzSAo1uJHQtl+AGaxdtGvw1LBL+DvjcRRAeUnE7M7crybg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:dcc5:0:b0:664:7913:46af with SMTP id
 y188-20020a25dcc5000000b00664791346afmr7489138ybe.339.1655958959145; Wed, 22
 Jun 2022 21:35:59 -0700 (PDT)
Date:   Thu, 23 Jun 2022 04:34:44 +0000
In-Reply-To: <20220623043449.1217288-1-edumazet@google.com>
Message-Id: <20220623043449.1217288-15-edumazet@google.com>
Mime-Version: 1.0
References: <20220623043449.1217288-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH v2 net-next 14/19] ip6mr: do not acquire mrt_lock while
 calling ip6_mr_forward()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ip6_mr_forward() uses standard RCU protection already.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/ip6mr.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 089c26af3120d198ccfdda631294ed9712568ac0..8a751a36020334168fe87c98ea38d561e2fa1d94 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -2042,9 +2042,7 @@ static int ip6mr_forward2(struct net *net, struct mr_table *mrt,
 		WRITE_ONCE(vif->bytes_out, vif->bytes_out + skb->len);
 		vif_dev->stats.tx_bytes += skb->len;
 		vif_dev->stats.tx_packets++;
-		rcu_read_lock();
 		ip6mr_cache_report(mrt, skb, vifi, MRT6MSG_WHOLEPKT);
-		rcu_read_unlock();
 		goto out_free;
 	}
 #endif
@@ -2112,6 +2110,7 @@ static int ip6mr_find_vif(struct mr_table *mrt, struct net_device *dev)
 	return ct;
 }
 
+/* Called under rcu_read_lock() */
 static void ip6_mr_forward(struct net *net, struct mr_table *mrt,
 			   struct net_device *dev, struct sk_buff *skb,
 			   struct mfc6_cache *c)
@@ -2131,14 +2130,12 @@ static void ip6_mr_forward(struct net *net, struct mr_table *mrt,
 		/* For an (*,G) entry, we only check that the incoming
 		 * interface is part of the static tree.
 		 */
-		rcu_read_lock();
 		cache_proxy = mr_mfc_find_any_parent(mrt, vif);
 		if (cache_proxy &&
 		    cache_proxy->_c.mfc_un.res.ttls[true_vifi] < 255) {
 			rcu_read_unlock();
 			goto forward;
 		}
-		rcu_read_unlock();
 	}
 
 	/*
@@ -2159,12 +2156,10 @@ static void ip6_mr_forward(struct net *net, struct mr_table *mrt,
 			       c->_c.mfc_un.res.last_assert +
 			       MFC_ASSERT_THRESH)) {
 			c->_c.mfc_un.res.last_assert = jiffies;
-			rcu_read_lock();
 			ip6mr_cache_report(mrt, skb, true_vifi, MRT6MSG_WRONGMIF);
 			if (mrt->mroute_do_wrvifwhole)
 				ip6mr_cache_report(mrt, skb, true_vifi,
 						   MRT6MSG_WRMIFWHOLE);
-			rcu_read_unlock();
 		}
 		goto dont_forward;
 	}
@@ -2278,11 +2273,8 @@ int ip6_mr_input(struct sk_buff *skb)
 		return -ENODEV;
 	}
 
-	read_lock(&mrt_lock);
 	ip6_mr_forward(net, mrt, dev, skb, cache);
 
-	read_unlock(&mrt_lock);
-
 	return 0;
 }
 
-- 
2.37.0.rc0.104.g0611611a94-goog

