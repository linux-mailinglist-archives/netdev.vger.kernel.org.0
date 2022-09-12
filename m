Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8485B5DE0
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 18:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbiILQES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 12:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiILQEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 12:04:16 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2115.outbound.protection.outlook.com [40.107.102.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809CB3AB01;
        Mon, 12 Sep 2022 09:04:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kxNWRh6PUde10E3IFbiU4B9wUvU7i43SiyJ6mbFs0J76R7Kx4MA7vfNWvPm9vRgaN905L7nF03jDuDJF+yDjfUWzb8nO9Qs49TI2pes8kJd4s9libXzO+BtcCjbTpOha7fdy/G1adcU2aJN946dw3rUi09E+bzFMXEbV7ppoNM4IT25bZTmk3Q6xuImfIN84TtXGchad8c1QQRHqwMBb3ecZKfmVvO8Mml+7NHgL/mF5UpA31lTh1EmY0iiWAZQXrhQ/KmUWO5QjQ8FOTh7FzGiiu8o1rFhxbo/4U5jfaZcgo+TPxJdF8kAzDyEBDxhJebTsZgwRNbhzDm6tLgS9Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jwWP1tCiQfpXmADXkAnhf36v/4lAKx4/e1LVA77Mg/8=;
 b=kNVND7U5X+yhKI9AwSh72eKHccvPnRtEMbTVTY/o6YPfPxORr8V5lQJFCvBCjCfB/oO8IqsH8tt3+EsqATGplKZU8MA3szqjN97cJepmF1fHOVz7KexCKj8naXzzf716VxgxOzYaw+mRRcSamAl7Z4ewwcMu5VCRnKg64nzlX6nXkxS7eBwzoT9/jhvqWJXoQzbdx0OFP/v9wWFA8RrdGSvpVELe9Dy57X5dWM2UNpOUWzrWIw1tl1ppbobKKOGktI0F2PaWl2Hs6tZdBCYAqImRHv/4G05UZgbJzTiP1o1dr+I1rC3qRUnYca66WNqwRJ+bR1mvOGOu4o06ZOjFNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jwWP1tCiQfpXmADXkAnhf36v/4lAKx4/e1LVA77Mg/8=;
 b=FZdf6+ZuFNgoIhW5dpBkji01KPBhg67DuR3ChXIRr1uz9XGLe4Oi6obtHMJFDUktwxt1cmlVK10q8hojikxUVV1ZAFFUNC/8Yjg6EZwGPsvA8NuhD2mTXhin0uUrI+KXH47MeSc2C8zxcj/+SwEaE/auVgC3rGXadTeKqc6yUf0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH0PR10MB5068.namprd10.prod.outlook.com
 (2603:10b6:610:c7::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.16; Mon, 12 Sep
 2022 16:04:11 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1%7]) with mapi id 15.20.5588.020; Mon, 12 Sep 2022
 16:04:11 +0000
Date:   Mon, 12 Sep 2022 09:04:06 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
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
Message-ID: <Yx9YdlrsLsBNPJzL@colin-ia-desktop>
References: <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-7-colin.foster@in-advantage.com>
 <Yx7yZESuK6Jh0Q8X@shell.armlinux.org.uk>
 <20220912101621.ttnsxmjmaor2cd7d@skbuf>
 <Yx9Uo9RiI7bRZvLC@colin-ia-desktop>
 <20220912155234.ds73xpn5ijjq3iif@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912155234.ds73xpn5ijjq3iif@skbuf>
X-ClientProxiedBy: SJ0PR03CA0124.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::9) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62f11276-aa51-4e21-812e-08da94d86e82
X-MS-TrafficTypeDiagnostic: CH0PR10MB5068:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /cABzw8cjHZIEW2PPGJQvhTSD/U69kgfEDDfXkkRq4FEeQrQTSno5KFcTXw2lANbAt7Z9EnO0YBxQhApM8C0bIHGNqvm++jqUoCI9NZaI6uwNKYiEgfoudsL+t2enK1mb7C98cEfM0iDet07e5SaWpFCmXIDJGx9Rx7o0NKzzaNoa+a36z2vAZJdjGwWOcTViwCUMktLd0jaI4WJcusFFPfPktkqXgWmQNeyoj683wg6PlmbRyF+LYDGCQViO7WZfBOEiQI/L+rIVEjqPh1w8Md0wzOKqRGx8I0iXsNzst7+DmHx1/gnkpo3x96zbrlpua3aSn7wBAv0IpmnN3H0eD76eG1KVnvRAcmaqDXrr976LOxbC8CPKowvhpjg83jYzOVi9U65/n8dNuz3SjjvQtNto60dqHtTKIghifIafFEk9JI2JnQm0mWKJVAQBt4cS/oJUudxHDVpy9h2uBNOIR79CR1imGlS2REYMyr511u1RN3S5S95GnPuRHWkHkw7CibiLQNpzmk6ceKUA25dBY46HYcowA01vDj9k7pAvjRGAd3p+t7EOQM8FI/9IDfCG/SAa1br48wo9rijAHu7vgn7KRBAO10PU3xKbva4/nwEkpSlGgfSGXAlL2KwaE5zUBOcZVfs2MEjCort0tw6WHGMT8IeqsgqSzFUaFJ4gx17hkNejMq8GHAJmX3HE69rs8iM1O7sCgWpx14bVILk0H61hNU+wdZAIlcxedIZvEs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(346002)(136003)(366004)(396003)(376002)(39840400004)(38100700002)(86362001)(8676002)(66556008)(66476007)(4326008)(66946007)(83380400001)(41300700001)(6512007)(6506007)(478600001)(6666004)(9686003)(26005)(6486002)(966005)(8936002)(316002)(54906003)(6916009)(186003)(2906002)(33716001)(44832011)(7416002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QqNMICxe+ntKrZmJD5E97lLtM2Pp8025jxOq94O/1bX63AiFhJkzU8BF0TPS?=
 =?us-ascii?Q?sGkrAi04AUhCIxHzhy5xECWRP7HUjT87d36j2PkRd4/AMwPqcr/qB5RKEXrQ?=
 =?us-ascii?Q?vm5FSCp+nOH95ajPgU/WTawh5Spi9GpD5GZGJkyhF258uUZo8jaeF6LeVVMy?=
 =?us-ascii?Q?X6i8OKwvStXikztrbM+OdIZx7SX9A8NEUzIeiva1fnYNxgzrSu78r0U9LFgo?=
 =?us-ascii?Q?NAea5Otqony7Drn/SN+cAZNRfIVsoBFYpMuyqGBvaA/mU0tn3XqCsoxqsEjr?=
 =?us-ascii?Q?m+5/xBJ/fjJsofLvZGMFmDmd5VJrWp3UW746SNYQK1m9Y6USHxDuo8qdXsWB?=
 =?us-ascii?Q?JCNqoiDC5mOe1VudnEPz0osSTGGBnTR6O7YUEF4CA/K+0iPym30esxYpVm07?=
 =?us-ascii?Q?Q+8ay8zsKkTbMXCt4RZ+vFxtnRBCzjGqKRzHGhuvUGb2sLAL+j8aF/vm8+kA?=
 =?us-ascii?Q?281CWdZjuclaeOuwJxvmn994lmpU/Cj8npmlOiE4F3vSIvadl+3mL1hUy7iI?=
 =?us-ascii?Q?Hf1oVKfIMPy/fMuncbVjYDyYR4rC23BaVGcAfWdBQyzwzbyyk9GTT8029L1e?=
 =?us-ascii?Q?elqPBzRwBBckxJ+Ji3cx0udBoMcrNKOhMQAGnzTnJoVTEhYWBnMuimpSAFRf?=
 =?us-ascii?Q?akhjtTXgswcc/oTJOVeWQ9vJaJqeRqmd4+X8DgK9C/W20KFFSftylw4mjuQl?=
 =?us-ascii?Q?/nyD63tP+iJhRGntea2lfrlGuw0QvT8oyBWgzzzLcv+4+QiZ3TucRtzvyBrL?=
 =?us-ascii?Q?QhvewU7kdWM3SXhXLZThi9ZSaIWUG7fKp+Enlay7vyuW+/Px2RDyLcElSPOP?=
 =?us-ascii?Q?pGnsVMr6QuxZBUf6JwjE36oL762HSAhbn8C6wYNy8DrXBvFAWR7w7Sc0w2NA?=
 =?us-ascii?Q?HdlAjDLnJ6pQejVj8n+z745gJs3C9Is6IJ9QUE1GLQTMwHoxO7WXfciJ7DR1?=
 =?us-ascii?Q?GKJd9y6rkIqF5X9nlLm87e/+QjquCBTOrUDJlMAiNOLksSnfuLLCrZ0gktke?=
 =?us-ascii?Q?g2cut7leibaDxyzHQUCOfTJ3IHiAVLHlLyBADWL9wtui1r2chQHu0NshhABR?=
 =?us-ascii?Q?WEMQvNwfgYXR6r3c3q7ZyBN0PeC3EVfFK5drkO6vmSiGuo0CZy0dXgB5I/+F?=
 =?us-ascii?Q?QXupFGf3r1EjBmuQbBM305uPyaznxIOceQaDDDyv6Kc2IWdpjAKsqPPHxmRZ?=
 =?us-ascii?Q?GAkg5vQK8ST7pFtG0RHAsKLTJNlgvgn2dPAYDzWEApktxmqMDdtI+iaEKGjA?=
 =?us-ascii?Q?refW46dDDV9qwO1ASKoEDz13GiOmBYPEVJgS05NBoa7xFfZslVHWD/gCO0Ht?=
 =?us-ascii?Q?FX2xt4ThxAJ8Glb7bqSDH2PMwaLjOzwpu+1/YvIvDwc7OKV5N6m0MCqMUhhD?=
 =?us-ascii?Q?IcYKdXY9GM2EsP7OREzgGkL/owp23MZCYZZj1INIuyOD5Z1gXf9KNA9MHqCR?=
 =?us-ascii?Q?tR/i8hYSzJZnkWLqtFjeIe0DJ1K8TCXdHVKmE6sZl2WF0gl67F0ZUnjIDh/x?=
 =?us-ascii?Q?yVkn6IDWd0j9RM85jTZnRNh3TXqTPVYZKFz27wlDXLX4MVnnAa7wZfCGaCVr?=
 =?us-ascii?Q?0TM8oTcslxyJEns/1DYElF52stYJcd6lS94Gdkt68mLroo2S/+ffbhxe46iO?=
 =?us-ascii?Q?Tg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62f11276-aa51-4e21-812e-08da94d86e82
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 16:04:11.7052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DvZI57TIbt3V7Ml9CcWvm0IKvULVPmbNFQQIAcRBLipWlFWr/RH8okvPbh4pg/paQSV49y7SwcRpOYhpSX8p//s1JIFhoenwV6wQnjFelhQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5068
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 03:52:35PM +0000, Vladimir Oltean wrote:
> On Mon, Sep 12, 2022 at 08:47:47AM -0700, Colin Foster wrote:
> > > This is true. I am also a bit surprised at Colin's choices to
> > > (a) not ask the netdev maintainers to pull into net-next the immutable
> > >     branch that Lee provided here:
> > >     https://lore.kernel.org/lkml/YxrjyHcceLOFlT%2Fc@google.com/
> > >     and instead send some patches for review which are difficult to
> > >     apply directly to any tree
> > 
> > As mentioned in the cover letter, I don't expect this to necessarily be
> > ready by the next merge window. But seemingly I misjudged whether
> > merging the net-next and Lee's tree would be more tedious for the netdev
> > maintainers than looking at the RFC for reviewers. I'm trying to create
> > as little hassle for people as I can. Apologies.
> 
> What is it exactly that is keeping this patch set from being ready for 6.1?
> There's still time...
> 
> It mostly looks ok to me, I'm in the process of reviewing it. You
> mentioned documentation in the cover letter; I suppose you're talking
> about dt-schema? If so, I just started off by converting ocelot.txt to
> mscc,ocelot.yaml, since I know that the conversion process is typically
> a bit daunting to even start.
> https://patchwork.kernel.org/project/netdevbpf/patch/20220912153702.246206-1-vladimir.oltean@nxp.com/

Yes - checkpatch correclty gave warnings about mscc,vsc7512-ext-switch being
undocumented. Thanks for that patch - I just saw it! I'll wait for your
review before I get optimistic. But if it boils down to separating the
last patch (per Lee's suggestion) and adding the dt-bindings, maybe it
could be ready in another round or two.
