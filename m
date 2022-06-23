Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4C505571B7
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 06:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbiFWElE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 00:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347415AbiFWEf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 00:35:57 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73AD930F71
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:35:56 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-31838c41186so38691407b3.23
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lhJAm38lB4oAVvBzY5Ysr2c9THun3k9dpinkYqVIY4o=;
        b=YBBKiNKqVhttXqdy4f7yctvmSiQKtUm9zJxFrLhx2qPT8PTdUanduaVTl+7tQi29EQ
         bAsBuaiT9VTVbNh7Y+OiU2fX4m6uWaMp6yhhfX+OCp/F6zry4o39VHJ3qq/QR4zeXzq9
         FaS7F7d/jsAJrTKDYOK2aM4Mp45Cs/pFk7qlJF31OBQuCPm5raKVOSu/rIAKy9GHrVGg
         m0Fu6gpSK1f2tFAulBN0efPVrEtZ3aNpyj4ffcnzWboCY+BuIdMutX21Fg93ycgQyR4H
         V6aDFgcbaF3KFVaE06LVAJs9g3WRKrRcKNtl8SIt/HQZHCvnv5OAapN77lwysyv0Lo4a
         WR7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lhJAm38lB4oAVvBzY5Ysr2c9THun3k9dpinkYqVIY4o=;
        b=y0ZR0MQ3I2Wz3UG5lKlvZdVx0cG8+1iR/d7szB8Zgvuak7MIhiPJwhX4ZbOkB29dqA
         yTliwqpg272d3SS0ItHpzjckIO6mW4v2YM+J3Lw9a+FVSYAt9WD0S3AXMK5vjhDYvt2m
         RH4KytiNQ8sVb0ttwflMkYEkxi75giSChZ2ucAncP7zQlpESzXfDoLDYm7eAgYJfTyUS
         h/DZPAOmB1CLMbucAxk209cwVsOumLutre7glMi8Y1ZmAgXQT9JXXjTch8Q0B+CJfiEb
         K6/KnyO5u8Vv3dWBuhboIIq4oAJKWfaXx35PM0vl0NmzptWiaB6cKTndXdLqJ8U3nS4E
         FmOw==
X-Gm-Message-State: AJIora+SPD17ne4QyWHmGr8DyCpCE0lHXAIV87DWGz5VUWZKUP7CA0aK
        jpY6+ezhdto0bWdmtqsMbMnQoiAfRl9w8A==
X-Google-Smtp-Source: AGRyM1vhkwY4y0b/VkWqUxCiwk9DLOwyoQvMpKB5nuSi3yZNr4iRa+PHmtCgNhDljiiC1Pm6UDAVCkn8s5hgsw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:6ed4:0:b0:664:b4b6:a480 with SMTP id
 j203-20020a256ed4000000b00664b4b6a480mr7463223ybc.120.1655958955795; Wed, 22
 Jun 2022 21:35:55 -0700 (PDT)
Date:   Thu, 23 Jun 2022 04:34:43 +0000
In-Reply-To: <20220623043449.1217288-1-edumazet@google.com>
Message-Id: <20220623043449.1217288-14-edumazet@google.com>
Mime-Version: 1.0
References: <20220623043449.1217288-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH v2 net-next 13/19] ip6mr: do not acquire mrt_lock before
 calling ip6mr_cache_unresolved
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

