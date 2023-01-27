Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E6267DA90
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 01:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232852AbjA0ARS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 19:17:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232512AbjA0ARM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 19:17:12 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on20614.outbound.protection.outlook.com [IPv6:2a01:111:f400:7d00::614])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F000F7376B
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 16:16:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a2xzoGofZA1j8lv2vszVfEm9SMXcz1bgOHZ/OSaf8E0ZZJgi9ZjVUQOApsCPeoWxtcOvdUVmgzlUIKcqKnuaIIZMoK318Fz4zp9Vas1FHlz03eXk1VehtFbYHfe/Y/M/UIolM4VAcajUHcua0f17EkeJI/RqQ+ayXM2XMw2sT/Zvp36aObg8LAZ8gpecXcfREKFNsDvrBdftIRCVKkXvUNo5rrCQ63D+MWawecow1DEodsad5f+SQRx1GpcTZuOk3QMAYrHHACZY5IJOZb7/HJqgmYFaR8d5pkG/rCcSDIjxs9yFYtpu0Qh/Sk13dQf6ZYQVaEtb47lrM7H4EBN/hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Hv0k8fZzpKFK5uc9tIAyi5kmBtjS0rDWyVnRvvNJGY=;
 b=G4Q8CjRSAcjuEUtMlsJrMgX02NmbmGoe16LcyNK1PRvJ5LIzXDUlBNe8YeIYzebuXG2psGYXKtN1tn1miZmAIB5PAQcZmQaBKl3obvlrE7ylkGX9FFO+KMKon1tabFFpvx98LKAnUPM7DupED9KGCoor/w25pdZnLzBwGEdQDtwDlN+VAxiWffdgajx8lnRNYoWFbRkXHbWKpxi7M2Mig+cM5AYXUnpBHm1DUXY1if27t8WU9mdu+aoMp42KriuCo1uV1ocwwDCOZTFR8I6yqB11gIranBuprbvwZhpi8LXsLiNv/spWHoHCSlQj69ZSW9d6jnYlJA/O3SremVurkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Hv0k8fZzpKFK5uc9tIAyi5kmBtjS0rDWyVnRvvNJGY=;
 b=AKwDs/DVjCUYvk5Q4CDDWFja5MBbBHlZhoE0udjv02GNElWEkOlFmHr7PgL0IXno6uVM61ShGEGxMN3XgiYaWQFD3ymQm/MRd7NZ+vkleQGXgF1GNQbA59J7+dLawA+UoHQVa/brSDJwOVSnxlvtZR5BearuVZFSX+P2IdBDMfE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7347.eurprd04.prod.outlook.com (2603:10a6:20b:1d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Fri, 27 Jan
 2023 00:16:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Fri, 27 Jan 2023
 00:16:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH v3 net-next 04/15] net: enetc: ensure we always have a minimum number of TXQs for stack
Date:   Fri, 27 Jan 2023 02:15:05 +0200
Message-Id: <20230127001516.592984-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230127001516.592984-1-vladimir.oltean@nxp.com>
References: <20230127001516.592984-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0057.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:23::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7347:EE_
X-MS-Office365-Filtering-Correlation-Id: 98ec0949-4047-487a-cdc3-08dafffbaba2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zdLIhRE7RuWFCurneEybpEC8kDWcsBh8cdt0sR/hMQQIH7CxjVmwpclt3KZPUggmVrZ5ugyNnWuykWAgVFqTcN4OOUL6tJdBavunCvPXzJkTPglqjfN/NWMlt2bra4HWsk1ojpPvNI3yU2F/yXFNuGbhOVcK4xZwQgU5CzGwCo/P1HPJqu5h+fSXRZA695hmj+ld6dgp+lQV8bgEAWkca1jAvH6Pemh9syZX7kP3nc1uG1iVDXBDLJoOZGAvSiNQ/jvNqBF8QeRDEQdsUF7DXdt3/EDEOqQizQyn2X80FsrvbMsNpPVndpAYYg3h8xN+/3rCfgSv8J7M7XInAe8Q37nSOsAp4o2lN5vyju8wG12jzmZhZDtZbZJu1a05156oXfpZPZr/U7xeEUpdZmGLFHkO4sHLogv9TerQBJCGMy6Qo8UA6Fx4ZwAq33N9QU3WERWCBp6YnQKhMfm50k2EfrXBvmGg6LVfIKSjbZC8+R9oVjm/5RqtKJitjpETlAlUvEu0kSlSoOOO9tS0X5b0rRtqeHqKuUwvcpamNmLOat04hxqXk7FBj+VCZxdtDSdFKrYdSC/QpN1D7jUPc1N+hKTtJEaDx4zhoDsTSYJI3WormCCPS//yn9xQeD1DGM4jwRQ4nDFSR+yeu2mcN/ldrFzRBdMggLKs5z5DeCaXakuU5WQYgIdy9Pk5ga+kMdXOjd7eRBPZRztZcmkaamZsSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39860400002)(396003)(376002)(366004)(451199018)(7416002)(44832011)(2906002)(36756003)(83380400001)(52116002)(6506007)(38100700002)(26005)(6512007)(186003)(478600001)(6486002)(2616005)(1076003)(86362001)(66946007)(66476007)(66556008)(8676002)(8936002)(4326008)(6916009)(41300700001)(54906003)(316002)(5660300002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Uk5Xh12nVhL/BbHc7CPxJVhpBsLnOYNcG1fTPva26tpcV7kq/QyDqb842z1c?=
 =?us-ascii?Q?gOb4DnYrBzJpw9MYMqTWCo5VmaD5mMnUXIiirgSQMViPc10ee5LlHb5pE4jS?=
 =?us-ascii?Q?uk6AdazX+XEmfphthZUcvaw6HuMcTAiZqrrflTH+QSyD/hToi10FrUqxt+W4?=
 =?us-ascii?Q?ViXzWYFtJBscW4xPv/81V0ghpkuMCKhQNQI+311pO2LquCxg6GsOZI1eiwYU?=
 =?us-ascii?Q?oKSHP8j2t0hErNp6cmMpPK+3DxbzcGIQWBhz0JJ0llL98lEwu2qgqqAHoofJ?=
 =?us-ascii?Q?uubedJA4DGQCBcCnWIvTBuzE2NPaQkg/L5MfRMD5eO/xWBwKslYpvWnGyxDv?=
 =?us-ascii?Q?MWdTeRmH3jQOY8Sjb3+2RLkss+r4UrbsBrLMatcAwaOj1277vTXlwc92mEWQ?=
 =?us-ascii?Q?Uhrehp5LpWqNkMMjkwF66o8eiyTmKxR0tbE3fjsbT7AU7zIouh18kJ8HMVQ+?=
 =?us-ascii?Q?Ch29mcZ8W4AFyrGMsF5FYRr47aiNghKA7vY81n3nK+Rj1KH3RF3tAULv5iDi?=
 =?us-ascii?Q?OYdxcgxalsT3TS5wLN2oMhzG8HOQl96hQpzXW/WDjpe3eOo6BSSZ2uM35gYO?=
 =?us-ascii?Q?T0yxruCmkqvNq4MvWjdfVeSz6WS+6+GF6VAnwEbk3h//gmF1x8U0lCqwsbNS?=
 =?us-ascii?Q?ZctcJI1eF3X/y5buCOeTjN9rX0hMtTaHVK8/EW3OLi6wTlBq00p2rkYH7o2l?=
 =?us-ascii?Q?G9HyTsRmIBEzqGbev8mF4qehPTVSal7fSuywODepTLurRDBNIS/hRIHBSUhh?=
 =?us-ascii?Q?UaL2Jg3tGwl0rUEziELB2wPFqAN8NL6S0fBDepfEMMNHp1Qjb/Rah4zWaVLG?=
 =?us-ascii?Q?DtyKnpBVM687pgEovsw9MZxpf5doe83sEjMPNKPjWlCXJ9ZQXZ2/OFhIr8PR?=
 =?us-ascii?Q?Jmb5XFbDi8vIhdnP4bqINKwwhqCkYHkx5TacGgyd5BUolHwtEvDxdjJGWAiA?=
 =?us-ascii?Q?+W31BJ9R6TZyvodeXTRn0FMhr1m2QMR/diO6tPd/5nPtXsk7nnk3ZjVlg2Ty?=
 =?us-ascii?Q?5WbkWXoAhjH0E3dzv61vyifnT4G1C43Au3ZFeqH+7rYLLbMEUshqwIpzpvHY?=
 =?us-ascii?Q?eqh5hRRvpuNv2fg7PhRCLYZ2dttXLKqLEVV3JsVCXVDzg8A369nRHjd9YImz?=
 =?us-ascii?Q?2p+/inshsKYi1HWq1dZCnRB5xBALoa8sZndn8m2loqebIip2zsyeLD4lpjJw?=
 =?us-ascii?Q?4I/YfRi9TbVjpKgrEZ4DPckzheW85xt1l4viJAV0tw9blKypBUq78/aLk0Fg?=
 =?us-ascii?Q?kkxoG7hBzjWCUz1rLhX7d2J1dTPDMXJHZZhWpbMKgVH1yHzkfgptq57kAe3c?=
 =?us-ascii?Q?hcUz27slu5/DtaXbaWhwSissyqu+HQ354CVgevzXaT+2f/1rlT6A8SNUVjlB?=
 =?us-ascii?Q?lqnbDA/aS6wF/ObzsPnDUY26ccqP7AoWodmYE2uXBxovwF5Jxy4II1UkVgrW?=
 =?us-ascii?Q?e9XlCuy+wHN6KJ0GSX35rFZZBVtVB5YFMIl+wHmaCtymwj3SVLlha1xI/NFI?=
 =?us-ascii?Q?zNnuSLdN8CN/SzMKDE+FbEo06pK4N67zIZL+AKhuZLIs1X4Tvk9DF18oWRN3?=
 =?us-ascii?Q?jGlm/81P4J0MmIJXXaprTM5TFFisObFozxdFADTpz9hDNbyhPlSe+syB+9zb?=
 =?us-ascii?Q?eQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98ec0949-4047-487a-cdc3-08dafffbaba2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 00:16:00.9356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oHVZVkfeBaEePl/NOLhcbOpAAIxPkBCPUkJfLFiYC/uUZGFpFnOTcimu9PsVROviS6gLRApGcR0FEYe9oD2VJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7347
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SPF_PERMERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently it can happen that an mqprio qdisc is installed with num_tc 8,
and this will reserve 8 (out of 8) TXQs for the network stack. Then we
can attach an XDP program, and this will crop 2 TXQs, leaving just 6 for
mqprio. That's not what the user requested, and we should fail it.

On the other hand, if mqprio isn't requested, we still give the 8 TXQs
to the network stack (with hashing among a single traffic class), but
then, cropping 2 TXQs for XDP is fine, because the user didn't
explicitly ask for any number of TXQs, so no expectations are violated.

Simply put, the logic that mqprio should impose a minimum number of TXQs
for the network never existed. Let's say (more or less arbitrarily) that
without mqprio, the driver expects a minimum number of TXQs equal to the
number of CPUs (on NXP LS1028A, that is either 1, or 2). And with mqprio,
mqprio gives the minimum required number of TXQs.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: move min_num_stack_tx_queues definition so it doesn't conflict
        with the ethtool mm patches I haven't submitted yet for enetc
        (and also to make use of a 4 byte hole)
v1->v2: patch is new

 drivers/net/ethernet/freescale/enetc/enetc.c | 14 ++++++++++++++
 drivers/net/ethernet/freescale/enetc/enetc.h |  3 +++
 2 files changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index e18a6c834eb4..1c0aeaa13cde 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2626,6 +2626,7 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 	if (!num_tc) {
 		netdev_reset_tc(ndev);
 		netif_set_real_num_tx_queues(ndev, num_stack_tx_queues);
+		priv->min_num_stack_tx_queues = num_possible_cpus();
 
 		/* Reset all ring priorities to 0 */
 		for (i = 0; i < priv->num_tx_rings; i++) {
@@ -2656,6 +2657,7 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 
 	/* Reset the number of netdev queues based on the TC count */
 	netif_set_real_num_tx_queues(ndev, num_tc);
+	priv->min_num_stack_tx_queues = num_tc;
 
 	netdev_set_num_tc(ndev, num_tc);
 
@@ -2702,9 +2704,20 @@ static int enetc_reconfigure_xdp_cb(struct enetc_ndev_priv *priv, void *ctx)
 static int enetc_setup_xdp_prog(struct net_device *ndev, struct bpf_prog *prog,
 				struct netlink_ext_ack *extack)
 {
+	int num_xdp_tx_queues = prog ? num_possible_cpus() : 0;
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	bool extended;
 
+	if (priv->min_num_stack_tx_queues + num_xdp_tx_queues >
+	    priv->num_tx_rings) {
+		NL_SET_ERR_MSG_FMT_MOD(extack,
+				       "Reserving %d XDP TXQs does not leave a minimum of %d TXQs for network stack (total %d available)",
+				       num_xdp_tx_queues,
+				       priv->min_num_stack_tx_queues,
+				       priv->num_tx_rings);
+		return -EBUSY;
+	}
+
 	extended = !!(priv->active_offloads & ENETC_F_RX_TSTAMP);
 
 	/* The buffer layout is changing, so we need to drain the old
@@ -2989,6 +3002,7 @@ int enetc_alloc_msix(struct enetc_ndev_priv *priv)
 	if (err)
 		goto fail;
 
+	priv->min_num_stack_tx_queues = num_possible_cpus();
 	first_xdp_tx_ring = priv->num_tx_rings - num_possible_cpus();
 	priv->xdp_tx_ring = &priv->tx_ring[first_xdp_tx_ring];
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 1fe8dfd6b6d4..e21d096c5a90 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -369,6 +369,9 @@ struct enetc_ndev_priv {
 
 	struct psfp_cap psfp_cap;
 
+	/* Minimum number of TX queues required by the network stack */
+	unsigned int min_num_stack_tx_queues;
+
 	struct phylink *phylink;
 	int ic_mode;
 	u32 tx_ictt;
-- 
2.34.1

