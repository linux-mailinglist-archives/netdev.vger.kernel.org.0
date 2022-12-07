Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF2964526A
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 04:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiLGDIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 22:08:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiLGDID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 22:08:03 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2135.outbound.protection.outlook.com [40.107.101.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753E945ED1;
        Tue,  6 Dec 2022 19:08:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UZBbRLfpot5VhnsGONTF8EefuqJm1F03zgcV6K3nvSXIKg1QhhWBpcaQSgKVDXEftUnLh1rd1DG0Yyl24AXjZuyTG4xjdPmtKK8b5nbpL7u1hwuKq0O7SBr4tQySy+rHWIkAc1tMn4DS2nkFyJcN2CuSS5ApCYGwWL3OnxwVT2fPxcHmzMeGtZzZrVH89Zar4SQM6W+4fgXLKWzEk/gANsQEgIplwQ/pgt9T9luszMwHTfbhnlR3HajLXzawfaB5FopkTpVJbizIZj47Y4G1DBBpg5lksxweugo0/qE3OjUDc8J43vLmuXDtacNLTPscDiIZwpBchScEtNnvREfAug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=45IvHtrLuqXUUc5pLs7h4y2lqgRg7nDEmt6hlkzR3U0=;
 b=R4yuxMpwGqX3X0yXIT7ciDtFbPAFS6hOuJVZfaO8jFkjzK3xo/1C/fj5+YaG5YTH+WLzf72rgX36Ceg0XT8E0Tb+AXexliGH4LY4YQalrDQ2dZZ5EORhMzkry+7+9/za+YWlp1CNJDA5i+UsyWEviGwxD2LtiCAApxOWFNF63ZoDk7beWOL64OeIYuQPCzGe9znjTqq1bzsMXo9G2e/tLVE/VYE6Dhe3/jT0Cf2TBaDpOXuqE3drV/QqkJlxcUR9ekuBkK8uE4nJj6Zn+zD4XCi3qxw5e3VKCuV3EIgUZ2Zn6LP7WlNAbgGLIv3mOlMruq/B77BzIh68X7QTe2Pzsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45IvHtrLuqXUUc5pLs7h4y2lqgRg7nDEmt6hlkzR3U0=;
 b=IxJ4JKbMb2VXDTuU8sdeEW0mPAMUVpundtfTlt0G3BElj6neNmyy4evkOdxF8jtJKx0nbD9EbZ8EkMlMfR2RKFVFf56EjEIZeLMDdc5OLYWMD0cxZer1JG5BpByvDkazxVjA+2HsEe4jJgyZSH5YzbXsW5LgGKZqrbUTEMJ6O1U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH3PR10MB6714.namprd10.prod.outlook.com
 (2603:10b6:610:142::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 03:07:59 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5880.013; Wed, 7 Dec 2022
 03:07:58 +0000
Date:   Tue, 6 Dec 2022 19:07:54 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?utf-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>
Subject: Re: [PATCH v4 net-next 0/9] dt-binding preparation for ocelot
 switches
Message-ID: <Y5ADis5/a0KrHM10@euler>
References: <20221202204559.162619-1-colin.foster@in-advantage.com>
 <20221206160430.4kiyrzrumcc6dp2g@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206160430.4kiyrzrumcc6dp2g@skbuf>
X-ClientProxiedBy: SJ0PR13CA0094.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::9) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|CH3PR10MB6714:EE_
X-MS-Office365-Filtering-Correlation-Id: 26b15179-be9f-46d7-e5ea-08dad8003e76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /MIitMwGrAxES/8j6sAvzm4gJJL6E16KVd8J6NfQWHjL5l0p44QGo39esI5+qhi/16DgvXamWoFj1MSqnisr/59TFrEqMUPQAjv757QM/i5267hEac5Q9zqLPiyT36gG6w45BM+D5hD7a2bCn9G1Urem/Y3TZmQZdZ58ndMKbxNICQShl+tOEqzzligOH+UOsS5Qm4fDpTd6CvruMk/aZRgQ1ZKgtc5rXjG+3bR6WikzVGR4xAHp5BavOk4qGj0JdckAq3ZaVQBtlGGKRg4jIR7LTeGnHRhAWsll3fKW+cQJfgU7FFamG6Vuh1iKBRnrMDTPuYoijlU5QWw8iRERw3OOHHvleUzFsAc0rTFWyfy4FedkEpTGs6yzQKntsM2MzV8VUdf1Ex2Gh5ca76A8OxNTuzME07hjoFlEST/zXAdn75S+8w0wFrlFPWhZAbFvkPOVGuQ2nwES9tUJVc4uCYSNmduhlVmH/b9mzZt+9YQhp1KX9VExtqOm4athavY0R7XhaeqM1Mb5uJKSf9QuCEoMyHtX/0lrdxFwmGcVLTNGFSzFtqrOPX3NO/xhF7tCbLgK0VSBLSYwfb5uhguYELAfIBzNxmpi/9uSXmZ31Bw+KLXiIOWKy1LjDhDvF8NK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39840400004)(396003)(346002)(366004)(376002)(136003)(451199015)(2906002)(6486002)(44832011)(41300700001)(478600001)(7416002)(8676002)(4326008)(66556008)(7406005)(86362001)(8936002)(5660300002)(66946007)(9686003)(66476007)(6512007)(66899015)(54906003)(26005)(186003)(6916009)(38100700002)(6666004)(83380400001)(33716001)(316002)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1NmU75uYeVvdJq4R538uT7lGO9MUBjTU2TwW7SJHUQorEexZoAYf2KZP8Tbm?=
 =?us-ascii?Q?8Pdt8rgAs0VCR67oFq1kVKipxtU+HRdS0e5FuEwZ5f2RjWML1t74NbwFCLPY?=
 =?us-ascii?Q?Y55TeJpKFU3DtKwbooGclQqPhI5X8gw72PqJz2hCgn5e3Z8cAbNKqlMf0qds?=
 =?us-ascii?Q?SCPp3KT/QP96AM2XiDKK6fmpVvKMmNmOz8QWNkXHWwFUusPn0wrqGUknx1Mw?=
 =?us-ascii?Q?R27C9qe287VJcg0GapjWMIDwjRQ/AymBM0AY+M+mEHalyWGBeBkVJnX6j8NU?=
 =?us-ascii?Q?JWT9Txk3Mlsvd0AAq2b+kO6K9wCHpjy3KJ+BSQZH2+BikqNKIGEEdQ0ehJ+N?=
 =?us-ascii?Q?+dYy54WzX6/AGJf+ZXeTRDc5iBrExV+p1FkhvWwE60NawmQOaJo6wYtKodpJ?=
 =?us-ascii?Q?fq1JesJfKy8LEhrnvDFo4VkO8AJL5QILPurVtNTaEcNcO9eWLnQMzxfBwf1P?=
 =?us-ascii?Q?ul6y4/VHMPHLO0RjQWIgjAUnyTUhfb2JC3ByDo2QA49yI1AS71oE2P5s4eR/?=
 =?us-ascii?Q?OMTIpYNltn3fRl9bc0QB2eKquuCiccwrvHU24GsIkYHA1j/j1A3ml6wA7ttF?=
 =?us-ascii?Q?4rlhoQv/O7u0hGhlryTK2R9VoqRP9TXRCi3T1XHXucadXH/ybkgQO7JoiaBf?=
 =?us-ascii?Q?BDUE+nezMx/d0B1UBwAFxY2dUcTULrOmDrL+v6RlcBjKaPjQY4ea0VJghhHY?=
 =?us-ascii?Q?K8trtomydrMBNldL3nGYegjDYBG80bdVl6jzR+qB/8BD3Qsa8NXT0Twog8Ug?=
 =?us-ascii?Q?k4ah7rFGWaL7i6P1xvQQS2CyhSr1q/aCQOEjsabxrrzuGROfzwrFtzjx8CWN?=
 =?us-ascii?Q?lJR42L4Fo2nzOJjdbZhAPp7yioJ/cGuhnYysdvZi4p2V2yoCAfkhvJ3bIWXG?=
 =?us-ascii?Q?iVqC76Ywi1mxFp34X3Rp4uS4Ehs8PFGzm3ITkLIRpNBLNt6LeSdTITd9w98Y?=
 =?us-ascii?Q?F6SLBUu81ZHxWU2Dfdpl7y1Qtip2YGVVlWEjBTVV5N8ZomdfvoL603BnSZF7?=
 =?us-ascii?Q?3ZDTGadLrfdkV1V4m4urIRuqwRbYnPz0bWXwYXeGrKEIrmCQpJaag7VZw+Xm?=
 =?us-ascii?Q?dMvTxtGkoe0p+Tncm/hBy38Y8FpkOcT+bJ2pSg2ybvx5HbtbojUQIVGVu5IT?=
 =?us-ascii?Q?sIAovWkW1grC0I30iy2gnbl+bbXDbtWsNY0PaiWD58Q6FPzch3FkolStN+Hl?=
 =?us-ascii?Q?127T//BWQgvUXkfFPxo9pWeeLd4AuQkahuTwIGpKMoGtmF/SPjK5PVJfP4s7?=
 =?us-ascii?Q?O2eZ5+ENLStG7nvVJA5ruCLzWBTuvuXztfSfinpU4+trie9RZ4ha0jt0nj8K?=
 =?us-ascii?Q?dBgZmCTMVcaG+5eraZoOAYhyW6qqh2bYmwNGhRyxJw4foPweNvsf5+nttMM5?=
 =?us-ascii?Q?yzA1APOLnfTZStRAYInoDnITRFJ1nuIbJB90JqDn1FVkodO7RGV3uFbwfoKS?=
 =?us-ascii?Q?mkBEk5sixDSmcqeLgOrKOTT7lcYvEKVSh1ClcEiU5YPuUxEw+qOdahxLZlHt?=
 =?us-ascii?Q?Nw1gH91ym6t7E0JG/KxmIk8ESr4XjJrCcsLpblXQ0whrKv1XdtLEX7YoJaR1?=
 =?us-ascii?Q?CSaFzurjpoDsvmig28s1bin4zx3vjfePnaklGl15vKkmYc8JZkD4t3Q9IW6S?=
 =?us-ascii?Q?zg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26b15179-be9f-46d7-e5ea-08dad8003e76
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 03:07:58.7644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p3/4rv9YhAYle8R0WPBOpDm3c3zwx8i2zOMoR2LS+gwtg8QlIGRQG21oFMtgtyiCIJWePTpEAI0hpQ0mWHBHt3Y+oNkZkQ+XRUc2nFu1uqo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6714
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 06:04:30PM +0200, Vladimir Oltean wrote:
> Hi Colin,
> 
> On Fri, Dec 02, 2022 at 12:45:50PM -0800, Colin Foster wrote:
> > Ocelot switches have the abilitiy to be used internally via
> > memory-mapped IO or externally via SPI or PCIe. This brings up issues
> > for documentation, where the same chip might be accessed internally in a
> > switchdev manner, or externally in a DSA configuration. This patch set
> > is perparation to bring DSA functionality to the VSC7512, utilizing as
> > much as possible with an almost identical VSC7514 chip.
> > 
> > This patch set changed quite a bit from v2, so I'll omit the background
> > of how those sets came to be. Rob offered a lot of very useful guidance.
> > My thanks.
> > 
> > At the end of the day, with this patch set, there should be a framework
> > to document Ocelot switches (and any switch) in scenarios where they can
> > be controlled internally (ethernet-switch) or externally (dsa-switch).
> > 
> > ---
> 
> This looks like a very clean implementation of what I had in mind
> (better than I could have done it). Sorry for not being able to help
> with the json-schema bits and thanks to Rob for doing so.

It seems like it worked out well. Thanks Rob for all the help on this!

> 
> Would you mind adding one more patch at the beginning of the series
> which syncs the maintainers from the DSA (and now also ethernet-switch)
> dt-bindings with the MAINTAINERS file? That would mean removing Vivien
> (see commit 6ce3df596be2 ("MAINTAINERS: Move Vivien to CREDITS")) and
> adding myself. This is in principle such that you don't carry around a
> not-up-to-date list of maintainers when adding new schemas.

Yep. I'll get that in the next set.

> 
> I don't know if we could do something about maintainer entries in
> schemas not becoming out of date w.r.t. the MAINTAINERS file.

Sounds like a nice feature. Maybe part of dt_binding_check / checkpatch?
I'm running out of hours in a day...
