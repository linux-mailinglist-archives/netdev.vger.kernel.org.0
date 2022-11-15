Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 221D762A000
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 18:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbiKORLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 12:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiKORLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 12:11:08 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2090.outbound.protection.outlook.com [40.107.243.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49A22A24C;
        Tue, 15 Nov 2022 09:11:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l7pzIG8o3qyRjRjfVCZJIVQUMOMqDMsRlGPEMCGxcEXEvQWQ0DSE/fkbEGO5n9ChvTOkSuFk5j7vac+cJ+6pw8L770ifA32fmCSvYlH2msLW79yADqT2FdUG5YkbByBbFtZprTvz4Qu2aM3CUS7JWGql1rD2krum+qqBvIJNPNFm6zf17OXb7cmQFkXgkNcR3Xd0GBwADRGRfHcYlXTUude1K+7BZYVdZ5FKaZcafnTSdiNSD770/ITjnSrPF7Kvaqm+VO87mWEGIwuMWlL+HcyKpWGhjESi6KCyhktJVYPhMT37hqVsfBkgKi+ozkyRKztt8ojTbSqJsv7Nf7Rixg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=23f9wa3u3JmvcxPtGXvwR0AVU3ysenr4nmmrqIAxbok=;
 b=T3Lvk30MYe2sbxSn2bft6uytqgE1KbSk2y5tzB/CmfkCPdcGQs/mQ2s5bIAvqwnEtwVWEtzvUDaS9OE1fuXYlDJ6+x5gl8lvfJbnsRmeC3/+3sphajUVrvar04d7/J3e+Db/XPrf6AsmUwN0ROm9c0RWX/e6LO50PjtHL+orm69yURxp45PliGA9qIaTpVKWjWnE7IiV7rAwexWwrAXJYkuBtskpzXLLB1rhB/N3+khQYPeeuBzE4HU4HfPjDFDUdWLO2aOrFwdZ7b1bafq1E3ajREXyO1F9DMhPKaUtQ8Tl0U+M3zBJ2bbjUXRRgK99AFGnNl7fo2mil6pfsJfZ1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=23f9wa3u3JmvcxPtGXvwR0AVU3ysenr4nmmrqIAxbok=;
 b=zFn3xz5SoWW/bYNcNRZ3bD7E3uvTbV2flZcjAi6xpt/e8//X/njaYL0QwfrMYjVsKE93SFKC3Dpyx3ct82MRW+RaPPFnPw2kALufIA5SnuTkpRioJ+/kd9SKu8b4KtDqOpyAcqzCQtyyjFb7gjtYLOKDyUvtyMz1GeWQDGx1IhM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM6PR10MB4121.namprd10.prod.outlook.com
 (2603:10b6:5:21d::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Tue, 15 Nov
 2022 17:11:02 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5813.016; Tue, 15 Nov 2022
 17:11:02 +0000
Date:   Tue, 15 Nov 2022 09:10:57 -0800
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
Message-ID: <Y3PIIQeGD9LUs2np@colin-ia-desktop>
References: <20221111204924.1442282-1-colin.foster@in-advantage.com>
 <20221111204924.1442282-2-colin.foster@in-advantage.com>
 <20221114151535.k7rknwmy3erslfwo@skbuf>
 <Y3MK9PCz0JQSQNiQ@euler>
 <20221115160839.rgyoa23yabrklpxd@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115160839.rgyoa23yabrklpxd@skbuf>
X-ClientProxiedBy: SJ0PR05CA0093.namprd05.prod.outlook.com
 (2603:10b6:a03:334::8) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|DM6PR10MB4121:EE_
X-MS-Office365-Filtering-Correlation-Id: 695c4336-3930-4173-a6d9-08dac72c5fa7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NwDvwil/r+1ab+WZE+tpZjah2xYyowKCo42KgJRcuhe0mGTyM0GjB6mcshLeB6zfrTA7ymI1m3XY6jeaiVIC1GPRXm6JaE+USb5j2by97yTC5pmKSVPAf70PmsgSWHO9BeqgJqmviJWHBFhKea3XXIBJUawWIOzmKOL987f/Q3RYQO4ijALnEVp+7TCmB1OFhWc9pWaBBsk4COtfNFJToVEQhkavu1C7P09IaPNNQDFwnXG9O5FYZidULoIX7fd/IvzlgUJztd9Bp4obXKMwz4y73NnDjlQ1ElecsULpQ/itAlSYL4MpxQoTcvTqwEfpi2FKxS0dzn9zBnErPhI4RokuTDnjba/vgYoQuzrTTHAhabxD9qCh/W7i62bMQfRPELZmCSw3eKyWQZI2Or24EW7L5dMv6bfSXhZ0BXIIhNCYnVldR2tx2Hg9IrodKlL7mJGT/KfePEILMpr3XpwZn/92YhVqo1xMLH7gQ/aSdqjaZMpQigRpcvzq66I4d/D3C6uWhXt6Z/T/tIgOV+PN8E/igEQ3yt0hdcBYJzLPa3Hf73HeJARzvIGTQ3zZqBETJYJET/wdx4JFSxFPMXdXDYKeCoySxxLjN4Sfo1MIlFu23jVa45y0+/EUfgYnoWorKuXpUlI3OcyklsseKyDPxBgA78wjKHOb8RNs81Cl7WMN6Z8R0vb7fKLZUVAXfv6FdhATzn9NqMGuJKaVwrCy3xWo14vRiF/2tOfrPZ1IsNU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(136003)(396003)(39830400003)(376002)(346002)(451199015)(66899015)(33716001)(6512007)(83380400001)(38100700002)(26005)(8936002)(41300700001)(5660300002)(7416002)(86362001)(186003)(316002)(44832011)(2906002)(478600001)(6486002)(9686003)(966005)(4326008)(54906003)(66556008)(6666004)(6506007)(6916009)(66476007)(66946007)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hAhJixjiDA7d/STZ0wuJBPGwak3z1IkLHRDV57LKX0w+y4Jht1cPpiHVGUlk?=
 =?us-ascii?Q?NeVTV2o6nDJXZV4zhD5RbMduDXJwrvOjcIEAmSzyj54jqq9LpohLzEJg6q8z?=
 =?us-ascii?Q?dlGqgcHFOYFUoZsekiHai4geQ9IhS9zkEw5sk1VGUSJ9PyD6+JvAk9d7MJ8p?=
 =?us-ascii?Q?oeUYjzjWnpKarfx2G+1StDcNWOJ3JF3/ni5rEEPKW5NHM7/T6FxLrEJrEfSl?=
 =?us-ascii?Q?NH8Qu3l9NkQKJF3OWd4x3oY5M6u5QwUTCFC/7zz6dxZ00+Kl5bz4jOHeysHp?=
 =?us-ascii?Q?ECxbjiWigxxFsXz2SRwUWq7fuie0+s+nJ0dUL/wOJmFh1yXz5WHonIrI867g?=
 =?us-ascii?Q?tSQKNhR7bIbrzc3A3PC1t0ewEG7srIv2VaMtHHYtzAdtrR1vnDqxFfzxDMoy?=
 =?us-ascii?Q?r5Bm8JKq9YQ2fzoVausV75vp+71JZQqKK+C+U83smljKbozLA/IB0Pne5QAy?=
 =?us-ascii?Q?ErhNQ87KAgcLOFDsgx0YtWzkd21GtNWKSDCCjgaIvAdjah8pjzVuilvQge1e?=
 =?us-ascii?Q?IET6fMRy28ga0ujDzE6RuXWm6B38oFkQHq/BL0QJ+/Y671QeUj3qNEMhK5AH?=
 =?us-ascii?Q?H5SufJcq3Y9UeIEfvELOV5f/pwridZN2B5t90LOC+aE556Oa2r0Q+6r0Io/K?=
 =?us-ascii?Q?oXVzKDuMBC05BTbw+R8jlusYZDGW81l1HY9GoDCg2qa0h7BNx6qYB+w0LTM5?=
 =?us-ascii?Q?JRZpHzO8JeM0EpQwB5y+9vKTI0BMrqPP+enoGEFl1SNHjLznllNsV0x1eIuJ?=
 =?us-ascii?Q?UNNALgXaxwK5zEI9Mt0kzhtqksIZcQL+nW1/GVCodnoYJHuoaJLAYjTm74gE?=
 =?us-ascii?Q?x9UDAuGXoqBygvqQezLpZ7a6PXNdoL8HQPZ54/Ef2oXLW42ieXmg/IJSVvq8?=
 =?us-ascii?Q?I14ycw/55Dy4ydgz0E3xyUBiwAXf08lSwGC0oOraO/5CgxTUqxEBhCemUoDF?=
 =?us-ascii?Q?ZZFhdyoBeJ4Tl82h7sqmlivUrzfpOwRfQTEdxKpNjcK2rIbfuZkY6d772RiJ?=
 =?us-ascii?Q?rHVzOa+HbVtNg8B96/OQ5QVAvlUp4A0mnyfhBBtltVUysS7e707FYVAED5TP?=
 =?us-ascii?Q?oqRVgrX0vAB6H6iWqAQbX5Mikv8Z7g9dSviURvJkEkMRsCg4Qr5hMlilw/LV?=
 =?us-ascii?Q?LrtuKWRD0xSz8SmlXB9Du/8zVsHMDGVbgnlVqLS+i/abLNsAZhEBX5myLGys?=
 =?us-ascii?Q?B3/CJ2uPxs5cBeKwGvItbMyR9LHgEVpS2PuHzLv9NdDPHdW6gxZfW0ovBUI5?=
 =?us-ascii?Q?sOhK8zG/wcGLWm7lrW0bs5lvKFlTYHHnq9KsCgqBamvtDeRzdACghIdjrXe9?=
 =?us-ascii?Q?cyzCj4pEMHzL26uts8Ihqzvtp/WUBJiBj4GI7hf3Iz+sYKfo3TV5izIJxuP3?=
 =?us-ascii?Q?AvTPilHK9zsvuhvAFrk5b81d/LHhtIWwkXj6JfBZtsNRfKHYYFU2MzTrhaV2?=
 =?us-ascii?Q?UuEsROGcsGT0rCcMIGaYMYagbPt43AlVB931BN5QHw4uvP2jjtWXzZA4oRMS?=
 =?us-ascii?Q?D+c79s2ZQqcPs6Y8DUc3OlHgk19cuJXIJ1VSEDYmeyyw4Yzt1iSNdhqDwpku?=
 =?us-ascii?Q?le8tA6E3uXvcKKXcu5V8p4Y93IiK76YPRyjD+xbsqFx0kA3UuPhY8bWYIDop?=
 =?us-ascii?Q?tQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 695c4336-3930-4173-a6d9-08dac72c5fa7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 17:11:02.6938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zh0xue1YMxo9MqatuNzTdZo1mqREaU62HRfJGnaXjZlTc3kc3wqs0liaNa1/ZoWEHsCoDFiFk9WqiGP51xfkfygzQUz+2qgDeyFrw9qnO2A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4121
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 04:08:40PM +0000, Vladimir Oltean wrote:
> On Mon, Nov 14, 2022 at 07:43:48PM -0800, Colin Foster wrote:
> > > The issue is that not all Ocelot family switches support the MAC merge
> > > layer. Namely, only vsc9959 does.
> > > 
> > > With your removal of the ability to have a custom per-switch stats layout,
> > > the only remaining thing for vsc9959 to do is to add a "bool mm_supported"
> > > to the common struct ocelot, and all the above extra stats will only be read
> > > from the common code in ocelot_stats.c only if mm_supported is set to true.
> > > 
> > > What do you think, is this acceptable?
> > 
> > That's an interesting solution. I don't really have any strong opinions
> > on this one. I remember we'd had the discussion about making sure the
> > stats are ordered (so that bulk stat reads don't get fragmented) and that
> > wasn't an issue here. So I'm happy to go any route, either:
> 
> Oops, I completely forgot about this patch, which I promised I'd submit
> to net-next and I never did:
> https://patchwork.kernel.org/project/netdevbpf/patch/20220816135352.1431497-7-vladimir.oltean@nxp.com/#24973682
> 
> Would you mind picking it up since you're dealing with stats ATM anyway?

I'll bring that patch into v2 of this set. I plan to get that out late
this week / end.

> 
> > 
> > 1. I fix up this patch and resubmit
> 
> Honestly, I don't quite remember today what I had in mind yesterday with
> "mm_supported" - I'm not sure how that would work. I guess it involves
> creating an extra struct ocelot_stat_layout array beyond ocelot_stats_layout[],
> which would be called ocelot_mm_stats_layout[].
> 
> What you mentioned just above with the stats ordering is going to be a
> problem with this approach, because we'd need to modify ocelot_prepare_stats_regions()
> to construct the regions based on 2 distinct struct ocelot_stat_layout
> arrays, depending on whether ocelot->mm_supported is set (at least that's
> what I believe I was saying yesterday). But if we merge the arrays if
> mm_supported is set, we need to merge them in a sorted way. Complicates
> a lot of things.
> 
> > 2. I wait until the 9959 code lands, and do some tweaks for mac merge stats
> 
> Hmm, waiting for me to do something sounds like a potentially long wait.
> Why do you need to make these changes exactly? To reduce the amount of
> stuff exposed for vsc7512, right?
> 
> > 3. Maybe we deem this patch set unnecessary and drop it, since 9959 will
> > start using custom stats again.
> > 
> > 
> > Or maybe a 4th route, where ocelot->stats_layout remains in tact and
> > felix->info->stats_layout defaults to the common stats. Only the 9959
> > would have to override it?
> 
> Something like that, maybe we could have a helper that is used in
> ocelot_stats.c like this:
> 
> static const struct ocelot_stat_layout *
> ocelot_get_stats_layout(struct ocelot *ocelot)
> {
> 	if (ocelot->stats_layout)
> 		return ocelot->stats_layout;
> 
> 	return ocelot_stats_layout; // common for everyone except VSC9959
> }
> 
> and we keep exposing to the world the OCELOT_COMMON_STATS macro and
> whatever else is needed for VSC9959 to construct its own vsc9959_stats_layout.
> 
> Or..... hmm (sorry, this is a single-pass email, not gonna delete
> anything previous), maybe we could implement the helper function like
> this:
> 
> static const struct ocelot_stat_layout ocelot_stats_layout[OCELOT_NUM_STATS] = {
> 	OCELOT_COMMON_STATS,
> };
> 
> static const struct ocelot_stat_layout ocelot_mm_stats_layout[OCELOT_NUM_STATS] = {
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
> static const struct ocelot_stat_layout *
> ocelot_get_stats_layout(struct ocelot *ocelot)
> {
> 	if (ocelot->mm_supported)
> 		return ocelot_mm_stats_layout; // common + MM stats
> 
> 	return ocelot_stats_layout; // just common stats
> }
> 
> Then, setting mm_supported = true from vsc9959 would be enough, no need
> to provide its own stats layout, no need to sort/merge anything.
> 
> How does this sound?

That should work. If there end up being 10 different struct
ocelot_stat_layout[]s, we might reconsider... but in the foreseeable
future there will only be two.

So this applies to patch 2 of my set, which means I'll pretty much keep
it as-is. The get_stats_layout and the ocelot_mm_stats_layout can be
added when the 9959 stuff gets applied.

Thanks for the feedback / suggestions as always!
