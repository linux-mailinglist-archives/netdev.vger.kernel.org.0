Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B91A56E72AF
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 07:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbjDSFvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 01:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjDSFvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 01:51:12 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2132.outbound.protection.outlook.com [40.107.93.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB60E5FD2;
        Tue, 18 Apr 2023 22:51:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IzQF/CgJhZyD+Av414nDnIAeDIhzKwd7dKdaYXE4VC+JTLIHkyfe5aoAiuIoZu7SBY0gorf0TWcmrjAxq8c04PYJfveIqQ+YTfmEgSz6PlyhH/GoBxRyZM3gHDounCf800mRuJmATExA/0FG/sgk/wsAo3Yeuc2RdKueWOM3u5sS8g9zVPY0NGAYr331S36TmLCkmY5CJMqK7gQ92Q7YMhErXMMAgxwouoJ6K6MX8OZJ5DDml2Vumod2WPPCXfBfY+ClVgLm5v3TbcGXQlZZE2zApzsnM2u7XkhzJde9pSfEaLOiAN4roPI57ZD9VRbI/NfJdSSHyGAcoKWsZ3gvMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5dWf4Dl7jViZwaM4G1qUPctIrIC4UTWUnKSGPKIUkU4=;
 b=lEbrUrpa+9rapjxSfgXn/9iZEBQMtEihZr1lZIXpp/PYOAsGWkPuFR0smU6jH02brchBiMgphyeuLWxPcWIYX8nDcwDX8cIR2yhkyNEGAsZhr/gEhQr01dvu9Q3D4UelXt+W4hBf3L60py1OPKVGgVle9YTcAZC3sO4p99oYFTwrYhNPopDotTaJ4kcPuvzuL8tTr3rgKaiV3sE4yVhk54azeCwby7DLM+nVD2vrWdeEfLOZoKr9XJSpImxJ8T9w5gwqdfDGFIJF5o7/mHokxuMDCXGFSR2mrSTW4A5dhNP0MbjAJNs16UtieXRy9GPNmjR6u2kAHzcVCUdMYgnbaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5dWf4Dl7jViZwaM4G1qUPctIrIC4UTWUnKSGPKIUkU4=;
 b=LVD9bb9vo4jA+UYVrDajdWg5dIHh7qQ4juI+Yssw5WmakTqyoWf5Zi7MOIY/gYMb25ggxJ2LUgi+T+FKjGV0uViQ/SW87xanUNQz5uCsz5+Uf4Xd3DMKXlj6Dwtl3RH8FqY0zOULMRNk4VjKacfCfAyHbQbWR2WzanhL1yXwwGc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by PH0PR13MB5793.namprd13.prod.outlook.com (2603:10b6:510:11c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 05:51:02 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::d98b:da1b:b1f0:d4d7]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::d98b:da1b:b1f0:d4d7%5]) with mapi id 15.20.6298.045; Wed, 19 Apr 2023
 05:51:02 +0000
Date:   Wed, 19 Apr 2023 07:50:54 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Ding Hui <dinghui@sangfor.com.cn>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        keescook@chromium.org, grzegorzx.szczurek@intel.com,
        mateusz.palczewski@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        pengdonglin@sangfor.com.cn, huangcun@sangfor.com.cn
Subject: Re: [RESEND PATCH net 1/2] iavf: Fix use-after-free in free_netdev
Message-ID: <ZD+BPjGImmvwVd3G@corigine.com>
References: <20230417074016.3920-1-dinghui@sangfor.com.cn>
 <20230417074016.3920-2-dinghui@sangfor.com.cn>
 <ZD70DKC3+K6gngTh@corigine.com>
 <ff2e0a06-abbb-213a-40ed-20c8e8b2f429@sangfor.com.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff2e0a06-abbb-213a-40ed-20c8e8b2f429@sangfor.com.cn>
X-ClientProxiedBy: AM3PR07CA0057.eurprd07.prod.outlook.com
 (2603:10a6:207:4::15) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|PH0PR13MB5793:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d3ab707-c7ce-43ec-82bc-08db409a0ed9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PckZ4utMuxhNGN9HsuzIRirRMf3W/vtRMuCpeg46S3VmZaDD9QMt9YKDPIAp9DJpe0ISq4lCeTdvCp2P3/HFC9VV7gt14plZAXBqBIXpwTSAqtDamLwp5Sue6Xx10bpZ0fl0Fao3BV42FjoZEsvE/lNLHUIaz9NhrVrKrW2inGnW5GCMDJ3u2ckNdLN8DdKFeVJLJkz+CL7qJFnJ5n6a98wrVg13Y5m1lWLYAdjb65Ydettf78fO2/HK+lJ2QIGJSa7W9oz4eaCgIDVTFSKbE2MkBR5wAGIhm2Nq1yVjJS2BtPag1U7+nWXIx1rftJt5AqcAiTKQ4RsuJRSYScfZ46UbBcqA6RVA0YXEHca+Pqu/FGm6TzfrCBdyaRDQiHSsMcTJv5w6VRWVos31+rAc5GRsFAOb3UsOQC7tUrEOKN/FnNUBJZFNuoU2GqKI+K3gWQSEEYVv+PVmov7G/zO2FlugEiURQIOAz2eIaUV+bGhHfoPMxjWFYG0uINMRIS0Q32/ve6oboOL+Xw5GAlon2XdJoY+W5CzGMGb7jDtvm92GrwvJcmnE2fyXOGETmyXn1617MJwCek4c9HeQ3cphuGaCvvimicoV1y4+pre7NXQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(396003)(366004)(39840400004)(451199021)(8936002)(38100700002)(36756003)(8676002)(7416002)(44832011)(2906002)(86362001)(5660300002)(478600001)(6486002)(6666004)(186003)(2616005)(6506007)(53546011)(66946007)(66476007)(6512007)(316002)(6916009)(83380400001)(66556008)(41300700001)(4326008)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T4fnGLk57hHcpSvp8o/ZMd7USJFcklQrHR0H8MoiJBejT0VvfNjl4i77LLUq?=
 =?us-ascii?Q?pIAP54+pJOgV0wPx13xtW2Oh9LUhKnAGXmWKUFNSr+y8Ofz06JChrkb2fQ8F?=
 =?us-ascii?Q?aklbXXzgjdSNY9fLs8GYYJRxSR9mG0NRKeI+0aJGCCGbT+I9fl7YggmFuWNF?=
 =?us-ascii?Q?m1zgxfOtgVIhV8a1XnQKUIqyzZm0f4HBn/zdDcaDWpMGJtxIXAbBjlnKG72H?=
 =?us-ascii?Q?c6HPfKYFjHH0L9QdYT6xOuXoJB6iZrSD0z6rnZuwCW6NeLC01yOOd14dRWZL?=
 =?us-ascii?Q?acveaFAXg2Y+6U7C0RiIUCGpqw95LjfmQSGQ5MtIv3wC9RRlIkEyHU6F5O8Y?=
 =?us-ascii?Q?AG//t3VzB+t4Aom6ATo5ZssRU6Os5nV10cGizBgbZaZqVhG2ENRgglc33ebf?=
 =?us-ascii?Q?pXrUYc1n+YIeH+ZJz1EnY32Y3OTtJJk0Izd8gO0PYXxLzk54/TFLbAGXLZNN?=
 =?us-ascii?Q?tRooGhc2i9JMXiXvCZbXP9BW6jtxFq0AZ9jR2Mb527m86kD1s/MNGgrQ12Ud?=
 =?us-ascii?Q?P9Inf1o7fwMaXvZNaiBkuIG8NgIOJ7ZLBqFpmOJCQ2tdw8JQoVWa2svn1x4k?=
 =?us-ascii?Q?y/RZ18fQ4eGHB4vkplSDyzxJZ0hWxCA58OD/SccvXgzm5aKQQ34wjN73ak4C?=
 =?us-ascii?Q?xoDpbpytmNK9wSD0srF0XWQfMK3Vrv1kiKe5TAvEYv9piSsX0OwL3dMwTNQP?=
 =?us-ascii?Q?n2AkKar4if9tx7Kaj+trZ1ZAyqpUad9+sFuX5vb6koB8IEjb4i6panCAZbJE?=
 =?us-ascii?Q?lYBoRfiy2RJ+g5w8OncXWIx4X176PBkM8kwbqFwOxF2CruvcMqCHn4rf6vxk?=
 =?us-ascii?Q?cdmJwQfPRehz3/VSw4Rudbq7I1A2/3M7usyqBKOu7ulGwRmTgXCTrmdIwZVq?=
 =?us-ascii?Q?sSjtrM28xt+flgPUJjG0KfRgkSxsN7wGSU+1oMFkz41opB6MOMATOSHM0X+K?=
 =?us-ascii?Q?bcuqcR+mNfwEN6FPl3meP4nEsDfII70wIn1eXoF0W5dD57GycymqAm6P8h50?=
 =?us-ascii?Q?K54+KtAQaqrh4whIu2aS9G0sedZv21EeLjMtf/fI8e+tUkAM1PYgTA+ISQj8?=
 =?us-ascii?Q?1LpnkC2YKpOdZ6CvlMBn0ynJ443mQLDXYTIowGvAYcYcdrS6id6Ud8nbkA4L?=
 =?us-ascii?Q?BZY8qj0DeaWY+LKNUvOfceg7lkEXTGcr+R9wfjUWNkNIOqOZvu5AB2d4JEYg?=
 =?us-ascii?Q?3xSE0bsQKVP2vVpMGrnZ2Dxp43+IQr1tFoXlp4PM6tnwD0lhGB4YGLuRQi5a?=
 =?us-ascii?Q?1ApX8y6IZM9aD7cwz1hS65edi+h4UDBPgEABC9Ya6NpE+IBWRQ5jtt+yi5Lb?=
 =?us-ascii?Q?GGR17gz33Ru2MDXkQyno2rzhQUY3keUnUr2hloDjQweWQ0gv/KvpF7HiIHp4?=
 =?us-ascii?Q?cXx7DXTYKfrgEeWasSVqXcGBN9UzQcM3Ce56tGPvElq/6IpuTIzKthen9jen?=
 =?us-ascii?Q?mQyBImpGct9U70KfTq1IvlYwysYjJ1oEuROAJgAK0hDNHPLOpimYEobqxAnf?=
 =?us-ascii?Q?u9aLq4yEqFyV+pWXJ2yXytY+VZeh0YaxWR/duGSPgEzLNJdc5gP6X2kqAwy1?=
 =?us-ascii?Q?vWvvloSGzM28aNPR8ZKJg1Di02emByneClQOG7OC1OpPnCsKgF0H+5eqJjb7?=
 =?us-ascii?Q?A1DNh6DClXHntnO5mM4Q4rUq1UoRpGnaIUW1COWRqd9Yuz0J5cDTIZl7hn/d?=
 =?us-ascii?Q?hhv0tg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d3ab707-c7ce-43ec-82bc-08db409a0ed9
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 05:51:02.2883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0uv2OsaMkble8jF4G1KkDiDcmyzru55/6T4k+FwsTnaUqMzFrKqo1oODFS23bvARRLtCXT777QeEcBNwbZUhXfEk4Sprzb3hQl5UOkVJuCk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5793
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 09:11:37AM +0800, Ding Hui wrote:
> On 2023/4/19 3:48, Simon Horman wrote:
> > Hi Ding Hui,
> > 
> > On Mon, Apr 17, 2023 at 03:40:15PM +0800, Ding Hui wrote:
> > > We do netif_napi_add() for all allocated q_vectors[], but potentially
> > > do netif_napi_del() for part of them, then kfree q_vectors and lefted
> > 
> > nit: lefted -> leave
> > 
> 
> Thanks, I'll update in v2.
> 
> > > invalid pointers at dev->napi_list.
> > > 
> > > If num_active_queues is changed to less than allocated q_vectors[] by
> > > unexpected, when iavf_remove, we might see UAF in free_netdev like this:
> > > 
> 
> ...
> 
> > > 
> > > Fix it by letting netif_napi_del() match to netif_napi_add().
> > > 
> > > Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
> > > Cc: Donglin Peng <pengdonglin@sangfor.com.cn>
> > > CC: Huang Cun <huangcun@sangfor.com.cn>
> > 
> > as this is a fix it probably should have a fixes tag.
> > I wonder if it should be:
> > 
> > Fixes: cc0529271f23 ("i40evf: don't use more queues than CPUs")
> 
> I don't think so.
> I searched the git log, and found that the mismatched usage was
> introduced since the beginning of i40evf_main.c, so I'll add
> 
> Fixes: 5eae00c57f5e ("i40evf: main driver core")

Yes, agreed, that is the right tag.
