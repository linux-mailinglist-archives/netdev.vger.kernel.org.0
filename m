Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B06AA2EF5DB
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 17:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbhAHQdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 11:33:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728159AbhAHQdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 11:33:42 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C2CC0612A9
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 08:32:43 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id r5so11716108eda.12
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 08:32:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EVQ47sUTr3Nf37oLO+DwJ+2X4bic3yriEBwcATozdCo=;
        b=cEDVH074ycomsGj2MdosFFUR6Ux7e8rwj534+3gAUqOmkEHR03ZqCehyzmADVApbYO
         u0tSpnT6Ml2fj+g0tMwWe6UA15v39nuf2X1M76pSJWqkayIp056XIVIHrwRBNeqnYpA6
         uxv+c4dlPpnBzzfRR0DQUlnOuLr+4oVWcU7ynLtcioX55Q9uj+i1VlhRFBTZTMP0dYhn
         eOatAMZSJCf9uY8fGKqUHTWs3mRuqgOpOg6ncTZUjbVVQYD1AsPnnTH9ow4OD1b3DrCO
         YfDKNwx9Y0OjzoJAuJRnUDbbBVHOkHtTvitqDfRR8Vdwc/H80ncsiQc1MJs3ZCo+B0UT
         0r4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EVQ47sUTr3Nf37oLO+DwJ+2X4bic3yriEBwcATozdCo=;
        b=Da6DX3THx1pu34Eh8mOps7S1ecE684MOKfM78f8nLeYfD2NYMF9XDN6nxpmTJHxxl5
         NypJdEO7jipkRge96WQWUn3HEbe5Bs06A/swb3BDlElSEHei9jI1lEEAGFQxWogEu3L1
         FPJanaII71GqO8moWyad/6PYZSWzuks6nIzqK9GJn0Z0wmyiXhAw7d9yUbW2je4G1ElE
         ALdHYWeC4e3bUFglj/7acPLluZQ4zaRTiL6nZFq8dNIQwkSDiZs8ersBBJ65wcoUfCrd
         VOOxPNJg7aD2XY+3dho1FKW0Gv+esA8DZlbPlDSMIRp0vuamdd/G3i191HV088+Etyhr
         kOIA==
X-Gm-Message-State: AOAM531NY4zBd9+BaDSZVGFZ6u7t3zArEDdwdnQWP0fJhShdVjltaajZ
        SUgHpEWGDWWEQFEjztzB2Oo=
X-Google-Smtp-Source: ABdhPJz9YEIrG7ShpfNCnbi2wZcAfx32RoCHDMtT5f157PVAjeP3kCJMkSa43IUGJH+4ziIjr9mVHw==
X-Received: by 2002:a05:6402:17a3:: with SMTP id j3mr5741321edy.333.1610123562131;
        Fri, 08 Jan 2021 08:32:42 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id x6sm3957737edl.67.2021.01.08.08.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 08:32:41 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH v5 net-next 15/16] net: bonding: ensure .ndo_get_stats64 can sleep
Date:   Fri,  8 Jan 2021 18:31:58 +0200
Message-Id: <20210108163159.358043-16-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108163159.358043-1-olteanv@gmail.com>
References: <20210108163159.358043-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There is an effort to convert .ndo_get_stats64 to sleepable context, and
for that to work, we need to prevent callers of dev_get_stats from using
atomic locking.

The bonding driver retrieves its statistics recursively from its lower
interfaces, with additional care to only count packets sent/received
while those lowers were actually enslaved to the bond - see commit
5f0c5f73e5ef ("bonding: make global bonding stats more reliable").

Since commit 87163ef9cda7 ("bonding: remove last users of bond->lock and
bond->lock itself"), the bonding driver uses the following protection
for its array of slaves: RCU for readers and rtnl_mutex for updaters.
This is not great because there is another movement [ somehow
simultaneous with the one to make .ndo_get_stats64 sleepable ] to reduce
driver usage of rtnl_mutex. This makes sense, because the rtnl_mutex has
become a very contended resource.

The aforementioned commit removed an interesting comment:

	/* [...] we can't hold bond->lock [...] because we'll
	 * deadlock. The only solution is to rely on the fact
	 * that we're under rtnl_lock here, and the slaves
	 * list won't change. This doesn't solve the problem
	 * of setting the slave's MTU while it is
	 * transmitting, but the assumption is that the base
	 * driver can handle that.
	 *
	 * TODO: figure out a way to safely iterate the slaves
	 * list, but without holding a lock around the actual
	 * call to the base driver.
	 */

The above summarizes pretty well the challenges we have with nested
bonding interfaces (bond over bond over bond over...), which need to be
addressed by a better locking scheme that also not relies on the bloated
rtnl_mutex for the update side of the slaves array. That issue is not
addressed here, but there is a way around it.

To solve the nesting problem, the simple way is to not hold any locks
when recursing into the slave netdev operation. We can "cheat" and use
dev_hold to take a reference on the slave net_device, which is enough to
ensure that netdev_wait_allrefs() waits until we finish, and the kernel
won't fault.

However, the slave structure might no longer be valid, just its
associated net_device. So we need to do some more work to ensure that
the slave exists after we took the statistics, and if it still does,
reapply the logic from Andy's commit 5f0c5f73e5ef.

Tested using the following two scripts running in parallel:

	#!/bin/bash

	while :; do
		ip link del bond0
		ip link del bond1
		ip link add bond0 type bond mode 802.3ad
		ip link add bond1 type bond mode 802.3ad
		ip link set sw0p1 down && ip link set sw0p1 master bond0 && ip link set sw0p1 up
		ip link set sw0p2 down && ip link set sw0p2 master bond0 && ip link set sw0p2 up
		ip link set sw0p3 down && ip link set sw0p3 master bond0 && ip link set sw0p3 up
		ip link set bond0 down && ip link set bond0 master bond1 && ip link set bond0 up
		ip link set sw1p1 down && ip link set sw1p1 master bond1 && ip link set sw1p1 up
		ip link set bond1 up
		ip -s -s link show
		cat /sys/class/net/bond1/statistics/*
	done

	#!/bin/bash

	while :; do
		echo spi2.0 > /sys/bus/spi/drivers/sja1105/unbind
		echo spi2.0 > /sys/bus/spi/drivers/sja1105/bind
		sleep 30
	done

where the sja1105 driver was explicitly modified for the purpose of this
test to have a msleep(500) in its .ndo_get_stats64 method, to catch some
more potential races.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v5:
- Use rcu_read_lock() and do not change the locking architecture of
  the driver.
- Gave some details on my testing procedure.

Changes in v4:
Now there is code to propagate errors.

Changes in v3:
- Added kfree(dev_stats);
- Removed the now useless stats_lock (bond->bond_stats and
  slave->slave_stats are now protected by bond->slaves_lock)

Changes in v2:
Switched to the new scheme of holding just a refcnt to the slave
interfaces while recursing with dev_get_stats.

 drivers/net/bonding/bond_main.c | 113 +++++++++++++++-----------------
 include/net/bonding.h           |  54 +++++++++++++++
 2 files changed, 108 insertions(+), 59 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 2352ef64486b..77c3a40adbf4 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3705,80 +3705,75 @@ static void bond_fold_stats(struct rtnl_link_stats64 *_res,
 	}
 }
 
-#ifdef CONFIG_LOCKDEP
-static int bond_get_lowest_level_rcu(struct net_device *dev)
-{
-	struct net_device *ldev, *next, *now, *dev_stack[MAX_NEST_DEV + 1];
-	struct list_head *niter, *iter, *iter_stack[MAX_NEST_DEV + 1];
-	int cur = 0, max = 0;
-
-	now = dev;
-	iter = &dev->adj_list.lower;
-
-	while (1) {
-		next = NULL;
-		while (1) {
-			ldev = netdev_next_lower_dev_rcu(now, &iter);
-			if (!ldev)
-				break;
-
-			next = ldev;
-			niter = &ldev->adj_list.lower;
-			dev_stack[cur] = now;
-			iter_stack[cur++] = iter;
-			if (max <= cur)
-				max = cur;
-			break;
-		}
-
-		if (!next) {
-			if (!cur)
-				return max;
-			next = dev_stack[--cur];
-			niter = iter_stack[cur];
-		}
-
-		now = next;
-		iter = niter;
-	}
-
-	return max;
-}
-#endif
-
 static int bond_get_stats(struct net_device *bond_dev,
 			  struct rtnl_link_stats64 *stats)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
-	struct rtnl_link_stats64 temp;
-	struct list_head *iter;
-	struct slave *slave;
-	int nest_level = 0;
-	int res = 0;
+	struct rtnl_link_stats64 *dev_stats;
+	struct bonding_slave_dev *s;
+	struct list_head slaves;
+	int res, num_slaves;
+	int i = 0;
 
-	rcu_read_lock();
-#ifdef CONFIG_LOCKDEP
-	nest_level = bond_get_lowest_level_rcu(bond_dev);
-#endif
+	res = bond_get_slaves(bond, &slaves, &num_slaves);
+	if (res)
+		return res;
 
-	spin_lock_nested(&bond->stats_lock, nest_level);
-	memcpy(stats, &bond->bond_stats, sizeof(*stats));
+	dev_stats = kcalloc(num_slaves, sizeof(*dev_stats), GFP_KERNEL);
+	if (!dev_stats) {
+		bond_put_slaves(&slaves);
+		return -ENOMEM;
+	}
 
-	bond_for_each_slave_rcu(bond, slave, iter) {
-		res = dev_get_stats(slave->dev, &temp);
+	/* Recurse with no locks taken */
+	list_for_each_entry(s, &slaves, list) {
+		res = dev_get_stats(s->ndev, &dev_stats[i]);
 		if (res)
 			goto out;
+		i++;
+	}
+
+	spin_lock(&bond->stats_lock);
+
+	memcpy(stats, &bond->bond_stats, sizeof(*stats));
+
+	/* Because we released the RCU lock in bond_get_slaves, the new slave
+	 * array might be different from the original one, so we need to take
+	 * it again and only update the stats of the slaves that still exist.
+	 */
+	rcu_read_lock();
+
+	i = 0;
+
+	list_for_each_entry(s, &slaves, list) {
+		struct list_head *iter;
+		struct slave *slave;
 
-		bond_fold_stats(stats, &temp, &slave->slave_stats);
+		bond_for_each_slave_rcu(bond, slave, iter) {
+			if (slave->dev != s->ndev)
+				continue;
 
-		/* save off the slave stats for the next run */
-		memcpy(&slave->slave_stats, &temp, sizeof(temp));
+			bond_fold_stats(stats, &dev_stats[i],
+					&slave->slave_stats);
+
+			/* save off the slave stats for the next run */
+			memcpy(&slave->slave_stats, &dev_stats[i],
+			       sizeof(dev_stats[i]));
+			break;
+		}
+
+		i++;
 	}
 
+	rcu_read_unlock();
+
 	memcpy(&bond->bond_stats, stats, sizeof(*stats));
-out:
+
 	spin_unlock(&bond->stats_lock);
-	rcu_read_unlock();
+
+out:
+	kfree(dev_stats);
+	bond_put_slaves(&slaves);
 
 	return res;
 }
diff --git a/include/net/bonding.h b/include/net/bonding.h
index adc3da776970..149d445f935f 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -449,6 +449,60 @@ static inline void bond_hw_addr_copy(u8 *dst, const u8 *src, unsigned int len)
 	memcpy(dst, src, len);
 }
 
+/* Helpers for reference counting the struct net_device behind the bond slaves.
+ * These can be used to propagate the net_device_ops from the bond to the
+ * slaves while not holding rcu_read_lock() or the rtnl_mutex.
+ */
+struct bonding_slave_dev {
+	struct net_device *ndev;
+	struct list_head list;
+};
+
+static inline void bond_put_slaves(struct list_head *slaves)
+{
+	struct bonding_slave_dev *s, *tmp;
+
+	list_for_each_entry_safe(s, tmp, slaves, list) {
+		dev_put(s->ndev);
+		list_del(&s->list);
+		kfree(s);
+	}
+}
+
+static inline int bond_get_slaves(struct bonding *bond,
+				  struct list_head *slaves,
+				  int *num_slaves)
+{
+	struct list_head *iter;
+	struct slave *slave;
+	int err = 0;
+
+	INIT_LIST_HEAD(slaves);
+	*num_slaves = 0;
+
+	rcu_read_lock();
+
+	bond_for_each_slave_rcu(bond, slave, iter) {
+		struct bonding_slave_dev *s;
+
+		s = kzalloc(sizeof(*s), GFP_ATOMIC);
+		if (!s) {
+			rcu_read_unlock();
+			bond_put_slaves(slaves);
+			break;
+		}
+
+		s->ndev = slave->dev;
+		dev_hold(s->ndev);
+		list_add_tail(&s->list, slaves);
+		(*num_slaves)++;
+	}
+
+	rcu_read_unlock();
+
+	return err;
+}
+
 #define BOND_PRI_RESELECT_ALWAYS	0
 #define BOND_PRI_RESELECT_BETTER	1
 #define BOND_PRI_RESELECT_FAILURE	2
-- 
2.25.1

