Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE1C666030
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 17:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234777AbjAKQSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 11:18:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236651AbjAKQRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 11:17:52 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2080.outbound.protection.outlook.com [40.107.247.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB3F1C42F;
        Wed, 11 Jan 2023 08:17:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SsIiPm2Jp5ghKaH5Fn94xuTpzq8AgQBEQUC+tBBIRoI/gwSN6TprY8V7msnne1mGmdD3Js+9kZE0txc6gRUQKseyRIuOBQpaLfZ7tobqPvssLS72jBBeGsVRHjHYsspoaghBjL8+pV2NG652UNnijc05FjYfaqNnqjQNLBISVEt99aqq4ZNsEcBsB1CgswVpQJOxFKcrgDyezpbOCkIHe7VKzYQPwWYZnX1JDFU4c3zwcgNiPYJ5SOpuD5Mtn61QBmKl4G/s8rSeXybLcIaOheqs/4TtpK7ooj4+EUAR2KvJKiudJYEtxvhMKlywYDgQWFFHyFKEfy7epvQ1GWIQwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c/kqf8kWcW1zl52Dy0FCWuLDKz4LORY+DybWP+OBPnU=;
 b=dgEe+reW9pzYKN29HpBTfS+Z5Fa7dohzEon24XckndJ4HMb+ijKSljcquwNQ8FdGUw0m7mXu6beToPlIqctiJPE8AEC5AsRnDWZdLmkPdTd7jt630+8VqsLD8Z1+o8AkbYtqrSeKtwVoHzbz27+SuCPPXpuKi3XC2jYp0Xtt7F79cjigY5HEOVFEuqD7FobixHozSRyz/zNMKSVVHhdasNF1Neli4OOK2vOpTbPMA3do/msxZWXTXkuekIJ0fL7ciIKATKgG5K9A87+RK6E4zO9YvierxHv9Xw2fQcMjBen96qYl4/BB5FsGNhdqsrz7wlGHYbxQpDc/h+rWEZNGgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c/kqf8kWcW1zl52Dy0FCWuLDKz4LORY+DybWP+OBPnU=;
 b=qHlu24tiaeJIU04J6WL4+YjkpIffkMHrd1acL+qG86PL7IRtL+MxcK/6tvVEWb3zp+PBSnSrc8X9zdP0uRJGJ+6Jkj7/ku/5/t9TipdsZPv3rBLzrz5HCRnWLMnK7YR8CbMJysoZJf4B3Nt1L0e5Q9a+HNfOLe20zjJZEDr6Ego=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8462.eurprd04.prod.outlook.com (2603:10a6:10:2cd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 16:17:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 16:17:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 net-next 09/12] net: mscc: ocelot: allow ocelot_stat_layout elements with no name
Date:   Wed, 11 Jan 2023 18:17:03 +0200
Message-Id: <20230111161706.1465242-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230111161706.1465242-1-vladimir.oltean@nxp.com>
References: <20230111161706.1465242-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0163.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:67::8) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB9PR04MB8462:EE_
X-MS-Office365-Filtering-Correlation-Id: 6103b1d3-cb68-46b6-d764-08daf3ef564b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GNSqQPWVuFae2Y1zeFxP5xaoiJBZjadqsnarwEVf9qiyVEGLguBHPp5ACk0FTj64c5wirGI7rO9483DAYx/Kcsy4jC2ld2cmUKwzsGisLJiLX2+K45Omnm5Rx11Z87QvqhnnPLwRRntDo0vz+NIpHuG3pGDk68YFcXUHkqLQZHsSr2/HJ0OH/XrDmpv8/rpZuw1Du/i6z8vfIP0DoFTDiDLDmu84bUoBkXlorsAnmk2EwmNmc1IOFddykNAGf8mBn0e3lc4h8cpvjkSv3O5ULlo5o4U0DQKoJ+y6//7B96bS8t8+eVXUvLHpDD9xvB/OtLA3LIGzq/PEba5AQygq+B7xhFmVKaH6lmrhnlj4JyJIJZ01QQ5Gd/PRFM4TgyhiaYttKkUL50YE0T2//F15fit/pVivdGoAbbqb8nEMVFXj85Ov9MYvOwze0tJr0wDcloGMT8NE3+T5HrPbkSjfvjg1SnpAGSZFp7qu1AKFwRgPqcpPUNhzbC1xuCa+cTvEDwV2nyAkI3TIsQ8bPlUjB1Yks/PSgHgIwP6Inv1CQWe53EoiGJqdzi5yB7zEo88cmLUfuM9C5S3zcRwr3o9YT8bBXKgDlu4H4TtguWKKv2itstPFZP4sdtenAx72oTOCy05FTmHClqvmBtwW0tCDPGxucv6J8ojXxRYR0h1PIMmgnQCx/1CiaKgC2xWfpGec
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199015)(36756003)(26005)(186003)(8936002)(6666004)(6512007)(6486002)(6506007)(1076003)(2616005)(66946007)(5660300002)(66476007)(66556008)(52116002)(7416002)(6916009)(316002)(4326008)(86362001)(41300700001)(38100700002)(38350700002)(478600001)(54906003)(8676002)(83380400001)(44832011)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M8H+Yoz7bQvQEMh+NSzLXF/37kcSxfCN6+CWdvDv6wO4K6eeSd3CnIh5zNOT?=
 =?us-ascii?Q?QjkU8y6v43TSUGwoVnDVY28GvhzqSEfMbDg/CLUQp/1GKSN+nmXTmLCjZQE3?=
 =?us-ascii?Q?rTOtncHFpYCwbHLDuqwkC0/zTM4OmcjaDp2GTLyYtEitFhmoAYH9Gwo01MSU?=
 =?us-ascii?Q?p154mXXQFtrg/L9u+dHZJstPBSadpYudQzLgdC91aKiIO9YQTqgEvBQXX9ej?=
 =?us-ascii?Q?peYhCkQZcmGbZFIp1gikbGkBlNnOlcGKdtfXLKQHOSNdEEWldBf4QskklQdK?=
 =?us-ascii?Q?KTUY6OWagYVZghA1N1L4qyMpWsekXF9oi48z310vKQEVi0uWgWUofc7I2vby?=
 =?us-ascii?Q?C3EJZkhuy9uUv12A9T4KpDcsssG1V/nR7O8vVfwixt64StW4Dk3ZhB7Qk604?=
 =?us-ascii?Q?1o3SunNSDIYxhQKOKLaBH3nFGkQiKqLKogTLs6DFBVVi/WT3fvOqejJpARB+?=
 =?us-ascii?Q?JB/jjYWvdiHy8s8ysayyYIvj22Vnh8fnDvjY6JGG8Rgdohjn1THBuML8V90P?=
 =?us-ascii?Q?5VzUAKhaw0K5KBMZkPwuxZw8UGz+WhBG6a/ua4ALa0bgpTiFbp+8o3aW9vfA?=
 =?us-ascii?Q?VdubDrC/NQnvQJbkpM8w7+Ch3l5+6q6C8UtXM6++Tncx9UsyMWhH5AjsEyCq?=
 =?us-ascii?Q?be/rJ6PMJFeiWBHuYiH6dovliLAOKZjOUYfBv73D1TrCM9rZw9mNnnLEioA1?=
 =?us-ascii?Q?J2OUvzVJgzQaco2ODCnJ/jr1Hot+6fBAafGEJNyRuJgL69mdC4sD+qs1FiQU?=
 =?us-ascii?Q?7/FgiWZPpsZsmmTiDbvFAqC4NFxcUn7O6dtpREAYqPvMWDx+jMBDpGN9ngmL?=
 =?us-ascii?Q?sPgn50/W5ujHGFpTDXbNtb7R57e/sO3cWby0D9qZ9ZCjHXVXhxD7qABxnh+0?=
 =?us-ascii?Q?+iNJg2fB8nv/5nsj8vdtH73kk5llmGCcQ65T7oT3yl7P+3SwKFLhd+140rzN?=
 =?us-ascii?Q?sMm3LJW/wY3UYt0TGLP3pU6bjSHbS5t8N/JTkfbFke6qHqI69bfkc0YccOj9?=
 =?us-ascii?Q?lSzB742ou4z46CJJi3vLQ1b5bXk1BTuR0kOd8EckE/b9abArSVrWPhIU2Ib6?=
 =?us-ascii?Q?2Yr41rrtmYDxuKAQMICidgETPbxs+Ra+dY5AzsA4q/f/Uego6Um7AfoHHT8d?=
 =?us-ascii?Q?AlQZDXxaczcgITVZZlo2vbLfwxhLU0LS8dSH2oUzWWUZoXEU0o/p2SljyHdI?=
 =?us-ascii?Q?qK/wMpB0g6qhtjT8AZ/70v98AVpcHP1exqU2UEehuMlp/V5B793lWL8/Q34z?=
 =?us-ascii?Q?XHZynzOZK/vTNuYtFzETnah8gc1+RLNkXl0ZYj+2Mm+r1TMRhJYbYOkkYtho?=
 =?us-ascii?Q?ipKdBPIWIuT3OR2VwXMZkMtjB3PTeZMq8KGK8x2h1BHMZnZ6o7CwgrgINiOM?=
 =?us-ascii?Q?At5wCQIp7tM4MEYthE8qLym01TitYIeTpUL0d3/Mb97Q87N3hIyVx4RqyC1J?=
 =?us-ascii?Q?Im1B8OYydMCMFoHzr3IejvXwWnQsnM/A669K/y8A1VpQiPondGLCOJIap1eM?=
 =?us-ascii?Q?6mkw49ODdXxEfK6lpekXlKcQyc11BceBIKk3cmQczo8zmXr4GsmacXaeHM7S?=
 =?us-ascii?Q?/E79ddYYk7sRSAWX974G4g601RDb8wUan2+GciAbKlQaaqtwDPUp3aBtJOQu?=
 =?us-ascii?Q?VQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6103b1d3-cb68-46b6-d764-08daf3ef564b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 16:17:29.8921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1l1BSWzUWz94R3bbKCIELIkXwnqDu6XzI2xKFPzy/iQLlMNCxavTVGAe7VAQPX+qxp4fZeXdp117UljWoeaPow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8462
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We will add support for pMAC counters and MAC merge layer counters,
which are only reported via the structured stats, and the current
ocelot_get_strings() stands in our way, because it expects that the
statistics should be placed in the data array at the same index as found
in the ocelot_stats_layout array.

That is not true. Statistics which don't have a name should not be
exported to the unstructured ethtool -S, so we need to have different
indices into the ocelot_stats_layout array (i) and into the data array
(data itself).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new (v1 was written for enetc)

 drivers/net/ethernet/mscc/ocelot_stats.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
index 1478c3b21af1..01306172b7f7 100644
--- a/drivers/net/ethernet/mscc/ocelot_stats.c
+++ b/drivers/net/ethernet/mscc/ocelot_stats.c
@@ -315,8 +315,8 @@ void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data)
 		if (ocelot_stats_layout[i].name[0] == '\0')
 			continue;
 
-		memcpy(data + i * ETH_GSTRING_LEN, ocelot_stats_layout[i].name,
-		       ETH_GSTRING_LEN);
+		memcpy(data, ocelot_stats_layout[i].name, ETH_GSTRING_LEN);
+		data += ETH_GSTRING_LEN;
 	}
 }
 EXPORT_SYMBOL(ocelot_get_strings);
-- 
2.34.1

