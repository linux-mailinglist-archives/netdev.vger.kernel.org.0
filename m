Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70BD5BD5BF
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 02:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389533AbfIYAbO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 24 Sep 2019 20:31:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43584 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388529AbfIYAbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 20:31:14 -0400
Received: from c-67-160-6-8.hsd1.wa.comcast.net ([67.160.6.8] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1iCvD2-0004CG-WA; Wed, 25 Sep 2019 00:31:09 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 7A49E67BB3; Tue, 24 Sep 2019 17:31:07 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 73FC8A9BF8;
        Tue, 24 Sep 2019 17:31:07 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     =?us-ascii?Q?=3D=3FUTF-8=3FB=3F0JDQu9C10LrRgdC10Lkg0JfQsNGF0LDRgNC+0LI?=
         =?us-ascii?Q?=3D=3F=3D?= <zaharov@selectel.ru>
cc:     netdev@vger.kernel.org, "zhangsha (A)" <zhangsha.zhang@huawei.com>
Subject: Re: Fwd: [PATCH] bonding/802.3ad: fix slave initialization states race
In-reply-to: <CAJYOGF_XStpFRkp0jN0um9d9WR1bqGpK2V=UgdnnX2m4YC=5pw@mail.gmail.com>
References: <20190918130545.GA11133@yandex.ru> <31893.1568817274@nyx> <CAJYOGF9KZdouvmTxQcTOQgsi-uBxbvW50K3ufW1=8neeW98QVA@mail.gmail.com> <CAJYOGF8LDwbZXXeEioKAtx=0rq9eZBxFYuRfF3jdFCDUGnJ-Rg@mail.gmail.com> <9357.1568880036@nyx> <CAJYOGF87z-o9=a20dC2mZRtfMU58uL0yxZkQJ-bxe5skVvi2rA@mail.gmail.com> <7236.1568906827@nyx> <7154.1568987531@nyx> <CAJYOGF-L0bEF_BqbyeKqv4xmLV=e2VKUvo5zPx4rULWdwt8e0Q@mail.gmail.com> <10497.1569049560@nyx> <CAJYOGF_XStpFRkp0jN0um9d9WR1bqGpK2V=UgdnnX2m4YC=5pw@mail.gmail.com>
Comments: In-reply-to =?us-ascii?Q?=3D=3FUTF-8=3FB=3F0JDQu9C10LrRgdC10Lkg0?=
 =?us-ascii?Q?JfQsNGF0LDRgNC+0LI=3D=3F=3D?= <zaharov@selectel.ru>
   message dated "Sat, 21 Sep 2019 14:17:57 +0300."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date:   Tue, 24 Sep 2019 17:31:07 -0700
Message-ID: <16538.1569371467@famine>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Алексей Захаров wrote:
[...]
>Right after reboot one of the slaves hangs with actor port state 71
>and partner port state 1.
>It doesn't send lacpdu and seems to be broken.
>Setting link down and up again fixes slave state.
[...]

	I think I see what failed in the first patch, could you test the
following patch?  This one is for net-next, so you'd need to again swap
slave_err / netdev_err for the Ubuntu 4.15 kernel.

	Thanks,

	-J


diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 931d9d935686..5e248588259a 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1617,6 +1617,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	if (bond->params.miimon) {
 		if (bond_check_dev_link(bond, slave_dev, 0) == BMSR_LSTATUS) {
 			if (bond->params.updelay) {
+/*XXX*/slave_info(bond_dev, slave_dev, "BOND_LINK_BACK initial state\n");
 				bond_set_slave_link_state(new_slave,
 							  BOND_LINK_BACK,
 							  BOND_SLAVE_NOTIFY_NOW);
@@ -2086,8 +2087,7 @@ static int bond_miimon_inspect(struct bonding *bond)
 	ignore_updelay = !rcu_dereference(bond->curr_active_slave);
 
 	bond_for_each_slave_rcu(bond, slave, iter) {
-		slave->new_link = BOND_LINK_NOCHANGE;
-		slave->link_new_state = slave->link;
+		bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
 
 		link_state = bond_check_dev_link(bond, slave->dev, 0);
 
@@ -2096,8 +2096,6 @@ static int bond_miimon_inspect(struct bonding *bond)
 			if (link_state)
 				continue;
 
-			bond_propose_link_state(slave, BOND_LINK_FAIL);
-			commit++;
 			slave->delay = bond->params.downdelay;
 			if (slave->delay) {
 				slave_info(bond->dev, slave->dev, "link status down for %sinterface, disabling it in %d ms\n",
@@ -2106,6 +2104,7 @@ static int bond_miimon_inspect(struct bonding *bond)
 					    (bond_is_active_slave(slave) ?
 					     "active " : "backup ") : "",
 					   bond->params.downdelay * bond->params.miimon);
+				slave->link = BOND_LINK_FAIL;
 			}
 			/*FALLTHRU*/
 		case BOND_LINK_FAIL:
@@ -2121,7 +2120,7 @@ static int bond_miimon_inspect(struct bonding *bond)
 			}
 
 			if (slave->delay <= 0) {
-				slave->new_link = BOND_LINK_DOWN;
+				bond_propose_link_state(slave, BOND_LINK_DOWN);
 				commit++;
 				continue;
 			}
@@ -2133,15 +2132,13 @@ static int bond_miimon_inspect(struct bonding *bond)
 			if (!link_state)
 				continue;
 
-			bond_propose_link_state(slave, BOND_LINK_BACK);
-			commit++;
 			slave->delay = bond->params.updelay;
-
 			if (slave->delay) {
 				slave_info(bond->dev, slave->dev, "link status up, enabling it in %d ms\n",
 					   ignore_updelay ? 0 :
 					   bond->params.updelay *
 					   bond->params.miimon);
+				slave->link = BOND_LINK_BACK;
 			}
 			/*FALLTHRU*/
 		case BOND_LINK_BACK:
@@ -2158,7 +2155,7 @@ static int bond_miimon_inspect(struct bonding *bond)
 				slave->delay = 0;
 
 			if (slave->delay <= 0) {
-				slave->new_link = BOND_LINK_UP;
+				bond_propose_link_state(slave, BOND_LINK_UP);
 				commit++;
 				ignore_updelay = false;
 				continue;
@@ -2196,7 +2193,7 @@ static void bond_miimon_commit(struct bonding *bond)
 	struct slave *slave, *primary;
 
 	bond_for_each_slave(bond, slave, iter) {
-		switch (slave->new_link) {
+		switch (slave->link_new_state) {
 		case BOND_LINK_NOCHANGE:
 			/* For 802.3ad mode, check current slave speed and
 			 * duplex again in case its port was disabled after
@@ -2268,8 +2265,8 @@ static void bond_miimon_commit(struct bonding *bond)
 
 		default:
 			slave_err(bond->dev, slave->dev, "invalid new link %d on slave\n",
-				  slave->new_link);
-			slave->new_link = BOND_LINK_NOCHANGE;
+				  slave->link_new_state);
+			bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
 
 			continue;
 		}
@@ -2677,13 +2674,13 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
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
@@ -2708,7 +2705,7 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
 			if (!bond_time_in_interval(bond, trans_start, 2) ||
 			    !bond_time_in_interval(bond, slave->last_rx, 2)) {
 
-				slave->new_link = BOND_LINK_DOWN;
+				bond_propose_link_state(slave, BOND_LINK_DOWN);
 				slave_state_changed = 1;
 
 				if (slave->link_failure_count < UINT_MAX)
@@ -2739,8 +2736,8 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
 			goto re_arm;
 
 		bond_for_each_slave(bond, slave, iter) {
-			if (slave->new_link != BOND_LINK_NOCHANGE)
-				slave->link = slave->new_link;
+			if (slave->link_new_state != BOND_LINK_NOCHANGE)
+				slave->link = slave->link_new_state;
 		}
 
 		if (slave_state_changed) {
@@ -2763,9 +2760,9 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
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
@@ -2777,12 +2774,12 @@ static int bond_ab_arp_inspect(struct bonding *bond)
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
@@ -2810,7 +2807,7 @@ static int bond_ab_arp_inspect(struct bonding *bond)
 		if (!bond_is_active_slave(slave) &&
 		    !rcu_access_pointer(bond->current_arp_slave) &&
 		    !bond_time_in_interval(bond, last_rx, 3)) {
-			slave->new_link = BOND_LINK_DOWN;
+			bond_propose_link_state(slave, BOND_LINK_DOWN);
 			commit++;
 		}
 
@@ -2823,7 +2820,7 @@ static int bond_ab_arp_inspect(struct bonding *bond)
 		if (bond_is_active_slave(slave) &&
 		    (!bond_time_in_interval(bond, trans_start, 2) ||
 		     !bond_time_in_interval(bond, last_rx, 2))) {
-			slave->new_link = BOND_LINK_DOWN;
+			bond_propose_link_state(slave, BOND_LINK_DOWN);
 			commit++;
 		}
 	}
@@ -2843,7 +2840,7 @@ static void bond_ab_arp_commit(struct bonding *bond)
 	struct slave *slave;
 
 	bond_for_each_slave(bond, slave, iter) {
-		switch (slave->new_link) {
+		switch (slave->link_new_state) {
 		case BOND_LINK_NOCHANGE:
 			continue;
 
@@ -2893,8 +2890,9 @@ static void bond_ab_arp_commit(struct bonding *bond)
 			continue;
 
 		default:
-			slave_err(bond->dev, slave->dev, "impossible: new_link %d on slave\n",
-				  slave->new_link);
+			slave_err(bond->dev, slave->dev,
+				  "impossible: link_new_state %d on slave\n",
+				  slave->link_new_state);
 			continue;
 		}
 
@@ -3133,6 +3131,7 @@ static int bond_slave_netdev_event(unsigned long event,
 		 * let link-monitoring (miimon) set it right when correct
 		 * speeds/duplex are available.
 		 */
+/*XXX*/slave_info(bond_dev, slave_dev, "EVENT %lu llu %lu\n", event, slave->last_link_up);
 		if (bond_update_speed_duplex(slave) &&
 		    BOND_MODE(bond) == BOND_MODE_8023AD) {
 			if (slave->last_link_up)
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


---
	-Jay Vosburgh, jay.vosburgh@canonical.com
