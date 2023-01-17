Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04E9D670E14
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 00:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjAQXwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 18:52:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjAQXvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 18:51:54 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2078.outbound.protection.outlook.com [40.107.14.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D01A4F36C
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 15:03:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SynbxAK6suQ7Y3WvXhdnE8EDZuI2sA+1+t7p7ru+L8lTlZI3+ITlIQBYY9HnWW9/E83OlGRBiE4F2dDxhO9DtDtJtus9YY3QPJT7xb9WZXwxuD0InOOhf4fvdtpUQxmBuAQhEHhMFL1t9Buee/9VjFtgmiOM5Ssuep0x71XVJHhqsfjr+6sbRGmm4xcmtdUbdQDbWgjfWgeFMoet4+qGvQbnqhtfa4BWRMswijezZD2gXWoA4ofDnaqzUR11gZOXT5wLw4V9XHC11CVy5al3qdo+aPaDsr32fkVxZ/De/Nr9W/ppmeUTMRfyAm9SEMe4MXJk99dzwqC0Km3G1bHrhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JB+vnNNoFCkRYklxnhkDBjVfALrPhc6i6XeL1QXw8h8=;
 b=Kfz9I1anSrILt5x07tugv+SsXkUxRPgZ+xKcdp2BkGwsViK4hmteSfpVe2/Q381nZxuFvrcmVTgJ8QODko4w2XEAGCodvjoqe56u7XwrF8lEAoorokggWRxv6B+1kgJoFYVfNuPACjx2tQ0sRpOL55dOhqGNeE4lQfCoZmbCgfA1mx0MrkPOW4+8QaXgqaqnsvLnMLOmk/ncp14VIz+DympSn3hVwg88/w00Zz11OA4Pwg/9DfvKwbuDNBZzQ/foXXwdT5ct4Ne2x01B5y/dgaskePYoIZnzF5BSnzU8zpL5rZxunTKT/R3vFxkrR2xdWO/zQgdNMaZ3Nwgcbed2DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JB+vnNNoFCkRYklxnhkDBjVfALrPhc6i6XeL1QXw8h8=;
 b=OQisgdDBsTPR85bTrAh6+iOi8U35/NogikIGSKShQGF2v8bppaUDbH1bGN1lWCTz4adBh8MmHaRUPEbhBLqkQ3C+WMt6mnvPZ62vKjdlmeRn57Xwb1LaMYmNnMsGZJ2FJW1mjcM3O/ZxMoaC4QNhmQtRtOrXm2VSRoFf8Nzfr1I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB6808.eurprd04.prod.outlook.com (2603:10a6:20b:109::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 23:03:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 23:03:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH net-next 02/12] net: enetc: set up RX ring indices from enetc_setup_rxbdr()
Date:   Wed, 18 Jan 2023 01:02:24 +0200
Message-Id: <20230117230234.2950873-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230117230234.2950873-1-vladimir.oltean@nxp.com>
References: <20230117230234.2950873-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P195CA0002.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e2::6) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM7PR04MB6808:EE_
X-MS-Office365-Filtering-Correlation-Id: 59961d11-f0a1-4267-941e-08daf8df010f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LjNOa6k3ldnppBX0xv75veBO5eNF83zP8AdiqNXYHGI26yE0HtscR5g2PYjZzpQDjuoer5xtLjsg2lJis3h2poC6t97jyRtfWZXYNdWrFdCVImvoiNqAlbmToDZ9AEe4My5i2llABs9YS9N7LsL7GW+OPDDvFynexv/5v5E7hno7HOkXzZmokZTn+Jl3VJrXJWTU15xlfPI4lTdpyG2yDAcr+mmJyROri5TYUiZJxF8Ne/Uytfw89OX/mvPhRVuFq30kgE+dshjgzfZDxo4ax495itxN8DW3vuG3k3Ot+WRhYUUNIXgLJX+GgvW41X0fWfa4TZSQfdAzWD3sZCclV0Ipm/dy359l3A/PTSefgFRqPVyFEFSwKjiItzpkUNusgUAY598yHYstjbyIUNZdKmqndcjRN6VIjHYBNDoyVuVjIqcH9BtT9oMMUfj6SND0wnwoLVeYGJu5JcBeBXZ8xSC97W2v8saRfmxRzwIB2mYjN02qQFQX+OtcK52/obsaxByafVjx6k8kW5LnUZXiU72Lq/3iG0t9jExCQw3STP8RGl4V9ZFSkPfDke1kXiS3ItMt5nR5nLcSqJZQUQnMBDI/tY6qNhotYz/TE3QXAWJRySg0G8qfNQoAU26yzYc4N7dILomXucgZUGhkfQFmRMqv1mBprgqLkvFnm0/U+pqg5f05vw2UzOmlxx6n/51rz4rpVuQCMcmHoQOlvAmCOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(451199015)(86362001)(36756003)(38350700002)(6512007)(8936002)(44832011)(41300700001)(5660300002)(66556008)(66476007)(8676002)(66946007)(6916009)(316002)(4326008)(2906002)(2616005)(52116002)(83380400001)(38100700002)(186003)(478600001)(26005)(6666004)(6506007)(1076003)(6486002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bREhd5uS524tchBGuRtHctOZgdthm0+IbR1y173IPsYrHdgUaZ6N58GZV+VJ?=
 =?us-ascii?Q?O//KNPlZAOinXdmxRiu6/1mGNonpCoXU6BI8R1ikFx/T+geSVmUJb1mZE6Ah?=
 =?us-ascii?Q?HbxJGMtTg2szJRaHHZDOFS1LE/9aUN0hRX6KNjeqdIHKZj6Uddomq9K/ungP?=
 =?us-ascii?Q?QmVER9X3TlznIX5xiYdVe3xDeXiqKd7dPCyvdOZeZ3F3cJFfReow4Z3H1Ity?=
 =?us-ascii?Q?qo/FIqCbBEhcODtgy4v+fh/LE434Ph9BhXw9GkhyDHQSiFaNo8Yr7nPxRa4K?=
 =?us-ascii?Q?P2DY0BYxTen5MBG1RVFBGAJ7BcJmd5/4ynD3buGHf5zRUjVECDmjD4xdKrbx?=
 =?us-ascii?Q?Pobb4t4Er44AUm96aBc/IaEtr/0JfyF3FxsKplxCKZyeptREUuHhYnuji/s8?=
 =?us-ascii?Q?6GQyQKs8rT0rSYVIu8sONOO5FvjmIG/JV8DAM6M2ojTlcD1a78KyWW0lOxaH?=
 =?us-ascii?Q?pQxaEbmA3rTP0d2h3KRoWYFjIP4na3eSIcibzoPZf2o6tJwmLUr2CO870RDw?=
 =?us-ascii?Q?PuYZf9dDQSU9FOLP3c/3uoeoBaHnpWqDVIMuFmYtpEkmHlj6FbXbSES6/vCs?=
 =?us-ascii?Q?24hH1aMiEDNkroUxf6IWMyZJkCIuJBMvr4zEG/igwLsr5VgUGOql5vQeWTHO?=
 =?us-ascii?Q?TGB8jtIsp4h/DrHbnCafPGwOKSQtrq7AC2KoKfJUZoYONFWaJW8JhuaJHNzZ?=
 =?us-ascii?Q?cZY0eS4FqOxPUuMNY67yrVkyZHNYl/7Jufbm2c2boZn96iXAE4H7SZPA7dK6?=
 =?us-ascii?Q?igFc/iVS25J8nkYsdlyIWqfFjuuswtNCiL5OZcifplfKkuonRDyiLuNIPRC8?=
 =?us-ascii?Q?7O9Orl7lutRagmYw2tC5Gsy5NR1lCbSh2mtqlNz0TgY+oA1vmbwUewK8K7Cr?=
 =?us-ascii?Q?cUcIug2GSmWn+gMVeWiaR802GWbvg7tITAg3ctZfSGm5eTsji5bKzhdwxTBb?=
 =?us-ascii?Q?AOlLrkIeqqvRK6SMzUr9RpsPpEhZgJ/lH0rQVXjWAuJb7L2UARq0GiAtPR8C?=
 =?us-ascii?Q?7LjqSrh97p5QkqGfL0+AQOx65htZb0J4Q71WACj2Y4oagitJO6w8hdg+b4Vl?=
 =?us-ascii?Q?qz0lXzWdAvX12CkeMHivdA5HUCnEl0WvB1K8So6upupl2DPobwmgmQ8F/T+F?=
 =?us-ascii?Q?aiQNv+I7pYCgsWrPzIat2iTIXWqRThBMoVLP4cUpiQG3S3tz8lLRk2tjFFFi?=
 =?us-ascii?Q?geHgJVZrgsa3AZAwAFQiANqFMOvR6sv/f84aA37n6jXGseYneejnOwwsq/W4?=
 =?us-ascii?Q?FykHHU17XNDuMbVGHmZhqyijtXRKO8blZrDSRHGsXWW8pVmdqWqHkEvaaGok?=
 =?us-ascii?Q?qHW3y0ZfjSzjM5sp7M35R8Lg8Wib1D3A2q+z8OWKIMtitkarC3uXW+GUQikR?=
 =?us-ascii?Q?zkvTmDfw9c8toa6tzlgMd3fV8L8k5k3cloRN2LDbqyNv9dJGIGPO2zAsg7r9?=
 =?us-ascii?Q?bUshtiC7A+OsfVQ/br0rCTfaIeR9HJcaw05Jzr1CwBNMPw2P4T1+kxg+1x3J?=
 =?us-ascii?Q?HniZ8hVXRJ/jOZya56IfMbHG4LFBV9FDt6MzERyLTARLUd8lRnX2mzRAFnaS?=
 =?us-ascii?Q?1irp+RJilZJGQp/1Cw/OmFCvmT3VSX1wZsIsML5TDixIsmEH61pPVKkFlbIg?=
 =?us-ascii?Q?5w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59961d11-f0a1-4267-941e-08daf8df010f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 23:03:10.8196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4zKRqUfrdRxV23hfXX5bgXHb1ZdR0VFmIMU+GcdYmtRSCJLqnmp0FOecXF2R6uGR506aTDKZ3tAXlyucHKwDbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6808
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is only one place which needs to set up indices in the RX ring.
Be consistent with what was done in the TX path and do this in
enetc_setup_rxbdr().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 911686df16e4..4f8c94957a8e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1832,9 +1832,6 @@ static int enetc_alloc_rxbdr(struct enetc_bdr *rxr, bool extended)
 		return err;
 	}
 
-	rxr->next_to_clean = 0;
-	rxr->next_to_use = 0;
-	rxr->next_to_alloc = 0;
 	rxr->ext_en = extended;
 
 	return 0;
@@ -1914,10 +1911,6 @@ static void enetc_free_rx_ring(struct enetc_bdr *rx_ring)
 		__free_page(rx_swbd->page);
 		rx_swbd->page = NULL;
 	}
-
-	rx_ring->next_to_clean = 0;
-	rx_ring->next_to_use = 0;
-	rx_ring->next_to_alloc = 0;
 }
 
 static void enetc_free_rxtx_rings(struct enetc_ndev_priv *priv)
@@ -2084,6 +2077,10 @@ static void enetc_setup_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring)
 	rx_ring->rcir = hw->reg + ENETC_BDR(RX, idx, ENETC_RBCIR);
 	rx_ring->idr = hw->reg + ENETC_SIRXIDR;
 
+	rx_ring->next_to_clean = 0;
+	rx_ring->next_to_use = 0;
+	rx_ring->next_to_alloc = 0;
+
 	enetc_lock_mdio();
 	enetc_refill_rx_ring(rx_ring, enetc_bd_unused(rx_ring));
 	enetc_unlock_mdio();
-- 
2.34.1

