Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED9E57D188
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 00:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730357AbfGaWuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 18:50:04 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54811 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbfGaWuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 18:50:03 -0400
Received: by mail-wm1-f67.google.com with SMTP id p74so62507024wme.4
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 15:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7rZvCO4ZmAhxIfLUsoEIkm6/Qbd7PgUWPdUq8MpSb58=;
        b=KPxtkcT7EEPGW6GWd4SUl7Wg34IWxlS/Ve3iQ3+WHUxYD2BBRPuWb0CaCxVD2uVtqb
         hRugHNsOO+MYqPmF1isHI+CF2PBChBUXp071sIy26EJY0d5bY57lJpDRLq9U1dGEYKLQ
         5BBVjZCCu3t7ebGpg/0LusPzcXgjWK1CLK25M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7rZvCO4ZmAhxIfLUsoEIkm6/Qbd7PgUWPdUq8MpSb58=;
        b=ubUtKCxE1O/Zm/fROpnKwjYjZgYb2qBLSmozvoPFdLhoDPyVXQ2KiQcxwUqjLYz7Hg
         vhnedANjjyAgEU+3NNgqYzNUQKAPLpbDLuSa5v9v8kFL2xeSZNT/oTdv0Qh7EQXR64oA
         fPnQ3O8f3hvJMTPunkaCBeCvEekuBkVCIFciFsX1GmVFLbucRFkWunJmQrfjmobntzKf
         BvjaiwbgP0WPuyjou1QHVZQAVuDOuo6P+gfAaQa/Bgcsf7P3gSgBJ9gTbK3j0oOFR4B+
         HgXgflCNHLSmgPJE2njpltklf0UzFHYfLnqczsojAhxN60e0dVV4cScDo9x2QlLtOHPr
         9lbw==
X-Gm-Message-State: APjAAAXWNt5hCwW4V3KN8JTxpiHs9C2GfrcWoPMIDMjjuXyBRjOB3TPW
        zVZ/Zx4iwGVFOE2/X4AOPtl3MV62yHOzFg==
X-Google-Smtp-Source: APXvYqzAA2yT/1+CmLKBimMtyhXlLCv4VLYO/Fmw+RDjEDQMzE+Wkmd5/+q5ZFuAW6LyqByQafuKuw==
X-Received: by 2002:a7b:c051:: with SMTP id u17mr110203011wmc.25.1564613400265;
        Wed, 31 Jul 2019 15:50:00 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id p12sm51550286wrt.13.2019.07.31.15.49.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 15:49:59 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        michael-dev <michael-dev@fami-braun.de>
Subject: [PATCH net v3] net: bridge: move vlan init/deinit to NETDEV_REGISTER/UNREGISTER
Date:   Thu,  1 Aug 2019 01:49:55 +0300
Message-Id: <20190731224955.10908-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <319fda43-195d-2b92-7f62-7e273c084a29@cumulusnetworks.com>
References: <319fda43-195d-2b92-7f62-7e273c084a29@cumulusnetworks.com>
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

v3: send the correct v2 patch with all changes (stub should return 0)
v2: on error in br_vlan_init set br->vlgrp to NULL and return 0 in
    the br_vlan_bridge_event stub when bridge vlans are disabled

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
 net/bridge/br_private.h | 20 +++++---------------
 net/bridge/br_vlan.c    | 25 ++++++++++++++++++-------
 4 files changed, 27 insertions(+), 33 deletions(-)

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
index e8cf03b43b7d..782f18c6b2a9 100644
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
@@ -1085,9 +1074,10 @@ static inline void br_vlan_port_event(struct net_bridge_port *p,
 {
 }
 
-static inline void br_vlan_bridge_event(struct net_device *dev,
-					unsigned long event, void *ptr)
+static inline int br_vlan_bridge_event(struct net_device *dev,
+				       unsigned long event, void *ptr)
 {
+	return 0;
 }
 #endif
 
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index a544e161c7fa..6a17408b4eb8 100644
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
@@ -1083,6 +1085,8 @@ int br_vlan_init(struct net_bridge *br)
 	return ret;
 
 err_vlan_add:
+	RCU_INIT_POINTER(br->vlgrp, NULL);
+	synchronize_rcu();
 	vlan_tunnel_deinit(vg);
 err_tunnel_init:
 	rhashtable_destroy(&vg->vlan_hash);
@@ -1469,13 +1473,19 @@ static void nbp_vlan_set_vlan_dev_state(struct net_bridge_port *p, u16 vid)
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
@@ -1483,12 +1493,13 @@ void br_vlan_bridge_event(struct net_device *dev, unsigned long event,
 
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

