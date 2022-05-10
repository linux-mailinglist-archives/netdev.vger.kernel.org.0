Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01686520388
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 19:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239551AbiEIR13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 13:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233396AbiEIR12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 13:27:28 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2094.outbound.protection.outlook.com [40.107.93.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3460A2764D2;
        Mon,  9 May 2022 10:23:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T0pyEEdvznoNUnQfTGzaZ62ozCLKnOp+BFuS3yktcl0ZOah1MA/q+1d+wHalzeJmcuO9+/Ppw+JAlVjywLDk5Qqg9eLq1G+uWS+mG35hzkIPA/2WspccFC4R66Nuv876vbi4k2no1bOAhTBZ5In1iGdp6PtopvP+zQLYAanMaIeaB4MnaE31O5P2cLxkKyXVbNDLhsJwVUuFmhuh4tuRuJw+2vae/QDpzd96PT/1ZjEi6XH8Nl5lX6bAArCguWZEXXOjfvZz77TTkDJ9ro2BGHOF9DAXk5StE5PVi70v+l22dae7kk843xMeyLb0NLimzXQU4FEx4OoZcPMnWHTUuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OyYjhfi9p5idjtkVNIRYyde63mgCXobPpoxKZR0JfME=;
 b=DtevcQeU2W57sdHZJamHP2HG5EGNRVR6H7kPbzxziYbDr+gWa/hlHohHF5hbEYf+BZVMi19JLDmmvNQ/YQlUb8hgT1AR74+klmiZXYbPuQW89+WHgK1d29DaVdCZ8Km4TtF7hrVc1niNl924i2uLTAJdOKXwYFqaGGYI9VU20QRM/BFX8rzeiWMUAIIcTf/4rqz8oCAewspB2rU0kAYXaW6lj+eVbo91701/xZWuImzCNR7PY1XEp03TYw5hZisRBgn5SBAXO8iSnVt0vb3P7f7N0/XsPPFw6YAf4yHP0SlNbvHnl1u/aBC0G57v01+Gzpaq58bv7xSixxnLOctYOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OyYjhfi9p5idjtkVNIRYyde63mgCXobPpoxKZR0JfME=;
 b=rdGycDIWqnrC/o6wiDgY4nHKaQav1kZ64JVJ69Jby6L/QfHGI4QRP5Vhkt1LQEs4qDfB8m53XJENkeLu33RoHS6t3RE24DbPHlnrf8yhmO0P8L27cCrl6bMe3CYz3BXa9Ut3Bpm8q0IB1pegaFM9Y+agglqAhG1uBPBBEET3Ls8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN6PR10MB1523.namprd10.prod.outlook.com
 (2603:10b6:404:46::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Mon, 9 May
 2022 17:23:30 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5227.020; Mon, 9 May 2022
 17:23:30 +0000
Date:   Mon, 9 May 2022 17:23:32 -0700
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
Subject: Re: [RFC v8 net-next 15/16] net: dsa: felix: add phylink_get_caps
 capability
Message-ID: <20220510002332.GF895@COLIN-DESKTOP1.localdomain>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220508185313.2222956-16-colin.foster@in-advantage.com>
 <20220509103444.bg6g6wt6mxohi2vm@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509103444.bg6g6wt6mxohi2vm@skbuf>
X-ClientProxiedBy: SJ0PR03CA0379.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::24) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb384467-8577-479e-4af0-08da31e0a28e
X-MS-TrafficTypeDiagnostic: BN6PR10MB1523:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB15234AE14C9388AE05A0A528A4C69@BN6PR10MB1523.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +uxs7M1a8k/+TX7NBpIt3/qOLhCbs9DwdBeENtwSYO/ZqeON5tB+OQb0oW6QPJGkkZ2x5ASe4q++gr8Ts2KtOFF02na29L/jkIf+1piUJqeJ481Ss7kKYJYL2pCLteVKracLsmlV4VyjCAjOhyRDkXHa1mMqrgirGSmPxKLVUk8mLHoLgXEesyM0hTfb7M2KuVIRaOeVXlTOooU9n+eqKEzO2MGVglzblK4izE73HDAyxME/Fq1oZwzQYjaMEW0R3x0gVc2WMV8MEGKDjrjQeiRvb5gIsnrRELFoKYbKxpbTN0drEJNaIGvcXd2IsJJPcuZ6CNRtrOIfQenob52NYVScrTKVaF8m4jDrvkZ1jypRxR/FZiIkjzTvycJiwQSKm2TtHTa+LSJ8IH5iE9/VSu10vk01pfv1s5bsxnHsOFgk/DN1Xf70zNbAVe0v6mVCa4k1qmP7H3LoMnH0VWrOkmfbHYQePa+KcNfgEV+S4mTCtj5qyzwOqvxufwSWuUthdHuMh0y+PozBi0pDpkxA/PbdIGNvQm4dW5w0geJO31vUULjH8Zu1/6ZeylCjGq7PmInDSo0bPGPpQb/FT6mXxj/iJ8gjkcQGDKv1FyxPQAXw0+O/ywBUxDClNo2VQ9498qSf1vp20SQM6AcOTDfb4d8N6P+ytfbX9jCXm6M0asxXiwpxvZFElucnnyUYx2EDdsejK46oczlLR5XMDfkrAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(346002)(376002)(396003)(39830400003)(136003)(2906002)(44832011)(5660300002)(33656002)(7416002)(66556008)(66946007)(8676002)(66476007)(4326008)(83380400001)(8936002)(38100700002)(6486002)(186003)(1076003)(86362001)(54906003)(38350700002)(6916009)(9686003)(6506007)(26005)(52116002)(316002)(6512007)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l9SHnZNpXco2yTXhNVahsQaFtzO1K7c3Ohi0eULE6ztjtWeldWOSHxSqKvYH?=
 =?us-ascii?Q?eDAgZ0Kjiuh6e2rxN7H35FtraQpSO/icdSPXdr+KuVgNymohlYrmQ20M7LR6?=
 =?us-ascii?Q?UrKHNFVWAN+AWn3/WE2hHYURKQUnJeBECk3OZ09s6UNpIetcvAWar7aRa7G2?=
 =?us-ascii?Q?AxBc4+e66zYGOpRmwIkwWTKB7Mj1nnxZ+OiXkycr+lo4AhYaKtMnGlgd72II?=
 =?us-ascii?Q?MJRaGLZ7F68OIHFAQme/gGIZQHOoRi7PkxfOqKs6aX1mSgeKFhMbNsVWYKyF?=
 =?us-ascii?Q?Qb/T9+tOegCc2V8fmuLsuZZoVUOfa0DTkdSQjwaN1ZXN7dH/hxGC8o+dm57e?=
 =?us-ascii?Q?LfxqyDu8N0A0ncHjhl8CiXT9oGddaef5VRoEwHbL9BVJ4C7t5JH7f0l+pGwS?=
 =?us-ascii?Q?eF3MRB7jyMvSH4PatjTu1D5y/kw35lyKpNiULIdyfvS46J1zTZu+kp1f9de1?=
 =?us-ascii?Q?S7bagjnDV1hclDArrOwWaNyVO0XIVnKfXHSXvt3xXkgRVeR1thOm2lMsDxx9?=
 =?us-ascii?Q?2IKM6TJy8qLOqqVpmP4lok2ph/1fwbA4s3xSVWs/7WLm+Q6Jw1q2s56iyHer?=
 =?us-ascii?Q?gqI1SxGIeFhAB30jCnjDSyVyp4njmcHentGGzzIq/DNguaWlQ3S2QipU9AWx?=
 =?us-ascii?Q?up/71uCxvcQ5l15CzV36//jTOKoGHmKiznoH1hko8LIf9IwieNjohMQdJeW0?=
 =?us-ascii?Q?tNUu5Jw8lmeLUY+Zqn2yyerDk38+43a9deFuEURWjXfr+KN3QGZGhsehNgmJ?=
 =?us-ascii?Q?xVOl3BBI4qqJc5OCtu7Ah3DxDesSw8ZJysialkl6dJyWvp2u7xA1wq3ticwv?=
 =?us-ascii?Q?K4YWC2N8GWEaxwzr4q+sXXOJwWdwqTEuvg1Q82Jz6XMIPSzF4WybDxqEvoiu?=
 =?us-ascii?Q?8G7FZtEVMdFjonEpnEE3BnSLi3pVa+ZTnMEH/COHq+9ONCKyOQqAK7qbw4SA?=
 =?us-ascii?Q?GlIpx2ESYpUdS6h1Iz+4IqBCJDQdKu8XMz9z5YmCbCtp0wXvHawlR+2c9o48?=
 =?us-ascii?Q?sLnAn5/NpsEcNqWyGM9M0ocjETQO091grl0UMrJUaI8RBEmYLs/HjGcbssrc?=
 =?us-ascii?Q?1EtZDeUI72DDu0q3qaxsMfee7FMAvHhEKcVjUO770FI9NHXvwwf6Vc2IoMBx?=
 =?us-ascii?Q?7mWkadxcuBaqYWGVCy5RHLWCzpfEUxV8vavHD4yy0ooATBnWLMM9iFAWEDKS?=
 =?us-ascii?Q?fsr3O/zuvTXDhJ7d3IoB+UZwchwoOXCbDAUjf52IzM4BgwHq3Ws59XDUrXNf?=
 =?us-ascii?Q?d0Gxme73K6WUfBJlH1dygBuPVxHu/drHftu9615FnDZzr3q6a+WMroircVip?=
 =?us-ascii?Q?8lxEGWMuP0btmDyUYsLJ5nxNVkafp7hhLZ0zQ/VtmI9x0tXngwaq/38s0c3R?=
 =?us-ascii?Q?5p9BWg6MVMd5P/bvGSFKINRnUr0Hvyijgc8scadQvwcsrTopreF50Fe6sKgq?=
 =?us-ascii?Q?8ySTC+sxHrRGEYfnSoXO+Qt6NmzRxVTD1MwuVDrBzxmWjNs+oCVm6lX4W4nt?=
 =?us-ascii?Q?O3xz+PdZ31WuTH1dwIvut+F5TDSK5fuPUhKBDAEHvNjJGC/KA923Ava5YFVM?=
 =?us-ascii?Q?LWCl7Hi3IaZ7gTTEqxmeghBTNkVCFeDC2aN+yHfdxyL/L+lHuwgoZivHwUR0?=
 =?us-ascii?Q?QKu+JOMxYzq1lMBqGufdCbPooa5E4F0Q87s8Q8LGwyXRMPRPMcE+7k07ntfe?=
 =?us-ascii?Q?lmcsqwzFEAOUwpUEnIC1A0pGfsFg79afTtWycUll8jHZX9DO2GU+D4K4bK03?=
 =?us-ascii?Q?qMOOSVGBgR9PdMEI4mKfrVikxlnA1Moj1K294mfE6u90ilLh2MS9?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb384467-8577-479e-4af0-08da31e0a28e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 17:23:29.8984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o39AQc6VdDox5iOhMk5w/EqJhddvzglfPpuDe6ru7vdgmO1wIRVkvy3fKoH6TbEq2k3ndyFF5IWhYOnI6u9U9bVfEKXJEsyAKlrpcoic+ac=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1523
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 10:34:45AM +0000, Vladimir Oltean wrote:
> On Sun, May 08, 2022 at 11:53:12AM -0700, Colin Foster wrote:
> > Add the ability for felix users to announce their capabilities to DSA
> > switches by way of phylink_get_caps. This will allow those users the
> > ability to use phylink_generic_validate, which otherwise wouldn't be
> > possible.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> >  drivers/net/dsa/ocelot/felix.c | 22 +++++++++++++++-------
> >  drivers/net/dsa/ocelot/felix.h |  2 ++
> >  2 files changed, 17 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> > index d09408baaab7..32ed093f47c6 100644
> > --- a/drivers/net/dsa/ocelot/felix.c
> > +++ b/drivers/net/dsa/ocelot/felix.c
> > @@ -982,15 +982,23 @@ static void felix_phylink_get_caps(struct dsa_switch *ds, int port,
> >  				   struct phylink_config *config)
> >  {
> >  	struct ocelot *ocelot = ds->priv;
> > +	struct felix *felix;
> >  
> > -	/* This driver does not make use of the speed, duplex, pause or the
> > -	 * advertisement in its mac_config, so it is safe to mark this driver
> > -	 * as non-legacy.
> > -	 */
> > -	config->legacy_pre_march2020 = false;
> > +	felix = ocelot_to_felix(ocelot);
> > +
> > +	if (felix->info->phylink_get_caps) {
> > +		felix->info->phylink_get_caps(ocelot, port, config);
> > +	} else {
> >  
> > -	__set_bit(ocelot->ports[port]->phy_mode,
> > -		  config->supported_interfaces);
> > +		/* This driver does not make use of the speed, duplex, pause or
> > +		 * the advertisement in its mac_config, so it is safe to mark
> > +		 * this driver as non-legacy.
> > +		 */
> > +		config->legacy_pre_march2020 = false;
> 
> I don't think you mean to set legacy_pre_march2020 to true only
> felix->info->phylink_get_caps is absent, do you?
> 
> Also, I'm thinking maybe we could provide an implementation of this
> function for all switches, not just for vsc7512.

I had assumed these last two patches might spark more discussion, which
is why I kept them separate (specifically the last patch).

With this, are you simply suggesting to take everything that is
currently in felix_phylink_get_caps and doing it in the felix / seville
implementations? This is because the default condition is no longer the
"only" condition. Sounds easy enough.

> 
> > +
> > +		__set_bit(ocelot->ports[port]->phy_mode,
> > +			  config->supported_interfaces);
> > +	}
> >  }
> >  
> >  static void felix_phylink_validate(struct dsa_switch *ds, int port,
> > diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
> > index 3ecac79bbf09..33281370f415 100644
> > --- a/drivers/net/dsa/ocelot/felix.h
> > +++ b/drivers/net/dsa/ocelot/felix.h
> > @@ -57,6 +57,8 @@ struct felix_info {
> >  					u32 speed);
> >  	struct regmap *(*init_regmap)(struct ocelot *ocelot,
> >  				      struct resource *res);
> > +	void	(*phylink_get_caps)(struct ocelot *ocelot, int port,
> > +				    struct phylink_config *pl_config);
> >  };
> >  
> >  extern const struct dsa_switch_ops felix_switch_ops;
> > -- 
> > 2.25.1
> >
