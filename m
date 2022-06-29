Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D424560B27
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 22:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiF2UjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 16:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiF2UjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 16:39:17 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2130.outbound.protection.outlook.com [40.107.102.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2663C120AE;
        Wed, 29 Jun 2022 13:39:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SuPNaSvD74voRKtjnEpLuFWvdvyStAhv7XWnxYnuRubWRnt32O879dBcgVr/z/H4FzvdLuCrnc3v5T8dFcLZGDc05G2t6ScJYNVHUHnycdcOXLONaqsp3S1EWsf2vxw0uJkgj7loBMVWTwk67vyNoOplQJs2Nq3CMAMBQsOHQXYVRAsdpZ6JYPb2fxsOZQcaVc+JTMaR0rSBajB5sBVO9R3RARosXVMH63LKHaYv+M1iCGkXA0IbpqrfSfouatMpDxXsqWOecmlMIHSqjoyuL8PfpLFh2UgJDJR43aH15iLBHh1XMXKmc2Vu/xsydFytASzwuYIhI6lQpsVt2wuEZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ysXmbtCiJSSEXKjp/c5V2c+iCkldFqp7syxksekW4Pg=;
 b=NCgVpl4Vsz/6Aq3mLOMUoSOnTpC0girZmICVW9sOhlBJKPw0zWBgu60qRw5hyg1wbqC3noaNymaLyTjpPhaGuOO3BcL4ST98UfUIvba7A01Cvg3yLWeK3wLu5PvmJ7bDL3zxYc1X7XtMu7LwUrBgeGWtNiDOYLe7bt/T5O0WmudE9O2MMokVF84OiQmmxoo0fAfR2nunkvgoBXaAcmsbGyxlaD7Lrr+h+QKBT/3R4NGneIZffASrNiZiBJlcMHaK8hGJqigO+WEZKoZ1LJrxNXHf+GkQaXGOAXjgN3k7UhwWXBoe/C07F4DBMBabPVfIF+vV/NhqJrSoocVdiTDvqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ysXmbtCiJSSEXKjp/c5V2c+iCkldFqp7syxksekW4Pg=;
 b=GcvO7A+uBNkd/Oc3YBVzrNMpeXgS8fslD03L6vuTZQ3YiyWOjZ1j3YEoV4wccxzZAj+VWSVQOt/JO7N5iEAprHTvq/cPe85IlC1j8aZwj9EW/xQtMAcp2RdcbUCEE5A3hFJBmaZEFBExryKwKPtXQU451Syod5eModsCLChQl6w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM4PR10MB6253.namprd10.prod.outlook.com
 (2603:10b6:8:b7::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Wed, 29 Jun
 2022 20:39:13 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Wed, 29 Jun 2022
 20:39:13 +0000
Date:   Wed, 29 Jun 2022 13:39:05 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Arnd Bergmann <arnd@kernel.org>
Subject: Re: [PATCH v11 net-next 1/9] mfd: ocelot: add helper to get regmap
 from a resource
Message-ID: <20220629203905.GA932353@euler>
References: <20220628081709.829811-1-colin.foster@in-advantage.com>
 <20220628081709.829811-2-colin.foster@in-advantage.com>
 <20220628160809.marto7t6k24lneau@skbuf>
 <20220628172518.GA855398@euler>
 <20220628184659.sel4kfvrm2z6rwx6@skbuf>
 <20220628185638.dpm2w2rfc3xls7xd@skbuf>
 <CAHp75Ve-MF=MafvwYbFvW330-GhZM9VKKUWmSVxUQ4r_8U1mJQ@mail.gmail.com>
 <20220628195654.GE855398@euler>
 <20220629175305.4pugpbmf5ezeemx3@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629175305.4pugpbmf5ezeemx3@skbuf>
X-ClientProxiedBy: CO2PR04CA0181.namprd04.prod.outlook.com
 (2603:10b6:104:5::11) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e295bc15-464f-42f6-a981-08da5a0f6d37
X-MS-TrafficTypeDiagnostic: DM4PR10MB6253:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EMz34cFIjUXgtmn0CobKgooYPP/o0nKIZwXXiyx/gC+L+TUFs+Fdju4XlR7AvNpmpAp19nNBEtQNjougFCiJ5QK5Pu/vjIeHB77FzT9D0+MaRSywcte+CjOuqRttYo1exhezjc6PvaZLMD99DJLHi5qdU80PjdrLt4orN55slGpJ3vfSFfb1kE10IeyUmXlrq5zzBDtoCKxli8cpcwMMBOL9J3L9sNWFIZ/rSKHszt5fGdF0nSMG7sj1ywbtNZ1NWJSMJYmAXWpPPhUihjfE4VwUUXlrLs98Jt7YZiMeb5Uim4mqxq1cBPOgFJbi5QI1fjD8RmMK5PFA5NI/DLtjy7CWy5/OssTknhbaTbYjDhQqc1pV1t6gs9lXrK4bzXPfzmPW32826YElfXI5M9eYHErk2YrtbPSiMiBxS4JNTiUNr+b58KJWeW/tYxHGDbWsxLT2hH9UXcOMnQbJQdwn/tKlVQ52Q3j+snrNmlq//a9x5lmL4jLGflKTyV0m7lZR41VIqmprhlcnP3/B/fop4QsePM7i0OZifpRosKkHA9AWx58c9S5am82WBYbsXIZPmV8adVoLNK0+uLunygk9tWQmNb94aDm5lqfQQjo5a5hsMtAJ5Wo+PBZegj5NDHUSQe1vF5Zx6h/9PHc0/ZWcvSJPRtHORAt1WO6KKT/W0V1zsaCLDZL4C8LX0/x00tyd9+3DOG6+9sjS8mfGQu1D+QdPaaZ2kS3O29B+Rv2fP7D4RORbZgiVuJJzwesR0QLn/OsZQOj+dLarzm/DTgxhabUu3pfPrq0DB8vuGnslShj9qL1eyy8Jew7LPmQCrtAaDWe4Dehce6jB73qfgGY5ZlO2yRtq8DJR7m99oklHxK0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(346002)(39830400003)(396003)(366004)(136003)(376002)(6666004)(53546011)(26005)(41300700001)(6916009)(66556008)(6506007)(66946007)(186003)(54906003)(83380400001)(1076003)(966005)(38350700002)(6512007)(8676002)(9686003)(52116002)(316002)(6486002)(4326008)(33716001)(38100700002)(33656002)(8936002)(7416002)(2906002)(478600001)(86362001)(5660300002)(66476007)(44832011)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NdpJp1HetkAyVzT1e52HvHOq26Ni2kdBUZtw3A9tIvHfQ7xw223hNi8jmKHD?=
 =?us-ascii?Q?iosYGZEkoFTlLzPDP/S8oBUwxoDdg8Qok8aPYfU7qj+1t91iB0VuaFQCpAaW?=
 =?us-ascii?Q?hS+WEJ2Jf466eWhOThQYee3o3iIa6pTGJlWiiUswHmRe2rWYnE3+Q0g82h2J?=
 =?us-ascii?Q?lfBKMftEO6w4cDDpLZHHkfdpvuZbk0cLDdLA8FZVTMnepZc2wVPJb2Xj9zPb?=
 =?us-ascii?Q?3EstYyb5HqyjzWZJrvTuNJEuz7NWcqJLrFaWG5pYZAgvZS0edWQ4gXeVpwrI?=
 =?us-ascii?Q?v4PyxbcWjdqTwdxwMwuMNSsSiRGYgcv5kZDU/Q6aY60q+wB4nTYYoEtc79mS?=
 =?us-ascii?Q?WotPM9/jmkKpuoKqmi3XXuTpw3PlfAnvXG7E9cTxPTJoetBRaaGG2m2OGD7g?=
 =?us-ascii?Q?GU2hIKEJUPqIQRWbAZQRmz0nyVCPnD1yvt741uve3Vvco+mEcigsgAOGFA1i?=
 =?us-ascii?Q?d+VX0YUqUrHARzwb7/1TGTNY1KNS3CTQuLmbIIWznbC1HORe4VVHCRuJhJHN?=
 =?us-ascii?Q?uYHp5TOb3ot5+m1C2NswPbenYHQOMVzcvJAxOEphW6KZxB52lkZX7AzeLD3b?=
 =?us-ascii?Q?yZjjun66AjP9r7IRuAGyblJwvBn36LRglXKf6zRD6Ei2/h86T0t7gZqPU/f9?=
 =?us-ascii?Q?RV67hrebRRwpHcvejrIWOCsPU6sS6GTaob0mi4zk0gd10zk7823fZvCXpJLx?=
 =?us-ascii?Q?UIH246SEqFMRiY8JQ2p/8iD/frsLGZcEGRkDTiUwv/LxzSWA23WqKPhakHmB?=
 =?us-ascii?Q?oL9P7H/twI8mvFBgL1cCtfBz3VDkHDZv5dUR+PA+nyt0Cp+dTszlIAfF1S7k?=
 =?us-ascii?Q?Oz49gRgussvzHLz6E80ZwF/+uvXtP+nsINkvBmKNFx9XXTjQoV2/4pqSzdzC?=
 =?us-ascii?Q?iOEeZvokKqwG/PUzbMmVpu7CWN9rHPT3PJ7J2Sd2xNTL/lMPzU63EC0gz/qr?=
 =?us-ascii?Q?kB6QS2lgQIoi79txloQ1BiTqOT7DRb4hHzqBJCcsAktOjLJj1pjptsTjwzA1?=
 =?us-ascii?Q?ugQ2X0h/BFyWYsBu6hwYvIbPstb/RUb+3DBW9FRqeK0lgA4uTQZHBbtqWKfH?=
 =?us-ascii?Q?8NLOhoA+YPMKTfIntdXLpu7E9BCq63NYMyrkpMhr/pBXLkRSavS+ZzqPtfES?=
 =?us-ascii?Q?wSeyA1Y8eTe4qd00VX7SiJ8XrvLqWH46HSXLWpFkuScPNhuteRDK6tk7gTq/?=
 =?us-ascii?Q?i/HPqBigmLRzP306id9YlZbO4HL3RuY4xvEclhYqfGD7sVps+VUmBQw9uMko?=
 =?us-ascii?Q?O4CBxcfoubm78yl/mdW91fkZwsO4ktzuV9U50gBE/Ke0037NDNSKlx1QgPsD?=
 =?us-ascii?Q?nJqXOcCgy2QEzWacMTO/V9assqOCmxTeN/wUWlB3yZ+Q1Cy15ypUfcUXdjmU?=
 =?us-ascii?Q?nas2x2Yn5iT/E7lkA+ac3ICRI4AFCkR6frZoCluB6r88Zz0JGUML/CBaJqci?=
 =?us-ascii?Q?tUZl7+Wsgzx3VMEmK/OFCywBfQmtj7Y3NJ9unLm9rU+YnNt8W4Km+iYphUI3?=
 =?us-ascii?Q?KU+bohcfnLwiiFWVQBdsE/hq6HI3Vtx7B6MK+y1I4GikbRBD9S60Ykj6i659?=
 =?us-ascii?Q?GD8N6HqkaVgGOTnJVfgy9DfHQXdFbm6RilV7c1Eri5oNYfRO+7jjnuJ0Y82V?=
 =?us-ascii?Q?7w=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e295bc15-464f-42f6-a981-08da5a0f6d37
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 20:39:13.2844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IUqpxdLD7TbhTjbYmUwuw0SDNgkcZOaEKIjB7xpyP5Lw+zi/ptd2KwuBlgXgf28YbfJRytmtlhY5s+voc8ZVbXqCQ9+e3AEjvGhozvDQT3M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6253
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

Wow, thanks for the summary! This is jogging my memory.

On Wed, Jun 29, 2022 at 05:53:06PM +0000, Vladimir Oltean wrote:
> On Tue, Jun 28, 2022 at 12:56:54PM -0700, Colin Foster wrote:
> > On Tue, Jun 28, 2022 at 09:04:21PM +0200, Andy Shevchenko wrote:
> > > On Tue, Jun 28, 2022 at 8:56 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> > > >
> > > > On Tue, Jun 28, 2022 at 09:46:59PM +0300, Vladimir Oltean wrote:
> > > > > I searched for 5 minutes or so, and I noticed regmap_attach_dev() and
> > > > > dev_get_regmap(), maybe those could be of help?
> > > >
> > > > ah, I see I haven't really brought anything of value to the table,
> > > > dev_get_regmap() was discussed around v1 or so. I'll read the
> > > > discussions again in a couple of hours to remember what was wrong with
> > > > it such that you aren't using it anymore.
> > > 
> > > It would be nice if you can comment after here to clarify that.
> > > Because in another series (not related to this anyhow) somebody
> > > insisted to use dev_get_regmap().
> > 
> > To add some info: The main issue at that time was "how do I get a spi
> > regmap instead of an mmio regmap from the device". V1 was very early,
> > and was before I knew about the pinctrl / mdio drivers that were to
> > come, so that led to the existing MFD implementation.
> > 
> > I came across the IORESOURCE_REG, which seems to be created for exactly
> > this purpose. Seemingly I'm pretty unique though, since IORESOURCE_REG
> > doesn't get used much compared to IORESOURCE_MEM.
> > 
> > Though I'll revisit this again. The switch portion of this driver (no
> > longer included in this patch set) is actually quite different from the
> > rest of the MFD in how it allocates regmaps, and that might have been
> > a major contributor at the time. So maybe I dismissed it at the time,
> > but it actually makes sense for the MFD portion now.
> 
> I'm sorry, I can't actually understand what went wrong, I'll need some
> help from you, Colin.
> 
> So during your RFC v1 and then v1 proper (Nov. 19, 2021), you talked
> about dev_get_regmap(dev->parent, res->name) yourself and proposed a
> relatively simple interface where the mfd child drivers would just
> request a regmap by its name:
> https://patchwork.kernel.org/project/netdevbpf/patch/20211119224313.2803941-4-colin.foster@in-advantage.com/
> 
> In fact you implemented just this (Dec. 6, 2021):
> https://patchwork.kernel.org/project/netdevbpf/patch/20211203211611.946658-1-colin.foster@in-advantage.com/#24637477
> it's just that the pattern went something like:
> 
> @@ -1368,7 +1369,11 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
>  	regmap_config.max_register = OCELOT_GPIO_SD_MAP * info->stride + 15 * 4;
> 
> -	info->map = devm_regmap_init_mmio(dev, base, &regmap_config);
> +	if (device_is_mfd(pdev))
> +		info->map = dev_get_regmap(dev->parent, "GCB");
> +	else
> +		info->map = devm_regmap_init_mmio(dev, base, &regmap_config);
> 
> where Lee Jones (rightfully) commented asking why can't you just first
> check whether dev->parent has any GCB regmap to give you, and only then
> resort to call devm_regmap_init_mmio? A small comment with a small
> and pretty actionable change to be made.
> 
> 
> As best as I can tell, RFC v5 (Dec. 18, 2021) is the first version after
> v1 where you came back with proposed mfd patches:
> https://patchwork.kernel.org/project/netdevbpf/patch/20211218214954.109755-2-colin.foster@in-advantage.com/
> 
> And while dev_get_regmap() was technically still there, its usage
> pattern changed radically. It was now just used as a sort of
> optimization in ocelot_mfd_regmap_init() to not create twice a regmap
> that already existed.
> What you introduced in RFC v5 instead was this "interface for MFD
> children to get regmaps":
> https://patchwork.kernel.org/project/netdevbpf/patch/20211218214954.109755-3-colin.foster@in-advantage.com/
> 
> to which Lee replied that "This is almost certainly not the right way to
> do whatever it is you're trying to do!"
> 
> And rightfully so. What happened to dev_get_regmap() as the "interface
> for MFD children to get regmaps" I wonder?
> dev_get_regmap() just wants a name, not a full blown resource.
> When you're a mfd child, you don't have a full resource, you just know
> the name of the regmap you want to use. Only the top dog needs to have
> access to the resources. And DSA as a MFD child is not top dog.
> So of course I expect it to change. Otherwise said, what is currently
> done in felix_init_structs() needs to be more or less replicated in its
> entirety in drivers/mfd/ocelot-core.c.
> All the regmaps of the switch SoC, created at mfd parent probe time, not
> on demand, and attached via devres to the mfd parent device, so that
> children can get them via dev_get_regmap.
> 

I think you're pointing out exactly where I went wrong. And I think it
might be related to my starting with the felix dsa driver before
migrating to the MFD setup.

My misconception was "the felix dsa driver should be able to create whatever
regmaps from resources it needs" and maybe I was being to optimistic
that I wouldn't need to change felix dsa's implementation. Or naive.

> Next thing would be to modify the felix DSA driver so that it only
> attempts to create regmaps if it can do so (if it has the resource
> structures). If it doesn't have the resource structures, it calls
> dev_get_regmap(ocelot->dev->parent, target->name) and tries to get the
> regmaps that way. If that fails => so sad, too bad, fail to probe, bye.
> 
> The point is that the ocelot-ext driver you're trying to introduce
> should have no resources in struct resource *target_io_res, *port_io_res,
> *imdio_res, etc. I really don't know why you're so fixated on this
> "regmap from resource" thing when the resource shouldn't even be of
> concern to the driver when used as a mfd child.
> 
> The contract is _not_ "here's the resource, give me the regmap".
> The contract is "I want the regmap named XXX". And in order to fulfill
> that contract, a mfd child driver should _not_ call a symbol exported by
> the ocelot parent driver directly (for the builtin vs module dependency
> reasons you've mentioned yourself), but get the regmap from the list of
> regmaps managed by devres using devm_regmap_init().
> 
> Yes, there would need to exist a split between the target strings and
> their start and end offsets, because the ocelot-ext driver would still
> call dev_get_regmap() by the name. But that's a fairly minor rework, and
> by the way, it turns out that the introduction of felix->info->init_regmap()
> was indeed not the right thing to do, so you'll need to change that again.
> 
> I am really not sure what went with the plan above. You said a while ago
> that you don't like the fact that regmaps exist in the parent
> independently of the drivers that use them and continue to do so even
> after the children unbind, and that feels "wrong". Yes, because?

I liked the idea of the MFD being "code complete" so if future regmaps
were needed for the felix dsa driver came about, it wouldn't require
changes to the "parent." But I think that was a bad goal - especially
since MFD requires all the resources anyway.

Also at the time, I was trying a hybrid "create it if it doesn't exist,
return it if was already created" approach. I backed that out after an
RFC.

Focusing only on the non-felix drivers: it seems trivial for the parent
to create _all_ the possible child regmaps, register them to the parent
via by way of regmap_attach_dev().

At that point, changing things like drivers/pinctrl/pinctrl-ocelot.c to
initalize like (untested, and apologies for indentation):

regs = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
if (IS_ERR(regs)) {
    map = dev_get_regmap(dev->parent, name);
} else {
    map = devm_regmap_init_mmio(dev, regs, config);
}

In that case, "name" would either be hard-coded to match what is in
drivers/mfd/ocelot-core.c. The other option is to fall back to
platform_get_resource(pdev, IORESOURCE_REG, 0), and pass in
resource->name. I'll be able to deal with that when I try it. (hopefully
this evening)

This seems to be a solid design that I missed! As you mention, it'll
require changes to felix dsa... but not as much as I had feared. And I
think it solves all my fears about modules to boot. This seems too good
to be true - but maybe I was too deep and needed to take this step back.
