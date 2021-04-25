Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D1F36A812
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 17:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhDYPxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 11:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbhDYPxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 11:53:09 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E23C061760
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 08:52:29 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id s20so11787222plr.13
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 08:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=B3+KCJ5ApyzyPJl3sgcRdpnOQXUWjk8rmeAno36JzEw=;
        b=la8B5yoiTW2qw84bOtcqm8RFmSoBA5lx5DKrw5+f4oNUbmjVKpKn3g9uQwcjQ8/U5b
         5NPEaWDoFHemDdepWjVNWgePPaLL+yfB78XW7MVg5+jD1f71JmTovswjCXDedE7raslz
         6qfci59guPI0uKvKn2Rti7AZEClvnlSqg2t0SmfSzosvmlFu9+Bjl3f/9W0fOruJz4NX
         h+FclC5u2gzf7YwrbrlB7FF+Fq5UL2W5ZUkG/c/Vsv41aHk5x9F25Is0uLKcAQvdZtUe
         mpTWv4FOKz8XBtj8u+Yd93VApDsO54xZ97US8rVzRWzek7XcMG1uUWzHjdyNDulr28/T
         fuUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=B3+KCJ5ApyzyPJl3sgcRdpnOQXUWjk8rmeAno36JzEw=;
        b=UzJziKzUgaezpSndpR8y9kpk5ob2mMVPmtFjLtNhDr01TpmS1TjQnWirtFM41DoEvF
         /jz83dkvKY9TMv2tWXU/aZw0DE2eRvhzOCcg3KFNZkBxAg1vM9a+mg+KHdMiZMl/U9Z+
         LLKzpuFUbIiPDyCorx2jr+BNzoMpEUz60XF1U5b5lsJ45Peg4WIXmY4v2C9e58tS6xqc
         VfiPimgmM6VscVrEyniEAhvwteIzAlhAwLwihVbJC15J44Avs3kptXT255yLlQQkHUfW
         ThBhSO/fVcC3QEPasaKjpOmYbSkeDOMJQygsAuyC15HfydsjFIoRRg6XGDZ8pFWCWBuZ
         eMZg==
X-Gm-Message-State: AOAM531umyOQ1ZeTgtLgg52tspCFv9TPBImxbiGu53+NlH3KJUuPhDDv
        Wf7kOD/hLdNF/d11S9MPzRQ=
X-Google-Smtp-Source: ABdhPJxS9jL5CQiljA4fuqZRHwlEFUz4a+8lIg9rLenhXRjJe+/WATeszLcrmn97dklXppdj8KN7cw==
X-Received: by 2002:a17:90b:4a4e:: with SMTP id lb14mr17092244pjb.155.1619365949090;
        Sun, 25 Apr 2021 08:52:29 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id v21sm1563936pjg.9.2021.04.25.08.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 08:52:28 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        roopa@nvidia.com, nikolay@nvidia.com, ast@kernel.org,
        andriin@fb.com, daniel@iogearbox.net, weiwan@google.com,
        cong.wang@bytedance.com, bjorn@kernel.org,
        herbert@gondor.apana.org.au, bridge@lists.linux-foundation.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 1/2] net: core: make bond_get_lowest_level_rcu() generic
Date:   Sun, 25 Apr 2021 15:52:06 +0000
Message-Id: <20210425155207.29888-2-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210425155207.29888-1-ap420073@gmail.com>
References: <20210425155207.29888-1-ap420073@gmail.com>
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

