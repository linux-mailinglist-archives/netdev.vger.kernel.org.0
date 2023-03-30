Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE3746D0F63
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 21:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbjC3Tw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 15:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjC3TwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 15:52:25 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on20724.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::724])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC37FE;
        Thu, 30 Mar 2023 12:52:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XWiyKOR3HRWpVgmyFMdIr6Iv6FlMvf97HPKahtOkWwCqojk/zytqqR5KJikCYMCKoTT28zPNPkAIBCYobqeC0qJoP9tOeNWqpYzDcaA/Wbj9TgHVPWzRADjkgToo60e+yHIgDBIK3kfilgm3Dqnu/HCRgBcQBwe9XOokTu7wADae+7/sL5f5bVJJGpq7PXrCFic56RK4I9DOA/CJlVFY6mDpWR/Es3r/wkAx2MAJzyy9FruKbABqv5q5E+AtOgd4UuLov0YOxI8fwJSqJQpUB4z3O7F3Sc09wyYoX/cHWGpS5NzVcimBQVGfNfSvSle8FgjuJMeVKxGWRpF7yBm6xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Wg8qnnVNtxtt0kyNrnsm2uXhs6rA02mVA9d7isQFEw=;
 b=KIgSiP/AREAFQhV362cuRaZAyKn5LcbLqPXj2+87Chc6368wdZu8rhnUAYkzE+d5EmozjZifLYLp6fRyQlKMCko2tIk3kVCCUrhU+QwaaZnjfZERgrYFe5ijBOrYEnqMi6tKWlKeTqi6D80OSzjoJjWIaBH+Vsw6dTrM1qxZLDJGJrIAJq4JNh05AEddh2kNvRrxpesCxDKrYnJvHpY82MSmCg4BsRQmgN8TimEW2YieR34vj/BowA4QsKhTZC1YKbNjnUL0jiPPAkJpwCrngY+EnuOvMYcseZgsJh7ZtvDT24KsQn01MdZrX9RK+J5TKk6gxA/sL+un/1WsjTEMJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Wg8qnnVNtxtt0kyNrnsm2uXhs6rA02mVA9d7isQFEw=;
 b=M1dwV/ZuO5JUQ5kCk8u2k/xhJkTxgYiL/tB2rl0payZF6njjAhr81SLURCdVh32h7ZOIIysjABpmj2w1ULwBL1eZrIY1QeIYJ/3Sy2gNAweeKKWIm1Q/1fPFsNwTpT1GJbAReseHfauWslEeWUGXrd8Gzpvyv9wn0xmsH1jjMlI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5574.namprd13.prod.outlook.com (2603:10b6:510:130::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.31; Thu, 30 Mar
 2023 19:52:20 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Thu, 30 Mar 2023
 19:52:19 +0000
Date:   Thu, 30 Mar 2023 21:52:13 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Denis Plotnikov <den-plotnikov@yandex-team.ru>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rajur@chelsio.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH] cxgb4: do conversion after string check
Message-ID: <ZCXobRYAPfNkSOK5@corigine.com>
References: <20230330154703.36958-1-den-plotnikov@yandex-team.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330154703.36958-1-den-plotnikov@yandex-team.ru>
X-ClientProxiedBy: AS4PR10CA0017.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5574:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ae928a9-b33f-44a9-12e2-08db31584540
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cWcTKLEITrPBBfx5MrpXMydFy5klozYOCpLxAqWqAwMKOxY4AFzvv2vlxB+GkhI7BM2d8yGO+ZcMugTF+X4Ea+RL+FLAnIZ5HNn8OFIvXWTtGZBT8DbbeFQ/aKB99rouc8Tv9BtOLVyYP5iTnmgpyK/u0SW54t6bFQNDUyc20R8w0Oilqg+DyOf+uXUQ2fTYYwmVLFYAGArxJ4VNj+Nl0KoNAsli6HlrNn3flG9XAA/z4TPRB7x5sq4LTUh+UYzrEFTehDTAzUImKFtAhPxIem2++F/4Qz57Ca/oT3QcD1owCho2S1aX4lbao1HwBu8F0dWZFzWOT4DvPcxYaFFKNxjAXQxbdfIP1YoHIKtrcavXXn7yQH2SOyhcE3qBEZyjqONT2yGWnODckWJ7jeJeptk1xuk4OhkEtNbP3HM+JDxzglbklOr/bX+cMGPCcqIr2ZtRrtVwIM8v1fqR84NomWzdHb4abT2RyLULJCIVpqoM+HZB7Xy0WOYewh5bbntzFxOnsYCkLnBv1c40S15bMIvhDxKK0Cnf8caPCTA0f7zs3Cypb+ULfZs3sjYi5OnI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(136003)(346002)(376002)(366004)(396003)(451199021)(86362001)(36756003)(2906002)(478600001)(6506007)(6666004)(83380400001)(38100700002)(2616005)(6512007)(6486002)(66946007)(66556008)(66476007)(5660300002)(4326008)(316002)(8936002)(44832011)(186003)(6916009)(41300700001)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WDEtLVe9GlqoGiS3INMox6V27empaesCmDRa/iZvE7y3OgDvL80jt2Vn/pDk?=
 =?us-ascii?Q?LF6Wnzze52LyjwI96ZwYDQC3rn+LYxOh4BN82RJKsylHMKe0HH3caSz8TO1t?=
 =?us-ascii?Q?EYmL9OgSh8Z9xhx9v1UcFasU7HvnnfFko+cQYHlGdOE7QB/Nz6SXOodzcDkz?=
 =?us-ascii?Q?T7SeOw6+RxTZkPjMAUe2jJNJU7zttsIhFblgZW0rMnSE9u3qXAGb8P8SIztL?=
 =?us-ascii?Q?ghYOrSG95g5LCVj5/AZwFY27SxsfWCVZ/pUQUtp/JVfUEIuyH2DPgwVjvEpg?=
 =?us-ascii?Q?d8dsKu71jx01dWB6aEZELpkE9wlt8GWsK7Wmr5bOIUEMHyC7ge/DSueXzwrE?=
 =?us-ascii?Q?IWeqnx1mkFQYAcK/8Bwoj84oRzHtxRd1qXPbbmZpAowG/6hW9TEIcXBrfKcG?=
 =?us-ascii?Q?Wm+0YisAA3GVQS6GM9TxQnshScpRCEhg+D43xd6V9Qf7KPLO3I5zR0Ys/vmB?=
 =?us-ascii?Q?H9TS9NJT6/ksTslSWLhyBZiTSRkQfyboDdjuKW0taH1nAwNVOcTpvyUi3Ecq?=
 =?us-ascii?Q?2rTB3umoXmIxhMOkBA5Rw9obDJbsjN5V9JXhga7p/HUUXpj2BXMBAGLQV9Lm?=
 =?us-ascii?Q?B5KSW/HT1zNhhZ0oq3kjlz212V1pqRuokdciOx7ifCIkp6etnxW5H38VUVar?=
 =?us-ascii?Q?Mez3Tawh9moxPqiGfUsOLnx6VDyB+KFdRrLsB0tpdFs2C0pF6JnRkkxqAkir?=
 =?us-ascii?Q?u/Uo3smEhv4QptdZOQjC7pHbtj4ITuqZH9yiIPQVgvkMxO4cqn6U3fnB+4F4?=
 =?us-ascii?Q?yyxF7Zq3kycYoNI9PNXoP1Yil33aeZJrmhlz3tXg16ajJBWaYobJl2MlVdnJ?=
 =?us-ascii?Q?hJAl5Z9aj9WLVhk7ExPj2G+KaAjk6ryuQQJa8XY+/fhb7VqVHMa3M+W6OnSJ?=
 =?us-ascii?Q?EEPMBdss4tLS+tmT8diYdg7s8TzE85ZPmqKIED75ImMzyaE5Zz1oL0uKOpym?=
 =?us-ascii?Q?bnWNB+qwD01Deu2MhGsGvamv9sYClZTVBz/FcASEv4qg2A8Npcx2d6lZOddK?=
 =?us-ascii?Q?XiCT2QpKCpWdMVp3j7V78eBY1HHVNA08r/Xx282LtVWfFxYtthtq6QNQpFZy?=
 =?us-ascii?Q?jljvp0vhsS3mB58oNJyT+rkHz6bdWNIqL18Q+uKmqHcu+bSEm6qS2BNjf5U3?=
 =?us-ascii?Q?0Y3rNdNoeHb7LED9obDeYPXSMTKxp836Yz2HaK2OhqwpcfVbgaZyk8mojASP?=
 =?us-ascii?Q?R+DTbICTabhk2X4M4zXctL0gBMHBkOUbY39/xAVsWErdgwluFd94WbOs1bSH?=
 =?us-ascii?Q?p2glGaEzGXBBcsSKNXPfDtmmgeExDKUIBbU7sDe5g5w2AloaNQiG3b6nbm/C?=
 =?us-ascii?Q?uYZCrkJv3czlc45iH0W7TM3sA2/d8PhPM2qjP46YyvHrw0E/zZWPIvN5ahBP?=
 =?us-ascii?Q?K2+FN6E3dWqgP8DJGil0YlgTfnz9iA/9YuCyinPo62G9NyqpNa5LtipW9DdK?=
 =?us-ascii?Q?Y8/PIjAHHNzgtVRR18rHASOZK4uxiTbGnf2id/vZ1FD5VGyUVF05Ub2QVTBS?=
 =?us-ascii?Q?C8SvJc/s+xHrYWzVtFc0TshKW1pcYtPPqHlbi79/bnccG05GzkBR2fRmEkOs?=
 =?us-ascii?Q?RvlyeqDXCYZZzOa0p9loTrsHUQArJkdq01WRfuZqSO4z3xaV6Iwv012zS3t4?=
 =?us-ascii?Q?3dYAHaDZcsW13JlHGtRbLSzmtDHISFlXkEFWE3mZd5A0XCBKzPW0CeLgmkCy?=
 =?us-ascii?Q?Lw2dUQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ae928a9-b33f-44a9-12e2-08db31584540
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 19:52:19.4015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HUhTt3WxbwherpnTwfL0TT1BCpsWh7QjiW0z9YvytmDq4S7eH6v0rKAHO/7Kc9Wz9x7zVonU4oMhY/WQKWXgM/xbXf7Tj4pV9OwYIlMjLY8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5574
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 06:47:03PM +0300, Denis Plotnikov wrote:
> Static code analyzer complains to uncheck return value.
> Indeed, the return value of kstrtouint "must be checked"
> as the comment says.
> Moreover, it looks like the string conversion  should be
> after "end of string" or "new line" check.
> This patch fixes these issues.
> 
> Signed-off-by: Denis Plotnikov <den-plotnikov@yandex-team.ru>
> ---
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
> index 14e0d989c3ba5..a8d3616630cc6 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
> @@ -1576,9 +1576,11 @@ inval:				count = -EINVAL;
>  		}
>  		if (*word == '@') {
>  			end = (char *)word + 1;
> -			ret = kstrtouint(end, 10, &j);
>  			if (*end && *end != '\n')
>  				goto inval;

I feel that I must be missing something very obvious.

My reading is that the code only gets to this line
if *end is either '\0' or '\n'. Which would not be the case
if end points to the string representation of number.
So I am confused about this code, both with and without your patch.

Perhaps the check is assuming that end is pointing
to the end of the string representation of the number.
Something like the endptr after a call to libc's strtoul(3).
But by my reading it is pointing to the beginning.

> +			ret = kstrtouint(end, 10, &j);
> +			if (ret)
> +				goto inval;
>  			if (j & 7)          /* doesn't start at multiple of 8 */
>  				goto inval;
>  			j /= 8;
> -- 
> 2.25.1
> 
