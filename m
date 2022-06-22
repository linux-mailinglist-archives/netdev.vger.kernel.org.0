Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9F4554221
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 07:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357051AbiFVFNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 01:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356969AbiFVFN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 01:13:29 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87A435DF2
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:28 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id a8-20020a25a188000000b0066839c45fe8so13667064ybi.17
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7rjrQ3wFza4ZoUN3WC5B+Xi/dWO10C5OH6N7utNmGIw=;
        b=LETSOc/bssPVooI/vaNgy4jS0YBe6yd7yiRnZCZ6kwrxfK1ITNI1kmJ5tTrwosMcBr
         /hgQP8G8MhkD+Sjr6cYE8C+MwE3DO2DNAiFsbcGCCZzDO8gCQnZjEuKEdx42jWD2C4ue
         n/cHD7hHkxO3I8TlXvqpf1oKsep8NNM7LJWASuCzDTZbDbJYes6iE3Gz06nwPJkNmhU2
         vS16RE+lFo6i04aj+swmz7+e6lxOB2antwKIDY4gc0wayalgYFb0+SbvbdFfare21Fzt
         Wf/GNc2xgXe19WTTbeTPVmqaiZXmT7RrHR3S/+6uTvzUXP+ZG99bVgGwojPT0ElqXAaA
         73PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7rjrQ3wFza4ZoUN3WC5B+Xi/dWO10C5OH6N7utNmGIw=;
        b=DBy/SOZR3CJrGF/2IO4QAVWo/Q4Cuxgopa43PABmGOcb9AbXZzJMPZ6KvCfmxcZlX9
         Dd6/oWe3cgEKr7rOV7ddsMyojVYpiOtGrqKSdGXBqxm8CbNUwqJjlZYz+DnqyLImpFqD
         vL6K0pO9QTJkrKejLZZAp0XPhaKU7R2Mg3mDepMnVChcXJrG2hnNWHUVA9pVTgf3QSqi
         PXAnzyxtfdO7VnMiaqn5x0D/1xYibX0F7a1t7XvaqhyKrJyU436JqdmSTHwa+a5HfWKC
         6osXuA7jHbbBjIwUA8LQEvzc+BkDqqRzjohfa2SfwrzUZE2HV659kqOesrl8XqeNjl/p
         DHmw==
X-Gm-Message-State: AJIora+nq242VPylgAm8MrQmCmtVJwZUaT0mQ9c0LoVza2NbOyafqO5W
        N/CxuwVskS+oiGbE2Uq85qgSt+6xJUqxBQ==
X-Google-Smtp-Source: AGRyM1vhrc76EprVw5CApFmzsMttOfvoXPREFJDmb3jUuhPwqzFvpQ2smIL3KOD1FvJNkbdrG+hM+W28ZHnenA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a0d:d8c5:0:b0:318:3994:cc3e with SMTP id
 a188-20020a0dd8c5000000b003183994cc3emr2115457ywe.225.1655874808494; Tue, 21
 Jun 2022 22:13:28 -0700 (PDT)
Date:   Wed, 22 Jun 2022 05:12:52 +0000
In-Reply-To: <20220622051255.700309-1-edumazet@google.com>
Message-Id: <20220622051255.700309-17-edumazet@google.com>
Mime-Version: 1.0
References: <20220622051255.700309-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH net-next 16/19] ipmr: adopt rcu_read_lock() in mr_dump()
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

We no longer need to acquire mrt_lock() in mr_dump,
using rcu_read_lock() is enough.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/mroute_base.h | 4 ++--
 net/ipv4/ipmr.c             | 2 +-
 net/ipv4/ipmr_base.c        | 8 +++-----
 net/ipv6/ip6mr.c            | 2 +-
 4 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/include/linux/mroute_base.h b/include/linux/mroute_base.h
index 10d1e4fb4e9fe387d914c83d135ed6a8f284c374..9dd4bf1572553ffbf41bade97393fac091797a8d 100644
--- a/include/linux/mroute_base.h
+++ b/include/linux/mroute_base.h
@@ -308,7 +308,7 @@ int mr_dump(struct net *net, struct notifier_block *nb, unsigned short family,
 			      struct netlink_ext_ack *extack),
 	    struct mr_table *(*mr_iter)(struct net *net,
 					struct mr_table *mrt),
-	    rwlock_t *mrt_lock, struct netlink_ext_ack *extack);
+	    struct netlink_ext_ack *extack);
 #else
 static inline void vif_device_init(struct vif_device *v,
 				   struct net_device *dev,
@@ -363,7 +363,7 @@ static inline int mr_dump(struct net *net, struct notifier_block *nb,
 					    struct netlink_ext_ack *extack),
 			  struct mr_table *(*mr_iter)(struct net *net,
 						      struct mr_table *mrt),
-			  rwlock_t *mrt_lock, struct netlink_ext_ack *extack)
+			  struct netlink_ext_ack *extack)
 {
 	return -EINVAL;
 }
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 69ccd3d7c655a53d3cf1ac9104b9da94213416f6..38963b8de7af65cabd09894a816d342cd3cee5df 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -3027,7 +3027,7 @@ static int ipmr_dump(struct net *net, struct notifier_block *nb,
 		     struct netlink_ext_ack *extack)
 {
 	return mr_dump(net, nb, RTNL_FAMILY_IPMR, ipmr_rules_dump,
-		       ipmr_mr_table_iter, &mrt_lock, extack);
+		       ipmr_mr_table_iter, extack);
 }
 
 static const struct fib_notifier_ops ipmr_notifier_ops_template = {
diff --git a/net/ipv4/ipmr_base.c b/net/ipv4/ipmr_base.c
index 59f62b938472aef79b4eb3ade706bf4d111e1e3a..271dc03fc6dbd9b35db4d5782716679134f225e4 100644
--- a/net/ipv4/ipmr_base.c
+++ b/net/ipv4/ipmr_base.c
@@ -399,7 +399,6 @@ int mr_dump(struct net *net, struct notifier_block *nb, unsigned short family,
 			      struct netlink_ext_ack *extack),
 	    struct mr_table *(*mr_iter)(struct net *net,
 					struct mr_table *mrt),
-	    rwlock_t *mrt_lock,
 	    struct netlink_ext_ack *extack)
 {
 	struct mr_table *mrt;
@@ -416,10 +415,9 @@ int mr_dump(struct net *net, struct notifier_block *nb, unsigned short family,
 		int vifi;
 
 		/* Notifiy on table VIF entries */
-		read_lock(mrt_lock);
+		rcu_read_lock();
 		for (vifi = 0; vifi < mrt->maxvif; vifi++, v++) {
-			vif_dev = rcu_dereference_check(v->dev,
-							lockdep_is_held(mrt_lock));
+			vif_dev = rcu_dereference(v->dev);
 			if (!vif_dev)
 				continue;
 
@@ -430,7 +428,7 @@ int mr_dump(struct net *net, struct notifier_block *nb, unsigned short family,
 			if (err)
 				break;
 		}
-		read_unlock(mrt_lock);
+		rcu_read_unlock();
 
 		if (err)
 			return err;
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 08ac177fe30ca3bfbc50cd73b41cdc3da56d23e0..f0a9bceb8e3c05ab45e95e8983e505edc005917e 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1267,7 +1267,7 @@ static int ip6mr_dump(struct net *net, struct notifier_block *nb,
 		      struct netlink_ext_ack *extack)
 {
 	return mr_dump(net, nb, RTNL_FAMILY_IP6MR, ip6mr_rules_dump,
-		       ip6mr_mr_table_iter, &mrt_lock, extack);
+		       ip6mr_mr_table_iter, extack);
 }
 
 static struct notifier_block ip6_mr_notifier = {
-- 
2.37.0.rc0.104.g0611611a94-goog

