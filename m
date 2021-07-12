Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83C4C3C5F00
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 17:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235417AbhGLPY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 11:24:59 -0400
Received: from mail-eopbgr80041.outbound.protection.outlook.com ([40.107.8.41]:27617
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235314AbhGLPY6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 11:24:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HErmWjR+emzdyP0ZzMLJUrwjHlAhyOByePYuVcQgXFOFGvgWr9JzRWY8EnWvhpWBXY8mNXtTkgTA3JWQtFNvTo/J8mBDKy6tZWNjtAXD2GejgrC0e3jvZzwTserZBEPwvSr397CxGkRzwBXRlyEgLLxRoaJePDq19S9ls/B6/AUWD6SpWgAateVdhILH246nPLobhvsr4DpfnpNaas6eRxoPwgUvFjWwBID6B2QdknGbbCvPRQawdHmDqJw5jHyi76Gqf46kua+rBcQFSig0ic+WVEHGD2C02EBLs/5GSXlTlJy7JW7srdROCoVnc1p2mmW2wIC1ghEsNl7SRksbPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RcyOeW/UOtXNlODGtAoSq/H1C6jv4cdEUQKkgqqcs54=;
 b=NJE/fauLv9yhotypjytHk/wdLNK3xSkW5qEAhCu7e8yH/4mvxSyoQGX8Y/0t69CBw4heOQSrTEK0t9/+2MqI4R7D22JuiZ3sUCiJ/afLhh/njTlBPytRWDlzb5tTfPgUZQ87zEAVMzFT8o4BDy2/W1HeFhMB1Ix/EQ2SC3JB4JMcNnzlIQ5sIh7OR2n6aXEe+jAh2dXjac815TZ+pw6EvxhJts8OGcnwBDyyQOvTnWdWRNrAd3URSscpm8ZCxh5DhL6HFFBU4FKLAwo+KizYqVVZKSBcr/fftYxPpd0UvkalVIJFP0X3fZRQepIKrc0rUIZESGIrYLMPDzj+RtK9Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RcyOeW/UOtXNlODGtAoSq/H1C6jv4cdEUQKkgqqcs54=;
 b=UejPmDPQPHijyrTg9km04KTweVLElWo9Cy2wyxFFHFlNS5EWyB3TkEyHpAX3+nRoMco5XLZUzLZ7Jj76CbTFBuU6aqvHndPuVtebA2cN3MkRUrt9Bqfvj/9opq4iwiGf3M3w7pB7Nv55Aa3RBWWm6/VTsDDkWm+RiQBHXTHON9Q=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3549.eurprd04.prod.outlook.com (2603:10a6:803:8::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Mon, 12 Jul
 2021 15:22:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 15:22:07 +0000
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
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC PATCH v3 net-next 01/24] net: dpaa2-switch: use extack in dpaa2_switch_port_bridge_join
Date:   Mon, 12 Jul 2021 18:21:19 +0300
Message-Id: <20210712152142.800651-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210712152142.800651-1-vladimir.oltean@nxp.com>
References: <20210712152142.800651-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0058.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM4PR0101CA0058.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 15:22:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f0407e7-ce32-4a94-d118-08d94548cfe3
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3549:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB35499EBC29573D917AA49F2DE0159@VI1PR0402MB3549.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yHC5D+kbDrofIryKjjjwfS2hvZ4pv3SpxijIn8HbJU8xq3+nzTuuqHlWsCPVDo8lx0rq83vLhV4fVV1jKdAA2hpqWSGueADweCrbrVHdWHUk0I+l6tJFDzoKmIGwJSAoBedLrGWosmmmIBFVS4HpJRTcQn5zJA9MCBpzqa/B7BtbRIkOyP+PQo3pY0PwwbNcac5Izpf9sulCe+iv3p90XXqGZjI17UHJH9I4J2kWq0McVD1TeiAPU/Svc0aVwKqKDIkgcvGMcPtc9gmplCrvvwPrhyIj2vUOl+fYB0O0l3lFesl3F7SV52stR0g1gUD0MgwX/fB1sIzibDbDcx3gIHHRNXnOt44uYcc1vspMc06ettWQVQrYkRtF8GkP1feThjawaZApFnB2XYjlLR5r4DxjmmBt6Oj7TcA7yNhOJao1/euOlWg9a8mrYzTqRWRcZmhKXerryMLSoWHemELMyI3ljcecJ7Uj6pQWrcaf7tUpJDtVvYnOX+o2VBnCBKffgYzs3upYEojKL5q1urMjEeyDKeS6+Co/eY1RFzCShI9N5R1RxZYaKdwr/gv6anvFa4vjdrfw+SyTeN6RIMQvl0QV8MSCEkQTniMV16nVPeof5i0c5OPyA6smjux3D+b8kLfK6bfExZ88B40Mvw8eAsU0Hkn0x82qsFtbR10eAL4sQ5N9kj1YkeURXr3Yt3IFsLEvxtR4ch5E5dtHbGfnlQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39850400004)(136003)(366004)(6506007)(6666004)(478600001)(26005)(186003)(83380400001)(66476007)(66556008)(2616005)(2906002)(7416002)(6512007)(316002)(956004)(44832011)(54906003)(110136005)(4326008)(8676002)(66946007)(8936002)(86362001)(38100700002)(52116002)(1076003)(5660300002)(6486002)(38350700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vNUkXpZDKlkrYDDhylXq9ZzzZd5svOyeZXS9Pu7apafUDRyXFoJ9B4UcDIXJ?=
 =?us-ascii?Q?71YqiNQzmoKrncvM9B2c/5lCA60v9ssdn99jCktBq3XUW7/Sm8LCzITlC7tF?=
 =?us-ascii?Q?hKH288FiS4aQ9puNwPmzO68mF0MrVbtj724m78e+qj7ECdnMzEsGweum+HH6?=
 =?us-ascii?Q?JE6pUC/bt+sEBNRBoD7TnQ3aT3FAC4OGVmyeYx+SmqLM89WPvEImVM8NpLIo?=
 =?us-ascii?Q?mt5R7Ts9xdJ2lqYdL2cHdkt94Zk7v5vnhDZ/Ph9FUV0D1WqAHs8co/a5PsMN?=
 =?us-ascii?Q?yEs79GP0i8VHi5VmEWPb8cyNb/e1zgqG4ovyuVp1Gh8jClMCiNffoiQ1/FMx?=
 =?us-ascii?Q?zJdAzHZLTctmIAnxvUJFNtoNFzJnvC9H4yIpYJybaytfRS+8SX/8c5rcv9rs?=
 =?us-ascii?Q?zX4+wvKjrWrKvYdm9T0Qr4Zmb5tZY+BpYqBD9lNTL9ute/os5twzNApW2Q2c?=
 =?us-ascii?Q?yrsDV0RretsxQqy0zSBZG+L036P9PXOV+MXT/681xcWsONfdkoMaGruHa0W7?=
 =?us-ascii?Q?CUQ7oK15482yap9T2ke5mwTCAKG8XAScpnh0h0vjkG2ZUbkPH/KVpSVHnda4?=
 =?us-ascii?Q?aFdxBKJuq6eC17Z2xcQM/gAd3WMaVIVqX2lDJrfp/TR5oMK1Wgb3VHYf5Ndl?=
 =?us-ascii?Q?Vm3OK+qzFnT4bgRaj/BADlKIuvWAC1iEaKnK/s5crNlRgWEn/vryGjUGTSjr?=
 =?us-ascii?Q?AWF5RzXFJuWjwD7QZ4ZXyPTIIfqSaxron9jHefHEHaQ2L6j7o9B9uFPqRfOb?=
 =?us-ascii?Q?FhQcolMuvF5siwxOnNti+0UsgN9cdCGX6kZsxY7UvHYS/9qsYCgQ5GaCMUgb?=
 =?us-ascii?Q?ZrxZ9UYuPgqnD3tvdRnLnuLn3roEDe0i/P1DjCvUhAiuHqc17BlfxSNQabZc?=
 =?us-ascii?Q?Hs1W9rbxArmK1VybwccOrD3EjLilg2OynCq0jREAaYAbmSzqxlaTmcbzvLcX?=
 =?us-ascii?Q?lcfAq81sZqao1/XKU/pgC8u3k/0Q0XgL+yCAPM6u3uZJ4YhSWv8jVldhYoXb?=
 =?us-ascii?Q?6w4/+XMSnHCk/3Eh3DG6wcLdcaPhxjQrpzibf1hPOvn0CGmDxLGYcY/R3EPR?=
 =?us-ascii?Q?VBYgMGlKHQvydfHiYiAtebcvevP3C2qAv76jUFU3zEbvxXmx2I6ocL9FUmPq?=
 =?us-ascii?Q?8RSVZ/RrNK28rCIVYV1qbcA/YDkfl7VonR/wcHE+u7tfj+ST37DAWV8S2dqD?=
 =?us-ascii?Q?/gzFQ5k5xBZx99eW5DcDimXJRRo6YA4ZbdSFzIRvW8+5cExH3SmPKvb278H3?=
 =?us-ascii?Q?Ak1r6Lxvt1tPKPneDiASYUHWa+7WvakvsBVInag/UtAV/bAA3lMxmBfhzM5A?=
 =?us-ascii?Q?2XUS7dpu6qAr7Ls9lHCFzGCl?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f0407e7-ce32-4a94-d118-08d94548cfe3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 15:22:07.9220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WdAxJSACzb56cc179puJ1hv+YlAGAXMDPPB8qMmQZJqzd5Txl1YUrgQSWAu0Ol4HJ7QlSWTb1wrLgsg1Q7mPBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3549
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to propagate the extack argument for
dpaa2_switch_port_bridge_join to use it in a future patch, and it looks
like there is already an error message there which is currently printed
to the console. Move it over netlink so it is properly transmitted to
user space.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
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

