Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B61B96A2AA1
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 17:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjBYQId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 11:08:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBYQIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 11:08:32 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A393DE385;
        Sat, 25 Feb 2023 08:08:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QhE64F1JzaQzkBK+28as6frECFA7zQ1lX92irM5RDIytTMEpOVRXyZ3NE0EtA32L7ZxZK1MkLSIFbi/OXDDu4KnaqtZEVM97zayUvT8ngMa14zPxajdk+HGopFCNbigX7JWRDFXCCY09DD3Mc9HhlRCBpLTA1w6mmfjfeh2xyuLDjHs+VcwbqgkyKJee2yFCoXXFoDtjjP/jkOU7/hnSX2O3kjxXc1Eac/yTdpWrJyiiEUrBPvgNLP82vlFaBRQnXSwYWkuLgZCbw51Px/s/zeMiKTrEarf3WeRo7FDq67s1jQ/DdSequT/1+DAxcFA/0uSozdKupi2EqP/C0K/4dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8q3rZdxZvht1KtN52p03kuzKrzqEkpB1c+4yek1UNE=;
 b=LJQPFp4qXbwLn3g/doOD9l93iRn07M+XvMutWv4ZeFfd0R1Hpfnmn/qrZtyCM9Ryki5SKfrz+xJmCzr6UKNvkwzT/7OLLViakrO4gSIYjcMXhbHumuh6j7GJ7I7YN2X62v28QiJcWpCl0/OmZ+FYhA6iNCxGUhEq+0tRKZLTu3NaaAO8c8j/7VLEnfwBSu16gmoAUW9cHi5qIv7nCSQ5huIVVJ4lLj4/t/L2J15guWS79pBc3b08cvmIJkhBuc+Mt2g0ZxJf45pcl6DfD5JEp24ubEcQbXpK91To1kjH/bJOaNPMnJZha51asK5xbf8PZoDSLn36pz+AdbZntYLBRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8q3rZdxZvht1KtN52p03kuzKrzqEkpB1c+4yek1UNE=;
 b=V4PnPzikbVsbhbFPT2nJlJxNEDtQNYRuBtqYtxAwKmpZb/DxpB6/tMtvDq/sJKHE/kVslBwlqhD3UeGpIxLiW0n1KBib9KxRI41Mz4uk7FbNZnVtRolbsxOrmMdh3DAN2f/h6dMx7at+AlCZNOAzZATogpSxanlwpNBRnZa+rks=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5921.namprd13.prod.outlook.com (2603:10b6:510:164::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Sat, 25 Feb
 2023 16:08:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6134.025; Sat, 25 Feb 2023
 16:08:26 +0000
Date:   Sat, 25 Feb 2023 17:08:17 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, paulb@nvidia.com, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net/sched: cls_api: Move call to
 tcf_exts_miss_cookie_base_destroy()
Message-ID: <Y/oycX7fMP8yJAdd@corigine.com>
References: <20230224-cls_api-wunused-function-v1-1-12c77986dc2d@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224-cls_api-wunused-function-v1-1-12c77986dc2d@kernel.org>
X-ClientProxiedBy: AM3PR03CA0074.eurprd03.prod.outlook.com
 (2603:10a6:207:5::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5921:EE_
X-MS-Office365-Filtering-Correlation-Id: 841c2975-198f-498b-80e4-08db174a869c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kZ299664d6PP4j5cmqFsjpSxLn343oY0bgaSPEq+xFozJO3eFRvlgrKyNTgi3AlIFT3YGA8KE1/k3rV9L1gylzr49cYmHWOsol9oMRIuOOjiAqx+qKhHzHCqIrmJRUMlI8b1/xV9STL3ej3t5Ok2HW1R62JFMI9xksUw+SZFo+R3HztfxI7qHpS+OVYorcxiuvruoaA9JJBc4euiu8BTI/PNaKPBbh6p7+xUedjPiax+f4gL/Jk1fc1fKEW4onnAvnSkj38GwZHLdIUUKjxB3uZoFP0AV7lJUr8mQ0+mk3D6I0XWB1oVJtbLOAgzjoxX9kn4CrY1/YwNZkTAwT0YUomjcHmfHarO2k9upav6G/A6ykppdT66+ql4P9jT3Hh8B8/3Q7vSMfQc7CvScYFM/p/RdEBTbKCHrrSfXtbEW13QWXLoyf/SL1Bdw4BXN3/VnvZs4GsZXmbgkK7dR48pBw9t0povryzCMEqsJUm5GGWEFJfqx20ZGSyHBGZEJ+tOuuAAgVhI//jLZAeYVS+VbxyTo2Zpnh5FuQBLPrmOGSBPLpNai+MzgGpjEZtI9F+qsp9vv3FXD6szdodK8hjIdFjmdZIX/GSrxMvjl2pMdGmRq/IaF8lXY340l36AEoNgkJY/DlcH7q5qNtnE+ptrCowvcTpF0uZmzbyyLr5EtpRyamyBAcfXu8swZ8JTte8n
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(136003)(346002)(39830400003)(366004)(451199018)(316002)(41300700001)(186003)(44832011)(7416002)(2616005)(8936002)(5660300002)(6486002)(6506007)(6512007)(4326008)(66556008)(66946007)(66476007)(8676002)(6916009)(83380400001)(38100700002)(86362001)(6666004)(478600001)(2906002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s5dO44cIvHekjr1mhndV3EcaYY9w9Dug4el8WgjEGMrJXu//PS8ihpWIKx0E?=
 =?us-ascii?Q?w6VhcYfBIN4Lzg0wKoo6NUl8suc1LvU+NTOcZWpN2ZtkXqAoooWNFI76RX8R?=
 =?us-ascii?Q?6Gbq0fE5fvI0OeMZL3KkqnWZd4kcpJdm/03vyPO0+S5JwF4x8VgAu2TsgtiD?=
 =?us-ascii?Q?vSA+AYqzZbs0et9QPW4Y61Dqbix3nov2KWkJRwx4q24UZf6z5U3dT5gGnZnY?=
 =?us-ascii?Q?X12OqFn1C1VvtRfKj2zQbpPEwQrkyPL1kfmcdLqpXLdvdzuqGfUIpF3WcFd6?=
 =?us-ascii?Q?h6XtmetkGxXTSS3d11JBCbUMpvAI/LNmGXLCTg1dH9Mn/Zz/jmoVW8U4q4/Y?=
 =?us-ascii?Q?Dh6ph6ZI5wCHAWlC6sdIGiWr2xETdAO1AaN98iENhSYSz9ZWOyBbOtw369rA?=
 =?us-ascii?Q?sLcC38Mx1telkvT8KK63nOVubKe1/uu2X5JQh8PSKpXquyY9MqWgzIv2G/uu?=
 =?us-ascii?Q?v80djFV3oY56wxpqF0n9FmZKKbJpjP7wxCtgSG9/PdEp8Wuswlqm556EIJxJ?=
 =?us-ascii?Q?EmDAdRsXw8Gwi2c71P/i17pGY0cC4ym2lX4hbVEIi/TFBFQrnXhXd2qDY5uY?=
 =?us-ascii?Q?+6pZ4qXjMrXnfcTLOBpQzwYQ7MSIWeOgQDhFGxh9f/C9iYyQ077pI7lc8GYF?=
 =?us-ascii?Q?Pwpk4q6qNq7qLY8m+OO1+NtGwvt3IQvBSPKbEpNDCSQLZLEVMRvMoPwWdlpR?=
 =?us-ascii?Q?UstEl3Qw004HKq5wDNoCPLOz5PKepNTZShuLxpnq63DOIgTG8BUd2DiP3rgc?=
 =?us-ascii?Q?pa1+hD6aN+jVCLz9ISk1+de9gcpm0o6+/lAhiIVLA4kLJW61mNw3TtYP2NMu?=
 =?us-ascii?Q?lGjUvIxIYA/obgNLQQx2WvvGHjEWpbnmNgwBtNT/3qgAKj+oJ57yskBGLvw7?=
 =?us-ascii?Q?CNzW6HEbP2sJlgr0UcTsbqAmL4WqKJPQI4LAvE5gsmpRu1xA/Fx2I4YYMhEj?=
 =?us-ascii?Q?fOe1bJwARjp0wnwKRs5etbF14RUTZUDUx89SrCxuOUFtbKPnZPJDw4RdVLRU?=
 =?us-ascii?Q?N3CVVjlIdspFWNH3a7Lf0SPC4VjE4uTMHw8rPnCAF2y30tPJIuqV5Rn2hKYB?=
 =?us-ascii?Q?zE/rBmKy/yaJlfkS2E0GbmaTgpxC2hwHtMlszsUSqtXkyQdoN/Z2DVoEkxiF?=
 =?us-ascii?Q?mRk9jNendb4hK5HuPAlZKmVYwWQKweOJJHGU2kSyJD7BBeblZSk8dL2kR1tr?=
 =?us-ascii?Q?SP9h+HPbkbzFN9KeFybpQNrzXiteulsAOH7Ca5p7rBLKwbiI2XNARr/QpPgH?=
 =?us-ascii?Q?I0owuLZktnfUdnXI0yiq9j1geENs1etD9OvOZCcz3Ou96kLC4dzdK+NVIuMY?=
 =?us-ascii?Q?+3LvBXWd32Ztb5CrD13uMABvUoh2zxfu8tSxNvSFuR2HsOZn7YuthDh1InOu?=
 =?us-ascii?Q?750Q3fiqfbgP007K0joQml43Ovetu0dHZTKwwZGwoJyQT+6iDlOPuU967pCR?=
 =?us-ascii?Q?S9GxtNfNXWhICMp0P79zALl/FFMLZdJit3wkRdeaDrEtsSX0leuWYdOKfHk1?=
 =?us-ascii?Q?0/TXw9SKXHjMd2H8LAQ1mla9CcH6cZSme+6eP/f4aETcIno4DNPoxMd2Y8fu?=
 =?us-ascii?Q?RFhjPR+2vy+pNN5jXDVqx8fHTnjDwQ8ChliQ6ulv8gWLiJiPFmDGoWN6gJm+?=
 =?us-ascii?Q?oHHCiASNbUGte70DP4WSPrLUiN7vP8LqStYPb3KMf39oUwPRvZfsQ1Esw+Dp?=
 =?us-ascii?Q?fcvH8g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 841c2975-198f-498b-80e4-08db174a869c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2023 16:08:25.8354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yF46HdyulOtYPYFtvD2Jfx3CqSeynKJTus+aGfQHt21nBglnY5erjUEowH+cvMG2+aSYP+Xt6OPxLDkqEdThnpVoxuHFJE+tVxpUuDMpWDw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5921
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 11:18:49AM -0700, Nathan Chancellor wrote:
> When CONFIG_NET_CLS_ACT is disabled:
> 
>   ../net/sched/cls_api.c:141:13: warning: 'tcf_exts_miss_cookie_base_destroy' defined but not used [-Wunused-function]
>     141 | static void tcf_exts_miss_cookie_base_destroy(struct tcf_exts *exts)
>         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Due to the way the code is structured, it is possible for a definition
> of tcf_exts_miss_cookie_base_destroy() to be present without actually
> being used. Its single callsite is in an '#ifdef CONFIG_NET_CLS_ACT'
> block but a definition will always be present in the file. The version
> of tcf_exts_miss_cookie_base_destroy() that actually does something
> depends on CONFIG_NET_TC_SKB_EXT, so the stub function is used in both
> CONFIG_NET_CLS_ACT=n and CONFIG_NET_CLS_ACT=y + CONFIG_NET_TC_SKB_EXT=n
> configurations.
> 
> Move the call to tcf_exts_miss_cookie_base_destroy() in
> tcf_exts_destroy() out of the '#ifdef CONFIG_NET_CLS_ACT', so that it
> always appears used to the compiler, while not changing any behavior
> with any of the various configuration combinations.
> 
> Fixes: 80cd22c35c90 ("net/sched: cls_api: Support hardware miss to tc action")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks Nathan,

I think the #ifdefs in this file could do with some work.
But as a fix this looks good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
