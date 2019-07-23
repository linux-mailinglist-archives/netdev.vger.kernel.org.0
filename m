Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BACD71045
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 05:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfGWD4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 23:56:46 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2698 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726305AbfGWD4q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jul 2019 23:56:46 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C4D2455982A6076BA519;
        Tue, 23 Jul 2019 11:56:43 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Tue, 23 Jul 2019
 11:56:41 +0800
Subject: Re: [PATCH v3 2/7] net: Use skb accessors in network core
To:     Matthew Wilcox <willy@infradead.org>, <davem@davemloft.net>
CC:     <hch@lst.de>, <netdev@vger.kernel.org>
References: <20190723030831.11879-1-willy@infradead.org>
 <20190723030831.11879-3-willy@infradead.org>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <aa40f270-9f55-323a-2e94-5bd326a7a142@huawei.com>
Date:   Tue, 23 Jul 2019 11:56:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20190723030831.11879-3-willy@infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/7/23 11:08, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> In preparation for unifying the skb_frag and bio_vec, use the fine
> accessors which already exist and use skb_frag_t instead of
> struct skb_frag_struct.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/linux/skbuff.h |  2 +-
>  net/core/skbuff.c      | 24 ++++++++++++++----------
>  net/core/tso.c         |  8 ++++----
>  net/ipv4/tcp.c         | 14 ++++++++------
>  net/kcm/kcmsock.c      |  8 ++++----
>  net/tls/tls_device.c   | 14 +++++++-------
>  6 files changed, 38 insertions(+), 32 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index d8af86d995d6..f9078e7edb53 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -3166,7 +3166,7 @@ static inline bool skb_can_coalesce(struct sk_buff *skb, int i,
>  	if (skb_zcopy(skb))
>  		return false;
>  	if (i) {
> -		const struct skb_frag_struct *frag = &skb_shinfo(skb)->frags[i - 1];
> +		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i - 1];
>  
>  		return page == skb_frag_page(frag) &&
>  		       off == frag->page_offset + skb_frag_size(frag);
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 6f1e31f674a3..e32081709a0d 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -2485,19 +2485,19 @@ int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
>  	for (fragidx = 0; fragidx < skb_shinfo(skb)->nr_frags; fragidx++) {
>  		skb_frag_t *frag  = &skb_shinfo(skb)->frags[fragidx];
>  
> -		if (offset < frag->size)
> +		if (offset < skb_frag_size(frag))
>  			break;
>  
> -		offset -= frag->size;
> +		offset -= skb_frag_size(frag);
>  	}
>  
>  	for (; len && fragidx < skb_shinfo(skb)->nr_frags; fragidx++) {
>  		skb_frag_t *frag  = &skb_shinfo(skb)->frags[fragidx];
>  
> -		slen = min_t(size_t, len, frag->size - offset);
> +		slen = min_t(size_t, len, skb_frag_size(frag) - offset);
>  
>  		while (slen) {
> -			ret = kernel_sendpage_locked(sk, frag->page.p,
> +			ret = kernel_sendpage_locked(sk, skb_frag_page(frag),
>  						     frag->page_offset + offset,
>  						     slen, MSG_DONTWAIT);
>  			if (ret <= 0)
> @@ -2975,11 +2975,15 @@ skb_zerocopy(struct sk_buff *to, struct sk_buff *from, int len, int hlen)
>  	skb_zerocopy_clone(to, from, GFP_ATOMIC);
>  
>  	for (i = 0; i < skb_shinfo(from)->nr_frags; i++) {
> +		int size;
> +
>  		if (!len)
>  			break;
>  		skb_shinfo(to)->frags[j] = skb_shinfo(from)->frags[i];
> -		skb_shinfo(to)->frags[j].size = min_t(int, skb_shinfo(to)->frags[j].size, len);
> -		len -= skb_shinfo(to)->frags[j].size;
> +		size = min_t(int, skb_frag_size(&skb_shinfo(to)->frags[j]),
> +					len);

It seems skb_frag_size returns unsigned int here, maybe:

unsigned int size;

size = min_t(unsigned int, skb_frag_size(&skb_shinfo(to)->frags[j]),

The original code also do not seem to using the correct min_t, but
perhaps it is better to clean that up too?


> +		skb_frag_size_set(&skb_shinfo(to)->frags[j], size);
> +		len -= size;
>  		skb_frag_ref(to, j);
>  		j++;
>  	}
> @@ -3293,7 +3297,7 @@ static int skb_prepare_for_shift(struct sk_buff *skb)
>  int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
>  {
>  	int from, to, merge, todo;
> -	struct skb_frag_struct *fragfrom, *fragto;
> +	skb_frag_t *fragfrom, *fragto;
>  
>  	BUG_ON(shiftlen > skb->len);
>  
> @@ -3625,10 +3629,10 @@ static inline skb_frag_t skb_head_frag_to_page_desc(struct sk_buff *frag_skb)
>  	struct page *page;
>  
>  	page = virt_to_head_page(frag_skb->head);
> -	head_frag.page.p = page;
> +	__skb_frag_set_page(&head_frag, page);
>  	head_frag.page_offset = frag_skb->data -
>  		(unsigned char *)page_address(page);
> -	head_frag.size = skb_headlen(frag_skb);
> +	skb_frag_size_set(&head_frag, skb_headlen(frag_skb));
>  	return head_frag;
>  }
>  
> @@ -4021,7 +4025,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
>  
>  		pinfo->nr_frags = nr_frags + 1 + skbinfo->nr_frags;
>  
> -		frag->page.p	  = page;
> +		__skb_frag_set_page(frag, page);
>  		frag->page_offset = first_offset;
>  		skb_frag_size_set(frag, first_size);
>  
> diff --git a/net/core/tso.c b/net/core/tso.c
> index 43f4eba61933..d4d5c077ad72 100644
> --- a/net/core/tso.c
> +++ b/net/core/tso.c
> @@ -55,8 +55,8 @@ void tso_build_data(struct sk_buff *skb, struct tso_t *tso, int size)
>  		skb_frag_t *frag = &skb_shinfo(skb)->frags[tso->next_frag_idx];
>  
>  		/* Move to next segment */
> -		tso->size = frag->size;
> -		tso->data = page_address(frag->page.p) + frag->page_offset;
> +		tso->size = skb_frag_size(frag);
> +		tso->data = skb_frag_address(frag);
>  		tso->next_frag_idx++;
>  	}
>  }
> @@ -79,8 +79,8 @@ void tso_start(struct sk_buff *skb, struct tso_t *tso)
>  		skb_frag_t *frag = &skb_shinfo(skb)->frags[tso->next_frag_idx];
>  
>  		/* Move to next segment */
> -		tso->size = frag->size;
> -		tso->data = page_address(frag->page.p) + frag->page_offset;
> +		tso->size = skb_frag_size(frag);
> +		tso->data = skb_frag_address(frag);
>  		tso->next_frag_idx++;
>  	}
>  }
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 7846afacdf0b..bb14c7c72f3c 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -1776,19 +1776,21 @@ static int tcp_zerocopy_receive(struct sock *sk,
>  				break;
>  			frags = skb_shinfo(skb)->frags;
>  			while (offset) {
> -				if (frags->size > offset)
> +				if (skb_frag_size(frags) > offset)
>  					goto out;
> -				offset -= frags->size;
> +				offset -= skb_frag_size(frags);
>  				frags++;
>  			}
>  		}
> -		if (frags->size != PAGE_SIZE || frags->page_offset) {
> +		if (skb_frag_size(frags) != PAGE_SIZE || frags->page_offset) {
>  			int remaining = zc->recv_skip_hint;
> +			int size = skb_frag_size(frags);
>  
> -			while (remaining && (frags->size != PAGE_SIZE ||
> +			while (remaining && (size != PAGE_SIZE ||
>  					     frags->page_offset)) {
> -				remaining -= frags->size;
> +				remaining -= size;
>  				frags++;
> +				size = skb_frag_size(frags);
>  			}
>  			zc->recv_skip_hint -= remaining;
>  			break;
> @@ -3779,7 +3781,7 @@ int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *hp,
>  		return 1;
>  
>  	for (i = 0; i < shi->nr_frags; ++i) {
> -		const struct skb_frag_struct *f = &shi->frags[i];
> +		const skb_frag_t *f = &shi->frags[i];
>  		unsigned int offset = f->page_offset;
>  		struct page *page = skb_frag_page(f) + (offset >> PAGE_SHIFT);
>  
> diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
> index 5dbc0c48f8cb..05f63c4300e9 100644
> --- a/net/kcm/kcmsock.c
> +++ b/net/kcm/kcmsock.c
> @@ -635,15 +635,15 @@ static int kcm_write_msgs(struct kcm_sock *kcm)
>  			frag_offset = 0;
>  do_frag:
>  			frag = &skb_shinfo(skb)->frags[fragidx];
> -			if (WARN_ON(!frag->size)) {
> +			if (WARN_ON(!skb_frag_size(frag))) {
>  				ret = -EINVAL;
>  				goto out;
>  			}
>  
>  			ret = kernel_sendpage(psock->sk->sk_socket,
> -					      frag->page.p,
> +					      skb_frag_page(frag),
>  					      frag->page_offset + frag_offset,
> -					      frag->size - frag_offset,
> +					      skb_frag_size(frag) - frag_offset,
>  					      MSG_DONTWAIT);
>  			if (ret <= 0) {
>  				if (ret == -EAGAIN) {
> @@ -678,7 +678,7 @@ static int kcm_write_msgs(struct kcm_sock *kcm)
>  			sent += ret;
>  			frag_offset += ret;
>  			KCM_STATS_ADD(psock->stats.tx_bytes, ret);
> -			if (frag_offset < frag->size) {
> +			if (frag_offset < skb_frag_size(frag)) {
>  				/* Not finished with this frag */
>  				goto do_frag;
>  			}
> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> index 7c0b2b778703..4ec8a06fa5d1 100644
> --- a/net/tls/tls_device.c
> +++ b/net/tls/tls_device.c
> @@ -243,14 +243,14 @@ static void tls_append_frag(struct tls_record_info *record,
>  	skb_frag_t *frag;
>  
>  	frag = &record->frags[record->num_frags - 1];
> -	if (frag->page.p == pfrag->page &&
> -	    frag->page_offset + frag->size == pfrag->offset) {
> -		frag->size += size;
> +	if (skb_frag_page(frag) == pfrag->page &&
> +	    frag->page_offset + skb_frag_size(frag) == pfrag->offset) {
> +		skb_frag_size_add(frag, size);
>  	} else {
>  		++frag;
> -		frag->page.p = pfrag->page;
> +		__skb_frag_set_page(frag, pfrag->page);
>  		frag->page_offset = pfrag->offset;
> -		frag->size = size;
> +		skb_frag_size_set(frag, size);
>  		++record->num_frags;
>  		get_page(pfrag->page);
>  	}
> @@ -301,8 +301,8 @@ static int tls_push_record(struct sock *sk,
>  		frag = &record->frags[i];
>  		sg_unmark_end(&offload_ctx->sg_tx_data[i]);
>  		sg_set_page(&offload_ctx->sg_tx_data[i], skb_frag_page(frag),
> -			    frag->size, frag->page_offset);
> -		sk_mem_charge(sk, frag->size);
> +			    skb_frag_size(frag), frag->page_offset);
> +		sk_mem_charge(sk, skb_frag_size(frag));
>  		get_page(skb_frag_page(frag));
>  	}
>  	sg_mark_end(&offload_ctx->sg_tx_data[record->num_frags - 1]);
> 

