Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3CB12F023E
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 18:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbhAIR2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 12:28:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbhAIR2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 12:28:49 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB8AC0617BA
        for <netdev@vger.kernel.org>; Sat,  9 Jan 2021 09:27:44 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id p22so14382229edu.11
        for <netdev@vger.kernel.org>; Sat, 09 Jan 2021 09:27:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uumYfeLD/WT/2ZsjqYAQDNsvJgxI+0mz0rY4cpEgYn0=;
        b=se0sxtYp0Azmk6d3K14TUKAL/KhsIi7wf2z7UlNH2gQcz3SQjQF9kQSnpnjVp0i8iz
         WLdgIM8TbjAwnPFWkitaVKoLOJlDMugMk+hoMn5tJUzU0rtz6YAgg7VHnmLPMSRhc+eo
         MC9sasB7AV7kZspAKhc43lrFKS/eQ7m6NYDak7cixAaFcFhwkQcxt55171H+XkwsxYnV
         VuBMlujbQcq0KsosdgTSjR9ITBvIri0F/nj4/emhoZ+cG0RnJ7GzojB9yBwXeA3CLWLK
         0ZG9bQ+DUcmZARugUz6XGjfuMRjWHFxDmc4IdR5+m8BWt6JKYzgqaxr5k/TLFuLWCsMB
         eZ/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uumYfeLD/WT/2ZsjqYAQDNsvJgxI+0mz0rY4cpEgYn0=;
        b=s55+eDdPU94qS/tRQ0zty/+Yq/sRm8ct6TJYw1qa6jCS20cS3ZTZkaEwduF2DRh01L
         O5t89WsEzd1HcGH33LIE2+ZvQcvqb+Fa00ftgvsReaSp2ilsfZBu/2qMCrAXqgVrES/o
         IhXX6lErxtW/ID9rnCwcSBmBxISV3Qzb6YJKnYjyp0kg/Pcm1f4njLFKf6OXEoB+8iX5
         vpGzHkK4qSd75olIl1osmj6P6Z1Bm//ePyOIW6lAW1AjCpeHlPnAzvfmXpkMHsYBU/qs
         4r0bAHG79rqHqtNZXubmuZzmR1XcLggAbjD1y4GOdq89DvSTgPSqoCDsZyl30ud0qHzG
         D+8A==
X-Gm-Message-State: AOAM531xZOyw4zwaMpvP5wgQ9H3FfH285gYUAjJPKVENnWYfY+NLXlp4
        vtO8LxEFsGXdX9cSx6Qdbhw=
X-Google-Smtp-Source: ABdhPJyCHIcV5u0P/3TSBFgUvRl9aILufdIdFp97r21ZEtU568X9K5oc0RYp4T4uovJAJuAoYsruEA==
X-Received: by 2002:aa7:c7d8:: with SMTP id o24mr9325399eds.328.1610213263635;
        Sat, 09 Jan 2021 09:27:43 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id h16sm4776714eji.110.2021.01.09.09.27.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 09:27:43 -0800 (PST)
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
Subject: [PATCH v6 net-next 14/15] net: bonding: ensure .ndo_get_stats64 can sleep
Date:   Sat,  9 Jan 2021 19:26:23 +0200
Message-Id: <20210109172624.2028156-15-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210109172624.2028156-1-olteanv@gmail.com>
References: <20210109172624.2028156-1-olteanv@gmail.com>
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
bonding interfaces (bond over bond over bond over...) and locking for
their slaves.

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
Changes in v6:
s/break/return -ENOMEM/ in bond_get_slaves.

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
 include/net/bonding.h           |  53 +++++++++++++++
 2 files changed, 107 insertions(+), 59 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index b70ca0e41142..84d4e97007cb 100644
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
index adc3da776970..2df1f7ea9036 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -449,6 +449,59 @@ static inline void bond_hw_addr_copy(u8 *dst, const u8 *src, unsigned int len)
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
+			return -ENOMEM;
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
+	return 0;
+}
+
 #define BOND_PRI_RESELECT_ALWAYS	0
 #define BOND_PRI_RESELECT_BETTER	1
 #define BOND_PRI_RESELECT_FAILURE	2
-- 
2.25.1

