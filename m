Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCA44B17CB
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 22:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344769AbiBJVmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 16:42:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344780AbiBJVmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 16:42:52 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 153D838F
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 13:42:46 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id 10so3027719plj.1
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 13:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qI5O0XuH+3yZN0d/+QqH9VaLKw3dLC9zY6iO3x506DA=;
        b=EXs9V/xVK+IAYNTRR+AmIyZxuXxMcDUz7tI5ZFVNgXKfDqA2vXK5abCJT+J8xeJMIG
         p6a9u3yT9iGNNL5QS+CkSgmHPOarKTJkF2o0sERcGL39vG005OfbKbKsWP6lVY0Oyddi
         NAXHzVr7WyjthyI2xe+HgSrusse5SnQ6SGoLYvh/hHXQXqoPHN9Zj10qeJks4kQWy6fv
         l4qyH13+AAQ47luHr8urgRsW3f0CXZ35lATesHoeBO/C7MbjqAPpf/n0wUqJOOCNnae1
         fF7IVV1nmQ6EDMN9Mkk6bJWDTC3/FJ2E/Gq+jyS5kzVJfzB4/cfRe1oWOh3b9dXb8MsQ
         yj3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qI5O0XuH+3yZN0d/+QqH9VaLKw3dLC9zY6iO3x506DA=;
        b=PduF/PHKVdonskV0SpSnKrjW2XFSAIBv+e3lKzG0pBYdYBLeiXIeoVEU/we4xFT2kK
         1S/YwLKRS+zW8CfbZSTNw38PqZIFFClZd1Z4WjlOuwy1RP8sEMkhf0Ku58+CkZBLpEj9
         vbmrfkcbW7LwEI4Jjf8RTDUHB6ub/ufaljf+vb0pNwJqq0nMARI3kGB0YpyVO270sr3t
         guS76+mSMvMu3ko0grHzcmsYHbCrdZGHoAR5hjMfq07GhXLOAfgWXLpc4vtHy2aNqMSS
         zKAieHr9WlQBy/qKPj+eilfugb/sStoG6yGdiD2gO+h5j8SH+VjA3W76FoBeQ8Xe1BlU
         A3nw==
X-Gm-Message-State: AOAM531H6R2T+nuocuWx933PXMEM+KUnuns97H6QFWTQdo9VmXcnaFIG
        Cha8tXB3AmQUGLGXFZpvLyP4ForpmXM=
X-Google-Smtp-Source: ABdhPJwzm6SrY7xfxPQJpyCyj4QpIcFZlyQa24LtLH/zSue2L0AFvJQ+rblCww9ZZoyXUaC9XFg42Q==
X-Received: by 2002:a17:902:ccd0:: with SMTP id z16mr9632442ple.13.1644529366581;
        Thu, 10 Feb 2022 13:42:46 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:60c1:10c1:3f4f:199d])
        by smtp.gmail.com with ESMTPSA id s19sm23824098pfu.34.2022.02.10.13.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 13:42:45 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 4/4] ipv4: add (struct uncached_list)->quarantine list
Date:   Thu, 10 Feb 2022 13:42:31 -0800
Message-Id: <20220210214231.2420942-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
In-Reply-To: <20220210214231.2420942-1-eric.dumazet@gmail.com>
References: <20220210214231.2420942-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This is an optimization to keep the per-cpu lists as short as possible:

Whenever rt_flush_dev() changes one rtable dst.dev
matching the disappearing device, it can can transfer the object
to a quarantine list, waiting for a final rt_del_uncached_list().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/route.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 634766e6c7cc8a472e912f7d4e99bb6be0397bb6..202d6b1fff43fb095427720ec36fe3744aeb7149 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1485,6 +1485,7 @@ static bool rt_cache_route(struct fib_nh_common *nhc, struct rtable *rt)
 struct uncached_list {
 	spinlock_t		lock;
 	struct list_head	head;
+	struct list_head	quarantine;
 };
 
 static DEFINE_PER_CPU_ALIGNED(struct uncached_list, rt_uncached_list);
@@ -1506,7 +1507,7 @@ void rt_del_uncached_list(struct rtable *rt)
 		struct uncached_list *ul = rt->rt_uncached_list;
 
 		spin_lock_bh(&ul->lock);
-		list_del(&rt->rt_uncached);
+		list_del_init(&rt->rt_uncached);
 		spin_unlock_bh(&ul->lock);
 	}
 }
@@ -1521,20 +1522,24 @@ static void ipv4_dst_destroy(struct dst_entry *dst)
 
 void rt_flush_dev(struct net_device *dev)
 {
-	struct rtable *rt;
+	struct rtable *rt, *safe;
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
 		struct uncached_list *ul = &per_cpu(rt_uncached_list, cpu);
 
+		if (list_empty(&ul->head))
+			continue;
+
 		spin_lock_bh(&ul->lock);
-		list_for_each_entry(rt, &ul->head, rt_uncached) {
+		list_for_each_entry_safe(rt, safe, &ul->head, rt_uncached) {
 			if (rt->dst.dev != dev)
 				continue;
 			rt->dst.dev = blackhole_netdev;
 			dev_replace_track(dev, blackhole_netdev,
 					  &rt->dst.dev_tracker,
 					  GFP_ATOMIC);
+			list_move(&rt->rt_uncached, &ul->quarantine);
 		}
 		spin_unlock_bh(&ul->lock);
 	}
@@ -3706,6 +3711,7 @@ int __init ip_rt_init(void)
 		struct uncached_list *ul = &per_cpu(rt_uncached_list, cpu);
 
 		INIT_LIST_HEAD(&ul->head);
+		INIT_LIST_HEAD(&ul->quarantine);
 		spin_lock_init(&ul->lock);
 	}
 #ifdef CONFIG_IP_ROUTE_CLASSID
-- 
2.35.1.265.g69c8d7142f-goog

