Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7F869CF19
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 15:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbjBTOMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 09:12:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBTOMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 09:12:22 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2118.outbound.protection.outlook.com [40.107.243.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C3D1F939;
        Mon, 20 Feb 2023 06:11:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gtVtYWvGP+TGvg4/nkj6EFQCedBsF/VDR+EjhBvTuM92V+tQZlKXEPvnnQhxJ1yIto1mmS9+YvyuL0yQ7TgalAi5254xEtrpw/BVppBjYlqSwWGJtQ3rTYoVJTVArh2fexMnqCpGvkk3cEXYHQzvsHUz6JIA8UPZ4sVbOimOi/sreZzNj+nmD59r+csRBZ3MimWHGL5fP8F2Ia0oQMbOBCeUSh6bVusM2iAK8vw9bfKEy0UN6r7pCmvB3epka4sMF5jGpiWaqaV2G42hKqLTTcNDioGxtqQYFgSG7cs52nquzy771LXwENTOhsWHvLrUwEmo3Yg3uSj2FepplLu8+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FKVGHeb22qzfhzH0WK8BTep6YXmUCvDuCjosBg2TlME=;
 b=LHuCUCNwWcViUXIBokj8zvxDJAPvQ9Mpiy1T2T/0YtKAGgnGryubKMl030/00PXhYXgbqScCScI0lCL7GpMugoWqfGZyql81Bhlp3sZsTVAUAKg9n9EYktQleptwqNdoNPqERpi2lbnY7uZdfXsWFY6kfqOAP4kxw/YXWIl9cS9OeTEaDKCUhRFqHEHu0FNOc6ZO9aWnvuLSdDIlECqKnGut4TA9afKplejDV8k5/Fb+/yBzRaEYplrqxkho/9g9/DQYG59OBocXLtDReBV1tJRYGAGoWrU8vpdF4XnhnDI/3nOUX1749QbgmF/WTCm6nLse5fAQaXTCchQpMyXwsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FKVGHeb22qzfhzH0WK8BTep6YXmUCvDuCjosBg2TlME=;
 b=k1g+GkDzccdzfKSIT/dygh80YJRCc31I/6xqX09BwfCf33Deb4MU1wi4kawYFLkmFLeTXEpkkKvUfeyEdlY99Vt3pvZOj3GzgAf9/ZnYo5/Jc+ajG3DJlYI4OvHHnxp2R9qVayXIf2tZpjk2edxhWY6ucJhV73L1qqVDOe88VXE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB5166.namprd13.prod.outlook.com (2603:10b6:408:151::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 14:11:29 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 14:11:29 +0000
Date:   Mon, 20 Feb 2023 15:11:19 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Hans Schultz <netdev@kapio-technology.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "maintainer:MICROCHIP KSZ SERIES ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "open list:RENESAS RZ/N1 A5PSW SWITCH DRIVER" 
        <linux-renesas-soc@vger.kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next 5/5] net: dsa: mv88e6xxx: implementation of
 dynamic ATU entries
Message-ID: <Y/N/h5WMRzl0i2IT@corigine.com>
References: <20230130173429.3577450-6-netdev@kapio-technology.com>
 <Y9lkXlyXg1d1D0j3@corigine.com>
 <9b12275969a204739ccfab972d90f20f@kapio-technology.com>
 <Y9zDxlwSn1EfCTba@corigine.com>
 <20230203204422.4wrhyathxfhj6hdt@skbuf>
 <Y94TebdRQRHMMj/c@corigine.com>
 <4abbe32d007240b9c3aea9c8ca936fa3@kapio-technology.com>
 <Y+EkiAyexZrPoCpP@corigine.com>
 <87fsb83q5s.fsf@kapio-technology.com>
 <20230217174431.bkkvfmtno56mfh5a@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217174431.bkkvfmtno56mfh5a@skbuf>
X-ClientProxiedBy: AM0PR06CA0142.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::47) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB5166:EE_
X-MS-Office365-Filtering-Correlation-Id: 8712852b-fd81-445c-4f90-08db134c5c26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6g04yy3J9c4cfPtgAnaatdb8wmLwtOOMnt2hhMRRYyqlO1xQp1+vJXbK6EzRyy/pDaZTRrSwdpTMOYYzhXlbFMTWQW+XqlzVCxXJycVKnQbn/SPI0aZrKgM6qprdmBxLN93lpLGJjMhB8UhYPzb918PiZpSrkWXqo5L/xshdrftEwuT8w++7WBwxA905VwszK7Stc9DohCDG18ozlPfLkjSvgCr4bKRsLWe5CqBgxgJu9A0tJk00M4fJG+oyhjSi1nrNLUM4HbiAYTWlgr40xDZHGDefzirFZi6s3ZjbrId5W8GhcVhTMixodfUV8XcxkXDmnP4UwsEopuUsxT70geBYfcqlibuIYT1c1blP+FsZ3VsqH5o4gBZNAi3CBFWZ1CC3gd9726I31kIoUxOAy3ZRoD4aJ0Hzr/nTgWe5jaa4WwpO00sn5WR1htuuhrk86UbcO1z49+C5O2AELGyr10Gf1GKptBM11fCdGDXOhXUlwoPwjFd1V7mdhxj1amOdH8PiUcj+H7ToYyMWi+r6JDDrbp8wv5LtKHKZH/qLas0meRzn8DRV8D4CVoA2//0yslJ2D4vXqMQ9UqjnvNGgcyzJdlPWKHzEURjkTD1saGK0JqkLuZdherPy6uKnfAPdMapos3ZE43r8FIWC/08bDjpgo/asBphe+vBqDSTXkychX5Gl+i07GF98vHnbo1n8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(346002)(39840400004)(366004)(136003)(451199018)(38100700002)(36756003)(6512007)(6666004)(186003)(6486002)(6506007)(4326008)(478600001)(2616005)(54906003)(53546011)(316002)(2906002)(8676002)(6916009)(66556008)(66476007)(66946007)(83380400001)(5660300002)(7406005)(8936002)(44832011)(86362001)(7416002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UTVQ42flIc2Awj0c8J/5DpjVeajT1b7SgjNgg0VcIX3Ahz7EYAzY9tpVJyzW?=
 =?us-ascii?Q?bNEXEWTYwsMrKLpy/demHii5+Cw3j6pw1ifv21OLxOIMOLZ0dutXVbQMsiMd?=
 =?us-ascii?Q?NaGsFDPIMuQes0lqtY9hnpAk01sIbOZE/ooSM2Dn4N7s5+SyqJ3tyZv8JzA1?=
 =?us-ascii?Q?nZu2KpNWNYwaNtbeT4RcLefISSvSuZOa8e0zDfprPRuiGn2JCOKajHU7LCIJ?=
 =?us-ascii?Q?tyhYR4b2XsY8DdqLCVgKzlF3FY35xH/gjyhGJC0eUyVfON0CAte4+dE13R5f?=
 =?us-ascii?Q?xLoNN8oRAQgTXfkbzXg7jHu1UOTUdBTl2sB/ilBi6w1IZ/27aCgS7rlybwGk?=
 =?us-ascii?Q?zoujVoL/SLhWXLiPKhQxlTufozTF0LaQtLTfy1Gy2NVV1nBMeTjiri2uwihG?=
 =?us-ascii?Q?hGPbMwxgKcFNncbDrHTPF/yKnGdp6wLnLYajISXDFOTSUw4yvevposTDvZpN?=
 =?us-ascii?Q?DtFo+hrQNqaXRm5hR1MVakLjP5po/OJ7ZIQNxPsD7gv1KP6RFxGg1lAziY3d?=
 =?us-ascii?Q?DjGPuqnKP4rT68w46Nid2opStOWFFr/e1zw6lXEJ/lN0HXTcuhP9i+q4FxxA?=
 =?us-ascii?Q?itXcW9EiMjiSd+ypG+qRCVtmyCyn5r150UbtHJ0lbjdvUsLyUELDZWFzQFBb?=
 =?us-ascii?Q?S+2DDr7lxXapUf+AuryNTNsa2KYo53B5cjry8YAw0lyW5sX3CwG6R2Gn94xD?=
 =?us-ascii?Q?toowigEssTV/ka7nvqZbQ+AC/UemI/bZnUnxssiFmMovmlNDsmlTdWrO7Zaq?=
 =?us-ascii?Q?l0XgOOtXGDyyeDkRNQmkHbJJUxNyIM4eBpbQDE+3umXrDeWZPV3NfSYOAFBK?=
 =?us-ascii?Q?ulMJdRrg/yN2DqhLgRkRnmjT+QsY5uwnV2F5AKKYs+OCMqG5S/OPvtlDY5Fl?=
 =?us-ascii?Q?hRU7DsDTdPjrtUXF16gLddN468gToKmL5PCGcRBTb8WH5ofADHTV9TCFNj9+?=
 =?us-ascii?Q?oCGSfQMFVwSJ7pxxwOl3vYkXx+P975qibT0J4+VPCXvfPvDkXfLhh27dTDS6?=
 =?us-ascii?Q?ksSY4huIACcKWB2tPLjY9MWKym5Uzks1JdSG8cDqVDq5HMJbczuGPEnaPtwS?=
 =?us-ascii?Q?Yd476TV8Q1/V8blzJK++Lg6Fn0+Qh5Zy8++E/51NfQ8iiLU3rr9r9Kh70t+o?=
 =?us-ascii?Q?36GYPXeDM1Q3xxbdTm3WF573SWdOQ31X85h8JL7W7gLMHpEm/yT+ocYclw1T?=
 =?us-ascii?Q?VZmA71lqD/mbt6uocgTPE0igpy/AzaGsmd6596tBLUbjVj3EQfH9hGAgoahQ?=
 =?us-ascii?Q?n10Bmy010B75kc4+Je+UYZmY6tzRnRTO1snAONozJNDOotDnMI7jxIr//QFc?=
 =?us-ascii?Q?UZpgf33RaJnW09HSDfTYWbiOgnmVQ2VtBc2BkxNKzEwJqbx+mMzS2Vd11JPp?=
 =?us-ascii?Q?rgGOAfqSaDt4pT7I+jekUi9YWzPSyLV0CT2HmYO7iBfkYPAMUjUaK1tD49e3?=
 =?us-ascii?Q?aBFnhbIqATnhlBt2Hya11i1kRpkuOb00/27r217wgBmcYecy1nPkwwn86SNA?=
 =?us-ascii?Q?tIvyCLe1cNIEYjZlksmY+Fm81z9SSb+jNDX9qTzSymUBsD3HoIXUg0o8iUJW?=
 =?us-ascii?Q?5Ovep+vw8arF7wljNeShG5uds97pckWyw0vxPFihFkhDb0GKXg+QEKp87ZIj?=
 =?us-ascii?Q?Fb7pSILMaOIzIfbMW1dd16OIzFOS26xqMnXtYAsYMjE+oi0oltoccYjJtAeD?=
 =?us-ascii?Q?T+TSsQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8712852b-fd81-445c-4f90-08db134c5c26
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 14:11:29.0794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fGsXtC+/y+dSteseq3KP/V/fO+rmX+lCjadVp2SJ29Ld11Mdze0hiinTSsnUVZOjc/0i5PfLBCrnu71VTrxFx6jqbxk0WWxt/J8PCTPfq88=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB5166
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 07:44:31PM +0200, Vladimir Oltean wrote:
> On Tue, Feb 14, 2023 at 10:14:55PM +0100, Hans Schultz wrote:
> > On Mon, Feb 06, 2023 at 17:02, Simon Horman <simon.horman@corigine.com> wrote:
> > >
> > > Just to clarify my suggestion one last time, it would be along the lines
> > > of the following (completely untested!). I feel that it robustly covers
> > > all cases for fdb_flags. And as a bonus doesn't need to be modified
> > > if other (unsupported) flags are added in future.
> > >
> > > 	if (fdb_flags & ~(DSA_FDB_FLAG_DYNAMIC))
> > > 		return -EOPNOTSUPP;
> > >
> > > 	is_dynamic = !!(fdb_flags & DSA_FDB_FLAG_DYNAMIC)
> > > 	if (is_dynamic)
> > > 		state = MV88E6XXX_G1_ATU_DATA_STATE_UC_AGE_7_NEWEST;
> > >
> > >
> > > And perhaps for other drivers:
> > >
> > > 	if (fdb_flags & ~(DSA_FDB_FLAG_DYNAMIC))
> > > 		return -EOPNOTSUPP;
> > > 	if (fdb_flags)
> > > 		return 0;
> > >
> > > Perhaps a helper would be warranted for the above.
> > 
> > How would such a helper look? Inline function is not clean.
> > 
> > >
> > > But in writing this I think that, perhaps drivers could return -EOPNOTSUPP
> > > for the DSA_FDB_FLAG_DYNAMIC case and the caller can handle, rather tha
> > > propagate, -EOPNOTSUPP.
> > 
> > I looked at that, but changing the caller is also a bit ugly.
> 
> Answering on behalf of Simon, and hoping he will agree.

Sorry for not responding earlier - I was on vacation last week.

TBH my idea was not nearly as well developed as the one you describe below.
But yes, I agree this is an interesting approach.

> You are missing a big opportunity to make the kernel avoid doing useless work.
> The dsa_slave_fdb_event() function runs in atomic switchdev notifier context,
> and schedules a deferred workqueue item - dsa_schedule_work() - to get sleepable
> context to program hardware.
> 
> Only that scheduling a deferred work item is not exactly cheap, so we try to
> avoid doing that unless we know that we'll end up doing something with that
> FDB entry once the deferred work does get scheduled:
> 
> 	/* Check early that we're not doing work in vain.
> 	 * Host addresses on LAG ports still require regular FDB ops,
> 	 * since the CPU port isn't in a LAG.
> 	 */
> 	if (dp->lag && !host_addr) {
> 		if (!ds->ops->lag_fdb_add || !ds->ops->lag_fdb_del)
> 			return -EOPNOTSUPP;
> 	} else {
> 		if (!ds->ops->port_fdb_add || !ds->ops->port_fdb_del)
> 			return -EOPNOTSUPP;
> 	}
> 
> What you should be doing is you should be using the pahole tool to find
> a good place for a new unsigned long field in struct dsa_switch, and add
> a new field ds->supported_fdb_flags. You should extend the early checking
> from dsa_slave_fdb_event() and exit without doing anything if the
> (fdb->flags & ~ds->supported_fdb_flags) expression is non-zero.
> 
> This way you would kill 2 birds with 1 stone, since individual drivers
> would no longer need to check the flags; DSA would guarantee not calling
> them with unsupported flags.
> 
> It would be also very good to reach an agreement with switchdev
> maintainers regarding the naming of the is_static/is_dyn field.
> 
> It would also be excellent if you could rename "fdb_flags" to just
> "flags" within DSA.
