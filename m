Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCAD6467035
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378229AbhLCCux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:50:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378242AbhLCCux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 21:50:53 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF42AC06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 18:47:29 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id y7so1150420plp.0
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 18:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=48N6fDcox0daRV3v03PbzXuddU0gNFZuG8z1YrrJ8J0=;
        b=FAy+I+H4vcT+hO9U6Jtw5wZNpmQrpFAzIImDdyH3u4ApRFWRTdIGRFeZDgiieiLq+A
         wenzMCwgaWtgbnHBHjLvUVO6kRlTWtvOn5/eB1Co+RVRgTml45mAs67nJYuj1Cf6oNbm
         WR0CJ1YG9Cjkx7lgp7oY0oVBWadwlAOWfEakeLGtzrZfZkllWIcoE4ZlLITJCX5aA6Hm
         dd88M8I0pa3G4JQiNkutq3iXjVKrkKNS4muVjW1drnfQlDODjw6OqnAU4axXDp2SI6gu
         z1aVCs/D2C5hUhywM6uSKc3AtR06YmGVTF4lSc2PmhFu+sXixZT5od1dDBPqNTklBxix
         cW+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=48N6fDcox0daRV3v03PbzXuddU0gNFZuG8z1YrrJ8J0=;
        b=Vsu4zubyuiAVi9F5cfiMk5tDAQrhVva+e8y/2NoCgHjK81sJ9AS8PKiv3htZYJmFCZ
         2MBxNe9dds8L5IA/ID/2THq+BlBwKw3NnC2BTl4uJDolE9n+tMcCbA887lk42gF7+aFc
         9WgBipNHTrnYp8RXKaV9qVORuqRlGg4C0oQE8Wo6x8gZAgd+pvi6ScJjEah63J+ZL17j
         9Bsbplha4spMkoWGk7Pne93Tm2xYvFhVM1fdTyWGtefUD+x0OmTsAJfKfLhES3eD/4i0
         h8JhYi4x0Nd9gDjovQoR238C3fpskMVZu1gNECxO+PfX5WY4AlrSmNFq2w+z9tcdozgL
         JTuQ==
X-Gm-Message-State: AOAM530DF7rEIMiAB6WKv8hCscI1++F8H/JydC18f2tnldbnXKRV8K8a
        icxZGSXPOXfdeeIjxGe4kME=
X-Google-Smtp-Source: ABdhPJyDoomTDBaRekCSUiyQn3e5/6XjynblHDsQKQyKq2aBr4HORJBIPlyhhqLAu3dHP8ePt+4jUQ==
X-Received: by 2002:a17:902:cecf:b0:141:e15d:4a2a with SMTP id d15-20020a170902cecf00b00141e15d4a2amr19692915plg.66.1638499649570;
        Thu, 02 Dec 2021 18:47:29 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6c4b:c5cb:ac63:1ebf])
        by smtp.gmail.com with ESMTPSA id k2sm1230260pfc.53.2021.12.02.18.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 18:47:28 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 05/23] net: add net device refcount tracker to struct netdev_queue
Date:   Thu,  2 Dec 2021 18:46:22 -0800
Message-Id: <20211203024640.1180745-6-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203024640.1180745-1-eric.dumazet@gmail.com>
References: <20211203024640.1180745-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This will help debugging pesky netdev reference leaks.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h | 2 ++
 net/core/net-sysfs.c      | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5bda48d81240e010bffb1cfa96e7a84c733a919a..3223f7db128de3a7353e6d50255c01ccf6c90ba7 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -586,6 +586,8 @@ struct netdev_queue {
  * read-mostly part
  */
 	struct net_device	*dev;
+	netdevice_tracker	dev_tracker;
+
 	struct Qdisc __rcu	*qdisc;
 	struct Qdisc		*qdisc_sleeping;
 #ifdef CONFIG_SYSFS
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 27a7ac2e516f65dbfdb2a2319e6faa27c7dd8f31..3b2cdbbdc858e06fb0a482a9b7fc778e501ba1e0 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1607,7 +1607,7 @@ static void netdev_queue_release(struct kobject *kobj)
 	struct netdev_queue *queue = to_netdev_queue(kobj);
 
 	memset(kobj, 0, sizeof(*kobj));
-	dev_put(queue->dev);
+	dev_put_track(queue->dev, &queue->dev_tracker);
 }
 
 static const void *netdev_queue_namespace(struct kobject *kobj)
@@ -1647,7 +1647,7 @@ static int netdev_queue_add_kobject(struct net_device *dev, int index)
 	/* Kobject_put later will trigger netdev_queue_release call
 	 * which decreases dev refcount: Take that reference here
 	 */
-	dev_hold(queue->dev);
+	dev_hold_track(queue->dev, &queue->dev_tracker, GFP_KERNEL);
 
 	kobj->kset = dev->queues_kset;
 	error = kobject_init_and_add(kobj, &netdev_queue_ktype, NULL,
-- 
2.34.1.400.ga245620fadb-goog

