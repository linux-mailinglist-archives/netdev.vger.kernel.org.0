Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9E356A2AAB
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 17:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjBYQPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 11:15:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjBYQPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 11:15:13 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2099.outbound.protection.outlook.com [40.107.220.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2033A11E8C
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 08:15:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ePE+MHCxsXfcHoGjp/7Rvu9RsqlmeaVt37qHO76ssAQqgp2yDx9BwtSGjxC/gfAUUEibS9fUMpp54mMFeP3EPfc1w1IFpVijKSPBIfCqtceEXi3sFYziO5ANG7uYwutK5eUDfKT6L3Jjgvqa7X85MQdA0O5+ylYTiPFAgzepiP9w5cGSDIP74cuJL8/9lK0CmVRJ/BJG/Xb6ConC+XKoynQFwFnS1/b0dBZttlveKsUtTTjtCjHig7BvaNnH3wkitWvvEHAcTDhDxmhUMdEJxm28e0Yy38HlRiDv8de7PDy4IYbvWgaVSOmQfC1r7lmigU5M3ed3wLx7LvtPjvPvog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6+/tF6MdJ7vSbSGVSR8+6+I6yW+w5WuGxYVOqZvIF6U=;
 b=I+ro9Oi9BEPIAENsQJyaut+lQMWXp+lskBz8UfezQzKe3EktO9GHcImmUZHLb//1WJwGRfdM2uCy5w8AXTNcP90TKX06MOuyYAJ2D7MJK1EM1SCgKSp5V7LP7Umz7KIFmAbgxh76qp64xm3LbenUAqFKQs+Jc+TimPAudO9fy5RjaQDZn7Z1S/G26F/aVB5qrd1KltDgHkMqFtMaZ2YMXPYj5AC0SyT6yT0snuwLdJn+ssHl2Feej+L5TnsCL4B6PxQjmZ5bGrvj4tDk8GrMc0l8gzLxGKRnI3Rr1Sof6NiCX64Vg+xbRY+QlUGxhl5hDQk9KFbLx3u3GM/0N26fMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6+/tF6MdJ7vSbSGVSR8+6+I6yW+w5WuGxYVOqZvIF6U=;
 b=EqV7O/mwkLlnBavgGWhdBH1Tfb+Zw9q1XJ+N1r0ra3zQgHICNjdvHg+SzuocdWG2Dpv5BuulacQx5TiWc/kxxdt5bFfQ3ov/cdoXoD5ML9sQAJI3RhDbIZxAzPvBQXXL6HExC5ZjMfNUuUth8/5/58IP1L8PUi9VrlG3gafwUWE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3617.namprd13.prod.outlook.com (2603:10b6:a03:21b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Sat, 25 Feb
 2023 16:15:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6134.025; Sat, 25 Feb 2023
 16:15:07 +0000
Date:   Sat, 25 Feb 2023 17:15:00 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, amir@vadai.me,
        dcaratti@redhat.com, willemb@google.com, ozsh@nvidia.com,
        paulb@nvidia.com
Subject: Re: [PATCH net 1/3] net/sched: act_pedit: fix action bind logic
Message-ID: <Y/o0BDsoepfkakiG@corigine.com>
References: <20230224150058.149505-1-pctammela@mojatatu.com>
 <20230224150058.149505-2-pctammela@mojatatu.com>
 <Y/oIWNU5ryYmPPO1@corigine.com>
 <a15d21c6-8a88-6c9a-ca7e-77a31ecfbe28@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a15d21c6-8a88-6c9a-ca7e-77a31ecfbe28@mojatatu.com>
X-ClientProxiedBy: AM0PR10CA0033.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3617:EE_
X-MS-Office365-Filtering-Correlation-Id: dd073a7e-cede-4d96-f5f7-08db174b764c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9sQuEKfKIflbeFbzl2WSBiXmnisPNKamR6rNiLU8Qr0iammp4BOOzvqvm9Fjci9IBGgqX6tfKXYAd4GKS7A+KRvPvzwRUfILa14dbJwh6ijwYimqQPy3oNCECu2Kq+2ZQ9liu0VQF3i2AmnIRP93u2TfCT2nsfSKtJI9SzlGNd6W6wQcWpa4fHJkpGQsKIOYMDBqqI8zRLrmWwYxBo1kV7QVMABHIfEALwRw+AHTF+Sr5TL0/eowtwCpVvB0iyM2sro06qj2sA2IqdSz2cBYbVqdTK+w3tmeRwYmrMk8xipR/PfenxTcrV/I3DyROa2wtQedI6aRSjTU5H1B4Z0mkQMb79tE4YVjRMoFT6kqDZ5VEh33eNW/3sDR2HcGKCgoPc9mreyVhcehNMXNUbvp2+iOzcOWqwndi7JKNA5fVXxTBPryqMYjcNqL6RcSdE/9HOUtjvuh+IVCjsROi5hX1B8BMC/dD66K9WjqDXetBFumzJ8cprVmRRNYBGpvo+nJpYKO1McDzXHWizCBjLarw8hZOhPvZtnbPUEeiLldNg5tCKzxu5fGntn4cLYF9b2zW3JrafNJpuaU80yIGtlmUHU3Pe9gNfOcU0xZTIEH/p64nZC/LITU/HNvwAIBDtzOfiGcplEdGbSgpw9lALBMtg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(346002)(376002)(39830400003)(396003)(451199018)(36756003)(316002)(83380400001)(2616005)(6486002)(478600001)(6512007)(4326008)(186003)(41300700001)(53546011)(5660300002)(8936002)(86362001)(44832011)(2906002)(7416002)(6506007)(66556008)(66476007)(6666004)(6916009)(66946007)(8676002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IgBUJKAPhkMcb8KVaGxyGfLq2BHRDMQy4UdCOIaiWddynO9gy7856Iq7D5o1?=
 =?us-ascii?Q?taemx4Xptu06QlM1KbKqcxPcawyGVw9Rymz+amKYpNeNNGfQ8/KJ4EG9RW6j?=
 =?us-ascii?Q?20Ho9Xb6RZqeKmU1TdTN/woA3XbyQBC23rBpxVJx+oLCKDAiYwiQcLkDvYdf?=
 =?us-ascii?Q?+MMwXwUAYpCULvE063F0G2oWSk3dN2PAIJmr8Pe6tgB5EpYWtAHTz4OhhQHw?=
 =?us-ascii?Q?IoE2HdOjKj1j7LJAq+PGAiSIQ76sBbNb4E1YOGOjJz4xQIxFU+yqNAGTaXmo?=
 =?us-ascii?Q?urDNLnGbpTtv76+y6YITqyqnW/qp8eExy6zrh96mFbEw2oo/UBrJrvBMF1cP?=
 =?us-ascii?Q?IvPOvkmIkmQLjPPgIhu+wCZDhW9ZSwHvqdRsA39TRLxHZgiu3U3HB9uQNs9X?=
 =?us-ascii?Q?ir7A88WXZtGwCEmlV3wWbvS/KjOOrO+kKzuOKL3NloC/RaduDNBuILPO1PzO?=
 =?us-ascii?Q?AZtimcrguL62ldZdmukwn2ZifL17SQsMDEtchoQr8LVk7cq7zieyok0WfMqh?=
 =?us-ascii?Q?jr9z4hO7QESUN+Q8Pa/WfBqGuZkr7XLhm9zr9tRjCONesOZFLjqEqOEVFlXD?=
 =?us-ascii?Q?ovosO0YKopfSChhihDpUI/9vgqO3Agc75W2Uo64gnSGMWm2k7aD3xr4TuGuk?=
 =?us-ascii?Q?+stVFAX+3dDXsn9HO8FgasGDR151nSvcph1Cb3y0f5xp3OYl3Hkk/t5BERw5?=
 =?us-ascii?Q?BxrJ32A2hFPPZisrC0E/UUgim8VpQFBEUAJkSyfxPV9NY1z4uSOM1szb1r/3?=
 =?us-ascii?Q?kPkiTj0MND7ZFBvwe2nKT5/ovo1CCPOz+V3xdHhWc4t2vVdssTcjHVxwiXX7?=
 =?us-ascii?Q?vt+tqrTE5yCLnv4YawDOWRAHBqJlI4ZNiktSqU/4PMAxS8suS3YZWfpetpL+?=
 =?us-ascii?Q?PoQkujCgp3zH95sHpnvMT7i1g5Mybe6S5pAJwGFNTpfVP50tnEZCCqgxf9j8?=
 =?us-ascii?Q?iBAmS35/ThHAbGofLkB5RwfB8fKsYReWvozv+TxzOFZuRNQG5iWLCrWZCMvV?=
 =?us-ascii?Q?kD1uVGWOZ3EoTk1IGNMt/9Ts49X6RQTzpLTg2L97rAATI9sa/C+bugCoRktc?=
 =?us-ascii?Q?KInLO7b3Pi7B9GfwpXEbextLbqtci9l2XIfPPjDywbyNAMDloLfi43CLBHap?=
 =?us-ascii?Q?gKAwcSw45jjdJoM3moSJu/GwPEPLWbEiq1cjKisti5lEFav25EGQozEjz7en?=
 =?us-ascii?Q?sgvFS7VB67Z3jn/kZos7tNuFOiGD+BoshVPyFCn47GLkwgfuloOiFmNalENG?=
 =?us-ascii?Q?2u2igAg4SfnDY2wxW6Qv7YxTsBh/v+I8ltAvisXD1FHY1Fx4Int11+L9m3CM?=
 =?us-ascii?Q?Vi4Y/xd9mS2gFcfmy/gcYInMG6p9s3UbiwRkH2T97HcIwGzkc9pRePiHU0FI?=
 =?us-ascii?Q?n8RH+/ueMxlqTtAfTD4W1Oc8CMxo5DVXCeV7FTtnCP5YMQUTaKui5+yRsu+R?=
 =?us-ascii?Q?aBBdlhJ/50ugr/Em2R9NG1aIIrOFGShlLqCfijoUdYS+C1jpZT+a6as3Thlq?=
 =?us-ascii?Q?NF33Z2RfTetrlJI38UVedRbRps3fqZkV6CFoMv5x8xWQzi98jiwpLMWU2IaH?=
 =?us-ascii?Q?3dcajWCNYlWyaJWTQuMePWGQRmxmitIVedHQumyEWc8HqR4VyYfJNpg+ksFe?=
 =?us-ascii?Q?mJttfUogkJnnM8HnWeExKn5N8atyBqI7Bl60aowNeo/KKs5ajP/WJGArziv/?=
 =?us-ascii?Q?VwJ5aA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd073a7e-cede-4d96-f5f7-08db174b764c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2023 16:15:07.9048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dQXQtCWgUrcmMERU19HCqYym/GMez2+Y/ZuUDNI7JXhX8HU1ZlD06/+TjSkgsiHrKnw2ZwJWU1hiQsmmR4jjFCJiPqHZdvEcXTeJHGqE35o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3617
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 25, 2023 at 10:38:31AM -0300, Pedro Tammela wrote:
> On 25/02/2023 10:08, Simon Horman wrote:
> > On Fri, Feb 24, 2023 at 12:00:56PM -0300, Pedro Tammela wrote:
> > > The TC architecture allows filters and actions to be created independently.
> > > In filters the user can reference action objects using:
> > > tc action add action pedit ... index 1
> > > tc filter add ... action pedit index 1
> > > 
> > > In the current code for act_pedit this is broken as it checks netlink
> > > attributes for create/update before actually checking if we are binding to an
> > > existing action.
> > > 
> > > tdc results:
> > > 1..69
> > 
> > ...
> > 
> > Hi Pedro,
> > 
> > Thanks for running the tests :)
> > 
> > I think this patch looks good - though I am still digesting it.
> > But I do wonder if you considered adding a test for this condition.
> 
> Yes, they are in my backlog to post when net-next reopens.

Excellent, thanks.

> > Also, what is the failure mode?
> 
> When referencing actions via its indexes on filters there would be three
> outcomes:
> 1 - Action binds to filter (expected)
> 2 - Action fails netlink parsing in kernel
> 3 - Action fails parsing in iproute2
> 
> I also posted complementary iproute2 patches.
> 
> > 
> > If it is that user's can't bind actions to filters,  but the kernel behaves
> > correctly with configurations it accepts. If so, then perhaps this is more
> > of a feature than a fix.
> 
> I would argue it's a fix...
> 
> > OTOH, perhaps it's a regression wrt the oldest of
> > the two patches references below.
> 
> ...because filters and actions are completely separate TC objects.
> There shouldn't be actions that can be created independently but can't be
> really used.

I agree that shouldn't be the case.
For me that doesn't make it a bug, but I don't feel strongly about it.

In any case, I'm now happy with this patch.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

...
