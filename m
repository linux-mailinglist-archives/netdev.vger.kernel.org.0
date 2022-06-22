Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01D2A55421F
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 07:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357028AbiFVFNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 01:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356897AbiFVFNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 01:13:24 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15EC934B82
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:24 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-317b6ecba61so71247207b3.9
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lhJAm38lB4oAVvBzY5Ysr2c9THun3k9dpinkYqVIY4o=;
        b=pmZedvPyUXhlNDtQ0Qx5wl3oxXnt38sa8B+n85gdjmMib3kGb0dR/CLa1RJPq6ngJi
         KrNIOwu04dZk63s/5yt4GL0s//ZU53UaXay5/QPtUAn44XN7vR977+8mFxBlSt246HtK
         7LWO0dNbWr9/eKRYKuXweULrNZxWP/bX8amdfoizXDj80i46UC0FF3FYCPtDhuEyyH6n
         efidc2QbxAoLf9lcdR6pUhix2ZohbGGRFCR6MDlz+ve2PNLiFq3tpFEemBrE0CAkC0f6
         5i55Nm0Juv51EeDJdYU04tkLgMQIsYnJdp+CeOlEZj/PxKjjkf7QGUsM5fWDvSMxMg49
         Sx0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lhJAm38lB4oAVvBzY5Ysr2c9THun3k9dpinkYqVIY4o=;
        b=CtyUeHEZ/G5W6CdBZnU02q0HHxEtdW+m6RcM0ruKjgSp24SoAE8dPCKd28bihDwcuK
         RR8lDAZHJ0bAdw74jpk/GnZa/3GW/t8//bdzZ7TzJ02I2wJW7kHkc30j3oeZZBHbQDh+
         oQ2DSnFq0HAUx0i1nlzLDkBLuqmrBeA78+zUwQpRQjK8zpmGIPhdCDpiqHFvfA6sbXWr
         5/fuQYqttOyrYBJ5vLRYj3znj/DqeQuF1jZEJ3jM78yXc4ReAr1WPJmenCMjnlN+0N1w
         VUdTvDMQi1SbfDQABWy5jVgqGgvYIRBLmwjSFKtFuiZ5Y8Lpi1S7x3yXCyR/5ZnZoT+L
         h9oQ==
X-Gm-Message-State: AJIora/4cXy+tJoIvbvsR9ZSckKmtVrrO8v87hKJhfE8E2RmgXwvQ7/A
        xn9PDvEHjkezLDTXkF5U8ZC3ncJ6EgGF5g==
X-Google-Smtp-Source: AGRyM1vwG9JGuwwhq7y2L4mcQxGUUR5WSvCrvmFCFrt4xCuB+c52vNQ8njyXVya4jog0s7eYiZjEdBsMW86g7A==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:1085:b0:669:1652:9f23 with SMTP
 id v5-20020a056902108500b0066916529f23mr1713239ybu.465.1655874803362; Tue, 21
 Jun 2022 22:13:23 -0700 (PDT)
Date:   Wed, 22 Jun 2022 05:12:49 +0000
In-Reply-To: <20220622051255.700309-1-edumazet@google.com>
Message-Id: <20220622051255.700309-14-edumazet@google.com>
Mime-Version: 1.0
References: <20220622051255.700309-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH net-next 13/19] ip6mr: do not acquire mrt_lock before calling ip6mr_cache_unresolved
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

rcu_read_lock() protection is good enough.

ip6mr_cache_unresolved() uses a dedicated spinlock (mfc_unres_lock)

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/ip6mr.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index b4ad606e24bdaf12c233f642cee303f06ccfa4eb..089c26af3120d198ccfdda631294ed9712568ac0 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -730,7 +730,7 @@ static int mif6_delete(struct mr_table *mrt, int vifi, int notify,
 			if (VIF_EXISTS(mrt, tmp))
 				break;
 		}
-		mrt->maxvif = tmp + 1;
+		WRITE_ONCE(mrt->maxvif, tmp + 1);
 	}
 
 	write_unlock_bh(&mrt_lock);
@@ -927,7 +927,7 @@ static int mif6_add(struct net *net, struct mr_table *mrt,
 		WRITE_ONCE(mrt->mroute_reg_vif_num, vifi);
 #endif
 	if (vifi + 1 > mrt->maxvif)
-		mrt->maxvif = vifi + 1;
+		WRITE_ONCE(mrt->maxvif, vifi + 1);
 	write_unlock_bh(&mrt_lock);
 	call_ip6mr_vif_entry_notifiers(net, FIB_EVENT_VIF_ADD,
 				       v, dev, vifi, mrt->id);
@@ -2099,11 +2099,13 @@ static int ip6mr_forward2(struct net *net, struct mr_table *mrt,
 	return 0;
 }
 
+/* Called with mrt_lock or rcu_read_lock() */
 static int ip6mr_find_vif(struct mr_table *mrt, struct net_device *dev)
 {
 	int ct;
 
-	for (ct = mrt->maxvif - 1; ct >= 0; ct--) {
+	/* Pairs with WRITE_ONCE() in mif6_delete()/mif6_add() */
+	for (ct = READ_ONCE(mrt->maxvif) - 1; ct >= 0; ct--) {
 		if (rcu_access_pointer(mrt->vif_table[ct].dev) == dev)
 			break;
 	}
@@ -2249,7 +2251,6 @@ int ip6_mr_input(struct sk_buff *skb)
 		return err;
 	}
 
-	read_lock(&mrt_lock);
 	cache = ip6mr_cache_find(mrt,
 				 &ipv6_hdr(skb)->saddr, &ipv6_hdr(skb)->daddr);
 	if (!cache) {
@@ -2270,15 +2271,14 @@ int ip6_mr_input(struct sk_buff *skb)
 		vif = ip6mr_find_vif(mrt, dev);
 		if (vif >= 0) {
 			int err = ip6mr_cache_unresolved(mrt, vif, skb, dev);
-			read_unlock(&mrt_lock);
 
 			return err;
 		}
-		read_unlock(&mrt_lock);
 		kfree_skb(skb);
 		return -ENODEV;
 	}
 
+	read_lock(&mrt_lock);
 	ip6_mr_forward(net, mrt, dev, skb, cache);
 
 	read_unlock(&mrt_lock);
-- 
2.37.0.rc0.104.g0611611a94-goog

