Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFDA6D902D
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 09:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235666AbjDFHJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 03:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235892AbjDFHJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 03:09:19 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2119.outbound.protection.outlook.com [40.107.96.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 821C6AD05
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 00:08:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BgS2Pga5wM5izGmAT2rjNwongneu5G6qUokmJ2xdRAeURTRccm6krTktj0zZuSAcDr6ECTm/Z/BBARO5uqsKA8DfY0j4KHhegTW1A+S2ZkzUlzY+lqbRLPGdkF2WXjPldbYodIFbSww00/jgCjckQVb/VxW2k4E7pyEYckOckSeVd4UC9O3dE7Vu3K16OJLgQf6mwmU4yIcZg9Rahh1kB6cq/9aGi0CTwUkHego0zxvrbgDU7d40aDY9TsXp4qIt0hdRv1HZ84fEaSNSMfuL08lpTik2tGOUJ4JZfFB8FXVm576frTcfLYtIopyv03UMLiiHXnXorBl9weEBaGVWwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mIY5m5NvdO3V/i0KuTvkM6Af80P+MhYvoWRDc6NG84Q=;
 b=G/MhVk81aSfTUq20ztF0+BC27jS1Kat6N3lpfuQ7C8Wutb7duWcMgAXMAQvl2iMxSsHJkkr//bCDCG3mh87Tfck4aeNKMJq64LPb2INFJNMmeyvttx8SpFixkjLZYlD8xm85rJYI3IV+SIgUoANgCEKvPFT+/GOBH/Pf8x3YTOcyP7uL2SHXs8QkyYDMOWTJ4jOB59xUGvRVL1gdjnn8YeAsp6nCwozkq3dBFaQDf8zmBz/1zQt9tIHd/vdxR+mdYDV3V8Kugws6Osg9Kf5mh6n4TtRfGLhQ1/O09VCg8M3qg3vVsErFG1klSA/L/W3zmyQPYc696xC/3gUaAlEiJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mIY5m5NvdO3V/i0KuTvkM6Af80P+MhYvoWRDc6NG84Q=;
 b=iLs3H+Ve8F8XqELhpZK0HJBFn4P3USakYOlzDdNxF6C3/pwEx5gXHaKH33QPdFeqE8cf3+fS3G8QlesXISsOjEt6+3gXEtM55t7hjNN+4HfFr2kSj9lorfYd5WrB64zZNX7G8q0syBDIjVDT3eym+kQ6Mk/tU07vZDcThbM4y/g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB4976.namprd13.prod.outlook.com (2603:10b6:806:187::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.30; Thu, 6 Apr
 2023 07:07:17 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.035; Thu, 6 Apr 2023
 07:07:17 +0000
Date:   Thu, 6 Apr 2023 09:07:11 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH net-next] net: dsa: replace
 NETDEV_PRE_CHANGE_HWTSTAMP notifier with a stub
Message-ID: <ZC5vn9lNyUgWwlaR@corigine.com>
References: <20230405165115.3744445-1-vladimir.oltean@nxp.com>
 <ZC3Ue5i/zjZkvMGy@corigine.com>
 <20230405200705.565jqcen5wd3zo4a@skbuf>
 <20230405200852.k7cfnjv442mxoscm@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405200852.k7cfnjv442mxoscm@skbuf>
X-ClientProxiedBy: AM0PR05CA0096.eurprd05.prod.outlook.com
 (2603:10a6:208:136::36) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB4976:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ebdbfb6-de69-466b-70f0-08db366d8e94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JCyBWY1AOv8haJrFcUe54Z31/oQJRzwkbJ4czhxaZo1SurZnAmklBea3VKhWXN7nypQ52yy3IcR6Ur+keGadz4SAFfxQ2ZL/UDY46KZ3hE5PfBy68ov3v8+WJLs4YUxER7OfzSLnC2P0P3Co40u9gO/71EOeVAvOk2euVHwGR2hf3EpghAB1ipTyiTH6FU1ngbzVdUASkvZ2Lo+b/W7VueiGs2S4myRvC76DhG9eCCw0mGlBuNokqh92Iv3+GdTkcIPdh155OCH0Qn+ABPUI25HBdT2+kfEwDwVqzLgkcVjG5bh0ZDTsx3I25hz/gyskNvuHVC9clEgCbNL9NM4CkKC951vwRhJJPWy0XadUaq+V1+Yisf1TcWRV3vUbK3+Dp2qXy1tCIl4CUSqQGgunxRgoNtXE/tOFxrhvE11HoMcJIwhjGQjPLhjdQZpI+GBFkdJYV7BwGtZGG3OSYUMBUg5nPYjCaYXgcg0XSqDxSOmmwih9aEsi4YKRk99HuniSCf5jvj8N4mD2IuRjd1YXAUbvfNn8FSTNgkWv8dnyr3pAWHEyIiI+1daAx8v4jzDNCDDYZCzSnZPVOacW1PIe0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(396003)(39840400004)(376002)(346002)(451199021)(6486002)(966005)(6666004)(66946007)(6916009)(4326008)(6512007)(6506007)(8676002)(66556008)(86362001)(66476007)(2906002)(186003)(478600001)(316002)(41300700001)(44832011)(54906003)(8936002)(36756003)(4744005)(38100700002)(5660300002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nQQdITDqGRNn+9EWjFdMDZx2giVe2UTACMKf5+/Es5WywHluZRm2Szsl2FUM?=
 =?us-ascii?Q?cBMhAMiB5UFc9tBcu70sbvNntT0MzqRWNnX9Bm3Cze+HucRfdglI9G11UpSF?=
 =?us-ascii?Q?bwP6UsQFXqqcfF62aASx0udWkHf0Zsjka3PyIzviCIlhsTYtCguNYQneznQi?=
 =?us-ascii?Q?VVZ7Jd/VaYJ5SpJ2GoF9fTD3Kw6QK8yvJVCfkHs5Fin6K6UCb9aStuStoKF6?=
 =?us-ascii?Q?E0ya9wiIXQZ8bb8bK6Ez2oucQTxeoLZjMVtzFIbxdtYyCgckQ0He4vE+447q?=
 =?us-ascii?Q?tvf35VfRH29frn5Koxoa3K8mn6tbS6pY3Bd2h0HRnNSq2nxWH4YLi0qNounJ?=
 =?us-ascii?Q?Y2SaQbm1hP25wXx0hJ0I/s43cqidDiue0XajT4u7ii5bnY2Y2Au0zdS/z0kO?=
 =?us-ascii?Q?lLyIVlQMbb+8Payw7BX2xJFiD9HzGTvzt7wsdXdWSY4vfILGkVfE/jO1TKls?=
 =?us-ascii?Q?1NwW//WS1hQaEts+0X4ddYEp88rbbfKt68OXcBlHxcBCCfh9i/1r4Dgho666?=
 =?us-ascii?Q?NhYBcHj5KiJJpwzhia5hsIZIStuhgScCLnWV4Ox/DT6Oc7jgXyN/cfWP2DTE?=
 =?us-ascii?Q?o5z7rWQUFfHmVcEZppvTMBe6vE7v6wFWsQ5NCBo8Yzgwe6ClHNXL8/W7KE/I?=
 =?us-ascii?Q?SV3spuJ+1MTHLSHeg8V44x8uIsZtorj8f8yHbFy/nIialj64h5cOSe+qdQm9?=
 =?us-ascii?Q?OOWM3Q29SwrV+7++ycRbJj6tkrjgxnTHHjx1FIc+cID0WThjJi/jm/iIjD7E?=
 =?us-ascii?Q?xeGOyGOM0K1gAHb4VVQXBM/l7YF3V88FfThBrcSsHK0b+LCNy9oXSpZyRBkn?=
 =?us-ascii?Q?YLOhgEPyxfgmeUuMnvKWoFZKt6X6inYc1hwyYgFphwaRATrxawPaHYOdHGH1?=
 =?us-ascii?Q?ZO/B+vKdORFc8+a+302WhTGpbbSh3EzDlLxynxpi/e8cOZ/XcC5v9jv12AuE?=
 =?us-ascii?Q?LJ7LDN7CgQhfXVTBPVyYrs9jHzakQY/7psqp6YiBuLcO9+g4rBnbKVU6q2TB?=
 =?us-ascii?Q?i7YxlGD3+9n/L9siz/q8loQbGnpbhHW5XrYMD4NqloV2hLmG5OjweQDwgUfo?=
 =?us-ascii?Q?Ww31iIMQiZAqSXWwCMBuQi6gChbs4hA7GCyNdJAn59agzT2um3WaTMRu7Tvh?=
 =?us-ascii?Q?N7NP134f/Rt/y1x21ZxJW1eceofM8dryjGF5LQRBim4MC2l21hXFRDUFBinQ?=
 =?us-ascii?Q?xF+AN3ilIy2mb0wbYZqoSNMH6EUIE6w3ViDEWohIvkIDw+srybr0pOW2TvyS?=
 =?us-ascii?Q?LajOmWUN3c5D4ToSGS/nf9euI57/N2MsxzY0YYRZjPlunhW2jSA3dTIIVJxa?=
 =?us-ascii?Q?GonKlQvFVtz67n/9/q2KpHKZMDlopVAUVyPe3pD5liXxeK1jEJHB/K2Bf8QX?=
 =?us-ascii?Q?boR7WeYzz4uaL84FIbvqcOjPq1/qx4kWiQGLitxjPXpZ7BNVOtMC3hrmuuSv?=
 =?us-ascii?Q?WDWNY1TMpD4drP/regiMNg+r6fH/vnptDZ2PHGC8IsE32jS72CSngzuX97do?=
 =?us-ascii?Q?Hk+hNdiZZHXmtzQUteIrURYSZeLRvJlSwlrKVvOixTvIgP4TZYDFpjxD2ARJ?=
 =?us-ascii?Q?L3cPu7kZbo59ejwueaNCeWwiO+TBywDXq+IVZZ1d+E+KbP53qW3CjSWmaKyJ?=
 =?us-ascii?Q?6WTCrS+Pnt4A94IUSzwJSvFkTq8EoGA9ZhODx0QrI5eAG9ovhEpKDLloXu8D?=
 =?us-ascii?Q?Srgaqg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ebdbfb6-de69-466b-70f0-08db366d8e94
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 07:07:17.6203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X6YCxV2r8GSTEKwPeXudZEuNw8yy191FGmwsGypTv3XDibPDkd2WdUq214TddppozKTtvm6/+JF2m35aQYq27B4j+0pDnDHWVITTY9bmAiM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4976
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 11:08:52PM +0300, Vladimir Oltean wrote:
> On Wed, Apr 05, 2023 at 11:07:05PM +0300, Vladimir Oltean wrote:
> > On Wed, Apr 05, 2023 at 10:05:15PM +0200, Simon Horman wrote:
> > > nit: clang-16 tells me that err is uninitialised here if dsa_stubs is false.
> > > nit: clang-16 tell me that extack is now unused in this function.
> > 
> > Thanks, all good points. Thank clang-16 on my behalf!
> 
> Perhaps I shouldn't have left it there. I'll start looking into setting
> up a toolchain with that for my own builds.

I did this a few weeks back using the toolchain at the link below.
It was quite a simple process. And well worth the effort.

https://mirrors.edge.kernel.org/pub/tools/llvm/
