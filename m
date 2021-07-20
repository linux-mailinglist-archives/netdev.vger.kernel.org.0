Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44F943CFB3B
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 15:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbhGTNMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:12:02 -0400
Received: from mail-eopbgr130074.outbound.protection.outlook.com ([40.107.13.74]:25504
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238009AbhGTNHT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:07:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EBUcreYpTI6KA65xw5AqjHX60SJsYm9nsqkcxCdTANOOW5goPQyv8wpP70daTxAc4jDuQGDc79TSvcN+j+tgs6b/28qOHtDtVs/MID0xd41e5fYj5edpbMpiCC3M0KFxewy188JC9kA236C8MG+GXUNsJpRPXT/HVf2BMHer3Wxayuor0QFLNM8m0XNiTQhVbrXoF02tHOqnNf/OjNmZljjWILSDUvN8GOgVC6cUKPk1e4RWxP+wjxUT3aF3HfM6e2XMQhBRzIu0qMtcD3JjhGP+fY67KlyswuH8qd0NySgC8N3x0JRNcDiOCFrnf7Blw7Ze5L6O1OjdalKa6Xvvog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5NwT0Lcz2EF0/jNw7fQ1Gxfv28nsd+8u+Xgwk9fQA94=;
 b=ZeEi3GxLr5r+MY/UyicijePt2BhNC4Om12Z2/qtDzcjzVNm3Zg95W8NGfrJ6Hzs/+wHb2YwP/BVp3IQaoxJ5V6QF4XDOVc4QOnTJqeCM+vBQncA4/JN0nP99wx9qCkADJcjsJGuomR65x5+J723UDLeQ43oyoSJ1oqe/0iHScbKICodNjlPRw1Adckvu2vd+BsJeZDDFpL9oupblAU29KS4+LFLjx65q6+IrdsP2v6LNnxpbbLPqmXSLGD6HpNmZDRD5GW+9mUgbF/QT4HX2XpEcg1HhJcUndJP2xPlYBQQTF1RxAiISr3QwVxAlVSVUY5BCcEOWS7f7r/jI+jp0hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5NwT0Lcz2EF0/jNw7fQ1Gxfv28nsd+8u+Xgwk9fQA94=;
 b=NdohlsnPhkPFoBu6eKUCcWEZpug758hCBlWARd45qZZO8JDWRRSGLPaX1mFa+kiWmktDz6P1ijh54xvvuBCOX2jPaihLU7hLgbMUCB7X1PFGPAfpjbIOQSoLgX3Tea5Lu6QHC28jGJBB/VuBx1nZX8J3bzMJdxeEim/DSbVqMhM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3551.eurprd04.prod.outlook.com (2603:10a6:803:a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Tue, 20 Jul
 2021 13:47:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 13:47:17 +0000
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
Subject: [PATCH v5 net-next 04/10] mlxsw: spectrum: refactor leaving an 8021q upper that is a bridge port
Date:   Tue, 20 Jul 2021 16:46:49 +0300
Message-Id: <20210720134655.892334-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210720134655.892334-1-vladimir.oltean@nxp.com>
References: <20210720134655.892334-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P191CA0002.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:102:54::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by PR3P191CA0002.EURP191.PROD.OUTLOOK.COM (2603:10a6:102:54::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19 via Frontend Transport; Tue, 20 Jul 2021 13:47:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c4c2649-c653-4828-b2a5-08d94b84e324
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3551:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3551ED3A6B2FE5BF191154A1E0E29@VI1PR0402MB3551.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:626;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gNYcxaAmJ3bpgDu1fA89L2v1Boun2JyHQuVR07sFd/qN8vcLsuImzmkZ8yTvuQLaK2UxyzA/HLo5I+q+vVoM5xecy22sXhG1UcvU3iBeRD/H/b4eMtNO87b3/lRhV2fkL4WTaqbNoUZsS4HQ6Zr/es8w7ZqN8gEL79c4eA2e1MmhoP2enaAmCn+BsMaim3C1QRIbkxGI9zAE++KFc8k85flKbWCxMkp331VY5azCRpHIxe/Y2tslsBdx5Jor7t3mmyEpCG/yarB8z95kkh2z/cE8bsiK9AzL6hkJBtn/w/qLIfx9pcMsFbP9Z2E3HVzOtNptadu/lof0zcIgP2bkvAQud7To/waBEUXfd1WBgybSzv42zdN2IfH6DQB3wFAlBgo75fiAeuCSQcm8gjNx1R0ldnVrflZKcQc5Se327MtchADsS+fyDP2PwQix47sWEwgxWQ5ZwobmIpyGCicZ8MRfK1Kz1LP145tCjvSa7hp8zPthd7nUJ3TADWHk0VsWaqzvJxk1ifl/SsbcnJ6QoCyay8d1vp0eh6Wrp8In1vOTnwmpm1aDEWferSKMTi8MBkqmO0r97K5hZwG3/TCt8RA7ORTdaIRbnAcgzoEVrmELIzgyz/hZuXSIe9/f5Vewkincw5HHi1211W5X1BYkQSL82GV243/geP3pa1DOht3/6JpjEA4MKqBq438njZp5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(478600001)(44832011)(316002)(38100700002)(2616005)(956004)(5660300002)(6486002)(54906003)(1076003)(38350700002)(2906002)(66946007)(6512007)(7416002)(110136005)(86362001)(83380400001)(66476007)(8936002)(186003)(4326008)(66556008)(6506007)(6666004)(26005)(36756003)(8676002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/K+J8yA1lpaDo2PHT7D+qDhslZBJW8B4KwRn/ksszbC0/WtfDJj5/acAvA1W?=
 =?us-ascii?Q?5GwPZwnkWagmzTpCj/z467d/HpOgmS0AJtEyHojUA7IirgT1BJUDL41DlJyB?=
 =?us-ascii?Q?8Y5HXMW5cEN6YV1TOHwIOklL31CKX8DppF1pf5Ml7GgSuWB36WDTmCbJtxAt?=
 =?us-ascii?Q?2XCx81Aw5dy2wpmiNH4bHWkCpyPDv52ukhDwkh6ohCn4zcFpUTg8yWoOuamr?=
 =?us-ascii?Q?1EydE3X00vyFyGvAwv4UVVkcXbrl9/eA0/SVDvLeaQYYQaTWDNsolZ7hsKrT?=
 =?us-ascii?Q?VckdsktdijhAXPRItdCSbScpee3hpL2Th4n7bK24C34b5u/NzolchNSs+8Im?=
 =?us-ascii?Q?3H0ao3EsW+Z+w6hQM1YlJj5gHd8ZyMa5HcTc/mv2fClvCYqqLw2xAPqIXA5c?=
 =?us-ascii?Q?YzJ2l0+uX8Qgxl31/IN+lOx5fMCwCWPKCGwnWCY9uD1U6vmmVgEu3gg0y/qU?=
 =?us-ascii?Q?FuTbHszZDCTrtXuWOHB2Uq421udnPQu0bZr8CduCYmtWeBrT4vjdxguPOWo3?=
 =?us-ascii?Q?Zg/03qzECA0HMVWWaoVe522rdzFgecGwIRSy6oqXIjSprn17Z4Y4VVsPIAbM?=
 =?us-ascii?Q?WNEbMvNQDwz0jNzSzBwqcsdVFU+OVZvL48CvpwTR0GSUdm1JwlQFWp5O2mqX?=
 =?us-ascii?Q?s/Md/MumtLhBJ039do5YV0Dl/UvtvQDdzZzPAtGXjVr2hmUAyyLK4RFoAyru?=
 =?us-ascii?Q?08ZJynm9vN46fIpLkkhc1XNwzq8KxS/KcwJqntzmlSCn96gkkCHV57a9KHif?=
 =?us-ascii?Q?MMWtcJ4Q2XrpwndHnCWJqx/eohcYukvJqZCODfZ0iO7Hl8djHE7z+7uimkyn?=
 =?us-ascii?Q?FxPzSsr7lEAxmISZ8qiCaqLpQswL4MgYEael1nGpiY7QrIEdYXCpvznPeYIF?=
 =?us-ascii?Q?VEHmwz/bEybH9bBzM5eKyw3D78fIXQWuKJQZh3TIxJnHpVpUAnm74T/3hqwU?=
 =?us-ascii?Q?bumIBCOpFIY4vKXrB+RnuU6yeK4kEcxwA00+CBY0AqSmD5e1JPpsBhjV0pMo?=
 =?us-ascii?Q?K37MIC70l/IV6L/tQiNv+g59/IFG+8a5dLZv/5Sq6LPFm3WuAknejJJHQxAU?=
 =?us-ascii?Q?jbEt7RifB2LrCqA6Ls+kQ6z0hQMVegrLfr3TCMJyUVgfutENxBfw5J3ux7NO?=
 =?us-ascii?Q?XggcLsvoOknhfPeWCJXvRgfdYYSROFZNFhr11hyFkJBkM7Lrqc8Zp12kaYAd?=
 =?us-ascii?Q?K0MQ3ZW9SSYApcsId0f6N6P6KDm8GVnpRoq1nc/Fipj01xeRl0wJ6w8oNMx1?=
 =?us-ascii?Q?LOVEk3TqGqXK9Tqu0dmaTclw3KRJ8DKZpTTgNNQXcDaGvqk5mgd2yegZyRGw?=
 =?us-ascii?Q?cXUzMuDyhFkdS0Mal/C5odv6?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c4c2649-c653-4828-b2a5-08d94b84e324
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 13:47:17.0004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +askNWNL5RnQvHzrN3w6QmKwiirUwCtdT7Gsrh5lCoTIV6dQguGB7molrBpu3SboUPV152L+YBIdSITNzqSI/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3551
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For symmetry with mlxsw_sp_port_lag_leave(), introduce a small function
called mlxsw_sp_port_vlan_leave() which checks whether the 8021q upper
we're leaving is a bridge port, and if it is, stop offloading that
bridge too.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v3->v4: patch is new
v4->v5: none

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

