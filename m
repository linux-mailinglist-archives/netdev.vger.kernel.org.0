Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26C875571B0
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 06:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiFWElH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 00:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237157AbiFWEgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 00:36:03 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC49730F71
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:36:02 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b11-20020a5b008b000000b00624ea481d55so16361850ybp.19
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1mcBhyhkyYvUwin15ciKRtLj/bHT6HY5NDONX+E6MMM=;
        b=DOginrh/azzPHXR1RdvWdZlu6WV7mnOS7e/tflHGMkK2f1hnleallGApSK5vdmOuv2
         dhxxZepcit/X1R0HWBvZ1BJk3BpdMjfPz4O8SvFuLkV6OTqMxvTR0vzaPI7XNWgClNz5
         8UhFrzgp6UhtLiT9S5EZs0c5wylvs54gjCXsIgfdjL+XLH27CMbmAdsomCpy0eeRani+
         J95/FaihgSayxhQ9P2Lkny+dyPVvQIbjnlOfuuCm21Yejo6RfKzV20jrL/wXzAEsM4kg
         6eX+RSi0daNVyTRqtHXIbMYoMdmqrwVTnRt0b30Nv8SYqTTu/akHLZIj7RJew1L03fVW
         Pq0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1mcBhyhkyYvUwin15ciKRtLj/bHT6HY5NDONX+E6MMM=;
        b=xjKE/Nq7/ryifARhYwdHVPlVAJOOQLT+TnyBdOVm+6omtGWYQeRvKhroMOxPpoTXC2
         2jwDCmy+CIecKe5GjdEDyWD45YfX00jrAG+JdZXLofdE6ZiobZTTf7llzkNaxdnrY+IB
         54tFKLhxO44p166O3m39afKx0WnsI5NtdaaznbtU3K0rOYmyR5wHp+EgWW/CCDLOFfaW
         xSn2/70kt9xJnj6d4Qi3kSMdxoRqF2J9qqUBfzkOJukyu+sqpil+JjhuHKaCV7R97QGB
         nCTQXo2sil5dvwetRZGqXIX5qxGrM0wfw2RtIs8qfKh4f7Q0ybPq9sO/OzywZ8J+reRR
         fOMQ==
X-Gm-Message-State: AJIora+ZcH7ClzA+qrLSKUUIt1D6m6EiqEZTAXRa5h2rJb8OCAUvSuwJ
        FKdH8XkepTbkvk0F6MgEtZ2Nh1QrI4JunA==
X-Google-Smtp-Source: AGRyM1uDrehv+wg6Ia+zZH28QY6cVXv2eFuenStE853j2zs2xcBkAdmI5c2SSdtt06FcdBbRl9YA84pudp6FUQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:57d2:0:b0:317:81b3:2460 with SMTP id
 l201-20020a8157d2000000b0031781b32460mr8672055ywb.493.1655958961931; Wed, 22
 Jun 2022 21:36:01 -0700 (PDT)
Date:   Thu, 23 Jun 2022 04:34:45 +0000
In-Reply-To: <20220623043449.1217288-1-edumazet@google.com>
Message-Id: <20220623043449.1217288-16-edumazet@google.com>
Mime-Version: 1.0
References: <20220623043449.1217288-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH v2 net-next 15/19] ip6mr: switch ip6mr_get_route() to rcu_read_lock()
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

Like ipmr_get_route(), we can use standard RCU here.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/ip6mr.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 8a751a36020334168fe87c98ea38d561e2fa1d94..08ac177fe30ca3bfbc50cd73b41cdc3da56d23e0 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -2290,7 +2290,7 @@ int ip6mr_get_route(struct net *net, struct sk_buff *skb, struct rtmsg *rtm,
 	if (!mrt)
 		return -ENOENT;
 
-	read_lock(&mrt_lock);
+	rcu_read_lock();
 	cache = ip6mr_cache_find(mrt, &rt->rt6i_src.addr, &rt->rt6i_dst.addr);
 	if (!cache && skb->dev) {
 		int vif = ip6mr_find_vif(mrt, skb->dev);
@@ -2308,14 +2308,14 @@ int ip6mr_get_route(struct net *net, struct sk_buff *skb, struct rtmsg *rtm,
 
 		dev = skb->dev;
 		if (!dev || (vif = ip6mr_find_vif(mrt, dev)) < 0) {
-			read_unlock(&mrt_lock);
+			rcu_read_unlock();
 			return -ENODEV;
 		}
 
 		/* really correct? */
 		skb2 = alloc_skb(sizeof(struct ipv6hdr), GFP_ATOMIC);
 		if (!skb2) {
-			read_unlock(&mrt_lock);
+			rcu_read_unlock();
 			return -ENOMEM;
 		}
 
@@ -2338,13 +2338,13 @@ int ip6mr_get_route(struct net *net, struct sk_buff *skb, struct rtmsg *rtm,
 		iph->daddr = rt->rt6i_dst.addr;
 
 		err = ip6mr_cache_unresolved(mrt, vif, skb2, dev);
-		read_unlock(&mrt_lock);
+		rcu_read_unlock();
 
 		return err;
 	}
 
 	err = mr_fill_mroute(mrt, skb, &cache->_c, rtm);
-	read_unlock(&mrt_lock);
+	rcu_read_unlock();
 	return err;
 }
 
-- 
2.37.0.rc0.104.g0611611a94-goog

