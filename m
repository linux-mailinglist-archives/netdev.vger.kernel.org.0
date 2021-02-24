Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33C3D323B6F
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 12:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbhBXLrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 06:47:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234255AbhBXLp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 06:45:28 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C93C0617A7
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:11 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id d2so2050271edq.10
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZhQQzSKu+5RLnYgBeMfX0i3Omf38kuDGLkALtzF7r7Q=;
        b=Zz9DRj+oV0tqMAIs9xPPagw8m6szTfqRggXu9xVtFT3GasjpxS+0PFa7VgAhE4X550
         6rRdldOa3W8pce+pCt73jd0Gos8mrmfSkeqrOSveqLlJB04Wd0lk1R9dM/MpiO+cPEHx
         Pum9ZEzv8jeGYS9vUth12g9d9Xrblvul4/n5jbLUS9jGbcTsqjxRCrZpaWcu1YqWuvzU
         Rj5G03qEE7lhUpI3lQmwGG4XcsWQ2ZxwfOyhaaTupU1tjyZiSfSlR6C85FBXwVCz8S48
         n6Ey7VyJ7L3ZSvTiiF4Tu333pfpkyi+ZA7ENj+u5BcH2TRAYskDIfhW/RfbXlap85ejE
         QJiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZhQQzSKu+5RLnYgBeMfX0i3Omf38kuDGLkALtzF7r7Q=;
        b=TRUr3o2Ele8q5ydrPR5bWJvcuVPFPvM8pt1a0A/cPRSEdhT01brNDApzBYyd2uNABe
         gp/VJIOnkN7Vhih70kXNUHuCpWFRDIgz4ZFD8iyFaaxfOX0VbE467CVjr1Dg8X05MuGW
         E2p/WXFmD45w8it5e7EAmOxDdEM4k60vczYb5rdKqp0ohh1nSfLp+xtaHzpgIoBudBhE
         kozKGNsIRb97dOBjbVSFjStldEYE3c6oIcurSq3E/G64WDLQYq8pcX90gWoIKN5+y+E6
         /wnxcTHBhuAgbhhKYapNRcgBppawew4ruaBZUhIJPjnS+/qkJwmIpoKXMLCft36IKgO8
         9yDw==
X-Gm-Message-State: AOAM53222Qup1TX/4nd7B37AwfbeojT8ui+wsvOHYGhiz0HKih+FSRWu
        E2KhmkCS+vdIumuSZm2cPbjnyxIgduY=
X-Google-Smtp-Source: ABdhPJyJNq5jlf9RaxyPurSjUmWgmYK1IDT89mBLI9IMnecf6hYxtzFN4zieU1yE1OWNTmNBlDHe6w==
X-Received: by 2002:a05:6402:95d:: with SMTP id h29mr1467675edz.327.1614167049850;
        Wed, 24 Feb 2021 03:44:09 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id r5sm1203921ejx.96.2021.02.24.03.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 03:44:09 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [RFC PATCH v2 net-next 08/17] net: bridge: switchdev: include local flag in FDB notifications
Date:   Wed, 24 Feb 2021 13:43:41 +0200
Message-Id: <20210224114350.2791260-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210224114350.2791260-1-olteanv@gmail.com>
References: <20210224114350.2791260-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

As explained in the discussion on the initial version of this patch:
https://lore.kernel.org/netdev/20210117193009.io3nungdwuzmo5f7@skbuf/

the switchdev notifiers for FDB entries managed to have a zero-day bug.
The bridge would not say that this entry is local:

ip link add br0 type bridge
ip link set swp0 master br0
bridge fdb add dev swp0 00:01:02:03:04:05 master local

and the switchdev driver would be more than happy to offload it as a
normal static FDB entry. This is despite the fact that 'local' and
non-'local' entries have completely opposite directions: a local entry
is locally terminated and not forwarded, whereas a static entry is
forwarded and not locally terminated. So, for example, DSA would install
this entry on swp0 instead of installing it on the CPU port as it should.

There is an even sadder part, which is that the 'local' flag is implicit
if 'static' is not specified, meaning that this command produces the
same result of adding a 'local' entry:

bridge fdb add dev swp0 00:01:02:03:04:05 master

So this patch is a bugfix which does what should have been done from day
one: make the bridge inform switchdev that it's a local entry, and have
all drivers ignore local entries (since none of them currently has any
logic to deal with host entries).

At least we've updated the man pages for 'bridge' now, and we're pretty
explicit that the commands above were broken and should have never worked:
https://patchwork.kernel.org/project/netdevbpf/cover/20210211104502.2081443-1-olteanv@gmail.com/

But we don't do anything to even attempt to keep backwards compatibility
with the broken behavior. If we did that, it would be pretty much game
over for any attempt to really deal with host entries in switchdev drivers.

Co-developed-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_switchdev.c | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c   | 5 +++--
 drivers/net/ethernet/rocker/rocker_main.c                  | 4 ++--
 drivers/net/ethernet/ti/am65-cpsw-switchdev.c              | 4 ++--
 drivers/net/ethernet/ti/cpsw_switchdev.c                   | 4 ++--
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c                    | 4 ++--
 include/net/switchdev.h                                    | 1 +
 net/bridge/br_switchdev.c                                  | 1 +
 net/dsa/slave.c                                            | 2 +-
 9 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 49e052273f30..cb564890a3dc 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -798,7 +798,7 @@ static void prestera_fdb_event_work(struct work_struct *work)
 	switch (swdev_work->event) {
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
 		fdb_info = &swdev_work->fdb_info;
-		if (!fdb_info->added_by_user)
+		if (!fdb_info->added_by_user || fdb_info->is_local)
 			break;
 
 		err = prestera_port_fdb_set(port, fdb_info, true);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 23b7e8d6386b..9aadc29ad777 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -2865,7 +2865,8 @@ mlxsw_sp_switchdev_bridge_nve_fdb_event(struct mlxsw_sp_switchdev_event_work *
 		return;
 
 	if (switchdev_work->event == SWITCHDEV_FDB_ADD_TO_DEVICE &&
-	    !switchdev_work->fdb_info.added_by_user)
+	    (!switchdev_work->fdb_info.added_by_user ||
+	     switchdev_work->fdb_info.is_local))
 		return;
 
 	if (!netif_running(dev))
@@ -2920,7 +2921,7 @@ static void mlxsw_sp_switchdev_bridge_fdb_event_work(struct work_struct *work)
 	switch (switchdev_work->event) {
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
 		fdb_info = &switchdev_work->fdb_info;
-		if (!fdb_info->added_by_user)
+		if (!fdb_info->added_by_user || fdb_info->is_local)
 			break;
 		err = mlxsw_sp_port_fdb_set(mlxsw_sp_port, fdb_info, true);
 		if (err)
diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index 3473d296b2e2..a46633606cae 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -2736,7 +2736,7 @@ static void rocker_switchdev_event_work(struct work_struct *work)
 	switch (switchdev_work->event) {
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
 		fdb_info = &switchdev_work->fdb_info;
-		if (!fdb_info->added_by_user)
+		if (!fdb_info->added_by_user || fdb_info->is_local)
 			break;
 		err = rocker_world_port_fdb_add(rocker_port, fdb_info);
 		if (err) {
@@ -2747,7 +2747,7 @@ static void rocker_switchdev_event_work(struct work_struct *work)
 		break;
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
 		fdb_info = &switchdev_work->fdb_info;
-		if (!fdb_info->added_by_user)
+		if (!fdb_info->added_by_user || fdb_info->is_local)
 			break;
 		err = rocker_world_port_fdb_del(rocker_port, fdb_info);
 		if (err)
diff --git a/drivers/net/ethernet/ti/am65-cpsw-switchdev.c b/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
index d93ffd8a08b0..23cfb91e9c4d 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
@@ -385,7 +385,7 @@ static void am65_cpsw_switchdev_event_work(struct work_struct *work)
 			   fdb->addr, fdb->vid, fdb->added_by_user,
 			   fdb->offloaded, port_id);
 
-		if (!fdb->added_by_user)
+		if (!fdb->added_by_user || fdb->is_local)
 			break;
 		if (memcmp(port->slave.mac_addr, (u8 *)fdb->addr, ETH_ALEN) == 0)
 			port_id = HOST_PORT_NUM;
@@ -401,7 +401,7 @@ static void am65_cpsw_switchdev_event_work(struct work_struct *work)
 			   fdb->addr, fdb->vid, fdb->added_by_user,
 			   fdb->offloaded, port_id);
 
-		if (!fdb->added_by_user)
+		if (!fdb->added_by_user || fdb->is_local)
 			break;
 		if (memcmp(port->slave.mac_addr, (u8 *)fdb->addr, ETH_ALEN) == 0)
 			port_id = HOST_PORT_NUM;
diff --git a/drivers/net/ethernet/ti/cpsw_switchdev.c b/drivers/net/ethernet/ti/cpsw_switchdev.c
index a72bb570756f..05a64fb7a04f 100644
--- a/drivers/net/ethernet/ti/cpsw_switchdev.c
+++ b/drivers/net/ethernet/ti/cpsw_switchdev.c
@@ -395,7 +395,7 @@ static void cpsw_switchdev_event_work(struct work_struct *work)
 			fdb->addr, fdb->vid, fdb->added_by_user,
 			fdb->offloaded, port);
 
-		if (!fdb->added_by_user)
+		if (!fdb->added_by_user || fdb->is_local)
 			break;
 		if (memcmp(priv->mac_addr, (u8 *)fdb->addr, ETH_ALEN) == 0)
 			port = HOST_PORT_NUM;
@@ -411,7 +411,7 @@ static void cpsw_switchdev_event_work(struct work_struct *work)
 			fdb->addr, fdb->vid, fdb->added_by_user,
 			fdb->offloaded, port);
 
-		if (!fdb->added_by_user)
+		if (!fdb->added_by_user || fdb->is_local)
 			break;
 		if (memcmp(priv->mac_addr, (u8 *)fdb->addr, ETH_ALEN) == 0)
 			port = HOST_PORT_NUM;
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
index 703055e063ff..aad212b9b97b 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -1298,7 +1298,7 @@ static void dpaa2_switch_event_work(struct work_struct *work)
 
 	switch (switchdev_work->event) {
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
-		if (!fdb_info->added_by_user)
+		if (!fdb_info->added_by_user || fdb_info->is_local)
 			break;
 		if (is_unicast_ether_addr(fdb_info->addr))
 			err = dpaa2_switch_port_fdb_add_uc(netdev_priv(dev),
@@ -1313,7 +1313,7 @@ static void dpaa2_switch_event_work(struct work_struct *work)
 					 &fdb_info->info, NULL);
 		break;
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		if (!fdb_info->added_by_user)
+		if (!fdb_info->added_by_user || fdb_info->is_local)
 			break;
 		if (is_unicast_ether_addr(fdb_info->addr))
 			dpaa2_switch_port_fdb_del_uc(netdev_priv(dev), fdb_info->addr);
diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index b7fc7d0f54e2..ca7223a79135 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -208,6 +208,7 @@ struct switchdev_notifier_fdb_info {
 	const unsigned char *addr;
 	u16 vid;
 	u8 added_by_user:1,
+	   is_local:1,
 	   offloaded:1;
 };
 
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 1386677bdaf8..a5e601e41cb9 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -114,6 +114,7 @@ br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
 		.addr = fdb->key.addr.addr,
 		.vid = fdb->key.vlan_id,
 		.added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags),
+		.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags),
 		.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags),
 	};
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 65b3c1166fe7..c4db870b48e5 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2549,7 +2549,7 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 		fdb_info = ptr;
 
 		if (dsa_slave_dev_check(dev)) {
-			if (!fdb_info->added_by_user)
+			if (!fdb_info->added_by_user || fdb_info->is_local)
 				return NOTIFY_OK;
 
 			dp = dsa_slave_to_port(dev);
-- 
2.25.1

