Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55C1A5203E1
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 19:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239911AbiEISAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 14:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239833AbiEIR7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 13:59:42 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2128.outbound.protection.outlook.com [40.107.237.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A474B2DAA6;
        Mon,  9 May 2022 10:55:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hqSYY3JLtrTm8TWrwDXpu8Z48TedOXP2k3yGCPvP16PHRdRngQSXaKztxCXYccXq2LweQOa7nshylRtEf3bcE694friUNw6uH0r72fKpeymQejb7i0T8YIcPpYcCl2obfv9n8IS0ecllr2opvoXknl+IEa+HiZuo1mQgMAXGt4InTRgDA20C8mK2XTytillc7qPiuZZo6IH3zf+BTO6uC38SwtrpXs62/DYHmfkmFTdBTvJCUjWvZB4QDbRu+k7SnjTB2bGjadfAhROR/ny6J1DeMVeysAwuZpa4FNMVJ1gfWklZmyjdyWKKw6UdoJ2RX2dFq0wui5u8p2Y/zq3SIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3njY0SlppYofuxSiHLODHPIWm+uR8lQFRZXon+aoYf0=;
 b=h/10Hw4wdbRMzKHKVov+u8P3kYb8/I0TVIsPahBIgL1yHPe//wG9WecPqUoBo+YCksw80j8jUzSO5+uXw4zS1qJUQ/rgRZQmm7fxSvVRxEwHCwL/gaeDIIA5klF6mrXBvK7i3ktynP+oDc8keQhnNtYz3hzsuqLrst1Ylfy7qyg9mCuLpA/AZ17VFSkpos5jLtEWy5eMHdWHeBQjZBhLXsydt2dTIgFwLSWQuRrzQroyMIVqzMXWSunjQSiwdWO/bs0al+EhNphmtIMd1j9OkDjQMjkYAiTXK+j1RiWzwKTG2Kd/XNpx6yRaZCm6ObEOI17F0c9PFFS593HAoXLiRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3njY0SlppYofuxSiHLODHPIWm+uR8lQFRZXon+aoYf0=;
 b=AykaHmwMuMSw6pesWPn4y1mPd/loHf1rdtEtfL+yaPGeFKsmwPWIoIEULMVi6cIVY69VQNt3AV4xU3nohgwsW6UYz+X0NVQ63r4iiJpVKrb2f0+PhXWEorVUzlSxRO5/HqN3ol276JKHRRv9EkixAyz9aiNocBCZXBWAtWTAxL4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH2PR10MB4023.namprd10.prod.outlook.com
 (2603:10b6:610:b::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Mon, 9 May
 2022 17:55:34 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5227.020; Mon, 9 May 2022
 17:55:33 +0000
Date:   Mon, 9 May 2022 17:55:37 -0700
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
Message-ID: <20220510005537.GH895@COLIN-DESKTOP1.localdomain>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220508185313.2222956-16-colin.foster@in-advantage.com>
 <20220509103444.bg6g6wt6mxohi2vm@skbuf>
 <20220510002332.GF895@COLIN-DESKTOP1.localdomain>
 <20220509173029.xkwajrngvejkyjzs@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509173029.xkwajrngvejkyjzs@skbuf>
X-ClientProxiedBy: MW2PR2101CA0015.namprd21.prod.outlook.com
 (2603:10b6:302:1::28) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7324c281-9a62-4ab3-2d4d-08da31e51d53
X-MS-TrafficTypeDiagnostic: CH2PR10MB4023:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB4023F980F427627E8EF5D015A4C69@CH2PR10MB4023.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1C9+wHK1P/edpjKer2ZZyPrCTcW5Fapp7bEnM2IDBUCf5JKF/NZxInWyd3LnI/HSLOzZyJjfDaVjBzhH40Ggyz7IO+SqXI0iHqiu8cas7tXqSxP5pLZQ+EIqelL7W57xLw8DoVveGr2m82rxdVZcwC4HRI1nG4D1eapVR9Ziy2OZKLJBjH4pN8CrQn5P217wdJFmSY+DAJPHEbq8whEu0Q4lPchBlrlvgOh7i0ppYVpafeLX6hWl8rzM8GBYEQb6RhCmscNWDPRzjzgkPzwgexO9mhsZBTZ1jR0xn7dNdphjWucTdmi1yyGhkJvJN4hVGieOuHY8XzGWd01xo563GGvEvJZ6wIN+hU0se4GSv9Y0ngjYTI7XLvw992OD2wIpVfG+R7OQ5admsG0PqKf+MGSqij5sK466pgXTJUpoFqkX/F+/ubedmBiCxvA93on5tocdGqJv4wbR7NeId9A8jDqQ8FCKE2vtBthKUane28hFlwtCM1IjAsFszENBZSigodmRJLC2TavpNzvFFVLryPlbexrYyu7j+2ymRRYXMB/8Wfo56ggcrqFC0dlr/nbBw3GmQK+HZIKnDSoaJOF4Xw/KxzIXENX6idTFo8LfzvGZ+fWSrc68849WT5FA1+9k6frY+YpGPBeyjcYORaFGDIrZAyzYjmIEb/WHUTXt/5rDPWTuqJCHctrlunWnEBkz5WbhU10+MoBsgY80yTu8Aw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(136003)(396003)(376002)(346002)(39840400004)(2906002)(54906003)(6916009)(26005)(9686003)(6512007)(86362001)(316002)(66476007)(66556008)(66946007)(4326008)(83380400001)(38100700002)(38350700002)(186003)(8676002)(1076003)(6506007)(8936002)(5660300002)(52116002)(6486002)(33656002)(44832011)(508600001)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WEKrzaujipuiWQdsUajlGttBfXShA9Iaa9LeGqwHniGBfbP6gvN7FntXibTK?=
 =?us-ascii?Q?90R0HuQLxkmhogoLsyeta7bsxe5Saa/zmSzL43kmLeu+Tfi+zaWjodjs1Rjx?=
 =?us-ascii?Q?0ilmzqtARxvNm/rptjz/8295RiKzTCADN45Oh8V64wiQDmRhN/Jhuaxa33Zb?=
 =?us-ascii?Q?TJ/k32RmVuB3/wSDC1ylxwd632e7dcPRyw4WkSQVTotMa07ODhhv9KEKC0tH?=
 =?us-ascii?Q?QZ7KDtw5H17hkRz1EtrJsMgjLzRqgi8DD97SDn3BeVxXFqpWuK31WcBwxeM4?=
 =?us-ascii?Q?rShN1Mm33xTJ5dAfMLUtByDyUZwfzwnFEyQZuGDjWgYWIbsuX5hk5hQaSwim?=
 =?us-ascii?Q?vAexgTP0dI1CUREC4SsKboyD+CqRtfbfV2Zd4Ah7JahgdBx/xksyjHag4Vuw?=
 =?us-ascii?Q?kvUxaEjIriextd0ddwQ5avOaxWXmnW45fJywR63BQrYhVIO/l/yUBTS9o3+S?=
 =?us-ascii?Q?3Kz7hcY97ICqbqyAgJ+oL4C7HFToWStGENacqXlE3lX1QzhMIMT2DGx0rCrY?=
 =?us-ascii?Q?STe1N89oDUW//M0aEP/n0vaSUeBBRB0zCdQWW1e23yLYX/4p83jOz8f88MY0?=
 =?us-ascii?Q?GcraAfoqOOLt3FHVKKFhqe4IDKZVuVaa8o9sNNyREnbAIcDq+4Udh/L6UZMA?=
 =?us-ascii?Q?2FgPl0Ngzd+dGdpmOiFKkHVgnNPVLixbMpoP65qQ/XkPQMIfxgfR0ABVmq05?=
 =?us-ascii?Q?ocX1JSlyznyqgh0RtUPhzcYlpeWzhC/Z4xL55TncoxCpYQGkfh1fe3grOD2X?=
 =?us-ascii?Q?H9GjUJlKJa4/QFhevjkEzOLUDD8m3xDuRh7exgr/M0OOy/FoT0Iai94IfIGW?=
 =?us-ascii?Q?fvOwMfgRCpylQiRyLZikqBPNtVmBqq+gdwSUeKqDU4ZKsXLoqJ5nXGs+jHmU?=
 =?us-ascii?Q?vYVcSejFxDY9Mbsl3Oez1ZyOgojnMQYbgf6OXXx+hgOKkoJaZJBh4376YK0K?=
 =?us-ascii?Q?tYN15aAfYCqCN9b/0x+xtzoQBXdcVS9vptGRBebMH+UXglemXR+3D1Od0pFh?=
 =?us-ascii?Q?rGpkITqRYLQpBttm+rAgbEiSaKFi6G6R1s4Bae0/cT2yW6W+s/AHRTteUB8c?=
 =?us-ascii?Q?qvK5d/fDVJRqo4ZU8UZ6sduhZm9fzoq+Wcf88pI2nIiq2soTfe5KmFKwHf9A?=
 =?us-ascii?Q?iVD/nIgfdXxiT6wItabvIhYX+I2mtp5IUMGectCQ+FP9GF3l5eKw+haUDRHn?=
 =?us-ascii?Q?YB3NpVvoaIJx1Wbyj1L3z6sLOCSzb0o2o+RJNavhVeZ7y1NDr7Qw4IRI2hKV?=
 =?us-ascii?Q?CIlsY+tw88cyLebW8Pwiso8e4PP/ReKI3AeToBaK08Uo9PnbxlWYYwAtmqeE?=
 =?us-ascii?Q?ALHnypFBi9DwUwLIH3eq3nuMoCd4Uv0IeO1QIe70gW+ppwBbpf/11tr0TjDa?=
 =?us-ascii?Q?jjQQ5ViYO8T7d2SPSoLG7nPmKmVRyXSUUMmJlEkrp0IwSEFkVvpcEF8gWNhc?=
 =?us-ascii?Q?c01Rud+f3ECpvCDz5UhQBOo63uf0NjlxvwZKnZaugpEIeRwPexRcDy8m4Nhe?=
 =?us-ascii?Q?jv0fLHsJ1tkt6Jbz20B+hlOoBw/ncpMhL6nMC46i/KAEnIum7BX1JWBWv97X?=
 =?us-ascii?Q?i0AmowBwHLCrgyMaa1JeLakJUxbIrSYEGiYqs+YtX9tLsje5TE4E3h83FN6E?=
 =?us-ascii?Q?BZYqHEUpgOuQ7BUlvxXFab2f4CCA93NfD1j9d/BA1FQ8oq9VKXP/+URrenKt?=
 =?us-ascii?Q?YEBbSaHFrfTPMFI3hh92XJV/teNbV2Y3HkUpsO/dq3BLM0OH6hikiTZ+FjQm?=
 =?us-ascii?Q?6LaUukKn1EsXBNdq/EiRMisIz5mCYOwFggzHYQKwHJ6N6MzgsJ02?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7324c281-9a62-4ab3-2d4d-08da31e51d53
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 17:55:33.7796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HZOzFG5JkMZD7vNAsWH1kSBXKm/PX+bY/W8iPAvpJzwfv9oKG7EeE6VWsmtP6cOXfJZxIr1De1WDYu54EinN0uZ3wYMwSZVyr+LE6hGKLPQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4023
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 05:30:30PM +0000, Vladimir Oltean wrote:
> On Mon, May 09, 2022 at 05:23:32PM -0700, Colin Foster wrote:
> > > > @@ -982,15 +982,23 @@ static void felix_phylink_get_caps(struct dsa_switch *ds, int port,
> > > >  				   struct phylink_config *config)
> > > >  {
> > > >  	struct ocelot *ocelot = ds->priv;
> > > > +	struct felix *felix;
> > > >  
> > > > -	/* This driver does not make use of the speed, duplex, pause or the
> > > > -	 * advertisement in its mac_config, so it is safe to mark this driver
> > > > -	 * as non-legacy.
> > > > -	 */
> > > > -	config->legacy_pre_march2020 = false;
> > > > +	felix = ocelot_to_felix(ocelot);
> > > > +
> > > > +	if (felix->info->phylink_get_caps) {
> > > > +		felix->info->phylink_get_caps(ocelot, port, config);
> > > > +	} else {
> > > >  
> > > > -	__set_bit(ocelot->ports[port]->phy_mode,
> > > > -		  config->supported_interfaces);
> > > > +		/* This driver does not make use of the speed, duplex, pause or
> > > > +		 * the advertisement in its mac_config, so it is safe to mark
> > > > +		 * this driver as non-legacy.
> > > > +		 */
> > > > +		config->legacy_pre_march2020 = false;
> > > 
> > > I don't think you mean to set legacy_pre_march2020 to true only
> > > felix->info->phylink_get_caps is absent, do you?
> > > 
> > > Also, I'm thinking maybe we could provide an implementation of this
> > > function for all switches, not just for vsc7512.
> > 
> > I had assumed these last two patches might spark more discussion, which
> > is why I kept them separate (specifically the last patch).
> > 
> > With this, are you simply suggesting to take everything that is
> > currently in felix_phylink_get_caps and doing it in the felix / seville
> > implementations? This is because the default condition is no longer the
> > "only" condition. Sounds easy enough.
> 
> No, not everything, just the way in which config->supported_interfaces
> is populated. We have different PCS implementations, so it's likely that
> the procedures to retrieve the valid SERDES protocols (when changing
> them will be supported) are different.
> 
> But in fact I seriously doubt that the current way in which supported_interfaces
> gets populated is limiting you from doing anything right now, precisely
> because you don't have any code that supports changing the phy-mode.

Hmm... So the main reason I needed get_caps was because
phylink_generic_validate looks at mac_capabilities. I know I'll have to
deal with supported_interfaces once I finally get the other four ports
working, but for now the main purpose of this patch is to allow me to
populate the mac_capabilities entry for phylink_generic_validate.

Aside from ensuring legacy_pre_march2020 = false, I feel like the rest
of the patch makes sense.

> 
> Also, it's unlikely (I'd say impossible) for one driver to be
> unconverted to the post-March-2020 requirements and the other not to be.
> The simple reason is that they share the same mac_config implementation.
> So it's perfectly ok to keep "config->legacy_pre_march2020 = false"
> right where it is.
> 
> So I'd say it's up to you, but I'd drop this patch right now.
