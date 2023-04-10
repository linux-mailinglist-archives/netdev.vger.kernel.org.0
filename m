Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56A586DC6F3
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 14:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjDJM5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 08:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjDJM5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 08:57:05 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2124.outbound.protection.outlook.com [40.107.220.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F25C1FD6
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 05:57:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TI0a48zIcYqL/B11nQv9f17YNPuOR3S68m85IAhkBEtl427mMS2lec2RNrIqKGavjvSeqEN+MBCEJmL1PNvBIdDBSiBQNGwvAEso2L06kixx7Q/8kQ7MraQ0J7N2/F/txjv1Twe6hld3Q4xgimDDcqrbfa0kQXBH+n10+BCo/SjmIDgIslTSHWye63CIiFrIi6NFqQrHaNQxKYNddPUyWqcehBzuiOKomNNgPrxaBzhMAa1MMPjCP6gmuTRnjCxU2VogK3uha/v8Sae83+DApYw7y/svVCX+Kj6T3SfJDLSsmjxvSyKC0oXYhFoCYpPzgnRpknNNLxY/s8HbEhCJZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6qyy71+kfS3wjg5Amyklk+d8hs9ZwmcTBsDNgrnsxr0=;
 b=DKDzW7u4pUcSGMJWMsTBHSFE9S9xr/1DyEs8CqB2BvKeo5YzuXbhnT3bZi6raCVWDf1CBndNCK6FiLrSxzMNf0G6aRbIUGhZTZje8Vgy1PwdGTT3oU2L24eJYWTLPzoF/G85XYmYP4kNOM3MYcl93gjnMEl/SJtklxgoDaXdWc3r22574gOyrHhHQ/Dp2F5nNL1u/3lLwFX3uWJTDOwwWvpqTmYp3TlPPEolq2ZlHtcIcPxfSMGfBZEC8y87eqS8QjldBvVre47xT6q9k8Vd8GNAq1Az+wDv/MuWvF9Pa/56BzFXni1TGs/MaHI11Di9GfeabxmWq1NQp6ufTlJF0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6qyy71+kfS3wjg5Amyklk+d8hs9ZwmcTBsDNgrnsxr0=;
 b=hq2g8g4FwRaUwGjmasBA+9mcJIWHKWWkBfNiEG57/qbauqAZTStDgyXG+ri/evvPEaTwu939Ebx8I4wukLt615Ijnr+whbk+OTHue+Rrb3E1bjngtxv30T9gjOUz7Btq9rzBd483qRHS8mzyF3OB50PSnZ/MQm8LKTkmE8yQpUY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3816.namprd13.prod.outlook.com (2603:10b6:610:9d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Mon, 10 Apr
 2023 12:57:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.038; Mon, 10 Apr 2023
 12:57:01 +0000
Date:   Mon, 10 Apr 2023 14:56:54 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH] net: ethernet: Add missing depends on MDIO_DEVRES
Message-ID: <ZDQHlhU4c5YRk2yZ@corigine.com>
References: <20230409150204.2346231-1-andrew@lunn.ch>
 <ZDPR7sQj3Mpatici@corigine.com>
 <741fc0ef-c94d-488e-86f8-436ab4582971@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <741fc0ef-c94d-488e-86f8-436ab4582971@lunn.ch>
X-ClientProxiedBy: AM4PR0101CA0056.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3816:EE_
X-MS-Office365-Filtering-Correlation-Id: 1770615f-4656-4637-d088-08db39c3134c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dN2jJdR2JIy2cicthglgrbmXncWpsj8dcIT5PVq9I1cSvDBsU894kmN6f4Hjlzmx/Z4ScFLHbUjkg2Ck5qjloju4UfMSiFsVP5hkEL4LVKUZul31hHjdHFLsZeLG310fc+W9rt2hvj0+dZOtwdxiV8BlPD61/Euf8BbduBxQ/nTQJ0YoLp0/BJ4yEn7p7zluPhse/C1NQoBiYmb42GYKagyWvLRp0NxwkEjLrxwzXoqqCdnWdqzAW97P5wbIH61qCbPmfXcRKDofnUBqtw1CKjHYgg8FoOrNa5XFO+w6RKr05IVKtwLXD1FJWj0YQ15iooc8Nx/5LnVyRQn+/MDN86XuLNbCxFH1JIUHgWtq1c7+GalODm4H1mRhDcOR3qPmb8k3T9YL8FAzWVZhKPhPMbCucr4UmNEnwWiaWaLx9egCuejqA6LOh9+Fcpx6LeZAX5/IxEdcktAiewzVKxNcstc7Fw73BfxR+37ADf+Ts3/2cGWdWl+vnWeXQyLuqoDrFbxuIB+rlIQ/CRFcQeqepo6dbFkBBUp7La4hILzKfEn5zhfHBnKWaMH9Bv8clXI5CuKT36GgyH83sb32RpNOxhzehSL1Rj3gS3KAmJmFWI4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(396003)(376002)(136003)(366004)(451199021)(478600001)(86362001)(83380400001)(36756003)(38100700002)(2616005)(6486002)(6666004)(2906002)(54906003)(316002)(186003)(44832011)(6512007)(6506007)(66476007)(8676002)(66556008)(8936002)(6916009)(5660300002)(41300700001)(66946007)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/s96rHsW5hSGof/b25wBOLC0nBUJ+nAKOSCOxXw+NRkeMJa1pDjvL5pqgAK5?=
 =?us-ascii?Q?typsX0HSiKc4C2+NOLESZh/A/P9b5RkN+kJFZoSPI8pWdwF8Rm01yI2MK597?=
 =?us-ascii?Q?Eh+sTfQjP5LKHGFKMKlS4Q35vQnK7huosFDb4Av0/W0XxslkBtszVDraRpBu?=
 =?us-ascii?Q?etI8MCGBMOQxIi+IfMBVf0fWhyBSrH6lO7Rvt60M5RDSdHx+fA1ismQM+wqX?=
 =?us-ascii?Q?/Rfpzh9mc7dlEIVgeK513CqIJmp0W0AHCcqw+PLtsaUXqjPhFIn2D7cdhp8K?=
 =?us-ascii?Q?OGzKjkszPWLaLVMAFuQEA2QDLdLjgDfVUdzHGuddHwnS8+KSAsN7lci8+PCm?=
 =?us-ascii?Q?7igK4IYU3z7Am9hsCIOqOHaG23NXIN85Fex0p2zdOhizndz9K9cU2BjTgSrP?=
 =?us-ascii?Q?aDwgd4yPV5tgXZp4VXurXYnconrAxwdlj9w4IZdb7w+0Ql70PPD/FhhO3eTE?=
 =?us-ascii?Q?3ueXdMWOF+DU2lGlvYlttDd6NbaaWXp3O1MiEHeMKQH5b82NRi5MxOSseEe6?=
 =?us-ascii?Q?w0S2H/rZRSdkV2oWUyylQ1iTyBLdkYwTs4HFJTjwzu0WxT7K8vHoX9LNLyjW?=
 =?us-ascii?Q?l2RScb1CbpEjRnm6DS2mBGE6r0w/vpfhiNBNP7kuVV0d2wzX2ZW44KOXgNoI?=
 =?us-ascii?Q?f6HuDiMB6RML0Qk4qQahytayI73pGeMo6MNENmvHNN6cSwWlXgz5tBnXhleL?=
 =?us-ascii?Q?XakD64y9HUICPHiUhIk+P+7jJA7UTrX4ivOL/Zu5nr5VjM+GOnfIBL+P/rgd?=
 =?us-ascii?Q?H2/4kpHBU3jaga7m8Tavdyrl2CLJtHW3+7lNvpH8C3RacrghA76G7bx3tl3k?=
 =?us-ascii?Q?V/DlXKU9R0XrcECzTuUWAWAJAW0x0mexCNCn11huWfo4R5yPaFqfYVwNj7fK?=
 =?us-ascii?Q?/LNRzpH7vlL2exAchYUO5C/Li0aXN09oxekuMGSg0w5syBA45Q/IgN/SEc8W?=
 =?us-ascii?Q?2N6K0ujqDYRXXCSJHUr2wPtLxZVCAb43AN4WiCPnaYJW0+P4lDC2HxaWPQtu?=
 =?us-ascii?Q?T05I6EvOqNvPSaehGMjQ6T65WcGB5q4XDhIoMA5eCxcjvSe1LObe7ZbJ3aeU?=
 =?us-ascii?Q?AhyqHmfGzA6cW3/OjmQ3hAvhD/nKwZZQO7OvW64C+BOCJJuvlYKfUDqs7n5n?=
 =?us-ascii?Q?Xr92iLOzLKat3jBdSVXhUTYRJ1GJnPy5sJ8VIy1N5caGYuXt1AhIw4N98Tw6?=
 =?us-ascii?Q?A03jGcUoHWPmuyAN12p9UjbJrzfj0vIVW+FlVriCLto+iUQeUN4souSITBXF?=
 =?us-ascii?Q?BJ65+rLpNQD3giRBBrGAsSVvaqq+GpTCw/JESmHzSs+xI20PUuG7r9ATQN+B?=
 =?us-ascii?Q?M8Xp4Gn+z4fBOnnihN+RTYvVZZWpfT6pJXmHc/85jDQcKCirBRpestPd5mqE?=
 =?us-ascii?Q?Xhbi8KLy2aQM5bK+dcP+hFlBGPu96OWLwfdYhXzNxb208DhMLyKJl4L3hWG7?=
 =?us-ascii?Q?ZGzJwYcvcQXt/ixyymQmY7wp04t1cdFQmJA8tCKXRheOovsSMGd9GaD0iZgt?=
 =?us-ascii?Q?8ptQ8fJSk2epO6REhtaYcvXI6RwoMJU8L0agmN1DpXzDBphw2bSh59RfoFDm?=
 =?us-ascii?Q?W0khg0Yxa1fOe+2Tb30NckC0dcDjRGogY0p+9q0L7U9JXPzBGVTG2nC2qSaY?=
 =?us-ascii?Q?0hW7zQ72lIhAngyLnnft5lYfbAGuKDnEzZfhcEsYzmo0sNYhwHLa077Jjtx9?=
 =?us-ascii?Q?NDZZEA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1770615f-4656-4637-d088-08db39c3134c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 12:57:01.0334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: npucUC3thcXEdWr+HW7qNPxj9gjNSzvTN55ajCDjUoE9TDKN9GN6zmi4w8Zi5Wf80siChfAPx8zZx8eMA8usfFs0YVSnVQpT2FwdLj2moD8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3816
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 02:11:39PM +0200, Andrew Lunn wrote:
> On Mon, Apr 10, 2023 at 11:07:58AM +0200, Simon Horman wrote:
> > On Sun, Apr 09, 2023 at 05:02:04PM +0200, Andrew Lunn wrote:
> > > A number of MDIO drivers make use of devm_mdiobus_alloc_size(). This
> > > is only available when CONFIG_MDIO_DEVRES is enabled. Add missing
> > > depends or selects, depending on if there are circular dependencies or
> > > not. This avoids linker errors, especially for randconfig builds.
> > > 
> > > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > > ---
> > >  drivers/net/ethernet/freescale/Kconfig       | 1 +
> > >  drivers/net/ethernet/freescale/enetc/Kconfig | 1 +
> > >  drivers/net/ethernet/marvell/Kconfig         | 1 +
> > >  drivers/net/ethernet/qualcomm/Kconfig        | 1 +
> > >  drivers/net/mdio/Kconfig                     | 3 +++
> > >  5 files changed, 7 insertions(+)
> > > 
> > > diff --git a/drivers/net/ethernet/freescale/Kconfig b/drivers/net/ethernet/freescale/Kconfig
> > > index f1e80d6996ef..1c78f66a89da 100644
> > > --- a/drivers/net/ethernet/freescale/Kconfig
> > > +++ b/drivers/net/ethernet/freescale/Kconfig
> > > @@ -71,6 +71,7 @@ config FSL_XGMAC_MDIO
> > >  	tristate "Freescale XGMAC MDIO"
> > >  	select PHYLIB
> > >  	depends on OF
> > > +	select MDIO_DEVRES
> > >  	select OF_MDIO
> > >  	help
> > >  	  This driver supports the MDIO bus on the Fman 10G Ethernet MACs, and
> > 
> > Perhaps this is a good idea, but I'd like to mention that I don't think
> > it is strictly necessary as:
> > 
> > 1. FSL_XGMAC_MDIO selects PHYLIB.
> > 2. And PHYLIB selects MDIO_DEVRES.
> > 
> > Likewise for FSL_ENETC, MV643XX_ETH, QCOM_EMAC.
> > 
> > Is there some combination of N/y/m that defeats my logic here?
> > I feel like I am missing something obvious.
> 
> I keep getting 0-day randconfig build warning about kernel
> configuration which don't link. It seems to get worse when we add in
> support of MAC and PHY LEDs. My guess is, the additional dependencies
> for LEDs upsets the conflict resolution engine, and it comes out with
> a different solution. `select` is a soft dependency. It is more a
> hint, and can be ignored. And when a randconfig kernel fails to build,
> MDIO_DEVRES is disabled.
> 
> Where possible, i've added a `depends on`, which is a much stronger
> dependency. But that can lead to circular dependencies, which kconfig
> cannot handle. In such cases, i've added selects. Maybe having more
> selects for a config option will influence it to find a solution which
> has MDIO_DEVRES enabled?
> 
> I've had this patch in a github tree for a week or more, and 0-day has
> not yet returned any randconfig build errors. But i've not combined it
> with the LED code.

Thanks Andrew,

I'm certainly not opposed to this patch.
More curious as to what situations (configs) the problems arise in.
