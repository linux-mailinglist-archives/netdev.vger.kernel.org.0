Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C15C15B6169
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 21:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiILTE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 15:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiILTE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 15:04:56 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2105.outbound.protection.outlook.com [40.107.220.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE05CE2F;
        Mon, 12 Sep 2022 12:04:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DXaUiByCkV/qWRSIwuf1Arj+O2wofyOcMQz0CvGxdrFoNns9oYaqZAcfSQoCeTtA6dPaIuOLDwJyilO349xxh5oPBNyLZNb35TDrtB6MZOkkKDkgaPAB8KP+iMwFmHQy3EEMqYSI3U0nUVpFsdLkiXfqN+cExZhgs/eDE5Em5Y8mWlbCCLHtgb6kjmqR7K+BjKoDQoRVpC2X3ZdzcSvv618Hbvsr1Hmn+UzqCjrvSE9iUXEgVcfMsODaHSSlUH1RgDw06VaBgpMO0mevOKzxXnLDVC9PNdLY4+IQWIS6CNLyXp9GLUNHZrX2wLCBLRUxJ19bSZx6c4v5mOaTzKPdhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yOmp6ul7ehSR1ffAhBOvRMh257fg+Nw5H3sjQCk2ApQ=;
 b=aB2xBrHslVfe6UjdodFUQ15o00s6rnOBlOsi6u/nwVGanNoIpBtniHJ9laJ9WSA1BO4bx0reDasQojXAGyzyNgQoGrz2fdGtWX5uAIzKNfmHqXaIVhEnN45kihuMX2xumSdMV1d9kqYQ27jQ20ItdNqr1FfIASKDB+6vGsa+zLf5QoXfNH2l98vqI5UiPwEOBixMTaPWQnCCrrrxzYr0iWLES0NYZzMjoKwOPRVBVbe5uU6lGEZTmXTFQl72KljkmrI+vw+2Kb2kB+T24Y6x2aVv6LUeLQnnakGYXRjmvOdLxdEXOGe9WWluFCJz0M/lWHJ3eL81X9EnqKy2YSg37Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yOmp6ul7ehSR1ffAhBOvRMh257fg+Nw5H3sjQCk2ApQ=;
 b=yONSFFNchXWb7Ewqia9US1eOiFf7vAurCCwPGZr/0lJ4/EUUe/YRss068HqBJ0/069aFEp3a9E8q1kEzYolr74hWRNpNahhQkL7qXirBz/JFCrHTdI0dz5N1O7sUYbpUt50aIO8PJJoNh99vIRVYLuox9oi7eFVPrMGzXGagre0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH0PR10MB4678.namprd10.prod.outlook.com
 (2603:10b6:510:3b::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Mon, 12 Sep
 2022 19:04:50 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1%7]) with mapi id 15.20.5588.020; Mon, 12 Sep 2022
 19:04:50 +0000
Date:   Mon, 12 Sep 2022 12:04:45 -0700
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
Message-ID: <Yx+CzUCbNgAjDK5l@colin-ia-desktop>
References: <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-8-colin.foster@in-advantage.com>
 <20220911200244.549029-8-colin.foster@in-advantage.com>
 <20220912170808.y4l4u2el7dozpx4j@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912170808.y4l4u2el7dozpx4j@skbuf>
X-ClientProxiedBy: BYAPR04CA0010.namprd04.prod.outlook.com
 (2603:10b6:a03:40::23) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cdbca2c-d707-4299-6558-08da94f1aae1
X-MS-TrafficTypeDiagnostic: PH0PR10MB4678:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0eMfZg7K/fK0qWvPG0ewznzhtGXOg7poTEgpNKoi6hAkKC8EcdcCqi+QhDH7UHgtc9FcJ2lSYhCk5/kzlCiL/UTu/DlIRkR6FWcBORMVMJpywbQjLeptpIJt6s6jHm+UGnFA4WM+ATqTr5VMY2xXmJ7eSKbWEpzwX3zaI1HcgvhKOaTS22mB0cJYPSKrFTzaccSuQyXMRh56m/OjLJLHup6biNuA/CV3a+5i4TqoKJQR4rzD5tFzT3YCuewtxkJ48fzRzDOPyLeWp0iL810PQoXrccEjoaMSZVQGphsAWG5igSa238oo+p4XUzPEUSm3kBh09QpgS5QrewDBTwGigrdYRSjFN8OvQIWCmbEhpIO/VO6LlgVAdVgDPkyF/GZod78OPUouMXAm2cPrnt94BmSG5qz+P44eQwHSJC1jzFMpws6hautPU0FrG8t7aiIjKmqM5f/F/YPoi2UFAg1WdniPfsblV+rMBflEOpHVM2Kpn7brlYbpn6vwUK2LXcTgqy01jBithW3GIpMSxM5y09ASMFNLAGi1jG30eW/Yyv0gwRyyxSySKumyhyTJx2ZKCDv2Iy0EVGuVxdmPzlbhri0azzl21/WAUaq/2O2blIwnb0V8SzXHKkh0rFJSsLEOX8BPeelsHKgnmBIQfhijrvbF19Rz1lxqhNq2vmlb1aYDtD2RS0OQbs0VedfUo4rO3x3u7e0TuZmhj5Gh/CG0dBraB703NgtJimhExdRiCi+aGIT2AUSBYs4V0opqtGCETn9L7lvp93TSG7O8ZR86ng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(376002)(346002)(366004)(39830400003)(136003)(396003)(451199015)(83380400001)(186003)(6486002)(9686003)(8676002)(6916009)(54906003)(6666004)(44832011)(5660300002)(4326008)(33716001)(86362001)(6506007)(966005)(66476007)(66556008)(7416002)(6512007)(478600001)(38100700002)(8936002)(41300700001)(66946007)(26005)(316002)(2906002)(30864003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fJHodgQvpGYN8iBxomlI8fvTe63bj4QYCZCv9JjeuggDaxUi4jSMzvK/GDNX?=
 =?us-ascii?Q?Q7BzZucqgZzR61PwXWDNLPnwSoVIRtsLLsZabIsBpnYWlqELfOe1LQqLwyE+?=
 =?us-ascii?Q?T+FWOkUz6CqGlqOgwkqjd+2pZ/cLxiAPVFQLv1Lv1rcSDrjVRII8Yud+En9Z?=
 =?us-ascii?Q?S+wFEHY3olLrN71rEQecsgXixvZBDHkf9Y+z5Y5sLBoE8kikZXlNhvfGwjvr?=
 =?us-ascii?Q?gKFnLaSJQRz4i6wWD/vnEezTRdYUN1PnK2m4nJuKi33HC4OLjWoBsLj0b0ew?=
 =?us-ascii?Q?E4UOallTgGkJGqydGo/Twx+Bnd2BAmRyOUQhDUjMClseruM+8S2EkoQbaY8q?=
 =?us-ascii?Q?VrYhhO1s5DvShb1MENtR026E3ZGc0Uku9VIR5SwXpWtHpc0lOJpZQe9uDHXK?=
 =?us-ascii?Q?W4BQF2C9nEwqpWEnVfCZS6tO4N7a5lL4YWrdRCB6YLT7gWqPMijOW35ceigu?=
 =?us-ascii?Q?gLpPC1IMNH2U9dzDe1R5WQKXnpofXFQ3tECCAaahhLosBive9rgN3KdJ3mb8?=
 =?us-ascii?Q?P4H9mxzMoGfODxJWRIKb2PGYoAYYyD6tqZ0MNZfV3PNoAR2a2HL+7RDvO//3?=
 =?us-ascii?Q?mVsThE7kyqP4d9ELFUgoRNimcsweg/DcQTWM3f/baLV/RrK+Y2/1BzjSWTc/?=
 =?us-ascii?Q?18GHOiSLBjRys6faRhU65oLNPCj72ZJghepeOO9BC62wClQuhDxt8HZt7WDA?=
 =?us-ascii?Q?9/GORYBnNCr1ig9NOYdLL1qbtapgdr0SjoRyQwCSpp0goY2klqREbmXS9PA9?=
 =?us-ascii?Q?JOGg/LDwiMBEu6WzYNgTGj+o6mraHwSd4yj1ivK8ZduxnAJuBvLbvE8FB9LQ?=
 =?us-ascii?Q?M3k9LguUvXpUHzjCBMG/GA1N3YAX1uXxkNTJ1d5zQ+qY1m5fzyUJBGtxcF7v?=
 =?us-ascii?Q?LupTcgwBL1QjSOmTRXwyLCyD0oj77tbIe3h4i4Isj3G6uMUakWvyQUG9QbV5?=
 =?us-ascii?Q?ynjK7LYxtNBYUhuvVS9XDc/GsvC9xxhiwTOkehJ9nqTv6aGV7DdQSeCwG1wt?=
 =?us-ascii?Q?3eY8KhtKEWoPP9oxUtqmAXlqpKYwTJE4WiogjU02s9ty4jKcP57NpwmnpJer?=
 =?us-ascii?Q?iyKFEl/SDIDYLTgn3RNQ8lxU2gJTpLHOhX75OzVLSpXIb2IeHTTwxyfw/+fx?=
 =?us-ascii?Q?4wF0h8UaDEDdZSzAPAtoL8z7xb29tkTJwItXDLTfFx9DG5QE4rH76cb6cfc2?=
 =?us-ascii?Q?OyZgI5SHCZFC/m9DhL8hhTYutlsPgO88/ecqCglL8Pc4YoDCq5JkYo2yjbEn?=
 =?us-ascii?Q?Wd5LnULkkF7tiFOI2utNBaBBVv5uGqaRhjqbyG5luj1DBUvsl5ffcj22QZbs?=
 =?us-ascii?Q?mZNfQGMs+2Ga3XTx8hq4ualwDOoZZ/870hm1ImtmnV/OoxopGn1nsoVkNWli?=
 =?us-ascii?Q?DEOa8Axn4qLSt7pihqzlExHBd2K1hVMxl7tm5GRQaLT+mR7hJkPhjH07T3gP?=
 =?us-ascii?Q?JvssXdCxr1I5I8GlttBv4flSUuegJIpq1szcN5X48+e32jsOhf0nPbSCKtAd?=
 =?us-ascii?Q?AGWktZU5QMz06CGVoxmpWLbnBh5MpSBDZdakSO6DuFfZtDGCzPmJInm2VPkm?=
 =?us-ascii?Q?aQujbDUsyg835sSKph8ia+P/DYY4vZvrbsaY5P8hpegZTQHZjhI1NOwJaC3j?=
 =?us-ascii?Q?VQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cdbca2c-d707-4299-6558-08da94f1aae1
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 19:04:50.3305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z19+zFBLIO+8EM/NDBEa9yyLOP0rNnybC0txngmVtT5lt+tTFDg1d4Aorfy8NDPOYcQ90/lNJYY1wEuToTaq4m+GWPHhZcaYj1yXxKgB4qM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4678
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 05:08:09PM +0000, Vladimir Oltean wrote:
> On Sun, Sep 11, 2022 at 01:02:43PM -0700, Colin Foster wrote:
> > The Ocelot switch core driver relies heavily on a fixed array of resources
> > for both ports and peripherals. This is in contrast to existing peripherals
> > - pinctrl for example - which have a one-to-one mapping of driver <>
> > resource. As such, these regmaps must be created differently so that
> > enumeration-based offsets are preserved.
> > 
> > Register the regmaps to the core MFD device unconditionally so they can be
> > referenced by the Ocelot switch / Felix DSA systems.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> > 
> > v1 from previous RFC:
> >     * New patch
> > 
> > ---
> >  drivers/mfd/ocelot-core.c  | 88 +++++++++++++++++++++++++++++++++++---
> >  include/linux/mfd/ocelot.h |  5 +++
> >  2 files changed, 88 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
> > index 1816d52c65c5..aa7fa21b354c 100644
> > --- a/drivers/mfd/ocelot-core.c
> > +++ b/drivers/mfd/ocelot-core.c
> > @@ -34,16 +34,55 @@
> >  
> >  #define VSC7512_MIIM0_RES_START		0x7107009c
> >  #define VSC7512_MIIM1_RES_START		0x710700c0
> > -#define VSC7512_MIIM_RES_SIZE		0x024
> > +#define VSC7512_MIIM_RES_SIZE		0x00000024
> >  
> >  #define VSC7512_PHY_RES_START		0x710700f0
> > -#define VSC7512_PHY_RES_SIZE		0x004
> > +#define VSC7512_PHY_RES_SIZE		0x00000004
> >  
> >  #define VSC7512_GPIO_RES_START		0x71070034
> > -#define VSC7512_GPIO_RES_SIZE		0x06c
> > +#define VSC7512_GPIO_RES_SIZE		0x0000006c
> >  
> >  #define VSC7512_SIO_CTRL_RES_START	0x710700f8
> > -#define VSC7512_SIO_CTRL_RES_SIZE	0x100
> > +#define VSC7512_SIO_CTRL_RES_SIZE	0x00000100
> 
> Split the gratuitous changes to _RES_SIZE to a separate patch please, as
> they're just noise here?

Will do.

> > +const struct resource vsc7512_target_io_res[TARGET_MAX] = {
> > +	[ANA] = DEFINE_RES_REG_NAMED(VSC7512_ANA_RES_START, VSC7512_ANA_RES_SIZE, "ana"),
> > +	[QS] = DEFINE_RES_REG_NAMED(VSC7512_QS_RES_START, VSC7512_QS_RES_SIZE, "qs"),
> > +	[QSYS] = DEFINE_RES_REG_NAMED(VSC7512_QSYS_RES_START, VSC7512_QSYS_RES_SIZE, "qsys"),
> > +	[REW] = DEFINE_RES_REG_NAMED(VSC7512_REW_RES_START, VSC7512_REW_RES_SIZE, "rew"),
> > +	[SYS] = DEFINE_RES_REG_NAMED(VSC7512_SYS_RES_START, VSC7512_SYS_RES_SIZE, "sys"),
> > +	[S0] = DEFINE_RES_REG_NAMED(VSC7512_S0_RES_START, VSC7512_S_RES_SIZE, "s0"),
> > +	[S1] = DEFINE_RES_REG_NAMED(VSC7512_S1_RES_START, VSC7512_S_RES_SIZE, "s1"),
> > +	[S2] = DEFINE_RES_REG_NAMED(VSC7512_S2_RES_START, VSC7512_S_RES_SIZE, "s2"),
> > +	[GCB] = DEFINE_RES_REG_NAMED(VSC7512_GCB_RES_START, VSC7512_GCB_RES_SIZE, "devcpu_gcb"),
> > +	[HSIO] = DEFINE_RES_REG_NAMED(VSC7512_HSIO_RES_START, VSC7512_HSIO_RES_SIZE, "hsio"),
> > +};
> 
> EXPORT_SYMBOL is required, I believe, for when ocelot_ext is built as
> module?

Agreed on this and the other symbol. Thanks.

> 
> > +
> >  static const struct mfd_cell vsc7512_devs[] = {
> >  	{
> >  		.name = "ocelot-pinctrl",
> > @@ -127,7 +194,7 @@ static const struct mfd_cell vsc7512_devs[] = {
> >  static void ocelot_core_try_add_regmap(struct device *dev,
> >  				       const struct resource *res)
> >  {
> > -	if (dev_get_regmap(dev, res->name))
> > +	if (!res->start || dev_get_regmap(dev, res->name))
> 
> I didn't understand at first what this extra condition here is for.
> I don't think that adding this extra condition here is the clearest
> way to deal with the sparsity of the vsc7512_target_io_res[] array, plus
> it seems to indicate the masking of a more unclean code design.

Yes, it was a way to deal with this struct. I see that I should have at
least added a comment, but the way you suggest below is cleaner (before
try_add_regmap())

> 
> I would propose an alternative below, at the caller site....
> 
> >  		return;
> >  
> >  	ocelot_spi_init_regmap(dev, res);
> > @@ -144,6 +211,7 @@ static void ocelot_core_try_add_regmaps(struct device *dev,
> >  
> >  int ocelot_core_init(struct device *dev)
> >  {
> > +	const struct resource *port_res;
> >  	int i, ndevs;
> >  
> >  	ndevs = ARRAY_SIZE(vsc7512_devs);
> > @@ -151,6 +219,16 @@ int ocelot_core_init(struct device *dev)
> >  	for (i = 0; i < ndevs; i++)
> >  		ocelot_core_try_add_regmaps(dev, &vsc7512_devs[i]);
> >  
> > +	/*
> > +	 * Both the target_io_res and tbe port_io_res structs need to be referenced directly by
> 
> s/tbe/the
> 
> > +	 * the ocelot_ext driver, so they can't be attached to the dev directly
> 
> I don't exactly understand the meaning of "they can't be attached to the
> dev *directly*". You mean that the "struct mfd_cell vsc7512_devs[]" entry
> for "mscc,vsc7512-ext-switch" will not have a "resources" property, right?
> Better to say "using mfd_add_devices()" rather than "directly"?

I'll reword the comment - but I think it might go away entirely with
what you're suggesting below.

> 
> > +	 */
> > +	for (i = 0; i < TARGET_MAX; i++)
> > +		ocelot_core_try_add_regmap(dev, &vsc7512_target_io_res[i]);
> 
> 	/*
> 	 * vsc7512_target_io_res[] is a sparse array, skip the missing
> 	 * elements
> 	 */
> 	for (i = 0; i < TARGET_MAX; i++) {
> 		res = &vsc7512_target_io_res[i];
> 		if (!res->start)
> 			continue;
> 
> 		ocelot_core_try_add_regmap(dev, res);
> 	}
> 
> Something interesting that I stumbled upon in Documentation/process/6.Followthrough.rst
> was:
> 
> | Andrew Morton has suggested that every review comment which does not result
> | in a code change should result in an additional code comment instead; that
> | can help future reviewers avoid the questions which came up the first time
> | around.
> 
> so if you don't like my alternative, please at least do add a comment in
> ocelot_core_try_add_regmap().

I'm due for another re-read of this documentation. That's a very practical
suggestion.

> 
> > +
> > +	for (port_res = vsc7512_port_io_res; port_res->start; port_res++)
> > +		ocelot_core_try_add_regmap(dev, port_res);
> > +
> >  	return devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, vsc7512_devs, ndevs, NULL, 0, NULL);
> >  }
> >  EXPORT_SYMBOL_NS(ocelot_core_init, MFD_OCELOT);
> > diff --git a/include/linux/mfd/ocelot.h b/include/linux/mfd/ocelot.h
> > index dd72073d2d4f..439ff5256cf0 100644
> > --- a/include/linux/mfd/ocelot.h
> > +++ b/include/linux/mfd/ocelot.h
> > @@ -11,8 +11,13 @@
> >  #include <linux/regmap.h>
> >  #include <linux/types.h>
> >  
> > +#include <soc/mscc/ocelot.h>
> > +
> >  struct resource;
> >  
> > +extern const struct resource vsc7512_target_io_res[TARGET_MAX];
> > +extern const struct resource vsc7512_port_io_res[];
> > +
> >  static inline struct regmap *
> >  ocelot_regmap_from_resource_optional(struct platform_device *pdev,
> >  				     unsigned int index,
> > -- 
> > 2.25.1
> >
> 
> Actually I don't like this mechanism too much, if at all. I have 4 mutt
> windows open right now, plus the previous mfd patch at:
> https://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git/commit/?h=ib-mfd-net-pinctrl-6.0&id=f3e893626abeac3cdd9ba41d3395dc6c1b7d5ad6
> to follow what is going on. So I'll copy some code from other places
> here, to concentrate the discussion in a single place:
> 
> From patch 8/8:
> 
> > +static struct regmap *ocelot_ext_regmap_init(struct ocelot *ocelot,
> > +					     struct resource *res)
> > +{
> > +	return dev_get_regmap(ocelot->dev->parent, res->name);
> > +}
> 
> > +static const struct felix_info vsc7512_info = {
> > +	.target_io_res			= vsc7512_target_io_res, // exported by drivers/mfd/ocelot-core.c
> > +	.port_io_res			= vsc7512_port_io_res, // exported by drivers/mfd/ocelot-core.c
> > +	.init_regmap			= ocelot_ext_regmap_init,
> > +};
> 
> From drivers/net/dsa/felix.c:
> 
> static int felix_init_structs(struct felix *felix, int num_phys_ports)
> {
> 	for (i = 0; i < TARGET_MAX; i++) {
> 		struct regmap *target;
> 
> 		if (!felix->info->target_io_res[i].name)
> 			continue;
> 
> 		memcpy(&res, &felix->info->target_io_res[i], sizeof(res));
> 		res.flags = IORESOURCE_MEM;
> 		res.start += felix->switch_base;
> 		res.end += felix->switch_base;
> 
> 		target = felix->info->init_regmap(ocelot, &res);
> 		if (IS_ERR(target)) {
> 			dev_err(ocelot->dev,
> 				"Failed to map device memory space\n");
> 			kfree(port_phy_modes);
> 			return PTR_ERR(target);
> 		}
> 
> 		ocelot->targets[i] = target;
> 	}
> }
> 
> So here's what I don't like. You export the resources from ocelot-mfd to
> DSA, to get just their *string* names. Then you let the common code
> create some bogus res.start and res.end in felix_init_structs(), which
> you discard in felix->info->init_regmap() - ocelot_ext_regmap_init(),
> and use just the name. You even discard the IORESOURCE_MEM flag, because
> what you get back are IORESOURCE_REG resources. This is all very confusing.
> 
> So you need to retrieve a regmap for each ocelot target that you can.
> Why don't you make it, via mfd_add_devices() and the "resources" array
> of struct mfd_cell (i.e. the same mechanism as for every other peripheral),
> such that the resources used by the DSA device have an index determined
> by i = 0; i < TARGET_MAX; i++; platform_get_resource(dev, i, IORESOURCE_REG)?
> This way, DSA needs to know no more than the index of the resource it
> asks for.

That is exactly right. The ocelot_ext version of init_regmap() now uses
dev_get_regmap() which only cares about the name and essentially drops
the rest of the information. Previous versions hooked into the
ocelot-core / ocelot-spi MFD system to request that a new regmap be
created (with start and end being honored.) A benefit of this design is
that any regmaps that are named the same are automatically shared. A
drawback (or maybe a benefit?) is that the users have no control over
ranges / flags.

I think if this goes the way of index-based that'll work. I'm happy to
revert my previous change (sorry it snuck in) but it seems like there'll
still have to be some trickery... For reference:

enum ocelot_target {
	ANA = 1,
	QS,
	QSYS,
	REW,
	SYS,
	S0,
	S1,
	S2,
	HSIO,
	PTP,
	FDMA,
	GCB,
	DEV_GMII,
	TARGET_MAX,
};

mfd_add_devices will probably need to add a zero-size resource for HSIO,
PTP, FDMA, and anything else that might come along in the future. At
this point, regmap_from_mfd(PTP) might have to look like (pseudocode):

struct regmap *ocelot_ext_regmap_from_mfd(struct ocelot *ocelot, int index)
{
    return ocelot_regmap_from_resource_optional(pdev, index-1, config);

    /* Note this essentially expands to:
     * res = platform_get_resource(pdev, IORESOURCE_REG, index-1);
     * return dev_get_regmap(pdev->dev.parent, res->name);
     *
     * This essentially throws away everything that my current
     * implementation does, except for the IORESOURCE_REG flag
     */
}

Then drivers/net/dsa/felix.c felix_init_structs() would have two loops
(again, just as an example)

for (i = ANA; i < TARGET_MAX; i++) {
    if (felix->info->regmap_from_mfd)
        target = felix->info->regmap_from_mfd(ocelot, i);
    else {
        /* existing logic back to ocelot_regmap_init() */
    }
}

for (port = 0; port < num_phys_ports; port++) {
    ...
    if (felix->info->regmap_from_mfd)
        target = felix->info->regmap_from_mfd(ocelot, TARGET_MAX + port);
    else {
        /* existing logic back to ocelot_regmap_init() */
    }
}

And lastly, ocelot_core_init() in drivers/mfd/ocelot-core.c would need a
mechanism to say "don't add a regmap for cell->resources[PTP], even
though that resource exists" because... well I suppose it is only in
drivers/net/ethernet/mscc/ocelot_vsc7514.c for now, but the existance of
those regmaps invokes different behavior. For instance:

	if (ocelot->targets[FDMA])
		ocelot_fdma_init(pdev, ocelot);

I'm not sure whether this last point will have an effect on felix.c in
the end. My current patch set of adding the SERDES ports uses the
existance of targets[HSIO] to invoke ocelot_pll5_init() similar to the
ocelot_vsc7514.c FDMA / PTP conditionals, but I'd understand if that
gets rejected outright. That's for another day.



I'm happy to make these changes if you see them valid. I saw the fact
that dev_get_regmap(dev->parent, res->name) could be used directly in
ocelot_ext_regmap_init() as an elegant solution to felix / ocelot-lib /
ocelot-core, but I recognize that the subtle "throw away the
IORESOURCE_MEM flag and res->{start,end} information" isn't ideal.

> 
> [ yes, you'll need to revert your own commit 242bd0c10bbd ("net: dsa:
>   ocelot: felix: add interface for custom regmaps"), which I asked you
>   about if you're sure if this is the final way in which DSA will get
>   its regmaps. Then you'll need to provide a different felix->info
>   operation, such as felix->info->regmap_from_mfd() or something, where
>   just the index is provided. If that isn't provided by the switch, we
>   "fall back" to the code that exists right now, which, when reverted,
>   does create an actual resource, and directly calls ocelot_regmap_init()
>   on it, to create an MMIO regmap from it ]
