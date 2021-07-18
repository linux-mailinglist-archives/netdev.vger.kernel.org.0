Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA913CCB0A
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 23:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233062AbhGRVtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 17:49:13 -0400
Received: from mail-eopbgr140071.outbound.protection.outlook.com ([40.107.14.71]:24552
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232896AbhGRVtM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Jul 2021 17:49:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FLgUyIJ7G3ZtsOdJuLr+tFXQ9LNTyt5IfX/WZUoO8LR2/ymsh/I+KmANw8+6ETBvUcA3Q12HbTMGpIlWG4SOI/zIaRyRwJyJmhGmAniiRBamG5/D38wimHKyhnTjHpBj0agtEDDf566o4Ds7QswP0xH42XPliM60nqJSXjly20VfmefUEs8IqL5LG/NiBFcKzTIIEkAjnl1Efp6XMXi4dB/+EMz4SPKty5HDzzXLJ28ld5Yij7jCpnbdzAt5FhAETkO0WAsqRdRoq/QCoLlbu1lZ+w+mYpOKYtSTC4K0f2l7T+oOvklGTVBcyFjR7j1mbOC8E/auIR9M57IBh5Iv/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qwyZdSk1iFTHcgKdbpcQLE4zz+zyBCZuegPxQIJ1tdA=;
 b=oD1lvaulIRN7AM0xLz3rrptzS06b9x9InBbTWvY9f+dEv4zDReq22j/MjFsAOXVv7zUzR2J3V873Gno3TkP734R3fWT4pBLWCg2ICEOOHtuYVLOq2x9YvWBx71dBcFU467IR2iRwfaAx01M22y1ODbyl2kFpIAZCSQsTQaoSkQwhANU8DIbO8Dmc/oaJghV+0ELJB3QqwNhsPF9qhxksWw7jlTY9dvAD8nVowolCtceUUL1WlwmMEd9dE+kZYRkT7kMwjvz7kQp8HxjYWbgf4xHgkEjdf3MFtVfyhL8tcbc7j+8gb5eHGouyraPm5mIoOKO3tn/WP5pbddlBCwZ/Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qwyZdSk1iFTHcgKdbpcQLE4zz+zyBCZuegPxQIJ1tdA=;
 b=h+uB8ikhnbLtiptRMTNxuntf+erKKBiLFvPTCCATYseVI8zKcVcGf52wr45bHa4JJFEM8R7vumjRMc2XXTAXzKa2kB6eu9Dddi2np08olCk2+NbRll9DGFjYaXZg3MBHGTERjwcZZRwa5C+dDLrVjzoVZWMTHKYm3kRUE/IjZME=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7325.eurprd04.prod.outlook.com (2603:10a6:800:1af::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Sun, 18 Jul
 2021 21:46:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.032; Sun, 18 Jul 2021
 21:46:10 +0000
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
        DENG Qingfang <dqfext@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v4 net-next 01/15] net: dpaa2-switch: use extack in dpaa2_switch_port_bridge_join
Date:   Mon, 19 Jul 2021 00:44:20 +0300
Message-Id: <20210718214434.3938850-2-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (82.76.66.29) by VI1PR0602CA0014.eurprd06.prod.outlook.com (2603:10a6:800:bc::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Sun, 18 Jul 2021 21:46:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c135e0d-5f0d-4768-a082-08d94a3574f7
X-MS-TrafficTypeDiagnostic: VE1PR04MB7325:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7325DDA1B10CB0F070BBA3A8E0E09@VE1PR04MB7325.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B1QaRYT2nqAqtZ83fd3SyxrUvs8cUX8Qo7JYLKO5S5Xd9bPdaIJmsIjMGgFuGaXh0iggXLvWMtzniosx1gOrycD6AbF0S/HoyWSrwSsMqk7TaicD7+kWqtRZ04pbhJsk/TxOWaSoFV8p4b5J3aDajfQmvK2AIpd7b+fn0tzZvtHt2RvVSEHhVNmUF4NXPAkrNd7R4mOtnsUJmbRRDNOZ3B6c3TdN9Hqqzdjv0SkXlG+x3rSfctCp6UWFSgvxIM5qerS6jiL18qB9uojM7UVeSwXA3TaNCClU5vadI15AsflR4zWZutK2k2EYdzFSbO+o4WbLI/xoa1DZdRxi+tUvmh9lldtmJnOsu0yGDlYEv2QGy9xV8zWVt1KirTHLZJQXiquogOjKHDvTGPCSX9zFaH9Vt2dsoeHHL+UfJNxS0p/hZXStZn4dQ7UtjvITFOkMy6bL66zdxBI2qBzH0xQT18fGxIOwaXPt7JIh+Rz20OlP35DMAocrtCnyKAzN9J3liup41UH/xH+TJ2EsWupLVCCAQWusuAFyT9EFGAPw5TT5MuqGMkWI3AvxqLyxznaQ1VlUTYUDQcfw+bA0rgcNJBQACF0zw4/0j4XVNx8P1LCryhZs2Ua3/hEExhUA6erJ0ss3slWn6/DNETgIQZPoZoQEFO0lpwyiB+rob6Z/x7xL9Xtbx+3vhQixUcnqesNVOVJPDfAJg553hqAneOKqsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(366004)(39850400004)(346002)(6666004)(110136005)(8936002)(6506007)(8676002)(86362001)(54906003)(186003)(26005)(66946007)(66556008)(83380400001)(66476007)(52116002)(2906002)(1076003)(316002)(7416002)(5660300002)(478600001)(36756003)(6512007)(6486002)(44832011)(4326008)(956004)(38350700002)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n/DrByRuEbP+V0Mj4ttsrHZ8v0rJGvpsEDdfaj0393yzyWRpH9NBosVJOqTN?=
 =?us-ascii?Q?5w1OA8J5VAMYiyzaBkwalbgl+NDEJfjCGfTij1JjK5nDleXrtjssILNGsCFm?=
 =?us-ascii?Q?bGiJaZv00foeMuz4w72EzsTP4tiL9Wfv6Ako5k8JRSG4Ny0c/l9UcRrCqsxU?=
 =?us-ascii?Q?akIbpIXl8888OVGKCIz6RwePJQt08uwznFZAHMQ31E7EIuoa77Rcp1en81HF?=
 =?us-ascii?Q?bUbis8j6EGUFWmpfQdFhxHMbsVlS8JQ0lNgIh+Gq2MUn1m+Wh7Oddfk2h1HU?=
 =?us-ascii?Q?umMvb3DrSBZKg8Dlmn0avquGpC2vJmcBZXfAz/K6RxBUkKlr3OoVfXh5fPoB?=
 =?us-ascii?Q?I9RPVNOHquQCp0dumSufNV5+EMTE1KxMi85AiKwkET+M0Z31//cELFAQ11Zq?=
 =?us-ascii?Q?KgSNKYzrcyMkCuS+wVNgWkosRhpSFp1GSiwV6knK5LkrsM4zk9aUuuhtXpa/?=
 =?us-ascii?Q?4iskACW9Ldj2So3IdCJbNkX8GwPiyptsc8wey0uOep/H5cC4bwFe/odtWlUM?=
 =?us-ascii?Q?ixNQuBIuE8ZRVuA0A03BU9DBRwBiMAI86vqxyC7ULpMX/SzbTaPjq0xUEmfx?=
 =?us-ascii?Q?UZ/WukNNHLelcIgoTN9IQ0SGjC++RvDXB6JpYFvEJgVpzI7jDhHPGHxKRqnp?=
 =?us-ascii?Q?NK8cjDr5u+FV5J3QWluzZ1OjQa0KD4/MvYKHbjldk2xTqH0vlBgQBLmCQvru?=
 =?us-ascii?Q?tObot4jnQ5S41mWfOHqnfvrCCn7joTv6I/hUQ0aHjrCgG1fRVgRGM5KjS5FT?=
 =?us-ascii?Q?6fE7fDCpRZWDv3GaVqzphKtKSihJM2vij4YbLbt2fjrrdtbmIIWk8axJum+H?=
 =?us-ascii?Q?oNZlIYbCY4iNP4jPabb185FdBvPSTs7P7xrTqc44jEj/7Qj5XAvx2CKkoPrO?=
 =?us-ascii?Q?VxnsE6k2p0CfRh/lIGES3oaE0M5fXH8mOPR3eqvcySwmCYZqfXn8A/3zEQVg?=
 =?us-ascii?Q?MUeGfl7MmhAWciw56GwhTpGATMKScHbGucUeKMjZ+5Qqf0fK4ahf5O2t3aUp?=
 =?us-ascii?Q?KpAZrGX8VrshQRSb2gTUqoF6FWfo6jmekQfJr2xZd0hIxAhPWPzHSJdHcUqn?=
 =?us-ascii?Q?DZPiDM7EJZPeEE8R2xu3U20bWVShCubQ0w5wB54qIBK29BSI0DBJn+7zEqvY?=
 =?us-ascii?Q?RHqTnsn0fkCAO1lARk9SEpZRvt9vdDqBki3o8ygEt3e35OzV1euMFQ+6CJuu?=
 =?us-ascii?Q?GWlkSfLPFz7FRjVo+nyUEUq/8ssX9cVeRwB6a+kZeFBNgJzrrvwkVN+7XvKx?=
 =?us-ascii?Q?RZ5N4WfN07WdAFmwQkTO0ZB9Pj1O1HQqqxKK6ZeZsw3MOzNw9FkWxEYyw0fp?=
 =?us-ascii?Q?IT1scEwSlT02lf2BmVKOznWI?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c135e0d-5f0d-4768-a082-08d94a3574f7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2021 21:46:10.9101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wfwPb4P/l3gWP540tVbgJ/TXCmWqPlgPTylmLDtWx1FDZBELRQdSULNsoRs6fLwgHhhbmFobb89bl1jgPTl/Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7325
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to propagate the extack argument for
dpaa2_switch_port_bridge_join to use it in a future patch, and it looks
like there is already an error message there which is currently printed
to the console. Move it over netlink so it is properly transmitted to
user space.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v2->v3: patch is new
v3->v4: none

 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index f3d12d0714fb..62d322ebf1f2 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -1890,7 +1890,8 @@ static int dpaa2_switch_port_attr_set_event(struct net_device *netdev,
 }
 
 static int dpaa2_switch_port_bridge_join(struct net_device *netdev,
-					 struct net_device *upper_dev)
+					 struct net_device *upper_dev,
+					 struct netlink_ext_ack *extack)
 {
 	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
@@ -1906,8 +1907,8 @@ static int dpaa2_switch_port_bridge_join(struct net_device *netdev,
 
 		other_port_priv = netdev_priv(other_dev);
 		if (other_port_priv->ethsw_data != port_priv->ethsw_data) {
-			netdev_err(netdev,
-				   "Interface from a different DPSW is in the bridge already!\n");
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Interface from a different DPSW is in the bridge already");
 			return -EINVAL;
 		}
 	}
@@ -2067,7 +2068,9 @@ static int dpaa2_switch_port_netdevice_event(struct notifier_block *nb,
 		upper_dev = info->upper_dev;
 		if (netif_is_bridge_master(upper_dev)) {
 			if (info->linking)
-				err = dpaa2_switch_port_bridge_join(netdev, upper_dev);
+				err = dpaa2_switch_port_bridge_join(netdev,
+								    upper_dev,
+								    extack);
 			else
 				err = dpaa2_switch_port_bridge_leave(netdev);
 		}
-- 
2.25.1

