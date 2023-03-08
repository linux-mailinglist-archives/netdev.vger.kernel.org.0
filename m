Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE1546B06A1
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 13:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbjCHMJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 07:09:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjCHMJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 07:09:32 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2093.outbound.protection.outlook.com [40.107.243.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1298D41087;
        Wed,  8 Mar 2023 04:09:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cGYZObjajPkgQzmk6b/ZDyYoDtopJKuYRRIs2d58FxTxcOv+Xkb/P1vN/wGyH5cZ/sSO4jUoOfr4vCfSE07OFYwXpwcx2M6UIGAkyD3HeBP8o/chzDTDg9iuJpTD9gXoIfZGNykO7nh/jPR2lPSkX2MosiU99z+OcJlFbpnxt7sRWCdX0lVxbxJxzeYObSppEN5DRJYnc/7Id4tq7xaZA8QQfDHUu+LP9EgziU8QP5A6GQa/fZxisTJhikt3r0Per+IsVzc326RvhZGt3N6IpxcIe9+ILipdG9FGh2v7jxIvU/hpUkYUQWQBFiu/RJ8+WzAJmQHCk336MeBPJmtIBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6S3AZ4hWhEKytDej51uxs93NE+bs6d7Mh/Z8AOvLPnU=;
 b=hCHc/Ij8II78Ya4If6qo2bU78ZT72uzEhsEfv8mLyMlYoRrmVJZ20mUhaUyqfDX3Gz52RVnIh8a/OhIZUjFYUKZBTfBs6IY8k3an0i05v/IOR/9e1RC/epHJdfL/Wguo6DTTXpWH+otw6Qo+7YZIuFVMQQ7xCiXxH6GpM92pfsfXQZME03ma4QqZdBCxfhg5Hn7YuaXQcHsl3MHZ92+IsczMnh+PzNikB4usmdZE2Iv+IoZkKjrXgaJVANoeiJt+WhKpe4p17cP920hsv8+ZT0cKFY6MC5jVZvin6nG9nB2TgLWERPL1Qup+7qKzkOwG/AQ0aakP6rvbdhQt1vRSQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6S3AZ4hWhEKytDej51uxs93NE+bs6d7Mh/Z8AOvLPnU=;
 b=S0xnKFsmXrjvhbVQsW6RT88eszUZpVauW9+E6OWfZC9zH3oAv2NUq2kSpH/pAm9zAwHqcG3+QXJe+te2OXio/xo7Kr/1vaWhXnPn9DmnFRpVxrxLlWQjqT8VSyzM6S+0pzN/usacwxreZSUbmll3cMmb9rM9SLHHdi+sIAV4dQk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5277.namprd13.prod.outlook.com (2603:10b6:806:204::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Wed, 8 Mar
 2023 12:09:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6156.029; Wed, 8 Mar 2023
 12:09:28 +0000
Date:   Wed, 8 Mar 2023 13:09:19 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>,
        =?utf-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>,
        Alexander Couzens <lynxis@fe80.eu>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Richard van Schagen <richard@routerhints.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, Greg Ungerer <gerg@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, arinc9.unal@gmail.com,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Re: [PATCH net] net: dsa: mt7530: permit port 5 to work without port
 6 on MT7621 SoC
Message-ID: <ZAh679+uLJN/J5x7@corigine.com>
References: <20230307155411.868573-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230307155411.868573-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AS4P250CA0019.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5277:EE_
X-MS-Office365-Filtering-Correlation-Id: 70def8ac-8811-4431-907a-08db1fcdf70a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HtpLZ1FnXkgxsBJVW86xLK9OIZCkD4b5YuglagaqGQLgFHhCa0e1JEHnnVXG7RK03OgrYxAlpra0dMA244t8SZLs0Lp5HFuaXBYGLnpjgI2C9XewtlNTuJqxKUVvqWyFWxqW7asCkRcLW0gBvFf9IwIot+5PiT2EAn0xvUm/SwzFtJ6HwsFzJ35CZjDPKrKuo5KYDV3d+Ym4v0+WnYf7BdMvx1kDz/BOlDUy+Ud6Ttro8d7A926UPeLrC80Tr/EKnsYu348VykHUuGVaZuqGf586qHD+zuGwB9BjS7hkweojqtlee7Y7QCWchSb+Ly7PIwwNtCA+WvCtBB+YleiZyQ53cGhCt069Uf3xlt1t/weXXHcEIntyJB6h7hFgYsjYARHi9puuVT4708R2h5prM4IGYqML7eXIohyDM0WSAMiRUlp8rzrJVuIpyisyXAn/BTw/2K4P0yP+6loGo0XJ4MGwaYGSuId1nXY5zHOqaPvLfs8R9mdFJa8fwOag361Zv6A25UKx97tBZCNY+NJdS1w6o/1cwuLj8r3BXGK+wj1RDpD0ebQaLGn6pJDdZ/M6v4bqEwONLBxmupmePOiuSI4YSKoK6m9IOSvja96ytO+09+qypR9x4uNT0UP8tdL8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(366004)(39840400004)(376002)(136003)(451199018)(36756003)(83380400001)(66574015)(186003)(6512007)(2616005)(6666004)(6506007)(966005)(6486002)(66946007)(66556008)(8676002)(86362001)(6916009)(2906002)(66476007)(4326008)(8936002)(41300700001)(5660300002)(7416002)(44832011)(38100700002)(316002)(54906003)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Uk5ZQlBRZmVYSXNmdDZoUnJCekFtMUowa3FKQTF6bFROQ2tBQmFwcWhuUS9k?=
 =?utf-8?B?a3ZjWUZlMy9KdnIxamdJZFlzN3AxeE1qUTR4WTRFMDR0YS9jVnp5TDVsaDlp?=
 =?utf-8?B?UDVPMHV4MHdiNGhUclljdXk1dHFLRlhFUEhUMHJORmVlay9YaXJTWHJpV2h4?=
 =?utf-8?B?Nnd3Z2UrYi83bUh0S2IzTTFQOUtReng3SWNqRDZhanluYVZTeDg4UEJSNXl4?=
 =?utf-8?B?V0tEeGZuTFdsWjlXclVhcmRUS2FtMmhhQmpkSDd1akZ0SGdQcTBhU1FFb082?=
 =?utf-8?B?bUw4bjIwMmZmY3o4R253VG1SOGhMSE9JSExGdTUrbUhqME1Ub25tVkNjSWd0?=
 =?utf-8?B?MFdxOWJiWTZXbHg3aGNWbEtTQnVuZktZT0xMSVp0bXpESnhSOGlQd0hyYWR0?=
 =?utf-8?B?emh4RDNhcWtiWm5iMEJDMVVmb0RIZ2pqYVlRcnk0UTB0UDFhNFRFdE1ZMkor?=
 =?utf-8?B?WGphZ0lEUEFCUGpvZHgwS3MvMDh3TElHM0I5aWpiak15dXJ5VmJsNGVPR3pT?=
 =?utf-8?B?NEJyclY3MXBxOWQzemx6U0lmcjU2SUZUYjRtRGdJYnBHY1puVUtFSDVXT3dD?=
 =?utf-8?B?Qk1XM0wrWXFSRDlrSFlEWWcyMGV4ajZ2Sk9oeXBPaThrTGVZWUd0YkR0WHdx?=
 =?utf-8?B?eURPbFpZL3lPb0NKUXd0NTVMbnVKMlh0LzhUc0ZsZjBwOGNsWnNqMjJZb0p4?=
 =?utf-8?B?VTRlcEdwVC9PUElBYy9ubktHVHNQVzBxUFF4N2tHT0NXV2tUNVZveDVzeGFo?=
 =?utf-8?B?OXRGTWZQdmFhZ1I0UjlLVk50dU52TlpmbXM0OHlMcE44eURvbmNQZnZYQ3FX?=
 =?utf-8?B?dXk3eWVnRXhmdC9weWhKeENMVDhuUWhDV0JmaGFrM2lzZHhyaU5OWExhdnBL?=
 =?utf-8?B?RTRia2FkV2ZhQndGLzd2V1RzSjZNd01xMDdKSHdiRUpCNlVZbmowLy9wYjI2?=
 =?utf-8?B?dTN2WFZjSm1UbmpMdzVENTlpZ2I5SEJOTnpPa0c4WFJ3U2laSm9FdWtaeW1r?=
 =?utf-8?B?QzdpNkV0cTRFRjNkMGdVYWZCUW5rVVFmRWVCRDU2VjNUZkc1Z3J6UVVqRkI0?=
 =?utf-8?B?QTZtMnZKOXZvL0tTRWVxYVhhKzI3eDF3aHR2M3JKaXRKclVEVUlCWVhZY1Fm?=
 =?utf-8?B?RTZwM0ZYQ1ZLSW9YMFN2TkFqNU9GR1dLWFdNY2RROEozTGhHYStrRVdTaEhq?=
 =?utf-8?B?N092Z2loeWNzM0dqbTdsWW9QVGN6eWpJR2ovcGhwUWxZOVo1YWErTFFiVytX?=
 =?utf-8?B?M1BKZGZJZ2tJbVliQTRla1V3ZmF1WlZxOTVKb09zc1l1M3JCL2IwQmQzb1FW?=
 =?utf-8?B?ZDZvSFppTDF2M0YxWFRnREt1cEt5YVNMVzVVL3B4K1RHb2xRcHBxYXBmSkJ2?=
 =?utf-8?B?YmxwVlgySW42SlFjOWI1QjlmUVdNOFBleG5aekxyekxXVUs4Q3grVFBBSzQw?=
 =?utf-8?B?OE9qMmVlVkpiRTlxN0p2T1YwMzdLRXc0SUg4SGlBYU9la1FjNjFmWmhURDVF?=
 =?utf-8?B?Z0Nwd3IzU0ZJRWgvb01tVFhxMW1sRlV4TzIxUCtuQ2FCN2xUN1N4Kzd5ek9E?=
 =?utf-8?B?MHphUUxITEtoazVGNytaYnlLWkhMQndvWDcycElTNlczMDBkNzZDU3VZdnc3?=
 =?utf-8?B?QWY4eXZxbXhtTTlqTWc3bDJLYW9OZWtzVUxpQ0VIckhvZW5xR3NTT2d5ekQx?=
 =?utf-8?B?dXJKNjIzeHlJV05EYTNZTHFWVGNRSHArelVUbDVvVEdjTjBnekR2UXEvSWRF?=
 =?utf-8?B?L2Jma2U3SFh3b05sMHJDNDBxNjZtdzcvdTR5aHN0UHBBVmYrS1pQeS91TkI3?=
 =?utf-8?B?YzRwSTlGTVkwVlkvS1BwVkNJOE82Tnl0SEY5ZjA5b3d2eVpiOXdzKzZQeXl0?=
 =?utf-8?B?U0MwbHE3VzdNSkhCaTdSMXdiSDBwQW43elNXL1BXTEs2SUpiSUd6OTJhRnN3?=
 =?utf-8?B?VnEwM1F1ejJtbUM2OHJyQXQvYURkbS9LZThGS2FvM2V4SUdxSldzUDdDaGE3?=
 =?utf-8?B?Vmc2R0RQakxjVE5VdXY0cUx1VS9XV24yWTlrcXZDemlwL2d0NWlpdlZpQ3JX?=
 =?utf-8?B?ZHFXTVZZaldDMVpUeDV4ZmdFUENZVjhMRFI3Z2g4MGF2UjVXbUxpRzd0WFNJ?=
 =?utf-8?B?ZEx2clhlV2lJM3piZm8zUnZEQXFyRU5sMUhycnJjYTk4M2xYZ2F3UmFtV2Jn?=
 =?utf-8?B?cEYxaSttZ1dCRTJycGlpSGhLeXRPS1A2bVgwMngwTnlSd1ZqcVkvaXN6ZWlS?=
 =?utf-8?B?VWhpUCtlTlIxUXJUc2ZhWjV2Y1RnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70def8ac-8811-4431-907a-08db1fcdf70a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 12:09:27.8353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /eZQ/ZMCr7N7JiAB31mJF/kWHaqvPddEMW60TURpDjXMQf0STrMXOcb/QvYa/eippqbL09wNln2XCdCQ1T6gVoHgI3mpw3MBhukS3iriMEs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5277
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 05:54:11PM +0200, Vladimir Oltean wrote:
> The MT7530 switch from the MT7621 SoC has 2 ports which can be set up as
> internal: port 5 and 6. Arınç reports that the GMAC1 attached to port 5
> receives corrupted frames, unless port 6 (attached to GMAC0) has been
> brought up by the driver. This is true regardless of whether port 5 is
> used as a user port or as a CPU port (carrying DSA tags).
> 
> Offline debugging (blind for me) which began in the linked thread showed
> experimentally that the configuration done by the driver for port 6
> contains a step which is needed by port 5 as well - the write to
> CORE_GSWPLL_GRP2 (note that I've no idea as to what it does, apart from
> the comment "Set core clock into 500Mhz"). Prints put by Arınç show that
> the reset value of CORE_GSWPLL_GRP2 is RG_GSWPLL_POSDIV_500M(1) |
> RG_GSWPLL_FBKDIV_500M(40) (0x128), both on the MCM MT7530 from the
> MT7621 SoC, as well as on the standalone MT7530 from MT7623NI Bananapi
> BPI-R2. Apparently, port 5 on the standalone MT7530 can work under both
> values of the register, while on the MT7621 SoC it cannot.
> 
> The call path that triggers the register write is:
> 
> mt753x_phylink_mac_config() for port 6
> -> mt753x_pad_setup()
>    -> mt7530_pad_clk_setup()
> 
> so this fully explains the behavior noticed by Arınç, that bringing port
> 6 up is necessary.
> 
> The simplest fix for the problem is to extract the register writes which
> are needed for both port 5 and 6 into a common mt7530_pll_setup()
> function, which is called at mt7530_setup() time, immediately after
> switch reset. We can argue that this mirrors the code layout introduced
> in mt7531_setup() by commit 42bc4fafe359 ("net: mt7531: only do PLL once
> after the reset"), in that the PLL setup has the exact same positioning,
> and further work to consolidate the separate setup() functions is not
> hindered.
> 
> Testing confirms that:
> 
> - the slight reordering of writes to MT7530_P6ECR and to
>   CORE_GSWPLL_GRP1 / CORE_GSWPLL_GRP2 introduced by this change does not
>   appear to cause problems for the operation of port 6 on MT7621 and on
>   MT7623 (where port 5 also always worked)
> 
> - packets sent through port 5 are not corrupted anymore, regardless of
>   whether port 6 is enabled by phylink or not (or even present in the
>   device tree)
> 
> My algorithm for determining the Fixes: tag is as follows. Testing shows
> that some logic from mt7530_pad_clk_setup() is needed even for port 5.
> Prior to commit ca366d6c889b ("net: dsa: mt7530: Convert to PHYLINK
> API"), a call did exist for all phy_is_pseudo_fixed_link() ports - so
> port 5 included. That commit replaced it with a temporary "Port 5 is not
> supported!" comment, and the following commit 38f790a80560 ("net: dsa:
> mt7530: Add support for port 5") replaced that comment with a
> configuration procedure in mt7530_setup_port5() which was insufficient
> for port 5 to work. I'm laying the blame on the patch that claimed
> support for port 5, although one would have also needed the change from
> commit c3b8e07909db ("net: dsa: mt7530: setup core clock even in TRGMII
> mode") for the write to be performed completely independently from port
> 6's configuration.
> 
> Thanks go to Arınç for describing the problem, for debugging and for
> testing.
> 
> Reported-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Link: https://lore.kernel.org/netdev/f297c2c4-6e7c-57ac-2394-f6025d309b9d@arinc9.com/
> Fixes: 38f790a80560 ("net: dsa: mt7530: Add support for port 5")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

