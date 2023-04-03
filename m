Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D136B6D4299
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 12:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbjDCKxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 06:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231977AbjDCKxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 06:53:24 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2060.outbound.protection.outlook.com [40.107.22.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5817D5FED
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 03:53:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MrRxG2LNmnSRFw06/H4ngrDjm3tLukNOGsgBBqEkEoBY0LHc4Yw7M2FuCfw8OT84nA2v4pR9hZ2pCena3gAqTV81gadjHAvGfZibyUAZKLlykgesv9geHSgZmHW8R8L4pcBkY+82POKn3wc3W8mLPv6Mm15SoS7h79P2EGiCPuJGGwMd5Rj2N1/laTYXJlaaeX5Eq+oQHnWZEycBhqNychLElI2HYChn7NbenW5UMO9AI62/3ndkyh3B6/rORGxuu16Y+d6qqNcNs/+lXmn2YSrgaqQjBMqagyC+erHzb6GzQz0ZznzVaNI1bA4xWint5lUGAHUubKt4hhBWNNXq+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YxOXfYkd8v6OR3EuVIyRZW+DdXXep7qNudyiZAsjyao=;
 b=jZbFwgRzxUk8D7+Q+F+qR+T0dnNBhrUbI9jog7054fzRy/IvJrqU/H0bnAORirk+5JBIed4nvjinAlO5IWVYMMM35tYsZeybypZlm8L0HL3WF0lUNAX0OZsRGVbHubj4ersQi9E7/eUKs7IhWfO0Jbz2lIEIYuJxD24e+VWUjKVywH3O8u/zyW01InpjcG6p7k1RLhE+tAK2vT3sqzDCz5O+/I9vQJEpoGTVhNQGP5MmJLIly0AU3uXpwsiBfaq8A7RrAIuWtTKi/s/Xey688StLtShEeOSuzLYANwOwnfBdLTl3wps3ZjBi40l1qOhfC1Jek1q3ShIfp75OOyUwcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YxOXfYkd8v6OR3EuVIyRZW+DdXXep7qNudyiZAsjyao=;
 b=ryxmhxXld6nfkJ61Caox6lPFZicnxNqQGNKWfPRPlGljTpC2SHeW4Tp74dAvVhe6wEzF/LrUX6u8aQpH4ujKj2AlpGc0VWOCsscfnLcThz1PVjC+Zyk4BdLUewaJk6BkTD2KnCMBfxE48yueQNFvVHo0cG9NSkDn9HLZuUELIYw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DB9PR04MB8479.eurprd04.prod.outlook.com (2603:10a6:10:2c5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 10:53:04 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Mon, 3 Apr 2023
 10:53:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 3/9] tc/taprio: add max-sdu to the man page SYNOPSIS section
Date:   Mon,  3 Apr 2023 13:52:39 +0300
Message-Id: <20230403105245.2902376-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230403105245.2902376-1-vladimir.oltean@nxp.com>
References: <20230403105245.2902376-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FRYP281CA0006.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::16)
 To AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DB9PR04MB8479:EE_
X-MS-Office365-Filtering-Correlation-Id: 33f0c9fa-31f3-4582-adc7-08db34319a0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aX1Fi2/4Mq5FydFbg71nh1uoPr+DskU1mVXMShPzZ0YOhhvtv+PhvKCyK3Cs4M/8Se7Nz6xQz0U3TDTXsPiuizBZnZ5iwRQpn5Tq6W/LGNvyKclPmkDvtyoy1ulb0UVkzIyWGQzjWlj+CUx7OOo9Hddg1E3VKdyFwgEuKS9/6XffUnULv9ytOd0QOlbp45k8K/battt/jF0aKa6y7+uGQUYC7tqxfFQC2DFGrk+JAF+r3cYnwTE2282ft4cOMCLRJWj+W9EzSxtn7Eo3zwGv87heKHD7htae+LB1+APq1H/ZVrWf3CiIK7DNfVyedkzfvHIIBuJurSQAvZw9VMMj5Fi+6vySWOsXuv0F/AoeRt7IE6wE379YlUeW+IorkJnAam/WJruNOXtINk0sESi49IPFNtLtus7figT81VA02CltiKPBi96s87HDzmupF26UkE73n0AnGCwjjAaFqIoTmOqfIfxUCN3G2+kWVppm6kef3h47JCDCTVNog0HECZew7apNfpDIgUhxoqUwuAgHTpZWdy3BJ/nw/cNycl1x0YpuuIiR7MDv7aCZy9RxVYIE7+VKJy/XTJfD13xoo5fgGc5CBqInsz+5SLtRAyRUiaGqi78kgn4jzhROoSG3s3rX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199021)(8676002)(6916009)(66556008)(66476007)(66946007)(54906003)(316002)(478600001)(4744005)(8936002)(44832011)(41300700001)(5660300002)(38100700002)(38350700002)(4326008)(186003)(83380400001)(2616005)(52116002)(6486002)(6666004)(1076003)(26005)(6506007)(6512007)(86362001)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u/Uief1Aj2V/8HWVagYFnLjurStNiSdrnzJEoWLzDAP8h4N3NP/BGSfY3PYX?=
 =?us-ascii?Q?IWuiw1mcU8sA+T2tAGeYR9j/84EniWbHjCd/0PnvaapHn5wKmae3dAq8Yltr?=
 =?us-ascii?Q?EMQdUIqvjSS2kV7Tz0CEDWBlnAPXZrjMPziqq0WOpiBKJ0/y5uYW5ehMwIZt?=
 =?us-ascii?Q?vzf7SQS5r3lmIi+RhvHvW8gI4qGbo0yyMxKMwrJrcqkDyefmM4xDF9UvOxTK?=
 =?us-ascii?Q?Swou9F2+k/GfYg+kIjGapRf6meE9cGtp9RSfnAOHRje+WWaUJXHank47+m7N?=
 =?us-ascii?Q?FD7hqCndXl0ghyb9cBON3LzgrQ0kNYLVVeXszpfRY/NFfopNLnWNi5lbsHNM?=
 =?us-ascii?Q?YxSY+Jq89FBlQaMG+qJHUaOyQPneBZhHfMD/f8YUMCtMKVMb3MWkpMEOwYIG?=
 =?us-ascii?Q?R5dQWLq1zEdYW+eBbMk6yR7znjrxKwGm1UZoGc8Xw3PgrS+4mjy+anH3t8GA?=
 =?us-ascii?Q?ipUp5h1GKaKsQ//kkc5HIBh323zKu3T/RCTo0qXWgylMmVeSyUHi8nIWClTr?=
 =?us-ascii?Q?jT8DXb+aQn6znw1yqkO1DokNNUaCvD31rNbzCW+oMa+wcWtFX8fqwcRK+Qh2?=
 =?us-ascii?Q?eNqfw79AkDMZEXc7hw2dthY8Nvcm5vvW2Vif8X9ewdhQRHReI2S9rMtkTBog?=
 =?us-ascii?Q?dT7NnHI2cURrBTEUQrWP9lX3oMnHO+HgRfeV9rrJ+kPojyE+r6mS9UvRW7LN?=
 =?us-ascii?Q?jTERg2xayL/gHlQuqw+4cbgeUbSvPn/EmVJu5NJ2cUh/QNTyqHoHuuk9pMqs?=
 =?us-ascii?Q?VrQNEQa0igva97c4ccRiW4j087Jjw52knhdWdS+BMwB0iujMIfMcbAdTBm09?=
 =?us-ascii?Q?5vQ8p6eyzXGrxt6vZxanLtk/SHtZzF7++VKNJvus19XTDhaLjt6PIxjjOSQL?=
 =?us-ascii?Q?GEw8Pech86XCY0L1zcFqdCPdqSpnymlTzvbmgMXBJ85p2mxQRftUaUWRwIjP?=
 =?us-ascii?Q?2mR8XB6B77ctLMXoPeaRc0qjnO643P4O4LlaVtoFR+V4KkRIoY1Rio7aG6wZ?=
 =?us-ascii?Q?vz1tlNB5hRN26pOIQqW2vFzhSrNOnWh7OwAlK9iNpdFnWxrfZsbtKiw9qNSM?=
 =?us-ascii?Q?Xvytlp6ojuyfNaUAhI/LLLvLjcL7P6OAfdhVP4uFL1JUI/4bDzpvCA5sDHln?=
 =?us-ascii?Q?EqE4kroHl/S73uBb1KP2/NlOKqGjCbealtpHNK2JqE8coL3EIRrHUDdMKYSa?=
 =?us-ascii?Q?IUXviGkbNO/NioFMZnCbY7EPHjl50pTPBBR2KG2uI3LCteu2PAWyUIE31qW/?=
 =?us-ascii?Q?I9vxgjz4IP3QdsHKdRwjJJEOLWd7sp+TGSUnTTp0P+k8XO30YI8x9fMYNA/2?=
 =?us-ascii?Q?kQX+TaOIzGhSsAKYZxwv7DawTAGfbjkxS89VFoX3uA5A+PUuqqXoreePPLs6?=
 =?us-ascii?Q?FDfSYeUZEJ6k9hfouFl12jodHDiWRK/ZdDMaUecJfDX4UfL+q2sRPuN6rXGl?=
 =?us-ascii?Q?938mi+TsmkmzJTlG3/Phgjiuy5m3FcUZf63xzhsxOoNzDefLhHi77PHAcTax?=
 =?us-ascii?Q?gt+bRj4e2WpybfOtb7jQvGc+vuqUcCq9aiDEK0LFG4SfjzqcUf/xTHuJ0Oel?=
 =?us-ascii?Q?WrjxMWo3GogrDYuDUm2/tPBY/IehAbHDZKtFnWBvHsbw/3Gx/jIZzYF+EiG8?=
 =?us-ascii?Q?9Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33f0c9fa-31f3-4582-adc7-08db34319a0e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 10:53:04.7839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tvc4/FBAmk/khu+G26qPp7ujjtPh6sgJLpKVrJvI1mF1BdpglhQtrVNouZrS/AG+sgqTE28dQmamxo2zu7uuqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8479
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although the max-sdu argument is documented in the PARAMETERS section,
it is absent from the SYNOPSIS. Add it there too.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 man/man8/tc-taprio.8 | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/man/man8/tc-taprio.8 b/man/man8/tc-taprio.8
index e1f32e73bab0..9adee7fd8dde 100644
--- a/man/man8/tc-taprio.8
+++ b/man/man8/tc-taprio.8
@@ -32,6 +32,10 @@ clockid
 .ti +8
 .B sched-entry
 <command N> <gate mask N> <interval N>
+.ti +8
+[
+.B max-sdu
+<queueMaxSDU[TC 0]> <queueMaxSDU[TC 1]> <queueMaxSDU[TC N]> ]
 
 .SH DESCRIPTION
 The TAPRIO qdisc implements a simplified version of the scheduling
-- 
2.34.1

