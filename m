Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32EF06C5151
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 17:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbjCVQx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 12:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbjCVQxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 12:53:49 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2090.outbound.protection.outlook.com [40.107.244.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833569026;
        Wed, 22 Mar 2023 09:53:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AyOxWSSoiRXZzL49gWfSVlat6mkRdT+S0pYgsbP/xTUsZWVDBmgNX+ypDjn2Dw/sfQOu3DOr1GbJBg+vW5EGt4/LZ6bJ60vG85NVD8FS+YB1arlY0majF18+ddhogczLkj+11oyqugA+/NYzNdkqfRy3OzszTyF0jsW332TGY48iXO6J1ztKfaiXnaZqojKzxPNpwwlATj1+uZM0BaKr0AF/K3Brx7ptDWdxiOEOHekR0YmP8igTTMsiJhvD4rn+O9cPrRFeNoBXqnZ5ib2XIZfspbTsmxN/f2bTuBt1b1PlcbK4IFgZSExTcJ/IbKJTxCP9UenvqpxowEAFSQQl7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8NxGobRpsh5xPZ1g2o3VerFNW+bLLgo0Tio1ZanrXcM=;
 b=CWD6fT+k6wR9U/vZcbxy3cWknrzuOGYf1yP7Hpy6GCZhplmQ3JvwJKtjueg1YKsXi6mkmER7qm1K3HCIv1zbvZOkAgGZauSOotgyjdjctMy6Jirtzg3A8Mn7IgkNPOwJTfmvu+luzRktQ9xykS5yGViRFpqXC4/PTIoLB4gCQbHXs4ltnHJx/uyq2MGDIlYb8yF3UUoAWycNIzC8N4gQnfYGxbyzQt9Fxo2T5a2cz1geznS9OfXe6PlvlBtLx7opFivKd+Ecf87YToHmUTis4a1lMcbudRqsnTtEQUZSjbZG3UGV+eNB4djDuAC5qycErhLCdk5e+te/mQlMITh1hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8NxGobRpsh5xPZ1g2o3VerFNW+bLLgo0Tio1ZanrXcM=;
 b=vHVF/0nmh7r4WfA6j0kwO5NSm61L9BTLKyXxycnrA/LCJKV2nFeNfUNtwI/xGS6UVv2DImmOY3A8sTbsiRDYm4/RjsCBNW29jWhg+JuKLsH7M0cK7EfnTj9ZgyzeRBu8mTPSzl6Q3cejVUEB7fEXjzfDI1udJL3u03ZaJ8OHv9Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5601.namprd13.prod.outlook.com (2603:10b6:303:180::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 16:53:43 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 16:53:43 +0000
Date:   Wed, 22 Mar 2023 17:53:37 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: enetc: fix aggregate RMON counters not showing
 the ranges
Message-ID: <ZBsykS8b+antCVL1@corigine.com>
References: <20230321232831.1200905-1-vladimir.oltean@nxp.com>
 <ZBsw/SRtCgfadtlC@corigine.com>
 <20230322165126.23bwb4rnnbuuwlnx@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322165126.23bwb4rnnbuuwlnx@skbuf>
X-ClientProxiedBy: AS4P190CA0025.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW4PR13MB5601:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cb524c7-4fea-439e-37c9-08db2af5fe7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TTkWQjsUoXKgAXDoX/jLtHIAbaWksKrdMuZGZTjzHc7a1lMB3VMvzFH9GTVYvAENFL2k8h6fSoqHQ5xBraazIULdyFa2o2E+eek3hbMGq4BZNz3oIgBOdRcdN5wNSd34XVpRxgoaNkhpkuDBBJO4XvHfWAGXc7V/YsUrYcdBRma6KxusXG6TmXj7/Wcw14k9AY1H9Xo9Vpg6Hs9/DtSfj8xZ0ZWzvBBNg0xYlqgbaozBo1pL3mYXeNUNQjUTDfzJlclztp3vHqGulQ9Ii6YNxoYCFWK2npQTce1bGA/VvRw4YCVV20kRV9w8X84x5F8SZy9Tj/E7iCKo3hRTg6fVCBVI0ckaIv4Twmhs5kmO8HKDTpcbuOonuKaSJNXuY3VLNIZCvYIES7FJL7g6X2fZmvAqG2AVOYQJ0tur2QhhxZylsuPWOLbHsxLMfjiv89FhZ1w6w7YXB5FqRWtVy05ubwTpHl7hY1I58AYW56dmTpl9XAZt3xRaeeixEfqCbcyZ1v1GdJWLcm8INJQdxtQXMkxNA9+HPa30RzMYOG+o5S1ch1IyCY5brak8+ZcHvSjDFv3M7dd+wzMAKWJkpYHF/n9BqckD4fy3iJCgcnidGddkJgNNkf+bD0whwKGkBNMPIb5Cc+COvVL2FxxjiUw5DPtU+sSthuGniWPGPcajs/IegWHTkb4/tJASwNN97yb9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(366004)(346002)(136003)(396003)(376002)(451199018)(6506007)(6666004)(316002)(6512007)(6486002)(186003)(38100700002)(86362001)(2616005)(478600001)(54906003)(2906002)(8676002)(66476007)(66946007)(4326008)(66556008)(6916009)(5660300002)(8936002)(36756003)(44832011)(41300700001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LVA038B7TN1VS9DRZrEscZyL8/ZmvmA+oovhjqOTryZHSnBPQk4AmC0IPLDj?=
 =?us-ascii?Q?oPaukGHSofyWziV01MicaNb9QhxUEzWH0rXSjjbxoOAWPG+/KUzuZ3KiVSO9?=
 =?us-ascii?Q?8z226PIjJU1jTt0vQQfmpEi6QEuqbeA8/e8rhMAhxNLPW9kPURSIij/5Nxo9?=
 =?us-ascii?Q?vW/zREmaBd9RhAYbm2BFPOSZNAQeuZWaa84KINxRTJGqRQPvQGPYpyhMPXij?=
 =?us-ascii?Q?iIcWE9Gzmm5H4H24PJprfZQzb6hdOhkPtQ6X1rPPuCsXI70R7eLSeCBBsg0A?=
 =?us-ascii?Q?xtDNjsrCB844BZbgsyCvEmDcUgth7RqlW4Z3+N+dqT+08y/GnEGzIXiOOuwY?=
 =?us-ascii?Q?mQDYrAvhnZrZlpBQw9RAsb2ipo7jZ5jI6W2tUoc3/ZYCqgzE1tJ0BCq2kgdp?=
 =?us-ascii?Q?uFKXkYTtWUktaU2jPBJpmdeGFx7Znf5QU/CttP3Mi8/gT2AtsfHSrYbP2DqV?=
 =?us-ascii?Q?v15MYDu0C0vkxAbX8PV2ArOsAFQa+g/aIbCr8Z5cGJtRSK2r4maiA2VWLMIM?=
 =?us-ascii?Q?woBM+btodVN+/Jfjht91a5MikxNcWUseI8WXN2k9tA5II2tq4ehU3KxKfUPB?=
 =?us-ascii?Q?cNKWQNAuUNkV05amSm/wE8RAyCE3Df/943uqljuAh53zE5kX6F7OPZVqcmRm?=
 =?us-ascii?Q?QpMQkymd8uWKaQoH4C0k38gky7mW9ik7+lTOPA3Cap8kKd5PoNkSnytaWbkL?=
 =?us-ascii?Q?4mt6uEVX4PPxYziEwQEMXOepDJZcxcxAYPF1GAV4rfXEs+bBc5EBKiyAbTv/?=
 =?us-ascii?Q?gm/0ieDPnS/xAceJn6unQUWddxvcQ7iA9BLipxLC/D23Ovft4/159zV040Is?=
 =?us-ascii?Q?b5G0bpBgajGjqDmuoeEXbPZMOItGtyTDreFh9kJcWTmRc1HIWS/ylw8KQMHE?=
 =?us-ascii?Q?6n7e1FnFvuVqmQt7acmNlLyyCMS+s17atPNoqxlIE43Z1kMMctwG11tuhVwz?=
 =?us-ascii?Q?DOqY9yxpfmx9+mMpRNAak0lxdJKroIcpjJkyewQoTTziA9xXkGO23evjH/m8?=
 =?us-ascii?Q?HyWVZD0tv431yDhzXSW+YSf915z1BtGwWzl9VKlAKC+4OiHAHbAjaqI6cC31?=
 =?us-ascii?Q?DAQPoPZzxj6OnN/nSe3P0fmdDtWfMMpeYA8J/ESrwqzvJE1rjxD6p888SJJJ?=
 =?us-ascii?Q?T3xM/fL1R6ICnNuP4Tog9jUsyiJp9aS/qtIns2p1v4RmIwXgSsCl8WuSXgeT?=
 =?us-ascii?Q?Ocefc7UDK0QuKUbE7rU083UsTpi1hkgZwW5Jxy78H3BWFkz82zwawrP26kvr?=
 =?us-ascii?Q?vLTGxqQmdrFNAvnzhrnA798hmKrJv+WDcr0yuTZAIDxgFpcA+xVvdoZJG+ww?=
 =?us-ascii?Q?KwN5VFfN3R6ocVgNYb2jt1UYxDWozYhZpap2qd6KPhJl1M/y+Y84LBboz/Bj?=
 =?us-ascii?Q?Xu4wTcnyBRA1boOnYhrd1/Qqct8Kktx4oyOZ2bxiVpVoTjLn4ggZQ1PRTQ3D?=
 =?us-ascii?Q?uXuhnyeYVqyqRtW0KZ9pHN7gA3Z3ISKMeCS2U4X3nn4+fB2rda08byA6ET8q?=
 =?us-ascii?Q?M8BoMi9vzw3w6a1YBlrbFB5tJRpaZjZ3RVkDZrBZ6NpVosssvbYvZIJgI/sT?=
 =?us-ascii?Q?H54LXEH8Qkho6o3CyAiBOleMTWf5bSPpSbUiGiljZkRGbC174zjjFVH7tJDr?=
 =?us-ascii?Q?NDU5TKJdd+2wT6oW8tt3T4Z5D+eyZSTpqJlYjDG+B8F030aP7MNYvXIFomSa?=
 =?us-ascii?Q?uBi7rA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cb524c7-4fea-439e-37c9-08db2af5fe7c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 16:53:42.9214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +7fZfFkueZnBwIq07LqkhPzP2qKiz2tRHx5YuMxa9icZEoNTLrFQkU+Ke19fjkrxTqW24zuJbYU19f37DlRJrEfa/Lcmrakd+4IQQAhps/Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5601
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 06:51:26PM +0200, Vladimir Oltean wrote:
> On Wed, Mar 22, 2023 at 05:46:53PM +0100, Simon Horman wrote:
> > This feels a bit more like an enhancement than a fix to me,
> > but I don't feel strongly about it.
> 
> How so?
> 
> Since commit 38b922c91227 ("net: enetc: expose some standardized ethtool
> counters") - merged in kernel v6.1 - the user could run this command and
> see this output:
> 
> $ ethtool -S eno0 --groups rmon
> Standard stats for eno0:
> rmon-etherStatsUndersizePkts: 0
> rmon-etherStatsOversizePkts: 0
> rmon-etherStatsFragments: 0
> rmon-etherStatsJabbers: 0
> rx-rmon-etherStatsPkts64to64Octets: 0
> rx-rmon-etherStatsPkts65to127Octets: 0
> rx-rmon-etherStatsPkts128to255Octets: 0
> rx-rmon-etherStatsPkts256to511Octets: 0
> rx-rmon-etherStatsPkts512to1023Octets: 0
> rx-rmon-etherStatsPkts1024to1522Octets: 0
> rx-rmon-etherStatsPkts1523to9600Octets: 0
> tx-rmon-etherStatsPkts64to64Octets: 0
> tx-rmon-etherStatsPkts65to127Octets: 0
> tx-rmon-etherStatsPkts128to255Octets: 0
> tx-rmon-etherStatsPkts256to511Octets: 0
> tx-rmon-etherStatsPkts512to1023Octets: 0
> tx-rmon-etherStatsPkts1024to1522Octets: 0
> tx-rmon-etherStatsPkts1523to9600Octets: 0
> 
> After the blamed commit - merged in the v6.3 release candidates - the
> same command produces the following output:
> 
> $ ethtool -S eno0 --groups rmon
> Standard stats for eno0:
> rmon-etherStatsUndersizePkts: 0
> rmon-etherStatsOversizePkts: 0
> rmon-etherStatsFragments: 0
> rmon-etherStatsJabbers: 0
> 
> So why is this an enhancement?

My understanding was incorrect.
I now agree it is a fix.
