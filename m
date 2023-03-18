Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8976BF9B6
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 12:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjCRLzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 07:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCRLzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 07:55:08 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2050.outbound.protection.outlook.com [40.107.6.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3000CF8;
        Sat, 18 Mar 2023 04:55:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n/dWuCL2BmN+rV89TVVZ6G2zft+K8fk6i9wIxElEbfLGGo0Am90mskhOVqZZInNJ90sQgg/KVoy21V9eU3yWKZtzJZikhRZUKeyhZX7TVaJW0XXFNs+XpexURnwU0nZzjrzjmhz6K2rMtU6aRzvVd/JV5zkbIIHex1cmshGl1usomZO3brndlSnvdclk5lGkJy72ZALu/fHZ0ygwFwpqL5IZBTLC4F+LLRnLVrFiik2yPdIjy4JUspBRI8rg58lI1McpCAU9jtuX8DO4pRTg5spCiy6awDh8egud0n2iMhOVe1uIZN798ZFZ3qTYLnyGRdRDypJMYb8GOgDfSNj/pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hP7pK2hgKL4eGGpIoQtbBVlFL/iTyog1C5fpkJ7H9t8=;
 b=ltn5AGnRikR/RofuKHi+walt/mzJ7T8qmMnAQowTFTKntETZlHyTbNxULQ1VyLFlSQN/y5vOXotFdUD3MYoMcHpq3aQ+MC75Rhai5Fa3lnuhnIdNfVZFGDRGZr6kjdQPzSfmYKFot1QJ4qwFaCePUY/ktagnrKGpGlZzglxyfqrLtJX3pAA+oh/gd8poit20wCYdaugZ95/ij9ALsYhuCjamqhr9rkBHc5RuXWZy3YXzKh2g2jxo7aJE5D20VklCJ60Q2qai2gm3hCZI6AiKSjZY+32Qj28NNIkRLYjfC8IkKjUUk6sgmQlB3scn7RX6TN96kzvfwAAh2aH7rnoEkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hP7pK2hgKL4eGGpIoQtbBVlFL/iTyog1C5fpkJ7H9t8=;
 b=oHJJL+3tjJjbdg5t5zoiwLqszLyDQGrCJkTYveu8qcL/6copmlZNEeyS5HU6m6kIh40pZtK7iFhbzCCB/XEYEf31eQ6rZaXDUVjiHUl3qdTb69DjF05MhdZ9fHmQ0m/gHvlmByJfMspgfY+T2MKDR5+X4iRSfz5q7Ykpwd3SZ3s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PR3PR04MB7404.eurprd04.prod.outlook.com (2603:10a6:102:8f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.36; Sat, 18 Mar
 2023 11:55:03 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.036; Sat, 18 Mar 2023
 11:55:02 +0000
Date:   Sat, 18 Mar 2023 13:54:57 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        =?utf-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Michael Walle <michael@walle.cc>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-omap@vger.kernel.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        thomas.petazzoni@bootlin.com, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Minghao Chi <chi.minghao@zte.com.cn>,
        Jie Wang <wangjie125@huawei.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Sean Anderson <sean.anderson@seco.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Marco Bonelli <marco@mebeim.net>
Subject: Re: [PATCH v3 3/5] net: Let the active time stamping layer be
 selectable.
Message-ID: <20230318115457.gtfvq6gom3jew2qc@skbuf>
References: <20230310114852.3cef643d@kmaincent-XPS-13-7390>
 <20230310113533.l7flaoli7y3bmlnr@skbuf>
 <b4ebfd3770ffa5ad1233d2b5e79499ee@walle.cc>
 <20230310131529.6bahmi4obryy5dsx@soft-dev3-1>
 <20230310164451.ls7bbs6pdzs4m6pw@skbuf>
 <20230313084059.GA11063@pengutronix.de>
 <20230316160920.53737d1c@kmaincent-XPS-13-7390>
 <20230317152150.qahrr6w5x4o3eysz@skbuf>
 <ZBUyST3kDP1ZE1lF@hoboy.vegasvil.org>
 <20230317210306.346e80ea@kernel.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230317210306.346e80ea@kernel.org>
X-ClientProxiedBy: VI1PR08CA0130.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::32) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PR3PR04MB7404:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f962c2f-a98f-4cab-1fa4-08db27a79b5b
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kIYL4oMnWQcD0Ds8IBtZlb7WeJX3o7aZmr/8fbTDbTshbo/RPEGytjNe92aGbWUbyTD4iHwlXfr80zOox7pm8bvxUeGG/jzhEACP+OckRbWurKL3e6mjYoif6mEpzqd6kfOiW8C0yRzGesPSMhX5AUQ7PnHTyG5m9I4yDK6qhnWSkVAA6vfOwYzpu5FYnwur2M0LJ9TbIFEwDWfa42RrX2QKbGRJJh3z41o75uGEsbMZQY+YwvEIDtHx5dgXnHLwOmvz0lfB5YwoBs6ipLDnNuj4VVpbAYh4rUQnVdT78BBJ6po8aCEhrjb8BqW6mjHnjwRGue780Sw/g07mkyUL3WRhg4Fel6Q/RibbZZc5O0Y4To8kUqSnnY/hm2xapvkE9h5xpsflvlAPzT2VCTtHMKQVJNGi1m5YZQpEV0n3FqWjO9vqh74QB4NorUg0oSAz4shPA/nOIXcvXJpLW+inh2G9kYcXQqqglG49sGxEZhJlJUmfFmgoLfKmZanJxoJ8FBAU1hxWXINhkmxTAQHdEheF9mXtyrDz6FCJnFbA7FmZeVQBCxeQgnTMB1/C7lhHw67B4q8wWhU71hhuDRVsoUUmnVt5Pr998jOQJ6L/5mUkF4Sh44sUb1nrDsFuGE3DCnOGF/mSdHZgp58dxQdtPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(136003)(366004)(346002)(376002)(39860400002)(396003)(451199018)(6666004)(186003)(6506007)(1076003)(26005)(6512007)(66574015)(6486002)(316002)(9686003)(6916009)(4326008)(66556008)(66946007)(66476007)(54906003)(478600001)(83380400001)(8936002)(7416002)(7406005)(5660300002)(2906002)(44832011)(41300700001)(8676002)(38100700002)(86362001)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?Ku6jfbNHWNj86RRzwn0CeXWmU6810N/ZyKnu6W7gfkotsUEpi+MMjMPx6A?=
 =?iso-8859-1?Q?+mfK3gabkQCspfg6h80/Gfd0gPsK13xMrHSEimkQvWwXhREMOPcwETVO/f?=
 =?iso-8859-1?Q?1mF2kjlCV2NBiC6f6yMP2BIwYju4oa5+b9J2Vtkgxds46G/SR3mH2N9pHT?=
 =?iso-8859-1?Q?kjSn1eAHwCJe7liTIr2UtHPJliSHHZPYMEBLkY1aTssu8wFk8zwPxM+KrY?=
 =?iso-8859-1?Q?Tqkih30YOfYyZuGA9fjjnVIxtsbxGeASOIhcTz0lekZztkICn4dakphU9Y?=
 =?iso-8859-1?Q?0Da34PrB2dNbegfPp424JmviR0JZsf4qgSWskovBkNCTXgcdXP2bzT6dnX?=
 =?iso-8859-1?Q?fzPQ5NJO1fiQmk1ycWTcRfTHCbF1rlwwRK8Cm+Mft7VRwj5CXf8jVgqdU6?=
 =?iso-8859-1?Q?y/c9vrrE0NXbSr9R+pXgdBuPEvLxbErs8rrNPahH69EXHSfGyY2P4cKUte?=
 =?iso-8859-1?Q?JQdGhVNFXerkmRhxtv1J3b/88EAJhRTb+XcFs84Hk2Mwkny+UyDdoyMTGi?=
 =?iso-8859-1?Q?M8A+xTlOYyuRryuWeMibyavaRpexir14p0Zcv8U77ajN8U08oOC8b7vqZd?=
 =?iso-8859-1?Q?CLnn7Y16HpIbOET7844fNUJqeTz1oluudVwAJ5U4ipp/NrdQW8KjoO1Hzn?=
 =?iso-8859-1?Q?/8XZs3Si2tulisP+qLkX6jJ556oW21anHIBJdp2VpZZehCXAYDN1dHm55J?=
 =?iso-8859-1?Q?EYZXHMJaTEkRXd9zGecJy9ziZhtXs7C4IpNrAmE+H+duO2Lwo+4/mmldKs?=
 =?iso-8859-1?Q?6h75QeJ4PihViodeiTkjnt7T9fLGth2HIn4C/ocZqW1szXdIL3/BTLJCOk?=
 =?iso-8859-1?Q?4KeaXcUa4DQ/TXrfLQfghZkDpaUnBGIqy9gBDBttYMpNn/boDmUaFe94tC?=
 =?iso-8859-1?Q?qGYYkrBVEThvZmRxNlaQdg3R35Ce/mr1wt3Upb6PzA8LQiB+XupUFH1gSV?=
 =?iso-8859-1?Q?Uxf38NJD3wPp2PijLJTAG/gxUR/wEf3pJaj4nnHVgZQhd/pUdJdItFhUiP?=
 =?iso-8859-1?Q?JKl2DWeT/v/4DQfempWOj2F72oq2ddW0cy2kLCbAmr0l1ZEPwYJewN3i38?=
 =?iso-8859-1?Q?M1NLPUy4dEWqKJ9PBAPx2iLSMLf4FhPFgTI5EdVYa605sDZftMIQwQHJLH?=
 =?iso-8859-1?Q?ulIZqJxElVdEekH02eg8EkOd90CMCNr3E7Ar3dh1KYAkjdyfoQGvmB4bG6?=
 =?iso-8859-1?Q?Er+4rdd7RvoexgjROEdJ6FqFK1Q+0WE4fJIv9Fz03WywIE8bF5V17QPIdo?=
 =?iso-8859-1?Q?klygkL7yiO24yoZ4+LGCORfY7TFi6fdblabSaNaNX+ZDx2CsWtjdQrbbzF?=
 =?iso-8859-1?Q?bi0hwHMqORxKt6v9b2/8uCnAkFMCAKBY6YVMbUPwSyn1gHt6jmFez5TR/o?=
 =?iso-8859-1?Q?K/1ZPPz+JncBsopWRABBKRTGNRSUlIx7Wb3B4efCtK/RdPXURUC6PxdJeW?=
 =?iso-8859-1?Q?epWs6uqJSiJkSn9rsuFa+vMeY/k67xwpeMiAODT9pFJzdZitiA+XNYUdlX?=
 =?iso-8859-1?Q?vfGGH2itdUb5Ssjp6vsN2uZXZFWKOJuaM4/U/blBJE+lFUmxwBmUmU4E1n?=
 =?iso-8859-1?Q?8YNH5u7wx9cmvT3mUgdHDQeeLMX0smurAYxPf/ymKYVVqLu9Qr3Pcpr/uG?=
 =?iso-8859-1?Q?jxHOJGWfU69oa6qBZj2AYqmGdQhKv6GV4uaj8z5k/FtLwSp5I+BPB8Qw?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f962c2f-a98f-4cab-1fa4-08db27a79b5b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2023 11:55:02.5331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BjlVDcEWMJUXDr/QiQHB/5F2UJN5Qq9TEtKB0Paqxw+UoztMF9ASFsKW8iucwTYitNQNmduDJY2kZgl4DlQcPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7404
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 09:03:06PM -0700, Jakub Kicinski wrote:
> On Fri, 17 Mar 2023 20:38:49 -0700 Richard Cochran wrote:
> > On Fri, Mar 17, 2023 at 05:21:50PM +0200, Vladimir Oltean wrote:
> > > On Thu, Mar 16, 2023 at 04:09:20PM +0100, Köry Maincent wrote:  
> > > > Was there any useful work that could be continued on managing timestamp through
> > > > NDOs. As it seem we will made some change to the timestamp API, maybe it is a
> > > > good time to also take care of this.  
> > > 
> > > Not to my knowledge. Yes, I agree that it would be a good time to add an
> > > NDO for hwtimestamping (while keeping the ioctl fallback), then
> > > transitioning as many devices as we can, and removing the fallback when
> > > the transition is complete.  
> > 
> > Um, user space ABI cannot be removed.
> 
> NDO meaning a dedicated callback in struct net_device_ops, so at least
> for netdevs we can copy the data from user space, validate in the core
> and then call the driver with a normal kernel pointer. So just an
> internal refactoring, no uAPI changes.

Yes, I was talking about the current handling via net_device_ops :: ndo_eth_ioctl()
(internal driver-facing kernel API) that should eventually get removed.
The new ndo_hwtstamp_get() and ndo_hwtstamp_set() should also have
slightly different (clearer) semantics IMO, like for example they should
only get called if the selected timestamping layer is the MAC. The MAC
driver would no longer be concerned with marshalling these calls down to
the PHY for PHY timestamping with this new API.

This is also the reason why the conversion can't be realistically done
all at once, because in some cases, as pointed out by Horatiu, simply
marshalling the ndo_eth_ioctl() to phy_mii_ioctl() isn't the only thing
that's necessary - sometimes the MAC driver may need to add filters or
traps for PTP frames itself, even if it doesn't provide the timestamps
per se. That will be solved not via the ndo_hwtstamp_set(), but via a
new (listen-only) NETDEV_HWTSTAMP_SET notifier, where interested drivers
can figure out that timestamping was enabled somewhere along the data
path of their netdev (not necessarily at their MAC layer) and program
those filters or traps accordingly, so that either MAC, or PHY,
timestamping works properly e.g. on a switch.

Also, the ndo_hwtstamp_get() and ndo_hwtstamp_set() API should not need
to explicitly call copy_from_user() and copy_to_user(), those are
especially error-prone w.r.t. their error code - non-zero means "bytes
left to copy IIRC", but -EFAULT should be returned to user space,
instead of blindly propagating what copy_from_user() has returned.
