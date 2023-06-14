Return-Path: <netdev+bounces-10720-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E247A72FF3C
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:59:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 206481C20CDB
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 12:59:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E03C8F62;
	Wed, 14 Jun 2023 12:59:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15576FBB
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 12:59:00 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B4713E
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 05:58:58 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.57])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Qh57y35gKzTkrR;
	Wed, 14 Jun 2023 20:58:22 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 14 Jun
 2023 20:58:53 +0800
Subject: Re: [PATCH net-next] gro: move the tc_ext comparison to a helper
To: Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
	<richardbgobert@gmail.com>
References: <20230613205105.1996166-1-kuba@kernel.org>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <81d765b3-8545-8791-4d1e-3b0f0dba39c0@huawei.com>
Date: Wed, 14 Jun 2023 20:58:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230613205105.1996166-1-kuba@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/6/14 4:51, Jakub Kicinski wrote:
> The double ifdefs are quite aesthetically displeasing.
> Use a helper function to make the code more compact.
> The resulting machine code looks the same (with minor
> movement of some basic blocks).
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: richardbgobert@gmail.com
> ---
>  net/core/gro.c | 31 ++++++++++++++++++-------------
>  1 file changed, 18 insertions(+), 13 deletions(-)
> 
> diff --git a/net/core/gro.c b/net/core/gro.c
> index ab9a447dfba7..90889e1f3f9a 100644
> --- a/net/core/gro.c
> +++ b/net/core/gro.c
> @@ -305,6 +305,23 @@ void napi_gro_flush(struct napi_struct *napi, bool flush_old)
>  }
>  EXPORT_SYMBOL(napi_gro_flush);
>  
> +static void gro_list_prepare_tc_ext(const struct sk_buff *skb,
> +				    const struct sk_buff *p,
> +				    unsigned long *diffs)

Isn't it more common to do something like below?

static unsigned long gro_list_prepare_tc_ext(const struct sk_buff *skb,
					     const struct sk_buff *p,
					     unsigned long diffs)

Is it because the resulting machine code is bigger for the above
case?

> +{
> +#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
> +	struct tc_skb_ext *skb_ext;
> +	struct tc_skb_ext *p_ext;
> +
> +	skb_ext = skb_ext_find(skb, TC_SKB_EXT);
> +	p_ext = skb_ext_find(p, TC_SKB_EXT);
> +
> +	*diffs |= (!!p_ext) ^ (!!skb_ext);
> +	if (!*diffs && unlikely(skb_ext))
> +		*diffs |= p_ext->chain ^ skb_ext->chain;
> +#endif
> +}
> +
>  static void gro_list_prepare(const struct list_head *head,
>  			     const struct sk_buff *skb)
>  {
> @@ -339,23 +356,11 @@ static void gro_list_prepare(const struct list_head *head,
>  		 * avoid trying too hard to skip each of them individually
>  		 */
>  		if (!diffs && unlikely(skb->slow_gro | p->slow_gro)) {
> -#if IS_ENABLED(CONFIG_SKB_EXTENSIONS) && IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
> -			struct tc_skb_ext *skb_ext;
> -			struct tc_skb_ext *p_ext;
> -#endif
> -
>  			diffs |= p->sk != skb->sk;
>  			diffs |= skb_metadata_dst_cmp(p, skb);
>  			diffs |= skb_get_nfct(p) ^ skb_get_nfct(skb);
>  
> -#if IS_ENABLED(CONFIG_SKB_EXTENSIONS) && IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
> -			skb_ext = skb_ext_find(skb, TC_SKB_EXT);
> -			p_ext = skb_ext_find(p, TC_SKB_EXT);
> -
> -			diffs |= (!!p_ext) ^ (!!skb_ext);
> -			if (!diffs && unlikely(skb_ext))
> -				diffs |= p_ext->chain ^ skb_ext->chain;
> -#endif
> +			gro_list_prepare_tc_ext(skb, p, &diffs);
>  		}
>  
>  		NAPI_GRO_CB(p)->same_flow = !diffs;
> 

