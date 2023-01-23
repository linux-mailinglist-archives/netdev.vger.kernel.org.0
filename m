Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C234167782F
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 11:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbjAWKFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 05:05:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjAWKFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 05:05:04 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2118.outbound.protection.outlook.com [40.107.243.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D1410D
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 02:05:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RHQ0tzYY7d6ZkFunlex3fv2k5svjkMpW3Q1dYcguryINrj3yasZhDQPuh8l15X4dP6nmQH4lSDQ3uJqT6t81LTTddniBCByqVApCYchMrZGAdQBWfV1cRzpZ5HZl8umvxZsbryiU3DXowexMkPSeQ3dKpCW26ttMLQHAQ6qO/2C7XNash2U8R+H89pjD6mvZTDQAfrvYmk/R+E8ti2Cb/yRkRDz3i3pjjtvJ8qLriZ3461XF0qnf+LGvX2Qy43N1E41mqSG5Co1xq5qh3AT0HqIEszfe9k2Q1rRpYLUp9P/8H1QCI8G9DyCrwqsN5VRRIE1HNxnepqqAkb6zkIWeew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/dALkBEklrHco+AJBP33UnfPk9QDD1lSqxyduHEyxaA=;
 b=OxrNmCnGmo1Qhn3WILtQhK8ged94mmX4V0phh5SfbOZrxuS7LHV43B8RS/xLZVBBoACVT4MF9+Xcrk1Hjx71FXQQ1AI3kwKE/+LiwJV9QIKkGV/2Vq6VSr+4xVZydxXkPgmEyZypKLmuAlb25HYcNYro2St6YHLUQ6dErX5Z5uQ7I96oYF4Ijg3BoLQ9T3rxpHTogDIK9rDZnGMioNHs7Be/EbvhXqY0gTtmjqiC0hi/jBT3sX5/K6ZfPcShzv/MXO9Tg+l+bST9MewrKNY70qPX0Cu6QCisdsS/CESLMtnp1F2hTll6O7aFA2UdvTpRVedb0+3C+Y+J6hTgEkA33Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/dALkBEklrHco+AJBP33UnfPk9QDD1lSqxyduHEyxaA=;
 b=Eo/zGiONIoa/LOIhZ3wrWpaa9IVk64BtzTgpai2hQr3T3Cx0usWbA2JuKl760PmS657+raO0ism9q6z1rVz52k5SY0wHiiAxoHsNKugUL/m2YXyzc5ARlCeQ+fdGalKCdLdL/vxKyGP38f0GUMjSdEEROHN3TCDtcjfcQLzA2Xs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5415.namprd13.prod.outlook.com (2603:10b6:303:196::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 10:05:00 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 10:05:00 +0000
Date:   Mon, 23 Jan 2023 11:04:52 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [PATCH net-next v4 1/6] net/sched: cls_api: Support hardware
 miss to tc action
Message-ID: <Y85bxLzv9wgwh+h5@corigine.com>
References: <20230122145512.8920-1-paulb@nvidia.com>
 <20230122145512.8920-2-paulb@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230122145512.8920-2-paulb@nvidia.com>
X-ClientProxiedBy: AS4P191CA0002.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5415:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f5ce151-c22f-494f-919e-08dafd2949ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lKU/9Rs9nwvw6Ix24F1e8CEQ7e/dL+0lPR3KzH6dOBrxfkJBByqq/C/dYo+cDUTXUVan8rtBKstx4g+bs/9+Mbr/fG1+A//XaklOw1zol8BX24U0fH1h9RL+soYO7MJ3RzwGve15bFCRiD9UIiXQECl/LxgBoByOqHZZrAcTVfgZzJssdhylMus6ooDODVsxSbkAp1rxOIfwLxPWn3A5oB2wSulQ4E4dTd/+IwiKMi6Hcpf4pwiOGe6oXoUHiswTJqAVHwTQp2Ludb8QBDJ9nb1Vhhko8weQCOoEXfAv20jl0IDuolndAe9xqCj2VzIxrTLF2BlFBOf/l2dRP4gSa/nBgAHW0bgrIGfcZtQ6FmmX/pLm5sJX3UX4d9GiM3GJ2Y1fTzItE4Zh8JGeNGgA34IKX2gKHDotptlEt1x57BdBO8gnjvI6Vn80v1ulFG+esuZsJdVgIqFE3uVf4hU6FuYPlauhWuCsZtDzyb5oPlWN18r0ghGrfdO7s9KlGBWvaKG/uA2vHpgqO/Safovx0ljV107WffG1ezEekgPuprqVu4GZSb79mOQeitrvzUniqrnOen/EEkwsqU0gz8W0BGgY2NcmPChchHY39oqh8MjeSxxslnnGXyk4UDe9SaDCRWaTC7Xb+vg+7I13AJv8ihsnINR4SNA4cMcLxIrWBnLMzHs9nmNcLjOl+5FmOCPP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39830400003)(366004)(376002)(396003)(136003)(346002)(451199015)(6916009)(66946007)(4326008)(66476007)(66556008)(8676002)(2616005)(6486002)(6512007)(6666004)(83380400001)(186003)(44832011)(8936002)(5660300002)(7416002)(41300700001)(2906002)(6506007)(38100700002)(54906003)(316002)(478600001)(86362001)(36756003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yMKzGHIReQi60soxym+8nuHLpo5ODU3sdOOSVqr45ttdHohkfPT2TNpSXcCF?=
 =?us-ascii?Q?nwZphqhbWEEynX9qPqJRkWA+DNp26HDQkRNqGA8FqIvlXeWhzrYViaX1SxbT?=
 =?us-ascii?Q?y7asSAl10/WlAUKwUrNDeh0O1pL6l1gEeFGPBSAqbjNaXHRQm8ddvQCN3C8j?=
 =?us-ascii?Q?VLESv0gJHHwNUZhl6N1c3LZczwtJfYU/GQlmIDjaoVccWtV8A+sy7EVhkljQ?=
 =?us-ascii?Q?WaSNEL0wJvt7IOuJ/NvE/pVwcRQGvYSNQDcHdw1rKw8x185bOUhCrCOmD36N?=
 =?us-ascii?Q?TAR4QGGKyP+ML+HAJv2ZRiVt0YI0Zqwg1IKbhJfNnnQ18BU0Nan+D74GPZaJ?=
 =?us-ascii?Q?HSGp4aZMJMb/3Nj1MB/rbF77EzjPvQyniTiDdV+LV4sfFwm4c+vnriLg0GYn?=
 =?us-ascii?Q?w2LnBZs1dv1AnaTka4YreurieR2SGNpdffg5zMApSPQmzaTiKIv4uZFDdaWc?=
 =?us-ascii?Q?c1O1XspMDKXoFdk+3/tIB/Dkz846Cjw3N5uwyJK6hYUrkQokltG+Nky6NM7g?=
 =?us-ascii?Q?ORxnVafimk5qj5mjhwV864EwdPD/DMSjMy2+t3nzPW3vwlvKow+/mtWUivrE?=
 =?us-ascii?Q?4lLDydvab3cfGQSl/LSRyEKazP5fszfLu5OnJFgk47fxACywa/KXMN+dmMy/?=
 =?us-ascii?Q?AhIU5rr3vLWYZOG1mQOJ3bQwIV8zOMWP5UEuNi0FfzoZmUH7aHn9tyrt7/Oc?=
 =?us-ascii?Q?+PVq4btBuCh4qiZ35yMV+9CY6VbJLNsd9zNTTt9FqN6EW3g2/O6dL5NxdeUU?=
 =?us-ascii?Q?V9ZVPN03f+BprYIa5jEV3xVYjuF436qFq1JKuo5+b1TGjlEXDL7HdXb1Ttsr?=
 =?us-ascii?Q?P8c/UTaLQjVN5RxlXWjdSkdfpSDgcXgwiJOS1w9dX5IA7i9ndIsa2DAuzU5U?=
 =?us-ascii?Q?5kXyW+zaHmUaLprDTF7h/Y5E4viNoaEyw8CdpnzwFLP2ZPg6rwujw6BZgivB?=
 =?us-ascii?Q?QSW9f8oh9eLYm5vuGPm9+nmSYaYV8ijlezz4SogJEBRXj86jRBy/LukLSLK6?=
 =?us-ascii?Q?rtgpzhY4EoShrqndKM/kqCl2uBK5/tJGcTj6Pr5s3AmL+GODAOrYdnydN6se?=
 =?us-ascii?Q?OoRyxIlgpFYZJf4VNewhMlIwQh0RmMvv6Kson52YMy7zZ5UYuGYkuiAYBiCQ?=
 =?us-ascii?Q?si2IlIPFNiWuLjxdyZvlwYJwLbYyM6nTR3YUAsAWtKBh+WSAo+8owBOIsE7c?=
 =?us-ascii?Q?spDcjxMeuMOO4dHaT246hKDDwPnq+FaNE8EBOiNw1rCcKa+bBGAPcGakL+cT?=
 =?us-ascii?Q?aym2rpLg9RrKZD0/ZFwBcGRZCIN1V/OnST+PKiR/9eMytjy0VDhS3FwcypPN?=
 =?us-ascii?Q?Za6FhBUKdZAhYAFDEIIDy6plVjIKqJLve8CuQl0WiVZmC+8faxHEr7S+QBMa?=
 =?us-ascii?Q?jSNx6EIE2R3QC+rRvlB9C/7cYIXtEq2TG237TMKgKkzElhc7N5h561tVxtS4?=
 =?us-ascii?Q?m++fi+42veixgJ60zEgcPePYYV0Pm+y43jxT22//PdLoOxy7hZGb7Rj9ajwd?=
 =?us-ascii?Q?0VkMu9Fg7QsOcli3/7vby3Cyd1lvNndJ60uzqXMEFASu+N0ska2ZR/Y55lPH?=
 =?us-ascii?Q?x1JHE3CXpdPR72toNhpxa00I5i192fKLU9brBoLh6YjBC3a57s9EgUQircyW?=
 =?us-ascii?Q?oL7IaAaNtt4LTDdG+hq6Hlwz1hXBEIwqVqarKeAR7BobbMlSL7qHA0w6So9Q?=
 =?us-ascii?Q?TGLxNw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f5ce151-c22f-494f-919e-08dafd2949ef
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 10:05:00.4145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZqKas9rlUTlVDot5uSYytGmQQt509zyN8tcI3NshIeGanEwxOTBIsVCUiuDna5hhiHyyAGSgyn9nBLgLgfDhS27Ec+ep8SFs6OJy8XFfE6k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5415
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 22, 2023 at 04:55:07PM +0200, Paul Blakey wrote:
> For drivers to support partial offload of a filter's action list,
> add support for action miss to specify an action instance to
> continue from in sw.
> 
> CT action in particular can't be fully offloaded, as new connections
> need to be handled in software. This imposes other limitations on
> the actions that can be offloaded together with the CT action, such
> as packet modifications.
> 
> Assign each action on a filter's action list a unique miss_cookie
> which drivers can then use to fill action_miss part of the tc skb
> extension. On getting back this miss_cookie, find the action
> instance with relevant cookie and continue classifying from there.
> 
> Signed-off-by: Paul Blakey <paulb@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

...

> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
> index 4cabb32a2ad94..9ef85cf9b5328 100644
> --- a/include/net/pkt_cls.h
> +++ b/include/net/pkt_cls.h

...

> @@ -240,21 +243,11 @@ struct tcf_exts {
>  static inline int tcf_exts_init(struct tcf_exts *exts, struct net *net,
>  				int action, int police)
>  {
> -#ifdef CONFIG_NET_CLS_ACT
> -	exts->type = 0;
> -	exts->nr_actions = 0;
> -	/* Note: we do not own yet a reference on net.
> -	 * This reference might be taken later from tcf_exts_get_net().
> -	 */
> -	exts->net = net;
> -	exts->actions = kcalloc(TCA_ACT_MAX_PRIO, sizeof(struct tc_action *),
> -				GFP_KERNEL);
> -	if (!exts->actions)
> -		return -ENOMEM;
> +#ifdef CONFIG_NET_CLS
> +	return tcf_exts_init_ex(exts, net, action, police, NULL, 0, false);
> +#else
> +	return -EOPNOTSUPP;
>  #endif

nit: I think it would be nicer if there was a dummy implementation
of tcf_exts_init_ex for the !CONFIG_NET_CLS case and #ifdefs
could disappear from tcf_exts_init() entirely.

Likewise, elsewhere in this patch there seems to be new #if/#ifdefs
Which may be in keeping with the style of this file. But I also
think it's a style we ought to be moving away from.

> -	exts->action = action;
> -	exts->police = police;
> -	return 0;
>  }
>  
>  /* Return false if the netns is being destroyed in cleanup_net(). Callers

...

> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 5b4a95e8a1ee0..46524ae353c5a 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c

...

> +static struct tcf_exts_miss_cookie_node *
> +tcf_exts_miss_cookie_lookup(u64 miss_cookie, int *act_index)
> +{
> +	union tcf_exts_miss_cookie mc = { .miss_cookie = miss_cookie, };
> +
> +	*act_index = mc.act_index;
> +	return xa_load(&tcf_exts_miss_cookies_xa, mc.miss_cookie_base);
> +}
> +#endif /* IS_ENABLED(CONFIG_NET_TC_SKB_EXT) */
> +
> +static u64 tcf_exts_miss_cookie_get(u32 miss_cookie_base, int act_index)
> +{
> +	union tcf_exts_miss_cookie mc = { .act_index = act_index, };
> +
> +	if (!miss_cookie_base)
> +		return 0;

nit: perhaps the compiler optimises this out, or it is otherwise
unimportant,
but doesn't the assignment
of mc zero it's fields, other than .act_index only for:

1. Any assignment of mc to be unused in the !miss_cookie_base case
2. mc.miss_cookie_base to be reassigned, otherwise

FWIIW, I might have gone for something more like this (*untested*).

	union tcf_exts_miss_cookie mc;

	if (!miss_cookie_base)
		return 0;

	mc.act_index = act_index;
	mc.miss_cookie_base = miss_cookie_base;

	return mc.miss_cookie;

> +
> +	mc.miss_cookie_base = miss_cookie_base;
> +	return mc.miss_cookie;
> +}
> +
>  #ifdef CONFIG_NET_CLS_ACT
>  DEFINE_STATIC_KEY_FALSE(tc_skb_ext_tc);
>  EXPORT_SYMBOL(tc_skb_ext_tc);
> @@ -1549,6 +1642,8 @@ static inline int __tcf_classify(struct sk_buff *skb,
>  				 const struct tcf_proto *orig_tp,
>  				 struct tcf_result *res,
>  				 bool compat_mode,
> +				 struct tcf_exts_miss_cookie_node *n,
> +				 int act_index,
>  				 u32 *last_executed_chain)
>  {
>  #ifdef CONFIG_NET_CLS_ACT
> @@ -1560,13 +1655,40 @@ static inline int __tcf_classify(struct sk_buff *skb,
>  #endif
>  	for (; tp; tp = rcu_dereference_bh(tp->next)) {
>  		__be16 protocol = skb_protocol(skb, false);
> -		int err;
> +		int err = 0;
>  
> -		if (tp->protocol != protocol &&
> -		    tp->protocol != htons(ETH_P_ALL))
> -			continue;
> +		if (n) {
> +			struct tcf_exts *exts;
>  
> -		err = tc_classify(skb, tp, res);
> +			if (n->tp_prio != tp->prio)
> +				continue;
> +
> +			/* We re-lookup the tp and chain based on index instead
> +			 * of having hard refs and locks to them, so do a sanity
> +			 * check if any of tp,chain,exts was replaced by the
> +			 * time we got here with a cookie from hardware.
> +			 */
> +			if (unlikely(n->tp != tp || n->tp->chain != n->chain ||
> +				     !tp->ops->get_exts))
> +				return TC_ACT_SHOT;
> +
> +			exts = tp->ops->get_exts(tp, n->handle);

I see that this is probably safe, but it's not entirely obvious
that tp->ops->get_exts will never by NULL here.

1) It is invariant on n, which is set in a different function and is in turn
2) invariant on ext->act_miss being set, several patches away, in the driver.
3) Which is lastly invariant on being a code path relating to for
   hardware offload of a classifier where tp->ops->get_exts is defined.

Or perhaps I mixed it up somehow. But I do think at a minimum this
ought to be documented.

Which brings me to a more central concern with this series: it's very
invasive and sets up a complex relationship between the core and the
driver. Is this the right abstraction for the problem at hand?

> +			if (unlikely(!exts || n->exts != exts))
> +				return TC_ACT_SHOT;
> +
> +			n = NULL;
> +#ifdef CONFIG_NET_CLS_ACT
> +			err = tcf_action_exec(skb, exts->actions + act_index,
> +					      exts->nr_actions - act_index,
> +					      res);
> +#endif
> +		} else {
> +			if (tp->protocol != protocol &&
> +			    tp->protocol != htons(ETH_P_ALL))
> +				continue;
> +
> +			err = tc_classify(skb, tp, res);
> +		}
>  #ifdef CONFIG_NET_CLS_ACT
>  		if (unlikely(err == TC_ACT_RECLASSIFY && !compat_mode)) {
>  			first_tp = orig_tp;

...

> @@ -1606,21 +1731,33 @@ int tcf_classify(struct sk_buff *skb,
>  #if !IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
>  	u32 last_executed_chain = 0;
>  
> -	return __tcf_classify(skb, tp, tp, res, compat_mode,
> +	return __tcf_classify(skb, tp, tp, res, compat_mode, NULL, 0,
>  			      &last_executed_chain);
>  #else
>  	u32 last_executed_chain = tp ? tp->chain->index : 0;
> +	struct tcf_exts_miss_cookie_node *n = NULL;
>  	const struct tcf_proto *orig_tp = tp;
>  	struct tc_skb_ext *ext;
> +	int act_index = 0;
>  	int ret;
>  
>  	if (block) {
>  		ext = skb_ext_find(skb, TC_SKB_EXT);
>  
> -		if (ext && ext->chain) {
> +		if (ext && (ext->chain || ext->act_miss)) {
>  			struct tcf_chain *fchain;
> +			u32 chain = ext->chain;

nit: ext->chain seems to only be used once, as it was before this patch.
Perhaps the chain local variable is an artifact of development
and is best not added?

> +
> +			if (ext->act_miss) {
> +				n = tcf_exts_miss_cookie_lookup(ext->act_miss_cookie,
> +								&act_index);
> +				if (!n)
> +					return TC_ACT_SHOT;
>  
> -			fchain = tcf_chain_lookup_rcu(block, ext->chain);
> +				chain = n->chain_index;
> +			}
> +
> +			fchain = tcf_chain_lookup_rcu(block, chain);
>  			if (!fchain)
>  				return TC_ACT_SHOT;
>  

...
