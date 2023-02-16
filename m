Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8727698E08
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 08:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjBPHtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 02:49:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBPHtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 02:49:40 -0500
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0091141B5F;
        Wed, 15 Feb 2023 23:49:37 -0800 (PST)
Received: from [192.168.0.2] (ip5f5aeab7.dynamic.kabel-deutschland.de [95.90.234.183])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 4182960027FD7;
        Thu, 16 Feb 2023 08:49:35 +0100 (CET)
Message-ID: <10c0dcb4-f353-41a8-dfff-e99d2dca7fb2@molgen.mpg.de>
Date:   Thu, 16 Feb 2023 08:49:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [Intel-wired-lan] [PATCH intel-next v4 4/8] i40e: Change size to
 truesize when using i40e_rx_buffer_flip()
To:     Tirthendu Sarkar <tirthendu.sarkar@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        bpf@vger.kernel.org, magnus.karlsson@intel.com
References: <20230215124305.76075-1-tirthendu.sarkar@intel.com>
 <20230215124305.76075-5-tirthendu.sarkar@intel.com>
Content-Language: en-US
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230215124305.76075-5-tirthendu.sarkar@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Tirthendu,


Thank you for your patch.

Am 15.02.23 um 13:43 schrieb Tirthendu Sarkar:
> Truesize is now passed directly to i40e_rx_buffer_flip() instead of size
> so that it does not need to recalculate truesize from size using
> i40e_rx_frame_truesize() before adjusting page offset.

Did the compiler not optimize that well enough?

> With these change the function can now be used during skb building and
> adding frags. In later patches it will also be easier for adjusting
> page offsets for multi-buffers.

Why couldn’t the function be used before?

> Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
> ---
>   drivers/net/ethernet/intel/i40e/i40e_txrx.c | 54 ++++++++-------------
>   1 file changed, 19 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> index a7fba294a8f4..019abd7273a2 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> @@ -2018,6 +2018,21 @@ static bool i40e_can_reuse_rx_page(struct i40e_rx_buffer *rx_buffer,
>   	return true;
>   }
>   
> +/**
> + * i40e_rx_buffer_flip - adjusted rx_buffer to point to an unused region
> + * @rx_buffer: Rx buffer to adjust
> + * @size: Size of adjustment
> + **/
> +static void i40e_rx_buffer_flip(struct i40e_rx_buffer *rx_buffer,
> +				unsigned int truesize)
> +{
> +#if (PAGE_SIZE < 8192)
> +	rx_buffer->page_offset ^= truesize;
> +#else
> +	rx_buffer->page_offset += truesize;
> +#endif

It’d be great if you sent a patch on top, doing the check not in the 
preprocessor but in native C code.

> +}
> +
>   /**
>    * i40e_add_rx_frag - Add contents of Rx buffer to sk_buff
>    * @rx_ring: rx descriptor ring to transact packets on
> @@ -2045,11 +2060,7 @@ static void i40e_add_rx_frag(struct i40e_ring *rx_ring,
>   			rx_buffer->page_offset, size, truesize);
>   
>   	/* page is being used so we must update the page offset */
> -#if (PAGE_SIZE < 8192)
> -	rx_buffer->page_offset ^= truesize;
> -#else
> -	rx_buffer->page_offset += truesize;
> -#endif
> +	i40e_rx_buffer_flip(rx_buffer, truesize);
>   }
>   
>   /**
> @@ -2154,11 +2165,7 @@ static struct sk_buff *i40e_construct_skb(struct i40e_ring *rx_ring,
>   				size, truesize);
>   
>   		/* buffer is used by skb, update page_offset */
> -#if (PAGE_SIZE < 8192)
> -		rx_buffer->page_offset ^= truesize;
> -#else
> -		rx_buffer->page_offset += truesize;
> -#endif
> +		i40e_rx_buffer_flip(rx_buffer, truesize);
>   	} else {
>   		/* buffer is unused, reset bias back to rx_buffer */
>   		rx_buffer->pagecnt_bias++;
> @@ -2209,11 +2216,7 @@ static struct sk_buff *i40e_build_skb(struct i40e_ring *rx_ring,
>   		skb_metadata_set(skb, metasize);
>   
>   	/* buffer is used by skb, update page_offset */
> -#if (PAGE_SIZE < 8192)
> -	rx_buffer->page_offset ^= truesize;
> -#else
> -	rx_buffer->page_offset += truesize;
> -#endif
> +	i40e_rx_buffer_flip(rx_buffer, truesize);
>   
>   	return skb;
>   }
> @@ -2326,25 +2329,6 @@ static int i40e_run_xdp(struct i40e_ring *rx_ring, struct xdp_buff *xdp, struct
>   	return result;
>   }
>   
> -/**
> - * i40e_rx_buffer_flip - adjusted rx_buffer to point to an unused region
> - * @rx_ring: Rx ring
> - * @rx_buffer: Rx buffer to adjust
> - * @size: Size of adjustment
> - **/
> -static void i40e_rx_buffer_flip(struct i40e_ring *rx_ring,
> -				struct i40e_rx_buffer *rx_buffer,
> -				unsigned int size)
> -{
> -	unsigned int truesize = i40e_rx_frame_truesize(rx_ring, size);
> -
> -#if (PAGE_SIZE < 8192)
> -	rx_buffer->page_offset ^= truesize;
> -#else
> -	rx_buffer->page_offset += truesize;
> -#endif
> -}
> -
>   /**
>    * i40e_xdp_ring_update_tail - Updates the XDP Tx ring tail register
>    * @xdp_ring: XDP Tx ring
> @@ -2513,7 +2497,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
>   		if (xdp_res) {
>   			if (xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR)) {
>   				xdp_xmit |= xdp_res;
> -				i40e_rx_buffer_flip(rx_ring, rx_buffer, size);
> +				i40e_rx_buffer_flip(rx_buffer, xdp.frame_sz);

Why is `xdp.frame_sz` the correct size now?

>   			} else {
>   				rx_buffer->pagecnt_bias++;
>   			}


Kind regards,

Paul
