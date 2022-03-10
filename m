Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6894F4D4244
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 09:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240233AbiCJINu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 03:13:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239430AbiCJINs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 03:13:48 -0500
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2118.outbound.protection.outlook.com [40.107.255.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382923DDC0;
        Thu, 10 Mar 2022 00:12:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gIy6MMj9Uu36UQ1dhW8ZQhSxECy6wFxR5CgZ8+esXlWmVSRysyNQIwjPEUwDKdJ+MRs3/qRrjs4iAiILGv8FdV5iZTlCWHvCGYDfCabb9BI5PMd21iSnm8VYTf5bs+pNd1Bt0PT9kGyLg1M+P7FCy5lAopShoFpTPjaWUq6RMA8P35hJ5SjHWJESY6Z7SQEpHUwLVVU3/0X3xSIpdy8jWmrk4nro/Eul9IS6dF20gJIhfkJM8N22xs4aHcG+lM0782lb0/mjFy22GLKPXjgEnzBGa9Ckok1QpJWjBXE2HB3dzWZW1BOqNBKxxMmtyaU/IzrHwTVLJh97QkxPBJGklQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Ig3ROKFsl8gYRkCLhDER0HakxcsI2xxSsPM9iiFmYk=;
 b=f6DdkNNxoUf3gCkqdBijE85Ye2jF6PfoEZiEpxrUvjaRtvd/t++JWCBysjUfxFEwQ5CjNQfgVPAqYMx5ml832NbVZlOYVEwXTMAoi7UAYTRTXFUo2xFEEw1zMlgzkrUQ4rV5jpNQ93ZEVKe1nijfaM/G4mQ0mjPjcykoInzaxkiDGNqJlVrpf2ezG1r+mgE7gBf2OpKitO5gDptZvw25ReNlY31NJBZS5TPS35sViNxhhS+cd9KR/XSHr5K37Cswf6bCUPXTuqOkX3rzSsCMN0dt4cGQbyQQ1LBvag5lTTH6EGqZ8xq273OYTmRGXuBm6XQpGlU1U2HOnKxXj7EjnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Ig3ROKFsl8gYRkCLhDER0HakxcsI2xxSsPM9iiFmYk=;
 b=itY4gpU4ZfcdRIe/cvzR832ogguhpJLDJ2ERbRt7OEOAeYu509N1AmkJpoM2PKJPwUZrx7eKdL8Lm2XwUh8XIszFR+62cNpuA6s0iKqpzzRwvDklfJYaxLdkTJ7jiBg8gJSKLvzEoJNpmMH9OdzGulcFmnJo/6UODcIhSLK7B58=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com (2603:1096:400:26::14)
 by HK0PR06MB2084.apcprd06.prod.outlook.com (2603:1096:203:44::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Thu, 10 Mar
 2022 08:12:43 +0000
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::30ce:609e:c8e8:8a06]) by TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::30ce:609e:c8e8:8a06%4]) with mapi id 15.20.5038.027; Thu, 10 Mar 2022
 08:12:43 +0000
From:   Yihao Han <hanyihao@vivo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Yihao Han <hanyihao@vivo.com>,
        Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com
Subject: [PATCH] net: ethernet: ezchip: fix platform_get_irq.cocci warning
Date:   Thu, 10 Mar 2022 00:12:19 -0800
Message-Id: <20220310081230.13033-1-hanyihao@vivo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: HK0PR03CA0109.apcprd03.prod.outlook.com
 (2603:1096:203:b0::25) To TYZPR06MB4173.apcprd06.prod.outlook.com
 (2603:1096:400:26::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8cbaab6d-eb27-4a6a-3487-08da026dc088
X-MS-TrafficTypeDiagnostic: HK0PR06MB2084:EE_
X-Microsoft-Antispam-PRVS: <HK0PR06MB208404B9112EE15DF0013C87A20B9@HK0PR06MB2084.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ucv0KBhhz/o1Nmn9dhfnnkqTprUrdSPxE6jbAopixVfzFbeiWXV4HCUUQ8XjM3NsJQq3pC2i+c9ZwaMUO6Pv4MkAmC18Rj/yrfAPLOEnDQ40agBQgX+GoV0mLOG4ytMfLaCXHQL+cg9TlgrOExPUmqtseBBCHDFy8Hj5mToryEPykTWbX7AmSAnuW31Halp/DwymXM/MBpke/YVvvrKWUjlBAdHTr0JkAsRaxHqu/uhYJry1cyJpyVJ0nZqyJJRZo9RIC3nc6Fn6nQ1CZn6+63r/hdCMBEm5ZDcjEgB/Xi67Ovws+R2kLslnuJMRu7TEfByvsUqcmB68wSqf/gFz4zl4prQDafh4iovATM1KGVuFzJhkGUqw0CnJwsdqKKiSLf8sE7sXcAoIE7bTVQiXYpbSDFscUkNdxEBMaBvgqw53BAUoJosj4s6edAsAe6XMObzutbL6TBChh1B57rCUg96QNZqvrDVqgcKXSekbanV8tr3Tce4Jcc6c4jRXJyRWiBST/5e6SqeaYungzzqLPpI9TKj1xWVYTaEaCxBoJofnCpJk4S9gh6TQsjfAKM4QOa8hA2XWpTPL03TI6NdEvUEWQeEgZBg0bHJ1o9BWgqTgfnxhoCcLpU9HZAzR8bavxu17gS1cAYJT4mVU1vUfwf/xO3Zi8WV0/zBrCrinzvXjkDpW1U2L6Oomx9YOKRo3D/QhovpAGvZwxRWUXmKWGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB4173.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(38350700002)(8936002)(316002)(86362001)(2616005)(186003)(26005)(107886003)(1076003)(2906002)(83380400001)(110136005)(36756003)(4744005)(6512007)(6506007)(6666004)(52116002)(8676002)(4326008)(66556008)(66476007)(66946007)(5660300002)(6486002)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0LmklLEgfcr9GvQUuwkuI1H5ABLlaIxew3a3jrvYOzKtf7iccc6FKTaqJSDS?=
 =?us-ascii?Q?5GETLiJCIXump3ExmUkCJ728R4jqFwR0LogOuuNgqQGcxY2PJQiXQOVZft9n?=
 =?us-ascii?Q?rodOqs1pV0d9kHM6lAw0LvN9kv6XcTrJbhHAU5xY638x0x9w32MJqUaa2Skr?=
 =?us-ascii?Q?D7TUstyymY+BJVYbi9268YDWyP2RFy/JfNm3/yTns9tq22qVUYCkiO5CMNm4?=
 =?us-ascii?Q?H/09haahkEBbqdpYLF0nwcookqMEBy4goLl3XevCxbsx54pANEOZUOnRkMOX?=
 =?us-ascii?Q?e78tOloZtI++ghYBkctWFVg70kWD5VRHK6BsG+JqN2B85rQAciCO1CmoWd46?=
 =?us-ascii?Q?kW1m4qJdi3jlUvgNRZXX3cTCzeqr2F8HEKYO7liozvyGkckKEAoSN3Q1uq91?=
 =?us-ascii?Q?OU9NJL8fiPo0EDQ4VOOtpVQoPncbTJVA1phq8+zp48izSS08EARfpLM+Zi+H?=
 =?us-ascii?Q?kGMdrjCVcMVuocrMKp6V9ZmfuSR0pdouL5V9vb4p1DfkOpgKhXe1HqMcuPGN?=
 =?us-ascii?Q?2A5o90l/h9vwcAMGzDNxIMaEK1o39BKeA0u+HeJNZ74UyOS8uygb2brFRHQh?=
 =?us-ascii?Q?x51vyqgiXK9ICJGlYVTNgpbSLi89K2WZ4bpMrzTpiETr9urM9GU2k8sG1T0h?=
 =?us-ascii?Q?cx1/W9eMx41F4CuflPje0mhbXyGz5ZwqqAgpQSGwz1Rrwj341Hn2GKip3Pcw?=
 =?us-ascii?Q?WhjY3Yfz61nmVtws3zqXhD3n+4txX6CchfOu7aWmRR7HTExv1xZKi3IhNBO6?=
 =?us-ascii?Q?ogCNZFW8ectijUbSu09JWlSVte56xHZqMHuNvgiGoZ3q2LJ0EbowkxEfunNi?=
 =?us-ascii?Q?VdkQo4Lkt/sVDut0f0tQi5E2EnSPEjueWZbn7KlgqSP5+10EHio7NOR0SrB+?=
 =?us-ascii?Q?U+CJUtJMM4M0Aicr4c/pISTsM/KpederK0AtrLJRIJcf2kyaekMZTCSlguWT?=
 =?us-ascii?Q?xM6gPRRigEz9lxwSyhKnGUkGR6uzvCYtlJ8UXlDLqBLqGjHmIvNd9zO3ptAv?=
 =?us-ascii?Q?y69FBx/RBp35Iv5sJaDc9DD2qSpiToX3EJ4zDrFlzych37LzpNEMljgL/fM7?=
 =?us-ascii?Q?HyK3ma4+snPrUSqXhRPY3hyIiFL8oxg7zsWY/3UFlMTTCaNo+8jZqyeg9Wk6?=
 =?us-ascii?Q?34cDxUrhh3J6ziEwCYvIzOKVcl1R7YC0UCq1B1XV3dGwdRUbVnVCjlpbREFx?=
 =?us-ascii?Q?ScTHqild4PdETuVGbds1+taecqZ//t299Ylt8aohw7aeRV2m9rIxvUAzLTSE?=
 =?us-ascii?Q?07zjNtoG+lIAXqqm7x9BQ3RvUd5U8ZoUKQWoaxfjbrgh9SyEE0G/JIf/kXyc?=
 =?us-ascii?Q?wY4950yKs0kT4QZCTGMHGS3lFui0wYty0v5L3iiehgsY13Er8gRIkGKe5bc4?=
 =?us-ascii?Q?v7qp8qIbctDDDQr4VhGwgPkTPLPFE1oKas8Pmqqwp7aXFPcc/Mp+wTNvdDLd?=
 =?us-ascii?Q?3J2KL8vNojY6hl5J+Wk9DW3ss0q1omaBJOGl4ysWg5oIL/ayn/szexM0mo9u?=
 =?us-ascii?Q?rmSP46aOQ1cmUjNKJ28H9Nx5RvFrUndxCJJG4kIg10V/BtuUuIlWtu1MRchG?=
 =?us-ascii?Q?OHBfa9RHWLm+tkDU3sy2FvEFD5N7N6k5aPooTjMICurWLT7rC18uwEmiNwbv?=
 =?us-ascii?Q?2gfv7STe25KZ6eT3uB+iSPc=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cbaab6d-eb27-4a6a-3487-08da026dc088
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB4173.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 08:12:43.2595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cyt4tRelXha+WPumoHyBwIR0A+emPM1Mgvcvs9H4dvTCQdKhuPUnvL6hXfvU+7aQgwdjVLcQ0k20b2WDp8qQcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR06MB2084
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove dev_err() messages after platform_get_irq*() failures.
platform_get_irq() already prints an error.

Generated by: scripts/coccinelle/api/platform_get_irq.cocci

Signed-off-by: Yihao Han <hanyihao@vivo.com>
---
 drivers/net/ethernet/ezchip/nps_enet.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/ezchip/nps_enet.c b/drivers/net/ethernet/ezchip/nps_enet.c
index 323340826dab..69dbf950d451 100644
--- a/drivers/net/ethernet/ezchip/nps_enet.c
+++ b/drivers/net/ethernet/ezchip/nps_enet.c
@@ -608,7 +608,6 @@ static s32 nps_enet_probe(struct platform_device *pdev)
 	/* Get IRQ number */
 	priv->irq = platform_get_irq(pdev, 0);
 	if (priv->irq < 0) {
-		dev_err(dev, "failed to retrieve <irq Rx-Tx> value from device tree\n");
 		err = -ENODEV;
 		goto out_netdev;
 	}
-- 
2.17.1

