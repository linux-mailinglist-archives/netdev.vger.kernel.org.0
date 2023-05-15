Return-Path: <netdev+bounces-2483-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E71D702319
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 06:59:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 340DA281090
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 04:59:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41B681C20;
	Mon, 15 May 2023 04:59:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366E810E6
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 04:59:33 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6588193;
	Sun, 14 May 2023 21:59:31 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.57])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QKRsv1WJHzLq1k;
	Mon, 15 May 2023 12:56:35 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Mon, 15 May
 2023 12:59:27 +0800
Subject: Re: [PATCH net-next] net: skbuff: update commemt about pfmemalloc
 propagating
To: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Pavel Begunkov
	<asml.silence@gmail.com>
References: <20230515045500.46225-1-linyunsheng@huawei.com>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <88cf34f5-7bdf-7ea6-f162-9302820a54ce@huawei.com>
Date: Mon, 15 May 2023 12:59:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230515045500.46225-1-linyunsheng@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

commemt should be comment in the title, please ignore this
patch.

On 2023/5/15 12:55, Yunsheng Lin wrote:
> __skb_fill_page_desc_noacc() is not doing any pfmemalloc
> propagating, and yet it has a comment about that, commit
> 84ce071e38a6 ("net: introduce __skb_fill_page_desc_noacc")
> may have accidentally move to __skb_fill_page_desc_noacc(),
> so move it back to __skb_fill_page_desc() which is supposed
> to be doing pfmemalloc propagating.
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> CC: Pavel Begunkov <asml.silence@gmail.com>
> ---
> Also maybe we need a better name for 'noacc' or add some
> comment about that, as 'noacc' seems a little confusing
> for __skb_fill_page_desc_noacc().
> ---
>  include/linux/skbuff.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 00e8c435fa1a..4b8d55247198 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -2426,11 +2426,6 @@ static inline void __skb_fill_page_desc_noacc(struct skb_shared_info *shinfo,
>  {
>  	skb_frag_t *frag = &shinfo->frags[i];
>  
> -	/*
> -	 * Propagate page pfmemalloc to the skb if we can. The problem is
> -	 * that not all callers have unique ownership of the page but rely
> -	 * on page_is_pfmemalloc doing the right thing(tm).
> -	 */
>  	skb_frag_fill_page_desc(frag, page, off, size);
>  }
>  
> @@ -2463,6 +2458,11 @@ static inline void __skb_fill_page_desc(struct sk_buff *skb, int i,
>  					struct page *page, int off, int size)
>  {
>  	__skb_fill_page_desc_noacc(skb_shinfo(skb), i, page, off, size);
> +
> +	/* Propagate page pfmemalloc to the skb if we can. The problem is
> +	 * that not all callers have unique ownership of the page but rely
> +	 * on page_is_pfmemalloc doing the right thing(tm).
> +	 */
>  	page = compound_head(page);
>  	if (page_is_pfmemalloc(page))
>  		skb->pfmemalloc	= true;
> 

