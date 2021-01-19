Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D482FC11F
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 21:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390220AbhASUdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 15:33:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:56988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391786AbhASU0F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 15:26:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B933E2313A;
        Tue, 19 Jan 2021 20:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611087924;
        bh=NoicAfwRaUtHrYf5u8ggo5OEU9vn+py/9mjflT9M2F0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ojQpblrgtyY6f2eehG9g5UwQyJPyTt9BbUAdhS3RGbsW8Pa4e41shzLkfPHRVDYOU
         jZyCdpmOw6gmli5Phmcx3woNoekfKqFDNevUx6RzRyoZruuQGnS4wlHwzL0qV+TOao
         cKDgNRCUJLXl6xbFi5zlcm4vnHvpvHW0xyC8pZIM4SRx+iDQDT2PdWY/pBbZhcHMHx
         BS15koinx42AN4A6fO+M3D1nNPGhyvJfEwSovi0CwmiiaLsD5v0b2DB2VkiOPtMRL9
         sDOrcdWHyZLrIhBv61WGJOIRbLMAxXTIqKHrdph35/sYzkSJd9IVFaPGCov2NM1vpe
         GWm5FHPp05rVA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 2/4] net: inline rollback_registered()
Date:   Tue, 19 Jan 2021 12:25:19 -0800
Message-Id: <20210119202521.3108236-3-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210119202521.3108236-1-kuba@kernel.org>
References: <20210119202521.3108236-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rollback_registered() is a local helper, it's common for driver
code to call unregister_netdevice_queue(dev, NULL) when they
want to unregister netdevices under rtnl_lock. Inline
rollback_registered() and adjust the only remaining caller.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/dev.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 5f928b51c6b0..85e9d4b7ddf2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9552,15 +9552,6 @@ static void rollback_registered_many(struct list_head *head)
 	}
 }
 
-static void rollback_registered(struct net_device *dev)
-{
-	LIST_HEAD(single);
-
-	list_add(&dev->unreg_list, &single);
-	rollback_registered_many(&single);
-	list_del(&single);
-}
-
 static netdev_features_t netdev_sync_upper_features(struct net_device *lower,
 	struct net_device *upper, netdev_features_t features)
 {
@@ -10105,7 +10096,7 @@ int register_netdevice(struct net_device *dev)
 	if (ret) {
 		/* Expect explicit free_netdev() on failure */
 		dev->needs_free_netdev = false;
-		rollback_registered(dev);
+		unregister_netdevice_queue(dev, NULL);
 		goto out;
 	}
 	/*
@@ -10727,7 +10718,11 @@ void unregister_netdevice_queue(struct net_device *dev, struct list_head *head)
 	if (head) {
 		list_move_tail(&dev->unreg_list, head);
 	} else {
-		rollback_registered(dev);
+		LIST_HEAD(single);
+
+		list_add(&dev->unreg_list, &single);
+		rollback_registered_many(&single);
+		list_del(&single);
 	}
 }
 EXPORT_SYMBOL(unregister_netdevice_queue);
-- 
2.26.2

