Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65C75B912C
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 15:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728796AbfITNwR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 20 Sep 2019 09:52:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51501 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728683AbfITNwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 09:52:14 -0400
Received: from 1.general.jvosburgh.uk.vpn ([10.172.196.206] helo=nyx.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1iBJKW-0005Md-37; Fri, 20 Sep 2019 13:52:12 +0000
Received: by nyx.localdomain (Postfix, from userid 1000)
        id CC8262415B1; Fri, 20 Sep 2019 15:52:11 +0200 (CEST)
Received: from nyx (localhost [127.0.0.1])
        by nyx.localdomain (Postfix) with ESMTP id C80A3289C5A;
        Fri, 20 Sep 2019 15:52:11 +0200 (CEST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
cc:     =?us-ascii?Q?=3D=3FUTF-8=3FB=3F0JDQu9C10LrRgdC10Lkg0JfQsNGF0LDRgNC+0LI?=
         =?us-ascii?Q?=3D=3F=3D?= <zaharov@selectel.ru>,
        netdev@vger.kernel.org
Subject: Re: Fwd: [PATCH] bonding/802.3ad: fix slave initialization states race
In-reply-to: <7236.1568906827@nyx>
References: <20190918130545.GA11133@yandex.ru> <31893.1568817274@nyx> <CAJYOGF9KZdouvmTxQcTOQgsi-uBxbvW50K3ufW1=8neeW98QVA@mail.gmail.com> <CAJYOGF8LDwbZXXeEioKAtx=0rq9eZBxFYuRfF3jdFCDUGnJ-Rg@mail.gmail.com> <9357.1568880036@nyx> <CAJYOGF87z-o9=a20dC2mZRtfMU58uL0yxZkQJ-bxe5skVvi2rA@mail.gmail.com> <7236.1568906827@nyx>
Comments: In-reply-to Jay Vosburgh <jay.vosburgh@canonical.com>
   message dated "Thu, 19 Sep 2019 17:27:07 +0200."
X-Mailer: MH-E 8.5+bzr; nmh 1.7.1-RC3; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7153.1568987531.1@nyx>
Content-Transfer-Encoding: 8BIT
Date:   Fri, 20 Sep 2019 15:52:11 +0200
Message-ID: <7154.1568987531@nyx>
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
[...]
>	In any event, I think I see what the failure is, I'm working up
>a patch to test and will post it when I have it ready.

	Aleksei,

	Would you be able to test the following patch and see if it
resolves the issue in your testing?  This is against current net-next,
but applies to current net as well.  Your kernel appears to be a bit
older (as the message formats differ), so hopefully it will apply there
as well.  I've tested this a bit (but not the ARP mon portion), and it
seems to do the right thing, but I can't reproduce the original issue
locally.

	Thanks,

	-J

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 931d9d935686..38042399717b 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2086,8 +2086,7 @@ static int bond_miimon_inspect(struct bonding *bond)
 	ignore_updelay = !rcu_dereference(bond->curr_active_slave);
 
 	bond_for_each_slave_rcu(bond, slave, iter) {
-		slave->new_link = BOND_LINK_NOCHANGE;
-		slave->link_new_state = slave->link;
+		bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
 
 		link_state = bond_check_dev_link(bond, slave->dev, 0);
 
@@ -2121,7 +2120,7 @@ static int bond_miimon_inspect(struct bonding *bond)
 			}
 
 			if (slave->delay <= 0) {
-				slave->new_link = BOND_LINK_DOWN;
+				bond_propose_link_state(slave, BOND_LINK_DOWN);
 				commit++;
 				continue;
 			}
@@ -2158,7 +2157,7 @@ static int bond_miimon_inspect(struct bonding *bond)
 				slave->delay = 0;
 
 			if (slave->delay <= 0) {
-				slave->new_link = BOND_LINK_UP;
+				bond_propose_link_state(slave, BOND_LINK_UP);
 				commit++;
 				ignore_updelay = false;
 				continue;
@@ -2196,7 +2195,7 @@ static void bond_miimon_commit(struct bonding *bond)
 	struct slave *slave, *primary;
 
 	bond_for_each_slave(bond, slave, iter) {
-		switch (slave->new_link) {
+		switch (slave->link_new_state) {
 		case BOND_LINK_NOCHANGE:
 			/* For 802.3ad mode, check current slave speed and
 			 * duplex again in case its port was disabled after
@@ -2268,8 +2267,8 @@ static void bond_miimon_commit(struct bonding *bond)
 
 		default:
 			slave_err(bond->dev, slave->dev, "invalid new link %d on slave\n",
-				  slave->new_link);
-			slave->new_link = BOND_LINK_NOCHANGE;
+				  slave->link_new_state);
+			bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
 
 			continue;
 		}
@@ -2677,13 +2676,13 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
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
@@ -2708,7 +2707,7 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
 			if (!bond_time_in_interval(bond, trans_start, 2) ||
 			    !bond_time_in_interval(bond, slave->last_rx, 2)) {
 
-				slave->new_link = BOND_LINK_DOWN;
+				bond_propose_link_state(slave, BOND_LINK_DOWN);
 				slave_state_changed = 1;
 
 				if (slave->link_failure_count < UINT_MAX)
@@ -2739,8 +2738,8 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
 			goto re_arm;
 
 		bond_for_each_slave(bond, slave, iter) {
-			if (slave->new_link != BOND_LINK_NOCHANGE)
-				slave->link = slave->new_link;
+			if (slave->link_new_state != BOND_LINK_NOCHANGE)
+				slave->link = slave->link_new_state;
 		}
 
 		if (slave_state_changed) {
@@ -2763,9 +2762,9 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
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
@@ -2777,12 +2776,12 @@ static int bond_ab_arp_inspect(struct bonding *bond)
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
@@ -2810,7 +2809,7 @@ static int bond_ab_arp_inspect(struct bonding *bond)
 		if (!bond_is_active_slave(slave) &&
 		    !rcu_access_pointer(bond->current_arp_slave) &&
 		    !bond_time_in_interval(bond, last_rx, 3)) {
-			slave->new_link = BOND_LINK_DOWN;
+			bond_propose_link_state(slave, BOND_LINK_DOWN);
 			commit++;
 		}
 
@@ -2823,7 +2822,7 @@ static int bond_ab_arp_inspect(struct bonding *bond)
 		if (bond_is_active_slave(slave) &&
 		    (!bond_time_in_interval(bond, trans_start, 2) ||
 		     !bond_time_in_interval(bond, last_rx, 2))) {
-			slave->new_link = BOND_LINK_DOWN;
+			bond_propose_link_state(slave, BOND_LINK_DOWN);
 			commit++;
 		}
 	}
@@ -2843,7 +2842,7 @@ static void bond_ab_arp_commit(struct bonding *bond)
 	struct slave *slave;
 
 	bond_for_each_slave(bond, slave, iter) {
-		switch (slave->new_link) {
+		switch (slave->link_new_state) {
 		case BOND_LINK_NOCHANGE:
 			continue;
 
@@ -2893,8 +2892,9 @@ static void bond_ab_arp_commit(struct bonding *bond)
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


---
	-Jay Vosburgh, jay.vosburgh@canonical.com
