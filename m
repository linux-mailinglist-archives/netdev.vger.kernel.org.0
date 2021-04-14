Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 972A635F777
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 17:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350340AbhDNPQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 11:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350311AbhDNPQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 11:16:38 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FB7C061574;
        Wed, 14 Apr 2021 08:16:17 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id s14so5587534pjl.5;
        Wed, 14 Apr 2021 08:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ko3bUK7S4NHBgCYpUzotMNEttB/eBU1sooQBiQa0jQI=;
        b=i+M/udkpSt1Ep0D0LRLW3uT3HFmaPRMTVVzScognXnObIwbywJmG8r/J8S4AvEXOGW
         09NZ/lZjR4ogDM86jx7TI7E6J4h9FqNKBiqw3F5Duq2SiwHtxtHLFtwgW0ACZ67WIqPY
         UcXmaIlTz0IUJlPyfZs/B1SgievLs6H8qzrQ9d96VjyYrB7HLkein+2Z97QIVnJ0R9CP
         RUYfeycrMew648tWzNag+DP2qlPnbJiFfoxPGQI70a6s4/xS6TnydbJq0LiXhGDQYqF9
         kfWGTmWNYUDUPePDMLuCLHDNz4Dbhp7ygR0xTgEH+tswb03icfrAXfFDZD1OMDqk4DtH
         4CwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ko3bUK7S4NHBgCYpUzotMNEttB/eBU1sooQBiQa0jQI=;
        b=AL6KLts7XNQiJieAIYZy4shV9P/chxblffUpbBaSN7yKE7XibhEO3+CXa92694XS4X
         4w8HUxilC0QqzCvXCYsD4Y8P6pO82AR5+Sn26qi37mHjOZBJ8LUfHKFmXnzfq9y1ZXGY
         SOD8k47tnT/KyaCi5hmR6vTDKbUT4ufa9yJHTYba8DyDrnmUCi19L7UbhRVOlgu9Cb+u
         AGfioyd2B6kPhQASQ4TgdINav8/s7/x6VxXWjWVGi+DyhwL1jx8xxWqiuV7TooUbk+nJ
         dbTvouCH5Xp5MPXcVCKWr1e+aYNr2F1ygswqXCVwxXcPAM6k9WOG1Exj2dGtATjJwq2L
         ze6g==
X-Gm-Message-State: AOAM532OYdTxFWruCOQm6aFFk/G/aqKk+RBi+Iy4p9jxCenQ83LNXs9f
        7LbQ5PNZeg5lD2R8ky9eKpU=
X-Google-Smtp-Source: ABdhPJxkllp11zWkMcJCvPXxjXLriLhBCsT9pyX9hmq2ceLKmwBdk0thXC2zrIrUztX2jmZ7hTLrAg==
X-Received: by 2002:a17:90b:30c6:: with SMTP id hi6mr4111961pjb.26.1618413376712;
        Wed, 14 Apr 2021 08:16:16 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id s40sm12241146pfw.133.2021.04.14.08.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 08:16:16 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH net-next 2/2] net: bridge: switchdev: include local flag in FDB notifications
Date:   Wed, 14 Apr 2021 18:15:40 +0300
Message-Id: <20210414151540.1808871-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210414151540.1808871-1-olteanv@gmail.com>
References: <20210414151540.1808871-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

As explained in bugfix commit 6ab4c3117aec ("net: bridge: don't notify
switchdev for local FDB addresses") as well as in this discussion:
https://lore.kernel.org/netdev/20210117193009.io3nungdwuzmo5f7@skbuf/

the switchdev notifiers for FDB entries managed to have a zero-day bug,
which was that drivers would not know what to do with local FDB entries,
because they were not told that they are local. The bug fix was to
simply not notify them of those addresses.

Let us now add the 'is_local' bit to bridge FDB entries, and make all
drivers ignore these entries by their own choice.

Co-developed-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c        | 4 ++--
 drivers/net/ethernet/marvell/prestera/prestera_switchdev.c | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c   | 5 +++--
 drivers/net/ethernet/rocker/rocker_main.c                  | 4 ++--
 drivers/net/ethernet/ti/am65-cpsw-switchdev.c              | 4 ++--
 drivers/net/ethernet/ti/cpsw_switchdev.c                   | 4 ++--
 include/net/switchdev.h                                    | 1 +
 net/bridge/br_switchdev.c                                  | 3 +--
 net/dsa/slave.c                                            | 2 +-
 9 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 80efc8116963..d7c0e11b16f7 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -1832,7 +1832,7 @@ static void dpaa2_switch_event_work(struct work_struct *work)
 
 	switch (switchdev_work->event) {
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
-		if (!fdb_info->added_by_user)
+		if (!fdb_info->added_by_user || fdb_info->is_local)
 			break;
 		if (is_unicast_ether_addr(fdb_info->addr))
 			err = dpaa2_switch_port_fdb_add_uc(netdev_priv(dev),
@@ -1847,7 +1847,7 @@ static void dpaa2_switch_event_work(struct work_struct *work)
 					 &fdb_info->info, NULL);
 		break;
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		if (!fdb_info->added_by_user)
+		if (!fdb_info->added_by_user || fdb_info->is_local)
 			break;
 		if (is_unicast_ether_addr(fdb_info->addr))
 			dpaa2_switch_port_fdb_del_uc(netdev_priv(dev), fdb_info->addr);
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
index c1f05c17557d..eeccd586e781 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -2916,7 +2916,8 @@ mlxsw_sp_switchdev_bridge_nve_fdb_event(struct mlxsw_sp_switchdev_event_work *
 		return;
 
 	if (switchdev_work->event == SWITCHDEV_FDB_ADD_TO_DEVICE &&
-	    !switchdev_work->fdb_info.added_by_user)
+	    (!switchdev_work->fdb_info.added_by_user ||
+	     switchdev_work->fdb_info.is_local))
 		return;
 
 	if (!netif_running(dev))
@@ -2971,7 +2972,7 @@ static void mlxsw_sp_switchdev_bridge_fdb_event_work(struct work_struct *work)
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
diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 8c3218177136..f1a5a9a3634d 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -209,6 +209,7 @@ struct switchdev_notifier_fdb_info {
 	const unsigned char *addr;
 	u16 vid;
 	u8 added_by_user:1,
+	   is_local:1,
 	   offloaded:1;
 };
 
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index c390f84adea2..a5e601e41cb9 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -114,13 +114,12 @@ br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
 		.addr = fdb->key.addr.addr,
 		.vid = fdb->key.vlan_id,
 		.added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags),
+		.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags),
 		.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags),
 	};
 
 	if (!fdb->dst)
 		return;
-	if (test_bit(BR_FDB_LOCAL, &fdb->flags))
-		return;
 
 	switch (type) {
 	case RTM_DELNEIGH:
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 995e0e16f295..6e348d2222a9 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2329,7 +2329,7 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 		fdb_info = ptr;
 
 		if (dsa_slave_dev_check(dev)) {
-			if (!fdb_info->added_by_user)
+			if (!fdb_info->added_by_user || fdb_info->is_local)
 				return NOTIFY_OK;
 
 			dp = dsa_slave_to_port(dev);
-- 
2.25.1

