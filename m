Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A99310B8D
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 14:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhBENIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 08:08:14 -0500
Received: from mail-eopbgr50065.outbound.protection.outlook.com ([40.107.5.65]:47758
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232250AbhBENFP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 08:05:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KnzTdPjJTxODIpzBf4aBZThXNCSJDLhfi+Tn8DhcP8ByMKNEGwLpGDpo1fkeUYMyx+5lZPaMdTzPrdGEKuPEaAbuc+Rf9x4pvGbxHGWalTXwN3AKM8m5JFXvnHpJuMIG1GYgXQibSqV/MaLu7xOsxUf6FnHEb0xyOs2x3F2NSv6q67A0rR0BY5NNzRakjGmk6hPLePS1wwZ2kkgliLk+sZcShxsCDPD+5yJeTJFOPcM65g+Y5XAgPX8GVS9dQ3xc6UvWkY+uewr3q+cEATK/QfuarofbgB0zRg+JYh5d2tDGhJGbpFlM0dUAQGfUuWPrPJSEfk4Uh2x+a0poR+lYxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yDCG90MMChzWmWulHNdfSxFF9fCb078nXp5zBwRuJwI=;
 b=LvykAnhHO1gCuKh6RfYj/b6zv/gnaTsRMhBhhpSm7EH351zC62xyi9+37Mz7JRrYUYefRCGO0J5V4F4kHF2VVq+DkLZSRfAZiPVbx6NY5KupcdrYoUJ43qOWvGMrFzTl/V2qGamCqT4RHnG5IW1dX0pIZGAQK1B2XA47D5RjD1QqPC9ywi2jIZHoX/BcPHQ1s8vNKZ+dVC3Xu2Fyl3s78fuQtCXLTqD38b6WRzX8963juT8T6BCzH2KTPBIXRZsMCXH9FRBkthOtq84cuD88gvx8wIGE7gqPAw/aI1fnrqBPGWAqeATXfpTacCAYiYpjqgn6KTTQvwAWvyWoh0VLKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yDCG90MMChzWmWulHNdfSxFF9fCb078nXp5zBwRuJwI=;
 b=m+ToxpsLRW4nMSU6VByuhLsQmaeem5dqJNagYcMbxEl0j56Kr85Y4+uMsnpEEeuGFlzCL41gMnnh+KMBLDxvTKfhyssKHLr1r3G8EY+dVqLVmTRr1Dq0JJi7rOG+nbrC6sIBgg4lOU/65WTn0oQfqvfBC79wZxedfw0srg+e+RQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2863.eurprd04.prod.outlook.com (2603:10a6:800:af::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Fri, 5 Feb
 2021 13:03:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3825.020; Fri, 5 Feb 2021
 13:03:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH v3 net-next 04/12] net: mscc: ocelot: use ipv6 in the aggregation code
Date:   Fri,  5 Feb 2021 15:02:32 +0200
Message-Id: <20210205130240.4072854-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210205130240.4072854-1-vladimir.oltean@nxp.com>
References: <20210205130240.4072854-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.12.227.87]
X-ClientProxiedBy: VI1PR0502CA0004.eurprd05.prod.outlook.com
 (2603:10a6:803:1::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (5.12.227.87) by VI1PR0502CA0004.eurprd05.prod.outlook.com (2603:10a6:803:1::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Fri, 5 Feb 2021 13:03:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 81b9d497-b79e-490c-6f01-08d8c9d65e10
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2863:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB286308D228F8D502EA1CAF5CE0B29@VI1PR0402MB2863.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T1RExAc4xAjfVTYoVCXneyvfnzTUaHQEMf3ego1Sc27ApdV/0NZR2DXb8oiodfTu/DOI5OQZRJDIvPVIAPKugfoVNjo2QgU7RSzoaa2V0ra4Z5OVaT9eZejnFatKfqCg06WwrQWHahUqKrml/sKpfMAiw1Abu1BKTLc0qXVDX5d/hr4XzM0H9DhX1cai5gEwDIIanQQ4JaSZc8kiQwvxmJC/Y9FZ65m3wskCFmr9qgy5KNDczs5QtKvcY/5gJ+NrvOWtRiYwHz6iKWQPjM4ekyKv+JqgOelqXZOvahKyfGyXFZbmxIxMkBg9Ii2ohHuhlWOvYITo3OMI/RKzq5Y+k6GdptCXIN8wTTHIxzSV4CF/jdvdYXoTnITqP6iXtVcYnUyDIrlPQSr3+hMLNNsJ9uWh6E4VHGN+j06J8/7mp6nhWnHq90BePbyPH1bo5wSiCzBwrT8aPt6Yno2zd9fmWJcE2Lvs7rF4GyEtistL/Wr+5cGWl0C5w4GzUTcAltulPUL29Rn+K+WxxqlZQZHqrTSKM8isfIVh/KfxGdnkt5enu0hvABmaNyfm/VumYlSCZIZhzO5ZrM4I+w80qBnPJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(346002)(39850400004)(376002)(66946007)(316002)(26005)(86362001)(6486002)(83380400001)(186003)(16526019)(6506007)(69590400011)(2906002)(5660300002)(44832011)(478600001)(8936002)(6512007)(4326008)(52116002)(54906003)(2616005)(110136005)(956004)(6666004)(8676002)(66476007)(1076003)(66556008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?c3EvPnT639tWn2g2PW45/2XMNuI/CjZ2oWgVfM3YmEK9cGlVef8byhEjGMa9?=
 =?us-ascii?Q?rYiRlrOAZC66o3WufUKc9bNlQwz25sWyYMGHSYQDa++pivIMv1Iy0cfVs2Jr?=
 =?us-ascii?Q?4LmMs8RzJD1zV8X1ZiADvldWdC9nYRFHLtBDOXEPtffmtJcYQgZ7DGFiULZm?=
 =?us-ascii?Q?Lb1mlYE7A8q4MJ8bveSRrmFkP1TUwPrXvJeYcWNandyxyl83a6FarCVlyytF?=
 =?us-ascii?Q?VO/qFbTxsj6uiGCs6TUZGxk4SX4QUXTmkXUpjRkZAOcrR+zpwMVJm6CpSijx?=
 =?us-ascii?Q?YgCaEnnI8GecdCb79nnhR9yvJxfC9TITxG5vr4PQC04rwc32nUP2FnIdTml4?=
 =?us-ascii?Q?cSvkHSW7U50LVxZ8E+LUh3gP3JCsmO+MKmSOXs1MUOrzAC7N+FAn2dkAGd9H?=
 =?us-ascii?Q?oTWK8c0Uzhn2+0KVHT5P/Yrtx+vpzqGg3zHtb/wG03DH/1iMEvGeoW7Z84XO?=
 =?us-ascii?Q?/YZSzVFjiQN6h83r+V79wkhxF6Iq/18qhyajc7shC7mU8LdD23+TP4ZTXey/?=
 =?us-ascii?Q?Fwmmznv7P/osMdxJtrsnny0RMLT4OwvxWNocicNWoRTCMz78X00z/V/MW4C9?=
 =?us-ascii?Q?J+s98m5hIDvHOYUiR31EDv6tQ/FxVfCM8K0ERHbvByk5gU2EYi4PkrlMKpt6?=
 =?us-ascii?Q?Jhqse0sRYs2TEuJhOkE75eiwJezYtEDPttzssJh/Th4/wR7UWrrfhKDdAW2d?=
 =?us-ascii?Q?Ngj2EnwhwlSnYCUnBN9eXSWT0YQ0mB3lB2cuH2oolg2RdfcwgXlpGLu7wMiG?=
 =?us-ascii?Q?8haW/TLOmnUFWXbMxRbqZh118gTLVWjdZDrYTyLeOOmRCmdgmR9cTn8jBnne?=
 =?us-ascii?Q?cZ7jtrKmGU6e/JRScNsd0I2B3n3zgApix5jN0WHo7KudJG6jgWeRWAAbncGJ?=
 =?us-ascii?Q?6mCtV4A4MR/4toEJAcuvkzuv1i/6LcxvJHxSiRizP2HboiwzRJzheIPWgKOv?=
 =?us-ascii?Q?DpdBPX9LqlYNibVTb/Ko1Oe/lZpFLYlIjq1rA2CBHW92YW/AywBTdDZInAWk?=
 =?us-ascii?Q?HKPfE5UW3JIY9f7QxAwy3HI1xTL4ioHot+HmchwYoJNLDBFL4CtV2auWYDN/?=
 =?us-ascii?Q?qLS075EPxQdHPxOeTYZmEeMsvHKw+hlGmP1mg2FzYg/bnN/yw47rnJL2Xj4F?=
 =?us-ascii?Q?0e+ZNGzV964JkJVVZdjTPokzqDKU8iZ4q8dfAmrY+n8CvSStgPWTA3QHm7ER?=
 =?us-ascii?Q?gVHvhlISbub8Pk/bvoKf/2U2qoVfXRVrV8cwNNhR9QXnqFaoTKK1rNBdEBqz?=
 =?us-ascii?Q?btmDNSNNpSZfogQaZYWR0KbQjrOpWD7hGBCLio45O+q5IhNgxyaz/4NbTA3g?=
 =?us-ascii?Q?CV4BbYGlrWlmmQoBm4Zk/KWO?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81b9d497-b79e-490c-6f01-08d8c9d65e10
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 13:03:01.3193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I7vidqnx2v85RL3+9NVov3g5JGu1IPIivADXi/MAqvuu/WKw1wnj/A8OUZkhoSh1ALNzwAfJgLfdynmZnQ4qoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2863
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPv6 header information is not currently part of the entropy source for
the 4-bit aggregation code used for LAG offload, even though it could be.
The hardware reference manual says about these fields:

ANA::AGGR_CFG.AC_IP6_TCPUDP_PORT_ENA
Use IPv6 TCP/UDP port when calculating aggregation code. Configure
identically for all ports. Recommended value is 1.

ANA::AGGR_CFG.AC_IP6_FLOW_LBL_ENA
Use IPv6 flow label when calculating AC. Configure identically for all
ports. Recommended value is 1.

Integration with the xmit_hash_policy of the bonding interface is TBD.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
---
Changes in v3:
None.

Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 33274d4fc5af..ef3f10f1e54f 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1615,7 +1615,10 @@ int ocelot_init(struct ocelot *ocelot)
 	ocelot_write(ocelot, ANA_AGGR_CFG_AC_SMAC_ENA |
 			     ANA_AGGR_CFG_AC_DMAC_ENA |
 			     ANA_AGGR_CFG_AC_IP4_SIPDIP_ENA |
-			     ANA_AGGR_CFG_AC_IP4_TCPUDP_ENA, ANA_AGGR_CFG);
+			     ANA_AGGR_CFG_AC_IP4_TCPUDP_ENA |
+			     ANA_AGGR_CFG_AC_IP6_FLOW_LBL_ENA |
+			     ANA_AGGR_CFG_AC_IP6_TCPUDP_ENA,
+			     ANA_AGGR_CFG);
 
 	/* Set MAC age time to default value. The entry is aged after
 	 * 2*AGE_PERIOD
-- 
2.25.1

