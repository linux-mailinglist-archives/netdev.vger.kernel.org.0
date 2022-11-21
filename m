Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA3F632BC8
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 19:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbiKUSNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 13:13:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiKUSNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 13:13:07 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2109.outbound.protection.outlook.com [40.107.94.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8B22791B;
        Mon, 21 Nov 2022 10:13:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YFgJv8dIsDU481e+rfrWx8uBscytuFrkFeYUv8w0yDqPP28L7Mwr9igjsioYZJ5Igiv86DzADcqvncSlcGz5/C/dRkRmL2MqyysZiLoBZIEvb103vfMdZG0TVDsRUloueg4Gju1KmIkBpaWwQhrVjC/1cbHbC9PBdNCEq81v2nokfvEsgHNh6NU0aRZoJt1J7GGOisvPTUH9Ppjlh+AxvcdXiW5hvZERfbPsnJSPnhtE7eCEjphTWQjnD7Emko76PnD7RK4eUg9Wx54Lonb6qvtVzunmADDN1BfnkDQ1Z/ExaguplnDNWoMuBZzcFZowAHiJSkjZEO8VpMczbRY0lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=soa/Sf0il9nwFEC9ekU1+76DY3AiJn/afIMv+otCwB8=;
 b=YD3nYHj6P9/QhEmVDPwplHIw3MeXrnLdef+arwbbqXUgPFVAHngLh8joxWrZtosWlzV9HuFAvAI0Hzi6uaWzZTGr67S5qM8MYP0hcnKKplnI+9n9vUi7+3GIkxBZHBzfXpn42UWMSC7B96bPX0O+7XC/sBn01HHrOG5fzeUzZ5tIMP1WzK4gpXpFxVvSfg9agz96kS/geMzUOfAe3NhPLLajYw0VKgnE9IOhDuSvZ2p8TP0DYwI6g/qsRzHFK+ttQH6vSW/G8UEuO1M/74bvvAJnfrSqy2hHam3Wb408AtCR6I/aV1+TLynyNToXxdYZl8+c6FHkgrJU4IWM1A7suA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=soa/Sf0il9nwFEC9ekU1+76DY3AiJn/afIMv+otCwB8=;
 b=OctgRJykrmzmXJnLphXn9JSSEm2gDCh3t2HA2xUnm0/Sds/j2cBy/xPOsA2ztjDToS4Fzmx02esDZxhr8gd7ERRbOJBIdQ4HmF9DfdSMDOgl/6P3JyCdCpaHoElWoZmyv4dCA6mKM8EyTxeWfXpOFZq4pLYSP2hQpKNZr5CZiFE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DS0PR10MB6895.namprd10.prod.outlook.com
 (2603:10b6:8:134::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Mon, 21 Nov
 2022 18:13:03 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 18:13:03 +0000
Date:   Mon, 21 Nov 2022 10:12:59 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Alexander Lobakin <alobakin@pm.me>, linux-kbuild@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Jens Axboe <axboe@kernel.dk>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Derek Chickles <dchickles@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Daniel Scally <djrscally@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/18] dsa: ocelot: fix mixed module-builtin object
Message-ID: <Y3u/qwvLED4nE/jR@colin-ia-desktop>
References: <20221119225650.1044591-1-alobakin@pm.me>
 <20221119225650.1044591-15-alobakin@pm.me>
 <20221121175504.qwuoyditr4xl6oew@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121175504.qwuoyditr4xl6oew@skbuf>
X-ClientProxiedBy: MW3PR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:303:2b::15) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|DS0PR10MB6895:EE_
X-MS-Office365-Filtering-Correlation-Id: ed0d3e0d-1d92-4423-f3ab-08dacbec0805
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yNR+xsWCb8dUy44PxKlTgrHEa+RpbG/mwV1D3MOhrcbTx9x0OLyc9OtR3OIIFFigbabbhXPqEImSjJEVbn6Kwq+RsUUOuhKA/DHFQHQWiQNgawvb+T7iYNnWyGja6djszMJNa4WIlNjMv/9NMb+j4Oh58T9wQ8n6JSqh0+ii5k5y7WGRwJf6nLVkGAG1xo884K+UVjVR7PHljGJHsQBVbYFsb+LVaPHFZHSkItQESm6My+N3UObWqY+QdTnn52Y4nStRgRDY5oNmVgbS1bDsVXOZBuTMh0PC2MIkLolGXl8tXmCGzHYvIvfv2ICXzUw8EqVmhIsaC9sErcthg0egsFEwh2LGH3djnAbT8KNKFbDuAOVZRFFbjiExgVnb054OlRHCpZDlcukAbi+AjtFwNT69dfVzgETw21BgneZMZe6F+xCy23sCQ7FwE1SSXW13xPGhybnvPmwa7wcI9+aQTg45/GTjyP6JgExzoNjiyKL3t5rLlhUImIioDfEHX6QTgx2gYPvFmV5GlHsox5SkPVQIpIHlKqgPVyrMMU97nvuGe0tPMKmV4qFLehHuRIQcmr7DX012bA9/nPB07l2G56JWs+zuy98FLwhPhvXGWCRUNqcZKs3zx3kvYOwzNTjjydeCIdtZ7rzQzBZDBoR+cQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(346002)(39830400003)(396003)(376002)(136003)(451199015)(54906003)(66556008)(86362001)(66476007)(66946007)(8676002)(6916009)(316002)(186003)(4326008)(33716001)(6486002)(6666004)(478600001)(6512007)(26005)(9686003)(41300700001)(5660300002)(7416002)(38100700002)(2906002)(8936002)(6506007)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yry+3HQGfJ3a4Pvi2NbzaMIeqUXEGGtplNWZMbAzojz2VTncsKRZkumAm1Sr?=
 =?us-ascii?Q?t2DL0O+L64Bti0GydDsOIsfxwLObz9P8W9P5QVLbWglLZUGlZaGgR9zFwq4Q?=
 =?us-ascii?Q?q2uXqI+ZddfaHoxbT2jf+Q+2ASFZMCvkcluhKo9vGkLVNEl9VkwVh7Wq5I7i?=
 =?us-ascii?Q?ocTMGDuTyHbgSBG6kL8fN9658DpfSHAouxLneYAgXt2qqhjHPHVuubS2FF1h?=
 =?us-ascii?Q?y2hnSSrCQ4Pc9qlgqhyvmOGuC5Olbm34fwVQcRxoR3XzD2NoOa9jH6R4JTm0?=
 =?us-ascii?Q?4/Y99Kmm6fjVB1i4vRy+UlwvXQIgpUJuFrmW4pTX1+unLtEjBvHPsp6l0bUV?=
 =?us-ascii?Q?JKMXGsCy45xwtDuw4z2gDnAkhS8/YbK5QEEp8VJQkyDJhsm/xkEwGrVIBu5b?=
 =?us-ascii?Q?TbvvR0U4MBUK0wWyTqpMC0LF4NNYMrsNe0pkCrOYhSHVphYsi5n4uIk23O8p?=
 =?us-ascii?Q?GrCs85DNVKmIbOpt7LuA8yCXShR9BC47I5H77r4aiIWwsbqdnr2C5np8Zx5L?=
 =?us-ascii?Q?HTiaNEUvdLYqPgPjqECvgrPeJddqOTC88Bym6NcSVzMkasOfd1sHC87LFs1q?=
 =?us-ascii?Q?hTq+2YWKRERksAIoQcQrl9J1VuQxlbr43sVny7h2x4NxX4LHe53Yu+HyTAWt?=
 =?us-ascii?Q?8Mo7OLKJSHtdLstZh5ja7s/5OqFUEjK7tV9D0XtLuFbRbL2oSGdVryDmln9x?=
 =?us-ascii?Q?yEHAMF+CQW6Eevomi22hOTduWfB9M04uZDiD+6boQNj7eFfTQvgq7+rIGAca?=
 =?us-ascii?Q?dTUfrOB0442ve10nPIG3BtnibAppK8FpXw33d8p06eh3mA7yCDRFrgCP1REe?=
 =?us-ascii?Q?HepmqmO2DeyPrCt4zalQWiOD8XWOEG6VjoktJNMMb+ws5EHq/zXHvjqa6gCZ?=
 =?us-ascii?Q?cRslRt1moo2m613TBHB4fGlR+R+OkbvO5sBHDcZ1MebFQEs+GULUc9xleR6/?=
 =?us-ascii?Q?ZOTtHQuJ3zBXI2efUI9W60GW4xarmCJEg0MYZRdwmzzHeVjcFM6RwPF59RXs?=
 =?us-ascii?Q?VKH2kZG8BnfA7wrKp+dY+da/niM4xjHipA6xql5cnmfOd9AAW660QqmGssqa?=
 =?us-ascii?Q?QOUx4u9j48Ic2FArwNmiZbqTAEUgrpvIVt1/c1D3SSZNCxzwEAyMk9mB0fLH?=
 =?us-ascii?Q?7Mbu8Z7Aq/ROoZYtyTwLGjx3Z1lyS+yDlYM4/90hU8fTaPYlrmVOfghX8NLL?=
 =?us-ascii?Q?BlVY1NUEBx9V4ETajIWv8IiH6C2tNGOxjfmT0FtjlWjK43z/yznWNTkSxIf/?=
 =?us-ascii?Q?r/JjSoAzqke8Fm43glXdfruuei/6MRx0PwehZM8s0fKNfZEioLG4GCr0rx1d?=
 =?us-ascii?Q?T5dRl3lt0FJKo2nUiKJGd3RT6XyX7DEAcYzxoDRD/WHHr7Nq6IBvpV7SfN0q?=
 =?us-ascii?Q?xqmzIqwPfXzFM51xxpleTfklCRcHuNAYnLimrl8EI96gvxTAZSU1T38+BB/0?=
 =?us-ascii?Q?ELAo/DQG/KYWx+45PK4qD4k6JvK7ZmCjiZZYcLwarQ3hIcCA/sbcV3c0yS7z?=
 =?us-ascii?Q?1aV1DMvUuYFcUL7Vsa8hmEWBNx7xv+CDWaVERG2KQVhHbfErSlKjcd5CCOnv?=
 =?us-ascii?Q?tiNwefADph4AvRZNh+d3bUr3Sj0WJo96YENknZ91+WWUh0dx1E9f74pjIqY8?=
 =?us-ascii?Q?ig=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed0d3e0d-1d92-4423-f3ab-08dacbec0805
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 18:13:03.5393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4xgmGIJ8tfli8xaI6NMoCjh1sYLRzkZjrIS1sM2EKBnscCxkoZuylYqBMNhYLJZfiVQZPcQPYF6IxPfbCUEhbRtbzaHo4WypzzIr+w8ZV2g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6895
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 07:55:04PM +0200, Vladimir Oltean wrote:
> On Sat, Nov 19, 2022 at 11:09:28PM +0000, Alexander Lobakin wrote:
> > With CONFIG_NET_DSA_MSCC_FELIX=m and CONFIG_NET_DSA_MSCC_SEVILLE=y
> > (or vice versa), felix.o are linked to a module and also to vmlinux
> > even though the expected CFLAGS are different between builtins and
> > modules.
> > This is the same situation as fixed by
> > commit 637a642f5ca5 ("zstd: Fixing mixed module-builtin objects").
> > There's also no need to duplicate relatively big piece of object
> > code into two modules.
> > 
> > Introduce the new module, mscc_core, to provide the common functions
> > to both mscc_felix and mscc_seville.
> > 
> > Fixes: d60bc62de4ae ("net: dsa: seville: build as separate module")
> > Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
> > Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> > ---
> 
> I don't disagree with the patch, but I dislike the name chosen.
> How about NET_DSA_OCELOT_LIB and mscc_ocelot_dsa_lib.o? The "core" of
> the hardware support is arguably mscc_ocelot_switch_lib.o, I don't think
> it would be good to use that word here, since the code you're moving is
> no more than a thin glue layer with some DSA specific code.
> 
> Adding Colin for a second opinion on the naming. I'm sure things could
> have been done better in the first place, just not sure how.

Good catch on this patch. "mscc_ocelot_dsa_lib" makes sense. The only
other option that might be considered would be along the lines of
"felix_lib". While I know "Felix" is the chip, in the dsa directory it
seems to represent the DSA lib in general.

Either one seems fine for me. And thanks for the heads up, as I'll need
to make the same changes for ocelot_ext when it is ready.
