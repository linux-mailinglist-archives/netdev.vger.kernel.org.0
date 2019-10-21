Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61D42DF54F
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 20:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730059AbfJUSsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 14:48:23 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36703 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbfJUSsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 14:48:23 -0400
Received: by mail-pl1-f194.google.com with SMTP id j11so7058620plk.3;
        Mon, 21 Oct 2019 11:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8cHh+sYnjDlrcLAoKgiN0g1Z2f1tC7907HNXOqHD3Lo=;
        b=H09jn9BbVjzCwyZoq6z7+4EN6dDMiHUWT7M4s3MnR8Q/d0hB7JYBNiBNNsKZP0CrnO
         E5tjtTbmugq/sI+MWsG0dg1esU7aIzmScBQKsdvwbv8v9yAXL0q9xvZ9+qVozE9TM/Aa
         7Hu/ozVUzmfdeX1N889uasL8qya7DANIqGIKtZOXbHDNxonY5gbqIqutz4QEhnD9fZl4
         UKV+2azXttGEi02J9/Vi+XLQQVhhk1ktNLYqm0WpCy/20Wq5zCL/EU/gh3xwhcYHypdj
         YJafcJN4E1ykbir/234iF8lv4rALkGV4t3i6KoGm01EzOPNukIHfRR32Ey0IUctuiXrb
         sLHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8cHh+sYnjDlrcLAoKgiN0g1Z2f1tC7907HNXOqHD3Lo=;
        b=HJtATFQ61qVpI9zj8BvaPERENIF80lK4hTTz5rbJmVPtwRsDxNrKKfMJp/BCxai3M+
         dHLZCBcjrzs7DZ4VB66lIgtshhALploPyf+SdOCh8Y/dKNBzYO/dYxi1dkbf0ut3BAMe
         PvoMR345uXpEj6RUaWQ9PHtiS9Cgi5XywJxF+Q2VRna7FMVJm7UQLoW0Q5gzKHe50TMX
         6znKWssOgmj2qygEALm0jjl5Cs/uBDxDlysaq/fLRhiNeJ+NWU0XVr0bR8C2zbtbgL5c
         wStrSGSHjFA3eKgQJ3sjuY5exW1PgJhUhZ1OtnLQtPnIJOvqP05s43C1XBQvh2fZ2qzo
         OdUw==
X-Gm-Message-State: APjAAAWKMOccYzhnMwVPEs5SwzopogcA6NEaAKLJaQ3XwCYcUVe/KZBu
        HkBE7guoWQcKCH5A7HusL0o=
X-Google-Smtp-Source: APXvYqxwxTrZjJMv/Yrcx8DXN4GuU34AMNm9wCLw0RPdw3N74GHojjGIc35aSitGVzjTTQ039itJ5w==
X-Received: by 2002:a17:902:6944:: with SMTP id k4mr1229023plt.175.1571683701402;
        Mon, 21 Oct 2019 11:48:21 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id ev20sm14502835pjb.19.2019.10.21.11.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 11:48:20 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, jakub.kicinski@netronome.com,
        johannes@sipsolutions.net, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, jiri@resnulli.us, sd@queasysnail.net,
        roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        jay.vosburgh@canonical.com, schuffelen@google.com, bjorn@mork.no
Cc:     ap420073@gmail.com
Subject: [PATCH net v5 02/10] net: core: add generic lockdep keys
Date:   Mon, 21 Oct 2019 18:47:51 +0000
Message-Id: <20191021184759.13125-2-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191021184759.13125-1-ap420073@gmail.com>
References: <20191021184759.13125-1-ap420073@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some interface types could be nested.
(VLAN, BONDING, TEAM, MACSEC, MACVLAN, IPVLAN, VIRT_WIFI, VXLAN, etc..)
These interface types should set lockdep class because, without lockdep
class key, lockdep always warn about unexisting circular locking.

In the current code, these interfaces have their own lockdep class keys and
these manage itself. So that there are so many duplicate code around the
/driver/net and /net/.
This patch adds new generic lockdep keys and some helper functions for it.

This patch does below changes.
a) Add lockdep class keys in struct net_device
   - qdisc_running, xmit, addr_list, qdisc_busylock
   - these keys are used as dynamic lockdep key.
b) When net_device is being allocated, lockdep keys are registered.
   - alloc_netdev_mqs()
c) When net_device is being free'd llockdep keys are unregistered.
   - free_netdev()
d) Add generic lockdep key helper function
   - netdev_register_lockdep_key()
   - netdev_unregister_lockdep_key()
   - netdev_update_lockdep_key()
e) Remove unnecessary generic lockdep macro and functions
f) Remove unnecessary lockdep code of each interfaces.

After this patch, each interface modules don't need to maintain
their lockdep keys.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v5 :
 - Initial patch

 drivers/net/bonding/bond_main.c               |   1 -
 .../net/ethernet/netronome/nfp/nfp_net_repr.c |  18 ---
 drivers/net/hamradio/bpqether.c               |  22 ---
 drivers/net/hyperv/netvsc_drv.c               |   2 -
 drivers/net/ipvlan/ipvlan_main.c              |   2 -
 drivers/net/macsec.c                          |   5 -
 drivers/net/macvlan.c                         |  12 --
 drivers/net/ppp/ppp_generic.c                 |   2 -
 drivers/net/team/team.c                       |   2 -
 drivers/net/vrf.c                             |   1 -
 .../net/wireless/intersil/hostap/hostap_hw.c  |  25 ----
 include/linux/netdevice.h                     |  35 ++---
 net/8021q/vlan_dev.c                          |  27 ----
 net/batman-adv/soft-interface.c               |  32 -----
 net/bluetooth/6lowpan.c                       |   8 --
 net/bridge/br_device.c                        |   8 --
 net/core/dev.c                                | 127 ++++++------------
 net/core/rtnetlink.c                          |   1 +
 net/dsa/master.c                              |   5 -
 net/dsa/slave.c                               |  12 --
 net/ieee802154/6lowpan/core.c                 |   8 --
 net/l2tp/l2tp_eth.c                           |   1 -
 net/netrom/af_netrom.c                        |  23 ----
 net/rose/af_rose.c                            |  23 ----
 net/sched/sch_generic.c                       |  17 +--
 25 files changed, 63 insertions(+), 356 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 21d8fcc83c9c..ac1b09b56c77 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4769,7 +4769,6 @@ static int bond_init(struct net_device *bond_dev)
 		return -ENOMEM;
 
 	bond->nest_level = SINGLE_DEPTH_NESTING;
-	netdev_lockdep_set_classes(bond_dev);
 
 	list_add_tail(&bond->bond_list, &bn->dev_list);
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index 1eef446036d6..79d72c88bbef 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -299,22 +299,6 @@ static void nfp_repr_clean(struct nfp_repr *repr)
 	nfp_port_free(repr->port);
 }
 
-static struct lock_class_key nfp_repr_netdev_xmit_lock_key;
-static struct lock_class_key nfp_repr_netdev_addr_lock_key;
-
-static void nfp_repr_set_lockdep_class_one(struct net_device *dev,
-					   struct netdev_queue *txq,
-					   void *_unused)
-{
-	lockdep_set_class(&txq->_xmit_lock, &nfp_repr_netdev_xmit_lock_key);
-}
-
-static void nfp_repr_set_lockdep_class(struct net_device *dev)
-{
-	lockdep_set_class(&dev->addr_list_lock, &nfp_repr_netdev_addr_lock_key);
-	netdev_for_each_tx_queue(dev, nfp_repr_set_lockdep_class_one, NULL);
-}
-
 int nfp_repr_init(struct nfp_app *app, struct net_device *netdev,
 		  u32 cmsg_port_id, struct nfp_port *port,
 		  struct net_device *pf_netdev)
@@ -324,8 +308,6 @@ int nfp_repr_init(struct nfp_app *app, struct net_device *netdev,
 	u32 repr_cap = nn->tlv_caps.repr_cap;
 	int err;
 
-	nfp_repr_set_lockdep_class(netdev);
-
 	repr->port = port;
 	repr->dst = metadata_dst_alloc(0, METADATA_HW_PORT_MUX, GFP_KERNEL);
 	if (!repr->dst)
diff --git a/drivers/net/hamradio/bpqether.c b/drivers/net/hamradio/bpqether.c
index fbec711ff514..fbea6f232819 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -107,27 +107,6 @@ struct bpqdev {
 
 static LIST_HEAD(bpq_devices);
 
-/*
- * bpqether network devices are paired with ethernet devices below them, so
- * form a special "super class" of normal ethernet devices; split their locks
- * off into a separate class since they always nest.
- */
-static struct lock_class_key bpq_netdev_xmit_lock_key;
-static struct lock_class_key bpq_netdev_addr_lock_key;
-
-static void bpq_set_lockdep_class_one(struct net_device *dev,
-				      struct netdev_queue *txq,
-				      void *_unused)
-{
-	lockdep_set_class(&txq->_xmit_lock, &bpq_netdev_xmit_lock_key);
-}
-
-static void bpq_set_lockdep_class(struct net_device *dev)
-{
-	lockdep_set_class(&dev->addr_list_lock, &bpq_netdev_addr_lock_key);
-	netdev_for_each_tx_queue(dev, bpq_set_lockdep_class_one, NULL);
-}
-
 /* ------------------------------------------------------------------------ */
 
 
@@ -498,7 +477,6 @@ static int bpq_new_device(struct net_device *edev)
 	err = register_netdevice(ndev);
 	if (err)
 		goto error;
-	bpq_set_lockdep_class(ndev);
 
 	/* List protected by RTNL */
 	list_add_rcu(&bpq->bpq_list, &bpq_devices);
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 39dddcd8b3cb..fd4fff57fd6e 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2335,8 +2335,6 @@ static int netvsc_probe(struct hv_device *dev,
 		NETIF_F_HW_VLAN_CTAG_RX;
 	net->vlan_features = net->features;
 
-	netdev_lockdep_set_classes(net);
-
 	/* MTU range: 68 - 1500 or 65521 */
 	net->min_mtu = NETVSC_MTU_MIN;
 	if (nvdev->nvsp_version >= NVSP_PROTOCOL_VERSION_2)
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index 887bbba4631e..ba3dfac1d904 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -131,8 +131,6 @@ static int ipvlan_init(struct net_device *dev)
 	dev->gso_max_segs = phy_dev->gso_max_segs;
 	dev->hard_header_len = phy_dev->hard_header_len;
 
-	netdev_lockdep_set_classes(dev);
-
 	ipvlan->pcpu_stats = netdev_alloc_pcpu_stats(struct ipvl_pcpu_stats);
 	if (!ipvlan->pcpu_stats)
 		return -ENOMEM;
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index cb7637364b40..e2a3d1d5795f 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2750,7 +2750,6 @@ static netdev_tx_t macsec_start_xmit(struct sk_buff *skb,
 
 #define MACSEC_FEATURES \
 	(NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_FRAGLIST)
-static struct lock_class_key macsec_netdev_addr_lock_key;
 
 static int macsec_dev_init(struct net_device *dev)
 {
@@ -3264,10 +3263,6 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 	dev_hold(real_dev);
 
 	macsec->nest_level = dev_get_nest_level(real_dev) + 1;
-	netdev_lockdep_set_classes(dev);
-	lockdep_set_class_and_subclass(&dev->addr_list_lock,
-				       &macsec_netdev_addr_lock_key,
-				       macsec_get_nest_level(dev));
 
 	err = netdev_upper_dev_link(real_dev, dev, extack);
 	if (err < 0)
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 940192c057b6..0354e9be2ca5 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -852,8 +852,6 @@ static int macvlan_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
  * "super class" of normal network devices; split their locks off into a
  * separate class since they always nest.
  */
-static struct lock_class_key macvlan_netdev_addr_lock_key;
-
 #define ALWAYS_ON_OFFLOADS \
 	(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_GSO_SOFTWARE | \
 	 NETIF_F_GSO_ROBUST | NETIF_F_GSO_ENCAP_ALL)
@@ -874,14 +872,6 @@ static int macvlan_get_nest_level(struct net_device *dev)
 	return ((struct macvlan_dev *)netdev_priv(dev))->nest_level;
 }
 
-static void macvlan_set_lockdep_class(struct net_device *dev)
-{
-	netdev_lockdep_set_classes(dev);
-	lockdep_set_class_and_subclass(&dev->addr_list_lock,
-				       &macvlan_netdev_addr_lock_key,
-				       macvlan_get_nest_level(dev));
-}
-
 static int macvlan_init(struct net_device *dev)
 {
 	struct macvlan_dev *vlan = netdev_priv(dev);
@@ -900,8 +890,6 @@ static int macvlan_init(struct net_device *dev)
 	dev->gso_max_segs	= lowerdev->gso_max_segs;
 	dev->hard_header_len	= lowerdev->hard_header_len;
 
-	macvlan_set_lockdep_class(dev);
-
 	vlan->pcpu_stats = netdev_alloc_pcpu_stats(struct vlan_pcpu_stats);
 	if (!vlan->pcpu_stats)
 		return -ENOMEM;
diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 9a1b006904a7..61824bbb5588 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -1324,8 +1324,6 @@ static int ppp_dev_init(struct net_device *dev)
 {
 	struct ppp *ppp;
 
-	netdev_lockdep_set_classes(dev);
-
 	ppp = netdev_priv(dev);
 	/* Let the netdevice take a reference on the ppp file. This ensures
 	 * that ppp_destroy_interface() won't run before the device gets
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index e8089def5a46..6cea83b48cad 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1642,8 +1642,6 @@ static int team_init(struct net_device *dev)
 		goto err_options_register;
 	netif_carrier_off(dev);
 
-	netdev_lockdep_set_classes(dev);
-
 	return 0;
 
 err_options_register:
diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index ee52bde058df..b8228f50bc94 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -865,7 +865,6 @@ static int vrf_dev_init(struct net_device *dev)
 
 	/* similarly, oper state is irrelevant; set to up to avoid confusion */
 	dev->operstate = IF_OPER_UP;
-	netdev_lockdep_set_classes(dev);
 	return 0;
 
 out_rth:
diff --git a/drivers/net/wireless/intersil/hostap/hostap_hw.c b/drivers/net/wireless/intersil/hostap/hostap_hw.c
index 158a3d762e55..e323e9a5999f 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_hw.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_hw.c
@@ -3041,30 +3041,6 @@ static void prism2_clear_set_tim_queue(local_info_t *local)
 	}
 }
 
-
-/*
- * HostAP uses two layers of net devices, where the inner
- * layer gets called all the time from the outer layer.
- * This is a natural nesting, which needs a split lock type.
- */
-static struct lock_class_key hostap_netdev_xmit_lock_key;
-static struct lock_class_key hostap_netdev_addr_lock_key;
-
-static void prism2_set_lockdep_class_one(struct net_device *dev,
-					 struct netdev_queue *txq,
-					 void *_unused)
-{
-	lockdep_set_class(&txq->_xmit_lock,
-			  &hostap_netdev_xmit_lock_key);
-}
-
-static void prism2_set_lockdep_class(struct net_device *dev)
-{
-	lockdep_set_class(&dev->addr_list_lock,
-			  &hostap_netdev_addr_lock_key);
-	netdev_for_each_tx_queue(dev, prism2_set_lockdep_class_one, NULL);
-}
-
 static struct net_device *
 prism2_init_local_data(struct prism2_helper_functions *funcs, int card_idx,
 		       struct device *sdev)
@@ -3223,7 +3199,6 @@ while (0)
 	if (ret >= 0)
 		ret = register_netdevice(dev);
 
-	prism2_set_lockdep_class(dev);
 	rtnl_unlock();
 	if (ret < 0) {
 		printk(KERN_WARNING "%s: register netdevice failed!\n",
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 38c5909e1c35..c93df7cf187b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -925,6 +925,7 @@ struct dev_ifalias {
 struct devlink;
 struct tlsdev_ops;
 
+
 /*
  * This structure defines the management hooks for network devices.
  * The following hooks can be defined; unless noted otherwise, they are
@@ -1760,9 +1761,13 @@ enum netdev_priv_flags {
  *	@phydev:	Physical device may attach itself
  *			for hardware timestamping
  *	@sfp_bus:	attached &struct sfp_bus structure.
- *
- *	@qdisc_tx_busylock: lockdep class annotating Qdisc->busylock spinlock
- *	@qdisc_running_key: lockdep class annotating Qdisc->running seqcount
+ *	@qdisc_tx_busylock_key: lockdep class annotating Qdisc->busylock
+				spinlock
+ *	@qdisc_running_key:	lockdep class annotating Qdisc->running seqcount
+ *	@qdisc_xmit_lock_key:	lockdep class annotating
+ *				netdev_queue->_xmit_lock spinlock
+ *	@addr_list_lock_key:	lockdep class annotating
+ *				net_device->addr_list_lock spinlock
  *
  *	@proto_down:	protocol port state information can be sent to the
  *			switch driver and used to set the phys state of the
@@ -2049,8 +2054,10 @@ struct net_device {
 #endif
 	struct phy_device	*phydev;
 	struct sfp_bus		*sfp_bus;
-	struct lock_class_key	*qdisc_tx_busylock;
-	struct lock_class_key	*qdisc_running_key;
+	struct lock_class_key	qdisc_tx_busylock_key;
+	struct lock_class_key	qdisc_running_key;
+	struct lock_class_key	qdisc_xmit_lock_key;
+	struct lock_class_key	addr_list_lock_key;
 	bool			proto_down;
 	unsigned		wol_enabled:1;
 };
@@ -2128,23 +2135,6 @@ static inline void netdev_for_each_tx_queue(struct net_device *dev,
 		f(dev, &dev->_tx[i], arg);
 }
 
-#define netdev_lockdep_set_classes(dev)				\
-{								\
-	static struct lock_class_key qdisc_tx_busylock_key;	\
-	static struct lock_class_key qdisc_running_key;		\
-	static struct lock_class_key qdisc_xmit_lock_key;	\
-	static struct lock_class_key dev_addr_list_lock_key;	\
-	unsigned int i;						\
-								\
-	(dev)->qdisc_tx_busylock = &qdisc_tx_busylock_key;	\
-	(dev)->qdisc_running_key = &qdisc_running_key;		\
-	lockdep_set_class(&(dev)->addr_list_lock,		\
-			  &dev_addr_list_lock_key); 		\
-	for (i = 0; i < (dev)->num_tx_queues; i++)		\
-		lockdep_set_class(&(dev)->_tx[i]._xmit_lock,	\
-				  &qdisc_xmit_lock_key);	\
-}
-
 u16 netdev_pick_tx(struct net_device *dev, struct sk_buff *skb,
 		     struct net_device *sb_dev);
 struct netdev_queue *netdev_core_pick_tx(struct net_device *dev,
@@ -3143,6 +3133,7 @@ static inline void netif_stop_queue(struct net_device *dev)
 }
 
 void netif_tx_stop_all_queues(struct net_device *dev);
+void netdev_update_lockdep_key(struct net_device *dev);
 
 static inline bool netif_tx_queue_stopped(const struct netdev_queue *dev_queue)
 {
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 93eadf179123..6e6f26bf6e73 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -489,31 +489,6 @@ static void vlan_dev_set_rx_mode(struct net_device *vlan_dev)
 	dev_uc_sync(vlan_dev_priv(vlan_dev)->real_dev, vlan_dev);
 }
 
-/*
- * vlan network devices have devices nesting below it, and are a special
- * "super class" of normal network devices; split their locks off into a
- * separate class since they always nest.
- */
-static struct lock_class_key vlan_netdev_xmit_lock_key;
-static struct lock_class_key vlan_netdev_addr_lock_key;
-
-static void vlan_dev_set_lockdep_one(struct net_device *dev,
-				     struct netdev_queue *txq,
-				     void *_subclass)
-{
-	lockdep_set_class_and_subclass(&txq->_xmit_lock,
-				       &vlan_netdev_xmit_lock_key,
-				       *(int *)_subclass);
-}
-
-static void vlan_dev_set_lockdep_class(struct net_device *dev, int subclass)
-{
-	lockdep_set_class_and_subclass(&dev->addr_list_lock,
-				       &vlan_netdev_addr_lock_key,
-				       subclass);
-	netdev_for_each_tx_queue(dev, vlan_dev_set_lockdep_one, &subclass);
-}
-
 static int vlan_dev_get_lock_subclass(struct net_device *dev)
 {
 	return vlan_dev_priv(dev)->nest_level;
@@ -609,8 +584,6 @@ static int vlan_dev_init(struct net_device *dev)
 
 	SET_NETDEV_DEVTYPE(dev, &vlan_type);
 
-	vlan_dev_set_lockdep_class(dev, vlan_dev_get_lock_subclass(dev));
-
 	vlan->vlan_pcpu_stats = netdev_alloc_pcpu_stats(struct vlan_pcpu_stats);
 	if (!vlan->vlan_pcpu_stats)
 		return -ENOMEM;
diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index 9cbed6f5a85a..5ee8e9a100f9 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -740,36 +740,6 @@ static int batadv_interface_kill_vid(struct net_device *dev, __be16 proto,
 	return 0;
 }
 
-/* batman-adv network devices have devices nesting below it and are a special
- * "super class" of normal network devices; split their locks off into a
- * separate class since they always nest.
- */
-static struct lock_class_key batadv_netdev_xmit_lock_key;
-static struct lock_class_key batadv_netdev_addr_lock_key;
-
-/**
- * batadv_set_lockdep_class_one() - Set lockdep class for a single tx queue
- * @dev: device which owns the tx queue
- * @txq: tx queue to modify
- * @_unused: always NULL
- */
-static void batadv_set_lockdep_class_one(struct net_device *dev,
-					 struct netdev_queue *txq,
-					 void *_unused)
-{
-	lockdep_set_class(&txq->_xmit_lock, &batadv_netdev_xmit_lock_key);
-}
-
-/**
- * batadv_set_lockdep_class() - Set txq and addr_list lockdep class
- * @dev: network device to modify
- */
-static void batadv_set_lockdep_class(struct net_device *dev)
-{
-	lockdep_set_class(&dev->addr_list_lock, &batadv_netdev_addr_lock_key);
-	netdev_for_each_tx_queue(dev, batadv_set_lockdep_class_one, NULL);
-}
-
 /**
  * batadv_softif_init_late() - late stage initialization of soft interface
  * @dev: registered network device to modify
@@ -783,8 +753,6 @@ static int batadv_softif_init_late(struct net_device *dev)
 	int ret;
 	size_t cnt_len = sizeof(u64) * BATADV_CNT_NUM;
 
-	batadv_set_lockdep_class(dev);
-
 	bat_priv = netdev_priv(dev);
 	bat_priv->soft_iface = dev;
 
diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index bb55d92691b0..4febc82a7c76 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -571,15 +571,7 @@ static netdev_tx_t bt_xmit(struct sk_buff *skb, struct net_device *netdev)
 	return err < 0 ? NET_XMIT_DROP : err;
 }
 
-static int bt_dev_init(struct net_device *dev)
-{
-	netdev_lockdep_set_classes(dev);
-
-	return 0;
-}
-
 static const struct net_device_ops netdev_ops = {
-	.ndo_init		= bt_dev_init,
 	.ndo_start_xmit		= bt_xmit,
 };
 
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 681b72862c16..e804a3016902 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -24,8 +24,6 @@
 const struct nf_br_ops __rcu *nf_br_ops __read_mostly;
 EXPORT_SYMBOL_GPL(nf_br_ops);
 
-static struct lock_class_key bridge_netdev_addr_lock_key;
-
 /* net device transmit always called with BH disabled */
 netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 {
@@ -108,11 +106,6 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 }
 
-static void br_set_lockdep_class(struct net_device *dev)
-{
-	lockdep_set_class(&dev->addr_list_lock, &bridge_netdev_addr_lock_key);
-}
-
 static int br_dev_init(struct net_device *dev)
 {
 	struct net_bridge *br = netdev_priv(dev);
@@ -150,7 +143,6 @@ static int br_dev_init(struct net_device *dev)
 		br_mdb_hash_fini(br);
 		br_fdb_hash_fini(br);
 	}
-	br_set_lockdep_class(dev);
 
 	return err;
 }
diff --git a/net/core/dev.c b/net/core/dev.c
index ab0edfc4a422..6b6d0fc65ef3 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -277,88 +277,6 @@ static RAW_NOTIFIER_HEAD(netdev_chain);
 DEFINE_PER_CPU_ALIGNED(struct softnet_data, softnet_data);
 EXPORT_PER_CPU_SYMBOL(softnet_data);
 
-#ifdef CONFIG_LOCKDEP
-/*
- * register_netdevice() inits txq->_xmit_lock and sets lockdep class
- * according to dev->type
- */
-static const unsigned short netdev_lock_type[] = {
-	 ARPHRD_NETROM, ARPHRD_ETHER, ARPHRD_EETHER, ARPHRD_AX25,
-	 ARPHRD_PRONET, ARPHRD_CHAOS, ARPHRD_IEEE802, ARPHRD_ARCNET,
-	 ARPHRD_APPLETLK, ARPHRD_DLCI, ARPHRD_ATM, ARPHRD_METRICOM,
-	 ARPHRD_IEEE1394, ARPHRD_EUI64, ARPHRD_INFINIBAND, ARPHRD_SLIP,
-	 ARPHRD_CSLIP, ARPHRD_SLIP6, ARPHRD_CSLIP6, ARPHRD_RSRVD,
-	 ARPHRD_ADAPT, ARPHRD_ROSE, ARPHRD_X25, ARPHRD_HWX25,
-	 ARPHRD_PPP, ARPHRD_CISCO, ARPHRD_LAPB, ARPHRD_DDCMP,
-	 ARPHRD_RAWHDLC, ARPHRD_TUNNEL, ARPHRD_TUNNEL6, ARPHRD_FRAD,
-	 ARPHRD_SKIP, ARPHRD_LOOPBACK, ARPHRD_LOCALTLK, ARPHRD_FDDI,
-	 ARPHRD_BIF, ARPHRD_SIT, ARPHRD_IPDDP, ARPHRD_IPGRE,
-	 ARPHRD_PIMREG, ARPHRD_HIPPI, ARPHRD_ASH, ARPHRD_ECONET,
-	 ARPHRD_IRDA, ARPHRD_FCPP, ARPHRD_FCAL, ARPHRD_FCPL,
-	 ARPHRD_FCFABRIC, ARPHRD_IEEE80211, ARPHRD_IEEE80211_PRISM,
-	 ARPHRD_IEEE80211_RADIOTAP, ARPHRD_PHONET, ARPHRD_PHONET_PIPE,
-	 ARPHRD_IEEE802154, ARPHRD_VOID, ARPHRD_NONE};
-
-static const char *const netdev_lock_name[] = {
-	"_xmit_NETROM", "_xmit_ETHER", "_xmit_EETHER", "_xmit_AX25",
-	"_xmit_PRONET", "_xmit_CHAOS", "_xmit_IEEE802", "_xmit_ARCNET",
-	"_xmit_APPLETLK", "_xmit_DLCI", "_xmit_ATM", "_xmit_METRICOM",
-	"_xmit_IEEE1394", "_xmit_EUI64", "_xmit_INFINIBAND", "_xmit_SLIP",
-	"_xmit_CSLIP", "_xmit_SLIP6", "_xmit_CSLIP6", "_xmit_RSRVD",
-	"_xmit_ADAPT", "_xmit_ROSE", "_xmit_X25", "_xmit_HWX25",
-	"_xmit_PPP", "_xmit_CISCO", "_xmit_LAPB", "_xmit_DDCMP",
-	"_xmit_RAWHDLC", "_xmit_TUNNEL", "_xmit_TUNNEL6", "_xmit_FRAD",
-	"_xmit_SKIP", "_xmit_LOOPBACK", "_xmit_LOCALTLK", "_xmit_FDDI",
-	"_xmit_BIF", "_xmit_SIT", "_xmit_IPDDP", "_xmit_IPGRE",
-	"_xmit_PIMREG", "_xmit_HIPPI", "_xmit_ASH", "_xmit_ECONET",
-	"_xmit_IRDA", "_xmit_FCPP", "_xmit_FCAL", "_xmit_FCPL",
-	"_xmit_FCFABRIC", "_xmit_IEEE80211", "_xmit_IEEE80211_PRISM",
-	"_xmit_IEEE80211_RADIOTAP", "_xmit_PHONET", "_xmit_PHONET_PIPE",
-	"_xmit_IEEE802154", "_xmit_VOID", "_xmit_NONE"};
-
-static struct lock_class_key netdev_xmit_lock_key[ARRAY_SIZE(netdev_lock_type)];
-static struct lock_class_key netdev_addr_lock_key[ARRAY_SIZE(netdev_lock_type)];
-
-static inline unsigned short netdev_lock_pos(unsigned short dev_type)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(netdev_lock_type); i++)
-		if (netdev_lock_type[i] == dev_type)
-			return i;
-	/* the last key is used by default */
-	return ARRAY_SIZE(netdev_lock_type) - 1;
-}
-
-static inline void netdev_set_xmit_lockdep_class(spinlock_t *lock,
-						 unsigned short dev_type)
-{
-	int i;
-
-	i = netdev_lock_pos(dev_type);
-	lockdep_set_class_and_name(lock, &netdev_xmit_lock_key[i],
-				   netdev_lock_name[i]);
-}
-
-static inline void netdev_set_addr_lockdep_class(struct net_device *dev)
-{
-	int i;
-
-	i = netdev_lock_pos(dev->type);
-	lockdep_set_class_and_name(&dev->addr_list_lock,
-				   &netdev_addr_lock_key[i],
-				   netdev_lock_name[i]);
-}
-#else
-static inline void netdev_set_xmit_lockdep_class(spinlock_t *lock,
-						 unsigned short dev_type)
-{
-}
-static inline void netdev_set_addr_lockdep_class(struct net_device *dev)
-{
-}
-#endif
-
 /*******************************************************************************
  *
  *		Protocol management and registration routines
@@ -8799,7 +8717,7 @@ static void netdev_init_one_queue(struct net_device *dev,
 {
 	/* Initialize queue lock */
 	spin_lock_init(&queue->_xmit_lock);
-	netdev_set_xmit_lockdep_class(&queue->_xmit_lock, dev->type);
+	lockdep_set_class(&queue->_xmit_lock, &dev->qdisc_xmit_lock_key);
 	queue->xmit_lock_owner = -1;
 	netdev_queue_numa_node_write(queue, NUMA_NO_NODE);
 	queue->dev = dev;
@@ -8846,6 +8764,43 @@ void netif_tx_stop_all_queues(struct net_device *dev)
 }
 EXPORT_SYMBOL(netif_tx_stop_all_queues);
 
+static inline void netdev_register_lockdep_key(struct net_device *dev)
+{
+	lockdep_register_key(&dev->qdisc_tx_busylock_key);
+	lockdep_register_key(&dev->qdisc_running_key);
+	lockdep_register_key(&dev->qdisc_xmit_lock_key);
+	lockdep_register_key(&dev->addr_list_lock_key);
+}
+
+static inline void netdev_unregister_lockdep_key(struct net_device *dev)
+{
+	lockdep_unregister_key(&dev->qdisc_tx_busylock_key);
+	lockdep_unregister_key(&dev->qdisc_running_key);
+	lockdep_unregister_key(&dev->qdisc_xmit_lock_key);
+	lockdep_unregister_key(&dev->addr_list_lock_key);
+}
+
+void netdev_update_lockdep_key(struct net_device *dev)
+{
+	struct netdev_queue *queue;
+	int i;
+
+	lockdep_unregister_key(&dev->qdisc_xmit_lock_key);
+	lockdep_unregister_key(&dev->addr_list_lock_key);
+
+	lockdep_register_key(&dev->qdisc_xmit_lock_key);
+	lockdep_register_key(&dev->addr_list_lock_key);
+
+	lockdep_set_class(&dev->addr_list_lock, &dev->addr_list_lock_key);
+	for (i = 0; i < dev->num_tx_queues; i++) {
+		queue = netdev_get_tx_queue(dev, i);
+
+		lockdep_set_class(&queue->_xmit_lock,
+				  &dev->qdisc_xmit_lock_key);
+	}
+}
+EXPORT_SYMBOL(netdev_update_lockdep_key);
+
 /**
  *	register_netdevice	- register a network device
  *	@dev: device to register
@@ -8880,7 +8835,7 @@ int register_netdevice(struct net_device *dev)
 	BUG_ON(!net);
 
 	spin_lock_init(&dev->addr_list_lock);
-	netdev_set_addr_lockdep_class(dev);
+	lockdep_set_class(&dev->addr_list_lock, &dev->addr_list_lock_key);
 
 	ret = dev_get_valid_name(net, dev, dev->name);
 	if (ret < 0)
@@ -9390,6 +9345,8 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 
 	dev_net_set(dev, &init_net);
 
+	netdev_register_lockdep_key(dev);
+
 	dev->gso_max_size = GSO_MAX_SIZE;
 	dev->gso_max_segs = GSO_MAX_SEGS;
 	dev->upper_level = 1;
@@ -9474,6 +9431,8 @@ void free_netdev(struct net_device *dev)
 	free_percpu(dev->pcpu_refcnt);
 	dev->pcpu_refcnt = NULL;
 
+	netdev_unregister_lockdep_key(dev);
+
 	/*  Compatibility with error handling in drivers */
 	if (dev->reg_state == NETREG_UNINITIALIZED) {
 		netdev_freemem(dev);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 1ee6460f8275..13493aae4e6c 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2355,6 +2355,7 @@ static int do_set_master(struct net_device *dev, int ifindex,
 			err = ops->ndo_del_slave(upper_dev, dev);
 			if (err)
 				return err;
+			netdev_update_lockdep_key(dev);
 		} else {
 			return -EOPNOTSUPP;
 		}
diff --git a/net/dsa/master.c b/net/dsa/master.c
index a8e52c9967f4..3255dfc97f86 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -310,8 +310,6 @@ static void dsa_master_reset_mtu(struct net_device *dev)
 	rtnl_unlock();
 }
 
-static struct lock_class_key dsa_master_addr_list_lock_key;
-
 int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 {
 	int ret;
@@ -325,9 +323,6 @@ int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 	wmb();
 
 	dev->dsa_ptr = cpu_dp;
-	lockdep_set_class(&dev->addr_list_lock,
-			  &dsa_master_addr_list_lock_key);
-
 	ret = dsa_master_ethtool_setup(dev);
 	if (ret)
 		return ret;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 75d58229a4bd..028e65f4b5ba 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1341,15 +1341,6 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 	return ret;
 }
 
-static struct lock_class_key dsa_slave_netdev_xmit_lock_key;
-static void dsa_slave_set_lockdep_class_one(struct net_device *dev,
-					    struct netdev_queue *txq,
-					    void *_unused)
-{
-	lockdep_set_class(&txq->_xmit_lock,
-			  &dsa_slave_netdev_xmit_lock_key);
-}
-
 int dsa_slave_suspend(struct net_device *slave_dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(slave_dev);
@@ -1433,9 +1424,6 @@ int dsa_slave_create(struct dsa_port *port)
 	slave_dev->max_mtu = ETH_MAX_MTU;
 	SET_NETDEV_DEVTYPE(slave_dev, &dsa_type);
 
-	netdev_for_each_tx_queue(slave_dev, dsa_slave_set_lockdep_class_one,
-				 NULL);
-
 	SET_NETDEV_DEV(slave_dev, port->ds->dev);
 	slave_dev->dev.of_node = port->dn;
 	slave_dev->vlan_features = master->vlan_features;
diff --git a/net/ieee802154/6lowpan/core.c b/net/ieee802154/6lowpan/core.c
index 3297e7fa9945..c0b107cdd715 100644
--- a/net/ieee802154/6lowpan/core.c
+++ b/net/ieee802154/6lowpan/core.c
@@ -58,13 +58,6 @@ static const struct header_ops lowpan_header_ops = {
 	.create	= lowpan_header_create,
 };
 
-static int lowpan_dev_init(struct net_device *ldev)
-{
-	netdev_lockdep_set_classes(ldev);
-
-	return 0;
-}
-
 static int lowpan_open(struct net_device *dev)
 {
 	if (!open_count)
@@ -96,7 +89,6 @@ static int lowpan_get_iflink(const struct net_device *dev)
 }
 
 static const struct net_device_ops lowpan_netdev_ops = {
-	.ndo_init		= lowpan_dev_init,
 	.ndo_start_xmit		= lowpan_xmit,
 	.ndo_open		= lowpan_open,
 	.ndo_stop		= lowpan_stop,
diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index fd5ac2788e45..d3b520b9b2c9 100644
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -56,7 +56,6 @@ static int l2tp_eth_dev_init(struct net_device *dev)
 {
 	eth_hw_addr_random(dev);
 	eth_broadcast_addr(dev->broadcast);
-	netdev_lockdep_set_classes(dev);
 
 	return 0;
 }
diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index c4f54ad2b98a..58d5373c513c 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -63,28 +63,6 @@ static DEFINE_SPINLOCK(nr_list_lock);
 
 static const struct proto_ops nr_proto_ops;
 
-/*
- * NETROM network devices are virtual network devices encapsulating NETROM
- * frames into AX.25 which will be sent through an AX.25 device, so form a
- * special "super class" of normal net devices; split their locks off into a
- * separate class since they always nest.
- */
-static struct lock_class_key nr_netdev_xmit_lock_key;
-static struct lock_class_key nr_netdev_addr_lock_key;
-
-static void nr_set_lockdep_one(struct net_device *dev,
-			       struct netdev_queue *txq,
-			       void *_unused)
-{
-	lockdep_set_class(&txq->_xmit_lock, &nr_netdev_xmit_lock_key);
-}
-
-static void nr_set_lockdep_key(struct net_device *dev)
-{
-	lockdep_set_class(&dev->addr_list_lock, &nr_netdev_addr_lock_key);
-	netdev_for_each_tx_queue(dev, nr_set_lockdep_one, NULL);
-}
-
 /*
  *	Socket removal during an interrupt is now safe.
  */
@@ -1414,7 +1392,6 @@ static int __init nr_proto_init(void)
 			free_netdev(dev);
 			goto fail;
 		}
-		nr_set_lockdep_key(dev);
 		dev_nr[i] = dev;
 	}
 
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index f0e9ccf472a9..6a0df7c8a939 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -64,28 +64,6 @@ static const struct proto_ops rose_proto_ops;
 
 ax25_address rose_callsign;
 
-/*
- * ROSE network devices are virtual network devices encapsulating ROSE
- * frames into AX.25 which will be sent through an AX.25 device, so form a
- * special "super class" of normal net devices; split their locks off into a
- * separate class since they always nest.
- */
-static struct lock_class_key rose_netdev_xmit_lock_key;
-static struct lock_class_key rose_netdev_addr_lock_key;
-
-static void rose_set_lockdep_one(struct net_device *dev,
-				 struct netdev_queue *txq,
-				 void *_unused)
-{
-	lockdep_set_class(&txq->_xmit_lock, &rose_netdev_xmit_lock_key);
-}
-
-static void rose_set_lockdep_key(struct net_device *dev)
-{
-	lockdep_set_class(&dev->addr_list_lock, &rose_netdev_addr_lock_key);
-	netdev_for_each_tx_queue(dev, rose_set_lockdep_one, NULL);
-}
-
 /*
  *	Convert a ROSE address into text.
  */
@@ -1533,7 +1511,6 @@ static int __init rose_proto_init(void)
 			free_netdev(dev);
 			goto fail;
 		}
-		rose_set_lockdep_key(dev);
 		dev_rose[i] = dev;
 	}
 
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 17bd8f539bc7..b2d34c49cbe6 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -799,9 +799,6 @@ struct Qdisc_ops pfifo_fast_ops __read_mostly = {
 };
 EXPORT_SYMBOL(pfifo_fast_ops);
 
-static struct lock_class_key qdisc_tx_busylock;
-static struct lock_class_key qdisc_running_key;
-
 struct Qdisc *qdisc_alloc(struct netdev_queue *dev_queue,
 			  const struct Qdisc_ops *ops,
 			  struct netlink_ext_ack *extack)
@@ -854,17 +851,9 @@ struct Qdisc *qdisc_alloc(struct netdev_queue *dev_queue,
 	}
 
 	spin_lock_init(&sch->busylock);
-	lockdep_set_class(&sch->busylock,
-			  dev->qdisc_tx_busylock ?: &qdisc_tx_busylock);
-
 	/* seqlock has the same scope of busylock, for NOLOCK qdisc */
 	spin_lock_init(&sch->seqlock);
-	lockdep_set_class(&sch->busylock,
-			  dev->qdisc_tx_busylock ?: &qdisc_tx_busylock);
-
 	seqcount_init(&sch->running);
-	lockdep_set_class(&sch->running,
-			  dev->qdisc_running_key ?: &qdisc_running_key);
 
 	sch->ops = ops;
 	sch->flags = ops->static_flags;
@@ -875,6 +864,12 @@ struct Qdisc *qdisc_alloc(struct netdev_queue *dev_queue,
 	dev_hold(dev);
 	refcount_set(&sch->refcnt, 1);
 
+	if (sch != &noop_qdisc) {
+		lockdep_set_class(&sch->busylock, &dev->qdisc_tx_busylock_key);
+		lockdep_set_class(&sch->seqlock, &dev->qdisc_tx_busylock_key);
+		lockdep_set_class(&sch->running, &dev->qdisc_running_key);
+	}
+
 	return sch;
 errout1:
 	kfree(p);
-- 
2.17.1

