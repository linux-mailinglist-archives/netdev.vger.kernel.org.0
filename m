Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD453CCB1F
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 23:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233528AbhGRVtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 17:49:24 -0400
Received: from mail-eopbgr140043.outbound.protection.outlook.com ([40.107.14.43]:15454
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233265AbhGRVtU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Jul 2021 17:49:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VMAaUJcU5QfxqVsIfA62YKEnoZKdfhuDQN9kqQyiA6l9UCFDbPjLaFT9n2MqcbWIyVyWu4hb/zuFA3ut34etmMUpRPZqEF656lIn466KCMI2NHlP2QGsZ3sstnaKcEeL3LDhjVXGzjt51FxI2tKIuv3R/eOI7dlFGQ886EPySUo+iE25HSzDQeO6SOh3/NwQinLgGm91STavSPvLkZm+tJ1J8B6SPuTmlhgz9WrWO5CUIF53CjHkTunWbSF1+LteXoh3eTKZeJuWvRH7c8zRSyqRDOlJnqi0kf7kGJ+XOVQESIcOrGTeTORa+s2gHr5VUIcJOQayz5ZMYSsOUl5lnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bvbeIVZl88ToICjHAmeKYYP1j/OuFxc9fvRDjVuotjE=;
 b=Vy73m0cNetEFBrQbWS/piXB3+566JMIyy/y9sQNN1Si/Wy9bhETipz3loAuGrkdahcuNqKfSERoCIZj+iFWafskLmjOFbzR5YzI1ZOEmxsm2ntvg+1zFvV7ZUJ4Bkk/vOsGPEGg+lV5mi86Rd9oL2zN3LHVHMaLTzGDdXTAjCwGMfG2hJWphIhl4l7RxlR8vMuhAnGiUcJqaGSnu5yXCSulODQncDmR3dqtYpWijkCggkBWzerm+2O5G1y2zW3m75YuY6U06uUZZxumoySv6/VH8yrCYSO2hrYEWaNueVJJFr66P8aJFe6dyTeuQhFEWCkYQNPSOa214j0n/1duuPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bvbeIVZl88ToICjHAmeKYYP1j/OuFxc9fvRDjVuotjE=;
 b=Sd4aeuSai407f7UpA0h3P78QAd+Ues01MzTqCmBudZ9q0/3vu0BjXabrYXHI1j/nl1TThmRvrpXJgdawJzntOFrMf5h/JMD3SW9WIRNhdTWomspOlGqwUx7FHwaoddO+tLNp3C+IDJldtHyKQ3cAbojqJdegLXNADDrTNhXDH6M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7325.eurprd04.prod.outlook.com (2603:10a6:800:1af::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Sun, 18 Jul
 2021 21:46:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.032; Sun, 18 Jul 2021
 21:46:13 +0000
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
Subject: [PATCH v4 net-next 04/15] mlxsw: spectrum: refactor leaving an 8021q upper that is a bridge port
Date:   Mon, 19 Jul 2021 00:44:23 +0300
Message-Id: <20210718214434.3938850-5-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (82.76.66.29) by VI1PR0602CA0014.eurprd06.prod.outlook.com (2603:10a6:800:bc::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Sun, 18 Jul 2021 21:46:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dfe0f57b-867a-4837-b7cd-08d94a35768f
X-MS-TrafficTypeDiagnostic: VE1PR04MB7325:
X-Microsoft-Antispam-PRVS: <VE1PR04MB7325101513C4D78E7B05CD90E0E09@VE1PR04MB7325.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:626;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xR4wrCrENvkbY8fg9xyy0MSs/9bAtyQh53W/aNeWP3/+u3TVjwwcfc1j/dXlx0Vmpc2bpYhna/QJsgMMYPISmv9DgzCVh06f3HWJTRgT0JNhGOcoHqpYADZHiR9CSdFlhl+RwhLJXcTlr1yZIsDYCca0lWrE58clI/Kvuv6ZANf/nCYRJOM1ZYIOoGReQbPZkeqPiLvijyUNbsVWHb8M4vb40kkaqcHi5+cH8rPW2lDRAD9prFVRPsPgWYDtWXwqGMtOKRCGT3KOR3QG1Nxd8KzZhlbunUZKH9o+l0EIX3Zk0tlIjagva5d617cYVlTs6T3YncL2I5/QjXTiZHAIPXevWa2f8DWS59QqKQ0IgH/Wlo+XN2O3CG7nTMyf33JiOXb4ntQygfLhUhavaeONPMIslUAzu40Nbso6rdYSunDFMW9/MVtbVOA8kgOVASkCjIqgx8wXZkKIkdXwlr7tPI3g94QkBW+37sILadbxJtpJJQ0iRnn7RL7hSidKhxgpnn1QRxPoKrfj1kyKumrNK0MPLmdk5VGSyw3W9tASXuzwml25UK6jInOTB/N4RMFutv+y4cWKfxifpAOT3JlIJLhloe9NLyd81f7ERtD0Jg96c/CviFR7MEUT9h8sN4P0IXMM/Fe3pkMf2AA2L1U3SQHavo6vwfnSmLN/3REadfbtkbaQopBe8g2uJMJfuG/w
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(366004)(39850400004)(346002)(6666004)(110136005)(8936002)(6506007)(8676002)(86362001)(54906003)(186003)(26005)(66946007)(66556008)(83380400001)(66476007)(52116002)(2906002)(1076003)(316002)(7416002)(5660300002)(478600001)(36756003)(6512007)(6486002)(44832011)(4326008)(956004)(38350700002)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EpHC6oL+UgxyRxuMqlXiJDjKrct2T+nxvW/xctGyOjCdiC4BpYy5lATeIXqK?=
 =?us-ascii?Q?ZoUcqqiS4hI+M19e89CQiO9WNRHkHsQLmLwDbCZxoDavM4sLKMh41RQAfcX6?=
 =?us-ascii?Q?+1FWsGjpjvkdsU6keJqv2/BZprz38wzUKkgttcY9zaA4wKsfd7N6e9JhgE+b?=
 =?us-ascii?Q?mMlW5q/WIBm15YX0fQLwAFIMCt9oc16Jq+qVSePWAlHIwE918kmSuoZKKU5w?=
 =?us-ascii?Q?nc0VRLwgEPZOOqlgcvH/+R3TxzC9hhHxPu66Oc5vLn/WGVXg5sK0lSMEgWgx?=
 =?us-ascii?Q?+uny4pRB4DkTbo9i5I2EwwpFhV0vJWVKM2aa0GiBYQdH7aHhSqTJRUF60zHC?=
 =?us-ascii?Q?lGd68fv0HZrXAcoh6YrymPz0ukUdODiqaKIbRVDgzbifRLe9at3vvC65EGCO?=
 =?us-ascii?Q?795MM8QfdR0FtadfAnyoyrCGfMJr0gFts9apYO43A8c5nwUE3GU+zf7BnprU?=
 =?us-ascii?Q?Nxc04Ni7tGONUuWU29WylUDz/kXn/VfjguMdiK3dq2K4xyQlc4tnp1NjNUtk?=
 =?us-ascii?Q?lcm8M6i50XPoY1PYvOlINm/njNvq4x693dQ+RQp/nLZqOydmMLleeq1JsXBs?=
 =?us-ascii?Q?4ndVHRzHVEb5Samw7DgVcDkvR3sx/lQc+O9xXeMGG+NRieOg0hnzC2SFeNu1?=
 =?us-ascii?Q?C4uoKRRnBxyv+91n+UJUcrLAoBmxO5Iqx0nMRjSgQARy6gI1CIEl9v796P2h?=
 =?us-ascii?Q?NdB3LQNwAzj3fS/gYWc2kuADoWznh38mCH+zICqLq3hNjgAP4OhtqTKGAEgd?=
 =?us-ascii?Q?/ZOQ9R6v6zZGdivPDyibs3UdNOZqlj5bApPZ38mu325Xmr0qXYVi43HM9T16?=
 =?us-ascii?Q?05p9IOSO0lQ0/XBBJxyXiS4D0tb7tgT+8qNb1apRGWCUsTZw0alGv+5ThBHh?=
 =?us-ascii?Q?CK/iqqdiprH/vts4faT106FMcqsEArmlStOmzMC0NQW8cebSSYWzZyA2EqP6?=
 =?us-ascii?Q?qVCY6tg4gamzGJrY/0upYIVUHlCiRZz08r1zYFdrN54DfzkggRQGH1yzqlmF?=
 =?us-ascii?Q?YE+7sZ0Mp4OcyAGzk5hjI6uncZg8ScBmfI9vfN1hxoHMGza87cmcgld5XaF9?=
 =?us-ascii?Q?38B/YQZBGpWLissWP34qqfDAXBcjHi/e1wve40IxEHddxXp7Fgl2lzewzpR6?=
 =?us-ascii?Q?2gUduFsddLvElMUxmKIJS28rNxsFMpM8G4bFBGABZ/o1muM0nrBNv7fvFP7f?=
 =?us-ascii?Q?7IclkMVgoqrFWOG6YPh+Jp4LPzVKihFy/jmA9x4X9pqeFPkSAqSpU5zG3Q8g?=
 =?us-ascii?Q?9e283uwo5Z2ply19oLPSroRl5GFeZr/NKQ5foRIQmjNis4WkSG1Yqtg0h3JS?=
 =?us-ascii?Q?kaBmUP4+cYXNKHf9IWpzeq1o?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfe0f57b-867a-4837-b7cd-08d94a35768f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2021 21:46:13.4187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OGYaGuaao8SiyChqWaQ98pPzXsO//9niPn+Y4P8O5V1ypSFSH7W+WP8shVuzpHgf69eg035z9RY5XKfo4rtClA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7325
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For symmetry with mlxsw_sp_port_lag_leave(), introduce a small function
called mlxsw_sp_port_vlan_leave() which checks whether the 8021q upper
we're leaving is a bridge port, and if it is, stop offloading that
bridge too.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v3->v4: patch is new

 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 25 +++++++++++--------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index c1b78878e5cf..b3d1fdc2d094 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3994,6 +3994,19 @@ static void mlxsw_sp_port_ovs_leave(struct mlxsw_sp_port *mlxsw_sp_port)
 	mlxsw_sp_port_vp_mode_set(mlxsw_sp_port, false);
 }
 
+static void mlxsw_sp_port_vlan_leave(struct mlxsw_sp_port *mlxsw_sp_port,
+				     struct net_device *vlan_dev)
+{
+	struct net_device *br_dev;
+
+	if (!netif_is_bridge_port(vlan_dev))
+		return;
+
+	br_dev = netdev_master_upper_dev_get(vlan_dev);
+
+	mlxsw_sp_port_bridge_leave(mlxsw_sp_port, vlan_dev, br_dev);
+}
+
 static bool mlxsw_sp_bridge_has_multiple_vxlans(struct net_device *br_dev)
 {
 	unsigned int num_vxlans = 0;
@@ -4225,16 +4238,8 @@ static int mlxsw_sp_netdevice_port_upper_event(struct net_device *lower_dev,
 		} else if (netif_is_macvlan(upper_dev)) {
 			if (!info->linking)
 				mlxsw_sp_rif_macvlan_del(mlxsw_sp, upper_dev);
-		} else if (is_vlan_dev(upper_dev)) {
-			struct net_device *br_dev;
-
-			if (!netif_is_bridge_port(upper_dev))
-				break;
-			if (info->linking)
-				break;
-			br_dev = netdev_master_upper_dev_get(upper_dev);
-			mlxsw_sp_port_bridge_leave(mlxsw_sp_port, upper_dev,
-						   br_dev);
+		} else if (is_vlan_dev(upper_dev) && !info->linking) {
+			mlxsw_sp_port_vlan_leave(mlxsw_sp_port, upper_dev);
 		}
 		break;
 	}
-- 
2.25.1

