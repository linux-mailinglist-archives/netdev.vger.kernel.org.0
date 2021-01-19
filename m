Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7592FC03C
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 20:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729811AbhASTcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 14:32:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:40788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392243AbhASTMy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 14:12:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E38522E00;
        Tue, 19 Jan 2021 19:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611083533;
        bh=NoicAfwRaUtHrYf5u8ggo5OEU9vn+py/9mjflT9M2F0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kHADm4oWgnWMpUvUcabBRxB19S4+lEDmg3g2CRHQkSnK/Py833krdcDuBYEGp70Pt
         /JPp/SctIWh5+rrBVQvV/O8ur1sri6Zg2MsaWuRpMbmUGYDSwQTlFiYMTynAFnAhV9
         fByNCG7ZMTkvl7eR0AEfOmNwOd3KwE2Pp+sFiV9nbPj3uebLuj6KsxMwOhKJVyqcaB
         7IwM2E9iQE4DyrZyjU8qf+i35YmanCN4mE2O7cnrZjvUjvfV3v2wFLRP2MKSEjUHFY
         mMZ6QxXTa8zRLwavXm+q/FhxvSWYPU3n0uw/MmIvY5uYRoWzCSCFDAwWlQVMMDNZvj
         +i/Xaz2LNwAKQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/4] net: inline rollback_registered()
Date:   Tue, 19 Jan 2021 11:11:56 -0800
Message-Id: <20210119191158.3093099-3-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210119191158.3093099-1-kuba@kernel.org>
References: <20210119191158.3093099-1-kuba@kernel.org>
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

