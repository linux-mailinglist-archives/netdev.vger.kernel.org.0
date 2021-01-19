Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBDA2FC00F
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 20:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731968AbhASTcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 14:32:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:40806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392248AbhASTMy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 14:12:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B06223107;
        Tue, 19 Jan 2021 19:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611083534;
        bh=nbOsQfBLsselG8ejr8u/V2kULbYmqE4TBTzu/PVXY8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k5QGlNSB8xo59wZ4OEIcFdfVEPda6uKo52nHFegTzYfi7/fHQNfV0LYC41U8CAMxZ
         kWuL9QOG2VeZAyadvYO0wL459qyzbTz+iuYbBHTobYIph0gCu7rD9wh0UvQkZigq30
         iZTOLfejUei0aZHmDns44Whqpj57UNcmwhSPF9ZovgS6xlveNajxskeQonTKrg44gr
         xJ6SS8VyzMEGvtqnhzAOLV1yIhCYwCu8Dx1CWIsQHCJ9MEHoAxQLOezFMui0506fKh
         WBAgpM4ygWoHpEmLLzXV5oSLW99McZUHV+QsVvle2yYCWF/1d3gSE+oppENHM+Yrp6
         a5qotfSKsumdw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 4/4] net: inline rollback_registered_many()
Date:   Tue, 19 Jan 2021 11:11:58 -0800
Message-Id: <20210119191158.3093099-5-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210119191158.3093099-1-kuba@kernel.org>
References: <20210119191158.3093099-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to the change for rollback_registered() -
rollback_registered_many() was a part of unregister_netdevice_many()
minus the net_set_todo(), which is no longer needed.

Functionally this patch moves the list_empty() check back after:

	BUG_ON(dev_boot_phase);
	ASSERT_RTNL();

but I can't find any reason why that would be an issue.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/dev.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index a7841d03c910..fd1da943cfb9 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5709,7 +5709,7 @@ static void flush_all_backlogs(void)
 	}
 
 	/* we can have in flight packet[s] on the cpus we are not flushing,
-	 * synchronize_net() in rollback_registered_many() will take care of
+	 * synchronize_net() in unregister_netdevice_many() will take care of
 	 * them
 	 */
 	for_each_cpu(cpu, &flush_cpus)
@@ -10605,8 +10605,6 @@ void synchronize_net(void)
 }
 EXPORT_SYMBOL(synchronize_net);
 
-static void rollback_registered_many(struct list_head *head);
-
 /**
  *	unregister_netdevice_queue - remove device from the kernel
  *	@dev: device
@@ -10630,7 +10628,7 @@ void unregister_netdevice_queue(struct net_device *dev, struct list_head *head)
 		LIST_HEAD(single);
 
 		list_add(&dev->unreg_list, &single);
-		rollback_registered_many(&single);
+		unregister_netdevice_many(&single);
 		list_del(&single);
 	}
 }
@@ -10644,15 +10642,6 @@ EXPORT_SYMBOL(unregister_netdevice_queue);
  *  we force a list_del() to make sure stack wont be corrupted later.
  */
 void unregister_netdevice_many(struct list_head *head)
-{
-	if (!list_empty(head)) {
-		rollback_registered_many(head);
-		list_del(head);
-	}
-}
-EXPORT_SYMBOL(unregister_netdevice_many);
-
-static void rollback_registered_many(struct list_head *head)
 {
 	struct net_device *dev, *tmp;
 	LIST_HEAD(close_head);
@@ -10660,6 +10649,9 @@ static void rollback_registered_many(struct list_head *head)
 	BUG_ON(dev_boot_phase);
 	ASSERT_RTNL();
 
+	if (list_empty(head))
+		return;
+
 	list_for_each_entry_safe(dev, tmp, head, unreg_list) {
 		/* Some devices call without registering
 		 * for initialization unwind. Remove those
@@ -10744,6 +10736,7 @@ static void rollback_registered_many(struct list_head *head)
 		net_set_todo(dev);
 	}
 }
+EXPORT_SYMBOL(unregister_netdevice_many);
 
 /**
  *	unregister_netdev - remove device from the kernel
-- 
2.26.2

