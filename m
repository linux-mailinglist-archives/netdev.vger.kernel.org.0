Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA801634368
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 19:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbiKVSOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 13:14:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232685AbiKVSOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 13:14:23 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2073.outbound.protection.outlook.com [40.107.22.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD346EB5A
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 10:14:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FhFL25/ZgFPObpjFiiB7FUDB6swxkU9Cg7RCA8Ct39G5ONlFvJ2RFrPfaEcn8z+x714baaOFKGhejxbAQJyOuZHDtJxbCsxA7FgDA8U/q7dpMekjWVqq3eUuS9enrfOu9r2WjIYQHVABmff/LfnvqE5u63KzzLv1CrKMj8J6H9Ze2hOgWVGgyXxZKDrI3ZP7qmov4t8bo9SWyLGkiZzPM0ocdHf7AIIICig2I0+fAXroo81lg55PzR8aFrqItW/1/LhBy4i5/KzmuBgswvOO4JFlq7y/94p75dXGtQdKhs9eMjXeq4AapeYtdn0xoY2Q60qkBt1yyz5XyJ8euq7nUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SZLHRuwZTQuCKLNrPiYG0I+v9Wr3QG/Kjc9xPNXb45I=;
 b=WvkOaCku5HQpVmeTdB9+CLbOdHzTFdlGTo0fGfXUEU9xojVQ+ljzejBL9UH+RzYiodMx+vzZIcZGA6tqr1gvJanf7FLpUr0RQ9nP9N3ANdpB4OPQkUd4weHlhbdDaTloXgL44WHcTD85kx9eicfM2eDQ0YR0iS38Bq9HzzhgAHq3uRlC3JWchlGQBR+xWwwqPnGIr0b89FU245zGYD/UWHpDPCkHjm9VMUwsDETsYEino+5T9kue7TPbmy2xwwn3rAvErgwfc3Gd1un2GypgaGni5qIJJg5AO5ZMyodSZWUxomtFls/KD57RVdjkE4hVc2ft/zLHkZGzunxWDT93LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SZLHRuwZTQuCKLNrPiYG0I+v9Wr3QG/Kjc9xPNXb45I=;
 b=KTRY9VHTsoL84N7DIO904lJU8bjyunM/mvWX8q2hjcy/SmwA5QSFDyaPhu/Kjhwz5mzPP4AlYDF7k+NF6gSCaOS7REJTE2O1p20woO8uUu73AoC2t7mfswaPXXDwQehBzXaeYJZikjZsmjVPeS5Cvc7OkYt5nW6wwqeRcw4hprs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS1PR04MB9480.eurprd04.prod.outlook.com (2603:10a6:20b:4d6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 18:14:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 18:14:20 +0000
Date:   Tue, 22 Nov 2022 20:14:16 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Sean Anderson <sean.anderson@seco.com>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
Subject: Re: [PATCH v4 net-next 3/8] net: phy: bcm84881: move the in-band
 capability check where it belongs
Message-ID: <20221122181416.ui2e4jzenvaeodyi@skbuf>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
 <20221118000124.2754581-4-vladimir.oltean@nxp.com>
 <Y3yYo63kj+ACdkW1@shell.armlinux.org.uk>
 <Y3yvd0uyG2tNeED3@shell.armlinux.org.uk>
 <20221122121122.klqkw4onjxabyi22@skbuf>
 <Y3z/xcbYMQFM5SN4@shell.armlinux.org.uk>
 <20221122175603.soux2q2cxs2wfsun@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122175603.soux2q2cxs2wfsun@skbuf>
X-ClientProxiedBy: AM0PR02CA0187.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::24) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS1PR04MB9480:EE_
X-MS-Office365-Filtering-Correlation-Id: 885615eb-3048-405e-1e33-08daccb5601b
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1TmJsMyUUq1lXjHfH6/iTTko3lxJm2xrlOKwEtcRzWz15nt4z/SAkrkULPsv4ShfoD7t/KgrNX9E6hnVeOx6fh3YeQlVsPZm7na1oB4SLQspRMdVWo9VAHDby5ZAWiFaFaom/AQ5u3PUEoYRimrA6LGOeEjiibjYn1M4Ne5+BnBeMa52vbNpJyyxxhgHPQQcLCFfLncwXwwHx7mBB4Zlk4UiwVtHJUdB/4qIRMEJeqjQZDWiJrofFQTbh2ZI3fmOwYDwhgVhKM16eEYqCrd6kDSrEGVe8oZvGFmG1ElskYW7xxb5WcUmRlL49iLhynB3a5RVE3VlyUIEs5uG2FC5Rk1w1RvZZXzsvA6cUkOhlSKXhK9gFEaF0PzF+UYBYrIWnvSSJOlEn9Z7yIdckMxy/G954a5Bjd1b0D8v92Jiu5BiE6KqUvgQW8lvQncS82QlqoVaHvui/UzP5iXlOGWNfO5L7jRvvQ+f//BrgVpa/Gz2Wu57lL3KkuvRsK+70U9ZZ2iXFsFYIRvK+hRcbv/qqJ+4pq4YFoLYyYdpOHeyg9fTj5oKpoT3dt84sGfMFAHtOauIiQuQNNZm50rn67LXaBKBOfAf0/SGAkM0kvEo7N6pI/L+ZgM6GEYW4UOSwkdj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(346002)(39860400002)(376002)(366004)(396003)(136003)(451199015)(478600001)(6666004)(6486002)(4326008)(41300700001)(8676002)(66556008)(66946007)(66476007)(186003)(1076003)(8936002)(6512007)(9686003)(26005)(5660300002)(44832011)(54906003)(7416002)(6916009)(316002)(6506007)(33716001)(2906002)(83380400001)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BLioWMotUSNRJHbWYlJqGZZYTWtY4CxP+fgoIKiUWeMZmSgTUOwHEjQaGPYR?=
 =?us-ascii?Q?KRdB51BDJzsYb9Q5nNr8ZWKbF6depb0KCY283aMgwyPqrUcPsO6ufqgzliQQ?=
 =?us-ascii?Q?RueDxfUxvQdDX53ZyczzWdp5v673Dj1FNyRiSW+wRB16eUvszzLLoA32UkTw?=
 =?us-ascii?Q?LKHAbPWThD63No8hYJ5Ysw7esCuDmYehpHcf0w6hv6MAR7+2Gil/bleAvvKj?=
 =?us-ascii?Q?hGd3O+y/t9sE18xDSIyVea0EKtlmiKBXk2VbWoeQO1b0Nxyu7x7L1CkMV601?=
 =?us-ascii?Q?IiacB0oiS1lj/bwBHWfh+BMZQRjjmRKOqy31who9qM7ftUUYS9sy84BsMm6s?=
 =?us-ascii?Q?qPQMHpnnDw/jMgaL0ZhkPYmCrzHVelchWe41j2YzFV1SzkUHu6apr+HZWjpX?=
 =?us-ascii?Q?YlPjNqCcfq/NkLzz98GfqLnY3PCo/zX0JHFMicyWiAt9fOnzmnSGs2z3/JTJ?=
 =?us-ascii?Q?dyovCAdxuL6U+ZonPG+YqGAfcZDzTPDKaJ/YtMKf3KsBgKAx5zVM6yh3lbrd?=
 =?us-ascii?Q?Jf82mOxjU68ZweHBQ9yJ+AMju5r6aZDeyaJH14Hi22wKfDfDpKtKKTucOU1t?=
 =?us-ascii?Q?DtAexbyxvpznqKAvSvCPGpBmFrPYW5TnMwS0+g+GlOe/maRk3bhbHgQPBCpx?=
 =?us-ascii?Q?njZGKvFm92JBqWEC4qPZLcg4vMzCcdZsQN7imadiF74Lf0eIe57agpJbjoAL?=
 =?us-ascii?Q?ovQ02fjoBHI42QFR62xCTP7WzemRsBye7ei4wZ+n80Snr+kOW7RtPoQmDmb+?=
 =?us-ascii?Q?H2qm+HnbYHtxXm/7dtgOwAjEJ++0ee9Hi+4JHbH87ox4PuSWt68b82cI9Cvp?=
 =?us-ascii?Q?L+hRpnn/jjxu0thAyKpMh0qJjDZQhbj+028zV7y99SkPUTwtLRqlJ+zFGcxu?=
 =?us-ascii?Q?xv+HI6eY2wXGox+vtipNFiBihWdyFc05M/omoNmsCAvZEkYASY1OY+tMkSme?=
 =?us-ascii?Q?NwgiBdFkk/S0BUBN2C2qEpLQXVDbTZ2nkRMeULEVfQJA1/UOmX0MBc+OUf5s?=
 =?us-ascii?Q?T+JyUMa0m2ChDLQat6WyStjl9n9Fjo1G0rtiyiXEHNv1BytUDhpnnkJ7g4oW?=
 =?us-ascii?Q?qB5kah9aIYaAvh/9KIHJvP0G9wiNDuL/OrfBvbx8o1TLL5KBM7Wq1pisUmg6?=
 =?us-ascii?Q?tMlqmhKT0PI9PrdtJrBs7b/bOjJ7aNjeXICyFPXcTFOShlNv+EF+bl9K6tUa?=
 =?us-ascii?Q?cVNyQQz2BZB1XDt+ZbRY+sZEYePyo+XhtBxzDW+5/RxGukgv4yLxXymkBivn?=
 =?us-ascii?Q?BfADzLklhapKMfj3ybe+avmf7LaD0anZ6uv2Ui8ej3OUfgwyKinZB27EguwD?=
 =?us-ascii?Q?x26WXI8QcG6PVlVYw5dwJUAV4pPBK3jseyepARbH6hsnEuF+ZztpCojsXQJE?=
 =?us-ascii?Q?iin07x278ToNlVdB4z64Xv1hUFMV+yjbhQe+hApCo7pPcNz8D2zO4OMkSmCI?=
 =?us-ascii?Q?G2PAlKvSHOaxIgeZ95qx5BEx8f5tE536Xx6s36wzmuW8L0qV3ezltwPrOn7Y?=
 =?us-ascii?Q?qSlF4iWRXueClVnasdAroQQ8tF1dZfTnpRf2XHuS2WlyMt03DsKaVqDFXCMI?=
 =?us-ascii?Q?95ayIBjczL5IkWnBgvtaCrfpyhRLzwvOWvuhyWQ2LFTnVQGPOG3jvWme0ito?=
 =?us-ascii?Q?8A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 885615eb-3048-405e-1e33-08daccb5601b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 18:14:20.1445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0NSAszCispSLYOLwlzqGmr4EtIKdIHmg17WHEiYzt/A5Ov3Sy30apCS5LHidVyC/Ne5lCgL7xQ00PhoGROVBdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9480
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 07:56:25PM +0200, Vladimir Oltean wrote:
> On Tue, Nov 22, 2022 at 04:58:45PM +0000, Russell King (Oracle) wrote:
> > > I think I have a copper SFP module which uses SGMII and 88E1111,
> > > and I can plug it into the Honeycomb and see what happens.
> > 
> > I don't have a way to do any in-depth tests other than with the SFPs
> > that are plugged into my Honeycomb
> 
> I actually meant that I can test on a Solidrun Honeycomb board that I
> happen to have access to

I may have misunderstood what you said here. Subconsciously I thought
that you replied to what I said, but it looks unrelated. Disregard.

Anyway, considering I can't really patch the Marvell PHY driver
(knowing what I'm doing), not sure what to choose between waiting for
some help there (to have more coverage => less chances for regression)
and simply not converting dpaa1's ovr_an_inband to sync_an_inband.
I don't think the other NXP drivers are quite in the same risk of
regressions as dpaa1, as their device trees were introduced much more
recently compared to their conversion to phylink.
