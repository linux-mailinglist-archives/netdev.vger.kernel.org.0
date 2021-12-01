Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAA4465676
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 20:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234646AbhLATbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 14:31:07 -0500
Received: from smtp8.emailarray.com ([65.39.216.67]:56423 "EHLO
        smtp8.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352757AbhLATbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 14:31:04 -0500
Received: (qmail 95186 invoked by uid 89); 1 Dec 2021 19:20:45 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNw==) (POLARISLOCAL)  
  by smtp8.emailarray.com with SMTP; 1 Dec 2021 19:20:45 -0000
Date:   Wed, 1 Dec 2021 11:20:43 -0800
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC 05/12] net: optimise page get/free for bvec zc
Message-ID: <20211201192043.tqed7rtwibnwhw7c@bsd-mbp.dhcp.thefacebook.com>
References: <cover.1638282789.git.asml.silence@gmail.com>
 <72608c13553a1372e7f6f7a32eb53d5d4b23a1fc.1638282789.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72608c13553a1372e7f6f7a32eb53d5d4b23a1fc.1638282789.git.asml.silence@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 03:18:53PM +0000, Pavel Begunkov wrote:
> get_page() in __zerocopy_sg_from_bvec() and matching put_page()s are
> expensive. However, we can avoid it if the caller can guarantee that
> pages stay alive until the corresponding ubuf_info is not released.
> In particular, it targets io_uring with fixed buffers following the
> described contract.
> 
> Assuming that nobody yet uses bvec together with zerocopy, make all
> calls with bvec iterators follow this model.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/linux/skbuff.h | 10 +++++++++-
>  net/core/datagram.c    |  9 +++++++--
>  net/core/skbuff.c      | 16 +++++++++++++---
>  net/ipv4/ip_output.c   |  4 ++++
>  4 files changed, 33 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 750b7518d6e2..ebb12a7d386d 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -461,6 +461,11 @@ enum {
>  	SKBFL_PURE_ZEROCOPY = BIT(2),
>  
>  	SKBFL_DONT_ORPHAN = BIT(3),
> +
> +	/* page references are managed by the ubuf_info, so it's safe to
> +	 * use frags only up until ubuf_info is released
> +	 */
> +	SKBFL_MANAGED_FRAGS = BIT(4),
>  };
>  
>  #define SKBFL_ZEROCOPY_FRAG	(SKBFL_ZEROCOPY_ENABLE | SKBFL_SHARED_FRAG)
> @@ -3154,7 +3159,10 @@ static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
>   */
>  static inline void skb_frag_unref(struct sk_buff *skb, int f)
>  {
> -	__skb_frag_unref(&skb_shinfo(skb)->frags[f], skb->pp_recycle);
> +	struct skb_shared_info *shinfo = skb_shinfo(skb);
> +
> +	if (!(shinfo->flags & SKBFL_MANAGED_FRAGS))
> +		__skb_frag_unref(&shinfo->frags[f], skb->pp_recycle);
>  }
>  
>  /**
> diff --git a/net/core/datagram.c b/net/core/datagram.c
> index e00f7e0a7a0a..5cf0672039d6 100644
> --- a/net/core/datagram.c
> +++ b/net/core/datagram.c
> @@ -642,7 +642,6 @@ static int __zerocopy_sg_from_bvec(struct sock *sk, struct sk_buff *skb,
>  		v = mp_bvec_iter_bvec(from->bvec, bi);
>  		copied += v.bv_len;
>  		truesize += PAGE_ALIGN(v.bv_len + v.bv_offset);
> -		get_page(v.bv_page);
>  		skb_fill_page_desc(skb, frag++, v.bv_page, v.bv_offset, v.bv_len);
>  		bvec_iter_advance_single(from->bvec, &bi, v.bv_len);
>  	}
> @@ -671,9 +670,15 @@ int __zerocopy_sg_from_iter(struct sock *sk, struct sk_buff *skb,
>  			    struct iov_iter *from, size_t length)
>  {
>  	int frag = skb_shinfo(skb)->nr_frags;
> +	bool managed = skb_shinfo(skb)->flags & SKBFL_MANAGED_FRAGS;
>  
> -	if (iov_iter_is_bvec(from))
> +	if (iov_iter_is_bvec(from) && (managed || frag == 0)) {
> +		skb_shinfo(skb)->flags |= SKBFL_MANAGED_FRAGS;
>  		return __zerocopy_sg_from_bvec(sk, skb, from, length);
> +	}
> +
> +	if (managed)
> +		return -EFAULT;
>  
>  	while (length && iov_iter_count(from)) {
>  		struct page *pages[MAX_SKB_FRAGS];
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index b23db60ea6f9..b7b087815539 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -666,10 +666,14 @@ static void skb_release_data(struct sk_buff *skb)
>  			      &shinfo->dataref))
>  		goto exit;
>  
> -	skb_zcopy_clear(skb, true);
> +	if (!(shinfo->flags & SKBFL_MANAGED_FRAGS)) {
> +		for (i = 0; i < shinfo->nr_frags; i++)
> +			__skb_frag_unref(&shinfo->frags[i], skb->pp_recycle);
> +	} else {
> +		shinfo->flags &= ~SKBFL_MANAGED_FRAGS;
> +	}
>  
> -	for (i = 0; i < shinfo->nr_frags; i++)
> -		__skb_frag_unref(&shinfo->frags[i], skb->pp_recycle);
> +	skb_zcopy_clear(skb, true);

It would be better if all of this logic was moved into the callback
under zcopy_clear.  Note that this path is called for both TX and RX.
-- 
Jonathan
