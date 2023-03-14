Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD8116B9A20
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbjCNPoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbjCNPoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:44:07 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2105.outbound.protection.outlook.com [40.107.92.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5DE8681;
        Tue, 14 Mar 2023 08:43:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LtZRCsVqsK+PMfFIaxv9ejO1Jyxat5oYWa+ST0BELZo0IYzcgRHpRrrWbipfXUnF3N85ZLNJ8hYG+w85W9Pka5pvl5VXtbz2Kr5G8BDd7dmJD7wNWr42alZhHzOrW3gduo/mG9PvoHnM/tTPT5BdPL3GhgEvX5k4i3emRAtMPOp56lzGLPEADL++a9gVmfEcnhXLimptr6OFBgb1TwwTlWAzmC2l+ZMYIiJpQHDyTbJJGQ00P97t/UT4ffgpZzrQAjc3n2S4ewaNThXTuAzu/Cvf4JBhF0IGYOuW0bMlhb7jR3rGYLIl21CjFZ8eJpu348D6QroIwbwRDYv/69foDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uBpcmQW6cYVv8wkjY5jvaWM+C5WcYsp+sXUUxMsyLSA=;
 b=Gw9rQTc9UirzolFuvyoSlf2fT17ZeJawBwmHK00GBNyBwRBII6TbYzYzE2S0+0bS0nabXd95UE/1IITQz8HhSB/ybzg7mJWjRqiroh5WTykzopAZEE3BoNSiao4CA5g8EyjaMXta2Kbdi18Up0Oouk2wlAR7ryMrHx5FPsejolHuG1xRp8cGRJqgf5J8UKXk8HLw2Rzlt5F2Rfp07v8w1Dxx9J44GUACzTJYAA+1qeunRiJhWsDjf+u4O2Vv5I5Rxp+mU/aWLnwyldJFsx/sHNVDwiVo+Hn1jzBnMC56tUCdLTuZwwr9VwvbfT2tt1coOSAylIqBFOXyupUR4pF3Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uBpcmQW6cYVv8wkjY5jvaWM+C5WcYsp+sXUUxMsyLSA=;
 b=khBRAPBnrBd6Q2URDex33vQjCbnwSlca/SwfxLTjMRtUzlpDHNtvLw64Bh3iVeCsTznuxgkYRLlRTkwD6vv6NnuJAFo7cR+pWF9PVqnDcyhVbfoqFUMzfFOHwkLxUZiTNWUT1p2K6XWcLcZyMaxaIsX5aHOxepOC41Wnn5JyMPA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3669.namprd13.prod.outlook.com (2603:10b6:610:a1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 15:42:50 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 15:42:50 +0000
Date:   Tue, 14 Mar 2023 16:42:43 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Gavin Li <gavinl@nvidia.com>, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, roopa@nvidia.com,
        eng.alaamohamedsoliman.am@gmail.com, bigeasy@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gavi@nvidia.com, roid@nvidia.com, maord@nvidia.com,
        saeedm@nvidia.com
Subject: Re: [PATCH net-next v7 4/5] ip_tunnel: Preserve pointer const in
 ip_tunnel_info_opts
Message-ID: <ZBCV8/IFqiNr8Hr1@corigine.com>
References: <20230313075107.376898-1-gavinl@nvidia.com>
 <20230313075107.376898-5-gavinl@nvidia.com>
 <CANn89iLDUR_3pmxco47VQkvWweq2g4Og6UhtLN1gQMQiCUy2KQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89iLDUR_3pmxco47VQkvWweq2g4Og6UhtLN1gQMQiCUy2KQ@mail.gmail.com>
X-ClientProxiedBy: AM0PR03CA0059.eurprd03.prod.outlook.com (2603:10a6:208::36)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3669:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c853e79-7e42-495a-2b41-08db24a2c457
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gAwJR6mWm+m+nY5fCps+u5CQZYTYgAmMwZzybz7oJTdL+2Q+JWkh9TiqrLMzcFpkjGmMqdB9ICFFOpSbB0mkc9G575XZAHlg/3hbpl0TAKlDV/E6pYiHQfhFYBdwrrpqDSADr/Y2Jo3PBygZhtAHwR6frSzT01bs+nleA3tbu8UdQ2zm7GZm4lQHndV4oDByiEGcJxFyd09F41KR9uzfyI6uVQbtsUqnmFvWoNZuHTiQ/NeB1cKL681mGLbTQHb5SBtnzxJkq6Y9FRY+KLDPXWbJg/u9EBx/CqjT+PchljNyme63VDeY8M1iP/zJPU85UC2CRLZ+/Q/2Nm4C7c+UO4rMiHSufRqajzvMO2dpNSGUn2Vd6hV3OV40C/DwuHpavWeP2KhwT+33IEdWLTjFzEueT8uk/AnTObKT8FwYVOSmOOTU6cxBASmcSDw6rykMvAiyqJ7sdGNoqbZn7Fju7YrgNYCPaEeQsHAUFk8gOSxeJQ04qoVYtgArGUQyjCjdg2snBvupE6PcCYG3ASvyBO57yResXFOkzBrkfC4WOYGWqQppHp0ED1dSime8M0htRd7u+dSZf/Q+vBBAqSNg92YMCRGt9xzUpvDlDuZpmu7WBGUC4XyqnUOsI6L5jNVhBe4fvalwPn7hpySP7BQnoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(396003)(366004)(346002)(376002)(136003)(451199018)(86362001)(38100700002)(36756003)(478600001)(66476007)(66556008)(66946007)(8676002)(6916009)(4326008)(41300700001)(8936002)(316002)(2906002)(5660300002)(6512007)(44832011)(4744005)(2616005)(7416002)(6486002)(6666004)(186003)(53546011)(6506007)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OG9INzlxTVFvdURnaWZ4RFNGQ096SkdnMkNjeitiSTM4KzlFRDFoWjkvU3RS?=
 =?utf-8?B?Y1R6Z05DYVFLeTQ2eUc5Vk5uOHFUeExqbkhYM0E3a3UzM2did3ZZcHhJTVIr?=
 =?utf-8?B?NXVRbDk1WVlIdjN4VThSYndWaXZ1N0VBL1M2ZWt1bkNHai9WamJKVkRCMXYr?=
 =?utf-8?B?Ly9PdHlUYTJvb1RqTnVPSkNpWVRpMXB2dldlYjI4QU1xaFo0MGdzWGNUVlhD?=
 =?utf-8?B?WTZoRTF5Z3RXVERYZDB2bHZoelVMTkZqc2lpYXlUdGR4a3FSeUs3Wkd2M2Ex?=
 =?utf-8?B?bFJTM05aY2xKSmc4MjZTeEVMeFI4NFMyQ292d1UvUlVKMUpQRStuYnNRUnll?=
 =?utf-8?B?M2V1SWgwT1R3U2g0cHo1L01IVGowM3NaRVVYaUMrSVJyU25aNDhPRTNxWVRS?=
 =?utf-8?B?KzhIOGJWa2xHbUx1MzhrMzg1YTRuQ0lUYjNSSEYwMzVXRnpubkw0RW1iemZs?=
 =?utf-8?B?UkJkSHFNbTh1RkZRRGJsVmdXYmJZbmo4WG1kSWpXbXY3TVNyMk1yeGtTdkxV?=
 =?utf-8?B?b2RQWXFJeDBhaURySEduOVNZQmtFQzhZZVpPN2xlaXNTSzRRTFBHd0JZcEpy?=
 =?utf-8?B?TkN6UU1qOERQM2JVNm1pVVFaM0I5VWpLU0hNNmF2VHlqRW9nUnFrU2tqcElE?=
 =?utf-8?B?S003NGorTFpmbHFJVy9Fd2dHVUJyOXdjT1poU2MrOElHYThxT3doTFlwaUxs?=
 =?utf-8?B?bVlsOFc1ZEhOaUFDcHJhczJqYnVCbXRPVWp3K0d2QktraEVtTllha3Rna0pF?=
 =?utf-8?B?d0w1ZDhXOXp2amI0bW5UbDUwcFdCek5yTTdaTHV1bkFLeVlxQ1BZODVKaURo?=
 =?utf-8?B?UU1yVkxGTlA2NmJJbmh3V2dXRTBSdjEyK3VvKzJUVWZWS3Z4b25Wb1YweHl1?=
 =?utf-8?B?M3d0MmRjQlJ0MEUxbkdwaGNnajJBekt1c0RZc0hCQnowdmlvSWRjV2N0ajhL?=
 =?utf-8?B?VHIybmpEd2dVaS9ZRmY5RmVCaUkvMGd2R2dvV3pKeVdXOERFdVZEMFVyOFZR?=
 =?utf-8?B?azc1YkhMeDRUUmx0ZzFOeG5VVFhEMkY5ZEw4UGNxU3g5Mk5wQ1I3TTY3VU93?=
 =?utf-8?B?Rk10NzNuK0pnUXRVRk1OZGZ1K2lldzYwcTJUZS90NS80TEFjY0tlRy9VZHdY?=
 =?utf-8?B?S1lWSGpLcGxTYXNJckd6QmRoNTJ2V2h6LzhTNDFLVGFJYXM0amdIU2VGVnV0?=
 =?utf-8?B?cnBta3RxZEdKVmVtN05YOEJPMytWVW1OQmVhSUN1WEVOeWU5VHhTQXJrUDlv?=
 =?utf-8?B?VE1iaVdzSnBaOGxBVFZTSjdWVFV1MkoyVUJTUGdETysrVVd0Mm5sSEhBSEdY?=
 =?utf-8?B?RzVSS052YjNBV1BUaDM1QTlTT09ZYm1KUFAzVldOQnhYY29OR2dibG9YU3Vy?=
 =?utf-8?B?cDh0bUtlZkF2dm16ait3MmNYbkI3bDdmMm8rN2tKWmllV0pwVlh4SnNZWnlC?=
 =?utf-8?B?S2lOdjIyWkt0TDdscElmYTJoclROVDNTOWtxaFlNUXNrc2Z0ai8zNitZT3I3?=
 =?utf-8?B?Szl0SE92QTcvN00vNUlQVzN4enZQVTJPTDEyQStneHVHbkhYMk5JaFZINlB1?=
 =?utf-8?B?Y0lvcktkYnpNRDRIZWYwa2JORzJ0UExHbU9HczhjKysxWWJaZXhTV2NtZDg3?=
 =?utf-8?B?RGRGYmlTb0Q5ek94SVpRV1J0LzRYTEUrVGFEVUFZNGRVZDZld2lvNHlnZmVS?=
 =?utf-8?B?NUxmTHRvU1R6dDdjVm9yTXJaQzUyV2pwM2dRVVAvYTVvc1V5YkNNODRrSDRp?=
 =?utf-8?B?bUd0VE9BWUQwNG9XMWNhQUM0VXRRRnFZdEk3M1dhOXp6Vm1WKzJtM01wRDEx?=
 =?utf-8?B?NFFydWlnTVF5cWdEQnd6a29rOGJFelUzdzdHQ0dIb091SFIzS3pNSjhKL21k?=
 =?utf-8?B?VVdvOU5jVXhRL0IxNGNQNkZQNXJRWDdkQ25nV3NFc1Ewd0NOTVNEMm55MC8w?=
 =?utf-8?B?aDFwSnF5b1hIMWpHdklhSU92bmxFYWFYZFFhV3NEbENSdnc0dzVuMm9URnQ2?=
 =?utf-8?B?WkhsKzdyYmZ3Rm9BZVgzN0V1ZGhZT05YUmYwSk9yK0dtODRtbHFob2lvQ1Vy?=
 =?utf-8?B?aVZoSHpPM0g2cU9SNUNPNk9FV08rNm9nbXE2dUVLWEFpbkFiNUdLNmRaMGFh?=
 =?utf-8?B?enpmM2tuckFPM0lqTnBiY1RRYUx2V0VzeG5XeGlQMzYyTkxndFhSaWFCWVIw?=
 =?utf-8?B?VUlKdGFiUzRoaWQ3YmZEcGRSQlI3dWl0eEw1VEx6UlRsMkIyZk5TczdLcG5V?=
 =?utf-8?B?MUcrZTF1cHN6MkllZ1VhSm0vY3RBPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c853e79-7e42-495a-2b41-08db24a2c457
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 15:42:50.3374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Iph4gvwH3P4a9w7zRUsYQ9zZgimeBlozzj2AT9d9Wv2sZBFLt6vmlFzdE/qqqZyQRfUEsNRDX2aT0Aet9CBreX36sUtzrflhP2VZ1PgTss=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3669
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 07:57:23PM -0700, Eric Dumazet wrote:
> On Mon, Mar 13, 2023 at 12:51 AM Gavin Li <gavinl@nvidia.com> wrote:
> >
> > Change ip_tunnel_info_opts( ) from static function to macro to cast return
> > value and preserve the const-ness of the pointer.
> >
> > Signed-off-by: Gavin Li <gavinl@nvidia.com>
> > ---
> >  include/net/ip_tunnels.h | 11 ++++++-----
> >  1 file changed, 6 insertions(+), 5 deletions(-)
> >
> 
> Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks Gavin,

this addresses my concerns.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

