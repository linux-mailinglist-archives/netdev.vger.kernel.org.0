Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C1A2FC120
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 21:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbhASUeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 15:34:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:56992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391787AbhASU0G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 15:26:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D53D2313C;
        Tue, 19 Jan 2021 20:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611087925;
        bh=3/eW4H3tjjKxnfp2qh2frcEPs8tUd6lc34Qs1+xtguc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U12wyRjNljW30Zwb6xWaXmls1kfd8FOl0z7jENUlm4vyeJRgPqlRdhIqFjjWokke7
         QEu1/HbAW7IRTPxUndyDfzisvhsaQIzv6iu4QyXWbQO5vWt0Jm2yrtncAEeAWBD1WT
         5z1+P9jssrGbmqpvJaVpWOZrJXpudsx6lOiMuYJLhcWllj43cypZjwYsAVvT9pXJSt
         X9oztAixmZstkMzad+7sn0JNL96H7ULwrj8FYFdUvVWPzSEmjgJ74eZjZBbiiTj086
         D+/DNdJgOptgJDUBrL4MZBc/T1zDD3mUfbkuvOYA+0Qhn/Asdak/PXR3zLI5sAAxYg
         O/I2UudkrJlXQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 3/4] net: move rollback_registered_many()
Date:   Tue, 19 Jan 2021 12:25:20 -0800
Message-Id: <20210119202521.3108236-4-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210119202521.3108236-1-kuba@kernel.org>
References: <20210119202521.3108236-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move rollback_registered_many() and add a temporary
forward declaration to make merging the code into
unregister_netdevice_many() easier to review.

No functional changes.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/dev.c | 188 +++++++++++++++++++++++++------------------------
 1 file changed, 95 insertions(+), 93 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 85e9d4b7ddf2..a7841d03c910 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9459,99 +9459,6 @@ static void net_set_todo(struct net_device *dev)
 	dev_net(dev)->dev_unreg_count++;
 }
 
-static void rollback_registered_many(struct list_head *head)
-{
-	struct net_device *dev, *tmp;
-	LIST_HEAD(close_head);
-
-	BUG_ON(dev_boot_phase);
-	ASSERT_RTNL();
-
-	list_for_each_entry_safe(dev, tmp, head, unreg_list) {
-		/* Some devices call without registering
-		 * for initialization unwind. Remove those
-		 * devices and proceed with the remaining.
-		 */
-		if (dev->reg_state == NETREG_UNINITIALIZED) {
-			pr_debug("unregister_netdevice: device %s/%p never was registered\n",
-				 dev->name, dev);
-
-			WARN_ON(1);
-			list_del(&dev->unreg_list);
-			continue;
-		}
-		dev->dismantle = true;
-		BUG_ON(dev->reg_state != NETREG_REGISTERED);
-	}
-
-	/* If device is running, close it first. */
-	list_for_each_entry(dev, head, unreg_list)
-		list_add_tail(&dev->close_list, &close_head);
-	dev_close_many(&close_head, true);
-
-	list_for_each_entry(dev, head, unreg_list) {
-		/* And unlink it from device chain. */
-		unlist_netdevice(dev);
-
-		dev->reg_state = NETREG_UNREGISTERING;
-	}
-	flush_all_backlogs();
-
-	synchronize_net();
-
-	list_for_each_entry(dev, head, unreg_list) {
-		struct sk_buff *skb = NULL;
-
-		/* Shutdown queueing discipline. */
-		dev_shutdown(dev);
-
-		dev_xdp_uninstall(dev);
-
-		/* Notify protocols, that we are about to destroy
-		 * this device. They should clean all the things.
-		 */
-		call_netdevice_notifiers(NETDEV_UNREGISTER, dev);
-
-		if (!dev->rtnl_link_ops ||
-		    dev->rtnl_link_state == RTNL_LINK_INITIALIZED)
-			skb = rtmsg_ifinfo_build_skb(RTM_DELLINK, dev, ~0U, 0,
-						     GFP_KERNEL, NULL, 0);
-
-		/*
-		 *	Flush the unicast and multicast chains
-		 */
-		dev_uc_flush(dev);
-		dev_mc_flush(dev);
-
-		netdev_name_node_alt_flush(dev);
-		netdev_name_node_free(dev->name_node);
-
-		if (dev->netdev_ops->ndo_uninit)
-			dev->netdev_ops->ndo_uninit(dev);
-
-		if (skb)
-			rtmsg_ifinfo_send(skb, dev, GFP_KERNEL);
-
-		/* Notifier chain MUST detach us all upper devices. */
-		WARN_ON(netdev_has_any_upper_dev(dev));
-		WARN_ON(netdev_has_any_lower_dev(dev));
-
-		/* Remove entries from kobject tree */
-		netdev_unregister_kobject(dev);
-#ifdef CONFIG_XPS
-		/* Remove XPS queueing entries */
-		netif_reset_xps_queues_gt(dev, 0);
-#endif
-	}
-
-	synchronize_net();
-
-	list_for_each_entry(dev, head, unreg_list) {
-		dev_put(dev);
-		net_set_todo(dev);
-	}
-}
-
 static netdev_features_t netdev_sync_upper_features(struct net_device *lower,
 	struct net_device *upper, netdev_features_t features)
 {
@@ -10698,6 +10605,8 @@ void synchronize_net(void)
 }
 EXPORT_SYMBOL(synchronize_net);
 
+static void rollback_registered_many(struct list_head *head);
+
 /**
  *	unregister_netdevice_queue - remove device from the kernel
  *	@dev: device
@@ -10743,6 +10652,99 @@ void unregister_netdevice_many(struct list_head *head)
 }
 EXPORT_SYMBOL(unregister_netdevice_many);
 
+static void rollback_registered_many(struct list_head *head)
+{
+	struct net_device *dev, *tmp;
+	LIST_HEAD(close_head);
+
+	BUG_ON(dev_boot_phase);
+	ASSERT_RTNL();
+
+	list_for_each_entry_safe(dev, tmp, head, unreg_list) {
+		/* Some devices call without registering
+		 * for initialization unwind. Remove those
+		 * devices and proceed with the remaining.
+		 */
+		if (dev->reg_state == NETREG_UNINITIALIZED) {
+			pr_debug("unregister_netdevice: device %s/%p never was registered\n",
+				 dev->name, dev);
+
+			WARN_ON(1);
+			list_del(&dev->unreg_list);
+			continue;
+		}
+		dev->dismantle = true;
+		BUG_ON(dev->reg_state != NETREG_REGISTERED);
+	}
+
+	/* If device is running, close it first. */
+	list_for_each_entry(dev, head, unreg_list)
+		list_add_tail(&dev->close_list, &close_head);
+	dev_close_many(&close_head, true);
+
+	list_for_each_entry(dev, head, unreg_list) {
+		/* And unlink it from device chain. */
+		unlist_netdevice(dev);
+
+		dev->reg_state = NETREG_UNREGISTERING;
+	}
+	flush_all_backlogs();
+
+	synchronize_net();
+
+	list_for_each_entry(dev, head, unreg_list) {
+		struct sk_buff *skb = NULL;
+
+		/* Shutdown queueing discipline. */
+		dev_shutdown(dev);
+
+		dev_xdp_uninstall(dev);
+
+		/* Notify protocols, that we are about to destroy
+		 * this device. They should clean all the things.
+		 */
+		call_netdevice_notifiers(NETDEV_UNREGISTER, dev);
+
+		if (!dev->rtnl_link_ops ||
+		    dev->rtnl_link_state == RTNL_LINK_INITIALIZED)
+			skb = rtmsg_ifinfo_build_skb(RTM_DELLINK, dev, ~0U, 0,
+						     GFP_KERNEL, NULL, 0);
+
+		/*
+		 *	Flush the unicast and multicast chains
+		 */
+		dev_uc_flush(dev);
+		dev_mc_flush(dev);
+
+		netdev_name_node_alt_flush(dev);
+		netdev_name_node_free(dev->name_node);
+
+		if (dev->netdev_ops->ndo_uninit)
+			dev->netdev_ops->ndo_uninit(dev);
+
+		if (skb)
+			rtmsg_ifinfo_send(skb, dev, GFP_KERNEL);
+
+		/* Notifier chain MUST detach us all upper devices. */
+		WARN_ON(netdev_has_any_upper_dev(dev));
+		WARN_ON(netdev_has_any_lower_dev(dev));
+
+		/* Remove entries from kobject tree */
+		netdev_unregister_kobject(dev);
+#ifdef CONFIG_XPS
+		/* Remove XPS queueing entries */
+		netif_reset_xps_queues_gt(dev, 0);
+#endif
+	}
+
+	synchronize_net();
+
+	list_for_each_entry(dev, head, unreg_list) {
+		dev_put(dev);
+		net_set_todo(dev);
+	}
+}
+
 /**
  *	unregister_netdev - remove device from the kernel
  *	@dev: device
-- 
2.26.2

