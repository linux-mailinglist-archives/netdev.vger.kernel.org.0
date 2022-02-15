Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21A344B7ABC
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 23:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243787AbiBOWxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 17:53:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240855AbiBOWx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 17:53:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42159494D
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 14:53:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E641B81CD1
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 22:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC915C340F1;
        Tue, 15 Feb 2022 22:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644965595;
        bh=h81u2dxW7LFTc3/EcgsTqfPiLdv95y0gCbwbsRx4BBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VAvPmGUn40ZoiaLuvQcwmX6URzgM/mF+glY5BB+fM77Z6DbApDVOZAV8smgDPrY3Y
         DlqEOPlp/Kohwp4MVoT8NOY9t8MV1zRugjEHxCEwcybZIFOICBwxE/gHYQ7pxtT9s5
         i7GRbguKbJP4Q7GmBaLh1jY/NK9cM1GVyA0l+vtm4Nb/KrV4Jz4QxUJqXQvXjK4sbb
         IRwS4I1yWvhzReJraNiHmIV1p8lL4ulITCDtDt+dI9//OjyAnVxj0HD27pMzNh7Ceu
         ZnP3unWTUuSS7aIBWKiF3KLTjSERsRg22/0eDyLus4pEK0NSnsl80Ksz/hRdg9hGaU
         VD4l8lz3EYiXg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, lucien.xin@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/2] net: allow out-of-order netdev unregistration
Date:   Tue, 15 Feb 2022 14:53:10 -0800
Message-Id: <20220215225310.3679266-2-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215225310.3679266-1-kuba@kernel.org>
References: <20220215225310.3679266-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sprinkle for each loops to allow netdevices to be unregistered
out of order, as their refs are released.

This prevents problems caused by dependencies between netdevs
which want to release references in their ->priv_destructor.
See commit d6ff94afd90b ("vlan: move dev_put into vlan_dev_uninit")
for example.

Eric has removed the only known ordering requirement in
commit c002496babfd ("Merge branch 'ipv6-loopback'")
so let's try this and see if anything explodes...

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/dev.c | 64 +++++++++++++++++++++++++++++---------------------
 1 file changed, 37 insertions(+), 27 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 2749776e2dd2..05fa867f1878 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9811,8 +9811,8 @@ int netdev_unregister_timeout_secs __read_mostly = 10;
 #define WAIT_REFS_MIN_MSECS 1
 #define WAIT_REFS_MAX_MSECS 250
 /**
- * netdev_wait_allrefs - wait until all references are gone.
- * @dev: target net_device
+ * netdev_wait_allrefs_any - wait until all references are gone.
+ * @list: list of net_devices to wait on
  *
  * This is called when unregistering network devices.
  *
@@ -9822,37 +9822,45 @@ int netdev_unregister_timeout_secs __read_mostly = 10;
  * We can get stuck here if buggy protocols don't correctly
  * call dev_put.
  */
-static void netdev_wait_allrefs(struct net_device *dev)
+static struct net_device *netdev_wait_allrefs_any(struct list_head *list)
 {
 	unsigned long rebroadcast_time, warning_time;
-	int wait = 0, refcnt;
+	struct net_device *dev;
+	int wait = 0;
 
-	linkwatch_forget_dev(dev);
+	list_for_each_entry(dev, list, todo_list)
+		linkwatch_forget_dev(dev);
 
 	rebroadcast_time = warning_time = jiffies;
-	refcnt = netdev_refcnt_read(dev);
 
-	while (refcnt != 1) {
+	list_for_each_entry(dev, list, todo_list)
+		if (netdev_refcnt_read(dev) == 1)
+			return dev;
+
+	while (true) {
 		if (time_after(jiffies, rebroadcast_time + 1 * HZ)) {
 			rtnl_lock();
 
 			/* Rebroadcast unregister notification */
-			call_netdevice_notifiers(NETDEV_UNREGISTER, dev);
+			list_for_each_entry(dev, list, todo_list)
+				call_netdevice_notifiers(NETDEV_UNREGISTER, dev);
 
 			__rtnl_unlock();
 			rcu_barrier();
 			rtnl_lock();
 
-			if (test_bit(__LINK_STATE_LINKWATCH_PENDING,
-				     &dev->state)) {
-				/* We must not have linkwatch events
-				 * pending on unregister. If this
-				 * happens, we simply run the queue
-				 * unscheduled, resulting in a noop
-				 * for this device.
-				 */
-				linkwatch_run_queue();
-			}
+			list_for_each_entry(dev, list, todo_list)
+				if (test_bit(__LINK_STATE_LINKWATCH_PENDING,
+					     &dev->state)) {
+					/* We must not have linkwatch events
+					 * pending on unregister. If this
+					 * happens, we simply run the queue
+					 * unscheduled, resulting in a noop
+					 * for this device.
+					 */
+					linkwatch_run_queue();
+					break;
+				}
 
 			__rtnl_unlock();
 
@@ -9867,14 +9875,18 @@ static void netdev_wait_allrefs(struct net_device *dev)
 			wait = min(wait << 1, WAIT_REFS_MAX_MSECS);
 		}
 
-		refcnt = netdev_refcnt_read(dev);
+		list_for_each_entry(dev, list, todo_list)
+			if (netdev_refcnt_read(dev) == 1)
+				return dev;
 
-		if (refcnt != 1 &&
-		    time_after(jiffies, warning_time +
+		if (time_after(jiffies, warning_time +
 			       netdev_unregister_timeout_secs * HZ)) {
-			pr_emerg("unregister_netdevice: waiting for %s to become free. Usage count = %d\n",
-				 dev->name, refcnt);
-			ref_tracker_dir_print(&dev->refcnt_tracker, 10);
+			list_for_each_entry(dev, list, todo_list) {
+				pr_emerg("unregister_netdevice: waiting for %s to become free. Usage count = %d\n",
+					 dev->name, netdev_refcnt_read(dev));
+				ref_tracker_dir_print(&dev->refcnt_tracker, 10);
+			}
+
 			warning_time = jiffies;
 		}
 	}
@@ -9942,11 +9954,9 @@ void netdev_run_todo(void)
 	}
 
 	while (!list_empty(&list)) {
-		dev = list_first_entry(&list, struct net_device, todo_list);
+		dev = netdev_wait_allrefs_any(&list);
 		list_del(&dev->todo_list);
 
-		netdev_wait_allrefs(dev);
-
 		/* paranoia */
 		BUG_ON(netdev_refcnt_read(dev) != 1);
 		BUG_ON(!list_empty(&dev->ptype_all));
-- 
2.34.1

