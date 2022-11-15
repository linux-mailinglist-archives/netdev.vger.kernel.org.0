Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2DB6290ED
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 04:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234078AbiKODoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 22:44:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232549AbiKODoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 22:44:05 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20726.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::726])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76FFF19C1D;
        Mon, 14 Nov 2022 19:44:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mvsv4EJwlidt2LaQitCeMx3pHJ+/oIrauIDEwnZGO4oQizT3AIYwuQEf13BKTRrxuKaMBh/jJbnI42TfgUyukm79z9YQlp/c4MFF6gwVVTAefOC7f8j9ETzwmhC7pR5f2LUL+iTxaZFmiYv9vHKxdz1ZURkaYBGpDyDmhaiOO1F30hpiLmLUoz8av9KFNyshXBBpogLHR4EjpWRrsKNo7X6zvQt6HxevflQfsjU4UjDv9hOxTgi71qZVZGpBgB2GyLf6NhzoLRCP/R4pMZ3ePEW/p2kAJheVIhdDNCwRkN4CgTJBaLm99oCixHOQNGWnhzumkL6mvZDKZ5bs4jKJRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9zVAOhc1LFuzqIhjXRhtUr1wA8Ea/cFj/pr1fUUfVNM=;
 b=mlTNH6YZQ0IhHSXlfMJYoPVLT/m6OAM6SWS5HRnKoJtnR9FFLTpd+wA3WimfWr8NolNHqaTQR9rWLeh1mpL5P2MUvRGjixBky1RNddvzpuKEHbNNhPEkISnq5NOYEEJLhZwCJi42t2kLuVBWRDn2DsFR+hvvPcj5E3vmxK17Iq8GTD8qg1fvUW/n6owqIw3dwdqcZwCFg44DWCAGKVDamCrBbP6jxI+0Cf8Say/gmo52odA3gA1GGzyd/p4lKZPs+W4kGWUxqbRNA8OMtyJ8UQAyHnkGEc/ReEnVHR5oFzkuvETnJjqU3KIwSrJD1dB6o1jXvx0e+UkV5ZWWeI3c9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9zVAOhc1LFuzqIhjXRhtUr1wA8Ea/cFj/pr1fUUfVNM=;
 b=UdPStbHqBMeTZ9AVPkY0lN3Ax/yUXz44UCldHKVGKtTJwGt1w9PlJHf97EbsAOvlgk8/ardwCvnQC+kYIJkZOYiW7Z+OdLaix04Xkj5KhWeMBXjz1TeusRAK42t7eafXFbRVjcRXXQbHqu077Eh2eQ9Tm1+GlI1Jyq+GYwDQU0c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4411.namprd10.prod.outlook.com
 (2603:10b6:806:116::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Tue, 15 Nov
 2022 03:43:51 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5813.016; Tue, 15 Nov 2022
 03:43:51 +0000
Date:   Mon, 14 Nov 2022 19:43:48 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH v1 net-next 1/2] net: mscc: ocelot: remove redundant
 stats_layout pointers
Message-ID: <Y3MK9PCz0JQSQNiQ@euler>
References: <20221111204924.1442282-1-colin.foster@in-advantage.com>
 <20221111204924.1442282-2-colin.foster@in-advantage.com>
 <20221114151535.k7rknwmy3erslfwo@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114151535.k7rknwmy3erslfwo@skbuf>
X-ClientProxiedBy: MW4PR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:303:8f::26) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SA2PR10MB4411:EE_
X-MS-Office365-Filtering-Correlation-Id: e904dab5-7937-47c0-0fe2-08dac6bb9c74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ek/kSd37E2sSv0hWx0ipQSUgWDKVZXRPLvu5HMNCHNAVK6FYwNMjexvvlTiBrcd2/bJOg+QXV2EbbBg/lCSbK0OellH98Q6bQBU81CjjRHEeu0LLNxrwSjBsQJyxeLCJAWmg/xHZpSdOsQ/r5+xUU/aURaBFCZvtyTBNq3/MwHE0MmTYrQDl+2g9lrKPQgIn+h+XvT7Z5ZaBcZjrTwlVe0DFEKjPIYC8BcwoSoMz5yAxnWKtZL/xVtY2i2bOILAJ9/nWSd6iEn5rqZ4+GSX1e8AcBm74eXWM6BOe7FV5j94xFHtVMOdEfh9Db8gZh2kvdwexcB6KwWUZEJeLsTthDLv+GBiKCQrP+E44ZLQDc8L0TPF0PuqoQycVqMXfU0fVVLrWxyouqtRQvgCuD5xdnRRKGwNL56+yxDT7BLPh9XTbjceQ/LmwjjQR3/PrZJklCSSbneaNEht2cC4Hbz+ZSJCjoGzRsV1aOuXdWZl9PqF6VzBtsGurqwjA5U6b7TOmV/GEd5b3Nkil8ba76HTwzf+uTfLqNTtWAi1mR5EfKClQCADKAFt4Vkkab51dybm9s0qsFf4DmoF+lKUjqk8m91SB8pDV0ewm3EvNnF+cxkH8WMvLxD9/+Fn+FJGIxgYi3xrduCV4PFd8zO8cZs58UP3gwpQBv3j32NFfFBWS+Ww235hBnGd0W8vLHJr9yIHNXh7D6yxGnMFUkBim8WksPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(376002)(346002)(136003)(39830400003)(366004)(396003)(451199015)(38100700002)(66946007)(86362001)(316002)(6486002)(478600001)(33716001)(66556008)(2906002)(6916009)(66476007)(41300700001)(8676002)(7416002)(5660300002)(4326008)(8936002)(44832011)(83380400001)(6666004)(54906003)(6506007)(186003)(9686003)(6512007)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F9NVCw7sQddeaFiQmugMpoGPIp3KCaKHib/Yc7XOyBdt4X+wuEVU69pQA6kw?=
 =?us-ascii?Q?naf01dTxe1vWzlZMqrVsYPBnyrQi+whxFSzUCZhbIb3xhRJs6TVAdujImjZc?=
 =?us-ascii?Q?XIV3Qahfsj5AZIa9xbiLlO3BV1wRv+WvwZ9cmuw5KJEAj/ZvaXnWiedDrIzC?=
 =?us-ascii?Q?bB/3EjeDICNPIGdehlzF/CoKQYVz1f/cy13UZrpW3812J7kbtQ8tVj0f3YKU?=
 =?us-ascii?Q?ydWuhqRbpwLLGoALfZi7dHjMRqxKrlZR0WyvAT4MpoQnAGw6Nj3uohOG4qtv?=
 =?us-ascii?Q?HGyUJwUzzqIslBKogdae2sha5Cgz7+v3LtkF12N5l7b9CLXlfsmRk2ju1SI8?=
 =?us-ascii?Q?/wUWQf7saUgl3FdQJegIrcLHZiI/GF59Ze4pxv/tRZw+udLe8Gz6j9+fdO4K?=
 =?us-ascii?Q?ZHlumxaMjvkcmwONsKY5zaPvj/yCsaFZnsjipC2GCV7nDq806/k5JWecsoFI?=
 =?us-ascii?Q?VBqzRaYxlt3Sgu9irU42KjGVOebzF69629jaAtB30cLTov0lVSR5S9s0r1rf?=
 =?us-ascii?Q?TNZBTTVnYvx+7PzC6UwL1QupvLR/sO+b/Yw3QWMvKWqpbFkGbf+JpXbT+c8+?=
 =?us-ascii?Q?hd3hX722NvLbbVK7Iv8FbBZOs7jJ6avbSUR3G9mJJ/ny6Ep0OEqpkQfQMJzg?=
 =?us-ascii?Q?cFnieZ8ARAHGHPBRCfXzgkynamEM3GSxf0GJwBkFRIGIw6WYQnGy6dtJ9+dn?=
 =?us-ascii?Q?4iNLNBchlgTxBNgX2mcYWQramhwFcix3yJqQ82O6d3mfmbgzOfinZxfWMfEy?=
 =?us-ascii?Q?EfWwnyYNbLbTkSton+pZG/lRmfgjpE7aYlE/36SoLFDMOWpvnGzEhSOy1QB1?=
 =?us-ascii?Q?d3HwF2I6T+gJoYusvKQalPGkEId3FeJiOSnP1wSsdNXaHRXSZobdtL9xhxLn?=
 =?us-ascii?Q?mySUSsvdcNn0fn1Gyul7TMvIH20huljdDrz8FKKpE5sbI1h7EKJC+3oQiSQh?=
 =?us-ascii?Q?6RYU/2h6mDHvC1VCxR5jgXiFRFz2vjnD57r3zgnQ2tOsiwRi21z+4/Ldx9Rb?=
 =?us-ascii?Q?ifIi5kQTP5Rp8AHelwBkESGO6HyIfh2vC/HGgmyBMchwGJrvFLFcXrNH0Rv7?=
 =?us-ascii?Q?Q/pwqOK8U4aij3Cs6w6ki6m4Up04FoEs0chhUXqJKLY5tYPeo9XupWxH2zUc?=
 =?us-ascii?Q?cLpnNBOZTxZPkMMtOrDq8pM8KxpVS0egwKJTj6SaHxEh1UKPWZrqih24Ndg4?=
 =?us-ascii?Q?4rLrq8adtK+0Q+B/rLvHNSlzGv7zR27uwdcoKzVrXhaI1sHiXD9Sx/ELvT1q?=
 =?us-ascii?Q?Wi6jsGMR3HZpLOy/xfrVCVUiclaJ5T+SJIGq5WwKvMEB1hUWqvzEIiyYCgAw?=
 =?us-ascii?Q?pN63KcrhIGg+muzZ2SIoIwDIf6wMoRcaA3DQBJUHqOxk5qWN5YDZyEdDUUi+?=
 =?us-ascii?Q?Krr05uCktJeA0HwYM4RAOb4ksi4krFYc24/KShi89UJ02cVDSSX93xSuJOaJ?=
 =?us-ascii?Q?Y1JKAMjHk3m0X+7BZzk1679Q2sPV0phin/6ymVMI5SpGX6JBYSOnvfd6q7Bw?=
 =?us-ascii?Q?FJAukqvHmDc92fMQwpAL3w8rKIez2pgyFbbXnMbG6GZELRpIjtxk06HL8VjV?=
 =?us-ascii?Q?EwDEQ/lYjO6xJdYAqLHHdRYptFGAv6m+OzOlJ/OGm09hfTG0nmB+18EcKfam?=
 =?us-ascii?Q?kw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e904dab5-7937-47c0-0fe2-08dac6bb9c74
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 03:43:51.5038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QO2245com5CfpbJoKQAEKr+4tG2RAxeCuoYtAdUtj2gWY+/R6wyAd620q1AyqAFGuUYsNbkW0/d6xsN1YctYPAgTs7kPUblPU7BOMvQ/ZkM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4411
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Mon, Nov 14, 2022 at 03:15:36PM +0000, Vladimir Oltean wrote:
> Hi Colin,
> 
> On Fri, Nov 11, 2022 at 12:49:23PM -0800, Colin Foster wrote:
> > Ever since commit 4d1d157fb6a4 ("net: mscc: ocelot: share the common stat
> > definitions between all drivers") the stats_layout entry in ocelot and
> > felix drivers have become redundant. Remove the unnecessary code.
> > 
> > Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> 
> (please also the Microchip development list, people do seem to follow it
> and do respond sometimes)

Apologies there. Honest mistake, as I see get_maintainer was working.

> 
> Before saying anything about this patch set, I wanted to check what's
> the status with my downstream patches for the MAC Merge Layer counters.
> 
> There, vsc9959_stats_layout would get expanded to look like this:
> 
> static const struct ocelot_stat_layout vsc9959_stats_layout[OCELOT_NUM_STATS] = {
> 	OCELOT_COMMON_STATS,
> 	OCELOT_STAT(RX_ASSEMBLY_ERRS),
> 	OCELOT_STAT(RX_SMD_ERRS),
> 	OCELOT_STAT(RX_ASSEMBLY_OK),
> 	OCELOT_STAT(RX_MERGE_FRAGMENTS),
> 	OCELOT_STAT(TX_MERGE_FRAGMENTS),
> 	OCELOT_STAT(RX_PMAC_OCTETS),
> 	OCELOT_STAT(RX_PMAC_UNICAST),
> 	OCELOT_STAT(RX_PMAC_MULTICAST),
> 	OCELOT_STAT(RX_PMAC_BROADCAST),
> 	OCELOT_STAT(RX_PMAC_SHORTS),
> 	OCELOT_STAT(RX_PMAC_FRAGMENTS),
> 	OCELOT_STAT(RX_PMAC_JABBERS),
> 	OCELOT_STAT(RX_PMAC_CRC_ALIGN_ERRS),
> 	OCELOT_STAT(RX_PMAC_SYM_ERRS),
> 	OCELOT_STAT(RX_PMAC_64),
> 	OCELOT_STAT(RX_PMAC_65_127),
> 	OCELOT_STAT(RX_PMAC_128_255),
> 	OCELOT_STAT(RX_PMAC_256_511),
> 	OCELOT_STAT(RX_PMAC_512_1023),
> 	OCELOT_STAT(RX_PMAC_1024_1526),
> 	OCELOT_STAT(RX_PMAC_1527_MAX),
> 	OCELOT_STAT(RX_PMAC_PAUSE),
> 	OCELOT_STAT(RX_PMAC_CONTROL),
> 	OCELOT_STAT(RX_PMAC_LONGS),
> 	OCELOT_STAT(TX_PMAC_OCTETS),
> 	OCELOT_STAT(TX_PMAC_UNICAST),
> 	OCELOT_STAT(TX_PMAC_MULTICAST),
> 	OCELOT_STAT(TX_PMAC_BROADCAST),
> 	OCELOT_STAT(TX_PMAC_PAUSE),
> 	OCELOT_STAT(TX_PMAC_64),
> 	OCELOT_STAT(TX_PMAC_65_127),
> 	OCELOT_STAT(TX_PMAC_128_255),
> 	OCELOT_STAT(TX_PMAC_256_511),
> 	OCELOT_STAT(TX_PMAC_512_1023),
> 	OCELOT_STAT(TX_PMAC_1024_1526),
> 	OCELOT_STAT(TX_PMAC_1527_MAX),
> };
> 
> The issue is that not all Ocelot family switches support the MAC merge
> layer. Namely, only vsc9959 does.
> 
> With your removal of the ability to have a custom per-switch stats layout,
> the only remaining thing for vsc9959 to do is to add a "bool mm_supported"
> to the common struct ocelot, and all the above extra stats will only be read
> from the common code in ocelot_stats.c only if mm_supported is set to true.
> 
> What do you think, is this acceptable?

That's an interesting solution. I don't really have any strong opinions
on this one. I remember we'd had the discussion about making sure the
stats are ordered (so that bulk stat reads don't get fragmented) and that
wasn't an issue here. So I'm happy to go any route, either:

1. I fix up this patch and resubmit
2. I wait until the 9959 code lands, and do some tweaks for mac merge
stats
3. Maybe we deem this patch set unnecessary and drop it, since 9959 will
start using custom stats again.


Or maybe a 4th route, where ocelot->stats_layout remains in tact and
felix->info->stats_layout defaults to the common stats. Only the 9959
would have to override it?

