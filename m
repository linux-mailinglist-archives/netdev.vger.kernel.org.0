Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15DF65ED0AA
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 01:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbiI0XCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 19:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231965AbiI0XCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 19:02:02 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2099.outbound.protection.outlook.com [40.107.220.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15CE160D5;
        Tue, 27 Sep 2022 16:02:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WExuBqJ7dF4xuA7RBKapbOmnM/6p0SqkyEX1tpHV2LLXs1Q6W4udNUz6J4sCeDoy9zm6UMH3XT+RM1mu6EVtiitCKc5G0ROKMZbaIqsTsggWjo0GR5dUdNigbiW0JAM48+gWpru1K1L6fFe8sTgc+PfHHp54lhVTsBdvH4aTDnT1MUYOJq6T010ha0rowCFnq5zUJ8qSfSAVPI5VBLQrRKmG4YroDgb0ru1aeIWPhlJ3fIcapkS19SP4tt1/T2I16md1TKG7iTEpNPrZAJh0/aYihSzRMTYsAxD0szEIczaIAwXQGsOd/Bxp835MjKW6aIb+WvUTJ7okxov8DtzW6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sQBvWDPleDMQr/XOGSA59C7H9WzrlpNADlmMEBGPQtA=;
 b=erZJCyZJCznd9RK+MunjfEjkCEd5RBspHpfBsaxSxP26Uxhv9ULcK6rkTYbyjCx3u0DTfjByyO7Ne9Ovkwg/pNf/M2o5PAhkOI4J6f6rsxUuSIEazib3+nS3VPTdYy/2L2AP/z1WnfTR8hIIKbs9uVJw6jgHk+Byo3dDvA4Q3idFMlqIR81Ru2LSvQjt3PuUyRKxg8mazUxTj5SSMXlIra6Hl93PPhAPts2iLyKztyUXCi8F5byvM9uheh7yvk49Qv9amoaRgutvx8MQcyT3aHqGHFNbB3DDa0k/9HaUG7zkH9eVBxWKGgwO9/hhUBHAA1PN0OggZNchHV7hlbbLvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sQBvWDPleDMQr/XOGSA59C7H9WzrlpNADlmMEBGPQtA=;
 b=SJX8M+xhYyu3W4CNOL3zy8ZZyLsUUSuyf9YV15g4zJqfj7Blyryaasnnwj2gyxxKd6f5gDmlnCSu9UcJUrVOKXpmJn0zFQxwHYZQbFXCtHW/As5UHLEyzJhwITSaDyye7Qx2LVSIUonRiZfGULeS28egXPvxiPOYYQO/Vy79/N0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH0PR10MB5657.namprd10.prod.outlook.com
 (2603:10b6:510:fc::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Tue, 27 Sep
 2022 23:01:57 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69%4]) with mapi id 15.20.5654.026; Tue, 27 Sep 2022
 23:01:55 +0000
Date:   Tue, 27 Sep 2022 16:01:51 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <olteanv@gmail.com>
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
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3 net-next 11/14] mfd: ocelot: add regmaps for ocelot_ext
Message-ID: <YzOA35MxZ6S6E6qe@colin-ia-desktop>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
 <20220926002928.2744638-12-colin.foster@in-advantage.com>
 <20220927210411.6oc3aphlyp4imgsq@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927210411.6oc3aphlyp4imgsq@skbuf>
X-ClientProxiedBy: SJ0PR05CA0086.namprd05.prod.outlook.com
 (2603:10b6:a03:332::31) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|PH0PR10MB5657:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c06d40f-ee39-40fe-b0a1-08daa0dc45f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uo1vFX4RUxojFf63pkhkS2v9IejbY+PgL8+ZW5BRuIG65B/7H7vWsVT5+XN4sFiXHL/tBAiKGslkXG34j7L8Nh6cN332X/orf/h/2UwjOt41ogou7gu7Lp8xbJm+hOZ+myOzL8sL2U4Ym8q/qc220MqMSIheo74En7qLEAeBcVjH+FFxQ//F/us/7033YnbjVvemJklVR8yHegkbEB7wdKLdsuO9SCt0RJdqPnoFMyvLZK+fDLYcKyhr4zWudJlcUNpc5Gne541jG5nPwayQTxzJwQ+0DdjdgFMSIzNSAJSraVkud93WRIU1ohEdsGD1WYuZ42qfOyTdXRCF8Dg0bBcJ2AWeSp4dysyTnQuzIdfMx/AHwgsn3e73M7JgDfA82bVa7W4FztoQbzCkHc8CQmkxMJLMgPIgiGfBH5A9nhJRzMnI8GszN05NARoTkfjPfec9KqZDI2g6CGuDGUPxWjXiXQ45YBwUHjQPVp1mBwqWlxlsR301HaGDleb8pENn4ve7nZnOnSB+JDsoFEJrT8rzr3PyRiLA4LaQBfOMAXERDf2Aoq1yilcvuQ8/98BngT0AEAN+UaRzichtcekcTPFVObTt2YrIzMdZTdWmUYpJdSuf3B3Z+vBx3r4lfR2g5GYZMiCEgyN3V52Ua22NMoXwNrYhZgx9r7BQd1dUhDPMH9sDcBI94wizUwnEPNseAT9FBzjWIzQv7R9tudnxwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(39830400003)(366004)(376002)(136003)(346002)(451199015)(6486002)(478600001)(7416002)(44832011)(6666004)(5660300002)(9686003)(6512007)(26005)(86362001)(8936002)(316002)(33716001)(6506007)(6916009)(186003)(54906003)(66476007)(66946007)(4326008)(38100700002)(66556008)(41300700001)(2906002)(8676002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zXer53tKHjzkkEFZ/IOHjKOvyL40T0K8XiC91uXZ8kACiROXd4Ce1bFVp4iv?=
 =?us-ascii?Q?gAy5ASsdJzl5NxegdZmYci/eG6DQymo0MNtdrq63AfChXeZOCUt4wMupx+fk?=
 =?us-ascii?Q?YtxOZGuoyNc9Tv9TYVcBWURzNM06b9dI40oiRna0HTIRzNV1McAsiEkRFCJ7?=
 =?us-ascii?Q?WoptDZlKpP2s1Zc8kMgeQIWwf4kFptj0hQyq+Nzcg6knCgnOA+lxUOoaShyS?=
 =?us-ascii?Q?zzYhIBOcY3up1mhI/e2Mw7RYwy1Lwu5m8tLJdsw4+M0A8xd5kWVREhEf65zD?=
 =?us-ascii?Q?6BQ+dKCXAMFrYTLWjg/IEP0M+tTtMnpEmX6enKOyvLGoiZpfx++ar8HWRwl9?=
 =?us-ascii?Q?2fNAScUP7L8x7Gk1MiXp403mJD8c2qAV2dzWrZwwqduk4yORzReQ1tpvNMVx?=
 =?us-ascii?Q?c1EKQL9GnIwpQs9WHN6NIe+U+jeGbovVl1ba8c8RLu8tkcG+2HBBT9ufSj13?=
 =?us-ascii?Q?NoP6MlzXpqKJ9mvdFW2RXJn4tPU2pIKGH4H9TtwDhQ9DH1rJBQN6cU7SXMfZ?=
 =?us-ascii?Q?/uMOM9fBy88M1ePar4UVwxmB2xypHtVq5UVBXda0IWTj+OgdVhIS1nLD0Taj?=
 =?us-ascii?Q?w9UW5uTi5dXK4AvlebkWZiZTJrKnAYTCwyXIssuDDnT3pOhy5hJfAwsTh1bx?=
 =?us-ascii?Q?BvBd4/qFIePUhOFiuXli/5qAScHt0VZt6Gpj35kE2Z6cX3HOWJhicVJNBBvj?=
 =?us-ascii?Q?yO8jY8FygdCpoNO6BJG0yIwV/0yqzzBdAXbOfpfpEkgI4Y0cOKDsO7QtxKsf?=
 =?us-ascii?Q?ayeNewB3Zhkeq3oy8+Rz0jlcwO+CmzhrBq2JcsMRlGqMJMUA+iRq+o7dbfRb?=
 =?us-ascii?Q?koJ3nERLog6sY2yqt0z2and9G6+2X4PlZxUFc+Ae3fcbN6nauBzcFhtwRNP8?=
 =?us-ascii?Q?S2/FUjbExIQZIWq2TRDsk8YOqjQbOMaZRgTG/e0cNnVkBchZZipwslZOnog9?=
 =?us-ascii?Q?QgB8CizZWMnab2klSwtqexfIloGDA5vHNlgMAPS6172JeYTqGEf9cYlO5jWe?=
 =?us-ascii?Q?LK/SAjniPWBgd2Xm5PYTlHPFtMnYsE4r80n1YZtfM4s5j8irpkAkB+wsi1Xu?=
 =?us-ascii?Q?N6XPtgCE2f+p113EeGBVOlP92E25c6MIMYka9cBITvyLHIlOaNRbRD+BnieY?=
 =?us-ascii?Q?meXcjbPMk1sLKobagU3I/vpdBs9WZI++rFBhvprYI6ZRdUtRNH9H7Mo4o2wn?=
 =?us-ascii?Q?ggOmeStlKj8mhF2RYDBYAP/TcfuvQgiufMId8roJzaEUbebJg21NYEJJS+SB?=
 =?us-ascii?Q?ZiDyU2cr77QNdPlPihHgwE21uLa++jg9yonqyh8odc35wsWvN6C/iAP5UsRI?=
 =?us-ascii?Q?UVWr+LaHlbRhkU2C0HyuixXLIU99v2RJMUKjeqvW+5xkEnmp4hSc38EE74+P?=
 =?us-ascii?Q?YpysGWKni+9+oA20TI7mswmshOxR/9Ry75+Pb6C6DPkvP4E6BnMUpxVFNzvk?=
 =?us-ascii?Q?raJ9azOFTbi+BWMAcwUNjqHKWhpDejwGk2jQj2f2Uv7+RXUG2KliW5Q/iIXo?=
 =?us-ascii?Q?2qi75g7yfbGfxFxGoprpT0nhNQ/gfJw+5lliDKiZk+jMyGFmg0SMaWWqaLe3?=
 =?us-ascii?Q?Ly4FLLctbLLnuHoqH596jeP0fyW3PZaH/nmr/bExUF+J7OUPnT0cagQW4I7a?=
 =?us-ascii?Q?IjqbuuYP7zq/E2otpwaqcSc=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c06d40f-ee39-40fe-b0a1-08daa0dc45f2
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 23:01:55.8440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TSsAqPQKCAsJUwbZqlRLydI1LDi+ZBAyRB0xIXm7YmhI9aC7NVf11B57oxEmnaxioNhzTRu1FLdEeSqx4yXlkj/FmGfYwEXLRPt1e/tvKOI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5657
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 12:04:11AM +0300, Vladimir Oltean wrote:
> On Sun, Sep 25, 2022 at 05:29:25PM -0700, Colin Foster wrote:
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
> > v3
> >     * No change
> > 
> > v2
> >     * Alignment of variables broken out to a separate patch
> >     * Structs now correctly use EXPORT_SYMBOL*
> >     * Logic moved and comments added to clear up conditionals around
> >       vsc7512_target_io_res[i].start
> > 
> > v1 from previous RFC:
> >     * New patch
> > 
> > ---
> >  drivers/mfd/ocelot-core.c  | 87 ++++++++++++++++++++++++++++++++++++++
> >  include/linux/mfd/ocelot.h |  5 +++
> >  2 files changed, 92 insertions(+)
> > 
> > diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
> > index 013e83173062..702555fbdcc5 100644
> > --- a/drivers/mfd/ocelot-core.c
> > +++ b/drivers/mfd/ocelot-core.c
> > @@ -45,6 +45,45 @@
> >  #define VSC7512_SIO_CTRL_RES_START	0x710700f8
> >  #define VSC7512_SIO_CTRL_RES_SIZE	0x00000100
> >  
> > +#define VSC7512_HSIO_RES_START		0x710d0000
> > +#define VSC7512_HSIO_RES_SIZE		0x00000128
> 
> I don't think you should give the HSIO resource to the switching driver.
> In drivers/net/ethernet/mscc/ocelot_vsc7514.c, there is this comment:
> 
> static void ocelot_pll5_init(struct ocelot *ocelot)
> {
> 	/* Configure PLL5. This will need a proper CCF driver
> 	 * The values are coming from the VTSS API for Ocelot
> 	 */
> 
> I believe CCF stands for Common Clock Framework.

It does stand for common clock framework. And this function / comment
keeps me up at night.

Agreed that the HSIO resource isn't currently used, and should be
dropped from this set. The resource will be brought back in as soon as I
add in phy-ocelot-serdes support during the third and final (?) patch
set of adding 7512 copper ethernet support.

My fear is that the lines:

if (ocelot->targets[HSIO])
    ocelot_pll5_init(ocelot);

won't fly inside felix_setup(), and I'm not sure how far that scope will
creep. Maybe it is easier than I suspect.


But I'm getting ahead of myself. I'll remove this for now.

> 
> > +
> > +#define VSC7512_ANA_RES_START		0x71880000
> > +#define VSC7512_ANA_RES_SIZE		0x00010000
> > +
> > +#define VSC7512_QS_RES_START		0x71080000
> > +#define VSC7512_QS_RES_SIZE		0x00000100
> > +
> > +#define VSC7512_QSYS_RES_START		0x71800000
> > +#define VSC7512_QSYS_RES_SIZE		0x00200000
> > +
> > +#define VSC7512_REW_RES_START		0x71030000
> > +#define VSC7512_REW_RES_SIZE		0x00010000
> > +
> > +#define VSC7512_SYS_RES_START		0x71010000
> > +#define VSC7512_SYS_RES_SIZE		0x00010000
> > +
> > +#define VSC7512_S0_RES_START		0x71040000
> > +#define VSC7512_S1_RES_START		0x71050000
> > +#define VSC7512_S2_RES_START		0x71060000
> > +#define VSC7512_S_RES_SIZE		0x00000400
> 
> VCAP_RES_SIZE?

I'll change this name to VCAP_RES_SIZE.

> 
> > +
> > +#define VSC7512_GCB_RES_START		0x71070000
> > +#define VSC7512_GCB_RES_SIZE		0x0000022c
> 
> Again, I don't think devcpu_gcb should be given to a switching-only
> driver. There's nothing switching-related about it.

Yes, this is no longer necessary and I missed this. I think you caught
them all, but I'll do another sweep just in case.

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
> > +EXPORT_SYMBOL_NS(vsc7512_target_io_res, MFD_OCELOT);
> > +
> > +const struct resource vsc7512_port_io_res[] = {
> 
> I hope you will merge these 2 arrays now.

Yep. And with that I should be able to add them via the standard
.num_resources, .resources method all the other drivers use. As
mentioned, without the GCB and HSIO entries.

> >  int ocelot_core_init(struct device *dev)
> >  {
> > +	const struct resource *port_res;
> >  	int i, ndevs;
> >  
> >  	ndevs = ARRAY_SIZE(vsc7512_devs);
> > @@ -151,6 +221,23 @@ int ocelot_core_init(struct device *dev)
> >  	for (i = 0; i < ndevs; i++)
> >  		ocelot_core_try_add_regmaps(dev, &vsc7512_devs[i]);
> >  
> > +	/*
> > +	 * Both the target_io_res and the port_io_res structs need to be referenced directly by
> > +	 * the ocelot_ext driver, so they can't be attached to the dev directly and referenced by
> > +	 * offset like the rest of the drivers. Instead, create these regmaps always and allow any
> > +	 * children look these up by name.
> > +	 */
> > +	for (i = 0; i < TARGET_MAX; i++)
> > +		/*
> > +		 * The target_io_res array is sparsely populated. Use .start as an indication that
> > +		 * the entry isn't defined
> > +		 */
> > +		if (vsc7512_target_io_res[i].start)
> > +			ocelot_core_try_add_regmap(dev, &vsc7512_target_io_res[i]);
> > +
> > +	for (port_res = vsc7512_port_io_res; port_res->start; port_res++)
> > +		ocelot_core_try_add_regmap(dev, port_res);
> > +
> 
> Will need to be updated.

Yep. I think it can all go away for the above
ocelot_core_try_add_regmaps() call now.

> 
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
> 
> Is this the problematic include that makes it necessary to have the
> pinctrl hack? Can we drop the #undef REG now?

Yes, this include was specifically for TARGET_MAX below. That undef REG
should not be necessary anymore. I'll drop it.

> 
> >  struct resource;
> >  
> > +extern const struct resource vsc7512_target_io_res[TARGET_MAX];
> > +extern const struct resource vsc7512_port_io_res[];
> > +
> 
> Will need to be removed.

Gladly :-)

> 
> >  static inline struct regmap *
> >  ocelot_regmap_from_resource_optional(struct platform_device *pdev,
> >  				     unsigned int index,
> > -- 
> > 2.25.1
> > 
