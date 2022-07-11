Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9945701A8
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 14:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbiGKMHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 08:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiGKMHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 08:07:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 08A20422C7
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 05:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657541268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=9QSMkodQocuaY90ymAgm3SeAQWg3xmb5kBQ+E+B+5DM=;
        b=ExagdicdhbBuxIYuAEuV7Po/Q0xcd7Q3q6rXSehv0WjqSWnDLsdWa9eP1rGXZFeuoPWzdg
        yfKc5SoKueAFZ37bRhv7mzo5A/NBFUkgILjc5HjQ/25m5q10YDsMwrWPIzy3Js1RFaOfYl
        /V1kgmtvTG+oAMi544KSNQ1DshIJD9M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-224-lU88rFioP6WPc0gwYyDY-A-1; Mon, 11 Jul 2022 08:07:38 -0400
X-MC-Unique: lU88rFioP6WPc0gwYyDY-A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B9B485A583;
        Mon, 11 Jul 2022 12:07:38 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.9.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 445A9492C3B;
        Mon, 11 Jul 2022 12:07:37 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     netdev@vger.kernel.org
Cc:     jtoppins@redhat.com, razor@blackwall.org,
        Long Xin <lxin@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: [RESEND PATCH net-next v4] bond: add mac filter option for balance-xor
Date:   Mon, 11 Jul 2022 08:07:30 -0400
Message-Id: <1755bbaad9c3792ce22b8fa4906bb6051968f29e.1657302266.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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
    
    v3: Nik's comments
     * clarified documentation
     * fixed inline and basic reverse Christmas tree formatting
     * zero'ed entry in mac_create
     * removed read_lock taking in bond_mac_filter_recv
     * made has_expired() atomic and removed critical sections
       surrounding calls to has_expired(), this also removed the
       use-after-free that would have occurred:
           spin_lock_irqsave(&entry->lock, flags);
               if (has_expired(bond, entry))
                   mac_delete(bond, entry);
           spin_unlock_irqrestore(&entry->lock, flags); <---
     * moved init/destroy of mac_filter_tbl to bond_open/bond_close
       this removed the complex option dependencies, the only behavioural
       change the user will see is if the bond is up and mac_filter is
       enabled if they try and set arp_interval they will receive -EBUSY
     * in bond_changelink moved processing of mac_filter option just below
       mode processing
    
    v4:
     * rebase to latest net-next
     * removed rcu_read_lock() call in bond_mac_insert()
     * used specific spin_lock_{}() calls instead of the irqsave version
     * Outstanding comments from Nik:
       https://lore.kernel.org/netdev/4c9db6ac-aa24-2ca2-3e44-18cfb23ac1bc@blackwall.org/
       - old version of the patch still under discussion
         https://lore.kernel.org/netdev/d2696dab-2490-feb5-ccb2-96906fc652f0@redhat.com/
         * response: it has been over a month now and no new comments have come in
           so I am assuming there is nothing left to the discussion
       - What if anyone decides at some point 5 seconds are not enough or too much?
         * response: I think making that configurable at a later time should not
           prevent the inclusion of the initial feature.
       - This bit is pointless, you still have races even though not critical
         * response: if there are races please point them out simply making a
           comment about an enum doesn't show the race.
       - This is not scalable at all, you get the lock even to update the
         expire on *every* packet, most users go for L3 or L3+L4 and will hit
         this with different flows on different CPUs.
         * response: we take the lock to update the value, so that receive
           traffic is not dropped. Further any implementation, bpf or nft,
           will also have to take locks to update MAC entries. If there is a
           specific locking order that will be less bad, I would appreciate
           that discussion. Concerning L3 or L3+L4 hashing this is not the
           data I have, in fact the most utilized hash is layer2.

 Documentation/networking/bonding.rst  |  20 +++
 drivers/net/bonding/Makefile          |   2 +-
 drivers/net/bonding/bond_mac_filter.c | 202 ++++++++++++++++++++++++++
 drivers/net/bonding/bond_mac_filter.h |  37 +++++
 drivers/net/bonding/bond_main.c       |  30 ++++
 drivers/net/bonding/bond_netlink.c    |  14 ++
 drivers/net/bonding/bond_options.c    |  81 +++++++++--
 drivers/net/bonding/bonding_priv.h    |   1 +
 include/net/bond_options.h            |   1 +
 include/net/bonding.h                 |   3 +
 include/uapi/linux/if_link.h          |   1 +
 11 files changed, 375 insertions(+), 17 deletions(-)
 create mode 100644 drivers/net/bonding/bond_mac_filter.c
 create mode 100644 drivers/net/bonding/bond_mac_filter.h

diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
index 53a18ff7cf23..430d1360bd20 100644
--- a/Documentation/networking/bonding.rst
+++ b/Documentation/networking/bonding.rst
@@ -550,6 +550,26 @@ lacp_rate
 
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
+		table. This value is used as the exponent in a 2^N calculation
+		to determine the actual size of the hashtable.
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
index 000000000000..9fed467fda16
--- /dev/null
+++ b/drivers/net/bonding/bond_mac_filter.c
@@ -0,0 +1,202 @@
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
+static unsigned long hold_time(void)
+{
+	return msecs_to_jiffies(5000);
+}
+
+static bool has_expired(struct bond_mac_cache_entry *entry)
+{
+	return time_before(entry->expired, jiffies);
+}
+
+static bool has_expired_sync(struct bond_mac_cache_entry *entry)
+{
+	bool ret;
+
+	spin_lock(&entry->lock);
+	ret = has_expired(entry);
+	spin_unlock(&entry->lock);
+
+	return ret;
+}
+
+static void mac_delete_rcu(struct callback_head *head)
+{
+	kmem_cache_free(bond_mac_cache,
+			container_of(head, struct bond_mac_cache_entry, rcu));
+}
+
+static int mac_remove(struct bonding *bond,
+		      struct bond_mac_cache_entry *entry)
+{
+	set_bit(BOND_MAC_DEAD, &entry->flags);
+	return rhashtable_remove_fast(bond->mac_filter_tbl,
+				      &entry->rhnode,
+				      bond->mac_filter_tbl->p);
+}
+
+void bond_mac_hash_release_entries(struct work_struct *work)
+{
+	struct bonding *bond = container_of(work, struct bonding,
+				mac_work.work);
+	struct bond_mac_cache_entry *entry;
+	struct rhashtable_iter iter;
+
+	rhashtable_walk_enter(bond->mac_filter_tbl, &iter);
+	rhashtable_walk_start(&iter);
+	while ((entry = rhashtable_walk_next(&iter)) != NULL) {
+		if (IS_ERR(entry))
+			continue;
+
+		spin_lock_bh(&entry->lock);
+		if (!has_expired(entry)) {
+			spin_unlock_bh(&entry->lock);
+			continue;
+		}
+
+		mac_remove(bond, entry);
+		spin_unlock_bh(&entry->lock);
+		call_rcu(&entry->rcu, mac_delete_rcu);
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
+	bond->mac_filter_tbl = kzalloc(sizeof(*bond->mac_filter_tbl),
+				       GFP_KERNEL);
+	if (!bond->mac_filter_tbl)
+		return -ENOMEM;
+
+	ret = rhashtable_init(bond->mac_filter_tbl, &bond_rht_params);
+	if (ret) {
+		kfree(bond->mac_filter_tbl);
+		bond->mac_filter_tbl = NULL;
+	}
+
+	bond->mac_filter_tbl->p.max_size = 1 << bond->params.mac_filter;
+	netdev_dbg(bond->dev, "mac_filter hash table size: %d\n",
+		   bond->mac_filter_tbl->p.max_size);
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
+static void mac_update(struct bond_mac_cache_entry *entry)
+{
+	entry->expired = jiffies + hold_time();
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
+
+	memset(entry, 0, sizeof(*entry));
+	spin_lock_init(&entry->lock);
+	memcpy(&entry->key, addr, sizeof(entry->key));
+	mac_update(entry);
+	ret = rhashtable_lookup_insert_fast(bond->mac_filter_tbl,
+					    &entry->rhnode,
+					    bond->mac_filter_tbl->p);
+	if (ret) {
+		kmem_cache_free(bond_mac_cache, entry);
+		if (ret == -EEXIST)
+			return 0;
+		netdev_dbg(bond->dev, "Failed to insert mac entry %d\n", ret);
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
+int bond_mac_insert(struct bonding *bond, const u8 *addr)
+{
+	struct bond_mac_cache_entry *entry;
+	int ret = 0;
+
+	if (!is_valid_ether_addr(addr))
+		return -EINVAL;
+
+	entry = mac_find(bond, addr);
+	if (entry) {
+		spin_lock(&entry->lock);
+		if (!test_bit(BOND_MAC_DEAD, &entry->flags)) {
+			mac_update(entry);
+			spin_unlock(&entry->lock);
+			goto out;
+		}
+		spin_unlock(&entry->lock);
+	}
+
+	ret = mac_create(bond, addr);
+
+out:
+	return ret;
+}
+
+int bond_mac_filter_recv(const struct sk_buff *skb, struct bonding *bond,
+			 struct slave *slave)
+{
+	struct bond_mac_cache_entry *entry;
+	const struct ethhdr *mac_hdr;
+	int ret = RX_HANDLER_ANOTHER;
+
+	mac_hdr = (struct ethhdr *)skb_mac_header(skb);
+	if (is_multicast_ether_addr(mac_hdr->h_dest) &&
+	    slave != rcu_dereference(bond->curr_active_slave)) {
+		ret = RX_HANDLER_CONSUMED;
+		goto out;
+	}
+
+	entry = mac_find(bond, mac_hdr->h_source);
+	if (entry && !has_expired_sync(entry))
+		ret = RX_HANDLER_CONSUMED;
+
+out:
+	return ret;
+}
diff --git a/drivers/net/bonding/bond_mac_filter.h b/drivers/net/bonding/bond_mac_filter.h
new file mode 100644
index 000000000000..4ebec63e41e7
--- /dev/null
+++ b/drivers/net/bonding/bond_mac_filter.h
@@ -0,0 +1,37 @@
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
+};
+
+struct bond_mac_cache_entry {
+	struct rhash_head	rhnode;
+	struct mac_addr		key;
+
+	spinlock_t		lock; /* protects used member */
+	unsigned long		flags;
+	unsigned long		expired;
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
index e75acb14d066..82e716e848f8 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -207,6 +207,7 @@ MODULE_PARM_DESC(lp_interval, "The number of seconds between instances where "
 atomic_t netpoll_block_tx = ATOMIC_INIT(0);
 #endif
 
+struct kmem_cache *bond_mac_cache __read_mostly;
 unsigned int bond_net_id __read_mostly;
 
 static const struct flow_dissector_key flow_keys_bonding_keys[] = {
@@ -4151,6 +4152,7 @@ void bond_work_init_all(struct bonding *bond)
 	INIT_DELAYED_WORK(&bond->arp_work, bond_arp_monitor);
 	INIT_DELAYED_WORK(&bond->ad_work, bond_3ad_state_machine_handler);
 	INIT_DELAYED_WORK(&bond->slave_arr_work, bond_slave_arr_handler);
+	INIT_DELAYED_WORK(&bond->mac_work, bond_mac_hash_release_entries);
 }
 
 static void bond_work_cancel_all(struct bonding *bond)
@@ -4161,6 +4163,7 @@ static void bond_work_cancel_all(struct bonding *bond)
 	cancel_delayed_work_sync(&bond->ad_work);
 	cancel_delayed_work_sync(&bond->mcast_work);
 	cancel_delayed_work_sync(&bond->slave_arr_work);
+	cancel_delayed_work_sync(&bond->mac_work);
 }
 
 static int bond_open(struct net_device *bond_dev)
@@ -4208,6 +4211,15 @@ static int bond_open(struct net_device *bond_dev)
 		bond_3ad_initiate_agg_selection(bond, 1);
 	}
 
+	if (BOND_MODE(bond) == BOND_MODE_XOR && bond->params.mac_filter) {
+		int ret = bond_mac_hash_init(bond);
+
+		if (ret)
+			return ret;
+		bond->recv_probe = bond_mac_filter_recv;
+		queue_delayed_work(bond->wq, &bond->mac_work, 0);
+	}
+
 	if (bond_mode_can_use_xmit_hash(bond))
 		bond_update_slave_arr(bond, NULL);
 
@@ -4223,6 +4235,7 @@ static int bond_close(struct net_device *bond_dev)
 	if (bond_is_lb(bond))
 		bond_alb_deinitialize(bond);
 	bond->recv_probe = NULL;
+	bond_mac_hash_destroy(bond);
 
 	return 0;
 }
@@ -5077,6 +5090,13 @@ static struct slave *bond_xmit_3ad_xor_slave_get(struct bonding *bond,
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
@@ -6158,6 +6178,7 @@ static int bond_check_params(struct bond_params *params)
 	params->downdelay = downdelay;
 	params->peer_notif_delay = 0;
 	params->use_carrier = use_carrier;
+	params->mac_filter = 0;
 	params->lacp_active = 1;
 	params->lacp_fast = lacp_fast;
 	params->primary[0] = 0;
@@ -6350,6 +6371,14 @@ static int __init bonding_init(void)
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
@@ -6379,6 +6408,7 @@ static void __exit bonding_exit(void)
 	/* Make sure we don't have an imbalance on our netpoll blocking */
 	WARN_ON(atomic_read(&netpoll_block_tx));
 #endif
+	kmem_cache_destroy(bond_mac_cache);
 }
 
 module_init(bonding_init);
diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
index c2d080fc4fc4..d166630fc835 100644
--- a/drivers/net/bonding/bond_netlink.c
+++ b/drivers/net/bonding/bond_netlink.c
@@ -117,6 +117,7 @@ static const struct nla_policy bond_policy[IFLA_BOND_MAX + 1] = {
 	[IFLA_BOND_PEER_NOTIF_DELAY]    = { .type = NLA_U32 },
 	[IFLA_BOND_MISSED_MAX]		= { .type = NLA_U8 },
 	[IFLA_BOND_NS_IP6_TARGET]	= { .type = NLA_NESTED },
+	[IFLA_BOND_MAC_FILTER]		= { .type = NLA_U8 },
 };
 
 static const struct nla_policy bond_slave_policy[IFLA_BOND_SLAVE_MAX + 1] = {
@@ -196,6 +197,15 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 		if (err)
 			return err;
 	}
+	if (data[IFLA_BOND_MAC_FILTER]) {
+		u8 mac_filter = nla_get_u8(data[IFLA_BOND_MAC_FILTER]);
+
+		bond_opt_initval(&newval, mac_filter);
+		err = __bond_opt_set(bond, BOND_OPT_MAC_FILTER, &newval,
+				     data[IFLA_BOND_MAC_FILTER], extack);
+		if (err)
+			return err;
+	}
 	if (data[IFLA_BOND_ACTIVE_SLAVE]) {
 		int ifindex = nla_get_u32(data[IFLA_BOND_ACTIVE_SLAVE]);
 		struct net_device *slave_dev;
@@ -610,6 +620,7 @@ static size_t bond_get_size(const struct net_device *bond_dev)
 						/* IFLA_BOND_NS_IP6_TARGET */
 		nla_total_size(sizeof(struct nlattr)) +
 		nla_total_size(sizeof(struct in6_addr)) * BOND_MAX_NS_TARGETS +
+		nla_total_size(sizeof(u8)) +	/* IFLA_BOND_MAC_FILTER */
 		0;
 }
 
@@ -768,6 +779,9 @@ static int bond_fill_info(struct sk_buff *skb,
 	if (nla_put_u8(skb, IFLA_BOND_MISSED_MAX,
 		       bond->params.missed_max))
 		goto nla_put_failure;
+	if (nla_put_u8(skb, IFLA_BOND_MAC_FILTER,
+		       bond->params.mac_filter))
+		goto nla_put_failure;
 
 	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
 		struct ad_info info;
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 3498db1c1b3c..bd791775fd6b 100644
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
@@ -226,6 +228,12 @@ static const struct bond_opt_value bond_missed_max_tbl[] = {
 	{ NULL,		-1,	0},
 };
 
+static const struct bond_opt_value bond_mac_filter_tbl[] = {
+	{ "off",	0,	BOND_VALFLAG_MIN | BOND_VALFLAG_DEFAULT},
+	{ "maxval",	18,	BOND_VALFLAG_MAX},
+	{ NULL,		-1,	0}
+};
+
 static const struct bond_option bond_opts[BOND_OPT_LAST] = {
 	[BOND_OPT_MODE] = {
 		.id = BOND_OPT_MODE,
@@ -490,7 +498,16 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
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
+		.flags = BOND_OPTFLAG_IFDOWN,
+		.values = bond_mac_filter_tbl,
+		.set = bond_option_mac_filter_set
+	},
 };
 
 /* Searches for an option by name */
@@ -855,25 +872,38 @@ static bool bond_set_tls_features(struct bonding *bond)
 	return true;
 }
 
+static void disable_arp_enable_mii(struct bonding *bond, const char *feature,
+				   const char *suffix)
+{
+	if (bond->params.arp_interval) {
+		netdev_dbg(bond->dev, "%s%s is incompatible with arp monitoring, start mii monitoring\n",
+			   feature, suffix);
+		/* disable arp monitoring */
+		bond->params.arp_interval = 0;
+	}
+
+	if (!bond->params.miimon) {
+		/* set miimon to default value */
+		bond->params.miimon = BOND_DEFAULT_MIIMON;
+		netdev_dbg(bond->dev, "Setting MII monitoring interval to %d\n",
+			   bond->params.miimon);
+	}
+}
+
 static int bond_option_mode_set(struct bonding *bond,
 				const struct bond_opt_value *newval)
 {
-	if (!bond_mode_uses_arp(newval->value)) {
-		if (bond->params.arp_interval) {
-			netdev_dbg(bond->dev, "%s mode is incompatible with arp monitoring, start mii monitoring\n",
-				   newval->string);
-			/* disable arp monitoring */
-			bond->params.arp_interval = 0;
-		}
-
-		if (!bond->params.miimon) {
-			/* set miimon to default value */
-			bond->params.miimon = BOND_DEFAULT_MIIMON;
-			netdev_dbg(bond->dev, "Setting MII monitoring interval to %d\n",
-				   bond->params.miimon);
-		}
+	if (bond->params.mac_filter && newval->value != BOND_MODE_XOR) {
+		netdev_dbg(bond->dev, "%s mode is incompatible with mac filtering, disabling\n",
+			   newval->string);
+		bond->params.mac_filter = 0;
 	}
 
+	if (!bond_mode_uses_arp(newval->value))
+		disable_arp_enable_mii(bond, newval->string, " mode");
+	else if (bond->params.mac_filter && bond->params.arp_interval)
+		disable_arp_enable_mii(bond, "MAC filtering", "");
+
 	if (newval->value == BOND_MODE_ALB)
 		bond->params.tlb_dynamic_lb = 1;
 
@@ -1061,6 +1091,17 @@ static int bond_option_use_carrier_set(struct bonding *bond,
 	return 0;
 }
 
+static int bond_option_mac_filter_set(struct bonding *bond,
+				      const struct bond_opt_value *newval)
+{
+	if (newval->value && bond->params.arp_interval)
+		disable_arp_enable_mii(bond, "MAC filtering", "");
+
+	netdev_dbg(bond->dev, "Setting mac_filter to %llu\n", newval->value);
+	bond->params.mac_filter = newval->value;
+	return 0;
+}
+
 /* There are two tricky bits here.  First, if ARP monitoring is activated, then
  * we must disable MII monitoring.  Second, if the ARP timer isn't running,
  * we must start it.
@@ -1068,6 +1109,14 @@ static int bond_option_use_carrier_set(struct bonding *bond,
 static int bond_option_arp_interval_set(struct bonding *bond,
 					const struct bond_opt_value *newval)
 {
+	if (newval->value && bond->params.mac_filter) {
+		if (bond->dev->flags & IFF_UP)
+			return -EBUSY;
+
+		netdev_dbg(bond->dev, "MAC filtering cannot be used with ARP monitoring. Disabling MAC filtering\n");
+		bond->params.mac_filter = 0;
+	}
+
 	netdev_dbg(bond->dev, "Setting ARP monitoring interval to %llu\n",
 		   newval->value);
 	bond->params.arp_interval = newval->value;
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
index d2aea5cf1e41..25a9ef30b047 100644
--- a/include/net/bond_options.h
+++ b/include/net/bond_options.h
@@ -68,6 +68,7 @@ enum {
 	BOND_OPT_MISSED_MAX,
 	BOND_OPT_NS_TARGETS,
 	BOND_OPT_PRIO,
+	BOND_OPT_MAC_FILTER,
 	BOND_OPT_LAST
 };
 
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 6e78d657aa05..ad5b9c43b1e9 100644
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
@@ -251,6 +252,7 @@ struct bonding {
 	struct   delayed_work alb_work;
 	struct   delayed_work ad_work;
 	struct   delayed_work mcast_work;
+	struct   delayed_work mac_work;
 	struct   delayed_work slave_arr_work;
 #ifdef CONFIG_DEBUG_FS
 	/* debugging support via debugfs */
@@ -263,6 +265,7 @@ struct bonding {
 	spinlock_t ipsec_lock;
 #endif /* CONFIG_XFRM_OFFLOAD */
 	struct bpf_prog *xdp_prog;
+	struct rhashtable *mac_filter_tbl;
 };
 
 #define bond_slave_get_rcu(dev) \
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index e36d9d2c65a7..c510e8be8479 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -936,6 +936,7 @@ enum {
 	IFLA_BOND_AD_LACP_ACTIVE,
 	IFLA_BOND_MISSED_MAX,
 	IFLA_BOND_NS_IP6_TARGET,
+	IFLA_BOND_MAC_FILTER,
 	__IFLA_BOND_MAX,
 };
 
-- 
2.31.1

