Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32AC1B3142
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 22:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbgDUUdy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 Apr 2020 16:33:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44715 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbgDUUdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 16:33:53 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1jQzaT-0006jg-86; Tue, 21 Apr 2020 20:33:45 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 87FD867BB3; Tue, 21 Apr 2020 13:33:43 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 80A43AC1DC;
        Tue, 21 Apr 2020 13:33:43 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Maor Gottlieb <maorg@mellanox.com>
cc:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        vfalico@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        jiri@mellanox.com, dsahern@kernel.org, leonro@mellanox.com,
        saeedm@mellanox.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, alexr@mellanox.com
Subject: Re: [PATCH V3 mlx5-next 08/15] bonding: Add array of all salves
In-reply-to: <20200421102844.23640-9-maorg@mellanox.com>
References: <20200421102844.23640-1-maorg@mellanox.com> <20200421102844.23640-9-maorg@mellanox.com>
Comments: In-reply-to Maor Gottlieb <maorg@mellanox.com>
   message dated "Tue, 21 Apr 2020 13:28:37 +0300."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <19153.1587501223.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Tue, 21 Apr 2020 13:33:43 -0700
Message-ID: <19154.1587501223@famine>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maor Gottlieb <maorg@mellanox.com> wrote:

>Keep all slaves in array so it could be used to get the xmit slave
>assume all the slaves are active.
>The logic to add slave to the array is like the usable slaves, except
>that we also add slaves that currently can't transmit - not up or active.

	Typo: in the Subject, slaves is misspelled "salves."

>Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
>---
> drivers/net/bonding/bond_main.c | 80 +++++++++++++++++++++++++--------
> include/net/bonding.h           |  1 +
> 2 files changed, 62 insertions(+), 19 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>index 1b0ae750d732..c37fd57bfcd4 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -4120,6 +4120,40 @@ static void bond_skip_slave(struct bond_up_slave *slaves,
> 	}
> }
> 
>+static void bond_set_slave_arr(struct bonding *bond,
>+			       struct bond_up_slave *usable_slaves,
>+			       struct bond_up_slave *all_slaves)
>+{
>+	struct bond_up_slave *usable, *all;
>+
>+	usable = rtnl_dereference(bond->usable_slaves);
>+	rcu_assign_pointer(bond->usable_slaves, usable_slaves);
>+	if (usable)
>+		kfree_rcu(usable, rcu);
>+
>+	all = rtnl_dereference(bond->all_slaves);
>+	rcu_assign_pointer(bond->all_slaves, all_slaves);
>+	if (all)
>+		kfree_rcu(all, rcu);

	Minor nit: kfree_rcu can accept a NULL pointer, so testing
beforehand is unnecessary.


>+}
>+
>+static void bond_reset_slave_arr(struct bonding *bond)
>+{
>+	struct bond_up_slave *usable, *all;
>+
>+	usable = rtnl_dereference(bond->usable_slaves);
>+	if (usable) {
>+		RCU_INIT_POINTER(bond->usable_slaves, NULL);
>+		kfree_rcu(usable, rcu);
>+	}
>+
>+	all = rtnl_dereference(bond->all_slaves);
>+	if (all) {
>+		RCU_INIT_POINTER(bond->all_slaves, NULL);
>+		kfree_rcu(all, rcu);
>+	}
>+}
>+
> /* Build the usable slaves array in control path for modes that use xmit-hash
>  * to determine the slave interface -
>  * (a) BOND_MODE_8023AD
>@@ -4130,7 +4164,7 @@ static void bond_skip_slave(struct bond_up_slave *slaves,
>  */
> int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
> {
>-	struct bond_up_slave *usable_slaves, *old_usable_slaves;
>+	struct bond_up_slave *usable_slaves = NULL, *all_slaves = NULL;
> 	struct slave *slave;
> 	struct list_head *iter;
> 	int agg_id = 0;
>@@ -4142,7 +4176,9 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
> 
> 	usable_slaves = kzalloc(struct_size(usable_slaves, arr,
> 					    bond->slave_cnt), GFP_KERNEL);
>-	if (!usable_slaves) {
>+	all_slaves = kzalloc(struct_size(all_slaves, arr,
>+					 bond->slave_cnt), GFP_KERNEL);
>+	if (!usable_slaves || !all_slaves) {
> 		ret = -ENOMEM;
> 		goto out;
> 	}
>@@ -4151,20 +4187,19 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
> 
> 		if (bond_3ad_get_active_agg_info(bond, &ad_info)) {
> 			pr_debug("bond_3ad_get_active_agg_info failed\n");
>-			kfree_rcu(usable_slaves, rcu);
> 			/* No active aggragator means it's not safe to use
> 			 * the previous array.
> 			 */
>-			old_usable_slaves = rtnl_dereference(bond->usable_slaves);
>-			if (old_usable_slaves) {
>-				RCU_INIT_POINTER(bond->usable_slaves, NULL);
>-				kfree_rcu(old_usable_slaves, rcu);
>-			}
>+			bond_reset_slave_arr(bond);
> 			goto out;
> 		}
> 		agg_id = ad_info.aggregator_id;
> 	}
> 	bond_for_each_slave(bond, slave, iter) {
>+		if (skipslave == slave)
>+			continue;
>+
>+		all_slaves->arr[all_slaves->count++] = slave;
> 		if (BOND_MODE(bond) == BOND_MODE_8023AD) {
> 			struct aggregator *agg;
> 
>@@ -4174,8 +4209,6 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
> 		}
> 		if (!bond_slave_can_tx(slave))
> 			continue;
>-		if (skipslave == slave)
>-			continue;
> 
> 		slave_dbg(bond->dev, slave->dev, "Adding slave to tx hash array[%d]\n",
> 			  usable_slaves->count);
>@@ -4183,14 +4216,17 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
> 		usable_slaves->arr[usable_slaves->count++] = slave;
> 	}
> 
>-	old_usable_slaves = rtnl_dereference(bond->usable_slaves);
>-	rcu_assign_pointer(bond->usable_slaves, usable_slaves);
>-	if (old_usable_slaves)
>-		kfree_rcu(old_usable_slaves, rcu);
>+	bond_set_slave_arr(bond, usable_slaves, all_slaves);
>+	return ret;
> out:
>-	if (ret != 0 && skipslave)
>+	if (ret != 0 && skipslave) {
>+		bond_skip_slave(rtnl_dereference(bond->all_slaves),
>+				skipslave);
> 		bond_skip_slave(rtnl_dereference(bond->usable_slaves),
> 				skipslave);
>+	}
>+	kfree_rcu(all_slaves, rcu);
>+	kfree_rcu(usable_slaves, rcu);
> 
> 	return ret;
> }
>@@ -4501,9 +4537,9 @@ void bond_setup(struct net_device *bond_dev)
> static void bond_uninit(struct net_device *bond_dev)
> {
> 	struct bonding *bond = netdev_priv(bond_dev);
>+	struct bond_up_slave *usable, *all;
> 	struct list_head *iter;
> 	struct slave *slave;
>-	struct bond_up_slave *arr;
> 
> 	bond_netpoll_cleanup(bond_dev);
> 
>@@ -4512,10 +4548,16 @@ static void bond_uninit(struct net_device *bond_dev)
> 		__bond_release_one(bond_dev, slave->dev, true, true);
> 	netdev_info(bond_dev, "Released all slaves\n");
> 
>-	arr = rtnl_dereference(bond->usable_slaves);
>-	if (arr) {
>+	usable = rtnl_dereference(bond->usable_slaves);
>+	if (usable) {
> 		RCU_INIT_POINTER(bond->usable_slaves, NULL);
>-		kfree_rcu(arr, rcu);
>+		kfree_rcu(usable, rcu);
>+	}
>+
>+	all = rtnl_dereference(bond->all_slaves);
>+	if (all) {
>+		RCU_INIT_POINTER(bond->all_slaves, NULL);
>+		kfree_rcu(all, rcu);
> 	}
> 
> 	list_del(&bond->bond_list);
>diff --git a/include/net/bonding.h b/include/net/bonding.h
>index 33bdb6d5182d..a2a7f461fa63 100644
>--- a/include/net/bonding.h
>+++ b/include/net/bonding.h
>@@ -201,6 +201,7 @@ struct bonding {
> 	struct   slave __rcu *current_arp_slave;
> 	struct   slave __rcu *primary_slave;
> 	struct   bond_up_slave __rcu *usable_slaves; /* Array of usable slaves */
>+	struct   bond_up_slave __rcu *all_slaves; /* Array of all slaves */

	Another nit: these comments don't really add much now, given the
new names of the arrays.  I don't know if the nits are worth respinning
the patch set, but the Subject ought to get fixed.

	I've looked at the other bonding patches in the series and don't
have any other comments, so for the series:

Reviewed-by: Jay Vosburgh <jay.vosburgh@canonical.com>

	-J

> 	bool     force_primary;
> 	s32      slave_cnt; /* never change this value outside the attach/detach wrappers */
> 	int     (*recv_probe)(const struct sk_buff *, struct bonding *,
>-- 
>2.17.2
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
