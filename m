Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF9168F8A4
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 21:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbjBHUOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 15:14:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjBHUOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 15:14:15 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2080.outbound.protection.outlook.com [40.107.104.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8B61719;
        Wed,  8 Feb 2023 12:14:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gdZ1Hju2EYedayLGNmUih2VwR9m/P72qkI4frPFpD9PaKm6K5gd/w6eu2BH/acvbtSw4dFehG/GnhWzMnQkEUU12pJggFnIktj3KXdwUssXbGnZyMqtN/JeVcVQ4sgVL+UFkRnNMO7tE/2toBquN/PJUO6FKz/50dM3lckWuHuteFxQTKKgHW2HboubnjWv4n0Q1nrxTDdC5zM38MB7AoAtpdf7XLpcjeQ2GAoMVNmJYZTfr/hOZ7cNupamzUzr8VJsyLqbOS7JkWM6OmfOuyHA8LlUDBOQj5P6ux50cfsevcHlaPB8iSv1n40OsPYl3MFBym1Dl2gotiWpg7ecHGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yrHtdWEPiMC7wpXpdvan9oY00rr4wtcOgjSRjxVSp0M=;
 b=DaF5plLh2++D+sYkp4xYTwPWo778BKsxSTr96B3YQdjEp7ZtMyyeIXS0zT9BnytLgzjzlwXyhKuuqcwej3UfvvMQt3fk4JzJOFE4EsjZrWctLWjYciA46ok0dR2Wn2KOqPwzMTRuQ4aCpZJ9Dj2lLiNuZTVa9fbzNZ3T16PzseT9l3Ca/o1mmCjsKZOK7dKkHzlPCJH7TArNq3ygoO7iMi6jYbv0xCJOFK2/+uR3WtZVcT+gH5mVv8BffiTILGdt9hyCX9lKkU/VYDPFBzFFNlSAorJtJNkghagHEZ0xJeB5dXC/9wgIUwn0PPfg9NWUN4M1ADgHRH5oacnAEpy59Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrHtdWEPiMC7wpXpdvan9oY00rr4wtcOgjSRjxVSp0M=;
 b=nxDNOws7UxLnSeTWxVN9cX5Cm5HyZPMdamNylumKQVnW16Sbi0o+FzNppJ8W6vBnLkNoJXL4g9Wvyna8P4hUqDD/j3iEzAH9u5g8rrp/dMmZbGgHl4j7FoDeWfT5h9GLEoru4IcopSVGhsq/QT2yG7qNJvqVqfOnG6vxDxps1IA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9280.eurprd04.prod.outlook.com (2603:10a6:102:2b6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.24; Wed, 8 Feb
 2023 20:14:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 20:14:11 +0000
Date:   Wed, 8 Feb 2023 22:14:07 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, richard@routerhints.com
Subject: Re: [PATCH net] net: dsa: mt7530: don't change PVC_EG_TAG when CPU
 port becomes VLAN-aware
Message-ID: <20230208201407.hrymk4zzuoerd2nl@skbuf>
References: <20230205140713.1609281-1-vladimir.oltean@nxp.com>
 <3649b6f9-a028-8eaf-ac89-c4d0fce412da@arinc9.com>
 <20230205203906.i3jci4pxd6mw74in@skbuf>
 <b055e42f-ff0f-d05a-d462-961694b035c1@arinc9.com>
 <20230205235053.g5cttegcdsvh7uk3@skbuf>
 <116ff532-4ebc-4422-6599-1d5872ff9eb8@arinc9.com>
 <20230206174627.mv4ljr4gtkpr7w55@skbuf>
 <c4c90e6576f1bc4ef9d634edda5862c5f003ae3c.camel@redhat.com>
 <20230207123952.r2r7tnama3vcr7vt@skbuf>
 <056934c443a57293f925d8f18f603b6ec76b91db.camel@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <056934c443a57293f925d8f18f603b6ec76b91db.camel@redhat.com>
X-ClientProxiedBy: AS4P191CA0022.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d9::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9280:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ed6baf8-028a-4974-91f3-08db0a110acb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K2oe7xCm7+VwO8y7ETlTedwjbQmitBgn4iCDW1S6P10RJ7Z4LFmKq1Cd/If5mgLGHn/r9sDdvavQg3p9Bf3UI5eFioz8LmUft3zL3WFPJbM7L9ofAYJBxmBLMaYUB8skAUnzhEjPAatJNeE/BCER7Mh07kSJ7K5TIrA6BFYRDReBQ0TPwNSut3zV6lqnjDtdBuWgMgXgnHjFDmyDqQRKmNOWHT4OqRaR1lKThIqN+oSbYpl1OeAFjzMYkW+Z8apjNw3zN5yOMB0Em07Smc4LWOI+RZ3kaq9l91Kwd9AVTvpXVowkXO4bgnP/kvSyDAdOX+S82Ng36SAgJtmnsWd0JrX92iF0HBxH78OnpdzFgsgZYv97sVyaQkrU2WxCAW6d8s6OKwCV36qqPoGacKwrqSgct2upOJeLyJp6nQCkZE2ww+bLlPQ53Oyl4eIm/TEdD98cDSlrhAeGDtWQ/Y2tckw8IAb+6yZMjH2/rtfMwtg0gec6tmqq4ud/nnD94FQac4SVerabreviMHdD7j8Mr1JnFmJTRPKOv/cr2GCCH5huneudIxkIQ6PQzH6In+KMGFNVw42yNYD4btjxtHZWnwLrhvY7wXIZuYyB82ZoWLBOZpGf/iaJ/qgVRLdwJlfIHId3MVil97mmqT2IdPDg2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(346002)(39860400002)(376002)(396003)(366004)(136003)(451199018)(2906002)(44832011)(7416002)(5660300002)(8936002)(41300700001)(83380400001)(66476007)(66556008)(66946007)(4326008)(6916009)(33716001)(9686003)(316002)(6512007)(38100700002)(86362001)(186003)(6506007)(54906003)(1076003)(8676002)(478600001)(26005)(6486002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FkED7JhWq6fQH6YOjVycnPqKksNTRNLQrbUm/aFP9dTMG1b7Yf8/t1y+W3r+?=
 =?us-ascii?Q?TeGbFS8PYvjQ0JWw1dXrCSsAkuOf91xBGPPFuJt8A/m+bgzmc3M29W5u7n7G?=
 =?us-ascii?Q?8jzjQDuv0/BaXUDb3I1dUffKgmXeF2E4OUEM0nkFQZeGV1aEWMbVbU7a3VWU?=
 =?us-ascii?Q?5QkEEaL6H0oCQbDbnwvu9P/zQIfWYSUPj7NpxHmr1RFd+yUxLQ3+qzf33dr1?=
 =?us-ascii?Q?67NaEN+8ekq8sq4laAoD6nLHBb0qtncra4D3OexgdFdKTqcQcbeLsySEoTnY?=
 =?us-ascii?Q?gp4qbPYYt3AYsTzDuEmVSAAgqKvzyJiWUmx3ujPAyus76ka0rp19kDqbUF/Y?=
 =?us-ascii?Q?MbCQ7DPB0yX+cRww9oE3C1Gu6YdaLBJr+LySwHm40UUXaWtTRc/ghSwcBoR1?=
 =?us-ascii?Q?mux/f2DJFZzIrD/JFkMJUIl3RJDaxWRrs3sYvlA5cytLUnb8TpEn/d0gPUuc?=
 =?us-ascii?Q?/iPD7vHuG2uJHFwGnfN5wg7lKNUpfTx4iIjewNYFPWwJhE4Mkpn6hYQValhK?=
 =?us-ascii?Q?w+haabARX9fwTH+tN8JD+s04vp/IgLnssX2CJgzr3MgUDVALr1Fz3DHVXdEZ?=
 =?us-ascii?Q?+O2oV16U+WRMpNfvBp6hvPoj4Pqh6SPDv2fPoj+pNcOw/SGEEEq+ts3v770q?=
 =?us-ascii?Q?qDgjAMTm+FPrB1PomcC0eZyfxPXN4xU+Wkfn4ReJtxgh8KZd7SHDm0jDxbig?=
 =?us-ascii?Q?ZT8K9L2zil5V6an5cXny6sDdg8Ab1g+G6glmBhl7AOTu+VqQBeswc+Wn9MbW?=
 =?us-ascii?Q?JKESDxcE/ssFgkkIJB93NCULIHsCodfj/JkbGbJd+1PnZWRLYKRdm7Txmo0L?=
 =?us-ascii?Q?m3JyEFfIPf/UVCvINz29ZGK85ZFyElEIzwuxEEVIi88CDry7h3x3EqxiNfRy?=
 =?us-ascii?Q?/YuTAM7LbZ00tD0OGRUg5o6WPKIJCA/gnzUZA4T81XqlVKt0eQeHSFpejvRb?=
 =?us-ascii?Q?wte2mWZrb9n1m6kTZlJYMqMzcxPRAsmPgS0E0+uYX49XE9PtOpuM2IHtgED/?=
 =?us-ascii?Q?H3vRz+MDOz0RwFYCVTPkNBBQzJ0HhNDtE/5Rl8g9Di0P8fnDpOkxWCncZhGZ?=
 =?us-ascii?Q?Timm2eLFkG20P9HY3hkVAtsUjFKyoF6IkDyqSPG4agcuLxujaejs7N96NV7O?=
 =?us-ascii?Q?VqRbrUGlmNc9zmkXCONEgAIVk4Kb1WvchUsm67m+8WSE+nXNXkNcc7BchEGE?=
 =?us-ascii?Q?4m0bIlGRbCRIslBYT+jXk/+iE9sk/pzYN4sFbBm5lxGUX26rVr9A3/MgIMPZ?=
 =?us-ascii?Q?vbLRV9i38Ll53qRbmD/0jXV5l2OGUVE3woxwLiDXCw0zDsExU3X+3dndO+rc?=
 =?us-ascii?Q?rlBwcVX5UaDO3TuuI6Gl0lWyFKJbX1tYFSumn2e5RrgUo4NK4ND+NkWXbPye?=
 =?us-ascii?Q?ISb6et20TniikXJre/ikj7CdBUQ2Eqo0dvVUWHk4wBqiRcKJULdnFBTOr9aC?=
 =?us-ascii?Q?E2WHbDNMeRpNzTc0KGogC81Lk7yL/6Ho98UoZ2bpCeSOhE7tiDKgn7H8zfB/?=
 =?us-ascii?Q?miKDhhIknK2V75GNmejOYQgYfXyV6MARpFk+4knd7opaPcZFh15d5pU8gSwg?=
 =?us-ascii?Q?Nbj/g0ifcGB9hcE0hP9d88yvsOEm/dqFFsXnpVYYxMUZvTdo/C1F4JQbqaJe?=
 =?us-ascii?Q?EA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ed6baf8-028a-4974-91f3-08db0a110acb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 20:14:11.6923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mYs2pQNi3dKL2uRRurTxrvwKMUqCuWfjlVw180CUWITYXpFQJUKLORal88n+2YSAPt0rBTRqlf2oJwIDpfW1ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9280
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 07:07:14PM +0100, Paolo Abeni wrote:
> On Tue, 2023-02-07 at 14:39 +0200, Vladimir Oltean wrote:
> > On Tue, Feb 07, 2023 at 11:56:13AM +0100, Paolo Abeni wrote:
> > > Thank you Vladimir for the quick turn-around! 
> > > 
> > > For future case, please avoid replying with new patches - tag area
> > > included - to existing patch/thread, as it confuses tag propagation,
> > > thanks!
> > 
> > Ah, yes, I see (and thanks for fixing it up).
> > 
> > Although I need to ask, since I think I made legitimate use of the tools
> > given to me. What should I have done instead? Post an RFC patch (even
> > though I didn't know whether it worked or not) in a thread separate to
> > the debugging session? I didn't want to diverge from the thread reporting
> > the issue. Maybe we should have started a new thread, decoupled from the
> > patch?
> 
> Here what specifically confused the bot were the additional tags
> present in the debug patch. One possible alternative would have been
> posting - in the same thread - the code of the tentative patch without
> the formal commit message/tag area.
> 
> That option is quite convenient toome, as writing the changelog takes
> me a measurable amount of time and I could spend that effort only when
> the patch is finalize/tested.
> 
> Please let me know if the above makes sense to you.

I think even the Signed-off-by would confuse the patchwork bot, right?
I would have to send just the diff portion, and send the full patch as
an email attachment.

In any case, I'll pay attention to this next time.
