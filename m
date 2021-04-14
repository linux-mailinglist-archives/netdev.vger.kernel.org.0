Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96C5135F643
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 16:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348551AbhDNOew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 10:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232950AbhDNOew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 10:34:52 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A8DC061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 07:34:30 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id b17so14546858pgh.7
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 07:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nk2RhtjnPyqGobg+rScKvkLX6MKGs5O0vMsI8TYeqGg=;
        b=Vddt2mE9yRj3pSQwBWThSTT/KrVkBByhH4kJ8tMSXL1upIEK49LrfaHSphu8JUZFct
         11Rdvg3A6iHAK5MmGMM5R7HzpeDZmKrqzIA8DTwoSC8DTu6azv7KtdkYPbU+j5oXyTAu
         L4/EgkVcosi5lSBdn6tL8KF67/8R7zE0SA6YjsT3L9go6oBPzmSwccb9PIU7ide2rVM2
         dAoc59qc8M8pDGg/oz4sAq5uMqP6G9rRSC+X3vjfztfOXf9STvbX5KL+5HXGuy887Da6
         UD3vQHely59SPHHr52qxiT16cNWefkFumvXUGf5AdQ4W6iyzQwhCuce/ggcz4bWwgfkf
         CMSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nk2RhtjnPyqGobg+rScKvkLX6MKGs5O0vMsI8TYeqGg=;
        b=kJqVShUBTaG8E2RfGNBv4xJ3LjdZK425OxdRF56hmcLBOpyM8/yiUMjmnQ/aXvqiZI
         bUTN/7l2XFfkM6d5P8Cfg+HcJvxnRUW3uaBHZAKNZakoPcWotOZOYu93hlKKiKztGxP0
         Nu64Rr6tW9oVM7vaoMSL9CWcDYTKwaFZruwifnuddrZU22PkK1ijBvf2zNWJRw2t16Yg
         BNUcLjuWQmqQrsq4B46HOiRR7uBQKt/stOf2vb3bkYjB8fVwD3jPcdVH5fhDPb/5Ql5G
         V5M/qnpy8cYl3lNVe2T7pWVQZLKFOWvdPoOoZiW96KgvUdCuH3UbxTgUHQWpeAdE9IDX
         MFCA==
X-Gm-Message-State: AOAM5323UYRuuZ4HeAUCNFWFIxp0bgG2ypMeNrMPd95+B7VQnr4w0JBh
        eKKIJpBQu1sfX/1PuOH/LQs=
X-Google-Smtp-Source: ABdhPJzLdFOv0PXjOpnOwLbZxKRC4DDfeGL6tBE8XCg1LGN9lp3McRoGPDF9rGQH8BW8+/nGOmJXSw==
X-Received: by 2002:a05:6a00:cd2:b029:253:5b9d:4f03 with SMTP id b18-20020a056a000cd2b02902535b9d4f03mr3120538pfv.34.1618410870264;
        Wed, 14 Apr 2021 07:34:30 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id ir3sm5129397pjb.42.2021.04.14.07.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 07:34:29 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next] net: bridge: propagate error code and extack from br_mc_disabled_update
Date:   Wed, 14 Apr 2021 17:34:13 +0300
Message-Id: <20210414143413.1786981-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

Some Ethernet switches might only be able to support disabling multicast
flooding globally, which is an issue for example when several bridges
span the same physical device and request contradictory settings.

Propagate the return value of br_mc_disabled_update() such that this
limitation is transmitted correctly to user-space.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_multicast.c | 26 +++++++++++++++++++-------
 net/bridge/br_netlink.c   |  4 +++-
 net/bridge/br_private.h   |  3 ++-
 net/bridge/br_sysfs_br.c  |  8 +-------
 4 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 9d265447d654..7f861a6eb348 100644
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
@@ -3560,16 +3567,21 @@ static void br_multicast_start_querier(struct net_bridge *br,
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
+	if (err && err != -EOPNOTSUPP)
+		goto unlock;
+
 	br_opt_toggle(br, BROPT_MULTICAST_ENABLED, !!val);
 	if (!br_opt_get(br, BROPT_MULTICAST_ENABLED)) {
 		change_snoopers = true;
@@ -3607,7 +3619,7 @@ int br_multicast_toggle(struct net_bridge *br, unsigned long val)
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
index ecb91e13d777..947c724c26b2 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -812,7 +812,8 @@ void br_multicast_flood(struct net_bridge_mdb_entry *mdst,
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

