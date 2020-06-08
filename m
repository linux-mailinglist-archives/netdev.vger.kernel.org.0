Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9DCF1F21A0
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 23:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgFHVxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 17:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbgFHVxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 17:53:10 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C28FC08C5C2
        for <netdev@vger.kernel.org>; Mon,  8 Jun 2020 14:53:10 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ga6so426482pjb.1
        for <netdev@vger.kernel.org>; Mon, 08 Jun 2020 14:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3FCciE/tT+XcLaoFynuSzwwaDM3nwO8CjCoXIU35A0s=;
        b=IGicT+5/6rZTdmmeNm0KoQ0Ng+lw+bzQXcRqBGMFtzMoHCtmNsuHW7hyIvQUwQQIhr
         CV+B0zgucRni1gPugj1+MnZP1vznG2rORRwAZr2zfY2b/xAcveyRJD0rzPa8H414wJXR
         xYyUmFgfAippCAON8pxlKaDFKMe/m7Bv6AnsF3yWOtsyHb66SbAN91ban9nk+ThIJxDX
         kN4AfGxzcHPxwqoLe2RO17o2NXWaLCK9mOZnK1JerbnzhHoxjNQZKCCfJDjX6tqDsSyz
         wyOj0CLut5OM/ANR4Ad9IdhzUCjV8UXLXAL58UAk6ARwgVvB0rRf3trYn60KsT1kvqXc
         4IUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3FCciE/tT+XcLaoFynuSzwwaDM3nwO8CjCoXIU35A0s=;
        b=b6ccsvQhtC0olNWtMLdvFx7RitWiovnr/Ylo2yYY1s5EBh/X7VrCDfL1SenoGz8TY2
         o79MQN5j0GF73l0D4nEVIk2KGYB0ahTYceoQNde1PySnbj16h9Wgtoc4gBUAdCHXTgsp
         EDUtmd06EowS0qA5y9riKaIahim9GC0brtf6w080SyadITev1MY43xjC5+3eRfSlMvDa
         VaW1Vchjoxu+GSk3+JX20I7r0Dauq2QIvpvID4gSn/UFMcxZgNnwBvZrvK9pC30iPSmY
         GIWwAJQFhvzJTtJZ2N+PHfdRPxRmlvi4cycD3zzMKB49wxBzvG++t8V6TjC7COfHozpr
         GjVA==
X-Gm-Message-State: AOAM532gKA9dZfNhKwD5ZgkK+P7hDSsKDvbwioRYU/rWw3FkTqj9FZqs
        IXlGks5jZhGrfy5/WOSt0kvx3vpm
X-Google-Smtp-Source: ABdhPJzRWpJTvNxMH6okCp7QJRGrBbowokt0Hs3fFN9iXs7AQTXXOlRsBfsh4EoFZOhv38fVzTNA4w==
X-Received: by 2002:a17:90b:3c6:: with SMTP id go6mr1367101pjb.224.1591653189411;
        Mon, 08 Jun 2020 14:53:09 -0700 (PDT)
Received: from MacBookAir.linux-6brj.site (99-174-169-255.lightspeed.sntcca.sbcglobal.net. [99.174.169.255])
        by smtp.gmail.com with ESMTPSA id n189sm8093594pfn.108.2020.06.08.14.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 14:53:08 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+f3a0e80c34b3fc28ac5e@syzkaller.appspotmail.com,
        Taehee Yoo <ap420073@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [Patch net] net: change addr_list_lock back to static key
Date:   Mon,  8 Jun 2020 14:53:01 -0700
Message-Id: <20200608215301.26772-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dynamic key update for addr_list_lock still causes troubles,
for example the following race condition still exists:

CPU 0:				CPU 1:
(RCU read lock)			(RTNL lock)
dev_mc_seq_show()		netdev_update_lockdep_key()
				  -> lockdep_unregister_key()
 -> netif_addr_lock_bh()

because lockdep doesn't provide an API to update it atomically.
Therefore, we have to move it back to static keys and use subclass
for nest locking like before.

In commit 1a33e10e4a95 ("net: partially revert dynamic lockdep key
changes"), I already reverted most parts of commit ab92d68fc22f
("net: core: add generic lockdep keys").

This patch reverts the rest and also part of commit f3b0a18bb6cb
("net: remove unnecessary variables and callback"). After this
patch, addr_list_lock changes back to using static keys and
subclasses to satisfy lockdep. Thanks to dev->lower_level, we do
not have to change back to ->ndo_get_lock_subclass().

And hopefully this reduces some syzbot lockdep noises too.

Reported-by: syzbot+f3a0e80c34b3fc28ac5e@syzkaller.appspotmail.com
Cc: Taehee Yoo <ap420073@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 drivers/net/bonding/bond_main.c               |  2 --
 drivers/net/bonding/bond_options.c            |  2 --
 drivers/net/hamradio/bpqether.c               |  2 ++
 drivers/net/macsec.c                          |  5 ++++
 drivers/net/macvlan.c                         | 13 ++++++--
 drivers/net/vxlan.c                           |  4 +--
 .../net/wireless/intersil/hostap/hostap_hw.c  |  3 ++
 include/linux/netdevice.h                     | 12 +++++---
 net/8021q/vlan_dev.c                          |  8 +++--
 net/batman-adv/soft-interface.c               |  2 ++
 net/bridge/br_device.c                        |  8 +++++
 net/core/dev.c                                | 30 ++++++++++---------
 net/core/dev_addr_lists.c                     | 12 ++++----
 net/core/rtnetlink.c                          |  1 -
 net/dsa/master.c                              |  4 +++
 net/netrom/af_netrom.c                        |  2 ++
 net/rose/af_rose.c                            |  2 ++
 17 files changed, 76 insertions(+), 36 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index a25c65d4af71..004919aea5fb 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3687,8 +3687,6 @@ static int bond_do_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cmd
 	case BOND_RELEASE_OLD:
 	case SIOCBONDRELEASE:
 		res = bond_release(bond_dev, slave_dev);
-		if (!res)
-			netdev_update_lockdep_key(slave_dev);
 		break;
 	case BOND_SETHWADDR_OLD:
 	case SIOCBONDSETHWADDR:
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 215c10923289..ddb3916d3506 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -1398,8 +1398,6 @@ static int bond_option_slaves_set(struct bonding *bond,
 	case '-':
 		slave_dbg(bond->dev, dev, "Releasing interface\n");
 		ret = bond_release(bond->dev, dev);
-		if (!ret)
-			netdev_update_lockdep_key(dev);
 		break;
 
 	default:
diff --git a/drivers/net/hamradio/bpqether.c b/drivers/net/hamradio/bpqether.c
index 60dcaf2a04a9..1ad6085994b1 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -113,6 +113,7 @@ static LIST_HEAD(bpq_devices);
  * off into a separate class since they always nest.
  */
 static struct lock_class_key bpq_netdev_xmit_lock_key;
+static struct lock_class_key bpq_netdev_addr_lock_key;
 
 static void bpq_set_lockdep_class_one(struct net_device *dev,
 				      struct netdev_queue *txq,
@@ -123,6 +124,7 @@ static void bpq_set_lockdep_class_one(struct net_device *dev,
 
 static void bpq_set_lockdep_class(struct net_device *dev)
 {
+	lockdep_set_class(&dev->addr_list_lock, &bpq_netdev_addr_lock_key);
 	netdev_for_each_tx_queue(dev, bpq_set_lockdep_class_one, NULL);
 }
 
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 20b53e255f68..e56547bfdac9 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3999,6 +3999,8 @@ static int macsec_add_dev(struct net_device *dev, sci_t sci, u8 icv_len)
 	return 0;
 }
 
+static struct lock_class_key macsec_netdev_addr_lock_key;
+
 static int macsec_newlink(struct net *net, struct net_device *dev,
 			  struct nlattr *tb[], struct nlattr *data[],
 			  struct netlink_ext_ack *extack)
@@ -4050,6 +4052,9 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 		return err;
 
 	netdev_lockdep_set_classes(dev);
+	lockdep_set_class_and_subclass(&dev->addr_list_lock,
+				       &macsec_netdev_addr_lock_key,
+				       dev->lower_level);
 
 	err = netdev_upper_dev_link(real_dev, dev, extack);
 	if (err < 0)
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 563aed5b3d9f..6a6cc9f75307 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -860,6 +860,8 @@ static int macvlan_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
  * "super class" of normal network devices; split their locks off into a
  * separate class since they always nest.
  */
+static struct lock_class_key macvlan_netdev_addr_lock_key;
+
 #define ALWAYS_ON_OFFLOADS \
 	(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_GSO_SOFTWARE | \
 	 NETIF_F_GSO_ROBUST | NETIF_F_GSO_ENCAP_ALL)
@@ -875,6 +877,14 @@ static int macvlan_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 #define MACVLAN_STATE_MASK \
 	((1<<__LINK_STATE_NOCARRIER) | (1<<__LINK_STATE_DORMANT))
 
+static void macvlan_set_lockdep_class(struct net_device *dev)
+{
+	netdev_lockdep_set_classes(dev);
+	lockdep_set_class_and_subclass(&dev->addr_list_lock,
+				       &macvlan_netdev_addr_lock_key,
+				       dev->lower_level);
+}
+
 static int macvlan_init(struct net_device *dev)
 {
 	struct macvlan_dev *vlan = netdev_priv(dev);
@@ -892,8 +902,7 @@ static int macvlan_init(struct net_device *dev)
 	dev->gso_max_size	= lowerdev->gso_max_size;
 	dev->gso_max_segs	= lowerdev->gso_max_segs;
 	dev->hard_header_len	= lowerdev->hard_header_len;
-
-	netdev_lockdep_set_classes(dev);
+	macvlan_set_lockdep_class(dev);
 
 	vlan->pcpu_stats = netdev_alloc_pcpu_stats(struct vlan_pcpu_stats);
 	if (!vlan->pcpu_stats)
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 5bb448ae6c9c..47424b2da643 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -4245,10 +4245,8 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
 		mod_timer(&vxlan->age_timer, jiffies);
 
 	netdev_adjacent_change_commit(dst->remote_dev, lowerdev, dev);
-	if (lowerdev && lowerdev != dst->remote_dev) {
+	if (lowerdev && lowerdev != dst->remote_dev)
 		dst->remote_dev = lowerdev;
-		netdev_update_lockdep_key(lowerdev);
-	}
 	vxlan_config_apply(dev, &conf, lowerdev, vxlan->net, true);
 	return 0;
 }
diff --git a/drivers/net/wireless/intersil/hostap/hostap_hw.c b/drivers/net/wireless/intersil/hostap/hostap_hw.c
index aadf3dec5bf3..2ab34cf74ecc 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_hw.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_hw.c
@@ -3048,6 +3048,7 @@ static void prism2_clear_set_tim_queue(local_info_t *local)
  * This is a natural nesting, which needs a split lock type.
  */
 static struct lock_class_key hostap_netdev_xmit_lock_key;
+static struct lock_class_key hostap_netdev_addr_lock_key;
 
 static void prism2_set_lockdep_class_one(struct net_device *dev,
 					 struct netdev_queue *txq,
@@ -3059,6 +3060,8 @@ static void prism2_set_lockdep_class_one(struct net_device *dev,
 
 static void prism2_set_lockdep_class(struct net_device *dev)
 {
+	lockdep_set_class(&dev->addr_list_lock,
+			  &hostap_netdev_addr_lock_key);
 	netdev_for_each_tx_queue(dev, prism2_set_lockdep_class_one, NULL);
 }
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 1a96e9c4ec36..e2825e27ef89 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1821,8 +1821,6 @@ enum netdev_priv_flags {
  *			for hardware timestamping
  *	@sfp_bus:	attached &struct sfp_bus structure.
  *
- *	@addr_list_lock_key:	lockdep class annotating
- *				net_device->addr_list_lock spinlock
  *	@qdisc_tx_busylock: lockdep class annotating Qdisc->busylock spinlock
  *	@qdisc_running_key: lockdep class annotating Qdisc->running seqcount
  *
@@ -2125,7 +2123,6 @@ struct net_device {
 #endif
 	struct phy_device	*phydev;
 	struct sfp_bus		*sfp_bus;
-	struct lock_class_key	addr_list_lock_key;
 	struct lock_class_key	*qdisc_tx_busylock;
 	struct lock_class_key	*qdisc_running_key;
 	bool			proto_down;
@@ -2217,10 +2214,13 @@ static inline void netdev_for_each_tx_queue(struct net_device *dev,
 	static struct lock_class_key qdisc_tx_busylock_key;	\
 	static struct lock_class_key qdisc_running_key;		\
 	static struct lock_class_key qdisc_xmit_lock_key;	\
+	static struct lock_class_key dev_addr_list_lock_key;	\
 	unsigned int i;						\
 								\
 	(dev)->qdisc_tx_busylock = &qdisc_tx_busylock_key;	\
 	(dev)->qdisc_running_key = &qdisc_running_key;		\
+	lockdep_set_class(&(dev)->addr_list_lock,		\
+			  &dev_addr_list_lock_key);		\
 	for (i = 0; i < (dev)->num_tx_queues; i++)		\
 		lockdep_set_class(&(dev)->_tx[i]._xmit_lock,	\
 				  &qdisc_xmit_lock_key);	\
@@ -3253,7 +3253,6 @@ static inline void netif_stop_queue(struct net_device *dev)
 }
 
 void netif_tx_stop_all_queues(struct net_device *dev);
-void netdev_update_lockdep_key(struct net_device *dev);
 
 static inline bool netif_tx_queue_stopped(const struct netdev_queue *dev_queue)
 {
@@ -4239,6 +4238,11 @@ static inline void netif_addr_lock(struct net_device *dev)
 	spin_lock(&dev->addr_list_lock);
 }
 
+static inline void netif_addr_lock_nested(struct net_device *dev)
+{
+	spin_lock_nested(&dev->addr_list_lock, dev->lower_level);
+}
+
 static inline void netif_addr_lock_bh(struct net_device *dev)
 {
 	spin_lock_bh(&dev->addr_list_lock);
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index f00bb57f0f60..c8d6a07e23c5 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -494,6 +494,7 @@ static void vlan_dev_set_rx_mode(struct net_device *vlan_dev)
  * separate class since they always nest.
  */
 static struct lock_class_key vlan_netdev_xmit_lock_key;
+static struct lock_class_key vlan_netdev_addr_lock_key;
 
 static void vlan_dev_set_lockdep_one(struct net_device *dev,
 				     struct netdev_queue *txq,
@@ -502,8 +503,11 @@ static void vlan_dev_set_lockdep_one(struct net_device *dev,
 	lockdep_set_class(&txq->_xmit_lock, &vlan_netdev_xmit_lock_key);
 }
 
-static void vlan_dev_set_lockdep_class(struct net_device *dev)
+static void vlan_dev_set_lockdep_class(struct net_device *dev, int subclass)
 {
+	lockdep_set_class_and_subclass(&dev->addr_list_lock,
+				       &vlan_netdev_addr_lock_key,
+				       subclass);
 	netdev_for_each_tx_queue(dev, vlan_dev_set_lockdep_one, NULL);
 }
 
@@ -597,7 +601,7 @@ static int vlan_dev_init(struct net_device *dev)
 
 	SET_NETDEV_DEVTYPE(dev, &vlan_type);
 
-	vlan_dev_set_lockdep_class(dev);
+	vlan_dev_set_lockdep_class(dev, dev->lower_level);
 
 	vlan->vlan_pcpu_stats = netdev_alloc_pcpu_stats(struct vlan_pcpu_stats);
 	if (!vlan->vlan_pcpu_stats)
diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index 0ddd80130ea3..f1f1c86f3419 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -745,6 +745,7 @@ static int batadv_interface_kill_vid(struct net_device *dev, __be16 proto,
  * separate class since they always nest.
  */
 static struct lock_class_key batadv_netdev_xmit_lock_key;
+static struct lock_class_key batadv_netdev_addr_lock_key;
 
 /**
  * batadv_set_lockdep_class_one() - Set lockdep class for a single tx queue
@@ -765,6 +766,7 @@ static void batadv_set_lockdep_class_one(struct net_device *dev,
  */
 static void batadv_set_lockdep_class(struct net_device *dev)
 {
+	lockdep_set_class(&dev->addr_list_lock, &batadv_netdev_addr_lock_key);
 	netdev_for_each_tx_queue(dev, batadv_set_lockdep_class_one, NULL);
 }
 
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 8ec1362588af..8c7b78f8bc23 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -105,6 +105,13 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 }
 
+static struct lock_class_key bridge_netdev_addr_lock_key;
+
+static void br_set_lockdep_class(struct net_device *dev)
+{
+	lockdep_set_class(&dev->addr_list_lock, &bridge_netdev_addr_lock_key);
+}
+
 static int br_dev_init(struct net_device *dev)
 {
 	struct net_bridge *br = netdev_priv(dev);
@@ -143,6 +150,7 @@ static int br_dev_init(struct net_device *dev)
 		br_fdb_hash_fini(br);
 	}
 
+	br_set_lockdep_class(dev);
 	return err;
 }
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 061496a1f640..6bc2388141f6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -439,6 +439,7 @@ static const char *const netdev_lock_name[] = {
 	"_xmit_IEEE802154", "_xmit_VOID", "_xmit_NONE"};
 
 static struct lock_class_key netdev_xmit_lock_key[ARRAY_SIZE(netdev_lock_type)];
+static struct lock_class_key netdev_addr_lock_key[ARRAY_SIZE(netdev_lock_type)];
 
 static inline unsigned short netdev_lock_pos(unsigned short dev_type)
 {
@@ -460,11 +461,25 @@ static inline void netdev_set_xmit_lockdep_class(spinlock_t *lock,
 	lockdep_set_class_and_name(lock, &netdev_xmit_lock_key[i],
 				   netdev_lock_name[i]);
 }
+
+static inline void netdev_set_addr_lockdep_class(struct net_device *dev)
+{
+	int i;
+
+	i = netdev_lock_pos(dev->type);
+	lockdep_set_class_and_name(&dev->addr_list_lock,
+				   &netdev_addr_lock_key[i],
+				   netdev_lock_name[i]);
+}
 #else
 static inline void netdev_set_xmit_lockdep_class(spinlock_t *lock,
 						 unsigned short dev_type)
 {
 }
+
+static inline void netdev_set_addr_lockdep_class(struct net_device *dev)
+{
+}
 #endif
 
 /*******************************************************************************
@@ -9373,15 +9388,6 @@ void netif_tx_stop_all_queues(struct net_device *dev)
 }
 EXPORT_SYMBOL(netif_tx_stop_all_queues);
 
-void netdev_update_lockdep_key(struct net_device *dev)
-{
-	lockdep_unregister_key(&dev->addr_list_lock_key);
-	lockdep_register_key(&dev->addr_list_lock_key);
-
-	lockdep_set_class(&dev->addr_list_lock, &dev->addr_list_lock_key);
-}
-EXPORT_SYMBOL(netdev_update_lockdep_key);
-
 /**
  *	register_netdevice	- register a network device
  *	@dev: device to register
@@ -9420,7 +9426,7 @@ int register_netdevice(struct net_device *dev)
 		return ret;
 
 	spin_lock_init(&dev->addr_list_lock);
-	lockdep_set_class(&dev->addr_list_lock, &dev->addr_list_lock_key);
+	netdev_set_addr_lockdep_class(dev);
 
 	ret = dev_get_valid_name(net, dev, dev->name);
 	if (ret < 0)
@@ -9939,8 +9945,6 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 
 	dev_net_set(dev, &init_net);
 
-	lockdep_register_key(&dev->addr_list_lock_key);
-
 	dev->gso_max_size = GSO_MAX_SIZE;
 	dev->gso_max_segs = GSO_MAX_SEGS;
 	dev->upper_level = 1;
@@ -10028,8 +10032,6 @@ void free_netdev(struct net_device *dev)
 	free_percpu(dev->xdp_bulkq);
 	dev->xdp_bulkq = NULL;
 
-	lockdep_unregister_key(&dev->addr_list_lock_key);
-
 	/*  Compatibility with error handling in drivers */
 	if (dev->reg_state == NETREG_UNINITIALIZED) {
 		netdev_freemem(dev);
diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
index 2f949b5a1eb9..6393ba930097 100644
--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -637,7 +637,7 @@ int dev_uc_sync(struct net_device *to, struct net_device *from)
 	if (to->addr_len != from->addr_len)
 		return -EINVAL;
 
-	netif_addr_lock(to);
+	netif_addr_lock_nested(to);
 	err = __hw_addr_sync(&to->uc, &from->uc, to->addr_len);
 	if (!err)
 		__dev_set_rx_mode(to);
@@ -667,7 +667,7 @@ int dev_uc_sync_multiple(struct net_device *to, struct net_device *from)
 	if (to->addr_len != from->addr_len)
 		return -EINVAL;
 
-	netif_addr_lock(to);
+	netif_addr_lock_nested(to);
 	err = __hw_addr_sync_multiple(&to->uc, &from->uc, to->addr_len);
 	if (!err)
 		__dev_set_rx_mode(to);
@@ -691,7 +691,7 @@ void dev_uc_unsync(struct net_device *to, struct net_device *from)
 		return;
 
 	netif_addr_lock_bh(from);
-	netif_addr_lock(to);
+	netif_addr_lock_nested(to);
 	__hw_addr_unsync(&to->uc, &from->uc, to->addr_len);
 	__dev_set_rx_mode(to);
 	netif_addr_unlock(to);
@@ -858,7 +858,7 @@ int dev_mc_sync(struct net_device *to, struct net_device *from)
 	if (to->addr_len != from->addr_len)
 		return -EINVAL;
 
-	netif_addr_lock(to);
+	netif_addr_lock_nested(to);
 	err = __hw_addr_sync(&to->mc, &from->mc, to->addr_len);
 	if (!err)
 		__dev_set_rx_mode(to);
@@ -888,7 +888,7 @@ int dev_mc_sync_multiple(struct net_device *to, struct net_device *from)
 	if (to->addr_len != from->addr_len)
 		return -EINVAL;
 
-	netif_addr_lock(to);
+	netif_addr_lock_nested(to);
 	err = __hw_addr_sync_multiple(&to->mc, &from->mc, to->addr_len);
 	if (!err)
 		__dev_set_rx_mode(to);
@@ -912,7 +912,7 @@ void dev_mc_unsync(struct net_device *to, struct net_device *from)
 		return;
 
 	netif_addr_lock_bh(from);
-	netif_addr_lock(to);
+	netif_addr_lock_nested(to);
 	__hw_addr_unsync(&to->mc, &from->mc, to->addr_len);
 	__dev_set_rx_mode(to);
 	netif_addr_unlock(to);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 2269199c5891..9aedc15736ad 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2462,7 +2462,6 @@ static int do_set_master(struct net_device *dev, int ifindex,
 			err = ops->ndo_del_slave(upper_dev, dev);
 			if (err)
 				return err;
-			netdev_update_lockdep_key(dev);
 		} else {
 			return -EOPNOTSUPP;
 		}
diff --git a/net/dsa/master.c b/net/dsa/master.c
index a621367c6e8c..480a61460c23 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -327,6 +327,8 @@ static void dsa_master_reset_mtu(struct net_device *dev)
 	rtnl_unlock();
 }
 
+static struct lock_class_key dsa_master_addr_list_lock_key;
+
 int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 {
 	int ret;
@@ -345,6 +347,8 @@ int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 	wmb();
 
 	dev->dsa_ptr = cpu_dp;
+	lockdep_set_class(&dev->addr_list_lock,
+			  &dsa_master_addr_list_lock_key);
 	ret = dsa_master_ethtool_setup(dev);
 	if (ret)
 		return ret;
diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index eccc7d366e17..f90ef6934b8f 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -70,6 +70,7 @@ static const struct proto_ops nr_proto_ops;
  * separate class since they always nest.
  */
 static struct lock_class_key nr_netdev_xmit_lock_key;
+static struct lock_class_key nr_netdev_addr_lock_key;
 
 static void nr_set_lockdep_one(struct net_device *dev,
 			       struct netdev_queue *txq,
@@ -80,6 +81,7 @@ static void nr_set_lockdep_one(struct net_device *dev,
 
 static void nr_set_lockdep_key(struct net_device *dev)
 {
+	lockdep_set_class(&dev->addr_list_lock, &nr_netdev_addr_lock_key);
 	netdev_for_each_tx_queue(dev, nr_set_lockdep_one, NULL);
 }
 
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index e7a872207b46..ce85656ac9c1 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -71,6 +71,7 @@ ax25_address rose_callsign;
  * separate class since they always nest.
  */
 static struct lock_class_key rose_netdev_xmit_lock_key;
+static struct lock_class_key rose_netdev_addr_lock_key;
 
 static void rose_set_lockdep_one(struct net_device *dev,
 				 struct netdev_queue *txq,
@@ -81,6 +82,7 @@ static void rose_set_lockdep_one(struct net_device *dev,
 
 static void rose_set_lockdep_key(struct net_device *dev)
 {
+	lockdep_set_class(&dev->addr_list_lock, &rose_netdev_addr_lock_key);
 	netdev_for_each_tx_queue(dev, rose_set_lockdep_one, NULL);
 }
 
-- 
2.26.2

