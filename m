Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF5E425792
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 18:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242683AbhJGQTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 12:19:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242596AbhJGQSv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 12:18:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4DB96105A;
        Thu,  7 Oct 2021 16:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633623417;
        bh=Fb3G46eVZSaqJ/73u+jZiUnK+uT23FPtztNo6bYR00U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AUftzbAyJuUai2SjIIXo1q915/vX8LBB0w/V3lGuGB5zLgKEIw4rpirQCOFECrxap
         BdB0POrzQ9Qw36+yIfG84RHDq+W55y16ilF43AmNlroK+2VWZuwjG0L+x2fMP0UERo
         /DyUvgy67rE6o3Vs7vFIZlAGajB3q/Rqk8WfiiOjDg1WEB8Fj5gTKxWk+Hz3BLbpiW
         4L+2V7MCTXmX2LIvARqsUSpIXz1jglAL/ghNT+bJ6G3zmp4b2XTpkSE/DMWFc9C/B2
         0ADv4Qi+jcdDzEFezC6jOMX9tlwmOHukzDAwqRcM6FH4trfnrU984FaPL+RR9YqC5+
         fSeG03RKYI2Jw==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, pabeni@redhat.com,
        juri.lelli@redhat.com, netdev@vger.kernel.org
Subject: [PATCH net-next 1/3] net: introduce a function to check if a netdev name is in use
Date:   Thu,  7 Oct 2021 18:16:50 +0200
Message-Id: <20211007161652.374597-2-atenart@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007161652.374597-1-atenart@kernel.org>
References: <20211007161652.374597-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__dev_get_by_name is currently used to either retrieve a net device
reference using its name or to check if a name is already used by a
registered net device (per ns). In the later case there is no need to
return a reference to a net device.

Introduce a new helper, netdev_name_in_use, to check if a name is
currently used by a registered net device without leaking a reference
the corresponding net device. This helper uses netdev_name_node_lookup
instead of __dev_get_by_name as we don't need the extra logic retrieving
a reference to the corresponding net device.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 include/linux/netdevice.h |  1 +
 net/core/dev.c            | 14 ++++++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d79163208dfd..15f4a658e436 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2955,6 +2955,7 @@ struct net_device *__dev_get_by_flags(struct net *net, unsigned short flags,
 struct net_device *dev_get_by_name(struct net *net, const char *name);
 struct net_device *dev_get_by_name_rcu(struct net *net, const char *name);
 struct net_device *__dev_get_by_name(struct net *net, const char *name);
+bool netdev_name_in_use(struct net *net, const char *name);
 int dev_alloc_name(struct net_device *dev, const char *name);
 int dev_open(struct net_device *dev, struct netlink_ext_ack *extack);
 void dev_close(struct net_device *dev);
diff --git a/net/core/dev.c b/net/core/dev.c
index 16ab09b6a7f8..1594cd2955ba 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -303,6 +303,12 @@ static struct netdev_name_node *netdev_name_node_lookup_rcu(struct net *net,
 	return NULL;
 }
 
+bool netdev_name_in_use(struct net *net, const char *name)
+{
+	return netdev_name_node_lookup(net, name);
+}
+EXPORT_SYMBOL(netdev_name_in_use);
+
 int netdev_name_node_alt_create(struct net_device *dev, const char *name)
 {
 	struct netdev_name_node *name_node;
@@ -1133,7 +1139,7 @@ static int __dev_alloc_name(struct net *net, const char *name, char *buf)
 	}
 
 	snprintf(buf, IFNAMSIZ, name, i);
-	if (!__dev_get_by_name(net, buf))
+	if (!netdev_name_in_use(net, buf))
 		return i;
 
 	/* It is possible to run out of possible slots
@@ -1187,7 +1193,7 @@ static int dev_get_valid_name(struct net *net, struct net_device *dev,
 
 	if (strchr(name, '%'))
 		return dev_alloc_name_ns(net, dev, name);
-	else if (__dev_get_by_name(net, name))
+	else if (netdev_name_in_use(net, name))
 		return -EEXIST;
 	else if (dev->name != name)
 		strlcpy(dev->name, name, IFNAMSIZ);
@@ -11153,7 +11159,7 @@ int __dev_change_net_namespace(struct net_device *dev, struct net *net,
 	 * we can use it in the destination network namespace.
 	 */
 	err = -EEXIST;
-	if (__dev_get_by_name(net, dev->name)) {
+	if (netdev_name_in_use(net, dev->name)) {
 		/* We get here if we can't use the current device name */
 		if (!pat)
 			goto out;
@@ -11506,7 +11512,7 @@ static void __net_exit default_device_exit(struct net *net)
 
 		/* Push remaining network devices to init_net */
 		snprintf(fb_name, IFNAMSIZ, "dev%d", dev->ifindex);
-		if (__dev_get_by_name(&init_net, fb_name))
+		if (netdev_name_in_use(&init_net, fb_name))
 			snprintf(fb_name, IFNAMSIZ, "dev%%d");
 		err = dev_change_net_namespace(dev, &init_net, fb_name);
 		if (err) {
-- 
2.31.1

