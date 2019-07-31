Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB4B7CC11
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 20:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730348AbfGaSgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 14:36:48 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39325 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbfGaSgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 14:36:48 -0400
Received: by mail-wm1-f65.google.com with SMTP id u25so50381932wmc.4
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 11:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jvbPu4YBYO12LCpE//3PfLYjJ0yC3CUYvT15uCxwmXA=;
        b=O8kU7Qu9qVR758Jz8QyNZCragqjTNCly5T/5LOi68NsNIfKMKldX0XQQG/FeIDAz7S
         xsGy2BbNE73i9/bDJ8odymQUkhLiuBwTew0dW21QKBqwa7Yq44lfAUD/FkzxXOvdGdaJ
         rpnv2BJHlAF0Pvd7FKY7nlGImGMhVkzZNSeWM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jvbPu4YBYO12LCpE//3PfLYjJ0yC3CUYvT15uCxwmXA=;
        b=no7S2ji6m6fcwDOjI5nks96JX8QDBxD7Z3YRfsxq16VTZBWQsNPaP1OoAKsWOv6x9Y
         zUIVEeZe6JA1UyNklNr4SMIUc4V9UXJXv7ylsdrbL0yLmuwARqtOLfJqL4OGCPY0TwK0
         Dh2OGCrug6ms27LxxhcDlLCtiX0/vhFDruXqEBAXsuicGEZsv6w+d+LC8GFoR1zFr+as
         llQndorKFF6B4QVCbZOBEymt49nbg1JmE0AV7cjRXPbStNOLbKRsLyeJtHovPpSwb3B/
         qW+Nkm2MUnJFOvBKugOqqLukDriMdYZhWrrDNiPeohnqIlhS0SWmZWPh+31AhTGsIbgX
         cejw==
X-Gm-Message-State: APjAAAVDbgE/O5HzIwoK8b+ncrTbsvb+2r98CWmxg/geLX4NJnXwUC5y
        MBBcydGcZ+vnMkrUhBKUNaKzv+S0mZv9tg==
X-Google-Smtp-Source: APXvYqzQLxDV9jTF74wccbrK4ElNxiUfRhoLLD96o6qCfVRVev15yQBNIcXfck3nXFZNnA0MbJ7J+g==
X-Received: by 2002:a1c:c742:: with SMTP id x63mr118261665wmf.0.1564598204358;
        Wed, 31 Jul 2019 11:36:44 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id c11sm117220457wrq.45.2019.07.31.11.36.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 11:36:43 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        michael-dev <michael-dev@fami-braun.de>
Subject: [PATCH net] net: bridge: move vlan init/deinit to NETDEV_REGISTER/UNREGISTER
Date:   Wed, 31 Jul 2019 21:36:23 +0300
Message-Id: <20190731183623.20127-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most of the bridge device's vlan init bugs come from the fact that it's
done in the wrong place, way too early in ndo_init() before the device is
even assigned an ifindex. That makes error handling harder, especially for
older kernels which don't have bridge ndo_uninit callback. It also
introduces another bug when the bridge's dev_addr is added as fdb in the
the initial default pvid on vlan initialization, the fdb notification has
ifindex/NDA_MASTER both equal to 0 (see example below) which really
makes no sense for user-space[0]. Usually user-space software would ignore
such entries, but they are actually valid and will eventually have all
necessary attributes. I chose to change the order because this can be
backported to all kernels even pre-ndo_uninit ones without many changes
and it keeps init/deinit symmetric. As a bonus this allows us to keep
the vlan init/deinit entirely in br_vlan.c and remove those exports.
It makes much more sense to send a notification *after* the device has
registered and has a proper ifindex allocated rather than before when
there's a chance that the registration might still fail.

For the demonstration below a small change to iproute2 for printing all fdb
notifications is added, because it contained a workaround not to show
entries with ifindex == 0.
Command executed while monitoring: $ ip l add br0 type bridge
Before (both ifindex and master == 0):
$ bridge monitor fdb
36:7e:8a:b3:56:ba dev * vlan 1 master * permanent

After (proper br0 ifindex):
$ bridge monitor fdb
e6:2a:ae:7a:b7:48 dev br0 vlan 1 master br0 permanent

[0] https://bugzilla.kernel.org/show_bug.cgi?id=204389

Reported-by: michael-dev <michael-dev@fami-braun.de>
Fixes: 5be5a2df40f0 ("bridge: Add filtering support for default_pvid")
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
I tried a few different approaches to resolve this but they were all
unsuitable for some kernels, this approach can go to stables easily
and IMO is the way this had to be done from the start. Alternatively
we could move only the br_vlan_add and pair it with a br_vlan_del of
default_pvid on the same events, but I don't think it hurts to move
the whole init/deinit there as it'd help older stable releases as well.

I also tested the br_vlan_init error handling after the move by always
returning errors from all over it. Since errors at NETDEV_REGISTER cause
NETDEV_UNREGISTER we can deinit vlans properly for all cases regardless
why it happened (e.g. device destruction or init error).

 net/bridge/br.c         |  5 ++++-
 net/bridge/br_device.c  | 10 ----------
 net/bridge/br_private.h | 19 ++++---------------
 net/bridge/br_vlan.c    | 23 ++++++++++++++++-------
 4 files changed, 24 insertions(+), 33 deletions(-)

diff --git a/net/bridge/br.c b/net/bridge/br.c
index d164f63a4345..8a8f9e5f264f 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -37,12 +37,15 @@ static int br_device_event(struct notifier_block *unused, unsigned long event, v
 	int err;
 
 	if (dev->priv_flags & IFF_EBRIDGE) {
+		err = br_vlan_bridge_event(dev, event, ptr);
+		if (err)
+			return notifier_from_errno(err);
+
 		if (event == NETDEV_REGISTER) {
 			/* register of bridge completed, add sysfs entries */
 			br_sysfs_addbr(dev);
 			return NOTIFY_DONE;
 		}
-		br_vlan_bridge_event(dev, event, ptr);
 	}
 
 	/* not a port of a bridge */
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 681b72862c16..b3e3de2ecf95 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -135,18 +135,9 @@ static int br_dev_init(struct net_device *dev)
 		return err;
 	}
 
-	err = br_vlan_init(br);
-	if (err) {
-		free_percpu(br->stats);
-		br_mdb_hash_fini(br);
-		br_fdb_hash_fini(br);
-		return err;
-	}
-
 	err = br_multicast_init_stats(br);
 	if (err) {
 		free_percpu(br->stats);
-		br_vlan_flush(br);
 		br_mdb_hash_fini(br);
 		br_fdb_hash_fini(br);
 	}
@@ -161,7 +152,6 @@ static void br_dev_uninit(struct net_device *dev)
 
 	br_multicast_dev_del(br);
 	br_multicast_uninit_stats(br);
-	br_vlan_flush(br);
 	br_mdb_hash_fini(br);
 	br_fdb_hash_fini(br);
 	free_percpu(br->stats);
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index e8cf03b43b7d..96dd1c68d73f 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -872,7 +872,6 @@ struct sk_buff *br_handle_vlan(struct net_bridge *br,
 int br_vlan_add(struct net_bridge *br, u16 vid, u16 flags,
 		bool *changed, struct netlink_ext_ack *extack);
 int br_vlan_delete(struct net_bridge *br, u16 vid);
-void br_vlan_flush(struct net_bridge *br);
 struct net_bridge_vlan *br_vlan_find(struct net_bridge_vlan_group *vg, u16 vid);
 void br_recalculate_fwd_mask(struct net_bridge *br);
 int __br_vlan_filter_toggle(struct net_bridge *br, unsigned long val);
@@ -881,7 +880,6 @@ int __br_vlan_set_proto(struct net_bridge *br, __be16 proto);
 int br_vlan_set_proto(struct net_bridge *br, unsigned long val);
 int br_vlan_set_stats(struct net_bridge *br, unsigned long val);
 int br_vlan_set_stats_per_port(struct net_bridge *br, unsigned long val);
-int br_vlan_init(struct net_bridge *br);
 int br_vlan_set_default_pvid(struct net_bridge *br, unsigned long val);
 int __br_vlan_set_default_pvid(struct net_bridge *br, u16 pvid,
 			       struct netlink_ext_ack *extack);
@@ -894,8 +892,8 @@ int nbp_get_num_vlan_infos(struct net_bridge_port *p, u32 filter_mask);
 void br_vlan_get_stats(const struct net_bridge_vlan *v,
 		       struct br_vlan_stats *stats);
 void br_vlan_port_event(struct net_bridge_port *p, unsigned long event);
-void br_vlan_bridge_event(struct net_device *dev, unsigned long event,
-			  void *ptr);
+int br_vlan_bridge_event(struct net_device *dev, unsigned long event,
+			 void *ptr);
 
 static inline struct net_bridge_vlan_group *br_vlan_group(
 					const struct net_bridge *br)
@@ -988,19 +986,10 @@ static inline int br_vlan_delete(struct net_bridge *br, u16 vid)
 	return -EOPNOTSUPP;
 }
 
-static inline void br_vlan_flush(struct net_bridge *br)
-{
-}
-
 static inline void br_recalculate_fwd_mask(struct net_bridge *br)
 {
 }
 
-static inline int br_vlan_init(struct net_bridge *br)
-{
-	return 0;
-}
-
 static inline int nbp_vlan_add(struct net_bridge_port *port, u16 vid, u16 flags,
 			       bool *changed, struct netlink_ext_ack *extack)
 {
@@ -1085,8 +1074,8 @@ static inline void br_vlan_port_event(struct net_bridge_port *p,
 {
 }
 
-static inline void br_vlan_bridge_event(struct net_device *dev,
-					unsigned long event, void *ptr)
+static inline int br_vlan_bridge_event(struct net_device *dev,
+				       unsigned long event, void *ptr)
 {
 }
 #endif
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index a544e161c7fa..266c1214b9f9 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -709,7 +709,7 @@ int br_vlan_delete(struct net_bridge *br, u16 vid)
 	return __vlan_del(v);
 }
 
-void br_vlan_flush(struct net_bridge *br)
+static void br_vlan_flush(struct net_bridge *br)
 {
 	struct net_bridge_vlan_group *vg;
 
@@ -721,6 +721,8 @@ void br_vlan_flush(struct net_bridge *br)
 	br_fdb_delete_by_port(br, NULL, 0, 1);
 
 	vg = br_vlan_group(br);
+	if (!vg)
+		return;
 	__vlan_flush(vg);
 	RCU_INIT_POINTER(br->vlgrp, NULL);
 	synchronize_rcu();
@@ -1054,7 +1056,7 @@ int br_vlan_set_default_pvid(struct net_bridge *br, unsigned long val)
 	return err;
 }
 
-int br_vlan_init(struct net_bridge *br)
+static int br_vlan_init(struct net_bridge *br)
 {
 	struct net_bridge_vlan_group *vg;
 	int ret = -ENOMEM;
@@ -1469,13 +1471,19 @@ static void nbp_vlan_set_vlan_dev_state(struct net_bridge_port *p, u16 vid)
 }
 
 /* Must be protected by RTNL. */
-void br_vlan_bridge_event(struct net_device *dev, unsigned long event,
-			  void *ptr)
+int br_vlan_bridge_event(struct net_device *dev, unsigned long event, void *ptr)
 {
 	struct netdev_notifier_changeupper_info *info;
-	struct net_bridge *br;
+	struct net_bridge *br = netdev_priv(dev);
+	int ret = 0;
 
 	switch (event) {
+	case NETDEV_REGISTER:
+		ret = br_vlan_init(br);
+		break;
+	case NETDEV_UNREGISTER:
+		br_vlan_flush(br);
+		break;
 	case NETDEV_CHANGEUPPER:
 		info = ptr;
 		br_vlan_upper_change(dev, info->upper_dev, info->linking);
@@ -1483,12 +1491,13 @@ void br_vlan_bridge_event(struct net_device *dev, unsigned long event,
 
 	case NETDEV_CHANGE:
 	case NETDEV_UP:
-		br = netdev_priv(dev);
 		if (!br_opt_get(br, BROPT_VLAN_BRIDGE_BINDING))
-			return;
+			break;
 		br_vlan_link_state_change(dev, br);
 		break;
 	}
+
+	return ret;
 }
 
 /* Must be protected by RTNL. */
-- 
2.21.0

