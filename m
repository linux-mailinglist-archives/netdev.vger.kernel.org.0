Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F48274348
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 15:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgIVNi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 09:38:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35456 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726494AbgIVNiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 09:38:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600781898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PdKlea1MV9vkKZsZlqernarbgR3WXGRjRFuwGQ6LoY0=;
        b=ZNSzDxdh14VUOuBuDDPEaheocQDcHnOfS4RvAMubckYVfxUlWSgJ0R/C6+RuQbhxhZbP2Y
        bUQ1SYk+m6YdbegeVE+lSh3dJ1Db6VdBU5G3YNI1/jBygWpjg5Kx09NDWJaJhdSmfYy/bH
        2zoT32XLlfbu68lOJmh0O5eknOT2pG0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-E-UKXfMEPxOuQuV4L1KH4A-1; Tue, 22 Sep 2020 09:38:17 -0400
X-MC-Unique: E-UKXfMEPxOuQuV4L1KH4A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C958ADC18;
        Tue, 22 Sep 2020 13:38:06 +0000 (UTC)
Received: from hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com (hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com [10.16.210.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4326B78808;
        Tue, 22 Sep 2020 13:38:05 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/5] bonding: rename struct slave member link to link_state
Date:   Tue, 22 Sep 2020 09:37:27 -0400
Message-Id: <20200922133731.33478-2-jarod@redhat.com>
In-Reply-To: <20200922133731.33478-1-jarod@redhat.com>
References: <20200922133731.33478-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Necessary prep work to recycle the name "link" as a replacement for
"slave" in bonding driver terminology.

Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Thomas Davis <tadavis@lbl.gov>
Cc: netdev@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/net/bonding/bond_3ad.c         | 12 ++--
 drivers/net/bonding/bond_alb.c         |  7 ++-
 drivers/net/bonding/bond_main.c        | 77 +++++++++++++-------------
 drivers/net/bonding/bond_netlink.c     |  2 +-
 drivers/net/bonding/bond_options.c     |  3 +-
 drivers/net/bonding/bond_procfs.c      |  3 +-
 drivers/net/bonding/bond_sysfs_slave.c |  2 +-
 include/net/bond_3ad.h                 |  2 +-
 include/net/bond_alb.h                 |  3 +-
 include/net/bonding.h                  | 10 ++--
 10 files changed, 64 insertions(+), 57 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index aa001b16765a..e55b73aa3043 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -183,7 +183,7 @@ static inline void __enable_port(struct port *port)
 {
 	struct slave *slave = port->slave;
 
-	if ((slave->link == BOND_LINK_UP) && bond_slave_is_up(slave))
+	if ((slave->link_state == BOND_LINK_UP) && bond_slave_is_up(slave))
 		bond_set_slave_active_flags(slave, BOND_SLAVE_NOTIFY_LATER);
 }
 
@@ -256,7 +256,7 @@ static u16 __get_link_speed(struct port *port)
 	 * This is done in spite of the fact that the e100 driver reports 0
 	 * to be compatible with MVT in the future.
 	 */
-	if (slave->link != BOND_LINK_UP)
+	if (slave->link_state != BOND_LINK_UP)
 		speed = 0;
 	else {
 		switch (slave->speed) {
@@ -345,7 +345,7 @@ static u8 __get_duplex(struct port *port)
 	/* handling a special case: when the configuration starts with
 	 * link down, it sets the duplex to 0.
 	 */
-	if (slave->link == BOND_LINK_UP) {
+	if (slave->link_state == BOND_LINK_UP) {
 		switch (slave->duplex) {
 		case DUPLEX_FULL:
 			retval = 0x1;
@@ -2505,7 +2505,7 @@ void bond_3ad_adapter_speed_duplex_changed(struct slave *slave)
  *
  * Handle reselection of aggregator (if needed) for this port.
  */
-void bond_3ad_handle_link_change(struct slave *slave, char link)
+void bond_3ad_handle_link_change(struct link *link, char link_state)
 {
 	struct aggregator *agg;
 	struct port *port;
@@ -2527,7 +2527,7 @@ void bond_3ad_handle_link_change(struct slave *slave, char link)
 	 * on link up we are forcing recheck on the duplex and speed since
 	 * some of he adaptors(ce1000.lan) report.
 	 */
-	if (link == BOND_LINK_UP) {
+	if (link_state == BOND_LINK_UP) {
 		port->is_enabled = true;
 		ad_update_actor_keys(port, false);
 	} else {
@@ -2542,7 +2542,7 @@ void bond_3ad_handle_link_change(struct slave *slave, char link)
 
 	slave_dbg(slave->bond->dev, slave->dev, "Port %d changed link status to %s\n",
 		  port->actor_port_number,
-		  link == BOND_LINK_UP ? "UP" : "DOWN");
+		  link_state == BOND_LINK_UP ? "UP" : "DOWN");
 
 	/* RTNL is held and mode_lock is released so it's safe
 	 * to update slave_array here.
diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 4e1b7deb724b..9e6f80d8ef8c 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -1664,15 +1664,16 @@ void bond_alb_deinit_slave(struct bonding *bond, struct slave *slave)
 
 }
 
-void bond_alb_handle_link_change(struct bonding *bond, struct slave *slave, char link)
+void bond_alb_handle_link_change(struct bonding *bond, struct slave *slave,
+				 char link_state)
 {
 	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
 
-	if (link == BOND_LINK_DOWN) {
+	if (link_state == BOND_LINK_DOWN) {
 		tlb_clear_slave(bond, slave, 0);
 		if (bond->alb_info.rlb_enabled)
 			rlb_clear_slave(bond, slave);
-	} else if (link == BOND_LINK_UP) {
+	} else if (link_state == BOND_LINK_UP) {
 		/* order a rebalance ASAP */
 		bond_info->tx_rebalance_counter = BOND_TLB_REBALANCE_TICKS;
 		if (bond->alb_info.rlb_enabled) {
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 42ef25ec0af5..1f602bcf10bd 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -487,7 +487,7 @@ int bond_set_carrier(struct bonding *bond)
 		return bond_3ad_set_carrier(bond);
 
 	bond_for_each_slave(bond, slave, iter) {
-		if (slave->link == BOND_LINK_UP) {
+		if (slave->link_state == BOND_LINK_UP) {
 			if (!netif_carrier_ok(bond->dev)) {
 				netif_carrier_on(bond->dev);
 				return 1;
@@ -538,9 +538,9 @@ static int bond_update_speed_duplex(struct slave *slave)
 	return 0;
 }
 
-const char *bond_slave_link_status(s8 link)
+const char *bond_slave_link_status(s8 link_state)
 {
-	switch (link) {
+	switch (link_state) {
 	case BOND_LINK_UP:
 		return "up";
 	case BOND_LINK_FAIL:
@@ -866,8 +866,8 @@ static struct slave *bond_choose_primary_or_current(struct bonding *bond)
 	struct slave *prim = rtnl_dereference(bond->primary_slave);
 	struct slave *curr = rtnl_dereference(bond->curr_active_slave);
 
-	if (!prim || prim->link != BOND_LINK_UP) {
-		if (!curr || curr->link != BOND_LINK_UP)
+	if (!prim || prim->link_state != BOND_LINK_UP) {
+		if (!curr || curr->link_state != BOND_LINK_UP)
 			return NULL;
 		return curr;
 	}
@@ -877,7 +877,7 @@ static struct slave *bond_choose_primary_or_current(struct bonding *bond)
 		return prim;
 	}
 
-	if (!curr || curr->link != BOND_LINK_UP)
+	if (!curr || curr->link_state != BOND_LINK_UP)
 		return prim;
 
 	/* At this point, prim and curr are both up */
@@ -914,10 +914,10 @@ static struct slave *bond_find_best_slave(struct bonding *bond)
 		return slave;
 
 	bond_for_each_slave(bond, slave, iter) {
-		if (slave->link == BOND_LINK_UP)
+		if (slave->link_state == BOND_LINK_UP)
 			return slave;
-		if (slave->link == BOND_LINK_BACK && bond_slave_is_up(slave) &&
-		    slave->delay < mintime) {
+		if (slave->link_state == BOND_LINK_BACK &&
+		    bond_slave_is_up(slave) && slave->delay < mintime) {
 			mintime = slave->delay;
 			bestslave = slave;
 		}
@@ -981,7 +981,7 @@ void bond_change_active_slave(struct bonding *bond, struct slave *new_active)
 	if (new_active) {
 		new_active->last_link_up = jiffies;
 
-		if (new_active->link == BOND_LINK_BACK) {
+		if (new_active->link_state == BOND_LINK_BACK) {
 			if (bond_uses_primary(bond)) {
 				slave_info(bond->dev, new_active->dev, "making interface the new active one %d ms earlier\n",
 					   (bond->params.updelay - new_active->delay) * bond->params.miimon);
@@ -1501,7 +1501,7 @@ static void bond_fill_ifbond(struct bonding *bond, struct ifbond *info)
 static void bond_fill_ifslave(struct slave *slave, struct ifslave *info)
 {
 	strcpy(info->slave_name, slave->dev->name);
-	info->link = slave->link;
+	info->slave = slave->link_state;
 	info->state = bond_slave_state(slave);
 	info->link_failure_count = slave->link_failure_count;
 }
@@ -1532,8 +1532,8 @@ void bond_lower_state_changed(struct slave *slave)
 {
 	struct netdev_lag_lower_state_info info;
 
-	info.link_up = slave->link == BOND_LINK_UP ||
-		       slave->link == BOND_LINK_FAIL;
+	info.link_up = slave->link_state == BOND_LINK_UP ||
+		       slave->link_state == BOND_LINK_FAIL;
 	info.tx_enabled = bond_is_active_slave(slave);
 	netdev_lower_state_changed(slave->dev, &info);
 }
@@ -1756,7 +1756,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 
 	if (bond_update_speed_duplex(new_slave) &&
 	    bond_needs_speed_duplex(bond))
-		new_slave->link = BOND_LINK_DOWN;
+		new_slave->link_state = BOND_LINK_DOWN;
 
 	new_slave->last_rx = jiffies -
 		(msecs_to_jiffies(bond->params.arp_interval) + 1);
@@ -1783,7 +1783,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	}
 
 	/* check for initial state */
-	new_slave->link = BOND_LINK_NOCHANGE;
+	new_slave->link_state = BOND_LINK_NOCHANGE;
 	if (bond->params.miimon) {
 		if (bond_check_dev_link(bond, slave_dev, 0) == BMSR_LSTATUS) {
 			if (bond->params.updelay) {
@@ -1810,11 +1810,11 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 					  BOND_SLAVE_NOTIFY_NOW);
 	}
 
-	if (new_slave->link != BOND_LINK_DOWN)
+	if (new_slave->link_state != BOND_LINK_DOWN)
 		new_slave->last_link_up = jiffies;
 	slave_dbg(bond_dev, slave_dev, "Initial state of slave is BOND_LINK_%s\n",
-		  new_slave->link == BOND_LINK_DOWN ? "DOWN" :
-		  (new_slave->link == BOND_LINK_UP ? "UP" : "BACK"));
+		  new_slave->link_state == BOND_LINK_DOWN ? "DOWN" :
+		  (new_slave->link_state == BOND_LINK_UP ? "UP" : "BACK"));
 
 	if (bond_uses_primary(bond) && bond->params.primary[0]) {
 		/* if there is a primary slave, remember it */
@@ -1865,7 +1865,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		 * so we can change it without calling change_active_interface()
 		 */
 		if (!rcu_access_pointer(bond->curr_active_slave) &&
-		    new_slave->link == BOND_LINK_UP)
+		    new_slave->link_state == BOND_LINK_UP)
 			rcu_assign_pointer(bond->curr_active_slave, new_slave);
 
 		break;
@@ -1953,7 +1953,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 
 	slave_info(bond_dev, slave_dev, "Enslaving as %s interface with %s link\n",
 		   bond_is_active_slave(new_slave) ? "an active" : "a backup",
-		   new_slave->link != BOND_LINK_DOWN ? "an up" : "a down");
+		   new_slave->link_state != BOND_LINK_DOWN ? "an up" : "a down");
 
 	/* enslave is successful */
 	bond_queue_slave_event(new_slave);
@@ -2258,7 +2258,7 @@ static int bond_miimon_inspect(struct bonding *bond)
 
 		link_state = bond_check_dev_link(bond, slave->dev, 0);
 
-		switch (slave->link) {
+		switch (slave->link_state) {
 		case BOND_LINK_UP:
 			if (link_state)
 				continue;
@@ -2341,15 +2341,15 @@ static int bond_miimon_inspect(struct bonding *bond)
 
 static void bond_miimon_link_change(struct bonding *bond,
 				    struct slave *slave,
-				    char link)
+				    char link_state)
 {
 	switch (BOND_MODE(bond)) {
 	case BOND_MODE_8023AD:
-		bond_3ad_handle_link_change(slave, link);
+		bond_3ad_handle_link_change(slave, link_state);
 		break;
 	case BOND_MODE_TLB:
 	case BOND_MODE_ALB:
-		bond_alb_handle_link_change(bond, slave, link);
+		bond_alb_handle_link_change(bond, slave, link_state);
 		break;
 	case BOND_MODE_XOR:
 		bond_update_slave_arr(bond, NULL);
@@ -2372,14 +2372,14 @@ static void bond_miimon_commit(struct bonding *bond)
 			 * link status
 			 */
 			if (BOND_MODE(bond) == BOND_MODE_8023AD &&
-			    slave->link == BOND_LINK_UP)
+			    slave->link_state == BOND_LINK_UP)
 				bond_3ad_adapter_speed_duplex_changed(slave);
 			continue;
 
 		case BOND_LINK_UP:
 			if (bond_update_speed_duplex(slave) &&
 			    bond_needs_speed_duplex(bond)) {
-				slave->link = BOND_LINK_DOWN;
+				slave->link_state = BOND_LINK_DOWN;
 				if (net_ratelimit())
 					slave_warn(bond->dev, slave->dev,
 						   "failed to get link speed/duplex\n");
@@ -2843,7 +2843,7 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
 
 		bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
 
-		if (slave->link != BOND_LINK_UP) {
+		if (slave->link_state != BOND_LINK_UP) {
 			if (bond_time_in_interval(bond, trans_start, 1) &&
 			    bond_time_in_interval(bond, slave->last_rx, 1)) {
 
@@ -2863,7 +2863,7 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
 				}
 			}
 		} else {
-			/* slave->link == BOND_LINK_UP */
+			/* slave->link_state == BOND_LINK_UP */
 
 			/* not all switches will respond to an arp request
 			 * when the source ip is 0, so don't take the link down
@@ -2904,7 +2904,7 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
 
 		bond_for_each_slave(bond, slave, iter) {
 			if (slave->link_new_state != BOND_LINK_NOCHANGE)
-				slave->link = slave->link_new_state;
+				slave->link_state = slave->link_new_state;
 		}
 
 		if (slave_state_changed) {
@@ -2944,11 +2944,11 @@ static int bond_ab_arp_inspect(struct bonding *bond)
 		bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
 		last_rx = slave_last_rx(bond, slave);
 
-		if (slave->link != BOND_LINK_UP) {
+		if (slave->link_state != BOND_LINK_UP) {
 			if (bond_time_in_interval(bond, last_rx, 1)) {
 				bond_propose_link_state(slave, BOND_LINK_UP);
 				commit++;
-			} else if (slave->link == BOND_LINK_BACK) {
+			} else if (slave->link_state == BOND_LINK_BACK) {
 				bond_propose_link_state(slave, BOND_LINK_FAIL);
 				commit++;
 			}
@@ -3135,7 +3135,8 @@ static bool bond_ab_arp_probe(struct bonding *bond)
 		 * one the current slave so it is still marked
 		 * up when it is actually down
 		 */
-		if (!bond_slave_is_up(slave) && slave->link == BOND_LINK_UP) {
+		if (!bond_slave_is_up(slave) &&
+		    slave->link_state == BOND_LINK_UP) {
 			bond_set_slave_link_state(slave, BOND_LINK_DOWN,
 						  BOND_SLAVE_NOTIFY_LATER);
 			if (slave->link_failure_count < UINT_MAX)
@@ -3315,9 +3316,9 @@ static int bond_slave_netdev_event(unsigned long event,
 		if (bond_update_speed_duplex(slave) &&
 		    BOND_MODE(bond) == BOND_MODE_8023AD) {
 			if (slave->last_link_up)
-				slave->link = BOND_LINK_FAIL;
+				slave->link_state = BOND_LINK_FAIL;
 			else
-				slave->link = BOND_LINK_DOWN;
+				slave->link_state = BOND_LINK_DOWN;
 		}
 
 		if (BOND_MODE(bond) == BOND_MODE_8023AD)
@@ -4409,7 +4410,8 @@ static netdev_tx_t bond_xmit_broadcast(struct sk_buff *skb,
 	bond_for_each_slave_rcu(bond, slave, iter) {
 		if (bond_is_last_slave(bond, slave))
 			break;
-		if (bond_slave_is_up(slave) && slave->link == BOND_LINK_UP) {
+		if (bond_slave_is_up(slave) &&
+		    slave->link_state == BOND_LINK_UP) {
 			struct sk_buff *skb2 = skb_clone(skb, GFP_ATOMIC);
 
 			if (!skb2) {
@@ -4420,7 +4422,8 @@ static netdev_tx_t bond_xmit_broadcast(struct sk_buff *skb,
 			bond_dev_queue_xmit(bond, skb2, slave->dev);
 		}
 	}
-	if (slave && bond_slave_is_up(slave) && slave->link == BOND_LINK_UP)
+	if (slave && bond_slave_is_up(slave) &&
+	    slave->link_state == BOND_LINK_UP)
 		return bond_dev_queue_xmit(bond, skb, slave->dev);
 
 	return bond_tx_drop(bond_dev, skb);
@@ -4442,7 +4445,7 @@ static inline int bond_slave_override(struct bonding *bond,
 	bond_for_each_slave_rcu(bond, slave, iter) {
 		if (slave->queue_id == skb_get_queue_mapping(skb)) {
 			if (bond_slave_is_up(slave) &&
-			    slave->link == BOND_LINK_UP) {
+			    slave->link_state == BOND_LINK_UP) {
 				bond_dev_queue_xmit(bond, skb, slave->dev);
 				return 0;
 			}
diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
index f0f9138e967f..f9cee93b71f4 100644
--- a/drivers/net/bonding/bond_netlink.c
+++ b/drivers/net/bonding/bond_netlink.c
@@ -38,7 +38,7 @@ static int bond_fill_slave_info(struct sk_buff *skb,
 	if (nla_put_u8(skb, IFLA_BOND_SLAVE_STATE, bond_slave_state(slave)))
 		goto nla_put_failure;
 
-	if (nla_put_u8(skb, IFLA_BOND_SLAVE_MII_STATUS, slave->link))
+	if (nla_put_u8(skb, IFLA_BOND_SLAVE_MII_STATUS, slave->link_state))
 		goto nla_put_failure;
 
 	if (nla_put_u32(skb, IFLA_BOND_SLAVE_LINK_FAILURE_COUNT,
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 9abfaae1c6f7..72b136e52f9f 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -826,7 +826,8 @@ static int bond_option_active_slave_set(struct bonding *bond,
 			/* do nothing */
 			slave_dbg(bond->dev, new_active->dev, "is already the current active slave\n");
 		} else {
-			if (old_active && (new_active->link == BOND_LINK_UP) &&
+			if (old_active &&
+			    (new_active->link_state == BOND_LINK_UP) &&
 			    bond_slave_is_up(new_active)) {
 				slave_dbg(bond->dev, new_active->dev, "Setting as active slave\n");
 				bond_change_active_slave(bond, new_active);
diff --git a/drivers/net/bonding/bond_procfs.c b/drivers/net/bonding/bond_procfs.c
index fd5c9cbe45b1..710e57bff90a 100644
--- a/drivers/net/bonding/bond_procfs.c
+++ b/drivers/net/bonding/bond_procfs.c
@@ -172,7 +172,8 @@ static void bond_info_show_slave(struct seq_file *seq,
 	struct bonding *bond = PDE_DATA(file_inode(seq->file));
 
 	seq_printf(seq, "\nSlave Interface: %s\n", slave->dev->name);
-	seq_printf(seq, "MII Status: %s\n", bond_slave_link_status(slave->link));
+	seq_printf(seq, "MII Status: %s\n",
+		   bond_slave_link_status(slave->link_state));
 	if (slave->speed == SPEED_UNKNOWN)
 		seq_printf(seq, "Speed: %s\n", "Unknown");
 	else
diff --git a/drivers/net/bonding/bond_sysfs_slave.c b/drivers/net/bonding/bond_sysfs_slave.c
index 9b8346638f69..d462c0ea6da8 100644
--- a/drivers/net/bonding/bond_sysfs_slave.c
+++ b/drivers/net/bonding/bond_sysfs_slave.c
@@ -39,7 +39,7 @@ static SLAVE_ATTR_RO(state);
 
 static ssize_t mii_status_show(struct slave *slave, char *buf)
 {
-	return sprintf(buf, "%s\n", bond_slave_link_status(slave->link));
+	return sprintf(buf, "%s\n", bond_slave_link_status(slave->link_state));
 }
 static SLAVE_ATTR_RO(mii_status);
 
diff --git a/include/net/bond_3ad.h b/include/net/bond_3ad.h
index c8696a230b7d..7a3e79f106a7 100644
--- a/include/net/bond_3ad.h
+++ b/include/net/bond_3ad.h
@@ -296,7 +296,7 @@ void bond_3ad_unbind_slave(struct slave *slave);
 void bond_3ad_state_machine_handler(struct work_struct *);
 void bond_3ad_initiate_agg_selection(struct bonding *bond, int timeout);
 void bond_3ad_adapter_speed_duplex_changed(struct slave *slave);
-void bond_3ad_handle_link_change(struct slave *slave, char link);
+void bond_3ad_handle_link_change(struct slave *slave, char link_state);
 int  bond_3ad_get_active_agg_info(struct bonding *bond, struct ad_info *ad_info);
 int  __bond_3ad_get_active_agg_info(struct bonding *bond,
 				    struct ad_info *ad_info);
diff --git a/include/net/bond_alb.h b/include/net/bond_alb.h
index f6af76c87a6c..665037f421f5 100644
--- a/include/net/bond_alb.h
+++ b/include/net/bond_alb.h
@@ -154,7 +154,8 @@ int bond_alb_initialize(struct bonding *bond, int rlb_enabled);
 void bond_alb_deinitialize(struct bonding *bond);
 int bond_alb_init_slave(struct bonding *bond, struct slave *slave);
 void bond_alb_deinit_slave(struct bonding *bond, struct slave *slave);
-void bond_alb_handle_link_change(struct bonding *bond, struct slave *slave, char link);
+void bond_alb_handle_link_change(struct bonding *bond, struct slave *slave,
+				 char link_state);
 void bond_alb_handle_active_change(struct bonding *bond, struct slave *new_slave);
 int bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev);
 int bond_tlb_xmit(struct sk_buff *skb, struct net_device *bond_dev);
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 7d132cc1e584..a753f0282d73 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -162,7 +162,7 @@ struct slave {
 	unsigned long last_link_up;
 	unsigned long last_rx;
 	unsigned long target_last_arp_rx[BOND_MAX_ARP_TARGETS];
-	s8     link;		/* one of BOND_LINK_XXXX */
+	s8     link_state;	/* one of BOND_LINK_XXXX */
 	s8     link_new_state;	/* one of BOND_LINK_XXXX */
 	u8     backup:1,   /* indicates backup slave. Value corresponds with
 			      BOND_STATE_ACTIVE and BOND_STATE_BACKUP */
@@ -387,9 +387,9 @@ static inline void bond_slave_state_change(struct bonding *bond)
 	struct slave *tmp;
 
 	bond_for_each_slave(bond, tmp, iter) {
-		if (tmp->link == BOND_LINK_UP)
+		if (tmp->link_state == BOND_LINK_UP)
 			bond_set_active_slave(tmp);
-		else if (tmp->link == BOND_LINK_DOWN)
+		else if (tmp->link_state == BOND_LINK_DOWN)
 			bond_set_backup_slave(tmp);
 	}
 }
@@ -419,7 +419,7 @@ static inline bool bond_is_active_slave(struct slave *slave)
 
 static inline bool bond_slave_can_tx(struct slave *slave)
 {
-	return bond_slave_is_up(slave) && slave->link == BOND_LINK_UP &&
+	return bond_slave_is_up(slave) && slave->link_state == BOND_LINK_UP &&
 	       bond_is_active_slave(slave);
 }
 
@@ -558,7 +558,7 @@ static inline void bond_commit_link_state(struct slave *slave, bool notify)
 	if (slave->link_new_state == BOND_LINK_NOCHANGE)
 		return;
 
-	slave->link = slave->link_new_state;
+	slave->link_state = slave->link_new_state;
 	if (notify) {
 		bond_queue_slave_event(slave);
 		bond_lower_state_changed(slave);
-- 
2.27.0

