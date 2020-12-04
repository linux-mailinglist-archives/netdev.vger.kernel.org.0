Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24AA92CF106
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 16:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730682AbgLDPr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 10:47:29 -0500
Received: from simonwunderlich.de ([79.140.42.25]:33450 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730627AbgLDPr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 10:47:28 -0500
Received: from kero.packetmixer.de (p200300c59716c1e0c1b6a3b925be22c4.dip0.t-ipconnect.de [IPv6:2003:c5:9716:c1e0:c1b6:a3b9:25be:22c4])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id E8EE4174064;
        Fri,  4 Dec 2020 16:46:34 +0100 (CET)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 5/8] batman-adv: Drop deprecated sysfs support
Date:   Fri,  4 Dec 2020 16:46:28 +0100
Message-Id: <20201204154631.21063-6-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201204154631.21063-1-sw@simonwunderlich.de>
References: <20201204154631.21063-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

The sysfs in batman-adv support was marked as deprecated by the commit
42cdd521487f ("batman-adv: ABI: Mark sysfs files as deprecated") and
scheduled for removal in 2021.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 .../ABI/obsolete/sysfs-class-net-batman-adv   |   32 -
 .../ABI/obsolete/sysfs-class-net-mesh         |  110 --
 MAINTAINERS                                   |    2 -
 net/batman-adv/Kconfig                        |   11 -
 net/batman-adv/Makefile                       |    1 -
 net/batman-adv/bat_v.c                        |    9 -
 net/batman-adv/hard-interface.c               |   16 +-
 net/batman-adv/hard-interface.h               |    6 -
 net/batman-adv/soft-interface.c               |   52 -
 net/batman-adv/soft-interface.h               |    1 -
 net/batman-adv/sysfs.c                        | 1272 -----------------
 net/batman-adv/sysfs.h                        |   93 --
 net/batman-adv/types.h                        |   30 -
 13 files changed, 1 insertion(+), 1634 deletions(-)
 delete mode 100644 Documentation/ABI/obsolete/sysfs-class-net-batman-adv
 delete mode 100644 Documentation/ABI/obsolete/sysfs-class-net-mesh
 delete mode 100644 net/batman-adv/sysfs.c
 delete mode 100644 net/batman-adv/sysfs.h

diff --git a/Documentation/ABI/obsolete/sysfs-class-net-batman-adv b/Documentation/ABI/obsolete/sysfs-class-net-batman-adv
deleted file mode 100644
index 5bdbc8d40256..000000000000
--- a/Documentation/ABI/obsolete/sysfs-class-net-batman-adv
+++ /dev/null
@@ -1,32 +0,0 @@
-This ABI is deprecated and will be removed after 2021. It is
-replaced with the batadv generic netlink family.
-
-What:           /sys/class/net/<iface>/batman-adv/elp_interval
-Date:           Feb 2014
-Contact:        Linus Lüssing <linus.luessing@web.de>
-Description:
-                Defines the interval in milliseconds in which batman
-                emits probing packets for neighbor sensing (ELP).
-
-What:           /sys/class/net/<iface>/batman-adv/iface_status
-Date:           May 2010
-Contact:        Marek Lindner <mareklindner@neomailbox.ch>
-Description:
-                Indicates the status of <iface> as it is seen by batman.
-
-What:           /sys/class/net/<iface>/batman-adv/mesh_iface
-Date:           May 2010
-Contact:        Marek Lindner <mareklindner@neomailbox.ch>
-Description:
-                The /sys/class/net/<iface>/batman-adv/mesh_iface file
-                displays the batman mesh interface this <iface>
-                currently is associated with.
-
-What:           /sys/class/net/<iface>/batman-adv/throughput_override
-Date:           Feb 2014
-Contact:        Antonio Quartulli <a@unstable.cc>
-description:
-                Defines the throughput value to be used by B.A.T.M.A.N. V
-                when estimating the link throughput using this interface.
-                If the value is set to 0 then batman-adv will try to
-                estimate the throughput by itself.
diff --git a/Documentation/ABI/obsolete/sysfs-class-net-mesh b/Documentation/ABI/obsolete/sysfs-class-net-mesh
deleted file mode 100644
index 04c1a2932507..000000000000
--- a/Documentation/ABI/obsolete/sysfs-class-net-mesh
+++ /dev/null
@@ -1,110 +0,0 @@
-This ABI is deprecated and will be removed after 2021. It is
-replaced with the batadv generic netlink family.
-
-What:           /sys/class/net/<mesh_iface>/mesh/aggregated_ogms
-Date:           May 2010
-Contact:        Marek Lindner <mareklindner@neomailbox.ch>
-Description:
-                Indicates whether the batman protocol messages of the
-                mesh <mesh_iface> shall be aggregated or not.
-
-What:           /sys/class/net/<mesh_iface>/mesh/<vlan_subdir>/ap_isolation
-Date:           May 2011
-Contact:        Antonio Quartulli <a@unstable.cc>
-Description:
-                Indicates whether the data traffic going from a
-                wireless client to another wireless client will be
-                silently dropped. <vlan_subdir> is empty when referring
-		to the untagged lan.
-
-What:           /sys/class/net/<mesh_iface>/mesh/bonding
-Date:           June 2010
-Contact:        Simon Wunderlich <sw@simonwunderlich.de>
-Description:
-                Indicates whether the data traffic going through the
-                mesh will be sent using multiple interfaces at the
-                same time (if available).
-
-What:           /sys/class/net/<mesh_iface>/mesh/bridge_loop_avoidance
-Date:           November 2011
-Contact:        Simon Wunderlich <sw@simonwunderlich.de>
-Description:
-                Indicates whether the bridge loop avoidance feature
-                is enabled. This feature detects and avoids loops
-                between the mesh and devices bridged with the soft
-                interface <mesh_iface>.
-
-What:           /sys/class/net/<mesh_iface>/mesh/fragmentation
-Date:           October 2010
-Contact:        Andreas Langer <an.langer@gmx.de>
-Description:
-                Indicates whether the data traffic going through the
-                mesh will be fragmented or silently discarded if the
-                packet size exceeds the outgoing interface MTU.
-
-What:           /sys/class/net/<mesh_iface>/mesh/gw_bandwidth
-Date:           October 2010
-Contact:        Marek Lindner <mareklindner@neomailbox.ch>
-Description:
-                Defines the bandwidth which is propagated by this
-                node if gw_mode was set to 'server'.
-
-What:           /sys/class/net/<mesh_iface>/mesh/gw_mode
-Date:           October 2010
-Contact:        Marek Lindner <mareklindner@neomailbox.ch>
-Description:
-                Defines the state of the gateway features. Can be
-                either 'off', 'client' or 'server'.
-
-What:           /sys/class/net/<mesh_iface>/mesh/gw_sel_class
-Date:           October 2010
-Contact:        Marek Lindner <mareklindner@neomailbox.ch>
-Description:
-                Defines the selection criteria this node will use
-                to choose a gateway if gw_mode was set to 'client'.
-
-What:           /sys/class/net/<mesh_iface>/mesh/hop_penalty
-Date:           Oct 2010
-Contact:        Linus Lüssing <linus.luessing@web.de>
-Description:
-                Defines the penalty which will be applied to an
-                originator message's tq-field on every hop.
-
-What:		/sys/class/net/<mesh_iface>/mesh/isolation_mark
-Date:		Nov 2013
-Contact:	Antonio Quartulli <a@unstable.cc>
-Description:
-		Defines the isolation mark (and its bitmask) which
-		is used to classify clients as "isolated" by the
-		Extended Isolation feature.
-
-What:           /sys/class/net/<mesh_iface>/mesh/multicast_mode
-Date:           Feb 2014
-Contact:        Linus Lüssing <linus.luessing@web.de>
-Description:
-                Indicates whether multicast optimizations are enabled
-                or disabled. If set to zero then all nodes in the
-                mesh are going to use classic flooding for any
-                multicast packet with no optimizations.
-
-What:           /sys/class/net/<mesh_iface>/mesh/network_coding
-Date:           Nov 2012
-Contact:        Martin Hundeboll <martin@hundeboll.net>
-Description:
-                Controls whether Network Coding (using some magic
-                to send fewer wifi packets but still the same
-                content) is enabled or not.
-
-What:           /sys/class/net/<mesh_iface>/mesh/orig_interval
-Date:           May 2010
-Contact:        Marek Lindner <mareklindner@neomailbox.ch>
-Description:
-                Defines the interval in milliseconds in which batman
-                sends its protocol messages.
-
-What:           /sys/class/net/<mesh_iface>/mesh/routing_algo
-Date:           Dec 2011
-Contact:        Marek Lindner <mareklindner@neomailbox.ch>
-Description:
-                Defines the routing procotol this mesh instance
-                uses to find the optimal paths through the mesh.
diff --git a/MAINTAINERS b/MAINTAINERS
index 3da6d8c154e4..c381ab27b05e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3120,8 +3120,6 @@ Q:	https://patchwork.open-mesh.org/project/batman/list/
 B:	https://www.open-mesh.org/projects/batman-adv/issues
 C:	irc://chat.freenode.net/batman
 T:	git https://git.open-mesh.org/linux-merge.git
-F:	Documentation/ABI/obsolete/sysfs-class-net-batman-adv
-F:	Documentation/ABI/obsolete/sysfs-class-net-mesh
 F:	Documentation/networking/batman-adv.rst
 F:	include/uapi/linux/batadv_packet.h
 F:	include/uapi/linux/batman_adv.h
diff --git a/net/batman-adv/Kconfig b/net/batman-adv/Kconfig
index c762758a4649..84bbf72b764e 100644
--- a/net/batman-adv/Kconfig
+++ b/net/batman-adv/Kconfig
@@ -97,17 +97,6 @@ config BATMAN_ADV_DEBUG
 	  buffer. The output is controlled via the batadv netdev specific
 	  log_level setting.
 
-config BATMAN_ADV_SYSFS
-	bool "batman-adv sysfs entries"
-	depends on BATMAN_ADV
-	help
-	  Say Y here if you want to enable batman-adv device configuration and
-	  status interface through sysfs attributes. It is replaced by the
-	  batadv generic netlink family but still used by various userspace
-	  tools and scripts.
-
-	  If unsure, say Y.
-
 config BATMAN_ADV_TRACING
 	bool "B.A.T.M.A.N. tracing support"
 	depends on BATMAN_ADV
diff --git a/net/batman-adv/Makefile b/net/batman-adv/Makefile
index daa49af7ff40..306615caba6c 100644
--- a/net/batman-adv/Makefile
+++ b/net/batman-adv/Makefile
@@ -28,7 +28,6 @@ batman-adv-y += originator.o
 batman-adv-y += routing.o
 batman-adv-y += send.o
 batman-adv-y += soft-interface.o
-batman-adv-$(CONFIG_BATMAN_ADV_SYSFS) += sysfs.o
 batman-adv-$(CONFIG_BATMAN_ADV_TRACING) += trace.o
 batman-adv-y += tp_meter.o
 batman-adv-y += translation-table.o
diff --git a/net/batman-adv/bat_v.c b/net/batman-adv/bat_v.c
index e91d2c0720c4..ee7a95aa7bd4 100644
--- a/net/batman-adv/bat_v.c
+++ b/net/batman-adv/bat_v.c
@@ -13,7 +13,6 @@
 #include <linux/if_ether.h>
 #include <linux/init.h>
 #include <linux/jiffies.h>
-#include <linux/kernel.h>
 #include <linux/kref.h>
 #include <linux/list.h>
 #include <linux/minmax.h>
@@ -686,13 +685,6 @@ static ssize_t batadv_v_store_sel_class(struct batadv_priv *bat_priv,
 	return count;
 }
 
-static ssize_t batadv_v_show_sel_class(struct batadv_priv *bat_priv, char *buff)
-{
-	u32 class = atomic_read(&bat_priv->gw.sel_class);
-
-	return sprintf(buff, "%u.%u MBit\n", class / 10, class % 10);
-}
-
 /**
  * batadv_v_gw_throughput_get() - retrieve the GW-bandwidth for a given GW
  * @gw_node: the GW to retrieve the metric for
@@ -1061,7 +1053,6 @@ static struct batadv_algo_ops batadv_batman_v __read_mostly = {
 	.gw = {
 		.init_sel_class = batadv_v_init_sel_class,
 		.store_sel_class = batadv_v_store_sel_class,
-		.show_sel_class = batadv_v_show_sel_class,
 		.get_best_gw_node = batadv_v_gw_get_best_gw_node,
 		.is_eligible = batadv_v_gw_is_eligible,
 #ifdef CONFIG_BATMAN_ADV_DEBUGFS
diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index 3838a6165c5e..6f827a6be4ed 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -39,7 +39,6 @@
 #include "originator.h"
 #include "send.h"
 #include "soft-interface.h"
-#include "sysfs.h"
 #include "translation-table.h"
 
 /**
@@ -889,13 +888,9 @@ void batadv_hardif_disable_interface(struct batadv_hard_iface *hard_iface,
 	batadv_hardif_recalc_extra_skbroom(hard_iface->soft_iface);
 
 	/* nobody uses this interface anymore */
-	if (batadv_hardif_cnt(hard_iface->soft_iface) <= 1) {
+	if (batadv_hardif_cnt(hard_iface->soft_iface) <= 1)
 		batadv_gw_check_client_stop(bat_priv);
 
-		if (autodel == BATADV_IF_CLEANUP_AUTO)
-			batadv_softif_destroy_sysfs(hard_iface->soft_iface);
-	}
-
 	hard_iface->soft_iface = NULL;
 	batadv_hardif_put(hard_iface);
 
@@ -908,7 +903,6 @@ static struct batadv_hard_iface *
 batadv_hardif_add_interface(struct net_device *net_dev)
 {
 	struct batadv_hard_iface *hard_iface;
-	int ret;
 
 	ASSERT_RTNL();
 
@@ -921,10 +915,6 @@ batadv_hardif_add_interface(struct net_device *net_dev)
 	if (!hard_iface)
 		goto release_dev;
 
-	ret = batadv_sysfs_add_hardif(&hard_iface->hardif_obj, net_dev);
-	if (ret)
-		goto free_if;
-
 	hard_iface->net_dev = net_dev;
 	hard_iface->soft_iface = NULL;
 	hard_iface->if_status = BATADV_IF_NOT_IN_USE;
@@ -954,8 +944,6 @@ batadv_hardif_add_interface(struct net_device *net_dev)
 
 	return hard_iface;
 
-free_if:
-	kfree(hard_iface);
 release_dev:
 	dev_put(net_dev);
 out:
@@ -976,7 +964,6 @@ static void batadv_hardif_remove_interface(struct batadv_hard_iface *hard_iface)
 
 	hard_iface->if_status = BATADV_IF_TO_BE_REMOVED;
 	batadv_debugfs_del_hardif(hard_iface);
-	batadv_sysfs_del_hardif(&hard_iface->hardif_obj);
 	batadv_hardif_put(hard_iface);
 }
 
@@ -994,7 +981,6 @@ static int batadv_hard_if_event_softif(unsigned long event,
 
 	switch (event) {
 	case NETDEV_REGISTER:
-		batadv_sysfs_add_meshif(net_dev);
 		bat_priv = netdev_priv(net_dev);
 		batadv_softif_create_vlan(bat_priv, BATADV_NO_FLAGS);
 		break;
diff --git a/net/batman-adv/hard-interface.h b/net/batman-adv/hard-interface.h
index b1855d9d0b06..1ee45b615399 100644
--- a/net/batman-adv/hard-interface.h
+++ b/net/batman-adv/hard-interface.h
@@ -42,12 +42,6 @@ enum batadv_hard_if_state {
 
 	/** @BATADV_IF_TO_BE_ACTIVATED: interface is getting activated */
 	BATADV_IF_TO_BE_ACTIVATED,
-
-	/**
-	 * @BATADV_IF_I_WANT_YOU: interface is queued up (using sysfs) for being
-	 * added as slave interface of a batman-adv soft interface
-	 */
-	BATADV_IF_I_WANT_YOU,
 };
 
 /**
diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index 8116631c11c5..072b76259bf7 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -30,7 +30,6 @@
 #include <linux/random.h>
 #include <linux/rculist.h>
 #include <linux/rcupdate.h>
-#include <linux/rtnetlink.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
 #include <linux/socket.h>
@@ -52,7 +51,6 @@
 #include "network-coding.h"
 #include "originator.h"
 #include "send.h"
-#include "sysfs.h"
 #include "translation-table.h"
 
 /**
@@ -575,7 +573,6 @@ struct batadv_softif_vlan *batadv_softif_vlan_get(struct batadv_priv *bat_priv,
 int batadv_softif_create_vlan(struct batadv_priv *bat_priv, unsigned short vid)
 {
 	struct batadv_softif_vlan *vlan;
-	int err;
 
 	spin_lock_bh(&bat_priv->softif_vlan_list_lock);
 
@@ -602,19 +599,6 @@ int batadv_softif_create_vlan(struct batadv_priv *bat_priv, unsigned short vid)
 	hlist_add_head_rcu(&vlan->list, &bat_priv->softif_vlan_list);
 	spin_unlock_bh(&bat_priv->softif_vlan_list_lock);
 
-	/* batadv_sysfs_add_vlan cannot be in the spinlock section due to the
-	 * sleeping behavior of the sysfs functions and the fs_reclaim lock
-	 */
-	err = batadv_sysfs_add_vlan(bat_priv->soft_iface, vlan);
-	if (err) {
-		/* ref for the function */
-		batadv_softif_vlan_put(vlan);
-
-		/* ref for the list */
-		batadv_softif_vlan_put(vlan);
-		return err;
-	}
-
 	/* add a new TT local entry. This one will be marked with the NOPURGE
 	 * flag
 	 */
@@ -642,7 +626,6 @@ static void batadv_softif_destroy_vlan(struct batadv_priv *bat_priv,
 	batadv_tt_local_remove(bat_priv, bat_priv->soft_iface->dev_addr,
 			       vlan->vid, "vlan interface destroyed", false);
 
-	batadv_sysfs_del_vlan(bat_priv, vlan);
 	batadv_softif_vlan_put(vlan);
 }
 
@@ -662,7 +645,6 @@ static int batadv_interface_add_vid(struct net_device *dev, __be16 proto,
 {
 	struct batadv_priv *bat_priv = netdev_priv(dev);
 	struct batadv_softif_vlan *vlan;
-	int ret;
 
 	/* only 802.1Q vlans are supported.
 	 * batman-adv does not know how to handle other types
@@ -682,17 +664,6 @@ static int batadv_interface_add_vid(struct net_device *dev, __be16 proto,
 	if (!vlan)
 		return batadv_softif_create_vlan(bat_priv, vid);
 
-	/* recreate the sysfs object if it was already destroyed (and it should
-	 * be since we received a kill_vid() for this vlan
-	 */
-	if (!vlan->kobj) {
-		ret = batadv_sysfs_add_vlan(bat_priv->soft_iface, vlan);
-		if (ret) {
-			batadv_softif_vlan_put(vlan);
-			return ret;
-		}
-	}
-
 	/* add a new TT local entry. This one will be marked with the NOPURGE
 	 * flag. This must be added again, even if the vlan object already
 	 * exists, because the entry was deleted by kill_vid()
@@ -1161,28 +1132,6 @@ struct net_device *batadv_softif_create(struct net *net, const char *name)
 	return soft_iface;
 }
 
-/**
- * batadv_softif_destroy_sysfs() - deletion of batadv_soft_interface via sysfs
- * @soft_iface: the to-be-removed batman-adv interface
- */
-void batadv_softif_destroy_sysfs(struct net_device *soft_iface)
-{
-	struct batadv_priv *bat_priv = netdev_priv(soft_iface);
-	struct batadv_softif_vlan *vlan;
-
-	ASSERT_RTNL();
-
-	/* destroy the "untagged" VLAN */
-	vlan = batadv_softif_vlan_get(bat_priv, BATADV_NO_FLAGS);
-	if (vlan) {
-		batadv_softif_destroy_vlan(bat_priv, vlan);
-		batadv_softif_vlan_put(vlan);
-	}
-
-	batadv_sysfs_del_meshif(soft_iface);
-	unregister_netdevice(soft_iface);
-}
-
 /**
  * batadv_softif_destroy_netlink() - deletion of batadv_soft_interface via
  *  netlink
@@ -1209,7 +1158,6 @@ static void batadv_softif_destroy_netlink(struct net_device *soft_iface,
 		batadv_softif_vlan_put(vlan);
 	}
 
-	batadv_sysfs_del_meshif(soft_iface);
 	unregister_netdevice_queue(soft_iface, head);
 }
 
diff --git a/net/batman-adv/soft-interface.h b/net/batman-adv/soft-interface.h
index 534e08d6ad91..74716d9ca4f6 100644
--- a/net/batman-adv/soft-interface.h
+++ b/net/batman-adv/soft-interface.h
@@ -20,7 +20,6 @@ void batadv_interface_rx(struct net_device *soft_iface,
 			 struct sk_buff *skb, int hdr_size,
 			 struct batadv_orig_node *orig_node);
 struct net_device *batadv_softif_create(struct net *net, const char *name);
-void batadv_softif_destroy_sysfs(struct net_device *soft_iface);
 bool batadv_softif_is_valid(const struct net_device *net_dev);
 extern struct rtnl_link_ops batadv_link_ops;
 int batadv_softif_create_vlan(struct batadv_priv *bat_priv, unsigned short vid);
diff --git a/net/batman-adv/sysfs.c b/net/batman-adv/sysfs.c
deleted file mode 100644
index 0f962dcd239e..000000000000
--- a/net/batman-adv/sysfs.c
+++ /dev/null
@@ -1,1272 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2010-2020  B.A.T.M.A.N. contributors:
- *
- * Marek Lindner
- */
-
-#include "sysfs.h"
-#include "main.h"
-
-#include <asm/current.h>
-#include <linux/atomic.h>
-#include <linux/compiler.h>
-#include <linux/device.h>
-#include <linux/errno.h>
-#include <linux/gfp.h>
-#include <linux/if.h>
-#include <linux/if_vlan.h>
-#include <linux/kernel.h>
-#include <linux/kobject.h>
-#include <linux/kref.h>
-#include <linux/limits.h>
-#include <linux/netdevice.h>
-#include <linux/printk.h>
-#include <linux/rculist.h>
-#include <linux/rcupdate.h>
-#include <linux/rtnetlink.h>
-#include <linux/sched.h>
-#include <linux/slab.h>
-#include <linux/stddef.h>
-#include <linux/string.h>
-#include <linux/stringify.h>
-#include <linux/workqueue.h>
-#include <uapi/linux/batadv_packet.h>
-#include <uapi/linux/batman_adv.h>
-
-#include "bridge_loop_avoidance.h"
-#include "distributed-arp-table.h"
-#include "gateway_client.h"
-#include "gateway_common.h"
-#include "hard-interface.h"
-#include "log.h"
-#include "netlink.h"
-#include "network-coding.h"
-#include "soft-interface.h"
-
-/**
- * batadv_sysfs_deprecated() - Log use of deprecated batadv sysfs access
- * @attr: attribute which was accessed
- */
-static void batadv_sysfs_deprecated(struct attribute *attr)
-{
-	pr_warn_ratelimited(DEPRECATED "%s (pid %d) Use of sysfs file \"%s\".\nUse batadv genl family instead",
-			    current->comm, task_pid_nr(current), attr->name);
-}
-
-static struct net_device *batadv_kobj_to_netdev(struct kobject *obj)
-{
-	struct device *dev = container_of(obj->parent, struct device, kobj);
-
-	return to_net_dev(dev);
-}
-
-static struct batadv_priv *batadv_kobj_to_batpriv(struct kobject *obj)
-{
-	struct net_device *net_dev = batadv_kobj_to_netdev(obj);
-
-	return netdev_priv(net_dev);
-}
-
-/**
- * batadv_vlan_kobj_to_batpriv() - convert a vlan kobj in the associated batpriv
- * @obj: kobject to covert
- *
- * Return: the associated batadv_priv struct.
- */
-static struct batadv_priv *batadv_vlan_kobj_to_batpriv(struct kobject *obj)
-{
-	/* VLAN specific attributes are located in the root sysfs folder if they
-	 * refer to the untagged VLAN..
-	 */
-	if (!strcmp(BATADV_SYSFS_IF_MESH_SUBDIR, obj->name))
-		return batadv_kobj_to_batpriv(obj);
-
-	/* ..while the attributes for the tagged vlans are located in
-	 * the in the corresponding "vlan%VID" subfolder
-	 */
-	return batadv_kobj_to_batpriv(obj->parent);
-}
-
-/**
- * batadv_kobj_to_vlan() - convert a kobj in the associated softif_vlan struct
- * @bat_priv: the bat priv with all the soft interface information
- * @obj: kobject to covert
- *
- * Return: the associated softif_vlan struct if found, NULL otherwise.
- */
-static struct batadv_softif_vlan *
-batadv_kobj_to_vlan(struct batadv_priv *bat_priv, struct kobject *obj)
-{
-	struct batadv_softif_vlan *vlan_tmp, *vlan = NULL;
-
-	rcu_read_lock();
-	hlist_for_each_entry_rcu(vlan_tmp, &bat_priv->softif_vlan_list, list) {
-		if (vlan_tmp->kobj != obj)
-			continue;
-
-		if (!kref_get_unless_zero(&vlan_tmp->refcount))
-			continue;
-
-		vlan = vlan_tmp;
-		break;
-	}
-	rcu_read_unlock();
-
-	return vlan;
-}
-
-/* Use this, if you have customized show and store functions for vlan attrs */
-#define BATADV_ATTR_VLAN(_name, _mode, _show, _store)	\
-struct batadv_attribute batadv_attr_vlan_##_name = {	\
-	.attr = {.name = __stringify(_name),		\
-		 .mode = _mode },			\
-	.show   = _show,				\
-	.store  = _store,				\
-}
-
-/* Use this, if you have customized show and store functions */
-#define BATADV_ATTR(_name, _mode, _show, _store)	\
-struct batadv_attribute batadv_attr_##_name = {		\
-	.attr = {.name = __stringify(_name),		\
-		 .mode = _mode },			\
-	.show   = _show,				\
-	.store  = _store,				\
-}
-
-#define BATADV_ATTR_SIF_STORE_BOOL(_name, _post_func)			\
-ssize_t batadv_store_##_name(struct kobject *kobj,			\
-			     struct attribute *attr, char *buff,	\
-			     size_t count)				\
-{									\
-	struct net_device *net_dev = batadv_kobj_to_netdev(kobj);	\
-	struct batadv_priv *bat_priv = netdev_priv(net_dev);		\
-	ssize_t length;							\
-									\
-	batadv_sysfs_deprecated(attr);					\
-	length = __batadv_store_bool_attr(buff, count, _post_func, attr,\
-					  &bat_priv->_name, net_dev);	\
-									\
-	batadv_netlink_notify_mesh(bat_priv);				\
-									\
-	return length;							\
-}
-
-#define BATADV_ATTR_SIF_SHOW_BOOL(_name)				\
-ssize_t batadv_show_##_name(struct kobject *kobj,			\
-			    struct attribute *attr, char *buff)		\
-{									\
-	struct batadv_priv *bat_priv = batadv_kobj_to_batpriv(kobj);	\
-									\
-	batadv_sysfs_deprecated(attr);					\
-	return sprintf(buff, "%s\n",					\
-		       atomic_read(&bat_priv->_name) == 0 ?		\
-		       "disabled" : "enabled");				\
-}									\
-
-/* Use this, if you are going to turn a [name] in the soft-interface
- * (bat_priv) on or off
- */
-#define BATADV_ATTR_SIF_BOOL(_name, _mode, _post_func)			\
-	static BATADV_ATTR_SIF_STORE_BOOL(_name, _post_func)		\
-	static BATADV_ATTR_SIF_SHOW_BOOL(_name)				\
-	static BATADV_ATTR(_name, _mode, batadv_show_##_name,		\
-			   batadv_store_##_name)
-
-#define BATADV_ATTR_SIF_STORE_UINT(_name, _var, _min, _max, _post_func)	\
-ssize_t batadv_store_##_name(struct kobject *kobj,			\
-			     struct attribute *attr, char *buff,	\
-			     size_t count)				\
-{									\
-	struct net_device *net_dev = batadv_kobj_to_netdev(kobj);	\
-	struct batadv_priv *bat_priv = netdev_priv(net_dev);		\
-	ssize_t length;							\
-									\
-	batadv_sysfs_deprecated(attr);					\
-	length = __batadv_store_uint_attr(buff, count, _min, _max,	\
-					  _post_func, attr,		\
-					  &bat_priv->_var, net_dev,	\
-					  NULL);			\
-									\
-	batadv_netlink_notify_mesh(bat_priv);				\
-									\
-	return length;							\
-}
-
-#define BATADV_ATTR_SIF_SHOW_UINT(_name, _var)				\
-ssize_t batadv_show_##_name(struct kobject *kobj,			\
-			    struct attribute *attr, char *buff)		\
-{									\
-	struct batadv_priv *bat_priv = batadv_kobj_to_batpriv(kobj);	\
-									\
-	batadv_sysfs_deprecated(attr);					\
-	return sprintf(buff, "%i\n", atomic_read(&bat_priv->_var));	\
-}									\
-
-/* Use this, if you are going to set [name] in the soft-interface
- * (bat_priv) to an unsigned integer value
- */
-#define BATADV_ATTR_SIF_UINT(_name, _var, _mode, _min, _max, _post_func)\
-	static BATADV_ATTR_SIF_STORE_UINT(_name, _var, _min, _max, _post_func)\
-	static BATADV_ATTR_SIF_SHOW_UINT(_name, _var)			\
-	static BATADV_ATTR(_name, _mode, batadv_show_##_name,		\
-			   batadv_store_##_name)
-
-#define BATADV_ATTR_VLAN_STORE_BOOL(_name, _post_func)			\
-ssize_t batadv_store_vlan_##_name(struct kobject *kobj,			\
-				  struct attribute *attr, char *buff,	\
-				  size_t count)				\
-{									\
-	struct batadv_priv *bat_priv = batadv_vlan_kobj_to_batpriv(kobj);\
-	struct batadv_softif_vlan *vlan = batadv_kobj_to_vlan(bat_priv,	\
-							      kobj);	\
-	size_t res = __batadv_store_bool_attr(buff, count, _post_func,	\
-					      attr, &vlan->_name,	\
-					      bat_priv->soft_iface);	\
-									\
-	batadv_sysfs_deprecated(attr);					\
-	if (vlan->vid)							\
-		batadv_netlink_notify_vlan(bat_priv, vlan);		\
-	else								\
-		batadv_netlink_notify_mesh(bat_priv);			\
-									\
-	batadv_softif_vlan_put(vlan);					\
-	return res;							\
-}
-
-#define BATADV_ATTR_VLAN_SHOW_BOOL(_name)				\
-ssize_t batadv_show_vlan_##_name(struct kobject *kobj,			\
-				 struct attribute *attr, char *buff)	\
-{									\
-	struct batadv_priv *bat_priv = batadv_vlan_kobj_to_batpriv(kobj);\
-	struct batadv_softif_vlan *vlan = batadv_kobj_to_vlan(bat_priv,	\
-							      kobj);	\
-	size_t res = sprintf(buff, "%s\n",				\
-			     atomic_read(&vlan->_name) == 0 ?		\
-			     "disabled" : "enabled");			\
-									\
-	batadv_sysfs_deprecated(attr);					\
-	batadv_softif_vlan_put(vlan);					\
-	return res;							\
-}
-
-/* Use this, if you are going to turn a [name] in the vlan struct on or off */
-#define BATADV_ATTR_VLAN_BOOL(_name, _mode, _post_func)			\
-	static BATADV_ATTR_VLAN_STORE_BOOL(_name, _post_func)		\
-	static BATADV_ATTR_VLAN_SHOW_BOOL(_name)			\
-	static BATADV_ATTR_VLAN(_name, _mode, batadv_show_vlan_##_name,	\
-				batadv_store_vlan_##_name)
-
-#define BATADV_ATTR_HIF_STORE_UINT(_name, _var, _min, _max, _post_func)	\
-ssize_t batadv_store_##_name(struct kobject *kobj,			\
-			     struct attribute *attr, char *buff,	\
-			     size_t count)				\
-{									\
-	struct net_device *net_dev = batadv_kobj_to_netdev(kobj);	\
-	struct batadv_hard_iface *hard_iface;				\
-	struct batadv_priv *bat_priv;					\
-	ssize_t length;							\
-									\
-	batadv_sysfs_deprecated(attr);					\
-	hard_iface = batadv_hardif_get_by_netdev(net_dev);		\
-	if (!hard_iface)						\
-		return 0;						\
-									\
-	length = __batadv_store_uint_attr(buff, count, _min, _max,	\
-					  _post_func, attr,		\
-					  &hard_iface->_var,		\
-					  hard_iface->soft_iface,	\
-					  net_dev);			\
-									\
-	if (hard_iface->soft_iface) {					\
-		bat_priv = netdev_priv(hard_iface->soft_iface);		\
-		batadv_netlink_notify_hardif(bat_priv, hard_iface);	\
-	}								\
-									\
-	batadv_hardif_put(hard_iface);				\
-	return length;							\
-}
-
-#define BATADV_ATTR_HIF_SHOW_UINT(_name, _var)				\
-ssize_t batadv_show_##_name(struct kobject *kobj,			\
-			    struct attribute *attr, char *buff)		\
-{									\
-	struct net_device *net_dev = batadv_kobj_to_netdev(kobj);	\
-	struct batadv_hard_iface *hard_iface;				\
-	ssize_t length;							\
-									\
-	batadv_sysfs_deprecated(attr);					\
-	hard_iface = batadv_hardif_get_by_netdev(net_dev);		\
-	if (!hard_iface)						\
-		return 0;						\
-									\
-	length = sprintf(buff, "%i\n", atomic_read(&hard_iface->_var));	\
-									\
-	batadv_hardif_put(hard_iface);				\
-	return length;							\
-}
-
-/* Use this, if you are going to set [name] in hard_iface to an
- * unsigned integer value
- */
-#define BATADV_ATTR_HIF_UINT(_name, _var, _mode, _min, _max, _post_func)\
-	static BATADV_ATTR_HIF_STORE_UINT(_name, _var, _min,		\
-					  _max, _post_func)		\
-	static BATADV_ATTR_HIF_SHOW_UINT(_name, _var)			\
-	static BATADV_ATTR(_name, _mode, batadv_show_##_name,		\
-			   batadv_store_##_name)
-
-static int batadv_store_bool_attr(char *buff, size_t count,
-				  struct net_device *net_dev,
-				  const char *attr_name, atomic_t *attr,
-				  bool *changed)
-{
-	int enabled = -1;
-
-	*changed = false;
-
-	if (buff[count - 1] == '\n')
-		buff[count - 1] = '\0';
-
-	if ((strncmp(buff, "1", 2) == 0) ||
-	    (strncmp(buff, "enable", 7) == 0) ||
-	    (strncmp(buff, "enabled", 8) == 0))
-		enabled = 1;
-
-	if ((strncmp(buff, "0", 2) == 0) ||
-	    (strncmp(buff, "disable", 8) == 0) ||
-	    (strncmp(buff, "disabled", 9) == 0))
-		enabled = 0;
-
-	if (enabled < 0) {
-		batadv_info(net_dev, "%s: Invalid parameter received: %s\n",
-			    attr_name, buff);
-		return -EINVAL;
-	}
-
-	if (atomic_read(attr) == enabled)
-		return count;
-
-	batadv_info(net_dev, "%s: Changing from: %s to: %s\n", attr_name,
-		    atomic_read(attr) == 1 ? "enabled" : "disabled",
-		    enabled == 1 ? "enabled" : "disabled");
-
-	*changed = true;
-
-	atomic_set(attr, (unsigned int)enabled);
-	return count;
-}
-
-static inline ssize_t
-__batadv_store_bool_attr(char *buff, size_t count,
-			 void (*post_func)(struct net_device *),
-			 struct attribute *attr,
-			 atomic_t *attr_store, struct net_device *net_dev)
-{
-	bool changed;
-	int ret;
-
-	ret = batadv_store_bool_attr(buff, count, net_dev, attr->name,
-				     attr_store, &changed);
-	if (post_func && changed)
-		post_func(net_dev);
-
-	return ret;
-}
-
-static int batadv_store_uint_attr(const char *buff, size_t count,
-				  struct net_device *net_dev,
-				  struct net_device *slave_dev,
-				  const char *attr_name,
-				  unsigned int min, unsigned int max,
-				  atomic_t *attr)
-{
-	char ifname[IFNAMSIZ + 3] = "";
-	unsigned long uint_val;
-	int ret;
-
-	ret = kstrtoul(buff, 10, &uint_val);
-	if (ret) {
-		batadv_info(net_dev, "%s: Invalid parameter received: %s\n",
-			    attr_name, buff);
-		return -EINVAL;
-	}
-
-	if (uint_val < min) {
-		batadv_info(net_dev, "%s: Value is too small: %lu min: %u\n",
-			    attr_name, uint_val, min);
-		return -EINVAL;
-	}
-
-	if (uint_val > max) {
-		batadv_info(net_dev, "%s: Value is too big: %lu max: %u\n",
-			    attr_name, uint_val, max);
-		return -EINVAL;
-	}
-
-	if (atomic_read(attr) == uint_val)
-		return count;
-
-	if (slave_dev)
-		snprintf(ifname, sizeof(ifname), "%s: ", slave_dev->name);
-
-	batadv_info(net_dev, "%s: %sChanging from: %i to: %lu\n",
-		    attr_name, ifname, atomic_read(attr), uint_val);
-
-	atomic_set(attr, uint_val);
-	return count;
-}
-
-static ssize_t __batadv_store_uint_attr(const char *buff, size_t count,
-					int min, int max,
-					void (*post_func)(struct net_device *),
-					const struct attribute *attr,
-					atomic_t *attr_store,
-					struct net_device *net_dev,
-					struct net_device *slave_dev)
-{
-	int ret;
-
-	ret = batadv_store_uint_attr(buff, count, net_dev, slave_dev,
-				     attr->name, min, max, attr_store);
-	if (post_func && ret)
-		post_func(net_dev);
-
-	return ret;
-}
-
-static ssize_t batadv_show_bat_algo(struct kobject *kobj,
-				    struct attribute *attr, char *buff)
-{
-	struct batadv_priv *bat_priv = batadv_kobj_to_batpriv(kobj);
-
-	batadv_sysfs_deprecated(attr);
-	return sprintf(buff, "%s\n", bat_priv->algo_ops->name);
-}
-
-static void batadv_post_gw_reselect(struct net_device *net_dev)
-{
-	struct batadv_priv *bat_priv = netdev_priv(net_dev);
-
-	batadv_gw_reselect(bat_priv);
-}
-
-static ssize_t batadv_show_gw_mode(struct kobject *kobj, struct attribute *attr,
-				   char *buff)
-{
-	struct batadv_priv *bat_priv = batadv_kobj_to_batpriv(kobj);
-	int bytes_written;
-
-	batadv_sysfs_deprecated(attr);
-
-	/* GW mode is not available if the routing algorithm in use does not
-	 * implement the GW API
-	 */
-	if (!bat_priv->algo_ops->gw.get_best_gw_node ||
-	    !bat_priv->algo_ops->gw.is_eligible)
-		return -ENOENT;
-
-	switch (atomic_read(&bat_priv->gw.mode)) {
-	case BATADV_GW_MODE_CLIENT:
-		bytes_written = sprintf(buff, "%s\n",
-					BATADV_GW_MODE_CLIENT_NAME);
-		break;
-	case BATADV_GW_MODE_SERVER:
-		bytes_written = sprintf(buff, "%s\n",
-					BATADV_GW_MODE_SERVER_NAME);
-		break;
-	default:
-		bytes_written = sprintf(buff, "%s\n",
-					BATADV_GW_MODE_OFF_NAME);
-		break;
-	}
-
-	return bytes_written;
-}
-
-static ssize_t batadv_store_gw_mode(struct kobject *kobj,
-				    struct attribute *attr, char *buff,
-				    size_t count)
-{
-	struct net_device *net_dev = batadv_kobj_to_netdev(kobj);
-	struct batadv_priv *bat_priv = netdev_priv(net_dev);
-	char *curr_gw_mode_str;
-	int gw_mode_tmp = -1;
-
-	batadv_sysfs_deprecated(attr);
-
-	/* toggling GW mode is allowed only if the routing algorithm in use
-	 * provides the GW API
-	 */
-	if (!bat_priv->algo_ops->gw.get_best_gw_node ||
-	    !bat_priv->algo_ops->gw.is_eligible)
-		return -EINVAL;
-
-	if (buff[count - 1] == '\n')
-		buff[count - 1] = '\0';
-
-	if (strncmp(buff, BATADV_GW_MODE_OFF_NAME,
-		    strlen(BATADV_GW_MODE_OFF_NAME)) == 0)
-		gw_mode_tmp = BATADV_GW_MODE_OFF;
-
-	if (strncmp(buff, BATADV_GW_MODE_CLIENT_NAME,
-		    strlen(BATADV_GW_MODE_CLIENT_NAME)) == 0)
-		gw_mode_tmp = BATADV_GW_MODE_CLIENT;
-
-	if (strncmp(buff, BATADV_GW_MODE_SERVER_NAME,
-		    strlen(BATADV_GW_MODE_SERVER_NAME)) == 0)
-		gw_mode_tmp = BATADV_GW_MODE_SERVER;
-
-	if (gw_mode_tmp < 0) {
-		batadv_info(net_dev,
-			    "Invalid parameter for 'gw mode' setting received: %s\n",
-			    buff);
-		return -EINVAL;
-	}
-
-	if (atomic_read(&bat_priv->gw.mode) == gw_mode_tmp)
-		return count;
-
-	switch (atomic_read(&bat_priv->gw.mode)) {
-	case BATADV_GW_MODE_CLIENT:
-		curr_gw_mode_str = BATADV_GW_MODE_CLIENT_NAME;
-		break;
-	case BATADV_GW_MODE_SERVER:
-		curr_gw_mode_str = BATADV_GW_MODE_SERVER_NAME;
-		break;
-	default:
-		curr_gw_mode_str = BATADV_GW_MODE_OFF_NAME;
-		break;
-	}
-
-	batadv_info(net_dev, "Changing gw mode from: %s to: %s\n",
-		    curr_gw_mode_str, buff);
-
-	/* Invoking batadv_gw_reselect() is not enough to really de-select the
-	 * current GW. It will only instruct the gateway client code to perform
-	 * a re-election the next time that this is needed.
-	 *
-	 * When gw client mode is being switched off the current GW must be
-	 * de-selected explicitly otherwise no GW_ADD uevent is thrown on
-	 * client mode re-activation. This is operation is performed in
-	 * batadv_gw_check_client_stop().
-	 */
-	batadv_gw_reselect(bat_priv);
-	/* always call batadv_gw_check_client_stop() before changing the gateway
-	 * state
-	 */
-	batadv_gw_check_client_stop(bat_priv);
-	atomic_set(&bat_priv->gw.mode, (unsigned int)gw_mode_tmp);
-	batadv_gw_tvlv_container_update(bat_priv);
-
-	batadv_netlink_notify_mesh(bat_priv);
-
-	return count;
-}
-
-static ssize_t batadv_show_gw_sel_class(struct kobject *kobj,
-					struct attribute *attr, char *buff)
-{
-	struct batadv_priv *bat_priv = batadv_kobj_to_batpriv(kobj);
-
-	batadv_sysfs_deprecated(attr);
-
-	/* GW selection class is not available if the routing algorithm in use
-	 * does not implement the GW API
-	 */
-	if (!bat_priv->algo_ops->gw.get_best_gw_node ||
-	    !bat_priv->algo_ops->gw.is_eligible)
-		return -ENOENT;
-
-	if (bat_priv->algo_ops->gw.show_sel_class)
-		return bat_priv->algo_ops->gw.show_sel_class(bat_priv, buff);
-
-	return sprintf(buff, "%i\n", atomic_read(&bat_priv->gw.sel_class));
-}
-
-static ssize_t batadv_store_gw_sel_class(struct kobject *kobj,
-					 struct attribute *attr, char *buff,
-					 size_t count)
-{
-	struct batadv_priv *bat_priv = batadv_kobj_to_batpriv(kobj);
-	ssize_t length;
-
-	batadv_sysfs_deprecated(attr);
-
-	/* setting the GW selection class is allowed only if the routing
-	 * algorithm in use implements the GW API
-	 */
-	if (!bat_priv->algo_ops->gw.get_best_gw_node ||
-	    !bat_priv->algo_ops->gw.is_eligible)
-		return -EINVAL;
-
-	if (buff[count - 1] == '\n')
-		buff[count - 1] = '\0';
-
-	if (bat_priv->algo_ops->gw.store_sel_class)
-		return bat_priv->algo_ops->gw.store_sel_class(bat_priv, buff,
-							      count);
-
-	length = __batadv_store_uint_attr(buff, count, 1, BATADV_TQ_MAX_VALUE,
-					  batadv_post_gw_reselect, attr,
-					  &bat_priv->gw.sel_class,
-					  bat_priv->soft_iface, NULL);
-
-	batadv_netlink_notify_mesh(bat_priv);
-
-	return length;
-}
-
-static ssize_t batadv_show_gw_bwidth(struct kobject *kobj,
-				     struct attribute *attr, char *buff)
-{
-	struct batadv_priv *bat_priv = batadv_kobj_to_batpriv(kobj);
-	u32 down, up;
-
-	batadv_sysfs_deprecated(attr);
-
-	down = atomic_read(&bat_priv->gw.bandwidth_down);
-	up = atomic_read(&bat_priv->gw.bandwidth_up);
-
-	return sprintf(buff, "%u.%u/%u.%u MBit\n", down / 10,
-		       down % 10, up / 10, up % 10);
-}
-
-static ssize_t batadv_store_gw_bwidth(struct kobject *kobj,
-				      struct attribute *attr, char *buff,
-				      size_t count)
-{
-	struct batadv_priv *bat_priv = batadv_kobj_to_batpriv(kobj);
-	struct net_device *net_dev = batadv_kobj_to_netdev(kobj);
-	ssize_t length;
-
-	batadv_sysfs_deprecated(attr);
-
-	if (buff[count - 1] == '\n')
-		buff[count - 1] = '\0';
-
-	length = batadv_gw_bandwidth_set(net_dev, buff, count);
-
-	batadv_netlink_notify_mesh(bat_priv);
-
-	return length;
-}
-
-/**
- * batadv_show_isolation_mark() - print the current isolation mark/mask
- * @kobj: kobject representing the private mesh sysfs directory
- * @attr: the batman-adv attribute the user is interacting with
- * @buff: the buffer that will contain the data to send back to the user
- *
- * Return: the number of bytes written into 'buff' on success or a negative
- * error code in case of failure
- */
-static ssize_t batadv_show_isolation_mark(struct kobject *kobj,
-					  struct attribute *attr, char *buff)
-{
-	struct batadv_priv *bat_priv = batadv_kobj_to_batpriv(kobj);
-
-	batadv_sysfs_deprecated(attr);
-	return sprintf(buff, "%#.8x/%#.8x\n", bat_priv->isolation_mark,
-		       bat_priv->isolation_mark_mask);
-}
-
-/**
- * batadv_store_isolation_mark() - parse and store the isolation mark/mask
- *  entered by the user
- * @kobj: kobject representing the private mesh sysfs directory
- * @attr: the batman-adv attribute the user is interacting with
- * @buff: the buffer containing the user data
- * @count: number of bytes in the buffer
- *
- * Return: 'count' on success or a negative error code in case of failure
- */
-static ssize_t batadv_store_isolation_mark(struct kobject *kobj,
-					   struct attribute *attr, char *buff,
-					   size_t count)
-{
-	struct net_device *net_dev = batadv_kobj_to_netdev(kobj);
-	struct batadv_priv *bat_priv = netdev_priv(net_dev);
-	u32 mark, mask;
-	char *mask_ptr;
-
-	batadv_sysfs_deprecated(attr);
-
-	/* parse the mask if it has been specified, otherwise assume the mask is
-	 * the biggest possible
-	 */
-	mask = 0xFFFFFFFF;
-	mask_ptr = strchr(buff, '/');
-	if (mask_ptr) {
-		*mask_ptr = '\0';
-		mask_ptr++;
-
-		/* the mask must be entered in hex base as it is going to be a
-		 * bitmask and not a prefix length
-		 */
-		if (kstrtou32(mask_ptr, 16, &mask) < 0)
-			return -EINVAL;
-	}
-
-	/* the mark can be entered in any base */
-	if (kstrtou32(buff, 0, &mark) < 0)
-		return -EINVAL;
-
-	bat_priv->isolation_mark_mask = mask;
-	/* erase bits not covered by the mask */
-	bat_priv->isolation_mark = mark & bat_priv->isolation_mark_mask;
-
-	batadv_info(net_dev,
-		    "New skb mark for extended isolation: %#.8x/%#.8x\n",
-		    bat_priv->isolation_mark, bat_priv->isolation_mark_mask);
-
-	batadv_netlink_notify_mesh(bat_priv);
-
-	return count;
-}
-
-BATADV_ATTR_SIF_BOOL(aggregated_ogms, 0644, NULL);
-BATADV_ATTR_SIF_BOOL(bonding, 0644, NULL);
-#ifdef CONFIG_BATMAN_ADV_BLA
-BATADV_ATTR_SIF_BOOL(bridge_loop_avoidance, 0644, batadv_bla_status_update);
-#endif
-#ifdef CONFIG_BATMAN_ADV_DAT
-BATADV_ATTR_SIF_BOOL(distributed_arp_table, 0644, batadv_dat_status_update);
-#endif
-BATADV_ATTR_SIF_BOOL(fragmentation, 0644, batadv_update_min_mtu);
-static BATADV_ATTR(routing_algo, 0444, batadv_show_bat_algo, NULL);
-static BATADV_ATTR(gw_mode, 0644, batadv_show_gw_mode, batadv_store_gw_mode);
-BATADV_ATTR_SIF_UINT(orig_interval, orig_interval, 0644, 2 * BATADV_JITTER,
-		     INT_MAX, NULL);
-BATADV_ATTR_SIF_UINT(hop_penalty, hop_penalty, 0644, 0, BATADV_TQ_MAX_VALUE,
-		     NULL);
-static BATADV_ATTR(gw_sel_class, 0644, batadv_show_gw_sel_class,
-		   batadv_store_gw_sel_class);
-static BATADV_ATTR(gw_bandwidth, 0644, batadv_show_gw_bwidth,
-		   batadv_store_gw_bwidth);
-#ifdef CONFIG_BATMAN_ADV_MCAST
-BATADV_ATTR_SIF_BOOL(multicast_mode, 0644, NULL);
-#endif
-#ifdef CONFIG_BATMAN_ADV_DEBUG
-BATADV_ATTR_SIF_UINT(log_level, log_level, 0644, 0, BATADV_DBG_ALL, NULL);
-#endif
-#ifdef CONFIG_BATMAN_ADV_NC
-BATADV_ATTR_SIF_BOOL(network_coding, 0644, batadv_nc_status_update);
-#endif
-static BATADV_ATTR(isolation_mark, 0644, batadv_show_isolation_mark,
-		   batadv_store_isolation_mark);
-
-static struct batadv_attribute *batadv_mesh_attrs[] = {
-	&batadv_attr_aggregated_ogms,
-	&batadv_attr_bonding,
-#ifdef CONFIG_BATMAN_ADV_BLA
-	&batadv_attr_bridge_loop_avoidance,
-#endif
-#ifdef CONFIG_BATMAN_ADV_DAT
-	&batadv_attr_distributed_arp_table,
-#endif
-#ifdef CONFIG_BATMAN_ADV_MCAST
-	&batadv_attr_multicast_mode,
-#endif
-	&batadv_attr_fragmentation,
-	&batadv_attr_routing_algo,
-	&batadv_attr_gw_mode,
-	&batadv_attr_orig_interval,
-	&batadv_attr_hop_penalty,
-	&batadv_attr_gw_sel_class,
-	&batadv_attr_gw_bandwidth,
-#ifdef CONFIG_BATMAN_ADV_DEBUG
-	&batadv_attr_log_level,
-#endif
-#ifdef CONFIG_BATMAN_ADV_NC
-	&batadv_attr_network_coding,
-#endif
-	&batadv_attr_isolation_mark,
-	NULL,
-};
-
-BATADV_ATTR_VLAN_BOOL(ap_isolation, 0644, NULL);
-
-/* array of vlan specific sysfs attributes */
-static struct batadv_attribute *batadv_vlan_attrs[] = {
-	&batadv_attr_vlan_ap_isolation,
-	NULL,
-};
-
-/**
- * batadv_sysfs_add_meshif() - Add soft interface specific sysfs entries
- * @dev: netdev struct of the soft interface
- *
- * Return: 0 on success or negative error number in case of failure
- */
-int batadv_sysfs_add_meshif(struct net_device *dev)
-{
-	struct kobject *batif_kobject = &dev->dev.kobj;
-	struct batadv_priv *bat_priv = netdev_priv(dev);
-	struct batadv_attribute **bat_attr;
-	int err;
-
-	bat_priv->mesh_obj = kobject_create_and_add(BATADV_SYSFS_IF_MESH_SUBDIR,
-						    batif_kobject);
-	if (!bat_priv->mesh_obj) {
-		batadv_err(dev, "Can't add sysfs directory: %s/%s\n", dev->name,
-			   BATADV_SYSFS_IF_MESH_SUBDIR);
-		goto out;
-	}
-
-	for (bat_attr = batadv_mesh_attrs; *bat_attr; ++bat_attr) {
-		err = sysfs_create_file(bat_priv->mesh_obj,
-					&((*bat_attr)->attr));
-		if (err) {
-			batadv_err(dev, "Can't add sysfs file: %s/%s/%s\n",
-				   dev->name, BATADV_SYSFS_IF_MESH_SUBDIR,
-				   ((*bat_attr)->attr).name);
-			goto rem_attr;
-		}
-	}
-
-	return 0;
-
-rem_attr:
-	for (bat_attr = batadv_mesh_attrs; *bat_attr; ++bat_attr)
-		sysfs_remove_file(bat_priv->mesh_obj, &((*bat_attr)->attr));
-
-	kobject_uevent(bat_priv->mesh_obj, KOBJ_REMOVE);
-	kobject_del(bat_priv->mesh_obj);
-	kobject_put(bat_priv->mesh_obj);
-	bat_priv->mesh_obj = NULL;
-out:
-	return -ENOMEM;
-}
-
-/**
- * batadv_sysfs_del_meshif() - Remove soft interface specific sysfs entries
- * @dev: netdev struct of the soft interface
- */
-void batadv_sysfs_del_meshif(struct net_device *dev)
-{
-	struct batadv_priv *bat_priv = netdev_priv(dev);
-	struct batadv_attribute **bat_attr;
-
-	for (bat_attr = batadv_mesh_attrs; *bat_attr; ++bat_attr)
-		sysfs_remove_file(bat_priv->mesh_obj, &((*bat_attr)->attr));
-
-	kobject_uevent(bat_priv->mesh_obj, KOBJ_REMOVE);
-	kobject_del(bat_priv->mesh_obj);
-	kobject_put(bat_priv->mesh_obj);
-	bat_priv->mesh_obj = NULL;
-}
-
-/**
- * batadv_sysfs_add_vlan() - add all the needed sysfs objects for the new vlan
- * @dev: netdev of the mesh interface
- * @vlan: private data of the newly added VLAN interface
- *
- * Return: 0 on success and -ENOMEM if any of the structure allocations fails.
- */
-int batadv_sysfs_add_vlan(struct net_device *dev,
-			  struct batadv_softif_vlan *vlan)
-{
-	char vlan_subdir[sizeof(BATADV_SYSFS_VLAN_SUBDIR_PREFIX) + 5];
-	struct batadv_priv *bat_priv = netdev_priv(dev);
-	struct batadv_attribute **bat_attr;
-	int err;
-
-	if (vlan->vid & BATADV_VLAN_HAS_TAG) {
-		sprintf(vlan_subdir, BATADV_SYSFS_VLAN_SUBDIR_PREFIX "%hu",
-			vlan->vid & VLAN_VID_MASK);
-
-		vlan->kobj = kobject_create_and_add(vlan_subdir,
-						    bat_priv->mesh_obj);
-		if (!vlan->kobj) {
-			batadv_err(dev, "Can't add sysfs directory: %s/%s\n",
-				   dev->name, vlan_subdir);
-			goto out;
-		}
-	} else {
-		/* the untagged LAN uses the root folder to store its "VLAN
-		 * specific attributes"
-		 */
-		vlan->kobj = bat_priv->mesh_obj;
-		kobject_get(bat_priv->mesh_obj);
-	}
-
-	for (bat_attr = batadv_vlan_attrs; *bat_attr; ++bat_attr) {
-		err = sysfs_create_file(vlan->kobj,
-					&((*bat_attr)->attr));
-		if (err) {
-			batadv_err(dev, "Can't add sysfs file: %s/%s/%s\n",
-				   dev->name, vlan_subdir,
-				   ((*bat_attr)->attr).name);
-			goto rem_attr;
-		}
-	}
-
-	return 0;
-
-rem_attr:
-	for (bat_attr = batadv_vlan_attrs; *bat_attr; ++bat_attr)
-		sysfs_remove_file(vlan->kobj, &((*bat_attr)->attr));
-
-	if (vlan->kobj != bat_priv->mesh_obj) {
-		kobject_uevent(vlan->kobj, KOBJ_REMOVE);
-		kobject_del(vlan->kobj);
-	}
-	kobject_put(vlan->kobj);
-	vlan->kobj = NULL;
-out:
-	return -ENOMEM;
-}
-
-/**
- * batadv_sysfs_del_vlan() - remove all the sysfs objects for a given VLAN
- * @bat_priv: the bat priv with all the soft interface information
- * @vlan: the private data of the VLAN to destroy
- */
-void batadv_sysfs_del_vlan(struct batadv_priv *bat_priv,
-			   struct batadv_softif_vlan *vlan)
-{
-	struct batadv_attribute **bat_attr;
-
-	for (bat_attr = batadv_vlan_attrs; *bat_attr; ++bat_attr)
-		sysfs_remove_file(vlan->kobj, &((*bat_attr)->attr));
-
-	if (vlan->kobj != bat_priv->mesh_obj) {
-		kobject_uevent(vlan->kobj, KOBJ_REMOVE);
-		kobject_del(vlan->kobj);
-	}
-	kobject_put(vlan->kobj);
-	vlan->kobj = NULL;
-}
-
-static ssize_t batadv_show_mesh_iface(struct kobject *kobj,
-				      struct attribute *attr, char *buff)
-{
-	struct net_device *net_dev = batadv_kobj_to_netdev(kobj);
-	struct batadv_hard_iface *hard_iface;
-	ssize_t length;
-	const char *ifname;
-
-	batadv_sysfs_deprecated(attr);
-
-	hard_iface = batadv_hardif_get_by_netdev(net_dev);
-	if (!hard_iface)
-		return 0;
-
-	if (hard_iface->if_status == BATADV_IF_NOT_IN_USE)
-		ifname =  "none";
-	else
-		ifname = hard_iface->soft_iface->name;
-
-	length = sprintf(buff, "%s\n", ifname);
-
-	batadv_hardif_put(hard_iface);
-
-	return length;
-}
-
-/**
- * batadv_store_mesh_iface_finish() - store new hardif mesh_iface state
- * @net_dev: netdevice to add/remove to/from batman-adv soft-interface
- * @ifname: name of soft-interface to modify
- *
- * Changes the parts of the hard+soft interface which can not be modified under
- * sysfs lock (to prevent deadlock situations).
- *
- * Return: 0 on success, 0 < on failure
- */
-static int batadv_store_mesh_iface_finish(struct net_device *net_dev,
-					  char ifname[IFNAMSIZ])
-{
-	struct net *net = dev_net(net_dev);
-	struct batadv_hard_iface *hard_iface;
-	int status_tmp;
-	int ret = 0;
-
-	ASSERT_RTNL();
-
-	hard_iface = batadv_hardif_get_by_netdev(net_dev);
-	if (!hard_iface)
-		return 0;
-
-	if (strncmp(ifname, "none", 4) == 0)
-		status_tmp = BATADV_IF_NOT_IN_USE;
-	else
-		status_tmp = BATADV_IF_I_WANT_YOU;
-
-	if (hard_iface->if_status == status_tmp)
-		goto out;
-
-	if (hard_iface->soft_iface &&
-	    strncmp(hard_iface->soft_iface->name, ifname, IFNAMSIZ) == 0)
-		goto out;
-
-	if (status_tmp == BATADV_IF_NOT_IN_USE) {
-		batadv_hardif_disable_interface(hard_iface,
-						BATADV_IF_CLEANUP_AUTO);
-		goto out;
-	}
-
-	/* if the interface already is in use */
-	if (hard_iface->if_status != BATADV_IF_NOT_IN_USE)
-		batadv_hardif_disable_interface(hard_iface,
-						BATADV_IF_CLEANUP_AUTO);
-
-	ret = batadv_hardif_enable_interface(hard_iface, net, ifname);
-out:
-	batadv_hardif_put(hard_iface);
-	return ret;
-}
-
-/**
- * batadv_store_mesh_iface_work() - store new hardif mesh_iface state
- * @work: work queue item
- *
- * Changes the parts of the hard+soft interface which can not be modified under
- * sysfs lock (to prevent deadlock situations).
- */
-static void batadv_store_mesh_iface_work(struct work_struct *work)
-{
-	struct batadv_store_mesh_work *store_work;
-	int ret;
-
-	store_work = container_of(work, struct batadv_store_mesh_work, work);
-
-	rtnl_lock();
-	ret = batadv_store_mesh_iface_finish(store_work->net_dev,
-					     store_work->soft_iface_name);
-	rtnl_unlock();
-
-	if (ret < 0)
-		pr_err("Failed to store new mesh_iface state %s for %s: %d\n",
-		       store_work->soft_iface_name, store_work->net_dev->name,
-		       ret);
-
-	dev_put(store_work->net_dev);
-	kfree(store_work);
-}
-
-static ssize_t batadv_store_mesh_iface(struct kobject *kobj,
-				       struct attribute *attr, char *buff,
-				       size_t count)
-{
-	struct net_device *net_dev = batadv_kobj_to_netdev(kobj);
-	struct batadv_store_mesh_work *store_work;
-
-	batadv_sysfs_deprecated(attr);
-
-	if (buff[count - 1] == '\n')
-		buff[count - 1] = '\0';
-
-	if (strlen(buff) >= IFNAMSIZ) {
-		pr_err("Invalid parameter for 'mesh_iface' setting received: interface name too long '%s'\n",
-		       buff);
-		return -EINVAL;
-	}
-
-	store_work = kmalloc(sizeof(*store_work), GFP_KERNEL);
-	if (!store_work)
-		return -ENOMEM;
-
-	dev_hold(net_dev);
-	INIT_WORK(&store_work->work, batadv_store_mesh_iface_work);
-	store_work->net_dev = net_dev;
-	strscpy(store_work->soft_iface_name, buff,
-		sizeof(store_work->soft_iface_name));
-
-	queue_work(batadv_event_workqueue, &store_work->work);
-
-	return count;
-}
-
-static ssize_t batadv_show_iface_status(struct kobject *kobj,
-					struct attribute *attr, char *buff)
-{
-	struct net_device *net_dev = batadv_kobj_to_netdev(kobj);
-	struct batadv_hard_iface *hard_iface;
-	ssize_t length;
-
-	batadv_sysfs_deprecated(attr);
-
-	hard_iface = batadv_hardif_get_by_netdev(net_dev);
-	if (!hard_iface)
-		return 0;
-
-	switch (hard_iface->if_status) {
-	case BATADV_IF_TO_BE_REMOVED:
-		length = sprintf(buff, "disabling\n");
-		break;
-	case BATADV_IF_INACTIVE:
-		length = sprintf(buff, "inactive\n");
-		break;
-	case BATADV_IF_ACTIVE:
-		length = sprintf(buff, "active\n");
-		break;
-	case BATADV_IF_TO_BE_ACTIVATED:
-		length = sprintf(buff, "enabling\n");
-		break;
-	case BATADV_IF_NOT_IN_USE:
-	default:
-		length = sprintf(buff, "not in use\n");
-		break;
-	}
-
-	batadv_hardif_put(hard_iface);
-
-	return length;
-}
-
-#ifdef CONFIG_BATMAN_ADV_BATMAN_V
-
-/**
- * batadv_store_throughput_override() - parse and store throughput override
- *  entered by the user
- * @kobj: kobject representing the private mesh sysfs directory
- * @attr: the batman-adv attribute the user is interacting with
- * @buff: the buffer containing the user data
- * @count: number of bytes in the buffer
- *
- * Return: 'count' on success or a negative error code in case of failure
- */
-static ssize_t batadv_store_throughput_override(struct kobject *kobj,
-						struct attribute *attr,
-						char *buff, size_t count)
-{
-	struct net_device *net_dev = batadv_kobj_to_netdev(kobj);
-	struct batadv_hard_iface *hard_iface;
-	struct batadv_priv *bat_priv;
-	u32 tp_override;
-	u32 old_tp_override;
-	bool ret;
-
-	batadv_sysfs_deprecated(attr);
-
-	hard_iface = batadv_hardif_get_by_netdev(net_dev);
-	if (!hard_iface)
-		return -EINVAL;
-
-	if (buff[count - 1] == '\n')
-		buff[count - 1] = '\0';
-
-	ret = batadv_parse_throughput(net_dev, buff, "throughput_override",
-				      &tp_override);
-	if (!ret)
-		goto out;
-
-	old_tp_override = atomic_read(&hard_iface->bat_v.throughput_override);
-	if (old_tp_override == tp_override)
-		goto out;
-
-	batadv_info(hard_iface->soft_iface,
-		    "%s: %s: Changing from: %u.%u MBit to: %u.%u MBit\n",
-		    "throughput_override", net_dev->name,
-		    old_tp_override / 10, old_tp_override % 10,
-		    tp_override / 10, tp_override % 10);
-
-	atomic_set(&hard_iface->bat_v.throughput_override, tp_override);
-
-	if (hard_iface->soft_iface) {
-		bat_priv = netdev_priv(hard_iface->soft_iface);
-		batadv_netlink_notify_hardif(bat_priv, hard_iface);
-	}
-
-out:
-	batadv_hardif_put(hard_iface);
-	return count;
-}
-
-static ssize_t batadv_show_throughput_override(struct kobject *kobj,
-					       struct attribute *attr,
-					       char *buff)
-{
-	struct net_device *net_dev = batadv_kobj_to_netdev(kobj);
-	struct batadv_hard_iface *hard_iface;
-	u32 tp_override;
-
-	batadv_sysfs_deprecated(attr);
-
-	hard_iface = batadv_hardif_get_by_netdev(net_dev);
-	if (!hard_iface)
-		return -EINVAL;
-
-	tp_override = atomic_read(&hard_iface->bat_v.throughput_override);
-
-	batadv_hardif_put(hard_iface);
-	return sprintf(buff, "%u.%u MBit\n", tp_override / 10,
-		       tp_override % 10);
-}
-
-#endif
-
-static BATADV_ATTR(mesh_iface, 0644, batadv_show_mesh_iface,
-		   batadv_store_mesh_iface);
-static BATADV_ATTR(iface_status, 0444, batadv_show_iface_status, NULL);
-#ifdef CONFIG_BATMAN_ADV_BATMAN_V
-BATADV_ATTR_HIF_UINT(elp_interval, bat_v.elp_interval, 0644,
-		     2 * BATADV_JITTER, INT_MAX, NULL);
-static BATADV_ATTR(throughput_override, 0644, batadv_show_throughput_override,
-		   batadv_store_throughput_override);
-#endif
-
-static struct batadv_attribute *batadv_batman_attrs[] = {
-	&batadv_attr_mesh_iface,
-	&batadv_attr_iface_status,
-#ifdef CONFIG_BATMAN_ADV_BATMAN_V
-	&batadv_attr_elp_interval,
-	&batadv_attr_throughput_override,
-#endif
-	NULL,
-};
-
-/**
- * batadv_sysfs_add_hardif() - Add hard interface specific sysfs entries
- * @hardif_obj: address where to store the pointer to new sysfs folder
- * @dev: netdev struct of the hard interface
- *
- * Return: 0 on success or negative error number in case of failure
- */
-int batadv_sysfs_add_hardif(struct kobject **hardif_obj, struct net_device *dev)
-{
-	struct kobject *hardif_kobject = &dev->dev.kobj;
-	struct batadv_attribute **bat_attr;
-	int err;
-
-	*hardif_obj = kobject_create_and_add(BATADV_SYSFS_IF_BAT_SUBDIR,
-					     hardif_kobject);
-
-	if (!*hardif_obj) {
-		batadv_err(dev, "Can't add sysfs directory: %s/%s\n", dev->name,
-			   BATADV_SYSFS_IF_BAT_SUBDIR);
-		goto out;
-	}
-
-	for (bat_attr = batadv_batman_attrs; *bat_attr; ++bat_attr) {
-		err = sysfs_create_file(*hardif_obj, &((*bat_attr)->attr));
-		if (err) {
-			batadv_err(dev, "Can't add sysfs file: %s/%s/%s\n",
-				   dev->name, BATADV_SYSFS_IF_BAT_SUBDIR,
-				   ((*bat_attr)->attr).name);
-			goto rem_attr;
-		}
-	}
-
-	return 0;
-
-rem_attr:
-	for (bat_attr = batadv_batman_attrs; *bat_attr; ++bat_attr)
-		sysfs_remove_file(*hardif_obj, &((*bat_attr)->attr));
-out:
-	return -ENOMEM;
-}
-
-/**
- * batadv_sysfs_del_hardif() - Remove hard interface specific sysfs entries
- * @hardif_obj: address to the pointer to which stores batman-adv sysfs folder
- *  of the hard interface
- */
-void batadv_sysfs_del_hardif(struct kobject **hardif_obj)
-{
-	kobject_uevent(*hardif_obj, KOBJ_REMOVE);
-	kobject_del(*hardif_obj);
-	kobject_put(*hardif_obj);
-	*hardif_obj = NULL;
-}
diff --git a/net/batman-adv/sysfs.h b/net/batman-adv/sysfs.h
deleted file mode 100644
index d987f8b30a98..000000000000
--- a/net/batman-adv/sysfs.h
+++ /dev/null
@@ -1,93 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2010-2020  B.A.T.M.A.N. contributors:
- *
- * Marek Lindner
- */
-
-#ifndef _NET_BATMAN_ADV_SYSFS_H_
-#define _NET_BATMAN_ADV_SYSFS_H_
-
-#include "main.h"
-
-#include <linux/kobject.h>
-#include <linux/netdevice.h>
-#include <linux/sysfs.h>
-#include <linux/types.h>
-
-#define BATADV_SYSFS_IF_MESH_SUBDIR "mesh"
-#define BATADV_SYSFS_IF_BAT_SUBDIR "batman_adv"
-/**
- * BATADV_SYSFS_VLAN_SUBDIR_PREFIX - prefix of the subfolder that will be
- *  created in the sysfs hierarchy for each VLAN interface. The subfolder will
- *  be named "BATADV_SYSFS_VLAN_SUBDIR_PREFIX%vid".
- */
-#define BATADV_SYSFS_VLAN_SUBDIR_PREFIX "vlan"
-
-/**
- * struct batadv_attribute - sysfs export helper for batman-adv attributes
- */
-struct batadv_attribute {
-	/** @attr: sysfs attribute file */
-	struct attribute attr;
-
-	/**
-	 * @show: function to export the current attribute's content to sysfs
-	 */
-	ssize_t (*show)(struct kobject *kobj, struct attribute *attr,
-			char *buf);
-
-	/**
-	 * @store: function to load new value from character buffer and save it
-	 * in batman-adv attribute
-	 */
-	ssize_t (*store)(struct kobject *kobj, struct attribute *attr,
-			 char *buf, size_t count);
-};
-
-#ifdef CONFIG_BATMAN_ADV_SYSFS
-
-int batadv_sysfs_add_meshif(struct net_device *dev);
-void batadv_sysfs_del_meshif(struct net_device *dev);
-int batadv_sysfs_add_hardif(struct kobject **hardif_obj,
-			    struct net_device *dev);
-void batadv_sysfs_del_hardif(struct kobject **hardif_obj);
-int batadv_sysfs_add_vlan(struct net_device *dev,
-			  struct batadv_softif_vlan *vlan);
-void batadv_sysfs_del_vlan(struct batadv_priv *bat_priv,
-			   struct batadv_softif_vlan *vlan);
-
-#else
-
-static inline int batadv_sysfs_add_meshif(struct net_device *dev)
-{
-	return 0;
-}
-
-static inline void batadv_sysfs_del_meshif(struct net_device *dev)
-{
-}
-
-static inline int batadv_sysfs_add_hardif(struct kobject **hardif_obj,
-					  struct net_device *dev)
-{
-	return 0;
-}
-
-static inline void batadv_sysfs_del_hardif(struct kobject **hardif_obj)
-{
-}
-
-static inline int batadv_sysfs_add_vlan(struct net_device *dev,
-					struct batadv_softif_vlan *vlan)
-{
-	return 0;
-}
-
-static inline void batadv_sysfs_del_vlan(struct batadv_priv *bat_priv,
-					 struct batadv_softif_vlan *vlan)
-{
-}
-
-#endif
-
-#endif /* _NET_BATMAN_ADV_SYSFS_H_ */
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index 965336a3b89d..7cfe3081039e 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -187,9 +187,6 @@ struct batadv_hard_iface {
 	/** @net_dev: pointer to the net_device */
 	struct net_device *net_dev;
 
-	/** @hardif_obj: kobject of the per interface sysfs "mesh" directory */
-	struct kobject *hardif_obj;
-
 	/** @refcount: number of contexts the object is used */
 	struct kref refcount;
 
@@ -1512,9 +1509,6 @@ struct batadv_softif_vlan {
 	/** @vid: VLAN identifier */
 	unsigned short vid;
 
-	/** @kobj: kobject for sysfs vlan subdirectory */
-	struct kobject *kobj;
-
 	/** @ap_isolation: AP isolation state */
 	atomic_t ap_isolation;		/* boolean */
 
@@ -1667,9 +1661,6 @@ struct batadv_priv {
 	/** @batman_queue_left: number of remaining OGM packet slots */
 	atomic_t batman_queue_left;
 
-	/** @mesh_obj: kobject for sysfs mesh subdirectory */
-	struct kobject *mesh_obj;
-
 #ifdef CONFIG_BATMAN_ADV_DEBUGFS
 	/** @debug_dir: dentry for debugfs batman-adv subdirectory */
 	struct dentry *debug_dir;
@@ -2274,10 +2265,6 @@ struct batadv_algo_gw_ops {
 	 */
 	ssize_t (*store_sel_class)(struct batadv_priv *bat_priv, char *buff,
 				   size_t count);
-
-	/** @show_sel_class: prints the current GW selection class (optional) */
-	ssize_t (*show_sel_class)(struct batadv_priv *bat_priv, char *buff);
-
 	/**
 	 * @get_best_gw_node: select the best GW from the list of available
 	 *  nodes (optional)
@@ -2456,21 +2443,4 @@ enum batadv_tvlv_handler_flags {
 	BATADV_TVLV_HANDLER_OGM_CALLED = BIT(2),
 };
 
-/**
- * struct batadv_store_mesh_work - Work queue item to detach add/del interface
- *  from sysfs locks
- */
-struct batadv_store_mesh_work {
-	/**
-	 * @net_dev: netdevice to add/remove to/from batman-adv soft-interface
-	 */
-	struct net_device *net_dev;
-
-	/** @soft_iface_name: name of soft-interface to modify */
-	char soft_iface_name[IFNAMSIZ];
-
-	/** @work: work queue item */
-	struct work_struct work;
-};
-
 #endif /* _NET_BATMAN_ADV_TYPES_H_ */
-- 
2.20.1

