Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3425808F
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 12:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfF0Kjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 06:39:53 -0400
Received: from packetmixer.de ([79.140.42.25]:48612 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbfF0Kjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 06:39:51 -0400
Received: from kero.packetmixer.de (ip-109-41-128-179.web.vodafone.de [109.41.128.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mail.packetmixer.de (Postfix) with ESMTPSA id 4772362074;
        Thu, 27 Jun 2019 12:39:48 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 08/10] batman-adv: no need to check return value of debugfs_create functions
Date:   Thu, 27 Jun 2019 12:39:36 +0200
Message-Id: <20190627103938.7488-9-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190627103938.7488-1-sw@simonwunderlich.de>
References: <20190627103938.7488-1-sw@simonwunderlich.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Because we don't care if debugfs works or not, this trickles back a bit
so we can clean things up by making some functions return void instead
of an error value that is never going to fail.

Cc: Marek Lindner <mareklindner@neomailbox.ch>
Cc: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Antonio Quartulli <a@unstable.cc>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: b.a.t.m.a.n@lists.open-mesh.org
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[sven@narfation.org: drop unused variables]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/debugfs.c        | 99 +++++++++--------------------------------
 net/batman-adv/debugfs.h        |  5 +--
 net/batman-adv/hard-interface.c |  6 +--
 net/batman-adv/icmp_socket.c    | 20 ++-------
 net/batman-adv/icmp_socket.h    |  2 +-
 net/batman-adv/log.c            | 17 ++-----
 net/batman-adv/network-coding.c | 29 +++---------
 net/batman-adv/network-coding.h |  5 +--
 8 files changed, 39 insertions(+), 144 deletions(-)

diff --git a/net/batman-adv/debugfs.c b/net/batman-adv/debugfs.c
index d38d70ccdd5a..38c4d8e51155 100644
--- a/net/batman-adv/debugfs.c
+++ b/net/batman-adv/debugfs.c
@@ -10,7 +10,6 @@
 #include <asm/current.h>
 #include <linux/dcache.h>
 #include <linux/debugfs.h>
-#include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/export.h>
 #include <linux/fs.h>
@@ -293,31 +292,13 @@ static struct batadv_debuginfo *batadv_hardif_debuginfos[] = {
 void batadv_debugfs_init(void)
 {
 	struct batadv_debuginfo **bat_debug;
-	struct dentry *file;
 
 	batadv_debugfs = debugfs_create_dir(BATADV_DEBUGFS_SUBDIR, NULL);
-	if (batadv_debugfs == ERR_PTR(-ENODEV))
-		batadv_debugfs = NULL;
-
-	if (!batadv_debugfs)
-		goto err;
-
-	for (bat_debug = batadv_general_debuginfos; *bat_debug; ++bat_debug) {
-		file = debugfs_create_file(((*bat_debug)->attr).name,
-					   S_IFREG | ((*bat_debug)->attr).mode,
-					   batadv_debugfs, NULL,
-					   &(*bat_debug)->fops);
-		if (!file) {
-			pr_err("Can't add general debugfs file: %s\n",
-			       ((*bat_debug)->attr).name);
-			goto err;
-		}
-	}
 
-	return;
-err:
-	debugfs_remove_recursive(batadv_debugfs);
-	batadv_debugfs = NULL;
+	for (bat_debug = batadv_general_debuginfos; *bat_debug; ++bat_debug)
+		debugfs_create_file(((*bat_debug)->attr).name,
+				    S_IFREG | ((*bat_debug)->attr).mode,
+				    batadv_debugfs, NULL, &(*bat_debug)->fops);
 }
 
 /**
@@ -333,42 +314,23 @@ void batadv_debugfs_destroy(void)
  * batadv_debugfs_add_hardif() - creates the base directory for a hard interface
  *  in debugfs.
  * @hard_iface: hard interface which should be added.
- *
- * Return: 0 on success or negative error number in case of failure
  */
-int batadv_debugfs_add_hardif(struct batadv_hard_iface *hard_iface)
+void batadv_debugfs_add_hardif(struct batadv_hard_iface *hard_iface)
 {
 	struct net *net = dev_net(hard_iface->net_dev);
 	struct batadv_debuginfo **bat_debug;
-	struct dentry *file;
-
-	if (!batadv_debugfs)
-		goto out;
 
 	if (net != &init_net)
-		return 0;
+		return;
 
 	hard_iface->debug_dir = debugfs_create_dir(hard_iface->net_dev->name,
 						   batadv_debugfs);
-	if (!hard_iface->debug_dir)
-		goto out;
-
-	for (bat_debug = batadv_hardif_debuginfos; *bat_debug; ++bat_debug) {
-		file = debugfs_create_file(((*bat_debug)->attr).name,
-					   S_IFREG | ((*bat_debug)->attr).mode,
-					   hard_iface->debug_dir,
-					   hard_iface->net_dev,
-					   &(*bat_debug)->fops);
-		if (!file)
-			goto rem_attr;
-	}
 
-	return 0;
-rem_attr:
-	debugfs_remove_recursive(hard_iface->debug_dir);
-	hard_iface->debug_dir = NULL;
-out:
-	return -ENOMEM;
+	for (bat_debug = batadv_hardif_debuginfos; *bat_debug; ++bat_debug)
+		debugfs_create_file(((*bat_debug)->attr).name,
+				    S_IFREG | ((*bat_debug)->attr).mode,
+				    hard_iface->debug_dir, hard_iface->net_dev,
+				    &(*bat_debug)->fops);
 }
 
 /**
@@ -379,15 +341,12 @@ void batadv_debugfs_rename_hardif(struct batadv_hard_iface *hard_iface)
 {
 	const char *name = hard_iface->net_dev->name;
 	struct dentry *dir;
-	struct dentry *d;
 
 	dir = hard_iface->debug_dir;
 	if (!dir)
 		return;
 
-	d = debugfs_rename(dir->d_parent, dir, dir->d_parent, name);
-	if (!d)
-		pr_err("Can't rename debugfs dir to %s\n", name);
+	debugfs_rename(dir->d_parent, dir, dir->d_parent, name);
 }
 
 /**
@@ -419,44 +378,29 @@ int batadv_debugfs_add_meshif(struct net_device *dev)
 	struct batadv_priv *bat_priv = netdev_priv(dev);
 	struct batadv_debuginfo **bat_debug;
 	struct net *net = dev_net(dev);
-	struct dentry *file;
-
-	if (!batadv_debugfs)
-		goto out;
 
 	if (net != &init_net)
 		return 0;
 
 	bat_priv->debug_dir = debugfs_create_dir(dev->name, batadv_debugfs);
-	if (!bat_priv->debug_dir)
-		goto out;
 
-	if (batadv_socket_setup(bat_priv) < 0)
-		goto rem_attr;
+	batadv_socket_setup(bat_priv);
 
 	if (batadv_debug_log_setup(bat_priv) < 0)
 		goto rem_attr;
 
-	for (bat_debug = batadv_mesh_debuginfos; *bat_debug; ++bat_debug) {
-		file = debugfs_create_file(((*bat_debug)->attr).name,
-					   S_IFREG | ((*bat_debug)->attr).mode,
-					   bat_priv->debug_dir,
-					   dev, &(*bat_debug)->fops);
-		if (!file) {
-			batadv_err(dev, "Can't add debugfs file: %s/%s\n",
-				   dev->name, ((*bat_debug)->attr).name);
-			goto rem_attr;
-		}
-	}
+	for (bat_debug = batadv_mesh_debuginfos; *bat_debug; ++bat_debug)
+		debugfs_create_file(((*bat_debug)->attr).name,
+				    S_IFREG | ((*bat_debug)->attr).mode,
+				    bat_priv->debug_dir, dev,
+				    &(*bat_debug)->fops);
 
-	if (batadv_nc_init_debugfs(bat_priv) < 0)
-		goto rem_attr;
+	batadv_nc_init_debugfs(bat_priv);
 
 	return 0;
 rem_attr:
 	debugfs_remove_recursive(bat_priv->debug_dir);
 	bat_priv->debug_dir = NULL;
-out:
 	return -ENOMEM;
 }
 
@@ -469,15 +413,12 @@ void batadv_debugfs_rename_meshif(struct net_device *dev)
 	struct batadv_priv *bat_priv = netdev_priv(dev);
 	const char *name = dev->name;
 	struct dentry *dir;
-	struct dentry *d;
 
 	dir = bat_priv->debug_dir;
 	if (!dir)
 		return;
 
-	d = debugfs_rename(dir->d_parent, dir, dir->d_parent, name);
-	if (!d)
-		pr_err("Can't rename debugfs dir to %s\n", name);
+	debugfs_rename(dir->d_parent, dir, dir->d_parent, name);
 }
 
 /**
diff --git a/net/batman-adv/debugfs.h b/net/batman-adv/debugfs.h
index ed3343195466..1c5afd301ce9 100644
--- a/net/batman-adv/debugfs.h
+++ b/net/batman-adv/debugfs.h
@@ -22,7 +22,7 @@ void batadv_debugfs_destroy(void);
 int batadv_debugfs_add_meshif(struct net_device *dev);
 void batadv_debugfs_rename_meshif(struct net_device *dev);
 void batadv_debugfs_del_meshif(struct net_device *dev);
-int batadv_debugfs_add_hardif(struct batadv_hard_iface *hard_iface);
+void batadv_debugfs_add_hardif(struct batadv_hard_iface *hard_iface);
 void batadv_debugfs_rename_hardif(struct batadv_hard_iface *hard_iface);
 void batadv_debugfs_del_hardif(struct batadv_hard_iface *hard_iface);
 
@@ -54,9 +54,8 @@ static inline void batadv_debugfs_del_meshif(struct net_device *dev)
 }
 
 static inline
-int batadv_debugfs_add_hardif(struct batadv_hard_iface *hard_iface)
+void batadv_debugfs_add_hardif(struct batadv_hard_iface *hard_iface)
 {
-	return 0;
 }
 
 static inline
diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index 899487641bca..b5465e6e380d 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -921,9 +921,7 @@ batadv_hardif_add_interface(struct net_device *net_dev)
 	hard_iface->soft_iface = NULL;
 	hard_iface->if_status = BATADV_IF_NOT_IN_USE;
 
-	ret = batadv_debugfs_add_hardif(hard_iface);
-	if (ret)
-		goto free_sysfs;
+	batadv_debugfs_add_hardif(hard_iface);
 
 	INIT_LIST_HEAD(&hard_iface->list);
 	INIT_HLIST_HEAD(&hard_iface->neigh_list);
@@ -945,8 +943,6 @@ batadv_hardif_add_interface(struct net_device *net_dev)
 
 	return hard_iface;
 
-free_sysfs:
-	batadv_sysfs_del_hardif(&hard_iface->hardif_obj);
 free_if:
 	kfree(hard_iface);
 release_dev:
diff --git a/net/batman-adv/icmp_socket.c b/net/batman-adv/icmp_socket.c
index 0a91c8661357..0a70b66e8770 100644
--- a/net/batman-adv/icmp_socket.c
+++ b/net/batman-adv/icmp_socket.c
@@ -314,25 +314,11 @@ static const struct file_operations batadv_fops = {
 /**
  * batadv_socket_setup() - Create debugfs "socket" file
  * @bat_priv: the bat priv with all the soft interface information
- *
- * Return: 0 on success or negative error number in case of failure
  */
-int batadv_socket_setup(struct batadv_priv *bat_priv)
+void batadv_socket_setup(struct batadv_priv *bat_priv)
 {
-	struct dentry *d;
-
-	if (!bat_priv->debug_dir)
-		goto err;
-
-	d = debugfs_create_file(BATADV_ICMP_SOCKET, 0600, bat_priv->debug_dir,
-				bat_priv, &batadv_fops);
-	if (!d)
-		goto err;
-
-	return 0;
-
-err:
-	return -ENOMEM;
+	debugfs_create_file(BATADV_ICMP_SOCKET, 0600, bat_priv->debug_dir,
+			    bat_priv, &batadv_fops);
 }
 
 /**
diff --git a/net/batman-adv/icmp_socket.h b/net/batman-adv/icmp_socket.h
index 1fc0b0de290e..27fafff586df 100644
--- a/net/batman-adv/icmp_socket.h
+++ b/net/batman-adv/icmp_socket.h
@@ -14,7 +14,7 @@
 
 #define BATADV_ICMP_SOCKET "socket"
 
-int batadv_socket_setup(struct batadv_priv *bat_priv);
+void batadv_socket_setup(struct batadv_priv *bat_priv);
 
 #ifdef CONFIG_BATMAN_ADV_DEBUGFS
 
diff --git a/net/batman-adv/log.c b/net/batman-adv/log.c
index f79ebd5b46e9..11941cf1adcc 100644
--- a/net/batman-adv/log.c
+++ b/net/batman-adv/log.c
@@ -190,27 +190,16 @@ static const struct file_operations batadv_log_fops = {
  */
 int batadv_debug_log_setup(struct batadv_priv *bat_priv)
 {
-	struct dentry *d;
-
-	if (!bat_priv->debug_dir)
-		goto err;
-
 	bat_priv->debug_log = kzalloc(sizeof(*bat_priv->debug_log), GFP_ATOMIC);
 	if (!bat_priv->debug_log)
-		goto err;
+		return -ENOMEM;
 
 	spin_lock_init(&bat_priv->debug_log->lock);
 	init_waitqueue_head(&bat_priv->debug_log->queue_wait);
 
-	d = debugfs_create_file("log", 0400, bat_priv->debug_dir, bat_priv,
-				&batadv_log_fops);
-	if (!d)
-		goto err;
-
+	debugfs_create_file("log", 0400, bat_priv->debug_dir, bat_priv,
+			    &batadv_log_fops);
 	return 0;
-
-err:
-	return -ENOMEM;
 }
 
 /**
diff --git a/net/batman-adv/network-coding.c b/net/batman-adv/network-coding.c
index c5e7906045f3..580609389f0f 100644
--- a/net/batman-adv/network-coding.c
+++ b/net/batman-adv/network-coding.c
@@ -1951,34 +1951,19 @@ int batadv_nc_nodes_seq_print_text(struct seq_file *seq, void *offset)
 /**
  * batadv_nc_init_debugfs() - create nc folder and related files in debugfs
  * @bat_priv: the bat priv with all the soft interface information
- *
- * Return: 0 on success or negative error number in case of failure
  */
-int batadv_nc_init_debugfs(struct batadv_priv *bat_priv)
+void batadv_nc_init_debugfs(struct batadv_priv *bat_priv)
 {
-	struct dentry *nc_dir, *file;
+	struct dentry *nc_dir;
 
 	nc_dir = debugfs_create_dir("nc", bat_priv->debug_dir);
-	if (!nc_dir)
-		goto out;
 
-	file = debugfs_create_u8("min_tq", 0644, nc_dir, &bat_priv->nc.min_tq);
-	if (!file)
-		goto out;
+	debugfs_create_u8("min_tq", 0644, nc_dir, &bat_priv->nc.min_tq);
 
-	file = debugfs_create_u32("max_fwd_delay", 0644, nc_dir,
-				  &bat_priv->nc.max_fwd_delay);
-	if (!file)
-		goto out;
+	debugfs_create_u32("max_fwd_delay", 0644, nc_dir,
+			   &bat_priv->nc.max_fwd_delay);
 
-	file = debugfs_create_u32("max_buffer_time", 0644, nc_dir,
-				  &bat_priv->nc.max_buffer_time);
-	if (!file)
-		goto out;
-
-	return 0;
-
-out:
-	return -ENOMEM;
+	debugfs_create_u32("max_buffer_time", 0644, nc_dir,
+			   &bat_priv->nc.max_buffer_time);
 }
 #endif
diff --git a/net/batman-adv/network-coding.h b/net/batman-adv/network-coding.h
index 4801d0891cc8..753fa49723cf 100644
--- a/net/batman-adv/network-coding.h
+++ b/net/batman-adv/network-coding.h
@@ -39,7 +39,7 @@ void batadv_nc_skb_store_for_decoding(struct batadv_priv *bat_priv,
 void batadv_nc_skb_store_sniffed_unicast(struct batadv_priv *bat_priv,
 					 struct sk_buff *skb);
 int batadv_nc_nodes_seq_print_text(struct seq_file *seq, void *offset);
-int batadv_nc_init_debugfs(struct batadv_priv *bat_priv);
+void batadv_nc_init_debugfs(struct batadv_priv *bat_priv);
 
 #else /* ifdef CONFIG_BATMAN_ADV_NC */
 
@@ -110,9 +110,8 @@ static inline int batadv_nc_nodes_seq_print_text(struct seq_file *seq,
 	return 0;
 }
 
-static inline int batadv_nc_init_debugfs(struct batadv_priv *bat_priv)
+static inline void batadv_nc_init_debugfs(struct batadv_priv *bat_priv)
 {
-	return 0;
 }
 
 #endif /* ifdef CONFIG_BATMAN_ADV_NC */
-- 
2.11.0

