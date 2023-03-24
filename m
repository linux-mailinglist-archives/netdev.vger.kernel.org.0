Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85F766C81BF
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 16:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbjCXPs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 11:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjCXPs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 11:48:27 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CAD3420E;
        Fri, 24 Mar 2023 08:48:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aVcrghQ+ch5y5pYgYkpe+1AlbigfHFxcy1zt4BWg0MBnBoE5m1oL3cTeO/rveJTqm5qcMZKYmPbwfFlb2r/rlwDsGCaslB4YyzdfzPzddbN1tYDRUELH6PCA33+Y0rinKVIBvfavq8JrT1VxT8836i6LQR5RKf9wUfBG2Yj5Ut8uZktqGaRgIwiVcYzZvB6KQSS4HW5RfDi+vq6N/ArAbmbjujbd/UqIlvxgvbaszZWNj+2825ASSsLirMrlUXoTQyUYjBVJ/WG8IywCwQMoESzRX7Sf4kChtkautl+pjwPrMnB9L5/RVT412tbI9q3bnsXklNUpnvCnnoyYaDHR0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ivd+Mz6/E8kVGKy52Sc2XUcOBx100CaMcMWYoD9q49o=;
 b=PiUHB6buG8gtuQuA9j7nUfSe2WMCgN/idrMfke4DF+Hyvs7+WTp/rnf/6i/Rk2vKDafW2F1LhqyWFzN742V/uyAok1i50ZezwKM5z9qqW0KFEwp2zy3pODtDozs3FOzcSqKhoosdKmV1EE7jQBqZa/ah7bAqYgxg49OCxHwf0CmPSuJ5iRojrVQKr2569vnVAgRanfUG8azrnrhXMadRd6UGrZtXQMK0bgewxaYKvIaQcO2Bd4XM2rFWLeXQqAE7E1dR7O+Sgi6KVCHet4pvZufIxAyjFtVTCsrXMP3W/OhpZm3o5ecTyS/fJAIkwxpJaXUZ6rSVI53j46bNGHztsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ivd+Mz6/E8kVGKy52Sc2XUcOBx100CaMcMWYoD9q49o=;
 b=guhrvQgEjr5Z6qc9MGsKNV991ldRdZdep0lb3utFwSfGMosupqrbzFY4xs1u/HGSymkTiG93wTexRabCi2Ym75+PwBBdKm3z0dsA35kYOBP0a2JH1ycmYIJ6yiMefymimSam3LnQZUb2syxXRY3F4HfyaEHfYnM85c3XOuxUtq0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM4PR10MB7506.namprd10.prod.outlook.com
 (2603:10b6:8:18b::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.39; Fri, 24 Mar
 2023 15:48:23 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa%4]) with mapi id 15.20.6178.038; Fri, 24 Mar 2023
 15:48:23 +0000
Date:   Fri, 24 Mar 2023 08:48:18 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        rafael@kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: Re: [RFC 4/7] mfd: ocelot-spi: Change the regmap stride to reflect
 the real one
Message-ID: <ZB3GQpdd/AicB84K@euler>
References: <20230324093644.464704-1-maxime.chevallier@bootlin.com>
 <20230324093644.464704-5-maxime.chevallier@bootlin.com>
 <c87cd0b0-9ea4-493d-819d-217334c299dd@lunn.ch>
 <20230324134817.50358271@pc-7.home>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230324134817.50358271@pc-7.home>
X-ClientProxiedBy: SJ2PR07CA0006.namprd07.prod.outlook.com
 (2603:10b6:a03:505::18) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|DM4PR10MB7506:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e36c2b0-b72b-4657-0203-08db2c7f32ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K3HiGTMjbhJcZqgVUMAPCgNy2td/to9ba5iHnDNa71A8yRhKog7AMnaEoWizXtG9Ap2nPK+LzmoEAIFO1iSYl3d0IZm8HgJN7e6cYT8wYFqNRsO1o2v0386D+XunA+eKGdrlxuqFhmbXDt0ofpiLuqKDevS61hcG1s5IX2brlSDCmglBkL3Y81V1SdGyuyPnw9mybcEacPG3Yli0NCUaaN6oBALGdVzPaK+vkUk37L3v7a7VD7VepzyNvJNR73lXp+VyPNPMrAh4ndvioVo3pMqNjZO4Y4+Hk1ONx8++YYKWTybMV7kE1AZjL/rZLb1JFFNFwE00W9+znGZmlty76UfUxWN9TENlt4EbNwf/gpOLpaAJYB87zJFMzZU4yqm6Iwj1NoXuNKycZdxLRnUQGSMNbPgmqr8XiJppeglzdExpGAVzNzugOOVDozhXd9BMMdEpIJmWo+9ySIxrMtY9gJDKjbg5NPx8Dv4zeDSXVje4ciBG/VIk3lB+qtOCjrrqckrkr4/Y/TPBr5ic6Lciy3Men6rghqrdDV25UCymDhefWHwJErrqntPyvmKYP6JHdbLWeslz0Gpai0Fvs8g5VSbkJna2/ZGji4O2vr3SfEM51VsmRUNyOFTW6AMVxrdK43ZWWQTz1/FQsyj1tABZQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(136003)(376002)(396003)(39830400003)(366004)(346002)(451199018)(8676002)(6916009)(4326008)(66946007)(66556008)(41300700001)(8936002)(66476007)(38100700002)(9686003)(6512007)(6506007)(86362001)(83380400001)(186003)(26005)(6666004)(54906003)(6486002)(33716001)(316002)(478600001)(2906002)(7416002)(44832011)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UjR/Ds/M/gYIEjkxiUCcwbrTLDoVZ5gbXSyYAx71nfoQnEHuIY5PO3IM0K8a?=
 =?us-ascii?Q?7lIH0cZVUuZ40KGr7eHy3QXveHNQo7SQO3Tru4+UBv0gVPdf+4N0Zajp16HN?=
 =?us-ascii?Q?25GybsAFtBgW74hPZKoa4k+SzRspxnWNjiua0ZvZYz7yeHXA9m+OGbTd0woj?=
 =?us-ascii?Q?EQWuOM2prqGg/RMDcm7j2RF6PvHfWf08Q79JnXHTK9E53etB/UTWQTs8z5PG?=
 =?us-ascii?Q?pbVI6g+Q/YuE7HKir86TVT325L7Vbu08NZQKpz9IxpK4BjarUqpGDEoY1+JY?=
 =?us-ascii?Q?4193YHMmhLUBBiY4xEwz714FoIkqHtmqMpeYNE/WzyKys2n4l0sDTiL7xmCU?=
 =?us-ascii?Q?XdQUFC0gEYlokS0STSAmCr53HubQZ9FZSL+QAbwXfyoe+LA7J8S8II+L4J2l?=
 =?us-ascii?Q?HMs33IWsOrrnoqiH7XnBqULZ1I3iGnTJrOLgmwtRAaDpquXx3YzOvT0k/VWk?=
 =?us-ascii?Q?FpH9hrBms0ZXnht6jk5piKNy7WeuGhwvdsdNUq2S4+YbZcUaMfsITBETnkXN?=
 =?us-ascii?Q?37OWvmwESoUUxU05aHnOOeNaUuVAl0IjkQS3akDyUeVA3uKfNDsILrcxHp0W?=
 =?us-ascii?Q?+nE3kOXQoWruP7cADlaihFsbfUTJsjfsfcAwPnKU86XlOt+IddLPPqpBimit?=
 =?us-ascii?Q?MYp+mFMDC3r9URQJizioKjSddkkZ7suCjU/oKrcTYArWiDtABSwfmX8FzJgK?=
 =?us-ascii?Q?d2x+tZzJv1GJWPjf2S1XjZZB8G7qLk/zYf4GaFZnsrjfJUxCF/UzpgmisV2f?=
 =?us-ascii?Q?bHvNyfDbFHkgBZOejCDVy/3W+JY99PFMUVHSvGGNNB70EnXVlT5zOXZ5VQiJ?=
 =?us-ascii?Q?qTALnnEwIuihRaK/iPRG9xr9YsTLqXePcd0RLRCxlFz2yeWwJs8JV9ZrK7c3?=
 =?us-ascii?Q?srVt3o/LPysqKqgvg+F4/LngMIAV7fUIyaMqS2XuN8zJVHDhaJR/To/DyupF?=
 =?us-ascii?Q?KNwPz3UlJCqchMUG6dnUNiULhJkQjZWQuLW+yxvBGBgQhH5lm6HfXReRM87C?=
 =?us-ascii?Q?3taXFp8XkY+0hmiiZnTiIQJge8jkKHKBTVs20041SMwflEU9/wccC3Tt4Q1c?=
 =?us-ascii?Q?v21yyGI4SkCw963NOT1j7pZbsUItMtW/ptbjQPKnPpBCuZy4MWB7xMqtZYuM?=
 =?us-ascii?Q?DOMjG0vY8EaU50K3qw7yAor9rCgqpSrTvzh34T/CGUsW0S9L7ENSbRba1GGk?=
 =?us-ascii?Q?Uekpo3cV5zl1HSqxk/ZWiAxQ0L/4vZMs2AvQKMf4SxL4M9XttQiCYG7LJoF8?=
 =?us-ascii?Q?nrIq5ekWOi+LjTUyEELY3ZjXs6UHEDX3NLlwmAFPq4Df+BqEl9AptQjAlMd6?=
 =?us-ascii?Q?+Pr04dtzlC2ahpKt77oErnKazEO9woFFkZ6/cPgSAsJvFxywyfSxa/rUZ2QE?=
 =?us-ascii?Q?3FtYMQoePLa/7ucTmDlXL+LjXheVcsiBcGFAMl7/8deOdvYltGecq3jRIWG6?=
 =?us-ascii?Q?ybcCFTWMOyjlR9AAf1wqEh2VGG5oo+XCT4ZVWftrzGeRdEGQ+VUOBVVZt/1u?=
 =?us-ascii?Q?MoGoSB++eTYZUeZkC8ARRc1bm4BZ20snN1oM61uMRmavOzkY3oRIjybMj/Yi?=
 =?us-ascii?Q?qWJGSACbLyHFtvN7an21xoHoYJx1PopEq1FRZU2lkm2cqo0tYC0fJoI3dDm+?=
 =?us-ascii?Q?rdpfyGkWA6ueVJpPFwbivxI=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e36c2b0-b72b-4657-0203-08db2c7f32ba
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 15:48:22.9232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tmYnBx8gPOilGL0Rsn3ClyhxzzwkDqRdvIuCNjpw54QI+RuoKwLgLL2qXcMQsNLYZw6rNPhhFutco04yzDjs3YGb5DIugvmeEMc199HDJRg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7506
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maxime,

On Fri, Mar 24, 2023 at 01:48:17PM +0100, Maxime Chevallier wrote:
> Hello Andrew,
> 
> On Fri, 24 Mar 2023 13:11:07 +0100
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > On Fri, Mar 24, 2023 at 10:36:41AM +0100, Maxime Chevallier wrote:
> > > When used over SPI, the register addresses needs to be translated,
> > > compared to when used over MMIO. The translation consists in
> > > applying an offset with reg_base, then downshifting the registers
> > > by 2. This actually changes the register stride from 4 to 1.
> > > 
> > > Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> > > ---
> > >  drivers/mfd/ocelot-spi.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/mfd/ocelot-spi.c b/drivers/mfd/ocelot-spi.c
> > > index 2d1349a10ca9..107cda0544aa 100644
> > > --- a/drivers/mfd/ocelot-spi.c
> > > +++ b/drivers/mfd/ocelot-spi.c
> > > @@ -124,7 +124,7 @@ static int ocelot_spi_initialize(struct device
> > > *dev) 
> > >  static const struct regmap_config ocelot_spi_regmap_config = {
> > >  	.reg_bits = 24,
> > > -	.reg_stride = 4,
> > > +	.reg_stride = 1,
> > >  	.reg_shift = REGMAP_DOWNSHIFT(2),
> > >  	.val_bits = 32,  
> > 
> > This does not look like a bisectable change? Or did it never work
> > before?
> 
> Actually this works in all cases because of "regmap: check for alignment
> on translated register addresses" in this series. Before this series,
> I think using a stride of 1 would have worked too, as any 4-byte-aligned
> accesses are also 1-byte aligned.
> 
> But that's also why I need review on this, my understanding is that
> reg_stride is used just as a check for alignment, and I couldn't test
> this ocelot-related patch on the real HW, so please take it with a
> grain of salt :(

You're exactly right. reg_stride wasn't used anywhere in the
ocelot-spi path before this patch series. When I build against patch 3
("regmap: allow upshifting register addresses before performing
operations") ocelot-spi breaks.

[    3.207711] ocelot-soc spi0.0: error -EINVAL: Error initializing SPI bus

When I build against the whole series, or even just up to patch 4 ("mfd:
ocelot-spi: Change the regmap stride to reflect the real one")
functionality returns.

If you keep patch 4 and apply it before patch 2, everything should
work.

Sorry for the bug. Thanks for the fix. And I'm glad I'm not the only one
taking advantage of the "reg_shift" regmap operation! I thought I'd be
the only one.


Let me know if you want me to take any action on this fix.


Colin
