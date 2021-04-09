Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244DF359628
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 09:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbhDIHQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 03:16:45 -0400
Received: from mail-eopbgr80054.outbound.protection.outlook.com ([40.107.8.54]:21304
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229455AbhDIHQo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 03:16:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gytKETOLxmoyd8twnmRqFFpIOgIhWucKQHTsxmquTH9naAiXPXB+rThQ1IyaRQ4rXFdv9lpbWf/RmZayWQAYS9r6gHWJrob68DQssjpWeV1GGyPloUiupOjD25TuXVu/dIPc4nuwnd8MSwzIudBXu0i4nr2YekeX8LzVYtCFLM9aytn07IUPX3UWuXkvrqaeBvBFxg+p4fhCPTtGjzJLXDlpey1Ux1Gjp/j8F5RaNWk2iMLvFehrNxtqqeKvH0YI3dwQDxHbMItBf+sVr6xbX/ZC5wvChxRutfLBQ3zPwsI5E2yeNypn9vUERqZePrXPTZItTzbGA6+Op/Iz4v3D9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tc0b3zudrdWnQHpEexfTTJISxZwIfzWWabB9wiWEWmo=;
 b=M1gPY/2tLzC3ePJBvvJQ4AJ/wUn56Dm/BJAOg7obM4APOzgUvkghBX85rCU4J3uP9jRjAobLP5KfBqX5swrgvxKKAhYcLwy8Sc8ZPZAOV22CBcFlfDqkfOUO5Kgim9JU4EexlT92WdlkjNJ4ARJuKuwyr8kpQQiM3qrZneHwSqPQexdjDF6IBGOEBYKt1TJCI/GbI50GBKrKI/iJ/WN4Yq6mOo74oE1d7JIn0wNYuWagXWcjEJ9ZWxozSLjWDNPZgGfOkUL99/Drt+oFq3IWTjnTh/iKckQZo89c3VBKHPI0ZHO5q/BmrNQQVeMg0L/mwAPahGR4vUi2llHtX8momQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tc0b3zudrdWnQHpEexfTTJISxZwIfzWWabB9wiWEWmo=;
 b=eQdw50hjLIUEzU02YYUwqEfcLvACgszNDzrXWmuJ0HiAggbDURpkPMWBFQ1oYgo6oaeYbFIBoww2TiVvnukwkpYca6zXz//M8ERv5u+HwhIWnBzYM5wAahMwN9PS3ksfA+UqSo8G0P0CvqZ4900qm/+UEK0Q0AOUZk22UzKklkA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM9PR04MB7682.eurprd04.prod.outlook.com (2603:10a6:20b:2db::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Fri, 9 Apr
 2021 07:16:30 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::1552:3518:1306:f73]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::1552:3518:1306:f73%6]) with mapi id 15.20.4020.016; Fri, 9 Apr 2021
 07:16:30 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next] enetc: Use generic rule to map Tx rings to interrupt vectors
Date:   Fri,  9 Apr 2021 10:16:13 +0300
Message-Id: <20210409071613.28912-1-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM0PR06CA0087.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::28) To AM0PR04MB6754.eurprd04.prod.outlook.com
 (2603:10a6:208:170::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15141.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR06CA0087.eurprd06.prod.outlook.com (2603:10a6:208:fa::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Fri, 9 Apr 2021 07:16:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ee8800d-d51a-4832-f87e-08d8fb276546
X-MS-TrafficTypeDiagnostic: AM9PR04MB7682:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9PR04MB7682883D7E963C03843CF71796739@AM9PR04MB7682.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Noy8Dyi1UNmMnwLDKm6jVWCdX3LchyEguzfrc2hUWoQMLmHTCQ8SSE3k1uVKaaYy/1P0fzqWfdcAy44uuHbIlBxCIqflhiKtjPKmqqwi4qSe0Z4sBwwY9IQnX2XUdwJfs5KkZ3zNaii01ERz37F8iyuIWsFYMeTJTinL9Sk30Saopx62BMHtYeN15efDJuHyszWRn/GRphVbxPYoSyvgqnlyL3oVLnhQwYBFRoT5atOR07cYjlE1HEHb7FyWDr5c3Puor937MpAvdgy7MFrj3+cFjd9EFtA51KW+OEWY+RI7Kb2H+Qr6Had41REGVBiT63lV0MQPaaS6gNFF84+uU7b8HebvsVZIDjwtTj7rKcjIFQLPyUB1OZA3SM79eR6LiN1Sm0dy/JdtrPQXJ8A4fUjOWVf2lSZtu9FKuIb8GFQCRmZmX4eKJI2X/CA+OSsXSH3GQlhllPDHc0PyvWFU7c68BglpNqtXh3EtUZdKpezD/KQSJWFpUF9VHsKJdF0Vtgqv3RR358V/v7UL+xKMYrPc2qhK7tOVeygJqxPfiHG+5Z6mThGFBRe4BvMaVYPBSL1MWfh2mpSmckvUIvJ33Cvz//jeX6FRfMmiBEIbdnY4+Sc28u5g7uSbAMMhD+tUrPG8CiUbI6OebVvsIB6LrHox096rk0/H36uBG0SL2kr6eL8C5PU3hl+wPrfQ8UzglB4fO5dSaoOnHF+mAOxRIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(346002)(136003)(376002)(6486002)(6916009)(38350700001)(5660300002)(8676002)(4326008)(8936002)(7696005)(52116002)(16526019)(54906003)(186003)(44832011)(38100700001)(2616005)(956004)(1076003)(66946007)(478600001)(316002)(83380400001)(66476007)(86362001)(26005)(36756003)(6666004)(66556008)(2906002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?XirS+UaiP39Zk9+v4gDL/WZsANHfXllBlHm9mQx6ryCKgzSFU8kG+KCvhtcu?=
 =?us-ascii?Q?Y18r40LKEWfsNubWzTlJf0YjoYnyoJN82ZJs2BfxpdSX6WjJ4oFkhTMwXtae?=
 =?us-ascii?Q?AyL6exuhnXr1KeBY+FDtBCxpw5P7WJ53aUuk+ME+f52RbfiKLq48rLIKAUZW?=
 =?us-ascii?Q?v5DFdPZmmASRvicE6D3RHEZp2ja1vsjIFBHshwZMrwfSDGyE2lmj9sdp/NlR?=
 =?us-ascii?Q?900K3bRYIRFefZ+xSEQD0mCkOYc5Xg7lD/cjjMvrEeGE/8Jkggzn8Y3NRl1f?=
 =?us-ascii?Q?0oq5dO2k72RNCwcTZWyTjJlN3JV+KlR09tx/Q4fmIc+v+p/hd0MoIVViRCps?=
 =?us-ascii?Q?Ir5DFM7gzkr56FF3ZZR4ALQxNeaAAFVLmKnFLIyrsmDrhkZEQSeUnzVZ+FRN?=
 =?us-ascii?Q?+ZIS79Qt8q5HMbMIjzjVN/72pr13F4QYpzWIyrZ0/QcOApkD1hN0+IsEkKiv?=
 =?us-ascii?Q?qBUIkAMwdxd99WsHpLJLVEnOtMzd2s3uLAlsdeWgCp5/pH18YDHeKNH/Xeyb?=
 =?us-ascii?Q?Dizqs4IKk09PrC6Ju2tK1ETK0/KLwXqFKQ54DGXtJW/dPpWxYmqTENGRGDR4?=
 =?us-ascii?Q?SD7x8GOjve1VfnkDmaK0ne+3XHvGDth5s9z7nf/tbjLWeWORrhp18uhpqpYY?=
 =?us-ascii?Q?RN8/hNmLJRPd2H4fh0FO3qr/VvXgqT9QhUDP3Ra39oziJDrQlK/4u+uV2DEt?=
 =?us-ascii?Q?PXE81fR1p96yYcson7QxgL1xR0OATZKJmVQOoGJvy5ZqB3nqFRCaZlDAxdZt?=
 =?us-ascii?Q?qc8vPCbPvwaJqiEkeHo35RJd66LhI3SNpE+doGJ/U7uresTVpLqsynLtbRMB?=
 =?us-ascii?Q?omv+DN+QupiXC+or4Mh8btkkCJJIUSTvv/cdpTglmdtj5CVdIma2E3Z72l5P?=
 =?us-ascii?Q?eT1O93aER5JbOCnaXlbwMUlZxwMIdOikD1vMNQwPnwMzRjbfXCJAo+rPwmxq?=
 =?us-ascii?Q?eHiCrNRZucO2cvcXKK7+IDZ+VL9TCrvJL8cdbzs0hlnJL4bgFNF6oTv0rsZ4?=
 =?us-ascii?Q?JucQ0cVOUpDrbXCBzavAYdpVFbs8dnKS7aeQc2N1IZyA6q8e/Nunq2m1mDwp?=
 =?us-ascii?Q?ujtP6/ySKbTZZHAEAG3dnTx0LGIRISeMBuB9p6mnOtcCGXIBqSh7l0u/HIdV?=
 =?us-ascii?Q?iL710GH3+GEGB97mcEh9bJG+Shmtwjd5Bf6ng1qzbZkB1PO6QQb+oUVE3ln7?=
 =?us-ascii?Q?P4hSd8faasQtLGYCW/7JM6awRYunhGtZHd+/siKb4Huu0kY5Q6jnVgWNdFiQ?=
 =?us-ascii?Q?00WyolFZZsOA3rcsAqdaS8wL+NC4bUcsYFjlu9YHoiT6H8lk7kED8JTnqU8G?=
 =?us-ascii?Q?yq9xK57UDh82S9fJYRwfEsLJ?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ee8800d-d51a-4832-f87e-08d8fb276546
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 07:16:29.9488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v6EKRvzaUjvlC1BdQKBm3ckJ+dlKyp1yBkoLKo+UnPvV3CbCg9vb6tlTHXdvZm5UwSi1AphiJIBpL5YOubv7Fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7682
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Even if the current mapping is correct for the 1 CPU and 2 CPU cases
(currently enetc is included in SoCs with up to 2 CPUs only), better
use a generic rule for the mapping to cover all possible cases.
The number of CPUs is the same as the number of interrupt vectors:

Per device Tx rings -
device_tx_ring[idx], where idx = 0..n_rings_total-1

Per interrupt vector Tx rings -
int_vector[i].ring[j], where i = 0..n_int_vects-1
			     j = 0..n_rings_per_v-1

Mapping rule -
n_rings_per_v = n_rings_total / n_int_vects
for i = 0..n_int_vects - 1:
	for j = 0..n_rings_per_v - 1:
		idx = n_int_vects * j + i
		int_vector[i].ring[j] <- device_tx_ring[idx]

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 57049ae97201..1646aaa68bd1 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2343,11 +2343,7 @@ int enetc_alloc_msix(struct enetc_ndev_priv *priv)
 			int idx;
 
 			/* default tx ring mapping policy */
-			if (priv->bdr_int_num == ENETC_MAX_BDR_INT)
-				idx = 2 * j + i; /* 2 CPUs */
-			else
-				idx = j + i * v_tx_rings; /* default */
-
+			idx = priv->bdr_int_num * j + i;
 			__set_bit(idx, &v->tx_rings_map);
 			bdr = &v->tx_ring[j];
 			bdr->index = idx;
-- 
2.25.1

