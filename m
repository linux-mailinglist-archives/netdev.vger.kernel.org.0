Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 511C3522169
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 18:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345374AbiEJQmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 12:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345278AbiEJQkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 12:40:41 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2079.outbound.protection.outlook.com [40.107.22.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A8956232
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 09:36:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NKtgcdKak5fgPHvNJk2DZCpQBONICq+xRh87koXNQOxEll1qU62IgkIHR91viR5qVjEU7bDB8hIzNPOQ9RK19kZnCtsWepXhZLUmq9Mj8y3Vh9+GSfqgW6gD1VCqb0CYsY5N9LkZV6bMi6eyC5UoMQwiWOEBJA3nS/1mjqaH2qHFIdXddkdrfBLAqjlm0HpRbgo1pZoDlAK2Y5BX0/ZLrdwo8M5dZq4zCnZy1gG68AQELxEX+ZbX4oBrDNwbWB3TbPzP2WwHfYT5AcPLDfU7oIwPy9vudx4MREOt8oCR6jA9wGUYUgdiaW6HgeuTjUqrryMjSndVlrkrEdoUd7ihaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XXkxuyFjx47M7w8HVie6d2KKVPBY7EafJK0tHtWhgQ8=;
 b=KtpCgNLfV9Ox/AtwLlsl9YKWnF+FSEWtzGiwgg6K/SrzzofqQHpuYvCcXXn90tYwlxHDYZRD8qz3L5x1V9n8Y1bnT6yvGliXHw1yJX/pWZ7E3dFhR0muWj9Uf1M/nkP3JN2joeJavCZzLysWWPgwOe2+O9WkbzpCFC4E4yR3lAVc/p6TE0Os4c7YCBVr2sr7h2smSuH3McZM7gNsLfRuv25/glyUuPlUFFUHp3VcJwera159wCIolf0OzCL/WlbxtXkwKeur35ZH0Pp5HuJ8cSDvEFpCm5QHOQnVQVdzEJpv8cXWFwVY6Dp8137NWJ+eLcKoKMecz1gnpqrCij8BxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XXkxuyFjx47M7w8HVie6d2KKVPBY7EafJK0tHtWhgQ8=;
 b=rOuKAgxJOiiJ4/lKPWGDq1CTR7wJ+iUM1EPj1WWgvTC96Fi/n2zZYNRP/HqZosh8RhAEQD17WvhHx5+3CONAze8Dkd1Yyxve0hfZBR02WReHgaArfFKkPf55jzXexDMGF1oQoT+z267TDGYbEfKFtlAoifbjpGWRP7UKNMj9jKM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB9461.eurprd04.prod.outlook.com (2603:10a6:102:2a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Tue, 10 May
 2022 16:36:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 16:36:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Michael Walle <michael@walle.cc>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: [PATCH net-next 1/2] net: enetc: manage ENETC_F_QBV in priv->active_offloads only when enabled
Date:   Tue, 10 May 2022 19:36:14 +0300
Message-Id: <20220510163615.6096-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220510163615.6096-1-vladimir.oltean@nxp.com>
References: <20220510163615.6096-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0097.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::38) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c5b143e-0014-478d-5660-08da32a33a1f
X-MS-TrafficTypeDiagnostic: PA4PR04MB9461:EE_
X-Microsoft-Antispam-PRVS: <PA4PR04MB946101CD0766877A269E46C9E0C99@PA4PR04MB9461.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tc+mly8OUQjWxLHUTCGLjFveMSUU98cm+hmMKA4mnot1Wq4+Vgrn4zGnzKxi5RraBwqj3+obv0xUaiWSvtkW/aeedxLEF+rD046qvHevUoGyWPz2QQoWH5O/ziykfTTwxZmz5f6X6CZySpJgcwwjAVw1dABoqyMSOjrhdcbj4homtiscwtsA06qN4OdT/9O/wXpHbABNDERseCetqzcAjRKf8rYdnUHomZkDlwlG060vCRqxohSRkCOm8J29uYvfb682PawBUaYmOQYhk8Svmedxuw0F5KWS3NStXuQT6U62pnf8zvQmZD03VEe7ljMgIN3kVxfcToBmPjM+Z1nqhXfk6oK6uFLG/RRbbPVe4xdNk3bOGJ5qgXpzSJwLii0Z6O6/mifWdlyiYmln+hCjVr5o3pqM/RlODin2w8puj6jhMae6yaCNHnXIrftD4+1YkjBLNfYEExXowMt4u3Ec1U3LQyEt7BUYdWIR2PsbZHigMyqPttg8Sd0UlthNGHLWE1yp+AmiSs5Ow69ykH9PluN6ha9Ba93efE/Ax9gN4sHUaB05/xbh2Y2r76Xl444gpeWwMBudVNvbcCIDqx2wjAc0Psoab4JlzR/YHumHqc7qSQMq+hhVKCfA1nSqszBg+D9J4uB3Fu6IbsSlGAJNy1LmdnJ0ODVclad5i6ZEXfMucAHwq/3vY7LWBT8y1y5HuKYMbxJxv9naXtcj3+UHBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(6666004)(6486002)(508600001)(66946007)(52116002)(8676002)(66556008)(8936002)(66476007)(6506007)(4326008)(44832011)(5660300002)(38100700002)(38350700002)(316002)(6916009)(36756003)(1076003)(2616005)(83380400001)(54906003)(186003)(6512007)(86362001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Po8CgxrBhMbJ7YYtMpstMjEjBUi3LGK+rOXubyRfDqrl3rbrun8fM4BcvtzB?=
 =?us-ascii?Q?3iE1yFpmBLS98QrZjwCS8jw7BjKRzbgh62kUQwaVCsD6BSweCVe8N9N4YXIy?=
 =?us-ascii?Q?rmXTMTH1Dbzb1vroWMmv9LWkYHpyhSBbCd5xY+3k47/onnQZQSyGUNzACjPF?=
 =?us-ascii?Q?NH0vIpPxJFuQQtXwv7sHQK8Wjg2JT6wKXiqWP0m/+Y7EEGDbzBFDhH5fdn8Z?=
 =?us-ascii?Q?RKtxnRPMNv6dMoa/QuHCDvIVjC5VvyAQK8OweeEOX2eNbUy0sfUU40IYnCi2?=
 =?us-ascii?Q?1GOBVqia5azaCyghnmDdQzE4SKcE5Ig1nS5YvWT9l8bnxW/FjROwlsa1vpkP?=
 =?us-ascii?Q?jg/8iIicFFHFn/Tn+8SlnQH7qXB5LcfSWpQ+Mo5YM9XQOuQnXXfo7iv3cuzJ?=
 =?us-ascii?Q?fR7WFzgMrvWpp3/GiU3/v5TtiJasG55DCgnJO1vurM24I3pSUEUBoZ2hiI/2?=
 =?us-ascii?Q?eUZi1Re/Ed6RP/ITMfv7mSKQykciI22TdsWv8eHUqY8QXS1lcR9cb35nUZYj?=
 =?us-ascii?Q?uX0E8zUey+mDYBd0JhVt/YQdqyJNuZiXAXFpMn5+Iv7V+mh/kGQfbdLWRMl9?=
 =?us-ascii?Q?ADqktVpaXR7BNy/ifMGes7XLH2PmYu5YTzN3gSIWg3cz4VTzm3P4vlGd+pQh?=
 =?us-ascii?Q?z1kgSEbZ4O79ZQ3Aq8U2SuseNGakrr0o7FbvQRdPYTLFeyx9xgS2e+dxPsjE?=
 =?us-ascii?Q?tHYMSAHxHgAZxBSv904rT/K3SF1i7wfcq+lEzBv6gg0utoNVSAFgbI3cHJ0n?=
 =?us-ascii?Q?q3q4ChE0PPC1YJycURcBmWqHevhxDWB5ZrzqTbRVQTIIWpwzFzXhcMD4Sh8J?=
 =?us-ascii?Q?AsWofv1m+iWw3GiiaRIHntmofK5tY4e9VCmhEvyARMv6hdD4dPOwb2TRWfQz?=
 =?us-ascii?Q?hiIojaHHujz2jo/23rSXNid+qcWpJY0g7I9UGXlBvIKyJI8cAzT6DQZLTMZ1?=
 =?us-ascii?Q?OhMvOB5ed8mKF1/956AyG2SSrSYPMO0QdSqeYJ6wWlJZIUb5LGT6moWs/Luo?=
 =?us-ascii?Q?1zsx44CHTTicqx9H2mEYm8/0D3nrijbXo9DiG816wU30Z6soq5qQYiUX95MG?=
 =?us-ascii?Q?9H8xfeP0J8gXxvJT2gmRCqjPweSjU8gH3AQ30GKAopA1SCWfIbL6A4zrItmb?=
 =?us-ascii?Q?h/+qlWMRyYA5gytGTyYVkXykNrWm4W8F89QUweLqZzQVr03ItHlEAM5RAuec?=
 =?us-ascii?Q?2EsF0T3EiypwS8Q+BaYntpi/uwlbmCDFBFfnQUwZMZQFjo++R44lgIJYuw0s?=
 =?us-ascii?Q?bOcVL/syNaZFvIEfT987/8xTvGKQYlHiXtUafCVqA2Zm+LK4UNUVHZVenWho?=
 =?us-ascii?Q?f7Xfq+UpXuDnR7UaeLcKM2ys5Q5+lFL7J17lL6qoGwj0ZcJjMIPGuGkqDbg3?=
 =?us-ascii?Q?BiQ51mtPphZnghX/wz59ZlejBJceGCPSo/XMRsHHintEilYv96VP+8fZjLg6?=
 =?us-ascii?Q?aTp2eYUj2a8qKfcJCQdcJZqCIK+6Wi00rcgLlftJmeB5hlUy+KaIvoA7GqUx?=
 =?us-ascii?Q?rzae+QExbIflD63JiF5l7Flqe5qhXB8dEGuvv8M8dROclQiQWhmO7CxomYKN?=
 =?us-ascii?Q?HJHjgXGOj91ecISNKtV9aJNrjxBW2f9waH7A8Fpccgy+7ncmpjuGSbYc8GPa?=
 =?us-ascii?Q?bndF1lVYOJCLtr7V+7DktRabuCTLspG8/aXSnRzj3bTAz7nucWFszOiLvbHC?=
 =?us-ascii?Q?SdwWneOYEckooQg87sp0LksRcuFqRC0WEpRMFa51gqt+pbYLOf76/Ve+PZBn?=
 =?us-ascii?Q?qP4FuUyuQun7quko1ecxmp7jIcp2wBs=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c5b143e-0014-478d-5660-08da32a33a1f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 16:36:26.5036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5ZqZWRRshObiqKGDtYfFPEfIzx8gn6IwDr7cFIaubQHk0IbztbwclcrytfC/q1rF+Gk6GHYpQPMetqlEG2q9/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9461
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Future work in this driver would like to look at priv->active_offloads &
ENETC_F_QBV to determine whether a tc-taprio qdisc offload was
installed, but this does not produce the intended effect.

All the other flags in priv->active_offloads are managed dynamically,
except ENETC_F_QBV which is set statically based on the probed SI capability.

This change makes priv->active_offloads & ENETC_F_QBV really track the
presence of a tc-taprio schedule on the port.

Some existing users, like the enetc_sched_speed_set() call from
phylink_mac_link_up(), are best kept using the old logic: the tc-taprio
offload does not re-trigger another link mode resolve, so the scheduler
needs to be functional from the get go, as long as Qbv is supported at
all on the port. So to preserve functionality there, look at the static
station interface capability from pf->si->hw_features instead.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c  | 6 ++----
 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 6 ++++++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index a0c75c717073..7cccdf54359f 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -777,9 +777,6 @@ static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 
 	ndev->priv_flags |= IFF_UNICAST_FLT;
 
-	if (si->hw_features & ENETC_SI_F_QBV)
-		priv->active_offloads |= ENETC_F_QBV;
-
 	if (si->hw_features & ENETC_SI_F_PSFP && !enetc_psfp_enable(priv)) {
 		priv->active_offloads |= ENETC_F_QCI;
 		ndev->features |= NETIF_F_HW_TC;
@@ -993,7 +990,8 @@ static void enetc_pl_mac_link_up(struct phylink_config *config,
 	int idx;
 
 	priv = netdev_priv(pf->si->ndev);
-	if (priv->active_offloads & ENETC_F_QBV)
+
+	if (pf->si->hw_features & ENETC_SI_F_QBV)
 		enetc_sched_speed_set(priv, speed);
 
 	if (!phylink_autoneg_inband(mode) &&
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 9182631856d5..582a663ed0ba 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -70,6 +70,9 @@ static int enetc_setup_taprio(struct net_device *ndev,
 		enetc_wr(&priv->si->hw,
 			 ENETC_QBV_PTGCR_OFFSET,
 			 tge & (~ENETC_QBV_TGE));
+
+		priv->active_offloads &= ~ENETC_F_QBV;
+
 		return 0;
 	}
 
@@ -125,6 +128,9 @@ static int enetc_setup_taprio(struct net_device *ndev,
 
 	enetc_cbd_free_data_mem(priv->si, data_size, tmp, &dma);
 
+	if (!err)
+		priv->active_offloads |= ENETC_F_QBV;
+
 	return err;
 }
 
-- 
2.25.1

