Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8776B51A7
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 21:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbjCJURT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 15:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231517AbjCJURD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 15:17:03 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2127.outbound.protection.outlook.com [40.107.94.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8E812DC1D;
        Fri, 10 Mar 2023 12:16:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eYUfxHr1GKsbtajMTyQOFuZBK+JspUShuy9Jot6Bjg6OKIUABwrQOSf3wbUrIt6npXzFSDMSNrmZaYBCUDeDnBbBCViqNwDSpXj+8+AoNnHP6pvYNRTfT8Ud8kuPaEISKEcHWaIeWHNEzp0Oii4PJ3sukjfT+lDthXr/88veQjlpu6a4D3+/+dPVEKil/httYZ645j+EN8Oz4Zqj2eCAREJzcZxN2pwyqXl8H5nGlYwmcAhIzs40eVOBd2/cZPkKMJyaqYkY5NyE2i5kzDRWkt7MtQxz46iBTps0re44qGi0DT8o7NTpA7kqAyuLThZnT0n5sJd85huwcFrm1qWu2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VgZII1j8j8eZT3PnHOqL+dmNW+C6z887aoeLFSVsJWk=;
 b=XpgxdRxxIrHPNdANCSOpw0rZO62TMZwX9Us3kY2HGiHA/JdCgBfRzgM2Vte7PKTB9mOb1eySrPXufhal/Kgm58rbGPUCthC0chrvgeotA4uajbuGORaPb9Lvs3cDYv5kQZ+bFaK/RmwLTXjSRsgvXprk0rQx9iiC5phiXJI2HC/AwjcrHfXyovQRW1p0ipL3PTKTJvIRFmz75ycHz3amGUJNRbqYtLSKMQTot04IOau7gwF/58i1cRjYsYWegCRh6o+XXsKy+/egC0dBFLj2t6pp0jlZzZ1aCTNle9J6rqxW4mwkEtx21IlUuFLiiWqe349GpwBP10NiToO1rtK8EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VgZII1j8j8eZT3PnHOqL+dmNW+C6z887aoeLFSVsJWk=;
 b=oHDIITRLN+QtR1k9boVjfPI3lfcNjB0CbCEB8y7yRmDTWXpjBezp1ORisII9L75Rb3tDjtrLW8+s6z92C5/7jOAZW8kzqH4COsqtDMH26x+LiO26O8IXxWzv+EjEkmjjFkmrA5+OocE4iouvIJF+wFRCcWGwo3JL5sAERLJSz5M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB4863.namprd13.prod.outlook.com (2603:10b6:806:1a3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.20; Fri, 10 Mar
 2023 20:16:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.020; Fri, 10 Mar 2023
 20:16:37 +0000
Date:   Fri, 10 Mar 2023 21:16:29 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v5 1/1] net: dsa: hellcreek: Get rid of custom
 led_init_default_state_get()
Message-ID: <ZAuQHdPHNYB8/Von@corigine.com>
References: <20230310163855.21757-1-andriy.shevchenko@linux.intel.com>
 <ZAt0gqmOifS65Z91@corigine.com>
 <ZAt6dDGQ7stx36UC@smile.fi.intel.com>
 <ZAuNqChj3MUNbHqe@smile.fi.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAuNqChj3MUNbHqe@smile.fi.intel.com>
X-ClientProxiedBy: AM0PR07CA0030.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::43) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB4863:EE_
X-MS-Office365-Filtering-Correlation-Id: fc1708ed-09db-4a5c-4e08-08db21a459c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QeRqXeoaDWOP0Iqq+MCVYC8u/23HsHUoE3QWYBkL+xx8XMnx3Nz4EIxie5+jKdfJlOJQNV70lXK8lY3mZEkE0IFK+LSrQR9H6DmZn3t0Ro3LHQBg2IYapUQuYcZl/UB5S3phKl3B4LylZIw+d1+smbl93p0Xls1X3vODw2yTIyX/w5SE2P82eJ6/DaFAimRC6cgxaMsdRb0ZfNRC4M68WgCpU5DYKGFwufS2xcleKlLDd4Fmg9mK7rS0M99fIQbM6qbm2d3uL/pneXRDxkSPSaoWV5sUU2hSAp9uMMSjKMmg1NaGNWOAGzUSPqGGP77cZTGrhNdZHx4ytbOEFpE3u5byXsH5H9IHAsYZWAm1MZfTRSzHVnuUwVplnRisd//uou29j1tXa3lWQTyWh822fE9m/h1CgdPGWAvXNHd7vYK2RaVqYnM6mKaSNPwL9aqirOu3lNMThW5XzjkaRHPHxnaBhR1Yv/2jVj78qSZU3F+hOdmd/RbHiOQpJUNyfaj1kxMi79w/Fu6XWQPUwREOmsZJZw+3wdXp+M1HK+1eWmJbh+XjQOisCDW6JwoyQIKmHVxAW/XI9b2ZVgoGGKxY7/OQOtosLhB6tXbAdJPJmW96dixCbtiA7X5ut6+j0jw62lmJPgx2Pa2XdCUtRjQgG7P04rPY3re3Xhu/Qtax+yA+9xka22BGZTwIlvjT1cpoOM/IKmUjBeyl9FSQI3Qvy8Qzz6TUuRuiDeOMbkUFd3QLuT1v1G2/d+ckNQkoK3zm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(136003)(376002)(346002)(39840400004)(451199018)(2906002)(4744005)(44832011)(5660300002)(7416002)(36756003)(66946007)(66556008)(66476007)(41300700001)(8936002)(4326008)(6916009)(8676002)(38100700002)(316002)(86362001)(54906003)(478600001)(2616005)(186003)(6506007)(6512007)(6666004)(6486002)(26583001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w1jTGOUZ3VujNM1NHZky48y9VYyMnN5wtoDsO4Jwg6R7qCvtQMiObQT+gXw8?=
 =?us-ascii?Q?ZH+40NZW7aQqzENX6o3ldlsk4L8W5lwm9XGaV4gPF8G3DKdYAxUkvUuwrLMu?=
 =?us-ascii?Q?LQbAbGB7kek7UZvaGEUHdTTAYgTjh9I400GNt48DlEqLFaYDWLPHA1jh1Xki?=
 =?us-ascii?Q?aVxqonTaQg9B7STdh6Qn6i0TlMZHUAKcpbKjn5yMjDU5X1jPLWa89cXvMD3e?=
 =?us-ascii?Q?fOMfXug8aGW4fWuKzxmUvusGgIw6RKWqVfVhyfqKj7LWTYyHfX7sQ4AmN21Q?=
 =?us-ascii?Q?m4xou3i89ZqSHqq84HxpIKZCf3hLFgCYD4RmKzk4LY1uIAJiPDX5WxO2pCMs?=
 =?us-ascii?Q?I9OVzrDYD6HL46rWXAYAU6vIDJQkMHR5YDAXjTpMHIT1YP04Crh9n8lgJyPN?=
 =?us-ascii?Q?v3XLEFsQT35HXAa3/pPa/YtTOO5NZSaLva6InuAfGZQuaMvPxKv3mAtCOkxv?=
 =?us-ascii?Q?6wASgHITjmjyL07Db7vrRlhaxTKd2zRUHpdj4fSv/FwQGtmxbLcqMA5mEzM9?=
 =?us-ascii?Q?koG3z7sYFHtrlZquBPaubW/JocGxJUBaDtMzo8JhgUvQXu9WgiD3oUNLFERB?=
 =?us-ascii?Q?sO7HOvmQ/4E6SWFz0sujUKhB2/BhuFqRcCRd8YTGIicnA3PgsS6vgZeEev6F?=
 =?us-ascii?Q?ahM4EVXcrZg6o2QugCLgrgloehS41axBKkroi8NpEGcjd2MROyQ6WIJwmZPR?=
 =?us-ascii?Q?9yohj9GDcXhIAoxFhSp5oHM2t3IfbVsOTZRtxd3Uj8UJKaodggVlDYQy9A+r?=
 =?us-ascii?Q?G6sIG5FasulMf0MqJomUsRNZxDCbTS/l1tkLXJo6FkgDsuk4/WZmSxRDCeLE?=
 =?us-ascii?Q?FbWX7+imVBSGs8MCRaMwrLlSttjLgbdFrhMH4Az1kLuf+MJ7wnlsdItOWFG+?=
 =?us-ascii?Q?TiHgW9AkIh23nNU5w9IpP40U7G+yBbp07Pp2P3Z+kDhXlV3CHhJtP/Tenixz?=
 =?us-ascii?Q?ox0gEmwxUMjZBu3OERmIJs/7PHqciHjyaSVQwWUomS2QtKzz3TZH/dwLL8R4?=
 =?us-ascii?Q?w7mljAGFQaRUgvQsOiy0d/ecs/l5ke1KcW0TDHgPvXjt5Lrn6VHjLkp/aqlI?=
 =?us-ascii?Q?aSLBiXUvVb3Bnypdk/42GNny16W9kZdNux3tzsINhKaresbaiOVKfrfjmN1A?=
 =?us-ascii?Q?al1B9VkU/UF5Tc9QwPdeEYP/plIDuFCqy9vN7Fc5jPGUZoOsUq6vTIsFUf+W?=
 =?us-ascii?Q?V+hAfJAVSGK3VYzgv2GqQCBucBfkkswMMsNdHeibIMhRBFBdSkAt0UC7cjG3?=
 =?us-ascii?Q?4SyZczFgIY2CR3FJLRJdJgP8vhWI+Rm/XaxuCvN21vOs00BxO3T4EsooqteS?=
 =?us-ascii?Q?uycpjotuPBgdmf/19LYdecbPn/ul+iHkjHgHXytn6BXXw9vy3WscgIJQcc1f?=
 =?us-ascii?Q?ei+eQJKX2g51Z9kG6Uu492KuLxoiZwM+wqbLtv541+yWbcAXX0cowMzyvyXq?=
 =?us-ascii?Q?tOoOQ6Jja5ysgwwg3UGwtsqc3kCsBZKAsZokVaFIXdX1W0/qkLO7eqtvh90Y?=
 =?us-ascii?Q?eFHhL0gMRCLNBIV6qptTWdaO8cuXM9mK6tCM1ZTonsjohFW1vH7s8M+XqADt?=
 =?us-ascii?Q?i4E1rVlHKYqcvVekD/FFYHtc50iX1QomxagBNTvHUNmL5bmw4Yl5qgS0ttxW?=
 =?us-ascii?Q?2wUICzxfBzAJvOER2UkKa5Sa1f1FpTeHzlT8quQ68mWIexHYb7AmSvd7rqxT?=
 =?us-ascii?Q?CHkquQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc1708ed-09db-4a5c-4e08-08db21a459c2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 20:16:37.0128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Rz2m+pwo1HxgQsY5rTJifWEE5zjdNBvMbGDzyg/vmPkWyuSJdUuMgCMze+AXFG8JzPteZQ58RLg3KWuBKCglazRach3Vb5APj4NhjuI84E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4863
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 10:06:00PM +0200, Andy Shevchenko wrote:
> On Fri, Mar 10, 2023 at 08:44:05PM +0200, Andy Shevchenko wrote:
> > On Fri, Mar 10, 2023 at 07:18:42PM +0100, Simon Horman wrote:
> > > On Fri, Mar 10, 2023 at 06:38:55PM +0200, Andy Shevchenko wrote:
> 
> ...
> 
> > > This seems to duplicate the logic in the earlier hunk of this patch.
> > > Could it be moved into a helper?
> > 
> > It's possible, but in a separate patch as it's out of scope of this one.
> > Do you want to create a such?
> 
> FWIW, I tried and it gives us +9 lines of code. So, what would be the point?
> I can send as RFC in v6.

Less duplication is good, IMHO. But it's not a hard requirement from my side.
