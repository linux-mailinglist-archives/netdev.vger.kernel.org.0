Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C79374172
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235228AbhEEQiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:38:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234939AbhEEQgK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:36:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9FD56143F;
        Wed,  5 May 2021 16:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232388;
        bh=sYQnTL6GCFz0oLjAuXPZLL+u10MJ9CI1uhBeuN9bM2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O1ArtVXy/rgrTV4TuCJ5vL6u6NaLpoNDVk7hl4nb6tWxw+SSQyW5HRQEPbZtvBSYy
         lsn09bf/RJRPH6fL4BbD88kOFDrdNtsak4oGQRBO7SgRjuoy7MJ+huXaJZ5eLhYGd0
         jAFa9u7gfhxzQgeLTwMGpAxK5k66dZyr+B26wLcgpmS3ZweMaShKuLeUool+QGtKhg
         jnDCFAxLj1BPFVFdpysLqNUL5p/l+U6fQVKpeyrWF97UeXXWWnqwb6P8+HluSmtNwG
         TRDivhHwcvViz9kLm1b6KbrSAr8dlUoKqqcb+a/P2xUUosaueCKYM3s9DpfaV0CY25
         pSwIFUieK9Ixw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 074/116] net: bridge: propagate error code and extack from br_mc_disabled_update
Date:   Wed,  5 May 2021 12:30:42 -0400
Message-Id: <20210505163125.3460440-74-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit ae1ea84b33dab45c7b6c1754231ebda5959b504c ]

Some Ethernet switches might only be able to support disabling multicast
snooping globally, which is an issue for example when several bridges
span the same physical device and request contradictory settings.

Propagate the return value of br_mc_disabled_update() such that this
limitation is transmitted correctly to user-space.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_multicast.c | 28 +++++++++++++++++++++-------
 net/bridge/br_netlink.c   |  4 +++-
 net/bridge/br_private.h   |  3 ++-
 net/bridge/br_sysfs_br.c  |  8 +-------
 4 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 9d265447d654..4daa95c913d0 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1593,7 +1593,8 @@ static void br_multicast_port_group_rexmit(struct timer_list *t)
 	spin_unlock(&br->multicast_lock);
 }
 
-static void br_mc_disabled_update(struct net_device *dev, bool value)
+static int br_mc_disabled_update(struct net_device *dev, bool value,
+				 struct netlink_ext_ack *extack)
 {
 	struct switchdev_attr attr = {
 		.orig_dev = dev,
@@ -1602,11 +1603,13 @@ static void br_mc_disabled_update(struct net_device *dev, bool value)
 		.u.mc_disabled = !value,
 	};
 
-	switchdev_port_attr_set(dev, &attr, NULL);
+	return switchdev_port_attr_set(dev, &attr, extack);
 }
 
 int br_multicast_add_port(struct net_bridge_port *port)
 {
+	int err;
+
 	port->multicast_router = MDB_RTR_TYPE_TEMP_QUERY;
 	port->multicast_eht_hosts_limit = BR_MCAST_DEFAULT_EHT_HOSTS_LIMIT;
 
@@ -1618,8 +1621,12 @@ int br_multicast_add_port(struct net_bridge_port *port)
 	timer_setup(&port->ip6_own_query.timer,
 		    br_ip6_multicast_port_query_expired, 0);
 #endif
-	br_mc_disabled_update(port->dev,
-			      br_opt_get(port->br, BROPT_MULTICAST_ENABLED));
+	err = br_mc_disabled_update(port->dev,
+				    br_opt_get(port->br,
+					       BROPT_MULTICAST_ENABLED),
+				    NULL);
+	if (err)
+		return err;
 
 	port->mcast_stats = netdev_alloc_pcpu_stats(struct bridge_mcast_stats);
 	if (!port->mcast_stats)
@@ -3560,16 +3567,23 @@ static void br_multicast_start_querier(struct net_bridge *br,
 	rcu_read_unlock();
 }
 
-int br_multicast_toggle(struct net_bridge *br, unsigned long val)
+int br_multicast_toggle(struct net_bridge *br, unsigned long val,
+			struct netlink_ext_ack *extack)
 {
 	struct net_bridge_port *port;
 	bool change_snoopers = false;
+	int err = 0;
 
 	spin_lock_bh(&br->multicast_lock);
 	if (!!br_opt_get(br, BROPT_MULTICAST_ENABLED) == !!val)
 		goto unlock;
 
-	br_mc_disabled_update(br->dev, val);
+	err = br_mc_disabled_update(br->dev, val, extack);
+	if (err == -EOPNOTSUPP)
+		err = 0;
+	if (err)
+		goto unlock;
+
 	br_opt_toggle(br, BROPT_MULTICAST_ENABLED, !!val);
 	if (!br_opt_get(br, BROPT_MULTICAST_ENABLED)) {
 		change_snoopers = true;
@@ -3607,7 +3621,7 @@ int br_multicast_toggle(struct net_bridge *br, unsigned long val)
 			br_multicast_leave_snoopers(br);
 	}
 
-	return 0;
+	return err;
 }
 
 bool br_multicast_enabled(const struct net_device *dev)
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index f2b1343f8332..0456593aceec 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1293,7 +1293,9 @@ static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
 	if (data[IFLA_BR_MCAST_SNOOPING]) {
 		u8 mcast_snooping = nla_get_u8(data[IFLA_BR_MCAST_SNOOPING]);
 
-		br_multicast_toggle(br, mcast_snooping);
+		err = br_multicast_toggle(br, mcast_snooping, extack);
+		if (err)
+			return err;
 	}
 
 	if (data[IFLA_BR_MCAST_QUERY_USE_IFADDR]) {
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index d7d167e10b70..af3430c2d6ea 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -810,7 +810,8 @@ void br_multicast_flood(struct net_bridge_mdb_entry *mdst,
 			struct sk_buff *skb, bool local_rcv, bool local_orig);
 int br_multicast_set_router(struct net_bridge *br, unsigned long val);
 int br_multicast_set_port_router(struct net_bridge_port *p, unsigned long val);
-int br_multicast_toggle(struct net_bridge *br, unsigned long val);
+int br_multicast_toggle(struct net_bridge *br, unsigned long val,
+			struct netlink_ext_ack *extack);
 int br_multicast_set_querier(struct net_bridge *br, unsigned long val);
 int br_multicast_set_hash_max(struct net_bridge *br, unsigned long val);
 int br_multicast_set_igmp_version(struct net_bridge *br, unsigned long val);
diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
index 072e29840082..381467b691d5 100644
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -409,17 +409,11 @@ static ssize_t multicast_snooping_show(struct device *d,
 	return sprintf(buf, "%d\n", br_opt_get(br, BROPT_MULTICAST_ENABLED));
 }
 
-static int toggle_multicast(struct net_bridge *br, unsigned long val,
-			    struct netlink_ext_ack *extack)
-{
-	return br_multicast_toggle(br, val);
-}
-
 static ssize_t multicast_snooping_store(struct device *d,
 					struct device_attribute *attr,
 					const char *buf, size_t len)
 {
-	return store_bridge_parm(d, buf, len, toggle_multicast);
+	return store_bridge_parm(d, buf, len, br_multicast_toggle);
 }
 static DEVICE_ATTR_RW(multicast_snooping);
 
-- 
2.30.2

