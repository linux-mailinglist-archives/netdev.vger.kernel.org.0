Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40E855B5D4D
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 17:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbiILPgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 11:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiILPgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 11:36:11 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2114.outbound.protection.outlook.com [40.107.243.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4332E6A1;
        Mon, 12 Sep 2022 08:36:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nFNE4HIHt44aZZv5TWdmkvlwRVs/dNTeXcZzja3SCEBudVXha2iJU3feGOaAdE2I+iQir8iMwY1Y/pi5yI2ltCpzlDuh1L70vcxEMsGdgN2Blc86jblpXR7+66Cd0ZIWZiin1BhirInvpBG1vjCkhEcCCcztpyqeto7YTXZkEJC/NNSMvMJ9mLDVrWnib5210IUk3gSLbRbtn4qfqFAMASIj1XkIEMze8YYhZfTtK2YqQAwM4U+wFyND+5qqIiHXjctzlubbe3sn0j9rzmWn3wXMxZRM8mcmX/Zp+qixt5Vy5waeh+YnMXVPFZ7ZmpZK/d6pQ/PLOAFmetg7/G3urA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vkc//rvnVwA5k5MmUAIRNwTxho+3bCFppPt7KI+LWxQ=;
 b=KAodl8v22yf6jSjmiI/MDfIv7A82tPwCwiSFzF0Ua7HIZkIX869BGm7nyv0Wea/yGXt59lKwq+/HB51rQyHc+8vlyqhBj0MqiC8YxBqoS1Gx2D1TOZP3rrmgEg7ub0DdpAg+yh/LRIZf/rI/mqQ9PaZh++zGpk+nDgSE0oTVWKOBfCTUcoRQQcK10CwHpRMvrUw+wJUjALSQ1FwxbsufDCT744Hj8/Hgmovpf/fo94cIbDotTSpAmTSjheemCfxu8BWc9XFyu8381ZB3oBcJtKy3MTxcjnFJG3wqFnO4eLFptGu7VJqpg3zLrpqnudZ8gn52ly3oEh8nKVENgjDe/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vkc//rvnVwA5k5MmUAIRNwTxho+3bCFppPt7KI+LWxQ=;
 b=Fm2kUVWrXIC3EEZ97yzTjcJjuSkusDHSRaq8nNan7uHufy21jHD+xJDKm7MUUsAuB3geC98xiHITsA9sAA0PIyhEkySrOIZvo+75hfWu8cpM+mQhw1jyWpZQZ8c7ZzJcfhUyiWvv38uX+EYOQFFG5n6KUNKnRhYg+T5aIOg+PyM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by IA1PR10MB6049.namprd10.prod.outlook.com
 (2603:10b6:208:38b::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.16; Mon, 12 Sep
 2022 15:36:03 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1%7]) with mapi id 15.20.5588.020; Mon, 12 Sep 2022
 15:36:03 +0000
Date:   Mon, 12 Sep 2022 08:35:59 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: Re: [RFC v1 net-next 6/8] net: dsa: felix: populate mac_capabilities
 for all ports
Message-ID: <Yx9R35d0+YvF9eh8@colin-ia-desktop>
References: <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-7-colin.foster@in-advantage.com>
 <Yx7yZESuK6Jh0Q8X@shell.armlinux.org.uk>
 <20220912101621.ttnsxmjmaor2cd7d@skbuf>
 <20220912114117.l2ufqv5forkpehif@skbuf>
 <Yx9RK0bDba4s02qn@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yx9RK0bDba4s02qn@shell.armlinux.org.uk>
X-ClientProxiedBy: MW2PR2101CA0032.namprd21.prod.outlook.com
 (2603:10b6:302:1::45) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0cb275fd-8e89-499d-9f9e-08da94d4804f
X-MS-TrafficTypeDiagnostic: IA1PR10MB6049:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oRWLWX+4xKQyu6V3ORhjT7o/wU/jgayEN95nBnFgrMLc4IERZws4siNbuRKRvI9YBFP4cJXM/m4kpScDXZMXz9MxQKQhltWQzJnSoazBQbSXIJTVjz+cYYFXLf/D35rhSThgfbhQL+3U1gsZmKvoE1Br+lHk9PwdY9+E86FQISjDG2VsONfmlpNeLnBDlKRvyvA17wfFZaL11J22HhQBm3Ryj0zroFzfEQ6AQlHzd8i4eF6lQKZyfmoLYolFnTeNfP0s0zTfYFow6oQyemYXVcn4qtj8NXGBL/L8rJSP/xM+x6LgjlOsewT1C8TPuf29dc3PHnJlzdP24ScQFCV461jb+Ao6QHUUgCVvdOW+h3qNK2lkDrW3tiHISfWvKwhOAfRmm2FA4+SqFAi7bkDTeTKAMoVyqi84rjzmo23457oLrwmteDtDZxd1jViA34hPpghz4eC6MtDNLQFs8owhx51J0M6EULfX+3qwunbLPVhu+Q4Q5aMN7lt8K5skMYmHbIrk0XJl5YrJdU9x/OmYp2CCvAvD84GnZpYgPmR7/zqJhbOMIZZ4r6pigvHN+riOaXQxoDAm+i+k8B9JdTmk4tQNK9XYbvFOVNzpt36JF/IrqtuARLKerMTBkvILYJvjY+FTccvt/x1qpug4GbAiZVVBgJIFA8KE7y0CDwJ7zifJjktHNgaMVL5jxL+GlDfP0rr9UdJ1enBLuiv+FeXeSqAVM19CMktLnZtdZeaLONs2Cbc8fh9hF2VG6S76f0O14VFTMwi1QrsR+gASJSf5/iQGowbB0eG+MqZL57vbHdc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(136003)(376002)(396003)(39840400004)(346002)(966005)(6486002)(7416002)(2906002)(8936002)(83380400001)(186003)(86362001)(38100700002)(26005)(5660300002)(6512007)(6506007)(9686003)(41300700001)(66556008)(8676002)(6666004)(44832011)(66946007)(54906003)(33716001)(4326008)(6916009)(316002)(66476007)(478600001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R/0IyyxVn8uvtYpH3ho4IEfPEKOBiWA040eZ2UgSn8bCfDEmoc73+T4Ap3bl?=
 =?us-ascii?Q?ImWaWgs4cf7XsN3DOtG6vGy8BnwC5/nZExEqBav1BmmsSimTEy0tJwv23JFk?=
 =?us-ascii?Q?XaqkWLZdNMxDeCSXcQbyyWFL2DcDVkUshjG9vLm+kCmVZCJQi0uUUTPltcZR?=
 =?us-ascii?Q?gaUjMcld/0GwbKEJPI5Tt1Z+3zrJ9cWP417/uoZNNi70/g3uWD0G4hHLqHDw?=
 =?us-ascii?Q?w8D0trssZWRMbetow7HJ3M1UjDMSI/opeX5urnhCo+IINksZ/27313g1muZl?=
 =?us-ascii?Q?Nt2mdnDgX5bW3HPrjWBL3VpNANAS19xUdYfkOJstGNqhh0kK5nJMJ26/RUNS?=
 =?us-ascii?Q?UP0xIQuj4EMEgVYNBCt4qqPkGFgujN6D5Dc4F3m8Wf6y7E5dUG28ZfMEt4dI?=
 =?us-ascii?Q?xidKYNysKd13n4+JhDTl62N5rwz0Nx7ln1gOkxOGDkJWxmNdT/JhOyQNyoNd?=
 =?us-ascii?Q?ETrALoN8dxMviFHdnoPTlP4ecueeaBiCqmhR3+2D2Aqu4wwp3k/MH4R+TffG?=
 =?us-ascii?Q?6WoF2BnBkdKwADSG1gHpOh3vAWy+cJSMc7K/NiTGQcAsvBistA9WqSNaLO+E?=
 =?us-ascii?Q?4QN154yT3gN6MZ7YrX1oWdG//YiIgah34PA2XCx1qLYUwEao+AKXykHPCZBP?=
 =?us-ascii?Q?k5DjSwsLiiWD7nmZ6gCWead95Rmr/8tR3Y5EaFWdqHLWSGubmsQ5tnor9EEA?=
 =?us-ascii?Q?nDflDphshEMcBCNvoSFCw6wihDyxjqGKqboyIWQnuXHomiixw3xnjAym1F1Q?=
 =?us-ascii?Q?ncWg6fTNNtKEobfOaXw0ASO/Nv9aU5PH6Q4r4MTJfrnh57t0rwhkKtmHUwDx?=
 =?us-ascii?Q?gGx08d+GLK53Q9fg3WbFn5KRkHY2RAaQhhEVVz3Nbp5Jkuxw0akbF2qwydvI?=
 =?us-ascii?Q?/rl78la+/KXc5ko8haUfStlXHndZ2y1U6D7pQNuZBk7iqY+47bPZVRdfpY1j?=
 =?us-ascii?Q?wJj9xgXvLkBbzujMCv8oys4GldvGNCBoik92po/jx3D9yIN1SfIhlVL2Qwzb?=
 =?us-ascii?Q?i5G5oVC+76a5Tkrn/pDVjepL7KREYWSyMOr5/SL15b13gdxvvSu24vR2I4dd?=
 =?us-ascii?Q?yUgVST1U8UKjisC4o40ScMVfuKnaS95qP5bpxi8A7K6mRoZnPrv0f8G3HQUc?=
 =?us-ascii?Q?6aoctwTP32Yh9UYlx64i+ifbEe1WLAE3BU1wQUCUtsnZDmYGf/TrtJWdbt4d?=
 =?us-ascii?Q?u/3ZV7weyV0hKatLL4r8iN0mWNo0kIGMvMtGIq/amsuyggivc3enyA8vELzN?=
 =?us-ascii?Q?TLot+5mkodMLQJs+VGeEcxfUGp76mCKw+0SeOyAhQZqfY+QKzP1uSjfCrNfI?=
 =?us-ascii?Q?7C41Dn8yW0MuNaCemPoei+pQ2Dga+iAEc1ea1sgWUZLPDS+RKPeqa25BwdE7?=
 =?us-ascii?Q?7N+Xfkt2c0txUEBwIz/O7ia9RyNCE4WrLgtGb8U6g0C5XilUsQg7r6GEZl6f?=
 =?us-ascii?Q?ubpad8pz624r53ImFW9VgRt+xsrzc4eHo7jB6Aot45EIxPCZbbvSN9fuRMfB?=
 =?us-ascii?Q?DY0vYaIkgujPwtMtVz5n4fl+xhmp3bejvE8nyTl7BJ3u04JrLF/6do+sqL2E?=
 =?us-ascii?Q?gRm0Wti9pMuNJvVmpQoaaLlc0zynWtXJroAySehE8Fxddw99oF7vfIdQkE3X?=
 =?us-ascii?Q?kQXsd1cv40GX3ogZaMl5sRs=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cb275fd-8e89-499d-9f9e-08da94d4804f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 15:36:03.6931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N4n3BjQ470YY4fvfG55giokekoizTwE+WjEY6yaZf0s1fi63/YpztJ+UG+YBN8w/+NUKemwKe3jS4NMB2jUci7mYOXS3xERLleGmV5uXIJ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6049
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 04:32:59PM +0100, Russell King (Oracle) wrote:
> On Mon, Sep 12, 2022 at 11:41:18AM +0000, Vladimir Oltean wrote:
> > On Mon, Sep 12, 2022 at 01:16:21PM +0300, Vladimir Oltean wrote:
> > > > Therefore, I think you can drop this patch from your series and
> > > > you won't see any functional change.
> > > 
> > > This is true. I am also a bit surprised at Colin's choices to
> > > (b) split the work he submitted such that he populates mac_capabilities
> > >     but does not make any use of it (not call phylink_generic_validate
> > >     from anywhere). We try as much as possible to not leave dead code
> > >     behind in the mainline tree, even if future work is intended to
> > >     bring it to life. I do understand that this is an RFC so the patches
> > >     weren't intended to be applied as is, but it is still confusing to
> > >     review a change which, as you've correctly pointed out, has no
> > >     effect to the git tree as it stands.
> > 
> > Ah, I retract this comment; after actually looking at all the patches, I
> > do see that in patch 8/8, Colin does call phylink_generic_validate().
> 
> Good point, I obviously missed that in the series.

Whew... I was getting confused as I was reading this. Double checking
that I did indeed add this to the set.

> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
