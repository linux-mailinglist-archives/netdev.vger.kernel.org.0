Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 024B0566443
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 09:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbiGEHge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 03:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbiGEHgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 03:36:32 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2117.outbound.protection.outlook.com [40.107.96.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BBF413D1C
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 00:36:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OhTU8YGik40GED8noLeJJ0DMXC54Zxg315VJdcozzNC2vuRncERod9jAlPXpHMLPMRxKnNjC5AsTBhHjIp44hikPn+96Pp8IWqN9QB+zbqVbUTpbsNgmwIdg/2ZeRvWVvXDYqPNPMtVVBs+rCbmffoPiOVsKmqlrYIJt1MhvKgkYdlyPu96+/LyM++nvYRSwwyXZewIY3tgq2EkfjIikrrsYnNwI8fijpR1nFF13h8ZHDSxfm+OdcXeIxr+X98HVh6kmF76UM3THk0SXlz/MHpjgpXFKcKsMBZqtQvlPEsav2baNf2kT3/qs/+ncMFNmw2qK0toT7YihO4LfMo/ILg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vKjjDikefbCYq9kOB+YC2sAUtnBytK2a3GQaQqsjTBg=;
 b=ZBy2HbmMWt9vlAVbkPpcPukRjAYahsPzLNYJC3kAi/YMLWBO8+tT4C2cC52QM1+CvvRkf7gTMBqirv8EL+qhARPK/EYNyFFMflGzVl8EDQI128dVJm+hZO2jTbtzS23RbbmUc05bigGBj3uhL65uwEMb5sCEPl0RXbt+eem6aXIpr+2pMA8Zt+a2DlyZtSHw9bMUpMyOGkxpCTMmFRiQgPrZZRew5t4KdGQtJOfa+ZVCul4B2YnVDRJo4bD8b2jNg4HB3rcaajUAqCoyGUj9zCVN/1vcs/58DZwnAMIx+vdUHRaRhkCnN5iFDZlpWl2KlaPgnSC969PgZ8X2nlvmCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vKjjDikefbCYq9kOB+YC2sAUtnBytK2a3GQaQqsjTBg=;
 b=rbmbRUGAB339msPMEzQNxnWYxMh+VcZph1s+EZNCjyHayqt349bb/zOuwOIGx+TalByH6plVwZyLz3SqTsSS+C2AzzoLK5laO6+ViVNJbJxgwfGIJXvo9AsuKtNwsSKNIv6k+NJ0gfgiL7gt1jy6WoHRSubZDyLDodn3hv3JYGw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5312.namprd13.prod.outlook.com (2603:10b6:806:20b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.8; Tue, 5 Jul
 2022 07:36:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::bd99:64d1:83ec:1b2]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::bd99:64d1:83ec:1b2%7]) with mapi id 15.20.5417.013; Tue, 5 Jul 2022
 07:36:27 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 2/2] nfp: enable TSO by default for nfp netdev
Date:   Tue,  5 Jul 2022 08:36:04 +0100
Message-Id: <20220705073604.697491-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220705073604.697491-1-simon.horman@corigine.com>
References: <20220705073604.697491-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LNXP265CA0033.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b790fc82-3229-4968-0195-08da5e5911b9
X-MS-TrafficTypeDiagnostic: SN4PR13MB5312:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Krr08EKBTDX1Vu0EkcFtanwHu05stoNtlHPT8MlR1CSB/B/32PZ+7iU0RLmvcvj7oZLx1GRmjUTs3/tYzIpYcYOfLM05sFA1ZPG+RJ1jmEfLhO9/erIrS5RYVuuwlxQEhZeDQGppzPaFRVT/AMyoz83DSTUah3bgEBm+v53Vy0n+aNngkymFTfStAYTqVciudgVayKEnYReHTfPYMo9328enG22ngtlFWnRFGiccBzVeXwyHu0DAdRvuqwoTCallbj6vFHppvOBRm6BRo47XShCa3nbehLaAQraZEAWJaPEER+1okewidEMz/T/an1vc0MJzvg3YHceV3n1ye/vrf0rOdA09xrP3CJWssdfwqwASiNvZnDJrl3EEwV2XduyLE19dDyZxRI6rEhqVXHvmfGwUyxuUYhYtBUNo1cb1uDLm9jyv2FXyx5YNDEtG3kzFtxnz253pB5ACQjDwmDA1Rh/qDCmvbNLuEO20jNOL92E6zGo5s6nROk+AM5gou5NlKGGkMXGCZhBiTi4JUevP/46QrBCdGVhYYkS+WCuCFV924sVF0OiKh7gGETibJ4eE0Y9voF4SDukP6q7oM38Yb6+Or15IvD4rQ+JFNthmIvtDbERXPKLcicMXOdv9m8y98PZpTL9Yt+WVlv6sECVctPWR3Nox8rUWZKWE0BHelRWv1iYthliq3nylz1i5dQTor9ns3DrSV3gTsJ5MCYTMYVIC99KNW8n/s9ag72RrycS1Bhralu9zl4uMjbWZdHuLUxZaWy4dp5SNjny5adpwgVLq7iVYpqDdhYYtaPMoyhoM6F804RyYUzyCPrmb9YXE4GupK2pGay2cN0e82HhROqqVQnA+VJKNwD6EPDOkEDo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(39840400004)(366004)(396003)(110136005)(83380400001)(44832011)(6486002)(2906002)(86362001)(478600001)(52116002)(1076003)(107886003)(2616005)(186003)(6506007)(36756003)(26005)(38100700002)(66476007)(66556008)(66946007)(38350700002)(6512007)(4326008)(8676002)(316002)(6666004)(8936002)(41300700001)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GKX00O4WhDxoUg+yM8Js0MbiupOa6/7N0vLbV3UW3YXMHmXYZ8wsVG3kU02r?=
 =?us-ascii?Q?+ErZokk3z7JmoG7WGKB8ddE0Lagf3lb3zyQLiHOXeL4sSjMCr5suyJqPIDSg?=
 =?us-ascii?Q?DfTb5yZPVq+PbYEAmRrhmWHHaVv2rKdE770PN7B7K7p6Pmnd9lVZXGy9LOaK?=
 =?us-ascii?Q?PvyTJ6mf+wnF6Y2J52Ara2P3WcOOVNMzduPY/dkySCYSpeSxcaR4tG6cQmrH?=
 =?us-ascii?Q?w6MvrnitBbCpZYIHD/q9dnyNV7TIOSwG0nYSbWolzZeBLY227ZO7nlbDml2y?=
 =?us-ascii?Q?HX1p1eZbFyNXUPychtNsaz9vGd1Ld6x5LgK8xyZGsTWSCSrrHzPFpzEMeMmr?=
 =?us-ascii?Q?TCh3HtgFLMbYhlulhvOj4+dN/RWYOyOW3b81EZOam7qhoUxkuBC+p5fPk8c6?=
 =?us-ascii?Q?/gmDIKVmQH3IfuCOGOnUDG4//DXQ4WMrdNaV/kVBp7okdDcmAoDXpVpQWsF6?=
 =?us-ascii?Q?/HoHsVQqliOKEBkJdDo8Ed28ymPt0EmrLk+aBCqnPWKBiFSu48NrvGG6ftie?=
 =?us-ascii?Q?nSN3QnAEWnMWeL+AKtyF4JKgXdvCcA/9c9MxKot9w560Qah+JTF/dDIwOmgD?=
 =?us-ascii?Q?xFushnzN+JGtMdxS7AY+YQV0d3RFmzUQpvfTFAQcbPhUmW5w775iWz6qCEno?=
 =?us-ascii?Q?Q8zYvBcEm+3KXj1fdgurWEvcfZOvkCnabcv0+s73A2Pms7WJOyVUti0cp4lj?=
 =?us-ascii?Q?PjDvCYLYI3uSwBNCL/aKwdZjzy3uPjFTVZfC5ETUEnoW97Cv2AgCr6HPkE6A?=
 =?us-ascii?Q?ko1UzpFwZpmhHJ3Ulb10jlA81XwUaXEpUVS6fsrrSt51OtULIe3Mjmc7jXB7?=
 =?us-ascii?Q?9pfvUhOyYQvMTYt9lnWdFihHELbNKAEbPAux3yBWgxzv3bvPH4W6JQSdceRJ?=
 =?us-ascii?Q?e8w9KcxmquxXwLaOsU3DARtICGCA0znuKovP0Oj3uF+ThrHKNeGcVktc6Fsf?=
 =?us-ascii?Q?pnp8ozJCRbkvDJ8+hmvWhDnngDBY//l6aZn3HDNXx04rVs6g9Qb64u5L5Wcl?=
 =?us-ascii?Q?iZAgeazZbl4Wne+Ed7uLC6/ueMy9uElIxFCGhvRUSrUcdf3AP9gV2awAbkn4?=
 =?us-ascii?Q?bP/pcVDjQMtZ59xHeJIfhXB3ARM0KjRU6sww3CWi++HEBBY0a37omtR61sfA?=
 =?us-ascii?Q?+Vq0mxVIIt9v6Sn5rr/ymVutRAv2rLOP486jUA72he/+oWSBj8qbYFAmyXa7?=
 =?us-ascii?Q?gbMIgRLH5Jw9w8rkRjSJ1urVD0FYZnjyiSnYagqqECCCs5OtqkK563RmL8Mq?=
 =?us-ascii?Q?yITj854IxLOihe9iDJj0XUr/Ay/T4qL2qLAuj9Mj4l0wKpPpwrPVjuRYwWAr?=
 =?us-ascii?Q?8h3LWHLj/RZU4GHr/8RUGhDsdjD5luUtDKZ5ugX9BwZlWg1+KhXx1erHXilI?=
 =?us-ascii?Q?dywxf5sCDBM49TzauQ0lCv9g++Iiu8BfYVkUjZ5ZzWSfzGnT8K1BIiRFo9z0?=
 =?us-ascii?Q?YEIioUSalsG5po+I7Ses8CZeM57C3aLkjcDV5uvj4i45iCA2D3h3il+Y00U1?=
 =?us-ascii?Q?wsrr4nhZc5yAvRd0NTXJW4tChUdDb7ZGsQ8vSBZ2vy5qXPhkUaWBOnpsJxfp?=
 =?us-ascii?Q?Iu3PveSaShX0Wh5bveNh8nhHpQrydBadM5dEFxAuyip9ZzuRsOWgYPSN8oh9?=
 =?us-ascii?Q?kA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b790fc82-3229-4968-0195-08da5e5911b9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 07:36:27.1752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QVZxMN3UmJv6Gy4CU9HH7acfZUXrqNVbvPs6hy65s0FhClx3qlbS8WCau378SxjPbkSCfUrVZYIU2/u0L2Z4PXWiVon/rHATFRt/vD16RG4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5312
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can benefit from TSO when the host CPU is not powerful enough,
so enable it by default now.

Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 7 +++----
 drivers/net/ethernet/netronome/nfp/nfp_net_repr.c   | 5 ++---
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index d4b4966d6e29..c5c3a4aac788 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2420,12 +2420,11 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 	if (nfp_app_has_tc(nn->app) && nn->port)
 		netdev->hw_features |= NETIF_F_HW_TC;
 
-	/* Advertise but disable TSO by default.
-	 * C-Tag strip and S-Tag strip can't be supported simultaneously,
+	/* C-Tag strip and S-Tag strip can't be supported simultaneously,
 	 * so enable C-Tag strip and disable S-Tag strip by default.
 	 */
-	netdev->features &= ~(NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_HW_VLAN_STAG_RX);
-	nn->dp.ctrl &= ~(NFP_NET_CFG_CTRL_LSO_ANY | NFP_NET_CFG_CTRL_RXQINQ);
+	netdev->features &= ~NETIF_F_HW_VLAN_STAG_RX;
+	nn->dp.ctrl &= ~NFP_NET_CFG_CTRL_RXQINQ;
 
 	/* Finalise the netdev setup */
 	switch (nn->dp.ops->version) {
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index 8ea4d8b55750..8b77582bdfa0 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -380,11 +380,10 @@ int nfp_repr_init(struct nfp_app *app, struct net_device *netdev,
 
 	netdev->features = netdev->hw_features;
 
-	/* Advertise but disable TSO by default.
-	 * C-Tag strip and S-Tag strip can't be supported simultaneously,
+	/* C-Tag strip and S-Tag strip can't be supported simultaneously,
 	 * so enable C-Tag strip and disable S-Tag strip by default.
 	 */
-	netdev->features &= ~(NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_HW_VLAN_STAG_RX);
+	netdev->features &= ~NETIF_F_HW_VLAN_STAG_RX;
 	netif_set_tso_max_segs(netdev, NFP_NET_LSO_MAX_SEGS);
 
 	netdev->priv_flags |= IFF_NO_QUEUE | IFF_DISABLE_NETPOLL;
-- 
2.30.2

