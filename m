Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4043CCB25
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 23:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233825AbhGRVtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 17:49:39 -0400
Received: from mail-db8eur05on2056.outbound.protection.outlook.com ([40.107.20.56]:53472
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233095AbhGRVtW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Jul 2021 17:49:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WJOhmh6N9HUDE0CPUmWinZh/nQeeveqzXje9p7bS41KQOG9pUxoOzgMcm4g9U8egP+WsYUZj9HuXK4nPLoOI93IgmibDoAi5EyKOuKEhJ0b5n2dYzlcjsQINLoogYleMgtR74vLi63ePP0/glgGZCNwaejOp7Qa6QEMJzvkwYeOVZmXgQrhfjsfkTErI6P5HFUciKy865AQeFl8k6bZzUfwazBBfkb5N8MO5bmWqlxLgu5dDYvTlSqmRIGwdhdRngwavbNxcDRh5hoiCHWfbdBM6Q6MaiUnktCfnoaBBc30lAgw8Z7c4Kwc8ibvlgiCrs8UCmC0ORZesjkAEM0tBDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f8Np/QoL3ecJ78o4XP98KhOw0MhI9YX918ommTqRqUg=;
 b=bqCrSismRiGppnvIdm6EwDnEP36Tb8o1m1fn3FjfmRCZklv3r9jEfZ+7kJSb9Mzpb7ksJLDg3YaqIfyNkSHoxIC/b6cHpgdOvDlqTdx3JANOc8jX2mlTiHpJU8ao7XAwLY/H+PlxOlOwDmZNYE+tfYDq8hLdF7fd3NKXtGBPsRMB40cj3f2X3Ky0+OQ3Wwl55jQQOvHoJYbT8dh1CM1w690nc+gqrM7YtsBnQVbhpyAJISPTM9sZTSh7kdBzypoTMT1L/FWQMUu3ZicRdTAk9SoadbzwsqfAGSUiZAQR3j/iSQOcYVUT1est4j9DrrnLeJ4GZ6hFo5bO96luRB3VOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f8Np/QoL3ecJ78o4XP98KhOw0MhI9YX918ommTqRqUg=;
 b=iorcxxEQlNSURNO/BcdoK9Lq4C7QgYzqkxG7Z8CKCr6AyyiJeLDUZKtAEDC7GkndWLZNftYl5OGDI7DqJIxSiNAwcYxAFopwnuAIW4OBs44nWc7xD2t1rLS6VgBZ4/bF59eshHnFqJ74eOD3Sr+ismZK5oWK7bYsdjE5gRyeG+Y=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5502.eurprd04.prod.outlook.com (2603:10a6:803:c9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Sun, 18 Jul
 2021 21:46:19 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.032; Sun, 18 Jul 2021
 21:46:19 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH v4 net-next 11/15] net: bridge: switchdev: allow the TX data plane forwarding to be offloaded
Date:   Mon, 19 Jul 2021 00:44:30 +0300
Message-Id: <20210718214434.3938850-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
References: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0602CA0014.eurprd06.prod.outlook.com
 (2603:10a6:800:bc::24) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by VI1PR0602CA0014.eurprd06.prod.outlook.com (2603:10a6:800:bc::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Sun, 18 Jul 2021 21:46:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82170c29-5310-4c98-f3e1-08d94a3579f6
X-MS-TrafficTypeDiagnostic: VI1PR04MB5502:
X-Microsoft-Antispam-PRVS: <VI1PR04MB55024FA3502E838B164B89B6E0E09@VI1PR04MB5502.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IhgkbFaUIrzrjU4u7Gun3Ueybl8YCOxwfYx0P7vKB+mTpuRkmVaL7DA9mzuGxVAgDbxrZHW5EVRI/6LALtP3riNZZl3e0S3ljW6k04vvqPNxnMmCC96d1/E7/MmHAryb9dEWJe1QM5qrtG+4LbsB0N8v7+V5DeignpUm6B0fX60DoJ0rrKxgUpvaeLGFcXkjb5nuESShGf+W1PqQJvv5QTaSioha2JK08ZKeBUupfHHpcR3qtXWVuJLNsJUyJ6rwPb1ttZGizbkhtGOCynQYsNEVGyhJDCETZtZDOp73jdU68r+fQs0y8fxvjV6WzaXUx/UfqNvj9wSbua3HIzXJ6N59F8sd1d1Zoo2P6J5Xk3ssKB3ylMUKGIHXHBNu4qwPtT5gTJT2P0ghOQKpq4CHtzmI9SHG61whIyrTrBUxJtlrVyHhTOyU8VeGslyJZ5hO5e2NTnxLPn7PUkXxAJ7mpCECv1iFSdJfIvQj46KDV4UY1gmTZpKDo1fpWZCKsGbXZ5BpfF7lJX+JDFNgaBG41CfsOT7WcC9OlKan4IiLyZ6rMh4epexVPjm/o/PciQI9iJLdFwLmYGqzy7ufaDB6VBERdEH/fX3k0xqEunxNMRRuwazBJ7jywFRUdavCbMFcdlud5PR+I/3Kn84+dUaup4SV+Q0Dhue8QhL9d88G183bN1jRb99kV80f3LXR6xoTehbWfdCYK1yrKZor3SCMGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(38100700002)(44832011)(52116002)(38350700002)(6486002)(956004)(508600001)(36756003)(2616005)(6512007)(1076003)(66476007)(66556008)(316002)(66946007)(26005)(6506007)(54906003)(30864003)(186003)(2906002)(86362001)(110136005)(7416002)(4326008)(83380400001)(6666004)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kSSJilJPZb+Is8FL1sVQL059QdvO2GzkjRTarIQo4SoMvqsCG5vDjtREJe/j?=
 =?us-ascii?Q?4/HZpjff781NVKu2jYjVWUi+kKu2tAUw5RSpfvYRIiHgP1ymPnHGs398ESMj?=
 =?us-ascii?Q?cpSOIev7iteg7Os8uSA21HQSk/9HZTsJj+uYV/6jFpu+9nJUfwYVhMnNSKmF?=
 =?us-ascii?Q?SZzY1HAklprbqx7Nk11IKdND/Iqpy6CAUHY2Z5Xh+DDtg51bq9GcNwm+obX9?=
 =?us-ascii?Q?eunF+Vu2UrVQ3HFkNk4zTsUtMutXYbp16hmnMnAPgn2nmeh4bTfRRopd3hPi?=
 =?us-ascii?Q?Gep5GGOOO1yu2c+5iyH7ThpwO2QcmsuQnVnAxmgs5J8//zzQu8to6LLV0iH8?=
 =?us-ascii?Q?nNaMiUMw5Onm4AMFIc7dqdEOKkYTPdBDm3DGwjQBcXZBAS4tmqMMnGplYt79?=
 =?us-ascii?Q?gcWBrB64XufUryzSNDK4WjKDEqyUmcdlzR/7SGUDXDwWU1LX7ftNA7aaNFXX?=
 =?us-ascii?Q?YJwOkTwd/beTJixWZHTsmlKWZG9iFwN7goqSIti4tXPa44MuGSQKfHrJbv66?=
 =?us-ascii?Q?RPsRwjUiVVLeeBRB4XSF7ZkedT5PBkFQiRhKRWBtnvUx2VH8tFuWPc/bKKV1?=
 =?us-ascii?Q?254Xn9A0DMUrZH2le1FV5NuZ8gRSU80y7t+L+j5EN2aTL32P0ChDJEYo/xuC?=
 =?us-ascii?Q?PJ42HwXM7YqNYccvBQB1w4GyKVDzryMHg0zuyBUhcTfX9IyRg0TLRFWn+1ak?=
 =?us-ascii?Q?VLJHjSxvJ3F+QDofHNZWuo0hNgSFXAIaFEwLT7JblfhxXQSsSq++UVrIOlrA?=
 =?us-ascii?Q?K/708qX0sM4ijSiXJrWEsiG1oGKO1QkYNapJO0EMyGzZf3vI2gnkueAGKMlQ?=
 =?us-ascii?Q?EgHnoAvLhcOhXVU8vSqpcNwPJvdBh29DBhMi2aES89EiqeYpNx9bgOKWWvE+?=
 =?us-ascii?Q?InbRV8NzlLrRt8egeXOndx1YhZN9WriFf40jsG2ZsP1gkPYdz/s36kVqzLxz?=
 =?us-ascii?Q?0hrJKCbKL/RajpAff9PUif0qfHjeLjpiMWCCTtrHKsN+/skaMrOEYTll72f3?=
 =?us-ascii?Q?S79ctmCGm78luw/f4P6XMCrkPCLyoe96uxJy7QTIYTmeAfNfQFVUkvS4eUvq?=
 =?us-ascii?Q?6tZsBnihWPcnpZOG5jIwsPRqw/SVNulOiWlPVPRIk5zfxtndJjpHvZe9FYRP?=
 =?us-ascii?Q?WMysl3/7dDpW1g/7sRo+4YRp0PsovaLihugsqlbRR/Fbd8lhnYvHfEH7sSc0?=
 =?us-ascii?Q?bU9n+9KA+6EmvaoqHOGqC4tZXkT8lWpsM242TknsE/0PsQK56qSXsR2xaxsh?=
 =?us-ascii?Q?xLkgJ9PjU6Qc7SacxqKo+X5rP0r5hwkyKIOuYq6TSeE5rqHg0SfpN8b0K0Rh?=
 =?us-ascii?Q?SUU/slKwBKWpq0hML4YyovRr?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82170c29-5310-4c98-f3e1-08d94a3579f6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2021 21:46:19.1484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ikV57zB9ID2rBefVv+v1toB4SrVADSyHm4Y7BNG4mpcD9bkuZxuHl+tqStsAsFYT1rxRJ/c1O9LgCmbBrbQQ9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5502
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>

Allow switchdevs to forward frames from the CPU in accordance with the
bridge configuration in the same way as is done between bridge
ports. This means that the bridge will only send a single skb towards
one of the ports under the switchdev's control, and expects the driver
to deliver the packet to all eligible ports in its domain.

Primarily this improves the performance of multicast flows with
multiple subscribers, as it allows the hardware to perform the frame
replication.

The basic flow between the driver and the bridge is as follows:

- When joining a bridge port, the switchdev driver calls
  switchdev_bridge_port_offload() with tx_fwd_offload = true.

- The bridge sends offloadable skbs to one of the ports under the
  switchdev's control using skb->offload_fwd_mark = true.

- The switchdev driver checks the skb->offload_fwd_mark field and lets
  its FDB lookup select the destination port mask for this packet.

v1->v2:
- convert br_input_skb_cb::fwd_hwdoms to a plain unsigned long
- introduce a static key "br_switchdev_fwd_offload_used" to minimize the
  impact of the newly introduced feature on all the setups which don't
  have hardware that can make use of it
- introduce a check for nbp->flags & BR_FWD_OFFLOAD to optimize cache
  line access
- reorder nbp_switchdev_frame_mark_accel() and br_handle_vlan() in
  __br_forward()
- do not strip VLAN on egress if forwarding offload on VLAN-aware bridge
  is being used
- propagate errors from .ndo_dfwd_add_station() if not EOPNOTSUPP

v2->v3:
- replace the solution based on .ndo_dfwd_add_station with a solution
  based on switchdev_bridge_port_offload
- rename BR_FWD_OFFLOAD to BR_TX_FWD_OFFLOAD
v3->v4: rebase

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  2 +-
 .../marvell/prestera/prestera_switchdev.c     |  2 +-
 .../mellanox/mlxsw/spectrum_switchdev.c       |  2 +-
 .../microchip/sparx5/sparx5_switchdev.c       |  2 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |  2 +-
 drivers/net/ethernet/rocker/rocker_ofdpa.c    |  2 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  2 +-
 drivers/net/ethernet/ti/cpsw_new.c            |  2 +-
 include/linux/if_bridge.h                     |  3 +
 net/bridge/br_forward.c                       |  9 +++
 net/bridge/br_private.h                       | 29 +++++++++
 net/bridge/br_switchdev.c                     | 59 +++++++++++++++++--
 net/bridge/br_vlan.c                          | 10 +++-
 net/dsa/port.c                                |  2 +-
 14 files changed, 114 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index a7db964a9ee6..b2518639a16b 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -1936,7 +1936,7 @@ static int dpaa2_switch_port_bridge_join(struct net_device *netdev,
 	return switchdev_bridge_port_offload(netdev, netdev, NULL,
 					     &dpaa2_switch_port_switchdev_nb,
 					     &dpaa2_switch_port_switchdev_blocking_nb,
-					     extack);
+					     false, extack);
 
 err_egress_flood:
 	dpaa2_switch_port_set_fdb(port_priv, NULL);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 0072b6251522..ba159894cbea 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -504,7 +504,7 @@ int prestera_bridge_port_join(struct net_device *br_dev,
 	err = switchdev_bridge_port_offload(br_port->dev, port->dev, port,
 					    &swdev->swdev_nb,
 					    &swdev->swdev_nb_blk,
-					    extack);
+					    false, extack);
 	if (err)
 		goto err_brport_offload;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 517cf5b498af..95c57af778af 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -2388,7 +2388,7 @@ int mlxsw_sp_port_bridge_join(struct mlxsw_sp_port *mlxsw_sp_port,
 	return switchdev_bridge_port_offload(brport_dev, dev, mlxsw_sp_port,
 					     &mlxsw_sp_switchdev_notifier,
 					     &mlxsw_sp_switchdev_blocking_notifier,
-					     extack);
+					     false, extack);
 
 err_port_join:
 	mlxsw_sp_bridge_port_put(mlxsw_sp->bridge, bridge_port);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
index f8b1deffbfb4..bbbc6ff1ce85 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
@@ -119,7 +119,7 @@ static int sparx5_port_bridge_join(struct sparx5_port *port,
 	return switchdev_bridge_port_offload(ndev, ndev, NULL,
 					     &sparx5->switchdev_nb,
 					     &sparx5->switchdev_blocking_nb,
-					     extack);
+					     false, extack);
 }
 
 static int sparx5_port_pre_bridge_leave(struct sparx5_port *port,
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index f24f6a790814..4b69af71a8fb 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1200,7 +1200,7 @@ static int ocelot_netdevice_bridge_join(struct net_device *dev,
 	err = switchdev_bridge_port_offload(brport_dev, dev, priv,
 					    &ocelot_netdevice_nb,
 					    &ocelot_switchdev_blocking_nb,
-					    extack);
+					    false, extack);
 	if (err)
 		goto err_switchdev_offload;
 
diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/ethernet/rocker/rocker_ofdpa.c
index e1ffac8f78b8..2bf7222491b8 100644
--- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
+++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
@@ -2601,7 +2601,7 @@ static int ofdpa_port_bridge_join(struct ofdpa_port *ofdpa_port,
 	return switchdev_bridge_port_offload(dev, dev, NULL,
 					     &rocker_switchdev_notifier,
 					     &rocker_switchdev_blocking_notifier,
-					     extack);
+					     false, extack);
 }
 
 static int ofdpa_port_pre_bridge_leave(struct ofdpa_port *ofdpa_port,
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index b6f9bc885c52..aaac02f10586 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2099,7 +2099,7 @@ static int am65_cpsw_netdevice_port_link(struct net_device *ndev,
 	err = switchdev_bridge_port_offload(ndev, ndev, NULL,
 					    &am65_cpsw_switchdev_notifier,
 					    &am65_cpsw_switchdev_bl_notifier,
-					    extack);
+					    false, extack);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index c8f54d6d7e17..41a5fd3daba4 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1520,7 +1520,7 @@ static int cpsw_netdevice_port_link(struct net_device *ndev,
 	err = switchdev_bridge_port_offload(ndev, ndev, NULL,
 					    &cpsw_switchdev_notifier,
 					    &cpsw_switchdev_bl_notifier,
-					    extack);
+					    false, extack);
 	if (err)
 		return err;
 
diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 425a4196f9c6..b99291249ade 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -57,6 +57,7 @@ struct br_ip_list {
 #define BR_MRP_AWARE		BIT(17)
 #define BR_MRP_LOST_CONT	BIT(18)
 #define BR_MRP_LOST_IN_CONT	BIT(19)
+#define BR_TX_FWD_OFFLOAD	BIT(20)
 
 #define BR_DEFAULT_AGEING_TIME	(300 * HZ)
 
@@ -182,6 +183,7 @@ int switchdev_bridge_port_offload(struct net_device *brport_dev,
 				  struct net_device *dev, const void *ctx,
 				  struct notifier_block *atomic_nb,
 				  struct notifier_block *blocking_nb,
+				  bool tx_fwd_offload,
 				  struct netlink_ext_ack *extack);
 int switchdev_bridge_port_unoffload(struct net_device *brport_dev,
 				    struct net_device *dev, const void *ctx,
@@ -196,6 +198,7 @@ switchdev_bridge_port_offload(struct net_device *brport_dev,
 			      struct net_device *dev, const void *ctx,
 			      struct notifier_block *atomic_nb,
 			      struct notifier_block *blocking_nb,
+			      bool tx_fwd_offload,
 			      struct netlink_ext_ack *extack)
 {
 	return -EINVAL;
diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 07856362538f..4873ecdc6f56 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -48,6 +48,8 @@ int br_dev_queue_push_xmit(struct net *net, struct sock *sk, struct sk_buff *skb
 		skb_set_network_header(skb, depth);
 	}
 
+	skb->offload_fwd_mark = br_switchdev_accels_skb(skb);
+
 	dev_queue_xmit(skb);
 
 	return 0;
@@ -76,6 +78,11 @@ static void __br_forward(const struct net_bridge_port *to,
 	struct net *net;
 	int br_hook;
 
+	/* Mark the skb for forwarding offload early so that br_handle_vlan()
+	 * can know whether to pop the VLAN header on egress or keep it.
+	 */
+	nbp_switchdev_frame_mark_accel(to, skb);
+
 	vg = nbp_vlan_group_rcu(to);
 	skb = br_handle_vlan(to->br, to, vg, skb);
 	if (!skb)
@@ -174,6 +181,8 @@ static struct net_bridge_port *maybe_deliver(
 	if (!should_deliver(p, skb))
 		return prev;
 
+	nbp_switchdev_frame_mark_tx_fwd(p, skb);
+
 	if (!prev)
 		goto out;
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 1d3e5957d4d5..0d965f35910c 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -518,12 +518,20 @@ struct br_input_skb_cb {
 #endif
 
 #ifdef CONFIG_NET_SWITCHDEV
+	/* Set if TX data plane offloading is used towards at least one
+	 * hardware domain.
+	 */
+	u8 fwd_accel:1;
 	/* The switchdev hardware domain from which this packet was received.
 	 * If skb->offload_fwd_mark was set, then this packet was already
 	 * forwarded by hardware to the other ports in the source hardware
 	 * domain, otherwise it wasn't.
 	 */
 	int src_hwdom;
+	/* Bit mask of hardware domains towards this packet has already been
+	 * transmitted using the TX data plane offload.
+	 */
+	unsigned long fwd_hwdoms;
 #endif
 };
 
@@ -1688,6 +1696,12 @@ static inline void br_sysfs_delbr(struct net_device *dev) { return; }
 
 /* br_switchdev.c */
 #ifdef CONFIG_NET_SWITCHDEV
+bool br_switchdev_accels_skb(struct sk_buff *skb);
+
+void nbp_switchdev_frame_mark_accel(const struct net_bridge_port *p,
+				    struct sk_buff *skb);
+void nbp_switchdev_frame_mark_tx_fwd(const struct net_bridge_port *p,
+				     struct sk_buff *skb);
 void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 			      struct sk_buff *skb);
 bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
@@ -1708,6 +1722,21 @@ static inline void br_switchdev_frame_unmark(struct sk_buff *skb)
 	skb->offload_fwd_mark = 0;
 }
 #else
+static inline bool br_switchdev_accels_skb(struct sk_buff *skb)
+{
+	return false;
+}
+
+static inline void nbp_switchdev_frame_mark_accel(const struct net_bridge_port *p,
+						  struct sk_buff *skb)
+{
+}
+
+static inline void nbp_switchdev_frame_mark_tx_fwd(const struct net_bridge_port *p,
+						   struct sk_buff *skb)
+{
+}
+
 static inline void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 					    struct sk_buff *skb)
 {
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 2a5acfaf8f92..1fdebbc63346 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -8,6 +8,40 @@
 
 #include "br_private.h"
 
+static struct static_key_false br_switchdev_fwd_offload_used;
+
+static bool nbp_switchdev_can_offload_tx_fwd(const struct net_bridge_port *p,
+					     const struct sk_buff *skb)
+{
+	if (!static_branch_unlikely(&br_switchdev_fwd_offload_used))
+		return false;
+
+	return (p->flags & BR_TX_FWD_OFFLOAD) &&
+	       (p->hwdom != BR_INPUT_SKB_CB(skb)->src_hwdom);
+}
+
+bool br_switchdev_accels_skb(struct sk_buff *skb)
+{
+	if (!static_branch_unlikely(&br_switchdev_fwd_offload_used))
+		return false;
+
+	return BR_INPUT_SKB_CB(skb)->fwd_accel;
+}
+
+void nbp_switchdev_frame_mark_accel(const struct net_bridge_port *p,
+				    struct sk_buff *skb)
+{
+	if (nbp_switchdev_can_offload_tx_fwd(p, skb))
+		BR_INPUT_SKB_CB(skb)->fwd_accel = true;
+}
+
+void nbp_switchdev_frame_mark_tx_fwd(const struct net_bridge_port *p,
+				     struct sk_buff *skb)
+{
+	if (nbp_switchdev_can_offload_tx_fwd(p, skb))
+		set_bit(p->hwdom, &BR_INPUT_SKB_CB(skb)->fwd_hwdoms);
+}
+
 void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 			      struct sk_buff *skb)
 {
@@ -18,8 +52,10 @@ void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
 				  const struct sk_buff *skb)
 {
-	return !skb->offload_fwd_mark ||
-	       BR_INPUT_SKB_CB(skb)->src_hwdom != p->hwdom;
+	struct br_input_skb_cb *cb = BR_INPUT_SKB_CB(skb);
+
+	return !test_bit(p->hwdom, &cb->fwd_hwdoms) &&
+		(!skb->offload_fwd_mark || cb->src_hwdom != p->hwdom);
 }
 
 /* Flags that can be offloaded to hardware */
@@ -164,8 +200,11 @@ static void nbp_switchdev_hwdom_put(struct net_bridge_port *leaving)
 
 static int nbp_switchdev_add(struct net_bridge_port *p,
 			     struct netdev_phys_item_id ppid,
+			     bool tx_fwd_offload,
 			     struct netlink_ext_ack *extack)
 {
+	int err;
+
 	if (p->offload_count) {
 		/* Prevent unsupported configurations such as a bridge port
 		 * which is a bonding interface, and the member ports are from
@@ -189,7 +228,16 @@ static int nbp_switchdev_add(struct net_bridge_port *p,
 	p->ppid = ppid;
 	p->offload_count = 1;
 
-	return nbp_switchdev_hwdom_set(p);
+	err = nbp_switchdev_hwdom_set(p);
+	if (err)
+		return err;
+
+	if (tx_fwd_offload) {
+		p->flags |= BR_TX_FWD_OFFLOAD;
+		static_branch_inc(&br_switchdev_fwd_offload_used);
+	}
+
+	return 0;
 }
 
 static void nbp_switchdev_del(struct net_bridge_port *p,
@@ -210,6 +258,8 @@ static void nbp_switchdev_del(struct net_bridge_port *p,
 
 	if (p->hwdom)
 		nbp_switchdev_hwdom_put(p);
+
+	p->flags &= ~BR_TX_FWD_OFFLOAD;
 }
 
 static int nbp_switchdev_sync_objs(struct net_bridge_port *p, const void *ctx,
@@ -280,6 +330,7 @@ int switchdev_bridge_port_offload(struct net_device *brport_dev,
 				  struct net_device *dev, const void *ctx,
 				  struct notifier_block *atomic_nb,
 				  struct notifier_block *blocking_nb,
+				  bool tx_fwd_offload,
 				  struct netlink_ext_ack *extack)
 {
 	struct netdev_phys_item_id ppid;
@@ -296,7 +347,7 @@ int switchdev_bridge_port_offload(struct net_device *brport_dev,
 	if (err)
 		return err;
 
-	err = nbp_switchdev_add(p, ppid, extack);
+	err = nbp_switchdev_add(p, ppid, tx_fwd_offload, extack);
 	if (err)
 		return err;
 
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 18f5d0380ee1..65334e5b8002 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -457,7 +457,15 @@ struct sk_buff *br_handle_vlan(struct net_bridge *br,
 		u64_stats_update_end(&stats->syncp);
 	}
 
-	if (v->flags & BRIDGE_VLAN_INFO_UNTAGGED)
+	/* If the skb will be sent using forwarding offload, the assumption is
+	 * that the switchdev will inject the packet into hardware together
+	 * with the bridge VLAN, so that it can be forwarded according to that
+	 * VLAN. The switchdev should deal with popping the VLAN header in
+	 * hardware on each egress port as appropriate. So only strip the VLAN
+	 * header if forwarding offload is not being used.
+	 */
+	if (v->flags & BRIDGE_VLAN_INFO_UNTAGGED &&
+	    !br_switchdev_accels_skb(skb))
 		__vlan_hwaccel_clear_tag(skb);
 
 	if (p && (p->flags & BR_VLAN_TUNNEL) &&
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 632c33c63064..fce69cf3f8e3 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -257,7 +257,7 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 	err = switchdev_bridge_port_offload(brport_dev, dev, dp,
 					    &dsa_slave_switchdev_notifier,
 					    &dsa_slave_switchdev_blocking_notifier,
-					    extack);
+					    false, extack);
 	if (err)
 		goto out_rollback_unbridge;
 
-- 
2.25.1

