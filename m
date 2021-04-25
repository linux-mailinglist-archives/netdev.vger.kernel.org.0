Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4020136A81D
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 17:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhDYP6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 11:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhDYP6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 11:58:42 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11727C061574
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 08:58:01 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id v13so14035148ple.9
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 08:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4/Id3zO9UOkD97ud9JSBjDD2mC2RMTQF143PvX5ZhaU=;
        b=Fv5B9dbcnvmZtwMrJ94ocGM00og57HJZxYRsrr+yYhq11l4X8qNVLe3/0INAEro7+W
         JtlxWaOH+IqDiqGwOWXAR80YQnQSvTV2y88Agp2OWh958QSy7poeP7OIDosuUfGoQdk2
         GpFdUkeMcuZCOKRNScMEWorqFodYfGT1Y5NI4DkggGUouPKwglIklfuGzlcYG2Gcg357
         jD02WxdrgRF7g3Ei4Y5knH9/4FPFJTF7DdKQzQRwwcBXt2HMxOitGAsllH32a2MVFGh5
         7znC9Gh2EpfoUrE6wUJnIkz98GNbuMsg5uzajrwogEAAJyHMUZD4ajQ2Yj7CYi2bIyGb
         pCNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4/Id3zO9UOkD97ud9JSBjDD2mC2RMTQF143PvX5ZhaU=;
        b=DN9VDWg8gooEy0K93uFwdZqYnlqoqEZkHSWSU0XW0cf+Jxn5LVlzJnhQk3/n2yCCw6
         VGyh3PhGS6Tld/5vQ+LE3hcbvYL62CZph1BWzqqwwOadezzt45Wn4vZpkipPyH7GNut+
         5dU8KmVOTWv7xbJNTWeCYIjQpyNySRr8iNHTrsazyqJYoLLBdTuFJmEBwzwOjsF+C2MZ
         6GAZ+Fb/YO2JUSnG0AOi45/KF2WoJu0xJvWuxRAQOi34naEP1P3PosIixhQLPWPVr5g7
         SZqwjH3m7ZMIj3XIwIc+MJxg85aFnjpUerB1KUl074t+sovH2vYD4Aj5kR1kW9niFyh3
         ANKw==
X-Gm-Message-State: AOAM532uxjrVMi1K6ry616jMvQ50ZTLoyHmMJ4ReK3Peva8EMx12CowZ
        yLdpvQnrdkL4sDEYochRptQ=
X-Google-Smtp-Source: ABdhPJxn6tGBDLg4dwS608uoJDQzCKEQUxkcmC98wjFx2PmeXBQRTtDiE/v2GSryKsvJ90atM0cw+Q==
X-Received: by 2002:a17:90a:3e43:: with SMTP id t3mr17807988pjm.216.1619366280575;
        Sun, 25 Apr 2021 08:58:00 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id j26sm8983010pfn.47.2021.04.25.08.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 08:58:00 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        roopa@nvidia.com, nikolay@nvidia.com, ast@kernel.org,
        andriin@fb.com, daniel@iogearbox.net, weiwan@google.com,
        cong.wang@bytedance.com, bjorn@kernel.org,
        herbert@gondor.apana.org.au, bridge@lists.linux-foundation.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 1/2] net: core: make bond_get_lowest_level_rcu() generic
Date:   Sun, 25 Apr 2021 15:57:41 +0000
Message-Id: <20210425155742.30057-2-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210425155742.30057-1-ap420073@gmail.com>
References: <20210425155742.30057-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of bond_get_lowest_level_rcu() is to get nested_level under
RCU. Because dev->nested_level is protected by RTNL, so it shouldn't be
used without RTNL. But bonding module needs this value under RCU without
RTNL.
So, this function was added.

But, there is another module, which needs this function.
So, make this function generic.
the new name is netdev_get_nest_level_rcu().

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2:
 - No change

 drivers/net/bonding/bond_main.c | 45 +--------------------------------
 include/linux/netdevice.h       |  1 +
 net/core/dev.c                  | 44 ++++++++++++++++++++++++++++++++
 3 files changed, 46 insertions(+), 44 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 83ef62db6285..a9feb039ffa6 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3754,47 +3754,6 @@ static void bond_fold_stats(struct rtnl_link_stats64 *_res,
 	}
 }
 
-#ifdef CONFIG_LOCKDEP
-static int bond_get_lowest_level_rcu(struct net_device *dev)
-{
-	struct net_device *ldev, *next, *now, *dev_stack[MAX_NEST_DEV + 1];
-	struct list_head *niter, *iter, *iter_stack[MAX_NEST_DEV + 1];
-	int cur = 0, max = 0;
-
-	now = dev;
-	iter = &dev->adj_list.lower;
-
-	while (1) {
-		next = NULL;
-		while (1) {
-			ldev = netdev_next_lower_dev_rcu(now, &iter);
-			if (!ldev)
-				break;
-
-			next = ldev;
-			niter = &ldev->adj_list.lower;
-			dev_stack[cur] = now;
-			iter_stack[cur++] = iter;
-			if (max <= cur)
-				max = cur;
-			break;
-		}
-
-		if (!next) {
-			if (!cur)
-				return max;
-			next = dev_stack[--cur];
-			niter = iter_stack[cur];
-		}
-
-		now = next;
-		iter = niter;
-	}
-
-	return max;
-}
-#endif
-
 static void bond_get_stats(struct net_device *bond_dev,
 			   struct rtnl_link_stats64 *stats)
 {
@@ -3806,9 +3765,7 @@ static void bond_get_stats(struct net_device *bond_dev,
 
 
 	rcu_read_lock();
-#ifdef CONFIG_LOCKDEP
-	nest_level = bond_get_lowest_level_rcu(bond_dev);
-#endif
+	nest_level = netdev_get_nest_level_rcu(bond_dev);
 
 	spin_lock_nested(&bond->stats_lock, nest_level);
 	memcpy(stats, &bond->bond_stats, sizeof(*stats));
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 87a5d186faff..507c06bf5dba 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4699,6 +4699,7 @@ int netdev_walk_all_lower_dev(struct net_device *dev,
 			      int (*fn)(struct net_device *lower_dev,
 					struct netdev_nested_priv *priv),
 			      struct netdev_nested_priv *priv);
+int netdev_get_nest_level_rcu(struct net_device *dev);
 int netdev_walk_all_lower_dev_rcu(struct net_device *dev,
 				  int (*fn)(struct net_device *lower_dev,
 					    struct netdev_nested_priv *priv),
diff --git a/net/core/dev.c b/net/core/dev.c
index 15fe36332fb8..efc2bf88eafd 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7709,6 +7709,50 @@ static int __netdev_update_lower_level(struct net_device *dev,
 	return 0;
 }
 
+int netdev_get_nest_level_rcu(struct net_device *dev)
+{
+#ifdef CONFIG_LOCKDEP
+	struct net_device *ldev, *next, *now, *dev_stack[MAX_NEST_DEV + 1];
+	struct list_head *niter, *iter, *iter_stack[MAX_NEST_DEV + 1];
+	int cur = 0, max = 0;
+
+	now = dev;
+	iter = &dev->adj_list.lower;
+
+	while (1) {
+		next = NULL;
+		while (1) {
+			ldev = netdev_next_lower_dev_rcu(now, &iter);
+			if (!ldev)
+				break;
+
+			next = ldev;
+			niter = &ldev->adj_list.lower;
+			dev_stack[cur] = now;
+			iter_stack[cur++] = iter;
+			if (max <= cur)
+				max = cur;
+			break;
+		}
+
+		if (!next) {
+			if (!cur)
+				return max;
+			next = dev_stack[--cur];
+			niter = iter_stack[cur];
+		}
+
+		now = next;
+		iter = niter;
+	}
+
+	return max;
+#else
+	return 0;
+#endif
+}
+EXPORT_SYMBOL_GPL(netdev_get_nest_level_rcu);
+
 int netdev_walk_all_lower_dev_rcu(struct net_device *dev,
 				  int (*fn)(struct net_device *dev,
 					    struct netdev_nested_priv *priv),
-- 
2.17.1

