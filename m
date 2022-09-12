Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 199DA5B6271
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 23:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbiILVD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 17:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiILVDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 17:03:54 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2126.outbound.protection.outlook.com [40.107.94.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926A246DAF;
        Mon, 12 Sep 2022 14:03:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NjbmDhGJZvEl1/Uh9GY6SWHI0qGQgDH8bNlMsgy33hNJrwZFXTc/TR42yRHsXY65U8LTfR4dbtrdzXj4nW0dIEOO/DFrzRyAxf97vZYXJCP4KWBDfc9Zx3KZlVCc3YL5SaMzHH4sFlmq+1G/LcG5jJ81zVHNYcdh6YMF4XwbjU7T4spYERhjmYduMFpJBoT2E0O4y9JUsjwuvokYHCtxeAb5qn4kEuzsNckYnv9otmIYphY9fe0rzTtN+RZvyRcyoZ0f669/JQL5g8e5qD61k7EEKULwi3cJxo2J7VZGkNcaWmEWAiS7SI/e7cRDn9D5gbOCVJkg8qn8afCUjgR23A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pR+m/3N59qG4/12CxBZfl8Is9prusqEMTMixsqFVJ0I=;
 b=VtyS7GJL6Ol5+tLrt576Kcdk5HKpZqtDHkEjadXft/Z3gxYGMungkeGh30XojlBxECxx1Dy5GKxPkZAWptuYARasKwsCcgDxFMZM0jYVhckqgbwRu3H3uHUPFPwhZ2QT8aMVJHB8HjVlG7xKeMI44puPk44sbB5711Dyh709EVRW8Bcvmzh/hkGknVIHc8CKpt6Hm1OfuzOMimTxNgux08XCiMpWgryvv//Hc3/CRxb7Hplc8Hyq42dAJeL442W+ODK3uziJFtSUTyn8dS3ej8mqVx3GLMJ5vG+XhP+WjqZIwSq0fxXwVJdgd5GDmEMcKVsCD0kQIUfw15IeAm9jJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pR+m/3N59qG4/12CxBZfl8Is9prusqEMTMixsqFVJ0I=;
 b=hx8ttyMw4huSDSyQECsbjrWzf4qUM2aux8pYzbuDgSn/ZxIXacJTZeVpDLtJUhlAw86mVtJU9OGjBtY4wq45cdlPe65cyfB/0fAeUwMfmqofwN9sBOtMmHf2MMr6Aul7YAzhNUUJFAK98C5ULAkcUrT/tlSxpCsum0HqnaVchPI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN0PR10MB5335.namprd10.prod.outlook.com
 (2603:10b6:408:127::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Mon, 12 Sep
 2022 21:03:48 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1%7]) with mapi id 15.20.5588.020; Mon, 12 Sep 2022
 21:03:48 +0000
Date:   Mon, 12 Sep 2022 14:03:43 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
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
Subject: Re: [RFC v1 net-next 7/8] mfd: ocelot: add regmaps for ocelot_ext
Message-ID: <Yx+er8l1CzutF8jo@colin-ia-desktop>
References: <20220911200244.549029-8-colin.foster@in-advantage.com>
 <20220912170808.y4l4u2el7dozpx4j@skbuf>
 <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-8-colin.foster@in-advantage.com>
 <20220911200244.549029-8-colin.foster@in-advantage.com>
 <20220912170808.y4l4u2el7dozpx4j@skbuf>
 <Yx+CzUCbNgAjDK5l@colin-ia-desktop>
 <Yx+CzUCbNgAjDK5l@colin-ia-desktop>
 <20220912202321.5yqmmf2j7gcljg4j@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912202321.5yqmmf2j7gcljg4j@skbuf>
X-ClientProxiedBy: SJ0PR05CA0011.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::16) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab6b421a-6e1b-4eca-8031-08da95024983
X-MS-TrafficTypeDiagnostic: BN0PR10MB5335:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iA3PUbPYuCGlhLEyJ5Pl12iXx3a6kBJe+RJq8L8fBfIV/zAj7SQmqmy4ZjUj8rA8zIyH3EsrAddE+kNIBQlGMtPS7zAKmTr3UVsf1MxSufn2rYctnDVBAy2mo60OZCFZ3uRn02zDoiRwQDbtxeF2R0MERmwyl/7Nv/RTHI2JkfwohODXx/Oi9ib77lD37DiMKjWUNqj7B8sZ14y7+rxQM5O8SbkrgvQPgwPFBYR0Er7pCbAP9MiL+X2OiCmLazYop8+eji6n3bZXBjCUShxG7a4QLy9Z5Equ+zj7KmV0rQFYKIWcEdziVEZL9Ofvfxp6bmhNM3eqUh+hocqQG+NHRqkwRzNGoOgYSuj6h+mJR1aq3dVc9Fhi1CUxArLEVnZuZjZTcsD3zDJZmUgbWlyYhgKkMc39Nj2sAjVMzHfi5NPUXNluiN/QFZtlWC8NGmjctdZk11K7FZrXzb5PPgRpetmMN31AK0l7kQKCoG5Djm++YsPgmE7ZiQLxigtYFzA9F2rdK7ZqyqZ/hOCO9ZYegIrTK+WnrV1D32sV+nJdRD6riL/ILqxRgkECkOT/zKwRM2tYadtbJ2JVYuX0Rc1LU1MpDhwMrH+YmEW/W1JHOxWHs960e+BdmViurw/Xe85YsigxPzGZv+OHrjr90F7MZ3aSVyv0+19VKxOWYXiw3WCNkJw+n1yIKmtrpmXCeHeShPYB1lBb/dbgJhNAgkMbe59t59j7FiuzeBK4Oki/S2jUCFiMTlTofH+moE7cS5ja
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(396003)(136003)(39840400004)(376002)(346002)(451199015)(4326008)(6512007)(7416002)(478600001)(6666004)(8936002)(6486002)(33716001)(44832011)(186003)(38100700002)(8676002)(83380400001)(6506007)(9686003)(2906002)(5660300002)(66556008)(86362001)(6916009)(26005)(66476007)(54906003)(66946007)(316002)(41300700001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zgOQmPLNp9/3uco1ukWqS8O5G8hKg1EIlRkoTH9JLXjH2ycf87jzHyfZ2Z4/?=
 =?us-ascii?Q?cL5G4oXejZwBUuAkFq3lOzHrWt9jF4e4whrJQiaEKxFMM3IU3i6KlRfaur+l?=
 =?us-ascii?Q?Nxx0/agRcwmnF46iVSjI3jyhcO8m2rpDogazOaHb5i/YpulQdMAGc90PdgQb?=
 =?us-ascii?Q?l5U9kJLk7cyYrtqILwEzC9dY4wq9nOSS3kLEhycmTQzVKc9IY+94fi2XnzP7?=
 =?us-ascii?Q?1bBNrKd8k7qMrZjaPJoQjySdvaybDKt6yEZUz98s3jIyqqvYZfAqX0/3yORX?=
 =?us-ascii?Q?yPn2JCxuq+9USKmtHyEpzrRbViFgDPTZiBBWAjjWVp6le7DkDLbDKMIvbM9Z?=
 =?us-ascii?Q?OvEFISTptGhc9bXDqEUYo4QOXNnuxqfOLPW9Q7MlmwHfuHbPaZaDXwZzmlBV?=
 =?us-ascii?Q?b+Eb9qKSpeljSCo6dLKLuFwnUStid6S/pn7PDAduo8GGvyJJrdHbnb+/S10x?=
 =?us-ascii?Q?6BJE/EPnOh/SsORFvTECMWSKPwCxCVJdrv958qAKIW2IAWZ1HFHjJkJf0Cdy?=
 =?us-ascii?Q?qYrZk4FbZiLiJ2lqDOxUcLb/UJy/nsjKpnkHz1sSSqc2gRePYiB4xiJeUaOz?=
 =?us-ascii?Q?BesD7iGpvjoDJAzdb39cSXk4GefUDyAem65egFmwqwr1CPqm73iGHLNF7OrQ?=
 =?us-ascii?Q?tmJykME36ZHsaasCV7SXS0vCuNVPakMYfzrxhZ4VNyl/vOKGSeheAly/Cafs?=
 =?us-ascii?Q?TvmXlBD2oXHQ2br0mmWb0+kiTq03zru3Mq0ltjtZ/jszBJ+BlJoLFpBkdCZF?=
 =?us-ascii?Q?zP9cSZfHfen+QAMXfgZ5v7W3txu0y/l4WAKgsEFffXuh1CxiQ6u/cQb7Y/yO?=
 =?us-ascii?Q?vwmhXYjjj89OtF99f9lw1Xz2uSgYi0WqysE3DTbATm6SW0GpdRhAe+47k1Y3?=
 =?us-ascii?Q?NA3f4SFCmT8bI/tEG1r6+JkOoE6qTDHlM+VCtCsgXg+8pd3onhGfZa44Ankf?=
 =?us-ascii?Q?u79TvANzvPZtlsWukWwUro00050tYH/n0QjXhIm9WxEvYSxk04j3i8pdzBq6?=
 =?us-ascii?Q?FW6LuKk8OKjkVhG4i9Ss2E7XOUHQAJPTFKD62MTkQfK/nqHDopdYg8gaPhUn?=
 =?us-ascii?Q?B5BM+30WjPbDUrLGk1nMJAkUnpR5orx22B8iKYLtaW2E1LAYUQTcoME068Lv?=
 =?us-ascii?Q?2e/ZM1hd7A7bBeUeQ1svqXmmlbrnWUfgUG6wNe96fnR6tNHto3mcFv5O9JDf?=
 =?us-ascii?Q?RXei6THB1TNIDMneiBvU3wM/dDyOi3CJdTvb6itNbk7lhrnKqYTEjO0x8A95?=
 =?us-ascii?Q?u0AyN2IOZKX3P4kKuYudSsJIy5syy8xePhGfVVLWO38Z3Jz3y1E7RwIqUGMN?=
 =?us-ascii?Q?PP1uO0cKwhogeQagfmSlvCFlkROkL73+3FbvxWQ/r96ewQEkOPPtqBMOJnlT?=
 =?us-ascii?Q?0upgChtbThPOiX/JNoPFenFapCgZvnr2tU/7lv69QQnb4oxGnKCwryLybcA2?=
 =?us-ascii?Q?tDOLHsHSLNCoDxguV+LLYya2BtljGXhCiakTzhHVh2mNE+GIwXvRR0PJCsNq?=
 =?us-ascii?Q?Ts0bvpvcq0I1CmffJj/21CCJCYKxLIKq3DtqvAn6GrdfCUr3n6YY/QqrgaVS?=
 =?us-ascii?Q?Vl6lyQHq1aEMWRrXQWZbEZu+EdE0vBpVFC99jHJ6z0uM4+YD/5AYVonurz+3?=
 =?us-ascii?Q?yA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab6b421a-6e1b-4eca-8031-08da95024983
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 21:03:48.4830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JBbirpRdjDsSfa/iNmP46Kc2aL6BF8hw+HZ8Is9Fb72V0sU2AFywAXK7WAqORsuKSszf+2myF4gujq+O73wul6fxZiVPnhocT8wDriCtLKU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5335
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 08:23:21PM +0000, Vladimir Oltean wrote:
> On Mon, Sep 12, 2022 at 12:04:45PM -0700, Colin Foster wrote:
> > That is exactly right. The ocelot_ext version of init_regmap() now uses
> > dev_get_regmap() which only cares about the name and essentially drops
> > the rest of the information. Previous versions hooked into the
> > ocelot-core / ocelot-spi MFD system to request that a new regmap be
> > created (with start and end being honored.) A benefit of this design is
> > that any regmaps that are named the same are automatically shared. A
> > drawback (or maybe a benefit?) is that the users have no control over
> > ranges / flags.
> > 
> > I think if this goes the way of index-based that'll work. I'm happy to
> > revert my previous change (sorry it snuck in) but it seems like there'll
> > still have to be some trickery... For reference:
> > 
> > enum ocelot_target {
> > 	ANA = 1,
> > 	QS,
> > 	QSYS,
> > 	REW,
> > 	SYS,
> > 	S0,
> > 	S1,
> > 	S2,
> > 	HSIO,
> > 	PTP,
> > 	FDMA,
> > 	GCB,
> > 	DEV_GMII,
> > 	TARGET_MAX,
> > };
> > 
> > mfd_add_devices will probably need to add a zero-size resource for HSIO,
> > PTP, FDMA, and anything else that might come along in the future. At
> > this point, regmap_from_mfd(PTP) might have to look like (pseudocode):
> > 
> > struct regmap *ocelot_ext_regmap_from_mfd(struct ocelot *ocelot, int index)
> > {
> >     return ocelot_regmap_from_resource_optional(pdev, index-1, config);
> > 
> >     /* Note this essentially expands to:
> >      * res = platform_get_resource(pdev, IORESOURCE_REG, index-1);
> >      * return dev_get_regmap(pdev->dev.parent, res->name);
> >      *
> >      * This essentially throws away everything that my current
> >      * implementation does, except for the IORESOURCE_REG flag
> >      */
> > }
> > 
> > Then drivers/net/dsa/felix.c felix_init_structs() would have two loops
> > (again, just as an example)
> > 
> > for (i = ANA; i < TARGET_MAX; i++) {
> >     if (felix->info->regmap_from_mfd)
> >         target = felix->info->regmap_from_mfd(ocelot, i);
> >     else {
> >         /* existing logic back to ocelot_regmap_init() */
> >     }
> > }
> > 
> > for (port = 0; port < num_phys_ports; port++) {
> >     ...
> >     if (felix->info->regmap_from_mfd)
> >         target = felix->info->regmap_from_mfd(ocelot, TARGET_MAX + port);
> >     else {
> >         /* existing logic back to ocelot_regmap_init() */
> >     }
> > }
> > 
> > And lastly, ocelot_core_init() in drivers/mfd/ocelot-core.c would need a
> > mechanism to say "don't add a regmap for cell->resources[PTP], even
> > though that resource exists" because... well I suppose it is only in
> > drivers/net/ethernet/mscc/ocelot_vsc7514.c for now, but the existance of
> > those regmaps invokes different behavior. For instance:
> > 
> > 	if (ocelot->targets[FDMA])
> > 		ocelot_fdma_init(pdev, ocelot);
> > 
> > I'm not sure whether this last point will have an effect on felix.c in
> > the end. My current patch set of adding the SERDES ports uses the
> > existance of targets[HSIO] to invoke ocelot_pll5_init() similar to the
> > ocelot_vsc7514.c FDMA / PTP conditionals, but I'd understand if that
> > gets rejected outright. That's for another day.
> > 
> > 
> > 
> > I'm happy to make these changes if you see them valid. I saw the fact
> > that dev_get_regmap(dev->parent, res->name) could be used directly in
> > ocelot_ext_regmap_init() as an elegant solution to felix / ocelot-lib /
> > ocelot-core, but I recognize that the subtle "throw away the
> > IORESOURCE_MEM flag and res->{start,end} information" isn't ideal.
> 
> Thinking some more about it, there will have to be even more trickery.
> Say you solve the problem for the global targets, but then what do you
> do for the port targets, how do you reference those by index?
> TARGET_MAX + port? Hmm, that isn't great either.

Yep, that's what my example above shows. Not my favorite.

> 
> What if we meet half way, and you just get the resources from the
> platform device by name, instead of by index? You'd have to modify the
> regmap creation procedure to look at a predefined array of strings,
> containing names of all targets that are mandatory (a la mscc_ocelot_probe),
> and match those
> (a) iteration over target_io_res and strcmp(), in the case of vsc9959
>     and vsc9953
> (b) dev_get_regmap() in the case of ocelot_ext
> 
> This way there's still no direct communication between ocelot-mfd and
> DSA, and I have the feeling that the problems we both mention are
> solved. Hope I'm not missing something.

This sounds reasonable. So long as it doesn't muddy up felix / seville
too much - I'll take a look. It seems like it would just be moving
a lot of the "resource configuration" code from felix_init_structs() into
the felix->info->init_regmap(), or similar.
