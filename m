Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1F0B6C3E82
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 00:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjCUX26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 19:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbjCUX24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 19:28:56 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2056.outbound.protection.outlook.com [40.107.105.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EEF813538;
        Tue, 21 Mar 2023 16:28:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MPfU05B0rGXJiCkq7lwgkdkCMOdyr07qbLBxDtsNMjYYglMjY8Szw7im7Z1kuPRQtGAVtKcbFBUm8CgKzws2tNj8vkG3A//6EqDGH+KySZCPxuA5qCbCkJ7i9G41HvDotcySQlx79Eo0hQ+A3sfZRDVptY9mDTcVQeILFiQFwm9APkoDqZVaaWr/7A4enBvGw5NjsodAY9dEmfwx2OS91HyeCRsrq27ZnLk8U8DgWTuZhpNtTgRsErAdYhf8YKzulBCy1wO4+vZnkAtjoqh+PVv4eafRRBU0X9fYkGAGnX0iOcNpRObtlos5NZg73fHIHQGp8h1CwQh0FKRFeLggjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JIq4o8WHLJHCTRDENDV9BYqFa4sIGoiQxsWS4hucH4A=;
 b=ZKa21tD5WcqyDedefu7+IjZBnS/OvLEMswiVG7FkMi4lGG2cB3O3f8H3Fk/Je3mcodCpftKky06HIPbuShr8tQ923yYOW49fpoEKW11etu2BszD2rd59Mikkqjh5rb3/T7+x+x4RQpLv3THtW40KNQzhsmc9VC6rUbbhuamMoz9kMmu6bvqZYTqZTmb7/wXWEzJGfKl6+xQTOE1G1wh5TdBvbIre2qEtONxdLwbZKonBp/0pKVGTGuSzHk/ZqxZTpHnAyc5juOSy9fPs4EvDGf9QwdBjsU5mWdHGQ80YX0DXm/RsdcKtg+jGSPY7VjGdn2Ca+T083q/YHlYzc0KMhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JIq4o8WHLJHCTRDENDV9BYqFa4sIGoiQxsWS4hucH4A=;
 b=h6XI/jk2HsE92inem8yGqZ401AbyS5Cj1ONZUoRuJJISA4+QpG4JdwQ+42ZosRHVRi2+S95CbDoFedq4BVLkCYz0a+L7JqckVGKjes7LySCSdM/vrMv1BoQShlEDvm7KZQEG0us8UJa+Q/qxCUtxIA4nHieoApDRY1Y13D3Xx1w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DU2PR04MB9052.eurprd04.prod.outlook.com (2603:10a6:10:2e7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 23:28:48 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 23:28:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: enetc: fix aggregate RMON counters not showing the ranges
Date:   Wed, 22 Mar 2023 01:28:31 +0200
Message-Id: <20230321232831.1200905-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0168.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::22) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DU2PR04MB9052:EE_
X-MS-Office365-Filtering-Correlation-Id: ed56d3a5-28a5-4827-ba6a-08db2a640557
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x6nZIxNGE6mHcmheNBny4k11RAnl7MZ4eckHiNPh/MUgIm5RWe4zGqOHjeUiQ0GUcbgRg9rD/t/9iKrCNfblO9K34YAyNjo8iy/sHpjdbtm/lVsSDlnlQDafFNq/2SY59PjhUpBab8Ab9F7OjhaZ+jlePF62WT+7J8s1NqG48uCimtX3yitCH/W/8Z2EcGRhmJoebHLJs/CaOGPt4rZrV5HA45iMgnCbSjrrdm5ffr37eaMvTeHshesLzifj18+uxt6s9dzLhYIi2nqUXSP2bDxwRGDiej64SiSUSI5TG5EbdYaAs0rz/IW/ba6D3J0XX8LJ+7wg69ycgLgu5afZjNprzH08HeuoWdQlw8yqDSTzNS9FhufHN12hCOQ1iU2aHYIxY7wJAQW1zQU6yyoY2Hyg3ifjwgR31KSdtDD34EsgImwq1XGzJoN2j7TMiBM/Y2flRjkyGrJUBKnD36vbTgIO0ung3LoY5j/EiJYsflETok+dnsM2SCZNmIn2ipahX5oKuhiaXd3FcVp811pDpMacu/7VWsR3Md76SpVRTqFu6AGMqmNZIy6h2y1AldmW/F1QcBSUhee2RNg6pj+dmoWQOyIhABUbpf/MLo1QfledBYhyMzAf4UWLyAV6zK/cLAxCIkWbWE3gp/itOUX/SchUu2EP/1UoOVYccFxyyh0WbHw5tLAyxcjdyp1XZ8ddtFhaUs/6O5zOGwLG/9mWFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(376002)(136003)(366004)(451199018)(26005)(6506007)(6512007)(2616005)(1076003)(6666004)(6486002)(316002)(6916009)(83380400001)(4326008)(52116002)(66476007)(66946007)(478600001)(66556008)(8676002)(54906003)(186003)(8936002)(5660300002)(44832011)(41300700001)(2906002)(38350700002)(38100700002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PRVZMlmBKBQtPbknas8ysfbBc+WUzoYV5+HCB0rhbLx4887Hd48ar30IHVUv?=
 =?us-ascii?Q?O97bbAiLookatNGjWsuxqYparoEYhXb/6ZxtDsgzNsilLvL6wzq77fyeLfKa?=
 =?us-ascii?Q?X+hptUOnN8imfAxoBWsZkY3sS+F4VsAd0kcT8MMJmg7hqMbZVDNzs0wh1DOS?=
 =?us-ascii?Q?Zji1lNfFZlZc8Ali+OZIxivqNwQQ3PgB5hZD+kczbXFoahRiqEfxckEl3o77?=
 =?us-ascii?Q?K/DHzq1uhbLzkNyQ9lrS2uYV6YzXsRZGW6RETCThNfc6uz3jxE4P80Nfn5sF?=
 =?us-ascii?Q?Lw+YpYOPIv5xDZFXlgRM9yPKlv6tgODkaCNF9fdsT2ZuiXzzhZzkhseo1aTN?=
 =?us-ascii?Q?w994B9M2wkYdohIwapX3WxXInjqyO+6rZ5bNjIDSqLAVdsfqRskC0iKqyD1e?=
 =?us-ascii?Q?Ea+JRiYwQr0qhMfCAWd0PTXCiY7msYgPfE9Z9lz8m+xbBd2JGSb0zq1I8uVq?=
 =?us-ascii?Q?YFFg1QlbwQk8Vx3ZQ+TYkhqGYMpmkTLB0A+ComhMp7y/BatBD3kI7sNxB7/P?=
 =?us-ascii?Q?ACbFyRnJ2bwU0y1JjgY6ekUb+Z60Bzs0+3TrPF6a0mRIvwWuk/so85N//lXq?=
 =?us-ascii?Q?b9G13+xcekOwreQF9VDCSzrjd2fl0nCYk+UQdV5ksj29ZAHwaNb6enCQu2BD?=
 =?us-ascii?Q?XvNuOh2LIim2XmTROVWa2O5r3ovW8JGiau5S7obPX4lDu1DYIaACewWxJMvt?=
 =?us-ascii?Q?FS29OUgqWV6zbYSOy1+GO+6rgMWJeI0DKd3HDzZCzgurdDzKdaAesRh+MXc7?=
 =?us-ascii?Q?1REMe1GYopP1Y7deDoZPLOecd8OtdpjleVBEn3GmdoJUpm2477rSxdIrsW/R?=
 =?us-ascii?Q?B9R/Ip5mZVfcykPGZKx0FRUqe3BYgmg32YqeTJ9vrNQqF7kYRoJJoAOX9y/h?=
 =?us-ascii?Q?EQciGbXpi+2zgSFCNmOh924cbS/MfxXjVd6/WtWkEgjyYVS1bij1NQ99oEhR?=
 =?us-ascii?Q?SFMywi9Q4NE3sOymAjwW2XWwke4nZYzpFw+YxyYDhf3LvUNYtJr5MoWuHXMo?=
 =?us-ascii?Q?y5Ct2BcifOPt0VCjekfgwIjiNxkakE/rAsk5C52m36SqPNRgpBtCsmtilJu+?=
 =?us-ascii?Q?S6lB8nIylE/FdfZiQT37/tcDEQhPRld4qsvJ+qJ7hWyawghLT20y2l+2LOti?=
 =?us-ascii?Q?8fPqUBkXDA/rg8B/cHL+ckzAK7T6cJbSx1HzPCvgaLg995YfBDywDAuI26ow?=
 =?us-ascii?Q?OXWQeYrn/GGj4RzMmdffOnYEgp/ZaEBgFhjDXv7g6hTKz90KshdBLJBh4DRC?=
 =?us-ascii?Q?gbohjr6FltpF2bMZVXS+RdyHCEIzVDe/lCPyXp1UOLk28sOHCHEW+JJvQ80Y?=
 =?us-ascii?Q?s64ILRz/B7Tl8GanC6F1twacqq5C+z5p9nTeuKQB46eZtfhK9yTw0u28bxKv?=
 =?us-ascii?Q?MVpKj2eRDSZHYyfWHMIYfPLvbD35SLUmJbvl78bdoX0Mc7Qzfc8arw+VHf+1?=
 =?us-ascii?Q?6aBRkxmPY8bUFYsjFS0jpQovsCZujzFXt+9/Qs5ES8iluSx3LdgbV04QQYVY?=
 =?us-ascii?Q?Qw6Zk4PWk7aZFKPJX8/KYdgrhOFQ+l35ZHVbYmMzl8xmrrYaCphgo+hKaB8C?=
 =?us-ascii?Q?5FPOJhwDXIQNo5toSFlgAJPUYggZ6HwY+u7mvvvsQ8hAvyOgJCJqr01zcJYU?=
 =?us-ascii?Q?tw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed56d3a5-28a5-4827-ba6a-08db2a640557
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 23:28:48.1226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oSOQnuAAIzITe5pgjtKReI8e8lJedcovQhYR4u0UX7mrm/oz1zqX/z+atoO3KTd34D1Tin/p8Edeo2olEJQ6uA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9052
X-Spam-Status: No, score=1.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When running "ethtool -S eno0 --groups rmon" without an explicit "--src
emac|pmac" argument, the kernel will not report
rx-rmon-etherStatsPkts64to64Octets, rx-rmon-etherStatsPkts65to127Octets,
etc. This is because on ETHTOOL_MAC_STATS_SRC_AGGREGATE, we do not
populate the "ranges" argument.

ocelot_port_get_rmon_stats() does things differently and things work
there. I had forgotten to make sure that the code is structured the same
way in both drivers, so do that now.

Fixes: cf52bd238b75 ("net: enetc: add support for MAC Merge statistics counters")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_ethtool.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index bca68edfbe9c..da9d4b310fcd 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -370,8 +370,7 @@ static const struct ethtool_rmon_hist_range enetc_rmon_ranges[] = {
 };
 
 static void enetc_rmon_stats(struct enetc_hw *hw, int mac,
-			     struct ethtool_rmon_stats *s,
-			     const struct ethtool_rmon_hist_range **ranges)
+			     struct ethtool_rmon_stats *s)
 {
 	s->undersize_pkts = enetc_port_rd(hw, ENETC_PM_RUND(mac));
 	s->oversize_pkts = enetc_port_rd(hw, ENETC_PM_ROVR(mac));
@@ -393,8 +392,6 @@ static void enetc_rmon_stats(struct enetc_hw *hw, int mac,
 	s->hist_tx[4] = enetc_port_rd(hw, ENETC_PM_T1023(mac));
 	s->hist_tx[5] = enetc_port_rd(hw, ENETC_PM_T1522(mac));
 	s->hist_tx[6] = enetc_port_rd(hw, ENETC_PM_T1523X(mac));
-
-	*ranges = enetc_rmon_ranges;
 }
 
 static void enetc_get_eth_mac_stats(struct net_device *ndev,
@@ -447,13 +444,15 @@ static void enetc_get_rmon_stats(struct net_device *ndev,
 	struct enetc_hw *hw = &priv->si->hw;
 	struct enetc_si *si = priv->si;
 
+	*ranges = enetc_rmon_ranges;
+
 	switch (rmon_stats->src) {
 	case ETHTOOL_MAC_STATS_SRC_EMAC:
-		enetc_rmon_stats(hw, 0, rmon_stats, ranges);
+		enetc_rmon_stats(hw, 0, rmon_stats);
 		break;
 	case ETHTOOL_MAC_STATS_SRC_PMAC:
 		if (si->hw_features & ENETC_SI_F_QBU)
-			enetc_rmon_stats(hw, 1, rmon_stats, ranges);
+			enetc_rmon_stats(hw, 1, rmon_stats);
 		break;
 	case ETHTOOL_MAC_STATS_SRC_AGGREGATE:
 		ethtool_aggregate_rmon_stats(ndev, rmon_stats);
-- 
2.34.1

