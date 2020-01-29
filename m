Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99B1614C485
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 03:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgA2CJF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 28 Jan 2020 21:09:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41895 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgA2CJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 21:09:05 -0500
Received: from c-67-160-6-8.hsd1.wa.comcast.net ([67.160.6.8] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1iwcmp-0002wQ-DY; Wed, 29 Jan 2020 02:08:59 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 6D94E67BB3; Tue, 28 Jan 2020 18:08:57 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 65AC4AC1CC;
        Tue, 28 Jan 2020 18:08:57 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Maor Gottlieb <maorg@mellanox.com>
cc:     vfalico@gmail.com, andy@greyhouse.net, jiri@mellanox.com,
        davem@davemloft.net, netdev@vger.kernel.org, saeedm@mellanox.com,
        jgg@mellanox.com, leonro@mellanox.com, alexr@mellanox.com,
        markz@mellanox.com, parav@mellanox.com, eranbe@mellanox.com,
        linux-rdma@vger.kernel.org
Subject: Re: [RFC PATCH 4/4] bonding: Implement ndo_xmit_slave_get
In-reply-to: <20200126132126.9981-5-maorg@mellanox.com>
References: <20200126132126.9981-1-maorg@mellanox.com> <20200126132126.9981-5-maorg@mellanox.com>
Comments: In-reply-to Maor Gottlieb <maorg@mellanox.com>
   message dated "Sun, 26 Jan 2020 15:21:26 +0200."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <708.1580263737.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Tue, 28 Jan 2020 18:08:57 -0800
Message-ID: <709.1580263737@famine>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maor Gottlieb <maorg@mellanox.com> wrote:

>Add implementation of ndo_xmit_slave_get.
>When user set the LAG_FLAGS_HASH_ALL_SLAVES bit and the xmit slave
>result is based on the hash, then the slave will be selected from the
>array of all the slaves.
>
>Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
>---
> drivers/net/bonding/bond_main.c | 63 ++++++++++++++++++++++++++++++---
> include/net/bonding.h           |  1 +
> 2 files changed, 60 insertions(+), 4 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>index adab1e3549ff..c8f440d1b624 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -4098,7 +4098,8 @@ static void bond_skip_slave(struct bond_up_slave *slaves,
>  */
> int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
> {
>-	struct bond_up_slave *active_slaves, *old_active_slaves;
>+	struct bond_up_slave *active_slaves = NULL, *all_slaves = NULL;
>+	struct bond_up_slave *old_active_slaves, *old_all_slaves;
> 	struct slave *slave;
> 	struct list_head *iter;
> 	int agg_id = 0;
>@@ -4110,7 +4111,9 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
> 
> 	active_slaves = kzalloc(struct_size(active_slaves, arr,
> 					    bond->slave_cnt), GFP_KERNEL);
>-	if (!active_slaves) {
>+	all_slaves = kzalloc(struct_size(all_slaves, arr,
>+					 bond->slave_cnt), GFP_KERNEL);
>+	if (!active_slaves || !all_slaves) {
> 		ret = -ENOMEM;
> 		pr_err("Failed to build slave-array.\n");
> 		goto out;
>@@ -4141,14 +4144,17 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
> 			if (!agg || agg->aggregator_identifier != agg_id)
> 				continue;
> 		}
>-		if (!bond_slave_can_tx(slave))
>+		if (!bond_slave_can_tx(slave)) {
>+			all_slaves->arr[all_slaves->count++] = slave;
> 			continue;
>+		}
> 		if (skipslave == slave)
> 			continue;
> 
> 		slave_dbg(bond->dev, slave->dev, "Adding slave to tx hash array[%d]\n",
> 			  active_slaves->count);
> 
>+		all_slaves->arr[all_slaves->count++] = slave;
> 		active_slaves->arr[active_slaves->count++] = slave;
> 	}
> 
>@@ -4156,10 +4162,18 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
> 	rcu_assign_pointer(bond->active_slaves, active_slaves);
> 	if (old_active_slaves)
> 		kfree_rcu(old_active_slaves, rcu);
>+
>+	old_all_slaves = rtnl_dereference(bond->all_slaves);
>+	rcu_assign_pointer(bond->all_slaves, all_slaves);
>+	if (old_all_slaves)
>+		kfree_rcu(old_all_slaves, rcu);
> out:
>-	if (ret != 0 && skipslave)
>+	if (ret != 0 && skipslave) {
> 		bond_skip_slave(rtnl_dereference(bond->active_slaves),
> 				skipslave);
>+		kfree(all_slaves);
>+		kfree(active_slaves);
>+	}

	I'm still going through the patch set, but noticed this right
away: the above will leak memory if !skipslave and the allocation for
active_slaves succeeds, but the allocation for all_slaves fails.
> 
> 	return ret;
> }
>@@ -4265,6 +4279,46 @@ static u16 bond_select_queue(struct net_device *dev, struct sk_buff *skb,
> 	return txq;
> }
> 
>+static struct net_device *bond_xmit_slave_get(struct net_device *master_dev,
>+					      struct sk_buff *skb,
>+					      int flags)
>+{
>+	struct bonding *bond = netdev_priv(master_dev);
>+	struct bond_up_slave *slaves;
>+	struct slave *slave;
>+
>+	switch (BOND_MODE(bond)) {
>+	case BOND_MODE_ROUNDROBIN:
>+		slave = bond_xmit_roundrobin_slave_get(bond, skb);
>+		break;
>+	case BOND_MODE_ACTIVEBACKUP:
>+		slave = bond_xmit_activebackup_slave_get(bond, skb);
>+		break;
>+	case BOND_MODE_8023AD:
>+	case BOND_MODE_XOR:
>+		if (flags & LAG_FLAGS_HASH_ALL_SLAVES)
>+			slaves = rcu_dereference(bond->all_slaves);
>+		else
>+			slaves = rcu_dereference(bond->active_slaves);
>+		slave = bond_xmit_3ad_xor_slave_get(bond, skb, slaves);
>+		break;
>+	case BOND_MODE_BROADCAST:
>+		return ERR_PTR(-EOPNOTSUPP);
>+	case BOND_MODE_ALB:
>+		slave = bond_xmit_alb_slave_get(bond, skb);
>+		break;
>+	case BOND_MODE_TLB:
>+		slave = bond_xmit_tlb_slave_get(bond, skb);
>+		break;
>+	default:
>+		return NULL;

	I would argue this should (a) return an error (not NULL), and,
(b) ideally issue a netdev_err for this impossible situation, similar to
the other switch statements in bonding.

	-J
	
>+	}
>+
>+	if (slave)
>+		return slave->dev;
>+	return NULL;
>+}
>+
> static netdev_tx_t __bond_start_xmit(struct sk_buff *skb, struct net_device *dev)
> {
> 	struct bonding *bond = netdev_priv(dev);
>@@ -4387,6 +4441,7 @@ static const struct net_device_ops bond_netdev_ops = {
> 	.ndo_del_slave		= bond_release,
> 	.ndo_fix_features	= bond_fix_features,
> 	.ndo_features_check	= passthru_features_check,
>+	.ndo_xmit_slave_get	= bond_xmit_slave_get,
> };
> 
> static const struct device_type bond_type = {
>diff --git a/include/net/bonding.h b/include/net/bonding.h
>index b77daffc1b52..6dd970eb9d3f 100644
>--- a/include/net/bonding.h
>+++ b/include/net/bonding.h
>@@ -201,6 +201,7 @@ struct bonding {
> 	struct   slave __rcu *current_arp_slave;
> 	struct   slave __rcu *primary_slave;
> 	struct   bond_up_slave __rcu *active_slaves; /* Array of usable slaves */
>+	struct   bond_up_slave __rcu *all_slaves; /* Array of all slaves */
> 	bool     force_primary;
> 	s32      slave_cnt; /* never change this value outside the attach/detach wrappers */
> 	int     (*recv_probe)(const struct sk_buff *, struct bonding *,
>-- 
>2.17.2
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
