Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A99D62FC0FC
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 21:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391707AbhASU22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 15:28:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:56998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391798AbhASU0G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 15:26:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5810E23142;
        Tue, 19 Jan 2021 20:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611087925;
        bh=mJ1AXD5yOyqGzpmFOoCAv9EAxBEeHkwGHfJvVMxBY6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GhBq0vDSCgVqv9Lpp61ItEm9irJr1wNGfcm8len8/59IfvhAUFiGyTRkLZRkn/kRW
         O54AmxlrQFO4ft40yKNOcbgiec2MHrjY0r04hwodz/ah2GMlZiK8bEELTji4+bL4rt
         +mNnY4y9zKMInAqsLCWrvYVD1n0uQ+SOtRFAQeh/FkEy8/NkfXPq97WaUhoJHOvI6S
         QWkcdb42zJm2UQUUQkxRurVpxuRUWynaRspZSlFDsEtu/zUq0yl25dSErN1cvhd2L7
         B+rH84OIy6m5BUuEV9fiVy8jf1FoVgUAmxVvjlg6vfCPnLFQGHgIECtFuZifzH7vON
         Q8qN9zkPLxnNQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 4/4] net: inline rollback_registered_many()
Date:   Tue, 19 Jan 2021 12:25:21 -0800
Message-Id: <20210119202521.3108236-5-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210119202521.3108236-1-kuba@kernel.org>
References: <20210119202521.3108236-1-kuba@kernel.org>
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
 net/core/dev.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index a7841d03c910..dee6488f8a31 100644
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
@@ -10630,8 +10628,7 @@ void unregister_netdevice_queue(struct net_device *dev, struct list_head *head)
 		LIST_HEAD(single);
 
 		list_add(&dev->unreg_list, &single);
-		rollback_registered_many(&single);
-		list_del(&single);
+		unregister_netdevice_many(&single);
 	}
 }
 EXPORT_SYMBOL(unregister_netdevice_queue);
@@ -10644,15 +10641,6 @@ EXPORT_SYMBOL(unregister_netdevice_queue);
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
@@ -10660,6 +10648,9 @@ static void rollback_registered_many(struct list_head *head)
 	BUG_ON(dev_boot_phase);
 	ASSERT_RTNL();
 
+	if (list_empty(head))
+		return;
+
 	list_for_each_entry_safe(dev, tmp, head, unreg_list) {
 		/* Some devices call without registering
 		 * for initialization unwind. Remove those
@@ -10743,7 +10734,10 @@ static void rollback_registered_many(struct list_head *head)
 		dev_put(dev);
 		net_set_todo(dev);
 	}
+
+	list_del(head);
 }
+EXPORT_SYMBOL(unregister_netdevice_many);
 
 /**
  *	unregister_netdev - remove device from the kernel
-- 
2.26.2

