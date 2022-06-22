Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9891D554218
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 07:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357035AbiFVFNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 01:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356904AbiFVFN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 01:13:26 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABDCC35DE2
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:25 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-30ffc75d920so136322197b3.2
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=FqrzbrlJqIQQUjGW5dvrMp33HGa4GU4gREXFl8wp6ts=;
        b=H+4rRm/tbi/VflEcVKnzv/Yn+CiNVJDNvD6sMQFSGzrJ1kwowwbT1fJtUXindPMDjJ
         L5Y0K/eTTvK9QkWzu+yeT25BCzQ3ADO5KfYGloI+KiusXaMF0f+VTgybgYn6o4jyzMEj
         hoDsVn8JLdS9Eojbk/VBoh2Yx0nrCq/Yx/V0TIi3ti2ty6UTtNdYKh6zkHl21dyOFdNU
         SR4qpHdCmcRlEYElQtVxY6c6HvTQgHq5MtEeWnYSDsxlvKkxbP2gdvqJjX4w8jRrPH+b
         9I3hNXekrfJKX5Eksms7L/+2uRODA/rHsect1sblWYwyj631YltdyEHjIz2DvXRmdPiJ
         i8tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FqrzbrlJqIQQUjGW5dvrMp33HGa4GU4gREXFl8wp6ts=;
        b=q2Bn7CRweIeLBl9JOt02Na3Ly0ID9vqka/uKdDjtmsEZrhvGfE2F/6iy0kBAL0IYvZ
         SkHRfDNT0s+BVfAdSAD2zrN5KvSums5weB6U91EpOmqORNpPTVJmdnahDPrdvbHMle12
         AAKjIL0iY5LbvFPZTEKjgtJU4SU4GN7PmReXo1sbSzPBimNMqlUruIyHnoOyyaWfOiSD
         StqWm1xCxpTs+qv+5XN1z2pcE2te4uhjFaNcUYBjxPjEgTpvY9dG6ickTD43sUY3+Rps
         Z5I2vDCYo5GyLhxGz2v0Xr0mlkyUxS9UkAeLjQ0SuB/k9jxnvenht7ZWV+FXBL8+Gq9S
         p8fg==
X-Gm-Message-State: AJIora9oVw5181MXlED/yBKHpOtdwOSVntvpO2e8plFt0GzhW8TxhpIZ
        P0z1CGUGzuE5fhPcE+bsPepUR3tRrxi0nQ==
X-Google-Smtp-Source: AGRyM1up/o8Ox6WK5urEZxm8aS912pWxBvJ5ED+S8i7AiPiQoPEb95M3xY390FdqmjySO1jxaCgcYpEJG9QI+A==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a5b:289:0:b0:65b:7312:c849 with SMTP id
 x9-20020a5b0289000000b0065b7312c849mr1690767ybl.469.1655874805020; Tue, 21
 Jun 2022 22:13:25 -0700 (PDT)
Date:   Wed, 22 Jun 2022 05:12:50 +0000
In-Reply-To: <20220622051255.700309-1-edumazet@google.com>
Message-Id: <20220622051255.700309-15-edumazet@google.com>
Mime-Version: 1.0
References: <20220622051255.700309-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH net-next 14/19] ip6mr: do not acquire mrt_lock while calling ip6_mr_forward()
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

