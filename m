Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272FD58856B
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 03:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235310AbiHCB2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 21:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234385AbiHCB2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 21:28:33 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2109.outbound.protection.outlook.com [40.107.237.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F4E205E1;
        Tue,  2 Aug 2022 18:28:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d3wVSzB1+j0pSszPC+X69I6GLu7MVwGoZWWSxaRBuqb5oICIEj/ehBAYQ9+3KGqH0zMS5rg2Y9HRRphjm/qt87IO6nmOkdhXI6g3uVuoDpiYPFN707TelmARQV5t9XyehzsVITOXygnZio/Emunqiuzy7Cqa7EJku4pRWluKLmivfWai9acDJSDRaJk2Ls4Lx9czsZeEPG0ugNrWfI/E7LI88NrxFPkO4Vd7TUq4ikhu6PsFU0gIwHkc3PG80fuQlkZXzmNppInnUjrKMXqQAx9MZv9HXekxfJCOkMIVfSgAfJIpZyvEnLAkSgyNSfjqoWQmf51fFkZvxm8eyMmFjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q0kVP3F1uMN9slbJCUWyqjDHGYwLcoc0Ra+9uaXCRuk=;
 b=OipdziJsUO52h9u1xngtvHv8lkZ7MM57RNkEuykLrR2GeS3Ju2JWwTMXetnGPA1jGQ57fYIPZBL+tcmvRU06vCSoJCK0PfNrCF9CmF/RhXnOCwtG89kfBgeuMDpD2naNjGInGm8vLyedxqJKrimie3mcGO3Wyy56bNKUcaKx5tRLz8Y1uTE1jYXYfpw1/4RSyfocog1Ff2Q4NoIASxp3AituND9XCcm1fFvfPj0v7KwQxUKo7FaMAP+z0O3YxBg3TY75XpyzxG27eC380Ij1fj8pf8xFcmCx3RF2HxmWTDTbPHXOuNFxig1CKBhxnMJttCGe4DDrmuoWoa0oVzCtDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q0kVP3F1uMN9slbJCUWyqjDHGYwLcoc0Ra+9uaXCRuk=;
 b=VTvHcHPdZFBlfKGUk9hr1LRehchfPG+0v926uPkXwo4ruVatqijKnXYigY8zYMpHh3j2+XxH/TwzC48PNgPoKC4vIONRlB0Zby5tHsmMZvEOhN2kVXYK7zfYGotXsNakLrsnTQeWwWO+vesa6jZsEeAxzG51IoCzwUi5Dvex7LY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM6PR10MB4138.namprd10.prod.outlook.com
 (2603:10b6:5:218::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.14; Wed, 3 Aug
 2022 01:28:28 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5482.014; Wed, 3 Aug 2022
 01:28:28 +0000
Date:   Tue, 2 Aug 2022 18:28:24 -0700
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
Subject: Re: [PATCH v14 mfd 9/9] mfd: ocelot: add support for the vsc7512
 chip via spi
Message-ID: <YunPOAnGaI9xF79n@euler>
References: <20220722040609.91703-1-colin.foster@in-advantage.com>
 <20220722040609.91703-10-colin.foster@in-advantage.com>
 <CAHp75Ve-pqgb56punEL=p=PnEtjRnqTBSqgs+vVn1Zv8F94g9Q@mail.gmail.com>
 <YuiJLK8ncbHH3OhE@euler>
 <CAHp75VcHU+Rh2ROjMcK+Yuyu1Ty9C0Dcx2SjrnrM4BV9NuMZig@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VcHU+Rh2ROjMcK+Yuyu1Ty9C0Dcx2SjrnrM4BV9NuMZig@mail.gmail.com>
X-ClientProxiedBy: SJ0PR05CA0185.namprd05.prod.outlook.com
 (2603:10b6:a03:330::10) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1a03852-c0ba-47ce-93c7-08da74ef77bb
X-MS-TrafficTypeDiagnostic: DM6PR10MB4138:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZEIrPv0R5/i0Qze9bhPLspauQyBhZ6bGvCpJ/nAj8FHADxcfKxq7wOsMsx1givfNqGUjFFrnboU3Bb+ZP16lToSAAavSTNPJ7Op50Fn+sudsFImdVBEt3K6/+iqAymwtHOBM3w4C2SuEhZ9h0Hxyp4tNC6lxC/Vt8LX65PlCIPhFdTiBJzUi/86/5raOHFcbTIZWf4RhhnvXwD4ZTdnGkDtb/aETA8WthgnsWE871QEZwPQuYYamx3s4VDmGupyoLKRsSCzfcy8COQyFUU0K97U2bvf7FIGce8IXdRHq0Qv+2/X/P4AKzhwxJH0a3JqRA0N749BtVYrcy0ti0ssITwdsqd0m2zXj5bofbRI69mC3uGA8/P/DUw2y403bkDMtngbOTO/2NOL2UG6CkIaUvAazg/VjS4KjpOZjijFGBlRdn3y2zYLvrhLdlJzXpRGz4sQBapvy8ZzFjaq2rice6/3QgWybvx6vX3N+cT4arKhAcxMPy7/gM9P/N2ZTyTNeAdX5K8bWOdjhdftsrp3fydPEXFc6pNKWEn8yhLIT89h3a9QtFvaSPWUIzDKAhmMYlOCmPh/B+qykNvjena2qlZqU+tipqJrp0fWc2NUFjE2mCmVQbPoZBVxmcuV7jy50ccPvjbFv9p2dY6wMHTQMKvhMlRdJtaZnRMtlL6SZ+bnatBEXPY8vVfwnnuWwRg7hl9hQasGnWE4IkfcdMrPSlR+ZXho0c3rOASn/N5GB3ajgN7K//E2qCo2F4NorAH9W
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(376002)(136003)(346002)(39830400003)(396003)(316002)(7416002)(5660300002)(4744005)(107886003)(186003)(66946007)(8936002)(8676002)(44832011)(4326008)(66556008)(2906002)(66476007)(478600001)(6486002)(33716001)(9686003)(53546011)(26005)(6916009)(54906003)(6506007)(41300700001)(6666004)(6512007)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LGtv+hwi2BrgEOnGngs28BGC99CyxE1x0r5XacumZrQU8M1xAVc7qQG/0JGo?=
 =?us-ascii?Q?i1WqSuwTAs5iGkfD05EZtS4X/BBrBF58Dpnu4L+W5Tz4sZ7iSW9VzzOl4d/m?=
 =?us-ascii?Q?5iZSw8DJHtJ3gusdTWYP1+wnTZ7v2Sm6ETHePZGps17GXTnmY/M+3lWULNYN?=
 =?us-ascii?Q?1FGR9VUmVpgg7Y6IDDEKpcb10ejt5aaFwyuICtnuPU5M3G11V0Rzm7ZkJy8W?=
 =?us-ascii?Q?FsfExV8g2mAon9nyI8cmiq2Qs2t7hhsQ6HzRIP5ylS6+bWJtxic5dWZgfeBL?=
 =?us-ascii?Q?F5Zh+EeHkkovtyEFbYCPmSuxyP0tuyJvYM8vkogZizopNQ4HntSBo9Z2MhGN?=
 =?us-ascii?Q?g3g7VbajhXMF5fsf0sy3VD8M6lHmLiEwfsL+nBh0Aez3+WwrpSZf+BNfsZm2?=
 =?us-ascii?Q?pa20IhUlL+5DkKfQaCJgQRxt0tzZ4gghpB62BaJdYTUcoZqlVJ2nfwqYIh2W?=
 =?us-ascii?Q?Ft+jL7aH3vGbCz681EFdHEy0YBIM6aSQE1EuwsAj+x1UgALxYFXxbNeD9a5s?=
 =?us-ascii?Q?8qHq5YPtzICT3I0Tvuk6IleC4ECpV57DvPl+ebl4zv8wFi+qddIZXnGqTPDO?=
 =?us-ascii?Q?fAeqWZ+8mBLqmQlaz2BanfWNCgAO5cvjtNL+zdQVrVkhIwxOC3YIq9caG9rG?=
 =?us-ascii?Q?XpGmMauf8q4IrGhqjokUe3ba+5NVKYAc1E4oDTUiJ1PQa4HENgN6m0M3q6c9?=
 =?us-ascii?Q?OYLit4SdkOgr2dkQlr6jG6x53GgqaBmLd4mSZ1+7YDdE+J/iSSMjFKtGRZRc?=
 =?us-ascii?Q?5tZ76cSBf1ihDdeWikgakiHSssiRTKzlT+NPatHXxbiDmcsL6q6yZlWd8+oa?=
 =?us-ascii?Q?Pc2UaMBtR1TendKF0H0+5NLK5wIXMurEYfhjoEekZ75O9WUl2aZdW70tblBM?=
 =?us-ascii?Q?TjrgYV44IqS6PRkj2PpdhSHujGOS8cQ31sxiaCnJ6j5aRoTo7kxOBRubiDsa?=
 =?us-ascii?Q?J80FCaTis1024fv+I+tUaS9m8WJNfRncgYCwlIVatZBtSnlWD9Ads+zPA+U3?=
 =?us-ascii?Q?+tA7k38GjwzjKbrsdziO3uf3JwrUFuruuVvDbKowAkxDyQ5cI5Aww5jDL/Fs?=
 =?us-ascii?Q?XR+FlclyjUNAVYhdvJH7+7tcnsY0djqnYPcM4aVubP4d64aE6nIlAldkgusD?=
 =?us-ascii?Q?zmfrBRLAfLBO32q535yC0YxoDdlnV+qTXFTontBbSkNLu7WU5p92fFpETIRO?=
 =?us-ascii?Q?x6W5D2zVtGl8iGwBfi0zqspcNrXjKB9nVDFxzJc0Xq3ZVHq7gNseLOp4cXV8?=
 =?us-ascii?Q?G8BA36JtWzGLjGYN2ub43/H8k7+sPAmnVBVTdSsfvuVdGCN7c/8ttNpoO4zZ?=
 =?us-ascii?Q?zxcB4UtZwpcmNDejd0T+sDlDa1v5c0TPfiwByBIBzfZbW7HHfpqn3xwr4uvl?=
 =?us-ascii?Q?1QMCxE9Q/Zm5qQvzizhhPz9+Qo5PWtVw1u6v27gWIHGctzYf0OFu50GTajRJ?=
 =?us-ascii?Q?2Kotu5hcQYavgy4yQfZhxaKqLwZFxaP3P9bQDBaif29NYIQ1ny0QXFLbTdks?=
 =?us-ascii?Q?rbqe83BZ3K173w6tfggEisfhOW8mF+UW/OgjKTTLe510RjQ0w9bVF0jLrNn9?=
 =?us-ascii?Q?G8KI4hferx1gU542KWsw6uhbiXAOzGncGtTlrg33LmBuTG2HotGdtWFnHKAh?=
 =?us-ascii?Q?4Q=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1a03852-c0ba-47ce-93c7-08da74ef77bb
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2022 01:28:28.3477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xgOM1sC8pIZ4NQlYd6ZM1laL3zbaOrALMBMlqFtHYZNyixY5daklPEEJwewIMR1xbQy+SD4RgayJDNhR/XjBStDMIcjhAeJYY1vLjYDlt28=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4138
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 02, 2022 at 10:47:04AM +0200, Andy Shevchenko wrote:
> On Tue, Aug 2, 2022 at 4:17 AM Colin Foster
> <colin.foster@in-advantage.com> wrote:
> 
> ...
> 
> See above. I.o.w. use index based assignments.

Will do. Thanks, and I'll hopefully be able to send out the next version
shortly.

> 
> 
> -- 
> With Best Regards,
> Andy Shevchenko
