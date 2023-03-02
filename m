Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 986386A7F78
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 11:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbjCBKBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 05:01:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbjCBKB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 05:01:27 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA998457E1
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 02:00:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b71oOj7sE+4jj1OWCCKvk+J+t5It99MKg+rQztfW9HHleg5IQSMFSdnR+L158khQ4weVoCz/x1anVKcMbOCKUNODr9zNQwnULygYjS39AK82OGhaeORAElEaD4YdsjZUmwkVQIUNMPThXiUE/OhEHREdJ20iADLhUHDc7EIbhd6bpOIwSMlXkVlY+vxORUgFArWgJdjX8rz+wOO3JO7uLc7SppJyWNk9hpv1BdarIc3gOL/k7AHQIKiEqiZnvFiLX4vkhafilhKVwJz7rrDKIu6xT+llzxD5DL4M/Yk6vl9Qg3Ih5suQEJh3hN3Ysk8kTn6tYfVitSj8oY08oJJbAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zlHsAftJ1ZtRqscibEj1gxHP1eEHKr1vXZr4ACcHOPs=;
 b=ZwKsHQARLBnYxmHdN02H2N7G9cMvcupwPo5NNcjzTZgzIKEVp1C072SXD7GP6rCqB3yYoVWrwJUzDHS14odgFlZuYP52U0h28r8vMYf/ioJsB+/u0UYnyDdKXl09ymIiwzuyC6KY6KsuSU3Oa+gPQ6LZccqzM8u5GGx4v0YT3YKk8hgQXOV7H52f4qJq4jSV9EASTIPzPW0tz1+tYsCmac2QmdGPnV9F9C4h1F74K2LnzkxwM7PvNtL9QaVUkt83vkuGLMVnoJLdXsJ3ApNz9iUH4w64iJftpNUQjyCk0wNcFi3IMJq/WITh+yPpDxIQ7+4q4riOulhsJS3PNl/0Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zlHsAftJ1ZtRqscibEj1gxHP1eEHKr1vXZr4ACcHOPs=;
 b=LvJ053Hx0cYn2mgRzEt5O7U5E6Id5F1O7jShyBqFrVHcASEaPaEV00uCD2aJLStt9cLnJ+yH8Sd/r0b2zjARgmTpp49aHVDEaC3JHSB2pO6mbTzlPy+AxyawoOauj1fzJJTJFiK5k0Kwi0OqwSwAvAfuPnie3vgC6vMXYeBR42w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5692.namprd13.prod.outlook.com (2603:10b6:a03:407::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18; Thu, 2 Mar
 2023 09:59:00 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6156.018; Thu, 2 Mar 2023
 09:59:00 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Huanhuan Wang <huanhuan.wang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net 2/3] nfp: fix incorrectly set csum flag for nfdk path
Date:   Thu,  2 Mar 2023 10:58:29 +0100
Message-Id: <20230302095830.2512535-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230302095830.2512535-1-simon.horman@corigine.com>
References: <20230302095830.2512535-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR10CA0008.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5692:EE_
X-MS-Office365-Filtering-Correlation-Id: 492ba72a-87fc-4aa8-f2ff-08db1b04bebf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NlVbhD3jqPB8Az1RdrmugldKVF2UF/+u0J88NxxHWR64NfcpLU0BjfBrVU132sSFvLRYLvjXHaSnAKcbUBe+V3j29myBC8XhZPpHzCwCw97p+OhsBtPuD6/P2p3WG6iVAldQPQcatd7RM1VtKoJ4t3nyzugnC/WSW6UJYbs+TjWCsBd+d5rrNLyeh9BTFvRPcJWyPGNdJKFrQs0d9LRWZykgFm0TKtBU7pHS5u/GQsOiNF8eVUdy7qx/RhOjaK3zBelrxuaA871sEOdZR8BBecJFRphKZmOkjIJvX1Zby0Z0Ghki0nWAjS0ncge75B6CHVXmG7QyR731cMcJUHT8wgNpN0c2op0YckmLs5CtbCNmJlxxqtxc0l4jv58bxmVziO3gJFcUA5UEgB7r2akxh9zdFde2ugLg9i5UOTxHm/2MOHXnKkF51IiG4/rxqQbtW2AKJEG0PolLMaYx9dnzQ0IHLxk6Rep/xCwkCoi6b9YfykUldRxDZnljBiVb+5HE282gjSYcv09ENNK/k4nCOwH09ZAzGuSgzGgTdwvzpoDWpl7uaSn9mVSpXzoTaIS2bF1FbXQu1OXS72f7WP7LJcZZAdbjHSPtFM6J6hEeHAuK6ApDlM9Fnaabk71Mxlzx9fiGmaHXZGTzjJhOgVRk/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(376002)(396003)(366004)(39840400004)(451199018)(5660300002)(2616005)(44832011)(6666004)(54906003)(107886003)(110136005)(52116002)(38100700002)(6486002)(478600001)(41300700001)(186003)(36756003)(6512007)(8936002)(6506007)(1076003)(316002)(4326008)(86362001)(66556008)(66476007)(8676002)(66946007)(83380400001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xKujbxpbn0mTHAwKqaepBocvRfqpFtAhXH2QC9xdNo5kojIgRyHBJW9N0YD2?=
 =?us-ascii?Q?NhKiyzRSQpskfXqmmKOsQCooQlza6ETtAHx+6o+0wFR3BmITj9jhFgbJ3S/a?=
 =?us-ascii?Q?CXH7I33Or8FUVZCCnGPZHdvraQa8d+dCSGNoLKBI7wy04cEnUT5qFIdmHUbh?=
 =?us-ascii?Q?x6mo2UdcV6QCcd3m8Ny7HmPsA7RkOiGLOG8hUS42Ms5HzisWAvWNaKUyuuMK?=
 =?us-ascii?Q?Y2QNuWXQ9QSUT2ihr0uOE/GFxqT/LYbfrjaGPfN4akMbC/YBAMkxN1wzfKbv?=
 =?us-ascii?Q?fNEWfDfFDX5OhWr5NDR4zYXIi1zNlK0tByPq2Lncs8JeFKT336TOngeiW5Ft?=
 =?us-ascii?Q?sPaNpmNighZM+dxNAFMlQu5JGf7K8jCT970xJr4Cvd8xKdq280xooQH46qK3?=
 =?us-ascii?Q?l+CCzCSp6d7wU/Sg+ASVmewobq7UXUFmUDyFRoY/c5qkTevJFwGOXcIXYHhM?=
 =?us-ascii?Q?wsaQPtjrkNL9A11IoOuVDF+RuY3dXv8kGXjKqNxVaLD9mwbFNT3+VqX2J6OO?=
 =?us-ascii?Q?IUAoy7fDoIRNP80uly9aJgN+FirC1t/d+qyXIvrt65rGAjTELnNO4WROSRzL?=
 =?us-ascii?Q?f5IryHC9dq9cxS5OsOJI5Ur+6pB1xTxGypDWPxZMgddd8IDrvozAWgFmvNtZ?=
 =?us-ascii?Q?mu6XEMc122K/zvCOubiqhlkJX6MHIvQLU8sTWit6FPVNBs/KP6fXzlevfVBl?=
 =?us-ascii?Q?xhXlNBW8VkvlVLPzQbX+UPEqDhRm33GxY6xWBqMxWLBchw2JScbfZkWyL9pD?=
 =?us-ascii?Q?mhW3dwd/dQArEbtpGb/Cw8dqVq0tmmfC84kKAOb+PSk1Yawo3rFcUXxY3B37?=
 =?us-ascii?Q?d0mWzNI7CXXI7/xRDqohPMphyj9132HafKR75QjLAUyEJawDKigBg+jKa0AV?=
 =?us-ascii?Q?J/ggvj5iilzlgzx/Ww7ffyphSBbXgJ7tHGcexmFVr6kKzJnXF3srfzZEm7Ik?=
 =?us-ascii?Q?U6zFo8CA56ds/fmHEV9CGlpWRRBg9nHSNPzEanFwUudTdz4sG+cNvenaRdHe?=
 =?us-ascii?Q?ZKolc45s2oeATwiYPinrx/E4h9tritpuoA9lxoxsIeiu8A9YrwsdXg1OhSnL?=
 =?us-ascii?Q?JUn5yyadX26genZHKXlqWVZ6nDm2Bvx8Zf0e57DUYf1hkig/QqOeacBvEf8q?=
 =?us-ascii?Q?OXHtSaJvC9pzrNJ0Dgc0fuSu4MFgfo18DzciESsgh6E2FMzpGZKxGeW7bPii?=
 =?us-ascii?Q?ViJWU5YN/ilKRjRbbiyzzd6zBnQWrQzXYxGA3p2RRx2qVZdSKySBkbHTc8pd?=
 =?us-ascii?Q?tFseZtDe64pV2vOd40AAeQkVx8bFceZnwVgFgsYKGbXhLDyfh/HPcTTtnUrj?=
 =?us-ascii?Q?61L87FFc+wlHlsyoUKjeF5w/rvK46kdPXyg/CaXCcT6C3SUmWpG6O65HLp4V?=
 =?us-ascii?Q?fztzbN41tANG5RxOUh0VN0FmYU06ijOW8rLxdFEKsDQ4iTlUlTNAgu/Op5TZ?=
 =?us-ascii?Q?DemwNWraO1o0zma2HA2CNh7Zmm6/h0CUt30jBi0O+r84pYp79Y6ZOa/jUmhj?=
 =?us-ascii?Q?vA05sm1FDLAIteRhnuGlLvE6v2JO4800SrhbAgIc0xpuz2DgvooOhfS96YRS?=
 =?us-ascii?Q?wUZHuNQbgdrkO+mF4tS2QJf/m3bmQEMCduPyQIpWl5XSkc7TCt0rXEX8b2+v?=
 =?us-ascii?Q?9UZciv0nV1qoDVF7pi2JT9J7FlnuEQKSqezMgXeoz5Gn5NEJBlQqGrOoxeXV?=
 =?us-ascii?Q?Ei6Wkw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 492ba72a-87fc-4aa8-f2ff-08db1b04bebf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 09:58:59.8689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: akMTH8tia+g3Al2IGFhZcUur/Si4mTlePsXjHE4rQYDQnUcA7VoxDdFDBqSGDxlD0DoMkOD5xrDBcgy/uHVOfH0NoDE6sLkkg2MDJiMhr0U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5692
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huanhuan Wang <huanhuan.wang@corigine.com>

The csum flag of IPsec packet are set repeatedly. Therefore, the csum
flag set of IPsec and non-IPsec packet need to be distinguished.

As the ipv6 header does not have a csum field, so l3-csum flag is not
required to be set for ipv6 case.

Fixes: 436396f26d50 ("nfp: support IPsec offloading for NFP3800")
Signed-off-by: Huanhuan Wang <huanhuan.wang@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c    | 6 ++++--
 drivers/net/ethernet/netronome/nfp/nfdk/ipsec.c | 8 ++++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
index d60c0e991a91..33b6d74adb4b 100644
--- a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
@@ -387,7 +387,8 @@ netdev_tx_t nfp_nfdk_tx(struct sk_buff *skb, struct net_device *netdev)
 	if (!skb_is_gso(skb)) {
 		real_len = skb->len;
 		/* Metadata desc */
-		metadata = nfp_nfdk_tx_csum(dp, r_vec, 1, skb, metadata);
+		if (!ipsec)
+			metadata = nfp_nfdk_tx_csum(dp, r_vec, 1, skb, metadata);
 		txd->raw = cpu_to_le64(metadata);
 		txd++;
 	} else {
@@ -395,7 +396,8 @@ netdev_tx_t nfp_nfdk_tx(struct sk_buff *skb, struct net_device *netdev)
 		(txd + 1)->raw = nfp_nfdk_tx_tso(r_vec, txbuf, skb);
 		real_len = txbuf->real_len;
 		/* Metadata desc */
-		metadata = nfp_nfdk_tx_csum(dp, r_vec, txbuf->pkt_cnt, skb, metadata);
+		if (!ipsec)
+			metadata = nfp_nfdk_tx_csum(dp, r_vec, txbuf->pkt_cnt, skb, metadata);
 		txd->raw = cpu_to_le64(metadata);
 		txd += 2;
 		txbuf++;
diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/ipsec.c b/drivers/net/ethernet/netronome/nfp/nfdk/ipsec.c
index 58d8f59eb885..cec199f4c852 100644
--- a/drivers/net/ethernet/netronome/nfp/nfdk/ipsec.c
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/ipsec.c
@@ -9,9 +9,13 @@
 u64 nfp_nfdk_ipsec_tx(u64 flags, struct sk_buff *skb)
 {
 	struct xfrm_state *x = xfrm_input_state(skb);
+	struct iphdr *iph = ip_hdr(skb);
 
-	if (x->xso.dev && (x->xso.dev->features & NETIF_F_HW_ESP_TX_CSUM))
-		flags |= NFDK_DESC_TX_L3_CSUM | NFDK_DESC_TX_L4_CSUM;
+	if (x->xso.dev && (x->xso.dev->features & NETIF_F_HW_ESP_TX_CSUM)) {
+		if (iph->version == 4)
+			flags |= NFDK_DESC_TX_L3_CSUM;
+		flags |= NFDK_DESC_TX_L4_CSUM;
+	}
 
 	return flags;
 }
-- 
2.30.2

