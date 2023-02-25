Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3DBA6A2AB0
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 17:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjBYQUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 11:20:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjBYQUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 11:20:48 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2094.outbound.protection.outlook.com [40.107.223.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72BB15CB9
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 08:20:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bFW1cn4vEKIckqMdrQulmVws3hq3RZFhoHSIlQtDmSZKerKkQJy3zfwPISmx+DRWjPhknxmF8uSpwpARGc5fGqnXjkD5sG8GofXHjZp7iZfdRE+I6v0qW+ARy62FNZ+SiSQS+4y8c8eVgJBzBUbRfZODT8JZhu+Fh98SE3Vx+9AbzXlM56gN1HJacE4X0B8ySAiYbQp3YgVBO88Zb2hpfGh2D6ODWl4+iUqWt9+HSBc3Ceyg/SIf6eISOBb38gK+i4OQA4qLkyP6evvbjIHKn4b4tVXEoUTyqfwt2UqaGGMh9ljTHHt6ZhpVqA5cntAdwgSh+RcDrfyrhG8ijwhyzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M0lhB9THIp1IdbSb1zyWwk9CpA3uCCWteqjt9bGlIo4=;
 b=CYRE/3leLw5zhV5xdN0VmAEgMLxnEFWR4eEoY5JApUEto2ZtIiQ0HuJcy8481G858usgSCRA/488VXp4hd5QH39gQf+qyQjYyXvSIUnw29CYi2JPU88vH0jC1aSBVvoqEFxjBM82LAjCxk1xL2srcLbQdhVFvAtyn/1CB0dVG8r1cQN0FQU6+4eB6MlfCEddDyNaqbraN2HVs8t9/WCsIwes6xvRKTvT9bapedXyLYLpIzjyQ18SEui2DmV4QafUxseY2mD4bpOitaCRObXMXY3QA/p97FGRZlyvTrm3pxtN8AR3eyo9vcBAYh04QzL9HH0DFyrVcGyIIZnlMc0B9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M0lhB9THIp1IdbSb1zyWwk9CpA3uCCWteqjt9bGlIo4=;
 b=Z5j1803eGlejRbgskX+VaL0JWRoz07XducQHGO3EyjOtxyP3jSoNMb/cTcrElXIb3Q2YTKKq+R5BGp0dPN+PJ8Zoyanu77IMVIt2+JLCCQqryYmMp5VIk4EWytdLEEo0azznb3d0XqTlxySHpwG5UIS9vFU3z+cUrrVKfJNVt0w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3617.namprd13.prod.outlook.com (2603:10b6:a03:21b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Sat, 25 Feb
 2023 16:20:43 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6134.025; Sat, 25 Feb 2023
 16:20:43 +0000
Date:   Sat, 25 Feb 2023 17:20:36 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, amir@vadai.me,
        dcaratti@redhat.com, willemb@google.com,
        simon.horman@netronome.com, john.hurley@netronome.com,
        yotamg@mellanox.com, ozsh@nvidia.com, paulb@nvidia.com
Subject: Re: [PATCH net 3/3] net/sched: act_sample: fix action bind logic
Message-ID: <Y/o1VJLEwPJWsxZv@corigine.com>
References: <20230224150058.149505-1-pctammela@mojatatu.com>
 <20230224150058.149505-4-pctammela@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224150058.149505-4-pctammela@mojatatu.com>
X-ClientProxiedBy: AM0PR06CA0106.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::47) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3617:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d9edb07-c592-474b-32a8-08db174c3e40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tG+SFlZz2C2KnNDPGS0kUDTT8jDnfy9qCWtE3bAR3VdP8UnBoS0ltvQUisbo5Qg6eFpfERx2AJhcMwRceNLca758yt3LUxjkU8m0SyxDywvGvin8f3B1RkWNkAfAHFwc2MQJU8AvbXj/XGW9vnas7VLnvd2MY8XE+j5d7Zx3rCvCW8wZBTfFT//D6xGwVlOk6UVoVvITiDakV+RfxS7ZWWGWNkmeRJmRqpx40onmkuD4R5PwBKdwATcdyTeINx167ddvWIUPxE/8kLtTSLdjTGyBGurc8HvPQDRV42zNRmFGfigACynEWlQ96dTNy9fggA1z75qV+sIiwCSvuKhtUDqSBmsCcEc9dLoDbRPfh6kPDk875sj5xRqYmmzZPKSzQRpIWMMDQt9Sx7ltB+0WYyGCDsg5FzjC3miAfqlZpDsniK2RQIOkwEdFUYz0iJgk2qRVIrA79t2Zf9GTlHtEg2A+MpXz9qweDk8+tsPU/LedatNUzzKJKIeLi2ZAJbW8ol1V1paX9P30ms76LmhdZTqziRUah0mhT8FAA5aX6lyaAIlaC8UY/Zmo4IVGUQFnzN+fWKzRevS/6jwMBcSDcHjdiomQNbxQsSOvvmMWvSmV4ovSGXjjG2E25djudB69bkLy7MkmY+ju4vBPYBW+xg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(346002)(376002)(39830400003)(396003)(451199018)(36756003)(316002)(83380400001)(2616005)(6486002)(478600001)(6512007)(4326008)(186003)(41300700001)(5660300002)(8936002)(86362001)(44832011)(2906002)(7416002)(6506007)(66556008)(66476007)(6666004)(6916009)(66946007)(8676002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cPIsGlUg0f4EyD96AskRhnNtXaNxESWMznSXGKptbaUpLT1CLVHvVNOAAjil?=
 =?us-ascii?Q?1yrf3OctlD5qMfQ2AVfXEFfVYg+lhyRZ48V+zINgOdaydga02dRSzrqdm1KM?=
 =?us-ascii?Q?BfQ6Z6y7937Xhqa7IbFr1m1MA+6RqzLQmq9gdndGhSlIB1HU1VJ57uFWRXQ1?=
 =?us-ascii?Q?TLR1i5Nao7nfaOe7sfRKUlP1b2WPGL2tBHdmUG+0wx0HCD1cqdDzGoU7kwqq?=
 =?us-ascii?Q?tl/E7ycmtymjtXIsQFHW8JRIljQ4gbSTaCN/QQiy4aGd3ZN/e0QRY8oGljxF?=
 =?us-ascii?Q?g6S+LcfHJ+Tufw688SYl8CM2V7ZMALItIhiuTmOp8TKQii+ugWmhIC2TEP4/?=
 =?us-ascii?Q?VTkTWEKQUVhiXCrnnX1RselotCA/o9tZ275N25iuMtOtgKZTw9R6/H1n48zw?=
 =?us-ascii?Q?LFI7i6H2CPYkeKsf+S1SLWIR2a33Z2lUlR9PJZagFppxucHucVrEL2OUytkc?=
 =?us-ascii?Q?Tk3LAxJbQumT6q0jda8bV0ttzvI/cbhH+3t8AueL4Bxhzr5skLwHHyt/QvL8?=
 =?us-ascii?Q?0LjMwUleB55k+31Vekf8H82kGA0u2+y2vZIGu3jmciB8Xz9j6eswTy2uGs8R?=
 =?us-ascii?Q?oAR8jnxNRMYwTbiDFcmzXt6m1fOsRHqDmYOMpK/VhaRhLkVvMl19S/mGKaAc?=
 =?us-ascii?Q?r+fr+9ypbS+L4L2sEzwau1bih6dUA4wcMc9BaJmhl1XwMGfvDYlkFX5MzUZr?=
 =?us-ascii?Q?KBnYXg8wrNpkezJoZaDHt22PhC6u92waP5PeIAb/jC9aIvmqYHi6HLSlpknz?=
 =?us-ascii?Q?GskBzf/ILiVNwCiQcFnbXcNF8bOlQ+bqGr3t8gLbGsPrumvRwIoERwijx0Q7?=
 =?us-ascii?Q?iNKdVEdlMVbKNiZwWvOng6QSt9ksaiz86Khb56YHRu5v53xSGax8mSOhjyif?=
 =?us-ascii?Q?0FfdniE0t+bc1ZDbHCt+m3/XZZXLpGoafTTjfyyx3bOLRI0UKQCNKAwa3/je?=
 =?us-ascii?Q?08BuVBkUpGxwjsO31Vc9eDAsGc1qC+X+BS50ZO3kSu2AXy88vLzuWdUHrcQn?=
 =?us-ascii?Q?+o3srpr9HLFyc0zNVGxzTXzAo0O3PlbZanjb7YqLpVbY/K5WUi3DqvD4IMyd?=
 =?us-ascii?Q?L7VYrKhczZPZzSKSJkqp2hWAL2qGCOUvQE3joUbEvHMHwkTLeyq0nQOFWwke?=
 =?us-ascii?Q?M8omdnclBfYvQprZ2BTW/FnPmOT2F0YqTKsS+FsRwsSdU/3qy4xxPSk+8BFO?=
 =?us-ascii?Q?hibDxQTjDbSSL252VBbZQPYbc4FKLk58mBqRcsh27ZGR6sp+1+IXAFN7gZUR?=
 =?us-ascii?Q?CVyTEQxCEvH5t11QpeKQIAoFSVq7rgcuni3asPh1ycJ5fFS/bwe7IAYvb1wD?=
 =?us-ascii?Q?7eJGKXtAmRMtmECIYD3gylzbJybykM+49+VaxqS5otIHQ3H5gOkw39QE5eib?=
 =?us-ascii?Q?Q+h7E/5dyZkONdlRF8g2TxCa673JM5Rp6qyYIj/bwKIAW+MnfK+h7ouxwsPO?=
 =?us-ascii?Q?+RMTVBzsc+1nZaHUN2HRT8FAzXi91qbX/iLOb2XuUL2pyorvOfL6dZP10LjR?=
 =?us-ascii?Q?iHLuTcCmuvaMMygcb93VH6JpxQRNrNfl4Y6gTTytstOu2usmesT8s5tov6gf?=
 =?us-ascii?Q?mrGcImxMbb98BLfWFp7wII4p5uC/kKXCGFcSoiZrbd/K5rBjMN7t9h3zZ+YY?=
 =?us-ascii?Q?fZ5cHIFthel7WAoG/j+MFv+ScTljm4IRM/NxueriYTZFbEgu+/k4la7NzAY6?=
 =?us-ascii?Q?gHMHLg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d9edb07-c592-474b-32a8-08db174c3e40
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2023 16:20:43.5541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JLdVOBenY0bCtWGar2g7U/hW7QgfXLPxyhNnVBLTfWK1Fvo7lPZpI0HZdkJY0RzTv75vXu79e4EoqdzqWRXDx+P9u4Iy7j7m/NkBRrheNyY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3617
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 12:00:58PM -0300, Pedro Tammela wrote:
> The TC architecture allows filters and actions to be created independently.
> In filters the user can reference action objects using:
> tc action add action sample ... index 1
> tc filter add ... action pedit index 1
> 
> In the current code for act_sample this is broken as it checks netlink
> attributes for create/update before actually checking if we are binding to an
> existing action.
> 
> tdc results:
> 1..29
> ok 1 9784 - Add valid sample action with mandatory arguments
> ok 2 5c91 - Add valid sample action with mandatory arguments and continue control action
> ok 3 334b - Add valid sample action with mandatory arguments and drop control action
> ok 4 da69 - Add valid sample action with mandatory arguments and reclassify control action
> ok 5 13ce - Add valid sample action with mandatory arguments and pipe control action
> ok 6 1886 - Add valid sample action with mandatory arguments and jump control action
> ok 7 7571 - Add sample action with invalid rate
> ok 8 b6d4 - Add sample action with mandatory arguments and invalid control action
> ok 9 a874 - Add invalid sample action without mandatory arguments
> ok 10 ac01 - Add invalid sample action without mandatory argument rate
> ok 11 4203 - Add invalid sample action without mandatory argument group
> ok 12 14a7 - Add invalid sample action without mandatory argument group
> ok 13 8f2e - Add valid sample action with trunc argument
> ok 14 45f8 - Add sample action with maximum rate argument
> ok 15 ad0c - Add sample action with maximum trunc argument
> ok 16 83a9 - Add sample action with maximum group argument
> ok 17 ed27 - Add sample action with invalid rate argument
> ok 18 2eae - Add sample action with invalid group argument
> ok 19 6ff3 - Add sample action with invalid trunc size
> ok 20 2b2a - Add sample action with invalid index
> ok 21 dee2 - Add sample action with maximum allowed index
> ok 22 560e - Add sample action with cookie
> ok 23 704a - Replace existing sample action with new rate argument
> ok 24 60eb - Replace existing sample action with new group argument
> ok 25 2cce - Replace existing sample action with new trunc argument
> ok 26 59d1 - Replace existing sample action with new control argument
> ok 27 0a6e - Replace sample action with invalid goto chain control
> ok 28 3872 - Delete sample action with valid index
> ok 29 a394 - Delete sample action with invalid index
> 
> Fixes: 5c5670fae430 ("net/sched: Introduce sample tc action")
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

I have a minor comment below.
But in the context of this series, this patch looks good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  net/sched/act_sample.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
> index f7416b5598e0..4c670e7568dc 100644
> --- a/net/sched/act_sample.c
> +++ b/net/sched/act_sample.c
> @@ -55,8 +55,8 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
>  					  sample_policy, NULL);
>  	if (ret < 0)
>  		return ret;
> -	if (!tb[TCA_SAMPLE_PARMS] || !tb[TCA_SAMPLE_RATE] ||
> -	    !tb[TCA_SAMPLE_PSAMPLE_GROUP])
> +
> +	if (!tb[TCA_SAMPLE_PARMS])
>  		return -EINVAL;
>  
>  	parm = nla_data(tb[TCA_SAMPLE_PARMS]);
> @@ -80,6 +80,13 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
>  		tcf_idr_release(*a, bind);
>  		return -EEXIST;

nit: not for this patch, but I think it would be more consistent
     to use goto release_idr here.

>  	}
> +
> +	if (!tb[TCA_SAMPLE_RATE] || !tb[TCA_SAMPLE_PSAMPLE_GROUP]) {
> +		NL_SET_ERR_MSG(extack, "sample rate and group are required");
> +		err = -EINVAL;
> +		goto release_idr;
> +	}
> +
>  	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
>  	if (err < 0)
>  		goto release_idr;
> -- 
> 2.34.1
> 
