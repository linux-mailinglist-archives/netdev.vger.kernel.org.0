Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD4F6BF25C
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 21:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjCQUY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 16:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbjCQUY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 16:24:57 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2126.outbound.protection.outlook.com [40.107.237.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DFE2E82F
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 13:24:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m5tUhh+9l7Cy9tY0lcyEQK//9r+qIwFF0a1R/RIcLhzsG9vc7eCe7O7nAkVIu6/2m4TrUlz/fUsp2QDQttnGbVxCeUvTyai6IDwsZQC4YDshq+sSCKkHCk0bZrVeS8ZPtL+uzNGOvFooqfajp4AO45bAshAFY3IFK6MItq7dkungo7eOr56mT2JWaUzXyRgwfMKGlA+2ZNNz0jgS6S9mI7JiEVdPonDo/lrSk4e7sv8Hus1CnfEBY7YgVMHzZUrZthgYwYQ3DrjopSeAGP90HvAQq7YDPPKJXeV92ToeaYklWRiR6srLv5FV+KwYSq6emJWGFary6XxWd/GWZiG/fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7opqS8omAkSMvoqA9trGUEt2JtZMjlUGQ0W+4EweSvo=;
 b=LH6ZGLFV45XpHjFC09N8I3aUt1fboILqj/5XzEHFQdTzW5iblCJHndsLln6HGc9e1Gi0OHgtumCqP/fuACZosRyt/vCqhTq2tczwkOQQMpxyuuJBGW3anF78f92iLxmtUdJR9n9SgiWG1OtXjD8mfHQGuGEzLNWiswU1ttJ3g3925Vb4Ip5iviCbZp1ud0mvq+r4G9oJYjfCTw5iEFshiBGRg3rQwCs0v3DpkTsJv5AoGd8Nebqnlrwl3laxl+dSOkDo/dXgNJaFvoHrYKRVriJAFg0tAosCixSIYRleWWg1NuB/FKoxM7kYE46dqPpy+GCWd4bdX1gDGBWz+ibX/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7opqS8omAkSMvoqA9trGUEt2JtZMjlUGQ0W+4EweSvo=;
 b=W/QhReO460y/OQRUqkZ78x97CezEQIb1rD7VtxFIyzN/B0I+f0PtGDV6bfBNxnvK+H1+hnCbrXEcevojBtOtiWLLwBVVMkeEbzvp7I9od9joP6xJiIva5IypLT+Mj8l5/KyysAjbOjXed24yM/P1YrGHaAveeYSWWF/tAsb0gtk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4578.namprd13.prod.outlook.com (2603:10b6:208:332::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Fri, 17 Mar
 2023 20:24:53 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 20:24:52 +0000
Date:   Fri, 17 Mar 2023 21:24:47 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next v3 1/4] net/sched: act_pedit: use extack in 'ex'
 parsing errors
Message-ID: <ZBTMj7DCCTQaEOCi@corigine.com>
References: <20230317195135.1142050-1-pctammela@mojatatu.com>
 <20230317195135.1142050-2-pctammela@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317195135.1142050-2-pctammela@mojatatu.com>
X-ClientProxiedBy: AM0PR03CA0087.eurprd03.prod.outlook.com
 (2603:10a6:208:69::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4578:EE_
X-MS-Office365-Filtering-Correlation-Id: fa0df273-aae8-419a-13e7-08db2725aa1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NQ9jWSWEzQKaj1rBfLJJTGUymNsGn0VV6PonabTvHHs4nFeAk8M6UIUUBNv7Bz4Ywwgy+pNJW3rcVb9iFm3ZvwFD9D4B2AVuzzCdpV2dIV+YANR+PVXu+mfRitj5pEdePrvlmqbwxqPhq36EsNbiHZirJcs1Gmdam/s6uTi4A9dHRzka5AvS1JseLe7xbWukjUDIZPOx0UrhysbfZWj67UaagZwtaPmfD/jN/HK29VhGbKlvz/l0ysx8OtNkrkRAOYY+WyU/hdEF7HzdJntxlkFlwWKbDVKmjA4PnmZx+slPYYh7+T443AyWNpg27iSrIUTtyw70AxFZLHLRKZD48UpEYjhD8nGpJzVsin4niQCTG2h7Qn93oCnm1i1veG1eErfnyjo6mLXDZwFgb80tZuaCUSpHj/bmBojFEO906pbjZVVplUm0gyIWNwmfidMvYYgPdpwDL5IeJFgiH3/CJrltBHXh6wRdEEu/0f2xKwC470RWbRuhIPOrPMqXZZZrXVLea7PXqj5EYXw222X0pG9NJ6LU3z8svtkMCRteloJLLpFTQZlVL1KniViBjAYN1Y9dRk4fNWjiK3Ku50VZbejEZjacuNhPRZuqXUYJoM5kgReQTeZLNi2aSToNI07JBJtk3ZYB41TaaaIo6o02Ow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(39840400004)(346002)(366004)(376002)(451199018)(36756003)(4326008)(8936002)(41300700001)(5660300002)(44832011)(2906002)(86362001)(38100700002)(66476007)(8676002)(478600001)(6486002)(6666004)(66556008)(66946007)(6916009)(2616005)(316002)(6512007)(83380400001)(6506007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5PN5b+RSlLUKTVvCzsqz8lkyPJozr2byMT9iD091xlzzFCxqGZgtJ5+E/uuu?=
 =?us-ascii?Q?SH9Ca7yFeZFweo73eKiB0NA+FeZDkks/Rj6Feq1np00brNnYLf+oZ3D5L64+?=
 =?us-ascii?Q?0P+2niAW1bMJJKalODr7he8juwSdtwiaykfyRxLZ1N+q0RRlAfJabnWMPFLQ?=
 =?us-ascii?Q?m5pwU5wk4hxCtubx2kRYbKzAAaXcA1c6PWesytmWAlkJey/7DneOzkWJn6Kg?=
 =?us-ascii?Q?AaAuaCqxA7UXLiDK//sxZhxhc47/5cZNJtDvk320kmYvyZ4uzMck+eDoG6aq?=
 =?us-ascii?Q?9kJLYPY+1Oi446ORVFnhdleQY3EwhFhezgIVUeuuL/XJLAHRPl67YFnLDiN0?=
 =?us-ascii?Q?Kmwu6zVlO9jQggS8DG0pGDk1EHeur3Hw4LKcqmkB+bxV+0lOY/CoXot6wXcx?=
 =?us-ascii?Q?W4aCxj/qiXbdojoAPESTSk0yebYwNBhWdOAopFfytdwg4eTeBbMr/8COqo2P?=
 =?us-ascii?Q?DwL4opoHdbevxJrJh0uSxQP7LbBNxTo9lF2SlMA/sCtMzd31KF5/MGPRwODn?=
 =?us-ascii?Q?76KY1LDA4Rs4TXBfk38riFTC8Zs39cqTUwhU9F4w95Y8661uNlPnLkmKpYlh?=
 =?us-ascii?Q?sO3hI+uLj/eW+Gk8umOsEpn0UE2FKyM28/yhCTMx++smgDhQlpZyCcjERP/L?=
 =?us-ascii?Q?6OimNXkt/Q8OATmg6sdzuFO7hdMsIuiYUd6Z5dmW1UzWL0OBNsqo9yMsSZmi?=
 =?us-ascii?Q?DlLshm5MLl9IdB6ZFK3QTYEAyT2LucqNok4Wta6tqT4BR85Wzn0yKS6SoCfO?=
 =?us-ascii?Q?Tdw5O/P62hN2EzM4M4IglMWTIlQ10BInMRQwsF8m/kKDS+u5vgesHWrMIDQl?=
 =?us-ascii?Q?EXWlCDMHwwV2ZWF0St43+Mj3Hg5YprvgmNOqb7JMqsH7EqCqIj2cFkf9B/jV?=
 =?us-ascii?Q?slDqxaAiT/5WsaB4H81A6Srr1nsu0EFg31wSorhxU+JJ3gRKy7bXDvGu7Dvi?=
 =?us-ascii?Q?M3H279cZvGJdGZXuPhSiNLkbsqY9QIgoOPn4mMXKY1AKlgB8ecmVn/1fS7sJ?=
 =?us-ascii?Q?aqzjvZEmhxonCn89Ej8ZVbjdUYgCPTry2f8A3G5u4J3vxX16EKRsEydZs/PZ?=
 =?us-ascii?Q?J1DPs20Rk+F2U0+3UaJzSRjpQ9W1w9C4Y/5MqY8CAIHkPwCV7Tfo0Nef6o9F?=
 =?us-ascii?Q?8C/BQVXkpfMObg5wjtyy3om0dBdpRBRot02OOhqnGtBVm0DjSqGoevupkSHv?=
 =?us-ascii?Q?g4tlT5aHJREXHbDCnA4VisQUKBSB6FSY0wmFd5anJDjjdysVKT9WjPQ/H39R?=
 =?us-ascii?Q?WQGSmNqCS0h0jtytYEYJIx4FKmVrlFfcPSoYc1VYOTySuTw4nWH2F9HKZnrW?=
 =?us-ascii?Q?0eGs8YJxL9MMgMCzM+r4ax9XLXWErTklE6Fgg0Ts5Thi1+wrfPwlUWrsMJwq?=
 =?us-ascii?Q?1GNqzFbWttwbMPRyVsetaBUvRiZUfgEEBaSfyUVYWi6N9BZ9kYXpbvLEttRf?=
 =?us-ascii?Q?KoGozOTNszpFEbT0+S19A0EWs06wGcoHibDhtXbLXj1B/jgJLQIVQ6wdT2Jf?=
 =?us-ascii?Q?2HiFlmjWb2tMsm5BVG6Znw2uxEYUuHj3qCH139NvAj1cxIobjqrDkXEVXkMN?=
 =?us-ascii?Q?xvkzdmgFU1ScfHsPRH9Ac4HZXMzv9JhR6DeAhZ2zCY5i0Qkoc2FZh0aPoaLZ?=
 =?us-ascii?Q?n9rJOQ0CsVHeSt/qmeInOG/tTQj2R3LAWZPZbDEC9+TFrj8oOWn83dI8sVVT?=
 =?us-ascii?Q?O2q1gA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa0df273-aae8-419a-13e7-08db2725aa1b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 20:24:52.7524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D8YsiTRtpqL0QT7v+ag4yA6k7T4YiEk553XJmvjNfF3Zu7Xb5+6nL86JkM+7gCcNF9kw0/PoBDB3TC4RYWVqkWb4WBP9gjwWp9TMspl2cdQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4578
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pedro,

On Fri, Mar 17, 2023 at 04:51:32PM -0300, Pedro Tammela wrote:
> We have extack available when parsing 'ex' keys, so pass it to
> tcf_pedit_keys_ex_parse and add more detailed error messages.

This part looks good.

> While at it, remove redundant code from the 'err_out' label code path.

But I think it would be better to do one thing at a time.

> 
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> ---
>  net/sched/act_pedit.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
> index 4559a1507ea5..cd3cbe397e87 100644
> --- a/net/sched/act_pedit.c
> +++ b/net/sched/act_pedit.c
> @@ -35,7 +35,7 @@ static const struct nla_policy pedit_key_ex_policy[TCA_PEDIT_KEY_EX_MAX + 1] = {
>  };
>  
>  static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
> -							u8 n)
> +							u8 n, struct netlink_ext_ack *extack)
>  {
>  	struct tcf_pedit_key_ex *keys_ex;
>  	struct tcf_pedit_key_ex *k;
> @@ -56,25 +56,25 @@ static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
>  		struct nlattr *tb[TCA_PEDIT_KEY_EX_MAX + 1];
>  
>  		if (!n) {
> -			err = -EINVAL;
> +			NL_SET_ERR_MSG_MOD(extack, "Can't parse more extended keys than requested");
>  			goto err_out;
>  		}
> +
>  		n--;
>  
>  		if (nla_type(ka) != TCA_PEDIT_KEY_EX) {
> -			err = -EINVAL;
> +			NL_SET_ERR_MSG_MOD(extack, "Unknown attribute, expected extended key");
>  			goto err_out;
>  		}

perhaps I'm missing something terribly obvious but what I see is that
this code sits in a loop and the initial value of err is -EINVAL.
`
>  
> -		err = nla_parse_nested_deprecated(tb, TCA_PEDIT_KEY_EX_MAX,
> -						  ka, pedit_key_ex_policy,
> -						  NULL);
> +		err = nla_parse_nested_deprecated(tb, TCA_PEDIT_KEY_EX_MAX, ka,
> +						  pedit_key_ex_policy, extack);
>  		if (err)
>  			goto err_out;

If nla_parse_nested_deprecated() succeeds then, here, err == 0

>  
>  		if (!tb[TCA_PEDIT_KEY_EX_HTYPE] ||
>  		    !tb[TCA_PEDIT_KEY_EX_CMD]) {
> -			err = -EINVAL;
> +			NL_SET_ERR_MSG_MOD(extack, "Extended Pedit missing required attributes");
>  			goto err_out;

If, f.e.,  this fails the code will now branch to err_out with err == 0.
Which will return ERR_PTR(err);

>  		}
>  
> @@ -83,7 +83,7 @@ static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
>  
>  		if (k->htype > TCA_PEDIT_HDR_TYPE_MAX ||
>  		    k->cmd > TCA_PEDIT_CMD_MAX) {
> -			err = -EINVAL;
> +			NL_SET_ERR_MSG_MOD(extack, "Extended Pedit key is malformed");
>  			goto err_out;
>  		}
>  
> @@ -91,7 +91,7 @@ static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
>  	}
>  
>  	if (n) {
> -		err = -EINVAL;
> +		NL_SET_ERR_MSG_MOD(extack, "Not enough extended keys to parse");
>  		goto err_out;
>  	}
>  
> @@ -222,7 +222,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
>  	}
>  
>  	nparms->tcfp_keys_ex =
> -		tcf_pedit_keys_ex_parse(tb[TCA_PEDIT_KEYS_EX], parm->nkeys);
> +		tcf_pedit_keys_ex_parse(tb[TCA_PEDIT_KEYS_EX], parm->nkeys, extack);
>  	if (IS_ERR(nparms->tcfp_keys_ex)) {
>  		ret = PTR_ERR(nparms->tcfp_keys_ex);
>  		goto out_free;
> -- 
> 2.34.1
> 
