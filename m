Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5579835FB9D
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 21:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353384AbhDNTXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 15:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353383AbhDNTXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 15:23:34 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83970C06175F
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 12:23:12 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id t23so10771979pjy.3
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 12:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RLPXF9xKfpbiqRgKyhcZfQg0rMsF6YZg+XoQ99yqW+s=;
        b=K5ix7wkUKvuO+6dtHTHcAxG2kvqSEBMgIbqGbNSUuJPBe37qLivHubSI2Jz2Is6qsA
         jT1j+qGmzf2ClgY9YQGxE+d+lzmrQpGOnceIJSkJqBcSD+yeBp/QREbb8d2yJpwIM4yp
         tEQcwT5SFBtSjuDgW9k6LRoN6LZ75pcQgtxteM4qLWyYiKQCiqIQib423OvpTaELbg0f
         dLxmHQnChCdyLSvURnTsoTsIJKt/fC+mGwxs+oaGBb87ve4AJBGAV5Uf8U0hFKi1ZVvg
         KKUm1ydCLJ5FobX9lmRSOHOO6ea4ifNGCh+8Ji0WikYzefa6PKeclWhXSIvYF1QX0Jq4
         lTZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RLPXF9xKfpbiqRgKyhcZfQg0rMsF6YZg+XoQ99yqW+s=;
        b=ZsXabB7+V1nj3n+PFFga9qFcmi4Vt/ufzAyhrWznMsdUEIPlXB+5zMhbqDEl5LCSou
         rhJcPQa3bohOC9rlZPEDuN8fNeESZEo/+0sV032r/l8xM59PK5z+eZTPOwVBz2mq9COP
         zjdVd/0VYUYgZ8qc0fdJYupsEqM0SVulrHxKqKD7iNSUeUivH4bvcZDFjZfM6+yJ9LdX
         PA3eP7kIWnyF+Z5R71OE2tkvdx6kSyAQAlUkT+86CfPZY2JC0X1dAQg3p2n0o73+eElO
         FmzBFhcRrDAEeDAJZQ8Gt8SO/zwHgUSMLG4rtGw8RkURk9+WV+AwgjVyQ75Zdz3wsCL0
         /rbQ==
X-Gm-Message-State: AOAM533YHrTa1CaBKZPFOj6Ei2ZYfgIGancqoRkuxsU5SXaSL88gJ2Zi
        qFBvX9YYVh7fuWxYzvjHcsk=
X-Google-Smtp-Source: ABdhPJyZwHFl//rRaxGZWDAjFPJGoNGFbbLGHzWi1HVNUZkUzhM1Ilfm72kX+8Xz0wU8Q4WtaF53ig==
X-Received: by 2002:a17:90a:e50d:: with SMTP id t13mr5176545pjy.160.1618428192001;
        Wed, 14 Apr 2021 12:23:12 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id k20sm193460pfa.34.2021.04.14.12.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 12:23:11 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next] net: bridge: propagate error code and extack from br_mc_disabled_update
Date:   Wed, 14 Apr 2021 22:22:57 +0300
Message-Id: <20210414192257.1954575-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

Some Ethernet switches might only be able to support disabling multicast
snooping globally, which is an issue for example when several bridges
span the same physical device and request contradictory settings.

Propagate the return value of br_mc_disabled_update() such that this
limitation is transmitted correctly to user-space.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2: Overwrite -EOPNOTSUPP with 0 so that br_multicast_toggle doesn't
leak that return value to the caller.

@Nikolay:

[root@LS1028ARDB ~/selftests/net/forwarding] # ./bridge_igmp.sh one two three four
[   45.476399] IPv6: ADDRCONF(NETDEV_CHANGE): one: link becomes ready
[   45.484079] IPv6: ADDRCONF(NETDEV_CHANGE): two: link becomes ready
[   45.559919] br0: port 1(two) entered blocking state
[   45.564965] br0: port 1(two) entered disabled state
[   45.570849] device two entered promiscuous mode
[   45.580737] br0: port 2(three) entered blocking state
[   45.585967] br0: port 2(three) entered disabled state
[   45.591850] device three entered promiscuous mode
[   45.601280] br0: port 1(two) entered blocking state
[   45.606229] br0: port 1(two) entered forwarding state
[   45.620600] br0: port 2(three) entered blocking state
[   45.625719] br0: port 2(three) entered forwarding state
[   45.631438] IPv6: ADDRCONF(NETDEV_CHANGE): four: link becomes ready
TEST: IGMPv2 report 239.10.10.10                                    [ OK ]
TEST: IGMPv2 leave 239.10.10.10                                     [ OK ]
TEST: IGMPv3 report 239.10.10.10 is_include                         [ OK ]
TEST: IGMPv3 report 239.10.10.10 include -> allow                   [ OK ]
TEST: IGMPv3 report 239.10.10.10 include -> is_include              [ OK ]
TEST: IGMPv3 report 239.10.10.10 include -> is_exclude              [ OK ]
TEST: IGMPv3 report 239.10.10.10 include -> to_exclude              [ OK ]
TEST: IGMPv3 report 239.10.10.10 exclude -> allow                   [ OK ]
TEST: IGMPv3 report 239.10.10.10 exclude -> is_include              [ OK ]
TEST: IGMPv3 report 239.10.10.10 exclude -> is_exclude              [ OK ]
TEST: IGMPv3 report 239.10.10.10 exclude -> to_exclude              [ OK ]
TEST: IGMPv3 report 239.10.10.10 include -> block                   [ OK ]
TEST: IGMPv3 report 239.10.10.10 exclude -> block                   [ OK ]
TEST: IGMPv3 group 239.10.10.10 exclude timeout                     [ OK ]
TEST: IGMPv3 S,G port entry automatic add to a *,G port             [ OK ]
[  160.556931] br0: port 2(three) entered disabled state
[  160.567926] br0: port 1(two) entered disabled state
[  160.578931] device three left promiscuous mode
[  160.584403] br0: port 2(three) entered disabled state
[  160.604206] device two left promiscuous mode
[  160.608837] br0: port 1(two) entered disabled state
RTNETLINK answers: Cannot assign requested address
[root@LS1028ARDB ~/selftests/net/forwarding] # ./bridge_mld.sh one two three four
[  168.606290] IPv6: ADDRCONF(NETDEV_CHANGE): one: link becomes ready
[  168.614313] IPv6: ADDRCONF(NETDEV_CHANGE): two: link becomes ready
[  168.653335] IPv6: ADDRCONF(NETDEV_CHANGE): four: link becomes ready
[  168.661972] IPv6: ADDRCONF(NETDEV_CHANGE): three: link becomes ready
[  168.680831] br0: port 1(two) entered blocking state
[  168.686361] br0: port 1(two) entered disabled state
[  168.692220] device two entered promiscuous mode
[  168.701535] br0: port 2(three) entered blocking state
[  168.706656] br0: port 2(three) entered disabled state
[  168.712105] device three entered promiscuous mode
[  168.722046] br0: port 2(three) entered blocking state
[  168.727150] br0: port 2(three) entered forwarding state
[  168.732484] br0: port 1(two) entered blocking state
[  168.737408] br0: port 1(two) entered forwarding state
TEST: MLDv2 report ff02::cc is_include                              [ OK ]
TEST: MLDv2 report ff02::cc include -> allow                        [ OK ]
TEST: MLDv2 report ff02::cc include -> is_include                   [ OK ]
TEST: MLDv2 report ff02::cc include -> is_exclude                   [ OK ]
TEST: MLDv2 report ff02::cc include -> to_exclude                   [ OK ]
TEST: MLDv2 report ff02::cc exclude -> allow                        [ OK ]
TEST: MLDv2 report ff02::cc exclude -> is_include                   [ OK ]
TEST: MLDv2 report ff02::cc exclude -> is_exclude                   [ OK ]
TEST: MLDv2 report ff02::cc exclude -> to_exclude                   [ OK ]
TEST: MLDv2 report ff02::cc include -> block                        [ OK ]
TEST: MLDv2 report ff02::cc exclude -> block                        [ OK ]
TEST: MLDv2 group ff02::cc exclude timeout                          [ OK ]
TEST: MLDv2 S,G port entry automatic add to a *,G port              [ OK ]
[  276.401190] br0: port 2(three) entered disabled state
[  276.414596] br0: port 1(two) entered disabled state
[  276.424809] device three left promiscuous mode
[  276.429494] br0: port 2(three) entered disabled state
[  276.444132] device two left promiscuous mode
[  276.449101] br0: port 1(two) entered disabled state

It might be helpful to enforce a check in these selftests for the
version of the bridge binary, it must be >= v5.10 due to your checking
for "source_list" in the 'bridge mdb' json output.

I tried to do this, and my bridge compiled from source says:

[root@LS1028ARDB ~/selftests/net/forwarding] # bridge -V
bridge utility, 5.11.0

but I suspect that the bridge utility shipped by most if not all
distributions just return:

$ bridge -V
bridge utility, 0.0

So I'm not sure how we can actually enforce this version check, but it
would be nonetheless useful for the selftests to auto-detect if the
bridge binary has this feature or not.

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
index 50747990188e..7ce8a77cc6b6 100644
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
2.25.1

