Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5D0F3CFB56
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 15:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239234AbhGTNNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:13:20 -0400
Received: from mail-eopbgr10049.outbound.protection.outlook.com ([40.107.1.49]:24800
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238910AbhGTNGk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:06:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oQhE9haz44vfTuKffN2FsjONsZJtlPLQ/1GqZYO4y7soPTRz3ZczptQm2yCSoMCo8O5cgILNwLBvguRg23hHSMAFycT+LkldLxqMqVWt4k3vAH7yucsFdECO7G4yGyB1XT+YJfj4QTVSXBvSniffLPUGcMhEWQVTbabjKSH5EnppT49ofjEp0SQorkaSoltt0U2MDIvyXt12b+gYSUCuSNYbAXO4n39Fv+4R2O3rciBwB8rFENYYq1k0bScTrb3CnqNNhk2/EnC28/CT5XjiRb1vwe5zKvD7nzWI6qS01EQqaM7DxrK/ZwYOyRhsu34QenNs2/d231PRtJjqLcYUCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Boyt5OrRKnPgrQyEiKEtD+UeUYEPSTgYl1wxYIFcTaI=;
 b=KLkJOztKRQWmquA9eNzey592qeJ24od7QE8xgluu3hUDvq4+gFpapM+Sm+nDu6iDez6RHA+DBdZfwlqCARXsg9oPH21wtV16xhVHMkLUEEupNKUW+z2prdHSjXTzAeYdg3u7GFybf1aCAFO6I8GBBY5NocrkSuJItqYPF+IfVPwQPT+3Cw5dhj33w8TJWkQNDE1Mrko8rPxhHmFk+uSV24otgG2XbwpK36DFKGPJvrGViJ5TPebQawPMqm9xjBTbcSsGIygdGbrM3gFOeo1ZLRsTbDInCrr/mzgcd2h2EVNeUIhQ5y9IXGIPQSJdCmpNoQOPzDhF2ddOBU7BUqNdMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Boyt5OrRKnPgrQyEiKEtD+UeUYEPSTgYl1wxYIFcTaI=;
 b=md7DAA4llikoRcEubNxaqkZ2LvRgYNd4vLdnEm+Y3unPg41JRM4lD/99Xi4WgPuLSdrcSSGuiKPo0NMdxs/sL9+7yIfG+TK7d6k7/JyZj98tacEOix1MHpoYnPkDCR2iqylLHaGjvMkBq7NyMq8XOYq0nOUiyle9KUkXXU7lFXs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3551.eurprd04.prod.outlook.com (2603:10a6:803:a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Tue, 20 Jul
 2021 13:47:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 13:47:14 +0000
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
Subject: [PATCH v5 net-next 02/10] net: dpaa2-switch: refactor prechangeupper sanity checks
Date:   Tue, 20 Jul 2021 16:46:47 +0300
Message-Id: <20210720134655.892334-3-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (82.76.66.29) by PR3P191CA0002.EURP191.PROD.OUTLOOK.COM (2603:10a6:102:54::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19 via Frontend Transport; Tue, 20 Jul 2021 13:47:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cbef9b1b-d29b-43be-0af6-08d94b84e164
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3551:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3551835DBF44408F8BFCAC00E0E29@VI1PR0402MB3551.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1107;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pXAXoRKHBNjT8rGkRs8knKzhfHCxmGmqOHSqTnqCt0X7a1OmXNEwLsxcaOHyiESzwBvUB8ipvpcKkMB/dTxnA7QV0ujE+5zAAjmrmrviOWGdfsvzzdOweakFWjmF46Tu7cMsH3Is2YfIpGKMQreipxGEBK8cLtZ6+os++FPcVtKPoMSlGExycT/70pko4zgrh0mZTIJm4yZEFAdjwrJ8W+hysd/aLlLNWZcI4KvSVL/130cmQ3eDiGBDHUz3XRyZ48KfVx+Wcly+V2P48INkK61k6Q6wd9uHu4cCTwkdD6pIe/+hgSwijdGJFAcP2a/nTTsVhV5nfdPZVVm7L3ehYVAZIcYgBJInnMaF/EPgef2Zr15G2/80vtu1gM02kAkZ9tE41/FkFfXs9GgY4ND0pMBgCjXUJub55Ys74lVaHYZwPghHZx0xMbSbZSgYBKI4fuOHBNUZqeNc8TvJtQB0e2yGaayNx6L/eYJ6PdGRdJVEISw0ElEY8zDae6f86zZAb2jkasAsJuQCLelPp4OPC+PoZsJS8spPl4EVHN3S4wiqiHyrsmeT3ENGDSVnm/zl+kPcuwpm9B9MHLMwltAqrO4d2ygkxuW0x5k1dpjxrnbCdxC+HqFCClI/J9bgelDdxW2zo60wGzugMMEA3ugZzwITs/kpnC8QoXk0IT+c/303k63wdrdwJXV2f2cvr9GKXPqXdxuHTyFY/y1DWRMB0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(478600001)(44832011)(316002)(38100700002)(2616005)(956004)(5660300002)(6486002)(54906003)(1076003)(38350700002)(2906002)(66946007)(6512007)(7416002)(110136005)(86362001)(83380400001)(66476007)(8936002)(186003)(4326008)(66556008)(6506007)(6666004)(26005)(36756003)(8676002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KwtfOB5k3X3pu+8f0CEqR8//y0mOGYHp/qPXx2WTaxqtonOYo0tvjcSJ9Z6O?=
 =?us-ascii?Q?LeSv3zHbeiM9P0p6UptYW9S0OzCRrTeacc5OFbEstVmH3Ta9Mf21y4Qm21Tr?=
 =?us-ascii?Q?Lz8mBPIL6MLmWizV0EZJ8kx79Yh4ameDalvQkUtwaoE8DTskI66z6JxRXwPV?=
 =?us-ascii?Q?KBKCQh/0m7+dg2uuCuj87l6mk2vaGPXefGkoQyGXwdopkKlD4sZSDe3QY/xx?=
 =?us-ascii?Q?lod+BqkhzBOAPVLRRsbt07/NKl4RdGsqdNhiIXJPxdNrBMBTQ1ZZ++agjXCt?=
 =?us-ascii?Q?TWDp9/8/TZ8GLEN32M9Jt/zFWzCQwYFVy0fmlKgVaqumGlFvWlUM8TMOpu1j?=
 =?us-ascii?Q?tOg8D2IAx4SqpAZxTBFoBmpfCEtlxmOiWOm/ThLVPWHgUBj0OfndQXTGyJSL?=
 =?us-ascii?Q?aXta6kjkerGGvMTkUKBP8wWHCFM4uH/4Dn9cuXzqjyxRT/HS7i2Ccd6o+dZ0?=
 =?us-ascii?Q?UBqIvKx00awItcVdOKaZ/L0ZjZXUoTrpyXT8FgQ7mXqB3gyVO4bb7PM0Y/UH?=
 =?us-ascii?Q?rl4kJVjS6phdZZRPC+dIYG8NLsv2khy7iNH01nhT+nEgJh7O+TmlQTNmA8n7?=
 =?us-ascii?Q?wt2MwLP/ib93XkInI1czcLyE+mVWAY2o2Xz0HVqeI3IYfY0/rjXKajQr1IW/?=
 =?us-ascii?Q?98zLfsl7FCwhknnhXrf2u7nTnFihGpm5j8/Bxq8el3nLQQTN2Ilg2MvEixPz?=
 =?us-ascii?Q?qv1yqBaVFcdI8OV7KIVBgkdI2EtmEtgaxdIuNueerkJhGdr60EwJ/a9YLwtL?=
 =?us-ascii?Q?8CfQyBRtFNjB44MBdYL1vhTB+/mKs9tLRXvlmSIyE6C20yzcRbvMdk1TqDc+?=
 =?us-ascii?Q?yYiuI6cEJLw57x86reAjPQFHn2lWyqEV/v0TqV/2MvWMKzfL8bbBKIx5FvsP?=
 =?us-ascii?Q?DtfBJOl7ho8rzfFAW/ApR3X+WrbQFZF9pDElTTzDqSQIut7swUJeRfZgE7I9?=
 =?us-ascii?Q?IypSOrsLxZDElJ2Mj04UtTwTR1Q7Wjg9ieP+qJycPY1caDEH4uPsFdkx8rC9?=
 =?us-ascii?Q?Jdi4+cuMvdEYI6Of2kHn7yfT2WXjZNT/+7ANSquU1xZAML5SwqPZ0s+dm7nh?=
 =?us-ascii?Q?zgdimRi2WDTpnpgPkxFPTFJuVIAevNFe4T6u8qhS4eiozDtdsRUnDKgUW6ga?=
 =?us-ascii?Q?3a+vjjKHKgnxEgIdUGic9T6mzSlzBHgCEC5i9+6uaUH3aNxI4Hn7O2ex7WMO?=
 =?us-ascii?Q?xzHPJTWLMXAfbu5u00Vs9VTltSU7pkq6XQw+o7apNbdLweI1Izp/YOidZIL1?=
 =?us-ascii?Q?xs22T8XXGxthefOtepcZfKg1k/MvbBHstOCajWkutZSHppIyM3HQWRhc3/7Z?=
 =?us-ascii?Q?cxZ+YFRyZACdpMmE5ULGldlA?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbef9b1b-d29b-43be-0af6-08d94b84e164
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 13:47:14.0341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6rKLhnryeB2v+Izlj0Uofm4r8Dy3pfjtO5HQbiLLNwglD/NaIuKYC/LClgPvJSK5nY0SCkspxsqrMmVPMAZ56w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3551
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make more room for some extra code in the NETDEV_PRECHANGEUPPER handler
by moving what already exists into a dedicated function.

Cc: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
v2->v3: patch is new
v3->v4: fix build error (s/dev/netdev/)
v4->v5: none

 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 37 +++++++++++++------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 62d322ebf1f2..23798feb40b2 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -2030,6 +2030,28 @@ static int dpaa2_switch_prevent_bridging_with_8021q_upper(struct net_device *net
 	return 0;
 }
 
+static int
+dpaa2_switch_prechangeupper_sanity_checks(struct net_device *netdev,
+					  struct net_device *upper_dev,
+					  struct netlink_ext_ack *extack)
+{
+	int err;
+
+	if (!br_vlan_enabled(upper_dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot join a VLAN-unaware bridge");
+		return -EOPNOTSUPP;
+	}
+
+	err = dpaa2_switch_prevent_bridging_with_8021q_upper(netdev);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Cannot join a bridge while VLAN uppers are present");
+		return 0;
+	}
+
+	return 0;
+}
+
 static int dpaa2_switch_port_netdevice_event(struct notifier_block *nb,
 					     unsigned long event, void *ptr)
 {
@@ -2050,18 +2072,11 @@ static int dpaa2_switch_port_netdevice_event(struct notifier_block *nb,
 		if (!netif_is_bridge_master(upper_dev))
 			break;
 
-		if (!br_vlan_enabled(upper_dev)) {
-			NL_SET_ERR_MSG_MOD(extack, "Cannot join a VLAN-unaware bridge");
-			err = -EOPNOTSUPP;
-			goto out;
-		}
-
-		err = dpaa2_switch_prevent_bridging_with_8021q_upper(netdev);
-		if (err) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Cannot join a bridge while VLAN uppers are present");
+		err = dpaa2_switch_prechangeupper_sanity_checks(netdev,
+								upper_dev,
+								extack);
+		if (err)
 			goto out;
-		}
 
 		break;
 	case NETDEV_CHANGEUPPER:
-- 
2.25.1

