Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D03652032E
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 19:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239510AbiEIRJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 13:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239505AbiEIRJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 13:09:11 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2090.outbound.protection.outlook.com [40.107.100.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411022D572E;
        Mon,  9 May 2022 10:05:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a619xj4W1uBPbGh0hVP/PvhgIONu9T5Q+a9ZWjOEGfrjfqwk9OTPmWeF8Jw7Nocdq4oLd2m+l0UjIcEKfFWLCTDqTBQGD20cfvBQC5hHFunOz9hWSfENl8nXmv5fOfj3G9nF8p4Nq1qiw7UJGt1/v1EJ0m3GxAxiyR6wMxyY9c7X6GzmOTUI7OL59dP06aVPtt0p+iYZ/ZeY7xANj/PKY6STky4ksId1PHyfkH/X3b4yEUd0HUSnwJLtSW/cnE54M2EtOodcwT3Fq0K8U3dEhcFTf8zGWsfy1VCjtR1Rdo4zqpEloPsT3mjcXVESDUe1WlZCQVFADnfv3Itlsr8Z1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ua/rd01XKu1/g96NDxmvClYCeZdS+A3hZ/jPdk15Mw=;
 b=ErPCa9PMrQD4fARcqAlw+gE8+ZfT6eQe/WJPjR3Ls6dKa0zygNMVWjPNT5o9lWg+UrsdCPNDB0eamExz517gxJXiO6SJWrwM4o7xjKSiZVO4BJF0EnLDH4uzfVlaPfhmz2IN/lQqVFceptvo9RSFMyBoyGOEU7ofGxeCgZfxrW0O7N4lG5iDIc1XP+8fITw6jtR17DX9DktwMsy9/5VjRViNFZdtk2+PTS5Dy0i4KDnO5eFukGbY/X6iQn4+fRAyIwnsgLn1rzQCXgaFTHkT5bLCgn5uSjkNNQVpmd3RBfeL7lnp+659Iu0LydI34lnMnETPPxn0483lLG2auKvV3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ua/rd01XKu1/g96NDxmvClYCeZdS+A3hZ/jPdk15Mw=;
 b=CHhH1hww3K1k/Zrdp3qblueijXVmMxWg1zQonQNoldBaEMk3DcgimgnZJQKEQNr14k0D/AwJMVqfJX1Di8rEWN6fkZVWCAN1UZw2f8LT3zgf5aI5LbxkYTRtKMhv0COD4CRTVWXZU47CHCSnndUJQ6b1VfCGdidt5Nm9OeZ1YuQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SN4PR10MB5573.namprd10.prod.outlook.com
 (2603:10b6:806:204::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Mon, 9 May
 2022 17:05:14 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5227.020; Mon, 9 May 2022
 17:05:14 +0000
Date:   Mon, 9 May 2022 17:05:16 -0700
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
Subject: Re: [RFC v8 net-next 11/16] net: mscc: ocelot: expose regfield
 definition to be used by other drivers
Message-ID: <20220510000516.GE895@COLIN-DESKTOP1.localdomain>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220508185313.2222956-12-colin.foster@in-advantage.com>
 <20220509105638.btfgdr4wt427ewip@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509105638.btfgdr4wt427ewip@skbuf>
X-ClientProxiedBy: BY5PR17CA0032.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::45) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ad3208f-f02d-4e77-dcbf-08da31de158e
X-MS-TrafficTypeDiagnostic: SN4PR10MB5573:EE_
X-Microsoft-Antispam-PRVS: <SN4PR10MB5573098770C09AE7CB3DBE7AA4C69@SN4PR10MB5573.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B1bOQ9nQUTXuXBP7NOEt7t1kZ4CBD6WU3jKpU0GZp+4toFN2j4/EXjqm55T/P2d4foNWG+EdTyaSVh3kbMrKfhqpRzJfFI+MfENDNfmwpxE+gp+oE5aNAwEmveDpj3lxU4jGemBobhaFSJe0JOpqXkGUSV1PMj0vJ0Mi2KXaRkj8e8NqI93Kac6GX8PLFoutGd7xikBwx1ZpB8dWKnTZ4bSzPTwG6BvW6oAwmvbDm3hEO8H9TWT/AsbCjjmlLaLujxnnMaDBvEyh1k9PBKv5CekOm3bfXOf/dIKDkA4znGa/KywWJ7U6BFhafgb6cvckOiH7ULSePicebX5Sc75E2JvG6GuHFDKvztDPa232Zy8MID9KmWD6Psv6fk7/WYyrlcnQGUhIiJZVPWQbcHaQbhQl09SgAaMwsTj2Fj/i89GFjYozwEOWH1BStI31D8J1FIaz7YQAWVj2rMrpqA+SANz1oLJ0793lCk/m81kMzrUmYig4ZMY0eRPCU04XXA88sEzKraKsAnKEHPZrQ2Xj/s2uL6TJXLE3REV6bvOtbeM00J+1qwd8dsuFpn4VZuEZJwtkrZpAApgT3IUvNmEbTd48JBbzqwO3nlj49XALezCO4QYXLz34M6aOxX6DGPnU1Bbstt4edREEQRLEvJN427d3p6zFVokEkIK82XGRkPXeueahJj4fPZY8h3lSp1lmgtVtZQPz/SE8R8k6WqdYkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(136003)(366004)(396003)(39830400003)(346002)(83380400001)(9686003)(26005)(316002)(38100700002)(5660300002)(6512007)(86362001)(38350700002)(6916009)(4326008)(7416002)(1076003)(54906003)(186003)(66556008)(66476007)(52116002)(44832011)(508600001)(8676002)(66946007)(6486002)(2906002)(33656002)(8936002)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hHHlMwmzSfGM1UZRi/Isxjml+gPngZS7yZUeCMJ/2o0hio+632v0D63CSAwG?=
 =?us-ascii?Q?GWe95CCtryYHTGAmca08j+eanbaUji/8U1WxutD14qpmS1s++erCt8cYmWol?=
 =?us-ascii?Q?0a7VmSY8AGwYVP73Sao9YgZKA74/N6OLRe0JIx+aoirZUEPgE1Xx9ahenvUA?=
 =?us-ascii?Q?m36vpVUAlgRwts6WEukwbVHUt7G7VRwB3cnf6Cv/6ujHj9RyIYLjcy/AVIN0?=
 =?us-ascii?Q?qfi4oGLNVzl7H3yYpD5BWJG7x+hZC4cWUfd7gtYevH4FE1InUqFhNX6DRPlC?=
 =?us-ascii?Q?SjmD33Rj4kH5RC6U9F5oN0vStCpD6Zk6EC6owQeEZP3cB7LAbXhdbxRy1rIR?=
 =?us-ascii?Q?XHPbnyj+5A1Ei7lZplP1LfVcKkQ96nPJpg98KfCZvGVhqY+64G/IYt2BTSNs?=
 =?us-ascii?Q?vVmUR03tI0nI1KSkwuP9VB+dnDG2ra+Vb/EA7tq7RTcrtz/aTCV3wZaczJWY?=
 =?us-ascii?Q?vaSF5q5jjl0PcyxpCH9wiYDnSADT29kW5smfelwug1ZNSv5etoaZDY7ZcFxu?=
 =?us-ascii?Q?01ad0+nR3z8z8ZTGZ5vpYFDnBy/4NNgasNjvnBnGpImWSl44/gt+xB3X1w9Y?=
 =?us-ascii?Q?cH7u4RtdJr3+2Mo96LVKb2Ucxu2PRWc9+//uwdZp5ZrJ4bKnqli7R5mtl6d9?=
 =?us-ascii?Q?Z7gIzn9M66u8x58lQTusFETWBVqDrm6y5212u5u5B2W2Dqsnku72ucJ6kSC9?=
 =?us-ascii?Q?dnEgLUdTsORtRXre05Y7uj4oMip4DluwJqNywv2S2GnPSwfgtSE4qs/OGiNJ?=
 =?us-ascii?Q?1Vj7v2BHJFSkp+XLFBdo5RLcHabM+7gMJHcZmNnSa+lqrTMQWkX/BykdrJDl?=
 =?us-ascii?Q?G7oODbqCYeP6dASnfx9gUfB6f8z/W07wH3IAODAAskv0Mz62YIJctVXUktGh?=
 =?us-ascii?Q?PoKkuQtCThZnf9JPaE4SG8y8uo4cR01Q6xG5Tt9YdziTt0YRG/6i05fh4WzB?=
 =?us-ascii?Q?pvFy5GLCvJT2bMPWSu4zXeuoMpqcL7/ooGN0VwF5yPNIgML0XFa6NUnL/z6j?=
 =?us-ascii?Q?xk2oT/DKeFhrjBqR1uN1bI8Hz+8b79MWzK4Cj0jGBK+9+m/3MaKs+O/c+Q/p?=
 =?us-ascii?Q?ahcXIvfIZ1iwa7fIuZAZUx1/f01aht8/g+gKi87kvinDLqBQKgtPzegeSiaI?=
 =?us-ascii?Q?lxAOfSUfIO4DXZIwtrtimchBxlytS8EVhLscoN5CN1MJJZLuaVd2pmb/MOr9?=
 =?us-ascii?Q?oKdjFSEHOun4sakgIlVOFxRiI9dVy3FFH4CI88fiC2R5CwAoawFuQeYJQjVA?=
 =?us-ascii?Q?u4SnQZnrejtPCbmn8HE9NEeQiTkOsqElYgLGu0mfFXmytaOc0HswvFAuzbb6?=
 =?us-ascii?Q?lJnu4znhA0OueDk9a+sFpL69qTXteYf36g0d5Zio8SchK0XLmeUs2jVYw1PV?=
 =?us-ascii?Q?1/C72N9bX9RqmBpCiLwx/pX912h1gUmOYUY7ilzl7scRxmcaQxsjUQWijT7/?=
 =?us-ascii?Q?gnDsaINe2xVwaWPAQGRD56uA2VQGae7mWFLZQooRE+g8PGAHz/x2S9ft+WvG?=
 =?us-ascii?Q?LhsHmNnsvyHLrHJCmcztlSXOv4KxhbixakL76KA1psJzQqEua/smxUykIOuV?=
 =?us-ascii?Q?Oc+tx+K6kZb7cZF4v7NqJfAboBbLnypJ+gdeQwe7Lb7ckq5rr+PAnX8IJrrT?=
 =?us-ascii?Q?6GSmVk43qQitOV3vEJJd6PWYZ3xLD286XcE5fJ3AUJRs96ZjdoK5AW8yLydR?=
 =?us-ascii?Q?9Z8o5ECYTiu/1Kkk78BDjHm+3Urp4R9TM7mELkC9fZjFtcU94ecPFR2ZWwJO?=
 =?us-ascii?Q?P9ShTBTIUeQR8beJvl0UCiClNBK7Rhgi02dMA4tCKYx2P8eUw3Cj?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ad3208f-f02d-4e77-dcbf-08da31de158e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 17:05:14.3499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k+Qg6DUl7zGuzrmlZY68RlTZMIjpY1OTRAKuEZuA5k2X3K0i5pT/2HCrxtDPRZ/4XtA0YHmZTJKb0T/QTmLkMpCVNiqHDV9g62BhccBiIEM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5573
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 10:56:39AM +0000, Vladimir Oltean wrote:
> On Sun, May 08, 2022 at 11:53:08AM -0700, Colin Foster wrote:
> > The ocelot_regfields struct is common between several different chips, some
> > of which can only be controlled externally. Export this structure so it
> > doesn't have to be duplicated in these other drivers.
> > 
> > Rename the structure as well, to follow the conventions of other shared
> > resources.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> 
> Doesn't the symbol need to be actually _exported_ (EXPORT_SYMBOL) to
> work when CONFIG_MSCC_OCELOT_SWITCH_LIB is a module?

Yes. I'll test the module configurations again before future rounds - I
admittedly haven't tested those cases in a while.

> 
> >  drivers/net/ethernet/mscc/ocelot_vsc7514.c | 60 +---------------------
> >  drivers/net/ethernet/mscc/vsc7514_regs.c   | 59 +++++++++++++++++++++
> >  include/soc/mscc/vsc7514_regs.h            |  2 +
> >  3 files changed, 62 insertions(+), 59 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> > index 68d205088665..a13fec7247d6 100644
> > --- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> > +++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> > @@ -38,64 +38,6 @@ static const u32 *ocelot_regmap[TARGET_MAX] = {
> >  	[DEV_GMII] = vsc7514_dev_gmii_regmap,
> >  };
> >  
> > -static const struct reg_field ocelot_regfields[REGFIELD_MAX] = {
> > -};
> > -
> >  static const struct ocelot_stat_layout ocelot_stats_layout[] = {
> >  	{ .name = "rx_octets", .offset = 0x00, },
> >  	{ .name = "rx_unicast", .offset = 0x01, },
> > @@ -231,7 +173,7 @@ static int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops)
> >  	ocelot->num_mact_rows = 1024;
> >  	ocelot->ops = ops;
> >  
> > -	ret = ocelot_regfields_init(ocelot, ocelot_regfields);
> > +	ret = ocelot_regfields_init(ocelot, vsc7514_regfields);
> >  	if (ret)
> >  		return ret;
> >  
> > diff --git a/drivers/net/ethernet/mscc/vsc7514_regs.c b/drivers/net/ethernet/mscc/vsc7514_regs.c
> > index c2af4eb8ca5d..847e64d11075 100644
> > --- a/drivers/net/ethernet/mscc/vsc7514_regs.c
> > +++ b/drivers/net/ethernet/mscc/vsc7514_regs.c
> > @@ -9,6 +9,65 @@
> >  #include <soc/mscc/vsc7514_regs.h>
> >  #include "ocelot.h"
> >  
> > +const struct reg_field vsc7514_regfields[REGFIELD_MAX] = {
> > +};
> > +
> >  const u32 vsc7514_ana_regmap[] = {
> >  	REG(ANA_ADVLEARN,				0x009000),
> >  	REG(ANA_VLANMASK,				0x009004),
> > diff --git a/include/soc/mscc/vsc7514_regs.h b/include/soc/mscc/vsc7514_regs.h
> > index ceee26c96959..9b40e7d00ec5 100644
> > --- a/include/soc/mscc/vsc7514_regs.h
> > +++ b/include/soc/mscc/vsc7514_regs.h
> > @@ -10,6 +10,8 @@
> >  
> >  #include <soc/mscc/ocelot_vcap.h>
> >  
> > +extern const struct reg_field vsc7514_regfields[REGFIELD_MAX];
> > +
> >  extern const u32 vsc7514_ana_regmap[];
> >  extern const u32 vsc7514_qs_regmap[];
> >  extern const u32 vsc7514_qsys_regmap[];
> > -- 
> > 2.25.1
> >
