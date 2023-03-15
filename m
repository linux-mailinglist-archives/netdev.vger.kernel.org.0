Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02AFB6BB884
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 16:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbjCOPwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 11:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbjCOPwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 11:52:40 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2106.outbound.protection.outlook.com [40.107.93.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2518A7FD73
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:52:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gNZ/45cspb/9BE6dUjMDeW8gowGdErSM1fs9VaioTaTw479xX2+6xIM1ZFY96uvbuuFCdMgzPSQQMOoRpJ6Sc+KHxYJ1Nxr24aq+SsvvzvuuPoSHX4L4t89LSro6/42+MZUG4Q4qZWqtDKhDqjz5WhYyLH+hW/Esgsyyx4JSs+8wt0SLPFTLZDdXcLpifmaWJltqyUuLsPm9ayS8FyhOL4P3mbk1bmAdiP4HGzRXt/yCWssPXtgt8iSCX1w184XR7ZM/VXVHkMZ6pUfXt3HS9HXBciTpaMpN6CPMne7vWOo9HaxlMx4mxI+Jv6WTz81QVzTLGG0QUM2rab3jkSdNmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=epmowEBFqhr36zYUgidWUyUT/vpkbpSRQ4TpL1jHsd8=;
 b=FEdXbomLLxJOFm0FFVjiSo9TK6lGiZ0D/Mt0tWJqu59kICw5ZG9qIYp2urIglQwtBdCzRg0DSvMZnj0ywE4w6FFA04fN6Svz6vvjkoD/5Ho0qBXZs5o6zB06ot/LyPIfD4RFhoNq+3zsFPjlnGaE1vtlIA8EGfLq6Fz4KqNZ0Q8AeqlwEWXsMUUvo/bQMkIoc8RNXJnFabLSkQt2bGj+Jnc7nsWybJ2XF4t2i+beyzvh1K3pRHi+xGXYVtnGYNwcn23SY+04t+VmANZOphlayypFvC26bHMs/Oh4vYD9Te8jEEh5p80DwtDWzWVuzwLFDdazlMf/xRsiyUfHBZt7pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=epmowEBFqhr36zYUgidWUyUT/vpkbpSRQ4TpL1jHsd8=;
 b=TQhZtiVE8jUK6UOJSlFAFDM+il6bZDD2m/gUag3lkJQ1ndliFCuYGNY5GX2cWxjW6yernwNCThOlGb4DjexgSoATUaX3VQhJ13NcUOwGuip6LUuQSwKBMSaw5yD0nMOKpZ/w1mrugtw1XoZcyxzmUobY8yLKb/Bu3I6TeeXZo8I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO3PR13MB5768.namprd13.prod.outlook.com (2603:10b6:303:167::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 15:52:02 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.030; Wed, 15 Mar 2023
 15:52:00 +0000
Date:   Wed, 15 Mar 2023 16:51:53 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next v2 1/4] net/sched: act_pedit: use extack in 'ex'
 parsing errors
Message-ID: <ZBHpmU+E0gXHRjB2@corigine.com>
References: <20230314202448.603841-1-pctammela@mojatatu.com>
 <20230314202448.603841-2-pctammela@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314202448.603841-2-pctammela@mojatatu.com>
X-ClientProxiedBy: AM0PR10CA0057.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::37) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO3PR13MB5768:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fbdb504-22cc-4d65-23cc-08db256d3675
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VfqpryMhbzyiGHlISk/dKD/fOLk3RQR7YywnOsLQ+QJTrgheX5Zp8pR2HXsEYRXElPUfPtdu8gEaAPOEEBaAEzrq98IMHoQnu4mFeCKPz1fVQjmRMRmAZcF0IMZFuXVMxIij7pkaa9HNFap1qtUWqLo7DtKVebVbZFQXI/oDNqvisY3voEQjXnnt3BoCtAPhjAQmxHuTysFXYS0zP+LWHAQAkBgl5oiy8HgNxn8GT/gD8n2ofJploz9K+oeYQMRUx/qoi+thzKa9ODgdDMiezBbqHGRAzR8/2LoNuRTqXszoAlBQ6WFZzJU22eSFJqu8gyOWOck3mDrptb/E8n5RZCkM3PpbyCwc1v/iAIDWrcRxskj+OLFT4NPbVbismLC/YC2Q3rbr2Jh5LjSVoxrvRy53TMV+LWoXO1Wf1xmDjTamMbu6C0Pv5m4/EuNjONPXZTvx387DPOH2CS5W/KQgF0S26Kh6/eaGJyhLZZzoOyw++pCS4bcjrD7pImu/Z4EQqTDRbWLPckEoYPeE3tqtrA45GqcdnENFX6H5wtfm7hNObKd1GKoWX17CHg5NkNLXV+P2nOchr3nES3zxtvsSLreqRJgTOskpH4oKU1lh1uVWVH8jeqpaVKHC2oX7kyHIO7MyTpalmVQ5ZeWSLrlF3KyKa2ro046kz4SNalQdLFxezm926FXG5WMoRWhSScKn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39840400004)(396003)(366004)(136003)(376002)(451199018)(86362001)(66556008)(36756003)(8936002)(5660300002)(44832011)(2906002)(41300700001)(478600001)(8676002)(316002)(6916009)(66476007)(66946007)(83380400001)(38100700002)(6512007)(6666004)(6506007)(2616005)(4326008)(6486002)(186003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f1M8f4ROGFPToG8O0BhTkDQlWnlL7ESa0op8FICSMsyRTrZ2uX6aKun1+5EB?=
 =?us-ascii?Q?At5wNbqOgzVNvLF2/zvJsy1xT/BZe+SD5GHjrJ16Jn19v4W7JiUifQC3YpmC?=
 =?us-ascii?Q?omcIHTlB00XqE5vNuwP1y6veTgJVWAWHFRsNxEEx5TA2+3inP2BFh6oBU5yA?=
 =?us-ascii?Q?GB7eYDWqucfVzR05euYcdUHRNuNFB1v9nhM9sz+SY1cuKn4LPTmrowCDE5X2?=
 =?us-ascii?Q?693kjDEtco9Sxw1c1tvU+2W+n37Sp86h/Ktk0rezx1xQMKREpB3lyqZICZcW?=
 =?us-ascii?Q?dDd1Sbuf3uHHMIYNUXfHfdF4UIS6v8cMrC2nKI1KZyG0LptU3B7x8NkcUFRs?=
 =?us-ascii?Q?5nCmB7et/qPsocNWGbm7V8pGw4Z/U15l7ovrM52LXgs8UcZWAIwR4giREher?=
 =?us-ascii?Q?VSQdqJ3aJtgzzObIX1i3PjQIVOic9YUL/ordB8rnxjheOmCpeTyonECO7JhF?=
 =?us-ascii?Q?d7M7SI3UJNHfSGEO7sZ2grIHq6oidNPQ+LLVpw3L1428ph/6+NZSEi091oxy?=
 =?us-ascii?Q?29UGjVHAAfMfLFKWqySEeATHWM6TiKdZIsgx8uoCGMzXMUWDBrSoBroi1VbA?=
 =?us-ascii?Q?UasxcJxrR6S0ohZFrS8hm4pK+4/lej3aOO1FgGhggrM/chnpp0i3hZk/Hwdx?=
 =?us-ascii?Q?juH/uIyeg28mp/xsiMxof9F4/mtv0AHh8qz6ptapGzWGPK3albu97f7kkLoz?=
 =?us-ascii?Q?d75baRYSIjbJhmFJQ+k8BcjiumBbutdBGkb678KAuDy0xgYUagNpvOe7fL5u?=
 =?us-ascii?Q?qLxsrq7uvDgnllhxakBvCG0dltG1Yy5a0W2qbzRzvo7EdpkPFmk0s5HIN/ML?=
 =?us-ascii?Q?y0I6r8Op893HzGqKI7tho3KrFBvYVGZ2GIqXUcCDZbxj9jmOtgnqnhBP7rvA?=
 =?us-ascii?Q?5vlpp3du/KxqjjGi3hLEAQrr7O5HI/N8lKGW3XS61rwYu2qLctfz2fLFkcOb?=
 =?us-ascii?Q?Ty0NvFUzJRB6YEExfO6A2x9dwjW6tXQTI9J71thnTCKcX778qjGSZwkaGyFl?=
 =?us-ascii?Q?TLog8xwozjzgk2Ov3iGqpCKz8c2icnb35IhZUZ7UyA8KM76POeUIhdd5ypjU?=
 =?us-ascii?Q?N68YWYtRS0/8eyfHvc9N7bb1iS4iME7Q3H1aH0DFuohorGIUubaAhmmHcbM0?=
 =?us-ascii?Q?rONtZfN01ZfOPYiSJ0+11SiQp3VfaFmgZkaGVUaojY7iu7214ZUmGxweSFDR?=
 =?us-ascii?Q?hD3Il8fT+8tFhNTbTYDnDOsHpa4IaJoJUlip0Fz80V/gKThd66ehKW7z0EIO?=
 =?us-ascii?Q?Z/WZP5hp+X/Ev5NbXB/spGieLLvkCIVW0zpRWM6H1NH0b68bUopVOKvKjCHF?=
 =?us-ascii?Q?hdXtcrIg7Le4rqkwUH3HCJyFm1wZzgNlj39pwIS59y7274vIJskQ0P/3Bxt+?=
 =?us-ascii?Q?aeo3q2qlHxA0O58a/n3wUjm60o84r/SiILwANaaLDwuMSRd74e5BaCpdUdIr?=
 =?us-ascii?Q?oIRuShQoFNdEeuSLQ+9QUpUVzIYfTef7b9eni5KC3ecR+WOMAM4mI/VIxX/D?=
 =?us-ascii?Q?ExUGM2PayFyLJfl3btXhNx+2FILFAAIRmbVuWFXw682IwuinQDOc9f3MbAIY?=
 =?us-ascii?Q?09zB/O/REktBqgD6jKps7KkVVQZz93ZNDPt5Zgw7LoQqlT7wr8aqb6NqZ/nR?=
 =?us-ascii?Q?gkzKg7LrAcpoFs8nGlBTTsg8cvrZHjJui5m4ruZqRwjAasUODN2Do1hP1AX6?=
 =?us-ascii?Q?J3sTzg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fbdb504-22cc-4d65-23cc-08db256d3675
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 15:52:00.0397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HzK4Soj0FM2LeWZKP+UK5lO5048yVytCygP5z1tC7uzHMtfBq/ab8B6su9/NF2VHhNZVV/aH9OR+XE9FlwmjkR2KMXq8iYOaYK+hZsVmYnc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO3PR13MB5768
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 05:24:45PM -0300, Pedro Tammela wrote:
> We have extack available when parsing 'ex' keys, so pass it to
> tcf_pedit_keys_ex_parse and add more detailed error messages.
> While at it, remove redundant code from the 'err_out' label code path.
> 
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> ---
>  net/sched/act_pedit.c | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
> index 4559a1507ea5..be9e7e565551 100644
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
>  
> -		err = nla_parse_nested_deprecated(tb, TCA_PEDIT_KEY_EX_MAX,
> -						  ka, pedit_key_ex_policy,
> -						  NULL);
> +		err = nla_parse_nested_deprecated(tb, TCA_PEDIT_KEY_EX_MAX, ka,
> +						  pedit_key_ex_policy, extack);
>  		if (err)
>  			goto err_out;

err_out will return ERR_PTR(-EINVAL).
I.e. the value of is not propagated.
Are you sure it is always -EINVAL?

>  
>  		if (!tb[TCA_PEDIT_KEY_EX_HTYPE] ||
>  		    !tb[TCA_PEDIT_KEY_EX_CMD]) {
> -			err = -EINVAL;
> +			NL_SET_ERR_MSG_MOD(extack, "Extended Pedit missing required attributes");
>  			goto err_out;
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
> @@ -99,7 +99,7 @@ static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
>  
>  err_out:
>  	kfree(keys_ex);
> -	return ERR_PTR(err);
> +	return ERR_PTR(-EINVAL);
>  }
>  
>  static int tcf_pedit_key_ex_dump(struct sk_buff *skb,
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
