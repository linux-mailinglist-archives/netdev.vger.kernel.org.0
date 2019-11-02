Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D490BECD15
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 05:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbfKBEN2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 2 Nov 2019 00:13:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44031 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbfKBEN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Nov 2019 00:13:28 -0400
Received: from c-67-160-6-8.hsd1.wa.comcast.net ([67.160.6.8] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1iQkmu-00067U-RZ; Sat, 02 Nov 2019 04:13:21 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 0FA7A6032A; Fri,  1 Nov 2019 21:13:19 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 0763FA9BF8;
        Fri,  1 Nov 2019 21:13:19 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     netdev@vger.kernel.org
Cc:     Aleksei Zakharov <zakharov.a.g@yandex.ru>,
        Sha Zhang <zhangsha.zhang@huawei.com>,
        Mahesh Bandewar <maheshb@google.com>,
        "David Miller" <davem@davemloft.net>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <675.1572667998.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Fri, 01 Nov 2019 21:13:19 -0700
Message-ID: <676.1572667999@famine>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fcc: canonical-drivel
Subject: [PATCH net] bonding: fix state transition issue in link monitoring
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
-------

	 Since de77ecd4ef02 ("bonding: improve link-status update in
mii-monitoring"), the bonding driver has utilized two separate variables
to indicate the next link state a particular slave should transition to.
Each is used to communicate to a different portion of the link state
change commit logic; one to the bond_miimon_commit function itself, and
another to the state transition logic.

	Unfortunately, the two variables can become unsynchronized,
resulting in incorrect link state transitions within bonding.  This can
cause slaves to become stuck in an incorrect link state until a
subsequent carrier state transition.

	The issue occurs when a special case in bond_slave_netdev_event
sets slave->link directly to BOND_LINK_FAIL.  On the next pass through
bond_miimon_inspect after the slave goes carrier up, the BOND_LINK_FAIL
case will set the proposed next state (link_new_state) to BOND_LINK_UP,
but the new_link to BOND_LINK_DOWN.  The setting of the final link state
from new_link comes after that from link_new_state, and so the slave
will end up incorrectly in _DOWN state.

	Resolve this by combining the two variables into one.

Reported-by: Aleksei Zakharov <zakharov.a.g@yandex.ru>
Reported-by: Sha Zhang <zhangsha.zhang@huawei.com>
Cc: Mahesh Bandewar <maheshb@google.com>
Fixes: de77ecd4ef02 ("bonding: improve link-status update in mii-monitoring")
Signed-off-by: Jay Vosburgh <jay.vosburgh@canonical.com>

---

	Note that the additional variable link_new_state is added at
f307668bfcb7, but the functional change occurs at de77ecd4ef02.

 drivers/net/bonding/bond_main.c | 44 ++++++++++++++++++++---------------------
 include/net/bonding.h           |  3 +--
 2 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 3e496e746cc6..3e8ba26fcae6 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2131,8 +2131,7 @@ static int bond_miimon_inspect(struct bonding *bond)
 	ignore_updelay = !rcu_dereference(bond->curr_active_slave);
 
 	bond_for_each_slave_rcu(bond, slave, iter) {
-		slave->new_link = BOND_LINK_NOCHANGE;
-		slave->link_new_state = slave->link;
+		bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
 
 		link_state = bond_check_dev_link(bond, slave->dev, 0);
 
@@ -2166,7 +2165,7 @@ static int bond_miimon_inspect(struct bonding *bond)
 			}
 
 			if (slave->delay <= 0) {
-				slave->new_link = BOND_LINK_DOWN;
+				bond_propose_link_state(slave, BOND_LINK_DOWN);
 				commit++;
 				continue;
 			}
@@ -2203,7 +2202,7 @@ static int bond_miimon_inspect(struct bonding *bond)
 				slave->delay = 0;
 
 			if (slave->delay <= 0) {
-				slave->new_link = BOND_LINK_UP;
+				bond_propose_link_state(slave, BOND_LINK_UP);
 				commit++;
 				ignore_updelay = false;
 				continue;
@@ -2241,7 +2240,7 @@ static void bond_miimon_commit(struct bonding *bond)
 	struct slave *slave, *primary;
 
 	bond_for_each_slave(bond, slave, iter) {
-		switch (slave->new_link) {
+		switch (slave->link_new_state) {
 		case BOND_LINK_NOCHANGE:
 			/* For 802.3ad mode, check current slave speed and
 			 * duplex again in case its port was disabled after
@@ -2313,8 +2312,8 @@ static void bond_miimon_commit(struct bonding *bond)
 
 		default:
 			slave_err(bond->dev, slave->dev, "invalid new link %d on slave\n",
-				  slave->new_link);
-			slave->new_link = BOND_LINK_NOCHANGE;
+				  slave->link_new_state);
+			bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
 
 			continue;
 		}
@@ -2722,13 +2721,13 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
 	bond_for_each_slave_rcu(bond, slave, iter) {
 		unsigned long trans_start = dev_trans_start(slave->dev);
 
-		slave->new_link = BOND_LINK_NOCHANGE;
+		bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
 
 		if (slave->link != BOND_LINK_UP) {
 			if (bond_time_in_interval(bond, trans_start, 1) &&
 			    bond_time_in_interval(bond, slave->last_rx, 1)) {
 
-				slave->new_link = BOND_LINK_UP;
+				bond_propose_link_state(slave, BOND_LINK_UP);
 				slave_state_changed = 1;
 
 				/* primary_slave has no meaning in round-robin
@@ -2753,7 +2752,7 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
 			if (!bond_time_in_interval(bond, trans_start, 2) ||
 			    !bond_time_in_interval(bond, slave->last_rx, 2)) {
 
-				slave->new_link = BOND_LINK_DOWN;
+				bond_propose_link_state(slave, BOND_LINK_DOWN);
 				slave_state_changed = 1;
 
 				if (slave->link_failure_count < UINT_MAX)
@@ -2784,8 +2783,8 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
 			goto re_arm;
 
 		bond_for_each_slave(bond, slave, iter) {
-			if (slave->new_link != BOND_LINK_NOCHANGE)
-				slave->link = slave->new_link;
+			if (slave->link_new_state != BOND_LINK_NOCHANGE)
+				slave->link = slave->link_new_state;
 		}
 
 		if (slave_state_changed) {
@@ -2808,9 +2807,9 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
 }
 
 /* Called to inspect slaves for active-backup mode ARP monitor link state
- * changes.  Sets new_link in slaves to specify what action should take
- * place for the slave.  Returns 0 if no changes are found, >0 if changes
- * to link states must be committed.
+ * changes.  Sets proposed link state in slaves to specify what action
+ * should take place for the slave.  Returns 0 if no changes are found, >0
+ * if changes to link states must be committed.
  *
  * Called with rcu_read_lock held.
  */
@@ -2822,12 +2821,12 @@ static int bond_ab_arp_inspect(struct bonding *bond)
 	int commit = 0;
 
 	bond_for_each_slave_rcu(bond, slave, iter) {
-		slave->new_link = BOND_LINK_NOCHANGE;
+		bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
 		last_rx = slave_last_rx(bond, slave);
 
 		if (slave->link != BOND_LINK_UP) {
 			if (bond_time_in_interval(bond, last_rx, 1)) {
-				slave->new_link = BOND_LINK_UP;
+				bond_propose_link_state(slave, BOND_LINK_UP);
 				commit++;
 			}
 			continue;
@@ -2855,7 +2854,7 @@ static int bond_ab_arp_inspect(struct bonding *bond)
 		if (!bond_is_active_slave(slave) &&
 		    !rcu_access_pointer(bond->current_arp_slave) &&
 		    !bond_time_in_interval(bond, last_rx, 3)) {
-			slave->new_link = BOND_LINK_DOWN;
+			bond_propose_link_state(slave, BOND_LINK_DOWN);
 			commit++;
 		}
 
@@ -2868,7 +2867,7 @@ static int bond_ab_arp_inspect(struct bonding *bond)
 		if (bond_is_active_slave(slave) &&
 		    (!bond_time_in_interval(bond, trans_start, 2) ||
 		     !bond_time_in_interval(bond, last_rx, 2))) {
-			slave->new_link = BOND_LINK_DOWN;
+			bond_propose_link_state(slave, BOND_LINK_DOWN);
 			commit++;
 		}
 	}
@@ -2888,7 +2887,7 @@ static void bond_ab_arp_commit(struct bonding *bond)
 	struct slave *slave;
 
 	bond_for_each_slave(bond, slave, iter) {
-		switch (slave->new_link) {
+		switch (slave->link_new_state) {
 		case BOND_LINK_NOCHANGE:
 			continue;
 
@@ -2938,8 +2937,9 @@ static void bond_ab_arp_commit(struct bonding *bond)
 			continue;
 
 		default:
-			slave_err(bond->dev, slave->dev, "impossible: new_link %d on slave\n",
-				  slave->new_link);
+			slave_err(bond->dev, slave->dev,
+				  "impossible: link_new_state %d on slave\n",
+				  slave->link_new_state);
 			continue;
 		}
 
diff --git a/include/net/bonding.h b/include/net/bonding.h
index f7fe45689142..d416af72404b 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -159,7 +159,6 @@ struct slave {
 	unsigned long target_last_arp_rx[BOND_MAX_ARP_TARGETS];
 	s8     link;		/* one of BOND_LINK_XXXX */
 	s8     link_new_state;	/* one of BOND_LINK_XXXX */
-	s8     new_link;
 	u8     backup:1,   /* indicates backup slave. Value corresponds with
 			      BOND_STATE_ACTIVE and BOND_STATE_BACKUP */
 	       inactive:1, /* indicates inactive slave */
@@ -549,7 +548,7 @@ static inline void bond_propose_link_state(struct slave *slave, int state)
 
 static inline void bond_commit_link_state(struct slave *slave, bool notify)
 {
-	if (slave->link == slave->link_new_state)
+	if (slave->link_new_state == BOND_LINK_NOCHANGE)
 		return;
 
 	slave->link = slave->link_new_state;
-- 
2.7.4

