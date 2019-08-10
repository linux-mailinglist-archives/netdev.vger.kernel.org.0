Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A386388A98
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 12:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbfHJKRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 06:17:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbfHJKRv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Aug 2019 06:17:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2374D20B7C;
        Sat, 10 Aug 2019 10:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565432270;
        bh=4JqN3jWAXz09YeqxlYxXimJrwjzfobWefS8qprG7tJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zv5sOOhLEKw+t/mrUQMyyL9Vt/ta5yH6DNVL8uKQMbNG5OwGpWRvnFrp+DJvWt7sh
         ispSOMUkM1yYWUfSrQjCdBglWXy5x+BN8abWgu99G40i+pVqj4iUVij7efauCa3Q90
         BkA0REOZFlopyw1O4hVlWci7dzWFfxsFoTEii1CI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH v3 12/17] skge: no need to check return value of debugfs_create functions
Date:   Sat, 10 Aug 2019 12:17:27 +0200
Message-Id: <20190810101732.26612-13-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190810101732.26612-1-gregkh@linuxfoundation.org>
References: <20190810101732.26612-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Cc: Mirko Lindner <mlindner@marvell.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/skge.c | 39 +++++++----------------------
 1 file changed, 9 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index 06dffee81e02..0a2ec387a482 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -3731,7 +3731,6 @@ static int skge_device_event(struct notifier_block *unused,
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct skge_port *skge;
-	struct dentry *d;
 
 	if (dev->netdev_ops->ndo_open != &skge_up || !skge_debug)
 		goto done;
@@ -3739,33 +3738,20 @@ static int skge_device_event(struct notifier_block *unused,
 	skge = netdev_priv(dev);
 	switch (event) {
 	case NETDEV_CHANGENAME:
-		if (skge->debugfs) {
-			d = debugfs_rename(skge_debug, skge->debugfs,
-					   skge_debug, dev->name);
-			if (d)
-				skge->debugfs = d;
-			else {
-				netdev_info(dev, "rename failed\n");
-				debugfs_remove(skge->debugfs);
-			}
-		}
+		if (skge->debugfs)
+			skge->debugfs = debugfs_rename(skge_debug,
+						       skge->debugfs,
+						       skge_debug, dev->name);
 		break;
 
 	case NETDEV_GOING_DOWN:
-		if (skge->debugfs) {
-			debugfs_remove(skge->debugfs);
-			skge->debugfs = NULL;
-		}
+		debugfs_remove(skge->debugfs);
+		skge->debugfs = NULL;
 		break;
 
 	case NETDEV_UP:
-		d = debugfs_create_file(dev->name, 0444,
-					skge_debug, dev,
-					&skge_debug_fops);
-		if (!d || IS_ERR(d))
-			netdev_info(dev, "debugfs create failed\n");
-		else
-			skge->debugfs = d;
+		skge->debugfs = debugfs_create_file(dev->name, 0444, skge_debug,
+						    dev, &skge_debug_fops);
 		break;
 	}
 
@@ -3780,15 +3766,8 @@ static struct notifier_block skge_notifier = {
 
 static __init void skge_debug_init(void)
 {
-	struct dentry *ent;
-
-	ent = debugfs_create_dir("skge", NULL);
-	if (!ent || IS_ERR(ent)) {
-		pr_info("debugfs create directory failed\n");
-		return;
-	}
+	skge_debug = debugfs_create_dir("skge", NULL);
 
-	skge_debug = ent;
 	register_netdevice_notifier(&skge_notifier);
 }
 
-- 
2.22.0

