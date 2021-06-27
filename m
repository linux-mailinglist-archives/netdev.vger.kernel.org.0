Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947B83B5337
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 13:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhF0L5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 07:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbhF0L5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 07:57:11 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D62BC061574
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 04:54:46 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id q14so20889641eds.5
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 04:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PB4XRofcGmet1mIWXZCAxZT7ibz4Rwr8KcwBqckbHN0=;
        b=GpPhFpmqq7+zQc042a3OvpnzpVmmujDf3whREQ3elIlJ1SeLqR49azAXwiU7rB83gt
         PgMR+jlSnChKz4aqedUm2y1ROIJh2Hjl+nL9vORzyZzGWmYWuud+0UUEtUa06Gtf/hKF
         4hVVjGaQD8i3KAs0nyLEScECHP9Q9LY9A8EbJns/zVClKuZIE6Kmkyo9XELQyisyIbkd
         knsq4xkFMW3dLcw3Ww5J7LKI2rZehgSxkUFcwSQTB37l2SRiqvs9XUpV3Q5syJJF0WiR
         6TTXRPGkH5P62aGamXnzNxu+m7wg9Yj9UBnMffLPSzKjOyxg0kkKa6vCTRaGKNGo4DUF
         kfSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PB4XRofcGmet1mIWXZCAxZT7ibz4Rwr8KcwBqckbHN0=;
        b=WMmxDXv2j4TG1gcCHYEa5u5QFf07uHZZoUtUhdOaljTxoeJbvsaF0RbbXwy5R7vzAx
         mVeSdWG3YVaWpGIMYn9qEvb6iVT4rCk3BcqicVb1o3vMpqXhkzzywYvCVdbHFSTWEoxV
         df7kPyW0W+MAt8wSCYLRqQGJQe1tAys0mapD4we+aGK/wVgCpeGodvei6YoXlWZ5EFTm
         kT9oTQ95igWiLBQpeHYweeyxOHGixNBP8iWULC8BC7qSRwUohSORdBocfPzRL3MApdbz
         PUP9AZ1BN7wZPp7Zt3nq+NZOl04XGEy3mBYzoRWUVsgP+cRP6zIiUOF5mGxfqsSFabWu
         HeGA==
X-Gm-Message-State: AOAM533b2+ZbhhYPAmAxd0QaZTfn7ck8pe41swVvmizEwj6HrBUEPpXe
        xLvhD8tUUOKIrWxEw6jdfmE=
X-Google-Smtp-Source: ABdhPJyuO34gl0H1oggpiTb9mSfZY1P/r14VemgLwZll2C8Pr7Ov7Ef5+BKmQ8tnjoutr0AkEvxvLw==
X-Received: by 2002:a05:6402:524d:: with SMTP id t13mr27003040edd.303.1624794885029;
        Sun, 27 Jun 2021 04:54:45 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s4sm7683688edu.49.2021.06.27.04.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 04:54:44 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 8/8] net: dsa: replay a deletion of switchdev objects for ports leaving a bridged LAG
Date:   Sun, 27 Jun 2021 14:54:29 +0300
Message-Id: <20210627115429.1084203-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210627115429.1084203-1-olteanv@gmail.com>
References: <20210627115429.1084203-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

When a DSA switch port leaves a bonding interface that is under a
bridge, there might be dangling switchdev objects on that port left
behind, because the bridge is not aware that its lower interface (the
bond) changed state in any way.

Call the bridge replay helpers with adding=false before changing
dp->bridge_dev to NULL, because we need to simulate to
dsa_slave_port_obj_del() that these notifications were emitted by the
bridge.

We add this hook to the NETDEV_PRECHANGEUPPER event handler, because
we are calling into switchdev (and the __switchdev_handle_port_obj_del
fanout helpers expect the upper/lower adjacency lists to still be valid)
and PRECHANGEUPPER is the last moment in time when they still are.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: moved switchdev unsync to PRECHANGEUPPER

 net/dsa/dsa_priv.h |  4 ++++
 net/dsa/port.c     | 45 +++++++++++++++++++++++++++++++++++--
 net/dsa/slave.c    | 55 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 102 insertions(+), 2 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index b0811253d101..c8712942002f 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -188,12 +188,16 @@ void dsa_port_disable_rt(struct dsa_port *dp);
 void dsa_port_disable(struct dsa_port *dp);
 int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 			 struct netlink_ext_ack *extack);
+int dsa_port_pre_bridge_leave(struct dsa_port *dp, struct net_device *br,
+			      struct netlink_ext_ack *extack);
 void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br);
 int dsa_port_lag_change(struct dsa_port *dp,
 			struct netdev_lag_lower_state_info *linfo);
 int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev,
 		      struct netdev_lag_upper_info *uinfo,
 		      struct netlink_ext_ack *extack);
+int dsa_port_pre_lag_leave(struct dsa_port *dp, struct net_device *lag_dev,
+			   struct netlink_ext_ack *extack);
 void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag_dev);
 int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 			    struct netlink_ext_ack *extack);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 4e58d07ececd..46089dd2b2ec 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -212,7 +212,33 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
 	return 0;
 }
 
-static void dsa_port_switchdev_unsync(struct dsa_port *dp)
+static int dsa_port_switchdev_unsync_objs(struct dsa_port *dp,
+					  struct net_device *br,
+					  struct netlink_ext_ack *extack)
+{
+	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
+	int err;
+
+	/* Delete the switchdev objects left on this port */
+	err = br_mdb_replay(br, brport_dev, dp, false,
+			    &dsa_slave_switchdev_blocking_notifier, extack);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	err = br_fdb_replay(br, brport_dev, dp, false,
+			    &dsa_slave_switchdev_notifier);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	err = br_vlan_replay(br, brport_dev, dp, false,
+			     &dsa_slave_switchdev_blocking_notifier, extack);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	return 0;
+}
+
+static void dsa_port_switchdev_unsync_attrs(struct dsa_port *dp)
 {
 	/* Configure the port for standalone mode (no address learning,
 	 * flood everything).
@@ -278,6 +304,12 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 	return err;
 }
 
+int dsa_port_pre_bridge_leave(struct dsa_port *dp, struct net_device *br,
+			      struct netlink_ext_ack *extack)
+{
+	return dsa_port_switchdev_unsync_objs(dp, br, extack);
+}
+
 void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 {
 	struct dsa_notifier_bridge_info info = {
@@ -297,7 +329,7 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 	if (err)
 		pr_err("DSA: failed to notify DSA_NOTIFIER_BRIDGE_LEAVE\n");
 
-	dsa_port_switchdev_unsync(dp);
+	dsa_port_switchdev_unsync_attrs(dp);
 }
 
 int dsa_port_lag_change(struct dsa_port *dp,
@@ -365,6 +397,15 @@ int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag,
 	return err;
 }
 
+int dsa_port_pre_lag_leave(struct dsa_port *dp, struct net_device *lag,
+			   struct netlink_ext_ack *extack)
+{
+	if (dp->bridge_dev)
+		return dsa_port_pre_bridge_leave(dp, dp->bridge_dev, extack);
+
+	return 0;
+}
+
 void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag)
 {
 	struct dsa_notifier_lag_info info = {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 20d8466d78f2..898ed9cf756f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2077,6 +2077,26 @@ static int dsa_slave_changeupper(struct net_device *dev,
 	return err;
 }
 
+static int dsa_slave_prechangeupper(struct net_device *dev,
+				    struct netdev_notifier_changeupper_info *info)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct netlink_ext_ack *extack;
+	int err = 0;
+
+	extack = netdev_notifier_info_to_extack(&info->info);
+
+	if (netif_is_bridge_master(info->upper_dev) && !info->linking)
+		err = dsa_port_pre_bridge_leave(dp, info->upper_dev, extack);
+	else if (netif_is_lag_master(info->upper_dev) && !info->linking)
+		err = dsa_port_pre_lag_leave(dp, info->upper_dev, extack);
+	/* dsa_port_pre_hsr_leave is not yet necessary since hsr cannot be
+	 * meaningfully enslaved to a bridge yet
+	 */
+
+	return notifier_from_errno(err);
+}
+
 static int
 dsa_slave_lag_changeupper(struct net_device *dev,
 			  struct netdev_notifier_changeupper_info *info)
@@ -2103,6 +2123,35 @@ dsa_slave_lag_changeupper(struct net_device *dev,
 	return err;
 }
 
+/* Same as dsa_slave_lag_changeupper() except that it calls
+ * dsa_slave_prechangeupper()
+ */
+static int
+dsa_slave_lag_prechangeupper(struct net_device *dev,
+			     struct netdev_notifier_changeupper_info *info)
+{
+	struct net_device *lower;
+	struct list_head *iter;
+	int err = NOTIFY_DONE;
+	struct dsa_port *dp;
+
+	netdev_for_each_lower_dev(dev, lower, iter) {
+		if (!dsa_slave_dev_check(lower))
+			continue;
+
+		dp = dsa_slave_to_port(lower);
+		if (!dp->lag_dev)
+			/* Software LAG */
+			continue;
+
+		err = dsa_slave_prechangeupper(lower, info);
+		if (notifier_to_errno(err))
+			break;
+	}
+
+	return err;
+}
+
 static int
 dsa_prevent_bridging_8021q_upper(struct net_device *dev,
 				 struct netdev_notifier_changeupper_info *info)
@@ -2206,6 +2255,12 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		if (err != NOTIFY_DONE)
 			return err;
 
+		if (dsa_slave_dev_check(dev))
+			return dsa_slave_prechangeupper(dev, ptr);
+
+		if (netif_is_lag_master(dev))
+			return dsa_slave_lag_prechangeupper(dev, ptr);
+
 		break;
 	}
 	case NETDEV_CHANGEUPPER:
-- 
2.25.1

