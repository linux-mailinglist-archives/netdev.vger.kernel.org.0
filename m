Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B62DF5220B3
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 18:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347121AbiEJQJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 12:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348629AbiEJQIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 12:08:36 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2115.outbound.protection.outlook.com [40.107.92.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979131F2D58;
        Tue, 10 May 2022 09:02:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TN2mqXWie+VoSViDy+ASmcferckba539KwT2kBRlLf/2jvQA4NZauH0NF3V7ZIKn7ggFoLKHMf4daFhf3mOhghNcItsKpgjOna6SOK0gXNn6pqG7e3Ehuk/zCmMKWI9+9R9oSkQcjyqfcUWcwuC7IZDfCiTTXfL+/MhhmXkHmmSL0zLAppN53EpzIfKoft8ADUGqdHtifodHzM2EhmD4z/ICzzIDyp1JIo3wpDg2gkL87iL7g4FA3qNmIMIE1h42KUfc8YMe9LM3WmqFb+sRed+7N1sEWYPfjHbT9Ltxhh1YA4O7Tr1DZOYgNdztrH3OsY4oyA2QKoy+P88il2CKkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PfluoNbyvdlHlBwEhlsy9UMwmYEj1RFINWAsE37B8mw=;
 b=STFYpHh+MZxRk0YIIwWxc7598CFzCPnyL47VUtAVyp2UfcN5yFOH+YOzDsdthwZglB+plCbY+sjO1nLKv3ZVAVjHDspkWp7w3q5BZF+H5WQm8/yssWWMm8Cu4pzCHZ9fMgg6z64Y5+ARgCsc5PyQlM/dMVGeDXuJzF6wS4Sy4RGUraBqMJmCtAy99Sy8s+plKy1C/wcoMirTgb2EGkAy4lTDXgC9HjQ+vBddtfUvBi2g2R+aPw6N+RDV8XWfjkTPF6RzirkJDKV5I4f6j5pbO397u79i9OruW+f6BDQCxEaVIOxy+v6ThX1rl6/p6sZOMKEc8rjeavCE2f6GXck1dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PfluoNbyvdlHlBwEhlsy9UMwmYEj1RFINWAsE37B8mw=;
 b=GEIvOvfWX15MpIyanwMdwI+JdsfX4QXFIuStMY0i4JLkl6m/Q5k84a5rveqjKFKf+NGKxTCcW5mUblQtXHApjzq2VjFDvn6dskVz1el4qdb+dyQ5WjFVgdz9w5ijg0y1Lup3siEvhG48HctDaY3dIFxTnK+citdEtSgCrMTAeTI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DS7PR10MB5358.namprd10.prod.outlook.com
 (2603:10b6:5:3a3::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.18; Tue, 10 May
 2022 16:02:12 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5227.020; Tue, 10 May 2022
 16:02:12 +0000
Date:   Tue, 10 May 2022 09:02:06 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
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
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [RFC v8 net-next 08/16] mfd: ocelot: add support for the vsc7512
 chip via spi
Message-ID: <20220510160206.GA526@COLIN-DESKTOP1.localdomain>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220508185313.2222956-9-colin.foster@in-advantage.com>
 <20220510155853.polwnf5t5angcx2a@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510155853.polwnf5t5angcx2a@skbuf>
X-ClientProxiedBy: SJ0PR05CA0048.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::23) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99bd17a1-df8f-4f42-f4f0-08da329e7194
X-MS-TrafficTypeDiagnostic: DS7PR10MB5358:EE_
X-Microsoft-Antispam-PRVS: <DS7PR10MB5358286EDB8D5A735A80D834A4C99@DS7PR10MB5358.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Th/ehGBN64khmiZHMBWTH4toBk6Hbh6azEtdUxXgB1B+RkPa5KKJJw4SYaou4BOieGh0N1m9gUcBKb59yXSBaKiwn5jf+8gPrMucJL0XzNZ7YqfpWrzBO6WcFoGUgII3PQ2F2nWw7CganrTGqwMa8NnNrFlyrfcfucGxvcemtYpvUuQvzv+8O4qDqFJ1IWGvqYdSa0F52mj37UOE4L+SqbyJmcVzKjJrLsf/sP2tZuxru37iJovkwpiepwZl/JyXhAkIovUMVA6G8K7r2wR+vezdA2u8exCnldLcOSqc2pdMU0caXUHmP8sF+mvI1A38wbE3S5qR4gXKN9BJwSCR/d2O/KKas2zMl+8ZHNeSoGnsQJV5lQvsSsCwY00udhm1LXFoHQDb79wh5a+0Xbu4ed9yqwxeTXY37rgDmFtCI6ENYX2VdhFGJUrrf8WDSWgZaivq/80XVKk6rJdj10Yc1FUt1uE1b+kTRy38Jl5QBwthQJWKMSXb+BL1tzJqAUkpgXEKf3WzVcLiXgd67CjvIBrr1tQGEZi3k9uRivGxggnPG3+jPBC9ESJ6eii+TJz4w4i/bZtnNLR7Ll5baNUKGVLznzmf98rHRLVMYgsSNtmP+9HDUjJSnNEyuHIoLKoO5cJovcJmNk9v4AtF4YN5AC+jxF79V4dnREKnc0cxDCbRM4O1xommLl8wpJyiElfIGgr9pCz5vYs6urHGZrP1/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(376002)(346002)(366004)(396003)(136003)(316002)(66946007)(54906003)(86362001)(6916009)(1076003)(6486002)(66556008)(8936002)(4326008)(6506007)(9686003)(6666004)(66476007)(6512007)(26005)(52116002)(38350700002)(44832011)(8676002)(38100700002)(508600001)(2906002)(7416002)(5660300002)(33656002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mDSJlsawZl0zUK7XdEVF3eJ34M3LApQEBsoEvmEDAT2vt/9N+fUi/KftHkTC?=
 =?us-ascii?Q?IF4eysIGMQOvNNDA9+I8TLfAC2S1YIeZUJ57WcNRoBh9lkb72w7rMUpSmwmG?=
 =?us-ascii?Q?25v3WOQSgcpluDCna00DSC1u0DCOdz3PGu46rQta2ye0lRbjM9NrUtcJgr7g?=
 =?us-ascii?Q?w1RW5G8HEMd8iRC+qQkBZDuiJ7AfX6pZHF4S+6SlugqEJhxAzFZWL6TBoTa9?=
 =?us-ascii?Q?0I65E/xw3Rggfs9ZngzBhWu55ILQQh8ejfzg99VbE2u+vVk+0yQ/N+XmMPWU?=
 =?us-ascii?Q?+p2OaaU3s/n8EnrX7ZIwfF6y/ahpOtYn7VeP5LPWpleZTgyOQmjiobpoVNlU?=
 =?us-ascii?Q?e1G39Ccsgc3jESq1utCMGLhpTGoCLPaHK49EMBzRYJ2Nk3W80H5umpQZV/ft?=
 =?us-ascii?Q?3cvbkb63iuhj24CNabMmSaMIpxGpaXq8rFVUOqIutFkRDTNHsztjCxZQpDWk?=
 =?us-ascii?Q?56R9Q0g1XxBFwBaSV7MqhJzsTsk1/9Ne2otr1LAvycbgl9dT+0o3QsYZ6ZD4?=
 =?us-ascii?Q?klNxU9IZ4FN2IcoFztg0Pl9hGyxmlue2iGt9u+thpikXrdO7TtqHuZ5ogAgh?=
 =?us-ascii?Q?nLs9nJ3zon6UwVzugtUu18dVTdlYY1IesZ4OSChX8GefFRGOnuglgsGEUZt/?=
 =?us-ascii?Q?IPbDw+IKmYsqaMPXDQxwTQozz734yfCuddQdNKCtFC4XssQanY3s23oHDbpV?=
 =?us-ascii?Q?HBlmxmeqhFkLXSP5gaIsELEY2d7FudExFrp8sq7pfd0/IW3kVci2ozEXHhls?=
 =?us-ascii?Q?sr90NZciK8uN4PAZWGp/JlkaVfwjbyqTcTA20zq/8pfy3wwedSl62reaWQPN?=
 =?us-ascii?Q?k7oKP6OaRU7oCMublyThWlPcLPl6br9obToY4BB+utG/ixBQOkBkZVjkFAUr?=
 =?us-ascii?Q?kQ9YM+iV6jWKVH/g8D4/tLoYco9MdvkaHfdDf2ma4Qcq3SP8Qne9yksmE73V?=
 =?us-ascii?Q?cxgTNHk5LAb1DiluLMck9eCp5kxBP4aM9sdeGRSGztv5BubYCu2WpE0k24Xx?=
 =?us-ascii?Q?ODJDdcTbTfWPc1siPweBGsc0C+8MIOtojav0kiMefafsZcYmfSfvnCiiQ6hh?=
 =?us-ascii?Q?72dpbzc3aG/EJPMfjb6/KX4+/1YkZiAeZa3UfHR7i6D8e63ilGrgcGpIwPpW?=
 =?us-ascii?Q?ldlD/1SYs5+xfCpkU4eoDFyW17tlbmS+Z7tM7FEHwA8mYCX6nKix2I6N9hwj?=
 =?us-ascii?Q?4I9ndCbaDJgJkfsKd6IXTEGx6gZWUsgEy5XVCTh8ujEOl0Yrk8RkodcyfTSU?=
 =?us-ascii?Q?Cbgn/qFPCTsXvLOyIsZa3gOXeGiDArtBV80v0btixMasemkUO01+vEZqMjz8?=
 =?us-ascii?Q?37MsHsEqcpnklZXiJzm1MKaUMMBTGG/hvRqPLzapzbx1WO/HMUJqsZkQc41e?=
 =?us-ascii?Q?F/hhEe4DYkLnE/HzlmwJCCyn92JI/yzdGzsW82NUoSVnGPOvYWlHpIcEUkvk?=
 =?us-ascii?Q?MhNPV/uCzrK3Thw26xPKdIFS7O6hBmWcq7tLdWJUaGfGj5SfLS8w1mAUYGyX?=
 =?us-ascii?Q?tU4qp/gXwPnedYxwShZTnkQBpqJ5KxlrVrp6v3cmyXKKA1imWaRvmMJvyniY?=
 =?us-ascii?Q?Kp1GrqWg6JZv0aw23kcgmb7zdSWaXa8PrsyKh4zb/tLTORhb0K8oQw/8fAae?=
 =?us-ascii?Q?XSAVE1simD77sJuWyD46o7/RrKb6iV2IrpcFQUuPTwx6e8xmEMT/FTii0RkH?=
 =?us-ascii?Q?asbBDFaCM7KdSrN/jol4k+I4mUmcn9zBaB9Vf/UhX4ToELywyafaFAE5LQuS?=
 =?us-ascii?Q?OfMnOu2cbhAI0DlWr5bbAP3BVvIGlamfZaQcluHn85IcL0rqI1X2?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99bd17a1-df8f-4f42-f4f0-08da329e7194
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 16:02:12.2530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7w2glXcxnjYRVudZcrsZqIASwNS9X558zJaBG6YsJmdLd5Rcg9MtNJ6ylFpBKYF2HbPLrVsyUwXDQcWZQoukdiK/FRoGYDqgTsCkW/3NoX4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5358
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 03:58:54PM +0000, Vladimir Oltean wrote:
> On Sun, May 08, 2022 at 11:53:05AM -0700, Colin Foster wrote:
> > +static const struct mfd_cell vsc7512_devs[] = {
> > +	{
> > +		.name = "ocelot-pinctrl",
> > +		.of_compatible = "mscc,ocelot-pinctrl",
> > +		.num_resources = ARRAY_SIZE(vsc7512_pinctrl_resources),
> > +		.resources = vsc7512_pinctrl_resources,
> > +	}, {
> > +		.name = "ocelot-sgpio",
> > +		.of_compatible = "mscc,ocelot-sgpio",
> > +		.num_resources = ARRAY_SIZE(vsc7512_sgpio_resources),
> > +		.resources = vsc7512_sgpio_resources,
> > +	}, {
> > +		.name = "ocelot-miim0",
> > +		.of_compatible = "mscc,ocelot-miim",
> > +		.num_resources = ARRAY_SIZE(vsc7512_miim0_resources),
> > +		.resources = vsc7512_miim0_resources,
> 
> I wonder whether you can differentiate these 2 MFD cells by "use_of_reg"
> + "of_reg".

I'll look into this. I figured your question regarding this during
the last v7 wasn't directed at me. If it was: I'm sorry I ignored it.

> 
> > +	}, {
> > +		.name = "ocelot-miim1",
> > +		.of_compatible = "mscc,ocelot-miim",
> > +		.num_resources = ARRAY_SIZE(vsc7512_miim1_resources),
> > +		.resources = vsc7512_miim1_resources,
> > +	},
> > +};
> > +
> > +const struct of_device_id ocelot_spi_of_match[] = {
> > +	{ .compatible = "mscc,vsc7512_mfd_spi" },
> > +	{ },
> > +};
> > +MODULE_DEVICE_TABLE(of, ocelot_spi_of_match);
> 
> Don't forget to add a struct spi_device_id table for the driver.
> 
> > +
> > +static struct spi_driver ocelot_spi_driver = {
> > +	.driver = {
> > +		.name = "ocelot_mfd_spi",
> > +		.of_match_table = of_match_ptr(ocelot_spi_of_match),
> > +	},
> > +	.probe = ocelot_spi_probe,
> > +};
> > +module_spi_driver(ocelot_spi_driver);
