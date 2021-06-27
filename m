Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06D23B5335
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 13:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhF0L5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 07:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbhF0L5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 07:57:07 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED15C061787
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 04:54:43 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id h2so20934182edt.3
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 04:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VVDq2FnTixepeEkiZpXbh08ZtEr1upv9OXcEytupIHI=;
        b=W0QRdGsDAhUW8x+txILNiU6UQaQa+R/m+SYcJKiuufFOQDRWAIvUlTLnPcgkUwVb2d
         O36RGo58ZMx527p0CGz5jf4F7NMKsovw7W6YzTvMXIfVlKPYuoEeYY3h9jOV6CFospoX
         AMbwF5MQ0KI5KVdh0wHy0lY/eB9nk100Mb+bVyG9/qEnS/D4IYJg6F+3Mv4ABqW1Ew1I
         YLcB/mqXS90bavZm8HiHMY8MWbPQsIiFHyyhFQoiej2X2UIbH146+3nGsdCddKqTi6hl
         6VznVA+QlqOO6o4RJ9UDEIlfgK4jeNsdb4xXVijVYJRL/SHn4/pOD7vGWr3mbWvkIAWS
         ZqTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VVDq2FnTixepeEkiZpXbh08ZtEr1upv9OXcEytupIHI=;
        b=jny29KjOs02XLRqi85LW2afAyDRx694IhB/NtPN/prtdeUTopuOT+uhXl1BeZfVqzu
         n1DlGPu6uKPZGUhWZwS+ecKVHRodw2iAPzpzs46dc4fObgsQ2hYeHIduuYID8ISSmP2z
         wBjfFI4IwTjRITA8EMgKHCn+VSrDC8kDzZ9qvEV7CalYyGXcADjrRw+JZdi0/FtepoME
         asYE8ns5SlUUQKlWxRwX/m/f0DN0M1I1cdZMxNHeWTpjrylgggFNGh23va8KS+BCnjik
         jMQfrl1Smi8wS2jwvoxgh3JAMukynJ+Hslqa7r4IlEagNkTRvjY2vj2+xAyonxKiVOAR
         oQuw==
X-Gm-Message-State: AOAM530dgBGjRI5H8Me4FrTVCu/weIPC9jWIriXsyPN7u78Q/97H0wFz
        vg4ZD5gVBLB0mJcwvJ0oCAc=
X-Google-Smtp-Source: ABdhPJyvJgXR10xU2naLJp59mgrFdDUCwf3tcJfJcqaeS2M6RB76YrdJzH7CrzNr14WiPd4AP1Y5oA==
X-Received: by 2002:a05:6402:1d11:: with SMTP id dg17mr27395699edb.30.1624794881899;
        Sun, 27 Jun 2021 04:54:41 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s4sm7683688edu.49.2021.06.27.04.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 04:54:41 -0700 (PDT)
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
Subject: [PATCH v2 net-next 5/8] net: bridge: constify variables in the replay helpers
Date:   Sun, 27 Jun 2021 14:54:26 +0300
Message-Id: <20210627115429.1084203-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210627115429.1084203-1-olteanv@gmail.com>
References: <20210627115429.1084203-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Some of the arguments and local variables for the newly added switchdev
replay helpers can be const, so let's make them so.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v2: none

 include/linux/if_bridge.h | 14 +++++++-------
 net/bridge/br_fdb.c       |  6 +++---
 net/bridge/br_mdb.c       |  8 ++++----
 net/bridge/br_stp.c       |  4 ++--
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 57df761b6f4a..6b54da2c65ba 100644
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
@@ -166,8 +166,8 @@ struct net_device *br_fdb_find_port(const struct net_device *br_dev,
 void br_fdb_clear_offload(const struct net_device *dev, u16 vid);
 bool br_port_flag_is_set(const struct net_device *dev, unsigned long flag);
 u8 br_port_get_stp_state(const struct net_device *dev);
-clock_t br_get_ageing_time(struct net_device *br_dev);
-int br_fdb_replay(struct net_device *br_dev, struct net_device *dev,
+clock_t br_get_ageing_time(const struct net_device *br_dev);
+int br_fdb_replay(const struct net_device *br_dev, const struct net_device *dev,
 		  const void *ctx, struct notifier_block *nb);
 #else
 static inline struct net_device *
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

