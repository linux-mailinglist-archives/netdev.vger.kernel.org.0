Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B633E1F7BFE
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 19:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgFLRDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 13:03:32 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:43544 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726463AbgFLRDV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jun 2020 13:03:21 -0400
X-Greylist: delayed 670 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Jun 2020 13:02:58 EDT
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 05CGpXZr019363
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 12 Jun 2020 18:51:34 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Donald Sharp <sharpd@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Dinesh Dutt <didutt@gmail.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [RFC,net-next, 2/5] vrf: track associations between VRF devices and tables
Date:   Fri, 12 Jun 2020 18:49:34 +0200
Message-Id: <20200612164937.5468-3-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200612164937.5468-1-andrea.mayer@uniroma2.it>
References: <20200612164937.5468-1-andrea.mayer@uniroma2.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the data structures and the processing logic to keep track of the
associations between VRF devices and routing tables.
When a VRF is instantiated, it needs to refer to a given routing table.
For each table, we explicitly keep track of the existing VRFs that refer to
the table.

Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
---
 drivers/net/vrf.c | 272 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 267 insertions(+), 5 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 43928a1c2f2a..f772aac6a04c 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -21,6 +21,7 @@
 #include <net/rtnetlink.h>
 #include <linux/u64_stats_sync.h>
 #include <linux/hashtable.h>
+#include <linux/spinlock_types.h>
 
 #include <linux/inetdevice.h>
 #include <net/arp.h>
@@ -35,12 +36,74 @@
 #include <net/netns/generic.h>
 
 #define DRV_NAME	"vrf"
-#define DRV_VERSION	"1.0"
+#define DRV_VERSION	"1.1"
 
 #define FIB_RULE_PREF  1000       /* default preference for FIB rules */
 
+#define HT_MAP_BITS	4
+#define HASH_INITVAL	((u32)0xcafef00d)
+
+struct  vrf_map {
+	DECLARE_HASHTABLE(ht, HT_MAP_BITS);
+	spinlock_t vmap_lock;
+
+	/* shared_tables:
+	 * count how many distinct tables does not comply with the
+	 * strict mode requirement.
+	 * shared_table value must be 0 in order to switch to strict mode.
+	 *
+	 * example of evolution of shared_table:
+	 *                                                        | time
+	 * add  vrf0 --> table 100        shared_tables = 0       | t0
+	 * add  vrf1 --> table 101        shared_tables = 0       | t1
+	 * add  vrf2 --> table 100        shared_tables = 1       | t2
+	 * add  vrf3 --> table 100        shared_tables = 1       | t3
+	 * add  vrf4 --> table 101        shared_tables = 2       v t4
+	 *
+	 * shared_tables is a "step function" (or "staircase function")
+	 * and is increased by one when the second vrf is associated to a table
+	 *
+	 * at t2, vrf0 and vrf2 are bound to table 100: shared_table = 1.
+	 *
+	 * at t3, another dev (vrf3) is bound to the same table 100 but the
+	 * shared_table counters is still 1.
+	 * This means that no matter how many new vrfs will register on the
+	 * table 100, the shared_table will not increase (considering only
+	 * table 100).
+	 *
+	 * at t4, vrf4 is bound to table 101, and shared_table = 2.
+	 *
+	 * Looking at the value of shared_tables we can immediately know if
+	 * the strict_mode can or cannot be enforced. Indeed, strict_mode
+	 * can be enforced iff shared_table = 0.
+	 *
+	 * Conversely, shared_table is decreased when a vrf is de-associated
+	 * from a table with exactly two associated vrfs.
+	 */
+	int shared_tables;
+
+	bool strict_mode;
+};
+
+struct vrf_map_elem {
+	struct hlist_node hnode;
+	struct list_head vrf_list;  /* VRFs registered to this table */
+
+	u32 table_id;
+	int users;
+	int ifindex;
+};
+
 static unsigned int vrf_net_id;
 
+/* per netns vrf data */
+struct netns_vrf {
+	/* protected by rtnl lock */
+	bool add_fib_rules;
+
+	struct vrf_map vmap;
+};
+
 struct net_vrf {
 	struct rtable __rcu	*rth;
 	struct rt6_info	__rcu	*rt6;
@@ -48,6 +111,9 @@ struct net_vrf {
 	struct fib6_table	*fib6_table;
 #endif
 	u32                     tb_id;
+
+	struct list_head	me_list;   /* entry in vrf_map_elem */
+	int			ifindex;
 };
 
 struct pcpu_dstats {
@@ -103,6 +169,173 @@ static void vrf_get_stats64(struct net_device *dev,
 	}
 }
 
+static struct vrf_map *netns_vrf_map(struct net *net)
+{
+	struct netns_vrf *nn_vrf = net_generic(net, vrf_net_id);
+
+	return &nn_vrf->vmap;
+}
+
+static struct vrf_map *netns_vrf_map_by_dev(struct net_device *dev)
+{
+	return netns_vrf_map(dev_net(dev));
+}
+
+static struct vrf_map_elem *vrf_map_elem_alloc(gfp_t flags)
+{
+	struct vrf_map_elem *me;
+
+	me = kmalloc(sizeof(*me), flags);
+	if (!me)
+		return NULL;
+
+	return me;
+}
+
+static void vrf_map_elem_free(struct vrf_map_elem *me)
+{
+	kfree(me);
+}
+
+static void vrf_map_elem_init(struct vrf_map_elem *me, int table_id,
+			      int ifindex, int users)
+{
+	me->table_id = table_id;
+	me->ifindex = ifindex;
+	me->users = users;
+	INIT_LIST_HEAD(&me->vrf_list);
+}
+
+static struct vrf_map_elem *vrf_map_lookup_elem(struct vrf_map *vmap,
+						u32 table_id)
+{
+	struct vrf_map_elem *me;
+	u32 key;
+
+	key = jhash_1word(table_id, HASH_INITVAL);
+	hash_for_each_possible(vmap->ht, me, hnode, key) {
+		if (me->table_id == table_id)
+			return me;
+	}
+
+	return NULL;
+}
+
+static void vrf_map_add_elem(struct vrf_map *vmap, struct vrf_map_elem *me)
+{
+	u32 table_id = me->table_id;
+	u32 key;
+
+	key = jhash_1word(table_id, HASH_INITVAL);
+	hash_add(vmap->ht, &me->hnode, key);
+}
+
+static void vrf_map_del_elem(struct vrf_map_elem *me)
+{
+	hash_del(&me->hnode);
+}
+
+static void vrf_map_lock(struct vrf_map *vmap) __acquires(&vmap->vmap_lock)
+{
+	spin_lock(&vmap->vmap_lock);
+}
+
+static void vrf_map_unlock(struct vrf_map *vmap) __releases(&vmap->vmap_lock)
+{
+	spin_unlock(&vmap->vmap_lock);
+}
+
+/* called with rtnl lock held */
+static int
+vrf_map_register_dev(struct net_device *dev, struct netlink_ext_ack *extack)
+{
+	struct vrf_map *vmap = netns_vrf_map_by_dev(dev);
+	struct net_vrf *vrf = netdev_priv(dev);
+	struct vrf_map_elem *new_me, *me;
+	u32 table_id = vrf->tb_id;
+	bool free_new_me = false;
+	int users;
+	int res;
+
+	/* we pre-allocate elements used in the spin-locked section (so that we
+	 * keep the spinlock as short as possibile).
+	 */
+	new_me = vrf_map_elem_alloc(GFP_KERNEL);
+	if (!new_me)
+		return -ENOMEM;
+
+	vrf_map_elem_init(new_me, table_id, dev->ifindex, 0);
+
+	vrf_map_lock(vmap);
+
+	me = vrf_map_lookup_elem(vmap, table_id);
+	if (!me) {
+		me = new_me;
+		vrf_map_add_elem(vmap, me);
+		goto link_vrf;
+	}
+
+	/* we already have an entry in the vrf_map, so it means there is (at
+	 * least) a vrf registered on the specific table.
+	 */
+	free_new_me = true;
+	if (vmap->strict_mode) {
+		/* vrfs cannot share the same table */
+		NL_SET_ERR_MSG(extack, "Table is used by another VRF");
+		res = -EBUSY;
+		goto unlock;
+	}
+
+link_vrf:
+	users = ++me->users;
+	if (users == 2)
+		++vmap->shared_tables;
+
+	list_add(&vrf->me_list, &me->vrf_list);
+
+	res = 0;
+
+unlock:
+	vrf_map_unlock(vmap);
+
+	/* clean-up, if needed */
+	if (free_new_me)
+		vrf_map_elem_free(new_me);
+
+	return res;
+}
+
+/* called with rtnl lock held */
+static void vrf_map_unregister_dev(struct net_device *dev)
+{
+	struct vrf_map *vmap = netns_vrf_map_by_dev(dev);
+	struct net_vrf *vrf = netdev_priv(dev);
+	u32 table_id = vrf->tb_id;
+	struct vrf_map_elem *me;
+	int users;
+
+	vrf_map_lock(vmap);
+
+	me = vrf_map_lookup_elem(vmap, table_id);
+	if (!me)
+		goto unlock;
+
+	list_del(&vrf->me_list);
+
+	users = --me->users;
+	if (users == 1) {
+		--vmap->shared_tables;
+	} else if (users == 0) {
+		vrf_map_del_elem(me);
+
+		/* no one will refer to this element anymore */
+		vrf_map_elem_free(me);
+	}
+
+unlock:
+	vrf_map_unlock(vmap);
+}
+
 /* by default VRF devices do not have a qdisc and are expected
  * to be created with only a single queue.
  */
@@ -1319,6 +1552,8 @@ static void vrf_dellink(struct net_device *dev, struct list_head *head)
 	netdev_for_each_lower_dev(dev, port_dev, iter)
 		vrf_del_slave(dev, port_dev);
 
+	vrf_map_unregister_dev(dev);
+
 	unregister_netdevice_queue(dev, head);
 }
 
@@ -1327,6 +1562,7 @@ static int vrf_newlink(struct net *src_net, struct net_device *dev,
 		       struct netlink_ext_ack *extack)
 {
 	struct net_vrf *vrf = netdev_priv(dev);
+	struct netns_vrf *nn_vrf;
 	bool *add_fib_rules;
 	struct net *net;
 	int err;
@@ -1349,11 +1585,26 @@ static int vrf_newlink(struct net *src_net, struct net_device *dev,
 	if (err)
 		goto out;
 
+	/* mapping between table_id and vrf;
+	 * note: such binding could not be done in the dev init function
+	 * because dev->ifindex id is not available yet.
+	 */
+	vrf->ifindex = dev->ifindex;
+
+	err = vrf_map_register_dev(dev, extack);
+	if (err) {
+		unregister_netdevice(dev);
+		goto out;
+	}
+
 	net = dev_net(dev);
-	add_fib_rules = net_generic(net, vrf_net_id);
+	nn_vrf = net_generic(net, vrf_net_id);
+
+	add_fib_rules = &nn_vrf->add_fib_rules;
 	if (*add_fib_rules) {
 		err = vrf_add_fib_rules(dev);
 		if (err) {
+			vrf_map_unregister_dev(dev);
 			unregister_netdevice(dev);
 			goto out;
 		}
@@ -1440,12 +1691,23 @@ static struct notifier_block vrf_notifier_block __read_mostly = {
 	.notifier_call = vrf_device_event,
 };
 
+static int vrf_map_init(struct vrf_map *vmap)
+{
+	spin_lock_init(&vmap->vmap_lock);
+	hash_init(vmap->ht);
+
+	vmap->strict_mode = false;
+
+	return 0;
+}
+
 /* Initialize per network namespace state */
 static int __net_init vrf_netns_init(struct net *net)
 {
-	bool *add_fib_rules = net_generic(net, vrf_net_id);
+	struct netns_vrf *nn_vrf = net_generic(net, vrf_net_id);
 
-	*add_fib_rules = true;
+	nn_vrf->add_fib_rules = true;
+	vrf_map_init(&nn_vrf->vmap);
 
 	return 0;
 }
@@ -1453,7 +1715,7 @@ static int __net_init vrf_netns_init(struct net *net)
 static struct pernet_operations vrf_net_ops __net_initdata = {
 	.init = vrf_netns_init,
 	.id   = &vrf_net_id,
-	.size = sizeof(bool),
+	.size = sizeof(struct netns_vrf),
 };
 
 static int __init vrf_init_module(void)
-- 
2.20.1

