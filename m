Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9ACE690ED3
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 18:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbjBIREn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 12:04:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjBIREl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 12:04:41 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2108.outbound.protection.outlook.com [40.107.237.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C06656AA;
        Thu,  9 Feb 2023 09:04:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QoOHyGwBbIOf/hXrU/yHLxDJqNTdpqd3+kIH25Y7Y/o0UsSH6TD5+BtWFZUhBl+EeQsIcR4u6jBcf516c9tEcDkWXTBa+da10/Rb8KeQ/7XuxewtyhdkItGXwWviF+ANSxBswu++81bKTyDNuoOB898KOzzzvorRpfyQyyc9BPsoX171KUkT5WIldh57drK/rG7DD5dw4zZoxE9utBuFqfWnw4NAzT56+sPOxUIWCSq/LR0S69MwlGL+J6uGGTgtDxlXwpthIfLxt/Kl/RiRzVExQA8tCiGT5/dDNJrKhxeMoccHBfkrkZGuN1hyb/I9Oml4Bpe2pTTtPuaFJJlc5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6LPt74rPkPnsGk8ULwOLVrkTwj2JXJUCrnOpYLmBPjM=;
 b=F3w3fjQ5weasCb6TEP3clT5rDdqy9ec7C+D4b0bIkMkbrQbmNf1CZ6cfw2Ey+wTH0M5meo3PavOetQlwzcw2ZkCsG0I6RyYvdlyP/fE6Bjdam8M+vEkXEQZmAuDrGzUVsByDOoB9Wk6GlLsB+jbcVT/PN8wprEWpn0GUMp8HHjVh9PnxZGW3ZuJSpZ7gXgft2SrnbLk+OtYCPKu6skxVk4fjtSuX4AbIVLhnEw39e7SXfuolfH5YObzxODnMeqartKxfYOE7WsRkq9e8B6AqX/0cpkfmxZgmfFD75FEPsdyGHEkl7RCZHKY9f8Py5rgL09C0mPn2BQkSO89pOHNbmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6LPt74rPkPnsGk8ULwOLVrkTwj2JXJUCrnOpYLmBPjM=;
 b=hbIxIEp8Omd4LjQY8zgxZG6D2PYU5JfyJ2+rCs/ceeMtIjM917ZgusLIWsxU16UgDC0GBrhKqXmv9xEBudNPrZJSe42uIPQ27sowFg/cLF3Fg05lLyEty/XHhwZ3F2N8yWDH5coKi6WThBp5HwjaY4AxMim/9+C2Mf/Irwln7+k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN0PR10MB5046.namprd10.prod.outlook.com
 (2603:10b6:408:127::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Thu, 9 Feb
 2023 17:04:35 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa%4]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 17:04:35 +0000
Date:   Thu, 9 Feb 2023 09:04:29 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Arnd Bergmann <arnd@arndb.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: ocelot: add PTP dependency for
 NET_DSA_MSCC_OCELOT_EXT
Message-ID: <Y+UnnbziFW097BD9@colin-ia-desktop>
References: <20230209124435.1317781-1-arnd@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209124435.1317781-1-arnd@kernel.org>
X-ClientProxiedBy: BY5PR04CA0021.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::31) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|BN0PR10MB5046:EE_
X-MS-Office365-Filtering-Correlation-Id: c09ff716-5e63-4883-11f8-08db0abfb7fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zTfD1Qgnaji2xXWoOU+kBlSCJGc3ZnQT4AzYN78EdLPAUHjfT19B+OMfNNgJfiiUebybPYeYVPc4tGrZKY4v2luowiTDdR+TSNBwUAPM1BNw7ZC6GhyDo/5xGu2BCWAe579KPg6KCcc859fZ+uuUe3hdiEVTFv4IrujwTM4lum3qMylYLeE+M14/HRz3TP+xvesrzvXcBim5at1jTMm1ThPFinTOTjB2u7XdbX7j31R7u9JNXH3+LJqZiAhdvP91O7XuW369SRX7XC1aI9HUT0mwqBGNR6ShWNg1tst+rEoA+DShL4X+mT1rwtsqXPPrKpZ5uNCI4nbPiaoqemc9xLK6aOhZ+SwyhChcTIopf1UxqqZLMhr6fHHxc/+6E/e3u6MwNO6GKOpspQAexWe8U8gZF9RNgopNP01Tgmmiozf5vjTBtUUXNWXIaBitxiNrf45DI04w4V2PNy28o01jJ6snqr643vp7feM2blyVvLuWH9LGuKdq2AeE10y2fZGKQI98a/1PahmrX42tmPkqyNKnDL2PqvqI1BEnmNXQHaqNLZ7GgO+I/mkKATl6ag+f/bssPmPEVtGqDllbUh0AnXhAqI+c8iBsIAEcIZL3tmqXLB4KkWmnOiX/jtdOrqLPoK1hprkEMCw7NlGiHsSjUHtZAdb2neMlBhCitne/qftt7DqeJI3Z7h8zVdZNKsOh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(136003)(39830400003)(376002)(366004)(396003)(346002)(451199018)(6486002)(8936002)(9686003)(6512007)(186003)(7416002)(26005)(5660300002)(66556008)(4326008)(8676002)(66946007)(316002)(6916009)(478600001)(6666004)(6506007)(2906002)(41300700001)(54906003)(83380400001)(66476007)(33716001)(86362001)(44832011)(38100700002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+wV6BXp2O6ct3/MjRpu2NWFzoU+CuGLoJprimwNWLdw+uU1nkl2RiO1RGmhj?=
 =?us-ascii?Q?3+ipAWohxUfWytgOuKHSobA7K8UKz++y5moZiLyXbHIPWUkUmBn3dBfyA5jb?=
 =?us-ascii?Q?xP3/6Rzzecftu8DxhVzWW1xzlLZ3jC2Kgo7daCRq9uFCsu4L7jl/3PL40xo8?=
 =?us-ascii?Q?hHSd97xYg10fj/GsDRniH/ECrjlaMdOSzcX74smw5ENFwdQPCuhI96zCmfA4?=
 =?us-ascii?Q?64xzpGOU3TPK5RP84B66LRADeNC9sql0Uv6NbW+O+yqX3cztUkAR/k5Un2Ep?=
 =?us-ascii?Q?oZgg+zCmgLLzSunj2f+ecki/aMNilOZWW+WC8WLXkZvjpqtARdI21JtwhpTY?=
 =?us-ascii?Q?nLc9zErBn0H3gZxA2C9/y3FBy+oF9bEJqkn7W7JmhZqHWQjDkMzxvSrVIbkf?=
 =?us-ascii?Q?AVTRhI5wCke+dOoNYEtkbyU+CaYqQiEfVAr9zHFJIUYSRm8oHoreqnXqzjzT?=
 =?us-ascii?Q?DTJmzSP1Qapn0WSVOKHpl/1ZNyHmQaBLsPWeL+Wa/PdesVCZLDp9Aslp6hA0?=
 =?us-ascii?Q?M42jObkHlpRHt9J52xMNArtoAfKH1XfjU65DGJRNc4LqweV/YHZBCPYZ8Pjc?=
 =?us-ascii?Q?YASmikHrvTtEVHIgvTohS16wNfInqitu5kKQeX+EBs57FqyIhXKEC4iz1iyU?=
 =?us-ascii?Q?wjeLRHKkyc+XANQt8NE9k+xt5jJYMwgma3VqVECazIPzRGLu9R/+Aoy0azIp?=
 =?us-ascii?Q?LzagCSSr1ZKQrfmwOEkZi7/95R0/ACsRus0nqJmw52Ex1SYzUfbw/SdkYJM+?=
 =?us-ascii?Q?BDAsq68EzDxOLDhukCzdsL/qYIP6g2MT/HTbE5MDECaudHqa+1QPw9wFtgr5?=
 =?us-ascii?Q?DjhnvkQWty6eM+4rygu3PM8xQ2wS1jHYSr8F1bPTv92Ula8k75zcsCppDr0O?=
 =?us-ascii?Q?pQ/9ypOAYAtWw6WpjQ5dnbOkTmpIo3XWXQ8J3FDfV+6t9t1uyzKx4X9QYXZR?=
 =?us-ascii?Q?p9EB++Oq5KPIQ4uHU3Mm56dOhyyDGY0PoU81m7ubR0b8FbsY7J+a0Xeftye0?=
 =?us-ascii?Q?rLzxggKizYUIOR9z5Q8l1e4o0L6mto2yGSa3AsWy7m497lq8r+0SsDxoUTDq?=
 =?us-ascii?Q?q4LyNXPLm76eYXpvB3uNvu3RcE82hRDUebZGl5qZ9srk8XY7aGbHpFoaWNBx?=
 =?us-ascii?Q?OXWCrkeuGeQf7EEduXNoPBLPCzPf+x7l94fQXwfz1hOmRuAy688mBuhyBVuD?=
 =?us-ascii?Q?b5i5PxRWrhKGI3xg/kV9d50kxs/aaS8gJwziR6iIOx2Qb4AqSnE1Nwxjv2Eh?=
 =?us-ascii?Q?+wMpS+lbiIidp/Mb3iVo4AGccG5aWpNbdJAMxPRL04uE5fwLB2gNkB0GJPrz?=
 =?us-ascii?Q?6bddsNDLsoceFx17s19puvZkSGMazNENW1S3uAnamH1znY7F3nKVjHBCddDf?=
 =?us-ascii?Q?67TbLL2VxTtP6h19O7f8SUup3/5mRb9h7brfJig3lPFQmp1sZfeOreTxarzS?=
 =?us-ascii?Q?LfUJKqCXWcZPqv5VrpAs+vQGtqDy5zAbpmo/7/EnAoH+QPo8iSHIRbVnw06l?=
 =?us-ascii?Q?HRNOzWNkYtdiop0lWbGWVRWk/Mx80PU3xSDhXhDW2ZFFdL+0HVYs/hcu1xC+?=
 =?us-ascii?Q?JvNPA4Ul+SaelgsuUerPDi11NrUadAtlhxXZUo+NiVCmcNASRahCexKaij3u?=
 =?us-ascii?Q?W9z6kX0yzQIysyngX7Kzcvc=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c09ff716-5e63-4883-11f8-08db0abfb7fe
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 17:04:34.8875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +iSRphbA+Kruv+NXiUfT5TRREqkzdH3RX44Hc5p08olEcbJMG9JImV8pYSc1n4H0RxiexncMhkSSCHBGM5CvOUF0yyVyXUbOlKA84jHFWYQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5046
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

On Thu, Feb 09, 2023 at 01:44:17PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> A new user of MSCC_OCELOT_SWITCH_LIB was added, bringing back an old
> link failure that was fixed with e5f31552674e ("ethernet: fix
> PTP_1588_CLOCK dependencies"):
> 
> x86_64-linux-ld: drivers/net/ethernet/mscc/ocelot_ptp.o: in function `ocelot_ptp_enable':
> ocelot_ptp.c:(.text+0x8ee): undefined reference to `ptp_find_pin'
> x86_64-linux-ld: drivers/net/ethernet/mscc/ocelot_ptp.o: in function `ocelot_get_ts_info':
> ocelot_ptp.c:(.text+0xd5d): undefined reference to `ptp_clock_index'
> x86_64-linux-ld: drivers/net/ethernet/mscc/ocelot_ptp.o: in function `ocelot_init_timestamp':
> ocelot_ptp.c:(.text+0x15ca): undefined reference to `ptp_clock_register'
> x86_64-linux-ld: drivers/net/ethernet/mscc/ocelot_ptp.o: in function `ocelot_deinit_timestamp':
> ocelot_ptp.c:(.text+0x16b7): undefined reference to `ptp_clock_unregister'
> 
> Add the same PTP dependency here, as well as in the MSCC_OCELOT_SWITCH_LIB
> symbol itself to make it more obvious what is going on when the next
> driver selects it.
> 
> Fixes: 3d7316ac81ac ("net: dsa: ocelot: add external ocelot switch control")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

I think this'll have to go through net-next, because ocelot-ext hasn't
been merged yet... unless there's something I don't fully understand
(which is very likely)

Thanks for finding / fixing! I'll run a quick verification when I have
access to hardware. Probably won't be for a couple days though.

Acked-by: Colin Foster <colin.foster@in-advantage.com>
