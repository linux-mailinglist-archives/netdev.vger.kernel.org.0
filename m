Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41B3258AF8D
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 20:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240953AbiHESHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 14:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiHESHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 14:07:11 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2096.outbound.protection.outlook.com [40.107.243.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D2274E1B;
        Fri,  5 Aug 2022 11:07:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FfGdtRVY91anWAit9jvGgVotwebob+FDrMHMltgaG8slzUaqbmQZKcxYDdPtmOu6AXjdjcLfyZcHYgyuJTQux9OA/zOq1QgG5aeA9QOxTTI6JaEztsVrGxYD/gLz9cUU2je9eugElsU2dfV+93PWremGkbkOSAWJKC48Hys7FUDlYvINo0XK14TUhXbuc3mD0CsxC/bkKaGsarkezzrWFb/NMAl3UnC0jhS824mSeM5yOILxpdjvXh34OeWWYTt4Sma8TbECMbnS/5yjReukqyPpTRqBvPyJriHX37XEMMzkVR5D8yO/cqErEAjkHXDt6x/LwsyWeQCpgJiIM/eVFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ChI4DWj3JEcmUw0v/Vf6KhKqQcUq2s06F+6v6xlz3Qc=;
 b=JSNE8b0fL9QLn9ej6JI4NREAKRH8LnMgK0w4/pzdgjvdwHmJPtN62lDcGX1ggT3N6SsYQD47JB2i24wLOWt7BpHh8TE2+pEIrEwkTnWgrqidVm1QM/PQgSfgVeR1AuDozagppYVTNgGX2sJj6guBcG+G/6GBb35Pwu8c0RbG6FRtMegH7t5SWZR16ndSiCue/G9e+C2V0+Iw7PDeRjGzP4RW3M263R5f0qs85BXjNNddOLUb3E1f2Tkx20XuGWLMF2DHKJJ1vCu0DyEEuK2QX0WJGdGCtyJ+0PQgghUZczK3F2GFF21lOH/6gg4Fk6Wbb3tzmdgK4u/0k/tscr+5Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ChI4DWj3JEcmUw0v/Vf6KhKqQcUq2s06F+6v6xlz3Qc=;
 b=UkAcDx9QseC68lGIFBGx/Y7JJtxpdD3dffLurs5jGlyPG48XRmfPPyMTRJkbMx9l8D8oVEVnmA2+hx1X8HYz2sf44zQ520OL3AYQ07QyY04z9E+YIyTzEVtYbGcQUJ3X1EYMy4bSbWp5a479QiHDWZTmiui2Zvgz2RDQfzFAmCk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH0PR10MB4970.namprd10.prod.outlook.com
 (2603:10b6:610:dd::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Fri, 5 Aug
 2022 18:07:08 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5482.017; Fri, 5 Aug 2022
 18:07:08 +0000
Date:   Fri, 5 Aug 2022 11:07:04 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Subject: Re: [PATCH v15 mfd 9/9] mfd: ocelot: add support for the vsc7512
 chip via spi
Message-ID: <Yu1cSLlkXAr/t5ho@euler>
References: <20220803054728.1541104-1-colin.foster@in-advantage.com>
 <20220803054728.1541104-10-colin.foster@in-advantage.com>
 <Yu1W8DMaP8xlyyr5@euler>
 <CAHp75VcVD4XxydmYkgybjpCKsh=0KS5+GnDGK5CJX-qZwJ06Cg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VcVD4XxydmYkgybjpCKsh=0KS5+GnDGK5CJX-qZwJ06Cg@mail.gmail.com>
X-ClientProxiedBy: BYAPR08CA0058.namprd08.prod.outlook.com
 (2603:10b6:a03:117::35) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23d1ae7b-de76-4b07-0f69-08da770d4fd7
X-MS-TrafficTypeDiagnostic: CH0PR10MB4970:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rrEU7xdMuahKQu94enEe+pVe75lWmZcuWLh+yTIbGjQkrLwunbHRX4W3ZHYYnDuGAF7fcenhKJ51M2sptVUhlSNgxwFZh1hDW4K5FHRnStusNlSj62SnK3XEidzVp7B8n4YaTDQ2BlMait29WVMXPMQMHwleDIDHxhZ4tySyfD4X7pFzuZTbpFcMINy3nXIwBtGf9FTmd20CAlwfGN4ZXAtXKY6PeeA6Au8HNUohvbvcVHwo7iaKba2U02gmABwVNYbB0nYUCn1/iDyzKynBI6lkaL7cUvJD67Uq6gFeWg2FWuZnWftHTL9qqP61naiz/xKTtWfokP+Az/F1AA/U05294BuBQhjdUPbgTU+1zh9UeYdNN6ooCi6CgT0yKXiN+KW2gJ0ZSKGf+bP3NTzKpH1wKcPLJgKz9h61VNLbVLGip6UoTK0fZcu9EiwMjYEwheriefkoMBMw3XVV9pJfGpMCvXDbByHr9Q8PYU+mRYxXQOEy6uUQrE29fII3payjGkzWDmA2ees9YHGaGhJXvyX3riF7MyzpwFkXqo9x+7zH4b96hB8BiEfQjwlXRS8umGoymDazsxsVt5mf7FLOsEmCpn6S55za41CUIyBU15IuhvfKUnJ59RYeOGHswlnpPD3pRK+alefnAe+bF9VbIK5e4mqZRfOktmu4fge4A23BQtfOlnRWtVHQDPbK2nyHLPkt1XWStm/X27OaP6NA6aksXR6zxTEv1MvcVmWgtBXd3hd5I1c1xGmi7Fvi7QCy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(396003)(376002)(346002)(136003)(366004)(39830400003)(2906002)(107886003)(7416002)(6666004)(44832011)(66476007)(66556008)(66946007)(6486002)(4744005)(478600001)(316002)(41300700001)(5660300002)(33716001)(54906003)(6916009)(186003)(6506007)(26005)(53546011)(86362001)(4326008)(8676002)(8936002)(38100700002)(9686003)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?djo1DK1p8Zkz58KuYw3JQNsU6vDpfjmdd268s6dBap+hMALmwJK0xG0knX7/?=
 =?us-ascii?Q?X2eqAE0i9gN71H+ym3Apr24WAq1Dy01p95Euy5IIKCMZHtYvdF0ed3jF6Bnm?=
 =?us-ascii?Q?qHc8gGbX5z32A4eEVg8eW1tnAknv3RrnIjonO1DjHTsEVLzNejFudJqIYsiy?=
 =?us-ascii?Q?/QojP+y4luN4tmrGs6885pHu7F4ba99UAuJixp+pF6UBrxLJLbQJirItUCfK?=
 =?us-ascii?Q?EvpLsXESF2z7uVxs5QYgrVdXDL2/3IidKm1HqSY9TLg6BHmDNvuY5jrjMoWH?=
 =?us-ascii?Q?M+Nk48vKjaaqu2NP9jv/A2yXhbk+2ZVsWwgGqRZ4gxF6nVTNy3h/2euezhvQ?=
 =?us-ascii?Q?fDm0mlSXzU/vpqK6vJNYKAkUQlOtFhnHySkap+T9Mt4YvlQhM+66Y0q8ZqRS?=
 =?us-ascii?Q?jqN/e4U7auvMgEUh2RKNGmtaFoyyyr5QB84rUpxpTazyVXfadrEo64KzPpJA?=
 =?us-ascii?Q?yx3vbovq9FlvYlWUQDc5ayEtVIeMPonFGeYOIjXRRwOvWzcVd1mm2ma4+83Z?=
 =?us-ascii?Q?/K1AgeEicWiF6/ziUayYDbwvmxOWxAhnuOTnU+HavsmyHBf4UmYnZddYBIFD?=
 =?us-ascii?Q?2GOSEExI2+ojrVfAZtO8zHZMoQp6tYFZx10X2sUO78ugTWmyYxw1IbrPFFAc?=
 =?us-ascii?Q?DDx6HYe7rLkF1o0HeZJhOqNepF0Wjj27CkNpUFeH5CzhDSRyP0hsrzOSMBHn?=
 =?us-ascii?Q?I2iBRJ1bhZYp6+pDYiuHmB80hlQtcjAQtPykotRaNnF3cXlwPrS/MOqJLOi7?=
 =?us-ascii?Q?8Hw2tQ3eoVfdyCNE31Z7OAbyFyDwSKZk9AMBho9hXwxFvQ8rC4IFDEIyzPRQ?=
 =?us-ascii?Q?fQPki9p0iwrUNb+6czf38Ws+kR0Zag09OLjghSz2P6pbQ2fsjf51VuR13s1f?=
 =?us-ascii?Q?K/owcskyLaoqfWbnCIAM4UqfgSnZmsqgStHFwPvOXqonFKPYjxlOQJgioTOo?=
 =?us-ascii?Q?yl+QMrsR93H+Sawj2GlDytT/t6eJHkfah2QvBwKDT6bPDwDHzOpLv9W3nGJr?=
 =?us-ascii?Q?mSEdr9IglPKI+o2XcKO4NN2Dzc7kwpnE65I3M9xXOoIzG2B04sLaEmQLb0jd?=
 =?us-ascii?Q?DWaUYixT8W8VcTjV2gszttFIe3grKgQZwz2xSIWr1IH5zMUa/eJyDMxCV1Bs?=
 =?us-ascii?Q?yz7Ak5zcup3nydnWrbDbAuQwxMxAJ5JbZl/NWV7OO5TE5n44vUjhejIB+asA?=
 =?us-ascii?Q?FoqVSRPimevdBwMWyp5j74ZY4jLZaGO7ASdJwA2uwFac5KPnFQfoFI578o7P?=
 =?us-ascii?Q?Ku2L/e8U5tCuHSeRhcewQ2w04Lx4bbcGU1lHXA7eSmB4GLbKJiQfrd86DG90?=
 =?us-ascii?Q?Ln7b3xhI52s/D+5hledNlx8SPBZ99lk4gFAKvAyQEum1T2yxzZoV5uqxoJSB?=
 =?us-ascii?Q?MIRT1mYb5zkBDWgyKPh+rw5n5zlLVtcv+USLAR+KBZGHfpR1QmduoWHtSQ3V?=
 =?us-ascii?Q?8MNiSsMZmL+H4y4i6EvneJVtdJM/pZze4M4levIPpytwJ9FHwhmsI7Altd30?=
 =?us-ascii?Q?e0fhoRRswbTD855mJGRByacVFGzek+KYJR4fqZ5NYx8Pa5BAIwsBEQgm/WCZ?=
 =?us-ascii?Q?de3MwHksAWbbQdtb11CTnW+/Qbh7gthqtS4fpQujELKNcqYLhan5nEgZNe3Y?=
 =?us-ascii?Q?yWQBQ67RHRLgdSk2i+rnULs=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23d1ae7b-de76-4b07-0f69-08da770d4fd7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2022 18:07:08.6152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P3p5PEwszPsx8Zz6c1zemJcdaCU8798ATS+8IdjOVzHnViHBwtDXOT633eVovJ15Lhhu+aiwF9xNVLCKx8fhgT45TnJOpo+okDLrhUPTL0U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4970
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 05, 2022 at 07:58:06PM +0200, Andy Shevchenko wrote:
> On Fri, Aug 5, 2022 at 7:44 PM Colin Foster
> <colin.foster@in-advantage.com> wrote:
> >
> > As I'm going through Andy's suggestions, I came across a couple more
> > include changes / misses:
> >
> > On Tue, Aug 02, 2022 at 10:47:28PM -0700, Colin Foster wrote:
> 
> ...
> 
> > > +int ocelot_chip_reset(struct device *dev)
> >
> > #include <linux/device.h>
> 
> Nope,
> 
> struct device;
> 
> ...
> 
> > > +static int ocelot_spi_initialize(struct device *dev)
> >
> > #include <linux/device.h>
> 
> Ditto.

ocelot-spi.c uses devm_kzalloc, so that should still be included.

ocelot-core.c uses dev_get_drvdata.

So I think I still want the includes... but for different reasons.

> 
> -- 
> With Best Regards,
> Andy Shevchenko
