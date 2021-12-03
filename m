Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15446467041
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378270AbhLCCvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:51:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378269AbhLCCvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 21:51:31 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E4EC061757
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 18:48:08 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id x5so1546060pfr.0
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 18:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=20Cb5L4Nfh6M+TGH/ohYepS0hgWA3PLHDkuxzPE2zO0=;
        b=b1y0hvvODp4aUqy4VRJeN4mnsi80HDuqUbHPIpjAiccEEV6CFJh+CISv2XkWczU2Uc
         vkITUNVbOtn+cesV5N6Na7CbKUFL2VHFQ/TwgFJw+l2tmFmrH2uOyRH61fSzPg8ZCkGS
         YWRhwHQyL6RVUKYS7C4fmWqeQN2oRr6wcxvqIOf3XRWlEK7O/dlJyoLzyW1cM1UJN8AE
         IKDGn6v1iysiJwNTW/RXQHXHPZIov3Ew71O2R8id9oDOlM4NK0BYxP087jiriGyGruy9
         aMmWbqltx8wMPzJOwu0+XVVMgZdURPzrrDrF2S/1ionmU5EJymRbnj4Hw4CtSj6hKggV
         ah5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=20Cb5L4Nfh6M+TGH/ohYepS0hgWA3PLHDkuxzPE2zO0=;
        b=SZpIMcHjRE0bKdqpTjskEBaljCJdm86wRL41cx8n0VjOp5L5NkqxLw0pPRheLb97yC
         vqn2PzgCgbPcqDYd3s+q6UBP06tLilnxwMyZYn+HItI+l3dSxnwXKuSAFYFY97fnWP1Q
         eeV1XOezN49AzxAHTf0W+35MQwFf0VlAl6rNpOy+z7vrRchMYiaUfu59JV1mtNZ/4uSF
         2PJLTC/m9FXA8tr2BQZi3L7OPxAttxBSY8VUbU/O/KppNERr2fWVhEIfaqQxGEfII445
         qafOBeUz+ki9Bel0vxDyNVVPZRlQo7eJHcXOScbtPBSvndTpMLmW480sxjvY+zVmvZXV
         f12w==
X-Gm-Message-State: AOAM5307pyLCE0Y+6W9G9HRzgd9Foh2+/qPpjMsvFqo/Lb+E3vBdNRVX
        39PghIh2Z7QVO86vHSdgJMc=
X-Google-Smtp-Source: ABdhPJwCymo+fxCDMIaxF2rsqHnd5NzqmOjOZF9fEbIwx/m51uH8L7gq+WmvAZPRBmc/+dHQF4K1QQ==
X-Received: by 2002:a63:2cd1:: with SMTP id s200mr2423573pgs.489.1638499688351;
        Thu, 02 Dec 2021 18:48:08 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6c4b:c5cb:ac63:1ebf])
        by smtp.gmail.com with ESMTPSA id k2sm1230260pfc.53.2021.12.02.18.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 18:48:08 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 16/23] net: add net device refcount tracker to struct netdev_adjacent
Date:   Thu,  2 Dec 2021 18:46:33 -0800
Message-Id: <20211203024640.1180745-17-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203024640.1180745-1-eric.dumazet@gmail.com>
References: <20211203024640.1180745-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/dev.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 1740d6cfe86b58359cceaec7ee9cc015a3843723..4420086f3aeb34614fc8222206dff2b2caa31d02 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6537,6 +6537,7 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
 
 struct netdev_adjacent {
 	struct net_device *dev;
+	netdevice_tracker dev_tracker;
 
 	/* upper master flag, there can only be one master device per list */
 	bool master;
@@ -7301,7 +7302,7 @@ static int __netdev_adjacent_dev_insert(struct net_device *dev,
 	adj->ref_nr = 1;
 	adj->private = private;
 	adj->ignore = false;
-	dev_hold(adj_dev);
+	dev_hold_track(adj_dev, &adj->dev_tracker, GFP_KERNEL);
 
 	pr_debug("Insert adjacency: dev %s adj_dev %s adj->ref_nr %d; dev_hold on %s\n",
 		 dev->name, adj_dev->name, adj->ref_nr, adj_dev->name);
@@ -7330,8 +7331,8 @@ static int __netdev_adjacent_dev_insert(struct net_device *dev,
 	if (netdev_adjacent_is_neigh_list(dev, adj_dev, dev_list))
 		netdev_adjacent_sysfs_del(dev, adj_dev->name, dev_list);
 free_adj:
+	dev_put_track(adj_dev, &adj->dev_tracker);
 	kfree(adj);
-	dev_put(adj_dev);
 
 	return ret;
 }
@@ -7372,7 +7373,7 @@ static void __netdev_adjacent_dev_remove(struct net_device *dev,
 	list_del_rcu(&adj->list);
 	pr_debug("adjacency: dev_put for %s, because link removed from %s to %s\n",
 		 adj_dev->name, dev->name, adj_dev->name);
-	dev_put(adj_dev);
+	dev_put_track(adj_dev, &adj->dev_tracker);
 	kfree_rcu(adj, rcu);
 }
 
-- 
2.34.1.400.ga245620fadb-goog

