Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89D0C5571CB
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 06:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbiFWElI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 00:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347428AbiFWEgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 00:36:06 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ADCA30F71
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:36:06 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id u128-20020a25dd86000000b0066073927e92so16375136ybg.13
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7rjrQ3wFza4ZoUN3WC5B+Xi/dWO10C5OH6N7utNmGIw=;
        b=XPKp+yeTV8kBer50XdEliSxmVxI5FdyYS54U+YJCZu2Vimo5kG1Fnaqq6wN77Ixysk
         fNOzsOFrLUDrkk7qoPt47M1Gm+PVCFu0PojkH+7nASs36bsUc4U8M6klrKudM657xf/K
         aFq5SucgvDF3Gfx1YAtjxId1zhBrsQU0ykx3d/k5wsQBjfQCwxH+GVSOxxZf8hwgbvH8
         Kvqa5XDG4EMPFXIsneonstlj+3LGl6IUTE7eqqZm2N1I8jAnTrRGnbB3JMQ7Vmqy5JfG
         7Cwk80WJmWdZ0kTrGOjGTJ+JH0XeImfwOiaFyRSm0uzrKR6GcTTjp28pDKqIWmVGKNgj
         gviA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7rjrQ3wFza4ZoUN3WC5B+Xi/dWO10C5OH6N7utNmGIw=;
        b=Kaiojym1qD/oWnrk0T/t0MtvQkCrDlAhEJ2yTZtBRwb/P6pRJQXkqlgtWZgSELA1Am
         IE2zsiCLsrqSpITNeR0kV6jj/kJbQrfwCLgimrz4it5rYpM0K2wR8kiN+mkK8GFEu3j4
         zhC4v6GIHaPjYQl+KnCBAR7+ELgHTHFey0CpUDGD/O2uaXKzi4AKdSl3sGuJarWrasGd
         TZTLGqVPfax5GnUnu4qjb1BpWqOJrkadQG6cKHenss/GPi8xABWPchx3JPfCEN7e3C9t
         kcPuvqQCrjQxSGLBfpcv7004vrJ3OOqaMQWwROk+gEGgECvxG4oZlspTQGIjjeBHLmUA
         4FkQ==
X-Gm-Message-State: AJIora8XsNC1kAqF2Uee37FPJ0zTucHw+xjX9f/X8QGbDm1hLdqxRlFs
        ySVHbbJZk4iSvc7NVx5pGUP8OxTRwKkwYQ==
X-Google-Smtp-Source: AGRyM1vaFIwLnSAoamL0yoOoGLJURmnQyfZlV54MhqpYeGPYyRYFdH2BZj0rsA4pINRJgKNcf7IhdwB45d2Wlw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:e30a:0:b0:664:be46:1577 with SMTP id
 z10-20020a25e30a000000b00664be461577mr7475359ybd.418.1655958965362; Wed, 22
 Jun 2022 21:36:05 -0700 (PDT)
Date:   Thu, 23 Jun 2022 04:34:46 +0000
In-Reply-To: <20220623043449.1217288-1-edumazet@google.com>
Message-Id: <20220623043449.1217288-17-edumazet@google.com>
Mime-Version: 1.0
References: <20220623043449.1217288-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH v2 net-next 16/19] ipmr: adopt rcu_read_lock() in mr_dump()
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

