Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70BB4B9CD1
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 09:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437645AbfIUHGI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 21 Sep 2019 03:06:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50029 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437304AbfIUHGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Sep 2019 03:06:07 -0400
Received: from [217.16.13.130] (helo=nyx.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1iBZT1-0004Ig-U7; Sat, 21 Sep 2019 07:06:05 +0000
Received: by nyx.localdomain (Postfix, from userid 1000)
        id 102242415B1; Sat, 21 Sep 2019 09:06:00 +0200 (CEST)
Received: from nyx (localhost [127.0.0.1])
        by nyx.localdomain (Postfix) with ESMTP id 07E85289C52;
        Sat, 21 Sep 2019 09:06:00 +0200 (CEST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     =?us-ascii?Q?=3D=3FUTF-8=3FB=3F0JDQu9C10LrRgdC10Lkg0JfQsNGF0LDRgNC+0LI?=
         =?us-ascii?Q?=3D=3F=3D?= <zaharov@selectel.ru>
cc:     netdev@vger.kernel.org
Subject: Re: Fwd: [PATCH] bonding/802.3ad: fix slave initialization states race
In-reply-to: <CAJYOGF-L0bEF_BqbyeKqv4xmLV=e2VKUvo5zPx4rULWdwt8e0Q@mail.gmail.com>
References: <20190918130545.GA11133@yandex.ru> <31893.1568817274@nyx> <CAJYOGF9KZdouvmTxQcTOQgsi-uBxbvW50K3ufW1=8neeW98QVA@mail.gmail.com> <CAJYOGF8LDwbZXXeEioKAtx=0rq9eZBxFYuRfF3jdFCDUGnJ-Rg@mail.gmail.com> <9357.1568880036@nyx> <CAJYOGF87z-o9=a20dC2mZRtfMU58uL0yxZkQJ-bxe5skVvi2rA@mail.gmail.com> <7236.1568906827@nyx> <7154.1568987531@nyx> <CAJYOGF-L0bEF_BqbyeKqv4xmLV=e2VKUvo5zPx4rULWdwt8e0Q@mail.gmail.com>
Comments: In-reply-to =?us-ascii?Q?=3D=3FUTF-8=3FB=3F0JDQu9C10LrRgdC10Lkg0?=
 =?us-ascii?Q?JfQsNGF0LDRgNC+0LI=3D=3F=3D?= <zaharov@selectel.ru>
   message dated "Fri, 20 Sep 2019 19:00:17 +0300."
X-Mailer: MH-E 8.5+bzr; nmh 1.7.1-RC3; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date:   Sat, 21 Sep 2019 09:06:00 +0200
Message-ID: <10497.1569049560@nyx>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Алексей Захаров wrote:

>>
>> Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
>> [...]
>> >       In any event, I think I see what the failure is, I'm working up
>> >a patch to test and will post it when I have it ready.
>>
>>         Aleksei,
>>
>>         Would you be able to test the following patch and see if it
>> resolves the issue in your testing?  This is against current net-next,
>> but applies to current net as well.  Your kernel appears to be a bit
>> older (as the message formats differ), so hopefully it will apply there
>> as well.  I've tested this a bit (but not the ARP mon portion), and it
>> seems to do the right thing, but I can't reproduce the original issue
>> locally.
>We're testing on ubuntu-bionic 4.15 kernel.

	I believe the following will apply for the Ubuntu 4.15 kernels;
this is against 4.15.0-60, so you may have some fuzz if your version is
far removed.  I've not tested this as I'm travelling at the moment, but
the only real difference is the netdev_err vs. slave_err changes in
bonding that aren't relevant to the fix itself.

	-J

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 8cd25eb26a9a..b159a6595e11 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2057,8 +2057,7 @@ static int bond_miimon_inspect(struct bonding *bond)
 	ignore_updelay = !rcu_dereference(bond->curr_active_slave);
 
 	bond_for_each_slave_rcu(bond, slave, iter) {
-		slave->new_link = BOND_LINK_NOCHANGE;
-		slave->link_new_state = slave->link;
+		bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
 
 		link_state = bond_check_dev_link(bond, slave->dev, 0);
 
@@ -2094,7 +2093,7 @@ static int bond_miimon_inspect(struct bonding *bond)
 			}
 
 			if (slave->delay <= 0) {
-				slave->new_link = BOND_LINK_DOWN;
+				bond_propose_link_state(slave, BOND_LINK_DOWN);
 				commit++;
 				continue;
 			}
@@ -2133,7 +2132,7 @@ static int bond_miimon_inspect(struct bonding *bond)
 				slave->delay = 0;
 
 			if (slave->delay <= 0) {
-				slave->new_link = BOND_LINK_UP;
+				bond_propose_link_state(slave, BOND_LINK_UP);
 				commit++;
 				ignore_updelay = false;
 				continue;
@@ -2153,7 +2152,7 @@ static void bond_miimon_commit(struct bonding *bond)
 	struct slave *slave, *primary;
 
 	bond_for_each_slave(bond, slave, iter) {
-		switch (slave->new_link) {
+		switch (slave->link_new_state) {
 		case BOND_LINK_NOCHANGE:
 			continue;
 
@@ -2237,8 +2236,8 @@ static void bond_miimon_commit(struct bonding *bond)
 
 		default:
 			netdev_err(bond->dev, "invalid new link %d on slave %s\n",
-				   slave->new_link, slave->dev->name);
-			slave->new_link = BOND_LINK_NOCHANGE;
+				   slave->link_new_state, slave->dev->name);
+			bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
 
 			continue;
 		}
@@ -2638,13 +2637,13 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
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
@@ -2671,7 +2670,7 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
 			if (!bond_time_in_interval(bond, trans_start, 2) ||
 			    !bond_time_in_interval(bond, slave->last_rx, 2)) {
 
-				slave->new_link = BOND_LINK_DOWN;
+				bond_propose_link_state(slave, BOND_LINK_DOWN);
 				slave_state_changed = 1;
 
 				if (slave->link_failure_count < UINT_MAX)
@@ -2703,8 +2702,8 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
 			goto re_arm;
 
 		bond_for_each_slave(bond, slave, iter) {
-			if (slave->new_link != BOND_LINK_NOCHANGE)
-				slave->link = slave->new_link;
+			if (slave->link_new_state != BOND_LINK_NOCHANGE)
+				slave->link = slave->link_new_state;
 		}
 
 		if (slave_state_changed) {
@@ -2727,9 +2726,9 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
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
@@ -2741,12 +2740,12 @@ static int bond_ab_arp_inspect(struct bonding *bond)
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
@@ -2774,7 +2773,7 @@ static int bond_ab_arp_inspect(struct bonding *bond)
 		if (!bond_is_active_slave(slave) &&
 		    !rcu_access_pointer(bond->current_arp_slave) &&
 		    !bond_time_in_interval(bond, last_rx, 3)) {
-			slave->new_link = BOND_LINK_DOWN;
+			bond_propose_link_state(slave, BOND_LINK_DOWN);
 			commit++;
 		}
 
@@ -2787,7 +2786,7 @@ static int bond_ab_arp_inspect(struct bonding *bond)
 		if (bond_is_active_slave(slave) &&
 		    (!bond_time_in_interval(bond, trans_start, 2) ||
 		     !bond_time_in_interval(bond, last_rx, 2))) {
-			slave->new_link = BOND_LINK_DOWN;
+			bond_propose_link_state(slave, BOND_LINK_DOWN);
 			commit++;
 		}
 	}
@@ -2807,7 +2806,7 @@ static void bond_ab_arp_commit(struct bonding *bond)
 	struct slave *slave;
 
 	bond_for_each_slave(bond, slave, iter) {
-		switch (slave->new_link) {
+		switch (slave->link_new_state) {
 		case BOND_LINK_NOCHANGE:
 			continue;
 
@@ -2859,8 +2858,8 @@ static void bond_ab_arp_commit(struct bonding *bond)
 			continue;
 
 		default:
-			netdev_err(bond->dev, "impossible: new_link %d on slave %s\n",
-				   slave->new_link, slave->dev->name);
+			netdev_err(bond->dev, "impossible: link_new_state %d on slave %s\n",
+				   slave->link_new_state, slave->dev->name);
 			continue;
 		}
 
diff --git a/include/net/bonding.h b/include/net/bonding.h
index af927d97c1c1..65361d56109e 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -149,7 +149,6 @@ struct slave {
 	unsigned long target_last_arp_rx[BOND_MAX_ARP_TARGETS];
 	s8     link;		/* one of BOND_LINK_XXXX */
 	s8     link_new_state;	/* one of BOND_LINK_XXXX */
-	s8     new_link;
 	u8     backup:1,   /* indicates backup slave. Value corresponds with
 			      BOND_STATE_ACTIVE and BOND_STATE_BACKUP */
 	       inactive:1, /* indicates inactive slave */
@@ -519,7 +518,7 @@ static inline void bond_propose_link_state(struct slave *slave, int state)
 
 static inline void bond_commit_link_state(struct slave *slave, bool notify)
 {
-	if (slave->link == slave->link_new_state)
+	if (slave->link_new_state == BOND_LINK_NOCHANGE)
 		return;
 
 	slave->link = slave->link_new_state;
-- 
2.23.0

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
