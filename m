Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12421686750
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 14:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbjBANpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 08:45:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbjBANpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 08:45:10 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2091.outbound.protection.outlook.com [40.107.220.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F4B4942A
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 05:45:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LtsgdQb6rJXFI6bUb86OFN7OcHRflyRBPX7UQDieRq6LXJcJZxIOuijUUg1dThUHmWLJb6rj7luzPzRDqFqWhggMI6BBD7HBlltuyWCrZrJovwtNotsjuYplqBy2QNMlKz34P7nfpXGJMZZ7v3YexC715GOPBENPuBXb+ZIXg7ApAD4qGM1rWwF7/w9+6HI3uuRAOROgIN3oCULYlO6n1Ij5prXjG2ysFhoZfZJDmHJuzms0aUmmaY6jg9DPs3OSFnz+e/wNl3a1fEg9vPwNGWE3rfZf+ByPwiRLPOSlRST0BQoONPV2x3xt2GHX5ryE9+hNNEcJLlXulD3lAaZkpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p4e5eFzdSRmJ4frMj2QxipN2By2tFgQaZOmzQP3ZpE4=;
 b=MCjxy/jJ2TKRuCQxfXDCAgrYhHIH1FIMG0eIQBdA62wJjei4+akS0rS/mET8k2aEq8nBSpBjNz9YDm6hQsl+IxJUL/hPS81tmRGYwC6T5ykMMNpjI1c7G3aYhqNPMSnT3FD8e9Mmcsmc6jBljUmv/Gy7qjPrJYLDfEQTOPtqUL1lBls0/6sO0OqwxQhKYvu5z7hBS/ZL0QKYoBEk5uQktguPxxa03u6hcZjGbclw303Hhntq6msFMhVkTbdMpbkvanKEcD8JyVwc5RjyetM9dJvkOq4zpqJOkfe4F9mwV0oNaSO5XubAdFC1xIHtIFYeZA2IftJxQ/gViovYbpEXjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p4e5eFzdSRmJ4frMj2QxipN2By2tFgQaZOmzQP3ZpE4=;
 b=D6rvon690ASVAN1DAWr7dCW7VEw/1YV5KzYwVUSqrfugXNqspl6C+tCYyu+00a+ALG7lXeKTwfFoWGGYgrPDo3F5PGxY2wOQgRF+m59k7BvhyOIzsqhHh5a4leqeTCco/z9IN809bhQ5B0DA98pwFGAjXvCo13uOzq3fDI1pwAY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5541.namprd13.prod.outlook.com (2603:10b6:510:142::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 13:45:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.025; Wed, 1 Feb 2023
 13:45:08 +0000
Date:   Wed, 1 Feb 2023 14:45:00 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
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
Subject: Re: [PATCH v4 net-next 03/15] net: enetc: recalculate
 num_real_tx_queues when XDP program attaches
Message-ID: <Y9ps3FDzmLUiN6im@corigine.com>
References: <20230130173145.475943-1-vladimir.oltean@nxp.com>
 <20230130173145.475943-4-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130173145.475943-4-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AM0PR01CA0173.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::42) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5541:EE_
X-MS-Office365-Filtering-Correlation-Id: dfcd6646-860b-4344-9002-08db045a87c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W/F1ZGG33e9I3hgruTd5a02z9Yc4Bkn2tYvfRiHJ5jM3+7nLkAKmLncUGw2V70dTDjlqd4CseWkjy8HoNYejLrE7IbRl7Z6zhNsRjgq7su1TpZAcLQsOoeyLDRzQ05scOnyUwn2/XOUp9Bxy/YvRm83WTR/MeaLLIb5ne8gOIvrRmf9gXPjmq7CKIl5Lnm8KL7SJ3IJ8Ezs2y8ksYj7fQbABXICpEEGqg3Q7McSsT45k7p/u2ZbjbWvn1PzKjyhcqTYPjSmlgBUKquos14IN1XcfrhdPsIgNHo0GzZdZ0+FShKC6VkqQwqE57QTOEMpq/TOvksir6QBV/qaf8FJlhuOd0rwnps8B4A3mD1Df3FgHbIGSA/8O3jMvnhd7hoxMow7Ak0w5Qe8y2Vl6eOHymqUwLmO6SKPlpTqG6yCt76rpfnV/5lp88YglNy3heJZ6u2vbImzB7Nlgswxlj0N4YVRV74NZNufSjAZkoL80AKQoc706h35WLkbBm2101KhRMxuYuSHZO/gRLSu1FuDEyiW8ojdU8UoV+OLtUjDen6eoudARGSb++AKgN0nlLbZsBCZ9KenSjutEqm1PJUBQF27cvrutzBwGI1iSldHbgWJcmj4ibfXjqas+UQpRobeoPDC3WF0eak4jNhlXtuES5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(376002)(346002)(136003)(396003)(366004)(451199018)(66946007)(66556008)(83380400001)(66476007)(8676002)(316002)(2616005)(86362001)(38100700002)(54906003)(36756003)(6916009)(186003)(6512007)(6486002)(6666004)(478600001)(6506007)(5660300002)(8936002)(4744005)(4326008)(44832011)(7416002)(41300700001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ErUJaqk4BJgPPXfjn0bT8H3qGixyLmVrn1cHsPyj7sqreITXtWFpk3KHLCbd?=
 =?us-ascii?Q?mrohaBK36+q/JHtObbfXf+nlLgPsUzILnFKABM8RnbYWm3bSYxkdGjz9fuqJ?=
 =?us-ascii?Q?Glu4qCCRegodRgaaqMu3aygul1Zmi17/VsuowIJ750bJf4PkwEtwJJRfBNn1?=
 =?us-ascii?Q?LSUcszRStb0N8ONXX7EM4iaUzImsmyey2u0r5c0lpYcj7Yem/E0ApbZMcUa4?=
 =?us-ascii?Q?ohQIWOrDIcMEPKggjeFSumfag5z14B/5AnmHyyWJzaEvKHq9V0n3BRGwmVfc?=
 =?us-ascii?Q?kBVpkeqs6D0ndPHN7nE+ZlBLuD0ZMMpY0u5gU73w+BYu3roiq+Nx8rTnulAa?=
 =?us-ascii?Q?MeA+WWqQJZFSt8zzFJVcsjA133l5fBGLvcs9u5n0/btK5WQp555NiWk8nMi6?=
 =?us-ascii?Q?ak+IkkrZv2OAn4vgN2lXQF3KviVV59nTCyn37QhnmwEwJSiWcL5fBnz8RPx/?=
 =?us-ascii?Q?5ewIdhiIMemOHq/b+lohN/cQ5tPTF/iRhJUAfSiU4T27ykXt9ORyO4xGmE68?=
 =?us-ascii?Q?D7o411HfdGAVZQJ8lv80dj2fYTUilV6iPii0mAWaSqMXZwd0dj4XBZIMqNxg?=
 =?us-ascii?Q?DVOAVOvNgxfUTMobtnZKnYXyhgEg6253k5fj31trb94NRrU3NEqhm26mAa6x?=
 =?us-ascii?Q?uQRRHdlj1I5kDocSXiXHjTg0yzTI0oI68UVFWtwYXAQSWrw3MgtmBr62YrEm?=
 =?us-ascii?Q?XDb5wHx+Sh9/faRIi7uznrKkhablshwDFj1TkVPueXy5oCvQ2C+Mg66kLwVk?=
 =?us-ascii?Q?CC/ymBvoWKbfFgIfwedf04CK/qfgVN6Qye9XZOlnfskX5TdGuUNXLe2r/8CG?=
 =?us-ascii?Q?8arL0pqkaJGHmJJc6K62Mrgl6trHER95lvcTeA2lt8TxvesfozdQ8iWx53sD?=
 =?us-ascii?Q?bCrz6SUHayzahZux3MQKiO6jTmteM5NdDLRk8BGkmTx44L+yYIQhcp/BQxh5?=
 =?us-ascii?Q?cLdyX1pLabOGeJhQDHrgF9jN3KGLiYbVXioLxyq/eaG93e0Nn4vS6IoKNutg?=
 =?us-ascii?Q?gD9KCPiCN++NrNUwtgGNyRNHN2OvHJ8YbI0EfiyLXH60i3F2np9yroEnvYvD?=
 =?us-ascii?Q?RZ9jEYckdc8JvxnBxOUljr8gEzAG+FW0L4mhcPBpj6N9RRWOUAQfh9yIvvkB?=
 =?us-ascii?Q?rIaDCEP9t+LoQfaxkXKgbCNHK5fqLs0g0HULLEuEk3UaXoW3QR/Li8kYSTVF?=
 =?us-ascii?Q?WMFpfsPgCVlLAXRsbnkcuaGY1zw28+3A40hZd1xJlwSDNSCtUSRfwiLGeFaZ?=
 =?us-ascii?Q?a0VNzNghGNKoKD5AFk2/uJVQOre7DmV+AgII/2XBga1F8WHfLfwxuF9AFlpv?=
 =?us-ascii?Q?Q0O8dAz4uSdexmBy6R3Sx5g5mKqfSGXbqnY+0kLz2da9gym4x8loTYOvLS4S?=
 =?us-ascii?Q?VNuukchyMAfJgncHtNcgDo5oDWNfg6S+hNCydW9hJ0H+1zchFnVcAJYySMn/?=
 =?us-ascii?Q?8HiZXuuEIHGtLhfwhE6FdQBMYUdxKsBe88llLhrNKstgkD0PoMDJ2V8Q+NbF?=
 =?us-ascii?Q?fJ2tvvVguVgKi4Et5rP2QmxXkxWV1TCvMbgVwriFMf46slGs+h7gW199lbc6?=
 =?us-ascii?Q?ATRWDhfiYlvON+2ZJmsl9HEJxrSZmj8Mt1jmkF55wcar8n5ruT6ogv0SDtbJ?=
 =?us-ascii?Q?b3WCEs6NAhP3l1B3Gmh7+YjUnYUGRLtbUWD2VfBWmMdEYpfesyGS82IUGrxn?=
 =?us-ascii?Q?axYH/g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfcd6646-860b-4344-9002-08db045a87c0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 13:45:08.0573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JetaoY2+ChxdjMh0K70e1VjNMlvdNlSMoTQXXRKRozWMlFnDRUi5YC94xpBLcaZCHQaDyTg8ScgnkPVRx2GG1B1myaTSMm0pf5euA0TsV0s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5541
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 07:31:33PM +0200, Vladimir Oltean wrote:
> Since the blamed net-next commit, enetc_setup_xdp_prog() no longer goes
> through enetc_open(), and therefore, the function which was supposed to
> detect whether a BPF program exists (in order to crop some TX queues
> from network stack usage), enetc_num_stack_tx_queues(), no longer gets
> called.
> 
> We can move the netif_set_real_num_rx_queues() call to enetc_alloc_msix()
> (probe time), since it is a runtime invariant. We can do the same thing
> with netif_set_real_num_tx_queues(), and let enetc_reconfigure_xdp_cb()
> explicitly recalculate and change the number of stack TX queues.
> 
> Fixes: c33bfaf91c4c ("net: enetc: set up XDP program under enetc_reconfigure()")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

