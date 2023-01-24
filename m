Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C126679B99
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 15:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234436AbjAXOV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 09:21:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233840AbjAXOVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 09:21:23 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2056.outbound.protection.outlook.com [40.107.21.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7806B359F
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 06:21:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cEpnrAMct9OIyksp7J6g8drhV82zJo2H69oAnYaFdoXjqyTkPNHn4ZiAWAVQwBquX+DeEt3mWXTxHe3AQDoJCqeMOLWLt7nMqTkJ6R/X12OV5DI0E4+RvCOHexEaNZPT1gghQNhOBWhZneQ906+BiGwUgL/P9XCjKU/92c+WghpSxmDQSwjWrNlXtyAaiEpBH4JKfXlCGv1lcWqn0QUpX5v11S2P6hi0B3a4x5G1GRL77z8osJy8pMGsXoc2PLaoanrqKAfy52w8/OPwKZpYHMvnPl1jyEwP0A7Xr8oXfcsWUaf9KG95+vFSwTo1NeV0IyW4dPuduKUhSbCvNwwQpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W4jQGjoizqdtSK1mAl57Im2aS8/l3i3ap46zn2rpgF0=;
 b=c3uemUB7RhD0c47JhCwl8jrqdoARiPm4M6pp0YIo/6PjEFved66ERdCS71mIas9A0lrvpR1l3xSup0aWrAE1DnCWxfAYXb+Po/oTaWSdVAqbtNejSeoGOkIkIqaYRTCb7iON0GFz6T06ejtaWfXGT49PqBQt1FLBhO5FlIUcshOmJAMO0SI89tAojtm3V7TKQJCaVJQx/Hic6XgMrVbU4BxL1QCMjO0EbrkBzZWDYlPfhw3jxAlBvj6h1uqUrqSOyMU37tas8Z5lzYhaWdf2a3+C/3ghmAFZThROBuxvl9MgZS7hOP9HIKurr94z77aWh9b5Xuh0q52yLUWb5j9c+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W4jQGjoizqdtSK1mAl57Im2aS8/l3i3ap46zn2rpgF0=;
 b=VOs4mOp7s6V0IcWkdNnHud3WLPtjE8R6jjN2sGPKxyh87X1+f0CAwLpo0aAZUxouILE1yhoIqo4lRS/HV+P4pbADbsO4e8R9UCBPltm9GsPIvLSD6h71I64iCQOLGtRojEvuiEdSsW4/Gi0OiAKd80m+hU+1+2wFARagKySsKW8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB9638.eurprd04.prod.outlook.com (2603:10a6:102:273::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 14:21:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 14:21:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: [PATCH v2 ethtool 4/5] netlink: pass the source of statistics for port stats
Date:   Tue, 24 Jan 2023 16:20:55 +0200
Message-Id: <20230124142056.3778131-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124142056.3778131-1-vladimir.oltean@nxp.com>
References: <20230124142056.3778131-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0158.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:67::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PA4PR04MB9638:EE_
X-MS-Office365-Filtering-Correlation-Id: f0ba205f-9cc0-43e9-ae86-08dafe163f3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZMe35Qgr9zSQWXBsI48iP0ku7NChrLUzOT2M4t6vYMwcg8vYgCCxFIibTYybH9Y1qoft4HDesXg9z9nFrKfocsDQiDZ6nsvlM/4xmgARyJ6atYMJFIscLHVCbv2rnC3b4lnlfMDGIx6lAGSgAUf6bA2NkstLRZndjeBtA/MfxUtVPH42NUWH3bhsA8o34AlFaK5pA2dE2Cs0xB7SHwpNKM4Abc5Q5guT9OCEoIKa0IswbUQnCidBqsL+iQt80Ofrty+AZ1sOEzNsC4PN+nyXrtxKlkLDWwhJFua4CMP1rGtTuGkD8K/z9091T067uGk96zLskyp3EZFJ2aK1VZFJFV/zEcbjxD6U6qHvD/Y9fxSCxhsM8e4qHWPiePVmtPsoaBku33q9O7MeeVxNZhjWWHIabnwclT/StHPtMFPpODHNmWSCGfHXxQR8a06YfMDK5cRjdtN3cFPutWx3SN58xvzkIDhm1oNxQrU6QUPFJGwknl+kF77QCFZVqb7uYenCV66dExgH0tbx0zR9apg8YYwP6F4TrdcHyFEfAT590pVF4J0v/rOY6aOXeB//zTaP1IzpJutRYBFBQdQvA8O6l1ylqCYmJ+DpBUaWY5dabOLq7Z8gkNB/eJWtutJCpss3DW35zdOU2ub8Nf3SZlchh7NrcgFBYeFK65OFe8+qNJZjg3QyWtUqlbx+afiaDoTDociDuuFhrhNpT05aDXLyDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(396003)(366004)(39860400002)(451199015)(36756003)(41300700001)(86362001)(8936002)(5660300002)(4326008)(44832011)(2906002)(38350700002)(38100700002)(6486002)(52116002)(478600001)(66946007)(6512007)(6916009)(26005)(6506007)(186003)(8676002)(316002)(54906003)(2616005)(1076003)(66476007)(6666004)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P6Fs5G6qJZQn4wbtgmIZPtoQcqk3gltmIQD/TqIvWx8oWrQ+A7tiIhNVmnSB?=
 =?us-ascii?Q?muJ5EPmtebgxK9GvmKrx7KScNt2nuTwHz2vX1mCu9S85hz78nsV5CO2n8QtH?=
 =?us-ascii?Q?HgLyoDgCWrg2gMgxaalMR/3u+VBZF2hOlzuprmcds7vbCP+xVy/4ur6Jj1tt?=
 =?us-ascii?Q?j6RG/8bTXAu3IhMt7sbaLD4wed4sKZFEGWRkfeaMXivbuwqb6kki6+FS8KUJ?=
 =?us-ascii?Q?WAKbKi1jHYAhYTM9LqhyezkS0Par/CDFgmCchbNCVvx9iGOgMcUxtwgUFfUj?=
 =?us-ascii?Q?1GqcK3Zc1H17yIoT+DiailzvftMsap8xAfhQoXLWl6yYcWJbWw84TNKFT6VJ?=
 =?us-ascii?Q?U1keZnX0giB5kozs+LH3Fawdkr+7iY1+uk/WqTQfB+8TqJq2FOq5Rvo966OG?=
 =?us-ascii?Q?8dbDvB78ElKROWIx+vV2Ypq36C5vBPgzrXwsWb1Abi9bHrL2pJt7BRW7bghG?=
 =?us-ascii?Q?/SelOsRQvg2i6NRL72EVh23LJnMp5ILnNe1zxYo7aFwRhBAoCFYljMwQsru7?=
 =?us-ascii?Q?iX1u4FJdtwgIgQqs8yozvF/yz3M6dEHQaUK4QD/D6wCrf8qfUiXw9RZiwE8+?=
 =?us-ascii?Q?lQ5gIn7pAvIGrlLIrHOI9TUhGBR2eZkCibwf2OubN6anlrbUvm135xnhvwJD?=
 =?us-ascii?Q?p1xwEeYo8xfM0ah/VbiNnG0RF59JCRyzYTC3X7fx3F6g++NsMP3rz/HCd7pu?=
 =?us-ascii?Q?YpFjRX5dmgcJqzWmCg+bBVa3MZOskRkBp9+dpXGNTkwvewa0C83GLxCcZeG5?=
 =?us-ascii?Q?mAecckVdbbl0PekM7QJeZAwc89X4dOcfEocAy4ExxaiGEynAilc/PnwbNnJM?=
 =?us-ascii?Q?uEs2X7n8JvLix4CMZAXPb78kOjgqELXxe9k7Bur+8YgoZ9OppZh3j+HiEPZW?=
 =?us-ascii?Q?vbi0IWOkKTwd1hYUuS+9j8ihJPVOXG1G4MXQbLoktUIV5PbLiCjLjOSME20F?=
 =?us-ascii?Q?C26DK22CPK131lP6gCpSxeRJjkxi0cAYa5/9Zqyc2uEw7OZclwDI7scJpwzY?=
 =?us-ascii?Q?XOmWJY6DCMZwjhBW1sXIHW5CfFVeZ4dzT3PGK1tp6JFehyTPk1xgNF7WLwCZ?=
 =?us-ascii?Q?F9JMbvm/WEwJfhQWEy0+MPlnAweCLnaMYuC8fLOUOSELsIs2jQSC3lahVxQC?=
 =?us-ascii?Q?IpHdRlilmMd+9a7F6jJRd2LXgNJ4uH6MkVrpi2gXH+FQp4mtK4rMbIW/qIxf?=
 =?us-ascii?Q?e5PhW/WQpFf5gGuoG1u+PeYW1xifwPO2CmVc9LuZO2y3wJx/u/2x/lEaqVFI?=
 =?us-ascii?Q?OMoi7lF4V/bE6mUs5YvvTMZ6LpI6yIgXiFnOjiMvjTayWNNpcDsPp0e6R7+A?=
 =?us-ascii?Q?tq/lDxSASKw8nExtwknQcQGrVXJJUIxmnmxL7D0XwmbmabwvC6VPX3SciUdz?=
 =?us-ascii?Q?e8FCpD/8jz6qvxeRmDYpPh9/0Wy7/U11RTgljJ4+UHQuxCECPJ4NUKwQawSH?=
 =?us-ascii?Q?Kf+T2HFVuTYvthGN7A4i/7j3u68++Cdna3hk/unMRi2BsswnsTvFBqMTwaYM?=
 =?us-ascii?Q?ETemvOfgAyEoTnuU6CmXtcxIya/u5Q3LcQRN4agSiGu2VwhP031wlsuO9Nuh?=
 =?us-ascii?Q?LdcBnJTnkbslDkyvMtZMXVI3ZEAh52qz1jYZs4SFPUzb9IWmhCFjX2j6WTSk?=
 =?us-ascii?Q?+g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0ba205f-9cc0-43e9-ae86-08dafe163f3f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 14:21:13.3813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x16oNmKRuA/zW52wq7hgyDsz9EWj1erZpj01qbp4MQX4bKXBrHxz/kRqFuiDWDBSwoGg3muuMctK8Bc84Q6Vfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9638
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the ETHTOOL_STATS_SRC_AGGREGATE attribute for the following
structured port groups, to allow looking at eMAC and pMAC counters
individually:

$ ethtool -S eno2 --groups eth-mac eth-phy eth-ctrl rmon -- --src pmac

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2:
- ETHTOOL_STATS_SRC* macro names changed to ETHTOOL_MAC_STATS_SRC*

 netlink/stats.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/netlink/stats.c b/netlink/stats.c
index 9f609a4ec550..8620d8de1555 100644
--- a/netlink/stats.c
+++ b/netlink/stats.c
@@ -268,6 +268,13 @@ err_free:
 	return ret;
 }
 
+static const struct lookup_entry_u32 stats_src_values[] = {
+	{ .arg = "aggregate",	.val = ETHTOOL_MAC_STATS_SRC_AGGREGATE },
+	{ .arg = "emac",	.val = ETHTOOL_MAC_STATS_SRC_EMAC },
+	{ .arg = "pmac",	.val = ETHTOOL_MAC_STATS_SRC_PMAC },
+	{}
+};
+
 static const struct param_parser stats_params[] = {
 	{
 		.arg		= "--groups",
@@ -283,6 +290,13 @@ static const struct param_parser stats_params[] = {
 		.handler	= stats_parse_all_groups,
 		.alt_group	= 1,
 	},
+	{
+		.arg		= "--src",
+		.type		= ETHTOOL_A_STATS_SRC,
+		.handler	= nl_parse_lookup_u32,
+		.handler_data	= stats_src_values,
+		.min_argc	= 1,
+	},
 	{}
 };
 
-- 
2.34.1

