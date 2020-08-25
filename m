Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACED251753
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 13:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729911AbgHYLTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 07:19:55 -0400
Received: from mga06.intel.com ([134.134.136.31]:47915 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729873AbgHYLTt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 07:19:49 -0400
IronPort-SDR: lArIx57CuZJkLTqYmW6SV1bQuBisTgvUCMMjVed3pvc60LpUQbPtQpP2S0SsK4P88mhXGAnDJ6
 i7AFl4vggKfg==
X-IronPort-AV: E=McAfee;i="6000,8403,9723"; a="217637824"
X-IronPort-AV: E=Sophos;i="5.76,352,1592895600"; 
   d="scan'208";a="217637824"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2020 04:19:45 -0700
IronPort-SDR: hl3u8cl7uonhVfGcM9X+cchEn2K1GdSLpiX3AbBcM9vl72QDiLmk1WnCUlciRPe8J3O5qo5Aa1
 I6jYs7bmpoCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,352,1592895600"; 
   d="scan'208";a="322722010"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga004.fm.intel.com with ESMTP; 25 Aug 2020 04:19:42 -0700
Date:   Tue, 25 Aug 2020 13:13:36 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Cc:     jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        netdev@vger.kernel.org, piotr.raczynski@intel.com,
        maciej.machnikowski@intel.com, lirongqing@baidu.com
Subject: Re: [PATCH net 1/3] i40e: avoid premature Rx buffer reuse
Message-ID: <20200825111336.GA38865@ranger.igk.intel.com>
References: <20200825091629.12949-1-bjorn.topel@gmail.com>
 <20200825091629.12949-2-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200825091629.12949-2-bjorn.topel@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 11:16:27AM +0200, Bj�rn T�pel wrote:
> From: Bj�rn T�pel <bjorn.topel@intel.com>
> 
> The page recycle code, incorrectly, relied on that a page fragment
> could not be freed inside xdp_do_redirect(). This assumption leads to
> that page fragments that are used by the stack/XDP redirect can be
> reused and overwritten.
> 
> To avoid this, store the page count prior invoking xdp_do_redirect().
> 
> Longer explanation:
> 
> Intel NICs have a recycle mechanism. The main idea is that a page is
> split into two parts. One part is owned by the driver, one part might
> be owned by someone else, such as the stack.
> 
> t0: Page is allocated, and put on the Rx ring
>               +---------------
> used by NIC ->| upper buffer
> (rx_buffer)   +---------------
>               | lower buffer
>               +---------------
>   page count  == USHRT_MAX
>   rx_buffer->pagecnt_bias == USHRT_MAX
> 
> t1: Buffer is received, and passed to the stack (e.g.)
>               +---------------
>               | upper buff (skb)
>               +---------------
> used by NIC ->| lower buffer
> (rx_buffer)   +---------------
>   page count  == USHRT_MAX
>   rx_buffer->pagecnt_bias == USHRT_MAX - 1
> 
> t2: Buffer is received, and redirected
>               +---------------
>               | upper buff (skb)
>               +---------------
> used by NIC ->| lower buffer
> (rx_buffer)   +---------------
> 
> Now, prior calling xdp_do_redirect():
>   page count  == USHRT_MAX
>   rx_buffer->pagecnt_bias == USHRT_MAX - 2
> 
> This means that buffer *cannot* be flipped/reused, because the skb is
> still using it.
> 
> The problem arises when xdp_do_redirect() actually frees the
> segment. Then we get:
>   page count  == USHRT_MAX - 1
>   rx_buffer->pagecnt_bias == USHRT_MAX - 2
> 
> From a recycle perspective, the buffer can be flipped and reused,
> which means that the skb data area is passed to the Rx HW ring!
> 
> To work around this, the page count is stored prior calling
> xdp_do_redirect().
> 
> Note that this is not optimal, since the NIC could actually reuse the
> "lower buffer" again. However, then we need to track whether
> XDP_REDIRECT consumed the buffer or not.
> 
> Fixes: d9314c474d4f ("i40e: add support for XDP_REDIRECT")
> Reported-by: Li RongQing <lirongqing@baidu.com>
> Signed-off-by: Bj�rn T�pel <bjorn.topel@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c | 28 +++++++++++++++------
>  1 file changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> index 3e5c566ceb01..5e446dc39190 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> @@ -1873,7 +1873,8 @@ static inline bool i40e_page_is_reusable(struct page *page)
>   *
>   * In either case, if the page is reusable its refcount is increased.
>   **/
> -static bool i40e_can_reuse_rx_page(struct i40e_rx_buffer *rx_buffer)
> +static bool i40e_can_reuse_rx_page(struct i40e_rx_buffer *rx_buffer,
> +				   int rx_buffer_pgcnt)
>  {
>  	unsigned int pagecnt_bias = rx_buffer->pagecnt_bias;
>  	struct page *page = rx_buffer->page;
> @@ -1884,7 +1885,7 @@ static bool i40e_can_reuse_rx_page(struct i40e_rx_buffer *rx_buffer)
>  
>  #if (PAGE_SIZE < 8192)
>  	/* if we are only owner of page we can reuse it */
> -	if (unlikely((page_count(page) - pagecnt_bias) > 1))
> +	if (unlikely((rx_buffer_pgcnt - pagecnt_bias) > 1))
>  		return false;
>  #else
>  #define I40E_LAST_OFFSET \
> @@ -1939,6 +1940,15 @@ static void i40e_add_rx_frag(struct i40e_ring *rx_ring,
>  #endif
>  }
>  
> +static int i40e_rx_buffer_page_count(struct i40e_rx_buffer *rx_buffer)
> +{
> +#if (PAGE_SIZE < 8192)
> +	return page_count(rx_buffer->page);
> +#else
> +	return 0;
> +#endif
> +}
> +
>  /**
>   * i40e_get_rx_buffer - Fetch Rx buffer and synchronize data for use
>   * @rx_ring: rx descriptor ring to transact packets on
> @@ -1948,11 +1958,13 @@ static void i40e_add_rx_frag(struct i40e_ring *rx_ring,
>   * for use by the CPU.
>   */
>  static struct i40e_rx_buffer *i40e_get_rx_buffer(struct i40e_ring *rx_ring,
> -						 const unsigned int size)
> +						 const unsigned int size,
> +						 int *rx_buffer_pgcnt)
>  {
>  	struct i40e_rx_buffer *rx_buffer;
>  
>  	rx_buffer = i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
> +	*rx_buffer_pgcnt = i40e_rx_buffer_page_count(rx_buffer);

What i previously meant was:

#if (PAGE_SIZE < 8192)
	*rx_buffer_pgcnt = page_count(rx_buffer->page);
#endif

and see below

>  	prefetchw(rx_buffer->page);
>  
>  	/* we are reusing so sync this buffer for CPU use */
> @@ -2112,9 +2124,10 @@ static struct sk_buff *i40e_build_skb(struct i40e_ring *rx_ring,
>   * either recycle the buffer or unmap it and free the associated resources.
>   */
>  static void i40e_put_rx_buffer(struct i40e_ring *rx_ring,
> -			       struct i40e_rx_buffer *rx_buffer)
> +			       struct i40e_rx_buffer *rx_buffer,
> +			       int rx_buffer_pgcnt)
>  {
> -	if (i40e_can_reuse_rx_page(rx_buffer)) {
> +	if (i40e_can_reuse_rx_page(rx_buffer, rx_buffer_pgcnt)) {
>  		/* hand second half of page back to the ring */
>  		i40e_reuse_rx_page(rx_ring, rx_buffer);
>  	} else {
> @@ -2319,6 +2332,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
>  	unsigned int xdp_xmit = 0;
>  	bool failure = false;
>  	struct xdp_buff xdp;
> +	int rx_buffer_pgcnt;

you could move scope this variable only for the

while (likely(total_rx_packets < (unsigned int)budget))

loop and init this to 0. then you could drop the helper function you've
added. and BTW the page_count is not being used for big pages but i agree
that it's better to have it set to 0.

>  
>  #if (PAGE_SIZE < 8192)
>  	xdp.frame_sz = i40e_rx_frame_truesize(rx_ring, 0);
> @@ -2370,7 +2384,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
>  			break;
>  
>  		i40e_trace(clean_rx_irq, rx_ring, rx_desc, skb);
> -		rx_buffer = i40e_get_rx_buffer(rx_ring, size);
> +		rx_buffer = i40e_get_rx_buffer(rx_ring, size, &rx_buffer_pgcnt);
>  
>  		/* retrieve a buffer from the ring */
>  		if (!skb) {
> @@ -2413,7 +2427,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
>  			break;
>  		}
>  
> -		i40e_put_rx_buffer(rx_ring, rx_buffer);
> +		i40e_put_rx_buffer(rx_ring, rx_buffer, rx_buffer_pgcnt);
>  		cleaned_count++;
>  
>  		if (i40e_is_non_eop(rx_ring, rx_desc, skb))
> -- 
> 2.25.1
> 
