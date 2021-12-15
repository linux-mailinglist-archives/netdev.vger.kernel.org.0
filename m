Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC0C47570A
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 11:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241836AbhLOK64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 05:58:56 -0500
Received: from mail-eopbgr150044.outbound.protection.outlook.com ([40.107.15.44]:16571
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241814AbhLOK6z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 05:58:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H4WAi+hVNwxkXrDK1JrGRyq0FbGurLS2eUZGc/4eQb1MiCVxvAGhP2aOmXDUpnm9BQHHChHYJI8nNfccSTnB2GJcll6ZZSj5RgvV8Klf9fYUxSRwxw26526wHTOeZgl8gDgz0ipbiTdD9GiPu/Dd2W7/nt5TWYqv1Gt3vn0RaXCf6ozoDpVOrVkpePoKK+h7uBuesqiyupseflScTKlCnPrbNmfufsvDH72K52iwRbhmmNXZv6XSiQRBrcys0ia1jWXLZGCMh+dhMY4qizxZ4cpaUv+lxeqSzx1ThlyZ3OL6k5wguRkOdAoy6s6CVFLj1eTofCTrHJXm0UESccimig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s6bIbaWc/prKVloFYedaOz4o9ZRUA7oLoWBncoFVamc=;
 b=n4RAFISsMyx19oq+E0BssTH/i+SBXCYZvgH7uElwCv9tBYviTnfW4koUXMQTFehF/bvS0l8UQMBj93PTB2zQePQ223WebHDQCGvEA1e5Xf5sKfGkdE+3WXsGJOhJzMkhg2p+V6KsriBU9O5/MJcj7KyfGBSIPuPaKwXbmCV8Odjs55tpexuNTwHIKTgt/e+9s+R6MeMd9XsLehjCO4h4N9gKY/HKxJ5LCcgtHPM983aZenDLuPfnAhSp2v4Xh3lEJzZDblF743nQsH7Gp6bq82vTE6qnYqNtazDIgfBK+rjJDQuUeRxrKpJRM38ygeC2mJkxpRpSGM0kLVJdrzyWVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s6bIbaWc/prKVloFYedaOz4o9ZRUA7oLoWBncoFVamc=;
 b=c+M7JoE4fuzUXFqK2wtOJ5pE6og+hlONu1U9MWi2f78cSAw4rbbv6TEK56tN/8ZDa5R0F3qD7oF7Lw3ghfUzDzRa8d7G4scPdmGwDAqcVYZwEKmiyf3Ow+zV1G7IINxiXmfx9J68xqNV3kKVHN1jy7yjEkGg5LXQtRSifNyvIqE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by AM9PR04MB8506.eurprd04.prod.outlook.com (2603:10a6:20b:431::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.14; Wed, 15 Dec
 2021 10:58:53 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::b5b4:c0ab:e6a:9ed9]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::b5b4:c0ab:e6a:9ed9%3]) with mapi id 15.20.4778.018; Wed, 15 Dec 2021
 10:58:53 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net] dpaa2-eth: fix ethtool statistics
Date:   Wed, 15 Dec 2021 12:58:31 +0200
Message-Id: <20211215105831.290070-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR07CA0016.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::29) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c64b9cfb-0452-4ac2-cd0d-08d9bfb9e23b
X-MS-TrafficTypeDiagnostic: AM9PR04MB8506:EE_
X-Microsoft-Antispam-PRVS: <AM9PR04MB85060699C5FB2FCB493A984AE0769@AM9PR04MB8506.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FHjuiAiyUEaLVolkMfHepqKyA6rnQbCR4lXUvC4HT8YYXyIH4FcTbyf485BbnzqpsHHGyhMW3QYx26j9MQWgxiQ9kzobpFi/W748qWLiO2oIMxoHlnd/EVGpYmwXfPhLd2i6YIPpGLiQmc4t3mSvpbHScc+HNHlJNsU3VnBtUhIMAtBUuVKm+81pFFHoelpmpVpmxwddZzk+GwWeDVw8McJflodIurIZJvwQFeuDneDgQzv8OshC+0wJPt3VTSQI7LMAHWpenPwLExYEfeHmFV5UtZVmGn7xRb7/m9O9FW1bV3OQUriG/FoAV+QuSwEzroQ0mUdwJatSogehp6KNXSEa3BgpK4sZf2YdYFEYQhzAJkoJLL97u/gD4qlOstsViWvigprRmo8/vfdwOK8X43hwf/LC1pDQqhIXBtqKR/836Zvdl5R9UB6ICqaDzt/xaI6F9yfIiQRaLuL4r8dDoB7ssgsw42lW1EdPuhbczpun7VHRKab1HIGXQi60jFsvN2MfVLB35KkV/t4K6VP1XcNQTMHYNci3eA0JMdrYgFx8h1QLK90Ito4G06oCB+kHova12DnO2qotxyvTmsN7Jt+zQSpDfL1hRORIhDNVhUi/eQQJRgtY2XkTY4TuT8Vbi+zDRGcpSNI8ZwZ2NkOY3MkSH2Lc/oacZECnCz6ZZsqpSsw31ZTUMM9IwecQJO9Xqyuy9CouwLps1YeE7zm5AA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(52116002)(2906002)(26005)(316002)(2616005)(6486002)(1076003)(5660300002)(6512007)(44832011)(8676002)(8936002)(6506007)(6666004)(4326008)(508600001)(66556008)(38100700002)(38350700002)(83380400001)(36756003)(66946007)(66476007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kftsV4vAa9LFdzzmIoDBrwrxYnsTjemjnzSWk41rkj+G0Ri0jPFZBq6RPzJU?=
 =?us-ascii?Q?30Eo1sVHT1+mc7aAMs4dBKpJo1NW/ZeacETOztIL2pdxBbylYF/5ufSHOukb?=
 =?us-ascii?Q?RDeT6NqZPVdYQZtsk2MnQmslCuCmCLVXNGk9eR55oBPsfnkbDKRgE34XNoFJ?=
 =?us-ascii?Q?DOXBU5PXeunfrTSd0M3sSOpTaHNIq+XH6Of6tYxPx9TRm2tNB5vGHJSaAlha?=
 =?us-ascii?Q?c0qfVv6rqQbj7TQ+/blTCCYY3f3iyO7SOeutBcwYPEL8p/34JC+F7PuRILnR?=
 =?us-ascii?Q?fPQz+8MLolzezfEbU7eVWSil9vEcZjyoIc5V2Sjtu3ZXi1nMEEFwD9R65nV3?=
 =?us-ascii?Q?PHdfe1MEEuN8CEV3khrgGs4ZttLKxoSJOnrp73U85ab+OOc/PAqSu5Ylgekh?=
 =?us-ascii?Q?3VNPUVU5FJa4Ffn/ryDrdFs0E9UCAPgFH8Aplf0wBtk2DRmU6UXmsMlZhEEq?=
 =?us-ascii?Q?JExiQdQ0UrdMQWSWektc93xemgDTYPbf1oBBMkx0nXEQwGWTwNlLXEzBnV8D?=
 =?us-ascii?Q?YFpFA7T8d/5fOun0G4/1vQ2NaNIib6i1MB/OtypWEPorGlIqiBSxp7Rgam9m?=
 =?us-ascii?Q?aI2+bl5UVcynRfV5JuZZSMR7I8GSN/zCq6dwghOvz7T0t47OWxniU20hp2Ur?=
 =?us-ascii?Q?FmREzHUpYYWdiS+vcOMaX8ZeNT8kArxUsHg1p/c4/z4RpynhP7aa0BL+v/2X?=
 =?us-ascii?Q?QoCcmzQ5YQP2QTaQ8kvO98yvBHNJ8ktzMjmDFctZ03AbiFQHHp2RFNwscvY/?=
 =?us-ascii?Q?lnQrJTmQJdVcd2ICH5+FiWlM1uA1vv8qxUAY1rbvgfwuLTudz39VSEbPV7MO?=
 =?us-ascii?Q?WGwhrLlIHLCf+PAMTdSJmC0OU8r2Po2MkP7SuNJHXTS9/esu6kFw/FRJxAOy?=
 =?us-ascii?Q?XKU+OgaWjo8+kCWV3RyS5N1MFfjMbBhrwrkj1iQVJDsfz8B9GuJtfxDPr1t/?=
 =?us-ascii?Q?m1CJf/uuf8W+Xv4t/u+rFz5ieGriRp2E8meTVRkJ6XPBOgbUZNlcbScdZR16?=
 =?us-ascii?Q?Pmf2vSmzVK5UMDE//69bw/NbJ7MwRuLWs0bTCpoU0dRltkpri/VGROVCsh16?=
 =?us-ascii?Q?l945J+o3DB9458fyvDlIQ52Tn8WMZzz1kX79O6aaUAolzZbsp3st7YUUIypq?=
 =?us-ascii?Q?wLKvA5RnPRH7EhZ46qKS2xi5siMX8lTPSAm/3oC0woSNm4c6kpjvZnvtYP3c?=
 =?us-ascii?Q?8r98OhSpkAv9GYKhkOZDrAK3uXyUmLBoNcV+GEJ3n4nfb78Ip7kTA/dViDzB?=
 =?us-ascii?Q?ySbWhG4KSfK3Mu9mZJf34Yy0VMqELel3fQIKvZ/glMj/27/ruKmj1PppSA6x?=
 =?us-ascii?Q?+IQ/fYCiVJkKfgLZ/Olfv1jnM2UuY97Wbg0rQEnkg1nikK3Fb1ncioYHAvOI?=
 =?us-ascii?Q?yOJMb0L98PKhgtZ57m01xczPNmnLRtVZgp1fkzaw8N3w9LwHCsY4mw7ZzD9d?=
 =?us-ascii?Q?zGvEsjWigxLd1RdZ+du8YqmtDt77OyjdfVKyB3rtx6dco8o/xj/7fws3H0az?=
 =?us-ascii?Q?sKuObG5zYoeF5WAnlzBR4ZYEeMvlsLNp+L9xd47SXcjVLuG+mkw7PtERMDCq?=
 =?us-ascii?Q?5Out2G4WnM7mj/OrBUtUlvhIBc1SJivRcsOGdzEL8XgjOSe5HXRgonW0O38I?=
 =?us-ascii?Q?InXSnzG4UZqm83oU54fIDsY=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c64b9cfb-0452-4ac2-cd0d-08d9bfb9e23b
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2021 10:58:53.7231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3bmsjo9MSkn4reTSra3eWD39FLSeBBhA/yNxsBt4nwA2mshdlAm2uQ6neIDA9EiV/+qH5WpUd2uT8Bs9pFP2gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8506
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unfortunately, with the blamed commit I also added a side effect in the
ethtool stats shown. Because I added two more fields in the per channel
structure without verifying if its size is used in any way, part of the
ethtool statistics were off by 2.
Fix this by not looking up the size of the structure but instead on a
fixed value kept in a macro.

Fixes: fc398bec0387 ("net: dpaa2: add adaptive interrupt coalescing")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h     | 2 ++
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 2085844227fe..e54e70ebdd05 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -388,6 +388,8 @@ struct dpaa2_eth_ch_stats {
 	__u64 bytes_per_cdan;
 };
 
+#define DPAA2_ETH_CH_STATS	7
+
 /* Maximum number of queues associated with a DPNI */
 #define DPAA2_ETH_MAX_TCS		8
 #define DPAA2_ETH_MAX_RX_QUEUES_PER_TC	16
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index adb8ce5306ee..3fdbf87dccb1 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -278,7 +278,7 @@ static void dpaa2_eth_get_ethtool_stats(struct net_device *net_dev,
 	/* Per-channel stats */
 	for (k = 0; k < priv->num_channels; k++) {
 		ch_stats = &priv->channel[k]->stats;
-		for (j = 0; j < sizeof(*ch_stats) / sizeof(__u64) - 1; j++)
+		for (j = 0; j < DPAA2_ETH_CH_STATS; j++)
 			*((__u64 *)data + i + j) += *((__u64 *)ch_stats + j);
 	}
 	i += j;
-- 
2.33.1

