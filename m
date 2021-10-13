Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EACFB42CDC9
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbhJMW00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:26:26 -0400
Received: from mail-db8eur05on2069.outbound.protection.outlook.com ([40.107.20.69]:19889
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230434AbhJMW0Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 18:26:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=grbdgIMDJ3ugmCHlEJRxoW227tNXwN/9w/bBESKmXyajVJfSy5E3bMoLotSwTKX+Ref8kkKP36HzKDsWgArfmpoFxdKbn5Vm+ZCFmMtvvZxYl7BzdFu7/y+By8jwEFPJn1dX+75b5sG1H04c2TQZrFdHRU41ZkzRzD6Sazc3rxaw58rCa3xdY78IuVajuDaYK83RVqNF1KMffLkOrP7gEASJp8LM2Oy8QekVASpCQ5Xj3zvaPusyH0kaYvE2WxhDAvTQnHhTMu495b123pu6s/dsEZKiPEn+AJ5lrmFSOy1qEXF+KgISGH8a1LJvDlfq3zS4VqIPB+EB07g1J6CSiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kl7do2Qv+fBvZ22Y/KDeKyEOx1UeobzRRvJNw73EgHY=;
 b=aawL9SndOb5gweLP23a6wY73ifWkHwJErOXpmhbebUuj53eZmvM6yeJCUdu9ZIZqsFe6d/TtIFkAVqRTzr3CHK/2DHHEFUzdYWukPwfgTDj0mRQcGvlGCL/TAg9FLnMAbMquzey2yYg4x78FykdbBFQKp+0F6bVaOB1s6F9stjVJGP5E07h+pPdwFki7UPFWETSpLmMVErEx+eJ5GmGleGdGbYx+WESETWp4+9ts0qq3JnrcOzZJoJmGKFMeqCTXLYh6Wza1v6Pv42BmGWnpzRAFBxB5nwY7xl3gnUtK0sZy1Hrn06AmN7GfeIoU/VkDmIOUzTMu0FyciAkcQuBXbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kl7do2Qv+fBvZ22Y/KDeKyEOx1UeobzRRvJNw73EgHY=;
 b=Lp+5/jOFVh9BZNfoGTRI4E/VEsWcKqfHmnsnbLmk2yrukiZn0TfqFmWWMoewS96mqslCR9GSsplbHqW4Ed1QA7dSshkLiCRbBgX/elrYXY+yGJCSyqOQpE9VfZst7O6AZKVulJgsurc7OIfL1SKGbxVqTMBlec1M0Zzqq0Vcwck=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4816.eurprd04.prod.outlook.com (2603:10a6:803:5b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Wed, 13 Oct
 2021 22:24:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 22:24:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net-next 1/6] ARM: dts: imx6qp-prtwd3: update RGMII delays for sja1105 switch
Date:   Thu, 14 Oct 2021 01:23:08 +0300
Message-Id: <20211013222313.3767605-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211013222313.3767605-1-vladimir.oltean@nxp.com>
References: <20211013222313.3767605-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0154.eurprd05.prod.outlook.com
 (2603:10a6:207:3::32) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by AM3PR05CA0154.eurprd05.prod.outlook.com (2603:10a6:207:3::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Wed, 13 Oct 2021 22:24:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1874b378-37ef-4b29-6ac2-08d98e983297
X-MS-TrafficTypeDiagnostic: VI1PR04MB4816:
X-Microsoft-Antispam-PRVS: <VI1PR04MB481684691AE017F5D458BAD8E0B79@VI1PR04MB4816.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FmnPROKrWgtlkld8wjjbD0xlBgWdx49Sg4Q+2xv30DqonqesYge+XRxHGr419Nd6kGGLdPDuzxVUeBufM2ClTBl/pYfKRfIEWC68iBfBSPDV4i9oanzWpreo781vQx8VHWMrLotz1OZC1CEpVuLi3XutZxEDmZcStPoaDZoDJiWBTOV6atOJO2qaja5jq+MyRKUnVoK3eZuCuh8jbWK7pkLfoDFBXG72wm8B6vKzfHkhxhYSubjWeHExGxuQpQEtnmMoKKa8R8f5k3r+skXvnmXBfCV/KiFIgTl4KDY0XthzXTftLIa1HgVtXvWJ9SqZ422MRV/AzhOcyY0qbg0CxGrzdzDcm/7XzCsbnQjL1zMqbyzUtGjDYxQQ+YbnqQ5GC9d0VmrecH3w/kbK3xsXq72cfNLCUMixXE5CxPpXRi6zILJx9u2h779YbbJ9D6RVil8DJUDNLP5VgQHfr9jSmRZ35qXulEu6Yp4z6dQq1q6YpUWrCc5Ouo0jArYRqSjHsH0gWU4IyOCFY3fvwDoe6OAJcndTvTeiwvCaI4E2eaRLl+e3LXVNnHdUDB9M3v7qv4Jtd+g+OH7F/8uvTZOSS30r5BWq3gNM7K2qfPCC9AUnOEIIjAYj2mVsyVfJVQF63B2fTI8w0FWPQLrBWpIga8EwenToMR97wLeIWqZEea8iMpajK58CiGtPboaueyNy63jjSSGvHr56lWmZ2zZR+GmQl7NRNKBNZjZBD1hwJ8g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(956004)(38350700002)(1076003)(38100700002)(6666004)(2616005)(6486002)(26005)(316002)(54906003)(110136005)(2906002)(8676002)(6506007)(36756003)(66946007)(6512007)(66556008)(66476007)(8936002)(186003)(4326008)(86362001)(508600001)(44832011)(5660300002)(52116002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jx94hoRRRwp/MTZPFHLWQGzKAffMlbsfNZD2EdjH0x+V7UJSzltocCPGHyBp?=
 =?us-ascii?Q?14YH21UECUBcZGeVZejn7q2yQVobEfjq84EbqhqTY+/gMsBNYvXoyVBFvqYX?=
 =?us-ascii?Q?4tD5EbKUfWVIqu3uUQ1HCMbgLr9BQ/rSUX0pf2MhH8NmpjmgJ+/6GfbonwvJ?=
 =?us-ascii?Q?/SWHRqIGOMOSaOc2jpzwJ0/nIO+BmsIQODcauKy+QcGkypE63bTKDl/ktKnH?=
 =?us-ascii?Q?QBvT3Y4Mwx+TqFgfz+rtuf92LQGCSA6eWMDnPKjCkrfXb9B731SY4y6eevzU?=
 =?us-ascii?Q?QW0CKyzV+bxBcxiwtU72PuPSTFlMeYlWz9pG6gJ63A5I/VAoVcNZ2zbBE1+z?=
 =?us-ascii?Q?qB57A0G0a9Kk2mHpUK85SpToMSWWaqWMyY/GCXtOM4j6SwQ2TUmCNT54gr1e?=
 =?us-ascii?Q?b0MKNBTttkahZnScLB3/lU3nFmcljS3jMFEH3RgVJfEKD1Bafsfwfp4WBV7J?=
 =?us-ascii?Q?sDHFhWEiPDPtuJhETlIkkVyta83aPXRIA+wBcgfTKrrVFqpAiTHOBANWbCej?=
 =?us-ascii?Q?WnYpT2f/RSNf2qT53VTeZSCedYOoZC9czSPEFziHFVVuXUpxPs8JvpW2/Pq4?=
 =?us-ascii?Q?vBEn8MRIar3RkLZnMKA/ZLwm3IngdWklIqu9nYeG47Z2LVyH8SuAPlyZuUOS?=
 =?us-ascii?Q?Qen+yBbXncnhPdaoFA1UZvqHFdahY3XI2LgVhLS/vC/2UeBWm57Y3Bbv8/3b?=
 =?us-ascii?Q?h/2uBeGt6XbxLIhCGal/hOO0vlufKBkqz9KfJVIqLD8EJa+dm3+EVj07ixI+?=
 =?us-ascii?Q?S9WLvknqnMvmUhVvmQIQRhcKjPPMiaHjJxMkCTwXnzaRsY5zoIa+hLLohKv0?=
 =?us-ascii?Q?/d1/zU8wkeQVFCpTwXuaN06jNg7XwVEkyQlLR6d6OPax7xrZQUtl/LpF2WOv?=
 =?us-ascii?Q?1JEw/I8PEGM6IAgVyz+F4MDJ1rFtyt2W78h8GMgUrnMCjM0kz2brqbMzqZv1?=
 =?us-ascii?Q?HrJWvJnzPGqKvTC1vNasBr4faFAnNcGXNg+cn+SNkOpM76ictwxalvlHmZgW?=
 =?us-ascii?Q?Aj0ewhn74wKZOfPB+7fOB9UutB/K3FgVM9IFxsS0mGxNMYrUfEvfhEMIo0+s?=
 =?us-ascii?Q?9TF7fUnZx1mx/c+U+UOG34gXFGm9tHW8A3ngHIC9LP5+i7Vl+BKaQdD/eIbp?=
 =?us-ascii?Q?KGu3Ms4wIpAwNdD3yzel9RPCtPBG1FVUKloBkVkSYM5xL5XGQBZ94aL78QQx?=
 =?us-ascii?Q?ZLqnZb0qBvm+gLfVaxOAMVUexRJQcWaMBomNV5zJsy1sJ7zb9BFehX5iHPO0?=
 =?us-ascii?Q?MyO/3N2aTPB/grE3lZrlFhQBtN2g0UQ6MTrhLvgPn+l3b1+xO6bEr9z9y3S2?=
 =?us-ascii?Q?vUoIH5E58NCSYKt+/4xC/0Ef?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1874b378-37ef-4b29-6ac2-08d98e983297
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 22:24:18.6631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i6Whb7QV+FqEByHlYmGoiuXdUUDFF2QDgXRome9/R7qS97QucyOG5JPWC/b1NR/LULyOKPo/SgbfL/gl4QJgqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4816
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the new behavior, the sja1105 driver expects there to be explicit
RGMII delays present on the fixed-link ports, otherwise it will complain
that it falls back to legacy behavior, which is to apply RGMII delays
incorrectly derived from the phy-mode string.

In this case, the legacy behavior of the driver is to apply both RX and
TX delays. To preserve that, add explicit 2 nanosecond delays, which are
identical with what the driver used to add (a 90 degree phase shift).
The delays from the phy-mode are ignored by new kernels (it's still
RGMII as long as it's "rgmii*" something), and the explicit
{rx,tx}-internal-delay-ps properties are ignored by old kernels, so the
change works both ways.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 arch/arm/boot/dts/imx6qp-prtwd3.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qp-prtwd3.dts b/arch/arm/boot/dts/imx6qp-prtwd3.dts
index b92e0f2748a5..29dd59bfa73d 100644
--- a/arch/arm/boot/dts/imx6qp-prtwd3.dts
+++ b/arch/arm/boot/dts/imx6qp-prtwd3.dts
@@ -178,6 +178,8 @@ port@4 {
 				label = "cpu";
 				ethernet = <&fec>;
 				phy-mode = "rgmii-id";
+				rx-internal-delay-ps = <2000>;
+				tx-internal-delay-ps = <2000>;
 
 				fixed-link {
 					speed = <100>;
-- 
2.25.1

