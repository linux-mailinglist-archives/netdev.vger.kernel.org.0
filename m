Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 594666C8416
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbjCXR6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232403AbjCXR5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:57:39 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2106.outbound.protection.outlook.com [40.107.92.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E8F21973;
        Fri, 24 Mar 2023 10:57:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bZHZTibytJigRbqbH9wH3yim+9IkBCkLqs6PQdO4PxANwkbgNN/nUJkEXM+6ahXfcNHGdp02YP2FHMOfrDlQVg1o9uW3kn3Z76N6dxgl0ZVeOylMwLX4YqxTgsTcP+QJS8BORVIVgt7olzOihenOUdR0r7NEsgDgcYU9QRjYirk3tUQEWelB4J/l0/wrFBfQgtjioJRbKQDItoyOYuXWhKKUg8LIAeE504s7v+/SupKmXYcUMuy39BW1cfH2eY+cyidzl4Cqz4xnSGa+/BAhAabuZ3f2qQsw897BLg3Kd4KYn3g+xQmHAVQeN8IUbseVDLCvHjw+xxFjDfU/F5j2LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7AXP2MppPEKUOlSduauRHv9zaVGsKV9G9nUc9bEN67o=;
 b=L9PVeExKwrCnpkPhYqbyMwoVA7ckp94GBFO30/gd4+TiW461u2SFedo1dFdse2bThVs3UNTfWlsK/qRW9+kITGm3pbOnjMfTTx2gBzrKmS5TvQZw842dmUdHLUZDmjBQxFtAr4UOLfgBSmgViudNORX+aqyyEX+H6Xn2dg4/m/uqkDok93mgLewLR99nwtgTjzFS/gpWTcTkWrzDXQAucIAijWbXO0l9RMlwOnvvaLDmiTPRGR9TppeHX71uPj1GBwg8N3SXIvfYc5UdWNhWErwGYYvjXDg60OK0CNvu85jGgYp8iYOJ/84jOMf2SL5ygbSvhdJvcNGOnPNT36H1Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7AXP2MppPEKUOlSduauRHv9zaVGsKV9G9nUc9bEN67o=;
 b=FyQ6K7Mu7AU3fjdiMkkuNGrFfeljq6+aezw9m/HRVRuPumQ191eM2NYFf6R97RZ7Pqc7evHv9+z6BYUHB923Mo7WH0iQcIJd3FEYdY78mne5zCzZJZPDJq5GLSTCFc/H40f3OmNrh6oba1h2WnHCvibMtGhLSr1zbCg7XC0CNGg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4668.namprd10.prod.outlook.com
 (2603:10b6:806:117::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Fri, 24 Mar
 2023 17:56:10 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa%4]) with mapi id 15.20.6178.038; Fri, 24 Mar 2023
 17:56:10 +0000
Date:   Fri, 24 Mar 2023 10:56:05 -0700
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
Message-ID: <ZB3kNXpNm9DTRxHH@euler>
References: <20230324093644.464704-1-maxime.chevallier@bootlin.com>
 <20230324093644.464704-5-maxime.chevallier@bootlin.com>
 <c87cd0b0-9ea4-493d-819d-217334c299dd@lunn.ch>
 <20230324134817.50358271@pc-7.home>
 <ZB3GQpdd/AicB84K@euler>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZB3GQpdd/AicB84K@euler>
X-ClientProxiedBy: BY3PR05CA0042.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::17) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SA2PR10MB4668:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e14e692-ae55-470a-8a69-08db2c910cda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lt0HrkGQAWOUY8aye7o52xcnTiPj4qe020guZFY43paLL9GweoEQ4sNCirGORZgETRXbn3oceu496f37XSnQXCDRwgv6qGWy+kpqlrYfByQbvcdXkw75yp2LsATkfSzQdY6rmPLXMRlzFQvkvqVcc/YDMwAfYbiK4UrZlL55rOI8gIPxqG+NOx0NNgTpDsba6+dgox4QkbIZKbuh1uTgY3OctuSVcQmSmlT16AjkCd41QHz01Zj0JgnKlVcxBB+mQa1F4triBgon6BaL3en0RHQGF+1c7FaJgZzidSciMsprMczzHolCr31kMovuBYqTvlIVQRTYTCodtcVi0obe9LSIcQzjnpWKQVeGVHyJEwPKBk8TI8vGj9BQ3e0dEUA1F5XplzGPNfIFgoPRX6nl6aECc12QvZcpBxJ+aRnFdeQwCvmvsPGP0QL1fXEsrfl9KK/PjXZVzG81owBPHh+Z6WpqEvh0Y3qFBGhY0S1/0OGBhuMOi1F05sAna03RfrFOEOcHRKs06yimjjm7Yww6goTB8V2B5fhm13E4HB7YsR8zsgZ/4PuyUT1KAeE4xy1J9+PvL3FfNs8cLTsGGlr9WiVDCPA1s9IM0FEyuGYUpP7ZIl0l+PpMLyPsxqWu/U5WnXj03UBDSxc0gdrhrRkv3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(346002)(39830400003)(376002)(136003)(366004)(451199021)(9686003)(2906002)(316002)(6486002)(54906003)(6506007)(6512007)(38100700002)(26005)(83380400001)(186003)(6666004)(478600001)(66946007)(8676002)(66556008)(41300700001)(4326008)(86362001)(6916009)(66476007)(8936002)(7416002)(5660300002)(44832011)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SHgilcCdFTdApkcEjknWrBlH6bmE6hbooqCSUicUsRY6sIrB9HlaY4eStxf5?=
 =?us-ascii?Q?YcAw4aPRCnZYxg+xQ8GxIK0LAX4eUjHLs2G+KyWcLeX8zPmckuV7z/N91h6z?=
 =?us-ascii?Q?HjzplYP1knnOyuNmGIivYdmPXSeL/vhEocPUICnfdfkkTj2XWOVHkiDEg+US?=
 =?us-ascii?Q?RjpLCXVCF3Ru++2ysZI4aS0kForHMSszytV56Epyl7dtvPGGa4qyGogQQHjE?=
 =?us-ascii?Q?oECcF0ZsVMSdGRZIKA8zFVhmuzpVmBwYznHk2e4KBrthS0vC59ipxl8/SWVG?=
 =?us-ascii?Q?CY0OgAeEvx0jf9ObUkEzj30CxqqrUn1nwjVqF/8k22S6nES7KMhS6hu4XcYp?=
 =?us-ascii?Q?kAhbiZpc45rMVBCAiQYqQkNT3D3eP4NG/nemFKnO4JEpJlVn66mjLH0W4nhi?=
 =?us-ascii?Q?6yCGTYpacFQn/qq7mx0BOlldiRzdAStv2MCJ2XbcALLS2gsArfipj67fHMO7?=
 =?us-ascii?Q?O3hsgn9oyBnWK7/jd+uw5J2zvZt68cG7FLTMGouaTiKoddKW7wRDIicBlETW?=
 =?us-ascii?Q?Sy5lnXje1GrvddDJjoqQ0Mt7sCMTmmJ8RGZqNG4q3BFOS4dgYO2Ko1UuO+Z7?=
 =?us-ascii?Q?PZt3ICNtsm6c/2GIolDnysjozq68IrYD0yAYBZpF69XotrP/ipimz13I2ttx?=
 =?us-ascii?Q?UufuM0K2C5kZdOSWNHbj0+yJvGd3o3qjHhZbrjkkY+tCHoL2DmDqQsQJDjjP?=
 =?us-ascii?Q?lsk1dnpfnSs0U3BPUkGzKnYWrTwSuNwXD1yBCRnQLVxmohlWhTtc+kAcfKMW?=
 =?us-ascii?Q?i5Po/qfW8D7oU0Sgy1myLH8mF/l79bYZWwxhoCcqlGkdMoMu6FpZFQ5PCQiN?=
 =?us-ascii?Q?zHcuFyCZdNbn6hiwsdVj4CYf8nskPKFyRmWBfP5P5ndojFV37I/civRqa+EZ?=
 =?us-ascii?Q?wyzB27tq/wbs/VwdDa8gu5hWtc++YUkBwqs0x7IHhMbEpgEFyJdgRs0rAqk6?=
 =?us-ascii?Q?TImQMXo0ClPTqaXsm8A4mSupLCNpF1jvcTi609Chg+XhbqhaZZUMPJKBsZlX?=
 =?us-ascii?Q?LRGNUN+rpSd/sMucu7g4iHIEUSUWHMrdENktXfI1bPKGuiQeBGJKlg4RIJKe?=
 =?us-ascii?Q?DBGZ/NA9EudZAiF1ejtIcH8dWS7DwnqXsfGnTayk6ky+0EP4eC8fkzER9l+c?=
 =?us-ascii?Q?WfIbAYTD7ki5yeRRaAFGqhBGU/Dhp30kJtrztWIU+yulVUYmRxHJLdEkfrdM?=
 =?us-ascii?Q?eiJz9mBf1xS9VoseiLxKFDLwyHjcwaA9YehNDbr/OQM9nU8QZZrdNqsJmi8Z?=
 =?us-ascii?Q?Ycq3yLrdJnaHrbrGQO7FQWdbETsl7llygBPCRx82yWm1e3x+rpoGA4tHD9l+?=
 =?us-ascii?Q?ggnbZQuP8a9J1SgkkRHUj0XFDVEmFl2uqGpritvCRmqCzFI9b5ch8xCRJMOT?=
 =?us-ascii?Q?+/ZvAcZlTfFimNnE+qBGgd+9XBX7aDC2Lf4qyIxFgDyCM77DUwBY2bSvw3QV?=
 =?us-ascii?Q?meL+3mZ/FjjHlHx6WTchtaxkL9sorsbxL3l6X6tgQ3WQiz9Hpdhp4k4ISfHF?=
 =?us-ascii?Q?3AUhhOEizGyhdhK3HbhObGOrvLk2By81S6UhG5XIiFtrOHxnqCjEhWxjfkJQ?=
 =?us-ascii?Q?LVF+3NcT5tWLpGm3RqBF7589xLmSq6QsOpUZFx8hIgnrcOlRcxrjbE6uNssB?=
 =?us-ascii?Q?S+/c5ABJRWkoH8eNuMYpBrk=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e14e692-ae55-470a-8a69-08db2c910cda
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 17:56:10.3242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aT6dRlkfOHVyHxBG4jORyMQr+bf9ZUnOjzO9MvkUVOQEs9FvvDez/wB4nzlqgUi53f9OCVzaMum1VkS+ETKlMOPpstNzalgjFzBppo69Ng8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4668
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 24, 2023 at 08:48:18AM -0700, Colin Foster wrote:
> Hi Maxime,
> 
> On Fri, Mar 24, 2023 at 01:48:17PM +0100, Maxime Chevallier wrote:
> > Hello Andrew,
> > 
> > On Fri, 24 Mar 2023 13:11:07 +0100
> > Andrew Lunn <andrew@lunn.ch> wrote:
> > 
> > > >  	.reg_bits = 24,
> > > > -	.reg_stride = 4,
> > > > +	.reg_stride = 1,
> > > >  	.reg_shift = REGMAP_DOWNSHIFT(2),
> > > >  	.val_bits = 32,  
> > > 
> > > This does not look like a bisectable change? Or did it never work
> > > before?
> > 
> > Actually this works in all cases because of "regmap: check for alignment
> > on translated register addresses" in this series. Before this series,
> > I think using a stride of 1 would have worked too, as any 4-byte-aligned
> > accesses are also 1-byte aligned.
> > 
> > But that's also why I need review on this, my understanding is that
> > reg_stride is used just as a check for alignment, and I couldn't test
> > this ocelot-related patch on the real HW, so please take it with a
> > grain of salt :(
> 
> You're exactly right. reg_stride wasn't used anywhere in the
> ocelot-spi path before this patch series. When I build against patch 3
> ("regmap: allow upshifting register addresses before performing
> operations") ocelot-spi breaks.
> 
> [    3.207711] ocelot-soc spi0.0: error -EINVAL: Error initializing SPI bus
> 
> When I build against the whole series, or even just up to patch 4 ("mfd:
> ocelot-spi: Change the regmap stride to reflect the real one")
> functionality returns.
> 
> If you keep patch 4 and apply it before patch 2, everything should
> work.

I replied too soon, before looking more into patch 2.

Some context from that patch:

--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -2016,7 +2016,7 @@ int regmap_write(struct regmap *map, unsigned int reg, unsigned int val)
 {
        int ret;

-       if (!IS_ALIGNED(reg, map->reg_stride))
+       if (!IS_ALIGNED(regmap_reg_addr(map, reg), map->reg_stride))
                return -EINVAL;

        map->lock(map->lock_arg);


I don't know whether checking IS_ALIGNED before or after the shift is
the right thing to do. My initial intention was to perform the shift at
the last possible moment before calling into the read / write routines.
That way it wouldn't interfere with any underlying regcache mechanisms
(which aren't used by ocelot-spi)

But to me it seems like patch 2 changes this expected behavior, so the
two patches should be squashed.


... Thinking more about it ...


In ocelot-spi, at the driver layer, we're accessing two registers.
They'd be at address 0x71070000 and 0x71070004. The driver uses those
addresses, so there's a stride of 4. I can't access 0x71070001.

The fact that the translation from "address" to "bits that go out the
SPI bus" shifts out the last two bits and hacks off a couple of the MSBs
doesn't seem like it should affect the 'reg_stride'.


So maybe patches 2 and 4 should be dropped, and your patch 6
alterra_tse_main should use a reg_stride of 1? That has a subtle benefit
of not needing an additional operation or two from regmap_reg_addr().

Would that cause any issues? Hopefully there isn't something I'm
missing.


(Aside: I'm now curious how the compiler will optimize
regmap_reg_addr())


Colin
