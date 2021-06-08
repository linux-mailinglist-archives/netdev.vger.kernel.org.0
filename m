Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F59339FAF0
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 17:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbhFHPhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 11:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233033AbhFHPhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 11:37:25 -0400
Received: from simonwunderlich.de (packetmixer.de [IPv6:2001:4d88:2000:24::c0de])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF3DC061789
        for <netdev@vger.kernel.org>; Tue,  8 Jun 2021 08:35:32 -0700 (PDT)
Received: from kero.packetmixer.de (p200300c5970dd3e020a52263b5aabfb3.dip0.t-ipconnect.de [IPv6:2003:c5:970d:d3e0:20a5:2263:b5aa:bfb3])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 077F4174059;
        Tue,  8 Jun 2021 17:27:05 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 09/11] batman-adv: Avoid name based attaching of hard interfaces
Date:   Tue,  8 Jun 2021 17:26:58 +0200
Message-Id: <20210608152700.30315-10-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210608152700.30315-1-sw@simonwunderlich.de>
References: <20210608152700.30315-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

The sysfs code for the batman-adv/mesh_iface file was receiving a string of
the batadv interface. This interface name was then provided to the code
which shared sysfs+rtnetlink code for attaching an hard-interface to an
batadv interface. The rtnetlink code was also using the (extracted)
interface name from the ndo_add_slave callback to increase the shared code
- even when it would have been more efficient to use the provided
net_device object directly instead of searching it again (based on its
name) in batadv_hardif_enable_interface.

But this indirect handling is no longer necessary because the sysfs code
was dropped. There is now only a single code path which is using
batadv_hardif_enable_interface.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/hard-interface.c | 14 ++++----------
 net/batman-adv/hard-interface.h |  3 +--
 net/batman-adv/soft-interface.c |  3 +--
 3 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index a638f35598f0..81d201cc343d 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -705,16 +705,15 @@ static int batadv_master_del_slave(struct batadv_hard_iface *slave,
 /**
  * batadv_hardif_enable_interface() - Enslave hard interface to soft interface
  * @hard_iface: hard interface to add to soft interface
- * @net: the applicable net namespace
- * @iface_name: name of the soft interface
+ * @soft_iface: netdev struct of the mesh interface
  *
  * Return: 0 on success or negative error number in case of failure
  */
 int batadv_hardif_enable_interface(struct batadv_hard_iface *hard_iface,
-				   struct net *net, const char *iface_name)
+				   struct net_device *soft_iface)
 {
 	struct batadv_priv *bat_priv;
-	struct net_device *soft_iface, *master;
+	struct net_device *master;
 	__be16 ethertype = htons(ETH_P_BATMAN);
 	int max_header_len = batadv_max_header_len();
 	int ret;
@@ -724,11 +723,7 @@ int batadv_hardif_enable_interface(struct batadv_hard_iface *hard_iface,
 
 	kref_get(&hard_iface->refcount);
 
-	soft_iface = dev_get_by_name(net, iface_name);
-	if (!soft_iface) {
-		ret = -EINVAL;
-		goto err;
-	}
+	dev_hold(soft_iface);
 
 	if (!batadv_softif_is_valid(soft_iface)) {
 		pr_err("Can't create batman mesh interface %s: already exists as regular interface\n",
@@ -802,7 +797,6 @@ int batadv_hardif_enable_interface(struct batadv_hard_iface *hard_iface,
 err_dev:
 	hard_iface->soft_iface = NULL;
 	dev_put(soft_iface);
-err:
 	batadv_hardif_put(hard_iface);
 	return ret;
 }
diff --git a/net/batman-adv/hard-interface.h b/net/batman-adv/hard-interface.h
index 83d11b46a9d8..8cb2a1f10080 100644
--- a/net/batman-adv/hard-interface.h
+++ b/net/batman-adv/hard-interface.h
@@ -16,7 +16,6 @@
 #include <linux/rcupdate.h>
 #include <linux/stddef.h>
 #include <linux/types.h>
-#include <net/net_namespace.h>
 
 /**
  * enum batadv_hard_if_state - State of a hard interface
@@ -75,7 +74,7 @@ bool batadv_is_wifi_hardif(struct batadv_hard_iface *hard_iface);
 struct batadv_hard_iface*
 batadv_hardif_get_by_netdev(const struct net_device *net_dev);
 int batadv_hardif_enable_interface(struct batadv_hard_iface *hard_iface,
-				   struct net *net, const char *iface_name);
+				   struct net_device *soft_iface);
 void batadv_hardif_disable_interface(struct batadv_hard_iface *hard_iface);
 int batadv_hardif_min_mtu(struct net_device *soft_iface);
 void batadv_update_min_mtu(struct net_device *soft_iface);
diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index 0c5b34251a6d..ae368a42a4ad 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -842,14 +842,13 @@ static int batadv_softif_slave_add(struct net_device *dev,
 				   struct netlink_ext_ack *extack)
 {
 	struct batadv_hard_iface *hard_iface;
-	struct net *net = dev_net(dev);
 	int ret = -EINVAL;
 
 	hard_iface = batadv_hardif_get_by_netdev(slave_dev);
 	if (!hard_iface || hard_iface->soft_iface)
 		goto out;
 
-	ret = batadv_hardif_enable_interface(hard_iface, net, dev->name);
+	ret = batadv_hardif_enable_interface(hard_iface, dev);
 
 out:
 	if (hard_iface)
-- 
2.20.1

