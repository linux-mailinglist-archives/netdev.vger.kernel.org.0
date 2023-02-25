Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF4A96A2AAE
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 17:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjBYQRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 11:17:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjBYQRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 11:17:38 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2122.outbound.protection.outlook.com [40.107.223.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A11F1BF2
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 08:17:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ewOoApgZlVKdymcX96TFetVE5+zIgRTaUBsqJ8LeOR/ArxXFNxAw7l7M7m+ifs6UTAzanut9RGNGIzNKcCggUjX8yYg8Nw+/09VHLJjmgiOnY/njbTwpszyrXFnoestS+w303YkUFLNS282zVp6LRiWD5cC8e08BEC9AjLVGVpijV9s7uKODABanJcGBMzbrCI80kLeyPYrk3NwRmHYLm09EKh09stdWY3HuDxBPMv4H31UKYQ7Krk9vWgXWWPwJHoUiykVEJYEvqx9bB+alBvh8dy/5jzGIeR2q2Q6QKRbQx0YMTqWvbpLU//PYP7XxLPMR10bkS7w6+kany211sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sPIMZGdX04UsKb9affqLEjWPPpJxb5l6wpmK4FJiv8Y=;
 b=AOowvVM2je+WRBEBDnkXeeWmtAIFd/+59Wk8mUiEho3nmM95XL1tIjaq4XtR6vBstoc0uFsnS9x8osgHpl0hiB1m0A/0XZpPnI11pWe028DmRikY7FXmH9jPskBjN4sIge7mx5OLVqvhPKk8U5r5jjwVLzhYS5wZjmPt4OZY6aZrh4w74dsvzMMOsRy08FGlKUy1vJ60ArdT+Bf7NPRRjbypXGJzEuNF7BfKAlRuPc/ZgEZ5GEMJW3IQYqKqzbdU1CUEbjvxWhJDa7mq1pDMPF1+A+QPFV3WPdIO3VzMwbTbT0cG7D6hVGbPYswSJwTjPDx5rkcAlZzcjlmXbuKIng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sPIMZGdX04UsKb9affqLEjWPPpJxb5l6wpmK4FJiv8Y=;
 b=Gx1NSCFCBJ1++6W07d38v8LxunvD/9nKGEUoCIPGDKga/rAxOvU2VtpvunQXuSr3ODX2YsVJNMcUZd7x+w954QQ8VjqEU4Jo17kedntCDxKFFV2zrnQhEQ/+UK8E4G13dLelwLZLflgwF8mzPGT+GCdxHRjnMeQo9fdDIHYDxsA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3617.namprd13.prod.outlook.com (2603:10b6:a03:21b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Sat, 25 Feb
 2023 16:17:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6134.025; Sat, 25 Feb 2023
 16:17:34 +0000
Date:   Sat, 25 Feb 2023 17:17:26 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, amir@vadai.me,
        dcaratti@redhat.com, willemb@google.com,
        simon.horman@netronome.com, john.hurley@netronome.com,
        yotamg@mellanox.com, ozsh@nvidia.com, paulb@nvidia.com
Subject: Re: [PATCH net 2/3] net/sched: act_mpls: fix action bind logic
Message-ID: <Y/o0loqC1TLzqQm8@corigine.com>
References: <20230224150058.149505-1-pctammela@mojatatu.com>
 <20230224150058.149505-3-pctammela@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224150058.149505-3-pctammela@mojatatu.com>
X-ClientProxiedBy: AS4P251CA0016.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3617:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ae76da6-2fb4-4144-6317-08db174bcd82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FlsJFk9Qmu+E62Sj0olbN6C/2OWSWsAMlHoi1ZYaS5KgD3ghKr9jqxwzSX1L08XajdFLeySun8KXvv6CrdT8a+/cejRprGM9wLgRoSD3SqptJLDwUD+5T1hTfzRpurAbwEa9uVpMwIQuYzDaXQuboDS4v9lDUE80Ufzd6BBFBf+HooPe5yihQMcuswO0FpB+vEsYqSWgH9d4Uth9mej0cMGmOFxGnY3UTMi8cN9GMhd1mX7iazpvUUfv6syWAIF/5QuecqlCuGp790IFzJzHeKZq1x8dU+AmnBntar9utT5PsrFIfl3Ym74F7V2tUARUXkvHFwwGLUcYJRTPGveMYUcv2AM+Q1YLZdv19pz63DPYTZbjOQX97umMDcXEtK/5Phzx6TSP/be//L9s+piLkxIL8QGTm/1GhV9JJ+cm9zSq7ggrUbLwf1QLtVAMkTXS63gv81Ai1HcEIES0xJsIlgFLT/wAXumdmrivyfWvOyLruLAPXbDjQ//cm9VP/UGblrAGtJDwRwBpWRq91lPvVmKkKBVelmCSlg1COs4Dgjb8phREhT8biSCDIje7gG/P38Hyvnq0A1njGi5GjwRkgpYYQAfGyI4z39Hmw56v1QWJV/nvTuXgAzy0quBV3NiLl5PJ18mfScDKjd5ArgFi2TJsxu/w8K2lcDaw6L1HNaMDhFlN8D1SefuL3YjT0dipHI83Jr31g7Y1VcD68bNwoEvt2bTaAfiEDdc1PxMywko=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(346002)(376002)(39830400003)(396003)(451199018)(36756003)(316002)(83380400001)(2616005)(6486002)(478600001)(6512007)(4326008)(186003)(41300700001)(5660300002)(8936002)(86362001)(44832011)(2906002)(7416002)(6506007)(66556008)(66476007)(6666004)(6916009)(66946007)(8676002)(38100700002)(473944003)(357404004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4dShmqFP/KPYExbalgY4haVy4z+b5Qsa6SMdHAWhbCPws/RXReTz/puMfM6E?=
 =?us-ascii?Q?O55KFOQow1Fbf/FWi/bKIvFwb8wXXgXD7mtMYrF9mCnsHpqakZMDqpkB5nSB?=
 =?us-ascii?Q?P9ERuhtQoI6yjnLVKQhLyrJRqHeOc5BcLDZ0ICLk/T96wW5Kf2oazoKCtz4N?=
 =?us-ascii?Q?eo0z08Pm5OuOPN3wC9sjzpklEuzAQO+u75O/ISY2eUZnYmlDxoVq92DX9Q/t?=
 =?us-ascii?Q?qWZmr6s3k0kL2Lmmnl2wDc/jKyRC9+ZgvC8AGRPwfIUonxw81Ga8CDsqNkfb?=
 =?us-ascii?Q?hhD225uzT5JyB7tFUD/Wrcy5pS+ftZyYc83zIzeq8QJoPCKeGfPDjY/NmsfV?=
 =?us-ascii?Q?+s27R+q4jusmCuO/miBN/bW82OX+bHW5/gLhuH2QsSrNh3Y4sXHw81lkDqn/?=
 =?us-ascii?Q?z94att/6QSDu4avKjDNNdHLFleBwBh6FC18FBj3dXKCFwy2acd1A2pmtPem3?=
 =?us-ascii?Q?oDFGiFXMf8n5gPSLN4AQKwu9Nxu7fiy/wVFUO6zkqvIOdO8ah4rZ/von3NoJ?=
 =?us-ascii?Q?2JAkx/8/5kyzd+4/dsGJ32wpWJfKV7TnDdRrtVpRiQghjiqIPmQRH95uygUL?=
 =?us-ascii?Q?aWhTMoVv65PICOZgJdcbQBfox4Q4RrwY5KUs+jBAjdtp2Y7GxYxbQmgQay89?=
 =?us-ascii?Q?2QS0eebeHOM9CXIlwmNbF89QCIlpDjlIvF1xCbDE+ctmGHoZ6NYNJWrlv4n1?=
 =?us-ascii?Q?hxgKW9wcyrPcvVu2tRVR5N8M0nJ3LV8LX19c6vSbrZV2ylDtYZaBY7f8d5+2?=
 =?us-ascii?Q?LRYjWx3PoFU5Pv/DPJBtlNtd4oahmhGgzVXiZTHcQPo/lS1GAWHtLvqL1Sg2?=
 =?us-ascii?Q?SAvQPG6zvXB9K/dX4ZA1l518YbGiLn8nZszVO7DkBP/LvglvVsClpNq18rsn?=
 =?us-ascii?Q?lJCcGqox+XhsxydvXczhrgpCAJcEqMFhs+l0IN6R5d1C/Q0jBvrjjj1xtKIv?=
 =?us-ascii?Q?M872Pwxv2XopouHRXjLDt4sSMn4jLmnvfHSVthBvTIMzjNWCxHqwoxdOuse4?=
 =?us-ascii?Q?yTpCIm+LgelgFa3WjhP0Dbj6twgUaeM5ufrd9SInFzF2hz3SelYKqkvN4QJ7?=
 =?us-ascii?Q?y57SzUWNQdgbQIagmevi4Abh8ZbgzLys9tZa9TSnG9G8NoWkT50twr+X9Qhy?=
 =?us-ascii?Q?5ygN7QIxt6x7+VA9A6hhSZ7O6TGr3PCv+HovIq2/161n9n31o+Du9PvbHoFq?=
 =?us-ascii?Q?lxdGTV71IWzI+oveQZHzHaqHs3oBX9K+FX6KIZUMDIsl4nHQD5xew+Cfg+Ll?=
 =?us-ascii?Q?xJZF8L+k5nPLf1ROIPVYmdaOdBu2Q5bD5gOI89sqs31TLNJjcNTnbA673q1M?=
 =?us-ascii?Q?G33P9zQCH7/DZWN3ETHEtKRxmb7m/NGggyLe/Y3YATHfslOuAOiL25Aq/koI?=
 =?us-ascii?Q?zBf6bP6WXLGe9AqBSFEauojHFO6S/O1iziwCNAL1Bypqalayvv9qieDiXPgD?=
 =?us-ascii?Q?46Wiyl6aOa84DAU1x2WNfYQBq5Gjnxsn1zuX/MDREHJV6YOHvile/TSFNbuF?=
 =?us-ascii?Q?xokkqZlqSsfrBQaQ3QT00OcznvL0wDENdzYZQLBbiGS74bcx2Z+qLPocs4+K?=
 =?us-ascii?Q?cOX9zVg6YdZecXojlg+dB3fJ0zJTUzeUWph5A9Z0K/Ymh0vG2VTAr4KfJH1i?=
 =?us-ascii?Q?Xl1w840nvYmx4JIv0oBA2oaCPAUvs359bbD3J5WnsOJGr5/il280IaOn5jCU?=
 =?us-ascii?Q?NCZ/lA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ae76da6-2fb4-4144-6317-08db174bcd82
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2023 16:17:34.4979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5PjH80iMgoOncKKRT03Y4wYcGl0i3RedygHUiACio2v5sm7JqVyIas9QVG0dvEeiL8RTOQny3sLaS9LqeeGo5TZBDK10ABtB2S+eoGQLUEI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3617
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 12:00:57PM -0300, Pedro Tammela wrote:
> The TC architecture allows filters and actions to be created independently.
> In filters the user can reference action objects using:
> tc action add action mpls ... index 1
> tc filter add ... action mpls index 1
> 
> In the current code for act_mpls this is broken as it checks netlink
> attributes for create/update before actually checking if we are binding to an
> existing action.
> 
> tdc results:
> 1..53
> ok 1 a933 - Add MPLS dec_ttl action with pipe opcode
> ok 2 08d1 - Add mpls dec_ttl action with pass opcode
> ok 3 d786 - Add mpls dec_ttl action with drop opcode
> ok 4 f334 - Add mpls dec_ttl action with reclassify opcode
> ok 5 29bd - Add mpls dec_ttl action with continue opcode
> ok 6 48df - Add mpls dec_ttl action with jump opcode
> ok 7 62eb - Add mpls dec_ttl action with trap opcode
> ok 8 09d2 - Add mpls dec_ttl action with opcode and cookie
> ok 9 c170 - Add mpls dec_ttl action with opcode and cookie of max length
> ok 10 9118 - Add mpls dec_ttl action with invalid opcode
> ok 11 6ce1 - Add mpls dec_ttl action with label (invalid)
> ok 12 352f - Add mpls dec_ttl action with tc (invalid)
> ok 13 fa1c - Add mpls dec_ttl action with ttl (invalid)
> ok 14 6b79 - Add mpls dec_ttl action with bos (invalid)
> ok 15 d4c4 - Add mpls pop action with ip proto
> ok 16 91fb - Add mpls pop action with ip proto and cookie
> ok 17 92fe - Add mpls pop action with mpls proto
> ok 18 7e23 - Add mpls pop action with no protocol (invalid)
> ok 19 6182 - Add mpls pop action with label (invalid)
> ok 20 6475 - Add mpls pop action with tc (invalid)
> ok 21 067b - Add mpls pop action with ttl (invalid)
> ok 22 7316 - Add mpls pop action with bos (invalid)
> ok 23 38cc - Add mpls push action with label
> ok 24 c281 - Add mpls push action with mpls_mc protocol
> ok 25 5db4 - Add mpls push action with label, tc and ttl
> ok 26 7c34 - Add mpls push action with label, tc ttl and cookie of max length
> ok 27 16eb - Add mpls push action with label and bos
> ok 28 d69d - Add mpls push action with no label (invalid)
> ok 29 e8e4 - Add mpls push action with ipv4 protocol (invalid)
> ok 30 ecd0 - Add mpls push action with out of range label (invalid)
> ok 31 d303 - Add mpls push action with out of range tc (invalid)
> ok 32 fd6e - Add mpls push action with ttl of 0 (invalid)
> ok 33 19e9 - Add mpls mod action with mpls label
> ok 34 1fde - Add mpls mod action with max mpls label
> ok 35 0c50 - Add mpls mod action with mpls label exceeding max (invalid)
> ok 36 10b6 - Add mpls mod action with mpls label of MPLS_LABEL_IMPLNULL (invalid)
> ok 37 57c9 - Add mpls mod action with mpls min tc
> ok 38 6872 - Add mpls mod action with mpls max tc
> ok 39 a70a - Add mpls mod action with mpls tc exceeding max (invalid)
> ok 40 6ed5 - Add mpls mod action with mpls ttl
> ok 41 77c1 - Add mpls mod action with mpls ttl and cookie
> ok 42 b80f - Add mpls mod action with mpls max ttl
> ok 43 8864 - Add mpls mod action with mpls min ttl
> ok 44 6c06 - Add mpls mod action with mpls ttl of 0 (invalid)
> ok 45 b5d8 - Add mpls mod action with mpls ttl exceeding max (invalid)
> ok 46 451f - Add mpls mod action with mpls max bos
> ok 47 a1ed - Add mpls mod action with mpls min bos
> ok 48 3dcf - Add mpls mod action with mpls bos exceeding max (invalid)
> ok 49 db7c - Add mpls mod action with protocol (invalid)
> ok 50 b070 - Replace existing mpls push action with new ID
> ok 51 95a9 - Replace existing mpls push action with new label, tc, ttl and cookie
> ok 52 6cce - Delete mpls pop action
> ok 53 d138 - Flush mpls actions
> 
> Fixes: 2a2ea50870ba ("net: sched: add mpls manipulation actions to TC")
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

Minor not notwithstanding,

Reviewed-by: Simon Horman <simon.horman@corigine.com>


> ---
>  net/sched/act_mpls.c | 66 +++++++++++++++++++++++++-------------------
>  1 file changed, 37 insertions(+), 29 deletions(-)
> 
> diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
> index 6b26bdb999d7..809f7928a1be 100644
> --- a/net/sched/act_mpls.c
> +++ b/net/sched/act_mpls.c
> @@ -190,40 +190,67 @@ static int tcf_mpls_init(struct net *net, struct nlattr *nla,
>  	parm = nla_data(tb[TCA_MPLS_PARMS]);
>  	index = parm->index;
>  
> +	err = tcf_idr_check_alloc(tn, &index, a, bind);
> +	if (err < 0)
> +		return err;
> +	exists = err;
> +	if (exists && bind)
> +		return 0;
> +
> +	if (!exists) {
> +		ret = tcf_idr_create(tn, index, est, a, &act_mpls_ops, bind,
> +				     true, flags);
> +		if (ret) {
> +			tcf_idr_cleanup(tn, index);
> +			return ret;
> +		}
> +
> +		ret = ACT_P_CREATED;
> +	} else if (!(flags & TCA_ACT_FLAGS_REPLACE)) {
> +		tcf_idr_release(*a, bind);
> +		return -EEXIST;

nit: I think it would be more consistent to goto release_idr here.

> +	}
> +
>  	/* Verify parameters against action type. */
>  	switch (parm->m_action) {
>  	case TCA_MPLS_ACT_POP:
>  		if (!tb[TCA_MPLS_PROTO]) {
>  			NL_SET_ERR_MSG_MOD(extack, "Protocol must be set for MPLS pop");
> -			return -EINVAL;
> +			err = -EINVAL;
> +			goto release_idr;
>  		}
>  		if (!eth_proto_is_802_3(nla_get_be16(tb[TCA_MPLS_PROTO]))) {
>  			NL_SET_ERR_MSG_MOD(extack, "Invalid protocol type for MPLS pop");
> -			return -EINVAL;
> +			err = -EINVAL;
> +			goto release_idr;
>  		}
>  		if (tb[TCA_MPLS_LABEL] || tb[TCA_MPLS_TTL] || tb[TCA_MPLS_TC] ||
>  		    tb[TCA_MPLS_BOS]) {
>  			NL_SET_ERR_MSG_MOD(extack, "Label, TTL, TC or BOS cannot be used with MPLS pop");
> -			return -EINVAL;
> +			err = -EINVAL;
> +			goto release_idr;
>  		}
>  		break;
>  	case TCA_MPLS_ACT_DEC_TTL:
>  		if (tb[TCA_MPLS_PROTO] || tb[TCA_MPLS_LABEL] ||
>  		    tb[TCA_MPLS_TTL] || tb[TCA_MPLS_TC] || tb[TCA_MPLS_BOS]) {
>  			NL_SET_ERR_MSG_MOD(extack, "Label, TTL, TC, BOS or protocol cannot be used with MPLS dec_ttl");
> -			return -EINVAL;
> +			err = -EINVAL;
> +			goto release_idr;
>  		}
>  		break;
>  	case TCA_MPLS_ACT_PUSH:
>  	case TCA_MPLS_ACT_MAC_PUSH:
>  		if (!tb[TCA_MPLS_LABEL]) {
>  			NL_SET_ERR_MSG_MOD(extack, "Label is required for MPLS push");
> -			return -EINVAL;
> +			err = -EINVAL;
> +			goto release_idr;
>  		}
>  		if (tb[TCA_MPLS_PROTO] &&
>  		    !eth_p_mpls(nla_get_be16(tb[TCA_MPLS_PROTO]))) {
>  			NL_SET_ERR_MSG_MOD(extack, "Protocol must be an MPLS type for MPLS push");
> -			return -EPROTONOSUPPORT;
> +			err = -EPROTONOSUPPORT;
> +			goto release_idr;
>  		}
>  		/* Push needs a TTL - if not specified, set a default value. */
>  		if (!tb[TCA_MPLS_TTL]) {
> @@ -238,33 +265,14 @@ static int tcf_mpls_init(struct net *net, struct nlattr *nla,
>  	case TCA_MPLS_ACT_MODIFY:
>  		if (tb[TCA_MPLS_PROTO]) {
>  			NL_SET_ERR_MSG_MOD(extack, "Protocol cannot be used with MPLS modify");
> -			return -EINVAL;
> +			err = -EINVAL;
> +			goto release_idr;
>  		}
>  		break;
>  	default:
>  		NL_SET_ERR_MSG_MOD(extack, "Unknown MPLS action");
> -		return -EINVAL;
> -	}
> -
> -	err = tcf_idr_check_alloc(tn, &index, a, bind);
> -	if (err < 0)
> -		return err;
> -	exists = err;
> -	if (exists && bind)
> -		return 0;
> -
> -	if (!exists) {
> -		ret = tcf_idr_create(tn, index, est, a,
> -				     &act_mpls_ops, bind, true, flags);
> -		if (ret) {
> -			tcf_idr_cleanup(tn, index);
> -			return ret;
> -		}
> -
> -		ret = ACT_P_CREATED;
> -	} else if (!(flags & TCA_ACT_FLAGS_REPLACE)) {
> -		tcf_idr_release(*a, bind);
> -		return -EEXIST;
> +		err = -EINVAL;
> +		goto release_idr;
>  	}
>  
>  	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
> -- 
> 2.34.1
> 
