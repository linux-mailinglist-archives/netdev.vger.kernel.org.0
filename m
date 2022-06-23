Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 691B25571AD
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 06:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiFWEl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 00:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347452AbiFWEgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 00:36:23 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A886130F71
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:36:22 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-317a4c8a662so104882337b3.6
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=9hpBdccy74sS7LhLCkjUZlDSBI954GNR5j1me5KZlE8=;
        b=GK+fixkDrlsidXLSyvKPfC26rPClSnVyscxqQvDt6bdZlYFdj+UEKmxOZc+iqq0QGx
         JzgwarjIGJDA2CHcwsa0P2MrJqJCuQ1E7zn8QwVbC8wQmunmEtyhJ2OMUTWvYf0cFRIC
         JcbrSO/YO9lcKDBCtK+pvGNmlP3IzO8w2HQUiQ8zg+jN/zzGCKEmR1axqxjHQkvBYIKx
         wLgndPtbSxmE+CTuNcYuyjK1ggG5/LONDKFr8ZzQMubnfeY+wPuniSFo195dEhycp5l4
         plxfiGts4gT72Wh0qkpPNOCoj/3RWtsyB4oBr0Ehy9zfwVltQfKufK8DRNi+7ETBoChc
         FPgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9hpBdccy74sS7LhLCkjUZlDSBI954GNR5j1me5KZlE8=;
        b=fk7bOYjEt4NZOhmOueNMp5ZKoVTqEKoVdcE5rGp5/hyVnDZWcKfqO7AWOMfbdybu5t
         2VGsvOizsvVqFyojO3sA5ycaBzUAwHPRSbk8CK60x5pjvFH0HwJ/9b/VzxVTqswLy40x
         8LB74OroSG6CrZXVF0ksKrq0NuyWLE7WZsEIibO8o/67WD3sbzeqSlel85zKB16quriy
         5XBAZQlDDKnTVpDsTMGV6J5mYFnCSoBdF67H/A0Hd+Q3AgSNaCYA9T38Rw6kQnFwKsHa
         oVmLxgesCUOAJX3dhVlfpL1RK5F8qxoKaQLnas83Kw47Np29AZyCxDjbb2LAh3pj9XoA
         SBNg==
X-Gm-Message-State: AJIora+aXDaPzJgh21URdQpyMMbQ8uTitsB1SpvxHn019Wd3KLzWaLdS
        lnT2eELkgmcBgZP7LiRwrd4IIk2gTJXdNQ==
X-Google-Smtp-Source: AGRyM1s8s7CK3vj94kIHeXK3IdC7Z6EIP0PaznQeLb46bmW50K5lwNfUk7e2aHeUe4YaqsqyW4NXwjPDfls3FQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:12d6:0:b0:314:6097:b272 with SMTP id
 205-20020a8112d6000000b003146097b272mr8522541yws.159.1655958981873; Wed, 22
 Jun 2022 21:36:21 -0700 (PDT)
Date:   Thu, 23 Jun 2022 04:34:49 +0000
In-Reply-To: <20220623043449.1217288-1-edumazet@google.com>
Message-Id: <20220623043449.1217288-20-edumazet@google.com>
Mime-Version: 1.0
References: <20220623043449.1217288-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH v2 net-next 19/19] ip6mr: convert mrt_lock to a spinlock
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

mrt_lock is only held in write mode, from process context only.

We can switch to a mere spinlock, and avoid blocking BH.

Also, vif_dev_read() is always called under standard rcu_read_lock().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/ip6mr.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 7381cfdac3e376c97917465918a464bd61643f2a..ec6e1509fc7cdfaf55bc79034f43b6e3ce0434ed 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -62,12 +62,11 @@ struct ip6mr_result {
    Note that the changes are semaphored via rtnl_lock.
  */
 
-static DEFINE_RWLOCK(mrt_lock);
+static DEFINE_SPINLOCK(mrt_lock);
 
 static struct net_device *vif_dev_read(const struct vif_device *vif)
 {
-	return rcu_dereference_check(vif->dev,
-				     lockdep_is_held(&mrt_lock));
+	return rcu_dereference(vif->dev);
 }
 
 /* Multicast router control variables */
@@ -714,7 +713,7 @@ static int mif6_delete(struct mr_table *mrt, int vifi, int notify,
 	call_ip6mr_vif_entry_notifiers(read_pnet(&mrt->net),
 				       FIB_EVENT_VIF_DEL, v, dev,
 				       vifi, mrt->id);
-	write_lock_bh(&mrt_lock);
+	spin_lock(&mrt_lock);
 	RCU_INIT_POINTER(v->dev, NULL);
 
 #ifdef CONFIG_IPV6_PIMSM_V2
@@ -733,7 +732,7 @@ static int mif6_delete(struct mr_table *mrt, int vifi, int notify,
 		WRITE_ONCE(mrt->maxvif, tmp + 1);
 	}
 
-	write_unlock_bh(&mrt_lock);
+	spin_unlock(&mrt_lock);
 
 	dev_set_allmulti(dev, -1);
 
@@ -833,7 +832,7 @@ static void ipmr_expire_process(struct timer_list *t)
 	spin_unlock(&mfc_unres_lock);
 }
 
-/* Fill oifs list. It is called under write locked mrt_lock. */
+/* Fill oifs list. It is called under locked mrt_lock. */
 
 static void ip6mr_update_thresholds(struct mr_table *mrt,
 				    struct mr_mfc *cache,
@@ -919,7 +918,7 @@ static int mif6_add(struct net *net, struct mr_table *mrt,
 			MIFF_REGISTER);
 
 	/* And finish update writing critical data */
-	write_lock_bh(&mrt_lock);
+	spin_lock(&mrt_lock);
 	rcu_assign_pointer(v->dev, dev);
 	netdev_tracker_alloc(dev, &v->dev_tracker, GFP_ATOMIC);
 #ifdef CONFIG_IPV6_PIMSM_V2
@@ -928,7 +927,7 @@ static int mif6_add(struct net *net, struct mr_table *mrt,
 #endif
 	if (vifi + 1 > mrt->maxvif)
 		WRITE_ONCE(mrt->maxvif, vifi + 1);
-	write_unlock_bh(&mrt_lock);
+	spin_unlock(&mrt_lock);
 	call_ip6mr_vif_entry_notifiers(net, FIB_EVENT_VIF_ADD,
 				       v, dev, vifi, mrt->id);
 	return 0;
@@ -1442,12 +1441,12 @@ static int ip6mr_mfc_add(struct net *net, struct mr_table *mrt,
 				    &mfc->mf6cc_mcastgrp.sin6_addr, parent);
 	rcu_read_unlock();
 	if (c) {
-		write_lock_bh(&mrt_lock);
+		spin_lock(&mrt_lock);
 		c->_c.mfc_parent = mfc->mf6cc_parent;
 		ip6mr_update_thresholds(mrt, &c->_c, ttls);
 		if (!mrtsock)
 			c->_c.mfc_flags |= MFC_STATIC;
-		write_unlock_bh(&mrt_lock);
+		spin_unlock(&mrt_lock);
 		call_ip6mr_mfc_entry_notifiers(net, FIB_EVENT_ENTRY_REPLACE,
 					       c, mrt->id);
 		mr6_netlink_event(mrt, c, RTM_NEWROUTE);
@@ -1565,7 +1564,7 @@ static int ip6mr_sk_init(struct mr_table *mrt, struct sock *sk)
 	struct net *net = sock_net(sk);
 
 	rtnl_lock();
-	write_lock_bh(&mrt_lock);
+	spin_lock(&mrt_lock);
 	if (rtnl_dereference(mrt->mroute_sk)) {
 		err = -EADDRINUSE;
 	} else {
@@ -1573,7 +1572,7 @@ static int ip6mr_sk_init(struct mr_table *mrt, struct sock *sk)
 		sock_set_flag(sk, SOCK_RCU_FREE);
 		atomic_inc(&net->ipv6.devconf_all->mc_forwarding);
 	}
-	write_unlock_bh(&mrt_lock);
+	spin_unlock(&mrt_lock);
 
 	if (!err)
 		inet6_netconf_notify_devconf(net, RTM_NEWNETCONF,
@@ -1603,14 +1602,14 @@ int ip6mr_sk_done(struct sock *sk)
 	rtnl_lock();
 	ip6mr_for_each_table(mrt, net) {
 		if (sk == rtnl_dereference(mrt->mroute_sk)) {
-			write_lock_bh(&mrt_lock);
+			spin_lock(&mrt_lock);
 			RCU_INIT_POINTER(mrt->mroute_sk, NULL);
 			/* Note that mroute_sk had SOCK_RCU_FREE set,
 			 * so the RCU grace period before sk freeing
 			 * is guaranteed by sk_destruct()
 			 */
 			atomic_dec(&devconf->mc_forwarding);
-			write_unlock_bh(&mrt_lock);
+			spin_unlock(&mrt_lock);
 			inet6_netconf_notify_devconf(net, RTM_NEWNETCONF,
 						     NETCONFA_MC_FORWARDING,
 						     NETCONFA_IFINDEX_ALL,
@@ -2097,7 +2096,7 @@ static int ip6mr_forward2(struct net *net, struct mr_table *mrt,
 	return 0;
 }
 
-/* Called with mrt_lock or rcu_read_lock() */
+/* Called with rcu_read_lock() */
 static int ip6mr_find_vif(struct mr_table *mrt, struct net_device *dev)
 {
 	int ct;
-- 
2.37.0.rc0.104.g0611611a94-goog

