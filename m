Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF78560DC0
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 01:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbiF2Xyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 19:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiF2Xyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 19:54:49 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2120.outbound.protection.outlook.com [40.107.244.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E0B248C4;
        Wed, 29 Jun 2022 16:54:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dKvPwFwTQppIDYt8xYM+dDblD6IIwreMTvmXluNbSpWT9E9N8f6nTJG+UHH7L/cqgg9nOBP0NOidubycbqR2dlld47IE8kodFwFM3hi1AiqbEFuFwXK3ClgyQ/ZVyKMr8CF++cn5uccV/9GF7OyBsMxXa0SAqZ5tEuDCxm1e8hO8YYmVzWDoxM486373ZVfOhC3i9eUrcWjHW5vwbD+1V1eYjNx+vjm7qrG4NxqQ5Oe8eIakRv+fXYwtNMXrerxTK+7VsVzd5pYxUmyxwvHI9wqlwZzaMQWtAoXlzcD/USbnYKFsbxIC5THtHJ7pxuKgIt9f1FOVlh2oxRSQXPQWzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MM7Q0wZ9EV8oVX1hKXAbFxwh1/CidJgDXyNrtpUKkz8=;
 b=XAIfKACt6UOkPmz3yJdmQtQU0eSUhHQre0w+zBYX4wQpfkp6UYoWeyQavuZOxAw1Kmg29QVaoylhHNFiPfKD0nFYDbcYX+w3spW7nMrGH4CkW4wAy01UoliSPPB6lF2wU+25Zx0V6rOlPVAo6A3Y6xuHPJkXFogwj0jpOTqGu2zr7yqqvHIhRM5hAoveedsRM3je6r4Nz073kJBwH2FzYRAr9rF5C7yd5n40V01G1F2Im82rWrs4HIwX1j/cI4/++Sgw4rxqfNzWxQqlPN5KRiEI23ALrzJeEWhL4SD/nGNDGdV5tJJScGfQkdH7E8bHzYVFwr0m22euuV9292eXIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MM7Q0wZ9EV8oVX1hKXAbFxwh1/CidJgDXyNrtpUKkz8=;
 b=Z9oOVK4rDPsnrqaWQSwNh2aSECzf7O6SgV9oY7ujzyVCG3Oq2ilHgGPffPibntMpIJeohs3Or3hIXv2YE59gPn4DK+0HblpQP2iTMpBKl8VLQph6NErPpmMwsMuouIcu+MY8Pg205JoV/rbjt/UEMMzY/aofvdY0JTiJt6uChDA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB5567.namprd10.prod.outlook.com
 (2603:10b6:a03:3dd::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Wed, 29 Jun
 2022 23:54:43 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Wed, 29 Jun 2022
 23:54:43 +0000
Date:   Wed, 29 Jun 2022 16:54:35 -0700
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
Message-ID: <20220629235435.GA992734@euler>
References: <20220628081709.829811-2-colin.foster@in-advantage.com>
 <20220628160809.marto7t6k24lneau@skbuf>
 <20220628172518.GA855398@euler>
 <20220628184659.sel4kfvrm2z6rwx6@skbuf>
 <20220628185638.dpm2w2rfc3xls7xd@skbuf>
 <CAHp75Ve-MF=MafvwYbFvW330-GhZM9VKKUWmSVxUQ4r_8U1mJQ@mail.gmail.com>
 <20220628195654.GE855398@euler>
 <20220629175305.4pugpbmf5ezeemx3@skbuf>
 <20220629203905.GA932353@euler>
 <20220629230805.klgcklovkkunn5cm@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629230805.klgcklovkkunn5cm@skbuf>
X-ClientProxiedBy: MW4PR03CA0118.namprd03.prod.outlook.com
 (2603:10b6:303:b7::33) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2edbd7b9-4025-4ef5-ecf3-08da5a2abcce
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5567:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CFq6BDE8KPTXxXAl8iseB+MBY9d12EotqAPdhVziXv3EMPZ1MNmJDDTwB9LG0a212SZrl68Qj/xxgB89AFgrMNMKTtv1PAOCYgpp6UPMLm+OZhK9ISdS2m+4fkOHzAaasWEkG6Quv2RmxeLi0uxj4exbvoWtl5M7W/tsefRVDVQDfTY3jN6tZJduaY9x2VpoVudffju01pcYsF3/REbQ/PpnOKBlX2bQf9US32aoHexV91Kxul6sZ1yb65QZTTr72JOfVdz0gLmiGy3nzKBJcxgJGKKH8xdIBJqa5mWG09htiCxJWnwOyR6FNstK6T/iZiMsORxjkaDP6M5kyJT9pMehMYIA5eiC8c7YmSSia/ggq/844d1uAHikFxr94V2HHcIPr60cv8lUv1rlVbQRBnPLgA0WgRP48CVT/oKr+qu4XewavrEPW1L5UdZ8Dvjti7/0Pf5Rnic0rDq2ZUbS/bGx8IH2izWFRBHdRr5XZ/+FMQB/OfcHjjWAZ9ESV/HMg1FKpcCQVT+LxEXjDePEwrV4ZNR3118XuMcqiJr7PYAmb5OstNEDPaR4nYSZNFugga6qE5rCm9yP+nXAYFFcX0HaWJ1+/u2KM343VD88AjgfVAu4vh9sjEDojb6nHnLOfg8gmUnUP2siRaUc/9hDV/KVHrPgn616UVOCem6IJGPeSsP/JtEtfiye+5bJjuwO2zGY6wTZTJfAt4I65L+6HbENc36lQbTCapF408adtXDWcKoPPaYoxBMexKswqoUf1zcPeQLDkIsykYoS4VOf+W1OHaVVTpoPvao97Nje7vQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(136003)(346002)(366004)(39840400004)(376002)(396003)(33656002)(8936002)(66946007)(1076003)(66556008)(4326008)(186003)(7416002)(86362001)(83380400001)(6666004)(38100700002)(6916009)(478600001)(5660300002)(316002)(8676002)(54906003)(66476007)(26005)(52116002)(9686003)(6506007)(44832011)(41300700001)(6512007)(38350700002)(6486002)(2906002)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Bhx8S7iRCwNbrZBrmxXDMMWanO+xFejStn6bORAH8aIjRlWqXT31gk9JhQmz?=
 =?us-ascii?Q?ho8I3S2knyb+d0xKpuEhhuXCZvqu3itnm4t3aMG8MZ5ltzEKdKQgnybo2H3I?=
 =?us-ascii?Q?jH6HUrkhRMfB3HgmFufKHqlD0nc8PtPyUeSAk8ZzB+HAv9lEh0DZEyOmIP2R?=
 =?us-ascii?Q?x9rINGv/FscOuuNkYX0z2r8yS3WLpwLuQesmOpKulPPd17ExbQzlelSWVJ3n?=
 =?us-ascii?Q?wivsOLQKMwMqu1FPwGQFWzVRTvR3ZUG8M2HVD3f9qP+I6MsQVT6JwWUGz1KW?=
 =?us-ascii?Q?fGA7kuUZT98Q6tBfOlIEFynWZNA6kDFYtqz+9mQDO2U1qVGOOOd5aLi6y8L/?=
 =?us-ascii?Q?UScYQhwv0E6aM5FyQod1LPgFcQTePsb4zeHpietXf4Vu4Tx4L7tKql5+C9mF?=
 =?us-ascii?Q?ffGu1P7c03fOuoWmd7Xhl/w10meTrUK+4Tyahiu+OS6OxGSd4XQmzq9MPIq8?=
 =?us-ascii?Q?BMcVB7vilb0My9Yntj/X/iI744TRxmzcaeEAtU1YUsRVmm62C9OtL/8KMZuC?=
 =?us-ascii?Q?/0uAV4mfV08cAZ1yC3rnK1cOlbWdctmbI2MgPHi+QY065pazMcyNtR8dTFpN?=
 =?us-ascii?Q?1j+u1UXOtvFaJfMPjuUsy1T3etIrl5GHCq14eDI/g4isPtroKbqu000b4+xn?=
 =?us-ascii?Q?PV8mC8FwSmnvwR6Ye4KlV3Qh3WsZd9Z23BXR/4scmun0yEEEsoz7rowxyT9z?=
 =?us-ascii?Q?Bzhm/Dq/6eTUmXERVKnsE3A+90OUXPsc99qY19Or6UR/I6otkFWYXxe2VK9X?=
 =?us-ascii?Q?Wl84mTyAEIQsBus3E8X/3MMLN39IPf48K9FOzp9TABrPLntE4QoC2pG5R42O?=
 =?us-ascii?Q?Wb88uiJ/WEKpVzU4vnF0VLJGv2BeLTTb+/8MNhu5rT09/UXicOOhhiKLKwVu?=
 =?us-ascii?Q?2Ocm27Y3cdmTPDlL2QNbccRji2YsVxPXKp1m2CwBUaDOYPoQDtBphDpU2XhO?=
 =?us-ascii?Q?jF8fzGql7TpXoauNdkmw2KRbLu2FJ4b1qAyE8fP2xdwv2pA9+f2i73BV3NLX?=
 =?us-ascii?Q?m6dQvoW3sTZhhB6ccHQqcgwtREYMxJX0HTzSUlyTwX3oi52wXQsS+Pu4LTCp?=
 =?us-ascii?Q?Fn3H3kGQDc2pGeJ146CSCQrwtvktaIKz4l/tuwnqixN/5jtmDxSddJprljEz?=
 =?us-ascii?Q?d6rKRCh8rrI4gceWJP0CDIxE4+ZqggGj3mhsO1+8Id8OkTjADD6DN7gIYNyy?=
 =?us-ascii?Q?Kb40D9krsqwXVjoCyuzsKU+Jfe8f9RvvrvzHTtaBtxNI5Y+Xi2OnFFqGBx7r?=
 =?us-ascii?Q?1zCwA4FNDQ2eWeXfOghK+pZNi/RXlcwFkTPtzvNniMV6xlAS+0yrg4XYUubo?=
 =?us-ascii?Q?Wfd5fnwEhFEiy+MF8lGygPntV7CbjLuVOB/m4ksHA/zK7Ve42fLGUP38yVgX?=
 =?us-ascii?Q?Z8gKrBxSrOFMjytP+QqYLxuemS5a7PN98aPmI028qfvLxVxAedDn15JzWkFe?=
 =?us-ascii?Q?H0b1hMmeR9iL1iS+RKDLjJ4ohurGI2MRwylMy69KDCnNyU1DxSZ/dxHOxc7c?=
 =?us-ascii?Q?Td7j+nvAnp/N93EzCJCMeajN9NszStHXw/evZFkYPe79HgQdhpdXcGq499VU?=
 =?us-ascii?Q?RmvTxeBh1w7e92dRg9PvCbuXS78eog+vbqQuk56SdZeC4Lv1+dc3Cy2s9rMo?=
 =?us-ascii?Q?0g=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2edbd7b9-4025-4ef5-ecf3-08da5a2abcce
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 23:54:43.4462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r4l66/jQX3Aug0BZTeHcaUZfnN3674Vjwf4Hm5U1P4F7VHHThK6HFr78bjosRjjph3QOwgTJQ+3knbyHKt0M8tz4RFvOj64spwLspwm3ds8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5567
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 11:08:05PM +0000, Vladimir Oltean wrote:
> On Wed, Jun 29, 2022 at 01:39:05PM -0700, Colin Foster wrote:
> > I liked the idea of the MFD being "code complete" so if future regmaps
> > were needed for the felix dsa driver came about, it wouldn't require
> > changes to the "parent." But I think that was a bad goal - especially
> > since MFD requires all the resources anyway.
> > 
> > Also at the time, I was trying a hybrid "create it if it doesn't exist,
> > return it if was already created" approach. I backed that out after an
> > RFC.
> > 
> > Focusing only on the non-felix drivers: it seems trivial for the parent
> > to create _all_ the possible child regmaps, register them to the parent
> > via by way of regmap_attach_dev().
> > 
> > At that point, changing things like drivers/pinctrl/pinctrl-ocelot.c to
> > initalize like (untested, and apologies for indentation):
> > 
> > regs = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
> > if (IS_ERR(regs)) {
> >     map = dev_get_regmap(dev->parent, name);
> > } else {
> >     map = devm_regmap_init_mmio(dev, regs, config);
> > }
> 
> Again, those dev_err(dev, "invalid resource\n"); prints you were
> complaining about earlier are self-inflicted IMO, and caused exactly by
> this pattern. I get why you prefer to call larger building blocks if
> possible, but in this case, devm_platform_get_and_ioremap_resource()
> calls exactly 2 sub-functions: platform_get_resource() and
> devm_ioremap_resource(). The IS_ERR() that you check for is caused by
> devm_ioremap_resource() being passed a NULL pointer, and same goes for
> the print. Just call them individually, and put your dev_get_regmap()
> hook in case platform_get_resource() returns NULL, rather than passing
> NULL to devm_ioremap_resource() and waiting for that to fail.

I see that now. Hoping this next version removes a lot of this
unnecessary complexity.

> 
> > In that case, "name" would either be hard-coded to match what is in
> > drivers/mfd/ocelot-core.c. The other option is to fall back to
> > platform_get_resource(pdev, IORESOURCE_REG, 0), and pass in
> > resource->name. I'll be able to deal with that when I try it. (hopefully
> > this evening)
> 
> I'm not exactly clear on what you'd do with the REG resource once you
> get it. Assuming you'd get access to the "reg = <0x71070034 0x6c>;"
> from the device tree, what next, who's going to set up the SPI regmap
> for you?

The REG resource would only get the resource name, while the MFD core
driver would set up the regmaps.

e.g. drivers/mfd/ocelot-core.c has (annotated):
static const struct resource vsc7512_sgpio_resources[] = {
    DEFINE_RES_REG_NAMED(start, size, "gcb_gpio") };

Now, the drivers/pinctrl/pinctrl-ocelot.c expects resource 0 to be the
gpio resource, and gets the resource by index.

So for this there seem to be two options:
Option 1:
drivers/pinctrl/pinctrl-ocelot.c:
res = platform_get_resource(pdev, IORESOURCE_REG, 0);
map = dev_get_regmap(dev->parent, res->name);


OR Option 2:
include/linux/mfd/ocelot.h has something like:
#define GCB_GPIO_REGMAP_NAME "gcb_gpio"

and drivers/pinctrl/pinctrl-ocelot.c skips get_resource and jumps to:
map = dev_get_regmap(dev->parent, GCB_GPIO_REGMAP_NAME);

(With error checking, macro reuse, etc.)


I like option 1, since it then makes ocelot-pinctrl.c have no reliance
on include/linux/mfd/ocelot.h. But in both cases, all the regmaps are
set up in advance during the start of ocelot_core_init, just before
devm_mfd_add_devices is called.


I should be able to test this all tonight.

> 
> > This seems to be a solid design that I missed! As you mention, it'll
> > require changes to felix dsa... but not as much as I had feared. And I
> > think it solves all my fears about modules to boot. This seems too good
> > to be true - but maybe I was too deep and needed to take this step back.
