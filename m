Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 117ED2DCE01
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 10:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbgLQI7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 03:59:21 -0500
Received: from mail-eopbgr60046.outbound.protection.outlook.com ([40.107.6.46]:50264
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727345AbgLQI7T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 03:59:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QntQj8BBVZhfzdqpf0rRxlNu/MBPXOPVBwmAP0cwSI0ROcnnbeAv3yADzlo2B504W0bjFS25AgPgbCXf9N+Sdekrc+C+ELR3rM12bFaT0P0qDUy9lS75IqrvCwxkfsqMdwey9B3PgMPupGUSF0jef3STfAv5Mezej0zl97DGR4jpj2xKKmYvHpOwekxpTZnGrJ6V0E7qm8t5/AC0KfG85MJBRJv9NBRkYbCsDwixYbJ2ZJJY/JlGyiHe2LC7/sm7Vz/073cOpKGGNi+9uC/5jCcrqDlE00mgtkKhQ94geKQfVaQdJi3yVIwtpJ9B48Ez0fAtOZNy6liHbplbJNSA3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hKLk6L3XB/vKicYkbSR1skju+GfjNK/S/DzptLIddwg=;
 b=oL/O4k80JFVSBkEucWxhT4TVwEfxZWY3KhGZZvjxhdpFyXlSwjoUaWdAtcYDVEjcrmgIJfOoUvbLy4fSoSdzQHWOonCk2Cg+CIT+xyvb7P/GCr763jmEQbELiMFu0x8HbN97DCCmAvCx6I6X5Cu/rqnyz1DpOb5OUi0kksh7ld0DDcji93lLctryUdwuL4S6oZoRHAqS9iivPRDptJ2efYd1dA6nHQ/mtjhlHHun0/MvSt05SvTMx+a/LY3wHU+i3s2uDgTA4v8TOTqv+Bxgoe5IT0iEgk6StzXYSz3In+XQEYT/9TSYRyiXr+ZBcNhKuz1fIq/dOgLAgunlZbNnZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hKLk6L3XB/vKicYkbSR1skju+GfjNK/S/DzptLIddwg=;
 b=S5pczeXgRrDP+oa3GceLAqDRcFN1rR/mqUTggvAK1YgkrnUVv3tLHCakUTJQqp7SbJ1U/YHFvPZITum/LMypN5K2ldJD+/5SfWomWMW/dgIuqR6LMvEw5KjwtxATBlMChKbCpzDb1bGtrDkt8Vp/3B+ehYv0v5hZ496dM1Bh6pU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB6674.eurprd05.prod.outlook.com (2603:10a6:20b:151::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.20; Thu, 17 Dec
 2020 08:57:38 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::4d67:7d47:90f1:19be]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::4d67:7d47:90f1:19be%7]) with mapi id 15.20.3654.021; Thu, 17 Dec 2020
 08:57:38 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        andrew@lunn.ch, f.fainelli@gmail.com, mkubecek@suse.cz,
        mlxsw@nvidia.com, idosch@nvidia.com,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net-next v2 6/7] mlxsw: ethtool: Pass link mode in use to ethtool
Date:   Thu, 17 Dec 2020 10:57:16 +0200
Message-Id: <20201217085717.4081793-7-danieller@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201217085717.4081793-1-danieller@mellanox.com>
References: <20201217085717.4081793-1-danieller@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [37.142.13.130]
X-ClientProxiedBy: VI1PR0601CA0024.eurprd06.prod.outlook.com
 (2603:10a6:800:1e::34) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-155.mtr.labs.mlnx (37.142.13.130) by VI1PR0601CA0024.eurprd06.prod.outlook.com (2603:10a6:800:1e::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 17 Dec 2020 08:57:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9f5de219-a726-422f-165a-08d8a269ce39
X-MS-TrafficTypeDiagnostic: AM0PR05MB6674:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM0PR05MB6674D26D0C8783D87EF29F1ED5C40@AM0PR05MB6674.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:626;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bwp1+y98jOSSrDl3kBcaOLdWNH3d6f3OqYHjHcNDmkEffU+vod34i+gFwvhxRJntXoN28GD5SGceX2xyJHCbSC0HLnXtS9Oyn14ht/ESu37ENKPSGBAl4TIBHh7U59DLGIcXS5iuIxTYYEfO0L05TD1JuprIOKLnUjNX13BRh9N/esxC430DIBkJAJYkaj78F+vLmw6i5IK89fxhyfYQor6X3VC3AsWSV6RmZEHD62DjLQIpUZNjQy30HbP7x07tYchanPTlaiAz8xQBHAfZVFK2IHGzapo7VkDudYTL2fpfcObAL1ZpVNmxqQ98lHAtZ5nDbAFqTc38ehhTqDfPUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(39860400002)(366004)(6916009)(316002)(86362001)(66476007)(2906002)(8936002)(5660300002)(2616005)(6512007)(6486002)(1076003)(4326008)(7416002)(6666004)(6506007)(36756003)(66556008)(26005)(8676002)(956004)(83380400001)(186003)(16526019)(66946007)(52116002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?q+Y/iPvEPn25lWcdVb1kehueEQk2W3JJMCCh4jM8JOckeH/lIiULSuvh6duW?=
 =?us-ascii?Q?+/qEXhQcJf8vS2ZM+y8tYnpKqVFlsP7bT1XIm6eDyYE9iAhsFcibPxJoc+t3?=
 =?us-ascii?Q?RbZZk8jlWdaS0SfNRRB0EPrZ1iCoql6+6jDeg2x3SBp5An6gMJLoROW4FbRE?=
 =?us-ascii?Q?xu2+tGjFJ8sE57QIJwZfb/69PPPUehMAxqMcnJW0m5fFjtGX6NOI2E0zzInO?=
 =?us-ascii?Q?gMz14+Jrbl4zJQLqT+atIDXRjoLA5trxaoRvUxAxaxbzQSZ4bhx1Eov5L1CB?=
 =?us-ascii?Q?wCSFwKhaLwK/WQXVupKT5mvloZR//f3SUoPa690RDsjKW4RCoAImpxRqEY0e?=
 =?us-ascii?Q?iuCa6/tivD6SpmvnzLrhRri9YdcFZ59QMO4jBwHwGYQdKm+w1VUChLSer3Cn?=
 =?us-ascii?Q?oXhpbUxclb4I43RcK09YshcAy58TiSXmmiNh8E2YlARFOiKrfCZmnZ5JhRbR?=
 =?us-ascii?Q?IEfidASB9B+eDMejmTXy2DOXEwI6K32tPLB5CZEeoHnQ4biVrRxkR0HfWxGg?=
 =?us-ascii?Q?KGhkQMB2iao2q1Or9NTqxW9EPI0zX4fsZCLmogwab0ADwwBIgUZEjYdHIMHc?=
 =?us-ascii?Q?peYGJBu+k8JaYuGvk6Iy54jBh8EYE1ff76xX8Yl/yit1pu4q9VoS2/iUCvsL?=
 =?us-ascii?Q?drD3dFlQMGDR6YaWDqkqDaGEpXJFbv7SJPDUmsDpbWP326Y8IRWzZALxYwWc?=
 =?us-ascii?Q?3NFSQOCHIRXsBfaZGNgkqjRhgz5jrU+PQA+EH/LPQg1SZb8rhXq3D9EiM7jc?=
 =?us-ascii?Q?krpo/J8f0QMcKHV2Ehe+x+aoFosXWvUQOmAxbIcdwQytO7QKJiBr/gBUn/g6?=
 =?us-ascii?Q?HVGYVIpSHcNIUCWKiUIGIxW03iF+RUdfbxoTIfWQ0l1/cGM0OD8JbmC8t+ii?=
 =?us-ascii?Q?wV5zIkLTpDjfdkIBk/N9EHDzUQ6PjJrNYoZYNNcu/Dm5ceslL1/CgiakjMhr?=
 =?us-ascii?Q?rIH14g3ZitRrUNAqgw/AOMN/Rq0kiw6wiB/8tSU6U4WDTirDJQvSm94XdYwc?=
 =?us-ascii?Q?ehva?=
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB5010.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2020 08:57:38.7259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f5de219-a726-422f-165a-08d8a269ce39
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RFvQDN7+GgskS6dpNnRQl6hEYDU/0V6yPbmnLemzxl+Da3xfxZ0ynIwi1y1JHbdBIcawt6W7pAmZXrIVLqBbzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6674
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Currently, when user space queries the link's parameters, as speed and
duplex, each parameter is passed from the driver to ethtool.

Instead, pass the link mode bit in use.
In Spectrum-1, simply pass the bit that is set to '1' from PTYS register.
In Spectrum-2, pass the first link mode bit in the mask of the used
link mode.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
---

Notes:
    v2:
    	* Reword commit message.
    	* Pass link mode bit to ethtool instead of link parameters.
    	* Use u32 for lanes param instead ETHTOOL_LANES defines.

 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  6 +--
 .../mellanox/mlxsw/spectrum_ethtool.c         | 47 +++++++++++--------
 2 files changed, 30 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 0ad6b8a581d5..4bf5c4ebc030 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -331,9 +331,9 @@ struct mlxsw_sp_port_type_speed_ops {
 	void (*from_ptys_link)(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto,
 			       unsigned long *mode);
 	u32 (*from_ptys_speed)(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto);
-	void (*from_ptys_speed_duplex)(struct mlxsw_sp *mlxsw_sp,
-				       bool carrier_ok, u32 ptys_eth_proto,
-				       struct ethtool_link_ksettings *cmd);
+	void (*from_ptys_link_mode)(struct mlxsw_sp *mlxsw_sp,
+				    bool carrier_ok, u32 ptys_eth_proto,
+				    struct ethtool_link_ksettings *cmd);
 	int (*ptys_max_speed)(struct mlxsw_sp_port *mlxsw_sp_port, u32 *p_max_speed);
 	u32 (*to_ptys_advert_link)(struct mlxsw_sp *mlxsw_sp,
 				   const struct ethtool_link_ksettings *cmd);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index b6c19a76388f..db2e61ed47e3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -966,8 +966,8 @@ static int mlxsw_sp_port_get_link_ksettings(struct net_device *dev,
 
 	cmd->base.autoneg = autoneg ? AUTONEG_ENABLE : AUTONEG_DISABLE;
 	cmd->base.port = mlxsw_sp_port_connector_port(connector_type);
-	ops->from_ptys_speed_duplex(mlxsw_sp, netif_carrier_ok(dev),
-				    eth_proto_oper, cmd);
+	ops->from_ptys_link_mode(mlxsw_sp, netif_carrier_ok(dev),
+				 eth_proto_oper, cmd);
 
 	return 0;
 }
@@ -1223,19 +1223,21 @@ mlxsw_sp1_from_ptys_speed(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto)
 }
 
 static void
-mlxsw_sp1_from_ptys_speed_duplex(struct mlxsw_sp *mlxsw_sp, bool carrier_ok,
-				 u32 ptys_eth_proto,
-				 struct ethtool_link_ksettings *cmd)
+mlxsw_sp1_from_ptys_link_mode(struct mlxsw_sp *mlxsw_sp, bool carrier_ok,
+			      u32 ptys_eth_proto,
+			      struct ethtool_link_ksettings *cmd)
 {
-	cmd->base.speed = SPEED_UNKNOWN;
-	cmd->base.duplex = DUPLEX_UNKNOWN;
+	int i;
+
+	cmd->link_mode = LINK_MODE_UNKNOWN;
 
 	if (!carrier_ok)
 		return;
 
-	cmd->base.speed = mlxsw_sp1_from_ptys_speed(mlxsw_sp, ptys_eth_proto);
-	if (cmd->base.speed != SPEED_UNKNOWN)
-		cmd->base.duplex = DUPLEX_FULL;
+	for (i = 0; i < MLXSW_SP1_PORT_LINK_MODE_LEN; i++) {
+		if (ptys_eth_proto & mlxsw_sp1_port_link_mode[i].mask)
+			cmd->link_mode = mlxsw_sp1_port_link_mode[i].mask_ethtool;
+	}
 }
 
 static int mlxsw_sp1_ptys_max_speed(struct mlxsw_sp_port *mlxsw_sp_port, u32 *p_max_speed)
@@ -1324,7 +1326,7 @@ const struct mlxsw_sp_port_type_speed_ops mlxsw_sp1_port_type_speed_ops = {
 	.from_ptys_supported_port	= mlxsw_sp1_from_ptys_supported_port,
 	.from_ptys_link			= mlxsw_sp1_from_ptys_link,
 	.from_ptys_speed		= mlxsw_sp1_from_ptys_speed,
-	.from_ptys_speed_duplex		= mlxsw_sp1_from_ptys_speed_duplex,
+	.from_ptys_link_mode		= mlxsw_sp1_from_ptys_link_mode,
 	.ptys_max_speed			= mlxsw_sp1_ptys_max_speed,
 	.to_ptys_advert_link		= mlxsw_sp1_to_ptys_advert_link,
 	.to_ptys_speed_lanes		= mlxsw_sp1_to_ptys_speed_lanes,
@@ -1660,19 +1662,24 @@ mlxsw_sp2_from_ptys_speed(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto)
 }
 
 static void
-mlxsw_sp2_from_ptys_speed_duplex(struct mlxsw_sp *mlxsw_sp, bool carrier_ok,
-				 u32 ptys_eth_proto,
-				 struct ethtool_link_ksettings *cmd)
+mlxsw_sp2_from_ptys_link_mode(struct mlxsw_sp *mlxsw_sp, bool carrier_ok,
+			      u32 ptys_eth_proto,
+			      struct ethtool_link_ksettings *cmd)
 {
-	cmd->base.speed = SPEED_UNKNOWN;
-	cmd->base.duplex = DUPLEX_UNKNOWN;
+	struct mlxsw_sp2_port_link_mode link;
+	int i;
+
+	cmd->link_mode = LINK_MODE_UNKNOWN;
 
 	if (!carrier_ok)
 		return;
 
-	cmd->base.speed = mlxsw_sp2_from_ptys_speed(mlxsw_sp, ptys_eth_proto);
-	if (cmd->base.speed != SPEED_UNKNOWN)
-		cmd->base.duplex = DUPLEX_FULL;
+	for (i = 0; i < MLXSW_SP2_PORT_LINK_MODE_LEN; i++) {
+		if (ptys_eth_proto & mlxsw_sp2_port_link_mode[i].mask) {
+			link = mlxsw_sp2_port_link_mode[i];
+			cmd->link_mode = link.mask_ethtool[1];
+		}
+	}
 }
 
 static int mlxsw_sp2_ptys_max_speed(struct mlxsw_sp_port *mlxsw_sp_port, u32 *p_max_speed)
@@ -1795,7 +1802,7 @@ const struct mlxsw_sp_port_type_speed_ops mlxsw_sp2_port_type_speed_ops = {
 	.from_ptys_supported_port	= mlxsw_sp2_from_ptys_supported_port,
 	.from_ptys_link			= mlxsw_sp2_from_ptys_link,
 	.from_ptys_speed		= mlxsw_sp2_from_ptys_speed,
-	.from_ptys_speed_duplex		= mlxsw_sp2_from_ptys_speed_duplex,
+	.from_ptys_link_mode		= mlxsw_sp2_from_ptys_link_mode,
 	.ptys_max_speed			= mlxsw_sp2_ptys_max_speed,
 	.to_ptys_advert_link		= mlxsw_sp2_to_ptys_advert_link,
 	.to_ptys_speed_lanes		= mlxsw_sp2_to_ptys_speed_lanes,
-- 
2.26.2

