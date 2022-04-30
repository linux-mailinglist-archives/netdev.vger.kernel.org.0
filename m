Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D545160C0
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 00:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237353AbiD3We6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 18:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiD3We5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 18:34:57 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2127.outbound.protection.outlook.com [40.107.243.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C5585B3D0;
        Sat, 30 Apr 2022 15:31:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YtPtY7oBua/D9+fFKnB+8qNnMY3M3FyZ+a/To+uhdAyY+iRQ53dvsXYE/V/C40UtB/y1UpVhqYGDNYxGNqbtff3zedugGQ5P/114ivlkDPvPUZcKtZqrbyL3Z7LIg5GsQAhPhaMWUBrTpxLzrV5CSmJ7chSE8kYVNTN1qr26FyyUgGHcNl4Fv0CnOXLzQ1Bs3IcE/9OLfYtx9f5ltYIbNiIYJYy1sOPQQOyxBSTgom23q/eJhm8dCTu9K59jOaZhl6B6PuzazZ8ArJYxWEmswn7KR0lon/ARznHLzZ+rgIkXYwK33Fsny6NWWXNSRGBNfOwo+e8aEuMTax7MQjnQmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i0JjhRq7Qs/rUbNoCdMbiZwERQugK3ZCgkMzUP+1fPY=;
 b=FH4w4Gnlpx0w6qAwZDysTLAT7ooYIxci8T8N6YROJWgToIYiloc3LFpQbnWsWt6QQyuZrATqF/4fsp6hjbFxjlPMax2TvV4HSnj5U5QYo4B4DIj7F4Wo6FmMweeiRkqZZoyEI5rONBq/kTGOAhJA7sdXflS+1uZf5ajUgawOWXKXGunSrMOHxfRaQ4c61RCvm4vW2Rrkr8X6mL6hA5uv6ILif2jacKTmjNaVIcKNpJ0gVBpgjyuoWSGv5oZaLoyzEJSQnVfgvvTLy3LalLCl6l6n1ENCi0EMac32qHBNzSGwpg93mvXw4N23PtYrRdVfQn5xTyhuTaD+0iQ+KeALkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i0JjhRq7Qs/rUbNoCdMbiZwERQugK3ZCgkMzUP+1fPY=;
 b=iawVUuprmhsruIyiADOS4pj1wZL9ZGEHbZm9Itp/AC+EIuuCq57YFFlBvkOwainXQ01ZKtjMsybY++2cO1hmkhN9zVARLwsYVF3qmHdwRtcBlt5VWw04pY0ihU7AdJ7A3tvX1zqYcM6Mq4Non2sD9IIGi+g9FdyJX92dISoXEVE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CY4PR1001MB2407.namprd10.prod.outlook.com
 (2603:10b6:910:47::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Sat, 30 Apr
 2022 22:31:32 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5186.028; Sat, 30 Apr 2022
 22:31:31 +0000
Date:   Sat, 30 Apr 2022 15:31:28 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        aolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v1 net-next 1/1] net: ethernet: ocelot: remove the need
 for num_stats initializer
Message-ID: <20220430223128.GB3871052@euler>
References: <20220429213036.3482333-1-colin.foster@in-advantage.com>
 <20220429213036.3482333-2-colin.foster@in-advantage.com>
 <20220430151530.zaf7hyagln5jqjyi@skbuf>
 <20220430174735.GD3846867@euler>
 <20220430213344.ifiw2wjtxqd2dqbj@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220430213344.ifiw2wjtxqd2dqbj@skbuf>
X-ClientProxiedBy: BYAPR06CA0046.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::23) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2582e727-2c08-4227-7513-08da2af92d0f
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2407:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1001MB2407226026499AF6E2E289CEA4FF9@CY4PR1001MB2407.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pOeARJ9126AAXrgbd+r/HwHxzNuYJ8iVIlNnrJZSWWC2cpI9TTg0FQ69L0V+umKgMkv8Ljwk8Ik8i653ZjOgYNITnKlpJ8OQk7tZPZbSQUQIL53+/d234yyEWZhCecoUmj5Ef7H1jZluf96Drkex0qPKQ0KBlU25wvZkFy89B+tUyWaQnNN+J2lcKYvyMDHWWQWJ5H67b7lNHd0zRxw7ODCz1z0V8QS3kY8xHZWukQXc4ZcDWMeO+WbK0KBUGHXK7GdsflC2rHhKUksCy8MWgfJRxW+DiZApN1RjUMWpcNqRcNLGEPvuW9K9/SaxZS3pGtIIjZOwbR8G/mZ6rsc9YFI7leabWEU9J35+8RlKUuS/iKpLRSVvr8x5/xjX1nm7RIBHcjMNODnyT86Wu7lslOdZke/RV7+NhdXg+iP/f6OTmmkpwOEf1kLfWsKzk95yMOk9mvfL/eu0NLErzPbLiKSBVYTRgaRdjnrh+l22NhGLu6ELj/Y/7T6zmKXykqsK07mp94jE8K4JjhJa/YoYvfq6yghLO5kY0pVgl6PH0a3fmegk3tcaAHpnxJrIpe0j23X0vtCWcQ03FmucC8Rf57FqQdiTpfBHarU9TYqD2A+8y3Mwazgm4q3tXDZrgPN3EeNEr11qAZTh8WDQke0gnvX/cFYgp+h88UTyM8z86dnw/itu2BkSdYp62WMPCw9++QptwdCeUse+d0yTk/kRjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(376002)(136003)(396003)(366004)(346002)(39830400003)(38100700002)(38350700002)(7416002)(33716001)(4326008)(66556008)(66476007)(8676002)(66946007)(2906002)(6506007)(5660300002)(44832011)(8936002)(6666004)(83380400001)(26005)(1076003)(9686003)(6512007)(86362001)(52116002)(186003)(6916009)(316002)(54906003)(6486002)(508600001)(33656002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iTO1rS2u95aHIHWiRilHW89Plh9Egf55j51KSpj/jJMDPL6rke/Z+7XBauii?=
 =?us-ascii?Q?YLT/JzzH/4AcW/q2zCECSbc3hVU36RkYpKDIsBa3TX7Vbcilz1K3QOqRed11?=
 =?us-ascii?Q?6Op/J9sMKypD11VIehVxLswvV9jXDKnIvslYsv8QiG1jbGo+Uebn9p4OwEFI?=
 =?us-ascii?Q?n6B7rGXVhdbVlr3ULFjNt0QjEySc67GlnixiR5+6cSSrWPwMs02Sxd8hhVNO?=
 =?us-ascii?Q?y2g98RDXcazNIahJWyyAqG1GcD92aeQ/yobEcoVnXkYvTK5splbtgnuMzl0j?=
 =?us-ascii?Q?iZmXS63ogLZ/XQ1eodhEz8vXS54Z27zB2zav7U2+mfe9PH2+Wwow/HGWlZDy?=
 =?us-ascii?Q?jK+NWU14rbRTRt2zMXKk8a0IK6wl/LpGqgKzp/JfvZMWXsHjNvT+jLqZkgFs?=
 =?us-ascii?Q?M75bV1V6mJ2ynahdbjhdAnQqr8UUA/5SKCRwzfpgk9QfV67RMrr4IE6CXdum?=
 =?us-ascii?Q?zPs/ib0PRW/gLP8+U389lU5iQltHBxAQMNHd0KTBXPYvsnXKNB5RTi2ZpUSH?=
 =?us-ascii?Q?6hKZ36QP9Hq1KCX8u3A9eO+8h8Fht7WYTdQ/2VNMQEKcv7qcBRCVei/5qJ88?=
 =?us-ascii?Q?ZoeMRhNy98U+g9QZKzzt4jF3R4PtMNmSlbFCbzfNtbt2wxYHOWwU9GzK1Kgy?=
 =?us-ascii?Q?ZwEo/fMw+MTYZfBVoeeA1IidJMSi6aB8duBdEfUuzhTz5kXYzi1tf8lYdbkL?=
 =?us-ascii?Q?ZwkMlBwc2oth5afOa3FNbfSAbpPDEPamD2zBPfmmW/oPBNO6Xp9p0qmHXAei?=
 =?us-ascii?Q?x4b1CNQN0xAv9fyh8CT4+z4ypgcJEc/26oBxxnLsJscKc89DyEqAxk0aSpUl?=
 =?us-ascii?Q?mGhBlGmDcMJheOcfKH1Jwqs/sfxy2L6i+GxGudfCoQZFWuabbFFSgqucUpAp?=
 =?us-ascii?Q?6gKJZnBTYCYWGmVtGf8H9fWN2kb4HUtfNivf0x99nmwTG41IKaWHn/jazPJ9?=
 =?us-ascii?Q?OJutT4rWDj1ifQNg8/zcCYHkoUa4hoGcLTHoZgX8P4oZxrTu5/uLAv9nvvXg?=
 =?us-ascii?Q?2eap3ZZrrinFicDrRDKU7/OdRcX5+22AxOkJN9ha1gcMCUbY1cjnKMdxIXB2?=
 =?us-ascii?Q?PVUFJu0qZobpcTxhj9D6/G55hxdV6ahWEsQ31rNFlyJtiREg6+lgLlp8W3xM?=
 =?us-ascii?Q?oYHYOwLbSrCVqV++hQZAY1CbDCnG7ahncrpyT2uzcpyJnOxFxttZq9GJvNi/?=
 =?us-ascii?Q?nA7IuqZL6sP9uRDPoWF3h/QUTEsq5Fi/M638NuLljfItg1Bz7w6J/w0s1Abd?=
 =?us-ascii?Q?lY28ZVx6ro9lPyiJfrKmqkOYDjYN+1UNIrtA15WxENXJrN6s5+dOHEQcFiFa?=
 =?us-ascii?Q?YPmPvdYGChlK0qd/dbcRi6F43AN1NvcyG+ux8x5Yq754fEWAZfFfceNkiqZv?=
 =?us-ascii?Q?JoPATOe2EV3bPaqNeAXhZW4ObFqrPp7EOhs8rCPkjFvOIeXdB0eL+U/cd7iW?=
 =?us-ascii?Q?CQvsbwjBUV3DWSvoemmLA1LSAnFC7lArPMXMLHc0ER7qpKfDB0XJXuaYoIul?=
 =?us-ascii?Q?95sMS1eb9iq9NT36leJgAaPrh15kOXJZWkCgYY+MqPw+BhaDGAs1P/Fb1aqX?=
 =?us-ascii?Q?w9lp/cJKoPT0GFELZpGRThZYZOoPZtJWyZxlfS/jjzuKwvps1s0fFj7+bCsb?=
 =?us-ascii?Q?z7sogBGncRwEyyg1Kv19S0NxhrJy2ZNH0hqn6tdQBnAXlSLpqxwzDGosbcxM?=
 =?us-ascii?Q?v7fmnZcb8GrJJd7ms4+ojCN3/GcnOhReQ+hwKttRWcSBZ/IrIGWUW3vhGjuk?=
 =?us-ascii?Q?nXZu4lQBAZRVI0zCblqC6rDjDAWqSdvkIHz3pmOVoTYzk33BUd53?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2582e727-2c08-4227-7513-08da2af92d0f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2022 22:31:31.8963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VDtAx3bpoe82+DKZHHHO+89FHftn6Og4OjDGmC795auzqcznpajVYbeHaHNRTdZK9zOOfR1cZLa5LPgO9/mmeS0zw2pxJDsm255HevYqUeE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2407
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 30, 2022 at 09:33:45PM +0000, Vladimir Oltean wrote:
> On Sat, Apr 30, 2022 at 10:47:35AM -0700, Colin Foster wrote:
> > > >  struct ocelot_stat_layout {
> > > >  	u32 offset;
> > > > +	u32 flags;
> > > 
> > > Was it really necessary to add an extra u32 to struct ocelot_stat_layout?
> > > Couldn't you check for the end of stats by looking at stat->name[0] and
> > > comparing against the null terminator, for an empty string?
> > 
> > I considered this as well. I could either have explicitly added the
> > flags field, as I did, or implicitly looked for .name == NULL (or
> > name[0] == '\0' as you suggest).
> 
> No, you cannot check for .name == NULL. The "name" member of struct
> ocelot_stat_layout is most definitely not NULL, but has the value of the
> memory address of the first char from that array. Contrast this with
> "char *name", where a NULL comparison can indeed be made.

My apologies - I had the structure wrong in my head and thought it was a
const char *. Checking for NULL is clearly not an option.

> 
> > I figured it might be better to make this an explicit relationship by
> > way of flags - but I'm happy to change OCELOT_STAT_END and for_each_stat
> > to rely on .name if you prefer.
> 
> I would have understood introducing a flag to mark the last element of
> an array as special (as opposed to introducing a dummy extra element).
> But even that calculation would have been wrong.
> 
> Before:
> 
> pahole -C ocelot_stat_layout drivers/net/ethernet/mscc/ocelot.o
> struct ocelot_stat_layout {
>         u32                        offset;               /*     0     4 */
>         char                       name[32];             /*     4    32 */
> 
>         /* size: 36, cachelines: 1, members: 2 */
>         /* last cacheline: 36 bytes */
> };
> 
> After:
> 
> pahole -C ocelot_stat_layout drivers/net/ethernet/mscc/ocelot.o
> struct ocelot_stat_layout {
>         u32                        offset;               /*     0     4 */
>         u32                        flags;                /*     4     4 */
>         char                       name[32];             /*     8    32 */
> 
>         /* size: 40, cachelines: 1, members: 3 */
>         /* last cacheline: 40 bytes */
> };
> 
> For example, vsc9959_stats_layout has 92 elements (93 with the dummy one
> you've added now). The overhead of 4 bytes per element amounts to 368
> extra bytes. Whereas a single dummy element at the end would have
> amounted to just 36 extra bytes.
> 
> With your approach, what we get is 372 extra bytes, so worst of both worlds.

Understood. I'll send an update momentarily. I also didn't know about
'pahole' which looks to be a useful tool!  Thanks again for the
feedback.

> 
> > > >  	char name[ETH_GSTRING_LEN];
> > > >  };
> > > >  
> > > > +#define OCELOT_STAT_END { .flags = OCELOT_STAT_FLAG_END }
