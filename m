Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67AE23B4901
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 20:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbhFYS4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 14:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbhFYS4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 14:56:05 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019CCC061787
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 11:53:42 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id bg14so16571380ejb.9
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 11:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1sH4wASBzBuOPj47O9V+fShN/nyjiN4InD9nFRgHojQ=;
        b=Zzage8gAy9KB8KoPKVtHbPBw5CQzVMqtaDYtCsRlcjvbzIPWkkgCqh8hncQmYaSWsE
         CYBo1WMq5wU/ZTx6NjtJYpUJLnibp09lk2l/BB8Ge3lvhpR45/20KQBo6EKtS1YZZ3B5
         Yy+uzQm7/4FFSrTXYdDyo597skaP4iS/JRmSpMHej7Zkp02Go1ApDGGGp4U+wRol3MF+
         m+FlFd1FbnJlP/DCMvJWaGesqba6IERZeqyfs9xfGDDTxpnJfE02Ma94ItOqI0bqeydE
         MM94Bs3FnMVgAUKpiQdjjuung9L7YnFC/lbbhcN4h//1KxQplcmznAvsQvtionmfC/bf
         rkGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1sH4wASBzBuOPj47O9V+fShN/nyjiN4InD9nFRgHojQ=;
        b=PhGYrcswzwYop1TzeNfAx7BOaDi4vmSCjZE9ccFjn6cx6zd8tcG5aofRhlyQlDI359
         4Hs3A9HUEwr8Yfm+UC7dLqLmZyrcXJ0145zsv5QZ4vU2tH0FYfOtqj+U6Ms/qyCexW1n
         xJjPvr2jlTcVuoYAjRlJ2FWr32ZrSkF7y3JzwsMW6B1/RClLMd3G6NYx5G2DQd/PlP2F
         sGchOaaZlBlKMjQJbVT5gLG47Qw8L9iDf3LSJbQTEuXu6QgVkYHAbPS5raK07epllhTA
         cPyMF5EP8Aqb5rX+kUJr0W1duieA+liS1WO9xdpyrEjgSnDRDLKbc7RLUeOZ+AdRzwdK
         UxpQ==
X-Gm-Message-State: AOAM531svvDIPr8curxV3sad5DUkwfAh2nHvnyFxynKaUZ+d0QHWkCvS
        1nxSYX1pnM2pZH1w3sAgy5c=
X-Google-Smtp-Source: ABdhPJzpdJRcTApH5zv+0BXH1el2bJ0ftKQfqdC+No+/xUP2Yd4DbASd583vvJLUJC+yUeKO8Y2cIg==
X-Received: by 2002:a17:906:8144:: with SMTP id z4mr12600070ejw.244.1624647221409;
        Fri, 25 Jun 2021 11:53:41 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id w2sm3094954ejn.118.2021.06.25.11.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 11:53:41 -0700 (PDT)
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
Subject: [PATCH net-next 5/7] net: bridge: constify variables in the replay helpers
Date:   Fri, 25 Jun 2021 21:53:19 +0300
Message-Id: <20210625185321.626325-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210625185321.626325-1-olteanv@gmail.com>
References: <20210625185321.626325-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Some of the arguments and local variables for the newly added switchdev
replay helpers can be const, so let's make them so.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/if_bridge.h | 16 ++++++++--------
 net/bridge/br_fdb.c       |  6 +++---
 net/bridge/br_mdb.c       |  8 ++++----
 net/bridge/br_stp.c       |  4 ++--
 4 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index c7042b2f6a91..6b54da2c65ba 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -104,8 +104,8 @@ static inline bool br_multicast_router(const struct net_device *dev)
 {
 	return false;
 }
-static inline int br_mdb_replay(struct net_device *br_dev,
-				struct net_device *dev, const void *ctx,
+static inline int br_mdb_replay(const struct net_device *br_dev,
+				const struct net_device *dev, const void *ctx,
 				struct notifier_block *nb,
 				struct netlink_ext_ack *extack)
 {
@@ -166,9 +166,9 @@ struct net_device *br_fdb_find_port(const struct net_device *br_dev,
 void br_fdb_clear_offload(const struct net_device *dev, u16 vid);
 bool br_port_flag_is_set(const struct net_device *dev, unsigned long flag);
 u8 br_port_get_stp_state(const struct net_device *dev);
-clock_t br_get_ageing_time(struct net_device *br_dev);
-int br_fdb_replay(struct net_device *br_dev, struct net_device *dev,
-		  void *ctx, struct notifier_block *nb);
+clock_t br_get_ageing_time(const struct net_device *br_dev);
+int br_fdb_replay(const struct net_device *br_dev, const struct net_device *dev,
+		  const void *ctx, struct notifier_block *nb);
 #else
 static inline struct net_device *
 br_fdb_find_port(const struct net_device *br_dev,
@@ -193,13 +193,13 @@ static inline u8 br_port_get_stp_state(const struct net_device *dev)
 	return BR_STATE_DISABLED;
 }
 
-static inline clock_t br_get_ageing_time(struct net_device *br_dev)
+static inline clock_t br_get_ageing_time(const struct net_device *br_dev)
 {
 	return 0;
 }
 
-static inline int br_fdb_replay(struct net_device *br_dev,
-				struct net_device *dev, const void *ctx,
+static inline int br_fdb_replay(const struct net_device *br_dev,
+				const struct net_device *dev, const void *ctx,
 				struct notifier_block *nb)
 {
 	return -EOPNOTSUPP;
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 9d164a518e38..2e777c8b0921 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -727,7 +727,7 @@ static inline size_t fdb_nlmsg_size(void)
 }
 
 static int br_fdb_replay_one(struct notifier_block *nb,
-			     struct net_bridge_fdb_entry *fdb,
+			     const struct net_bridge_fdb_entry *fdb,
 			     struct net_device *dev, const void *ctx)
 {
 	struct switchdev_notifier_fdb_info item;
@@ -745,7 +745,7 @@ static int br_fdb_replay_one(struct notifier_block *nb,
 	return notifier_to_errno(err);
 }
 
-int br_fdb_replay(struct net_device *br_dev, struct net_device *dev,
+int br_fdb_replay(const struct net_device *br_dev, const struct net_device *dev,
 		  const void *ctx, struct notifier_block *nb)
 {
 	struct net_bridge_fdb_entry *fdb;
@@ -760,7 +760,7 @@ int br_fdb_replay(struct net_device *br_dev, struct net_device *dev,
 	rcu_read_lock();
 
 	hlist_for_each_entry_rcu(fdb, &br->fdb_list, fdb_node) {
-		struct net_bridge_port *dst = READ_ONCE(fdb->dst);
+		const struct net_bridge_port *dst = READ_ONCE(fdb->dst);
 		struct net_device *dst_dev;
 
 		dst_dev = dst ? dst->dev : br->dev;
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 8bc6afca5e8c..cebdbff17b54 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -567,7 +567,7 @@ static void br_switchdev_mdb_populate(struct switchdev_obj_port_mdb *mdb,
 }
 
 static int br_mdb_replay_one(struct notifier_block *nb, struct net_device *dev,
-			     struct switchdev_obj_port_mdb *mdb,
+			     const struct switchdev_obj_port_mdb *mdb,
 			     const void *ctx, struct netlink_ext_ack *extack)
 {
 	struct switchdev_notifier_port_obj_info obj_info = {
@@ -607,7 +607,7 @@ int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
 		  const void *ctx, struct notifier_block *nb,
 		  struct netlink_ext_ack *extack)
 {
-	struct net_bridge_mdb_entry *mp;
+	const struct net_bridge_mdb_entry *mp;
 	struct switchdev_obj *obj, *tmp;
 	struct net_bridge *br;
 	LIST_HEAD(mdb_list);
@@ -634,8 +634,8 @@ int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
 	rcu_read_lock();
 
 	hlist_for_each_entry_rcu(mp, &br->mdb_list, mdb_node) {
-		struct net_bridge_port_group __rcu **pp;
-		struct net_bridge_port_group *p;
+		struct net_bridge_port_group __rcu * const *pp;
+		const struct net_bridge_port_group *p;
 
 		if (mp->host_joined) {
 			err = br_mdb_queue_one(&mdb_list,
diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
index 3dafb6143cff..1d80f34a139c 100644
--- a/net/bridge/br_stp.c
+++ b/net/bridge/br_stp.c
@@ -639,9 +639,9 @@ int br_set_ageing_time(struct net_bridge *br, clock_t ageing_time)
 	return 0;
 }
 
-clock_t br_get_ageing_time(struct net_device *br_dev)
+clock_t br_get_ageing_time(const struct net_device *br_dev)
 {
-	struct net_bridge *br;
+	const struct net_bridge *br;
 
 	if (!netif_is_bridge_master(br_dev))
 		return 0;
-- 
2.25.1

