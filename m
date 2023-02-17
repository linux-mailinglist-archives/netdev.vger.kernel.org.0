Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A16669A312
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 01:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjBQAqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 19:46:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjBQAqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 19:46:19 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2058.outbound.protection.outlook.com [40.107.247.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4591D50348
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 16:46:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X7YKtC3vikHCI6L6xigKcpTIsAGozIppgNVqbqWJ0C4E+rzwF3/WuMCuVX6gXWrwWKbKTGhf/xLcxh48HYu31xJZZ0CTerKp9R17YcVzde5SeiK0Li1y1y/8xg1T8Kk4b6+KttgDomk6Lqr3VafXOJDGAjU+SB8d2OFQoU6gz4NFSG2Ob3NROPOMWTsWKIpM0VUwIrPCmg3fGenZkVrL5O8Eqylz/2hPjKV/CT/nNvem/zGKZXHDlRQoBQ7ROmLC8U+CEO6nBPyEj3Dd9xchQgsqhs6Ga5hf24j3cahngLZHX0/WNyiDNr5qvakjM/cIcfRD5BgJuK2R0NPLlDUyyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z/64v1ihm9emFYNGpBEMn0YzfD0I/H0+a8GCA0P1wsk=;
 b=EYUjSfglDNglF0CH0j7QRqxfnBH011eqbT91ReyA2vQENX4aj13zXh951eALoUH1qhk0kElry4VNyLMjRePrD0luBnSRBYKD5mvMLYi+zcbfr7NKZng9W+YJqCEGJ5Uq4Fb0RjiRx1XU4Oi+TcKdIhKlPbZEecDP8G6pruj9uv105ykOXW5Md4A2H7sOoWFYqic51JYaflt+5U8DTtVjHZ5tscIPllu10VrAz+ofeDnVFJ9kvnLVK7To6pIgjwmBQdXl6w+oZi/wFvFTnuYGOv3GZDpluEJeF6XEZCVJe9nh4LJwovOTQK9Q24Pf8MBlxCLu7VLRhbOQxlhO5iRxRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/64v1ihm9emFYNGpBEMn0YzfD0I/H0+a8GCA0P1wsk=;
 b=nCTQZ6kMfWjHxWVN0+Rvcu3zh6uQJbCLbckzLwxJ7gVAypVRZocp76kiB9LrwCwLUNFO1BjKbEYsegrKo/hx6nugSapkrmx0QRVedKPKMoKAUrlczkajCjT+8thuEaQ7LbRng/6qDbf9p+LEXoyE5Oduk7th1ikXZNY8eOGHyzE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB7625.eurprd04.prod.outlook.com (2603:10a6:10:202::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Fri, 17 Feb
 2023 00:46:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.026; Fri, 17 Feb 2023
 00:46:13 +0000
Date:   Fri, 17 Feb 2023 02:46:10 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Lee Jones <lee@kernel.org>
Subject: Re: [PATCH net-next] net: mscc: ocelot: fix duplicate driver name
 error
Message-ID: <20230217004610.ozdkcim5dbmwjw55@skbuf>
References: <20230217003845.3424338-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217003845.3424338-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: VI1PR0302CA0002.eurprd03.prod.outlook.com
 (2603:10a6:800:e9::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DBBPR04MB7625:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bf807c4-a69f-48a1-eb0f-08db10805eab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 15NVy48e6uSgIe1ApKV6jkIXCjGUAC0ll0ajC8fZdJLVcP7xavzs8yrMoGAYu6lye8DvX1RHiviYmQ+zAz9qLioZiddOrOo2/w2RCx3txh77zZXHGGsQBByTlWQFHXRtT/suHTtDNpNtB6IhsD3a9vCWvYhb4NDrc4RRu2+9bBQ3U60huWxDFU839CeEMR0dMFzLmrF6UeerHzfAPs+g1BNoQALFnHvd3L2550M6bT0llIxeQ6/9XNHwTxFZlIeFBTiYc9hz2LoxICKPPu3F25dYunPkEIyk+ZPi0VIypxMEdySSxR7MmzPo4nqDTuvw7kSucBYHE3icAxMb9FVfkJHlbBOlqLREAiCPKVtGUkJhuWRT0gzD/vewZtvOE3/TN2qedP82WlR3S2BK6LSfywFMjs2Shaax/dALO3sU5ufbjljdMRCduHxVniPLJABXZfTwenFygSpkTjuEY/e1xuOifzCXwPDn9LAQptk/8dGKwJO+Cja+/9WsmCktj/K6N2q2Fi7BFbyWUNxRmdG1iijZ5ApjYJGDSbhT6FHgEQagehWPIpUZLMzEPG8/0XIxI9GgaA0rDTTyeW+oXu4RnO+EMm0wc3rSGMbpeqgtUAU7O5QWZW0TJZX011U4E9+2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(346002)(366004)(376002)(136003)(396003)(39860400002)(451199018)(5660300002)(7416002)(66556008)(44832011)(2906002)(54906003)(316002)(8936002)(478600001)(6916009)(4326008)(4744005)(8676002)(66476007)(66946007)(41300700001)(38100700002)(83380400001)(6486002)(6506007)(6512007)(186003)(9686003)(33716001)(26005)(966005)(1076003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?etSC9j7cq8D4FEuM4h7kwb6IYTkpQISNQtELLa/I9GWekmOQzA7VoiarA9U3?=
 =?us-ascii?Q?xiBE6Rpr8xXhHVlIihVe5UaV8bdCsbviKCJQ2sLtgcr3ovprVHemaBYUDwJ3?=
 =?us-ascii?Q?BexNIsTUMUr+Oj0UmSLTSKhpVy4swYQQQ8s7JdI7uCaX4H0azRX9GX1p9/en?=
 =?us-ascii?Q?EgH3JRcABZ9nn4sJYpzXTB3n7eCplzL725SSY30qrorqQsn/EY4QioVFGPWt?=
 =?us-ascii?Q?Z8AoSxjU4310uEEx1s2Ux88pKLv1jKt7mxZZjPzM9e50DiGxNNhBb1ZP68mR?=
 =?us-ascii?Q?qTOBHdogSd4NyQsS2Lkgq1QcX9RDa2eWd1AU0oIo90xw4ckqfetVHTljRSOT?=
 =?us-ascii?Q?eioCMP5mD4bwPxkPTFYriqe5bSYhQLcYCE2HEiG5st8ztav1Ntue4zBqxz8e?=
 =?us-ascii?Q?I90cOVmM2kkbMH5jOvgtaslXyorL1Idf/1tUD0eoJHVWvsR5ozV2mSlYBbXU?=
 =?us-ascii?Q?c6KrSJh58hDArNrhgJsbeOWV0uAeCBBpbjn9lnQCdw20ffEIZOb823XSFjYZ?=
 =?us-ascii?Q?LaKvy4gGeqIPHfRJ/WK8MJyXNkm4c4gokJLQT9sRWdIL4cdtX/BIVbVUhDXo?=
 =?us-ascii?Q?wGE2wO+JTNRipxr5s1DOlvOBT+cLTX9Et+a1dNDopjxw/3bGGarPjGZ/yvoF?=
 =?us-ascii?Q?q4TevKtFTesmQ/+EyJdH26A2UP+Wke9YiUAZyBdrv3RaFZErnWVqIqdhW6Xi?=
 =?us-ascii?Q?2/4AIQiwgQZhYvCoQZhTsdxXwB9LLs/mg+4AEToN7VoVP/E4axMXVH/w+/8c?=
 =?us-ascii?Q?Su99rBuX4h7bLeSucNokLLgBPjcH85TOHTcsh3DhHaqDPe7rLs/0uV31vDju?=
 =?us-ascii?Q?FitpAEvDqQcXDZoXq/rhyrDVSGym2PP8GDq+PX+J7KclmbP5DWQ8DbamKC44?=
 =?us-ascii?Q?PkFNzc3NmuRk7vBuWuNb0SXn4EQqL4cXCpZ5OkrCa+kCy1Ca6E04WZMe4oO2?=
 =?us-ascii?Q?yI6VLITihBDSLIImoeO0aNDl5whrjfZCzdp+MgJGC7lIfDq1ytI1OA9IXzA1?=
 =?us-ascii?Q?QNb7eQnUXUxa8ZbvDs8BT24s1uVjAZyGEfHVpSdDzHXpqJaMxw/7cCoBvFp/?=
 =?us-ascii?Q?a2JpGGdwWfuy7JZY0W+WZPyxG/cvRjhyXxVK6B/fU3j86ljqTZLx3esIzkTh?=
 =?us-ascii?Q?Dr7cb+SHYQpAm9nLq/9oWXgg55JCL3fo4G4ub8h/Y6r2zQUrMOVs25mTuKib?=
 =?us-ascii?Q?Ets5gccuxIk6Fq9lM1bAxfGiLWP+Ne6SGOy36Ztr1AI1JIU/BKB0QfTL66fZ?=
 =?us-ascii?Q?LNfBTwcEofX++/alFOO/jUvXlvkFt3oBSqiaJdd1BEPHVCNdgyT2j4Y1Xt/K?=
 =?us-ascii?Q?V7hRD6qwT6FfndmqQPw8f8hFddW+p0lqHaeAFwIqGy/f452xlfv/ePshV+rf?=
 =?us-ascii?Q?Ndx2JhWnu2lKm49XF/IOU8kLLBzQHzghj8oEb/lr6a9VMvhy5fb58MlnVMUS?=
 =?us-ascii?Q?NYcJxai3on+kwGI/qhUndL4XH2UaNyM3GYJRApM+iK9W83P+EKyUq69fzNwG?=
 =?us-ascii?Q?TL855f5pfIBLa9K4CobDtQFll8BapxIP8nGnFR6TpQI3yVGY+m0ihjIzNlK6?=
 =?us-ascii?Q?uqz8yl5xDhJc27DI0ndoApnrnXy9ztLa0tOQYuzgIvLaq57UsG4J3P/k1hS9?=
 =?us-ascii?Q?HA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bf807c4-a69f-48a1-eb0f-08db10805eab
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 00:46:13.4802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vUxmwvp+LG1GeW4krYWPJKvbDPd2kf/Ffv+PAbO3Fs5mes258UDc8SFfdpaVIhr3uU9LA3fRegTRZ7x7+0RzsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7625
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 02:38:45AM +0200, Vladimir Oltean wrote:
> When compiling a kernel which has both CONFIG_NET_DSA_MSCC_OCELOT_EXT
> and CONFIG_MSCC_OCELOT_SWITCH enabled, the following error message will
> be printed:
> 
> [    5.266588] Error: Driver 'ocelot-switch' is already registered, aborting...
> 
> Rename the ocelot_ext.c driver to "ocelot-ext-switch" to avoid the name
> duplication, and update the mfd_cell entry for its resources.
> 
> Fixes: 3d7316ac81ac ("net: dsa: ocelot: add external ocelot switch control")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

Patch will have to be resent because I wrote it on top of Colin's patch
set and I forgot to rebase:
https://patchwork.kernel.org/project/netdevbpf/cover/20230216075321.2898003-1-colin.foster@in-advantage.com/

Will wait for feedback before resending.
