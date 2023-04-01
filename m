Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7556D3316
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 20:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjDASVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 14:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjDASVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 14:21:05 -0400
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2081.outbound.protection.outlook.com [40.107.241.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2258321A81
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 11:21:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CpDcB13/Y8BuGKWSFgEgxC2/vZY+g3TQJopZyvQApBPx6XXse+PTHziAMcmI9q7hlGD2q4rzItZJJNQXxjXCqD+MJ4If7WHSqf9A5CepMsStB22oq3G0bP46KDNtlkVAYo2HVQ0ryNlM18NUPk0OpNGXwrddfcISzXnayyRNN4LGSw2gq8+wza9epFZBIkZhH2B46D32qGGrLTLMsZU8TsKy4FGfQXllusXd89WZBmjf8CX37FA+BjUg0wWPwnpuPtkfSkc3a72n79J6jdbnloXUUpiyV4V9vWEms28Z/bgRU4D0jURQEW4mKH3NNLvjm0PfA/zYAddrFokmQqMguA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yFk46l0+vrkFvuSfvHnxedvotywLtMJr/kMmff8bYds=;
 b=LuuFF5qg3R99lGw9QwJDLeRoQK07eAHA47EV1Eku1zRSZ3Hp1myFNP1QZSc5lVtwj3jGVTlf5UGnJmE+xWx+/ZQM0p0xbWRLhziRj7CdrB4VhBtcNA5A2/DAQs1qMG/gafZ/a/K1nJE7hMywVkjc/t8COei/K88OiVCIllwcaKbakQeY3xnuhb4C8H2EH0ZZBI4hmr6tJ3KZGq/qksLu7kysMusCW4tCPLJh+ZUbfLTPUSP87g508qXAhX7SIZLD9LxnJzo7/rk7fm0dhL5z0+1hux+W9HKqdOGha77RSB/ae/JqKvl/bFsAbL5mNZIPLpK6FkMFU353CnOGfifgig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yFk46l0+vrkFvuSfvHnxedvotywLtMJr/kMmff8bYds=;
 b=d7ZoHauxEiVkQi+ITuHs55qET52Cj68JhLJUwHEYL6p6k2IuQLOCqTVD21O/wz/J24SHquAST0mJFMC5zMf+Trr/ZAg5UPuP6a+Yk5f4AbORAanoRM44PaEbnrVV/pwNJ4V/3AFzt8UROn2lUsJ2qfM0+G6IYV+UO02GQYFwDfI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VI1PR04MB7055.eurprd04.prod.outlook.com (2603:10a6:800:123::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.28; Sat, 1 Apr
 2023 18:21:01 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Sat, 1 Apr 2023
 18:21:01 +0000
Date:   Sat, 1 Apr 2023 21:20:58 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Maxim Georgiev <glipus@gmail.com>, kory.maincent@bootlin.com,
        netdev@vger.kernel.org, maxime.chevallier@bootlin.com
Subject: Re: [PATCH net-next RFC] Add NDOs for hardware timestamp get/set
Message-ID: <20230401182058.zt5qhgjmejm7lnst@skbuf>
References: <20230331045619.40256-1-glipus@gmail.com>
 <20230330223519.36ce7d23@kernel.org>
 <20230401160829.7tbxnm5l3ke5ggvr@skbuf>
 <20230401105533.240e27aa@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230401105533.240e27aa@kernel.org>
X-ClientProxiedBy: FR2P281CA0119.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9d::15) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VI1PR04MB7055:EE_
X-MS-Office365-Filtering-Correlation-Id: 52f0ae55-105d-4169-406c-08db32ddd915
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wvXhcs5udkQO+zvrYcXukbaXpotGlC6Yai1AQNYU9iTt9oXqIOf9AoJLmC5mbZgQFQChWOFXOLyOAzxraRomrzOjCIVma5e5DubnYdQgsB3Xllu8IdAc4TvVmIdSGYyCJDWbkPl75Xjgg0uYmXHnmANxbZHbAQjm9sG5Nk/jY5pwMGZkdaV2qOy3mQZqVTXX1jLo0yhI0MOF7xi3TmfM10NC7P5lDkaE8hO15Lt+arN1nwiiA5besH3ny6lnWSaSws1RF0oLnwbmTWBTJiDfbI51fXhOI59XwzE0vfhZRZK6PUnzjgJ9mBCHnGv17CwR//FYPqmdEDx9/+LHwusMYV8oXA0swv39zTd9xGyugSN5sNXjBzU0tKaUsmEcEmnYNYRfKjPG7OueAAaWkVPz94eEpAozRyT/jNKjCabchLhgfObtA1mUOWiij9PrC387gcGlyDMW1rkVItwgwAVgissx5HsIYjRhSIbREW4yRCvBbxboYiKBPpzemOaI5vKwWI71yRg/gap7FFLIgDqSsr196VRsjzY/pkad4C3nKRqvaf7BGKCSGuJYMWc1g+Qt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(136003)(366004)(39850400004)(346002)(376002)(396003)(451199021)(4326008)(8676002)(6916009)(6486002)(316002)(66946007)(66556008)(66476007)(9686003)(6512007)(6506007)(1076003)(6666004)(26005)(186003)(83380400001)(38100700002)(5660300002)(41300700001)(33716001)(8936002)(478600001)(86362001)(2906002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3cdvxvL3RvLQy1iKTPj282OjrrH3cvhI3VWbwu0syz/zTc0Lm5TtGY9exKB3?=
 =?us-ascii?Q?dQwrGIAM13WwneXhMQwsB0av+Aw5TO1L3CKS0irQdJummdAtjqPIJBgJJ0FS?=
 =?us-ascii?Q?/Tomjmw3txCX61AHOcanVnhYiMKh3bzoec31R508e6Djn+MBSOLbFfMNsz/G?=
 =?us-ascii?Q?GfT2gfg4HcTbzbubSswbcM3drKP/xuUMQhMzm+pbemZDE0CflbsnIpGoKjrw?=
 =?us-ascii?Q?Co2EgGVJ0YrEmZ4kRkqh38n/KVoOfgM9ABnu0L2KBjlP/k24IoVSmZ6mXa7m?=
 =?us-ascii?Q?RJdeXIAsZLZ0AE3mwQdmPRrKgcB4355CPD505FSslLAQzdsaTwxCheQMOXWR?=
 =?us-ascii?Q?j+h9KkMR67WMErxyYM5gFkgg02XQhw0XmZG0DIHafOCOng8N6FMt8K78TweS?=
 =?us-ascii?Q?54FBLR5kUqJvwlTvtZRgkmEIfoEvCyQc3IxdIXC0TBou6t2x0qtfCjztHMGI?=
 =?us-ascii?Q?HuR5Bp8ATr1Szbzz4/TuubPoXFGSj0/gI1lRPdmZYTSUrw+d4q7T5xslWROk?=
 =?us-ascii?Q?tvFbOmb/4WHMZlNIfSFV+Gz2oxmCQ3nQ/YO4JVKl189tv2aiAZSA94tOclkH?=
 =?us-ascii?Q?QSsNRi/uboM9bLRlYai898qhxrgFAcmFQB4ajn6ZLHu2f1Uwq91NvZnS3GEp?=
 =?us-ascii?Q?i+wzj6R47Q8++I26V7gJ82aJL3rdCJ4whK4uYrWMyBXCSYsHCLY4Yf0yau71?=
 =?us-ascii?Q?hculkH0n9+ipe8sq5L5lOEvSumfW/akN0UVbO4iA/reDoFGAbBEGPit0PPZy?=
 =?us-ascii?Q?I4TstKea5GG21oGqfEfim9lS3hNms3ifuPjGAcGwVMGKjPodfXItzT/U5qVq?=
 =?us-ascii?Q?313rBMYcc4fSaem7ftDCdBa/hmf2YiNfZkYnAIEzMsDDp40BKD2xnIl73uVR?=
 =?us-ascii?Q?6W/akZaRjGCm6H1W2xr3uWEYSE4EdzYaTBa1oJ2yNjUFEzTUmxnTCg3Hnztn?=
 =?us-ascii?Q?ACjPkNMQySU/F0Fq4LjX79ynh8veKkLEsroqHu2kzhRZ46WGlgKYNgrKuEzg?=
 =?us-ascii?Q?BXPWyJRH1ZClHMqxwNj7XI/L5JK2KYUqpNy2C3WOW0NlkMiym3q9tQvLt6QB?=
 =?us-ascii?Q?4C53Bg91gVYGtyvHO5zUhUCoClh8G0N7eCVD6EtUVaiUpkUDckLpZScphNyD?=
 =?us-ascii?Q?4tMiYOGJyOz/wj/ZVAqBwahKlSjwxGj+A/tjTjFPXLzqlqZVeTN6go0tSu2q?=
 =?us-ascii?Q?sPqcI0bC6XInvbHaBmoXSs0JwehOT+sRXddI7gyud4zpi98993xuG2huR3ZI?=
 =?us-ascii?Q?7q9OUIWXdqpm2rEk1KJrK+Hm4NVLMnfM15PsZ7LsEWMLMcYj+uk1kOQ/WJut?=
 =?us-ascii?Q?A6V4zpccsHEzJaJxTUJ6wOlXdedgJLD5jYUSBWxWzYOvFR/ZJeqqnjvTaloq?=
 =?us-ascii?Q?J5AmKO3TyPUj/giG3yFyocceI3f01b4gcZ4+4aqMy4PtlC21Z7363wMDSmVG?=
 =?us-ascii?Q?p6oy1W7z0TMsU9dmLot47uy8G+0h8E4pYXQyAysvQ3FkLZriB5MMlz5VktrT?=
 =?us-ascii?Q?av0TClx8Ma4sGw2l7vuqe78jTWsKP5savLDwMuBoknSQcVBYUA5jqcOc3iDx?=
 =?us-ascii?Q?9G9A7Xt9JMD6e6Vo34jF4R/cIOIpTmTYjoddzi+nbkdaE3AgU1CzR/gk73L2?=
 =?us-ascii?Q?AA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52f0ae55-105d-4169-406c-08db32ddd915
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2023 18:21:01.6035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iMdI0wNCIXjtjhahLwz9gcXxeK404RvBYCjd1uZ/juO+W7lMrpoHB6h7N9jL9ZQ1RKNQcJO29XZYDofKdtdzRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7055
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 01, 2023 at 10:55:33AM -0700, Jakub Kicinski wrote:
> On Sat, 1 Apr 2023 19:08:29 +0300 Vladimir Oltean wrote:
> > > Let's refactor this differently, we need net_hwtstamp_validate()
> > > to run on the same in-kernel copy as we'll send down to the driver.
> > > If we copy_from_user() twice we may validate a different thing
> > > than the driver will end up seeing (ToCToU).  
> > 
> > I'm not sure I understand this. Since net_hwtstamp_validate() already
> > contains a copy_from_user() call, don't we already call copy_to_user()
> > twice (the second time being in all SIOCSHWTSTAMP handlers from drivers)?
> 
> After this patch we'll be passing an in-kernel-space struct to drivers
> rather than the ifr they have to copy themselves. I'm saying that we
> should validate that exact copy, rather than copy, validate, copy, pass
> to drivers, cause user space may change the values between the two
> copies.
> 
> Unlikely to cause serious bugs but seems like a good code hygiene.
> 
> This is only for the drivers converted to the NDO, obviously, 
> the legacy drivers will still have to copy themselves.

Could you answer my second paragraph too, please?

| Perhaps I don't understand what is it that can change the contents
| of the ifreq structure, which would make this a potential issue for
| ndo_hwtstamp_set() that isn't an issue for ndo_eth_ioctl()...

I don't disagree with minimizing the number of copy_to_user() calls, but
I don't understand the ToCToU argument that you're bringing....
