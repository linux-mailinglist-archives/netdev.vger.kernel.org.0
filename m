Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D3167FA97
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 20:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234507AbjA1T4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 14:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232455AbjA1T4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 14:56:36 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2101.outbound.protection.outlook.com [40.107.92.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325F822DC9;
        Sat, 28 Jan 2023 11:56:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VHhiQDgADDWDCnHIZWyxkDFRePxrCOGxZ5l0KhyfMc/D9qsTu1L1kpbIYoNTeZB0VeTQovPSL4cC6YhdHsLqgwXXh4R9xFi7H89A97G7wqJ6XMsGuT6eISzgAXQNQxdLBdi6Sj/1l/J5BHMolkLHu/cerUN8rOVCJc/EhZk7+zpkKaSjKTCKwg8bhRqKJLYKyYDdHTlxoXutWt20Ok4DiHtdUjtLS6veSTz5M3o3QcIYDKH/nFYTt3/3pTZE7+u8tOlqRC8Kn4LfSHTDFY/JN9gHhcDRjVJbMqeiWmDKiEWiNVIYs5Le1H3UX62xBr5bCjuahmm+IOYu1T2bFuKoow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zgq8rfoNP1X+dGEXGbXFPNJI+FV7R2nGm5jnNvVWHSs=;
 b=B2jifLCxLdzdR8xVJnjUEX6atIfY3wk/hurjjIJOxgQqtI4ZBT+rDUTKL9pjk5gw8CvsXAlYqc4qbrp+7K+H8QmVif498C8DSuhS0U7RtcgENG4gd4Pwh1nweEYGWLeYIPaUkWL1hTvCuPa3CvZkrDTFh0sWKuaWWp74s7E9PS2ThWDTlT18rZ8xRKn16269SjsOpobutnbXqnXgtlE6xf3kYuGQ1yi7zdgJqEzjdzmHQD/hiBZzRjWVLfdoYtIxx0dNOAeJAfo9Sl7brXp0uWLP6vxvA016x8E9cVe4CJn3LovHbtaoDrDKAf9DInFAEml0emxBjHPE/m46Vp8KJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zgq8rfoNP1X+dGEXGbXFPNJI+FV7R2nGm5jnNvVWHSs=;
 b=u7+IkvPuA2rlMGvua+xw6YBFkhTm37wN2umFyMxdzof6kJ2O6FQsvErYfP+ho6Ruy96SVqMRFdi9yBn6qzkGfhaMOqe+61IvJ4wbgfb5faBCsh9JwjJIok6FBsPIaEU+ALaQn2mW5+xlx+wXA+aRXJ+ZOu7ocRb3s+y3Wljq6bQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by DS7PR13MB4591.namprd13.prod.outlook.com (2603:10b6:5:3a1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.30; Sat, 28 Jan
 2023 19:56:33 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::1cd0:5238:2916:882]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::1cd0:5238:2916:882%4]) with mapi id 15.20.6043.030; Sat, 28 Jan 2023
 19:56:33 +0000
Date:   Sat, 28 Jan 2023 20:56:27 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, ysato@users.sourceforge.jp, dalias@libc.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH net-next] sh: checksum: add missing linux/uaccess.h
 include
Message-ID: <Y9V963IQhnL9ieLk@corigine.com>
References: <20230128073108.1603095-1-kuba@kernel.org>
 <Y9VKZhCOdM4L28UA@corigine.com>
 <Y9VNY2C1CuHHo6WY@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9VNY2C1CuHHo6WY@corigine.com>
X-ClientProxiedBy: AM4P190CA0003.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::13) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|DS7PR13MB4591:EE_
X-MS-Office365-Filtering-Correlation-Id: 380b6ab0-88f4-42b8-7e1a-08db0169c14a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X0T+e0oUl8QQgWGxF+0JNE9TfJimrk/ikrSY4bwnS5R9CTdk5bIEBu2/qPZeeN6Kr6Ete/pjd+FmQhQAXP0rE9Iw4vyWmNOq5h3rYXJUbIQS/1gz6VzvlsFy/H3YOp6o3mXuCfheajZrxc5viAosRqS+gIg4taQS0sNa/killJ8AYzvcOUCbaPgSJ7H4D5LN8t3Q1lm468jDBEifbR1cVSIXW5VrKvGwtWdBGnr3b9QQaoddsJrKy/vYtChOL+F8QOShJF/5mRviZkjxIK/WfFk/c+3JWr7B80i4DdKsONVVpu6p0S2Fd+GTGbxfJCIJoYNoDcGRh1YJa8Sf1xBGIMnXmaB0UhFFOxJtb/a+8+7xAfvRRJ4BTtMQLIyAG8I8b+yNgPOpMvS8+Qu36L0gFDLZreGYd2tTo5b4bIAfaKQH/C5mxwLr4Rn3x3UCm59mCamRg13qjJ1CLMjU2YO312Xt+92lFV8/BaS3vGHTTnv5m58GpooiMIhASiJojW9gMfk6+8S5HyCmXn8GljSBvVWlGOUDGRgXQa9lEzFDbLWzXpps7Nh2+Utn1wpKx4RpMuZIbD9bKqy6kNil5GvLWmSXycquPcYfFXE3CEbL2AbIaaI5bB9llBLRimr9aJCz1Sst6/2MdFivlfJYrkJ8HAMzg9JB5BrtRsKbYmdOcPFAfNjLparqaFcJTkUvSqP88F0c5F1ipRlPTJwgrr5xnd1MrW62cTTA/d/BfE6WfTw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(346002)(396003)(39840400004)(136003)(451199018)(2616005)(36756003)(6506007)(4744005)(186003)(6512007)(44832011)(6486002)(966005)(6666004)(478600001)(86362001)(2906002)(38100700002)(316002)(5660300002)(66946007)(66556008)(66476007)(6916009)(41300700001)(4326008)(83380400001)(8676002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0gzFriPWH4Y9C8gmqjRlMmPzbtY7rA5LNCc7wkDA8N0iDX72H76wO/ROqAVN?=
 =?us-ascii?Q?eRyA3qs82iWvA8UJ8SF746R0IXXC3nuiaX/Ao50g8YfT2FNWkvmhRk5trgmx?=
 =?us-ascii?Q?K26i7u9qJmg7JAMQDrvMk4W9yHPpLNCxF2gFpnXf/1ysnHCMEV2gmj9W8aXe?=
 =?us-ascii?Q?adR+YAZReKSfTL3v+4KPrrgJWsw/ExsYnokz71lMBshx+nlw0JjzT6fN60Eb?=
 =?us-ascii?Q?kJST5rOmzpfL5RujpRasUa6T4OI/EX64Lk288qWefS/t0MzTwAkaT693XJ23?=
 =?us-ascii?Q?VIRZgx/RRD6dDvRMjGKPr6LWwZk7fhNdW/wqTaH3Q37C/gw1pmjn0lwZ/nHV?=
 =?us-ascii?Q?BfBlTg/de1eMvvKB3zd/F9Usa1J/HB1j0jDtmq1vrtsiJYoNbdGE+S4bBsgH?=
 =?us-ascii?Q?b54apP+5W+iSRs03VUV+zlzghwJPcU+QrB4IIVni2fGBj4Sn5jww+t40WyN9?=
 =?us-ascii?Q?U5uc7aeE9XeRriJsiE8krvbQCblcvnkkjlGjQAUsZ4moHm2gLmdTmlsMU7/Q?=
 =?us-ascii?Q?cfH87euzIZXH/Xp3RA0ceSpCuYGXuN4OE3ap1DV2esPT/vm9rIh18+euhSaj?=
 =?us-ascii?Q?5HiLipwyAJir1H9q5FZrB4mdoTwjP8ZZ7sgU9n0uHl3jOKobrm0iV02y6ibz?=
 =?us-ascii?Q?r56qFk46OaERs6TiG4hv4FUQPDudXADGQNIkut0IBbJrf2mHG026ww2p9qhS?=
 =?us-ascii?Q?EZo0I/dtjY7ys25ILgbQ2rowGHxZF3IY4ppLMnQzB4GJjcjoDug+qbN/ilQb?=
 =?us-ascii?Q?K0rL1pXUwHTzjyHGXZM4c4JsWeBmVitv7wb6Ik+X6mDKOTO7dBB23YJ9CmJr?=
 =?us-ascii?Q?pEqvIad4KHwHV11zhqYZm2of3Q0VF5NUoJCswaiA8Q8aY8pVia/X2AZrjX+l?=
 =?us-ascii?Q?LdEp9bmG8uGrAYMlYZfwHJb0C3ps8HXqkRmy6yZXM26s23ZTmPWy2UH5LTpl?=
 =?us-ascii?Q?M5OIrE32SEWFb6gyxB6GhO7cR9B9ZhQr0VoTDHllsV9Uunbc24Hgk2VaMv23?=
 =?us-ascii?Q?sms63lm3B8rRh0De99FrXAxSqvWd4o4zfOZi1BHf0smJRo/Rk9jVCJm+1t2w?=
 =?us-ascii?Q?F9Hw+YfEGW+Tn+epm21FrzXSxEPLyEb6j9ZNKS+Csu7zJ1JeokVBnMGN9U20?=
 =?us-ascii?Q?++sroSFs34VuzzbdKmKghgfK1aYt3JFv+4EP2IJfNnuNkyGFLWmIsPkmYqQ2?=
 =?us-ascii?Q?ch1y+i5smaOogpRRHLDUGat/fWij9rLRce6UXMYzupkqOdNNb3e10do1NihE?=
 =?us-ascii?Q?34klBjS/07ium3S6dLltFGCy80Za5AQ6OecOUnGh12uix4TqbOWhAtS7laKz?=
 =?us-ascii?Q?iePpfn/Yfz5iv4fg/sy8w17nvdYapG98pLYipFVrFEeW5lzjl2U9udSnMM/l?=
 =?us-ascii?Q?ihEmuGf5Z1zDztIgxxqTyM3dYEVMAm466Fz6GGpiRaXL5Nz0NO6Zx13Y8m4u?=
 =?us-ascii?Q?XpR0+Ibz5jB1MsZKodr4wsV0RdcfHpgdARJxVMNJ5fqXaW/3mQZ6LWIdwMtT?=
 =?us-ascii?Q?99ZOlzwbw8EweZvpbs5/EO4AXxq0grN9rhpV4sa22clytBWqqQu2h9nEQVd8?=
 =?us-ascii?Q?szkSKAJvMglBnW+1OuEnENedwqQKUAJOi7KvlJOohnvbPv/FQj6FIpG2rcr2?=
 =?us-ascii?Q?mYPS6RlK/W3nIGaOkkogm7C5aQFxS5f382js1ukIBpmKQZIxSQWgbcw3lIgA?=
 =?us-ascii?Q?TZiZwA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 380b6ab0-88f4-42b8-7e1a-08db0169c14a
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 19:56:33.1009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r2+GpA5I/d8M0Ei3F65gsxc0K822bsmol4lpB6YhE8N8e2lDlQm05BO9pxXsp7EaW56EW2vL1e8cMzfbHoXv7up77Qw82szqfKhxzvfONkc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4591
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 28, 2023 at 05:29:37PM +0100, Simon Horman wrote:
> On Sat, Jan 28, 2023 at 05:16:48PM +0100, Simon Horman wrote:
> > On Fri, Jan 27, 2023 at 11:31:08PM -0800, Jakub Kicinski wrote:
> > > SuperH does not include uaccess.h, even tho it calls access_ok().
> > 
> > I see that is true.
> > But it's less clear to me why that is a problem.
> 
> Ok, now I see the kernel test robot splat.
> Let me try and reproduce it for my own edification.

Done. Unsurprisingly, your patch resolves the problem.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Tested-by: Simon Horman <simon.horman@corigine.com>

For the record, the splat is here:
- https://lore.kernel.org/netdev/202301281438.ZNGVwW6S-lkp@intel.com/

