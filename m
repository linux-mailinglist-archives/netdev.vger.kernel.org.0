Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D4E3CFB3D
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 15:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238704AbhGTNML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:12:11 -0400
Received: from mail-eopbgr60072.outbound.protection.outlook.com ([40.107.6.72]:39553
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238795AbhGTNHI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:07:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oNZzB3C4qaL/TWDPMg4mfR/pGgDSyaPA0QK9ccH3/VMz19RnKvyFufUw+tr9RjcC3TvPM+OPHuAG0zQS6+F1XjTMZ0HkW4nA6v/B9OE0Iuhq8RWMNHHoj1iYWbGeMzxFxpZNn5G4XpFBJr0AvRInpqObaydbculvcoQ2KtjApfIhIGC53m7+agX5avDFKwxnhiVvj0Xdn1VgzLAJWZ+PzJ6q3dJw+9WUB0HVR4GxojoVevlvDgjhMNNJaUYl2VXuV7HPYWtNpn2nvxGWD3KdUbzTUD3rdqZDRB1WUxveFQvEvUwVTSU+YDniYwpU6zHYmQ3NuIY380O47Bjs6KbCSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j1v5r3VHLcLwvZ43czbjpOSp/Uy0eQgsiDZ3Eoiz908=;
 b=my6/79pgwy/TIjxItF0vLZRxh6WzyWRUaYNwUyTKPF7LXC1bJGb0los7uHA/FN2VQrOTTY7ZMVQD2HuwTfitgU9b4c51mCMHWJCL+Dfn3AITIyxuRsRmJ5goiyWdOGVUCMgbUEIZGJ5RHQMYYdME0mkV5HXeKrqeYCHIcqsyt+c41IaxqjxkQsKDJaTeOUJSgRTkfZQaxDVYew7jyEH0kSRyjk4MgvSVDQkVyGh30KXdyDnCwJmhELkY/Vqr2HTmBn3CM8voI0LoZuYPao6b49zPNZNaVOQSCY6wJ4eEw/D4lDDpD3URae1F4pA4OaAlw8Y0CIO7uFnqFPtAuvu90Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j1v5r3VHLcLwvZ43czbjpOSp/Uy0eQgsiDZ3Eoiz908=;
 b=pO+HnEJ3Uo0fflGngOwzbIwkq2gzIB7bkTBtTAXkP5C1vrDQYTILVgkFL4vz4mjGl29q7W2Xqsj5V36s5dqJ9YIKYjMgYtMxcUZw/3kNCTtDOTv4lpHAbFkSk40L+4I7odAyWemv+W+okFh6+4/qvjpY3hpJKb6H35Ho8Y9Mevw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Tue, 20 Jul
 2021 13:47:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 13:47:12 +0000
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
Subject: [PATCH v5 net-next 01/10] net: dpaa2-switch: use extack in dpaa2_switch_port_bridge_join
Date:   Tue, 20 Jul 2021 16:46:46 +0300
Message-Id: <20210720134655.892334-2-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (82.76.66.29) by PR3P191CA0002.EURP191.PROD.OUTLOOK.COM (2603:10a6:102:54::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19 via Frontend Transport; Tue, 20 Jul 2021 13:47:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72289256-7c27-4bfa-6ce3-08d94b84e08a
X-MS-TrafficTypeDiagnostic: VI1PR04MB5696:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5696112A76FE80C67886CB67E0E29@VI1PR04MB5696.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BxQAaqe2B9m24HZXqpcPMtx3RZ6gUHTn7ULEG+1dk2dbjAw90eBkFhQjgCYP2l+IEP49Ze2mZIt47Gfcphg8xWN4200uLBkzAX8kd9Kvm2ix3vP++SrUp/P5oIXCv67G1XJbVbue+PdfEO9Z9i/oD9BLqMF04BguvnuPvX/GWg2/NJT51joffDfhmNFL6oE0o51rGByK+HcJbXPRwwVuRmkob+g3674Q6ujrM/T6fTkJUM2Bas1aVrsZNAJIoGMfZg8Y8cjEXMBtEjTaJa+nkjeMsfAeDlMbkf6Rm5KiqF7SLRCoNOpRIIT3izh+bB3Ftn5eHWR9hB8q+aDQXrgz6bugvoCvNJpeOC7mmWqDKC3ZT9dJq6MNdiI8vHnS+srgsjbGtOhyWfnvDzExjm3si/a0qsqkoO7i8R59wS5+QOA2nw4fxe7xounxzOq6u/4bnQ9o8r2gd0KzrtsjUEoXVXOLQhjs26Lg/c5KgzlNOdnt/f/hva5mB/ECwF+d14YIpdWkmJxGxd2OK+0EiXwX17g28U+oVSK3A0FdU+yGbHmyNp7X6+M1NZ6+64GHzDr1dsGJ/BQ012ae/TmasiVeCRoXTpaw6Kkka65DiSDtCsnuPHWebTeWFM5U/tk7FZvDdXWSyHacwae59FoeSKmoabZzqqM2YNPsvfoUBVctkjmngwukt1Gh5dsVytViY3deMlL4/KfDTqA0UKgX65+suw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(396003)(366004)(346002)(66946007)(6486002)(66556008)(316002)(26005)(54906003)(110136005)(38350700002)(6666004)(38100700002)(8676002)(83380400001)(4326008)(66476007)(8936002)(6512007)(2616005)(186003)(5660300002)(36756003)(52116002)(956004)(478600001)(7416002)(44832011)(86362001)(1076003)(2906002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bQRUi5Uu1hR7H+OR9PTnTTKQepTOH1QiUntw9+dzONhD49JaWCgZwkQ2xil6?=
 =?us-ascii?Q?gK8uKeKxilvIOWa8mVMEPsBiLznf6PvaNP5tpuMGd7636s9h7mKZex9sLkzJ?=
 =?us-ascii?Q?l7UnFcOF3MS577xBeoI96JwDhbrqTcquEGnFRfDiUF/7vI3j55bOEdsuYjFf?=
 =?us-ascii?Q?itpdlVs6ucns5QZydxlUKzF1y85TmCK1a5LLbUf3fQCun2KPdS/JRMGprEuz?=
 =?us-ascii?Q?wqEa+Dav8suoYKIFHw34Q0PsT7dE5WNriJnsiyQ0KxNaDvLBGYNr35tmXbms?=
 =?us-ascii?Q?PWo4+UNhngcCWnuc8S6RSrGrb9O2hKgXW7HmWV7Oegf2cDUjhc6cSbsPbtz2?=
 =?us-ascii?Q?T3kGdHc6hF8jissaowLIEACFLEP/K2GjXkOEy+ThG0/+wZYRVJJmM1ScmahJ?=
 =?us-ascii?Q?D2OFzw752UgQmZax0oom0Elaly5SS1KSz2quwGONnuozkMoM+FzHMglvizSa?=
 =?us-ascii?Q?IxebQYMWA3NY4+Nszrol9NiFpjyegAv0gAvfWWBerEfPupwnDaqxKeW/Xum/?=
 =?us-ascii?Q?aiivYcFWBwBfT7vO+eo92oa2LNVRSK6GGU1UUUKqNGqEAgoWQPiyC+tBTU2r?=
 =?us-ascii?Q?a8/S+STWy6M6igP2veFDOnEZo8+ExbEDl3hd+xdrRXZ0b3pPXQCMjHQPgQuC?=
 =?us-ascii?Q?BFN9bSYanc+rD5e/D2mJlNbVxJFsmuKN0RYDv+kUdaMpdk1rSixMkTN6tiwn?=
 =?us-ascii?Q?s1AQBpBsTIe9c+LkGqQ4Uax49mcBaqu8Or4YIpK5nPx91sAMDVm7tVL6FN1+?=
 =?us-ascii?Q?p04ZEgZwKZml9QzwKvcYp7YmqcUmvu/X+AADoF7qW5S533JPMrYrk7kOHcUG?=
 =?us-ascii?Q?/qOwBz7w9EkGLqhRJ/B+QBzd3uXqDuCtFBE0C8v8zv8dOgs7SFd+NclyGArc?=
 =?us-ascii?Q?4bg9MSZ52y44wJSurh2d1TSqk3ocVYj7Q3BN3YVzikMsMN2Mu7mdnzQ0WzzR?=
 =?us-ascii?Q?SgDVcooXprLirbrN+QVKz/pA4odCetODYKWTVk6Sl22savVzx5eFx+GvnqAO?=
 =?us-ascii?Q?KcnT2zjZ+xvMsTPZUfF04yYNUkHciSKie4I8E+zFs4JkAyBZ1qZKzrQBhix0?=
 =?us-ascii?Q?5NqdGk7wpAvFatboDv7fpIb4PiMUj1G+a0BgyMpdbwY6Hihu+M9mFK9DVbwF?=
 =?us-ascii?Q?72DSgbivF8rW63qTtoztx5lxSsUebqcSXsjm09ZNcf+UaEGu1tgVLNeLS3O5?=
 =?us-ascii?Q?I4fV2R17EvIRyfLE+zJ+IiY3sz6epzbEZa2iBT5w+fs/0jau30Y6Bb35V9/v?=
 =?us-ascii?Q?kjMJ09pDVMrVMusZe61dATEXGOSSyF97f6Vr9QRKAwsLxzy5Xi2Yyr7jUglU?=
 =?us-ascii?Q?k3Urm3NMMjvY1EQDWEtK/MnJ?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72289256-7c27-4bfa-6ce3-08d94b84e08a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 13:47:12.6169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ovIOtNm4gqKJaasJwZWCpOwAEpJyn3JPAYBpbIqN/YLqfppVBEkdO8mp3Jacf11YKI/3DrPmKET5m4burHLogg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5696
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to propagate the extack argument for
dpaa2_switch_port_bridge_join to use it in a future patch, and it looks
like there is already an error message there which is currently printed
to the console. Move it over netlink so it is properly transmitted to
user space.

Cc: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Acked-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
v2->v3: patch is new
v3->v5: none

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

