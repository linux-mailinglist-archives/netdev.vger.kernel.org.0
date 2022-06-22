Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2A5554217
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 07:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357040AbiFVFNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 01:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356924AbiFVFN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 01:13:28 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563C535DEE
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:27 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2eb7d137101so136292017b3.12
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1mcBhyhkyYvUwin15ciKRtLj/bHT6HY5NDONX+E6MMM=;
        b=kfGlyiY8/tzXSmp+KRhULB6SjCgfmqgaoVgGuGzy/kV3pu3ojstYvNBvJDHqFNhUa4
         JUXz59ANXPO/HG0mI96GiNBa9lxZMIlrTJLoTqC9U2bOVTeQGXdAKp/pJRD1FAxp7bso
         m89ilJFuOJCgOdFTiWBOBuWlZEJeSRluE0zQAn12zBIOs/wAJY0HBnt6ynZCjgfCR/4F
         Gd3LOSGfIJ3GQAqd8i2RdQ+zIm1HuPKn4ZTVs2eEOiExwgd2SoPr2+IKHLWpEz/ndHp9
         Se2BgvcQ39Ntduv7SFr4GU+5I89j0mHLFtwJO9iuf+TKOVM5VRL1RAS1pvQ2R3XWOVR+
         MJzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1mcBhyhkyYvUwin15ciKRtLj/bHT6HY5NDONX+E6MMM=;
        b=rRNybELX6s8pPz05rJ0ZqxiFcArNoZ2skIJuMh8An9XaKsnPsn6o8dnUHa8U0VKhr7
         VRDumY2VD1zBg07PpSi47L57FZ8tAL4j4gZ/4w0SYAMcLHrwzA3tDON1oeP9gY6SJOQh
         vHHdqwSe9bh7/enQVW4OP3CGKPWeY3ujZ0yMD2r2LEPJUsRdixU9fI0gMyqtiu2O5tE9
         mAP8SKMj5UKB7tPXESM4Nh8gqkUs4vtr8Af9+5O4rXyqfmmU0WIXA3QfZ/c+5agVW555
         H5jZafidRw/8Ey3reNZhQT0oX8QGMNqykf2dXuaWuOgI05TL5Mw/rD4ktV2HgP7DT3TU
         Or0g==
X-Gm-Message-State: AJIora82TYtGpIbGrueO8Fu30ktdev4kBNFwYjhmRlzgLDcSYayPc6M9
        mDUQoGgJ8AMwovFQdHZT8GoSpWtZjjiovg==
X-Google-Smtp-Source: AGRyM1sPgMdgj1lF3Y4VSNffOkrcXAU6rNPN6NG3LA72Tmqxdz79R9C/6RJZ5bFwpPRO6BNr34AnTQo8yl59/A==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:8909:0:b0:656:ae08:d91a with SMTP id
 e9-20020a258909000000b00656ae08d91amr1887126ybl.414.1655874806670; Tue, 21
 Jun 2022 22:13:26 -0700 (PDT)
Date:   Wed, 22 Jun 2022 05:12:51 +0000
In-Reply-To: <20220622051255.700309-1-edumazet@google.com>
Message-Id: <20220622051255.700309-16-edumazet@google.com>
Mime-Version: 1.0
References: <20220622051255.700309-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH net-next 15/19] ip6mr: switch ip6mr_get_route() to rcu_read_lock()
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

