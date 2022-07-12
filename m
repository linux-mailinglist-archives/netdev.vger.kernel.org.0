Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7604570A66
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 21:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbiGKTLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 15:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbiGKTLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 15:11:01 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2108.outbound.protection.outlook.com [40.107.223.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A72EC2AE02;
        Mon, 11 Jul 2022 12:11:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fLNc0f5ugPszAhSozPCCY5z3HfBVFo7ko1hIa/PdjOTvGanJMJNY5cgIDX5ZjHlXQRQC1lJMeyS72YGGCO8Dt7M1neTZvU7WbA0KEypcO70ulsC/6N9WqMUwT9291A4qmLCuip3rclc/KcM6YlMak75T/Q1J+YkrO+gj0f88hp2QUvhQuGUc8CY9YuRUFwO4vyveRZgthhozVPd4RJCpSrCk/4yFEvmGgJG0ELRcFKqTCPa5g2UvB1uVwMOVxYodjnKa09o+HybEVa/ykOSlx3ikXa8v2zAvV9G1e2QwPlutpwbyXO6s1HnUdVYltM2cxpHwrfvDQcXpyAUX91Oa3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LZT9iE8j4PqTdzlx0P8deV3inSHqJ65f3WuNUw7i0VA=;
 b=n6RqQjPyWiDfcGuUb9G0jTbaj5mpZ8BuD3Qdrm/2i8M/JQWGjo0tfmIPxgJWU9A5vXatqdXQHl9qz2Zg5x8/U8cuZJcyrdQLZ5AeahXt5Rwzhm6QLisL46BqjQ03kSer/gFAZID5Orh913F7p2A1//DT+0KTjl0/al9HoNlJh2WXmAtc8KQJbZYJigQA/C9AawcMTIGePEwGRbpbzpRxsf6+bzMUobJffDRb7Too4WRp8mfR0kIDPZzFcJ5AVht/UJl8zuW5GBGI36OwWhS4XkVhH77UePj87OBq2JAMBDVPrjbh8jNIYpv+3AXP+dajLSKC65wHpqnKgOXst1vdIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LZT9iE8j4PqTdzlx0P8deV3inSHqJ65f3WuNUw7i0VA=;
 b=npHMKa7duiS2EblwEgTmQAHGoflBkgh9dyde4OkrA7Dpj1W+BjPUz1Mp96AQ2yaArjL6zFtrNvpbhDlFqCv4ZKCMTkzWK7U0o80Z+qQ+QEYSe8Ed4QyGUKiML5LENw+7ZDPNTd5oCs8Qm/HIj2zuieQIdM87vEDKQMYI4IM13ww=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BYAPR10MB2437.namprd10.prod.outlook.com
 (2603:10b6:a02:b0::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.23; Mon, 11 Jul
 2022 19:10:58 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5395.020; Mon, 11 Jul 2022
 19:10:58 +0000
Date:   Mon, 11 Jul 2022 19:10:48 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lee Jones <lee.jones@linaro.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        katie.morris@in-advantage.com
Subject: Re: [PATCH v13 net-next 0/9] add support for VSC7512 control over SPI
Message-ID: <YszYKLxNyuLdH35Q@COLIN-DESKTOP1.localdomain>
References: <20220705204743.3224692-1-colin.foster@in-advantage.com>
 <20220708200918.131c0950@kernel.org>
 <YsvWh8YJGeJNbQFB@google.com>
 <20220711112116.2f931390@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711112116.2f931390@kernel.org>
X-ClientProxiedBy: MW4PR03CA0052.namprd03.prod.outlook.com
 (2603:10b6:303:8e::27) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64e09eb6-c1ea-4a4c-68fe-08da63711611
X-MS-TrafficTypeDiagnostic: BYAPR10MB2437:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qrrecnuG3dsM+tobq/F2MvOYEepUeHpQ5j2f6T+1xTDMiuuKnaPhkxMhOyd+doNqO8vhHVoeitcTSW4aAJtrzaGQl7SQ6vQj6fCNjA21uIkVX2iGb2vS35kfC5ms4vgGSYVaksfBcIOuFltsTLDerDrYTSySXQSvsORq1kmEJotNyNwlY3fUhF+/v2yyBJHGG6Ja03Aa+D1IngvXwTteQikd3FueaoheQTVW1XgKnbWyGwXR8reFfj6goOisSspGebYNct5peFtSN8BupyGmeiOuaIFy4XSjW3MNyLqu6ng54p3BKKKMPeJSt094H5x1qIYhxTklcdYDnyLXrswfp8sE3Gif81Uc2ArOTyw4Rov+x/sM9oriSs76bHNybnOXdtfzN65PNCnAAYwEtChKXLCe7ZUECISfOOcI5yP//t7cVkJ8HMflsrJei9MSBkXKcqt/e3Kwfx4InJd/S+wkXBRRIh6t4/Qgb+YH4elc7fqRYcjHhI8OZf3763aEqj+s3rb+QzXZlRKpRLu6ckUON4z4BLpSL0Q8xnhb8CAV6F3fDCzdcBxc6Z46jWphftK+rmCRZWfD1ftkRgRGmUxxE57WrIZ4Ot1Z3lM3ceHcm9yd6IN4MVzMCxuul1pCuYllnn2rv3cQWXub3boNdmE7PzIAnCZ6TkLF3ksMsz7e4Tm/zxxXb08Tn4iDRelbbFsCKCHA/9eX1n9yvMfgXp9cq/zfT8L6yXAH2KQ0+RqNHLnL/nsgDbwrxguyWdyfTdSrqeqJohVQAVl/ZG7+BQB7JA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39830400003)(136003)(396003)(346002)(376002)(366004)(8676002)(186003)(66946007)(66476007)(66556008)(6666004)(83380400001)(4326008)(6486002)(316002)(478600001)(107886003)(41300700001)(86362001)(6916009)(6512007)(26005)(6506007)(54906003)(44832011)(5660300002)(38100700002)(2906002)(7416002)(9686003)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LTi/yKZrGzdhXfwtTOwAecDVmz0Vljrc/EN6ZcT5EP8p/5eD+UB2wI336WdR?=
 =?us-ascii?Q?7IaR6RhuOgxyt6mdZT9PZXXWMxpyohPGa65iFp8jH7Yx0dW7bwCMS/n5Pm0M?=
 =?us-ascii?Q?XQVuZkBP0JDHd2zD0J7MnSqHbDPwNo/XEMZZg1CmyqCBjJslCep73CVMeskn?=
 =?us-ascii?Q?xHXPd7r3G2hHmmrJDKH+YFaAowMmgJneNbSCNndr8jjlN46KFXa2S09VmopZ?=
 =?us-ascii?Q?udyA9s+gSljMlKWwrWof9PlBk4fAyNiLtzkrKEW3nlg+1JCd8D0oKTj6SeHf?=
 =?us-ascii?Q?A7fvYFRB3PjX8/pbQUuUgUnEqrBCc7QhQVV8dLK6Hj5UY4VdANP8CAFhi9Q1?=
 =?us-ascii?Q?DLazB2SgmaMymjOfy+EvzfczqM6oo3/2BZ1BeoyjHN8bjGgyiLM1zmlsjsjo?=
 =?us-ascii?Q?8L2r9j9jQ5P+p+r9d2uwXJp3WrbsaRZGS9318fPp5gn9zX/pyq71lcgBbodQ?=
 =?us-ascii?Q?SjzLCKZ2f52gOnLSDGhfey/RV5Rc7Mg3qrsOerZtNN4YSuUnX9Wjg9K1NiXB?=
 =?us-ascii?Q?kfLO0hs2ERpY+xU/ND4wxppGphwCWT8WenLSIdV9RhVcRMLM7BocfC/viR+z?=
 =?us-ascii?Q?dPI+Ovhkn88cgfOhSLqRKaSt4H0dphllkT1VLoO2IzPI5M+RZ2r71cLuZqHS?=
 =?us-ascii?Q?owm8tpWolGaqdatZs4W5uXkF8J2M4BdAhUS/ys0H29akXb6jlFYWQTCvQbP5?=
 =?us-ascii?Q?mOwj/rHony+2oMBaf5xbifzDGb2yh+aqyQbdBRZOLXV0TkSHKc9VLRPHqoIO?=
 =?us-ascii?Q?XrkgLKX13+sRyAvi6R04eRePDS4OFXw1sK0BwXy0yQ6WdyD5HWgxAoQli7xd?=
 =?us-ascii?Q?192DgJTYu1pe44bbSvbbrRQD1GwWT17kJWp57Us3mknppLIOJGbX0x50Kbfc?=
 =?us-ascii?Q?onds0OujXUULCvkjbAZDH3AAz/mMgU2rtjQJIwi6dm4Mnir1x5AW+wB0M3hE?=
 =?us-ascii?Q?6oAh85M8z2U8SeettxjdJfl47FeDjYHyuTIN2gIgo7NoqevpbgXhEAjaON6U?=
 =?us-ascii?Q?xjH5FyPZEGtvKn+/jPyojmhl1gZbRsRtYx4/YsS6lK/cT5CNyWDGa35XqdHU?=
 =?us-ascii?Q?O0CqTT7zkjXN5qGIZiq3U8Yl70KIdbQ3oz7FyORDowR6n8KC9R6oEgWzmqUk?=
 =?us-ascii?Q?EVMhzpIQLhG9YbO9VmR+ZbTkx/IgwWFsUKmN4WI+Z0yetBuLOGCckTycFr2T?=
 =?us-ascii?Q?mxAPRFD94bkPzKEVXf0Ocy0UK3t25O6KpvgqWaBhpcCMKy5de0MEk3MhtRI8?=
 =?us-ascii?Q?Fs+HNRN1VMW1RQ4BqvB2si8bMlRrWdq3ggW+ftj926PGZ7QCm9LqUHv4HTQa?=
 =?us-ascii?Q?wzLlmEpILwHhwDWx9m9l8BBQnbN/r+SAkZ28E24XAAnacNgqt0dGxylYs2Xj?=
 =?us-ascii?Q?oLNI8GxXHsJ1HTzSovg9LkNy0/2pZgJruE1TL6rp3a5lHdgJBua5Sy3Owtw7?=
 =?us-ascii?Q?oEGFQv22OYj2ZyYD06LizhEvdS4Ft+642SEyLmBbfJMMBf7DildlbNcJ/1iB?=
 =?us-ascii?Q?Fb1orCQ7opGJ3ZLvURhU7d1R2BrkoLQrNcy2y1WK+Pj6BL243QDxtrvkTv3A?=
 =?us-ascii?Q?OwLGvDC7sY0U3dNVclnYBYsIdP1e4jo04FjyaY/GQX/yap66LZLwptagbGKC?=
 =?us-ascii?Q?TUw11pXJZrZgJjT7+hapsdc=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64e09eb6-c1ea-4a4c-68fe-08da63711611
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 19:10:58.1384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nRsUO9RONIf0LiA+mph5uRuDCp/Y5EV2fjxRLKGJzKHxAcHT5KYLGANl9aMXgpPxgjpFjmgKz0CUlnVRLErfcsODIJiuSOP5AbwMyINCBJM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2437
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 11:21:16AM -0700, Jakub Kicinski wrote:
> On Mon, 11 Jul 2022 08:51:35 +0100 Lee Jones wrote:
> > > Can this go into net-next if there are no more complains over the
> > > weekend? Anyone still planning to review?  
> > 
> > As the subsystem with the fewest changes, I'm not sure why it would.
> 
> Yeah, just going by the tag in the subject. I have no preference,
> looks like it applies cleanly to Linus'.
> 
> > I'd planed to route this in via MFD and send out a pull-request for
> > other sub-system maintainers to pull from.
> > 
> > If you would like to co-ordinate it instead, you'd be welcome to.
> > However, I (and probably Linus) would need a succinct immutable branch
> > to pull from.
> 
> Oh, that'd be perfect, sorry, I didn't realize there was already a plan.
> If you're willing to carry on as intended, please do.
> 
> Colin if there is another version please make a note of the above
> merging plan in the cover letter and drop the net-next tag. 
> Just in  case my goldfish brain forgets.

I wasn't sure of the plan, but this makes sense to bring it through MFD.
Fortunately there's enough work for me on the DSA front that there's no
way that'll land before this merge window - so I have no objection to it
going any non-net-next path.

I'll look to Lee as to whether there should be a v14 with the header
guard addition per Vladimir's review, or whether that should be in a
future patch set. I'm happy to go either way.
