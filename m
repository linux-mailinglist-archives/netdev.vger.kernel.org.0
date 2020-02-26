Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABB7B170687
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 18:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgBZRt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 12:49:26 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:54733 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbgBZRtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 12:49:25 -0500
Received: by mail-pj1-f67.google.com with SMTP id dw13so1534431pjb.4
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 09:49:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=VwMJgocV6YhDaeelLV9IerRRmlVu5ZN5e465ESHUgJQ=;
        b=ePV01Ori7pZ9C+x/X7xgPaBraEjFr6MbMxBIdJ72cvzh9Q6rIVrA3JVPU3NjFcUhfp
         sAeIfSirfbIP75EFNXETutKiwg0KN3oYQBX5dBmX2ZeRamj6DwJbnat5sX5wTYdQFFUG
         t6syj1WUAB80UW5XfPuJAnwMhUTx7fcikuv55OsIU9fh6lgdD6lHsKuy90WjutOh/0sM
         KJlEHJ5mS/Vv/WFpRJw25018dlTv9XYuRzwPpZFJc6soH5BNprivxkNZ4UAkeWDl5CZD
         aqDWXhALMtvKIx5fjRVao+QeGXLqv89ebgerE64mX3yBDvFauQSEjDXErJTT4bGlOrap
         //Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=VwMJgocV6YhDaeelLV9IerRRmlVu5ZN5e465ESHUgJQ=;
        b=J7sFfeORXMsWPzplfzUFDDt3Rbaj99Z6DeJpbVU90vtSDbR96UvLcJL26umfBGHKuI
         0+5Q2kvfWSycHlKtKmkFVuXHFhoAvnblGFQFmoArABvGbQEIYIe3wC2akSzBTWO5B/J4
         a/hUe1pnO8LXdLZRtzS0wwPSnWvllnaVvETLHgHunveCXP7Sd3sGrEhHzm9gvLvea06e
         9jsEf0IBpL+YmeTLXaS+DUpNp+faj8XQkK7d1BnwJv/q+z6vuSIMeYUV+TGlE/8NHeq7
         QtHtqsZer4L4eqd+KL5OGhu20Q2JBw/fQYwMm6m7CY1vksa9eqGXQnkXBmyJ8a9lc+hL
         yfIQ==
X-Gm-Message-State: APjAAAVfee2PwsapnQTmWv0sqzHnNWN9155HbLq7nIqLKbBywRtkihDa
        4Rw/t1vErBpgRUN9/otsxyE=
X-Google-Smtp-Source: APXvYqwFsj5WGlYfQPOeQPKCyTPsyEh18IyThS3VqbIz1r5xMS4t+bnaXobp5uXnQK6wmObK723tJQ==
X-Received: by 2002:a17:90a:f0d1:: with SMTP id fa17mr253809pjb.90.1582739364354;
        Wed, 26 Feb 2020 09:49:24 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id l12sm3436140pgj.16.2020.02.26.09.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 09:49:23 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, subashab@codeaurora.org,
        stranche@codeaurora.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 09/10] net: rmnet: fix bridge mode bugs
Date:   Wed, 26 Feb 2020 17:49:14 +0000
Message-Id: <20200226174914.6382-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to attach a bridge interface to the rmnet interface,
"master" operation is used.
(e.g. ip link set dummy1 master rmnet0)
But, in the rmnet_add_bridge(), which is a callback of ->ndo_add_slave()
doesn't register lower interface.
So, ->ndo_del_slave() doesn't work.
There are other problems too.
1. It couldn't detect circular upper/lower interface relationship.
2. It couldn't prevent stack overflow because of too deep depth
of upper/lower interface
3. It doesn't check the number of lower interfaces.
4. Panics because of several reasons.

The root problem of these issues is actually the same.
So, in this patch, these all problems will be fixed.

Test commands:
    ip link add dummy0 type dummy
    modprobe rmnet
    ip link add rmnet0 link dummy0 type rmnet mux_id 1
    ip link add dummy1 master rmnet0 type dummy
    ip link add dummy2 master rmnet0 type dummy
    ip link del rmnet0
    ip link del dummy2
    ip link del dummy1

Splat looks like:
[  138.464412][ T1237] general protection fault, probably for non-canonical address 0xdffffc0000000101I
[  138.475658][ T1237] KASAN: null-ptr-deref in range [0x0000000000000808-0x000000000000080f]
[  138.477242][ T1237] CPU: 1 PID: 1237 Comm: ip Not tainted 5.6.0-rc1+ #447
[  138.478428][ T1237] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  138.479899][ T1237] RIP: 0010:rmnet_unregister_bridge.isra.6+0x71/0xf0 [rmnet]
[  138.483673][ T1237] Code: 48 89 ef 48 89 c6 5b 5d e9 fc fe ff ff e8 f7 f3 ff ff 48 8d b8 08 08 00 00 48 ba 00 7
[  138.511468][ T1237] RSP: 0018:ffff8880ca39f188 EFLAGS: 00010202
[  138.512088][ T1237] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000101
[  138.512803][ T1237] RDX: dffffc0000000000 RSI: ffffffff89cf64f0 RDI: 0000000000000808
[  138.513542][ T1237] RBP: ffff8880c9f01000 R08: ffffed101b440e3c R09: 0000000000000001
[  138.514332][ T1237] R10: 0000000000000001 R11: ffffed101b440e3b R12: 1ffff11019473e3c
[  138.515129][ T1237] R13: ffff8880ca39f200 R14: ffffffff89d56160 R15: ffff8880b7c7c000
[  138.515900][ T1237] FS:  00007fe19afb30c0(0000) GS:ffff8880da000000(0000) knlGS:0000000000000000
[  138.516711][ T1237] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  138.517309][ T1237] CR2: 0000563cebbb9928 CR3: 00000000d3756004 CR4: 00000000000606e0
[  138.518093][ T1237] Call Trace:
[  138.518426][ T1237]  ? rcu_is_watching+0x2c/0x80
[  138.518860][ T1237]  rmnet_config_notify_cb+0x1f7/0x590 [rmnet]
[  138.519412][ T1237]  ? rmnet_unregister_bridge.isra.6+0xf0/0xf0 [rmnet]
[  138.523502][ T1237]  ? rmnet_unregister_bridge.isra.6+0xf0/0xf0 [rmnet]
[  138.524180][ T1237]  ? __module_text_address+0x13/0x140
[  138.524710][ T1237]  notifier_call_chain+0x90/0x160
[  138.525211][ T1237]  rollback_registered_many+0x660/0xcf0
[  138.525780][ T1237]  ? netif_set_real_num_tx_queues+0x780/0x780
[  138.526394][ T1237]  ? __lock_acquire+0xdfe/0x3de0
[  138.526892][ T1237]  ? memset+0x1f/0x40
[  138.527294][ T1237]  ? __nla_validate_parse+0x98/0x1ab0
[  138.527831][ T1237]  unregister_netdevice_many.part.133+0x13/0x1b0
[  138.528464][ T1237]  rtnl_delete_link+0xbc/0x100
[  138.528929][ T1237]  ? rtnl_af_register+0xc0/0xc0
[  138.529372][ T1237]  rtnl_dellink+0x2dc/0x840
[ ... ]

Fixes: 60d58f971c10 ("net: qualcomm: rmnet: Implement bridge mode")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 .../ethernet/qualcomm/rmnet/rmnet_config.c    | 128 ++++++++----------
 .../ethernet/qualcomm/rmnet/rmnet_config.h    |   1 +
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   |   8 --
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.h   |   1 -
 4 files changed, 61 insertions(+), 77 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index 5b642123c178..6dc332818e15 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -13,25 +13,6 @@
 #include "rmnet_vnd.h"
 #include "rmnet_private.h"
 
-/* Locking scheme -
- * The shared resource which needs to be protected is realdev->rx_handler_data.
- * For the writer path, this is using rtnl_lock(). The writer paths are
- * rmnet_newlink(), rmnet_dellink() and rmnet_force_unassociate_device(). These
- * paths are already called with rtnl_lock() acquired in. There is also an
- * ASSERT_RTNL() to ensure that we are calling with rtnl acquired. For
- * dereference here, we will need to use rtnl_dereference(). Dev list writing
- * needs to happen with rtnl_lock() acquired for netdev_master_upper_dev_link().
- * For the reader path, the real_dev->rx_handler_data is called in the TX / RX
- * path. We only need rcu_read_lock() for these scenarios. In these cases,
- * the rcu_read_lock() is held in __dev_queue_xmit() and
- * netif_receive_skb_internal(), so readers need to use rcu_dereference_rtnl()
- * to get the relevant information. For dev list reading, we again acquire
- * rcu_read_lock() in rmnet_dellink() for netdev_master_upper_dev_get_rcu().
- * We also use unregister_netdevice_many() to free all rmnet devices in
- * rmnet_force_unassociate_device() so we dont lose the rtnl_lock() and free in
- * same context.
- */
-
 /* Local Definitions and Declarations */
 
 static const struct nla_policy rmnet_policy[IFLA_RMNET_MAX + 1] = {
@@ -51,9 +32,10 @@ rmnet_get_port_rtnl(const struct net_device *real_dev)
 	return rtnl_dereference(real_dev->rx_handler_data);
 }
 
-static int rmnet_unregister_real_device(struct net_device *real_dev,
-					struct rmnet_port *port)
+static int rmnet_unregister_real_device(struct net_device *real_dev)
 {
+	struct rmnet_port *port = rmnet_get_port_rtnl(real_dev);
+
 	if (port->nr_rmnet_devs)
 		return -EINVAL;
 
@@ -93,28 +75,33 @@ static int rmnet_register_real_device(struct net_device *real_dev)
 	return 0;
 }
 
-static void rmnet_unregister_bridge(struct net_device *dev,
-				    struct rmnet_port *port)
+static void rmnet_unregister_bridge(struct rmnet_port *port)
 {
-	struct rmnet_port *bridge_port;
-	struct net_device *bridge_dev;
+	struct net_device *bridge_dev, *real_dev, *rmnet_dev;
+	struct rmnet_port *real_port;
 
 	if (port->rmnet_mode != RMNET_EPMODE_BRIDGE)
 		return;
 
-	/* bridge slave handling */
+	rmnet_dev = port->rmnet_dev;
 	if (!port->nr_rmnet_devs) {
-		bridge_dev = port->bridge_ep;
+		/* bridge device */
+		real_dev = port->bridge_ep;
+		bridge_dev = port->dev;
 
-		bridge_port = rmnet_get_port_rtnl(bridge_dev);
-		bridge_port->bridge_ep = NULL;
-		bridge_port->rmnet_mode = RMNET_EPMODE_VND;
+		real_port = rmnet_get_port_rtnl(real_dev);
+		real_port->bridge_ep = NULL;
+		real_port->rmnet_mode = RMNET_EPMODE_VND;
 	} else {
+		/* real device */
 		bridge_dev = port->bridge_ep;
 
-		bridge_port = rmnet_get_port_rtnl(bridge_dev);
-		rmnet_unregister_real_device(bridge_dev, bridge_port);
+		port->bridge_ep = NULL;
+		port->rmnet_mode = RMNET_EPMODE_VND;
 	}
+
+	netdev_upper_dev_unlink(bridge_dev, rmnet_dev);
+	rmnet_unregister_real_device(bridge_dev);
 }
 
 static int rmnet_newlink(struct net *src_net, struct net_device *dev,
@@ -160,6 +147,7 @@ static int rmnet_newlink(struct net *src_net, struct net_device *dev,
 		goto err2;
 
 	port->rmnet_mode = mode;
+	port->rmnet_dev = dev;
 
 	hlist_add_head_rcu(&ep->hlnode, &port->muxed_ep[mux_id]);
 
@@ -177,8 +165,9 @@ static int rmnet_newlink(struct net *src_net, struct net_device *dev,
 
 err2:
 	unregister_netdevice(dev);
+	rmnet_vnd_dellink(mux_id, port, ep);
 err1:
-	rmnet_unregister_real_device(real_dev, port);
+	rmnet_unregister_real_device(real_dev);
 err0:
 	kfree(ep);
 	return err;
@@ -187,30 +176,32 @@ static int rmnet_newlink(struct net *src_net, struct net_device *dev,
 static void rmnet_dellink(struct net_device *dev, struct list_head *head)
 {
 	struct rmnet_priv *priv = netdev_priv(dev);
-	struct net_device *real_dev;
+	struct net_device *real_dev, *bridge_dev;
+	struct rmnet_port *real_port, *bridge_port;
 	struct rmnet_endpoint *ep;
-	struct rmnet_port *port;
-	u8 mux_id;
+	u8 mux_id = priv->mux_id;
 
 	real_dev = priv->real_dev;
 
-	if (!real_dev || !rmnet_is_real_dev_registered(real_dev))
+	if (!rmnet_is_real_dev_registered(real_dev))
 		return;
 
-	port = rmnet_get_port_rtnl(real_dev);
-
-	mux_id = rmnet_vnd_get_mux(dev);
+	real_port = rmnet_get_port_rtnl(real_dev);
+	bridge_dev = real_port->bridge_ep;
+	if (bridge_dev) {
+		bridge_port = rmnet_get_port_rtnl(bridge_dev);
+		rmnet_unregister_bridge(bridge_port);
+	}
 
-	ep = rmnet_get_endpoint(port, mux_id);
+	ep = rmnet_get_endpoint(real_port, mux_id);
 	if (ep) {
 		hlist_del_init_rcu(&ep->hlnode);
-		rmnet_unregister_bridge(dev, port);
-		rmnet_vnd_dellink(mux_id, port, ep);
+		rmnet_vnd_dellink(mux_id, real_port, ep);
 		kfree(ep);
 	}
-	netdev_upper_dev_unlink(real_dev, dev);
-	rmnet_unregister_real_device(real_dev, port);
 
+	netdev_upper_dev_unlink(real_dev, dev);
+	rmnet_unregister_real_device(real_dev);
 	unregister_netdevice_queue(dev, head);
 }
 
@@ -222,23 +213,23 @@ static void rmnet_force_unassociate_device(struct net_device *real_dev)
 	unsigned long bkt_ep;
 	LIST_HEAD(list);
 
-	ASSERT_RTNL();
-
 	port = rmnet_get_port_rtnl(real_dev);
 
-	rmnet_unregister_bridge(real_dev, port);
-
-	hash_for_each_safe(port->muxed_ep, bkt_ep, tmp_ep, ep, hlnode) {
-		netdev_upper_dev_unlink(real_dev, ep->egress_dev);
-		unregister_netdevice_queue(ep->egress_dev, &list);
-		rmnet_vnd_dellink(ep->mux_id, port, ep);
-		hlist_del_init_rcu(&ep->hlnode);
-		kfree(ep);
+	if (port->nr_rmnet_devs) {
+		/* real device */
+		rmnet_unregister_bridge(port);
+		hash_for_each_safe(port->muxed_ep, bkt_ep, tmp_ep, ep, hlnode) {
+			unregister_netdevice_queue(ep->egress_dev, &list);
+			netdev_upper_dev_unlink(real_dev, ep->egress_dev);
+			rmnet_vnd_dellink(ep->mux_id, port, ep);
+			hlist_del_init_rcu(&ep->hlnode);
+			kfree(ep);
+		}
+		rmnet_unregister_real_device(real_dev);
+		unregister_netdevice_many(&list);
+	} else {
+		rmnet_unregister_bridge(port);
 	}
-
-	unregister_netdevice_many(&list);
-
-	rmnet_unregister_real_device(real_dev, port);
 }
 
 static int rmnet_config_notify_cb(struct notifier_block *nb,
@@ -433,9 +424,17 @@ int rmnet_add_bridge(struct net_device *rmnet_dev,
 	if (err)
 		return -EBUSY;
 
+	err = netdev_master_upper_dev_link(slave_dev, rmnet_dev, NULL, NULL,
+					   extack);
+	if (err) {
+		rmnet_unregister_real_device(slave_dev);
+		return err;
+	}
+
 	slave_port = rmnet_get_port_rtnl(slave_dev);
 	slave_port->rmnet_mode = RMNET_EPMODE_BRIDGE;
 	slave_port->bridge_ep = real_dev;
+	slave_port->rmnet_dev = rmnet_dev;
 
 	port->rmnet_mode = RMNET_EPMODE_BRIDGE;
 	port->bridge_ep = slave_dev;
@@ -447,16 +446,9 @@ int rmnet_add_bridge(struct net_device *rmnet_dev,
 int rmnet_del_bridge(struct net_device *rmnet_dev,
 		     struct net_device *slave_dev)
 {
-	struct rmnet_priv *priv = netdev_priv(rmnet_dev);
-	struct net_device *real_dev = priv->real_dev;
-	struct rmnet_port *port, *slave_port;
-
-	port = rmnet_get_port_rtnl(real_dev);
-	port->rmnet_mode = RMNET_EPMODE_VND;
-	port->bridge_ep = NULL;
+	struct rmnet_port *port = rmnet_get_port_rtnl(slave_dev);
 
-	slave_port = rmnet_get_port_rtnl(slave_dev);
-	rmnet_unregister_real_device(slave_dev, slave_port);
+	rmnet_unregister_bridge(port);
 
 	netdev_dbg(slave_dev, "removed from rmnet as slave\n");
 	return 0;
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
index 0d568dcfd65a..be515982d628 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
@@ -28,6 +28,7 @@ struct rmnet_port {
 	u8 rmnet_mode;
 	struct hlist_head muxed_ep[RMNET_MAX_LOGICAL_EP];
 	struct net_device *bridge_ep;
+	struct net_device *rmnet_dev;
 };
 
 extern struct rtnl_link_ops rmnet_link_ops;
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
index 90c19033ebe0..6ef007f69237 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -268,14 +268,6 @@ int rmnet_vnd_dellink(u8 id, struct rmnet_port *port,
 	return 0;
 }
 
-u8 rmnet_vnd_get_mux(struct net_device *rmnet_dev)
-{
-	struct rmnet_priv *priv;
-
-	priv = netdev_priv(rmnet_dev);
-	return priv->mux_id;
-}
-
 int rmnet_vnd_do_flow_control(struct net_device *rmnet_dev, int enable)
 {
 	netdev_dbg(rmnet_dev, "Setting VND TX queue state to %d\n", enable);
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
index d8fa76e8e9c4..4967f3461ed1 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
@@ -17,6 +17,5 @@ int rmnet_vnd_dellink(u8 id, struct rmnet_port *port,
 		      struct rmnet_endpoint *ep);
 void rmnet_vnd_rx_fixup(struct sk_buff *skb, struct net_device *dev);
 void rmnet_vnd_tx_fixup(struct sk_buff *skb, struct net_device *dev);
-u8 rmnet_vnd_get_mux(struct net_device *rmnet_dev);
 void rmnet_vnd_setup(struct net_device *dev);
 #endif /* _RMNET_VND_H_ */
-- 
2.17.1

