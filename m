Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02895E7F03
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 17:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbiIWPyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 11:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbiIWPxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 11:53:40 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D1B14769A;
        Fri, 23 Sep 2022 08:53:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ithoz8EfzSkyDN1tZk2umTxY2ew0JELBIMC0jEDfLsz4tjs/Iu2N3zBCpoijBcZV1CVXCS48LE+Fv50jXblbOi8tpAW2P514vaEPaHIB3CAfmSYT0/TzUPfLE+Snffv2MCFIGBc3G4pK2HOpaUiH8oeoyos78ys4QUHo/hZ0KxJ5GDqdNHD5A1jA9gAMcNMWVNDeHY1JWOsvO4Q5XUiQyejOHC7HKsotIHn8Bc+eSmHk62wXibmRcX8wY8DarcCypeVj04/VJcLcttI52txOrZ/V1lC+VmpnNFYiUxgr5rm5RUKk1jlLMqEyUsmIc6FuzC1GAYyNw4QjKlrnOafv7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=knKQE2o2bP5O/7sszKiA1mpLODGfMgb4IiS21vGdmjE=;
 b=Zikz5RhUZcAUHTQvcaxt2VmJLg6wnTsFVcaLPg0hIrvbS7WFO7VpkQesUUvW88rCc0Re/fVv6bi0F1SH7gbNQW37yvrPqj8kh4FQMhgpT9bDib98Og9bedx9UoSUjAC/XcaiI5uy10TUAQXgV8lv85uhiSoqRUWZQVkU03R6JjKimPmKpOFejsrc1cfQK7DgX5C3Q6NQSDRTM9u9GUCyHBpRRUIuHpf363kG/ZvPkfyHohGuC2tJhLaNf8J7KFEZWcIroJpASVCSQeZ858nQUcBE4XdwfRZTkpuwuxI7Pd2dAAjt/Ly4NNS88GHqWu/3x3XZTEARGgIqWKJ7Rd9w+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=knKQE2o2bP5O/7sszKiA1mpLODGfMgb4IiS21vGdmjE=;
 b=Dh9GpS75ms88FutQKR0mDZ+mFZZiDBzzxngkuNwTGRgQ9UGIQpPTYc+JIsUJyKW3UkNO8j/RnXyIOaSiqix3Tx3DysT/4/lF6NKd2moELL4/oVdYCOXz9TdUf6cp0zFhWJiptDmzYyhLvAmkHhswo2BhM8w0FH5UGWMcwLiaGAc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by BN0PR10MB5173.namprd10.prod.outlook.com (2603:10b6:408:127::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Fri, 23 Sep
 2022 15:53:20 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e%5]) with mapi id 15.20.5654.020; Fri, 23 Sep 2022
 15:53:20 +0000
Date:   Fri, 23 Sep 2022 08:53:16 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v2 net-next 08/14] net: dsa: felix: update init_regmap to
 be string-based
Message-ID: <Yy3WbBjMNllNQ+gs@euler>
References: <20220922040102.1554459-1-colin.foster@in-advantage.com>
 <20220922040102.1554459-9-colin.foster@in-advantage.com>
 <20220922193906.7ab18960@kernel.org>
 <20220922194009.276371fc@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922194009.276371fc@kernel.org>
X-ClientProxiedBy: BY3PR10CA0028.namprd10.prod.outlook.com
 (2603:10b6:a03:255::33) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2345:EE_|BN0PR10MB5173:EE_
X-MS-Office365-Filtering-Correlation-Id: 804b2662-cf00-4f93-b5ab-08da9d7bbcf8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RF7zryiIJgF0mZ/x2/UiehoxXIXyN9JPPPSfBWlmRzKNcf5qiUYlfaw5cc1pNxa/sy9t9h1E6oFVBZUul5RxT/hD0Vkf22OWUbMXXY9IA38OO+0/sqtkU9mTC+enLQao92Mu4OXf/lMUKNvjgby94LydZ7CA9Bc2GWL6qbog0N/Yx0SoD20sC4fIHUtwEZQ73gVbJy/ExsIuE+MAY0rCnah8gBtNTzY4O0MEN2Yl84GRqlyTz81s7K+pJLD5OcKUhap7YmhpFJ9knyfnNZkXndpvtZNACul1xnhJWy4VDZjU9bn/Hc3CTDnON7OAFwOFHmPdLMxqx01/6zU3MXInezyKCd7slPwZpJDu1n8N/tvDnOyqzR9eseuQkWot6gqpxB7MZudrY0jtB8IqSMHbDmHkuIldghRpkrT9KauGY2RUVPXloBfqT/gI+O44TIGpj0mg0E607F3qmE1Mz2ZxhoWczQPvHZ13vaLryDiAiDG7WJThlHutdjfUZiHykOJBLWy+str3eWomWeryHAcWC8ixLsxFsBkaca+4s0V8E4eYhQCg1jz/XlPpDa2HbMFTg8TclIlpR1LLR2wrzyb++Deko3gB48b51h7q+ybENezlK9yETHzSaFJI8nEaOcKCdvJ2oAfJDcSqsedKCW9hyDFVADdtxqn6V4Z1VZacdMLRW7LsfiVghQxdODtqbS0KMbIRbj2O44C03rGdLiI2NakhVNLEg1VQrggxumZ0VZZ2lML/B3MQ3nPbyXEU0/S5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(376002)(346002)(136003)(396003)(39830400003)(451199015)(38100700002)(478600001)(41300700001)(33716001)(6486002)(6666004)(6916009)(54906003)(66556008)(2906002)(66476007)(26005)(9686003)(4326008)(8676002)(316002)(66946007)(6512007)(8936002)(5660300002)(44832011)(83380400001)(6506007)(186003)(7416002)(86362001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UWhdYAtk3KU9vFWW3/BVBHaoHeGakVQLDucwkhC06CAxZwu0BCYqhfc2M0IU?=
 =?us-ascii?Q?9mcY/+ZCRXHEVuevmrlMJblfDdIjjHcDSNqtUAGiYY6NolsoUs/EqMwA569U?=
 =?us-ascii?Q?RVZxXjExXEy56MUmciVagYXNX4ealQ0qtIGCqU2DXLdjTHto0fN39JTB9rER?=
 =?us-ascii?Q?yuvyMnilN4L4ZNGbki+rb1zjL1XGswM47kfQANBdmyYVFTGxX3sdMzEiO6Cl?=
 =?us-ascii?Q?s9rkQCvBQEnScty09NsjD45VfElcv+9s1eZTqp9xHX6mj485e58gCoZ2hlyp?=
 =?us-ascii?Q?oWENEmZsJ30qW2M5eRMSH1B1cHDuw3X00aamyxSVgD+ZccmA2nbeVdZdevqd?=
 =?us-ascii?Q?GdV20tb1hDXKSMaL6TofKafA5u8SKTLr0oZ7WA41bYOfBvhxqXyRH9uf6kQP?=
 =?us-ascii?Q?b2yC+iRgzRL4pCULOwpVOqzPzAZxfhdnTx/qBQvJIyYCCP6In7Gie6cFWM1h?=
 =?us-ascii?Q?WIEbLHqATSgtRiqQeGzWALM2REknfDHGAP5adI7bK+8rLZbXWMFfRMfHOXXJ?=
 =?us-ascii?Q?JeozJ7OqCBWXpZ2E1nVF4PeKw17SH2gyPBH2TTcc/e1I7oZ4NUTgKLuakvlH?=
 =?us-ascii?Q?gPIbU0up7s9vErhgL5dOEIep5K/l7NhW1mTx3BpR3ud44/xyt2PmnhUG+jwb?=
 =?us-ascii?Q?yVHbqegfXQ8EeoAoOL9huS7597GjhrgRky64HyexLnH2o6Zl6f8dmJbVm98E?=
 =?us-ascii?Q?8Uefy2pH6G01XHBL7u0C1AvyV8C6Lf6l5mbjbf8S0qTZIlh2rxHzbQe4avxh?=
 =?us-ascii?Q?1wqQ6smaleoCTEgFR7LoHwxRMkO50XBDJRIAjv+9ijodOCeEEp0AlMXhgkat?=
 =?us-ascii?Q?9+7FVpMspzur2duHuBolUd/g/NIr9w+h/4mGvL2H0IDrvgTzTf75HAs1+Y5d?=
 =?us-ascii?Q?Kz+TgO/1pjD43ur11Hhwf8PiIt5QBDgPN8GePxbWvBHbXZ9hq5wF4NWRCOOI?=
 =?us-ascii?Q?jCrR5ukUc5/gTQ9NpT9XAm7WE+lZfNEgvdmyPTy6zXYkMViot+2Wth/ePni1?=
 =?us-ascii?Q?z9qbsq0s3dJ+7HfxSv76OOKw+dp9p9PN6AGqwN8NAbNE+pEXg+4mWjJj8j9c?=
 =?us-ascii?Q?kWh1uQOA4EPPCUQ0GGrsrSyHkJ/1NtkEwT4i7tQ2rrXvkaeMrZUaYjbq9yr1?=
 =?us-ascii?Q?WB1KJTPqVMoMMsEIvUzW0uD6TfLNFcXf0tBSihvsDujZ6WCFirP2HgTuwdj1?=
 =?us-ascii?Q?N4qidjerLsYmKGqK/iWgwO5X58eVaf/VoQ81281XaOAFLXmRpy+9AZYmvg6X?=
 =?us-ascii?Q?DEyJTuE690/JCy1Ul2bDHFPT9p25oROoyCV1S9ZBVfk2zObL9PYtzyr0bK4K?=
 =?us-ascii?Q?mkB16mvklgylISsaj8ZOdul5dvlcYvWLPU76hXM9b4f0YmRbiZQkkOs3itKV?=
 =?us-ascii?Q?rltXT896cs++g9NiPLfdCJiWYEyVEGXk0ctqw6E8nmzy2mWkUADxPUeGTUt6?=
 =?us-ascii?Q?Yz1WbwZnJzHTaPvSgd/eIL3pbLCD3nCDJW2nMxOTiiwjlw+1LifbEsVERyrN?=
 =?us-ascii?Q?RMMrihv544ud1RqvvQE64gWkVSp9Fec05ulLtzngcDXi3syw6NOzS8S3pki0?=
 =?us-ascii?Q?Yglk+p3LKvSaViq4Wgm3sBqe6WVQAGjS5alkr4RT41PTe4I0rgcrD0ZeIN6i?=
 =?us-ascii?Q?RA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 804b2662-cf00-4f93-b5ab-08da9d7bbcf8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 15:53:20.5644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ervM7lSRtiG95/RY2t0570Euma9WZMFNTIueaUL9wN/pGM5/pasMNrUD85YOqfzS241mkn8ZXxPtNFBAVG2cUHjB/mS025NHjZcfhlcCyFs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5173
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 22, 2022 at 07:40:09PM -0700, Jakub Kicinski wrote:
> On Thu, 22 Sep 2022 19:39:06 -0700 Jakub Kicinski wrote:
> > On Wed, 21 Sep 2022 21:00:56 -0700 Colin Foster wrote:
> > > During development, it was believed that a wrapper for ocelot_regmap_init()
> > > would be sufficient for the felix driver to work in non-mmio scenarios.
> > > This was merged in during commit 242bd0c10bbd ("net: dsa: ocelot: felix:
> > > add interface for custom regmaps")
> > > 
> > > As the external ocelot DSA driver grew closer to an acceptable state, it
> > > was realized that most of the parameters that were passed in from struct
> > > resource *res were useless and ignored. This is due to the fact that the
> > > external ocelot DSA driver utilizes dev_get_regmap(dev, resource->name).
> > > 
> > > Instead of simply ignoring those parameters, refactor the API to only
> > > require the name as an argument. MMIO scenarios this will reconstruct the
> > > struct resource before calling ocelot_regmap_init(ocelot, resource). MFD
> > > scenarios need only call dev_get_regmap(dev, name).
> 
> Ah, and the modpost:
> 
> ERROR: modpost: drivers/net/dsa/ocelot/mscc_seville: 'felix_init_regmap' exported twice. Previous export was in drivers/net/dsa/ocelot/mscc_felix.ko

Yep. Since felix.c gets compiled into both drivers I don't need to
export the symbol.

And there's the NULL assignment. That one I'm surprised doesn't throw a
warning... Looking forward to more feedback before I send out v3 next
week.
