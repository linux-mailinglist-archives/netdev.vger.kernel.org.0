Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C12737149
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 12:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728211AbfFFKIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 06:08:06 -0400
Received: from regular1.263xmail.com ([211.150.70.196]:41064 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728058AbfFFKIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 06:08:04 -0400
X-Greylist: delayed 481 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Jun 2019 06:08:02 EDT
Received: from jiaolitao?raisecom.com (unknown [192.168.167.231])
        by regular1.263xmail.com (Postfix) with ESMTP id A2C1381E;
        Thu,  6 Jun 2019 17:59:51 +0800 (CST)
X-263anti-spam: KSV:0;BIG:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ADDR-CHECKED: 0
X-ABS-CHECKED: 1
X-SKE-CHECKED: 1
X-ANTISPAM-LEVEL: 2
Received: from localhost.localdomain (194.195.37.106.static.bjtelecom.net [106.37.195.194])
        by smtp.263.net (postfix) whith ESMTP id P11377T140226221557504S1559815148043212_;
        Thu, 06 Jun 2019 17:59:49 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <461dc0c530c87eed0f1ca3db33067cfe>
X-RL-SENDER: jiaolitao@raisecom.com
X-SENDER: 006714@raisecom.com
X-LOGIN-NAME: jiaolitao@raisecom.com
X-FST-TO: davem@davemloft.net
X-SENDER-IP: 106.37.195.194
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 5
From:   Litao jiao <jiaolitao@raisecom.com>
To:     davem@davemloft.net
Cc:     petrm@mellanox.com, idosch@mellanox.com, roopa@cumulusnetworks.com,
        sd@queasysnail.net, sbrivio@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jiaolitao@raisecom.com
Subject: [PATCH] vxlan: Use FDB_HASH_SIZE hash_locks to reduce contention
Date:   Thu,  6 Jun 2019 17:57:58 +0800
Message-Id: <1559815078-5901-1-git-send-email-jiaolitao@raisecom.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The monolithic hash_lock could cause huge contention when
inserting/deletiing vxlan_fdbs into the fdb_head.

Use FDB_HASH_SIZE hash_locks to protect insertions/deletions
of vxlan_fdbs into the fdb_head hash table.

Suggested-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Litao jiao <jiaolitao@raisecom.com>
---
 drivers/net/vxlan.c | 92 ++++++++++++++++++++++++++++++++++-------------------
 include/net/vxlan.h |  2 +-
 2 files changed, 60 insertions(+), 34 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 5994d54..9f93c5e 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -471,14 +471,19 @@ static u32 eth_vni_hash(const unsigned char *addr, __be32 vni)
 	return jhash_2words(key, vni, vxlan_salt) & (FDB_HASH_SIZE - 1);
 }
 
+static u32 fdb_head_index(struct vxlan_dev *vxlan, const u8 *mac, __be32 vni)
+{
+	if (vxlan->cfg.flags & VXLAN_F_COLLECT_METADATA)
+		return eth_vni_hash(mac, vni);
+	else
+		return eth_hash(mac);
+}
+
 /* Hash chain to use given mac address */
 static inline struct hlist_head *vxlan_fdb_head(struct vxlan_dev *vxlan,
 						const u8 *mac, __be32 vni)
 {
-	if (vxlan->cfg.flags & VXLAN_F_COLLECT_METADATA)
-		return &vxlan->fdb_head[eth_vni_hash(mac, vni)];
-	else
-		return &vxlan->fdb_head[eth_hash(mac)];
+	return &vxlan->fdb_head[fdb_head_index(vxlan, mac, vni)];
 }
 
 /* Look up Ethernet address in forwarding table */
@@ -593,8 +598,8 @@ int vxlan_fdb_replay(const struct net_device *dev, __be32 vni,
 		return -EINVAL;
 	vxlan = netdev_priv(dev);
 
-	spin_lock_bh(&vxlan->hash_lock);
 	for (h = 0; h < FDB_HASH_SIZE; ++h) {
+		spin_lock_bh(&vxlan->hash_lock[h]);
 		hlist_for_each_entry(f, &vxlan->fdb_head[h], hlist) {
 			if (f->vni == vni) {
 				list_for_each_entry(rdst, &f->remotes, list) {
@@ -602,14 +607,16 @@ int vxlan_fdb_replay(const struct net_device *dev, __be32 vni,
 								  f, rdst,
 								  extack);
 					if (rc)
-						goto out;
+						goto unlock;
 				}
 			}
 		}
+		spin_unlock_bh(&vxlan->hash_lock[h]);
 	}
+	return 0;
 
-out:
-	spin_unlock_bh(&vxlan->hash_lock);
+unlock:
+	spin_unlock_bh(&vxlan->hash_lock[h]);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(vxlan_fdb_replay);
@@ -625,14 +632,15 @@ void vxlan_fdb_clear_offload(const struct net_device *dev, __be32 vni)
 		return;
 	vxlan = netdev_priv(dev);
 
-	spin_lock_bh(&vxlan->hash_lock);
 	for (h = 0; h < FDB_HASH_SIZE; ++h) {
+		spin_lock_bh(&vxlan->hash_lock[h]);
 		hlist_for_each_entry(f, &vxlan->fdb_head[h], hlist)
 			if (f->vni == vni)
 				list_for_each_entry(rdst, &f->remotes, list)
 					rdst->offloaded = false;
+		spin_unlock_bh(&vxlan->hash_lock[h]);
 	}
-	spin_unlock_bh(&vxlan->hash_lock);
+
 }
 EXPORT_SYMBOL_GPL(vxlan_fdb_clear_offload);
 
@@ -1108,6 +1116,7 @@ static int vxlan_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 	__be16 port;
 	__be32 src_vni, vni;
 	u32 ifindex;
+	u32 hash_index;
 	int err;
 
 	if (!(ndm->ndm_state & (NUD_PERMANENT|NUD_REACHABLE))) {
@@ -1126,12 +1135,13 @@ static int vxlan_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 	if (vxlan->default_dst.remote_ip.sa.sa_family != ip.sa.sa_family)
 		return -EAFNOSUPPORT;
 
-	spin_lock_bh(&vxlan->hash_lock);
+	hash_index = fdb_head_index(vxlan, addr, src_vni);
+	spin_lock_bh(&vxlan->hash_lock[hash_index]);
 	err = vxlan_fdb_update(vxlan, addr, &ip, ndm->ndm_state, flags,
 			       port, src_vni, vni, ifindex,
 			       ndm->ndm_flags | NTF_VXLAN_ADDED_BY_USER,
 			       true, extack);
-	spin_unlock_bh(&vxlan->hash_lock);
+	spin_unlock_bh(&vxlan->hash_lock[hash_index]);
 
 	return err;
 }
@@ -1179,16 +1189,18 @@ static int vxlan_fdb_delete(struct ndmsg *ndm, struct nlattr *tb[],
 	__be32 src_vni, vni;
 	__be16 port;
 	u32 ifindex;
+	u32 hash_index;
 	int err;
 
 	err = vxlan_fdb_parse(tb, vxlan, &ip, &port, &src_vni, &vni, &ifindex);
 	if (err)
 		return err;
 
-	spin_lock_bh(&vxlan->hash_lock);
+	hash_index = fdb_head_index(vxlan, addr, src_vni);
+	spin_lock_bh(&vxlan->hash_lock[hash_index]);
 	err = __vxlan_fdb_delete(vxlan, addr, ip, port, src_vni, vni, ifindex,
 				 true);
-	spin_unlock_bh(&vxlan->hash_lock);
+	spin_unlock_bh(&vxlan->hash_lock[hash_index]);
 
 	return err;
 }
@@ -1300,8 +1312,10 @@ static bool vxlan_snoop(struct net_device *dev,
 		f->updated = jiffies;
 		vxlan_fdb_notify(vxlan, f, rdst, RTM_NEWNEIGH, true, NULL);
 	} else {
+		u32 hash_index = fdb_head_index(vxlan, src_mac, vni);
+
 		/* learned new entry */
-		spin_lock(&vxlan->hash_lock);
+		spin_lock(&vxlan->hash_lock[hash_index]);
 
 		/* close off race between vxlan_flush and incoming packets */
 		if (netif_running(dev))
@@ -1312,7 +1326,7 @@ static bool vxlan_snoop(struct net_device *dev,
 					 vni,
 					 vxlan->default_dst.remote_vni,
 					 ifindex, NTF_SELF, true, NULL);
-		spin_unlock(&vxlan->hash_lock);
+		spin_unlock(&vxlan->hash_lock[hash_index]);
 	}
 
 	return false;
@@ -2702,7 +2716,7 @@ static void vxlan_cleanup(struct timer_list *t)
 	for (h = 0; h < FDB_HASH_SIZE; ++h) {
 		struct hlist_node *p, *n;
 
-		spin_lock(&vxlan->hash_lock);
+		spin_lock(&vxlan->hash_lock[h]);
 		hlist_for_each_safe(p, n, &vxlan->fdb_head[h]) {
 			struct vxlan_fdb *f
 				= container_of(p, struct vxlan_fdb, hlist);
@@ -2724,7 +2738,7 @@ static void vxlan_cleanup(struct timer_list *t)
 			} else if (time_before(timeout, next_timer))
 				next_timer = timeout;
 		}
-		spin_unlock(&vxlan->hash_lock);
+		spin_unlock(&vxlan->hash_lock[h]);
 	}
 
 	mod_timer(&vxlan->age_timer, next_timer);
@@ -2767,12 +2781,13 @@ static int vxlan_init(struct net_device *dev)
 static void vxlan_fdb_delete_default(struct vxlan_dev *vxlan, __be32 vni)
 {
 	struct vxlan_fdb *f;
+	u32 hash_index = fdb_head_index(vxlan, all_zeros_mac, vni);
 
-	spin_lock_bh(&vxlan->hash_lock);
+	spin_lock_bh(&vxlan->hash_lock[hash_index]);
 	f = __vxlan_find_mac(vxlan, all_zeros_mac, vni);
 	if (f)
 		vxlan_fdb_destroy(vxlan, f, true, true);
-	spin_unlock_bh(&vxlan->hash_lock);
+	spin_unlock_bh(&vxlan->hash_lock[hash_index]);
 }
 
 static void vxlan_uninit(struct net_device *dev)
@@ -2817,9 +2832,10 @@ static void vxlan_flush(struct vxlan_dev *vxlan, bool do_all)
 {
 	unsigned int h;
 
-	spin_lock_bh(&vxlan->hash_lock);
 	for (h = 0; h < FDB_HASH_SIZE; ++h) {
 		struct hlist_node *p, *n;
+
+		spin_lock_bh(&vxlan->hash_lock[h]);
 		hlist_for_each_safe(p, n, &vxlan->fdb_head[h]) {
 			struct vxlan_fdb *f
 				= container_of(p, struct vxlan_fdb, hlist);
@@ -2829,8 +2845,8 @@ static void vxlan_flush(struct vxlan_dev *vxlan, bool do_all)
 			if (!is_zero_ether_addr(f->eth_addr))
 				vxlan_fdb_destroy(vxlan, f, true, true);
 		}
+		spin_unlock_bh(&vxlan->hash_lock[h]);
 	}
-	spin_unlock_bh(&vxlan->hash_lock);
 }
 
 /* Cleanup timer and forwarding table on shutdown */
@@ -3014,7 +3030,6 @@ static void vxlan_setup(struct net_device *dev)
 	dev->max_mtu = ETH_MAX_MTU;
 
 	INIT_LIST_HEAD(&vxlan->next);
-	spin_lock_init(&vxlan->hash_lock);
 
 	timer_setup(&vxlan->age_timer, vxlan_cleanup, TIMER_DEFERRABLE);
 
@@ -3022,8 +3037,10 @@ static void vxlan_setup(struct net_device *dev)
 
 	gro_cells_init(&vxlan->gro_cells, dev);
 
-	for (h = 0; h < FDB_HASH_SIZE; ++h)
+	for (h = 0; h < FDB_HASH_SIZE; ++h) {
+		spin_lock_init(&vxlan->hash_lock[h]);
 		INIT_HLIST_HEAD(&vxlan->fdb_head[h]);
+	}
 }
 
 static void vxlan_ether_setup(struct net_device *dev)
@@ -3917,7 +3934,9 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
 
 	/* handle default dst entry */
 	if (!vxlan_addr_equal(&conf.remote_ip, &dst->remote_ip)) {
-		spin_lock_bh(&vxlan->hash_lock);
+		u32 hash_index = fdb_head_index(vxlan, all_zeros_mac, conf.vni);
+
+		spin_lock_bh(&vxlan->hash_lock[hash_index]);
 		if (!vxlan_addr_any(&conf.remote_ip)) {
 			err = vxlan_fdb_update(vxlan, all_zeros_mac,
 					       &conf.remote_ip,
@@ -3928,7 +3947,7 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
 					       conf.remote_ifindex,
 					       NTF_SELF, true, extack);
 			if (err) {
-				spin_unlock_bh(&vxlan->hash_lock);
+				spin_unlock_bh(&vxlan->hash_lock[hash_index]);
 				return err;
 			}
 		}
@@ -3940,7 +3959,7 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
 					   dst->remote_vni,
 					   dst->remote_ifindex,
 					   true);
-		spin_unlock_bh(&vxlan->hash_lock);
+		spin_unlock_bh(&vxlan->hash_lock[hash_index]);
 	}
 
 	if (conf.age_interval != vxlan->cfg.age_interval)
@@ -4195,8 +4214,11 @@ vxlan_fdb_offloaded_set(struct net_device *dev,
 	struct vxlan_dev *vxlan = netdev_priv(dev);
 	struct vxlan_rdst *rdst;
 	struct vxlan_fdb *f;
+	u32 hash_index;
+
+	hash_index = fdb_head_index(vxlan, fdb_info->eth_addr, fdb_info->vni);
 
-	spin_lock_bh(&vxlan->hash_lock);
+	spin_lock_bh(&vxlan->hash_lock[hash_index]);
 
 	f = vxlan_find_mac(vxlan, fdb_info->eth_addr, fdb_info->vni);
 	if (!f)
@@ -4212,7 +4234,7 @@ vxlan_fdb_offloaded_set(struct net_device *dev,
 	rdst->offloaded = fdb_info->offloaded;
 
 out:
-	spin_unlock_bh(&vxlan->hash_lock);
+	spin_unlock_bh(&vxlan->hash_lock[hash_index]);
 }
 
 static int
@@ -4221,11 +4243,13 @@ vxlan_fdb_external_learn_add(struct net_device *dev,
 {
 	struct vxlan_dev *vxlan = netdev_priv(dev);
 	struct netlink_ext_ack *extack;
+	u32 hash_index;
 	int err;
 
+	hash_index = fdb_head_index(vxlan, fdb_info->eth_addr, fdb_info->vni);
 	extack = switchdev_notifier_info_to_extack(&fdb_info->info);
 
-	spin_lock_bh(&vxlan->hash_lock);
+	spin_lock_bh(&vxlan->hash_lock[hash_index]);
 	err = vxlan_fdb_update(vxlan, fdb_info->eth_addr, &fdb_info->remote_ip,
 			       NUD_REACHABLE,
 			       NLM_F_CREATE | NLM_F_REPLACE,
@@ -4235,7 +4259,7 @@ vxlan_fdb_external_learn_add(struct net_device *dev,
 			       fdb_info->remote_ifindex,
 			       NTF_USE | NTF_SELF | NTF_EXT_LEARNED,
 			       false, extack);
-	spin_unlock_bh(&vxlan->hash_lock);
+	spin_unlock_bh(&vxlan->hash_lock[hash_index]);
 
 	return err;
 }
@@ -4246,9 +4270,11 @@ vxlan_fdb_external_learn_del(struct net_device *dev,
 {
 	struct vxlan_dev *vxlan = netdev_priv(dev);
 	struct vxlan_fdb *f;
+	u32 hash_index;
 	int err = 0;
 
-	spin_lock_bh(&vxlan->hash_lock);
+	hash_index = fdb_head_index(vxlan, fdb_info->eth_addr, fdb_info->vni);
+	spin_lock_bh(&vxlan->hash_lock[hash_index]);
 
 	f = vxlan_find_mac(vxlan, fdb_info->eth_addr, fdb_info->vni);
 	if (!f)
@@ -4262,7 +4288,7 @@ vxlan_fdb_external_learn_del(struct net_device *dev,
 					 fdb_info->remote_ifindex,
 					 false);
 
-	spin_unlock_bh(&vxlan->hash_lock);
+	spin_unlock_bh(&vxlan->hash_lock[hash_index]);
 
 	return err;
 }
diff --git a/include/net/vxlan.h b/include/net/vxlan.h
index 83b5999..dc1583a 100644
--- a/include/net/vxlan.h
+++ b/include/net/vxlan.h
@@ -242,7 +242,7 @@ struct vxlan_dev {
 	struct vxlan_rdst default_dst;	/* default destination */
 
 	struct timer_list age_timer;
-	spinlock_t	  hash_lock;
+	spinlock_t	  hash_lock[FDB_HASH_SIZE];
 	unsigned int	  addrcnt;
 	struct gro_cells  gro_cells;
 
-- 
2.7.4



