Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E99563889
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 19:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbiGARSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 13:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbiGARSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 13:18:44 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2107.outbound.protection.outlook.com [40.107.102.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E00620F56;
        Fri,  1 Jul 2022 10:18:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BgE4BVQonD7ArYbQUZoCs2+vP7YBOAS9r5oitI+vmfQXFM0X52+cVy5OvYBjn+RP4LIhMvALD/zgvqMu/nvNWXBzNj/cgBkg49SqkbewOjINgeM1DfsGHYqJXbTeAXlwB2vjnnWxE2TgUzrst4fv62i/S55pK49Yygwngb2VNdjw1XmpSXKhQQrgSSa136CAlYrqI6CgRCaDZPCAYJBcPvKj5o+zwxIt47w8PF8xcZw8+heM3mzaviJIar2qV8ve1rVUdZIHd7q8xHB+SiqHdM76j3zOeXC4u+I1bzKQFlO00JP+IEvShhtOpWp3B/eJRugrwkLXiqEa6jhyulp6qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rnam+bJ5hwRdkQVl69VO12O54KR7qTWObxXRcrGzoZo=;
 b=Hv1FOhOl8j2H5Nznf/kbihq2PS5mArb5lbPI0iIb6B4pd5XbTSDfIIkrdDjUzQLhg5zaLOXJSir9MUSQzVhClezD/rp+jLQTrkE8RM9BZEI1kz7l5Qlk4FBD7/uEfVfscRKmK705XGJqZsHh1QhtgIca1bA8eoHKB+ve2fw+NLbKErHu2PxrWYFOtIcoEnGW+yYWhnhNp1BiHpijAT1+hHKXzpjxjFTXAQKRPHuP7/CBKTH2SuL56OoSfZ1r2J+hmHYy+r3oq5HBeLZzQYYX+WQ5IRdmD//CeLqo20WxKAqsvkp5hERoMIwgCiELc8HTeCM1YLQas+ki9JreuQKRxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rnam+bJ5hwRdkQVl69VO12O54KR7qTWObxXRcrGzoZo=;
 b=alThQoD5xo4drwR4tSSjrmg723ZQeUw8XsUrnZ8EzZA9vM+D+4fCp+63lZDerHRXXwDe7MIlgQgGlcTd2LUX8F3vUB2GhfL+nS+HsqWZEYD5u0IVkt2i0iNBESf6N1ClZ0jV6fECsgm9zrew8c2uRd+Ia/NqE323gCN5uVein6k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CY4PR10MB1671.namprd10.prod.outlook.com
 (2603:10b6:910:8::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Fri, 1 Jul
 2022 17:18:38 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Fri, 1 Jul 2022
 17:18:38 +0000
Date:   Fri, 1 Jul 2022 10:18:31 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Arnd Bergmann <arnd@kernel.org>
Subject: Re: [PATCH v11 net-next 1/9] mfd: ocelot: add helper to get regmap
 from a resource
Message-ID: <20220701171831.GA3327062@euler>
References: <20220628185638.dpm2w2rfc3xls7xd@skbuf>
 <CAHp75Ve-MF=MafvwYbFvW330-GhZM9VKKUWmSVxUQ4r_8U1mJQ@mail.gmail.com>
 <20220628195654.GE855398@euler>
 <20220629175305.4pugpbmf5ezeemx3@skbuf>
 <20220629203905.GA932353@euler>
 <20220629230805.klgcklovkkunn5cm@skbuf>
 <20220629235435.GA992734@euler>
 <20220630131155.hs7jzehiyw7tpf5f@skbuf>
 <20220630200951.GB2152027@euler>
 <20220701162126.wbembm47snbggxwv@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220701162126.wbembm47snbggxwv@skbuf>
X-ClientProxiedBy: CO2PR04CA0096.namprd04.prod.outlook.com
 (2603:10b6:104:6::22) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0950b93f-58c2-4e8f-bd8a-08da5b85bc6b
X-MS-TrafficTypeDiagnostic: CY4PR10MB1671:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y+S8N/7eY9BcRqYgkWeMitsVuFVfRugUlM/BL1ICy0GjQJMxcJnOHKoy8p1LXULkBs7c6pDvHuv/A3jUXvEo98XITZpcSO2d3Lc+eKfNXRQxLpK+PuCgkxQrbKdQcgaOK4k70bxJeeB01MoCzuxBa4j08Q9lvvciEnM0VE6eh9nx/rxgNpaJjn3DctGfs+0k8T0S8Xuy2Ft/3qmH7r/+UAaF/p2SlZJqS8DTJH4bVegktexFoHL0R6h0T8bFpQxiQ7rDo6R/CtEiSi11BH4bcNqMcTGh7b3s48X0PejENKtCLQIeZDtw1QUHqEt35uhpV6vjGi0NTvwCt8U9K5GsGGfVcWYrNqgyb9KnON1JOX9jDmj7fEHd6K+WCWlZNVd5jL26k0iGpFPoQhC9ujy0Lieq/kUoC5+A6hlZm9Cuh7hjPiM2JfckXLi6dK/NCSJOcoQxvBEzNaariRoWu8EaAwCjqGoNHtZwv+0hoZ627qGhA9fYeuvOO+ZFm4yGC4kFntQdnBe9dJsXbe4Lf6CdidFfPMJKQYz3QZWz5+ePIsTKkSgZ/NPgDyVkr17BM1rnjdSYXmCjFAJYecp+GL3mynPRx8sQ2qrAyIWpkGsQeCeY82ysSXqw1/kJqThotEN7yuu0ejreT6yVG3CSu9IeewnlUrTM3mxiK1TFhHWjmdwtlpcGn3Gv6eTfbjFuYMLZ73cM+AYQ7cbFWNY+nS+Z926d9nzzdsi44HJMb7U6DES9sb+ockPFCYH8iO73VUrKkdBlD0vYxTFyLErWVTabSxi+pCNcRkQS4gco206HXJY0EFhP6bzUVI2sbpCqw7fR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(376002)(346002)(396003)(366004)(136003)(39830400003)(5660300002)(8936002)(6512007)(7416002)(54906003)(6506007)(33656002)(52116002)(33716001)(6486002)(9686003)(44832011)(1076003)(38100700002)(66946007)(8676002)(41300700001)(6666004)(4326008)(186003)(26005)(66476007)(66556008)(38350700002)(2906002)(6916009)(86362001)(316002)(478600001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GnNVBvoX98zl9LnfK11GdSb0aFvyAZihog8WKYV39l5a2PzwXgd2PR7qG11W?=
 =?us-ascii?Q?GFFlyA8kewiHqe5+MQUlChUqVxB2keV/9tzvLdnBmsvU6QXgivyLaFJvPzQT?=
 =?us-ascii?Q?gmnB6y0lDFrWsonuuTiuYt8u4+bZMXnjuIg7+ahrfZWRWWH0Jo9Du5kk6k1i?=
 =?us-ascii?Q?yI1mXkXcQwnaYy/5dtFQ3IVm2CPwN4OciXZ+NfswkFexT+Y3MjAx0PSB4b5T?=
 =?us-ascii?Q?JFrwQs+5MdHsnUOtj3QPc8rboOWkMFr7K+7tqkBcBv8p2AHmsqYJsvYUMnuX?=
 =?us-ascii?Q?smfxkgkWXUl+1FwU6VUJ9SKUbF8+o9xRDSrnKS3jHMEeHoG9FU33x54SggyT?=
 =?us-ascii?Q?ulQTaZKVFK8x/QBk0aSxZC/1Evz8agg07yo8VKmlAKI5DgpJps3PvQTJVJff?=
 =?us-ascii?Q?/fPeF9B2FeXvNoHuWQViUGVvv+DuZk9msZbMBcUbql3YqpXBAy2/MIh9uGe4?=
 =?us-ascii?Q?HayBhLaAJwGuHMiWvRBdB/Q6+2p/tp4MjI7QORDOt197cJSxpg9ex0Ll6fjX?=
 =?us-ascii?Q?Lk2HMUf+eFvDZ44Mi8SawvOrrWTi0Iowo+hl9/ismDqLxzmfN2V6bsInDVqq?=
 =?us-ascii?Q?RAtDMNgwcGP/EqwgRzxxrR+ExhzCs6sZsmJQUgtOE/748PT+o2KSbdOXyyUD?=
 =?us-ascii?Q?wi0VcH7y27z/lxlHs0+2Zf+x7o33rxWwXFzEx7qWbonZHYZWqmYfePDl++7y?=
 =?us-ascii?Q?wxm0xM0OHhgr0bUyf8LbdUX7HMtH/ShHlTEqkXc0J+c1AK4r0hbbjyQGqwc0?=
 =?us-ascii?Q?5+X3zx2YBWYLiJ31DhnhIwYq6gKxcVzUjOhhJSAmxkKqFOAQpqTS1rkca2nQ?=
 =?us-ascii?Q?PXQ9zmDzKuNcLwr6HXxhLLTW/Yq2D+cfIXkGY56/r4Rz2aHVxIoUi2f7BxRT?=
 =?us-ascii?Q?9Mkm6X8zofAZJuo72NYDT9/ekLs6eCOySELNK4eHW9gE2gR4+6PGaH+1KFAX?=
 =?us-ascii?Q?1NmHYUf2B24YYaVoWksWucFbAVYoc5wAdsf11O0FlQd30ArJV+/X4Q5h/fki?=
 =?us-ascii?Q?WUz/RVkQwtgTDR/wcg/2mNzoGmPxd8Pl157pMZce5aMD/o3yp72GZxyir++v?=
 =?us-ascii?Q?xEkKsc+hnIAC3oYRkOvSs8gFHWDApJA48XElr4JpWn8byrfZLq5SSoiHQwlq?=
 =?us-ascii?Q?mP8kUJXoRvHzqiIuEtQ+Bv/r2r6yhSXNgfcbD13/8ghNfpg4qsKLF6wJtIav?=
 =?us-ascii?Q?U19YyhMd7lgNZAw8o/eAnW748XRPLBkQ97QtvdMOpok+dnoOmVdQqC4ndNwt?=
 =?us-ascii?Q?InqvvaVtiQgY1AEajixwN/Psm+gWfDXzPoBRhNU/KUnsvpzaEMs4Z7UqsmYl?=
 =?us-ascii?Q?Bu7B89eY3WyXGVn74ABo/kOhG4a1rNblD8t4ijapraQ+ZifqUuMauTLL3HaE?=
 =?us-ascii?Q?x0PKJgkcG5cDBE6XbAYmO/qpJFKXzseBVVKvfftCbFylTcZh+COJ+2I5Q0p9?=
 =?us-ascii?Q?qlFjp+LQjg9MAk+2S1T2lDqdUMzb3Ubq0R23PBZRxcjHbDxVOETT8gpDKN8M?=
 =?us-ascii?Q?6YyF4hJetU+5Cajg2KlXrMpBVwPIwOk2RUyLO028pPAZvRDvL3HweZT8vwIA?=
 =?us-ascii?Q?AGjV2Plt8yLgJ+HSVaVsT3hO4YQ5UJRwsBw2m4xqRnN72Dt94mPDAIFQTbmG?=
 =?us-ascii?Q?0A=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0950b93f-58c2-4e8f-bd8a-08da5b85bc6b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 17:18:37.8645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SOhj5AOIO3juyJsPL08mk/f5rhCpUh1FJendiv3cEeeGqct26lINv1OPweIs/9Ydm0IWo1IWc8sjIB1f8ZG9G2WvVFoyyQyJkqR0eY5Doak=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1671
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 01, 2022 at 04:21:28PM +0000, Vladimir Oltean wrote:
> On Thu, Jun 30, 2022 at 01:09:51PM -0700, Colin Foster wrote:
> > Ok... so I haven't yet changed any of the pinctrl / mdio drivers yet,
> > but I'm liking this:
> > 
> > static inline struct regmap *
> > ocelot_regmap_from_resource(struct platform_device *pdev, unsigned int index,
> >                             const struct regmap_config *config)
> > {
> >         struct device *dev = &pdev->dev;
> >         struct resource *res;
> >         u32 __iomem *regs;
> > 
> >         res = platform_get_resource(pdev, IORESOURCE_MEM, index);
> >         if (res) {
> >                 regs = devm_ioremap_resource(dev, res);
> >                 if (IS_ERR(regs))
> >                         return ERR_CAST(regs);
> >                 return devm_regmap_init_mmio(dev, regs, config);
> >         }
> > 
> >         /*
> >          * Fall back to using REG and getting the resource from the parent
> >          * device, which is possible in an MFD configuration
> >          */
> >         res = platform_get_resource(pdev, IORESOURCE_REG, index);
> >         if (!res)
> >                 return ERR_PTR(-ENOENT);
> > 
> >         return (dev_get_regmap(dev->parent, res->name));
> 
> parentheses not needed around dev_get_regmap.

Oops.

While I have your ear: do I need to check for dev->parent == NULL before
calling dev_get_regmap? I see find_dr will call
(dev->parent)->devres_head... but specifically "does every device have a
valid parent?"

> 
> > }
> > 
> > So now there's no need for #if (CONFIG_MFD_OCELOT) - it can just remain
> > an inline helper function. And so long as ocelot_core_init does this:
> > 
> > static void ocelot_core_try_add_regmap(struct device *dev,
> >                                        const struct resource *res)
> > {
> >         if (!dev_get_regmap(dev, res->name)) {
> >                 ocelot_spi_init_regmap(dev, res);
> >         }
> > }
> > 
> > static void ocelot_core_try_add_regmaps(struct device *dev,
> >                                         const struct mfd_cell *cell)
> > {
> >         int i;
> > 
> >         for (i = 0; i < cell->num_resources; i++) {
> >                 ocelot_core_try_add_regmap(dev, &cell->resources[i]);
> >         }
> > }
> > 
> > int ocelot_core_init(struct device *dev)
> > {
> >         int i, ndevs;
> > 
> >         ndevs = ARRAY_SIZE(vsc7512_devs);
> > 
> >         for (i = 0; i < ndevs; i++)
> >                 ocelot_core_try_add_regmaps(dev, &vsc7512_devs[i]);
> 
> Dumb question, why just "try"?

Because of this conditional:
> >         if (!dev_get_regmap(dev, res->name)) {
Don't add it if it is already there.


This might get interesting... The soc uses the HSIO regmap by way of
syscon. Among other things, drivers/phy/mscc/phy-ocelot-serdes.c. If
dev->parent has all the regmaps, what role does syscon play?

But that's a problem for another day...

> 
> > 
> >         return devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, vsc7512_devs,
> >                                     ndevs, NULL, 0, NULL);
> > }
> > EXPORT_SYMBOL_NS(ocelot_core_init, MFD_OCELOT);
> > 
> > we're good! (sorry about spaces / tabs... I have to up my mutt/vim/tmux
> > game still)
> > 
> > 
> > I like the enum / macro idea for cleanup, but I think that's a different
> > problem I can address. The main question I have now is this:
> > 
> > The ocelot_regmap_from_resource now has nothing to do with the ocelot
> > MFD system. It is generic. (If you listen carefully, you might hear me
> > cheering)
> > 
> > I can keep this in linux/mfd/ocelot.h, but is this actually something
> > that belongs elsewhere? platform? device? mfd-core?
> 
> Sounds like something which could be named devm_platform_get_regmap_from_resource_or_parent(),
> but I'm not 100% clear where it should sit. Platform devices are independent
> of regmap, regmap is independent of platform devices, device core of both.
> 
> FWIW platform devices are always built-in and have no config option;
> regmap is bool and is selected by others.
> 
> Logically, the melting pot of regmaps and platform devices is mfd.
> However, it seems that include/linux/mfd/core.h only provides API for
> mfd parent drivers, not children. So a new header would be needed?
> 
> Alternatively, you could just duplicate this logic in the drivers
> (by the way, only spelling out the function name takes up half of the
> implementation). How many times would it be needed? Felix DSA would roll
> its own thing, as mentioned. I'm thinking, let it be open coded for now,
> let's agree on the entire solution in terms of operations that are
> actually being done, and we can revisit proper placement for this later.

I came to the same conclusion. Hopefully I'll button up v12 today.

> 
> > And yes, I like the idea of changing the driver to
> > "ocelot_regmap_from_resource(pdev, GPIO, config);" from
> > "ocelot_regmap_from_resource(pdev, 0, config);"
> 
> Sorry, I just realized we need to junk this idea with GPIO instead of 0.
> Presenting the entire resource table to all peripherals implies that
> there is no more than one single peripheral of each kind. This is not
> true for the MDIO controllers, where the driver would need to know it
> has to request the region corresponding to MIIM1 or MIIM2 according to
> some crystal ball.
