Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E387D69063E
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 12:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjBILN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 06:13:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbjBILNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 06:13:50 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2099.outbound.protection.outlook.com [40.107.237.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB134FADD;
        Thu,  9 Feb 2023 03:13:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YfPaCgRmRdW2hLPthgyEI3m9p07MZvMNIFPfQoUfbWnFBGsGW/qz1STvWjwqh+OFaY/YauMB87EqClA6IQKDpc+f9+SzWAEjgXs1zYZM02dBvtmtYq9nKyE+WVP7we8tYVJbizc/K6MQE17QRus2avD0WPxQK0TYw/87ggAGr8F5Yd3hRzLLuJgSqCy0AIaOrDxPFoLjnvXtAMJFOXEMLfB16N4nxBCUeQ6q6Gms+azjUXm4Pt15NrlIgs8wJF+/8P3FVQXfk2/nyQaghqDUM1OaBcCm0/KiTVpZGO62kbod0jXtAhf+OKxguAGuxVSDVhW4wB3p4KldlcVkorBssw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GCXgRACl+QNfsTsOTEbSsRt3e8z18+LLuRsmHUyl6Eo=;
 b=XgWwOvk45s4NTW65PiAzlNB6LIfoDLw2B/saCM6h4zvmDhE9z4Uh2Aa3gixMPtu6+8qGmIpH0uShyTresxlazd89GoEWsvFo4/5GXOC+btxzSUteGYl9PlYKmEvEDJ5Mti7yk1cVJ1EG1uQnOTfs6pF3A5fkGJLC3RqeqOMif/qpTebRqgxtPJ3C9qJQZpLoT90SzPkvv8b04Z76YkmwLwFesMkhW0LYDv8+9Gn0pzN+yWonRtMc0hPwySFRR0m1Sc5aHEwmn6ZzRL46krQRAXxVogqrR0hjBMiQ4NvcVJXu8o0PDJ+zBSn7Dt7SliRq7NP3+i618K4s9L1L4AF1Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GCXgRACl+QNfsTsOTEbSsRt3e8z18+LLuRsmHUyl6Eo=;
 b=M2TDakpQsCQ7YIAwL5Lhb3gE5v7CI+kg7K2KPEREuZ+yfRyKGYUKLwR2fac8pxRsYULBLD4pAgtLGPlWjVUQWJb/DgGhLiTsMw4KUz3ETl/Sk4ixgJRMHk+41ZGt54nSPVgua1/uhKcZbPY3Lcjqb2Zdo7p8/EfpIR83pZAjE94=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5455.namprd13.prod.outlook.com (2603:10b6:510:139::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Thu, 9 Feb
 2023 11:13:32 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 11:13:32 +0000
Date:   Thu, 9 Feb 2023 12:13:26 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yuval Mintz <Yuval.Mintz@qlogic.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v0] qed/qed_dev: guard against a possible division by zero
Message-ID: <Y+TVVuLgF+V7iTO1@corigine.com>
References: <20230209103813.2500486-1-d-tatianin@yandex-team.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209103813.2500486-1-d-tatianin@yandex-team.ru>
X-ClientProxiedBy: AM4PR0501CA0046.eurprd05.prod.outlook.com
 (2603:10a6:200:68::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5455:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f8779ba-2fc2-45a3-36f3-08db0a8eadc7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eqwf6Qisf4J5dWcqRgx+dPWKfw6LG2FXDVHaLTVzEwncWx81XQqAz1LWAA3ZnNplMMV3oHybVtQz+Eev9T61ddEIcZOqjD/xlIHXFcVZ70DQ6j+vF5Gx4kog4NJu/2hihC/HQHqKDpJxkYF4wmVWK/KtuYkOqdHwJiGlMAK88gMu6klRdbJvFlG3pA7tI5T/SayDfBighKJvXJpqm2kcWlLE7zZxd4UvWVqBuXK0rYws2KO8iYSUu8cC6pnDP1nNnBekLcSwz/eAaGjnTJ2UnQkJwUnkT7eoRLML8/koMhug8W4ox5P+2S3vp9CA7DdKVXEs++O5d1gXXEhPAKH0ovIzE6TTMcXoG0NWva02zG7Pgl9plDDRru9/sz3Z3dhu+5J2ZOY4sXTMV0ZrS19wrV+9CnSBedjx1qjtAT4Ebieajoo2+sAxXNDa/X3CUtCnHlfyhRK7wpmSOvbglykP7UzT/+Ta6EGNm/DM3kDnxZFUQe89Kz6UrGCdeVQSRYm2HihXgiXpBD2UXhw/fgyyZXCwvrNb7/6Uepb5ATp6JSlqdznUvNvYQivYSsJwUimwyPoP6y1x9/Ii8H6u8lXPx/VZIXLbYbnXaMMQrIMpaaAxT3ftExhF2gY5nejhZXLzISlSI5+Xc0l8bl2OJfPJZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(396003)(346002)(376002)(136003)(366004)(451199018)(86362001)(36756003)(41300700001)(6512007)(6666004)(6506007)(6486002)(2616005)(66476007)(4326008)(54906003)(66556008)(8676002)(66946007)(6916009)(478600001)(5660300002)(38100700002)(7416002)(316002)(44832011)(2906002)(83380400001)(186003)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PwE0jpIQ4OH0eaxrrA6BV1runafqmqwP0aTQXGE4pRY4AT6C/i80uYndmHjG?=
 =?us-ascii?Q?V9aX6FOiseWsY6mCtezg+lmhWyNknJsRZ+pSNEIoe44Fj+09k/S4HBxlpntT?=
 =?us-ascii?Q?M+HU5gb5vkAJW4E0VcBLzysiMZ3B5Y22xrFiRterQEoKytBhIP9YbWyhtlNN?=
 =?us-ascii?Q?8OK//AFBftwSWvcpe4efEJFc44hhdYOHGadl8uNSmUsThR4jp1ekKuAcAUZr?=
 =?us-ascii?Q?G06AQQDz/CaGNkkDNFGM+eXys/FWUizShFheS981kwaEpC8E1mShhV9PsjxE?=
 =?us-ascii?Q?sfOHkJvS2v9i04v82rERpzjmU5813r5x+OwvJm0DGKIouSwvIW9LZ+BKE92k?=
 =?us-ascii?Q?CJfqk3wRT+SA9F2AzR5j8e+L8aRgrSOmSPPDS8OvCxjm9pDGtGlG//CeWObG?=
 =?us-ascii?Q?Y8A1BHlYDMcahZNjaA2mpWr+K50Q+pIAHUxJKyGEXTKcdw5d674+axY3YskX?=
 =?us-ascii?Q?L+7HMXyENssmacUm0m05H3y0BcO2bdvH5MJ4BjK6g2TsPXNtm9D6H7hfu3P0?=
 =?us-ascii?Q?CoM7fU1oHFynh/GgUDbcHucWyBRs5rlt0VwtuXNN+UeTOPQ4+oCr7F1VfBy7?=
 =?us-ascii?Q?L4W47npTyViNKsO11FL005GvxHwDBxyJpXMZ+8kRJerie11fYozoU2sXyOq6?=
 =?us-ascii?Q?yk423pL+1ZrsMG0M3bWvU1K2mLxGIKxSAnEgqBa4HLbqDeITaM22DAXr136C?=
 =?us-ascii?Q?uC+Al5hsbYX5dgsx6qCasLUogdiOGxfPIi7xYcdHMbWCO25Dgj+XtdDBcxK/?=
 =?us-ascii?Q?fIX+a8VrJRAXciu+toWoJ5zElnKS8BHKmUNIr9WbmwghygJNOUpW0QW94h4f?=
 =?us-ascii?Q?TYAzSi39Mslz5sfGrlJaqiQjxu9MCgW6N0csTktY91Y0tS9mxJnMgfk35nmv?=
 =?us-ascii?Q?4tZ1NVB36U6Ooi/l0dlAQjJCwnAr3LSjTGh5vX4ekekv4pxm3zLkDkSqKH1f?=
 =?us-ascii?Q?YdpYPb0EMc2RJx7wGoSfG/uNyQ8DUAk1ZrQSZGnlOG8xrw0kcYd3WGL87NnZ?=
 =?us-ascii?Q?fihOKH0Ej1bGiZmIWkBR/D4Te/0NUn/eqAnwuC0QlDUJsazppgfhmxmIkj8+?=
 =?us-ascii?Q?H4ZcixICeC1dAza/gC5c7E0f6VXNDL8QWjw7e4+iO9gImWYPpIJlwgziuUDT?=
 =?us-ascii?Q?dLYUX8ZU2mO7bT+bKrCYYy/QuWfUfWG7GhokhFKG6fQHmU2HOnYpXVSmkNxy?=
 =?us-ascii?Q?H4uqn1cylT0f0PDy961q8daobVCukVQGKxkgpGSX/1zHtODoXEFZJgRSO6Fz?=
 =?us-ascii?Q?pambh4UhprWfZz8Sfjcmd1zojzlCkHcssfTXJkSBJ4wvYSFw8rUwWotlN0qu?=
 =?us-ascii?Q?KBuIjOPj1Tq45D4T8zgDDUR3L5XoW2axVmg3uC81wfrIenOecg9jhxQNM4Yj?=
 =?us-ascii?Q?8K1QNNCh6WwvK0BwRo5XX16Q8F2/v+cvwiU9lWUup+VdBrzw/BanAK/FmQrp?=
 =?us-ascii?Q?PxylnSGmUAYY6KbDeZhJ8ISWW+lTflQiBN0PsiPgd1SLLjLdX2jZ+KWyVXCw?=
 =?us-ascii?Q?Yzs4qo+lxf4gISFR+oXjywI58DWaAE2EwUoFbyNhCUFMFleJunGP8i4foVbj?=
 =?us-ascii?Q?1PaUXzXWtJX3tGBxbF9E6jHdllDFx8Cx9Tbaz05PZBmjOFvr2B6mDKsIwfek?=
 =?us-ascii?Q?EW21pWH9+fLlnKw1o8bmdQp+6+pTA/jDtRNj8H/rEI5jDw/duFwh+sUmlgfK?=
 =?us-ascii?Q?A9MSiA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f8779ba-2fc2-45a3-36f3-08db0a8eadc7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 11:13:32.1924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MG0uD3u7zoLh18PiYBTCm8QvmL/IHIz9p6y86bErFDZpox/gBc616DV0Vch83qBsUqJcjHjczQ2DA7lxRrPQmjuVMiQ95UkbnL6bKc657Fo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5455
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 09, 2023 at 01:38:13PM +0300, Daniil Tatianin wrote:
> Previously we would divide total_left_rate by zero if num_vports
> happened to be 1 because non_requested_count is calculated as
> num_vports - req_count. Guard against this by explicitly checking for
> zero when doing the division.
> 
> Found by Linux Verification Center (linuxtesting.org) with the SVACE
> static analysis tool.
> 
> Fixes: bcd197c81f63 ("qed: Add vport WFQ configuration APIs")
> Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
> index d61cd32ec3b6..90927f68c459 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
> @@ -5123,7 +5123,7 @@ static int qed_init_wfq_param(struct qed_hwfn *p_hwfn,
>  
>  	total_left_rate	= min_pf_rate - total_req_min_rate;
>  
> -	left_rate_per_vp = total_left_rate / non_requested_count;
> +	left_rate_per_vp = total_left_rate / (non_requested_count ?: 1);

I don't know if num_vports can be 1.
But if it is then I agree that the above will be a divide by zero.

I do, however, wonder if it would be better to either:

* Treat this case as invalid and return with -EINVAL if num_vports is 1; or

* Skip both the calculation immediately above and the code
  in the if condition below, which is the only place where
  the calculated value is used, if num_vports is 1.
  I don't think the if clause makes much sense if num_vports is one.

>  	if (left_rate_per_vp <  min_pf_rate / QED_WFQ_UNIT) {
>  		DP_VERBOSE(p_hwfn, NETIF_MSG_LINK,
>  			   "Non WFQ configured vports rate [%d Mbps] is less than one percent of configured PF min rate[%d Mbps]\n",
> -- 
> 2.25.1
> 
