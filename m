Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C1A633B84
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 12:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbiKVLhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 06:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbiKVLgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 06:36:42 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2123.outbound.protection.outlook.com [40.107.244.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D5660E85
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 03:31:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qxft3+PaEApNTI810O3TY1zY/f1Q3DeQF10BpGftrOMeEdBUhgXFKn3DeFlxLH2t6ulwgseFvO+He/07tHEIPAwKQHvkZ066OVpQWKrIZQdh9fjl0OpXUb2sXva/7hyqS1C5UrgSMeGiaKN53dXxv0wg/byySe4hWRarkzLtVcMDCxE1uskQNybSlTXBYXuQj/Uxcs1a251tZfPlmFbIZIZMuUjm4d8MN33hIXn8Luc8/dfOIP//CECxDojuBpS/jkzihEUnAws/7LVn9yWFY1AAImSpjoazWP8QxP7ZCxGj722Z0c7uUWf3/tTGcaJ0vvPsSDfGymAzCJ0bATtmQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5GxGdA3XR7cFvGXMh+4bwNmgcJr9iNeE1gvTTOnqVr4=;
 b=Y9+S4hcTUUQX/1eM8oLrpBKT0whc0037MaOY3Y86rsoHjsKCfFc9Ag7Gge76cS2+Qm7zQREaXhzvSTEWdX6SWUGn7ZY6B9+Io9I5syGEfo6ZG/KMtoBKl2XM9DuSSB9HGwDz57P0zpayTR19yo+qAWvRPUIsO77b2KoZifFGpwBZIIdlrsQavlB2phk2qYJ/2l30/2tEikYryf/nN1FqNzlZlH/nThsP9ff6Q+pb1budANiHeiUNbWHhbDfW57vt/iy8jm77R8KGNYeSIu8rgLjjsDWRJe0wd5VJ4CQLREcxHJkDSMYLSumxBvxVdtqjcxtGMTreTGp2uL0nXGD5aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5GxGdA3XR7cFvGXMh+4bwNmgcJr9iNeE1gvTTOnqVr4=;
 b=aSL+xrDgtyFv1jMOHmWMNQvh0zAawzOQegSnjDq+mzOoAbDmcpG/c9JLXxyUXstyWftg9y2ux18gtP3F3O2RkEbUWHen1W4Ld8HcPAOOdjO+wEZ5yyGfWLLng4qypz2VxHleMI8/RL2FL0OB/kynKAVBBY5kr2U6ne2FZTbITro=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA0PR13MB3982.namprd13.prod.outlook.com (2603:10b6:806:9d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 11:31:23 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%8]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 11:31:23 +0000
Date:   Tue, 22 Nov 2022 12:31:16 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Marcelo Leitner <mleitner@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Tianyu Yuan <tianyu.yuan@corigine.com>, dev@openvswitch.org,
        oss-drivers <oss-drivers@corigine.com>, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [ovs-dev] [PATCH] tests: fix reference output for meter offload
 stats
Message-ID: <Y3yzBJ87Atg+EeAd@corigine.com>
References: <CAKa-r6sn1oZNn0vrnrthzq_XsxpdHGWyxw_T9b9ND0=DJk64yQ@mail.gmail.com>
 <CALnP8ZaZ5zGD4sP3=SSvC=RBmVOOcc9MdA=aaYRQctaBOhmHfQ@mail.gmail.com>
 <CAM0EoM=zWBzivTkEG7uBJepZ0=OZmiuqDF3RmgdWA=FgznRF6g@mail.gmail.com>
 <CALnP8ZY2M3+m_qrg4ox5pjGJ__CAMKfshD+=OxTHCWc=EutapQ@mail.gmail.com>
 <CAM0EoM=5wqbsOL-ZPkuhQXTJh3pTGqhdDDXuEqsjxEoAapApdQ@mail.gmail.com>
 <b9e25530-e618-421c-922e-b9f2380bc19f@ovn.org>
 <CAM0EoMkFhGtT5t0103V=h0YVddBrkwiAngP7BZY-vStijUVvtw@mail.gmail.com>
 <Y0+xh2V7KUMRPaUI@corigine.com>
 <ef15dc87-7e70-55f5-7736-535b4e0a5d5c@ovn.org>
 <Y0/tbYTy5Up9X1m4@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0/tbYTy5Up9X1m4@corigine.com>
X-ClientProxiedBy: AM3PR07CA0065.eurprd07.prod.outlook.com
 (2603:10a6:207:4::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA0PR13MB3982:EE_
X-MS-Office365-Filtering-Correlation-Id: 52ca5b36-e838-43ab-fdb9-08dacc7d159b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J5lai7BRGk0FQuTryuwxrYkz+4UuelKh5RfmavLrUEk3/dKv7qf9zSKa3d9Tcy6elow7Lv36n1G1ixJfVdhu1xVZzGo1BSlCC6c06HwuDjtJ0Vnw8W/jXd/bzpEZ2FFwTI5op5lnblpy03hlOkKEq+FirK+CSnT9+kNCZRtf6R9qTObiBab8uKgGkqTjzbCy7xcdWft58uDQp2PreQC5COvtSJcuVf1aNTkImOirGJDTzgwlcAYqTc2tY4uxnWpgK9IJfNZtxUHaeNEBosJZm9rl9KWmkIZngblnCgBMyaIdi1nVA6v18Bpq44R1j1qJZ1NgBiDXWD+ErVGs0RMfQHXgm3kU+cfxGMTlZbsA/XDOfBp6hn2omDeKYJovKpKjEYR67RhWcE+xBTGq1zaDgQLf8qAkyTCHNSH+OpktlVkrhZHt3+Hdrnwfc2ZhZg9MMGxSOwRfCJLSndG01Kt5UFghwuZi/ykG4UtmLNxgMXPfw4OnslE9I+iFMyAoecnQc8iSBXb3Gg4DI5pdyg9UClILSQ0nsYWHY9qGHxgAmfxVuh5s7BNnUOPpA6YGqHs9RGMLS0jd8lX1LM4bVmVq1orcEm/wnnd2M5yUKuuBGoS4tkWFcH/I9o8gb/oUtnpA/+KVfE4GI0abiDg6uPXmzBTN//yw3mizvBBsE9w8xKqL+tU3w+6PUDfQ0xb2XjuFr64Uduqf9aMuHhmtsxR/vax6+P+NBTdNBdbobFxMyqwRohNgLtFRT8LxsfLF0JhAXK1Yc4nLHtlJhhRNljV64w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39840400004)(346002)(366004)(136003)(376002)(451199015)(6512007)(186003)(2616005)(83380400001)(53546011)(38100700002)(2906002)(7416002)(44832011)(5660300002)(6506007)(6916009)(66556008)(54906003)(6486002)(966005)(8676002)(478600001)(66946007)(316002)(6666004)(8936002)(41300700001)(66476007)(4326008)(36756003)(86362001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?252suAThxKpwS17MwSi2d+wAO6ob/r6v2ATs0NuH4oBHw1loqXVu/qq9VjkQ?=
 =?us-ascii?Q?kDUuGkAksmqmkRbuFsQxFg7l49gxI+Fg5VhWyVf+yFCsSsYdc7hsOAIeWefS?=
 =?us-ascii?Q?VRoskZcAeEuHLIGjKehr3QuEiANfFjusq6rbe1+wgT/YoB/d4h4iXqgXlEUN?=
 =?us-ascii?Q?lHX2JlyTaMbYvjtoVHqdrQr6DaGP9s5yRMWCzx/gyPynOAXlwezpgFWaVSou?=
 =?us-ascii?Q?n5hypUZmTbhnNhrLi2MNK/wBBSfwDnUVxJOnE6LSKrlxlUlxIE6bI9PBHu0D?=
 =?us-ascii?Q?ki/LznhXx2ECaCmFgQqobXYAsDi3LSTk4zF7EI0DFAlkuDFoo+wcTFmo4v2X?=
 =?us-ascii?Q?4R57UrsKdipQKv1I0NbvkScthTxoaIAs+WXPeisBAA7yevSoT2nW2OB71q6C?=
 =?us-ascii?Q?NFg4/LUz7CsymOKHkgUDlZ+nS1tJBb7VxOGqTbSClaayXuh0i/VSOP0Zjt3X?=
 =?us-ascii?Q?OfS0ZnrcyTqXFZBXU0W0gi21z9fX+Wtnz0CZIi3Ynf4m9HWJFKC0MsNrLbSu?=
 =?us-ascii?Q?D791Md1MRGvXDN9Gg/CGioG0lcjz9fKKPWPwppSwyPAve1rC6DWQpcL3bBpg?=
 =?us-ascii?Q?UaquDEdYb8Nobk/YngSLIVHo0goA0AB/cpB6F9CUQEzZMyB9rJ5phEP3JwpB?=
 =?us-ascii?Q?XvhqaGChlbdS2Q04whl/V/xDNXiDNAbfHJirGsYId1FzyIk6HxIKVfrnnthJ?=
 =?us-ascii?Q?mmgYFnH3tspL0A9Sa30l6TcSfdMxwY5zeM7w9hivOINezvGiZwQ8GdAp9H+b?=
 =?us-ascii?Q?f0BjLDNFCq+8b9RryszurmCMUVyoRH4/KDhWG+fQ0NqBYSEM+CkwTboe0Zks?=
 =?us-ascii?Q?nXHGiRs9xLFdym2asUhnQp5fESbEq5cDSITGKH6GXpPq2sElsruHvjlGUwMb?=
 =?us-ascii?Q?k3SrcXB/h+cDRYqqE01uftgrbyWApmgMPnTtPvjlzBwUfLqDfKqo/DsCq20Y?=
 =?us-ascii?Q?Ns/xSWtHSYnkLe8g/e8B8u6shQheH7y6ZOgXFlB9B9NVryaYIuAPY03O8oWh?=
 =?us-ascii?Q?WXSTHzISN1fCHPm75Uouy0diILcxSqp0IA6NoaZW+c+BEfK6ohcEjCOgAgjy?=
 =?us-ascii?Q?hImeXron3v/m8Ilcuj/4vqVrvERmZJ9UW+nbVHwQOO1eYpqy5EInjIXwBWGn?=
 =?us-ascii?Q?yUIOcFY6sqtx6FaX85rfu7ZSxwKhNZKRf1q5QDk7gQXI5fRMqX9v9nC+0Eug?=
 =?us-ascii?Q?lSFIn939TBgJSQ1sq77MkLi2Sy2ZKce8MqJpF+FTuy9gDqsouTr83wre4tLe?=
 =?us-ascii?Q?+BSHIojtNJ8yzeUBXQTkMw/zSh9UbM1gUUYoguQm5KdwCgK7gnpBiZymcPtT?=
 =?us-ascii?Q?+MUe8gawNnXeCppohkZY8n18pU1oUj0wcoPlY9F+NH8eEdN4696bkbglyhnV?=
 =?us-ascii?Q?AjiCC0cROvcG2UfyOvLQ/1niyHOPiIZThA1RuQiEPkM8CTs6rylcvZv+Z1ct?=
 =?us-ascii?Q?pCpniBcOKSbTbPgqn5xZ3DgVx+lVO38sTms9COlqUojE6Wh3xrTyQlwRa2qf?=
 =?us-ascii?Q?u11gdt+ZA90zwMEv4wqdLIj3D70ztjcHgE3Bi8bZn5Ew1DjR3Ot/+tKAQT1I?=
 =?us-ascii?Q?QaxYyeCjddOQshYs7zCBEPAJs9ubAiy+Av/alpM2oVMr3LEi/Z91vZiKc758?=
 =?us-ascii?Q?8yFKDRTn8wYfejBiwqfsnpCpIux2t7SkTIygHp4o7i2Ru5GgSZhvn+Z+CUSK?=
 =?us-ascii?Q?+OD1wA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52ca5b36-e838-43ab-fdb9-08dacc7d159b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 11:31:23.3744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rwd+KotOgMjAgkYYwTNm3LMvdYvOr/RpM+UeFCutEEr9fR0LLfL9qrjd9diMkaujqU2fT+s6K1yPmRLJJfMe8nWmGb5Au9CLi2GHkdC7dSU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR13MB3982
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 02:28:29PM +0200, Simon Horman wrote:
> On Wed, Oct 19, 2022 at 02:17:42PM +0200, Ilya Maximets wrote:
> > On 10/19/22 10:12, Simon Horman wrote:
> > > On Fri, Oct 14, 2022 at 10:40:30AM -0400, Jamal Hadi Salim wrote:
> > >> On Fri, Oct 14, 2022 at 9:00 AM Ilya Maximets <i.maximets@ovn.org> wrote:
> > >>>
> > >>
> > >> [..]
> > >>>> I thought it was pipe but maybe it is OK(in my opinion that is a bad code
> > >>>> for just "count"). We have some (at least NIC) hardware folks on the list.
> > >>>
> > >>> IIRC, 'OK' action will stop the processing for the packet, so it can
> > >>> only be used as a last action in the list.  But we need to count packets
> > >>> as a very first action in the list.  So, that doesn't help.
> > >>>
> > >>
> > >> That's why i said it is a bad code - but i believe it's what some of
> > >> the hardware
> > >> people are doing. Note: it's only bad if you have more actions after because
> > >> it aborts the processing pipeline.
> > >>
> > >>>> Note: we could create an alias to PIPE and call it COUNT if it helps.
> > >>>
> > >>> Will that help with offloading of that action?  Why the PIPE is not
> > >>> offloadable in the first place and will COUNT be offloadable?
> > >>
> > >> Offloadable is just a semantic choice in this case. If someone is
> > >> using OK to count  today - they could should be able to use PIPE
> > >> instead (their driver needs to do some transformation of course).
> > > 
> > > FWIIW, yes, that is my thinking too.
> > 
> > I don't know that code well, but I thought that tcf_gact_offload_act_setup()
> > is a generic function.  And since it explicitly forbids offload of PIPE
> > action, no drivers can actually offload it even if they want to.
> 
> Sure, but I would expect that can be changed.

RFC kernel patch posted:
* https://lore.kernel.org/netdev/20221122112020.922691-1-simon.horman@corigine.com/

> > So it's not really a driver's choice in the current kernel code.  Or am I
> > missing something?
> >
> > Best regards, Ilya Maximets.
