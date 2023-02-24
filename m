Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6753E6A1F72
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 17:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjBXQQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 11:16:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBXQQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 11:16:38 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2049.outbound.protection.outlook.com [40.107.8.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BDAE658C3
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 08:16:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bwTjs/WhGU8IAKlMC40W5BYJQtYdlsXZYVoxuOK81EjkY/pGg3KE+6qyYlXBt+7JURUogwCrJY1DGGG9X0hCTFQ5NX397nMNMJyGFJXDfDB8lamysPveXep5NDx7hic2K1LrtBKWo8REIubRd4g7mL4X1oW0z5ANaV81mtK4MdKTrLouQiLQtNc5h8DMy3PizzExerd0q0IPi0PaICGZTCrJd4Yri5g7NZuHnzPvZ7sKIzKHOV3MWpVyz6u5kILdM4z5MKkZuPl1ebgr7R4wanGhW6KiOZb67FQk0OfBxkh0GwRBmCr19v/fosKoHG3fhRHTpFlDT7ep7/W9DZ8fwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oQsJrAgvpr9fvOE6jzTQ+iN3VvhPSnPX1f+AZkqq5Jo=;
 b=mr5Sc/4JZSVeANCvy323CRYJMZ0MlpDM3QvdnhseEwcsaM9Q5NzX+0oBEFQiVao+VTP+kAXvDbGlJMSH+41s11R00suYNs6JC0H2iOlggCCPKbYAPKoUviAO58SNuM+AdXkQb6POvVp5A0sIFmb6ny/EY/aOo7JYNi78g43adFUD92nVkaaxE6mA+0MOqHKzKgMCj1SmqYrrrXmLrTAFkmMVihSg8QsO5bo1HmwBxD5HsA47PNmu1TPY4NNaQog8X2JTJdQ1PbJnFrKB8q0RrG056Yu3Gkk0Jt9dtGNV/lCck5SFmXhpVCOlON2pio2LSfCRPW3wE93DslnVu5qoKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oQsJrAgvpr9fvOE6jzTQ+iN3VvhPSnPX1f+AZkqq5Jo=;
 b=h8ecIWOjr0eIU91/fE5yJS5Wkwrl/F5/K7fu9/PXMYrk1G/PRq0kpM+gxMP+90ggltoHSQmSbsJNqnvaxPEaoKv55YwyPO6xrgX3tIxN7oGbfW7BlGkRZJ1GTp+mKXsF7Crp+Mw9y5rETIFiuNcpOyTpW5VyRV9cQFExjp7cQGY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DB8PR04MB6955.eurprd04.prod.outlook.com (2603:10a6:10:11d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24; Fri, 24 Feb
 2023 16:16:32 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%4]) with mapi id 15.20.6134.019; Fri, 24 Feb 2023
 16:16:32 +0000
Date:   Fri, 24 Feb 2023 18:16:29 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Lee Jones <lee@kernel.org>,
        Maksim Kiselev <bigunclemax@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net 3/3] net: mscc: ocelot: fix duplicate driver name
 error
Message-ID: <20230224161629.w7onocrzlokqmglh@skbuf>
References: <20230224155235.512695-1-vladimir.oltean@nxp.com>
 <20230224155235.512695-4-vladimir.oltean@nxp.com>
 <Y/jel+aPo4PkWc1g@shell.armlinux.org.uk>
 <20230224160920.cjia4n7zn3jm4nyd@skbuf>
 <Y/jiYdNjaeqPAfO9@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/jiYdNjaeqPAfO9@shell.armlinux.org.uk>
X-ClientProxiedBy: VI1P190CA0008.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::21) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DB8PR04MB6955:EE_
X-MS-Office365-Filtering-Correlation-Id: e1c8e048-4233-4a90-2a5d-08db16827e4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: apa/aaRkLlRXrPxRyBzNtM9A+o5TXnQUlsesj9ijXaq+1MZJrNQXCgkeSmdi7rsInkNqsKCzcQ2f6M2hvcXbW7IH22cI5xK+CHQvJwzb4j4hy9KwdHV49ky2yZ4mIDd6DkiZ7ZW/ttk2vGyplTGGBsZTFN9/JSlMpsjKgI+ITiYDqkF63xQlbUBwvn4gBu5DJkI9umeZ5xXbGHKU3I+XzIjief4q+z9ZOc6AFAMoq4AfjREs/KA59ytpog+U7cs9zf8Oq8cuvkEEJ8PNWPD6WphzLUgz2R69UZmlf8lsuWVNnrJ46EzqgB0NcTScZOv6mSyPZ2N25Nm7uwJhVJAwbohmxLPt6gigleioq5fsV8hCiYz0cxqpWE5ZDnZO40IeECYIQOdmBtKl9lehQ7wqt1+84RpJUfo2pLnUa/hhBgRqqboj39Q3TXEC4C/NjjVW+KoDHAz2ZElQ0rPJyqgQPXOQjgaU1pOhf56AC4uA87MqXZurgVd7+sDmlROMqK89qQN+XPMgfeioDcqxVtcYN0Z3acQ0PPRkX6GxzpOm8xN+seAO+ttW2/ZAf4dGu5Oo4O7sdNzWLuRGRkrvzwwifH7CubU8YwsZ9U57I4EvehSW5AjG5fPnUTYTDS14rqPh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(396003)(39860400002)(136003)(376002)(366004)(346002)(451199018)(6666004)(8676002)(54906003)(316002)(38100700002)(478600001)(7416002)(44832011)(5660300002)(86362001)(83380400001)(66556008)(66476007)(66946007)(4326008)(33716001)(6916009)(2906002)(966005)(6486002)(41300700001)(8936002)(6506007)(26005)(1076003)(6512007)(9686003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ovZszHw6AWv6cfJBi4Gq+944d/9SqXVeI22stqt+P+pYTdfK88EFHyK3i8Yl?=
 =?us-ascii?Q?UxaY+u2fhy0Z5chT8ZeyFZ9FStejRdZwqBOmFGyPIeqwk5ZpYYCaV4QVxhpA?=
 =?us-ascii?Q?lHN9FolkH2zII5ZJs0UsHzden0y+ABgiJ4dJ4MMQhw9OK+V54Deshq27KnTS?=
 =?us-ascii?Q?3GP6CzMJWXUjJpyBqQIU+tuwsTx3oclCq14XNewvFDhpcwsEK/ordP5Pri2w?=
 =?us-ascii?Q?sS216cC2QDusT3kb03sn5xGK2JwBM8C96cAwX+VHHFgyLX0zsd1K2Q5gTkKQ?=
 =?us-ascii?Q?BOObI+QzqkDeFPMi4/ZlmqKiPHHpWhZ2W0VkWXpU7SQOsQNi7j18b7i312sW?=
 =?us-ascii?Q?li/bwquFkcfLXVywZhPSOPOH8uOy586b3SZKAqhKMGYakdXOgJ/YlF/5c8+d?=
 =?us-ascii?Q?u8ug/D1iPI/STuxTpUXmQBwtZUPQ8DU3JtNMEj/lVCmzMGV6ETExc73MXewM?=
 =?us-ascii?Q?JSlve9qq48N6kGzFGxY61Pn8psm9KyShVON6IvatGEchXSgNMW+f3Y8Xr6zQ?=
 =?us-ascii?Q?/7FMMMFz6L/BNKo9KARzI95XFvR0L/MwtaLZPx3YOgT67tw8ioWIQrzuFNnW?=
 =?us-ascii?Q?6+bExF9AYNAOOauW0sjNcBFFxOtPwZQjchsEmnM4wzMJV5LdVFZTxF4p9hU1?=
 =?us-ascii?Q?TAm/3D2HIhxV6CVbmyBTvX0ROqhjiD6BJvuno1M6l/Rjz2VmLQAgvCpZ2Qtb?=
 =?us-ascii?Q?M1UHdftjUbC6Uwq1cF6reUq9hkIy8T3YRBHI2Dzhd203dcbSwBg+GMfID/8m?=
 =?us-ascii?Q?aoVzCWPPcOHbWgLX4GUgKZ7LoczQ+AtHT9YPOWYCit+0wmwB0h2gbkVoQiDo?=
 =?us-ascii?Q?bLsFMcZxD6q1Xmkoy53YpeLL9ItVTt1kMdNayTXyTbZwiqUAoBcKcTk5x4b8?=
 =?us-ascii?Q?5w4sV+XqWbsHMDciZx8BV0yk56/vpqJ7xNqA5P8/bbX9fPF5SuRj40ALVtRY?=
 =?us-ascii?Q?jFhQtMC5hjN9NNVOViA/rBVLG8NoJn+bpgMhX7G6wiRjzLfzgwKEkQH5ivAn?=
 =?us-ascii?Q?N3/RMQaXHX08rvRUNPteUgY4EDerYBsVr6RNPkY1+w/K5bqclNGBpnFIFaY3?=
 =?us-ascii?Q?9XOwFsZGPrtJcvIdm9Q5zlhXay5HYxEuFBELoQjN9+VHRQa8J+ArV/VBNeFT?=
 =?us-ascii?Q?CH8iSeoFVYK2ZSkoEiqs687ESxpUP6hXmTK0OleP0Lz1oOeI8WOoPQMxbOZz?=
 =?us-ascii?Q?6PdDyZ9BBjeyB9dB6TN6W4x+xID0QnSdgmuEybtAV/hyAyjTOT+5Px34bGtG?=
 =?us-ascii?Q?OyEHrHVBkBiityrMjHprDs4nFJRDZPCEOwvk/z615CbqzbkgsVAqZWkfGC0y?=
 =?us-ascii?Q?oiyQh7Ga++ZJIqUFpXoNGnGi5B7v4EvAVO4PZWfGzvrsDGAeT2RahgFlMOCA?=
 =?us-ascii?Q?9APhOpbfF9o2lkHDXtx0U2bhc6j5uRIlFbCfdfjIIXAHT5F4TjPxiSQ28e1D?=
 =?us-ascii?Q?A5qLDCPZ5szaZnQ1coipvBOx8p8szeliNc6PznueUXbqrEeLgtlRD6ZOWcVh?=
 =?us-ascii?Q?pBIR5jPheJhRf3//mB47LvMRaLiOaaNLeN0bGKxVLCh4w7Q6HPhAYLxMBc/I?=
 =?us-ascii?Q?XgNF9AzRVSPf8y2//kui9VWlYzLs/13Fr22blxVmxa9A4stOw24nrvgx7rXy?=
 =?us-ascii?Q?0Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1c8e048-4233-4a90-2a5d-08db16827e4e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 16:16:32.5231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NRI9N/ckD0P7vE+aJ3C6D1R76PiBts1v2z21Oea+LIhEjBNNBHeM3+g5rumigKg/+oV2n7pMiAidKufqMPtvCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6955
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 04:14:25PM +0000, Russell King (Oracle) wrote:
> On Fri, Feb 24, 2023 at 06:09:20PM +0200, Vladimir Oltean wrote:
> > On Fri, Feb 24, 2023 at 03:58:15PM +0000, Russell King (Oracle) wrote:
> > > I'll also send another patch to delete linux/phylink.h from
> > > ocelot_ext.c - seems that wasn't removed when the phylink instance
> > > was removed during review.
> > 
> > Good point. I suppose that would be on net-next, after the 6th of March?
> > I just hope we'll remember by then.
> 
> Yep - however, I'm facing challenges to build-testing it at the moment
> as net-next is broken:
> 
> kernel/bpf/core.c: In function '___bpf_prog_run':
> kernel/bpf/core.c:1914:3: error: implicit declaration of function 'barrier_nospec' [-Werror=implicit-function-declaration]
>  1914 |   barrier_nospec();
>       |   ^~~~~~~~~~~~~~
> cc1: some warnings being treated as errors
> 
> ... so I'm going to send the patch as untested.
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

https://github.com/torvalds/linux/commit/f3dd0c53370e70c0f9b7e931bbec12916f3bb8cc

Can't deny it would be great to have this on net.git ASAP :)
