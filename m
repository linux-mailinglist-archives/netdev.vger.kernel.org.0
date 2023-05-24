Return-Path: <netdev+bounces-4996-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6F7E70F65F
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:28:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ADA511C20D92
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:28:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9258182BD;
	Wed, 24 May 2023 12:24:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ACAD182A0
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:24:22 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F3A99;
	Wed, 24 May 2023 05:24:20 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.57])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QR9Jx5wfyzLpvk;
	Wed, 24 May 2023 20:21:21 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 24 May
 2023 20:24:17 +0800
Subject: Re: [PATCH net-next v10 03/16] net: Add a function to splice pages
 into an skbuff for MSG_SPLICE_PAGES
To: David Howells <dhowells@redhat.com>, <netdev@vger.kernel.org>
CC: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>, Matthew Wilcox <willy@infradead.org>, Al
 Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, Jens
 Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>, Christian Brauner
	<brauner@kernel.org>, Chuck Lever III <chuck.lever@oracle.com>, Linus
 Torvalds <torvalds@linux-foundation.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
References: <20230522121125.2595254-1-dhowells@redhat.com>
 <20230522121125.2595254-4-dhowells@redhat.com>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <82041a42-e7b0-bde3-0f70-8ad180565794@huawei.com>
Date: Wed, 24 May 2023 20:24:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230522121125.2595254-4-dhowells@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/5/22 20:11, David Howells wrote:

Hi, David

I am not very familiar with the 'struct iov_iter' yet, just two
questions below.

> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 7f53dcb26ad3..f4a5b51aed22 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -6892,3 +6892,91 @@ nodefer:	__kfree_skb(skb);
>  	if (unlikely(kick) && !cmpxchg(&sd->defer_ipi_scheduled, 0, 1))
>  		smp_call_function_single_async(cpu, &sd->defer_csd);
>  }
> +
> +static void skb_splice_csum_page(struct sk_buff *skb, struct page *page,
> +				 size_t offset, size_t len)
> +{
> +	const char *kaddr;
> +	__wsum csum;
> +
> +	kaddr = kmap_local_page(page);
> +	csum = csum_partial(kaddr + offset, len, 0);
> +	kunmap_local(kaddr);
> +	skb->csum = csum_block_add(skb->csum, csum, skb->len);
> +}
> +
> +/**
> + * skb_splice_from_iter - Splice (or copy) pages to skbuff
> + * @skb: The buffer to add pages to
> + * @iter: Iterator representing the pages to be added
> + * @maxsize: Maximum amount of pages to be added
> + * @gfp: Allocation flags
> + *
> + * This is a common helper function for supporting MSG_SPLICE_PAGES.  It
> + * extracts pages from an iterator and adds them to the socket buffer if
> + * possible, copying them to fragments if not possible (such as if they're slab
> + * pages).
> + *
> + * Returns the amount of data spliced/copied or -EMSGSIZE if there's

I am not seeing any copying done directly in the skb_splice_from_iter(),
maybe iov_iter_extract_pages() has done copying for it?

> + * insufficient space in the buffer to transfer anything.
> + */
> +ssize_t skb_splice_from_iter(struct sk_buff *skb, struct iov_iter *iter,
> +			     ssize_t maxsize, gfp_t gfp)
> +{
> +	size_t frag_limit = READ_ONCE(sysctl_max_skb_frags);
> +	struct page *pages[8], **ppages = pages;
> +	ssize_t spliced = 0, ret = 0;
> +	unsigned int i;
> +
> +	while (iter->count > 0) {
> +		ssize_t space, nr;
> +		size_t off, len;
> +
> +		ret = -EMSGSIZE;
> +		space = frag_limit - skb_shinfo(skb)->nr_frags;
> +		if (space < 0)
> +			break;
> +
> +		/* We might be able to coalesce without increasing nr_frags */
> +		nr = clamp_t(size_t, space, 1, ARRAY_SIZE(pages));
> +
> +		len = iov_iter_extract_pages(iter, &ppages, maxsize, nr, 0, &off);
> +		if (len <= 0) {
> +			ret = len ?: -EIO;
> +			break;
> +		}
> +
> +		i = 0;
> +		do {
> +			struct page *page = pages[i++];
> +			size_t part = min_t(size_t, PAGE_SIZE - off, len);
> +
> +			ret = -EIO;
> +			if (WARN_ON_ONCE(!sendpage_ok(page)))
> +				goto out;
> +
> +			ret = skb_append_pagefrags(skb, page, off, part,
> +						   frag_limit);
> +			if (ret < 0) {
> +				iov_iter_revert(iter, len);

I am not sure I understand the error handling here, doesn't 'len'
indicate the remaining size of the data to be appended to skb, maybe
we should revert the size of data that is already appended to skb here?
Does 'spliced' need to be adjusted accordingly?

> +				goto out;
> +			}
> +
> +			if (skb->ip_summed == CHECKSUM_NONE)
> +				skb_splice_csum_page(skb, page, off, part);
> +
> +			off = 0;
> +			spliced += part;
> +			maxsize -= part;
> +			len -= part;
> +		} while (len > 0);
> +
> +		if (maxsize <= 0)
> +			break;
> +	}
> +
> +out:
> +	skb_len_add(skb, spliced);
> +	return spliced ?: ret;
> +}
> +EXPORT_SYMBOL(skb_splice_from_iter);
> 
> 
> .
> 

