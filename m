Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D61451AD44
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 20:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377310AbiEDSvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 14:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348410AbiEDSvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 14:51:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 28F9A165B5
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 11:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651690084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=IhgVURhgbuNXOQlJlrqsFaU1eyQ9iz5LQpBl+7wTZ04=;
        b=fUTqoXoHOVZeHzpgpiRRgow0z6M9cFLdDYVMi2aBryu7dw7CKhAHlTdB2hzUELAgqlzz2d
        gnx0Prx3GAF+vOKtkbF0YegdPgMxHfh1bLt2KCmRmSCWigVF2vE6b+GxDYEFIi7HjBeYvS
        81xoQ0bJ3/vKAoNANx7PLffVwX7wT2g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-294-clMFzeFROLy4H3wqdXuBhA-1; Wed, 04 May 2022 14:48:02 -0400
X-MC-Unique: clMFzeFROLy4H3wqdXuBhA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 34FE0833966;
        Wed,  4 May 2022 18:48:02 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.10.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 469B52166B1A;
        Wed,  4 May 2022 18:48:01 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Long Xin <lxin@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2] bond: add mac filter option for balance-xor
Date:   Wed,  4 May 2022 14:47:50 -0400
Message-Id: <6227427ef3b57d7de6d4d95e9dd7c9b222a37bf6.1651689665.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement a MAC filter that prevents duplicate frame delivery when
handling BUM traffic. This attempts to partially replicate OvS SLB
Bonding[1] like functionality without requiring significant change
in the Linux bridging code.

A typical network setup for this feature would be:

            .--------------------------------------------.
            |         .--------------------.             |
            |         |                    |             |
       .-------------------.               |             |
       |    | Bond 0  |    |               |             |
       | .--'---. .---'--. |               |             |
  .----|-| eth0 |-| eth1 |-|----.    .-----+----.   .----+------.
  |    | '------' '------' |    |    | Switch 1 |   | Switch 2  |
  |    '---,---------------'    |    |          +---+           |
  |       /                     |    '----+-----'   '----+------'
  |  .---'---.    .------.      |         |              |
  |  |  br0  |----| VM 1 |      |      ~~~~~~~~~~~~~~~~~~~~~
  |  '-------'    '------'      |     (                     )
  |      |        .------.      |     ( Rest of Network     )
  |      '--------| VM # |      |     (_____________________)
  |               '------'      |
  |  Host 1                     |
  '-----------------------------'

Where 'VM1' and 'VM#' are hosts connected to a Linux bridge, br0, with
bond0 and its associated links, eth0 & eth1, provide ingress/egress. One
can assume bond0, br1, and hosts VM1 to VM# are all contained in a
single box, as depicted. Interfaces eth0 and eth1 provide redundant
connections to the data center with the requirement to use all bandwidth
when the system is functioning normally. Switch 1 and Switch 2 are
physical switches that do not implement any advanced L2 management
features such as MLAG, Cisco's VPC, or LACP.

Combining this feature with vlan+srcmac hash policy allows a user to
create an access network without the need to use expensive switches that
support features like Cisco's VCP.

[1] https://docs.openvswitch.org/en/latest/topics/bonding/#slb-bonding

Co-developed-by: Long Xin <lxin@redhat.com>
Signed-off-by: Long Xin <lxin@redhat.com>
Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
---

Notes:
    v2:
     * dropped needless abstraction functions and put code in module init
     * renamed variable "rc" to "ret" to stay consistent with most of the
       code
     * fixed parameter setting management, when arp-monitor is turned on
       this feature will be turned off similar to how miimon and arp-monitor
       interact
     * renamed bond_xor_recv to bond_mac_filter_recv for a little more
       clarity
     * it appears the implied default return code for any bonding recv probe
       must be `RX_HANDLER_ANOTHER`. Changed the default return code of
       bond_mac_filter_recv to use this return value to not break skb
       processing when the skb dev is switched to the bond dev:
         `skb->dev = bond->dev`

 Documentation/networking/bonding.rst  |  19 +++
 drivers/net/bonding/Makefile          |   2 +-
 drivers/net/bonding/bond_mac_filter.c | 201 ++++++++++++++++++++++++++
 drivers/net/bonding/bond_mac_filter.h |  39 +++++
 drivers/net/bonding/bond_main.c       |  27 ++++
 drivers/net/bonding/bond_netlink.c    |  13 ++
 drivers/net/bonding/bond_options.c    |  86 ++++++++++-
 drivers/net/bonding/bonding_priv.h    |   1 +
 include/net/bond_options.h            |   1 +
 include/net/bonding.h                 |   3 +
 include/uapi/linux/if_link.h          |   1 +
 11 files changed, 390 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/bonding/bond_mac_filter.c
 create mode 100644 drivers/net/bonding/bond_mac_filter.h

diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
index 43be3782e5df..8786ce7eaacb 100644
--- a/Documentation/networking/bonding.rst
+++ b/Documentation/networking/bonding.rst
@@ -550,6 +550,25 @@ lacp_rate
 
 	The default is slow.
 
+mac_filter
+
+	Tells the bonding device to drop frames received who's source MAC
+	address	matches entries in a filter table. The filter table is
+	populated when the bond transmits frames. This is similar in
+	concept to the MAC learning table implemented in the bridge code.
+
+	This filtering is only enabled for the balance-xor bonding mode.
+
+	off or 0
+		Turns the feature off
+
+	number
+		A number greater than zero turns the feature on and sets
+		the maximum number of MAC addresses to store in the hash
+		table.
+
+	The default is off.
+
 max_bonds
 
 	Specifies the number of bonding devices to create for this
diff --git a/drivers/net/bonding/Makefile b/drivers/net/bonding/Makefile
index 30e8ae3da2da..5dbc360a8522 100644
--- a/drivers/net/bonding/Makefile
+++ b/drivers/net/bonding/Makefile
@@ -5,7 +5,7 @@
 
 obj-$(CONFIG_BONDING) += bonding.o
 
-bonding-objs := bond_main.o bond_3ad.o bond_alb.o bond_sysfs.o bond_sysfs_slave.o bond_debugfs.o bond_netlink.o bond_options.o
+bonding-objs := bond_main.o bond_3ad.o bond_alb.o bond_sysfs.o bond_sysfs_slave.o bond_debugfs.o bond_netlink.o bond_options.o bond_mac_filter.o
 
 proc-$(CONFIG_PROC_FS) += bond_procfs.o
 bonding-objs += $(proc-y)
diff --git a/drivers/net/bonding/bond_mac_filter.c b/drivers/net/bonding/bond_mac_filter.c
new file mode 100644
index 000000000000..e86b2b475df3
--- /dev/null
+++ b/drivers/net/bonding/bond_mac_filter.c
@@ -0,0 +1,201 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Filter received frames based on MAC addresses "behind" the bond.
+ */
+
+#include "bonding_priv.h"
+
+static const struct rhashtable_params bond_rht_params = {
+	.head_offset         = offsetof(struct bond_mac_cache_entry, rhnode),
+	.key_offset          = offsetof(struct bond_mac_cache_entry, key),
+	.key_len             = sizeof(struct mac_addr),
+	.automatic_shrinking = true,
+};
+
+static inline unsigned long hold_time(const struct bonding *bond)
+{
+	return msecs_to_jiffies(5000);
+}
+
+static bool has_expired(const struct bonding *bond,
+			struct bond_mac_cache_entry *mac)
+{
+	return time_before_eq(mac->used + hold_time(bond), jiffies);
+}
+
+static void mac_delete_rcu(struct callback_head *head)
+{
+	kmem_cache_free(bond_mac_cache,
+			container_of(head, struct bond_mac_cache_entry, rcu));
+}
+
+static int mac_delete(struct bonding *bond,
+		      struct bond_mac_cache_entry *entry)
+{
+	int ret;
+
+	ret = rhashtable_remove_fast(bond->mac_filter_tbl,
+				     &entry->rhnode,
+				     bond->mac_filter_tbl->p);
+	set_bit(BOND_MAC_DEAD, &entry->flags);
+	call_rcu(&entry->rcu, mac_delete_rcu);
+	return ret;
+}
+
+void bond_mac_hash_release_entries(struct work_struct *work)
+{
+	struct bonding *bond = container_of(work, struct bonding,
+				mac_work.work);
+	struct rhashtable_iter iter;
+	struct bond_mac_cache_entry *entry;
+	unsigned long flags;
+
+	rhashtable_walk_enter(bond->mac_filter_tbl, &iter);
+	rhashtable_walk_start(&iter);
+	while ((entry = rhashtable_walk_next(&iter)) != NULL) {
+		if (IS_ERR(entry))
+			continue;
+
+		spin_lock_irqsave(&entry->lock, flags);
+		if (has_expired(bond, entry))
+			mac_delete(bond, entry);
+		spin_unlock_irqrestore(&entry->lock, flags);
+	}
+	rhashtable_walk_stop(&iter);
+	rhashtable_walk_exit(&iter);
+	queue_delayed_work(bond->wq, &bond->mac_work,
+			   msecs_to_jiffies(5 * 60 * 1000));
+}
+
+int bond_mac_hash_init(struct bonding *bond)
+{
+	int ret;
+
+	netdev_dbg(bond->dev, "mac_filter: alloc memory for hash table\n");
+	bond->mac_filter_tbl = kzalloc(sizeof(*bond->mac_filter_tbl),
+				       GFP_KERNEL);
+	if (!bond->mac_filter_tbl)
+		return -ENOMEM;
+
+	ret = rhashtable_init(bond->mac_filter_tbl, &bond_rht_params);
+	if (ret)
+		kfree(bond->mac_filter_tbl);
+
+	return ret;
+}
+
+static void bond_mac_free_entry(void *entry, void *ctx)
+{
+	kmem_cache_free((struct kmem_cache *)ctx, entry);
+}
+
+void bond_mac_hash_destroy(struct bonding *bond)
+{
+	if (bond->mac_filter_tbl) {
+		rhashtable_free_and_destroy(bond->mac_filter_tbl,
+					    bond_mac_free_entry,
+					    bond_mac_cache);
+		kfree(bond->mac_filter_tbl);
+		bond->mac_filter_tbl = NULL;
+	}
+}
+
+static int mac_create(struct bonding *bond, const u8 *addr)
+{
+	struct bond_mac_cache_entry *entry;
+	int ret;
+
+	entry = kmem_cache_alloc(bond_mac_cache, GFP_ATOMIC);
+	if (!entry)
+		return -ENOMEM;
+	spin_lock_init(&entry->lock);
+	memcpy(&entry->key, addr, sizeof(entry->key));
+	entry->used = jiffies;
+	ret = rhashtable_lookup_insert_fast(bond->mac_filter_tbl,
+					    &entry->rhnode,
+					    bond->mac_filter_tbl->p);
+	if (ret) {
+		kmem_cache_free(bond_mac_cache, entry);
+		entry = NULL;
+		if (ret == -EEXIST)
+			return 0;
+		pr_err_once("Failed to insert mac entry %d\n", ret);
+	}
+	return ret;
+}
+
+static struct bond_mac_cache_entry *mac_find(struct bonding *bond,
+					     const u8 *addr)
+{
+	struct mac_addr key;
+
+	memcpy(&key, addr, sizeof(key));
+	return rhashtable_lookup(bond->mac_filter_tbl, &key,
+				 bond->mac_filter_tbl->p);
+}
+
+inline void mac_update(struct bond_mac_cache_entry *entry)
+{
+	entry->used = jiffies;
+}
+
+int bond_mac_insert(struct bonding *bond, const u8 *addr)
+{
+	struct bond_mac_cache_entry *entry;
+	int ret = 0;
+
+	if (!is_valid_ether_addr(addr))
+		return -EINVAL;
+
+	rcu_read_lock();
+	entry = mac_find(bond, addr);
+	if (entry) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&entry->lock, flags);
+		if (!test_bit(BOND_MAC_DEAD, &entry->flags)) {
+			mac_update(entry);
+			spin_unlock_irqrestore(&entry->lock, flags);
+			goto out;
+		}
+		spin_unlock_irqrestore(&entry->lock, flags);
+	}
+
+	ret = mac_create(bond, addr);
+
+out:
+	rcu_read_unlock();
+	return ret;
+}
+
+int bond_mac_filter_recv(const struct sk_buff *skb, struct bonding *bond,
+			 struct slave *slave)
+{
+	const struct ethhdr *mac_hdr;
+	struct bond_mac_cache_entry *entry;
+	int ret = RX_HANDLER_ANOTHER;
+
+	mac_hdr = (struct ethhdr *)skb_mac_header(skb);
+	rcu_read_lock();
+	if (is_multicast_ether_addr(mac_hdr->h_dest) &&
+	    slave != rcu_dereference(bond->curr_active_slave)) {
+		ret = RX_HANDLER_CONSUMED;
+		goto out;
+	}
+
+	entry = mac_find(bond, mac_hdr->h_source);
+	if (entry) {
+		unsigned long flags;
+		bool expired;
+
+		spin_lock_irqsave(&entry->lock, flags);
+		expired = has_expired(bond, entry);
+		spin_unlock_irqrestore(&entry->lock, flags);
+		if (!expired)
+			ret = RX_HANDLER_CONSUMED;
+	}
+
+out:
+	rcu_read_unlock();
+	return ret;
+}
diff --git a/drivers/net/bonding/bond_mac_filter.h b/drivers/net/bonding/bond_mac_filter.h
new file mode 100644
index 000000000000..7c968d41b456
--- /dev/null
+++ b/drivers/net/bonding/bond_mac_filter.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Filter received frames based on MAC addresses "behind" the bond.
+ */
+
+#ifndef _BOND_MAC_FILTER_H
+#define _BOND_MAC_FILTER_H
+#include <net/bonding.h>
+#include <linux/spinlock.h>
+#include <linux/rhashtable.h>
+
+enum {
+	BOND_MAC_DEAD,
+	BOND_MAC_LOCKED,
+	BOND_MAC_STATIC,
+};
+
+struct bond_mac_cache_entry {
+	struct rhash_head	rhnode;
+	struct mac_addr		key;
+
+	spinlock_t		lock; /* protects used member */
+	unsigned long		flags;
+	unsigned long		used;
+	struct rcu_head		rcu;
+};
+
+extern struct kmem_cache *bond_mac_cache;
+
+void bond_mac_hash_release_entries(struct work_struct *work);
+int bond_mac_hash_init(struct bonding *bond);
+void bond_mac_hash_destroy(struct bonding *bond);
+
+int bond_mac_insert(struct bonding *bond, const u8 *addr);
+int bond_mac_filter_recv(const struct sk_buff *skb,
+			 struct bonding *bond,
+			 struct slave *slave);
+
+#endif
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index c9e75a9de282..0e3b4e271c58 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -207,6 +207,7 @@ MODULE_PARM_DESC(lp_interval, "The number of seconds between instances where "
 atomic_t netpoll_block_tx = ATOMIC_INIT(0);
 #endif
 
+struct kmem_cache *bond_mac_cache __read_mostly;
 unsigned int bond_net_id __read_mostly;
 
 static const struct flow_dissector_key flow_keys_bonding_keys[] = {
@@ -4122,6 +4123,7 @@ void bond_work_init_all(struct bonding *bond)
 	INIT_DELAYED_WORK(&bond->arp_work, bond_arp_monitor);
 	INIT_DELAYED_WORK(&bond->ad_work, bond_3ad_state_machine_handler);
 	INIT_DELAYED_WORK(&bond->slave_arr_work, bond_slave_arr_handler);
+	INIT_DELAYED_WORK(&bond->mac_work, bond_mac_hash_release_entries);
 }
 
 static void bond_work_cancel_all(struct bonding *bond)
@@ -4132,6 +4134,7 @@ static void bond_work_cancel_all(struct bonding *bond)
 	cancel_delayed_work_sync(&bond->ad_work);
 	cancel_delayed_work_sync(&bond->mcast_work);
 	cancel_delayed_work_sync(&bond->slave_arr_work);
+	cancel_delayed_work_sync(&bond->mac_work);
 }
 
 static int bond_open(struct net_device *bond_dev)
@@ -4179,6 +4182,11 @@ static int bond_open(struct net_device *bond_dev)
 		bond_3ad_initiate_agg_selection(bond, 1);
 	}
 
+	if (BOND_MODE(bond) == BOND_MODE_XOR && bond->params.mac_filter) {
+		bond->recv_probe = bond_mac_filter_recv;
+		queue_delayed_work(bond->wq, &bond->mac_work, 0);
+	}
+
 	if (bond_mode_can_use_xmit_hash(bond))
 		bond_update_slave_arr(bond, NULL);
 
@@ -5048,6 +5056,13 @@ static struct slave *bond_xmit_3ad_xor_slave_get(struct bonding *bond,
 	if (unlikely(!count))
 		return NULL;
 
+	if (BOND_MODE(bond) == BOND_MODE_XOR && bond->params.mac_filter) {
+		const struct ethhdr *mac_hdr;
+
+		mac_hdr = (struct ethhdr *)skb_mac_header(skb);
+		if (bond_mac_insert(bond, mac_hdr->h_source))
+			return NULL;
+	}
 	slave = slaves->arr[hash % count];
 	return slave;
 }
@@ -5665,6 +5680,8 @@ static void bond_destructor(struct net_device *bond_dev)
 
 	if (bond->rr_tx_counter)
 		free_percpu(bond->rr_tx_counter);
+
+	bond_mac_hash_destroy(bond);
 }
 
 void bond_setup(struct net_device *bond_dev)
@@ -6120,6 +6137,7 @@ static int bond_check_params(struct bond_params *params)
 	params->downdelay = downdelay;
 	params->peer_notif_delay = 0;
 	params->use_carrier = use_carrier;
+	params->mac_filter = 0;
 	params->lacp_active = 1;
 	params->lacp_fast = lacp_fast;
 	params->primary[0] = 0;
@@ -6322,6 +6340,14 @@ static int __init bonding_init(void)
 			goto err;
 	}
 
+	bond_mac_cache = kmem_cache_create("bond_mac_cache",
+					   sizeof(struct bond_mac_cache_entry),
+					   0, SLAB_HWCACHE_ALIGN, NULL);
+	if (!bond_mac_cache) {
+		res = -ENOMEM;
+		goto err;
+	}
+
 	skb_flow_dissector_init(&flow_keys_bonding,
 				flow_keys_bonding_keys,
 				ARRAY_SIZE(flow_keys_bonding_keys));
@@ -6351,6 +6377,7 @@ static void __exit bonding_exit(void)
 	/* Make sure we don't have an imbalance on our netpoll blocking */
 	WARN_ON(atomic_read(&netpoll_block_tx));
 #endif
+	kmem_cache_destroy(bond_mac_cache);
 }
 
 module_init(bonding_init);
diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
index f427fa1737c7..249d79b6e21a 100644
--- a/drivers/net/bonding/bond_netlink.c
+++ b/drivers/net/bonding/bond_netlink.c
@@ -113,6 +113,7 @@ static const struct nla_policy bond_policy[IFLA_BOND_MAX + 1] = {
 	[IFLA_BOND_PEER_NOTIF_DELAY]    = { .type = NLA_U32 },
 	[IFLA_BOND_MISSED_MAX]		= { .type = NLA_U8 },
 	[IFLA_BOND_NS_IP6_TARGET]	= { .type = NLA_NESTED },
+	[IFLA_BOND_MAC_FILTER]		= { .type = NLA_U8 },
 };
 
 static const struct nla_policy bond_slave_policy[IFLA_BOND_SLAVE_MAX + 1] = {
@@ -498,6 +499,14 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 		if (err)
 			return err;
 	}
+	if (data[IFLA_BOND_MAC_FILTER]) {
+		u8 mac_filter = nla_get_u8(data[IFLA_BOND_MAC_FILTER]);
+
+		bond_opt_initval(&newval, mac_filter);
+		err = __bond_opt_set(bond, BOND_OPT_MAC_FILTER, &newval);
+		if (err)
+			return err;
+	}
 
 	return 0;
 }
@@ -565,6 +574,7 @@ static size_t bond_get_size(const struct net_device *bond_dev)
 						/* IFLA_BOND_NS_IP6_TARGET */
 		nla_total_size(sizeof(struct nlattr)) +
 		nla_total_size(sizeof(struct in6_addr)) * BOND_MAX_NS_TARGETS +
+		nla_total_size(sizeof(u8)) +	/* IFLA_BOND_MAC_FILTER */
 		0;
 }
 
@@ -723,6 +733,9 @@ static int bond_fill_info(struct sk_buff *skb,
 	if (nla_put_u8(skb, IFLA_BOND_MISSED_MAX,
 		       bond->params.missed_max))
 		goto nla_put_failure;
+	if (nla_put_u8(skb, IFLA_BOND_MAC_FILTER,
+		       bond->params.mac_filter))
+		goto nla_put_failure;
 
 	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
 		struct ad_info info;
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 64f7db2627ce..d295903a525b 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -15,6 +15,7 @@
 #include <linux/sched/signal.h>
 
 #include <net/bonding.h>
+#include "bonding_priv.h"
 
 static int bond_option_active_slave_set(struct bonding *bond,
 					const struct bond_opt_value *newval);
@@ -84,7 +85,8 @@ static int bond_option_ad_user_port_key_set(struct bonding *bond,
 					    const struct bond_opt_value *newval);
 static int bond_option_missed_max_set(struct bonding *bond,
 				      const struct bond_opt_value *newval);
-
+static int bond_option_mac_filter_set(struct bonding *bond,
+				      const struct bond_opt_value *newval);
 
 static const struct bond_opt_value bond_mode_tbl[] = {
 	{ "balance-rr",    BOND_MODE_ROUNDROBIN,   BOND_VALFLAG_DEFAULT},
@@ -226,6 +228,14 @@ static const struct bond_opt_value bond_missed_max_tbl[] = {
 	{ NULL,		-1,	0},
 };
 
+static const struct bond_opt_value bond_mac_filter_tbl[] = {
+	{ "off",	0,	BOND_VALFLAG_MIN | BOND_VALFLAG_DEFAULT},
+	{ "maxval",	18,	BOND_VALFLAG_MAX},
+	{ NULL,		-1,	0}
+};
+
+static const struct bond_opt_value *macfilteroff = &bond_mac_filter_tbl[0];
+
 static const struct bond_option bond_opts[BOND_OPT_LAST] = {
 	[BOND_OPT_MODE] = {
 		.id = BOND_OPT_MODE,
@@ -482,7 +492,16 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
 		.desc = "Delay between each peer notification on failover event, in milliseconds",
 		.values = bond_intmax_tbl,
 		.set = bond_option_peer_notif_delay_set
-	}
+	},
+	[BOND_OPT_MAC_FILTER] = {
+		.id = BOND_OPT_MAC_FILTER,
+		.name = "mac_filter",
+		.unsuppmodes = BOND_MODE_ALL_EX(BIT(BOND_MODE_XOR)),
+		.desc = "filter received frames based on MAC addresses that have transmitted from the bond, number of MAC addresses to track",
+		.flags = BOND_OPTFLAG_NOSLAVES | BOND_OPTFLAG_IFDOWN,
+		.values = bond_mac_filter_tbl,
+		.set = bond_option_mac_filter_set
+	},
 };
 
 /* Searches for an option by name */
@@ -832,6 +851,16 @@ static bool bond_set_tls_features(struct bonding *bond)
 static int bond_option_mode_set(struct bonding *bond,
 				const struct bond_opt_value *newval)
 {
+	int ret;
+
+	if (bond->params.mac_filter && newval->value != BOND_MODE_XOR) {
+		netdev_dbg(bond->dev, "%s mode is incompatiable with mac filtering, disabling\n",
+			   newval->string);
+		ret = bond_option_mac_filter_set(bond, macfilteroff);
+		if (ret)
+			return ret;
+	}
+
 	if (!bond_mode_uses_arp(newval->value)) {
 		if (bond->params.arp_interval) {
 			netdev_dbg(bond->dev, "%s mode is incompatible with arp monitoring, start mii monitoring\n",
@@ -840,6 +869,17 @@ static int bond_option_mode_set(struct bonding *bond,
 			bond->params.arp_interval = 0;
 		}
 
+		if (!bond->params.miimon) {
+			/* set miimon to default value */
+			bond->params.miimon = BOND_DEFAULT_MIIMON;
+			netdev_dbg(bond->dev, "Setting MII monitoring interval to %d\n",
+				   bond->params.miimon);
+		}
+	} else if (bond->params.mac_filter && bond->params.arp_interval) {
+		netdev_dbg(bond->dev, "mac filtering is incompatible with arp monitoring, start mii monitoring\n");
+		/* disable arp monitoring */
+		bond->params.arp_interval = 0;
+
 		if (!bond->params.miimon) {
 			/* set miimon to default value */
 			bond->params.miimon = BOND_DEFAULT_MIIMON;
@@ -1035,6 +1075,44 @@ static int bond_option_use_carrier_set(struct bonding *bond,
 	return 0;
 }
 
+static int bond_option_mac_filter_set(struct bonding *bond,
+				      const struct bond_opt_value *newval)
+{
+	int rc = 0;
+	u8 prev = bond->params.mac_filter;
+
+	if (newval->value && bond->params.arp_interval) {
+		netdev_err(bond->dev, "ARP monitoring cannot be used with MAC Filtering.\n");
+		rc = -EPERM;
+		goto err;
+	}
+
+	netdev_dbg(bond->dev, "Setting mac_filter to %llu\n", newval->value);
+	bond->params.mac_filter = newval->value;
+
+	if (prev == 0 && bond->params.mac_filter > 0) {
+		rc = bond_mac_hash_init(bond);
+		if (rc)
+			goto err;
+	} else if (prev > 0 && bond->params.mac_filter == 0) {
+		bond_mac_hash_destroy(bond);
+	}
+
+	if (bond->mac_filter_tbl) {
+		bond->mac_filter_tbl->p.max_size =
+			1 << bond->params.mac_filter;
+		netdev_dbg(bond->dev, "mac_filter hash table size: %d\n",
+			   bond->mac_filter_tbl->p.max_size);
+	}
+
+out:
+	return rc;
+
+err:
+	bond->params.mac_filter = 0;
+	goto out;
+}
+
 /* There are two tricky bits here.  First, if ARP monitoring is activated, then
  * we must disable MII monitoring.  Second, if the ARP timer isn't running,
  * we must start it.
@@ -1050,6 +1128,10 @@ static int bond_option_arp_interval_set(struct bonding *bond,
 			netdev_dbg(bond->dev, "ARP monitoring cannot be used with MII monitoring. Disabling MII monitoring\n");
 			bond->params.miimon = 0;
 		}
+		if (bond->params.mac_filter) {
+			netdev_dbg(bond->dev, "mac filtering cannot be used with ARP monitoring. Disabling mac filtering\n");
+			bond_option_mac_filter_set(bond, macfilteroff);
+		}
 		if (!bond->params.arp_targets[0])
 			netdev_dbg(bond->dev, "ARP monitoring has been set up, but no ARP targets have been specified\n");
 	}
diff --git a/drivers/net/bonding/bonding_priv.h b/drivers/net/bonding/bonding_priv.h
index 48cdf3a49a7d..0299f8bcb5fd 100644
--- a/drivers/net/bonding/bonding_priv.h
+++ b/drivers/net/bonding/bonding_priv.h
@@ -15,6 +15,7 @@
 #ifndef _BONDING_PRIV_H
 #define _BONDING_PRIV_H
 #include <generated/utsrelease.h>
+#include "bond_mac_filter.h"
 
 #define DRV_NAME	"bonding"
 #define DRV_DESCRIPTION	"Ethernet Channel Bonding Driver"
diff --git a/include/net/bond_options.h b/include/net/bond_options.h
index 61b49063791c..42e3e676b9c2 100644
--- a/include/net/bond_options.h
+++ b/include/net/bond_options.h
@@ -67,6 +67,7 @@ enum {
 	BOND_OPT_LACP_ACTIVE,
 	BOND_OPT_MISSED_MAX,
 	BOND_OPT_NS_TARGETS,
+	BOND_OPT_MAC_FILTER,
 	BOND_OPT_LAST
 };
 
diff --git a/include/net/bonding.h b/include/net/bonding.h
index b14f4c0b4e9e..5bc3e7b5a2af 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -125,6 +125,7 @@ struct bond_params {
 	int miimon;
 	u8 num_peer_notif;
 	u8 missed_max;
+	u8 mac_filter;
 	int arp_interval;
 	int arp_validate;
 	int arp_all_targets;
@@ -248,6 +249,7 @@ struct bonding {
 	struct   delayed_work alb_work;
 	struct   delayed_work ad_work;
 	struct   delayed_work mcast_work;
+	struct   delayed_work mac_work;
 	struct   delayed_work slave_arr_work;
 #ifdef CONFIG_DEBUG_FS
 	/* debugging support via debugfs */
@@ -260,6 +262,7 @@ struct bonding {
 	spinlock_t ipsec_lock;
 #endif /* CONFIG_XFRM_OFFLOAD */
 	struct bpf_prog *xdp_prog;
+	struct rhashtable *mac_filter_tbl;
 };
 
 #define bond_slave_get_rcu(dev) \
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index d1e600816b82..55e54d54f358 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -934,6 +934,7 @@ enum {
 	IFLA_BOND_AD_LACP_ACTIVE,
 	IFLA_BOND_MISSED_MAX,
 	IFLA_BOND_NS_IP6_TARGET,
+	IFLA_BOND_MAC_FILTER,
 	__IFLA_BOND_MAX,
 };
 
-- 
2.27.0

