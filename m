Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4425B3BB8A5
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 10:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhGEIQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 04:16:32 -0400
Received: from mail-eopbgr70054.outbound.protection.outlook.com ([40.107.7.54]:57408
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230000AbhGEIQb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Jul 2021 04:16:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I/CVTVh5WvXw2bRIR7Ji3KXXRKYLPV42kNbLTeA4FIpOJcUZiVcGuuCyPhmSUKhGoG2oywWovKVEdwNBjrkpLtq4GzxFaDpzqGQSc9VxDTBKdiSyuCPv0Z1q33A007p2G63q8l5JC0jz/8j+2DrFctnw7fZrOFZSuS+wDMxGOTS1gW+EAdtKxsOydkZjYd9eNNtRiJA3t6rCmZ01POr8imaWv7iNHCXTUvPXK9Bqf/D7wOGJP++jpKv+P5EvTlEhJWcK07zgu202qWo1XvohpdGe9x5QxsiglyNOgS8lqljN+1kV8Gpq1LPnmJN3D5jwN8y/ubp/OmWuCJ87wyKkvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=16CRPByyO6gYKJ2VzW3sbOXkoMbzqZUooGakaRyfW68=;
 b=WkkuJxnqMPaaa600ZuYIE93/EavRUZTpxCdAKQRB3RqQTAEnF4CCzqOoUaa2fcznJHvPSgpFV9XnV9aA1InMagloj7iSuRlMK+RyARNtXDj5+vZtX0tzecihhvjoOYejrvX2S7/pKlLELLmlJH4JcugXT0B1AeO4QbZJjjTDBasqPBJLzIuNuZmb5yPePg7br6FpQ9athElvA3fy/sHOof2sM5lvNkZfkE9y7jtHuU98AUm625rLu61L5tUDb72I3l4aEC7joIhkxe11YarBmqCcHeSC+mrVT2qpkaVVQgfrk4cOlt2QNLAtzLpsQDclhxkI3/KAFAzFt7tIsA+XhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nextfour.com; dmarc=pass action=none header.from=nextfour.com;
 dkim=pass header.d=nextfour.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=NextfourGroupOy.onmicrosoft.com;
 s=selector2-NextfourGroupOy-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=16CRPByyO6gYKJ2VzW3sbOXkoMbzqZUooGakaRyfW68=;
 b=JQk0FTPbgLRB0YcPFnta5G+LmlApdauR20r+4w1FHhFqO59V1+eHeBSn6CAd8lsEVGBnBaIPG8L+N2cODs/94KDqpaV9Yubdz0GKAZuaqqYP6vslSiSYhkV8zlAVr0tt+3RlrJUz6qob38LWZpPHKIvfYb4XsFnblRQFj3BZTrc=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nextfour.com;
Received: from DBAPR03MB6630.eurprd03.prod.outlook.com (2603:10a6:10:194::6)
 by DB7PR03MB4684.eurprd03.prod.outlook.com (2603:10a6:10:22::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.26; Mon, 5 Jul
 2021 08:13:52 +0000
Received: from DBAPR03MB6630.eurprd03.prod.outlook.com
 ([fe80::254c:af9d:3060:2201]) by DBAPR03MB6630.eurprd03.prod.outlook.com
 ([fe80::254c:af9d:3060:2201%7]) with mapi id 15.20.4242.023; Mon, 5 Jul 2021
 08:13:51 +0000
Subject: Re: [PATCH net v2] skbuff: Release nfct refcount on napi stolen or
 re-used skbs
To:     Paul Blakey <paulb@nvidia.com>, netdev@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
References: <1625471347-21730-1-git-send-email-paulb@nvidia.com>
From:   =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>
Message-ID: <ecceba2b-bbea-7341-19d0-d8007833ccc0@nextfour.com>
Date:   Mon, 5 Jul 2021 11:13:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <1625471347-21730-1-git-send-email-paulb@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [91.145.109.188]
X-ClientProxiedBy: HE1PR0901CA0056.eurprd09.prod.outlook.com
 (2603:10a6:3:45::24) To DBAPR03MB6630.eurprd03.prod.outlook.com
 (2603:10a6:10:194::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.121] (91.145.109.188) by HE1PR0901CA0056.eurprd09.prod.outlook.com (2603:10a6:3:45::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.21 via Frontend Transport; Mon, 5 Jul 2021 08:13:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7210fa75-a6b0-46a6-3600-08d93f8cd2de
X-MS-TrafficTypeDiagnostic: DB7PR03MB4684:
X-Microsoft-Antispam-PRVS: <DB7PR03MB4684134353F79659862669BA831C9@DB7PR03MB4684.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DP/VjB5AD6b8nXs/q15P8m0nI7KOEsqTlKvuu+j/NMVJTd0IPCiVGnDloLIrZlVxEozNVFL0sGTqNI/11asgcY8uttxNMBWx+ZafkE44H9kJg/GVH+nLeAhXUDCVNbE9TqDRw8WQfoeGdL1RbKJy9nfM5C0R+fmvL9PqR1TZJiC8JyKye0bchyl3UMCAaiO5cRHrVj58wRm+ajGHnBT3i08a9YJHjYELF2LImu4lDEgK1ovtpCMyWT7MtBxp34FG154xMxEQd84gsv+Frem25nk2Hx2U98enm62jSFMTi+Z76ToUQv1i7RvL0X7n5Ova6iCLO+Av687UonAoUfvLIBVrjZgc/zVpnkY1LbZNoGOOUN1uUHRNJqnbAvytOW/CruoblYcjrUhbPJdeyJfT40a907zF0odqd5oVtKz/ZcE0eLZoraFPU64/MQQU4Xj8U9QlwLI2W/SpQXnwpXGmMMlieyBozN08M75EfNEH3TrOZ4Q3x/5M8Bh6PmXPM0+RDvWVztkESQfGVO5A1aNBlFs2JMjG2TVMmLUxnT7RWOmpNNsH+fTo8oycwgna5Xi7VMj2ofQsZiT8ThrPcJPMpWiTfxeSPBYhu0dpt4XMy/0d3TKPyV2lAr8n8UJ8LnuRTdv63tRZmV2BDQbe2KWEC0Sm4WoXVahsDQ04lbFj1PPo7cSsrD+ZiwBqULQpvboZO2x265sncTZjlL7UV6xK9xxHFI1/0WCusUf6bNhk1vrkgLxH1HLKJPDC9E4XQS3y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR03MB6630.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(366004)(376002)(39830400003)(66946007)(4326008)(2906002)(26005)(31686004)(86362001)(16526019)(6486002)(186003)(31696002)(8936002)(2616005)(956004)(5660300002)(52116002)(478600001)(8676002)(66476007)(66556008)(316002)(16576012)(7416002)(110136005)(38350700002)(54906003)(38100700002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1NSZThIeGlZOGY5aDlvcHhNWUV2akttaXRQUDNha3kxUVorQ3RBQmJPVkVU?=
 =?utf-8?B?T2g0cG9PMkVwaDBVZjlWS1dWUWlxM2RYL3o3bHpTOEN1R211SzdvSDJhcjVZ?=
 =?utf-8?B?TW9keHV0R0RmdE0zWU1uWXQ2d2xaOE5xdm0vWHVJWFppMDJ6Y2UyVnNoR3Nr?=
 =?utf-8?B?SWFXajJBNVc4SEZHRjVIQnhOT0RzOHc3dDlBLzNBYm42MkFxZHpLbWZPZndC?=
 =?utf-8?B?NnV3bTQvYnpVdWtCc3NGbjBEZnVXc3FrcHhaMkVFKzBWZ1FJbW02Tm1YUEY2?=
 =?utf-8?B?TkRBTFNBeVA3Q204OStGT0ZBL2JlV2w1Rm1Sam9TTEFadjZwMTd1bTIrRXUw?=
 =?utf-8?B?ZmFBRWp6WkJIOUh6blFha2FnNGVSdXVLSjRVUzF6dDV3NWFvdHhVdWMwMW4x?=
 =?utf-8?B?M25TT1BjZlhJdzNtdG9NSzR4TnZvNTV1QkUyaTZ4RmY4WXVSakl5MWRKWjVx?=
 =?utf-8?B?dFNXYlVNNTBIajJ0OW4wZzRjM3dmSzMvMnhKOW82SFFzZFBsanVWY3NwN0ph?=
 =?utf-8?B?UXZPRFNWWkh0Tk1rV25vWVQwRWhUU1ppYkF2NFVHWndFdnk2Q3BsQW02Y0k2?=
 =?utf-8?B?d0llRHY0V1lhS2x3TnRVYnJONTBqMEpvUVB3VXdybSt3OHZqR1FYRUpwYTBG?=
 =?utf-8?B?bC9paFVFbnJZRU1RU1A2NW1HVGpxNmRKTTJMNlA2VEJ2L09BcStlWlM3NVo1?=
 =?utf-8?B?a25SQ09Oak5pbEtFNEdBcDUzV29hdDRGKzI2VEtZTWo5ZEllYSt3TkJEZUZU?=
 =?utf-8?B?bm5NeWVCWW9NL3lxdUdsN3FKY0ZmTUxrWFNJa2k3cFlKSU44R1g2cmpTa05p?=
 =?utf-8?B?bWoxS0pLa2JZK1VDT2k5UTZ6bGVuWldiWi9pZzdDdWhDNHNtaTlwM00yZlhU?=
 =?utf-8?B?TUFzRVA1d1JsKzBNWTJla3RmTW5nKzhiMHNmM29LMzFxeWJSNGZ1M1ZxeUVC?=
 =?utf-8?B?eTFBVW5uc0dIMVRmRng1anZEWnZ2bG1sZEQzcEJMWEtQQ2VKOE9mRU91Sy9J?=
 =?utf-8?B?ZGFEYzh2LzRkRjhCVmlOczVybXh4WThUS3Z5UkcvK08zVTV1dEZ4RVdFcXVO?=
 =?utf-8?B?ZEMydDF4bmY0bDRFd3VIaVJWMllkbVhTOVdUM3ZZZnZnTzA4cUk3VmYyUW85?=
 =?utf-8?B?M2lZZ081aEFUT3hQWjFzWFdHS251U3dDWnBkbVlUcmpCSHc1M0JGcDRGeW55?=
 =?utf-8?B?aHRTV25WbFBadVhyekhmWmpFaVp3V0c0cFlmdC9jblhsazNhdGk3aDdUOXpn?=
 =?utf-8?B?RkxxNzZwbGFMakRjTTRIM1E4Vkk5NnhEOEtPUCtLc2dNdEoyQ01rRXlobUpu?=
 =?utf-8?B?ZFZ1c2wzUnRpYmRySHFhUHNwVThYY0trcHR5djYyRkNEVVBBU05tMHRrd0N3?=
 =?utf-8?B?ZlFKbVJlMG5FT0JkNjZNVkltRmErcE11ZUJjNlJnUFFpaExMK0dYY2hLejVN?=
 =?utf-8?B?dGV6RjMrbzFCYWFIT01iOWNSWC8zSHdhOGd0YVoweGVlc2RRM2QyZyt0YTRM?=
 =?utf-8?B?Um9FZkFlL1FZTTltZDcxaVZvNUpSMkwyTGlLRS9vYjVpZjJlcEdlaldXZGI4?=
 =?utf-8?B?VXQreGVLRzdkeUJiQThXam45bVh4bm9NTFlVWUtBR2J4MzFPVlhybFcrd3hv?=
 =?utf-8?B?ZTFsb292SW1LU3djTFN2bGJJT1NDS2RBL28zb3F4cXV2ZUxXTlZyUk11T1h3?=
 =?utf-8?B?RGlxNGo1R0lXbWR1b3NyeWlOM3QzQUNYWUh0dUZpcjR6K2UxbjJaTXY5R09D?=
 =?utf-8?Q?0OoOwghO/Eld3bEhf+GHW89/x/6nZ0ukVxM2Zl+?=
X-OriginatorOrg: nextfour.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7210fa75-a6b0-46a6-3600-08d93f8cd2de
X-MS-Exchange-CrossTenant-AuthSource: DBAPR03MB6630.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2021 08:13:51.8183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 972e95c2-9290-4a02-8705-4014700ea294
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qKPwQdywSD6F7AEN6yZ+/7cS8V2uyqvrek1PNsGvEk/rLGJ/0C8zmN5B8lSOJI0Xcz3RM2dHmP0NkAo9hd0dqytvsd0Nx5IvHuQe2EC0jSU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4684
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

On 5.7.2021 10.49, Paul Blakey wrote:
> When multiple SKBs are merged to a new skb under napi GRO,
> or SKB is re-used by napi, if nfct was set for them in the
> driver, it will not be released while freeing their stolen
> head state or on re-use.
>
> Release nfct on napi's stolen or re-used SKBs, and
> in gro_list_prepare, check conntrack metadata diff.
>
> Fixes: 5c6b94604744 ("net/mlx5e: CT: Handle misses after executing CT action")
> Reviewed-by: Roi Dayan <roid@nvidia.com>
> Signed-off-by: Paul Blakey <paulb@nvidia.com>
> ---
> Changelog:
> 	v1->v2:
> 	 Check for different flows based on CT and chain metadata in gro_list_prepare
>
>   net/core/dev.c    | 13 +++++++++++++
>   net/core/skbuff.c |  1 +
>   2 files changed, 14 insertions(+)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 439faadab0c2..bf62cb2ec6da 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -5981,6 +5981,18 @@ static void gro_list_prepare(const struct list_head *head,
>   			diffs = memcmp(skb_mac_header(p),
>   				       skb_mac_header(skb),
>   				       maclen);
> +
> +		diffs |= skb_get_nfct(p) ^ skb_get_nfct(skb);
> +
> +		if (!diffs) {
> +			struct tc_skb_ext *skb_ext = skb_ext_find(skb, TC_SKB_EXT);
> +			struct tc_skb_ext *p_ext = skb_ext_find(p, TC_SKB_EXT);
> +
> +			diffs |= (!!p_ext) ^ (!!skb_ext);
> +			if (!diffs && unlikely(skb_ext))
> +				diffs |= p_ext->chain ^ skb_ext->chain;
> +		}
> +
>   		NAPI_GRO_CB(p)->same_flow = !diffs;
>   	}
>   }
> @@ -6243,6 +6255,7 @@ static void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
>   	skb_shinfo(skb)->gso_type = 0;
>   	skb->truesize = SKB_TRUESIZE(skb_end_offset(skb));
>   	skb_ext_reset(skb);
> +	nf_reset_ct(skb);
>   
>   	napi->skb = skb;
>   }
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index bbc3b4b62032..239eb2fba255 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -939,6 +939,7 @@ void __kfree_skb_defer(struct sk_buff *skb)
>   
>   void napi_skb_free_stolen_head(struct sk_buff *skb)
>   {
> +	nf_conntrack_put(skb_nfct(skb));

Should this be  nf_reset_ct() to clear the skb->_nfct and not leave a 
uncounted reference?

>   	skb_dst_drop(skb);
>   	skb_ext_put(skb);
>   	napi_skb_cache_put(skb);

